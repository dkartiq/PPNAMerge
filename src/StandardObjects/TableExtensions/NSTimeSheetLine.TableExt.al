tableextension 14021211 NS_TimeSheetLine extends "Time Sheet Line"
{
    // version NAVW111.00.00.23019,PPNA11.00
    //PRJ-841.JS.1.0 19Aug2021 | Field added
    //PRJ-842.JS.1.0 19Aug2021 | Field added   
    //PRJ-1074.AS.1.0 28DEC2021 : Done code to transfer values of field "NS_Resource Name" to field "NS_Resource Name New", as we are obseleting old field in NS_TimeSheetLine Table
    //PRJ-1144.JS.1.0 31JAN2022 | Add one fields
    //PRJ-1281.RM.1.0 18April2022 | Changed field caption
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
    fields
    {
        field(14021100; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Total Posted Quantity"; Decimal)
        {
            CalcFormula = Sum("Time Sheet Detail"."Posted Quantity" WHERE("Time Sheet No." = FIELD("Time Sheet No."),
                                                                           "Time Sheet Line No." = FIELD("Line No.")));
            Caption = 'Total Posted Quantity';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021102; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
            //PE-68 Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68 Dk.1.0 10April2023 End
        }
        //PE-68 Dk.1.0 10April2023 Start
        field(14021112; "NS_Skill Class New"; Code[20])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
        }
        //PE-68 Dk.1.0 10April2023 End
        field(14021103; NS_Correction; Boolean)
        {
            Caption = 'Correction';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Ref Customize TimesheetNo."; Code[20])    //PRJ-772.AS.2.0 12July2021 Add field
        {
            Caption = 'Ref Customize TimesheetNo.';
            Description = 'Specifies Ref Customize TimesheetNo.';
            DataClassification = CustomerContent;
        }

        //PRJ-772.AS.2.0 New req. Additional - start
        field(14021105; "NS_Working Hours"; Integer)
        {
            Caption = 'Working Hours';
            Description = '';
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Crew code"; code[20])
        {
            Caption = 'Crew code';
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Lead Person"; code[20])
        {
            Caption = 'Lead crew';
            Description = 'Specifies Lead crew';
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Working Date"; Date)
        {
            Caption = 'Working Date';
            Description = 'Specifies Working Date';
            DataClassification = CustomerContent;
        }
        field(14021109; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'Specifies Status';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Submitted';
            OptionMembers = Open,Submitted;
        }
        field(14021110; "NS_Resource Name"; Code[20])
        {
            ObsoleteState = Pending;//PRJ-1074.AS.1.0 28DEC2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-1074.AS.1.0 28DEC2021 Obselete

            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        //PRJ-772.AS.2.0 New req. end

        field(14021111; "NS_Resource Name New"; Text[100])//PRJ-1074.AS.1.0 28DEC2021 Add New field
        {
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }

        field(14021131; "NS_CrewTimeSheetLine"; Boolean)//PRJ-772.2.0
        {
            Caption = 'Crew TimeSheet Line';
            Description = 'Crew TimeSheet Line';
            DataClassification = CustomerContent;
        }

        field(14021132; "NS_Crew Time Unique Line ID"; Code[20])
        {
            Caption = 'Crew Time Unique Line ID';
            Description = 'Specifies Crew time unique line ID';
            DataClassification = CustomerContent;
            Editable = false;
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
        field(14021135; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type';
            TableRelation = "Work Type";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Crew Time Sheet Date"; Date)
        {
            Caption = 'Crew Time Sheet Date';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021139; "NS_Skill Code"; Code[10])   //PRJ-841.JS.1.0 19Aug2021-Start
        {
            Caption = 'Skill Class Code'; //PRJ-1281.RM.1.0
            Editable = false;
            DataClassification = CustomerContent;
            //PE-68 Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68 Dk.1.0 10April2023 End
        }
        //PE-68.Dk.1.0 10April2023 Start
        field(14021113; "NS_Skill Code New"; Code[20])
        {
            Caption = 'Skill Class';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PE-68 Dk.1.0 10April2023 End
        field(14021140; "NS_Segment Code"; Code[20])   //PRJ-842.JS.1.0 19Aug2021-Start
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            Editable = false;
            DataClassification = CustomerContent;

        }

        modify(Description)  //PRJ-842.JS.1.0 19Aug2021-Start
        {
            Caption = 'Work Description';
        }

        //PRJ-1144.JS.1.0 31JAN2022 - start
        field(14021141; "NS_Rejected Remark"; Text[100])
        {
            Caption = 'Rejected Remark';
            DataClassification = CustomerContent;

        }

        field(14021142; "NS_Crew Time Sheet Line No."; Integer)
        {
            Caption = 'Crew Time Sheet Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-1144.JS.1.0 31JAN2022 - end
        //PRJ-1452.GK.1.0 13June2022 start
        field(14021143; "NS_Time Sheet Owner User ID"; Code[50])
        {
            Caption = 'Time Sheet Owner User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        //PRJ-1452.GK.1.0 13June2022 end
        //PRJCTPR-2.RM.1.0 13Dec2022 start
        field(14021144; "NS_Union Code"; Code[10])
        {
            Caption = 'Union Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJCTPR-2.RM.1.0 13Dec2022 end

    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Resource No.
//   +     14021101 Total Posted Quantity
//   +     14021102 Skill Class
//   +     14021103 Correction
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - OnInsert: Resource No. assignment
//   +
//   +-----------------------------------------------------------------------------------------------