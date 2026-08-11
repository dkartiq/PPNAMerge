//PE-47.PS.1.0. Open Job Backlog Batch New 
/// <summary>
/// Report NS_Open Job Backlog Batch New (ID 14021295).
/// </summary>
Report 14021295 "NS_Open Job Backlog Batch New"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    // Caption = 'Update Open Job Backlog Batch New'; //PE-173.PS.1.0 03Oct2023 Commented
    Caption = 'Calculate Open Job Backlog'; //PE-173.PS.1.0 03Oct2023
    ProcessingOnly = true;
    Permissions = tabledata Job = rm;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", NS_Manager, "Bill-to Customer No.";//PE-173.PS.1.0 09Oct2023
            trigger OnAfterGetRecord()
            var
                InvoiceBilled: array[3] of Decimal;
                JobTask: Record "Job Task";
                InvoiceAmount: Decimal;
                BilledAmount: Decimal;
                Jobsubform: Page "Job Task Lines Subform";
                JobSetup: Record "Jobs Setup"; //PE-47.PS.2.0 26April2023
                SunlevaeBool: Boolean; //PE-47.PS.2.0 26April2023
                NSBilledAndDiffence: Decimal;//PE-173.PS.1.0 04Oct2023 
            begin
                Job."NS_Last Run Open Job Backlog" := WorkDate(); //PE-173.PS.1.0 09Oct2023 
                if (Job.Status = Job.Status::Completed) then begin
                    If (Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Closed) OR (Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running) then begin
                        Clear(InvoiceAmount);
                        Clear(BilledAmount);
                        JobTask.Reset();
                        JobTask.SetRange("Job No.", Job."No.");
                        JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                        if JobTask.FindSet() then
                            repeat
                                JobTask.CalcFields("Contract (Total Price)");
                                JobTask.CalcFields("Contract (Invoiced Price)");
                                BilledAmount += JobTask."Contract (Total Price)";
                                InvoiceAmount += JobTask."Contract (Invoiced Price)";
                            until JobTask.Next() = 0;
                        if (Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running) AND (InvoiceAmount - BilledAmount = 0) then
                            Job."NS_Open Job Backlog" := 0
                        else
                            if (Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Closed) AND (InvoiceAmount - BilledAmount >= 0) then
                                Job."NS_Open Job Backlog" := 0;
                        Job."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount;  //PRJCTPR-122.PS.1.0 14Jun2023
                        Job.Modify();
                    end;
                end
                else begin
                    //if (Job."NS_Sub-Level to Job No." = '') then
                    SunlevaeBool := true;
                    //PE-173.PS.1.0 04Oct2023  Start
                    if (Job.Status = Job.Status::Open) or (Job.Status = Job.Status::Planning) then begin
                        if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running then begin
                            NSBilledAndDiffence := 0;
                            Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                            NSBilledAndDiffence += Job."NS_Budgeted Price (LCY)";
                            Job.CalculateInvBilledExcluedSubandChagesOrder(Job, InvoiceBilled, true);
                            NSBilledAndDiffence -= InvoiceBilled[3];
                            // Job."NS_New Billable/Inv Dif" := 0 - NSBilledAndDiffence;//PRJCTPR-254.PS.1.0 10Jan2024 Commented Negative showing 
                            Job."NS_New Billable/Inv Dif" := NSBilledAndDiffence; //PRJCTPR-254.PS.1.0 10Jan2024 Added New for Positive
                            Job.Modify();
                        end;
                    end;
                    //PE-173.PS.1.0 04Oct2023  End 
                    JobSetup.Get();
                    if JobSetup."NS_Inclued SubJob & Change Ord" = false then begin
                        if (Job.Status = Job.Status::Open) or (Job.Status = Job.Status::Planning) then begin
                            if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running then begin
                                Job."NS_Open Job Backlog" := 0;
                                Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                Job."NS_Open Job Backlog" += Job."NS_Budgeted Price (LCY)";
                                //Job.CalculateInvoiceBilled(Job, InvoiceBilled, true); //PRJCTPR-187.PS.1.0 11Sep2023 Commented
                                Job.CalculateInvBilledExcluedSubandChagesOrder(Job, InvoiceBilled, true); //PRJCTPR-187.PS.1.0 11Sep2023
                                Job."NS_Open Job Backlog" -= InvoiceBilled[3];
                                //     Job."NS_New Billable/Inv Dif" := 0 - Job."NS_Open Job Backlog"; //PE-47.2.0.PS 20April2023 //PRJCTPR-122.PS.1.0 14Jun2023//PE-173.PS.1.0 04Oct2023
                                Job.Modify();
                            end;
                        end;
                    end else begin
                        if (Job.Status = Job.Status::Open) or (Job.Status = Job.Status::Planning) then begin
                            if Job."NS_Manager Job Status" = Job."NS_Manager Job Status"::Running then begin
                                Job."NS_Open Job Backlog" := 0;
                                Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                                Job."NS_Open Job Backlog" += Job."NS_Budgeted Price (LCY)";
                                Job."NS_Open Job Backlog" += Job.NS_SLsBudgetedPrice(Job);
                                Job.CalculateInvoiceBilled(Job, InvoiceBilled, true);
                                Job."NS_Open Job Backlog" -= InvoiceBilled[3];
                                //  Job."NS_New Billable/Inv Dif" := 0 - Job."NS_Open Job Backlog"; //PE-47.2.0.PS 20April2023 //PRJCTPR-122.PS.1.0 14Jun2023 //PE-173.PS.1.0 04Oct2023 
                                Job.Modify();
                            end;
                        end;

                    end;

                end;
            end;
        }
    }
    var
        myInt: Integer;
}
