pageextension 50120 "SOL Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
            field(WonLostQuoteStatus; Rec."Won/Lost Quote Status")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Won/Lost Quote Status';
                ToolTip = 'Caption';
            }

            field(WonLostReasonCode; Rec."Won/Lost Reason Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Won/Lost Quote Status';
                ToolTip = 'Caption';
            }

            field(WonLostReasonDesc; Rec."Won/Lost Reason Desc")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Won/Lost Quote Status';
                ToolTip = 'Caption';
            }

            field(WWonLostRemarks; Rec."Won/Lost Remarks")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Won/Lost Quote Status';
                ToolTip = 'Caption';
            }

            field(WonLostDate; Rec."Won/Lost Date")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Won/Lost Quote Status';
                ToolTip = 'Caption';
            }

        }

    }

    actions
    {
        addfirst(Create)
        {
            action(CloseQuote)
            {
                ApplicationArea = All;
                Caption = 'Close Quote';
                ToolTip = 'Close Quote';
                Image = Close;

                trigger OnAction()
                var
                    QuoteStatusMgmt: Codeunit "SOL Quote Status Mgmt";    
                    CloseQuotePage: Page "SOL Close Quote";
                begin
                    clear(CloseQuotePage);
                    If CloseQuotePage.RunModal() = Action::OK then
                        QuoteStatusMgmt.CloseQuote(Rec);

                end;
            }
        }
    } 
}

