table 14021386 "NS_Linked Resources"
{
    //PE-323.AT.1.0 13Jun24 | Added New Table.
    DataClassification = CustomerContent;
    Caption = 'Linked Resources';
    DrillDownPageId = "NS_Linked Resources";
    LookupPageId = "NS_Linked Resources";

    fields
    {
        field(1; "NS_Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "NS_Linked Resource"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Linked Resource';
            TableRelation = Resource."No.";
            trigger OnValidate()
            var
                Resource: record Resource;
            begin
                if "NS_Linked Resource" <> '' then begin
                    if Resource.get("NS_Linked Resource") then
                        "NS_Resource Name" := Resource.Name;
                end;
            end;
        }
        field(4; "NS_Resource Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource Name';

        }
        field(5; "NS_Labor Hr. per Qty"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Labor Hr. per Qty';
            DecimalPlaces = 0 : 5;
        }
        field(6; "NS_Default"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default';
            trigger OnValidate()
            var
            Begin
                UpdateDefault();
            End;
        }

    }

    keys
    {
        key(Key1; "NS_Item No.", "NS_Linked Resource")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UpdateDefault()
    var
        NS_LinkedResources: Record "NS_Linked Resources";
    begin
        if "NS_Default" then begin
            NS_LinkedResources.SetRange("NS_Item No.", Rec."NS_Item No.");
            NS_LinkedResources.SetRange("NS_Default", true);
            if not NS_LinkedResources.IsEmpty then
                Error(Error01);
        End
    end;

    var
        Error01: Label ' You can only assign one default linked resource.';

}