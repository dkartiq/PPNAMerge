//PRJCTPR-147.NK.1.0 Start created new Page for change Request List
/// <summary>
/// Page NS_ChangeRequestList (ID 14021297).
/// </summary>
page 14021297 NS_ChangeRequestList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Job;
    Caption = 'Change Request List';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Change Request No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }//PE-193.PS.1.0 15Nov2023 Start
                 // field("NS_Sub-Level to Job No."; Rec."NS_Sub-Level to Job No.")
                 // {
                 //     ApplicationArea = All;
                 //     Caption = 'Sub-Level to Job No.';
                 // }

                field("NS_Change Request to Job No."; Rec."NS_Change Request to Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Change Request to Job No.';
                }
                //PE-193.PS.1.0 15Nov2023 End 
                field("NS_Manager Job Status"; Rec."NS_Manager Job Status")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Status';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(NS_MergeAll)
            {
                ApplicationArea = All;
                Visible = false;//PE-193.PS.2.0 08Dec2023
                Caption = 'Merge All';
                Promoted = false;
                Image = CreateDocument;
                ToolTip = 'Create change order for all change requests.';
                trigger OnAction();
                begin
                    NS_CreateChangeOrderFromCR(false);
                end;
            }
            action(NS_MergeSelected)
            {
                ApplicationArea = All;
                //Caption = 'Merge Selected';//PE-193.PS.2.0 08Dec2023 Commneted 
                Caption = 'Merge'; //PE-193.PS.2.0 08Dec2023
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateDocument;
                ToolTip = 'Create change order for the selected change requests.';
                trigger OnAction()
                var
                    NS_ChangeRequestMerge: Report NS_ChangeRequesttoChangeOrder; //PE-193.PS.2.0 20Nov2023
                    //PE-193.PS.3.0 05Jan2024 Start
                    JobSetupRec: Record "Jobs Setup";
                    jobRecord: Record Job;
                    jobRecord1: Record Job;
                    jobtaskrec1: Record "Job Task";
                    MasterTask: Record "Job Task";


                //PE-193.PS.3.0 05Jan2024 End 
                begin

                    //PE-193.PS.3.0 05Jan2024 Start
                    Clear(Tempjobtask);
                    JobSetupRec.Get();
                    if JobSetupRec."NS_Check Master Job No." = true then begin
                        If Rec."NS_Change Request to Job No." <> '' then begin
                            if jobRecord.Get(Rec."NS_Change Request to Job No.") then begin
                                jobtaskrec1.SetRange("Job No.", Rec."No.");
                                if jobtaskrec1.findset() then begin
                                    repeat
                                        Tempjobtask.Init();
                                        Tempjobtask."Job No." := Rec."NS_Change Request to Job No.";
                                        Tempjobtask.Validate("Job Task No.", jobtaskrec1."Job Task No.");
                                        Tempjobtask.Insert();
                                        CreateJobtaskChangeRequesttoMasterJob(Tempjobtask);
                                    until jobtaskrec1.Next = 0;
                                end;
                            end;
                        End;
                    end;
                    Commit();
                    //PE-193.PS.3.0 05Jan2024 End 

                    //PE-193.PS.2.0 20Nov2023 Start
                    NS_ChangeRequestMerge.NS_CreateChangeOrderFromCR(Rec."No.", Rec."NS_Change Request to Job No.", true);
                    NS_ChangeRequestMerge.RunModal();

                    // blocked today 23Nov2023 Start
                    //PE-193.PS.2.0 20Nov2023 Start
                    // if Confirm('Do you Wish to Mearge in Exiting Change Order?') then begin
                    // NS_ChangeRequestMerge.NS_CreateChangeOrderFromCR(Rec."No.", Rec."NS_Change Request to Job No.", true);
                    //     NS_ChangeRequestMerge.RunModal();
                    // end else
                    //     NS_CreateChangeOrderFromCR(true);
                    //PE-193.PS.2.0 20Nov2023  End
                    // blocked today 23Nov2023 End 
                    NS_ChangeOrderNo := NS_ChangeRequestMerge.NS_RetunValue();
                    NS_ChangeRequestfalse := NS_ChangeRequestMerge.NS_ClosePageRetrun();
                    if not NS_ChangeRequestfalse then begin
                        if NS_ChangeOrderNo <> '' then
                            NS_GetFromJobPlaningChangeRequestLine(NS_ChangeOrderNo, NS_ChangeRequestNo, Rec."NS_Change Request to Job No.", true)
                        else
                            NS_CreateChangeOrderFromCR(true);
                    end;
                    //PE-193.PS.2.0 20Nov2023  End
                end;
            }

        }
    }
    var

    /// <summary>
    /// NS_CreateChangeOrderFromCR.
    /// </summary>
    /// <param name="IsSelected">Boolean.</param>
    procedure NS_CreateChangeOrderFromCR(IsSelected: Boolean)
    var
        NS_lrJob: Record Job;
        NS_lcChangeOrderNo: Code[20];
        NS_lrOldJobTask: Record "Job Task";
        NS_lrNewJobTask: Record "Job Task";
        NS_lrOldJPL: Record "Job Planning Line";
        NS_lrNewJPL: Record "Job Planning Line";
        NS_LiLineNo: Integer;
        NS_JobPage: Page 88;
        NS_JobChangeOrderNo: Record Job;

    begin
        NS_LiLineNo := 10000;
        if IsSelected then
            CurrPage.SetSelectionFilter(NS_lrJob);
        //PE-193.PS.2.0 21Nov2023 Start
        NS_JobChangeOrderNo.Reset();
        NS_JobChangeOrderNo.SetRange("NS_Sub-Level to Job No.", Rec."NS_Change Request to Job No.");
        NS_JobChangeOrderNo.SetRange("NS_Job Class", NS_JobChangeOrderNo."NS_Job Class"::"Change Order");
        if NS_JobChangeOrderNo.Findlast() then
            NS_lcChangeOrderNo := NS_lrJob.NS_CreateCOHeader(NS_JobChangeOrderNo)
        else
            NS_lcChangeOrderNo := NS_lrJob.NS_CreateCOHeader(Rec);
        //PE-193.PS.2.0 21Nov2023 End
        if NS_lcChangeOrderNo <> '' then begin
            if not IsSelected then begin
                NS_lrJob.reset;
                NS_lrJob.setrange("NS_Sub-Level to Job No.", Rec."NS_Sub-Level to Job No.");
                NS_lrJob.SetRange("NS_Manager Job Status", NS_lrJob."NS_Manager Job Status"::Approval);
                NS_lrJob.SetRange("NS_Job Class", NS_lrJob."NS_Job Class"::"Change Request");
                if NS_lrJob.FindSet() then;
            end else
                if NS_lrJob.FindSet() then;
            repeat
                //Create Change Order Task Lines
                NS_lrOldJobTask.Reset();
                NS_lrOldJobTask.SetRange("Job No.", NS_lrJob."No.");
                if NS_lrOldJobTask.FindSet() then
                    repeat
                        if not NS_lrNewJobTask.Get(NS_lcChangeOrderNo, NS_lrOldJobTask."Job Task No.") then begin
                            NS_lrNewJobTask.Init();
                            NS_lrNewJobTask.TransferFields(NS_lrOldJobTask);
                            NS_lrNewJobTask."Job No." := NS_lcChangeOrderNo;
                            NS_lrNewJobTask.Insert();
                        end;
                    until NS_lrOldJobTask.Next() = 0;
                //Create Task Order Planning Lines
                NS_lrOldJPL.Reset();
                NS_lrOldJPL.SetRange("Job No.", NS_lrJob."No.");
                if NS_lrOldJPL.FindSet() then
                    repeat
                        NS_lrNewJPL.Init();
                        NS_lrNewJPL.TransferFields(NS_lrOldJPL);
                        NS_lrNewJPL."Job No." := NS_lcChangeOrderNo;
                        NS_lrNewJPL."Line No." := NS_LiLineNo;
                        if NS_lrNewJPL.Insert() then
                            NS_LiLineNo += 10000;
                    until NS_lrOldJPL.Next() = 0;
                NS_lrJob.Validate(Status, NS_lrJob.Status::Completed);  //PRJCTPR-147.PS.2.0 21Sep2023
                NS_lrJob."NS_Manager Job Status" := NS_lrJob."NS_Manager Job Status"::Completed;
                NS_lrJob."NS_Change Order No." := NS_lcChangeOrderNo; //PE-193.PS.3.0 21Dec2023
                NS_lrJob.Modify(false);
            until NS_lrJob.Next() = 0;
        end;
        IF CONFIRM('Job No.' + ' ' + NS_lcChangeOrderNo + ' ' + 'has been created. Go to new Job?') THEN BEGIN
            NS_lrJob.Reset();
            NS_lrJob.SetRange("No.", NS_lcChangeOrderNo);
            NS_JobPage.SETRECORD(NS_lrJob);
            Page.Run(Page::"Job Card", NS_lrJob);
        end;
    end;
    //PE-193.PS.2.0 20Nov2023 Start
    /// <summary>
    /// NS_GetFromSubcontractChangeRequestLine.
    /// </summary>
    /// <param name="NS_No">Code[20].</param>
    /// <param name="NSSubLeveltoJobNo">code[20].</param>
    /// <param name="ChangeReqNo">Code[20].</param>
    /// <param name="NSChangeOrdger">Boolean.</param>
    procedure NS_GetFromJobPlaningChangeRequestLine(NS_No: Code[20]; NSSubLeveltoJobNo: code[20]; ChangeReqNo: Code[20]; NSChangeOrdger: Boolean);
    var
        NS_JobPlaningLine: Record "Job Planning Line";
        NS_PassJobPlaningLine: Record "Job Planning Line";
        NS_JobPlaningLineNew: Record "Job Planning Line";
        LastLineNo: Integer;
        NS_count: Integer;
        NS_Jobs: Record Job;
        NS_lrNewJobTask: Record "Job Task";
        NS_lrOldJobTask: Record "Job Task";
    begin
        CurrPage.SetSelectionFilter(NS_Jobs);

        //NS_Jobs.reset;
        NS_Jobs.setrange("NS_Change Request to Job No.", Rec."NS_Change Request to Job No.");
        NS_Jobs.SetRange("NS_Manager Job Status", NS_Jobs."NS_Manager Job Status"::Approval);
        NS_Jobs.SetRange("NS_Job Class", NS_Jobs."NS_Job Class"::"Change Request");
        if NS_Jobs.FindSet() then begin
            repeat


                //PE-193.PS.2.0 12Dec2023 Start  

                NS_lrOldJobTask.Reset();
                NS_lrOldJobTask.SetRange("Job No.", NS_Jobs."No.");
                if NS_lrOldJobTask.FindSet() then
                    repeat
                        if not NS_lrNewJobTask.Get(NS_No, NS_lrOldJobTask."Job Task No.") then begin
                            NS_lrNewJobTask.Init();
                            NS_lrNewJobTask.TransferFields(NS_lrOldJobTask);
                            NS_lrNewJobTask."Job No." := NS_No;
                            NS_lrNewJobTask.Insert();
                        end;
                    until NS_lrOldJobTask.Next() = 0;

                //PE-193.PS.2.0 12Dec2023 End 

                NS_count := 0;
                LastLineNo := 0;
                NS_JobPlaningLineNew.RESET();
                NS_JobPlaningLineNew.SETRANGE("Job No.", NS_No);
                if NS_JobPlaningLineNew.FINDSet() then begin
                    NS_count := NS_JobPlaningLineNew.Count + 1;
                    LastLineNo := NS_count * 10000;
                end;
                NS_PassJobPlaningLine.Reset();
                NS_PassJobPlaningLine.SetRange("Job No.", NS_Jobs."No."); //PE-193.PS teamp Changes
                if NS_PassJobPlaningLine.findset() then begin
                    repeat
                        NS_JobPlaningLine.INIT();
                        NS_JobPlaningLine.TransferFields(NS_PassJobPlaningLine);
                        NS_JobPlaningLine."Job No." := NS_No;
                        NS_JobPlaningLine."NS_Ext Reference No." := NS_PassJobPlaningLine."NS_Ext Reference No.";
                        NS_JobPlaningLine."Line No." := LastLineNo;
                        if NS_JobPlaningLine.Insert() then
                            LastLineNo := LastLineNo + 10000;
                    until NS_PassJobPlaningLine.Next() = 0;
                    NS_Jobs.Validate(Status, NS_Jobs.Status::Completed);
                    NS_Jobs."NS_Manager Job Status" := NS_Jobs."NS_Manager Job Status"::Completed;
                    NS_Jobs."NS_Change Order No." := NS_No;
                    NS_Jobs.Modify(false);
                end;
            until NS_Jobs.Next = 0;
        end;

    end;
    //PE-193.PS.2.0 20Nov2023 End

    /// <summary>
    /// RetunValue.
    /// </summary>


    /// <summary>
    /// Setdefintion.
    /// </summary>
    /// <param name="OrderNo">Code[20].</param>
    /// <param name="NSChangeRequestNo">Code[20].</param>
    /// <param name="ClosePage">Boolean.</param>
    procedure Setdefintion(OrderNo: Code[20]; NSChangeRequestNo: Code[20]; ClosePage: Boolean)
    begin
        NS_ChangeOrderNo := OrderNo;
        NS_ChangeRequestNo := NSChangeRequestNo;
        NS_ChangeRequestfalse := ClosePage;

    end;

    // PE-193.PS.3.0 09Jan2024 Start

    /// <summary>
    /// CreateJobtaskChangeRequesttoMasterJob.
    /// </summary>
    /// <param name="tempJobtask">Record "Job Task".</param>
    procedure CreateJobtaskChangeRequesttoMasterJob(tempJobtask: Record "Job Task")
    var
        jobtaskrec: Record "Job Task";
    Begin

        jobtaskrec.Reset();
        jobtaskrec.SetRange("Job No.", tempJobtask."Job No.");
        jobtaskrec.SetRange("Job Task No.", Tempjobtask."Job Task No.");
        if not jobtaskrec.FindFirst() then begin
            IF not CONFIRM('The Task No. "%1" does not exist in the Master Job No. "%2". clicking on Yes will add this Job Task in the Master Job.\\Do you want to continue?', false,
Tempjobtask."Job Task No.", tempJobtask."Job No.") THEN begin
                Error('');
            end
            else begin
                JobtaskInt.Init();
                JobtaskInt."Job No." := Tempjobtask."Job No.";
                JobtaskInt.Validate("Job Task No.", Tempjobtask."Job Task No.");
                JobtaskInt.Insert();
            end;
        End;
    End;
    // PE-193.PS.3.0 09Jan2024  End 


    var
        NS_ChangeOrderNo: Code[20];
        NS_ChangeRequestNo: Code[20];
        NS_ChangeRequestfalse: Boolean;
        JobtaskInt: Record "Job Task";//PE-193.PS.3.0 09Jan2024
        Tempjobtask: Record "Job Task" temporary;//PE-193.PS.3.0 09Jan2024

}