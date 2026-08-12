report 14021288 "NS_Work Order (Job LedgerSumm)"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-195.MS.1.0 SignatureLabel change var length from 30 to 50 and //   - modify the layout of report 
    //PRJ-223.MS.1.0 added two new field and modify the layout of report
    //PE-114.VC.1.0 ProjectPro Reports format to Word Output
    //PE-215.DK.2.0 26Dec2023 | Also change in Both Layout RDLC and Word Layout
    // PE-215.HS.1.0 25Jan2024 | Cosmetic Changes in Word layout 
    //PE-311.PP.1.0 11JUN2024 | Renamed the caption as Work order completed, and also change in RDLC layout.
    DefaultLayout = RDLC;
    //PE-215.DK.3.0 26Dec2023

    Caption = 'Work Order Completed'; //Caption = 'Work Order (Job LedgerSumm)';//PE-311.PP.1.0 11JUN2024 Change caption 'Work Order (Job LedgerSumm)' to 'Work Order Completed'
                                      //PE-215.DK.3.0 26Dec2023
    RDLCLayout = './Layouts/NSWork Order (Job Ledger Summ).rdl';
    WordLayout = './Layouts/NSWork Order (Job Ledger Summ).docx';//PE-114.VC.1.0
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            column(WorkOrderNo; Job."No.")
            {
            }
            //PE-215.DK.2.0 26Dec2023 Start
            // column(WorkOrderDate; FORMAT(TODAY, 0, '<Month,2>/<Day,2>/<Year4>'))//PE-114.VC.1.2 //PE-215.DK.1.0 Remove (-) and Add (/) 
            // {
            // }
            column(WorkOrderDate; TODAY) //This Date is working on RDLC Report
            {
            }
            column(WorkOrderDate2; Format(Today)) //This Date is Working on Word Report
            {

            }
            column(WorkOrderManagerName; NS_ManagerName)
            {
            }
            //PE-215.DK.2.0 26Dec2023 End
            column(WorkOrderManager; Job.NS_Manager)
            {
            }
            column(WorkOrderCustAddress; BilltoAddress)
            {
            }
            column(WorkOrderCustAddress2; BilltoAddress2)
            {
            }
            column(WorkOrderCustName; "Bill-to Name")
            {
            }
            column(WorkOrderCustPhone; BilltoPhone)
            {
            }
            column(WorkOrderDescription; Job.Description)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompAddress)
            {
            }
            //PE-114.VC.1.1 Start 01Aug2023
            column(CompAddress2; CompAddress2) { }
            column(CompanyInfoCity; CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code") { } //PE-215.DK.1.0 Add County
            column(UserIDText; UserIDText) { }
            //PE-114.VC.1.1 End 01Aug2023
            column(CompanyPhone; CompPhone)
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(FooterSignatureLabel; SignatureLabel)
            {
            }
            column(FooterDateLabel; DateLabel)
            {
            }
            column(FooterCustSignatureLabel; CustSignatureLabel)
            {
            }
            column(CostCatTotal; CostCatTotal)
            { }
            column(QtyTotal; QtyTotal)
            { }
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
                    column(JobCostCatDesc1; CostCategoryDesc)
                    {
                    }
                    column(Detail_CostCategory; TempJobLedgEntry."NS_Job Cost Category")
                    {
                    }
                    //PE-215.DK.2.0 26Dec2023 Start 
                    // column(Detail_WorkOrderDate; FORMAT(TODAY, 0, '<Month,2>/<Day,2>/<Year4>'))//PE-114.VC.1.2 //PE-215.DK.1.0 Remove (-) and Add (/) 
                    // {
                    // }

                    column(Detail_WorkOrderDate; TempJobLedgEntry."Posting Date") //This column Working on RDLC Report
                    {
                    }
                    column(Detail_WorkOrderDate2; Format(TempJobLedgEntry."Posting Date")) //This column Working on Word Report
                    {
                    }
                    //PE-215.DK.2.0 26Dec2023 End
                    column(Detail_Type; TempJobLedgEntry.Type)
                    {
                    }
                    column(Detail_No; TempJobLedgEntry."No.")
                    {
                    }
                    column(Detail_Description; TempJobLedgEntry.Description)
                    {
                    }
                    column(Detail_Quantity; TempJobLedgEntry.Quantity)
                    {
                    }
                    column(Detail_Rate; TempJobLedgEntry."Unit Price")
                    {
                    }
                    column(Detail_Total; TempJobLedgEntry."Line Amount")
                    {
                    }
                    //PRJ-223.MS.1.0 Start
                    //PE-68 Dk.1.0 10April2023 Start
                    // column(Skill_Code; TempJobLedgEntry."NS_Skill Class")
                    // {

                    // }
                    column(Skill_Code; TempJobLedgEntry."NS_Skill Class New")
                    {

                    }
                    //PE-68 Dk.1.0 10April2023 End
                    column(Work_TYpe_Code; TempJobLedgEntry."Work Type Code")
                    {

                    }
                    //PRJ-223.MS.1.0 End

                    trigger OnAfterGetRecord();
                    begin
                        RowCount += 1;
                        if RowCount = 1 then
                            TempJobLedgEntry.FINDFIRST()
                        else
                            TempJobLedgEntry.NEXT();
                        //PE-114.VC.1.0 Start 26Jul2023
                        If CostCategory.Get(TempJobLedgEntry."NS_Job Cost Category") then
                            CostCategoryDesc := CostCategory.NS_Description;
                        //PE-114.VC.1.0 End 26Jul2023
                    end;

                    trigger OnPreDataItem();
                    begin
                        TempJobLedgEntry.RESET();
                        TempJobLedgEntry.SETRANGE("NS_Job Cost Category", "Job Cost Category".NS_Code);
                        TempLedgEntryCount := TempJobLedgEntry.COUNT;
                        RowCount := 0;
                        SETRANGE(Number, 1, TempLedgEntryCount);
                    end;
                }
            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
                EntryNo: Integer;
            begin
                Cust.GET(Job."Bill-to Customer No.");
                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);
                TempJobLedgEntry.DELETEALL();
                BilltoAddress := Job."Bill-to Address" + ', ' + Job."Bill-to Address 2";
                BilltoAddress2 := Job."Bill-to City" + ', ' + Job."Bill-to County" + ' ' + Job."Bill-to Post Code";
                BilltoPhone := 'Phone: ' + Cust."Phone No.";
                CompAddress := CompanyInfo.Address;
                //PE-114.VC.1.1 Start 01Aug2023
                UserIDText := UserId;
                CompAddress2 := CompanyInfo."Address 2";
                //if CompanyInfo."Address 2" <> '' then
                //    CompAddress := CompAddress + ', ' + CompanyInfo."Address 2";
                //CompAddress := CompAddress + ' ' + CompanyInfo.City + ' ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
                //PE-114.VC.1.1 End 01Aug2023
                CompPhone := 'Phone: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.";
                SignatureLabel := STRSUBSTNO(Text001, CompanyInfo.Name);
                EntryNo := 0;
                CostCategory.RESET();
                CostCategory.FINDSET();
                //PE-114.VC.1.0 Start 26Jul2023
                CostCatTotal := 0;
                QtyTotal := 0;
                //PE-114.VC.1.0 End 26Jul2023
                repeat
                    PurchRecHeader.RESET();
                    PurchRecHeader.SETRANGE("NS_Job No.", Job."No.");
                    if PurchRecHeader.FINDSET() then begin
                        repeat
                            PurchRecLine.RESET();
                            PurchRecLine.SETRANGE("Document No.", PurchRecHeader."No.");
                            PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                            PurchRecLine.SETRANGE("Quantity Invoiced", 0);
                            if PurchRecLine.FINDSET() then
                                repeat
                                    EntryNo += 10000;
                                    TempJobLedgEntry.INIT();
                                    case PurchRecLine.Type of
                                        PurchRecLine.Type::Item:
                                            TempJobLedgEntry.Type := TempJobLedgEntry.Type::Item;
                                        PurchRecLine.Type::"G/L Account":
                                            TempJobLedgEntry.Type := TempJobLedgEntry.Type::"G/L Account";
                                    end;
                                    TempJobLedgEntry.Quantity := PurchRecLine.Quantity;
                                    TempJobLedgEntry."Unit Price" := PurchRecLine."Unit Price (LCY)";
                                    TempJobLedgEntry."Line Amount" := PurchRecLine.Quantity * PurchRecLine."Unit Price (LCY)";
                                    TempJobLedgEntry.INSERT();
                                until PurchRecLine.NEXT() = 0;
                        until PurchRecHeader.NEXT() = 0;
                    end else begin
                        PurchRecLine.RESET();
                        PurchRecLine.SETRANGE("Job No.", Job."No.");
                        PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                        PurchRecLine.SETRANGE("Quantity Invoiced", 0);
                        if PurchRecLine.FINDSET() then
                            repeat
                                EntryNo += 10000;
                                TempJobLedgEntry.INIT();
                                TempJobLedgEntry."Entry No." := EntryNo;
                                case PurchRecLine.Type of
                                    PurchRecLine.Type::Item:
                                        TempJobLedgEntry.Type := TempJobLedgEntry.Type::Item;
                                    PurchRecLine.Type::"G/L Account":
                                        TempJobLedgEntry.Type := TempJobLedgEntry.Type::"G/L Account";
                                end;
                                TempJobLedgEntry.Quantity := PurchRecLine.Quantity;
                                TempJobLedgEntry."Unit Price" := PurchRecLine."Unit Price (LCY)";
                                TempJobLedgEntry."Line Amount" := PurchRecLine.Quantity * PurchRecLine."Unit Price (LCY)";
                                TempJobLedgEntry.INSERT();
                            until PurchRecLine.NEXT() = 0;
                    end;
                    JobLedgEntry.RESET();
                    JobLedgEntry.SETRANGE("Job No.", Job."No.");
                    JobLedgEntry.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                    JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
                    if JobLedgEntry.FINDSET() then
                        repeat
                            EntryNo += 10000;
                            TempJobLedgEntry.INIT();
                            TempJobLedgEntry := JobLedgEntry;
                            TempJobLedgEntry."Entry No." := EntryNo;
                            TempJobLedgEntry.INSERT();
                        until JobLedgEntry.NEXT() = 0;
                until CostCategory.NEXT() = 0;
                //PE-114.VC.1.0 Start 26Jul2023
                JobLedgEntry1.RESET();
                JobLedgEntry1.SETRANGE("Job No.", Job."No.");
                JobLedgEntry1.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Usage);
                if JobLedgEntry1.FINDSET() then
                    repeat
                        CostCatTotal += JobLedgEntry1."Line Amount";
                        QtyTotal += JobLedgEntry1.Quantity;
                    until JobLedgEntry1.Next() = 0;
                //PE-114.VC.1.0 End 26Jul2023
                //PRJCTPR-262.DK.1.0 26Dec2023 Start
                Clear(NS_ManagerName);
                if job.NS_Manager <> '' then begin
                    if NS_Recource.Get(Job.NS_Manager) then
                        NS_ManagerName := NS_Recource.Name;
                end;
                //PRJCTPR-262.DK.1.0 26Dec2023 End
            end;

            trigger OnPreDataItem();
            begin
                if JobNoFilter <> '' then
                    Job.SETFILTER("No.", JobNoFilter);
                if NS_UserSettings.Get() then begin
                    if NS_UserSettings."Language ID" = 1033 then
                        NS_Today := FORMAT(TODAY, 0, '<Month,2>-<Day,2>-<Year4>');
                // >> Upgrade
                // #152 Start
                IF Job.GETFILTER("No.") = '' THEN
                    ERROR(Text002);
                // #152 End
                // << Upgrade
                end;


            end;
        }
    }

    requestpage
    {

        layout
        {
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
        CompAddress: Text[120];
        CompAddress2: Text[120];
        CompPhone: Text[60];
        CompanyInfo: Record "Company Information";
        JobLedgEntry: Record "Job Ledger Entry";
        JobLedgEntry1: Record "Job Ledger Entry";
        PurchRecLine: Record "Purch. Rcpt. Line";
        PurchRecHeader: Record "Purch. Rcpt. Header";
        CostCategory: Record "NS_Job Cost Category";
        //PE-114.VC.1.0 Start 26Jul2023
        CostCategoryDesc: Text;
        CostCatTotal: Decimal;
        QtyTotal: Decimal;
        UserIDText: Text;
        //PE-114.VC.1.0 End 26Jul2023
        TempJobLedgEntry: Record "Job Ledger Entry" temporary;
        Text001: Label '%1 Signature';
        DateLabel: Label 'Date';
        CustSignatureLabel: Label 'Customer Signature';
        CostCategoryCode: Code[20];
        CompName: Text[120];
        TempLedgEntryCount: Integer;
        RowCount: Integer;
        SignatureLabel: Text[50]; //PRJ-195.MS.1.0 Modified
        JobNoFilter: Text[60];
        NS_Today: Text;
        NS_ManagerName: Text;
        NS_UserSettings: Record "User Settings";
        NS_Recource: Record Resource;
        // >> Upgrade
        Text002: Label 'Job No. filter is empty.';
    // << Upgrade

    procedure SetFilter(PassJobNoFilter: Text[60]);
    begin
        JobNoFilter := PassJobNoFilter;
    end;
    //PRJCTPR-262.DK.1.0 26Dec2023 Start
    procedure SetManagerName(ManagerName: Text)
    begin
        NS_ManagerName := ManagerName;
    end;
    //PRJCTPR-262.DK.1.0 26Dec2023 End
}

