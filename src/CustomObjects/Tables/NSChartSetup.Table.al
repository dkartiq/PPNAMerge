
/// <summary>
/// Table NS_Job_Chart Setup (ID 14021291).
/// </summary>
/// PE-115.JS.1.0 03July2023 New Table
table 14021291 "NS_Job_Chart Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Job Chart Setup';

    Permissions = tabledata "NS_Job_Chart Setup" = RIMD;

    fields
    {
        field(1; "NS_User ID"; code[150])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
        }
        field(2; "NS_Chart Type"; Enum "Business Chart Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Chart Type';
        }
        field(5; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job."No." where("NS_Job Class" = filter("Master Job"));

            trigger OnValidate()
            begin
                if "NS_Job No." <> '' then begin
                    "NS_Project Manager No." := '';
                    "NS_ChartProject Mgr. Name" := '';
                    "NS_Gen. Bus. Posting Group" := '';
                end;
            end;
        }
        field(6; "NS_Job Values"; Enum "NS Chart Job Values")
        {
            DataClassification = CustomerContent;
            Caption = 'Job Values';
        }
        field(8; "NS_Project Manager No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Manager No.';
            TableRelation = Resource."No." where(Type = filter(Person));

            trigger OnValidate()
            var
                NS_CHResource: Record Resource;
            begin
                if "NS_Project Manager No." <> '' then begin
                    if NS_CHResource.Get("NS_Project Manager No.") then
                        "NS_ChartProject Mgr. Name" := NS_CHResource.Name;
                    "NS_Job No." := '';
                    "NS_Gen. Bus. Posting Group" := '';
                end else
                    "NS_ChartProject Mgr. Name" := '';
            end;
        }
        field(9; "NS_ChartStatus"; Enum "Job Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            InitValue = Open;
        }
        field(10; "NS_Contract Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Date';
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

            trigger OnValidate()
            begin
                if "NS_Gen. Bus. Posting Group" <> '' then begin
                    "NS_Job No." := '';
                    "NS_Project Manager No." := '';
                end;
            end;
        }
        field(14; "NS_Hours Details"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Budget Vs Usage Hours Details';
        }

    }

    keys
    {
        key(Key1; "NS_User ID")
        {
            Clustered = true;
        }
    }

    var

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