report 14021485 "NS_Unit Cost Prod report"
{
    //PRJ-1264.AS.1.0 22APRIL2022 Created New Report
    //PRJ-1456.JS.1.0 | Change Conditions
    //PRJ-1545.NK.1.0 26July2022 New Filter customization for Job Task No.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSUnitCostprod.rdl';
    Caption = 'Unit Cost Production Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Bill-to Customer No.", "NS_Date Filter", Status;

            column(ToTWorkUnitJT; ToTWorkUnitJT)
            { }
            column(TotWEQty; TotWEQty)
            { }
            column(ToTMonthlyQty; ToTMonthlyQty)
            { }
            column(TotJBqty1; TotJBqty1)
            { }
            column(TotJBqty2; TotJBqty2)
            { }
            column(CompAddress; CompAddress)
            { }
            column(ProjNoCap; ProjNoCap)
            { }
            column(ProJNameCap; ProJNameCap)
            { }
            column(ProjMangr; ProjMangr)
            { }
            column(DirectrVPCap; DirectrVPCap)
            { }
            column(CostAccTntCap; CostAccTntCap)
            { }
            column(WeekEndCap; WeekEndCap)
            { }
            column(MonthEndCap; MonthEndCap)
            { }
            column(MONTHLYCOSTCAP; MONTHLYCOSTCAP)
            { }
            column(COSTTODATE; COSTTODATE)
            { }
            column(COSTTOCOMPL; COSTTOCOMPL)
            { }
            column(COSTCODECAP; COSTCODECAP)
            { }
            column(DESCCAP; DESCCAP)
            { }
            column(COSTTYPECAP; COSTTYPECAP)
            { }
            column(UNITMESURECAP; UNITMESURECAP)
            { }
            column(QTYCAP; QTYCAP)
            { }
            column(ESTIMATEDCAP; ESTIMATEDCAP)
            { }
            column(UNITCOSTCAP; UNITCOSTCAP)
            { }
            column(COSTCAP; COSTCAP)
            { }
            column(POSTEDCAP; POSTEDCAP)
            { }
            column(RECNTINVCAP; RECNTINVCAP)
            { }
            column(TOTALCOSTCAP; TOTALCOSTCAP)
            { }
            column(JOBTODATECAP; JOBTODATECAP)
            { }
            column(PERCCAP; PERCCAP)
            { }
            column(USEDCAP; USEDCAP)
            { }
            column(COMPLCAP; COMPLCAP)
            { }
            column(VARIANCECAP; VARIANCECAP)
            { }
            column(PROJCOSTCAP; PROJCOSTCAP)
            { }
            column(TOTALCAP; TOTALCAP)
            { }
            column(CompFinalAddrLine; CompFinalAddrLine)
            { }
            column(No_; "No.")
            { }
            column(Description; Description)
            { }
            column(Project_Manager; "Project Manager")
            { }
            column(CompanyInfoPicture; CompanyInformation.Picture)
            { }
            column(enddate; enddate)
            { }
            column(cmenddate; cmenddate)
            { }
            column(MonthName; MonthName)
            { }
            column(UNITCOSTREPCAP; UNITCOSTREPCAP)
            { }

            dataitem("Job Task"; "Job Task")
            {
                DataItemTableView = sorting("Job No.") ORDER(Ascending) WHERE("Job Task No." = filter(<> 'TOTALS' & <> 'TOTAL')
                );//PRJ-1456.AS.1.0
                DataItemLink = "Job No." = field("No.");

                column(Activity_Activity; Activity)
                {
                }
                column(Process_Code; process)
                {
                }
                column(Operation_Code; Operation)
                {
                }

                column(JobOperationDes; UPPERCASE(JobOperation.NS_Description))
                {
                }
                column(JobProcessDescription; UPPERCASE(JobProcess.NS_Description))
                {
                }
                // column(JobActivityDescription; UPPERCASE(JobActivity.NS_Description))//PRJ-1545.AS.1.0 Code blocked
                column(JobActivityDescription; "Job Task".Description)//PRJ-1545.AS.1.0 Code Added
                {
                }
                column(JobSectionDescription; JobSection.NS_Description)
                { }
                column(NS_Work_Units; "NS_Work Units")
                { }
                column(NS_Work_Unit_of_Measure; "NS_Work Unit of Measure")
                { }
                column(Schedule__Total_Cost_; "Schedule (Total Cost)")
                { }
                column(WorkUnitJT; WorkUnitJT)
                { }

                column(WorkUnitMeasureJT; WorkUnitMeasureJT)
                { }
                column(EstQty; EstQty)
                { }
                column(EstUnitCost; EstUnitCost)
                { }
                column(EstCost; EstCost)
                { }
                column(WEQty; WEQty)
                { }
                column(WEUniCost; WEUniCost)
                { }
                column(WEPosted; WEPosted)
                { }
                column(WERecNoInv; WERecNoInv)
                { }
                column(WETotlCost; WETotlCost)
                { }
                column(MonthlyQty; MonthlyQty)
                { }
                column(MonthlyUnitCost; MonthlyUnitCost)
                { }
                column(MonthlyPosted; MonthlyPosted)
                { }
                column(MonthlyRecNoInv; MonthlyRecNoInv)
                { }
                column(MonthlyTotlCost; MonthlyTotlCost)
                { }
                column(JobToDateQty; JobToDateQty)
                { }
                column(JobToDateUnitCost; JobToDateUnitCost)
                { }
                column(JobToDatePosted; JobToDatePosted)
                { }
                column(JobToDteRecNoInv; JobToDteRecNoInv)
                { }
                column(JobToDateTotlCost; JobToDateTotlCost)
                { }
                column(PerCUsedVal; PerCUsedVal)
                { }
                column(PerComplVal; PerComplVal)
                { }
                column(CostToCompltVal; CostToCompltVal)
                { }
                column(ProjCostVal; ProjCostVal)
                { }
                column(VarianceVal; VarianceVal)
                { }


                trigger OnAfterGetRecord()
                begin

                    Clear(WorkUnitJT);

                    Clear(WorkUnitMeasureJT);
                    Clear(EstQty);
                    Clear(EstUnitCost);
                    Clear(EstCost);
                    Clear(WEQty);
                    Clear(WEUniCost);
                    Clear(WEPosted);
                    Clear(WERecNoInv);
                    Clear(WETotlCost);
                    Clear(MonthlyQty);
                    Clear(MonthlyUnitCost);
                    Clear(MonthlyPosted);
                    Clear(MonthlyRecNoInv);
                    Clear(MonthlyTotlCost);
                    Clear(JobToDateQty);
                    Clear(JobToDateUnitCost);
                    Clear(JobToDatePosted);
                    Clear(JobToDteRecNoInv);
                    Clear(JobToDateTotlCost);
                    Clear(PerCUsedVal);
                    Clear(PerComplVal);
                    Clear(CostToCompltVal);
                    Clear(ProjCostVal);
                    Clear(VarianceVal);
                    Clear(TotalJB2DateQty);
                    Clear(FinalTotalJB2DateQty);

                    Job.NS_JobTaskNoToAPo("Job Task No.", Activity, Process, Operation, Section);
                    JobActivity.Reset;
                    JobProcess.Reset;
                    JobOperation.Reset;
                    IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN;
                    IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, Process) THEN;
                    IF JobOperation.get(JobOperation.NS_Type::Cost, Activity, Process, Operation) THEN;
                    IF JobSection.get(JobSection.NS_Type::Cost, Activity, Process, Operation, Section) THEN;

                    if Process <> '' then BEGIN
                        Process := Process;
                    end else begin
                        Process := '';

                    end;
                    if Operation <> '' then BEGIN
                        Operation := Operation;
                    end else BEGIN
                        Operation := '';
                    end;

                    if Section <> '' then BEGIN
                        Section := Section;
                    end else BEGIN
                        Section := '';
                    end;

                    Clear(CombinedJobTaskNo);
                    if (NS_Act <> '') and (NS_Proc <> '') then
                        CombinedJobTaskNo := NS_Act + '-' + NS_Proc;

                    if (NS_Act <> '') and (NS_Proc = '') then
                        CombinedJobTaskNo := NS_Act;

                    Ntasklines.Reset();
                    Ntasklines.SetRange("Job No.", Job."No.");
                    Ntasklines.SetRange(NS_Act, NS_Act);
                    Ntasklines.SetFilter("NS_Work Units", '<>%1', 0);
                    if Ntasklines.FindFirst() then
                        WorkUnitJT := Ntasklines."NS_Work Units";

                    if XACTIVITY <> NS_Act
                    then begin
                        Ntasklines.Reset();
                        Ntasklines.SetRange("Job No.", Job."No.");
                        Ntasklines.SetRange(NS_Act, NS_Act);
                        Ntasklines.SetFilter("NS_Work Units", '<>%1', 0);
                        if Ntasklines.FindFirst() then begin
                            ToTWorkUnitJT += Ntasklines."NS_Work Units";
                            XACTIVITY := NS_Act;
                        end;

                    end;


                    Ntasklines.Reset();
                    Ntasklines.SetRange("Job No.", Job."No.");
                    Ntasklines.SetRange(NS_Act, NS_Act);
                    Ntasklines.SetFilter("NS_Work Unit of Measure", '<>%1', '');
                    if Ntasklines.FindFirst() then
                        WorkUnitMeasureJT := Ntasklines."NS_Work Unit of Measure";

                    if WorkUnitJT <> 0 then
                        EstUnitCost := ROUND("Schedule (Total Cost)" / WorkUnitJT, 0.01);
                    EstCost := "Schedule (Total Cost)";

                    //Values of WEEKLY - Start
                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    if (startdate <> 0D) and (enddate <> 0D) then
                        NJobledgEntries.SetFilter("Posting Date", '%1..%2', startdate, enddate);
                    if (startdate <> 0D) and (enddate = 0D) then
                        NJobledgEntries.SetRange("Posting Date", startdate);
                    if (startdate = 0D) and (enddate <> 0D) then
                        NJobledgEntries.SetFilter("Posting Date", '..%1', enddate);
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    //NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    NJobledgEntries.SetFilter("NS_Work Units", '<>%1', 0);
                    if NJobledgEntries.FindFirst() then
                        WEQty := NJobledgEntries."NS_Work Units";

                    if YACTIVITY <> NS_Act
                    then begin
                        NJobledgEntries.Reset();
                        NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                        NJobledgEntries.SetRange("Job No.", Job."No.");
                        if (startdate <> 0D) and (enddate <> 0D) then
                            NJobledgEntries.SetFilter("Posting Date", '%1..%2', startdate, enddate);
                        if (startdate <> 0D) and (enddate = 0D) then
                            NJobledgEntries.SetRange("Posting Date", startdate);
                        if (startdate = 0D) and (enddate <> 0D) then
                            NJobledgEntries.SetFilter("Posting Date", '..%1', enddate);
                        NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                        NJobledgEntries.SetFilter("NS_Work Units", '<>%1', 0);
                        if NJobledgEntries.FindFirst() then begin
                            TotWEQty += NJobledgEntries."NS_Work Units";
                            YACTIVITY := NS_Act;
                        end;
                    end;

                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    if (startdate <> 0D) and (enddate <> 0D) then
                        NJobledgEntries.SetFilter("Posting Date", '%1..%2', startdate, enddate);
                    if (startdate <> 0D) and (enddate = 0D) then
                        NJobledgEntries.SetRange("Posting Date", startdate);
                    if (startdate = 0D) and (enddate <> 0D) then
                        NJobledgEntries.SetFilter("Posting Date", '..%1', enddate);
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    //PRJ-1456.JS.1.0 Start
                    //if NJobledgEntries.FindFirst() then
                    if NJobledgEntries.FindSet() then begin
                        NJobledgEntries.CalcSums("Total Cost");
                        WEPosted := NJobledgEntries."Total Cost";
                    end;
                    //PRJ-1456.JS.1.0 end

                    PHdr.Reset();
                    PHdr.SetRange("Document Type", PHdr."Document Type"::Order);
                    PHdr.SetRange("NS_Job No.", Job."No.");
                    if (startdate <> 0D) and (enddate <> 0D) then
                        PHdr.SetFilter("Posting Date", '%1..%2', startdate, enddate);
                    if (startdate <> 0D) and (enddate = 0D) then
                        PHdr.SetRange("Posting Date", startdate);
                    if (startdate = 0D) and (enddate <> 0D) then
                        PHdr.SetFilter("Posting Date", '..%1', enddate);
                    if PHdr.FindSet() then
                        repeat
                            PLine.Reset();
                            PLine.SetRange("Document Type", PLine."Document Type"::Order);
                            PLine.setrange("Document No.", PHdr."No.");
                            PLine.SetRange("Job Task No.", CombinedJobTaskNo);
                            if PLine.FindSet() then
                                repeat
                                    //PRJ-1456.JS.1.0-Start
                                    //WERecNoInv := PLine."Amt. Rcd. Not Invoiced";
                                    WERecNoInv := WERecNoInv + PLine."Amt. Rcd. Not Invoiced";
                                //PRJ-1456.JS.1.0-end
                                until PLine.Next() = 0;
                        until PHdr.Next() = 0;

                    WETotlCost := round(WEPosted + WERecNoInv, 0.01);


                    if WEQty <> 0 then
                        WEUniCost := Round(WETotlCost / WEQty, 0.01);
                    //Values of WEEKLY - end

                    //Values of MONTHLY - Start
                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    NJobledgEntries.Setrange("Posting Date", cmstartdate, cmenddate);
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    //NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    NJobledgEntries.SetFilter("NS_Work Units", '<>%1', 0);
                    //PRJ-1456.JS.1.0-start
                    //if NJobledgEntries.FindFirst() then
                    if NJobledgEntries.FindSet() then begin
                        NJobledgEntries.CalcSums("NS_Work Units");
                        MonthlyQty := NJobledgEntries."NS_Work Units";
                    end;
                    //PRJ-1456.JS.1.0-End

                    if ZACTIVITY <> NS_Act then begin
                        NJobledgEntries.Reset();
                        NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                        NJobledgEntries.SetRange("Job No.", Job."No.");
                        NJobledgEntries.Setrange("Posting Date", cmstartdate, cmenddate);
                        NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                        //NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                        NJobledgEntries.SetFilter("NS_Work Units", '<>%1', 0);
                        //PRJ-1456.JS.1.0-Start
                        //if NJobledgEntries.FindFirst() then begin
                        if NJobledgEntries.FindSet() then begin
                            NJobledgEntries.CalcSums("NS_Work Units");
                            ToTMonthlyQty += NJobledgEntries."NS_Work Units";
                            ZACTIVITY := NS_Act;
                        end;
                        //PRJ-1456.JS.1.0-end
                    end;

                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    NJobledgEntries.Setrange("Posting Date", cmstartdate, cmenddate);
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    //PRJ-1456.JS.1.0 Start
                    //if NJobledgEntries.FindFirst() then
                    if NJobledgEntries.FindSet() then Begin
                        NJobledgEntries.CalcSums("Total Cost");
                        MonthlyPosted := NJobledgEntries."Total Cost";
                    end;
                    //PRJ-1456.JS.1.0 end;

                    PHdr.Reset();
                    PHdr.SetRange("Document Type", PHdr."Document Type"::Order);
                    PHdr.SetRange("NS_Job No.", Job."No.");
                    PHdr.SetRange("Posting Date", cmstartdate, cmenddate);
                    if PHdr.FindSet() then
                        repeat
                            PLine.Reset();
                            PLine.SetRange("Document Type", PLine."Document Type"::Order);
                            PLine.setrange("Document No.", PHdr."No.");
                            PLine.SetRange("Job Task No.", CombinedJobTaskNo);
                            if PLine.FindSet() then
                                repeat
                                    //PRJ-1456.JS.1.0-Start
                                    //MonthlyRecNoInv := PLine."Amt. Rcd. Not Invoiced";
                                    MonthlyRecNoInv := MonthlyRecNoInv + PLine."Amt. Rcd. Not Invoiced";
                                //PRJ-1456.JS.1.0-end
                                until PLine.Next() = 0;
                        until PHdr.Next() = 0;

                    MonthlyTotlCost := round(MonthlyPosted + MonthlyRecNoInv, 0.01);

                    if MonthlyQty <> 0 then
                        MonthlyUnitCost := Round(MonthlyTotlCost / MonthlyQty, 0.01);
                    //Values of MONTHLY - end

                    //Values of JOB-TO-DATE - Start
                    CurrMounthLastDate := CalcDate('<CM>', enddate);  //PRJ-1456.JS.1.0

                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    NJobledgEntries.SetFilter("Posting Date", '..%1', CurrMounthLastDate);  //PRJ-1456.JS.1.0
                    //NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    //NJobledgEntries.SetFilter("NS_Work Units", '<>%1', 0);
                    if NJobledgEntries.FindFirst() then
                        repeat
                            TotalJB2DateQty += NJobledgEntries."NS_Work Units";
                        until NJobledgEntries.Next() = 0;

                    JobToDateQty := TotalJB2DateQty;

                    if KACTIVITY <> NS_Act
                     then begin
                        NJobledgEntries.Reset();
                        NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                        NJobledgEntries.SetRange("Job No.", Job."No.");
                        NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                        if NJobledgEntries.FindSet() then begin
                            repeat
                                TotJBqty1 += NJobledgEntries."NS_Work Units";
                            until NJobledgEntries.Next() = 0;

                            TotJBqty2 += TotJBqty1;
                            KACTIVITY := NS_Act;
                        end;
                    end;

                    NJobledgEntries.Reset();
                    NJobledgEntries.SetRange("Entry Type", NJobledgEntries."Entry Type"::Usage);
                    NJobledgEntries.SetRange("Job No.", Job."No.");
                    NJobledgEntries.SetRange("NS_Activity Code", NS_Act);
                    NJobledgEntries.SetRange("NS_Process Code", NS_Proc);
                    //PRJ-1456.JS.1.0 01JULY22 -Start
                    NJobledgEntries.SetFilter("Posting Date", '..%1', CurrMounthLastDate);
                    //if NJobledgEntries.FindFirst() then
                    if NJobledgEntries.FindSet() then Begin
                        NJobledgEntries.CalcSums("Total Cost");
                        JobToDatePosted := NJobledgEntries."Total Cost";
                    end;
                    //PRJ-1456.JS.1.0 01JULY22 -end

                    PHdr.Reset();
                    PHdr.SetRange("Document Type", PHdr."Document Type"::Order);
                    PHdr.Setrange("Posting Date", 0D, cmenddate);//PRJ-1456.AS.2.0 24JUNE2022
                    PHdr.SetRange("NS_Job No.", Job."No.");
                    if PHdr.FindSet() then
                        repeat
                            PLine.Reset();
                            PLine.SetRange("Document Type", PLine."Document Type"::Order);
                            PLine.setrange("Document No.", PHdr."No.");
                            PLine.SetRange("Job Task No.", CombinedJobTaskNo);
                            if PLine.FindSet() then
                                repeat
                                    //PRJ-1456.JS.1.0-Start
                                    //JobToDteRecNoInv := PLine."Amt. Rcd. Not Invoiced";
                                    JobToDteRecNoInv := JobToDteRecNoInv + PLine."Amt. Rcd. Not Invoiced";
                                //PRJ-1456.JS.1.0-end
                                until PLine.Next() = 0;
                        until PHdr.Next() = 0;

                    JobToDateTotlCost := round(JobToDatePosted + JobToDteRecNoInv, 0.01);

                    if JobToDateQty <> 0 then
                        JobToDateUnitCost := Round(JobToDateTotlCost / JobToDateQty, 0.01);
                    //Values of JOB-TO-DATE - end

                    if EstCost <> 0 then
                        PerComplVal := ROUND((JobToDateTotlCost / EstCost) * 100, 0.01);

                    if WorkUnitJT <> 0 then
                        PerCUsedVal := Round((JobToDateQty / WorkUnitJT) * 100, 0.01);

                    //Case 1 - If Job forecast exist START
                    JobForcast.Reset();
                    JobForcast.SetRange("NS_Job No.", Job."No.");
                    JobForcast.SetRange("NS_Job Task No.", CombinedJobTaskNo);
                    JobForcast.SetRange(NS_Posted, true);
                    JobForcast.SetFilter("NS_Status Date", '<=%1', enddate);
                    if JobForcast.FindLast() then begin
                        ProjCostVal := JobForcast."NS_Forecasted Completed Cost";

                        VarianceVal := ProjCostVal - EstCost;
                    end

                    //Case 1 - If Job forecast exist END 
                    //Case 2 - If Job forecast doesn't exist START
                    else
                        if JobForcast.Count = 0 then begin
                            ProjCostVal := EstCost;
                            VarianceVal := ProjCostVal - EstCost;
                        end;
                    //Case 2 - If Job forecast doesn't exist END


                    //ProjCostVal := EstCost;

                    CostToCompltVal := ProjCostVal - JobToDateTotlCost;

                    //VarianceVal := ProjCostVal - EstCost;
                end;

                trigger OnPreDataItem()
                begin
                    // SetFilter("Job Task Type", '%1|%2|%3', "Job Task Type"::"Begin-Total", "Job Task Type"::"End-Total", "Job Task Type"::Posting);//PRJ-1456.AS.1.0
                    Clear(CurrMounthLastDate);  //PRJ-1456.JS.1.0
                    SetRange("Job Task Type", "Job Task Type"::Posting);//PRJ-1456.AS.2.0   

                    //PRJ-1545.NK.1.0 26July2022 Start
                    if JTaskNo <> '' then
                        "Job Task".SETFILTER("Job Task No.", JTaskNo);
                    //PRJ-1545.NK.1.0 26July2022 End                 
                    Clear(XACTIVITY);
                    Clear(YACTIVITY);
                    Clear(ZACTIVITY);
                    Clear(KACTIVITY);
                    ToTWorkUnitJT := 0;
                    TotWEQty := 0;
                    ToTMonthlyQty := 0;
                    TotJBqty1 := 0;
                    TotJBqty2 := 0;

                end;


                trigger OnPostDataItem()
                begin

                end;

            }

            trigger OnPostDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CompAddress);
                Clear(CompFinalAddrLine);
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
                if CompanyInformation."Address 2" = '' then
                    CompAddress := CompanyInformation.Address;
                if CompanyInformation."Address 2" <> '' then
                    CompAddress := CompanyInformation.Address + ' ' + CompanyInformation."Address 2";
                CompFinalAddrLine := CompanyInformation.City + ' ' + CompanyInformation."Post Code" + ' ' + CompanyInformation."Country/Region Code";
            end;

            trigger OnPreDataItem()
            begin
                //PRJ-1545.NK.1.0 26July2022 Start
                if JobNumFilter <> '' then
                    Job.SETFILTER("No.", JobNumFilter);
                //PRJ-1545.NK.1.0 26July2022 End
                startdate := job.GetRangeMin("NS_Date Filter");
                enddate := Job.GetRangeMax("NS_Date Filter");

                cmenddate := CalcDate('CM', startdate);

                cmstartdate := CALCDATE('<-CM>', startdate);
                Clear(MonthName);
                Clear(YearName);

                YearName := FORMAT(DATE2DMY(startdate, 3));
                MonthName := FORMAT(startdate, 0, '<Month Text,12> ') + '' + FORMAT(YearName);

            end;

        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {

                group("NS_Custom Filters")
                {
                    Caption = 'Custom Filters';

                    field(JobNumFilter; JobNumFilter)
                    {
                        Caption = 'Job No.';
                        TableRelation = Job;
                        ApplicationArea = all;
                        trigger OnValidate()
                        begin
                            JTaskNo := '';
                        end;

                    }
                    //PRJ-1545.AS.1.0 START
                    field(JTaskNo; JTaskNo)
                    {
                        Caption = 'Job Task No.';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            NumbFilter: Record NSNumberFilter;
                            NumbFilter2: Record NSNumberFilter;
                            JobTaskLine: Record "Job Task";
                            JTaskNo2: Code[20];
                        begin


                            if JobNumFilter = '' then
                                Error('Please select Job No.');

                            NumbFilter.Reset();
                            NumbFilter.SetRange(Type, NumbFilter.Type::NS_Job);
                            NumbFilter.SetFilter("Document No.", '%1', JobNumFilter);
                            if NumbFilter.FindFirst() then
                                NumbFilter.DeleteAll();

                            JobTaskLine.Reset();
                            JobTaskLine.SetCurrentKey("Job No.", "Job Task No.");
                            JobTaskLine.SetFilter("Job No.", '%1', JobNumFilter);
                            JobTaskLine.SetRange("Job Task Type", JobTaskLine."Job Task Type"::Posting);
                            if JobTaskLine.FindFirst() then
                                repeat
                                    if JTaskNo2 <> JobTaskLine."Job Task No." then begin
                                        NumbFilter2.Init();
                                        NumbFilter2.Type := NumbFilter2.Type::NS_Job;
                                        NumbFilter2."Document No." := JobNumFilter;
                                        NumbFilter2."No." := JobTaskLine."Job Task No.";
                                        JTaskNo2 := JobTaskLine."Job Task No.";
                                        NumbFilter2.Insert();
                                    end;
                                until JobTaskLine.Next() = 0;
                            Commit();
                            NumbFilter.Reset();
                            NumbFilter.SetRange(Type, NumbFilter.Type::NS_Job);
                            NumbFilter.SetFilter("Document No.", JobNumFilter);
                            if PAGE.RUNMODAL(PAGE::"NSJobTaskNoFilter List", NumbFilter) = ACTION::LookupOK then
                                JTaskNo := NumbFilter."No.";
                        end;
                    }
                    //PRJ-1545.AS.1.0 End

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


    var
        XACTIVITY: Code[20];
        YACTIVITY: Code[20];
        ZACTIVITY: Code[20];
        KACTIVITY: Code[20];
        ToTWorkUnitJT: Decimal;
        TotWEQty: decimal;
        TotalJB2DateQty: Decimal;
        FinalTotalJB2DateQty: Decimal;
        JobForcast: Record "NS_Job Forecast";
        YearName: Text;
        MonthName: text;
        CombinedJobTaskNo: Code[35];
        cmstartdate: Date;
        cmenddate: Date;
        CurrMounthLastDate: Date; //PRJ-1456.JS.1.0.29JUN2022
        PHdr: Record "Purchase Header";
        PLine: Record "Purchase Line";
        startdate: Date;
        enddate: Date;
        NJobledgEntries: Record "Job Ledger Entry";
        EstQty: Integer;
        EstUnitCost: Decimal;
        EstCost: Decimal;
        WEQty: Decimal;
        WEUniCost: Decimal;
        WEPosted: Decimal;
        WERecNoInv: Decimal;
        WETotlCost: Decimal;
        MonthlyQty: Decimal;
        ToTMonthlyQty: Decimal;
        TotJBqty1: Decimal;
        TotJBqty2: Decimal;
        MonthlyUnitCost: Decimal;
        MonthlyPosted: Decimal;
        MonthlyRecNoInv: Decimal;
        MonthlyTotlCost: Decimal;
        JobToDateQty: Decimal;
        JobToDateUnitCost: Decimal;
        JobToDatePosted: Decimal;
        JobToDteRecNoInv: Decimal;
        JobToDateTotlCost: Decimal;
        PerCUsedVal: Decimal;
        PerComplVal: Decimal;
        CostToCompltVal: Decimal;
        ProjCostVal: Decimal;
        VarianceVal: Decimal;
        Ntasklines: Record "Job Task";
        Activity: Code[10];
        Process: Code[10];
        Operation: Code[10];
        CurrencyCode: Code[10];
        Section: Code[10];
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobSection: Record NS_Sections;
        CompanyInformation: Record "Company Information";
        CompAddress: Text;
        CompFinalAddrLine: Text;
        i: Integer;
        jobtaskLines: Record "Job Task";
        ProjNoCap: Label 'PROJECT NO.';
        ProJNameCap: Label 'PROJECT NAME';
        ProjMangr: Label 'PROJECT MANAGER';
        DirectrVPCap: Label 'DIRECTOR VP';
        CostAccTntCap: Label 'COST ACCOUNTANT';
        WeekEndCap: Label 'WEEK ENDING';
        MonthEndCap: Label 'MONTH ENDING';
        MONTHLYCOSTCAP: Label 'MONTHLY COST';
        COSTTODATE: Label 'COST TO DATE';
        COSTTOCOMPL: Label 'COST TO COMPLETE';
        COSTCODECAP: Label 'COST CODE';
        DESCCAP: Label 'DESCRIPTION';
        COSTTYPECAP: Label 'COST TYPE';
        UNITMESURECAP: Label 'UNIT MEASURE';
        ESTIMATEDCAP: Label 'ESTIMATED';
        QTYCAP: Label 'QTY.';
        UNITCOSTCAP: Label 'UNIT COST';
        COSTCAP: Label 'COST';
        RECNTINVCAP: Label 'REC NOT INV';
        TOTALCOSTCAP: Label 'TOTAL COST';
        POSTEDCAP: Label 'POSTED';
        JOBTODATECAP: Label 'JOB TO DATE';
        PERCCAP: Label '%';
        USEDCAP: Label 'USED';
        COMPLCAP: Label 'COMPL.';
        PROJCOSTCAP: Label 'PROJECTED COST';
        VARIANCECAP: Label 'VARIANCE';
        UNITCOSTREPCAP: Label 'JOB UNIT COST PRODUCTION REPORT';
        TOTALCAP: Label 'TOTAL';
        WorkUnitJT: Decimal;
        WorkUnitMeasureJT: Code[20];
        JTaskNo: Code[20];//PRJ-1545.AS.1.0 26July2022
        JobNumFilter: Code[20];//PRJ-1545.AS.1.0 26July2022
        NSUpgradeDataCodeunit: Codeunit "NS_UpgradeDataCodeunit"; //PE-317 AT.1.0 25June2024

    trigger OnPreReport()
    begin
        NSUpgradeDataCodeunit.UpdateJobTaskLine(); //PE-317 AT.1.0 25June2024
    end;

    trigger OnInitReport()
    begin

    end;

    trigger OnPostReport()
    begin
    end;
}