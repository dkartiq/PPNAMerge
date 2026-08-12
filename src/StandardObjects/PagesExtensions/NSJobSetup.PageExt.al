pageextension 14021260 NS_JobSetupExt extends "Jobs Setup"
{

    //ContextSensitiveHelpPage = 'user-guide/';   //PRJ-1556.JS.1.0 24AUG2022
    // version NAVW111.00,NSNA11.00
    //PRJ-39.SK.1.0 - Added LookupPageID property on fields
    //PRJ-191.AS.1.0 - 2APRIL2020 - Corrected caption of 'Progress Billiing' to 'Progress Billing'
    //PRJ-291.MS.1.0 Added new field
    //NSAL-64.MS.1.0 added new field
    //CTSI-95.MS.1.0 added new field
    //CTSI-115.AS.1.0 Added new field
    //TM-10.AM.1.0 Added New Field.
    //PRJ-459.MS.1.0 added new field
    //CTSI-268.MS.1.0 added new field
    //PRJ-530.AS.1.0 8FEB2021 Commented code
    //PRJ-562/MGLBC-4 to remove filed from Progress Payment TAB
    //PRJ-639.RS.1.0 19May2021 | Creat the tool tip Specific to PP Fields
    //PRJ-756.RS.1.0 18June21 | Shifting of "Auto Lock Planning Line" field from Job Quoting Fast Tab to General Fast Tab on Job Setup
    //PRJ-659.JS.1.0�27July2021 | Remove NS form two fast tabs
    //CTSI-254.MS.1.0 added 2 new field
    //PRJ-866.JS.1.0  19Aug2021 | Add one field
    //PRJ-881.JS.1.0 25Aug2021 | update fields
    //PRJ-889.GK.1.0 13Sep2021 | Add one field
    //PRJ-929.GK.1.0 22Sep2021 | Add one field
    //PRJ-935.RM.1.0 04-Oct-2021 | Modify Tooltip of a field
    //PRJ-945.RM.1.0 04-Oct-2021 | Modify Tooltip of  fields
    //PRJ-973.GK.1.0 13Oct2021 | Add one field.
    //PRJ-985.RM.1.0 14Oct2021 | Modified Tooltip of field
    //PRJ-986.RM.1.0 14Oct2021  | Made field invisible
    //PRJ-987.RM.1.0 14Oct2021 | Modified Tooltip of field
    //PRJ-1087.JS.1.0 18Dec2021 | Add one field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1098.NK.1.0 15Feb2022 | Add One Field
    //PRJ-1262.RM.1.0 28March2022 | Added a field
    //PRJ-1299.JS.1.0 18APR2022 | Add one field
    //PRJ-1349.JS.1.0 15MAY2022 | Add one Field 
    //PRJ-1389.RM.1.0 23May2022 | Made fields invisible
    //PRJ-1438.RM.1.0 06June2022 | Made a field invisible
    //PRJ-1510.NK.1.0 21Jul2022 | Added Field
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
    //PRJ-1579.RM.2.0 31Aug2022 | Added a tooltip
    //PRJ-1617.RM.1.0 07Sep2022 | Added some code
    //PRJ-1669.RM.1.0 14Oct2022 | Added a tooltip
    //PRJ-1711.RM.1.0 24Nov2022 | Added a tooltip 
    //PRJ-1711.RP.1.0 24Nov2022 | Added a tooltip
    //PRJ-1454.NK.1.0 13Jan2023 | Added Code
    //PE-45.RM.1.0 13Feb2023 | Added tooltip
    //PRJCTPR-78.NC.1.0 24Mar2023 | Obsolete Property
    //PRJCTPR-151.RM.1.0 10July2023 | Added a tooltip
    //PE-132.RM.1.0 19July2023 | Added some code
    //PRJCTPR-162.RM.1.0 21July2023 | Added some code and tested the same on the web client.
    //PE-167.VC.1.0 18Sep2023 | Job -> status -> WIP Message -> Setup -> to disable message.
    //PE-170.HS.1.0 27Sept2023 |Changed Tooltip and Caption
    //PRJCTPR-209.HS.1.0 27Oct2023 | Add tooltip and caption
    //PE-210.HS.1.0 23Nov2023| Add Code
    // PE-229.HS.1.0 14Dec2023 | Add field
    //PRJCTPR-279.HS.1.0 17Jan2024 | Obselete Field
    //PE-247.HS.1.0 6Feb2024 | Added code
    Caption = 'Jobs Setup'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        //PE-323 AT.01 03July2024 start
        addafter(General)
        {
            group("NS_Item& Resources")
            {
                Caption = 'Items & Resources';
                field("NS_Explode Linked Resource"; rec."NS_Explode Linked Resource")
                {
                    ApplicationArea = All;
                    Caption = 'Explode All Linked Resource';
                    ToolTip = 'Specifies if you want to explode all linked resources on the job planning lines upon entering the Quantity for an item having "Linked Resource" Boolean checked. By default, this is off which would only pull the Default linked resource on the job planning lines.';
                }
            }
        }
        //PE-323 AT.01 03July2024 end
        addfirst(General)
        {
            group("NS_Cost Categories Required")
            {
                Caption = 'Cost Categories Required';
                field("NS Cost Category Required Bud"; Rec."NS_Cost Category Required Bud")
                {
                    ApplicationArea = All;
                    Caption = 'On Budget Entries';
                    ToolTip = 'Specifies that you want the program to ask the Cost Categories on Budget Entries ';//PRJ-639.RS.1.0 19May2021
                }
                field("NS Cost Category Required"; Rec."NS_Cost Category Required")
                {
                    ApplicationArea = All;
                    Caption = 'On Actual Entries';
                    ToolTip = 'Specifies that you want the program to ask the Cost Categories on Actual Entries '; //PRJ-639.RS.1.0 19May2021
                }
            }
            group("NS_Revenue Categories Required")
            {
                Caption = 'Revenue Categories Required';
                field("NS Rev Category Required Bud"; Rec."NS_Revenue Cat. Required Bud")
                {
                    ApplicationArea = All;
                    Caption = 'On Budget Entries';
                    ToolTip = 'Specifies that you want the program to ask the Revenue Categories on Budget Entries ';//PRJ-639.RS.1.0 19May2021
                }
                field("NS Rev Category Required"; Rec."NS_Revenue Category Required")
                {
                    ApplicationArea = All;
                    Caption = 'On Actual Entries';
                    ToolTip = 'Specifies that you want the program to ask the Revenue Categories on Actual Entries ';//PRJ-639.RS.1.0 19May2021
                }
                //PE-249.JS.1.0 08FEB2024 - Start
                field("NS_Mandate Revenue Category"; Rec."NS_Mandate Revenue Category")
                {
                    caption = 'Mandate Revenue Category';
                    ApplicationArea = All;
                    ToolTip = 'Enable this to make �Revenue Category Code� for every job planning line and transaction. This will allow you to enter the code against Budget planning/actual lines. Currently, the system does not allow you to enter Rev. Cat. Code on Budget planning lines.';
                }
                //PE-249.JS.1.0 08FEB2024 - end
            }
            field("NS Post Labor Burden To Job"; Rec."NS_Post Labor Burden RateToJob")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Post Labor Burden Rate To Job';
                //PE-132.RM.1.0 19July2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in upcoming build';
                ObsoleteTag = 'Will be removed in upcoming build';
                //PE-132.RM.1.0 19July2023 End
            }
            field("NS Labor Burden Cost Category"; Rec."NS_Payroll Burden Job Cost Cat")
            {
                ApplicationArea = All;
                Caption = 'Payroll Burden Cost Category';
                ToolTip = 'Specifies the Payroll Burdon Cost Categiories.';//PRJ-639.RS.1.0 19May2021
            }
            field("NS Warning on Zero Multiplier"; Rec."NS_Warning on Zero Multiplier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Warning on Zero Multiplier';
                visible = false; //PRJ-1389.RM.1.0 
                                 //PE-132.RM.1.0 19July2023 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in upcoming build';
                ObsoleteTag = 'Will be removed in upcoming build';
                //PE-132.RM.1.0 19July2023 End
            }
            field("NS Item Jnl Use Budgeted Cost"; Rec."NS_Item JNL Use Budgeted Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Item Journal Use Budgeted Cost';
                Visible = false; //PRJ-1389.RM.1.0 
            }
            field("NS Default Job Class"; Rec."NS_Default Job Class")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Default Job Class'; //PRJ-639.RS.1.0 19May2021 Comment
                // ToolTip = 'Specifies the categorization of job class while creating a new Job.';//PRJ-639.RS.1.0 19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Select the Default Job Class to be used when creating a new Job.  Typically, the "Master Job" would be used.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS Default Deposit Job Task No"; Rec."NS_Default Deposit JobTaskNo.")
            {
                ApplicationArea = All;
                Enabled = false;
                ToolTip = 'Specifies the Default Deposit Job Task No.';
                Visible = false;
            }
            //PRJ-929.GK.1.0 22Sep2021 start
            field("NS_Use Tax Percentage"; Rec."NS_Use Tax Percentage")
            {
                ToolTip = 'Specifies the value of the Use Tax Percentage field';
                ApplicationArea = All;
            }
            //PRJ-929.GK.1.0 22Sep2021 end
            //PRJ-973.GK.1.0 13Oct2021 start
            field("NS_Use Job Plan. Line Entries"; Rec."NS_Use Job Plan. Line Entries")
            {
                // ToolTip = 'Specifies the boolean if Progress Billing flow same G/L in Sales Document.'; //PE-170.HS.1.0 27Sept2023 Commented
                ToolTip = 'Enable this field to flow the same G/L Account No. from Job Planning Lines to Sales Document via Progress Billings. Disabling this, the system will follow the same rule to flow G/L Account No. on Sales Document via Progress Billings based on the Job Posting Group selected on the Job Task Lines or Job Card.'; //PE-170.HS.1.0 27Sept2023
                ApplicationArea = All;
            }
            //PRJ-973.GK.1.0 13Oct2021 end
            field("NS APO Separators"; Rec."NS_APO Separators")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the APO Separators'; //PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the default separators while creating job task lines between Activities, Process and Operations codes.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'The symbol that will be used to separate the Activity, Process, Operation and Section task codes.  Typically, this is a dash ''-'''; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS Activity Code Position"; Rec."NS_Activity Code Position")
            {
                ApplicationArea = All;
                Caption = 'Activity Code Position in Job Task No.';
                MultiLine = true;
                // ToolTip = 'Specifies the positioning of the activity on the job task number.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Specifies the positioning of the Activity in the Job Task number.  Typically, the Activity is "1" position.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS KPI Calculation Start Date"; Rec."NS_KPI CalculationStartingDate")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies KPI Calculation Starting Date'; //PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies Starting date of the Key Process Indicator (KPI).';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'This date is normally blank in which the Key Performance Indicator (KPI) automatically uses 12 months back from today''s date.  You will find the KPI information on the ProjectPro Manager Role Center.  If you wish to change  the date range of information for the KPI calculations, enter the  the ''Beginning Date'' for when you want the indicator to start from. '; //PRJ-1711.RM.1.0 24Nov2022
                                                                                                                                                                                                                                                                                                                                                                                                        //PE-132.RM.1.0 19July2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in upcoming build';
                ObsoleteTag = 'Will be removed in upcoming build';
                //PE-132.RM.1.0 19July2023 End
            }
            field("NS KPI Calculation Ending Date"; Rec."NS_KPI Calculation Ending Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies KPI Calculation Ending Date';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies Ending date of  the Key Process Indicator (KPI).';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'This date is normally blank in which the Key Performance Indicator (KPI) automatically uses 12 months back from today''s date.  You will find the KPI information on the ProjectPro Manager Role Center.  If you wish to change  the date range of information for the KPI calculations, enter the  the ''Ending Date'' for when you want the indicator to the end.'; //PRJ-1711.RM.1.0 24Nov2022
                                                                                                                                                                                                                                                                                                                                                                                                 //PE-132.RM.1.0 19July2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in upcoming build';
                ObsoleteTag = 'Will be removed in upcoming build';
                //PE-132.RM.1.0 19July2023 End
            }
            field("NS Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Gen. Bus. Posting Group';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies that default Gen. Bus. Posting group code to be picked in Purchase and Sales documents.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'The Gen. Bus Posting Group will flow from the Job Setup to Job Card and from Job Card to Sales Invoice/ Purchase Invoice Document, overwriting Vendor & Customer Posting Group.'; //PRJ-1711.RM.1.0 24Nov2022 
            }
            field("NS Job Calendars Not Used"; Rec."NS_Job Calendars Not Used")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendars Not Used';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies that it should be true when job calendars are not to be used.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS GBPG for Job Forecast"; Rec."NS_GBPG for Job Forecast")//CTSI-115.AS.1.0 Added field
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the GBPG for Job Forecast';//PRJ-639.RS.1.0�19May2021 Comment
                Caption = 'GBPG for Sub-Job Forecast';
                ToolTip = 'Specifies the General  business posting group for the sub-level jobs to be included in job forecast worksheet posting.';//PRJ-639.RS.1.0�19May2021
            }
            //PRJCTPR-308.DK.1.0 11June2024 Start
            field("NS Job Calendar Source"; Rec."NS_JobCalendarSource")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendar Source';//PRJ-639.RS.1.0 19May2021 Comment
                // ToolTip = 'Specifies the source of the calendar It can be either Navision Calendar or Job calendar.';//PRJ-639.RS.1.0 19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'This field is recommended to be Business Central Calendar. '; //PRJ-1711.RM.1.0 24Nov2022
                trigger OnValidate()
                begin
                    //ProjectPro - start
                    //IF Rec."NS_Job Calendar Source" <> xRec."NS_Job Calendar Source" THEN//PRJ-1135.RM.1.0
                    //    Rec."NS_Job Calendar Code" := '';//PRJ-1135.RM.1.0
                    IF Rec."NS_JobCalendarSource" <> xRec."NS_JobCalendarSource" THEN
                        Rec."NS_Job Calendar Code" := '';
                    //ProjectPro - end
                end;
            }
            //PRJCTPR-308.DK.1.0 11June2024 End
            field("NS Job Calendar Code"; Rec."NS_Job Calendar Code")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendar Code';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the calendar code for jobs as per the calendar source selected.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'This field is recommended to blank.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            //TM-10.AM.1.0 start
            field("NS_Job Segment Mandatory"; Rec."NS_Job Segment Mandatory")
            {
                ApplicationArea = all;
                Caption = 'Job Segment Mandatory';
                // ToolTip = 'Specifies that the job segment is mandatory for every transaction related to job';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'If "Yes", Segment Field will be required. '; //PRJ-1711.RM.1.0 24Nov2022
            }
            //TM-10.AM.1.0 End
            //PE-81.Dk.1.0 Start
            field("NS_FA Job Segment Mandatory"; Rec."NS_FA Job Segment Mandatory")
            {
                ToolTip = 'Enableing this field make "FA Job Segment Mandatory" on Purchase documents';
                ApplicationArea = all;
                Caption = 'FA Job Segment Mandatory';
            }
            //PE-81.Dk.1.0 End
            field("NS_Get Job Segment"; Rec."NS_Get Job Segment")
            {
                ApplicationArea = all;
                // ToolTip = 'Specifies to Get the Job Segement '; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                // ToolTip = 'Specifies to get the Job Segement '; //PRJ-1579.RM.2.0 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'If "Yes", System will carry  the Segment from Master Job to Sub-Levels jobs.'; //PRJ-1711.RM.1.0 24Nov2022
                Description = 'PRJ-291.MS.1.0';
            }
            field("NS_Auto Lock Planning Lines"; Rec."NS_Auto Lock Planning Lines")//PRJ-756.RS.1.0 18June21 It has Moved from "Job Quoting" Group
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies that case you can auto lock the job planning lines.';//PRJ-639.RS.1.0�19May2021 //PRJ-756.RS.1.0 18June21 Commented
                ToolTip = 'Specifies that you want the program to Lock the Planning Lines';//PRJ-756.RS.1.0 18June21
            }
            //PE-210.HS.1.0 23Nov2023 Start
            field(NS_CostExceedsColor; Rec.NS_CostExceedsColor)
            {
                ApplicationArea = All;
                ToolTip = 'Enable to highlight the amount in Red on Purchase Order or Subcontract lines when it exceeds the cost defined on respective Job Planning Lines. This will also highlight the "Actual Cost" and the "Invoiced Price" amounts on the Job Task Lines, when they get exceeded by the "Budgeted Cost" and the "Billable Price", respectively.';
            }
            //PE-210.HS.1.0 23Nov2023 End

        }
        addafter("Logo Position on Documents")
        {
            field("NS Forecast Percent For Hours Req"; Rec."NS_Forecast Percent For HrsReq")
            {
                ApplicationArea = All;
                Caption = 'Forecast Percent For Hours Req';
                //ToolTip = 'Specifies the Forecast Percent For Hours Req';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies that at what percent of your budget should trigger hours to finish by project managers.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Specifies at what percent of your budget should trigger Project Manager to perform Job Forecast for completion.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS Default Forecast Type"; Rec."NS_Default Forecast Type")
            {
                ApplicationArea = All;
                Caption = 'Default Forecast Type';
                //ToolTip = 'Specifies the Default Forecast Type';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the type of  Job Forecast be available and calculations on the basis of : % of  Budget or % of  Projected. Recommend % of  Projected if you will be using the Job Forecast Tool.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Select the type of Job Forecast calculations based on: % of Budget or % of Projected. % Of Projected is the recommended option, if using the Job Forecast Tool.';  //PRJ-1711.RM.1.0 24Nov2022
            }
            //PE-130.NC.1.0 17July2023 Start
            field("NS_Default Draw Pay Terms Code"; Rec."NS_Default Draw Pay Terms Code")
            {
                ApplicationArea = All;
                Caption = 'Default Draw Payment Terms Code';
                ToolTip = 'Specifies the Default Draw Payment Terms Code to be set for vendors as a default when using "Pay when Paid" business process. The "Pay when Paid" is the term of paying your vendors when your customer pays you, i.e., This will get updated on the purchase documents when a Draw No. is selected. This is typically set in ProjectPro with the one set to "999D" due date calculation.';
            }
            //PE-130.NC.1.0 17July2023 End
            field("NS  Default Draw Payment Terms"; Rec."NS_Draw Default Payment Terms")
            {
                ApplicationArea = All;
                //Caption = 'Default Draw Payment Terms'; //PE-130.NC.1.0 17July2023 Block
                Caption = 'Default Draw Due Date Calculation'; //PE-130.NC.1.0 17July2023
                Editable = false; //PE-130.NC.1.0 17July2023
                //ToolTip = 'Specifies the Default Draw Payment Terms';//PRJ-639.RS.1.0�19May2021 Comment
                //ToolTip = 'Specifies the payment terms to be set for vendors as a default when using �Pay when Paid� business process.The �Pay when Paid� is the term of paying your vendors when your customer pays you. This is typically set in ProjectPro to 999D.';//PRJ-639.RS.1.0�19May2021 //PE-130.NC.1.0 26July2023 Block
                ToolTip = 'Specifies Default Due Date Calculation based on Payment Terms Code selected above.'; //PE-130.NC.1.0 26July2023
            }
            field("NS Allow Timesheet & Job Jnl"; Rec."NS_Allow Timesheet&JobJnlPost")
            {
                ApplicationArea = All;
                Caption = 'Allow Time Sheet & Job Jnl';
                //ToolTip = 'Specifies the Allow Time Sheet & Job Jnl';//PRJ-639.RS.1.0�19May2021 Comment 
                // ToolTip = 'Specifies and enables users to enter resources on the Job Journal even though their resource card is set to �allow time sheet entry�.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'This enables a User to enter Resource''s time either directly through the Job Journal or employee can enter their own Timesheet if their Resource Card is set to �Allow Time Sheet Entry�. '; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS_Received Accrual Batch Name"; Rec."NS_Received Accrual Batch Name")
            {
                ApplicationArea = All;
                Caption = 'Rcvd. Accr. Batch Name';
                // ToolTip = 'Specifies the Rcvd. Accr. Batch Name'; //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Specifies the Batch Name  for Revenue Recognition to keep entities separate from standard entries'; //PRJ-1711.RM.1.0 24Nov2022
                ObsoleteState = Pending; //PRJCTPR-78.NC.1.0 24Mar2023
                ObsoleteTag = 'Remove in ProjectPro upcoming build 21.0.xx.49984'; //PRJCTPR-78.NC.1.0 24Mar2023
                ObsoleteReason = 'This field is no more required because we update the same with new functionality Accrual interim entry.'; //PRJCTPR-78.NC.1.0 24Mar2023
            }
            field("NS_Allow Updates To Orig Planning"; Rec."NS_Allow UpdatesToOrigPlanning")
            {
                ApplicationArea = All;
                // ToolTip = 'Specifies the Allow Updates To Orig Planning'; //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'If "Yes" this will allow the QTY & Rate on the  Planning Lines to be changed  - even after the Purchase Order has been generated.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS_Highlight Price Less Than Cost"; Rec."NS_HighlightPrice LessThanCost")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Highlight Price Less Than Cost';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies and highlight the planning lines in red, Italicized font to indicate that your price is less than your cost.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS_APO Sep Change In Progress"; Rec."NS_APO Sep Change In Progress")
            {
                ApplicationArea = all;
                Description = 'PRJ-459.MS.1.0';
                Visible = false;
            }
            //PRJ-490.AM.1.0 start
            group("NS_FA Job Purchase")
            {
                Caption = 'FA Job Purchase';
                field("NS_FA Job Template Name"; Rec."NS_FA Job Template Name")
                {
                    ApplicationArea = all;
                    // ToolTip = 'Specifies the job journal template for FA posting with job.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Job Journal Template for FA posting with Job. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_FA Job Batch Name"; Rec."NS_FA Job Batch Name")
                {
                    ApplicationArea = all;
                    // ToolTip = 'Specifies the Job journal batch based on the template selected on prior field.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Job Journal Batch based on the Template selected on prior field. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_Check Master Job No."; Rec."NS_Check Master Job No.")//PRJ-604.AS.1.0
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Check Master Job No.'; //PRJ-987.RM.1.0 14Oct2021 |Comment Code
                    // ToolTip = 'Specifies the validation of the newly created Job Task No. in Sub Level Jobs against the Master Job'; //PRJ-987.RM.1.0 14Oct2021| Add Code //PRJ-1711.RM.1.0 24Nov2022 commented
                    // ToolTip = 'Specifies the validation of the newly created Job Task No. in Sub Level Jobs against the Master Job'; //PRJ-1711.RM.1.0 24Nov2022 //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'If enabled, when creating a Sub-Job from a Master Job card, only Job Task Lines from the Master Job will be available to copy over.'; //PE-45.RM.1.0 13Feb2023 
                }

                field("NS_Notify Insurance Exp"; Rec."NS_Notify Insurance Exp")//PRJ-1040.AS.1.0
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies Notify Insurance Expiration'; //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Toggle �On� or �Off� to enable or disable notification of Vendor Insurance Expiration.'; //PRJ-1711.RM.1.0 24Nov2022

                }
                field(NS_EnableItemNosForProgBill; Rec.NS_EnableItemNosForProgBill)//PRJ-1061.AS.1.0
                {
                    ApplicationArea = all;
                    // ToolTip = 'Specifies Enable Item Nos. For Progress Billing';//PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Toggling it �On� means that in Progress Billing, Type Item will be updated in the line instead of the G/L Account No. Toggling it �Off� means that in Progress Billing, Type G/L will be updated in the lines from Job Posting Setup.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1079.GK.1.0 14Dec2021 start
                field("NS_Enable CalcPlanOnNonInvItem"; Rec."NS_Enable CalcPlanOnNonInvItem")
                {
                    // ToolTip = 'Specifies the value of the Enable PP Calc Plan for Non Inv Item in Requisition Worksheet.'; //PRJ-1711.RM.1.0 24Nov2022
                    ToolTip = 'Toggle it �On� or �Off� based on whether you want to include Non Inventory Items in the PP Calculate Plan function in Requisition Worksheet.'; //PRJ-1711.RM.1.0 24Nov2022 commented
                    ApplicationArea = All;
                }
                //PRJ-1079.GK.1.0 14Dec2021 end

                //PRJ-1087.JS.1.0 18Dec2021
                field("NS_Flow Job Card Dimension"; Rec."NS_Flow Job Card Dimension")
                {
                    // ToolTip = 'Specifies the value of the Enable to flow dimension from Job Card field.';//PRJ-1711.RM.1.0 24Nov2022 commented
                    // ToolTip = 'Toggle it �On� or �Off� based on whether you want to update the Dimensions from Job Card or from default General Ledger Setup. '; //PRJ-1711.RM.1.0 24Nov2022 //PE-45.RM.1.0 13Feb2023 commented
                    // ToolTip = 'Toggle it "On" or "Off" based on whether you want to update the Dimensions from Job Card or from default General Ledger Setup.'; //PE-45.RM.1.0 13Feb2023  //PRJCTPR-384.DK.1.0 8July2024
                    ToolTip = 'If enabled, the priority for dimensions on purchase documents (created via JMP, Subcontract, T&M) and sale documents (created via Progress Billing, Project card, Project Planning Lines, and T&M) will be given to the Project Tasks/Card if dimensions exist on both the project and the master card. Additionally, usage posts via the Project Journal or any sales/purchase document directly created for a project will follow the same priority.'; //PRJCTPR-384.DK.1.0 8July2024 //PE-342.DK.1.0 25July2024 change in Word Job to Project
                    ApplicationArea = All;
                }
                //PRJ-1405.AS.1.0 02MAY2022 START
                //PE-273.JS.1.0 15MAR2024 Start
                field("NS_Enable Change Dim. on JPL"; Rec."NS_Enable Change Dim. on JPL")
                {
                    ApplicationArea = All;
                    ToolTip = 'If enable, user allow to change dimension on "Job Planning Line", NOTE: In ProjectPro Dimensions on "Job Planning Line" are only for information purpose.';
                }
                //PE-273.JS.1.0 15MAR2024 end
                field("NS_Force change Work UOM"; Rec."NS_Force change Work UOM")
                {
                    // ToolTip = 'Specifies the Force change Work UOM'; //PRJ-1669.RM.1.0  commented
                    //PRJCTPR-209.HS.1.0 27Oct2023 Start
                    // ToolTip = 'Enable user to change the Work Unit of Measure on the Job Task Line'; //PRJ-1669.RM.1.0  // Commented
                    ToolTip = 'Specifies if user can change the Work UOM on Job Task Lines having Job Ledger Entries associated with it.';
                    Caption = 'Access to Change Work UOM';
                    //PRJCTPR-209.HS.1.0 27Oct2023 End
                    ApplicationArea = All;
                }
                //PRJ-1405.AS.1.0 02MAY2022 END
                //PRJ-1348.NK.1.0 21Jun2022 Start
                field("NS_Activate Task Pick List"; Rec."NS_Activate Task Pick List")
                {
                    ApplicationArea = all;
                    // Caption = 'Activate Task Pick List'; //PRJ-1617.RM.1.0 commented
                    // ToolTip = 'Specifies the Value of Activate Task Pick List'; //PRJ-1617.RM.1.0 commented
                    Caption = 'Enable User-Defined Task Type Caption'; //PRJ-1617.RM.1.0
                    // ToolTip = 'Specifies user to change Captions of Task Types, i.e. Activities, Process, Operation and Section.';//PRJ-1617.RM.1.0 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, user can change the captions of Task Types (ex: "Activities", "Process", "Operation", and "Section" wording).'; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1348.NK.1.0 21Jun2022 End
                //PRJ-1510.NK.1.0 21Jul2022 Start
                field("NS_Enable Job Address"; Rec."NS_Enable Job Address")
                {
                    ApplicationArea = all;
                    Caption = 'Enable Job Address';
                    // ToolTip = 'Specifies and enables the Add Job address default under Shipping and Payment fasttab in Purchase order if Job No. is available on Header'; //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If enabled in Job Setup , the address from the Job Card will be the Ship to Address in Purchase Order.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1510.NK.1.0 21Jul2022 End

                //PE-47.PS.1.0 06March2023 Start
                field("NS_Enable Job Backlog Feature."; Rec."NS_Enable Job Backlog Feature.")
                {
                    ApplicationArea = all;
                    Caption = 'Enable Job Backlog Feature.';
                    // ToolTip = 'This feature when enabled will cause the closing of jobs to verify that all sub-level jobs are closed prior to closing the �Parent� or �Master� job.  The user will be alerted to �Open� sub-level jobs preventing the closing until all sub-level jobs are set to �Completed'; //PE-47.PS.1.0 11April2023 Commented
                    //ToolTip = 'Specifies if you can run the Open Job Backlog batch to update the values on the Jobs list. It also causes the closing of Jobs to verify that all sub-level Jobs are closed prior to closing the �Parent� or �Master� Job. The user will be alerted to �Open� sub-level Jobs preventing the closing until all sub-level Jobs are set to �Completed.Note: The Manager Status of the job must be set to �Running�, to include the jobs for calculations.';  //PE-170.HS.1.0 27Sept2023 //PE-170.HS.1.0 28Sept2023 Commented
                    ToolTip = 'If enabled, the closing of �Parent� or �Master� Jobs will be dependent upon whether all its sub-level Jobs are closed prior. The user will be alerted if there exists �Open� sub-level Jobs, preventing the closing until all sub-level Jobs are set to �Completed�. Note: The �Manager Status� of the job must be set to �Running�, for it to be included in the open job backlog calculations.';//PE-170.HS.1.0 28Sept2023  
                }
                field("NS_Inclued Sub Job & Change Order"; Rec."NS_Inclued SubJob & Change Ord") //PRJCTPR-101.NC.1.0 25Apr2023
                {
                    ApplicationArea = all;
                    //Caption = 'Include Sub-levels in Job Backlog� Calcs'; //PE-170.HS.1.0 28Sept2023 Commented
                    Caption = 'Include Sub-levels in Job Backlog';//PE-170.HS.1.0 28Sept2023
                    // ToolTip = 'When turned on the combined value for Open Job Backlog value will be shown on the Master Job and it�s Sub-Levels and at the Sub-Levels it will show individual Backlog values for its sub-level.'; //PE-47.PS.2.0 20April2023 commented
                    // Tooltip = 'Specifies if the sub-level jobs will be included in the Open Job Backlog calculations as well. If enabled, the Open Job Backlog batch will show the combined (Master + Sub-Levels) Open Job Backlog value on the Master Job, while the sub-levels will be shown with their individual Backlog values as well.Note: The Manager Status of the job must be set to �Running�, to include the jobs for calculations.'; //PE-170.HS.1.0 27Sept2023 //PE-170.HS.1.0 28Sept2023 Commented
                    ToolTip = 'If enabled, the Master Job will show combined value (Master + Sub-Levels) under the �Open Job Backlog� column on the Jobs list, while the sub-levels will be shown with their individual Backlog values as well. Note: The �Manager Status� of the job must be set to �Running�, for it to be included in the open job backlog calculations.';//PE-170.HS.1.0 28Sept2023
                }
                //PE-47.PS.1.0 06March2023 End 
                //PE-85.Dk.1.0 4sep2023 Start
                field("NS_Advance Cust Lien Waiver"; Rec."NS_Advance Cust Lien Waiver")
                {
                    ApplicationArea = all;
                    ToolTip = 'Enable this feature to use advance level of Customer Lien Waivers. When set to True, it will disable the two fields on Customer Ledger Entries, "Lien Waiver Amount" and "Lien Waiver Payment".';
                }
                //PE-85.Dk.1.0 4sep2023 End

            }
            //PRJ-490.AM.1.0 End

        }
        addafter("Job WIP Nos.")
        {
            field("NS Subcontract Nos."; Rec."NS_Subcontract Nos.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Subcontract Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the code for the sub contract number series which will be used in Subcontracts.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS Draw Nos."; Rec."NS_Draw Nos.")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Draw Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the code for the Draw number series that will be used in Draw.';//PRJ-639.RS.1.0�19May2021
            }
            //PRJ-986.RM.1.0 14Oct2021  Start
            // field("NS Subcontract Draw Nos."; Rec."NS_Subcontract Draw Nos.")
            // {
            //     Visible = false; //PRJ-986.RM.1.0 14Oct2021 
            //     ApplicationArea = All;
            //     //ToolTip = 'Specifies the Subcontract Draw Nos.';//PRJ-639.RS.1.0�19May2021 Comment
            //     ToolTip = 'Specifies the code for the Sub contract Draw number series that will be used in Subcontract Draw.';//PRJ-639.RS.1.0�19May2021
            // }
            //PRJ-986.RM.1.0 14Oct2021  End
            field("NS Lien Release Document 01"; Rec."NS_Lien Release Document 01")
            {
                ApplicationArea = All;
                Caption = 'Lien Release Report ID';
                LookupPageID = Objects;
                //ToolTip = 'Specifies the Lien Release Report ID';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the report number for the Lien Release Report.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Enter the report number for the Lien Release Report.'; //PRJ-1711.RM.1.0 24Nov2022

                trigger OnValidate()
                begin
                    //ProjectPro - start
                    CALCFIELDS("NS_Lien Release Document01Name");
                    //ProjectPro - end
                end;
            }
            field("NS Lien Release Doc 01 Name"; Rec."NS_Lien Release Document01Name")
            {
                ApplicationArea = All;
                Editable = false;
                //ToolTip = 'Specifies the Lien Release Document 01 Name';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Spacifies the Lien Release Report name displays from the ID which you have entered in report ID.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS_Prepayment No. Series"; Rec."NS_Prepayment No. Series")
            {
                ApplicationArea = All;
                Caption = 'Prepayment Nos.';
                //ToolTip = 'Specifies the Prepayment Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the code for the number series that will be used assign numbers to PrePayment Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Enter the Prepayment No. series CODE. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS_Job Quote No. Series"; Rec."NS_Job Quote No. Series")
            {
                ApplicationArea = All;
                Caption = 'Quote Nos.';
                //ToolTip = 'Specifies the Quote Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Quote Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Enter the Quote No. series CODE. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            field("NS_Change Order No. Separator"; Rec."NS_Change Order No. Separator")
            {
                ApplicationArea = All;
                Caption = 'Change Order Nos.';
                //ToolTip = 'Specifies the Change Order Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the code for the number series that will be used assign numbers to Change Orders created from Master Job. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS_Work Order No. Series"; Rec."NS_Work Order No. Series")
            {
                ApplicationArea = All;
                Caption = 'Work Order Nos.';
                //ToolTip = 'Specifies the Work Order Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Work Order Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                ToolTip = 'Enter the Work Order No. series CODE. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
            }
            //PRJCTPR-147.NK.1.0 start 17Aug2023
            field("NS_Change Req No. Series"; Rec."NS_Change Req No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Enter the Change Request No. series CODE. See "No. Series" Table.';
            }

            //PRJCTPR-147.NK.1.0 end 17Aug2023
            //PE-177.DK.1.0 10Nov2023 Start
            field("NS_SubConChange Req No. Series"; Rec."NS_SubConChange Req No. Series")
            {
                ApplicationArea = all;
            }
            //PE-177.DK.1.0 10Nov2023 End
            group("NS_Progress Billing Numbers")
            {
                Caption = 'Progress Billing Numbers';
                field("NS_Progress Billing Nos."; Rec."NS_Progress Billing Nos.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Progress Billing Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Progress Billing. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Progress Billing No. series CODE. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_PB Sales Invoice Nos."; Rec."NS_PB Sales Invoice Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice Nos.';
                    //ToolTip = 'Specifies the Sales Invoice Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Sales Invoice Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Sales Invoice No. series CODE for Progress Billing. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_PB Posted Invoice Nos."; Rec."NS_PB Posted Invoice Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoice Nos.';
                    //ToolTip = 'Specifies the Posted Sales Invoice Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Posted Sales Invoice Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Posted Sales Invoice No. series CODE for Progress Billing. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_PB Sales Credit Memo Nos."; Rec."NS_PB Sales Credit Memo Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Memo Nos.';
                    //ToolTip = 'Specifies the Credit Memo Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Credit Memo Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Credit Memo No. series CODE for Progress Billing. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_PB Posted Credit Memo Nos."; Rec."NS_PB Posted Cr. Memo Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Credit Memo Nos.';
                    //ToolTip = 'Specifies the Posted Credit Memo Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to Posted Credit Memo Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Posted Credit Memo No. series CODE for Progress Billing. See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1098.NK.1.0 15Feb2022 Start
                field("NS_JFW Batch Document No."; Rec."NS_JFW Batch Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'JFW Batch Document Nos.';
                    // ToolTip = 'Specifies the code for the number series that will be used assign numbers to JFW Batch Document Nos. To see the number series that have been setup in the No. Series table.'; //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the CODE for the number series that will be used assign numbers to Job Forecast Worksheet Batch Document Nos.  See "No. Series" Table.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1098.NK.1.0 15Feb2022 End
                //PE-168.PS.1.0 06Oct2023 Start
                field("NS_Daliy Job Doc No."; Rec."NS_Daliy Job Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Daliy Job Doc No.';
                    Visible = false;//PRJCTPR-275.PS.1.0 22Dec2023
                }
                //PE-168.PS.1.0 06Oct2023 End 

            }
        }
        addafter(Numbering)
        {
            group(NS_Retention)
            {
                Caption = 'Retention';
                field("NS Sales Retention Period"; Rec."NS_Sales Retention Period")
                {
                    ApplicationArea = All;
                    //CharAllowed = '09YYMMDDQQ';//PRJ-530.AS.1.0 8FEB2021 Comment
                    //ToolTip = 'Specifies the Sales Retention Period';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the aging of the retention portion of the receivable. The �1Y� means one year from the document date for establishing retention receivable due dates.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Represents the Aging of the Retention portion of the Receivable. The ''1Y'' means one year from the document date for establishing Retention Receivable Due Dates. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Purchase Retention Period"; Rec."NS_Purchase Retention Period")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Purchase Retention Period';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the aging of the retention portion of the receivable.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = '1Y represents the Due Date for the Retainage portion of the billing to be one year from the billing date of the Contract Billing. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Retention Receivable Ledger"; Rec."NS_Retention Receivable Ledger")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Retention Receivable Ledger';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the default value when system post the retention in to customer ledger entry to identify the retention entry.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Select the Retention Ledger for Retention Receivables. This is the standard selection for Retention Receivable tracking. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Retention Payable Ledger"; Rec."NS_Retention Payable Ledger")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Retention Payable Ledger';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the default value when system post the retention in to vendor ledger entry to identify the retention entry.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Select the Retention Ledger for Retention Payables. This is the standard selection for Retention Payable tracking. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Calc Receiv Ret Before Tax"; Rec."NS_Calc ReceivableRetBeforeTax")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Calc Receivable Ret Before Tax';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;
                    // ToolTip = 'Specifies that your preference is to have the retention receivables calculated before tax is assessed.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Check this box if you prefer to have Retention Receivables calculated before Tax is assessed. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Calc Payable Ret Before Tax"; Rec."NS_Calc Payable Ret Before Tax")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Calc Payable Ret Before Tax';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that your preference is to have the retention receivables calculated before tax is assessed.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS A/R Retention Calc Method"; Rec."NS_A/R RetentionTaxCalcMethod")
                {
                    ApplicationArea = All;
                    Caption = 'A/R Retention Calc Method';
                    // ToolTip = 'Specifies the A/R Retention Calc Method';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies that the retention calculation method for sales whether its beofre the tax or after the tax.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Specifies that the Retention calculation method for Sales whether its before the Tax or after the Tax.  1. Calc. Tax on Sale then apply a Retention value based on Taxed Sale Amount. In this option Retention is calculated on the Amount Including Tax and then Retention is calculated.  2. Calc. Tax on Sale then apply Retention determined by Orogress Billing. In this option Retention is calculated on the Line Amount (Without Tax) then Retention is calculated.   3. Calc. Tax on Sale less the Retention determined by Progress Billing. In this option Retention is calculated on the Line Amount (Without Tax) and then Tax Calculated on Line Amount-Retention Amount'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS A/P Retention Calc Method"; Rec."NS_A/P RetentionTaxCalcMethod")
                {
                    ApplicationArea = All;
                    Caption = 'A/P Retention Calc Method';
                    //ToolTip = 'Specifies the A/P Retention Calc Method';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies that the retention calculation method for purchase whether its beofre the tax or after the tax.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Specifies that the Retention calculation method for Purchase whether its beofre the Tax or after the Tax.  1. Calc. Tax on Purchase then apply a Retention value based on Taxed Purchase Amount. In this option Retention is calculated on the Amount Including Tax.  2. Calc. Tax on Purchase then apply Retention Amount. In this option Retention is calculated on the Line Amount (Without Tax).  3. Calc. Tax on Purchase less the Retention Amount. In this option Retention is calculated on the Line Amount (Without Tax) and the Tax is calculated on Line Amout - Retetion Amount'; //PRJ-1711.RM.1.0 24Nov2022
                }
            }
            group("NS_Progress Billiing")
            {
                Caption = 'Progress Billing';//PRJ-191.AS.1.0 - 2APRIL2020
                field("NS AIA Form Code"; Rec."NS_AIA Form Code")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA Form Code';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the AIA From Code.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter your AIA license (Subscription No.) to print G702 and G703 pages '; //PRJ-1711.RM.1.0 24Nov2022 
                }
                field("NS AIA Form Expiration Date"; Rec."NS_AIA Form Expiration Date")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA Form Expiration Date';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the AIA Form expiry date.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter your AIA license (subscription no.) Expiration Date.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_AIA G702 Show With Page No."; Rec."NS_AIA G702 Show With Page No.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA G702 Show With Page No.';//PRJ-639.RS.1.0�19May2021 Comment
                    LookupPageID = Objects; //PRJ-39.SK.1.0
                    // ToolTip = 'Specifies the report with page number.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the page number if desired on the AIA G702 report.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS_AIA G703 Start As Page No."; Rec."NS_AIA G703 Start As Page No.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA G703 Start As Page No.';//PRJ-639.RS.1.0�19May2021 Comment
                    LookupPageID = Objects; //PRJ-39.SK.1.0
                    // ToolTip = 'Specifies the page number from where report should be started.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the start page number if desired on the AIA G703 report.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Sales Document Type"; Rec."NS_Sales Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Document Type to Create';
                    //ToolTip = 'Specifies the Sales Document Type to Create';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the setting for whether you want the progress billing to create either a Customer Sales Order or a Customer Sales Invoice.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'This is the setting for whether you want the Progress Billing to create either a Customer Sales Order or a Customer Sales Invoice. '; //PRJ-1711.RM.1.0 24Nov2022 
                }
                field("NS_Prog Bill Salesperson Dim"; Rec."NS_Prog BillSalespersonDimCode")
                {
                    ApplicationArea = All;
                    Caption = 'Prog Bill Salesperson Dimension';
                    //ToolTip = 'Specifies the Prog Bill Salesperson Dimension';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the dimension code for the Salesperson in case of Progressive billing.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog. Bill Gen Prod Pst Grp"; Rec."NS_Prog. Bill Gen. ProdPostGr.")
                {
                    ApplicationArea = All;
                    Caption = 'General Product Posting Group';
                    //ToolTip = 'Specifies the General Product Posting Group';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifes default Gen. Prod. Posting group to be defined while creating the Progress Bill on line items.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If the Prod. Posting Group is specified at the Job Setup, It will carry to the Job Card Level.'; //PRJ-1711.RM.1.0 24Nov2022
                    Visible = false;//PRJ-1684.AS.1.0
                    ObsoleteState = Pending;
                    ObsoleteReason = 'This field is marked for removal & replace from another field because this field make descreprency in code due to name';
                }
                //PRJ-1684.AS.1.0 start
                field("NS_ProgBillGenProdPostGr New"; Rec."NS_ProgBillGenProdPostGr New")
                {
                    ApplicationArea = All;
                    Caption = 'General Product Posting Group';
                    // ToolTip = 'Specifes default Gen. Prod. Posting group to be defined while creating the Progress Bill on line items.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Sets a default General Product Posting Group that is used during the Customer Invoice process in Progress Billing on Line Items '; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1684.AS.1.0 add
                field("NS Progress Billing Rounding"; Rec."NS_Progress Billing Rounding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Progress Billing Rounding';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the Option for rounding the progress billing sales amounts to nearest currency.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, Progress Billing Sales Amounts will be rounded to nearest whole Dollar. This can also be selected on Progress Billings for individual billings.'; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Progress Bill Std Invoice"; NS_ProgressBillStandardInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Billing Std Inv Report ID';
                    LookupPageID = Objects;
                    //ToolTip = 'Specifies the Progress Billing Std Inv Report ID';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the report number for a standard Invoice.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'Enter the report number for a Standard Invoice. The ProjectPro default report number is 14021327 '; //PRJ-1711.RM.1.0 24Nov2022

                    trigger OnValidate()
                    begin
                        //ProjectPro - start
                        CALCFIELDS("NS_Progress Bill Std Inv Name");
                        //ProjectPro - end
                    end;
                }
                field("NS Progress Bill Std Inv Name"; Rec."NS_Progress Bill Std Inv Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //ToolTip = 'Specifies the Progress Bill Std Inv Name';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the automatically updates the Name of the report.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Progr Bill First No. Def"; Rec."NS_ProgressBillingFirstNo. Def")
                {
                    ApplicationArea = All;
                    Caption = 'First No. for job to default as Job No.';
                    //ToolTip = 'Specifies the First No. for job to default as Job No.';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the field to make Job No. as the first Progress Billing No.';//PRJ-639.RS.1.0�19May2021  //PRJ-985.RM.1.0 14Oct2021|Comment
                    // ToolTip = 'Specifies that the Job No. is used as Prefix to the Progress Billing No.'; //PRJ-985.RM.1.0 14Oct2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the Job No. is used as prefix to the Progress Billings No. '; //PRJ-1711.RM.1.0 24Nov2022
                }
                //PRJ-1332.GK.1.0 25Apr2022 start
                field("NS_Res Amt in Progbill Inv"; Rec."NS_Res Amt in Progbill Inv")
                {
                    ToolTip = 'Specifies the value of the Restrict Amount Changes in Progress Billing Invoice field.';
                    ApplicationArea = All;
                }
                //PRJ-1332.GK.1.0 25Apr2022 end
                //PRJCTPR-136.NC.1.0 28June2023 Start
                field("NS_Transfer Qty of Units to SI"; Rec."NS_Transfer Qty of Units to SI")
                {
                    ApplicationArea = All;
                    ToolTip = 'If enabled and the Billable Planning line is set to Billing Method of "Units",  then Quantity being billed is transferred to the Sales Document. If disabled then only the Quantity of 1 is transferred.';
                }
                //PRJCTPR-136.NC.1.0 28June2023 End
                //PE-118.NC.1.0 03Aug2023 Start
                field("NS_Enable Get Job Planning Lin"; Rec."NS_Enable Get Job Planning Lin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enable this option to use "Get Job Planning Lines" function on the progress billing form. enabling this will disable the standard "Get Billings" function on the progress billing form.';
                }
                //PE-118.NC.1.0 03Aug2023 End

                // PE-229.HS.1.0 14Dec2023 Start
                field("NS_Disable Qty for % Method"; Rec."NS_Disable Qty for % Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the user can put Quantity more than 1 on billable job planning lines when �Progress Billing Method = %�.';
                }

                // PE-229.HS.1.0 14Dec2023 End
                //PE-225.PS.1.0 05June2024 Start
                field("NS_Auto Apply Retetion Billing"; Rec."NSAuto Apply Retetion Billing")
                {
                    ApplicationArea = All;
                    Caption = 'Auto Apply Retention Billing';
                    ToolTip = 'Enable this to auto apply the final retention billing document to the related progress billing’s open invoices to close the remaining amount per retention billing';
                }
                //PE-225.PS.1.0 05June2024 End
            }
            group("NS_Progress Payment")
            {
                Caption = 'Progress Payment';
                field("NS Prog Pay AIA Form Code"; rec."NS_Prog Pay AIA Form Code")
                {
                    ApplicationArea = All;
                    Caption = 'AIA Form Code';
                    //ToolTip = 'Specifies the AIA Form Code';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;//PRJ-562/MGLBC-4.N.S.1.0
                    ToolTip = 'Specifies the Vendor AIA license (subscription no.) to print the Form along with billing data.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay AIA Form Exp Date"; Rec."NS_Prog Pay AIA Form Exp Date")
                {
                    ApplicationArea = All;
                    Caption = 'AIA Form Expxpiration Date';
                    //ToolTip = 'Specifies the AIA Form Expxpiration Date';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;//PRJ-562/MGLBC-4.N.S.1.0
                    ToolTip = 'Specifies the Vendor AIA expiration date to print the Form along with billing data.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay G702 Show Page No"; Rec."NS_Prog Pay AIA G702ShowPageNo")
                {
                    ApplicationArea = All;
                    Caption = 'AIA G702 Show With Page No';
                    //ToolTip = 'Specifies the AIA G702 Show With Page No';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;//PRJ-562/MGLBC-4.N.S.1.0
                    ToolTip = 'Specifies to show the report with page number.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay G703 Start Page"; Rec."NS_Prog Pay AIA G703StartPage")
                {
                    ApplicationArea = All;
                    Caption = 'AIA G703 Start As Page No.';
                    //ToolTip = 'Specifies the AIA G703 Start As Page No.';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;//PRJ-562/MGLBC-4.N.S.1.0
                    ToolTip = 'Specifies default page number  from where report should start.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay Payment Doc Type"; Rec."NS_Prog Pay Payment Doc Type")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Document Type to Create';
                    //ToolTip = 'Specifies the Purchase Document Type to Create';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the setting for which you want  the progress billing to create either  a Vendor Purchase Order or a Vendor Purchase Invoice.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'This is the setting for whether you want the Progress Payment to create either a "Vendor Purchase Order" or a Vendor Purchase Invoice". '; //PRJ-1711.RM.1.0 24Nov2022
                }
                field("NS Prog Pay Salesperson Dim Code"; Rec."NS_Prog Pay Purchaser Dim Code")
                {
                    ApplicationArea = All;
                    Caption = 'Prog Payment Purchaser Dimension';
                    //ToolTip = 'Specifies the Prog Payment Purchaser Dimension';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the default dimension value that will belong to purchaser in case of  Progress Payment.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Selection will define the Default Dimension for Purchaser for Progress Payment.';//PRJ-1711.RP.1.0 24Nov2022

                }
                field("NS Prog Pay Gen. Prod. Post Gr."; Rec."NS_Prog Pay Gen. Prod. PostGr.")
                {
                    ApplicationArea = All;
                    Caption = 'General Product Posting Group';
                    //ToolTip = 'Specifies the General Product Posting Group';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the Sets of default General  Product Posting Group that is used during the Vendor Invoice process.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Selection will define the default General Product Posting Group that is used during the Vendor Invoice process.';//PRJ-1711.RP.1.0 24Nov2022  
                    Visible = false; //PE-233.AS.1.0
                    ObsoleteState = Pending;//PE-233.AS.1.0 ADD
                    ObsoleteReason = 'Will be removed in next build';//PE-233.AS.1.0 ADD
                }
                //PE-233.AS.1.0 ADD START
                field("NS_Prog Pay Gen.ProdPostGr.New"; Rec."NS_Prog Pay Gen.ProdPostGr.New")
                {
                    ApplicationArea = All;
                    Caption = 'General Product Posting Group';
                    ToolTip = 'Selection will define the default General Product Posting Group that is used during the Vendor Invoice process.';//PRJ-1711.RP.1.0 24Nov2022  
                    //PRJCTPR-279.HS.1.0 17Jan2024 Start
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    //PRJCTPR-279.HS.1.0 17Jan2024 End
                }
                //PE-233.AS.1.0 ADD END
                field("NS Prog Pay Rounding"; Rec."NS_Prog Pay Rounding")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment Rounding';//PRJ-400.AS.1.0 12APRIL2021
                    //ToolTip = 'Specifies the Progress Billing Rounding';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies and enable the option for rounding the progress payment vendor amounts to nearest to currency.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, Progress Payment amounts will be rounded to the nearest whole Dollar.';//PRJ-1711.RP.1.0 24Nov2022

                }
                field("NS Prog Pay Standard Invoice"; Rec."NS_Prog Pay Standard Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment Std Inv Report ID';//PRJ-400.AS.1.0 12APRIL2021
                    LookupPageID = Objects;
                    //ToolTip = 'Specifies the Progress Billing Std Inv Report ID';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the report number for a standard Invoice.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Enter the report number for a Standard Payment. The ProjectPro Standard Report is 14021342';//PRJ-1711.RP.1.0 24Nov2022

                    trigger OnValidate()
                    begin
                        //ProjectPro - start
                        CALCFIELDS("NS_Progress Bill Std Inv Name");
                        //ProjectPro - end
                    end;
                }
                field("NS Prog Pay Std Inv Name"; Rec."NS_Prog Pay Std Inv Name")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment Std Invoice Name';//PRJ-400.AS.1.0 12APRIL2021
                    Editable = false;
                    //ToolTip = 'Specifies the Progress Billing Std Invoice Name';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the automatically updates the name of the Report.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'The name of the report will be automatically update when the Progress Payment Std. Inv Report ID is selected (above).';//PRJ-1711.RP.1.0 24Nov2022
                }
                //PRJ-889.GK.1.0 13Sep2021 start
                field("NS_Progress Payment Enable"; Rec."NS_Progress Payment Enable")
                {
                    //ToolTip = 'Specifies the value of the Progress Payment Enable field';//PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Set to "Yes" if you would like to enable Progress Payment.';//PRJ-1711.RP.1.0 24Nov2022
                    ApplicationArea = All;
                }

                //PRJ-889.GK.1.0 13Sep2021 end

            }
            group(NS_Subcontract)
            {
                Caption = 'Subcontract';
                field("NS_Subcontract Default UOM"; Rec."NS_Subcontract Default UOM")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Default UOM';
                    //ToolTip = 'Specifies the Subcontract Default UOM';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the default unit of measure while creating the subcontract card from job.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select the default Unit of Measure for all Subcontracts.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS_Subcontract Use of UOM"; Rec."NS_Subcontract Use of UOM")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Use of UOM';
                    //ToolTip = 'Specifies the Subcontract Use of UOM';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the flexbility to pick the Subcontract Deafult UOM if there is no unit of measure has been provided in planning lines.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select the best suitable option for Subcontract use of Unit of Measure.';//PRJ-1711.RP.1.0 24Nov2022
                }

                field("NS_Unapply UsageLink on Subcon"; Rec."NS_Unapply UsageLink on Subcon")    //PRJ-866.JS.1.0 19Aug2021
                {
                    Caption = 'Unapply Usage Link on Subcontract';
                    //ToolTip = 'Specifies the value of the Unapply Usage Link on Subcontract';//PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'Toggle this �On� if you want to use Usage Links related to Subcontracts.';//PRJ-1711.RP.1.0 24Nov2022 //PRJCTPR-151.RM.1.0 10July2023 commented
                    ToolTip = 'Toggle this "On" if you don''t want to use Usage Links related to Subcontracts.'; //PRJCTPR-151.RM.1.0 10July2023
                    ApplicationArea = All;
                }
            }
            group(NS_Lists)
            {
                Caption = 'Lists';
                field("NS Job No. Separators"; Rec."NS_Job No. Separators")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job No. Separators';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the symbol used to differentiate Master Jobs from Sub-Level Jobs. Example: 9600,  9600.01,  9600.02,  etc.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Enter the symbol used to differentiate Master Jobs from Sub-Level Jobs. Example: if  "."  is used, then 9600 (Master Job) and  9600.01 (Sub Job)';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Job List Indent Increment"; Rec."NS_Job List Indent Increment")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Indent Increment';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies the view of indented sub-level Jobs under master Jobs.';//PRJ-639.RS.1.0�19May2021 //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'Specify the  Increment for indentation when viewing Sub-Level Jobs from Master Jobs on Job List View. '; //PE-45.RM.1.0 13Feb2023 
                }
                field("NS Job List Default Level"; Rec."NS_Job List Default Level")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Default Level';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies that how many levels of Job sub-levels you want the list too.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Enter the number of levels of Job Sub-Levels you want the list to default to.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Job List Bolding"; Rec."NS_Job List Bolding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Bolding';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies what level will be bold during list display.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select what level will be displayed in bold when Job List is displayed.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Job List Auto Link Create"; Rec."NS_Job List Auto Link Create")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Auto Link Create';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies and enables a job list table to be populated with the links between the various job classes.This function should always be on.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'This should always be "On". This enables a Job List Table to be populated with the links between the various Job Classes.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Subcontract No. Separators"; Rec."NS_Subcontract No. Separators")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract No. Separators';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the symbol that will be used to differentiate Master Subcontractor from Sub-Level.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'The symbol used to differentiate Master Subcontractor from Sub-Level.  Example: SUB101, SUB101.01, SUB101.02, etc.  Would use the "." symbol.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Subcont List Indent Incr"; Rec."NS_Subcont ListIndentIncrement")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcont List Indent Increment';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the sub-level Jobs under master Jobs.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies indentation increment for the sub-level Jobs under Master Jobs.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Subcont List Default Lvl"; Rec.NS_SubcontractListDefaultLevel)
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract List Default Level';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies how many levels of subcontract sub-levels you want  the list to default too. See sample list below.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Enter a number for how many levels of Subcontract Sub-Levels you want the list to default too.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Subcontract List Bolding"; Rec."NS_Subcontract List Bolding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract List Bolding';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies Indicates what  level is bold during list display.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select at what level is displayed as bold in list display, if any.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Subc List Auto Link Create"; Rec."NS_Subcont ListAutoLinkCreate")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcont List Auto Link Create';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies and enables a subcontract list table to be populated with the links between the various job classes.This should always be on.C75';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'This should always be "On". This enables a Subcontract List Table to be populated with the links between the various Job Classes.';//PRJ-1711.RP.1.0 24Nov2022
                }
            }
            group("NS_Indirect Burden Allocation")
            {
                Caption = 'Indirect Burden Allocation';
                field("NS_Calculate Indirect Burden"; Rec."NS_Calculate Indirect Burden")
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Indirect Burden';
                    //ToolTip = 'Specifies the Calculate Indirect Burden';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies that if indirect burden is to be required in your business process.';//PRJ-639.RS.1.0�19May2021 //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'If enabled, the Indirect Burden will be calculated on the Jobs, based on Burden % defined on a specific Job Task Line. This will only update Job Ledger Entries.'; //PE-45.RM.1.0 13Feb2023
                }
                field("NS_Advanced Burden Allocation"; REC."NS_Advanced Burden Allocation")//CTSI-254.AS.1.0
                {
                    ApplicationArea = All;
                    Caption = 'Advanced Burden Allocation';
                    // ToolTip = 'Specifies the Advanced Burden Allocation'; //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'If enabled, in addition to Indirect Burden, the Calculated Burden amount will also be updated on the G/L account through a Batch Job. '; //PE-45.RM.1.0 13Feb2023
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("NS Burden Alloc From - Credit"; Rec."NS_Burden Alloc From - Credit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc From - Credit';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the credit G/L account for burden allocation.This G/L account is usually from the �Indirect Job Cost� section of your Chart of Accounts.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If a G/L account is defined, the additional burden entries calculated amount will update the G/L account defined in Job Setup.';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc To - Debit"; Rec."NS_Burden Alloc To - Debit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc To - Debit';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies Select the debit G/L account for burden allocation.This  G/L account is usually from the �Direct Job Cost� section of your Chart of Accounts.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If a G/L account is defined, the additional burden entries calculated amount will update the G/L account defined in Job Setup.';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Dimension"; Rec."NS_Burden Alloc Dimension")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Dimension';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies and indicates which dimension will be used for burden and that will be linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If the Indirect Burden Dimension is defined at Job Setup,  it will flow to Posted G/L entries.';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Proj Dim Value"; Rec."NS_Burden AllocProjectDimValue")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Project Dim Value';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the code for a dimension that is linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Based on the Dimension above, set the Project Dimension value ';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Serv Dim Value"; Rec."NS_Burden AllocServiceDimValue")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Service Dim Value';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the code for a dimension that is linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Based on the Dimension above, set the Service Dimension value ';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Auto Post Burden to G/L"; REC."NS_Auto Post Burden to G/L")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    Caption = 'Auto Post Burden to G/L';
                    // ToolTip = 'Specifies the Auto Post Burden to G/L'; //PE-45.RM.1.0 13Feb2023  commented
                    ToolTip = 'If enabled, the Indirect Burden and the Calculated Burden amount will be updated automatically on the G/L account through a batch Job.'; //PE-45.RM.1.0 13Feb2023 
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0

                }
                field("NS_Burden G/L Journal Template"; REC."NS_Burden G/L Journal Template")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden G/L Journal Template';//PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Burden G/L Journal Template to be used. This is only available if you are using "Advanced Burden Allocations".';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Burden G/L Journal Batch"; rec."NS_Burden G/L Journal Batch")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden G/L Journal Batch';//PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If the Burden G/L Batch is defined , Posting routine will be updated using this batch.';//PRJ-1711.RP.1.0 24Nov2022
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Mandatory Dimension"; rec."NS_Mandatory Dimension")
                {
                    ApplicationArea = all;
                    Caption = 'Mandatory Dimension';
                    //ToolTip = 'Specifies the Dimension for Indirect Burden Allocation'; //PRJ-1579.RM.1.0 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Dimension to be mandatory while processing the Subcontracts. This is only available if You are using Advanced Burder Allocation';//PRJ-1711.RP.1.0 24Nov2022
                    Description = 'CTSI-254';
                    Editable = NewAdvanceBoolEditable;
                }
                field("NS_Mandatory Dimension Value"; rec."NS_Mandatory Dimension Value")
                {
                    ApplicationArea = all;
                    Caption = 'Mandatory Dimension Value';
                    //ToolTip = 'Specifies the Dimension value'; //PRJ-1579.RM.1.0 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Dimension Value to be mandatory while processing the Subcontracts. This is only available if you are using Advanced Burden Allocations.';//PRJ-1711.RP.1.0 24Nov2022 
                    Description = 'CTSI-254';
                    Editable = NewAdvanceBoolEditable;
                }
                field("NS_Default Job Task No."; rec."NS_Default Job Task No.")
                {
                    Description = 'CTSI-254';
                    // ToolTip = 'Specifies the default Job task no.'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    // ToolTip = 'Specifies the Default Job Task No.'; //PRJ-1579.RM.2.0 //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'If using Advanced Burden Allocation, the system will default to the Job Task No. referenced when processing the Subcontract. '; //PE-45.RM.1.0 13Feb2023 
                    Editable = NewAdvanceBoolEditable;
                    ApplicationArea = all;
                }
                field("NS Burden Required"; Rec."NS_Burden Required")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Required';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the burden if required for all jobs please trun ON.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Turn "On" if Burden is required for all Jobs.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS Burden Job Cost Category"; Rec."NS_Burden Job Cost Category")
                {
                    ApplicationArea = All;
                    Caption = 'Burden Job Cost Category';
                    //ToolTip = 'Specifies the Burden Job Cost Category';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the job cost category for Burden calculations.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select the Job Cost Category for Burden calculations.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS_Dimension for Labor Rates"; Rec."NS_Dimension for Labor Rates")
                {
                    ApplicationArea = all;
                    // ToolTip = 'Specifies the Dimesnsion for labor rate'; //PRJ-1579.RM.1. //PRJ-1579.RM.2.0 commented
                    //ToolTip = 'Specifies the Dimesnsion for Labor Rate'; //PRJ-1579.RM.2.0 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If you are requiring a Dimension for Labor Rates, please specify here.';//PRJ-1711.RP.1.0 24Nov2022 
                    Description = 'CTSI-95.MS.1.0';
                    Caption = 'Dimension for Labor Rates';
                }
            }
            group("NS_Labor to G/L")
            {
                Caption = 'Labor to G/L';

                //PE-247.HS.1.0 6Feb2024 Start
                field("NS_Enable Job Labor to G/L"; Rec."NS_Enable Job Labor to G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'If enabled, the Labor entries posted from the Job Journal Batch (defined in the below setups) will flow to the defined General Journal Batch, where you can review the entries before posting them to G/L entries.';
                    trigger OnValidate()
                    begin
                        // PE-247.AT.1.0 06July2024 Start
                        if Rec."NS_Enable Job Labor to G/L" then begin
                            NS_EditAutoPost := Rec."NS_Enable Job Labor to G/L";
                            rec."NS_Post Job Labor to G/L" := Rec."NS_Enable Job Labor to G/L";
                        end else
                            NS_EditAutoPost := Rec."NS_Enable Job Labor to G/L";
                        rec."NS_Post Job Labor to G/L" := Rec."NS_Enable Job Labor to G/L";

                        // PE-247.AT.1.0 06July2024 End 
                        // if not Rec."NS_Enable Job Labor to G/L" then // PE-247.AT.1.0 06July2024 Comment
                        //  NS_EnableAutoPost := Rec."NS_Enable Job Labor to G/L"; // PE-247.AT.1.0 06July2024 Comment
                    end;
                }
                //PE-247.HS.1.0 6Feb2024 End
                // field("NS_Post Job Labor to G/L"; Rec."NS_Post Job Labor to G/L")  //PE-247.HS.1.0 6Feb2024 Commented
                field("NS_Post Job Labor to G/L"; Rec."NS_Post Job Labor to G/L") //PE-247.HS.1.0 6Feb2024 // PE-247.AT.1.0 06July2024
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Post Job Labor to G/L';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the senario when labor is posted through the Job Journal, you can turn ON to create a General Ledger entry.';//PRJ-639.RS.1.0�19May2021  //PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'When Labor is posted through the Job Journal, you can create a General Ledger Journal Entry by toggling this "On".';//PRJ-1711.RP.1.0 24Nov2022 // //PE-247.HS.1.0 5Feb2024 Commented
                    //PE-247.HS.1.0 5Feb2024 Start
                    ToolTip = 'Enable this to automatically post the Labor entries created on the Job Journal to G/L entries.';
                    Caption = 'Auto Post Job Labor to G/L';
                    Editable = NS_EditAutoPost;
                    //PE-247.HS.1.0 6Feb2024 End
                }
                //PE-247.HS.1.0 6Feb2024 Start
                field("NS_Labor Job Journal Template"; Rec."NS_Labor Job Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job journal template name for creating the Job Labor entries that should be posted to G/L.';
                }
                field("NS_Labor Job Journal Batch"; Rec."NS_Labor Job Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job journal batch name based on the Job Journal Template selected above for creating the Job Labor entries.';
                }
                field("NS_Labor G/L Journal Template"; Rec."NS_Labor G/L Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the general journal template name to which the Job Labor entries will get populated from the Job Journal when posted.';
                }
                //PE-247.HS.1.0 6Feb2024 End
                field("NS_Labor to Job Batch Name"; Rec."NS_Labor to Job Batch Name")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor to Job Batch Name';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies either set to �Default� or �Labor�.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'Typically set to �Default� or �Labor� ';//PRJ-1711.RP.1.0 24Nov2022 //PE-247.HS.1.0 5Feb2024 Commented
                    ToolTip = 'Specifies the general journal batch name based on the G/L Journal template selected above to which the Job Labor entries will get populated from Job Journal when posted.'; //PE-247.HS.1.0 5Feb2024
                }
                field("NS_Labor Allocated to Job - Debit"; Rec."NS_LaborAllocated toJob -Debit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor Allocated to Job - Debit';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the General Ledger account to post job cost �labor value.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'This is the General Ledger Account to post Job Cost � Labor Value ';//PRJ-1711.RP.1.0 24Nov2022 //PE-247.HS.1.0 5Feb2024 commented
                    ToolTip = 'Specifies debit G/L account for job labor allocation to G/L entries.';  //PE-247.HS.1.0 5Feb2024
                }
                field("NS_Labor to Job Offset - Credit"; Rec."NS_Labor to JobOffset - Credit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor to Job Offset - Credit';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the General Ledger account that is the of f set to the labor posted to the G/L.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'This is the General Ledger Account that is the offset to the Labor posted to the G/L.';//PRJ-1711.RP.1.0 24Nov2022  // //PE-247.HS.1.0 5Feb2024  Commented
                    ToolTip = 'Specifies the credit G/L account for job labor allocation to G/L entries.';  //PE-247.HS.1.0 5Feb2024 
                }
                field("NS_Job Cost Cat.for Rev.LaborEnt."; Rec."NS_Job Cost Cat.for Rev.LaborEnt.")
                {
                    ApplicationArea = ALL;
                    Description = 'NSAL-64.MS.1.0';
                    //ToolTip = 'Specifies the Job cost Cat. for Reverse Labor Entries';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Select the job cost category to be used f or posting reversal of  labor entries.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    // ToolTip = 'Select the Job Cost Category to be used for posting reversals of Labor entries.';//PRJ-1711.RP.1.0 24Nov2022  //PE-247.HS.1.0 5Feb2024  Commented
                    ToolTip = 'Specifies the Job Cost Category to be used for posting reversals of job labor entries.'; //PE-247.HS.1.0 5Feb2024 
                }
            }
            group("NS_Job Quoting")
            {
                Caption = 'Job Quoting';
                field("NS_Use Default Tasks"; Rec."NS_Use Default Tasks")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Use Default Tasks';//PRJ-639.RS.1.0�19May2021 Comment
                    // ToolTip = 'Specifies that system will allow to copy the task template in job quote.';//PRJ-639.RS.1.0�19May2021 //PE-45.RM.1.0 13Feb2023  commented
                    ToolTip = 'When creating a new Quote, you can set the ''Use Default Tasks'' for  Default or Job Type. "Default" option - The system use the Default Task Lists for the Task Lines. "Job Type" - The system will carry over to the new Job Quote the selected Job Type Tasks Lines.'; //PE-45.RM.1.0 13Feb2023 
                }

                field("NS_Billing Job Task No."; Rec."NS_Billing Job Task No.")    //PRJ-881.JS.1.0 25Aug2021
                {
                    Caption = 'Billing Job Task No.';
                    // ToolTip = 'Specifies default heading while managing with job quoting in case of billing task number. Syste carry forwards this value to new job created from job quote.'; //PRJ-639.RS.1.0�19May2021 //PE-45.RM.1.0 13Feb2023 commented
                    ToolTip = 'If specified, the Billing Job Task No. will carry over from the Job Quote to a Job Card when it gets converted to a Job. '; //PE-45.RM.1.0 13Feb2023 
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Billing Job Task No.';//PRJ-639.RS.1.0�19May2021 Comment
                }
                field("NS_Total Task No."; Rec."NS_Total Task No.")    //PRJ-881.JS.1.0 25Aug2021
                {
                    Caption = 'Total Task No.';
                    //ToolTip = 'Specifies default heading while managing with job quoting in case of budget total task number. Syste carry forwards this value to new job created from job quote.';//PRJ-639.RS.1.0�19May2021 //PRJ-935.RM.1.0 04-Oct-2021-Comment
                    //ToolTip = 'Specifies the default APO code to be used in Job Quoting. The System carries this value forward when a new job is created'; //PRJ-935.RM.1.0 04-Oct-2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If specified, the Task No. assigned to the ''TOTAL'' line, it will carry over when a Quote is converted to a Job.';//PRJ-1711.RP.1.0 24Nov2022
                    ApplicationArea = All;
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
                field("NS_Item Quote Costs"; Rec."NS_Item Quote Costs")
                {
                    Caption = 'Item Quote Costs';
                    // ToolTip = 'If enabled, an items �Quote Cost� will be used as the default value instead of the items standard costs. If not enabled, then standard cost will be applied.';//PRJ-1579.RM.1.0  //PRJ-1579.RM.2.0 commented
                    //ToolTip = 'If enabled, an Item''s �Quote Cost� will be used as the default value instead of the Item''s Standard Cost. If not enabled, then Standard Cost will be applied.'; //PRJ-1579.RM.2.0  //PRJ-1711.RP.1.0 24Nov2022 commented 
                    ToolTip = 'If enabled, an Item''s ''Quote Cost'' will be used as the default value instead of the Item''s Standard Cost. If not enabled, then Standard Cost will be applied.';//PRJ-1711.RP.1.0 24Nov2022
                    ApplicationArea = All;
                }
                field("NS_Labour Rate"; Rec."NS_Labour Rate")
                {
                    //Caption='Labour Rate';//PRJ-1058.GK.1.0 01Dec2021 comment
                    Caption = 'Labor Rate';//PRJ-1058.GK.1.0 01Dec2021
                    // ToolTip = 'If it''s enabled then labor rates will default from the "Labor Rates by Task List" page.'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    // ToolTip = 'If it is enabled then Labor Rates will default from the "Labor Rates by Task List" page.'; //PRJ-1579.RM.2.0 //PE-45.RM.1.0 14Feb2023  commented
                    ToolTip = 'If enabled, the Labor Rates can be setup for a specified Task Code which will be pulled from the "Labor Rates by Task" List page (Dimension code, Task code and Job Type Code data is needed).'; //PE-45.RM.1.0 14Feb2023 
                    ApplicationArea = All;
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
                //PRJ-1262.RM.1.0 start
                field("NS_Project Pro KPI"; Rec."NS_Project Pro KPI")
                {
                    Caption = 'ProjectPro KPI';
                    Description = 'ProjectPro';
                    ApplicationArea = all;
                    Visible = false; //PRJ-1438.RM.1.0 

                }
                //PRJ-1262.RM.1.0 end
                //PRJ-1443.AS.1.0 START
                field("NS_EnblGLNResGMCalc"; Rec."NS_EnblGLNResGMCalc")
                {
                    Caption = 'Enable Resources in Gross Marg. Calc.';
                    Description = 'Enable Resources in Gross Marg. Calc.';
                    //ToolTip = 'Specifies Resources in Gross Marg. Calc.'; //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the system calculates the Markup% on Job Tasks for the Resource.'; //PRJ-1711.RP.1.0 24Nov2022 
                    ApplicationArea = all;
                    Editable = TRUE;
                }
                //PRJ-1443.AS.1.0 END

                //PRJ-1645.AS.1.0 START
                field(NS_EnblMrkupOnJPLCostCatg; Rec.NS_EnblMrkupOnJPLCostCatg)
                {
                    Caption = 'Enable Markup on JPL Cost Category';
                    Description = 'Enable Markup on JPL Cost Category';
                    //ToolTip = ' Enabling this field will Update MarKup on JobPlanning Lines CostCategory Wise'; //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the Markup will be updated on the Job Planning Line based on the value or % specified  on the Cost Category.';//PRJ-1711.RP.1.0 24Nov2022
                    ApplicationArea = All;

                }
                field(NS_LockMultiMrkpUpdateonJPL; Rec.NS_LockMultiMrkpUpdateonJPL)
                {
                    Caption = 'Lock Multi Markup Update on JPL';
                    Description = 'Lock Multi Markup Update on JPL';
                    //ToolTip = ' Making this field enable will lock the Job Planning Lines to update Markup calculation at multiple times means User can update Markup calculation on Job Planning Lines only once';//PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, user can only update the Markup calculation on the Job Planning Line only once.';//PRJ-1711.RP.1.0 24Nov2022
                    ApplicationArea = All;

                }
                //PRJ-1645.AS.1.0 END

            }
            group("NS_Job Material Planning")
            {
                Caption = 'Job Material Planning';
                field("NS_Use Job Mat'l Plan Active"; Rec."NS_Use Job Mat'l Plan Active")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies whether to activate Use Job Mat''l Plan Active';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies that job material planning functionality to be used against the job.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Turn "ON", to use the Job Material Planning feature to plan and track Materials/Items on ordered.';//PRJ-1711.RP.1.0 24Nov2022 
                }
                field("NS_Job Mat'l Planning Location"; Rec."NS_Job Mat'l Planning Location")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job Mat''l Planning Location';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the default location for Job Material Planning  module.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 01Dec2022 commented
                    ToolTip = 'If a Location needs to be specified for Job Material Planning, select the location for Jobs. ';//PRJ-1711.RP.1.0 01Dec2022
                }
                field("NS_Expanded Job Material Planning"; Rec.NS_ExpandedJobMaterialPlanning)
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Expanded Job Material Planning';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the use of G/L accounts on the JMP worksheet.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the G/L account must be specified on the Job Material Planning Worksheet.';//PRJ-1711.RP.1.0 24Nov2022
                }
                field("NS_Purchase Resources with Orders"; Rec.NS_PurchaseResourcesWithOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Use Purchase Orders for Resources';
                    //ToolTip = 'Specifies the Use Purchase Orders for Resources';//PRJ-639.RS.1.0�19May2021 Comment
                    //ToolTip = 'Specifies the purchase document type to be created from JMP as to Vendor Purchase Order or Vendor Purchase Invoice.';//PRJ-639.RS.1.0�19May2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Select "Order" or "Invoice" to specify option for  the Purchase Document type when creating from JMP (''Purchase Order'' or ''Purchase Invoice'').';//PRJ-1711.RP.1.0 24Nov2022
                }
                //PRJ-1361.AS.1.0 START
                field("NS_DelvArch Rev No."; Rec."NS_DelvArch Rev No.")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Delivery Ticket Archive Revision No.'; //PE-45.RM.1.0 14Feb2023 commented
                    ToolTip = 'Specify the No. Series for generating Archived Delivery Ticket.'; //PE-45.RM.1.0 14Feb2023 
                }
                //PRJ-1361.AS.1.0 END
            }

            group("NS_Job Forecast Worksheet")
            {
                Caption = 'Job Forecast Worksheet';   //PRJ-659.JS.1.0�27July2021
                field("NS_GBPG for Job Forecast"; Rec."NS_GBPG for Job Forecast")//CTSI-115.AS.1.0 Added field
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the GBPG for Job Forecast';//PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'This field is recommended to be left blank. Only enter a General Business Posting Group (GBPG) if you wish to require all Sub-Level Jobs to have this GBPG code to be included during Job Forecasting.  Example: If you enter "PROJECT" than only Sub-Level Jobs with "PROJECT"  GBPG will be included during Job Forecasting.';//PRJ-1711.RP.1.0 24Nov2022 
                    Caption = 'GBPG for Sub-Level Job Forecast';
                }
                field("NS Allow Posting Date on JFW As of Date Filter"; Rec."NS_Allow Posting Date on JFW As of Date Filter")
                {
                    Caption = 'Allow Posting Date on JFW As of Date Filter';
                    //ToolTip = 'If a date is entered, this date becomes the "As of Date" for the Job Forecast Worksheet '; //PRJ-1579.RM.1.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If a date is entered, this date becomes the only "As of Date" for the Job Forecast Worksheet. This will require the Construction Manager to change the date before the next Forecast period.  Typically this is a monthly process. If left blank, there''s no restriction for the PM Forecasting date.';//PRJ-1711.RP.1.0 24Nov2022 
                    Description = 'CTSI-268';
                    ApplicationArea = All;
                }
                //PRJ-543.AS.1.0 18FEB2021 - START
                field("NS_Forecast Amount Rounding"; Rec."NS_Forecast Amount Rounding")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Forecast Amount Rounding'; //PRJ-1579.RM.1.0 commented
                    // ToolTip = 'Enter the decimal value in which the forecast percentage will be rounded. For example: To calculate forecast value for 4 decimal places (Recommended) enter "0.0001"'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Enter the Decimal Value in which the Forecast Percentage will be rounded. For example: To calculate Forecast Value for 4 decimal places (Recommended) enter "0.0001"';//PRJ-1579.RM.2.0
                }
                //PRJ-543.AS.1.0 18FEB2021 - END
                field("NS_Required GM% Var for JFW Comments"; Rec."NS_Required GM% Var for JFW Comments")
                {
                    ApplicationArea = all;
                    Description = 'CTSI-268';
                    // ToolTip = 'Specifies the Gross margin% for Job Forecast Worksheet, If the GM Var% is more or less than the specified % the PM comments are required.'; //PRJ-1579.RM.1.0
                    //ToolTip = 'Specifies the Gross Margin% for Job Forecast Worksheet, If the GM Var % is more or less than the specified % the PM Comments are required.'; //PRJ-1579.RM.2.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Enter the Gross Margin % Net change that will trigger a comment must be entered to explain the Variance in month-to-month Gross Margin % change.';//PRJ-1711.RP.1.0 24Nov2022
                }
                //PRJ-1189.GK.1.0 06apr2022 start
                field("NS_Enab. Budg.on Contract Date"; Rec."NS_Enab. Budg.on Contract Date")
                {
                    //ToolTip = 'This date is to be used for the Job Forecasting. This date specifies the Contract Forecast Date to be used instead of the Planning date in the Job Forecasting.';//PRJ-1711.RP.1.0 24Nov2022 commented
                    //ToolTip = 'Recommend this be "ON" which will use Contract Date for forecasting each Planning Line.  If "OFF", Job Planning Line date applies.';//PRJ-1711.RP.1.0 24Nov2022 //PRJ-1454.NK.1.0 13Jan2023 Block
                    //ToolTip = 'Recommend this to be "ON" which will use the Contract Forecast Date for Job Forecasting each Planning Line.  If "OFF" the standard Job Planning Line date is applied.'; //PRJ-1454.NK.1.0 13Jan2023 //PE-170.HS.1.0 28Sept2023 Commented
                    // Caption = 'Enable Forecast Worksheet Budget Cost and Contract Billings to use the Contract Forecast Date.'; //PRJ-1454.NK.1.0 13Jan2023 //PE-170.HS.1.0 28Sept2023 Commented
                    ToolTip = 'Specify if you want to use the �Contract Forecast Date� available on the job planning lines, as a date filter for Job Forecasting. When disabled, the standard �Planning Date� from the job planning lines is applied.'; //PE-170.HS.1.0 28Sept2023 
                    Caption = 'Use Contract Forecast Date'; //PE-170.HS.1.0 28Sept2023
                    ApplicationArea = All;
                }
                //PRJ-1189.GK.1.0 06apr2022 end
                //PRJ-1299.JS.1.0 18APR2022 - start
                field("NS_Forecast By Task Total"; Rec."NS_Forecast By Task Total")
                {
                    //ToolTip = 'Specifies the value of the Forecast By Totals field.'; //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the user can prepare Job Forecast by using summarized Job Task Type ''End-Total'' instead of Forecasting by each individual Job Task lines that is ''Posting''.';//PRJ-1711.RP.1.0 24Nov2022 
                    ApplicationArea = All;
                    Caption = 'Forecast By Task Total';
                }
                //PRJ-1299.JS.1.0 18APR2022 - end
                //PRJ-1349.JS.1.0 15MAY2022 - Start
                //PE-191.NC.1.0 06Mar2024 Start Block
                // field("NS_Budgeted Cost on Projection"; Rec."NS_Budgeted Cost on Projection")
                // {
                //     // ToolTip = 'Enable to Specifies the value of the Budgeted Cost on Job Projection Tab'; //PRJCTPR-162.RM.1.0 21July2023 commented
                //     ToolTip = 'Enabling this Boolean will check the Job Planning Lines with Line Type not equal to Billable and picks the Total Cost LCY on Projections fast tab into the field Budget Total Cost under Actual column on Job Card.'; //PRJCTPR-162.RM.1.0 21July2023
                //     ApplicationArea = All;
                //     Caption = 'Budgeted Cost on Projection';
                // }
                //PE-191.NC.1.0 06Mar2024 End Block
                //PRJ-1349.JS.1.0 15MAY2022 - end

                //PRJCTPR-62.JS.1.0 16FEB2023 - start
                field("NS_Forecast Force Completed"; Rec."NS_Forecast Force Completed")
                {
                    ApplicationArea = All;
                    Caption = 'Force Forecast Lines to be Completed'; //PE-170.HS.1.0 27Sept2023
                    // ToolTip = 'Specifies the value of the Enable this field to force Completed the Job forecast field.'; //PE-170.HS.1.0 27Sept2023 Commented
                    ToolTip = 'Specifies if you want to force the forecast worksheet to be set as “Completed”. This feature is used only when an upgrade/implementation is performed along with the import of historical data and there is a case where the Percentage Complete exceeds 100%. If this Boolean is true during the import, the system will auto-set those forecast lines to “Completed”.';  //PE-170.HS.1.0 27Sept2023
                }
                //PRJCTPR-62.JS.1.0 16FEB2023 - end
                //PE-287.JS.1.0 29APR2023-Start
                field(NS_UpdJFWForecastCompCostOnJT; Rec.NS_UpdJFWForecastCompCostOnJT)
                {
                    Caption = 'Enable JFW Forecasted Completed Cost on JTL';
                    ApplicationArea = All;
                    ToolTip = 'Specifies if you want to carry over latest “Forecasted Completed Cost” value from JFW to job task line’s “JFW Forecasted Completed Cost” column if the POC method on the job card is either set to “Blank” or “Job Forecast”. This setup will be defaulted to the job card and modified as per requirement. This also ensures that the “Batch Posting of Job Forecast Worksheets” uses these values to calculate TCE on the rev rec summary details for the same POC methods.';
                }
                //PE-287.JS.1.0 29APR2023-end
                //PE-299.JS.1.0 17MAY024-Start
                field("NS_Push-OrV2JFWForecastedonJTL"; Rec."NS_Push-OrV2JFWForecastedonJTL")
                {
                    Caption = 'Push Override value to JFW Forecasted on JTL';
                    ApplicationArea = All;
                    ToolTip = 'Enable this to auto-update the values on job task lines from “Override Forecasted Completed Cost” to “JFW Forecasted Completed Cost”. Please note that this will work only if the “Enable JFW Forecasted Completed Cost on JTL” setup is ON';
                }
                //PE-299.JS.1.0 17MAY024-end

                //PE-312.JS.1.0 11JUN2024-Start
                field("NS_AllowNegEst. Cost2Complete"; Rec."NS_AllowNegEst. Cost2Complete")
                {
                    ApplicationArea = All;
                    ToolTip = 'If enabled, you can enter and calculate negative values in the “Estimated Cost to Complete” column on JFW.', Comment = '%';
                }
                //PE-312.JS.1.0 11JUN2024-end
            }
            group("NS_Revenue Recognition")
            {
                Caption = 'Revenue Recognition';   //PRJ-659.JS.1.0�27July2021
                //PRJ-1546.GK.2.0 24Aug2022 start-comment
                field("NS_Burden G/L Journal Template Rev."; '')
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Burden G/L Journal Template';  //PRJ-945.RM.1.0 04-Oct-2021- Comment
                    ToolTip = 'Specifies the Rev. Rec. G/L Journal Template';  //PRJ-945.RM.1.0 04-Oct-2021
                    Description = 'CTSI-274';
                    //PRJ-1546.GK.1.0 08Aug2022 start
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'This field is marked for removal & replace from another field because this field make descreprency in code due to name';
                    //PRJ-1546.GK.1.0 08Aug2022 end
                }
                //PRJ-1546.GK.1.0 08Aug2022 start
                //PRJ-1546.GK.2.0 24Aug2022 end
                field("NS_Burden G/L Journal Temp. Rev."; Rec."NS_Burden G/L Jour. Temp Rev.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Rev. Rec. G/L Journal Template'; //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Rev. Rec. G/L Journal Template to be used ';//PRJ-1711.RP.1.0 24Nov2022
                    Description = 'CTSI-274';
                }
                //PRJ-1546.GK.1.0 08Aug2022 end
                field("NS_Burden G/L Journal Batch Rev."; Rec."NS_Burden G/L Journal Batch Rev.")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Burden G/L Journal Batch';  //PRJ-945.RM.1.0 04-Oct-2021- Comment
                    //ToolTip = 'Specifies the Rev. Rec. G/L Journal Batch';  //PRJ-945.RM.1.0 04-Oct-2021 //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Rev. Rec. G/L Journal Batch to be used ';//PRJ-1711.RP.1.0 24Nov2022
                    Description = 'CTSI-274';
                }
                //PE-136.JS.1.0 03Aug2023 - Start
                field("NS_RevRec Batch No. Series"; Rec."NS_RevRec Batch No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'This Field is use to specifies the "Revenue Recognition" batch No. Series';
                    caption = 'Revenue Recognition Batch No. Series';
                }
                //PE-136.JS.1.0 03Aug2023 - End
                //PE-271.PS.2.0 05April2024  Start
                field("NS_Rev Rec Reference No."; Rec."NS_Rev Rec Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field is use to specifies the "Rev Rec Reference No." No. Series';
                }
                //PE-271.PS.2.0 05April2024 End
                field("NS_Mandatory Dimension Rev."; Rec."NS_Mandatory Dimension Rev.")
                {
                    ApplicationArea = all;
                    Caption = 'Additional Dimension';
                    // ToolTip = 'Select any additional defult dimension that needs to be added on Rev. Rec. G/L Journal'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    //ToolTip = 'Select any additional Defult Dimension that needs to be added on Rev. Rec. G/L Journal'; //PRJ-1579.RM.2.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Additional Dimension to be used in Rev Rec. if applicable ';//PRJ-1711.RP.1.0 24Nov2022 
                    Description = 'CTSI-274';
                }
                field("NS_Mandatory Dimension Value Rev."; Rec."NS_Mandatory Dimension Value Rev.")
                {
                    ApplicationArea = all;
                    Caption = 'Additional Dimension Value';
                    // ToolTip = 'Select additional defult dimension value as per the seelcted dimension that needs to be added on Rev. Rec. G/L Journal'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0  commented 
                    //ToolTip = 'Select additional Defult Dimension value as per the seelcted Dimension that needs to be added on Rev. Rec. G/L Journal';  //PRJ-1579.RM.2.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Additional Dimension Value to be used in Rev Rec. if applicable ';//PRJ-1711.RP.1.0 24Nov2022
                    Description = 'CTSI-274';
                }
                field("NS_Default Job Task No. Rev."; Rec."NS_Default Job Task No. Rev.")
                {
                    Description = 'CTSI-274';
                    Caption = 'Rev. Rec. Default Job Task No.';
                    ApplicationArea = all;
                    // ToolTip = 'Define the default Job Task No. to be auto picked on all Rev. Rec. G/L Journal entries. Please note that, selected job task no. should be available on every job that are included in the journal batch. Also, there is no impact on the ledgers and is just for smooth preocess of posting entries.'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    // ToolTip = 'Define the Default Job Task No. to be auto picked on all Rev. Rec. G/L Journal entries. Please note that, selected Job Task no. should be available on every Job that are included in the Journal batch. Also, there is no impact on the Ledgers and is just for smooth preocess of posting entries.'; //PRJ-1579.RM.2.0 //PRJ-1579.RM.3.0 commented
                    //ToolTip = 'Define the Default Job Task No. to be auto picked on all Rev. Rec. G/L Journal entries. Please note that, selected Job Task no. should be available on every Job that are included in the Journal batch. Also, there is no impact on the Ledgers and is just for smooth process of posting entries.'; //PRJ-1579.RM.3.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'Specifies the Rev. Rec. Default Job Task No. to be used if applicable ';//PRJ-1711.RP.1.0 24Nov2022
                }
                //PRJ-1098.NK.1.1 24Mar2022 Start
                field(NS_AutoRunRevRecPOCBatch; Rec.NS_AutoRunRevRecPOCBatch)
                {
                    Description = 'PRJ=1098';
                    Caption = 'Auto Run Revenue Rec POC Batch';
                    ApplicationArea = all;
                    // ToolTip = 'If enabled, the Revenue recognition summary detail will be auto update based on POC method used in Job after running the Batch Posting of Job Forecast Worksheets.'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    //ToolTip = 'If enabled, the "Revenue Recognition Summary Detail" will be auto update based on POC method used in Job after running the Batch Posting of Job Forecast Worksheets.';  //PRJ-1579.RM.2.0  //PRJ-1711.RP.1.0 24Nov2022 commented
                    ToolTip = 'If enabled, the "Revenue Recognition Summary Detail" will be auto update based on Percentage of Completion (POC) method used in Job after running the Batch Posting of Job Forecast Worksheets. Note: The Revenue Recognition Method on the “Job Card” must be set to “Forecast” method for this feature to work.';//PRJ-1711.RP.1.0 24Nov2022 //PRJCTPR-235.JS.1.0 23JAN2023
                }
                //PRJ-1098.NK.1.1 24Mar2022 End
                //PE-281.JS.1.0 18APR2024 - start
                field("NS_Job Default POC Method"; Rec."NS_Job Default POC Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default "POC Method" on "Job Card". If it is blank, the system by default considers it as "Job Forecast" on "Job Card".';
                }
                //PE-281.JS.1.0 18APR2024 - end


                //PE-272.JS.1.0 14MAR2024 - Start
                field("NS_Enable POC Method Change"; Rec."NS_Enable POC Method Change")
                {
                    caption = 'Enable to Change POC Method on Job';
                    ApplicationArea = All;
                    ToolTip = 'If Enable, allow the user to change POC method on job card even if the "Revenue Recognition Summary Detail" is already exist';
                }
                //PE-272.JS.1.0 14MAR2024 - end
                //PRJCTPR-346.JS.1.0 31MAR2024 - Start
                field("NS_Disable RevCat FactBox"; rec."NS_Disable RevCat FactBox")
                {
                    ApplicationArea = All;
                    caption = 'Disable Revenue Category FactBox on Job Card';
                    ToolTip = 'If disable, the "Revenue Category $" analytics factbox is not consider while opening the Job Card';
                }
                //PRJCTPR-346.JS.1.0 31MAR2024 - end                
            }
        }
        //PRJCTPR-192.DK.1.0 28Sep23 Start
        addafter("Document No. Is Job No.")
        {
            field("NS_Sell-to Cust_Ship-to Code"; Rec."NS_Sell-to Cust_Ship-to Code")
            {
                Tooltip = 'If enabled, the Sell-to Customer information will be set to default for Ship-to Code/details on General fast tab of the Job card. By default, the Ship-to Code/details gets updated with Bill-to Customer information.';
                Caption = 'Sell-to Customer Info for Ship-to Code';
                ApplicationArea = all;
            }
            //PE-191.NC.1.0 06Mar2024 Start
            field("NS_Budgeted Cost on Projection"; Rec."NS_Budgeted Cost on Projection")
            {
                // ToolTip = 'Enable to Specifies the value of the Budgeted Cost on Job Projection Tab'; //PRJCTPR-162.RM.1.0 21July2023 commented
                ToolTip = 'Enabling this Boolean will check the Job Planning Lines with Line Type not equal to Billable and picks the Total Cost LCY on Projections fast tab into the field Budget Total Cost under Actual column on Job Card.'; //PRJCTPR-162.RM.1.0 21July2023
                ApplicationArea = All;
                Caption = 'Budgeted Cost on Projection';
            }
            //PE-191.NC.1.0 06Mar2024 End
            //PE-301.NC.1.0 10Jun2024 Start
            field("NS_Pur/Sale UOM for B&B JPL"; Rec."NS_Pur/Sale UOM for B&B JPL")
            {
                ApplicationArea = all;
                Caption = 'Purchase/Sale UOM for Both Budget & Billable JPL';
                ToolTip = 'If enabled, the system will take Purchase and Sales UOM on priority from the item card else it will take UOM present on Job Planning Lines when a document is created via job planning lines for "Type=Both Budget and Billable". For e.g.: JMP, Subcontract, Progress Billing, Direct Sales and Purchase doc using "Get Project Planning Lines".';
            }
            //PE-301.NC.1.0 10Jun2024 End
        }
        //PRJCTPR-192.DK.1.0 28Sep23 End
        //PRJ-639.RS.1.0�19May2021 Start
        modify("Automatic Update Job Item Cost")
        {
            // ToolTip = 'Specifies that cost changes are automatically adjusted each time the Adjust Cost -Item Entries batch job will run.'; //PRJ-1711.RM.1.0 24Nov2022 commented
            ToolTip = 'Specifies that cost changes are automatically adjusted each time the Adjust Cost - Item Entries Batch Job is run. The adjustment process and its results are the same as when you run the Update Job Item Cost Batch Job. Recommended to the "ON". '; //PRJ-1711.RM.1.0 24Nov2022
        }
        modify("Apply Usage Link by Default")
        {
            // ToolTip = 'Specifies that job ledger entries are linked to job planning lines by default. Select this check box if you want to apply this setting to all new jobs that you will create.'; //PRJ-1711.RM.1.0 24Nov2022 commented
            ToolTip = 'By default, the ''Job Ledger Entries'' are linked to ''Job Planning Lines'' . If enabled, this will apply to  all new Jobs created.  Recommended to be "OFF" and can used on a Job by Job basis.'; //PRJ-1711.RM.1.0 24Nov2022
        }
        modify("Allow Sched/Contract Lines Def")
        {
            // ToolTip = 'Specifies that job lines can be Both type Budget and Billable by default. Select this check box if you want to apply this setting to all new jobs that you will create.'; //PRJ-1711.RM.1.0 24Nov2022 commented
            ToolTip = 'Recommend this featur be (OFF).  If  enabled (ON), Job Card will be defaulted to allow both ''Budget and Billable''.  This feature can be enabled on a Job by Job basis'; //PRJ-1711.RM.1.0 24Nov2022
        }
        modify("Default WIP Method")
        {
            ToolTip = 'Specifies how the default WIP method will be applied when posting Work in Process (WIP) to the general ledger. By default, it is applied �Per Job� but can be changed to�Per Job Ledger Entry�.';
        }
        modify("Default Job Posting Group")
        {
            // ToolTip = 'Specifies the default posting group to be applied when you create a new job.This group is used whenever you create a job, but you can modify the value on the job card.';//PRJ-1711.RM.1.0 24Nov2022 commented
            ToolTip = 'Specifies the default Posting Group to be applied when you create a new Job. This Group is used whenever you create a Job, but you can modify the value on the Job Card. '; //PRJ-1711.RM.1.0 24Nov2022
        }
        modify("Default WIP Posting Method")
        {
            ToolTip = 'Specifies how the default WIP method is to be applied when posting work in progress (WIP) to the general ledger.by default, It is applied per job.';
        }
        modify("Logo Position on Documents")
        {
            // ToolTip = 'Specifies the position of your company logo on business letters and documents.It can be set to Left,Right,Center,or No Logo.'; //PRJ-1711.RM.1.0 24Nov2022 commented
            ToolTip = 'Specifies the position of your Company Logo on business letters and documents. It can be set to Left, Right, Center, or No Logo. ';//PRJ-1711.RM.1.0 24Nov2022
        }
        modify("Job Nos.")
        {
            ToolTip = 'Specifies the code for the Job number series which will be used in Jobs.';
        }
        modify("Job WIP Nos.")
        {
            ToolTip = 'Specifies the code for the Job WIP number series which will be used in Job WIP.';
        }
        modify("Price List Nos.")
        {
            ToolTip = 'Specifies the code for the number series that will be used assign numbers to Price List Nos. To see the number series that have been setup in the No. Series table.';
        }
        //PRJ-639.RS.1.0�19May2021 End
        //PE-167.VC.1.0 18Sep2023 Start
        addafter("Default WIP Method")
        {
            field("NS_Skip Recalculate JobWIP"; Rec."NS_Skip Recalculate JobWIP")
            {
                ApplicationArea = All;
                ToolTip = 'If enabled, the WIP message will not appear after changing the Status of the Job under the "Constant/Manager" fast tab on the Job Card. Please note that WIP messages will only skip if no WIP Entries exist for the same job.';//PE-167.VC.1.3 27Sep2023
            }
        }
        //PE-167.VC.1.0 18Sep2023 End

        //PE-246.HS.1.0 1Feb2024 Start
        addlast(NS_Lists)
        {
            field("NS_Change Ordr NumberingFormat"; Rec."NS_Change Ordr NumberingFormat")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the starting number for Sub Levels to be displayed after the Master job No. Users can either enter "1" or "01". By default, it is set to "001". (For e.g. if master job no. is J00200, entering "1" means the sub level no. will be J00200.1 or entering "01" means the sub level no. will be J00200.01 & if it is left blank, then the no. will be J00200.001).';
                trigger OnValidate()
                begin
                    if Rec."NS_Change Ordr NumberingFormat" <> '' then begin
                        if (Rec."NS_Change Ordr NumberingFormat" <> '1') AND (Rec."NS_Change Ordr NumberingFormat" <> '01') then
                            Error('You can only enter either 1 or 01.');
                    end;

                end;
            }

        }
        //PE-246.HS.1.0 1Feb2024 End
    }
    actions
    {

        addfirst(processing)
        {
            group("NS Functions")
            {
                Caption = 'Functions';
                action("NS Initialize Linked Job List")
                {
                    ApplicationArea = All;
                    Caption = 'Initialize Linked Job List';
                    Image = JobListSetup;
                    RunObject = Report "NS_Initialize Job Link List";
                }
                action("NS Initialize Linked Subc List")
                {
                    ApplicationArea = All;
                    Caption = 'Initialize Linked Subcontract List';
                    Image = ServiceSetup;
                    RunObject = Report "NS_Initialize Subcont LinkList";
                }
            }
        }
    }
    VAR //CTSI-254.AS.1.0
        OldAdvanceBoolEditable: Boolean;//CTSI-254.AS.1.0
        NewAdvanceBoolEditable: Boolean;//CTSI-254.AS.1.0

        //PE-247.HS.1.0 6Feb2024  Start
        NS_EditAutoPost: Boolean;
        NS_EnableAutoPost: Boolean;
    //PE-247.HS.1.0 6Feb2024  End


    trigger OnOpenPage()
    begin
        //CTSI-254.AS.1.0 - START
        IF "NS_Advanced Burden Allocation" = FALSE THEN BEGIN
            OldAdvanceBoolEditable := true;
            NewAdvanceBoolEditable := false;
        END;

        IF "NS_Advanced Burden Allocation" = TRUE THEN BEGIN
            OldAdvanceBoolEditable := FALSE;
            NewAdvanceBoolEditable := TRUE;
        END;
        //CTSI-254.AS.1.0 - END
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //CTSI-254.AS.1.0 - START
        IF "NS_Advanced Burden Allocation" = FALSE THEN BEGIN
            OldAdvanceBoolEditable := true;
            NewAdvanceBoolEditable := false;
        END;

        IF "NS_Advanced Burden Allocation" = TRUE THEN BEGIN
            OldAdvanceBoolEditable := FALSE;
            NewAdvanceBoolEditable := TRUE;
        END;
        //CTSI-254.AS.1.0 - END
    end;

    trigger OnAfterGetRecord()
    begin
        //CTSI-254.AS.1.0 - START
        IF "NS_Advanced Burden Allocation" = FALSE THEN BEGIN
            OldAdvanceBoolEditable := true;
            NewAdvanceBoolEditable := false;
        END;

        IF "NS_Advanced Burden Allocation" = TRUE THEN BEGIN
            OldAdvanceBoolEditable := FALSE;
            NewAdvanceBoolEditable := TRUE;
        END;
        //CTSI-254.AS.1.0 - END

        //PE-247.HS.1.0 6Feb2024 Start
        if Rec."NS_Enable Job Labor to G/L" then
            NS_EditAutoPost := Rec."NS_Enable Job Labor to G/L"
        else
            NS_EditAutoPost := Rec."NS_Enable Job Labor to G/L";
        //PE-247.HS.1.0 6Feb2024 End
    end;
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added FastTab(s):
    // +     Retention
    // +     Progress Billing
    // +     Progress Payment
    // +     Subcontract
    // +     Lists
    // +     Indirect Burden Allocation
    // +     Labor to G/L
    // +     Job Quoting
    // +     Job Material Planning
    // +
    // +  - Added field(s):
    // +     "NS Cost Category Required Bud"
    // +     "NS Cost Category Required"
    // +     "NS Reve Category Required Bud"
    // +     "NS Rev Category Required"
    // +     "NS Post Labor Burden To Job"
    // +     "NS Labor Burden Cost Category"
    // +     "NS Warning on Zero Multiplier"
    // +     "NS Item Jnl Use Budgeted Cost"
    // +     "NS Default Job Class"
    // +     "NS Default Deposit Job Task No."
    // +     "NS AP Separators"
    // +     "NS Activity Code Position"
    // +     "NS KPI Calculation Start Date"
    // +     "NS KPI Calculation Ending Date"
    // +     "NS Gen. Bus. Posting Group"
    // +     "NS Job Calendars Not Used"
    // +     "NS Job Calendar Source"
    // +     "NS Job Calendar Code"
    // +     "NS Forecast Percent For Hours Req"
    // +     "NS Default Forecast Type"
    // +     "NS Default Draw Payment Terms"
    // +     "NS Allow Timesheet & Job Jnl"
    // +     "NS Subcontract Nos."
    // +     "NS Draw Nos."
    // +     "NS Subcontract Draw Nos."
    // +     "NS Lien Release Document 01"
    // +     "NS Lien Release Doc 01 Name"
    // +     "Progress Billing Nos."
    // +     "PB Sales Invoice Nos."
    // +     "PB Posted Invoice Nos."
    // +     "PB Sales Credit Memo Nos."
    // +     "PB Posted Credit Memo Nos."
    // +     "NS Sales Retention Period"
    // +     "NS Purchase Retention Period"
    // +     "NS Retention Receivable Ledger"
    // +     "NS Retention Payable Ledger"
    // +     "NS Calc Receiv Ret Before Tax"
    // +     "NS Calc Payable Ret Before Tax"
    // +     "NS A/R Retention Calc Method"
    // +     "NS A/P Retention Calc Method"
    // +     "NS AIA Form Code"
    // +     "NS AIA Form Expiration Date"
    // +     "AIA G702 Show With Page No."
    // +     "AIA G703 Start As Page No."
    // +     "NS Sales Document Type"
    // +     "NS _Prog Bill Salesperson Dim"
    // +     "NS Prog. Bill Gen Prod Pst Grp"
    // +     "NS Progress Billing Rounding"
    // +     "NS Progress Bill Std Invoice"
    // +     "NS Progress Bill Std Inv Name"
    // +     "NS _Progr Bill First No. Def"
    // +     "NS Prog Pay AIA Form Code"
    // +     "NS Prog Pay AIA Form Exp Date"
    // +     "NS Prog Pay G702 Show Page No"
    // +     "NS Prog Pay G703 Start Page"
    // +     "NS Prog Pay Payment Doc Type"
    // +     "NS Prog Pay Salesperson Dim Code"
    // +     "NS Prog Pay Gen. Prod. Post Gr."
    // +     "NS Prog Pay Rounding"
    // +     "NS Prog Pay Standard Invoice"
    // +     "NS Prog Pay Std Inv Name"
    // +     "NS _Subcontract Default UOM"
    // +     "NS _Subcontract Use of UOM"
    // +     "NS Job No. Separators"
    // +     "NS Job List Indent Increment"
    // +     "NS Job List Default Level"
    // +     "NS Job List Bolding"
    // +     "NS Job List Auto Link Create"
    // +     "NS Subcontract No. Separators"
    // +     "NS Subcont List Indent Incr"
    // +     "NS Subcont List Default Lvl"
    // +     "NS Subcontract List Bolding"
    // +     "NS Subc List Auto Link Create"
    // +     "Calculate Indirect Burden"
    // +     "NS Burden Alloc Form - Credit"
    // +     "NS Burden Alloc To - Debit"
    // +     "NS Burden Alloc Dimension"
    // +     "NS Burden Alloc Proj Dim Value"
    // +     "NS Burden Alloc Serv Dim Value"
    // +     "NS Burden Required"
    // +     "NS Burden Job Cost Category"
    // +     "Use Default Tasks"
    // +     "Billing Job Task No."
    // +     "Total Task No."
    // +     "Use Job Mat'l Plan Active"
    // +     "Job Mat'l Planning Location"
    // +     "Expanded Job Material Planning"
    // +     "Purchase Resources with Orders"
    // +     "Work Order No. Series"
    // +     "Received Accrual Batch Name"
    // +     "Post Job Labor to G/L"
    // +     "Labor Allocated to Job - Debit"
    // +     "Labor to Job Offset - Credit"
    // +     "Labor to Job Batch Name"
    // +     "Allow Updates to Orig Planning"
    // +     "Highlight Price Less Than Cost"
    // +     "Auto Lock Planning Lines"
    // +
    // +  - Modification(s):
    // +     - Added Functions menu: Initialize Linked Job List, Initialize Linked Subcontract List
    // +     - Modified field 'Purchase Resources with Orders' to show as 'Use Purchase Orders for Resources'
    // +------------------------------------------------------------
}