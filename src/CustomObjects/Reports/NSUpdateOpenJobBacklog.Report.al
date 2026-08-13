/// <summary>
/// Report NS_UpdateOpenJobBacklogBatch (ID 14021487).
/// </summary>
//PRJ-1262.GK.1.0 03June2022
//PRJ-1710.GK.1.0 23Nov2022 |Added some code
report 14021487 "NS_UpdateOpenJobBacklogBatch"
{
    // UsageCategory = Administration; //PE-173.PS.1.0 03Oct2023 Commented
    //ApplicationArea = All; //PE-173.PS.1.0 03Oct2023 Commented 
    Caption = 'Update Open Job Backlog Batch';
    ProcessingOnly = true;
    Permissions = tabledata Job = rm;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = where(Status = filter(Open | Planning));
            trigger OnAfterGetRecord()
            var
                InvoiceBilled: array[3] of Decimal;
            begin
                if Job."NS_Sub-Level to Job No." = '' then
                    if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Handover then begin
                        Job."NS_Open Job Backlog" := 0;//PRJ-1262.GK.2.0 13June2022
                        Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                        Job."NS_Open Job Backlog" += Job."NS_Budgeted Price (LCY)";
                        //PRJ-1710.GK.1.0 start
                        //Job."NS_Open Job Backlog" += Job."SLsUsage(Price)"(Job);
                        Job."NS_Open Job Backlog" += Job.NS_SLsBudgetedPrice(Job);
                        //PRJ-1710.GK.1.0 end
                        Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                        Job."NS_Open Job Backlog" -= InvoiceBilled[3];
                        Job.Modify();
                    end;
            end;

        }
    }
    var
        myInt: Integer;
}