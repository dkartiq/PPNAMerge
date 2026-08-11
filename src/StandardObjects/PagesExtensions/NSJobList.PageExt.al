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
    //PRJ-1299.JS.1.0 25APR2022 | Add toolTip
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1710.RM.1.0 23Nov2022 | Added a tooltip
    //PRJ-1711.RP.1.0 24Nov2022 | Added a tooltip
    //PE-149.RM.1.0 21Aug2023 | Added a field
    //PE-210.HS.1.0 23Nov2023| Add Code
    //PE-210.HS.1.0 7Dec2023 | Block Code for color change on % completed field
    //PE-311.PP.1.0 11JUN2024 | Added the action for newly created Work order report.
    Caption = 'Jobs'; //PRJ-1330.NK.1.0 25Apr2022
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
        //PE-47.PS.1.0 01March2023 Start
        addafter("Bill-to Customer No.")
        {
            field("NS_Open Job Backlog New"; Rec."NS_Open Job Backlog")
            {
                ApplicationArea = all;
                Caption = 'Open Job Backlog';

                //PRJCTPR-122.PS.1.0 19Jun2023 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Because of already added this filed on same page';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                Visible = false; //PRJCTPR-163.PS.1.0 19Jul2023
                //PRJCTPR-122.PS.1.0 19Jun2023 End

            }

            field("NS_Billable/Invoiced Difference"; '')
            {
                ApplicationArea = all;
                Caption = 'Billable/Invoiced Difference';
                //PRJCTPR-122.PS.1.0 19Jun2023 Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Because of length  the table field name NS_Billable/Invoiced Difference  must not exceed 30 characters.';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                Visible = false; //PRJCTPR-163.PS.1.0 19Jul2023
                //PRJCTPR-122.PS.1.0 19Jun2023 End
            }


            field("NS_New Billable/Inv Dif"; Rec."NS_New Billable/Inv Dif")  //PRJCTPR-122.PS.1.0 14Jun2023
            {
                ApplicationArea = all;
                Caption = 'Billable/Invoiced Difference';
                ToolTip = 'Specifies the difference between the "Total Invoiced Price" and the "Total Contract Price" including Master & the Sub Levels Jobs'; //PRJCTPR-163.PS.1.0 19Jul2023//PE-173.PS.1.0 18Oct2023

            }
        }
        //PE-47.PS.1.0 01March2023 End

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
            //PE-193.PS.1.0 03Nov2023 Start
            field("NS_Change Request to Job No."; Rec."NS_Change Request to Job No.")
            {
                ApplicationArea = all;
            }
            //PE-193.PS.1.0 03Nov2023 End 
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
            //PE-67.Dk.1.0 5May2023 Start
            field("NS_Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Usage (Cost) (LCY)';
                StyleExpr = NS_Color;//PE-210.HS.1.0 23Nov2023
            }
            field("NS_Invoiced Price (LCY)"; Rec."NS_Invoiced Price (LCY)")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Invoiced Price (LCY)';
                StyleExpr = NS_InvColor; //PE-210.HS.1.0 23Nov2023 
            }
            //PE-67.Dk.1.0 5May2023 End 
            //PE-149.RM.1.0 28Aug2023 start
            field("NS_Act Invd Less Act Cost"; Rec.NS_ActInvdLessActCost)
            {
                Caption = 'Actual Invoiced Less Actual Cost (Margin)';
                ApplicationArea = all;
                ToolTip = 'To calculate the values under this column, click on "Calculate Margin" option available under Actions and then Functions.';
            }
            //PE-149.RM.1.0 28Aug2023 end
            //PE-193.PS.1.0 16OCt2023 Start
            field("NS_Margin %"; Rec."NS_Margin %")
            {
                Caption = 'Margin %';
                ApplicationArea = all;
                ToolTip = 'Specifies Margin % based on Actual invoiced less Actual Cost. To calculate the values under this column, click on "Calculate Margin" option available under Actions and then Functions.';//PE-193.PS.1.0 08Dec2023
            }
            //PE-193.PS.1.0 16OCt2023 End 

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
                ToolTip = 'Specifies the last Forecast Posted Date';   //PRJ-1299.JS.1.0 25APR2022
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
            //PE-267.JS.1.0 05MAR2024 - Start below control is removed by Base BC in Version 2024
            //part(NS_Control1903710908; "Power BI Report FactBox")
            part(NS_Control1903710908; "Power BI Embedded Report Part")
            {
                ApplicationArea = All;
            }
            //PE-267.JS.1.0 05MAR2024
            //<-- HK End



        }
        //PRJ-1262.GK.1.0 03June2022 start
        addafter("NS_Last Forecast Posted Date")
        {
            field("NS_Open Job Backlog"; Rec."NS_Open Job Backlog")
            {
                Caption = 'Open Job Backlog';
                //ToolTip = 'Open Job Backlog specifies the value which is the difference between the “Total Contract Price including Master & Sub Levels Jobs” minus “Total Invoiced Price including Master & the Sub Levels Jobs”. Open Job Backlog Batch can be run from the Job card & on the ProjectPro Manager Role Center. Note: Open Job Backlog calculation includes Jobs only with status “Open or Planning”, in addition to this “Manager Job Status” should be "Planning".'; //PRJ-1710.RM.1.0  //PRJ-1711.RP.1.0 01Dec2022 commented
                //ToolTip = 'Open Job backlog Specifies the Value which is the difference between the "Total Contract Price including Master & Sub Levels Jobs" minus "Total Invoiced Price including Master & the Sub Levels Jobs". Open Job Backlog Batch can be run from the Job card & on the ProjectPro Manager Role Center. Note: Open Job Backlog calculation includes Jobs only with status "Open or Planning", in addition to this "Manager Job Status" should be "Running."';//PRJ-1711.RP.1.0 01Dec2022 //PRJ-1710.RM.1.0 06dec //PRJCTPR-122.PS.1.0 20Jun2023 //PRJCTPR-163.PS.1.0 20Jul2023
                // ToolTip = 'Specifies the difference between the "Total Contract Price” and the "Total Invoiced Price” including Master & the Sub Levels Jobs. The value under this field will get updated only when the “Open Job Backlog Batch” is run. Note: Open Job Backlog calculation includes Jobs only with the status "Open” or “Planning", and in addition to this the "Manager Job Status" should also be set to "Planning."'; //PRJCTPR-163.PS.1.0 20Jul2023 //PE-173.PS.1.0 09Oct2023 Commented
                ToolTip = 'Specifies the job backlog value calculated when "Open Job Backlog Batch" was run last time. It shows the difference between the "Total Contract Price” and the "Total Invoiced Price" including Master & the Sub-Level Jobs based on the Jobs Setup.Note: The calculation occurs only for the Jobs with Status set to "Open" or "Planning", and the "Manager Job Status" set to "Running."'; //PE-173.PS.1.0 09Oct2023
                Editable = false;
                ApplicationArea = all;
            }
            //PRJCTPR-39.JS.1.0 23JAN2023 - Start
            field("NS_Contract Date"; Rec."NS_Contract Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Contract Date of the Job';
                Caption = 'Contract Date';
            }
            //PRJCTPR-39.JS.1.0 23JAN2023 - ends
        }
        //PRJ-1262.GK.1.0 03June2022 end

    }
    actions
    {

        //PRJ-1616.AS.1.0 29SEPT2022 start
        modify(CopyJob)
        {
            Promoted = false;
        }
        //PRJ-1616.AS.1.0 29SEPT2022 end
        //PE-149.RM.1.0 28Aug2023 start
        addafter(CopyJob)
        {
            action(NS_ActIvdLessActCost)
            {
                ApplicationArea = all;
                image = Calculate;
                Caption = 'Calculate Margin';
                ToolTip = 'This function will calculate the value under "Actual Invoiced Less Actual Cost (Margin)" column for each Job on the Job list page.';
                trigger OnAction()
                var
                    NS_ActReport: Report NS_ActInvdLessActCostMargin;
                begin
                    NS_ActReport.RunModal();
                    CurrPage.Update();
                end;
            }
        }
        //PE-149.RM.1.0 28Aug2023

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
        //PRJCTPR-122.AT.1.0.0 27June23 Start
        addafter("Co&mments")
        {
            action(NS_ImportFromExcel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import from Excel';
                Image = ImportExcel;
                ToolTip = 'Import the Jobs data in excel format.';
                trigger OnAction()
                var
                    ImportPoDate: XmlPort "NS_JobImport XML";
                begin

                    ImportPoDate.Run();
                    CurrPage.UPDATE();
                end;

            }
            action(Ns_ExportData)
            {
                Caption = 'Export To Excel';
                ApplicationArea = All;
                Image = ExportToExcel;
                ToolTip = 'Export the jobs data in excel format';
                trigger OnAction()
                var
                    ImportPoDate: XmlPort "NS_JobsExport XML";
                    TempBlob: Codeunit "Temp Blob";
                    CSVOutStream: OutStream;
                    FileMgt: Codeunit "File Management";
                begin

                    ImportPoDate.SetTableView(Rec);
                    TempBlob.CreateOutStream(CSVOutStream);
                    ImportPoDate.SetDestination(CSVOutStream);
                    ImportPoDate.Export();
                    FileMgt.BLOBExport(TempBlob, 'Jobs.csv', true);
                    CurrPage.UPDATE();
                end;
            }
            //PRJCTPR-122.AT.1.0.0 27June23 End
        }

        //PPAL-80.AS.1.0 31JULY2020 - END

        //PRJ-1616.AS.1.0 29SEPT2022 start
        addbefore("Create Job &Sales Invoice")
        {
            action(NS_CopyJob)
            {
                ApplicationArea = Jobs;
                Caption = '&Copy Job';
                Ellipsis = true;
                Image = CopyFromTask;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Copy a job and its job tasks, planning lines, and prices.';

                trigger OnAction()
                var
                    CopyJob: Page "NS Copy JobList";
                begin
                    CopyJob.SetFromJob(Rec);
                    CopyJob.RunModal;
                end;
            }
        }
        //PRJ-1616.AS.1.0 29SEPT2022 end

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
                //PE-311.PP.1.0 11JUN2024 Start
                action("NS_Work Order Report")
                {
                    ApplicationArea = all;
                    Caption = 'Work Order';
                    ToolTip = 'Specifies the Work Order Report';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = Report;
                    trigger OnAction()
                    var
                        NS_WorkOrder: Report "NS_WorkOrder";
                        NS_JobRec: Record Job;
                    begin
                        NS_JobRec.Reset();
                        NS_JobRec.SetRange("No.", Rec."No.");
                        report.RunModal(14021488, true, false, NS_JobRec);
                    end;

                }
                //PE-311.PP.1.0 11JUN2024 End
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
        //SetPowerBIUserConfig: Codeunit "Set Power BI User Config";   //PE-267.JS.1.0 05MAR2024
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
        NS_Color: Text; //PE-210.HS.1.0 23Nov2023 
        NS_InvColor: Text; //PE-210.HS.1.0 23Nov2023 

    procedure InitVar(lJobClass: Option " ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template; lJobType: Code[20]);
    begin
        JobClass := lJobClass;
        JobType := lJobType;
    end;

    trigger OnAfterGetRecord()
    var
        JobSetup: Record "Jobs Setup";
    begin
        //PE-210.HS.1.0 23Nov2023 Start
        Clear(NS_Color);
        Clear(NS_InvColor);
        if JobSetup.Get() then;
        if JobSetup.NS_CostExceedsColor then begin
            if rec."NS_Budgeted Cost (LCY)" < rec."NS_Usage (Cost) (LCY)" then
                NS_Color := 'Unfavorable'
            else
                NS_Color := 'standardaccent';

            if rec."NS_Budgeted Price (LCY)" < rec."NS_Invoiced Price (LCY)" then
                NS_InvColor := 'Unfavorable'
            else
                NS_InvColor := 'standardaccent';
        end
        //PE-210.HS.1.0 23Nov2023 End
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

