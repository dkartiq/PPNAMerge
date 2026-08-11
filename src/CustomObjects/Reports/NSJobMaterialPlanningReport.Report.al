report 14021370 "NS_Job Material PlanningReport"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-316.AS.1.0 30JUNE2020 Increased length
    DefaultLayout = RDLC;
    Caption = 'Job Material Planning Report';
    RDLCLayout = './Layouts/NSJob Material Planning Report.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(JMP; "NS_Job Material Planning")
        {
            DataItemTableView = SORTING("NS_Job Manager", "NS_Worksheet Job No.");
            RequestFilterFields = "NS_Job Manager", "NS_Worksheet Job No.";
            column(JMP_JobNo; JMP."NS_Worksheet Job No.")
            {
            }
            column(JMP_LineNo; JMP."NS_Line No.")
            {
            }
            column(JMP_DocumentNo; JMP."NS_Document No.")
            {
            }
            column(JMP_DateOrdered; JMP."NS_Date Ordered By")
            {
            }
            column(JMP_DateRequired; JMP."NS_Date Required")
            {
            }
            column(JMP_OrderCode; JMP."NS_Order Code")
            {
            }
            column(JMP_Type; JMP.NS_Type)
            {
            }
            column(JMP_PartNo; JMP."NS_Part No.")
            {
            }
            column(JMP_Descrp; JMP.NS_Description)
            {
            }
            column(JMP_Details; JMP.NS_Details)
            {
            }
            column(JMP_Manufacturer; JMP.NS_Manufacturer)
            {
            }
            column(JMP_Vendor; JMP.NS_Vendor)
            {
            }
            column(JMP_Quantity; JMP.NS_Quantity)
            {
            }
            column(JMP_InvQty; JMP."NS_Inv. Qty")
            {
            }
            column(JMP_POQty; JMP."NS_PO Qty")
            {
            }
            column(JMP_POQtyRcd; JMP."NS_PO Qty Rcd")
            {
            }
            column(JMP_JobSite; JMP."NS_Job Site")
            {
            }
            column(JMP_BalReq; JMP."NS_Bal. Req")
            {
            }
            column(JMP_InvAvail; JMP."NS_Inv. Avail")
            {
            }
            column(JMP_JobName; JMP."NS_Job Name")
            {
            }
            column(JMP_SubmittedBy; SubmittedBy)
            {
            }
            column(JMP_POQtyStagged; JMP."NS_PO Qty Staged")
            {
            }
            column(JMP_QuantityInvoiced; JMP."NS_Quantity Invoiced")
            {
            }
            column(JMP_JobDescr; JMP."NS_Job Description")
            {
            }
            column(JMP_CustomerAccountName; JMP."NS_Customer Account Name")
            {
            }
            column(JMP_JobSiteFromInv; JMP."NS_Job Site From Inv.")
            {
            }
            column(JMP_JobSiteVndrQty; JMP."NS_Job Site Vndr Qty")
            {
            }
            column(JMP_JobManager; JMP."NS_Job Manager")
            {
            }
            column(JMP_POQtyStaged; JMP."NS_PO Qty Staged")
            {
            }

            trigger OnAfterGetRecord();
            begin
                if "NS_Worksheet Job No." <> '' then
                    Job.GET("NS_Worksheet Job No.")
                else
                    CurrReport.SKIP();
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

    var
        SubmittedBy: Text;//PRJ-316.AS.1.0 30JUNE2020
        Job: Record Job;
        JobNo: Code[20];
        JobMngr: Text;//PRJ-316.AS.1.0 30JUNE2020

    procedure InitVar(lJobNo: Code[20]; lJobMngr: Text[50]);
    begin
        JobNo := lJobNo;
        JobMngr := lJobMngr;
    end;
}

