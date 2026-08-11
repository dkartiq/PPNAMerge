codeunit 14021325 "NS_Progress Billing Management"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    procedure NS_ProgressBillDelete(ProgressBillingNo: Code[20]; ProgressBillingRequisitionNo: Integer; ProgressBillingVersionNo: Integer);
    var
        PBDeleteConfirmLbl: Label 'Should the progress bill be deleted %1?',;
        PBHeader: Record "NS_Progress Billing Header";
        PBLine: Record "NS_Progress Billing Line";
        PBCommentLine: Record "NS_Progress BillingCommentLine";
        PBKeyValues: Text[80];
        MustProvideProgressBillingNoLbl: Label 'No Progress Billing No. has been provided so there will be no deletion performed';
        MustProvideRequisitionNoWithVersionNoLbl: Label 'A Requisition No. must be provided if a Version No. is being used.';
        DeletionStoppedLbl: Label 'The deletion function has been stopped.';
        RequisitionsLbl: Label 'requisitions';
        VersionsLbl: Label 'versions';
        AfterRequestLbl: Label 'The delete can not be done on this record because there are active %1 afterword.';
    begin

        if ProgressBillingNo = '' then
            ERROR(MustProvideProgressBillingNoLbl);

        if (ProgressBillingRequisitionNo = 0) and (ProgressBillingVersionNo > 0) then
            ERROR(MustProvideRequisitionNoWithVersionNoLbl);

        PBKeyValues := ProgressBillingNo;

        if ProgressBillingRequisitionNo > 0 then begin
            PBKeyValues := PBKeyValues + ' - ' + FORMAT(ProgressBillingRequisitionNo);
            if ProgressBillingVersionNo > 0 then
                PBKeyValues := PBKeyValues + ' - ' + FORMAT(ProgressBillingVersionNo);
        end;

        //Check to be sure that there are not any records after the one to be deleted
        with PBHeader do begin
            RESET;
            SETRANGE("NS_No.", ProgressBillingNo);
            SETRANGE("NS_Requisition No.", ProgressBillingRequisitionNo);
            SETRANGE("NS_Version No.", ProgressBillingVersionNo);
            if FINDFIRST then
                if NS_Status <> NS_Status::Void then begin
                    SETRANGE("NS_Version No.");
                    if FINDLAST then
                        if "NS_Version No." > ProgressBillingVersionNo then
                            ERROR(AfterRequestLbl, VersionsLbl);
                    SETRANGE("NS_Requisition No.");
                    if FINDLAST then
                        if "NS_Requisition No." > ProgressBillingRequisitionNo then
                            ERROR(AfterRequestLbl, RequisitionsLbl);
                end;
        end;

        //Confirm the deletion and then do it
        if CONFIRM(PBDeleteConfirmLbl, false, PBKeyValues) then begin
            with PBLine do begin
                RESET;
                SETRANGE("NS_Progress Billing No.", ProgressBillingNo);
                SETRANGE("NS_Requisition No.", ProgressBillingRequisitionNo);
                SETRANGE("NS_Version No.", ProgressBillingVersionNo);
                DELETEALL;
            end;
            with PBCommentLine do begin
                RESET;
                SETRANGE("NS_No.", ProgressBillingNo);
                SETRANGE("NS_Requisition No.", ProgressBillingRequisitionNo);
                SETRANGE("NS_Version No.", ProgressBillingVersionNo);
                DELETEALL;
            end;
            with PBHeader do begin
                RESET;
                SETRANGE("NS_No.", ProgressBillingNo);
                SETRANGE("NS_Requisition No.", ProgressBillingRequisitionNo);
                SETRANGE("NS_Version No.", ProgressBillingVersionNo);
                DELETEALL;
            end;
        end else
            MESSAGE(DeletionStoppedLbl);
    end;
}

