page 14021306 "NS_Subcontract Statistics"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RM.1.0 23Oct2021 | Aligned Caption of columns to right.
    Caption = 'Subcontract Statistics';
    Editable = false;
    PageType = Card;
    SourceTable = Job;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(Budgeted)
            {
                Caption = 'Budgeted';
                fixed(Control1903895201)
                {
                    group(Resources)
                    {
                        Caption = '                                Resources'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobBudgetTotalPrice[1]"; JobBudgetTotalPrice[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Price';

                            ToolTip = 'Total Price';
                        }
                        field("JobBudgetTotalCost[1]"; JobBudgetTotalCost[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';

                            ToolTip = 'Total Cost';
                        }
                        field("JobBudgetProfit[1]"; JobBudgetProfit[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Profit';

                            ToolTip = 'Profit';
                        }
                        field("JobBudgetProfitPct[1]"; JobBudgetProfitPct[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Profit %';

                            ToolTip = 'Profit %';
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Items)
                    {
                        Caption = '                                       Items'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobBudgetTotalPrice[2]"; JobBudgetTotalPrice[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetTotalCost[2]"; JobBudgetTotalCost[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfit[2]"; JobBudgetProfit[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfitPct[2]"; JobBudgetProfitPct[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Miscellaneous)
                    {
                        Caption = '                          Miscellaneous'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobBudgetTotalPrice[3]"; JobBudgetTotalPrice[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetTotalCost[3]"; JobBudgetTotalCost[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfit[3]"; JobBudgetProfit[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfitPct[3]"; JobBudgetProfitPct[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Total)
                    {
                        Caption = '                                        Total'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobBudgetTotalPrice[4]"; JobBudgetTotalPrice[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetTotalCost[4]"; JobBudgetTotalCost[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfit[4]"; JobBudgetProfit[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobBudgetProfitPct[4]"; JobBudgetProfitPct[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                    }
                }
            }
            group(Realized)
            {
                Caption = 'Realized';
                fixed(Control1904230701)
                {
                    group(Control1900724401)
                    {
                        Caption = '                                 Resources'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobInvTotalPrice[1]"; JobInvTotalPrice[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Invoiced Price';
                        }
                        field("JobUsageTotalPrice[1]"; JobUsageTotalPrice[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Price';
                        }
                        field("ExcessInvoicing[1]"; ExcessInvoicing[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Excess Invoicing';
                        }
                        field("ExcessInvPct[1]"; ExcessInvPct[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Excess Inv. %';
                            DecimalPlaces = 1 : 1;
                        }
                        field("JobUsageTotalCost[1]"; JobUsageTotalCost[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Total Cost';
                        }
                        field("JobInvProfit[1]"; JobInvProfit[1])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = 'Profit';
                        }
                        field("JobInvProfitPct[1]"; JobInvProfitPct[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Profit %';
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Control1900724301)
                    {
                        Caption = '                                        Items'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobInvTotalPrice[2]"; JobInvTotalPrice[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobUsageTotalPrice[2]"; JobUsageTotalPrice[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("ExcessInvoicing[2]"; ExcessInvoicing[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("ExcessInvPct[2]"; ExcessInvPct[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                        field("JobUsageTotalCost[2]"; JobUsageTotalCost[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfit[2]"; JobInvProfit[2])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfitPct[2]"; JobInvProfitPct[2])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Control1900724201)
                    {
                        Caption = '                          Miscellaneous';//PRJ-659.RM.1.0 23Oct2021
                        field("JobInvTotalPrice[3]"; JobInvTotalPrice[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobUsageTotalPrice[3]"; JobUsageTotalPrice[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("ExcessInvoicing[3]"; ExcessInvoicing[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("ExcessInvPct[3]"; ExcessInvPct[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                        field("JobUsageTotalCost[3]"; JobUsageTotalCost[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfit[3]"; JobInvProfit[3])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfitPct[3]"; JobInvProfitPct[3])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                    }
                    group(Control1900724101)
                    {
                        Caption = '                                         Total'; //PRJ-659.RM.1.0 23Oct2021
                        field("JobInvTotalPrice[4]"; JobInvTotalPrice[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobUsageTotalPrice[4]"; JobUsageTotalPrice[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("ExcessInvoicing[4]"; ExcessInvoicing[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            Caption = '""';
                        }
                        field("ExcessInvPct[4]"; ExcessInvPct[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
                        field("JobUsageTotalCost[4]"; JobUsageTotalCost[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfit[4]"; JobInvProfit[4])
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                        }
                        field("JobInvProfitPct[4]"; JobInvProfitPct[4])
                        {
                            ApplicationArea = All;
                            DecimalPlaces = 1 : 1;
                        }
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
        CLEARALL;

          //PE-306.JS.1.0 06JUN2024-Start
        //Rec.SETRANGE("NS_Type Filter", Rec."NS_Type Filter"::Ledger); //PRJ-1131.NK.1.0
        //PE-306.JS.1.0 06JUN2024-end
        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        JobBudgetTotalCost[1] := "NS_Budgeted Cost (LCY)";
        JobBudgetTotalPrice[1] := "NS_Budgeted Price (LCY)";

        //PE-306.JS.1.0 06JUN2024-Start
        //Rec.SETRANGE("NS_Type Filter"); //PRJ-1131.NK.1.0
        Rec.SETRANGE("NS_TypeEnumFilter");
        //PE-306.JS.1.0 06JUN2024-end
        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        ContractCost := "NS_Budgeted Cost (LCY)";
        ContractPrice := "NS_Budgeted Price (LCY)";
        JobBudgetTotalPrice[1] := -ContractPrice;
        JobBudgetTotalPrice[2] := -ContractPrice;
        JobBudgetTotalPrice[3] := -ContractPrice;

        for i := 1 to 3 do begin // Resource,Item,Account (G/L)
            //PE-306.JS.1.0 06JUN2024-Start
            //Rec.SETRANGE("NS_Type Filter", i - 1); //PRJ-1131.NK.1.0
            Rec.SETRANGE("NS_TypeEnumFilter", i - 1);
            //PE-306.JS.1.0 06JUN2024-end
            CALCFIELDS(
              "NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)", "NS_Usage (Cost) (LCY)",
              "NS_Usage (Price) (LCY)", "NS_Invoiced Price (LCY)");
            JobBudgetTotalCost[i] := JobBudgetTotalCost[i] + "NS_Budgeted Cost (LCY)";
            JobBudgetTotalCost[4] := JobBudgetTotalCost[4] + JobBudgetTotalCost[i];

            JobBudgetTotalPrice[i] := JobBudgetTotalPrice[i] + "NS_Budgeted Price (LCY)";
            JobBudgetTotalPrice[4] := JobBudgetTotalPrice[4] + JobBudgetTotalPrice[i];

            JobUsageTotalCost[i] := "NS_Usage (Cost) (LCY)";
            JobUsageTotalCost[4] := JobUsageTotalCost[4] + "NS_Usage (Cost) (LCY)";

            JobUsageTotalPrice[i] := "NS_Usage (Price) (LCY)";
            JobUsageTotalPrice[4] := JobUsageTotalPrice[4] + "NS_Usage (Price) (LCY)";

            JobInvTotalPrice[i] := "NS_Invoiced Price (LCY)";
            JobInvTotalPrice[4] := JobInvTotalPrice[4] + "NS_Invoiced Price (LCY)";
        end;

        JobBudgetTotalPrice[4] := JobBudgetTotalPrice[4] + ContractPrice;

        for i := 1 to 4 do begin
            JobBudgetProfit[i] := JobBudgetTotalPrice[i] - JobBudgetTotalCost[i];
            JobBudgetProfitPct[i] := NS_CalcPercentage(JobBudgetProfit[i], JobBudgetTotalPrice[i]);

            ExcessInvoicing[i] := JobInvTotalPrice[i] - JobUsageTotalPrice[i];
            ExcessInvPct[i] := NS_CalcPercentage(JobInvTotalPrice[i], JobUsageTotalPrice[i]);

            JobInvProfit[i] := JobInvTotalPrice[i] - JobUsageTotalCost[i];
            JobInvProfitPct[i] := NS_CalcPercentage(JobInvProfit[i], JobInvTotalPrice[i]);
        end;

        //PE-306.JS.1.0 06JUN2024-Start
        //Rec.SETRANGE("NS_Type Filter"); //PRJ-1131.NK.1.0
        Rec.SETRANGE("NS_TypeEnumFilter"); //PRJ-1131.NK.1.0
        //PE-306.JS.1.0 06JUN2024-end
    end;

    var
        i: Integer;
        JobBudgetTotalCost: array[4] of Decimal;
        JobBudgetTotalPrice: array[4] of Decimal;
        JobUsageTotalCost: array[4] of Decimal;
        JobUsageTotalPrice: array[4] of Decimal;
        JobInvTotalPrice: array[4] of Decimal;
        ExcessInvoicing: array[4] of Decimal;
        JobBudgetProfit: array[4] of Decimal;
        JobBudgetProfitPct: array[4] of Decimal;
        JobInvProfit: array[4] of Decimal;
        JobInvProfitPct: array[4] of Decimal;
        ExcessInvPct: array[4] of Decimal;
        ContractPrice: Decimal;
        ContractCost: Decimal;

    local procedure NS_CalcPercentage(PartAmount: Decimal; Base: Decimal): Decimal;
    begin
        if Base <> 0 then
            exit(100 * PartAmount / Base)
        else
            exit(0);
    end;
}

