report 14021289 "NS_ProjectPro Rcvd NotInvoiced"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-59 : AS : 09 March 2020 : Use Detail_Total value TempPurchRcptLine.Quantity * TempPurchRcptLine."Unit Cost"
    //PRJ-59 : AS : 11 March 2020 : Added Start End, End Date Filters. 
    //PRJ-59.SK.1.0 Added code for removing repeatation of previous data
    //PRJ-59.MS.1.0 added code and modfiy layout of report
    //PRJ-493.MS.1.0 Changes new for qty recd. not inv.

    DefaultLayout = RDLC;
    //RDLCLayout = './ProjectPro Rcvd Not Invoiced.rdlc'; //PRJ-59.MS.1.0 Commented
    RDLCLayout = './Layouts/NSJob Received not Invoiced.rdl'; //PRJ-59.MS.1.0 Rename layout name
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Job Received not Invoiced'; //PRJ-59.MS.1.0 Added caption


    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            column(JobNo; Job."No.")
            {
            }
            column(JobManager; Job.NS_Manager)
            {
            }
            column(JobCustAddress; BilltoAddress)
            {
            }
            column(JobCustAddress2; BilltoAddress2)
            {
            }
            column(JobCustName; "Bill-to Name")
            {
            }
            column(JobCustPhone; BilltoPhone)
            {
            }
            column(JobDescription; Job.Description)
            {
            }
            dataitem("Job Cost Category"; "NS_Job Cost Category")
            {
                DataItemTableView = SORTING(NS_Code) ORDER(Ascending);
                column(JobCostCategory; NS_Code)
                {
                }
                column(JobCostCatDesc; NS_Description)
                {
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);
                    column(Detail_CostCategory; TempPurchRcptLine."NS_Job Cost Category")
                    {
                    }
                    column(Detail_DocNumber; TempPurchRcptLine."Document No.")
                    {
                    }
                    column(Detail_DocLineNum; TempPurchRcptLine."Line No.")
                    {
                    }
                    column(Detail_No; TempPurchRcptLine."No.")
                    {
                    }
                    column(Detail_Description; TempPurchRcptLine.Description)
                    {
                    }
                    column(Detail_Quantity; TempPurchRcptLine."Qty. Rcd. Not Invoiced" + TempPurchRcptLine."Quantity Invoiced" - TempPurchInvLine.Quantity)
                    {
                        //PRJ-493.MS.1.0 Changes forfula of qty
                    }
                    column(Detail_Rate; TempPurchRcptLine."Unit Cost")
                    {
                    }
                    column(Detail_Total; (TempPurchRcptLine."Qty. Rcd. Not Invoiced" + TempPurchRcptLine."Quantity Invoiced" - TempPurchInvLine.Quantity) * TempPurchRcptLine."Unit Cost")
                    {
                        //PRJ-59 : AS : 09 March 2020 :Used TempPurchRcptLine.Quantity * TempPurchRcptLine."Unit Cost"
                        //PRJ-59 : AS : 09 March 2020 : instead of LineAmount
                        //PRJ-493.MS.1.0 Changes forfula of total cost from quantity to new changes
                    }

                    trigger OnAfterGetRecord();
                    begin
                        RowCount += 1;
                        if RowCount = 1 then
                            TempPurchRcptLine.FINDFIRST()
                        else
                            TempPurchRcptLine.NEXT();
                    end;

                    trigger OnPreDataItem();
                    begin
                        TempPurchRcptLine.RESET();
                        //if ((StartDate <> 0D) and (EndDate <> 0D)) then//PRJ-493.MS.1.0 comment
                            TempPurchRcptLine.SetRange("Posting Date", StartDate, EndDate);//PRJ-59 : AS : 11 March 2020 Added Date Filter
                        TempPurchRcptLine.SETRANGE("NS_Job Cost Category", "Job Cost Category".NS_Code);

                        TempRcptLineCount := TempPurchRcptLine.COUNT;
                        RowCount := 0;
                        SETRANGE(Number, 1, TempRcptLineCount);
                    end;
                }
            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
                EntryNo: Integer;
            begin

                Clear(LineTotal);// Reset LineTotal Var
                if (Job."Bill-to Customer No." = '') then// or (TempPurchRcptLine."Document No." = '') then //PRJ-59.MS.1.0
                                                         //PRJ-59.MS.1.0 STart Commenting
                                                         // if Job."Bill-to Customer No." = '' then
                                                         //     CurrReport.SKIP;
                                                         //PRJ-59.MS.1.0 End Commenting 

                    //PRJ-59.MS.1.0 STart
                    if (Job."Bill-to Customer No." = '') or (TempPurchRcptLine.Quantity = 0) then
                        CurrReport.SKIP;
                //PRJ-59.MS.1.0 End
                Cust.GET(Job."Bill-to Customer No.");
                CLEAR(TempPurchRcptLine); //PRJ-59.SK.1.0 Added 
                TempPurchRcptLine.DELETEALL();
                CLEAR(TempPurchInvLine); //PRJ-493.MS.1.0
                TempPurchinvLine.DELETEALL;//PRJ-493.MS.1.0
                BilltoAddress := Job."Bill-to Address" + ', ' + Job."Bill-to Address 2";
                BilltoAddress2 := Job."Bill-to City" + ' ' + Job."Bill-to County" + ' ' + Job."Bill-to Post Code";
                BilltoPhone := 'Phone: ' + Cust."Phone No.";
                EntryNo := 0;

                CostCategory.RESET();
                if CostCatFilter <> '' then
                    CostCategory.SETFILTER(NS_Code, CostCatFilter);
                CostCategory.FINDSET();
                repeat
                    //PRJ-493.MS.1.0  start
                    PurchInvHeader.RESET;
                    PurchInvHeader.SETRANGE("NS_Job No.", Job."No.");
                    PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);
                    if PurchInvHeader.FINDSET then begin
                        repeat
                            PurchInvLine.RESET;
                            PurchInvLine.SETRANGE("Document No.", PurchInvHeader."No.");
                            PurchInvLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                            if JobTaskFilter <> '' then
                                PurchInvLine.SETFILTER("Job Task No.", JobTaskFilter);
                            if PurchInvLine.FINDSET then
                                repeat
                                    TempPurchInvLine.INIT;
                                    TempPurchInvLine := PurchInvLine;
                                    TempPurchInvLine.INSERT;
                                until PurchInvLine.NEXT = 0;

                        until PurchInvHeader.NEXT = 0;
                    end;
                    //PRJ-493.MS.1.0  end

                    PurchRecHeader.RESET();
                    PurchRecHeader.SETRANGE("NS_Job No.", Job."No.");
                    //if ((StartDate <> 0D) and (EndDate <> 0D)) then //PRJ-493.MS.1.0  comment
                        PurchRecHeader.SetRange("Posting Date", StartDate, EndDate);//PRJ-59 : AS : 11 March 2020 : Added Date filter
                    if PurchRecHeader.FINDSET() then begin
                        repeat
                            PurchRecLine.RESET();
                            PurchRecLine.SETRANGE("Document No.", PurchRecHeader."No.");
                            PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                            if JobTaskFilter <> '' then
                                PurchRecLine.SETFILTER("Job Task No.", JobTaskFilter);
                            //PurchRecLine.SETRANGE("Quantity Invoiced", 0);//PRJ-493.MS.1.0  comment
                            if PurchRecLine.FINDSET() then
                                repeat
                                    TempPurchRcptLine.INIT();
                                    TempPurchRcptLine := PurchRecLine;
                                    LineTotal := TempPurchRcptLine."Unit Cost" * TempPurchRcptLine.Quantity;
                                    TempPurchRcptLine.INSERT();
                                until PurchRecLine.NEXT() = 0;
                        until PurchRecHeader.NEXT() = 0;
                    end else begin
                        PurchRecLine.RESET();
                        PurchRecLine.SETRANGE("Job No.", Job."No.");
                        PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                        //if ((StartDate <> 0D) and (EndDate <> 0D)) then//PRJ-493.MS.1.0  comment
                            TempPurchRcptLine.SetRange("Posting Date", StartDate, EndDate);//PRJ-59 : AS
                        if JobTaskFilter <> '' then
                            PurchRecLine.SETFILTER("Job Task No.", JobTaskFilter);
                        PurchRecLine.SETRANGE("Quantity Invoiced", 0);
                        if PurchRecLine.FINDSET() then
                            repeat
                                TempPurchRcptLine.INIT();
                                TempPurchRcptLine := PurchRecLine;
                                LineTotal := TempPurchRcptLine."Unit Cost" * TempPurchRcptLine.Quantity;
                                TempPurchRcptLine.INSERT();
                            until PurchRecLine.NEXT() = 0;
                    end;
                until CostCategory.NEXT() = 0;
            end;

            trigger OnPreDataItem();
            begin
                if JobNoFilter <> '' then
                    SETFILTER("No.", JobNoFilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(JobTaskFilter; JobTaskFilter)
                {
                    Caption = 'Job Task No. Filter';
                    Lookup = true;
                    ApplicationArea = All;
                    ToolTip = 'Job Task No. Filter';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobTaskPage: Page "Job Task List";
                        JobTaskRec: Record "Job Task";
                    begin
                        JobTaskRec.RESET();
                        if JobNoFilter <> '' then
                            JobTaskRec.SETFILTER("Job No.", JobNoFilter);
                        JobTaskPage.LOOKUPMODE(true);
                        JobTaskPage.SETTABLEVIEW(JobTaskRec);
                        JobTaskPage.RUNMODAL;
                        JobTaskPage.GETRECORD(JobTaskRec);
                        JobTaskFilter := JobTaskRec."Job Task No.";
                    end;
                }
                field(CostCatFilter; CostCatFilter)
                {
                    Caption = 'Cost Category Filter';
                    TableRelation = "NS_Job Cost Category".NS_Code;
                    ApplicationArea = All;
                    ToolTip = 'Cost Category Filter';
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';//PRJ-59 : AS : 11 March 2020
                    ApplicationArea = All;
                    ToolTip = 'Start Date';
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';//PRJ-59 : AS : 11 March 2020
                    ApplicationArea = All;
                    ToolTip = 'End Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BilltoAddress: Text[120];
        BilltoAddress2: Text[120];
        BilltoPhone: Text[60];
        ActivityCodes: Text[1000];
        JobDescription: Text[1000];
        PurchRecLine: Record "Purch. Rcpt. Line";
        PurchRecHeader: Record "Purch. Rcpt. Header";
        CostCategory: Record "NS_Job Cost Category";
        Text001: Label '%1 Signature';
        DateLabel: Label 'Date';
        CustSignatureLabel: Label 'Customer Signature';
        CostCategoryCode: Code[20];
        RowCount: Integer;
        TempPurchRcptLine: Record "Purch. Rcpt. Line" temporary;
        TempRcptLineCount: Integer;
        LineTotal: Decimal;
        JobTaskFilter: Text[30];
        CostCatFilter: Text[30];
        JobNoFilter: Text[30];
        StartDate: Date;
        EndDate: Date;
        PurchInvLine: Record "Purch. Inv. Line";//PRJ-493.MS.1.0
        PurchInvHeader: Record "Purch. Inv. Header";//PRJ-493.MS.1.0
        TempPurchInvLine: Record "Purch. Inv. Line" temporary;//PRJ-493.MS.1.0

    procedure SetFilter(PassJobNo: Text[30]; PassJobTask: Text[30]);
    begin
        JobNoFilter := PassJobNo;
        JobTaskFilter := PassJobTask;
    end;
}

