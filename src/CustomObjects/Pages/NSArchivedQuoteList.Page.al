page 14021444 "NS_Archived Quote List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PPAL-81.AS.1.0 swap the order of quote no. and template for open card on web client
    // +------------------------------------------------------------

    Caption = 'Archived Quote List';
    CardPageID = "NS_Archived Job Quote";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Supplemental,Tasks,Team,Workflow,Filters';
    SourceTable = "NS_Job Quote Header Archive";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Quote No."; Rec."NS_Quote No.")//PPAL-81.AS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quote No.';
                }
                field(Template; Rec.NS_Template)//PPAL-81.AS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Template';
                }
                field("Description/Nickname"; Rec."NS_Description/Nickname")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description/Nickname';
                }
                field("Quote Type Code"; Rec."NS_Quote Type Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Quote Type Code';
                    Visible = false;
                }
                field("Proposal Date"; Rec."NS_Proposal Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Proposal Date';
                }
                field("Accepted at Date"; Rec."NS_Accepted at Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Accepted at Date';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Link-to Quote No."; Rec."NS_Link-to Quote No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Link-to Quote No.';
                    Visible = false;
                }
                field(Revision; Rec.NS_Revision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revision';
                }
                field("Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sell-to Customer No.';
                }
                field("Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sell-to Customer Name';
                }
                field("Salesperson Code"; Rec."NS_Salesperson Code New")//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Code';
                }
                field("Salesperson Name"; Rec."NS_Salesperson Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Name';
                }
                field("Contact No."; Rec."NS_Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contact No.';
                }
                field("Contact Name"; Rec."NS_Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contact Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Description"; Rec."NS_Job Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Description';
                }
                field("Job Type"; Rec."NS_Job Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Type';
                }
                field("Sales Quote No."; Rec."NS_Sales Quote No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Sales Quote No.';
                    Visible = false;
                }
                field("Probability to Close"; Rec."NS_Probability to Close")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Probability to Close';
                    Visible = false;
                }
                field("Estimator No."; Rec."NS_Estimator No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimator No.';
                }
                field("Estimator Name"; Rec."NS_Estimator Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimator Name';
                }
                field("Total Contract Price"; Rec."NS_Total Contract Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Price';
                }
                field("Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 2 Code';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

