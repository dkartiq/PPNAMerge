page 14021459 "NS_NSPercentofCompletionList"
{
    //PRJ-1098.NK.0.0 11Feb2022 |New Page Create
    Caption = 'Project Summary Details JFW Batch';
    PageType = List;
    Editable = false;
    SourceTable = "NS_Percentage of Completion";
    UsageCategory = Lists;
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
                field("PP_Forecasted Cost Remaining"; Rec."NS_Forecasted Cost Remaining") //PRJ-1131.NK.1.0
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
                    Caption = 'Recognized Profit';
                }
                field("PP_Gross Margin Percent"; Rec."NS_Gross Margin Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Margin Percent';
                    Caption = 'Recognized Profit %';
                }
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
            }
        }
    }

    actions
    {
    }
}