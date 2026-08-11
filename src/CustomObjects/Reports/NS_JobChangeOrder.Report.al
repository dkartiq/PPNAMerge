report 14021333 "NS_Job Change Order"
{
    //PRJ-737.RM.1.0 16March2022 Created a New Report 

    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJobChangeOrder.rdl';
    Caption = 'Job Change Order';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    dataset
    {
        dataitem(JobDI; Job)
        {
            DataItemTableView = SORTING("No.") where("NS_Job Class" = filter("change Order"));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Job';

            column(No_PurchHdr; "NS_Quote No.")
            {
            }
            column(NS_Project_Manager_Name; User."Full Name")
            {

            }
            column(NS_Customer_PO_Number; "NS_Customer PO Number")
            {

            }
            column(Estimated_StartDate; "NS_Estimated Start Date")
            {

            }
            column(Estimated_CompletionDate; "NS_Estimated Completion Date")
            {

            }
            //PRJ-737.RM.1.0 commented
            //column(NS_Revision; NS_Revision)
            //{

            //}
            //column(NS_Payment_Terms_Code; "Payment Terms Code")
            //{

            //}
            column(ShowDetails; ShowDetails)
            {

            }
            column(ShowProcesses; ShowProcesses)
            {
            }
            column(ShowOperations; ShowOperations)
            {
            }
            //PRJ-737.RM.1.0 commented
            // column(GSTPer; "GST %")
            // {

            // }
            column(QuoteHeader_ProposalDate; "NS_Contract Date")
            {

            }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(BillToAddress_1; BillToAddressText[1])
                    {
                    }
                    column(BillToAddress_2; BillToAddressText[2])
                    {
                    }
                    column(BillToAddress_3; BillToAddressText[3])
                    {
                    }
                    column(CustomerBillTohomePage; CustomerBillTo."Home Page")
                    { }

                    column(CustomerBillToCurr; CurrencyCode)
                    {

                    }
                    column(ContactName; CustomerContact.Name)
                    {

                    }
                    column(ContactPhoneNo; CustomerContact."Phone No.")
                    {

                    }
                    column(ContactEmail; CustomerContact."E-Mail")
                    {

                    }
                    column(Salesperson_PhoneNo; Salesperson."Phone No.")
                    {
                    }
                    column(Salesperson_Name; Salesperson.Name)
                    {
                    }
                    column(Salesperson_EMail; Salesperson."E-Mail")
                    {
                    }
                    column(PaymentTerms_Description; PaymentTerms.Description)
                    {
                    }

                    column(ShipToAddress_1; ShipToAddressText[1])
                    {
                    }
                    column(ShipToAddress_2; ShipToAddressText[2])
                    {
                    }
                    column(ShipToAddress_3; ShipToAddressText[3])
                    {
                    }
                    column(ShipmentMethod_Description; ShipmentMethod.Description)
                    {
                    }
                    column(QuoteHeader_LinkToQuoteNo_; JobDI."No.")
                    {
                    }

                    column(CompInfo_Name; CompInfo.Name)
                    {
                    }
                    column(JobNo; JobDI."No.")
                    {
                    }

                    column(CompInfo_Name2; CompInfo."Name 2")
                    {
                    }
                    column(CompInfo_Address; CompInfo.Address)
                    {
                    }
                    column(CompInfo_Address2; CompInfo."Address 2")
                    {
                    }
                    column(CompInfo_City; CompInfo.City + ' ' + CompInfo.County + ' ' + CompInfo."Post Code")
                    {
                    }
                    column(CompInfo_PhoneNo; 'Phone ' + CompInfo."Phone No.")
                    {
                    }
                    column(CompInfo_Email; CompInfo."E-Mail")
                    {
                    }

                    column(CompInfo_HomePage; CompInfo."Home Page")
                    {
                    }
                    //PRJ-737.RM.1.0 commented
                    // column(CompInfo_ABN; '(ABN' + ' ' + CompInfo.ABN + ')')
                    // {
                    // }
                    column(CompInfo_Pic; CompInfo.Picture)
                    {
                    }
                    column(VendName; Vendor.Name + ' ' + Vendor."Name 2")
                    {
                    }
                    //PRJ-737.RM.1.0 commented
                    // column(VendorABN; vendor.ABN)
                    // {

                    // }

                    column(VendAddress; Vendor.Address)
                    {
                    }
                    column(VendorCode; Vendor."No.")
                    {
                    }

                    column(VendAddress2; Vendor.County + ' ' + Vendor."Post Code")
                    {
                    }
                    column(PhoneNo; Vendor."Phone No.")
                    {
                    }
                    column(Email; Vendor."E-Mail")
                    {
                    }
                    column(PaymentTerms; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodCode; ShipmentMethod.Description)
                    {
                    }
                    column(VendCountryName; CountryRegion.Name)
                    {
                    }

                    column(PortofDischarge; EntryExitPoint.Description)
                    {
                    }
                    dataitem(JobPlanningLineDI; "Job Planning Line")
                    {
                        DataItemTableView = where("line Type" = Filter(Billable | "Both Budget and Billable"));
                        DataItemLink = "Job No." = FIELD("No.");
                        DataItemLinkReference = JobDI;
                        column(Unit_Price; "Unit Price")
                        {
                        }
                        column(Total_Price; "Total Price")
                        {
                        }
                        column(Quantity; Quantity)
                        {

                        }
                        column(VAT_Line_Amount; "VAT Line Amount")
                        {

                        }
                        column(Type; Type)
                        {
                        }

                        column(Unit_of_Measure_Code; "Unit of Measure Code")
                        {
                        }
                        column(No_; "No.")
                        { }
                        column(Description; Description)
                        { }
                        column(Activity_Activity; Activity)
                        {
                        }
                        column(Process_Code; process)
                        {
                        }
                        column(Operation_Code; Operation)
                        {
                        }

                        column(JobOperationDes; UPPERCASE(JobOperation.NS_Description))
                        {
                        }
                        column(JobProcessDescription; UPPERCASE(JobProcess.NS_Description))
                        {
                        }
                        column(JobActivityDescription; UPPERCASE(JobActivity.NS_Description))
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            Job: record job;
                        begin
                            //PRJ-737.RM.1.0 commented start
                            // ShowonPO := FALSE;
                            // JobPlanningLineDI.CalcFields("Take Off Lines");
                            // TakeOffCaptionTxt := '';
                            // clear(TakeOffDetailArray);
                            // IF "Take Off Lines" then BEGIN
                            //     ShowonPO := TRUE;
                            //     CalculateTakeOffText(JobPlanningLineDI."Job No.", JobPlanningLineDI."Job Task No.", "Line No.");
                            // End;
                            //PRJ-737.RM.1.0 commented end
                            if Item.Get(JobPlanningLineDI."No.") then;

                            TotalSubTotal += "Line Amount";
                            Job.NS_JobTaskNoToAPo("Job Task No.", Activity, Process, Operation, Section);
                            JobActivity.Reset;
                            JobProcess.Reset;
                            JobOperation.Reset;
                            IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN;
                            IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, Process) THEN;
                            IF JobOperation.get(JobOperation.NS_Type::Cost, Activity, Process, Operation) THEN;
                            if ShowProcesses and (Process <> '') then BEGIN
                                Process := Process;

                            end else begin
                                Process := '';

                            end;
                            if ShowOperations and (Operation <> '') then BEGIN
                                Operation := Operation;

                            end else BEGIN
                                Operation := '';

                            end;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var


                    begin

                    end;
                }


                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;

                    CommentSerialNo := 0;
                    Clear(PurchLine);
                    // Clear(PurchPost);   //PRJ-737.RM.1.0 commented
                    TotalSubTotal := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclGST := 0;
                    TotalInvoiceDiscountAmount := 0;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                User.Reset;
                IF UserSetup.GET("Project Manager") THEN;
                User.Setrange("User Name", UserSetup."User ID");
                IF User.FindFirst() THEN;

                IF Salesperson.get("NS_Salesperson Code") THEN;
                if not CustomerSellTo.GET("NS_Sell-to Customer No.") then begin
                    CustomerSellTo.INIT();
                    // CreateSellToAddress(Contact.Name, Contact.Address, Contact."Address 2", contact.City, Contact.County, Contact."Post Code");  //PRJ-737.RM.1.0 commented
                end else
                    //   CreateSellToAddress(CustomerSellTo.Name, CustomerSellTo.Address, CustomerSellTo."Address 2", CustomerSellTo.City, CustomerSellTo.County, CustomerSellTo."Post Code");  //PRJ-737.RM.1.0 commented
                    IF CustomerContact.GET(CustomerSellTo."Primary Contact No.") THEN;

                if not CustomerBillTo.GET("Bill-to Customer No.") then begin
                    if not CustomerBillTo.GET("NS_Sell-to Customer No.") then begin
                        CustomerBillTo.INIT();
                        //    CreateBillToAddress(Contact.Name, Contact.Address, Contact."Address 2", contact.City, Contact.County, Contact."Post Code");   //PRJ-737.RM.1.0 commented
                    end else
                        //  CreateSellToAddress(CustomerSellTo.Name, CustomerSellTo.Address, CustomerSellTo."Address 2", CustomerSellTo.City, CustomerSellTo.County, CustomerSellTo."Post Code");  //PRJ-737.RM.1.0 commented
                        //end else
                        // CreateBillToAddress("Bill-to Name", "Bill-to Address", "Bill-to Address 2", "Bill-to City", "Bill-to County", "Bill-to Post Code");  //PRJ-737.RM.1.0 commented
                        AddressBillTo.SETRANGE("NS_Table ID", DATABASE::Job);
                    AddressBillTo.SETRANGE("NS_No.", "No.");
                    AddressBillTo.SETRANGE("NS_Address Type", AddressBillTo."NS_Address Type"::"Bill-to");
                    if AddressBillTo.FINDFIRST() then
                        // CreateBillToAddress(AddressBillTo.Name, AddressBillTo.Address, AddressBillTo."Address 2", AddressBillTo.City, AddressBillTo.County, AddressBillTo."Post Code");  //PRJ-737.RM.1.0 commented
                        PaymentTerms.reset;
                    ShipmentMethod.reset;

                    IF "NS_Job Ship-to Code" <> '' THEN BEGIN
                        T222.RESET;
                        T222.SETRANGE("Customer No.", "NS_Sell-to Customer No.");
                        T222.SETRANGE(Code, "NS_Job Ship-to Code");
                        // IF T222.FINDFIRST THEN
                        // CreateShipToAddress(T222.Name, T222.Address, T222."Address 2", T222.City, T222.County, T222."Post Code");  //PRJ-737.RM.1.0 commented
                    END;
                    IF "NS_Job Ship-to Code" = '' THEN BEGIN
                        AddressShipTo.RESET();
                        AddressShipTo.SETRANGE("NS_Table ID", DATABASE::"Job");
                        AddressShipTo.SETRANGE("NS_No.", "No.");
                        AddressShipTo.SETRANGE("NS_Address Type", AddressShipTo."NS_Address Type"::"Ship-to");
                        IF NOT AddressShipTo.FINDFIRST() THEN BEGIN
                            AddressShipTo.INIT();
                            ShipToAddressText[1] := SellToAddressText[1];
                            ShipToAddressText[2] := SellToAddressText[2];
                            ShipToAddressText[3] := SellToAddressText[3];
                            //END ELSE
                            // CreateShipToAddress(AddressShipTo.Name, AddressShipTo.Address, AddressShipTo."Address 2", AddressShipTo.City, AddressShipTo.County, AddressShipTo."Post Code");  //PRJ-737.RM.1.0 commented
                        END;
                        CurrencyCode := CustomerBillTo."Currency Code";
                        IF CustomerBillTo."Currency Code" = '' then
                            CurrencyCode := 'AUD';

                    end;
                end;  //PRJ-737.RM.1.0 commented
            end;  //PRJ-737.RM.1.0 commented

            trigger OnPreDataItem()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
            end;

        }
    }
    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                field("Show Processes"; ShowProcesses)
                {
                    Caption = 'Show Processes';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if not ShowProcesses then
                            ShowOperations := false;
                    end;
                }
                field("Show Operations"; ShowOperations)
                {
                    Caption = 'Show Operations';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if ShowOperations then
                            ShowProcesses := true;
                    end;
                }
                field("Show Details"; ShowDetails)
                {
                    Caption = 'Show Details';
                    ApplicationArea = All;
                }
            }
        }
    }

    labels
    {

        CustomerSupport = 'Customer Support  1300 556 241';
        SKUNoLbl = 'Stock Code';
        ProductNameLbl = 'Description';
        UOMLbl = 'Units';
        QuantityLbl = 'Total Qty';
        UnitPriceLbl = 'Unit Price';
        AmountLbl = 'Total Cost';
        SubTotalLbl = 'Sub Total';
        GSTAmtLbl = 'Gst Amount';
        TotalAmountLbl = 'Total Amount($)';
        OrderDateLbl = 'Order Date';
        CurrLbl = 'Currency';
        DestinationPortLbl = 'Destination Port';
        PaymentTermsLbl = 'Payment Terms';
        ShipmentTermsLbl = 'Shipment Terms';
        TotalWt = 'Total Weight';
        PCSLbl = 'PCS / PLT.';
        SQMLbl = 'SQM / PLT.';
        WeightLbl = 'Weight / Crate';
        SizeLbl = 'Size';

        Text001 = 'a) Mention the correct and valid purchase order number on all shipping documents, including the shipment invoice and packing list.';
        Text002 = 'b) Timely notify any issue(s) in arranging and / or dispatching the product(s) or item(s) mentioned in the purchase order as sent by Stone Depot.';
        Text003 = 'c) Supply ONLY the “First Choice Premium Quality" product(s). In case of any discrepancy observed during the quality checks, Stone Depot holds complete authority to fully or partially reject or return the delivered shipment.';
        Text004 = 'd) Size and / or Thickness Variation of ONLY up to +/- 1 mm are acceptable for the supplied Natural Stones only.';
        Text005 = 'e) Follow the packaging and labeling standards ONLY as specified or instructed by Stone Depot, and DO NOT put any label of other company or brand on any item, package, box, and / or crate.';
        Text006 = 'f) Dispatch all shipments ONLY through shipping agents as designated and communicated by Stone Depot.';
        Text007 = 'g) All wooden crates and container(s) must be fumigated by a certified fumigator by Australia Agriculture Department. This certified fumigator also needs to make sure that the wooden crates have gone through the Brown Marmorated Stink Bug (BMSB) Heat Treatment process.';
        AuthorizedSignatoryLbl = 'Authorized Signatory';
        SubtotalCaptionLbl = 'Subtotal';
    }

    var
        CompInfo: Record "Company Information";
        FormatDocument: Codeunit "Format Document";
        Language: Codeunit Language;
        Vendor: Record Vendor;
        CountryRegion: Record "Country/Region";
        Item: Record Item;

        EntryExitPoint: Record "Entry/Exit Point";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line" temporary;
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        OutputNo: Integer;
        CopyText: Text[30];
        TotalAmountInclGST: Decimal;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountVAT: Decimal;
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalText: Text[50];
        TotalInvoiceDiscountAmount: Decimal;
        // PurchPost: Codeunit "Purch.-Post";   //PRJ-737.RM.1.0 commented
        VATAmountText: Text;
        TakeOffDetailArray: array[10] of Text[100];
        LineVATAmount: Decimal;
        TakeOffCaptionTxt: text;
        POCreater: Record User;
        TakeOffLineNo: Integer;
        ShowonPO: Boolean;
        CommentSerialNo: integer;
        Salesperson: Record "Salesperson/Purchaser";
        AddressBillTo: Record "Ship-to Address";

        CustomerBillTo: Record Customer;
        PaymentTerms: Record "Payment Terms";
        QuoteHeader: record "NS_Job Quote Header";
        ShipmentMethod: Record "Shipment Method";

        T222: Record "Ship-to Address";
        Contact: Record Contact;
        AddressShipTo: Record "Ship-to Address";
        CustomerSellTo: Record Customer;
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        CurrencyCode: Code[10];

        Section: Code[10];
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        ShowDetails: Boolean;
        UserSetup: Record "User Setup";
        User: Record User;
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        CustomerContact: record Contact;
        BillToAddressText: array[3] of Text[250];
        ShipToAddressText: array[3] of Text[250];
        SellToAddressText: array[3] of Text[250];


    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        FormatDocument.SetTotalLabels(PurchaseHeader."Currency Code",
            TotalText, TotalInclVATText, TotalExclVATText);
    end;

    procedure CalculateTakeOffText(JobNo: Code[20]; JobTaskNo: Code[20]; LineNo: Integer)
    var
        //  PlanningTakeOffLines: record "Planning TakeOff Lines";   //PRJ-737.RM.1.0 commented
        ArrayPosition: integer;
    begin
        TakeOffCaptionTxt := '## TAKE OFF::';
        //     PlanningTakeOffLines.reset;

        //     PlanningTakeOffLines.Setrange("Job No.", JobNo);
        //     PlanningTakeOffLines.Setrange("Job Task No.", JobTaskNo);
        //     PlanningTakeOffLines.Setrange("Line No.", LineNo);
        //     IF PlanningTakeOffLines.Findset THEN
        //         repeat
        //             ArrayPosition += 1;
        //             IF ArrayPosition <= 10 THEN BEGIN
        //                 IF PlanningTakeOffLines.Quantity <> 0 THEN
        //                     TakeOffDetailArray[ArrayPosition] += ' Qty - ' + FORMAT(PlanningTakeOffLines.Quantity);
        //                 IF PlanningTakeOffLines.Length <> 0 THEN
        //                     TakeOffDetailArray[ArrayPosition] += ' x L - ' + FORMAT(PlanningTakeOffLines.Length);
        //                 IF PlanningTakeOffLines.Length <> 0 THEN
        //                     TakeOffDetailArray[ArrayPosition] += ' x W - ' + FORMAT(PlanningTakeOffLines.Width);
        //                 IF PlanningTakeOffLines.height <> 0 THEN
        //                     TakeOffDetailArray[ArrayPosition] += ' x H - ' + FORMAT(PlanningTakeOffLines.Height);
        //             end;
        //         until PlanningTakeOffLines.next = 0;
        // end;
        //PRJ-737.RM.1.0 commented end

        //     local procedure CreateBillToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
        // begin
        //     Clear(BillToAddressText);
        //     BillToAddressText[1] := Name;
        //     BillToAddressText[2] := Address + ' ' + Address2;
        //     BillToAddressText[3] := City + ' ' + County + ' ' + PostCode;
        // end;
        //PRJ-737.RM.1.0 commented end

        //     local procedure CreateShipToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
        // begin
        //     Clear(ShipToAddressText);
        //     ShipToAddressText[1] := Name;
        //     ShipToAddressText[2] := Address + ' ' + Address2;
        //     ShipToAddressText[3] := City + ' ' + County + ' ' + PostCode;
        // end;
        //PRJ-737.RM.1.0 commented end
        //     local procedure CreateSellToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
        // begin
        //     Clear(SellToAddressText);
        //     SellToAddressText[1] := Name;
        //     SellToAddressText[2] := Address + ' ' + Address2;
        //     SellToAddressText[3] := City + ' ' + County + ' ' + PostCode;
        // end;
        //PRJ-737.RM.1.0 commented
    end;
}

