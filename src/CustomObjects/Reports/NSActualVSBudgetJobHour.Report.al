report 14021182 "NS_Actual vs Budget Job Hour"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption = 'RequestPage' can't be used on Area  
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSActual vs Budget Job Hour.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Actual vs Budget Jobs Hour';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;
            column(TIME; TIME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(Sub_LevelsText_; "Sub-LevelsText")
            {
            }
            column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
            {
            }
            column(Variance__; "Variance%")
            {
                DecimalPlaces = 1 : 1;
            }
            column(Variance; Variance)
            {
            }
            column(ActualHours; ActualHours)
            {
            }
            column(BudgetedHours; BudgetedHours)
            {
            }
            column(Job_Description; Description)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job_Job__Description_2_; Job."Description 2")
            {
            }
            column(ActualHours_Control26; ActualHours)
            {
            }
            column(BudgetedHours_Control30; BudgetedHours)
            {
            }
            column(Variance_Control34; Variance)
            {
            }
            column(Variance___Control12; "Variance%")
            {
                DecimalPlaces = 1 : 1;
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Actual_vs_Budget_Job_HoursCaption; Actual_vs_Budget_Job_HoursCaptionLbl)
            {
            }
            column(Percent_DifferenceCaption; Percent_DifferenceCaptionLbl)
            {
            }
            column(DifferenceCaption; DifferenceCaptionLbl)
            {
            }
            column(Actual_HoursCaption; Actual_HoursCaptionLbl)
            {
            }
            column(Budget_HoursCaption; Budget_HoursCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Job__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Total_JobsCaption; Total_JobsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                BudgetedHours := Job.BudgetedLaborHours(Job);
                ActualHours := Job.ActualLaborHours(Job);

                if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                    BudgetedHours := BudgetedHours + NS_SLsBudgetedLaborHours(Job);
                    ActualHours := ActualHours + SLsUsageLaborHours(Job);
                end;

                Variance := BudgetedHours - ActualHours;
                if BudgetedHours <> 0 then
                    "Variance%" := (Variance / BudgetedHours) * 100
                else
                    "Variance%" := 0;
            end;

            trigger OnPreDataItem();
            begin
                JobHold := Job;
                JobHold.COPYFILTERS(Job);
                "MarkSub-Levels"(Job, "IncludeSub-Levels");
                COPYFILTERS(JobHold);

                CurrReport.CREATETOTALS(BudgetedHours, ActualHours);
                if not "ShowSub-Levels" then
                    SETRANGE("NS_Sub-Level to Job No.", '');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field("Include Sub-Levels"; "IncludeSub-Levels")
                    {
                        ApplicationArea = All;
                    }
                    field("Show Sub-Levels"; "ShowSub-Levels")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;

        if not "ShowSub-Levels" then
            if "IncludeSub-Levels" then
                "Sub-LevelsText" := Text001
            else
                "Sub-LevelsText" := Text002
        else
            "Sub-LevelsText" := Text002;
    end;

    var
        CompanyInformation: Record "Company Information";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        Resource: Record Resource;
        JobHold: Record Job;
        JobFilter: Text[250];
        ActualHours: Decimal;
        BudgetedHours: Decimal;
        Variance: Decimal;
        "Variance%": Decimal;
        TotaltoPrintBudget: Decimal;
        TotaltoPrintActual: Decimal;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        "Sub-LevelsText": Text[50];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Actual_vs_Budget_Job_HoursCaptionLbl: Label 'Actual vs Budget Job Hours';
        Percent_DifferenceCaptionLbl: Label 'Percent Difference';
        DifferenceCaptionLbl: Label 'Difference';
        Actual_HoursCaptionLbl: Label 'Actual Hours';
        Budget_HoursCaptionLbl: Label 'Budget Hours';
        DescriptionCaptionLbl: Label 'Description';
        Total_JobsCaptionLbl: Label 'Total Jobs';
        Text001: Label 'Sub-Levels are included in jobs';
        Text002: Label 'Sub-Levels are not included in jobs';
}

