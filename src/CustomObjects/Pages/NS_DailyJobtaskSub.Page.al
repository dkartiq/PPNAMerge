/// <summary>
/// Page NS_Daily Job task Subfrom (ID 14021462).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New page create
/// //PE-168.HS.1.0 10Nov2023| Removed Doc job no. and Entry Date field 
page 14021462 "NS_Daily Job task Subfrom"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    Caption = 'Work Performed Today';
    SourceTable = "NS_Daily JOb Log Sub.";
    SourceTableView = sorting("Document Type", "Documnet No.", "Line No.") WHERE("Document Type" = FILTER("Job Task"));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_Job Tasks"; Rec."NS_Job Tasks")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task No.';
                    trigger OnValidate()
                    var
                        NS_JobTaskNo: Record "Job Task";
                        NS_JobPlaningLine: Record "Job Planning Line"; //PE-253.PS.1.0 16Feb2024
                        NS_JobLedgerEntry: Record "Job Ledger Entry";//PE-253.PS.1.0 16Feb2024
                    begin
                        if Rec."NS_Job Tasks" <> '' then begin
                            NS_JobTaskNo.SetRange("Job No.", Rec."Documnet Job No.");
                            NS_JobTaskNo.SetRange("Job Task No.", Rec."NS_Job Tasks");
                            if NS_JobTaskNo.FindFirst() then begin
                                Rec."Task Description" := NS_JobTaskNo.Description;
                                //PE-253.PS.1.0 16Feb2024 Start
                                Rec.NS_UM := NS_JobTaskNo."NS_Work Unit of Measure";
                                // Rec.NS_WorkUnitToday := NS_JobTaskNo."NS_Work Units";
                                Rec.NS_WorkUnitBudgeted := 0;
                                NS_JobPlaningLine.Reset();
                                NS_JobPlaningLine.SetRange("Job No.", Rec."Documnet Job No.");
                                NS_JobPlaningLine.SetRange("Job Task No.", Rec."NS_Job Tasks");
                                NS_JobPlaningLine.SetFilter("Line Type", '%1|%2', NS_JobPlaningLine."Line Type"::Budget, NS_JobPlaningLine."Line Type"::"Both Budget and Billable");
                                if NS_JobPlaningLine.FindSet() then begin
                                    repeat
                                        Rec.NS_WorkUnitBudgeted += NS_JobPlaningLine."NS_Work Units";
                                    until NS_JobPlaningLine.Next = 0;
                                end;
                            end;
                        end;
                        // if Rec.NS_PostedJobJournal = true then begin
                        Rec.NS_WorkUnitPrevious := 0;

                        NS_JobLedgerEntry.Reset();
                        NS_JobLedgerEntry.SetRange("Job No.", Rec."Documnet Job No.");
                        NS_JobLedgerEntry.SetRange("Job Task No.", Rec."NS_Job Tasks");
                        NS_JobLedgerEntry.SetRange("Entry Type", NS_JobLedgerEntry."Entry Type"::Usage);
                        NS_JobLedgerEntry.SetRange(Type, NS_JobLedgerEntry.Type::Resource);
                        if NS_JobLedgerEntry.FindSet() then begin
                            repeat
                                Rec.NS_WorkUnitPrevious += NS_JobLedgerEntry."NS_Work Units";
                            until NS_JobLedgerEntry.Next = 0;

                        end;
                        //PE-253.PS.1.0 16Feb2024 End 


                    end;
                }
                field("Task Description"; Rec."Task Description")
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';
                }
                //PE-253.PS.1.0 14Feb2024 Start
                field(NS_WorkUnitBudgeted; Rec.NS_WorkUnitBudgeted)
                {
                    ApplicationArea = All;
                    Caption = 'Work Units Budgeted';
                    Editable = false;
                }
                field(NS_UM; Rec.NS_UM)
                {
                    ApplicationArea = All;
                    Caption = 'UOM';
                }
                field(NS_WorkUnitPrevious; Rec.NS_WorkUnitPrevious)
                {
                    ApplicationArea = All;
                    Caption = 'Work Units Previous';
                    Editable = false;
                }
                field(NS_WorkUnitToday; Rec.NS_WorkUnitToday)
                {
                    ApplicationArea = All;
                    Caption = 'Work Units Completed';
                    Editable = NS_WorkUnitCompltedEdite;//PE-253.PS.2.0 22Feb2024
                }
                field(NS_PostedJobJournal; Rec.NS_PostedJobJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Job Journal Posted';
                    ToolTip = 'Specifies Job Journal has been Posted';
                    Editable = false;
                }
                //PE-253.PS.1.0 14Feb2024 End 
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';  //PE-168.HS.1.0 16Nov2023
                }
                field("Remark 2"; Rec."Remark 2")
                {
                    ApplicationArea = All;
                    Caption = 'Comment 2';  //PE-168.HS.1.0 16Nov2023
                }
            }
        }
    }
    //PE-253.PS.2.0 22Feb2024 Start
    var
        NS_WorkUnitCompltedEdite: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        NS_WorkUnitCompltedEdite := true;
        if Rec.NS_PostedJobJournal = true then
            NS_WorkUnitCompltedEdite := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        NS_WorkUnitCompltedEdite := true;
        if Rec.NS_PostedJobJournal = true then
            NS_WorkUnitCompltedEdite := false;
    end;
    //PE-253.PS.2.0 22Feb2024 End 
}