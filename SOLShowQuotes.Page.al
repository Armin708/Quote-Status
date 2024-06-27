page 50121 "SOL Show Quotes"
{
    ApplicationArea = All;
    Caption = 'Show Won/Lost Quotes';
    PageType = ListPart;
    SourceTable = "Sales Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Sales Quote", Rec);
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field("Won/Lost Date"; Rec."Won/Lost Date")
                {
                    ToolTip = 'Caption';
                }
                field("Won/Lost Reason Desc"; Rec."Won/Lost Reason Desc")
                {
                    ToolTip = 'Caption';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetQuotesCurrentUser()
    end;

    local procedure GetQuotesCurrentUser()
    var
        QuoteStatsuMgmt: Codeunit "SOL Quote Status Mgmt";
        SalesPersonCode: Code[20];
    begin
        SalesPersonCode := QuoteStatsuMgmt.GetSalesPersonForUser();
        Rec.filtergroup(2);
        if SalesPersonCode <> '' then
            Rec.setrange("Salesperson Code", SalesPersonCode);
        Rec.FilterGroup(0);
    end;

}
