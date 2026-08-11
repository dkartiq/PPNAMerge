page 14021201 "NS_Job Cost Categories"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    // JD-29.NS.1.0 11aug2020 Change the page type from card to list & add new property

    Caption = 'Job Cost Categories';
    //PageType= Card;//JD-29.NS.1.0 1
    PageType = List;// JD-29.NS.1.0 11aug2020 Change the page type from card to list
    SourceTable = "NS_Job Cost Category";
    UsageCategory = Administration;
    ApplicationArea = all;
    RefreshOnActivate = true;// JD-29.NS.1.0 11aug2020 

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the Type';
                }
                field("G/L Account No."; Rec."NS_G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L Account No.';
                    Visible = false;
                }
                field("Activity Code"; Rec."NS_Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Activity Code';
                }
                field("Bal. Account No."; Rec."NS_Bal. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bal. Account No.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

