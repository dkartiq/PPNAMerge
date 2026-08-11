codeunit 14021406 "NS_ExportImport Excel Handle"
{
    // version PPNA11.00,SPLN

    // SPLN1.00 2019-01-31 DMT Redesigned for use of ExcelBuffer
    // 
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        Text000Lbl: Label 'Excel Program not found.';
        Text001Lbl: Label 'You must enter a file name.';
        Text003Lbl: Label 'The file %1 does not exist.', Comment = '%1=WorkbookPath';
        Text004Lbl: Label 'Value from Excel is not valid for Field %1 %2 in sheet %3, Excel Value : %4.', Comment = '%1=Number,%2=Name,%3=excelerrorinfo,%4=ValueasText';
        Window: Dialog;
        StatusCounter: Integer;
        TotalRecNo: Integer;
        Text005Lbl: Label 'Current process @1@@@@@@@@@@@@@@@\';
        Text006Lbl: Label 'Current status  #2###################';
        Text007Lbl: Label 'Export definition.';
        Text008Lbl: Label 'Export data from table %1.';
        Text009Lbl: Label 'Import data to table %1.';
        Text010Lbl: Label 'Mapping has not been created.';
        Text011Lbl: Label 'Do you want the system to automatically define the\Excel column for each field?';
        Text012Lbl: Label 'When importing into a table that contains data, a duplicate check is not available\\Do you want to continue?';
        Text013Lbl: Label 'Import completed.';
        Text014Lbl: Label 'When importing into table %1 %2, duplicates were found. Duplicates are not allowed in the Excel worksheet and importation will be terminated.';
        Text015lbl: Label 'When importing data, duplicates were found in the Excel worksheet.';
        Text016Lbl: Label 'The option value %1 found in sheet %2 cell %3 is invalid.';
        Text018Lbl: Label 'Table %1, %2.';
        Text020Lbl: Label 'No fields defined';
        IntegerValue: Integer;
        LastLine: Integer;
        JobMatPlan: Record "NS_Job Material Planning";
        GlobalRecRef: RecordRef;
        FileMngt: Codeunit "File Management";

    procedure NS_InsertKeyFields(var EIE: Record "NS_Export/Import Excel Header")
    var
        EIELines: Record "NS_Export / Import Excel Line";
        RecordReference: RecordRef;
        KeyReference: KeyRef;
        FieldReference: FieldRef;
        i: Integer;
    begin
        if EIE."NS_Table No." = 0 then
            exit;
        EIELines.SetRange(NS_Code, EIE.NS_Code);
        EIELines.SetRange("NS_Job No.", EIE."NS_Job No.");
        if EIELines.Find('-') then
            exit;

        EIELines.Reset;
        RecordReference.Open(EIE."NS_Table No.");
        KeyReference := RecordReference.KeyIndex(1);
        for i := 1 to KeyReference.FieldCount do begin
            FieldReference := KeyReference.FieldIndex(i);
            EIELines.NS_Code := EIE.NS_Code;
            EIELines."NS_Table no." := EIE."NS_Table No.";
            EIELines."NS_Line No." := i * 10000;
            EIELines."NS_Job No." := EIE."NS_Job No.";
            EIELines."NS_Field No." := FieldReference.Number;
            EIELines.NS_KeyIndex := i;
            EIELines.Insert;
        end;
        RecordReference.Close;
    end;

    procedure NS_InsertAllFields(var EIEHeader: Record "NS_Export/Import Excel Header"; DoMapFields: Boolean)
    var
        EIELines: Record "NS_Export / Import Excel Line";
        FieldObject: Record "Field";
        i: Integer;
    begin
        if EIEHeader.NS_Code = '' then
            Error(Text010Lbl);

        EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
        EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
        if not EIELines.Find('-') then
            NS_InsertKeyFields(EIEHeader);

        if EIELines.Find('+') then
            i := EIELines."NS_Line No." + 10000
        else
            i := 10000;

        FieldObject.SetRange(TableNo, EIEHeader."NS_Table No.");
        FieldObject.SetRange(FieldObject.Enabled, true);
        FieldObject.SetRange(FieldObject.Class, FieldObject.Class::Normal);
        FieldObject.SetFilter(FieldObject.Type, '%1|%2|%3|%4|%5|%6|%7|%8',
          FieldObject.Type::Text,
          FieldObject.Type::Date,
          FieldObject.Type::Decimal,
          FieldObject.Type::Boolean,
          FieldObject.Type::Code,
          FieldObject.Type::Option,
          FieldObject.Type::Integer,
          FieldObject.Type::BigInteger);
        if FieldObject.Find('-') then
            repeat
                EIELines.Reset;
                EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
                EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
                EIELines.SetRange("NS_Field No.", FieldObject."No.");
                if not EIELines.Find('-') then begin
                    Clear(EIELines);
                    EIELines.NS_Code := EIEHeader.NS_Code;
                    EIELines."NS_Table no." := EIEHeader."NS_Table No.";
                    EIELines."NS_Job No." := EIEHeader."NS_Job No.";
                    EIELines."NS_Line No." := i;
                    EIELines."NS_Field No." := FieldObject."No.";
                    EIELines.Insert;
                    i := i + 10000;
                end;
            until FieldObject.Next = 0;

        if not DoMapFields then begin
            if Confirm(Text011Lbl) then begin
                EIELines.Reset;
                EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
                EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
                //AutoMapFields(EIELines);
            end
        end else begin
            EIELines.Reset;
            EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
            EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
            //AutoMapFields(EIELines);
        end;
    end;

    procedure NS_ExportDefinition(var EIEHeader: Record "NS_Export/Import Excel Header"; WorkBookPath: Text[250])
    var
        EIELines: Record "NS_Export / Import Excel Line";
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        Char10: Char;
        T10: Text[1];
        RowComment: Text[300];
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        if WorkBookPath = '' then
            if EIEHeader."NS_File Name" <> '' then
                WorkBookPath := EIEHeader."NS_File Name"
            else
                Error(Text001Lbl);

        Window.Open(Text005Lbl + Text006Lbl);
        Window.Update(2, Text007Lbl);
        Clear(StatusCounter);

        EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
        EIELines.SetRange(NS_Type, EIELines.NS_Type::Column);
        EIELines.SetFilter(NS_Source, '<>%1', '');
        TotalRecNo := EIELines.Count;
        if EIELines.Find('-') then begin
            RecordReference.Open(EIELines."NS_Table no.");
            FieldReference := RecordReference.Field(EIELines."NS_Field No.");
            if EIEHeader."NS_First DataRow" > 1 then
                NS_AddColumnValue(ExcelBuffer, 'A', 1, StrSubstNo(Text018Lbl, RecordReference.Number,
                  RecordReference.Caption), true, FieldReference);
            repeat
                StatusCounter := StatusCounter + 1;
                Window.Update(1, Round(StatusCounter / TotalRecNo * 10000, 1));

                FieldReference := RecordReference.Field(EIELines."NS_Field No.");

                if EIEHeader."NS_First DataRow" = 3 then begin
                    NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 2, FieldReference.Name,
                      true, FieldReference);
                end;
                if EIEHeader."NS_First DataRow" = 4 then begin
                    NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 2, FieldReference.Name,
                      true, FieldReference);
                    NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 3, FieldReference.Caption,
                      true, FieldReference);
                end;
                if EIEHeader."NS_First DataRow" >= 5 then begin
                    NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 2, FieldReference.Name,
                      true, FieldReference);
                    NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 3, FieldReference.Caption,
                      true, FieldReference);
                    if (Format(FieldReference.Type) = 'Text') or (Format(FieldReference.Type) = 'Code') then
                        NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 4, Format(FieldReference.Type) +
                          Format(FieldReference.Length), true, FieldReference)
                    else
                        NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, 4, Format(FieldReference.Type),
                          true, FieldReference);
                end;
                if EIEHeader."NS_First DataRow" > 1 then begin
                    Char10 := 10;
                    T10 := Format(Char10);
                    Clear(RowComment);
                    if EIELines.NS_Description <> '' then
                        RowComment := EIELines.NS_Description + T10;
                    if FieldReference.OptionCaption <> '' then
                        NS_AddOptionComment(FieldReference, RowComment);
                    if RowComment <> '' then begin
                        ExcelBuffer.Comment := CopyStr(RowComment, 1, 250);
                        ExcelBuffer.Modify;
                    end;
                end;
            until EIELines.Next = 0;
            RecordReference.Close;

            //PPNA16.0 Blocked Start
            // if FileMngt.ServerFileExists(WorkBookPath) then
            //     ExcelBuffer.UpdateBookExcel(WorkBookPath, EIEHeader.NS_Code, false)
            // else
            // ExcelBuffer.CreateBook(WorkBookPath, EIEHeader.NS_Code);
            //PPNA16.0 Blocked End
            ExcelBuffer.WriteSheet('', CompanyName, UserId);
            ExcelBuffer.CloseBook;
        end else begin
            NS_CleanUpOnError;
            Error(Text020Lbl);
        end;
        Window.Close;
    end;

    procedure NS_ExportData(var EIEHeader: Record "NS_Export/Import Excel Header"; WorkBookPath: Text[250])
    var
        EIELines: Record "NS_Export / Import Excel Line";
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        DataRowFactor: Integer;
        i: Integer;
        x: Integer;
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        if WorkBookPath = '' then
            if EIEHeader."NS_File Name" <> '' then
                WorkBookPath := EIEHeader."NS_File Name"
            else
                Error(Text001Lbl);

        NS_ExportDefinition(EIEHeader, WorkBookPath);

        if EIEHeader."NS_First DataRow" > 1 then
            DataRowFactor := (EIEHeader."NS_First DataRow" - 1)
        else
            DataRowFactor := 0;

        Window.Open(Text005Lbl + Text006Lbl);
        Window.Update(2, StrSubstNo(Text008Lbl, Format(EIEHeader."NS_Table No.")));
        Clear(StatusCounter);

        // ExcelBuffer.OpenBook(WorkBookPath, EIEHeader.NS_Code);//PPNA16.0 Blocked

        RecordReference.Open(EIEHeader."NS_Table No.");
        TotalRecNo := RecordReference.Count;
        if RecordReference.Find('-') then begin
            for i := 1 to RecordReference.Count do begin
                StatusCounter := StatusCounter + 1;
                Window.Update(1, Round(StatusCounter / TotalRecNo * 10000, 1));
                for x := 1 to RecordReference.FieldCount do begin
                    FieldReference := RecordReference.FieldIndex(x);
                    EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
                    EIELines.SetRange("NS_Field No.", FieldReference.Number);
                    EIELines.SetRange(NS_Type, EIELines.NS_Type::Column);
                    EIELines.SetFilter(NS_Source, '<>%1', '');
                    if EIELines.Find('-') then begin
                        NS_AddColumnValue(ExcelBuffer, EIELines.NS_Source, i + DataRowFactor, Format(FieldReference.Value), false, FieldReference);
                    end;
                end;
                if RecordReference.Next = 0 then;
            end;
        end;
        RecordReference.Close;

        ExcelBuffer.WriteSheet('', CompanyName, UserId);
        ExcelBuffer.CloseBook;
        Window.Close;
    end;

    procedure NS_ImportDataSingleSheet(var EIEHeader: Record "NS_Export/Import Excel Header"; WorkBookPath: Text[250]; MultipleImport: Boolean; Implementation: Boolean; JobNo: Code[20]) SheetImported: Boolean
    var
        EIELines: Record "NS_Export / Import Excel Line";
        RecordReference: RecordRef;
        FieldReference: FieldRef;
        i: Integer;
        NoOfRows: Integer;
        SkipRecord: Boolean;
        DataInTable: Boolean;
        DublicatesFound: Boolean;
        FldRefValue: Code[20];
        EIELines2: Record "NS_Export / Import Excel Line";
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin
        if WorkBookPath = '' then
            if EIEHeader."NS_File Name" <> '' then
                WorkBookPath := EIEHeader."NS_File Name"
            else
                Error(Text001Lbl);

        if not FileMngt.ServerFileExists(WorkBookPath) then
            Error(Text003Lbl, WorkBookPath);


        //PPNA16.0 Blocked Start
        // if FileMngt.ServerFileExists(WorkBookPath) then begin
        //     ExcelBuffer.OpenBook(WorkBookPath, EIEHeader.NS_Code);
        //     ExcelBuffer.ReadSheet;
        // end else
        //     ExcelBuffer.CreateBook(WorkBookPath, EIEHeader.NS_Code);
        //PPNA16.0 Blocked End

        RecordReference.Open(EIEHeader."NS_Table No.");
        GlobalRecRef.Open(EIEHeader."NS_Table No.");

        if DATABASE::"NS_Job Material Planning" = EIEHeader."NS_Table No." then begin
            JobMatPlan.SetRange("NS_Worksheet Job No.", JobNo);
            if JobMatPlan.FindLast then
                LastLine := JobMatPlan."NS_Line No.";
        end;

        if RecordReference.Count <> 0 then begin
            DataInTable := true;
            if not EIEHeader.NS_AllowDuplicates then
                if not MultipleImport then
                    if not Confirm(Text012Lbl) then begin
                        ExcelBuffer.CloseBook;
                        exit(false);
                    end;
        end else
            DataInTable := false;

        if Implementation and DataInTable then begin
            RecordReference.DeleteAll;
            DataInTable := false;
        end;

        Window.Open(Text005Lbl + Text006Lbl);
        Window.Update(2, StrSubstNo(Text009Lbl, Format(EIEHeader."NS_Table No.")));
        Clear(StatusCounter);

        if ExcelBuffer.FindLast then;
        NoOfRows := ExcelBuffer."Row No.";
        TotalRecNo := NoOfRows;

        if EIEHeader."NS_First DataRow" = 0 then
            EIEHeader."NS_First DataRow" := 1;

        for i := EIEHeader."NS_First DataRow" to NoOfRows do begin
            FldRefValue := '';
            StatusCounter := StatusCounter + 1;
            Window.Update(1, Round(StatusCounter / TotalRecNo * 10000, 1));
            EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
            EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
            EIELines.SetFilter(NS_KeyIndex, '>%1', 0);
            if EIELines.Find('-') then begin
                repeat
                    FieldReference := RecordReference.Field(EIELines."NS_Field No.");
                    if EIELines.NS_Type = EIELines.NS_Type::Column then begin
                        if StrLen(EIELines.NS_Source) <> 0 then
                            NS_ImportValue(ExcelBuffer, EIEHeader.NS_Code, EIELines.NS_Source + Format(i), EIELines.NS_Type, FieldReference, i, EIELines.NS_Source)
                    end else
                        NS_ImportValue(ExcelBuffer, EIEHeader.NS_Code, EIELines.NS_Source, EIELines.NS_Type, FieldReference, i, EIELines.NS_Source)
                until EIELines.Next = 0;
            end;

            Clear(SkipRecord);
            if RecordReference.Find('=') then begin
                if EIEHeader.NS_AllowDuplicates then begin
                    if DataInTable then
                        DublicatesFound := true
                end else
                    if not DataInTable then begin
                        ExcelBuffer.CloseBook;
                        EIEHeader.CalcFields("NS_Table Name");
                        Window.Close;
                        Error(Text014Lbl, EIEHeader."NS_Table No.", EIEHeader."NS_Table Name");
                    end;

                if EIEHeader.NS_ImportOption = EIEHeader.NS_ImportOption::"Add entries" then
                    SkipRecord := true;
            end;

            //*-
            if EIEHeader.NS_ValidateInsertModify then begin
                if FldRefValue <> '' then
                    if not RecordReference.Insert(true) then
                        if EIEHeader.NS_ImportOption = EIEHeader.NS_ImportOption::"Replace entries" then
                            RecordReference.Modify(true);
            end else begin
                if FldRefValue <> '' then
                    if not RecordReference.Insert then
                        if EIEHeader.NS_ImportOption = EIEHeader.NS_ImportOption::"Replace entries" then
                            RecordReference.Modify;
            end;
            //*+

            if not SkipRecord then begin
                EIELines.SetRange(NS_Code, EIEHeader.NS_Code);
                EIELines.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
                EIELines.SetRange(NS_KeyIndex, 0);
                if EIELines.Find('-') then begin
                    repeat
                        FieldReference := RecordReference.Field(EIELines."NS_Field No.");
                        if EIELines.NS_Type = EIELines.NS_Type::Column then begin
                            if StrLen(EIELines.NS_Source) <> 0 then
                                NS_ImportValue(ExcelBuffer, EIEHeader.NS_Code, EIELines.NS_Source + Format(i), EIELines.NS_Type, FieldReference, i, EIELines.NS_Source)
                        end else
                            NS_ImportValue(ExcelBuffer, EIEHeader.NS_Code, EIELines.NS_Source, EIELines.NS_Type, FieldReference, i, EIELines.NS_Source)
                    until EIELines.Next = 0;
                end;
            end;

            //*-
            EIELines2.Reset;
            EIELines2.SetRange(NS_Code, EIEHeader.NS_Code);
            EIELines2.SetRange("NS_Job No.", EIEHeader."NS_Job No.");
            EIELines2.SetRange(NS_KeyIndex, 0);//?
            EIELines2.SetRange("NS_Field Validate", true);
            if EIELines2.FindFirst then begin
                FieldReference := RecordReference.Field(EIELines2."NS_Field No.");
                FldRefValue := FieldReference.Value;
                if EIEHeader.NS_ValidateInsertModify then begin
                    if FldRefValue <> '' then
                        if not RecordReference.Insert(true) then
                            if EIEHeader.NS_ImportOption = EIEHeader.NS_ImportOption::"Replace entries" then
                                RecordReference.Modify(true);
                end else begin
                    if FldRefValue <> '' then
                        if not RecordReference.Insert then
                            if EIEHeader.NS_ImportOption = EIEHeader.NS_ImportOption::"Replace entries" then
                                RecordReference.Modify;
                end;
            end;
            //*+
        end;
        RecordReference.Close;
        ExcelBuffer.CloseBook;
        Window.Close;

        if not DataInTable and EIEHeader.NS_AllowDuplicates and DublicatesFound then
            Message(Text015lbl);

        if not MultipleImport then
            Message(Text013Lbl);

        exit(true);
    end;

    // procedure ImportDataMultipleSheets(WorkBookPath: Text[250]; Implementation: Boolean)
    // var
    //     EIEHeader: Record "Export / Import Excel Header";
    //     EndOfLoop: Integer;
    //     i: Integer;
    //     XlWrkBkReader: dotnet WorkbookReader1;
    //     DotNetArray: Codeunit DotNet_Array;
    //     SheetName: Text;
    // begin
    //     if FileMngt.ServerFileExists(WorkBookPath) then begin
    //         XlWrkBkReader := XlWrkBkReader.Open(WorkBookPath);
    //         DotNetArray.SetArray(XlWrkBkReader.SheetNames);
    //     end else
    //         Error(Text003, WorkBookPath);

    //     for i := 0 to DotNetArray.Length - 1 do begin
    //         SheetName := DotNetArray.GetValueAsText(i);
    //         if StrLen(SheetName) < 21 then
    //             if EIEHeader.Get(SheetName) then
    //                 ImportDataSingleSheet(EIEHeader, WorkBookPath, true, Implementation, '');
    //         i += 1;
    //     end;
    // end;

    local procedure NS_AddColumnValue(var ExcelBuf: Record "Excel Buffer"; ColumnNo: Text[20]; RowNo: Integer; ColumnValue: Text[1024]; ColumnHeader: Boolean; var FieldReference: FieldRef)
    var
        Chr: Char;
        TextValue: Text[1];
        BooleanConvertion: Boolean;
    begin
        if not ColumnHeader then
            case UpperCase(Format(FieldReference.Type)) of
                'CODE', 'TEXT':
                    begin
                        Chr := 39;
                        TextValue := Format(Chr);
                        NS_EnterCell(ExcelBuf, RowNo, ColumnNo, TextValue + ColumnValue, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
                    end;
                'BOOLEAN':
                    begin
                        if not ColumnHeader then begin
                            Evaluate(BooleanConvertion, ColumnValue);
                            if BooleanConvertion then
                                NS_EnterCell(ExcelBuf, RowNo, ColumnNo, '1', false, false, false, false, '', ExcelBuf."Cell Type"::Text)
                            else
                                NS_EnterCell(ExcelBuf, RowNo, ColumnNo, '0', false, false, false, false, '', ExcelBuf."Cell Type"::Text);
                        end;
                    end;
                else
                    NS_EnterCell(ExcelBuf, RowNo, ColumnNo, ColumnValue, false, false, false, false, '', ExcelBuf."Cell Type"::Text);
            end
        else
            NS_EnterCell(ExcelBuf, RowNo, ColumnNo, ColumnValue, true, true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure NS_GetColumnCode(ColumnNo: Integer) xlColumn: Text[2]
    var
        x: Integer;
        i: Integer;
        c: Char;
        xlColID: array[10] of Char;
    begin
        //not in use
        Clear(xlColID);
        if ColumnNo <> 0 then begin
            x := ColumnNo - 1;
            c := 65 + x mod 26;
            xlColID[10] := c;
            i := 10;
            while x > 25 do begin
                x := x div 26;
                i := i - 1;
                c := 64 + x mod 26;
                xlColID[i] := c;
            end;
            for x := i to 10 do
                xlColumn := xlColumn + Format(xlColID[x]);
        end;
        exit(xlColumn);
    end;

    local procedure NS_ImportValue(var ExcelBuf: Record "Excel Buffer"; SheetName: Text[30]; Source: Text[250]; Type: Option Column,Constant,Auto; var FieldReference: FieldRef; Row: Integer; Column: Text)
    var
        BooleanType: Boolean;
        DecimalType: Decimal;
        IntegerType: Integer;
        DateType: Date;
        OptionType: Option;
        BigIntegerType: BigInteger;
        ValueAsText: Text[250];
        ExcelErrorInfo: Text[250];
        IntSubValue: Integer;
        Text0001lbl: Label '''';
    begin
        Clear(ValueAsText);

        //SPLN1.00
        //IF Type = Type::Column THEN
        //  XlSheet.Range(Source).Columns.AutoFit;

        if Type = Type::Column then
            ExcelBuf.Get(Row, NS_GetColumnNo(Column));

        case UpperCase(Format(FieldReference.Type)) of
            'TEXT':
                begin
                    case Type of
                        Type::Column:
                            begin
                                ValueAsText := ExcelBuf."Cell Value as Text";
                                if ValueAsText = '0' then
                                    ValueAsText := '';
                            end;
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if StrLen(ValueAsText) > FieldReference.Length then begin
                        ExcelErrorInfo := SheetName + '/' + Source;
                        NS_CleanUpOnError;
                        Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                    end else
                        FieldReference.Value := ValueAsText;
                end;
            'DATE':
                begin
                    case Type of
                        Type::Column:
                            begin
                                //SPLN1.00 XlSheet.Range(Source).NumberFormat := 0;
                                ValueAsText := Format(NS_SerialDate2DMY(ExcelBuf."Cell Value as Text"));
                            end;
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if ValueAsText <> '' then begin
                        if not Evaluate(DateType, ValueAsText) then begin
                            ExcelErrorInfo := SheetName + '/' + Source;
                            NS_CleanUpOnError;
                            Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                        end else
                            //FieldReference.VALUE := DateType
                            FieldReference.Value(DateType);
                    end else begin
                        DateType := 0D;
                        //FieldReference.VALUE := DateType;
                        FieldReference.Value(DateType);
                    end;
                end;
            'DECIMAL':
                begin
                    case Type of
                        Type::Column:
                            ValueAsText := Format(ExcelBuf."Cell Value as Text");
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if ValueAsText <> '' then begin
                        if not Evaluate(DecimalType, ValueAsText) then begin
                            DecimalType := 0;
                            FieldReference.Validate(DecimalType);
                            /*ExcelErrorInfo := XlSheet.Name + '/' + Source;
                            CleanUpOnError;
                            ERROR(Text004,FieldReference.NUMBER,FieldReference.NAME,ExcelErrorInfo,ValueAsText)*/
                        end else
                            //FieldReference.VALUE := DecimalType;
                            FieldReference.Validate(DecimalType);
                    end else begin
                        DecimalType := 0;
                        //FieldReference.VALUE := DecimalType;
                        FieldReference.Validate(DecimalType);
                    end;
                end;
            'BOOLEAN':
                begin
                    case Type of
                        Type::Column:
                            ValueAsText := Format(ExcelBuf."Cell Value as Text");
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if ValueAsText <> '' then begin
                        if not Evaluate(BooleanType, ValueAsText) then begin
                            ExcelErrorInfo := SheetName + '/' + Source;
                            NS_CleanUpOnError;
                            Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                        end else
                            FieldReference.Value := BooleanType;
                    end else begin
                        BooleanType := false;
                        FieldReference.Value := BooleanType;
                    end;
                end;

            'CODE':
                begin
                    case Type of
                        Type::Column:
                            begin
                                ValueAsText := Format(ExcelBuf."Cell Value as Text");
                                if ValueAsText = '0' then
                                    ValueAsText := '';
                            end;
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if StrLen(ValueAsText) > FieldReference.Length then begin
                        ExcelErrorInfo := SheetName + '/' + Source;
                        NS_CleanUpOnError;
                        Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                    end else
                        FieldReference.Value := ValueAsText;
                    //FieldReference.VALIDATE(ValueAsText);
                end;
            'OPTION':
                begin
                    case Type of
                        Type::Column:
                            begin
                                ValueAsText := Format(ExcelBuf."Cell Value as Text");
                                if StrLen(ValueAsText) = 0 then
                                    ValueAsText := '0';
                                if not NS_ValidateOptionValue(FieldReference, ValueAsText) then begin
                                    NS_CleanUpOnError;
                                    Error(Text016Lbl, SheetName, ValueAsText, Source);
                                end;
                            end;
                        Type::Constant:
                            begin
                                ValueAsText := Source;
                                if StrLen(ValueAsText) = 0 then
                                    ValueAsText := '0';
                                if not NS_ValidateOptionValue(FieldReference, ValueAsText) then begin
                                    NS_CleanUpOnError;
                                    Error(Text016Lbl, SheetName, ValueAsText, Format(FieldReference.Number));
                                end;
                            end;
                    end;

                    if ValueAsText <> '' then
                        if not Evaluate(OptionType, ValueAsText) then begin
                            ExcelErrorInfo := SheetName + '/' + Source;
                            NS_CleanUpOnError;
                            Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                        end else
                            FieldReference.Value := OptionType;
                end;
            'INTEGER':
                begin
                    case Type of
                        Type::Column:
                            begin
                                ValueAsText := Format(ExcelBuf."Cell Value as Text");
                                if StrLen(ValueAsText) = 0 then
                                    ValueAsText := '0';
                            end;
                        Type::Constant:
                            ValueAsText := Source;
                        Type::Auto:
                            begin
                                if LastLine = 0 then begin
                                    Evaluate(IntSubValue, Source);
                                    LastLine := IntSubValue;
                                end else begin
                                    Evaluate(IntSubValue, Source);
                                    LastLine += IntSubValue;
                                    ;
                                end;
                                ValueAsText := Format(LastLine);
                            end;
                    /*BEGIN
                      IntegerValue := LastLine;
                      IF IntegerValue = 0 THEN BEGIN
                        EVALUATE(IntSubValue,Source);
                        IntegerValue := IntSubValue;
                      END ELSE BEGIN
                        EVALUATE(IntSubValue,Source);
                        IntegerValue += IntSubValue;;
                      END;
                      ValueAsText := FORMAT(IntegerValue);
                    END;*/
                    end;

                    if ValueAsText <> '' then begin
                        if not Evaluate(IntegerType, ValueAsText) then begin
                            ExcelErrorInfo := SheetName + '/' + Source;
                            NS_CleanUpOnError;
                            Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                        end else
                            FieldReference.Value := IntegerType;
                    end else begin
                        IntegerType := 0;
                        FieldReference.Value := IntegerType;
                    end;
                end;
            'BIGINTEGER':
                begin
                    case Type of
                        Type::Column:
                            begin
                                ValueAsText := Format(ExcelBuf."Cell Value as Text");
                                if StrLen(ValueAsText) = 0 then
                                    ValueAsText := '0';
                            end;
                        Type::Constant:
                            ValueAsText := Source;
                    end;

                    if ValueAsText <> '' then begin
                        if not Evaluate(BigIntegerType, ValueAsText) then begin
                            ExcelErrorInfo := SheetName + '/' + Source;
                            NS_CleanUpOnError;
                            Error(Text004Lbl, FieldReference.Number, FieldReference.Name, ExcelErrorInfo, ValueAsText)
                        end else
                            FieldReference.Value := BigIntegerType;
                    end else begin
                        IntegerType := 0;
                        FieldReference.Value := BigIntegerType;
                    end;
                end;
        end;

    end;

    procedure NS_AutoMapFields(EIELines: Record "NS_Export / Import Excel Line")
    var
        i: Integer;
    begin
        //not in use
        EIELines.SetRange(NS_Type, EIELines.NS_Type::Column);
        EIELines.SetRange(NS_Code, EIELines.NS_Code);
        EIELines.SetRange("NS_Job No.", EIELines."NS_Job No.");
        if EIELines.Find('-') then begin
            for i := 1 to EIELines.Count do begin
                EIELines.NS_Source := NS_GetColumnCode(i);
                EIELines.Modify;
                if EIELines.Next = 0 then;
            end;
        end;
        EIELines.SetRange(NS_Type);
    end;

    procedure NS_AddOptionComment(var FieldReference: FieldRef; var RowComment: Text[300])
    var
        Char10: Char;
        T10: Text[1];
        StartPos: Integer;
        FieldNo: Integer;
        i: Integer;
        FieldBuffer: array[50] of Text[250];
    begin
        if StrLen(FieldReference.OptionCaption) = 0 then
            exit;

        StartPos := 1;
        FieldNo := 1;
        Char10 := 10;
        T10 := Format(Char10);
        Clear(FieldBuffer);

        while not (StartPos = StrLen(FieldReference.OptionCaption) + 1) do begin
            if CopyStr(FieldReference.OptionCaption, StartPos, 1) <> ',' then
                FieldBuffer[FieldNo] := FieldBuffer[FieldNo] + CopyStr(FieldReference.OptionCaption, StartPos, 1)
            else
                FieldNo := FieldNo + 1;
            StartPos := StartPos + 1;
        end;

        for i := 1 to FieldNo do
            RowComment := RowComment + Format(i - 1) + ': ' + FieldBuffer[i] + T10
    end;

    procedure NS_ValidateOptionValue(var FieldReference: FieldRef; OptionValue: Text[250]) Valid: Boolean
    var
        StartPos: Integer;
        OptionNo: Integer;
        OptionValueAsInteger: Integer;
        OptionValueNo: Text;
    begin
        /*WITH GlobalRecRef DO BEGIN
          OptionValueNo := FIELD(5).VALUE;
        END;*/
        if not Evaluate(OptionValueAsInteger, OptionValue) then
            if not Evaluate(OptionValueAsInteger, OptionValueNo) then
                exit(false);

        StartPos := 1;
        OptionNo := 0;

        while not (StartPos = StrLen(FieldReference.OptionCaption) + 1) do begin
            if CopyStr(FieldReference.OptionCaption, StartPos, 1) = ',' then
                OptionNo := OptionNo + 1;
            StartPos := StartPos + 1;
        end;

        exit(not (OptionValueAsInteger > OptionNo));

    end;

    procedure NS_SerialDate2DMY(SerialDateText: Text[250]) DMYDate: Date
    var
        SerialDate: Integer;
        OffsetDate: Date;
        NoOfCalc: Decimal;
        RemainingDays: Integer;
        I: Integer;
    begin
        DMYDate := 0D;
        if not Evaluate(SerialDate, SerialDateText) then
            exit(DMYDate);

        if SerialDate = 0 then
            exit(DMYDate);

        OffsetDate := 19000101D;

        // do not add last day.
        SerialDate := SerialDate - 1;

        // Compensate for Know bug in Excel 1900 is not a leapyear
        if SerialDate > 60 then
            SerialDate := SerialDate - 1;

        NoOfCalc := SerialDate / 9999;
        NoOfCalc := Round(NoOfCalc, 1, '<');
        RemainingDays := SerialDate mod 9999;

        for I := 1 to NoOfCalc do
            OffsetDate := CalcDate('+9999<D>', OffsetDate);

        if RemainingDays <> 0 then
            OffsetDate := CalcDate('+' + Format(RemainingDays) + '<D>', OffsetDate);

        exit(OffsetDate);
    end;

    procedure NS_CleanUpOnError()
    begin
    end;

    procedure NS_OpenFile(WindowTitle: Text[50]; DefaultFileName: Text[250]; DefaultFileType: Option " ",Text,Excel,Word,Custom; FilterString: Text[250]; "Action": Option Open,Save): Text[260]
    var
        CommonDialogControl: Integer;
        FileMgt: Codeunit "File Management";
    begin
        //exit(FileMgt.OpenFileDialog(WindowTitle, DefaultFileName, FilterString));   //PRJ-1221.JS.1.0  24FEB2022 Need to check comments
    end;

    local procedure NS_EnterCell(var ExcelBuf: Record "Excel Buffer"; RowNo: Integer; ColumnCode: Text[20]; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; DoubleUnderLine: Boolean; Format: Text[30]; CellType: Option)
    begin
        //SPLN1.00
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo);
        ExcelBuf.Validate("Column No.", NS_GetColumnNo(ColumnCode));
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Italic := Italic;
        if DoubleUnderLine = true then begin
            ExcelBuf."Double Underline" := true;
            ExcelBuf.Underline := false;
        end else begin
            ExcelBuf."Double Underline" := false;
            ExcelBuf.Underline := UnderLine;
        end;
        ExcelBuf.NumberFormat := Format;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.Insert;
    end;

    local procedure NS_GetColumnNo(ColumnCode: Code[20]) xlColumn: Integer
    var
        Multi: Integer;
        x: Decimal;
    begin
        //SPLN1.00
        ColumnCode := CopyStr(DelChr(ColumnCode), 1, 3);  //to ensure max 16384 columns
        Multi := StrLen(ColumnCode);
        while StrLen(ColumnCode) > 0 do begin
            if Multi = 1 then
                x := (ColumnCode[1] - 'A' + 1)
            else
                x := (ColumnCode[1] - 'A' + 1) * Power(26, (Multi - 1));
            xlColumn += Round(x, 1);
            ColumnCode := CopyStr(ColumnCode, 2);
            Multi := StrLen(ColumnCode);
        end;
    end;
}

