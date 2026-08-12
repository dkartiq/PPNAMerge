page 14021305 "NS_Job Subcontract List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1154.JS.1.0 09MAR2022 | Make New Subcontract Buttom visible false
    //PE-182.HS.1.0 5Oct2023 | Added new Fields and their calculation
    //PE-182 11Oct2023 | Added Tooltips
    Caption = 'Job Subcontract List';
    CardPageID = "NS_Subcontract Card";
    DataCaptionFields = "NS_Job No.";
    Editable = false;
    PageType = List;
    SourceTable = NS_Subcontract;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    //ContextSensitiveHelpPage = 'user-guide/subcontracts/subcontract-management/'; //PRJ-1085.RM.1.0 16Dec2021
    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Buy-from Vendor No."; Rec."NS_Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                }
                field("Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
                //PRJCTPR-235.JS.1.0 24JAN2024 - Start
                field("NS_Subcon Class"; Rec."NS_Subcon Class")
                {
                    caption = 'Subcon Class';
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the class/type of subcontract document';
                }
                //PRJCTPR-235.JS.1.0 24JAN2024 - end
                field("Ending Date"; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ending Date';
                }
                field("Completion Date"; Rec."NS_Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Completion Date';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Person Responsible';
                }
                field("Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budgeted Cost (LCY)';
                }
                field("Invoiced Cost (LCY)"; Rec."NS_Invoiced Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Cost (LCY)';
                }
                field("Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Cost) (LCY)';
                    Visible = false;
                }
                field("Sub-Level to Subcontract No."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub-Level to Subcontract No.';
                }

                //PE-182.HS.1.0 5Oct2023 Start
                field(InvoiceReceivedJTD; NS_InvoiceReceived[3])
                {
                    ApplicationArea = All;
                    Editable = false;
                    //ToolTip = 'Specifies the Invoice Recevied'; //PE-182 11Oct2023
                    ToolTip = 'Specifies total invoiced amount including retainage.'; //PE-182 11Oct2023
                    Caption = 'Invoiced Amount';
                    trigger OnDrillDown();
                    begin
                        NS_ShowVLEntries.RESET();
                        NS_ShowVLEntries.SetCurrentKey("NS_Subcontract No.");
                        NS_ShowVLEntries.SETRANGE("NS_Subcontract No.", rec."NS_No.");
                        NS_ShowVLEntries.SETFILTER("Document Type", '<>%1', NS_ShowVLEntries."Document Type"::Payment);
                        page.Run(0, NS_ShowVLEntries);
                        CLEAR(NS_ShowVLEntries)
                    end;
                }
                field(NS_RetentionAmt; NS_RetentionAmt[3])
                {
                    ApplicationArea = All;
                    Caption = 'Retention Amount';
                    ToolTip = 'Specifies total Retention to be paid.';
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        NS_ShowVLEntries.RESET();
                        NS_ShowVLEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                        NS_ShowVLEntries.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        NS_ShowVLEntries.SETFILTER("Document Type", '<>%1', NS_ShowVLEntries."Document Type"::Payment);
                        page.Run(0, NS_ShowVLEntries);
                        CLEAR(NS_ShowVLEntries)
                    end;
                }
                field(PaymentMadeJTD; NS_PaymentMade[3])
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the payment made amount.';
                    Caption = 'Payment Made Amount';
                }
                field(NS_NetAmount; NS_NetAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Net Amount';
                    ToolTip = 'Specifies the difference between Invoiced Amount and Retainage.'; //PE-182 11Oct2023
                    Editable = false;
                }
                field(RetentionHeldJTD; NS_RetentionHeld[3])
                {
                    ApplicationArea = All;
                    //PE-182 11Oct2023 START
                    // ToolTip = 'Specifies the retention held amount.'; 
                    ToolTip = 'Specifies retention amount yet to be paid.';
                    // Caption = 'Retention Amount';
                    Caption = 'Retention Balance';
                    //PE-182 11Oct2023 END
                    Editable = false;

                    trigger OnDrillDown();
                    begin
                        NS_ShowVLEntries.RESET();
                        NS_ShowVLEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                        NS_ShowVLEntries.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
                        page.Run(0, NS_ShowVLEntries);
                        CLEAR(NS_ShowVLEntries)
                    end;
                }
                field(NS_BalanceDue; NS_BalanceDue)
                {
                    ApplicationArea = All;
                    caption = 'Balance Due';
                    ToolTip = 'Specifies the difference between the Invoice Amount (including Retainage) and the Payment made against it.'; //PE-182 11Oct2023
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        NS_ShowVLEntries.RESET();
                        NS_ShowVLEntries.SETRANGE("Vendor No.", rec."NS_Buy-from Vendor No.");
                        NS_ShowVLEntries.SETRANGE("NS_Subcontract No.", rec."NS_No.");
                        NS_ShowVLEntries.SETRANGE(Open, true);
                        page.Run(0, NS_ShowVLEntries);
                        CLEAR(NS_ShowVLEntries)
                    end;
                }
                //PE-182.HS.1.0 5Oct2023 End
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_New Subcontract Card")
            {
                ApplicationArea = All;
                Caption = 'New Subcontract';
                Image = NewDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;     //PRJ-1154.JS.1.0 09MAR2022
                //SMPL RunPageMode = Create;
                ToolTip = 'Create a new subcontract.';

                trigger OnAction();
                var
                    Subcontract: Record NS_Subcontract;
                    SubcontractCard: Page "NS_Subcontract Card";
                begin
                    Subcontract.INIT();
                    Subcontract.VALIDATE("NS_Job No.", JobNo);
                    Subcontract.INSERT(true);

                    SubcontractCard.SETRECORD(Subcontract);
                    SubcontractCard.RUN();
                    NS_JobMark();
                end;

            }
            action("NS_Subcontract Card")
            {
                ApplicationArea = All;
                Caption = 'Subcontract';
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "NS_Subcontract Card";
                RunPageLink = "NS_No." = FIELD(FILTER("NS_No."));
                RunPageOnRec = true;
                ToolTip = 'View the subcontract card.';
            }
        }
    }

    //PE-182.HS.1.0 5Oct2023  Start
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        NS_CalcStatistics;
        NS_NetAmt := NS_InvoiceReceived[3] - NS_RetentionAmt[3];
        NS_BalanceDue := NS_InvoiceReceived[3] - NS_PaymentMade[3];
    end;
    //PE-182.HS.1.0 5Oct2023 End

    trigger OnOpenPage();
    begin
        if JobNo > '' then begin
            JobFilter := JobNo;
            NS_JobMark();
        end;
        if NS_PurchSetup.GET() then; //PE-182.HS.1.0 5Oct2023
        if NS_JobsSetup.Get() then;  //PE-182.HS.1.0 5Oct2023
    end;

    var
        Subcontract: Record NS_Subcontract;
        SubcontractDetail: Record "NS_Subcontract Lines";
        JobFilter: Text[250];
        JobNo: Code[20];

        //PE-182.HS.1.0 5Oct2023 Start
        NS_InvoiceReceived: array[3] of Decimal;
        NS_RetentionHeld: array[3] of Decimal;
        NS_PaymentMade: array[3] of decimal;
        NS_RetentionAmt: array[3] of Decimal;
        NS_NetAmt: Decimal;
        NS_BalanceDue: Decimal;
        NS_NetAmount: array[3] of Decimal;
        "NS_Sub-Levels": Boolean;
        NS_VendorLedgEntryRetention: Record "Vendor Ledger Entry";
        NS_SourceCodeSetup: Record "Source Code Setup";
        NS_DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        NS_VendorLedgEntry: Record "Vendor Ledger Entry";
        NS_JobsSetup: Record "Jobs Setup";
        NS_ShowVLEntries: Record "Vendor Ledger Entry";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NSSubcontractCalc: Record NS_Subcontract;
    //PE-182.HS.1.0 5Oct2023 End

    procedure NS_JobMark();
    begin
        RESET();
        if JobFilter > '' then begin
            with Subcontract do begin
                RESET();
                SETFILTER("NS_Job No.", JobFilter);
                if FINDSET() then
                    repeat
                        if Rec.GET("NS_No.") then
                            Rec.MARK(true);
                    until NEXT() = 0;
            end;
            MARKEDONLY(true);
        end;
    end;

    procedure NS_Set(JobNoIn: Code[20]);
    begin
        JobNo := JobNoIn;
    end;

    local procedure NS_JobFilterOnAfterValidate();
    begin
        NS_JobMark();
    end;

    //PE-182.HS.1.0 5Oct2023  Start
    procedure NS_CalcStatistics();
    begin
        "NS_Sub-Levels" := true;
        NSSubcontractCalc := Rec;
        NSSubcontractCalc.RESET;
        CLEAR(NS_InvoiceReceived);
        NS_VendorLedgEntry.RESET();
        NS_VendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        NS_VendorLedgEntry.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
        NS_VendorLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
        NS_VendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
        NS_VendorLedgEntry.SetRange("NS_Retention Document", false);
        if NS_VendorLedgEntry.FINDFIRST() then
            repeat
                NS_VendorLedgEntry.CALCFIELDS("Amount (LCY)");
                NS_InvoiceReceived[3] := NS_InvoiceReceived[3] - NS_VendorLedgEntry."Purchase (LCY)";
            until NS_VendorLedgEntry.NEXT() = 0;
        if "NS_Sub-Levels" then
            NS_InvoiceReceived[3] := NS_InvoiceReceived[3] + Rec.NS_SLsInvoicedCost(NSSubcontractCalc);

        CLEAR(NS_PaymentMade);
        NS_SourceCodeSetup.GET();
        NS_DetailedVendorLedgEntry.RESET();
        NS_DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        NS_DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", NSSubcontractCalc."NS_No.");
        NS_DetailedVendorLedgEntry.SETRANGE("Source Code", NS_SourceCodeSetup."Payment Journal");
        NS_DetailedVendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
        NS_DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        NS_PaymentMade[3] := NS_DetailedVendorLedgEntry."Amount (LCY)";
        if "NS_Sub-Levels" then
            NS_PaymentMade[3] := NS_PaymentMade[3] + Rec.NS_SLsPaymentMade(NSSubcontractCalc);

        CLEAR(NS_RetentionHeld);
        NS_VendorLedgEntryRetention.RESET();
        NS_VendorLedgEntryRetention.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        NS_VendorLedgEntryRetention.SETRANGE("NS_Subcontract No.", NSSubcontractCalc."NS_No.");
        NS_VendorLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
        NS_VendorLedgEntryRetention.SETRANGE("Posting Date", 0D, WORKDATE);
        if NS_VendorLedgEntryRetention.FINDFIRST() then
            repeat
                NS_VendorLedgEntryRetention.CALCFIELDS("Remaining Amount");
                NS_RetentionHeld[3] -= NS_VendorLedgEntryRetention."Remaining Amount";
            until NS_VendorLedgEntryRetention.NEXT() = 0;

        CLEAR(NS_RetentionAmt);
        NS_VendorLedgEntryRetention.RESET();
        NS_VendorLedgEntryRetention.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        NS_VendorLedgEntryRetention.SETRANGE("NS_Subcontract No.", NSSubcontractCalc."NS_No.");
        NS_VendorLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Payable Ledger");
        NS_VendorLedgEntryRetention.SETRANGE("Posting Date", 0D, WORKDATE);
        NS_VendorLedgEntryRetention.SETFILTER("Document Type", '<>%1', NS_ShowVLEntries."Document Type"::Payment);
        if NS_VendorLedgEntryRetention.FINDFIRST() then
            repeat
                NS_VendorLedgEntryRetention.CALCFIELDS("Amount");
                NS_RetentionAmt[3] -= NS_VendorLedgEntryRetention.Amount;
            until NS_VendorLedgEntryRetention.NEXT() = 0;
    end;
    //PE-182.HS.1.0 5Oct2023 End

    //SMPL Page run in create mode by default
}

