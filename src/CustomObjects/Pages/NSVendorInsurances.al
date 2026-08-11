page 14021209 "NS_Vendor Insurances"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-320.AS.1.0 30JUNE2020 Added Vendor No. field on page
    //ZEL-12.RM.1.0 19Apr2023 | Added 2 properties
    Caption = 'Vendor Insurances';
    DataCaptionFields = "NS_Vendor No.";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "NS_Vendor Insurance";
    UsageCategory = Lists; //ZEL-12.RM.1.0 19Apr2023 
    ApplicationArea = All; //ZEL-12.RM.1.0 19Apr2023 

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Insurance Type"; Rec."NS_Insurance Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Insurance Type';
                }
                field("Carrier Name"; Rec."NS_Carrier Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Carrier Name';
                }
                field("Policy No."; Rec."NS_Policy No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Policy No.';
                }
                field(Value; Rec.NS_Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Value';
                }
                field("Expiration Date"; Rec."NS_Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Expiration Date';
                }
                //PRJ-320.AS.1.0 30JUNE2020 - START
                field("Vendor No."; Rec."NS_Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor No.';
                }
                //PRJ-320.AS.1.0 30JUNE2020 - END
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
            }
        }
    }

    actions
    {
    }
}

