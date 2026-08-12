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
    //PRJ-999.JS.1.0 12Nov2021 | Add Code


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
        NS_Jobs: Record Job;   //PRJ-999.JS.1.0  12Nov2021
        SalesHeader: Record "Sales Header"; //PRJCTPR-190.NC.1.0 31Aug2023
        NS_Jpl: Record "Job Planning Line"; //PRJCTPR-191.HS.1.0 16OCT2023
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
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end
            //PRJ-1686.GK.1.0 26Oct2022 end          
        end;
        //PRJ-516.ms.1.0 end
        NewNumber := -1;
        //PRJCTPR-190.NC.1.0 31Aug2023 Start
        if Not (BillingHeader.NS_Status = BillingHeader.NS_Status::Invoiced) then
            Error('Current Status of the requisition %1 is %2. To create a new requisition, the status must be Invoiced.', BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."), BillingHeader.NS_Status);

        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
        if SalesHeader.FindFirst() then
            Error('The Sales Invoice %1 is open for the requisition %2. To create new requisition, the sales invoice must be posted.', BillingHeader."NS_Sales Document No.", BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."));
        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::"Credit Memo");
        SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
        if SalesHeader.FindFirst() then
            Error('The Sales Credit Memo %1 is open for the requisition %2. To create new requisition, the sales credit memo must be posted.', BillingHeader."NS_Sales Document No.", BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."));

        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", BillingHeader."NS_No.");
        ProgressBillingHeader.SetRange(NS_Status, ProgressBillingHeader.NS_Status::Open);
        ProgressBillingHeader.SetFilter("NS_Requisition No.", '>%1', BillingHeader."NS_Requisition No.");
        if ProgressBillingHeader.FindFirst() then
            Error('There is already an open requisition for the job %1 . To create a new requisition, the status of the requisition %2 must be invoiced.', ProgressBillingHeader."NS_Job No.", ProgressBillingHeader."NS_No." + '.' + Format(ProgressBillingHeader."NS_Requisition No.") + '.' + Format(ProgressBillingHeader."NS_Version No."));
        //PRJCTPR-190.NC.1.0 31Aug2023 End

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
                    BillingHeader."NS_Multiple Retention on Lines" := ProgressBillingHeader."NS_Multiple Retention on Lines"; //PRJ-1624.NK.1.0 11Oct2022
                    NS_Final := false;
                    //PRJ-999.JS.1.0 12Nov2021 Start
                    "NS_Global Dimension 1 Code" := ProgressBillingHeader."NS_Global Dimension 1 Code";
                    "NS_Global Dimension 2 Code" := ProgressBillingHeader."NS_Global Dimension 2 Code";
                    "NS_Dimension Set ID" := ProgressBillingHeader."NS_Dimension Set ID";
                    //PRJ-999.JS.1.0 12Nov2021 end
                    "NS_Invoiced Currency Code" := ProgressBillingHeader."NS_Invoiced Currency Code";  //PE-22.JS.1.0 23FEB2023
                    INSERT;
                    //PRJ-999.JS.1.0 12Nov2021 Start
                    if NS_Jobs.get("NS_Job No.") then begin
                        "NS_Global Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                        "NS_Global Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                        "NS_Dimension Set ID" := ProgressBillingHeader.GetDimensionNoFromJob("NS_Job No.");
                    end;
                    //PRJ-999.JS.1.0 12Nov2021 end

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
                            //PRJCTPR-191.HS.1.0 12Oct2023 START
                            NS_Jpl.Reset();
                            NS_Jpl.SetRange("Job No.", ProgressBillingLine2."NS_Job No.");
                            NS_Jpl.SetRange("Job Task No.", ProgressBillingLine2."NS_Job Task No.");
                            NS_Jpl.SetRange("Line No.", ProgressBillingLine2."NS_Planing Line No.");
                            if NS_Jpl.FindFirst() then begin
                                NS_Jpl."NS_Version No." := ProgressBillingLine2."NS_Version No.";
                                NS_Jpl."NS_Requisition No." := ProgressBillingLine2."NS_Requisition No.";
                                NS_Jpl.NS_ProgessBillingNo := ProgressBillingLine2."NS_Progress Billing No.";
                                NS_Jpl.Modify();
                            end;
                            //PRJCTPR-191.HS.1.0 12Oct2023 End
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
        NS_Jpl: Record "Job Planning Line";//PRJCTPR-191.HS.1.0 12Oct2023
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
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end  
            //PRJ-1686.GK.1.0 26Oct2022 end          
        end;
        //PRJ-516.ms.1.0 end
        NewNumber := -1;

        if ProgressBillingHeader.NS_IsInvoiced(BillingHeader, 0) <> 2 then
            ERROR(Text01Lbl);

        with BillingHeader do begin
            if not NS_Final then
                if (NS_Status < NS_Status::Paid) or (NS_Status = NS_Status::Void) then
                    //(BillingHeader.NS_Status = BillingHeader.NS_Status::"Invoice Posted") then   //PRJ-1289.JS.1.0 03MAY2022  
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
                            ProgressBillingHeader2."NS_Disable Auto Post Cr. Memo" := false;  //PE-320.JS.1.0 04July2024
                            ProgressBillingHeader2."NS_Posted Sales Invoice No." := ''; //PRJ-744.GK.1.0 18May2022
                            ProgressBillingHeader2."NS_Invoiced Currency Code" := BillingHeader."NS_Invoiced Currency Code";  //PE-22.JS.1.0 23FEB2023
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
                                    //PRJCTPR-191.HS.1.0 12Oct2023 START
                                    NS_Jpl.Reset();
                                    NS_Jpl.SetRange("Job No.", ProgressBillingLine2."NS_Job No.");
                                    NS_Jpl.SetRange("Job Task No.", ProgressBillingLine2."NS_Job Task No.");
                                    NS_Jpl.SetRange("Line No.", ProgressBillingLine2."NS_Planing Line No.");
                                    if NS_Jpl.FindFirst() then begin
                                        NS_Jpl."NS_Version No." := ProgressBillingLine2."NS_Version No.";
                                        NS_Jpl."NS_Requisition No." := ProgressBillingLine2."NS_Requisition No.";
                                        NS_Jpl.NS_ProgessBillingNo := ProgressBillingLine2."NS_Progress Billing No.";
                                        NS_Jpl.Modify();
                                    end;
                                //PRJCTPR-191.HS.1.0 12Oct2023 End
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
                //PRJCTPR-378.DK.1.0 10June2024 Start
                if BillingHeader.NS_Final = true then
                    if (BillingHeader.NS_Status < BillingHeader.NS_Status::Paid) or (BillingHeader.NS_Status = BillingHeader.NS_Status::Void) then
                        if BillingHeader."NS_No." > '' then begin
                            JobsSetup.GET();
                            SalesHeader.RESET();
                            SalesHeader.SETRANGE(SalesHeader."Document Type", SalesHeader."Document Type"::Invoice);
                            SalesHeader.SetRange("NS_Job No.", BillingHeader."NS_Job No.");
                            SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
                            SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
                            SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
                            IF SalesHeader.FindLast() then
                                Message('You have to Void / Cancel the Sales Invoice No. %1', SalesHeader."No.");
                            BillingHeader.NS_Status := BillingHeader.NS_Status::Void;
                            BillingHeader.MODIFY();
                            ProgressBillingHeader.RESET();
                            ProgressBillingHeader.SETRANGE("NS_No.", BillingHeader."NS_No.");
                            ProgressBillingHeader.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                            if ProgressBillingHeader.FINDLAST() then begin
                                ProgressBillingHeader2.INIT();
                                ProgressBillingHeader2.TRANSFERFIELDS(ProgressBillingHeader);
                                ProgressBillingHeader2."NS_No." := ProgressBillingHeader."NS_No.";
                                ProgressBillingHeader2."NS_Requisition No." := ProgressBillingHeader."NS_Requisition No.";
                                ProgressBillingHeader2."NS_Version No." := ProgressBillingHeader."NS_Version No." + 1;
                                ProgressBillingHeader2.NS_Status := BillingHeader.NS_Status::Open;
                                ProgressBillingHeader2."NS_Sales Document No." := '';
                                ProgressBillingHeader2."NS_Posted Sales Invoice No." := '';
                                ProgressBillingHeader2."NS_Invoiced Currency Code" := BillingHeader."NS_Invoiced Currency Code";
                                ProgressBillingHeader2.INSERT();

                                ProgressBillingLine.RESET();
                                ProgressBillingLine.SETRANGE("NS_Progress Billing No.", BillingHeader."NS_No.");
                                ProgressBillingLine.SETRANGE("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                                ProgressBillingLine.SETRANGE("NS_Version No.", BillingHeader."NS_Version No.");
                                if ProgressBillingLine.FINDSET() then
                                    repeat
                                        ProgressBillingLine2.INIT();
                                        ProgressBillingLine2.TRANSFERFIELDS(ProgressBillingLine);
                                        ProgressBillingLine2."NS_Version No." := ProgressBillingHeader2."NS_Version No.";
                                        ProgressBillingLine2.INSERT();
                                        ProgressBillingLine2.NS_LineCalculations(ProgressBillingLine2);
                                        NS_Jpl.Reset();
                                        NS_Jpl.SetRange("Job No.", ProgressBillingLine2."NS_Job No.");
                                        NS_Jpl.SetRange("Job Task No.", ProgressBillingLine2."NS_Job Task No.");
                                        NS_Jpl.SetRange("Line No.", ProgressBillingLine2."NS_Planing Line No.");
                                        if NS_Jpl.FindFirst() then begin
                                            NS_Jpl."NS_Version No." := ProgressBillingLine2."NS_Version No.";
                                            NS_Jpl."NS_Requisition No." := ProgressBillingLine2."NS_Requisition No.";
                                            NS_Jpl.NS_ProgessBillingNo := ProgressBillingLine2."NS_Progress Billing No.";
                                            NS_Jpl.Modify();
                                        end;
                                    until ProgressBillingLine.NEXT() = 0;
                                BillingHeader.CALCFIELDS("NS_Line Work Amount");
                                BillingHeader."NS_Current Payment Due" := BillingHeader."NS_Line Work Amount" - BillingHeader."NS_Total Retention";
                                BillingHeader.MODIFY();

                                if JobsSetup."NS_Copy Version Comments From" <> JobsSetup."NS_Copy Version Comments From"::None then begin
                                    ProgressBillingCommentLine.RESET();
                                    ProgressBillingCommentLine.SETRANGE("NS_No.", ProgressBillingHeader."NS_No.");
                                    ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                                    if JobsSetup."NS_Copy Version Comments From" = JobsSetup."NS_Copy Version Comments From"::"Previous Version" then
                                        ProgressBillingCommentLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.")
                                    else
                                        ProgressBillingCommentLine.SETRANGE("NS_Version No.", 0);
                                    if ProgressBillingCommentLine.FINDSET() then
                                        repeat
                                            ProgressBillingCommentLine2.INIT();
                                            ProgressBillingCommentLine2.TRANSFERFIELDS(ProgressBillingCommentLine);
                                            ProgressBillingCommentLine2."NS_Version No." := ProgressBillingHeader2."NS_Version No.";
                                            ProgressBillingCommentLine2.INSERT();
                                        until ProgressBillingCommentLine.NEXT() = 0;
                                end;

                                NewNumber := ProgressBillingHeader2."NS_Version No.";
                                Message('The new version %1 has been created for job no. %2 Requisition no. %3',
                                    ProgressBillingHeader2."NS_Version No.", ProgressBillingHeader2."NS_Job No.",
                                    ProgressBillingHeader2."NS_Requisition No.");

                            end;
                            // MESSAGE(Text04Lbl);
                        end;
        end;
        //PRJCTPR-378.DK.1.0 10June2024 End

        exit(NewNumber);
    end;

    //PRJ-1036.GK.1.0 22Nov2021 start
    procedure NS_NewVersionCO(var BillingHeader: Record "NS_Progress Billing Header"): Integer;
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
        BillingLastLine: Integer;
        JobCO: Record Job;
        COPlanningLine: Record "Job Planning Line";
        APODesc: Text[100];
        BudgetDesc: Text[100];
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        ItemNo: Integer;
        RevCatTble: Record "NS_Job Revenue Category";
        PlanningLineAdded: Boolean;
        NSJob: Record Job; //PRJCTPR-238.NC.1.0 09Jan2024
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            //Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            //EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            //if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //    Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            //if WorkDate > Licdate then
            //    Error('Your free trial has expired.Please contact your administrator.');
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end 
            //PRJ-1686.GK.1.0 26Oct2022 end           
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
                            ProgressBillingHeader2."NS_Posted Sales Invoice No." := ''; //PRJ-744.GK.1.0 18May2022
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

                            //CO Planning Lines
                            ProgressBillingLine.Reset();
                            ProgressBillingLine.SetRange("NS_Progress Billing No.", ProgressBillingHeader2."NS_No.");
                            ProgressBillingLine.SetRange("NS_Requisition No.", ProgressBillingHeader2."NS_Requisition No.");
                            ProgressBillingLine.SetRange("NS_Version No.", ProgressBillingHeader2."NS_Version No.");
                            IF ProgressBillingLine.FindLast() then begin
                                BillingLastLine := ProgressBillingLine."NS_Line No.";
                                if Evaluate(ItemNo, ProgressBillingLine."NS_Item No.") then;
                                //ProgressBillingLine."NS_Item No.";
                            end else begin
                                BillingLastLine := 0;
                                ItemNo := 0;
                            end;
                            JobCO.Reset();
                            JobCO.SetRange(Status, JobCO.Status::Open);
                            JobCO.SetRange("NS_Sub-Level to Job No.", ProgressBillingHeader2."NS_Job No.");
                            JobCO.SetRange("NS_Job Class", JobCo."NS_Job Class"::"Change Order");
                            JobCO.SetRange("NS_Progress Billing Sub-Level", false);
                            JobCO.SetFilter("NS_Progress Billing No.", '%1', '');
                            IF JobCO.FindSet() then begin
                                repeat
                                    COPlanningLine.reset;
                                    COPlanningLine.SetRange("Job No.", JobCO."No.");
                                    COPlanningLine.SetFilter("Line Type", '%1|%2', COPlanningLine."Line Type"::Billable,
                                                            COPlanningLine."Line Type"::"Both Budget and Billable");
                                    If COPlanningLine.FindSet() then begin
                                        PlanningLineAdded := false;
                                        repeat
                                            if (COPlanningLine."NS_Entry Type" = COPlanningLine."NS_Entry Type"::Price) or (COPlanningLine."NS_Entry Type" = COPlanningLine."NS_Entry Type"::Both) then begin
                                                APODesc := '';
                                                BudgetDesc := COPlanningLine.Description;
                                                if JobActivity.GET(JobActivity.NS_Type::Revenue, COPlanningLine."NS_Activity Code") then
                                                    APODesc := JobActivity.NS_Description;

                                                if JobProcess.GET(JobProcess.NS_Type::Revenue, COPlanningLine."NS_Process Code") then
                                                    APODesc := JobProcess.NS_Description;

                                                if JobOperation.GET(JobOperation.NS_Type::Revenue, COPlanningLine."NS_Operation Code") then
                                                    APODesc := JobOperation.NS_Description;
                                                ProgressBillingLine.Init();
                                                ProgressBillingLine."NS_Progress Billing No." := ProgressBillingHeader2."NS_No.";
                                                ProgressBillingLine."NS_Requisition No." := ProgressBillingHeader2."NS_Requisition No.";
                                                ProgressBillingLine."NS_Version No." := ProgressBillingHeader2."NS_Version No.";
                                                BillingLastLine := BillingLastLine + 10000;
                                                ProgressBillingLine."NS_Line No." := BillingLastLine;
                                                ItemNo := ItemNo + 1;
                                                ProgressBillingLine."NS_Item No." := FORMAT(ItemNo);
                                                ProgressBillingLine."NS_Job No." := COPlanningLine."Job No.";
                                                ProgressBillingLine."NS_Revenue Category" := COPlanningLine."NS_Revenue Category";
                                                //PRJ-702.AS.1.0 - start
                                                if RevCatTble.Get(ProgressBillingLine."NS_Revenue Category") then
                                                    ProgressBillingLine."NS_Revenue Cat Description" := RevCatTble.NS_Description;
                                                //PRJ-702.AS.1.0 - end
                                                ProgressBillingLine."NS_Job Task No." := COPlanningLine."Job Task No.";
                                                ProgressBillingLine."NS_Activity Code" := COPlanningLine."NS_Activity Code";
                                                ProgressBillingLine."NS_Process Code" := COPlanningLine."NS_Process Code";
                                                ProgressBillingLine."NS_Operation Code" := COPlanningLine."NS_Operation Code";
                                                if BudgetDesc > '' then
                                                    ProgressBillingLine.NS_Description := BudgetDesc
                                                else
                                                    ProgressBillingLine.NS_Description := APODesc;
                                                ProgressBillingLine."NS_Billing Method" := COPlanningLine."NS_Progress Billing Method";
                                                if ProgressBillingLine."NS_Billing Method" = ProgressBillingLine."NS_Billing Method"::Unit then begin
                                                    ProgressBillingLine."NS_Contract Quantity" := COPlanningLine.Quantity;
                                                    ProgressBillingLine."NS_Base Amount" := COPlanningLine."Unit Price";
                                                    if COPlanningLine.Quantity < 0 then
                                                        ProgressBillingLine."NS_Base Amount" := ProgressBillingLine."NS_Base Amount" * -1;
                                                end else
                                                    ProgressBillingLine."NS_Base Amount" := COPlanningLine."Total Price";
                                                ProgressBillingLine."NS_Segment Code" := COPlanningLine."NS_Segment Code"; //TM-10.AM.1.0
                                                                                                                           //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 start
                                                ProgressBillingLine."NS_Unit of Measure Code" := COPlanningLine."Unit of Measure Code";
                                                ProgressBillingLine."NS_Planing Line No." := COPlanningLine."Line No.";
                                                ProgressBillingLine."NS_Scheduled Values" := COPlanningLine."Line Amount (LCY)";
                                                //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 end    
                                                //PRJCTPR-238.NC.1.0 09Jan2024 Start 
                                                if NSJob.get(COPlanningLine."Job No.") then;
                                                if NSJob."NS_Job Class" = NSJob."NS_Job Class"::"Change Order" then
                                                    ProgressBillingLine."NS_Change Order" := true;
                                                ProgressBillingLine."NS_Contract Forecast Date" := COPlanningLine."NS_Contract Forecast Date";
                                                //PRJCTPR-238.NC.1.0 09Jan2024 End

                                                ProgressBillingLine.INSERT();
                                                PlanningLineAdded := true;
                                                ProgressBillingLine.VALIDATE("NS_Work Retention Percent", JobCO."NS_Default Job Retention");
                                                ProgressBillingLine.NS_LineCalculations(ProgressBillingLine);
                                            end;
                                        until COPlanningLine.Next() = 0;
                                    end;
                                    if PlanningLineAdded then begin
                                        JobCO."NS_Progress Billing No." := ProgressBillingHeader2."NS_No.";
                                        JobCO."NS_Progress Billing Sub-Level" := true;
                                        JobCO.Modify();
                                    end;
                                until JobCO.Next() = 0;
                            end;
                            //CO Planning Lines
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


    procedure NS_NewRequisitionCO(var BillingHeader: Record "NS_Progress Billing Header"): Integer;
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
        BillingLastLine: Integer;
        ItemNo: Integer;
        JobCO: Record Job;
        COPlanningLine: Record "Job Planning Line";
        APODesc: Text[100];
        BudgetDesc: Text[100];
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        // ItemNo: Integer;
        RevCatTble: Record "NS_Job Revenue Category";
        PlanningLineAdded: Boolean;
        SalesHeader: Record "Sales Header"; //PRJCTPR-190.NC.1.0 18Sep2023
        NSJob: Record job; //PRJCTPR-238.NC.1.0 09Jan2024 
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            //Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            //EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            //if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //    Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            //if WorkDate > Licdate then
            //    Error('Your free trial has expired.Please contact your administrator.');
            //PRJ-1686.GK.1.0 26Oct2022 start
            //PRJ-1641.JS.1.0 23SEP2022 - Start		
            // Licdate := DMY2Date(30, 11, 2022);
            // Licdate := DMY2Date(31, 12, 2022);
            // Licdate := DMY2Date(31, 1, 2023);
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 15)) and (WorkDate <= Licdate) then
            //     Message('Your ProjectPro license is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your ProjectPro license has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();   //PRJ-1641.JS.1.0 23SEP2022 line commented
            //PRJ-1641.JS.1.0 23SEP2022 - end
            //PRJ-1686.GK.1.0 26Oct2022 end            
        end;
        //PRJ-516.ms.1.0 end
        NewNumber := -1;
        //PRJCTPR-190.NC.1.0 31Aug2023 Start
        if Not (BillingHeader.NS_Status = BillingHeader.NS_Status::Invoiced) then
            Error('Current Status of the requisition %1 is %2. To create a new requisition, the status must be Invoiced.', BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."), BillingHeader.NS_Status);

        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
        if SalesHeader.FindFirst() then
            Error('The Sales Invoice %1 is open for the requisition %2. To create new requisition, the sales invoice must be posted.', BillingHeader."NS_Sales Document No.", BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."));
        SalesHeader.Reset();
        SalesHeader.SetFilter("Document Type", '%1', SalesHeader."Document Type"::"Credit Memo");
        SalesHeader.SetRange("NS_From Progress Billing No.", BillingHeader."NS_No.");
        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", BillingHeader."NS_Requisition No.");
        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", BillingHeader."NS_Version No.");
        if SalesHeader.FindFirst() then
            Error('The Sales Credit Memo %1 is open for the requisition %2. To create new requisition, the sales credit memo must be posted.', BillingHeader."NS_Sales Document No.", BillingHeader."NS_No." + '.' + Format(BillingHeader."NS_Requisition No.") + '.' + Format(BillingHeader."NS_Version No."));


        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", BillingHeader."NS_No.");
        ProgressBillingHeader.SetRange(NS_Status, ProgressBillingHeader.NS_Status::Open);
        ProgressBillingHeader.SetFilter("NS_Requisition No.", '>%1', BillingHeader."NS_Requisition No.");
        if ProgressBillingHeader.FindFirst() then
            Error('There is already an open requisition for the job %1 . To create a new requisition, the status of the requisition %2 must be invoiced.', ProgressBillingHeader."NS_Job No.", ProgressBillingHeader."NS_No." + '.' + Format(ProgressBillingHeader."NS_Requisition No.") + '.' + Format(ProgressBillingHeader."NS_Version No."));
        //PRJCTPR-190.NC.1.0 31Aug2023 End

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
                    "NS_Owner Contact Type" := ProgressBillingHeader."NS_Owner Contact Type";
                    "NS_Owner Contact Code" := ProgressBillingHeader."NS_Owner Contact Code";
                    "NS_Requisition Date" := TODAY;
                    NS_Status := NS_Status::Open;
                    "NS_Sales Document No." := '';
                    "NS_Work Retention Percent" := ProgressBillingHeader."NS_Work Retention Percent";
                    "NS_Material Retention Percent" := ProgressBillingHeader."NS_Material Retention Percent";
                    "NS_Round Amounts" := ProgressBillingHeader."NS_Round Amounts";
                    "NS_Multiple Retention on Lines" := ProgressBillingHeader."NS_Multiple Retention on Lines"; //PRJ-1624.NK.1.0 14Nov2022                   
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

                    //CO Planning Lines
                    ProgressBillingLine.Reset();
                    ProgressBillingLine.SetRange("NS_Progress Billing No.", ProgressBillingHeader."NS_No.");
                    ProgressBillingLine.SetRange("NS_Requisition No.", BillingHeader."NS_Requisition No.");
                    ProgressBillingLine.SetRange("NS_Version No.", 0);
                    IF ProgressBillingLine.FindLast() then begin
                        BillingLastLine := ProgressBillingLine."NS_Line No.";
                        if Evaluate(ItemNo, ProgressBillingLine."NS_Item No.") then;
                        //ProgressBillingLine."NS_Item No.";
                    end else begin
                        BillingLastLine := 0;
                        ItemNo := 0;
                    end;
                    JobCO.Reset();
                    JobCO.SetRange(Status, JobCO.Status::Open);
                    JobCO.SetRange("NS_Sub-Level to Job No.", ProgressBillingHeader."NS_Job No.");
                    JobCO.SetRange("NS_Job Class", JobCO."NS_Job Class"::"Change Order");
                    JobCO.SetRange("NS_Progress Billing Sub-Level", false);
                    JobCO.SetFilter("NS_Progress Billing No.", '%1', '');
                    IF JobCO.FindSet() then begin
                        repeat
                            COPlanningLine.reset;
                            COPlanningLine.SetRange("Job No.", JobCO."No.");
                            COPlanningLine.SetFilter("Line Type", '%1|%2', COPlanningLine."Line Type"::Billable,
                                                   COPlanningLine."Line Type"::"Both Budget and Billable");
                            If COPlanningLine.FindSet() then begin
                                PlanningLineAdded := false;
                                repeat
                                    if (COPlanningLine."NS_Entry Type" = COPlanningLine."NS_Entry Type"::Price) or (COPlanningLine."NS_Entry Type" = COPlanningLine."NS_Entry Type"::Both) then begin
                                        APODesc := '';
                                        BudgetDesc := COPlanningLine.Description;
                                        if JobActivity.GET(JobActivity.NS_Type::Revenue, COPlanningLine."NS_Activity Code") then
                                            APODesc := JobActivity.NS_Description;

                                        if JobProcess.GET(JobProcess.NS_Type::Revenue, COPlanningLine."NS_Process Code") then
                                            APODesc := JobProcess.NS_Description;

                                        if JobOperation.GET(JobOperation.NS_Type::Revenue, COPlanningLine."NS_Operation Code") then
                                            APODesc := JobOperation.NS_Description;
                                        ProgressBillingLine.Init();
                                        ProgressBillingLine."NS_Progress Billing No." := ProgressBillingHeader."NS_No.";
                                        ProgressBillingLine."NS_Requisition No." := BillingHeader."NS_Requisition No.";
                                        ProgressBillingLine."NS_Version No." := 0;
                                        BillingLastLine := BillingLastLine + 10000;
                                        ProgressBillingLine."NS_Line No." := BillingLastLine;
                                        ItemNo := ItemNo + 1;
                                        ProgressBillingLine."NS_Item No." := FORMAT(ItemNo);
                                        ProgressBillingLine."NS_Job No." := COPlanningLine."Job No.";
                                        ProgressBillingLine."NS_Revenue Category" := COPlanningLine."NS_Revenue Category";
                                        //PRJ-702.AS.1.0 - start
                                        if RevCatTble.Get(ProgressBillingLine."NS_Revenue Category") then
                                            ProgressBillingLine."NS_Revenue Cat Description" := RevCatTble.NS_Description;
                                        //PRJ-702.AS.1.0 - end
                                        ProgressBillingLine."NS_Job Task No." := COPlanningLine."Job Task No.";
                                        ProgressBillingLine."NS_Activity Code" := COPlanningLine."NS_Activity Code";
                                        ProgressBillingLine."NS_Process Code" := COPlanningLine."NS_Process Code";
                                        ProgressBillingLine."NS_Operation Code" := COPlanningLine."NS_Operation Code";
                                        if BudgetDesc > '' then
                                            ProgressBillingLine.NS_Description := BudgetDesc
                                        else
                                            ProgressBillingLine.NS_Description := APODesc;
                                        ProgressBillingLine."NS_Billing Method" := COPlanningLine."NS_Progress Billing Method";
                                        if ProgressBillingLine."NS_Billing Method" = ProgressBillingLine."NS_Billing Method"::Unit then begin
                                            ProgressBillingLine."NS_Contract Quantity" := COPlanningLine.Quantity;
                                            ProgressBillingLine."NS_Base Amount" := COPlanningLine."Unit Price";
                                            if COPlanningLine.Quantity < 0 then
                                                ProgressBillingLine."NS_Base Amount" := ProgressBillingLine."NS_Base Amount" * -1;
                                        end else
                                            ProgressBillingLine."NS_Base Amount" := COPlanningLine."Total Price";
                                        ProgressBillingLine."NS_Segment Code" := COPlanningLine."NS_Segment Code"; //TM-10.AM.1.0
                                                                                                                   //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 start
                                        ProgressBillingLine."NS_Unit of Measure Code" := COPlanningLine."Unit of Measure Code";
                                        ProgressBillingLine."NS_Planing Line No." := COPlanningLine."Line No.";
                                        ProgressBillingLine."NS_Scheduled Values" := COPlanningLine."Line Amount (LCY)";
                                        //PRJCTPR-238.NC.1.0 09Jan2024 Start 
                                        if NSJob.get(COPlanningLine."Job No.") then;
                                        if NSJob."NS_Job Class" = NSJob."NS_Job Class"::"Change Order" then
                                            ProgressBillingLine."NS_Change Order" := true;
                                        ProgressBillingLine."NS_Contract Forecast Date" := COPlanningLine."NS_Contract Forecast Date";
                                        //PRJCTPR-238.NC.1.0 09Jan2024 End
                                        //GLEI-11.MS.1.001 //PRJ-203:AS:21APRIL2020 end    
                                        ProgressBillingLine.INSERT();
                                        PlanningLineAdded := true;
                                        ProgressBillingLine.VALIDATE("NS_Work Retention Percent", JobCO."NS_Default Job Retention");
                                        ProgressBillingLine.NS_LineCalculations(ProgressBillingLine);
                                    end;
                                until COPlanningLine.Next() = 0;
                            end;
                            if PlanningLineAdded then begin
                                JobCO."NS_Progress Billing No." := BillingHeader."NS_No.";
                                JobCO."NS_Progress Billing Sub-Level" := true;
                                JobCO.Modify();
                            end;
                        until JobCO.Next() = 0;
                    end;
                    //CO Planning Lines
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
    //PRJ-1036.GK.1.0 22Nov2021 end

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

