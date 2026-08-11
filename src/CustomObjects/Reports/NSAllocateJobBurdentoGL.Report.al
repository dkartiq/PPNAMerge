report 14021167 "NS_Allocate Job Burden to G/L"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-401.MS.1.0 aaded property for showing in RTC

    Permissions = TableData "Job Ledger Entry" = rm;
    Caption = 'Allocate Job Burden to G/L';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis; //PRJ-401
    ApplicationArea = all;//PRJ-401    

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = WHERE("NS_Burden Amount" = FILTER(> 0), "NS_Burden Amount Posted to G/L" = CONST(0));

            trigger OnAfterGetRecord();
            begin
                Job.GET("Job No.");

                //Set BurdenAllocSecondDimension & BurdenAllocSecondDimensionCode to values for this entry
                BurdenAllocateSecondDimensionCode := '';
                case true of
                    JobsSetup."NS_Burden Alloc Secondary Dim" = GLSetup."Global Dimension 1 Code":
                        BurdenAllocateSecondDimensionCode := Job."Global Dimension 1 Code";
                    JobsSetup."NS_Burden Alloc Secondary Dim" = GLSetup."Global Dimension 2 Code":
                        BurdenAllocateSecondDimensionCode := Job."Global Dimension 2 Code";
                end;

                //Accumulate the "Burdan Amount" into the proper TotalSetValue
                if (i > 0) and (BurdenAllocateSecondDimensionCode > '') then begin
                    Accumulated := false;
                    for j := 1 to i do begin  //Search through table for a match
                        case "NS_Burden Type" of
                            "NS_Burden Type"::Project:
                                if (TotalSetName[j, 1] = JobsSetup."NS_Burden AllocProjectDimValue") and
                                   (TotalSetName[j, 2] = BurdenAllocateSecondDimensionCode) then begin
                                    TotalSetValue[j] := TotalSetValue[j] + "NS_Burden Amount";
                                    Accumulated := true;
                                    j := i;
                                end;
                            "NS_Burden Type"::Service:
                                if (TotalSetName[j, 1] = JobsSetup."NS_Burden AllocServiceDimValue") and
                                   (TotalSetName[j, 2] = BurdenAllocateSecondDimensionCode) then begin
                                    TotalSetValue[j] := TotalSetValue[j] + "NS_Burden Amount";
                                    Accumulated := true;
                                    j := i;
                                end;
                        end;
                    end;
                    if not Accumulated then
                        ERROR(Text005, Job."No.", "NS_Burden Type", BurdenAllocateSecondDimensionCode);
                end else begin
                    //Add to the two arrays beyond i as blank Job."Shortcut Dimension x Code"s
                    case "NS_Burden Type" of
                        "NS_Burden Type"::Project:
                            TotalSetValue[i + 1] := TotalSetValue[i + 1] + "NS_Burden Amount";
                        "NS_Burden Type"::Service:
                            TotalSetValue[i + 2] := TotalSetValue[i + 2] + "NS_Burden Amount";
                    end;
                end;

                "NS_Burden Amount Posted to G/L" := "NS_Burden Amount";
                "NS_Burden Posting Document No." := DocumentNo;
                MODIFY;
            end;

            trigger OnPreDataItem();
            begin
                JobsSetup.GET;
                GLSetup.GET;
                //Create a set of Secondary Dimension totals
                i := 0;
                with DimensionValue do begin
                    RESET;
                    SETRANGE("Dimension Code", JobsSetup."NS_Burden Alloc Secondary Dim");
                    if FINDSET then
                        repeat
                            i := i + 1;
                            TotalSetName[i, 1] := JobsSetup."NS_Burden AllocProjectDimValue";
                            TotalSetName[i, 2] := Code;
                            i := i + 1;
                            TotalSetName[i, 1] := JobsSetup."NS_Burden AllocServiceDimValue";
                            TotalSetName[i, 2] := Code;
                        until NEXT = 0;
                    CLEAR(TotalSetValue);
                end;
            end;
        }
        dataitem("Table"; "Integer")
        {

            trigger OnAfterGetRecord();
            begin
                if TotalSetValue[Table.Number] <> 0 then begin
                    with GenJnlLine do begin
                        INIT;
                        "Posting Date" := PostingDate;
                        "Document No." := DocumentNo;
                        Description := DocumentDescription;
                        "Account Type" := "Account Type"::"G/L Account";
                        "Account No." := JobsSetup."NS_Burden Alloc To - Debit";
                        "Bal. Account Type" := "Account Type"::"G/L Account";
                        "Bal. Account No." := JobsSetup."NS_Burden Alloc From - Credit";
                        VALIDATE(Amount, TotalSetValue[Table.Number]);
                        VALIDATE("Shortcut Dimension 1 Code", TotalSetName[Table.Number, 2]);
                        VALIDATE("Shortcut Dimension 2 Code", TotalSetName[Table.Number, 1]);
                        "System-Created Entry" := true;
                        "NS_Bal. Ledger No." := "Shortcut Dimension 2 Code";
                        GenJnlPostLine.RUN(GenJnlLine);
                    end;
                end;
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE(Number, 1, i + 2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field("Document No."; DocumentNo)
                {
                    Caption = 'Document No.';
                    NotBlank = true;
                    ApplicationArea = All;
                }
                field(Description; DocumentDescription)
                {
                    Caption = 'Description';
                    NotBlank = true;
                    ApplicationArea = All;
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
        PostingDate := WORKDATE;
        DocumentDescription := DefaultDescription;
    end;

    trigger OnPreReport();
    begin


        //CTSI-254.AS.1.0 - START
        JobsSetup.Get();
        if JobsSetup."NS_Advanced Burden Allocation" = true
        then
            Error('Please disable "Advanced Burden Allocation" setup on Jobs Setup, to use this batch.');
        //CTSI-254.AS.1.0 - END

        //CTSI-254.AM.1.0 - START
        if UserSetup.Get(UserId) then
            if NOT UserSetup."NS_Access to Job Burden Allocation Batch" then
                Error('You are not authorized to run this Batch.');
        //CTSI-254.AM.1.0 - END

        if PostingDate = 0D then
            ERROR(Text002);
        if DocumentNo = '' then
            ERROR(Text003);
        if DocumentDescription = '' then
            ERROR(Text004);
    end;

    var
        Text001: Label 'The Burden Alloc Dimension in Jobs Setup must be one of the Shortcut dimensions.\\The system is not setup for other dimensions.';
        Text002: Label 'A Posting Date must be entered.';
        Text003: Label 'A Document No. must be entered.';
        Text004: Label 'A Document Description must be entered.';
        Text005: Label 'Job %1 does not have a valid %2 of %3.';
        DefaultJournalTemplateName: Label 'GENERAL';
        GenJnlLine: Record "Gen. Journal Line";
        JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";//CTSI-254
        DimensionValue: Record "Dimension Value";
        Job: Record Job;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ProjectTotal: Decimal;
        ServiceTotal: Decimal;
        PostingDate: Date;
        DocumentNo: Code[20];
        BurdenAllocateSecondDimensionCode: Code[20];
        DocumentDescription: Text[50];
        DefaultDescription: Label 'Burden Allocation';
        Accumulated: Boolean;
        i: Integer;
        j: Integer;
        TotalSetName: array[100, 2] of Code[20];
        TotalSetValue: array[100] of Decimal;
}

