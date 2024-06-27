codeunit 50120 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(SalesQuote: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin

        // In the CloseQuote procedure you need to write code to archive a Sales Quote.
        SalesSetup.Get();
        case SalesSetup."Archive Quotes" of
            SalesSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesQuote);
            SalesSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchiveSalesDocument(SalesQuote);
        end;

    end;

    local procedure CheckIfWonLost(SalesQuote: Record "Sales Header")
    var
        CloseQuotePage: Page "SOL Close Quote";
        Error001Err: Label 'Quote cannot be closed, wrong Status';
    begin

        if SalesQuote."Won/Lost Quote Status" <> SalesQuote."Won/Lost Quote Status"::"In Progress" then
            exit;

        CloseQuotePage.SetTableView(SalesQuote);
        if CloseQuotePage.RunModal() <> Action::LookupOK then
            Error(Error001Err);

    end;

    procedure GetSalesPersonForUser(): Code[20]
    var
        SalesPerson: Record "Salesperson/Purchaser";
        User: Record User;
    begin

        clear(User);
        if not User.Get(UserSecurityId()) then
            exit;

        Clear(SalesPerson);
        SalesPerson.SetRange("E-Mail", User."Contact Email");
        if SalesPerson.FindFirst() then
            exit(SalesPerson.Code);

    end;

    procedure OpenQuotes(Notif: Notification)
    var
        SalesHeader: Record "Sales Header";
        WonLostStatusInteger: Integer;

    begin

        Evaluate(WonLostStatusInteger, Notif.GetData('WonlostStatus'));

        clear(SalesHeader);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetRange("Salesperson Code", Notif.GetData('SalespersonCode'));
        SalesHeader.SetRange("Won/Lost Quote Status", "SOL Won/Lost Quote Status".FromInteger(WonLostStatusInteger));
        if SalesHeader.FindFirst() then
            Page.Run(Page::"Sales Quotes", SalesHeader);

    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'Archive Document', false, false)]
    local procedure OnBeforeArchiveQuote(var Rec: Record "Sales Header")
    begin
        CheckIfWonLost(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrder(var Rec: Record "Sales Header")
    begin
        CheckIfWonLost(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quotes", 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrders(var Rec: Record "Sales Header")
    begin
        CheckIfWonLost(Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeSalesHeaderArchiveInsert', '', false, false)]
    local procedure OnBeforeStoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    begin

        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote then
            exit;

        SalesHeaderArchive.Validate("Won/Lost Date", SalesHeader."Won/Lost Date");
        SalesHeaderArchive.Validate("Won/Lost Quote Status", SalesHeader."Won/Lost Quote Status");
        SalesHeaderArchive.Validate("Won/Lost Reason Code", SalesHeader."Won/Lost Reason Code");
        SalesHeaderArchive.Validate("Won/Lost Remarks", SalesHeader."Won/Lost Remarks");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Conf./Personalization Mgt.", 'OnRoleCenterOpen', '', false, false)]
    local procedure OnRoleCenterOpen()
    var
        SalesHeader: Record "Sales Header";
        MyNotificationWon: Notification;
        MyNotificationLost: Notification;
        SalesPersonCode: Code[20];
        LostCounter: Integer;
        WonCounter: Integer;
        WonMsg: Label 'You won %1 quote(s) during the last 5 days';
        LostMsg: Label 'You lost %1 quote(s) during the last 5 days';
        ShowQuotes: Label 'Show %1 quotes';


    begin

        SalesPersonCode := GetSalesPersonForUser();

        if SalesPersonCode = '' then
            exit;

        clear(SalesHeader);
        SalesHeader.SetRange("Won/Lost Date", CreateDateTime(Today - 5, 0T), CurrentDateTime);
        SalesHeader.SetRange("Salesperson Code", SalesPersonCode);
        SalesHeader.SetRange("Won/Lost Quote Status", SalesHeader."Won/Lost Quote Status"::Won);
        WonCounter := SalesHeader.Count;

        SalesHeader.SetRange("Won/Lost Quote Status", SalesHeader."Won/Lost Quote Status"::Lost);
        LostCounter := SalesHeader.Count;

        if WonCounter > 0 then begin

            MyNotificationWon.Message(StrSubstNo(WonMsg, WonCounter));
            MyNotificationWon.SetData('SalespersonCode', SalesPersonCode);
            MyNotificationWon.SetData('WonlostStatus', Format(SalesHeader."Won/Lost Quote Status"::Won.AsInteger()));
            MyNotificationWon.AddAction(StrSubstNo(ShowQuotes, SalesHeader."Won/Lost Quote Status"::Won), Codeunit::"SOL Quote Status Mgmt", 'OpenQuotes');
            MyNotificationWon.Send();

        end;


        if LostCounter > 0 then begin

            MyNotificationLost.Message(StrSubstNo(LostMsg, LostCounter));
            MyNotificationWon.SetData('SalespersonCode', SalesPersonCode);
            MyNotificationWon.SetData('WonlostStatus', Format(SalesHeader."Won/Lost Quote Status"::Lost.AsInteger()));
            MyNotificationWon.AddAction(StrSubstNo(ShowQuotes, SalesHeader."Won/Lost Quote Status"::Lost), Codeunit::"SOL Quote Status Mgmt", 'OpenQuotes');
            MyNotificationLost.Send();

        end;

    end;





}
