pageextension 14021294 NS_HumanResourceSetup extends "Human Resources Setup"
{
    // version NAVW111.00.00.23572,NSNA11.00
    //PRJ-553.SK.1.0 17FEB2021 Commented some code that is not useful
    //PRJ-924.JS.1.0 17Sep2021 | Correct Captions
    //PRJ-1281.RM.1.0 08April2022 | Added a new field 
    //PRJ-1301.RM.1.0 13April2022 | Added a fast tab
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Human Resources Setup'; //PRJ-1330.NK.1.0 25Apr2022
    //PRJ-1403.RM.1.0 17May2022 | Modified caption
    //PRJ-1547.RM.1.0 28July2022 | Added caption
    //PRJ-1649.RP.1.0 07Dec2022 | Added two fields
    //PE-19.RM.1.0 31Jan2023 | Added some fields
    //PE-68.Dk.1.0 13june2023 | Added ToolTip
    layout
    {
        addafter(Numbering)
        {
            group(NS_CrewTimesheet)//PRJ-1301.RM.1.0
            {
                //Caption = 'Crew Timesheet';//PRJ-1301.RM.1.0   //PRJ-1403.RM.1.0 commented
                Caption = 'ProjectPro - Crew Timesheet'; //PRJ-1403.RM.1.0
                field("NS_Custom Timesheet No. Series"; Rec."NS_Custom Timesheet No. Series")//PRJ-772.AS.1.0
                {
                    ApplicationArea = All;
                    Caption = 'Crew Timesheet No. Series';   //PRJ-924.JS.1.0 17Sep2021                
                    ToolTip = 'Crew Timesheet No. Series';
                }
                field(NS_TimeSheetCrewWorkDays; Rec.NS_TimeSheetCrewWorkDays)//PRJ-772.AS.1.0 //PRJ-1135.NK.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Time Sheet Work Days';
                }
                field(NS_CustomTimesheetCrewWorkingHrs; Rec.NS_CustomTimesheetCrewWorkingHrs)//PRJ-772.AS.1.0 //PRJ-1135.NK.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Time Sheet Work Hours';
                }
                field("NS_Timesheet Unique Line Nos."; Rec."NS_Timesheet Unique Line Nos.")  //PRJ-772.JS.1.0 26July2021
                {
                    Caption = 'Crew Timesheet Line No. Series';   //PRJ-924.JS.1.0 17Sep2021                
                    ToolTip = 'Specifies the value of the Timesheet Unique Line Nos. field';
                    ApplicationArea = All;
                }
                //PRJ-1281.RM.1.0 08April2022 START
                field("NS_Activate Skill Class"; Rec."NS_Activate Skill Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Makes the “Skill Class” Mandatory on “Crew Time Sheet” for “Manager Time Sheet” approval.';  //PE-68.Dk.1.0 13june2023 
                }
                //PRJ-1281.RM.1.0 08April2022 END

                //PE-158.AS.1.0 04SEPT2023 START
                field(NS_EnableResourceSkillClass; Rec.NS_EnableResourceSkillClass)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Enable Use Only Resource Default Skill Class';
                }
                //PE-158.AS.1.0 04SEPT2023 END
            }//PRJ-1301.RM.1.0 



            group(NS_ProjectPro)
            {
                //Caption = 'ProjectPro';//PRJ-1301.RM.1.0 commented
                // Caption = 'ProjectPro - Crew Timesheet';//PRJ-1301.RM.1.0  //PRJ-1403.RM.1.0 commented
                //Caption = 'Timesheet'; //PRJ-1403.RM.1.0 //PRJ-1547.RM.1.0 commented
                Caption = 'ProjectPro - Job Payroll'; //PRJ-1547.RM.1.0
                field("NS_Adv Job Labor is Active"; Rec."NS_Advanced Job Labor isActive")
                {
                    ApplicationArea = All;
                    Caption = 'Advanced Job Labor is Active';
                    ToolTip = 'Enabling this will calculate the Labor Wage Rate defined on the “Employee” card as per the “Skill Class Code” and it will auto activate the “ Activate Skill Class Code” Boolean as True.';  //PE-68.Dk.1.0 13june2023 
                }
                field("NS_Default Payroll Batch No."; Rec."NS_Default Payroll Batch No.")
                {
                    ApplicationArea = All;
                    Caption = 'Default Payroll Batch No.';

                    ToolTip = 'Default Payroll Batch No.';
                }
                field("NS_Payroll Export File Name"; Rec."NS_Payroll Export File Name")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Export File Name';

                    ToolTip = 'Payroll Export File Name';
                }
                field("NS_Overtime Calculation Basis"; Rec."NS_Overtime Calculation Basis")
                {
                    ApplicationArea = All;
                    Caption = 'Overtime Calculation Basis';

                    ToolTip = 'Overtime Calculation Basis';
                }
                field("NS_Hrs worked before OT begins"; Rec."NS_Hours worked beforeOTbegins")
                {
                    ApplicationArea = All;
                    Caption = 'Hours worked before OT begins';

                    ToolTip = 'Hours worked before OT begins';
                }
                field("NS_Earning Code Identifier"; Rec."NS_Earning Code Identifier")
                {
                    ApplicationArea = All;
                    Caption = 'Earning Code Identifier';

                    ToolTip = 'Earning Code Identifier';
                }
                field("NS_Deduction Code Identifier"; Rec."NS_Deduction Code Identifier")
                {
                    ApplicationArea = All;
                    Caption = 'Deduction Code Identifier';

                    ToolTip = 'Deduction Code Identifier';
                }
            }
            group("NS_ProjectPro - Certified Payroll")

            {
                Visible = false;//PE-348.PS.1.0 27July2024 
                Caption = 'ProjectPro - Certified Payroll';
                field("NS_Payroll Reg. Import XMLPort No"; Rec."NS_Payroll RegImportXMLPortNo")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Reg. Import XMLPort No';

                    ToolTip = 'Payroll Reg. Import XMLPort No';
                }
                field("NS_WH 347 XLS Template"; Rec."NS_WH 347 XLS Template")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 XLS Template';
                    ToolTip = 'WH 347 XLS Template';


                    Editable = false;
                }
                field("NS_Payroll Week Ending Day"; Rec."NS_Payroll Week Ending Day")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Week Ending Day';

                    ToolTip = 'Payroll Week Ending Day';
                }
                field("NS_WH 347 Signatory Party"; Rec."NS_WH 347 Signatory Party")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 Signatory Party';

                    ToolTip = 'WH 347 Signatory Party';
                }
                field("NS_WH 347 Title"; Rec."NS_WH 347 Title")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 Title';

                    ToolTip = 'WH 347 Title';
                }
                field("NS_WH 347 Contractor Name"; Rec."NS_WH 347 Contractor Name")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 Contractor Name';

                    ToolTip = 'WH 347 Contractor Name';
                }
                field("NS_WH 347 Address 1"; Rec."NS_WH 347 Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 Address 1';

                    ToolTip = 'WH 347 Address 1';
                }
                field("NS_WH 347 Address 2"; Rec."NS_WH 347 Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'WH 347 Address 2';

                    ToolTip = 'WH 347 Address 2';
                }
                field("NS_OBD No."; Rec."NS_OBD No.") //PRJ-1649.RP.1.0 07Dec2022 Start
                {
                    ApplicationArea = All;
                    Caption = 'OBD No.';
                    ToolTip = 'OBD No.';
                }
                field("NS_Expires Date"; Rec."NS_Expires Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expires';
                    ToolTip = 'Expires';
                }
                //PRJ-1649.RP.1.0 07Dec2022 End
                //PE-19.RM.1.0 31Jan2023 start
                field("NS_Company ID"; Rec."NS_Company ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Company ID';
                }
                field(NS_Picture; Rec.NS_Picture)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the picture that has been set up for the company, such as a company logo.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                //PE-19.RM.1.0 31Jan2023 End
            }
        }
    }
    actions
    {
        addafter("Employee Statistics Groups")
        {
            // area(processing)
            // {
            // }
            group("NS_F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("NS_Import WH347 XLS Template")
            {
                ApplicationArea = All;
                Caption = 'Import WH347 XLS Template';

                ToolTip = 'Import WH347 XLS Template';
                Ellipsis = true;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    HumanResourcesSetup: Record "Human Resources Setup";
                    FileManagement: Codeunit "File Management";
                    // TempBlob: Record TempBlob temporary;//PRJ-553.SK.1.0 Commented
                    TempBlobCodeunit: Codeunit "Temp Blob";
                    PathFilename: Text[250];

                begin
                    //PathFilename := TESMPORARYPATH + PathFilename; //NSNA16.0 Blocked
                    //FileManagement.BLOBImport(TempBlob, PathFilename);//PRJ-9.SK.1.0 Commented
                    //NSNA16.0 Blocked start
                    // TempBlobCodeunit.FromRecord(Rec, Rec.FieldNo("NS_WH 347 XLS Template"));
                    // FileManagement.BLOBImport(TempBlobCodeunit, '');//PRJ-9.SK.1.0 Commented
                    // TempBlobCodeunit.ToRecordRef(Rec, Rec.FieldNo("NS_WH 347 XLS Template"));
                    // MODIFY;
                    //NSNA16.0 Blocked End
                end;
            }
            action("NS_Export WH347 XLS Template")
            {
                ApplicationArea = All;
                Caption = 'Export WH347 XLS Template';

                ToolTip = 'Export WH347 XLS Template';
                Ellipsis = true;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    HumanResourcesSetup: Record "Human Resources Setup";
                    TempBlobCodeunit: Codeunit "Temp Blob";
                    PathFilename: Text[250];
                    FileManagement: Codeunit "File Management";
                    InStreamVar: InStream;
                    OutStreamVar: OutStream;
                begin
                    PathFilename := 'd.xlsx';
                    // PathFilename := TEMPORARYPATH + PathFilename; //NSNA16.0 Blocked
                    Rec.CalcFields("NS_WH 347 XLS Template");
                    TempBlobCodeunit.FromRecord(Rec, Rec.FieldNo("NS_WH 347 XLS Template"));
                    FileManagement.BLOBExport(TempBlobCodeunit, PathFilename, true);//PRJ-9.SK.1.0 Commented
                end;
            }

        }
    }

    var
        NS_UserSetup: Record "User Setup";
    //PathFileName: Label 'ProjectPro WH-347 Template.xlsx';

    /* Documentation
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "NS Adv Job Labor is Active"
      +     "NS Default Payroll Batch No."
      +     "NS Payroll Export File Name"
      +     "NS Overtime Calculation Basis"
      +     "NS Hrs Worked before OT begins"
      +     "NS Earning Code Identifier"
      +     "NS Deduction Code Identifier"
      +     "Payroll Reg. Import XMLPort No"
      +     "WH 347 XLS Template"
      +     "Payroll Week Ending Day"
      +     "WH 347 Signatory Party"
      +     "WH 347 Title"
      +     "WH 347 Contractor Name"
      +     "WH 347 Address 1"
      +     "WH 347 Address 2"
      +
      +  - Added function(s):
      +     - Added Function to import "WH 347 XLS Template" BLOB value
      +
      + -  Added Global Text Constant(s):
      +     PathFileName
      +
      +  - Modification(s):
      +     - Added Import Export WH347 Page Actions
      +------------------------------------------------------------
    */

}

