report 14021421 "NS_Daily Field Report"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-84.SK.1.0 Added report to search
    //PRJ-195.MS.1.0 SignatureLabel change var length from 30 to 50
    //   - modify the layout of report    
    //PRJ-223.MS.1.0 added two new field and modify the layout of report
    //JD-10:AS:27APRIL2020 : Created New Report by Saving Report "14021288".
    //JD-10:AS:27APRIL2020 : Here "JobCostCategory" is used as "JobNo." & in layout has very important group on it.
    //JD-42.NS.1.0 add condition of DFR no creation
    //JD-44.NS.1.0 12Aug2020 Add filter not required line type budget
    //JD-54.AM.1.0 Added new conditions on Predataitem and new column added.added new grouping in layout. 
    //PRJ-1474.NK.1.0 26July2022 |Added Filter
    //PRJ-1723.NK.1.0 14Dec2022 | Added Code
    //PE-81.DK.1.0 04May2023 | Change in Layout 
    //PE-141.AS.1.0 14AUG2023 Done changes in Layout to Add UserID, workdate time, page
    //PE-215.DK.2.0 08Jan2024 | Add UserID column and also change both Layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSDaily Field Report.rdl';
    WordLayout = './Layouts/NSDaily Field Report.docx'; //PE-114.DK.1.0 24june-2023
    Caption = 'Daily Field Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;


    dataset
    {
        dataitem(Job; Job)
        {
            //RequestFilterFields = "No."; //PRJ-1474.NK.1.0 28July2022 Block
            column(WorkOrderNo; Job."No.")
            {
            }
            //PRJCTPR-105 Dk.1.0 28April2023 Start
            //PE-215.DK.2.0 08Jan2024 Start
            column(NS_CurrentDate; format(Today))
            {
            }

            column(WorkOrderDate; startdate) //PE-114.DK.1.0 24june-2023
            {
            }
            column(WorkOrderDate1; FORMAT(startdate)) //PE-114.DK.1.0 24june-2023
            {
            }
            //PE-215.DK.2.0 08Jan2024 End
            //PE-215.Dk.3.0 11Jan2023 Start
            column(NS_ManagerName; NS_ManagerName)
            {

            }
            //PE-215.Dk.3.0 11Jan2023 End
            //PRJCTPR-105 Dk.1.0 28April2023 End
            column(WorkOrderManager; Job.NS_Manager)
            {
            }
            column(WorkOrderCustAddress; BilltoAddress)
            {
            }
            column(WorkOrderCustAddress2; BilltoAddress2)
            {
            }
            column(WorkOrderCustName; "Bill-to Name")
            {
            }
            column(WorkOrderCustPhone; BilltoPhone)
            {
            }
            column(WorkOrderDescription; Job.Description)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompAddress)
            {
            }
            column(CompanyPhone; CompPhone)
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            //PE-141.AS.1.0 14AUG2023 start
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(CompanyInformationAdd; CompanyInformation.Address) { }
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }//PE-141.AS.1.0 24AUG2023
            //PE-141.AS.1.0 14AUG2023 end
            column(FooterSignatureLabel; SignatureLabel)
            {
            }
            column(FooterDateLabel; DateLabel)
            {
            }
            column(FooterCustSignatureLabel; CustSignatureLabel)
            {
            }
            //PE-215.DK.2.0 08Jan2023 Start
            column(NS_UserIDText; NS_UserIDText)
            {
            }
            //PE-215.DK.2.0 08Jan2023 End

            dataitem("Job Planning Line"; "Job Planning Line")
            {
                //PRJCTPR-105 Dk.1.0 28April2023 Start
                //  DataItemTableView = sorting("Line No.") order(ascending);
                DataItemTableView = sorting("Planning Date") order(ascending);
                //PRJCTPR-105 Dk.1.0 28April2023 End
                DataItemLinkReference = job;
                DataItemLink = "Job No." = field("No.");
                RequestFilterFields = "NS_DFR No.";

                column(JobCostCategory; "Job No.")//JD-10:AS:27APRIL2020
                {
                }

                column(JobCostCatDesc; Description)
                {
                }
                column(Detail_CostCategory; "Job Planning Line"."Job No.")//JD-10:AS:27APRIL2020
                {
                }
                //PE-215.DK.1.0 27DEC2023 Start
                //  column(Detail_WorkOrderDate; FORMAT("Job Planning Line"."Planning Date")) //PE-114.DK.1.0 24june-2023
                // {
                // }
                column(Detail_WorkOrderDate; "Job Planning Line"."Planning Date")
                {
                }
                column(Detail_WorkOrderDatenew; FORMAT("Job Planning Line"."Planning Date"))
                {
                }
                //PE-215.DK.1.0 27DEC2023 End
                column(Detail_Type; "Job Planning Line".Type)
                {
                }
                column(Detail_No; "Job Planning Line"."No.")
                {
                }
                column(Detail_Description; "Job Planning Line".Description)
                {
                }
                column(Detail_Quantity; "Job Planning Line".Quantity)
                {
                }
                //PRJCTPR-105 Dk.1.0 28April2023 Start
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                //PRJCTPR-105 Dk.1.0 28April2023 End
                column(Detail_Rate; "Job Planning Line"."Unit Price")
                {
                }
                column(Detail_Total; "Job Planning Line"."Line Amount")
                {
                }

                column(Skill_Code; "Job Planning Line"."NS_Skill Class")
                {
                }
                column(Work_TYpe_Code; "Job Planning Line"."Work Type Code")
                {
                }
                column(DFRnoVar; "Job Planning Line"."NS_DFR No.")
                {
                }
                //JD-54.AM.1.0 start
                column(DFRNo; "Job Planning Line"."NS_DFR No.")
                {

                }
                column(IsDFRcreate; IsDFRcreate)
                {

                }
                //PE-114.DK.1.0 24june2023 Start
                column(NSTotalQTY; NSTotalQTY) { }
                column(NSDetailTotal; NSDetailTotal) { }
                //PE-114.DK.1.0 24june2023 End
                //JD-54.AM.1.0 end
                trigger OnPreDataItem();
                var
                    NoSeriesMgt: Codeunit 396;
                begin
                    if (startdate <> 0D) and (enddate <> 0D) then //JD-54.AM.1.0 
                        "Job Planning Line".SetRange("Planning Date", startdate, enddate);
                    // "Job Planning Line".SetFilter("Line Type", '%1', "Job Planning Line"."Line Type"::Billable); //JD-44.NS.1.0 12Aug2020 code comment
                    "Job Planning Line".SetFilter("Line Type", '<>%1', "Job Planning Line"."Line Type"::Budget); //JD-44.NS.1.0 12Aug2020                                                                                           //PRJ-1474.NK.1.0 26July2022 Start
                    //PRJ-1474.NK.1.0 26July2022 Start
                    if DFRCode <> '' then begin
                        "Job Planning Line".SETFILTER("NS_DFR No.", DFRCode);
                        //PE-114.DK.1.0 24june2023 Start
                        if "Job Planning Line".FindSet() then
                            repeat
                                NSTotalQTY += "Job Planning Line".Quantity;
                                NSDetailTotal += "Job Planning Line"."Line Amount";
                            until "Job Planning Line".Next() = 0;
                        //PE-114.DK.1.0 24june2023 End
                    end;

                    //PRJ-1474.NK.1.0 26July2022 End
                    //if (IsDFRcreate) then //JD-42.NS.1.0 code comment
                    // if (IsDFRcreate) AND (startdate <> 0D) then //JD-42.NS.1.0 //PRJ-1723.NK.1.0 14Dec2022 Block
                    //     NoSeriesMgt.InitSeries(Job."NS_DFR Nos.", Job."NS_DFR Nos.", 0D, DFRnoVar, Job."NS_DFR Nos."); //PRJ-1723.NK.1.0 14Dec2022 Block
                end;

                trigger OnAfterGetRecord()
                begin
                    //PRJ-1723.NK.1.0 14Dec2022 Block Start 
                    // if IsDFRcreate then begin
                    //     "Job Planning Line"."NS_DFR Created" := true;
                    //     "NS_DFR No." := DFRnoVar;
                    //     Modify();
                    // end;
                    //PRJ-1723.NK.1.0 14Dec2022 Block End
                    if "NS_DFR No." = '' then
                        CurrReport.Skip();
                end;

            }

            trigger OnAfterGetRecord();
            var
                Cust: Record Customer;
                EntryNo: Integer;
                PlanLineLocal: Record "Job Planning Line";

            begin
                if IsDFRcreate then begin
                    TestField("NS_DFR Nos.");
                    PlanLineLocal.Reset();
                    PlanLineLocal.SetRange("Job No.", "No.");
                    PlanLineLocal.SetRange("Planning Date", startdate, enddate);
                    PlanLineLocal.SetFilter("NS_DFR No.", '<>%1', '');
                    if PlanLineLocal.FindFirst() then
                        Error('DFR no. is already created for this period')
                    else
                        repeat
                            NSTotalQTY += PlanLineLocal.Quantity;
                            NSDetailTotal += PlanLineLocal."Line Amount";
                        until PlanLineLocal.Next() = 0;
                end;
                //PRJ-1723.NK.1.0 14Dec2022 Start
                if (IsDFRcreate) AND (startdate <> 0D) then //JD-42.NS.1.0
                    NoSeriesMgt.InitSeries(Job."NS_DFR Nos.", Job."NS_DFR Nos.", 0D, DFRnoVar, Job."NS_DFR Nos.");
                if IsDFRcreate then begin
                    JobPlanLine.Reset();
                    JobPlanLine.SetRange("Job No.", Job."No.");
                    if DFRCode <> '' then
                        JobPlanLine.SETFILTER("NS_DFR No.", DFRCode);
                    if (startdate <> 0D) and (enddate <> 0D) then
                        JobPlanLine.SetRange("Planning Date", startdate, enddate);
                    JobPlanLine.SetFilter("Line Type", '<>%1', JobPlanLine."Line Type"::Budget); //JD-44.NS.1.0 12Aug2020                                             
                    if JobPlanLine.FindFirst() then
                        repeat
                            JobPlanLine."NS_DFR Created" := true;
                            JobPlanLine."NS_DFR No." := DFRnoVar;
                            JobPlanLine.Modify();
                        until JobPlanLine.Next() = 0;
                end;
                //PRJ-1723.NK.1.0 14Dec2022 End
                if Job."Bill-to Customer No." <> '' then
                    Cust.GET(Job."Bill-to Customer No.");

                //PE-141.AS.1.0 14AUG2023 start
                CompanyInformation.GET;
                CompanyInformation.CalcFields(Picture);
                //PE-141.AS.1.0 14AUG2023 end

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

                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                BilltoAddress := Job."Bill-to Address" + ', ' + Job."Bill-to Address 2";
                BilltoAddress2 := Job."Bill-to City" + ' ' + Job."Bill-to County" + ' ' + Job."Bill-to Post Code";
                BilltoPhone := Cust."Phone No."; //PE-114.DK.1.0 24june-2023 //PE-215.DK.2.0 3Jan2024
                CompAddress := CompanyInfo.Address;
                if CompanyInfo."Address 2" <> '' then
                    CompAddress := CompAddress + ', ' + CompanyInfo."Address 2";
                CompAddress := CompAddress + ' ' + CompanyInfo.City + ' ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
                CompPhone := 'Phone: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.";
                SignatureLabel := STRSUBSTNO(Text001, CompanyInfo.Name);
                ////PE-215.Dk.3.0 11Jan2023 Start
                Clear(NS_ManagerName);
                if job.NS_Manager <> '' then begin
                    if NS_Recource.Get(Job.NS_Manager) then
                        NS_ManagerName := NS_Recource.Name;
                end;
                ////PE-215.Dk.3.0 11Jan2023 End
            end;

            trigger OnPreDataItem();
            begin
                //PRJ-1474.NK.1.0 28July2022 Start
                // if JobNoFilter <> '' then
                //     Job.SETFILTER("No.", JobNoFilter);
                if JobNo <> '' then
                    Job.SETFILTER("No.", JobNo);
                //PRJ-1474.NK.1.0 26July2022 End
                DFRnoVar := '';

            end;

        }
    }
    requestpage
    {

        // SaveValues = true;//PRJ-425.AM.1.0
        layout
        {
            area(Content)
            {

                group(DateFilters)
                {
                    field(startdate; startdate)
                    {
                        ApplicationArea = jobs;
                        Caption = 'Planning Start Date';
                    }
                    field(enddate; enddate)
                    {
                        ApplicationArea = jobs;
                        Caption = 'Planning End Date';
                    }

                    field(IsDFRcreate; IsDFRcreate)
                    {
                        Caption = 'DFR No. Create';
                        ApplicationArea = jobs;

                    }
                    //PRJ-1474.NK.1.0 26July2022 Start
                    field(JobNo; jobno)
                    {
                        Caption = 'Job No.';
                        TableRelation = Job;
                        ApplicationArea = all;
                        trigger OnValidate()
                        begin
                            DFRCode := '';
                        end;

                    }
                    field(DFRCode; DFRCode)
                    {
                        Caption = 'DFR Code';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            NumbFilter: Record NSNumberFilter;
                            NumbFilter2: Record NSNumberFilter;
                            JobPlanLine: Record "Job Planning Line";
                            DFRCode2: Code[20];
                        begin


                            if JobNo = '' then
                                Error('Please select Job No.');

                            NumbFilter.Reset();
                            NumbFilter.SetRange(Type, NumbFilter.Type::NS_DFR);
                            NumbFilter.SetFilter("Document No.", '%1', JobNo);
                            if NumbFilter.FindFirst() then
                                NumbFilter.DeleteAll();
                            JobPlanLine.Reset();
                            JobPlanLine.SetCurrentKey("Job No.", "NS_DFR No.");
                            JobPlanLine.SetFilter("Job No.", '%1', JobNo);
                            if JobPlanLine.FindFirst() then
                                repeat
                                    if DFRCode2 <> JobPlanLine."NS_DFR No." then begin
                                        NumbFilter2.Init();
                                        NumbFilter2.Type := NumbFilter2.Type::NS_DFR;
                                        NumbFilter2."Document No." := JobNo;
                                        NumbFilter2."No." := JobPlanLine."NS_DFR No.";
                                        DFRCode2 := JobPlanLine."NS_DFR No.";
                                        NumbFilter2.Insert();
                                    end;
                                until JobPlanLine.Next() = 0;
                            Commit();
                            NumbFilter.Reset();
                            NumbFilter.SetRange(Type, NumbFilter.Type::NS_DFR);
                            NumbFilter.SetFilter("Document No.", JobNo);
                            if PAGE.RUNMODAL(PAGE::"NSNumberFilter List", NumbFilter) = ACTION::LookupOK then
                                DFRCode := NumbFilter."No.";
                        end;
                    }
                    //PRJ-1474.NK.1.0 26July2022 End

                }


            }

        }

        actions
        {

        }

        //PE-215.DK.2.0 08Jan2023 Start
        trigger OnInit()
        begin
            NS_UserIDText := UserId;
        end;
        //PE-215.DK.2.0 08Jan2023 End

        trigger OnOpenPage()
        begin
            //  IsDFRcreate := false; //PRJ-425.AM.1.0
            JobNo := JobNoFilter; //PRJ-1474.NK.1.0 27July2022
        end;
    }

    labels
    {
    }

    var
        BilltoAddress: Text[120];
        BilltoAddress2: Text[120];
        BilltoPhone: Text[60];
        ActivityCodes: Text[1000];
        JobDescription: Text[1000];
        CompAddress: Text[120];
        CompAddress2: Text[120];
        CompPhone: Text[60];
        NS_ManagerName: Text; //PE-215.Dk.3.0 11Jan2023
        NS_Recource: Record Resource; //PE-215.Dk.3.0 11Jan2023
        CompanyInfo: Record "Company Information";
        CompanyInformation: Record "Company Information";//PE-141.AS.1.0 14AUG2023
                                                         //PE-141.AS.1.0 start 24Aug2023 
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        //PE-141.AS.1.0 24Aug2023 
        Text001: Label '%1 Signature';
        DateLabel: Label 'Date';
        CustSignatureLabel: Label 'Customer Signature';
        CostCategoryCode: Code[20];
        CompName: Text[120];
        TempLedgEntryCount: Integer;
        RowCount: Integer;
        SignatureLabel: Text[50]; //PRJ-195.MS.1.0 Modified
        JobNoFilter: Text[60];
        startdate: Date;
        enddate: Date;
        IsDFRcreate: Boolean;
        DFRnoVar: Code[20];
        DFRNo: Code[20];//JD-54.AM.1.0
        DFRCode: Code[20]; //PRJ-1474.NK.1.0 26July2022
        JobNo: Code[20]; //PRJ-1474.NK.1.0 27July2022

        //PE-114.DK.1.0 24june-2023 Start
        NSTotalQTY: Integer;
        NSDetailTotal: Decimal;
        //PE-114.DK.1.0 24june-2023 End
        NoSeriesMgt: Codeunit NoSeriesManagement; //PRJ-1723.NK.1.0 14Dec2022
        JobPlanLine: Record "Job Planning Line";  //PRJ-1723.NK.1.0 14Dec2022
        NS_UserIDText: Text; //PE-215.DK.2.0 08Jan2023

    procedure NS_SetFilter(PassJobNoFilter: Text[60]);
    begin
        JobNoFilter := PassJobNoFilter;
    end;

}

