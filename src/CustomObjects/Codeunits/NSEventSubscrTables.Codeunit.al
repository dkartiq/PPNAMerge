codeunit 14021106 "NS_Event Subscr. Tables"
{
    // version SPLN1.00
    //PRJ-40.SK.1.0 Validate "Pay-to-Vendor No."
    //PRJ-71.SK.1.0 Added Events in CAL then generate sybbols here
    //PRJ-121.SK.1.0 BLocked code //PRJ-107.VT.1.0 //PRJ-119.VT.1.0
    //PRJ-145.SK.1.0 Blocked some code and added and event subscriber
    //PRJ-163.SK.1.0 Added code for bypassing standard error of timesheet
    //PRJ-196 VT 08-04-20 Event,Function, Code added and code removed
    //PRJ-197.AS.1.0 - 15APRIL2020 : Added function T21OnBeforeDrillDownEntriesRLCCode()
    //PRJ-230.AS.1.0 - 21APRIL2020 : Added code in function T81OnAfterValidateAccountType() to Add Retentionledger for customer also;
    //PRJ-232 VT1.0 16-04-20 Code Added and Commented
    //PRJ-211 VT1.0 20-04-20 Code Added
    //PRJ-212 VT1.0 22-04-20 Event and code added
    //PRJ-249 AS1.0 29-04-20 - Code Added in function T39OnAfterAssignFieldsForNo()
    //PRJ-268 VT1.0 18-05-20 Code Commented
    //PRJ-284.MS.1.0 Update JMP doc. no on PO Line after validate GBPG on header
    //PPAL-73.SK.1.0 - 12AUG2020 - Added code to avoid calling of "SetVentorItemNo" function in case of if "Type=Rescource".
    //PRJ-333.AS.1.0 27 JULY 2020 Added Event "T37UpdateGPPB" in Sales Line Table to Update GPPG
    //PRJ-395.MS.1.0 added code for dim flow from Job to Plng line
    //PRJ-394.MS.1.0 update GBPG when create planning lines 
    //PPAL-128.AM.1.0 19NOV2020 | Added event to update Quantity fields & Contract Line field while creating Job from Quote.
    //PRJ-419.MS.1.0 added code for adding only posting line on forecast   
    //PRJ-415.MS.1.0 flow of salesperson from Job to SI 
    //PRJ-395.MS.1.0 added code for dim flow from Job to Plng line 
    //PRJ-452.AM.1.0 | Added Event to validate Qty Fields & Contract line value on Quantity Validation.
    //PRJ-504.MS.1.0 new changes for update Total cost (LCY) in JLE 
    //PRJ-522.MS.1.0 Added new code for type ledger
    //JD-48.AS.1.0 //PRJ-419.MS.1.0 Taken reference of this tag code. Added code for adding only posting line on forecast by Segment 
    //PRJ-458.MS.1.0 new changes for update burden amount on total cost 
    //PRJ-470.MS.1.0 added code for modifying the posting date when type is resource
    //PRJ-440.MS.1.0 added code for selecting type all on job price item without item no.s
    //PRJ-488.MS.1.0 new changes for GBPG for changing in vendor no. on PO and PI
    //PRJ-458.MS.1.0 new changes for update burden amount on total cost 
    //PRJ-613 N.S.1.0 remove error divide by 0 by job currency factor
    //PRJ-665 N.S.1.0 Remove FA Job usage = TRUE condition
    //PRJ-772.JS.1.0 28July2021 | Add condition for Crew code resource
    //PRJ-834.JS.1.0 09Aug2021 | Correct code in local procedure "NS_T5902OnAfterValidateJobPlanningLineNo"
    //PRJ-882.JS.1.0   25Aug2021 | Add procedure to correct Sales LCY on factbox
    //PRJ-931.JS.1.0�24Sep2021 | Add Procedure as per requirement
    //PRJ-899.GK.1.0 24Sep2021 | Merge code from CTSI for PRJ-899.
    //PRJ-1003.JS.1.0 25Oct2021 | code commented
    //PRJ-1004.JS.1.0 25Oct2021 | code commented

    Permissions = tabledata "Purch. Rcpt. Line" = rimd, tabledata 169 = rimd, tabledata "NS_Assembley BOM Components" = rimd;//PRJ-256.MS.1.0 //PRJ-563.AS.2.0 Added AssemblyBOM

    trigger OnRun()
    begin
    end;

    var
        p: Codeunit "NS_Parameters for Table Events";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        NS_JobsSetup: Record "Jobs Setup";
        SalesHeaderxRec: Record "Sales Header"; //PRJ-9.SK.1.0
        xSalesHeaderRecContact: Record "Sales Header"; //PRJ-9.SK.1.0
        I: integer;



    //PPNA16.0 Blocked Start Will remove this code once testing done
    //PRJ-212 VT1.0 22-04-20 begin

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeCreateTempJobJnlLine', '', false, false)]
    // local procedure T39OnBeforeCreateTempJobJnlLine(var GetPrices: Boolean; var TempJobJournalLine: Record "Job Journal Line"; PurchaseLine: Record "Purchase Line")
    // begin
    //     GetPrices := true;
    // end;
    //PPNA16.0 Blocked End


    //PPNA16.0 Blocked Start Will remove this code once testing done
    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterCreateTempJobJnlLine', '', false, false)]
    // local procedure T39OnAfterCreateTempJobJnlLine(var PurchLine: Record "Purchase Line"; var JobJournalLine: Record "Job Journal Line")
    // begin
    //     if JobJournalLine."Unit Cost (LCY)" = 0 then begin
    //         if JobJournalLine."Direct Unit Cost (LCY)" <> 0 then
    //             JobJournalLine.Validate("Unit Cost (LCY)", JobJournalLine."Direct Unit Cost (LCY)");
    //         //PurchLine."Unit Cost (LCY)" := JobJournalLine."Unit Cost (LCY)";
    //         //PurchLine."Unit Cost" := JobJournalLine."Unit Cost";
    //         PurchLine."Unit Price (LCY)" := JobJournalLine."Unit Price (LCY)";
    //     end;
    // end;
    //PPNA16.0 Blocked End
    //PRJ-212 VT1.0 22-04-20 end


    //PRJ-568.AS.1.0 - START
    [EventSubscriber(ObjectType::Table, 1003, 'OnBeforeModifyEvent', '', false, false)]
    local procedure NS_T1003OnBeforeModifyEvent(var Rec: Record "Job Planning Line")
    var
        JPLRec: Record "Job Planning Line";
    begin
        JPLRec.reset;
        JPLRec.SetRange("Job No.", Rec."Job No.");
        // JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
        JPLRec.SetRange("NS_Resource Line No.", Rec."Line No.");
        if JPLRec.FindFirst() then begin
            JPLRec.Validate(Quantity, Rec.Quantity * Rec."NS_Labor Hours per Qty.");
            JPLRec."NS_Labor Hours per Qty." := Rec."NS_Labor Hours per Qty.";
            JPLRec.Modify();
        end;
    end;
    //PRJ-568.AS.1.0 - END

    //PRJ-568.AS.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure NS_UpdateLinkedResourceFields(var Rec: Record "Job Planning Line")
    var
        ItemMasterRec: Record Item;
    begin
        IF Rec.Type = Rec.Type::Item then begin
            if ItemMasterRec.get(Rec."No.") then begin
                Rec.Validate("NS_Linked Resource", ItemMasterRec."NS_Linked Resource");
                Rec.Validate("NS_Labor Hours per Qty.", ItemMasterRec."NS_Labor Hours per Qty.");
            end;
        end;
    end;
    //PRJ-568.AS.1.0 End   

    //PRJ-452.AM.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure UpdateQtyFields(var Rec: Record "Job Planning Line")
    begin
        if (rec."Line Type" = Rec."Line Type"::"Both Budget and Billable") OR (rec."Line Type" = Rec."Line Type"::Billable) then begin
            Rec.Validate("Contract Line", true);
            Rec.Validate("Qty. to Invoice", Rec.Quantity);
            Rec.Validate("Qty. to Transfer to Invoice", Rec.Quantity);
        end;
    end;

    //PRJ-452.AM.1.0 End

    [EventSubscriber(ObjectType::Table, 169, 'OnBeforeInsertEvent', '', false, false)]
    local procedure NS_T169OnBeforeInsertEvent(var Rec: Record "Job Ledger Entry")
    begin
        rec."NS_Job Cost Category Tmp" := Rec."NS_Job Cost Category";
        rec."NS_Job Revenue Category Tmp" := rec."NS_Job Revenue Category";
    end;

    [EventSubscriber(ObjectType::Table, 169, 'OnBeforeModifyEvent', '', false, false)]
    local procedure NS_T169OnBeforeModifyEvent(var Rec: Record "Job Ledger Entry")
    begin
        rec."NS_Job Cost Category Tmp" := Rec."NS_Job Cost Category";
        rec."NS_Job Revenue Category Tmp" := rec."NS_Job Revenue Category";
        //if Rec.Adjusted = true then begin //PRJ-504 
        //end;//PRJ-504
    end;

    // //PRJ-504.MS.1.0 start
    [EventSubscriber(ObjectType::Table, 254, 'OnAfterInsertEvent', '', false, false)]
    local procedure T254Onafterinsert(var Rec: Record "VAT Entry")
    var
        JLE: Record "Job Ledger Entry";
    begin
        if (Rec."Document Type" = rec."Document Type"::Invoice) and (Rec.Amount = 0) then begin
            JLE.Reset();
            jle.SetRange("Document No.", Rec."Document No.");
            if JLE.FindFirst() then begin
                JLE."Total Cost (LCY)" := JLE."Total Cost (LCY)" + JLE."NS_Burden Amount";
                JLE.Modify();

            end;
        end;

    end;
    // //PRJ-504.MS.1.0 end

    [EventSubscriber(ObjectType::Table, 169, 'OnBeforeRenameEvent', '', false, false)]
    local procedure T169OnBeforeRenameEvent(var Rec: Record "Job Ledger Entry")
    begin
        rec."NS_Job Cost Category Tmp" := Rec."NS_Job Cost Category";
        rec."NS_Job Revenue Category Tmp" := rec."NS_Job Revenue Category";
    end;

    //PRJ-563.AS.1.0 start
    [EventSubscriber(ObjectType::Table, 14021495, 'OnAfterInsertEvent', '', false, false)]
    local procedure T14021495Onafterinsert(var Rec: Record "NS_Assembley BOM Components")
    var
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRec2: Record "NS_Assembley BOM Components";
        AssemBOMRec3: Record "NS_Assembley BOM Components";
        BOMComponentRec: Record "BOM Component";
        itemrec: Record Item;
        Resourcerec: Record Resource;
        JobPlanLine: Record "Job Planning Line";//PRJ-563.AS.1.0 24MAY2020 
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') and (Rec."NS_Assembly BOM" = true) then begin
            BOMComponentRec.Reset();
            BOMComponentRec.SetRange("Parent Item No.", Rec."NS_No.");
            BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
            if BOMComponentRec.FindSet() then
                repeat
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", BOMComponentRec."Parent Item No.");
                    AssemBOMRec.SetRange("NS_Ref. ASMBOM Line No.", BOMComponentRec."Line No.");
                    if not AssemBOMRec.FindFirst() then begin
                        AssemBOMRec2.Init();
                        AssemBOMRec2."NS_Job No." := Rec."NS_Job No.";
                        AssemBOMRec2."NS_Job Task No." := Rec."NS_Job Task No.";

                        AssemBOMRec3.Reset();
                        AssemBOMRec3.SetRange("NS_Job No.", Rec."NS_Job No.");
                        AssemBOMRec3.SetRange("NS_Job Task No.", Rec."NS_Job Task No.");
                        if AssemBOMRec3.FindLast() then
                            AssemBOMRec2."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
                        else
                            AssemBOMRec2."NS_Line No." := 10000;

                        if BOMComponentRec.Type = BOMComponentRec.Type::Item then begin
                            AssemBOMRec2.NS_Type := BOMComponentRec.Type::Item;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                if itemrec.get(AssemBOMRec2."NS_No.") then begin
                                    itemrec.CalcFields("Assembly BOM");
                                    AssemBOMRec2."NS_Assembly BOM" := itemrec."Assembly BOM";
                                    // AssemBOMRec2.NS_Description := itemrec.Description;//PRJ-838 COMMENT
                                    AssemBOMRec2."NS_Description New" := itemrec.Description;//PRJ-838 ADD
                                    AssemBOMRec2."NS_Unit Cost" := itemrec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                end;
                            end;
                        end;
                        if BOMComponentRec.Type = BOMComponentRec.Type::Resource then begin
                            AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Resource;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            // if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                            if Resourcerec.get(AssemBOMRec2."NS_No.") then begin
                                AssemBOMRec2."NS_Assembly BOM" := BOMComponentRec."Assembly BOM";
                                // AssemBOMRec2.NS_Description := Resourcerec.Name;//PRJ-838 COMMENT
                                AssemBOMRec2."NS_Description New" := Resourcerec.Name;//PRJ-838 ADD
                                AssemBOMRec2."NS_Unit Cost" := Resourcerec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                            end;
                            //end;
                        end;

                        //PRJ-563.AS.1.0 24MAY2020 - start
                        AssemBOMRec2.NS_Level := Rec.NS_Level + 1;
                        AssemBOMRec2."NS_Main Item" := Rec."NS_Main Item";
                        if AssemBOMRec2."NS_Assembly BOM" = true then
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Assembly
                        else
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Normal;
                        //PRJ-563.AS.1.0 24MAY2020 - end

                        AssemBOMRec2."NS_Quantity Per" := BOMComponentRec."Quantity per";
                        AssemBOMRec2."NS_Unit of Measure Code" := BOMComponentRec."Unit of Measure Code";
                        AssemBOMRec2."NS_Quantity of Assembly Item on Job" := AssemBOMRec."NS_Expected Quantity";//PRJ-563.AS.2.0
                        AssemBOMRec2."NS_Expected Quantity" := AssemBOMRec2."NS_Quantity Per" * AssemBOMRec2."NS_Quantity of Assembly Item on Job";
                        AssemBOMRec2."NS_Ref. JPL Line No." := Rec."NS_Ref. JPL Line No.";
                        AssemBOMRec2."NS_Ref. JPL Parent Item No." := BOMComponentRec."Parent Item No.";
                        AssemBOMRec2."NS_Ref. ASMBOM Line No." := BOMComponentRec."Line No.";
                        AssemBOMRec2."NS_JPL DocNo" := AssemBOMRec."NS_JPL DocNo";
                        AssemBOMRec2.Insert();
                    end;
                until BOMComponentRec.NEXT = 0;
        end;

    end;
    //PRJ-563.AS.1.0 end

    // //PRJ-563.AS.2.0
    [EventSubscriber(ObjectType::Table, 14021495, 'OnbeforeModifyEvent', '', false, false)]
    // [EventSubscriber(ObjectType::Page, 14021495, 'OnModifyRecordEvent', '', false, false)]
    local procedure T14021495OnafterModify(var Rec: Record "NS_Assembley BOM Components")
    var
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRec2: Record "NS_Assembley BOM Components";
        AssemBOMRec3: Record "NS_Assembley BOM Components";
        BOMComponentRec: Record "BOM Component";
        itemrec: Record Item;
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') and (Rec."NS_Assembly BOM" = true) then begin
            BOMComponentRec.Reset();
            BOMComponentRec.SetRange("Parent Item No.", Rec."NS_No.");
            BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
            if BOMComponentRec.FindSet() then
                repeat
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."NS_No.");
                    if AssemBOMRec.Findset() then
                        repeat
                            AssemBOMRec."NS_Quantity of Assembly Item on Job" := Rec."NS_Expected Quantity";
                            AssemBOMRec."NS_Expected Quantity" := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                            //PRJ-563.AS.1.0 24MAY2020 - start
                            if AssemBOMRec."NS_Assembly BOM" = true then
                                AssemBOMRec."NS_Item Type" := AssemBOMRec."NS_Item Type"::Assembly
                            else
                                AssemBOMRec."NS_Item Type" := AssemBOMRec."NS_Item Type"::Normal;
                            //PRJ-563.AS.1.0 24MAY2020 - end
                            AssemBOMRec.Modify();
                        until AssemBOMRec.next = 0;
                until BOMComponentRec.NEXT = 0;
        end;

    end;
    // //PRJ-563.AS.2.0

    //PRJ-563.AS.3.0
    [EventSubscriber(ObjectType::Table, 14021495, 'Onaftervalidateevent', 'NS_No.', false, false)]
    local procedure UpdateQtyAfterNovalidateinAssemblyBOMPg(var Rec: Record "NS_Assembley BOM Components")
    var
        JPL: Record "Job Planning Line";
        AssemBOMRec: Record "NS_Assembley BOM Components";
    begin
        JPL.reset;
        JPL.setrange("Job No.", rec."NS_Job No.");
        JPL.SetRange("Job Task No.", Rec."NS_Job Task No.");
        JPL.SetRange("Line No.", Rec."NS_Ref. JPL Line No.");
        JPL.SetRange(Type, JPL.Type::Item);
        JPL.SetRange("No.", Rec."NS_Ref. JPL Parent Item No.");
        if JPL.FindFirst then begin
            Rec."NS_Quantity of Assembly Item on Job" := JPL.Quantity;
            Rec."NS_JPL DocNo" := JPL."Document No.";
            Rec.Modify();
        end;

        AssemBOMRec.Reset();
        AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
        AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
        AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
        AssemBOMRec.SetRange("NS_No.", Rec."NS_Ref. JPL Parent Item No.");
        if AssemBOMRec.FindFirst() then begin
            Rec."NS_Quantity of Assembly Item on Job" := AssemBOMRec."NS_Expected Quantity";
            Rec."NS_Expected Quantity" := Rec."NS_Quantity Per" * Rec."NS_Quantity of Assembly Item on Job";
            Rec."NS_JPL DocNo" := AssemBOMRec."NS_JPL DocNo";
            //PRJ-563.AS.1.0 24MAY2020 - start
            if Rec."NS_Assembly BOM" = true then
                Rec."NS_Item Type" := Rec."NS_Item Type"::Assembly
            else
                Rec."NS_Item Type" := Rec."NS_Item Type"::Normal;
            //PRJ-563.AS.1.0 24MAY2020 - end
            Rec.Modify();
        end;
    end;
    //PRJ-563.AS.3.0



    //PRJ-563.AS.1.0 24MAY2020 - START
    [EventSubscriber(ObjectType::Page, 14021495, 'OnInsertRecordEvent', '', false, false)]
    local procedure T14021495OnafterinsertPG(var Rec: Record "NS_Assembley BOM Components")
    var
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRec2: Record "NS_Assembley BOM Components";
        AssemBOMRec3: Record "NS_Assembley BOM Components";
        BOMComponentRec: Record "BOM Component";
        itemrec: Record Item;
        Resourcerec: Record Resource;
        JobPlanLine: Record "Job Planning Line";//PRJ-563.AS.1.0 24MAY2020 
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') and (Rec."NS_Assembly BOM" = true) then begin
            BOMComponentRec.Reset();
            BOMComponentRec.SetRange("Parent Item No.", Rec."NS_No.");
            BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
            if BOMComponentRec.FindSet() then
                repeat
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", BOMComponentRec."Parent Item No.");
                    AssemBOMRec.SetRange("NS_Ref. ASMBOM Line No.", BOMComponentRec."Line No.");
                    if not AssemBOMRec.FindFirst() then begin
                        AssemBOMRec2.Init();
                        AssemBOMRec2."NS_Job No." := Rec."NS_Job No.";
                        AssemBOMRec2."NS_Job Task No." := Rec."NS_Job Task No.";

                        AssemBOMRec3.Reset();
                        AssemBOMRec3.SetRange("NS_Job No.", Rec."NS_Job No.");
                        AssemBOMRec3.SetRange("NS_Job Task No.", Rec."NS_Job Task No.");
                        if AssemBOMRec3.FindLast() then
                            AssemBOMRec2."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
                        else
                            AssemBOMRec2."NS_Line No." := 10000;

                        if BOMComponentRec.Type = BOMComponentRec.Type::Item then begin
                            AssemBOMRec2.NS_Type := BOMComponentRec.Type::Item;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                if itemrec.get(AssemBOMRec2."NS_No.") then begin
                                    itemrec.CalcFields("Assembly BOM");
                                    AssemBOMRec2."NS_Assembly BOM" := itemrec."Assembly BOM";
                                    // AssemBOMRec2.NS_Description := itemrec.Description;//PRJ-838 COMMENT
                                    AssemBOMRec2."NS_Description New" := itemrec.Description;//PRJ-838 ADD
                                    AssemBOMRec2."NS_Unit Cost" := itemrec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                end;
                            end;
                        end;
                        if BOMComponentRec.Type = BOMComponentRec.Type::Resource then begin
                            AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Resource;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            //if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                            if Resourcerec.get(AssemBOMRec2."NS_No.") then begin
                                AssemBOMRec2."NS_Assembly BOM" := BOMComponentRec."Assembly BOM";
                                // AssemBOMRec2.NS_Description := Resourcerec.Name;//PRJ-838 COMMENT
                                AssemBOMRec2."NS_Description New" := Resourcerec.Name;//PRJ-838 ADD
                                AssemBOMRec2."NS_Unit Cost" := Resourcerec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                            end;
                            //end;
                        end;

                        //PRJ-563.AS.1.0 24MAY2020 - start
                        AssemBOMRec2.NS_Level := Rec.NS_Level + 1;
                        AssemBOMRec2."NS_Main Item" := Rec."NS_Main Item";
                        if AssemBOMRec2."NS_Assembly BOM" = true then
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Assembly
                        else
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Normal;
                        //PRJ-563.AS.1.0 24MAY2020 - end

                        AssemBOMRec2."NS_Quantity Per" := BOMComponentRec."Quantity per";
                        AssemBOMRec2."NS_Unit of Measure Code" := BOMComponentRec."Unit of Measure Code";
                        AssemBOMRec2."NS_Quantity of Assembly Item on Job" := AssemBOMRec."NS_Expected Quantity";//PRJ-563.AS.2.0
                        AssemBOMRec2."NS_Expected Quantity" := AssemBOMRec2."NS_Quantity Per" * AssemBOMRec2."NS_Quantity of Assembly Item on Job";
                        AssemBOMRec2."NS_Ref. JPL Line No." := Rec."NS_Ref. JPL Line No.";
                        AssemBOMRec2."NS_Ref. JPL Parent Item No." := BOMComponentRec."Parent Item No.";
                        AssemBOMRec2."NS_Ref. ASMBOM Line No." := BOMComponentRec."Line No.";
                        AssemBOMRec2."NS_JPL DocNo" := AssemBOMRec."NS_JPL DocNo";
                        AssemBOMRec2.Insert();
                    end;
                until BOMComponentRec.NEXT = 0;
        end;

    end;


    [EventSubscriber(ObjectType::Page, 14021495, 'OnModifyRecordEvent', '', false, false)]
    local procedure T14021495OnafterModifyPG(var Rec: Record "NS_Assembley BOM Components")
    var
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRec2: Record "NS_Assembley BOM Components";
        AssemBOMRec3: Record "NS_Assembley BOM Components";
        BOMComponentRec: Record "BOM Component";
        itemrec: Record Item;
        Resourcerec: Record Resource;
    begin
        if (Rec.NS_Type = Rec.NS_Type::Item) and (Rec."NS_No." <> '') and (Rec."NS_Assembly BOM" = true) then begin
            BOMComponentRec.Reset();
            BOMComponentRec.SetRange("Parent Item No.", Rec."NS_No.");
            BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
            if BOMComponentRec.FindSet() then
                repeat
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", BOMComponentRec."Parent Item No.");
                    AssemBOMRec.SetRange("NS_Ref. ASMBOM Line No.", BOMComponentRec."Line No.");
                    if not AssemBOMRec.FindFirst() then begin
                        AssemBOMRec2.Init();
                        AssemBOMRec2."NS_Job No." := Rec."NS_Job No.";
                        AssemBOMRec2."NS_Job Task No." := Rec."NS_Job Task No.";

                        AssemBOMRec3.Reset();
                        AssemBOMRec3.SetRange("NS_Job No.", Rec."NS_Job No.");
                        AssemBOMRec3.SetRange("NS_Job Task No.", Rec."NS_Job Task No.");
                        if AssemBOMRec3.FindLast() then
                            AssemBOMRec2."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
                        else
                            AssemBOMRec2."NS_Line No." := 10000;

                        if BOMComponentRec.Type = BOMComponentRec.Type::Item then begin
                            AssemBOMRec2.NS_Type := BOMComponentRec.Type::Item;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                if itemrec.get(AssemBOMRec2."NS_No.") then begin
                                    itemrec.CalcFields("Assembly BOM");
                                    AssemBOMRec2."NS_Assembly BOM" := itemrec."Assembly BOM";
                                    // AssemBOMRec2.NS_Description := itemrec.Description;//PRJ-838 COMMENT
                                    AssemBOMRec2."NS_Description New" := itemrec.Description; //PRJ-838 ADD
                                    //AssemBOMRec2."NS_Unit Cost" := itemrec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                end;
                            end;
                        end;
                        if BOMComponentRec.Type = BOMComponentRec.Type::Resource then begin
                            AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Resource;
                            AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                            //if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                            if Resourcerec.get(AssemBOMRec2."NS_No.") then begin
                                AssemBOMRec2."NS_Assembly BOM" := BOMComponentRec."Assembly BOM";
                                // AssemBOMRec2.NS_Description := Resourcerec.Name;//PRJ-838 COMMENT
                                AssemBOMRec2."NS_Description New" := Resourcerec.Name;//PRJ-838 ADD
                                //AssemBOMRec2."NS_Unit Cost" := Resourcerec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                            end;
                            //end;
                        end;

                        //PRJ-563.AS.1.0 24MAY2020 - start
                        AssemBOMRec2.NS_Level := Rec.NS_Level + 1;
                        AssemBOMRec2."NS_Main Item" := Rec."NS_Main Item";
                        if AssemBOMRec2."NS_Assembly BOM" = true then
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Assembly
                        else
                            AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Normal;
                        //PRJ-563.AS.1.0 24MAY2020 - end

                        AssemBOMRec2."NS_Quantity Per" := BOMComponentRec."Quantity per";
                        AssemBOMRec2."NS_Unit of Measure Code" := BOMComponentRec."Unit of Measure Code";
                        AssemBOMRec2."NS_Quantity of Assembly Item on Job" := AssemBOMRec."NS_Expected Quantity";//PRJ-563.AS.2.0
                        AssemBOMRec2."NS_Expected Quantity" := AssemBOMRec2."NS_Quantity Per" * AssemBOMRec2."NS_Quantity of Assembly Item on Job";
                        AssemBOMRec2."NS_Ref. JPL Line No." := Rec."NS_Ref. JPL Line No.";
                        AssemBOMRec2."NS_Ref. JPL Parent Item No." := BOMComponentRec."Parent Item No.";
                        AssemBOMRec2."NS_Ref. ASMBOM Line No." := BOMComponentRec."Line No.";
                        AssemBOMRec2."NS_JPL DocNo" := AssemBOMRec."NS_JPL DocNo";
                        AssemBOMRec2.Insert();
                    end;
                until BOMComponentRec.NEXT = 0;


            BOMComponentRec.Reset();
            BOMComponentRec.SetRange("Parent Item No.", Rec."NS_No.");
            BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
            if BOMComponentRec.FindSet() then
                repeat
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."NS_No.");
                    if AssemBOMRec.Findset() then
                        repeat
                            AssemBOMRec."NS_Quantity of Assembly Item on Job" := Rec."NS_Expected Quantity";
                            AssemBOMRec."NS_Expected Quantity" := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                            if AssemBOMRec."NS_Assembly BOM" = true then
                                AssemBOMRec."NS_Item Type" := AssemBOMRec."NS_Item Type"::Assembly
                            else
                                AssemBOMRec."NS_Item Type" := AssemBOMRec."NS_Item Type"::Normal;
                            //PRJ-563.AS.4.0 23JUN2021 - start
                            // if itemrec.Get(AssemBOMRec."NS_No.") then
                            //     AssemBOMRec."NS_Unit Cost" := itemrec."Unit Cost";
                            // if Resourcerec.Get(AssemBOMRec."NS_No.") then
                            //     AssemBOMRec."NS_Unit Cost" := Resourcerec."Unit Cost";
                            //PRJ-563.AS.4.0 23JUN2021 - end
                            AssemBOMRec.Modify();
                        until AssemBOMRec.next = 0;
                until BOMComponentRec.NEXT = 0;
        end;

    end;
    //PRJ-563.AS.1.0 24MAY2020 - END   

    //PRJ-604.AS.1.0 - start
    [EventSubscriber(ObjectType::Table, 1001, 'OnAfterInsertEvent', '', false, false)]
    local procedure T1001OnBeforeValidateEvent(var Rec: Record "Job Task")
    var
        JobSetupRec: Record "Jobs Setup";
        jobRecord: Record Job;
        jobRecord1: Record Job;
        jobtaskrec: Record "Job Task";
        jobtaskrec1: Record "Job Task";
    begin
        JobSetupRec.Get();

        if JobSetupRec."NS_Check Master Job No." = true then begin
            if jobRecord.get(Rec."Job No.") then begin
                if jobRecord1.get(jobRecord."NS_Sub-Level to Job No.") then begin
                    jobtaskrec.Reset();
                    jobtaskrec.SetRange("Job No.", jobRecord1."No.");
                    jobtaskrec.SetRange("Job Task No.", Rec."Job Task No.");
                    if not jobtaskrec.FindFirst() then
                        IF not CONFIRM('The Task No. "%1" doesn�t Exist in the Master Job No. "%2" . Do you want to Continue??', false,
    Rec."Job Task No.", jobRecord1."No.") THEN begin
                            jobtaskrec1.Reset();
                            jobtaskrec1.SetRange("Job No.", Rec."Job No.");
                            jobtaskrec1.SetRange("Job Task No.", Rec."Job Task No.");
                            if jobtaskrec1.FindFirst() then
                                jobtaskrec1.Delete();
                        end;
                end;
            end;
        end;
    end;
    //PRJ-604.AS.1.0 - end 

    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 167, 'OnBeforeUpdateJobTaskDimension', '', false, false)]
    local procedure NS_T167OnUpdateJobTaskDimensionCustom1(Job: Record Job; FieldNumber: Integer; ShortcutDimCode: Code[20]; VAR isHandled: Boolean)
    var
        JobTask: Record "Job Task";
        UpdateJobTaskDimQst: Label 'You have changed a dimension.\\Do you want to update the lines?';
    begin

        JobTask.SETRANGE("Job No.", Job."No.");
        IF JobTask.FINDSET(TRUE) THEN BEGIN
            IF (GUIALLOWED) AND (NOT Job.GetCopiedJob()) AND (NOT Job.GetSupressDimConfirmDialogs()) THEN
                IF NOT CONFIRM(UpdateJobTaskDimQst, FALSE) THEN
                    EXIT;
            //ProjectPro - end
            REPEAT
                CASE FieldNumber OF
                    1:
                        JobTask.VALIDATE("Global Dimension 1 Code", ShortcutDimCode);
                    2:
                        JobTask.VALIDATE("Global Dimension 2 Code", ShortcutDimCode);
                END;
                JobTask.MODIFY;
            UNTIL JobTask.NEXT = 0;
            //ProjectPro - start
        END;
        //ProjectPro - end
    end;


    //PPNA16.0 Comment Start Will remove this code once testing done
    // [EventSubscriber(ObjectType::Table, 167, 'OnValidateShortcutDimCodeCustom1', '', false, false)]
    // local procedure T167OnValidateShortcutDimCodeCustom1(VAR DimMgt: Codeunit DimensionManagement; Job: Record Job)
    // begin
    //     DimMgt.SetSupressConfirmDialogs(Job.GetSupressDimConfirmDialogs());
    // end;
    //PPNA16.0 Comment End

    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 167, 'OnAfterValidateEvent', 'Bill-to Customer No.', false, false)]
    local procedure NS_T167OnUpdateCustCustom1(var Rec: Record Job; var xRec: Record Job)
    var
        JobXrec: Record Job;
        CustomerRec: Record Customer;
    begin
        IF JobXrec.GET(Rec."No.") THEN
            IF jobxrec."Invoice Currency Code" <> Rec."Invoice Currency Code" THEN begin
                Rec."Invoice Currency Code" := Jobxrec."Invoice Currency Code"; //restore assigned value
                IF CustomerRec.GET(Rec."Bill-to Customer No.") THEN
                    Rec."Currency Code" := CustomerRec."Currency Code";
            end;
    end;
    //PRJ-9.SK.10 End


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 124, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T124OnAppliestoDocNoOnLookupSetFilter(VAR VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        NS_PurchSetup.GET;
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            VendLedgEntry.SETRANGE("NS_Ledger No. Link", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;
    //PPNA16.0 Modified Event End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Table, 124, 'OnNavigateBeforeRun', '', false, false)]
    // local procedure T124OnNavigateBeforeRun(Rec: Record "Purch. Cr. Memo Hdr.")
    // begin
    //     NS_PurchSetup.GET;
    //     IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
    //         p.SetNS_Navigate(Rec."Posting Date", Rec."No.", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    // end;
    //PPNA16.0 Blocked End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 122, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T122OnAppliestoDocNoOnLookupSetFilter(VAR VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        NS_PurchSetup.GET();
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;
    //PPNA16.0 Modified Event End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Table, 122, 'OnNavigateBeforeRun', '', false, false)]
    // local procedure T122OnNavigateBeforeRun(Rec: Record "Purch. Inv. Header")
    // begin
    //     NS_PurchSetup.GET;
    //     IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
    //         p.SetNS_Navigate(Rec."Posting Date", Rec."No.", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    // end;
    //PPNA16.0 Blocked End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 120, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T120OnAppliestoDocNoOnLookupSetFilter(VAR VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        NS_PurchSetup.GET;
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
    end;
    //PPNA16.0 Modified Event End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Table, 114, 'OnNavigateBeforeRun', '', false, false)]
    // local procedure T114OnNavigateBeforeRun(Rec: Record "Sales Cr.Memo Header")
    // begin
    //     NS_SalesSetup.GET;
    //     IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
    //         p.SetNS_Navigate(Rec."Posting Date", Rec."No.", NS_SalesSetup."NS_Normal Customer Ledger No.");
    // end;
    //PPNA16.0 Blocked End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 114, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T114OnAppliestoDocNoOnLookupSetFilter(VAR CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;
    //PPNA16.0 Modified Event End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Table, 112, 'OnNavigateBeforeRun', '', false, false)]
    // local procedure T112OnNavigateBeforeRun(Rec: Record "Sales Invoice Header")
    // begin
    //     NS_SalesSetup.GET;
    //     IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
    //         p.SetNS_Navigate(Rec."Posting Date", Rec."No.", NS_SalesSetup."NS_Normal Customer Ledger No.");
    // end;
    //PPNA16.0 Blocked End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 112, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T112OnAppliestoDocNoOnLookupSetFilter(VAR CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;
    //PPNA16.0 Modified Event End



    //PPNA16.0 Blocked Start
    // [EventSubscriber(ObjectType::Table, 110, 'OnNavigateBeforeRun', '', false, false)]
    // local procedure T110OnNavigateBeforeRun(Rec: Record "Sales Shipment Header")
    // begin
    //     NS_SalesSetup.GET;
    //     IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
    //         p.SetNS_Navigate(Rec."Posting Date", Rec."No.", NS_SalesSetup."NS_Normal Customer Ledger No.");
    // end;
    //PPNA16.0 Blocked End


    [EventSubscriber(ObjectType::Table, 110, 'OnLookupAppliesToDocNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T110OnAppliestoDocNoOnLookupSetFilter(VAR CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
    end;

    [EventSubscriber(ObjectType::Table, 21, 'OnBeforeDrillDownEntries', '', false, false)]
    local procedure NS_T21OnBeforeDrillDownEntries(var CustLedgerEntry: Record "Cust. Ledger Entry"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        //ProjectPro - start
        DetailedCustLedgEntry.CopyFilter("NS_Job No.", CustLedgerEntry."NS_Job No.");
        //ProjectPro - end
    end;

    //PRJ-197:AS:15APRIL2020 - START
    [EventSubscriber(ObjectType::Table, 21, 'OnBeforeDrillDownEntries', '', false, false)]
    local procedure NS_T21OnBeforeDrillDownEntriesRLCCode(var CustLedgerEntry: Record "Cust. Ledger Entry"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin

        DetailedCustLedgEntry.CopyFilter("NS_Retention Ledger Code", CustLedgerEntry."NS_Retention Ledger Code");
    end;
    //PRJ-197:AS:15APRIL2020 - END


    //PPNA17.0 Opened Start OnBeforeOpenVendorLedgerEntries 
    [EventSubscriber(ObjectType::Table, 23, 'OnBeforeOpenVendorLedgerEntries', '', false, false)]
    local procedure NS_T23OnBeforeOpenVendorLedgerEntries(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //ProjectPro - start
        //NS_PurchSetup.Get; //PRJ-197.AS.1.0 Commented
        //DetailedVendorLedgEntry.SetRange("Retention Ledger Code", NS_PurchSetup."Normal Vendor Ledger No.");//PRJ-197.AS.1.0 Commented
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 25, 'OnBeforeDrillDownEntries', '', false, false)]
    local procedure NS_T25OnBeforeDrillDownEntries(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        //ProjectPro - start
        DetailedVendorLedgEntry.CopyFilter("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
        //ProjectPro - end stop
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnBeforeDrillDownOnOverdueEntries', '', false, false)]
    local procedure NS_T25OnBeforeDrillDownOnOverdueEntries(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        //ProjectPro - start
        DetailedVendorLedgEntry.CopyFilter("NS_Retention Ledger Code", VendorLedgerEntry."NS_Retention Ledger Code");
        //ProjectPro - end stop
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnInitInsertOnBeforeInitRecord', '', false, false)]
    local procedure NS_T36OnInitInsertOnBeforeInitRecord(VAR SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        //ProjectPro - start
        SalesHeader."Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header", SalesHeader."Document Type".AsInteger(), SalesHeader."No.");
        //ProjectPro - end
    end;


    //PRJ-9.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure NS_T36OnAfterSelltoCustomerNoInit(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    begin
        Clear(SalesHeaderxRec);
        IF SalesHeaderxRec.GET(Rec."Document Type", Rec."No.") then;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Header", 'OnAfterInitNoSeries', '', false, false)]
    local procedure NS_AssigningxRecValues(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."No. Series" := SalesHeaderxRec."No. Series";
        SalesHeader.InitRecord;
        if SalesHeaderxRec."Shipping No." <> '' then begin
            SalesHeader."Shipping No. Series" := SalesHeaderxRec."Shipping No. Series";
            SalesHeader."Shipping No." := SalesHeaderxRec."Shipping No.";
        end;
        if SalesHeaderxRec."Posting No." <> '' then begin
            SalesHeader."Posting No. Series" := SalesHeaderxRec."Posting No. Series";
            SalesHeader."Posting No." := SalesHeaderxRec."Posting No.";
        end;
        if SalesHeaderxRec."Return Receipt No." <> '' then begin
            SalesHeader."Return Receipt No. Series" := SalesHeaderxRec."Return Receipt No. Series";
            SalesHeader."Return Receipt No." := SalesHeaderxRec."Return Receipt No.";
        end;
        if SalesHeaderxRec."Prepayment No." <> '' then begin
            SalesHeader."Prepayment No. Series" := SalesHeaderxRec."Prepayment No. Series";
            SalesHeader."Prepayment No." := SalesHeaderxRec."Prepayment No.";
        end;
        if SalesHeaderxRec."Prepmt. Cr. Memo No." <> '' then begin
            SalesHeader."Prepmt. Cr. Memo No. Series" := SalesHeaderxRec."Prepmt. Cr. Memo No. Series";
            SalesHeader."Prepmt. Cr. Memo No." := SalesHeaderxRec."Prepmt. Cr. Memo No.";
        end;

    end;
    //PRJ-9.SK.1.0 End


    [EventSubscriber(ObjectType::Table, 36, 'OnAfterSetFieldsBilltoCustomer', '', false, false)]
    local procedure NS_T36OnAfterSetFieldsBilltoCustomer(var SalesHeader: Record "Sales Header"; Customer: Record Customer)
    var
        BillToCustTemplate: Record "Customer Template";
    begin
        //ProjectPro - start
        if not SalesHeader."NS_Progress Billing Document" then
            //ProjectPro - end
            SalesHeader."Prices Including VAT" := Customer."Prices Including VAT"
        else
            clear(SalesHeader."Prices Including VAT"); //SPLN1.00
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeSalesLineInsert', '', false, false)]
    local procedure NS_T36OnBeforeSalesLineInsert(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        IF TempSalesLine."No." <> '' THEN
            IF SalesLine.Type <> SalesLine.Type::" " THEN
                //ProjectPro - start
                SalesLine."Job No." := TempSalesLine."Job No.";
        //ProjectPro - end
    end;

    //PPNA17.0 Opened Start OnAfterInitFromContact 
    [EventSubscriber(ObjectType::Table, 36, 'OnInitFromContactOnAfterInitNoSeries', '', false, false)]
    local procedure NS_T36OnAfterInitFromContact(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        //ProjectPro - start
        if xSalesHeader."Shipping No." <> '' then begin
            SalesHeader."Shipping No. Series" := xSalesHeader."Shipping No. Series";
            SalesHeader."Shipping No." := xSalesHeader."Shipping No.";
        end;
        if xSalesHeader."Posting No." <> '' then begin
            SalesHeader."Posting No. Series" := xSalesHeader."Posting No. Series";
            SalesHeader."Posting No." := xSalesHeader."Posting No.";
        end;

        if xSalesHeader."Return Receipt No." <> '' then begin
            SalesHeader."Return Receipt No. Series" := xSalesHeader."Return Receipt No. Series";
            SalesHeader."Return Receipt No." := xSalesHeader."Return Receipt No.";
        end;
        if xSalesHeader."Prepayment No." <> '' then begin
            SalesHeader."Prepayment No. Series" := xSalesHeader."Prepayment No. Series";
            SalesHeader."Prepayment No." := xSalesHeader."Prepayment No.";
        end;
        if xSalesHeader."Prepmt. Cr. Memo No." <> '' then begin
            SalesHeader."Prepmt. Cr. Memo No. Series" := xSalesHeader."Prepmt. Cr. Memo No. Series";
            SalesHeader."Prepmt. Cr. Memo No." := xSalesHeader."Prepmt. Cr. Memo No.";
        end;
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End


    //PPNA17.0 Opened Start OnAfterInitOnInitFromTemplate 
    [EventSubscriber(ObjectType::Table, 36, 'OnInitFromTemplateOnAfterInitNoSeries', '', false, false)]
    local procedure NS_T36OnAfterInitOnInitFromTemplate(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        //ProjectPro - start
        if xSalesHeader."Shipping No." <> '' then begin
            SalesHeader."Shipping No. Series" := xSalesHeader."Shipping No. Series";
            SalesHeader."Shipping No." := xSalesHeader."Shipping No.";
        end;
        if xSalesHeader."Posting No." <> '' then begin
            SalesHeader."Posting No. Series" := xSalesHeader."Posting No. Series";
            SalesHeader."Posting No." := xSalesHeader."Posting No.";
        end;
        if xSalesHeader."Return Receipt No." <> '' then begin
            SalesHeader."Return Receipt No. Series" := xSalesHeader."Return Receipt No. Series";
            SalesHeader."Return Receipt No." := xSalesHeader."Return Receipt No.";
        end;
        if xSalesHeader."Prepayment No." <> '' then begin
            SalesHeader."Prepayment No. Series" := xSalesHeader."Prepayment No. Series";
            SalesHeader."Prepayment No." := xSalesHeader."Prepayment No.";
        end;
        if xSalesHeader."Prepmt. Cr. Memo No." <> '' then begin
            SalesHeader."Prepmt. Cr. Memo No. Series" := xSalesHeader."Prepmt. Cr. Memo No. Series";
            SalesHeader."Prepmt. Cr. Memo No." := xSalesHeader."Prepmt. Cr. Memo No.";
        end;
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeTestSalesLineFieldsBeforeRecreate', '', false, false)]
    local procedure NS_T36OnBeforeTestSalesLineFieldsBeforeRecreate(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        p.nS_T36SetT36TestSalesLineFieldsBeforeRecreate_JobNo(SalesLine."Job No.");
        SalesLine."Job No." := '';
        SalesLine.TESTFIELD("Job No.", '');
        SalesLine.TESTFIELD("Job Contract Entry No.", 0);
        SalesLine.TESTFIELD("Quantity Invoiced", 0);
        SalesLine.TESTFIELD("Return Qty. Received", 0);
        SalesLine.TESTFIELD("Shipment No.", '');
        SalesLine.TESTFIELD("Return Receipt No.", '');
        SalesLine.TESTFIELD("Blanket Order No.", '');
        SalesLine.TESTFIELD("Prepmt. Amt. Inv.", 0);
        SalesLine.TESTFIELD("Quantity Shipped", 0);
        SalesLine."Job No." := p.nS_T36GetT36TestSalesLineFieldsBeforeRecreate_JobNo();
        IsHandled := true;
    end;


    //PPNA16.0 Comment Start //Will done this functionality on page level
    // [EventSubscriber(ObjectType::Table, 37, 'OnJobTaskNoOnLookup', '', false, false)]
    // local procedure T37OnJobTaskNoOnLookup(VAR SalesLine: Record "Sales Line")
    // var
    //     NS_JobTaskLines: Page "Job Task Lines";
    // begin
    //     with SalesLine do begin
    //         NS_JobTaskLines.LOOKUPMODE(TRUE);
    //         NS_JobTaskLines.NS_SetJobNo("Job No.");
    //         IF NS_JobTaskLines.RUNMODAL = ACTION::LookupOK THEN
    //             "Job Task No." := NS_JobTaskLines.NS_GetTask;
    //     end;
    // end;
    //PPNA16.0 Comment End

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignHeaderValues', '', false, false)]
    local procedure NS_T37OnAfterAssignHeaderValues(VAR SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        StandardText: Record "Standard Text";
        RecId: RecordId;
    begin
        with SalesLine do begin
            if Type = Type::" " then begin
                IF Not StandardText.GET("No.") THEN begin
                    StandardText.Code := "No.";
                    StandardText.Insert;
                    p.NS_T7SetRecId(StandardText.RecordId());
                end else
                    p.NS_T7SetRecId(RecId);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignStdTxtValues', '', false, false)]
    LOCAL procedure NS_T37OnAfterAssignStdTxtValues(VAR SalesLine: Record "Sales Line"; StandardText: Record "Standard Text")
    var
        RecId: RecordId;
    begin
        p.NS_T7GetRecId(RecId);
        if StandardText.Get(RecId) then
            StandardText.Delete();
    end;


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeInitOutstandingAmount', '', false, false)]
    local procedure NS_T37OnAfterCheckPricesInclVATOnInitOutstandingAmount(CurrentFieldNo: Integer; var IsHandled: Boolean; var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        AmountInclVAT: Decimal;
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
    begin
        With SalesLine DO begin
            if Quantity = 0 then begin
                "Outstanding Amount" := 0;
                "Outstanding Amount (LCY)" := 0;
                "Shipped Not Invoiced" := 0;
                "Shipped Not Invoiced (LCY)" := 0;
                "Return Rcd. Not Invd." := 0;
                "Return Rcd. Not Invd. (LCY)" := 0;
            end else begin
                TESTFIELD("Document No.");
                IF SalesHeader.Get("Document Type", "Document No.") then
                    IF SalesHeader."Currency Code" = '' THEN
                        Currency.InitRoundingPrecision
                    ELSE BEGIN
                        SalesHeader.TESTFIELD("Currency Factor");
                        Currency.GET(SalesHeader."Currency Code");
                        Currency.TESTFIELD("Amount Rounding Precision");
                    END;
                if SalesHeader."Prices Including VAT" then
                    AmountInclVAT := "Line Amount" - "Inv. Discount Amount"
                else
                    if "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" then
                        AmountInclVAT :=
                          CalcLineAmount +
                        //ProjectPro Start
                        //   Round(
                        //     SalesTaxCalculate.CalculateTax(
                        //       "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                        //       CalcLineAmount, "Quantity (Base)", SalesHeader."Currency Factor"),
                        //     Currency."Amount Rounding Precision")
                                ROUND(
                                    SalesTaxCalculate.CalculateTax(
                                     "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                         "VAT Base Amount", "Quantity (Base)", SalesHeader."Currency Factor"),
                                     Currency."Amount Rounding Precision")
                    //ProjectPro End
                    else
                        AmountInclVAT :=
                          Round(
                            CalcLineAmount * (1 + "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100)),
                            Currency."Amount Rounding Precision");
                Validate(
                  "Outstanding Amount",
                  Round(
                    AmountInclVAT * "Outstanding Quantity" / Quantity,
                    Currency."Amount Rounding Precision"));
                if IsCreditDocType() then
                    Validate(
                      "Return Rcd. Not Invd.",
                      Round(
                        AmountInclVAT * "Return Qty. Rcd. Not Invd." / Quantity,
                        Currency."Amount Rounding Precision"))
                else
                    Validate(
                      "Shipped Not Invoiced",
                      Round(
                        AmountInclVAT * "Qty. Shipped Not Invoiced" / Quantity,
                        Currency."Amount Rounding Precision"));
            end;
        end;
        IsHandled := true;
    end;
    //PPNA16.0 Modified Event End


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 37, 'OnAfterUpdateVATAmounts', '', false, false)]
    local procedure NS_T37OnAfterUpdateVATAmounts(VAR SalesLine: Record "Sales Line")
    var
        TotalVATBase: Decimal;
        SalesLine2: Record "Sales Line";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    begin
        with SalesLine do begin
            SalesHeader.GET("Document Type", "Document No.");
            IF SalesHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE
                Currency.GET(SalesHeader."Currency Code");
            SalesLine2.SETRANGE("Document Type", "Document Type");
            SalesLine2.SETRANGE("Document No.", "Document No.");
            SalesLine2.SETFILTER("Line No.", '<>%1', "Line No.");
            SalesLine2.SETRANGE("VAT Identifier", "VAT Identifier");
            SalesLine2.SETRANGE("Tax Group Code", "Tax Group Code");

            IF "Line Amount" <> "Inv. Discount Amount" THEN BEGIN
                TotalLineAmount := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountInclVAT := 0;
                TotalQuantityBase := 0;
                //ProjectPro - start
                TotalVATBase := 0;
                //ProjectPro - end
                IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
                   (("VAT Calculation Type" IN
                     ["VAT Calculation Type"::"Normal VAT", "VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
                THEN
                    IF NOT SalesLine2.ISEMPTY THEN BEGIN
                        //ProjectPro - start
                        //SalesLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
                        SalesLine2.CALCSUMS("Line Amount", "Inv. Discount Amount", Amount, "Amount Including VAT", "Quantity (Base)", "VAT Base Amount");
                        TotalVATBase := SalesLine2."VAT Base Amount";
                        //ProjectPro - end
                        TotalLineAmount := SalesLine2."Line Amount";
                        TotalInvDiscAmount := SalesLine2."Inv. Discount Amount";
                        TotalAmount := SalesLine2.Amount;
                        TotalAmountInclVAT := SalesLine2."Amount Including VAT";
                        TotalQuantityBase := SalesLine2."Quantity (Base)";
                    END;

                IF NOT SalesHeader."Prices Including VAT" THEN
                    CASE "VAT Calculation Type" OF
                        "VAT Calculation Type"::"Sales Tax":
                            BEGIN
                                Amount := ROUND(CalcLineAmount, Currency."Amount Rounding Precision");
                                "VAT Base Amount" := Amount;
                                NS_T37NS_AdjustVATBaseAmount(SalesLine, SalesHeader);
                                "Amount Including VAT" :=
                                  TotalAmount + Amount +
                                  ROUND(
                                    SalesTaxCalculate.CalculateTax(
                                      "Tax Area Code", "Tax Group Code", "Tax Liable", SalesHeader."Posting Date",
                                      TotalVATBase + "VAT Base Amount", TotalQuantityBase + "Quantity (Base)",
                                      SalesHeader."Currency Factor"), Currency."Amount Rounding Precision") -
                                  TotalAmountInclVAT;
                                IF "VAT Base Amount" <> 0 THEN
                                    "VAT %" :=
                                      ROUND(100 * ("Amount Including VAT" - Amount) / "VAT Base Amount", 0.00001)
                                //ProjectPro - end
                                ELSE
                                    "VAT %" := 0;
                            END;
                    END; //Case
            END;
        end;
    end;
    //PPNA16.0 Modified Event End


    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 37, 'OnAfterUpdateVATOnLines', '', false, false)]
    local procedure NS_T37OnAfterQtyTypeCheckOnUpdateVATOnLines(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; QtyType: Option General,Invoicing,Shipping)
    begin
        IF QtyType = QtyType::General Then
            //ProjectPro - start
            NS_T37NS_AdjustVATBaseAmount(SalesLine, SalesHeader);
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPDA.1.0 Added Start
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure CopyJobNoFromTempSalesLinesToCurrRec(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
        SalesLine."Job No." := TempSalesLine."Job No.";
    end;
    //PPDA.1.0 Added End

    //PPNA16.0 Modified event Start
    [EventSubscriber(ObjectType::Table, 37, 'OnCalcVATAmountLinesOnAfterCalcLineTotals', '', false, false)]
    local procedure NS_T37OnBeforeCheckIfVATAmtLineExistsOnCalcVATAmountLines(SalesHeader: Record "Sales Header"; var VATAmountLine: Record "VAT Amount Line")
    var
        SalesHdr: Record "Sales Header";
    begin
        IF SalesHdr.Get(SalesHeader."Document Type", SalesHeader."No.") Then
            VATAmountLine.SetRetentionPerc(SalesHdr."NS_Retention Percent");
    end;
    //PPNA16.0 Modified event End
    procedure NS_T37NS_AdjustVATBaseAmount(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
    begin
        //ProjectPro - start
        if SalesHeader."NS_Retention Percent" = 0 then
            exit;

        if NS_JobsSetup.Get then begin
            NS_GLSetup.Get();
            if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then
                SalesLine."VAT Base Amount" := SalesLine.Amount - Round(SalesLine."VAT Base Amount" * (SalesHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
        end;
        //ProjectPro - end
    end;

    //PRJ-196 VT 08-04-20 Begin
    procedure NS_T39NS_AdjustVATBaseAmount(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup: Record "Jobs Setup";
    begin
        //ProjectPro - start
        if PurchHeader."NS_Retention Percent" = 0 then
            exit;

        if NS_JobsSetup.Get then begin
            NS_GLSetup.Get();
            if NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" then
                PurchLine."VAT Base Amount" := PurchLine.Amount - Round(PurchLine."VAT Base Amount" * (PurchHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
        end;

        //ProjectPro - end
    end;
    //PRJ-196 VT 08-04-20 end

    //PRJ-9.TY.1.0 Start
    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeUpdateAllLineDim', '', false, false)]
    LOCAL procedure NS_T38OnBeforeUpdateAllLineDim(VAR PurchaseHeader: Record "Purchase Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; VAR IsHandled: Boolean)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        PurchLine: Record "Purchase Line";
        //DimMgt: Codeunit DimensionManagement;
        DimMgt: Codeunit 408;
    begin
        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT ConfirmManagement.GetResponseOrDefault(Text051, TRUE) THEN
            EXIT;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchLine.LOCKTABLE;
        IF PurchLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF PurchLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    PurchLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");

                    PurchLine.MODIFY;
                END;
            UNTIL PurchLine.NEXT = 0;
        IsHandled := true;
    end;
    //PRJ-9.TY.1.0 End

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterCreateDimTableIDs', '', false, false)]
    local procedure NS_T38OnAfterCreateDimTableIDs(VAR PurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; VAR TableID: ARRAY[10] OF Integer; VAR No: ARRAY[10] OF Code[20])
    var
        No2: Code[20];
        TableID2: Integer;
    begin
        p.NS_T38GetCreateDim(TableID2, No2);
        if TableID2 <> 0 then begin
            TableID[5] := TableID[2];
            No[5] := No[2];
            TableID[2] := TableID2;
            No[2] := No2;
        end;
        p.NS_T38SetCreateDim(0, '');
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInsertEvent', '', false, false)]
    local procedure NS_T38OnAfterInsertEvent(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        if not RunTrigger then
            exit;
        //ProjectPro - start
        Rec."Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header", Rec."Document Type".AsInteger(), Rec."No.");
        //ProjectPro - end
        Rec.Modify(false);
    end;

    //PW.32.0.SK Start
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnBeforeTempPurchLineInsert', '', false, false)]
    local procedure T38UpdateCustomFieldOnLineAfterUpdatingVATBusPosGrp(var TempPurchaseLine: Record "Purchase Line"; PurchaseLine: Record "Purchase Line")
    begin
        TempPurchaseLine."NS_JMP Document No." := PurchaseLine."NS_JMP Document No.";
        TempPurchaseLine."NS_Segment Code" := PurchaseLine."NS_Segment Code";
        TempPurchaseLine."NS_Job Cost Category" := PurchaseLine."NS_Job Cost Category";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnBeforeInsertPurchLine', '', false, false)]
    local procedure T38_UpdateCustomFieldOnLineAfterUpdatingVATBusPosGrp(var TempPurchaseLine: Record "Purchase Line"; var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine."NS_JMP Document No." := TempPurchaseLine."NS_JMP Document No.";
        PurchaseLine."NS_Segment Code" := TempPurchaseLine."NS_Segment Code";
        PurchaseLine."NS_Job Cost Category" := TempPurchaseLine."NS_Job Cost Category";
    end;
    //PW.32.0.SK End


    [EventSubscriber(ObjectType::Table, 38, 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure NS_T38OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    var
        NS_Job: Record Job;
    begin
        //Code refactored (taken from function NS_AssignDefaultValuesToTaxFields)
        //ProjectPro - start add
        if PurchaseHeader."Buy-from Vendor No." <> Vendor."No." then
            Vendor.Get(PurchaseHeader."Buy-from Vendor No.");
        PurchaseHeader."VAT Bus. Posting Group" := Vendor."VAT Bus. Posting Group";
        PurchaseHeader."Tax Area Code" := Vendor."Tax Area Code";
        PurchaseHeader."Tax Liable" := Vendor."Tax Liable";
        if PurchaseHeader."NS_Job No." <> '' then
            if NS_Job.Get(PurchaseHeader."NS_Job No.") then begin
                if NS_Job."NS_VAT Bus. Posting Group" <> '' then
                    PurchaseHeader."VAT Bus. Posting Group" := NS_Job."NS_VAT Bus. Posting Group";
                if NS_Job."NS_Tax Area Code" <> '' then begin
                    PurchaseHeader."Tax Area Code" := NS_Job."NS_Tax Area Code";
                    PurchaseHeader."Tax Liable" := NS_Job."NS_Tax Liable";
                end;
            end;
        PurchaseHeader.Validate("VAT Bus. Posting Group");
        PurchaseHeader.Validate("Tax Area Code");
        PurchaseHeader.Validate("Tax Liable");
        //PRJ-40.SK.1.0 Start
        IF (PurchaseHeader."Pay-to Vendor No." <> '') AND (Vendor."Pay-to Vendor No." <> '') then
            PurchaseHeader.Validate("Pay-to Vendor No.", Vendor."Pay-to Vendor No.");
        IF PurchaseHeader."Pay-to Vendor No." = '' then
            PurchaseHeader.VALIDATE("Pay-to Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        //PRJ-40.SK.1.0 End
        //ProjectPro - end add
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterUpdateVATAmounts', '', false, false)]
    LOCAL procedure NS_OnAfterUpdateVATAmounts(VAR PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        //PRJ-196 VT 08-04-20 Begin
        PurchLine2: Record "Purchase Line";
        Currency: Record Currency;
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
        TotalVATBase: Decimal;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    //PRJ-196 VT 08-04-20 End
    begin

        //PRJ-196 VT 08-04-20 Begin
        with PurchaseLine do begin
            PurchHeader.Get("Document Type", "Document No.");
            TotalLineAmount := 0;
            TotalInvDiscAmount := 0;
            TotalAmount := 0;
            TotalAmountInclVAT := 0;
            TotalQuantityBase := 0;
            IF PurchHeader."Prices Including VAT" THEN
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            //ProjectPro - start
                            //NS_AdjustVATBaseAmount;
                            NS_T39NS_AdjustVATBaseAmount(PurchaseLine, PurchHeader);
                            //ProjectPro - end

                            IF "VAT Base Amount" <> 0 THEN
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                            ELSE
                                "VAT %" := 0;
                        END;
                END
            ELSE
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            //ProjectPro - start
                            //NS_AdjustVATBaseAmount;
                            NS_T39NS_AdjustVATBaseAmount(PurchaseLine, PurchHeader);
                            //ProjectPro - end


                            //Amount := ROUND(CalcLineAmount, Currency."Amount Rounding Precision");
                            //"VAT Base Amount" := Amount;
                            // IF "Use Tax" THEN
                            //    "Amount Including VAT" := Amount
                            //ELSE
                            "Amount Including VAT" :=
                              TotalAmount + Amount +
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                  TotalAmount + "VAT Base Amount", TotalQuantityBase + "Quantity (Base)",
                                  PurchHeader."Currency Factor"),
                                Currency."Amount Rounding Precision") -
                              TotalAmountInclVAT;

                            IF "VAT Base Amount" <> 0 THEN
                                "VAT %" :=
                                  ROUND(100 * ("Amount Including VAT" - Amount) / "VAT Base Amount", 0.00001)
                            ELSE
                                "VAT %" := 0;
                        END;
                END;
        END;
        //PRJ-196 VT 08-04-20 end


    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignHeaderValues', '', false, false)]
    local procedure NS_T39OnAfterAssignHeaderValues(VAR PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        StdText: Record "Standard Text";
        RecId: RecordId;
    begin
        p.NS_T39SetStdTextRecId(RecId);
        with PurchLine do begin
            p.NS_T39SetNo_PurchaseLine(PurchLine);
            if Type = Type::Resource then begin
                if not StdText.FindFirst() then begin
                    StdText.Code := 'DUMY';
                    StdText.Insert();
                    p.NS_T39SetStdTextRecId(StdText.RecordId());
                end;
                Type := Type::" ";
                "No." := StdText.Code;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignFieldsForNo', '', false, false)]
    LOCAL procedure NS_T39OnAfterAssignFieldsForNo(VAR PurchLine: Record "Purchase Line"; VAR xPurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        RecId: RecordId;
        StdText: Record "Standard Text";
        OrigPurchLine: Record "Purchase Line";
        NS_Resource: Record Resource;
        NS_ResourceFindPrice: Codeunit "Resource-Find Price";
        NS_ResourceFindCost: Codeunit "Resource-Find Cost";
        PPEventSubsCodeunits: Codeunit "NS_Event Subscr. Codeunits";
    begin
        with PurchLine do begin
            p.NS_T39GetNo_PurchaseLine(OrigPurchLine);
            if OrigPurchLine.Type = OrigPurchLine.Type::Resource then begin
                Type := OrigPurchLine.Type::Resource;
                "No." := OrigPurchLine."No.";
                p.NS_T39GetStdTextRecId(RecId);
                if StdText.Get(RecId) then //remove DUMY record
                    StdText.Delete();
                case Type of
                    Type::"G/L Account":
                        GetJobCosts;
                    Type::Resource:
                        begin
                            NS_Resource.GET("No.");
                            NS_Resource.TESTFIELD(Blocked, FALSE);
                            NS_Resource.TESTFIELD("Gen. Prod. Posting Group");
                            Description := NS_Resource.Name;
                            "Description 2" := NS_Resource."Name 2";
                            "NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";//PRJ-249 AS1.0 29-04-20
                            VALIDATE("Unit of Measure Code", NS_Resource."Base Unit of Measure");
                            "Direct Unit Cost" := NS_Resource."Unit Cost";
                            "Unit Cost (LCY)" := NS_Resource."Unit Cost";
                            GetJobCosts;//Project Pro
                            "Indirect Cost %" := NS_Resource."Indirect Cost %";
                            "Gen. Prod. Posting Group" := NS_Resource."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := NS_Resource."VAT Prod. Posting Group";
                            "Tax Group Code" := NS_Resource."Tax Group Code";
                            PPEventSubsCodeunits.NS_C221FindResUnitPricePurchLine(PurchLine);
                            PPEventSubsCodeunits.NS_C220FindResUnitCostPurchLine(PurchLine);
                            UpdateUnitCost;
                            VALIDATE("VAT Prod. Posting Group");
                            VALIDATE("Direct Unit Cost");
                        end;
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, 39, 'OnValidateTypeOnCopyFromTempPurchLine', '', false, false)]
    local procedure NS_T39OnValidateTypeOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchLineTypeEnum: enum "Purchase Line Type";
    begin
        with PurchLine do begin
            PurchaseHeader.Get("Document Type", "Document No.");
            //ProjectPro - start
            if (Type <> PurchLineTypeEnum::" ") AND (Type <> PurchLineTypeEnum::"Fixed Asset") then begin //PRJ-490.AM.1.0
                Validate("Job No.", PurchaseHeader."NS_Job No.");
                "Job Task No." := TempPurchaseLine."Job Task No.";
                "NS_Job Cost Category" := TempPurchaseLine."NS_Job Cost Category";
            end else //PRJ-490.AM.1.0 start
                     // if Type = PurchLineTypeEnum::"Fixed Asset" then begin //PRJ-665.N.S.1.0 Comment
                     //     validate("NS_FA Job Usage", true);//PRJ-665.N.S.1.0 Comment
                     //     Validate("NS_FA Job No.", PurchaseHeader."NS_Job No.");//PRJ-665.N.S.1.0 Comment
                     // end;//PRJ-490.AM.1.0 End //PRJ-665.N.S.1.0 Comment
                     //PRJ-665.N.S.1.0 Start
                if (Type = PurchLineTypeEnum::"Fixed Asset") AND (PurchaseHeader."NS_Job No." <> '') then begin
                    validate("NS_FA Job Usage", true);
                    Validate("NS_FA Job No.", PurchaseHeader."NS_Job No.");
                end;
            //PRJ-665.N.S.1.0 END
            //ProjectPro - end
        end;
    end;

    //PPNA16.0 Comment Start  Will try to do this on page level
    // [EventSubscriber(ObjectType::Table, 39, 'OnJobTaskNoOnLookup', '', false, false)]
    // LOCAL procedure T39OnJobTaskNoOnLookup(VAR PurchLine: Record "Purchase Line")
    // var
    //     NS_JobTaskLines: page "Job Task Lines";
    //     NS_JobTask: Record "Job Task";
    // begin
    //     with PurchLine do begin
    //         CLEAR(NS_JobTaskLines);
    //         NS_JobTaskLines.LOOKUPMODE(TRUE);
    //         NS_JobTaskLines.NS_SetJobNo("Job No.");
    //         NS_JobTask.SETRANGE("Job No.", "Job No.");
    //         NS_JobTaskLines.SETTABLEVIEW(NS_JobTask);
    //         IF NS_JobTaskLines.RUNMODAL = ACTION::LookupOK THEN
    //             "Job Task No." := NS_JobTaskLines.NS_GetTask;
    //         VALIDATE("Job Task No.");
    //     end;
    // end;
    //PPNA16.0 Comment End

    [EventSubscriber(ObjectType::Table, 39, 'OnValidateNoOnBeforeInitRec', '', false, false)]
    local procedure NS_T39OnValidateNoOnBeforeInitRec(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer)
    var
        ParamsForTables: Codeunit "NS_Parameters for Table Events";
    begin
        //ProjectPro - start
        ParamsForTables.NS_T39SetNS_JobCurrencyCodeHold(PurchaseLine."Job Currency Code");
        ParamsForTables.NS_T39SetNS_JobCurrencyFactorHold(PurchaseLine."Job Currency Factor");
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure NS_T39OnAfterInitOutstandingQty(var PurchaseLine: Record "Purchase Line")
    begin
        with PurchaseLine do begin
            if "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] then begin
                //ProjectPro - start
                "NS_Committed Quantity" := Quantity - "Return Qty. Shipped";
                "NS_Committed Qty. (Base)" := "Quantity (Base)" - "Return Qty. Shipped (Base)";
                //ProjectPro - end
            end else begin
                //ProjectPro - start
                "NS_Committed Quantity" := Quantity - "Quantity Invoiced";
                "NS_Committed Qty. (Base)" := "Quantity (Base)" - "Qty. Invoiced (Base)";
                //ProjectPro - end
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure NS_T39OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        with PurchLine do begin
            "Job Currency Factor" := TempPurchaseLine."Job Currency Factor";
            "Job Currency Code" := TempPurchaseLine."Job Currency Code";
            "Job Task No." := TempPurchaseLine."Job Task No.";
            "NS_Job Cost Category" := TempPurchaseLine."NS_Job Cost Category";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterInitOutstandingAmount', '', false, false)]
    local procedure NS_T39OnAfterInitOutstandingAmount(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; Currency: Record Currency)
    var
        AmountInclVAT: Decimal;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    begin
        with PurchLine do begin
            if Quantity = 0 then begin
                //ProjectPro - start
                "NS_Committed Amount" := 0;
                "NS_Committed Amount (LCY)" := 0;
                //ProjectPro - end
            end else begin
                IF PurchHeader."Prices Including VAT" THEN
                    AmountInclVAT := "Line Amount" - "Inv. Discount Amount"
                ELSE
                    IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                        IF NOT "Tax Liable" THEN
                            OnBeforeSetTaxToBeExpensed(PurchLine); //PPDA.1.0 Added
                        //"Tax To Be Expensed" := 0; //PPDA.1.0 Commented
                        IF "Use Tax" THEN
                            AmountInclVAT := CalcLineAmount
                        ELSE
                            AmountInclVAT :=
                              CalcLineAmount +
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                  CalcLineAmount, "Quantity (Base)", PurchHeader."Currency Factor"),
                                Currency."Amount Rounding Precision")
                    END ELSE
                        AmountInclVAT :=
                          ROUND(
                            CalcLineAmount * (1 + "VAT %" / 100 * (1 - PurchHeader."VAT Base Discount %" / 100)),
                            Currency."Amount Rounding Precision");

                //ProjectPro - start
                VALIDATE(
                  "NS_Committed Amount",
                  ROUND(
                    AmountInclVAT * "NS_Committed Quantity" / Quantity,
                    Currency."Amount Rounding Precision"));
                //ProjectPro - end
            end;

            //ProjectPro - start
            NS_SetRetentionBase;
            //ProjectPro - end
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure NS_T39OnAfterInitHeaderDefaults(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        NS_JobsSetup: Record "Jobs Setup";
    begin
        with PurchLine do begin
            if Type <> Type::"Fixed Asset" then //PRJ-490.Am.1.0
                Validate("Job No.", PurchHeader."NS_Job No.")
            else begin
                // "NS_FA Job Usage" := true;//PRJ-665.N.S.1.0 Comment
                // Validate("NS_FA Job No.", PurchHeader."NS_Job No.")//PRJ-490.Am.1.0 //PRJ-665.N.S.1.0 Comment
                if PurchHeader."NS_Job No." <> '' then begin //PRJ-665.N.S.1.0
                    "NS_FA Job Usage" := true; //PRJ-665.N.S.1.0 Comment
                    Validate("NS_FA Job No.", PurchHeader."NS_Job No.");//PRJ-665.N.S.1.0 Comment
                end; //PRJ-665.N.S.1.0
            end;


            //PRJ-145.SK.1.0 Start
            // if "Job No." <> '' then begin
            //     NS_JobsSetup.Get;
            //     "Gen. Bus. Posting Group" := NS_JobsSetup."Gen. Bus. Posting Group";

            //end;
            //PRJ-145.SK.1.0 End
        end;
    end;

    //PRJ-145.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure NS_T38ValidateGenBusPosGrp(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    var
        VendorRec: Record Vendor;
        NS_JobSetup: Record "Jobs Setup";
        Job: Record Job;
        PurchHeader: Record "Purchase Header";
    begin
        NS_JobSetup.Get();
        IF PurchHeader.get(Rec."Document Type", Rec."No.") then;

        IF NS_JobSetup."NS_Gen. Bus. Posting Group" <> '' then
            Rec.VALIDATE(Rec."Gen. Bus. Posting Group", NS_JobSetup."NS_Gen. Bus. Posting Group")
        else
            IF VendorRec.get(PurchHeader."Buy-from Vendor No.") then
                IF VendorRec."Gen. Bus. Posting Group" <> '' then
                    Rec.VALIDATE(Rec."Gen. Bus. Posting Group", VendorRec."Gen. Bus. Posting Group");

        IF job.Get(PurchHeader."NS_Job No.") then//PRJ-488.MS.1.0 changes place of code and jobsetp to job 
            // IF job."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
            //     Rec.VALIDATE(Rec."Gen. Bus. Posting Group", Job."NS_Gen. Bus. Posting Group"); //PRJ-831.AS.1.0 12OCT2021 Comment old
                     IF job."NS_Gen. Bus. Posting Group New" <> '' then //PRJ-831.AS.1.0 12OCT2021 Add New
                Rec.VALIDATE(Rec."Gen. Bus. Posting Group", Job."NS_Gen. Bus. Posting Group New"); //PRJ-831.AS.1.0 12OCT2021 Add New
    end;
    //PRJ-145.SK.1.0 End

    //PRJ-131.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure NS_T36ValidateGenBusPosGrp(var Rec: Record "Sales Header")
    var
        CustomerRec: Record Customer;
        NS_JobSetup: Record "Jobs Setup";
        Job: Record Job;
        SalesHeader: Record "Sales Header";
    begin
        NS_JobSetup.Get();
        IF SalesHeader.get(Rec."Document Type", Rec."No.") then;
        IF Job.Get(SalesHeader."NS_Job No.") then
            // IF job."NS_Gen. Bus. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
            IF job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                Rec.VALIDATE(Rec."Gen. Bus. Posting Group", NS_JobSetup."NS_Gen. Bus. Posting Group");
        IF NS_JobSetup."NS_Gen. Bus. Posting Group" <> '' then
            Rec.VALIDATE(Rec."Gen. Bus. Posting Group", NS_JobSetup."NS_Gen. Bus. Posting Group")
        else
            IF CustomerRec.get(SalesHeader."Sell-to Customer No.") then
                IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                    Rec.VALIDATE(Rec."Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group")
    end;
    //PRJ-131.SK.1.0 End

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterAssignItemValues', '', false, false)]
    local procedure NS_T39OnAfterAssignItemValues(var PurchLine: Record "Purchase Line"; Item: Record Item)
    var
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        with PurchLine do begin
            //ProjectPro - start
            GetJobCosts;
            //ProjectPro - end
            if Item."Price Includes VAT" then begin
                if not VATPostingSetup.Get(Item."VAT Bus. Posting Gr. (Price)", Item."VAT Prod. Posting Group") then
                    VATPostingSetup.Init;
                case VATPostingSetup."VAT Calculation Type" of
                    VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                        VATPostingSetup."VAT %" := 0;
                end;
                GLSetup.Get();
                "Unit Price (LCY)" :=
                  Round("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
            end;

            //ProjectPro - start
            "NS_Job Cost Category" := Item."NS_Job Cost Category";
            //ProjectPro - end
        end;
    end;

    //PRJ-52.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'Job No.', False, False)]
    local procedure NS_T39BeforeJobNoValidate(var Rec: Record "Purchase Line")
    begin
        IF Rec."Job No." <> '' then begin
            p.NS_SetTypeBeforeJobNoValidate(Rec.Type.AsInteger());
            Rec.Type := Rec.Type::"G/L Account" //Passing Type as GLAccount so code will not trigger FIELDERROR
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Job No.', False, False)]
    local procedure NS_T39AfterJobNoValidate(var Rec: Record "Purchase Line")
    begin
        IF Rec."Job No." <> '' then
            Rec.Type := p.NS_GetTypeBeforeJobNoValidate(); //Passing Type as GLAccount so code will not trigger FIELDERROR

    end;

    //PRJ-52.SK.1.0 End




    [EventSubscriber(ObjectType::Table, 39, 'OnUpdateDirectUnitCostOnBeforeFindPrice', '', false, false)]
    LOCAL procedure NS_T39OnUpdateDirectUnitCostOnBeforeFindPrice(PurchaseHeader: Record "Purchase Header"; VAR PurchaseLine: Record "Purchase Line"; CalledByFieldNo: Integer; CallingFieldNo: Integer; VAR IsHandled: Boolean)
    begin
        with PurchaseLine do
            IF CalledByFieldNo IN [FIELDNO("No."), FIELDNO("Variant Code"), FIELDNO("Location Code")] THEN
                IF Type = Type::Item then //PPAL-73.SK.1.0 Added
                    SetVendorItemNo;
    end;


    //PPNA16.0 Modified event start
    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeUpdateDirectUnitCost', '', false, false)]
    local procedure NS_T39OnBeforeUpdateDirectUnitCostOnUpdateUOMQtyPerStockQty(var PurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        PurchaseHeader: Record "Purchase Header";
    begin
        IF PurchaseHeader.Get(PurchLine."Document Type", PurchLine."Document No.") Then;
        IF (CurrFieldNo = PurchLine.FieldNo("Unit of Measure Code")) AND (CalledByFieldNo = PurchLine.FieldNo("Unit of Measure Code")) THEN
            with PurchLine do begin
                if PurchaseHeader."Currency Code" <> '' then begin
                    //ProjectPro - start                
                    "Unit Price (LCY)" :=
                        CurrExchRate.ExchangeAmtLCYToFCY(
                        GetDate, PurchaseHeader."Currency Code",
                        PurchLine."Unit Price (LCY)", PurchaseHeader."Currency Factor");
                    //ProjectPro - end
                end;
                //ProjectPro - start
                if PurchaseHeader."NS_Job No." <> '' then begin
                    GetJobCosts;
                    if PurchaseHeader."Currency Code" <> '' then begin
                        "Unit Cost" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            GetDate, PurchaseHeader."Currency Code",
                            PurchLine."Unit Cost (LCY)", PurchaseHeader."Currency Factor");
                        "Unit Price (LCY)" :=
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              GetDate, PurchaseHeader."Currency Code",
                              PurchLine."Unit Price (LCY)", PurchaseHeader."Currency Factor");
                    end else
                        "Unit Cost" := "Unit Cost (LCY)";
                end;
                //ProjectPro - end
            end;
    end;
    //PPNA16.0 Modified event End

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 39, 'OnAfterUpdateVATOnLines', '', false, false)]
    local procedure NS_T39OnAfterQtyTypeCheckOnUpdateVATOnLines(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; QtyType: Option General,Invoicing,Shipping)
    begin
        if QtyType = QtyType::General then
            //ProjectPro - start
            PurchLine.NS_AdjustVATBaseAmount();
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPDA.1.0 Sart
    //PPNA16.0 Modified Event Start
    // [EventSubscriber(ObjectType::Table, 39, 'OnAfterCalcVATAmountLines', '', false, false)]
    // local procedure NS_T39TOnBeforeCheckIfVATAmtLineExistsOnCalcVATAmountLines(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; var VATAmountLine: Record "VAT Amount Line")
    // begin
    //     //ProjectPro - start
    //     if not VATAmountLine.Get(PurchLine."VAT Identifier", PurchLine."VAT Calculation Type",
    //                              PurchLine."Tax Group Code", PurchLine."Tax Area Code", PurchLine."Use Tax", PurchLine."Line Amount" >= 0)
    //                              then
    //         VATAmountLine."NS_Retention Percent" := PurchHeader."NS_Retention Percent";
    //     //ProjectPro - end
    // end;
    //PPNA16.0 Modified Event End
    //PPDA.1.0 End

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeJobTaskIsSet', '', false, false)]
    LOCAL procedure NS_T39OnBeforeJobTaskIsSet(PurchLine: Record "Purchase Line"; VAR IsJobLine: Boolean)
    begin
        with PurchLine do
            IsJobLine := ("Job No." <> '') AND (Type IN [Type::"G/L Account", Type::Item]);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterFilterLinesWithItemToPlan', '', false, false)]
    local procedure NS_T39OnAfterFilterLinesWithItemToPlan(var PurchaseLine: Record "Purchase Line")
    begin
        //ProjectPro - start
        if not PurchaseLine.GetJobDemandOnly then
            PurchaseLine.SetFilter("Job No.", '=%1', '');
        //ProjectPro - end
    end;


    //PPNA17.0 Opened Start OnCreateTempJobJnlLineCustom1 
    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeCreateTempJobJnlLine', '', false, false)]
    LOCAL procedure NS_T39OnCreateTempJobJnlLineCustom1(var TempJobJournalLine: Record "Job Journal Line"; PurchaseLine: Record "Purchase Line"; GetPrices: Boolean; xPurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    Var
        PurchHeader: Record "Purchase Header";
    begin
        IF PurchHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") Then;
        Clear(TempJobJournalLine);
        TempJobJournalLine.DontCheckStdCost;
        TempJobJournalLine.Validate("Job No.", PurchaseLine."Job No.");
        TempJobJournalLine.Validate("Job Task No.", PurchaseLine."Job Task No.");
        TempJobJournalLine.Validate("Posting Date", PurchHeader."Posting Date");
        if PurchaseLine."Job Currency Factor" <> 0 then //PRJ-613 N.S.1.0
            TempJobJournalLine.SetCurrencyFactor(PurchaseLine."Job Currency Factor");
        if PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
            TempJobJournalLine.Validate(Type, TempJobJournalLine.Type::"G/L Account")
        else
            IF PurchaseLine.Type = PurchaseLine.Type::Resource THEN  //PRJ-470.MS.1.0 added below code
                TempJobJournalLine.VALIDATE(Type, TempJobJournalLine.Type::Resource)
            else
                IF PurchaseLine.Type = PurchaseLine.Type::NS_Ledger THEN  //PRJ-470.MS.1.0 added below code
                    TempJobJournalLine.VALIDATE(Type, TempJobJournalLine.Type::NS_Ledger)
                else
                    TempJobJournalLine.Validate(Type, TempJobJournalLine.Type::Item);
        TempJobJournalLine.Validate("NS_Job Cost Category", PurchaseLine."NS_Job Cost Category");//PRJ-212 VT1.0 22-0-20 //PRJ-212 VT1.0 22-0-20 //PRJ-268 VT1.0 18-05-20 Code Commented
                                                                                                 //IF PurchaseLine.Type = PurchaseLine.Type::Resource THEN//PRJ-470.MS.1.0 comment
                                                                                                 //TempJobJournalLine.VALIDATE(Type, TempJobJournalLine.Type::Resource);//PRJ-470.MS.1.0 comment
        TempJobJournalLine.Validate("No.", PurchaseLine."No.");
        TempJobJournalLine.Validate(Quantity, PurchaseLine.Quantity);
        TempJobJournalLine.Validate("Variant Code", PurchaseLine."Variant Code");
        TempJobJournalLine.Validate("Unit of Measure Code", PurchaseLine."Unit of Measure Code");

        if not GetPrices then begin
            if xPurchaseLine."Line No." <> 0 then begin
                TempJobJournalLine."Unit Cost" := xPurchaseLine."Unit Cost";
                TempJobJournalLine."Unit Cost (LCY)" := xPurchaseLine."Unit Cost (LCY)";
                TempJobJournalLine."Unit Price" := xPurchaseLine."Job Unit Price";
                TempJobJournalLine."Line Amount" := xPurchaseLine."Job Line Amount";
                TempJobJournalLine."Line Discount %" := xPurchaseLine."Job Line Discount %";
                TempJobJournalLine."Line Discount Amount" := xPurchaseLine."Job Line Discount Amount";
            end else begin
                TempJobJournalLine."Unit Cost" := PurchaseLine."Unit Cost";
                TempJobJournalLine."Unit Cost (LCY)" := PurchaseLine."Unit Cost (LCY)";
                TempJobJournalLine."Unit Price" := PurchaseLine."Job Unit Price";
                TempJobJournalLine."Line Amount" := PurchaseLine."Job Line Amount";
                TempJobJournalLine."Line Discount %" := PurchaseLine."Job Line Discount %";
                TempJobJournalLine."Line Discount Amount" := PurchaseLine."Job Line Discount Amount";
            end;
            TempJobJournalLine.Validate("Unit Price");
        end else
            TempJobJournalLine.Validate("Unit Cost (LCY)", PurchaseLine."Unit Cost (LCY)");
        IsHandled := true; //PRJ-470.MS.1.0
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterInvPostBufferPrepareSales', '', false, false)]
    local procedure NS_T49OnAfterInvPostBufferPrepareSales(var SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        //ProjectPro - start
        InvoicePostBuffer."NS_Job Task No." := SalesLine."Job Task No.";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 49, 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure NS_T49OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
        //ProjectPro - start
        InvoicePostBuffer."NS_Job Task No." := PurchaseLine."Job Task No.";
        //ProjectPto - end
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterValidateEvent', 'Account Type', false, false)]
    local procedure NS_T81OnAfterValidateAccountType(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";//PRJ-230.AS.1.0 - 21APRIL2020
    begin
        //ProjectPro - start
        if (Rec."Account Type" = Rec."Account Type"::Vendor) and (Rec."NS_Retention Ledger Code" = '') then begin
            PurchSetup.Get;
            Rec."NS_Retention Ledger Code" := PurchSetup."NS_Normal Vendor Ledger No.";
        end;
        //ProjectPro - end

        //PRJ-230.AS.1.0 - 21APRIL2020 - start
        if (Rec."Account Type" = Rec."Account Type"::Customer) and (Rec."NS_Retention Ledger Code" = '') then begin
            SalesSetup.Get;
            Rec."NS_Retention Ledger Code" := SalesSetup."NS_Normal Customer Ledger No.";
        end;
        //PRJ-230.AS.1.0 - 21APRIL2020 - end
    end;




    //PPDA.1.0 Start
    // //PPNA17.0 Opened Start OnAccountNoValidateBeforeCreateDim 
    // [EventSubscriber(ObjectType::Table, 81, 'OnAccountNoOnValidateOnBeforeCreateDim', '', false, false)]
    // local procedure NS_OnAccountNoValidateBeforeCreateDim(var isHandled: Boolean; var GenJournalLine: Record "Gen. Journal Line")
    // var
    //     GenJnlTemplate: Record "Gen. Journal Template";
    // begin
    //     isHandled := false;
    //     IF GenJournalLine."Journal Template Name" <> '' THEN BEGIN
    //         GenJnlTemplate.GET(GenJournalLine."Journal Template Name");
    //         IF GenJnlTemplate.Type = GenJnlTemplate.Type::Deposits THEN
    //             isHandled := true;
    //     END;
    // end;
    //PPNA17.0 Opened End
    //PPDA.1.0 End


    //PPNA17.0 Opened Start OnBeforeSetCustLedgEntryFilterOnAppliesToDocNoValidate 
    [EventSubscriber(ObjectType::Table, 81, 'OnAppliesToDocNoOnValidateOnAfterCustLedgEntrySetFilters', '', false, false)]
    local procedure NS_T81OnBeforeSetCustLedgEntryFilterOnAppliesToDocNoValidate(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgerEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnBeforeSetVendLedgEntryFilterOnAppliesToDocNoValidate 
    [EventSubscriber(ObjectType::Table, 81, 'OnAppliesToDocNoOnValidateOnAfterVendLedgEntrySetFilters', '', false, false)]
    local procedure NS_T81OnBeforeSetVendLedgEntryFilterOnAppliesToDocNoValidate(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //ProjectPro - start
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            VendorLedgerEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End


    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCreateDimTableIDs', '', false, false)]
    //local procedure T81OnAfterCreateDimTableIDs(var GenJournalLine: Record "Gen. Journal Line"; FieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    local procedure NS_T81OnAfterCreateDimTableIDs(var GenJournalLine: Record "Gen. Journal Line"; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    var
        ParamsForTables: Codeunit "NS_Parameters for Table Events";
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        NS_PurchSetup.Get();
        //ProjectPro - start
        if (not NS_PurchSetup."NS_Purchase Retention Inactive") and (GenJournalLine."NS_Retention Ledger Code" > '') then
            GenJournalLine.Validate("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //ProjectPro - end
    end;




    //PPNA17.0 Opened Start OnAfterFindFirstCustLedgEntryWithAppliesToID 
    [EventSubscriber(ObjectType::Table, 81, 'OnFindFirstCustLedgEntryWithAppliesToIDOnAfterSetFilters', '', false, false)]
    local procedure NS_T81OnAfterFindFirstCustLedgEntryWithAppliesToID(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnAfterFindFirstVendLedgEntryWithAppliesToID 
    [EventSubscriber(ObjectType::Table, 81, 'OnFindFirstVendLedgEntryWithAppliesToIDOnAfterSetFilters', '', false, false)]
    local procedure NS_T81OnAfterFindFirstVendLedgEntryWithAppliesToID(var GenJournalLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry")
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //ProjectPro - start
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            VendLedgEntry.SetRange("NS_Retention Ledger Code", GenJournalLine."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    //[EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyFromPaymentCustLedgEntry', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 367, 'OnUnApplyCustInvoicesOnBeforePost', '', false, false)]
    local procedure NS_T81OnUnApplyCustInvoicesOnBeforePost(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        //ProjectPro - start
        GenJournalLine."NS_Retention Ledger Code" := CustLedgerEntry."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    //[EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyFromPaymentVendLedgEntry', '', false, false)]
    [EventSubscriber(ObjectType::Codeunit, 367, 'OnUnApplyVendInvoicesOnBeforePost', '', false, false)]
    local procedure NS_T81OnUnApplyVendInvoicesOnBeforePost(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        //ProjectPro - start
        GenJournalLine."NS_Retention Ledger Code" := VendorLedgerEntry."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerAccount', '', false, false)]
    //local procedure T81OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    local procedure NS_T81OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            GenJournalLine."NS_Retention Ledger Code" := NS_SalesSetup."NS_Normal Customer Ledger No.";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorAccount', '', false, false)]
    //local procedure T81OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    local procedure NS_T81OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; CallingFieldNo: Integer)
    var
        NS_PurchSetup: Record "Purchases & Payables Setup";
    begin
        //ProjectPro - start
        NS_PurchSetup.Get;
        if not NS_PurchSetup."NS_Purchase Retention Inactive" then
            GenJournalLine."NS_Retention Ledger Code" := NS_PurchSetup."NS_Normal Vendor Ledger No.";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure NS_T83OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        //ProjectPro - Start
        ItemJnlLine.NS_Category := PurchLine."NS_Job Cost Category";
        ItemJnlLine."NS_Job Currency Code" := ItemJnlLine."NS_Job Currency Code";
        ItemJnlLine."NS_Job Currency Factor" := ItemJnlLine."NS_Job Currency Factor";
        //ProjectPro - End
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromServHeader', '', false, false)]
    local procedure NS_T83OnAfterCopyItemJnlLineFromServHeader(var ItemJnlLine: Record "Item Journal Line"; ServHeader: Record "Service Header")
    begin
        //ProjectPro - start
        ItemJnlLine."Posting Date" := ServHeader."Posting Date";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromJobJnlLine', '', false, false)]
    local procedure NS_T83OnAfterCopyItemJnlLineFromJobJnlLine(var ItemJournalLine: Record "Item Journal Line"; JobJournalLine: Record "Job Journal Line")
    begin
        //ProjectPro - start
        ItemJournalLine."NS_Retention Ledger Code" := JobJournalLine."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 156, 'OnAfterValidateEvent', 'Use Time Sheet', false, false)]
    local procedure NS_T156OnAfterValidateUseTimeSheet(var Rec: Record Resource; var xRec: Record Resource; CurrFieldNo: Integer)
    var
        NS_HRSetup: Record "Human Resources Setup";
        NS_Employee: Record Employee;
        Text14021100: Label 'This resource cannot be set to %1 until it has first been assigned to an employee.';
    begin
        //ProjectPro - start
        NS_HRSetup.Get;
        if NS_HRSetup."NS_Advanced Job Labor isActive" then begin
            if Rec."Use Time Sheet" then begin
                NS_HRSetup.Get();
                if NS_HRSetup."NS_Advanced Job Labor isActive" then begin
                    NS_Employee.Reset;
                    NS_Employee.SetCurrentKey("Resource No.");
                    NS_Employee.SetRange("Resource No.", Rec."No.");
                    if NS_Employee.IsEmpty then
                        Error(Text14021100, Rec.FieldCaption("Use Time Sheet"));
                end;
            end;
        end;
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 207, 'OnAfterCopyResJnlLineFromJobJnlLine', '', false, false)]
    local procedure NS_T207OnAfterCopyResJnlLineFromJobJnlLine(var ResJnlLine: Record "Res. Journal Line"; JobJnlLine: Record "Job Journal Line")
    begin
        //ProjectPro - start
        ResJnlLine."NS_Retention Ledger Code" := JobJnlLine."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 210, 'OnBeforeUpdateAllAmounts', '', false, false)]
    LOCAL procedure NS_T210OnBeforeUpdateAllAmounts(VAR JobJournalLine: Record "Job Journal Line"; xJobJournalLine: Record "Job Journal Line")
    var
        Currency: Record Currency;
    begin
        with JobJournalLine do begin
            UpdateCostFactor();
            IF "Currency Code" <> '' THEN
                Currency.GET("Currency Code")
            else
                Currency.InitRoundingPrecision;
            IF ("Cost Factor" <> 0) THEN
                "Unit Price" := ROUND("Unit Cost" * "Cost Factor", Currency."Unit-Amount Rounding Precision");
        end;
    end;

    [EventSubscriber(ObjectType::Table, 210, 'OnBeforeRetrieveCostPrice', '', false, false)]
    LOCAL procedure NS_T210OnBeforeRetrieveCostPrice(JobJournalLine: Record "Job Journal Line"; xJobJournalLine: Record "Job Journal Line"; VAR ShouldRetrieveCostPrice: Boolean)
    var
        ParametersForEvents: Codeunit "NS_Parameters for Table Events";
    begin
        //PPNA16.0 Added Start
        ParametersForEvents.NS_SetT210FieldsOnBeforeRetrieveCostPrice(JobJournalLine."Job Task No.",
        JobJournalLine."Job No.",
        JobJournalLine."Currency Code");
        //PPNA16.0 Added End
        with JobJournalLine do begin
            CASE Type OF
                Type::Resource:
                    IF ("No." <> xJobJournalLine."No.") OR
                       ("Work Type Code" <> xJobJournalLine."Work Type Code") OR
                       //ProjectPro - start
                       ("NS_Skill Class" <> xJobJournalLine."NS_Skill Class") OR
                       (Quantity <> xJobJournalLine.Quantity) OR
                       //ProjectPro - end
                       ("Unit of Measure Code" <> xJobJournalLine."Unit of Measure Code")
                    THEN
                        ShouldRetrieveCostPrice := true;
                //PRJ-232 VT1.0 16-04-20
                Type::"G/L Account":
                    //ProjectPro - start
                    //ShouldRetrieveCostPrice := "No." <> TempNo; //PRJ-232 VT1.0 16-04-20
                    ShouldRetrieveCostPrice := ("No." <> xJobJournalLine."No.");// or ("Job Cost Category" <> xJobJournalLine."Job Cost Category");//PRJ-232 VT1.0 16-04-20
            //ProjectPro - end    
            end;
        end;
    end;

    //PRJ-158/159 VT 25-03-20 Begin
    [EventSubscriber(ObjectType::Codeunit, 220, 'OnBeforeFindResUnitCost', '', false, false)]
    LOCAL procedure NS_T210OnBeforeResourceFindCost(var ResourceCost: Record "Resource Cost")
    var
        ParametersForTableEvents: Codeunit "NS_Parameters for Table Events";
        JobTaskNo: Code[20];
        JobNo: Code[20];
        CurrencyCode: code[10];
    begin
        ParametersForTableEvents.NS_GetT210FieldsOnBeforeFindResUnitCost(JobTaskNo, JobNo, CurrencyCode);
        ResourceCost."NS_Job No." := JobNo;
        ResourceCost."NS_Job Task No." := JobTaskNo;
        ResourceCost."NS_Currency Code" := CurrencyCode;
    end;

    //PRJ-158/159 VT 25-03-20 end

    //PRJ-158/159 VT 25-03-20 begin Code Commented
    // [EventSubscriber(ObjectType::Table, 210, 'OnUpdateUnitCostCustom1', '', false, false)]
    /* [EventSubscriber(ObjectType::Table, 210, 'OnAfterResourceFindCost', '', false, false)]
    LOCAL procedure T210OnAfterResourceFindCost(var JobJournalLine: Record "Job Journal Line"; var ResourceCost: Record "Resource Cost")
    begin
        with JobJournalLine do begin
            ResourceCost."Job No." := "Job No.";
            ResourceCost."Job Task No." := "Job Task No.";
            ResourceCost."Currency Code" := "Currency Code";
        end;
    end; */
    //PRJ-158/159 VT 25-03-20 end Code Commented

    //PRJ-163.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnValidateJobNoOnBeforeCheckJob', '', false, false)]
    local procedure NS_T210ByPassValidateOnNo(var JobJournalLine: Record "Job Journal Line"; var IsHandled: Boolean; var Customer: Record Customer)
    var
        PPJob: Record job;
    begin
        IF PPJob.Get(JobJournalLine."Job No.") Then begin
            PPJob.TESTFIELD("Bill-to Customer No.");
            Customer.GET(PPJob."Bill-to Customer No.");
        end else
            JobJournalLine.Validate("Job Task No.", '');
        IsHandled := True;
    end;
    //PRJ-163.SK.1.0 End





    [EventSubscriber(ObjectType::Table, 210, 'OnAfterAssignItemValues', '', false, false)]
    LOCAL procedure NS_T210OnAfterAssignItemValues(VAR JobJournalLine: Record "Job Journal Line"; Item: Record Item)
    begin
        JobJournalLine."NS_Job Cost Category" := Item."NS_Job Cost Category";
    end;

    [EventSubscriber(ObjectType::Table, 210, 'OnAfterAssignResourceValues', '', false, false)]
    LOCAL procedure NS_T210OnAfterAssignResourceValues(VAR JobJournalLine: Record "Job Journal Line"; Resource: Record Resource)
    begin
        with JobJournalLine do begin
            //PRJ-163.SK.1.0 Start
            // "Time Sheet No." := p.T210GetTimeSheetNo();
            // //ProjectPro - start
            // IF "Time Sheet No." = '' THEN
            //     Resource.TESTFIELD("Use Time Sheet", FALSE);
            //PRJ-163.SK.1.0 End
            "NS_Job Cost Category" := Resource."NS_Job Cost Category";
            "NS_Job Revenue Category" := Resource."NS_Job Revenue Category";
            NS_AssignPayrollWorkState;
            NS_AssignDefaultSkillClass;
            NS_CalculateWageRate;
            IF "Time Sheet No." = 'DUMY' Then
                "Time Sheet No." := ''; //PRJ-163.SK.1.0 Added
            //ProjectPro - end
        end;
    end;

    [EventSubscriber(ObjectType::Table, 210, 'OnAfterAssignGLAccountValues', '', false, false)]
    LOCAL procedure NS_T210OnAfterAssignGLAccountValues(VAR JobJournalLine: Record "Job Journal Line"; GLAccount: Record "G/L Account")
    var
        NS_Job: Record Job;
    begin
        with JobJournalLine do begin
            //ProjectPro - start
            "Unit Cost (LCY)" := NS_Job.GetJobGLCost("No.", "NS_Job Cost Category", "Job No.", "Job Task No.", "Currency Code");
            //SPLN  NS_UnitCostLCYHold := "Unit Cost (LCY)";
            "Direct Unit Cost (LCY)" := "Unit Cost (LCY)";
            JobJournalLine.PopulateJobRelatedFields();//PRJ-211 VT1.0 20-04-20
            //ProjectPro - end
        end;
    end;

    [EventSubscriber(ObjectType::Table, 210, 'OnAfterSetUpNewLine', '', false, false)]
    LOCAL procedure NS_T210OnAfterSetUpNewLine(VAR JobJournalLine: Record "Job Journal Line"; LastJobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; JobJournalBatch: Record "Job Journal Batch")
    var
        JobJnlLine: Record "Job Journal Line";
    begin
        JobJnlLine.SETRANGE("Journal Template Name", JobJournalLine."Journal Template Name");
        JobJnlLine.SETRANGE("Journal Batch Name", JobJournalLine."Journal Batch Name");
        IF JobJnlLine.FINDFIRST THEN BEGIN
            //ProjectPro - start
            IF JobJournalBatch."NS_Auto-F8 Job No." THEN
                IF LastJobJournalLine."Job No." <> '' THEN
                    JobJournalLine.VALIDATE("Job No.", LastJobJournalLine."Job No.");
            IF JobJournalBatch."NS_Auto-F8 Job Task No." THEN
                IF LastJobJournalLine."Job Task No." <> '' THEN
                    JobJournalLine."Job Task No." := LastJobJournalLine."Job Task No.";
            //ProjectPro - end
        END;
    end;


    //PPNA17.0 Opened Start OnSetReplenishmentSystemFromProdOrderOnAfterCheckSubcontracting 
    [EventSubscriber(ObjectType::Table, 246, 'OnSetReplenishmentSystemFromProdOrderOnBeforeSetProdFields', '', false, false)]
    local procedure NS_T246OnSetReplenishmentSystemFromProdOrderOnAfterCheckSubcontracting(var RequisitionLine: Record "Requisition Line"; Item: Record Item; Subcontracting: Boolean; PlanningResiliency: Boolean; var TempPlanningErrorLog: Record "Planning Error Log" temporary)
    var
        ProdBOMHeader: Record "Production BOM Header";
        Text033: Label '%1 %2 %3 is not certified.';
    begin
        //ProjectPro - start
        if PlanningResiliency and
          ProdBOMHeader.Get(Item."Production BOM No.") and
          (ProdBOMHeader.Status <> ProdBOMHeader.Status::Certified)
        then begin
            TempPlanningErrorLog.SetError(
              StrSubstNo(
                Text033, ProdBOMHeader.TableCaption,
                ProdBOMHeader.FieldCaption("No."), ProdBOMHeader."No."),
              DATABASE::"Production BOM Header", ProdBOMHeader.GetPosition);
            ProdBOMHeader.TestField(Status, ProdBOMHeader.Status::Certified);
        end;
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnCalcVATFieldsCustom1 
    [EventSubscriber(ObjectType::Table, 290, 'OnAfterCalcVATFields', '', false, false)]
    local procedure NS_OnCalcVATFieldsCustom1(VAR VATAmountLine: Record "VAT Amount Line"; NewPricesIncludingVAT: Boolean; NewVATBaseDiscPct: Decimal)
    begin
        with VATAmountLine do begin
            if NewPricesIncludingVAT and (NewVATBaseDiscPct = 0) then
                "VAT Base" := NS_AdjustVATBaseAmount(VATAmountLine)
            else begin
                "VAT Base" := NS_AdjustVATBaseAmount(VATAmountLine);
                "Amount Including VAT" := "VAT Base" + "VAT Amount";
            end;
        end;
    end;
    //PPNA17.0 Opened End



    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 290, 'OnInsertLineOnBeforeModify', '', false, false)]
    local procedure NS_T290OnAfterCalcVATBaseOnInsertLine(var VATAmountLine: Record "VAT Amount Line")
    begin
        //ProjectPro - start
        VATAmountLine."VAT Base" := VATAmountLine.NS_AdjustVATBaseAmount(VATAmountLine);
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    //PPNA16.0 Modified Event Start Commented Will remove this code once testing done since this code is handled on "OnAfterCalcVATAmountLines" Event
    // [EventSubscriber(ObjectType::Table, 290, 'OnBeforeInsertEvent', '', false, false)]
    // local procedure T290OnAfterSetValuesOnInsertNewLine(var Rec: Record "VAT Amount Line")
    // begin
    //     //ProjectPro - start
    //     Rec."Retention Percent" := Rec.GetRetentionPerc();
    //     //ProjectPro - end
    // end;
    //PPNA16.0 Modified Event End Commented



    //PPNA17.0 Opened Start OnAfterCalcVATBaseOnUpdateLines 
    [EventSubscriber(ObjectType::Table, 290, 'OnUpdateLinesOnBeforeCalcSalesTaxVatBase', '', false, false)]
    local procedure T290OnAfterCalcVATBaseOnUpdateLines(var VATAmountLine: Record "VAT Amount Line")
    begin
        //ProjectPro - start
        //"VAT Base" := "Line Amount" - "Invoice Discount Amount";
        VATAmountLine."VAT Base" := VATAmountLine.NS_AdjustVATBaseAmount(VATAmountLine);
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End


    [EventSubscriber(ObjectType::Table, 296, 'OnBeforeCalcFinChrg', '', false, false)]
    local procedure NS_T296OnBeforeCalcFinChrg(var ReminderLine: Record "Reminder Line"; var ReminderHeader: Record "Reminder Header"; var IsHandled: Boolean)
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        IssuedReminderHeader: Record "Issued Reminder Header";
        FinanceChargeInterestRate: Record "Finance Charge Interest Rate";
        ExtraReminderLine: Record "Reminder Line";
        InterestStartDate: Date;
        LineFee: Decimal;
        UseDueDate: Date;
        UseCalcDate: Date;
        UseInterestRate: Decimal;
        CumAmount: Decimal;
        CustLedgEntry: Record "Cust. Ledger Entry";
        ReminderLevel: Record "Reminder Level";
        FinChrgTerms: Record "Finance Charge Terms";
        CalcInterest: Boolean;
        NrOfLinesToInsert: Integer;
        InterestCalcDate: Date;
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";

    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        NS_PurchSetup.Get;
        //DtldCLE.SETRANGE("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
        ReminderLine.T296GetReminderHeader();
        ReminderLine."Interest Rate" := 0;
        ReminderLine.Amount := 0;
        ReminderLine."VAT Amount" := 0;
        ReminderLine."VAT Calculation Type" := ReminderLine."VAT Calculation Type"::"Normal VAT";
        ReminderLine."Gen. Prod. Posting Group" := '';
        ReminderLine."VAT Prod. Posting Group" := '';
        ExtraReminderLine := ReminderLine;
        ExtraReminderLine.SETRANGE("Reminder No.", ReminderLine."Reminder No.");
        ExtraReminderLine.SETRANGE("Detailed Interest Rates Entry", TRUE);
        ExtraReminderLine.SETRANGE("Entry No.", ReminderLine."Entry No.");
        ExtraReminderLine.DELETEALL;
        CustLedgEntry.GET(ReminderLine."Entry No.");
        IF (CustLedgEntry."On Hold" <> '') OR (ReminderLine."Due Date" >= ReminderHeader."Document Date") THEN
            EXIT;

        ReminderLevel.SETRANGE("Reminder Terms Code", ReminderHeader."Reminder Terms Code");
        IF ReminderHeader."Use Header Level" THEN
            ReminderLevel.SETRANGE("No.", 1, ReminderHeader."Reminder Level")
        ELSE
            ReminderLevel.SETRANGE("No.", 1, ReminderLine."No. of Reminders");
        IF NOT ReminderLevel.FINDLAST THEN
            ReminderLevel.INIT;
        IF (NOT ReminderLevel."Calculate Interest") OR (ReminderHeader."Fin. Charge Terms Code" = '') THEN
            EXIT;
        FinChrgTerms.GET(ReminderHeader."Fin. Charge Terms Code");

        ReminderLine.T296CalcFinanceChargeInterestRate(FinanceChargeInterestRate, UseDueDate, UseInterestRate, UseCalcDate);

        CASE FinChrgTerms."Interest Calculation Method" OF
            FinChrgTerms."Interest Calculation Method"::"Average Daily Balance":
                BEGIN
                    CalcInterest := FALSE;
                    IF NrOfLinesToInsert = 0 THEN
                        FinChrgTerms.TESTFIELD("Interest Period (Days)")
                    ELSE
                        FinanceChargeInterestRate.TESTFIELD("Interest Period (Days)");
                    InterestCalcDate := CustLedgEntry."Due Date";
                    ReminderEntry.SETCURRENTKEY("Customer Entry No.");
                    ReminderEntry.SETRANGE("Customer Entry No.", ReminderLine."Entry No.");
                    ReminderEntry.SETRANGE(Type, ReminderEntry.Type::Reminder);
                    ReminderEntry.SETRANGE("Interest Posted", TRUE);
                    IF ReminderEntry.FINDLAST THEN
                        InterestCalcDate := ReminderEntry."Document Date";
                    ReminderEntry.SETRANGE(Type, ReminderEntry.Type::"Finance Charge Memo");
                    ReminderEntry.SETRANGE("Interest Posted");
                    IF ReminderEntry.FINDLAST THEN
                        IF ReminderEntry."Document Date" > InterestCalcDate THEN
                            InterestCalcDate := ReminderEntry."Document Date";
                    IF InterestCalcDate < ReminderHeader."Document Date" THEN BEGIN
                        CalcInterest := TRUE;
                        DetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
                        DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                        DetailedCustLedgEntry.SETFILTER("Entry Type", '%1|%2|%3|%4|%5',
                          DetailedCustLedgEntry."Entry Type"::"Initial Entry",
                          DetailedCustLedgEntry."Entry Type"::Application,
                          DetailedCustLedgEntry."Entry Type"::"Payment Tolerance",
                          DetailedCustLedgEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                          DetailedCustLedgEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)");
                        DetailedCustLedgEntry.SETRANGE("Posting Date", 0D, ReminderHeader."Document Date");
                        if (not NS_SalesSetup."NS_Sales Retention Inactive") or (not NS_PurchSetup."NS_Purchase Retention Inactive") then
                            DetailedCustLedgEntry.SetRange("NS_Retention Ledger Code", CustLedgEntry."NS_Retention Ledger Code");
                        IF DetailedCustLedgEntry.FIND('-') THEN
                            REPEAT
                                IF DetailedCustLedgEntry."Entry Type" = DetailedCustLedgEntry."Entry Type"::"Initial Entry" THEN
                                    InterestStartDate := CustLedgEntry."Due Date"
                                ELSE
                                    InterestStartDate := DetailedCustLedgEntry."Posting Date";
                                IF InterestCalcDate > InterestStartDate THEN
                                    InterestStartDate := InterestCalcDate;
                                ReminderLine.Amount := ReminderLine.Amount + DetailedCustLedgEntry.Amount * (ReminderHeader."Document Date" - InterestStartDate);
                            UNTIL DetailedCustLedgEntry.NEXT = 0;
                        IF NOT FinChrgTerms."Add. Line Fee in Interest" THEN
                            IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Reminder THEN
                                IF IssuedReminderHeader.GET(CustLedgEntry."Document No.") THEN BEGIN
                                    IssuedReminderHeader.CALCFIELDS("Add. Fee per Line");
                                    LineFee := IssuedReminderHeader."Add. Fee per Line" + IssuedReminderHeader.CalculateLineFeeVATAmount;
                                    ReminderLine.Amount := ReminderLine.Amount - LineFee * (ReminderHeader."Document Date" - InterestStartDate);
                                    IF ReminderLine.Amount < 0 THEN
                                        ReminderLine.Amount := 0;
                                END;
                    END;
                    IF CalcInterest THEN
                        ReminderLine.Amount := ReminderLine.Amount / FinChrgTerms."Interest Period (Days)" * ReminderLine."Interest Rate" / 100
                    ELSE
                        ReminderLine.Amount := 0;
                    IF (InterestCalcDate < ReminderHeader."Document Date") AND (NrOfLinesToInsert = 0) THEN
                        IF NrOfLinesToInsert = 0 THEN
                            ReminderLine.T296CumulateDetailedEntries(
                              ReminderLine.Amount, UseDueDate, UseCalcDate, UseInterestRate, FinChrgTerms."Interest Period (Days)")
                        ELSE
                            ReminderLine.T296CumulateDetailedEntries(
                              ReminderLine.Amount, UseDueDate, UseCalcDate, UseInterestRate, FinanceChargeInterestRate."Interest Period (Days)");
                    IF (NrOfLinesToInsert > 0) AND
                       (FinChrgTerms."Interest Calculation Method" = FinChrgTerms."Interest Calculation Method"::"Average Daily Balance")
                    THEN
                        ReminderLine.T296CreateMulitplyInterestRateEntries(
                          ExtraReminderLine, FinanceChargeInterestRate, UseDueDate, UseInterestRate, UseCalcDate, CumAmount);

                    IF CumAmount <> 0 THEN
                        ReminderLine.VALIDATE(Amount, CumAmount);
                END;
            FinChrgTerms."Interest Calculation Method"::"Balance Due":
                IF ReminderLine."Due Date" < ReminderHeader."Document Date" THEN
                    ReminderLine.Amount := ReminderLine."Remaining Amount" * ReminderLine."Interest Rate" / 100;
        END;
        IF ReminderLine.Amount <> 0 THEN BEGIN
            CustPostingGr.GET(ReminderHeader."Customer Posting Group");
            GLAcc.GET(CustPostingGr.GetInterestAccount);
            GLAcc.TESTFIELD("Gen. Prod. Posting Group");
            ReminderLine."Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
            ReminderLine.VALIDATE("VAT Prod. Posting Group", GLAcc."VAT Prod. Posting Group");
        END;
        IsHandled := true;
        //OnAfterCalcFinChrg(Rec, ReminderHeader);
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 296, 'OnAfterSetCustLedgEntryView', '', false, false)]
    local procedure NS_T296OnAfterSetCustLedgEntryView(var CustLedgEntry: Record "Cust. Ledger Entry"; ReminderHeader: Record "Reminder Header")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            //CustLedgEntry.SETRANGE("Global Dimension 2 Code",ReminderHeader."Shortcut Dimension 2 Code");
            CustLedgEntry.SetRange("NS_Retention Ledger Code", ReminderHeader."NS_Retention Ledger Code");
        //ProjectPro - end
    end;



    //PPNA17.0 Opened Start OnEntryNoLookUp 
    [EventSubscriber(ObjectType::Table, 298, 'OnAfterSetCustLedgEntryFilter', '', false, false)]
    local procedure NS_T298OnEntryNoLookUp(var IssuedReminderLine: Record "Issued Reminder Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        IssuedReminderHeader.GET(IssuedReminderLine."Reminder No.");

        //ProjectPro - start
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", IssuedReminderHeader."NS_Retention Ledger Code");
        //ProjectPro - ends
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnDocumentNoLookUp 
    [EventSubscriber(ObjectType::Table, 298, 'OnAfterSetCustLedgEntryFilter', '', false, false)]
    local procedure NS_T298OnDocumentNoLookUp(var IssuedReminderLine: Record "Issued Reminder Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        IssuedReminderHeader.GET(IssuedReminderLine."Reminder No.");

        //ProjectPro - start
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", IssuedReminderHeader."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnAfterSetRangeOnSetCustLedgEntryView 
    [EventSubscriber(ObjectType::Table, 303, 'OnAfterSetCustLedgEntryView', '', false, false)]
    local procedure NS_T303OnAfterSetRangeOnSetCustLedgEntryView(var CustLedgEntry: Record "Cust. Ledger Entry"; FinChrgMemoHeader: Record "Finance Charge Memo Header")
    var
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        //ProjectPro - start
        NS_SalesSetup.Get;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then
            CustLedgEntry.SetRange("NS_Retention Ledger Code", FinChrgMemoHeader."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnEntryNoLookUp 
    [EventSubscriber(ObjectType::Table, 305, 'OnAfterSetCustLedgEntryFilter', '', false, false)]
    local procedure NS_T305OnEntryNoLookUp(var IssuedFinChrgMemoLine: Record "Issued Fin. Charge Memo Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        IssuedFinChrgMemoHeader.GET(IssuedFinChrgMemoLine."Finance Charge Memo No.");

        //ProjectPro - start
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", IssuedFinChrgMemoHeader."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnDocumentNoLookUp 
    [EventSubscriber(ObjectType::Table, 305, 'OnAfterSetCustLedgEntryFilter', '', false, false)]
    local procedure NS_T305OnDocumentNoLookUp(var IssuedFinChrgMemoLine: Record "Issued Fin. Charge Memo Line"; var CustLedgEntry: Record "Cust. Ledger Entry")
    var
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        NS_SalesSetup: Record "Sales & Receivables Setup";
    begin
        IssuedFinChrgMemoHeader.GET(IssuedFinChrgMemoLine."Finance Charge Memo No.");

        //ProjectPro - start
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            CustLedgEntry.SETRANGE("NS_Retention Ledger Code", IssuedFinChrgMemoHeader."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 352, 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure NS_T352OnAfterUpdateGlobalDimCode(GlobalDimCodeNo: Integer; TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    begin
        //ProjectPro - start
        case TableID of
            DATABASE::NS_Subcontract:
                NS_UpdateSubcontractGLobalDimCode(GlobalDimCodeNo, AccNo, NewDimValue);
            DATABASE::"NS_Job Quote Header"://PRJ-409.AS.1.0
                NS_UpdateJobQuoteGlobalDimCode(GlobalDimCodeNo, AccNo, NewDimValue);//PRJ-409.AS.1.0
        end;
        //ProjectPro - end
    end;

    procedure NS_UpdateSubcontractGLobalDimCode(GlobalDimCodeNo: Integer; SubcontractNo: Code[20]; NewDimValue: Code[20])
    var
        NS_Subcontract: Record NS_Subcontract;
    begin
        //ProjectPro - start
        if NS_Subcontract.Get(SubcontractNo) then begin
            case GlobalDimCodeNo of
                1:
                    NS_Subcontract."NS_Global Dimension 1 Code" := NewDimValue;
                2:
                    NS_Subcontract."NS_Global Dimension 2 Code" := NewDimValue;
            end;
            NS_Subcontract.Modify(true);
        end;
        //ProjectPro - end
    end;


    //PRJ-409.AS.1.0 - START
    procedure NS_UpdateJobQuoteGlobalDimCode(GlobalDimCodeNo: Integer; JobQuoteNo: Code[20]; NewDimValue: Code[20])
    var
        NSJobQuoteRec: Record "NS_Job Quote Header";
    begin
        if NSJobQuoteRec.Get(JobQuoteNo) then begin
            case GlobalDimCodeNo of
                1:
                    NSJobQuoteRec."NS_Shortcut Dimension 1 Code" := NewDimValue;
                2:
                    NSJobQuoteRec."NS_Shortcut Dimension 2 Code" := NewDimValue;
            end;
            NSJobQuoteRec.Modify(true);
        end;
    end;
    //PRJ-409.AS.1.0 - END

    [EventSubscriber(ObjectType::Table, 382, 'OnAfterCopyFromVendLedgerEntry', '', false, false)]
    local procedure NS_T382OnAfterCopyFromVendLedgerEntry(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        //ProjectPro - start
        CVLedgerEntryBuffer."NS_Retention Ledger Code" := VendorLedgerEntry."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    //PPNA16.0 Modified Event Start
    [EventSubscriber(ObjectType::Table, 383, 'OnBeforeCreateDtldCVLedgEntryBuf', '', false, false)]
    local procedure NS_T383OnAfterSetFiltersOnInsertDtldCVLedgEntry(var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var CVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    begin
        //ProjectPro - start
        DtldCVLedgEntryBuf.SetRange("NS_Retention Ledger Code", CVLedgEntryBuf."NS_Retention Ledger Code");
        //ProjectPro - end
    end;
    //PPNA16.0 Modified Event End

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromCVLedgEntryBuf', '', false, false)]
    local procedure NS_T383OnAfterCopyFromCVLedgEntryBuf(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        //ProjectPro - start
        DetailedCVLedgEntryBuffer."NS_Job No." := CVLedgerEntryBuffer."NS_Job No.";
        DetailedCVLedgEntryBuffer."NS_Subcontract No." := CVLedgerEntryBuffer."NS_Subcontract No.";
        DetailedCVLedgEntryBuffer."NS_Retention Ledger Code" := CVLedgerEntryBuffer."NS_Retention Ledger Code";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 951, 'OnAfterInsertEvent', '', false, false)]
    local procedure NS_T951OnAfterInsertEvent(var Rec: Record "Time Sheet Line"; RunTrigger: Boolean)
    var
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        if not RunTrigger then
            exit;
        //SPLN1.00 TTU start
        TimeSheetHeader.Get(Rec."Time Sheet No.");
        //SPLN1.00 TTU end
        //ProjectPro - start
        Rec."NS_Resource No." := TimeSheetHeader."Resource No.";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 952, 'OnAfterDeleteEvent', '', false, false)]
    local procedure NS_T952OnAfterDeleteEvent(var Rec: Record "Time Sheet Detail"; RunTrigger: Boolean)
    var
        Text14021110: Label '%1 entries cannot be deleted.';
    begin
        if not RunTrigger then
            exit;
        //ProjectPro - start
        if Rec.Posted then
            Error(Text14021110, Rec.FieldCaption(Posted));
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 952, 'OnAfterCopyFromTimeSheetLine', '', false, false)]
    local procedure NS_T952OnAfterCopyFromTimeSheetLine(var TimeSheetDetail: Record "Time Sheet Detail"; TimeSheetLine: Record "Time Sheet Line")
    var
        NS_TimeSheetHeader: Record "Time Sheet Header";
    begin
        //ProjectPro - start
        NS_TimeSheetHeader.Get(TimeSheetLine."Time Sheet No.");
        if NS_TimeSheetHeader."NS_Crew code" = '' then //PRJ-772.JS.1.0 21JULY2021
            TimeSheetDetail."Resource No." := NS_TimeSheetHeader."Resource No.";
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 1001, 'OnBeforeInsertEvent', '', false, false)]
    local procedure NS_T1001OnBeforeInsertEvent(var Rec: Record "Job Task"; RunTrigger: Boolean)
    var
        Job: Record Job;
        QuoteHeader: Record "NS_Job Quote Header";
        JobForeCast: Record "NS_Job Forecast";//PRJ-419
        NS_Jobsetup: Record "Jobs Setup";
    begin
        if not RunTrigger then
            exit;
        //SPLN1.00 TTU start
        IF Job.Get(Rec."Job No.") Then;
        if Job.Blocked = Job.Blocked::All then
            Job.TestBlocked;
        //ProjectPro - start
        Rec."NS_Burden Percent" := NS_GetDefaultAPOBurdenPercent(Job, Rec."Job Task No.");
        NS_UpdateForecastWorksheet(Rec."Job No.", Rec."Job Task No.", Rec."NS_Total Percent Complete Date", Rec."NS_Total Percent Complete", Rec."NS_Billing Percent Date", Rec."NS_Billing Percent");
        if (QuoteHeader.Get(Rec."Job No.")) and (Rec."NS_Quote No." = '') then
            Rec."NS_Quote No." := Rec."Job No.";
        //ProjectPro - end
        //PRJ-419.MS.1.0 Start 
        //PRJ-899.GK.1.0 24Sep2021 start 
        if NS_Jobsetup.Get() then;
        if not NS_Jobsetup."NS_Show Default task in Copy Job" then begin //CTSI-288.MS.1.0       
            if Rec."Job Task Type" <> Rec."Job Task Type"::Posting then begin
                JobForeCast.Reset();
                JobForeCast.SetRange("NS_Job No.", Rec."Job No.");
                JobForeCast.SetRange("NS_Job Task No.", rec."Job Task No.");
                if JobForeCast.FindFirst() then
                    JobForeCast.Deleteall;
            end;
        end;
        //PRJ-899.GK.1.0 24Sep2021 end
        //PRJ-419.MS.1.0  End
    end;

    procedure NS_GetDefaultAPOBurdenPercent(Job: Record Job; JobTaskNo: Code[35]): Decimal
    var
        JobWork: Record Job;
        JobTaskWork: Record "Job Task";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        Section: Code[10];//PRJ-688.AM.1.0
        BurdenPercent: Decimal;
    begin
        //ProjectPro - start

        //This routine reads the master APO tables to fill in a Burden Percent on a Job Task.  By looking at a Job's Indirect Burden Type and
        //  the JobTaskNo passed in, this routine will look at the master APO tables to return the correct Burden Percent for the JobTaskNo.

        BurdenPercent := 0;

        if JobWork.Get(Job."No.") then
            if JobTaskWork.Get(JobWork."No.", JobTaskNo) then begin
                JobWork.NS_JobTaskNoToAPO(JobTaskNo, Activity, Process, Operation, Section);//PRJ-688.AM.1.0
                case true of
                    Operation > '':
                        if JobOperation.Get(JobOperation.NS_Type::Cost, Activity, Process, Operation) then
                            case Job."NS_Indirect Burden Type" of
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobOperation."NS_DefaultProjectBurdenPercent";
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobOperation."NS_DefaultServiceBurdenPercent";
                            end;
                    Process > '':
                        if JobProcess.Get(JobProcess.NS_Type::Cost, Activity, Process) then
                            case Job."NS_Indirect Burden Type" of
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobProcess.NS_DefaultProjectBurdenPercent;
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobProcess."NS_DefaultServiceBurdenPercent";
                            end;
                    Activity > '':
                        if JobActivity.Get(JobActivity.NS_Type::Cost, Activity) then
                            case Job."NS_Indirect Burden Type" of
                                Job."NS_Indirect Burden Type"::Project:
                                    BurdenPercent := JobActivity.NS_DefaultProjectBurdenPerc;
                                Job."NS_Indirect Burden Type"::Service:
                                    BurdenPercent := JobActivity.NS_DefaultServiceBurdenPerc;
                            end;
                end;
            end;

        exit(BurdenPercent);
        //ProjectPro - end
    end;

    procedure NS_UpdateForecastWorksheet(JobNo: Code[20]; JobTaskNo: Code[20]; StatusDate: Date; TotalPct: Decimal; BillDate: Date; BillPct: Decimal)
    var
        JobForecast: Record "NS_Job Forecast";
        Found: Boolean;
    begin
        //ProjectPro - start
        with JobForecast do begin
            Found := false;
            Reset;
            SetCurrentKey("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");
            SetRange("NS_Job No.", JobNo);
            SetRange("NS_Job Task No.", JobTaskNo);
            SetRange(NS_Posted, false);
            if FindSet(true) then
                Found := true;
            if not Found then begin
                Validate("NS_Job No.", JobNo);
                Validate("NS_Job Task No.", JobTaskNo);
                "NS_Line No." := 100;
                Insert;
                Found := true;
            end;

            "NS_Status Date" := StatusDate;
            "NS_Percent Complete" := TotalPct;
            "NS_Bill Date" := BillDate;
            "NS_Bill Percent" := BillPct;

            Modify;
        end;
        //ProjectPro - end
    end;

    [EventSubscriber(ObjectType::Table, 1001, 'OnAfterModifyEvent', '', false, false)]
    local procedure NS_T1001OnAfterModifyEvent(var Rec: Record "Job Task"; var xRec: Record "Job Task"; RunTrigger: Boolean)
    var
        JobForeCast: Record "NS_Job Forecast";//PRJ-419
        NS_Jobsetup: Record "Jobs Setup";
    begin
        if not RunTrigger then
            exit;
        //ProjectPro - start
        NS_UpdateForecastWorksheet(Rec."Job No.", Rec."Job Task No.", Rec."NS_Total Percent Complete Date", Rec."NS_Total Percent Complete", Rec."NS_Billing Percent Date", Rec."NS_Billing Percent");
        //ProjectPro - end
        //PRJ-419.MS.1.0 Start 
        //PRJ-899.GK.1.0 24Sep2021 start
        if NS_Jobsetup.Get() then;
        if not NS_Jobsetup."NS_Show Default task in Copy Job" then begin //CTSI-288.MS.1.0       
            if Rec."Job Task Type" <> Rec."Job Task Type"::Posting then begin
                JobForeCast.Reset();
                JobForeCast.SetRange("NS_Job No.", Rec."Job No.");
                JobForeCast.SetRange("NS_Job Task No.", rec."Job Task No.");
                if JobForeCast.FindFirst() then
                    JobForeCast.Deleteall;
            end;
        end;
        //PRJ-899.GK.1.0 24Sep2021 end
        //PRJ-419.MS.1.0  End
    end;


    // [EventSubscriber(ObjectType::Table, 1003, 'OnRetrieveCostPriceCustom1', '', false, false)]
    [EventSubscriber(ObjectType::Table, 1003, 'OnBeforeRetrieveCostPrice', '', false, false)]
    LOCAL procedure NS_T1003OnBeforeRetrieveCostPrice(var JobPlanningLine: Record "Job Planning Line"; xJobPlanningLine: Record "Job Planning Line"; var ShouldRetrieveCostPrice: Boolean; var IsHandled: Boolean)
    begin
        with JobPlanningLine do begin
            case Type of
                Type::Item:
                    //ProjectPro - start
                    ShouldRetrieveCostPrice := ("No." <> NS_TempNo) or
                       ("Location Code" <> NS_TempLocation) or
                       ("Variant Code" <> NS_TempVariant) or
                       (Quantity <> xJobPlanningLine.Quantity) or
                       ("Unit of Measure Code" <> NS_TempUM);
                //ProjectPro - end
                //ReturnVal := true;
                Type::Resource:
                    //ProjectPro - start
                    ShouldRetrieveCostPrice := ("No." <> NS_TempNo) or
                       ("Work Type Code" <> NS_TempWorkType) or
                       ("NS_Skill Class" <> NS_TempSkillClass) or
                       ("Unit of Measure Code" <> NS_TempUM);
                // ShouldRetrieveCostPrice := ((xJobPlanningLine."No." = '') AND (JobPlanningLine."No." <> '')) OR
                //     (xJobPlanningLine."No." <> JobPlanningLine."No.");
                //ProjectPro - end
                //ReturnVal := true;

                Type::"G/L Account":
                    //ProjectPro - start
                    //ShouldRetrieveCostPrice := "No." <> TempNo; //PRJ-232 VT1.0 16-04-20
                    ShouldRetrieveCostPrice := "No." <> xJobPlanningLine."No.";//PRJ-232 VT1.0 16-04-20
                //ProjectPro - end
                //ReturnVal := true;

                else
                    //ReturnVal := false;
                    ShouldRetrieveCostPrice := false;
            end;
            //ReturnVal := false;
            //ShouldRetrieveCostPrice := false; //PRJ-121.SK.1.0 Blocked
        end;
        //IsHandled := true;//PRJ-232 VT1.0 16-04-20
    end;

    //PPNA16.0 Modified Event Start

    //PRJ-604.AS.1.0 - start
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterInsertEvent', '', false, false)]
    local procedure T1003OnAfterInsertEvent(var Rec: Record "Job Planning Line")
    var
        JobSetupRec: Record "Jobs Setup";
        jobRecord: Record Job;
        jobRecord1: Record Job;
        jobPlanLineRec: Record "Job Planning Line";
        jobPlanLineRec1: Record "Job Planning Line";
    begin
        JobSetupRec.Get();

        if JobSetupRec."NS_Check Master Job No." = true then begin
            if jobRecord.get(Rec."Job No.") then begin
                if jobRecord1.get(jobRecord."NS_Sub-Level to Job No.") then begin
                    jobPlanLineRec.Reset();
                    jobPlanLineRec.SetRange("Job No.", jobRecord1."No.");
                    jobPlanLineRec.SetRange("Job Task No.", Rec."Job Task No.");
                    if not jobPlanLineRec.FindFirst() then BEGIN
                        jobPlanLineRec1.Reset();
                        jobPlanLineRec1.SetRange("Job No.", Rec."Job No.");
                        jobPlanLineRec1.SetRange("Job Task No.", Rec."Job Task No.");
                        if jobPlanLineRec1.FindFirst() then
                            jobPlanLineRec1.Delete();
                    end;
                end;
            end;
        end;
    end;
    //PRJ-604.AS.1.0 - end 


    //PRJ-71.SK.1.0 Start 
    //[EventSubscriber(ObjectType::Table, 1003, 'OnAfterUpdateTotalPrice', '', false, false)]//PRJ-850.MS.1.0 comment
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterUpdateAllAmounts', '', false, false)] //PRJ-850.MS.1.0 new event
    local procedure NS_T1003OnAfterUpdateTotalPriceOnUpdateAllAmounts(var JobPlanningLine: Record "Job Planning Line")
    begin
        //ProjectPro - start
        JobPlanningLine.UpdateGrossProfit;
        // /ProjectPro - end
    end;
    //PRJ-71.SK.1.0 End
    //PPNA16.0 Modified Event End



    // [EventSubscriber(ObjectType::Table, 1003, 'OnWorkTypeCodeonValidateCustom1', '', false, false)]
    // LOCAL procedure T1003OnWorkTypeCodeonValidateCustom1(JobPlanningLine: Record "Job Planning Line"; VAR isHandled: Boolean)
    // begin
    //     IF JobPlanningLine.Type = JobPlanningLine.Type::Resource THEN
    //         isHandled := true;
    // end;



    //PPNA17.0 Opened Start OnUpdateUnitCostCustom1 
    //PRJ-71.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnBeforeUpdateUnitCost', '', false, false)]
    LOCAL procedure NS_T1003OnUpdateUnitCostCustom1(JobPlanningLine: Record "Job Planning Line"; VAR isHandled: Boolean)
    begin
        IF JobPlanningLine."NS_Template No." <> '' THEN
            isHandled := true;
    end;
    //PRJ-71.SK.1.0 End
    //PPNA17.0 Opened End




    //PPNA17.0 Opened Start OnFindPriceAndDiscountCustom1 
    //PRJ-71.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnBeforeFindPriceAndDiscount', '', false, false)]
    LOCAL procedure NS_T1003OnFindPriceAndDiscountCustom1(sender: Record "Job Planning Line"; VAR isHandled: Boolean; CalledByFieldNo: Integer)
    var
        PriceType: Enum "Price Type";
    begin
        sender.ApplyPrice(PriceType::Sale, CalledByFieldNo);
        sender.UpdateTotalCost();
        IF (sender."Unit Cost" = 0) AND (sender."Unit Price" = 0) then
            //isHandled := true; //PRJ-121.VT.1.0 Blocked
            //PRJ-121.VT.1.0 Start //PRJ-107.VT.1.0 //PRJ-119.VT.1.0 Same fix applied for the this issue also
            isHandled := false
        //else
        //isHandled := true;//PPAL-163.MS.1.0 comment unit cost and price nt comes on JPL
        //PRJ-121.VT.1.0 End //PRJ-107.VT.1.0 //PRJ-119.VT.1.0 Same fix applied for the this issue also

    end;
    //PRJ-71.SK.1.0 End
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnHandleCostFactorCustom1 
    //PRJ-71.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterHandleCostFactor', '', false, false)]
    LOCAL procedure NS_T1003OnHandleCostFactorCustom1(VAR JobPlanningLine: Record "Job Planning Line"; xJobPlanningLine: Record "Job Planning Line"; Item: Record Item)
    begin
        with JobPlanningLine do begin
            CalcUnitPriceEvent(xJobPlanningLine, Item);
        end;
    end;
    //PRJ-71.SK.1.0 End
    //PPNA17.0 Opened End



    //PPNA17.0 Opened Start OnUpdateAmountsAndDiscountsCustom1 
    //PRJ-71.SK.1.0 Start
    [EventSubscriber(ObjectType::Table, 1003, 'OnBeforeUpdateAmountsAndDiscounts', '', false, false)]
    LOCAL procedure NS_T1003OnUpdateAmountsAndDiscountsCustom1(VAR JobPlanningLine: Record "Job Planning Line"; xJobPlanningLine: Record "Job Planning Line"; VAR isHandled: Boolean)
    begin
        with JobPlanningLine do begin
            UpdateAmountsAndDiscountsEvent(JobPlanningLine, xJobPlanningLine);
            //isHandled := true; //PRJ-854 comment start
        end;
    end;
    //PRJ-71.SK.1.0 End
    //PPNA17.0 Opened End

    //JD-48.AS.1.0 //PRJ-419.MS.1.0 - start
    [EventSubscriber(ObjectType::Table, 1003, 'OnAfterModifyEvent', '', false, false)]
    local procedure NS_T1003OnAfterModifyEvent(var Rec: Record "Job Planning Line")
    var
        JobForeCastbySeg: Record "NS_Job Forecast by Seg code";
        JobtaskRec: Record "Job Task";

    begin
        JobtaskRec.Reset();
        JobtaskRec.SetRange("Job No.", Rec."Job No.");
        JobtaskRec.SetRange("Job Task No.", Rec."Job Task No.");
        if JobtaskRec.FindSet then begin
            if JobtaskRec."Job Task Type" <> JobtaskRec."Job Task Type"::Posting then begin
                JobForeCastbySeg.Reset();
                JobForeCastbySeg.SetRange("NS_Job No.", Rec."Job No.");
                JobForeCastbySeg.SetRange("NS_Job Task No.", rec."Job Task No.");
                JobForeCastbySeg.SetRange("NS_Segment Code", rec."NS_Segment Code");
                if JobForeCastbySeg.FindFirst() then
                    JobForeCastbySeg.Deleteall;
            end;
        end;
    end;
    //JD-48.AS.1.0 //PRJ-419.MS.1.0 - end

    //DMT TTU kodas pradzia
    //DMT TTU kodo pabaiga

    [EventSubscriber(ObjectType::Table, 5050, 'OnCreateCustomerOnBeforeCustomerModify', '', false, false)]
    local procedure NS_T5050OnCreateCustomerOnBeforeCustomerModify(var Customer: Record Customer; Contact: Record Contact)
    begin
        if Contact.Type = Contact.Type::Company then
            Customer.Validate("Country/Region Code", Contact."Country/Region Code");
    end;


    //PPNA17.0 Opened Start OnAfterSetContactFilterOnGetCompNo 
    [EventSubscriber(ObjectType::Table, 5050, 'OnGetCompNoOnAfterSetFilters', '', false, false)]
    local procedure NS_T5050OnAfterSetContactFilterOnGetCompNo(var Contact: Record Contact)
    begin
        //ProjectPro - start
        Contact.SetRange(Type, Contact.Type::Company);
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 5065, 'OnAfterCopyFromSegment', '', false, false)]
    local procedure NS_T5065OnAfterCopyFromSegment(var InteractionLogEntry: Record "Interaction Log Entry"; SegmentLine: Record "Segment Line")
    begin
        //ProjectPro - start
        InteractionLogEntry."NS_Job Quote No." := SegmentLine."NS_Job Quote No.";
        //ProjectPro - end
    end;



    //PPNA17.0 Opened Start OnAfterSetOutputItemLedgEntryFilterOnCalcCurrencyFactor 
    [EventSubscriber(ObjectType::Table, 5896, 'OnCalcCurrencyFactorOnAfterSetFilters', '', false, false)]
    local procedure NS_T5896OnAfterSetOutputItemLedgEntryFilterOnCalcCurrencyFactor(var OutputItemLedgEntry: Record "Item Ledger Entry"; InventoryAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)")
    begin
        OutputItemLedgEntry.Reset;
        OutputItemLedgEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type");
        OutputItemLedgEntry.SetRange("Order Type", InventoryAdjmtEntryOrder."Order Type");
        OutputItemLedgEntry.SetRange("Order No.", InventoryAdjmtEntryOrder."Order No.");
        //ProjectPro - start
        //IF "Order Type" = "Order Type"::Production THEN BEGIN
        //  OutputItemLedgEntry.SETRANGE("Order Line No.","Order Line No.");
        //  OutputItemLedgEntry.SETRANGE("Entry Type",OutputItemLedgEntry."Entry Type"::Output);
        //END ELSE
        //  OutputItemLedgEntry.SETRANGE("Entry Type",OutputItemLedgEntry."Entry Type"::"Assembly Output");
        if InventoryAdjmtEntryOrder."Order Type" = InventoryAdjmtEntryOrder."Order Type"::Production then
            OutputItemLedgEntry.SetRange("Order Line No.", InventoryAdjmtEntryOrder."Order Line No.");
        OutputItemLedgEntry.SetRange("Entry Type", OutputItemLedgEntry."Entry Type"::Output);
        //ProjectPro - end
    end;
    //PPNA17.0 Opened End

    [EventSubscriber(ObjectType::Table, 5902, 'OnAfterValidateEvent', 'Job Planning Line No.', false, false)]
    local procedure NS_T5902OnAfterValidateJobPlanningLineNo(var Rec: Record "Service Line"; var xRec: Record "Service Line"; CurrFieldNo: Integer)
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        //JobPlanningLine.Get(Rec."Job No.", Rec."Job Task No.", Rec."Job Planning Line No.");   //PRJ-834.JS.1.0�09Aug2021 code commented
        if Rec."Job Planning Line No." <> 0 then begin
            JobPlanningLine.Get(Rec."Job No.", Rec."Job Task No.", Rec."Job Planning Line No."); //PRJ-834.JS.1.0�09Aug2021
            //ProjectPro - start
            Rec."NS_Job Cost Category" := JobPlanningLine."NS_Cost Category";
            Rec."NS_Job Revenue Category" := JobPlanningLine."NS_Revenue Category";
            //ProjectPro - end
        end;
    end;

    //[EventSubscriber(ObjectType::Table, 7346, 'OnAfterOpenInternalMovementHeader', '', false, false)]
    [EventSubscriber(ObjectType::Table, 7346, 'OnBeforeOpenInternalMovementHeader', '', false, false)]
    local procedure NS_T7346OnBeforeOpenInternalMovementHeader(var InternalMovementHeader: Record "Internal Movement Header"; var IsHandled: Boolean)
    var
        WhseEmployee: Record "Warehouse Employee";
        CurrentLocationCode: Code[20];
    begin
        WhseEmployee.SETRANGE("Location Code", InternalMovementHeader."Location Code");
        IF NOT WhseEmployee.ISEMPTY THEN
            CurrentLocationCode := InternalMovementHeader."Location Code"
        ELSE
            CurrentLocationCode := InternalMovementHeader.GetDefaultOrFirstAllowedLocation;

        InternalMovementHeader.FILTERGROUP := 2;
        InternalMovementHeader.SETRANGE("Location Code", CurrentLocationCode);
        InternalMovementHeader.FILTERGROUP := 0;
        InternalMovementHeader.NS_OpenInternalMovementHeaderEvent(InternalMovementHeader, WhseEmployee, InternalMovementHeader);
        IsHandled := true;
    end;



    //PPNA17.0 Opened Start onLookupInternalMovementHeaderCustom1 
    [EventSubscriber(ObjectType::Table, 7346, 'OnBeforeLookupInternalMovementHeader', '', false, false)]
    local procedure NS_T7346onLookupInternalMovementHeaderCustom1(sender: Record "Internal Movement Header"; VAR InternalMovementHeader: Record "Internal Movement Header"; VAR isHandled: Boolean)
    begin
        isHandled := true;
        sender.LookupInternalMovementHeaderEvent(InternalMovementHeader);
    end;
    //PPNA17.0 Opened End


    //PPDA.1.0 Start
    // //[EventSubscriber(ObjectType::Table, 10010, 'OnAfterInsertIRS1099OnInitIRS1099FormBoxes', '', false, false)]
    // [EventSubscriber(ObjectType::Table, 10010, 'OnAfterInsertEvent', '', false, false)]
    // //local procedure T10010OnAfterInsertIRS1099OnInitIRS1099FormBoxes(var IRS1099FormBox: Record "IRS 1099 Form-Box")
    // local procedure NS_T10010OnAfterInsertEvent(var Rec: Record "IRS 1099 Form-Box"; RunTrigger: Boolean)
    // var
    //     IRS1099FormBoxVar: Record "IRS 1099 Form-Box";
    // begin
    //     //ProjectPro - start
    //     //InsertIRS1099('INT-12','Bond Premium on Treasury Obligation',0.01);
    //     //ProjectPro - end
    //     if IRS1099FormBoxVar.Get('INT-12') then
    //         IRS1099FormBoxVar.Delete;
    // end;
    //PPDA.1.0 End

    [EventSubscriber(ObjectType::Table, 99000853, 'OnAfterTransferFromJobPlanningLine', '', false, false)]
    local procedure NS_T99000853OnAfterTransferFromJobPlanningLine(var InventoryProfile: Record "Inventory Profile"; JobPlanningLine: Record "Job Planning Line")
    begin
        //ProjectPro - start
        InventoryProfile."NS_Job No." := JobPlanningLine."Job No.";//PPNA17.0 Opened
        InventoryProfile."NS_Job Task No." := JobPlanningLine."Job Task No.";//PPNA17.0 Opened
        //ProjectPro - end
    end;



    //PPNA17.0 Opened Start OnInteractionTemplateCodeOnValidateCustom1 
    [EventSubscriber(ObjectType::Table, 5077, 'OnValidateInteractionTemplateCode', '', false, false)]
    local procedure NS_T5077OnInteractionTemplateCodeOnValidateCustom1(VAR SegmentLine: Record "Segment Line"; var Cont: Record Contact; VAR isHandled: Boolean)
    begin
        SegmentLine.GetContact(Cont);
        isHandled := true;
    end;
    //PPNA17.0 Opened End

    //PPNA16.0 Modified Event Start
    //PRJ-816.MS.1.0 code comment for std.func.issue start
    // [EventSubscriber(ObjectType::Table, 5077, 'OnBeforeStartWizard', '', false, false)]
    // local procedure NS_T5077OnStartWizardCustom1(VAR SegmentLine: Record "Segment Line"; VAR isHandled: Boolean)
    // var
    //     RelationshipPerformanceMgt: Codeunit "Relationship Performance Mgt.";
    //     Campaign: Record Campaign;
    //     Opp: Record Opportunity;
    // begin
    //     with SegmentLine do begin

    //         //PPNA16.0 Start
    //         IF Campaign.GET("Campaign No.") THEN
    //             "Campaign Description" := Campaign.Description;
    //         IF Opp.GET("Opportunity No.") THEN
    //             "Opportunity Description" := Opp.Description;
    //         "Wizard Contact Name" := NS_LocalGetContactName(SegmentLine);
    //         "Wizard Step" := "Wizard Step"::"1";
    //         "Interaction Successful" := TRUE;
    //         VALIDATE(Date, WORKDATE);
    //         "Time of Interaction" := DT2TIME(ROUNDDATETIME(CURRENTDATETIME + 1000, 60000, '>'));
    //         INSERT;
    //         //PPNA16.0 End

    //         //ProjectPro - start
    //         IF GETFILTER("NS_Job Quote No.") > '' THEN BEGIN
    //             IF PAGE.RUNMODAL(PAGE::"NS_Job Quote CreateInteraction", SegmentLine, "Interaction Template Code") = ACTION::OK THEN;
    //             IF "Wizard Step" = "Wizard Step"::"6" THEN
    //                 //RelationshipPerformanceMgt.SendCreateOpportunityNotification(SegmentLine);
    //                 NS_CU783SendCreateOpportunityNotification(SegmentLine);
    //             isHandled := true;
    //         END;
    //         //ProjectPro - end
    //     end;
    // end;
    //PRJ-816.MS.1.0 code comment for std.func.issue end
    //PPNA16.0 Modified Event End


    //[EventSubscriber(ObjectType::Table, 5077, 'OnCheckStatusCustom1', '', false, false)]
    [EventSubscriber(ObjectType::Table, 5077, 'OnBeforeCheckStatus', '', false, false)]
    local procedure NS_T5077OnBeforeCheckStatus(var SegmentLine: Record "Segment Line"; var IsHandled: Boolean)
    var
        TempAttachment: Record Attachment;
        Cont: Record Contact;
    begin
        Cont.Get(SegmentLine."Contact No.");
        SegmentLine.CheckStatusEvent(TempAttachment, Cont);
        isHandled := true;
    end;

    //PRJ-9.TY.1.0 Start
    //[EventSubscriber(ObjectType::Table, 297, 'OnNavigateCustom1', '', false, false)]
    [EventSubscriber(ObjectType::Page, 438, 'OnBeforeActionEvent', '&Navigate', false, false)]
    local procedure NS_T297OnNavigateCustom1(var Rec: Record "Issued Reminder Header")
    begin
        with Rec do
            p.NS_SetNS_Navigate("Posting Date", "No.", "NS_Retention Ledger Code");
    end;
    //PRJ-9.TY.1.0 End

    //PRJ-9.TY.1.0 Start
    // [EventSubscriber(ObjectType::Table, 297, 'OnNavigateCustom1', '', false, false)]
    // local procedure T297OnNavigateCustom1(IssuedReminderHeader: Record "Issued Reminder Header")
    // begin
    //     with IssuedReminderHeader do
    //         p.SetNS_Navigate("Posting Date", "No.", "Retention Ledger Code");
    // end;
    //PRJ-9.TY.1.0 End

    procedure NS_CU783SendCreateOpportunityNotification(SegmentLine: Record "Segment Line")
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        CreateOpportunityNotification: Notification;
        CreateOpportunityQst: TextConst ENU = 'Do you want to create an opportunity for contact %1?';
        CreateOpportunityCaptionTxt: Label 'Create opportunity...';
    begin
        CreateOpportunityNotification.ID := CREATEGUID;
        CreateOpportunityNotification.MESSAGE := STRSUBSTNO(CreateOpportunityQst, SegmentLine."Contact No.");
        InteractionLogEntry.SETRANGE("User ID", USERID);
        InteractionLogEntry.SETRANGE("Contact No.", SegmentLine."Contact No.");
        InteractionLogEntry.FINDFIRST;
        CreateOpportunityNotification.SETDATA(
          NS_CU783GetSegmentLineNotificationDataItemID, NS_CU783RecordsToXml(SegmentLine, InteractionLogEntry));
        CreateOpportunityNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
        CreateOpportunityNotification.ADDACTION(
          CreateOpportunityCaptionTxt, CODEUNIT::"Relationship Performance Mgt.", 'CreateOpportunityFromSegmentLineNotification');
        CreateOpportunityNotification.SEND;
    end;

    procedure NS_CU783GetSegmentLineNotificationDataItemID(): Text
    begin
        EXIT('SegmentLineNotificationTok');
    end;

    procedure NS_CU783RecordsToXml(SegmentLine: Record "Segment Line"; InteractionLogEntry: Record "Interaction Log Entry"): Text
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        RecRef: RecordRef;
    //   DotNetXmlDocument: DotNet "System.Xml.XmlDocument.'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089";
    begin


        // EXIT(DotNetXmlDocument.OuterXml);

    end;

    procedure NS_LocalGetContactName(SegmentLine: Record "Segment Line"): Text[100]
    var
        Cont: Record Contact;
    begin
        IF Cont.GET(SegmentLine."Contact No.") THEN
            EXIT(Cont.Name);
        IF Cont.GET(SegmentLine."Contact Company No.") THEN
            EXIT(Cont.Name);
    end;
    //PRJ-333.AS.1.0 27 JULY 2020 - start
    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure NS_T37UpdateGPPB(var Rec: Record "Sales Line")
    var
        Job_Tbl: Record job;
        JobSetup_Tbl: Record "Jobs Setup";
        SalesHeader: Record "Sales Header";
    begin
        JobSetup_Tbl.Get();
        SalesHeader.Get(rec."Document Type", rec."Document No.");
        if (Rec.Type = Rec.Type::"G/L Account") OR (Rec.Type = Rec.Type::NS_Ledger) then begin
            if Job_Tbl.Get(SalesHeader."NS_Job No.") then begin
                // if Job_Tbl."NS_Gen. Prod. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                //     Rec."Gen. Prod. Posting Group" := Job_Tbl."NS_Gen. Prod. Posting Group"//PRJ-831.AS.1.0 12OCT2021 Comment old

                if Job_Tbl."NS_Gen. Prod. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                    Rec."Gen. Prod. Posting Group" := Job_Tbl."NS_Gen. Prod. Posting Group New"//PRJ-831.AS.1.0 12OCT2021 Add New
                else
                    Rec."Gen. Prod. Posting Group" := JobSetup_Tbl."NS_Prog. Bill Gen. ProdPostGr.";
            end;
        end;
    end;

    //PRJ-333.AS.1.0 27 JULY 2020 - end
    //PRJ-394 start
    [EventSubscriber(ObjectType::Table, 1003, 'OnbeforeInsertEvent', '', false, false)]
    local procedure NS_T1003OnBeforeInsertEvent(var Rec: Record "job planning line"; RunTrigger: Boolean)
    var
        Job: Record Job;
    begin
        if Job.Get(rec."Job No.") then;
        // Rec."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        Rec."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
        //PRJ-395 start
        Rec."NS_Shortcut Dimension 1 Code" := job."Global Dimension 1 Code";
        Rec."NS_Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
        //PRJ-395 end
    end;
    //PRJ-394 end

    //PRJ-440.MS.1.0 start
    [EventSubscriber(ObjectType::Table, 1013, 'OnBeforeCheckItemNoNotEmpty', '', false, false)]
    LOCAL procedure NS_T1033OnBeforeCheckItemNoNotEmpty(VAR JobItemPrice: Record "Job Item Price"; VAR isHandled: Boolean)
    begin
        isHandled := true;
    end;
    //PRJ-440.MS.1.0 end

    //PRJ-395 satrt
    [EventSubscriber(ObjectType::Table, 1002, 'OnAfterInsertEvent', '', false, false)]
    local procedure NS_T1002OnAfterInsertEvent(var Rec: Record "Job Task Dimension"; RunTrigger: Boolean)
    var
        Job: Record Job;
        PlngLine: Record "Job Planning Line";
    begin
        if Job.get(rec."Job No.") then;
        PlngLine.Reset;
        PlngLine.SetRange("Job No.", Rec."Job No.");
        if PlngLine.FindFirst() then
            repeat
                if Job."Global Dimension 1 Code" = rec."Dimension Value Code" then
                    PlngLine."NS_Shortcut Dimension 1 Code" := rec."Dimension Value Code"
                else
                    if Job."Global Dimension 2 Code" = Rec."Dimension Value Code" then
                        PlngLine."NS_Shortcut Dimension 2 Code" := rec."Dimension Value Code";
                PlngLine.Modify();
            until PlngLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, 1002, 'OnafterDeleteEvent', '', false, false)]
    local procedure NS_T1002OnafterDeleteEvent(var Rec: Record "Job Task Dimension"; RunTrigger: Boolean)
    var
        Job: Record Job;
        PlngLine: Record "Job Planning Line";
    begin
        if Job.get(rec."Job No.") then;
        PlngLine.Reset;
        PlngLine.SetRange("Job No.", Rec."Job No.");
        if PlngLine.FindFirst() then
            repeat
                if Job."Global Dimension 1 Code" = '' then
                    PlngLine."NS_Shortcut Dimension 1 Code" := '';

                if Job."Global Dimension 2 Code" = '' then
                    PlngLine."NS_Shortcut Dimension 2 Code" := '';
                PlngLine.Modify();
            until PlngLine.Next() = 0;
    end;
    //PRJ-395 end
    //PRJ-488.MS.1.0 Start
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Pay-to Vendor No.', false, false)]
    local procedure NS_T38ValidateGenBusPosGrp2(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header")
    var
        Job: Record Job;
        PurchHeader: Record "Purchase Header";
    begin
        IF PurchHeader.get(Rec."Document Type", Rec."No.") then;
        IF Job.Get(PurchHeader."NS_Job No.") then
            // IF job."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
            //     Rec.VALIDATE(Rec."Gen. Bus. Posting Group", Job."NS_Gen. Bus. Posting Group"); //PRJ-831.AS.1.0 12OCT2021 Comment old

                IF job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                Rec.VALIDATE(Rec."Gen. Bus. Posting Group", Job."NS_Gen. Bus. Posting Group New");//PRJ-831.AS.1.0 12OCT2021 Add New
    end;
    //PRJ-488.MS.1.0 End

    //CTSI-274.MS.1.0 start
    [EventSubscriber(ObjectType::Table, 81, 'OnafterDeleteEvent', '', false, false)]
    local procedure T81OnafterDeleteEvent(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    var
        RevenueRecSummaryTab: Record NS_RevenueRecSummaryTab;
        Jobsetp: Record "Jobs Setup";
        JLE: Record "Job Ledger Entry";
    begin
        //CTSI-274.MS.1.0 start
        if Jobsetp.get then;
        if (Jobsetp."NS_Burden G/L Journal Batch Rev." = Rec."Journal Batch Name") then begin
            RevenueRecSummaryTab.Reset();
            RevenueRecSummaryTab.SetRange("NS_Gen.Doc.No.", Rec."Document No.");
            RevenueRecSummaryTab.SetFilter(NS_Voided, '%1', false);
            if RevenueRecSummaryTab.FindSet then
                repeat
                    RevenueRecSummaryTab."NS_Gen.Doc.No." := '';
                    //RevenueRecSummaryTab.NS_TrueupDoc := false; //CTSI-286 rollback
                    RevenueRecSummaryTab.NS_CheckBool := false;//PRJ-658.AS.1.0 17MAY2021
                    if RevenueRecSummaryTab.NS_Posted = false then  //CTSI-286
                        RevenueRecSummaryTab."NS_True-Up Value" := 0;
                    //PRJ-830
                    if RevenueRecSummaryTab."NS_Over/Under Billings Posted" = false then
                        RevenueRecSummaryTab."NS_Billing Amt. Posted" := 0;
                    //PRJ-830   
                    RevenueRecSummaryTab.Modify();
                until RevenueRecSummaryTab.next = 0;
        end;
        //CTSI-274.MS.1.0 end

        //CTSI-254.MS.1.0 start
        if Jobsetp."NS_Advanced Burden Allocation" = true then begin
            if (Jobsetp."NS_Burden G/L Journal Batch" = Rec."Journal Batch Name") then begin
                JLE.Reset();
                JLE.SetRange("Job No.", Rec."Job No.");
                JLE.SetRange("NS_Burden Export", true);
                if JLE.FindSet() then
                    repeat
                        JLE."NS_Burden Export" := false;
                        JLE.MODIFY;
                    until JLE.Next() = 0;
            end;
            //CTSI-254.MS.1.0 start
        end;

    END;//EXTRA ADDED
    //PRJ-522.MS.1.0 start
    [EventSubscriber(ObjectType::Table, 1670, 'OnBeforeIncludeoption', '', false, false)]
    LOCAL procedure NS_T1670nBeforeIncludeoption(OptionLookupBuffer: Record "Option Lookup Buffer"; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        IndexofLedger: Integer;
    begin
        if (LookupType <> OptionLookupBuffer."Lookup Type"::Purchases) then
            exit;
        IndexofLedger := PurchaseLine.Type.Ordinals.IndexOf(PurchaseLine.Type::NS_Ledger.AsInteger()) - 1;
        if Option = IndexofLedger then begin
            Result := true;
            Handled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Table, 1670, 'OnBeforeInsertEvent', '', false, false)]

    LOCAL procedure NS_T1670OnbeforeInsert(var Rec: Record "Option Lookup Buffer")
    var
        PurchaseLine: Record "Purchase Line";
        IndexofLedger: Integer;
    begin
        if (rec."Lookup Type" <> Rec."Lookup Type"::Purchases) then
            exit;
        IndexofLedger := PurchaseLine.Type.Ordinals.IndexOf(PurchaseLine.Type::NS_Ledger.AsInteger()) - 1;
        if rec.ID = IndexofLedger then begin
            Rec.ID := "purchase line type"::NS_Ledger;
            Rec."Option Caption" := format("Purchase Line Type"::NS_Ledger);
        end;
    end;
    //PRJ-522.MS.1.0 end
    //PRJ-522.MS.1.0 start SL
    [EventSubscriber(ObjectType::Table, 1670, 'OnBeforeIncludeoption', '', false, false)]
    LOCAL procedure NS_T1670nBeforeIncludeoptionSL(OptionLookupBuffer: Record "Option Lookup Buffer"; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean)
    var
        SalesLine: Record "Sales Line";
        IndexofLedger: Integer;
    begin
        if (LookupType <> OptionLookupBuffer."Lookup Type"::Sales) then
            exit;
        IndexofLedger := SalesLine.Type.Ordinals.IndexOf(SalesLine.Type::NS_Ledger.AsInteger()) - 1;
        if Option = IndexofLedger then begin
            Result := true;
            Handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 1670, 'OnBeforeInsertEvent', '', false, false)]
    LOCAL procedure NS_T1670OnbeforeInsertSL(var Rec: Record "Option Lookup Buffer")
    var
        SaleLine: Record "Sales Line";
        IndexofLedger: Integer;
    begin
        if (rec."Lookup Type" <> Rec."Lookup Type"::Sales) then
            exit;
        IndexofLedger := SaleLine.Type.Ordinals.IndexOf(SaleLine.Type::NS_Ledger.AsInteger()) - 1;
        if rec.ID = IndexofLedger then begin
            Rec.ID := "sales line type"::NS_Ledger;
            Rec."Option Caption" := format("sales Line Type"::NS_Ledger);
        end;
    end;

    //PRJ-522.MS.1.0 end      

    //SK Start
    [EventSubscriber(ObjectType::Table, Database::"NS_Job Forecast", 'OnOpenJobForcastPage', '', false, false)]
    local procedure P14021187_OnOpenForcastPage(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; var JobForecast: Record "NS_Job Forecast")
    begin
        POpenForecastpage(JobNo, DefaultStatusDate, NextBillDate, JobForecast);
    end;

    procedure POpenForecastpage(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; var JobForecast: Record "NS_Job Forecast")
    var
        PreviousJobForecastNew: Record "NS_Job Forecast";
        PreviousJobForecastNew2: Record "NS_Job Forecast";
        ViewOpenTaskonly: Boolean;
        CurrentJobNo: Code[20];
        JobsRec: Record Job;
        PersonResponsible: Code[20];
        ManagerValue: Code[20];
        JobDescription: Text;
        CurrentTaskManager: Code[100];
        TaskManagerName: Text;
        TaskManagerSentIn: Code[20];
        Resource: Record Resource;
        Job: Record Job;
        JobNoSentIn: Code[20];
        AsOfDateSentIn: Date;
        FilterMonth: Integer;
    begin
        ViewOpenTaskonly := false; //CTSI-192.MS.1.0
        JobForecast.Reset();
        JobForecast.SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", NS_Posted, "NS_Status Date");

        CurrentJobNo := JobNo;//new
        JobDescription := '';
        if CurrentJobNo > '' then
            if Job.GET(CurrentJobNo) then begin
                JobDescription := Job.Description;
                // CurrPage.SAVERECORD;
            end;
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if JobsRec.get(CurrentJobNo) then
            PersonResponsible := JobsRec."Person Responsible"
        else
            PersonResponsible := '';
        if JobsRec.get(CurrentJobNo) then
            ManagerValue := JobsRec.NS_Manager
        Else
            ManagerValue := '';
        //CTSI-121.N.S.1.0 18Aug2020 Start

        CurrentTaskManager := TaskManagerSentIn;
        TaskManagerName := '';
        if CurrentTaskManager > '' then
            if Resource.GET(CurrentTaskManager) then begin
                TaskManagerName := Resource.Name;
                // CurrPage.SAVERECORD;
            end;

        DefaultStatusDate := AsOfDateSentIn;
        NextBillDate := 0D;
        if DefaultStatusDate > 0D then begin
            FilterMonth := DATE2DMY(DefaultStatusDate, 2);
            case true of
                FilterMonth <= 10:
                    NextBillDate := DMY2DATE(1, DATE2DMY(DefaultStatusDate, 2) + 2, DATE2DMY(DefaultStatusDate, 3)) - 1;
                FilterMonth = 11:
                    NextBillDate := DMY2DATE(31, 12, DATE2DMY(DefaultStatusDate, 3));
                else
                    NextBillDate := DMY2DATE(31, 1, DATE2DMY(DefaultStatusDate, 3) + 1);
            end;
        end;

        ListUpdate(JobForecast, CurrentJobNo, CurrentTaskManager);

        JobForecast.FILTERGROUP := 2;
        if CurrentJobNo > '' then
            JobForecast.SETRANGE("NS_Job No.", CurrentJobNo);
        if CurrentTaskManager > '' then
            JobForecast.SETRANGE("NS_Task Manager", CurrentTaskManager);
        JobForecast.SETRANGE(NS_Posted, false);
        JobForecast.FILTERGROUP := 1;
        ListUpdate(JobForecast, CurrentJobNo, CurrentTaskManager);
        // Message('Please enter "As of Date Filter".');//PRJ-565
        //if calculated then
        //  CurrPage.Close();
    end;

    [EventSubscriber(ObjectType::Table, Database::"NS_Job Forecast", 'OnAfterGetCurrRecordJobForcastPage', '', false, false)]
    local procedure P14021187_OnAfterGetCurrRecordJobForcastPage(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date)
    begin

    end;


    [EventSubscriber(ObjectType::Table, Database::"NS_Job Forecast", 'OnAfterGetJobForcastPage', '', false, false)]
    local procedure P14021187_OnAfterGetJobForcastPage(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; Var JobForecast: Record "NS_Job Forecast")
    begin
        POnAfterGetJobForecastPage(JobNo, DefaultStatusDate, NextBillDate, JobForecast);
    end;


    procedure POnAfterGetJobForecastPage(JobNo: Code[20]; DefaultStatusDate: Date; NextBillDate: Date; Var JobForecast: Record "NS_Job Forecast")
    var
        glsetup: Record "General Ledger Setup";
        FlagHrs: Integer;
        PoNo: Code[20];
        PPH: Record "Purch. Inv. Header";
        JobTask: Record "Job Task";
        JobLedEntry: record "Job Ledger Entry";
        AmtRcdNotInv: Decimal; //PRJ-285.MS.1.0
        AmtRcdNotInv1: Decimal; //PRJ-285.MS.1.0
        AmtRcdNotInv2: Decimal; //PRJ-285.MS.1.0
        PurRecpLine: Record "Purch. Rcpt. Line";//PRJ-285.MS.1.0
        PurcInvLine: Record "Purch. Inv. Line"; //PRJ-285.MS.1.0
        InvAmt: Decimal;//PRJ-285.MS.1.0
        LaborRate: Decimal;//CTSI-95.MS.1.0
        LabrrateBytask: Record "NS_Labor rate by task list";//CTSI-95.MS.1.0
        Jobsetup: Record "Jobs Setup";//CTSI-95.MS.1.0
        DefDim: Record "Default Dimension";//CTSI-95.MS.1.0
        PersonResponsible: Code[20];//CTSI-121.N.S.1.0 18Aug2020
        ManagerValue: Code[20];//CTSI-121.N.S.1.0 18Aug2020
        JobsRec: Record Job;//CTSI-121.N.S.1.0 18Aug2020
        Job: Record job;
        TaskManagerName: Text;//PRJ-301.AS.1.0
        TotalBudget: Decimal;
        TotalTaskBudget: Decimal;
        TotalCostsUsed: Decimal;
        JobCostsUsed: Decimal;
        BudgetRemaining: Decimal;
        BudgetPercentageUsed: Decimal;
    begin
        if (JobForecast.NS_Posted = false) then
            FillInTable(JobForecast, DefaultStatusDate, NextBillDate);

        if JobTask.GET(JobForecast."NS_Job No.", JobForecast."NS_Job Task No.") then;
        JobTask.CALCFIELDS("Outstanding Orders", "Amt. Rcd. Not Invoiced");
        //CTSI-21.MS.1.0 start
        JobLedEntry.Reset();
        JobLedEntry.SetCurrentKey("Job No.", "Job Task No.", Type, "Entry Type", "Unit of Measure Code");
        JobLedEntry.SetRange("Job No.", JobForecast."NS_Job No.");
        JobLedEntry.SetRange("Job Task No.", JobForecast."NS_Job Task No.");
        JobLedEntry.SetFilter(Type, '%1', JobLedEntry.Type::Resource);
        JobLedEntry.SetFilter("Entry Type", '%1', JobLedEntry."Entry Type"::Usage);
        JobLedEntry.SetFilter("Unit of Measure Code", '%1', 'HR');
        if DefaultStatusDate <> 0D then
            JobLedEntry.SetFilter("Posting Date", '%1..%2', 0D, DefaultStatusDate);
        JobLedEntry.CalcSums(Quantity);
        //CTSI-21.MS.1.0 end 
        //CTSI-21.MS.1.001 start
        if glsetup.Get() then;
        JobForecast."NS_Remaining Hours" := JobForecast."Budgeted Hours" - jobledEntry.Quantity;//"Actual Hours";
        if JobForecast."NS_Remaining Hours" < 0 then //PRJ-565
            JobForecast."NS_Remaining Hours" := 0;
        if JobForecast."Budgeted Hours" <> 0 then
            JobForecast."NS_Budgeted Hrs Percent Compelete" := round(jobledEntry.Quantity * 100 / JobForecast."Budgeted Hours", glsetup."Amount Rounding Precision");
        //round("Actual Hours" * 100 / "Budgeted Hours", glsetup."Amount Rounding Precision");
        //CTSI-21.MS.1.001 end  
        //PRJ-285.MS.1.0 start
        if JobForecast.NS_Posted = false then begin
            AmtRcdNotInv := 0;
            AmtRcdNotInv1 := 0;
            AmtRcdNotInv2 := 0;
            PurRecpLine.reset;
            PurRecpLine.setrange("Job No.", JobForecast."NS_Job No.");
            PurRecpLine.SetRange("Job Task No.", JobForecast."NS_Job Task No.");
            //PurRecpLine.SetFilter(Type, '%1', PurRecpLine.Type::Item);//PRJ-MS
            if DefaultStatusDate <> 0D then
                PurRecpLine.Setrange("Posting Date", 0D, DefaultStatusDate);
            if PurRecpLine.FindFirst() then begin
                repeat
                    //AmtRcdNotInv1 := AmtRcdNotInv1 + PurRecpLine."Qty. Rcd. Not Invoiced" * PurRecpLine."Direct Unit Cost";
                    //AmtRcdNotInv2 := AmtRcdNotInv2 + PurRecpLine."Quantity Invoiced" * PurRecpLine."Direct Unit Cost";
                    AmtRcdNotInv1 := AmtRcdNotInv1 + (PurRecpLine.Quantity * PurRecpLine."Direct Unit Cost");//PRJ-MS
                until PurRecpLine.Next() = 0;
            end;
            InvAmt := 0;
            PurcInvLine.Reset();
            PurcInvLine.SetRange("Job No.", JobForecast."NS_Job No.");
            PurcInvLine.SetRange("Job Task No.", JobForecast."NS_Job Task No.");
            //PurcInvLine.SetFilter(Type, '%1', PurcInvLine.Type::Item);//PRJ-MS
            if DefaultStatusDate <> 0D then
                PurcInvLine.Setrange("Posting Date", 0D, DefaultStatusDate);
            if PurcInvLine.FindFirst() then
                repeat
                    if PPH.get(PurcInvLine."Document No.") then;
                    if PPH."Order No." <> '' then
                        InvAmt := InvAmt + (PurcInvLine.Quantity * PurcInvLine."Direct Unit Cost");//PRJ-MS
                until PurcInvLine.Next() = 0;

            AmtRcdNotInv := AmtRcdNotInv1 - InvAmt;//PRJ-MS    
                                                   //AmtRcdNotInv := AmtRcdNotInv1 + AmtRcdNotInv2 - InvAmt;

        end;
        //PRJ-285.MS.1.0 end 
        //CTSI-95.MS.1.0 start
        LaborRate := 0;
        if job.get(JobForecast."NS_Job No.") then;
        if jobsetup.Get() then;
        if DefDim.get('167', Job."No.", Jobsetup."NS_Dimension for Labor Rates") then begin
            LabrrateBytask.Reset();
            LabrrateBytask.SetRange("NS_Dimension code", DefDim."Dimension Code");
            LabrrateBytask.SetRange("NS_Dimension Value code", DefDim."Dimension Value Code");
            LabrrateBytask.SetRange("NS_Task Code", JobForecast."NS_Job Task No.");
            if LabrrateBytask.FindFirst() then
                LaborRate := LabrrateBytask."NS_Labor Rate";
        end;

        //CTSI.95.MS.1.0 end
        //UnitsCompleteOnAfterValidate;//PRJ-350.MS.1.0 //PRJ-527.MS.1.0
        //CTSI-192.MS.1.0 start
        if (TotalBudget <> 0) or (TotalCostsUsed <> 0) or (JobForecast."NS_Cost To Complete" <> 0) then //CTSI-MS.1.0
            JobForecast."NS_View Open Tasks Only" := true;
        //PRJ-565.AS.1.0 12MARCH2021- COMMENT START
        // if (Complete = false) and (PreviousJobForecast."Hours To Finish" > 0) and (Rec."Hours To Finish" = 0) then
        //     CalCulateHoursToFinish(rec, JobLedEntry);//PRJ-565
        //PRJ-565.AS.1.0 12MARCH2021- COMMENT END
        JobForecast.Modify();
        Commit();

        //CTSI-192.MS.1.0 end

    end;


    procedure FillInTable(Var Rec: Record "NS_Job Forecast"; DefaultStatusDate: date; NextBillDate: date);
    var
        UseRecord: Boolean;
        JobTask: Record "Job Task";
        JobPlanningLineBudget: Record "Job Planning Line";
        PreviousJobForecast: Record "NS_Job Forecast";
        TotalBudget: Decimal;
        Job: record job;
        SumofTotalBudget: Decimal;//PRJ-537.MS.1.0;1
        SumOfTotalCostsUsed: Decimal;//PRJ-537.MS.1.0;2
        SumofBudgetRemaining: Decimal;//PRJ-537.MS.1.0;3
        BudgetRemaining: Decimal;
        BudgetPercentageUsed: Decimal;

        TotalTaskBudget: Decimal;
        TotalCostsUsed: Decimal;
        JobCostsUsed: Decimal;
        MonthEndDate: Date;
        ForecastedVariance: Decimal;
        SumofForecastedVariance: Decimal;//PRJ-537.MS.1.0;4
    begin
        BudgetRemaining := 0;
        if Rec."NS_Job No." > '' then begin

            //Fill in JobTask information on the Page if available
            if JobTask.GET(Rec."NS_Job No.", Rec."NS_Job Task No.") then;

            //Get previous completion status for the task
            Rec.NS_GetLastPostedStatus(Rec."NS_Job No.", Rec."NS_Job Task No.", 0D, PreviousJobForecast);
            Rec.NS_GetJobPlanningLineAndBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, TotalBudget, DefaultStatusDate);
            Rec.NS_GetBudgetHours(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, Rec."Budgeted Hours", DefaultStatusDate);
            Rec.NS_GetJobSumofTotalBudget(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofTotalBudget, DefaultStatusDate);//PRJ-537
            Rec.NS_GetSumOfTotalCostsUsed(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumOfTotalCostsUsed, DefaultStatusDate);//PRJ-537

            TotalCostsUsed := 0;
            if Job.GET(Rec."NS_Job No.") then begin
                Job.SETRANGE("NS_Job Task No. Filter", Rec."NS_Job Task No.");
                if NextBillDate > 0D then begin
                    if DATE2DMY(NextBillDate, 2) < 12 then
                        MonthEndDate := DMY2DATE(1, DATE2DMY(NextBillDate, 2) + 1, DATE2DMY(NextBillDate, 3)) - 1
                    else
                        MonthEndDate := DMY2DATE(31, 12, DATE2DMY(NextBillDate, 3));
                end;
                if DefaultStatusDate <> 0D then
                    Job.SETFILTER("NS_Date Filter", '..%1', DefaultStatusDate)
                else
                    Job.SETRANGE("NS_Date Filter");
                Job.CALCFIELDS("NS_Usage (Cost) (LCY)");
                TotalCostsUsed := Job."NS_Usage (Cost) (LCY)";

            end;

            //Budget Remaining
            if Rec."NS_Percent Complete" <= 100 then begin //prj-611 add  =
                BudgetRemaining := TotalBudget - TotalCostsUsed;
                //if BudgetRemaining <= 0 then //PRJ-611 comment
                //BudgetRemaining := 0;

                BudgetPercentageUsed := Rec.NS_CalcPercentFrom0To100(TotalBudget, TotalCostsUsed);

                //PRJ-545.MS.1.0 open this start  

                if (Rec."NS_Hours To Finish" = 0) then begin
                    if Rec."NS_Cost To Complete" = 0 then //PRJ-565
                        Rec."NS_Cost To Complete" := Rec.NS_CalcCostToComplete(Rec."NS_Status Date", Rec."NS_Percent Complete", TotalBudget, TotalCostsUsed,
                                                                 PreviousJobForecast."NS_Status Date",
                                                                 PreviousJobForecast."NS_Forecasted Completed Cost")
                    else
                        Rec."NS_Cost To Complete" := Rec."NS_Cost To Complete";
                end;

                Rec."NS_Forecasted Completed Cost" := TotalCostsUsed + Rec."NS_Cost To Complete";

            end;
            if Rec."NS_Percent Complete" <> 100 then
                ForecastedVariance := TotalBudget - Rec."NS_Forecasted Completed Cost"
            else
                ForecastedVariance := TotalBudget - TotalCostsUsed;
            Rec.NS_GetSumofBudgetRemaining(Rec."NS_Job No.", Rec."NS_Job Task No.", JobPlanningLineBudget, SumofBudgetRemaining, DefaultStatusDate, SumofForecastedVariance);//PRJ-537
        end;
    end;



    local procedure ListUpdate(VAR JobForecast: record "NS_Job Forecast"; LCurrentJobNo: Code[20]; LCurrentTaskManager: Code[100])
    var
        StartBillingPeriod: Date;
        EndBillingPeriod: Date;
        //JobForecast: Record "Job Forecast";
        CurrentJobNo: Code[20];
        CurrentTaskManager: Code[100];
        ViewOpenTaskonly: Boolean;
        JFWorsheetpage: Page "NS_Job Forecast Worksheet";
    begin
        JobForecast.RESET;
        JobForecast.FILTERGROUP := 2;
        if ViewOpenTaskonly = true then//CTSI-192.MS.1.0
            JobForecast.SetFilter("NS_View Open Tasks Only", '%1', true); //CTSI-192.MS.1.0
        JobForecast.SETRANGE("NS_Job No.");
        JobForecast.SETRANGE("NS_Task Manager");
        if LCurrentJobNo > '' then
            JobForecast.SETRANGE("NS_Job No.", LCurrentJobNo);
        if LCurrentTaskManager > '' then
            JobForecast.SETRANGE("NS_Task Manager", LCurrentTaskManager);
        JobForecast.SETRANGE(NS_Posted, false);
        JobForecast.FILTERGROUP := 0;
        if JobForecast.FINDSET then;
        JobForecast.GetNewTasks(LCurrentJobNo, LCurrentTaskManager);
        //CurrPage.UPDATE(false);
    end;
    //SK End

    //AS - END COMMENT
    //CTSI-285.MS.1.0 start
    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure T88OnAfterStatusValidate(var Rec: Record Job; var xRec: Record Job)
    begin
        if rec.Status = Rec.Status::Completed then begin
            rec."NS_Revenue Recognized" := true;
            rec.Modify();
        end;
    end;
    //CTSI-285.MS.1.0 end


    //PRJ-623.MS.1.0 start
    [EventSubscriber(ObjectType::Table, 169, 'OnBeforeInsertEvent', '', false, false)]
    LOCAL procedure NS_T169OnBeforeInsert(var Rec: Record "Job Ledger Entry")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        if Rec."NS_Burden Amount" > 0 then begin
            Rec."Total Cost" := Rec."Total Cost" + rec."NS_Burden Amount";
            if Rec."Currency Code" <> '' then
                Rec."Total Cost" := Round(CurrExchRate.ExchangeAmtLCYToFCY(Rec."Posting Date",
                                                   Rec."Currency Code", Rec."Total Cost (LCY)",
                                                   CurrExchRate.ExchangeRate(Rec."Posting Date", Rec."Currency Code")),
                                                   Currency."Amount Rounding Precision");

            Rec."Total Cost (LCY)" := Rec."Total Cost (LCY)" + rec."NS_Burden Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Report, 1095, 'OnPostTotalCostAdjustmentOnBeforeJobLedgEntryModify', '', false, false)]
    LOCAL procedure NS_R1095OnPostTotalCostAdjustmentOnBeforeJobLedgEntryModify(var JobLedgerEntry: Record "Job Ledger Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        if JobLedgerEntry."NS_Burden Amount" > 0 then begin
            JobLedgerEntry."Total Cost" := JobLedgerEntry."Total Cost" + JobLedgerEntry."NS_Burden Amount";
            if JobLedgerEntry."Currency Code" <> '' then
                JobLedgerEntry."Total Cost" := Round(CurrExchRate.ExchangeAmtLCYToFCY(JobLedgerEntry."Posting Date",
                                                   JobLedgerEntry."Currency Code", JobLedgerEntry."Total Cost (LCY)",
                                                   CurrExchRate.ExchangeRate(JobLedgerEntry."Posting Date", JobLedgerEntry."Currency Code")),
                                                   Currency."Amount Rounding Precision");
            JobLedgerEntry."Total Cost (LCY)" := JobLedgerEntry."Total Cost (LCY)" + JobLedgerEntry."NS_Burden Amount";
        end;

    end;

    [EventSubscriber(ObjectType::Report, 1095, 'OnBeforePostTotalCostAdjustment', '', false, false)]
    LOCAL procedure NS_R1095OnBeforePostTotalCostAdjustment(ItemLedgerEntry: Record "Item Ledger Entry"; JobLedgerEntryCostValueACY: Decimal; JobLedgerEntryCostValue: Decimal; var AdjustJobCost: Decimal; var AdjustJobCostLCY: Decimal; var IsHandled: Boolean; var JobLedgEntry: Record "Job Ledger Entry"; var NoOfJobLedgEntry: Integer)
    var
    begin
        if JobLedgEntry.Adjusted = true then
            IsHandled := true;
    end;
    //PRJ-623.MS.1.0 end

    //PRJ-882.JS.1.0   25Aug2021-start
    [EventSubscriber(ObjectType::Table, database::Customer, 'OnBeforeGetSalesLCY', '', false, false)]
    local procedure NSGetSalesLCY(var Customer: Record Customer; var IsHandled: Boolean; var SalesLCY: Decimal)
    var
        AccountingPeriod: Record "Accounting Period";
        StartDate: Date;
        EndDate: Date;
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate);
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", Customer."No.");
        CustLedgEntry.SetRange("Posting Date", StartDate, EndDate);
        CustLedgEntry.SetRange("NS_Retention Ledger Code", 'NORMAL');
        CustLedgEntry.CalcSums("Sales (LCY)");
        SalesLCY := CustLedgEntry."Sales (LCY)";
        IsHandled := true;
    end;
    //PRJ-882.JS.1.0   25Aug2021-end  

    //PRJ-931.JS.1.0 24Sep2021-Start
    //PRJ-1003.JS.1.0 25Oct2021-Start
    //PRJ-1004.JS.1.0 25Oct2021-Start
    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnUpdateUnitPriceOnBeforeFindPrice', '', false, false)]
    local procedure NS_R37OnUpdateUnitPriceOnBeforeFindPrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CallingFieldNo: Integer; var IsHandled: boolean)
    var
    // NS_SalesRecSetup: Record "Sales & Receivables Setup";//PRJ-1003.JS.1.0 25Oct2021 Commented Code
    // NS_Item: Record item;//PRJ-1003.JS.1.0 25Oct2021 Commented Code
    begin
        //PRJ-1003.JS.1.0 25Oct2021 Commented Code - start
        // if SalesLine.type = SalesLine.type::item then begin
        //     NS_SalesRecSetup.get();
        //     if NS_SalesRecSetup."NS_Disable Sales Price" then begin
        //         IsHandled := true;
        //         if NS_Item.get(SalesLine."No.") then
        //             SalesLine."Unit Price" := NS_Item."Unit Price";
        //     end
        // end;
        //PRJ-1003.JS.1.0 25Oct2021 Commented Code - end
    end;
    //PRJ-931.JS.1.0 24Sep2021-end
    //PRJ-1003.JS.1.0 25Oct2021-end
    //PRJ-1004.JS.1.0 25Oct2021-end      

    //PRJ-952.AS.1.0 - start
    [EventSubscriber(ObjectType::Table, Database::"Standard General Journal", 'OnAfterCopyGenJnlFromStdJnl', '', false, false)]
    local procedure CopyVendorCustomerRetentionLedger(StdGenJournalLine: Record "Standard General Journal Line"; var GenJournalLine: Record "Gen. Journal Line")
    var
        NS_SalesSetupT: Record "Sales & Receivables Setup";
        NS_PurchSetupT: Record "Purchases & Payables Setup";
    begin
        NS_SalesSetupT.Get();
        NS_PurchSetupT.Get();

        if StdGenJournalLine."Account Type" = StdGenJournalLine."Account Type"::Vendor then begin
            IF NOT NS_PurchSetupT."NS_Purchase Retention Inactive" THEN
                GenJournalLine."NS_Retention Ledger Code" := NS_PurchSetupT."NS_Normal Vendor Ledger No.";
        end;

        if StdGenJournalLine."Account Type" = StdGenJournalLine."Account Type"::Customer then begin
            IF NOT NS_SalesSetupT."NS_Sales Retention Inactive" THEN
                GenJournalLine."NS_Retention Ledger Code" := NS_SalesSetupT."NS_Normal Customer Ledger No.";
        end;
    end;
    //PRJ-952.AS.1.0 - end

    //PPDA.1.0 Start
    [IntegrationEvent(False, false)]
    local procedure OnBeforeSetTaxToBeExpensed(Var PurchLine: Record "Purchase Line")
    begin
    end;
    //PPDA.1.0 End
}

