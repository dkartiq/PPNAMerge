report 14021401 "NS_Load Job Jnl from JMP"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-134.VT.1.0 Added code
    //PRJ-394.MS.1.0 added code for GBPG
    //TM-10.AM.1.0 | Added Segment Code Flow .
    //PE-48.RM.1.0 15Feb2023 | Added a caption
    //PE-144.RM.1.0 09Aug2023 | Added a new caption 
    // Caption = 'Load Job Jnl from JMP'; //PE-144.RM.1.0 09Aug2023 commented
    //PE-180.VC.1.0 04Oct2023 | Location Code is not getting populated on Job Journal through JMP Requisition Worksheet.
    Caption = 'Suggest Available Inventory for JMP requirements'; //PE-144.RM.1.0 09Aug2023 
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 1;

            trigger OnAfterGetRecord();
            begin
                //PE-291.JS.1.0 - Start
                clear(NSBaseAppIDCode);
                NSBaseAppIDCode := NSEnviroInfo.VersionInstalled(NSBaseAppId.Get());
                //PE-291.JS.1.0 - end
                JobSU.GET();
                JobMatPlan.RESET();
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", JobNo);
                JobMatPlan.SETRANGE("NS_Document No.", DocumentNo);
                JobMatPlan.SETFILTER("NS_Date Ordered By", '<=%1', AsOfDate);
                JobMatPlan.SETFILTER("NS_Bal. Req", '>%1', 0);
                JobMatPlan.SETFILTER("NS_Inv. Avail", '>%1', 0);
                if JobMatPlan.FINDSET(true, false) then
                    repeat
                        if Item.GET(JobMatPlan."NS_Part No.") then;
                        if not AddLine then begin
                            LineNo += 10000;
                            JobJnlLine."Journal Template Name" := 'JOB';
                            //JobJnlLine."Journal Batch Name" := JobNo;//PRJ-134 VIKAS
                            JobJnlLine."Journal Batch Name" := CopyStr(JobNo, 1, 10);//PRJ-134 VIKAS
                            JobJnlLine."Line No." := LineNo;
                            JobJnlLine."Job No." := JobNo;
                            JobJnlLine."Document No." := DocumentNo;
                            JobJnlLine."Posting Date" := AsOfDate;
                            JobJnlLine."Document Date" := AsOfDate;
                            JobJnlLine.Description := JobMatPlan.NS_Description;
                            JobJnlLine.Type := JobJnlLine.Type::Item;
                            JobJnlLine.VALIDATE("No.", JobMatPlan."NS_Part No.");
                            JobJnlLine."Job Task No." := JobMatPlan."NS_Order Code";
                            if Job.GET(JobNo) then; //PRJ-394 start
                                                    // if Job."NS_Gen. Bus. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                                                    //     JobJnlLine."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group"//PRJ-394 end //PRJ-831.AS.1.0 12OCT2021 Comment old

                            if Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                                JobJnlLine."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group New"//PRJ-394 end //PRJ-831.AS.1.0 12OCT2021 Add New
                            else
                                JobJnlLine."Gen. Bus. Posting Group" := JobSU."NS_Gen. Bus. Posting Group";
                            JobJnlLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            JobJnlLine."NS_Segment Code" := JobMatPlan."NS_Segment Code";//TM-10.AM.1.0
                            if Job.GET(JobNo) then begin
                                //PE-180.VC.1.0 04Oct2023 Start
                                //JobJnlLine."Location Code" := JobSU."NS_Job Mat'l Planning Location"; //PE-180.VC.1.0 04Oct2023 Commented
                                JobJnlLine."Location Code" := JobMatPlan."NS_Location Code";
                                //PE-180.VC.1.0 04Oct2023 End                                    
                                JobJnlLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                                JobJnlLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                            end else
                                JobJnlLine."Location Code" := JobSU."NS_Job Mat'l Planning Location";

                            //PE-291.JS.1.0 - Start
                            //JobJnlLine."Source Code" := 'JOBJNL';
                            if NSBaseAppIDCode < 24 then
                                JobJnlLine."Source Code" := 'JOBJNL'
                            else
                                JobJnlLine."Source Code" := 'PROJJNL';
                            //PE-291.JS.1.0 - end    
                            if UseQOH then
                                JobJnlLine.VALIDATE(Quantity, CalcReqQty(JobNo, JobMatPlan."NS_Part No.", JobMatPlan.NS_Quantity))
                            else
                                JobJnlLine.VALIDATE(Quantity, JobMatPlan."NS_Bal. Req");
                            //PE-279.NC.1.0 08Apr2024 Start
                            if JobSU."NS_Flow Job Card Dimension" then begin
                                if JobTask.Get(JobNo, JobMatPlan."NS_Order Code") then;
                                if ((JobTask."Global Dimension 1 Code" <> '') or (JobTask."Global Dimension 2 Code" <> '')) then begin
                                    JobJnlLine."Shortcut Dimension 1 Code" := JobTask."Global Dimension 1 Code";
                                    JobJnlLine."Shortcut Dimension 2 Code" := JobTask."Global Dimension 2 Code";
                                    JobJnlLine."Dimension Set ID" := JobMatPlan.NS_GetDimensionNoFromJobTask(JobTask."Job No.", JobTask."Job Task No.");
                                end else begin
                                    if ((Job."Global Dimension 1 Code" <> '') or (Job."Global Dimension 2 Code" <> '')) then begin
                                        JobJnlLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                                        JobJnlLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                                        JobJnlLine."Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(Job."No.");
                                    end else begin
                                        JobJnlLine."Shortcut Dimension 1 Code" := item."Global Dimension 1 Code";
                                        JobJnlLine."Shortcut Dimension 2 Code" := item."Global Dimension 2 Code";
                                        JobJnlLine."Dimension Set ID" := JobMatPlan.GetDimensionNoFromItemNo(Item."No.");
                                    end;
                                end;
                            end;
                            //PE-279.NC.1.0 08Apr2024 End
                            if JobJnlLine.Quantity > 0 then
                                if not JobJnlLine.INSERT then
                                    JobJnlLine.MODIFY;
                        end else begin
                            LineNo += 10000;
                            JobJnlLine."Journal Template Name" := 'JOB';
                            //JobJnlLine."Journal Batch Name" := JobNo;//PRJ-134 VIKAS
                            JobJnlLine."Journal Batch Name" := CopyStr(JobNo, 1, 10);//PRJ-134 VIKAS
                            JobJnlLine."Line No." := LineNo;
                            JobJnlLine."Job No." := JobNo;
                            JobJnlLine."Document No." := DocumentNo;
                            JobJnlLine."Posting Date" := AsOfDate;
                            JobJnlLine."Document Date" := AsOfDate;
                            JobJnlLine.Description := JobMatPlan.NS_Description;
                            JobJnlLine.Type := JobJnlLine.Type::Item;
                            JobJnlLine.VALIDATE("No.", JobMatPlan."NS_Part No.");
                            JobJnlLine."Job Task No." := JobMatPlan."NS_Order Code";
                            if Job.GET(JobNo) then; //PRJ-394 start
                                                    // if Job."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
                                                    //     JobJnlLine."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group"//PRJ-394 end //PRJ-831.AS.1.0 12OCT2021 Comment old

                            if Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                                JobJnlLine."Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group New"//PRJ-394 end //PRJ-831.AS.1.0 12OCT2021 Add New
                            else
                                JobJnlLine."Gen. Bus. Posting Group" := JobSU."NS_Gen. Bus. Posting Group";
                            JobJnlLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            JobJnlLine."NS_Segment Code" := JobMatPlan."NS_Segment Code";//TM-10.AM.1.0
                            if Job.GET(JobNo) then begin
                                //PE-180.VC.1.0 04Oct2023 Start 
                                //JobJnlLine."Location Code" := JobSU."NS_Job Mat'l Planning Location"; //PE-180.VC.1.0 04Oct2023 Commented                              
                                JobJnlLine."Location Code" := JobMatPlan."NS_Location Code";
                                //PE-180.VC.1.0 04Oct2023 End                                
                                JobJnlLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                                JobJnlLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                            end else
                                JobJnlLine."Location Code" := JobSU."NS_Job Mat'l Planning Location";

                            //PE-291.JS.1.0 - Start
                            //JobJnlLine."Source Code" := 'JOBJNL';
                            if NSBaseAppIDCode < 24 then
                                JobJnlLine."Source Code" := 'JOBJNL'
                            else
                                JobJnlLine."Source Code" := 'PROJJNL';
                            //PE-291.JS.1.0 - end                              
                            if UseQOH then
                                JobJnlLine.VALIDATE(Quantity, CalcReqQty(JobNo, JobMatPlan."NS_Part No.", JobMatPlan.NS_Quantity))
                            else
                                JobJnlLine.VALIDATE(Quantity, JobMatPlan."NS_Bal. Req");
                            //PE-279.NC.1.0 08Apr2024 Start
                            if JobSU."NS_Flow Job Card Dimension" then begin
                                if JobTask.Get(JobNo, JobMatPlan."NS_Order Code") then;
                                if ((JobTask."Global Dimension 1 Code" <> '') or (JobTask."Global Dimension 2 Code" <> '')) then begin
                                    JobJnlLine."Shortcut Dimension 1 Code" := JobTask."Global Dimension 1 Code";
                                    JobJnlLine."Shortcut Dimension 2 Code" := JobTask."Global Dimension 2 Code";
                                    JobJnlLine."Dimension Set ID" := JobMatPlan.NS_GetDimensionNoFromJobTask(JobTask."Job No.", JobTask."Job Task No.");
                                end else begin
                                    if ((Job."Global Dimension 1 Code" <> '') or (Job."Global Dimension 2 Code" <> '')) then begin
                                        JobJnlLine."Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                                        JobJnlLine."Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                                        JobJnlLine."Dimension Set ID" := JobMatPlan.GetDimensionNoFromJob(Job."No.");
                                    end else begin
                                        JobJnlLine."Shortcut Dimension 1 Code" := item."Global Dimension 1 Code";
                                        JobJnlLine."Shortcut Dimension 2 Code" := item."Global Dimension 2 Code";
                                        JobJnlLine."Dimension Set ID" := JobMatPlan.GetDimensionNoFromItemNo(Item."No.");
                                    end;
                                end;
                            end;
                            //PE-279.NC.1.0 08Apr2024 End
                            if JobJnlLine.Quantity > 0 then
                                if not JobJnlLine.INSERT then
                                    JobJnlLine.MODIFY;
                        end;
                    until JobMatPlan.NEXT = 0;
            end;

            trigger OnPostDataItem();
            begin
                UpdateJMPQtys;
            end;

            trigger OnPreDataItem();
            var
                JobBatch: Record "Job Journal Batch";
            begin
                if JobNo = '' then
                    ERROR(Text0001);

                CalcQtys(JobNo);

                if not Job.GET(JobNo) then
                    ERROR(STRSUBSTNO(Text0006, JobNo));

                if DocumentNo = '' then
                    ERROR(Text0003);

                if AsOfDate = 0D then
                    ERROR(Text0004);

                JobBatch.RESET;
                JobBatch.SETRANGE("Journal Template Name", 'JOB');
                //JobBatch.SETRANGE(Name, JobNo);//PRJ-134 VIKAS
                JobBatch.SETRANGE(Name, CopyStr(JobNo, 1, 10));//PRJ-134 VIKAS
                if not JobBatch.FINDFIRST then begin
                    JobBatch.INIT;
                    JobBatch."Journal Template Name" := 'JOB';
                    //JobBatch.Name := JobNo;//PRJ-134 VIKAS
                    JobBatch.Name := CopyStr(JobNo, 1, 10);//PRJ-134 VIKAS
                    JobBatch.Description := Job.Description;
                    JobBatch.INSERT;
                end;

                JobJnlLine.RESET;
                JobJnlLine.SETCURRENTKEY("Job No.", Type, "No.");

                if AddLine then begin
                    JobJnlLine2.RESET;
                    JobJnlLine2.SETRANGE("Journal Template Name", 'JOB');
                    //JobJnlLine2.SETRANGE("Journal Batch Name", JobNo);//PRJ-134 VIKAS
                    JobJnlLine2.SETRANGE("Journal Batch Name", CopyStr(JobNo, 1, 10));//PRJ-134 VIKAS
                    if JobJnlLine2.FINDLAST then
                        LineNo := JobJnlLine2."Line No."
                    else
                        LineNo := 10000;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1100773001)
                {
                    // Caption = 'Load Job Jnl from JMP'; //PE-48.RM.1.0 15Feb2023 //PE-144.RM.1.0 09Aug2023 commented
                    Caption = ''; //PE-144.RM.1.0 09Aug2023

                    field(JobNo; JobNo)
                    {
                        Caption = 'Job No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'Document No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(UseQOH; UseQOH)
                    {
                        Caption = 'Use Available Inventory';
                        Editable = false;//PE-146.NK.1.0 09Aug2023
                        ApplicationArea = All;
                    }
                    field(AsOfDate; AsOfDate)
                    {
                        Caption = 'As Of Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            UseQOH := true;
        end;
    }

    labels
    {
    }

    var

        JobMatPlan: Record "NS_Job Material Planning";
        JobSU: Record "Jobs Setup";
        Item: Record Item;
        JobTask: Record "Job Task";
        JobJnlLine: Record "Job Journal Line";
        JobJnlLine2: Record "Job Journal Line";
        UseQOH: Boolean;
        AsOfDate: Date;
        JobNo: Code[20];
        JobTaskNo: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        LineNo2: Integer;

        NSEnviroInfo: codeunit "Environment information";  //PE-291.JS.1.0
        NSBaseAppId: Codeunit "BaseApp ID";  //PE-291.JS.1.0
        NSBaseAppIDCode: Integer;   //PE-291.JS.1.0        
        ItemLedgerEntry: Record "Item Ledger Entry";
        Text0001: Label 'Job No. Must Be Filled In';
        Text0002: Label 'Job Task No. Must Be Filled In';
        Text0003: Label 'Document No. Must Be Filled In';
        Text0004: Label 'You Must Select a Valid As Of Date';
        Text0005: Label 'There are no matching Job Material Planning Lines!';
        Job: Record Job;
        Text0006: Label 'Job No. %1 Does Not Exists.';
        AddLine: Boolean;

    procedure InitVar(lJobNo: Code[20]; lDocNo: Code[20]; lAsOfDate: Date; YesNo: Boolean);
    begin
        JobNo := lJobNo;
        DocumentNo := lDocNo;
        AsOfDate := lAsOfDate;
        AddLine := YesNo;
    end;

    procedure CalcReqQty(lJobNo: Code[20]; lPartNo: Code[20]; lQty: Decimal): Decimal;
    var
        JnlQty: Decimal;
        ILEQty: Decimal;
        iQuantity: Decimal;
    begin
        JobJnlLine.RESET;
        JobJnlLine.SETCURRENTKEY("Job No.", Type, "No.");
        JobJnlLine.SETRANGE("Job No.", lJobNo);
        JobJnlLine.SETRANGE(Type, JobJnlLine.Type::Item);
        JobJnlLine.SETRANGE("No.", lPartNo);
        JobJnlLine.CALCSUMS(Quantity);
        JnlQty := JobJnlLine.Quantity;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.");
        ItemLedgerEntry.SETRANGE("Item No.", lPartNo);
        ItemLedgerEntry.CALCSUMS(Quantity);
        ILEQty := ItemLedgerEntry.Quantity - iQuantity;

        iQuantity := ILEQty - JnlQty;
        if iQuantity < lQty then
            exit(iQuantity)
        else
            exit(lQty);
    end;

    procedure UpdateJMPQtys();
    begin
        JobMatPlan.RESET;
        JobJnlLine.RESET;

        JobJnlLine.SETRANGE("Journal Template Name", 'JOB');
        //JobJnlLine.SETRANGE("Journal Batch Name", JobNo);
        JobJnlLine.SETRANGE("Journal Batch Name", CopyStr(JobNo, 1, 10));//PRJ-134 VIKAS
        JobJnlLine.SETRANGE("Job No.", JobNo);
        JobJnlLine.SETRANGE("Document No.", DocumentNo);
        if JobJnlLine.FINDSET(false, false) then
            repeat
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", JobJnlLine."Journal Batch Name");
                JobMatPlan.SETRANGE("NS_Document No.", JobJnlLine."Document No.");
                JobMatPlan.SETRANGE("NS_Part No.", JobJnlLine."No.");
                if JobMatPlan.FINDFIRST() then begin
                    JobMatPlan."NS_Bal. Req" := ABS(JobMatPlan."NS_Bal. Req" - JobJnlLine.Quantity);
                    JobMatPlan."NS_Inv. Avail" := JobMatPlan."NS_Inv. Avail" - JobJnlLine.Quantity;
                    JobMatPlan.MODIFY();
                end;
            until JobJnlLine.NEXT = 0;
    end;

    procedure CalcQtys(JobNo: Code[20]);
    var
        lJobJnlLine: Record "Job Journal Line";
        iQuantity: Decimal;
        lItemLedgerEntry: Record "Item Ledger Entry";
        lJMP: Record "NS_Job Material Planning";
    begin
        if JobNo <> '' then
            lJMP.SETRANGE("NS_Worksheet Job No.", JobNo);
        if lJMP.FINDSET() then
            repeat
                lJobJnlLine.RESET();
                lJobJnlLine.SETCURRENTKEY("Job No.", Type, "No.");
                lJobJnlLine.SETRANGE(Type, lJobJnlLine.Type::Item);
                lJobJnlLine.SETRANGE("No.", lJMP."NS_Part No.");
                lJobJnlLine.CALCSUMS(Quantity);
                iQuantity := lJobJnlLine.Quantity;

                lItemLedgerEntry.RESET();
                lItemLedgerEntry.SETCURRENTKEY("Item No.");
                lItemLedgerEntry.SETRANGE("Item No.", lJMP."NS_Part No.");
                lItemLedgerEntry.CALCSUMS(Quantity);
                lJMP."NS_Inv. Avail" := lItemLedgerEntry.Quantity - iQuantity;

                lJMP.CALCFIELDS("NS_Inv. Qty", "NS_PO Qty", "NS_Job Site", "NS_PO Qty Rcd", "NS_Quantity Invoiced");
                lJMP."NS_Bal. Req" := lJMP.NS_Quantity - (lJMP."NS_Inv. Qty" + lJMP."NS_Job Site From Inv.") - lJMP."NS_PO Qty" - lJMP."NS_PO Qty Rcd" - lJMP."NS_Inventory Qty. Staged";
                if lJMP."NS_Bal. Req" < 0 then
                    lJMP."NS_Bal. Req" := 0;
                lJMP.MODIFY();
            until lJMP.NEXT() = 0;
        COMMIT;
    end;
}

