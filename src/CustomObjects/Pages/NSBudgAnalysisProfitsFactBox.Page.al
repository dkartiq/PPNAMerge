page 14021358 "NS_BudgAnalysisProfitsFactBox"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PPAL-12.AM.1.0 - 2JUNE2020 - Changed the property of page
    //PPAL-119.AS.1.0 27AUG20 Bold some captions
    //PRJ-340.SK.1.0 - 12AUG2020 - Addedd condition for skipping calculation of fields on new record.
    //PE-75.RM.1.0 17May2023 | Added tootlips

    Caption = 'Budget Analysis/Profits';
    //PageType=CardPart;//PPAL-12.AM Commented
    PageType = ListPart;//PPAL-12.Am Added
    SourceTable = Job;

    layout
    {
        area(content)
        {
            fixed(Control1900723401)
            {
                Caption = '';
                group(PROJECTPRO)
                {
                    Caption = 'PROJECTPRO';
                    field("FORMAT('Budget Remaining')"; FORMAT('Budget Remaining'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        // ToolTip = 'Budget Remaining'; //PE-75.RM.1.0 17May2023  commented
                        ToolTip = 'Specifies the Estimated Budget Remaining, Projected Bugdet Remaining and Variance Budget Remaining of the Job.'; //PE-75.RM.1.0 17May2023 
                        Caption = '';
                    }
                    field("FORMAT('Budget Rem%')"; FORMAT('Budget Rem%'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Budget Remaining Percent';
                        Caption = '';
                    }
                    field("FORMAT('Profit')"; FORMAT('Profit'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Profit';
                        Caption = '';
                    }

                    //PPAL-119.SK.1.0 Comment start
                    // field("FORMAT(' ')"; FORMAT(' '))
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    //     Caption = '';
                    // }
                    //PPAL-119.SK.1.0 Comment End

                    //PPAL-119.SK.1.0 Start
                    field("FORMAT('Budget/Actual')"; FORMAT('Budget/Actual'))//PPAL-119.AS.1.0 04Sept20
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Style = Strong;//PPAL-119.AS.1.0 27AUG20
                        Caption = '';
                    }
                    //PPAL-119.SK.1.0 End
                    field("FORMAT('Labor Hours')"; FORMAT('Labor Hours'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Labor Hours';
                        Caption = '';
                    }
                    field("FORMAT('Estd. Units')"; FORMAT('Estd. Units'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Estd. Units';
                        Caption = '';
                    }
                    field("FORMAT('Unit Rates')"; FORMAT('Unit Rates'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Unit Rates';
                        Caption = '';
                    }
                }
                group(Estimated)
                {
                    Caption = 'Estimated';
                    field("FORMAT(CalcValues[1,3],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 3], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Budget Remaining';
                        ToolTip = 'Specifies the Estimated Budget Remaining, Projected Bugdet Remaining and Variance Budget Remaining of the Job.';  //PE-75.RM.1.0 17May2023
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,4]*100,14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(CalcValues[1, 4] * 100, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>') + '%')
                    {
                        ApplicationArea = All;
                        Caption = 'Budget Rem %';
                        ToolTip = 'Specifies the Estimated Budget Remaining %, Projected Bugdet Remaining % and Variance Budget Remaining % of the Job.';  //PE-75.RM.1.0 17May2023
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,5],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 5], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Profit';
                        ToolTip = 'Specifies the Estimated Profit, Projected Profit and Variance Profit of the Job.';  //PE-75.RM.1.0 17May2023
                        Editable = false;
                    }
                    //PPAL-119.SK.1.0 Commented Start
                    // field("' '"; '')
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    // }
                    //PPAL-119.SK.1.0 Commented End

                    //PPAL-119.SK.1.0 Start
                    field("'Budgeted'"; ' Budgeted')//PPAL-119.AS.1.0 04Sept20
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Specifies the Values from the Planning Lines where the Line Type is Budgeted';  //PE-75.RM.1.0 17May2023
                        Style = Strong;//PPAL-119.AS.1.0 27AUG20
                    }
                    //PPAL-119.SK.1.0 End
                    field("FORMAT(CalcValues[6,1],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[6, 1], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Labor Hours';
                        ToolTip = 'Specifies the Total number of Hours from the Job Planning Lines where the Type is Resource (only Person) whose Unit of Measure is HR or HOUR. ';  //PE-75.RM.1.0 17May2023
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,7],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 7], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Estimated Units';
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,8],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 8], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Units/Rate';
                        Editable = false;
                    }
                }
                group("        Projected")
                {
                    Caption = '        Projected';
                    field("FORMAT(CalcValues[1,13],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 13], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,14]*100,14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT(CalcValues[1, 14] * 100, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>') + '%')
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[2,7],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[2, 7], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    //PPAL-119.Sk.1.0 Comment Start
                    // field(Control1100773005; '')
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    // }
                    //PPAL-119.SK.1.0 Comment End

                    //PPAL-119.Sk.1.0 Start
                    field("Actual"; '        Actual')//PPAL-119.AS.1.0 02SeptG20
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        Style = Strong;//PPAL-119.AS.1.0 27AUG20
                    }
                    //PPAL-119.Sk.1.0 End
                    field("FORMAT(CalcValues[6,2],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[6, 2], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[2,9],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[2, 9], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,18],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 18], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group("       Variance")
                {
                    Caption = '       Variance';
                    field("FORMAT(CalcValues[1,13] - CalcValues[1,3],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 13] - CalcValues[1, 3], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT((CalcValues[1,14]-CalcValues[1,4])*100,14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')+'%'"; FORMAT((CalcValues[1, 14] - CalcValues[1, 4]) * 100, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>') + '%')
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[2,7] - CalcValues[1,5],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[2, 7] - CalcValues[1, 5], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    //PPAL-119.Sk.1.0 Comment Start
                    // field(Control1100773006; ' ')
                    // {
                    //     ApplicationArea = All;
                    //     Editable = false;
                    // }
                    //PPAL-119.Sk.1.0 Comment End

                    //PPAL-119.Sk.1.0 Start
                    field("Remaining"; '        Remaining')//PPAL-119.AS.1.0 27AUG20
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = '';
                        ToolTip = 'Specifies the difference between Budgeted Value and Actual Value.';  //PE-75.RM.1.0 17May2023
                        Style = Strong;//PPAL-119.AS.1.0 27AUG20
                    }
                    //PPAL-119.Sk.1.0 End
                    field("FORMAT(CalcValues[6,1] - CalcValues[6,2],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[6, 1] - CalcValues[6, 2], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("FORMAT(CalcValues[1,7] - CalcValues[2,9],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 7] - CalcValues[2, 9], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("FORMAT(CalcValues[1,18] - CalcValues[1,8],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CalcValues[1, 18] - CalcValues[1, 8], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NS_OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_OnAfterGetCurrRecord;
    end;

    var
        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        CalcValues: array[8, 40] of Decimal;
        "Sub-LevelsCost": Decimal;
        "Sub-LevelsPrice": Decimal;

    procedure CalcStatistics();
    begin
        //PRJ-340.SK.1.0 Start
        IF "No." = '' then
            Exit;
        //PRJ-340.SK.1.0 End
        NS_CalculateJobFinancials(Rec, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, true);

        //Calculate Common Values
        CLEAR("Sub-LevelsCost");
        CLEAR("Sub-LevelsPrice");
        "Sub-LevelsCost" := NS_SLsBudgetedLaborHours(Rec);
        "Sub-LevelsPrice" := "SLsUsage(Price)"(Rec);

        NS_CalculateJobStatistics(Rec, ActualCostToDate, InvoiceBilled, "Sub-LevelsCost", "Sub-LevelsPrice", CommittedCost, true, CalcValues);
    end;

    local procedure NS_OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        CalcStatistics;
    end;

    //SMPL - Renamed OnAfterGetCurrRecord to PP_OnAfterGetCurrRecord
}

