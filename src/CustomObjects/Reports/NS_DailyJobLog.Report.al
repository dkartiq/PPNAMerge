/// <summary>
/// Report NS_Daily Job Log Report (ID 14021453).
/// </summary>
/// Create New Report for Daily Job Log and New Layout
/// PE-168.DK.1.0 01NOV2023 Start
/// //PE-168.HS.1.0 3 Nov 2023 | Add Code
//PE-168.HS.1.0 9Nov2023 |Add Filter in Subcontract visitor table 
//PE-168.HS.1.0 7Dec2023 | Add Code and cosmetic changes in RDL 
//PE-253.PS.1.0 05March2024 |Add Code and cosmetic changes in RDL




report 14021453 "NS_Daily Job Log Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Job Daily Log Report'; //PE-168.HS.1.0 22Nov2023
    RDLCLayout = './Layouts/NS_DailyJobLogReport.rdl';
    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending);
            MaxIteration = 1;
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            // column(CompanyInformationAdd; CompanyInformation.Address) { } //PE-168.HS.1.0 14Nov2023 Commented
            column(CompanyInformationAdd; NS_CompanyInformationAdd) { } //PE-168.HS.1.0 14Nov2023
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }
            column(NS_UserIDText; NS_UserIDText) { }
            column(NSWorkDate; format(Workdate())) { }
            column(NS_CompanyName; NS_CompanyName) { } //PE-168.HS.1.0 22Nov2023
            column(NS_UserName; NS_UserName) { } //PE-168.HS.1.0 22Nov2023

            dataitem("NS_Daily Job Log"; "NS_Daily Job Log")
            {
                DataItemTableView = sorting("NS_No.");
                RequestFilterFields = "NS_No.";
                column(NS_No_; "NS_No.") { }
                column(NS_Signiture; "NS_Daily Job Log"."NS_Signature") { }  //PE-217.DK.1.0 27Dec2023 
                column(NS_Job_No_; "NS_Job No.") { }
                column(NS_Job_Address_1; NS_JobAddress1) { }
                column(NS_Job_Address_2; NS_JobAddress2) { }
                column(NS_Job_County; NS_JobCounty) { }
                column(NS_Job_Tasks; "NS_Job Tasks") { }
                column(NS_Manager; NS_Manager) { }
                column(NS_City; NS_JobCity) { }
                column(NS_Completion_Date; Format("NS_Completion Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(NS_Contract_Date; Format("NS_Contract Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(NS_CRM_No_; "NS_CRM No.") { }
                column(NS_Description; NS_Description) { }
                column(NS_Actual_Work_Completion__; "NS_Actual Work Completion %") { }
                column(Dusty; Dusty) { }
                column(Clear; Clear) { }
                column(E_Mail; "E-Mail") { }
                column(Multiple_Selectiions; "Multiple Selectiions") { }
                column(NS_Job_Zip_Code; NS_ZipCode) { }
                column(NS_Project_Manager_Name; "NS_Project Manager Name") { }
                column(NS_Risk_or_Delay; "NS_Risk or Delay") { }
                column(NS_Project_Manager_No_; "NS_Project Manager No.") { }
                column(Site_Condition_Other; "Site Condition Other") { }
                column(NS_PO___SC; "NS_PO / SC") { }
                column(Weather_Temperature_Other; "Weather/Temperature Other") { }
                column(Rainy; Rainy) { }
                column(Windy; Windy) { }
                column(Temperature; Temperature) { }
                column(Measuring_Scale; "Measuring Scale") { }
                column(Muddy; Muddy) { }
                column(Others; Others) { }
                column(NS_Worker_Count; "NS_Worker Count") { }
                column(NS_Estimated_Completion_Date; Format("NS_Estimated Completion Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(NS_Log_Date; Format("NS_Log Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
                column(NS_JobDescription; NS_JobDescription) { } //PE-168.HS.1.0 3 Nov 2023               
                column(NS_Country_NS_DailyJobLog; NS_JobCountry) { } //PE-168.HS.1.0  14Nov 2023   

                dataitem("NS_RiskDelayDaily Job Log Sub."; "NS_Daily Job Log Sub.")
                {
                    DataItemLink = "Documnet No." = field("NS_No.");
                    DataItemLinkReference = "NS_Daily Job Log";
                    DataItemTableView = sorting("Document Type", "Documnet No.", "Documnet Job No.", "Line No.") where("Document Type" = filter(Risks));
                    column(NS_RiskDocument_Type; "Document Type") { }
                    column(NS_RiskDocumnet_No_; "Documnet No.") { }
                    column(NS_RiskDocumnet_Job_No_; "Documnet Job No.") { }
                    column(NS_RiskEntry_Date; Format("Entry Date")) { }
                    column(NS_RiskRemark; Remark) { }
                    column(NS_RiskRemark_; "Remark 2") { }
                    column(NS_RiskRisk__Delay; "Risk/ Delay") { }
                }
                dataitem("NS_AccidentsDaily Job Log Sub."; "NS_Daily Job Log Sub.")
                {
                    DataItemLink = "Documnet No." = field("NS_No.");
                    DataItemLinkReference = "NS_Daily Job Log";
                    DataItemTableView = sorting("Document Type", "Documnet No.", "Documnet Job No.", "Line No.") where("Document Type" = filter(Accidents));
                    column(NS_AcciDocumnet_Job_No_1; "Documnet Job No.") { }
                    column(NS_AcciEntry_Date1; Format("Entry Date")) { }
                    column(NS_AcciRemark; Remark) { }
                    column(NS_AcciRemark_2; "Remark 2") { }
                    column(NS_AcciAccidents___Safety_Issues1; "Accidents / Safety Issues") { }
                    column(DocumentType_NS_AccidentsDailyJobLogSub; "Document Type") { }
                }
                dataitem("NS_PerformanceDaily Job Log Sub."; "NS_Daily Job Log Sub.")
                {
                    DataItemLink = "Documnet No." = field("NS_No.");
                    DataItemLinkReference = "NS_Daily Job Log";
                    DataItemTableView = sorting("Document Type", "Documnet No.", "Documnet Job No.", "Line No.") where("Document Type" = filter("Job Task"));
                    column(NS_PerforDocumnet_Job_No_2; "Documnet Job No.") { }
                    column(DocumentType_NS_PerformanceDailyJobLogSub; "Document Type") { }
                    column(NS_PerforEntry_Date2; Format("Entry Date")) { }
                    column(NS_PerforJobTask; "NS_Job Tasks") { }
                    column(NS_PerforRemark; Remark) { }
                    column(NS_PerforRemark_2; "Remark 2") { }
                    column(NS_PerforTask_Description2; "Task Description") { }

                    //PE-253.PS.1.0 08March2024 Start
                    column(NS_WorkUnitBudgeted; NS_WorkUnitBudgeted) { }
                    column(NS_UM; NS_UM) { }
                    column(NS_WorkUnitPrevious; NS_WorkUnitPrevious) { }
                    column(NS_WorkUnitToday; NS_WorkUnitToday) { }
                    //PE-253.PS.1.0 08March2024 End 
                }
                dataitem("NS_VendorDaily Job Log Sub."; "NS_Daily Job Log Sub.")
                {
                    DataItemLink = "Documnet No." = field("NS_No.");
                    DataItemLinkReference = "NS_Daily Job Log";
                    DataItemTableView = sorting("Document Type", "Documnet No.", "Documnet Job No.", "Line No.") where("Document Type" = filter(Order));
                    column(VEDocumnet_Job_No_; "Documnet Job No.") { }
                    column(DocumentType_NS_VendorDailyJobLogSub; "Document Type")
                    {
                    }
                    column(VEEntry_Date; Format("Entry Date")) { }
                    column(VEPO_Sub_Con__No_; "PO/Sub Con. No.") { }
                    column(VERemark; Remark) { }
                    column(VERemark_2; "Remark 2") { }
                    column(VEVendor_No_2; "Vendor No.") { }
                    column(VEVendor_Name2; "Vendor Name") { }
                    column(VEOrder_Type2; "Order Type") { }
                }
                dataitem("NS_VisitorsDaily Job Log Sub."; "NS_Daily Job Log Sub.")
                {
                    DataItemLink = "Documnet No." = field("NS_No.");
                    DataItemLinkReference = "NS_Daily Job Log";
                    DataItemTableView = sorting("Document Type", "Documnet No.", "Documnet Job No.", "Line No.") where("Document Type" = filter(Visitors));
                    column(NS_VisDocumnet_Job_No_; "Documnet Job No.") { }
                    column(DocumentType_NS_VisitorsDailyJobLogSub; "Document Type")
                    {
                    }
                    column(NS_VisEntry_Date; Format("Entry Date")) { }
                    column(NS_VisRemark; Remark) { }
                    column(NS_VisRemark_2; "Remark 2") { }
                    column(NS_VisContacts_No_2; "Contacts No.") { }
                    column(NS_VisContacts_Name2; "Contacts Name") { }
                    column(NS_VisitTime1; Format(NS_VisitTime)) { }
                }

                //PE-168.HS.1.0 3 Nov 2023 Start
                trigger OnAfterGetRecord()
                var
                    NSJob: record Job;
                    NS_User: Record User;
                begin
                    "NS_Daily Job Log".CalcFields("NS_Signature"); //PE-217.DK.1.0 27Dec2023 
                    NSJob.SetRange("No.", "NS_Daily Job Log"."NS_Job No.");
                    if NSJob.FindFirst() then
                        NS_JobDescription := NSJob.Description;

                    if "NS_Daily Job Log"."NS_Job Address 1" = '' then
                        NS_JobAddress1 := ''
                    else
                        NS_JobAddress1 := "NS_Daily Job Log"."NS_Job Address 1" + ',';

                    if "NS_Daily Job Log"."NS_Job Address 2" = '' then
                        NS_JobAddress2 := ''
                    else
                        // NS_JobAddress2 := "NS_Daily Job Log"."NS_Job Address 2" + ','; //PE-168.HS.1.0 17Nov2023 Commented
                        NS_JobAddress2 := "NS_Daily Job Log"."NS_Job Address 2";  //PE-168.HS.1.0 17Nov2023


                    if "NS_Daily Job Log".NS_City = '' then
                        NS_JobCity := ''
                    else
                        NS_JobCity := "NS_Daily Job Log".NS_City + ',';

                    if "NS_Daily Job Log"."NS_Job County" = '' then
                        NS_JobCounty := ''
                    else
                        // NS_JobCounty := "NS_Daily Job Log"."NS_Job County" + ',';  //PE-168.HS.1.0 17Nov2023 Commented
                        NS_JobCounty := "NS_Daily Job Log"."NS_Job County"; //PE-168.HS.1.0 17Nov2023

                    if "NS_Daily Job Log".NS_Country = '' then
                        NS_JobCountry := ''
                    else
                        NS_JobCountry := "NS_Daily Job Log".NS_Country + ',';

                    if "NS_Daily Job Log"."NS_Job Zip Code" = '' then
                        "NS_Job Zip Code" := ''
                    else
                        NS_ZipCode := "NS_Daily Job Log"."NS_Job Zip Code";

                    NS_User.SetRange("User Name", "NS_Daily Job Log"."Created By");
                    if NS_User.FindFirst() then
                        NS_UserName := NS_User."Full Name";
                end;
                //PE-168.HS.1.0 3 Nov 2023 End

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnInitReport()
    begin
        NS_UserIDText := UserId;
        if CompanyInformation.GET then;
        NS_CompanyName := CompanyInformation.Name;
        CompanyInformation.CalcFields(Picture);
        if CompanyInformation.Address = '' then
            NS_CompanyInformationAdd := ''
        else
            NS_CompanyInformationAdd := CompanyInformation.Address + ',';   //PE-168.HS.1.0 14Nov2023
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

    end;

    var
        myInt: Record "NS_Daily Job Log Sub.";
        CompanyInformation: Record "Company Information";
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        NS_UserIDText: Text;
        //PE-168.HS.1.0 14Nov2023 Start
        NS_JobDescription: Text[100];
        NS_DailyJobLog: Record "NS_Daily Job Log";
        NS_JobAddress1: Text[100];
        NS_JobAddress2: Text[50];
        NS_JobCity: Text[50];
        NS_JobCounty: Text[30];
        NS_JobCountry: Text[30];
        NS_ZipCode: Text[30];
        NS_UserName: text[80];
        NS_CompanyName: text[100];
    //PE-168.HS.1.0 14Nov2023 End

    //PE-168.DK.1.0 01NOV2023 End
}