report 14021480 NS_DeleteJobPlanLine
{
    // PRJCTPR-191.HS.1.0 18Oct2023 Start
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    // Caption = 'Delete Job Plan Line'; //PRJCTPR-191.HS.1.0 7Nov2023 Remove this line from code
    Caption = 'Remove Progress Billing No.';
    Permissions = tabledata "Job Planning Line" = rimd;
    UseRequestPage = true;

    dataset
    {
        dataitem("Job PlanningLine"; "Job Planning Line")
        {
            RequestFilterFields = "Job No.", "Job Task No.", "Line No.";
            trigger OnAfterGetRecord()
            var
                NS_Jpl: Record "Job Planning Line";
            begin
                // NS_Jpl.SetRange("Job No.", "Job No.");
                // NS_Jpl.SetRange("Job Task No.", "Job Task No.");
                if "Line No." <> 0 then begin
                    NS_ProgessBillingNo := '';
                    "NS_Requisition No." := 0;
                    "NS_Version No." := 0;
                    Modify();
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
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    var
        NS_User: Record "User Setup";
        DelProgLine: Label 'Are you certain, you want to delete the progress billing reference from planning lines?';
    begin
        if NS_User.Get(UserId) then
            if NS_User.NS_AllowDelPrgBilllines = false then
                Error('You do not have permission to run this batch. To run the batch, you must have permission on User Setup for "Access to Remove Progress Billing No."')
            else
                if not Confirm(DelProgLine, false) then
                    CurrReport.Quit();
    end;
    // PRJCTPR-191.HS.1.0 18Oct2023 End
}