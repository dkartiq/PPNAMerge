report 14021293 "NS_UpdateJLEforBurdenDocument"
{
    //CTSI-254.MS.1.0 

    Permissions = TableData "Job Ledger Entry" = rimd, Tabledata "No. Series Line" = rimd;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Update JLE for Burden Document';
    dataset
    {

        dataitem("Job Ledger Entry";
        "Job Ledger Entry")
        {
            DataItemTableView = sorting("Job No.") ORDER(Ascending);//WHERE("Burden Amount" = FILTER(<> 0), "Burden Amount Posted to G/L" = CONST(0));
            RequestFilterFields = "Job No.", "Posting Date", "NS_Burden Posting Document No.";

            trigger OnAfterGetRecord();
            begin
                "NS_Burden Posting Document No." := '';
                "NS_Burden Amount Posted to G/L" := 0;
                Modify();

            end;

            trigger OnPreDataItem();
            begin

            end;

            trigger OnPostDataItem();
            begin

            end;
        }

    }



    var




    trigger OnPreReport();
    begin
        Message('JLE has been updated.');
    end;




}


