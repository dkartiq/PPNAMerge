page 14021404 "NS_Job Quote Setup"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Setup';
    PageType = Card;
    SourceTable = "Jobs Setup";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Job Quote No. Series"; Rec."NS_Job Quote No. Series")
                {
                    ApplicationArea = All;
                    Caption = 'Job Quote No. Series';
                    ToolTip = 'Specifies the Job Quote No. Series';
                }
                field("Job Attribute No. Series"; Rec."NS_Job Attribute No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Job Attribute No. Series';
                    Caption = 'Job Attribute No. Series';
                }
                field("Sales Quote No. Series"; Rec."NS_Sales Quote No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Quote No. Series';
                    Caption = 'Sales Quote No. Series';
                }
                field("Job Nos."; Rec."Job Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Nos.';
                    Caption = 'Job Nos.';
                }
                field("Resource No. for Contract Line"; Rec."NS_ResourceNo. forContractLine")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource No. for Contract Line';
                    Caption = 'Resource No. for Contract Line';
                }
                field("Resource No. for Install Line"; Rec."NS_ResourceNo. forInstallLine")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource No. for Install Line';
                    Caption = 'Resource No. for Install Line';
                }
                field("Resource No. for Service Line"; Rec."NS_ResourceNo. forServiceLine")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Resource No. for Service Line';
                    Caption = 'Resource No. for Service Line';
                }
                field("Install Category Code"; Rec."NS_Install Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Install Category Code';
                    Caption = 'Install Category Code';
                }
                field("G/L Account No. - Service Line"; Rec."NS_G/L AccountNo.-ServiceLine")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account No. - Service Line';
                    Visible = false;
                    Caption = 'G/L Account No. - Service Line';
                }
                field("Service Line Description"; Rec."NS_Service Line Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Service Line Description';
                    Caption = 'Service Line Description';
                }
                field("Service Category Code"; Rec."NS_Service Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Service Category Code';
                    Caption = 'Service Category Code';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        if not FINDFIRST() then begin
            INIT();
            INSERT();
        end;
    end;
}

