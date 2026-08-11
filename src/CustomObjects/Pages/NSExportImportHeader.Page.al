page 14021429 "NS_Export / Import Header"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0 1July21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    SourceTable = "NS_Export/Import Excel Header";
    Caption = 'Export / Import Header';//PRJ-659.RS.1.0 1July21 Caption Added

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    Caption = 'First Tab Name';
                    ToolTip = 'First Tab Name';


                }
                field("Table No."; Rec."NS_Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Table No.';
                }
                field("Table Name"; Rec."NS_Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Table Name';
                }
                field("File Name"; Rec."NS_File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the File Name';

                    trigger OnAssistEdit();
                    begin
                        "NS_File Name" := EIEHandler.NS_OpenFile('', '', 2, '', 0);
                    end;
                }
                field("First DataRow"; Rec."NS_First DataRow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the First DataRow';
                }
                field(ImportOption; Rec.NS_ImportOption)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ImportOption';
                }
                field(AllowDuplicates; Rec.NS_AllowDuplicates)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the AllowDuplicates';
                }
                field(ValidateInsertModify; Rec.NS_ValidateInsertModify)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ValidateInsertModify';
                }
                field(JobNo; JobNo)
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';

                    ToolTip = 'Job No.';
                    Editable = false;
                    Visible = ShowJob;
                }
            }
            part(Lines; "NS_Export /Import Lines")
            {
                ApplicationArea = All;
                SubPageLink = NS_Code = FIELD(NS_Code),
                              "NS_Table no." = FIELD("NS_Table No."),
                              "NS_Job No." = FIELD("NS_Job No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1100773012)
            {
                separator(Separator1100773014)
                {
                }
                action(NS_AutoCollumn)
                {
                    ApplicationArea = All;
                    Caption = '&Auto Collumn';

                    ToolTip = '&Auto Collumn';

                    trigger OnAction();
                    begin
                        CurrPage.Lines.PAGE.NS_AutomapColumn;
                    end;
                }
                action(InsertFieldsfromtable)
                {
                    ApplicationArea = All;
                    Caption = 'I&nsert fields from table';

                    trigger OnAction();
                    begin
                        CLEAR(EIEHandler);
                        EIEHandler.NS_InsertAllFields(Rec, false);
                    end;
                }
                separator(Separator1100773017)
                {
                }
                action(NS_Export)
                {
                    ApplicationArea = All;
                    Caption = 'E&xport';

                    trigger OnAction();
                    begin
                        if CONFIRM(Text002) then begin
                            CLEAR(EIEHandler);
                            EIEHandler.NS_ExportData(Rec, '')
                        end;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = All;
                    Caption = '&Import';

                    trigger OnAction();
                    begin
                        if CONFIRM(Text002) then begin
                            CLEAR(EIEHandler);
                            EIEHandler.NS_ImportDataSingleSheet(Rec, '', false, false, JobNo);
                        end;
                    end;
                }
                separator(Separator1100773022)
                {
                }
                action(NS_List)
                {
                    ApplicationArea = All;
                    ToolTip = 'List';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "NS_Excel Import List";
                    RunPageLink = "NS_Job No." = FIELD("NS_Job No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SETRANGE("NS_Job No.");
        SETRANGE(NS_Code);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "NS_First DataRow" := 2;
    end;

    var
        EIEHandler: Codeunit "NS_ExportImport Excel Handle";
        Text001: Label 'Changing the table no. will delete all the mappings!\Do you want to continue?';
        Text002: Label 'Please close all workbooks before import/export. \Do you wish to continue';
        JobNo: Code[20];
        ShowJob: Boolean;
        TableNo: Integer;
        FileName: Text;
        ImpOpt: Option "Replace entries","Add entries";
        AllowDups: Boolean;
        ValidateIM: Boolean;

    procedure NS_SetJobNo(lJobNo: Code[20]);
    begin
        Rec."NS_Job No." := lJobNo;
    end;

    procedure NS_InitVar(_FileName: Text; _TableNo: Integer; _ImportOption: Option "Replace entries","Add entries"; _AllowDuplicates: Boolean; _ValidateIM: Boolean; _ShowJob: Boolean);
    begin
        TableNo := _TableNo;
        FileName := _FileName;
        ImpOpt := _ImportOption;
        AllowDups := _AllowDuplicates;
        ValidateIM := _ValidateIM;
        ShowJob := _ShowJob;
    end;
}

