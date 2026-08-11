report 14021334 "NS_JobEstimationJob"
{
    //PRJ-737.RM.1.0 16March2022 Created a New Report 
    //PRJCTPR-130.RM.1.0 18March2023 Changes in the Layout 
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJobEstimate.rdl';
    Caption = 'Job Estimation Report';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(JobDI; "job")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Job No.';
            column(No_PurchHdr; "No.")
            {
            }
            column(ShowDetails; ShowDetails)
            {

            }
            //PRJ-737.RM.1.0 commented
            // column(GSTPer; "GST %")
            // {

            // }
            column(ShowProcesses; ShowProcesses)
            {
            }
            column(ShowOperations; ShowOperations)
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
                    column(QuoteHeader_ProposalDate; JobDI."NS_Contract Date")
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

                    column(NS_Revision; '')
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
                    column(CompInfo_PhoneNo; 'Perth Office' + ' ' + CompInfo."Phone No.")
                    {
                    }
                    column(CompInfo_Email; CompInfo."E-Mail")
                    {
                    }

                    column(CompInfo_HomePage; 'W:' + '' + CompInfo."Home Page")
                    {
                    }
                    // column(CompInfo_ABN; '(ABN' + ' ' + CompInfo.ABN + ')')
                    // {
                    // }
                    //PRJ-737.RM.1.0 commented
                    column(CompInfo_Pic; CompInfo.Picture)
                    {
                    }
                    column(VendName; Vendor.Name + ' ' + Vendor."Name 2")
                    {
                    }

                    // column(VendorABN; vendor.ABN)
                    // {

                    // }
                    //PRJ-737.RM.1.0 commented

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

                        DataItemLinkReference = JobDI;
                        DataItemTableView = sorting("Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                        column(Unit_Price; "Unit Price")
                        {
                        }
                        column(Unit_Cost; "Unit Cost")
                        {
                        }
                        column(Total_Price; "Total Price")
                        {
                        }
                        column(Total_Cost; "Total Cost")
                        {
                        }
                        column(Quantity; Quantity)
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
                        column(Line_No_; PlanningLineNo)
                        {

                        }
                        // column(Take_Off_Lines; "Take Off Lines")
                        // {

                        // }
                        //PRJ-737.RM.1.0 commented
                        column(NS_Assembley_BOM; "NS_Assembley BOM")
                        {

                        }


                        column(RunningQty; RunningQty)
                        {

                        }
                        column(RunningTotalPrice; RunningTotalPrice)
                        {

                        }
                        column(RunningtotalCost; RunningtotalCost)
                        {

                        }
                        column(RunningProcessQty; RunningProcessQty)
                        {

                        }
                        column(RunningProcessTotalPrice; RunningProcessTotalPrice)
                        {

                        }
                        column(RunningProcesstotalCost; RunningProcesstotalCost)
                        {

                        }
                        column(RunningOperationQty; RunningOperationQty)
                        {

                        }
                        column(RunningOperationTotalPrice; RunningOperationTotalPrice)
                        {

                        }
                        column(RunningOperationTotalCost; RunningOperationTotalCost)
                        {
                        }
                        column(RunningActivityQty; RunningActivityQty)
                        {

                        }
                        column(RunningActivityTotalPrice; RunningActivityTotalPrice)
                        {

                        }
                        column(RunningActivityTotalCost; RunningActivityTotalCost)
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
                        //PRJ-737.RM.1.0 commented start
                        // dataitem(PlanningTakeOffLinesDL; "Planning TakeOff Lines")
                        // {
                        //     DataItemLink = "Job No." = FIELD("Job No."), "JOb Task No." = field("JOb Task No."), "Job Planning Line No." = field("Line No.");
                        //     DataItemLinkReference = JobPlanningLineDI;
                        //     column(TakeOffDescription; Description)
                        //     {

                        //     }
                        //     column(TakeOffQuantity; Quantity)
                        //     {

                        //     }
                        //     column(Length; Length)
                        //     {

                        //     }
                        //     column(Width; Width)
                        //     {

                        //     }
                        //     column(Height; Height)
                        //     {

                        //     }
                        //     column(TakeOffLineNo; TakeOffLineNo)
                        //     {

                        //     }
                        //     trigger OnAfterGetRecord()
                        //     begin
                        //         if NOT JobPlanningLineDI."Take Off Lines" THEN
                        //             CurrReport.Break();
                        //         TakeOffLineNo += 1;
                        //     end;

                        //     trigger OnPreDataItem()
                        //     begin
                        //         if NOT JobPlanningLineDI."Take Off Lines" THEN
                        //             CurrReport.Break();
                        //     end;

                        // }
                        //PRJ-737.RM.1.0 commented end
                        dataitem(ASMDLInteger; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(BOMItemNo; BOMItem[ASMDLInteger.Number])
                            {

                            }

                            column(BOMItemDec; BOMItemDes[ASMDLInteger.Number])
                            {

                            }
                            column(QuantityPer; QuantityPer[ASMDLInteger.Number])
                            {

                            }
                            column(ExpectedQty; ExpectedQty[ASMDLInteger.Number])
                            {

                            }
                            trigger OnAfterGetRecord()
                            begin
                                IF NOT JobPlanningLineDI."NS_Assembley BOM" then
                                    CurrReport.Break;
                                ASMLineNo += 1;
                            end;

                            trigger OnPreDataItem()
                            var
                                Item: Record Item;
                                ArrayCnt: Integer;
                                ParentItems: Text[2048];
                                NSAssembleyBOMComponents: record "NS_Assembley BOM Components";
                            begin
                                IF NOT JobPlanningLineDI."NS_Assembley BOM" then
                                    CurrReport.Break;
                                clear(BOMItem);
                                clear(QuantityPer);
                                clear(ExpectedQty);
                                Clear(BOMItemDes);
                                ASMTotalLines := 0;
                                IF JobPlanningLineDI.Type = JobPlanningLineDI.type::Item THEN begin
                                    IF JobPlanningLineDI."NS_Assembley BOM" THEN BEGIN
                                        Item.GET(JobPlanningLineDI."No.");
                                        // ParentItems := Item.FindASMCostparentItems();  //PRJ-737.RM.1.0 commented
                                        ParentItems := Item."No.";//PRJCTPR-239.PS.1.0 05Dec2023
                                        IF ParentItems <> '' THEN BEGIN
                                            NSAssembleyBOMComponents.reset;
                                            NSAssembleyBOMComponents.Setrange("NS_Job No.", JobPlanningLineDI."Job No.");
                                            NSAssembleyBOMComponents.Setrange("NS_Job Task No.", JobPlanningLineDI."Job Task No.");
                                            NSAssembleyBOMComponents.Setrange("NS_Ref. JPL Line No.", JobPlanningLineDI."Line No.");
                                            NSAssembleyBOMComponents.setFilter("NS_Ref. JPL Parent Item No.", ParentItems);
                                            if NSAssembleyBOMComponents.FindSet then BEGIN
                                                ASMTotalLines := NSAssembleyBOMComponents.Count;
                                                ArrayCnt := 0;
                                                repeat
                                                    ArrayCnt += 1;
                                                    BOMItem[ArrayCnt] := NSAssembleyBOMComponents."NS_No.";
                                                    QuantityPer[ArrayCnt] := NSAssembleyBOMComponents."NS_Quantity Per";
                                                    ExpectedQty[ArrayCnt] := NSAssembleyBOMComponents."NS_Expected Quantity";
                                                    BOMItemDes[ArrayCnt] := NSAssembleyBOMComponents.NS_Description;
                                                until NSAssembleyBOMComponents.next = 0;
                                                SetRange(Number, 1, ASMTotalLines);
                                            end;
                                        End;
                                    end;
                                End;

                            end;
                        }


                        trigger OnAfterGetRecord()
                        var
                            Job: record job;
                        begin
                            PlanningLineNo += 1;
                            ShowonPO := FALSE;
                            //JobPlanningLineDI.CalcFields("Take Off Lines");  //PRJ-737.RM.1.0 commented
                            TakeOffCaptionTxt := '';
                            clear(TakeOffDetailArray);
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
                            RunningQty += Quantity;
                            RunningTotalPrice += "Total Price";
                            RunningtotalCost += "Total Cost";
                            IF Activity <> '' THEN BEGIN
                                IF LastActivityCode = Activity then begin
                                    RunningActivityQty += Quantity;
                                    RunningActivityTotalPrice += "Total Price";
                                    RunningActivityTotalCost += "Total Cost";
                                end
                                Else begin
                                    RunningActivityQty := Quantity;
                                    RunningActivityTotalPrice := "Total Price";
                                    RunningActivityTotalCost := "Total Cost";

                                end;

                            END;
                            IF Process <> '' THEN BEGIN
                                IF (LastActivityCode = Activity) and (LastProcessCode = Process) then begin
                                    RunningProcessQty += Quantity;
                                    RunningProcessTotalPrice += "Total Price";
                                    RunningProcesstotalCost += "Total Cost";
                                end
                                Else begin
                                    RunningProcessQty := Quantity;
                                    RunningProcessTotalPrice := "Total Price";
                                    RunningProcesstotalCost := "Total Cost";
                                end;

                            END;

                            IF Operation <> '' THEN BEGIN
                                IF (LastActivityCode = Activity) and (LastProcessCode = Process) and (LastOperationCode = Operation) then begin
                                    RunningOperationQty += Quantity;
                                    RunningOperationTotalPrice += "Total Price";
                                    RunningOperationtotalCost += "Total Cost";
                                end
                                Else begin
                                    RunningOperationQty := Quantity;
                                    RunningOperationTotalPrice := "Total Price";
                                    RunningOperationtotalCost := "Total Cost";
                                end;

                            END;
                            IF Activity <> '' THEN
                                LastActivityCode := Activity;
                            IF Process <> '' THEN
                                LastProcessCode := Process;
                            IF Operation <> '' THEN
                                LastOperationCode := Operation;

                        end;

                        trigger OnPreDataItem()

                        begin
                            Setrange("Job No.", JobDI."No.")
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
                        //     CopyText := FormatDocument.GetCOPYText;  //PRJ-737.RM.1.0 commented
                        OutputNo += 1;
                    end;

                    CommentSerialNo := 0;
                    Clear(PurchLine);
                    //Clear(PurchPost);   //PRJ-737.RM.1.0 commented
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

                PlanningLineNo := 0;
                RunningQty := 0;
                RunningTotalPrice := 0;
                RunningtotalCost := 0;
                RunningTotalPrice := 0;
                RunningtotalCost := 0;
                RunningProcessQty := 0;
                RunningProcessTotalPrice := 0;
                RunningProcesstotalCost := 0;
                RunningOperationQty := 0;
                RunningOperationTotalPrice := 0;
                RunningOperationtotalCost := 0;
                RunningActivityQty := 0;
                RunningActivityTotalPrice := 0;
                RunningActivityTotalCost := 0;

                IF Salesperson.get("NS_Salesperson Code") THEN;
                if not CustomerSellTo.GET("NS_Sell-to Customer No.") then begin
                    CustomerSellTo.INIT();
                    CreateSellToAddress(Contact.Name, Contact.Address, Contact."Address 2", contact.City, Contact.County, Contact."Post Code");
                end else
                    CreateSellToAddress(CustomerSellTo.Name, CustomerSellTo.Address, CustomerSellTo."Address 2", CustomerSellTo.City, CustomerSellTo.County, CustomerSellTo."Post Code");

                if not CustomerBillTo.GET("Bill-to Customer No.") then begin
                    if not CustomerBillTo.GET("NS_Sell-to Customer No.") then begin
                        CustomerBillTo.INIT();
                        CreateBillToAddress(Contact.Name, Contact.Address, Contact."Address 2", contact.City, Contact.County, Contact."Post Code");
                    end else
                        CreateSellToAddress(CustomerSellTo.Name, CustomerSellTo.Address, CustomerSellTo."Address 2", CustomerSellTo.City, CustomerSellTo.County, CustomerSellTo."Post Code");
                end else
                    CreateBillToAddress("Bill-to Name", "Bill-to Address", "Bill-to Address 2", "Bill-to City", "Bill-to County", "Bill-to Post Code");
                AddressBillTo.SETRANGE("NS_Table ID", DATABASE::Job);
                AddressBillTo.SETRANGE("NS_No.", "No.");
                AddressBillTo.SETRANGE("NS_Address Type", AddressBillTo."NS_Address Type"::"Bill-to");
                if AddressBillTo.FINDFIRST() then
                    CreateBillToAddress(AddressBillTo.Name, AddressBillTo.Address, AddressBillTo."Address 2", AddressBillTo.City, AddressBillTo.County, AddressBillTo."Post Code");
                IF "NS_Job Ship-to Code" <> '' THEN BEGIN
                    T222.RESET;
                    T222.SETRANGE("Customer No.", "NS_Sell-to Customer No.");
                    T222.SETRANGE(Code, "NS_Job Ship-to Code");
                    IF T222.FINDFIRST THEN
                        CreateShipToAddress(T222.Name, T222.Address, T222."Address 2", T222.City, T222.County, T222."Post Code");
                END;
                IF "NS_Job Ship-to Code" = '' THEN BEGIN
                    AddressShipTo.RESET();
                    AddressShipTo.SETRANGE("NS_Table ID", DATABASE::job);
                    AddressShipTo.SETRANGE("NS_No.", "No.");
                    AddressShipTo.SETRANGE("NS_Address Type", AddressShipTo."NS_Address Type"::"Ship-to");
                    IF NOT AddressShipTo.FINDFIRST() THEN BEGIN
                        AddressShipTo.INIT();
                        ShipToAddressText[1] := SellToAddressText[1];
                        ShipToAddressText[2] := SellToAddressText[2];
                        ShipToAddressText[3] := SellToAddressText[3];
                    END ELSE
                        CreateShipToAddress(AddressShipTo.Name, AddressShipTo.Address, AddressShipTo."Address 2", AddressShipTo.City, AddressShipTo.County, AddressShipTo."Post Code");
                END;
            end;

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
        // FormatDocument: Codeunit "Format Document";   //PRJ-737.RM.1.0 commented
        // Language: Codeunit Language;   //PRJ-737.RM.1.0 commented
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
        //PurchPost: Codeunit "Purch.-Post";  //PRJ-737.RM.1.0 commented
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

        T222: Record "Ship-to Address";//PPAL-32.AS.1.0 14Aug2020
        Contact: Record Contact;
        AddressShipTo: Record "Ship-to Address";

        CustomerSellTo: Record Customer;
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        Section: Code[10];
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        ShowDetails: Boolean;
        RunningQty: Decimal;
        RunningTotalPrice: Decimal;
        RunningtotalCost: Decimal;

        RunningProcessQty: Decimal;
        RunningProcessTotalPrice: Decimal;
        RunningProcesstotalCost: Decimal;
        RunningOperationQty: Decimal;
        RunningOperationTotalPrice: Decimal;
        RunningOperationtotalCost: Decimal;

        RunningActivityQty: Decimal;
        RunningActivityTotalPrice: Decimal;
        RunningActivityTotalCost: Decimal;


        LastProcessCode: Code[10];
        LastOperationCode: Code[10];
        LastActivityCode: Code[10];
        PlanningLineNo: Integer;
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        BOMItem: array[100] of Code[20];
        BOMItemDes: array[100] of TExt[50];
        QuantityPer: array[100] of Decimal;
        ExpectedQty: array[100] of Decimal;
        ShowASMLine: Boolean;
        ASMLineNo: Integer;
        ASMTotalLines: integer;
        BillToAddressText: array[3] of Text[250];
        ShipToAddressText: array[3] of Text[250];
        SellToAddressText: array[3] of Text[250];


    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        // FormatDocument.SetTotalLabels(PurchaseHeader."Currency Code",  //PRJ-737.RM.1.0 commented
        //   TotalText, TotalInclVATText, TotalExclVATText);
    end;
    //PRJ-737.RM.1.0 commented start
    // procedure CalculateTakeOffText(JobNo: Code[20]; JobTaskNo: Code[20]; LineNo: Integer)
    // var
    //     //PlanningTakeOffLines: record "Planning TakeOff Lines";   //PRJ-737.RM.1.0 commented 
    //     ArrayPosition: integer;
    // begin
    //     TakeOffCaptionTxt := '## TAKE OFF::';
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

    local procedure CreateBillToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
    begin
        Clear(BillToAddressText);
        BillToAddressText[1] := Name;
        BillToAddressText[2] := Address + ' ' + Address2;
        BillToAddressText[3] := City + ' ' + County + ' ' + PostCode;
    end;

    local procedure CreateShipToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
    begin
        Clear(ShipToAddressText);
        ShipToAddressText[1] := Name;
        ShipToAddressText[2] := Address + ' ' + Address2;
        ShipToAddressText[3] := City + ' ' + County + ' ' + PostCode;
    end;

    local procedure CreateSellToAddress(Name: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[50]; County: Text[50]; PostCode: Text[50])
    begin
        Clear(SellToAddressText);
        SellToAddressText[1] := Name;
        SellToAddressText[2] := Address + ' ' + Address2;
        SellToAddressText[3] := City + ' ' + County + ' ' + PostCode;
    end;
}

