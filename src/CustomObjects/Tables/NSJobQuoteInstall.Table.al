table 14021415 "NS_Job Quote Install"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Install Jobs Setup';

    fields
    {
        field(11; NS_Type; Text[50])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(21; NS_Subtype; Text[50])
        {
            Caption = 'Subtype';
            DataClassification = CustomerContent;
        }
        field(31; "NS_G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(36; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(37; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(40; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(41; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; NS_Type, NS_Subtype)
        {
        }
    }

    fieldgroups
    {
    }
}

