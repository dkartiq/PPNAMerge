/// <summary>
/// Report NSPP_PunchListReport (ID 14021111).
/// </summary>
report 14021111 NS_PunchListReport
{
    //PE-288.JS.1.0 06MAY2024 | Created new report and RDL Layout
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Layouts\NSJobPunchList.rdl';
    Caption = 'Punch List Report';
    dataset
    {
        dataitem(NS_PunchListHeader; "NS_Punch List Header")
        {
            RequestFilterFields = "NS_PunchListNo.";
            column(NS_punchListNo;
            NS_PunchListHeader."NS_PunchListNo.")
            { }
            column(NS_Description; NS_PunchListHeader.NS_Description) { }
            column(NS_Job_No_; NS_PunchListHeader."NS_Job No.") { }
            //column(NS_Status; NSPP1_PunchListHeader.NS_Status) { }
            column(NS_User; NS_PunchListHeader.NS_User) { }
            column(NS_Job_Description; NS_PunchListHeader."NS_Job Description") { }
            column(NS_Name; NS_Name) { }
            column(NS_JobAddress1; NS_JobAddress1) { }
            column(NS_JobAddress2; NS_JobAddress2) { }
            column(NS_JobCity; NS_JobCity) { }
            column(NS_JobState; NS_JobState) { }
            column(NS_JobContact; NS_JobContact) { }
            column(NS_JobZipCode; NS_JobZipCode) { }
            column(NS_UserId; USERID) { }
            column(NS_CurrentDate; Today) { }
            dataitem(NS_PunchListSubForm; NS_PunchListDailyTasks)
            {
                DataItemLink = "NS_Punch List No." = FIELD("NS_PunchListNo.");
                column(NS_Job_NoLine; NS_PunchListSubForm."NS_Job No.") { }
                column(NS_JobDescription; NSPP1_JobDescription) { }
                column(NS_Job_Task_No_; "NS_Job Task No.") { }
                column(NS_Job_Task_Description_; "NS_Job Task Description.") { }
                column(NS_Priority; NS_Priority) { }
                column(NS_StartDate; NS_StartDate) { }
                column(NS_DueDate; NS_DueDate) { }
                column(NS_User_Task; "NS_User Task") { }
                column(NS_Assignee; NS_Assignee) { }
                column(NS_Camera_Image; NS_Camera_Image) { }
                column(NS_ClientApproval; NSClientConforReq) { }
                //column(NSClientConforReq; NSClientConforReq) { }
                column(NS_Close; NS_Close) { }
                column(NS_Closed_By; "NS_Closed By") { }
                column(NS_CloseDate; NS_CloseDate) { }
                column(NS_Punch_List_No_; "NS_Punch List No.") { }
                column(NS_Punch_List_Code; "NS_Punch List Code") { }
                column(NS_PunchListDescription; NS_PunchListDescription) { }
                column(NSPP_Content; NSPP_Content) { }
                column(NSPP_GetImage; NSPP_GetImage) { }
                column(NS_Comments; NS_Comments) { }
                column(NS_status; NS_status) { }
                trigger OnAfterGetRecord()
                var
                    NS_Job: Record Job;
                begin
                    NS_Job.Reset();
                    if NS_Job.get(NS_PunchListSubForm."NS_Job No.") then;
                    //NS_Job.SetRange("No.", NSPP1_PunchListSubForm."NS_Job No.");
                    //if NS_Job.FindFirst() then begin
                    // NS_JobAddress1 := NS_Job."NS_Job Address 1";
                    // NS_JobAddress2 := NS_Job."NS_Job Address 2";
                    // NS_JobCity := NS_Job."NS_Job City";
                    // NS_JobState := NS_Job."NS_Job County";
                    // NS_JobContact := NS_Job."Bill-to Contact";
                    // NS_JobZipCode := NS_Job."NS_Job Post Code";
                    //end;
                    if NS_PunchListSubForm.NS_ClientApproval = true then
                        NSClientConforReq := 'Yes'
                    else
                        NSClientConforReq := 'No';
                end;
            }
            trigger OnAfterGetRecord()
            var
                NSJobRec: Record Job;
            begin
                if NSJobRec.get(NS_PunchListHeader."NS_Job No.") then begin
                    NS_JobAddress1 := NSJobRec."NS_Job Address 1";
                    NS_JobAddress2 := NSJobRec."NS_Job Address 2";
                    NS_JobCity := NSJobRec."NS_Job City";
                    NS_JobState := NSJobRec."NS_Job County";
                    //NS_JobContact := NSJobRec."NS_Job Contact";
                    NS_JobZipCode := NSJobRec."NS_Job Post Code";
                end;
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    var

    begin
        if copImformation.Get() then;
        NS_Name := copImformation.Name;

    end;

    var
        myInt: Integer;
        NS_Name: Text[100];
        NS_JobAddress1: Text[100];
        NS_JobAddress2: Text[50];
        NS_JobCity: Text[50];
        NS_JobState: Text[30];
        NS_JobContact: Text[100];
        NS_JobZipCode: code[20];
        copImformation: Record "Company Information";
        NS_user: Text[50];
        NSClientConforReq: text[10];




}