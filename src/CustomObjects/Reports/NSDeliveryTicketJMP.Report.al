/// <summary>
/// Report NS_Delivery Ticket JMP (ID 14021402).
/// </summary>
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
    //PRJ-1073.JS.1.0 10Dec2021 | Add Permission for Purch. Recpt. Line Table
    //PRJ-1386.NK.1.0 12May2022 | Add Code
    //PRJ-1458.RM.1.0 17June2022 | Added a column
    //PRJ-1458.RM.1.0 21June2022 | Added some code
    //PRJCTPR-7.RP.1.0 23Dec2022 | Correction in Layout
    //PE-52.RM.1.0 21Feb2023 | Changes in Layout
    //PE-114.RM.1.0 27July2023 | Created Word Layout Report.
    //PE-215.HS.1.0 28Dec2023 | Added Code And Cosmetic chnages in RDL and Word Layout
    DefaultLayout = RDLC;
    Caption = 'Delivery Ticket JMP';
    WordLayout = './Layouts/NSDelivery Ticket JMP.docx'; //PE-114.RM.1.0 27July2023
    RDLCLayout = './Layouts/NSDelivery Ticket JMP.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Permissions = tabledata "Purch. Rcpt. Line" = rmdi;    //PRJ-1073.JS.1.0 10Dec2021 //PRJ-1386.NK.1.0 12May2022 

    dataset
    {

        dataitem("Job Material Planning"; "NS_Job Material Planning")
        {
            DataItemTableView = SORTING("NS_Box Text");
            RequestFilterFields = "NS_Worksheet Job No."; //PRJ-1458.RM.1.0 21June2022
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            //PE-114.RM.1.0 10Aug2023 start
            column(NS_TodayDate; format(WorkDate()))
            {
            }
            //PE-114.RM.1.0 10Aug2023 End
            column(Job_No; Job."No.")
            {
            }
            column(Job_Name; Job.Description)
            {
            }

            //PE-215.HS.1.0 28Dec2023 Start

            // column(Job_AddressLine1; CustAddr[1])
            // {
            // }
            // column(Job_AddressLine2; CustAddr[2])
            // {
            // }
            // column(Job_AddressLine3; CustAddr[3])
            // {
            // }
            // column(Job_AddressLine4; CustAddr[4])
            // {
            // }
            // column(Job_AddressLine5; CustAddr[5])
            // {
            // }
            // column(Job_AddressLine6; CustAddr[6])
            // {
            // }
            column(Job_AddressLine1; Job."NS_Job Contact")
            {
            }
            column(Job_AddressLine2; job."NS_Job Address 1")
            {
            }
            column(Job_AddressLine3; job."NS_Job Address 2")
            {
            }
            column(Job_AddressLine4; Job."NS_Job City")
            {
            }
            column(Job_AddressLine5; Job."NS_Job County")
            {
            }
            //PE-215.HS.1.0 28Dec2023 End
            column(Job_AddressLine6; Job."NS_Job Post Code")
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
            // column(Job_Project_Emgineer; Job."Person Responsible")  //PE-215.HS.1.0 28Dec2023 commented
            // {
            // }
            column(Job_Project_Emgineer; NS_PersonResponsible) //PE-215.HS.1.0 28Dec2023
            {
            }
            //PRJ-1458.RM.1.0 21June2022start
            column(JobDeliveryInstruction; Job."NS_Delievery Instruction")
            {
            }
            //PRJ-1458.RM.1.0 21June2022 end
            column(CompanyInfo1Picture; CoInfo.Picture)
            {
            }
            //PE-114.RM.1.0 02Aug2023 start
            column(CoInfo_Name; CoInfo.Name)
            {
            }
            column(CoInfo_Adr; CoInfo.Address)
            {
            }
            column(CoInfo_Adr2; CoInfo."Address 2")
            {
            }
            column(CoInfo_City; CoInfo.City)
            {
            }
            column(CoInfo_country; CoInfo.County)
            {
            }
            column(CoInfo_PostCode; CoInfo."Post Code")
            {
            }
            column(CoInfo_PhNo; CoInfo."Phone No.")
            {
            }
            column(NS_TextComma; NS_TextComma)
            {
            }
            column(NS_QtyShip; Format("NS_Total Qty. Ready to Ship"))
            {
            }
            //PE-114.RM.1.0 02Aug2023 end
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
            column(NS_Userid; UserId) { } //PE-215.HS.1.0 18Dec2023
            trigger OnAfterGetRecord();
            begin

                QuantityShipped := 0;
                CALCFIELDS("NS_Inv. Qty", "NS_PO Qty Staged");
                if "NS_Invt. Qty. to Ship" = 0 then
                    "NS_Invt. Qty. to Ship" := "NS_Inventory Qty. Staged";
                //PRJ-1432.GK.1.0 21July2022 start-comment
                // if "NS_PO Qty. to Ship" = 0 then
                //     "NS_PO Qty. to Ship" := "NS_PO Qty Staged";
                //PRJ-1432.GK.1.0 21July2022 end
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
                //PurchRcptLine.SETRANGE("NS_Journal Status", PurchRcptLine."NS_Journal Status"::Posted); //PRJCTPR-300.NC.1.0 28Feb2024 Block
                PurchRcptLine.SETRANGE("Job Task No.", "NS_Order Code"); //PRJCTPR-300.NC.1.0 28Feb2024
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

                //PRJ-1361.AS.1.0 START
                if (post = true) and (i = 1) then
                    NS_CreateJMPDeliveryticketArchive("Job Material Planning"."NS_Worksheet Job No.");
                //PRJ-1361.AS.1.0 END

                i += 1;//PRJ-1361

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

                //PE-215.HS.1.0 28Dec2023 Start
                NS_Resource.SetRange("No.", Job."Person Responsible");
                if NS_Resource.FindFirst() then
                    NS_PersonResponsible := NS_Resource.Name;
                //PE-215.HS.1.0 28Dec2023 End
            end;

            trigger OnPreDataItem();
            begin
                //SETRANGE("Worksheet Job No.",JobNo);
                i := 1;//PRJ-1361
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
        CoInfo.GET(); //PE-114.RM.1.0 02Aug2023 //Added open/close parenthesis.
        CoInfo.CALCFIELDS(Picture);
        //PE-114.RM.1.0 02Aug2023 start
        clear(NS_TextComma);
        if (CoInfo.City <> '') and (CoInfo.County <> '') then
            NS_TextComma := ','
        else
            NS_TextComma := '';
        //PE-114.RM.1.0 02Aug2023
    end;

    var
        CoInfo: Record "Company Information";
        NS_TextComma: Text[10]; //PE-114.RM.1.0 02Aug2023
        NS_QtyShip: Text; //PE-114.RM.1.0 02Aug2023
        Customer: Record Customer;
        Job: Record Job;
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Post: Boolean;
        QuantityShipped: Decimal;
        BoxText: Text[30];
        JobNo: Code[20];
        CustAddr: array[6] of Text;
        x: Integer;
        i: Integer;//PRJ-1361
        NoSeriesMgt: Codeunit NoSeriesManagement;//PRJ-1361
        NS_TodayDate: date; //PE-114.RM.1.0 10Aug2023

        //PE-215.HS.1.0 28Dec2023 Start
        NS_Resource: Record Resource;
        NS_PersonResponsible: Text[100];
    //PE-215.HS.1.0 28Dec2023 End

    procedure InitVar(lJobNo: Code[20]);
    begin
        JobNo := lJobNo;
    end;


    //PRJ-1361.AS.1.0 start
    procedure NS_CreateJMPDeliveryticketArchive(lJobNo: Code[20]);
    var
        DelvryArchve: Record "NS_Delivery ticket Archive";
        JMPRec1: Record "NS_Job Material Planning";
        JobStp: Record "Jobs Setup";
        RevNum: Integer;
        Revcode: code[20];
    begin
        Clear(Revcode);
        if JobStp.Get() then;

        JMPRec1.Reset();
        JMPRec1.SetRange("NS_Worksheet Job No.", lJobNo);
        JMPRec1.SetFilter("NS_Total Quantity Staged", '<>%1', 0);
        if JMPRec1.FindSet() then begin
            Revcode := NoSeriesMgt.GetNextNo(JobStp."NS_DelvArch Rev No.", WorkDate(), true);
            repeat
                DelvryArchve.Init();
                JMPRec1.CalcFields("NS_Inv. Qty", "NS_PO Qty", "NS_PO Qty Rcd", "NS_Job Site", "NS_Job Name", "NS_Quantity Invoiced", "NS_PO Qty Staged", "NS_Posted Quantity", "NS_Task Description", "NS_PO Return Qty. Shipped", "NS_PO Return Qty. Invoiced");

                DelvryArchve."NS_Worksheet Job No." := JMPRec1."NS_Worksheet Job No.";
                DelvryArchve."NS_Line No." := JMPRec1."NS_Line No.";

                DelvryArchve.NS_Revision := Revcode;

                DelvryArchve."NS_Document No." := JMPRec1."NS_Document No.";
                DelvryArchve."NS_Date Ordered By" := JMPRec1."NS_Date Ordered By";
                DelvryArchve."NS_Date Required" := JMPRec1."NS_Date Required";
                DelvryArchve."NS_Order Code" := JMPRec1."NS_Order Code";
                DelvryArchve.NS_Type := JMPRec1.NS_Type;
                DelvryArchve."NS_Part No." := JMPRec1."NS_Part No.";
                DelvryArchve.NS_Description := JMPRec1.NS_Description;
                DelvryArchve.NS_Details := JMPRec1.NS_Details;
                DelvryArchve.NS_Manufacturer := JMPRec1.NS_Manufacturer;
                DelvryArchve.NS_Vendor := JMPRec1.NS_Vendor;
                DelvryArchve."NS_Inv. Qty" := JMPRec1."NS_Inv. Qty";
                DelvryArchve."NS_Bal. Req" := JMPRec1."NS_Bal. Req";
                DelvryArchve.NS_Quantity := JMPRec1.NS_Quantity;
                DelvryArchve."NS_Job Name" := JMPRec1."NS_Job Name";
                DelvryArchve."NS_Location Code" := JMPRec1."NS_Location Code";
                DelvryArchve."NS_PO Qty Staged" := JMPRec1."NS_PO Qty Staged";
                DelvryArchve."NS_Job Description" := JMPRec1."NS_Job Description";
                DelvryArchve."NS_Customer Account Name" := JMPRec1."NS_Customer Account Name";
                DelvryArchve."NS_Total Qty. Ready to Ship" := JMPRec1."NS_Total Qty. Ready to Ship";
                DelvryArchve."NS_Inventory Qty. Staged" := JMPRec1."NS_Inventory Qty. Staged";
                DelvryArchve."NS_Box Text" := JMPRec1."NS_Box Text";
                DelvryArchve."NS_PO Qty. to Ship" := JMPRec1."NS_PO Qty. to Ship";
                DelvryArchve."NS_Invt. Qty. to Ship" := JMPRec1."NS_Invt. Qty. to Ship";
                DelvryArchve."NS_Total Quantity Staged" := JMPRec1."NS_Total Quantity Staged";
                DelvryArchve."NS_Posted Quantity" := JMPRec1."NS_Posted Quantity";
                DelvryArchve."NS_Task Description" := JMPRec1."NS_Task Description";
                DelvryArchve."NS_Purchase Res. G/L" := JMPRec1."NS_Purchase Res. G/L";
                DelvryArchve."NS_Unit Cost" := JMPRec1."NS_Unit Cost";
                DelvryArchve."NS_Total Cost" := JMPRec1."NS_Total Cost";
                DelvryArchve."NS_Job Plannine Line No." := JMPRec1."NS_Job Plannine Line No.";
                DelvryArchve."NS_Job Purchaser" := JMPRec1."NS_Job Purchaser";
                DelvryArchve."NS_Segment Code" := JMPRec1."NS_Segment Code";
                DelvryArchve."NS_Assembly Item on Job." := JMPRec1."NS_Assembly Item on Job.";
                DelvryArchve."NS_Item Name" := JMPRec1."NS_Item Name";
                DelvryArchve."NS_Quantity Per" := JMPRec1."NS_Quantity Per";
                DelvryArchve.NS_Level := JMPRec1.NS_Level;
                DelvryArchve."NS_Main Item" := JMPRec1."NS_Main Item";
                DelvryArchve."NS_Item Type" := JMPRec1."NS_Item Type";
                DelvryArchve."NS_Item Name New" := JMPRec1."NS_Item Name New";
                DelvryArchve."NS_Global Dimension 1 Code" := JMPRec1."NS_Global Dimension 1 Code";
                DelvryArchve."NS_Global Dimension 2 Code" := JMPRec1."NS_Global Dimension 2 Code";
                DelvryArchve."NS_Dimension Set ID" := JMPRec1."NS_Dimension Set ID";
                DelvryArchve."NS_Variant Code" := JMPRec1."NS_Variant Code";
                DelvryArchve."NS_Unit of Measure Code" := JMPRec1."NS_Unit of Measure Code";
                DelvryArchve."NS_Base UOM" := JMPRec1."NS_Base UOM";
                DelvryArchve."NS_Base UOM (Qty)" := JMPRec1."NS_Base UOM (Qty)";
                DelvryArchve.Insert();
            until JMPRec1.Next() = 0;
        end;
    end;
    //PRJ-1361.AS.1.0 end
}

