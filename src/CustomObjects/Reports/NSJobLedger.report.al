report 14021176 "NS_Job Ledger"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Replaced ReqFilterHeading to RequestFilterHeading 
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-301.N.S.1.0 24sep 2020 Change varible length
    //PRJ-410.AM.1.0 10OCT2020 | Made Changes in layout to avoid printing alternate blank pages.
    //PRJCTPR-213.HS.1.0 23Oct2023 | Done changes in RDL To increase column length of entry type,type, category code and removed time from header 
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Ledger.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Job Ledger';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", Status, "NS_Date Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(TIME; TIME)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Job_TABLECAPTION__________JobFilter; Job.TABLECAPTION + ': ' + JobFilter)
            {
            }
            column(Job_Ledger_Entry__TABLECAPTION__________JobLedgerEntryFilter; "Job Ledger Entry".TABLECAPTION + ': ' + JobLedgerEntryFilter)
            {
            }
            column(Job_TABLECAPTION_________Job_FIELDNAME__No_____________No__; Job.TABLECAPTION + ' ' + Job.FIELDNAME("No.") + ' ' + "No.")
            {
            }
            column(Job_Description; Description)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job_LedgerCaption; Job_LedgerCaptionLbl)
            {
            }
            column(Job_Ledger_Entry__Posting_Date_Caption; "Job Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Job_Ledger_Entry_TypeCaption; "Job Ledger Entry".FIELDCAPTION(Type))
            {
            }
            column(Job_Ledger_Entry__Document_No__Caption; "Job Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(Job_Ledger_Entry__Entry_Type_Caption; "Job Ledger Entry".FIELDCAPTION("Entry Type"))
            {
            }
            column(Job_Ledger_Entry__No__Caption; "Job Ledger Entry".FIELDCAPTION("No."))
            {
            }
            column(Job_Ledger_Entry_QuantityCaption; "Job Ledger Entry".FIELDCAPTION(Quantity))
            {
            }
            column(Job_Ledger_Entry__Unit_of_Measure_Code_Caption; "Job Ledger Entry".FIELDCAPTION("Unit of Measure Code"))
            {
            }
            column(Job_Ledger_Entry__Total_Cost_Caption; "Job Ledger Entry".FIELDCAPTION("Total Cost"))
            {
            }
            column(Job_Ledger_Entry_DescriptionCaption; "Job Ledger Entry".FIELDCAPTION(Description))
            {
            }
            column(Job_Ledger_Entry__Activity_Code_Caption; "Job Ledger Entry".FIELDCAPTION("NS_Activity Code"))
            {
            }
            column(VendorNameCaption; VendorNameCaptionLbl)
            {
            }
            column(Job_Ledger_Entry__Unit_Cost_Caption; "Job Ledger Entry".FIELDCAPTION("Unit Cost"))
            {
            }
            column(Job_Ledger_Entry__Process_Code_Caption; "Job Ledger Entry".FIELDCAPTION("NS_Process Code"))
            {
            }
            column(Job_Ledger_Entry__Operation_Code_Caption; "Job Ledger Entry".FIELDCAPTION("NS_Operation Code"))
            {
            }
            column(CatCodeCaption; CatCodeCaptionLbl)
            {
            }
            column(Job_No_; "No.")
            {
            }
            column(Job_Date_Filter; "NS_Date Filter")
            {
            }
            column(Job_Type_Filter; "NS_Type Filter")
            {
            }
            column(Job_Activity_Filter; "NS_Activity Filter")
            {
            }
            column(Job_Process_Filter; "NS_Process Filter")
            {
            }
            column(Job_Operation_Filter; "NS_Operation Filter")
            {
            }
            column(Job_Resource_Gr__Filter; "Resource Gr. Filter")
            {
            }
            dataitem("Job Ledger Entry"; "Job Ledger Entry")
            {
                //PE-308.DK.1.0 13JUNE2024 Start
                //DataItemLink = "Job No." = FIELD("No."), "Posting Date" = FIELD("NS_Date Filter"), Type = FIELD("NS_Type Filter"), "NS_Activity Code" = FIELD("NS_Activity Filter"), "NS_Process Code" = FIELD("NS_Process Filter"), "NS_Operation Code" = FIELD("NS_Operation Filter"), "Resource Group No." = FIELD("Resource Gr. Filter");
                DataItemLink = "Job No." = FIELD("No."), "Posting Date" = FIELD("NS_Date Filter"), Type = FIELD("NS_TypeEnumFilter"), "NS_Activity Code" = FIELD("NS_Activity Filter"), "NS_Process Code" = FIELD("NS_Process Filter"), "NS_Operation Code" = FIELD("NS_Operation Filter"), "Resource Group No." = FIELD("Resource Gr. Filter");
                //PE-308.DK.1.0 13JUNE2024 END
                DataItemTableView = SORTING("Job No.", "Posting Date") WHERE("Entry Type" = FILTER(< NS_Payment));
                RequestFilterFields = "Entry Type", "NS_Activity Code";
                RequestFilterHeading = 'Job Ledger Entry';

                column(Job_Ledger_Entry__Posting_Date_; "Posting Date")
                {

                }
                column(Job_Ledger_Entry_Type; Type)
                {
                }
                column(Job_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Job_Ledger_Entry__Entry_Type_; "Entry Type")
                {
                }
                column(Job_Ledger_Entry__No__; "No.")
                {
                }
                column(Job_Ledger_Entry_Quantity; Quantity)
                {
                    DecimalPlaces = 2 : 5;
                }
                column(Job_Ledger_Entry__Unit_of_Measure_Code_; "Unit of Measure Code")
                {
                }
                column(Job_Ledger_Entry__Total_Cost_; "Total Cost")
                {
                }
                column(Job_Ledger_Entry_Description; Description)
                {
                }
                column(Job_Ledger_Entry__Activity_Code_; "NS_Activity Code")
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(Job_Ledger_Entry__Unit_Cost_; "Unit Cost")
                {
                }
                column(Job_Ledger_Entry__Process_Code_; "NS_Process Code")
                {
                }
                column(Job_Ledger_Entry__Operation_Code_; "NS_Operation Code")
                {
                }
                column(CatCode; CatCode)
                {
                }
                column(TotalCost_1_; TotalCost[1])
                {
                }
                column(TotalCost_2_; -TotalCost[2])
                {
                }
                column(TotalCost_4_; TotalCost[4])
                {
                }
                column(TotalCost_3_; -TotalCost[3])
                {
                }
                column(Total_Usage_Caption; Total_Usage_CaptionLbl)
                {
                }
                column(Total_Sales_Caption; Total_Sales_CaptionLbl)
                {
                }
                column(Total_Release_Caption; Total_Release_CaptionLbl)
                {
                }
                column(Total_Earn_Caption; Total_Earn_CaptionLbl)
                {
                }
                column(Job_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Job_Ledger_Entry_Job_No_; "Job No.")
                {
                }
                column(Job_Ledger_Entry_Resource_Group_No_; "Resource Group No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IncrementTotals("Entry Type");

                    //Find Vendor
                    VendorName := '';
                    if "Document No." > '' then begin
                        if PurchInvHeader.GET("Document No.") then
                            VendorName := PurchInvHeader."Pay-to Name"
                        else begin
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("No.", "Document No.");
                            if PurchaseHeader.FINDFIRST then
                                VendorName := PurchaseHeader."Pay-to Name";
                        end;
                    end;

                    CatCode := '';
                    case "Entry Type" of
                        "Entry Type"::Usage, "Entry Type"::NS_Release:
                            CatCode := "NS_Job Cost Category";
                        "Entry Type"::Sale, "Entry Type"::NS_Earn:
                            CatCode := "NS_Job Revenue Category";
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    CLEAR(TotalCost);
                    CLEAR(TotalPrice);
                    CLEAR(AmtPostedToGL);
                    CLEAR(AmtRecognized);
                end;
            }
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
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;
        JobLedgerEntryFilter := "Job Ledger Entry".GETFILTERS;
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaseHeader: Record "Purchase Header";
        JobFilter: Text[250];
        JobLedgerEntryFilter: Text[250];
        TotalCost: array[5] of Decimal;
        TotalPrice: array[5] of Decimal;
        AmtPostedToGL: array[5] of Decimal;
        AmtRecognized: array[5] of Decimal;
        //VendorName: Text[50]; PRJ-301.N.S.1.0 23Sep2020 Comment
        VendorName: Text[100]; //PRJ-301.N.S.1.0 23Sep2020 Increase length
        CatCode: Code[10];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_LedgerCaptionLbl: Label 'Job Ledger';
        VendorNameCaptionLbl: Label 'Vendor Name';
        CatCodeCaptionLbl: Label 'Category Code';
        Total_Usage_CaptionLbl: Label 'Total Usage:';
        Total_Sales_CaptionLbl: Label 'Total Sales:';
        Total_Release_CaptionLbl: Label 'Total Release:';
        Total_Earn_CaptionLbl: Label 'Total Earn:';

    procedure IncrementTotals(EntryType: Integer);
    var
        i: Integer;
    begin
        i := EntryType + 1;
        TotalCost[i] := TotalCost[i] + "Job Ledger Entry"."Total Cost";
        TotalPrice[i] := TotalPrice[i] + "Job Ledger Entry"."Total Price";
        AmtPostedToGL[i] := AmtPostedToGL[i] + "Job Ledger Entry"."Amt. Posted to G/L";
    end;
}

