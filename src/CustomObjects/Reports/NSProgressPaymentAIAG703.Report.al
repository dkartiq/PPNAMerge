report 14021341 "NS_Progress Payment AIA G703"
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
    RDLCLayout = './Layouts/NSProgress Payment AIA G703.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'AIA G703';

    dataset
    {
        dataitem("Progress Payment Header"; "NS_Progress Payment Header")
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
            column(ApplicationNo; "Progress Payment Header"."NS_Subcontract No." + '-' + FORMAT("Progress Payment Header"."NS_Requisition No."))
            {
            }
            column(ApplicationDate; "Progress Payment Header"."NS_Requisition Date")
            {
            }
            column(PeriodTo; "Progress Payment Header"."NS_Period To")
            {
            }
            column(ArchitectProjectNo; JobContact."NS_Their Job No.")
            {
            }
            dataitem("Progress Payment Line"; "NS_Progress Payment Line")
            {
                DataItemLink = "NS_Progress Payment No." = FIELD("NS_No."), "NS_Requisition No." = FIELD("NS_Requisition No."), "NS_Version No." = FIELD("NS_Version No.");
                DataItemTableView = SORTING("NS_Progress Payment No.", "NS_Requisition No.", "NS_Line No.", "NS_Version No.", "NS_Item No.", "NS_Job No.", "NS_Cost Category", "NS_Job Task No.") ORDER(Ascending);
                column(LineNo; "NS_Line No.")
                {
                }
                column(ItemNum; ItemNum)
                {
                }
                column(Description; "NS_Task Description")
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
                    if "NS_Subcontract No." > '' then
                        DetailSubcontract.GET("NS_Subcontract No.");

                    OK := false;
                    if "NS_Subcontract No." > '' then begin
                        if (DetailSubcontract.NS_Status >= DetailSubcontract.NS_Status::Order) and
                           (DetailSubcontract."NS_Contract Date" <= "Progress Payment Header"."NS_Period To") then
                            OK := true;
                    end else
                        OK := true;

                    if not OK then
                        CurrReport.SKIP;

                    ItemNum := CommentItemNo;
                    if "NS_Item No." > '' then
                        ItemNum := "NS_Item No.";
                    "NS_Task Description" := "NS_Task Description";
                    if "NS_Payment Method" > 0 then begin
                        ScheduledValue := NS_LastBase("Progress Payment Line");
                        PreviousWork := NS_LastTotal("Progress Payment Line");
                        ThisPeriodWork := "NS_Work Amount";
                        StoredMaterials := "NS_Stored Materials Amount";
                        TotalCompletedAndStored := PreviousWork + ThisPeriodWork + StoredMaterials;
                        if ScheduledValue <> 0 then
                            TotalCompletedAndStoredPct := ROUND((TotalCompletedAndStored / ScheduledValue) * 100, 0.01)
                        else
                            TotalCompletedAndStoredPct := 0;
                        BalanceToFinish := ScheduledValue - TotalCompletedAndStored;
                        if "NS_Work Retention Amount" = 0 then
                            if "Progress Payment Header"."NS_Work Retention Percent" <> 0 then
                                "NS_Work Retention Amount" := ROUND(("Progress Payment Header"."NS_Work Retention Percent" / 100) * (PreviousWork + ThisPeriodWork));
                        if "NS_Material Retention Amount" = 0 then
                            if "Progress Payment Header"."NS_Material Retention Percent" <> 0 then
                                "NS_Material Retention Amount" := ROUND(("Progress Payment Header"."NS_Material Retention Percent" / 100) *
                                                                       "NS_Stored Materials Amount");
                        Retainage := "NS_Work Retention Amount" + "NS_Material Retention Amount";
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            begin

                Subcontract.GET("NS_Subcontract No.");
                JobContact.RESET;
                JobContact.SETRANGE("NS_Job No.", Job."No.");
                JobContact.SETRANGE(NS_Type, JobContact.NS_Type::"Architect/Engineer");
                if not JobContact.FINDSET() then
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
        JobsSetup.GET;

        if not (
                ((JobsSetup."NS_Prog Pay AIA Form Code" > '') and
                 (JobsSetup."NS_Prog Pay AIA Form Exp Date" >= TODAY()))
                or
                JobsSetup."NS_Prog PayAIAPreprintAllowed"
               ) then
            ERROR(Text14021101);

        PageNo := JobsSetup."NS_Prog Pay AIA G703StartPage";
    end;

    var
        Subcontract: Record NS_Subcontract;
        DetailSubcontract: Record NS_Subcontract;
        Job: Record Job;
        JobContact: Record "NS_Job Contact";
        JobsSetup: Record "Jobs Setup";
        ItemNum: Text[30];
        Description: Text[50];
        ScheduledValue: Decimal;
        PreviousWork: Decimal;
        ThisPeriodWork: Decimal;
        StoredMaterials: Decimal;
        TotalCompletedAndStored: Decimal;
        TotalCompletedAndStoredPct: Decimal;
        BalanceToFinish: Decimal;
        Retainage: Decimal;
        PreviousReqPeriodToDate: Date;
        Text14021101: Label 'The AIA Form Code and Form Expiration Date have expired in the Jobs Setup - Progress Payment area.';
        Text14021102: Label 'There is no ''Period To'' date.';
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
}

