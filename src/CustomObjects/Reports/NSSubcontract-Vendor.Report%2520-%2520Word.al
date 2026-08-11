report 14021315 "NS_Subcontract-Vendor"
{
    // PRJ-482.MS.1.0 create new report
    // PRJ-482.AS.1.0 12Jan2021  Added many new fields to the following dataitems
    // PRJ-676.RS.1.0 29May2021 | Custom Report Creation for V17
    //PRJCTPR-197 Dk.1.0 31March2023 | Job No. Rewrite Issue.

    DefaultLayout = Word;
    //RDLCLayout = './Layouts/NSCustomized subcontract Status by Vendor_New.rdl';//PRJ-218:AS:14April2020
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Subcontract-Vendor';
    ApplicationArea = all;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(Vendor__No; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }

            column(Address; Address)
            {
            }
            column(Address_2; "Address 2")
            {
            }
            column(City; City)
            {
            }

            column(Contact; Contact)
            {
            }
            column(Balance; Balance)
            {
            }
            column(Balance__LCY_; "Balance (LCY)")
            {
            }
            column(Balance_Due; "Balance Due")
            {
            }
            column(Purchaser_Code; "Purchaser Code")
            {
            }
            // PRJ-482.AS.1.0 START
            column(Cash_Flow_Payment_Terms_Code; "Cash Flow Payment Terms Code")
            {
            }
            column(Creditor_No_; "Creditor No.")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(E_Mail; "E-Mail")
            {
            }
            column(Fax_No_; "Fax No.")
            {
            }
            column(Fin__Charge_Terms_Code; "Fin. Charge Terms Code")
            {
            }
            column(IC_Partner_Code; "IC Partner Code")
            {
            }
            column(Gen__Bus__Posting_Group; "Gen. Bus. Posting Group")
            {
            }
            column(Vendor_Posting_Group; "Vendor Posting Group")
            {
            }
            column(Tax_Area_Code; "Tax Area Code")
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(Post_Code; "Post Code")
            {
            }
            // PRJ-482.AS.1.0 END

            // PRJ-676.RS.1.0 29May2021 Start
            column(companyinfo_Name; companyinfo.Name)
            {
            }
            column(companyinfo_Address; companyinfo.Address)
            {
            }
            column(companyinfo_Address_2; companyinfo."Address 2")
            {
            }
            column(companyinfo_Picture; companyinfo.Picture)
            {
            }
            column(companyinfo_GLN; companyinfo.GLN)
            {
            }
            column(companyinfo_GiroNo; companyinfo."Giro No.")
            {
            }
            column(companyinfo_EMail; companyinfo."E-Mail")
            {
            }
            // PRJ-676.RS.2.0
            column(companyinf_Country_RegionCode; companyinfo."Country/Region Code")
            {
            }
            column(companyinfo_county; companyinfo.County)
            {
            }
            column(companyinfo_Allow_Blank_Payment_Info; companyinfo."Allow Blank Payment Info.")
            {
            }
            column(companyinfo_City; companyinfo.City)
            {
            }
            column(companyinfo_Contact_Person; companyinfo."Contact Person")
            {
            }
            column(companyinfo_FaxNo; companyinfo."Fax No.")
            {
            }
            column(companyinfo_IBAN; companyinfo.IBAN)
            {
            }
            column(companyinfo_PhoneNo; companyinfo."Phone No.")
            {
            }
            column(companyinfo_Post_Code; companyinfo."Post Code")
            {
            }
            column(companyinfo_Registration_No; companyinfo."Registration No.")
            {
            }
            //PPDA.1.0 START COMMENT
            // column(companyinfo_Federal_ID_No; companyinfo."Federal ID No.")
            // {
            // }
            // column(companyinfo_RFC_No; companyinfo."RFC No.")
            // {
            // }
            //PPDA.1.0 END COMMENT
            column(companyinfo_Location_Code; companyinfo."Location Code")
            {
            }
            column(companyinfo_SWIFT_Code; companyinfo."SWIFT Code")
            {
            }
            column(companyinfo_Responsibility_Center; companyinfo."Responsibility Center")
            {
            }
            //PPDA.1.0 START COMMENT
            // column(companyinfo_Tax_Area_Code; companyinfo."Tax Area Code")
            // {
            // }
            // column(companyinfo_Tax_Exemption_No; companyinfo."Tax Exemption No.")
            // {
            // }
            // column(companyinfo_Tax_Scheme; companyinfo."Tax Scheme")
            // {
            // }
            // column(companyinfo_Provincial_Tax_Area_Code; companyinfo."Provincial Tax Area Code")
            // {
            // }
            // column(companyinfo_CURP_No; companyinfo."CURP No.")
            // {
            // }
            //PPDA.1.0 END COMMENT
            column(companyinfo_Telex_No; companyinfo."Telex No.")
            {
            }
            // PRJ-676.RS.2.0
            // PRJ-676.RS.1.0 29May2021 End
            dataitem(Subcontract_Header; NS_Subcontract)
            {
                DataItemLink = "NS_Buy-from Vendor No." = FIELD("No.");
                RequestFilterFields = "NS_No.";
                DataItemLinkReference = vendor;
                column(Vendor_No;
                "NS_Buy-from Vendor No.")
                {
                }
                column(No; "NS_No.")
                {
                }
                column(Description; NS_Description)
                {
                }
                column(Starting_Date; "NS_Starting Date")
                {
                }
                column(Subcontract_No; "NS_No.")
                {
                }
                column(Subcontract_Description; NS_Description)
                {
                }
                column(NS_Job_No_; "NS_Job No.")
                {
                }
                column(NS_Buy_from_Vendor_No_; "NS_Buy-from Vendor No.")
                {
                }
                // PRJ-482.AS.1.0 START
                column(NS_Buy_fromCountry_RegionCode; "NS_Buy-fromCountry/RegionCode")
                {
                }
                column(NS_Buy_from_Post_Code; "NS_Buy-from Post Code")
                {
                }
                column(NS_Buy_from_City; "NS_Buy-from City")
                {
                }
                column(NS_Buy_from_Address; "NS_Buy-from Address")
                {
                }
                column(NS_Buy_from_Address_2; "NS_Buy-from Address 2")
                {
                }
                column(NS_Contract_No_; "NS_Contract No.")
                {
                }
                column(NS_Contract_Type; "NS_Contract Type")
                {
                }
                column(NS_County; NS_County)
                {
                }
                column(NS_Currency_Code; "NS_Currency Code")
                {
                }
                column(NS_Description; NS_Description)
                {
                }
                column(NS_Ending_Date; "NS_Ending Date")
                {
                }
                column(NS_Global_Dimension_1_Code; "NS_Global Dimension 1 Code")
                {
                }
                column(NS_Description_2; "NS_Description 2")
                {
                }
                column(NS_Tax_Area_Code; "NS_Tax Area Code")
                {
                }
                column(NS_Progress_Payment_Sub_Level; "NS_Progress Payment Sub-Level")
                {
                }
                column(NS_Status; NS_Status)
                {
                }
                column(NS_Retention_Percent; "NS_Retention Percent")
                {
                }

                column(NS_Vendor_Job_No_; "NS_Vendor Job No.")
                {
                }
                column(NS_Sub_LeveltoSubcontractNo_; "NS_Sub-LeveltoSubcontractNo.")
                {
                }
                // PRJ-482.AS.1.0 END

                // PRJ-676.RS.1.0 29May2021 Start
                column(NS_NameBuyfromName_Subcontract; "NS_Buy-from Name")
                {
                }
                column(NS_Subcontract_Address_1; "NS_Subcontract Address 1")
                {
                }
                column(NS_Subcontract_City; "NS_Subcontract City")
                {
                }
                column(NS_SubcontractCountry_RegnCode; "NS_SubcontractCountry/RegnCode")
                {
                }
                column(NS_Subcontract_Post_Code; "NS_Subcontract Post Code")
                {
                }
                column(NS_Subcontract; "NS_No.")
                {
                }
                column(NS_Subcontract_Contact; "NS_Subcontract Contact")
                {
                }
                column(NS_Subcontract_Buy_from_Name; "NS_Buy-from Name")
                {
                }
                column(NS_Subcontract_Completion_Date; "NS_Completion Date")
                {
                }
                // PRJ-676.RS.2.0
                column(NS_Creation_Date; "NS_Creation Date")
                {
                }
                column(NS_Starting_Date; "NS_Starting Date")
                {

                }
                column(NS_Person_Responsible; "NS_Person Responsible")
                {

                }
                column(NS_Global_Dimension_2_Code; "NS_Global Dimension 2 Code")
                {

                }
                column(NS_Language_Code; "NS_Language Code")
                {

                }
                column(NS_Picture; NS_Picture)
                {
                }
                column(NS_Buy_from_Name; "NS_Buy-from Name")
                {

                }
                column(NS_Next_Invoice_Date; "NS_Next Invoice Date")
                {

                }
                column(NS_SubcontractLinesExist; NS_SubcontractLinesExist)
                {

                }
                column(NS_Subcon_Class; "NS_Subcon Class")
                {

                }
                column(NS_Subcontract_Address_2; "NS_Subcontract Address 2")
                {

                }
                column(NS_Subcontract_Cost_Posting; "NS_Subcontract Cost Posting")
                {

                }
                column(NS_Subcontract_County; "NS_Subcontract County")
                {

                }
                column(NS_Subcontract_Phone; "NS_Subcontract Phone")
                {

                }
                column(NS_Purchase_Document_No_; "NS_Purchase Document No.")
                {

                }
                column(NS_Purchase_Document_Type; "NS_Purchase Document Type")
                {

                }
                column(NS_Progress_Payment_No_; "NS_Progress Payment No.")
                {

                }
                column(NS_Contract_Date; "NS_Contract Date")
                {

                }
                column(NS_Contract_Purchase_Price; "NS_Contract Purchase Price")
                {

                }
                column(NS_Blocked; NS_Blocked)
                {

                }
                column(NS_Tax_Liable; "NS_Tax Liable")
                {

                }
                column(NS_Temp_LinkedParentSubcontNo_; "NS_Temp LinkedParentSubcontNo.")
                {

                }
                column(NS_SubcontractUsageCost_LCY_; "NS_SubcontractUsageCost(LCY)")
                {

                }
                column(NS_Scheduled_Res__Qty_; "NS_Scheduled Res. Qty.")
                {

                }
                column(NS_Scheduled_Res__Gr__Qty_; "NS_Scheduled Res. Gr. Qty.")
                {

                }
                column(NS_Retention_Ledger_Filter; "NS_Retention Ledger Filter")
                {

                }
                // PRJ-676.RS.2.0
                // PRJ-676.RS.1.0 29May2021 End

                dataitem(Job; Job)
                {
                    DataItemLink = "no." = FIELD("NS_Job No.");
                    DataItemTableView = SORTING("No.") ORDER(Ascending);
                    DataItemLinkReference = Subcontract_Header;

                    column(No_; "No.")
                    {
                    }
                    column(Job_Description; Description)
                    {
                    }
                    column(NS_Sub_Level_to_Job_No_; "NS_Sub-Level to Job No.")
                    {
                    }
                    column(Bill_to_Customer_No_; "Bill-to Customer No.")
                    {
                    }
                    column(NS_Manager; NS_Manager)
                    {
                    }
                    column(NS_Job_Address_1; "NS_Job Address 1")
                    {
                    }
                    column(NS_Job_Address_2; "NS_Job Address 2")
                    {
                    }
                    column(NS_Job_City; "NS_Job City")
                    {
                    }
                    column(NS_Job_County; "NS_Job County")
                    {
                    }
                    column(NS_Customer_Job_No_; "NS_Customer Job No.")
                    {
                    }
                    column(NS_Customer_PO_Number; "NS_Customer PO Number")
                    {
                    }

                    column(NS_Customer_Account; "NS_Customer Account")
                    {
                    }

                    column(NS_Job_Site_Customer_Name; "NS_Job Site Customer Name")
                    {
                    }

                    column(NS_Job_Site_Customer_No_; "NS_Job Site Customer No.")
                    {
                    }
                    column(NS_Gen__Bus__Posting_Group; "NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
                    {
                    }
                    column(NS_Gen__Prod__Posting_Group; "NS_Gen. Prod. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
                    {
                    }
                    column(Status; Status)
                    {
                    }
                    column(Project_Manager; "Project Manager")
                    {
                    }
                    column(NS_Job_Class; "NS_Job Class")
                    {
                    }
                    column(NS_Project_Manager_Name; "NS_Project Manager Name")
                    {
                    }

                    column(NS_Project_Manager_No_; "NS_Project Manager No.")
                    {
                    }

                    column(NS_Quote_No_; "NS_Quote No.")
                    {
                    }

                    column(NS_Quote_Revision; "NS_Quote Revision")
                    {
                    }
                    column(NS_VAT_Prod__Posting_Group; "NS_VAT Prod. Posting Group")
                    {
                    }
                    column(NS_VAT_Bus__Posting_Group; "NS_VAT Bus. Posting Group")
                    {
                    }
                    //PRJCTPR-197 Dk.1.0 Start
                    // column(NS_Job_Type; "NS_Job Type")
                    // {
                    // }
                    column(NS_Job_Type; "NS_Job Type New")
                    {
                    }
                    //PRJCTPR-197 Dk.1.0 End
                    column(NS_Job_Status_Date; "NS_Job Status Date")
                    {
                    }
                    column(NS_Estimator; NS_Estimator)
                    {
                    }
                    column(NS_Estimated_Start_Date; "NS_Estimated Start Date")
                    {
                    }
                    column(NS_Estimated_Completion_Date; "NS_Estimated Completion Date")
                    {
                    }
                    //PRJCTPR-308.DK.1.0 Start
                    // column(NS_Job_Calendar_Type; "NS_Job Calendar Type")
                    // {
                    // }
                    column(NS_Job_Calendar_Type; "NS_JobCalendarType")
                    {
                    }
                    //PRJCTPR-308.DK.1.0 End
                    // PRJ-482.AS.1.0 START
                    column(Bill_to_Address; "Bill-to Address")
                    {
                    }
                    column(Bill_to_Address_2; "Bill-to Address 2")
                    {
                    }
                    column(Bill_to_City; "Bill-to City")
                    {
                    }
                    column(Bill_to_Contact_No_; "Bill-to Contact No.")
                    {
                    }
                    column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code")
                    {
                    }
                    column(Bill_to_County; "Bill-to County")
                    {
                    }
                    column(Bill_to_Name; "Bill-to Name")
                    {
                    }
                    column(Bill_to_Name_2; "Bill-to Name 2")
                    {
                    }
                    column(Bill_to_Post_Code; "Bill-to Post Code")
                    {
                    }
                    column(Customer_Disc__Group; "Customer Disc. Group")
                    {
                    }
                    column(Customer_Price_Group; "Customer Price Group")
                    {
                    }
                    column(Global_Dimension_1_Code; "Global Dimension 1 Code")
                    {
                    }
                    column(Global_Dimension_2_Code; "Global Dimension 2 Code")
                    {
                    }
                    column(NS_DFR_Nos_; "NS_DFR Nos.")
                    {
                    }
                    column(NS_Prepmt__Cr__Memo_No_; "NS_Prepmt. Cr. Memo No.")
                    {
                    }
                    column(NS_Prepmt__Payment_Terms_Code; "NS_Prepmt. Payment Terms Code")
                    {
                    }
                    column(NS_Sell_to_Customer_Name; "NS_Sell-to Customer Name")
                    {
                    }
                    column(NS_Sell_to_Customer_No_; "NS_Sell-to Customer No.")
                    {
                    }

                    column(Person_Responsible; "Person Responsible")
                    {
                    }
                    column(NS_Owner_Name; "NS_Owner Name")
                    {
                    }
                    column(NS_Owner_No_; "NS_Owner No.")
                    {
                    }
                    column(NS_General_Contractor_Name; "NS_General Contractor Name")
                    {
                    }
                    column(NS_General_Contractor_No_; "NS_General Contractor No.")
                    {
                    }
                    column(NS_Architect_Engineer_Name; "NS_Architect/Engineer Name")
                    {
                    }
                    column(NS_Architect_Engineer_No_; "NS_Architect/Engineer No.")
                    {
                    }
                    column(NS_Created_from_Quote_No_; "NS_Created from Quote No.")
                    {
                    }
                    column(Creation_Date; "Creation Date")
                    {
                    }
                    column(NS_Unit_of_Measure; "NS_Unit of Measure")
                    {
                    }
                    column(NS_Completion_Date; "NS_Completion Date")
                    {
                    }
                    column(Comment; Comment)
                    {
                    }
                    column(Search_Description; "Search Description")
                    {
                    }
                    column(Description_2; "Description 2")
                    {
                    }
                    column(Job_Posting_Group; "Job Posting Group")
                    {
                    }
                    column(Language_Code; "Language Code")
                    {
                    }
                    column(NS_Actual_Percent_Complete; "NS_Actual Percent Complete")
                    {
                    }
                    column(NS_Tax_Group_Code; "NS_Tax Group Code New") //PRJCTPR-298.JS.1.0
                    {
                    }
                    // column(NS_Tax_Group_Code; "NS_Tax Group Code") //PRJCTPR-298.JS.1.0
                    // {
                    // }
                    column(NS_Actual_PercentCompleteDate; "NS_Actual PercentCompleteDate")
                    {
                    }
                    column(NS_Job_Revenue_Posting; "NS_Job Revenue Posting")
                    {
                    }
                    column(NS_Progress_Billing_Sub_Level; "NS_Progress Billing Sub-Level")
                    {
                    }
                    column(NS_Prepayment_No_; "NS_Prepayment No.")
                    {
                    }
                    column(NS_Contract_Sell_Price; "NS_Contract Sell Price")
                    {
                    }
                    column(NS_OS_File_Name; "NS_OS File Name")
                    {
                    }
                    column(NS_Prepayment__; "NS_Prepayment %")
                    {
                    }
                    column(NS_Prepayment_Due_Date; "NS_Prepayment Due Date")
                    {
                    }
                    column(NS_Prepayment_Amount; "NS_Prepayment Amount")
                    {
                    }
                    column(NS_Prepmt__Payment_Discount__; "NS_Prepmt. Payment Discount %")
                    {
                    }
                    // PRJ-482.AS.1.0 END

                    // PRJ-676.RS.1.0 29May2021 Start
                    column(No_Job; "No.")
                    {
                    }
                    column(NS_Job_Contract_No; "NS_Contract No.")
                    {
                    }
                    column(NS_Job_Budgeted_Price__LCY; "NS_Budgeted Price (LCY)")
                    {
                    }
                    // PRJ-676.RS.2.0
                    column(NS_AP_Comment; "NS_AP Comment")
                    {

                    }
                    column(NS_CCIP_OCIP_RCOIP_Insurance; "NS_CCIP/OCIP/RCOIP Insurance")
                    {

                    }
                    column(NS_Global_Dimension_1_Filter; "NS_Global Dimension 1 Filter")
                    {

                    }
                    column(NS_Global_Dimension_2_Filter; "NS_Global Dimension 2 Filter")
                    {

                    }
                    column(NS_Forecast_Type; "NS_Forecast Type")
                    {

                    }
                    column(NS_Invoiced_Price__LCY_; "NS_Invoiced Price (LCY)")
                    {

                    }
                    column(NS_Budget_Type_Filter; "NS_Budget Type Filter")
                    {

                    }
                    column(NS_Budgeted_Cost__LCY_; "NS_Budgeted Cost (LCY)")
                    {

                    }
                    column(NS_Budgeted_Cost_Quantity; "NS_Budgeted Cost Quantity")
                    {

                    }
                    column(NS_Budgeted_Price__LCY_; "NS_Budgeted Price (LCY)")
                    {

                    }
                    column(NS_Budgeted_Price_Quantity; "NS_Budgeted Price Quantity")
                    {

                    }
                    column(NS_Budgeted_Res__Gr__Qty_; "NS_Budgeted Res. Gr. Qty.")
                    {

                    }
                    column(NS_Budgeted_Res__Qty_; "NS_Budgeted Res. Qty.")
                    {

                    }
                    column(NS_Contract_For; "NS_Contract For")
                    {

                    }
                    column(NS_Forecast_Method; "NS_Forecast Method")
                    {

                    }
                    column(NS_Indirect_Burden_Type; "NS_Indirect Burden Type")
                    {

                    }
                    column(NS_Job_Calendar_Code; "NS_Job Calendar Code")
                    {

                    }
                    column(NS_Job_Contact; "NS_Job Contact")
                    {

                    }
                    column(NS_Job_Country_Region_Code; "NS_Job Country/Region Code")
                    {

                    }
                    column(NS_Job_Phone; "NS_Job Phone")
                    {

                    }
                    column(NS_Job_Post_Code; "NS_Job Post Code")
                    {

                    }
                    column(NS_Job_Posting_Date; "NS_Job Posting Date")
                    {

                    }
                    // PRJ-676.RS.2.0
                    //PRJ-676.RS.1.0 29May2021 End
                }
                dataitem(Subcontract_Lines_Detail; "NS_Subcontract Lines")
                {
                    DataItemLink = "NS_Subcontract No." = FIELD("NS_No.");
                    DataItemTableView = SORTING("NS_Subcontract No.", "NS_Line No.") ORDER(Ascending);
                    DataItemLinkReference = Subcontract_Lines_Detail;

                    column(B_Job_No; "NS_Job No.")
                    {
                    }
                    column(B_Job_Description; Job.Description)
                    {
                    }
                    column(B_Job_Task_No; "NS_Job Task No.")
                    {
                    }
                    column(B_Subcontract_Line_Description; NS_Description)
                    {
                    }
                    column(B_Type; NS_Type)
                    {
                    }
                    column(B_No; "NS_No.")
                    {
                    }
                    column(B_Quantity; NS_Quantity)
                    {
                    }
                    column(B_Unit_Of_Measure_Code; "NS_Unit of Measure Code")
                    {
                    }
                    column(B_Unit_Cost; "NS_Unit Cost")
                    {
                    }
                    column(B_Total_Cost; "NS_Total Cost")
                    {
                    }

                    // PRJ-482.AS.1.0 START
                    column(NS_Operation_Code; "NS_Operation Code")
                    {
                    }
                    column(NS_Job_Cost_Category; "NS_Job Cost Category")
                    {
                    }
                    column(NS_Job_Planning_Line_No_; "NS_Job Planning Line No.")
                    {
                    }
                    column(NS_PO_Line_No_; "NS_PO Line No.")
                    {
                    }
                    column(NS_PO_No_; "NS_PO No.")
                    {
                    }
                    column(NS_Process_Code; "NS_Process Code")
                    {
                    }
                    column(NS_Progress_Payment_Method; "NS_Progress Payment Method")
                    {
                    }
                    column(NS_Quantity; NS_Quantity)
                    {
                    }
                    column(NS_Quantity__Base_; "NS_Quantity (Base)")
                    {
                    }
                    column(NS_Subcontract_No_; "NS_Subcontract No.")
                    {
                    }
                    column(NS_Type; NS_Type)
                    {
                    }
                    column(NS_Unit_of_Measure_Code; "NS_Unit of Measure Code")
                    {
                    }
                    column(NS_Variant_Code; "NS_Variant Code")
                    {
                    }
                    column(NS_Work_Unit_of_Measure; "NS_Work Unit of Measure")
                    {
                    }
                    // PRJ-482.AS.1.0 END

                    //PRJ-676.RS.1.0 29May2021 Start
                    column(NS_Subcontract_Lines_Total_Cost; "NS_Total Cost")
                    {
                    }
                    // PRJ-676.RS.2.0
                    column(NS_Activity_Code; "NS_Activity Code")
                    {

                    }
                    column(NS_Base_Amount; "NS_Base Amount")
                    {

                    }
                    column(NS_Direct_Unit_Cost; "NS_Direct Unit Cost")
                    {

                    }
                    column(NS_Job_Task_No_; "NS_Job Task No.")
                    {

                    }
                    column(NS_Unit_Cost; "NS_Unit Cost")
                    {

                    }
                    column(NS_Work_Units; "NS_Work Units")
                    {

                    }
                    column(NS_No_; "NS_No.")
                    {

                    }
                    column(NS_Qty__per_Unit_of_Measure; "NS_Qty. per Unit of Measure")
                    {

                    }
                    column(NS_Shortcut_Dimension_1_Code; "NS_Shortcut Dimension 1 Code")
                    {

                    }
                    column(NS_Shortcut_Dimension_2_Code; "NS_Shortcut Dimension 2 Code")
                    {

                    }
                    column(NS_Job_Task_Description; "NS_Job Task Description")
                    {

                    }
                    // PRJ-676.RS.2.0
                    //PRJ-676.RS.1.0 29May2021 End

                    trigger OnAfterGetRecord();
                    begin


                    end;

                    trigger OnPreDataItem();
                    begin

                    end;
                }

                trigger OnAfterGetRecord();
                begin

                end;

                trigger OnPreDataItem();
                begin
                    companyinfo.get();
                end;
            }

            trigger OnAfterGetRecord();
            begin

            end;

            trigger OnPreDataItem();
            begin

            end;
        }
    }
    trigger OnPreReport()
    begin

    end;

    var
        companyinfo: Record "Company Information";
}







