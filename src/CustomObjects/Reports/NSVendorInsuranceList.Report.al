report 14021186 "NS_Vendor Insurance List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption can't be used on area
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-319.AS.1.0 Added layout in outer AL Code box to visible report output
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSVendor Insurance List.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Vendor Insurance List';
    ApplicationArea = all;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(ExpirationDate; ExpirationDate)
            {
            }
            column(Vendor_Insurance_ListCaption; Vendor_Insurance_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ExpirationDateCaption; ExpirationDateCaptionLbl)
            {
            }
            column(Vendor_Insurance__Policy_No__Caption; "Vendor Insurance".FIELDCAPTION("NS_Policy No."))
            {
            }
            column(Vendor_Insurance__Carrier_Name_Caption; "Vendor Insurance".FIELDCAPTION("NS_Carrier Name"))
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Vendor_Insurance_ValueCaption; "Vendor Insurance".FIELDCAPTION(NS_Value))
            {
            }
            column(Vendor_Insurance__Expiration_Date_Caption; "Vendor Insurance".FIELDCAPTION("NS_Expiration Date"))
            {
            }
            column(Vendor_Insurance__Insurance_Type_Caption; "Vendor Insurance".FIELDCAPTION("NS_Insurance Type"))
            {
            }
            column(ExpiredStatusCaption; ExpiredStatusCaptionLbl)
            {
            }
            column(Vendor_No_; "No.")
            {
            }
            dataitem("Vendor Insurance"; "NS_Vendor Insurance")
            {
                DataItemLink = "NS_Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("NS_Vendor No.", "NS_Insurance Type", "NS_Policy No.") ORDER(Ascending);
                column(Vendor__No_____________Vendor_Name; Vendor."No." + ' - ' + Vendor.Name)
                {
                }
                column(Vendor_Insurance__Insurance_Type_; "NS_Insurance Type")
                {
                }
                column(Vendor_Insurance__Carrier_Name_; "NS_Carrier Name")
                {
                }
                column(Vendor_Insurance__Policy_No__; "NS_Policy No.")
                {
                }
                column(Vendor_Insurance_Value; NS_Value)
                {
                }
                column(Vendor_Insurance__Expiration_Date_; "NS_Expiration Date")
                {
                }
                column(InsuranceDescription; InsuranceDescription)
                {
                }
                column(ExpiredStatus; ExpiredStatus)
                {
                }
                column(Vendor_Caption; Vendor_CaptionLbl)
                {
                }
                column(Vendor_Insurance_Vendor_No_; "NS_Vendor No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    VendorInsuranceType.SETRANGE(NS_Code, "NS_Insurance Type");
                    if VendorInsuranceType.FINDFIRST() then
                        InsuranceDescription := VendorInsuranceType.NS_Description;

                    if (ExpirationDate > 0D) and ("Vendor Insurance"."NS_Expiration Date" > ExpirationDate) then
                        CurrReport.SKIP;

                    ExpiredStatus := '';
                    if "Vendor Insurance"."NS_Expiration Date" < TODAY() then
                        ExpiredStatus := Text001_Lbl;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //SMPL - Caption = 'RequestPage';
                group(Options)
                {
                    field("Expired After"; ExpirationDate)
                    {
                        Caption = 'Expired After';
                        ApplicationArea = All;
                        ToolTip = 'Expired After';
                    }
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

    var
        VendorInsuranceType: Record "NS_Vendor Insurance Type";
        ExpirationDate: Date;
        InsuranceDescription: Text[50];
        ExpiredStatus: Text[10];
        Vendor_Insurance_ListCaptionLbl: Label 'Vendor Insurance List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ExpirationDateCaptionLbl: Label 'Expired by:';
        DescriptionCaptionLbl: Label '';
        ExpiredStatusCaptionLbl: Label 'Status';
        Vendor_CaptionLbl: Label 'Vendor:';
        Text001_Lbl: Label 'Expired';
}

