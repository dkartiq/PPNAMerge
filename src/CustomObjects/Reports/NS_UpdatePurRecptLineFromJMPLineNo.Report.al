/// <summary>
/// Report MyReport (ID 14021436).
/// </summary>
//PRJ-1681.GK.1.0
//PRJ-1648.JS.1.0 24NOV2022 Put only NS_ initial in report name 
report 14021436 "NS_Update JMP Line No."
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update JMP Line No. in Purchase Recpt Line';
    Permissions = tabledata "Purch. Rcpt. Line" = RM;
    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            trigger OnPreDataItem()
            begin
                "Purchase Line".SetRange("Document Type", "Purchase Line"."Document Type"::Order);
                "Purchase Line".SetFilter("NS_JMP Line No.", '<>%1', 0);

            end;

            trigger OnAfterGetRecord()
            var
                PurchRcptLine: Record "Purch. Rcpt. Line";
            begin
                PurchRcptLine.Reset();
                PurchRcptLine.SetRange("Order No.", "Purchase Line"."Document No.");
                PurchRcptLine.SetRange("Order Line No.", "Purchase Line"."Line No.");
                if PurchRcptLine.FindFirst() then
                    repeat
                        PurchRcptLine."NS_JMP Line No." := "Purchase Line"."NS_JMP Line No.";
                        PurchRcptLine.Modify();
                    until PurchRcptLine.Next() = 0;
            end;


        }
    }

    requestpage
    {


    }



    var
        myInt: Integer;
}