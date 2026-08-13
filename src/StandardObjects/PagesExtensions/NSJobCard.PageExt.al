pageextension 14021131 NS_JobCard extends "Job Card"
//PRJCTPR-197 Dk.1.0 31March2023 | Job No. Rewrite Issue.
//PE-311.PP.1.0 11JUN2024 | Added the new Work order report and uncomment the "Work Requested" fasttab. Rename the old work order report as "Work order completed" report
{
    //ContextSensitiveHelpPage = 'user-guide/';   //PRJ-1556.JS.1.0 24AUG2022
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-88.SK.1.0 Do open original field and blocked the new field that has been added.
    //PRJ-120.SK.1.0 Added field
    //PRJ-105.SK.1.0 Make a field visible false due to duplicate field
    //PRJ-162.SK.1.0 Added a field on this Page
    //PRJ-153.SK.1.0 Added action on this page
    //PRJ-194.AS.1.0 - 3APRIL2020 - Added LookupPageId equals to "Job Types List" on field "Job Type".
    //PRJ-59.MS.1.0  changes caption of action
    //PRJ-229.SK.1.0 Added code	
    //JD-10.MS.1.0 added field	 
    //PRJ-243 VT1.0 07-05-20   
    //PRJ-301.AS.1.0 Increased length from 50 to 100 chars
    //PPAL-12.AM.1.0 Commented Factboxes and added them into Fasttabs
    //PPAL-80.AS.1.0 31JULY2020 Hide action Report Job Quote and action Send Job Quote from job card page
    //PRJ-325.AS.1.0 16JULY2020 Commented some code for Job planning lines editable and added some code for action trigger
    //PRJ-200.AS.2.0 15JULY2020 Commented & added some code 
    //JD-48.AS.1.0 31OCT2020 Added Forecast method field
    //CTSI-115.AS.1.0 Added new field
    //CTSI-152.AS.1.0 14Sept2020 Added action to run Project profit analysis report
    //PPAL-38.SK.1.0 - 13AUG2020 - Blocked some code
    //CTSI-106.NS.1.0 31July2020 When manager job status is Completed then Job status Date is Today   
    //CTSI-125.MS.1.0 update name on validate of person res. 
    //PRJ-374.AS.1.0 -  START Pulled Job Segment action from group out & Done other changes also
    //PRJ-381.AS.1.0 14Sept2020 Commented code and added new code as per NAV2017, as it was working there    
    //PRJ-394.MS.1.0 update planning line when modify the GBPG on job card	
    //CTSI-150.AS.1.0 28Sept2020 Added field on page
    //PRJ-351.AS.1.0 08Sept2020 Changed location of Person Responsible Name field
    //TM-10.AM.1.0 1DEC2020 | added new part page .
    //PRJ-464.AM.1.0 4DEC2020 | Added Resp. name field after Person Responsible in page layout 
    //PPAL-166.Am.1.0 | Added Caption property.
    //PRJ-673.N.S.1.0 Remove multiple report TAB
    //PRJ-672.N.S.1.0 add filter job on differnt report
    //PRJ-640 CODE COMMENT
    //PRJ-762.RS.1.0 18June21 | CRITICAL: NAV/PP 17: Please "Turn On" APO Links in Ribbon of Job Card
    //PRJ-769.RS.1.0 8July21  | Create the tool tip Specific to PP fields - Job Card
    //PRJ-820.JS.1.0�04Aug21 | Add Local procedure NS_SetAPOLinkForJob to Create APO Link from Job Card
    //PRJ-949.GK.1.0 01Oct2021 | Added Action,code & field.
    //PRJ-973.GK.1.0 13Oct2021 | Add one field
    //PRJ-991.GK.1.0 14Oct2021 |Change Image icon
    //PRJ-991.GK.1.0 14Oct2021 | Add Field & Code.
    //PRJ-1015.JS.1.0 05Oct2021 | Add one new field
    //PRJ-659.RM.1.0 22Oct2021 | Aligned columns from left to right
    //PRJ-914.AS.1.0 21OCT2021 Added action Create Change order Quote
    //FGH-16.SK.1.0 | 13JAN2022 | Added fields and code for Revenue Recognition customisation
    //PRJ-1152.JS.1.0 20JAN2022 | correct code
    //PRJ-1184.JS.1.0 10FEB2022 | Add Action Job Task All Levels
    //PRJ-1254.RM.1.0 22March2022 | Added a report on action button
    //PRJ-1291.RM.1.0 12April2022 | Added code
    //PRJ-1237.JS.1.0 19MAR2022 | Add code for AppSource security
    //PRJ-1299.JS.1.0 18APR2022 | Add new Option 
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1349.JS.1.0
    //PRJ-1337.RM.1.0 17May2022 | Modified caption 
    //PRJ-1380.NK.1.0 13May2022 | Add New Fields
    //PRJ-1299.JS.1.0 18APR2022 | Add new Option
    //PRJ-1458.RM.1.0 16June2022 | Added a new field.
    //PRJ-1474.RM.1.0 14July2022 | Added some code.
    //PRJ-1486.NK.1.0 08Jul2022 | Added Code
    Caption = 'Job Card'; //PRJ-1330.NK.1.0 25Apr2022 

    //PRJ-1530.NK.1.0 22July2022 | Added code
    //PRJ-1574.RM.1.0 12Aug2022 | Added a tooltip
    //PRJ-1579.RM.1.0  18Aug2022 | Added tooltips
    //PRJ-1556.RM.1.0 22Aug2022 | Added a tooltip
    //PRJ-1579.RM.2.0 31Aug2022 | Added a tooltip
    //PRJ-1615.RM.1.0 09Sep2022 | Added caption & tooltip
    //PRJ-1627.RM.1.0 19Sep2022 | Added some code
    //PRJ-1710.NK.1.0 18Nov2022 | Added Code
    //PRJ-1711.RP.1.0 01Dec2022 | Added a tooltip
    //PE-9.Dk.1.0.23Dec2022     | Move the "Cost Category by Code" from Report to Analytics
    //PE-1.Dk.1.0 6Dec 2023     | Added a Action Job Summary    
    //PRJCTPR-48.Dk.1.0 27Jan 2023| Added a filter    
    //PE-6.NK.1.0 28Mar2022 | Add one field. 
    //PE-74.NK.1.0 17Apr2023 | Added Code
    //PRJCTPR-162.RM.1.0 20July2023 | Added some code
    //PE-190.VC.1.0 16Oct2023 | New page for Current Earned Revenue and Profits Analysis
    //PE-168.HS.1.0 18Nov2023 | Added New Action
    //PRJCTPR-230.HS.1.0 11Dec2023 | Added new action and removed lookup from No. field
    //PRJCTPR-262.DK.1.0 22DEC2023 | Added Action Work Order (Job LedgerSumm)" and Also Chang on Layout
    PromotedActionCategories = 'New,Process,Report,Prices & Discounts,WIP,Navigate,Job,Print/Send,Analytics'; //PRJ-1530.NK.1.0 22July2022
    layout
    {
        modify("No.")
        {
            //Visible = false; //PRJ-88.SK.1.0 BLocked

            //PRJ-88.SK.1.0 Start
            //trigger OnLookup() //PRJ-229.SK.1.0 Commented

            //PRJCTPR-230.HS.1.0 11Dec2023  Start Commented
            // trigger OnLookup(var Text: Text): Boolean; //PRJ-229.SK.1.0 Added
            // var
            //     JobList: Page "NS_Job List (Formatted)";
            // begin
            //     //ProjectPro - start
            //     Clear(JobList);//PRJ-229.SK.1.0 Added
            //     JobList.LOOKUPMODE(TRUE);
            //     JobList.SETTABLEVIEW(Rec);
            //     JobList.SETRECORD(Rec);
            //     IF JobList.RUNMODAL = ACTION::LookupOK THEN
            //         JobList.GETRECORD(Rec);
            //     //ProjectPro - end
            // end;
            //PRJCTPR-230.HS.1.0 11Dec2023  End Commented


            trigger OnAfterValidate()
            begin
                rec.Validate("No.", "No.");
            end;
            //PRJ-88.SK.1.0 End
        }

        modify("Bill-to Country/Region Code")
        {
            Caption = 'Country';
        }
        modify(Posting)
        {
            Caption = 'Constants/Manager';
        }
        modify("Apply Usage Link")
        {
            ApplicationArea = Jobs;
        }

        //PRJ-759.AS.1.0 - START COMMENT
        // modify("Currency Code")
        // {
        //     Visible = false;
        // }
        // modify("Invoice Currency Code")
        // {
        //     Visible = false;
        // }
        //PRJ-759.AS.1.0 - START COMMENT
        modify("WIP Posting Date")
        {
            Visible = false;
        }
        modify("WIP G/L Posting Date")
        {
            Visible = false;
        }
        addafter("Project Manager")//JD-48.AS.1.0 31OCT2020 - start
        {

            field("NS_Forecast Method"; Rec."NS_Forecast Method")
            {

                ApplicationArea = All;
                //OptionCaption = 'Job Forecast by Task Code,Job Forecast by Segment Code';
                OptionCaption = 'Job Forecast by Task Code,Job Forecast by Segment Code,Job Forecast by Task Totals';  //PRJ-1299.JS.1.0 18APR2022
                //ToolTip = 'Specifies the Forecast Method';//PRJ-769.RS.1.0 8July21 Commented                
                ToolTip = 'Specifies the Forecast Method to be used for the Job, either is based on Tasks or Segments or Task Totals'; //PRJ-769.RS.1.0 8July21 //PRJ-1299.JS.1.0 18APR2022

                trigger OnValidate()
                var
                    JobFWBySEG: Record "NS_Job Forecast by Seg code";
                    JobFW: Record "NS_Job Forecast";
                begin
                    JobFWBySEG.Reset;
                    JobFWBySEG.SetRange("NS_Job No.", Rec."No.");
                    JobFWBySEG.SetRange("NS_Posted Segment Boolean", true);
                    if JobFWBySEG.FindFirst then
                        Error('You are not allowed to change the forecast method, as there are already posted entries in forecast worksheet');

                    JobFW.Reset;
                    JobFW.SetRange("NS_Job No.", Rec."No.");
                    JobFW.SetRange("NS_Posted Check Boolean", true);
                    if JobFW.FindFirst then
                        Error('You are not allowed to change the forecast method, as there are already posted entries in forecast worksheet');
                end;
            }
            field("NS_Include Sub Levels"; Rec."NS_Include Sub Levels")   //PRJ-1015.JS.1.0 05Oct2021
            {
                ToolTip = 'Specifies the value for the Master Job Including Sub Level jobs';
                ApplicationArea = All;
                Caption = 'Forecast to Include Sub Levels';
            }
            //PRJ-929.GK.1.0 22Sep2021 start
            field("NS_Use Tax Percentage"; Rec."NS_Use Tax Percentage")
            {
                ToolTip = 'Specifies the value of the Use Tax Percentage field';
                ApplicationArea = All;

            }
            //PRJ-929.GK.1.0 22Sep2021 end
            /// PRJ-949.GK.1.0 01Oct2021 start
            /// PRJ-949.GK.1.0 01Oct2021 start
            field("NS_No. Of Active Crews"; Rec."NS_No. Of Active Crews")
            {
                ToolTip = 'Specifies the value of the No. Of Active Crews field';
                ApplicationArea = All;
                //DrillDownPageId = 14021267; //PRJ-991.GK.1.0 14Oct2021 //PRJ-991.GK.2.0 26Oct2021 comment
                //PRJ-991.GK.2.0 26Oct2021 start
                trigger OnDrillDown()
                var
                    NS_jobCrews: Record "NS_Job Crews";
                    NS_JobCrewsPage: Page "NS_ Job Crew List";
                begin
                    NS_jobCrews.FilterGroup(2);
                    NS_jobCrews.SetRange("NS_Job No.", Rec."No.");
                    NS_jobCrews.SetRange(NS_Active, true);
                    NS_jobCrews.FilterGroup(0);
                    NS_JobCrewsPage.SetTableView(NS_jobCrews);
                    NS_JobCrewsPage.RunModal();
                end;
                //PRJ-991.GK.2.0 26Oct2021 end
            }
            /// PRJ-949.GK.1.0 01Oct2021 end

            //PRJ-991.GK.1.0 14Oct2021 start
            field("NS_No. Of Inactive Crews"; Rec."NS_No. Of Inactive Crews")
            {
                ToolTip = 'Specifies the value of the No. Of Inactive Crews field.';
                ApplicationArea = All;
                //DrillDownPageId = 14021267; //PRJ-991.GK.2.0 26Oct2021 comment
                //PRJ-991.GK.2.0 26Oct2021 start
                trigger OnDrillDown()
                var
                    NS_jobCrews: Record "NS_Job Crews";
                    NS_JobCrewsPage: Page "NS_ Job Crew List";
                begin
                    NS_jobCrews.FilterGroup(2);
                    NS_jobCrews.SetRange("NS_Job No.", Rec."No.");
                    NS_jobCrews.SetRange(NS_Active, false);
                    NS_jobCrews.FilterGroup(0);
                    NS_JobCrewsPage.SetTableView(NS_jobCrews);
                    NS_JobCrewsPage.RunModal();
                end;
                //PRJ-991.GK.2.0 26Oct2021 end
            }
            //PRJ-991.GK.1.0 14Oct2021 end
            //PE-6.NK.1.0 24Mar2022 Start
            field(NS_Opportunity; Rec.NS_Opportunity)
            {
                ApplicationArea = all;
                ToolTip = 'Opportunity';
                Editable = false;
            }
            //PE-6.NK.1.0 24Mar2022 End
            //PRJ-973.GK.1.0 13Oct2021 start
            field("NS_Use Job Plan. Line Entries"; Rec."NS_Use Job Plan. Line Entries")
            {
                // ToolTip = 'Specifies the boolean if Progress Billing flow same G/L in Sales Document.'; //PRJ-1556.RM.1.0 commented
                ToolTip = 'If this is "On", then Progress Billings will use the G/L Account during the make "Job Sales Invoice". If this is "Off", then the Job Posting Group Revenue Account is used'; //PRJ-1556.RM.1.0
                ApplicationArea = All;
            }
            //PRJ-973.GK.1.0 13Oct2021 end

        }//JD-48.AS.1.0 31OCT2020 - end

        //CTSI-125.MS.1.0 start
        modify("Person Responsible")
        {
            trigger OnAfterValidate()
            begin
                NS_UpdatePersonResponsibleName;
            end;
        }
        //CTSI-125.MS.1.0 end
        moveafter("Exch. Calculation (Cost)"; "Exch. Calculation (Price)")//PRJ-759.AS.1.0 Foreign Tab Field Adjustment
        addafter(Description)
        {
            field("NS_Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Sell-to Customer No.';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Sell-to Customer No. of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Sell-to Customer Name';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Sell-to Customer Name of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Salesperson Code"; Rec."NS_Salesperson Code")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Salesperson Code';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the SalesPerson assinged to the Job';//PRJ-769.RS.1.0 8July21
                Caption = 'Salesperson Code';
                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_UpdateSalespersonName;
                    //ProjectPro - end
                end;
            }
            field(NS_SalespersonName; NS_SalespersonName)
            {
                ApplicationArea = All;
                Caption = 'Salesperson Name';
                Editable = false;
                ToolTip = 'Specifies the Salesperson Name';
            }
            field("NS_Contract No."; Rec."NS_Contract No.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Contract No.';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Contract No. of the job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Contract Date"; Rec."NS_Contract Date")
            {
                ApplicationArea = All;
                ToolTip = '"Contract Date" defaulted from the workdate';//PRJ-769.RS.1.0 8July21   //PRJCTPR-343.JS.1.0 22MAR2024
                ShowMandatory = true;//PRJ-1368.GK.1.0 13June2022
            }
            field("NS_Contract For"; Rec."NS_Contract For")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Contract For';//PRJ-769.RS.1.0 8July21 Commented
                //ToolTip = 'Specifies the Contract For of the Job';//PRJ-769.RS.1.0 8July21 //PRJ-1711.RP.1.0 01Dec2022 commented
                ToolTip = 'This field gets updated from the "Description" field above for the Job but can be edited. This field is used on the Progress Billing Job Description.';//PRJ-1711.RP.1.0 01Dec2022
            }
            field("NS_Contract Type"; Rec."NS_Contract Type")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Contract Type';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Contract Type of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Contract Sell Price"; Rec."NS_Contract Sell Price")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Contract Sell Price';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Contract Sell Price of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Customer PO Number"; Rec."NS_Customer PO Number")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Customer PO Number';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Customer PO No.';//PRJ-769.RS.1.0 8July21
                Visible = false; //PRJ-105.SK.1.0 Added
            }
            field("NS_Use Job Material Planning"; Rec."NS_Use Job Material Planning")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies whether to Use Job Material Planning';//PRJ-769.RS.1.0 8July21 Commented
                // ToolTip = 'Specifies whether you ant to use the Job Material Planning or not for the Job';//PRJ-769.RS.1.0 8July21 //PRJ-1579.RM.1.0 commented
                ToolTip = 'Specifies whether you want to use the Job Material Planning or not for the Job'; //PRJ-1579.RM.1.0  
            }
            field("NS_Estimated Start Date"; Rec."NS_Estimated Start Date")
            {
                ApplicationArea = All;
                Caption = 'Job Est. Start Date';
                //ToolTip = 'Specifies the Job Est. Start Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Estimated Date when the Job is going to be started';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Estimated Completion Date"; Rec."NS_Estimated Completion Date")
            {
                ApplicationArea = All;
                Caption = 'Job Est. Completion Date';
                //ToolTip = 'Specifies the Job Est. Completion Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Estimated Date when the Job is going to be completed';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job Contact"; Rec."NS_Job Contact")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Contact';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Job Contact for the Job';//PRJ-769.RS.1.0 8July21
                //PRJCTPR-192.DK.1.0 9OCT2023 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the Job Address FasTab named as Job Contact';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 22.0.XX.XXXXX';
                //PRJCTPR-192.DK.1.0 9OCT2023 End
            }
            field("NS_Job Class"; Rec."NS_Job Class")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Class';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Class of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Sub-Level to Job No."; Rec."NS_Sub-Level to Job No.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Sub-Level to Job No.';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Master Job for which the current Job is a Sub Level';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Exclude from Job Forecast"; Rec."NS_Exclude from Job Forecast")//CTSI-115.AS.1.0
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Exclude from Job Forecast Boolean';   //PRJ-1015.JS.1.0 line commented
                //Bellow tooltip added PRJ-914.JS.1.0  18Oct2021
                ToolTip = 'Specifies whether this Job is to be excluded from the Forecast, This will only work in case of Change Order or Sub Job not for Master Job';
                Caption = 'Exclude from Job Forecast';
            }
            field(NS_Manager; Rec.NS_Manager)
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Manager';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Manager of the Job';//PRJ-769.RS.1.0 8July21

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_UpdateManagerName;
                    //ProjectPro - end
                end;
            }
            field(NS_ManagerName; ManagerName)
            {
                ApplicationArea = All;
                Caption = 'Manager Name';
                Editable = false;
                ToolTip = 'Specifies the Manager Name';
            }
            field(NS_Estimator; Rec.NS_Estimator)
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Estimator';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Estimator of the Job';//PRJ-769.RS.1.0 8July21

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_UpdateEstimatorName;
                    //ProjectPro - end
                end;
            }
            field(NS_EstimatorName; EstimatorName)
            {
                ApplicationArea = All;
                Caption = 'Estimator Name';
                Editable = false;
                ToolTip = 'Specifies the Estimator Name';
            }
            field("NS_Default Job Retention"; Rec."NS_Default Job Retention")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Default Job Retention';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Default Retention percentage of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Manager Job Status"; Rec."NS_Manager Job Status")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Manager Job Status';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the current Status of the Job';//PRJ-769.RS.1.0 8July21
                Editable = NSReturnManagerStatus;  //PRJCTPR-147.PS.2.0 20Sep2023

                trigger OnValidate();
                begin
                    // CTSI-106.NS.1.0 Start //PRJ-337.AS.1.0
                    if "NS_Manager Job Status" = "NS_Manager Job Status"::Completed then
                        "NS_Job Status Date" := Today;
                    // CTSI-106.NS.1.0 END //PRJ-337.AS.1.0
                    //ProjectPro - start
                    NS_CalcStatistics;
                    //ProjectPro - end
                    CurrPage.Update;//PRJ-337.AS.1.0
                end;
            }
            field("NS_Job Status Date"; Rec."NS_Job Status Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Status Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Status Date of the Job';//PRJ-769.RS.1.0 8July21
                //PRJ-337.AS.1.0 - start
                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;
                //PRJ-337.AS.1.0 - end
            }
            field("NS_WIP Method1"; Rec."WIP Method")
            {
                ApplicationArea = All;
                Caption = 'WIP Method';
                ToolTip = 'Specifies the WIP Method';
            }
            field("NS_WIP Posting Date2"; Rec."WIP Posting Date")
            {
                ApplicationArea = All;
                Caption = 'WIP Posting Date';
                Editable = false;
                ToolTip = 'Specifies the WIP Posting Date';
            }
            field("NS_Job Phone"; Rec."NS_Job Phone")
            {
                ApplicationArea = All;
                Editable = "Job PhoneEditable";
                //ToolTip = 'Specifies the Job Phone';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Job Phone for the Job';//PRJ-769.RS.1.0 8July21                                    
                //PRJCTPR-192.DK.1.0 9OCT2023 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the Job Address FasTab named as Job Phone';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 22.0.XX.XXXXX';
                //PRJCTPR-192.DK.1.0 9OCT2023 End
            }
            field("NS_DFR Nos."; Rec."NS_DFR Nos.")
            {
                ApplicationArea = all;
                Caption = 'DFR Nos.';
                Description = 'JD-10.MS.1.0';
                ToolTip = 'Specifies the DFR Nos. of the Job';//PRJ-769.RS.1.0 8July212
            }

            // PRJCTPR-305.PS.1.0 05Feb2024 Start 
            //PE-193.PS.1.0 15Nov2023 Start
            group("NSChange Request")
            {
                Caption = 'Change Request';
                field("NS_Change Request to Job No."; Rec."NS_Change Request to Job No.")
                {
                    ApplicationArea = All;
                }
                field("NS_Change Order No."; Rec."NS_Change Order No.")
                {
                    ApplicationArea = All;
                }
            }

            //PE-193.PS.1.0 15Nov2023 End
            // PRJCTPR-305.PS.1.0 05Feb2024 End


            group(NS_General1)
            {
                // Caption = 'General'; //PRJ-1615.RM.1.0 commented
                Caption = ''; //PRJ-1615.RM.1.0
                field(NS_Control1100773073; '')
                {
                    ApplicationArea = All;
                    CaptionClass = Text19050914;
                    Visible = false;  //PRJ-1483.GK.1.0 28JUN2022
                }
            }
        }
        //PRJ-1380.NK.1.0 13May2022 Start
        addafter("Project Manager")
        {
            //PE-211.AS.2.0 start
            field("NS_Field Manager"; Rec."NS_Field Manager")
            {
                ApplicationArea = Jobs;

                Caption = 'Field Manager ID'; //PRJ-1615.RM.1.0
                ToolTip = 'Specifies the Field Manager ID'; //PRJ-1615.RM.1.0
            }
            //PE-211.AS.2.0 end
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = all;
                Caption = 'Job Purchaser';
                //ToolTip = 'Job Purchaser';  //PRJ-1579.RM.1.0 commented
                ToolTip = 'Specifies the Purchaser for the specific Job'; //PRJ-1579.RM.1.0
                Description = '//PRJ-1380.NK.1.0';

                trigger OnValidate()
                var
                    Resource: Record Resource;
                begin
                    if Resource.Get(Rec."NS_Job Purchaser") then;
                    JobPurName := Resource.Name;
                end;
            }
            field(NS_JobPurName; JobPurName)
            {
                ApplicationArea = all;
                Caption = 'Job Purchaser Name';
                // ToolTip = 'Job Purchaser Name'; //PRJ-1579.RM.1.0 commented
                ToolTip = 'Specifies the Name of Purchaser for specific Job'; //PRJ-1579.RM.1.0
                Editable = false;
                Description = '//PRJ-1380.NK.1.0';
            }
        }
        //PRJ-1380.NK.1.0 13May2022 End
        //PRJ-162.SK.1.0 Start
        addafter(Status)
        {
            field("NS_Line Type"; Rec."NS_Line Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the default Line Type for the Job';//PRJ-769.RS.1.0 8July212
            }
        }
        //PRJ-162.SK.1.0 End
        // moveafter("NS_Sub-Level to Job No."; "Search Description")//PE-193.PS.1.0 15Nov2023 Commented
        // moveafter("NS_Change Order No."; "Search Description")//PE-193.PS.1.0 15Nov2023 // PRJCTPR-305.PS.1.0 05Feb2024 Commented
        moveafter("NS_Sell-to Customer Name"; "Bill-to Contact No.")
        addafter("Last Date Modified")
        {
            field(NS_CustomerPONumber; Rec."NS_Customer PO Number")
            {
                ApplicationArea = All;
                Caption = 'Cust. PO No.';
                ToolTip = 'Specifies Customer''s Purchase order no.'; //PRJ-1579.RM.1.0  
            }
            field("NS_Customer Job No."; Rec."NS_Customer Job No.")
            {
                ApplicationArea = All;
                Caption = 'Cust. Job No.';
                ToolTip = 'Specifies the Customer Job No.';//PRJ-769.RS.1.0 8July212
            }
            // field(NS_PersonResponsibleName; PersonResponsibleName)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Resp. Name';
            //     Editable = false;
            // }
            field("NS_Job Ship-to Code"; Rec."NS_Job Ship-to Code")
            {
                ApplicationArea = All;
                Caption = 'Ship-to Code';
                ToolTip = 'Specifies the Job Ship-to Code for the Job';//PRJ-769.RS.1.0 8July212
                //PRJCTPR-192.DK.1.0 09OCT2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the Job Address FasTab named as Ship-to Code';
                ObsoleteTag = 'Removed in upcoming app 22.0.XX.XXXXX';
                //PRJCTPR-192.DK.1.0 09OCT2023 End
                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if JobSetup.Get() then;//PRJCTPR-192.DK.1.0 15SEP2023
                    if "NS_Job Ship-to Code" > '' then begin
                        //PRJCTPR-192.DK.1.0 15SEP2023 START
                        if JobSetup."NS_Sell-to Cust_Ship-to Code" then
                            ShipToAddress.GET(Rec."Sell-to Customer No.", Rec."NS_Job Ship-to Code")
                        else
                            ShipToAddress.GET("Bill-to Customer No.", "NS_Job Ship-to Code");
                        //PRJCTPR-192.DK.1.0 15SEP2023 END
                        "NS_Job Address 1" := ShipToAddress.Address;
                        "NS_Job Address 2" := ShipToAddress."Address 2";
                        "NS_Job City" := ShipToAddress.City;
                        "NS_Job County" := ShipToAddress.County;
                        "NS_Job Post Code" := ShipToAddress."Post Code";
                        "NS_Job Country/Region Code" := ShipToAddress."Country/Region Code";
                        "NS_Job Contact" := ShipToAddress.Contact;
                        "NS_Job Phone" := ShipToAddress."Phone No.";
                        "NS_Tax Area Code" := ShipToAddress."Tax Area Code";
                        "NS_Tax Liable" := ShipToAddress."Tax Liable";
                    end else begin
                        "NS_Job Address 1" := '';
                        "NS_Job Address 2" := '';
                        "NS_Job City" := '';
                        "NS_Job County" := '';
                        "NS_Job Post Code" := '';
                        "NS_Job Country/Region Code" := '';
                        "NS_Job Contact" := '';
                        "NS_Job Phone" := '';
                        if CONFIRM(Text14021100, true) then begin
                            "NS_Tax Area Code" := '';
                            "NS_Tax Liable" := false;
                        end;
                    end;

                    NS_BlockShipTo;
                    //ProjectPro - end
                end;
                //  PRJCTPR-192.DK.1.0 15SEP2023 START
                trigger OnDrillDown()
                var
                    NS_Ship_to: Record "Ship-to Address";
                    NS_ShiptoAddress: Page "Ship-to Address List";
                begin
                    NS_Ship_to.Reset();
                    if JobsSetup.Get() then;
                    if not JobsSetup."NS_Sell-to Cust_Ship-to Code" then
                        NS_Ship_to.setRange(NS_Ship_to."Customer No.", Rec."Bill-to Customer No.");
                    if NS_Ship_to.findFirst() then begin
                        if PAGE.RUNMODAL(0, NS_ship_to) = ACTION::LookupOK then begin
                            Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                            Rec."NS_Job Address 1" := NS_Ship_to.Address;
                            Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                            Rec."NS_Job City" := NS_Ship_to.City;
                            Rec."NS_Job County" := NS_Ship_to.County;
                            Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                            Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                            Rec."NS_Job Contact" := NS_Ship_to.Contact;
                            Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                            Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                            Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                        end;
                    end;
                    if JobsSetup."NS_Sell-to Cust_Ship-to Code" then begin
                        NS_Ship_to.setRange(NS_Ship_to."Customer No.", Rec."Sell-to Customer No.");
                        if NS_ship_to.findFirst() then
                            if PAGE.RUNMODAL(0, NS_Ship_to) = ACTION::LookupOK then begin
                                Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                                Rec."NS_Job Address 1" := NS_Ship_to.Address;
                                Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                                Rec."NS_Job City" := NS_Ship_to.City;
                                Rec."NS_Job County" := NS_Ship_to.County;
                                Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                                Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                                Rec."NS_Job Contact" := NS_Ship_to.Contact;
                                Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                                Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                                Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                            end;
                    end;
                end;
                // PRJCTPR-192.DK.1.0 15SEP2023 END

            }
            //PRJ-1458.RM.1.0 Start
            field("NS_Delievery Instruction"; Rec."NS_Delievery Instruction")
            {
                ApplicationArea = all;
                // ToolTip = 'specifies the description of the Delievery Instruction'; 
                ToolTip = 'Specifies the description of the Delivery Instructions'; //PRJ-1574.RM.1.0
            }
            //PRJ-1458.RM.1.0 end

            field(NS_Description_; Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description of the job';
                Visible = false; //PRJ-1390.GK.1.0 01June2022
            }
            field("NS_Job Address 1"; Rec."NS_Job Address 1")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Editable = "Job Address 1Editable";
                //ToolTip = 'Specifies the Job Address 1';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Address 1 for the Job';//PRJ-769.RS.1.0 8July21
            }

            field("NS_Job Address 2"; Rec."NS_Job Address 2")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Editable = "Job Address 2Editable";
                //ToolTip = 'Specifies the Job Address 2';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies an additional Line of Address';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job City"; Rec."NS_Job City")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Caption = 'Job City';
                Editable = "Job CityEditable";
                //ToolTip = 'Specifies the Job City';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the City for the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job County"; Rec."NS_Job County")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Caption = 'Job State';
                Editable = "Job CountyEditable";
                //ToolTip = 'Specifies the Job State';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the County for the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job Post Code"; Rec."NS_Job Post Code")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Editable = "Job Post CodeEditable";
                //ToolTip = 'Specifies the Job Post Code';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Post Code for the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job Country/Region Code"; Rec."NS_Job Country/Region Code")
            {
                //PRJ-1615.RM.1.0 start 
                ObsoleteState = Pending;
                ObsoleteReason = 'Moved to the new FasTab named as Job Address';
                Visible = false;
                ObsoleteTag = 'Removed in upcoming app 20.0.10.41354';
                //PRJ-1615.RM.1.0 end
                ApplicationArea = All;
                Caption = 'Job Country';
                Editable = JobCountryRegionCodeEditable;
                //ToolTip = 'Specifies the Job Country';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Post Country Region for the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job Type"; '') //PRJCTPR-197 DK.1.0
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Type';//PRJ-769.RS.1.0 8July21 Commented
                LookupPageId = "NS_Job Types List";//PRJ-194.AS.1.0 - 3APRIL2020
                ToolTip = 'Specifies the Type of the Job';//PRJ-769.RS.1.0 8July21
                Visible = false;  //PRJCTPR-197 DK.1.0
            }
            //PRJCTPR-197 DK.1.0 Start
            field("NS_Job Type New"; Rec."NS_Job Type New")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Type';
                LookupPageId = "NS_Job Types List";
                ToolTip = 'Specifies the Type of the Job';
            }
            //PRJCTPR-197 Dk.1.0 End
            field("NS_Gen. Prod. Posting Group"; Rec."NS_Gen. Prod. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Gen. Prod. Posting Group';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the default Gen. Prod. Posting Group of the Job';//PRJ-769.RS.1.0 8July21

            }
            //PRJ-120.SK.1.0 Start
            field("NS_Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Gen. Bus. Posting Group';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the default Gen. Bus. Posting Group of the Job';//PRJ-769.RS.1.0 8July21
                trigger OnValidate()
                var
                    PlngLine: Record "Job Planning line";
                begin
                    //PRJ-394 start
                    PlngLine.Reset();
                    PlngLine.SetRange("Job No.", "No.");
                    if PlngLine.FindSet() then
                        repeat
                            //PlngLine."Gen. Bus. Posting Group" := "NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
                            PlngLine."Gen. Bus. Posting Group" := "NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                            PlngLine.Modify();
                        until PlngLine.Next() = 0;
                    //PRJ-394 end    
                end;
            }
            //PRJ-120.SK.1.0 End
            //PRJ-640.N.S.1.0 Start Comment
            // field("NS_Original Budget Created"; Rec."NS_Locked Planning Lines Exist")
            // {
            //     ApplicationArea = All;
            //     AssistEdit = false;
            //     DrillDown = false;
            //     Editable = false;
            //     Lookup = false;
            //     ToolTip = 'Specifies whether Locked Planning Lines Exist for this Job.';
            // }
            //PRJ-640.N.S.1.0 END Comment

        }

        //PE-47.PS.1.0 01March2023 Start
        addafter("NS_Line Type")
        {
            field("NS_Open Job Backlog"; Rec."NS_Open Job Backlog")
            {
                ApplicationArea = all;
                Editable = false;
                //Caption = 'Open Job Backlog';//PE-173.PS.1.0 09Oct2023 Commented
                Caption = 'Last Run Open Job Backlog Value'; //PE-173.PS.1.0 09Oct2023
                ToolTip = 'Specifies the job backlog value calculated when "Open Job Backlog Batch" was run last time. It shows the difference between the "Total Contract Price” and the "Total Invoiced Price" including Master & the Sub-Level Jobs based on the Jobs Setup.Note: The calculation occurs only for the Jobs with Status set to "Open" or "Planning", and the "Manager Job Status" set to "Running."';//PE-173.PS.1.0 09Oct2023 
            }
            //PE-173.PS.1.0 09Oct2023 Start
            field("NS_Last Run Open Job Backlog"; Rec."NS_Last Run Open Job Backlog")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the date the Open Job Backlog batch was last run.';
            }
            //PE-173.PS.1.0 09Oct2023 END

            field("NSOpen Job Backlog New"; Rec."NS_New Run B_OpenJob B Log")  //PRJCTPR-122.PS.1.0 14Jun2023
            {
                ApplicationArea = all;
                // caption = 'Run Batch Open Job Backlog';//PE-173.PS.1.0 09Oct2023 Commented
                Caption = 'Open Job Backlog Updated';//PE-173.PS.1.0 09Oct2023
                ToolTip = 'Specifies if the open job backlog has been cleared for both the master and sub-level jobs. This auto-sets to True, if Last Run Open Job Backlog Value field shows zero value on running the open job backlog batch.';//PE-173.PS.1.0 09Oct2023
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(NS_Status; Rec.Status)
            {
                ApplicationArea = all;
                Caption = 'Status';
                Visible = false;
            }
            // field("NS_Open Job Backlog"; Rec."NS_Open Job Backlog")
            // {
            //     ApplicationArea = all;
            //     Caption = 'Open Job Backlog';

            // }
        }
        //PE-47.PS.1.0 01March2023 End

        //PRJ-464.AM.1.0 Start
        addafter("Person Responsible")
        {
            field(NS_PersonResponsibleName; PersonResponsibleName)
            {
                ApplicationArea = All;
                Caption = 'Resp. Name';
                Editable = false;
            }
        }
        //PRJ-464.AM.1.0 End
        addfirst(Posting)
        {
            field("NS_Completion Date"; Rec."NS_Completion Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Completion Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Date when the Job is going to be completed, this is automatically updated when the Job status is changes';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Job Calendar Code"; Rec."NS_Job Calendar Code")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendar Code';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Job Calendar Code of the Job';//PRJ-769.RS.1.0 8July21
            }
            //PRJ-759.AS.1.0 - START COMMENT
            //   field("NS_Currency Code2"; Rec."Currency Code")
            //     {
            //         ApplicationArea = All;
            //         Editable = CurrencyCodeEditable;
            //         Importance = Promoted;
            //         ToolTip = 'Specifies the Currency Code';

            //         trigger OnValidate();
            //         begin
            //             //PRJ-9.SK.1.0 Start
            //             IF ("Invoice Currency Code" <> "Currency Code") AND ("Invoice Currency Code" <> '') AND ("Currency Code" <> '') THEN
            //                 ERROR(DifferentCurrenciesErr);
            //             //PRJ-9.SK.1.0 End
            //             //CurrencyCheck;
            //         end;
            //     }
            //PRJ-759.AS.1.0 - END COMMENT
        }
        moveafter("Starting Date"; "Creation Date")
        // moveafter(Posting; "Ending Date") //PPAL-38.SK.1.0 Blocked
        moveafter("Creation Date"; "Ending Date")

        //PE-200.AS.10.0 start
        addafter("Payment Method Code")
        {
            field(NS_PaywhenpaidTermsCode; Rec.NS_PaywhenpaidTermsCode)
            {
                ApplicationArea = All;
                ToolTip = 'The "Pay When Paid term" is used in the calculation of due dates for vendor ledger entries and update them with the new ones. Define the no. of days in here manually by denoting them with D, for example, 5D. The days defined here will get added to the Posting Date of the payment received of the related Draw No. customer entry, and thereby recalculating the new Due Date for vendor ledger entries associated with a specific draw number.';
            }
        }
        //PE-200.AS.10.0 end
        addafter(Status)
        {
            //PRJ-759.AS.1.0 - START COMMENT
            //    field("NS_Invoice Currency Code2"; Rec."Invoice Currency Code")
            // {
            //     ApplicationArea = All;
            //     Editable = InvoiceCurrencyCodeEditable;
            //     ToolTip = 'Specifies the Invoice Currency Code';

            //     trigger OnValidate();
            //     begin
            //         //CurrencyCheck;
            //         //PRJ-9.SK.1.0 Start
            //         IF ("Invoice Currency Code" <> "Currency Code") AND ("Invoice Currency Code" <> '') AND ("Currency Code" <> '') THEN
            //             ERROR(DifferentCurrenciesErr);
            //         //PRJ-9.SK.1.0 End
            //     end;
            //}
            //PRJ-759.AS.1.0 - END COMMENT
            field("NS_Tax Liable"; Rec."NS_Tax Liable")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Tax Liable';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the job is Taxable or not';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Tax Group Code"; Rec."NS_Tax Group Code New")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Tax Group Code';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Tax Group Code of the Job';//PRJ-769.RS.1.0 8July21
            }

            field("NS_Tax Area Code"; Rec."NS_Tax Area Code")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Tax Area Code';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Tax Area Code of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_VAT Bus. Posting Group"; Rec."NS_VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the VAT Bus. Posting Group';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the VAT Bus. Posting Group of the Job';//PRJ-769.RS.1.0 8July21
            }
        }
        //moveafter("Exch. Calculation (Cost)"; "Exch. Calculation (Price)")//PRJ-759.AS.1.0 Commented to move "Exch. Calculation (Cost)" in Foreign tab
        //moveafter("NS_Invoice Currency Code2"; "Exch. Calculation (Cost)")//PRJ-759.AS.1.0 Commented to move "Exch. Calculation (Cost)" in Foreign tab
        addafter("Job Posting Group")
        {
            field("NS_VAT Prod. Posting Group"; Rec."NS_VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the VAT Prod. Posting Group';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the VAT Prod. Posting Group of the Job';//PRJ-769.RS.1.0 8July21
            }
            //CTSI-150.AS.1.0 28Sept2020 - start
            field("NS_Use % Billing format"; REC."NS_Use % Billing format")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Use % Billing format Boolean';
            }
            //CTSI-150.AS.1.0 28Sept2020 - end
            field("NS_Progress Billing No."; Rec."NS_Progress Billing No.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Progress Billing No.';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Progress Billing No. of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Progress Billing Sub-Level"; Rec."NS_Progress Billing Sub-Level")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Progress Billing Sub-Level'; //PRJ-243 VT1.0 07-05-20 //PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Progress Billing Sub-Level of the Job';//PRJ-769.RS.1.0 8July21
                Caption = 'Progress Billing CO:';//PRJ-243 VT1.0 07-05-20                
            }
        }
        moveafter("NS_VAT Prod. Posting Group"; "Allow Schedule/Contract Lines")
        addafter("WIP Posting Method")
        {
            field("NS_Job Posting Date"; Rec."NS_Job Posting Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Posting Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Posting Date of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Recognition Date"; Rec."NS_Recognition Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Recognition Date';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Recognition Date of the Job';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Time And Material"; Rec."NS_Time And Material")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Time And Material';
            }
            field("NS_Indirect Burden Type"; Rec."NS_Indirect Burden Type")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Indirect Burden Type';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies Default Burden Type for the job, that burden should be of Project, Service or Admin';//PRJ-769.RS.1.0 8July21
                Editable = Editbool;//CTSI-254.AM
            }
            field("NS_Requires Certified Payroll"; Rec."NS_Requires Certified Payroll")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Requires Certified Payroll';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the job has Certified Payroll or not';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Unit of Measure"; Rec."NS_Unit of Measure")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Unit of Measure';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Unit Of Measure of the Job';//PRJ-769.RS.1.0 8July21
            }
            //FGH-16.SK.1.0 Start | Moved this field
            // field("NS_Total Units"; Rec."NS_Total Units")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the Total Units';
            // }

            // field("NS_Actual Percent Complete"; Rec."NS_Actual Percent Complete")
            // {
            //     ApplicationArea = All;
            //     Caption = '% Job Actually Complete';
            //     DecimalPlaces = 0 : 2;
            //     //ToolTip = 'Specifies the % Job Actually Complete';//PRJ-769.RS.1.0 8July21 Commented
            //     ToolTip = 'Specifies the actual percenatge complete of the Job';//PRJ-769.RS.1.0 8July21

            //     trigger OnValidate();
            //     begin
            //         //ProjectPro - start
            //         NS_CalcStatistics;
            //         //ProjectPro - end
            //     end;
            // }

            // field("NS_Actual Percent Complete Date"; Rec."NS_Actual PercentCompleteDate")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Job Completed % Date';
            //     //ToolTip = 'Specifies the Job Completed % Date';//PRJ-769.RS.1.0 8July21 Commented
            //     ToolTip = 'Specifies the actual percenatge complete date of the Job';//PRJ-769.RS.1.0 8July21

            //     trigger OnValidate();
            //     begin
            //         //ProjectPro - start
            //         NS_CalcStatistics;
            //         //ProjectPro - end
            //     end;
            // }

            // field("NS_Actual Units Complete"; Rec."NS_Actual Units Complete")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Actual Units Complete';
            //     DecimalPlaces = 0 : 0;
            //     //ToolTip = 'Specifies the Actual Units Complete';//PRJ-769.RS.1.0 8July21 Commented
            //     ToolTip = 'Specifies the actual unit complete of the Job';//PRJ-769.RS.1.0 8July21
            // }

            // field("NS_Actual Units Complete Date"; Rec."NS_Actual Units Complete Date")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Units Completed % Date';
            //     //ToolTip = 'Specifies the Units Completed % Date';//PRJ-769.RS.1.0 8July21 Commented
            //     ToolTip = 'Specifies the actual unit complete date of the Job';//PRJ-769.RS.1.0 8July21
            // }
            //FGH-16.SK.1.0 End
        }
        addafter("Apply Usage Link")
        {
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 start
        addafter("Bill-to County")
        {

            field(NS_County; Rec."NS_County")
            {
                ToolTip = 'Specifies the value for County';
                ApplicationArea = All;
                Caption = 'County';
            }
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 end
        moveafter("Apply Usage Link"; "% of Overdue Planning Lines")
        addafter("% Invoiced")
        {
            field("NS_Forecast Type"; Rec."NS_Forecast Type")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Forecast Type';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Forecast Type of the Job that whether it is percentage of Budget or percentage of Projected';//PRJ-769.RS.1.0 8July21
            }
            field("NS_Billing Day of Month"; Rec."NS_Billing Day of Month")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Billing Day of Month';
            }
            //PE-249.JS.1.0 08FEB2024 - Start
            field("NS_Mandate Revenue Category"; Rec."NS_Mandate Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Enable this to make “Revenue Category Code” for every job planning line and transaction. This will allow you to enter the code against Budget planning/actual lines. Currently, the system does not allow you to enter Rev. Cat. Code on Budget planning lines.';
            }
            //PE-249.JS.1.0 08FEB2024 - end

            //PE-301.NC.1.0 10Jun2024 Start
            field("NS_Pur/Sale UOM for B&B JPL"; Rec."NS_Pur/Sale UOM for B&B JPL")
            {
                ApplicationArea = all;
                Caption = 'Purchase/Sale UOM for Both Budget & Billable JPL';
                ToolTip = 'If enabled, the system will take Purchase and Sales UOM on priority from the item card else it will take UOM present on Job Planning Lines when a document is created via job planning lines for "Type=Both Budget and Billable". For e.g.: JMP, Subcontract, Progress Billing, Direct Sales and Purchase doc using "Get Project Planning Lines".';
            }
            //PE-301.NC.1.0 10Jun2024 End

        }
        //PPAL-12.AM Start
        addafter(JobTaskLines)
        {
            //PRJ-1615.RM.1.0 start
            group(NS_JobAddress)
            {
                Caption = 'Job Address';
                field("NS_Job Address New1"; Rec."NS_Job Address 1")
                {
                    ApplicationArea = All;
                    Editable = "Job Address 1Editable";
                    //ToolTip = 'Specifies the Job Address 1';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Address 1 for the Job';//PRJ-769.RS.1.0 8July21
                }

                field("NS_Job Address New2"; Rec."NS_Job Address 2")
                {
                    ApplicationArea = All;
                    Editable = "Job Address 2Editable";
                    //ToolTip = 'Specifies the Job Address 2';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies an additional Line of Address';//PRJ-769.RS.1.0 8July21
                }
                field("NS_Job City New"; Rec."NS_Job City")
                {
                    ApplicationArea = All;
                    Caption = 'Job City';
                    Editable = "Job CityEditable";
                    //ToolTip = 'Specifies the Job City';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the City for the Job';//PRJ-769.RS.1.0 8July21
                }
                field("NS_Job Country New"; Rec."NS_Job County")
                {
                    ApplicationArea = All;
                    Caption = 'Job State';
                    Editable = "Job CountyEditable";
                    //ToolTip = 'Specifies the Job State';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the State for the Job';//PRJ-769.RS.1.0 8July21
                }
                field("NS_Job Post Code New"; Rec."NS_Job Post Code")
                {
                    ApplicationArea = All;
                    Editable = "Job Post CodeEditable";
                    //ToolTip = 'Specifies the Job Post Code';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Post Code for the Job';//PRJ-769.RS.1.0 8July21
                }
                field("NS_Job Country/Region Code New"; Rec."NS_Job Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Job Country';
                    Editable = JobCountryRegionCodeEditable;
                    //ToolTip = 'Specifies the Job Country';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Post Country Region for the Job';//PRJ-769.RS.1.0 8July21
                }
                //PE-99.NC.1.0 29May2023 Start

                field(NS_ShowMap; NS_ShowMapLbl)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the Job''s address on your preferred map website.';
                    trigger OnDrillDown()
                    begin
                        CurrPage.Update(true);
                        Rec.DisplayMap();
                    end;
                }
                //PE-99.NC.1.0 29May2023 End
            }
            //PRJ-1615.RM.1.0 end
            part(NS_JobBudgetBillable; "NS_Job Budget/Billable FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Caption = 'Job Budget/Billable';
            }
            part(NS_JobAdjustedBudBillable; "NS_Job AdjtdBudBillableFactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
                Caption = 'Job Adjtd Bud/Billable';
            }
            part(NS_ActualcostBillings; "NS_Actual CostBillingsFactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Caption = 'Actual Cost/Billings';
                ObsoleteState = Pending; //PRJ-1486.NK.1.0 08Jul2022
                ObsoleteReason = 'This part page is deprecated in upcoming release due to Job Card Performance issue and moving in Action Button '; //PRJ-1486.NK.1.0 08Jul2022
                ObsoleteTag = '19.0.40.30666'; //PRJ-1486.NK.1.0 08Jul2022
            }
            part(NS_BudgetAnalysisProfits; NS_BudgAnalysisProfitsFactBox)
            {
                ApplicationArea = Jobs;
                SubPageLink = "No." = FIELD("No.");
                Caption = 'Budg. Analysis/Profits';
                ObsoleteState = Pending; //PRJ-1486.NK.1.0 08Jul2022
                ObsoleteReason = 'This part page is deprecated in upcoming release due to Job Card Performance issue and moving in Action Button '; //PRJ-1486.NK.1.0 08Jul2022
                ObsoleteTag = '19.0.40.30666'; //PRJ-1486.NK.1.0 08Jul2022
            }
            //TM-10.AM.1.0 start
            //PE-311.PP.1.0 11JUN2024 Start Uncomment 
            part("NS_Work Completed"; "NS_Work Type")
            {
                Caption = 'Work Requested'; // PE-311.PP.1.0 11JUN2024
                ApplicationArea = Suite;
                SubPageLink = "NS_Job No." = field("No.");
                UpdatePropagation = Both;
            }
            //PE-311.PP.1.0 11JUN2024 End
            //TM-10.AM.1.0 end
        }
        //PPAL-12.AM End
        // movebefore("Exch. Calculation (Price)";"NS_Currency Code2")
        addafter("Foreign Trade")
        {
            group(NS_Prepayment)
            {
                Caption = 'Prepayment';
                field("NS_Prepayment %"; Rec."NS_Prepayment %")
                {
                    //ToolTip = 'Specifies the Prepayment %';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Prepayment % of the Job to calculate the Prepayments';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        "NS_Prepayment Amount" := ROUND("NS_Budgeted Price (LCY)" * ("NS_Prepayment %" / 100), NS_GLSetup."Amount Rounding Precision");
                        VALIDATE("NS_Prepayment Due Date");
                        //ProjectPro - end
                    end;
                }
                field("NS_Prepayment Amount"; Rec."NS_Prepayment Amount")
                {
                    Editable = true;
                    //ToolTip = 'Specifies the Prepayment Amount';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Prepayment Amount of the Job, here user can even enter the prepayment amount manually';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        "NS_Prepayment %" := 0;
                        VALIDATE("NS_Prepmt. Payment Terms Code");
                        //ProjectPro - end
                    end;
                }
                //PRJ-1433.GK.1.0 START UNCOMMENT START
                //PRJ-640.N.S.1.0 Start Comment
                field("NS_Budgeted Price (LCY)"; Rec."NS_Budgeted Price (LCY)")
                {
                    Caption = 'Prepmt. Contract Amount';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Prepmt. Contract Amount';
                }
                //PRJ-640.N.S.1.0 END Comment
                //PRJ-1433.GK.1.0 START UNCOMMENT END
                field("NS_Compress Prepayment"; Rec."NS_Compress Prepayment")
                {
                    //ToolTip = 'Specifies the Compress Prepayment';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the where to Compress Prepayment on the Job or not';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;
                }
                field("NS_Prepmt. Payment Terms Code"; Rec."NS_Prepmt. Payment Terms Code")
                {
                    //ToolTip = 'Specifies the Prepmt. Payment Terms Code';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Prepmt. Payment Terms Code of the Job';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        IF "NS_Prepmt. Payment Terms Code" <> '' THEN BEGIN
                            NS_PaymentTerms.GET("NS_Prepmt. Payment Terms Code");
                            "NS_Prepayment Due Date" := CALCDATE(NS_PaymentTerms."Due Date Calculation", WORKDATE());
                        END ELSE
                            VALIDATE("NS_Prepayment Due Date", WORKDATE());
                        //ProjectPro - end
                    end;
                }
                field("NS_Prepmt. Payment Discount %"; Rec."NS_Prepmt. Payment Discount %")
                {
                    //ToolTip = 'Specifies the Prepmt. Payment Discount %';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the Prepmt. Payment Discount % of the Job';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;
                }
                field("NS_Prepayment Due Date"; Rec."NS_Prepayment Due Date")
                {
                    //ToolTip = 'Specifies the Prepayment Due Date';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies that when is the Prepayment Due for the Job';//PRJ-769.RS.1.0 8July21
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        IF "NS_Prepmt. Payment Terms Code" <> '' THEN BEGIN
                            NS_PaymentTerms.GET("NS_Prepmt. Payment Terms Code");
                            "NS_Prepayment Due Date" := CALCDATE(NS_PaymentTerms."Due Date Calculation", "NS_Prepayment Due Date");
                        END ELSE
                            "NS_Prepayment Due Date" := WORKDATE();
                        //ProjectPro - end
                    end;
                }
                //PRJ-640.N.S.1.0 Start Comment
                // field("NS_Schedule Total Cost"; Rec."NS_Schedule Total Cost")
                // {
                //     Editable = false;
                //     ToolTip = 'Specifies the Schedule Total Cost';
                //     Visible = false;
                //     ApplicationArea = all;
                // }
                //PRJ-640.N.S.1.0 END Comment
            }
            group(NS_Projections)
            {
                Caption = 'Projections'; //PRJ-659.RM.1.0 22Oct2021

                fixed(NS_Control1100773246)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    Caption = '';

                    group(NS_PROJECTPRO)
                    {
                        Caption = 'PROJECTPRO';
                        field(NS_Text19000744; Text19000744)
                        {
                            Editable = false;
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_BudgetUsedPctLbl; NS_BudgetUsedPctLbl)
                        {
                            ToolTip = 'Specifies the budget used percentage';
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_CostsToDateLbl; NS_CostsToDateLbl)
                        {
                            ToolTip = 'Specifies the cost to date';
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_BudgetRemainingLbl; NS_BudgetRemainingLbl)
                        {
                            ToolTip = 'Specifies the remaining budget';
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_BudgetedTotalsCostsLbl; NS_BudgetedTotalsCostsLbl)
                        {
                            ToolTip = 'Specifies the budgeted total cost';
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_BudgetedProfitLossLbl; NS_BudgetedProfitLossLbl)
                        {
                            ToolTip = 'Specifies the budgeted profit loss';
                            Caption = '';
                            ApplicationArea = all;
                        }
                        field(NS_BudgetedOrifitPctLbl; NS_BudgetedOrifitPctLbl)
                        {
                            ToolTip = 'Specifies the budgeted profit percentage';
                            Caption = '';
                            ApplicationArea = all;
                        }

                    }

                    group("NS_Actual")
                    {
                        Caption = '                             Actual'; //PRJ-659.RM.1.0 22Oct2021
                        field(NS_Control1100773136; '                        ' + FORMAT(WORKDATE)) //PRJ-659.RM.1.0 22Oct2021
                        {
                            ToolTip = 'Work Date';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773135; CalcValues[1, 2] * 100)
                        {
                            Editable = false;
                            ToolTip = 'Percent of Actual Costs To Date / Total Budgeted Cost';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773134; CalcValues[2, 1])
                        {
                            Editable = false;
                            ToolTip = 'Actual Costs To Date';
                            ApplicationArea = all;

                            trigger OnDrillDown();
                            begin
                                //ProjectPro - start
                                ShowJobRec.RESET;
                                ShowJobRec := Rec;
                                ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE());
                                ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgEntry."Entry Type"::Usage);
                                JobLedgerEntries.NS_SetFilters(ShowJobRec, FALSE);
                                JobLedgerEntries.RUNMODAL;
                                CLEAR(JobLedgerEntries);
                                //ProjectPro - end
                            end;
                        }
                        field(NS_Control1100773248; CalcValues[1, 3])
                        {
                            Editable = false;
                            ToolTip = 'Total Budgeted Cost - Actual Costs To Date';
                            ApplicationArea = all;
                        }
                        //PRJ-1349.GK.1.0 09May2022 start
                        field("NS_BudgetedCost(LCY)"; BudgetCostLCYForProjectionA)   //PRJ-1349.JS.1.0 15MAY2022
                        {
                            Editable = false;
                            ToolTip = 'Specifies the Budgeted Cost (LCY)';
                            ApplicationArea = all;
                            Caption = 'Budgeted Total Cost';

                            trigger OnDrillDown();
                            begin
                                if JobSetup.Get() then; //PRJCTPR-162.RM.1.0 20July2023 
                                if JobSetup."NS_Budgeted Cost on Projection" = true then begin //PRJCTPR-162.RM.1.0 20July2023 
                                    JobPlanningList.SetFilters(Rec."No.", 0);
                                    JobPlanningList.RUNMODAL(); //PRJCTPR-162.RM.1.0 20July2023 
                                    CLEAR(JobPlanningList);
                                end else //PRJCTPR-162.RM.1.0 20July2023 
                                    exit; //PRJCTPR-162.RM.1.0 20July2023 
                            end;

                        }
                        //PRJ-640.N.S.1.0 Start Comment
                        // field("NS_BudgetedCost(LCY)"; "NS_Budgeted Cost (LCY)")
                        // {
                        //     Editable = false;
                        //     ToolTip = 'Specifies the Budgeted Cost (LCY)';
                        //     ApplicationArea = all;

                        //     trigger OnDrillDown();
                        //     begin
                        //         //ProjectPro - start
                        //         JobPlanningList.SetFilters("No.", 0);
                        //         JobPlanningList.RUNMODAL;
                        //         CLEAR(JobPlanningList);
                        //         //ProjectPro - end
                        //     end;
                        // }
                        //PRJ-640.N.S.1.0 END Comment
                        //PRJ-1349.GK.1.0 09May2022 end                        
                        field(NS_Control1100773127; CalcValues[1, 5])
                        {
                            Editable = false;
                            ToolTip = 'Total Contract - Total Budgeted Cost';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773125; CalcValues[1, 6] * 100)
                        {
                            Editable = false;
                            ToolTip = 'Percent of Estimated Profit (Loss) / Total Budgeted Cost';
                            ApplicationArea = all;
                        }
                    }
                    group("NS_Projected")
                    {
                        Caption = '                        Projected'; //PRJ-659.RM.1.0 22Oct2021
                        field(NS_ActualPercentCompleteDate; '                     ' + FORMAT("NS_Actual PercentCompleteDate"))
                        {
                            Editable = false;
                            ToolTip = '% Job Actually Complete Date from the Constants/Manager tab';
                            ApplicationArea = all;
                        }
                        field(NS_ActualPercentComplete; "NS_Actual Percent Complete")
                        {
                            Editable = false;
                            ToolTip = '% Job Actually Complete from the Constants/Manager tab';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773130; CalcValues[2, 1])
                        {
                            Editable = false;
                            ToolTip = 'Actual Costs To Date';
                            ApplicationArea = all;

                            trigger OnDrillDown();
                            begin
                                //ProjectPro - start
                                ShowJobRec.RESET;
                                ShowJobRec := Rec;
                                ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE());
                                ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgEntry."Entry Type"::Usage);
                                JobLedgerEntries.NS_SetFilters(ShowJobRec, FALSE);
                                JobLedgerEntries.RUNMODAL;
                                CLEAR(JobLedgerEntries);
                                //ProjectPro - end
                            end;
                        }
                        field(NS_Control1100773128; CalcValues[1, 13])
                        {
                            Editable = false;
                            ToolTip = 'Actual Costs To Date / (Entered Complete / 100)';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773126; CalcValues[2, 3])
                        {
                            Editable = false;
                            ToolTip = 'Actual Costs To Date / (Actual Percent Complete  from Constants/Manager tab / 100)';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773124; CalcValues[2, 7])
                        {
                            Editable = false;
                            ToolTip = 'Total Contract - Projected Total Costs';
                            ApplicationArea = all;
                        }
                        field(NS_Control1100773122; CalcValues[2, 8] * 100)
                        {
                            Editable = false;
                            ToolTip = 'Projected Profit (Loss) / Projected Total Costs';
                            ApplicationArea = all;
                        }
                    }
                    group(NS_Control1100773123)
                    {
                        Caption = '';
                        field(NS_Spacer1; '')
                        {
                            Caption = '.';
                            ApplicationArea = all;
                        }
                    }
                    group(NS_Control1100773249)
                    {
                        Caption = '';
                        field(NS_Spacer2; '')
                        {
                            Caption = '.';
                            ApplicationArea = all;
                        }
                    }
                    group(NS_Control1100773273)
                    {
                        Caption = '';
                        field(NS_Spacer3; '')
                        {
                            Caption = '.';
                            ApplicationArea = all;
                        }
                    }

                }
            }
        }
        addafter("To Post")
        {
            field(NS_ARRetentionBalance; CalcValues[3, 1])
            {
                ApplicationArea = All;
                Caption = 'A/R Retention Balance';
                Editable = false;
                Importance = Promoted;
                ToolTip = 'Retention Balance in Customer Card for this Job';

                trigger OnDrillDown();
                begin
                    //ProjectPro - start
                    with CustLedgEntryRetention do begin
                        CLEARMARKS;
                        if not SalesSetup."NS_Sales Retention Inactive" then begin
                            RESET;
                            SETCURRENTKEY("Document Type", "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                            SETRANGE("Customer No.", "Bill-to Customer No.");
                            SetRange("NS_Job No.", Rec."No.");//PRJCTPR-48.Dk.0.1
                            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
                            if FINDSET then
                                repeat
                                    case "Document Type" of
                                        "Document Type"::Invoice:
                                            begin
                                                SalesInvoiceLine.RESET;
                                                SalesInvoiceLine.SETRANGE("Document No.", "Document No.");
                                                SalesInvoiceLine.SETRANGE("Job No.", "No.");
                                                if SalesInvoiceLine.FINDSET then
                                                    repeat
                                                        MARK(true);
                                                    until SalesInvoiceLine.NEXT = 0;
                                            end;
                                        "Document Type"::"Credit Memo":
                                            begin
                                                SalesCrMemoLine.RESET;
                                                SalesCrMemoLine.SETRANGE("Document No.", "Document No.");
                                                SalesInvoiceLine.SETRANGE("Job No.", "No.");
                                                if SalesCrMemoLine.FINDSET then
                                                    repeat
                                                        MARK(true);
                                                    until SalesCrMemoLine.NEXT = 0;
                                            end;
                                        "Document Type"::Payment:
                                            MARK(true);
                                    end;
                                until NEXT = 0;
                        end;
                    end;
                    CustLedgEntryRetention.MARKEDONLY(true);
                    PAGE.RUN(PAGE::"Customer Ledger Entries", CustLedgEntryRetention);
                    //ProjectPro - end
                end;
            }
            field(NS_APRetentionBalance; CalcValues[3, 2])
            {
                ApplicationArea = All;
                Caption = 'A/P Retention Balance';
                Editable = false;
                ToolTip = 'Retention Balance in Vendor Card for this Job';

                trigger OnDrillDown();
                begin
                    //ProjectPro - start
                    with VendLedgEntryRetention do begin
                        CLEARMARKS;
                        if not PurchSetup."NS_Purchase Retention Inactive" then begin
                            RESET;
                            SETCURRENTKEY("Document Type", "Vendor No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date", "Currency Code", "NS_Retention Ledger Code");
                            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
                            if FIND('-') then
                                repeat
                                    case "Document Type" of
                                        "Document Type"::Invoice:
                                            begin
                                                PurchInvLine.RESET;
                                                PurchInvLine.SETRANGE("Document No.", "Document No.");
                                                PurchInvLine.SETRANGE("Job No.", "No.");
                                                if PurchInvLine.FIND('-') then
                                                    repeat
                                                        MARK(true);
                                                    until PurchInvLine.NEXT = 0;
                                            end;
                                        "Document Type"::"Credit Memo":
                                            begin
                                                PurchCrMemoLine.RESET;
                                                PurchCrMemoLine.SETRANGE("Document No.", "Document No.");
                                                PurchCrMemoLine.SETRANGE("Job No.", "No.");
                                                if PurchCrMemoLine.FIND('-') then
                                                    repeat
                                                        MARK(true);
                                                    until PurchCrMemoLine.NEXT = 0;
                                            end;
                                        "Document Type"::Payment:
                                            MARK(true);
                                    end;
                                until NEXT = 0;
                        end;
                    end;
                    VendLedgEntryRetention.MARKEDONLY(true);
                    PAGE.RUN(PAGE::"Vendor Ledger Entries", VendLedgEntryRetention);
                    //ProjectPro - end
                end;
            }
            field(NS_WIP_Method; Rec."WIP Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the WIP Method';
            }

            field(NS_WIPPostingDate; Rec."WIP Posting Date")
            {
                ApplicationArea = Jobs;
                Editable = false;
                ToolTip = 'Specifies the posting date that was entered when the Job Calculate WIP batch job was last run.';
            }
            field("NS_WIP G/L Posting Date2"; Rec."WIP G/L Posting Date")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the WIP G/L Posting Date';
            }
            field("NS_FORMAT(CalcValues[3,5],0,'<Precision,0:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(CalcValues[3, 5], 0, '<Precision,0:2><Sign><Integer Thousand><Decimals>') + '%')
            {
                ApplicationArea = All;
                Caption = 'Contract Billed';
                DrillDownPageID = "Purchase List";
                Editable = false;
                ToolTip = 'Percent of Job To Date Invoice Billed / Total Contract';
            }
            field("NS_CalcValues[3,6]"; CalcValues[3, 6])
            {
                ApplicationArea = All;
                Caption = 'Over/Under Billed';
                Editable = false;
                ToolTip = 'Invoiced Price - ((Total Contract + Contract Sub-Levels) * Actual Cost To Date % (Up to 100%))';
            }
            field("NS_CalcValues[3,7]"; CalcValues[3, 7])
            {
                ApplicationArea = All;
                Caption = 'Contract Back Log';
                Editable = false;
                ToolTip = 'Total Contract - Invoice Billed Job To Date';
            }
        }
        moveafter("NS_WIP_Method"; "Recog. Costs G/L Amount")
        moveafter("Recog. Costs G/L Amount"; "Recog. Sales G/L Amount")
        moveafter("NS_WIP_Method"; "Total WIP Cost G/L Amount")
        moveafter("Total WIP Cost G/L Amount"; "Total WIP Sales G/L Amount")
        moveafter("Total WIP Sales G/L Amount"; "Recog. Costs Amount")
        moveafter("Recog. Costs G/L Amount"; "Recog. Sales Amount")
        moveafter("NS_WIP_Method"; "Total WIP Cost Amount")
        addafter("WIP and Recognition")
        {
            group("NS_Cost Categories $")
            {
                Caption = 'Cost Categories $';
                fixed(NS_Control1100773259)
                {
                    Caption = '';
                    group("NS_PROJECTPRO COSTS")
                    {
                        Caption = 'PROJECTPRO COSTS';
                        field(NS_LaborCostLbl; NS_LaborCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Labor Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_MaterialCostLbl; NS_MaterialCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Material Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_EquipmentCostLbl; NS_EquipmentCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Equipment Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_SubcontractCostLbl; NS_SubcontractCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the  Budgeted Subcontract Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_MfgCostLbl; NS_MfgCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Manufacturing Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_OverheadCostLbl; NS_OverheadCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Overhead Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_MiscellaneousCostLbl; NS_MiscellaneousCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Miscellaneous Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_UncategorizedCostLbl; NS_UncategorizedCostLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Uncategorized Cost Amount Total';
                            Caption = '';
                        }
                        field(NS_CostTotasLbl; NS_CostTotasLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Uncategorized Cost Amount Total';
                            Caption = '';
                        }
                    }
                    group("NS_Budget Cost")
                    {
                        Caption = 'Budget Cost';
                        field("NS_CalcValues[4,1]"; CalcValues[4, 1])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Labor Cost Amount Total';
                        }
                        field("NS_CalcValues[4,5]"; CalcValues[4, 5])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Material Cost Amount Total';
                        }
                        field("NS_CalcValues[4,9]"; CalcValues[4, 9])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Equipment Cost Amount Total';
                        }
                        field("NS_CalcValues[4,13]"; CalcValues[4, 13])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Subcontract Cost Amount Total';
                        }
                        field("NS_CalcValues[4,17]"; CalcValues[4, 17])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Manufacturing Cost Amount Total';
                        }
                        field("NS_CalcValues[4,21]"; CalcValues[4, 21])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Overhead Cost Amount Total';
                        }
                        field("NS_CalcValues[4,25]"; CalcValues[4, 25])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Miscellaneous Cost Amount Total';
                        }
                        field("NS_CalcValues[4,29]"; CalcValues[4, 29])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Budget Cost';
                            Editable = false;
                            ToolTip = 'Budgeted Uncategorized Cost Amount Total';
                        }
                        field("NS_CalcValues[4,33]"; CalcValues[4, 33])
                        {
                            ApplicationArea = All;
                            Caption = 'Cost Budget Totals';
                            Editable = false;
                            ToolTip = 'Total Budgeted Cost Amount';
                        }
                    }
                    group("NS_Actual Cost")
                    {
                        Caption = 'Actual Cost';
                        field("NS_CalcValues[4,2]"; CalcValues[4, 2])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Labor Cost Amount Total';
                        }
                        field("NS_CalcValues[4,6]"; CalcValues[4, 6])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Material Cost Amount Total';
                        }
                        field("NS_CalcValues[4,10]"; CalcValues[4, 10])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Equipment Cost Amount Total';
                        }
                        field("NS_CalcValues[4,14]"; CalcValues[4, 14])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Subcontract Cost Amount Total';
                        }
                        field("NS_CalcValues[4,18]"; CalcValues[4, 18])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Manufacturing Cost Amount Total';
                        }
                        field("NS_CalcValues[4,22]"; CalcValues[4, 22])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Overhead Cost Amount Total';
                        }
                        field("NS_CalcValues[4,26]"; CalcValues[4, 26])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Miscellaneous Cost Amount Total';
                        }
                        field("NS_CalcValues[4,30]"; CalcValues[4, 30])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Actual Cost';
                            Editable = false;
                            ToolTip = 'Actual Uncategorized Cost Amount Total';
                        }
                        field("NS_CalcValues[4,34]"; CalcValues[4, 34])
                        {
                            ApplicationArea = All;
                            Caption = 'Cost Actual Totals';
                            Editable = false;
                            ToolTip = 'Total Actual Cost Amount';
                        }
                    }
                    group("NS_Cost Variance")
                    {
                        Caption = 'Cost Variance';
                        field("NS_CalcValues[4,3]"; CalcValues[4, 3])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Cost Variance';
                            Editable = false;
                            ToolTip = 'Labor Budget - Labor Actual';
                        }
                        field("NS_CalcValues[4,7]"; CalcValues[4, 7])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Cost Variance';
                            Editable = false;
                            ToolTip = 'Material Budget - Material Actual';
                        }
                        field("NS_CalcValues[4,11]"; CalcValues[4, 11])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Cost Variance';
                            Editable = false;
                            ToolTip = 'Equipment Budget - Equipment Actual';
                        }
                        field("NS_CalcValues[4,15]"; CalcValues[4, 15])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Cost Variance';
                            Editable = false;
                            ToolTip = 'Subcontract Budget - Subcontract Actual';
                        }
                        field("NS_CalcValues[4,19]"; CalcValues[4, 19])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Cost Variance';
                            Editable = false;
                            ToolTip = 'Manufacturing Budget - Manufacturing Actual';
                        }
                        field("NS_CalcValues[4,23]"; CalcValues[4, 23])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Cost Variance';
                            Editable = false;
                            ToolTip = 'Overhead Budget - Overhead Actual';
                        }
                        field("NS_CalcValues[4,27]"; CalcValues[4, 27])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Cost Variance';
                            Editable = false;
                            ToolTip = 'Miscellaneous Budget - Miscellaneous Actual';
                        }
                        field("NS_CalcValues[4,31]"; CalcValues[4, 31])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Cost Variance';
                            Editable = false;
                            ToolTip = 'Uncategorized Budget - Uncategorized Actual';
                        }
                        field("NS_CalcValues[4,35]"; CalcValues[4, 35])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Cost Varaiance';
                            Editable = false;
                            ToolTip = 'Total Budgeted - Total Actual';
                        }
                    }
                    group("NS_Cost Variance %")
                    {
                        Caption = 'Cost Variance %';
                        field("NS_CalcValues[4,4]"; CalcValues[4, 4])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Labor Variance / Labor Budget';
                        }
                        field("NS_CalcValues[4,8]"; CalcValues[4, 8])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Material Variance / Material Budget';
                        }
                        field("NS_CalcValues[4,12]"; CalcValues[4, 12])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Equipment Variance / Equipment Budget';
                        }
                        field("NS_CalcValues[4,16]"; CalcValues[4, 16])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Subcontract Variance / Subcontract Budget';
                        }
                        field("NS_CalcValues[4,20]"; CalcValues[4, 20])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Manufacturing Variance / Manufacturing Budget';
                        }
                        field("NS_CalcValues[4,24]"; CalcValues[4, 24])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Overhead Variance / Overhead Budget';
                        }
                        field("NS_CalcValues[4,28]"; CalcValues[4, 28])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Miscellaneous Variance / Miscellaneous Budget';
                        }
                        field("NS_CalcValues[4,32]"; CalcValues[4, 32])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Cost Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Uncategorized Variance / Uncategorized Budget';
                        }
                        field("NS_CalcValues[4,36]"; CalcValues[4, 36])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Cost Varaiance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Total Variance / Total Budget';
                        }
                    }
                    group(NS_Control1100773271)
                    {
                        Caption = '';
                        field(NS_Spacer4; '')
                        {
                            Caption = '.';
                            ApplicationArea = all;
                        }
                    }
                }
            }
            group("NS_Rev Categories $")
            {
                Caption = 'Rev Categories $';
                Visible = NSDisableRevCateFactBoxobJobCard;  //PRJCTPR-346.JS.1.0 04MAR2024 
                fixed(NS_Control1100773275)
                {
                    Caption = '';
                    group("NS_PROJECTPRO REVENUE")
                    {
                        Caption = 'PROJECTPRO REVENUE';
                        field(NS_LaborRevLbl; NS_LaborRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Labor Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MaterialRevLbl; NS_MaterialRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Material Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_EquipmentRevLbl; NS_EquipmentRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Equipment Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_SubcontractRevLbl; NS_SubcontractRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Subcontract Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MfgRevLbl; NS_MfgRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Manufacturing Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_OverheadRevLbl; NS_OverheadRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Overhead Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_MiscellaneousRevLbl; NS_MiscellaneousRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Miscellaneous Revenue Amount';
                            Caption = '';
                        }
                        field(NS_UncategorizedRevLbl; NS_UncategorizedRevLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Budgeted Uncategorized Revenue Amount Total';
                            Caption = '';
                        }
                        field(NS_RevenueTotalsLbl; NS_RevenueTotalsLbl)
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the Total Budgeted Revenue Amount';
                            Caption = '';
                        }
                    }
                    group("NS_Budget Revenue")
                    {
                        Caption = 'Budget Revenue';
                        field("NS_CalcValues[5,1]"; CalcValues[5, 1])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Labor Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,5]"; CalcValues[5, 5])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Material Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,9]"; CalcValues[5, 9])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Equipment Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,13]"; CalcValues[5, 13])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Subcontract Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,17]"; CalcValues[5, 17])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Manufacturing Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,21]"; CalcValues[5, 21])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Overhead Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,25]"; CalcValues[5, 25])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Miscellaneous Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,29]"; CalcValues[5, 29])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Budget Revenue';
                            Editable = false;
                            ToolTip = 'Budgeted Uncategorized Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,33]"; CalcValues[5, 33])
                        {
                            ApplicationArea = All;
                            Caption = 'Revenue Budget Totals';
                            Editable = false;
                            ToolTip = 'Total Budgeted Revenue Amount';
                        }
                    }
                    group("NS_Actual Revenue")
                    {
                        Caption = 'Actual Revenue';
                        field("NS_CalcValues[5,2]"; CalcValues[5, 2])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Labor Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,6]"; CalcValues[5, 6])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Material Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,10]"; CalcValues[5, 10])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipmentl Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Equipment Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,14]"; CalcValues[5, 14])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontractl Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Subcontract Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,18]"; CalcValues[5, 18])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Manufacturing Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,22]"; CalcValues[5, 22])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Overhead Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,26]"; CalcValues[5, 26])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Miscellaneous Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,30]"; CalcValues[5, 30])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Uncategorized Revenue Amount Total';
                        }
                        field("NS_CalcValues[5,34]"; CalcValues[5, 34])
                        {
                            ApplicationArea = All;
                            Caption = 'Revenue Actual Revenue';
                            Editable = false;
                            ToolTip = 'Actual Revenue Amount Total';
                        }
                    }
                    group("NS_Revenue Variance")
                    {
                        Caption = 'Revenue Variance';
                        field("NS_CalcValues[5,3]"; CalcValues[5, 3])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Revenue Variance';
                            Editable = false;
                            ToolTip = 'Labor Budget - Labor Actual';
                        }
                        field("NS_CalcValues[5,7]"; CalcValues[5, 7])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Revenue Variance';
                            Editable = false;
                            ToolTip = 'Material Budget - Material Actual';
                        }
                        field("NS_CalcValues[5,11]"; CalcValues[5, 11])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Revenue Variance';
                            Editable = false;
                            ToolTip = 'Equipment Budget - Equipment Actual';
                        }
                        field("NS_CalcValues[5,15]"; CalcValues[5, 15])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Revenue Variance';
                            Editable = false;
                            ToolTip = 'Subcontract Budget - Subcontract Actual';
                        }
                        field("NS_CalcValues[5,19]"; CalcValues[5, 19])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Revenue Variance';
                            Editable = false;
                            ToolTip = 'Manufacturing Budget - Manufacturing Actual';
                        }
                        field("NS_CalcValues[5,23]"; CalcValues[5, 23])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Revenue Variance';
                            Editable = false;
                            ToolTip = 'Overhead Budget - Overhead Actual';
                        }
                        field("NS_CalcValues[5,27]"; CalcValues[5, 27])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance';
                            Editable = false;
                            ToolTip = 'Miscellaneous Budget - Miscellaneous Actual';
                        }
                        field("NS_CalcValues[5,31]"; CalcValues[5, 31])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized Revenue Variance';
                            Editable = false;
                            ToolTip = 'Uncategorized Budget - Uncategorized Actual';
                        }
                        field("NS_CalcValues[5,35]"; CalcValues[5, 35])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revenue Variance';
                            Editable = false;
                            ToolTip = 'Total Budgeted - Total Actual';
                        }
                    }
                    group("NS_Revenue Variance %")
                    {
                        Caption = 'Revenue Variance %';
                        field("NS_CalcValues[5,4]"; CalcValues[5, 4])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Labor Variance / Labor Budget';
                        }
                        field("NS_CalcValues[5,8]"; CalcValues[5, 8])
                        {
                            ApplicationArea = All;
                            Caption = 'Material Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Material Variance / Material Budget';
                        }
                        field("NS_CalcValues[5,12]"; CalcValues[5, 12])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Equipment Variance / Equipment Budget';
                        }
                        field("NS_CalcValues[5,16]"; CalcValues[5, 16])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Subcontract Variance / Subcontract Budget';
                        }
                        field("NS_CalcValues[5,20]"; CalcValues[5, 20])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Manufacturing Variance / Manufacturing Budget';
                        }
                        field("NS_CalcValues[5,24]"; CalcValues[5, 24])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Overhead Variance / Overhead Budget';
                        }
                        field("NS_CalcValues[5,28]"; CalcValues[5, 28])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Miscellaneous Variance / Miscellaneous Budget';
                        }
                        field("NS_CalcValues[5,32]"; CalcValues[5, 32])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Uncategorized Variance / Uncategorized Budget';
                        }
                        field("NS_CalcValues[5,36]"; CalcValues[5, 36])
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revenue Variance Pct';
                            Editable = false;
                            ToolTip = 'Percent of Total Variance / Total Budget';
                        }
                    }
                    group(NS_Control1100773288)
                    {
                        Caption = '';
                        field(NS_Spacer5; '')
                        {
                            ApplicationArea = All;
                            Caption = '.';
                        }
                    }
                }
            }
        }
        //CTSI-285.MS.1.0
        addafter(Status)
        {
            field("NS_Revenue Recognized"; REC."NS_Revenue Recognized")
            {
                ApplicationArea = all;
            }
        }
        //CTSI.285.MS.1.0

        //PPAL-12.AM  Comment start
        // addbefore("Attached Documents")
        // {
        //     part(NS_Control1100773142; "NS_Job Budget/Billable FactBox")
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = "No." = FIELD("No.");
        //         Caption = 'Job Budget/Billable FactBox';
        //     }
        //     part(NS_Control1100773290; "NS_Job AdjtdBudBillableFactBox")
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = "No." = FIELD("No.");
        //         Visible = false;
        //         Caption = 'Job Adjtd Bud/Billable FactBox';
        //     }
        //     part(NS_Control1100773153; "NS_Actual CostBillingsFactBox")
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = "No." = FIELD("No.");
        //         Caption = 'Actual Cost/Billings FactBox';
        //     }
        //     part(NS_Control1100773237; NS_BudgAnalysisProfitsFactBox)
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = "No." = FIELD("No.");
        //         Caption = 'Budg. Analysis/Profits FactBox';
        //     }
        // }
        //PPAL-12.AM Comment End

        //FGH-16.SK.1.0 STart
        addafter(Posting)
        {
            group(NS_RevRec)
            {
                Caption = 'Rev Rec POC Calculation';
                field("NS_POC Method"; Rec."NS_POC Method")
                {
                    ApplicationArea = all;
                    Caption = 'POC Method';
                    ToolTip = 'Specification of POC method';
                    trigger OnValidate()
                    var
                        SubLevelJobs: Record Job;
                        NSSubLevelJobs: Record Job;  //PRJCTPR-371.JS.1.0 15MAY2024
                        ConfirmMgt: Codeunit "Confirm Management";
                        Text01_Msg: Label 'Do you want to update this POC method on the sub level jobs?';
                    begin
                        NS_SetFieldsEditable();
                        if Rec."NS_POC Method" <> Rec."NS_POC Method"::" " then
                            if Rec."NS_Sub-Level to Job No." = '' then begin  //PRJCTPR-371.JS.1.0 15MAY2024 line modify
                                //PRJCTPR-371.JS.1.0 15MAY2024-Start
                                NSSubLevelJobs.Reset();
                                NSSubLevelJobs.SetRange(NSSubLevelJobs."NS_Sub-Level to Job No.", Rec."No.");
                                If NSSubLevelJobs.FindSet() then begin
                                    //PRJCTPR-371.JS.1.0 15MAY2024-end    
                                    if ConfirmMgt.GetResponse(Text01_Msg, true) then begin
                                        SubLevelJobs.Reset();
                                        SubLevelJobs.SetRange(SubLevelJobs."NS_Sub-Level to Job No.", Rec."No.");
                                        // If SubLevelJobs.FindSet() then
                                        //     SubLevelJobs.Modifyall(SubLevelJobs."NS_POC Method", Rec."NS_POC Method");

                                        //FGH-16.AS.1.0 18JAN2022 START
                                        If SubLevelJobs.FindSet() then
                                            repeat
                                                SubLevelJobs.Validate("NS_POC Method", Rec."NS_POC Method");
                                                SubLevelJobs.Modify();
                                            until SubLevelJobs.Next() = 0;
                                        //FGH-16.AS.1.0 18JAN2022 END
                                    end;
                                end; //PRJCTPR-371.JS.1.0 15MAY2024 line added
                            end; //PRJCTPR-371.JS.1.0 15MAY2024 line added
                    end;


                }
                field("NS_POC Method Value"; Rec."NS_POC Method Value")
                {
                    ApplicationArea = all;
                    Caption = 'POC Method Value';
                    ToolTip = 'Specification of POC Method Value';
                    Editable = POCMethodValueVar;
                }

                field("NS_Total Units"; Rec."NS_Total Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Units';
                    Editable = TotalUnitsVar;
                }
                field("NS_Actual Percent Complete"; Rec."NS_Actual Percent Complete")
                {
                    ApplicationArea = All;
                    Caption = '% Job Actually Complete';
                    DecimalPlaces = 0 : 2;
                    Editable = PercJobActuallyCompleteVar;
                    //ToolTip = 'Specifies the % Job Actually Complete';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the actual percenatge complete of the Job';//PRJ-769.RS.1.0 8July21

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        NS_CalcStatistics;
                        //ProjectPro - end
                    end;
                }
                field("NS_Actual Percent Complete Date"; Rec."NS_Actual PercentCompleteDate")
                {
                    ApplicationArea = All;
                    Caption = 'Job Completed % Date';
                    Editable = JobCompletedDateVar;
                    //ToolTip = 'Specifies the Job Completed % Date';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the actual percenatge complete date of the Job';//PRJ-769.RS.1.0 8July21

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        NS_CalcStatistics;
                        //ProjectPro - end
                    end;
                }
                field("NS_Actual Units Complete"; Rec."NS_Actual Units Complete")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Units Complete';
                    DecimalPlaces = 0 : 0;
                    Editable = ActualUnitsCompleteVar;
                    //ToolTip = 'Specifies the Actual Units Complete';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the actual unit complete of the Job';//PRJ-769.RS.1.0 8July21
                }
                field("NS_Actual Units Complete Date"; Rec."NS_Actual Units Complete Date")
                {
                    ApplicationArea = All;
                    Caption = 'Units Completed % Date';
                    Editable = UnitsCompletedDateVar;
                    //ToolTip = 'Specifies the Units Completed % Date';//PRJ-769.RS.1.0 8July21 Commented
                    ToolTip = 'Specifies the actual unit complete date of the Job';//PRJ-769.RS.1.0 8July21
                }
                field("NS_POC Method Value Date"; Rec."NS_POC Method Value Date")
                {
                    ApplicationArea = all;
                    Caption = 'POC Method Value Date';
                    ToolTip = 'Specification of POC Method Value Date';
                    Editable = false;
                }
                //PE-270.AS.1.0 START
                field(NS_EnableOverrideForecastonJFW; Rec.NS_EnableOverrideForecastonJFW)
                {
                    ApplicationArea = all;
                    Caption = 'Enable Override Forecast on JFW';
                    //PE-270.JS.1.0 06MAY2024
                    ToolTip = 'Enable this to edit the “Override Forecasted Completed Cost” on the job forecast worksheet instead of the Job Task Lines. Please note that only one of them works at the same time and the sublevels values are not included in this case. For any existing values on the job task lines under the same field will not be considered and the values on the forecast will take precedent.';
                }
                //PE-270.AS.1.0 END
                //PE-287.JS.1.0 30APR2024-Start
                field(NS_UpdJFWForecastCompCostOnJT; Rec.NS_UpdJFWForecastCompCostOnJT)
                {
                    Caption = 'Enable JFW Forecasted Completed Cost on JTL';
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want to carry over latest “Forecasted Completed Cost” value from JFW to job task line’s “JFW Forecasted Completed Cost” column if the POC method on the job card is either set to “Blank” or “Job Forecast”. This also ensures that the “Batch Posting of Job Forecast Worksheets” uses these values to calculate TCE on the rev rec summary details for the same POC methods.';
                }
                //PE-287.JS.1.0 30APR2024-End
                //PE-299.JS.1.0 17MAY2024-Start
                field("NS_Push-OrV2JFWForecastedonJTL"; Rec."NS_Push-OrV2JFWForecastedonJTL")
                {
                    Caption = 'Push Override Values to JFW Forecasted on JTL';
                    ApplicationArea = All;
                    ToolTip = 'Enable this to auto-update the values on job task lines from Override Forecasted Completed Cost to JFW Forecasted Completed Cost”. Please note that this will work only if the “Enable JFW Forecasted Completed Cost on JTL” setup is ON. This is defaulted from the job setup and can be modified at the job level.';
                }
                //PE-299.JS.1.0 17MAY2024-end

            }

        }

        moveafter("NS_Actual Units Complete Date"; "% Completed")
        modify("% Completed")
        {
            Editable = PercCompletedVar;
        }
        moveafter("% Completed"; "% Invoiced")
        modify("% Invoiced")
        {
            Editable = PercInvoicedVar;
        }
        modify(Status)
        {
            //PE-193.PS.1.0 07Nov2023 Start 
            Editable = NSReturnManagerStatus;
            //PE-193.PS.1.0 07Nov2023 End 
            trigger OnAfterValidate()
            var
                RevRecSummDetails: Record NS_RevenueRecSummaryTab;
            begin
                IF Rec.Status = Rec.Status::Completed then begin
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            RevRecSummDetails."NS_POC %" := 100;
                            if RevRecSummDetails."NS_POC %" <> 0 then  //PRJCTPR-182.NC.1.0 28Aug2023
                                RevRecSummDetails."NS_Gross Revenue" := (RevRecSummDetails."NS_Current Contract" * RevRecSummDetails."NS_POC %") / 100;
                            RevRecSummDetails."NS_Gross Profit" := RevRecSummDetails."NS_Gross Revenue" - RevRecSummDetails."NS_Actual Costs To Date";
                            if RevRecSummDetails."NS_Gross Revenue" <> 0 then //PRJCTPR-182.NC.1.0 28Aug2023
                                RevRecSummDetails."NS_Current GM %" := (RevRecSummDetails."NS_Gross Profit" / RevRecSummDetails."NS_Gross Revenue") * 100;
                            RevRecSummDetails.Modify();
                        until RevRecSummDetails.Next() = 0;
                end;

                //PE-47.PS.1.0 01May2023 Start 
                if Rec.Status <> xRec.Status then begin
                    Rec."NS_New Run B_OpenJob B Log" := false; //PRJCTPR-122.PS.1.0 14Jun2023
                    Rec.Modify();
                end;

                //PE-47.PS.1.0 01May2023 End 



            end;
        }
        //FGH-16.SK.1.0 End
        //PRJCTPR-192.DK.1.0 9OCT2023 Start
        addafter("NS_Job Country New")
        {
            field("NS_Job Contact New"; Rec."NS_Job Contact")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Contact for the Job';//PRJ-769.RS.1.0 8July21

            }
            field("NS_Job Phone New"; Rec."NS_Job Phone")
            {
                ApplicationArea = All;
                Editable = "Job PhoneEditable";
                //ToolTip = 'Specifies the Job Phone';//PRJ-769.RS.1.0 8July21 Commented
                ToolTip = 'Specifies the Job Phone no. for the Job';//PRJ-769.RS.1.0 8July21
            }

        }
        addbefore("NS_Job Address New1")
        {
            field("NS_Job Ship-to Code New"; Rec."NS_Job Ship-to Code")
            {
                ApplicationArea = All;
                Caption = 'Ship-to Code';
                ToolTip = 'Specifies the Job Ship-to Code for the Job';//PRJ-769.RS.1.0 8July212

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    //PRJ-1135.RM.1.0 Start
                    if JobSetup.Get() then;//PRJCTPR-192.DK.1.0 15SEP2023
                    if Rec."NS_Job Ship-to Code" > '' then begin
                        //PRJCTPR-192.DK.1.0 15SEP2023 START
                        if JobSetup."NS_Sell-to Cust_Ship-to Code" then
                            ShipToAddress.GET(Rec."Sell-to Customer No.", Rec."NS_Job Ship-to Code")
                        else
                            ShipToAddress.GET(Rec."Bill-to Customer No.", Rec."NS_Job Ship-to Code");
                        //PRJCTPR-192.DK.1.0 15SEP2023 END
                        Rec."NS_Job Address 1" := ShipToAddress.Address;
                        Rec."NS_Job Address 2" := ShipToAddress."Address 2";
                        Rec."NS_Job City" := ShipToAddress.City;
                        Rec."NS_Job County" := ShipToAddress.County;
                        Rec."NS_Job Post Code" := ShipToAddress."Post Code";
                        Rec."NS_Job Country/Region Code" := ShipToAddress."Country/Region Code";
                        Rec."NS_Job Contact" := ShipToAddress.Contact;
                        Rec."NS_Job Phone" := ShipToAddress."Phone No.";
                        Rec."NS_Tax Area Code" := ShipToAddress."Tax Area Code";
                        Rec."NS_Tax Liable" := ShipToAddress."Tax Liable";
                    end else begin
                        Rec."NS_Job Address 1" := '';
                        Rec."NS_Job Address 2" := '';
                        Rec."NS_Job City" := '';
                        Rec."NS_Job County" := '';
                        Rec."NS_Job Post Code" := '';
                        Rec."NS_Job Country/Region Code" := '';
                        Rec."NS_Job Contact" := '';
                        Rec."NS_Job Phone" := '';
                        if CONFIRM(Text14021100, true) then begin
                            Rec."NS_Tax Area Code" := '';
                            Rec."NS_Tax Liable" := false;
                        end;
                    end;
                    //PRJ-1135.RM.1.0 End
                    NS_BlockShipTo;
                    //ProjectPro - end
                end;
                //  PRJCTPR-192.DK.1.0 15SEP2023 START
                trigger OnDrillDown()
                var
                    NS_Ship_to: Record "Ship-to Address";
                    NS_ShiptoAddress: Page "Ship-to Address List";
                begin
                    NS_Ship_to.Reset();
                    if JobsSetup.Get() then;
                    if not JobsSetup."NS_Sell-to Cust_Ship-to Code" then begin
                        NS_Ship_to.setRange(NS_Ship_to."Customer No.", Rec."Bill-to Customer No.");
                        if NS_Ship_to.findFirst() then begin
                            if PAGE.RUNMODAL(0, NS_ship_to) = ACTION::LookupOK then begin
                                Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                                Rec."NS_Job Address 1" := NS_Ship_to.Address;
                                Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                                Rec."NS_Job City" := NS_Ship_to.City;
                                Rec."NS_Job County" := NS_Ship_to.County;
                                Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                                Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                                Rec."NS_Job Contact" := NS_Ship_to.Contact;
                                Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                                Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                                Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                            end;
                        end else begin
                            if PAGE.RUNMODAL(0, NS_ship_to) = ACTION::LookupOK then begin
                                Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                                Rec."NS_Job Address 1" := NS_Ship_to.Address;
                                Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                                Rec."NS_Job City" := NS_Ship_to.City;
                                Rec."NS_Job County" := NS_Ship_to.County;
                                Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                                Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                                Rec."NS_Job Contact" := NS_Ship_to.Contact;
                                Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                                Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                                Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                            end;
                        end;
                    end;
                    if JobsSetup."NS_Sell-to Cust_Ship-to Code" then begin
                        NS_Ship_to.setRange(NS_Ship_to."Customer No.", Rec."Sell-to Customer No.");
                        if NS_ship_to.findFirst() then begin
                            if PAGE.RUNMODAL(0, NS_Ship_to) = ACTION::LookupOK then begin
                                Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                                Rec."NS_Job Address 1" := NS_Ship_to.Address;
                                Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                                Rec."NS_Job City" := NS_Ship_to.City;
                                Rec."NS_Job County" := NS_Ship_to.County;
                                Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                                Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                                Rec."NS_Job Contact" := NS_Ship_to.Contact;
                                Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                                Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                                Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                            end;
                        end else begin
                            if PAGE.RUNMODAL(0, NS_ship_to) = ACTION::LookupOK then begin
                                Rec."NS_Job Ship-to Code" := NS_Ship_to.code;
                                Rec."NS_Job Address 1" := NS_Ship_to.Address;
                                Rec."NS_Job Address 2" := NS_Ship_to."Address 2";
                                Rec."NS_Job City" := NS_Ship_to.City;
                                Rec."NS_Job County" := NS_Ship_to.County;
                                Rec."NS_Job Post Code" := NS_Ship_to."Post Code";
                                Rec."NS_Job Country/Region Code" := NS_Ship_to."Country/Region Code";
                                Rec."NS_Job Contact" := NS_Ship_to.Contact;
                                Rec."NS_Job Phone" := NS_Ship_to."Phone No.";
                                Rec."NS_Tax Area Code" := NS_Ship_to."Tax Area Code";
                                Rec."NS_Tax Liable" := NS_Ship_to."Tax Liable";
                            end;
                        end;
                    end;
                end;
            }
        }
        // PRJCTPR-192.DK.1.0 9OCT2023 END
    }
    actions
    {
        modify("&Statistics")
        {
            Promoted = false;
        }
        modify("Ledger E&ntries")
        {
            Promoted = false;
        }
        modify("Copy Job Tasks &from...")
        {
            Promoted = false;
        }
        modify("Copy Job Tasks &to...")
        {
            Promoted = false;
        }
        modify("Job Analysis")
        {
            Visible = false;
            Enabled = FALSE;
        }
        modify("Job - Planning Lines")
        {
            Promoted = false;
            Visible = false;

            Enabled = FALSE;
        }
        //PPDA.1.0.TBA Start
        // modify("Job Cost Transaction Detail")
        // {
        //     Promoted = false;
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Job Actual to Budget (Cost)")
        // {
        //     Promoted = false;
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Job Actual to Budget (Price)")
        // {
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Open Purchase Invoices by Job")
        // {
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Open Sales Invoices by Job")
        // {
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Job Cost Suggested Billing")
        // {
        //     Promoted = false;
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        // modify("Job Cost Budget")
        // {
        //     Visible = false;
        // }
        //PPDA.1.0.TBA End
        //PPAL-80.AS.1.0 31JULY2020 - START
        modify("Report Job Quote")
        {
            Visible = false;
        }
        modify("Send Job Quote")
        {
            Visible = false;
        }
        //PPAL-80.AS.1.0 31JULY2020 - END
        addfirst("&Job")
        {
            action("NS_Next")
            {
                Caption = 'Next';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;

                trigger OnAction();
                var
                    NextRec: Record Job;
                begin
                    NS_JobLinkNextRecord(1, Rec, NextRec);
                    Rec := NextRec;
                end;
            }
            action("NS_Previous")
            {
                Caption = 'Previous';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    NextRec: Record Job;
                begin
                    NS_JobLinkNextRecord(-1, Rec, NextRec);
                    Rec := NextRec;
                end;

            }
            action("NS_Job &Task Lines")
            {
                Caption = 'Job &Task Lines';
                Image = TaskList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Task Lines";
                RunPageLink = "Job No." = FIELD("No.");
                ShortCutKey = 'Shift+Ctrl+T';
                ApplicationArea = All;
            }
        }
        //PRJ-1045.GK.1.0 10Nov2021 start
        modify(JobPlanningLines)
        {
            PromotedCategory = Process;
            Promoted = true;
            PromotedIsBig = true;
        }
        //PRJ-1045.GK.1.0 10Nov2021 end
        addafter(JobPlanningLines)
        {
            action("NS_Planning Lines (Editable)")
            {
                Caption = 'Job Planning Lines (&Editable)';
                Image = ServiceLedger;
                Promoted = true;
                //PromotedCategory = Process;// //PRJ-1045.GK.1.0 10Nov2021 comment
                PromotedCategory = Category6; //PRJ-1045.GK.1.0 10Nov2021
                PromotedIsBig = true;
                //RunObject = Page "NS_Job PlanningList(Editable)";	  //PRJ-325.AS.1.0 16JULY2020 Commented
                //RunPageLink = "Job No." = FIELD("No.");//PRJ-325.AS.1.0 16JULY2020 Commented
                ApplicationArea = All;
                //PRJ-325.AS.1.0 16JULY2020 - start
                trigger OnAction();
                var
                    JPLEditable_L: Page "NS_Job PlanningList(Editable)";
                    JPLlineRec: Record "Job Planning Line";
                begin
                    JPLlineRec.Reset();
                    JPLlineRec.SetRange("Job No.", "No.");
                    JPLEditable_L.SetTableView(JPLlineRec);
                    JPLEditable_L.NS_Set("No.");
                    JPLEditable_L.RUNMODAL;
                end;
                //PRJ-325.AS.1.0 16JULY2020 - end
            }
            action("NS_JM Planning")
            {
                Caption = 'Job Material Planning';
                Image = ItemWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    NS_JobMaterialPlanning: Record "NS_Job Material Planning";
                    NS_JobMataterialWorksheet: Page "NS_Job Material Planning Wksht";
                    Text14011100: Label '"""Use Job Material Planning"" Must be Set to Yes for Job No. %1"';
                begin
                    //ProjectPro - start
                    if "NS_Use Job Material Planning" then begin
                        NS_JobMaterialPlanning.SETRANGE("NS_Worksheet Job No.", "No.");
                        NS_JobMataterialWorksheet.SETTABLEVIEW(NS_JobMaterialPlanning);
                        NS_JobMataterialWorksheet.EDITABLE(true);
                        NS_JobMataterialWorksheet.RUN;
                    end else
                        MESSAGE(STRSUBSTNO(Text14011100, "No."));
                    //ProjectPro - end
                end;
            }
            action("NS_Subcontracts")
            {
                Caption = 'Su&bcontracts';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Job Subcontract List";
                RunPageLink = "NS_Job No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("NS_Progress Billings")
            {
                Caption = 'Pro&gress Billings';
                ToolTip = 'Progress Billing feature creates a sales invoice in a progressive manner using methods (%, Units, L/S) over a different time peiod'; //PRJCTPR-126.DK.1.0 24june2023
                Image = CalculateInvoiceDiscount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Job Progress Billing List";
                RunPageLink = "NS_Job No." = FIELD("No.");
                ApplicationArea = All;
                //PRJ-1627.RM.1.0 start
                trigger OnAction()
                var
                    NSJobRec: Record Job;
                begin
                    if NSJobRec.Get(Rec."No.") then;
                    if NSJobRec.Status = NSJobRec.Status::Planning then
                        Error('Job Card''s Status must be Open');

                end;
                //PRJ-1627.RM.1.0 end

            }
            action("NS_Draws")
            {
                Caption = 'Dra&ws';
                ToolTip = 'Draw Feature is the linkage between the Sales documents, Progress billings and the Vendor invoice for the Job. It is used for tracking the bills.'; //PRJCTPR-126.DK.1.0 24june2023
                Image = DepositSlip;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page NS_Draws;
                ApplicationArea = All;
                RunPageLink = "NS_Job No." = FIELD("No.");
            }
            action("NS_Job Forecast Worksheet")
            {
                Caption = 'Job &Forecast Worksheet';
                ToolTip = 'This is an area in your Job that you can enter Estimated Costs to Complete on Task by Task basis. This projects what the "Expected Cost At Completion" will be as compared to the initial Estimate when you started the Job.'; //PRJCTPR-126.DK>1.0
                Image = Forecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var //JD-48.AS.1.0 31OCT2020
                    JobForecastWorksheetbySeg: Page "NS_Job Forecast Work by Seg"; //JD-48.AS.1.0 31OCT2020
                    JobForecastWorksheetbyTaskTotals: Page "NS_JobForecastWrks Task Total";   //PRJ-1299.JS.1.0 19APR2022
                begin
                    //ProjectPro - start
                    if "NS_Forecast Method" = "NS_Forecast Method"::"Job Forecast by Task Code" then begin //JD-48.AS.1.0 31OCT2020
                        JobForecastWorksheet.NS_Set("No.", '', 0D);
                        JobForecastWorksheet.RUN;
                        CLEAR(JobForecastWorksheet);
                    end;
                    //ProjectPro - end

                    if "NS_Forecast Method" = "NS_Forecast Method"::"Job Forecast by Segment Code" then begin //JD-48.AS.1.0 31OCT2020
                        JobForecastWorksheetbySeg.NS_Set("No.", '', 0D);
                        JobForecastWorksheetbySeg.RUN;
                        Clear(JobForecastWorksheetbySeg);
                    end;
                    //JD-48.AS.1.0 31OCT2020 - end
                    //PRJ-1299.JS.1.0 19APR2022 Start
                    if Rec."NS_Forecast Method" = Rec."NS_Forecast Method"::"Job Forecast by Task Totals" then begin //JD-48.AS.1.0 31OCT2020 //PRJ-1135.RM.1.0
                        JobForecastWorksheetbyTaskTotals.NS_SetTaskTotals(Rec."No.", '', 0D, true);
                        JobForecastWorksheetbyTaskTotals.RUN;
                        Clear(JobForecastWorksheetbyTaskTotals);
                    end;
                    //PRJ-1299.JS.1.0 19APR2022 end
                end;
            }
            //PRJ-949.GK.1.0 01Oct2021 start
            action("NS_Crews")
            {
                Caption = 'Crews';
                ToolTip = 'Click on Crews to assign a Crew to a Job'; //PRJCTPR-126.DK.1.0 24june2023
                Image = TeamSales;//PRJ-991.GK.1.0 14Oct2021
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_ Job Crew List";
                ApplicationArea = All;
                RunPageLink = "NS_Job No." = FIELD("No.");
            }
            //PRJ-949.GK.1.0 01Oct2021 end
            //PRJ-1586.NK.1.0 09Sep2022 Start
            action("NS_Job Task Line Worksheet")
            {
                Caption = 'Job Task Line Worksheet';
                ToolTip = 'On this page we have various filters that can be applied at different Task levels. It also shows the Total Task Summary.'; //PRJCTPR-126.1.0
                Image = Forecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    NS_JobTaskLineWorksheet: Page "NS_Job Task Line Worksheet";
                begin
                    NS_JobTaskLineWorksheet.NS_Set(Rec."No.");
                    NS_JobTaskLineWorksheet.RUN;
                    CLEAR(NS_JobTaskLineWorksheet);
                end;
                //PRJ-1586.NK.1.0 09Sep2022 End
            }
            //PRJ-1184.JS.1.0 10FEB2022 Start
            //PE-178.JS.1.0 16NOV2023 - Start
            action(NSProjectProAI)
            {
                ApplicationArea = All;
                Caption = 'ProjectPro AI';
                Image = Info;
                Promoted = true;
                PromotedCategory = Process;
                //InFooterBar = true;
                trigger OnAction()
                begin
                    Hyperlink('https://webchat.botframework.com/embed/ChatBotAIUS-bot?s=AsNjejE0XXs.6dxHmclWNW1hYkEGoPRwb_tzwWFLSo4r2tDOwbZRxmc');
                end;
            }
            //PE-178.JS.1.0 16NOV2023 - end                                   
            action("NS_Job Task All Levels")
            {
                Caption = 'Job Task Totals';
                ToolTip = 'While clicking on Job Task Totals a “Job Task all Levels” page will open showing the totals of all the inclusive Task totals.'; //PRJCTPR-126.1.0
                Image = Totals;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    // NSTaskTotalsAllLevel: Page "NS_Job Task All Levels List";////PRJ-1493.AS.1.0 Commented
                    NSTaskTotalsAllLevel: Page "NS_Job Task All Levels List1";//PRJ-1493.AS.1.0 Added code
                    NSJobTask: Record "Job Task";
                begin
                    //PE-29.Dk.1.0 12May2023 Start
                    // if Rec."NS_Job Class" = Rec."NS_Job Class"::"Master Job" then begin
                    //     Clear(NSTaskTotalsAllLevel);
                    //     NSJobTask.Reset();
                    //     NSJobTask.SetRange("Job No.", Rec."No.");
                    //     NSTaskTotalsAllLevel.SetTableView(NSJobTask);
                    //     NSTaskTotalsAllLevel.Run;
                    // end else
                    //     Error('Job Class should be a Master Job only')
                    Clear(NSTaskTotalsAllLevel);
                    NSJobTask.Reset();
                    NSJobTask.SetRange("Job No.", Rec."No.");
                    NSTaskTotalsAllLevel.SetTableView(NSJobTask);
                    NSTaskTotalsAllLevel.Run;
                    //PE-29.Dk.1.0 12May2023 END
                end;
            }
            //PRJ-1184.JS.1.0 10FEB2022 end           

        }

        addafter("Co&mments")
        {
            action("NS_Links")
            {
                Caption = 'Lin&ks';
                Image = Links;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Job Links";
                RunPageLink = "NS_Job No." = FIELD("No.");
                RunPageView = SORTING("NS_Job No.", "NS_Parent Job No.");
                ApplicationArea = All;
            }
            action("NS_APO Links")
            {
                Caption = 'APO Links';
                ToolTip = 'The purpose of the APO Link is to relate the “Budgeted” Job Planning Lines within a Job Task to the “Billable” Job Planning Lines in the same or another Job Task for calculating the “Suggested Billing %” in the Progress Billing page.'; //PRJCTPR-126.DK.1.0 24june2023
                Enabled = true;//PRJ-762.RS.1.0 18June21 
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                //PRJ-820.JS.1.0�04August2021-Start
                // RunObject = Page "NS_APO Links Subform";
                // RunPageLink = NS_Type = FILTER(Job),
                //               NS_Code = FIELD(UPPERLIMIT("No."));
                // RunPageView = SORTING(NS_Type, NS_Code);
                //PRJ-820.JS.1.0�04August2021-end
                Visible = true; //PRJ-762.RS.1.0 18June21
                ApplicationArea = All;

                //PRJ-820.JS.1.0�04August2021-Start
                trigger OnAction();
                begin
                    IF Rec."No." <> '' then begin
                        NS_SetAPOLinkForJob();
                        NS_APOLinkLine.Reset();
                        NS_APOLinkLine.SetRange(NS_Type, NS_APOLinkLine.NS_Type::Job);
                        NS_APOLinkLine.SetRange(NS_Code, Rec."No.");

                        page.Run(14021166, NS_APOLinkLine);

                    end
                end;
                //PRJ-820.JS.1.0�04August2021-Start                

            }
            action("NS_Job Contacts")
            {
                Caption = 'Job C&ontacts';
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Job Contacts List";
                RunPageLink = "NS_Job No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        addafter("&Online Map")
        {
            action("NS_CustomReports")
            {
                Caption = 'Custom &Reports';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                    CustomReports: Page "Custom Report Layouts";
                begin
                    //ProjectPro - start

                    CustomReports.RUNMODAL;
                    CLEAR(CustomReports);
                    //ProjectPro - end
                end;
            }
            separator(NS_Separator1100773116)
            {
            }
            action(NS_ImportExcelSht)
            {
                Caption = 'Import Job Budget';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Visible = false;//PRJ-473.AS.1.0 20JAN2021

                trigger OnAction();
                var
                    ImportHdrPg: Page "NS_Export / Import Header";
                    ImportHdrTbl: Record "NS_Export/Import Excel Header";
                    EIEHandler: Codeunit "NS_ExportImport Excel Handle";
                begin
                    ImportHdrTbl.SETRANGE("NS_Job No.", "No.");
                    if ImportHdrTbl.FINDFIRST then begin
                        ImportHdrPg.SETTABLEVIEW(ImportHdrTbl);
                        ImportHdrPg.RUNMODAL;
                    end else begin
                        ImportHdrTbl.INIT;
                        ImportHdrTbl."NS_Job No." := "No.";
                        ImportHdrTbl.NS_Code := Text14021104;
                        ImportHdrTbl.VALIDATE("NS_Table No.", 1003);
                        ImportHdrTbl.INSERT;
                        CLEAR(EIEHandler);
                        EIEHandler.NS_InsertAllFields(ImportHdrTbl, false);
                        //ImportHdrPg.SETTABLEVIEW(ImportHdrTbl);
                        //ImportHdrPg.RUNMODAL;
                        //PAGE.RUN(60146, ImportHdrTbl, ImportHdrTbl."File Name");//PRJ-381.AS.1.0 14Sept2020 Commented
                        PAGE.RUN(14021429, ImportHdrTbl, ImportHdrTbl."NS_File Name");//PRJ-381.AS.1.0 14Sept2020 Changed as per NAV2017
                    end;
                end;
            }
            group("NS_&Take-Off")
            {
                Caption = '&Take-Off';
                action("NS_Get Job Segments")
                {
                    ApplicationArea = All;
                    Image = Job;
                    caption = 'Get Job Segments';//PPAL-166.Am.1.0
                    Promoted = true;
                    PromotedCategory = Category4;
                }
                action("NS_Get Job Task Segments")
                {
                    ApplicationArea = All;
                    Image = JobLines;
                    caption = 'Get Job Task Segments';//PPAL-166.Am.1.0
                    Promoted = true;
                    PromotedCategory = Category4;

                }
                //PRJ-374.AS.1.0 -  START Pulled Job Segment action from group out
                action("NS_Job Segments")
                {
                    ApplicationArea = All;
                    Caption = 'Job Segments';//PPAL-166.Am.1.0
                    ToolTip = 'This represents “Bid Items” to prepare an estimate based on a customer’s request for pricing for a project. It can be used to categorize/group, the various budget/cost lines for each Bid Item. It is a user-definable name structure to have the proper break-down of the costs across task codes and planning lines.'; //PRJCTPR-126.DK.1.0 24june2023
                    Image = "Event";
                    Promoted = true;
                    PromotedCategory = Process;
                    //RunObject = Page "NS_Drawing Segment"; //PRJ-374.AS.1.0 Commented Code
                    //RunPageLink = "NS_Job No." = FIELD("No."); //PRJ-374.AS.1.0 Commented Code

                    trigger OnAction();
                    var
                        JobSegment: Record "NS_Job Takeoff Segments";
                        JobSegList: Page "NS_Drawing Segment";
                        JebSegTmpl: Page "NS_Job Takeoff Seg. Tmpl. List";
                        QuoteJobSegment: Record "NS_Job Takeoff Segments";
                        JobNo: Code[20];
                    begin
                        //ProjectPro TO Start
                        IF "NS_Job Class" <> "NS_Job Class"::Template THEN BEGIN
                            //JobSegment.SETFILTER(NS_Type, '%1|%2', JobSegment.Type::Welding, JobSegment.Type::Drawing);//PRJ-374.AS.1.0 Commented Code
                            JobSegment.SETRANGE("NS_Job No.", "No.");
                            //PRJ-374.AS.1.0 Commented Code - start
                            //JobSegList.LOOKUPMODE(TRUE);
                            //JobSegList.SETRECORD(JobSegment);
                            //IF JobSegList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            //END;
                            //PRJ-374.AS.1.0 Commented Code - end
                            PAGE.RUNMODAL(14021400, JobSegment);
                        END ELSE BEGIN
                            JobSegment.SETRANGE(NS_Type, JobSegment.NS_Type::Template);
                            //JobSegment.SETRANGE("Drawing Code", '0');
                            JebSegTmpl.LOOKUPMODE(TRUE);
                            JebSegTmpl.SETRECORD(JobSegment);
                            IF JebSegTmpl.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                JebSegTmpl.GETRECORD(JobSegment);
                                JobNo := JobSegment."NS_Job No.";
                                NS_SetJobSegments(JobNo);
                            END;
                        END;
                        //ProjectPro TO End

                    end;
                }
                //PRJ-374-AS.1.0 - END


            }
        }
        //PRJ-1486.NK.1.0 08Jul2022 Start
        //addbefore("&Copy") //PRJ-1530.NK.1.0 22July2022 Block
        addafter(Attachments) //PRJ-1530.NK.1.0 22July2022
        {

            group(NS_JobGraphis)
            {
                //PE-115.DK.1.0 5july2023 START
                action("NSGenericCharts")
                {
                    Caption = 'Job Analytics Chart';
                    Promoted = true;
                    Ellipsis = true;
                    ApplicationArea = All;
                    Image = BarChart;
                    PromotedCategory = Category9;
                    trigger OnAction()
                    var
                        GenericCharts: Page NSProjectProJobChart;
                        NS_CostCategory: Codeunit "NS_Job Chart Management";
                        NS_SegmentCode: Codeunit "NS_Job Chart Management";
                    begin
                        NS_CostCategory.NS_FillJobCostCategory(Rec."No.");
                        //NS_SegmentCode.NS_FillJobSegment(Rec."No.");
                        GenericCharts.NSSetJobNo(Rec."No.", Rec.Description);
                        GenericCharts.Run();
                    end;
                }
                action("NSJPLCharts")
                {
                    Caption = 'Job task Analytics Chart ';
                    Promoted = true;
                    Ellipsis = true;
                    ApplicationArea = All;
                    Image = BarChart;
                    PromotedCategory = Category9;
                    trigger OnAction()
                    var
                        NSJPLCharts: Page NS_JobPlanningLineChart;
                    begin
                        NSJPLCharts.NSSetJobNo(Rec."No.", Rec.Description);
                        NSJPLCharts.Run();
                    end;
                }
                //PE-115.DK.1.0 5july2023 END
            }
            group("NS_Job Statistics")
            {
                //Caption = 'Job Statistics'; //PRJ-1530.NK.1.0 22July2022 Block
                Caption = 'Job Analytics'; //PRJ-1530.NK.1.0 22July2022
                Image = Statistics;
                action("NS_Budget Billable")
                {
                    ApplicationArea = All;
                    Caption = 'Job Budget/Billable';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category9; //PRJ-1530.NK.1.0 22July2022
                    //PromotedIsBig = true; //PRJ-1530.NK.1.0 22July2022 Block
                    RunObject = Page "NS_Job Budget/Billable FactBox";
                    RunPageLink = "No." = field("No.");
                }

                action("NS_Actual_Cost_Billings")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Cost/Billings';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category9; //PRJ-1530.NK.1.0 22July2022
                    //PromotedIsBig = true; //PRJ-1530.NK.1.0 22July2022 Block
                    RunObject = Page "NS_Actual CostBillingsFactBox";
                    RunPageLink = "No." = field("No.");
                }
                action("NS_Budget_Analysis_Profits")
                {
                    ApplicationArea = All;
                    Caption = 'Budg. Analysis/Profits';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category9; //PRJ-1530.NK.1.0 22July2022
                    //PromotedIsBig = true; //PRJ-1530.NK.1.0 22July2022 Block
                    //PE-190.VC.1.0 Start
                    //RunObject = Page "NS_BudgAnalysisProfitsFactBox";//PE-190.VC.1.0 Commented
                    RunObject = Page "NS_BudgAnalysProfitFactBoxNew";
                    //PE-190.VC.1.0 End
                    RunPageLink = "No." = field("No.");
                }
                //PE-9.Dk.1.0.23Dec2022 Start

                //PRJCTPR-346.JS.1.0 27MAR2024 - start
                action("NS_RevenueCategoryNew")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Category $';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category9;
                    RunObject = Page "NS_RevCategoryStatistics";
                    RunPageLink = "No." = field("No.");
                }
                //PRJCTPR-346.JS.1.0 27MAR2024 - end           
                action("NS_Cost cat by code New")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Category by code';
                    Image = Cost;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction();
                    var
                        Tcostbycode: Record "NS_Cost Cat by Code";
                        Tcostbycode1: Record "NS_Cost Cat by Code";
                        Tcostbycode2: Record "NS_Cost Cat by Code";
                        Tcostbycode3: Record "NS_Cost Cat by Code";
                        Tcostcat: Record "NS_Job Cost Category";
                        PGCostCat: Page NS_CostCatbyCodelist;
                    begin
                        Tcostcat.Reset();
                        Tcostcat.Setfilter(NS_Code, '<>%1', '');
                        if Tcostcat.FindSet() then
                            repeat
                                Tcostbycode.Reset();
                                Tcostbycode.SetRange("NS_Job No", rec."No.");
                                Tcostbycode.SetRange("NS_Cost Category", Tcostcat.NS_Code);
                                if not Tcostbycode.FindFirst() then begin
                                    Tcostbycode1.Init();
                                    Tcostbycode1."NS_Job No" := Rec."No.";
                                    Tcostbycode1."NS_Cost Category" := Tcostcat.NS_Code;
                                    Tcostbycode1.Insert();
                                end;
                            until Tcostcat.Next() = 0;

                        if not Tcostbycode.Get(Rec."No.", '') then begin
                            Tcostbycode2.Init();
                            Tcostbycode2."NS_Job No" := Rec."No.";
                            Tcostbycode2."NS_Cost Category" := '';
                            Tcostbycode2.Insert();
                        end;

                        Tcostbycode2.Reset();
                        Tcostbycode2.SetParameter(Rec."No.");

                        Tcostbycode3.Reset();
                        Tcostbycode3.FilterGroup(2);
                        Tcostbycode3.SetRange("NS_Job No", rec."No.");
                        Tcostbycode3.SetRange(NS_CheckBool, false);
                        Tcostbycode3.FilterGroup(0);
                        PGCostCat.SetTableView(Tcostbycode3);
                        PGCostCat.Run();
                    end;
                }
                //PE-9.Dk.1.0.23Dec2022 END
                //PE-1.Dk.1.0 6Dec 2023 Start
                action("NS_Expand &Collaps")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Summary';
                    Promoted = true;
                    Image = AllLines;
                    PromotedCategory = Category9;
                    trigger OnAction()
                    var
                        JobSummary: Page NS_JobTaskExpandCollapse;
                    begin
                        JobSummary.Run();
                    end;
                }
                //PE-1.Dk.1.0 6Dec 2023 End
            }
            //PE-23.NC.1.0 16May2023 Start
            action("NS_Commitment Report")
            {
                Caption = 'Commitment Report';
                ToolTip = 'Run Commitment Report.';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category9;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecJob: Record Job;
                begin
                    RecJob.Reset();
                    RecJob.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::NS_CommitmentReport, true, false, RecJob);
                end;
            }
            //PE-23.NC.1.0 16May2023 End
        }
        //PRJ-1486.NK.1.0 08Jul2022 End
        addfirst("W&IP")
        {
            action("NS_Calculate WIP")
            {
                ApplicationArea = All;
                Image = CalculateWIP;
                Caption = 'Calculate WIP';//PPAL-166.Am.1.0

                trigger OnAction();
                var
                    NS_JobRec: Record Job;
                begin
                    //ProjectPro - start
                    TESTFIELD("No.");
                    NS_JobRec.COPY(Rec);
                    NS_JobRec.SETRANGE("No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Job Calculate WIP", true, false, NS_JobRec);
                    //ProjectPro - end
                end;
            }
            action("NS_Post WIP to G/L")
            {
                ApplicationArea = All;
                Caption = 'Post WIP to G/L';
                Image = Post;


                trigger OnAction();
                var
                    NS_JobRec: Record Job;
                begin
                    //ProjectPro - start
                    TESTFIELD("No.");
                    NS_JobRec.COPY(Rec);
                    NS_JobRec.SETRANGE("No.", "No.");
                    REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", true, false, NS_JobRec);
                    //ProjectPro - end
                end;
            }
        }
        addafter("&G/L Account")
        {
            action("NS_Page Job Cost Category Prices")
            {
                ApplicationArea = All;
                Caption = '&Cost Category';
                Image = Cost;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "NS_Job Cost Category Prices";
                RunPageLink = "NS_Job No." = FIELD("No.");
            }
            group("NS_Prepa&yment")
            {
                Caption = 'Prepa&yment';
                Image = Prepayment;
                group(NS_Activity)
                {
                    Caption = 'Activity';
                    Image = Prepayment;
                    action("NS_Post Prepayment &Invoice")
                    {
                        ApplicationArea = All;
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtInvoiceYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, false);
                            //ProjectPro - end
                        end;
                    }
                    action("NS_Post and Print Prepmt. Invoic&e")
                    {
                        ApplicationArea = All;
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtInvoiceYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, true);
                            //ProjectPro - end
                        end;
                    }
                    action("NS_Post Prepayment &Credit Memo")
                    {
                        ApplicationArea = All;
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;

                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtCrMemoYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, false);
                            //ProjectPro - end
                        end;
                    }
                    action("NS_Post and Print Prepmt. Cr. Mem&o")
                    {
                        ApplicationArea = All;
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;

                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtCrMemoYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, true);
                            //ProjectPro - end
                        end;
                    }
                }
                action("NS_Page Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("NS_Prepayment Credi&t Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("NS_Prepayment History")
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment History';
                    Image = PaymentHistory;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_ViewPrepayments;
                        //ProjectPro - end
                    end;
                }
            }
        }
        addafter("Ledger E&ntries")
        {
            action("NS_Job Billing History")
            {
                ApplicationArea = All;
                Promoted = false;
                Caption = 'Job Billing History';
                Visible = false;

            }
            action("NS_Job Journal")
            {
                ApplicationArea = All;
                Image = Journals;
                RunObject = Page "Job Journal";
                caption = 'Job Journal';
            }
        }
        addafter("Copy Job Tasks &to...")
        {

            //PRJ-1015.JS.1.0  10Oct2021-Start
            action("NS_Create Sub Job")
            {
                ApplicationArea = All;
                Caption = 'Create Sub Job';
                Promoted = false;
                Image = ChangePaymentTolerance;

                trigger OnAction();
                begin
                    Rec.CreateSubJob(Rec);
                end;
            }
            //PRJ-1015.JS.1.0  10Oct2021-Start

            action("NS_Create Change Order")
            {
                ApplicationArea = All;
                Caption = 'Create Change Order';
                Promoted = false;
                Image = ChangeBatch;    //PRJ-1015.JS.1.0  10Oct2021

                trigger OnAction();
                begin
                    //ProjectPro - start
                    CreateChangeOrder(Rec);
                    //ProjectPro - end
                end;
            }
            //PRJCTPR-147.NK.1.0 start 17Aug2023
            action("NS_AGM_Create Change Request")
            {
                ApplicationArea = All;
                Caption = 'Create Change Request';
                Promoted = false;
                Image = ChangeBatch;

                trigger OnAction();
                var
                    NS_Jobs: Record Job;
                begin

                    NS_Jobs.NS_CreateChangeRequest(Rec);

                end;
            }
            action("NS_AGM_Merge Change Request")
            {
                ApplicationArea = All;
                Caption = 'Merge Change Request';
                Promoted = false;
                Image = ChangeBatch;

                trigger OnAction();
                var
                    NS_Jobs: Record Job;
                begin
                    NS_Jobs.ClearMarks();
                    NS_Jobs.Reset();
                    //  NS_Jobs.SetRange("NS_Sub-Level to Job No.", Rec."No."); //PE-193.PS.1.0 06Nov2023 Commented 
                    NS_Jobs.SetRange("NS_Change Request to Job No.", Rec."No."); //PE-193.PS.1.0 06Nov2023
                    NS_Jobs.SetRange("NS_Job Class", NS_Jobs."NS_Job Class"::"Change Request");
                    NS_Jobs.SetRange("NS_Manager Job Status", NS_Jobs."NS_Manager Job Status"::"Budget Review");
                    PAGE.RUN(PAGE::"NS_ChangeRequestList", NS_Jobs);
                end;
            }
            //PRJCTPR-147.NK.1.0 end 17Aug2023

            //PRJ-914.AS.1.0 21OCT2021 - start
            action("NS_Create Change Order Quote")
            {
                ApplicationArea = All;
                Caption = 'Create Change Order Quote';
                Promoted = false;
                Image = ChangeBatch;

                trigger OnAction();
                begin
                    NS_CreateChangeOrderQuoatation(Rec);
                end;
            }
            //PRJ-914.AS.1.0 21OCT2021 - end

            action("NS_Create Work Order")
            {
                ApplicationArea = All;
                Caption = 'Create Work Order';
                Image = ChangeLog;     //PRJ-1015.JS.1.0  10Oct2021

                trigger OnAction();
                begin
                    //ProjectPro - Start
                    CreateWorkOrder(Rec);
                    //ProjectPro - end
                end;
            }
        }
        //PRJ-1217.GK.1.0 16mar2022 start
        addafter("Copy Job Tasks &to...")
        {
            action("NS_Copy Job Task from")
            {
                // Caption = 'ProjectPro Copy Job Task from...';//PRJ-1296.GK.1.0 12apr2022  //PRJ-1337.RM.1.0  commented
                Caption = 'ProjectPro Copy Job Task to...';//PRJ-1337.RM.1.0 
                Image = CopyDocument;
                //Visible=false;
                ApplicationArea = All;
                trigger OnAction()
                var
                    CopyJobTasks: Page "NS Copy Job Tasks";
                begin
                    CopyJobTasks.SetFromJob(Rec);
                    CopyJobTasks.RunModal;
                end;



            }
            action("NS_Copy Job Task To")
            {
                // Caption = 'ProjectPro Copy Job Task To...';//PRJ-1296.GK.1.0 12apr2022 //PRJ-1337.RM.1.0  commented
                Caption = 'ProjectPro Copy Job Task from...'; //PRJ-1337.RM.1.0 
                Image = CopyDocument;
                ApplicationArea = All;
                //Visible=false;
                trigger OnAction()
                var
                    CopyJobTasks: Page "NS Copy Job Tasks";
                begin
                    CopyJobTasks.SetToJob(Rec);
                    CopyJobTasks.RunModal;
                end;
            }
        }
        //PRJ-1217.GK.1.0 16mar2022 end
        addafter("W&IP")
        {
            group(NS_ActionGroup1000000008)
            {
                Caption = 'Prepa&yment';
                Image = Prepayment;
                group(NS_ActionGroup1000000007)
                {
                    Caption = 'Activity';
                    Image = Prepayment;
                    action(NS_Action1000000006)
                    {
                        ApplicationArea = All;
                        Caption = 'Post Prepayment &Invoice';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtInvoiceYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, false);
                            //ProjectPro - end
                        end;
                    }
                    action(NS_Action1000000005)
                    {
                        ApplicationArea = All;
                        Caption = 'Post and Print Prepmt. Invoic&e';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        Promoted = true;
                        PromotedCategory = Process;
                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtInvoiceYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, true);
                            //ProjectPro - end
                        end;
                    }
                    action(NS_Action1000000004)
                    {
                        ApplicationArea = All;
                        Caption = 'Post Prepayment &Credit Memo';
                        Ellipsis = true;
                        Image = PrepaymentPost;
                        Promoted = true;
                        PromotedCategory = Process;
                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtCrMemoYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, false);
                            //ProjectPro - end
                        end;
                    }
                    action(NS_Action1000000003)
                    {
                        ApplicationArea = All;
                        Caption = 'Post and Print Prepmt. Cr. Mem&o';
                        Ellipsis = true;
                        Image = PrepaymentPostPrint;
                        Promoted = true;
                        PromotedCategory = Process;
                        trigger OnAction();
                        var
                            NS_PurchaseHeader: Record "Purchase Header";
                            NS_JobPostYNPrepmt: Codeunit "NS_Job-Post PrepaymentYesNo";
                        begin
                            //ProjectPro - start
                            NS_BuildSalesHeaderTemp(Rec);
                            NS_JobPostYNPrepmt.NS_PostPrepmtCrMemoYN(Rec, NS_SalesHeaderTemp, NS_SalesLineTemp, true);
                            //ProjectPro - end
                        end;
                    }
                }
                action("NS_Prepayment Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Prepa&yment Invoices';
                    Image = PrepaymentInvoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action(NS_Action1000000001)
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment Credi&t Memos';
                    Image = PrepaymentCreditMemo;
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action(NS_Action1000000000)
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment History';
                    Image = PaymentHistory;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_ViewPrepayments;
                        //ProjectPro - end
                    end;
                }
            }
            action("NS_Schedule of Values")
            {
                ApplicationArea = All;
                Image = ValueLedger;
                RunObject = Page "NS_Job Quote Scope of Work";
                Caption = 'Schedule of Values';
            }
        }
        addafter("NS_Schedule of Values")
        {
            group("NS_Actual vs Budget")
            {
                Caption = 'Actual vs Budget';
                action("NS_Act vs Bud Cost by Task")
                {
                    ApplicationArea = All;
                    Caption = 'Act vs Bud Cost by Task';
                    Promoted = true;
                    PromotedCategory = Report;
                    Image = Report;
                    //RunObject = Report "NS_ActualvsBudget Cost by APO";//PRJ-672.N.S.1.0 comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_ActualvsBudget Cost by APO", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
                action("NS_Act vs Bud Cost by Task with Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Act vs Bud Cost by Task with Qty';
                    Image = "Report";
                    Promoted = false;
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                }
                action("NS_Act vs. Bud Cost Work Units by Task")
                {
                    ApplicationArea = All;
                    Caption = 'Act vs. Bud Cost Work Units by Task';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_ActualvsBudget C/WU by APO"; //PRJ-200.AS.2.0 15JULY2020 commented
                    //PRJ-200.AS.2.0 15JULY2020 - start
                    trigger OnAction();
                    var
                        jobrec: Record job;
                    begin
                        jobrec.RESET;
                        jobrec.SETRANGE("No.", "No.");
                        REPORT.RUNMODAL(REPORT::"NS_ActualvsBudget C/WU by APO", true, false, jobrec);
                    end;
                    //PRJ-200.AS.2.0 15JULY2020 - end
                }
            }
            group("NS_Pct of Completion")
            {
                Caption = 'Pct of Completion';
                //CTSI-152.AS.1.0 14Sept2020 - start
                action(NS_ProjProfitAnalysisReport)
                {
                    ApplicationArea = All;
                    Caption = 'Project Profit Analysis Report';
                    Image = "Report";
                    Promoted = true;
                    Visible = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Percentage of CompletionNew";
                }
                //CTSI-152.AS.1.0 14Sept2020 - end
                action(NS_Action1100773107)
                {
                    ApplicationArea = All;
                    Caption = 'Pct of Completion';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_Percentage of Completion";//PRJ-672.N.S.1.0 Comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_Percentage of Completion", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
                //CTSI-281.AM.1.0
                action("NS_OPS Manager")
                {
                    ApplicationArea = All;
                    Caption = 'OPS Manager Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report NS_OPSManagerRep;
                    //Visible = false;
                }
                //CTSI-281.AM.1.0
                action("NS_Pct of Completion by Dim")
                {
                    ApplicationArea = All;
                    Caption = 'Pct of Completion by Dim';
                    Enabled = false;
                    Image = "Report";

                    RunObject = Report "NS_Pct of Completion by Dim";
                    Visible = false;
                }
                action("NS_Pct of Completion with GM")
                {
                    ApplicationArea = All;
                    Caption = 'Pct of Completion with GM';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_POC Gross Margin";//PRJ-672.N.S.1.0 comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_POC Gross Margin", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
            }
            group("NS_Job Mat/Labor Analysis")
            {
                Caption = 'Job Mat/Labor Analysis';
                // action("NS_Act vs Bud Material by Task")//PRJ-813.AS.1.0 Action commented as report not needed anymore
                // {
                //     ApplicationArea = All;
                //     Caption = 'Act vs Bud Material by Task';
                //     Image = Report;
                //     Promoted = false;

                //     RunObject = Report "NS_ActualvsBudget Mat by APO";
                // }
                action("NS_Act vs Bud Qty by Task")
                {
                    ApplicationArea = All;
                    Caption = 'Act vs Bud Qty by Task';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_Actual vs Budget Qty by APO";PRJ-672.N.S.1.0 Comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_Actual vs Budget Qty by APO", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
                action("NS_Act vs Bud Job Hours")
                {
                    ApplicationArea = All;
                    Caption = 'Act vs Bud Job Hours';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_Actual vs Budget Job Hour";//PRJ-672.N.S.1.0 Comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_Actual vs Budget Job Hour", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
                action("NS_Variance Report")//PPAL-437.AS.1.0
                {
                    ApplicationArea = All;
                    Caption = 'Variance Report';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_Act vs Bud Cost by APOwQty";//PRJ-672.N.S.1.0
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                        T_27: Record "Purchase Line";
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_Act vs Bud Cost by APOwQty", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
            }
            group("NS_Job Analysis group")
            {
                Caption = 'Job Analysis';
                action("NS_Job Detail by Task")
                {
                    ApplicationArea = All;
                    Caption = 'Job Detail by Task';
                    Image = Report;
                    Promoted = false;

                    RunObject = Report "NS_Job Detail by Task";
                }
                action("NS_Job Gross Profit")
                {
                    ApplicationArea = All;
                    Caption = 'Job Gross Profit';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    //RunObject = Report "NS_Jobs Gross Profit";//PRj-672.N.S.1.0 Comment
                    //PRJ-672.N.S.1.0 Start
                    trigger OnAction()
                    var
                        JobRec: Record Job;
                    begin
                        JobRec.SetRange("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"NS_Jobs Gross Profit", true, false, JobRec);
                    end;
                    //PRJ-672.N.S.1.0 END
                }
                action("NS_Committed Cost Detail")
                {
                    ApplicationArea = All;
                    Caption = 'Committed Cost Detail';
                    Image = Report;
                    Promoted = false;
                    RunObject = Report "NS_Committed Cost DetailReport";
                }
            }
            action("NS_Print Work Order")
            {
                ApplicationArea = All;
                Caption = 'Print Work Order';
                Image = Document;

                trigger OnAction();
                var
                    WorkOrderDoc: Report "NS_Work Order (Job LedgerSumm)";
                begin
                    //ProjectPro - start
                    WorkOrderDoc.SetFilter(Rec."No.");
                    WorkOrderDoc.RUNMODAL;
                    //ProjectPro - end
                end;
            }
            action("NS_Job Rcvd Not Invoiced")
            {
                ApplicationArea = All;
                //Caption = 'Job Rcvd Not Invoiced'; //PRJ-59.MS.1.0 Commented
                Caption = 'Job Received not Invoiced'; //PRJ-59.MS.1.0 Added
                Image = Document;

                trigger OnAction();
                var
                    PPRcvdNotInvoiced: Report "NS_ProjectPro Rcvd NotInvoiced";
                begin
                    PPRcvdNotInvoiced.SetFilter(Rec."No.", '');
                    PPRcvdNotInvoiced.RUNMODAL;
                end;
            }
            action("NS_Daily Filled Report")  //JD-10.MS.1.0
            {
                ApplicationArea = All;
                Caption = 'Daily Field Report';
                Image = Document;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    DFR: report 14021421;
                    JobRec: Record Job;//PRJ-672.N.S.1.0
                    DailyFieldReport: Report "NS_Daily Field Report";
                begin

                    //JobRec.SetRange("No.", Rec."No.");//PRJ-672.N.S.1.0 //PRJ-1474.RM.1.0 14July2022 Block
                    //REPORT.RUNMODAL(REPORT::"NS_Daily Field Report", true, false, JobRec);//PRJ-672.N.S.1.0 //PRJ-1474.RM.1.0 14July2022 Block
                    DailyFieldReport.NS_SetFilter(Rec."No."); //PRJ-1474.RM.1.0 14July2022
                    DailyFieldReport.Run();  //PRJ-1474.RM.1.0 14July2022                                                             
                end;
            }
            //PRJ-673.N.S.1.0 Start
            action("NS_Job Cost Budget by Task/Segment")
            {
                ApplicationArea = All;
                Caption = 'Job Cost Budget by Task/Segment';
                Image = CostLedger;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Specifies the Job Cost Budget by Task/Segment';
                trigger OnAction();
                var
                    lJob: Record Job;
                    lJobCostBudget: Report "NS_Job Cost Budget withSorting";
                begin
                    lJob.SETRANGE("No.", Rec."No.");
                    lJobCostBudget.SETTABLEVIEW(lJob);
                    lJobCostBudget.RUNMODAL;
                end;
            }
            //PRJ-673.N.S.1.0 End
            //PRJ-1254.RM.1.0 start
            action("NS_Cost & BillingReportDetail")
            {
                ApplicationArea = Jobs;
                Caption = 'Cost & Billing Report Detailed';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Report;
                Tooltip = 'Specifies Cost & Billing Report Detail';
                trigger OnAction()
                var
                    CostBillingRep: Report "NS_Cost & BillingReportDetail";
                    JobLedEntry: Record "Job Ledger Entry"; //PRJ-1291.RM.1.0 start
                begin
                    JobLedEntry.Reset();
                    JobLedEntry.SetRange("Job No.", Rec."No.");
                    Report.RunModal(14021493, true, false, JobLedEntry);
                    // CostBillingRep.Run();
                    //PRJ-1291.RM.1.0 end
                end;

            }
            //PRJ-1254.RM.1.0 end

            //PE-9.Dk.1.0.23Dec2022 | Move the "Cost Category by Code" from Report to Analytics
            //PRJ-1052.AS.1.0 - START
            action("NS_Cost cat by code")
            {
                ApplicationArea = All;
                Caption = 'Cost Category by code';
                Image = Cost;
                Promoted = true;
                PromotedCategory = Report;
                //PE-9.Dk.1.0.26Dec2022 start
                ObsoleteState = Pending;
                ObsoleteTag = '21.0.XXXX';
                ObsoleteReason = 'This control is marked for removal because it moves from Report section to Analcites Section on the job card';
                //PE-9.Dk.1.0.26Dec2022 end
                trigger OnAction();
                var
                    Tcostbycode: Record "NS_Cost Cat by Code";
                    Tcostbycode1: Record "NS_Cost Cat by Code";
                    Tcostbycode2: Record "NS_Cost Cat by Code";
                    Tcostbycode3: Record "NS_Cost Cat by Code";
                    Tcostcat: Record "NS_Job Cost Category";
                    PGCostCat: Page NS_CostCatbyCodelist;
                begin
                    Tcostcat.Reset();
                    Tcostcat.Setfilter(NS_Code, '<>%1', '');
                    if Tcostcat.FindSet() then
                        repeat
                            Tcostbycode.Reset();
                            Tcostbycode.SetRange("NS_Job No", rec."No.");
                            Tcostbycode.SetRange("NS_Cost Category", Tcostcat.NS_Code);
                            if not Tcostbycode.FindFirst() then begin
                                Tcostbycode1.Init();
                                Tcostbycode1."NS_Job No" := Rec."No.";
                                Tcostbycode1."NS_Cost Category" := Tcostcat.NS_Code;
                                Tcostbycode1.Insert();
                            end;
                        until Tcostcat.Next() = 0;

                    if not Tcostbycode.Get(Rec."No.", '') then begin
                        Tcostbycode2.Init();
                        Tcostbycode2."NS_Job No" := Rec."No.";
                        Tcostbycode2."NS_Cost Category" := '';
                        Tcostbycode2.Insert();
                    end;

                    Tcostbycode2.Reset();
                    Tcostbycode2.SetParameter(Rec."No.");

                    Tcostbycode3.Reset();
                    Tcostbycode3.FilterGroup(2);
                    Tcostbycode3.SetRange("NS_Job No", rec."No.");
                    Tcostbycode3.SetRange(NS_CheckBool, false);
                    Tcostbycode3.FilterGroup(0);
                    PGCostCat.SetTableView(Tcostbycode3);
                    PGCostCat.Run();
                end;
            }
            //PRJ-1052.AS.1.0 - END
            //PRJ-1710.NK.1.0 18Nov2022 Start
            action("NS_Update Open Job Backlog batch")
            {
                ApplicationArea = All;
                Caption = 'Update Open Job Backlog Batch';
                ToolTip = 'Specifies the Update Open Job Backlog Batch';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction();
                var
                    RecJob: Record Job;
                begin
                    RecJob.RESET();
                    RecJob.SETRANGE("No.", Rec."No.");
                    //Report.Runmodal(14021487, true, false, RecJob);//PE-173.PS.1.0 03Oct2023 Commneted
                    Report.Runmodal(14021295, true, false, RecJob);//PE-173.PS.1.0 03Oct2023
                end;
            }
            //PRJ-1710.NK.1.0 18Nov2022 End

            //PE-311.PP.1.0 11JUN2024 Start
            action("NS_Job LEM Quantity Report")
            {
                ApplicationArea = all;
                Caption = 'Work Order';
                ToolTip = 'Specifies the Job LEM Quantity Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    NS_WorkOrder: Report "NS_WorkOrder";
                    NS_JobRec: Record Job;
                    WorkInfo: record "NS_Work Type Info";
                begin
                    NS_JobRec.Reset();
                    NS_JobRec.SetRange("No.", Rec."No.");
                    report.RunModal(14021488, true, false, NS_JobRec);
                end;

            }
            //PE-311.PP.1.0 11JUN2024 End

            //PRJCTPR-262.DK.1.0 22DEC2023 Start
            action("NS_Work Order (Job Ledger Summ)")
            {
                ApplicationArea = all;
                Caption = 'Work Order Completed'; //PE-215.DK.3.0 4jan2024 //PE-311.PP.1.0 11JUN2024 
                ToolTip = 'Specifies the Work Order (Job Ledger Summ)';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    NS_WorkOrder: Report "NS_Work Order (Job LedgerSumm)";
                begin
                    NS_WorkOrder.SetFilter(Rec."No.");
                    NS_WorkOrder.RUNMODAL;
                end;
            }
            //PRJCTPR-262.DK.1.0 22DEC2023 End
        }
        addafter("Send Job Quote")
        {
            //PRJ-153.SK.1.0 Start
            // action("Create Sales Invoice")
            // {
            //     ApplicationArea = All;
            //     Image = Invoice;

            //     trigger OnAction();
            //     var
            //         lSalesInvoice: Page "Sales Invoice";
            //         lSalesHeader: Record "Sales Header";
            //     begin
            //         lSalesHeader.INIT;
            //         lSalesHeader.VALIDATE("Document Type", lSalesHeader."Document Type"::Invoice);
            //         lSalesHeader.VALIDATE("No.", '');
            //         lSalesHeader.VALIDATE("Sell-to Customer No.", "Bill-to Customer No.");
            //         lSalesHeader.VALIDATE("Job No.", "No.");
            //         if lSalesHeader.INSERT then begin
            //             lSalesInvoice.SETRECORD(lSalesHeader);
            //             lSalesInvoice.RUN;
            //         end else
            //             MESSAGE(Text14021105);
            //     end;
            // }
            //PRJ-153.SK.1.0 End

            //PRJ-673.N.S.1.0 Start Comment
            // action("NS_Job Cost Budget by Task/Segment")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Job Cost Budget by Task/Segment';
            //     Image = CostLedger;
            //     Promoted = true;
            //     PromotedCategory = Report;

            //     ToolTip = 'Specifies the Job Cost Budget by Task/Segment';

            //     trigger OnAction();
            //     var
            //         lJob: Record Job;
            //         lJobCostBudget: Report "NS_Job Cost Budget withSorting";
            //     begin
            //         lJob.SETRANGE("No.", "No.");
            //         lJobCostBudget.SETTABLEVIEW(lJob);
            //         lJobCostBudget.RUNMODAL;
            //     end;
            // }
            //PRJ-673.N.S.1.0 END Comment
        }
        //PRJ-153.SK.1.0 Start
        addafter("NS_Create Work Order")
        {


            action("NS_Create Job &Sales Invoice")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Job &Sales Invoice';
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';

                trigger OnAction()
                var
                    ParameterForEvent14021110: Codeunit "NS_Parameters for Events";
                    ReportJobCreateSalesInvoice: Report NS_JobCreateSalesInvoice;
                begin
                    ParameterForEvent14021110.NS_P88SetJobNo(Rec."No.");
                    ReportJobCreateSalesInvoice.Run();
                end;
            }
            action(NS_SalesInvoicesCreditMemos)
            {
                ApplicationArea = Jobs;
                Caption = 'Sales &Invoices/Credit Memos';
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'View sales invoices or sales credit memos that are related to the selected job.';

                trigger OnAction()
                var
                    JobInvoices: Page "Job Invoices";
                begin
                    JobInvoices.SetPrJob(Rec);
                    JobInvoices.RunModal;
                end;
            }
            //PE-74.NK.1.0 17Apr2023 Start
            action("NS_User Tasks")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category4;
                Caption = 'User Tasks';
                Image = Task;
                ToolTip = 'View this User Tasks.';
                trigger OnAction()
                var
                    UserTask: Record "User Task";
                    UserTask2: Record "User Task";
                begin
                    UserTask.Reset();
                    UserTask.SetRange("NS_Job No.", Rec."No.");
                    if UserTask.IsEmpty then begin
                        UserTask2.Init();
                        UserTask2."NS_Job No." := Rec."No.";
                        UserTask2.Insert();
                        Commit();
                        UserTask.Reset();
                        UserTask.SetRange("NS_Job No.", Rec."No.");
                        PAGE.RunModal(PAGE::"User Task Card", UserTask);
                    end else begin
                        UserTask.Reset();
                        UserTask.SetRange("NS_Job No.", Rec."No.");
                        PAGE.RunModal(PAGE::"User Task List", UserTask);
                    end;
                end;
            }
            //PE-74.NK.1.0 17Apr2023 End

        }

        //PRJ-153.SK.1.0 End

        //PE-47.PS.1.0 26March2023 Start 
        addafter("&Copy")
        {
            group("NS_Run Batch Open Job Backlog")
            {
                Caption = 'Run Batch Open Job Backlog';
                action("NS_Run Open Backlog Batch")
                {
                    Caption = 'Run Open Backlog Batch';
                    ApplicationArea = all;

                    trigger OnAction()
                    var
                        JobTask: Record "Job Task";
                        InvoiceAmount: Decimal;
                        BilledAmount: Decimal;
                        SublevelInvoiceAmount: Decimal;
                        SublevelBilledAmount: Decimal;
                        JobRec: Record Job;
                        JobSetup: Record "Jobs Setup";
                    begin
                        Rec."NS_Last Run Open Job Backlog" := WorkDate();//PE-173.PS.1.0 10Oct2023 
                        Rec."NS_New Run B_OpenJob B Log" := false;//PE-173.PS.1.0 10Oct2023
                        If (Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Closed) OR (Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Handover) OR ((Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Completed)) then begin
                            Clear(InvoiceAmount);
                            Clear(BilledAmount);
                            JobTask.Reset();
                            JobTask.SetRange("Job No.", Rec."No.");
                            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                            if JobTask.FindSet() then
                                repeat
                                    JobTask.CalcFields("Contract (Total Price)");
                                    JobTask.CalcFields("Contract (Invoiced Price)");
                                    BilledAmount += JobTask."Contract (Total Price)";
                                    InvoiceAmount += JobTask."Contract (Invoiced Price)";
                                until JobTask.Next() = 0;
                            if (InvoiceAmount - BilledAmount >= 0) AND (Rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Closed) OR ((Rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Completed)) then begin
                                Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount; //PRJCTPR-122.PS.1.0 14Jun2023
                                Rec."NS_Open Job Backlog" := ABS(InvoiceAmount - BilledAmount);
                                Rec."NS_New Run B_OpenJob B Log" := true; //PRJCTPR-122.PS.1.0 14Jun2023
                                Rec.Modify();
                            end;
                            if (InvoiceAmount - BilledAmount = 0) AND (Rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Handover) then begin
                                Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount; //PRJCTPR-122.PS.1.0 14Jun2023
                                Rec."NS_Open Job Backlog" := ABS(InvoiceAmount - BilledAmount);
                                Rec."NS_New Run B_OpenJob B Log" := true; //PRJCTPR-122.PS.1.0 14Jun2023
                                Rec.Modify();
                            end;
                            JobSetup.Get();
                            If JobSetup."NS_Inclued SubJob & Change Ord" = true then begin
                                if (InvoiceAmount - BilledAmount < 0) then begin
                                    JobRec.Reset();
                                    JobRec.SetRange("NS_Sub-Level to Job No.", Rec."No.");
                                    if JobRec.FindSet() then
                                        repeat
                                            JobTask.Reset();
                                            JobTask.SetRange("Job No.", JobRec."No.");
                                            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                                            if JobTask.FindSet() then
                                                repeat
                                                    JobTask.CalcFields("Contract (Total Price)");
                                                    JobTask.CalcFields("Contract (Invoiced Price)");
                                                    SublevelBilledAmount += JobTask."Contract (Total Price)";
                                                    SublevelInvoiceAmount += JobTask."Contract (Invoiced Price)";
                                                until JobTask.Next() = 0;
                                            //JobRec."NS_New Billable/Inv Dif" := 0; //PRJCTPR-122.PS.1.0 14Jun2023 //PE-173.PS.1.0 04Oct2023 Commented
                                            JobRec.Modify();
                                        until JobRec.Next() = 0;
                                End;
                            end;
                            Clear(MgsAmoutn);
                            MgsAmoutn := InvoiceAmount - BilledAmount + SublevelInvoiceAmount - SublevelBilledAmount;
                            if MgsAmoutn <> 0 then
                                Message('The billable amount of %1 is still pending to be invoiced, this will not allow you to clear the backlog.', InvoiceAmount - BilledAmount + SublevelInvoiceAmount - SublevelBilledAmount)
                            else
                                Message('The job is fully Invoiced and There is no value in Open Job Backlog');
                            //Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount + SublevelInvoiceAmount - SublevelBilledAmount; //PRJCTPR-122.PS.1.0 14Jun2023 //PE-173.PS.1.0 04Oct2023 Commented 
                            Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount;//PE-173.PS.1.0 04Oct2023
                            Rec."NS_Open Job Backlog" := Abs(InvoiceAmount - BilledAmount + SublevelInvoiceAmount - SublevelBilledAmount);
                            Rec.Modify();
                        end;
                    end;
                    //  end;
                }
            }
        }
        //PE-47.PS.1.0 26March2023 End 
        //PE-126.DK.1.1 10july2023 START
        addafter("&Dimensions")
        {
            action("NS_Job Journal2")
            {
                ApplicationArea = Jobs;
                caption = 'Job Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Category7;
                trigger OnAction()
                var
                    NSJobJournal: Page "Job Journal";
                begin
                    NSJobJournal.Run();
                end;
            }
            //PE-126.DK.1.1 10july2023 END

            //PE-168.HS.1.0 18Nov2023 Start
            action("NS_DailyJobLog")
            {
                ApplicationArea = all;
                Caption = 'Job Daily Log';
                Promoted = true;
                PromotedCategory = Category7;
                Image = TaskList;
                RunObject = page "NS_Daily Job Log List";
                RunPageLink = "NS_Job No." = field("No.");
            }
            //PE-168.HS.1.0 18Nov2023 End

            //PE-288.JS.1.0 06MAY2024
            action("NS_JobPunchList")
            {
                ApplicationArea = all;
                Caption = 'Punch List';
                RunObject = page "NS_Punch list";
                Promoted = true;
                PromotedCategory = Category7;
                RunPageLink = "NS_Job No." = field("No.");
            }
            //PE-288.JS.1.0 06MAY2024
        }

        //PRJCTPR-230.HS.1.0 11Dec2023 Start
        addlast(processing)
        {
            action("NS_JobLinksList")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category7;
                Image = List;
                Caption = 'Job Links List';
                ToolTip = '“Shows a Job list with sub-levels providing the ability to filter for a job and all levels. To enable this, use "Job List Auto Link Create" on job setup under Lists fast tab and run the "Initialize Linked Job List" batch from the same page on the ribbon”.';
                trigger OnAction()
                var
                    NS_JobList: Page "NS_Job List (Formatted)";
                begin
                    Clear(NS_JobList);
                    NS_JobList.LOOKUPMODE(TRUE);
                    NS_JobList.SETTABLEVIEW(Rec);
                    NS_JobList.SETRECORD(Rec);
                    IF NS_JobList.RUNMODAL = ACTION::LookupOK THEN
                        NS_JobList.GETRECORD(Rec);
                end;
            }
        }
        //PRJCTPR-230.HS.1.0 11Dec2023 End
    }



    var
        Job_No: Code[20];
        Text19050914: Label 'Bill-To Customer';
        DifferentCurrenciesErr: Label 'You cannot plan and invoice a job in different currencies.'; //PRJ-SK.1.0 Start
        Text19078857: Label 'Budget';
        Text19080001: Label 'Budget';
        Text19036146: Label 'ACTUAL';
        Text19065266: Label 'Actual';
        Text19068395: Label 'PROJECTED';
        Text19080002: Label 'Actual';
        Text19047697: Label 'Variance';
        Text19080003: Label 'Variance';
        Text19000744: Label 'Date';
        Text19004432: Label 'Budget (Cost)';
        Text19031882: Label 'Period to Date';
        Text19022646: Label 'Estimated';
        Text19019020: Label 'Contract (Price)';
        Text19015578: Label 'Year to Date';
        Text19072856: Label 'Job to Date';
        Text19061674: Label 'Projected';
        Text19080004: Label 'Variance';
        Text14021100: Label 'Should the Tax Area Code and Tax Liable values also be cleared?';
        Text14021101: Label 'Project %1 Prepayment';
        MgsAmoutn: Decimal; //PRJCTPR-122.PS.1.0 20jun2023

    var
        CustLedgEntryRetention: Record "Cust. Ledger Entry";
        JobCalc: Record Job;
        JobLedgEntry: Record "Job Ledger Entry";
        JobsSetup: Record "Jobs Setup";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchSetup: Record "Purchases & Payables Setup";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ShowJobRec: Record Job;
        "Sub-LevelJob": Record Job;
        JobLinks: Record "NS_Job Links";
        VendLedgEntryRetention: Record "Vendor Ledger Entry";
        ShipToAddress: Record "Ship-to Address";
        Resource: Record Resource;
        CalcValues: array[8, 40] of Decimal;
        TotalBudgetedCost: Decimal;
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;
        OriginalBudget: Decimal;
        OriginalContract: Decimal;
        AdjustmentBudget: Decimal;
        AdjustmentContract: Decimal;
        BudgetCostLCYForProjectionA: Decimal;   //PRJ-1349.JS.1.0 15MAY2022
        PersonResponsibleName: Text[100];//PRJ-301.AS.1.0 Increased length from 50 to 100 chars
        ManagerName: Text;//PRJ-301.AS.1.0 Increased lenth from 30 chars
        EstimatorName: Text;//PRJ-301.AS.1.0 Increased lenth from 30 chars
        "Sub-Levels": Boolean;
        JobCalendar: Record "NS_Job Calendar";
        BaseCalendar: Record "Base Calendar";
        JobCalendarCode: Code[10];
        [InDataSet]
        "Job Address 1Editable": Boolean;
        [InDataSet]
        "Job Address 2Editable": Boolean;
        [InDataSet]
        "Job CityEditable": Boolean;
        [InDataSet]
        "Job CountyEditable": Boolean;
        [InDataSet]
        "Job Post CodeEditable": Boolean;
        [InDataSet]
        JobCountryRegionCodeEditable: Boolean;
        [InDataSet]
        "Job PhoneEditable": Boolean;
        JobPlanningList: Page "Job Planning Lines";
        JobLedgerEntries: Page "Job Ledger Entries";
        DtldCustLedgEntries: Page "Detailed Cust. Ledg. Entries";
        CommittedLineList: Page "NS_Committed Line List";
        JobSubContractList: Page "NS_Job Subcontract List";
        JobForecastWorksheet: Page "NS_Job Forecast Worksheet";
        NS_SalesHeaderTemp: Record "Sales Header" temporary;
        NS_SalesLineTemp: Record "Sales Line";
        NS_Customer: Record Customer;
        NS_GLSetup: Record "General Ledger Setup";
        NS_PaymentTerms: Record "Payment Terms";
        NS_Salesperson: Record "Salesperson/Purchaser";
        NS_APOLinkLine: Record "NS_APO Links Line";   //PRJ-820.JS.1.0 04Aug2021
        NS_SalespersonName: Text;//PRJ-301.AS.1.0 Increased length
        NS_ApprovalMgt: Codeunit "Approvals Mgmt.";
        CurrencyCodeEditable: Boolean;
        InvoiceCurrencyCodeEditable: Boolean;
        JobPurName: Text; //PRJ-1380.NK.1.0 13May2022
        Text14021102: Label 'JOB';
        Text14021103: Label 'Job';
        Text14021104: Label 'Page 1';
        Text14021105: Label 'Unable to create Sales Invoice';
        Editbool: Boolean;//CTSI-254.AM
        JobsSetup1: Record "Jobs Setup";//CTSI-254.AM
        NS_LaborCostLbl: Label 'Labor Cost';
        NS_MaterialCostLbl: Label 'Material Cost';
        NS_EquipmentCostLbl: Label 'Equipment Cost';
        NS_SubcontractCostLbl: Label 'Subcontract Cost';
        NS_MfgCostLbl: Label 'Mfg. Cost';
        NS_OverheadCostLbl: Label 'Overhead Cost';
        NS_MiscellaneousCostLbl: Label 'Miscellaneous Cost';
        NS_UncategorizedCostLbl: Label 'Uncategorized Cost';
        NS_CostTotasLbl: Label 'Cost Totals';
        NS_LaborRevLbl: Label 'Labor Rev';
        NS_MaterialRevLbl: Label 'Material Rev';
        NS_EquipmentRevLbl: Label 'Equipment Rev';
        NS_SubcontractRevLbl: Label 'Subcontract Rev';
        NS_MfgRevLbl: Label 'Mfg. Rev';
        NS_OverheadRevLbl: Label 'Overhead Rev';
        NS_MiscellaneousRevLbl: Label 'Miscellaneous Rev';
        NS_UncategorizedRevLbl: Label 'Uncategorized Rev';
        NS_RevenueTotalsLbl: Label 'Revenue Totals';
        NS_BudgetUsedPctLbl: Label 'Budget Used %';
        NS_CostsToDateLbl: Label 'Costs To Date';
        NS_BudgetRemainingLbl: Label 'Budget Remaining';
        NS_BudgetedTotalsCostsLbl: Label 'Budgeted Totals Costs';
        NS_BudgetedProfitLossLbl: Label 'Budgeted Profit (Loss)';
        NS_BudgetedOrifitPctLbl: Label 'Budgeted Profit %';
        //FGH-16.SK.1.0 Start
        NS_ShowMapLbl: Label 'Show on Map'; //PE-99.NC.1.0 29May2023

        POCMethodValueVar: Boolean;
        TotalUnitsVar: Boolean;
        PercJobActuallyCompleteVar: Boolean;
        JobCompletedDateVar: Boolean;
        ActualUnitsCompleteVar: Boolean;
        UnitsCompletedDateVar: Boolean;
        PercCompletedVar: Boolean;
        PercInvoicedVar: Boolean;
        NSDisableRevCateFactBoxobJobCard: boolean;   //PRJCTPR-346.JS.1.0
        NS_CRManagerStatus: Boolean; //PRJCTPR-147.PS.2.0 20Sep2023 
        NSReturnManagerStatus: Boolean; //PRJCTPR-147.PS.2.0 20Sep2023 
        //FGH-16.SK.1.0 End
        JobSetup: Record "Jobs Setup";  //PRJCTPR-162.RM.1.0 20July2023

    trigger OnOpenPage();
    var
        NS_JobSetup: Record "Jobs Setup";//PRJCTPR-233.PS.1.0 06Dec2023
    begin

        //PRJCTPR-233.PS.1.0 06Dec2023 Start
        If NS_JobSetup.Get() then;
        NS_JobSetup."NS_Show Default task in Copy Job" := false;
        //PRJCTPR-346.JS.1.0 04MAR2024 - start
        if NS_JobSetup."NS_Disable RevCat FactBox" = true then
            NSDisableRevCateFactBoxobJobCard := false
        else
            NSDisableRevCateFactBoxobJobCard := true;
        //PRJCTPR-346.JS.1.0 04MAR2024 - end  
        // NS_JobSetup.Modify();//PRJCTPR-322
        //PRJCTPR-233.PS.1.0 06Dec2023 End
        //ProjectPro - start
        "Sub-Levels" := TRUE;
        //ProjectPro - end
        //ProjectPro - start
        SalesSetup.GET;
        PurchSetup.GET;
        JobsSetup.GET;
        NS_BlockShipTo;
        NS_GLSetup.GET;
        //ProjectPro - end
        //CTSI-254.AM Start
        if JobsSetup1.Get() then;//PRJCTPR-322
        if JobsSetup1."NS_Advanced Burden Allocation" then
            Editbool := false
        else
            Editbool := true;
        //CTSI-254.AM End
    end;

    trigger OnAfterGetRecord();
    begin
        NSReturnManagerStatus := NSManagerStatusEdite();//PRJCTPR-147.PS.2.0 20Sep2023
        //ProjectPro - start
        NS_OnAfterGetCurrRecord;
        //ProjectPro - end
        //FGH-16.SK.1.0 Start
        NS_SetFieldsEditable();
        BudgetCostLCYForProjectionA := NS_GetBudgetedCostLCYForProjection(Rec."No.");  //PRJ-1349.JS.1.0 15MAY2022
        //FGH-16.SK.1.0 End
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //ProjectPro - start
        "NS_Job Class" := JobsSetup."NS_Default Job Class";
        NS_BlockShipTo;
        OriginalBudget := 0;
        OriginalContract := 0;
        NS_OnAfterGetCurrRecord;
        if JobSetup.Get() then; //PE-301.NC.1.0 10Jun2024
        Rec."NS_Pur/Sale UOM for B&B JPL" := JobSetup."NS_Pur/Sale UOM for B&B JPL"; //PE-301.NC.1.0 10Jun2024
        //ProjectPro - end
    end;

    procedure NS_BlockShipTo();
    begin
        //ProjectPro - start
        if "NS_Job Ship-to Code" > '' then begin
            "Job Address 1Editable" := false;
            "Job Address 2Editable" := false;
            "Job CityEditable" := false;
            "Job CountyEditable" := false;
            "Job Post CodeEditable" := false;
            JobCountryRegionCodeEditable := false;
            "Job PhoneEditable" := false;
        end else begin
            "Job Address 1Editable" := true;
            "Job Address 2Editable" := true;
            "Job CityEditable" := true;
            "Job CountyEditable" := true;
            "Job Post CodeEditable" := true;
            JobCountryRegionCodeEditable := true;
            "Job PhoneEditable" := true;
        end;
        //ProjectPro - end
    end;

    procedure NS_JobLinkNextRecord(Steps: Integer; JobRecIn: Record Job; var JobRecOut: Record Job): Integer;
    var
        LastGoodRecordForward: Record "NS_Job Links";
        LastGoodRecordBackward: Record "NS_Job Links";
        JobNumOut: Code[20];
        ParentJobNumOut: Code[20];
        StepsTaken: Integer;
        i: Integer;
        EOF: Boolean;
    begin
        //ProjectPro - start
        StepsTaken := 0;
        EOF := false;
        CLEAR(LastGoodRecordForward);
        CLEAR(LastGoodRecordBackward);
        JobRecOut := JobRecIn;

        with JobLinks do begin


            if JobRecIn."NS_Temp Linked Parent Job No." = '' then
                JobRecIn."NS_Temp Linked Parent Job No." := JobRecIn."No.";

            RESET;
            SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
            SETRANGE("NS_Job No.", JobRecIn."No.");
            if NS_SeparatorCount(JobRecIn."NS_Temp Linked Parent Job No.") = 0 then
                SETRANGE("NS_Parent Job No.", JobRecIn."NS_Temp Linked Parent Job No.");
            if FINDFIRST then;
            SETRANGE("NS_Parent Job No.");
            SETRANGE("NS_Job No.");


            if Steps > 0 then
                for i := 1 to Steps do begin
                    if not EOF then begin
                        if NS_GoForward(EOF) then begin
                            LastGoodRecordForward := JobLinks;
                            StepsTaken := StepsTaken + 1;
                        end;
                    end;
                end
            else
                for i := 1 to -Steps do begin
                    if not EOF then begin
                        if NS_GoBackward(EOF) then begin
                            LastGoodRecordBackward := JobLinks;
                            StepsTaken := StepsTaken - 1;
                        end;
                    end;
                end;
        end;


        if StepsTaken <> 0 then begin
            if Steps <> 0 then begin
                if Steps > 0 then begin
                    JobNumOut := LastGoodRecordForward."NS_Job No.";
                    ParentJobNumOut := LastGoodRecordForward."NS_Parent Job No.";
                end else begin
                    JobNumOut := LastGoodRecordBackward."NS_Job No.";
                    ParentJobNumOut := LastGoodRecordBackward."NS_Parent Job No.";
                end;
                JobRecOut.GET(JobNumOut);
                if ParentJobNumOut = '' then
                    ParentJobNumOut := JobNumOut;
                JobRecOut."NS_Temp Linked Parent Job No." := ParentJobNumOut;
            end;
        end;

        exit(StepsTaken);
        //ProjectPro - end
    end;

    procedure NS_GoForward(var EOF1: Boolean): Boolean;
    var
        SepCount: Integer;
        ParentSepCount: Integer;
        Result: Integer;
        Level: Integer;
        BeginProjNo: Code[20];
        GoodRecord: Boolean;
        EOF2: Boolean;
    begin
        //ProjectPro - start
        GoodRecord := false;
        Level := 100;

        with JobLinks do begin
            repeat
                Result := NEXT;
                if Result > 0 then begin
                    SepCount := NS_SeparatorCount("NS_Job No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                    if (SepCount <= Level) and
                       (ParentSepCount = 0) then begin
                        GoodRecord := true;
                    end;
                end else begin
                    EOF1 := true;
                    if SepCount > Level then begin
                        EOF2 := false;
                        repeat
                            if NEXT(-1) = 0 then
                                EOF2 := true;
                            if (SepCount <= Level) and
                               (ParentSepCount = 0) then begin
                                GoodRecord := true;
                            end;
                        until ((NS_SeparatorCount("NS_Job No.") <= Level) and
                               (NS_SeparatorCount("NS_Parent Job No.") = 0))
                              or EOF2;
                    end;
                end;
            until EOF1 or GoodRecord;
        end;

        exit(GoodRecord);
        //ProjectPro - end
    end;

    procedure NS_GoBackward(var EOF1: Boolean): Boolean;
    var
        SepCount: Integer;
        ParentSepCount: Integer;
        Result: Integer;
        Level: Integer;
        GoodRecord: Boolean;
        EOF2: Boolean;
    begin
        //ProjectPro - start
        GoodRecord := false;
        Level := 100;

        with JobLinks do begin
            repeat
                Result := NEXT(-1);
                if (Result < 0) and not EOF1 then begin
                    SepCount := NS_SeparatorCount("NS_Job No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                    if (SepCount > Level) and
                       (ParentSepCount = 0) then begin
                        EOF2 := false;
                        repeat
                            if NEXT(-1) = 0 then
                                EOF2 := true;
                            SepCount := NS_SeparatorCount("NS_Job No.");
                            ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                        until ((SepCount <= Level) and
                               (ParentSepCount = 0))
                              or EOF2;
                    end;
                    if (SepCount <= Level) and
                       (ParentSepCount = 0) then begin
                        GoodRecord := true;
                    end;
                end else
                    EOF1 := true;
            until EOF1 or GoodRecord;
        end;

        exit(GoodRecord);
        //ProjectPro - end
    end;

    procedure NS_UpdatePersonResponsibleName();
    begin
        //ProjectPro - start
        if Resource.GET("Person Responsible") then
            PersonResponsibleName := Resource.Name
        else
            PersonResponsibleName := '';
        //ProjectPro - end
    end;

    procedure NS_UpdateManagerName();
    begin
        //ProjectPro - start
        if NS_Manager > '' then begin
            Resource.GET(NS_Manager);
            ManagerName := Resource.Name;
        end else
            ManagerName := '';
        //ProjectPro - end
    end;

    procedure NS_UpdateEstimatorName();
    begin
        //ProjectPro - start
        if NS_Estimator > '' then begin
            Resource.GET(NS_Estimator);
            EstimatorName := Resource.Name;
        end else
            EstimatorName := '';
        //ProjectPro - end
    end;

    procedure NS_OnAfterGetCurrRecord();
    var
        Resource: Record Resource;//PRJ-1380.NK.1.0 13May2022
    begin
        //ProjectPro - start
        SETRANGE("No.");
        CLEAR(CalcValues);
        CLEAR(InvoiceBilled);
        CLEAR(ActualCostToDate);
        CLEAR(PaymentReceived);
        Clear(JobPurName);//PRJ-1380.NK.1.0 13May2022
        TotalBudgetedCost := 0;
        CommittedCost := 0;
        "Sub-LevelsCost" := 0;
        "Sub-LevelsPrice" := 0;

        if "No." <> '' then
            NS_CalcStatistics;
        NS_BlockShipTo;
        NS_UpdatePersonResponsibleName;
        NS_UpdateManagerName;
        NS_UpdateEstimatorName;
        NS_UpdateSalespersonName;
        //ProjectPro - end
        Job_No := "No."; //SPLN1.00
        //PRJ-1380.NK.1.0 13May2022 start
        if Resource.Get(Rec."NS_Job Purchaser") then begin
            JobPurName := Resource.Name;
        end;
        //PRJ-1380.NK.1.0 13May2022 end
    end;

    procedure NS_CalcStatistics();
    var
        NSJobSetup1: record "Jobs Setup";  //PRJCTPR-346.JS.1.0 31MAR2024
    begin
        if NSJobSetup1.get() then;   //PRJCTPR-346.JS.1.0 31MAR2024
        //ProjectPro - start
        JobCalc := Rec;
        JobCalc.RESET;
        NS_CalculateJobFinancials(JobCalc, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, "Sub-Levels");


        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        "Sub-LevelsCost" := NS_SLsBudgetedCost(JobCalc);
        "Sub-LevelsPrice" := NS_SLsBudgetedPrice(JobCalc);

        if NSJobSetup1."NS_Disable RevCat FactBox" = false then  //PRJCTPR-346.JS.1.0 31MAR2024
            Rec.NS_CalculateJobStatistics(JobCalc, ActualCostToDate, InvoiceBilled, "Sub-LevelsCost", "Sub-LevelsPrice", CommittedCost, "Sub-Levels", //PRJ-1135.RM.1.0
                                   CalcValues);


        JobCalc.SETFILTER("NS_Adjustment Filter", '=%1', '');
        JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        OriginalBudget := JobCalc."NS_Budgeted Cost (LCY)";
        OriginalBudget := OriginalBudget + NS_SLsBudgetedCost(JobCalc);
        OriginalContract := JobCalc."NS_Budgeted Price (LCY)";
        OriginalContract := OriginalContract + NS_SLsBudgetedPrice(JobCalc);

        JobCalc.SETFILTER("NS_Adjustment Filter", '>%1', '');
        JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        AdjustmentBudget := JobCalc."NS_Budgeted Cost (LCY)";
        AdjustmentBudget := AdjustmentBudget + NS_SLsBudgetedCost(JobCalc);
        AdjustmentContract := JobCalc."NS_Budgeted Price (LCY)";
        AdjustmentContract := AdjustmentContract + NS_SLsBudgetedPrice(JobCalc);
        //ProjectPro - end
    end;

    procedure NS_BuildSalesHeaderTemp(Job: Record Job);
    begin
        //ProjectPro - start
        with NS_SalesHeaderTemp do begin
            CLEAR(NS_SalesHeaderTemp);
            "Document Type" := "Document Type"::Invoice;
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;

            "Bill-to Customer No." := Job."Bill-to Customer No.";
            "Bill-to Name" := Job."Bill-to Name";
            "Bill-to Address" := Job."Bill-to Address";
            "Bill-to Address 2" := Job."Bill-to Address 2";
            "Bill-to City" := Job."Bill-to City";
            "Bill-to Contact" := Job."Bill-to Contact";
            "Bill-to Post Code" := Job."Bill-to Post Code";
            "Bill-to County" := Job."Bill-to County";
            "Bill-to Country/Region Code" := Job."Bill-to Country/Region Code";

            "Sell-to Customer No." := Job."Bill-to Customer No.";
            "Sell-to Customer Name" := Job."Bill-to Name";
            "Sell-to Address" := Job."Bill-to Address";
            "Sell-to Address 2" := Job."Bill-to Address 2";
            "Sell-to City" := Job."Bill-to City";
            "Sell-to Contact" := Job."Bill-to Contact";
            "Sell-to Post Code" := Job."Bill-to Post Code";
            "Sell-to County" := Job."Bill-to County";
            "Sell-to Country/Region Code" := Job."Bill-to Country/Region Code";
            "Ship-to Code" := Job."NS_Job Ship-to Code";
            "Ship-to Name" := Job."Bill-to Name";
            "Ship-to Address" := Job."Bill-to Address";
            "Ship-to Address 2" := Job."Bill-to Address 2";
            "Ship-to City" := Job."Bill-to City";
            "Ship-to Contact" := Job."Bill-to Contact";
            "Ship-to Post Code" := Job."Bill-to Post Code";
            "Ship-to County" := Job."Bill-to County";
            "Ship-to Country/Region Code" := Job."Bill-to Country/Region Code";

            "Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
            NS_Customer.GET(Job."Bill-to Customer No.");
            NS_Customer.TESTFIELD("Gen. Bus. Posting Group");
            "Gen. Bus. Posting Group" := NS_Customer."Gen. Bus. Posting Group";
            //PRJ-1152.JS.1.0 20JAN2022-Start
            // Job.TESTFIELD("NS_Gen. Prod. Posting Group"); //PRJ-1433.RM.1.0 commented
            //Rec."NS_Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group"; //PRJ-1433.RM.1.0 commented
            job.TestField("NS_Gen. Prod. Posting Group New");  //PRJ-1433.RM.1.0 
            Rec."NS_Gen. Prod. Posting Group New" := Job."NS_Gen. Prod. Posting Group New"; //PRJ-1433.RM.1.0 
            //PRJ-1152.JS.1.0 20JAN2022-end
            "Prepayment %" := Job."NS_Prepayment %";
            "Prepayment No. Series" := Job."NS_Prepayment No. Series";
            "Compress Prepayment" := Job."NS_Compress Prepayment";
            "Prepayment Due Date" := Job."NS_Prepayment Due Date";
            "Prepmt. Cr. Memo No. Series" := Job."NS_Prepmt. Cr. Memo No. Series";
            "Prepmt. Payment Terms Code" := Job."NS_Prepmt. Payment Terms Code";
            "Prepmt. Cr. Memo No." := Job."NS_Prepmt. Cr. Memo No.";
            "Currency Code" := Job."Invoice Currency Code";
            "Language Code" := Job."Language Code";
        end;


        with NS_SalesLineTemp do begin
            Job.CALCFIELDS("NS_Budgeted Price (LCY)");
            CLEAR(NS_SalesLineTemp);

            "Document Type" := "Document Type"::Invoice;
            "Document No." := NS_SalesHeaderTemp."No.";
            "Line No." := 10000;
            Amount := Job."NS_Budgeted Price (LCY)";
            "Amount Including VAT" := Amount;
            "Sell-to Customer No." := Job."Bill-to Customer No.";
            "Shipment Date" := WORKDATE;
            Description := STRSUBSTNO(Text14021101, Job."No.");
            Quantity := 1;
            "Outstanding Quantity" := 1;
            "Qty. to Invoice" := 1;
            "Qty. to Ship" := 1;
            "Unit Price" := Amount;
            "Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
            "Job No." := Job."No.";
            "Outstanding Amount" := Amount;
            "Bill-to Customer No." := Job."Bill-to Customer No.";
            "Gen. Bus. Posting Group" := NS_Customer."Gen. Bus. Posting Group";
            //PRJ-1152.JS.1.0 20JAN2022 - Start
            //"Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group";
            "Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New";
            //PRJ-1152.JS.1.0 20JAN2022 - End
            "Outstanding Amount (LCY)" := Amount;
            "VAT Base Amount" := Amount;
            "Prepayment %" := Job."NS_Prepayment %";
            "Prepmt. Line Amount" := Job."NS_Prepayment Amount";
            "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
            "Prepmt. Amt. Incl. VAT" := "Prepmt. Line Amount";
            "Prepayment Amount" := "Prepmt. Line Amount";
            "Prepmt. VAT Base Amt." := "Prepmt. Line Amount";
            "Prepmt Amt to Deduct" := "Prepmt. Line Amount";
            "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Line Amount";
            "Prepmt. Amount Inv. (LCY)" := "Prepmt. Line Amount";
            "Qty. per Unit of Measure" := 1;
            "Outstanding Qty. (Base)" := 1;
            "Qty. to Invoice (Base)" := 1;
            "Qty. to Ship (Base)" := 1;
            "Planned Delivery Date" := WORKDATE;
            "Planned Shipment Date" := WORKDATE;
            "VAT Calculation Type" := "VAT Calculation Type"::"Sales Tax";
            "Line Amount" := Amount;
        end;
        //ProjectPro - end
    end;

    procedure NS_ViewPrepayments();
    var
        NS_ViewPrepaymentLines: Page "NS_Get Prepayment LinesHistory";
    begin
        //ProjectPro - start
        NS_ViewPrepaymentLines.NS_Set("No.");
        NS_ViewPrepaymentLines.RUNMODAL;
        //ProjectPro - end
    end;

    procedure NS_UpdateSalespersonName();
    begin
        //ProjectPro - start
        if NS_Salesperson.GET("NS_Salesperson Code") then
            NS_SalespersonName := NS_Salesperson.Name
        else
            NS_SalespersonName := '';
        //ProjectPro - end
    end;

    procedure NS_SetJobSegments(lJobNo: Code[20]);
    var
        JobSegTmpl: Record "NS_Job Takeoff Segments";
        JobSegEntry: Record "NS_Job Takeoff Segments";
    begin
        JobSegTmpl.RESET;
        JobSegTmpl.SETRANGE(NS_Type, JobSegTmpl.NS_Type::Template);
        JobSegTmpl.SETRANGE("NS_Job No.", lJobNo);
        JobSegTmpl.SETFILTER("NS_Segment Code", '<>%1', '0');
        if JobSegTmpl.FINDSET(false, false) then
            repeat
                JobSegEntry := JobSegTmpl;
                JobSegEntry.NS_Type := JobSegEntry.NS_Type::Drawing;
                JobSegEntry."NS_Job No." := "No.";
                JobSegEntry.INSERT;
            until JobSegTmpl.NEXT = 0;
        ;
    end;

    //PRJ-820.JS.1.0�03August21-Start
    local procedure NS_SetAPOLinkForJob();
    var
        APOLinkHeader: Record "NS_APO Links Header";
        APOLinkLine: Record "NS_APO Links Line";
    begin
        APOLinkHeader.Reset();
        APOLinkHeader.SetRange(NS_Type, APOLinkHeader.NS_Type::Job);
        APOLinkHeader.SetRange(NS_Code, Rec."No.");
        IF NOT APOLinkHeader.FindFirst() Then begin
            APOLinkHeader.Init();
            APOLinkHeader.NS_Type := APOLinkHeader.NS_Type::Job;
            APOLinkHeader.NS_Code := Rec."No.";
            APOLinkHeader.NS_Description := copystr(Rec.Description, 1, 30);
            APOLinkHeader.Insert();

            APOLinkLine.Init();
            APOLinkLine.NS_Type := APOLinkHeader.NS_Type;
            APOLinkLine.NS_Code := APOLinkHeader.NS_Code;
            APOLinkLine."NS_Source Type" := APOLinkLine."NS_Source Type"::Cost;
            APOLinkLine."NS_Source Activity Code" := '';
            APOLinkLine."NS_Source Process Code" := '';
            APOLinkLine."NS_Source Operation Code" := '';
            APOLinkLine."NS_Source Category" := '';
            APOLinkLine."NS_Destination Type" := APOLinkLine."NS_Destination Type"::Revenue;
            APOLinkLine."NS_Destination Activity Code" := '';
            APOLinkLine."NS_Destination Process Code" := '';
            APOLinkLine."NS_Destination Operation Code" := '';
            APOLinkLine."NS_Destination Category" := '';
            APOLinkLine.Insert();
        end;
    end;
    //PRJ-820.JS.1.0�03August21-End    

    //FGH-16.SK.1.0 Start
    local procedure NS_SetFieldsEditable()

    begin
        case Rec."NS_POC Method" of
            rec."NS_POC Method"::"NS_Job forecast":
                begin
                    POCMethodValueVar := false;
                    TotalUnitsVar := false;
                    PercJobActuallyCompleteVar := false;
                    JobCompletedDateVar := false;
                    ActualUnitsCompleteVar := false;
                    UnitsCompletedDateVar := false;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;
            rec."NS_POC Method"::"NS_Gross Margin%":
                begin
                    POCMethodValueVar := true;
                    TotalUnitsVar := false;
                    PercJobActuallyCompleteVar := false;
                    JobCompletedDateVar := false;
                    ActualUnitsCompleteVar := false;
                    UnitsCompletedDateVar := false;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;
            rec."NS_POC Method"::NS_BudgettoActualCost:
                begin
                    POCMethodValueVar := false;
                    TotalUnitsVar := false;
                    PercJobActuallyCompleteVar := false;
                    JobCompletedDateVar := false;
                    ActualUnitsCompleteVar := false;
                    UnitsCompletedDateVar := false;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;
            rec."NS_POC Method"::"NS_Manual Job%":
                begin
                    POCMethodValueVar := false;
                    TotalUnitsVar := false;
                    PercJobActuallyCompleteVar := true;
                    JobCompletedDateVar := true;
                    ActualUnitsCompleteVar := false;
                    UnitsCompletedDateVar := false;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;
            rec."NS_POC Method"::"NS_Markup%":
                begin
                    POCMethodValueVar := true;
                    TotalUnitsVar := false;
                    PercJobActuallyCompleteVar := false;
                    JobCompletedDateVar := false;
                    ActualUnitsCompleteVar := false;
                    UnitsCompletedDateVar := false;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;
            rec."NS_POC Method"::"NS_Units Complete":
                begin
                    POCMethodValueVar := false;
                    TotalUnitsVar := true;
                    PercJobActuallyCompleteVar := false;
                    JobCompletedDateVar := false;
                    ActualUnitsCompleteVar := true;
                    UnitsCompletedDateVar := true;
                    PercCompletedVar := false;
                    PercInvoicedVar := false;
                    // ManualJobDateVar := false;
                end;

        end;
    end;
    //FGH-16.SK.1.0 End  

    //PRJ-1349.JS.1.0 15MAY2022 - Start
    /// <summary>
    /// NS_GetBudgetedCostLCYForProjection.
    /// </summary>
    /// <param name="JobNo">code[20].</param>
    /// <returns>Return variable BudgetCostLCYForProj of type Decimal.</returns>
    procedure NS_GetBudgetedCostLCYForProjection(JobNo: code[20]) BudgetCostLCYForProj: Decimal
    var
        NSJobPlenningLineA: Record "Job Planning Line";
        NSJobRec: Record job;
        NSJobSetupA: Record "Jobs Setup";
    begin
        NSJobSetupA.get();
        if NSJobSetupA."NS_Budgeted Cost on Projection" = true then begin
            BudgetCostLCYForProj := 0;
            if NSJobRec.get(JobNo) then;
            NSJobPlenningLineA.Reset();
            NSJobPlenningLineA.SetRange("Job No.", NSJobRec."No.");
            NSJobPlenningLineA.SetFilter("Line Type", '<>%1', NSJobPlenningLineA."Line Type"::Billable);
            if NSJobPlenningLineA.FindSet() then begin
                NSJobPlenningLineA.CalcSums("Total Cost (LCY)");
                BudgetCostLCYForProj := NSJobPlenningLineA."Total Cost (LCY)";
            end;
        end;
        exit(BudgetCostLCYForProj);
    end;
    //PRJ-1349.JS.1.0 15MAY2022 - end

    //PRJCTPR-147.PS.2.0 20Sep2023 Start
    local procedure NSManagerStatusEdite(): Boolean
    var
        myInt: Integer;
        NS_Job: Record Job;
    begin
        NS_CRManagerStatus := true;
        NS_Job.SetRange("No.", Rec."No.");
        NS_Job.SetRange("NS_Job Class", NS_Job."NS_Job Class"::"Change Request");
        NS_Job.SetRange(Status, NS_Job.Status::Completed);
        if NS_Job.FindFirst() then
            NS_CRManagerStatus := false;
        exit(NS_CRManagerStatus);
    end;
    //PRJCTPR-147.PS.2.0 20Sep2023  End 



    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Actual Percent Complete          CustomerPONumber          Job Ship-to Code            Recognition Date
      +     Actual Percent Complete          Default Job Retention      Job State                    Requires Certified Payroll
      +     Actual Percent Complete Date    Estimated Completion Date   Job Status Date              Salesperson Code
      +     Actual Units Complete            Estimated Start Date      Job Type                    Schedule Total Cost
      +     Actual Units Complete Date      Estimator                  Locked Planning Lines Exist   Sell-to Customer Name
      +     Actual Units Complete Date"      Estimator Name            Manager                      Sell-to Customer No.
      +     Allow Schedule/Contract Lines    Forecast Type              Manager Job Status          Sub-Level to Job No.
      +     Billing Day of Month            Gen. Prod. Posting Group  ManagerName                  Tax Area Code
      +     Budgeted Price (LCY)            Indirect Burden Type      Original Budget Created      Tax Bus. Posting Group
      +     CalcValues[]                    Job Address 1              PercentOverdue              Tax Group Code
      +     Completion Date                  Job Address 2              Person Responsible Name      Tax Liable
      +     Compress Prepayment              Job Calendar Code          NS_SalespersonName          Tax Prod. Posting Group
      +     Contract Date                    Job City                  Prepayment %                Time And Material
      +     Contract For                    Job Class                  Prepayment Amount            Total Units
      +     Contract No.                    Job Contact                Prepayment Due Date          Unit of Measure
      +     Contract Sell Price              Job Country                Prepmt. Payment Discount %  Use Job Material Planning
      +     Contract Type                    Job Phone                  Prepmt. Payment Terms Code  WIP Method
      +     Cust. Job No.                    Job Post Code              Progress Billing No.
      +     Customer PO Number              Job Posting Date          Progress Billing Sub-Level
      +
      +   Group - Cost Categories    BudgetedActual  Cost    Cost
      +     SOURCE = CalcValues[]    Cost    Cost    VarianceVariance %
      +     NS_LaborCostLbl          [4,1]   [4,2]    [4,3]    [4,4]
      +     NS_MaterialCostLbl      [4,5]    [4,6]    [4,7]    [4,8]
      +     NS_EquipmentCostLbl      [4,9]    [4,10]  [4,11]  [4,12]
      +     NS_SubcontractCostLbl    [4,13]  [4,14]  [4,15]  [4,16]
      +     NS_ManufacturingCostLbl   [4,17]  [4,18]  [4,19]  [4,20]
      +     NS_OverheadCostLbl      [4,21]  [4,22]  [4,23]  [4,24]
      +     NS_MiscellaneousCostLbl  [4,25]  [4,26]  [4,27]  [4,28]
      +     NS_UncategorizedCostLbl  [4,29]  [4,30]  [4,31]  [4,32]
      +     NS_CostTotalsLbl        [4,33]  [4,34]  [4,35]  [4,36]
      +
      +   Group - Rev Categories     BudgetedActual  Revenue  Revenue
      +     SOURCE = CalcValues[]    Revenue  Revenue  VarianceVariance %
      +     NS_LaborRevLbl          [5,1]    [5,2]    [5,3]    [5,4]
      +     NS_MaterialRevLbl        [5,5]    [5,6]    [5,7]    [5,8]
      +     NS_EquipmentRevLbl      [5,9]    [5,10]  [5,11]  [5,12]
      +     NS_SubcontractRevLbl    [5,13]  [5,14]  [5,15]  [5,16]
      +     NS_ManufacturingRevLbl  [5,17]  [5,18]  [5,19]  [5,20]
      +     NS_OverheadRevLbl        [5,21]  [5,22]  [5,23]  [5,24]
      +     NS_MiscellaneousRevLbl  [5,25]  [5,26]  [5,27]  [5,28]
      +     NS_UncategorizedRevLbl  [5,29]  [5,30]  [5,31]  [5,32]
      +     NS_RevenueTotalsLbl      [5,33]  [5,34]  [5,35]  [5,36]
      +
      +  - Added function(s):
      +     NS_BlockShipTo            NS_JobLinkNextRecord      NS_UpdatePersonResponsibleName
      +     NS_BuildSalesHeaderTemp     NS_OnAfterGetCurrRecord    NS_UpdateSalespersonName
      +     NS_CalcStatistics          NS_SetJobSegments          NS_ViewPrepayments
      +     NS_GoBackward              NS_UpdateEstimatorName
      +     NS_GoForward              NS_UpdateManagerName
      +
      +  - Added global variable(s):
      +     ActualCostToDate            Job CityEditable              JobSubContractList      PurchInvLine
      +     AdjustmentBudget            Job CountyEditable            ManagerName              PurchSetup
      +     AdjustmentContract          Job PhoneEditable              OriginalBudget          Resource
      +     BaseCalendar                Job Post CodeEditable          OriginalContract        SalesCrMemoLine
      +     CalcValues                  JobCalc                        PaymentReceived          SalesInvoiceLine
      +     CommittedCost                JobCalendar                    PersonResponsibleName     SalesSetup
      +     CommittedLineList            JobCalendarCode                NS_ApprovalMgt          ShipToAddress
      +     CurrencyCodeEditable        JobCountryRegionCodeEditable    NS_Customer              ShowJobRec
      +     CustLedgEntryRetention      JobForecastWorksheet          NS_GLSetup              Sub-LevelJob
      +     DtldCustLedgEntries          JobLedgEntry                  NS_PaymentTerms          Sub-Levels
      +     EstimatorName                JobLedgerEntries              NS_SalesHeaderTemp      Sub-LevelsCost
      +     InvoiceBilled                JobLinks                      NS_SalesLineTemp        Sub-LevelsPrice
      +     InvoiceCurrencyCodeEditable   JobList                        NS_Salesperson          TotalBudgetedCost
      +     Job Address 1Editable        JobPlanningList                NS_SalespersonName      VendLedgEntryRetention
      +     Job Address 2Editable        JobsSetup                      PurchCrMemoLine
      +
      +  - Added global text constant(s):
      +     NS_CostTotasLbl          NS_OverheadCostLbl      Text14021104      Text19061674
      +     NS_EquipmentCostLbl      NS_OverheadRevLbl        Text14021105      Text19065266
      +     NS_EquipmentRevLbl      NS_RevenueTotalsLbl      Text19000744      Text19068395
      +     NS_LaborCostLbl          NS_SubcontractCostLbl    Text19004432      Text19072856
      +     NS_LaborRevLbl          NS_SubcontractRevLbl    Text19015578      Text19078857
      +     NS_MaterialCostLbl      NS_UncategorizedCostLbl   Text19019020      Text19080001
      +     NS_MaterialRevLbl        NS_UncategorizedRevLbl  Text19022646      Text19080002
      +     NS_MfgCostLbl            Text14021100            Text19031882      Text19080003
      +     NS_MfgRevLbl            Text14021101            Text19036146      Text19080004
      +     NS_MiscellaneousCostLbl  Text14021102            Text19047697
      +     NS_MiscellaneousRevLbl  Text14021103            Text19050914
      +
      +     NS_BudgetUsedPctLbl
      +     NS_CostsToDateLbl
      +     NS_BudgetRemainingLbl
      +     NS_BudgetedTotalsCostsLbl
      +     NS_BudgetedProfitLossLbl
      +     NS_BudgetedOrifitPctLbl
      +
      +  - Modification(s):
      +     - OnInit              - Set Sub-Levels to TRUE
      +     - OnOpenPage          - Read setup records
      +                                 SalesSetup
      +                                 PurchSetup
      +                                 JobsSetup
      +                                 NS_GLSetup
      +                           - Run setup
      +                                 NS_BlockShipTo
      +     - OnNextRecord        - Set StepsTaken value based on call to NS_JobLinkNextRecord
      +                           - Set Temp Linked Parent Job No.
      +     - OnAfterGetRecord    - Added call to NS_OnAfterGetCurrRecord
      +     - OnNewRecord         - Set values for
      +                                 Job Class
      +                                 OriginalBudget := 0;
      +                                 OriginalContract := 0;
      +                           - Calls to
      +                                 NS_BlockShipTo;
      +                                 NS_OnAfterGetCurrRecord;
      +
      +     - Added action lists:
      +
      +         Added to Action Group - Job            Added Action Group - Take-Off              Added Action Group - PrePayment
      +          Job Task Lines                         Get Job Segments                            Added Action Group - Activity
      +           PP Planning Lines (Editable)         Get Job Task Segments                        Post Prepayment Invoice
      +           JM Planning                           Job Segments                                  Post and Print Prepmt. Invoice
      +           PP Subcontracts                      Added to Action Group - WIP                    Post Prepayment Credit Memo
      +           PP Progress Billings                 Calculate WIP                                Post and Print Prepmt. Cr. Memo
      +           PP Draws                             Post WIP to G/L                              Page Posted Sales Invoices
      +           PP Job Forecast Worksheet            Added to Action Group - Prices                Prepayment Credit Memos
      +           CreateJobJournal                     Page Job Cost Category Prices                Prepayment History
      +           PP Links                                 ==> Cost Category
      +           PP APO Links
      +           PP Job Contacts
      +           PP CustomReports
      +           ImportExcelSht
      +
      +         Added to Action Group - History        Added to Acton Group - Reports             Added Action Group - Job Analysis
      +           Job Billing History                   Added Action Group - Actual vs Budget      Job Detail by Task
      +           Job Journal;                           Act vs Bud Cost by Task                  Job Gross Profit
      +         Added Action Group - NewDocumentItems     Act vs Bud Cost by Task with Qty        Committed Cost Detail
      +           Action Group - ActionItems             Act vs. Bud Cost Work Units by Task      Print Work Order
      +             Create Change Order                Added Action Group -  Pct of Completion      Job Rcvd Not Invoiced
      +             Create Work Order                   Pct of Completion                          Create Sales Invoice
      +         Added Action Group - Prepayment         Pct of Completion by Dim                  Job Cost Budget by Task/Segment
      +           Added Action Group - Activity         Pct of Completion with GM
      +             Post Prepayment Invoice            Added Action Group - Job Mat/Labor Analysis
      +             Post and Print Prepmt. Invoice     Act vs Bud Material by Task
      +             Post Prepayment Credit Memo         Act vs Bud Qty by Task
      +             Post and Print Prepmt. Cr. Memo     Act vs Bud Job Hours
      +             Prepayment Invoices
      +             Prepayment Credit Memos
      +             Prepayment History
      +             Schedule of Values
      +
      +     - Removed Foreign Trade fasttab - fields moved to Contants/Manager fasttab
      +         Currency Code               Exch.Calculation (Cost)
      +         Invoice Currency Code       Exch.Calculation (Price)
      +
      +     - Modify action list:
      +        - Set Promoted to FALSE
      +            Statistics                          Reports -
      +            Ledger Entries                        Job Analysis
      +            Copy Job Tasks &from...               Job - Planning Lines
      +            Copy Job Tasks &to...                 Job Actual to Budget (Cost)
      +            Job Analysis                          Job Cost Suggested Billing
      +            Job Planning Lines
      +            Job Actual to Budget (Cost)
      +            Job Cost Suggested Billing
      +            Ledger Entries
      +
      +        - Set Visable = FALSE & Enabled = FALSE as needed
      +            Job Cost Budget                         Job Actual to Budget (Price)
      +            Job Analysis                            Open Purchase Invoices by Job
      +            Job - Planning Lines                    Open Sales Invoices by Job
      +            Job Cost Transaction Detail             Job Cost Suggested Billing
      +            Job Actual to Budget (Cost)
      +
      +     - Modified controls:
      +         Rename Group caption from General to Job Info
      +         No. - OnLookup - Added call to JobList
      +         WIP Method - Set Name to WIPMethod
      +     - Rename Field
      +         Job Cost Transaction Detail to Job - Planning Lines
      +     - Added Factboxes
      +         Job Budget/Billable FactBox
      +         Job Adjtd Bud/Billable FactBox
      +         Actual Cost/Billings FactBox
      +         Budg. Analysis/Profits FactBox
      +     - Moved to General fasttab
      +         Bill-to Customer No.
      +
      +
      +
      +-----------------------------------------------------------------------------------------------
      */

}

