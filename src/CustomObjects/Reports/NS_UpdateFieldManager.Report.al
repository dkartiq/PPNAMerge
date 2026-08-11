report 14021149 "NS_UpdateFieldManager"
{
    //PE-317 AT.1.0 25June2024 Start
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Field Manager';
    Permissions = tabledata job = rimd,
                  tabledata "Purchase Header" = rimd,
                  tabledata "NS_Daily Job Log" = rimd,
                  tabledata NS_TimeSheetLineCustom = rimd,
                  tabledata "NS_Progress Billing Header" = rimd,
                  tabledata NS_Subcontract = rimd,
                  tabledata "Purch. Cr. Memo Hdr." = rimd,
                  tabledata "Purch. Inv. Header" = rimd;
    trigger OnPreReport()
    var
    Begin
        UpdateFieldManager();
    End;

    trigger OnPostReport()
    begin
        Message('Done');
    end;

    procedure UpdateFieldManager()
    var
        //PE-211.AS start
        jbrec: Record job;
        PHorder: Record "Purchase Header";
        dailyjbrec: Record "NS_Daily Job Log";
        TSlineCustom: Record NS_TimeSheetLineCustom;
        PBhdr: Record "NS_Progress Billing Header";
        subcon: Record NS_Subcontract;
        PosCrMemo: Record "Purch. Cr. Memo Hdr.";
        PosInv: Record "Purch. Inv. Header";
    //PE-211.AS end
    begin

        //PE-211.AS start
        PHorder.Reset();
        PHorder.SetFilter("NS_Job No.", '<>%1', '');
        if PHorder.FindSet() then
            repeat
                if jbrec.get(PHorder."NS_Job No.") then begin
                    PHorder."NS_Field Manager" := jbrec."NS_Field Manager";
                    PHorder.Modify();
                end;
            until PHorder.Next() = 0;

        PosCrMemo.Reset();
        PosCrMemo.SetFilter("NS_Job No.", '<>%1', '');
        if PosCrMemo.FindSet() then
            repeat
                if jbrec.get(PosCrMemo."NS_Job No.") then begin
                    PosCrMemo."NS_Field Manager" := jbrec."NS_Field Manager";
                    PosCrMemo.Modify();
                end;
            until PosCrMemo.Next() = 0;

        PosInv.Reset();
        PosInv.SetFilter("NS_Job No.", '<>%1', '');
        if PosInv.FindSet() then
            repeat
                if jbrec.get(PosInv."NS_Job No.") then begin
                    PosInv."NS_Field Manager" := jbrec."NS_Field Manager";
                    PosInv.Modify();
                end;
            until PosInv.Next() = 0;

        dailyjbrec.Reset();
        dailyjbrec.SetFilter("NS_Job No.", '<>%1', '');
        if dailyjbrec.FindSet() then
            repeat
                if jbrec.get(dailyjbrec."NS_Job No.") then begin
                    dailyjbrec."NS_Field Manager" := jbrec."NS_Field Manager";
                    dailyjbrec.Modify();
                end;
            until dailyjbrec.Next() = 0;

        TSlineCustom.Reset();
        TSlineCustom.SetFilter("NS_Job No.", '<>%1', '');
        if TSlineCustom.FindSet() then
            repeat
                if jbrec.get(TSlineCustom."NS_Job No.") then begin
                    TSlineCustom."NS_Field Manager" := jbrec."NS_Field Manager";
                    TSlineCustom.Modify();
                end;
            until TSlineCustom.Next() = 0;

        PBhdr.Reset();
        PBhdr.SetFilter("NS_Job No.", '<>%1', '');
        if PBhdr.FindSet() then
            repeat
                if jbrec.get(PBhdr."NS_Job No.") then begin
                    PBhdr."NS_Field Manager" := jbrec."NS_Field Manager";
                    PBhdr.Modify();
                end;
            until PBhdr.Next() = 0;

        subcon.Reset();
        subcon.SetFilter("NS_Job No.", '<>%1', '');
        if subcon.FindSet() then
            repeat
                if jbrec.get(subcon."NS_Job No.") then begin
                    subcon."NS_Field Manager" := jbrec."NS_Field Manager";
                    subcon.Modify();
                end;
            until subcon.Next() = 0;
        //PE-211.AS end
    end;
    //PRJ-1237.JS.1.0 18APR2022 - Start
    //PE-317 AT.1.0 25June2024 End


}