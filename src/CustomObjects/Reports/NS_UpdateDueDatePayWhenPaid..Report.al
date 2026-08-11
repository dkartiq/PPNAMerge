report 14021413 "NS_UpdateDueDatePayWhenPaid"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Due Dates - Pay When Paid';
    Permissions = tabledata "Vendor Ledger Entry" = rm;

    //PE-200.AS.6.0 Created Batch Report
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            trigger OnAfterGetRecord()
            var
                vleTable: Record "Vendor Ledger Entry";
                vleTable2: Record "Vendor Ledger Entry";
                JobRec1: Record Job;
                JobRec2: Record Job;
                CLEentry: Record "Cust. Ledger Entry";//PE-200.AS.10.0
                drawRecord: Record NS_Draw;
            begin
                //PE-200.AS.10.0 START
                drawRecord.RESET;
                drawRecord.SetRange("NS_No.", "Cust. Ledger Entry"."NS_Draw No.");
                drawRecord.SetRange("NS_Job No.", "Cust. Ledger Entry"."NS_Job No.");
                drawRecord.SetRange(NS_Closed, true);
                if drawRecord.FindFirst() then
                    CurrReport.Skip();

                //PE-200.AS.10.0 END

                if EntNum = 0 then begin
                    if "Cust. Ledger Entry"."Entry No." <> 0 then begin
                        if JobRec1.get("Cust. Ledger Entry"."NS_Job No.") then;

                        vleTable.Reset();
                        vleTable.SetCurrentKey("Posting Date");
                        vleTable.Ascending(true);
                        vleTable.SetRange("NS_Job No.", "Cust. Ledger Entry"."NS_Job No.");
                        vleTable.SetRange("NS_Draw No.", "Cust. Ledger Entry"."NS_Draw No.");
                        vleTable.SetRange("Document Type", vleTable."Document Type"::Invoice);
                        vleTable.SetFilter("Remaining Amount", '<>%1', 0);
                        vleTable.SETRANGE("Posting Date", 0D, "Cust. Ledger Entry"."Posting Date");
                        vleTable.SetRange(NS_PaywhenPaid, false);
                        vleTable.SetFilter("NS_Retention Ledger Code", '<>%1', JobStp."NS_Retention Payable Ledger");//PE-200.AS.11.0
                        if vleTable.FindSet() then begin
                            repeat
                                vleTable."Due Date" := CalcDate(JobRec1.NS_PaywhenpaidTermsCode, "Cust. Ledger Entry"."Posting Date");
                                vleTable.NS_PaywhenPaid := true;
                                vleTable.Modify();
                            until vleTable.Next() = 0;
                            "Cust. Ledger Entry".NS_PaywhenPaid := true;
                            "Cust. Ledger Entry".Modify();
                        end;
                    end;
                end;

                if EntNum <> 0 then begin
                    // if NS_VLEEntrVendorNo <> '' then begin
                    JobRec2.Reset();
                    JobRec2.SetRange("No.", NS_JobNo);
                    if JobRec2.FindFirst() then;

                    vleTable2.Reset();
                    if NS_JobNo <> '' then
                        vleTable2.SetRange("NS_Job No.", NS_JobNo);
                    vleTable2.SetRange("NS_Draw No.", "Cust. Ledger Entry"."NS_Draw No.");
                    if NS_VLEEntrVendorNo <> '' then
                        vleTable2.SetRange("Vendor No.", NS_VLEEntrVendorNo);
                    vleTable2.SetRange("Document Type", vleTable2."Document Type"::Invoice);
                    vleTable2.SetFilter("Remaining Amount", '<>%1', 0);
                    vleTable2.SETRANGE("Posting Date", 0D, "Cust. Ledger Entry"."Posting Date");
                    vleTable2.SetRange(NS_PaywhenPaid, false);
                    vleTable2.SetFilter("NS_Retention Ledger Code", '<>%1', JobStp."NS_Retention Payable Ledger");//PE-200.AS.11.0
                    if vleTable2.FindSet() then begin
                        repeat
                            vleTable2."Due Date" := CalcDate(JobRec2.NS_PaywhenpaidTermsCode, PDCustPayonCLE);
                            vleTable2.NS_PaywhenPaid := true;
                            vleTable2.Modify();
                        until vleTable2.Next() = 0;

                        "Cust. Ledger Entry".NS_PaywhenPaid := true;
                        "Cust. Ledger Entry".Modify();
                    end;
                    // end;
                end;

            end;

            trigger OnPostDataItem()
            var

            begin

            end;

            trigger OnPreDataItem()
            var
                JobTbl: Record Job;
            begin
                if JobStp.Get() then;

                if EntNum = 0 then begin
                    if NS_JobNo <> '' then
                        if JobTbl.get(NS_JobNo) then;

                    "Cust. Ledger Entry".SetCurrentKey("Posting Date");
                    "Cust. Ledger Entry".Ascending(true);

                    if NS_JobNo <> '' then
                        "Cust. Ledger Entry".SetRange("NS_Job No.", NS_JobNo);
                    "Cust. Ledger Entry".SetRange("Customer No.", JobTbl."Sell-to Customer No.");
                    if NS_DrawNo = '' then
                        "Cust. Ledger Entry".SetFilter("NS_Draw No.", '<>%1', '');
                    if NS_DrawNo <> '' then
                        "Cust. Ledger Entry".SetRange("NS_Draw No.", NS_DrawNo);
                    "Cust. Ledger Entry".SetRange("Document Type", "Cust. Ledger Entry"."Document Type"::Payment);
                    "Cust. Ledger Entry".SetRange("Remaining Amount", 0);
                    "Cust. Ledger Entry".SetRange(NS_PaywhenPaid, false);
                end;

                if EntNum <> 0 then begin
                    if NS_JobNo <> '' then
                        if JobTbl.get(NS_JobNo) then;

                    "Cust. Ledger Entry".SetRange("Entry No.", EntNum);
                end;
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';

                    field(NS_JobNo; NS_JobNo)
                    {
                        Caption = 'Job No.';

                        ToolTip = 'Job No.';
                        TableRelation = Job."No." where(Status = filter(Open));
                        ApplicationArea = all;
                        trigger OnValidate()
                        var
                            JobRecord: Record job;
                        begin
                            //PE-200.AS.8.0 START
                            if NS_JobNo = '' then
                                Error('Please enter Job No.');

                            if NS_JobNo <> '' then
                                if JobRecord.get(NS_JobNo) then
                                    if JobRecord.Status <> JobRecord.Status::Open then
                                        Error('Job "%1" Status must be Open', JobRecord."No.");

                            if NS_JobNo <> '' then
                                if JobRecord.get(NS_JobNo) then
                                    SellToCustNo := JobRecord."Sell-to Customer No.";

                            if NS_JobNo = '' then
                                SellToCustNo := '';
                            //PE-200.AS.8.0 END
                        end;
                    }
                    field(SellToCustNo; SellToCustNo)
                    {
                        Caption = 'Customer No.';
                        ToolTip = 'Customer No.';
                        Editable = false;
                        ApplicationArea = all;
                        trigger OnValidate()
                        begin

                        end;
                    }
                    field(NS_DrawNo; NS_DrawNo)
                    {
                        Caption = 'Draw No.';

                        ToolTip = 'Draw No.';
                        Lookup = true;
                        ApplicationArea = All;

                        trigger OnLookup(VAR Text: Text): Boolean;
                        var
                            DrawList: Page NS_Draws;
                            drawRec: Record NS_Draw;
                        begin
                            //PE-200.AS.8.0 START
                            if NS_JobNo = '' then
                                Error('Please enter Job No.');
                            //PE-200.AS.8.0 END
                            if NS_JobNo <> '' then begin
                                drawRec.RESET;
                                drawRec.SetRange("NS_Job No.", NS_JobNo);
                                drawRec.SetRange(NS_Closed, false);
                                if PAGE.RunModal(PAGE::NS_Draws, drawRec) = ACTION::LookupOK then
                                    NS_DrawNo := drawRec."NS_No.";
                            end;
                        end;
                    }
                    field(EntNum; EntNum)
                    {
                        Caption = 'CLE Entry No.';

                        ToolTip = 'CLE Entry No.';
                        BlankZero = true;
                        Lookup = true;
                        ApplicationArea = All;

                        trigger OnLookup(VAR Text: Text): Boolean;
                        var
                            CLEList: Page "Customer Ledger Entries";
                            CustLedEntRec: Record "Cust. Ledger Entry";
                        begin
                            //PE-200.AS.8.0 START
                            if NS_JobNo = '' then
                                Error('Please enter Job No.');
                            //PE-200.AS.8.0 END
                            if NS_JobNo <> '' then begin
                                CustLedEntRec.RESET;
                                CustLedEntRec.SetRange("NS_Job No.", NS_JobNo);
                                if NS_DrawNo <> '' then
                                    CustLedEntRec.SetRange("NS_Draw No.", NS_DrawNo);
                                if NS_DrawNo = '' then
                                    CustLedEntRec.SetFilter("NS_Draw No.", '<>%1', '');
                                CustLedEntRec.SetRange("Remaining Amount", 0);
                                CustLedEntRec.setrange("Document Type", CustLedEntRec."Document Type"::Payment);//PE-200.AS.7.0
                                CustLedEntRec.SetRange(NS_PaywhenPaid, false);
                                if PAGE.RunModal(PAGE::"Customer Ledger Entries", CustLedEntRec) = ACTION::LookupOK then begin
                                    NS_CustLedEntry := CustLedEntRec."Customer No.";
                                    PDCustPayonCLE := CustLedEntRec."Posting Date";
                                    EntNum := CustLedEntRec."Entry No.";
                                end;
                            end;
                        end;
                    }

                    field(NS_VLEEntrVendorNo; NS_VLEEntrVendorNo)
                    {
                        Caption = 'Vendor No. ';

                        ToolTip = 'Vendor No. ';
                        Lookup = true;
                        ApplicationArea = All;

                        trigger OnLookup(VAR Text: Text): Boolean;
                        var
                            VLEList: Page "Vendor Ledger Entries";
                            VendiLedEntRec: Record "Vendor Ledger Entry";
                        begin
                            //PE-200.AS.8.0 START
                            if NS_JobNo = '' then
                                Error('Please enter Job No.');
                            //PE-200.AS.8.0 END
                            if NS_JobNo <> '' then begin
                                VendiLedEntRec.RESET;
                                VendiLedEntRec.SetRange("NS_Job No.", NS_JobNo);
                                if NS_DrawNo <> '' then
                                    VendiLedEntRec.SetRange("NS_Draw No.", NS_DrawNo);
                                if NS_DrawNo = '' then
                                    VendiLedEntRec.SetFilter("NS_Draw No.", '<>%1', '');
                                VendiLedEntRec.SetRange("Document Type", VendiLedEntRec."Document Type"::Invoice);//PE-200.AS.7.0
                                VendiLedEntRec.SetFilter("Remaining Amount", '<>%1', 0);
                                VendiLedEntRec.SetRange(NS_PaywhenPaid, false);
                                VendiLedEntRec.SetFilter("NS_Retention Ledger Code", '<>%1', JobStp."NS_Retention Payable Ledger");//PE-200.AS.11.0
                                if PAGE.RunModal(PAGE::"Vendor Ledger Entries", VendiLedEntRec) = ACTION::LookupOK then
                                    NS_VLEEntrVendorNo := VendiLedEntRec."Vendor No.";
                                if (NS_JobNo <> '') and (EntNum = 0) and (NS_VLEEntrVendorNo <> '') then
                                    Error('Please Enter Customer Ledger  Entry No.');
                            end;
                        end;
                    }

                }
            }
        }
        actions
        {
        }

        trigger OnInit()
        begin

        end;

        trigger OnOpenPage()
        begin

        end;
    }


    labels
    {
    }

    trigger OnInitReport()
    var

    begin

    end;

    trigger OnPostReport()
    begin
        Message('Data has been successfully updated');
    end;

    trigger OnPreReport()
    begin
        //PE-200.AS.9.0 START
        if UserSetup.Get(UserId) then
            if NOT UserSetup."NS_Allow PayWhenPaid" then
                Error('You are not authorized to run this Batch. Please contact your administrator.');
        //PE-200.AS.9.0 END

        //PE-200.AS.8.0 START
        if NS_JobNo = '' then
            Error('Please Enter Job No.');

        if NS_JobNo <> '' then
            if JobRecord11.get(NS_JobNo) then
                if JobRecord11.Status <> JobRecord11.Status::Open then
                    Error('Job "%1" Status must be Open', JobRecord11."No.");
        // if (NS_JobNo <> '') and (NS_CustLedEntry = '') then
        //     Error('Please Enter Customer No.');
        // if (NS_JobNo <> '') and (NS_CustLedEntry <> '') and (NS_VLEEntrVendorNo = '') then
        //     Error('Please Enter Vendor No.');

        // if (NS_JobNo <> '') and (NS_CustLedEntry = '') and (NS_VLEEntrVendorNo <> '') then
        //     Error('Please Enter Customer Ledger  Entry No.');
        //PE-200.AS.8.0 END
    end;

    var
        JobRecord11: Record Job;
        NS_JobNo: Code[20];
        NS_DrawNo: Code[25];
        NS_CustLedEntry: Code[20];

        NS_VLEEntrVendorNo: Code[20];

        PDCustPayonCLE: Date;
        EntNum: Integer;
        SellToCustNo: Code[20];
        UserSetup: Record "User Setup";//PE-200.AS.9.0
        JobStp: Record "Jobs Setup";//PE-200.AS.11.0
}