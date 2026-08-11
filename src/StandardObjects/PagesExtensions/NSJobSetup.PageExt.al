pageextension 14021260 NS_JobSetupExt extends "Jobs Setup"
{
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

    layout
    {
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
            }
            field("NS Post Labor Burden To Job"; Rec."NS_Post Labor Burden RateToJob")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Post Labor Burden Rate To Job';
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
            }
            field("NS Item Jnl Use Budgeted Cost"; Rec."NS_Item JNL Use Budgeted Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Item Journal Use Budgeted Cost';
            }
            field("NS Default Job Class"; Rec."NS_Default Job Class")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Default Job Class'; //PRJ-639.RS.1.0 19May2021 Comment
                ToolTip = 'Specifies the categorization of job class while creating a new Job.';//PRJ-639.RS.1.0 19May2021
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
                ToolTip = 'Specifies the boolean if Progress Billing flow same G/L in Sales Document.';
                ApplicationArea = All;
            }
            //PRJ-973.GK.1.0 13Oct2021 end
            field("NS APO Separators"; Rec."NS_APO Separators")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the APO Separators'; //PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the default separators while creating job task lines between Activities, Process and Operations codes.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS Activity Code Position"; Rec."NS_Activity Code Position")
            {
                ApplicationArea = All;
                Caption = 'Activity Code Position in Job Task No.';
                MultiLine = true;
                ToolTip = 'Specifies the positioning of the activity on the job task number.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS KPI Calculation Start Date"; Rec."NS_KPI CalculationStartingDate")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies KPI Calculation Starting Date'; //PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies Starting date of the Key Process Indicator (KPI).';//PRJ-639.RS.1.0�19May2021
            }
            field("NS KPI Calculation Ending Date"; Rec."NS_KPI Calculation Ending Date")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies KPI Calculation Ending Date';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies Ending date of  the Key Process Indicator (KPI).';//PRJ-639.RS.1.0�19May2021
            }
            field("NS Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Gen. Bus. Posting Group';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies that default Gen. Bus. Posting group code to be picked in Purchase and Sales documents.';//PRJ-639.RS.1.0�19May2021
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
            field("NS Job Calendar Source"; Rec."NS_Job Calendar Source")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendar Source';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the source of the calendar It can be either Navision Calendar or Job calendar.';//PRJ-639.RS.1.0�19May2021

                trigger OnValidate()
                begin
                    //ProjectPro - start
                    IF "NS_Job Calendar Source" <> xRec."NS_Job Calendar Source" THEN
                        "NS_Job Calendar Code" := '';
                    //ProjectPro - end
                end;
            }
            field("NS Job Calendar Code"; Rec."NS_Job Calendar Code")
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies the Job Calendar Code';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the calendar code for jobs as per the calendar source selected.';//PRJ-639.RS.1.0�19May2021
            }
            //TM-10.AM.1.0 start
            field("NS_Job Segment Mandatory"; Rec."NS_Job Segment Mandatory")
            {
                ApplicationArea = all;
                Caption = 'Job Segment Mandatory';
                ToolTip = 'Specifies that the job segment is mandatory for every transaction related to job';//PRJ-639.RS.1.0�19May2021
            }
            //TM-10.AM.1.0 End
            field("NS_Get Job Segment"; Rec."NS_Get Job Segment")
            {
                ApplicationArea = all;
                Description = 'PRJ-291.MS.1.0';
            }
            field("NS_Auto Lock Planning Lines"; Rec."NS_Auto Lock Planning Lines")//PRJ-756.RS.1.0 18June21 It has Moved from "Job Quoting" Group
            {
                ApplicationArea = All;
                //ToolTip = 'Specifies that case you can auto lock the job planning lines.';//PRJ-639.RS.1.0�19May2021 //PRJ-756.RS.1.0 18June21 Commented
                ToolTip = 'Specifies that you want the program to Lock the Planning Lines';//PRJ-756.RS.1.0 18June21
            }
        }
        addafter("Logo Position on Documents")
        {
            field("NS Forecast Percent For Hours Req"; Rec."NS_Forecast Percent For HrsReq")
            {
                ApplicationArea = All;
                Caption = 'Forecast Percent For Hours Req';
                //ToolTip = 'Specifies the Forecast Percent For Hours Req';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies that at what percent of your budget should trigger hours to finish by project managers.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS Default Forecast Type"; Rec."NS_Default Forecast Type")
            {
                ApplicationArea = All;
                Caption = 'Default Forecast Type';
                //ToolTip = 'Specifies the Default Forecast Type';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the type of  Job Forecast be available and calculations on the basis of : % of  Budget or % of  Projected. Recommend % of  Projected if you will be using the Job Forecast Tool.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS  Default Draw Payment Terms"; Rec."NS_Draw Default Payment Terms")
            {
                ApplicationArea = All;
                Caption = 'Default Draw Payment Terms';
                //ToolTip = 'Specifies the Default Draw Payment Terms';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the payment terms to be set for vendors as a default when using �Pay when Paid� business process.The �Pay when Paid� is the term of paying your vendors when your customer pays you. This is typically set in ProjectPro to 999D.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS Allow Timesheet & Job Jnl"; Rec."NS_Allow Timesheet&JobJnlPost")
            {
                ApplicationArea = All;
                Caption = 'Allow Time Sheet & Job Jnl';
                //ToolTip = 'Specifies the Allow Time Sheet & Job Jnl';//PRJ-639.RS.1.0�19May2021 Comment 
                ToolTip = 'Specifies and enables users to enter resources on the Job Journal even though their resource card is set to �allow time sheet entry�.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS_Received Accrual Batch Name"; Rec."NS_Received Accrual Batch Name")
            {
                ApplicationArea = All;
                Caption = 'Rcvd. Accr. Batch Name';
                ToolTip = 'Specifies the Rcvd. Accr. Batch Name';
            }
            field("NS_Allow Updates To Orig Planning"; Rec."NS_Allow UpdatesToOrigPlanning")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allow Updates To Orig Planning';
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
                    ToolTip = 'Specifies the job journal template for FA posting with job.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_FA Job Batch Name"; Rec."NS_FA Job Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Job journal batch based on the template selected on prior field.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Check Master Job No."; Rec."NS_Check Master Job No.")//PRJ-604.AS.1.0
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Check Master Job No.'; //PRJ-987.RM.1.0 14Oct2021 |Comment Code
                    ToolTip = 'Specifies the validation of the newly created Job Task No. in Sub Level Jobs against the Master Job'; //PRJ-987.RM.1.0 14Oct2021| Add Code
                }

                field("NS_Notify Insurance Exp"; Rec."NS_Notify Insurance Exp")//PRJ-1040.AS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Notify Insurance Expiration';

                }
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
                ToolTip = 'Specifies the report number for the Lien Release Report.';//PRJ-639.RS.1.0�19May2021

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
                ToolTip = 'Specifies the code for the number series that will be used assign numbers to PrePayment Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
            }
            field("NS_Job Quote No. Series"; Rec."NS_Job Quote No. Series")
            {
                ApplicationArea = All;
                Caption = 'Quote Nos.';
                //ToolTip = 'Specifies the Quote Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                ToolTip = 'Specifies the code for the number series that will be used assign numbers to Quote Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
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
                ToolTip = 'Specifies the code for the number series that will be used assign numbers to Work Order Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
            }
            group("NS_Progress Billing Numbers")
            {
                Caption = 'Progress Billing Numbers';
                field("NS_Progress Billing Nos."; Rec."NS_Progress Billing Nos.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Progress Billing Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Progress Billing. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_PB Sales Invoice Nos."; Rec."NS_PB Sales Invoice Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Invoice Nos.';
                    //ToolTip = 'Specifies the Sales Invoice Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Sales Invoice Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_PB Posted Invoice Nos."; Rec."NS_PB Posted Invoice Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoice Nos.';
                    //ToolTip = 'Specifies the Posted Sales Invoice Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Posted Sales Invoice Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_PB Sales Credit Memo Nos."; Rec."NS_PB Sales Credit Memo Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Memo Nos.';
                    //ToolTip = 'Specifies the Credit Memo Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Credit Memo Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_PB Posted Credit Memo Nos."; Rec."NS_PB Posted Cr. Memo Nos.")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Credit Memo Nos.';
                    //ToolTip = 'Specifies the Posted Credit Memo Nos.';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Posted Credit Memo Nos. To see the number series that have been setup in the No. Series table.';//PRJ-639.RS.1.0�19May2021
                }
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
                    ToolTip = 'Specifies the aging of the retention portion of the receivable. The �1Y� means one year from the document date for establishing retention receivable due dates.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Purchase Retention Period"; Rec."NS_Purchase Retention Period")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Purchase Retention Period';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the aging of the retention portion of the receivable.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Retention Receivable Ledger"; Rec."NS_Retention Receivable Ledger")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Retention Receivable Ledger';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the default value when system post the retention in to customer ledger entry to identify the retention entry.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Retention Payable Ledger"; Rec."NS_Retention Payable Ledger")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Retention Payable Ledger';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the default value when system post the retention in to vendor ledger entry to identify the retention entry.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Calc Receiv Ret Before Tax"; Rec."NS_Calc ReceivableRetBeforeTax")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Calc Receivable Ret Before Tax';//PRJ-639.RS.1.0�19May2021 Comment
                    Visible = false;
                    ToolTip = 'Specifies that your preference is to have the retention receivables calculated before tax is assessed.';//PRJ-639.RS.1.0�19May2021
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
                    //ToolTip = 'Specifies the A/R Retention Calc Method';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that the retention calculation method for sales whether its beofre the tax or after the tax.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS A/P Retention Calc Method"; Rec."NS_A/P RetentionTaxCalcMethod")
                {
                    ApplicationArea = All;
                    Caption = 'A/P Retention Calc Method';
                    //ToolTip = 'Specifies the A/P Retention Calc Method';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that the retention calculation method for purchase whether its beofre the tax or after the tax.';//PRJ-639.RS.1.0�19May2021
                }
            }
            group("NS_Progress Billiing")
            {
                Caption = 'Progress Billing';//PRJ-191.AS.1.0 - 2APRIL2020
                field("NS AIA Form Code"; Rec."NS_AIA Form Code")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA Form Code';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the AIA From Code.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS AIA Form Expiration Date"; Rec."NS_AIA Form Expiration Date")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA Form Expiration Date';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the AIA Form expiry date.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_AIA G702 Show With Page No."; Rec."NS_AIA G702 Show With Page No.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA G702 Show With Page No.';//PRJ-639.RS.1.0�19May2021 Comment
                    LookupPageID = Objects; //PRJ-39.SK.1.0
                    ToolTip = 'Specifies the report with page number.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_AIA G703 Start As Page No."; Rec."NS_AIA G703 Start As Page No.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the AIA G703 Start As Page No.';//PRJ-639.RS.1.0�19May2021 Comment
                    LookupPageID = Objects; //PRJ-39.SK.1.0
                    ToolTip = 'Specifies the page number from where report should be started.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Sales Document Type"; Rec."NS_Sales Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Document Type to Create';
                    //ToolTip = 'Specifies the Sales Document Type to Create';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the setting for whether you want the progress billing to create either a Customer Sales Order or a Customer Sales Invoice.';//PRJ-639.RS.1.0�19May2021
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
                    ToolTip = 'Specifes default Gen. Prod. Posting group to be defined while creating the Progress Bill on line items.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Progress Billing Rounding"; Rec."NS_Progress Billing Rounding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Progress Billing Rounding';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the Option for rounding the progress billing sales amounts to nearest currency.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Progress Bill Std Invoice"; NS_ProgressBillStandardInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Billing Std Inv Report ID';
                    LookupPageID = Objects;
                    //ToolTip = 'Specifies the Progress Billing Std Inv Report ID';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the report number for a standard Invoice.';//PRJ-639.RS.1.0�19May2021

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
                    ToolTip = 'Specifies that the Job No. is used as Prefix to the Progress Billing No.'; //PRJ-985.RM.1.0 14Oct2021
                }
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
                    ToolTip = 'Specifies the setting for which you want  the progress billing to create either  a Vendor Purchase Order or a Vendor Purchase Invoice.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay Salesperson Dim Code"; Rec."NS_Prog Pay Purchaser Dim Code")
                {
                    ApplicationArea = All;
                    Caption = 'Prog Payment Purchaser Dimension';
                    //ToolTip = 'Specifies the Prog Payment Purchaser Dimension';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the default dimension value that will belong to purchaser in case of  Progress Payment.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay Gen. Prod. Post Gr."; Rec."NS_Prog Pay Gen. Prod. PostGr.")
                {
                    ApplicationArea = All;
                    Caption = 'General Product Posting Group';
                    //ToolTip = 'Specifies the General Product Posting Group';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the Sets of default General  Product Posting Group that is used during the Vendor Invoice process.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay Rounding"; Rec."NS_Prog Pay Rounding")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment Rounding';//PRJ-400.AS.1.0 12APRIL2021
                    //ToolTip = 'Specifies the Progress Billing Rounding';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies and enable the option for rounding the progress payment vendor amounts to nearest to currency.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Prog Pay Standard Invoice"; Rec."NS_Prog Pay Standard Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment Std Inv Report ID';//PRJ-400.AS.1.0 12APRIL2021
                    LookupPageID = Objects;
                    //ToolTip = 'Specifies the Progress Billing Std Inv Report ID';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the report number for a standard Invoice.';//PRJ-639.RS.1.0�19May2021

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
                    ToolTip = 'Specifies the automatically updates the name of the Report.';//PRJ-639.RS.1.0�19May2021
                }
                //PRJ-889.GK.1.0 13Sep2021 start
                field("NS_Progress Payment Enable"; Rec."NS_Progress Payment Enable")
                {
                    ToolTip = 'Specifies the value of the Progress Payment Enable field';
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
                    ToolTip = 'Specifies the default unit of measure while creating the subcontract card from job.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Subcontract Use of UOM"; Rec."NS_Subcontract Use of UOM")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Use of UOM';
                    //ToolTip = 'Specifies the Subcontract Use of UOM';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the flexbility to pick the Subcontract Deafult UOM if there is no unit of measure has been provided in planning lines.';//PRJ-639.RS.1.0�19May2021
                }

                field("NS_Unapply UsageLink on Subcon"; Rec."NS_Unapply UsageLink on Subcon")    //PRJ-866.JS.1.0 19Aug2021
                {
                    Caption = 'Unapply Usage Link on Subcontract';
                    ToolTip = 'Specifies the value of the Unapply Usage Link on Subcontract';
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
                    ToolTip = 'Specifies the symbol used to differentiate Master Jobs from Sub-Level Jobs. Example: 9600,  9600.01,  9600.02,  etc.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Job List Indent Increment"; Rec."NS_Job List Indent Increment")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Indent Increment';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the view of indented sub-level Jobs under master Jobs.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Job List Default Level"; Rec."NS_Job List Default Level")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Default Level';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that how many levels of Job sub-levels you want the list too.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Job List Bolding"; Rec."NS_Job List Bolding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Bolding';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies what level will be bold during list display.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Job List Auto Link Create"; Rec."NS_Job List Auto Link Create")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job List Auto Link Create';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies and enables a job list table to be populated with the links between the various job classes.This function should always be on.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Subcontract No. Separators"; Rec."NS_Subcontract No. Separators")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract No. Separators';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the symbol that will be used to differentiate Master Subcontractor from Sub-Level.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Subcont List Indent Incr"; Rec."NS_Subcont ListIndentIncrement")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcont List Indent Increment';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the sub-level Jobs under master Jobs.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Subcont List Default Lvl"; Rec.NS_SubcontractListDefaultLevel)
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract List Default Level';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies how many levels of subcontract sub-levels you want  the list to default too. See sample list below.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Subcontract List Bolding"; Rec."NS_Subcontract List Bolding")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcontract List Bolding';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies Indicates what  level is bold during list display.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Subc List Auto Link Create"; Rec."NS_Subcont ListAutoLinkCreate")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Subcont List Auto Link Create';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies and enables a subcontract list table to be populated with the links between the various job classes.This should always be on.C75';//PRJ-639.RS.1.0�19May2021
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
                    ToolTip = 'Specifies that if indirect burden is to be required in your business process.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Advanced Burden Allocation"; REC."NS_Advanced Burden Allocation")//CTSI-254.AS.1.0
                {
                    ApplicationArea = All;
                    Caption = 'Advanced Burden Allocation';
                    ToolTip = 'Specifies the Advanced Burden Allocation';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("NS Burden Alloc From - Credit"; Rec."NS_Burden Alloc From - Credit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc From - Credit';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the credit G/L account for burden allocation.This G/L account is usually from the �Indirect Job Cost� section of your Chart of Accounts.';//PRJ-639.RS.1.0�19May2021
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc To - Debit"; Rec."NS_Burden Alloc To - Debit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc To - Debit';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies Select the debit G/L account for burden allocation.This  G/L account is usually from the �Direct Job Cost� section of your Chart of Accounts.';//PRJ-639.RS.1.0�19May2021
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Dimension"; Rec."NS_Burden Alloc Dimension")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Dimension';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies and indicates which dimension will be used for burden and that will be linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Proj Dim Value"; Rec."NS_Burden AllocProjectDimValue")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Project Dim Value';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for a dimension that is linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS Burden Alloc Serv Dim Value"; Rec."NS_Burden AllocServiceDimValue")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Alloc Service Dim Value';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the code for a dimension that is linked to the record or entry for analysis purposes.';//PRJ-639.RS.1.0�19May2021
                    Editable = OldAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Auto Post Burden to G/L"; REC."NS_Auto Post Burden to G/L")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    Caption = 'Auto Post Burden to G/L';
                    ToolTip = 'Specifies the Auto Post Burden to G/L';
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0

                }
                field("NS_Burden G/L Journal Template"; REC."NS_Burden G/L Journal Template")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden G/L Journal Template';
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Burden G/L Journal Batch"; rec."NS_Burden G/L Journal Batch")//CTSI-254.AS.1.0 25MARCH2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden G/L Journal Batch';
                    Editable = NewAdvanceBoolEditable;//CTSI-254.AS.1.0
                }
                field("NS_Mandatory Dimension"; rec."NS_Mandatory Dimension")
                {
                    ApplicationArea = all;
                    Caption = 'Mandatory Dimension';
                    Description = 'CTSI-254';
                    Editable = NewAdvanceBoolEditable;
                }
                field("NS_Mandatory Dimension Value"; rec."NS_Mandatory Dimension Value")
                {
                    ApplicationArea = all;
                    Caption = 'Mandatory Dimension Value';
                    Description = 'CTSI-254';
                    Editable = NewAdvanceBoolEditable;
                }
                field("NS_Default Job Task No."; rec."NS_Default Job Task No.")
                {
                    Description = 'CTSI-254';
                    Editable = NewAdvanceBoolEditable;
                    ApplicationArea = all;
                }
                field("NS Burden Required"; Rec."NS_Burden Required")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Burden Required';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the burden if required for all jobs please trun ON.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS Burden Job Cost Category"; Rec."NS_Burden Job Cost Category")
                {
                    ApplicationArea = All;
                    Caption = 'Burden Job Cost Category';
                    //ToolTip = 'Specifies the Burden Job Cost Category';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the job cost category for Burden calculations.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Dimension for Labor Rates"; Rec."NS_Dimension for Labor Rates")
                {
                    ApplicationArea = all;
                    Description = 'CTSI-95.MS.1.0';
                    Caption = 'Dimension for Labor Rates';
                }
            }
            group("NS_Labor to G/L")
            {
                Caption = 'Labor to G/L';
                field("NS_Post Job Labor to G/L"; Rec."NS_Post Job Labor to G/L")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Post Job Labor to G/L';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the senario when labor is posted through the Job Journal, you can turn ON to create a General Ledger entry.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Labor Allocated to Job - Debit"; Rec."NS_LaborAllocated toJob -Debit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor Allocated to Job - Debit';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the General Ledger account to post job cost �labor value.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Labor to Job Offset - Credit"; Rec."NS_Labor to JobOffset - Credit")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor to Job Offset - Credit';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the General Ledger account that is the of f set to the labor posted to the G/L.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Labor to Job Batch Name"; Rec."NS_Labor to Job Batch Name")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Labor to Job Batch Name';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies either set to �Default� or �Labor�.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Job Cost Cat.for Rev.LaborEnt."; Rec."NS_Job Cost Cat.for Rev.LaborEnt.")
                {
                    ApplicationArea = ALL;
                    Description = 'NSAL-64.MS.1.0';
                    //ToolTip = 'Specifies the Job cost Cat. for Reverse Labor Entries';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Select the job cost category to be used f or posting reversal of  labor entries.';//PRJ-639.RS.1.0�19May2021
                }
            }
            group("NS_Job Quoting")
            {
                Caption = 'Job Quoting';
                field("NS_Use Default Tasks"; Rec."NS_Use Default Tasks")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Use Default Tasks';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that system will allow to copy the task template in job quote.';//PRJ-639.RS.1.0�19May2021
                }

                field("NS_Billing Job Task No."; Rec."NS_Billing Job Task No.")    //PRJ-881.JS.1.0 25Aug2021
                {
                    Caption = 'Billing Job Task No.';
                    ToolTip = 'Specifies default heading while managing with job quoting in case of billing task number. Syste carry forwards this value to new job created from job quote.'; //PRJ-639.RS.1.0�19May2021
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Billing Job Task No.';//PRJ-639.RS.1.0�19May2021 Comment
                }
                field("NS_Total Task No."; Rec."NS_Total Task No.")    //PRJ-881.JS.1.0 25Aug2021
                {
                    Caption = 'Total Task No.';
                    //ToolTip = 'Specifies default heading while managing with job quoting in case of budget total task number. Syste carry forwards this value to new job created from job quote.';//PRJ-639.RS.1.0�19May2021 //PRJ-935.RM.1.0 04-Oct-2021-Comment
                    ToolTip = 'Specifies the default APO code to be used in Job Quoting. The System carries this value forward when a new job is created'; //PRJ-935.RM.1.0 04-Oct-2021
                    ApplicationArea = All;
                }
            }
            group("NS_Job Material Planning")
            {
                Caption = 'Job Material Planning';
                field("NS_Use Job Mat'l Plan Active"; Rec."NS_Use Job Mat'l Plan Active")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies whether to activate Use Job Mat''l Plan Active';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies that job material planning functionality to be used against the job.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Job Mat'l Planning Location"; Rec."NS_Job Mat'l Planning Location")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Job Mat''l Planning Location';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the default location for Job Material Planning  module.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Expanded Job Material Planning"; Rec.NS_ExpandedJobMaterialPlanning)
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Expanded Job Material Planning';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the use of G/L accounts on the JMP worksheet.';//PRJ-639.RS.1.0�19May2021
                }
                field("NS_Purchase Resources with Orders"; Rec.NS_PurchaseResourcesWithOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Use Purchase Orders for Resources';
                    //ToolTip = 'Specifies the Use Purchase Orders for Resources';//PRJ-639.RS.1.0�19May2021 Comment
                    ToolTip = 'Specifies the purchase document type to be created from JMP as to Vendor Purchase Order or Vendor Purchase Invoice.';//PRJ-639.RS.1.0�19May2021
                }
            }

            group("NS_Job Forecast Worksheet")
            {
                Caption = 'Job Forecast Worksheet';   //PRJ-659.JS.1.0�27July2021
                field("NS_GBPG for Job Forecast"; Rec."NS_GBPG for Job Forecast")//CTSI-115.AS.1.0 Added field
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GBPG for Job Forecast';
                    Caption = 'GBPG for Sub-Level Job Forecast';
                }
                field("NS Allow Posting Date on JFW As of Date Filter"; Rec."NS_Allow Posting Date on JFW As of Date Filter")
                {
                    Caption = 'Allow Posting Date on JFW As of Date Filter';
                    Description = 'CTSI-268';
                    ApplicationArea = All;
                }
                //PRJ-543.AS.1.0 18FEB2021 - START
                field("NS_Forecast Amount Rounding"; Rec."NS_Forecast Amount Rounding")
                {
                    ApplicationArea = All;
                    ToolTip = 'Forecast Amount Rounding';
                }
                //PRJ-543.AS.1.0 18FEB2021 - END
                field("NS_Required GM% Var for JFW Comments"; Rec."NS_Required GM% Var for JFW Comments")
                {
                    ApplicationArea = all;
                    Description = 'CTSI-268';
                }

            }
            group("NS_Revenue Recognition")
            {
                Caption = 'Revenue Recognition';   //PRJ-659.JS.1.0�27July2021
                field("NS_Burden G/L Journal Template Rev."; Rec."NS_Burden G/L Journal Template Rev.")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Burden G/L Journal Template';  //PRJ-945.RM.1.0 04-Oct-2021- Comment
                    ToolTip = 'Specifies the Rev. Rec. G/L Journal Template';  //PRJ-945.RM.1.0 04-Oct-2021
                    Description = 'CTSI-274';
                }
                field("NS_Burden G/L Journal Batch Rev."; Rec."NS_Burden G/L Journal Batch Rev.")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Burden G/L Journal Batch';  //PRJ-945.RM.1.0 04-Oct-2021- Comment
                    ToolTip = 'Specifies the Rev. Rec. G/L Journal Batch';  //PRJ-945.RM.1.0 04-Oct-2021
                    Description = 'CTSI-274';
                }
                field("NS_Mandatory Dimension Rev."; Rec."NS_Mandatory Dimension Rev.")
                {
                    ApplicationArea = all;
                    Caption = 'Additional Dimension';
                    Description = 'CTSI-274';
                }
                field("NS_Mandatory Dimension Value Rev."; Rec."NS_Mandatory Dimension Value Rev.")
                {
                    ApplicationArea = all;
                    Caption = 'Additional Dimension Value';
                    Description = 'CTSI-274';
                }
                field("NS_Default Job Task No. Rev."; Rec."NS_Default Job Task No. Rev.")
                {
                    Description = 'CTSI-274';
                    Caption = 'Rev. Rec. Default Job Task No.';
                    ApplicationArea = all;
                }
            }
        }
        //PRJ-639.RS.1.0�19May2021 Start
        modify("Automatic Update Job Item Cost")
        {
            ToolTip = 'Specifies that cost changes are automatically adjusted each time the Adjust Cost -Item Entries batch job will run.';
        }
        modify("Apply Usage Link by Default")
        {
            ToolTip = 'Specifies that job ledger entries are linked to job planning lines by default. Select this check box if you want to apply this setting to all new jobs that you will create.';
        }
        modify("Allow Sched/Contract Lines Def")
        {
            ToolTip = 'Specifies that job lines can be Both type Budget and Billable by default. Select this check box if you want to apply this setting to all new jobs that you will create.';
        }
        modify("Default WIP Method")
        {
            ToolTip = 'Specifies how the default WIP method will be applied when posting Work in Process (WIP) to the general ledger. By default, it is applied �Per Job� but can be changed to�Per Job Ledger Entry�.';
        }
        modify("Default Job Posting Group")
        {
            ToolTip = 'Specifies the default posting group to be applied when you create a new job.This group is used whenever you create a job, but you can modify the value on the job card.';
        }
        modify("Default WIP Posting Method")
        {
            ToolTip = 'Specifies how the default WIP method is to be applied when posting work in progress (WIP) to the general ledger.by default, It is applied per job.';
        }
        modify("Logo Position on Documents")
        {
            ToolTip = 'Specifies the position of your company logo on business letters and documents.It can be set to Left,Right,Center,or No Logo.';
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