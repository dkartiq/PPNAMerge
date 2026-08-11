report 14021203 "NS_Date Compress Vendor Led."
{
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +     PP_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Purchases & Payables Setup record
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on NewDtldVendLedgEntry."Retention Ledger Code" if needed
    // +                                            add filter on Retention Ledger Code if needed
    // +     - InsertRegisters: add filter on NewDtldVendLedgEntry."Retention Ledger Code" if needed
    // +     - SummarizeEntry: add filter on DtldVendLedgEntry."Retention Ledger Code" if needed
    // +     - CompressDetails: add filter on DtldVendLedgEntry."Retention Ledger Code" if needed
    // +     - InsertDtldEntries: add filter on DtldVendLedgEntryBuffer."Retention Ledger Code" if needed
    // +------------------------------------------------------------

    ApplicationArea = Jobs;

    Caption = 'Date Compress Vendor Ledger';
    Permissions = TableData 17 = rimd,
                  TableData 25 = rimd,
                  TableData 45 = rimd,
                  TableData 87 = rimd,
                  TableData 355 = imd,
                  TableData 380 = rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Vendor No.", "Posting Date")
                                WHERE(Open = CONST(false));
            RequestFilterFields = "Vendor No.", "Vendor Posting Group", "Currency Code";

            trigger OnAfterGetRecord()
            begin
                VendLedgEntry2 := "Vendor Ledger Entry";
                WITH VendLedgEntry2 DO BEGIN
                    IF NOT CompressDetails("Vendor Ledger Entry") THEN
                        CurrReport.SKIP;
                    SETCURRENTKEY("Vendor No.", "Posting Date");
                    COPYFILTERS("Vendor Ledger Entry");
                    SETRANGE("Vendor No.", "Vendor No.");
                    SETFILTER("Posting Date", DateComprMgt.GetDateFilter("Posting Date", EntrdDateComprReg, TRUE));
                    SETRANGE("Vendor Posting Group", "Vendor Posting Group");
                    SETRANGE("Currency Code", "Currency Code");
                    SETRANGE("Document Type", "Document Type");

                    IF RetainNo(FIELDNO("Document No.")) THEN
                        SETRANGE("Document No.", "Document No.");
                    IF RetainNo(FIELDNO("Buy-from Vendor No.")) THEN
                        SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
                    IF RetainNo(FIELDNO("Purchaser Code")) THEN
                        SETRANGE("Purchaser Code", "Purchaser Code");
                    IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
                        SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                    IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
                        SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");

                    CALCFIELDS(Amount);
                    IF Amount >= 0 THEN
                        SummarizePositive := TRUE
                    ELSE
                        SummarizePositive := FALSE;

                    InitNewEntry(NewVendLedgEntry);

                    DimBufMgt.CollectDimEntryNo(
                      TempSelectedDim, "Dimension Set ID", "Entry No.",
                      0, FALSE, DimEntryNo);
                    ComprDimEntryNo := DimEntryNo;
                    SummarizeEntry(NewVendLedgEntry, VendLedgEntry2);
                    WHILE NEXT <> 0 DO BEGIN
                        CALCFIELDS(Amount);
                        IF ((Amount >= 0) AND SummarizePositive) OR
                           ((Amount < 0) AND (NOT SummarizePositive))
                        THEN
                            IF CompressDetails(VendLedgEntry2) THEN BEGIN
                                DimBufMgt.CollectDimEntryNo(
                                  TempSelectedDim, "Dimension Set ID", "Entry No.",
                                  ComprDimEntryNo, TRUE, DimEntryNo);
                                IF DimEntryNo = ComprDimEntryNo THEN
                                    SummarizeEntry(NewVendLedgEntry, VendLedgEntry2);
                            END;
                    END;

                    InsertNewEntry(NewVendLedgEntry, ComprDimEntryNo);

                    ComprCollectedEntries;
                END;

                IF DateComprReg."No. Records Deleted" >= NoOfDeleted + 10 THEN BEGIN
                    NoOfDeleted := DateComprReg."No. Records Deleted";
                    InsertRegisters(GLReg, DateComprReg);
                END;
            end;

            trigger OnPostDataItem()
            begin
                IF DateComprReg."No. Records Deleted" > NoOfDeleted THEN
                    InsertRegisters(GLReg, DateComprReg);
            end;

            trigger OnPreDataItem()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                IF NOT Confirm(Text000, TRUE) THEN
                    CurrReport.BREAK;

                IF EntrdDateComprReg."Ending Date" = 0D THEN
                    ERROR(Text003, EntrdDateComprReg.FIELDCAPTION("Ending Date"));

                Window.OPEN(
                  Text004 +
                  Text005 +
                  Text006 +
                  Text007 +
                  Text008);

                SourceCodeSetup.GET;
                SourceCodeSetup.TESTFIELD("Compress Vend. Ledger");

                SelectedDim.GetSelectedDim(
                  USERID, 3, REPORT::"Date Compress Vendor Ledger", '', TempSelectedDim);
                GLSetup.GET;
                Retain[4] :=
                  TempSelectedDim.GET(
                    USERID, 3, REPORT::"Date Compress Vendor Ledger", '', GLSetup."Global Dimension 1 Code");
                Retain[5] :=
                  TempSelectedDim.GET(
                    USERID, 3, REPORT::"Date Compress Vendor Ledger", '', GLSetup."Global Dimension 2 Code");

                GLentry.LOCKTABLE;
                NewDtldVendLedgEntry.LOCKTABLE;
                NewVendLedgEntry.LOCKTABLE;
                GLReg.LOCKTABLE;
                DateComprReg.LOCKTABLE;

                IF GLentry.FINDLAST THEN;
                LastEntryNo := GLentry."Entry No.";
                NextTransactionNo := GLentry."Transaction No." + 1;
                //ProjectPro - start
                NewDtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", "Vendor Ledger Entry"."NS_Retention Ledger Code");
                //ProjectPro - end
                IF NewDtldVendLedgEntry.FINDLAST THEN;
                LastDtldEntryNo := NewDtldVendLedgEntry."Entry No.";
                SETRANGE("Entry No.", 0, LastEntryNo);
                SETRANGE("Posting Date", EntrdDateComprReg."Starting Date", EntrdDateComprReg."Ending Date");
                //ProjectPro - start
                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                    SETRANGE("NS_Retention Ledger Code", "Vendor Ledger Entry"."NS_Retention Ledger Code");
                //ProjectPro - end

                InitRegisters;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field("NS_EntrdDateComprReg.Starting Date";
                    EntrdDateComprReg."Starting Date")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("NS_EntrdDateComprReg.Ending Date";
                    EntrdDateComprReg."Ending Date")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field("NS_EntrdDateComprReg.Period Length";
                    EntrdDateComprReg."Period Length")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Period Length';
                        OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field("NS_EntrdVendLedgEntry.Description";
                    EntrdVendLedgEntry.Description)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies a text that accompanies the entries that result from the compression. The default description is Date Compressed.';
                    }
                    group("NS_Retain Field Contents")
                    {
                        Caption = 'Retain Field Contents';
                        field("NS_Retain[1]"; Retain[1])
                        {
                            ApplicationArea = Suite;
                            Caption = 'Document No.';
                            ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                        }
                        field("NS_Retain[2]"; Retain[2])
                        {
                            ApplicationArea = Suite;
                            Caption = 'Buy-from Vendor No.';
                            ToolTip = 'Specifies a filter for the vendor or vendors that you want to compress entries for.';
                        }
                        field("NS_Retain[3]"; Retain[3])
                        {
                            ApplicationArea = Suite;
                            Caption = 'Purchaser Code';
                            ToolTip = 'Specifies the purchaser for whom vendor ledger entries are date compressed';
                        }
                    }
                    field(NS_RetainDimText; RetainDimText)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Retain Dimensions';
                        Editable = false;
                        ToolTip = 'Specifies which dimension information you want to retain when the entries are compressed. The more dimension information that you choose to retain, the more detailed the compressed entries are.';

                        trigger OnAssistEdit()
                        begin
                            DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Date Compress Vendor Ledger", RetainDimText);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitializeParameter;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DimSelectionBuf.CompareDimText(
          3, REPORT::"Date Compress Vendor Ledger", '', RetainDimText, Text010);
        VendLedgEntryFilter := COPYSTR("Vendor Ledger Entry".GETFILTERS, 1, MAXSTRLEN(DateComprReg.Filter));
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;

    var
        DimBufMgt: Codeunit 411;
        DimMgt: Codeunit 408;
        Text000: Label 'This batch job deletes entries. Therefore, it is important that you make a backup of the database before you run the batch job.\\Do you want to date compress the entries?';
        Text003: Label '%1 must be specified.';
        Text004: Label 'Date compressing vendor ledger entries...\\';
        Text005: Label 'Vendor No.           #1##########\';
        Text006: Label 'Date                 #2######\\';
        Text007: Label 'No. of new entries   #3######\';
        Text008: Label 'No. of entries del.  #4######';
        Text009: Label 'Date Compressed';
        Text010: Label 'Retain Dimensions';
        SourceCodeSetup: Record "Source Code Setup";
        DateComprReg: Record "Date Compr. Register";
        EntrdDateComprReg: Record "Date Compr. Register";
        GLReg: Record "G/L Register";
        EntrdVendLedgEntry: Record "Vendor Ledger Entry";
        NewVendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntryBuffer: Record "Detailed Vendor Ledg. Entry" temporary;
        GLentry: Record "G/L Entry";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        DateComprMgt: Codeunit DateComprMgt;

        Window: Dialog;
        VendLedgEntryFilter: Text[250];
        NoOfFields: Integer;
        Retain: array[10] of Boolean;
        FieldNumber: array[10] of Integer;
        FieldNameArray: array[10] of Text[100];
        LastEntryNo: Integer;
        NextTransactionNo: Integer;
        NoOfDeleted: Integer;
        LastDtldEntryNo: Integer;
        LastTmpDtldEntryNo: Integer;
        GLRegExists: Boolean;
        i: Integer;
        ComprDimEntryNo: Integer;
        DimEntryNo: Integer;
        RetainDimText: Text[250];
        SummarizePositive: Boolean;
        NS_PurchSetup: Record "Purchases & Payables Setup";

    local procedure InitRegisters()
    var
        NextRegNo: Integer;
    begin
        IF GLReg.FIND('+') THEN;
        GLReg.INIT;
        GLReg."No." := GLReg."No." + 1;
        GLReg."Creation Date" := TODAY;
        GLReg."Source Code" := SourceCodeSetup."Compress Vend. Ledger";
        GLReg."User ID" := USERID;
        GLReg."From Entry No." := LastEntryNo + 1;

        IF DateComprReg.FINDLAST THEN
            NextRegNo := DateComprReg."No." + 1;

        DateComprReg.InitRegister(
          DATABASE::"Vendor Ledger Entry", NextRegNo,
          EntrdDateComprReg."Starting Date", EntrdDateComprReg."Ending Date", EntrdDateComprReg."Period Length",
          VendLedgEntryFilter, GLReg."No.", SourceCodeSetup."Compress Vend. Ledger");

        FOR i := 1 TO NoOfFields DO
            IF Retain[i] THEN
                DateComprReg."Retain Field Contents" :=
                  COPYSTR(
                    DateComprReg."Retain Field Contents" + ',' + FieldNameArray[i], 1,
                    MAXSTRLEN(DateComprReg."Retain Field Contents"));
        DateComprReg."Retain Field Contents" := COPYSTR(DateComprReg."Retain Field Contents", 2);

        GLRegExists := FALSE;
        NoOfDeleted := 0;
    end;

    local procedure InsertRegisters(var GLReg: Record "G/L Register"; var DateComprReg: Record "Date Compr. Register")
    begin
        GLentry.INIT;
        LastEntryNo := LastEntryNo + 1;
        GLentry."Entry No." := LastEntryNo;
        GLentry."Posting Date" := TODAY;
        GLentry.Description := EntrdVendLedgEntry.Description;
        GLentry."Source Code" := SourceCodeSetup."Compress Vend. Ledger";
        GLentry."System-Created Entry" := TRUE;
        GLentry."User ID" := USERID;
        GLentry."Transaction No." := NextTransactionNo;
        GLentry.INSERT;
        GLentry.CONSISTENT(GLentry.Amount = 0);
        GLReg."To Entry No." := GLentry."Entry No.";

        IF GLRegExists THEN BEGIN
            GLReg.MODIFY;
            DateComprReg.MODIFY;
        END ELSE BEGIN
            GLReg.INSERT;
            DateComprReg.INSERT;
            GLRegExists := TRUE;
        END;
        COMMIT;

        GLentry.LOCKTABLE;
        NewDtldVendLedgEntry.LOCKTABLE;
        NewVendLedgEntry.LOCKTABLE;
        GLReg.LOCKTABLE;
        DateComprReg.LOCKTABLE;

        IF GLentry.FINDLAST THEN;
        IF NewVendLedgEntry.FIND('+') THEN;
        IF (LastEntryNo <> GLentry."Entry No.") OR
           (LastEntryNo <> NewVendLedgEntry."Entry No." + 1)
        THEN BEGIN
            LastEntryNo := GLentry."Entry No.";
            NextTransactionNo := GLentry."Transaction No." + 1;
            InitRegisters;
        END;
        //ProjectPro - start
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            NewDtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", "Vendor Ledger Entry"."NS_Retention Ledger Code");
        //ProjectPro - end

        IF NewDtldVendLedgEntry.FINDLAST THEN;
        LastDtldEntryNo := NewDtldVendLedgEntry."Entry No.";
    end;

    local procedure InsertField(Number: Integer; Name: Text[100])
    begin
        NoOfFields := NoOfFields + 1;
        FieldNumber[NoOfFields] := Number;
        FieldNameArray[NoOfFields] := Name;
    end;

    local procedure RetainNo(Number: Integer): Boolean
    begin
        EXIT(Retain[Index(Number)]);
    end;

    local procedure Index(Number: Integer): Integer
    begin
        FOR i := 1 TO NoOfFields DO
            IF Number = FieldNumber[i] THEN
                EXIT(i);
    end;

    local procedure SummarizeEntry(var NewVendLedgEntry: Record "Vendor Ledger Entry"; VendLedgEntry: Record "Vendor Ledger Entry")
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        WITH VendLedgEntry DO BEGIN
            NewVendLedgEntry."Purchase (LCY)" := NewVendLedgEntry."Purchase (LCY)" + "Purchase (LCY)";
            NewVendLedgEntry."Inv. Discount (LCY)" := NewVendLedgEntry."Inv. Discount (LCY)" + "Inv. Discount (LCY)";
            NewVendLedgEntry."Original Pmt. Disc. Possible" :=
              NewVendLedgEntry."Original Pmt. Disc. Possible" + "Original Pmt. Disc. Possible";
            NewVendLedgEntry."Remaining Pmt. Disc. Possible" :=
              NewVendLedgEntry."Remaining Pmt. Disc. Possible" + "Remaining Pmt. Disc. Possible";
            NewVendLedgEntry."Closed by Amount (LCY)" :=
              NewVendLedgEntry."Closed by Amount (LCY)" + "Closed by Amount (LCY)";

            DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
            DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", "Entry No.");
            //ProjectPro - start
            IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                DtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", "NS_Retention Ledger Code");
            //ProjectPro - end
            IF DtldVendLedgEntry.FIND('-') THEN BEGIN
                REPEAT
                    SummarizeDtldEntry(DtldVendLedgEntry, NewVendLedgEntry);
                UNTIL DtldVendLedgEntry.NEXT = 0;
                DtldVendLedgEntry.DELETEALL;
            END;

            DELETE;
            DateComprReg."No. Records Deleted" := DateComprReg."No. Records Deleted" + 1;
            Window.UPDATE(4, DateComprReg."No. Records Deleted");
        END;
    end;

    local procedure ComprCollectedEntries()
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        OldDimEntryNo: Integer;
        Found: Boolean;
        VendLedgEntryNo: Integer;
    begin
        OldDimEntryNo := 0;
        IF DimBufMgt.FindFirstDimEntryNo(DimEntryNo, VendLedgEntryNo) THEN BEGIN
            InitNewEntry(NewVendLedgEntry);
            REPEAT
                VendLedgEntry.GET(VendLedgEntryNo);
                SummarizeEntry(NewVendLedgEntry, VendLedgEntry);
                OldDimEntryNo := DimEntryNo;
                Found := DimBufMgt.NextDimEntryNo(DimEntryNo, VendLedgEntryNo);
                IF (OldDimEntryNo <> DimEntryNo) OR NOT Found THEN BEGIN
                    InsertNewEntry(NewVendLedgEntry, OldDimEntryNo);
                    IF Found THEN
                        InitNewEntry(NewVendLedgEntry);
                END;
                OldDimEntryNo := DimEntryNo;
            UNTIL NOT Found;
        END;
        DimBufMgt.DeleteAllDimEntryNo;
    end;

    [Scope('Cloud')]
    procedure InitNewEntry(var NewVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        LastEntryNo := LastEntryNo + 1;

        WITH VendLedgEntry2 DO BEGIN
            NewVendLedgEntry.INIT;
            NewVendLedgEntry."Entry No." := LastEntryNo;
            NewVendLedgEntry."Vendor No." := "Vendor No.";
            NewVendLedgEntry."Posting Date" := GETRANGEMIN("Posting Date");
            NewVendLedgEntry.Description := EntrdVendLedgEntry.Description;
            NewVendLedgEntry."Vendor Posting Group" := "Vendor Posting Group";
            NewVendLedgEntry."Currency Code" := "Currency Code";
            NewVendLedgEntry."Document Type" := "Document Type";
            NewVendLedgEntry."Source Code" := SourceCodeSetup."Compress Vend. Ledger";
            NewVendLedgEntry."User ID" := USERID;
            NewVendLedgEntry."Transaction No." := NextTransactionNo;

            IF RetainNo(FIELDNO("Document No.")) THEN
                NewVendLedgEntry."Document No." := "Document No.";
            IF RetainNo(FIELDNO("Buy-from Vendor No.")) THEN
                NewVendLedgEntry."Buy-from Vendor No." := "Buy-from Vendor No.";
            IF RetainNo(FIELDNO("Purchaser Code")) THEN
                NewVendLedgEntry."Purchaser Code" := "Purchaser Code";
            IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
                NewVendLedgEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
            IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
                NewVendLedgEntry."Global Dimension 2 Code" := "Global Dimension 2 Code";

            Window.UPDATE(1, NewVendLedgEntry."Vendor No.");
            Window.UPDATE(2, NewVendLedgEntry."Posting Date");
            DateComprReg."No. of New Records" := DateComprReg."No. of New Records" + 1;
            Window.UPDATE(3, DateComprReg."No. of New Records");
        END;
    end;

    local procedure InsertNewEntry(var NewVendLedgEntry: Record "Vendor Ledger Entry"; DimEntryNo: Integer)
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempDimBuf.DELETEALL;
        DimBufMgt.GetDimensions(DimEntryNo, TempDimBuf);
        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
        NewVendLedgEntry."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        NewVendLedgEntry.INSERT;
        InsertDtldEntries;
    end;

    local procedure CompressDetails(VendLedgEntry: Record "Vendor Ledger Entry"): Boolean
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Posting Date");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        //ProjectPro - start
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            DtldVendLedgEntry.SETRANGE("NS_Retention Ledger Code", VendLedgEntry."NS_Retention Ledger Code");
        //ProjectPro - end
        IF EntrdDateComprReg."Starting Date" <> 0D THEN
            DtldVendLedgEntry.SETFILTER(
              "Posting Date",
              STRSUBSTNO(
                '..%1|%2..',
                CALCDATE('<-1D>', EntrdDateComprReg."Starting Date"),
                CALCDATE('<+1D>', EntrdDateComprReg."Ending Date")))
        ELSE
            DtldVendLedgEntry.SETFILTER(
              "Posting Date",
              STRSUBSTNO(
                '%1..',
                CALCDATE('<+1D>', EntrdDateComprReg."Ending Date")));

        EXIT(NOT DtldVendLedgEntry.FINDLAST);
    end;

    local procedure SummarizeDtldEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; var NewVendLedgEntry: Record "Vendor Ledger Entry")
    var
        NewEntry: Boolean;
        PostingDate: Date;
    begin
        DtldVendLedgEntryBuffer.SETFILTER(
          "Posting Date",
          DateComprMgt.GetDateFilter(DtldVendLedgEntry."Posting Date", EntrdDateComprReg, TRUE));
        PostingDate := DtldVendLedgEntryBuffer.GETRANGEMIN("Posting Date");
        DtldVendLedgEntryBuffer.SETRANGE("Posting Date", PostingDate);
        DtldVendLedgEntryBuffer.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type");
        IF RetainNo("Vendor Ledger Entry".FIELDNO("Document No.")) THEN
            DtldVendLedgEntryBuffer.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
        IF RetainNo("Vendor Ledger Entry".FIELDNO("Buy-from Vendor No.")) THEN
            DtldVendLedgEntryBuffer.SETRANGE("Vendor No.", "Vendor Ledger Entry"."Buy-from Vendor No.");
        IF RetainNo("Vendor Ledger Entry".FIELDNO("Global Dimension 1 Code")) THEN
            DtldVendLedgEntryBuffer.SETRANGE("Initial Entry Global Dim. 1", "Vendor Ledger Entry"."Global Dimension 1 Code");
        IF RetainNo("Vendor Ledger Entry".FIELDNO("Global Dimension 2 Code")) THEN
            DtldVendLedgEntryBuffer.SETRANGE("Initial Entry Global Dim. 2", "Vendor Ledger Entry"."Global Dimension 2 Code");

        IF NOT DtldVendLedgEntryBuffer.FIND('-') THEN BEGIN
            DtldVendLedgEntryBuffer.RESET;
            CLEAR(DtldVendLedgEntryBuffer);

            LastTmpDtldEntryNo := LastTmpDtldEntryNo + 1;
            DtldVendLedgEntryBuffer."Entry No." := LastTmpDtldEntryNo;
            DtldVendLedgEntryBuffer."Posting Date" := PostingDate;
            DtldVendLedgEntryBuffer."Document Type" := NewVendLedgEntry."Document Type";
            DtldVendLedgEntryBuffer."Initial Document Type" := NewVendLedgEntry."Document Type";
            DtldVendLedgEntryBuffer."Document No." := NewVendLedgEntry."Document No.";
            DtldVendLedgEntryBuffer."Entry Type" := DtldVendLedgEntry."Entry Type";
            DtldVendLedgEntryBuffer."Vendor Ledger Entry No." := NewVendLedgEntry."Entry No.";
            DtldVendLedgEntryBuffer."Vendor No." := NewVendLedgEntry."Vendor No.";
            DtldVendLedgEntryBuffer."Currency Code" := NewVendLedgEntry."Currency Code";
            DtldVendLedgEntryBuffer."User ID" := NewVendLedgEntry."User ID";
            DtldVendLedgEntryBuffer."Source Code" := NewVendLedgEntry."Source Code";
            DtldVendLedgEntryBuffer."Transaction No." := NewVendLedgEntry."Transaction No.";
            DtldVendLedgEntryBuffer."Journal Batch Name" := NewVendLedgEntry."Journal Batch Name";
            DtldVendLedgEntryBuffer."Reason Code" := NewVendLedgEntry."Reason Code";
            DtldVendLedgEntryBuffer."Initial Entry Due Date" := NewVendLedgEntry."Due Date";
            DtldVendLedgEntryBuffer."Initial Entry Global Dim. 1" := NewVendLedgEntry."Global Dimension 1 Code";
            DtldVendLedgEntryBuffer."Initial Entry Global Dim. 2" := NewVendLedgEntry."Global Dimension 2 Code";
            //ProjectPro - start
            DtldVendLedgEntryBuffer."NS_Retention Ledger Code" := NewVendLedgEntry."NS_Retention Ledger Code";
            //ProjectPro - end
            NewEntry := TRUE;
        END;

        DtldVendLedgEntryBuffer.Amount :=
          DtldVendLedgEntryBuffer.Amount + DtldVendLedgEntry.Amount;
        DtldVendLedgEntryBuffer."Amount (LCY)" :=
          DtldVendLedgEntryBuffer."Amount (LCY)" + DtldVendLedgEntry."Amount (LCY)";
        DtldVendLedgEntryBuffer."Debit Amount" :=
          DtldVendLedgEntryBuffer."Debit Amount" + DtldVendLedgEntry."Debit Amount";
        DtldVendLedgEntryBuffer."Credit Amount" :=
          DtldVendLedgEntryBuffer."Credit Amount" + DtldVendLedgEntry."Credit Amount";
        DtldVendLedgEntryBuffer."Debit Amount (LCY)" :=
          DtldVendLedgEntryBuffer."Debit Amount (LCY)" + DtldVendLedgEntry."Debit Amount (LCY)";
        DtldVendLedgEntryBuffer."Credit Amount (LCY)" :=
          DtldVendLedgEntryBuffer."Credit Amount (LCY)" + DtldVendLedgEntry."Credit Amount (LCY)";

        IF NewEntry THEN
            DtldVendLedgEntryBuffer.INSERT
        ELSE
            DtldVendLedgEntryBuffer.MODIFY;
    end;

    local procedure InsertDtldEntries()
    begin
        DtldVendLedgEntryBuffer.RESET;
        //ProjectPro - start
        IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
            DtldVendLedgEntryBuffer.SETRANGE("NS_Retention Ledger Code", "Vendor Ledger Entry"."NS_Retention Ledger Code");
        //ProjectPro - end
        IF DtldVendLedgEntryBuffer.FIND('-') THEN
            REPEAT
                IF ((DtldVendLedgEntryBuffer.Amount <> 0) OR
                    (DtldVendLedgEntryBuffer."Amount (LCY)" <> 0) OR
                    (DtldVendLedgEntryBuffer."Debit Amount" <> 0) OR
                    (DtldVendLedgEntryBuffer."Credit Amount" <> 0) OR
                    (DtldVendLedgEntryBuffer."Debit Amount (LCY)" <> 0) OR
                    (DtldVendLedgEntryBuffer."Credit Amount (LCY)" <> 0))
                THEN BEGIN
                    LastDtldEntryNo := LastDtldEntryNo + 1;

                    NewDtldVendLedgEntry := DtldVendLedgEntryBuffer;
                    NewDtldVendLedgEntry."Entry No." := LastDtldEntryNo;
                    NewDtldVendLedgEntry.INSERT(TRUE);
                END;
            UNTIL DtldVendLedgEntryBuffer.NEXT = 0;
        DtldVendLedgEntryBuffer.DELETEALL;
    end;

    local procedure InitializeParameter()
    begin
        IF EntrdDateComprReg."Ending Date" = 0D THEN
            EntrdDateComprReg."Ending Date" := TODAY;
        IF EntrdVendLedgEntry.Description = '' THEN
            EntrdVendLedgEntry.Description := Text009;

        WITH "Vendor Ledger Entry" DO BEGIN
            InsertField(FIELDNO("Document No."), FIELDCAPTION("Document No."));
            InsertField(FIELDNO("Buy-from Vendor No."), FIELDCAPTION("Buy-from Vendor No."));
            InsertField(FIELDNO("Purchaser Code"), FIELDCAPTION("Purchaser Code"));
            InsertField(FIELDNO("Global Dimension 1 Code"), FIELDCAPTION("Global Dimension 1 Code"));
            InsertField(FIELDNO("Global Dimension 2 Code"), FIELDCAPTION("Global Dimension 2 Code"));
        END;

        RetainDimText := DimSelectionBuf.GetDimSelectionText(3, REPORT::"Date Compress Vendor Ledger", '');
    end;

    [Scope('Cloud')]
    procedure InitializeRequest(StartingDate: Date; EndingDate: Date; PeriodLength: Option; Description: Text[50]; RetainDocumentNo: Boolean; RetainBuyfromVendorNo: Boolean; RetainPurchaserCode: Boolean; RetainDimensionText: Text[250])
    begin
        InitializeParameter;
        EntrdDateComprReg."Starting Date" := StartingDate;
        EntrdDateComprReg."Ending Date" := EndingDate;
        EntrdDateComprReg."Period Length" := PeriodLength;
        EntrdVendLedgEntry.Description := Description;
        Retain[1] := RetainDocumentNo;
        Retain[2] := RetainBuyfromVendorNo;
        Retain[3] := RetainPurchaserCode;
        RetainDimText := RetainDimensionText;
    end;
}

