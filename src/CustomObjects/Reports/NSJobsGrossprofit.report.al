report 14021177 "NS_Jobs Gross Profit"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //SMPL - Caption = 'RequestPage' can't be used on area
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-708.N.S.1.0 change report layout because report comes in 2 pages.
    //PRJ-708.N.S.1.0 comment the field NS_Amt. Recognized because it is Not flowfield.
    //PRJ-849 Line Amt change for Actual, Budget price
    //PE-141.AS.1.0 14AUG2023 Done change in layout to Add comp logo, user id, timedate, page
    //PE-134.DK.1.0 26July2023| Add ToolTip
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJobs Gross Profit.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Jobs Gross Profit';
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "NS_Date Filter", Status;
            column(TIME; TIME)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            //PRJCTPR-52.PS.1.0 14March2023  Strat
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_Address_2; CompanyInformation."Address 2")
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_State; CompanyInformation.County)
            {
            }
            column(CompanyInformation_StateZipCode; CompanyInformation."Post Code")
            {
            }

            //PRJCTPR-52.PS.1.0 14March2023  End
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
            column(Sub_LevelsText_; "Sub-LevelsText")
            {
            }
            column(ValuesFromText; ValuesFromText)
            {
            }
            column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
            {
            }
            column(Variance__; "Variance%")
            {
                DecimalPlaces = 1 : 1;
            }
            column(Variance; Variance)
            {
            }
            column(ActualCost; ActualCost)
            {
            }
            column(ActualPrice; ActualPrice)
            {
            }
            column(Job_Description; Description)
            {
            }
            column(Job__No__; "No.")
            {
            }
            column(Job__Description_2_; "Description 2")
            {
            }
            column(ActualCost_Control26; ActualCost)
            {
            }
            column(ActualPrice_Control30; ActualPrice)
            {
            }
            column(Variance_Control34; Variance)
            {
            }
            column(Variance___Control12; "Variance%")
            {
                DecimalPlaces = 1 : 1;
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job_Gross_ProfitCaption; Job_Gross_ProfitCaptionLbl)
            {
            }
            column(Percent_ProfitCaption; Percent_ProfitCaptionLbl)
            {
            }
            column(Actual_ProfitCaption; Actual_ProfitCaptionLbl)
            {
            }
            column(Actual_CostCaption; Actual_CostCaptionLbl)
            {
            }
            column(Actual_PriceCaption; Actual_PriceCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Job__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Total_JobsCaption; Total_JobsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin


                if UseValuesFromWIP then begin
                    SETRANGE("NS_Entry Type Filter", "NS_Entry Type Filter"::Earn);
                    //CALCFIELDS("NS_Amt. Recognized");//PRJ-708.N.S.1.0 Comment
                    ActualPrice := "NS_Amt. Recognized";

                    SETRANGE("NS_Entry Type Filter", "NS_Entry Type Filter"::Release);
                    //CALCFIELDS("NS_Amt. Recognized");//PRJ-708.N.S.1.0 Comment
                    ActualCost := -"NS_Amt. Recognized";

                    if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                        ActualPrice := ActualPrice + SLsWIPSalesGL(Job);
                        ActualCost := ActualCost + SLsWIPCostsGL(Job);
                    end;
                end else begin
                    CALCFIELDS("NS_Invoiced Price (LCY)", "NS_Usage (Cost) (LCY)");
                    ActualPrice := "NS_Invoiced Price (LCY)";
                    ActualCost := "NS_Usage (Cost) (LCY)";

                    if "IncludeSub-Levels" and not "ShowSub-Levels" then begin
                        ActualPrice := ActualPrice + SLsInvoicedPrice(Job);
                        ActualCost := ActualCost + "SLsUsage(Cost)"(Job);
                    end
                end;

                Variance := ActualPrice - ActualCost;
                if ActualPrice <> 0 then
                    "Variance%" := (Variance / ActualPrice) * 100
                else
                    "Variance%" := 0;
            end;

            trigger OnPreDataItem();
            var
                JobNofilter: Code[250];  // PRJCTPR-52.PS.1.0 24Feb2023
            begin
                if "IncludeSub-Levels" then begin
                    JobHold := Job;
                    JobHold.COPYFILTERS(Job);
                    "MarkSub-Levels"(Job, "IncludeSub-Levels");
                    COPYFILTERS(JobHold);
                    // CurrReport.CREATETOTALS(ActualPrice, ActualCost); //PRJCTPR-101.NC.1.0 25Apr2023 Block
                    if not "ShowSub-Levels" then
                        SETRANGE("NS_Sub-Level to Job No.", '');
                end;

                // PRJCTPR-52.PS.1.0 24Feb2023  Strat
                if "ShowSub-Levels" then begin
                    JobHold := Job;
                    JobHold.COPYFILTERS(Job);
                    JobNofilter := '@*' + Job.GetFilter("No.") + '*';
                    SetFilter("No.", '%1', JobNofilter);
                    // CurrReport.CREATETOTALS(ActualPrice, ActualCost); //PRJCTPR-101.NC.1.0 25Apr2023 Block
                end;
                // PRJCTPR-52.PS.1.0 24Feb2023  End
            end;
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
                }
                field("Include Sub-Levels"; "IncludeSub-Levels")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enabling this will include the Sub Level Jobs with the master Job.';  //PE-134.DK.1.0 26July2023
                }
                field("Show Sub Levels"; "ShowSub-Levels")
                {
                    ApplicationArea = All;
                }
                field("Use Values From WIP"; UseValuesFromWIP)
                {
                    Caption = 'Use Values from WIP';
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
        CompanyInformation.GET;
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

        JobFilter := Job.GETFILTERS;

        if not "ShowSub-Levels" then
            if "IncludeSub-Levels" then
                "Sub-LevelsText" := Text001
            else
                "Sub-LevelsText" := Text002
        else
            "Sub-LevelsText" := Text002;

        if UseValuesFromWIP then
            ValuesFromText := Text003
        else
            ValuesFromText := Text004;
    end;




    var
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
        JobHold: Record Job;
        JobFilter: Text[250];
        ActualPrice: Decimal;
        ActualCost: Decimal;
        Variance: Decimal;
        "Variance%": Decimal;
        TotaltoPrintCost: Decimal;
        TotaltoPrintPrice: Decimal;
        "Sub-LevelsText": Text[50];
        ValuesFromText: Text[50];
        UseValuesFromWIP: Boolean;
        "IncludeSub-Levels": Boolean;
        "ShowSub-Levels": Boolean;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Gross_ProfitCaptionLbl: Label 'Job Gross Profit';
        Percent_ProfitCaptionLbl: Label 'Percent Profit';
        Actual_ProfitCaptionLbl: Label 'Actual Profit';
        Actual_CostCaptionLbl: Label 'Actual Cost';
        Actual_PriceCaptionLbl: Label 'Actual Price';
        DescriptionCaptionLbl: Label 'Description';
        Total_JobsCaptionLbl: Label 'Total Jobs';
        Text001: Label 'Sub-Levels are included in jobs';
        //  Text002: Label 'Sub-Levels are not included in jobs';// PRJCTPR-52.PS.1.0 28Feb2023 Commented by Under PRJCTPR-52 
        Text002: Label ''; //PRJCTPR-52.PS.1.0 28Feb2023
        Text003: Label 'Values are from WIP';
        Text004: Label 'Values are from usage and invoices';
}

