report 14021495 NS_UpdateTempleteUnitCostPrice
{
    //PRJ-734 Create New Report
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Update Unit Price & Cost For Job Template';
    ProcessingOnly = true;
    Permissions = tabledata "Job Planning Line" = RIMD;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.") order(ascending) where("NS_Job Class" = FILTER(Template));
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Job No.", "Job Task No.", "Line No.") where(Type = filter(item | Resource));
                trigger OnAfterGetRecord()
                begin
                    if Type = Type::Item then begin
                        if Item.Get("No.") then;
                        if Item."Unit Cost" <> 0 then
                            Validate("Unit Cost", Item."Unit Cost");
                        if Item."Unit Price" <> 0 then
                            Validate("Unit Price", Item."Unit Price");
                        Modify();
                    end;
                    if Type = Type::Resource then begin
                        if Resource.Get("No.") then;
                        if Resource."Unit Cost" <> 0 then
                            Validate("Unit Cost", Resource."Unit Cost");
                        if Resource."Unit Price" <> 0 then
                            Validate("Unit Price", Resource."Unit Price");
                        Modify();
                    end;
                end;

            }
            trigger OnPreDataItem()
            begin
                if JobNo <> '' then
                    SetRange("No.", JobNo);
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
                    field("Job Class"; JobClass)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Class';
                        Editable = false;
                        ToolTip = 'Job Class';

                    }
                    field(JobNo; JobNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Job No.';
                        ToolTip = 'Job No.';
                        TableRelation = Job."No." where("NS_Job Class" = FILTER(Template));
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            JobClass := 'Template';
        end;

    }
    trigger OnPostReport()
    begin
        Message('Process Done....');
    end;


    var
        Item: Record Item;
        Resource: Record Resource;
        JobClass: Text;
        JobNo: Code[20];

}