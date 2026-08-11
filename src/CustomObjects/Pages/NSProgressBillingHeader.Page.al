page 14021325 "NS_Progress Billing Header"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +  - GLEI-11.MS.1.0001 added new action of Progress Invoice with unit	
    //PRJ-203:AS:21APRIL2020 Duplicated GLEI-11 work
    //CTSI-41.AS.1.0 08MAY2020 Added New action to run report "AIA G703 - Revenue wise"
    //CTSI-41.AS.1.0 13May2020 : Changed Caption
    //CTSI-41.AS.1.0 21MAY2020 Added Revenue Category Description Field.
    // +------------------------------------------------------------
    //PRJ-301.AS.1.0 : Increased length of chars
    //PPAL-106.AS.1.0 13AUG20 Done code in Progress billing header to modify work retention percent on progress billing line & also commented an error
    //CTSI-105.AS.1.0 Done code in Progress billing header to modify work retention percent on progress billing line & also commented an error //PPAL-106
    //CTSI-121.N.S.1.0 18Aug2020 add field manager & person responsible
    // Code Commented PRJ-338.AS.1.0 08Sept2020 Commented code
    //PRJ-764.RS.1.0 30June21 | Voided progress billings not viewable
    //PRJ-820.JS.1.0�03Aug2021 | Add action button Suggest Billing by Task under Functions   
    //PRJ-858.GK.1.0 24Aug2021 | Add action for Combined AIA G702 and AIA G703. 
    Caption = 'Progress Billing';
    PageType = Card;
    SourceTable = "NS_Progress Billing Header";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

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
                        ProgressBillingHeader.RESET();
                        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                        if ProgressBillingHeader.FINDFIRST() then
                            ERROR(Text009Lbl)
                        else begin
                            "NS_Requisition No." := 1;
                            "NS_Version No." := 0;
                        end;

                        if STRLEN("NS_Job No.") > 0 then
                            if Job.GET("NS_Job No.") then begin
                                JobName := Job.Description;
                                NS_GetCustomerName();
                                if "NS_Work Retention Percent" = 0 then
                                    "NS_Work Retention Percent" := Job."NS_Default Job Retention";
                                if "NS_Material Retention Percent" = 0 then
                                    if (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                                       (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then
                                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
                            end else begin
                                JobName := '';
                                CustomerNo := '';
                                CustomerName := '';
                            end;
                    end;
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition No.';

                    ToolTip = 'Requisition No.';
                    Editable = false;
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    Caption = 'Version No.';

                    ToolTip = 'Version No.';
                    Editable = false;
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';

                    ToolTip = 'Job No.';
                    Editable = "Job No.Editable";

                    trigger OnValidate();
                    begin
                        NS_JobNoOnAfterValidate();
                    end;
                }
                field(JobName; JobName)
                {
                    ApplicationArea = All;
                    Caption = 'Job Name';

                    ToolTip = 'Job Name';
                    Editable = false;
                }
                field("Draw No."; Rec."NS_Draw No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Draw No.';
                }
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';

                    ToolTip = 'Customer No.';
                    Editable = false;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';

                    ToolTip = 'Customer Name';
                    Editable = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 Start
                field(Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the manager';
                }
                field(ManagerName; ManagerName)
                {
                    ApplicationArea = All;
                    Caption = 'Manager Name';
                    Editable = false;


                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Person Responsible';
                }
                field(PersonResponsibleName; PersonResponsibleName)
                {
                    ApplicationArea = all;
                    Caption = 'Person Responsible Name';
                    Editable = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 End
                field("Round Amounts"; Rec."NS_Round Amounts")
                {
                    ApplicationArea = All;
                    Editable = "Round AmountsEditable";
                    ToolTip = 'Specifies the Round Amounts';

                    trigger OnValidate();
                    begin
                        NS_RoundAmountsOnAfterValidate();
                    end;
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    Caption = 'Final';

                    ToolTip = 'Final';
                    Editable = FinalEditable;
                }
                field("Owner Contact Type"; Rec."NS_Owner Contact Type")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Contact';

                    ToolTip = 'Owner Contact';
                    Editable = "Owner Contact TypeEditable";

                    trigger OnValidate();
                    begin
                        NS_OwnerContactTypeOnAfterValidat();
                    end;
                }
                field("Owner Contact Code"; Rec."NS_Owner Contact Code")
                {
                    ApplicationArea = All;
                    Editable = "Owner Contact CodeEditable";
                    LookupPageID = "NS_Job Contacts List";
                    ToolTip = 'Specifies the Owner Contact Code';
                }
                field("Arch Eng Contact Type"; Rec."NS_Arch Eng Contact Type")
                {
                    ApplicationArea = All;
                    Caption = 'Arch/Eng Contact';

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

                    ToolTip = 'Status';
                    Editable = StatusEditable;

                    trigger OnValidate();
                    begin
                        if NS_Status = NS_Status::Void then
                            ERROR(Text010Lbl);
                    end;
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';

                    ToolTip = 'Document No.';
                    Editable = false;
                }
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Date';

                    ToolTip = 'Requisition Date';
                    Editable = "Requisition DateEditable";
                }
                field("Period To"; Rec."NS_Period To")
                {
                    Caption = 'Period To';

                    ToolTip = 'Period To';
                    ApplicationArea = All;
                    Editable = "Period ToEditable";
                }
            }
            part(Control16; "NS_Progress Billing Subform")
            {
                ApplicationArea = All;
                SubPageLink = "NS_Progress Billing No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No.");
                // SubPageView = ORDER(Ascending);
            }
            group(Retention)
            {
                Caption = 'Retention';
                field("Work Retention %"; Rec."NS_Work Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = "Work Retention %Editable";
                    ToolTip = 'Specifies the Work Retention Percent';

                    trigger OnValidate();
                    var
                        TProgBillLine: Record "NS_Progress Billing Line";//PPAL-106.AS.1.0 13AUG20	 //CTSI-105.AS.1.0
                    begin
                        //CTSI-105.AS.1.0 - START
                        //PPAL-106.AS.1.0 13AUG20 - START
                        TProgBillLine.Reset();
                        TProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        TProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        TProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        IF TProgBillLine.FindSet then
                            repeat
                                TProgBillLine."NS_Work Retention Percent" := rec."NS_Work Retention Percent";
                                TProgBillLine.Modify;
                                CurrPage.Update(false);
                            until TProgBillLine.Next = 0;
                        //CTSI-105.AS.1.0 - end
                        //PPAL-106.AS.1.0 13AUG20 - end

                        if "NS_Work Retention Percent" <> 0 then
                            NS_CheckLineWorkRetention();
                        NS_WorkRetentionPercentOnAfterVal();
                    end;
                }
                field("Material Retention Percent"; Rec."NS_Material Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Material Retention %';

                    ToolTip = 'Material Retention %';
                    Editable = MaterialRetentionPercentEditab;

                    trigger OnValidate();
                    begin
                        if "NS_Material Retention Percent" <> 0 then
                            NS_CheckLineMaterialRetention();
                        NS_MaterialRetentionPercentOnAfte();
                    end;
                }
                field("Manual Retention Amount"; Rec."NS_Manual Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = ManualRetentionAmountEditable;
                    ToolTip = 'Specifies the Manual Retention Amount';
                }
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
                action(NS_Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';

                    ToolTip = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "NS_Progress Billing Statistics";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                    ShortCutKey = 'F7';
                }
                action("NS_Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';

                    ToolTip = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "NS_ProgressBillingCommentSheet";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                }
            }
            group("NS_&Job")
            {
                Caption = '&Job';
                action(NS_Card)
                {
                    Caption = 'Card';

                    ToolTip = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("NS_Job No.");
                    ApplicationArea = All;
                }
                action("NS_Job Contacts")
                {
                    ApplicationArea = All;
                    Caption = 'Job Contacts';

                    ToolTip = 'Job Contacts';
                    Image = TeamSales;
                    RunObject = Page "NS_Job Contacts List";
                    RunPageLink = "NS_Job No." = FIELD("NS_Job No.");
                }
            }
        }
        area(processing)
        {
            action("NS_Price &Budget")
            {
                ApplicationArea = All;
                Caption = 'Price &Budget';

                ToolTip = 'Price &Budget';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Planning Lines";
                RunPageLink = "Job No." = FIELD("NS_Job No.");
                RunPageView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code")
                              ORDER(Ascending)
                              WHERE("Line Type" = FILTER(Billable | "Both Budget and Billable"));
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(NS_GetBillings)
                {
                    ApplicationArea = All;
                    Caption = 'Get Billings';

                    ToolTip = 'Get Billings';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        //JobPlanningLine: Record "Job Planning Line";
                        GetContract: Report "NS_Get Contact forProgressBill";
                        JobRec: Record Job;
                    begin
                        if "NS_No." > '' then
                            if NS_Status = NS_Status::Open then begin
                                if "NS_Job No." <> '' then
                                    JobRec.SETFILTER("No.", "NS_Job No.");
                                GetContract.SetParameters("NS_No.", "NS_Requisition No.", "NS_Version No.");
                                GetContract.SETTABLEVIEW(JobRec);
                                GetContract.RUNMODAL;
                                CLEAR(GetContract);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                action(NS_GetBillingForecase)
                {
                    ApplicationArea = All;
                    Caption = 'Get Billing Forecast';

                    ToolTip = 'Get Billing Forecast';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;
                    Visible = false;//PRJ-820
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            if NS_Status = NS_Status::Open then begin
                                GetBillingForecast.SetParameters("NS_No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.");
                                GetBillingForecast.RUNMODAL;
                                CLEAR(GetBillingForecast);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                action(NS_CopyComments)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Comments';

                    ToolTip = 'Copy Comments';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            NS_CopyCommentLines(Rec);
                    end;
                }
                action(NS_GetJobForecasts)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Forecasts';

                    ToolTip = 'Get Job Forecasts';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;
                    Visible = false;//PRJ-820
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            NS_GetJobForecast(Rec);
                    end;
                }

                //PRJ-820.JS.1.0�03Aug2021-Start
                action(NS_SuggestBillingByTask)
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Billing By Task';

                    ToolTip = 'Suggest Billing By Task on the basis of APO Link';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;

                    trigger OnAction();
                    begin
                        if Rec."NS_No." > '' then
                            if Rec.NS_Status = Rec.NS_Status::Open then begin
                                GetBillingByTask.SetParameters(Rec."NS_No.", Rec."NS_Requisition No.", Rec."NS_Version No.", Rec."NS_Job No.");
                                GetBillingByTask.RUNMODAL;
                                CLEAR(GetBillingByTask);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                //PRJ-820.JS.1.0�03Aug2021-end
                separator(Separator1000000004)
                {
                }
                action(NewRequisition)
                {
                    ApplicationArea = All;
                    Caption = 'New Requisition';

                    ToolTip = 'New Requisition';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        //Result := NewRequisition(Rec);
                        Result := PBNewDocument.NS_NewRequisition(Rec);
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

                    ToolTip = 'New Version';
                    Image = NewWarehouseShipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        if "NS_No." > '' then begin
                            //Result := NewVersion(Rec);
                            Result := PBNewDocument.NS_NewVersion(Rec);
                            if Result <> -1 then begin
                                SETRANGE("NS_Version No.", Result);
                                SETRANGE("NS_Version No.");
                            end;
                        end;
                    end;
                }
                separator(Separator1000000006)
                {
                }
                action(NS_MakeSalesDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Make Sales Document';

                    ToolTip = 'Make Sales Document';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            if NS_Status = NS_Status::Void then
                                MESSAGE(Text012Lbl)
                            else
                                if ("NS_Sales Document No." = '') and (NS_Status = NS_Status::Open) then begin
                                    if "NS_Period To" = 0D then
                                        ERROR(Text013Lbl);
                                    if CONFIRM(Text014Lbl, true) then
                                        //MakeReceivablesDocument(Rec);
                                        PBDocProcess.NS_MakeReceivablesDocument(Rec);
                                end else
                                    MESSAGE(Text015Lbl);
                    end;
                }
                action(NS_ViewSalesDocument)
                {
                    ApplicationArea = All;
                    Caption = 'View Sales Document';

                    tooltip = 'View Sales Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        SalesHeader: Record "Sales Header";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        if "NS_Sales Document No." > '' then
                            case "NS_Sales Document Type" of

                                "NS_Sales Document Type"::Order:
                                    if SalesHeader.GET(SalesHeader."Document Type"::Order, "NS_Sales Document No.") then
                                        PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader)
                                    else begin
                                        SalesInvoiceHeader.RESET();
                                        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", "NS_Sales Document No.");
                                        if SalesInvoiceHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader)
                                        else
                                            ERROR(Text016Lbl);
                                    end;

                                "NS_Sales Document Type"::Invoice:

                                    if SalesHeader.GET(SalesHeader."Document Type"::Invoice, "NS_Sales Document No.") then
                                        PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader)
                                    else begin
                                        SalesInvoiceHeader.RESET();
                                        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", "NS_Sales Document No.");
                                        if SalesInvoiceHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader)
                                        else
                                            ERROR(Text017Lbl);
                                    end;
                                "NS_Sales Document Type"::Credit:

                                    if SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", "NS_Sales Document No.") then
                                        PAGE.RUNMODAL(PAGE::"Sales Credit Memo", SalesHeader)
                                    else begin
                                        SalesCrMemoHeader.RESET();
                                        SalesCrMemoHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        SalesCrMemoHeader.SETRANGE("Pre-Assigned No.", "NS_Sales Document No.");
                                        if SalesCrMemoHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader)
                                        else
                                            ERROR(Text018Lbl);
                                    end;
                            end;
                    end;
                }
            }
            group("Prin&t")
            {
                Caption = 'Prin&t';
                action(NS_ProgressInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice';

                    ToolTip = 'Progress Invoice';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(JobsSetup."NS_ProgressBillStandardInvoice", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-203:AS:21APRIL2020 - start
                action(NS_ProgressInvoicewithunit)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice with Units';

                    ToolTip = 'Progress Invoice with Units';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        //GLEI-11.MS.1.0001 Added new action 
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(Report::"NS_Progress Billing with Units", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-203:AS:21APRIL2020 - end

                //CTSI-85.AS.1.0 26JUN2020 - Start
                action("NS_Progress invoice - Revenue Wise")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice-Rev. Cat. Summ';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::"NS_Progress Bill InvRevCatSumm", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE('This is a VOID requisition.');
                    end;
                }
                //CTSI-85.AS.1.0 26JUN2020 - End

                action(NS_AIAG702)
                {
                    ApplicationArea = All;
                    Caption = 'AIA G702';

                    ToolTip = 'AIA G702';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunPageOnRec = true;

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::"NS_AIA G702", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                action(NS_AIAG703)
                {
                    ApplicationArea = All;
                    Caption = 'AIA G703';

                    ToolTip = 'AIA G703';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::"NS_AIA G703", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //CTSI-41.AS.1.0 08MAY2020 - start
                action("NS_AIAG703 - Revenue Wise")
                {
                    ApplicationArea = All;
                    Caption = 'G703-Rev. Cat. Summ';//CTSI-41.AS.1.0 13May2020
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::"NS_AIA G703 - Revenue Wise", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE('This is a VOID requisition.');
                    end;
                }
                //CTSI-41.AS.1.0 08MAY2020 - End
                //PRJ-858.GK.1.0 24Aug2021 start 
                action("NS_Combined AIA G702 and AIA G703")
                {
                    ApplicationArea = All;
                    Caption = 'Combined AIA G702 and AIA G703';

                    ToolTip = 'Combined AIA G702 and AIA G703';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                        Prams: Text;
                        MyReport: Report "NS_AIA G702";
                    begin
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::NS_Combined_AIAG702andAIAG703, true, false, ProgressBillingHeader);

                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-858.GK.1.0 24Aug2021 end
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        if "NS_Requisition No." = 1 then begin
            ProgressBillingHeader.RESET();
            ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
            if ProgressBillingHeader.COUNT <= 1 then
                "No.Editable" := true
            else
                "No.Editable" := false;
        end else
            "No.Editable" := false;

        if NS_Status > NS_Status::Open then begin
            "Job No.Editable" := false;
            "Owner Contact TypeEditable" := false;
            "Owner Contact CodeEditable" := false;
            "Arch Eng Contact TypeEditable" := false;
            "Arch Eng Contact CodeEditable" := false;
            "Requisition DateEditable" := false;
            "Period ToEditable" := false;
            StatusEditable := false;
            "Round AmountsEditable" := false;
            "Work Retention %Editable" := false;
            MaterialRetentionPercentEditab := false;
            ManualRetentionAmountEditable := false;
        end else begin
            "Job No.Editable" := true;
            "Owner Contact TypeEditable" := true;
            "Owner Contact CodeEditable" := true;
            "Arch Eng Contact TypeEditable" := true;
            "Arch Eng Contact CodeEditable" := true;
            "Requisition DateEditable" := true;
            "Period ToEditable" := true;
            StatusEditable := true;
            "Round AmountsEditable" := true;
            // >> Upgrade

            // "Work Retention %Editable" := true;
            // MaterialRetentionPercentEditab := true;
            // << Upgrade
            ManualRetentionAmountEditable := true;
        end;

        if NS_Status <> NS_Status::Void then begin
            StatusEditable := true;
            FinalEditable := true;
        end;

        if NS_Final then
            FinalEditable := false
        else
            FinalEditable := true;

        if Job.GET("NS_Job No.") then begin
            JobName := Job.Description;
            NS_GetCustomerName();
            CustomerNo := Job."Bill-to Customer No.";
            if Customer.GET(Job."Bill-to Customer No.") then
                CustomerName := Customer.Name
            else
                CustomerName := Text001Lbl;
        end else begin
            JobName := '';
            CustomerNo := '';
            CustomerName := '';
        end;
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if ResourceRec.Get(NS_Manager) then
            ManagerName := ResourceRec.Name
        else
            ManagerName := '';
        if ResourceRec.Get("NS_Person Responsible") then
            PersonResponsibleName := ResourceRec.Name
        else
            PersonResponsibleName := '';
        //CTSI-121.N.S.1.0 18Aug2020 End;

    end;

    trigger OnDeleteRecord(): Boolean;
    var
        PBHeader: Record "NS_Progress Billing Header";
        OK: Boolean;
    begin
        PBHeader.RESET();
        PBHeader.SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
        PBHeader.SETRANGE("NS_No.", "NS_No.");
        PBHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." + 1);
        if PBHeader.FINDFIRST() then
            ERROR(Text002Lbl);

        OK := CONFIRM(Text003Lbl + FORMAT("NS_Requisition No.") + Text004Lbl + "NS_No." + Text005Lbl + FORMAT("NS_Requisition No.") + Text004Lbl + "NS_No." + Text006Lbl);

        if not OK then
            ERROR(Text007Lbl);
    end;

    trigger OnInit();
    begin
        FinalEditable := true;
        ManualRetentionAmountEditable := true;
        // >> Upgrade
        //MaterialRetentionPercentEditab := true;
        // MaterialRetentionPercentEditab := "Retention Type" = "Retention Type"::Cash; // #RG008
        // "Work Retention %Editable" := "Retention Type" = "Retention Type"::Cash; // #RG008
        // << Upgrade
        "Work Retention %Editable" := true;
        "Round AmountsEditable" := true;
        StatusEditable := true;
        "Period ToEditable" := true;
        "Requisition DateEditable" := true;
        "Arch Eng Contact CodeEditable" := true;
        "Arch Eng Contact TypeEditable" := true;
        "Owner Contact CodeEditable" := true;
        "Owner Contact TypeEditable" := true;
        "Job No.Editable" := true;
        "No.Editable" := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
    begin
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
        if ProgressBillingHeader.FINDFIRST() then
            ERROR(Text001Lbl)
        else begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
        end;
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if "NS_Job No." <> xRec."NS_Job No." then begin
            ;
            //            with ProgressBillingHeader do begin
            ProgressBillingHeader.reset();
            SETRANGE("NS_No.", "NS_No.");
            if FINDSET() then
                repeat
                    "NS_Job No." := Rec."NS_Job No.";
                    MODIFY();
                until NEXT() = 0;
        end;

        NS_CalculateRequisition(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        JobName := '';
        CustomerNo := '';
        CustomerName := '';
        "NS_Round Amounts" := JobsSetup."NS_Progress Billing Rounding";
        "NS_Owner Contact Type" := "NS_Owner Contact Type"::Owner;
        "No.Editable" := true;
        if (GETFILTER("NS_Job No.") <> '') and JobsSetup."NS_ProgressBillingFirstNo. Def" then
            if ("NS_No." = '') and ("NS_Requisition No." = 0) then begin
                "NS_No." := GETFILTER("NS_Job No.");
                "NS_Requisition No." := 1;
            end;
        if GETFILTER("NS_Job No.") <> '' then
            "NS_Job No." := GETFILTER("NS_Job No.");
    end;

    trigger OnOpenPage();
    begin
        //SETFILTER(NS_Status, '<> Void');//PRJ-764.RS.1.0 30June21 Commented
        JobsSetup.GET();
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if ResourceRec.Get(NS_Manager) then
            ManagerName := ResourceRec.Name
        else
            ManagerName := '';
        if ResourceRec.Get("NS_Person Responsible") then
            PersonResponsibleName := ResourceRec.Name
        else
            PersonResponsibleName := '';
        //CTSI-121.N.S.1.0 18Aug2020 End;
    end;
    // >> Upgrade
    protected var
        [InDataSet]
        "Work Retention %Editable": Boolean;
        [InDataSet]
        MaterialRetentionPercentEditab: Boolean;
    // << Upgrade
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        Customer: Record Customer;
        GetBillingForecast: Report "NS_Get Billing Forecast";
        GetContractForProgressBill: Report "NS_Get Contact forProgressBill";

        GetBillingByTask: Report "NS_Suggest Billing Task Lines";//PRJ-820
        PBDocProcess: Codeunit "NS_Progress BillingMakeSaleDoc";
        PBNewDocument: Codeunit "NS_Progress BillingNewDocument";

        CustomerNo: Code[20];
        LineRetention: Boolean;


        JobName: Text[100];//PRJ-301.AS.1.0 Increase length 50 to 100
        CustomerName: Text[100];//PRJ-301.AS.1.0 Increase length from 50 to 100 chars
        [InDataSet]


        "No.Editable": Boolean;
        [InDataSet]
        "Job No.Editable": Boolean;
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
        // >> Upgrade
        // [InDataSet]
        // "Work Retention %Editable": Boolean;

        // [InDataSet]
        // MaterialRetentionPercentEditab: Boolean;
        // << Upgrade
        [InDataSet]
        ManualRetentionAmountEditable: Boolean;
        [InDataSet]
        FinalEditable: Boolean;
        Text001Lbl: Label 'UNKNOWN!!';
        Text002Lbl: Label 'This is not the last requisition in the series.\Only the last requisition in the series can be deleted.';
        Text003Lbl: Label '"WARNING!\\This function will DELETE all versions of requisition "';
        Text004Lbl: Label '" for Progress Billing No. "';
        Text005Lbl: Label '"\\Any sales documents, posted and unposted, will remain as they are.  However all the detail of how those documents were generated will be lost.\\If this is what is needed, click Yes.\If this is not desired, click No.\\Do you want to delete Requisition "';
        Text006Lbl: Label '?';
        Text007Lbl: Label 'Deletion has been halted.';
        Text008Lbl: Label 'A value cannot be entered here because there are retention values in the line items.';
        Text009Lbl: Label 'There are already requisitions for this job.\\Use the new menu to make a new requisition or version.';
        Text010Lbl: Label 'You cannot set the status to VOID. Create a new version or set the value of this version to zero.';
        Text011Lbl: Label 'This function can only be run on Open versions.';
        Text012Lbl: Label 'This requisition is VOID and cannot be invoiced.';
        Text013Lbl: Label 'The Period To date is not filled in.';
        Text014Lbl: Label 'Are you certain you want to make a Sales Receivables Document for this requisition?';
        Text015Lbl: Label 'A Sales Receivables Document has already been generated for this requisition.';
        Text016Lbl: Label 'There is no sales order for this requisition.';
        Text017Lbl: Label 'There is no sales invoice for this requisition.';
        Text018Lbl: Label 'There is no sales credit memo for this requisition.';
        Text019Lbl: Label 'This is a VOID requisition.';
        ManagerName: Text[100];//CTSI-121.N.S.1.0 18Aug2020
        PersonResponsibleName: Text[100];//CTSI-121.N.S.1.0 18Aug2020
        ResourceRec: Record Resource; //CTSI-121.N.S.1.0 18Aug2020

    procedure NS_GetCustomerName();
    begin
        CustomerNo := Job."Bill-to Customer No.";
        if Customer.GET(Job."Bill-to Customer No.") then
            CustomerName := Customer.Name
        else
            CustomerName := Text001Lbl;
    end;

    procedure NS_CheckLineWorkRetention();
    begin
        LineRetention := false;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if (ProgressBillingLine."NS_Work Retention Percent" <> 0) or
                   (ProgressBillingLine."NS_Work Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressBillingLine.NEXT() = 0;

        // if LineRetention then
        //     ERROR(Text008Lbl);//PPAL-106.AS.1.0 13AUG20 Code commented

        NS_UpdateLines();
    end;

    procedure NS_CheckLineMaterialRetention();
    begin
        LineRetention := false;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if (ProgressBillingLine."NS_Material Retention Percent" <> 0) or
                   (ProgressBillingLine."NS_Material Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressBillingLine.NEXT() = 0;

        // if LineRetention then
        //     ERROR(Text008Lbl);// Code Commented PRJ-338.AS.1.0 08Sept2020

        NS_UpdateLines();
    end;

    procedure NS_UpdateLines();
    begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                MODIFY;
            until ProgressBillingLine.NEXT() = 0;
    end;

    procedure NS_RoundingRecalculate();
    begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                ProgressBillingLine.MODIFY();
            until ProgressBillingLine.NEXT() = 0;
        CurrPage.UPDATE(false);
    end;

    procedure NS_CalcTotals();
    begin
        MODIFY();

        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                ProgressBillingLine.MODIFY();
            until ProgressBillingLine.NEXT() = 0;
        CurrPage.UPDATE(false);
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        if Job.GET("NS_Job No.") then begin
            JobName := Job.Description;
            NS_GetCustomerName();
            if "NS_Work Retention Percent" = 0 then
                "NS_Work Retention Percent" := Job."NS_Default Job Retention";
            if "NS_Material Retention Percent" = 0 then
                if JobsSetup."NS_Calc ReceivableRetBeforeTax" then
                    if (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                       (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then
                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
        end else begin
            JobName := '';
            CustomerNo := '';
            CustomerName := '';
        end;
    end;

    local procedure NS_RoundAmountsOnAfterValidate();
    begin
        MODIFY();
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

