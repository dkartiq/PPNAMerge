/// <summary>
/// Table NSPP1_Punch List Code (ID 14021131).
/// </summary>
table 14021131 "NS_Punch List Code"
{
    //PE-288.JS.1.0 06MAY2024 | Created new Table
    Caption = 'Punch List Code';
    DrillDownPageId = "NS_Punch List Codes";
    LookupPageId = "NS_Punch List Codes";
    Permissions = tabledata "NS_Punch List Code" = RIMD;

    fields
    {
        field(1; "NS_Document Type"; Enum NS_PunchListDocType)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
            Editable = false;
        }
        field(2; "NS_Punch List Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Punch List Code';
            trigger OnValidate()
            var
                myInt: Integer;
            begin

            end;

        }
        field(3; "NS_Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "NS_Punch List Code", "NS_Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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

}