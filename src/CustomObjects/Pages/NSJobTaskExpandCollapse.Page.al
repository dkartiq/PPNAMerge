page 14021271 NS_JobTaskExpandCollapse
{    //PE-1 .Dk.1.0 
    //PRJ-689.DK.1.0 15Dec2022 | Make New Page
    //PRJ-689.DK.1.0 15Dec2022 - start
    //Caption = 'JobTask Expand Collapse'; //PE-1 DK.1.0 03Jan2023 Block
    Caption = 'Job Task Summary'; //PE-1 DK.1.0 03Jan2023
    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Job Task";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    //SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            //PRJ-689.Dk.1.0 20Dec2022 -Start
            field(NS_SearchTxt; NS_SearchTxt)//PE-1 Dk.1.0 27Dec 2022
            {
                ApplicationArea = jobs;
                LookupPageID = "Job List";
                Caption = 'Job No.';
                ToolTip = 'Specifies the Worksheet Job No.';
                //PE-1 DK.1.0 27Dec2022 -Start
                trigger OnLookup(var Text1: Text): Boolean
                begin
                    Jobs."No." := NS_SearchTxt;
                    if PAGE.RUNMODAL(0, Jobs) = ACTION::LookupOK then
                        if Jobs."No." > '' then begin
                            if Jobs.GET(Jobs."No.") then
                                if jobs.Find() then;
                            Text1 := Jobs."No.";
                            EXIT(TRUE);
                        end;
                end;
                //PE-1 DK.1.0 27Dec2022 -End
                trigger OnValidate()
                begin
                    Rec.SetFilter("Job No.", NS_SearchTxt); //PE-1 DK.1.0 27Dec2022
                    CurrPage.Update();
                end;
            }

            //PRJ-689.Dk.1.0 20Dec2022 -End
            repeater(Control1)
            {

                IndentationColumn = NS_NameIndent;
                IndentationControls = Description;
                ShowAsTree = true;
                field("Job No."; Rec."Job No.")
                {
                    caption = 'job No';
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies the number of the related job.';
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies the number of the related job task.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.';
                }

                field("Job Task Type"; Rec."Job Task Type")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies an interval or a list of job task numbers.';
                }
                field("Schedule (Total Cost)"; Rec."Schedule (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.';
                }
                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies, in local currency, the total cost of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.';
                }
                field("Contract (Total Price)"; Rec."Contract (Total Price)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies, in the local currency, the total billable price for the job task during the time period in the Planning Date Filter field.';
                }
                field("Contract (Invoiced Price)"; Rec."Contract (Invoiced Price)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies, in the local currency, the total billable price for the job task that has been invoiced during the time period in the Posting Date Filter field.';
                }
                field("Remaining (Total Cost)"; Rec."Remaining (Total Cost)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies the remaining total cost (LCY) as the sum of costs from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.';
                }
                field("Remaining (Total Price)"; Rec."Remaining (Total Price)")
                {
                    ApplicationArea = Jobs;
                    Style = Strong;
                    StyleExpr = NS_Emphasize;
                    ToolTip = 'Specifies the remaining total price (LCY) as the sum of prices from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.';
                }
                field(NS_JobNo_JobTaskLine; Rec.NS_JobNo_JobTaskLine)
                {
                    Caption = 'Key(Sorting)';
                    ApplicationArea = Jobs;
                    Editable = false;
                    Style = AttentionAccent;//PRJ-1 DK.1.0 27Dec2022 
                }

            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        NS_Emphasize := (Rec."Job Task Type" = Rec."Job Task Type"::"Begin-Total");
        NS_NameIndent := 0;
        NS_FormatLine;
    end;

    trigger OnOpenPage()
    begin
        Clear(NS_SearchTxt);//PE-1 DK.1.0 27Dec2022
        NS_CopyjobTaskToTemp(false);
    end;

    var
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]

        NS_StyleIsStrong: Boolean;
        [InDataSet]

        NS_StyleIsStrongNew: Boolean;
        [InDataSet]
        NS_Emphasize: Boolean;
        [InDataSet]
        NS_NameIndent: Integer;

        [InDataSet]
        NS_EmphasizeNew: Boolean;
        "NS_Worksheet Job No.": Code[20];
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        jobs: Record Job;//PRJ-1 DK.1.0 27Dec2022 -Start
        NS_SearchTxt: Code[250];//PE-1 DK.1.0 27Dec2022
    //PRJ-689.Dk.1.0 20Dec2022 -End
    local procedure NS_FormatLine()
    begin
        NS_NameIndent := Rec.Indentation;
        NS_Emphasize := (Rec."Job Task Type" <> Rec."Job Task Type"::Posting);
    end;
    //PRJ-689.DK.1.0 15Dec2022 -End
    //PE-1 .Dk.1.0 9jan 2023 start
    local procedure NS_CopyjobTaskToTemp(OnlyRoot: Boolean)
    var
        NS_JobTask: Record "Job Task";
    begin
        NS_JobTask.Reset;
        NS_JobTask.SetFilter("Job Task Type", '<>%1', NS_JobTask."Job Task Type"::"End-Total");
        if NS_JobTask.Find('-') then
            repeat
                Rec := NS_JobTask;
                if NS_JobTask."Job Task Type" = NS_JobTask."Job Task Type"::"Begin-Total" then
                    Totaling := GetEndTotal(NS_JobTask);
                Modify();
            until NS_JobTask.Next() = 0;
        if FindFirst() then;
    end;
    //PE-1 .Dk.1.0 9jan 2023 start
    local procedure GetEndTotal(var NS_JobTask: Record "job Task"): Text[250]
    var
        NS_JobTask2: Record "Job Task";
    begin
        NS_JobTask2.SetFilter("Job No.", '>%1', NS_JobTask."Job No.");
        NS_JobTask2.SetRange(Indentation, NS_JobTask.Indentation);
        NS_JobTask2.SetRange("Job Task Type", NS_JobTask2."Job Task Type"::"End-Total");
        if NS_JobTask2.FindFirst() then
            exit(NS_JobTask2.Totaling);
        exit('');
    end;
    //PE-1 .Dk.1.0 9jan 2023 End

}