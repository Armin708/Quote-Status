page 50120 "Close Quote"
{
    ApplicationArea = All;
    Caption = 'Close Quote';
    PageType = Card;
    SourceTable = "Sales Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Won/Lost Date"; Rec."Won/Lost Date")
                {
                    ToolTip = 'Caption';
                }
                field("Won/Lost Quote Status"; Rec."Won/Lost Quote Status")
                {
                    ToolTip = 'Caption';
                }
                field("Won/Lost Reason Code"; Rec."Won/Lost Reason Code")
                {
                    ToolTip = 'Caption';
                }
                field("Won/Lost Reason Desc"; Rec."Won/Lost Reason Desc")
                {
                    ToolTip = 'Caption';
                }
                field("Won/Lost Remarks"; Rec."Won/Lost Remarks")
                {
                    ToolTip = 'Caption';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Editable := Rec."Won/Lost Quote Status" <> Rec."Won/Lost Quote Status"::Won;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            FinishWizard();
    end;

    local procedure FinishWizard()
    var
        Error001: label 'Won/Lost status must be set either to Won or Lost!';
        Error002: label 'Won/Lost Reason Code must be set!';

    begin

        if Rec."Won/Lost Quote Status" = Rec."Won/Lost Quote Status"::"In Progress" then
            Error(Error001);

        if Rec."Won/Lost Reason Code" = '' then
            Error(Error002);

    end;
}
