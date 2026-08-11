//PRJ-689.DK.1.0 14Dec2022 start | Expend$Collapes
report 14021278 NSUpDateJobTskExpndAndCollapse
{
    Caption = 'UpDate JobTask ExpandAndCollapse';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Job Task"; "Job Task")
        {
            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                "Job Task".Reset();
                if "Job Task".FindSet() then begin
                    repeat
                        if "Job Task".NS_JobNo_JobTaskLine = '' then
                            "Job Task".NS_JobNo_JobTaskLine := "Job No." + ',' + "Job Task No.";
                        "Job Task".Modify();
                    until "Job Task".Next() = 0;
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
    //PRJ-689.DK.1.0 14Dec2022 End 
    var
        myInt: Integer;
}