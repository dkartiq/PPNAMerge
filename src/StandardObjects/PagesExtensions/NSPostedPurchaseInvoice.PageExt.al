pageextension 14021149 NS_PostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-889.GK.1.0 13Sep2021 |Add one field
    //PRJ-1380.NK.1.0 13May2022 | Added Fields
    //PRJ-1418.NK.1.0 08Jun2022 | Added Property
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Posted Purchase Invoice'; //PRJ-1330.NK.1.0 25Apr2022
    //Editable = false; //PRJ-1418.NK.1.0 08Jun2022 Block
    //PRJCTPR-252.HS.1.0 20Dec2023 | Made "NS_Draw No."Uneditable
    layout
    {
        addafter(Corrective)
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job No.';
            }
            //PRJ-1380.NK.1.0 13May2022 Start
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = All;
                ToolTip = 'Job Purchaser';
                Description = 'PRJ-1380.NK.1.0';
                Editable = false; //PRJ-1418.NK.1.0 08Jun2022
            }
            field("NS_Job Manager"; Rec."NS_Job Manager")
            {
                ApplicationArea = All;
                ToolTip = 'Job Manager';
                Description = 'PRJ-1380.NK.1.0';
                Editable = false; //PRJ-1418.NK.1.0 08Jun2022
            }
            //PRJ-1380.NK.1.0 13May2022 End
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies whether this is a Retention Document';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
                Editable = false; //PRJ-1418.NK.1.0 08Jun2022
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
                Editable = false;  //PRJCTPR-252.HS.1.0 20Dec2023
            }
            //PRJ-889.GK.1.0 13Sep2021 start
            field("NS_Progress Payment Enable"; Rec."NS_Progress Payment Enable")
            {
                ToolTip = 'Specifies the value of the Progress Payment Enable field';
                ApplicationArea = All;
            }

            //PRJ-889.GK.1.0 13Sep2021 end
        }
        addafter("Shipping and Payment")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Amount';
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Date';
                }
            }
        }
    }

    //PRJCTPR-294.JS.1.0 18JAN2024 - Start
    actions
    {
        addafter(Vendor)
        {
            action(NSProgressPayment)
            {
                caption = 'Progress Payment';
                tooltip = 'This action button use to view "Progress Payment" list for this invoice. This action may also be used to create a vendor purchase retention invoice.';
                ApplicationArea = Basic, Suite;
                Image = List;

                trigger OnAction()
                Var
                    NSProgressPayment: Record "NS_Progress Payment Header";
                begin
                    if rec."NS_Job No." <> '' then begin
                        NSProgressPayment.Reset();
                        NSProgressPayment.SetRange("NS_Job No.", rec."NS_Job No.");
                        //NSProgressPayment.SetRange("NS_Purchase Order No.", rec."Order No.");
                        NSProgressPayment.SetRange("NS_Subcontract No.", rec."NS_Subcontract No.");

                        PAGE.RunModal(PAGE::"NS_Progress Payment List", NSProgressPayment, rec."Order No.");
                    end;
                end;
            }
        }
    }
    //PRJCTPR-294.JS.1.0 18JAN2024 - end


    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Job No.
    //   +     PP Retention Document
    //   +     PP Subcontract No.
    //   +     PP Draw No.
    //   +     Retention group
    //   +       PP Retention Base Amount
    //   +       PP Retention Percent
    //   +       PP Retention Amount (LCY)
    //   +       PP Retention Amount
    //   +       PP Retention Date
    //   +
    //   +  - Modification(s):
    //   +     - Set page's Editable = No
    //   +-----------------------------------------------------------------------------------------------

}

