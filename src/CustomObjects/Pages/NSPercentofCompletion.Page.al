page 14021458 "NS_Percentage of Completion"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-94.ms.1.0 Create new page 
    //CTSI-94.AS.1.0 10AUG2020 Added fields Recognized Profit, Recognized Profit %, Also changed caption 
    // +------------------------------------------------------------
    //CTSI-115.AS.1.0 : done uneditable property on page
    //PRJ-830.GK.1.0 06Sep2021 |Remove two fields & add caption of two fields at page level.
    //PRJ-1098.NK.0.0 11Feb2022 |Add Two Fields
    //PRJ-1387.NK.1.0 12May2022 | Add One Field
    Caption = 'ProjectPro Summary Details';//CTSI-94.AS.1.0 10AUG2020
    PageType = List;
    //Editable = false;//CTSI-115.AS.1.0 //PRJ-585.AS.1.0 16MARCH2021 Comment //PRJ-1573.AS.1.0 09SEPT2022
    SourceTable = "NS_Percentage of Completion";//PRJ-1573.AS.1.0 09SEPT2022
    UsageCategory = Administration;//PRJ-585.AS.1.0 16MARCH2021//PRJ-1573.AS.1.0 09SEPT2022
    ApplicationArea = all;//PRJ-585.AS.1.0 16MARCH2021

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PP_Entry No"; Rec."NS_Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry No';
                    Editable = false;
                }
                field("PP_Posting Date"; Rec."NS_Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Posting Date';
                }
                field("PP_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field(PP_TotalForecastCompletedCost; Rec.NS_TotalForecastCompletedCost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Forecast Completed Cost';
                }
                field("PP_Total Budgeted Costs"; Rec."NS_Total Budgeted Costs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Budgeted Costs';
                }
                field("PP_Total Forecasted Variance"; Rec."NS_Total Forecasted Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Forecasted Variance';
                }
                field("PP_Total Contract Revenue"; Rec."NS_Total Contract Revenue")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Revenue';
                }
                field("PP_Total Cost to Date"; Rec."NS_Total Cost to Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost to Date';
                }
                field("PP_Total Budget Remaining"; Rec."NS_Total Budget Remaining")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Budget Remaining';
                }
                field("PP_Forecasted Cost Remaining"; "NS_Forecasted Cost Remaining")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Forecasted Cost Remaining';
                }
                field("PP_Net Cost Variance"; Rec."NS_Net Cost Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Net Cost Variance';
                }
                field("PP_Job Percent Complet"; Rec."NS_Job Percent Complete")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Percent Complete';
                }
                field("PP_Revenue Earned"; Rec."NS_Revenue Earned")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Earned';
                }
                field("PP_Gross Margin"; Rec."NS_Gross Margin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Margin';
                    Caption = 'Recognized Profit';//PRJ-830.GK.1.0 06Sep2021
                }
                field("PP_Gross Margin Percent"; Rec."NS_Gross Margin Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Margin Percent';
                    Caption = 'Recognized Profit %';//PRJ-830.GK.1.0 06Sep2021
                }
                //PRJ-1098.NK.0.0 11Feb2022 Start
                field(NS_EntryFromBatchJob; Rec.NS_EntryFromBatchJob)
                {
                    ApplicationArea = all;
                    ToolTip = 'Entry From Batch Job';
                    Caption = 'Entry From Batch Job';
                }
                field(NS_JFWBatchDocumentNo; Rec.NS_JFWBatchDocumentNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'JFW Batch Document No.';
                    Caption = 'JFW Batch Document No.';
                }
                //PRJ-1098.NK.0.0 11Feb2022 End

                //PRJ-830.GK.1.0 06Sep2021 start
                // field("PP_Recognized Profit"; Rec."NS_Recognized Profit")//CTSI-94.AS.1.0 10AUG2020
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Recognized Profit';
                // }
                // field("PP_Recognized Profit Percent"; Rec."NS_Recognized Profit Percent")//CTSI-94.AS.1.0 10AUG2020
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Recognized Profit Percent';
                // }
                //PRJ-830.GK.1.0 06Sep2021 end
                //PRJ-1387.NK.1.0 12May2022 Start
                field(NS_Void; Rec.NS_Void)
                {
                    ApplicationArea = all;
                    ToolTip = 'Void';
                    Description = 'PRJ-1387';
                }
                //PRJ-1387.NK.1.0 12May2022 End
            }
        }
    }

    actions
    {
    }

    //PRJ-585.AS.1.0 16MARCH2021 - start //PRJ-1573.AS.1.0 09SEPT2022
    trigger OnOpenPage()
    var
        Usersetup: Record "User Setup";
    begin
        if Usersetup.Get(UserId) then;
        if Usersetup."NS_Modify Project Summary Details" = true then begin
            PageEditableSummDetails := true;
            CurrPage.Editable := true;
        end;

        if Usersetup."NS_Modify Project Summary Details" = false then begin
            PageEditableSummDetails := false;
            CurrPage.Editable := false;
        end;
    end;

    var
        PageEditableSummDetails: Boolean;
    //PRJ-585.AS.1.0 16MARCH2021 - end    //PRJ-1573.AS.1.0 09SEPT2022
}

