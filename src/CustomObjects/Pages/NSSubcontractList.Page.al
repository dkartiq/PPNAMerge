page 14021302 "NS_Subcontract List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    // +------------------------------------------------------------
//PE-182.HS.1.0 5Oct2023 | Added new Fields and their calculation
    //PE-182 11Oct2023| Added Tooltips
    Caption = 'Subcontract List';
    CardPageID = "NS_Subcontract Card";
    DataCaptionFields = "NS_No.";
    PageType = List;
    SourceTable = NS_Subcontract;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

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
                field("NS_Subcon Class"; "NS_Subcon Class")//PRJ-533.AS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcon Class';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Description"; Job.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job.Description';
                }
                field("Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Name';
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
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
                field("Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Cost) (LCY)';
                    Visible = false;
                }
                field("Subcontract Usage Cost (LCY)"; Rec."NS_SubcontractUsageCost(LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract Usage Cost (LCY)';
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
                    //ToolTip = 'Specifies the Invoice Recevied'; //PE-182 11Oct2023 Commented
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
                    //ToolTip = 'Specifies the retention held amount.';
                    ToolTip = 'Specifies retention amount yet to be paid.';
                    //Caption = 'Retention Amount';
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
                //PE-177.DK.1.0 10Nov2023 Start
                field("NS_Manager Subcontract Status"; Rec."NS_Manager Subcontract Status")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                //PE-177.DK.1.0 10Nov2023  End
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Subcontract")
            {
                Caption = '&Subcontract';
                action("NS_Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(NS_Quote),
                                  "No." = FIELD("NS_No.");
                    ToolTip = 'View comments';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("NS_Dimensions-Single")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(14021300),
                                      "No." = FIELD("NS_No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View/edit dimensions.';
                    }
                    action("NS_Dimensions-&Multiple")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-&Multiple';
                        ToolTip = 'View/edit dimensions.';

                        trigger OnAction();
                        var
                            Subcontract: Record NS_Subcontract;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Subcontract);
                            DefaultDimMultiple.SetMultiSubContract(Subcontract);
                            DefaultDimMultiple.RUNMODAL();
                        end;
                    }
                }
                action("NS_Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = Page "NS_Subcontract Ledger Entries";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    RunPageView = SORTING("NS_Subcontract No.", "NS_Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View subcontract ledger entries.';
                }
            }
        }
        area(reporting)
        {
            action("NS_Subcontract Status by Vendor")
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Vendor';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status byVendor";
                ToolTip = 'Run Subcontract Status by Vendor report.';
            }
            action("NS_Subcontract Status by Job")
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Job';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status by Job";
                ToolTip = 'Run Subcontract Status by Job report.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SubcontractDescription := '';
        VendorNo := '';
        VendorName := '';
        if "NS_No." <> '' then
            if Subcontract.GET("NS_No.") then begin
                SubcontractDescription := Subcontract.NS_Description;
                VendorNo := Subcontract."NS_Buy-from Vendor No.";
                if VendorNo <> '' then
                    if Vendor.GET(VendorNo) then
                        VendorName := Vendor.Name;
            end;
        //PE-182.HS.1.0 5Oct2023  Start
        NS_CalcStatistics;
        NS_NetAmt := NS_InvoiceReceived[3] - NS_RetentionAmt[3];
        NS_BalanceDue := NS_InvoiceReceived[3] - NS_PaymentMade[3];
        //PE-182.HS.1.0 5Oct2023 End
    end;

    trigger OnOpenPage();
    begin
        if VendorNo > '' then
            SETRANGE("NS_Buy-from Vendor No.", VendorNo);
            if NS_PurchSetup.GET() then; //PE-182.HS.1.0 5Oct2023
        if NS_JobsSetup.Get() then;  //PE-182.HS.1.0 5Oct2023
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


    var
        Job: Record Job;
        Subcontract: Record NS_Subcontract;
        Vendor: Record Vendor;
        VendorNo: Code[20];
        SubcontractDescription: Text[50];
        VendorName: Text[100]; //PRJ-301.MS.1.0

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

    procedure NS_SetVendor(VendNo: Code[20]);
    begin
        VendorNo := VendNo;
    end;
}

