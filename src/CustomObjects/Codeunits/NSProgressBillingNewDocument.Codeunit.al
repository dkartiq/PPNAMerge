codeunit 14021327 "NS_Progress BillingNewDocument"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-744.JS.1.0 23July21- Add messge while Void progress billing for sales invoice
    //PRJ-855.JS.1.0 19Aug2021 | correction in message


    trigger OnRun();
    begin
    end;

    var
        xText01Lbl: Label 'There must be an existing requisition showing.';

    procedure NS_NewRequisition(var BillingHeader: Record "NS_Progress Billing Header"): Integer;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgressBillingLine2: Record "NS_Progress Billing Line";
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingCommentLine2: Record "NS_Progress BillingCommentLine";
        JobsSetup: Record "Jobs Setup";
        NewNumber: Integer;
        Text01: Label 'There must be an existing requisition showing.';
        Licdate: Date;//PRJ-516
        NoOfDays: Text;
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        NewNumber := -1;
        with BillingHeader do begin
            if "NS_No." > '' then begin
                JobsSetup.GET;
                ProgressBillingHeader.RESET;
                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                if ProgressBillingHeader.FINDLAST then begin
                    INIT;
                    "NS_No." := ProgressBillingHeader."NS_No.";
                    "NS_Requisition No." := ProgressBillingHeader."NS_Requisition No." + 1;
                    "NS_Version No." := 0;
                    "NS_Job No." := ProgressBillingHeader."NS_Job No.";
                    // >> Upgrade
                    NS_NewRequisition1(BillingHeader, ProgressBillingHeader);
                    // << Upgrade
                    "NS_Owner Contact Type" := ProgressBillingHeader."NS_Owner Contact Type";
                    "NS_Owner Contact Code" := ProgressBillingHeader."NS_Owner Contact Code";
                    "NS_Requisition Date" := TODAY;
                    NS_Status := NS_Status::Open;
                    "NS_Sales Document No." := '';
                    "NS_Work Retention Percent" := ProgressBillingHeader."NS_Work Retention Percent";
                    "NS_Material Retention Percent" := ProgressBillingHeader."NS_Material Retention Percent";
                    "NS_Round Amounts" := ProgressBillingHeader."NS_Round Amounts";
                    NS_Final := false;
                    INSERT;

                    ProgressBillingLine.RESET;
                    ProgressBillingLine.SETRANGE("NS_Progress Billing No.", ProgressBillingHeader."NS_No.");
                    ProgressBillingLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                    ProgressBillingLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.");
                    if ProgressBillingLine.FINDSET then
                        repeat
                            ProgressBillingLine2.INIT;
                            ProgressBillingLine2.TRANSFERFIELDS(ProgressBillingLine);
                            ProgressBillingLine2."NS_Requisition No." := BillingHeader."NS_Requisition No.";
                            ProgressBillingLine2."NS_Version No." := 0;
                            ProgressBillingLine2.INSERT;
                            ProgressBillingLine2.NS_LineCalculations(ProgressBillingLine2);
                            ProgressBillingLine2.MODIFY;
                        until ProgressBillingLine.NEXT = 0;

                    CALCFIELDS("NS_Line Work Amount");
                    "NS_Current Payment Due" := "NS_Line Work Amount" - "NS_Total Retention";
                    MODIFY;

                    if JobsSetup."NS_Copy Requisition Comments" then begin
                        ProgressBillingCommentLine.RESET;
                        ProgressBillingCommentLine.SETRANGE("NS_No.", ProgressBillingHeader."NS_No.");
                        ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                        ProgressBillingCommentLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.");
                        if ProgressBillingCommentLine.FINDSET then
                            repeat
                                ProgressBillingCommentLine2.INIT;
                                ProgressBillingCommentLine2.TRANSFERFIELDS(ProgressBillingCommentLine);
                                ProgressBillingCommentLine2."NS_Requisition No." := BillingHeader."NS_Requisition No.";
                                ProgressBillingCommentLine2."NS_Version No." := 0;
                                ProgressBillingCommentLine2.INSERT;
                            until ProgressBillingCommentLine.NEXT = 0;
                    end;

                    NewNumber := "NS_Requisition No.";
                end;
            end else
                MESSAGE(Text01);
        end;

        exit(NewNumber);
    end;

    procedure NS_NewVersion(var BillingHeader: Record "NS_Progress Billing Header"): Integer;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingHeader2: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgressBillingLine2: Record "NS_Progress Billing Line";
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingCommentLine2: Record "NS_Progress BillingCommentLine";
        JobsSetup: Record "Jobs Setup";
        NewNumber: Integer;
        Text01Lbl: Label 'The next requisition must not be invoiced before\making a new version for this requisition.';
        Text02Lbl: Label 'There must be an existing requisition showing.';
        Text03Lbl: Label 'The existing requisition must not be Paid.';
        Text04Lbl: Label 'This requisition is final.';
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        SalesHeader: Record 36;  //PRJ-744.JS.1.0�23July2021
        Text05Lbl: Label 'The new version %1 get created for job no. %2 requisition no. %3';  //PRJ-744.JS.1.0 02Aug2021
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        NewNumber := -1;

        if ProgressBillingHeader.NS_IsInvoiced(BillingHeader, 0) <> 2 then
            ERROR(Text01Lbl);

        with BillingHeader do begin
            if not NS_Final then
                if (NS_Status < NS_Status::Paid) or (NS_Status = NS_Status::Void) then
                    if "NS_No." > '' then begin
                        JobsSetup.GET;
                        //PRJ-744.JS.1.0�23July2021-Start
                        SalesHeader.RESET;
                        SalesHeader.SETRANGE(SalesHeader."Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.SetRange("NS_Job No.", BillingHeader."NS_Job No.");
                        SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
                        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
                        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
                        IF SalesHeader.FindLast() then
                            Message('You have to Void / Cancel the Sales Invoice No. %1', SalesHeader."No.");
                        //PRJ-744.JS.1.0�23July2021-End
                        NS_Status := NS_Status::Void;
                        MODIFY;
                        ProgressBillingHeader.RESET;
                        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                        ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                        if ProgressBillingHeader.FINDLAST then begin
                            ProgressBillingHeader2.INIT;
                            ProgressBillingHeader2.TRANSFERFIELDS(ProgressBillingHeader);
                            ProgressBillingHeader2."NS_No." := ProgressBillingHeader."NS_No.";
                            ProgressBillingHeader2."NS_Requisition No." := ProgressBillingHeader."NS_Requisition No.";
                            ProgressBillingHeader2."NS_Version No." := ProgressBillingHeader."NS_Version No." + 1;
                            ProgressBillingHeader2.NS_Status := NS_Status::Open;
                            ProgressBillingHeader2."NS_Sales Document No." := '';
                            ProgressBillingHeader2.INSERT;

                            ProgressBillingLine.RESET;
                            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
                            ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                            ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
                            if ProgressBillingLine.FINDSET then
                                repeat
                                    ProgressBillingLine2.INIT;
                                    ProgressBillingLine2.TRANSFERFIELDS(ProgressBillingLine);
                                    ProgressBillingLine2."NS_Version No." := ProgressBillingHeader2."NS_Version No.";
                                    ProgressBillingLine2.INSERT;
                                    ProgressBillingLine2.NS_LineCalculations(ProgressBillingLine2);
                                until ProgressBillingLine.NEXT = 0;

                            CALCFIELDS("NS_Line Work Amount");
                            "NS_Current Payment Due" := "NS_Line Work Amount" - "NS_Total Retention";
                            MODIFY;

                            if JobsSetup."NS_Copy Version Comments From" <> JobsSetup."NS_Copy Version Comments From"::None then begin
                                ProgressBillingCommentLine.RESET;
                                ProgressBillingCommentLine.SETRANGE("NS_No.", ProgressBillingHeader."NS_No.");
                                ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                                if JobsSetup."NS_Copy Version Comments From" = JobsSetup."NS_Copy Version Comments From"::"Previous Version" then
                                    ProgressBillingCommentLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.")
                                else
                                    ProgressBillingCommentLine.SETRANGE("NS_Version No.", 0);
                                if ProgressBillingCommentLine.FINDSET then
                                    repeat
                                        ProgressBillingCommentLine2.INIT;
                                        ProgressBillingCommentLine2.TRANSFERFIELDS(ProgressBillingCommentLine);
                                        ProgressBillingCommentLine2."NS_Version No." := ProgressBillingHeader2."NS_Version No.";
                                        ProgressBillingCommentLine2.INSERT;
                                    until ProgressBillingCommentLine.NEXT = 0;
                            end;

                            NewNumber := ProgressBillingHeader2."NS_Version No.";
                            //PRJ-744.JS.1.0 02Aug2021 - start
                            //PRJ-855.JS.1.0 19Aug2021
                            Message('The new version %1 has been created for job no. %2 Requisition no. %3',
                                ProgressBillingHeader2."NS_Version No.", ProgressBillingHeader2."NS_Job No.",
                                ProgressBillingHeader2."NS_Requisition No.");
                            //PRJ-744.JS.1.0 02Aug2021 - end
                        end;
                    end else
                        MESSAGE(Text02Lbl)
                else
                    MESSAGE(Text03Lbl)
            else
                MESSAGE(Text04Lbl);
        end;

        exit(NewNumber);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure NS_NewRequisition1(var BillingHeader: Record "NS_Progress Billing Header"; var ProgressBillingHeader: Record "NS_Progress Billing Header")
    begin
    end;
    // << Upgrade

}

