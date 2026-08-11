
//PE-23 Dk.1.0.3Jan2023 | Create New Page Commitement List Page Start
page 14021295 "NS_CommitementListPage"
{

    Caption = 'Commitement List';
    PageType = List;
    ApplicationArea = jobs;
    UsageCategory = Lists;
    SourceTable = NS_Subcontract;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_No."; Rec."NS_No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;

                }
                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field("NS_Subcon Class"; Rec."NS_Subcon Class")
                {
                    Caption = 'Subcon Class';
                    ApplicationArea = all;
                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    Caption = 'Job No';
                    ApplicationArea = all;
                }
                field("Job Description"; Job.Description)
                {
                    Caption = 'Job Description';
                    ApplicationArea = all;
                }
                field("NS_Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    Caption = 'Buy-from Name';
                    ApplicationArea = all;

                }
                field("NS_Starting Date"; Rec."NS_Starting Date")
                {
                    Caption = 'Starting Date';
                    ApplicationArea = all;
                }
                field("NS_Ending Date"; Rec."NS_Ending Date")
                {
                    Caption = 'Ending Date';
                    ApplicationArea = all;
                }
                field("NS_Completion Date"; Rec."NS_Completion Date")
                {
                    Caption = 'Completion Date';
                    ApplicationArea = all;
                }
                field(NS_Status; Rec.NS_Status)
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field("NS_Person Responsible"; Rec."NS_Person Responsible")
                {
                    Caption = 'Person Responsible';
                    ApplicationArea = all;
                }
                field("NS_Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    Caption = 'Budgeted Cost (LCY)';
                    ApplicationArea = all;
                }
                field("NS_Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
                {
                    Caption = 'Usage (Cost) (LCY)';
                    ApplicationArea = all;
                }
                field("NS_SubcontractUsageCost(LCY)"; Rec."NS_SubcontractUsageCost(LCY)")
                {
                    Caption = 'Subcontract Usage Cost (LCY)';
                    ApplicationArea = all;
                }
                field("NS_Sub-LeveltoSubcontractNo."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    Caption = 'Sub-Level to Subcontract No.';
                    ApplicationArea = all;

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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        Job: Record Job;
}
//PE-23 Dk.1.0.3Jan2023 end