report 14021491 NS_CommitmentReport
{
    //PE-23.NC.1.0 15May2023 Create New Report & Layout
    //PE-23.NC.2.0 27July2023 change in code & layout
    //PE-141.AS.1.0 14AUG2023 Done chnages in layout to add logo, comp address, userid, time,page
    //PRJCTPR-302.PS.1.0 31Jan2024 Changes in layout 
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCommitmentReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Commitment Report';

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(No_Job;
            "No.")
            { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }

            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            //PE-23.NC.2.0 27July2023 Start
            column(CurrencySymbol; GenLedSetup."Local Currency Symbol")
            {
            }
            //PE-23.NC.2.0 27July2023 End
            //PE-141.AS.1.0 14AUG2023 start
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            column(CompanyInformationAdd; CompanyInformation.Address) { }
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }//PE-141.AS.1.0 24AUG2023
            //PE-141.AS.1.0 14AUG2023 end
            column(USERID; UserId)
            {
            }
            column(Description_Job; Description)
            {
            }
            column(BarTextNNC; BarTextNNC)
            {
            }

            dataitem(NS_CommitmentReportTemp; NS_CommitmentReportTemp)
            {
                DataItemLink = "NS_Job No." = field("No.");

                column(NS_ChangeOrderCommitment_NS_CommitmentReportTemp; "NS_Change Order Commitment")
                {
                }
                column(NS_Description_NS_CommitmentReportTemp; NS_Description)
                {
                }
                column(NS_DocumentNo_NS_CommitmentReportTemp; "NS_Document No.")
                {
                }
                column(NS_DocumentType_NS_CommitmentReportTemp; "NS_Document Type")
                {
                }
                column(NS_InvoicedAmount_NS_CommitmentReportTemp; "NS_Invoiced Amount")
                {
                }
                column(NS_JobNo_NS_CommitmentReportTemp; "NS_Job No.")
                {
                }
                column(NS_OriginalCommitment_NS_CommitmentReportTemp; "NS_Original Commitment")
                {
                }
                column(NS_PaymentReceived_NS_CommitmentReportTemp; "NS_Payment Received")
                {
                }
                column(NS_PaymentsIssued_NS_CommitmentReportTemp; "NS_Payments Issued")
                {
                }
                column(NS_RetentionAmount_NS_CommitmentReportTemp; "NS_Retention Amount")
                {
                }
                column(NS_SubcontactNo_NS_CommitmentReportTemp; "NS_Subcontact No.")
                {
                }
                column(NS_VendorNo_NS_CommitmentReportTemp; "NS_Vendor No.")
                {
                }
                column(VendorName; RecVendor.Name)
                { }
                trigger OnAfterGetRecord()
                begin
                    if RecVendor.get("NS_Vendor No.") then;
                    if ((("NS_Invoiced Amount" + "NS_Payment Received") > 0) and (("NS_Original Commitment" + "NS_Change Order Commitment") > 0)) then
                        BarTextNNC := Round(("NS_Invoiced Amount" + "NS_Payment Received") / ("NS_Original Commitment" + "NS_Change Order Commitment") * 100, 1)
                    else
                        BarTextNNC := 0;


                    //PRJCTPR-302.PS.1.0 07Feb2024 Start
                    if "Include Sub-Levels" = false then
                        NS_CommitmentReportTemp."NS_Change Order Commitment" := 0;
                    //PRJCTPR-302.PS.1.0 07Feb2024 End

                end;
            }

            trigger OnAfterGetRecord()
            var
                NS_AllSubscriber: Codeunit "NS_AllSubscriber";
            begin
                NS_AllSubscriber.InsertCommitemtReportTable(Job, Job."No.");

            end;
        }
    }
    //PRJCTPR-302.PS.1.0 07Feb2024 Start



    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Include Sub-Levels"; "Include Sub-Levels")
                    {
                        Caption = 'Include Sub-Level';
                        ApplicationArea = All;
                        ToolTip = 'Enable this to Include Change Orders and Sub-levels Job';
                    }
                }
            }

        }
    }

    //PRJCTPR-302.PS.1.0 07Feb2024 End 
    trigger OnPreReport()
    begin
        if CompanyInformation.get() then;
        if GenLedSetup.Get() then; //PE-23.NC.2.0 27July2023
        CompanyInformation.CalcFields(Picture);//PE-141.AS.1.0 14AUG2023

        //PE-141.AS.1.0 start 24Aug2023
        if CompanyInformation.Address = '' then
            NS_CompanyInformationAdd := ''
        else
            NS_CompanyInformationAdd := CompanyInformation.Address;
        if CompanyInformation."Address 2" = '' then
            NS_CompanyInformationadd2 := ''
        else
            NS_CompanyInformationadd2 := CompanyInformation."Address 2";

        if CompanyInformation.City = '' then
            NS_CompanyInformationcity := ''
        else
            NS_CompanyInformationcity := CompanyInformation.City + ',' + ' ';
        if CompanyInformation.County = '' then
            NS_CompanyInformationCountry := ''
        else
            NS_CompanyInformationCountry := CompanyInformation.County + ' ';
        if CompanyInformation."Post Code" = '' then
            NS_CompanyInformationpost := ''
        else
            NS_CompanyInformationpost := CompanyInformation."Post Code";
        NS_CompanyFullAddress := NS_CompanyInformationcity + NS_CompanyInformationCountry + NS_CompanyInformationpost;

        //PE-141.AS.1.0 start 24Aug2023
    end;

    var
        NS_CommitRepTemp: Record NS_CommitmentReportTemp;
        GenLedSetup: Record "General Ledger Setup"; //PE-23.NC.2.0 27July2023
        RecVendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        //PE-141.AS.1.0 start 24Aug2023 
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        //PE-141.AS.1.0 24Aug2023 
        BarTextNNC: Integer;
        "Include Sub-Levels": Boolean; //PRJCTPR-302.PS.1.0 07Feb2024
}