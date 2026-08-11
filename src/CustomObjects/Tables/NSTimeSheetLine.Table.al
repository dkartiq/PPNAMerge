table 14021317 "NS_TimeSheetLineCustom"
{
    //PRJ-772.AS.1.0 12July2021 New table
    //PRJ-841.JS.1.0 16Aug2021 | Added new fields
    //PRJ-842.JS.1.0 20Aug2021 | add new field
    //PRJ-924.JS.1.0 17Sep2021 | Add new field
    //PRJ-659.RM.1.0 06-OCT-2021  | Updated caption of Table
    Caption = 'Time Sheet Line Custom';  //PRJ-659.RM.1.0 06-OCT-2021 
    fields
    {
        field(1; "NS_TimeSheetNo."; Code[20])
        {
            Caption = 'Time Sheet No.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "NS_LineNo."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }

        field(3; NS_Description; Text[100])
        {
            Caption = 'Description';//PRJ-841.JS.1.0 Caption change
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
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(5; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Specifies Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("NS_Job No."), "Job Task Type" = Const(Posting));
            DataClassification = CustomerContent;
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(6; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'Specifies Resource No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ResourceRec: Record Resource;
            begin
                if ResourceRec.Get("NS_Resource No.") then
                    "NS_Resource Name" := ResourceRec.Name;
            end;
        }
        field(7; "NS_Resource Name"; Code[20])
        {
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
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(9; "NS_Crew code"; code[20])
        {
            Caption = 'Crew code';
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "NS_Lead Person"; code[20])
        {
            Caption = 'Lead crew';
            Description = 'Specifies Lead crew';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "NS_Working Date"; Date)
        {
            Caption = 'Working Date';
            Description = 'Specifies Working Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'Specifies Status';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Submitted,Approved,Rejected,Posted';
            OptionMembers = Open,Submitted,Approved,Rejected,Posted;
        }
        field(13; "NS_Unique Line ID"; Code[20])
        {
            Caption = 'Unique Line ID';
            Description = 'Specifies unique line ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "NS_TimeSheetCrewWorkDays"; integer)
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            MaxValue = 7;
            MinValue = 1;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type';
            TableRelation = "Work Type";
            //Editable = false;                 //PRJ-841.JS.1.0 16Aug2021
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
        }

        field(16; "NS_Skill Code"; Code[10])   //PRJ-841.JS.1.0 16Aug2021
        {
            Caption = 'Skill Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

            trigger OnLookup()
            var
                JobResourcePrice: Record "Job Resource Price";
            begin
                JobResourcePrice.Reset();
                JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                //JobResourcePrice.SetFilter("Job Task No.", '%1', "NS_Job Task No.");
                JobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                    "NS_Skill Code" := JobResourcePrice."NS_Skill Class Code";
            end;
        }

        field(17; "NS_Segment Code"; Code[20])  //PRJ-842.JS.1.0 20Aug2021
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

        }

        //PRJ-924.JS.1.0 17Sep2021-Start
        field(19; "NS_Resource Working Hours"; Decimal)
        {
            Caption = 'Working Hours';
            Description = '';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            MaxValue = 8;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

        }
        //PRJ-924.JS.1.0 17Sep2021-Start

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