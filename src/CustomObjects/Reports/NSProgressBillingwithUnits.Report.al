report 14021405 "NS_Progress Billing with Units"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //CTSI-20.MS.1.0 change key to Revenue category in billing line data item
    //GLEI-11.MS.1.0001 save as report progress invoice and added 6 new fields with landscape property
    //PRJ-203:AS:20APRIL2020 : Created new report for UPP by Duplicating GLEI-11.MA.1.0001.
    //     - changes in layout
    //CTSI-86.MS.1.0 increase length of job description from 50 to 100
    //PRJ-323.MS.1.0 new changes for Bal to finish field calculation
    //PRJ-464.AM.1.0 | Cleared the variables as they are picking the previous values .Added Customer No. in Report & Added Item no. 
    //PRJ-464.AM.1.0 | Changed decimal property of Previous Qty and Current Qty ,Balance Qty to 6 decimal places in layout .

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSProgress Billing with Units.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Progress Billing with Units';

    dataset
    {
        dataitem("Progress Billing Header"; "NS_Progress Billing Header")
        {
            RequestFilterFields = "NS_No.", "NS_Requisition No.", "NS_Version No.";
            column(Invoice_Header_Caption; Invoice_CaptionLbl)
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
            column(CompanyAddress_1_; CompanyAddress[1])
            {
            }
            column(CompanyAddress_2_; CompanyAddress[2])
            {
            }
            column(CompanyAddress_3_; CompanyAddress[3])
            {
            }
            column(CompanyAddress_4_; CompanyAddress[4])
            {
            }
            column(CompanyAddress_5_; CompanyAddress[5])
            {
            }
            column(CompanyAddress_6_; CompanyAddress[6])
            {
            }
            column(CompanyAddress_7_; CompanyAddress[7])
            {
            }
            column(CompanyAddress_8_; CompanyAddress[8])
            {
            }
            column(Invoice_Number__Caption; Invoice_Number__CaptionLbl)
            {
            }
            column(Progress_Billing_Header_No_; "NS_No." + '-' + FORMAT("NS_Requisition No."))
            {
            }
            column(Invoice_Date__Caption; Invoice_Date__CaptionLbl)
            {
            }
            column(Invoice_Date; "NS_Requisition Date")
            {
            }
            column(Page__Caption; Page__CaptionLbl)
            {
            }

            column(Bill_Caption; Bill_CaptionLbl)
            {
            }
            column(To__Caption; To__CaptionLbl)
            {
            }
            column(CustomerAddress_1_; CustomerAddress[1])
            {
            }
            column(CustomerAddress_2_; CustomerAddress[2])
            {
            }
            column(CustomerAddress_3_; CustomerAddress[3])
            {
            }
            column(CustomerAddress_4_; CustomerAddress[4])
            {
            }
            column(CustomerAddress_5_; CustomerAddress[5])
            {
            }
            column(CustomerAddress_6_; CustomerAddress[6])
            {
            }
            column(CustomerAddress_7_; CustomerAddress[7])
            {
            }
            column(CustomerAddress_8_; CustomerAddress[8])
            {
            }
            column(Job_Caption; Job_CaptionLbl)
            {
            }
            column(Addr__Caption; Addr__CaptionLbl)
            {
            }
            column(JobAddress_1_; JobAddress[1])
            {
            }
            column(JobAddress_2_; JobAddress[2])
            {
            }
            column(JobAddress_3_; JobAddress[3])
            {
            }
            column(JobAddress_4_; JobAddress[4])
            {
            }
            column(A_ECaption; A_ECaptionLbl)
            {
            }
            column(AEAddress_1_; AEAddress[1])
            {
            }
            column(AEAddress_2_; AEAddress[2])
            {
            }
            column(AEAddress_3_; AEAddress[3])
            {
            }
            column(AEAddress_4_; AEAddress[4])
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Job_Description; JobDescription)
            {
            }
            column(Period_ToCaption; Period_ToCaptionLbl)
            {
            }
            column(Period_To; PeriodTo)
            {
            }
            column(Customer_IDCaption; Customer_IDCaptionLbl)
            {
            }
            column(Customer_ID_No; CustomerIDNo)
            {
            }
            column(Customer_Job_No_Caption; Customer_Job_No__CaptionLbl)
            {
            }
            column(Customer_Job_No; CustomerJobNo)
            {
            }
            column(Contract_DateCaption; Contract_DateCaptionLbl)
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
            column(Total_Earned_Less_Retention; TotalEarnedLessRetention)
            {
            }
            column(Header_Line_07_No_Lbl; HeaderLine07NoLbl)
            {
            }
            column(Header_Line_07_Name_Lbl; HeaderLine07NameLbl)
            {
            }
            column(Less_Previous_Invoices; LessPreviousInvoices)
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
            column(Balance_To_Finish__Including_Retention; BalanceToFinishIncludingRetention)
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
            dataitem("Progress Billing Line"; "NS_Progress Billing Line")
            {
                DataItemLink = "NS_Progress Billing No." = FIELD("NS_No."), "NS_Requisition No." = FIELD("NS_Requisition No."), "NS_Version No." = FIELD("NS_Version No.");
                DataItemTableView = Sorting("NS_Revenue Category") ORDER(Ascending);
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
                column(NS_Item_No_; "NS_Item No.")
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
                column(Contract_Quantity; "NS_Contract Quantity")
                {

                }
                column(Unit_of_Measure_Code; "NS_Unit of Measure Code")
                {

                }
                column(Base_Amount; "NS_Base Amount")
                {
                    Caption = 'Rate';
                }
                column(PreviousQty; PreviousQty)
                {

                }
                column(Current_Work_Unit; "NS_Current Work Unit")
                {

                }
                column(BalanceQty; BalanceQty)
                {

                }

                trigger OnAfterGetRecord();
                var
                    OK: Boolean;
                begin
                    //PRJ-464.AM.1.0 Start
                    CLEAR(DScheduledValue);
                    CLEAR(DPreviousPeriod);
                    CLEAR(DThisPeriod);
                    CLEAR(DStoredMaterialsAmount);
                    CLEAR(DTotalCompletedAndStored);
                    CLEAR(DTotalCompletedAndStoredPct);
                    CLEAR(DBalanceToFinish);
                    Clear(DWorkRetention);
                    Clear(DMaterialRetention);
                    CLEAR(DRetention);
                    Clear(PreviousQty);
                    Clear(BalanceQty);
                    //PRJ-464.AM.1.0 End


                    if "NS_Job No." > '' then
                        DetailJob.GET("NS_Job No.")
                    else
                        CLEAR(DetailJob);

                    OK := false;

                    if (DetailJob.Status.AsInteger() >= DetailJob.Status::Open.AsInteger()) and
                       (DetailJob."NS_Contract Date" <= "Progress Billing Header"."NS_Period To") then
                        OK := true;

                    if not OK then
                        CurrReport.SKIP;

                    DLineNo := DLineNo + 1;
                    DDescription := NS_Description;
                    if "NS_Billing Method" > 0 then begin
                        DScheduledValue := NS_LastBase("Progress Billing Line");
                        DPreviousPeriod := NS_LastTotal("Progress Billing Line");
                        PreviousQty := NS_GetPreviousWorkunit("Progress Billing Line");
                        DThisPeriod := "NS_Work Amount";
                        DStoredMaterialsAmount := "NS_Stored Materials Amount";
                        DTotalCompletedAndStored := DPreviousPeriod + DThisPeriod + DStoredMaterialsAmount;
                        if DScheduledValue <> 0 then
                            DTotalCompletedAndStoredPct := ROUND((DTotalCompletedAndStored / DScheduledValue) * 100, 0.01)
                        else
                            DTotalCompletedAndStoredPct := 0;
                        DBalanceToFinish := DScheduledValue - DThisPeriod - DPreviousPeriod - DStoredMaterialsAmount;//PRJ-323.MS.1.0
                        if "NS_Contract Quantity" <> 0 then
                            BalanceQty := "NS_Contract Quantity" - NS_Quantity
                        else
                            BalanceQty := 100 - (PreviousQty + "NS_Current Work Unit");
                        DWorkRetention := ROUND(("Progress Billing Header"."NS_Work Retention Percent" / 100) * (DPreviousPeriod + DThisPeriod), 0.01);
                        DMaterialRetention := ROUND(("Progress Billing Header"."NS_Material Retention Percent" / 100) * DStoredMaterialsAmount, 0.01);
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
                NS_CalculateRequisition("Progress Billing Header");
                MODIFY;

                //Read related records
                Job.GET("NS_Job No.");
                Customer.GET(Job."Bill-to Customer No.");

                //Find first line of the progress bill
                ProgressBillingLine.RESET();
                ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
                ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressBillingLine.FINDSET() then;

                //Format Addresses
                FormatAddress.Company(CompanyAddress, CompanyInformation);

                if JobContact.GET("NS_Job No.", "NS_Owner Contact Type", "NS_Owner Contact Code") then begin
                    CustomerJobNo := JobContact."NS_Their Job No.";
                    NS_FormatAddress.NS_JobContact(CustomerAddress, JobContact)
                end else begin
                    CustomerJobNo := Job."NS_Customer Job No.";
                    FormatAddress.Customer(CustomerAddress, Customer);
                end;

                JobContact.RESET();
                JobContact.SETRANGE("NS_Job No.", Job."No.");
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
                WorkPreviousBilling := ProgressBillingLine.NS_TotalWorkPreviousBilling("Progress Billing Header");
                PreviousStoredMaterial := NS_LastProgressBillStoredMat("Progress Billing Header");
                PreviousEarning := NS_ProgressBillPreviousTotalEarn("Progress Billing Header");
                PreviousRetention := NS_PreviousProgressBillRetention("Progress Billing Header", '', '', '', '', '', '');//PRJ-688.AM.1.0
                CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount", "NS_Requisition Total");

                PreviousAdditions := 0;
                PreviousDeductions := 0;
                CurrentAdditions := 0;
                CurrentDeductions := 0;

                PreviousReqPeriodToDate := NS_GetPeriodFromDate("NS_No.", "NS_Period To");
                NS_GetChangeOrderValues(Job."No.",
                                     PreviousReqPeriodToDate, "NS_Period To",
                                     PreviousAdditions, PreviousDeductions,
                                     CurrentAdditions, CurrentDeductions);

                if "NS_Period To" > 0D then
                    Job.SETFILTER("NS_Date Filter", '<=%1', "NS_Period To")
                else
                    ERROR(Text14021101);

                JobDescription := Job.Description;
                PeriodTo := FORMAT("NS_Period To");
                CustomerJobNo := Job."NS_Customer Job No.";
                CustomerIDNo := Job."Bill-to Customer No.";//PRJ-464.AM.1.0
                ContractDate := FORMAT(Job."NS_Contract Date");
                OriginalContractSum := NS_ProgressBillBaseAmount("Progress Billing Header");    //Line 1
                NetChanges := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;  //Line 2
                ContractSumToDate := OriginalContractSum + NetChanges;  //Line 3
                TotalCompletedAndStoredToDate := WorkPreviousBilling + "NS_Requisition Total";  //Line 4
                if "NS_Work Retention Percent" <> 0 then
                    RetentionPercentOfCompletedWork := ROUND((WorkPreviousBilling + "NS_Line Work Amount") * ("NS_Work Retention Percent" / 100), 0.01)  //Line 5a
                else
                    RetentionPercentOfCompletedWork := 0;  //Line 5a
                if "NS_Material Retention Percent" <> 0 then
                    RetentionPercentOfCompletedMaterial := ROUND("NS_Line Material Amount" * ("NS_Material Retention Percent" / 100), 0.01)  //Line 5b
                else
                    RetentionPercentOfCompletedMaterial := 0;  //Line 5b
                if RetentionPercentOfCompletedWork + RetentionPercentOfCompletedMaterial <> 0 then
                    TotalRetention := RetentionPercentOfCompletedWork + RetentionPercentOfCompletedMaterial  //Line 5c
                else begin
                    ProgressBillingLine.RESET();
                    ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
                    ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                    ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
                    if ProgressBillingLine.FINDSET() then
                        repeat
                            TotalRetention := TotalRetention + ProgressBillingLine."NS_Work Retention Amount" + ProgressBillingLine."NS_Material Retention Amount";  //Line 5c
                        until ProgressBillingLine.NEXT() = 0;
                end;
                TotalEarnedLessRetention := TotalCompletedAndStoredToDate - TotalRetention;  //Line 6
                LessPreviousInvoices := NS_ProgressBillPreviousInvoice("Progress Billing Header");  //Line 7
                CurrentPaymentDue := TotalEarnedLessRetention - LessPreviousInvoices;  //Line 8
                BalanceToFinishIncludingRetention := ContractSumToDate - TotalEarnedLessRetention;  //Line 9
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
        CompanyInfo1.CalcFields(Picture);
        CompanyInfo2.GET;
        CompanyInfo3.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Job: Record Job;
        ChangeJob: Record Job;
        DetailJob: Record Job;
        JobContact: Record "NS_Job Contact";
        Customer: Record Customer;
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PrevProgressBillingHeader: Record "NS_Progress Billing Header";
        JobPlanningLine: Record "Job Planning Line";
        FormatAddress: Codeunit "Format Address";
        NS_FormatAddress: Codeunit "NS_Format Address";
        WorkPreviousBilling: Decimal;
        PreviousEarning: Decimal;
        PreviousRetention: Decimal;
        PreviousStoredMaterial: Decimal;
        PreviousAdditions: Decimal;
        PreviousDeductions: Decimal;
        CurrentAdditions: Decimal;
        CurrentDeductions: Decimal;
        JobBudgetedPrice: Decimal;
        PeriodToDate: Date;
        PreviousReqPeriodToDate: Date;
        Labels: array[80] of Text[100];
        JobDescription: Text[100];//CTSI-86.MS.1.0
        CustomerIDNo: Text[30];
        PeriodTo: Text[30];
        CustomerJobNo: Text[30];
        ContractDate: Text[30];
        OriginalContractSum: Decimal;
        NetChanges: Decimal;
        ContractSumToDate: Decimal;
        TotalCompletedAndStoredToDate: Decimal;
        RetentionPercentOfCompletedWork: Decimal;
        RetentionPercentOfCompletedMaterial: Decimal;
        TotalRetention: Decimal;
        TotalEarnedLessRetention: Decimal;
        LessPreviousInvoices: Decimal;
        CurrentPaymentDue: Decimal;
        BalanceToFinishIncludingRetention: Decimal;
        TotalChangesAdditions: Decimal;
        TotalChangesDeductions: Decimal;
        NetChangeOrders: Decimal;
        DLineNo: Integer;
        DDescription: Text[100];//CTSI-86.MS.1.0
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
        CustomerAddress: array[8] of Text[50];
        AEAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        ItemNo: Integer;
        Text14021101: Label 'There is no "Period To" date.';
        Invoice_CaptionLbl: Label 'INVOICE';
        Invoice_Number__CaptionLbl: Label 'Invoice Number:';
        Invoice_Date__CaptionLbl: Label 'Invoice Date:';
        Page__CaptionLbl: Label 'Page:';
        To__CaptionLbl: Label 'To:';
        Bill_CaptionLbl: Label 'Bill';
        Job_CaptionLbl: Label 'Job';
        Addr__CaptionLbl: Label 'Addr:';
        DescriptionCaptionLbl: Label 'Description:';
        Customer_Job_No__CaptionLbl: Label 'Customer Job No.:';
        Contract_DateCaptionLbl: Label 'Contract Date:';
        Period_ToCaptionLbl: Label 'Period To:';
        Customer_IDCaptionLbl: Label 'Customer ID:';
        Addr__Caption_Control1100773039Lbl: Label 'Addr:';
        A_ECaptionLbl: Label 'A/E';
        Totals__CaptionLbl: Label 'Totals:';
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
        PreviousQty: Decimal;
        BalanceQty: Decimal;
}

