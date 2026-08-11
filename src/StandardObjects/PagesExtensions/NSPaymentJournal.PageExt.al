pageextension 14021237 NS_PaymentJournal extends "Payment Journal"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,NAVMX11.00.00.23572,PPNA11.00
    //PRJ-10.SK.1.0 - Added new action "PP_SuggestVendorPayments" and made standard "SuggestVendorPayments" not visible
    //PRJ-290.MS.1.0 written code for print len report
    //PRJ-290.AS.1.0 09SEPT20 Done Visible false for Print Lien Release report
    //PRJ-669.N.S.1.0 add new field on page
    layout
    {

        addafter("Bal. Account No.")
        {
            //PRJ-669.N.S.1.0 Start
            field("NS_Inv. Discount (LCY)"; Rec."Inv. Discount (LCY)")
            {
                ApplicationArea = All;
                Caption = 'Inv. Discount (LCY)';
                ToolTip = 'Specifies the Invoice Discount';
                Visible = false;
            }
            field("NS_Pmt. Discount Date"; Rec."Pmt. Discount Date")
            {
                ApplicationArea = All;
                Caption = 'Pmt. Discount Date';
                ToolTip = 'Specifies the Payment Discount Date';
                Visible = false;
            }
            field("NS_Payment Discount %"; Rec."Payment Discount %")
            {
                ApplicationArea = All;
                Caption = 'Payment Discount %';
                ToolTip = 'Specifies the Payment Discount %';
                Visible = false;
            }
            //PRJ-669.N.S.1.0 End
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Bal. Ledger No.';
            }
        }
        addafter("Bal. VAT Prod. Posting Group")
        {
            field("NS_Print Lien Release"; Rec."NS_Print Lien Release")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Print Lien Release';
            }
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS_Job Quantity"; Rec."Job Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Quantity';
            }
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;

                ToolTip = 'Specifies the Subcontract No.';
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;

                ToolTip = 'Specifies the Draw No.';
            }
        }
        addafter("Has Payment Export Error")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;

                ToolTip = 'Specifies the Retention Ledger Code';
            }
            field("NS_Retention Percent"; Rec."NS_Retention Percent")
            {
                ApplicationArea = All;

                ToolTip = 'Specifies the Retention Percent';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if "NS_Retention Percent" = 0 then begin
                        if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                            "NS_Retention Date" := 0D;
                    end else begin
                        "NS_Retention Amount (LCY)" := ROUND("NS_Retention Base Amount" * ("NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
                        if "NS_Retention Date" = 0D then
                            "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
                    end;
                    CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
        }
    }
    actions
    {
        addafter("Post and &Print")
        {
            action("NS_Print Lien Releases")
            {
                ApplicationArea = All;

                Caption = 'Print &Lien Releases';

                ToolTip = 'Print &Lien Releases';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Visible = false;//PRJ-290.AS.1.0 09SEPT20 //PRJ-975.GK.1.0 21Oct2021|Comment
                Visible = True;//PRJ-975.GK.1.0 21Oct2021 |Added Code

                trigger OnAction();

                begin
                    //ProjectPro - start
                    if NS_JobsSetup.get then; //PRJ-290.MS.1.0
                    //PRJ-975.GK.1.0 21Oct2021 start
                    if NS_UserSetup.Get(UserId) then;
                    if (NS_UserSetup."NS_Enable Lien Release Print") then
                        REPORT.RUNMODAL(NS_JobsSetup."NS_Lien Release Document 01", true, true)
                    else
                        Error(NS_LienReleaseError);
                    //PRJ-975.GK.1.0 21Oct2021 end
                    //ProjectPro - end
                end;
            }
        }
        modify(SuggestVendorPayments)
        {
            Visible = false; //PRJ-10.SK.1.0 Added
        }
        addafter(SuggestVendorPayments)
        {

            //PRJ-10.SK.1.0 Start
            action(NS_SuggestVendorPayments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Vendor Payments';
                ToolTip = 'Create payment suggestions as lines in the payment journal.';
                Image = SuggestVendorPayments;
                Promoted = True;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Ellipsis = true;



                trigger OnAction()
                var
                    SuggestVendorPayments: Report "NS_Suggest Vendor Payments";
                begin
                    CLEAR(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RUNMODAL;
                end;
            }
            //PRJ-10.SK.1.0 Start
        }
    }

    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
        NS_UserSetup: Record "User Setup"; //PRJ-975.GK.1.0 21Oct2021
        NS_LienReleaseError: Label 'You are not authorized to print Lien Release Document. Please contact your system administrator.'; //PRJ-975.GK.1.0 21Oct2021
    // NS_Vendor: Record Vendor;
    // Text14021100: Label 'Warning:  Insurance has expired for Vendor %1';

    trigger OnOpenPage();
    begin
        NS_PurchSetup.GET;
        NS_GLSetup.GET;
    end;

    //+---------------------------------------------------------------------------------------------
    //+ProjectPro
    //   +  - Added field(s):
    //   +     PP Bal. Ledger No.
    //   +     PP Job No.
    //   +     Job Task No.
    //   +     Job Quantity
    //   +     Job Cost Category
    //   +     PP Subcontract No.
    //   +     Subcontract No.
    //   +     PP Draw No.
    //   +     PP Retention Percent
    //   +
    //   +  - Added function(s):
    //   +     PP Print Lien Release
    //   +
    //   +  - Added global variable(s):
    //   +     PP_PurchSetup
    //   +     PP_GLSetup
    //   +     PP_JobsSetup
    //   +     PP_Vendor
    //   +
    //   +  - Added global text constant(s):
    //   +     Text14021100
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage - Read setup records
    //   +                       PP_PurchSetup
    //   +                       PP_GLSetup
    //   +                       PP_JobsSetup
    //   +     - Modify action list:
    //   +         Account No. - OnValidate - Display message if the vendor's insurance has expired
    //   +                                  - Set retention code based on setting of Purchase Retention Inactive
    //   +     - Added Print Lien Releases option to Posting menu
    //   +                       PP_JobsSetup
    //   +     - Modify action list:
    //   +         Account No. - OnValidate - Display message if the vendor's insurance has expired
    //   +                                  - Set retention code based on setting of Purchase Retention Inactive
    //   +     - Added Print Lien Releases option to Posting menu
    //   +-----------------------------------------------------------------------------------------------

}
