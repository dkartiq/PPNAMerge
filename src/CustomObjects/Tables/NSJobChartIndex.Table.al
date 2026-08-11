/// <summary>
/// Table NS_Job Chart Index (ID 14021149).
/// </summary>
/// PE-115.JS.1.0 03July2023 New Table
table 14021149 "NS_Job Chart Index"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "NS_Chart Index No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Chart Index No.';
        }
        field(2; "NS_Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(3; "NS_Index Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Index Value';
        }
        field(4; "NS_Value Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Value Description';
        }
        field(5; "NS_Job Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(8; "NS_Project Manager No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Manager No.';
            Editable = false;
        }
        field(11; "NS_ChartProject Mgr. Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Manager Name';
            Editable = false;
        }
        field(12; "NS_Gen. Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Business Posting Group';
            TableRelation = "Gen. Business Posting Group".Code;
            Editable = false;
        }
        field(14; "NS_Hours Details"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Budget Vs Usage Hours Details';
            editable = false;
        }
        field(40; "NS_Value UOM"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Value Unit of Measure';
            editable = false;
        }

    }

    keys
    {
        key(Key1; "NS_Chart Index No.")
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

}