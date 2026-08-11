pageextension 14021197 NS_CreateInteraction extends "Create Interaction"
{
    //PE-6.NK.1.0 28Feb2023 New Created
    layout
    {
        addafter("Opportunity Description")
        {
            field("NS_Job Quote No."; Rec."NS_Job Quote No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Quote No. field.';
            }

            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job No. field.';
            }

            field("NS_Job Task No."; Rec."NS_Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Task No. field.';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Subcontract No. field.';
            }
            field("NS_Progess Billing No."; Rec."NS_Progess Billing No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Progess Billing No. field.';
            }

        }

    }
}