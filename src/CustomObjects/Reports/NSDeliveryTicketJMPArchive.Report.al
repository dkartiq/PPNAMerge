report 14021232 "NS_DeliveryTicketJMPArchive"
{

    //PRJ-1361.AS.1.0 Created New Report
    //PRJ-1458.RM.1.0 17June2022 | Added a column
    //PRJ-1458.RM.1.0 21June2022 | Added some code
    //PE-52.RM.1.0 21Feb2023 | Changes in Layout
    DefaultLayout = RDLC;
    Caption = 'Delivery Ticket Archive';
    RDLCLayout = './Layouts/NSDelivery Ticket JMPArchive.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("NS_Delivery ticket Archive"; "NS_Delivery ticket Archive")
        {
            RequestFilterFields = "NS_Worksheet Job No.";//PRJ-1458.RM.1.0 21June2022
            DataItemTableView = SORTING("NS_Box Text");
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            //PRJ-1458.RM.1.0 21June start
            column(JobDeliveryInstruction; Job."NS_Delievery Instruction")
            {
            }
            //PRJ-1458.RM.1.0 21June end
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
                //QuantityShipped := NS_Quantity;//PRJ-1432.GK.1.0 13July2022 comment
                QuantityShipped := "NS_Total Quantity Staged"; //PRJ-1432.GK.1.0 13July2022
                BoxText := '';
                BoxText := "NS_Box Text";

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
            end;

            trigger OnPreDataItem();
            begin
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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

}

