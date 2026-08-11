report 14021432 NS_JobrecNotInv1
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJobReceivedNotInv1.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Purchase Jobs - Received Not Invoiced';
    //PRJ-493.AM.1.0 New report & Layout

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            column(Job_No_; PurRecptLineTemp."Job No.") { }
            column(SeparatorLbl; SeparatorLbl) { }
            column(JobNo; JobNo) { }
            column(Document_No_; PurRecptLineTemp."Document No.") { }
            column(No_; PurRecptLineTemp."No.") { }
            column(Description; PurRecptLineTemp.Description) { }
            column(Job_Cost_Category; PurRecptLineTemp."NS_Job Cost Category") { }
            column(Quantity; PurRecptLineTemp.Quantity) { }
            column(Unit_Cost; PurRecptLineTemp."Unit Cost") { }
            column(Jobdescription; Jobdescription) { }
            column(PurRecptLineTempOrderNo; PurRecptLineTemp."Order No.") { }
            column(BillToName; BillToName) { }
            column(PurinvLineQty; PurinvLineQty) { }
            column(CheckQty; CheckQty) { }
            column(TotalAmt; (PurRecptLineTemp."Unit Cost" * CheckQty)) { }
            column(CostCatdesc; CostCatdesc) { }
            column(JobNum; JobNum) { }
            column(StartDate; StartDate) { }
            column(Enddate; Enddate) { }

            trigger OnPreDataItem()
            var
            begin
                if StartDate = 0D then
                    PurRecptLineRec.Reset();
                if ((StartDate <> 0D) and (EndDate <> 0D)) then
                    PurRecptLineRec.SetRange("Posting Date", StartDate, Enddate);

                PurRecptLineRec.SetRange(Type, PurRecptLineRec.Type::Item);
                PurRecptLineRec.SetFilter(Quantity, '<>%1', 0);// New changes 06-11-2021 .MS
                PurRecptLineRec.SetFilter("Job No.", '<>%1', '');
                if JobNum <> '' then
                    PurRecptLineRec.SetFilter("Job No.", JobNum);

                if PurRecptLineRec.FindSet() then
                    repeat
                        PurRecptLineTemp.Init();
                        PurRecptLineTemp := PurRecptLineRec;
                        PurRecptLineTemp.Insert();

                    until PurRecptLineRec.Next() = 0;

                // PurRecptLineTemp.SetCurrentKey("No.");

                PurRecptLineTemp.Reset();
                if ((StartDate <> 0D) and (EndDate <> 0D)) then
                    PurRecptLineTemp.SetRange("Posting Date", StartDate, Enddate);
                PurRecptLineTemp.SetRange(Type, PurRecptLineTemp.Type::Item);
                PurRecptLineTemp.SetFilter(Quantity, '<>%1', 0); // New changes 06-11-2021 .MS
                if JobNum <> '' then
                    PurRecptLineTemp.SetFilter("Job No.", JobNum);

                CountReceiptLine := PurRecptLineTemp.Count;
                RowCount := 0;
                SetRange(Number, 1, CountReceiptLine);

            end;

            trigger OnAfterGetRecord()
            var
            begin
                PurRecptLineTemp.SetCurrentKey("Job No.", "Order No.", "No.");

                RowCount += 1;
                if RowCount = 1 then
                    PurRecptLineTemp.FINDFIRST
                else
                    PurRecptLineTemp.NEXT;

                if Job.Get(PurRecptLineTemp."Job No.") then begin
                    Jobdescription := Job.Description;
                    BillToName := Job."Bill-to Name"
                end else begin
                    Jobdescription := '';
                    BillToName := '';
                end;

                // Clear(PurinvLineQty);
                PurinvLineQty := 0;
                if itemvar <> PurRecptLineTemp."No." then begin
                    Checkbool := false;
                    CheckQty := 0;
                end;
                if JobNoVar <> PurRecptLineTemp."Job No." then begin
                    Itemvar := '';
                    Checkbool := false;
                    CheckQty := 0;
                end;
                if OrderNo <> PurRecptLineTemp."Order No." then begin
                    Itemvar := '';
                    Checkbool := false;
                    CheckQty := 0;
                end;
                if (NOT Checkbool) And (CheckQty >= 0) AND (itemvar <> PurRecptLineTemp."No.") then begin
                    PurInvLineRec.Reset();
                    PurInvLineRec.SetRange("Job No.", PurRecptLineTemp."Job No.");
                    PurInvLineRec.SetRange("No.", PurRecptLineTemp."No.");
                    if ((StartDate <> 0D) and (EndDate <> 0D)) then
                        PurInvLineRec.SetRange("Posting Date", StartDate, Enddate);
                    if JobTaskFilter <> '' then
                        PurInvLineRec.SETFILTER("Job Task No.", JobTaskFilter);
                    PurInvLineRec.SetRange("Order No.", PurRecptLineTemp."Order No.");
                    PurInvLineRec.SetRange("NS_Job Cost Category", PurRecptLineTemp."NS_Job Cost Category");
                    PurInvLineRec.SetRange(Type, PurInvLineRec.Type::Item);
                    PurInvLineRec.SetFilter(Quantity, '>%1', 0);
                    if PurInvLineRec.FindSet() then
                        repeat
                            PurinvLineQty += PurInvLineRec.Quantity;
                        until PurInvLineRec.Next() = 0;
                    CheckQty := 0;
                    ItemVar := PurRecptLineTemp."No.";
                    JobNoVar := PurRecptLineTemp."Job No.";
                    OrderNo := PurRecptLineTemp."Order No.";
                end;
                if (itemvar = PurRecptLineTemp."No.") and (CheckQty > 0) then
                    CheckQty := 0;
                if (JobNoVar = PurRecptLineTemp."Job No.") and (CheckQty > 0) then
                    CheckQty := 0;
                if (OrderNo = PurRecptLineTemp."Order No.") and (CheckQty > 0) then
                    CheckQty := 0;
                CheckQty := CheckQty + PurRecptLineTemp.Quantity - PurinvLineQty;

                if CheckQty <= 0 then
                    Checkbool := True
                else
                    Checkbool := false;

                if CheckQty <= 0 then
                    CurrReport.Skip();
            end;
        }
    }

    requestpage
    {
        Caption = 'Purchase Jobs - Received Not Invoiced';

        layout
        {
            area(content)
            {
                field(JobTaskFilter; JobTaskFilter)
                {
                    Caption = 'Job Task No. Filter';
                    Lookup = true;
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        JobTaskPage: Page "Job Task List";
                        JobTaskRec: Record "Job Task";
                    begin
                        JobTaskRec.RESET;
                        if JobNoFilter <> '' then
                            JobTaskRec.SETFILTER("Job No.", JobNoFilter);
                        JobTaskPage.LOOKUPMODE(true);
                        JobTaskPage.SETTABLEVIEW(JobTaskRec);
                        JobTaskPage.RUNMODAL;
                        JobTaskPage.GETRECORD(JobTaskRec);
                        JobTaskFilter := JobTaskRec."Job Task No.";
                    end;
                }
                field(CostCatFilter; CostCatFilter)
                {
                    Caption = 'Cost Category Filter';
                    TableRelation = "NS_Job Cost Category".NS_Code;
                    ApplicationArea = All;
                    Visible = false;
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';//PRJ-59 : AS : 11 March 2020
                    ApplicationArea = All;

                }
                field(EndDate; EndDate)
                {
                    Caption = 'As On Date';//PRJ-59 : AS : 11 March 2020
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        if StartDate = 0D then begin
                            StartDate := CalcDate('-1Y', Enddate)
                        end;

                    end;
                }
                field(JobNum; JobNum)
                {
                    Caption = 'Job No.';
                    ApplicationArea = all;
                    TableRelation = Job."No.";
                }
            }
        }
    }
    trigger OnPreReport()
    var
    begin

        if Enddate = 0D then
            Error('As On Date Cannot Be Empty.');
    end;

    var
        StartDate: Date;
        Enddate: Date;
        JobTaskFilter: Text[30];
        CostCatFilter: Text[30];
        JobNoFilter: Text[30];
        CostCategory: Record "NS_Job Cost Category";
        Job: Record Job;
        Jobdescription: Text[100];
        BillToName: Text[100];
        PurInvLineRec: Record "Purch. Inv. Line";
        PurInvheader: Record "Purch. Inv. Header";
        PurinvLineQty: Decimal;
        CostCatdesc: Text[30];
        PurRecheader: Record "Purch. Rcpt. Header";
        PurRecptLineTemp: Record "Purch. Rcpt. Line" temporary;
        PurRecptLineRec: Record "Purch. Rcpt. Line";
        JobNo: Text;
        Checkbool: Boolean;
        CheckQty: Decimal;
        JobNum: Code[20];
        CountReceiptLine: Integer;
        RowCount: Integer;
        SeparatorLbl: Label '..';

        Itemvar: Code[20];
        JobNoVar: Code[20];
        OrderNo: Code[20];

}