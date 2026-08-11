
report 14021323 "NS_User Task Category Update"
{
    //PRJCTPR-270.HS.1.0 8Feb2024 | Created New Batch Report
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    ProcessingOnly = true;
    Caption = 'User Task Category Update';
    Permissions = tabledata NSNumberFilter = rm;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            trigger OnAfterGetRecord()
            var
                NS_numfilt: Record NSNumberFilter;
                NS_numfilt1: Record NSNumberFilter;
            begin
                NS_numfilt1.Reset();
                NS_numfilt1.SetCurrentKey(Type, "No.", "Document No.");
                NS_numfilt1.SetRange(Type, NS_numfilt1.Type::"NS_User Task Category");
                NS_numfilt1.SetFilter("Document No.", '%1', '');
                NS_numfilt1.SetFilter("No.", '<>%1', '');
                if NS_numfilt1.FindSet() then
                    repeat
                        if NS_numfilt.get(NS_numfilt1.Type, NS_numfilt1."Document No.", NS_numfilt1."No.") then
                            NS_numfilt1.Rename(NS_numfilt1.Type, 'USER', NS_numfilt1."No.");
                    until NS_numfilt1.Next() = 0;
            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

            end;
        }
    }
    trigger OnPostReport()
    begin
        Message('Updated');
    end;

}