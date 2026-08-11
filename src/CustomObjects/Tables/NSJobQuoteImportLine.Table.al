table 14021405 "NS_Job Quote Import Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Install Import Line';

    fields
    {
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2801; "NS_Column 1 Value"; Text[80])
        {
            Caption = 'Column 1 Value';
            DataClassification = CustomerContent;
        }
        field(2802; "NS_Column 2 Value"; Text[80])
        {
            Caption = 'Column 2 Value';
            DataClassification = CustomerContent;
        }
        field(2803; "NS_Column 3 Value"; Text[80])
        {
            Caption = 'Column 3 Value';
            DataClassification = CustomerContent;
        }
        field(2804; "NS_Column 4 Value"; Text[80])
        {
            Caption = 'Column 4 Value';
            DataClassification = CustomerContent;
        }
        field(2805; "NS_Column 5 Value"; Text[80])
        {
            Caption = 'Column 5 Value';
            DataClassification = CustomerContent;
        }
        field(2806; "NS_Column 6 Value"; Text[80])
        {
            Caption = 'Column 6 Value';
            DataClassification = CustomerContent;
        }
        field(2807; "NS_Column 7 Value"; Text[80])
        {
            Caption = 'Column 7 Value';
            DataClassification = CustomerContent;
        }
        field(2808; "NS_Column 8 Value"; Text[80])
        {
            Caption = 'Column 8 Value';
            DataClassification = CustomerContent;
        }
        field(2809; "NS_Column 9 Value"; Text[80])
        {
            Caption = 'Column 9 Value';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = CustomerContent;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "NS_Created by" := USERID[50];
        "NS_Created at Date" := TODAY;
        "NS_Created at Time" := TIME;
    end;
}

