table 14021320 "NS_TimeSheetLineCustom Archive"
{
    //PRJ-772.JS.1.0 26July2021 New table
    //PRJ-659.RM.1.0 06-OCT-2021 | Updated Caption of Table

    Caption = 'Time Sheet Line Custom Archive'; //PRJ-659.RM.1.0 06-OCT-2021 

    fields
    {
        field(1; "NS_TimeSheetNo."; Code[20])
        {
            Caption = 'Time Sheet No.';
            NotBlank = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "NS_LineNo."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(3; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin

            end;
        }
        field(4; "NS_Job No."; code[20])
        {
            Caption = 'Job No.';
            Description = 'Specifies Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Specifies Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("NS_Job No."), "Job Task Type" = Const(Posting));
            DataClassification = CustomerContent;
        }
        field(6; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'Specifies Resource No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            var
                ResourceRec: Record Resource;
            begin
                if ResourceRec.Get("NS_Resource No.") then
                    // "NS_Resource Name" := ResourceRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                     "NS_Resource Name New" := ResourceRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
            end;
        }
        field(7; "NS_Resource Name"; Code[20])
        {
            ObsoleteState = Pending;//PRJ-1074.AS.1.0 28DEC2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-1074.AS.1.0 28DEC2021 Obselete
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(8; "NS_Working Hours"; Integer)
        {
            Caption = 'Working Hours';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(9; "NS_Crew code"; code[20])
        {
            Caption = 'Crew code';
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
        }
        field(10; "NS_Lead Person"; code[20])
        {
            Caption = 'Lead crew';
            Description = 'Specifies Lead crew';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Working Date"; Date)
        {
            Caption = 'Working Date';
            Description = 'Specifies Working Date';
            DataClassification = CustomerContent;
        }
        field(12; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'Specifies Status';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Submitted';
            OptionMembers = Open,Submitted;
        }
        field(13; "NS_Unique Line ID"; Code[20])
        {
            Caption = 'Unique Line ID';
            Description = 'Specifies unique line ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "NS_Resource Name New"; Text[100])//PRJ-1074.AS.1.0 28DEC2021
        {
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_TimeSheetNo.", "NS_LineNo.")
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