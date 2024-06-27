tableextension 50125 "SOL Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50120; "Won/Lost Quote Status"; Enum "SOL Won/Lost Quote Status")
        {
            Caption = 'Won/Lost Quote Status';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if xRec."Won/Lost Quote Status" <> Rec."Won/Lost Quote Status" then
                    Validate("Won/Lost Date", CurrentDateTime);
            end;
        }
        field(50121; "Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50122; "Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = if ("Won/Lost Quote Status" = const(Won)) "Close Opportunity Code" where(Type = const("Won"))
            else if ("Won/Lost Quote Status" = const(Lost)) "Close Opportunity Code" where(Type = const("Lost"));
            ValidateTableRelation = true;
            trigger OnValidate()
            begin
                CalcFields("Won/Lost Reason Desc");
            end;
        }
        field(50123; "Won/Lost Reason Desc"; Text[100])
        {
            Caption = 'Won/Lost Reason Desc';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("Won/Lost Reason Code")));
        }
        field(50124; "Won/Lost Remarks"; Text[2048])
        {
            Caption = 'Won/Lost Remarks';
            DataClassification = ToBeClassified;
        }
    }

}
