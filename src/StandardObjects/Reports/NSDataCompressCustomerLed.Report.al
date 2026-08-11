report 14021201 "NS_Date Compress Customer Led."
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
    // +     NS_SalesSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: get Sales & Receivables Setup record
    // +     - Cust. Ledger Entry - OnPreDataItem: add filter on NewDtldCustLedgEntry."Retention Ledger Code" if needed
    // +                                           add filter on Retention Ledger Code if needed
    // +     - InsertRegisters: add filter on NewDtldCustLedgEntry."Retention Ledger Code" if needed
    // +     - SummarizeEntry: add filter on DtldCustLedgEntry."Retention Ledger Code" if needed
    // +     - CompressDetails: add filter on DtldCustLedgEntry."Retention Ledger Code" if needed
    // +     - InsertDtldEntries: add filter on DtldCustLedgEntryBuffer."Retention Ledger Code" if needed
    // +------------------------------------------------------------

    Caption = 'Date Compress Customer Ledger';
    Permissions = TableData 17 = rimd,
                  TableData 21 = rimd,
                  TableData 45 = rimd,
                  TableData 87 = rimd,
                  TableData 300 = rimd,
                  TableData 355 = imd,
                  TableData 379 = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.", "Posting Date")
                                WHERE(Open = CONST(false));

            RequestFilterFields = "Customer No.", "Customer Posting Group", "Currency Code";

            trigger OnAfterGetRecord()
            begin
                IF NOT CompressDetails("Cust. Ledger Entry") THEN
                    CurrReport.SKIP;
                ReminderEntry.SETCURRENTKEY("Customer Entry No.");
                CustLedgEntry2 := "Cust. Ledger Entry";
                WITH CustLedgEntry2 DO BEGIN
                    SETCURRENTKEY("Customer No.", "Posting Date");
                    COPYFILTERS("Cust. Ledger Entry");
                    SETRANGE("Customer No.", "Customer No.");
                    SETFILTER("Posting Date", DateComprMgt.GetDateFilter("Posting Date", EntrdDateComprReg, TRUE));
                    SETRANGE("Customer Posting Group", "Customer Posting Group");
                    SETRANGE("Currency Code", "Currency Code");
                    SETRANGE("Document Type", "Document Type");

                    IF RetainNo(FIELDNO("Document No.")) THEN
                        SETRANGE("Document No.", "Document No.");
                    IF RetainNo(FIELDNO("Sell-to Customer No.")) THEN
                        SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
                    IF RetainNo(FIELDNO("Salesperson Code")) THEN
                        SETRANGE("Salesperson Code", "Salesperson Code");
                    IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
                        SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
                    IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
                        SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
                    CALCFIELDS(Amount);
                    IF Amount >= 0 THEN
                        SummarizePositive := TRUE
                    ELSE
                        SummarizePositive := FALSE;

                    InitNewEntry(NewCustLedgEntry);

                    DimBufMgt.CollectDimEntryNo(
                      TempSelectedDim, "Dimension Set ID", "Entry No.",
                      0, FALSE, DimEntryNo);
                    ComprDimEntryNo := DimEntryNo;
                    SummarizeEntry(NewCustLedgEntry, CustLedgEntry2);

                    WHILE NEXT <> 0 DO BEGIN
                        CALCFIELDS(Amount);
                        IF ((Amount >= 0) AND SummarizePositive) OR
                           ((Amount < 0) AND (NOT SummarizePositive))
                        THEN
                            IF CompressDetails(CustLedgEntry2) THEN BEGIN
                                DimBufMgt.CollectDimEntryNo(
                                  TempSelectedDim, "Dimension Set ID", "Entry No.",
                                  ComprDimEntryNo, TRUE, DimEntryNo);
                                IF DimEntryNo = ComprDimEntryNo THEN
                                    SummarizeEntry(NewCustLedgEntry, CustLedgEntry2);
                            END;
                    END;

                    InsertNewEntry(NewCustLedgEntry, ComprDimEntryNo);

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
                SourceCodeSetup.TESTFIELD("Compress Cust. Ledger");

                SelectedDim.GetSelectedDim(
                  USERID, 3, REPORT::"Date Compress Customer Ledger", '', TempSelectedDim);
                GLSetup.GET;
                Retain[4] :=
                  TempSelectedDim.GET(
                    USERID, 3, REPORT::"Date Compress Customer Ledger", '', GLSetup."Global Dimension 1 Code");
                Retain[5] :=
                  TempSelectedDim.GET(
                    USERID, 3, REPORT::"Date Compress Customer Ledger", '', GLSetup."Global Dimension 2 Code");

                GLEntry.LOCKTABLE;
                ReminderEntry.LOCKTABLE;
                NewDtldCustLedgEntry.LOCKTABLE;
                NewCustLedgEntry.LOCKTABLE;
                GLReg.LOCKTABLE;
                DateComprReg.LOCKTABLE;

                IF GLEntry.FINDLAST THEN;
                LastEntryNo := GLEntry."Entry No.";
                NextTransactionNo := GLEntry."Transaction No." + 1;
                //ProjectPro - start
                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                    NewDtldCustLedgEntry.SETRANGE("NS_Retention Ledger Code", "Cust. Ledger Entry"."NS_Retention Ledger Code");
                //ProjectPro - end
                IF NewDtldCustLedgEntry.FINDLAST THEN;
                LastDtldEntryNo := NewDtldCustLedgEntry."Entry No.";
                //ProjectPro - start
                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                    SETRANGE("NS_Retention Ledger Code", "Cust. Ledger Entry"."NS_Retention Ledger Code");
                //ProjectPro - end
                SETRANGE("Entry No.", 0, LastEntryNo);
                SETRANGE("Posting Date", EntrdDateComprReg."Starting Date", EntrdDateComprReg."Ending Date");

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
                    field("NS_EntrdDateComprReg.Starting Date"; EntrdDateComprReg."Starting Date")
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
                    field("NS_EntrdCustLedgEntry.Description";
                    EntrdCustLedgEntry.Description)
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
                            Caption = 'Sell-to Customer No.';
                            ToolTip = 'Specifies the customer for whom ledger entries are date compressed.';
                        }
                        field("NS_Retain[3]"; Retain[3])
                        {
                            ApplicationArea = Suite;
                            Caption = 'Salesperson Code';
                            ToolTip = 'Specifies the salesperson for whom customer ledger entries are date compressed';
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
                            DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Date Compress Customer Ledger", RetainDimText);
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
          3, REPORT::"Date Compress Customer Ledger", '', RetainDimText, Text010);
        CustLedgEntryFilter := COPYSTR("Cust. Ledger Entry".GETFILTERS, 1, MAXSTRLEN(DateComprReg.Filter));
        //ProjectPro - start
        NS_SalesSetup.GET;
        //ProjectPro - end
    end;

    var

        SourceCodeSetup: Record "Source Code Setup";
        DateComprReg: Record "Date Compr. Register";
        EntrdDateComprReg: Record "Date Compr. Register";
        GLReg: Record "G/L Register";
        EntrdCustLedgEntry: Record "Cust. Ledger Entry";
        NewCustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntryBuffer: Record "Detailed Cust. Ledg. Entry" temporary;
        GLEntry: Record "G/L Entry";
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        NS_SalesSetup: Record 311;

        DateComprMgt: Codeunit DateComprMgt;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit 408;
        Window: Dialog;
        CustLedgEntryFilter: Text[250];
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
        Text000: Label 'This batch job deletes entries. Therefore, it is important that you make a backup of the database before you run the batch job.\\Do you want to date compress the entries?';
        Text003: Label '%1 must be specified.';
        Text004: Label 'Date compressing customer ledger entries...\\';
        Text005: Label 'Customer No.         #1##########\';
        Text006: Label 'Date                 #2######\\';
        Text007: Label 'No. of new entries   #3######\';
        Text008: Label 'No. of entries del.  #4######';
        Text009: Label 'Date Compressed';
        Text010: Label 'Retain Dimensions';

    local procedure InitRegisters()
    var
        NextRegNo: Integer;
    begin
        IF GLReg.FIND('+') THEN;
        GLReg.INIT;
        GLReg."No." := GLReg."No." + 1;
        GLReg."Creation Date" := TODAY;
        GLReg."Source Code" := SourceCodeSetup."Compress Cust. Ledger";
        GLReg."User ID" := USERID;
        GLReg."From Entry No." := LastEntryNo + 1;

        IF DateComprReg.FINDLAST THEN
            NextRegNo := DateComprReg."No." + 1;

        DateComprReg.InitRegister(
          DATABASE::"Cust. Ledger Entry", NextRegNo,
          EntrdDateComprReg."Starting Date", EntrdDateComprReg."Ending Date", EntrdDateComprReg."Period Length",
          CustLedgEntryFilter, GLReg."No.", SourceCodeSetup."Compress Cust. Ledger");
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
        GLEntry.INIT;
        LastEntryNo := LastEntryNo + 1;
        GLEntry."Entry No." := LastEntryNo;
        GLEntry."Posting Date" := TODAY;
        GLEntry.Description := EntrdCustLedgEntry.Description;
        GLEntry."Source Code" := SourceCodeSetup."Compress Cust. Ledger";
        GLEntry."System-Created Entry" := TRUE;
        GLEntry."User ID" := USERID;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry.INSERT;
        GLEntry.CONSISTENT(GLEntry.Amount = 0);
        GLReg."To Entry No." := GLEntry."Entry No.";

        IF GLRegExists THEN BEGIN
            GLReg.MODIFY;
            DateComprReg.MODIFY;
        END ELSE BEGIN
            GLReg.INSERT;
            DateComprReg.INSERT;
            GLRegExists := TRUE;
        END;
        COMMIT;

        GLEntry.LOCKTABLE;
        ReminderEntry.LOCKTABLE;
        NewDtldCustLedgEntry.LOCKTABLE;
        NewCustLedgEntry.LOCKTABLE;
        GLReg.LOCKTABLE;
        DateComprReg.LOCKTABLE;

        IF GLEntry.FINDLAST THEN;
        IF NewCustLedgEntry.FIND('+') THEN;
        IF (LastEntryNo <> GLEntry."Entry No.") OR
           (LastEntryNo <> NewCustLedgEntry."Entry No." + 1)
        THEN BEGIN
            LastEntryNo := GLEntry."Entry No.";
            NextTransactionNo := GLEntry."Transaction No." + 1;
            InitRegisters;
        END;
        //ProjectPro - start
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            NewDtldCustLedgEntry.SETRANGE("NS_Retention Ledger Code", "Cust. Ledger Entry"."NS_Retention Ledger Code");
        //ProjectPro - end
        IF NewDtldCustLedgEntry.FINDLAST THEN;
        LastDtldEntryNo := NewDtldCustLedgEntry."Entry No.";
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

    local procedure SummarizeEntry(var NewCustLedgEntry: Record "Cust. Ledger Entry"; CustLedgEntry: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        WITH CustLedgEntry DO BEGIN
            NewCustLedgEntry."Sales (LCY)" := NewCustLedgEntry."Sales (LCY)" + "Sales (LCY)";
            NewCustLedgEntry."Profit (LCY)" := NewCustLedgEntry."Profit (LCY)" + "Profit (LCY)";
            NewCustLedgEntry."Inv. Discount (LCY)" := NewCustLedgEntry."Inv. Discount (LCY)" + "Inv. Discount (LCY)";
            NewCustLedgEntry."Original Pmt. Disc. Possible" :=
              NewCustLedgEntry."Original Pmt. Disc. Possible" + "Original Pmt. Disc. Possible";
            NewCustLedgEntry."Remaining Pmt. Disc. Possible" :=
              NewCustLedgEntry."Remaining Pmt. Disc. Possible" + "Remaining Pmt. Disc. Possible";
            NewCustLedgEntry."Closed by Amount (LCY)" :=
              NewCustLedgEntry."Closed by Amount (LCY)" + "Closed by Amount (LCY)";

            DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
            //ProjectPro - start
            IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                DtldCustLedgEntry.SETRANGE("NS_Retention Ledger Code", "NS_Retention Ledger Code");
            //ProjectPro - end
            DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", "Entry No.");
            IF DtldCustLedgEntry.FIND('-') THEN BEGIN
                REPEAT
                    SummarizeDtldEntry(DtldCustLedgEntry, NewCustLedgEntry);
                UNTIL DtldCustLedgEntry.NEXT = 0;
                DtldCustLedgEntry.DELETEALL;
            END;

            ReminderEntry.SETRANGE("Customer Entry No.", "Entry No.");
            ReminderEntry.DELETEALL;
            DELETE;
            DateComprReg."No. Records Deleted" := DateComprReg."No. Records Deleted" + 1;
            Window.UPDATE(4, DateComprReg."No. Records Deleted");
        END;
    end;

    local procedure ComprCollectedEntries()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        OldDimEntryNo: Integer;
        Found: Boolean;
        CustLedgEntryNo: Integer;
    begin
        OldDimEntryNo := 0;
        IF DimBufMgt.FindFirstDimEntryNo(DimEntryNo, CustLedgEntryNo) THEN BEGIN
            InitNewEntry(NewCustLedgEntry);
            REPEAT
                CustLedgEntry.GET(CustLedgEntryNo);
                SummarizeEntry(NewCustLedgEntry, CustLedgEntry);
                OldDimEntryNo := DimEntryNo;
                Found := DimBufMgt.NextDimEntryNo(DimEntryNo, CustLedgEntryNo);
                IF (OldDimEntryNo <> DimEntryNo) OR NOT Found THEN BEGIN
                    InsertNewEntry(NewCustLedgEntry, OldDimEntryNo);
                    IF Found THEN
                        InitNewEntry(NewCustLedgEntry);
                END;
                OldDimEntryNo := DimEntryNo;
            UNTIL NOT Found;
        END;
        DimBufMgt.DeleteAllDimEntryNo;
    end;

    [Scope('Cloud')]
    procedure InitNewEntry(var NewCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        LastEntryNo := LastEntryNo + 1;

        WITH CustLedgEntry2 DO BEGIN
            NewCustLedgEntry.INIT;
            NewCustLedgEntry."Entry No." := LastEntryNo;
            NewCustLedgEntry."Customer No." := "Customer No.";
            NewCustLedgEntry."Posting Date" := GETRANGEMIN("Posting Date");
            NewCustLedgEntry.Description := EntrdCustLedgEntry.Description;
            NewCustLedgEntry."Customer Posting Group" := "Customer Posting Group";
            NewCustLedgEntry."Currency Code" := "Currency Code";
            NewCustLedgEntry."Document Type" := "Document Type";
            NewCustLedgEntry."Source Code" := SourceCodeSetup."Compress Cust. Ledger";
            NewCustLedgEntry."User ID" := USERID;
            NewCustLedgEntry."Transaction No." := NextTransactionNo;

            IF RetainNo(FIELDNO("Document No.")) THEN
                NewCustLedgEntry."Document No." := "Document No.";
            IF RetainNo(FIELDNO("Sell-to Customer No.")) THEN
                NewCustLedgEntry."Sell-to Customer No." := "Sell-to Customer No.";
            IF RetainNo(FIELDNO("Salesperson Code")) THEN
                NewCustLedgEntry."Salesperson Code" := "Salesperson Code";
            IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
                NewCustLedgEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
            IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
                NewCustLedgEntry."Global Dimension 2 Code" := "Global Dimension 2 Code";

            Window.UPDATE(1, NewCustLedgEntry."Customer No.");
            Window.UPDATE(2, NewCustLedgEntry."Posting Date");
            DateComprReg."No. of New Records" := DateComprReg."No. of New Records" + 1;
            Window.UPDATE(3, DateComprReg."No. of New Records");
        END;
    end;

    local procedure InsertNewEntry(var NewCustLedgEntry: Record "Cust. Ledger Entry"; DimEntryNo: Integer)
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempDimBuf.DELETEALL;
        DimBufMgt.GetDimensions(DimEntryNo, TempDimBuf);
        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
        NewCustLedgEntry."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        NewCustLedgEntry.INSERT;
        InsertDtldEntries;
    end;

    local procedure CompressDetails(CustLedgEntry: Record "Cust. Ledger Entry"): Boolean
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        //ProjectPro - start
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            DtldCustLedgEntry.SETRANGE("NS_Retention Ledger Code", CustLedgEntry."NS_Retention Ledger Code");
        //ProjectPro - end
        IF EntrdDateComprReg."Starting Date" <> 0D THEN BEGIN
            DtldCustLedgEntry.SETFILTER(
              "Posting Date",
              STRSUBSTNO(
                '..%1|%2..',
                CALCDATE('<-1D>', EntrdDateComprReg."Starting Date"),
                CALCDATE('<+1D>', EntrdDateComprReg."Ending Date")));
        END ELSE
            DtldCustLedgEntry.SETFILTER(
              "Posting Date",
              STRSUBSTNO(
                '%1..',
                CALCDATE('<+1D>', EntrdDateComprReg."Ending Date")));

        EXIT(NOT DtldCustLedgEntry.FINDLAST);
    end;

    local procedure SummarizeDtldEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var NewCustLedgEntry: Record "Cust. Ledger Entry")
    var
        NewEntry: Boolean;
        PostingDate: Date;
    begin
        DtldCustLedgEntryBuffer.SETFILTER(
          "Posting Date",
          DateComprMgt.GetDateFilter(DtldCustLedgEntry."Posting Date", EntrdDateComprReg, TRUE));
        PostingDate := DtldCustLedgEntryBuffer.GETRANGEMIN("Posting Date");
        DtldCustLedgEntryBuffer.SETRANGE("Posting Date", PostingDate);
        DtldCustLedgEntryBuffer.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type");
        IF RetainNo("Cust. Ledger Entry".FIELDNO("Document No.")) THEN
            DtldCustLedgEntryBuffer.SETRANGE("Document No.", "Cust. Ledger Entry"."Document No.");
        IF RetainNo("Cust. Ledger Entry".FIELDNO("Sell-to Customer No.")) THEN
            DtldCustLedgEntryBuffer.SETRANGE("Customer No.", "Cust. Ledger Entry"."Sell-to Customer No.");
        IF RetainNo("Cust. Ledger Entry".FIELDNO("Global Dimension 1 Code")) THEN
            DtldCustLedgEntryBuffer.SETRANGE("Initial Entry Global Dim. 1", "Cust. Ledger Entry"."Global Dimension 1 Code");
        IF RetainNo("Cust. Ledger Entry".FIELDNO("Global Dimension 2 Code")) THEN
            DtldCustLedgEntryBuffer.SETRANGE("Initial Entry Global Dim. 2", "Cust. Ledger Entry"."Global Dimension 2 Code");

        IF NOT DtldCustLedgEntryBuffer.FIND('-') THEN BEGIN
            DtldCustLedgEntryBuffer.RESET;
            CLEAR(DtldCustLedgEntryBuffer);

            LastTmpDtldEntryNo := LastTmpDtldEntryNo + 1;
            DtldCustLedgEntryBuffer."Entry No." := LastTmpDtldEntryNo;
            DtldCustLedgEntryBuffer."Posting Date" := PostingDate;
            DtldCustLedgEntryBuffer."Document Type" := NewCustLedgEntry."Document Type";
            DtldCustLedgEntryBuffer."Initial Document Type" := NewCustLedgEntry."Document Type";
            DtldCustLedgEntryBuffer."Document No." := NewCustLedgEntry."Document No.";
            DtldCustLedgEntryBuffer."Entry Type" := DtldCustLedgEntry."Entry Type";
            DtldCustLedgEntryBuffer."Cust. Ledger Entry No." := NewCustLedgEntry."Entry No.";
            DtldCustLedgEntryBuffer."Customer No." := NewCustLedgEntry."Customer No.";
            DtldCustLedgEntryBuffer."Currency Code" := NewCustLedgEntry."Currency Code";
            DtldCustLedgEntryBuffer."User ID" := NewCustLedgEntry."User ID";
            DtldCustLedgEntryBuffer."Source Code" := NewCustLedgEntry."Source Code";
            DtldCustLedgEntryBuffer."Transaction No." := NewCustLedgEntry."Transaction No.";
            DtldCustLedgEntryBuffer."Journal Batch Name" := NewCustLedgEntry."Journal Batch Name";
            DtldCustLedgEntryBuffer."Reason Code" := NewCustLedgEntry."Reason Code";
            DtldCustLedgEntryBuffer."Initial Entry Due Date" := NewCustLedgEntry."Due Date";
            DtldCustLedgEntryBuffer."Initial Entry Global Dim. 1" := NewCustLedgEntry."Global Dimension 1 Code";
            DtldCustLedgEntryBuffer."Initial Entry Global Dim. 2" := NewCustLedgEntry."Global Dimension 2 Code";
            //ProjectPro - start
            DtldCustLedgEntryBuffer."NS_Retention Ledger Code" := NewCustLedgEntry."NS_Retention Ledger Code";
            //ProjectPro - end
            NewEntry := TRUE;
        END;

        DtldCustLedgEntryBuffer.Amount :=
          DtldCustLedgEntryBuffer.Amount + DtldCustLedgEntry.Amount;
        DtldCustLedgEntryBuffer."Amount (LCY)" :=
          DtldCustLedgEntryBuffer."Amount (LCY)" + DtldCustLedgEntry."Amount (LCY)";
        DtldCustLedgEntryBuffer."Debit Amount" :=
          DtldCustLedgEntryBuffer."Debit Amount" + DtldCustLedgEntry."Debit Amount";
        DtldCustLedgEntryBuffer."Credit Amount" :=
          DtldCustLedgEntryBuffer."Credit Amount" + DtldCustLedgEntry."Credit Amount";
        DtldCustLedgEntryBuffer."Debit Amount (LCY)" :=
          DtldCustLedgEntryBuffer."Debit Amount (LCY)" + DtldCustLedgEntry."Debit Amount (LCY)";
        DtldCustLedgEntryBuffer."Credit Amount (LCY)" :=
          DtldCustLedgEntryBuffer."Credit Amount (LCY)" + DtldCustLedgEntry."Credit Amount (LCY)";

        IF NewEntry THEN
            DtldCustLedgEntryBuffer.INSERT
        ELSE
            DtldCustLedgEntryBuffer.MODIFY;
    end;

    local procedure InsertDtldEntries()
    begin
        DtldCustLedgEntryBuffer.RESET;
        //ProjectPro - start
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
            DtldCustLedgEntryBuffer.SETRANGE("NS_Retention Ledger Code", "Cust. Ledger Entry"."NS_Retention Ledger Code");
        //ProjectPro - end
        IF DtldCustLedgEntryBuffer.FIND('-') THEN
            REPEAT
                IF ((DtldCustLedgEntryBuffer.Amount <> 0) OR
                    (DtldCustLedgEntryBuffer."Amount (LCY)" <> 0) OR
                    (DtldCustLedgEntryBuffer."Debit Amount" <> 0) OR
                    (DtldCustLedgEntryBuffer."Credit Amount" <> 0) OR
                    (DtldCustLedgEntryBuffer."Debit Amount (LCY)" <> 0) OR
                    (DtldCustLedgEntryBuffer."Credit Amount (LCY)" <> 0))
                THEN BEGIN
                    LastDtldEntryNo := LastDtldEntryNo + 1;

                    NewDtldCustLedgEntry := DtldCustLedgEntryBuffer;
                    NewDtldCustLedgEntry."Entry No." := LastDtldEntryNo;
                    NewDtldCustLedgEntry.INSERT(TRUE);
                END;
            UNTIL DtldCustLedgEntryBuffer.NEXT = 0;
        DtldCustLedgEntryBuffer.DELETEALL;
    end;

    local procedure InitializeParameter()
    begin
        IF EntrdDateComprReg."Ending Date" = 0D THEN
            EntrdDateComprReg."Ending Date" := TODAY;
        IF EntrdCustLedgEntry.Description = '' THEN
            EntrdCustLedgEntry.Description := Text009;

        WITH "Cust. Ledger Entry" DO BEGIN
            InsertField(FIELDNO("Document No."), FIELDCAPTION("Document No."));
            InsertField(FIELDNO("Sell-to Customer No."), FIELDCAPTION("Sell-to Customer No."));
            InsertField(FIELDNO("Salesperson Code"), FIELDCAPTION("Salesperson Code"));
            InsertField(FIELDNO("Global Dimension 1 Code"), FIELDCAPTION("Global Dimension 1 Code"));
            InsertField(FIELDNO("Global Dimension 2 Code"), FIELDCAPTION("Global Dimension 2 Code"));
        END;

        RetainDimText := DimSelectionBuf.GetDimSelectionText(3, REPORT::"Date Compress Customer Ledger", '');
    end;

    [Scope('Cloud')]
    procedure InitializeRequest(StartingDate: Date; EndingDate: Date; PeriodLength: Option; Description: Text[50]; RetainDocumentNo: Boolean; RetainSelltoCustomerNo: Boolean; RetainSalespersonCode: Boolean; RetainDimensionText: Text[250])
    begin
        InitializeParameter;
        EntrdDateComprReg."Starting Date" := StartingDate;
        EntrdDateComprReg."Ending Date" := EndingDate;
        EntrdDateComprReg."Period Length" := PeriodLength;
        EntrdCustLedgEntry.Description := Description;
        Retain[1] := RetainDocumentNo;
        Retain[2] := RetainSelltoCustomerNo;
        Retain[3] := RetainSalespersonCode;
        RetainDimText := RetainDimensionText;
    end;
}

