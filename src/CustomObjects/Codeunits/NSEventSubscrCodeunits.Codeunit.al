codeunit 14021111 "NS_Event Subscr. Codeunits"
{
    // version SPLN1.00

    // 2019-01-14 SPLN1.00 DMT Created
    //PRJ-44.SK.1.0 Start Added code for handling error in case currency code in blank
    //PRJ-44.SK.1.0 Modified code for validating quantity
    //PRJ-55.SK.1.0 Modified code in case "Ship-to-Code" is blank
    //PRJ-64.SK.1.0 Modified string
    //PRJ-137.SK.1.0 Added a subscriber to remove some transaferfields values while copy document
    //PRJ-141.SK.1.0 Added some code
    //PRJ-179.SK.1.0 Added some code
    //PRJ-182.SK.1.0 Added suscriber events
    //PRJ-148.SK.1.0 Added events and code
    //PRJ-158/159 VT 25-03-20 Added events subscriber
    //PRJ-189.MS.1.0 added code for retantion ledger code error 
    //PRJ-180.MS.1.0 added code for job no floe from planing line to sales invoice
    //PRJ-247/CTSI-23.MS.1.0 validate jon no for creation PO from Req. worksheet
    //PRJ-208.SK.1.0 Added code for dimension flow
    //PRJ-196 VT 08-04-20 Added Code and Events
    //JD-10.MS.1.0 added code
    //PRJ-253 AS1.0 30-04-20 - Added some code in C1002OnBeforeInsertSalesLine()
    //PRJ-240 VT1.0 23-04-20 Code Added	  
    //PRJ-253 AS2.0 05-05-2020 -Added some code
    //PRJ-246.MS.1.0 Add code for use tax error	
    //PPAL-9.SK.1.0 Replaced an existing event with newly published event
    //PRJ-234.TY.1.0 - 20APRIL2020 Added Code
    //PRJ-263 VT1.0 01-05-20 Code Added
    //PRJ-312.MS.1.0 Added codes
    //PRJ-261.MS.1.0 add code for job name	//PPAL-21
    //PRJ-130.MS.1.0 add code for purchaser code on the basis of user setup
    //PRJ-294.AS.1.0 29JUNE2020 -Added Function C1006OnAfterCopyJobToAddCostCategoryLines
    //PRJ-318.MS.1.0 code comment for Jobledgerentry double UOM issues
    //PPAL-73.SK.1.0 - 28AUG2020 - Added code for handle type of resource on purchase line 28AUG2020
    //CTSI-122.MS.1.0 added code for job cost cat error on undo receipt
    //PPAL-126.N.S.1.0 01Sep2020 when copy job planning line Suncontract No. & subcontract line is blank
    //CTSI-150.AS.1.0 added code
    //PRJ-420.MS.1.0 code added for GBPG floe from Job card to SI
    //PRJ-415.MS.1.0 flow of salesperson from Job to SI
    //CTSI-179.MS.1.0 added code for flow of custome po in ext. doc no.
    //TM-10.AM.1.0 | Added code to flow segment code in documents .
    //PRJ-415.MS.1.0 flow of salesperson from Job to SI
    //PRJ-613.N.S.1.0 Change in Currency code calculation
    //PRJ-571.MS.1.0 new changes for unit price in T&M issue of resource price 
    //PRJ-671.N.S.1.0 Change tax base amount according to currency factor
    //PRJ-817.JS.1.0�04Aug2021 | Add code to flow values for work unit and work unit of measure
    //PRJ-844.JS.1.0-09Aug2021 | Replace existion event OnBeforeReopenSalesDoc from OnReopenOnBeforeSalesHeaderModify
    //PRJ-911.GK.1.0 10Sep2021 | Added new line for flowing Retention Percent.
    //PRJ-939.JS.1.0 29Sep2021 | Add new procedure 
    //PRJ-906.GK.1.0 5Oct2021 | Added code
    //PRJ-1015.JS.1.0  10Oct2021 | code Added
    //PRJ-1002.GK.1.0 21Oct2021 | Changes in code
    //PRJ-1039.JS.1.0 15Nov2021 | Add Code
    //PRJ-999.JS.1.1 24Nov2021 | update code for job dimension
    //PRJ-1117.JS.1.0 07Dec2022 | Add code to flow varient code
    //PRJ-1148.JS.1.0 20JAN2022 | Correct code Regarding dimension
    //PRJ-1165.JS.1.0 24JAN2022 | correct code for No. Series already exist issue
    //PRJ-1144.JS.1.0  31JAN2022 | correct code for crew timesheet
    //PRJ-1218.JS.1.0  23FEB2022 | correct code for copy jobs
    //PRJ-1221.JS.1.0 24FEB2022 - Repleace standard function OnCreateHeaderAddField
    //PRJ-1225.JS.1.0 28FEB2022 | correct condition
    //PRJ-1380.NK.1.0 13May2022 | added code for job purchaser
    //PRJ-1411.RM.1.0 08June2022 | Added some code 
    //PRJ-1510.NK.1.0 21Jul2022|  | Added Code  
    //PRJ-1467.NK.1.0 21Jun2022 |Add Code     
    //PRJ-1562.RM.1.0 17Aug2022 | Added some code
    //PRJ-1707.NK.1.0 16Nov2022 | Added Code
    //PRJCTPR-26.JS.1.0 17JAN2023 | Add new even
    //PE-43.NK.1.0   |aded document type return order and credit memo in event OnBeforePostPurchaseDoc
    //PE-43.RM.1.0 24Feb2023 | Added some code
    //PE-61.NK.1.0 21Mar2023 | Added code
    //PE-64.RM.1.0 27March2023 | Corrected Unit cost of FA on JLE.
    //PRJCTPR-115.AT.1.0 17May2023 | Flow the value
    //PRJCTPR-197 Dk.1.0 31March2023 | Job No. Rewrite Issue.
    //PRJCTPR-191.DK.1.0 25Sep23  | Add EventSubscriber
    //PRJCTPR-214.VC.1.0 26Oct2023 | Credit Memo in progress billing creates closed retention entry.(FOR-10)
    //PRJCTPR-207.VC.1.0 27Oct2023 | Retention CLE for Credit Memos
    //PRJCTPR-252.HS.1.0 19Dec2023 | Added EventSubscriber
    //PRJCTPR-296.HS.1.0 17Jan2024 |  Added EventSubscriber
    //PE-265.DK.1.0.18March2024 |Add the Message "Please use "Create Corrective Retention Credit Memo" function in this case"
    trigger OnRun()
    begin
    end;

    var
        p: Codeunit "NS_Parameters for Events";
        TempPrepaidSalesLine: Record "Sales Line" temporary;
    //PE-59.GK.1.0 14Mar2023 start
    [EventSubscriber(ObjectType::Codeunit, 5069, 'OnGetDataSourceOnBeforeRestoreGlobalLanguage', '', false, false)]
    //[EventSubscriber(ObjectType::Codeunit, 5054, 'OnAddFieldsToMergeSource', '', false, false)]
    local procedure NS_C5054OnAddFieldsToMergeSource(var InteractLogEntry: Record "Interaction Log Entry"; var SegLine: Record "Segment Line"; var DataSource: Dictionary of [Text, Text])
    //local procedure NS_C5054OnAddFieldsToMergeSource(var TempNameValueBuffer: Record "Name/Value Buffer" temporary; Salesperson: Record "Salesperson/Purchaser"; Country: Record "Country/Region"; Contact: Record Contact; CompanyInfo: Record "Company Information"; SegmentLine: Record "Segment Line"; InteractionLogEntry: Record "Interaction Log Entry")
    //PE-59.GK.1.0 14Mar2023 end
    var
        ContactNo: Code[20];
    begin
        //PE-59.GK.1.0 14Mar2023 start
        // if InteractionLogEntry.IsEmpty then
        //     ContactNo := SegmentLine."Contact No."
        // else
        //     ContactNo := InteractionLogEntry."Contact No.";

        // if ContactNo = '' then begin
        //     TempNameValueBuffer.SetRange(ID, 1, 19);
        //     TempNameValueBuffer.DeleteAll;
        //     TempNameValueBuffer.SetRange(ID);
        // end;
        if InteractLogEntry.IsEmpty then
            ContactNo := SegLine."Contact No."
        else
            ContactNo := InteractLogEntry."Contact No.";
        // if ContactNo = '' then begin
        //     TempNameValueBuffer.SetRange(ID, 1, 19);
        //     TempNameValueBuffer.DeleteAll;
        //     TempNameValueBuffer.SetRange(ID);
        // end;
        //PE-59.GK.1.0 14Mar2023 end

    end;
    //PRJ-464.AM.1.0 start //PPAL-171.AM.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnAfterCopyJob', '', false, false)]
    local procedure CopySegments(SourceJob: Record Job; var TargetJob: Record Job)
    var
        SegmentsRec: record "NS_Job Takeoff Segments";
        TargetSegmentRec: Record "NS_Job Takeoff Segments";
        //PRJCTPR-235.JS.1.0 05JAN2023 - Start
        TargetSegmentRec2: Record "NS_Job Takeoff Segments";
        NSAPOSLinkLineSource: Record "NS_APO Links Line";
        NSAPOSLinkLineTarget: Record "NS_APO Links Line";
        NSAPOSLinkLineTarget2: Record "NS_APO Links Line";
        NSJobs: Record Job;
        NStempCounter: integer;
    //PRJCTPR-235.JS.1.0 05JAN2023 - end        
    begin
        TargetJob."NS_Salesperson Code" := SourceJob."NS_Salesperson Code";
        //TargetJob."NS_Gen. Bus. Posting Group" := SourceJob."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        // TargetJob."NS_Gen. Prod. Posting Group" := SourceJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        TargetJob."NS_Gen. Prod. Posting Group New" := SourceJob."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New

        TargetJob."NS_Gen. Bus. Posting Group New" := SourceJob."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                 //PRJCTPR-371.JS.1.0 16MAY2024-Start
        TargetJob."NS_POC Method" := SourceJob."NS_POC Method";
        if TargetJob."NS_POC Method" = TargetJob."NS_POC Method"::" " then
            TargetJob."NS_POC Method" := TargetJob."NS_POC Method"::"NS_Job forecast";
        //PRJCTPR-371.JS.1.0 16MAY2024-end 
        //Segment Copy
        SegmentsRec.Reset();
        SegmentsRec.SetRange("NS_Job No.", SourceJob."No.");
        if SegmentsRec.FindSet() then
            repeat
                TargetSegmentRec.Init();
                TargetSegmentRec.validate("NS_Job No.", TargetJob."No.");
                TargetSegmentRec."NS_Segment Code" := SegmentsRec."NS_Segment Code";
                TargetSegmentRec.NS_Type := SegmentsRec.NS_Type;
                TargetSegmentRec."NS_Size of Weld" := SegmentsRec."NS_Size of Weld";
                TargetSegmentRec."NS_Segment Name" := SegmentsRec."NS_Segment Name";
                TargetSegmentRec."NS_Segment Description" := SegmentsRec."NS_Segment Description";
                TargetSegmentRec."NS_Billing Type" := SegmentsRec."NS_Billing Type";
                TargetSegmentRec."NS_Unit of Measure Code" := SegmentsRec."NS_Unit of Measure Code";
                TargetSegmentRec.validate("NS_Estimated Quantity", SegmentsRec."NS_Estimated Quantity");
                TargetSegmentRec.Validate("NS_Unit Rate", SegmentsRec."NS_Unit Rate");
                TargetSegmentRec.Validate("NS_Total Cost", SegmentsRec."NS_Total Cost");
                TargetSegmentRec.Insert();
            until SegmentsRec.Next() = 0;

        //PRJCTPR-235.JS.1.0 05JAN2023 - Start
        if NSJobs.get(SourceJob."No.") then
            if NSJobs."NS_Job Class" = NSJobs."NS_Job Class"::"Master Job" then begin
                NSAPOSLinkLineSource.Reset();
                NSAPOSLinkLineSource.setrange(NS_Code, SourceJob."No.");
                if NSAPOSLinkLineSource.findset() then
                    repeat
                        NSAPOSLinkLineTarget.Reset();
                        NSAPOSLinkLineTarget.setrange(NS_Type, NSAPOSLinkLineSource.NS_Type);
                        NSAPOSLinkLineTarget.setrange("NS_Code", TargetJob."No.");
                        NSAPOSLinkLineTarget.setrange("NS_Source Type", NSAPOSLinkLineSource."NS_Source Type");
                        NSAPOSLinkLineTarget.setrange("NS_Source Activity Code", NSAPOSLinkLineSource."NS_Source Activity Code");
                        NSAPOSLinkLineTarget.setrange("NS_Source Process Code", NSAPOSLinkLineSource."NS_Source Process Code");
                        NSAPOSLinkLineTarget.setrange("NS_Source Operation Code", NSAPOSLinkLineSource."NS_Source Operation Code");
                        NSAPOSLinkLineTarget.setrange("NS_Source Category", NSAPOSLinkLineSource."NS_Source Category");
                        NSAPOSLinkLineTarget.setrange("NS_Destination Type", NSAPOSLinkLineSource."NS_Destination Type");
                        NSAPOSLinkLineTarget.setrange("NS_Destination Activity Code", NSAPOSLinkLineSource."NS_Destination Activity Code");
                        NSAPOSLinkLineTarget.setrange("NS_Destination Process Code", NSAPOSLinkLineSource."NS_Destination Process Code");
                        NSAPOSLinkLineTarget.setrange("NS_Destination Operation Code", NSAPOSLinkLineSource."NS_Destination Operation Code");
                        NSAPOSLinkLineTarget.setrange("NS_Destination Category", NSAPOSLinkLineSource."NS_Destination Category");
                        if not NSAPOSLinkLineTarget.findfirst() then begin
                            NSAPOSLinkLineTarget.Init();
                            NSAPOSLinkLineTarget.TransferFields(NSAPOSLinkLineSource);
                            NSAPOSLinkLineTarget."NS_Code" := TargetJob."No.";
                            NSAPOSLinkLineTarget.Insert();
                        end;
                    until NSAPOSLinkLineSource.next() = 0;
            end;
        //PRJCTPR-235.JS.1.0 05JAN2023 - end 

    end;
    //PRJ-464.AM.1.0 End //PPAL-171.AM.1.0 End

    //PPAL-171.AM.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnBeforeInsertSalesLine', '', false, false)]
    local procedure FlowSegmentCode(var SalesLine: Record "Sales Line"; JobPlanningLine: Record "Job Planning Line")
    begin
        SalesLine.Validate("NS_Segment Code", JobPlanningLine."NS_Segment Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromPlanningLineToJnlLine', '', false, false)]
    local procedure FlowSegmentCodeToJournalline(JobPlanningLine: Record "Job Planning Line"; var JobJournalLine: Record "Job Journal Line")
    begin
        JobJournalLine.Validate("NS_Segment Code", JobPlanningLine."NS_Segment Code");
        JobJournalLine.Validate("NS_Job Cost Category", JobPlanningLine."NS_Cost Category");
    end;
    //PPAL-171.AM.1.0 End

    //PRJ-1221.JS.1.0 24FEB2022 - Repleace standard function OnCreateHeaderAddFields Start
    //[EventSubscriber(ObjectType::Codeunit, 5054, 'OnCreateHeaderAddFields', '', false, false)]
    //PE-59.GK.1.0 14Mar2023 start   
    // [EventSubscriber(ObjectType::Codeunit, 5054, 'OnAddFieldsToMergeSource', '', false, false)]
    // local procedure NS_C5054OnCreateHeaderAddFields(var TempNameValueBuffer: Record "Name/Value Buffer" temporary; Salesperson: Record "Salesperson/Purchaser"; Country: Record "Country/Region"; Contact: Record Contact; CompanyInfo: Record "Company Information"; SegmentLine: Record "Segment Line"; InteractionLogEntry: Record "Interaction Log Entry")
    [EventSubscriber(ObjectType::Codeunit, 5069, 'OnGetDataSourceOnBeforeRestoreGlobalLanguage', '', false, false)]
    local procedure NS_C5054OnCreateHeaderAddFields(var InteractLogEntry: Record "Interaction Log Entry"; var SegLine: Record "Segment Line"; var DataSource: Dictionary of [Text, Text])
    //PE-59.GK.1.0 14Mar2023 end
    var
        ContactNo: Code[20];
    begin
        //PE-59.GK.1.0 14Mar2023 start
        // if InteractionLogEntry.IsEmpty then
        //     ContactNo := SegmentLine."Contact No."
        // else
        //     ContactNo := InteractionLogEntry."Contact No.";

        // if ContactNo = '' then begin
        //     TempNameValueBuffer.SetRange(ID, 1, 19);
        //     TempNameValueBuffer.DeleteAll;
        //     TempNameValueBuffer.SetRange(ID);
        // end;
        if InteractLogEntry.IsEmpty then
            ContactNo := SegLine."Contact No."
        else
            ContactNo := InteractLogEntry."Contact No.";
        // if ContactNo = '' then begin
        //     TempNameValueBuffer.SetRange(ID, 1, 19);
        //     TempNameValueBuffer.DeleteAll;
        //     TempNameValueBuffer.SetRange(ID);
        // end;
        //PE-59.GK.1.0 14Mar2023 end
    end;
    //PRJ-1221.JS.1.0 24FEB2022 - end

    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 10202, 'OnBeforeGetAppliedVendEntries', '', false, false)]
    // local procedure C10202OnBeforeGetAppliedVendEntries(var VendLedgEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         VendLedgEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    // end;
    // PPNA16.0 Blocked End



    [EventSubscriber(ObjectType::Table, 382, 'OnAfterCopyFromCustLedgerEntry', '', false, false)]
    //local procedure C10201OnBeforeCustLedgEntryTOCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; CustLedgEntry: Record "Cust. Ledger Entry")
    local procedure NS_T382OnAfterCopyFromCustLedgerEntry(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CVLedgerEntryBuffer."NS_Retention Ledger Code" := CustLedgerEntry."NS_Retention Ledger Code";
    end;
    //PRJCTPR-11.GK.1.0 20Apr2023 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Cust. Entry-Edit", 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure NS_CustEntryEditOnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry."NS_Lien Waiver Print Status" := FromCustLedgEntry."NS_Lien Waiver Print Status";
        CustLedgEntry."NS_Lien Waiver Signed Date" := FromCustLedgEntry."NS_Lien Waiver Signed Date";
        CustLedgEntry."NS_Lien Waiver Type" := FromCustLedgEntry."NS_Lien Waiver Type";
        CustLedgEntry."NS_Lien Waiver Amount" := FromCustLedgEntry."NS_Lien Waiver Amount";
        CustLedgEntry."NS_Lien Waiver Payment" := FromCustLedgEntry."NS_Lien Waiver Payment";
        CustLedgEntry."NS_Lien Waiver Work Type" := FromCustLedgEntry."NS_Lien Waiver Work Type";
    end;
    //PRJCTPR-11.GK.1.0 20Apr2023 end

    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 10085, 'OnAfterOnRun', '', false, false)]
    // local procedure C10085OnAfterOnRun(var Codes: array[3, 30] of Code[10])
    // begin
    //     Clear(Codes[3, 12]);
    // end;
    //PPNA16.0 Blocked End



    //[EventSubscriber(ObjectType::Codeunit, 7320, 'OnBeforeInsertTempWhseJnlLine', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 7302, 'OnAfterCreateWhseJnlLine', '', false, false)]
    // local procedure C7320OnBeforeInsertTempWhseJnlLine(ItemJnlLine: Record "Item Journal Line")
    local procedure NS_C7302OnAfterCreateWhseJnlLine(WhseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line"; ToTransfer: Boolean)
    begin
        p.NS_C7320SetQtyperUnitofMeasure(ItemJournalLine."Qty. per Unit of Measure");

    end;

    //[EventSubscriber(ObjectType::Codeunit, 7320, 'OnInsertTempWhseJnlLineBeforeCreateWhseJnlLine', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 7320, 'OnBeforeTempWhseJnlLineInsert', '', false, false)]
    // local procedure C7320OnInsertTempWhseJnlLineBeforeCreateWhseJnlLine(var ItemJnlLine: Record "Item Journal Line")
    local procedure NS_C7320OnBeforeTempWhseJnlLineInsert(var WarehouseJournalLine: Record "Warehouse Journal Line"; WarehouseEntry: Record "Warehouse Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."Qty. per Unit of Measure" := p.NS_C7320GetQtyperUnitofMeasure;
    end;


    //PPNA17.0 Opened Start OnBeforeJobJnlLineFindResCost
    //PRJ-158/159 VT 25-03-20
    [EventSubscriber(ObjectType::Codeunit, 7010, 'OnFindJobJnlLinePriceOnBeforeResourceFindCost', '', false, false)]
    local procedure NS_C7010OnBeforeJobJnlLineFindResCost(var ResCost: Record "Resource Cost"; JobJournalLine: Record "Job Journal Line")
    begin
        with JobJournalLine do begin
            IF Type = Type::Resource THEN BEGIN
                ResCost."NS_Job No." := "Job No.";
                ResCost."NS_Job Task No." := "Job Task No.";
                ResCost."NS_Currency Code" := "Currency Code";
            end;
        end;
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Codeunit, 7010, 'OnAfterJobPlanningLineFindResCost', '', false, false)]
    local procedure NS_C7010OnAfterJobPlanningLineFindResCost(var JobPlanningLine: Record "Job Planning Line"; ResourceCost: Record "Resource Cost")
    var
        Currency: Record Currency;
    begin
        with JobPlanningLine do begin
            IF JobPlanningLine."Currency Code" <> '' then
                IF Currency.GET("Currency Code") then;
            IF Type = Type::Resource then begin
                "Unit Cost (LCY)" := Round(ResourceCost."Unit Cost" * "Qty. per Unit of Measure",
                                            Currency."Unit-Amount Rounding Precision");
                "Unit Cost" := Round(ResourceCost."Unit Cost" * "Qty. per Unit of Measure",
                                      Currency."Unit-Amount Rounding Precision");
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterUpdatePurchLine', '', false, false)]
    local procedure NS_C6620OnAfterUpdatePurchLine(var ToPurchHeader: Record "Purchase Header"; var ToPurchLine: Record "Purchase Line"; var FromPurchHeader: Record "Purchase Header"; var FromPurchLine: Record "Purchase Line"; var CopyThisLine: Boolean; RecalculateAmount: Boolean; FromPurchDocType: Option; var CopyPostedDeferral: Boolean)
    begin
        ToPurchLine."Gen. Bus. Posting Group" := FromPurchLine."Gen. Bus. Posting Group";
        ToPurchLine."Gen. Prod. Posting Group" := FromPurchLine."Gen. Prod. Posting Group";
        ToPurchLine."Tax Liable" := FromPurchLine."Tax Liable";
        ToPurchLine."Tax Area Code" := FromPurchLine."Tax Area Code";
        ToPurchLine."Tax Group Code" := FromPurchLine."Tax Group Code";
        ToPurchLine."Job No." := FromPurchLine."Job No.";
        ToPurchLine."Job Task No." := FromPurchLine."Job Task No.";
        ToPurchLine."NS_Job Cost Category" := FromPurchLine."NS_Job Cost Category";
        ToPurchLine."NS_Job Revenue Category" := FromPurchLine."NS_Job Revenue Category";
        ToPurchLine."NS_Retention Applies" := FromPurchLine."NS_Retention Applies";
        ToPurchLine."NS_Retention Base Before Tax" := FromPurchLine."NS_Retention Base Before Tax";   //PRJ-939.JS.1.0 27Sep2021
        ToPurchLine."NS_Retention Base Amount" := FromPurchLine."NS_Retention Base Amount";  //PRJ-939.JS.1.0 27Sep2021
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterUpdateSalesLine', '', false, false)]
    local procedure NS_C6620OnAfterUpdateSalesLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; var FromSalesHeader: Record "Sales Header"; var FromSalesLine: Record "Sales Line"; var CopyThisLine: Boolean; RecalculateAmount: Boolean; FromSalesDocType: Option; var CopyPostedDeferral: Boolean)
    begin
        ToSalesLine."Gen. Bus. Posting Group" := FromSalesLine."Gen. Bus. Posting Group";
        ToSalesLine."Gen. Prod. Posting Group" := FromSalesLine."Gen. Prod. Posting Group";
        ToSalesLine."Tax Liable" := FromSalesLine."Tax Liable";
        ToSalesLine."Tax Area Code" := FromSalesLine."Tax Area Code";
        ToSalesLine."Tax Group Code" := FromSalesLine."Tax Group Code";
        ToSalesLine."Job No." := FromSalesLine."Job No.";
        ToSalesLine."Job Task No." := FromSalesLine."Job Task No.";
        ToSalesLine."NS_Job Cost Category" := FromSalesLine."NS_Job Cost Category";
        ToSalesLine."NS_Job Revenue Category" := FromSalesLine."NS_Job Revenue Category";
        ToSalesLine."NS_Retention Applies" := FromSalesLine."NS_Retention Applies";
    end;

    [EventSubscriber(ObjectType::Codeunit, 5987, 'OnAfterTransferValuesToJobJnlLine', '', false, false)]
    local procedure NS_C5987OnAfterTransferValuesToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; ServiceLine: Record "Service Line")
    begin
        JobJournalLine."NS_Job Cost Category" := ServiceLine."NS_Job Cost Category";
        JobJournalLine."NS_Job Revenue Category" := ServiceLine."NS_Job Revenue Category";
        JobJournalLine."NS_Retention Ledger Code" := ServiceLine."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Table, 207, 'OnAfterCopyResJnlLineFromServLine', '', false, false)]
    local procedure T207OnAfterCopyResJnlLineFromServLine(var ServLine: Record "Service Line"; var ResJnlLine: Record "Res. Journal Line")
    begin
        ResJnlLine."NS_Retention Ledger Code" := ServLine."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromServHeader', '', false, false)]
    local procedure NS_T81OnAfterCopyGenJnlLineFromServHeader(ServiceHeader: Record "Service Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        GenJournalLine."NS_Retention Ledger Code" := SalesSetup."NS_Normal Customer Ledger No.";
    end;

    [Obsolete('Replaced by Microsoft with event OnPostLinesOnBeforeGenJnlLinePost in Codeunit Service Post Invoice Events.', '22.0')]//PE-129.AS.4.0
    [EventSubscriber(ObjectType::Codeunit, 5987, 'OnBeforePostInvoicePostBuffer', '', false, false)]
    local procedure NS_C5987OnBeforePostInvoicePostBuffer(var GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; ServiceHeader: Record "Service Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJournalLine."NS_Retention Ledger Code" := InvoicePostBuffer."NS_Retention Ledger Code";
    end;

    //PE-129.AS.4.0 start add
    [EventSubscriber(ObjectType::Codeunit, 827, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure NS_CU827OnPostLinesOnBeforeGenJnlLinePost(var GenJnlLine: Record "Gen. Journal Line"; ServiceHeader: Record "Service Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        GenJnlLine."NS_Retention Ledger Code" := TempInvoicePostingBuffer."NS_Retention Ledger Code";
    end;
    //PE-129.AS.4.0 end add

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromServLine', '', false, false)]
    local procedure NS_T83OnAfterCopyItemJnlLineFromServLine(var ItemJnlLine: Record "Item Journal Line"; ServLine: Record "Service Line")
    begin
        ItemJnlLine."NS_Retention Ledger Code" := ServLine."NS_Retention Ledger Code";
    end;

    //[EventSubscriber(ObjectType::Codeunit, 5051, 'OnBeforeTestFields', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 5051, 'OnBeforeInteractLogEntryInsert', '', false, false)]
    local procedure NS_C5051OnBeforeInteractLogEntryInsert(SegmentLine: Record "Segment Line")
    var
        Cont: Record Contact;
        Salesperson: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        InteractTmpl: Record "Interaction Template";
        ContAltAddr: Record "Contact Alt. Address";
    begin
        with SegmentLine do begin
            TestField(Date);
            //ProjectPro - start
            if SegmentLine."NS_Job Quote No." = '' then begin
                //ProjectPro - end
                TestField("Contact No.");
                Cont.Get("Contact No.");
                //ProjectPro - start
            end;
            //ProjectPro - end
            if "Document Type" = "Document Type"::" " then begin
                TestField("Salesperson Code");
                Salesperson.Get("Salesperson Code");
            end;
            TestField("Interaction Template Code");
            InteractTmpl.Get("Interaction Template Code");
            if "Campaign No." <> '' then
                Campaign.Get("Campaign No.");
            case "Correspondence Type" of
                "Correspondence Type"::Email:
                    begin
                        if Cont."E-Mail" = '' then
                            "Correspondence Type" := "Correspondence Type"::" ";

                        if ContAltAddr.Get("Contact No.", "Contact Alt. Address Code") then
                            if ContAltAddr."E-Mail" <> '' then
                                "Correspondence Type" := "Correspondence Type"::Email;
                    end;
                "Correspondence Type"::Fax:
                    begin
                        if Cont."Fax No." = '' then
                            "Correspondence Type" := "Correspondence Type"::" ";

                        if ContAltAddr.Get("Contact No.", "Contact Alt. Address Code") then
                            if ContAltAddr."Fax No." <> '' then
                                "Correspondence Type" := "Correspondence Type"::Fax;
                    end;
            end;
        end;
    end;

    //PRJ-9.TY.1.0 Start
    //PPNA16.0 Modified Event Start //PPAL-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1026, 'OnBeforeMatchUsageSpecified', '', false, false)]
    local procedure NS_C1012OnBeforeApplyUsageLink(VAR JobLedgerEntry: Record "Job Ledger Entry"; VAR JobJournalLine: Record "Job Journal Line"; VAR IsHandled: Boolean; var JobPlanningLine: Record "Job Planning Line")
    var
    begin
        JobPlanningLine.GET(JobLedgerEntry."Job No.", JobLedgerEntry."Job Task No.", JobJournalLine."Job Planning Line No.");
        IF JobPlanningLine."Usage Link" THEN
            JobPlanningLine.Validate("Unit Cost", JobLedgerEntry."Unit Cost");
    end;
    //PRJ-9.TY.1.0 End
    //PPNA16.0 Modified Event End  //PPAL-9.SK.1.0 End

    //PRJ-9.TY.1.0 Start
    // [EventSubscriber(ObjectType::Codeunit, 1026, 'OnMatchUsageSpecifiedBeforeUse', '', false, false)]
    // local procedure C1026OnMatchUsageSpecifiedBeforeUse(var JobPlanningLine: Record "Job Planning Line"; JobLedgerEntry: Record "Job Ledger Entry")
    // begin
    //     JobPlanningLine.Validate("Unit Cost", JobLedgerEntry."Unit Cost");
    // end;
    //PRJ-9.TY.1.0 End


    //PRJ-44.SK.1.0 Start

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Check Line", 'OnBeforeTestJobJnlLine', '', false, false)]
    local procedure NS_C1011OnBeforeTestJobJnlLine(JobJournalLine: Record "Job Journal Line"; var IsHandled: Boolean)
    begin
        With JobJournalLine do Begin
            TESTFIELD("Job No.");
            // TESTFIELD("Job Task No."); //PE-200.AS.11.0 Comment
            TESTFIELD("No.");
            TESTFIELD("Posting Date");
            IF not "Job Posting Only" then
                TestField(Quantity);
            IsHandled := true;
        End;
    end;
    //PE-200.AS.11.0 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnCheckJobOnBeforeTestJobTaskType', '', false, false)]
    local procedure NS_OnCheckJobOnBeforeTestJobTaskType(var IsHandled: Boolean; var JobJournalLine: Record "Job Journal Line")
    begin
        if JobJournalLine."Entry Type" = JobJournalLine."Entry Type"::NS_Payment then
            IsHandled := true;
    end;
    //PE-200.AS.11.0 END

    // PRJCTPR-404.AT.24July2024 Comment Start
    //PE-200.AS.11.0 START
    // [EventSubscriber(ObjectType::Codeunit, 1001, 'OnBeforePostGenJnlLine', '', false, false)]
    // // local procedure NS_OnBeforePostGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; var IsHandled: Boolean; var JobJnlPostLine: Codeunit "Job Jnl.-Post Line"; var JobJournalLine: Record "Job Journal Line")
    // local procedure NS_OnBeforePostGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    // begin
    //     if (GenJournalLine."Source Code" = 'PAYMENTJNL') AND (GenJournalLine."Job No." <> '') then
    //         IsHandled := true;

    //     if (GenJournalLine."Source Code" = 'CASHRECJNL') AND (GenJournalLine."Job No." <> '') then
    //         IsHandled := true;
    // end;
    //PE-200.AS.11.0 END
    // PRJCTPR-404.AT.24July2024 Comment End
    // [EventSubscriber(ObjectType::Codeunit, 1011, 'OnBeforeRunCheck', '', false, false)]
    // local procedure C1011OnBeforeRunCheck(var JobJnlLine: Record "Job Journal Line")
    // begin
    //     with JobJnlLine do begin
    //         if ("Job No." = '') and ("No." = '') and (Quantity = 0) then
    //             exit;

    //         if NOT "Job Posting Only" and (Quantity = 0) then begin //PRJ-44.SK.1.0
    //             p.NS_C1011SetQuantity(Quantity);
    //             Quantity := 1;
    //         end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1011, 'OnAfterRunCheck', '', false, false)]
    // local procedure C1011OnAfterRunCheck(var JobJnlLine: Record "Job Journal Line")
    // begin
    //     with JobJnlLine do
    //         if NOT "Job Posting Only" and (p.NS_C1011GetQuantity = 0) then //PRJ-44.SK.1.0
    //             Quantity := p.NS_C1011GetQuantity;
    // end;

    //PRJ-44.SK.1.0 End

    //PRJ-9.TY.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnAfterCopyJobTask', '', false, false)]
    local procedure NS_C1006OnAfterCopyJobTask(VAR TargetJobTask: Record "Job Task"; SourceJobTask: Record "Job Task"; CopyPrices: Boolean; CopyQuantity: Boolean)
    var
        QuoteHeader: Record "NS_Job Quote Header";
        TargetJob: Record job;
        CheckTargetJobTask: Record "Job Task";//PRJ-604
    begin
        // TargetJob.Get(TargetJobTask."Job No.");//PRJCTPR-140.AT.1.0 20JUNE2023 Commented
        if TargetJob.Get(TargetJobTask."Job No.") then;//PRJCTPR-140.AT.1.0 20JUNE2023 Add

        if QuoteHeader.Get(TargetJob."No.") then
            TargetJobTask."NS_Quote No." := TargetJob."No."
        else
            if TargetJob."NS_Quote No." <> '' then
                TargetJobTask."NS_Quote No." := TargetJob."NS_Quote No."
            else
                TargetJobTask."NS_Quote No." := '';
        //PRJ-604.AS.1.0 - START
        CheckTargetJobTask.Reset();
        CheckTargetJobTask.SetRange("Job No.", TargetJobTask."Job No.");
        CheckTargetJobTask.SetRange("Job Task No.", TargetJobTask."Job Task No.");
        if CheckTargetJobTask.FindFirst() then
            //PRJ-604.AS.1.0 - END
            TargetJobTask.Modify(true);
    end;
    //PRJ-9.TY.1.0 End

    //PRJ-9.TY.1.0 Start
    // [EventSubscriber(ObjectType::Codeunit, 1006, 'OnCopyJobTasksBeforeInsert', '', false, false)]

    // local procedure C1006OnCopyJobTasksBeforeInsert(var TargetJobTask: Record "Job Task"; TargetJob: Record Job)
    // var
    //     QuoteHeader: Record "Job Quote Header";
    // begin
    //     if QuoteHeader.Get(TargetJob."No.") then
    //         TargetJobTask."Quote No." := TargetJob."No."
    //     else
    //         if TargetJob."Quote No." <> '' then
    //             TargetJobTask."Quote No." := TargetJob."Quote No."
    //         else
    //             TargetJobTask."Quote No." := '';
    // end;
    //PRJ-9.TY.1.0 End


    //PRJ-604.AS.1.0 - START
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnCopyJobPlanningLinesOnAfterCopyTargetJobPlanningLine', '', false, false)]
    local procedure MyProcedure()
    begin

    end;
    //PRJ-604.AS.1.0 - END

    //PRJ-1340.GK.1.0 04May2022 start
    //PRJ-604.AS.1.0 - START
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnCopyJobPlanningLinesOnAfterCopyTargetJobPlanningLine', '', false, false)]
    local procedure OnCopyJobPlanningLinesOnAfterCopyTargetJobPlanningLine(SourceJobPlanningLine: Record "Job Planning Line"; var TargetJobPlanningLine: Record "Job Planning Line")
    Var
        AssBOMComp: Record "NS_Assembley BOM Components";
        AssBOMComp1: Record "NS_Assembley BOM Components";
        AssBOMComp2: Record "NS_Assembley BOM Components";
    begin
        if SourceJobPlanningLine."NS_Assembley BOM" = true then begin
            AssBOMComp1.Reset();
            AssBOMComp1.SetRange("NS_Job No.", TargetJobPlanningLine."Job No.");
            AssBOMComp1.SetRange("NS_Job Task No.", TargetJobPlanningLine."Job Task No.");
            AssBOMComp1.SetRange("NS_Ref. JPL Line No.", TargetJobPlanningLine."Line No.");
            if AssBOMComp1.FindSet() then begin
                AssBOMComp1.DeleteAll();
            end;
            AssBOMComp.Reset();
            AssBOMComp.SetRange("NS_Job No.", SourceJobPlanningLine."Job No.");
            AssBOMComp.SetRange("NS_Job Task No.", SourceJobPlanningLine."Job Task No.");
            AssBOMComp.SetRange("NS_Ref. JPL Line No.", SourceJobPlanningLine."Line No.");
            if AssBOMComp.FindSet() then
                repeat
                    AssBOMComp2.Init();
                    AssBOMComp2 := AssBOMComp;
                    AssBOMComp2.Validate("NS_Job No.", TargetJobPlanningLine."Job No.");
                    AssBOMComp2.Validate("NS_Job Task No.", TargetJobPlanningLine."Job Task No.");
                    AssBOMComp2."NS_Line No." := AssBOMComp."NS_Line No.";
                    AssBOMComp2.Insert();
                until AssBOMComp.Next() = 0;
        end;

    end;
    //PRJ-604.AS.1.0 - END
    //PRJ-1340.GK.1.0 04May2022 end


    //PRJ-1321.AS.1.0 START
    [EventSubscriber(ObjectType::Codeunit, 13, 'OnBeforeCheckBalance', '', false, false)]
    local procedure NS_OnBeforeCheckbalance(CommitIsSuppressed: Boolean; CurrencyBalance: Decimal; CurrentBalance: Decimal; CurrentBalanceReverse: Decimal; GenJnlLine: Record "Gen. Journal Line"; GenJnlTemplate: Record "Gen. Journal Template"; LastCurrencyCode: Code[10]; LastDate: Date; LastDocNo: Code[20]; LastDocType: Option; StartLineNo: Integer; StartLineNoReverse: Integer)
    var
        //Text012: Label '%5 %2 is out of balance by %1. ';
        Text012: Label 'Balancing account cannot be blank for the Document No. %1';
        Text013: Label 'Please check that %3, %4, %5 and %6 are correct for each line.';
        Text014: Label 'The lines in %1 are out of balance by %2. ';
        Text015: Label 'Check that %3 and %4 are correct for each line.';
        Text016: Label 'Your reversing entries in %4 %2 are out of balance by %1. ';
        Text017: Label 'Please check whether %3 is correct for each line for this %4.';
        Text018: Label 'Your reversing entries for %1 are out of balance by %2. ';
        Text026: Label '%5 %2 is out of balance by %1 %7. ';
        Text027: Label 'The lines in %1 are out of balance by %2 %5. ';
    begin
        with GenJnlLine do begin
            if CurrentBalance <> 0 then begin
                Get("Journal Template Name", "Journal Batch Name", StartLineNo);
                if GenJnlTemplate."Force Doc. Balance" then
                    Error(
                      Text012,
                      ("Document No."));
                // Error(
                //   Text014 +
                //   Text015,
                //   LastDate, CurrentBalance, FieldCaption("Posting Date"), FieldCaption(Amount));
            end;
            // if CurrentBalanceReverse <> 0 then begin
            //     Get("Journal Template Name", "Journal Batch Name", StartLineNoReverse);
            //     if GenJnlTemplate."Force Doc. Balance" then
            //         Error(
            //           Text016 +
            //           Text017,
            //           CurrentBalanceReverse, LastDocNo, FieldCaption("Recurring Method"), FieldCaption("Document No."));
            //     Error(
            //       Text018 +
            //       Text017,
            //       LastDate, CurrentBalanceReverse, FieldCaption("Recurring Method"), FieldCaption("Posting Date"));
            // end;
            // if (LastCurrencyCode <> '') and (CurrencyBalance <> 0) then begin
            //     Get("Journal Template Name", "Journal Batch Name", StartLineNo);
            //     if GenJnlTemplate."Force Doc. Balance" then
            //         Error(
            //           Text026 +
            //           Text013,
            //           CurrencyBalance, LastDocNo, FieldCaption("Posting Date"), FieldCaption("Document Type"),
            //           FieldCaption("Document No."), FieldCaption(Amount),
            //           LastCurrencyCode);
            //     Error(
            //       Text027 +
            //       Text015,
            //       LastDate, CurrencyBalance, FieldCaption("Posting Date"), FieldCaption(Amount), LastCurrencyCode);
            // end;
        end;
    end;
    //PRJ-1321.AS.1.0 END

    //PRJ-9.TY.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnAfterCopyJobTask', '', false, false)]
    local procedure NS_C1006OnCopyJobPlanningLinesAfterInsert(VAR TargetJobTask: Record "Job Task"; SourceJobTask: Record "Job Task"; CopyPrices: Boolean; CopyQuantity: Boolean)
    var
        QuoteHeader: Record "NS_Job Quote Header";
        TargetJob: Record job;
        SourceJob: Record job;
        SourceJobPlanningLine: Record "Job Planning Line";
        TargetJobPlanningLine: Record "Job Planning Line";
        JobPlanningLineType: Option ,Budget,Billable;
        CheckTargetJobTask: Record "Job Task";
    begin
        // TargetJob.Get(TargetJobTask."Job No.");//PRJCTPR-140.AT.1.0 20JUNE2023 Commented
        if TargetJob.Get(TargetJobTask."Job No.") then;//PRJCTPR-140.AT.1.0 20JUNE2023 Add

        // SourceJob.Get(SourceJobTask."Job No.");//PRJCTPR-140.AT.1.0 20JUNE2023 Commented
        if SourceJob.Get(SourceJobTask."Job No.") then;//PRJCTPR-140.AT.1.0 20JUNE2023 Add
        if QuoteHeader.Get(TargetJob."No.") then
            TargetJobTask."NS_Quote No." := TargetJob."No."
        else
            if TargetJob."NS_Quote No." <> '' then
                TargetJobTask."NS_Quote No." := TargetJob."NS_Quote No."
            else
                TargetJobTask."NS_Quote No." := '';
        //PRJ-604.AS.1.0 - START
        CheckTargetJobTask.Reset();
        CheckTargetJobTask.SetRange("Job No.", TargetJobTask."Job No.");
        CheckTargetJobTask.SetRange("Job Task No.", TargetJobTask."Job Task No.");
        if CheckTargetJobTask.FindFirst() then
            //PRJ-604.AS.1.0 - END
        TargetJobTask.Modify(true);
        SourceJobPlanningLine.SETRANGE("Job No.", SourceJobTask."Job No.");
        SourceJobPlanningLine.SETRANGE("Job Task No.", SourceJobTask."Job Task No.");
        CASE JobPlanningLineType OF
            JobPlanningLineType::Budget:
                SourceJobPlanningLine.SETRANGE("Line Type", SourceJobPlanningLine."Line Type"::Budget);
            JobPlanningLineType::Billable:
                SourceJobPlanningLine.SETRANGE("Line Type", SourceJobPlanningLine."Line Type"::Billable);
        END;
        SourceJobPlanningLine.SETFILTER("Planning Date", SourceJobTask.GETFILTER("Planning Date Filter"));
        IF NOT SourceJobPlanningLine.FINDLAST THEN
            EXIT;
        SourceJobPlanningLine.SETRANGE("Line No.", 0, SourceJobPlanningLine."Line No.");
        IF SourceJobPlanningLine.FINDSET THEN
            REPEAT
                TargetJobPlanningLine.SetRange("Job No.", TargetJobTask."Job No.");
                TargetJobPlanningLine.SetRange("Job Task No.", TargetJobTask."Job Task No.");
                TargetJobPlanningLine.SetRange("Line No.", SourceJobPlanningLine."Line No.");
                IF TargetJobPlanningLine.FindFirst() THEN begin   //PRJ-1218.JS.1.0 23FEB2022                    
                    //PRJ-1170.NK.1.0 Start
                    //with TargetJobPlanningLine do begin
                    if CopyPrices then begin
                        TargetJobPlanningLine."Unit Price (LCY)" := SourceJobPlanningLine."Unit Price (LCY)";
                        TargetJobPlanningLine."Unit Price" := SourceJobPlanningLine."Unit Price";
                        TargetJobPlanningLine."Unit Cost (LCY)" := SourceJobPlanningLine."Unit Cost (LCY)";
                        TargetJobPlanningLine."Unit Cost" := SourceJobPlanningLine."Unit Cost";
                        TargetJobPlanningLine."Total Cost (LCY)" := TargetJobPlanningLine."Unit Cost (LCY)" * TargetJobPlanningLine.Quantity;
                        TargetJobPlanningLine."Total Cost" := TargetJobPlanningLine."Unit Cost" * TargetJobPlanningLine.Quantity;
                        TargetJobPlanningLine."Total Price" := TargetJobPlanningLine."Unit Price" * TargetJobPlanningLine.Quantity;
                        TargetJobPlanningLine."Total Price (LCY)" := TargetJobPlanningLine."Unit Price (LCY)" * TargetJobPlanningLine.Quantity;
                        TargetJobPlanningLine."Line Amount" := SourceJobPlanningLine."Line Amount";
                        TargetJobPlanningLine."Line Amount (LCY)" := SourceJobPlanningLine."Line Amount (LCY)";
                        TargetJobPlanningLine."Line Discount %" := SourceJobPlanningLine."Line Discount %";
                        TargetJobPlanningLine."Line Discount Amount" := SourceJobPlanningLine."Line Discount Amount";
                        NS_C1006ExchangeJobPlanningLineAmounts(TargetJobPlanningLine, SourceJob."Currency Code");
                        TargetJobPlanningLine.Modify();
                    end;
                    //PPAL-126.N.S.1.0 01Sep2020 Start job planning line Suncontract No. & subcontract line is blank
                    TargetJobPlanningLine."NS_Subcontract Line No." := 0;
                    TargetJobPlanningLine."NS_Subcontract No." := '';
                    TargetJobPlanningLine.Modify();
                end;   //PRJ-1218.JS.1.0 23FEB2022 add line
            //PPAL-126.N.S.1.0 01Sep2020 End job planning line Suncontract No. & subcontract line is blank

            //end;
            //PRJ-1170.NK.1.0 End
            UNTIL SourceJobPlanningLine.NEXT = 0;
    end;
    //PRJ-9.TY.1.0 End



    local procedure NS_C1006ExchangeJobPlanningLineAmounts(var JobPlanningLine: Record "Job Planning Line"; CurrencyCode: Code[10])
    var
        Job: Record Job;
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        //Copied from C1006
        //Job.Get(JobPlanningLine."Job No.");   //PRJ-1218.JS.1.0  23FEB2022 line commented
        if Job.Get(JobPlanningLine."Job No.") then  //PRJ-1218.JS.1.0  23FEB2022 add line
            if CurrencyCode <> Job."Currency Code" then begin
                if (CurrencyCode = '') and (Job."Currency Code" <> '') then begin
                    JobPlanningLine."Currency Code" := Job."Currency Code";
                    JobPlanningLine.UpdateCurrencyFactor;
                    Currency.Get(JobPlanningLine."Currency Code");
                    Currency.TestField("Unit-Amount Rounding Precision");
                    JobPlanningLine."Unit Cost" := Round(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          JobPlanningLine."Currency Date", JobPlanningLine."Currency Code",
                          JobPlanningLine."Unit Cost (LCY)", JobPlanningLine."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision");
                    JobPlanningLine."Unit Price" := Round(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          JobPlanningLine."Currency Date", JobPlanningLine."Currency Code",
                          JobPlanningLine."Unit Price (LCY)", JobPlanningLine."Currency Factor"),
                        Currency."Unit-Amount Rounding Precision");
                    JobPlanningLine.Validate("Currency Date");
                end else begin
                    if (CurrencyCode <> '') and (Job."Currency Code" = '') then begin
                        JobPlanningLine."Currency Code" := '';
                        JobPlanningLine."Currency Date" := 0D;
                        JobPlanningLine.UpdateCurrencyFactor;
                        JobPlanningLine."Unit Cost" := JobPlanningLine."Unit Cost (LCY)";
                        JobPlanningLine."Unit Price" := JobPlanningLine."Unit Price (LCY)";
                        JobPlanningLine.Validate("Currency Date");
                    end else begin
                        if (CurrencyCode <> '') and (Job."Currency Code" <> '') then begin
                            JobPlanningLine."Currency Code" := Job."Currency Code";
                            JobPlanningLine.UpdateCurrencyFactor;
                            Currency.Get(JobPlanningLine."Currency Code");
                            Currency.TestField("Unit-Amount Rounding Precision");
                            JobPlanningLine."Unit Cost" := Round(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  JobPlanningLine."Currency Date", CurrencyCode,
                                  JobPlanningLine."Currency Code", JobPlanningLine."Unit Cost"),
                                Currency."Unit-Amount Rounding Precision");
                            JobPlanningLine."Unit Price" := Round(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  JobPlanningLine."Currency Date", CurrencyCode,
                                  JobPlanningLine."Currency Code", JobPlanningLine."Unit Price"),
                                Currency."Unit-Amount Rounding Precision");
                            JobPlanningLine.Validate("Currency Date");
                        end;
                    end;
                end;
            end;
    end;

    //PRJ-294.AS.1.0 29JUNE2020 - Start
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnAfterCopyJob', '', false, false)]
    local procedure NS_C1006OnAfterCopyJobToAddCostCategoryLines(VAR TargetJob: Record Job; SourceJob: Record Job)
    var
        SourceJobCostCategoryRec: Record "NS_Job Cost Category Price";
        TargetJobCostCategoryRec: Record "NS_Job Cost Category Price";
    begin
        SourceJobCostCategoryRec.SETRANGE("NS_Job No.", SourceJob."No.");
        IF SourceJobCostCategoryRec.FINDSET THEN
            REPEAT
                TargetJobCostCategoryRec.TRANSFERFIELDS(SourceJobCostCategoryRec, TRUE);
                TargetJobCostCategoryRec."NS_Job No." := TargetJob."No.";
                TargetJobCostCategoryRec.INSERT(TRUE);
            UNTIL SourceJobCostCategoryRec.NEXT = 0;
    end;
    //PRJ-294.AS.1.0 29JUNE2020 - end


    //PPNA17.0 Opened Start OnFromPurchaseLineToJnlLineType
    //PRJ-9.TY.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnFromPurchaseLineToJnlLineOnBeforeValidateNo', '', false, false)]
    local procedure NS_C1004OnAfterFromPurchaseLineToJnlLine2(var JobJnlLine: Record "Job Journal Line"; PurchLine: Record "Purchase Line")
    var
        ParameterForEvents: Codeunit "NS_Parameters for Events";
        OriginalLineType: Integer;
    begin
        JobJnlLine."NS_Segment Code" := PurchLine."NS_Segment Code"; //TM-10.AM.1.0

        //PPAL-73.SK.1.0 Comment start
        //PRJ-179.SK.1.0 Start
        // ParameterForEvents.NS_GetPurchLineTypeC90(PurchLine);
        //PPAL-73.SK.1.0 CommentEnd

        IF PurchLine.Type = PurchLine.Type::Resource then begin
            JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
        end;
        //PRJ-179.SK.1.0 End
    end;
    //PRJ-9.TY.1.0 End
    //PPNA17.0 Opened End


    //PRJ-182.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Job Transfer Line", 'OnAfterFromPurchaseLineToJnlLine', '', false, false)]
    local procedure NS_C1004OnAfterFromPurchaseLineToJnlLine(var JobJnlLine: Record "Job Journal Line"; PurchHeader: Record "Purchase Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; PurchLine: Record "Purchase Line"; SourceCode: Code[10])
    var
        NS_JobsSetup: Record "Jobs Setup";
        LCYCurrency: Record Currency;
        NS_Jobs: Record job;   //PRJ-1039.JS.1.0  15Nov2021
    begin
        NS_JobsSetup.Get;
        LCYCurrency.InitRoundingPrecision;

        with PurchLine do begin

            if not NS_C1004UpdateBaseQtyForPurchLine(PurchLine) then
                if (PurchLine."NS_Subcontract No." = '') or (PurchLine."Unit of Measure Code" <> NS_JobsSetup."NS_Subcontract Default UOM") then
                    JobJnlLine.Validate("Unit of Measure Code", "Unit of Measure Code")
                else
                    JobJnlLine.Validate("Unit of Measure Code", '');

            if not (PurchHeader."Document Type" in [PurchHeader."Document Type"::"Return Order",
                                               PurchHeader."Document Type"::"Credit Memo"]) then
                if PurchHeader."Vendor Shipment No." > '' then
                    JobJnlLine."External Document No." := PurchHeader."Vendor Shipment No.";

            if (JobJnlLine."Unit Price (LCY)" = 0) and (JobJnlLine."Unit Price" = 0) and
               ("Unit Price (LCY)" <> 0) then begin
                JobJnlLine."Unit Price (LCY)" := "Unit Price (LCY)";
                JobJnlLine."Unit Price" := "Unit Price (LCY)";
            end;

            JobJnlLine."NS_Job Cost Category" := "NS_Job Cost Category";
            JobJnlLine."NS_Job Revenue Category" := "NS_Job Revenue Category";
            if "NS_Job Revenue Category" > '' then
                JobJnlLine."NS_Cost-Revenue Type" := JobJnlLine."NS_Cost-Revenue Type"::Revenue;
            JobJnlLine."NS_Subcontract No." := "NS_Subcontract No.";
            JobJnlLine."NS_External Relationship Type" := JobJnlLine."NS_External Relationship Type"::Vendor;
            JobJnlLine."NS_External Relationship No." := PurchHeader."Buy-from Vendor No.";
            JobJnlLine."NS_External Relationship Name" := PurchHeader."Buy-from Vendor Name";
            //PRJ-817.JS.1.0�04Aug2021-Start
            JobJnlLine."NS_Work Units" := "NS_Work Units";
            JobJnlLine."NS_Work Unit of Measure" := "NS_Work Unit of Measure";
            JobJnlLine."NS_Work Unit Completed" := "NS_Work Unit Completed";
            //PRJ-1039.JS.1.0  15Nov2021 - Start
            If NS_Jobs.get(PurchLine."Job No.") then
                if NS_Jobs."NS_Sub-Level to Job No." = '' then
                    JobJnlLine."NS_Sub-Level to Job No." := ''
                else
                    JobJnlLine."NS_Sub-Level to Job No." := PurchLine."NS_Sub-Level to Job No.";   //PRJ-1015.JS.1.0  22Oct2021
                                                                                                   //PRJ-1039.JS.1.0  15Nov2021 - end
                                                                                                   //PRJ-817.JS.1.0�04Aug2021-End
            if ("NS_Subcontract No." > '') and ("Unit of Measure Code" = NS_JobsSetup."NS_Subcontract Default UOM") then begin
                JobJnlLine."Unit Cost (LCY)" := PurchLine."Direct Unit Cost";
                JobJnlLine."Unit Cost" := PurchLine."Direct Unit Cost";
                JobJnlLine."Total Cost (LCY)" :=
                  Round(JobJnlLine."Unit Cost (LCY)" * JobJnlLine.Quantity, LCYCurrency."Amount Rounding Precision");
            end;

            //PRJ-1696.GK.1.0 15Dec2022 start
            if PurchLine."Document Type" = PurchLine."Document Type"::Invoice then begin
                JobJnlLine."NS_Purch. Receipt Doc. No." := PurchLine."Receipt No.";
                JobJnlLine."NS_Purch. Receipt Line No." := PurchLine."Receipt Line No.";
            end;
            //PRJ-1696.GK.1.0 15Dec2022 end
        end;
    end;
    //PRJ-182.SK.1.0 End





    //PPNA17.0 Opened Start OnFromPurchaseLineToJnlLineUnitCost
    //PRJ-182.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnFromPurchaseLineToJnlLineOnAfterCalcUnitCostLCY', '', false, false)]
    local procedure NS_C1004OnFromPurchaseLineToJnlLineUnitCost(var JobJnlLine: Record "Job Journal Line"; PurchLine: Record "Purchase Line")
    begin
        //JobJnlLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";//PRJ-318.MS.1.0
    end;
    //PRJ-182.SK.1.0 End
    //PPNA17.0 Opened End


    local procedure NS_C1004UpdateBaseQtyForPurchLine(PurchLine: Record "Purchase Line"): Boolean
    var
        Item: Record Item;
    begin
        if PurchLine.Type = PurchLine.Type::Item then begin
            Item.Get(PurchLine."No.");
            Item.TestField("Base Unit of Measure");
            exit(PurchLine."Unit of Measure Code" <> Item."Base Unit of Measure");
        end;
        exit(false);
    end;



    local procedure NS_GetCurrencyRounding(CurrencyCode: Code[10])
    var
        Currency: Record Currency;
        CurrencyRoundingRead: Boolean;
        LCYCurrency: Record Currency;
    begin
        IF CurrencyRoundingRead THEN
            EXIT;
        CurrencyRoundingRead := TRUE;
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        LCYCurrency.InitRoundingPrecision;
    end;
    //PRJ-9.TY.1.0 End

    //PRJ-9.TY.1.0 Start
    local procedure NS_UpdateBaseQtyForPurchLine1(VAR Item: Record Item; PurchLine: Record "Purchase Line"): Boolean
    begin
        IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
            Item.GET(PurchLine."No.");
            Item.TESTFIELD("Base Unit of Measure");
            EXIT(PurchLine."Unit of Measure Code" <> Item."Base Unit of Measure");
        END;
        EXIT(FALSE);
    end;
    //PRJ-9.TY.1.0 End

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromJobLedgEntryToPlanningLine', '', false, false)]
    local procedure NS_C1004OnAfterFromJobLedgEntryToPlanningLine(var JobPlanningLine: Record "Job Planning Line"; JobLedgEntry: Record "Job Ledger Entry")
    begin
        JobPlanningLine."NS_Cost Category" := JobLedgEntry."NS_Job Cost Category";
        JobPlanningLine.validate("NS_Segment Code", JobLedgEntry."NS_Segment Code");//TM-10.AM.1.0
    end;

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromGenJnlLineToJnlLine', '', false, false)]
    local procedure NS_C1004OnAfterFromGenJnlLineToJnlLine(var JobJnlLine: Record "Job Journal Line"; GenJnlLine: Record "Gen. Journal Line")
    begin
        JobJnlLine."NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
        JobJnlLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        JobJnlLine."NS_Job Cost Category" := GenJnlLine."NS_Job Cost Category";
        JobJnlLine."NS_Job Revenue Category" := GenJnlLine."NS_Job Revenue Category";
        JobJnlLine."NS_Cost-Revenue Type" := GenJnlLine."NS_Cost-Revenue Type";
        JobJnlLine."NS_Segment Code" := GenJnlLine."NS_Segment Code";//PRJ-595.AM
    end;

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromPlanningSalesLineToJnlLine', '', false, false)]
    local procedure NS_C1004OnBeforeFromPlanningSalesLineToJnlLine(var JobJnlLine: Record "Job Journal Line"; JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; EntryType: Option Usage,Sale)
    var
        NS_Jobs: record job;   //PRJ-1039.JS.1.0   15Nov2021    
    begin
        JobJnlLine."NS_Job Cost Category" := SalesLine."NS_Job Cost Category";
        JobJnlLine."NS_Job Revenue Category" := SalesLine."NS_Job Revenue Category";
        //PRJ-1039.JS.1.0 15Nov2021 Start        
        if NS_Jobs.get(JobJnlLine."Job No.") then
            if NS_Jobs."NS_Sub-Level to Job No." = '' then
                JobJnlLine."NS_Sub-Level to Job No." := ''
            else
                JobJnlLine."NS_Sub-Level to Job No." := SalesLine."NS_Sub-Level to Job No.";
        //PRJ-1039.JS.1.0 15Nov2021 end      
    end;

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromJnlLineToLedgEntry', '', false, false)]
    local procedure NS_C1004OnAfterFromJnlLineToLedgEntry(var JobLedgerEntry: Record "Job Ledger Entry"; JobJournalLine: Record "Job Journal Line")
    var
        NS_Job: Record Job;
    begin
        JobLedgerEntry."NS_Retention Ledger Code" := JobJournalLine."NS_Retention Ledger Code";
        JobLedgerEntry."NS_Job Cost Category" := JobJournalLine."NS_Job Cost Category";
        JobLedgerEntry."NS_Job Revenue Category" := JobJournalLine."NS_Job Revenue Category";
        NS_Job.NS_JobTaskNoToAPO(JobLedgerEntry."Job Task No.", JobLedgerEntry."NS_Activity Code",
                              JobLedgerEntry."NS_Process Code", JobLedgerEntry."NS_Operation Code", JobLedgerEntry."NS_Section Code");//PRJ-688.AM.1.0
        JobLedgerEntry."NS_Subcontract No." := JobJournalLine."NS_Subcontract No.";
        JobLedgerEntry."NS_External Relationship Type" := JobJournalLine."NS_External Relationship Type";
        JobLedgerEntry."NS_External Relationship No." := JobJournalLine."NS_External Relationship No.";
        JobLedgerEntry."NS_External Relationship Name" := JobJournalLine."NS_External Relationship Name";
        ;
        JobLedgerEntry."NS_Work Units" := JobJournalLine."NS_Work Units";
        JobLedgerEntry."NS_Work Unit of Measure" := JobJournalLine."NS_Work Unit of Measure";
        JobLedgerEntry.Quantity := JobJournalLine.Quantity;
        JobLedgerEntry."Total Cost (LCY)" := JobJournalLine."Total Cost (LCY)";
        JobLedgerEntry."Total Price (LCY)" := JobJournalLine."Total Price (LCY)";
        JobLedgerEntry."NS_Burden Amount" := JobJournalLine."NS_Burden Amount";
        JobLedgerEntry."NS_Burden Job Cost Category" := JobJournalLine."NS_Burden Job Cost Category";
        JobLedgerEntry."NS_Payroll Burden Amount" := JobJournalLine."NS_Payroll Burden Amount";
        JobLedgerEntry."NS_Payroll Burden Job Cost Cat" := JobJournalLine."NS_Payroll Burden Job Cost Cat";
        JobLedgerEntry."NS_Employee Wage Rate" := JobJournalLine."NS_Employee Wage Rate";
        JobLedgerEntry."NS_Employee Fringe - Insurance" := JobJournalLine."NS_Employee Fringe - Insurance";
        JobLedgerEntry."NS_Employee Fringe - Vacation" := JobJournalLine."NS_Employee Fringe - Vacation";
        JobLedgerEntry."NS_Employee Fringe - Education" := JobJournalLine."NS_Employee Fringe - Education";
        JobLedgerEntry."NS_Employee Fringe - Misc. 1" := JobJournalLine."NS_Employee Fringe - Misc. 1";
        JobLedgerEntry."NS_Employee Fringe - Misc. 2" := JobJournalLine."NS_Employee Fringe - Misc. 2";
        JobLedgerEntry."NS_Employee Fringe - Misc. 3" := JobJournalLine."NS_Employee Fringe - Misc. 3";
        JobLedgerEntry."NS_Employee Fringe Total" := JobJournalLine."NS_Employee Fringe Total";
        JobLedgerEntry."NS_Prevailing Wage Rate" := JobJournalLine."NS_Prevailing Wage Rate";
        JobLedgerEntry."NS_Prevailing Fringe Rate" := JobJournalLine."NS_Prevailing Fringe Rate";
        JobLedgerEntry."NS_Wage Calculation Basis" := JobJournalLine."NS_Wage Calculation Basis";
        JobLedgerEntry."NS_Jobsite Work" := JobJournalLine."NS_Jobsite Work";
        JobLedgerEntry."NS_Payroll Work State" := JobJournalLine."NS_Payroll Work State";
        //PE-68 Dk.1.0 10April2023 Start 
        // JobLedgerEntry."NS_Skill Class" := JobJournalLine."NS_Skill Class"; 
        JobLedgerEntry."NS_Skill Class New" := JobJournalLine."NS_Skill Class New";
        //PE-68 Dk.1.0 10April2023 End
        JobLedgerEntry."NS_Segment Code" := JobJournalLine."NS_Segment Code";//TM-10.AM.1.0
        JobLedgerEntry."NS_Work Unit Completed" := JobJournalLine."NS_Work Unit Completed"; //PRJ-817.JS.1.0�04Aug2021
        JobLedgerEntry."NS_Sub-Level to Job No." := JobJournalLine."NS_Sub-Level to Job No.";   //PRJ-1015.JS.1.0  22Oct2021

    end;


    //PPNA17.0 Opened Start OnPostPurchaseGLAccountsBeforeFind 
    //PRJ-182.SK.1.0 Start
    [Obsolete('Replaced by Microsoft with event OnAfterSetJobLineFilters in CU 826 "Purch. Post Invoice Events"', '22.0')]//PE-129.AS.4.0
    [EventSubscriber(ObjectType::Codeunit, 1001, 'OnPostPurchaseGLAccountsOnAfterTempPurchaseLineJobSetFilters', '', false, false)]
    local procedure NS_C1001OnPostPurchaseGLAccountsBeforeFind(var TempPurchaseLineJob: Record "Purchase Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        IF TempPurchaseLineJob.Type <> TempPurchaseLineJob.Type::"G/L Account" THEN        //PRJ-234.TY.1.0 - 20APRIL2020 Added Code
            TempPurchaseLineJob.SetRange("Job Task No.", TempInvoicePostBuffer."NS_Job Task No.");

    end;
    //PRJ-182.SK.1.0 End
    //PPNA17.0 Opened End

    //PE-129.AS.4.0 start Add
    [EventSubscriber(ObjectType::Codeunit, 826, 'OnAfterSetJobLineFilters', '', false, false)]
    local procedure NS_CU826OnAfterSetJobLineFilters(var JobPurchLine: Record "Purchase Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        IF JobPurchLine.Type <> JobPurchLine.Type::"G/L Account" THEN        //PRJ-234.TY.1.0 - 20APRIL2020 Added Code
            JobPurchLine.SetRange("Job Task No.", InvoicePostingBuffer."NS_Job Task No.");
    end;
    //PE-129.AS.4.0 end Add

    //[EventSubscriber(ObjectType::Codeunit, 1001, 'OnAfterChangeGLNo', '', false, false)]
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterModifyEvent', '', false, false)]
    local procedure NS_T1003OnAfterModifyEvent(RunTrigger: Boolean; var Rec: Record "Job Planning Line"; var xRec: Record "Job Planning Line")
    var
        Job: Record Job;
    begin
        //Job.Get(Rec."Job No."); //PRJCTPR-197 Dk.1.0 Block
        if Job.Get(Rec."Job No.") then; //PRJCTPR-197 Dk.1.0
        //PRJ-240 VT1.0 23-04-20 Begin
        if Rec.Type = Rec.Type::Resource then begin
            // if Job."NS_Gen. Prod. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
            //     Rec."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            if Job."NS_Gen. Prod. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                Rec."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
        end
        else
            //PRJ-240 VT1.0 23-04-20 end
            // Rec."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            if Job."NS_Gen. Prod. Posting Group New" <> '' then //PRJ-1608.RM.1.0 20Sep2022
                Rec."Gen. Prod. Posting Group" := Job."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
    end;

    [EventSubscriber(ObjectType::Codeunit, 1001, 'OnBeforePostJobOnPurchaseLine', '', false, false)]
    local procedure NS_C1001OnBeforePostJobOnPurchaseLine(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchLine: Record "Purchase Line"; var JobJnlLine: Record "Job Journal Line"; var IsHandled: Boolean; var Sourcecode: Code[10])
    var
        Job: Record job;
        JobTask: Record "Job Task";
        JobTransferLine: Codeunit "Job Transfer Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
    begin

        //ProjectPro - start
        IF (PurchLine.Type = PurchLine.Type::Resource)
        //ProjectPro - end
        then begin
            //PPAL-73.SK.1.0 Start
            Clear(JobJnlLine);
            PurchLine.TestField("Job No.");
            PurchLine.TestField("Job Task No.");
            Job.LockTable();
            JobTask.LockTable();
            // Job.Get(PurchLine."Job No.");//PRJCTPR-140.AT.1.0 20JUNE2023 Commented
            if Job.Get(PurchLine."Job No.") then;//PRJCTPR-140.AT.1.0 20JUNE2023 Add
            PurchLine.TestField("Job Currency Code", Job."Currency Code");

            // JobTask.Get(PurchLine."Job No.", PurchLine."Job Task No.");//PRJCTPR-140.AT.1.0 20JUNE2023 Commented
            if JobTask.Get(PurchLine."Job No.", PurchLine."Job Task No.") then;//PRJCTPR-140.AT.1.0 20JUNE2023 Add

            JobTransferLine.FromPurchaseLineToJnlLine(
              PurchHeader, PurchInvHeader, PurchCrMemoHdr, PurchLine, Sourcecode, JobJnlLine);
            JobJnlLine."Job Posting Only" := true;
            JobJnlPostLine.RunWithCheck(JobJnlLine);
            IsHandled := true;
            //PPAL-73.SK.1.0 End
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, 1001, 'OnBeforeValidateRelationship', '', false, false)]
    local procedure NS_C1001OnPostInvoiceContractLineBeforeCheckJobLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var JobPlanningLine: Record "Job Planning Line")
    begin
        if SalesHeader."Prices Including VAT" then
            if JobPlanningLine."VAT %" <> SalesLine."VAT %" then
                SalesLine."VAT %" := JobPlanningLine."VAT %";
    end;

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, 951, 'OnBeforeSubmit', '', false, false)]
    local procedure NS_C395OnSubmitBeforeCheckTotalQuantity(var TimeSheetLine: Record "Time Sheet Line"; var IsHandled: Boolean)
    var
        Text001: Label 'There is nothing to submit for line with %1=%2, %3=%4.', Comment = 'There is nothing to submit for line with Time Sheet No.=10, Line No.=10000.';
    begin
        //PRJ-1170.NK.1.0 Start
        //with TimeSheetLine do begin            
        if TimeSheetLine.Status = TimeSheetLine.Status::Submitted then
            exit;

        if ((timesheetLine."NS_Crew Time Sheet Ref. No." = '') and (timesheetline."NS_Crew Time Unique Line ID" = '')) then begin  //PRJ-1144.JS.1.0 06Feb2022
            if TimeSheetLine.Type = TimeSheetLine.Type::" " then
                TimeSheetLine.FieldError(Type);
            TimeSheetLine.TestStatus();
            TimeSheetLine.CalcFields("Total Quantity");
            IF Not TimeSheetLine.NS_Correction Then
                if TimeSheetLine."Total Quantity" = 0 then
                    Error(
                  Text001, TimeSheetLine.FieldCaption("Time Sheet No."), TimeSheetLine."Time Sheet No.", TimeSheetLine.FieldCaption("Line No."), TimeSheetLine."Line No.");
            case TimeSheetLine.Type of
                TimeSheetLine.Type::Job:
                    begin
                        TimeSheetLine.TestField("Job No.");
                        TimeSheetLine.TestField("Job Task No.");
                    end;
                TimeSheetLine.Type::Absence:
                    TimeSheetLine.TestField("Cause of Absence Code");
                TimeSheetLine.Type::Service:
                    TimeSheetLine.TestField("Service Order No.");
            end;
        end else begin  //PRJ-1144.JS.1.0 06Feb2022-Start
            TimeSheetLine.Reset();
            TimeSheetLine.setfilter("NS_Crew Time Sheet Ref. No.", '<>%1', '');
            TimeSheetLine.setfilter("NS_Crew Time Unique Line ID", '<>%1', '');
            TimeSheetLine.setfilter(Status, '%1', timesheetline.Status::Open);
            TimeSheetLine.SetFilter("NS_Crew Time Sheet Line No.", '<>%1', 0);  //PRJ-1225.JS.1.0 28FEB2022
            if timesheetLine.findset() then
                TimeSheetLine.CalcFields("Total Quantity");

            IF Not TimeSheetLine.NS_Correction Then
                //if TimeSheetLine."Total Quantity" = 0 then   //PRJ-1225.JS.2.0 line commented
                if ((TimeSheetLine."Total Quantity" = 0) and (TimeSheetLine."NS_Crew Time Sheet Line No." <> 0)) then  //PRJ-1225.JS.2.0 line added
                    Error(
                  Text001, TimeSheetLine.FieldCaption("Time Sheet No."), TimeSheetLine."Time Sheet No.", TimeSheetLine.FieldCaption("Line No."), TimeSheetLine."Line No.");

        end;
        //PRJ-1144.JS.1.0 06Feb2022-end
        TimeSheetLine.UpdateApproverID;
        TimeSheetLine.Status := TimeSheetLine.Status::Submitted;
        TimeSheetLine.Modify(true);
        //end;
        //PRJ-1170.NK.1.0 End
        IsHandled := true;
    end;
    //PPNA16.0 Modified Event End


    [EventSubscriber(ObjectType::Codeunit, 951, 'OnAfterSubmit', '', false, false)]
    local procedure NS_C951OnAfterSubmit(var TimeSheetLine: Record "Time Sheet Line")
    begin
        if not TimeSheetLine.NS_Correction then
            NS_C951PP_ValidateOT(TimeSheetLine."Time Sheet No.")
        else
            if p.NS_C951GetTotalQuantity = 0 then
                TimeSheetLine."Total Quantity" := p.NS_C951GetTotalQuantity;
    end;

    [EventSubscriber(ObjectType::Codeunit, 951, 'OnAfterApprove', '', false, false)]
    local procedure NS_C951OnAfterApprove(var TimeSheetLine: Record "Time Sheet Line")
    var
        NSCrewTimeSheetCustLine: Record NS_TimeSheetLineCustom;   //PRJ-1144.JS.1.0 
    begin
        if not TimeSheetLine.NS_Correction then
            NS_C951PP_ValidateOT(TimeSheetLine."Time Sheet No.");
        //PRJ-1144.JS.1.0  31JAN2022 - start
        if ((TimeSheetLine."NS_Crew Time Unique Line ID" <> '') and (TimeSheetLine."NS_Ref Customize TimesheetNo." <> '')) then begin
            NSCrewTimeSheetCustLine.Reset();
            NSCrewTimeSheetCustLine.SetRange("NS_TimeSheetNo.", TimeSheetLine."NS_Ref Customize TimesheetNo.");
            NSCrewTimeSheetCustLine.SetRange("NS_Unique Line ID", TimeSheetLine."NS_Crew Time Unique Line ID");
            if NSCrewTimeSheetCustLine.findfirst() then begin
                NSCrewTimeSheetCustLine.NS_Status := NSCrewTimeSheetCustLine.NS_Status::Approved;
                NSCrewTimeSheetCustLine.modify();
            end
        end
        //PRJ-1144.JS.1.0  31JAN2022 - end    
    end;

    procedure NS_C951PP_ValidateOT(TimeSheetNo: Code[20])
    var
        NS_HumanResourcesSetup: Record "Human Resources Setup";
        NS_TimeSheetHeader: Record "Time Sheet Header";
        NS_TimeSheetLine: Record "Time Sheet Line";
        NS_TimeSheetDetail: Record "Time Sheet Detail";
        NS_WorkType: Record "Work Type";
        NS_TotalRegularHours: Decimal;
        Text14021100: Label 'You have recorded %1 regular hours in timesheet %2.\To submit Overtime, you must have %3 regular hours recorded.';
        NS_DateLoop: Date;
        NS_CheckOT: Boolean;
        Text14021101: Label 'You have recorded %1 regular hours for %2 in timesheet %3.\To submit Overtime for %2, you must have %4 regular hours recorded on this day.';
    begin
        NS_HumanResourcesSetup.Get;
        if NS_HumanResourcesSetup."NS_Advanced Job Labor isActive" then
            if NS_HumanResourcesSetup."NS_Overtime Calculation Basis" = NS_HumanResourcesSetup."NS_Overtime Calculation Basis"::Week then begin
                if NS_C951PP_OTfound(TimeSheetNo, 0) then begin
                    NS_TotalRegularHours := 0;
                    NS_TimeSheetLine.Reset;
                    NS_TimeSheetLine.SetRange("Time Sheet No.", TimeSheetNo);
                    if NS_TimeSheetLine.FindSet then
                        repeat
                            if NS_TimeSheetLine.Type = NS_TimeSheetLine.Type::Absence then begin
                                NS_TimeSheetLine.CalcFields("Total Quantity");
                                NS_TotalRegularHours += NS_TimeSheetLine."Total Quantity";
                            end else begin
                                //PE-68 Dk.1.0 10April2023 Start
                                // NS_TimeSheetLine.TestField("NS_Skill Class");
                                NS_TimeSheetLine.TestField("NS_Skill Class new");
                                //PE-68 Dk.1.0 10April2023 End
                                NS_WorkType.Get(NS_TimeSheetLine."Work Type Code");
                                if NS_WorkType."NS_Wage Type" = NS_WorkType."NS_Wage Type"::"Regular Time" then begin
                                    NS_TimeSheetLine.CalcFields("Total Quantity");
                                    NS_TotalRegularHours += NS_TimeSheetLine."Total Quantity";
                                end;
                            end;
                        until NS_TimeSheetLine.Next = 0;
                    if NS_TotalRegularHours <> NS_HumanResourcesSetup."NS_Hours worked beforeOTbegins" then
                        Error(Text14021100, NS_TotalRegularHours, TimeSheetNo, NS_HumanResourcesSetup."NS_Hours worked beforeOTbegins");
                end;
            end else begin //Validate Overtime Calculation on Daily basis
                NS_TimeSheetHeader.Get(TimeSheetNo);
                for NS_DateLoop := NS_TimeSheetHeader."Starting Date" to NS_TimeSheetHeader."Ending Date" do begin
                    NS_TotalRegularHours := 0;
                    NS_CheckOT := false;
                    NS_TimeSheetDetail.Reset;
                    NS_TimeSheetDetail.SetRange("Time Sheet No.", TimeSheetNo);
                    NS_TimeSheetDetail.SetRange(Date, NS_DateLoop);
                    if NS_TimeSheetDetail.FindSet then
                        repeat
                            NS_TimeSheetLine.Get(NS_TimeSheetDetail."Time Sheet No.", NS_TimeSheetDetail."Time Sheet Line No.");
                            //PE-68 Dk.1.0 10April2023 Start
                            //NS_TimeSheetLine.TestField("NS_Skill Class");
                            NS_TimeSheetLine.TestField("NS_Skill Class new");
                            //PE-68 Dk.1.0 10April2023 End
                            if NS_C951PP_OTfound(NS_TimeSheetLine."Time Sheet No.", NS_TimeSheetLine."Line No.") then
                                NS_CheckOT := true
                            else
                                NS_TotalRegularHours += NS_TimeSheetDetail.Quantity;
                        until NS_TimeSheetDetail.Next = 0;
                    if NS_CheckOT then
                        if NS_TotalRegularHours <> NS_HumanResourcesSetup."NS_Hours worked beforeOTbegins" then
                            Error(Text14021101, NS_TotalRegularHours, NS_TimeSheetDetail.Date, TimeSheetNo, NS_HumanResourcesSetup."NS_Hours worked beforeOTbegins");
                end;
            end;
    end;

    procedure NS_C951PP_OTfound(PassedTimeSheetNo: Code[20]; PassedTimeSheetLineNo: Integer): Boolean
    var
        NS_TimeSheetLn: Record "Time Sheet Line";
        NS_WorkTyp: Record "Work Type";
    begin
        NS_TimeSheetLn.Reset;
        NS_TimeSheetLn.SetRange("Time Sheet No.", PassedTimeSheetNo);
        if PassedTimeSheetLineNo <> 0 then
            NS_TimeSheetLn.SetRange("Line No.", PassedTimeSheetLineNo);
        if NS_TimeSheetLn.FindSet then
            repeat
                if NS_TimeSheetLn.Type <> NS_TimeSheetLn.Type::Absence then begin
                    NS_WorkTyp.Get(NS_TimeSheetLn."Work Type Code");
                    if NS_WorkTyp."NS_Wage Type" = NS_WorkTyp."NS_Wage Type"::Overtime then begin
                        NS_TimeSheetLn.CalcFields("Total Quantity");
                        if NS_TimeSheetLn."Total Quantity" > 0 then
                            exit(true);
                    end;
                end;
            until NS_TimeSheetLn.Next = 0;
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, 950, 'OnCheckInsertJobPlanningLine', '', false, false)]
    local procedure NS_C950OnCheckInsertJobPlanningLine(JobPlanningLine: Record "Job Planning Line"; var JobPlanningLineBuffer: Record "Job Planning Line"; var SkipLine: Boolean)
    begin
        JobPlanningLineBuffer."NS_Skill Class" := JobPlanningLine."NS_Skill Class";
        JobPlanningLineBuffer."Work Type Code" := JobPlanningLine."Work Type Code";
    end;

    //PPNA16.0 Modified event Start
    [EventSubscriber(ObjectType::Codeunit, 950, 'OnCreateLinesFromJobPlanningOnBeforeTimeSheetLineInsert', '', false, false)]
    local procedure NS_C950OnCreateLinesFromJobPlanningBeforeInsert(var TimeSheetLine: Record "Time Sheet Line"; var JobPlanningLine: Record "Job Planning Line")
    var
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        IF TimeSheetHeader.Get(TimeSheetLine."Time Sheet No.") then;
        TimeSheetLine."NS_Resource No." := TimeSheetHeader."Resource No.";
        if JobPlanningLine."Work Type Code" <> '' then begin
            //PE-68.Dk.1.0 10April2023 Start
            //TimeSheetLine.Validate("NS_Skill Class", JobPlanningLine."NS_Skill Class");
            TimeSheetLine.Validate("NS_Skill Class New", JobPlanningLine."NS_Skill Class New");
            //PE-68.Dk.1.0 10April2023 End
            TimeSheetLine.Validate("Work Type Code", JobPlanningLine."Work Type Code");
        end;
    end;
    //PPNA16.0 Modified event End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnMngPmtDiscToleranceWarningVendorSetRetLedgFilter', '', false, false)]
    // local procedure C426OnMngPmtDiscToleranceWarningVendorSetRetLedgFilter(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; NewVendLedgEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", NewVendLedgEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnMngPmtDiscToleranceWarningCustomerSetRetLedgFilter', '', false, false)]
    // local procedure C426OnMngPmtDiscToleranceWarningCustomerSetRetLedgFilter(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; NewCustLedgEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", NewCustLedgEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelPmtTolApllnDocNoSetRetLedgFilter20', '', false, false)]
    // local procedure C426OnDelPmtTolApllnDocNoSetRetLedgFilter20(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; GenJnlLine: Record "Gen. Journal Line")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     NS_SalesSetup.Get;
    //     if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", GenJnlLine."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelPmtTolApllnDocNoSetRetLedgFilter', '', false, false)]
    // local procedure C426OnDelPmtTolApllnDocNoSetRetLedgFilter(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; GenJnlLine: Record "Gen. Journal Line")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     NS_SalesSetup.Get;
    //     if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", GenJnlLine."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End




    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelTolVendLedgEntrySetRetLedgFilter', '', false, false)]
    // local procedure C426OnDelTolVendLedgEntrySetRetLedgFilter(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         VendorLedgerEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcTolVendLedgEntrySetRetLedgFilter', '', false, false)]
    // local procedure C426OnCalcTolVendLedgEntrySetRetLedgFilter(var VendLedgEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         VendLedgEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelTolCustLedgEntrySetRetLedgFilter', '', false, false)]
    // local procedure C426OnDelTolCustLedgEntrySetRetLedgFilter(var CustLedgEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         CustLedgEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    // end;
    //PPNA16.0 Blocked End

    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcTolCustLedgEntryOnBeforeModify', '', false, false)]
    local procedure NS_C426OnCalcTolCustLedgEntrySetRetLedgFilter(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        OldCustLedgerEntry: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            IF CustLedgerEntry."NS_Retention Ledger Code" <> NS_SalesSetup."NS_Normal Customer Ledger No." then begin
                OldCustLedgerEntry.Get(CustLedgerEntry."Entry No.");
                CustLedgerEntry."Pmt. Disc. Tolerance Date" := OldCustLedgerEntry."Pmt. Disc. Tolerance Date";
                CustLedgerEntry."Max. Payment Tolerance" := OldCustLedgerEntry."Max. Payment Tolerance";
            end;
        end;
    end;
    //PRJ-9.SK.1.0 End


    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure NS_C426OnCalcGracePeriodCVLedgEntrySetRetLedgFilter20(var Rec: Record "Vendor Ledger Entry"; var xRec: Record "Vendor Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        NS_PurchSetup.Get;
        IF not NS_PurchSetup."NS_Purchase Retention Inactive" then
            IF OldVendLedgEntry.Get(Rec."Entry No.") then
                IF OldVendLedgEntry."NS_Retention Ledger Code" <> NS_PurchSetup."NS_Normal Vendor Ledger No." then
                    Rec."Pmt. Disc. Tolerance Date" := OldVendLedgEntry."Pmt. Disc. Tolerance Date";
    end;
    //PRJ-9.SK.1.0 End



    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure NS_C426OnCalcGracePeriodCVLedgEntrySetRetLedgFilter(var Rec: Record "Cust. Ledger Entry"; var xRec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        OldCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        NS_SalesSetup.Get;
        IF not NS_SalesSetup."NS_Sales Retention Inactive" then
            IF OldCustLedgerEntry.Get(Rec."Entry No.") THEN
                IF OldCustLedgerEntry."NS_Retention Ledger Code" <> NS_SalesSetup."NS_Normal Customer Ledger No." then
                    Rec."Pmt. Disc. Tolerance Date" := OldCustLedgerEntry."Pmt. Disc. Tolerance Date";
    end;
    //PRJ-9.SK.1.0 End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelVendPmtTolAccSetRetLedgFilter20', '', false, false)]
    // local procedure C426OnDelVendPmtTolAccSetRetLedgFilter20(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelVendPmtTolAccSetRetLedgFilter', '', false, false)]
    // local procedure C426OnDelVendPmtTolAccSetRetLedgFilter(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelCustPmtTolAccSetRetLedgFilter20', '', false, false)]
    // local procedure C426OnDelCustPmtTolAccSetRetLedgFilter20(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnDelCustPmtTolAccSetRetLedgFilter', '', false, false)]
    // local procedure C426OnDelCustPmtTolAccSetRetLedgFilter(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnPutVendPmtTolAmountSetRetLedgFilter', '', false, false)]
    // local procedure C426OnPutVendPmtTolAmountSetRetLedgFilter(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnPutCustPmtTolAmountSetRetLedgFilter', '', false, false)]
    // local procedure C426OnPutCustPmtTolAmountSetRetLedgFilter(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcVendApplnAmountSetRetLedgFilter20', '', false, false)]
    // local procedure C426OnCalcVendApplnAmountSetRetLedgFilter20(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcVendApplnAmountSetRetLedgFilter10', '', false, false)]
    // local procedure C426OnCalcVendApplnAmountSetRetLedgFilter10(var AppliedVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_PurchSetup.Get;
    //     if not NS_PurchSetup."NS_Purchase Retention Inactive" then
    //         AppliedVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcCustApplnAmountSetRetLedgFilter20', '', false, false)]
    // local procedure C426OnCalcCustApplnAmountSetRetLedgFilter20(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnCalcCustApplnAmountSetRetLedgFilter10', '', false, false)]
    // local procedure C426OnCalcCustApplnAmountSetRetLedgFilter10(var AppliedCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     if not NS_SalesSetup."NS_Sales Retention Inactive" then
    //         AppliedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    // end;
    //PPNA16.0 Blocked End



    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnDistTaxOverSalesLines30
    //PRJ-148.SK.1.0 Start  
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverSalesLinesOnSalesLineLoopOnAfterSetSalesLineVATBaseAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverSalesLines30(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    //     Currency: Record Currency;
    //SalesTaxCalculate: Codeunit "Sales Tax Calculate"; //PRJCTPR-320.NC.1.0 13Feb2024
    //  NS_JobsSetup: Record "Jobs Setup"; //PRJCTPR-320.NC.1.0 13Feb2024
    // begin
    //     NS_TaxBaseAmount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
    //     NS_C398PP_AdjustTaxBaseAmount(NS_TaxBaseAmount, SalesHeader);
    //     if SalesHeader."Currency Code" = '' then
    //         Currency.InitRoundingPrecision
    //     else
    //         Currency.Get(SalesHeader."Currency Code");
    //     SalesLine."VAT Base Amount" := Round(NS_TaxBaseAmount, Currency."Amount Rounding Precision");
    //PRJCTPR-320.NC.1.0 13Feb2024 Start
    //if NS_JobsSetup.Get() then;
    //if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
    //  if SalesHeader."NS_Multiple Retention on Lines" then begin
    //    SalesLine."VAT Base Amount" := Round(NS_TaxBaseAmount - SalesLine."NS_Retention Amount", Currency."Amount Rounding Precision");
    //  SalesLine."Amount Including VAT" :=
    //                  NS_TaxBaseAmount - SalesLine."NS_Retention Amount" +
    //                SalesTaxCalculate.CalculateTax(
    //                SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
    //              SalesLine."VAT Base Amount", SalesLine."Quantity (Base)", SalesHeader."Currency Factor");
    //end;
    //end;
    //PRJCTPR-320.NC.1.0 13Feb2024 End
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnDistTaxOverSalesLines20 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverSalesLinesOnTempSalesTaxLineLoopOnAfterSetSalesLineVATBaseAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverSalesLines20(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    //Currency: Record Currency; //PRJCTPR-320.NC.1.0 13Feb2024
    //  SalesTaxCalculate: Codeunit "Sales Tax Calculate"; //PRJCTPR-320.NC.1.0 13Feb2024
    //NS_JobsSetup: Record "Jobs Setup"; //PRJCTPR-320.NC.1.0 13Feb2024
    // begin
    //     NS_TaxBaseAmount := SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
    //     NS_C398PP_AdjustTaxBaseAmount(NS_TaxBaseAmount, SalesHeader);
    //     SalesLine."VAT Base Amount" := NS_TaxBaseAmount;
    //PRJCTPR-320.NC.1.0 13Feb2024 Start
    // if NS_JobsSetup.Get() then;
    //if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
    //  if SalesHeader."NS_Multiple Retention on Lines" then begin
    //    if SalesHeader."Currency Code" = '' then
    //      Currency.InitRoundingPrecision
    // else
    //   Currency.Get(SalesHeader."Currency Code");
    //SalesLine."VAT Base Amount" := Round(NS_TaxBaseAmount - SalesLine."NS_Retention Amount", Currency."Amount Rounding Precision");
    //SalesLine."Amount Including VAT" :=
    //                NS_TaxBaseAmount - SalesLine."NS_Retention Amount" +
    //              SalesTaxCalculate.CalculateTax(
    //              SalesLine."Tax Area Code", SalesLine."Tax Group Code", SalesLine."Tax Liable", SalesHeader."Posting Date",
    //            SalesLine."VAT Base Amount", SalesLine."Quantity (Base)", SalesHeader."Currency Factor");
    //  end;
    //end;
    //PRJCTPR-320.NC.1.0 13Feb2024 End
    // end;
    // //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnDistTaxOverSalesLines10 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverSalesLinesOnTempSalesTaxLineLoopOnAfterSetTempSalesTaxLineAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverSalesLines10(var Amount: Decimal; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    // begin
    //     NS_TaxBaseAmount := (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount");
    //     NS_C398PP_AdjustTaxBaseAmount(NS_TaxBaseAmount, SalesHeader);
    //     Amount := NS_TaxBaseAmount;
    // end;
    // //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PRJ-196 VT 08-04-20 begin



    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnUpdateVATPercOverPurchLines 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnAfterUpdatePurchaseLineVatPct', '', false, false)]
    // local procedure NS_C398UpdateVATPercOverPurchLines(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    // var

    // begin
    //     if PurchLine."VAT Base Amount" <> 0 then
    //         PurchLine."VAT %" := ROUND(100 * (PurchLine."Amount Including VAT" - PurchLine.Amount) / PurchLine."VAT Base Amount", 0.00001);
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End



    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnDistTaxOverPurchLines30 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverPurchLinesOnPurchLineLoopOnAfterSetPurchLineVATBaseAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverPuchLines30(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    //     Currency: Record Currency;
    // begin
    //     NS_TaxBaseAmount := PurchLine."Line Amount" - PurchLine."Inv. Discount Amount";
    //     NS_C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchHeader);
    //     if PurchHeader."Currency Code" = '' then
    //         Currency.InitRoundingPrecision
    //     else
    //         Currency.Get(PurchHeader."Currency Code");
    //     PurchLine."VAT Base Amount" := Round(NS_TaxBaseAmount, Currency."Amount Rounding Precision");
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End



    //PPDA.1.0 STart
    // //PPNA17.0 Opened Start OnDistTaxOverPurchLines20 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverPurchLinesOnTempSalesTaxLineLoopOnAfterSetPurchLineVATBaseAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverPurchLines20(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header");
    // var
    //     NS_TaxBaseAmount: Decimal;
    // begin
    //     NS_TaxBaseAmount := PurchLine."Line Amount" - PurchLine."Inv. Discount Amount";
    //     NS_C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchHeader);
    //     PurchLine."VAT Base Amount" := NS_TaxBaseAmount;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnDistTaxOverPurchLines10 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnDistTaxOverPurchLinesOnTempSalesTaxLineLoopOnAfterSetTempSalesTaxLineAmount', '', false, false)]
    // local procedure NS_C398OnDistTaxOverPurchLines10(var Amount: Decimal; PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    // begin
    //     NS_TaxBaseAmount := (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount");
    //     NS_C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchHeader);
    //     Amount := NS_TaxBaseAmount;
    // end;
    //PPNA17.0 Opened End
    //PRJ-196 VT 08-04-20 end;
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnEndSalesTaxCalculationBefireInsert 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnEndSalesTaxCalculationOnBeforeSalesTaxAmountLine2Insert', '', false, false)]
    // local procedure NS_C398OnEndSalesTaxCalculationBefireInsert(var SalesTaxAmountLine2: Record "Sales Tax Amount Line"; var TempSalesTaxLine: Record "Sales Tax Amount Line")
    // begin
    //     with TempSalesTaxLine do begin
    //         "Amount Including Tax" := "Tax Amount" + "Line Amount"; //PRJ-148.SK.1.0 Blocked
    //         //"Amount Including Tax" := "Tax Amount" + "Tax Base Amount"; //PRJ-148.SK.1.0 Added
    //         SalesTaxAmountLine2."Amount Including Tax" := "Amount Including Tax";
    //         if "Tax Type" <> "Tax Type"::"Excise Tax" then
    //             if "Tax Base Amount" <> 0 then
    //                 SalesTaxAmountLine2."Tax %" := 100 * ("Amount Including Tax" - "Line Amount") / "Tax Base Amount"
    //     end;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End

    //PPDA.1.0 Start
    //PPNA17.0 Opened Start OnAddPurchLineBeforeNext 
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnAfterAddPurchLine', '', false, false)]
    // local procedure NS_C398OnAddPurchLineBeforeNext(var TempSalesTaxLine: Record "Sales Tax Amount Line"; PurchLine: Record "Purchase Line"; ExchangeFactor: Decimal; PurchHeader: Record "Purchase Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    // begin
    //     //PRJ-196 VT 06-04-20 begin Commented
    //     // with TempSalesTaxLine do begin
    //     //     NS_TaxBaseAmount := PurchaseLine."Line Amount" / ExchangeFactor;
    //     //     C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchaseHeader);
    //     //     "Tax Base Amount FCY" := NS_TaxBaseAmount;
    //     //     "Tax Base Amount" := "Tax Base Amount FCY" / ExchangeFactor;
    //     //     Modify;
    //     //PRJ-196 VT 06-04-20 End Commented

    //     //PRJ-196 VT 06-04-20 begin
    //     with TempSalesTaxLine do begin
    //         TempSalesTaxLine.Reset();
    //         IF TempSalesTaxLine.FindSet() then
    //             repeat
    //                 NS_TaxBaseAmount := TempSalesTaxLine."Line Amount"; /// ExchangeFactor;
    //                 NS_C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchHeader);
    //                 "Tax Base Amount FCY" := NS_TaxBaseAmount;
    //                 TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY" / ExchangeFactor;  //PRJCTPR-183.JS.1.0 01Sep2023 line commented
    //                 TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY";  //PRJCTPR-183.JS.1.0 01Sep2023 line added 
    //                 Modify;
    //             until TempSalesTaxLine.Next() = 0;
    //     end;
    //     //PRJ-196 VT 06-04-20 End
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnAddPurchLineInvBeforeNext 
    // //PRJ-196 VT 07-04-20 Begin
    // [EventSubscriber(ObjectType::Codeunit, 398, 'OnAddPurchInvoiceLinesOnAfterCalcPurchLineSalesTaxAmountLine', '', false, false)]
    // local procedure NS_C398OnAddPurchInvLineBeforeNext(var TempSalesTaxLine: Record "Sales Tax Amount Line"; PurchInvLine: Record "Purch. Inv. Line"; ExchangeFactor: Decimal; PurchInvHeader: Record "Purch. Inv. Header")
    // var
    //     NS_TaxBaseAmount: Decimal;
    //     NS_GLSetup: Record "General Ledger Setup";
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     with TempSalesTaxLine do begin
    //         TempSalesTaxLine.Reset();
    //         IF TempSalesTaxLine.FindSet() then
    //             repeat
    //                 NS_TaxBaseAmount := TempSalesTaxLine."Line Amount"; /// ExchangeFactor;

    //                 if PurchInvHeader."NS_Retention Percent" = 0 then
    //                     exit;
    //                 NS_GLSetup.Get;
    //                 if NS_JobsSetup.Get then
    //                     if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount" then
    //                         NS_TaxBaseAmount := NS_TaxBaseAmount - Round(NS_TaxBaseAmount * (PurchInvHeader."NS_Retention Percent" / 100),
    //                                                                      NS_GLSetup."Amount Rounding Precision");
    //                 // C398PP_AdjustPurchTaxBaseAmount(NS_TaxBaseAmount, PurchaseHeader);
    //                 "Tax Base Amount FCY" := NS_TaxBaseAmount;
    //                 TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY" / ExchangeFactor;  //PRJCTPR-183.JS.1.0 01Sep2023 line commented
    //                 TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY";  //PRJCTPR-183.JS.1.0 01Sep2023 line added
    //                 Modify;
    //             until TempSalesTaxLine.Next() = 0;
    //     end;
    // end;
    // //PRJ-196 VT 07-04-20 end 
    // //PPNA17.0 Opened End
    //PPDA.1.0 End



    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnAddSalesLineAfterNext 
    // //PRJ-148.SK.1.0 Start
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Tax Calculate", 'OnAfterAddSalesLine', '', False, false)]
    // local procedure NS_C398OnAddSalesLineAfterNext(ExchangeFactor: Decimal; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TempSalesTaxLine: Record "Sales Tax Amount Line")
    // var
    //     NS_TaxBaseAmount: Decimal;
    // begin
    //     TempSalesTaxLine.Reset();
    //     IF TempSalesTaxLine.FindSet() then
    //         repeat
    //             NS_TaxBaseAmount := TempSalesTaxLine."Line Amount"; //PRJ-671.N.S.1.0 comment  //PRJ-939.JS.1.0 Line open
    //            //NS_TaxBaseAmount := TempSalesTaxLine."Tax Base Amount"; //PRJ-671.N.S.1.0  //PRJ-939.JS.1.0 Line commented
    //             NS_C398PP_AdjustTaxBaseAmount(NS_TaxBaseAmount, SalesHeader);
    //NS_MultipleRetentiontTaxBaseAmt(NS_TaxBaseAmount, SalesHeader, SalesLine, TempSalesTaxLine); //PRJCTPR-320.NC.1.0 14Feb2024
    //             TempSalesTaxLine."Tax Base Amount FCY" := NS_TaxBaseAmount;
    //             //TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY" / ExchangeFactor;//PRJ-671.N.S.1.0 comment
    //             TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY" / ExchangeFactor;//PRJ-671.N.S.1.0  //PRJCTPR-183.JS.1.0 01Sep2023 line commented
    //             TempSalesTaxLine."Tax Base Amount" := TempSalesTaxLine."Tax Base Amount FCY";  //PRJCTPR-183.JS.1.0 01Sep2023 line added
    //             TempSalesTaxLine.Modify();
    //         until TempSalesTaxLine.Next() = 0;
    // end;
    // //PRJ-148.SK.1.0 End
    // //PPNA17.0 Opened End
    //PPDA.1.0 End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnAfterPurchPmtTolGenJnl', '', false, false)]
    // local procedure C426OnAfterPurchPmtTolGenJnl(var NewVendLedgEntry: Record "Vendor Ledger Entry"; GenJnlLine: Record "Gen. Journal Line")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     NS_PurchSetup.Get;
    //     if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then begin
    //         NewVendLedgEntry."NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
    //         NewVendLedgEntry."Dimension Set ID" := GenJnlLine."Dimension Set ID";
    //     end;
    // end;
    //PPNA16.0 Blocked End




    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Codeunit, 426, 'OnAfterSalesPmtTolGenJnl', '', false, false)]
    // local procedure C426OnAfterSalesPmtTolGenJnl(var NewCustLedgEntry: Record "Cust. Ledger Entry"; GenJnlLine: Record "Gen. Journal Line")
    // var
    //     NS_SalesSetup: Record "Sales & Receivables Setup";
    //     NS_PurchSetup: Record "Purchases & Payables Setup";
    // begin
    //     NS_SalesSetup.Get;
    //     NS_PurchSetup.Get;
    //     if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then begin
    //         NewCustLedgEntry."NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
    //         NewCustLedgEntry."Dimension Set ID" := GenJnlLine."Dimension Set ID";
    //     end;
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, 408, 'OnAfterDefaultDimObjectNoWithoutGlobalDimsList', '', false, false)]
    local procedure NS_C408OnAfterDefaultDimObjectNoWithoutGlobalDimsList(var TempAllObjWithCaption: Record AllObjWithCaption)
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.InsertObject(TempAllObjWithCaption, DATABASE::"NS_Subcontract Lines");
        DimensionManagement.InsertObject(TempAllObjWithCaption, DATABASE::"NS_Job Quote Header");//PRJ-409
    end;
    //PPNA16.0 Modified Event End



    //PPNA17.0 Opened Start OnRunSetInsuranceExpiredFilter
    [EventSubscriber(ObjectType::Codeunit, 407, 'OnRunOnBeforeGenJnlLineFind', '', false, false)]
    local procedure NS_C407OnRunSetInsuranceExpiredFilter(var GenJnlLine: Record "Gen. Journal Line")
    var
        NS_Vendor: Record Vendor;
    begin
        with GenJnlLine do begin
            if FindSet then begin
                repeat
                    if NS_Vendor.InsuranceExpired("Account No.", "Posting Date") then
                        Mark(true);
                until Next = 0;
                MarkedOnly(true);
            end;
        end;
    end;
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnRunSetRetentionLedgFilter10
    [EventSubscriber(ObjectType::Codeunit, 402, 'OnRunOnAfterFilterVendLedgEntry', '', false, false)]
    local procedure NS_C402OnRunSetRetentionLedgFilter10(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            VendorLedgerEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnRunSetRetentionLedgFilter11
    [EventSubscriber(ObjectType::Codeunit, 402, 'OnRunOnBeforeVendLedgEntryFindFirst', '', false, false)]
    local procedure NS_C402OnRunSetRetentionLedgFilter11(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            VendorLedgerEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnRunSetRetentionLedgFilter11
    [EventSubscriber(ObjectType::Codeunit, 401, 'OnRunOnAfterFilterCustLedgEntry', '', false, false)]
    local procedure NS_C401OnRunSetRetentionLedgFilter11(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgerEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnRunSetRetentionLedgFilter10
    [EventSubscriber(ObjectType::Codeunit, 401, 'OnRunOnBeforeCustLedgEntryFindFirst', '', false, false)]
    local procedure NS_C401OnRunSetRetentionLedgFilter10(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgerEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;
    //PPNA17.0 Opened End


    //PPDA.1.0 Start
    // local procedure NS_C398PP_AdjustTaxBaseAmount(var NS_TaxBaseAmount: Decimal; SalesHeader: Record "Sales Header")
    // var
    //     NS_GLSetup: Record "General Ledger Setup";
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     if SalesHeader."NS_Retention Percent" = 0 then
    //         exit;
    //     NS_GLSetup.Get;
    //     if NS_JobsSetup.Get then
    //         if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then
    //             NS_TaxBaseAmount := NS_TaxBaseAmount - Round(NS_TaxBaseAmount * (SalesHeader."NS_Retention Percent" / 100),
    //                                                          NS_GLSetup."Amount Rounding Precision");
    // end;
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // local procedure NS_C398PP_AdjustPurchTaxBaseAmount(var NS_TaxBaseAmount: Decimal; PurchHeader: Record "Purchase Header")
    // var
    //     NS_GLSetup: Record "General Ledger Setup";
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     if PurchHeader."NS_Retention Percent" = 0 then
    //         exit;
    //     NS_GLSetup.Get;
    //     if NS_JobsSetup.Get then
    //         if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount" then
    //             NS_TaxBaseAmount := NS_TaxBaseAmount - Round(NS_TaxBaseAmount * (PurchHeader."NS_Retention Percent" / 100),
    //                                                          NS_GLSetup."Amount Rounding Precision");
    // end;
    //PPDA.1.0 End




    //PPNA17.0 Opened Start OnUpdateCustLedgEntriesCalcInterestBeforeModify
    [EventSubscriber(ObjectType::Codeunit, 395, 'OnUpdateCustLedgEntriesCalculateInterestOnBeforeCustLedgerEntry2ModifyAll', '', false, false)]
    local procedure NS_C395OnUpdateCustLedgEntriesCalcInterestBeforeModify(var CustLedgEntry2: Record "Cust. Ledger Entry"; CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgEntry2.SetRange("NS_Retention Ledger Code", CustLedgEntry."NS_Retention Ledger Code");
    end;
    //PPNA17.0 Opened End



    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 395, 'OnAfterTestDeleteHeader', '', false, false)]
    local procedure NS_C395OnDeleteHeaderBeforeInsert(var IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        IssuedFinChargeMemoHeader."NS_Retention Ledger Code" := '';
    end;
    //PRJ-9.SK.1.0 End


    [EventSubscriber(ObjectType::Codeunit, 395, 'OnAfterInitGenJnlLine', '', false, false)]
    local procedure NS_C395OnAfterInitGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; FinChargeMemoHeader: Record "Finance Charge Memo Header")
    begin
        GenJnlLine."NS_Retention Ledger Code" := FinChargeMemoHeader."NS_Retention Ledger Code";
    end;



    //PPNA17.0 Opened Start OnSetEnd
    [EventSubscriber(ObjectType::Codeunit, 394, 'OnAfterSet', '', false, false)]
    local procedure NS_C394OnSetEnd(var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;
    //PPNA17.0 Opened End


    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, 393, 'OnAfterTestDeleteHeader', '', false, false)]
    local procedure NS_C393OnDeleteHeaderBeforeHeaderInsert(var IssuedReminderHeader: Record "Issued Reminder Header")
    begin
        IssuedReminderHeader."NS_Retention Ledger Code" := '';
    end;
    //PRJ-9.SK.1.0 End



    //PPNA17.0 Opened Start OnUpdateCustLedgEntriesCalculateInterestBeforeModify
    [EventSubscriber(ObjectType::Codeunit, 393, 'OnUpdateCustLedgEntriesCalculateInterestOnBeforeCustLedgerEntry2ModifyAll', '', false, false)]
    local procedure NS_C393OnUpdateCustLedgEntriesCalculateInterestBeforeModify(var CustLedgEntry2: Record "Cust. Ledger Entry"; CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //SPLN: Code moved before MODIFYALL
        NS_SalesSetup.Get;
        NS_PurchSetup.Get;
        if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
            CustLedgEntry2.SetRange("NS_Retention Ledger Code", CustLedgEntry."NS_Retention Ledger Code");
    end;
    //PPNA17.0 Opened End



    [EventSubscriber(ObjectType::Codeunit, 392, 'OnAfterFilterCustLedgEntryReminderLevel', '', false, false)]
    local procedure NS_C392OnAfterFilterCustLedgEntryReminderLevel(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgerEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;

    //PRJ-9.SK.1.0 Start

    [EventSubscriber(ObjectType::Codeunit, 392, 'OnBeforeCustLedgerEntryFind', '', false, false)]
    local procedure NS_C392OnCodeCustLedgEntrySetFilter(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgerEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;

    //PRJ-9.SK.1.0 End


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, 378, 'OnPurchCheckIfAnyExtTextOnBeforeSetFilters', '', false, false)]
    local procedure NS_C378OnPurchCheckIfAnyExtTextAfterCASE(var AutoText: Boolean; var PurchaseLine: Record "Purchase Line")
    Var
        Resource: Record Resource;
    begin
        if not AutoText then
            case PurchaseLine.Type of
                PurchaseLine.Type::NS_Ledger:
                    if Resource.Get(PurchaseLine."No.") then
                        AutoText := Resource."Automatic Ext. Texts";
            end;
    end;
    //PPNA16.0 Modified Event End

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnPostRoundingAmountOnBeforeGenJnlPostLine', '', false, false)]
    local procedure NS_OnPostRoundingAmountOnBeforeGenJnlPostLine(CheckLedgerEntry: Record "Check Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry.GET(CheckLedgerEntry."Bank Account Ledger Entry No.");
        GenJournalLine."NS_Retention Ledger Code" := BankAccLedgEntry."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnUnApplyVendInvoicesOnBeforePost', '', false, false)]
    local procedure NS_C367OnUnApplyVendInvoicesOnBeforePost(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_SalesSetup.Get;
        NS_PurchSetup.Get;
        if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
            VendorLedgerEntry.SetRange("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostBalAccLine', '', false, false)]
    local procedure NS_C367OnFinancialVoidCheckOnBeforePostBalAccLine(CheckLedgerEntry: Record "Check Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry.GET(CheckLedgerEntry."Bank Account Ledger Entry No.");
        GenJournalLine."NS_Retention Ledger Code" := BankAccLedgEntry."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostVend', '', false, false)]
    local procedure NS_C367OnFinancialVoidCheckOnBeforePostVend(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := VendorLedgerEntry."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostCust', '', false, false)]
    local procedure NS_C367OnFinancialVoidCheckOnBeforePostCust(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := CustLedgerEntry."NS_Retention Ledger Code";
    end;

    //PRJ-9.TY.1.0 Start
    //[EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckPostGLEntry', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostBalAccLine', '', false, false)]
    local procedure NS_C367OnFinancialVoidCheckPostGLEntry(VAR GenJournalLine: Record "Gen. Journal Line"; CheckLedgerEntry: Record "Check Ledger Entry")
    var
        GLEntry: Record "G/L Entry";
        BankAccLedgEntry2: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry2.GET(CheckLedgerEntry."Bank Account Ledger Entry No.");
        With GLEntry Do BEGIN
            SETCURRENTKEY("Transaction No.");
            SETRANGE("Transaction No.", BankAccLedgEntry2."Transaction No.");
            SETRANGE("Document No.", BankAccLedgEntry2."Document No.");
            SETRANGE("Posting Date", BankAccLedgEntry2."Posting Date");
            SETFILTER("Entry No.", '<>%1', BankAccLedgEntry2."Entry No.");
            SETRANGE("G/L Account No.", CheckLedgerEntry."Bal. Account No.");
            IF FindFirst() THEN;
        END;
        GenJournalLine."NS_Retention Ledger Code" := GLEntry."NS_Retention Ledger Code";
    end;
    //PRJ-9.TY.1.0 End


    //[EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckPostCheckLedger', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 367, 'OnFinancialVoidCheckOnBeforePostVoidCheckLine', '', false, false)]
    local procedure NS_OnFinancialVoidCheckOnBeforePostVoidCheckLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        CheckLedgerEntry.Reset();
        CheckLedgerEntry.SetRange("Document No.", GenJournalLine."Document No.");
        CheckLedgerEntry.SetFilter("Bank Account Ledger Entry No.", '<>%1', 0);   //PRJ.907.JS.1.0  07Sep2021
        IF CheckLedgerEntry.FindFirst() THEN;
        BankAccLedgEntry.GET(CheckLedgerEntry."Bank Account Ledger Entry No.");
        GenJournalLine."NS_Retention Ledger Code" := BankAccLedgEntry."NS_Retention Ledger Code";
    end;


    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Codeunit, 10140, 'OnBeforePostedDepositLineInsert', '', false, false)]
    // local procedure NS_C10140OnBeforePostedDepositLineInsert(var PostedDepositLine: Record "Posted Deposit Line"; GenJnlLine: Record "Gen. Journal Line")
    // begin
    //     with PostedDepositLine do begin
    //         "NS_Job No." := GenJnlLine."Job No.";
    //         "NS_Job Task No." := GenJnlLine."Job Task No.";
    //         "NS_Retention Ledger Code" := GenJnlLine."NS_Retention Ledger Code";
    //     end;
    // end;
    //PPDA.1.0 End

    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnBeforeInsertSalesLine', '', false, false)]
    local procedure NS_C1002OnBeforeInsertSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    var//PRJ-253 AS1.0 30-04-20
        Job_L: Record Job;//PRJ-253 AS1.0 30-04-20
    begin
        SalesLine."NS_Job Cost Category" := JobPlanningLine."NS_Cost Category";
        SalesLine."NS_Job Revenue Category" := JobPlanningLine."NS_Revenue Category";
        SalesLine."NS_DFR No." := JobPlanningLine."NS_DFR No.";//JD-10.MS.1.0
        if JobPlanningLine."Gen. Prod. Posting Group" <> '' then
            SalesLine."Gen. Prod. Posting Group" := JobPlanningLine."Gen. Prod. Posting Group";
        // SalesLine."Gen. Bus. Posting Group" := Job_L."NS_Gen. Bus. Posting Group";//PRJ-420.MS.1.0   //PRJ-831.AS.1.0 12OCT2021 Comment old 
        //SalesLine."Gen. Bus. Posting Group" := Job_L."NS_Gen. Bus. Posting Group New";//PRJ-420.MS.1.0   //PRJ-831.AS.1.0 12OCT2021 Add New //PRJ-1002.GK.1.0 21Oct2021 |Comment
        //PRJ-253 AS1.0 30-04-20 - start
        //if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then begin//PRJ-312.MS.1.0
        if Job_L.Get(JobPlanningLine."Job No.") then begin
            SalesLine.Validate("Tax Liable", Job_L."NS_Tax Liable");//PRJ-312.MS.1.0
            SalesLine."Tax Area Code" := Job_L."NS_Tax Area Code";
            SalesLine."Gen. Bus. Posting Group" := Job_L."NS_Gen. Bus. Posting Group New";//PRJ-420.MS.1.0   //PRJ-831.AS.1.0 12OCT2021 Add New //PRJ-1002.GK.1.0 21Oct2021| Add new line
        end;
        //end;
        //PRJ-253 AS1.0 30-04-20 - end
    end;

    procedure NS_C1002NS_GetSalesInvoice(JobPlanningLine: Record "Job Planning Line")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Text001: Label 'The lines were not transferred to an invoice.';
    begin
        ClearAll;
        with JobPlanningLine do begin
            if "Line No." = 0 then
                exit;
            TestField("Job No.");
            TestField("Job Task No.");
            CalcFields("Qty. Invoiced");
            if "Qty. Invoiced" = 0 then begin
                SalesLine.SetCurrentKey("Job Contract Entry No.");
                SalesLine.SetRange("Job Contract Entry No.", "Job Contract Entry No.");
                if SalesLine.FindFirst then begin
                    if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then;
                    if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                        PAGE.RunModal(PAGE::"Sales Invoice", SalesHeader)
                    else
                        PAGE.RunModal(PAGE::"Sales Credit Memo", SalesHeader);
                end else
                    Error(Text001);
            end;
            if "Qty. Invoiced" <> 0 then begin
                SalesCrMemoLine.SetCurrentKey("Job Contract Entry No.");
                SalesCrMemoLine.SetRange("Job Contract Entry No.", "Job Contract Entry No.");
                if SalesCrMemoLine.FindFirst then begin
                    ;
                    if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then;
                    PAGE.RunModal(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
                end else begin
                    SalesInvLine.SetCurrentKey("Job Contract Entry No.");
                    SalesInvLine.SetRange("Job Contract Entry No.", "Job Contract Entry No.");
                    SalesInvLine.FindFirst;
                    if SalesInvHeader.Get(SalesInvLine."Document No.") then;
                    PAGE.RunModal(PAGE::"Posted Sales Invoice", SalesInvHeader);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnAfterReleaseATOs', '', false, false)]
    local procedure NS_C414OnAfterReleaseATOs(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesHeader do begin
            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then begin
                if "NS_Retention Percent" <> 0 then
                    Validate("NS_Retention Percent")
                else
                    Validate("NS_Retention Amount (LCY)");
                Validate("NS_Retention Date");
            end;
        end;
    end;

    //PRJ-844.JS.1.0-09Aug2021-Start
    // [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReopenSalesDoc', '', false, false)]   //PRJ-844.JS.1.0-09Aug2021 commented
    // local procedure NS_C414OnBeforeReopenSalesDoc(var SalesHeader: Record "Sales Header")      //PRJ-844.JS.1.0-09Aug2021 commented  
    [EventSubscriber(ObjectType::Codeunit, 414, 'OnReopenOnBeforeSalesHeaderModify', '', false, false)]
    local procedure NS_C414OnReopenOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesHeader do begin
            // if Status = Status::Open then   //PRJ-844.JS.1.0-09Aug2021 commented
            //     exit;                       //PRJ-844.JS.1.0-09Aug2021 commented 
            Status := Status::Open;

            SalesSetup.Get;
            if not SalesSetup."NS_Sales Retention Inactive" then begin
                if "NS_Retention Percent" <> 0 then
                    Validate("NS_Retention Percent")
                else
                    Validate("NS_Retention Amount (LCY)");
                Validate("NS_Retention Date");
            end;
        end;
    end;
    //PRJ-844.JS.1.0-09Aug2021-End

    [EventSubscriber(ObjectType::Codeunit, 366, 'OnAfterOnRun', '', false, false)]
    local procedure NS_C366OnAfterOnRun(var GenJournalLine: Record "Gen. Journal Line"; GenJournalLine2: Record "Gen. Journal Line")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin

        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Bank Account" THEN//PRJ-141.SK.1.0 Added
            with GenJournalLine do begin
                NS_SalesSetup.Get;
                NS_PurchSetup.Get;
                if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then begin
                    "NS_Bal. Ledger No." := "NS_Retention Ledger Code"; //PRJ-189.MS.1.0 Added
                    Validate("NS_Retention Ledger Code", "NS_Bal. Ledger No.");
                    //"Bal. Ledger No." := "Retention Ledger Code"; //PRJ-189.MS.1.0 Commented
                end;
            end
        else
            //PRJ-141.SK.1.0 Start
            with GenJournalLine2 do begin
                NS_SalesSetup.Get;
                NS_PurchSetup.Get;
                if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then begin
                    "NS_Bal. Ledger No." := "NS_Retention Ledger Code";  //PRJ-189.MS.1.0 Added
                    Validate("NS_Retention Ledger Code", "NS_Bal. Ledger No.");
                    //"Bal. Ledger No." := "Retention Ledger Code"; //PRJ-189.MS.1.0 Commented
                end;
            end;
        //PRJ-141.SK.1.0 End

    end;

    [EventSubscriber(ObjectType::Codeunit, 333, 'OnBeforePurchOrderLineInsert', '', false, false)]
    local procedure NS_C333OnBeforePurchOrderLineInsert(var PurchOrderLine: Record "Purchase Line"; var ReqLine: Record "Requisition Line")
    var
        JobSU: Record "Jobs Setup";
        Job: Record Job;
        JPL: Record "Job Planning Line";
        NS_JPL2: Record "Job Planning Line"; //PRJ-929.GK.4.0 20Dec2021
        NS_Jobs: Record Job;   //PRJ-1117.JS.1.0 07Dec2022
        NS_BillingHeader: Record "NS_Progress Billing Header";  //PRJ-1117.JS.1.0 07Dec2022
        NS_DefaultDim: Record "Default Dimension";   //PRJ-1117.JS.1.0 07Dec2022
        NS_Item: record Item;  //PRJ-1148.JS.1.0 20JAN2022
        NS_JobMatPlan: Record "NS_Job Material Planning";  //PRJ-1148.JS.1.0 20JAN2022
        JobTask1: Record "Job Task"; //PRJ-1148.JS.1.0 20JAN2022
    begin
        JobSU.Get;
        with ReqLine do begin
            if (JobSU."NS_Use Job Mat'l Plan Active") and ("NS_Job No." <> '')
                and (JobSU."NS_Job Mat'l Planning Location" <> '') then
                PurchOrderLine.Validate("Location Code", JobSU."NS_Job Mat'l Planning Location");

            //PurchOrderLine.validate("No.", ReqLine."No.");   //PRJ-1148.JS.1.0 21Jan2022
            if "NS_Job No." <> '' then
                if Job.Get("NS_Job No.") then begin
                    PurchOrderLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                    PurchOrderLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                    PurchOrderLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                end;
            //Job No.,Job Task No.,Line No.
            if JPL.Get("NS_Job No.", "NS_Job Task No.", "NS_Job Planning Line No.") and JPL."Usage Link" then
                PurchOrderLine."Job Planning Line No." := "NS_Job Planning Line No.";
            //PRJ-999.JS.1.1  24Nov2021-Start
            //PRJ-1117.JS.1.0 07Dec2022 - Start
            PurchOrderLine."Job No." := "NS_Job No.";//PRJ-1099.AS.1.0 05JAN2021 Line uncommented //PRJ-1115.AS.1.0
            PurchOrderLine."Job Task No." := "NS_Job Task No.";//PRJ-1099.AS.1.0 05JAN2021 Line uncommented //PRJ-1115.AS.1.0
            //PurchOrderLine.Validate("Job No.", "NS_Job No.");//PRJ-1099.AS.1.0 05JAN2021 Line commented //PRJ-1115.AS.1.0
            //PurchOrderLine.Validate("Job Task No.", "NS_Job Task No.");//PRJ-1099.AS.1.0 05JAN2021 Line commented //PRJ-1115.AS.1.0
            PurchOrderLine."Variant Code" := ReqLine."Variant Code";
            //PRJ-1117.JS.1.0 07Dec2022 - End
            PurchOrderLine."NS_Job Planning Line No." := "NS_Job Planning Line No."; //PRJ-929.GK.4.0 20Dec2021
            //PRJ-999.JS.1.1  24Nov2021-end  
            PurchOrderLine."NS_JMP Details" := copystr(ReqLine."NS_JMP Details", 1, 20);  //PRJCTPR-256.JS.1.0
            PurchOrderLine."NS_PPJMP Details" := ReqLine."NS_JMP Details";  //PRJCTPR-256.JS.1.0
            PurchOrderLine."NS_JMP Line No." := "NS_JMP Line No.";//PRJ-1411.RM.1.0                  
            PurchOrderLine."NS_JMP Document No." := "NS_JMP Document No.";
            PurchOrderLine."NS_Segment Code" := "NS_Segment Code";//TM-10.AM.1.0
            //PRJ-1117.JS.1.0 07Dec2022 - Start
            //PRJ-1308.GK.1.0 05May2022 -start Comment
            // if ReqLine."NS_Job No." <> '' then begin
            //     if ns_jobs.get(ReqLine."NS_Job No.") then begin
            //         if JobSU."NS_Flow Job Card Dimension" = true then begin
            //             PurchOrderLine."Shortcut Dimension 1 Code" := ns_jobs."Global Dimension 1 Code";
            //             PurchOrderLine."Shortcut Dimension 2 Code" := ns_jobs."Global Dimension 2 Code";
            //             PurchOrderLine."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(ReqLine."NS_Job No.");
            //         end else begin
            //             //PRJ-1148.JS.1.0 20JAN2022 - Start
            //             NS_DefaultDim.Reset();
            //             NS_DefaultDim.SetRange("Table ID", 27);
            //             NS_DefaultDim.SetRange("No.", ReqLine."No.");
            //             if NS_DefaultDim.IsEmpty() then begin
            //                 PurchOrderLine."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
            //                 PurchOrderLine."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
            //                 PurchOrderLine."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(ReqLine."NS_Job No.");
            //                 If JobTask1.get(ReqLine."NS_Job No.", ReqLine."NS_Job Task No.") then
            //                     IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
            //                         PurchOrderLine."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
            //                         PurchOrderLine."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
            //                         PurchOrderLine."Dimension Set ID" := NS_BillingHeader.NS_GetDimensionNoFromJobTask(JobTask1."Job No.", JobTask1."Job Task No.");
            //                     end;
            //             end else
            //                 if NS_Item.get(ReqLine."No.") then begin
            //                     PurchOrderLine."Shortcut Dimension 1 Code" := NS_Item."Global Dimension 1 Code";
            //                     PurchOrderLine."Shortcut Dimension 2 Code" := NS_Item."Global Dimension 2 Code";
            //                     PurchOrderLine."Dimension Set ID" := NS_JobMatPlan.GetDimensionNoFromItemNo(NS_Item."No.");
            //                 end;
            //         end;
            //         //PRJ-1148.JS.1.0 20JAN2022 - end    
            //     end;
            // end
            //PRJ-1308.GK.1.0 05May2022 -end
            //PRJ-1117.JS.1.0 07Dec2022 - end
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 333, 'OnAfterInsertPurchOrderHeader', '', false, false)]
    local procedure NS_C333OnAfterInsertPurchOrderHeader(var RequisitionLine: Record "Requisition Line"; var PurchaseOrderHeader: Record "Purchase Header")
    var
        JobSU: Record "Jobs Setup";
        Job: Record Job;
        PurchasingCode: Record Purchasing;
        SpecialOrder: Boolean;
        vendor: Record Vendor;
        userSetup: Record "User Setup"; //PRJ-130.MS.1.0
        NS_Job: Record Job; //PRJ-1510.NK.1.0 21Jul2022
        VendRec: Record Vendor;//PRJ-1674
        //PRJCTPR-199.JS.1.0 24NOV2023 - Start
        NS_JobSetup: Record "Jobs Setup";
        NS_Jobs: Record job;
        NS_JobTesks: Record "Job Task";
        NS_BillingHeader: Record "NS_Progress Billing Header";
        NSDimBufferTemp: record "Dimension Buffer" temporary;
        NSVendor: Record Vendor;
        NSDefaultDim: record "Default Dimension";
        NSJobTaskDimension: record "Job Task Dimension";
        NSDimMgt: codeunit DimensionManagement;
        NSGLedgSetup: record "General Ledger Setup";
    //PRJCTPR-199.JS.1.0 24NOV2023 - end        
    begin
        if JobSU.Get() then;   //PRJCTPR-199.JS.1.0 03NOV2023
        with RequisitionLine do begin
            PurchaseOrderHeader."NS_Job No." := "NS_Job No.";
            //PRJ-1510.NK.1.0 21Jul2022 Start
            if JobSU."NS_Enable Job Address" then begin
                PurchaseOrderHeader."NS_Add Job Address" := true;
                if NS_Job.get(RequisitionLine."NS_Job No.") then
                    PurchaseOrderHeader.SetShipToAddress('', '', NS_Job."NS_Job Address 1", NS_Job."NS_Job Address 2",
                                      NS_Job."NS_Job City", NS_Job."NS_Job Post Code", NS_Job."NS_Job County", NS_Job."NS_Job Country/Region Code");
                PurchaseOrderHeader."Ship-to Name" := NS_Job.Description;
            end;
            //PRJ-1510.NK.1.0 21Jul2022 End

            if "NS_Job No." <> '' then
                if Job.Get("NS_Job No.") then begin
                    if JobSU."NS_Use Job Mat'l Plan Active"
                      and (JobSU."NS_Job Mat'l Planning Location" <> '') then
                        PurchaseOrderHeader."Location Code" := JobSU."NS_Job Mat'l Planning Location"
                    else
                        PurchaseOrderHeader."Location Code" := "Location Code";
                    PurchaseOrderHeader."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                    PurchaseOrderHeader."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                end;
            //PRJ-130.MS.1.0    
            if userSetup.Get(UserId) then;
            if userSetup."Salespers./Purch. Code" <> '' then
                PurchaseOrderHeader."Purchaser Code" := userSetup."Salespers./Purch. Code";
            //PRJ-130.MS.1.0     
            if PurchasingCode.Get("Purchasing Code") then
                if PurchasingCode."Special Order" then
                    SpecialOrder := true;

            if not SpecialOrder then
                // if "Ship-to Code" = '' then //PRJ-55.SK.1.0 Commented
                  if "Ship-to Code" <> '' Then //PRJ-55.SK.1.0 Added
                    PurchaseOrderHeader.Validate("Ship-to Code", "Ship-to Code");

            //PRJCTPR-199.JS.1.0 03NOV2023 - Start
            if NS_JobSetup.get() then;
            if NSGLedgSetup.get() then;
            if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
                clear(NSDimBufferTemp);
                if PurchaseOrderHeader."NS_Job No." <> '' then begin
                    if NS_Jobs.get(PurchaseOrderHeader."NS_Job No.") then begin
                        NSDefaultDim.Reset();
                        NSDefaultDim.setrange("Table ID", 167);
                        NSDefaultDim.setrange("No.", NS_Jobs."No.");
                        NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                        if NSDefaultDim.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 38;
                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSDefaultDim.next = 0;
                    end;
                    if NSVendor.get(PurchaseOrderHeader."Buy-from Vendor No.") then begin
                        NSDefaultDim.Reset();
                        NSDefaultDim.setrange("Table ID", 23);
                        NSDefaultDim.setrange("No.", NSVendor."No.");
                        NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                        if NSDefaultDim.findset() then
                            repeat
                                NSDimBufferTemp.reset();
                                NSDimBufferTemp.setrange("Table ID", 38);
                                NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                if not NSDimBufferTemp.findfirst() then begin
                                    NSDimBufferTemp.Init();
                                    NSDimBufferTemp."Table ID" := 38;
                                    NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                    NSDimBufferTemp.Insert();
                                    NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                    NSDimBufferTemp.Modify();
                                end;
                            until NSDefaultDim.next = 0;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                PurchaseOrderHeader.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                PurchaseOrderHeader.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;
                    PurchaseOrderHeader."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                    PurchaseOrderHeader.Modify();
                end;
            end;
            //PRJCTPR-199.JS.1.1 17JAN2024 - start
            if NS_JobSetup."NS_Flow Job Card Dimension" = false then begin
                clear(NSDimBufferTemp);
                if PurchaseOrderHeader."NS_Job No." <> '' then begin
                    if NS_Jobs.get(PurchaseOrderHeader."NS_Job No.") then begin
                        NSDefaultDim.Reset();
                        NSDefaultDim.setrange("Table ID", 167);
                        NSDefaultDim.setrange("No.", NS_Jobs."No.");
                        NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                        if NSDefaultDim.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 38;
                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSDefaultDim.next = 0;
                    end;
                    if NSVendor.get(PurchaseOrderHeader."Buy-from Vendor No.") then begin
                        NSDefaultDim.Reset();
                        NSDefaultDim.setrange("Table ID", 23);
                        NSDefaultDim.setrange("No.", NSVendor."No.");
                        NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                        if NSDefaultDim.findset() then
                            repeat
                                NSDimBufferTemp.reset();
                                NSDimBufferTemp.setrange("Table ID", 38);
                                NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                if not NSDimBufferTemp.findfirst() then begin
                                    NSDimBufferTemp.Init();
                                    NSDimBufferTemp."Table ID" := 38;
                                    NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                    NSDimBufferTemp.Insert();
                                    NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                    NSDimBufferTemp.Modify();
                                end;
                            until NSDefaultDim.next = 0;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                PurchaseOrderHeader.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                PurchaseOrderHeader.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;
                    PurchaseOrderHeader."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                    PurchaseOrderHeader.Modify();
                end;
            end;
            //PRJCTPR-199.JS.1.1 17JAN2024 - start
            //CTSI-23.MS.1.0 start
            if Job.Get(PurchaseOrderHeader."NS_Job No.") then;
            if vendor.get(PurchaseOrderHeader."Buy-from Vendor No.") then;//PRJ-1674.AS.1.0 09DEC2022 Commented
            if VendRec.get(PurchaseOrderHeader."Buy-from Vendor No.") then; //PRJ-1674.AS.1.0 09DEC2022 Added

            // if JOB."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
            //     PurchaseOrderHeader."Gen. Bus. Posting Group" := job."NS_Gen. Bus. Posting Group" //PRJ-831.AS.1.0 12OCT2021 Comment old


            IF RequisitionLine."NS_Job No." <> '' then begin //PRJ-1674.AS.1.0 09DEC2022  --- Added begin..end
                if JOB."NS_Gen. Bus. Posting Group New" <> '' then //PRJ-831.AS.1.0 12OCT2021 Add New
                    PurchaseOrderHeader."Gen. Bus. Posting Group" := job."NS_Gen. Bus. Posting Group New" //PRJ-831.AS.1.0 12OCT2021 Add New
                else
                    if JobSU."NS_Gen. Bus. Posting Group" <> '' then
                        PurchaseOrderHeader."Gen. Bus. Posting Group" := JobSU."NS_Gen. Bus. Posting Group"
                    else
                        if vendor."Gen. Bus. Posting Group" <> '' then
                            PurchaseOrderHeader."Gen. Bus. Posting Group" := vendor."Gen. Bus. Posting Group";
            END;
            //PRJ-1674.AS.1.0 09DEC2022  --- Added begin..end

            //PRJ-1674.AS.1.0 09DEC2022 START
            IF RequisitionLine."NS_Job No." = '' then begin
                if VendRec."Gen. Bus. Posting Group" <> '' then
                    PurchaseOrderHeader."Gen. Bus. Posting Group" := VendRec."Gen. Bus. Posting Group";
            END;
            //PRJ-1674.AS.1.0 09DEC2022 END

            if Job."NS_Tax Area Code" <> '' then //PRJ-1562.RM.1.0
                PurchaseOrderHeader."Tax Area Code" := Job."NS_Tax Area Code";//PRJ-1562.RM.1.0

            PurchaseOrderHeader."NS_Job Name" := Job.Description;//PRJ-261.MS.1.0	//PPAL-21
                                                                 //CTSI-23.MS.1.0 end
                                                                 //end;
                                                                 //PRJ-1170.NK.1.0 End
            PurchaseOrderHeader."NS_Job Purchaser" := job."NS_Job Purchaser";//PRJ-1380.NK.1.0 13May2022
            PurchaseOrderHeader."NS_Job Manager" := job.NS_Manager;//PRJ-1380.NK.1.0 13May2022
            PurchaseOrderHeader."NS_Created By JMP" := true; //PRJCTPR-115.AT.1.0 17May2023
        end;
    End;

    [EventSubscriber(ObjectType::Codeunit, 227, 'OnBeforePostApplyVendLedgEntry', '', false, false)]
    local procedure NS_C227OnBeforePostApplyVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := VendorLedgerEntry."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 227, 'OnBeforePostUnapplyVendLedgEntry', '', false, false)]
    local procedure NS_C227OnBeforePostUnapplyVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := VendorLedgerEntry."NS_Retention Ledger Code";
    end;

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Codeunit, 227, 'OnGetApplicationDateOnAfterSetFilters', '', false, false)]
    local procedure NS_C227OnGetApplicationDateApplyToVendLedgEntry(var ApplyToVendLedgEntry: Record "Vendor Ledger Entry"; VendorLedgEntry: Record "Vendor Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_SalesSetup.Get;
        NS_PurchSetup.Get;
        if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
            ApplyToVendLedgEntry.SetRange("NS_Retention Ledger Code", VendorLedgEntry."NS_Retention Ledger Code");
    end;
    //PPNA16.0 Modified Event End

    //PPNA16.0 Modified event start
    [EventSubscriber(ObjectType::Codeunit, 226, 'OnGetApplicationDateOnAfterSetFilters', '', false, false)]
    local procedure NS_C226OnGetApplicationDateApplyToCustLedgEntry(var ApplyToCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_SalesSetup.Get;
        NS_PurchSetup.Get;
        if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
            ApplyToCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgEntry."NS_Retention Ledger Code");
    end;
    //PPNA16.0 Modified event end

    [EventSubscriber(ObjectType::Codeunit, 226, 'OnBeforePostApplyCustLedgEntry', '', false, false)]
    local procedure NS_C226OnBeforePostApplyCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := CustLedgerEntry."NS_Retention Ledger Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 226, 'OnBeforePostUnapplyCustLedgEntry', '', false, false)]
    local procedure NS_C226OnBeforePostUnapplyCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        GenJournalLine."NS_Retention Ledger Code" := CustLedgerEntry."NS_Retention Ledger Code";
    end;

    //PRJ-158/159 VT 26-03-20 begin

    [EventSubscriber(ObjectType::Codeunit, 221, 'OnBeforeFindResPrice', '', false, false)]
    local procedure NS_C221OnBeforeFindResPrice(var ResourcePrice: Record "Resource Price"; var IsHandled: Boolean)
    var
        ResPrice2: Record "Resource Price";
        Res: Record Resource;
    begin
        with ResourcePrice do begin
            ResPrice2.Reset;
            //ResPrice2.SetCurrentKey("Job No.", Type, Code, "Work Type Code", "Currency Code"); PRJ-158/159 VT 27-03-20, as Job no. is not the part of Key
            ResPrice2.SetRange("NS_Job No.", "NS_Job No.");
            ResPrice2.SetRange(Type, ResPrice2.Type::Resource);
            ResPrice2.SetRange(Code, Code);
            ResPrice2.SetRange("Work Type Code", "Work Type Code");
            ResPrice2.SetRange("Currency Code", "Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            End;
            ResPrice2.SetRange("Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            end;

            Res.Get(Code);
            ResPrice2.SetRange(Type, ResPrice2.Type::"Group(Resource)");
            ResPrice2.SetRange(Code, Res."Resource Group No.");
            ResPrice2.SetRange("Currency Code", "Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            end;
            ResPrice2.SetRange("Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            end;

            ResPrice2.SetRange(Type, ResPrice2.Type::All);
            ResPrice2.SetRange(Code);
            ResPrice2.SetRange("Currency Code", "Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            end;

            ResPrice2.SetRange("Currency Code");
            if ResPrice2.FindFirst then begin
                IsHandled := true;
                exit;
            end;
            ResPrice2.Reset;
        end;
    end;


    //PRJ-180.MS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnBeforeModifySalesHeader', '', false, false)]
    local procedure NS_C1002onBeforeModifySalesHeader(var SalesHeader: Record "Sales Header"; Job: Record "Job")
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        NS_Job: Record Job;//PRJ-1610.GK.1.0 09Sept2022
        JobSetup: Record "Jobs Setup";//PRJ-1610.GK.1.0 09Sept2022
        CustomerRec: Record Customer;//PRJ-1610.GK.1.0 09Sept2022
        //PRJCTPR-199.JS.1.0 24NOV2023 - Start
        NS_JobSetup: Record "Jobs Setup";
        NS_Jobs: Record job;
        NS_JobTesks: Record "Job Task";
        NS_BillingHeader: Record "NS_Progress Billing Header";
        NSDimBufferTemp: record "Dimension Buffer" temporary;
        NSCustomer: Record Customer;
        NSDefaultDim: record "Default Dimension";
        NSJobTaskDimension: record "Job Task Dimension";
        NSDimMgt: codeunit DimensionManagement;
        NSGLedgSetup: record "General Ledger Setup";
    //PRJCTPR-199.JS.1.0 24NOV2023 - end
    begin
        //PRJ-1610.GK.1.0 09Sept2022 start
        SalesHeader."NS_Job No." := Job."No.";
        if SalesHeader."NS_Job No." <> '' then begin
            if NS_Job.Get(SalesHeader."NS_Job No.") then;
            if JobSetup.Get() then;
            IF NS_Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                SalesHeader.Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Add New
            else
                IF JobSetup."NS_Gen. Bus. Posting Group" <> '' then
                    SalesHeader.Validate("Gen. Bus. Posting Group", JobSetup."NS_Gen. Bus. Posting Group")
                else
                    IF CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
                        IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                            SalesHeader.Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
            //PRJ-131.SK.1.0 End
        end else begin
            IF CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
                IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                    SalesHeader.Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
        end;
        //PRJ-1610.GK.1.0 09Sept2022 end
        //PRJ-253 AS2.0 05-05-2020 start                                                                                                 
        //IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then //PRJ-312.MS.1.0
        SalesHeader.Validate("Tax Liable", Job."NS_Tax Liable"); //PRJ-312.MS.1.0
        SalesHeader."Tax Area Code" := Job."NS_Tax Area Code";
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then //CTSI-150.AS.1.0 28Sept2020
            SalesHeader."NS_Use % Billing format" := Job."NS_Use % Billing format";//CTSI-150.AS.1.0 28Sept2020
        //PRJ-253 AS2.0 05-05-2020 end
        SalesHeader."Dimension Set ID" := ProgressBillingHeader.NS_GetDimensionNoFromJob(Job."No."); //PRJ-208.SK.1.0 Added for dimension flow into 
        //SalesHeader.validate("Gen. Bus. Posting Group", Job."NS_Gen. Bus. Posting Group");//PRJ-420.MS.1.0 //PRJ-831.AS.1.0 12OCT2021 Comment old                                                                             
        SalesHeader.Validate("External Document No.", job."NS_Customer PO Number");//CTSI-179.MS.1.0
        SalesHeader."Salesperson Code" := Job."NS_Salesperson Code";//PRJ-415  
        SalesHeader.Validate("NS_Retention Percent", Job."NS_Default Job Retention"); //PRJ-911.GK.1.0 10Sep2021

        //PRJCTPR-199.JS.1.0 24NOV2023 - Start
        clear(NSDimBufferTemp);
        if NS_JobSetup.get() then;
        if NSGLedgSetup.get() then;
        if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
            if SalesHeader."NS_Job No." <> '' then begin
                if NS_Jobs.get(SalesHeader."NS_Job No.") then begin
                    NSDefaultDim.Reset();
                    NSDefaultDim.setrange("Table ID", 167);
                    NSDefaultDim.setrange("No.", NS_Jobs."No.");
                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                    if NSDefaultDim.findset() then
                        repeat
                            NSDimBufferTemp.Init();
                            NSDimBufferTemp."Table ID" := 38;
                            NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                            NSDimBufferTemp.Insert();
                            NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                            NSDimBufferTemp.Modify();
                        until NSDefaultDim.next = 0;
                end;
                if NSCustomer.get(SalesHeader."Bill-to Customer No.") then begin
                    NSDefaultDim.Reset();
                    NSDefaultDim.setrange("Table ID", 18);
                    NSDefaultDim.setrange("No.", NSCustomer."No.");
                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                    if NSDefaultDim.findset() then
                        repeat
                            NSDimBufferTemp.reset();
                            NSDimBufferTemp.setrange("Table ID", 38);
                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                            if not NSDimBufferTemp.findfirst() then begin
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 38;
                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            end;
                        until NSDefaultDim.next = 0;
                end;
                NSDimBufferTemp.reset();
                if NSDimBufferTemp.findset() then
                    repeat
                        if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                            SalesHeader.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                        if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                            SalesHeader.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                    until NSDimBufferTemp.next = 0;
                SalesHeader."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
            end;
        end;
        //PRJCTPR-199.JS.1.1 17Jan2023 - Start
        if NS_JobSetup."NS_Flow Job Card Dimension" = false then begin   //PRJCTPR-324.JS.1.0 27FEB2024
            if SalesHeader."NS_Job No." <> '' then begin
                if NS_Jobs.get(SalesHeader."NS_Job No.") then begin
                    NSDefaultDim.Reset();
                    NSDefaultDim.setrange("Table ID", 167);
                    NSDefaultDim.setrange("No.", NS_Jobs."No.");
                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                    if NSDefaultDim.findset() then
                        repeat
                            NSDimBufferTemp.Init();
                            NSDimBufferTemp."Table ID" := 38;
                            NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                            NSDimBufferTemp.Insert();
                            NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                            NSDimBufferTemp.Modify();
                        until NSDefaultDim.next = 0;
                end;
                if NSCustomer.get(SalesHeader."Bill-to Customer No.") then begin
                    NSDefaultDim.Reset();
                    NSDefaultDim.setrange("Table ID", 18);
                    NSDefaultDim.setrange("No.", NSCustomer."No.");
                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                    if NSDefaultDim.findset() then
                        repeat
                            NSDimBufferTemp.reset();
                            NSDimBufferTemp.setrange("Table ID", 38);
                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                            if not NSDimBufferTemp.findfirst() then begin
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 38;
                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            end;
                        until NSDefaultDim.next = 0;
                end;
                NSDimBufferTemp.reset();
                if NSDimBufferTemp.findset() then
                    repeat
                        if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                            SalesHeader.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                        if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                            SalesHeader.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                    until NSDimBufferTemp.next = 0;
                SalesHeader."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
            end;
        end;
        //PRJCTPR-199.JS.1.0 24NOV2023 - end
    end;
    //PRJ-180.MS.1.0 end

    //PRJ-158/159 VT 26-03-20 end

    procedure NS_C221FindResUnitPricePurchLine(var PurchLine: Record "Purchase Line")
    var
        NS_ResPrice: Record "Resource Price";
        NS_ResFindUnitPrice: Codeunit "Resource-Find Price";
    begin
        NS_ResPrice.Init;
        NS_ResPrice.Code := PurchLine."No.";
        NS_ResPrice."Work Type Code" := PurchLine."NS_Work Type Code";
        NS_ResPrice."NS_Job No." := PurchLine."Job No.";
        NS_ResFindUnitPrice.Run(NS_ResPrice);
        PurchLine."Unit Price (LCY)" := NS_ResPrice."Unit Price";
    end;

    //PRJ-158/159 VT 25-03-20 BEGIN
    [EventSubscriber(ObjectType::Codeunit, 220, 'OnBeforeFindResUnitCost', '', false, false)]
    local procedure NS_C220OnBeforeFindResUnitCost(var ResourceCost: Record "Resource Cost"; var IsHandled: Boolean)
    var
        NS_JobResPrice: Record "Job Resource Price";
        Res: Record Resource;
    begin
        Res.Get(ResourceCost.Code);
        NS_JobResPrice.SetRange("Job No.", ResourceCost."NS_Job No.");
        NS_JobResPrice.SetRange("Currency Code", ResourceCost."NS_Currency Code");
        NS_JobResPrice.SetRange("Job Task No.", ResourceCost."NS_Job Task No.");
        case true of
            NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::Resource):
                begin
                    ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                    ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                    if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                        IsHandled := true;
                    exit;
                end;
            NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::"Group(Resource)"):
                begin
                    ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                    ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                    //PRJ-263 VT1.0 01-05-20 begin
                    if ResourceCost."Unit Cost" = 0 then
                        ResourceCost."Unit Cost" := Res."Unit Cost";
                    //PRJ-263 VT1.0 01-05-20 end
                    if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                        IsHandled := true;
                    exit;
                end;
            NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::All):
                begin
                    ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                    ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                    //PRJ-263 VT1.0 01-05-20 begin
                    if ResourceCost."Unit Cost" = 0 then
                        ResourceCost."Unit Cost" := Res."Unit Cost";
                    //PRJ-263 VT1.0 01-05-20 end
                    if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                        IsHandled := true;
                    exit;
                end;
            else begin
                NS_JobResPrice.SetRange("Job Task No.", '');
                case true of
                    NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::Resource):
                        begin
                            ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                            ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                            if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                                IsHandled := true;
                            exit;
                        end;
                    NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::"Group(Resource)"):
                        begin
                            ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                            ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                            //PRJ-263 VT1.0 01-05-20 begin
                            if ResourceCost."Unit Cost" = 0 then
                                ResourceCost."Unit Cost" := Res."Unit Cost";
                            //PRJ-263 VT1.0 01-05-20 end
                            if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                                IsHandled := true;
                            exit;
                        end;
                    NS_C220FindJobResCost(NS_JobResPrice, ResourceCost, NS_JobResPrice.Type::All):
                        begin
                            ResourceCost."Unit Cost" := NS_JobResPrice."NS_Unit Cost";
                            ResourceCost."Direct Unit Cost" := Res."Direct Unit Cost";
                            //PRJ-263 VT1.0 01-05-20 begin
                            if ResourceCost."Unit Cost" = 0 then
                                ResourceCost."Unit Cost" := Res."Unit Cost";
                            //PRJ-263 VT1.0 01-05-20 end
                            if (ResourceCost."Unit Cost" <> 0) or (Res."Direct Unit Cost" <> 0) then
                                IsHandled := true;
                            exit;
                        end;
                end;
            end;
        end;
    end;
    //PRJ-158/159 VT 25-03-20 End  



    procedure NS_C220FindResUnitCostPurchLine(var PurchLine: Record "Purchase Line")
    var
        NS_ResCost: Record "Resource Cost";
        NS_ResFindUnitCost: Codeunit "Resource-Find Cost";
    begin
        NS_ResCost.Init;
        NS_ResCost.Code := PurchLine."No.";
        NS_ResCost."Work Type Code" := PurchLine."NS_Work Type Code";
        NS_ResFindUnitCost.Run(NS_ResCost);
        PurchLine."Direct Unit Cost" := NS_ResCost."Direct Unit Cost";
        PurchLine."Unit Cost (LCY)" := NS_ResCost."Unit Cost";
    end;

    procedure NS_C220FindJobResCost(var JobResourcePrice: Record "Job Resource Price"; ResourceCost: Record "Resource Cost"; PriceType: Option Resource,"Group(Resource)",All): Boolean
    var
        NS_Resource: Record Resource;
    begin
        NS_Resource.Get(ResourceCost.Code);
        case PriceType of
            PriceType::Resource:
                begin
                    JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                    JobResourcePrice.SetRange("Work Type Code", ResourceCost."Work Type Code");
                    JobResourcePrice.SetRange(Code, ResourceCost.Code);
                    exit(JobResourcePrice.FindFirst);
                end;
            PriceType::"Group(Resource)":
                begin
                    JobResourcePrice.SetRange(Type, JobResourcePrice.Type::"Group(Resource)");
                    JobResourcePrice.SetRange(Code, NS_Resource."Resource Group No.");
                    exit(JobResourcePrice.FindFirst);
                end;
            PriceType::All:
                begin
                    JobResourcePrice.SetRange(Type, JobResourcePrice.Type::All);
                    exit(JobResourcePrice.FindFirst);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 212, 'OnBeforeResLedgEntryInsert', '', false, false)]
    local procedure NS_C212OnBeforeResLedgEntryInsert(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    var
        NS_JobsSetup: Record "Jobs Setup";
        ResUOM: Record "Resource Unit of Measure";
    begin
        with ResJournalLine do begin
            ResLedgerEntry."NS_Work Units" := "NS_Work Units";
            ResLedgerEntry."NS_Work Unit of Measure" := "NS_Work Unit of Measure";
            ResLedgerEntry."NS_Retention Ledger Code" := "NS_Retention Ledger Code";

            NS_JobsSetup.Get;
            if ("NS_Subcontract No." > '') and ("Unit of Measure Code" = NS_JobsSetup."NS_Subcontract Default UOM") then
                ResLedgerEntry."Quantity (Base)" := Quantity * "Qty. per Unit of Measure"
            else begin
                ResUOM.Get(ResLedgerEntry."Resource No.", ResLedgerEntry."Unit of Measure Code");
                if ResUOM."Related to Base Unit of Meas." then
                    ResLedgerEntry."Quantity (Base)" := ResLedgerEntry.Quantity * ResLedgerEntry."Qty. per Unit of Measure";
            end;
        end;
    end;




    //PPNA17.0 Opened Start OnBeforeDtldVendLedgEntryModify
    [EventSubscriber(ObjectType::Codeunit, 113, 'OnRunOnBeforeDtldVendLedgEntryModifyAll', '', false, false)]
    local procedure NS_C113OnBeforeDtldVendLedgEntryModify(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            DtldVendLedgEntry.SetRange("NS_Retention Ledger Code", VendLedgEntry."NS_Retention Ledger Code");
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Codeunit, 113, 'OnBeforeVendLedgEntryModify', '', false, false)]
    local procedure NS_C113OnBeforeVendLedgEntryModify(var VendLedgEntry: Record "Vendor Ledger Entry"; FromVendLedgEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchInvHeader: Record "Purch. Inv. Header";
        NS_PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //If Draw Number changed, update associated document also
        if VendLedgEntry."NS_Draw No." <> FromVendLedgEntry."NS_Draw No." then begin
            case VendLedgEntry."Document Type" of
                VendLedgEntry."Document Type"::Invoice:
                    begin
                        if NS_PurchInvHeader.Get(VendLedgEntry."Document No.") then begin
                            NS_PurchInvHeader."NS_Draw No." := FromVendLedgEntry."NS_Draw No.";
                            NS_PurchInvHeader.Modify;
                        end;
                    end;
                VendLedgEntry."Document Type"::"Credit Memo":
                    begin
                        if NS_PurchCrMemoHdr.Get(VendLedgEntry."Document No.") then begin
                            NS_PurchCrMemoHdr."NS_Draw No." := FromVendLedgEntry."NS_Draw No.";
                            NS_PurchCrMemoHdr.Modify;
                        end;
                    end;
            end;
            VendLedgEntry."NS_Draw No." := FromVendLedgEntry."NS_Draw No.";
        end;
        VendLedgEntry."NS_Lien Release Print Status" := FromVendLedgEntry."NS_Lien Release Print Status";
        VendLedgEntry."NS_Lien Release Type" := FromVendLedgEntry."NS_Lien Release Type";
        VendLedgEntry."NS_Lien Release Signed Date" := FromVendLedgEntry."NS_Lien Release Signed Date";
        //ProjectPro - end

        if VendLedgEntry.Open then begin
            NS_PurchSetup.Get;
            if not NS_PurchSetup."NS_Purchase Retention Inactive" then
                VendLedgEntry."NS_Retention Date" := FromVendLedgEntry."NS_Retention Date";
        end;
    end;

    //PRJ-9.TY.1.0 Start
    //[EventSubscriber(ObjectType::Codeunit, 103, 'OnBeforeDtldCustLedgEntryModify', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 103, 'OnBeforeOnRun', '', false, false)]
    local procedure NS_C103OnBeforeDtldCustLedgEntryModify(VAR CustLedgerEntryRec: Record "Cust. Ledger Entry"; VAR CustLedgerEntry: Record "Cust. Ledger Entry"; VAR DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        NS_SalesSetup.Get;
        IF not NS_SalesSetup."NS_Sales Retention Inactive" then
            DetailedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgerEntryRec."NS_Retention Ledger Code");
    end;
    //PRJ-9.TY.1.0 End


    [EventSubscriber(ObjectType::Codeunit, 103, 'OnBeforeCustLedgEntryModify', '', false, false)]
    local procedure NS_C103OnBeforeCustLedgEntryModify(var CustLedgEntry: Record "Cust. Ledger Entry"; FromCustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        if CustLedgEntry.Open then begin
            NS_SalesSetup.Get;
            if not NS_SalesSetup."NS_Sales Retention Inactive" then
                CustLedgEntry."NS_Retention Date" := FromCustLedgEntry."NS_Retention Date";
        end;
    end;

    //PPNA16.0 Modified Event STart
    [EventSubscriber(ObjectType::Codeunit, 14, 'OnBeforeShowCustomerLedgerEntries', '', false, false)]
    local procedure NS_C14OnBeforeGenJnlShowEntriesRun(var IsHandled: Boolean; GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";

    begin
        with GenJournalLine do
            case "Account Type" of
                "Account Type"::Customer:
                    begin
                        NS_SalesSetup.Get;
                        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
                            CustLedgEntry.SetRange("NS_Retention Ledger Code", "NS_Retention Ledger Code");
                            IF CustLedgEntry.FindLast() Then;
                            PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgEntry);
                            IsHandled := true;
                        end;
                    end;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Show Entries", 'OnBeforeShowVendorLedgerEntries', '', false, false)]
    local procedure NS_C14OnBeforeShowVendorLedgerEntriesRun(GenJournalLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry"; var IsHandled: Boolean)
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        with GenJournalLine do
            case "Account Type" of
                "Account Type"::Vendor:
                    begin
                        NS_PurchSetup.Get;
                        if not NS_PurchSetup."NS_Purchase Retention Inactive" then begin
                            VendLedgEntry.SetRange("NS_Retention Ledger Code", "NS_Retention Ledger Code");
                            IF VendLedgEntry.FindLast() then;
                            PAGE.Run(PAGE::"Vendor Ledger Entries", VendLedgEntry);
                            IsHandled := true;
                        end;
                    end;
            end;
    end;
    //PPNA16.0 Modified Event End


    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure NS_C22OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        //PE-291.JS.1.0 - Start
        NSEnviroInfo: codeunit "Environment information";
        NSBaseAppId: Codeunit "BaseApp ID";
        NSBaseAppIDCode: Integer;
    //PE-291.JS.1.0 - end
    begin
        //PE-291.JS.1.0 - Start
        clear(NSBaseAppIDCode);
        NSBaseAppIDCode := NSEnviroInfo.VersionInstalled(NSBaseAppId.Get());
        //PRJ-1170.NK.1.0 Start
        //with ItemJournalLine do
        if (ItemJournalLine."Job No." <> '') or (ItemJournalLine."NS_Subcontract No." <> '') then
            if NSBaseAppIDCode < 24 then begin
                if (ItemJournalLine."Source Code" <> 'JOBJNL') AND (ItemJournalLine."Source Code" <> 'INVTADJMT') then//PRJ-444.MS
                    NS_C22PostJobLedgerEntry(ItemJournalLine);
            end else begin
                if (ItemJournalLine."Source Code" <> 'PROJJNL') AND (ItemJournalLine."Source Code" <> 'INVTADJMT') then//PRJ-444.MS
                    NS_C22PostJobLedgerEntry(ItemJournalLine);
            end;
        //PE-291.JS.1.0 - end        
        //PRJ-1170.NK.1.0 End
    end;

    procedure NS_C22PostJobLedgerEntry(ItemJnlLine: Record "Item Journal Line")
    var
        NS_JobJnlLine: Record "Job Journal Line";
        NS_JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        PurReptLine: Record "Purch. Rcpt. Line";//CTSI-122.MS.1.0
        JobRec: Record Job;//PRJ-613.N.S.1.0
    begin
        with NS_JobJnlLine do begin
            Init;
            "Job No." := ItemJnlLine."Job No.";
            "NS_Subcontract No." := ItemJnlLine."NS_Subcontract No.";
            "Job Task No." := ItemJnlLine."Job Task No.";
            "Posting Date" := ItemJnlLine."Posting Date";
            "Document No." := ItemJnlLine."Document No.";
            Type := Type::Item;
            "No." := ItemJnlLine."Item No.";
            Description := ItemJnlLine.Description;
            "Unit Cost" := ItemJnlLine."NS_Job Unit Cost";
            "Unit Price" := ItemJnlLine."NS_Job Unit Price";
            "Unit of Measure Code" := ItemJnlLine."Unit of Measure Code";
            "Location Code" := ItemJnlLine."Location Code";
            "Shortcut Dimension 1 Code" := ItemJnlLine."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ItemJnlLine."Shortcut Dimension 2 Code";
            "NS_Retention Ledger Code" := ItemJnlLine."NS_Retention Ledger Code";
            "Job Posting Only" := true;
            "Dimension Set ID" := ItemJnlLine."Dimension Set ID";
            "Entry Type" := "Entry Type"::Usage;
            "Source Code" := ItemJnlLine."Source Code";
            "Gen. Bus. Posting Group" := ItemJnlLine."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := ItemJnlLine."Gen. Prod. Posting Group";
            "Document Date" := ItemJnlLine."Document Date";
            "External Document No." := ItemJnlLine."External Document No.";
            "Source Currency Code" := ItemJnlLine."Source Currency Code";
            case ItemJnlLine."Entry Type" of
                ItemJnlLine."Entry Type"::Purchase:
                    "Source Currency Total Cost" := -ItemJnlLine.Amount;
                ItemJnlLine."Entry Type"::Sale:
                    "Source Currency Total Price" := ItemJnlLine.Amount;
            end;
            "Source Currency Line Amount" := ItemJnlLine.Amount;
            "Variant Code" := ItemJnlLine."Variant Code";
            "Bin Code" := ItemJnlLine."Bin Code";
            "Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
            //CTSI-122.MS.1.0 start
            if ItemJnlLine."Source Code" = 'PURCHASES' then begin
                PurReptLine.Reset();
                PurReptLine.SetRange("Document No.", ItemJnlLine."Document No.");
                PurReptLine.SetFilter(Type, '%1', PurReptLine.Type::Item);
                PurReptLine.SetRange("No.", ItemJnlLine."item No.");
                if PurReptLine.FindFirst() then;
            end;
            if PurReptLine."NS_Job Cost Category" <> '' then
                "NS_job cost category" := PurReptLine."NS_Job Cost Category"
            else    //CTSI-122.MS.1.0 end;
                "NS_Job Cost Category" := ItemJnlLine.NS_Category;
            "NS_Cost-Revenue Type" := "NS_Cost-Revenue Type"::Cost;
            case ItemJnlLine."Entry Type" of
                ItemJnlLine."Entry Type"::"Negative Adjmt.":
                    begin
                        if ItemJnlLine."Quantity (Base)" >= 0 then begin
                            Quantity := ItemJnlLine.Quantity;
                            "Quantity (Base)" := ItemJnlLine."Quantity (Base)";
                            "Total Cost" := ItemJnlLine."NS_Job Cost";
                            "Total Price" := ItemJnlLine."NS_Job Price";
                        end else begin
                            Quantity := -ItemJnlLine.Quantity;
                            "Quantity (Base)" := -ItemJnlLine."Quantity (Base)";
                            "Total Cost" := -ItemJnlLine."NS_Job Cost";
                            "Total Price" := -ItemJnlLine."NS_Job Price";
                        end;
                    end;
                ItemJnlLine."Entry Type"::"Positive Adjmt.":
                    begin
                        Quantity := -ItemJnlLine.Quantity;
                        "Quantity (Base)" := -ItemJnlLine."Quantity (Base)";
                        "Total Cost" := -ItemJnlLine."NS_Job Cost";
                        "Total Price" := -ItemJnlLine."NS_Job Price";
                    end;
            end;
            "Currency Factor" := ItemJnlLine."NS_Job Currency Factor";
            //"Currency Code" := ItemJnlLine."NS_Job Currency Code";////PRJ-613.N.S.1.0
            //PRJ-613.N.S.1.0 Start
            if JobRec.get(ItemJnlLine."Job No.") then
                "Currency Code" := JobRec."Currency Code"
            else
                "Currency Code" := ItemJnlLine."NS_Job Currency Code";
            //PRJ-613.N.S.1.0 End
            "NS_External Relationship Type" := ItemJnlLine."NS_External Relationship Type";
            "NS_External Relationship No." := ItemJnlLine."NS_External Relationship No.";
            "NS_External Relationship Name" := ItemJnlLine."NS_External Relationship Name";
            "NS_Adj. entry" := ItemJnlLine.Adjustment; //PRJ-246.MS.1.0
            NS_JobJnlPostLine.RunWithCheck(NS_JobJnlLine);
        end;
    end;
    //PRJ-1332.GK.2.0 12May2022 start
    //PRJ-1332.JS.1.0 03MAY2022-start code Commented
    // //PRJ-1332.GK.1.0 25Apr2022 start  
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure NS_OnAfterPostSalesDoc(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesInvHdrNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        ProgressBillingHeader: Record "NS_Progress Billing Header";
    begin
        if SalesInvHeader.Get(SalesInvHdrNo) and (SalesInvHeader."NS_From Progress Billing No." <> '') then begin
            ProgressBillingHeader.reset;
            ProgressBillingHeader.SetRange("NS_No.", SalesInvHeader."NS_From Progress Billing No.");
            ProgressBillingHeader.SetRange("NS_Requisition No.", SalesInvHeader."NS_From ProgressBillingReq.No.");
            ProgressBillingHeader.SetRange("NS_Version No.", SalesInvHeader."NS_From ProgressBillingVer.No.");
            ProgressBillingHeader.SetRange("NS_Sales Document No.", SalesInvHeader."Pre-Assigned No.");
            if ProgressBillingHeader.FindFirst() then begin
                //ProgressBillingHeader.NS_Status := ProgressBillingHeader.NS_Status::"Invoice Posted";
                ProgressBillingHeader."NS_Posted Sales Invoice No." := SalesInvHeader."No.";
                ProgressBillingHeader.Modify();
            end;
        end;
    end;
    // //PRJ-1332.GK.1.0 25Apr2022 end
    //PRJ-1332.JS.1.0 03MAY2022-end code Commented
    //PRJ-1332.GK.2.0 12May2022 end
    //PRJ-1448.GK.1.0 14June2022 start
    [EventSubscriber(ObjectType::Codeunit, 444, 'OnPostVendorEntryOnAfterInitNewLine', '', false, false)]
    local procedure OnPostVendorEntryOnAfterInitNewLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        purchaseSetup: Record "Purchases & Payables Setup";
    begin
        if (purchaseSetup.get()) AND (purchaseSetup."NS_Purchase Retention Inactive" = false) then
            GenJnlLine."NS_Retention Ledger Code" := purchaseSetup."NS_Normal Vendor Ledger No.";
    end;
    //PRJ-1448.GK.1.0 14June2022 end
    //PRJ-1012.AS.1.0 - START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Return Shipment Line", 'OnAfterCopyItemJnlLineFromReturnShpt', '', false, false)]
    local procedure NS_ItemJnlLineValues(ReturnShipmentHeader: Record "Return Shipment Header"; ReturnShipmentLine: Record "Return Shipment Line"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine.NS_Category := ReturnShipmentLine."NS_Job Cost Category";
    end;
    //PRJ-1012.AS.1.0 - END

    [EventSubscriber(ObjectType::Codeunit, 9015, 'OnAfterGetApplicationVersion', '', false, false)]
    local procedure NS_C9015OnAfterGetApplicationVersion(var ApplicationVersion: Text[248])
    begin
        ApplicationVersion := ApplicationVersion + ' PPNA14.01'; //PRJ-64.SK.1.0 Modified string
    end;



    [EventSubscriber(ObjectType::Codeunit, 11, 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure NS_C11OnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        with GenJournalLine do begin
            if (("NS_Retention Amount" <> 0) or ("NS_Retention Percent" <> 0)) and
              not "NS_Retention Document" then
                TestField("NS_Retention Date");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeErrorIfNegativeAmt', '', false, false)]
    local procedure NS_C11OnBeforeErrorIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line"; var RaiseError: Boolean)
    begin
        with GenJnlLine do
            if ("Document Type" = "Document Type"::Invoice) and not "NS_Retention Document" then
                RaiseError := RaiseError
            else
                RaiseError := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeErrorIfPositiveAmt', '', false, false)]
    local procedure NS_C11OnBeforeErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line"; var RaiseError: Boolean)
    begin
        with GenJnlLine do
            if ("Document Type" = "Document Type"::"Credit Memo") and not "NS_Retention Document" then
                RaiseError := RaiseError
            else
                RaiseError := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostCustOnAfterCopyCVLedgEntryBuf', '', false, false)]
    local procedure NS_C12OnPostCustOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
        p.NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(GenJournalLine."NS_Retention Document", CVLedgerEntryBuffer."NS_Retention Ledger Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostVendOnAfterCopyCVLedgEntryBuf', '', false, false)]
    local procedure NS_C12OnPostVendOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
        p.NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(GenJournalLine."NS_Retention Document", CVLedgerEntryBuffer."NS_Retention Ledger Code");
    end;

    //[EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeFindOldCustLedgEntry', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckSalesDocNoIsNotUsed', '', false, false)]
    local procedure NS_OnBeforeCheckSalesDocNoIsNotUsed(DocType: Option; DocNo: Code[20]; var IsHandled: Boolean)
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        RetentionDocument: Boolean;
        RetentionLedgerCode: Code[20];
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        SalesDocAlreadyExistsErr: TextConst ENU = 'Sales %1 %2 already exists.';
        IsHandle: Boolean;//FGH-163.AS.29052024 //PE-307.JS.1.0
    begin
        //FGH-163.AS.29052024 start //PE-307.JS.1.0
        NS_OnBeforeNS_OnBeforeCheckSalesDocNoIsNotUsed(DocType, DocNo, IsHandled, IsHandle);
        if IsHandle then
            exit;
        //FGH-163.AS.29052024 end //PE-307.JS.1.0

        NS_SalesSetup.Get;
        OldCustLedgEntry.Reset();   //PRJ-1165.JS.1.0 24JAN2022
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            p.NS_C12GetOnPostCustOnAfterCopyCVLedgEntryBuf(RetentionDocument, RetentionLedgerCode);
            if RetentionDocument then
                OldCustLedgEntry.SetRange("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.")
            else
                OldCustLedgEntry.SetRange("NS_Retention Ledger Code", RetentionLedgerCode);
        end;
        //PRJ-1165.JS.1.0 24JAN2022 - start
        OldCustLedgEntry.SETRANGE("Document Type", DocType);
        OldCustLedgEntry.SETRANGE("Document No.", DocNo);
        //OldCustLedgEntry.SETRANGE("Document Type", DocType);
        //PRJ-1165.JS.1.0 24JAN2022 - end
        IF OldCustLedgEntry.FINDFIRST THEN
            ERROR(SalesDocAlreadyExistsErr, OldCustLedgEntry."Document Type", DocNo);
        IsHandled := true;
        p.NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(false, '');
    end;

    //[EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeFindOldVendLedgEntry', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckPurchDocNoIsNotUsed', '', false, false)]
    local procedure NS_C11OnBeforeCheckPurchDocNoIsNotUsed(DocType: Option; DocNo: Code[20]; var IsHandled: Boolean)
    var
        RetentionDocument: Boolean;
        RetentionLedgerCode: Code[20];
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        PurchDocAlreadyExistsErr: TextConst ENU = 'Purchase %1 %2 already exists.';
        NS_PurchDocAlreadyLedgerErr: TextConst ENU = 'You can not add more than one line in case of Type "Ledger" in a Retention Document.'; //PRJ-906.GK.1.0 05Oct2021
    begin
        //PRJ-1467.NK.2.0 START CODE BLOCK DUE TO APPSOURCE VALIDATION
        //p.NS_C12GetOnPostCustOnAfterCopyCVLedgEntryBuf(RetentionDocument, RetentionLedgerCode);
        //OldVendLedgEntry.SetRange("NS_Retention Ledger Code", RetentionLedgerCode);
        //OldVendLedgEntry.SETRANGE("Document No.", DocNo);
        //OldVendLedgEntry.SETRANGE("Document Type", DocType);
        //IF OldVendLedgEntry.FINDFIRST THEN
        //ERROR(PurchDocAlreadyExistsErr, OldVendLedgEntry."Document Type", DocNo);//PRJ-906.GK.1.0 05Oct2021 |Comment Line
        //    ERROR(NS_PurchDocAlreadyLedgerErr);//PRJ-906.GK.1.0 5Oct2021 |Add line
        //IsHandled := true;
        //p.NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(false, '');
        //PRJ-1467.NK.2.0 END
    end;

    //PRJ-1467.NK.2.0 START
    [EventSubscriber(ObjectType::Codeunit, 11, 'OnBeforeCheckPurchDocNoIsNotUsed', '', false, false)]
    local procedure NS_C11OnBeforeCheckPurchDocNoIsNotUsed1(DocType: Option; DocNo: Code[20]; var IsHandled: Boolean; GenJournalLine: Record "Gen. Journal Line") //PRJ-1467.NK.1.0 21Jun2022
    var
        RetentionDocument: Boolean;
        RetentionLedgerCode: Code[20];
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        PurchDocAlreadyExistsErr: TextConst ENU = 'Purchase %1 %2 already exists.';
        NS_PurchDocAlreadyLedgerErr: TextConst ENU = 'You can not add more than one line in case of Type "Ledger" in a Retention Document.'; //PRJ-906.GK.1.0 05Oct2021
    begin
        p.NS_C12GetOnPostCustOnAfterCopyCVLedgEntryBuf(RetentionDocument, RetentionLedgerCode);
        if ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) and (GenJournalLine."Journal Batch Name" = '')) then begin //PRJ-1467.NK.1.0 21Jun2022 |Add line
            OldVendLedgEntry.SetRange("NS_Retention Ledger Code", RetentionLedgerCode);
            OldVendLedgEntry.SETRANGE("Document No.", DocNo);
            OldVendLedgEntry.SETRANGE("Document Type", DocType);
            IF OldVendLedgEntry.FINDFIRST THEN
                ERROR(NS_PurchDocAlreadyLedgerErr);//PRJ-906.GK.1.0 5Oct2021 |Add line
                                                   //ERROR(PurchDocAlreadyExistsErr, OldVendLedgEntry."Document Type", DocNo);//PRJ-906.GK.1.0 05Oct2021 |Comment Line
        end; //PRJ-1467.NK.1.0 21Jun2022 Start
        if ((GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice) and (GenJournalLine."Journal Batch Name" <> '')) then begin //PRJ-1467.NK.1.0 21Jun2022 |Add line
            OldVendLedgEntry.Reset();
            OldVendLedgEntry.SetRange("NS_Retention Ledger Code", RetentionLedgerCode);
            OldVendLedgEntry.SETRANGE("Document No.", DocNo);
            OldVendLedgEntry.SETRANGE("Document Type", DocType);
            IF OldVendLedgEntry.FINDFIRST THEN
                ERROR(PurchDocAlreadyExistsErr, OldVendLedgEntry."Document Type", DocNo);
        end;
        //PRJ-1467.NK.1.0 21Jun2022 End
        IsHandled := true;
        p.NS_C12SetOnPostCustOnAfterCopyCVLedgEntryBuf(false, '');
    end;
    //PRJ-1467.NK.2.0 END


    //PRJ-137.SK.1.0 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeModifySalesHeader', '', false, false)]
    local procedure NS_C6620RemoveSomeUnwnatedFieldsToBeCopiedFrom(var ToSalesHeader: Record "Sales Header")
    begin
        ToSalesHeader."Applies-to Doc. No." := '';
        ToSalesHeader."Applies-to Doc. Type" := ToSalesHeader."Applies-to Doc. Type"::" ";
    end;
    //PRJ-137.SK.1.0 End

    //PRJ-9.SK.1.0 Start
    local procedure NS_SetTaxDetailFilter(var TaxDetail: Record "Tax Detail"; TaxJurisdictionCode: Code[10]; TaxGroupCode: Code[20]; Date: Date)
    begin
        TaxDetail.Reset;
        TaxDetail.SetRange("Tax Jurisdiction Code", TaxJurisdictionCode);
        if TaxGroupCode = '' then
            TaxDetail.SetFilter("Tax Group Code", '%1', TaxGroupCode)
        else
            TaxDetail.SetFilter("Tax Group Code", '%1|%2', '', TaxGroupCode);
        if Date = 0D then
            TaxDetail.SetFilter("Effective Date", '<=%1', WorkDate)
        else
            TaxDetail.SetFilter("Effective Date", '<=%1', Date);
    end;
    //PRJ-9.SK.1.0 End

    //PRJ-9.SK.1.0 Start

    //PPDA.1.0 Start
    // procedure NS_HandleRoundTaxUpOrDown(var SalesTaxAmountLine: Record "Sales Tax Amount Line"; RoundTax: Option "To Nearest",Up,Down; TotalTaxAmount: Decimal; TaxAreaCode: Code[20]; TaxGroupCode: Code[20])
    // var
    //     RoundedAmount: Decimal;
    //     RoundingError: Decimal;
    // begin
    //     if (RoundTax = RoundTax::"To Nearest") or (TotalTaxAmount = 0) then
    //         exit;
    //     case RoundTax of
    //         RoundTax::Up:
    //             RoundedAmount := Round(TotalTaxAmount, 0.01, '>');
    //         RoundTax::Down:
    //             RoundedAmount := Round(TotalTaxAmount, 0.01, '<');
    //     end;
    //     RoundingError := RoundedAmount - TotalTaxAmount;
    //     with SalesTaxAmountLine do begin
    //         Reset;
    //         SetRange("Tax Area Code for Key", TaxAreaCode);
    //         SetRange("Tax Group Code", TaxGroupCode);
    //         SetRange("Is Report-to Jurisdiction", true);
    //         if FindFirst then begin
    //             Delete;
    //             "Tax Amount" := "Tax Amount" + RoundingError;
    //             "Amount Including Tax" := "Tax Amount" + "Tax Base Amount";
    //             if "Tax Type" = "Tax Type"::"Excise Tax" then
    //                 "Tax %" := 0
    //             else
    //                 if "Tax Base Amount" <> 0 then
    //                     "Tax %" := 100 * ("Amount Including Tax" - "Tax Base Amount") / "Tax Base Amount";
    //             Insert;
    //         end;
    //     end;
    // end;
    // //PRJ-9.SK.1.0 End
    //PPDA.1.0 End


    //PPDA.1.0 Start
    // //PRJ-9.SK.1.0 Start
    // local procedure NS_UpdateSalesTaxForPrepmt(var SalesTaxAmountLine: Record "Sales Tax Amount Line"; var TotalTaxAmount: Decimal; RoundTax: Option "To Nearest",Up,Down)
    // var
    //     GeneralLedgerSetup: Record "General Ledger Setup";
    //     CheckTotalTaxAmount: Decimal;
    //     TaxRoundingDiff: Decimal;
    // begin
    //     if TotalTaxAmount = 0 then
    //         exit;

    //     case RoundTax of
    //         RoundTax::"To Nearest":
    //             CheckTotalTaxAmount := Round(TotalTaxAmount);
    //         RoundTax::Up:
    //             CheckTotalTaxAmount := Round(TotalTaxAmount, 0.01, '>');
    //         RoundTax::Down:
    //             CheckTotalTaxAmount := Round(TotalTaxAmount, 0.01, '<');
    //     end;

    //     if not TempPrepaidSalesLine.IsEmpty then begin
    //         TempPrepaidSalesLine.CalcSums("Amount Including VAT");
    //         TaxRoundingDiff :=
    //            //TempPrepaidSalesLine."Amount Including VAT" - TempPrepaidSalesLine.GetPrepaidSalesAmountInclVAT - //PPNA17.0 Commented due to issue with access of this function
    //            TempPrepaidSalesLine."Amount Including VAT" - NS_LocalGetPrepaidSalesAmountInclVAT(TempPrepaidSalesLine) - //PPNA17.0 Added this line here
    //           (SalesTaxAmountLine."Tax Base Amount" + CheckTotalTaxAmount);
    //         GeneralLedgerSetup.Get;
    //         if Abs(TaxRoundingDiff) <= GeneralLedgerSetup."Amount Rounding Precision" then begin
    //             TotalTaxAmount := TotalTaxAmount + TaxRoundingDiff;
    //             SalesTaxAmountLine."Tax Amount" += TaxRoundingDiff;
    //             SalesTaxAmountLine."Amount Including Tax" += TaxRoundingDiff;
    //             SalesTaxAmountLine.Modify;
    //         end;
    //     end;
    // end;
    // //PRJ-9.SK.1.0 End
    //PPDA.1.0 End

    //TM-10.AM.1.0 start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchRcptLineInsert', '', false, false)]
    local procedure C90OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        PurchRcptLine."NS_Segment Code" := PurchLine."NS_Segment Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePurchInvLineInsert', '', false, false)]
    local procedure C90OnBeforePurchInvLineInsert(VAR PurchInvLine: Record "Purch. Inv. Line"; VAR PurchInvHeader: Record "Purch. Inv. Header"; VAR PurchaseLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    begin
        PurchInvLine."NS_Segment Code" := PurchaseLine."NS_Segment Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 74, 'OnBeforeTransferLineToPurchaseDoc', '', false, false)]
    local procedure C90OnBeforeTransferLineToPurchaseDoc(VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchaseHeader: Record "Purchase Header"; VAR TransferLine: Boolean)
    var
        PurchasLine: Record "Purchase Line";
    begin
        PurchasLine.reset;
        PurchasLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchasLine.SetRange("No.", PurchRcptLine."No.");
        if PurchasLine.FindFirst() then
            PurchasLine."NS_Segment Code" := PurchRcptLine."NS_Segment Code";

    end;



    [EventSubscriber(ObjectType::Codeunit, 1012, 'OnBeforeJobLedgEntryInsert', '', false, false)]
    local procedure C1012OnBeforeJobLedgEntryInsert(VAR JobLedgerEntry: Record "Job Ledger Entry"; JobJournalLine: Record "Job Journal Line")
    begin
        JobLedgerentry."NS_Segment Code" := JobJournalLine."NS_Segment Code";
    end;
    //TM-10.AM.1.0 26NOV2020 start
    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterRecalculateSalesLine', '', false, false)]
    local procedure FlowToCopyDocumentSales(var FromSalesLine: Record "Sales Line"; var ToSalesLine: Record "Sales Line")
    begin
        ToSalesLine."NS_Segment Code" := FromSalesLine."NS_Segment Code";

    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnbeforeInsertToPurchLine', '', false, false)]
    local procedure FlowToCopyDocumentPurchase(FromPurchLine: Record "Purchase Line"; var ToPurchLine: Record "Purchase Line")
    begin
        ToPurchLine."NS_Segment Code" := FromPurchLine."NS_Segment Code";

    end;
    //TM-10.AM.1.0 26NOV2020 End
    //TM-10.AM.1.0 end



    //PPNA17.0 Added Start Actually this code written on the Sales Line table but to accessiblity we cant access it here. So created new one here
    procedure NS_LocalGetPrepaidSalesAmountInclVAT(SalesLine: Record "Sales Line"): Decimal
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetRange("Order No.", SalesLine."Document No.");
        SalesInvoiceLine.SetRange("Order Line No.", SalesLine."Line No.");
        SalesInvoiceLine.CalcSums("Amount Including VAT");
        exit(SalesInvoiceLine."Amount Including VAT");
    end;
    //PPNA17.0 Added End
    //PRJ-490.MS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, 96, 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure C96OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    begin
        PurchQuoteLine."NS_FA Job Usage" := PurchOrderLine."NS_FA Job Usage";
    end;

    [Obsolete('Replaced by Microsoft with event OnAfterPreparePurchase in table "Invoice Posting Buffer"', '22.0')]//PE-129.AS.2.0
    [EventSubscriber(ObjectType::Table, 49, 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure FlowDataToGenJnLine(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var PurchaseLine: Record "Purchase Line")
    begin
        InvoicePostBuffer."NS_FA Job No." := PurchaseLine."NS_FA Job No.";
        InvoicePostBuffer."NS_FA Job Task No." := PurchaseLine."NS_FA Job Task No.";
        InvoicePostBuffer."NS_FA Segment Code" := PurchaseLine."NS_FA Segment Code";
    end;

    //PE-129.AS.2.0 start Add
    [EventSubscriber(ObjectType::Table, 55, 'OnAfterPreparePurchase', '', false, false)]
    local procedure NS_T55FlowDataToGenJnLine(var PurchaseLine: Record "Purchase Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
        InvoicePostingBuffer."NS_FA Job No." := PurchaseLine."NS_FA Job No.";
        InvoicePostingBuffer."NS_FA Job Task No." := PurchaseLine."NS_FA Job Task No.";
        InvoicePostingBuffer."NS_FA Segment Code" := PurchaseLine."NS_FA Segment Code";
    end;
    //PE-129.AS.2.0 end Add

    [Obsolete('Replaced by Microsoft with event OnPostLinesOnBeforeGenJnlLinePost in codeunit 826 "Purch. Post Invoice Events"', '22.0')]//PE-129.AS.2.0
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure DataFlowFromInvPostingBufferToGenJnline(var GenJnlLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        GenJnlLine."NS_FA Job No." := InvoicePostBuffer."NS_FA Job No.";
        GenJnlLine."NS_FA Job Task No." := InvoicePostBuffer."NS_FA Job Task No.";
        GenJnlLine."NS_FA Segment Code" := InvoicePostBuffer."NS_FA Segment Code";
    end;

    //PE-129.AS.2.0 start Add
    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure NS_CU826DataFlowFromInvPostingBufferToGenJnline(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        GenJnlLine."NS_FA Job No." := TempInvoicePostingBuffer."NS_FA Job No.";
        GenJnlLine."NS_FA Job Task No." := TempInvoicePostingBuffer."NS_FA Job Task No.";
        GenJnlLine."NS_FA Segment Code" := TempInvoicePostingBuffer."NS_FA Segment Code";
    end;
    //PE-129.AS.2.0 end Add

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', false, false)]
    local procedure DataFlowFromGenJnlineToGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    var
        VendPostGroup: record "Vendor Posting Group"; //PRJ-1707.NK.1.0 16Nov2022
    begin
        //PRJ-1707.NK.1.0 16Nov2022 Start
        VendPostGroup.Reset();
        VendPostGroup.setrange("Payables Account", GLEntry."G/L Account No.");
        if VendPostGroup.findfirst() then begin
            GLEntry."NS_FA Job No." := '';
            GLEntry."NS_FA Job Task No." := '';
            GLEntry."NS_FA Segment Code" := '';
        end else begin
            //PRJ-1707.NK.1.0 16Nov2022 End
            GLEntry."NS_FA Job No." := GenJournalLine."NS_FA Job No.";
            GLEntry."NS_FA Job Task No." := GenJournalLine."NS_FA Job Task No.";
            GLEntry."NS_FA Segment Code" := GenJournalLine."NS_FA Segment Code";
            //PRJCTPR-112.DK>1.0 12may2023 Start     
            if ((GLEntry."NS_FA Job No." <> '') and (GLEntry.Amount > 0)) then begin
                GLEntry."Job No." := GenJournalLine."NS_FA Job No.";
            end else
                if ((GLEntry."NS_FA Job No." <> '') and (GLEntry.Amount < 0)) then begin
                    GLEntry."Job No." := GenJournalLine."NS_FA Job No.";
                end else
                    GLEntry."Job No." := GenJournalLine."Job No.";
            //PRJCTPR-112.DK>1.0 12may2023 End
        END; //PRJ-1707.NK.1.0 16Nov2022
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostVendorEntry', '', false, false)]
    local procedure FlowFromPOToGenJnLine(var TotalPurchLine: Record "Purchase Line"; var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    begin
        TotalPurchLine.Reset();
        TotalPurchLine.SetRange("Document No.", PurchHeader."No.");
        TotalPurchLine.SetRange("Document Type", PurchHeader."Document Type");
        if TotalPurchLine.FindSet() then
            repeat
                GenJnlLine."NS_FA Job No." := TotalPurchLine."NS_FA Job No.";
                GenJnlLine."NS_FA Job Task No." := TotalPurchLine."NS_FA Job Task No.";
                GenJnlLine."NS_FA Segment Code" := TotalPurchLine."NS_FA Segment Code";
            until TotalPurchLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure FlowToVLE(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."NS_FA Job No." := GenJournalLine."NS_FA Job No.";
        VendorLedgerEntry."NS_FA Job Task No." := GenJournalLine."NS_FA Job Task No.";
        VendorLedgerEntry."NS_FA Segment Code" := GenJournalLine."NS_FA Segment Code";
    end;

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure FlowToDVLEBuff(GenJnlLine: Record "Gen. Journal Line"; var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        DtldCVLedgEntryBuffer."NS_FA Job No." := GenJnlLine."NS_FA Job No.";
        DtldCVLedgEntryBuffer."NS_FA Job Task No." := GenJnlLine."NS_FA Job Task No.";
        DtldCVLedgEntryBuffer."NS_FA Segment Code" := GenJnlLine."NS_FA Segment Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInsertDtldVendLedgEntry', '', false, false)]
    local procedure FlowToDVLE(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        DtldVendLedgEntry."NS_FA Job No." := GenJournalLine."NS_FA Job No.";
        DtldVendLedgEntry."NS_FA Job Task No." := GenJournalLine."NS_FA Job Task No.";
        DtldVendLedgEntry."NS_FA Segment Code" := GenJournalLine."NS_FA Segment Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 5604, 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure FlowtoFALedger(GenJournalLine: Record "Gen. Journal Line"; var FALedgerEntry: Record "FA Ledger Entry")
    begin
        FALedgerEntry."NS_FA Job No." := GenJournalLine."NS_FA Job No.";
        FALedgerEntry."NS_FA Job Task No." := GenJournalLine."NS_FA Job Task No.";
        FALedgerEntry."NS_FA Segment Code" := GenJournalLine."NS_FA Segment Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 5604, 'OnBeforeCopyFromFACard', '', false, false)]
    local procedure FlowToFALedgerFromFA(var FALedgerEntry: Record "FA Ledger Entry"; var FixedAsset: Record "Fixed Asset")
    begin
        if FALedgerEntry."NS_FA Job No." <> '' then
            FALedgerEntry."NS_FA Res. No." := FixedAsset."NS_FA Res. No.";
    end;

    [EventSubscriber(ObjectType::Page, 50, 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure ValidationFA(var Rec: Record "Purchase Header")
    var
        JobsSetup: Record "Jobs Setup";
        Purchline: Record "Purchase Line";
    begin
        Purchline.Reset();
        Purchline.SetRange("Document No.", rec."No.");
        Purchline.SetRange(Type, Purchline.Type::"Fixed Asset");
        Purchline.SetRange("NS_FA Job Usage", true);
        if Purchline.FindSet() then
            repeat
                JobsSetup.Get();
                JobsSetup.TestField("NS_FA Job Template Name");
                JobsSetup.TestField("NS_FA Job Batch Name");
            until Purchline.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterFinalizePosting', '', false, false)]
    local procedure CreateJobJnLine(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")  //PE-43.RM.1.0 24Feb2023
    var
        JobJnline: Record "Job Journal Line";
        JobJnline2: Record "Job Journal Line";
        PurchInvLine: Record "Purch. Inv. Line";
        NS_PurchCrMemoLine: Record "Purch. Cr. Memo Line"; //PE-43.RM.1.0 24Feb2023
        JobJnlineCU: Codeunit "Job Jnl.-Post Line";
        FACard: Record "Fixed Asset";
        Jobsetuprec: Record "Jobs Setup";
    begin
        Jobsetuprec.Get();
        if PurchHeader."Document Type" in [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Return Order"] then begin
            PurchInvLine.Reset();
            PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
            PurchInvLine.SetRange(Type, PurchInvLine.Type::"Fixed Asset");
            //PRJCTPR-26.JS.1.0 09JAN2022 - start
            PurchInvLine.SetRange("NS_FA Job Usage", true);
            PurchInvLine.Setfilter("NS_FA Job No.", '<>%1', '');
            //PRJCTPR-26.JS.1.0 09JAN2022 - end
            if PurchInvLine.FindSet() then
                repeat
                    //if (PurchInvLine."NS_FA Job Usage") then begin   //PRJCTPR-26.JS.1.0 09JAN2022 line commented
                    JobJnline.Init();
                    JobJnline."Journal Template Name" := Jobsetuprec."NS_FA Job Template Name";
                    JobJnline."Journal Batch Name" := Jobsetuprec."NS_FA Job Batch Name";
                    JobJnline."Line No." := GetNextLineNo(JobJnline);
                    JobJnline.validate("Entry Type", JobJnline."Entry Type"::Usage);
                    JobJnline.Validate("Document No.", PurchInvLine."Document No.");
                    JobJnline.Validate("Posting Date", PurchInvLine."Posting Date");
                    JobJnline.validate("Job No.", PurchInvLine."NS_FA Job No.");
                    JobJnline.Validate("Job Task No.", PurchInvLine."NS_FA Job Task No.");
                    JobJnline.Validate("NS_Segment Code", PurchInvLine."NS_FA Segment Code");
                    JobJnline.Validate(Type, JobJnline.Type::Resource);
                    if FACard.Get(PurchInvLine."No.") then
                        JobJnline.Validate("No.", FACard."NS_FA Res. No.");
                    JobJnline.validate(Quantity, PurchInvLine.Quantity);

                    // JobJnline.Validate("Unit Cost", PurchInvLine."Line Amount"); //PE-60.NK.1.0 commented
                    JobJnline.Validate("Unit Cost", PurchInvLine."Unit Cost");//PE-60.NK.1.0 start 15March2023
                    JobJnline.Validate("NS_External Relationship Type", JobJnline."NS_External Relationship Type"::Vendor);
                    JobJnline.Validate("NS_External Relationship Name", PurchInvHeader."Buy-from Vendor Name");
                    JobJnline.Validate("NS_External Relationship No.", PurchInvHeader."Buy-from Vendor No.");
                    JobJnline.Validate("External Document No.", PurchInvHeader."Vendor Invoice No.");
                    JobJnline.Validate("NS_FA Res.No.", PurchInvLine."No.");
                    JobJnline.Insert();
                    //Commit();   //PRJCTPR-26.JS.1.0 09JAN2022 line commented
                    JobJnlineCU.RunWithCheck(JobJnline);
                    Commit();
                    JobJnline2.Reset();
                    JobJnline2.Setrange("Journal Template Name", Jobsetuprec."NS_FA Job Template Name");
                    JobJnline2.setrange("Journal Batch Name", Jobsetuprec."NS_FA Job Batch Name");
                    JobJnline2.Setrange("Line No.", JobJnline."Line No.");
                    if JobJnline2.FindFirst() then
                        JobJnline2.DeleteAll();
                //end;  //PRJCTPR-26.JS.1.0 09JAN2022 line commented
                until PurchInvLine.Next() = 0;
        end;
        //PE-43.RM.1.0 24Feb2023 Start
        if PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" then begin
            NS_PurchCrMemoLine.Reset();
            NS_PurchCrMemoLine.SetRange("Document No.", PurchCrMemoHdr."No.");
            NS_PurchCrMemoLine.SetRange(Type, NS_PurchCrMemoLine.Type::"Fixed Asset");
            NS_PurchCrMemoLine.SetRange("NS_FA Job Usage", true);
            NS_PurchCrMemoLine.Setfilter("NS_FA Job No.", '<>%1', '');
            if NS_PurchCrMemoLine.FindSet() then
                repeat
                    JobJnline.Init();
                    JobJnline."Journal Template Name" := Jobsetuprec."NS_FA Job Template Name";
                    JobJnline."Journal Batch Name" := Jobsetuprec."NS_FA Job Batch Name";
                    JobJnline."Line No." := GetNextLineNo(JobJnline);
                    JobJnline.validate("Entry Type", JobJnline."Entry Type"::Usage);
                    JobJnline.Validate("Document No.", NS_PurchCrMemoLine."Document No.");
                    JobJnline.Validate("Posting Date", NS_PurchCrMemoLine."Posting Date");
                    JobJnline.validate("Job No.", NS_PurchCrMemoLine."NS_FA Job No.");
                    JobJnline.Validate("Job Task No.", NS_PurchCrMemoLine."NS_FA Job Task No.");
                    JobJnline.Validate("NS_Segment Code", NS_PurchCrMemoLine."NS_FA Segment Code");
                    JobJnline.Validate(Type, JobJnline.Type::Resource);
                    if FACard.Get(NS_PurchCrMemoLine."No.") then
                        JobJnline.Validate("No.", FACard."NS_FA Res. No.");
                    JobJnline.validate(Quantity, NS_PurchCrMemoLine.Quantity);
                    // JobJnline.Validate("Unit Cost", NS_PurchCrMemoLine."Line Amount"); //PE-64.RM.1.0 27March2023 commented
                    JobJnline.Validate("Unit Cost", NS_PurchCrMemoLine."Direct Unit Cost"); //PE-64.RM.1.0 27March2023
                    JobJnline.Validate("NS_External Relationship Type", JobJnline."NS_External Relationship Type"::Vendor);
                    JobJnline.Validate("NS_External Relationship Name", PurchCrMemoHdr."Buy-from Vendor Name");
                    JobJnline.Validate("NS_External Relationship No.", PurchCrMemoHdr."Buy-from Vendor No.");
                    JobJnline.Validate("External Document No.", PurchCrMemoHdr."No.");
                    JobJnline.Validate("NS_FA Res.No.", NS_PurchCrMemoLine."No.");
                    JobJnline.Insert();
                    JobJnlineCU.RunWithCheck(JobJnline);
                    Commit();
                    JobJnline2.Reset();
                    JobJnline2.Setrange("Journal Template Name", Jobsetuprec."NS_FA Job Template Name");
                    JobJnline2.setrange("Journal Batch Name", Jobsetuprec."NS_FA Job Batch Name");
                    JobJnline2.Setrange("Line No.", JobJnline."Line No.");
                    if JobJnline2.FindFirst() then
                        JobJnline2.DeleteAll();
                until NS_PurchCrMemoLine.Next() = 0;
        end;
        //PE-43.RM.1.0 24Feb2023 End
    end;

    local procedure GetNextLineNo(JobJnline: Record "Job Journal Line") LineNo: Integer
    var
        Jobsetuprec: Record "Jobs Setup";
    begin
        Jobsetuprec.Get();
        JobJnline.Reset();
        JobJnline.SetRange("Journal Template Name", Jobsetuprec."NS_FA Job Template Name");
        JobJnline.SetRange("Journal Batch Name", Jobsetuprec."NS_FA Job Batch Name");
        if JobJnline.FindLast() then
            LineNo := JobJnline."Line No." + 10000
        else
            LineNo := 10000;
        exit(LineNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1004, 'OnAfterFromJnlLineToLedgEntry', '', false, false)]
    local procedure FlowtoJLE(JobJournalLine: Record "Job Journal Line"; var JobLedgerEntry: Record "Job Ledger Entry")
    begin
        JobLedgerEntry."NS_FA Res.No." := JobJournalLine."NS_FA Res.No.";
        JobLedgerEntry."NS_Segment Code" := JobJournalLine."NS_Segment Code";//PRJ-595.AM
        JobLedgerEntry."NS_Receipt No." := JobJournalLine."NS_Purch. Receipt Doc. No.";//PRJ-1696.GK.1.0 15Dec2022
        JobLedgerEntry."NS_Receipt Line No." := JobJournalLine."NS_Purch. Receipt Line No.";//PRJ-1696.GK.1.0 15Dec2022
        JobLedgerEntry."NS_Union Code" := JobJournalLine."NS_Union Code"; //PRJCTPR-2.RM.1.0 13Dec2022
    end;
    //PRJ-490.MS.1.0 end

    //CTSI-274.MS.1.0 start
    [EventSubscriber(ObjectType::Codeunit, 13, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure C13OnBeforePostGenJnlLine(VAR GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; VAR Posted: Boolean; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")

    var
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
        RevenueRecSummaryTab2: Record NS_RevenueRecSummaryTab;
        Jobsetup: Record "Jobs Setup";
    begin
        if Jobsetup.get then;
        if (Jobsetup."NS_Burden G/L Journal Batch Rev." = GenJournalLine."Journal Batch Name") then begin
            RevenueRecSummaryTab.Reset();
            // RevenueRecSummaryTab.SetRange("NS_Gen.Doc.No.", GenJournalLine."Document No."); //PE-271.PS.2.0 07April2024 Commented 
            RevenueRecSummaryTab.SetRange("NS_Gen.Doc.No.", GenJournalLine."External Document No.");//PE-271.PS.2.0 07April2024
            RevenueRecSummaryTab.SetFilter(NS_Voided, '%1', false);
            //RevenueRecSummaryTab.Setfilter("NS_Job No.", '%1', GenJournalLine."Job No.");   //PE-136.JS.1.0 03Oct2023 add line
            if RevenueRecSummaryTab.FindSet() then begin
                repeat
                    //CTSI-286 rollback
                    // if RevenueRecSummaryTab."Entry Type" = RevenueRecSummaryTab."Entry Type"::Finance then begin
                    //     if RevenueRecSummaryTab.TrueupDoc then begin
                    //         //RevenueRecSummaryTab."True-Up Posted" := true; //CTSI-286 rollback
                    //         RevenueRecSummaryTab."Gen.Doc.No." := ''
                    //     end else begin
                    //         RevenueRecSummaryTab.Posted := true;
                    //        RevenueRecSummaryTab."Gen.Doc.No." := '' 
                    //     end;
                    // end else  
                    //     if RevenueRecSummaryTab."Entry Type" = RevenueRecSummaryTab."Entry Type"::JFW then begin
                    //         RevenueRecSummaryTab.Posted := true;
                    //         //RevenueRecSummaryTab."True-Up Posted" := true;//CTSI-286 rollback
                    //         RevenueRecSummaryTab."Gen.Doc.No." := '';
                    //     end;
                    //CTSI-286 rollback
                    //CTSI-286 start
                    if RevenueRecSummaryTab."NS_True-Up Value" <> 0 then
                        RevenueRecSummaryTab.NS_Posted := true;
                    RevenueRecSummaryTab."NS_Gen.Doc.No." := '';
                    if RevenueRecSummaryTab."NS_Billing Amt. Posted" <> 0 then
                        RevenueRecSummaryTab."NS_Over/Under Billings Posted" := true;//PRJ-830
                    //CTSI-286 end
                    RevenueRecSummaryTab.Modify();
                until RevenueRecSummaryTab.Next() = 0;
            end;
        end;
        //PE-136.JS.1.0 28MAY2024 - Start
        if (Jobsetup."NS_Burden G/L Journal Batch Rev." = GenJournalLine."Journal Batch Name") then begin
            if GenJournalLine."NS_RevRec G/L Reverse EntryNo." <> 0 then begin
                RevenueRecSummaryTab2.Reset();
                RevenueRecSummaryTab2.SetRange(NS_Voided, true);
                RevenueRecSummaryTab2.setrange("NS_Over/Under Billings Posted", true);
                RevenueRecSummaryTab2.setrange("NS_GenJnl Posted Doc. No.", GenJournalLine."NS_RevRec GenJnl Document No.");
                if RevenueRecSummaryTab2.FindSet() then begin
                    repeat
                        RevenueRecSummaryTab2."NS_Reversed Gen. Posted" := true;
                        RevenueRecSummaryTab2.Modify();
                    until RevenueRecSummaryTab2.Next() = 0;
                end else begin
                    RevenueRecSummaryTab2.Reset();
                    RevenueRecSummaryTab2.SetRange(NS_Voided, true);
                    RevenueRecSummaryTab2.setrange(NS_Posted, true);
                    RevenueRecSummaryTab2.setrange("NS_GenJnl Posted Doc. No.", GenJournalLine."NS_RevRec GenJnl Document No.");
                    if RevenueRecSummaryTab2.FindSet() then begin
                        repeat
                            RevenueRecSummaryTab2."NS_Reversed Gen. Posted" := true;
                            RevenueRecSummaryTab2.Modify();
                        until RevenueRecSummaryTab2.Next() = 0;
                    end;
                end;
            end;
        end;
        //PE-136.JS.1.0 PE-136.JS.1.0 28MAY2024 - End
    end;
    //CTSI-274.MS.1.0 end

    //PRJ-817.JS.1.0�04Aug2021-Start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure NS_C90OOnAfterPostPurchaseDoc(CommitIsSupressed: Boolean; PurchCrMemoHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        If PurchLine.FindFirst() then
            repeat
                PurchLine."NS_Work Unit Completed" := 0;
                PurchLine.Modify();
            until PurchLine.Next() = 0;
    end;
    //PRJ-817.JS.1.0�04Aug2021-Start

    //PRJ-939.JS.1.0-Start  29Sep2021
    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnAfterCopyPurchaseLinesToDoc', '', false, false)]
    local procedure NS_C6620OnAfterCopyPurchaseLinesToDoc(var ToPurchaseHeader: Record "Purchase Header"; var FromPurchInvLine: Record "Purch. Inv. Line")
    var
        FromPurchInvHeader: record "Purch. Inv. Header";
        FromPurchaseHeader: record "Purchase Header";
    begin
        if FromPurchInvHeader.get(FromPurchInvLine."Document No.") then begin
            If FromPurchaseHeader.get(ToPurchaseHeader."Document Type", ToPurchaseHeader."No.") then begin
                FromPurchaseHeader."NS_Retention Percent" := FromPurchInvHeader."NS_Retention Percent";
                FromPurchaseHeader."Tax Liable" := FromPurchInvHeader."Tax Liable";
                FromPurchaseHeader."Tax Area Code" := FromPurchInvHeader."Tax Area Code";
                FromPurchaseHeader.modify();
            end;
        end;
    end;
    //PRJ-939.JS.1.0-end 29Sep2021       

    //PRJ-1144.JS.1.0  01FEB2022 - Start

    [EventSubscriber(ObjectType::Codeunit, 951, 'OnAfterReject', '', false, false)]
    local procedure NS_C951OnAfterReject(var TimeSheetLine: Record "Time Sheet Line")
    var
        NSCrewTimeSheetCustLine: Record NS_TimeSheetLineCustom;
    begin
        if ((TimeSheetLine."NS_Crew Time Unique Line ID" <> '') and (TimeSheetLine."NS_Ref Customize TimesheetNo." <> '')) then begin
            NSCrewTimeSheetCustLine.Reset();
            NSCrewTimeSheetCustLine.SetRange("NS_TimeSheetNo.", TimeSheetLine."NS_Ref Customize TimesheetNo.");
            NSCrewTimeSheetCustLine.SetRange("NS_Unique Line ID", TimeSheetLine."NS_Crew Time Unique Line ID");
            if NSCrewTimeSheetCustLine.findfirst() then begin
                NSCrewTimeSheetCustLine.NS_Status := NSCrewTimeSheetCustLine.NS_Status::Rejected;
                NSCrewTimeSheetCustLine."NS_Rejected Remark" := TimeSheetLine."NS_Rejected Remark";
                NSCrewTimeSheetCustLine.modify();
            end
        end

    end;

    [EventSubscriber(ObjectType::Codeunit, 951, 'OnAfterReopenApproved', '', false, false)]
    local procedure NS_C951OnAfterReopenApproved(var TimeSheetLine: Record "Time Sheet Line")
    var
        NSCrewTimeSheetCustLine: Record NS_TimeSheetLineCustom;
    begin
        if ((TimeSheetLine."NS_Crew Time Unique Line ID" <> '') and (TimeSheetLine."NS_Ref Customize TimesheetNo." <> '')) then begin
            NSCrewTimeSheetCustLine.Reset();
            NSCrewTimeSheetCustLine.SetRange("NS_TimeSheetNo.", TimeSheetLine."NS_Ref Customize TimesheetNo.");
            NSCrewTimeSheetCustLine.SetRange("NS_Unique Line ID", TimeSheetLine."NS_Crew Time Unique Line ID");
            if NSCrewTimeSheetCustLine.findfirst() then begin
                NSCrewTimeSheetCustLine.NS_Status := NSCrewTimeSheetCustLine.NS_Status::Submitted;
                NSCrewTimeSheetCustLine.modify();
            end
        end
    end;
    //PRJ-1144.JS.1.0  01FEB2022 - end 

    //PRJ-1358.GK.1.0 12May2022 start
    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnAfterCreateSalesLine', '', false, false)]
    local procedure NS_OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; Job: Record Job; JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine.Validate("Tax Group Code", Job."NS_Tax Group Code New");
        SalesLine.Modify();
    end;
    //PRJ-1358.GK.1.0 12May2022 end
    //PRJ-1523.GK.1.0 28July2022 start
    [EventSubscriber(ObjectType::Table, 21, 'OnbeforeModifyEvent', '', false, false)]
    local procedure NS_CLEOnAfterModifyEvent(var Rec: Record "Cust. Ledger Entry")
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
        JobSetup: Record "Jobs Setup";
        NSSalesCrMemo: Record "Sales Cr.Memo Header"; //PRJCTPR-114.Dk.1.0 25may2023
                                                      //OldCustLedgerEntry: Record "Cust. Ledger Entry";//PRJCTPR-214.VC.1.2 //PRJCTPR-242.PS.1.0 08Dec2023 Start Commented 
    begin
        if SalesRecSetup.get() then
            if not SalesRecSetup."NS_Sales Retention Inactive" then
                if JobSetup.get() then
                    if (JobSetup."NS_Retention Receivable Ledger" <> '') and (Rec."NS_Retention Ledger Code" = JobSetup."NS_Retention Receivable Ledger") then begin
                        if (rec."Document Type" = Rec."Document Type"::Invoice) AND (Rec."NS_Retention Document" = False) then //PRJCTPR-9.PS.1.0 28March2023  //PRJCTPR-114.DK.1.0 25may2023 Line commented
                            Rec.Positive := true; //PRJCTPR-9.PS.1.0 28March2023
                    end;
        //PRJCTPR-65.NK.1.0 start 24feb2023
        //PRJCTPR-114.Dk.1.0 25may2023 Start   
        //PRJCTPR-214.VC.1.0 Comment Start   
        //PRJCTPR-242.PS.1.0 08Dec2023 Start UnCommented    
        //PRJCTPR-214.AS.1.0 14DEC2023 START comment
        // if (Rec."Document Type" = Rec."Document Type"::"Credit Memo") and (Rec."Remaining Amount" <> 0) and (Rec."NS_Retention Ledger Code" = 'RETENTION') and (Rec."NS_Job No." <> '') then begin
        //     if NSSalesCrMemo.Get(Rec."Document No.") then
        //         if NSSalesCrMemo."NS_From Progress Billing No." <> '' then
        //             Rec.Open := false;
        // end;
        //PRJCTPR-214.AS.1.0 14DEC2023 END comment
        //PRJCTPR-214.VC.1.0 Comment End
        //PRJCTPR-242.PS.1.0 08Dec2023 End UnCommented

        //PRJCTPR-214.AS.1.0 14DEC2023 START Add
        Rec.CalcFields("Remaining Amount");
        if (Rec."Document Type" = Rec."Document Type"::"Credit Memo") and (Rec."Remaining Amount" = 0) and (Rec."NS_Retention Ledger Code" = 'RETENTION') and (Rec."NS_Job No." <> '') then begin
            if NSSalesCrMemo.Get(Rec."Document No.") then
                if NSSalesCrMemo."NS_From Progress Billing No." <> '' then
                    Rec.Open := false;
        end;
        //PRJCTPR-214.AS.1.0 14DEC2023 END Add

        //PRJCTPR-242.PS.1.0 08Dec2023 Start Commented 
        //PRJCTPR-214.VC.1.2 Start
        // IF OldCustLedgerEntry.Get(Rec."Entry No.") THEN Begin
        //     IF OldCustLedgerEntry."NS_Retention Ledger Code" <> SalesRecSetup."NS_Normal Customer Ledger No." then
        //         Rec.CalcFields("Remaining Amount");
        //     If Rec."Remaining Amount" = 0 then
        //         Rec.Open := Rec."Remaining Amount" <> 0;
        // end;
        //PRJCTPR-214.VC.1.2 End
        //PRJCTPR-242.PS.1.0 08Dec2023 End Commented 
        //PRJCTPR-114.Dk.1.0 25may2023 End 
        //PRJCTPR-65.NK.1.0 end 24feb2023
    end;
    //PRJCTPR-207.VC.1.0 Start
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnBeforeCreateCreditMemoOnAction', '', false, false)]
    local procedure NS_CreateCorrectiveCreditMemo(var IsHandled: Boolean; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        NS_InvoicePartiallyPaidMsg: Label 'Invoice %1 is partially paid or credited. The corrective credit memo may not be fully closed by the invoice. As the Progress Billing No. exist on posted sales invoice %2.';
        //NS_RetentionMsg: Label 'Invoice %1 is partially paid or credited. The corrective credit memo may not be fully closed by the invoice. As the Retention Percent  %2 exist on posted sales invoice. Please use "Create Corrective Retention Credit Memo" function in this case.';//PRJCTPR-207.VC.1.1  //PE-265.DK.1.0.18March2024 Modify the Message line commented
        NS_RetentionMsg: Label 'Invoice %1 is partially paid or credited. The corrective credit memo may not be fully closed by the invoice. As the Retention Percent %2 exists on the posted sales invoice. Please use the "Create Corrective Credit Memo with Retention" function in this case.'; //PE-265.JS line added
    begin
        If SalesInvoiceHeader."NS_From Progress Billing No." <> '' then begin
            Error(NS_InvoicePartiallyPaidMsg, SalesInvoiceHeader."No.", SalesInvoiceHeader."No.");
            IsHandled := true;
        End;
        //PRJCTPR-207.VC.1.1 Start
        If SalesInvoiceHeader."NS_Retention Percent" <> 0 then begin
            Error(NS_RetentionMsg, SalesInvoiceHeader."No.", SalesInvoiceHeader."NS_Retention Percent");
            IsHandled := true;
            //PRJCTPR-207.VC.1.1 End                
        end;
    end;
    //PRJCTPR-207.VC.1.0 End
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnAfterCreateCorrectiveSalesCrMemo', '', false, false)]
    local procedure OnAfterCreateCorrectiveSalesCrMemo(SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; var CancellingOnly: Boolean);

    var
        ReleaseMgmtCU: Codeunit "Release Sales Document";
        NSSalesRecSetup: Record "Sales & Receivables Setup";  //PE-302.JS.1.0 12July2024
    begin
        //Message('%1..%2', SalesHeader."Document Type", SalesHeader."No.");
        //PE-302.JS.1.0 12July2024 - Start
        if NSSalesRecSetup.get() then;
        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
        SalesHeader."Applies-to Doc. No." := SalesInvoiceHeader."No.";
        if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
            if ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") and (SalesHeader."NS_Retention Percent" <> 0)
                and (SalesHeader."NS_From Progress Billing No." <> '') and (SalesHeader."NS_Retention Document" = false)) then begin
                SalesHeader."NS_AppliesToDocument Type" := SalesHeader."NS_AppliesToDocument Type"::Invoice;
                SalesHeader."NS_AppliesToDocument No." := SalesInvoiceHeader."No.";
                SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::" ";
                SalesHeader."Applies-to Doc. No." := '';
            end;
        end;
        ReleaseMgmtCU.PerformManualRelease(SalesHeader);
        //PE-302.JS.1.0 12July2024 - end
    end;
    //PRJ-1523.GK.1.0 28July2022 end

    //PRJ-1611.AS.1.0 START
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnAfterCreateCopyDocument', '', false, false)]
    local procedure NS_OnAfterCreateCopyDocument(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        salLine: Record "Sales Line";
    begin
        salLine.Reset();
        salLine.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        salLine.SetRange("Document No.", SalesHeader."No.");
        if salLine.FindSet() then
            repeat
                if salLine."Job No." = '' then begin
                    salLine."Job Contract Entry No." := 0;
                    salLine.Modify();
                end;
            until salLine.Next() = 0;
    end;
    //PRJ-1611.AS.1.0 END

    //PRJCTPR-26.JS.1.0 - start
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]  //PRJCTPR-26.JS.1.0 09JAN2022 //PE-43.JS.1.0
    local Procedure NS_OnBeforeCreateFAJobJnlLine(var PurchaseHeader: Record "Purchase Header")
    var
        NSPurchLine: Record "Purchase Line";
        NSJOb: Record Job; //PE-60.NK.1.0 Start15March2023
        NSJobSetup: Record "Jobs Setup";//PE-81.Dk.1.0 04may2023
    Begin
        if PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"] then begin
            NSPurchLine.Reset();
            NSPurchLine.Setrange("Document Type", PurchaseHeader."Document Type");
            NSPurchLine.Setrange("Document No.", PurchaseHeader."No.");
            NSPurchLine.Setrange(Type, NSPurchLine.Type::"Fixed Asset");
            if NSPurchLine.Findfirst() then
                repeat
                    if NSPurchLine."NS_FA Job Usage" = true then begin
                        NSPurchLine.Testfield("NS_FA Job No.");
                        NSPurchLine.Testfield("NS_FA Job Task No.");
                        //NSPurchLine.Testfield("NS_FA Segment Code");//PE-81.Dk.1.0 04may2023
                    end;
                    //PE-81.Dk.1.0 Start 04may2023
                    if NSJobSetup.Get() then
                        if NSJobSetup."NS_FA Job Segment Mandatory" = true then
                            NSPurchLine.Testfield("NS_FA Segment Code");
                //PE-81.Dk.1.0 End 04may2023
                until NSPurchLine.next() = 0;
        end;
        //PE-60.NK.1.0 Start 15march2023
        if PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::"Credit Memo", PurchaseHeader."Document Type"::"Return Order"] then begin
            NSPurchLine.Reset();
            NSPurchLine.Setrange("Document Type", PurchaseHeader."Document Type");
            NSPurchLine.Setrange("Document No.", PurchaseHeader."No.");
            NSPurchLine.Setrange(Type, NSPurchLine.Type::"Fixed Asset");
            if NSPurchLine.Findfirst() then
                repeat
                    if NSPurchLine."NS_FA Job Usage" = true then begin
                        if NSPurchLine."NS_FA Job No." <> '' then begin
                            NSJOb.Reset();
                            NSJOb.SetRange("No.", NSPurchLine."NS_FA Job No.");
                            if NSJOb.FindFirst() then begin
                                if NSJOb.Status <> NSJOb.Status::Open then
                                    Error('Job Status should be Open');
                            end;
                        end;
                    end
                until NSPurchLine.next() = 0;
        end;
        //PE-60.NK.1.0 end  15macrh2023

    End;
    //PRJCTPR-26.JS.1.0 - end
    //PE-61.NK.1.0 21Mar2023 - start
    [EventSubscriber(ObjectType::Report, 952, 'OnAfterTransferTimeSheetDetailToJobJnlLine', '', false, false)]
    local Procedure NS_OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail"; JobJournalBatch: Record "Job Journal Batch"; var LineNo: Integer)
    var
    Begin
        //PE-68 Dk.1.0 10April2023 Start
        // JobJournalLine."NS_Skill Class" := TempTimeSheetLine."NS_Skill Class";
        JobJournalLine."NS_Skill Class New" := TempTimeSheetLine."NS_Skill Class New";
        //PE-68 DK.1.0 10April2023 End
    end;
    //PE-61.NK.1.0 21Mar2023 - End

    // PRJCTPR-17.PS.1.0 28March2023 Start

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure PostedSalesInvoiceOnBeforeActionEvent(var Rec: Record "Sales Invoice Header")
    var
    begin
        if Rec."NS_Progress Billing Document" = true then
            Error('This Invoice is created from Progress billing, to correct this invoice please perform the reversal from Progress billing page by creating new  version of Progress Billing');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", 'OnBeforeActionEvent', 'CorrectInvoice', false, false)]
    local procedure PostedSalesInvoicesOnBeforeActionEvent(var Rec: Record "Sales Invoice Header")
    begin
        if Rec."NS_Progress Billing Document" = true then
            Error('This Invoice is created from Progress billing, to correct this invoice please perform the reversal from Progress billing page by creating new  version of Progress Billing');
    end;
    // PRJCTPR-17.PS.1.0 28March2023 End
    //PE-99.NC.1.0 29May2023 Start
    [EventSubscriber(ObjectType::Codeunit, 802, 'OnAfterGetAddress', '', false, false)]
    local procedure NS_OnAfterGetAddress(TableID: Integer; RecPosition: Text; var Parameters: array[12] of Text[100]; var RecordRef: RecordRef)
    begin
        if TableID = 167 then
            if ((format(RecordRef.Field(14021100)) <> '') and ((format(RecordRef.Field(14021102)) <> '')) and ((format(RecordRef.Field(14021103)) <> '')) and ((format(RecordRef.Field(14021105)) <> ''))) then
                NS_SetParameters(RecordRef, Parameters, 14021100, 14021101, 14021102, 14021103, 14021105);
    end;

    local procedure NS_SetParameters(var RecordRef: RecordRef; var Parameters: array[12] of Text[100]; AddressFieldNo: Integer; CityFieldNo: Integer; CountyFieldNo: Integer; PostCodeFieldNo: Integer; CountryCodeFieldNo: Integer)
    var
        FieldRef: FieldRef;
    begin
        FieldRef := RecordRef.Field(AddressFieldNo);
        Parameters[1] := Format(FieldRef);
        FieldRef := RecordRef.Field(CityFieldNo);
        Parameters[2] := Format(FieldRef);
        FieldRef := RecordRef.Field(CountyFieldNo);
        Parameters[3] := Format(FieldRef);
        FieldRef := RecordRef.Field(PostCodeFieldNo);
        Parameters[4] := Format(FieldRef);
        FieldRef := RecordRef.Field(CountryCodeFieldNo);
        Parameters[5] := Format(FieldRef);
    end;
    //PE-99.NC.1.0 29May2023 End
    //PRJCTPR-191.DK.1.0 25Sep23 Start
    [EventSubscriber(ObjectType::Codeunit, 1006, 'OnCopyJobPlanningLinesOnBeforeTargetJobPlanningLineInsert', '', true, true)]
    local procedure NSOnCopyJobPlanningLinesOnBeforeTargetJobPlanningLineInsert(var TargetJobPlanningLine: Record "Job Planning Line"; SourceJobPlanningLine: Record "Job Planning Line")
    begin
        TargetJobPlanningLine."NS_ProgessBillingNo" := '';
    end;
    //PRJCTPR-191.DK.1.0 25Sep23 End

    //PRJCTPR-199.JS.1.0 20NOV2023 - Start
    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnAfterCreateSalesLine', '', false, false)]
    local procedure NS_C1002OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Job: Record Job; var JobPlanningLine: Record "Job Planning Line")
    var
        NS_JobSetup: Record "Jobs Setup";
        NS_Jobs: Record job;
        NS_JobTesks: Record "Job Task";
        NS_BillingHeader: Record "NS_Progress Billing Header";
        NSDimBufferTemp: record "Dimension Buffer" temporary;
        NSItemRec: record item;
        NSGLRec: record "G/L Account";
        NSResource: record resource;
        NSDefaultDim: record "Default Dimension";
        NSJobTaskDimension: record "Job Task Dimension";
        NSDimMgt: codeunit DimensionManagement;
        NSGLedgSetup: record "General Ledger Setup";
    begin
        clear(NSDimBufferTemp);
        if NS_JobSetup.get() then;
        if NSGLedgSetup.get() then;
        if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
            if (SalesLine."Job No." <> '') and (SalesLine."Job Task No." <> '') then begin
                NSJobTaskDimension.reset();
                NSJobTaskDimension.setrange("Job No.", SalesLine."Job No.");
                NSJobTaskDimension.setrange("Job Task No.", SalesLine."Job Task No.");
                if NSJobTaskDimension.findset() then
                    repeat
                        NSDimBufferTemp.Init();
                        NSDimBufferTemp."Table ID" := 37;
                        NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                        NSDimBufferTemp.Insert();
                        NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                        NSDimBufferTemp.Modify();
                    until NSJobTaskDimension.next = 0;
            end;
            case SalesLine.Type of
                SalesLine.Type::Item:
                    begin
                        if NSItemRec.get(SalesLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 27);
                            NSDefaultDim.setrange("No.", SalesLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 37);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 37;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
                SalesLine.Type::Resource:
                    begin
                        if NSResource.get(SalesLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 156);
                            NSDefaultDim.setrange("No.", SalesLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 37);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 37;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
                SalesLine.Type::"G/L Account":
                    begin
                        if NSGLRec.get(SalesLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 15);
                            NSDefaultDim.setrange("No.", SalesLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 37);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 37;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
            end;
            NSDimBufferTemp.reset();
            if NSDimBufferTemp.findset() then
                repeat
                    if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                        SalesLine.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                    if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                        SalesLine.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                until NSDimBufferTemp.next = 0;

            if SalesLine."Line No." <> 0 then begin
                SalesLine."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                SalesLine.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 333, 'OnAfterPurchOrderLineInsert', '', false, false)]
    local procedure NS_C333OnAfterPurchOrderLineInsert(var PurchOrderLine: Record "Purchase Line")
    var
        NS_JobSetup: Record "Jobs Setup";
        NS_Jobs: Record job;
        NS_JobTesks: Record "Job Task";
        NS_BillingHeader: Record "NS_Progress Billing Header";
        NSDimBufferTemp: record "Dimension Buffer" temporary;
        NSItemRec: record item;
        NSGLRec: record "G/L Account";
        NSResource: record resource;
        NSDefaultDim: record "Default Dimension";
        NSJobTaskDimension: record "Job Task Dimension";
        NSDimMgt: codeunit DimensionManagement;
        NSGLedgSetup: record "General Ledger Setup";
    begin
        clear(NSDimBufferTemp);
        if NSGLedgSetup.get() then;
        if NS_JobSetup.get() then;
        if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
            if (PurchOrderLine."Job No." <> '') and (PurchOrderLine."Job Task No." <> '') then begin
                NSJobTaskDimension.reset();
                NSJobTaskDimension.setrange("Job No.", PurchOrderLine."Job No.");
                NSJobTaskDimension.setrange("Job Task No.", PurchOrderLine."Job Task No.");
                if NSJobTaskDimension.findset() then
                    repeat
                        NSDimBufferTemp.Init();
                        NSDimBufferTemp."Table ID" := 39;
                        NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                        NSDimBufferTemp.Insert();
                        NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                        NSDimBufferTemp.Modify();
                    until NSJobTaskDimension.next = 0;
            end;
            case PurchOrderLine.Type of
                PurchOrderLine.Type::Item:
                    begin
                        if NSItemRec.get(PurchOrderLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 27);
                            NSDefaultDim.setrange("No.", PurchOrderLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 39);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 39;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
                PurchOrderLine.Type::Resource:
                    begin
                        if NSResource.get(PurchOrderLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 156);
                            NSDefaultDim.setrange("No.", PurchOrderLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 39);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 39;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
                PurchOrderLine.Type::"G/L Account":
                    begin
                        if NSGLRec.get(PurchOrderLine."No.") then begin
                            NSDefaultDim.Reset();
                            NSDefaultDim.setrange("Table ID", 15);
                            NSDefaultDim.setrange("No.", PurchOrderLine."No.");
                            NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                            if NSDefaultDim.findset() then
                                repeat
                                    NSDimBufferTemp.reset();
                                    NSDimBufferTemp.setrange("Table ID", 39);
                                    NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                    if not NSDimBufferTemp.findfirst() then begin
                                        NSDimBufferTemp.Init();
                                        NSDimBufferTemp."Table ID" := 39;
                                        NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                        NSDimBufferTemp.Insert();
                                        NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                        NSDimBufferTemp.Modify();
                                    end;
                                until NSDefaultDim.next = 0;
                        end;
                    end;
            end;
            NSDimBufferTemp.reset();
            if NSDimBufferTemp.findset() then
                repeat
                    if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                        PurchOrderLine.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                    if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                        PurchOrderLine.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                until NSDimBufferTemp.next = 0;

            if PurchOrderLine."Line No." <> 0 then begin
                PurchOrderLine."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                PurchOrderLine.Modify();
            end;
        end;
    end;
    //PRJCTPR-199.JS.1.0 20NOV2023 - end

    //PRJCTPR-252.HS.1.0 19Dec2023 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", 'OnBeforePurchInvHeaderModify', '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header");
    begin
        PurchInvHeader."NS_Draw No." := PurchInvHeaderRec."NS_Draw No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Inv. Header - Edit", 'OnRunOnBeforeAssignValues', '', false, false)]
    local procedure OnRunOnBeforeAssignValues(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceHeaderRec: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader."NS_Draw No." := SalesInvoiceHeaderRec."NS_Draw No.";
    end;

    //PRJCTPR-252.HS.1.0 19Dec2023 End

    //PRJCTPR-296.HS.1.0 17Jan2024 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Explode BOM", 'OnBeforeInsertExplodedPurchLine', '', false, false)]
    local procedure OnBeforeInsertExplodedPurchLine(var ToPurchaseLine: Record "Purchase Line"; PurchaseLine: Record "Purchase Line"; FromBOMComp: Record "BOM Component")
    begin
        ToPurchaseLine.Validate("Job Task No.", PurchaseLine."Job Task No.");
    end;
    //PRJCTPR-296.HS.1.0 17Jan2024 End
    //PRJCTPR-320.NC.1.0 09Feb2024 Start
    // [EventSubscriber(ObjectType::Codeunit, 57, 'OnAfterCalculateSalesSubPageTotals', '', false, false)]
    // local procedure NSOnAfterCalculateSalesSubPageTotals(var TotalSalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var VATAmount: Decimal; var InvoiceDiscountAmount: Decimal; var InvoiceDiscountPct: Decimal; var TotalSalesLine2: Record "Sales Line")
    // var
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     if NS_JobsSetup.Get() then;
    //     if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
    //         if TotalSalesHeader."NS_Multiple Retention on Lines" then begin
    //             Clear(VATAmount);
    //             TotalSalesLine2.CalcSums("NS_Retention Amount");
    //             VATAmount += (Abs(Abs(TotalSalesLine2."Amount" - TotalSalesLine2."NS_Retention Amount") - (TotalSalesLine2."Amount Including VAT")));
    //         end;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 57, 'OnAfterCalculatePostedSalesInvoiceTotals', '', false, false)]
    // local procedure NS_OnAfterCalculatePostedSalesInvoiceTotals(var SalesInvoiceHeader: Record "Sales Invoice Header"; SalesInvoiceLine: Record "Sales Invoice Line"; var VATAmount: Decimal)
    // var
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     if SalesInvoiceHeader."NS_Multiple Retention on Lines" = false then
    //         exit;
    //     if NS_JobsSetup.Get() then;
    //     if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then
    //         VATAmount := SalesInvoiceHeader."Amount Including VAT" - (SalesInvoiceHeader.Amount - SalesInvoiceHeader."NS_Retention Amount");
    // end;

    // local procedure NS_MultipleRetentiontTaxBaseAmt(var NS_TaxBaseAmount: Decimal; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TempSalesTaxLine: Record "Sales Tax Amount Line")
    // var
    //     NS_JobsSetup: Record "Jobs Setup";
    // begin
    //     if NS_JobsSetup.Get() then;
    //     if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then begin
    //         if SalesHeader."NS_Multiple Retention on Lines" = false then
    //             exit;
    //         if SalesLine."VAT %" <> 0 then
    //             NS_TaxBaseAmount := TempSalesTaxLine."Tax Base Amount" - SalesLine."NS_Retention Amount"
    //         else
    //             NS_TaxBaseAmount := TempSalesTaxLine."Tax Base Amount";
    //     end;
    // end;
    //PRJCTPR-320.NC.1.0 09Feb2024 End
    //PE-260.JS.1.0 04MAR2024 - Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterPurchRcptLineSetFilters', '', false, false)]
    local procedure NS_C74OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchaseHeader: Record "Purchase Header")
    begin
        if (PurchaseHeader."NS_Job No." <> '') and (PurchaseHeader."NS_Multiple Jobs On Lines" = false) then
            PurchRcptLine.setrange("Job No.", PurchaseHeader."NS_Job No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnBeforeInsertInvoiceLineFromReceiptLine', '', false, false)]
    local procedure NS_C74OnBeforeInsertInvoiceLineFromReceiptLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchRcptLine2: Record "Purch. Rcpt. Line"; PurchHeader: Record "Purchase Header"; TransferLine: Boolean; var PrepmtAmtToDeductRounding: Decimal; var IsHandled: Boolean)
    begin
        if (PurchHeader."NS_Job No." <> '') and (PurchHeader."NS_Multiple Jobs on Lines" = false) then
            if PurchHeader."NS_Job No." <> PurchRcptLine2."Job No." then
                error('Please enable "Multiple Jobs on Lines" in %1 no. %2 on "Purchase %3 Header"', PurchHeader."Document Type", PurchHeader."No.", PurchHeader."Document Type");
    end;
    //PE-260.JS.1.0 04MAR2024 - end
    //FGH-163.AS.29052024 START //PE-307.JS.1.0
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeNS_OnBeforeCheckSalesDocNoIsNotUsed(var DocType: Option; var DocNo: Code[20]; var IsHandled: Boolean; var IsHandle: Boolean)
    begin
    end;
    //FGH-163.AS.29052024 END //PE-307.JS.1.0

    //PE-302.JS.1.0 29MAY24-Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', true, true)]
    local procedure NS_C12OnAfterInitCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        RecCust: Record Customer;
        NSSalesRecSetup: Record "Sales & Receivables Setup";
    begin
        // if NSSalesRecSetup.get() then begin
        //     if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
        //         if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then begin
        //             CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
        //             CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
        //         end;
        //     end;
        // end;
    end;

    // We need this event in upcoming version 
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsertInclPreviewMode', '', true, true)]
    // local procedure NS_C12OnAfterCustLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     RecCust: Record Customer;
    //     NSSalesRecSetup: Record "Sales & Receivables Setup";
    // begin
    //     if NSSalesRecSetup.get() then begin
    //         if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
    //             if GenJournalLine."NS_Retention Percent" <> 0 then begin
    //                 CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
    //                 CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
    //                 CustLedgerEntry.Modify();
    //             end;
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCustLedgEntryInsert', '', true, true)]
    local procedure NS_C12OnAfterCustLedgEntryInsert(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        RecCust: Record Customer;
        NSSalesRecSetup: Record "Sales & Receivables Setup";
    begin
        if NSSalesRecSetup.get() then begin
            if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
                if GenJournalLine."NS_Retention Percent" <> 0 then begin
                    if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then begin
                        CustLedgerEntry."NS_AppliesToDocument Type" := GenJournalLine."NS_AppliesToDocument Type";
                        CustLedgerEntry."NS_AppliesToDocument No." := GenJournalLine."NS_AppliesToDocument No.";
                        CustLedgerEntry.Modify();
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Correct Posted Sales Invoice", 'OnAfterCreateCorrectiveSalesCrMemo', '', true, true)]
    local procedure NS_C1303OnAfterCreateCorrectiveSalesCrMemo(SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; var CancellingOnly: Boolean)
    var
        NSSalesRecSetup: Record "Sales & Receivables Setup";
        ReleaseMgmtCU: Codeunit "Release Sales Document";
    begin
        // SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
        // SalesHeader."Applies-to Doc. No." := SalesInvoiceHeader."No.";
        // if NSSalesRecSetup.get() then begin
        //     if NSSalesRecSetup."NS_AutoApplySCM After Posting" = true then begin
        //         if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
        //             if ((SalesHeader."NS_From Progress Billing No." <> '') and (SalesHeader."NS_Retention Percent" <> 0) and
        //                 (SalesHeader."NS_Retention Document" = false)) then begin
        //                 SalesHeader."NS_AppliesToDocument Type" := SalesHeader."Applies-to Doc. Type"::Invoice;  //PE-302.JS.1.0 12July2024
        //                 SalesHeader."NS_AppliesToDocument No." := SalesInvoiceHeader."No.";
        //                 SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::" ";
        //                 SalesHeader."Applies-to Doc. No." := '';
        //             end;
        //         end;
        //     end;
        // end;
        // ReleaseMgmtCU.PerformManualRelease(SalesHeader);
    end;
    //PE-302.JS.1.0 29MAY24-Start

    //PE-323.AT.1.0 13Jun24 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Item", 'OnAfterCopyItem', '', false, false)]
    local procedure OnAfterCopyItem(SourceItem: Record Item; var CopyItemBuffer: Record "Copy Item Buffer"; var TargetItem: Record Item)
    var
        NSLinkedRes: Record "NS_Linked Resources";
        NSLinkedRes1: Record "NS_Linked Resources";
    begin
        if not TargetItem.IsEmpty then begin
            NSLinkedRes.SetRange("NS_Item No.", SourceItem."No.");
            if NSLinkedRes.FindSet() then
                repeat
                    NSLinkedRes1.Init();
                    NSLinkedRes1."NS_Item No." := TargetItem."No.";
                    NSLinkedRes1."NS_Linked Resource" := NSLinkedRes."NS_Linked Resource";
                    NSLinkedRes1."NS_Labor Hr. per Qty" := NSLinkedRes."NS_Labor Hr. per Qty";
                    NSLinkedRes1.NS_Default := NSLinkedRes.NS_Default;
                    NSLinkedRes1.Insert();
                until NSLinkedRes.Next() = 0;
        end;
    end;
    //PE-323.AT.1.0 13Jun24 end
}

