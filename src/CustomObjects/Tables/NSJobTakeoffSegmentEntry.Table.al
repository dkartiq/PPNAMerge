table 14021401 "NS_Job Takeoff Segment Entry"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Takeoff Segment Entry';

    fields
    {
        field(10; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;

        }
        field(25; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;

        }
        field(30; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account,Text,Resource (Group)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Resource (Group)";
            DataClassification = CustomerContent;

        }
        field(40; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

        }
        field(50; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;

        }
        field(60; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;

        }
        field(70; "NS_Segment Code"; Text[20])
        {
            Caption = 'Segment Code';
            DataClassification = CustomerContent;

        }
        field(80; "NS_Segment Quantity"; Decimal)
        {
            Caption = 'Segment Quantity';
            DataClassification = CustomerContent;

        }
        field(90; "NS_Labor Hours / Quantity"; Decimal)
        {
            Caption = 'Labor Hours / Quantity';
            DataClassification = CustomerContent;

        }
        field(100; "NS_Total Caused by Drawing"; Code[20])
        {
            Caption = 'Total Caused by Drawing';
            DataClassification = CustomerContent;

        }
        field(110; "NS_Date Entered"; DateTime)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;

        }
        field(120; NS_Certified; Boolean)
        {
            Caption = 'Certified';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", NS_Type, "NS_No.", "NS_Segment Code")
        {
            SumIndexFields = "NS_Segment Quantity";
        }
    }

    fieldgroups
    {
    }
}

