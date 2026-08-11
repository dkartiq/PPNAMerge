page 14021378 "NS_PayrollInterfaceJnlTemplate"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    UsageCategory = Lists;//PRJ-542.AM.1.0
    Caption = 'Payroll Interface Jnl Template';
    SourceTable = "NS_PayrollInterfaceJnlTemplate";
    ApplicationArea = all;   //PRJ-1442.JS.1.0 07JUN2022

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.NS_Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Name';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Page ID"; Rec."NS_Page ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Page ID';
                }
                field("Create Entries Report ID"; Rec."NS_Create Entries Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Create Entries Report ID';
                }
                field("Test Report ID"; Rec."NS_Test Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Test Report ID';
                }
                field("Export XMLport ID"; Rec."NS_Export XMLport ID")
                {
                    ApplicationArea = All;
                    Caption = 'Export XMLport ID';
                }
                field("Page Name"; Rec."NS_Page Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Page Name';
                }
                field("Create Entries Report Name"; Rec."NS_Create Entries Report Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Create Entries Report Name';
                }
                field("Test Report Name"; Rec."NS_Test Report Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Test Report Name';
                }
                field("Export XMLport Name"; Rec."NS_Export XMLport Name")
                {
                    ApplicationArea = All;
                    Caption = 'Export XMLport Name';
                    ToolTip = 'Export XMLPort Name';
                }
                field("No. Series"; Rec."NS_No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. Series';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100773012; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1100773013; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = All;
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page "NS_PayrollInterfaceJnlBatches";
                    RunPageLink = "NS_Journal Template Name" = FIELD(NS_Name);
                }
            }
        }
    }
}

