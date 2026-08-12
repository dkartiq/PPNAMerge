page 14021340 "NS_Progress Payment Header"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1194.NK.1.0 02Mar2022 | Add One Field & Create New Button
    //PRJ-1257.NK.1.0 30Mar2022 | Change in Code
    //PE-215.HS.1.0 15Jan2024 | Added tooltip
    //PRJCTPR-292.HS.1.0 17Jan2024 | Added New action
    // PRJCTPR-293.HS.1.0 19Jan2024 | Added Code 
    Caption = 'Progress Payment Header';
    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    SourceTable = "NS_Progress Payment Header";
    // >> Upgrade
    InsertAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Purchasing';
    // << Upgrade
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Editable = "No.Editable";
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate();
                    begin
                        ProgressPaymentHeader.RESET;
                        ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
                        if ProgressPaymentHeader.FINDFIRST then
                            ERROR(Text009Lbl)
                        else begin
                            "NS_Requisition No." := 1;
                            "NS_Version No." := 0;
                        end;

                        if "NS_Requisition No." = 0 then
                            "NS_Requisition No." := 1;

                        if STRLEN("NS_Subcontract No.") > 0 then begin
                            if Subcontract.GET("NS_Subcontract No.") then begin
                                SubcontractName := Subcontract.NS_Description;
                                GetVendorName;
                                "NS_Job No." := Subcontract."NS_Job No.";
                                JobName := '';
                                if Job.GET("NS_Job No.") then
                                    JobName := Job.Description;
                                if "NS_Work Retention Percent" = 0 then
                                    "NS_Work Retention Percent" := Subcontract."NS_DefaultSubcontractRetention";
                                if "NS_Material Retention Percent" = 0 then
                                    if (JobsSetup."NS_A/P RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/P RetentionTaxCalcMethod"::"2 - Calc tax on purchase then apply retention amount") or
                                       (JobsSetup."NS_A/P RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount") then
                                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
                            end else begin
                                SubcontractName := '';
                                VendorNo := '';
                                VendorName := '';
                                JobName := '';
                            end;
                        end;
                    end;
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition No.';
                    Editable = false;
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    Caption = 'Version No.';
                    Editable = false;
                }
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract No.';
                    Editable = false;

                    trigger OnValidate();
                    begin
                        NS_SubcontractNoOnAfterValidate();
                    end;
                }
                field(SubcontractName; SubcontractName)
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Name';
                    Editable = false;
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    Editable = false;
                }
                field(JobName; JobName)
                {
                    ApplicationArea = All;
                    Caption = 'Job Name';
                    ToolTip = 'Job Name';

                    Editable = false;
                }
                field("Subcontract Draw No."; Rec."NS_Subcontract Draw No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract Draw No.';
                }
                field(VendorNo; VendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    ToolTip = 'Vendor No.';

                    Editable = false;
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                    ToolTip = 'Vendor Name';

                    Editable = false;
                }
                field("Purchase Order No."; Rec."NS_Purchase Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Purchase Order No.';
                }
                field("Round Amounts"; Rec."NS_Round Amounts")
                {
                    ApplicationArea = All;
                    Editable = "Round AmountsEditable";
                    ToolTip = 'Specifies the Round Amounts';

                    trigger OnValidate();
                    begin
                        NS_RoundAmountsOnAfterValidate;
                    end;
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    Caption = 'Final';
                    Editable = FinalEditable;
                    ToolTip = 'Final';
                }
                field("Owner Contact Type"; Rec."NS_Owner Contact Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Owner Contact';
                    Editable = "Owner Contact TypeEditable";

                    trigger OnValidate();
                    begin
                        NS_OwnerContactTypeOnAfterValidat;
                    end;
                }
                field("Owner Contact Code"; Rec."NS_Owner Contact Code")
                {
                    ApplicationArea = All;
                    Editable = "Arch Eng Contact CodeEditable";
                    LookupPageID = "NS_Job Contacts List";
                    ToolTip = 'Specifies the Owner Contact Code';
                }
                field("Arch Eng Contact Type"; Rec."NS_Arch Eng Contact Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Arch/Eng Contact';
                    Editable = "Arch Eng Contact TypeEditable";
                }
                field("Arch Eng Contact Code"; Rec."NS_Arch Eng Contact Code")
                {
                    ApplicationArea = All;
                    Editable = "Arch Eng Contact CodeEditable";
                    LookupPageID = "NS_Job Contacts List";
                    ToolTip = 'Specifies the Arch Eng Contact Code';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = StatusEditable;

                    trigger OnValidate();
                    begin
                        if NS_Status = NS_Status::Void then
                            ERROR(Text010Lbl);
                    end;
                }
                //PRJ-1194.NK.1.0 02Mar2022 Start
                field("Retention Reduction Invoice"; Rec."NS_Retention Reduction Invoice")
                {
                    ApplicationArea = all;
                    Caption = 'Retention Reduction Invoice';
                    ToolTip = 'Retention Reduction Invoice';

                }
                //PRJ-1194.NK.1.0 02Mar2022 End

                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Date';
                    Editable = "Requisition DateEditable";
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    Caption = 'Period To';
                    Editable = "Period ToEditable";
                }
            }
            part(Control16; "NS_Progress Payment Subform")
            {
                ApplicationArea = All;
                SubPageLink = "NS_Progress Payment No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No."),
                              "NS_Subcontract No." = FIELD("NS_Subcontract No.");
                UpdatePropagation = Both;//PE-183.AS.1.0
                //   SubPageView = ORDER(Ascending);
            }
            group(Retention)
            {

                Caption = 'Retention';
                // >> Upgrade
                Editable = false;
                // << Upgrade
                field("Work Retention %"; Rec."NS_Work Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = "Work Retention %Editable";
                    ToolTip = 'Specifies the Work Retention Percent"';

                    trigger OnValidate();
                    begin
                        if "NS_Work Retention Percent" <> 0 then
                            NS_CheckLineWorkRetention;
                        NS_WorkRetentionPercentOnAfterVal;

                        CalcFields(Rec.NS_RetentionBaseAmt);//PE-183.AS.1.0
                        Rec.NS_RetentionAmt := (Rec.NS_RetentionBaseAmt * Rec."NS_Work Retention Percent") / 100;//PE-183.AS.1.0
                    end;
                }
                field("Material Retention Percent"; Rec."NS_Material Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Material Retention %';
                    Editable = MaterialRetentionPercentEditab;

                    trigger OnValidate();
                    begin
                        if "NS_Material Retention Percent" <> 0 then
                            NS_CheckLineMaterialRetention;
                        NS_MaterialRetentionPercentOnAfte;
                    end;
                }
                field("Manual Retention Amount"; Rec."NS_Manual Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = ManualRetentionAmountEditable;
                    ToolTip = 'Specifies the Manual Retention Amount';
                }

                //PE-183.AS.1.0 start
                field(NS_RetentionBaseAmt; Rec.NS_RetentionBaseAmt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field(NS_RetentionAmt; Rec.NS_RetentionAmt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retention Amount';
                }
                //PE-183.AS.1.0 end
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Requisition")
            {
                Caption = '&Requisition';
                action("<NS_Page Progress Payment Statistic")
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "NS_Progress Payment Statistics";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                    ShortCutKey = 'F7';
                    //PRJCTPR-292.HS.1.0 17Jan2024 Start
                    Visible = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    //PRJCTPR-292.HS.1.0 17Jan2024  End
                }

                //PRJCTPR-292.HS.1.0 17Jan2024  Start
                action("NS_Page Progress Payment Statistic New")
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "NS_Progress Payment Stats. New";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                    ShortCutKey = 'F7';
                }
                //PRJCTPR-292.HS.1.0 17Jan2024 End

                //PRJ-1194.NK.1.0 02Mar2022 Start
                action(NS_CreateRetentionReductionInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Create Retention Document';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        Lbltext0001: Label 'Do you want to Create Retention Document?';
                    begin
                        if not Rec."NS_Retention Reduction Invoice" then
                            Error('Retention Reduction option must be selected in the Progress payment header.');
                        if not Confirm(Lbltext0001, false) then
                            exit;

                        Rec.CreateRetentionReductionInv(rec, VendorNo);
                    end;
                }
                //PRJ-1194.NK.1.0 02Mar2022 End
                action("<Page Progress Payment Comment S")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page NS_ProgressPaymentCommentSheet;
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                }
            }
            group("&Subcontract")
            {
                Caption = '&Subcontract';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "NS_Subcontract Card";
                    RunPageLink = "NS_No." = FIELD("NS_Subcontract No.");
                }
                action("Job Contacts")
                {
                    ApplicationArea = All;
                    Caption = 'Job Contacts';
                    Image = TeamSales;
                    RunObject = Page "NS_Job Contacts List";
                    RunPageLink = "NS_Job No." = FIELD("NS_Subcontract No.");
                }
            }
        }
        area(processing)
        {
            action("<NS_Page Subcontract Planning Lines>")
            {
                ApplicationArea = All;
                Caption = 'Cost &Budget';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Planning Lines";
                RunPageLink = "Job No." = FIELD("NS_Subcontract No.");
                RunPageView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code")
                              ORDER(Ascending)
                              WHERE("Line Type" = FILTER(Billable | "Both Budget and Billable"));
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action(NS_NewRequision)
                {
                    ApplicationArea = All;
                    Caption = 'New Requisition';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        // >> Upgrade
                        // #RG008 Start
                        if NS_Status = NS_Status::Open then
                            Error(Text50000);
                        // #RG008 End
                        // << Upgrade
                        Result := NewRequisition(Rec);
                        if Result <> -1 then begin
                            SETRANGE("NS_Requisition No.", Result);
                            SETRANGE("NS_Version No.", 0);
                            SETRANGE("NS_Requisition No.");
                            SETRANGE("NS_Version No.");
                        end;
                    end;
                }
                action(NS_NewVersion)
                {
                    ApplicationArea = All;
                    Caption = 'New Version';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        // >> Upgrade
                        // #RG008 Start
                        if NS_Status <> NS_Status::Open then
                            Error(Text50001);
                        // #RG008 End
                        // << Upgrade
                        Result := NewVersion(Rec);
                        if Result <> -1 then begin
                            SETRANGE("NS_Version No.", Result);
                            SETRANGE("NS_Version No.");
                        end;
                    end;
                }
                action(NS_SendToPO)
                {
                    ApplicationArea = All;
                    Caption = 'Send to PO';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        if CONFIRM(Text014Lbl, false) then
                             if (Rec."NS_Period To" > 0D) AND (Rec."NS_Requisition Date" > 0D) then //PRJ-1131.NK.1.0 //PRJCTPR-286.PS.1.0 10Jan2024
                                Rec.UpdatePurchaseOrderLines(Rec, PurchaseHeader, Subcontract) //PRJ-1131.NK.1.0
                            else
                                ERROR(Text013Lbl);
                    end;
                }
                action(NS_GetPO)
                {
                    ApplicationArea = All;
                    Caption = 'Get PO';
                    Image = SuggestVendorBills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        ProgPayHeader: Record "NS_Progress Payment Header";
                        GetPOForProgressPayment: Report "NS_Get PO for Progress Payment";
                        SubcontractRec: Record NS_Subcontract;
                    begin
                        if NS_Status = NS_Status::Open then begin
                            GetPOForProgressPayment.SetParameters("NS_Subcontract No.", "NS_No.", "NS_Requisition No.", "NS_Version No.");
                            GetPOForProgressPayment.SETTABLEVIEW(PurchaseLine);
                            GetPOForProgressPayment.RUNMODAL;
                            CLEAR(GetPOForProgressPayment);
                        end else
                            ERROR(Text011Lbl);
                    end;
                }
                action(NS_CopyComments)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Comments';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    // PRJCTPR-293.HS.1.0 19Jan2024 Start
                    RunObject = page "NS_Progress PaymentCommentList";
                    RunPageLink = "NS_No." = field("NS_No."), "NS_Requisition No." = field("NS_Requisition No."), "NS_Version No." = field("NS_Version No.");
                    ToolTip = 'Copy the comments from one requisition to another or add a new comment for current requisition.';
                    // PRJCTPR-293.HS.1.0 19Jan2024 End
                    trigger OnAction();
                    begin
                        Rec.CopyCommentLines(Rec); //PRJ-1131.NK.1.0
                    end;
                }

            }
            group(Print)
            {
                Caption = 'Prin&t';
                action(NS_ProgressPayment)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Payment';
                    ToolTip = 'This report can also be viewed on word layout using custom report layout option.'; //PE-215.HS.1.0 15Jan2024
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        if NS_Status <> NS_Status::Void then begin
                            JobsSetup.Get(); //PRJ-1257.NK.1.0 30Mar2022
                            ProgressPaymentHeader.RESET;
                            ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
                            ProgressPaymentHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                            ProgressPaymentHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                            REPORT.RUNMODAL(JobsSetup."NS_Prog Pay Standard Invoice", true, false, ProgressPaymentHeader);
                        end else
                            MESSAGE(Text019Lbl);
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        if "NS_Requisition No." = 1 then begin
            ProgressPaymentHeader.RESET;
            ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
            if ProgressPaymentHeader.COUNT <= 1 then
                "No.Editable" := true
            else
                "No.Editable" := false;
        end else
            "No.Editable" := false;

        if (NS_Status > NS_Status::Open) or
           ((NS_Status = NS_Status::Open) and ("NS_Requisition No." > 1)) then begin
            "Subcontract No.Editable" := false;
            "Owner Contact TypeEditable" := false;
            "Owner Contact CodeEditable" := false;
            "Arch Eng Contact TypeEditable" := false;
            "Arch Eng Contact CodeEditable" := false;
            "Round AmountsEditable" := false;
        end else begin
            "Subcontract No.Editable" := true;
            "Owner Contact TypeEditable" := true;
            "Owner Contact CodeEditable" := true;
            "Arch Eng Contact TypeEditable" := true;
            "Arch Eng Contact CodeEditable" := true;
            "Round AmountsEditable" := true;
        end;

        if NS_Status > NS_Status::Open then begin
            StatusEditable := false;
            "Requisition DateEditable" := false;
            "Period ToEditable" := false;
            "Work Retention %Editable" := false;
            MaterialRetentionPercentEditab := false;
            ManualRetentionAmountEditable := false;
        end else begin
            StatusEditable := true;
            "Requisition DateEditable" := true;
            "Period ToEditable" := true;
            "Work Retention %Editable" := true;
            MaterialRetentionPercentEditab := true;
            ManualRetentionAmountEditable := true;
        end;

        if NS_Final or (NS_Status <> NS_Status::Void) then
            FinalEditable := false
        else
            FinalEditable := true;

        if Subcontract.GET("NS_Subcontract No.") then begin
            SubcontractName := Subcontract.NS_Description;
            GetVendorName;
            VendorNo := Subcontract."NS_Buy-from Vendor No.";
            if Vendor.GET(Subcontract."NS_Buy-from Vendor No.") then
                VendorName := Vendor.Name
            else
                VendorName := Text001Lbl;
            "NS_Job No." := Subcontract."NS_Job No.";
            JobName := '';
            if Job.GET("NS_Job No.") then
                JobName := Job.Description;
        end else begin
            SubcontractName := '';
            VendorNo := '';
            VendorName := '';
            JobName := '';
        end;

        //PE-183.AS.1.0 START
        if rec."NS_No." <> '' then begin
            if rec."NS_Manual Retention Amount" = 0 then begin
                CalcFields(Rec.NS_RetentionBaseAmt);
                Rec.NS_RetentionAmt := (Rec.NS_RetentionBaseAmt * Rec."NS_Work Retention Percent") / 100;
                // rec.Modify();//PE-183.AS.2.0 COMMENT
            end;

            if rec."NS_Manual Retention Amount" <> 0 then begin
                Rec.NS_RetentionAmt := 0;
                // rec.Modify();//PE-183.AS.2.0 COMMENT
            end;
        end;
        //PE-183.AS.1.0 END
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        PBHeader: Record "NS_Progress Billing Header";
        OK: Boolean;
    begin
        PBHeader.RESET;
        PBHeader.SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
        PBHeader.SETRANGE("NS_No.", "NS_No.");
        PBHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." + 1);
        if PBHeader.FINDFIRST then
            ERROR(Text002Lbl);

        OK := CONFIRM(Text003Lbl, false, FORMAT("NS_Requisition No."), "NS_No.");

        if not OK then
            ERROR(Text007Lbl);
    end;

    trigger OnInit();
    begin
        FinalEditable := true;
        ManualRetentionAmountEditable := true;
        MaterialRetentionPercentEditab := true;
        "Work Retention %Editable" := true;
        "Round AmountsEditable" := true;
        StatusEditable := true;
        "Period ToEditable" := true;
        "Requisition DateEditable" := true;
        "Arch Eng Contact CodeEditable" := true;
        "Arch Eng Contact TypeEditable" := true;
        "Owner Contact CodeEditable" := true;
        "Owner Contact TypeEditable" := true;
        "Subcontract No.Editable" := true;
        "No.Editable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        ProgressPaymentHeader.RESET;
        ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
        if ProgressPaymentHeader.FINDFIRST then
            ERROR(Text001Lbl)
        else begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
        end;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if "NS_Subcontract No." <> xRec."NS_Subcontract No." then
            with ProgressPaymentHeader do begin
                ProgressPaymentHeader.RESET();
                SETRANGE("NS_No.", "NS_No.");
                if FINDSET then
                    repeat
                        "NS_Subcontract No." := Rec."NS_Subcontract No.";
                        MODIFY;
                    until NEXT = 0;
            end;

        NS_CalculateRequisition(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        PurchaseHeader: Record "Purchase Header";
        Job: Record Job;
        ProgressPaymentHdr: Record "NS_Progress Payment Header";
    begin
        SubcontractName := '';
        VendorNo := '';
        VendorName := '';
        JobName := '';

        if not Subcontract.GET("NS_No.") then
            ERROR(Text005Lbl, Text050Lbl, "NS_No.");

        PurchaseHeader.SETCURRENTKEY("NS_Subcontract No.");
        PurchaseHeader.SETFILTER("NS_Subcontract No.", Subcontract."NS_No.");

        if PurchaseHeader.FINDFIRST then begin
            "NS_Subcontract No." := Subcontract."NS_No.";
            SubcontractName := Subcontract.NS_Description;
            if PurchaseHeader."NS_Job No." > '' then begin
                Job.GET(PurchaseHeader."NS_Job No.");
                "NS_Job No." := PurchaseHeader."NS_Job No.";
                JobName := Job.Description
            end else
                ERROR(Text004Lbl, Text051Lbl);
            if PurchaseHeader."Buy-from Vendor No." > '' then begin
                VendorNo := PurchaseHeader."Buy-from Vendor No.";
                VendorName := PurchaseHeader."Buy-from Vendor Name";
            end else
                ERROR(Text004Lbl, Text052Lbl);
            "NS_Purchase Order No." := PurchaseHeader."No.";
        end;

        "NS_Round Amounts" := JobsSetup."NS_Prog Pay Rounding";
        "NS_Owner Contact Type" := "NS_Owner Contact Type"::Owner;
        "No.Editable" := true;

        if GETFILTER("NS_Subcontract No.") <> '' then
            if ("NS_No." = '') and ("NS_Requisition No." = 0) then begin
                "NS_No." := GETFILTER("NS_Subcontract No.");
                "NS_Requisition No." := 1;
            end;
        CurrPage.UPDATE();
    end;

    trigger OnOpenPage();
    begin
        //SETFILTER(NS_Status, Text054Lbl);//PRJ-1111.AS.1.0
        JobsSetup.GET;
    end;

    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        Subcontract: Record NS_Subcontract;
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        VendorNo: Code[20];
        LineRetention: Boolean;
        GetContractForProgressPay: Report "NS_Get Contact forProgressBill";
        GetPaymentForecast: Report "NS_Get Billing Forecast";
        JobName: Text[50];
        VendorName: Text[50];
        [InDataSet]
        "No.Editable": Boolean;
        [InDataSet]
        "Subcontract No.Editable": Boolean;
        [InDataSet]
        "Owner Contact TypeEditable": Boolean;
        [InDataSet]
        "Owner Contact CodeEditable": Boolean;
        [InDataSet]
        "Arch Eng Contact TypeEditable": Boolean;
        [InDataSet]
        "Arch Eng Contact CodeEditable": Boolean;
        [InDataSet]
        "Requisition DateEditable": Boolean;
        [InDataSet]
        "Period ToEditable": Boolean;
        [InDataSet]
        StatusEditable: Boolean;
        [InDataSet]
        "Round AmountsEditable": Boolean;
        [InDataSet]
        "Work Retention %Editable": Boolean;
        [InDataSet]
        MaterialRetentionPercentEditab: Boolean;
        [InDataSet]
        ManualRetentionAmountEditable: Boolean;
        [InDataSet]
        FinalEditable: Boolean;
        Text001Lbl: Label 'UNKNOWN!!';
        Text002Lbl: Label 'This is not the last requisition in the series.\Only the last requisition in the series can be deleted.';
        Text003Lbl: Label 'WARNING!\\This function will DELETE all versions of requisition %1  for Progress Payment No. %2.\\Any purchase documents, posted and unposted, will remain as they are.  However all the detail of how those documents were generated will be lost.\\If this is what is needed, click Yes.\If this is not desired, click No.\\Do you want to delete Requisition %1?';
        Text004Lbl: Label 'A %1 has not been entered on the Purchase Order.';
        Text005Lbl: Label 'The %1 %2 does not exist', Comment = '%1=PP_No.';
        Text007Lbl: Label 'Deletion has been halted.';
        Text008Lbl: Label 'A value cannot be entered here because there are retention values in the line items.';
        Text009Lbl: Label 'There are already requisitions for this job.\\Use the new menu to make a new requisition or version.';
        Text010Lbl: Label 'You cannot set the status to VOID. Create a new version or set the value of this version to zero.';
        Text011Lbl: Label 'This function can only be run on Open versions.';
        // Text013Lbl: Label 'The Period To date is not filled in.'; //PRJCTPR-286.PS.1.0 10Jan2024 Commented
        Text013Lbl: Label 'The Period To date and  The Requisition Date is not filled in.';//PRJCTPR-286.PS.1.0 10Jan2024 
        Text019Lbl: Label 'This is a VOID requisition.';
        Text050Lbl: Label 'Subcontract No.';
        Text051Lbl: Label 'Job No.';
        Text052Lbl: Label 'Buy-from Vendor No.';
        Text053Lbl: Label 'Purchase Order';
        Text054Lbl: Label '<> Void';

        SubcontractName: Text[50];
        Text014Lbl: Label 'Are you certain you want to update the Purchase Order for this requisition?';
        Text50000: Label 'You can only create a new Requisition when the current requisition is Invoiced';
        Text50001: Label 'You can only create a new Version when the current requisition has NOT been Invoiced.';
    // << Upgrade

    procedure GetVendorName();
    begin
        VendorNo := Subcontract."NS_Buy-from Vendor No.";
        if Vendor.GET(Subcontract."NS_Buy-from Vendor No.") then
            VendorName := Vendor.Name
        else
            VendorName := Text001Lbl;
    end;

    procedure NS_CheckLineWorkRetention();
    begin
        LineRetention := false;
        ProgressPaymentLine.RESET;
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressPaymentLine.FINDSET then
            repeat
                if (ProgressPaymentLine."NS_Work Retention Percent" <> 0) or
                   (ProgressPaymentLine."NS_Work Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressPaymentLine.NEXT = 0;

        //if LineRetention then //PRJ-1194.NK.1.0 15Mar2022 Block
        // ERROR(Text008LBL); //PRJ-1194.NK.1.0 15Mar2022 Block

        NS_UpdateLines;
    end;

    procedure NS_CheckLineMaterialRetention();
    begin
        LineRetention := false;
        ProgressPaymentLine.RESET;
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressPaymentLine.FINDSET then
            repeat
                if (ProgressPaymentLine."NS_Material Retention Percent" <> 0) or
                   (ProgressPaymentLine."NS_Material Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressPaymentLine.NEXT = 0;

        if LineRetention then
            ERROR(Text008Lbl);

        NS_UpdateLines;
    end;

    procedure NS_UpdateLines();
    begin
        ProgressPaymentLine.RESET;
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressPaymentLine.FINDSET then
            repeat
                if Rec."NS_Work Retention Percent" <> 0 then //PRJ-1194.NK.1.1 30Mar2022
                    ProgressPaymentLine.Validate("NS_Work Retention Percent", Rec."NS_Work Retention Percent"); //PRJ-1194.NK.1.1 30Mar2022
                ProgressPaymentLine.VALIDATE(NS_Quantity);
                MODIFY;
            until ProgressPaymentLine.NEXT = 0;
    end;

    procedure NS_RoundingRecalculate();
    begin
        ProgressPaymentLine.RESET;
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressPaymentLine.FINDSET then
            repeat
                ProgressPaymentLine.VALIDATE(NS_Quantity);
                ProgressPaymentLine.MODIFY;
            until ProgressPaymentLine.NEXT = 0;
        CurrPage.UPDATE(false);
    end;

    procedure NS_CalcTotals();
    begin
        MODIFY;

        ProgressPaymentLine.RESET;
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressPaymentLine.FINDSET then
            repeat
                ProgressPaymentLine.VALIDATE(NS_Quantity);
                ProgressPaymentLine.MODIFY;
            until ProgressPaymentLine.NEXT = 0;
        CurrPage.UPDATE(false);
    end;

    local procedure NS_SubcontractNoOnAfterValidate();
    begin
        if Subcontract.GET("NS_Subcontract No.") then begin
            SubcontractName := Subcontract.NS_Description;
            GetVendorName;
            "NS_Job No." := Subcontract."NS_Job No.";
            JobName := '';
            if Job.GET("NS_Job No.") then
                JobName := Job.Description;
            if "NS_Work Retention Percent" = 0 then
                "NS_Work Retention Percent" := Subcontract."NS_DefaultSubcontractRetention";
            if "NS_Material Retention Percent" = 0 then
                if JobsSetup."NS_Calc ReceivableRetBeforeTax" then
                    if (JobsSetup."NS_A/P RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/P RetentionTaxCalcMethod"::"2 - Calc tax on purchase then apply retention amount") or
                       (JobsSetup."NS_A/P RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount") then
                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
        end else begin
            SubcontractName := '';
            VendorNo := '';
            VendorName := '';
            JobName := '';
        end;

        MODIFY;
    end;

    local procedure NS_RoundAmountsOnAfterValidate();
    begin
        MODIFY;
        NS_RoundingRecalculate();
    end;

    local procedure NS_OwnerContactTypeOnAfterValidat();
    begin
        if "NS_Owner Contact Type" <> xRec."NS_Owner Contact Type" then
            "NS_Owner Contact Code" := '';
    end;

    local procedure NS_WorkRetentionPercentOnAfterVal();
    begin
        NS_UpdateLines();
    end;

    local procedure NS_MaterialRetentionPercentOnAfte();
    begin
        NS_UpdateLines();
    end;
}

