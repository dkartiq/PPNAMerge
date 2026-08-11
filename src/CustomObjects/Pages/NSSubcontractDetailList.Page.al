page 14021310 "NS_Subcontract Detail List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-274 VT1.0 21-05-20 Code Added
    Caption = 'Subcontract Detail List';
    CardPageID = "NS_Subcontract Detail List";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "NS_Subcontract Lines";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Unit Cost';
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                //PRJ-274 VT1.0 21-05-20 begin
                field("PO No."; Rec."NS_PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO No.';
                }
                field("PO Line No."; Rec."NS_PO Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Line No.';
                }
                //PRJ-274 VT1.0 21-05-20 end
            }
        }
    }

    actions
    {
    }
}

