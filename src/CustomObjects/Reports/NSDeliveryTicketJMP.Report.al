report 14021402 "NS_Delivery Ticket JMP"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    DefaultLayout = RDLC;
    Caption = 'Delivery Ticket JMP';
    RDLCLayout = './Layouts/NSDelivery Ticket JMP.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Job Material Planning"; "NS_Job Material Planning")
        {
            DataItemTableView = SORTING("NS_Box Text");
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }

            column(Job_No; Job."No.")
            {
            }
            column(Job_Name; Job.Description)
            {
            }
            column(Job_AddressLine1; CustAddr[1])
            {
            }
            column(Job_AddressLine2; CustAddr[2])
            {
            }
            column(Job_AddressLine3; CustAddr[3])
            {
            }
            column(Job_AddressLine4; CustAddr[4])
            {
            }
            column(Job_AddressLine5; CustAddr[5])
            {
            }
            column(Job_AddressLine6; CustAddr[6])
            {
            }
            column(Job_JobName; Job.Description)
            {
            }
            column(Job_CustomerAccount; Job."NS_Customer Account")
            {
            }
            column(Job_CustomerAccountName; Job."Bill-to Contact")
            {
            }
            column(Job_Project_Emgineer; Job."Person Responsible")
            {
            }
            column(CompanyInfo1Picture; CoInfo.Picture)
            {
            }
            column(Quantity_Shipped; "NS_Total Qty. Ready to Ship")
            {
            }
            column(Box_Ref; "NS_Box Text")
            {
            }
            column(Part_No; "NS_Part No.")
            {
            }
            column(Description; NS_Description)
            {
            }
            column(Quantity_Shipped_Calc; QuantityShipped)
            {
            }
            column(Box_Ref_Calc; BoxText)
            {
            }

            trigger OnAfterGetRecord();
            begin
                QuantityShipped := 0;
                CALCFIELDS("NS_Inv. Qty", "NS_PO Qty Staged");
                if "NS_Invt. Qty. to Ship" = 0 then
                    "NS_Invt. Qty. to Ship" := "NS_Inventory Qty. Staged";
                if "NS_PO Qty. to Ship" = 0 then
                    "NS_PO Qty. to Ship" := "NS_PO Qty Staged";
                if "NS_Total Qty. Ready to Ship" = 0 then
                    "NS_Total Qty. Ready to Ship" := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                QuantityShipped := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                BoxText := '';
                BoxText := "NS_Box Text";
                if "NS_Total Qty. Ready to Ship" = 0 then
                    CurrReport.SKIP;
                PurchRcptLine.RESET();
                PurchRcptLine.SETRANGE("Job No.", "NS_Worksheet Job No.");
                PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
                PurchRcptLine.SETRANGE("No.", "NS_Part No.");
                PurchRcptLine.SETRANGE(NS_Staged, true);
                PurchRcptLine.SETRANGE("NS_JMP Document No.", "NS_Document No.");
                PurchRcptLine.SETRANGE("NS_Journal Status", PurchRcptLine."NS_Journal Status"::Posted);
                if PurchRcptLine.FINDFIRST() then begin
                    if Post then begin
                        PurchRcptLine."NS_Staged Quantity" -= "NS_PO Qty. to Ship";
                        if PurchRcptLine."NS_Staged Quantity" <= 0 then
                            PurchRcptLine.NS_Staged := false;
                        PurchRcptLine.MODIFY();
                    end;
                end;

                Job.RESET();
                if Job.GET("NS_Worksheet Job No.") then begin
                    if Customer.GET(Job."Bill-to Customer No.") then begin
                        CustAddr[1] := Customer.Name;
                        CustAddr[2] := Customer.Address;
                        CustAddr[3] := Customer."Address 2";
                        CustAddr[4] := Customer.City;
                        CustAddr[5] := Customer.County;
                        CustAddr[6] := Customer."Post Code";
                        COMPRESSARRAY(CustAddr);
                    end;
                end;


                if Post then begin
                    "NS_Inventory Qty. Staged" -= "NS_Invt. Qty. to Ship";
                    "NS_Job Site From Inv." += "NS_Invt. Qty. to Ship";
                    "NS_Job Site Vndr Qty" += "NS_PO Qty. to Ship";
                    "NS_Total Quantity Staged" -= ("NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship");
                    "NS_Total Qty. Ready to Ship" := 0;//-= "Invt. Qty. to Ship" + "PO Qty. to Ship";
                    "NS_Invt. Qty. to Ship" := 0;
                    "NS_PO Qty. to Ship" := 0;
                    "NS_Box Text" := '';
                    MODIFY();
                end;
            end;

            trigger OnPreDataItem();
            begin
                //SETRANGE("Worksheet Job No.",JobNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Post; Post)
                {
                    Caption = 'Post?';
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

    trigger OnPreReport();
    begin
        CoInfo.GET;
        CoInfo.CALCFIELDS(Picture);
    end;

    var
        CoInfo: Record "Company Information";
        Customer: Record Customer;
        Job: Record Job;
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Post: Boolean;
        QuantityShipped: Decimal;
        BoxText: Text[30];
        JobNo: Code[20];
        CustAddr: array[6] of Text;
        x: Integer;

    procedure InitVar(lJobNo: Code[20]);
    begin
        JobNo := lJobNo;
    end;
}

