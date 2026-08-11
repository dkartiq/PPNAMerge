report 14021434 NS_GetJobPlanningLines
{
    //PE-118.NC.1.0 03Aug2023 Create New Report
    ProcessingOnly = true;
    Caption = 'Get Job Planning Lines';
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) where(Number = filter(1));
            trigger OnPreDataItem()
            var
            begin
                JobPlanningList.LOOKUPMODE := true;
                if ChangeOrderNo <> '' then
                    JobPlanningLine.SETRANGE("Job No.", ChangeOrderNo)
                else
                    JobPlanningLine.SetRange("Job No.", NSJobNo);
                JobPlanningLine.SetFilter(NS_ProgessBillingNo, '%1', '');
                if ((FromDate <> 0D) and (ToDate <> 0D)) then
                    JobPlanningLine.SetFilter("Planning Date", '%1..%2', FromDate, ToDate);
                if NS_RevenueCategory <> '' then
                    JobPlanningLine.SetFilter("NS_Revenue Category", NS_RevenueCategory);
                JobPlanningLine.SETFILTER("Line Type", '%1|%2', JobPlanningLine."Line Type"::Billable,
                                              JobPlanningLine."Line Type"::"Both Budget and Billable");
                JobPlanningList.SETTABLEVIEW(JobPlanningLine);
                if ChangeOrderNo <> '' then
                    //PRJCTPR-191.DK.1.0 11Sep2023 START 
                    //JobPlanningList.NS_GetFromProgessBilling(ChangeOrderNo, true, ProgressBillingNo, RequisitionNo, VersionNo)
                    JobPlanningList.NS_GetFromProgessBillingCO(ChangeOrderNo, true, ProgressBillingNo, RequisitionNo, VersionNo, true)
                else
                    // JobPlanningList.NS_GetFromProgessBilling(ChangeOrderNo, true, ProgressBillingNo, RequisitionNo, VersionNo);
                    JobPlanningList.NS_GetFromProgessBillingCO(NSJobNo, true, ProgressBillingNo, RequisitionNo, VersionNo, false);
                //PRJCTPR-191.DK.1.0 11Sep2023 END 
                JobPlanningList.RUNMODAL;
                CLEAR(JobPlanningList);
            end;
        }
    }

    requestpage
    {
        Caption = 'Open Job Planning Line';

        layout
        {
            area(content)
            {
                field(NSJobNo; NSJobNo)
                {
                    Caption = 'Job No.';
                    ApplicationArea = all;
                    TableRelation = Job."No.";
                    Editable = false;
                }
                field(ChangeOrderNo; ChangeOrderNo)
                {
                    Caption = 'Change Order No.';
                    Lookup = true;
                    ApplicationArea = All;
                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobList: Page "Job List";
                        RecJob: Record Job;
                    begin
                        if NSJobNo <> '' then begin
                            RecJob.RESET;
                            RecJob.SETFILTER("NS_Sub-Level to Job No.", NSJobNo);
                            if PAGE.RunModal(PAGE::"Job List", RecJob) = ACTION::LookupOK then
                                ChangeOrderNo := RecJob."No.";
                        end;
                    end;
                }
                group("Filters")
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = all;
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'To Date';
                    }
                    field("NS_Revenue Category"; "NS_RevenueCategory")
                    {
                        ApplicationArea = all;
                        Caption = 'Revenue Category';
                        TableRelation = "NS_Job Revenue Category";
                    }
                }
            }
        }
    }
    procedure NS_GetOpenProgessBilling(NSJobNo1: Code[30]; PassGetProgBilling: Boolean; ProgressBillingNo1: Code[20]; RequisitionNo1: Integer; VersionNo1: Integer);
    begin
        NSJobNo := NSJobNo1;
        CalledFromProgBilling := PassGetProgBilling;
        ProgressBillingNo := ProgressBillingNo1;
        RequisitionNo := RequisitionNo1;
        VersionNo := VersionNo1;
    end;

    var
        JobPlanningList: Page "Job Planning Lines";
        JobPlanningLine: Record "Job Planning Line";
        NSJobNo: Code[30];
        CalledFromProgBilling: Boolean;
        ProgressBillingNo: Code[20];
        ChangeOrderNo: Code[20];
        RequisitionNo: Integer;
        VersionNo: Integer;
        NS_RevenueCategory: Code[20];
        NS_PlanningDate: Date;
        FromDate: date;
        ToDate: Date;
}