report 14021423 "NS_Job Quote Segment SOW"
{
    //PRJ-278.AS.1.0 27MAY2020 Created New Report
    //PPAL-34.AS.1.0 27JUNE2020 Created the report for PPAL
    //PPAL-83.NS.1.0 13AUG20 Changed Layout from BC14 as it was working proper there
    //PPAL-83.AS.1.0 13AUG20 Changed Layout from BC16 as it was working proper there
    //PPAL-32.AS.1.0 27Aug2020 Done code for ship to address
    //PRJ-1180.RM.1.0 10Feb2022 | Added a column to dataitem
    //PRJ-1595.GK.1.0 01Sep2022 |Changes in Layout for removing INTERNAL USE ONLY caption.
    //PE-141.RM.1.0 22Aug2023 | Did some changes in the layout.
    DefaultLayout = RDLC;
    Caption = 'Job Quote Segment SOW';
    RDLCLayout = './Layouts/NSJobQuoteSegmentSOW.rdl';

    dataset
    {
        dataitem("Job Quote Header"; "NS_Job Quote Header")
        {
            RequestFilterFields = "NS_Quote No.";
            column(SalesPersonCap; SalesPersonCap)
            {
            }
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
            //PE-141.RM.1.0 23Aug2023 start
            // column(CustInitCap; CustInitCap)
            // {
            // }
            column(NS_Salesperson_User_ID; "NS_Salesperson/User ID")
            {
            }
            //PE-141.RM.1.0 23Aug2023
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
            //PRJ-1180.RM.1.0 10Feb2022 start
            column(Company_Name; CompanyInfo.Name)
            {
            }
            //PRJ-1180.RM.1.0 10Feb2022 end
            //PE-141.RM.1.0 22Aug2023 start
            column(NS_TextCommaAdd; NS_TextCommaAdd)
            {
            }
            //PE-141.RM.1.0 22Aug2023  end
            column(QuoteNo_JobQuoteHeader; "Job Quote Header"."NS_Quote No.")
            {
            }
            //PE-141.RM.1.0 23Aug2023 start
            // column(ProposalDate_JobQuoteHeader; FORMAT("Job Quote Header"."NS_Proposal Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            // {
            // }
            column(NS_Today; format(WorkDate(), 0, '<Month,2>-<Day,2>-<Year4>'))
            {
            }
            column(ProposalDate_JobQuoteHeader; FORMAT("Job Quote Header"."NS_Proposal Date", 0, '<Month,2>-<Day,2>-<Year4>'))
            {
            }
            //PE-141.RM.1.0 23Aug2023 End
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
            dataitem("Job Takeoff Segments"; "NS_Job Takeoff Segments")
            {
                DataItemLink = "NS_Job No." = FIELD("NS_Quote No.");
                column(SegmentCode_JobTakeoffSegments; "Job Takeoff Segments"."NS_Segment Code")
                {
                }
                column(SegmentName_JobTakeoffSegments; "Job Takeoff Segments"."NS_Segment Name")
                {
                }
                column(Qty_JobTakeoffSegments; "Job Takeoff Segments"."NS_Work Units")
                {
                }
                column(WorkUnitofMeasure_JobTakeoffSegments; "Job Takeoff Segments"."NS_Work Unit of Measure")
                {
                }
                column(TotalPrice; TotalPrice)
                {
                }
                column(TotalBySegment; TotalBySegment)
                {
                }
                dataitem("Job Quote Scope of Work"; "NS_Job Quote Scope of Work")
                {
                    DataItemLink = "NS_Quote No." = FIELD("NS_Job No."),
                                   "NS_Segment Code" = FIELD("NS_Segment Code");
                    column(Description_JobQuoteScopeofWork; "Job Quote Scope of Work".NS_Description)
                    {
                    }
                    column(Description2_JobQuoteScopeofWork; "Job Quote Scope of Work"."NS_Description 2")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(TotalPrice);


                    JobTakeoffSegments_G.RESET;
                    JobTakeoffSegments_G.SETRANGE("NS_Job No.", "Job Takeoff Segments"."NS_Job No.");
                    JobTakeoffSegments_G.SETRANGE("NS_Segment Code", "Job Takeoff Segments"."NS_Segment Code");
                    IF JobTakeoffSegments_G.FINDFIRST THEN BEGIN
                        JobTakeoffSegments_G.CALCFIELDS("NS_Schedule (Total Price)");
                        IF JobTakeoffSegments_G."NS_Total Contract Price" = 0 THEN
                            TotalPrice := JobTakeoffSegments_G."NS_Schedule (Total Price)";

                        IF JobTakeoffSegments_G."NS_Total Contract Price" <> 0 THEN
                            TotalPrice := JobTakeoffSegments_G."NS_Total Contract Price";
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    CLEAR(TotalPrice2);
                    CLEAR(TotalBySegment);
                    //PE-141.RM.1.0 22Aug2023 start
                    Clear(NS_TextCommaAdd);
                    if (CompanyInfo.City <> '') and (CompanyInfo.County <> '') then
                        NS_TextCommaAdd := ','
                    else
                        NS_TextCommaAdd := '';
                    //PE-141.RM.1.0 22Aug2023 End
                    JobTakeoffSegments_G.RESET;
                    JobTakeoffSegments_G.SETRANGE("NS_Job No.", "Job Quote Header"."NS_Quote No.");
                    IF JobTakeoffSegments_G.FINDSET THEN
                        REPEAT

                            JobTakeoffSegments_G.CALCFIELDS("NS_Schedule (Total Price)");
                            IF JobTakeoffSegments_G."NS_Total Contract Price" = 0 THEN
                                TotalPrice2 := JobTakeoffSegments_G."NS_Schedule (Total Price)";

                            IF JobTakeoffSegments_G."NS_Total Contract Price" <> 0 THEN
                                TotalPrice2 := JobTakeoffSegments_G."NS_Total Contract Price";
                            TotalBySegment += TotalPrice2;
                        UNTIL JobTakeoffSegments_G.NEXT = 0;
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
                //PPAL-32.AS.1.0 27Aug2020 - start
                IF "Job Quote Header"."NS_Job Ship-to Code" <> '' THEN BEGIN
                    T222.RESET;
                    T222.SETRANGE("Customer No.", "Job Quote Header"."NS_Sell-to Customer No.");
                    T222.SETRANGE(Code, "Job Quote Header"."NS_Job Ship-to Code");
                    IF T222.FINDFIRST THEN BEGIN
                        ShipToName := T222.Name;
                    END;
                    ShipToAddr := "Job Quote Header"."NS_Job Address 1" + ' , ' + "Job Quote Header"."NS_Job Address 2";
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
                //PPAL-32.AS.1.0 27Aug2020 - end

                // SoldToData - start
                IF "Job Quote Header"."NS_Bill-to Customer No." <> '' THEN BEGIN
                    CustRec_G.RESET;
                    CustRec_G.SETRANGE("No.", "Job Quote Header"."NS_Bill-to Customer No.");
                    IF CustRec_G.FINDFIRST THEN BEGIN
                        BillToName := CustRec_G.Name;
                        BillToAddr := CustRec_G.Address;
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
                        BillToCont := CustRec_G.Contact;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County = '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" = '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County;
                        IF (CustRec_G.City <> '') AND (CustRec_G.County <> '') AND (CustRec_G."Post Code" <> '') THEN
                            BillTocity := CustRec_G.City + ', ' + CustRec_G.County + ' ' + CustRec_G."Post Code";
                    END;
                END;
                // SoldToData - End
                IF "Job Quote Header"."NS_Payment Terms Code" <> '' THEN
                    PaymentTerms.GET("Job Quote Header"."NS_Payment Terms Code");

                // IF "Job Quote Header"."NS_Salesperson Code" <> '' THEN//PRJ-867.AS.1.0 23SEPT2021 Comment
                //     Salesperson.GET("Job Quote Header"."NS_Salesperson Code");//PRJ-867.AS.1.0 23SEPT2021 Comment


                IF "Job Quote Header"."NS_Salesperson Code New" <> '' THEN//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
                    Salesperson.GET("Job Quote Header"."NS_Salesperson Code New");//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New


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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        ShipToName: Text[100];
        ShipToCont: Text[60];
        ShipToAddr: Text[100];
        ShipTocity: Text[100];
        BillToName: Text[100];
        BillToCont: Text[60];
        BillToAddr: Text[100];
        BillTocity: Text[100];
        CustRec_G: Record "Customer";
        CompanyInfo: Record "Company Information";
        AddressShipTo: Record "Ship-to Address";
        SalesPersonCap: Label 'Sales Person :';
        SoldToCap: Label 'Sold To:';
        ShipToCap: Label 'Ship To:';
        TermsCap: Label 'Terms:';
        ShipByCap: Label 'ShipBy:';
        POCap: Label 'PO:';
        PaymentTerms: Record "Payment Terms";
        Salesperson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        AcceptanceCap: Label 'ACCEPTANCE';
        Acceptance1Cap: Label 'This proposal, when accepted by the purchaser, and final approval of Seller''s Official Officer, will constitute a bona fide contract between us, subject to all terms and conditions on the reverse side.';
        Acceptance2Cap: Label 'It is expressly agreed that there are no promises, agreements or understandings, oral or written, not specified in this proposal.';
        //PE-141.RM.1.0 23Aug2023 start
        // CompNameCap: Label 'Company Name _____________________________________________________________';
        // SignDateCap: Label 'Signature ______________________________________________ Date _______________';
        // PrintNameCap: Label 'Print Name _________________________________________________________________';
        // PrintTitleCap: Label 'Print Title __________________________________________________________________';
        // CustInitCap: Label 'Customer Initials_______________   Cronus Construction Initials ___________';
        CompNameCap: Label 'Company Name';
        SignDateCap: Label 'Signature';
        PrintNameCap: Label 'Print Name';
        PrintTitleCap: Label 'Print Title';
        //PE-141.RM.1.0 23Aug2023 End
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
        JobTakeoffSegments_G: Record "NS_Job Takeoff Segments";
        TotalPrice2: Decimal;
        NS_TextCommaAdd: Text[10]; //PE-141.RM..1.0 22Aug2023
        T222: Record "Ship-to Address";//PPAL-32.AS.1.0 27Aug2020
}

