page 14021170 "NS_Rcvd. Not Invoiced Accrual"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    SourceTable = "Purch. Rcpt. Line";
    Caption = 'Rcvd. Not invoiced Accural';
    SourceTableView = SORTING("Job No.", "Job Task No.", "No.", NS_Staged)
                      WHERE("Quantity Invoiced" = CONST(0));

    UsageCategory = Lists;//PRJ-428.AS.1.0 09FEB2021
    ApplicationArea = Jobs;//PRJ-428.AS.1.0 09FEB2021
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field("Post Accrual"; Rec."NS_Post Accrual")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Post Accrual';
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the No.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qty. Rcd. Not Invoiced';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document No.';
                }
                field("Accrual Posted"; Rec."NS_Accrual Posted")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Accrual Posted';
                }
                field("Accrual Account No."; Rec."NS_Accrual Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Accrual Account No.';
                }
                field("Bal. Accrual Account No."; Rec."NS_Bal. Accrual Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bal. Accrual Account No.';
                }
                field("Job Cost Category"; Rec."NS_Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Cost Category';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("NS_Post Accruals")
            {
                Caption = 'Post Accruals';
                ToolTip = 'Post the accruals';
                ApplicationArea = All;

                trigger OnAction();
                begin
                    NS_PostAccruals;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        NS_GetRcvdNotInvoiced;
        if DocNumFilter <> '' then
            SETFILTER("Document No.", DocNumFilter);
    end;

    var
        PostAccrual: Boolean;
        JobNoFilter: Text[250];
        TaskFilter: Text[250];
        PostDateFilter: Text[100];
        DocNumFilter: Text[1000];
        JnlTemplateName_Lbl: Label 'GENERAL';
        JnlLineSourceCode_Lbl: Label 'GENJNL';

    procedure NS_GetRcvdNotInvoiced();
    var
        PurchRcvdLine: Record "Purch. Rcpt. Line";
        PurchRcvdHeader: Record "Purch. Rcpt. Header";
        Job: Record Job;
        JobTask: Record "Job Task";
        CostCat: Record "NS_Job Cost Category";
    begin
        Job.RESET();
        if JobNoFilter <> '' then
            Job.SETFILTER("No.", JobNoFilter);
        Job.FINDSET();
        repeat
            PurchRcvdHeader.RESET();
            PurchRcvdHeader.SETRANGE("NS_Job No.", Job."No.");
            if PostDateFilter <> '' then
                PurchRcvdHeader.SETFILTER("Posting Date", PostDateFilter);
            if PurchRcvdHeader.FINDSET() then
                repeat
                    PurchRcvdLine.RESET();
                    PurchRcvdLine.SETRANGE("Document No.", PurchRcvdHeader."No.");
                    PurchRcvdLine.SETRANGE("Quantity Invoiced", 0);
                    PurchRcvdLine.SETRANGE("NS_Accrual Posted", false);
                    if TaskFilter <> '' then
                        PurchRcvdLine.SETFILTER("Job Task No.", TaskFilter);
                    if PurchRcvdLine.FINDSET() then
                        repeat
                            if DocNumFilter = '' then
                                DocNumFilter := PurchRcvdLine."Document No."
                            else
                                DocNumFilter += '|' + PurchRcvdLine."Document No.";
                        //CostCat.RESET;
                        //CostCat.SETRANGE(Code,PurchRcvdLine."Job Cost Category");
                        //IF CostCat.FINDFIRST THEN BEGIN
                        //PurchRcvdLine."Accrual Account No." := CostCat."G/L Account No.";
                        //PurchRcvdLine."Bal. Accrual Account No." := CostCat."Bal. Account No.";
                        //PurchRcvdLine.MODIFY;
                        //END;
                        until PurchRcvdLine.NEXT() = 0;
                until PurchRcvdHeader.NEXT() = 0
            else begin
                PurchRcvdLine.RESET();
                PurchRcvdLine.SETRANGE("Job No.", Job."No.");
                PurchRcvdLine.SETRANGE("Quantity Invoiced", 0);
                PurchRcvdLine.SETRANGE("NS_Accrual Posted", false);
                if TaskFilter <> '' then
                    PurchRcvdLine.SETFILTER("Job Task No.", TaskFilter);
                if PostDateFilter <> '' then
                    PurchRcvdLine.SETFILTER("Posting Date", PostDateFilter);
                if PurchRcvdLine.FINDSET() then
                    repeat
                        if DocNumFilter = '' then
                            DocNumFilter := PurchRcvdLine."Document No."
                        else
                            DocNumFilter += '|' + PurchRcvdLine."Document No.";
                    //CostCat.RESET;
                    //CostCat.SETRANGE(Code,PurchRcvdLine."Job Cost Category");
                    //IF CostCat.FINDFIRST THEN BEGIN
                    //PurchRcvdLine."Accrual Account No." := CostCat."G/L Account No.";
                    //PurchRcvdLine."Bal. Accrual Account No." := CostCat."Bal. Account No.";
                    //PurchRcvdLine.MODIFY;
                    //END;
                    until PurchRcvdLine.NEXT() = 0;
            end;
        until Job.NEXT() = 0;
    end;

    local procedure NS_PostAccruals();
    var
        GenJnlLine: Record "Gen. Journal Line";
        PurchRcvdLine: Record "Purch. Rcpt. Line";
        AccrAcct: Code[20];
        OffsetAccrAcct: Code[20];
        JnlTemplate: Code[10];
        BatchName: Code[10];
        LineNum: Integer;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        CostCat: Record "NS_Job Cost Category";
        JobSetup: Record "Jobs Setup";
    begin
        JobSetup.GET();
        JnlTemplate := JnlTemplateName_Lbl;
        BatchName := JobSetup."NS_Received Accrual Batch Name";
        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Template Name", JnlTemplate);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        if GenJnlLine.FINDLAST() then
            LineNum := GenJnlLine."Line No."
        else
            LineNum := 0;
        PurchRcvdLine.COPYFILTERS(Rec);
        PurchRcvdLine.SETRANGE("NS_Post Accrual", true);
        PurchRcvdLine.SETRANGE("NS_Accrual Posted", false);
        if PurchRcvdLine.FINDSET() then
            repeat
                CostCat.RESET();
                CostCat.SETRANGE(NS_Code, PurchRcvdLine."NS_Job Cost Category");
                if CostCat.FINDFIRST() then begin
                    if PurchRcvdLine."NS_Accrual Account No." = '' then
                        AccrAcct := CostCat."NS_G/L Account No."
                    else
                        AccrAcct := PurchRcvdLine."NS_Accrual Account No.";
                    if PurchRcvdLine."NS_Bal. Accrual Account No." = '' then
                        OffsetAccrAcct := CostCat."NS_Bal. Account No."
                    else
                        OffsetAccrAcct := PurchRcvdLine."NS_Bal. Accrual Account No.";
                end;
                GenJnlLine.INIT();
                GenJnlLine."Journal Template Name" := JnlTemplate;
                GenJnlLine."Journal Batch Name" := BatchName;
                LineNum += 10000;
                GenJnlLine."Line No." := LineNum;
                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.", AccrAcct);
                GenJnlLine.VALIDATE("Posting Date", PurchRcvdLine."Posting Date");
                GenJnlLine."Document No." := PurchRcvdLine."Document No.";
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", OffsetAccrAcct);
                GenJnlLine.VALIDATE("Currency Code", PurchRcvdLine."Currency Code");
                GenJnlLine.VALIDATE(Amount, PurchRcvdLine.Quantity * PurchRcvdLine."Unit Cost");
                GenJnlLine.VALIDATE("Source Code", JnlLineSourceCode_Lbl);
                GenJnlLine.VALIDATE("Job No.", PurchRcvdLine."Job No.");
                GenJnlLine.VALIDATE("Job Task No.", PurchRcvdLine."Job Task No.");
                GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Purchase;
                GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Sales Tax";
                GenJnlLine."Job Quantity" := PurchRcvdLine.Quantity;
                GenJnlLine.INSERT(true);
                PurchRcvdLine."NS_Accrual Posted" := true;
                PurchRcvdLine.MODIFY();
            until PurchRcvdLine.NEXT() = 0;
        GenJnlLine.RESET();
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Journal Template Name", JnlTemplate);
        if not GenJnlLine.ISEMPTY() then
            GenJnlPost.RUN(GenJnlLine);
    end;
}

