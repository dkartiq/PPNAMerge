report 14021184 "NS_Job Purchase Order Status"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-301.N.S.1.0 23Sep2020 increase length varible
    //CTSI-169.AS.1.0 07OCT2020 Added code & also done change in layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Purchase Order Status.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job Purchase Order Status';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(JobsFilter; JobsFilter)
            {
            }
            column(PurchaseLineFilter; PurchaseLineFilter)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job_Description; Description)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job_Purchase_Order_StatusCaption; Job_Purchase_Order_StatusCaptionLbl)
            {
            }
            column(JobsFilterCaption; JobsFilterCaptionLbl)
            {
            }
            column(PurchaseLineFilterCaption; PurchaseLineFilterCaptionLbl)
            {
            }
            column(Purchase_Line__Document_No__Caption; "Purchase Line".FIELDCAPTION("Document No."))
            {
            }
            column(Purchase_Line_TypeCaption; "Purchase Line".FIELDCAPTION(Type))
            {
            }
            column(Purchase_Line__No__Caption; "Purchase Line".FIELDCAPTION("No."))
            {
            }
            column(Purchase_Line_DescriptionCaption; "Purchase Line".FIELDCAPTION(Description))
            {
            }
            column(Purchase_Line__Quantity__Base__Caption; Purchase_Line__Quantity__Base__CaptionLbl)
            {
            }
            column(Unit_of_MeasureCaption; Unit_of_MeasureCaptionLbl)
            {
            }
            column(Purchase_Line__Qty__Received__Base__Caption; Purchase_Line__Qty__Received__Base__CaptionLbl)
            {
            }
            column(QuantityInStockCaption; QuantityInStockCaptionLbl)
            {
            }
            column(Purchase_Line__Subcontract_No__Caption; "Purchase Line".FIELDCAPTION("NS_Subcontract No."))
            {
            }
            column(Job__No__Caption; Job__No__CaptionLbl)
            {
            }
            column(VendNameCap; VendNameCap)//CTSI-169.AS.1.0 07OCT2020
            {
            }
            column(QtyCap; QtyCap)//CTSI-169.AS.1.0 07OCT2020
            {
            }
            column(UnitCostcap; UnitCostcap)//CTSI-169.AS.1.0 07OCT2020
            {
            }
            column(TotalAmtCap; TotalAmtCap)//CTSI-169.AS.1.0 07OCT2020
            {
            }
            column(QtyRemCap; QtyRemCap)//CTSI-169.AS.1.0 07OCT2020
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                RequestFilterFields = "NS_Job Cost Category";
                column(Purchase_Line__Document_No__; "Document No.")
                {
                }
                column(Purchase_Line_Type; Type)
                {
                }
                column(Purchase_Line__No__; "No.")
                {
                }
                column(Purchase_Line_Description; Description)
                {
                }
                column(Purchase_Line__Quantity__Base__; "Quantity (Base)")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(UnitOfMeasure; UnitOfMeasure)
                {
                }
                column(Purchase_Line__Qty__Received__Base__; "Qty. Received (Base)")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(QuantityInStock; QuantityInStock)
                {
                }
                column(Purchase_Line__Subcontract_No__; "NS_Subcontract No.")
                {
                }
                column(Purchase_Line_Document_Type; "Document Type")
                {
                }
                column(Purchase_Line_Line_No_; "Line No.")
                {
                }
                column(Purchase_Line_Job_No_; "Job No.")
                {
                }
                column(Purchase_Line_Quantity; Quantity)//CTSI-169.AS.1.0 07OCT2020
                {
                }
                column(Purchase_Line_Unit_Cost; "Unit Cost")//CTSI-169.AS.1.0 07OCT2020
                {
                }
                column(Purchase_Line_Amount; "Line Amount")//CTSI-169.AS.1.0 07OCT2020
                {
                }
                column(PL_Outstanding_Quantity; "Outstanding Quantity")//CTSI-169.AS.1.0 07OCT2020
                {
                }
                column(Purchase_Line_Direct_Unit_Cost; "Direct Unit Cost")//CTSI-169.AS.1.0 07OCT2020
                {
                }
                column(VenName; VenName)//CTSI-169.AS.1.0 07OCT2020
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Clear(VenName);//CTSI-169.AS.1.0 07OCT2020

                    if "Buy-from Vendor No." > '' then
                        if Vendor.GET("Buy-from Vendor No.") then
                            VendorName := Vendor.Name
                        else
                            VendorName := Text001 + "Buy-from Vendor No."
                    else
                        VendorName := '';

                    //CTSI-169.AS.1.0 07OCT2020 - start
                    if VenRec.get("Buy-from Vendor No.") then
                        VenName := VenRec.Name;
                    //CTSI-169.AS.1.0 07OCT2020 - end

                    QuantityInStock := 0;
                    UnitOfMeasure := "Unit of Measure";
                    if Item.GET("No.") then begin
                        UnitOfMeasure := Item."Base Unit of Measure";
                        Item.CALCFIELDS(Inventory);
                        QuantityInStock := QuantityInStock + Item.Inventory;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    SETFILTER("NS_Committed Amount (LCY)", '>0');
                end;
            }

            trigger OnPreDataItem();
            begin
                CurrReport.CREATETOTALS("Purchase Line"."NS_Committed Amount (LCY)");
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

    trigger OnPreReport();
    begin
        JobsFilter := Job.GETFILTERS();
        PurchaseLineFilter := "Purchase Line".GETFILTERS();
    end;

    var
        Vendor: Record Vendor;
        Item: Record Item;
        UnitOfMeasure: Code[10];
        QuantityInStock: Decimal;
        //VendorName: Text[50];//PRJ-301.N.S.1.0 23Sep2020 comment

        VendorName: Text[120];//PRJ-301.N.S.1.0 23Sep2020
        JobsFilter: Text[250];
        PurchaseLineFilter: Text[250];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Purchase_Order_StatusCaptionLbl: Label 'Job Purchase Order Status';
        JobsFilterCaptionLbl: Label 'Jobs Filter:';
        PurchaseLineFilterCaptionLbl: Label 'Purchase Line Filter:';
        Purchase_Line__Quantity__Base__CaptionLbl: Label 'Quantity Ordered';
        Unit_of_MeasureCaptionLbl: Label 'UOM';//CTSI-169.AS.1.0 07OCT2020
        Purchase_Line__Qty__Received__Base__CaptionLbl: Label 'Quantity Received';
        QuantityInStockCaptionLbl: Label 'Quantity In Stock';
        Job__No__CaptionLbl: Label 'Job:';
        Text001: Label '"Unknown - "';
        VendNameCap: Label 'Vendor Name';//CTSI-169.AS.1.0 07OCT2020
        QtyCap: Label 'Quantity';//CTSI-169.AS.1.0 07OCT2020
        UnitCostcap: Label 'Unit Cost';//CTSI-169.AS.1.0 07OCT2020
        TotalAmtCap: Label 'Total Amount';//CTSI-169.AS.1.0 07OCT2020
        QtyRemCap: Label 'Qty. Remaining';//CTSI-169.AS.1.0 07OCT2020
        VenName: Text;//CTSI-169.AS.1.0 07OCT2020
        VenRec: Record Vendor;//CTSI-169.AS.1.0 07OCT2020
}

