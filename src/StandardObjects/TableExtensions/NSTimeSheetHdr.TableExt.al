tableextension 14021423 NS_TimeSheetHdr extends "Time Sheet Header"
{
    //PRJ-772.AS.2.0 12July2021 New Table ext for Time sheet Header
    //PRJ-1074.AS.1.0 28DEC2021 : Done code to transfer values of field "NS_Resource Name" to field "NS_Resource Name New", as we are obseleting old field in "Time Sheet Header" Table

    fields
    {
        field(14021100; "NS_Ref Customize TimesheetNo."; Code[20])    //PRJ-772.AS.1.0 12July2021 Add field
        {
            Caption = 'Ref Customize TimesheetNo.';
            Description = 'Specifies Ref Customize TimesheetNo.';
            DataClassification = CustomerContent;
        }
        //PRJ-772.AS.2.0 New req. Additional - start
        field(14021101; "NS_Work Date"; Date)
        {
            Caption = 'Work Date';
            Description = '';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "NS_Work Date" := WorkDate();
            end;
        }
        field(14021102; "NS_Crew code"; code[20])
        {
            Caption = 'Crew code';
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CrewLine2: record "NS_Crew Line";
            begin
                CrewLine2.RESET();
                CrewLine2.SETRANGE(NS_Code, "NS_Crew code");
                CrewLine2.SetRange("NS_Lead Person", true);
                IF CrewLine2.FindFirst() then
                    "Resource No." := CrewLine2."NS_Resource No.";
            end;
        }
        field(14021103; "NS_Lead crew"; code[20])
        {
            Caption = 'Lead crew';
            Description = '';
            //Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Working Hours"; Decimal)
        {
            Caption = 'Working Hours';
            Description = '';
            DataClassification = CustomerContent;
        }
        //PRJ-772.AS.2.0 New req. Additional - end
        field(14021105; "NS_Description"; Text[100])
        {
            Caption = 'Description';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Job No."; code[20])
        {
            Caption = 'Job No.';
            Description = 'Specifies Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Job No. Filter" := "NS_Job No.";
            end;
        }
        field(14021117; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Specifies Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("NS_Job No."));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Job Task No. Filter" := "NS_Job Task No.";
            end;
        }
        field(14021131; "NS_CrewTimeSheetLine"; Boolean)//PRJ-772.2.0
        {
            Caption = 'Crew TimeSheet Line';
            Description = 'Crew TimeSheet Line';
            DataClassification = CustomerContent;
        }
        field(14021132; "NS_Resource Name"; Code[20])//PRJ-772.2.0
        {
            ObsoleteState = Pending;//PRJ-1074.AS.1.0 28DEC2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-1074.AS.1.0 28DEC2021 Obselete
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021133; "NS_TimeSheetCrewWorkDays"; integer)
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            MaxValue = 7;
            MinValue = 1;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021134; "NS_Crew Time Sheet Ref. No."; Code[20])
        {
            Caption = 'Crew Time Sheet Ref. No.';
            Description = 'Specifies Crew Time Sheet Ref. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021135; "NS_Resource Name New"; Text[100])//PRJ-1074.AS.1.0 28DEC2021 
        {
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
    }
}
