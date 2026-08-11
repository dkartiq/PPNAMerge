pageextension 14021132 NS_JobList extends "Job List"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PPAL-80.AS.1.0 31JULY2020 Hide action Report Job Quote and action Send Job Quote from job card page
    //PRJ-325.AS.1.0 16JULY2020 Commented some code for Job planning lines editable and added some code for action trigger 
    //CTSI-152.AS.1.0 14Sept2020 Added action to run Project profit analysis report
    //JD-48.AS.2.0 Added code to run JFW by forecast method
    //PRJ-464.AM.1.0 23NOV2020 | Added field on page layout.
    //CTSI-196.MS.1.0 added new field
    //PRJ-659.RS.1.0�22June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    layout
    {
        modify(Control1905650007)
        {
            Visible = true;
        }
        modify(Control1905767507)
        {
            Visible = true;
        }


        addafter(Description)
        {
            field("NS_Job Class"; Rec."NS_Job Class")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Class';
            }
            //PRJ-464.AM.1.0 Start
            field("NS_Sub-Level to Job No."; Rec."NS_Sub-Level to Job No.")
            {
                ApplicationArea = all;
            }
            //PRJ-464.AM.1.0 End
            field("NS_Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Budgeted Cost (LCY)';
            }
            field("NS_Budgeted Price (LCY)"; Rec."NS_Budgeted Price (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Budgeted Price (LCY)';
            }
        }
        addafter("Search Description")
        {
            field("NS_Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Global Dimension 1 Code';
            }
            field("NS_Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the "Global Dimension 2 Code';
            }
            field("NS_Last Forecast Posted Date"; "NS_Last Forecast Posted Date")
            {
                ApplicationArea = all;
                Description = 'CTSI-196.MS.1.0';
            }
        }
        addafter(Control1905650007)
        {
            part("NS_Job_Details"; "Job Cost Factbox")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Details';
                Enabled = false;
                SubPageLink = "No." = FIELD("No.");
                Visible = JobSimplificationAvailable;
            }
            part("NS_Job A/R A/P Balances"; "NS_Job A/R A/P BalancesFactBox")
            {
                ApplicationArea = All;
                Caption = 'Job A/R A/P Balances';
                SubPageLink = "No." = FIELD("No.");
            }
            //-->HK Start
            part(NS_Control1903710908; "Power BI Report FactBox")
            {
                ApplicationArea = All;
            }
            //<-- HK End
        }
    }
    actions
    {
        modify("&Prices")
        {
            Caption = 'Cost/&Price';
        }

        //PPDA.1.0.TBA Start
        // modify("Job Actual to Budget (Cost)")
        // {
        //     Promoted = false;

        //     Visible = false;

        //     Enabled = FALSE;
        // }
        // modify("Job Actual to Budget (Price)")
        // {
        //     Promoted = false;

        //     Visible = false;

        //     Enabled = FALSE;
        // }
        //PPDA.1.0.TBA End
        modify("Job Analysis")
        {
            Promoted = false;

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
        // modify("Job Cost Suggested Billing")
        // {
        //     Promoted = false;

        //     Visible = false;

        //     Enabled = FALSE;
        // }
        // modify("Customer Jobs (Cost)")
        // {
        //     Visible = false;
        //     Promoted = false;
        //     Enabled = FALSE;
        // }
        // modify("Customer Jobs (Price)")
        // {
        //     Visible = false;
        //     Enabled = FALSE;
        // }
        //PPDA.1.0.TBA End
        modify("Items per Job")
        {
            Visible = false;
            Enabled = FALSE;
        }
        modify("Jobs per Item")
        {
            Visible = false;
            Enabled = FALSE;
        }
        modify("Job WIP to G/L")
        {
            Visible = false;
            Enabled = FALSE;
        }
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
        addafter("Job Task &Lines")
        {
            action("NS_Job Planning Lns (Editable)")
            {
                Caption = 'Job Planning Lines (&Editable)';
                Image = ServiceLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = Page "NS_Job PlanningList(Editable)";//PRJ-325.AS.1.0 16JULY2020 Commented
                // RunPageLink = "Job No." = FIELD("No."); //PRJ-325.AS.1.0 16JULY2020 Commented
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
            action("NS_Subcontracts")
            {
                Caption = 'Su&bcontracts';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //ProjectPro - start
                    JobSubContractList.NS_Set("No.");
                    JobSubContractList.RUNMODAL;
                    CLEAR(JobSubContractList);
                    //ProjectPro - end
                end;
            }
            action("NS_Progress Billings")
            {
                Caption = 'Pro&gress Billings';
                Image = CalculateInvoiceDiscount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Job Progress Billing List";
                RunPageLink = "NS_Job No." = FIELD("No.");
                ApplicationArea = All;
            }
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
            action("NS_Draws")
            {
                Caption = 'Dra&ws';
                Image = DepositSlip;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page NS_Draws;
                RunPageLink = "NS_Job No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("NS_Job Forecast Worksheet")
            {
                Caption = 'Job &Forecast Worksheet';
                Image = Forecast;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                var
                    JobForecastWorksheet: Page "NS_Job Forecast Worksheet";
                    JobForecastWorksheetbySeg: Page "NS_Job Forecast Work by Seg"; //JD-48.AS.2.0
                begin
                    //ProjectPro - start
                    if "NS_Forecast Method" = "NS_Forecast Method"::"Job Forecast by Task Code" then begin  //JD-48.AS.2.0
                        JobForecastWorksheet.NS_Set("No.", '', 0D);
                        JobForecastWorksheet.RUNMODAL;
                        CLEAR(JobForecastWorksheet);
                    end; //JD-48.AS.2.0
                    //ProjectPro - end

                    //JD-48.AS.2.0 - start
                    if "NS_Forecast Method" = "NS_Forecast Method"::"Job Forecast by Segment Code" then begin
                        JobForecastWorksheetbySeg.NS_Set("No.", '', 0D);
                        JobForecastWorksheetbySeg.RUN;
                        Clear(JobForecastWorksheetbySeg);
                    end;
                    //JD-48.AS.2.0 - end
                end;
            }
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
                Enabled = false;
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_APO Links Subform";
                RunPageLink = NS_Type = FILTER(Job),
                              NS_Code = FIELD(UPPERLIMIT("No."));
                RunPageView = SORTING(NS_Type, NS_Code);
                Visible = false;
                ApplicationArea = All;
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
        addafter(History)
        {
            action("NS_Job Journal")
            {
                Image = Journals;
                RunObject = Page "Job Journal";
                ApplicationArea = All;
                Caption = 'Job Journal';
            }
        }
        addafter("<Action9>")
        {
            action("NS_Schedule of Values")
            {
                Image = ValueLedger;
                RunObject = Page "NS_Job Quote Scope of Work";
                ApplicationArea = All;
                Caption = 'Schedule of Values';//PRJ-659.RS.1.0�22June21 New Added
            }
            group(NS_Display)
            {
                Caption = 'Display';
            }
        }
        addafter("NS_Schedule of Values")
        {
            group("NS_Actual vs Budget")
            {
                Caption = 'Actual vs Budget';
                action("NS_Act vs Bud Cost by Task")
                {
                    Caption = 'Act vs Bud Cost by Task';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_ActualvsBudget Cost by APO";
                    ApplicationArea = all;
                }
                action("NS_Act vs Bud Cost by Task with Qty")
                {
                    Caption = 'Act vs Bud Cost by Task with Qty';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                    ApplicationArea = All;
                }
                action("NS_Act vs. Bud Cost Work Units by Task")
                {
                    Caption = 'Act vs. Bud Cost Work Units by Task';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_ActualvsBudget C/WU by APO";
                    ApplicationArea = All;
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
                action(NS_Action1100773036)
                {
                    Caption = 'Pct of Completion';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Percentage of Completion";
                    ApplicationArea = All;
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
                    Caption = 'Pct of Completion by Dim';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Pct of Completion by Dim";
                    ApplicationArea = All;
                }
                action("NS_Pct of Completion with GM")
                {
                    Caption = 'Pct of Completion with GM';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_POC Gross Margin";
                    ApplicationArea = All;
                }
            }
            group("NS_Job Mat/Labor Analysis")
            {
                Caption = 'Job Mat/Labor Analysis';
                // action("NS_Act vs Bud Material by Task")//PRJ-813.AS.1.0 Action commented as report not needed anymore
                // {
                //     Caption = 'Act vs Bud Material by Task';
                //     Image = "Report";
                //     Promoted = true;
                //     PromotedCategory = Report;
                //     RunObject = Report "NS_ActualvsBudget Mat by APO";
                //     ApplicationArea = All;
                // }
                action("NS_Act vs Bud Qty by Task")
                {
                    Caption = 'Act vs Bud Qty by Task';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Actual vs Budget Qty by APO";
                    ApplicationArea = All;
                }

                action("NS_Act vs Bud Job Hours")
                {
                    Caption = 'Act vs Bud Job Hours';
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = Report "NS_Actual vs Budget Job Hour";
                }
                action("NS_VarianceReport")//PPAL-437.AS.1.0
                {
                    Caption = 'Variance Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Act vs Bud Cost by APOwQty";
                    ApplicationArea = All;
                }
            }
            group("NS_Job Analysis2")
            {
                Caption = 'Job Analysis';
                action("NS_Job Detail by Task")
                {
                    Caption = 'Job Detail by Task';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Report;
                    RunObject = Report "NS_Job Detail by Task";
                    ApplicationArea = All;
                }
                action("NS_Job Gross Profit")
                {
                    Caption = 'Job Gross Profit';
                    Image = Report;
                    RunObject = Report "NS_Jobs Gross Profit";
                    ApplicationArea = All;
                }
                action("NS_Committed Cost Detail")
                {
                    Caption = 'Committed Cost Detail';
                    Image = Report;
                    Promoted = false;
                    RunObject = Report "NS_Committed Cost DetailReport";
                    ApplicationArea = All;
                }
            }
        }
        addafter(History)
        {
            action("NS_Create Sales Invoice")
            {
                Image = Invoice;
                ApplicationArea = All;
                Caption = 'Create Sales Invoice';//PRJ-659.RS.1.0�22June21 New Added

                trigger OnAction();
                var
                    lSalesInvoice: Page "Sales Invoice";
                    lSalesHeader: Record "Sales Header";
                    lJob: Record Job;
                begin
                    CurrPage.SETSELECTIONFILTER(lJob);
                    if lJob.FINDFIRST then begin
                        lSalesHeader.INIT;
                        lSalesHeader.VALIDATE("Document Type", lSalesHeader."Document Type"::Invoice);
                        lSalesHeader.VALIDATE("No.", '');
                        lSalesHeader.VALIDATE("Sell-to Customer No.", lJob."Bill-to Customer No.");
                        lSalesHeader.VALIDATE("NS_Job No.", lJob."No.");
                        if lSalesHeader.INSERT then begin
                            lSalesInvoice.SETRECORD(lSalesHeader);
                            lSalesInvoice.RUN;
                        end else
                            MESSAGE('Unable to create Sales Invoice');
                    end;
                end;
            }
        }
    }

    var
        PowerBIUserConfiguration: Record "Power BI User Configuration";
        SetPowerBIUserConfig: Codeunit "Set Power BI User Config";
        PowerBIVisible: Boolean;
        JobSimplificationAvailable: Boolean;
        JobSubContractList: Page "NS_Job Subcontract List";
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        Contact: Record Contact;
        JobClass: Option " ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template;
        JobType: Code[20];

    procedure InitVar(lJobClass: Option " ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template; lJobType: Code[20]);
    begin
        JobClass := lJobClass;
        JobType := lJobType;
    end;

    /* Documentation 
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +       PP Job Class
      +       PP Budgeted Cost (LCY)
      +       PP Budgeted Price (LCY)
      +       PP Global Dimension 1 Code
      +       PP Global Dimension 2 Code
      +
      +  - Added function(s):
      +       InitVar
      +
      +  - Added global variable(s):
      +      JobSubContractList
      +      ActualCostToDate - ARRAY [3]
      +      InvoiceBilled - ARRAY [3]
      +      PaymentReceived - ARRAY [3]
      +      CommittedCost
      +      Contact
      +      JobClass
      +      JobType
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added action list:
      +         PPJob Planning Lns (Editable)
      +         PP Subcontracts
      +         PP Progress Billings
      +         PP CustomReports
      +         PP Draws
      +         PP Job Forecast Worksheet
      +         PP Links
      +         PP APO Links
      +         PP Job Contacts
      +         Job Journal
      +         Schedule of Values
      +         Reports - Container
      +           Actual vs Budget - Group
      +             Act vs Bud Cost by Task
      +             Act vs Bud Cost by Task with Qty
      +             Act vs. Bud Cost Work Units by Task
      +           Pct of Completion - Group
      +             Pct of Completion
      +             Pct of Completion by Dim
      +             Pct of Completion with GM
      +           Job Mat/Labor Analysis - Group
      +             Act vs Bud Material by Task
      +             Act vs Bud Qty by Task
      +             Act vs Bud Job Hours
      +           Job Analysis - Group
      +             Job Detail by Task
      +             Job Gross Profit
      +             Committed Cost Detail
      +           Financial Management - Group
      +             Create Sales Invoice
      +     - Modify action list:
      +         Prices - Changed caption to Cost/Price
      +         Disable actions and unpromote the following
      +           Reports - Container
      +             Job Analysis - Group
      +               Job Actual to Budget (Cost)
      +               Job Actual to Budget (Price)
      +               Job Analysis
      +               Job - Planning Lines
      +               Job Cost Suggested Billing
      +               Customer Jobs (Cost)
      +               Customer Jobs (Price)
      +               Jobs per Item
      +             Financial Management - Group
      +               Job WIP to G/L
      +     - Modified controls:
      +         Job Details - Diabled
      +     - Added Factboxes
      +         genericchartjob
      +         PP Job A/R A/P Balances
      +
      + -SMP
      +  -Added Visability to controls NO.
      +   -1905767507
      +   -1905650007
      +-----------------------------------------------------------------------------------------------
    */

}

