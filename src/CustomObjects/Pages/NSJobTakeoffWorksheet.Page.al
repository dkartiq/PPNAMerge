page 14021401 "NS_Job Takeoff Worksheet"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0 24June21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    Caption = 'Project Pro Job Take-off Worksheet';
    PageType = ListPlus;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group("NS_Job Worksheet")
            {
                Caption = 'Job Worksheet';
                field(JobNo; JobNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify Job No.';
                    Caption = 'Job No.';
                    Lookup = true;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobRec: Record Job;
                        JobList: Page "Job List";
                    begin
                        JobRec.SETRANGE("No.");
                        JobList.SETTABLEVIEW(JobRec);
                        JobList.LOOKUPMODE(true);
                        if JobList.RUNMODAL() = ACTION::LookupOK then begin
                            JobList.GETRECORD(JobRec);
                            JobNo := JobRec."No.";
                            JobTask := '';
                        end;
                        CurrPage.Matrix.PAGE.NS_InitVariables(Matrix_ColumnCaptions2, JobNo, JobTask);
                        CurrPage.Matrix.PAGE.NS_GetPlanningLines(JobNo, JobTask, 0);
                        CurrPage.UPDATE(false);
                    end;
                }
                field(ViewBy; ViewBy)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    OptionCaption = '" ,Resource,Item,G/L Account,Text,Resource (Group)"';
                    ToolTip = 'Specify View By';

                    trigger OnValidate();
                    begin
                        CurrPage.Matrix.PAGE.NS_InitVariables(Matrix_ColumnCaptions2, JobNo, JobTask);
                        CurrPage.Matrix.PAGE.NS_GetPlanningLines(JobNo, JobTask, ViewBy);
                        CurrPage.UPDATE(false);
                    end;
                }
                field(JobTask; JobTask)
                {
                    ApplicationArea = All;
                    Caption = 'Job Task No.';
                    Lookup = true;
                    ToolTip = 'Specify Job task ';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobTaskRec: Record "Job Task";
                        JobTaskList: Page 1002;
                    begin
                        JobTaskRec.SETRANGE("Job No.", JobNo);
                        JobTaskRec.SETRANGE("Job Task Type", JobTaskRec."Job Task Type"::Posting);
                        JobTaskList.SETTABLEVIEW(JobTaskRec);
                        JobTaskList.LOOKUPMODE(true);
                        if JobTaskList.RUNMODAL() = ACTION::LookupOK then begin
                            JobTaskList.GETRECORD(JobTaskRec);
                            JobTask := JobTaskRec."Job Task No.";
                        end else
                            JobTask := '';
                        CurrPage.Matrix.PAGE.NS_InitVariables(Matrix_ColumnCaptions2, JobNo, JobTask);
                        CurrPage.Matrix.PAGE.NS_GetPlanningLines(JobNo, JobTask, 0);
                        CurrPage.UPDATE(false);
                    end;

                    trigger OnValidate();
                    begin
                        CurrPage.Matrix.PAGE.NS_InitVariables(Matrix_ColumnCaptions2, JobNo, JobTask);
                        CurrPage.Matrix.PAGE.NS_GetPlanningLines(JobNo, JobTask, 0);
                        CurrPage.Matrix.PAGE.NS_UpdateMatrixPage();
                    end;
                }
                field(ColumnSet; ColumnSet)
                {
                    ApplicationArea = All;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specify Column Set';
                }
            }
            part(Matrix; "NS_Project Pro Job WkshtMatrix")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_Previous Set")
            {
                ApplicationArea = All;
                ToolTip = 'Specify Previous Set';
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = false;

                trigger OnAction();
                begin
                    NS_SetColumns(SetWanted::Previous);
                end;
            }
            action("NS_Previous Column")
            {
                ApplicationArea = All;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                //PromotedIsBig = true;
                ToolTip = 'PP_Previous Column';
                PromotedOnly = false;

                trigger OnAction();
                begin
                    NS_SetColumns(SetWanted::PreviousColumn);
                end;
            }
            action("NS_Next Column")
            {
                ApplicationArea = All;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'PP_Next column';

                trigger OnAction();
                begin
                    NS_SetColumns(SetWanted::NextColumn);
                end;
            }
            action("NS_Next Set")
            {
                ApplicationArea = All;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                ToolTip = 'PP_Next Set';
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;

                trigger OnAction();
                begin
                    NS_SetColumns(SetWanted::Next);
                end;
            }
            action("NS_Update Planning Lines")
            {
                ApplicationArea = All;
                Image = "Action";
                caption = 'Update Planning Lines';//PRJ-659.RS.1.0 24June21 New Added
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'PP_UPdate Planning Lines';

                trigger OnAction();
                var
                    lJobPlanLine: Record "Job Planning Line";
                begin
                    lJobPlanLine.InitVar(JobNo, ViewBy, JobTask);
                    lJobPlanLine.UpdateJobPlan(JobNo);
                    CurrPage.UPDATE(false);
                    CurrPage.CLOSE();
                end;
            }
            action("NS_Create Planning Lines")
            {
                ApplicationArea = All;
                Image = "Action";
                caption = 'Create Planning Lines';//PRJ-659.RS.1.0 24June21 New Added
                ToolTip = 'PP_Create Planning Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = false;

                trigger OnAction();
                var
                    lJobPlanLine: Record "Job Planning Line";
                begin
                    lJobPlanLine.CreatePlanfromTakeOff(JobNo, JobTask);
                    CurrPage.UPDATE();
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        JobSegment.SETRANGE("NS_Job No.", JobNo);
        RecRef.GETTABLE(JobSegment);
        NS_SetColumns(SetWanted::Initial);
        CurrPage.Matrix.PAGE.NS_InitVariables(Matrix_ColumnCaptions2, JobNo, JobTask);
        NS_GetPlanningLine();
    end;

    var
        //Job: Record Job;
        //JobPlanLine: Record "Job Planning Line";
        JobSegment: Record "NS_Job Takeoff Segments";


        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;


        JobNo: Code[20];
        JobTask: Code[20];
        ColumnSet: Text;
        ColumnSet2: Text;
        ViewBy: Option " ",Resource,Item,"G/L Account",Text,"Resource (Group)";
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        Matrix_ColumnCaptions: array[32] of Text[1024];
        Matrix_ColumnCaptions2: array[32] of Text[1024];
        PKFirstRecInCurrSet: Text;
        //CaptionRange: Text[1024];
        CurrSetLength: Integer;
        CategoryType: Text[30];


    procedure NS_SetMatrix();
    begin
        CurrPage.UPDATE(false);
    end;

    procedure NS_SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn);
    var
        q: Integer;
    begin
        MatrixMgt.GenerateMatrixData(RecRef, SetWanted, ARRAYLEN(Matrix_ColumnCaptions), 30, PKFirstRecInCurrSet, Matrix_ColumnCaptions, ColumnSet, CurrSetLength);
        MatrixMgt.GenerateMatrixData(RecRef, SetWanted, ARRAYLEN(Matrix_ColumnCaptions), 20, PKFirstRecInCurrSet, Matrix_ColumnCaptions2, ColumnSet2, CurrSetLength);
        for q := 1 to CurrSetLength do
            Matrix_ColumnCaptions[q] := Matrix_ColumnCaptions[q];

        CurrPage.Matrix.PAGE.NS_SetMatrixData(Matrix_ColumnCaptions, RecRef, CategoryType, CurrSetLength);
        CurrPage.UPDATE(false);
    end;

    procedure NS_GetPlanningLine();
    var
        q: Integer;
    begin
        q := 1;
        CurrPage.Matrix.PAGE.NS_GetPlanningLines(JobNo, JobTask, 0);
    end;

    procedure NS_InitPage(lJobNo: Code[20]; lJobTask: Code[20]);
    begin
        JobNo := lJobNo;
        JobTask := lJobTask;
    end;

    //SMPL Replaced "Job Task Lines" name reference to ID 1002
}

