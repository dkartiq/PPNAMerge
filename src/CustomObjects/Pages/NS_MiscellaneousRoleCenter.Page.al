page 14021256 "NS_MiscellaneousRoleCenter"
{
    Caption = 'Field Manager Filters';
    PageType = CardPart;
    SourceTable = "NS_ProjectPro Job Cue";
    //PE-211.AS.2.0 Created New Page
    layout
    {
        area(content)
        {

            cuegroup("NS_Miscellanous1")
            {
                Caption = ' ';
                Visible = true;
                field(JobsTotal; JobsTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Jobs';
                    DrillDown = true;
                    trigger OnDrillDown();
                    VAR
                        JobsRec: Record Job;
                    begin
                        JobsRec.Reset();
                        JobsRec.SetRange("NS_Field Manager", USERID());
                        PAGE.RUN(PAGE::"job list", JobsRec);
                    end;
                }
            }

            cuegroup("NS_Miscellanous2")
            {
                Caption = ' ';
                Visible = true;
                field(SubcontractCal; SubcontractCal)
                {
                    ApplicationArea = All;
                    Caption = 'Subcontracts';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        SubConRec: Record NS_Subcontract;
                        JobsRec: Record Job;
                    begin
                        SubConRec.Reset();
                        SubConRec.SetRange("NS_Field Manager", USERID());
                        SubConRec.SetFilter("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"NS_Subcontract List", SubConRec);

                    end;
                }
                field(PuOrdCal; PuOrdCal)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Orders';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PHRec: Record "Purchase Header";
                        JobsRec: Record Job;
                    begin
                        PHRec.Reset();
                        PHRec.SetRange("NS_Field Manager", USERID());
                        PHRec.SetFilter("NS_Job No.", '<>%1', '');
                        PHRec.SetRange("Document Type", PHRec."Document Type"::Order);
                        PAGE.RUN(PAGE::"Purchase Order List", PHRec);

                    end;
                }
            }
            cuegroup("NS_Miscellanous3")
            {
                Caption = ' ';
                Visible = true;

                field(PInvCal; PInvCal)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Invoice Unposted';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PHRec4: Record "Purchase Header";
                        JobsRec: Record Job;
                    begin
                        PHRec4.Reset();
                        PHRec4.SetRange("NS_Field Manager", USERID());
                        PHRec4.SetFilter("NS_Job No.", '<>%1', '');
                        PHRec4.SetRange("Document Type", PHRec4."Document Type"::Invoice);
                        PAGE.RUN(PAGE::"Purchase Invoices", PHRec4);
                    end;
                }

                field(PuCrMemoCal; PuCrMemoCal)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase CM Unposted';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PHRec2: Record "Purchase Header";
                        JobsRec: Record Job;
                    begin
                        PHRec2.Reset();
                        PHRec2.SetRange("NS_Field Manager", USERID());
                        PHRec2.SetFilter("NS_Job No.", '<>%1', '');
                        PHRec2.SetRange("Document Type", PHRec2."Document Type"::"Credit Memo");
                        PAGE.RUN(PAGE::"Purchase Credit Memos", PHRec2);

                    end;
                }

                //---
                field(PInvPosCal; PInvPosCal)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Invoice';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PInvhdr1: Record "Purch. Inv. Header";
                        JobsRec: Record Job;
                    begin
                        PInvhdr1.Reset();
                        PInvhdr1.SetRange("NS_Field Manager", USERID());
                        PInvhdr1.SetFilter("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"Posted Purchase Invoices", PInvhdr1);
                    end;
                }

                field(PuCrMemoCalPosted; PuCrMemoCalPosted)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase CM';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PuCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                        JobsRec: Record Job;
                    begin
                        PuCrMemoHdr.Reset();
                        PuCrMemoHdr.SetRange("NS_Field Manager", USERID());
                        PuCrMemoHdr.SetFilter("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"Posted Purchase Credit Memos", PuCrMemoHdr);
                    end;
                }
            }
            cuegroup("NS_Miscellanous4")
            {
                Caption = ' ';
                Visible = true;
                //PE-211.AS.3.0 START ADD
                field(PrBillingCal; PrBillingCal)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Billing';
                    DrillDown = true;
                    trigger OnDrillDown();
                    var
                        PBRec: Record "NS_Progress Billing Header";
                        JobsRec: Record Job;
                    begin
                        PBRec.Reset();
                        PBRec.SetRange("NS_Field Manager", USERID());
                        PBRec.SetFilter("NS_Job No.", '<>%1', '');
                        PAGE.RUN(PAGE::"NS_Progress Billing List", PBRec);
                    end;
                }
                //PE-211.AS.3.0 END ADD

                //PE-211.AS.4.0 START ADD
                field(NS_DailyJobLogs; NS_DailyJobLogs)
                {
                    ApplicationArea = all;
                    Caption = 'Job Daily Log List';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        JobsRec: Record Job;
                        NS_DailyJobLg: Record "NS_Daily Job Log";
                    begin
                        NS_DailyJobLg.Reset();
                        NS_DailyJobLg.SetRange("NS_Field Manager", USERID());
                        NS_DailyJobLg.SetFilter("NS_Job No.", '<>%1', '');
                        page.Run(page::"NS_Daily Job Log List", NS_DailyJobLg);
                    end;
                }
            }
            //PE-211.AS.4.0 END ADD


        }


    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        //Calculate Jobs
        JobsTotal := 0;
        JobCal1.RESET();
        if JobCal1.FIND('-') then
            repeat
                if JobCal1."NS_Field Manager" = UserId() then
                    JobsTotal += 1;
            until JobCal1.NEXT() = 0;

        //Calculate SubContract     
        SubcontractCal := 0;
        SuBcontRec.RESET();
        SuBcontRec.SetRange("NS_Field Manager", USERID());
        SuBcontRec.SetFilter("NS_Job No.", '<>%1', '');
        if SuBcontRec.FIND('-') then
            repeat
                if SuBcontRec."NS_Job No." <> '' then
                    SubcontractCal += 1;
            until SuBcontRec.NEXT() = 0;

        //Calculate POs    
        PuOrdCal := 0;
        PurHeaderRec.RESET();
        PurHeaderRec.SetRange("NS_Field Manager", USERID());
        PurHeaderRec.SetFilter("NS_Job No.", '<>%1', '');
        PurHeaderRec.SetRange("Document Type", PurHeaderRec."Document Type"::Order);
        if PurHeaderRec.FIND('-') then
            repeat
                if PurHeaderRec."NS_Job No." <> '' then
                    PuOrdCal += 1;
            until PurHeaderRec.NEXT() = 0;

        //Calculate Purchase Credit Memos Unposted
        PuCrMemoCal := 0;
        PurHeaderRec1.RESET();
        PurHeaderRec1.SetRange("NS_Field Manager", USERID());
        PurHeaderRec1.SetFilter("NS_Job No.", '<>%1', '');
        PurHeaderRec1.SetRange("Document Type", PurHeaderRec1."Document Type"::"Credit Memo");
        if PurHeaderRec1.FIND('-') then
            repeat
                if PurHeaderRec1."NS_Job No." <> '' then
                    PuCrMemoCal += 1;
            until PurHeaderRec1.NEXT() = 0;

        //Calculate Purchase Invoices Unposted 
        PInvCal := 0;
        PurHeaderRec2.RESET();
        PurHeaderRec2.SetRange("NS_Field Manager", USERID());
        PurHeaderRec2.SetFilter("NS_Job No.", '<>%1', '');
        PurHeaderRec2.SetRange("Document Type", PurHeaderRec2."Document Type"::Invoice);
        if PurHeaderRec2.FIND('-') then
            repeat
                if PurHeaderRec2."NS_Job No." <> '' then
                    PInvCal += 1;
            until PurHeaderRec2.NEXT() = 0;

        //Calculate Purchase Invoices Posted 
        PInvPosCal := 0;
        PinvPosted.RESET();
        PinvPosted.SetRange("NS_Field Manager", USERID());
        PinvPosted.SetFilter("NS_Job No.", '<>%1', '');
        if PinvPosted.FIND('-') then
            repeat
                if PinvPosted."NS_Job No." <> '' then
                    PInvPosCal += 1;
            until PinvPosted.NEXT() = 0;

        //Calculate Purchase CM Posted 
        PuCrMemoCalPosted := 0;
        PCMPosted.RESET();
        PCMPosted.SetRange("NS_Field Manager", USERID());
        PCMPosted.SetFilter("NS_Job No.", '<>%1', '');
        if PCMPosted.FIND('-') then
            repeat
                if PCMPosted."NS_Job No." <> '' then
                    PuCrMemoCalPosted += 1;
            until PCMPosted.NEXT() = 0;



        //Calculate Progress Billing
        //PE-211.AS.3.0 START ADD
        PrBillingCal := 0;
        ProggBillHeader.RESET();
        ProggBillHeader.SetRange("NS_Field Manager", USERID());
        ProggBillHeader.SetFilter("NS_Job No.", '<>%1', '');
        if ProggBillHeader.FIND('-') then
            repeat
                if ProggBillHeader."NS_Job No." <> '' then
                    PrBillingCal += 1;
            until ProggBillHeader.NEXT() = 0;
        //PE-211.AS.3.0 END ADD

        //Calculate Daily Job Logs
        //PE-211.AS.4.0 START
        NS_DailyJobLogs := 0;
        NS_DailyJobLgRec.RESET();
        NS_DailyJobLgRec.SetRange("NS_Field Manager", USERID());
        NS_DailyJobLgRec.SetFilter("NS_Job No.", '<>%1', '');
        if NS_DailyJobLgRec.FIND('-') then
            repeat
                if NS_DailyJobLgRec."NS_Job No." <> '' then
                    NS_DailyJobLogs += 1;
            until NS_DailyJobLgRec.NEXT() = 0;
        //PE-211.AS.4.0 END

    end;

    trigger OnOpenPage();
    begin
        Rec.RESET();
        if not Rec.GET() then begin
            Rec.INIT();
            Rec.INSERT();
        end;

    end;

    var
        JobCal1: Record Job;
        JobCal2: Record Job;
        JobCal3: Record Job;

        JobCal4: Record Job;
        JobCal5: Record Job;
        JobCal6: Record Job; //PE-211.AS.4.0 
        JobsTotal: Integer;
        SuBcontRec: Record NS_Subcontract;
        PurHeaderRec: Record "Purchase Header";
        PurHeaderRec1: Record "Purchase Header";
        PurHeaderRec2: Record "Purchase Header";
        PinvPosted: Record "Purch. Inv. Header";
        PCMPosted: Record "Purch. Cr. Memo Hdr.";
        ProggBillHeader: Record "NS_Progress Billing Header";//PE-211.AS.3.0 ADD
        NS_DailyJobLgRec: Record "NS_Daily Job Log"; //PE-211.AS.4.0 
        SubcontractCal: Integer;
        PuOrdCal: Integer;
        PInvCal: Integer;
        PuCrMemoCal: Integer;
        PInvPosCal: Integer;
        PuCrMemoCalPosted: Integer;
        PrBillingCal: Integer;//PE-211.AS.3.0 ADD
        NS_DailyJobLogs: Integer; //PE-211.AS.4.0 
}

