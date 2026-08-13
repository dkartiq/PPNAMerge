report 14021290 "NS_Sales Invoice by Work Order"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    // SMPL Replaced ApplicationManagement codeunit to TextManagement
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-751.RS.1.0 14June21 | Cloned of TMF: 10: Product Change: Change the names associated with the Manager Job Status on Job Card (88)//PRJ-751.AS.1.0 06July2021 Roll back because it was wrong 
    DefaultLayout = RDLC;
    Caption = 'Sales Invoice by Work Order';
    RDLCLayout = './Layouts/NSSales Invoice by Work Order.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("NS_Job Class" = CONST("Master Job"));
            column(Job_No; Job."No.")
            {
            }
            column(Job_Description; Job.Description)
            {
            }
            column(Job_Status; Job.Status)
            {
            }
            column(Job_CompletionDate; Job."NS_Completion Date")
            {
            }
            column(Job_BillToName; Job."Bill-to Name")
            {
            }
            column(Job_Phone; Job."NS_Job Phone")
            {
            }
            column(Job_Contact; Job."NS_Job Contact")
            {
            }
            column(Job_Manager; ManagerResource.Name)
            {
            }
            column(BillToAddress1; BillToAddress[1])
            {
            }
            column(BillToAddress2; BillToAddress[2])
            {
            }
            column(BillToAddress3; BillToAddress[3])
            {
            }
            column(BillToAddress4; BillToAddress[4])
            {
            }
            column(BillToAddress5; BillToAddress[5])
            {
            }
            column(BillToAddress6; BillToAddress[6])
            {
            }
            column(Customer_Fax; Customer."Fax No.")
            {
            }
            column(PaymentTerms; PaymentTerms.Description)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_PhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyInformation_FaxNo; CompanyInformation."Fax No.")
            {
            }
            column(CompanyAddress1; CompanyAddress[1])
            {
            }
            column(CompanyAddress2; CompanyAddress[2])
            {
            }
            column(CompanyAddress3; CompanyAddress[3])
            {
            }
            column(CompanyAddress4; CompanyAddress[4])
            {
            }
            column(CompanyAddress5; CompanyAddress[5])
            {
            }
            column(CompanyAddress6; CompanyAddress[6])
            {
            }
            dataitem(WorkOrder; Job)
            {
                DataItemLink = "NS_Sub-Level to Job No." = FIELD("No.");
                //DataItemTableView = SORTING("NS_Sub-Level to Job No.", "NS_Contract Date") ORDER(Ascending) WHERE("NS_Job Class" = CONST("Work Order"), "NS_Manager Job Status" = CONST(Approved));//PRJ-751.RS.1.0 14June21 change from Approval to Approved //PRJ-751.AS.1.0 06July2021. All commented done by RS. Roll back because it was wrong 
                DataItemTableView = SORTING("NS_Sub-Level to Job No.", "NS_Contract Date") ORDER(Ascending) WHERE("NS_Job Class" = CONST("Work Order"), "NS_Manager Job Status" = CONST("Budget Review"));//PRJ-751.AS.1.0 06July2021 //PRJ-751.AS.1.0 06July2021 After roll back previous changes done again
                column(WorkOrder_No; WorkOrder."No.")
                {
                }
                column(WorkOrder_CustomerPONumber; WorkOrder."NS_Customer PO Number")
                {
                }
                column(WorkOrder_Description; WorkOrder.Description)
                {
                }
                column(WorkOrder_StartingDate; WorkOrder."Starting Date")
                {
                }
                column(WorkOrder_Address1; WorkOrder."NS_Job Address 1")
                {
                }
                dataitem("Job Cost Category"; "NS_Job Cost Category")
                {
                    DataItemTableView = SORTING(NS_Code) ORDER(Ascending);
                    column(JobCostCategory_Code; "Job Cost Category".NS_Code)
                    {
                    }
                    column(JobCostCategory_Description; "Job Cost Category".NS_Description)
                    {
                    }
                    column(JobCostCategory_Total; JobCostCategoryTotal)
                    {
                    }

                    trigger OnAfterGetRecord();
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        SalesLine.RESET();
                        SalesLine.SETRANGE("Job No.", WorkOrder."No.");
                        SalesLine.SETRANGE("NS_Job Cost Category", "Job Cost Category".NS_Code);
                        SalesLine.SETFILTER("Posting Date", PostingDateFilter);
                        SalesLine.CALCSUMS("Line Amount");
                        JobCostCategoryTotal := SalesLine."Line Amount";
                        if JobCostCategoryTotal = 0 then
                            CurrReport.SKIP;
                    end;
                }
            }

            trigger OnAfterGetRecord();
            var
                SubJob: Record Job;
            begin
                SubJob.RESET();
                SubJob.SETRANGE("NS_Job Class", SubJob."NS_Job Class"::"Work Order");
                SubJob.SETRANGE("NS_Sub-Level to Job No.", "No.");
                //PRJ-751.AS.1.0 06July2021 Roll back because it was wrong - start
                //SubJob.SETRANGE("NS_Manager Job Status", "NS_Manager Job Status"::"Budget Review");//PRJ-751 Comment//PRJ-751.AS.1.0 06July2021
                //SubJob.SETRANGE("NS_Manager Job Status", "NS_Manager Job Status"::Approved);//PRJ-751 Add//PRJ-751.AS.1.0 06July2021
                //PRJ-751.AS.1.0 06July2021 Roll back because it was wrong - end
                SubJob.SETRANGE("NS_Manager Job Status", "NS_Manager Job Status"::"Budget Review");//PRJ-751.AS.1.0 06July2021 Previous changes done again
                if not SubJob.FINDFIRST() then
                    CurrReport.SKIP;

                NS_FormatAdress.NS_JobBillTo(BillToAddress, Job);

                if ManagerResource.GET(NS_Manager) then;

                if Customer.GET("Bill-to Customer No.") then
                    if PaymentTerms.GET(Customer."Payment Terms Code") then;
            end;

            trigger OnPreDataItem();
            begin
                if JobNo <> '' then
                    SETRANGE("No.", JobNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Job No."; JobNo)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown();
                    var
                        LocalJob: Record Job;
                        LocalJobList: Page "Job List";
                    begin
                        CLEAR(LocalJob);
                        LocalJob.SETRANGE("NS_Job Class", LocalJob."NS_Job Class"::"Master Job");
                        LocalJobList.LOOKUPMODE(true);
                        LocalJobList.SETTABLEVIEW(LocalJob);
                        if LocalJobList.RUNMODAL = ACTION::LookupOK then begin
                            LocalJobList.GETRECORD(LocalJob);
                            JobNo := LocalJob."No.";
                        end;
                    end;
                }
                field("Posting Date"; PostingDateFilter)
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    var
                        AppMgt: Codeunit "Filter Tokens";
                    begin
                        AppMgt.MakeDateFilter(PostingDateFilter);
                    end;
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
        if CompanyInformation.GET then
            CompanyInformation.CALCFIELDS(Picture);
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;

    var
        JobCostCategoryTotal: Decimal;
        PostingDateFilter: Text;
        JobNo: Code[20];
        CompanyInformation: Record "Company Information";
        CompanyAddress: array[8] of Text[50];
        FormatAddress: Codeunit "Format Address";
        NS_FormatAdress: Codeunit "NS_Format Address";
        ManagerResource: Record Resource;
        BillToAddress: array[8] of Text[50];
        PaymentTerms: Record "Payment Terms";
        Customer: Record Customer;
}

