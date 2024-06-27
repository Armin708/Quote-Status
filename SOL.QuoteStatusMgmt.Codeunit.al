codeunit 50120 "Quote Status Mgmt"
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
        CloseQuotePage: Page "Close Quote";
    begin

        if NOT (SalesQuote."Won/Lost Quote Status" in [SalesQuote."Won/Lost Quote Status"::Won, SalesQuote."Won/Lost Quote Status"::Lost]) then begin
            CloseQuotePage.SetTableView(SalesQuote);
            CloseQuotePage.RunModal()
        end;


    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'Archive Document', false, false)]
    local procedure OnBeforeArchiveQuote()
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrder()
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quotes", 'OnBeforeActionEvent', 'MakeOrder', false, false)]
    local procedure OnBeforeMakeOrders()
    begin

    end;

}
