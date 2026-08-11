report 14021378 "NS_Payroll InterfClearExpStat"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interface Clear Export Status';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Interface Jnl Line"; "NS_Payroll Interface Jnl Line")
        {
            DataItemTableView = SORTING("NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                "Payroll Interface Jnl Line"."NS_Export Status" := 0;
                "Payroll Interface Jnl Line"."NS_Export Status Date/Time" := ClearDateTime;
                "Payroll Interface Jnl Line".MODIFY();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Instruction; Text001)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ClearDateTime: DateTime;
        Text001: Label 'Press OK to clear the Export Status.';
}

