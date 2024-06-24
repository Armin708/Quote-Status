pageextension 50120 "Sales Quote Ext" extends "Sales Quote"
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
}

