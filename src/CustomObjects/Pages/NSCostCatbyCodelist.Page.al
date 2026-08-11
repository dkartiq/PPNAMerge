page 14021369 "NS_CostCatbyCodelist"
{
    //PRJ-1052.AS.1.0 Created New Page for Cost categories with codes grouping
    //PE-75.RM.1.0 17May2023 | Added tootlips
    Caption = 'Cost Categories By Codes List';
    Editable = false;
    PageType = List;
    SourceTable = "NS_Cost Cat by Code";
    DataCaptionFields = "NS_Job No";
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NS_Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category Codes';  //PE-75.RM.1.0 17May2023
                }
                field("NS_Budget Cost"; Rec."NS_Budget Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Budgeted Cost on the basis of Category Codes used in the Job Planning lines'; //PE-75.RM.1.0 19May2023
                }
                field("NS_Actual Cost"; rec."NS_Actual Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'This value is calculated based on the sum of Total Cost from the Job Ledger Entries of Type "Usage"'; //PE-75.RM.1.0 17May2023
                }

                field("NS_Cost Variance"; rec."NS_Cost Variance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between Budget Cost and the Actual Cost.';  //PE-75.RM.1.0 17May2023
                }

                field("NS_Cost Vaiance%"; rec."NS_Cost Vaiance%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between Budget Cost and Actual Cost in percentage.';  //PE-75.RM.1.0 17May2023
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        Rec.CalcFields(Rec."NS_Budget Cost");
        Rec.CalcFields(Rec."NS_Actual Cost");


        Rec."NS_Cost Variance" := Rec."NS_Budget Cost" - Rec."NS_Actual Cost";

        if Rec."NS_Budget Cost" <> 0 then
            Rec."NS_Cost Vaiance%" := (Rec."NS_Cost Variance" / Rec."NS_Budget Cost") * 100;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        Rec.CalcFields(Rec."NS_Budget Cost");
        Rec.CalcFields(Rec."NS_Actual Cost");

        Rec."NS_Cost Variance" := Rec."NS_Budget Cost" - Rec."NS_Actual Cost";

        if Rec."NS_Budget Cost" <> 0 then
            Rec."NS_Cost Vaiance%" := (Rec."NS_Cost Variance" / Rec."NS_Budget Cost") * 100;
    end;

    trigger OnOpenPage()
    begin
    end;

}