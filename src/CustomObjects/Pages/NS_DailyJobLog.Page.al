/// <summary>
/// Page Daily Job Log List (ID 14021399).
/// </summary>
/// Create New Page for Daily Job Log //PE-168.PS.1.0 18Sep2023
page 14021453 "NS_Daily Job Log List"
{
    Editable = false;
    PageType = List;
    CardPageId = "NS_Daily Job Log Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "NS_Daily Job Log";
    Caption = 'Job Daily Log List';
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("NS_No."; Rec."NS_No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                }
                field(NS_Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                }
                field("NS_Log Date"; Rec."NS_Log Date")
                {
                    ApplicationArea = All;
                }
                field("NS_Project Manager Name"; Rec."NS_Project Manager Name")
                {
                    ApplicationArea = All;
                }
                //PE-168.HS.1.0 22Nov2023 Start
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                //PE-168.HS.1.0 22Nov2023 End
            }
        }
    }
}