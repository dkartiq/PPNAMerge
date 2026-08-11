page 14021433 NS_genericchartjob
{
    // version PPNA11.00

    Caption = 'Generic Charts';
    CardPageID = "Generic Chart Setup";
    PageType = List;
    SourceTable = Chart;
    SourceTableView = SORTING(ID);
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    ToolTip = 'Specifies the id.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name.';
                }
                field("BLOB.HASVALUE"; Rec.BLOB.HASVALUE)
                {
                    ApplicationArea = All;
                    Caption = 'Data';
                    ToolTip = 'Specifies the data.';
                }
                //PPNA16.0 Blocked Start
                // field("GenericChartMgt.GetDescription(Rec)"; GenericChartMgt.GetDescription(Rec))
                // {
                //     ApplicationArea = All;
                //     Caption = 'Description';
                //     MultiLine = true;
                //     ToolTip = 'Specifies the description.';
                // }
                //PPNA16.0 Blocked End
            }
        }
        area(factboxes)
        {
            systempart(Control13; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control14; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Import Chart")
                {
                    ApplicationArea = All;
                    Caption = 'Import Chart';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import the chart.';

                    trigger OnAction();
                    var
                        TempBlob: codeunit "Temp Blob";
                        FileMgt: Codeunit "File Management";
                        RecordRef: RecordRef;
                        ChartExists: Boolean;
                        InstreamLoc: InStream;
                    begin

                        ChartExists := BLOB.HasValue;
                        TempBlob.CreateInStream(InstreamLoc);
                        InstreamLoc.Read(BLOB);
                        if FileMgt.BLOBImport(TempBlob, '*.xml') = '' then
                            exit;

                        if ChartExists then
                            if not Confirm(Text001Lbl, false, TableCaption, ID) then
                                exit;

                        //BLOB := TempTempBlob.Blob; //PPNA16.0 Blocked
                        CurrPage.SAVERECORD;
                    end;
                }
                action("E&xport Chart")
                {
                    ApplicationArea = All;
                    Caption = 'E&xport Chart';
                    Ellipsis = true;
                    Image = Export;
                    ToolTip = 'Export the chart.';

                    trigger OnAction()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileMgt: Codeunit "File Management";
                        InstreamLoc: InStream;
                    begin
                        CALCFIELDS(BLOB);
                        IF BLOB.HASVALUE THEN BEGIN
                            TempTempBlob.CreateInStream(InstreamLoc);
                            InstreamLoc.Read(BLOB);


                            FileMgt.BLOBExport(TempTempBlob, '*.xml', TRUE);
                        END;
                    end;
                }
                action("Copy Chart")
                {
                    ApplicationArea = All;
                    Caption = 'Copy Chart';
                    Ellipsis = true;
                    Image = Copy;
                    ToolTip = 'Copy the chart.';

                    trigger OnAction();
                    var
                        CopyGenericChart: Page "Copy Generic Chart";
                    begin
                        if BLOB.HASVALUE then
                            CALCFIELDS(BLOB);
                        CopyGenericChart.SetSourceChart(Rec);
                        CopyGenericChart.RUNMODAL;
                    end;
                }
                action("Delete Chart")
                {
                    ApplicationArea = All;
                    Caption = 'Delete Chart';
                    Image = Delete;
                    ToolTip = 'Delete the chart.';

                    trigger OnAction();
                    begin
                        if BLOB.HASVALUE then
                            if CONFIRM(Text002Lbl, false, TABLECAPTION, ID) then begin
                                CALCFIELDS(BLOB);
                                CLEAR(BLOB);
                                CurrPage.SAVERECORD;
                            end;
                    end;
                }
            }
        }
    }

    var
        TempTempBlob: codeunit "Temp Blob";
        //FileMgt: Codeunit "File Management";
        GenericChartMgt: Codeunit "Generic Chart Mgt";
        Text001Lbl: Label 'Do you want to replace the existing definition for Chart 36-06?', comment = '%1=TABLECAPTION,%2=ID';
        Text002Lbl: Label 'Are you sure that you want to delete the definition for Chart 36-06?', comment = '%1=TABLECAPTION,%2=ID';





}
