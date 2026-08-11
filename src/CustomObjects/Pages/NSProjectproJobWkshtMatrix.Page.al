page 14021402 "NS_Project Pro Job WkshtMatrix"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    DeleteAllowed = true;
    InsertAllowed = false;
    PageType = ListPart;
    Caption = 'Project Pro Job Wksht Matrix';
    SourceTable = "Job Planning Line";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1100773001)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Task No.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Original Total';
                    Editable = false;
                    ToolTip = 'Specify Quantity';
                }
                field(Welding; Rec.NS_Welding)
                {
                    ApplicationArea = All;
                    Caption = 'Welding';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specify Welding';
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field1Visible;
                    ToolTip = 'Matrix_Celldata';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[1], MATRIX_CellData[1]);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field2Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[2], MATRIX_CellData[2]);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field2Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[3], MATRIX_CellData[3]);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field4Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[4], MATRIX_CellData[4]);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field5Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[5], MATRIX_CellData[5]);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field6Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[6], MATRIX_CellData[6]);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field7Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[7], MATRIX_CellData[7]);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field8Visible;
                    ToolTip = 'MATRIX_CellData';


                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[8], MATRIX_CellData[8]);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field9Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[9], MATRIX_CellData[9]);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field10Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[10], MATRIX_CellData[10]);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field11Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[11], MATRIX_CellData[11]);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field12Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[12], MATRIX_CellData[12]);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[13];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field13Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[13], MATRIX_CellData[13]);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[14];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field14Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[14], MATRIX_CellData[14]);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[15];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field15Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[15], MATRIX_CellData[15]);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[16];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field16Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[16], MATRIX_CellData[16]);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[17];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field17Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[17], MATRIX_CellData[17]);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[18];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field18Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[18], MATRIX_CellData[18]);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[19];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field19Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[19], MATRIX_CellData[19]);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[20];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field20Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[20], MATRIX_CellData[20]);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[21];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field21Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[21], MATRIX_CellData[21]);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[22];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field22Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[22], MATRIX_CellData[22]);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[23];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field23Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[23], MATRIX_CellData[23]);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[24];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field24Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[24], MATRIX_CellData[24]);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[25];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field25Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[25], MATRIX_CellData[25]);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[26];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field26Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[26], MATRIX_CellData[26]);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[27];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field27Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[27], MATRIX_CellData[27]);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    BlankZero = true;
                    ApplicationArea = All;
                    CaptionClass = '3,' + MATRIX_CaptionSet[28];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field28Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[28], MATRIX_CellData[28]);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[29];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field29Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[29], MATRIX_CellData[29]);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[30];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field30Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[30], MATRIX_CellData[30]);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[31];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field31Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[31], MATRIX_CellData[31]);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_CaptionSet[32];
                    Style = StandardAccent;
                    StyleExpr = LineUpdated;
                    Visible = Field32Visible;
                    ToolTip = 'MATRIX_CellData';

                    trigger OnValidate();
                    begin
                        NS_MatrixDataUpdate(Rec, MATRIX_CaptionSet2[32], MATRIX_CellData[32]);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    var
        lJobPlanLine: Record "Job Planning Line";

        i: Integer;
        TestText: Text[1024];
    begin
        lJobPlanLine.SETRANGE("Job No.", "Job No.");
        if "Job Task No." <> '' then
            lJobPlanLine.SETRANGE("Job Task No.", "Job Task No.");
        lJobPlanLine.SETRANGE(Type, Type);
        lJobPlanLine.SETRANGE("No.", "No.");
        if lJobPlanLine.COUNT = Matrix_ColumnCount then
            for i := 1 to Matrix_ColumnCount do begin
                SegmentEntry.SETRANGE("NS_Job No.", "Job No.");
                if "Job Task No." <> '' then
                    SegmentEntry.SETRANGE("NS_Job Task No.", "Job Task No.");
                SegmentEntry.SETRANGE(NS_Type, Type);
                SegmentEntry.SETRANGE("NS_No.", "No.");
                TestText := MATRIX_CaptionSet2[i];
                SegmentEntry.SETRANGE("NS_Segment Code", MATRIX_CaptionSet2[i]);
                if (SegmentEntry.FINDFIRST()) and (TestText = "NS_Segment Code") then begin
                    MATRIX_CellData[i] := SegmentEntry."NS_Segment Quantity";
                    LineUpdated := not SegmentEntry.NS_Certified;
                end else begin
                    MATRIX_CellData[i] := 0;
                    LineUpdated := not SegmentEntry.NS_Certified;
                end;
            end else begin
            for i := 1 to Matrix_ColumnCount do
                SegmentEntry.SETRANGE("NS_Job No.", "Job No.");
            if "Job Task No." <> '' then
                SegmentEntry.SETRANGE("NS_Job Task No.", "Job Task No.");
            SegmentEntry.SETRANGE(NS_Type, Type);
            SegmentEntry.SETRANGE("NS_No.", "No.");
            TestText := MATRIX_CaptionSet2[i];
            SegmentEntry.SETRANGE("NS_Segment Code", MATRIX_CaptionSet2[i]);
            if (SegmentEntry.FINDFIRST()) then begin
                MATRIX_CellData[i] := SegmentEntry."NS_Segment Quantity";
                LineUpdated := not SegmentEntry.NS_Certified;
            end else begin
                MATRIX_CellData[i] := 0;
                LineUpdated := not SegmentEntry.NS_Certified;
            end;
        end;
    end;

    trigger OnOpenPage();
    begin
        Field1Visible := true;
        Field2Visible := true;
        Field3Visible := true;
        Field4Visible := true;
        Field5Visible := true;
        Field6Visible := true;
        Field7Visible := true;
        Field8Visible := true;
        Field9Visible := true;
        Field10Visible := true;
        Field11Visible := true;
        Field12Visible := true;
        Field13Visible := true;
        Field14Visible := true;
        Field15Visible := true;
        Field16Visible := true;
        Field17Visible := true;
        Field18Visible := true;
        Field19Visible := true;
        Field20Visible := true;
        Field21Visible := true;
        Field22Visible := true;
        Field23Visible := true;
        Field24Visible := true;
        Field25Visible := true;
        Field26Visible := true;
        Field27Visible := true;
        Field28Visible := true;
        Field29Visible := true;
        Field30Visible := true;
        Field31Visible := true;
        Field32Visible := true;
    end;

    var
        SegmentEntry: Record "NS_Job Takeoff Segment Entry";

        MATRIX_CellData: array[32] of Decimal;
        MATRIX_CaptionSet: array[32] of Text[1024];
        MATRIX_CaptionSet2: array[32] of Text[1024];
        [InDataSet]
        Field1Visible: Boolean;
        [InDataSet]
        Field2Visible: Boolean;
        [InDataSet]
        Field3Visible: Boolean;
        [InDataSet]
        Field4Visible: Boolean;
        [InDataSet]
        Field5Visible: Boolean;
        [InDataSet]
        Field6Visible: Boolean;
        [InDataSet]
        Field7Visible: Boolean;
        [InDataSet]
        Field8Visible: Boolean;
        [InDataSet]
        Field9Visible: Boolean;
        [InDataSet]
        Field10Visible: Boolean;
        [InDataSet]
        Field11Visible: Boolean;
        [InDataSet]
        Field12Visible: Boolean;
        [InDataSet]
        Field13Visible: Boolean;
        [InDataSet]
        Field14Visible: Boolean;
        [InDataSet]
        Field15Visible: Boolean;
        [InDataSet]
        Field16Visible: Boolean;
        [InDataSet]
        Field17Visible: Boolean;
        [InDataSet]
        Field18Visible: Boolean;
        [InDataSet]
        Field19Visible: Boolean;
        [InDataSet]
        Field20Visible: Boolean;
        [InDataSet]
        Field21Visible: Boolean;
        [InDataSet]
        Field22Visible: Boolean;
        [InDataSet]
        Field23Visible: Boolean;
        [InDataSet]
        Field24Visible: Boolean;
        [InDataSet]
        Field25Visible: Boolean;
        [InDataSet]
        Field26Visible: Boolean;
        [InDataSet]
        Field27Visible: Boolean;
        [InDataSet]
        Field28Visible: Boolean;
        [InDataSet]
        Field29Visible: Boolean;
        [InDataSet]
        Field30Visible: Boolean;
        [InDataSet]
        Field31Visible: Boolean;
        [InDataSet]
        Field32Visible: Boolean;
        JobNo: Code[20];
        Matrix_ColumnCount: Integer;
        PageCategoryFilter: Text;
        LineType: Option Resource,Item,"G/L Account",Text,"Resource (Group)";
        //SkipType: Boolean;
        JobTaskNo: Code[20];
        LineUpdated: Boolean;

    procedure NS_ShowHideColumns();
    begin
        Field1Visible := Matrix_ColumnCount >= 1;
        Field2Visible := Matrix_ColumnCount >= 2;
        Field3Visible := Matrix_ColumnCount >= 3;
        Field4Visible := Matrix_ColumnCount >= 4;
        Field5Visible := Matrix_ColumnCount >= 5;
        Field6Visible := Matrix_ColumnCount >= 6;
        Field7Visible := Matrix_ColumnCount >= 7;
        Field8Visible := Matrix_ColumnCount >= 8;
        Field9Visible := Matrix_ColumnCount >= 9;
        Field10Visible := Matrix_ColumnCount >= 10;
        Field11Visible := Matrix_ColumnCount >= 11;
        Field12Visible := Matrix_ColumnCount >= 12;
        Field13Visible := Matrix_ColumnCount >= 13;
        Field14Visible := Matrix_ColumnCount >= 14;
        Field15Visible := Matrix_ColumnCount >= 15;
        Field16Visible := Matrix_ColumnCount >= 16;
        Field17Visible := Matrix_ColumnCount >= 17;
        Field18Visible := Matrix_ColumnCount >= 18;
        Field19Visible := Matrix_ColumnCount >= 19;
        Field20Visible := Matrix_ColumnCount >= 20;
        Field21Visible := Matrix_ColumnCount >= 21;
        Field22Visible := Matrix_ColumnCount >= 22;
        Field23Visible := Matrix_ColumnCount >= 23;
        Field24Visible := Matrix_ColumnCount >= 24;
        Field25Visible := Matrix_ColumnCount >= 25;
        Field26Visible := Matrix_ColumnCount >= 26;
        Field27Visible := Matrix_ColumnCount >= 27;
        Field28Visible := Matrix_ColumnCount >= 28;
        Field29Visible := Matrix_ColumnCount >= 29;
        Field30Visible := Matrix_ColumnCount >= 30;
        Field31Visible := Matrix_ColumnCount >= 31;
        Field32Visible := Matrix_ColumnCount >= 32;
    end;

    procedure NS_SetMatrixData(ColumnCaptions: array[32] of Text[1024]; var MatrixRec: RecordRef; CategoryFilter: Text; ColumnSetLength: Integer);
    var
        i: Integer;
    begin
        for i := 1 to ColumnSetLength do
            if ColumnCaptions[i] = '' then
                MATRIX_CaptionSet[i] := ' '
            else
                MATRIX_CaptionSet[i] := ColumnCaptions[i];

        PageCategoryFilter := CategoryFilter;
        Matrix_ColumnCount := ColumnSetLength;
        NS_ShowHideColumns();
    end;

    procedure NS_InitVariables(lMatrix_CaptionSet2: array[32] of Text[1024]; lJobNo: Code[20]; lJobTask: Code[20]);
    begin
        COPYARRAY(MATRIX_CaptionSet2, lMatrix_CaptionSet2, 1);
        JobNo := lJobNo;
        JobTaskNo := lJobTask;
    end;

    procedure NS_UpdateMatrixPage();
    begin
    end;

    procedure NS_GetPlanningLines(lJobNo: Code[20]; lJobTask: Code[20]; lLineType: Option " ",Resource,Item,"G/L Account",Text,"Resource (Group)");
    var
        JobPlanLine: Record "Job Planning Line";
    begin
        DELETEALL();
        JobPlanLine.RESET();
        JobPlanLine.SETRANGE("Job No.", lJobNo);
        JobPlanLine.SETRANGE("NS_Defaulted Entry", false);
        if lJobTask <> '' then
            JobPlanLine.SETRANGE("Job Task No.", lJobTask);
        if lLineType = lLineType::" " then
            JobPlanLine.SETRANGE(Type)
        else begin
            case lLineType of
                lLineType::Resource:
                    LineType := LineType::Resource;
                lLineType::Item:
                    LineType := LineType::Item;
                lLineType::"G/L Account":
                    LineType := LineType::"G/L Account";
                lLineType::Text:
                    LineType := LineType::Text;
                lLineType::"Resource (Group)":
                    LineType := LineType::"Resource (Group)";
            end;
            JobPlanLine.SETRANGE(Type, LineType);
        end;
        if JobPlanLine.FINDSET() then
            repeat
                Rec := JobPlanLine;
                if INSERT() then;
            until JobPlanLine.NEXT() = 0;
    end;

    local procedure NS_MatrixDataUpdate(lJobPlanLine: Record "Job Planning Line"; lDwgCode: Text[20]; MatrixQty: Decimal);
    var
        lJobSegEntry: Record "NS_Job Takeoff Segment Entry";
    begin
        with lJobPlanLine do begin
            lJobSegEntry.RESET();
            lJobSegEntry.SETRANGE("NS_Job No.", "Job No.");
            lJobSegEntry.SETRANGE("NS_Job Task No.", "Job Task No.");
            lJobSegEntry.SETRANGE(NS_Type, Type);
            lJobSegEntry.SETRANGE("NS_No.", "No.");
            lJobSegEntry.SETRANGE("NS_Segment Code", lDwgCode);
            if lJobSegEntry.FINDFIRST() then begin
                lJobSegEntry."NS_Segment Quantity" := MatrixQty;
                lJobSegEntry."NS_Date Entered" := CURRENTDATETIME;
                lJobSegEntry.NS_Certified := false;
                LineUpdated := true;
                lJobSegEntry.MODIFY();
            end else begin
                lJobSegEntry.INIT();
                lJobSegEntry."NS_Job No." := "Job No.";
                lJobSegEntry."NS_Job Task No." := "Job Task No.";
                lJobSegEntry.NS_Type := Type;
                lJobSegEntry."NS_No." := "No.";
                lJobSegEntry."NS_Variant Code" := "Variant Code";
                lJobSegEntry."NS_Line No." := "Line No.";
                lJobSegEntry."NS_Segment Code" := lDwgCode;
                lJobSegEntry."NS_Segment Quantity" := MatrixQty;
                lJobSegEntry."NS_Date Entered" := CURRENTDATETIME;
                lJobSegEntry.NS_Certified := false;
                LineUpdated := true;
                lJobSegEntry.INSERT();
            end;
        end;
    end;
}

