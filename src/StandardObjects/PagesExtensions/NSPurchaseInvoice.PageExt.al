pageextension 14021120 NS_PurchaseInvoice extends "Purchase Invoice"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,NAVMX11.00.00.25466,PPNA11.00
    //TM-10.AM.1.0 | Added code on Post action.
    //PRJ-999.JS.1.0 19Nov2021 | Add code for dimension
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1099.JS.1.0 31Dec2021 | Modify code for dimension on condition basis
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Purchase Invoice'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
                //PRJ-1099.JS.1.0 31Dec2021 -start

                trigger OnValidate();
                var
                    NS_Job: Record Job;
                    NS_ProgrBillHead: Record "NS_Progress Billing Header";
                    NS_DefaultDim: Record "Default Dimension";
                begin
                    //PRJCTPR-199.JS.1.0 11DEC23 start below code commented till line no. 50

                    // if rec."NS_Job No." <> '' then begin
                    //     NS_JobsSetup.Get();
                    //     If NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                    //         IF Rec."NS_Job No." <> '' then
                    //             if NS_Job.Get(Rec."NS_Job No.") then begin
                    //                 Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    //                 Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    //                 Rec."Dimension Set ID" := Rec.GetDimensionNoFromJob(Rec."NS_Job No.");
                    //             end;
                    //     end else
                    //         if NS_Job.get(Rec."NS_Job No.") then begin
                    //             NS_DefaultDim.Reset();
                    //             NS_DefaultDim.SetRange("Table ID", 23);
                    //             NS_DefaultDim.SetRange("No.", Rec."Buy-from Vendor No.");
                    //             if NS_DefaultDim.IsEmpty() then begin
                    //                 Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    //                 Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    //                 Rec."Dimension Set ID" := NS_ProgrBillHead.GetDimensionNoFromJob(Rec."NS_Job No.");
                    //             end;
                    //         end;
                    // end;
                    // CurrPage.UPDATE();
                    //PRJCTPR-199.JS.1.0 11DEC23 end 
                end;
                //PRJ-1099.JS.1.0 31Dec2021 -end  
            }
            //PE-260.JS.1.0 20FEB2024 - Start
            field("NS_Multiple Jobs on Lines"; Rec."NS_Multiple Jobs on Lines")
            {
                caption = 'Multiple Jobs on Lines';   //PE-260.JS.1.0 12MAR2024  
                ApplicationArea = All;
                ToolTip = 'If enabled, you can manually select multiple jobs on the purchase order/invoice lines, even if the job number is defined on the purchase order/invoice header. It is suggested to take different jobs but with similar "Tax Area Code" to avoid inconsistency in tax calculation. Please note that, this is not applicable for the purchase orders/invoices created via JMP and Subcontracts.';
            }
            //PE-260.JS.1.0 20FEB2024 - end
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Document';
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
        addafter("Foreign Trade")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; NS_RetentionBaseAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Base Amount';
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionPercentEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountLCYEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountEditable;
                    ToolTip = 'Specifies the Retention Amount';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        "NS_Retention Percent" := 0;
                        if ("NS_Retention Amount" <> 0) and ("NS_Retention Date" = 0D) then
                            "NS_Retention Date" := CALCDATE('+1Y', "Posting Date");
                        CurrPage.UPDATE;
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionDateEditable;
                    ToolTip = 'Specifies the Retention Date';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
            }
        }
    }
    //TM-10.AM.1.0 start

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
            begin
                JobSetup.Get();
                if JobSetup."NS_Job Segment Mandatory" then
                    if PurchLineSegment.Type <> PurchLineSegment.Type::"Fixed Asset" then begin
                        PurchLineSegment.Reset();
                        PurchLineSegment.SetCurrentKey("Document No.", "Line No.");
                        PurchLineSegment.SetRange("Document No.", Rec."No.");
                        PurchLineSegment.SetRange("Document Type", Rec."Document Type");
                        PurchLineSegment.SetFilter("No.", '<>%1', '');
                        PurchLineSegment.SetFilter("Job No.", '<>%1', '');
                        if PurchLineSegment.FindSet() then begin
                            repeat
                                PurchLineSegment.TestField("NS_Segment Code");
                            until PurchLineSegment.Next() = 0;
                        end;
                    end;
            end;
        }

        //TM-10.AM.1.0 end



        //PE-204.AS.1.0 27OCT2023 START 
        addafter(CopyDocument)
        {
            //PE-204.AS.1.0 27OCT2023 START Added Action NS_Get Retention
            action("NS_Get Retention")
            {
                ApplicationArea = All;
                Caption = 'Get R&etention';
                Image = SuggestVendorPayments;
                PromotedCategory = Category6;
                Promoted = true;
                trigger OnAction();
                begin
                    if Rec."NS_Retention Document" then
                        NS_GetJobRLedgerNew(Rec."NS_Job No.")
                    else
                        MESSAGE(Text14021100);
                end;
            }
            //PE-204.AS.1.0 27OCT2023 END   
        }
        //PE-204.AS.1.0 27OCT2023 END
    }


    var
        NS_JobsSetup: Record "Jobs Setup";
        PurchLineSegment: Record "Purchase Line";//TM-10.AM.1.0
        JobSetup: Record "Jobs Setup";//TM-10.AM.1.0
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_PurchHeader: Record "Purchase Header";
        NS_VendLedgEntry: Record "Vendor Ledger Entry";
        NS_GetPurchaseRetentionList: Page "NS_Get Purchase Retention List";
        [InDataSet]
        NS_RetentionPercentEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountLCYEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountEditable: Boolean;
        [InDataSet]
        NS_RetentionDateEditable: Boolean;
        NS_RetentionBaseAmount: Decimal;
        Text14021100: Label 'This function can only be used when the Retention Document field is checked.';//PE-204.AS.1.0 27OCT2023
        Text14021101: Label 'This function can only be performed if'' Retention Document is checked.';


    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        NS_JobsSetup.GET;
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    var
        NS_Jobs: Record Job;   //PRJ-999.JS.1.0 18Nov2021
    begin
        //ProjectPro - start
        NS_RetentionCalcs;
        //ProjectPro - 
        //PRJ-999.JS.1.0 18Nov2021 Start
        //PRJ-1099.JS.1.0 31Dec2021 -Start
        // NS_JobsSetup.Get();  //PRJ-1087.JS.1.0 18Dec2021 add line
        // If NS_JobsSetup."NS_Flow Job Card Dimension" = true then  //PRJ-1087.JS.1.0 18Dec2021 add line
        //     IF Rec."NS_Job No." <> '' then
        //         if NS_Jobs.Get(Rec."NS_Job No.") then begin
        //             Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
        //             Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
        //             Rec."Dimension Set ID" := Rec.GetDimensionNoFromJob(Rec."NS_Job No.");
        //         end;
        //PRJ-1099.JS.1.0 31Dec2021 -End        
        //PRJ-999.JS.1.0 18Nov2021 end                
    end;

    procedure NS_GetJobRLedger();
    var
        NS_PurchLine: Record "Purchase Line";
        NS_LineNumber: Integer;
        Text14021100: Label '"Retention for job "';
    begin
        //ProjectPro - start
        NS_PurchHeader.COPY(Rec);
        NS_PurchHeader.SETRECFILTER;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            NS_VendLedgEntry.RESET;
            NS_VendLedgEntry.SETRANGE("Vendor No.", "Buy-from Vendor No.");
            NS_VendLedgEntry.SETRANGE("Document Type", NS_VendLedgEntry."Document Type"::Invoice);
            NS_VendLedgEntry.SETRANGE(Open, true);
            NS_VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
            NS_GetPurchaseRetentionList.SETTABLEVIEW(NS_VendLedgEntry);
            NS_GetPurchaseRetentionList.NS_SetPurchHeader(NS_PurchHeader);

            if NS_GetPurchaseRetentionList.RUNMODAL = ACTION::OK then begin
                with NS_VendLedgEntry do begin

                    NS_PurchLine.RESET;
                    NS_PurchLine.SETRANGE("Document Type", NS_PurchHeader."Document Type");
                    NS_PurchLine.SETRANGE("Document No.", NS_PurchHeader."No.");
                    if NS_PurchLine.FINDLAST then
                        NS_LineNumber := NS_PurchLine."Line No."
                    else
                        NS_LineNumber := 0;
                    SETFILTER("NS_Retention Applies-to Amount", '<>0');
                    if FINDSET then
                        repeat

                            NS_PurchLine.INIT;
                            NS_PurchLine."Document Type" := NS_PurchHeader."Document Type";
                            NS_PurchLine."Buy-from Vendor No." := NS_PurchHeader."Buy-from Vendor No.";
                            NS_PurchLine."Document No." := NS_PurchHeader."No.";
                            NS_LineNumber := NS_LineNumber + 10000;
                            NS_PurchLine."Line No." := NS_LineNumber;
                            NS_PurchLine.Type := NS_PurchLine.Type::NS_Ledger;
                            NS_PurchLine.VALIDATE(Type);
                            NS_PurchLine."No." := NS_JobsSetup."NS_Retention Payable Ledger";
                            NS_PurchLine.VALIDATE("No.");
                            NS_PurchLine.Description := Text14021100 + NS_PurchLine."Job No.";
                            NS_PurchLine."Job No." := NS_VendLedgEntry.GetJobNo(NS_VendLedgEntry);
                            NS_PurchLine.Quantity := 1;
                            NS_PurchLine.VALIDATE(Quantity);
                            NS_PurchLine."Direct Unit Cost" := "NS_Retention Applies-to Amount";
                            NS_PurchLine.Amount := NS_PurchLine."Unit Cost";
                            if NS_PurchHeader."Document Type" = NS_PurchHeader."Document Type"::"Credit Memo" then
                                NS_PurchLine."Unit Cost" := -NS_PurchLine."Unit Cost";
                            NS_PurchLine.VALIDATE("Direct Unit Cost");
                            NS_PurchLine.INSERT;


                            "NS_Retention Applies-to Amount" := 0;
                            "Applies-to ID" := '';
                            MODIFY;
                        until NEXT = 0;
                end;
            end;

            CLEAR(NS_GetPurchaseRetentionList);
        end;
        //ProjectPro - end
    end;

    procedure NS_RetentionCalcs();
    begin
        //ProjectPro - start
        NS_RetentionBaseAmount := NS_RetentionBase("Document Type", "No.");

        if "NS_Retention Percent" <> 0 then begin
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        end else
            if "NS_Retention Amount (LCY)" <> 0 then begin
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            end;

        if "NS_Retention Document" then begin
            "NS_Retention Percent" := 0;
            "NS_Retention Amount (LCY)" := 0;
            "NS_Retention Amount" := 0;
            "NS_Retention Date" := 0D;
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
            NS_RetentionDateEditable := false;
        end else begin
            NS_RetentionPercentEditable := true;
            NS_RetentionAmountLCYEditable := true;
            NS_RetentionAmountEditable := true;
            NS_RetentionDateEditable := true;
        end;

        if NS_JobsSetup."NS_Calc Payable Ret Before Tax" then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    procedure NS_GetSubcontract();
    begin
        //ProjectPro - start
        CODEUNIT.RUN(CODEUNIT::"NS_Purch.-Get Subcontract", Rec);
        //ProjectPro - end
    end;

    //PE-204.AS.1.0 START 
    procedure NS_GetJobRLedgerNew(NS_JobNo: code[20]);
    var
        NS_PurchLine: Record "Purchase Line";
        jobrec: Record job;
        NS_LineNumber: Integer;
        Text0001: Label '"Retention for job "';
        NS_GLAccount: Record "G/L Account"; //PRJCTPR-354.DK.2.0 16MAy2024
    begin
        NS_PurchHeader.COPY(Rec);
        NS_PurchHeader.SETRECFILTER;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
            NS_VendLedgEntry.RESET;
            NS_VendLedgEntry.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
            NS_VendLedgEntry.SETRANGE("Document Type", NS_VendLedgEntry."Document Type"::Invoice);
            NS_VendLedgEntry.SETRANGE(Open, true);
            NS_VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
            if NS_JobNo <> '' then
                NS_VendLedgEntry.SetRange("NS_Job No.", NS_JobNo);
            NS_GetPurchaseRetentionList.SETTABLEVIEW(NS_VendLedgEntry);
            NS_GetPurchaseRetentionList.NS_SetPurchHeader(NS_PurchHeader);

            if NS_GetPurchaseRetentionList.RUNMODAL = ACTION::OK then
                NS_PurchLine.RESET();
            NS_PurchLine.SETRANGE("Document Type", NS_PurchHeader."Document Type");
            NS_PurchLine.SETRANGE("Document No.", NS_PurchHeader."No.");
            if NS_PurchLine.FINDLAST() then
                NS_LineNumber := NS_PurchLine."Line No."
            else
                NS_LineNumber := 0;
            NS_VendLedgEntry.SETFILTER("NS_Retention Applies-to Amount", '<>0');
            //PRJCTPR-354.DK.2.0 16MAy2024 End
            NS_GLAccount.SetRange(Name, 'Retention Payables');
            if NS_GLAccount.FindSet() then;
            //PRJCTPR-354.DK.2.0 16MAy2024 End
            if NS_VendLedgEntry.FINDSET() then
                repeat
                    NS_PurchLine.INIT();
                    NS_PurchLine."Document Type" := NS_PurchHeader."Document Type";
                    NS_PurchLine."Buy-from Vendor No." := NS_PurchHeader."Buy-from Vendor No.";
                    NS_PurchLine."Document No." := NS_PurchHeader."No.";
                    NS_LineNumber := NS_LineNumber + 10000;
                    NS_PurchLine."Line No." := NS_LineNumber;
                    NS_PurchLine.Type := NS_PurchLine.Type::NS_Ledger;
                    NS_PurchLine.VALIDATE(Type);
                    NS_PurchLine."No." := NS_JobsSetup."NS_Retention Payable Ledger";
                    NS_PurchLine.VALIDATE("No.");
                    NS_PurchLine.Description := Text0001 + NS_PurchLine."Job No.";//PE-200.AS.5.0
                    NS_PurchLine."Job No." := NS_VendLedgEntry.GetJobNo(NS_VendLedgEntry);
                    NS_PurchLine.Quantity := 1;
                    NS_PurchLine.VALIDATE(Quantity);
                    NS_PurchLine."Direct Unit Cost" := (NS_VendLedgEntry."NS_Retention Applies-to Amount" * -1); //PRJCTPR-354.DK.1.0
                    NS_PurchLine.Amount := NS_PurchLine."Unit Cost";
                    if NS_PurchHeader."Document Type" = NS_PurchHeader."Document Type"::"Credit Memo" then
                        NS_PurchLine."Direct Unit Cost" := -NS_PurchLine."Direct Unit Cost";
                    NS_PurchLine.VALIDATE("Direct Unit Cost");

                    if jobrec.get(NS_PurchLine."Job No.") then begin
                        if NS_PurchLine."Tax Liable" then
                            if NS_PurchLine."Tax Area Code" <> '' then
                                NS_PurchLine.VALIDATE("Tax Group Code", jobrec."NS_Tax Group Code New");
                        //PRJCTPR-354.DK.2.0 16MAy2024 Start
                        // NS_PurchLine."Gen. Prod. Posting Group" := jobrec."NS_Gen. Prod. Posting Group New";
                        NS_PurchLine.Validate("Gen. Prod. Posting Group", NS_GLAccount."Gen. Prod. Posting Group");
                        NS_PurchLine."Gen. Bus. Posting Group" := jobrec."NS_Gen. Bus. Posting Group New";
                        //PRJCTPR-354.DK.2.0 16MAy2024 End
                    end;
                    NS_PurchLine.INSERT();

                    NS_VendLedgEntry."NS_Retention Applies-to Amount" := 0;
                    NS_VendLedgEntry."Applies-to ID" := '';
                    NS_VendLedgEntry.MODIFY();
                until NS_VendLedgEntry.NEXT() = 0;

            CLEAR(NS_GetPurchaseRetentionList);
        end;
    end;
    //PE-204.AS.1.0 END


    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Job No.
      +     PP Retention Document
      +     PP Subcontract No.
      +     PP Draw No.
      +     - PP Retention
      +         PP Retention Base Amount
      +         PP Retention Percent
      +         PP Retention Amount (LCY)
      +         PP Retention Amount
      +         PP Retention Date
      +
      +  - Added function(s):
      +     PP_GetJobRLedger
      +     PP_RetentionCalcs
      +     PP_GetSubcontract
      +
      +  - Added global variable(s):
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_RetentionBaseAmount
      +     PP_GetPurchaseRetentionList
      +     PP_JobsSetup
      +     PP_PurchSetup
      +     PP_PurchHeader
      +     PP_VendLedgEntry
      +
      +  - Added global text constant(s):
      +      Text14021101
      +
      +  - Modification(s):
      +     - OnOpenPage - Read setup records
      +                         Jobs Setup
      +                         Purchases & Payables Setup
      +                  - Initialze variables
      +     - OnAfterGetRecord - Call PP_RetentionCalcs
      +
      + -SMP
      +  -Modified Page Triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +-----------------------------------------------------------------------------------------------
    */
}

