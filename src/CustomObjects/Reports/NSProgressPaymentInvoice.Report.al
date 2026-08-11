report 14021342 "NS_Progress Payment Invoice"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSProgress Payment Invoice.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Progress Payment Invoice';

    dataset
    {
        dataitem("Progress Payment Header"; "NS_Progress Payment Header")
        {
            RequestFilterFields = "NS_No.", "NS_Requisition No.", "NS_Version No.";
            column(Invoice_Header_Caption; InvoiceCaptionLbl)
            {
            }
            column(CompanyInfo1Picture; CompanyInfo1.Picture)
            {
            }
            column(CompanyInfo2Picture; CompanyInfo2.Picture)
            {
            }
            column(CompanyInfo3Picture; CompanyInfo3.Picture)
            {
            }
            column(CompanyAddress_1; CompanyAddress[1])
            {
            }
            column(CompanyAddress_2; CompanyAddress[2])
            {
            }
            column(CompanyAddress_3; CompanyAddress[3])
            {
            }
            column(CompanyAddress_4; CompanyAddress[4])
            {
            }
            column(CompanyAddress_5; CompanyAddress[5])
            {
            }
            column(CompanyAddress_6; CompanyAddress[6])
            {
            }
            column(CompanyAddress_7; CompanyAddress[7])
            {
            }
            column(CompanyAddress_8; CompanyAddress[8])
            {
            }
            column(Invoice_Number_Caption; InvoiceNumberCaptionLbl)
            {
            }
            column(Progress_Payment_Header_No; "NS_No." + '-' + FORMAT("NS_Requisition No."))
            {
            }
            column(Invoice_Date_Caption; InvoiceDateCaptionLbl)
            {
            }
            column(Requision_Date; "NS_Requisition Date")
            {
            }
            column(Page_Caption; PageCaptionLbl)
            {
            }

            column(Payment_Caption; PaymentCaptionLbl)
            {
            }
            column(To_Caption; ToCaptionLbl)
            {
            }
            column(VendorAddress_1; VendorAddress[1])
            {
            }
            column(VendorAddress_2; VendorAddress[2])
            {
            }
            column(VendorAddress_3; VendorAddress[3])
            {
            }
            column(VendorAddress_4; VendorAddress[4])
            {
            }
            column(VendorAddress_5; VendorAddress[5])
            {
            }
            column(VendorAddress_6; VendorAddress[6])
            {
            }
            column(VendorAddress_7; VendorAddress[7])
            {
            }
            column(VendorAddress_8; VendorAddress[8])
            {
            }
            column(Job_Caption; JobCaptionLbl)
            {
            }
            column(Addr_Caption; AddrCaptionLbl)
            {
            }
            column(JobAddress_1; JobAddress[1])
            {
            }
            column(JobAddress_2; JobAddress[2])
            {
            }
            column(JobAddress_3; JobAddress[3])
            {
            }
            column(JobAddress_4; JobAddress[4])
            {
            }
            column(A_E_Caption; AECaptionLbl)
            {
            }
            column(AEAddress_1; AEAddress[1])
            {
            }
            column(AEAddress_2; AEAddress[2])
            {
            }
            column(AEAddress_3; AEAddress[3])
            {
            }
            column(AEAddress_4; AEAddress[4])
            {
            }
            column(Description_Caption; DescriptionCaptionLbl)
            {
            }
            column(Subcontract_Description; SubcontractDescription)
            {
            }
            column(Period_To_Caption; PeriodToCaptionLbl)
            {
            }
            column(Period_To; PeriodTo)
            {
            }
            column(Vendor_ID_Caption; VendorIDCaptionLbl)
            {
            }
            column(Vendor_ID_No; VendorIDNo)
            {
            }
            column(Vendor_Job_No_Caption; VendorJobNoCaptionLbl)
            {
            }
            column(Vendor_Job_No; VendorJobNo)
            {
            }
            column(Contract_Date_Caption; ContractDateCaptionLbl)
            {
            }
            column(Contract_Date; ContractDate)
            {
            }
            column(Header_Line_01_No_Lbl; HeaderLine01NoLbl)
            {
            }
            column(Header_Line_01_Name_Lbl; HeaderLine01NameLbl)
            {
            }
            column(Original_Contract_Sum; OriginalContractSum)
            {
            }
            column(Header_Line_02_No_Lbl; HeaderLine02NoLbl)
            {
            }
            column(Header_Line_02_Name_Lbl; HeaderLine02NameLbl)
            {
            }
            column(Net_Changes; NetChanges)
            {
            }
            column(Header_Line_03_No_Lbl; HeaderLine03NoLbl)
            {
            }
            column(Header_Line_03_Name_Lbl; HeaderLine03NameLbl)
            {
            }
            column(Contract_Sum_To_Date; ContractSumToDate)
            {
            }
            column(Header_Line_04_No_Lbl; HeaderLine04NoLbl)
            {
            }
            column(Header_Line_04_Name_Lbl; HeaderLine04NameLbl)
            {
            }
            column(Total_Completed_And_Stored_To_Date; TotalCompletedAndStoredToDate)
            {
            }
            column(Header_Line_05_No_Lbl; HeaderLine05NoLbl)
            {
            }
            column(Header_Line_05_Name_Lbl; HeaderLine05NameLbl)
            {
            }
            column(Header_Line_05a_No_Lbl; HeaderLine05aNoLbl)
            {
            }
            column(Header_Line_05a_Name_Lbl; STRSUBSTNO(HeaderLine05aNameLbl, FORMAT("NS_Work Retention Percent", 0, '<Precision,2:2><Standard Format,0>')))
            {
            }
            column(Retention_Percent_Of_Completed_Work; RetentionPercentOfCompletedWork)
            {
            }
            column(Header_Line_05b_No_Lbl; HeaderLine05bNoLbl)
            {
            }
            column(Header_Line_05b_Name_Lbl; STRSUBSTNO(HeaderLine05bNameLbl, FORMAT("NS_Material Retention Percent", 0, '<Precision,2:2><Standard Format,0>')))
            {
            }
            column(Retention_Percent_Of_Completed_Material; RetentionPercentOfCompletedMaterial)
            {
            }
            column(Header_Line_05c_Name_Lbl; HeaderLine05cNameLbl)
            {
            }
            column(Total_Retention; TotalRetention)
            {
            }
            column(Header_Line_06_No_Lbl; HeaderLine06NoLbl)
            {
            }
            column(Header_Line_06_Name_Lbl; HeaderLine06NameLbl)
            {
            }
            column(Total_Earned_Less_Retention; TotalPaidLessRetention)
            {
            }
            column(Header_Line_07_No_Lbl; HeaderLine07NoLbl)
            {
            }
            column(Header_Line_07_Name_Lbl; HeaderLine07NameLbl)
            {
            }
            column(Less_Previous_Invoices; LessPreviousPayments)
            {
            }
            column(Header_Line_08_No_Lbl; HeaderLine08NoLbl)
            {
            }
            column(Header_Line_08_Name_Lbl; HeaderLine08NameLbl)
            {
            }
            column(Current_Payment_Due; CurrentPaymentDue)
            {
            }
            column(Header_Line_09_No_Lbl; HeaderLine09NoLbl)
            {
            }
            column(Header_Line_09_Name_Lbl; HeaderLine09NameLbl)
            {
            }
            column(Balance_To_Finish_Including_Retention; BalanceToFinishIncludingRetention)
            {
            }
            column(Header_Line_10_No_Lbl; HeaderLine10Lbl)
            {
            }
            column(Header_Line_10a_No_Lbl; HeaderLine10aLbl)
            {
            }
            column(Header_Line_10b_No_Lbl; HeaderLine10bLbl)
            {
            }
            column(Header_Line_11_No_Lbl; HeaderLine11NoLbl)
            {
            }
            column(Previous_Additions; PreviousAdditions)
            {
            }
            column(Previous_Deductions; PreviousDeductions)
            {
            }
            column(Header_Line_12_No_Lbl; HeaderLine12NoLbl)
            {
            }
            column(Current_Additions; CurrentAdditions)
            {
            }
            column(Current_Deductions; CurrentDeductions)
            {
            }
            column(Header_Line_13_No_Lbl; HeaderLine13NoLbl)
            {
            }
            column(Total_Changes_Additions; TotalChangesAdditions)
            {
            }
            column(Total_Changes_Deductions; TotalChangesDeductions)
            {
            }
            column(Header_Line_14_No_Lbl; HeaderLine14NoLbl)
            {
            }
            column(Net_Change_Orders; NetChangeOrders)
            {
            }
            dataitem("Progress Payment Line"; "NS_Progress Payment Line")
            {
                DataItemLink = "NS_Progress Payment No." = FIELD("NS_No."), "NS_Requisition No." = FIELD("NS_Requisition No."), "NS_Version No." = FIELD("NS_Version No.");
                DataItemTableView = SORTING("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.", "NS_Subcontract No.", "NS_Cost Category", "NS_Job No.", "NS_Job Task No.") ORDER(Ascending);
                column(Detail_Item_Lbl; DetailItemLbl)
                {
                }
                column(Detail_Description_Lbl; DetailDescriptionLbl)
                {
                }
                column(Detail_Scheduled_Value_Lbl; DetailScheduledValueLbl)
                {
                }
                column(Detail_Previous_Period_Lbl; DetailPreviousPeriodLbl)
                {
                }
                column(Detail_This_Period_Lbl; DetailThisPeriodLbl)
                {
                }
                column(Detail_Materials_Presently_Stored_Lbl; DetailMaterialsPresentlyStoredLbl)
                {
                }
                column(Detail_Total_Completed_And_Stored_Lbl; DetailTotalCompletedAndStoredLbl)
                {
                }
                column(Detail_Percent_This_Period_Lbl; DetailPercentThisPeriodLbl)
                {
                }
                column(Detail_Balance_To_Finish_Lbl; DetailBalanceToFinishLbl)
                {
                }
                column(Detail_Retention_Lbl; DetailRetentionLbl)
                {
                }
                column(DLine_No; DLineNo)
                {
                }
                column(DDescription; DDescription)
                {
                }
                column(DScheduled_Value; DScheduledValue)
                {
                }
                column(DPrevious_Period; DPreviousPeriod)
                {
                }
                column(DThis_Period; DThisPeriod)
                {
                }
                column(DStored_Materials_Amount; DStoredMaterialsAmount)
                {
                }
                column(DTotal_Completed_And_Stored; DTotalCompletedAndStored)
                {
                }
                column(DTotal_Completed_And_Stored_Pct; DTotalCompletedAndStoredPct)
                {
                }
                column(DBalance_To_Finish; DBalanceToFinish)
                {
                }
                column(DRetention; DRetention)
                {
                }

                trigger OnAfterGetRecord();
                var
                    OK: Boolean;
                begin
                    if "NS_Subcontract No." > '' then
                        DetailSubcontract.GET("NS_Subcontract No.")
                    else
                        CLEAR(DetailSubcontract);

                    OK := false;
                    if (DetailSubcontract.NS_Status >= DetailSubcontract.NS_Status::Order) and
                       (DetailSubcontract."NS_Contract Date" <= "Progress Payment Header"."NS_Period To") then
                        OK := true;

                    if not OK then
                        CurrReport.SKIP;

                    DLineNo := DLineNo + 1;
                    DDescription := "NS_Task Description";
                    if "NS_Payment Method" > 0 then begin
                        DScheduledValue := NS_LastBase("Progress Payment Line");
                        DPreviousPeriod := NS_LastTotal("Progress Payment Line");
                        DThisPeriod := "NS_Work Amount";
                        DStoredMaterialsAmount := "NS_Stored Materials Amount";
                        DTotalCompletedAndStored := DPreviousPeriod + DThisPeriod + DStoredMaterialsAmount;
                        if DScheduledValue <> 0 then
                            DTotalCompletedAndStoredPct := ROUND((DTotalCompletedAndStored / DScheduledValue) * 100, 0.01)
                        else
                            DTotalCompletedAndStoredPct := 0;
                        DBalanceToFinish := DScheduledValue - DThisPeriod;
                        DWorkRetention := ROUND(("Progress Payment Header"."NS_Work Retention Percent" / 100) * (DPreviousPeriod + DThisPeriod), 0.01);
                        DMaterialRetention := ROUND(("Progress Payment Header"."NS_Material Retention Percent" / 100) * DStoredMaterialsAmount, 0.01);
                        DRetention := DWorkRetention + DMaterialRetention;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    ItemNo := 0;
                    CurrReport.NEWPAGE;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                NS_CalculateRequisition("Progress Payment Header");
                MODIFY;

                //Read related records
                Subcontract.GET("NS_Subcontract No.");
                Vendor.GET(Subcontract."NS_Buy-from Vendor No.");

                //Find first line of the progress bill
                ProgressPaymentLine.RESET();
                ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
                ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressPaymentLine.FINDSET() then;

                //Format Addresses
                FormatAddress.Company(CompanyAddress, CompanyInformation);

                Job.GET(Subcontract."NS_Job No.");
                if JobContact.GET("NS_Subcontract No.", "NS_Owner Contact Type", "NS_Owner Contact Code") then begin
                    VendorJobNo := JobContact."NS_Their Job No.";
                    NS_FormatAddress.NS_JobContact(VendorAddress, JobContact)
                end else begin
                    VendorJobNo := Subcontract."NS_Vendor Job No.";
                    FormatAddress.Vendor(VendorAddress, Vendor);
                end;

                JobContact.RESET();
                JobContact.SETRANGE("NS_Job No.", Subcontract."NS_No.");
                JobContact.SETRANGE(NS_Type, JobContact.NS_Type::"Architect/Engineer");
                if JobContact.FINDSET() then
                    NS_FormatAddress.NS_JobContact(AEAddress, JobContact)
                else
                    CLEAR(AEAddress);
                FormatAddress.FormatAddr(JobAddress, '', '', Job."NS_Job Contact",
                                         Job."NS_Job Address 1", Job."NS_Job Address 2",
                                         Job."NS_Job City", Job."NS_Job Post Code",
                                         Job."NS_Job County",
                                         Job."NS_Job Country/Region Code");

                //Aquire needed values
                WorkPreviousPayment := ProgressPaymentLine.NS_TotalWorkPreviousPayment("Progress Payment Header");
                PreviousStoredMaterial := NS_LastProgressPayStoredMat("Progress Payment Header");
                PreviousEarning := NS_ProgressPayPreviousTotalEarn("Progress Payment Header");
                PreviousRetention := NS_PreviousProgressPayRetention("Progress Payment Header", '', '', '', '', '');
                CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount", "NS_Requisition Total");

                PreviousAdditions := 0;
                PreviousDeductions := 0;
                CurrentAdditions := 0;
                CurrentDeductions := 0;

                PreviousReqPeriodToDate := NS_GetPeriodFromDate("NS_No.", "NS_Period To");
                NS_GetChangeOrderValues(Subcontract."NS_No.",
                                     PreviousReqPeriodToDate, "NS_Period To",
                                     PreviousAdditions, PreviousDeductions,
                                     CurrentAdditions, CurrentDeductions);

                if "NS_Period To" > 0D then
                    Subcontract.SETFILTER("NS_Date Filter", '<=%1', "NS_Period To")
                else
                    ERROR(Text14021101);

                SubcontractDescription := Subcontract.NS_Description;
                PeriodTo := FORMAT("NS_Period To");
                VendorJobNo := Subcontract."NS_Vendor Job No.";
                ContractDate := FORMAT(Subcontract."NS_Contract Date");
                OriginalContractSum := NS_ProgressPayBaseAmount("Progress Payment Header");    //Line 1
                NetChanges := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;  //Line 2
                ContractSumToDate := OriginalContractSum + NetChanges;  //Line 3
                TotalCompletedAndStoredToDate := WorkPreviousPayment + "NS_Requisition Total";  //Line 4
                if "NS_Work Retention Percent" <> 0 then
                    RetentionPercentOfCompletedWork := ROUND((WorkPreviousPayment + "NS_Line Work Amount") * ("NS_Work Retention Percent" / 100), 0.01)  //Line 5a
                else
                    RetentionPercentOfCompletedWork := 0;  //Line 5a
                if "NS_Material Retention Percent" <> 0 then
                    RetentionPercentOfCompletedMaterial := ROUND("NS_Line Material Amount" * ("NS_Material Retention Percent" / 100), 0.01)  //Line 5b
                else
                    RetentionPercentOfCompletedMaterial := 0;  //Line 5b
                if RetentionPercentOfCompletedWork + RetentionPercentOfCompletedMaterial <> 0 then
                    TotalRetention := RetentionPercentOfCompletedWork + RetentionPercentOfCompletedMaterial  //Line 5c
                else begin
                    ProgressPaymentLine.RESET();
                    ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
                    ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                    ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                    if ProgressPaymentLine.FINDSET() then
                        repeat
                            TotalRetention := TotalRetention + ProgressPaymentLine."NS_Work Retention Amount" + ProgressPaymentLine."NS_Material Retention Amount";  //Line 5c
                        until ProgressPaymentLine.NEXT() = 0;
                end;
                TotalPaidLessRetention := TotalCompletedAndStoredToDate - TotalRetention;  //Line 6
                LessPreviousPayments := NS_ProgressPayPreviousInvoice("Progress Payment Header");  //Line 7
                CurrentPaymentDue := TotalPaidLessRetention - LessPreviousPayments;  //Line 8
                BalanceToFinishIncludingRetention := ContractSumToDate - TotalPaidLessRetention;  //Line 9
                TotalChangesAdditions := PreviousAdditions + CurrentAdditions;  //Line 13a
                TotalChangesDeductions := PreviousDeductions + CurrentDeductions;  //Line 13b
                NetChangeOrders := TotalChangesAdditions - TotalChangesDeductions;  //Line 14
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

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInfo1.GET;
        CompanyInfo2.GET;
        CompanyInfo3.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Subcontract: Record NS_Subcontract;
        DetailSubcontract: Record NS_Subcontract;
        JobContact: Record "NS_Job Contact";
        Job: Record Job;
        Vendor: Record Vendor;
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        FormatAddress: Codeunit "Format Address";
        NS_FormatAddress: Codeunit "NS_Format Address";
        WorkPreviousPayment: Decimal;
        PreviousEarning: Decimal;
        PreviousRetention: Decimal;
        PreviousStoredMaterial: Decimal;
        PreviousAdditions: Decimal;
        PreviousDeductions: Decimal;
        CurrentAdditions: Decimal;
        CurrentDeductions: Decimal;
        JobBudgetedCost: Decimal;
        PeriodToDate: Date;
        PreviousReqPeriodToDate: Date;
        Labels: array[80] of Text[100];
        SubcontractDescription: Text[50];
        VendorIDNo: Text[30];
        PeriodTo: Text[30];
        VendorJobNo: Text[30];
        ContractDate: Text[30];
        OriginalContractSum: Decimal;
        NetChanges: Decimal;
        ContractSumToDate: Decimal;
        TotalCompletedAndStoredToDate: Decimal;
        RetentionPercentOfCompletedWork: Decimal;
        RetentionPercentOfCompletedMaterial: Decimal;
        TotalRetention: Decimal;
        TotalPaidLessRetention: Decimal;
        LessPreviousPayments: Decimal;
        CurrentPaymentDue: Decimal;
        BalanceToFinishIncludingRetention: Decimal;
        TotalChangesAdditions: Decimal;
        TotalChangesDeductions: Decimal;
        NetChangeOrders: Decimal;
        DLineNo: Integer;
        DDescription: Text[50];
        DScheduledValue: Decimal;
        DPreviousPeriod: Decimal;
        DThisPeriod: Decimal;
        DStoredMaterialsAmount: Decimal;
        DTotalCompletedAndStored: Decimal;
        DTotalCompletedAndStoredPct: Decimal;
        DBalanceToFinish: Decimal;
        DWorkRetention: Decimal;
        DMaterialRetention: Decimal;
        DRetention: Decimal;
        JobAddress: array[8] of Text[50];
        VendorAddress: array[8] of Text[50];
        AEAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        ItemNo: Integer;
        Text14021101: Label 'There is no "Period To" date.';
        InvoiceCaptionLbl: Label 'INVOICE';
        InvoiceNumberCaptionLbl: Label 'Invoice Number:';
        InvoiceDateCaptionLbl: Label 'Invoice Date:';
        PageCaptionLbl: Label 'Page:';
        ToCaptionLbl: Label 'To:';
        PaymentCaptionLbl: Label 'Payment';
        JobCaptionLbl: Label 'Job';
        AddrCaptionLbl: Label 'Addr:';
        DescriptionCaptionLbl: Label 'Description:';
        VendorJobNoCaptionLbl: Label 'Vendor Job No.:';
        ContractDateCaptionLbl: Label 'Contract Date:';
        PeriodToCaptionLbl: Label 'Period To:';
        VendorIDCaptionLbl: Label 'Vendor ID:';
        AECaptionLbl: Label 'A/E';
        TotalsCaptionLbl: Label 'Totals:';
        HeaderLine01NoLbl: Label '1.';
        HeaderLine01NameLbl: Label 'Original contract sum';
        HeaderLine02NoLbl: Label '2.';
        HeaderLine02NameLbl: Label 'Net changes';
        HeaderLine03NoLbl: Label '3.';
        HeaderLine03NameLbl: Label 'Contract sum to date';
        HeaderLine04NoLbl: Label '4.';
        HeaderLine04NameLbl: Label 'Total completed & stored to date';
        HeaderLine05NoLbl: Label '5.';
        HeaderLine05NameLbl: Label 'Retention:';
        HeaderLine05aNoLbl: Label 'a.';
        HeaderLine05aNameLbl: Label '%1% of completed work';
        HeaderLine05bNoLbl: Label 'b.';
        HeaderLine05bNameLbl: Label '%1% of stored material';
        HeaderLine05cNameLbl: Label 'Total Retention';
        HeaderLine06NoLbl: Label '6.';
        HeaderLine06NameLbl: Label 'Total earned less retention';
        HeaderLine07NoLbl: Label '7.';
        HeaderLine07NameLbl: Label 'Less previous invoices';
        HeaderLine08NoLbl: Label '8.';
        HeaderLine08NameLbl: Label 'Current payment due';
        HeaderLine09NoLbl: Label '9.';
        HeaderLine09NameLbl: Label 'Balance to finish, including retention';
        HeaderLine10Lbl: Label 'Change order summary';
        HeaderLine10aLbl: Label 'ADDITIONS';
        HeaderLine10bLbl: Label 'DEDUCTIONS';
        HeaderLine11NoLbl: Label 'Total changes approved in previous months';
        HeaderLine12NoLbl: Label 'Total changes approved this month';
        HeaderLine13NoLbl: Label 'Totals';
        HeaderLine14NoLbl: Label 'Net Changes';
        DetailItemLbl: Label 'Item';
        DetailDescriptionLbl: Label 'Description';
        DetailScheduledValueLbl: Label 'Scheduled Value';
        DetailPreviousPeriodLbl: Label 'Previous Period';
        DetailThisPeriodLbl: Label 'This Period';
        DetailMaterialsPresentlyStoredLbl: Label 'Materials Presently Stored';
        DetailTotalCompletedAndStoredLbl: Label 'Total Completed and Stored';
        DetailPercentThisPeriodLbl: Label '%';
        DetailBalanceToFinishLbl: Label 'Balance To Finish';
        DetailRetentionLbl: Label 'Retention';
}

