/// <summary>
/// Page Daily PO Subform (ID 14021463).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New page create
/// //PE-168.HS.1.0 10Nov2023| Removed Doc job no. and Entry Date field 
// / //PE-168.HS.1.0 17Nov2023 | Add Caption

Page 14021463 "NS_Daily PO Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    // Caption = 'Vendor/ Subcontract'; //PE-168.HS.1.0 17Nov2023 Commented
    Caption = 'Vendor/Subcontractor'; //PE-168.HS.1.0 17Nov2023
    SourceTable = "NS_Daily JOb Log Sub.";
    SourceTableView = sorting("Document Type", "Documnet No.", "Line No.") WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Type field.';
                }
                field("PO/Sub Con. No."; Rec."PO/Sub Con. No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO/Sub Con. No. field.';
                }

                field("Vednor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vednor No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remark field.';
                    Caption = 'Comment';  //PE-168.HS.1.0 16Nov2023
                }
                field("Remark 2"; Rec."Remark 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remark 2 field.';
                    Caption = 'Comment 2';  //PE-168.HS.1.0 16Nov2023
                }

            }
        }
    }
}