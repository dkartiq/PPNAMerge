pageextension 14021118 NS_PurchaseQuote extends "Purchase Quote"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-387.AM.1.0 9OCT2020 | Made Field Posting Date Visible On page .
    //TM-10.AM.1.0 20NOV2020 | Added validation before action MakeOrder.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Purchase Quote'; //PRJ-1330.NK.1.0 25Apr2022


    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
        }
        //PRJ-387.AM.1.0 start
        addafter("Document Date")
        {
            field("NS_Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
                Caption = 'Posting Date';

            }
        }
        //PRJ-387.AM.1.0 End

    }
    actions
    {
        //TM-10.AM.1.0 Start
        modify(MakeOrder)
        {
            trigger OnBeforeAction()
            var
            begin
                Jobssetup.Get();
                if Jobssetup."NS_Job Segment Mandatory" then
                    if PurchQuoteLine.Type <> PurchQuoteLine.Type::"Fixed Asset" then begin
                        PurchQuoteLine.Reset();
                        PurchQuoteLine.SetCurrentKey("Document No.", "Line No.");
                        PurchQuoteLine.SetRange("Document No.", Rec."No.");
                        PurchQuoteLine.SetRange("Document Type", Rec."Document Type");
                        PurchQuoteLine.SetFilter("No.", '<>%1', '');
                        PurchQuoteLine.SetFilter("Job No.", '<>%1', '');
                        if PurchQuoteLine.FindSet() then begin
                            repeat
                                PurchQuoteLine.TestField("NS_Segment Code");
                            until PurchQuoteLine.Next() = 0;
                        end;
                    end;
            end;
        }
        //TM-10.AM.1.0 End
        addbefore(CopyDocument)
        {
            action("NS_Get Job Planning Line")
            {
                Caption = 'Get Job &Planning Line';
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Get Job Planning Line';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    CurrPage.PurchLines.PAGE.GetJobBudget('');
                    //ProjectPro - end
                end;
            }
            separator(NS_Separator1100773002)
            {
            }
        }
    }
    var
        PurchQuoteLine: Record "Purchase Line";//TM-10.AM.1.0
        Jobssetup: Record "Jobs Setup";//TM-10.AM.1.0

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Job No.
      +     PP Subcontract No.
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Added action list:
      +         Added Save and Send
      +         Added Get Job Planning Line
      +-----------------------------------------------------------------------------------------------
    */

}

