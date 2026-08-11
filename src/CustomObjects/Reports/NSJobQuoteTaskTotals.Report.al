
/// <summary>
/// Report NS_Job Task Tot Quote Proposal (ID 14021497).
/// </summary>
Report 14021497 "NS_Job Task Tot Quote Proposal"
{
    // version PPNA11.00
    //PRJ-1046.RM.1.0 11Nov2021 | Created a Report
    //PRJ-1595.GK.1.0 01Sep2022 |Changes in Layout for removing INTERNAL USE ONLY caption.
    //PE-114.RM.1.0 22June2023  | Added some code
    //PE-141.RM.1.0 23Aug2023 | Did some changes in the Layout.
    //PE-215.DK.2.0 26Dec2023 | Also change in Both Layout RDLC and Word Layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Task Tot QuoteProposal.rdl';
    WordLayout = './Layouts/NSJob Task Tot QuoteProposal.docx';  //PE-114.RM.1.0 22June2023
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Task Quote/Proposal';
    UseRequestPage = true;

    dataset
    {
        dataitem("Job Quote Header"; "NS_Job Quote Header")
        {
            RequestFilterFields = "NS_Quote No.";
            column(SalesPersonCap; SalesPersonCap)
            {
            }
            //PE-114.RM.1.0 26June2023 start
            column(TotalBySegment; TotalBySegment) //PE-215.Dk.4.0 13Feb2024 Replace TotalPrice2 to TotalBySegment
            {

            }
            //PE-215.DK.3.0 15jan2023 Start
            // column(NS_Salesperson_User_ID; "NS_Salesperson/User ID")
            // {
            // }
            column(NS_Salesperson_User_ID; UserID)
            {
            }
            //PE-215.DK.3.0 15jan2023 End
            column(NS_TextCommaAdd1; NS_TextCommaAdd1)
            {

            }
            column(NS_TextCommaAdd2; NS_TextCommaAdd2)
            {

            }
            column(NS_TextCommaAdd3; NS_TextCommaAdd3)
            {

            }

            // 26June2023 End
            column(SoldToCap; SoldToCap)
            {
            }
            column(ShipToCap; ShipToCap)
            {
            }
            column(TermsCap; TermsCap)
            {
            }
            column(ShipByCap; ShipByCap)
            {
            }
            column(POCap; POCap)
            {
            }
            column(AcceptanceCap; AcceptanceCap)
            {
            }
            column(Acceptance1Cap; Acceptance1Cap)
            {
            }
            column(Acceptance2Cap; Acceptance2Cap)
            {
            }
            column(CompNameCap; CompNameCap)
            {
            }
            column(SignDateCap; SignDateCap)
            {
            }
            column(PrintNameCap; PrintNameCap)
            {
            }
            column(PrintTitleCap; PrintTitleCap)
            {
            }
            column(CustInitCap; CustInitCap)
            {
            }
            column(CronusConFiCap; CronusConFiCap)
            {
            }
            column(QuoteValidCap; QuoteValidCap)
            {
            }
            column(ThisDocApplCap; ThisDocApplCap)
            {
            }
            column(GrandTotalCap; GrandTotalCap)
            {
            }
            //PE-114.RM.1.0 01Aug2023 start
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            //PE-114.RM.1.0 01Aug2023 end
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2; CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_County; CompanyInfo.County)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
            {
            }
            column(Company_Pic; CompanyInfo.Picture)
            {
            }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { } //PE-215.DK.1.0 13Dec2023 
            column(QuoteNo_JobQuoteHeader; "Job Quote Header"."NS_Quote No.")
            {
            }
            // column(ProposalDate_JobQuoteHeader; FORMAT("Job Quote Header"."NS_Proposal Date", 0, '<Day,2>/<Month,2>/<Year4>')) //PE-114.RM.1.0 09Aug2023 commented
            // {
            // }

            //PE-114.RM.1.0 09Aug2023 start
            //PE-215.DK.2.0 26Dec2023 Start
            // column(ProposalDate_JobQuoteHeader; FORMAT("Job Quote Header"."NS_Proposal Date", 0, '<Month,2>/<Day,2>/<Year4>'))//PE-215.DK.1.0 Remove (-) and Add (/) 
            // {

            // }
            // column(NS_Today; format(WorkDate(), 0, '<Month,2>/<Day,2>/<Year4>')) //PE-215.DK.1.0 Remove (-) and Add (/) 
            // {
            // }
            /// <summary>
            /// This Field Use to RDLC Report
            /// </summary>
            column(ProposalDate_JobQuoteHeader; "Job Quote Header"."NS_Proposal Date")
            {

            }
            /// <summary>
            /// This Field Use to RDLC Report
            /// </summary>
            column(NS_Today; WorkDate())
            {
            }
            /// <summary>
            /// This Field Use to WordLayout
            /// </summary>
            column(ProposalDate_JobQuoteHeader1; FORMAT("Job Quote Header"."NS_Proposal Date"))
            {

            }
            /// <summary>
            /// This Field Use to WordLayout
            /// </summary>
            column(NS_Today1; format(WorkDate()))
            {
            }
            //PE-215.DK.2.0 26Dec2023 End
            //PE-114.RM.1.0 09Aug2023 end


            column(JobQuoteExtDoc; "Job Quote Header"."NS_External Document No.")
            {
            }
            column(ShipToName; ShipToName)
            {
            }
            column(ShipToCont; ShipToCont)
            {
            }
            column(ShipToAddr; ShipToAddr)
            {
            }
            column(ShipToAddr2; ShipToAddr2)  //PE-114.RM.1.0 28July2023
            {
            }
            column(ShipTocity; ShipTocity)
            {
            }
            column(BillToName; BillToName)
            {
            }
            column(BillToCont; BillToCont)
            {
            }
            column(BillToAddr; BillToAddr)
            {
            }
            //PE-114.RM.1.0 28July2023 start
            column(BillToAddr2; BillToAddr2)
            {
            }
            //PE-114.RM.1.0 28July2023 end
            column(BillTocity; BillTocity)
            {
            }
            column(PaymentTermsDesc; PaymentTerms.Description)
            {
            }
            column(SalespersonName; Salesperson.Name)
            {
            }
            column(ShipmentMethodDesc; ShipmentMethod.Description)
            {
            }
            dataitem("Job Quote Task"; "Job Task")
            {
                DataItemLink = "Job No." = FIELD("NS_Quote No.");
                column(Job_Task_No_; "Job Task No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Schedule__Total_Price_; "Schedule (Total Price)")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(TotalPrice);
                    CLEAR(TotalPrice2);//PE-215.DK.4.0 13Feb2024 
                    CLEAR(TotalBySegment);//PE-215.DK.4.0 13Feb2024
                    // //PE-114.RM.1.0 11July2023 start
                    // Clear(NS_TextCommaAdd1);
                    // Clear(NS_TextCommaAdd2);
                    // Clear(NS_TextCommaAdd3);
                    // if (CompanyInfo.Address <> '') AND (CompanyInfo.City <> '') then
                    //     NS_TextCommaAdd1 := ','
                    // else
                    //     NS_TextCommaAdd1 := '';
                    // if CompanyInfo.County <> '' then
                    //     NS_TextCommaAdd2 := ','
                    // else
                    //     NS_TextCommaAdd2 := '';
                    // if CompanyInfo."Post Code" <> '' then
                    //     NS_TextCommaAdd3 := ','
                    // else
                    //     NS_TextCommaAdd3 := '';
                    //PE-114.RM.1.0 11July2023 End

                    JobTakeoffSegments_G.RESET;
                    JobTakeoffSegments_G.SETRANGE("Job No.", "Job Quote Task"."Job No.");
                    JobTakeoffSegments_G.SETRANGE("Job Task No.", "Job Quote Task"."Job Task No.");
                    IF JobTakeoffSegments_G.FINDFIRST THEN BEGIN
                        JobTakeoffSegments_G.CALCFIELDS("Schedule (Total Price)");
                        IF JobTakeoffSegments_G."Schedule (Total Price)" = 0 THEN
                            TotalPrice := JobTakeoffSegments_G."Schedule (Total Price)";

                        IF JobTakeoffSegments_G."Schedule (Total Price)" <> 0 THEN
                            TotalPrice := JobTakeoffSegments_G."Schedule (Total Price)";
                        //PE-215.DK.4.0 13Feb2024 Start
                        IF JobTakeoffSegments_G."Schedule (Total Price)" <> 0 THEN
                            TotalPrice2 += JobTakeoffSegments_G."Schedule (Total Price)";
                        TotalBySegment := TotalPrice2;
                        //PE-215.DK.4.0 13Feb2024 End
                    END;
                end;

                trigger OnPreDataItem()
                begin

                    "Job Quote Task".Setrange("Job Task Type", "Job Quote Task"."Job Task Type"::"End-Total");
                    //PE-215.DK.4.0 13Feb2024 Start
                    //     CLEAR(TotalPrice2);
                    //     CLEAR(TotalBySegment);
                    //     JobTakeoffSegments_G.RESET;
                    //     JobTakeoffSegments_G.SETRANGE("Job No.", "Job Quote Header"."NS_Quote No.");
                    //     IF JobTakeoffSegments_G.FINDfirst THEN begin
                    //         REPEAT
                    //             JobTakeoffSegments_G.CALCFIELDS("Schedule (Total Price)");
                    //             IF JobTakeoffSegments_G."Schedule (Total Price)" = 0 THEN
                    //                 TotalPrice2 := JobTakeoffSegments_G."Schedule (Total Price)";

                    //             IF JobTakeoffSegments_G."Schedule (Total Price)" <> 0 THEN
                    //                 TotalPrice2 := JobTakeoffSegments_G."Schedule (Total Price)";
                    //             TotalBySegment += TotalPrice2;
                    //         UNTIL JobTakeoffSegments_G.NEXT = 0;
                    //     end;
                    //PE-215.DK.4.0 13Feb2024 End
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(ShipToName);
                CLEAR(ShipToAddr);
                CLEAR(ShipTocity);
                CLEAR(ShipToCont);
                CLEAR(BillToName);
                CLEAR(BillToAddr);
                CLEAR(BillToCont);
                CLEAR(BillTocity);
                CLEAR(ShipToAddr2); //PE-114.RM.1.0 28July2023
                CLEAR(BillToAddr2);
                //PE-114.RM.1.0 28July2023

                IF "Job Quote Header"."NS_Job Ship-to Code" <> '' THEN BEGIN
                    T222.RESET;
                    T222.SETRANGE("Customer No.", "Job Quote Header"."NS_Sell-to Customer No.");
                    T222.SETRANGE(Code, "Job Quote Header"."NS_Job Ship-to Code");
                    IF T222.FINDFIRST THEN BEGIN
                        ShipToName := T222.Name;
                    END;

                    // ShipToAddr := "Job Quote Header"."NS_Job Address 1" + ' , ' + "Job Quote Header"."NS_Job Address 2" //PE-114.RM.1.0 28July2023 commented
                    ShipToAddr := "Job Quote Header"."NS_Job Address 1"; //PE-114.RM.1.0 28July2023
                    ShipToAddr2 := "Job Quote Header"."NS_Job Address 2"; //PE-114.RM.1.0 28July2023
                    ShipToCont := "Job Quote Header"."NS_Contact Name";
                    IF ("Job Quote Header"."NS_Job City" <> '') AND ("Job Quote Header"."NS_Job County" = '') AND ("Job Quote Header"."NS_Job Post Code" = '') THEN
                        ShipTocity := "Job Quote Header"."NS_Job City";
                    IF ("Job Quote Header"."NS_Job City" <> '') AND ("Job Quote Header"."NS_Job County" <> '') AND ("Job Quote Header"."NS_Job Post Code" = '') THEN
                        ShipTocity := "Job Quote Header"."NS_Job City" + ', ' + "Job Quote Header"."NS_Job County";
                    IF ("Job Quote Header"."NS_Job City" <> '') AND ("Job Quote Header"."NS_Job County" <> '') AND ("Job Quote Header"."NS_Job Post Code" <> '') THEN
                        ShipTocity := "Job Quote Header"."NS_Job City" + ', ' + "Job Quote Header"."NS_Job County" + ' ' + "Job Quote Header"."NS_Job Post Code";
                END;

                IF "Job Quote Header"."NS_Job Ship-to Code" = '' THEN BEGIN
                    //>>>>>>Old Code of report putted inside under conditions: ShipToAddr Data - start
                    AddressShipTo.RESET;
                    AddressShipTo.SETRANGE("NS_No.", "Job Quote Header"."NS_Job No.");
                    AddressShipTo.SETFILTER(Code, '<>%1', '');
                    IF AddressShipTo.FINDFIRST THEN BEGIN
                        ShipToName := AddressShipTo.Name;
                        ShipToAddr := AddressShipTo.Address;
                        ShipToAddr2 := AddressShipTo."Address 2"; //PE-114.RM.1.0 28July2023

                        ShipToCont := AddressShipTo.Contact;
                        IF (AddressShipTo.City <> '') AND (AddressShipTo.County = '') AND (AddressShipTo."Post Code" = '') THEN
                            ShipTocity := AddressShipTo.City;
                        IF (AddressShipTo.City <> '') AND (AddressShipTo.County <> '') AND (AddressShipTo."Post Code" = '') THEN
                            ShipTocity := AddressShipTo.City + ', ' + AddressShipTo.County;
                        IF (AddressShipTo.City <> '') AND (AddressShipTo.County <> '') AND (AddressShipTo."Post Code" <> '') THEN
                            ShipTocity := AddressShipTo.City + ', ' + AddressShipTo.County + ' ' + AddressShipTo."Post Code";
                    END ELSE BEGIN
                        CustRec_G.GET("Job Quote Header"."NS_Sell-to Customer No.");
                        ShipToName := CustRec_G.Name;
                        ShipToAddr := CustRec_G.Address;
                        ShipToAddr2 := CustRec_G."Address 2"; //PE-114.RM.1.0 28July2023
                        ShipToCont := CustRec_G.Contact;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County = '') AND (CustRec_G."Post Code" = '') THEN
                            ShipTocity := CustRec_G.City;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" = '') THEN
                            ShipTocity := CustRec_G.City + ', ' + CustRec_G.County;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" <> '') THEN
                            ShipTocity := CustRec_G.City + ', ' + CustRec_G.County + ' ' + CustRec_G."Post Code";
                    END;
                    //>>>>>>Old Code of report putted inside under conditions: ShipToAddr Data - End
                end;


                // SoldToData - start
                IF "Job Quote Header"."NS_Bill-to Customer No." <> '' THEN BEGIN
                    CustRec_G.RESET;
                    CustRec_G.SETRANGE("No.", "Job Quote Header"."NS_Bill-to Customer No.");
                    IF CustRec_G.FINDFIRST THEN BEGIN
                        BillToName := CustRec_G.Name;
                        BillToAddr := CustRec_G.Address;
                        BillToAddr2 := CustRec_G."Address 2"; //PE-114.RM.1.0 28July2023
                        BillToCont := CustRec_G.Contact;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County = '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" <> '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County + ' ' + CustRec_G."Post Code";
                    END;
                END;

                IF "Job Quote Header"."NS_Bill-to Customer No." = '' THEN BEGIN
                    CustRec_G.RESET;
                    CustRec_G.SETRANGE("No.", "Job Quote Header"."NS_Sell-to Customer No.");
                    IF CustRec_G.FINDFIRST THEN BEGIN
                        BillToName := CustRec_G.Name;
                        BillToAddr := CustRec_G.Address;
                        BillToAddr2 := CustRec_G."Address 2"; //PE-114.RM.1.0 28July2023
                        BillToCont := CustRec_G.Contact;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County = '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" <> '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County + ' ' + CustRec_G."Post Code";
                    END;
                END;
                IF "Job Quote Header"."NS_Payment Terms Code" <> '' THEN
                    PaymentTerms.GET("Job Quote Header"."NS_Payment Terms Code");
                IF "Job Quote Header"."NS_Salesperson Code New" <> '' THEN
                    Salesperson.GET("Job Quote Header"."NS_Salesperson Code New");
                IF "Job Quote Header"."NS_Shipment Method Code" <> '' THEN
                    ShipmentMethod.GET("Job Quote Header"."NS_Shipment Method Code");
            end;
        }

    }



    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
    //PE-215.DK.1.0 13Dec2023 Start
    trigger OnInitReport()
    begin
        if CompanyInformation.GET then;
        if CompanyInformation.City = '' then
            NS_CompanyInformationcity := ''
        else
            NS_CompanyInformationcity := CompanyInformation.City + ',' + ' ';
        if CompanyInformation.County = '' then
            NS_CompanyInformationCountry := ''
        else
            NS_CompanyInformationCountry := CompanyInformation.County + ' ';
        if CompanyInformation."Post Code" = '' then
            NS_CompanyInformationpost := ''
        else
            NS_CompanyInformationpost := CompanyInformation."Post Code";
        NS_CompanyFullAddress := NS_CompanyInformationcity + NS_CompanyInformationCountry + NS_CompanyInformationpost;

    end;
    //PE-215.DK.1.0 13Dec2023 End
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        //PE-114.RM.1.0 11July2023 start
        Clear(NS_TextCommaAdd1);
        Clear(NS_TextCommaAdd2);
        Clear(NS_TextCommaAdd3);
        if (CompanyInfo.Address <> '') and (CompanyInfo.City <> '') then
            NS_TextCommaAdd1 := ','
        else
            NS_TextCommaAdd1 := '';
        if CompanyInfo.County <> '' then
            NS_TextCommaAdd2 := ','
        else
            NS_TextCommaAdd2 := '';
        if CompanyInfo."Post Code" <> '' then
            NS_TextCommaAdd3 := ','
        else
            NS_TextCommaAdd3 := '';
        //PE-114.RM.1.0 11July2023 end
    end;

    var
        ShipToName: Text[100];
        ShipToCont: Text[60];
        ShipToAddr: Text[100];
        ShipToAddr2: Text[100]; //PE-114.RM.1.0 28July2023 
        ShipTocity: Text[100];
        BillToName: Text[100];
        BillToCont: Text[60];
        BillToAddr: Text[100];
        BillToAddr2: Text[100]; //PE-114.RM.1.0 28July2023
        BillTocity: Text[100];
        CustRec_G: Record "Customer";
        CompanyInfo: Record "Company Information";
        AddressShipTo: Record "Ship-to Address";
        // SalesPersonCap: Label 'Sales Person :'; //PE-114.RM.1.0 28July2023 commented
        SalesPersonCap: Label 'Salesperson:'; //PE-114.RM.1.0 28July2023
        SoldToCap: Label 'Sold To:';
        ShipToCap: Label 'Ship To:';
        TermsCap: Label 'Terms:';
        // ShipByCap: Label 'ShipBy:'; //PE-114.RM.1.0 28July2023 commented
        ShipByCap: Label 'Ship By:'; //PE-114.RM.1.0 28July2023
        POCap: Label 'PO:';
        PaymentTerms: Record "Payment Terms";
        Salesperson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        AcceptanceCap: Label 'ACCEPTANCE';
        Acceptance1Cap: Label 'This proposal, when accepted by the purchaser, and final approval of Seller''s Official Officer, will constitute a bona fide contract between us, subject to all terms and conditions on the reverse side.';
        Acceptance2Cap: Label 'It is expressly agreed that there are no promises, agreements, or understandings, oral or written, not specified in this proposal.';
        CompNameCap: Label 'Company Name';
        SignDateCap: Label 'Signature';
        PrintNameCap: Label 'Print Name';
        PrintTitleCap: Label 'Print Title';
        CustInitCap: Label 'Customer Initials';
        CronusConFiCap: Label 'Cronus Construction - Confidential';
        QuoteValidCap: Label 'Quotation valid for 30 days';
        ThisDocApplCap: Label 'This document does not reflect any applicable sales tax.';
        GrandTotalCap: Label 'GRAND TOTAL';
        NoCap: Label 'No.';
        DescCap: Label 'Description';
        QtyCap: Label 'Qty.';
        UnitCap: Label 'Unit';
        AmtCap: Label 'Amount';
        TotalPrice: Decimal;
        TotalBySegment: Decimal;
        JobTakeoffSegments_G: Record "Job Task";
        TotalPrice2: Decimal;
        T222: Record "Ship-to Address";
        //PE-114.RM.1.0 11July2023 start
        NS_TextCommaAdd1: Text[10];

        NS_TextCommaAdd2: Text[10];

        NS_TextCommaAdd3: Text[10];
        //PE-114.RM.1.0 11July2023 End
        //PE-215.DK.1.0 13Dec2023 Start
        CompanyInformation: Record "Company Information";
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
    //PE-215.DK.1.0 13Dec2023 End
}

