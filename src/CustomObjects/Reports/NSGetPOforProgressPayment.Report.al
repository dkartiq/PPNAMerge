report 14021345 "NS_Get PO for Progress Payment"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    //     002 23-08-2021  PRE RG008 "Task P0415-13a New Progress Payment"
    // 001 20-08-2021  PRE RG008 "Task P0415-13 Get PO"

    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-906.GK.1.0  04Oct2021 |changes in code

    Caption = 'Get Contact for Progress Bill';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            RequestFilterFields = "Document Type", "No.";

            trigger OnAfterGetRecord();
            var
                NS_JobTask: Record "Job Task";
                NS_ProgressPaymentHead: Record "NS_Progress Payment Header";  //PRJ-906.GK.1.0 04Oct2021
                NS_SubContractHead: Record NS_Subcontract;  //PRJ-906.GK.1.0 04Oct2021
            begin
                ProgressPaymentLine.INIT();
                ProgressPaymentLine."NS_Progress Payment No." := ProgressPayNoIn;
                ProgressPaymentLine."NS_Requisition No." := RequisitionNoIn;
                ProgressPaymentLine."NS_Version No." := VersionNoIn;
                LastLineNo := LastLineNo + 10000;
                ProgressPaymentLine."NS_Line No." := LastLineNo;
                LastItemNo := LastItemNo + 1;
                ProgressPaymentLine."NS_Item No." := FORMAT(LastItemNo);
                ProgressPaymentLine."NS_Subcontract No." := SubcontractNoIn;
                ProgressPaymentLine."NS_Job No." := "Job No.";
                case Type of
                    Type::"G/L Account":
                        ProgressPaymentLine.NS_Type := ProgressPaymentLine.NS_Type::"G/L Account";
                    Type::Item:
                        ProgressPaymentLine.NS_Type := ProgressPaymentLine.NS_Type::Item;
                    Type::Resource:
                        ProgressPaymentLine.NS_Type := ProgressPaymentLine.NS_Type::Resource;
                    // >> 001 Upgrade
                    Type::"Fixed Asset":
                        ProgressPaymentLine.NS_Type := ProgressPaymentLine.NS_Type::"Fixed Asset";
                // << 001 Upgrade
                end;
                ProgressPaymentLine."NS_No." := "No.";
                ProgressPaymentLine."NS_No. Description" := Description;
                ProgressPaymentLine."NS_Job Task No." := "Job Task No.";

                NS_JobTask.GET("Job No.", "Job Task No.");
                ProgressPaymentLine."NS_Task Description" := NS_JobTask.Description;

                ProgressPaymentLine."NS_Cost Category" := "NS_Job Cost Category";
                // >> 001 Upgrade
                //ProgressPaymentLine."NS_Base Amount" := "Unit Cost";
                ProgressPaymentLine.Validate("NS_Base Amount", "Unit Cost");
                // << 001 Upgrade
                ProgressPaymentLine."NS_Base Quantity" := "Quantity (Base)";
                //PRJ-906.GK.1.0  04Oct2021 Start
                If NS_SubContractHead.Get(SubcontractNoIn) then begin
                    ProgressPaymentLine."NS_Work Retention Percent" := NS_SubContractHead."NS_Retention Percent";
                    If NS_ProgressPaymentHead.Get(ProgressPayNoIn, RequisitionNoIn, VersionNoIn) then begin
                        NS_ProgressPaymentHead."NS_Work Retention Percent" := NS_SubContractHead."NS_Retention Percent";
                        NS_ProgressPaymentHead.Modify();
                    end;
                end;

                //PRJ-906.GK.1.0  04Oct2021 End
                if Quantity < 0 then
                    // >> 001
                    //ProgressPaymentLine."NS_Base Amount" := -ProgressPaymentLine."NS_Base Amount";
                    ProgressPaymentLine.Validate("NS_Base Amount", -ProgressPaymentLine."NS_Base Amount");
                // << 001
                ProgressPaymentLine.INSERT();
            end;

            trigger OnPreDataItem();
            // >> Upgrade
            var
                Subcontract: Record NS_Subcontract;
                ProgressPaymentHeader: Record "NS_Progress Payment Header";
            // << Upgrade
            begin
                with PurchaseHeader do begin
                    RESET();
                    SETCURRENTKEY("NS_Subcontract No.");
                    SETRANGE("NS_Subcontract No.", SubcontractNoIn);
                    SETRANGE("Document Type", "Document Type"::Order);
                    if COUNT = 0 then
                        CurrReport.QUIT;
                    // >> 002 Upgrade
                    FINDFIRST;
                    IF Subcontract.GET(SubcontractNoIn) THEN
                        IF Subcontract."NS_Purchase Document No." <> '' THEN
                            PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Subcontract."NS_Purchase Document No.");
                    // << 002 Upgrade
                end;
                // #RG008 Start Upgrade
                ProgressPaymentHeader.GET(ProgressPayNoIn, RequisitionNoIn, VersionNoIn);
                IF ProgressPaymentHeader."NS_Purchase Order No." <> PurchaseHeader."No." THEN BEGIN
                    ProgressPaymentHeader."NS_Purchase Order No." := PurchaseHeader."No.";
                    ProgressPaymentHeader.MODIFY;
                END;
                // #RG008 End Upgrade
                //Determine the last Line No. and Item No. so far
                LastLineNo := 0;
                LastItemNo := 0;
                ProgressPaymentLine.RESET();
                ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", ProgressPayNoIn);
                ProgressPaymentLine.SETRANGE("NS_Requisition No.", RequisitionNoIn);
                ProgressPaymentLine.SETRANGE("NS_Version No.", VersionNoIn);
                if ProgressPaymentLine.FINDLAST() then
                    LastLineNo := ProgressPaymentLine."NS_Line No.";
                ProgressPaymentLine.SETFILTER("NS_Item No.", '>%1', '');
                if ProgressPaymentLine.FINDLAST() then
                    EVALUATE(LastItemNo, ProgressPaymentLine."NS_Item No.");

                //Set Purchase Line filters
                RESET();
                SETCURRENTKEY("Document Type", "Document No.");
                SETRANGE("Document Type", PurchaseHeader."Document Type");
                SETRANGE("Document No.", PurchaseHeader."No.");
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
        SubcontractDetail: Record "NS_Subcontract Lines";
        PurchaseHeader: Record "Purchase Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        LastLineNo: Integer;
        LastItemNo: Integer;
        "Sub-Levels": Boolean;
        SubcontractNoIn: Code[20];
        ProgressPayNoIn: Code[20];
        RequisitionNoIn: Integer;
        VersionNoIn: Integer;
        APODesc: Text[30];
        Text001: Label 'Should the Subcontract %1 card be updated to show that it is part of progress paymnet %2?';
        Text002: Label 'Is subcontract %1 a change order for Progress payment %2?';
        Text004: Label 'Should the sub-level %1 subcontract card be updated to show that it is part of progress payment %2?';
        Text005: Label 'Is Subcontract %1 a sub-level for progress payment %2?';

    procedure SetParameters(SubContractNo: Code[20]; ProgPayNo: Code[20]; ReqNo: Integer; VerNo: Integer);
    begin
        SubcontractNoIn := SubContractNo;
        ProgressPayNoIn := ProgPayNo;
        RequisitionNoIn := ReqNo;
        VersionNoIn := VerNo;
    end;
}

