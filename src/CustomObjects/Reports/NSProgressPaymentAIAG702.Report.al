report 14021340 "NS_Progress Payment AIA G702"
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
    RDLCLayout = './Layouts/NSProgress Payment AIA G702.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Progress Payment AIA G702';

    dataset
    {
        dataitem("Progress Payment Header"; "NS_Progress Payment Header")
        {
            RequestFilterFields = "NS_No.", "NS_Requisition No.", "NS_Version No.";
            column(Title_Lbl; Title_Lbl)
            {
            }
            column(Document_Lbl; Document_Lbl)
            {
            }
            column(To_Owner_Lbl; To_Owner_Lbl)
            {
            }
            column(Project_Lbl; Project_Lbl)
            {
            }
            column(Application_No_Lbl; Application_No_Lbl)
            {
            }
            column(Period_To_Lbl; Period_To_Lbl)
            {
            }
            column(Project_Nos_Lbl; Project_Nos_Lbl)
            {
            }
            column(Contract_Date_Lbl; Contract_Date_Lbl)
            {
            }
            column(Distribution_To_Lbl; Distribution_To_Lbl)
            {
            }
            column(Distribution_To_Owner_Lbl; Distribution_To_Owner_Lbl)
            {
            }
            column(Distribution_To_Architect_Lbl; Distribution_To_Architect_Lbl)
            {
            }
            column(Distribution_To_Contractor_Lbl; Distribution_To_Contractor_Lbl)
            {
            }
            column(From_Contractor_Lbl; From_Contractor_Lbl)
            {
            }
            column(Via_Architect_Lbl; Via_Architect_Lbl)
            {
            }
            column(Contract_For_Lbl; Contract_For_Lbl)
            {
            }
            column(Contractor_Application_Heading_1_Lbl; Contractor_Application_Heading_1_Lbl)
            {
            }
            column(Contractor_Application_Heading_2_Lbl; Contractor_Application_Heading_2_Lbl)
            {
            }
            column(Contractor_Application_Heading_3_Lbl; Contractor_Application_Heading_3_Lbl)
            {
            }
            column(Line_Heading_1_Lbl; Line_Heading_1_Lbl)
            {
            }
            column(Line_Heading_2_Lbl; Line_Heading_2_Lbl)
            {
            }
            column(Line_Heading_3_Lbl; Line_Heading_3_Lbl)
            {
            }
            column(Line_Heading_4_Lbl; Line_Heading_4_Lbl)
            {
            }
            column(Line_Heading_5_Lbl; Line_Heading_5_Lbl)
            {
            }
            column(Line_Heading_5a_Lbl; STRSUBSTNO(Line_Heading_5a_Lbl, Line_05a1_Value))
            {
            }
            column(Line_Heading_5b_Lbl; STRSUBSTNO(Line_Heading_5b_Lbl, Line_05b1_Value))
            {
            }
            column(Line_Heading_5c_Lbl; Line_Heading_5c_Lbl)
            {
            }
            column(Line_Heading_6_Lbl; Line_Heading_6_Lbl)
            {
            }
            column(Line_Heading_7_Lbl; Line_Heading_7_Lbl)
            {
            }
            column(Line_Heading_8_Lbl; Line_Heading_8_Lbl)
            {
            }
            column(Line_Heading_9_Lbl; Line_Heading_9_Lbl)
            {
            }
            column(Line_Heading_10_Lbl; Line_Heading_10_Lbl)
            {
            }
            column(Line_Heading_10a_Lbl; Line_Heading_10a_Lbl)
            {
            }
            column(Line_Heading_10b_Lbl; Line_Heading_10b_Lbl)
            {
            }
            column(Line_Heading_11_Lbl; Line_Heading_11_Lbl)
            {
            }
            column(Line_Heading_12_Lbl; Line_Heading_12_Lbl)
            {
            }
            column(Line_Heading_13_Lbl; Line_Heading_13_Lbl)
            {
            }
            column(Line_Heading_14_Lbl; Line_Heading_14_Lbl)
            {
            }
            column(Undersigned_1_Lbl; Undersigned_1_Lbl)
            {
            }
            column(Undersigned_2_Lbl; Undersigned_2_Lbl)
            {
            }
            column(Undersigned_3_Lbl; Undersigned_3_Lbl)
            {
            }
            column(Undersigned_4_Lbl; Undersigned_4_Lbl)
            {
            }
            column(Undersigned_5_Lbl; Undersigned_5_Lbl)
            {
            }
            column(Contractor_Lbl; Contractor_Lbl)
            {
            }
            column(By_Lbl; By_Lbl)
            {
            }
            column(Date_Lbl; Date_Lbl)
            {
            }
            column(State_Of_Lbl; State_Of_Lbl)
            {
            }
            column(County_Of_Lbl; County_Of_Lbl)
            {
            }
            column(Subscribed_Lbl; Subscribed_Lbl)
            {
            }
            column(Me_This_Lbl; Me_This_Lbl)
            {
            }
            column(Day_Of_Lbl; Day_Of_Lbl)
            {
            }
            column(Notary_Public_Lbl; Notary_Public_Lbl)
            {
            }
            column(Commission_Expires_Lbl; Commission_Expires_Lbl)
            {
            }
            column(Architect_Certificate_Heading_Lbl; Architect_Certificate_Heading_Lbl)
            {
            }
            column(Accordance_1_Lbl; Accordance_1_Lbl)
            {
            }
            column(Accordance_2_Lbl; Accordance_2_Lbl)
            {
            }
            column(Accordance_3_Lbl; Accordance_3_Lbl)
            {
            }
            column(Accordance_4_Lbl; Accordance_4_Lbl)
            {
            }
            column(Accordance_5_Lbl; Accordance_5_Lbl)
            {
            }
            column(Amount_Certified_Lbl; Amount_Certified_Lbl)
            {
            }
            column(Attach_1_Lbl; Attach_1_Lbl)
            {
            }
            column(Attach_2_Lbl; Attach_2_Lbl)
            {
            }
            column(Attach_3_Lbl; Attach_3_Lbl)
            {
            }
            column(Architect_Lbl; Architect_Lbl)
            {
            }
            column(Certificate_1_Lbl; Certificate_1_Lbl)
            {
            }
            column(Certificate_2_Lbl; Certificate_2_Lbl)
            {
            }
            column(Certificate_3_Lbl; Certificate_3_Lbl)
            {
            }
            column(AIA_Form_Code; JobsSetup."NS_AIA Form Code")
            {
            }
            column(AIA_Form_Expiration_Date; JobsSetup."NS_AIA Form Expiration Date")
            {
            }
            column(CustomerAddress_1_; VendorAddress[1])
            {
            }
            column(CustomerAddress_2_; VendorAddress[2])
            {
            }
            column(CustomerAddress_3_; VendorAddress[3])
            {
            }
            column(CustomerAddress_4_; VendorAddress[4])
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
            column(Contract_For; Job."NS_Contract For")
            {
            }
            column(Application_No; "NS_No." + '-' + FORMAT("NS_Requisition No."))
            {
            }
            column(Period_To; "NS_Period To")
            {
            }
            column(Project_No_1; Project_No_1)
            {
            }
            column(Project_No_2; Project_No_2)
            {
            }
            column(Contract_Date; Job."NS_Contract Date")
            {
            }
            column(Line_01_Value; Line_01_Value)
            {
            }
            column(Line_02_Value; Line_02_Value)
            {
            }
            column(Line_03_Value; Line_03_Value)
            {
            }
            column(Line_04_Value; Line_04_Value)
            {
            }
            column(Line_05a2_Value; Line_05a2_Value)
            {
            }
            column(Line_05b2_Value; Line_05b2_Value)
            {
            }
            column(Line_05c_Value; Line_05c_Value)
            {
            }
            column(Line_06_Value; Line_06_Value)
            {
            }
            column(Line_07_Value; Line_07_Value)
            {
            }
            column(Line_08_Value; Line_08_Value)
            {
            }
            column(Line_09_Value; Line_09_Value)
            {
            }
            column(Line_11a_Value; Line_11a_Value)
            {
            }
            column(Line_11b_Value; Line_11b_Value)
            {
            }
            column(Line_12a_Value; Line_12a_Value)
            {
            }
            column(Line_12b_Value; Line_12b_Value)
            {
            }
            column(Line_13a_Value; Line_13a_Value)
            {
            }
            column(Line_13b_Value; Line_13b_Value)
            {
            }
            column(Line_14a_Value; Line_14a_Value)
            {
            }
            column(Contractor_Name; ContractorName)
            {
            }

            trigger OnAfterGetRecord();
            begin
                ClearFormData;
                Subcontract.GET("NS_Subcontract No.");
                Vendor.GET(Subcontract."NS_Buy-from Vendor No.");

                FormatAddress.Company(CompanyAddress, CompanyInformation);

                //Get Job Lead Contact Information
                if JobContact.GET("NS_Job No.", "NS_Owner Contact Type", "NS_Owner Contact Code") then begin
                    NS_FormatAddress.NS_JobContact(VendorAddress, JobContact);
                    VendorJobNo := JobContact."NS_Their Job No.";
                end else begin
                    CLEAR(VendorAddress);
                    VendorJobNo := '';
                end;

                //Get Architect/Engineer Contact Information
                if JobContact.GET("NS_Job No.", "NS_Arch Eng Contact Type", "NS_Arch Eng Contact Code") then begin
                    NS_FormatAddress.NS_JobContact(AEAddress, JobContact);
                    AEJobNo := JobContact."NS_Their Job No.";
                end else begin
                    CLEAR(AEAddress);
                    AEJobNo := '';
                end;

                FormatAddress.FormatAddr(JobAddress, Job.Description, '', '',
                                         Job."NS_Job Address 1", Job."NS_Job Address 2",
                                         Job."NS_Job City", Job."NS_Job Post Code",
                                         Job."NS_Job County",
                                         Job."NS_Job Country/Region Code");

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
                    ERROR(Text14021102);

                Project_No_1 := VendorJobNo;
                if Project_No_1 = '' then
                    Project_No_1 := AEJobNo
                else
                    Project_No_2 := AEJobNo;

                Line_01_Value := NS_ProgressPayBaseAmount("Progress Payment Header");
                Line_02_Value := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;
                Line_03_Value := Line_01_Value + Line_02_Value;
                Line_04_Value := WorkPreviousPayment + "NS_Requisition Total";

                Line_05a1_Value := "NS_Work Retention Percent";
                if "NS_Work Retention Percent" <> 0 then
                    Line_05a2_Value := ROUND((WorkPreviousPayment + "NS_Line Work Amount") * ("NS_Work Retention Percent" / 100), 0.01)
                else
                    Line_05a2_Value := 0;

                Line_05b1_Value := "NS_Material Retention Percent";
                if "NS_Material Retention Percent" <> 0 then
                    Line_05b2_Value := ROUND("NS_Line Material Amount" * ("NS_Material Retention Percent" / 100), 0.01)
                else
                    Line_05b2_Value := 0;

                if Line_05a2_Value + Line_05b2_Value <> 0 then
                    Line_05c_Value := Line_05a2_Value + Line_05b2_Value
                else begin
                    ProgressPaymentLine.RESET();
                    ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
                    ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                    ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                    if ProgressPaymentLine.FINDSET() then
                        repeat
                            Line_05c_Value := Line_05c_Value + ProgressPaymentLine."NS_Work Retention Amount" + ProgressPaymentLine."NS_Material Retention Amount";
                        until ProgressPaymentLine.NEXT() = 0;
                end;

                Line_06_Value := Line_04_Value - Line_05c_Value;
                Line_07_Value := NS_ProgressPayPreviousInvoice("Progress Payment Header");
                Line_08_Value := Line_06_Value - Line_07_Value;
                Line_09_Value := Line_03_Value - Line_06_Value;
                Line_11a_Value := PreviousAdditions;
                Line_11b_Value := PreviousDeductions;
                Line_12a_Value := CurrentAdditions;
                Line_12b_Value := CurrentDeductions;
                Line_13a_Value := Line_11a_Value + Line_12a_Value;
                Line_13b_Value := Line_11b_Value + Line_12b_Value;
                Line_14a_Value := Line_13a_Value - Line_13b_Value;
                ContractorName := CompanyInformation.Name;
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

    trigger OnInitReport();
    begin
        JobsSetup.GET;

        if not (
                ((JobsSetup."NS_Prog Pay AIA Form Code" > '') and
                 (JobsSetup."NS_Prog Pay AIA Form Exp Date" >= TODAY()))
                or
                JobsSetup."NS_Prog PayAIAPreprintAllowed"
               ) then
            ERROR(Text14021101);
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        Subcontract: Record NS_Subcontract;
        Job: Record Job;
        JobContact: Record "NS_Job Contact";
        ChangeJob: Record Job;
        Vendor: Record Vendor;
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        JobsSetup: Record "Jobs Setup";
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
        PeriodTo: Date;
        PreviousReqPeriodToDate: Date;
        Project_No_1: Text[30];
        Project_No_2: Text[30];
        Line_01_Value: Decimal;
        Line_02_Value: Decimal;
        Line_03_Value: Decimal;
        Line_04_Value: Decimal;
        Line_05a_Value: Text[50];
        Line_05a1_Value: Decimal;
        Line_05a2_Value: Decimal;
        Line_05b_Value: Text[50];
        Line_05b1_Value: Decimal;
        Line_05b2_Value: Decimal;
        Line_05c_Value: Decimal;
        Line_06_Value: Decimal;
        Line_07_Value: Decimal;
        Line_08_Value: Decimal;
        Line_09_Value: Decimal;
        Line_11a_Value: Decimal;
        Line_11b_Value: Decimal;
        Line_12a_Value: Decimal;
        Line_12b_Value: Decimal;
        Line_13a_Value: Decimal;
        Line_13b_Value: Decimal;
        Line_14a_Value: Decimal;
        ContractorName: Text[50];
        JobAddress: array[8] of Text[50];
        VendorAddress: array[8] of Text[50];
        VendorJobNo: Text[30];
        AEAddress: array[8] of Text[50];
        AEJobNo: Text[30];
        CompanyAddress: array[8] of Text[50];
        Text14021101: Label 'The AIA Form Code and Form Expiration Date have expired in the Jobs Setup - Progress Payment area.';
        Text14021102: Label 'There is no "Period To" date.';
        Title_Lbl: Label 'APPLICATION AND CERTIFICATE FOR PAYMENT';
        Document_Lbl: Label 'AIA DOCUMENT G702';
        To_Owner_Lbl: Label 'TO OWNER:';
        Project_Lbl: Label 'PROJECT:';
        Application_No_Lbl: Label 'APPLICATION NO:';
        Period_To_Lbl: Label 'PERIOD TO:';
        Project_Nos_Lbl: Label 'PROJECT NOS.:';
        From_Contractor_Lbl: Label 'FROM CONTRACTOR:';
        Contract_Date_Lbl: Label 'CONTRACT DATE:';
        Distribution_To_Lbl: Label 'Distribution to:';
        Distribution_To_Owner_Lbl: Label 'OWNER';
        Distribution_To_Architect_Lbl: Label 'ARCHITECT';
        Distribution_To_Contractor_Lbl: Label 'CONTRACTOR';
        Via_Architect_Lbl: Label 'VIA ARCHITECT:';
        Contract_For_Lbl: Label 'CONTRACT FOR:';
        Contractor_Application_Heading_1_Lbl: Label 'CONTRACTOR''S APPLICATION FOR PAYMENT';
        Contractor_Application_Heading_2_Lbl: Label 'Application is made for payment, as shown below, in connection with the Contract.';
        Contractor_Application_Heading_3_Lbl: Label 'Continuation Sheet, AIA Document G703, is attached.';
        Line_Heading_1_Lbl: Label '1. ORIGINAL CONTRACT SUM';
        Line_Heading_2_Lbl: Label '2. Net change by Change Orders';
        Line_Heading_3_Lbl: Label '3. CONTRACT SUM TO DATE';
        Line_Heading_4_Lbl: Label '4. TOTAL COMPLETED & STORED TO DATE';
        Line_Heading_5_Lbl: Label '5. RETAINAGE:';
        Line_Heading_5a_Lbl: Label 'a.   %1% of Completed Work';
        Line_Heading_5b_Lbl: Label 'b.   %1% of Stored Material';
        Line_Heading_5c_Lbl: Label 'Total Retainage';
        Line_Heading_6_Lbl: Label '6. TOTAL EARNED LESS RETAINAGE';
        Line_Heading_7_Lbl: Label '7. LESS PREVIOUS CERTIFICATES FOR PAYMENT';
        Line_Heading_8_Lbl: Label '8. CURRENT PAYMENT DUE';
        Line_Heading_9_Lbl: Label '9. BALANCE TO FINISH, INCLUDING RETAINAGE';
        Line_Heading_10_Lbl: Label 'CHANGE ORDER SUMMARY';
        Line_Heading_10a_Lbl: Label 'ADDITIONS';
        Line_Heading_10b_Lbl: Label 'DEDUCTIONS';
        Line_Heading_11_Lbl: Label 'Total changes approved in previous months by owner';
        Line_Heading_12_Lbl: Label 'Total approved this month';
        Line_Heading_13_Lbl: Label 'TOTALS';
        Line_Heading_14_Lbl: Label 'NET CHANGES by Change Order';
        Undersigned_1_Lbl: Label 'The undersigned Contractor certifies that to the best of the Contractor''''s knowledge, infor-';
        Undersigned_2_Lbl: Label 'mation and belief the Work covered by this Application for Payment has been completed';
        Undersigned_3_Lbl: Label 'in accordance with the Contract Documents, that all amounts have been paid by the';
        Undersigned_4_Lbl: Label 'Contractor for Work for which previous Certificates for Payment were issued and pay-';
        Undersigned_5_Lbl: Label 'ments received from the Owner, and that current payment shown herein is now due.';
        Contractor_Lbl: Label 'CONTRACTOR:';
        By_Lbl: Label 'By:';
        Date_Lbl: Label 'Date:';
        State_Of_Lbl: Label 'State of:';
        County_Of_Lbl: Label 'County of:';
        Subscribed_Lbl: Label 'Subscribed and sworn to before';
        Me_This_Lbl: Label 'me this';
        Day_Of_Lbl: Label 'day of';
        Notary_Public_Lbl: Label 'Notary Public:';
        Commission_Expires_Lbl: Label 'My Commission expires:';
        Architect_Certificate_Heading_Lbl: Label 'ARCHITECT''S CERTIFICATE FOR PAYMENT';
        Accordance_1_Lbl: Label 'In accordance with the Contract Documents, based on on-site observations and the data';
        Accordance_2_Lbl: Label 'comprising this application, the Architect certifies to the Owner that to the best of the';
        Accordance_3_Lbl: Label 'Architect''s knowledge, information and belief the Work has progressed as indicated, the';
        Accordance_4_Lbl: Label 'quality of the Work is in accordance with the Contract Documents, and the Contractor';
        Accordance_5_Lbl: Label 'is entitled to payment of the AMOUNT CERTIFIED.';
        Amount_Certified_Lbl: Label 'AMOUNT CERTIFIED';
        Attach_1_Lbl: Label '(Attach explanation if amount certified differs from the amount applied for.  Initial';
        Attach_2_Lbl: Label 'all figures on this Application and on the Continuation Sheet that are changed to';
        Attach_3_Lbl: Label 'conform to the amount certified.)';
        Architect_Lbl: Label 'ARCHITECT:';
        Certificate_1_Lbl: Label 'This Certificate is not negotiable.  The AMOUNT CERTIFIED is payable only to the Con-';
        Certificate_2_Lbl: Label 'tractor named herein.  Issuance, payment and acceptance of payment are without';
        Certificate_3_Lbl: Label 'prejudice to any rights of the Owner of Contractor under this Contract.';

    procedure ClearFormData();
    begin
        CLEAR(VendorAddress);
        CLEAR(JobAddress);
        CLEAR(AEAddress);
        CLEAR(CompanyAddress);

        Project_No_1 := '';
        Project_No_2 := '';
        Line_01_Value := 0;
        Line_02_Value := 0;
        Line_03_Value := 0;
        Line_04_Value := 0;
        Line_05a1_Value := 0;
        Line_05b1_Value := 0;
        Line_05c_Value := 0;
        Line_06_Value := 0;
        Line_07_Value := 0;
        Line_08_Value := 0;
        Line_09_Value := 0;
        Line_11a_Value := 0;
        Line_11b_Value := 0;
        Line_12a_Value := 0;
        Line_12b_Value := 0;
        Line_13a_Value := 0;
        Line_13b_Value := 0;
        Line_14a_Value := 0;
        ContractorName := '';
    end;
}

