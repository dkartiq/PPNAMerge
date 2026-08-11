pageextension 14021104 NS_CustomerLedgerEntries extends "Customer Ledger Entries"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Customer Ledger Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Reason Code")
        {
            Visible = false;
            Enabled = false;

        }
        addafter("Source Code")
        {
            field("NS_ReasonCode"; Rec."Reason Code")
            {
                ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                ApplicationArea = Advanced;
                Caption = 'Reason Code';
                Editable = false;
                Visible = false;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ToolTip = 'Specifies the Retention Ledger Code';
                ApplicationArea = All;
            }

            //PE-200.AS.1.0 24SEPT2023 START
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ToolTip = 'Specifies the Draw No.';
                ApplicationArea = All;
            }
            //PE-200.AS.1.0 24SEPT2023 END

            //PE-200.AS.9.0 START
            field(NS_PaywhenPaid; Rec.NS_PaywhenPaid)
            {
                ToolTip = 'Specify whether the "Pay When Paid" batch for the entry has already been executed. if the user attempts to run the batch again, these entries will be excluded from consideration';
                ApplicationArea = All;
            }
            //PE-200.AS.9.0 END

        }
        addafter("Bal. Account No.")
        {
            field("NS_Bal. Ledger No."; Rec."NS_Bal. Ledger No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Bal. Ledger No.';
                ApplicationArea = All;
            }
        }
        addafter("On Hold")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                Editable = false;
                ToolTip = 'Specifies the Job No.';
                ApplicationArea = All;
            }
        }
        addafter("Reason Code")
        {
            field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Base Amount';
                ApplicationArea = All;
            }
            field("NS_Retention Percent"; Rec."NS_Retention Percent")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Percent';
                ApplicationArea = All;
            }
            field("NS_Retention Amount LCY"; Rec."NS_Retention Amount (LCY)")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Amount (LCY)';
                ApplicationArea = All;
            }
            field("NS_Retention Amount"; Rec."NS_Retention Amount")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Amount';
                ApplicationArea = All;
            }
            field("NS_Retention Date"; Rec."NS_Retention Date")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Date';
                ApplicationArea = All;
            }
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                Editable = false;
                ToolTip = 'Specifies the Retention Document';
                ApplicationArea = All;
            }
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 start
        addafter(Description)
        {
            field("NS_Lien Waiver Type"; Rec."NS_Lien Waiver Type")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                ToolTip = 'Specify the Lien Waiver Report Type: Conditional Progress, Unconditional Progress, Conditional Final, Unconditional Final.'; //PE-85.DK.1.0 4Sep2023
            }
            field("NS_Lien Waiver Signed Date"; Rec."NS_Lien Waiver Signed Date")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                ToolTip = 'Specifies the date on which the report is printed. The user can modify the value accordingly.'; //PE-85.DK.1.0 4Sep2023
            }
            field("NS_Lien Waiver Print Status"; Rec."NS_Lien Waiver Print Status")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                ToolTip = 'This field is auto set to "Printed" when a user prints the Lien Waiver report. The user can modify the value accordingly.'; //PE-85.DK.1.0 4Sep2023
            }
            field("NS_Lien Waiver Work Type"; Rec."NS_Lien Waiver Work Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specify the Work Type for your Lien Waiver report.'; //PE-85.DK.1.0 4Sep2023
                Editable = true;
            }
            field("NS_Lien Waiver Amount"; Rec."NS_Lien Waiver Amount")
            {
                ApplicationArea = all;
                Editable = NS_IsPermissionToView;
                ToolTip = 'Specify the Lien Waiver invoice amount to be printed on the basic level of Lien Waiver report. This field is disabled when "Advance Customer Lien Waiver" setup is True.'; //PE-85.DK.1.0 4Sep2023
                //Editable = true;
            }
            field("NS_Lien Waiver Payment"; Rec."NS_Lien Waiver Payment")
            {
                //Editable = true;
                Editable = NS_IsPermissionToView;
                ToolTip = 'Specify the Lien Waiver invoice amount to be printed on the basic level of Lien Waiver report. This field is disabled when "Advance Customer Lien Waiver" setup is True.'; //PE-85.DK.1.0 4Sep2023
                ApplicationArea = all;
            }

        }
        //PRJCTPR-11.GK.1.0 20Apr2023 end
    }
    actions
    {

        modify("&Navigate")
        {
            Visible = false;
        }
        //PPDA.1.0.TBA Start
        // addafter("&Cancel")
        // {
        //     action("NS_Navigate")
        //     {
        //         Caption = 'Navigate';
        //         ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        //         ApplicationArea = Basic, Suite;
        //         Promoted = true;
        //         Image = Navigate;
        //         PromotedCategory = Process;
        //         Scope = "Repeater";
        //         trigger OnAction();
        //         begin
        //             //ProjectPro - start
        //             //Navigate.SetDoc("Posting Date","Document No.");
        //             Navigate.SetDocLedger("NS_Retention Ledger Code", "Posting Date", "Document No.");
        //             Navigate.RUN;
        //             //ProjectPro - end
        //         end;
        //     }
        // }
        //PPDA.1.0.TBA End
        addafter(ReverseTransaction)
        {
            // PE-85.DK.1.0 01june2023 Start
            action("NS_Print Lien Waiver")
            {
                ApplicationArea = all;
                Caption = 'Print Lien Waiver';
                // Visible = NS_IsPermissionToView;
                trigger OnAction()
                var
                    ConditionalProgress: Report 14021472;
                    ConditionalFinal: Report 14021471;
                    UnconditionalProgress: Report 14021474;
                    UnconditionalFinal: Report 14021473;
                    NS_AdvanceConditionalProgress: Report 14021494;
                    NS_AdvanceUnconditionalProgress: Report 14021475;
                    NS_AdvanceConditionalLienFinal: Report 14021476;
                    NS_AdvanceUnconditionalFinal: Report 14021477;
                    NS_CLE: Record "Cust. Ledger Entry";
                    NS_Remaningamt: Decimal;
                begin
                    If rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::" " then
                        Error('Please Select Lien Waiver Type.');
                    if NSjobSetUp.Get() then;
                    if not NSjobSetUp."NS_Advance Cust Lien Waiver" then begin
                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Conditional-Progress" then begin
                            ConditionalProgress.SetDocument(rec."NS_Job No.", rec."Document No.", rec."Currency Code");
                            ConditionalProgress.UseRequestPage(true);
                            ConditionalProgress.RunModal();
                        end;

                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Conditional-Final" then begin
                            ConditionalFinal.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Currency Code");
                            ConditionalFinal.UseRequestPage(true);
                            ConditionalFinal.RunModal();
                        end;

                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Unconditional-Progress" then begin
                            UnconditionalProgress.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Currency Code");
                            UnconditionalProgress.UseRequestPage(true);
                            UnconditionalProgress.RunModal();
                        end;

                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Unconditional-Final" then begin
                            UnconditionalFinal.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Currency Code");
                            UnconditionalFinal.UseRequestPage(true);
                            UnconditionalFinal.Runmodal();
                        end;
                    end else begin
                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Conditional-Progress" then begin
                            NS_AdvanceConditionalProgress.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Posting Date", Rec."Customer No.");
                            // NS_AdvanceConditionalProgress.SetTableView(Rec);
                            NS_AdvanceConditionalProgress.UseRequestPage(true);
                            NS_AdvanceConditionalProgress.RunModal();
                        end;
                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Unconditional-Progress" then begin
                            NS_AdvanceUnconditionalProgress.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Customer No.", Rec."Posting Date");
                            NS_AdvanceUnconditionalProgress.UseRequestPage(true);
                            NS_AdvanceUnconditionalProgress.RunModal();
                        end;
                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"conditional-Final" then begin
                            NS_CLE.SetCurrentKey("Posting Date");
                            NS_CLE.SetRange("NS_Job No.", Rec."NS_Job No.");
                            NS_CLE.SetRange("Customer No.", Rec."Customer No.");
                            NS_CLE.SetRange("Document Type", Rec."Document Type"::Invoice);
                            NS_CLE.SetFilter("Posting Date", '%1', Rec."Posting Date");
                            NS_CLE.SetRange("NS_Retention Ledger Code", 'NORMAL');
                            if NS_CLE.FindLast() then begin
                                NS_CLE.CalcFields("Remaining Amt. (LCY)");
                                NS_Remaningamt := NS_CLE."Remaining Amt. (LCY)";
                                if NS_Remaningamt = 0 then
                                    Message('Conditional final Report Can not be run as there is no pending amount yet to be received.')
                                else
                                    if NS_Remaningamt <> 0 then begin
                                        NS_AdvanceConditionalLienFinal.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Customer No.", Rec."Posting Date");
                                        NS_AdvanceConditionalLienFinal.UseRequestPage(true);
                                        NS_AdvanceConditionalLienFinal.RunModal();
                                    end;
                            end;
                        end;
                        if rec."NS_Lien Waiver Type" = Rec."NS_Lien Waiver Type"::"Unconditional-Final" then begin
                            NS_CLE.Reset();
                            NS_CLE.SetRange("NS_Job No.", Rec."NS_Job No.");
                            NS_CLE.SetRange("Customer No.", Rec."Customer No.");
                            NS_CLE.SetRange("Document Type", Rec."Document Type"::Invoice);
                            NS_CLE.SetRange("NS_Retention Ledger Code", 'NORMAL');
                            if NS_CLE.FindFirst() then begin
                                repeat
                                    NS_CLE.CalcFields("Remaining Amt. (LCY)");
                                    NS_Remaningamt += NS_CLE."Remaining Amt. (LCY)";
                                until NS_CLE.Next() = 0;
                                if NS_Remaningamt <> 0 then
                                    Message('Report Can not be Print as there is pending amount yet to be received.')
                                else
                                    if NS_Remaningamt = 0 then begin
                                        NS_AdvanceUnconditionalFinal.SetDocument(rec."NS_Job No.", rec."Document No.", Rec."Customer No.");
                                        NS_AdvanceUnconditionalFinal.UseRequestPage(true);
                                        NS_AdvanceUnconditionalFinal.RunModal();
                                    end;
                            end;
                        end;
                    end;
                end;

            }
            //PE-85.DK.1.0 01june2023 End

            //PE-200.AS.7.0 START
            action("NS_UpdateDueDatePayWhenPaid")
            {
                ApplicationArea = all;
                Image = PostBatch;
                Caption = 'Update Due Dates- Pay When Paid';

                trigger OnAction()
                var
                begin
                    Report.Run(14021413);
                end;
            }
            //PE-200.AS.7.0 END//

        }
    }
    //PE-85.DK.1.0 4Sep2023 Start
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        NS_IsPermissionToView := false;
        NS_IsPermissionToView := NS_AdvanceCustLienWaiverEnable();
    end;
    /// <summary>
    /// NS_AdvanceCustLienWaiverEnable.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure NS_AdvanceCustLienWaiverEnable(): Boolean
    begin
        if NSjobSetUp.Get() then
            if NSjobSetUp."NS_Advance Cust Lien Waiver" = true then
                exit(false)
            else
                exit(true);
    end;
    //PE-85.DK.1.0 4Sep2023 End
    var
        Navigate: Page 344;
        //PE-85 Dk.1.0 04Sep2023 Start
        [InDataSet]
        NS_IsPermissionToView: Boolean;
        NSjobSetUp: Record "Jobs Setup";
    //PE-85 Dk.1.0 04Sep2023 End

    /*
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Retention Ledger Code
      +     Bal. Ledger No.
      +     Job No.
      +     Retention Base Amount
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +     Retention Document
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Modified action list:
      +         Detailed Ledger Entries - RunPageLink - Added field Initial Entry Global Dim. 2
      +         Navigate                - OnAction - Modified call to Navigate.SetDoc to call Navigate.SetDocLedger
      +
      + -SMP
      +  -Rewritten Actions
      +   -&Navigate
      +  -Rewritten Fields
      +   -Reason Code
      +-----------------------------------------------------------------------------------------------
      */
}

