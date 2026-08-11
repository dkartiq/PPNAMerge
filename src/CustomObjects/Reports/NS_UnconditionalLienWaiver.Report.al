
/// <summary>
/// Report NS_Unconditional Lien Waiver (ID 14021474).
/// </summary>
//PRJCTPR-11.GK.1.0 20Apr2023|Add new report
//PE-145.RM.1.0 08Aug2023 | added some code
report 14021474 "NS_Unconditional Lien Waiver"
{
    Caption = 'Unconditional Lien Waiver';
    // UsageCategory = ReportsAndAnalysis; //PE-145.RM.1.0 08Aug2023 commented
    UsageCategory = None; //PE-145.RM.1.0 08Aug2023

    // ApplicationArea = Basic, suite; //PE-145.RM.1.0 08Aug2023 commented
    //DefaultRenderingLayout = LayoutName;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NS_Unconditional Lien Waiver.rdl';
    dataset
    {
        dataitem(DataItemName; Integer)
        {
            DataItemTableView = where(Number = CONST(1));
            column(gcState; gcState)
            {

            }
            column(RemAmnt; RemAmnt)
            { }
            column(jobNo1; jobNo1)
            { }
            column(jobInvoice1; jobInvoice1)
            { }
            column(gcCounty; gcCounty)
            {

            }
            column(LienAmount; LienAmount)
            { }
            column(LienPaymentunt; LienPayment)
            { }
            column(SignedDate; SignedDate)
            { }
            column(LeinWaiverWorkType; LeinWaiverWorkType)
            {

            }
            column(gcCompanyName; gcCompanyName)
            { }
            column(AmntInWrds; AmntInWrds)
            {

            }
            column(WhatFor; WhatFor)
            { }
            column(ThisAmount; ThisAmount)
            { }
            column(gcOwnername; gcOwnername)
            {

            }
            column(gcJobContact; gcJobContact)
            {

            }
            column(gcJobTitle; gcJobTitle)
            {

            }
            column(gcJobAddress; gcJobAddress)
            {

            }
            column(gcContractValue; gcContractValue)
            {

            }

            column(gcDate; gcDate)
            {

            }
            column(gcDay; gcDay)
            {

            }
            column(gcMonthYear; gcMonthYear)
            {

            }
            column(gcJobNo; gcJobNo)
            {

            }
            column(gcOwnerInfo; gcOwnerInfo)
            {

            }
            column(gcProjectName; gcProjectName)
            {

            }
            column(JobGenCont; JobGenCont)
            {

            }

            column(grCompanyName; grCompanyInformation.Name)
            {

            }
            column(grCompanyAddress; gcCompanyAddress)
            {

            }
            column(gcInvoiceNo; gcInvoiceNo)
            {

            }
            column(gcJobDescription; gcJobDescription)
            {

            }
            trigger OnPreDataItem()
            begin
                if grCompanyInformation.get() then
                    gcCompanyAddress := grCompanyInformation.Address + ' ' + grCompanyInformation."Address 2" + ' ' +
                                        grCompanyInformation.city + ' ' + grCompanyInformation.County + ' ' +
                                        grCompanyInformation."Post Code" + ' ';
                gcCompanyName := grCompanyInformation.Name;
                grSalesInvHeader.Reset();
                grSalesInvHeader.SetRange("No.", gcInvoiceNo);
                grSalesInvHeader.SetRange("NS_Retention Ledger Code", 'NORMAL');
                if grSalesInvHeader.FindFirst() then begin
                    grSalesInvHeader.CalcFields(Amount);
                    gcContractValue := grSalesInvHeader.Amount;
                end;

                grCustLedgerEntry.SetRange("Document No.", gcInvoiceNo);
                grCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'NORMAL');
                if grCustLedgerEntry.FindFirst() then begin
                    grCustLedgerEntry.CalcFields("Original Amount");
                    LienAmount := grCustLedgerEntry."NS_Lien Waiver Amount";
                    LienPayment := grCustLedgerEntry."NS_Lien Waiver Payment";
                    SignedDate := grCustLedgerEntry."NS_Lien Waiver Signed Date";
                    gcContractValue := grCustLedgerEntry."Original Amount";
                    jobno1 := grCustLedgerEntry."NS_Job No.";
                    jobInvoice1 := grCustLedgerEntry."Document No.";
                    LeinWaiverWorkType := grCustLedgerEntry."NS_Lien Waiver Work Type";
                end;

                if grJobHeader.Get(gcJobNo) then begin
                    gcState := grJobHeader."Bill-to County";
                    gcCounty := grJobHeader."NS_County";
                    gcJobDescription := grJobHeader.Description;

                    grJobContact.Reset();
                    grJobContact.SetRange("NS_Job No.", gcJobNo);
                    grJobContact.SetRange(NS_Type, 0);
                    IF grJobContact.FindFirst() then begin
                        gcJobContact := grJobContact.NS_Name;
                        if grContact.Get(grJobContact.NS_Code) then
                            gcJobTitle := grContact."Job Title";
                    end;

                    grJobContact.Reset();
                    grJobContact.SetRange("NS_Job No.", gcJobNo);
                    grJobContact.SetRange(NS_Type, 1);
                    IF grJobContact.FindFirst() then
                        gcOwnerInfo := grJobContact.NS_Name;

                    //if gcOwnerInfo = '' then begin
                    grJobContact.Reset();
                    grJobContact.SetRange("NS_Job No.", gcJobNo);
                    grJobContact.SetRange(NS_Type, 2);
                    IF grJobContact.FindFirst() then
                        JobGenCont := grJobContact.NS_Name;
                    //end;
                    gcJobAddress := grJobHeader."NS_Job Address 1" + ' ' + grJobHeader."NS_Job Address 2" + ' ' +
                                    grJobHeader."NS_Job City" + ' ' + grJobHeader."NS_Job County" + ' ' +
                                    grJobHeader."NS_Job Post Code" + ' ';
                    ;

                    gcProjectName := grJobHeader.Description;
                    gcDate := Format(WorkDate, 0, '<Month Text> <Day,2> <Year4>');
                    gcDay := Format(WorkDate, 0, '<Day,2>');
                    gcMonthYear := Format(WorkDate, 0, '<Month Text> <Year4>');
                    WhatFor := 'Labor And Material'
                end;

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(LeinPaymnt);
                grCustLedgerEntry.Reset();
                grCustLedgerEntry.SetRange("Document No.", gcInvoiceNo);
                grCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'NORMAL');
                grCustLedgerEntry.SetFilter("Document Type", '%1', grCustLedgerEntry."Document Type"::Invoice);
                if grCustLedgerEntry.FindFirst() then
                    LeinPaymnt += Abs(grCustLedgerEntry."NS_Lien Waiver Payment");

                RepCheck.FormatNoText(NoText, LeinPaymnt, gcCurrencyCode);
                AmntInWrds := NoText[1];

                Clear(AmountPaid);
                grCustLedgerEntry.Reset();
                grCustLedgerEntry.SetRange("Document No.", gcInvoiceNo);
                grCustLedgerEntry.SetRange("NS_Retention Ledger Code", 'NORMAL');
                if grCustLedgerEntry.FindFirst() then begin
                    DetailedCustLedEnt.Reset();
                    DetailedCustLedEnt.SetRange("Cust. Ledger Entry No.", grCustLedgerEntry."Entry No.");
                    DetailedCustLedEnt.SetRange("Entry Type", DetailedCustLedEnt."Entry Type"::Application);
                    if DetailedCustLedEnt.FindSet() then
                        repeat
                            AmountPaid += DetailedCustLedEnt.Amount;
                        until DetailedCustLedEnt.Next() = 0;

                    RemAmnt := Abs(AmountPaid);
                end;
            end;
        }
    }

    var
        gcCurrencyCode: Code[10];
        RepCheck: report Check;
        NoText: Array[2] of Text[20];
        AmntInWrds: Text[250];
        RemAmnt: Decimal;
        AmountPaid: Decimal;
        LeinWaiverWorkType: Text[50];
        LeinPaymnt: Decimal;
        jobNo1: Code[20];
        jobInvoice1: code[20];
        ThisAmount: Decimal;
        WhatFor: Text[20];
        JobGenCont: Text[50];
        gcCompanyName: Text[100];
        SignedDate: Date;
        LienAmount: Decimal;
        LienPayment: Decimal;
        DetailedCustLedEnt: Record "Detailed Cust. Ledg. Entry";
        grSalesInvHeader: record "Sales Invoice Header";
        grSalesInvLine: record "Sales Invoice Line";
        grJobHeader: record Job;

        grJobContact: Record "NS_Job Contact";

        grContact: Record Contact;

        grCustLedgerEntry: Record "Cust. Ledger Entry";

        grCompanyInformation: Record "Company Information";
        gcJobNo: code[20];
        gcState: Code[20];

        gcCounty: Text[250];

        gcOwnerInfo: Text[50];

        gcProjectName: Text[100];

        gcDate: Text[100];

        gcDay: Text[50];

        gcMonthYear: Text[50];

        gcOwnername: Text[50];

        gcJobContact: Text[30];

        gcJobTitle: Text[30];

        gcJobAddress: Text[250];

        gcJobDescription: Text[100];

        gcContractValue: Decimal;

        gcInvoiceNo: Code[20];

        gcCompanyAddress: Text[250];

    procedure SetDocument(pJobNo: code[20]; DocNo: code[20]; CurrencyCode: Code[10])
    begin
        "Clear Values"();
        if pJobNo = '' then
            exit;
        gcJobNo := pJobNo;
        gcInvoiceNo := DocNo;
        gcCurrencyCode := CurrencyCode;
    end;


    local procedure "Clear Values"()
    var
        myInt: Integer;
    begin
        clear(gcState);
    end;

}

