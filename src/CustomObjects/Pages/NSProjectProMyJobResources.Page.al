page 14021353 "NS_ProjectPro My Job Resources"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro - My Job Resources';
    PageType = ListPart;
    SourceTable = "NS_My Job Resource";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_GetJob;
                    end;
                }
                field("Job.Description"; Job.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                    tooltip = 'Description';
                }
                field(EstdHours; EstdHours)
                {
                    ApplicationArea = All;
                    Caption = 'Estd. Hours';
                    ToolTip = 'Estd. Hours';
                }
                field(ActualHours; ActualHours)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Hours';
                    ToolTip = 'Actual Hours';
                }
                field("Job.""Total Units"""; Job."NS_Total Units")
                {
                    ApplicationArea = All;
                    Caption = 'Estd. Units';
                    ToolTip = 'Estd. Units';
                }
                field("Job.""Actual Units Complete"""; Job."NS_Actual Units Complete")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Units';
                    ToolTip = 'Actual Units';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ToolTip = 'Open';

                trigger OnAction();
                begin
                    NS_OpenJobCard();
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_GetJob();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(Job);
    end;

    trigger OnOpenPage();
    begin
        SETRANGE("NS_User ID", USERID);
    end;

    var
        Job: Record Job;
        JobCalc: Record Job;
        JobCostCategory: Record "NS_Job Cost Category";
        testv: Decimal;
        EstdHours: Decimal;
        ActualHours: Decimal;

    procedure NS_OpenJobCard();
    begin
        if Job.GET("NS_Job No.") then
            PAGE.RUN(PAGE::"Job Card", Job);
    end;

    procedure NS_GetJob();
    begin
        EstdHours := 0;
        ActualHours := 0;
        if not Job.GET("NS_Job No.") then begin
            CLEAR(Job);
            exit;
        end;

        JobCalc.RESET();
        JobCalc := Job;

        //Estimated Hours
        JobCostCategory.RESET();
        if JobCostCategory.FINDSET() then
            repeat
                if JobCostCategory.NS_Type = JobCostCategory.NS_Type::Labor then begin
                    JobCalc.SETFILTER("NS_Cost Category Filter", JobCostCategory.NS_Code);
                    JobCalc.CALCFIELDS("NS_Budgeted Cost Quantity");
                    EstdHours := EstdHours + JobCalc."NS_Budgeted Cost Quantity";
                end;
            until JobCostCategory.NEXT() = 0;

        //Add in Sub-Level Quantities
        JobCostCategory.RESET();
        if JobCostCategory.FINDSET() then
            repeat
                if JobCostCategory.NS_Type = JobCostCategory.NS_Type::Labor then begin
                    JobCalc.SETRANGE("NS_Cost Category Filter", JobCostCategory.NS_Code);
                    EstdHours := EstdHours + JobCalc.SLsBudgetedCostQty(JobCalc);
                end;
            until JobCostCategory.NEXT() = 0;

        //Actual Quantities
        JobCostCategory.RESET();
        if JobCostCategory.FINDSET() then
            repeat
                if JobCostCategory.NS_Type = JobCostCategory.NS_Type::Labor then begin
                    JobCalc.SETFILTER("NS_Cost Category Filter", JobCostCategory.NS_Code);
                    JobCalc.CALCFIELDS("NS_Actual Cost Quantity(Usage)");
                    ActualHours := ActualHours + JobCalc."NS_Actual Cost Quantity(Usage)";
                end;
            until JobCostCategory.NEXT() = 0;

        //Add in Sub-Level Quantities
        JobCostCategory.RESET();
        if JobCostCategory.FINDSET() then
            repeat
                if JobCostCategory.NS_Type = JobCostCategory.NS_Type::Labor then begin
                    JobCalc.SETRANGE("NS_Cost Category Filter", JobCostCategory.NS_Code);
                    ActualHours := ActualHours + JobCalc.SLsActualCostQty(JobCalc);
                end;
            until JobCostCategory.NEXT() = 0;
    end;
}

