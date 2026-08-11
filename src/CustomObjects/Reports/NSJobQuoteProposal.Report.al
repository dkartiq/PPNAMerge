report 14021400 "NS_Job Quote/Proposal"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PPAL-32.AS.1.0 14Aug2020 Done code for ship to address and also removed a useless variable Shiptoaddress[5] from layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob QuoteProposal.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Quote/Proposal';
    UseRequestPage = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(QuoteHeader_Title; DocumentTitle)
            {
            }
            column(QuoteHeader_Draft; Draft)
            {
            }
            column(QuoteHeader_QuoteNo_; QuoteHeader."NS_Quote No.")
            {
            }
            column(QuoteHeader_RevisionNo_; QuoteHeader.NS_Revision)
            {
            }
            column(QuoteHeader_Proposal; QuoteHeader."NS_Equipment Only")
            {
            }
            column(QuoteHeader_LinkToQuoteNo_; QuoteHeader."NS_Link-to Quote No.")
            {
            }
            column(QuoteHeader_ProposalDate; QuoteHeader."NS_Proposal Date")
            {
            }
            column(QuoteHeader_SellToCustomerNo_; QuoteHeader."NS_Sell-to Customer No.")
            {
            }
            column(QuoteHeader_BillToCustomerNo_; QuoteHeader."NS_Bill-to Customer No.")
            {
            }
            column(QuoteHeader_LocationCode; QuoteHeader."NS_Location Code")
            {
            }
            column(QuoteHeader_PaymentTermsCode; QuoteHeader."NS_Payment Terms Code")
            {
            }
            column(QuoteHeader_SalespersonCode; QuoteHeader."NS_Salesperson Code New")//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            {
            }
            column(QuoteHeader_ContactNo_; QuoteHeader."NS_Contact No.")
            {
            }
            column(QuoteHeader_ContactName; QuoteHeader."NS_Contact Name")
            {
            }
            column(QuoteHeader_OwnerName; QuoteHeader."NS_Owner Name")
            {
            }
            column(QuoteHeader_GeneralContractorName; QuoteHeader."NS_General Contractor Name")
            {
            }
            column(QuoteHeader_ArchitectEngineerName; QuoteHeader."NS_Architect/Engineer Name")
            {
            }
            column(QuoteHeader_ProjectManagerName; QuoteHeader."NS_Project Manager Name")
            {
            }
            column(QuoteHeader_EstimatorName; QuoteHeader."NS_Estimator Name")
            {
            }
            column(QuoteHeader_ExtDocNo; QuoteHeader."NS_External Document No.")
            {
            }
            column(QuoteHeader_DepositRequired; QuoteHeader."NS_Deposit Required")
            {
            }
            column(QuoteHeader_PrintSalesTax; QuoteHeader."NS_Print Sales Tax")
            {
            }
            column(HeaderComments; TempBuf."NS_Header Comment")
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
            column(Customer_Name; Customer.Name)
            {
            }
            column(SellToAddress_1; SellToAddress[1])
            {
            }
            column(SellToAddress_2; SellToAddress[2])
            {
            }
            column(SellToAddress_3; SellToAddress[3])
            {
            }
            column(SellToAddress_4; SellToAddress[4])
            {
            }
            column(SellToAddress_5; SellToAddress[5])
            {
            }
            column(ShipToAddress_1; ShipToAddress[1])
            {
            }
            column(ShipToAddress_2; ShipToAddress[2])
            {
            }
            column(ShipToAddress_3; ShipToAddress[3])
            {
            }
            column(ShipToAddress_4; ShipToAddress[4])
            {
            }
            column(ShipToAddress_5; ShipToAddress[5])
            {
            }
            column(BillToAddress_1; BillToAddress[1])
            {
            }
            column(BillToAddress_2; BillToAddress[2])
            {
            }
            column(BillToAddress_3; BillToAddress[3])
            {
            }
            column(BillToAddress_4; BillToAddress[4])
            {
            }
            column(BillToAddress_5; BillToAddress[5])
            {
            }
            column(PaymentTerms_Description; PaymentTerms.Description)
            {
            }
            column(Salesperson_Name; Salesperson.Name)
            {
            }
            column(Salesperson_EMail; Salesperson."E-Mail")
            {
            }
            column(Salesperson_PhoneNo; Salesperson."Phone No.")
            {
            }
            column(ShipmentMethod_Description; ShipmentMethod.Description)
            {
            }
            column(SalesTaxDisclaimer; SalesTaxDisclaimer)
            {
            }
            column(QuoteLine_Indentation; TempBuf.NS_Indentation)
            {
            }
            column(QuoteLine_Type; TempBuf.NS_Type)
            {
            }
            column(QuoteLine_No_; TempBuf."NS_No.")
            {
            }
            column(QuoteLine_No2_; TempBuf."NS_No. 2")
            {
            }
            column(QuoteLine_Description; TempBuf.NS_Description)
            {
            }
            column(QuoteLine_Quantity; TempBuf.NS_Quantity)
            {
            }
            column(QuoteLine_UnitOfMeasure; TempBuf."NS_Unit of Measure Code")
            {
            }
            column(QuoteLine_UnitPrice; TempBuf."NS_Total Price")
            {
            }
            column(QuoteLine_Amount; TempBuf.NS_Amount)
            {
            }
            column(QuoteLine_AmountInclVAT; TempBuf."NS_Amount Including VAT")
            {
            }
            column(QuoteLine_LineDiscAmount; TempBuf."NS_Line Discount Amount")
            {
            }
            column(QuoteLine_LineDiscPct; TempBuf."NS_Line Discount %")
            {
            }
            column(QuoteLine_FreightAmt; TempBuf.NS_Freight)
            {
            }
            column(QuoteLine_EquipAmt; TempBuf."NS_Equipment Subtotal")
            {
            }
            column(QuoteLine_InstallAmt; TempBuf."NS_Installation Subtotal")
            {
            }
            column(QuoteLine_BondsAmt; TempBuf."NS_Bonds Subtotal")
            {
            }
            column(QuoteLine_ServiceAmt; TempBuf."NS_Service Subtotal")
            {
            }
            column(QuoteLine_Name; TempBuf.NS_Name)
            {
            }
            column(QuoteBySegment; BySegment)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Number = 1 then
                    TempBuf.FINDSET(false)
                else
                    if TempBuf.NEXT = 0 then;
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE(Number, 1, TempBuf.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Quote/Proposal")
                {
                    Caption = 'Quote/Proposal';
                    field("QuoteHeader.""Quote No."""; QuoteHeader."NS_Quote No.")
                    {
                        Caption = 'No.';
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Quaote Number';
                    }
                    field("QuoteHeader.""Description/Nickname"""; QuoteHeader."NS_Description/Nickname")
                    {
                        Caption = 'Description';
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Quote Description';
                    }
                    field("QuoteHeader.""Sell-to Customer No."""; QuoteHeader."NS_Sell-to Customer No.")
                    {
                        Caption = 'Site Customer No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("QuoteHeader.""Sell-to Customer Name"""; QuoteHeader."NS_Sell-to Customer Name")
                    {
                        Caption = 'Site Customer Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("QuoteHeader.""Bill-to Customer No."""; QuoteHeader."NS_Bill-to Customer No.")
                    {
                        Caption = 'Bill-to Customer No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("QuoteHeader.""Bill-to Customer Name"""; QuoteHeader."NS_Bill-to Customer Name")
                    {
                        Caption = 'Bill-to Customer Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("QuoteHeader.""Contact No."""; QuoteHeader."NS_Contact No.")
                    {
                        Caption = 'Contact No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("QuoteHeader.""Contact Name"""; QuoteHeader."NS_Contact Name")
                    {
                        Caption = 'Contact Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
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

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        DocumentTitle := Text000;  // Quotation

        if QuoteHeader."NS_Link-to Quote No." = '' then
            QuoteHeader."NS_Link-to Quote No." := QuoteHeader."NS_Quote No.";
    end;

    var

        T222: Record "Ship-to Address";//PPAL-32.AS.1.0 14Aug2020
        AddressBillTo: Record "Ship-to Address";
        AddressSellTo: Record "Ship-to Address";
        AddressShipTo: Record "Ship-to Address";
        CompanyInfo: Record "Company Information";
        Contact: Record Contact;
        Customer: Record Customer;
        PaymentTerms: Record "Payment Terms";
        QuoteHeader: Record "NS_Job Quote Header";
        Salesperson: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        TempBuf: Record "NS_Job Quote Sel. Buf." temporary;
        QuoteNo: Code[20];
        Draft: Integer;
        EntryNo: Integer;
        DocumentTitle: Text[30];
        Text000: Label 'Quotation';
        Text001: Label 'Proposal';
        Text002: Label 'Preview not allowed when document is printing as a draft.';
        Text003: Label 'This document does not reflect any applicable sales tax.';
        SalesTaxDisclaimer: Text[250];
        Text004: Label 'Change Proposal';
        CustomerBillTo: Record Customer;
        CustomerShipTo: Record Customer;
        CustomerSellTo: Record Customer;
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        SellToAddress: array[8] of Text[50];
        FormatAddress: Codeunit "Format Address";
        BySegment: Boolean;

    procedure InsertTempBuf(var _TempBuf: Record "NS_Job Quote Sel. Buf." temporary);
    begin
        EntryNo += 1;
        TempBuf := _TempBuf;
        TempBuf."NS_Entry No." := EntryNo;
        TempBuf.INSERT();
    end;

    procedure Initialize(_QuoteHeader: Record "NS_Job Quote Header");
    begin
        QuoteHeader.GET(_QuoteHeader."NS_Quote No.");

        case _QuoteHeader."NS_Job Class" of
            _QuoteHeader."NS_Job Class"::"Change Order":
                DocumentTitle := Text004;
        end;

        if not Contact.GET(_QuoteHeader."NS_Contact No.") then
            Contact.INIT();

        if not CustomerBillTo.GET(_QuoteHeader."NS_Bill-to Customer No.") then begin
            if not CustomerBillTo.GET(_QuoteHeader."NS_Sell-to Customer No.") then begin
                CustomerBillTo.INIT();
                FormatAddress.ContactAddr(BillToAddress, Contact);
            end else
                FormatAddress.Customer(BillToAddress, CustomerBillTo)
        end else
            FormatAddress.Customer(BillToAddress, CustomerBillTo);

        if not CustomerSellTo.GET(_QuoteHeader."NS_Sell-to Customer No.") then begin
            CustomerSellTo.INIT();
            FormatAddress.ContactAddr(SellToAddress, Contact);
        end else
            FormatAddress.Customer(SellToAddress, CustomerSellTo);

        //PPAL-32.AS.1.0 14Aug2020 - start
        IF _QuoteHeader."NS_Job Ship-to Code" <> '' THEN BEGIN
            T222.RESET;
            T222.SETRANGE("Customer No.", _QuoteHeader."NS_Sell-to Customer No.");
            T222.SETRANGE(Code, _QuoteHeader."NS_Job Ship-to Code");
            IF T222.FINDFIRST THEN BEGIN
                ShipToAddress[1] := T222.Name;
            END;
            ShipToAddress[2] := _QuoteHeader."NS_Job Address 1";
            ShipToAddress[3] := _QuoteHeader."NS_Job Address 2";
            ShipToAddress[4] := _QuoteHeader."NS_Job City" + ', ' + _QuoteHeader."NS_Job County" + ' ' + _QuoteHeader."NS_Job Post Code";
        END;

        IF _QuoteHeader."NS_Job Ship-to Code" = '' THEN BEGIN
            //>>>>>>Old Code of report putted inside under conditions - start
            AddressShipTo.RESET();
            AddressShipTo.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
            AddressShipTo.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
            AddressShipTo.SETRANGE("NS_Address Type", AddressShipTo."NS_Address Type"::"Ship-to");
            IF NOT AddressShipTo.FINDFIRST() THEN BEGIN
                AddressShipTo.INIT();
                COPYARRAY(ShipToAddress, SellToAddress, 1, 8);
            END ELSE BEGIN
                ShipToAddress[1] := AddressShipTo.Name;
                ShipToAddress[2] := AddressShipTo.Address;
                ShipToAddress[3] := AddressShipTo."Address 2";
                ShipToAddress[4] := AddressShipTo.City + ', ' + AddressShipTo.County + ' ' + AddressShipTo."Post Code";
                COMPRESSARRAY(ShipToAddress);
            END;
            //>>>>>>Old Code of report putted inside under conditions - end
        END;
        //PPAL-32.AS.1.0 14Aug2020 - end

        AddressBillTo.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
        AddressBillTo.SETRANGE("NS_No.", _QuoteHeader."NS_Quote No.");
        AddressBillTo.SETRANGE("NS_Address Type", AddressBillTo."NS_Address Type"::"Bill-to");
        if AddressBillTo.FINDFIRST() then begin
            BillToAddress[1] := AddressBillTo.Name;
            BillToAddress[2] := AddressBillTo.Address;
            BillToAddress[3] := AddressBillTo."Address 2";
            BillToAddress[4] := AddressBillTo.City + ', ' + AddressBillTo.County + ' ' + AddressBillTo."Post Code";
            COMPRESSARRAY(BillToAddress);
        end;

        if not Customer.GET(_QuoteHeader."NS_Bill-to Customer No.") then
            Customer.INIT();

        if not PaymentTerms.GET(QuoteHeader."NS_Payment Terms Code") then
            PaymentTerms.INIT();

        if not Salesperson.GET(QuoteHeader."NS_Salesperson Code New") then//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            Salesperson.INIT();

        if not ShipmentMethod.GET(QuoteHeader."NS_Shipment Method Code") then
            ShipmentMethod.INIT();

        CLEAR(SalesTaxDisclaimer);
        if not _QuoteHeader."NS_Print Sales Tax" then
            SalesTaxDisclaimer := Text003;

        CLEAR(TempBuf);
        TempBuf.DELETEALL;
    end;

    procedure SetDraft(_Draft: Boolean);
    begin
        Draft := 1;
    end;

    procedure SetProposal();
    begin
        DocumentTitle := Text001;  // Proposal
    end;

    procedure SetBySegment(PassBySegment: Boolean);
    begin
        BySegment := PassBySegment;
    end;
}

