report 14021396 NS_ActInvdLessActCostMargin
{
    //PE-149.RM.1.0 28Aug2023 | Created a  New Processing Only Report
    UsageCategory = Administration;
    UseRequestPage = false;
    ApplicationArea = All;
    Caption = 'Actual Invoiced Less Actual Cost (Margin)';
    ProcessingOnly = true;
    Permissions = tabledata "Job Planning Line" = RIMD;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.") order(ascending);
            trigger OnAfterGetRecord()
            begin
                Job.CalcFields("NS_Invoiced Price (LCY)", "NS_Usage (Cost) (LCY)");
                Job.NS_ActInvdLessActCost := Job."NS_Invoiced Price (LCY)" - Job."NS_Usage (Cost) (LCY)";
                //PE-193.PS.1.0 16Oct2023 Start
                if (Job.NS_ActInvdLessActCost <> 0) and (Job."NS_Invoiced Price (LCY)" <> 0) then
                    Job."NS_Margin %" := (Job.NS_ActInvdLessActCost / Job."NS_Invoiced Price (LCY)") * 100;
                //PE-193.PS.1.0 16Oct2023 End
                Job.Modify();
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }


    }

    trigger OnPostReport()
    begin
        Message('Process Done!');
    end;



}