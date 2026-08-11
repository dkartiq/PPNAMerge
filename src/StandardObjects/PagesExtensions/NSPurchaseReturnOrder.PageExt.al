pageextension 14021178 NS_PurchaseReturnOrder extends "Purchase Return Order"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-168.SK.1.0 Added some code and blocked exisiting code
    //PRJ-372.MS.1.0 code comment due to wrong value changes
    //TM-10.AM.1.0 23NOV2020 | Added Validation on Post Action.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Purchase Return Order'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            //PE-260.JS.1.0 07MAR2024 - Start
            field("NS_Multiple Jobs on Lines"; Rec."NS_Multiple Jobs on Lines")
            {
                ApplicationArea = All;
                caption = 'Multiple Jobs on Lines';
                ToolTip = 'If enabled, you can manually select multiple jobs on the purchase order/invoice lines, even if the job number is defined on the purchase order/invoice header. It is suggested to take different jobs but with similar "Tax Area Code" to avoid inconsistency in tax calculation. Please note that, this is not applicable for the purchase orders/invoices created via JMP and Subcontracts.';
            }
            //PE-260.JS.1.0 07MAR2024 - end
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
        }
    }
    actions
    {

        modify(Post)
        {
            trigger OnBeforeAction();
            var
                EventSubsCOD14021112: Codeunit "NS_Event Subscr. Codeunit 90"; //PRJ-168.SK.1.0 Added
            begin
                //ProjectPro - start
                //NS_PostPurchaseReturn(Rec) //PRJ-168.SK.1.0 Blocked
                //EventSubsCOD14021112.NS_PostPurchaseReturn(Rec); //PRJ-168.SK.1.0 Added	  /PRJ-372 code comment
                //ProjectPro - end
                //TM-10.AM.1.0 Start
                Jobssetup.Get();
                if Jobssetup."NS_Job Segment Mandatory" then
                    if PurchaseReturn.Type <> PurchaseReturn.Type::"Fixed Asset" then begin
                        PurchaseReturn.Reset();
                        PurchaseReturn.SetCurrentKey("Document No.", "Line No.");
                        PurchaseReturn.SetRange("Document No.", Rec."No.");
                        PurchaseReturn.SetRange("Document Type", Rec."Document Type");
                        PurchaseReturn.SetFilter("No.", '<>%1', '');
                        PurchaseReturn.SetFilter("Job No.", '<>%1', '');
                        if PurchaseReturn.FindSet() then begin
                            repeat
                                PurchaseReturn.TestField("NS_Segment Code");
                            until PurchaseReturn.Next() = 0;
                        end;
                    end;
                //TM-10.AM.1.0 End

            end;
        }
    }
    var
        PurchaseReturn: Record "Purchase Line";//TM-10.AM.1.0
        JobsSetup: Record "Jobs Setup";//TM-10.AM.1.0


    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Job No."
      +     "PP Draw No."
      +
      +  - Added function(s):
      +     PP_PostPurchaseReturn(Rec) Function Call to Post Action
      +------------------------------------------------------------
    */


}

