page 14021357 "NS_Actual CostBillingsFactBox"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PPAL-12.AM.1.0 - 2JUNE2020 - Changed the property of page
    //PRJ-340.SK.1.0 - 12AUG2020 - Addedd condition for skipping calculation of fields on new record.
    //PRJ-1293.RM.1.0 08April2022 | Added a variable
    Caption = 'Job Actual Cost/Billings';
    //PageType=CardPart;//PPAL-12.AM commented
    PageType = ListPart;//ppAL-12.AM Added
    SourceTable = Job;

    layout
    {
        area(content)
        {
            fixed(Control1900723401)
            {
                Caption = '';
                group(PROJECTPRO)
                {
                    Caption = 'PROJECTPRO';

                    field("'Actual Cost'"; 'Actual Cost')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Actual cost';
                        ToolTip = 'Actual Cost';

                    }
                    field("'Invoice Billed'"; 'Invoice Billed')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Invoice Billed';
                        ToolTip = 'Invoice Billed';
                    }
                    field("'Payments Rec''d'"; 'Payments Rec''d')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Payments Rec';
                        ToolTip = 'payments Rec';
                    }
                    field("'Committed Cost'"; 'Committed Cost')
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Caption = 'Committed Cost';
                        ToolTip = 'Committed Cost';
                    }
                }
                group("Period to Date")
                {
                    Caption = 'Period to Date';

                    field("FORMAT(ActualCostToDate[1],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(ActualCostToDate[1], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Actual Cost';

                        ToolTip = 'Actual Cost';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Usage);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(InvoiceBilled[1],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(InvoiceBilled[1], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Invoices Billed';

                        ToolTip = 'Invoices Billed';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            //ShowJobRec.SETFILTER("NS_Type Filter", '<>%1', ShowJobRec."NS_Type Filter"::Ledger); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line commented
                            ShowJobRec.SETFILTER("NS_TypeEnumFilter", '<>%1', ShowJobRec."NS_TypeEnumFilter"::Text); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line added                        
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Sale);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(PaymentReceived[1],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(PaymentReceived[1], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'Payments Rec''d';

                        ToolTip = 'Payments Rec''d';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), WORKDATE);
                            DtldCustLedgEntries.NS_SetFilters(ShowJobRec, true);
                            DtldCustLedgEntries.RUNMODAL;
                            CLEAR(DtldCustLedgEntries);
                        end;
                    }
                    field("' '"; ' ')
                    {
                        ApplicationArea = All;
                        Caption = 'Committed Cost';

                        ToolTip = 'Committed Cost';
                        Editable = false;
                    }
                }
                group("Year to Date")
                {
                    Caption = 'Year to Date';
                    field("FORMAT(ActualCostToDate[2],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(ActualCostToDate[2], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'ActualCostToDateYTD';

                        ToolTip = 'ActualCostToDateYTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Usage);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(InvoiceBilled[2],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(InvoiceBilled[2], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'InvoicedBilledYTD';

                        ToolTip = 'InvoicedBilledYTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            //ShowJobRec.SETFILTER("NS_Type Filter", '<>%1', ShowJobRec."NS_Type Filter"::Ledger); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line commented
                            ShowJobRec.SETFILTER("NS_TypeEnumFilter", '<>%1', ShowJobRec."NS_TypeEnumFilter"::Text); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line added                        
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Sale);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(PaymentReceived[2],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(PaymentReceived[2], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'PaymentReceivedYTD';

                        ToolTip = 'PaymentReceivedYTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE);
                            DtldCustLedgEntries.NS_SetFilters(ShowJobRec, true);
                            DtldCustLedgEntries.RUNMODAL;
                            CLEAR(DtldCustLedgEntries);
                        end;
                    }
                    field(CommittedCostYTD; ' ')
                    {
                        ApplicationArea = All;
                        Caption = 'CommittedCostYTD';

                        ToolTip = 'CommittedCostYTD';
                        Editable = false;
                    }
                }
                group("Job to Date")
                {
                    Caption = 'Job to Date';
                    field("FORMAT(ActualCostToDate[3],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(ActualCostToDate[3], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'ActualCostToDateJTD';

                        ToolTip = 'ActualCostToDateJTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Usage);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(InvoiceBilled[3],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(InvoiceBilled[3], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'InvoicedBilledJTD';

                        ToolTip = 'InvoicedBilledJTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            //ShowJobRec.SETFILTER("NS_Type Filter", '<>%1', ShowJobRec."NS_Type Filter"::Ledger); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line commented
                            ShowJobRec.SETFILTER("NS_TypeEnumFilter", '<>%1', ShowJobRec."NS_TypeEnumFilter"::Text); //PRJ-1131.RM.1.0 10Jan2022 //PE-306.JS.1.0 06JUN2024 line added                        
                            ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE);
                            ShowJobRec.SETRANGE("NS_Entry Type Filter", JobLedgerEntry."Entry Type"::Sale);
                            JobLedgerEntries.NS_SetFilters(ShowJobRec, true);
                            JobLedgerEntries.RUNMODAL;
                            CLEAR(JobLedgerEntries);
                        end;
                    }
                    field("FORMAT(PaymentReceived[3],14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(PaymentReceived[3], 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'PaymentReceivedJTD';

                        ToolTip = 'PaymentReceivedJTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            ShowJobRec.RESET;
                            ShowJobRec := Rec;
                            ShowJobRec.SETRANGE("NS_Date Filter", 0D, WORKDATE);
                            DtldCustLedgEntries.NS_SetFilters(ShowJobRec, true);
                            DtldCustLedgEntries.RUNMODAL;
                            CLEAR(DtldCustLedgEntries);
                        end;
                    }
                    field("FORMAT(CommittedCost,14,'<Precision,2:2><Sign><Integer Thousand><Decimals>')"; FORMAT(CommittedCost, 14, '<Precision,2:2><Sign><Integer Thousand><Decimals>'))
                    {
                        ApplicationArea = All;
                        Caption = 'CommittedCostJTD';

                        ToolTip = 'CommittedCostJTD';
                        Editable = false;

                        trigger OnDrillDown();
                        begin
                            CommittedLineList.NS_SetJob("No.");
                            CommittedLineList.RUNMODAL;
                            CLEAR(CommittedLineList);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        NS_OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_OnAfterGetCurrRecord;
    end;

    var
        ShowJobRec: Record Job;

        JobLedgerEntry: Record "Job Ledger Entry";
        JobLedgerEntries: Page "Job Ledger Entries";

        ActualCostToDate: array[3] of Decimal;
        InvoiceBilled: array[3] of Decimal;
        PaymentReceived: array[3] of Decimal;
        CommittedCost: Decimal;
        DtldCustLedgEntries: Page "Detailed Cust. Ledg. Entries";
        //CommittedLineList: Page "NS_Committed Line List"; //PRJ-1293.RM.1.0 commented
        CommittedLineList: Page "NS_Committed Line List Page"; //PRJ-1293.RM.1.0 

    procedure NS_ShowDetails();
    begin
        PAGE.RUN(PAGE::"Job Card", Rec);
    end;

    procedure NS_CalcStatistics();
    begin
        // >> Upgrade
        //FDD108 Start
        IF "NS_Sub-Level to Job No." = "No." THEN
            EXIT;
        //FDD108 End
        // << Upgrade
        //PRJ-340.SK.1.0 Start
        IF "No." = '' then
            Exit;
        //PRJ-340.SK.1.0 End
        NS_CalculateJobFinancials(Rec, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, true);
    end;

    local procedure NS_OnAfterGetCurrRecord();
    begin
        xRec := Rec;
        NS_CalcStatistics;
    end;

    //SMPL - Renamed OnAfterGetCurrRecord to PP_OnAfterGetCurrRecord
}

