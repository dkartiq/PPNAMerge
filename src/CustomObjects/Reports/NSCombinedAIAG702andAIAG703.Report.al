/// <summary>
/// Report NS_Combined_AIAG702andAIAG703 (ID 14021355).
/// </summary>
report 14021355 "NS_Combined_AIAG702andAIAG703"
{

    //PRJ-858.GK.1.0 24Aug2021 |Create a combine report for AIAG702 & AIAG703 with Layout.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CombinedNSAIAG702andAIAG703.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Combined NS AIAG702 and AIAG703';

    dataset
    {
        dataitem("Progress Billing Header"; "NS_Progress Billing Header")
        {
            RequestFilterFields = "NS_No.";
            column(StartAsPageNo; PageNo)
            {
            }
            column(DocumentHeading01; DocumentHeading01)
            {
            }
            column(DocumentHeading02; DocumentHeading02)
            {
            }
            column(DocumentHeading03; DocumentHeading03)
            {
            }
            column(DocumentHeading04; DocumentHeading04)
            {
            }
            column(DocumentHeading05; DocumentHeading05)
            {
            }
            column(DocumentHeading06; DocumentHeading06)
            {
            }
            column(DocumentHeading07; DocumentHeading07)
            {
            }
            column(DocumentHeading08; DocumentHeading08)
            {
            }
            column(DocumentHeading09; DocumentHeading09)
            {
            }
            column(DocumentHeading10; DocumentHeading10)
            {
            }
            column(DocumentHeading11; DocumentHeading11)
            {
            }
            column(ColumnHeadingA1; ColumnHeadingA1)
            {
            }
            column(ColumnHeadingA2; ColumnHeadingA2)
            {
            }
            column(ColumnHeadingB1; ColumnHeadingB1)
            {
            }
            column(ColumnHeadingB2; ColumnHeadingB2)
            {
            }
            column(ColumnHeadingC1; ColumnHeadingC1)
            {
            }
            column(ColumnHeadingC2; ColumnHeadingC2)
            {
            }
            column(ColumnHeadingD1; ColumnHeadingD1)
            {
            }
            column(ColumnHeadingD2; ColumnHeadingD2)
            {
            }
            column(ColumnHeadingD3; ColumnHeadingD3)
            {
            }
            column(ColumnHeadingE1; ColumnHeadingE1)
            {
            }
            column(ColumnHeadingE2; ColumnHeadingE2)
            {
            }
            column(ColumnHeadingF1; ColumnHeadingF1)
            {
            }
            column(ColumnHeadingF2; ColumnHeadingF2)
            {
            }
            column(ColumnHeadingG1; ColumnHeadingG1)
            {
            }
            column(ColumnHeadingG2; ColumnHeadingG2)
            {
            }
            column(ColumnHeadingGA; ColumnHeadingGA)
            {
            }
            column(ColumnHeadingH1; ColumnHeadingH1)
            {
            }
            column(ColumnHeadingH2; ColumnHeadingH2)
            {
            }
            column(ColumnHeadingI1; ColumnHeadingI1)
            {
            }
            column(ColumnHeadingI2; ColumnHeadingI2)
            {
            }
            column(ApplicationNo; "Progress Billing Header"."NS_No." + '-' + FORMAT("Progress Billing Header"."NS_Requisition No.")) //CTSI-117 NS_job no. change to NS_no.
            {
            }
            column(ApplicationDate; "Progress Billing Header"."NS_Requisition Date")
            {
            }
            column(PeriodTo; "Progress Billing Header"."NS_Period To")
            {
            }
            column(ArchitectProjectNo; JobContact."NS_Their Job No.")
            {
            }
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
            dataitem("Progress Billing Line"; "NS_Progress Billing Line")
            {
                DataItemLink = "NS_Progress Billing No." = FIELD("NS_No."), "NS_Requisition No." = FIELD("NS_Requisition No."), "NS_Version No." = FIELD("NS_Version No.");
                DataItemTableView = SORTING("NS_Progress Billing No.", "NS_Requisition No.", "NS_Line No.", "NS_Version No.", "NS_Item No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.") ORDER(Ascending);
                column(LineNo; "NS_Line No.")
                {
                }
                column(ItemNum; ItemNum)
                {
                }
                // column(Description; Description) PPAL-105 N.S.1.0 14AUG2020 Comment

                column(Description; NS_Description) // PPAL-105 N.S.1.0 14AUG2020
                {
                }
                column(ScheduledValue; ScheduledValue)
                {
                }
                column(PreviousWork; PreviousWork)
                {
                }
                column(ThisPeriodWork; ThisPeriodWork)
                {
                }
                column(StoredMaterials; StoredMaterials)
                {
                }
                column(TotalCompletedAndStored; TotalCompletedAndStored)
                {
                }
                column(TotalCompletedAndStoredPct; TotalCompletedAndStoredPct)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(BalanceToFinish; BalanceToFinish)
                {
                }
                column(Retainage; Retainage)
                {
                }

                trigger OnAfterGetRecord();
                var
                    OK: Boolean;
                begin
                    //PRJ-91.SK.1.0 Start
                    CLEAR(ScheduledValue);
                    CLEAR(PreviousWork);
                    CLEAR(ThisPeriodWork);
                    CLEAR(StoredMaterials);
                    CLEAR(TotalCompletedAndStored);
                    CLEAR(TotalCompletedAndStoredPct);
                    CLEAR(BalanceToFinish);
                    CLEAR(Retainage);
                    //PRJ-91.SK.1.0 Start
                    if "NS_Job No." > '' then
                        DetailJob.GET("NS_Job No.");

                    OK := false;

                    if "NS_Job No." > '' then begin
                        if (DetailJob.Status.AsInteger() >= DetailJob.Status::Open.AsInteger()) and
                           (DetailJob."NS_Contract Date" <= "Progress Billing Header"."NS_Period To") then
                            OK := true;
                    end else
                        OK := true;

                    if not OK then
                        CurrReport.SKIP;

                    ItemNum := CommentItemNo;
                    if "NS_Item No." > '' then
                        ItemNum := "NS_Item No.";
                    //Description := Description;//PPAL-105 N.S.1.0  14AUG2020 Code Comment
                    Description := NS_Description;//PPAL-105 N.S.1.0 14AUG2020
                    if "NS_Billing Method" > 0 then begin
                        ScheduledValue := NS_LastBase("Progress Billing Line");
                        PreviousWork := NS_LastTotal("Progress Billing Line");
                        ThisPeriodWork := "NS_Work Amount";
                        StoredMaterials := "NS_Stored Materials Amount";
                        TotalCompletedAndStored := PreviousWork + ThisPeriodWork + StoredMaterials;
                        if ScheduledValue <> 0 then
                            TotalCompletedAndStoredPct := ROUND((TotalCompletedAndStored / ScheduledValue) * 100, 0.01)
                        else
                            TotalCompletedAndStoredPct := 0;
                        BalanceToFinish := ScheduledValue - TotalCompletedAndStored;
                        if "NS_Work Retention Amount" = 0 then
                            if "Progress Billing Header"."NS_Work Retention Percent" <> 0 then
                                "NS_Work Retention Amount" := ROUND(("Progress Billing Header"."NS_Work Retention Percent" / 100) * (PreviousWork + ThisPeriodWork));
                        if "NS_Material Retention Amount" = 0 then
                            if "Progress Billing Header"."NS_Material Retention Percent" <> 0 then
                                "NS_Material Retention Amount" := ROUND(("Progress Billing Header"."NS_Material Retention Percent" / 100) *
                                                                       "NS_Stored Materials Amount");
                        Retainage := "NS_Work Retention Amount" + "NS_Material Retention Amount";
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                ///new from G702
                NS_ClearFormData;
                Job.GET("NS_Job No.");
                Customer.GET(Job."Bill-to Customer No.");

                FormatAddress.Company(CompanyAddress, CompanyInformation);

                //Get Job Lead Contact Information
                if JobContact.GET("NS_Job No.", "NS_Owner Contact Type", "NS_Owner Contact Code") then begin
                    NS_FormatAddress.NS_JobContact(CustomerAddress, JobContact);
                    CustomerJobNo := JobContact."NS_Their Job No.";
                end else begin
                    CLEAR(CustomerAddress);
                    CustomerJobNo := '';
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
                    ERROR(Text14021102);

                Project_No_1 := CustomerJobNo;
                if Project_No_1 = '' then
                    Project_No_1 := AEJobNo
                else
                    Project_No_2 := AEJobNo;

                Line_01_Value := NS_ProgressBillBaseAmount("Progress Billing Header");
                Line_02_Value := PreviousAdditions - PreviousDeductions + CurrentAdditions - CurrentDeductions;
                Line_03_Value := Line_01_Value + Line_02_Value;
                Line_04_Value := WorkPreviousBilling + "NS_Requisition Total";

                Line_05a1_Value := "NS_Work Retention Percent";
                if "NS_Work Retention Percent" <> 0 then
                    Line_05a2_Value := ROUND((WorkPreviousBilling + "NS_Line Work Amount") * ("NS_Work Retention Percent" / 100), 0.01)
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
                    ProgressBillingLine.RESET();
                    ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
                    ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                    ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
                    if ProgressBillingLine.FINDSET() then
                        repeat
                            Line_05c_Value := Line_05c_Value + ProgressBillingLine."NS_Work Retention Amount" + ProgressBillingLine."NS_Material Retention Amount";
                        until ProgressBillingLine.NEXT() = 0;
                end;

                Line_06_Value := Line_04_Value - Line_05c_Value;
                Line_07_Value := NS_ProgressBillPreviousInvoice("Progress Billing Header");
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
                /// new from G702 end

                Job.GET("NS_Job No.");
                JobContact.RESET;
                JobContact.SETRANGE("NS_Job No.", Job."No.");
                JobContact.SETRANGE(NS_Type, JobContact.NS_Type::"Architect/Engineer");
                if not JobContact.FINDSET then
                    CLEAR(JobContact."NS_Their Job No.");

                if "NS_Period To" = 0D then
                    ERROR(Text14021102);

                PreviousReqPeriodToDate := NS_GetPeriodFromDate("NS_No.", "NS_Period To");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Start as Page No"; PageNo)
                    {
                        MinValue = 1;
                        ApplicationArea = All;
                    }
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

    trigger OnInitReport();
    begin
        JobsSetup.GET();

        if not (
                ((JobsSetup."NS_AIA Form Code" > '') and
                 (JobsSetup."NS_AIA Form Expiration Date" >= TODAY()))
                or
                JobsSetup."NS_AIA Preprinted Allowed"
               ) then
            ERROR(Text14021101);

        PageNo := JobsSetup."NS_AIA G703 Start As Page No.";
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET();
    end;

    var
        Job: Record Job;
        DetailJob: Record Job;
        JobContact: Record "NS_Job Contact";
        JobsSetup: Record "Jobs Setup";
        ItemNum: Text[30];
        //Description: Text[50]; PPAL-105 N.S.1.0 Comment
        Description: Text[100];//PPAL-105 N.S.1.0 14AUG2020
        ScheduledValue: Decimal;
        PreviousWork: Decimal;
        ThisPeriodWork: Decimal;
        StoredMaterials: Decimal;
        TotalCompletedAndStored: Decimal;
        TotalCompletedAndStoredPct: Decimal;
        BalanceToFinish: Decimal;
        Retainage: Decimal;
        // PreviousReqPeriodToDate: Date;
        //Text14021101: Label 'The AIA Form Code and Form Expiration Date have expired in the Jobs Setup - Progress Billing area.';
        //Text14021102: Label 'There is no ''Period To'' date.';
        CommentItemNo: Label '0';
        DocumentHeading01: Label 'CONTINUATION SHEET';
        DocumentHeading02: Label 'AIA DOCUMENT G703';
        DocumentHeading03: Label 'PAGE';
        DocumentHeading04: Label 'AIA Document G703, APPLICATION AND CERTIFICATE FOR PAYMENT,';
        DocumentHeading05: Label 'containing Contractor''s signed Certification is attached.';
        DocumentHeading06: Label 'In tabulations below, amounts are stated to the nearest dollar.';
        DocumentHeading07: Label 'Use Column I on Contacts where variable retainage for line items may apply.';
        DocumentHeading08: Label 'APPLICATION NO.:';
        DocumentHeading09: Label 'APPLICATION DATE:';
        DocumentHeading10: Label 'PERIOD TO:';
        DocumentHeading11: Label 'ARCHITECT''S PROJECT NO.:';
        ColumnHeadingA1: Label 'A';
        ColumnHeadingA2: Label 'ITEM NO.';
        ColumnHeadingB1: Label 'B';
        ColumnHeadingB2: Label 'DESCRIPTION OF WORK';
        ColumnHeadingC1: Label 'C';
        ColumnHeadingC2: Label 'SCHEDULED VALUE';
        ColumnHeadingD1: Label 'D';
        ColumnHeadingD2: Label 'WORK COMPLETED';
        ColumnHeadingD3: Label 'FROM PREVIOUS APPLICATION';
        ColumnHeadingE1: Label 'E';
        ColumnHeadingE2: Label 'THIS PERIOD';
        ColumnHeadingF1: Label 'F';
        ColumnHeadingF2: Label 'MATERIALS PRESENTLY STORED';
        ColumnHeadingG1: Label 'G';
        ColumnHeadingG2: Label 'TOTAL COMPLETED AND STORED TO DATE';
        ColumnHeadingGA: Label '%';
        ColumnHeadingH1: Label 'H';
        ColumnHeadingH2: Label 'BALANCE TO FINISH';
        ColumnHeadingI1: Label 'I';
        ColumnHeadingI2: Label 'RETAINAGE';
        PageNo: Integer;
        CompanyInformation: Record "Company Information";

        ChangeJob: Record Job;
        Customer: Record Customer;
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PrevProgressBillingHeader: Record "NS_Progress Billing Header";
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
        CustomerAddress: array[8] of Text[50];
        CustomerJobNo: Text[30];
        AEAddress: array[8] of Text[50];
        AEJobNo: Text[30];
        CompanyAddress: array[8] of Text[50];
        Text14021101: Label 'The AIA Form Code and Form Expiration Date have expired in the Jobs Setup - Progress Billing area.';
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
        Test: Label 'TEST!!!';

    /// <summary>
    /// NS_ClearFormData.
    /// </summary>
    procedure NS_ClearFormData();
    begin
        CLEAR(CustomerAddress);
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

