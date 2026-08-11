tableextension 14021226 NS_HumanResourceSetup extends "Human Resources Setup"
{
    // version NAVW111.00.00.25466,PPNA11.00
    //PRJ-384.AS.1.0 11SEPT2020 Removed inverted commas from "Payroll Week Ending Day" field
    //PRJ-772.AS.1.0 12July2021 Added field
    //PRJ-772.JS.1.0 26July2021 Added field
    //PRJ-1281.RM.1.0 08April2022 | Added field
    //PRJ-1649.RP.1.0 07Dec2022 | Added two fields
    //PE-19.RM.1.0 31Jan2023 | Added some fields
    //PE-68.Dk.1.0 5june2023 | Added some code
    fields
    {
        field(14021100; "NS_Advanced Job Labor isActive"; Boolean)
        {
            Caption = '3rd Party Payroll is Active';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                //PE-68.Dk.1.0 5june2023 Start
                if "NS_Advanced Job Labor isActive" then begin
                    "NS_Activate Skill Class" := true;
                    if not xRec."NS_Advanced Job Labor isActive" then
                        TESTFIELD("NS_Hours worked beforeOTbegins");
                end;
                //PE-68.Dk.1.0 5june2023 End
                //ProjectPro - end
            end;
        }
        field(14021101; "NS_Overtime Calculation Basis"; Option)
        {
            Caption = 'Overtime Calculation Basis';
            Description = 'ProjectPro';
            OptionCaption = 'Week,Day';
            OptionMembers = Week,Day;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Overtime Calculation Basis" <> xRec."NS_Overtime Calculation Basis" then
                    "NS_Hours worked beforeOTbegins" := 0;
                //ProjectPro - end
            end;
        }
        field(14021102; "NS_Hours worked beforeOTbegins"; Decimal)
        {
            Caption = 'Hours worked before OT begins';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Hours worked beforeOTbegins" < 0 then
                    ERROR(Text14021100, FIELDCAPTION("NS_Hours worked beforeOTbegins"));
                if "NS_Overtime Calculation Basis" = "NS_Overtime Calculation Basis"::Day then
                    if "NS_Hours worked beforeOTbegins" > 16 then
                        ERROR(Text14021101, FIELDCAPTION("NS_Hours worked beforeOTbegins"));
                //ProjectPro - end
            end;
        }
        field(14021103; "NS_Default Payroll Batch No."; Code[20])
        {
            Caption = 'Default Payroll Batch No.';
            Description = 'ProjectPro';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('GENERAL'));
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Earning Code Identifier"; Code[10])
        {
            Caption = 'Earning Code Identifier';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Deduction Code Identifier"; Code[10])
        {
            Caption = 'Deduction Code Identifier';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Payroll Export File Name"; Text[120])
        {
            Caption = 'Payroll Export File Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Payroll RegImportXMLPortNo"; Integer)
        {
            Caption = 'Payroll Reg. Import XMLPort No';
            Description = 'ProjectPro';
            TableRelation = AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(XMLport));
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_WH 347 XLS Template"; BLOB)
        {
            Caption = 'WH 347 XLS Template';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Payroll Week Ending Day"; Option)
        {
            Caption = 'Payroll Week Ending Day';
            Description = 'ProjectPro';
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';//PRJ-384.AS.1.0 11SEPT2020
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_WH 347 Signatory Party"; Text[100])
        {
            Caption = 'WH 347 Signatory Party';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_WH 347 Title"; Text[100])
        {
            Caption = 'WH 347 Title';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_WH 347 Contractor Name"; Text[100])
        {
            Caption = 'WH 347 Contractor Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021113; "NS_WH 347 Address 1"; Text[100])
        {
            Caption = 'WH 347 Address 1';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021114; "NS_WH 347 Address 2"; Text[100])
        {
            Caption = 'WH 347 Address 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Custom Timesheet No. Series"; Code[10])  //PRJ-772.AS.1.0 12July2021
        {
            Caption = 'Custom Timesheet No. Series';
            Description = 'Specifies Custom Timesheet No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_TimeSheetCrewWorkDays"; integer)  //PRJ-772.AS.1.0 12July2021
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if NS_TimeSheetCrewWorkDays > 7 then
                    Error('The Time Sheet Work Days cannot be greater than 7');

                if NS_TimeSheetCrewWorkDays < 1 then
                    Error('The Time Sheet Work Days cannot be less than 1');

            end;
        }
        field(14021117; "NS_CustomTimesheetCrewWorkingHrs"; Decimal)  //PRJ-772.AS.1.0 12July2021
        {
            Caption = 'Time Sheet Work Hours';
            Description = 'Specifies Time Sheet Work Hours';
            DataClassification = CustomerContent;
        }
        field(14021118; "NS_Timesheet Unique Line Nos."; Code[10])  //PRJ-772.JS.1.0 12July2021
        {
            Caption = 'Timesheet Unique Line Nos.';
            Description = 'Specifies Time Sheet unique line Id';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        //PRJ-1281.RM.1.0 08April2022 start
        field(14021119; "NS_Activate Skill Class"; Boolean)
        {
            Caption = 'Activate Skill Class Code';
            DataClassification = CustomerContent;
            Description = 'Skill Class Code';
            //PE-68.Dk.1.0 5june2023 Start
            trigger OnValidate()
            begin
                if "NS_Advanced Job Labor isActive" then begin
                    Message('Please first disable "Advanced Job Labor is Active" field if you want to disable "Activate Skill Class Code"');
                    "NS_Activate Skill Class" := true;
                end;
            end;
            //PE-68.Dk.1.0 5june2023 End
        }
        //PRJ-1281.RM.1.0 08April2022 end
        field(14021120; "NS_OBD No."; Code[20]) //PRJ-1649.RP.1.0 07Dec2022 Start
        {
            Caption = 'OBD No.';
            DataClassification = CustomerContent;
        }

        field(14021121; "NS_Expires Date"; Date)
        {
            Caption = 'Expires';
            DataClassification = CustomerContent;
        }
        //PRJ-1649.RP.1.0 07Dec2022 End
        //PE-19.RM.1.0 31Jan2023 start
        field(14021122; "NS_Picture"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture';
            SubType = Bitmap;

            trigger OnValidate()
            begin
                PictureUpdated := true;
            end;
        }
        field(14021123; "NS_Picture -Last Mod. DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Picture - Last Mod. Date Time';
            Editable = false;
        }
        field(14021124; "NS_Last Modified DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(14021125; "NS_Company ID"; Text[4])
        {
            Caption = 'Company ID';
            DataClassification = CustomerContent;
        }
        //PE-19.RM.1.0 31Jan2023 End

        //PE-158.AS.1.0 04SEPT2023 START
        field(14021126; "NS_EnableResourceSkillClass"; Boolean)
        {
            Caption = 'Enable Use Only Resource Default Skill Class';
            DataClassification = CustomerContent;
            Description = 'Enable Use Only Resource Default Skill Class';
        }
        //PE-158.AS.1.0 04SEPT2023 END

    }

    var
        PictureUpdated: Boolean; //PE-19.RM.1.0 31Jan2023
        Text14021100: Label 'The %1 cannot be less than zero.';
        Text14021101: Label 'The %1 cannot be more than 16.';
    //PE-19.RM.1.0 31Jan2023 start
    trigger OnAfterInsert()
    begin

        "NS_Last Modified DateTime" := CurrentDateTime;
        if PictureUpdated then
            "NS_Picture -Last Mod. DateTime" := "NS_Last Modified DateTime";
    end;

    trigger OnAfterModify()
    begin
        "NS_Last Modified DateTime" := CurrentDateTime;
        if PictureUpdated then
            "NS_Picture -Last Mod. DateTime" := "NS_Last Modified DateTime";
    end;
    //PE-19.RM.1.0 31Jan2023 End
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Advanced Job Labor is Active
//   +     14021101 Overtime Calculation Basis
//   +     14021102 Hours worked before OT begins
//   +     14021103 Default Payroll Batch No.
//   +     14021104 Earning Code Identifier
//   +     14021105 Deduction Code Identifier
//   +     14021106 Payroll Export File Name
//   +     14021107 Payroll Reg. Import XMLPort No
//   +     14021108 WH 347 XLS Template
//   +     14021109 Payroll Week Ending Day
//   +     14021110 WH 347 Signatory Party
//   +     14021111 WH 347 Title
//   +     14021112 WH 347 Contractor Name
//   +     14021113 WH 347 Address 1
//   +     14021114 WH 347 Address 2
//   +
//   +  - Added global text constant(s):
//   +     Text14021100
//   +     Text14021101
//   +
//   +-----------------------------------------------------------------------------------------------