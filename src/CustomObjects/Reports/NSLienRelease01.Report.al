report 14021302 "NS_Lien Release 01"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    // PRJ-290.N.S.1.0 20Aug 2020 remove ""
    //PRJ-975.GK.1.0 21Oct2021 | Add request filter fields
    DefaultLayout = RDLC;
    Caption = 'Lien Release 01';
    RDLCLayout = './Layouts/NSLien Release 01.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Posting Date"; //PRJ-975.GK.1.0 21Oct2021
            DataItemTableView = where("NS_Lien Release Print Status" = filter(Requested));//PRJ-975.GK.1.0 21Oct2021
            column(Entry_No_; "Entry No.")
            {
                ///Test
            }
            column(HeadingLine1; HeadingLine[1])
            {
            }
            column(HeadingLine2; HeadingLine[2])
            {
            }
            column(HeadingLine3; HeadingLine[3])
            {
            }
            column(HeadingLine4; HeadingLine[4])
            {
            }
            column(HeadingLine5; HeadingLine[5])
            {
            }
            column(HeadingLine6; HeadingLine[6])
            {
            }
            column(BodyLine1; BodyLine[1])
            {
            }
            column(BodyLine2; BodyLine[2])
            {
            }
            column(BodyLine3; BodyLine[3])
            {
            }
            column(BodyLine4; BodyLine[4])
            {
            }
            column(BodyLine5; BodyLine[5])
            {
            }
            column(BodyLine6; BodyLine[6])
            {
            }
            column(BodyLine7; BodyLine[7])
            {
            }
            column(BodyLine8; BodyLine[8])
            {
            }
            column(BodyLine9; BodyLine[9])
            {
            }
            column(BodyLine10; BodyLine[10])
            {
            }
            column(BodyLine11; BodyLine[11])
            {
            }
            column(BodyLine12; BodyLine[12])
            {
            }
            column(BodyLine13; BodyLine[13])
            {
            }
            column(BodyLine14; BodyLine[14])
            {
            }
            column(BodyLine15; BodyLine[15])
            {
            }
            column(BodyLine16; BodyLine[16])
            {
            }
            column(BodyLine17; BodyLine[17])
            {
            }
            column(BodyLine18; BodyLine[18])
            {
            }
            column(BodyLine19; BodyLine[19])
            {
            }
            column(BodyLine20; BodyLine[20])
            {
            }
            column(BodyLine21; BodyLine[21])
            {
            }
            column(BodyLine22; BodyLine[22])
            {
            }
            column(BodyLine23; BodyLine[23])
            {
            }
            column(BodyLine24; BodyLine[24])
            {
            }
            column(SignatureDateHeading; SignatureDateHeading)
            {
            }
            column(SingatureDate; SignatureDate)
            {
            }
            column(SignatureCheckNoHeading; SignatureCheckNoHeading)
            {
            }
            column(SignatureCheckNo; SignatureCheckNo)
            {
            }
            column(SignatureLine1; SignatureLine[1])
            {
            }
            column(SignatureLine2; SignatureLine[2])
            {
            }
            column(SignatureLine3; SignatureLine[3])
            {
            }
            column(SignatureLine4; SignatureLine[4])
            {
            }
            column(SignatureLine5; SignatureLine[5])
            {
            }
            column(SignatureLine6; SignatureLine[6])
            {
            }
            column(SignatureLine7; SignatureLine[7])
            {
            }
            column(SignatureLine8; SignatureLine[8])
            {
            }
            column(SignatureLine9; SignatureLine[9])
            {
            }
            column(SignatureLine10; SignatureLine[10])
            {
            }
            column(SignatureLine11; SignatureLine[11])
            {
            }
            column(NoticeLine1; NoticeLine[1])
            {
            }
            column(NoticeLine2; NoticeLine[2])
            {
            }
            column(NoticeLine3; NoticeLine[3])
            {
            }
            column(NoticeLine4; NoticeLine[4])
            {
            }

            trigger OnAfterGetRecord();
            begin
                //PRJ-290.AS.1.0 27AUG20 - START
                Clear(WaiverAmount);
                clear(CurrencyCode);
                clear(CheckNo);
                clear(CheckDate);
                clear(ThruDate);
                clear(SubcontractNo);
                clear(FinalOrProgress);
                clear(PaymentToName);
                clear(SignatureDate);
                clear(SignatureCheckNo);
                if Entrynum = "Vendor Ledger Entry"."Entry No." then
                    CurrReport.skip;
                //PRJ-290.AS.1.0 27AUG20 - END
                "Vendor Ledger Entry".CALCFIELDS(Amount);//PRJ-290.AS.1.0 27AUG20

                CompanyInformation.GET;
                //PRJ-290.AS.1.0 27AUG20
                IF "Vendor Ledger Entry"."NS_Job No." = '' then
                    CurrReport.Skip;

                if "Vendor Ledger Entry"."NS_Job No." <> '' then
                    Job.GET("Vendor Ledger Entry"."NS_Job No.");
                //PRJ-290.AS.1.0 27AUG20
                ThruDate := "Vendor Ledger Entry"."Posting Date";
                InvoiceVLE.RESET();
                InvoiceVLE.SETCURRENTKEY("Document Type", "Vendor No.", "NS_Retention Ledger Code");
                InvoiceVLE.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type"::Invoice);
                InvoiceVLE.SETRANGE("Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                InvoiceVLE.SETRANGE("NS_Retention Ledger Code", "Vendor Ledger Entry"."NS_Retention Ledger Code");
                if InvoiceVLE.FINDSET() then begin
                    repeat
                        InvoiceVLE.CALCFIELDS(Amount);
                        if (("Vendor Ledger Entry".Amount = ABS(InvoiceVLE.Amount)) and ("Vendor Ledger Entry"."NS_Subcontract No." = InvoiceVLE."NS_Subcontract No.")) then
                            ThruDate := InvoiceVLE."Document Date";
                    until InvoiceVLE.NEXT() = 0;
                end;
                CurrencyCode := "Vendor Ledger Entry"."Currency Code";
                CheckNo := "Vendor Ledger Entry"."Document No.";
                CheckDate := "Vendor Ledger Entry"."Document Date";
                SubcontractNo := "Vendor Ledger Entry"."NS_Subcontract No.";
                if "Vendor Ledger Entry"."NS_Lien Release Type" = "Vendor Ledger Entry"."NS_Lien Release Type"::Progress then
                    FinalOrProgress := FinalOrProgress::Progress
                else
                    FinalOrProgress := FinalOrProgress::Final;
                FormatAddr.NS_JobSite(AddressLine, Job);
                if JobNoFiltered and "IncludeSub-Levels" then
                    WaiverAmount := Job.SLsPaymentsMade(Job, "Document No.");
                FirstPass := false;
                CheckLedgEntry.RESET();
                CheckLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
                CheckLedgEntry.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                CheckLedgEntry.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");
                if CheckLedgEntry.FIND('-') then
                    PaymentToName := CheckLedgEntry.Description
                else
                    PaymentToName := 'UNKNOWN!!';



                WaiverAmount := WaiverAmount + "Vendor Ledger Entry".Amount;
                WaiverAmount := ABS(WaiverAmount);

                if MarkAsPrinted then begin
                    "NS_Lien Release Print Status" := "NS_Lien Release Print Status"::Printed;
                    MODIFY()
                end;

                //

                if WaiverAmount = 0 then   //If no data was found
                    CurrReport.BREAK;


                //Convert amount to words

                LanguageCode := 1033;    // sets Language to English (United States)
                OnSetAmountInWords(WordedAmount, WaiverAmount, LanguageCode, CurrencyCode); //PPDA.1.0 Added

                //PPDA.1.0 Start Commented
                // if not ChkTransMgt.FormatNoText(WordedAmount, WaiverAmount, LanguageCode, CurrencyCode) then
                //     ERROR(WordedAmount[1]);
                //PPDA.1.0 End Commented


                //LN - Line Number
                //LN += 1; is the same as LN := LN + 1; used to keep the line shorter for better readability
                CLEAR(HeadingLine);
                CLEAR(BodyLine);
                CLEAR(SignatureLine);
                CLEAR(NoticeLine);
                LN := 1;
                HeadingLine[LN] := HeadingText1a + UPPERCASE(FORMAT(FinalOrProgress)) + HeadingText1b;
                LN += 2;
                HeadingLine[LN] := HeadingText2 + Job.Description;
                LN += 1;
                HeadingLine[LN] := HeadingText3 + Job."No.";
                if SubcontractNo <> '' then begin
                    LN += 1;
                    HeadingLine[LN] := HeadingText4 + SubcontractNo;
                end;

                LN := 1;
                BodyLine[LN] := BodyText1a + LOWERCASE(FORMAT(FinalOrProgress)) + BodyText1b + FORMAT(WaiverAmount, 0, '<Precision,2:2><Standard Format,0>') + BodyText1c;
                LN += 2;
                BodyLine[LN] := Tab + WordedAmount[1];
                if WordedAmount[2] > '' then begin
                    LN += 1;
                    BodyLine[LN] := Tab + WordedAmount[2];
                end;
                LN += 2;
                BodyLine[LN] := BodyText2 + CompanyInformation.Name;
                LN += 1;
                BodyLine[LN] := BodyText3;
                LN += 2;
                BodyLine[LN] := Tab + Tab + Job.Description;

                if AddressLine[1] > '' then begin
                    LN += 1;
                    BodyLine[LN] := Tab + Tab + AddressLine[1];
                    if AddressLine[2] > '' then begin
                        LN += 1;
                        BodyLine[LN] := Tab + Tab + AddressLine[2];
                        if AddressLine[3] > '' then begin
                            LN += 1;
                            BodyLine[LN] := Tab + Tab + AddressLine[3];
                            if AddressLine[4] > '' then begin
                                LN += 1;
                                BodyLine[LN] := Tab + Tab + AddressLine[4];
                                if AddressLine[5] > '' then begin
                                    LN += 1;
                                    BodyLine[LN] := Tab + Tab + AddressLine[5];
                                    if AddressLine[6] > '' then begin
                                        LN += 1;
                                        BodyLine[LN] := Tab + Tab + AddressLine[6];
                                        if AddressLine[7] > '' then begin
                                            LN += 1;
                                            BodyLine[LN] := Tab + Tab + AddressLine[7];
                                            if AddressLine[8] > '' then begin
                                                LN += 1;
                                                BodyLine[LN] := Tab + Tab + AddressLine[8];
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                LN += 2;
                BodyLine[LN] := BodyText4;
                LN += 1;
                BodyLine[LN] := BodyText5;
                LN += 1;
                BodyLine[LN] := BodyText6;
                LN += 1;
                BodyLine[LN] := BodyText7a;
                if FinalOrProgress = FinalOrProgress::Final then
                    BodyLine[LN] := BodyLine[LN] + BodyText7b
                else
                    BodyLine[LN] := BodyLine[LN] + BodyText7c;
                BodyLine[LN] := BodyLine[LN] + BodyText7d;
                LN += 1;
                BodyLine[LN] := BodyText8a + CompanyInformation.Name + BodyText8b + FORMAT(ThruDate) + BodyText8c;
                LN += 1;
                BodyLine[LN] := BodyText9a;
                if FinalOrProgress = FinalOrProgress::Final then
                    BodyLine[LN] := BodyLine[LN] + BodyText9b
                else
                    BodyLine[LN] := BodyLine[LN] + BodyText9c;
                LN += 2;
                BodyLine[LN] := BodyText10 + LOWERCASE(FORMAT(FinalOrProgress));
                LN += 1;
                BodyLine[LN] := BodyText11;
                LN += 1;
                BodyLine[LN] := BodyText12;


                SignatureDateHeading := SignText1;
                SignatureDate := FORMAT(CheckDate);
                SignatureCheckNoHeading := SignText2;
                SignatureCheckNo := CheckNo;
                LN := 1;
                SignatureLine[LN] := Tab + Tab + Tab + Tab + PaymentToName;
                LN += 3;
                SignatureLine[LN] := Tab + Tab + SignText3a + Tab + Tab + Tab + Tab + Tab + SignText3b;
                LN += 3;
                SignatureLine[LN] := Tab + Tab + SignText4;
                LN += 3;
                SignatureLine[LN] := Tab + Tab + SignText5;

                LN := 1;
                NoticeLine[LN] := NoticeText1;
                LN += 1;
                NoticeLine[LN] := NoticeText2;
                LN += 1;
                NoticeLine[LN] := NoticeText3;


                EntryNum := "Vendor Ledger Entry"."Entry No.";//PRJ-290.AS.1.0 27AUG20
            end;

            trigger OnPreDataItem();
            begin

                // FirstPass := true;

                // if GETFILTER("NS_Job No.") > '' then
                //     JobNoFiltered := true;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("IncludeSub-Levels"; "IncludeSub-Levels")
                {
                    Caption = 'Include Sub-Levels';
                    ApplicationArea = All;
                }
                field(PrintOnLetterhead; PrintOnLetterhead)
                {
                    Caption = 'Print On Letterhead';
                    ApplicationArea = All;
                }
                field(MarkAsPrinted; MarkAsPrinted)
                {
                    Caption = 'Mark As Printed';
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
        Entrynum: Integer;
        //Tab: Label '"         "';
        Tab: Label ' ';

        //HeadingText1a: Label '"UNCONDITIONAL WAIVER AND RELEASE ON "'; PRJ-290.N.S.1.0 20Aug 2020 comment
        HeadingText1a: Label 'UNCONDITIONAL WAIVER AND RELEASE ON ';//PRJ-290.N.S.1.0 20Aug 2020
        //HeadingText1b: Label '" PAYMENT"';PRJ-290.N.S.1.0 20Aug 2020 comment
        HeadingText1b: Label ' PAYMENT';//PRJ-290.N.S.1.0 20Aug 2020
        //HeadingText2: Label ' "PROJECT: "';PRJ-290.N.S.1.0 20Aug 2020 comment
        HeadingText2: Label 'PROJECT: ';//PRJ-290.N.S.1.0 20Aug 2020
        //HeadingText3: Label '"JOB NO: "';PRJ-290.N.S.1.0 20Aug 2020 comment
        HeadingText3: Label 'JOB NO: ';//PRJ-290.N.S.1.0 20Aug 2020

        //HeadingText4: Label '"SUBCONTRACT NO: "'; PRJ-290.N.S.1.0 20Aug 2020 comment
        HeadingText4: Label 'SUBCONTRACT NO: ';//PRJ-290.N.S.1.0 20Aug 2020
        //BodyText1a: Label '"The undersigned has been paid and has received a "'; PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText1a: Label 'The undersigned has been paid and has received a ';//PRJ-290.N.S.1.0 20Aug 2020
        //BodyText1b: Label '" payment in the sum of:  **"';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText1b: Label ' payment in the sum of: **'; //PRJ-290.N.S.1.0 20Aug 2020
        BodyText1c: Label '**';
        //BodyText2: Label '"for all labor, services, equipment or materials furnished to the jobsite or to "';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText2: Label 'for all labor, services, equipment or materials furnished to the jobsite or to '; //PRJ-290.N.S.1.0 20Aug 2020
        BodyText3: Label 'on the job of:';
        BodyText4: Label 'and does hereby release any mechanic''s liens, any state or federal statutory bond right, any private bond right,';
        BodyText5: Label 'any claim for payment and any rights under any similar ordinance, rule or statute related to claim to or';
        BodyText6: Label 'payment rights for persons in the undersigned''''s position that the undersigned has on the above referenced';
        //BodyText7a: Label '"projects to the following extent.  This release covers "';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText7a: Label 'projects to the following extent.  This release covers ';//PRJ-290.N.S.1.0 20Aug 2020
        //BodyText7b: Label '"the final "';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText7b: Label 'the final ';//PRJ-290.N.S.1.0 20Aug 2020
        //BodyText7c: Label '"a progress "'; PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText7c: Label 'a progress ';//PRJ-290.N.S.1.0 20Aug 2020
        BodyText7d: Label 'payment for all labor, services, equipment or';
        //BodyText8a: Label '"materials furnished to the jobsite or to "';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText8a: Label 'materials furnished to the jobsite or to ';//PRJ-290.N.S.1.0 20Aug 2020
        //BodyText8b: Label '" thru "'; PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText8b: Label ' thru '; //PRJ-290.N.S.1.0 20Aug 2020
        //BodyText8c: Label '" only,"'; PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText8c: Label ' only,'; //PRJ-290.N.S.1.0 20Aug 2020
        BodyText9a: Label 'and does not cover any retentions, pending modifications and charges or items furnished';
        BodyText9b: Label '.';
        //BodyText9c: Label '" after that date."'; PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText9c: Label ' after that date.'; //PRJ-290.N.S.1.0 20Aug 2020

        //BodyText10: Label '"The undersigned warrents the he either has already paid or will use monies he receives from this "';PRJ-290.N.S.1.0 20Aug 2020 comment
        BodyText10: Label 'The undersigned warrents the he either has already paid or will use monies he receives from this ';//PRJ-290.N.S.1.0 20Aug 2020
        BodyText11: Label 'payment to promptly pay in full all his laborers, subcontractors, material men and suppliers for all work, material';
        BodyText12: Label 'and equipment or services provided for or to the above referenced project up to the date of this waiver.';
        SignText1: Label 'Dated:';
        SignText2: Label 'Check No.:';
        SignText3a: Label 'Signature:';
        SignText3b: Label 'Date:';
        SignText4: Label 'Print Name:';
        SignText5: Label 'Title:';
        NoticeText1: Label 'NOTICE: This document waives rights unconditionally and states that you have been paid for giving up those';
        NoticeText2: Label 'rights.This document is enforceable against you if you signed it even if you have not been paid.  If you have not';
        NoticeText3: Label 'been paid, use a conditional release of lien rights is subject to the clearance of the instrument used for payment.';
        Job: Record Job;
        CompanyInformation: Record "Company Information";
        CheckLedgEntry: Record "Check Ledger Entry";
        // ChkTransMgt: Report "Check Translation Management"; //PPDA.1.0 Commented
        CheckReport: Report Check;
        FormatAddr: Codeunit "NS_Format Address";
        CurrencyCode: Code[10];
        SubcontractNo: Code[20];
        LanguageCode: Integer;
        WaiverAmount: Decimal;
        LN: Integer;
        FinalOrProgress: Option Final,Progress;
        ThruDate: Date;
        CheckDate: Date;
        PaymentToName: Text[30];
        AddressLine: array[8] of Text[50];
        WordedAmount: array[2] of Text[80];
        CheckNo: Text[30];
        FirstPass: Boolean;
        JobNoFiltered: Boolean;
        "IncludeSub-Levels": Boolean;
        MarkAsPrinted: Boolean;
        PrintOnLetterhead: Boolean;
        "------------------------------": Integer;
        HeadingLine: array[10] of Text[150];
        BodyLine: array[50] of Text[150];
        SignatureDateHeading: Text[30];
        SignatureDate: Text[30];
        SignatureCheckNoHeading: Text[30];
        SignatureCheckNo: Text[30];
        SignatureLine: array[20] of Text[150];
        NoticeLine: array[10] of Text[150];
        VLENo: Integer;
        VLE: Record "Vendor Ledger Entry";
        InvoiceVLE: Record "Vendor Ledger Entry";


    //PPDA.1.0 Start Added
    [IntegrationEvent(false, false)]
    local procedure OnSetAmountInWords(Var WordedAmount: array[2] of Text[80]; Var WaiverAmount: Decimal; Var LanguageCode: Integer; Var CurrencyCode: code[10])
    begin
    end;
    //PPDA.1.0 End Added


}

