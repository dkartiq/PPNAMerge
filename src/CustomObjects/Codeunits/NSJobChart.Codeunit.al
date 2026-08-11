
/// <summary>
/// Codeunit NS_Job Chart Management (ID 14021221).
/// </summary>
/// PE-115.JS.1.0 03July2023 New codeunit
codeunit 14021221 "NS_Job Chart Management"
{
    trigger OnRun()
    begin

    end;

    var
        NSJobChartSetup: Record "NS_Job_Chart Setup";


    /// <summary>
    /// GeneratJobChartData.
    /// </summary>
    /// <param name="BusinessChartBuffer">VAR Record "Business Chart Buffer".</param>
    procedure GeneratJobChartData(var BusinessChartBuffer: Record "Business Chart Buffer")
    var
        NSJobs: Record Job;
        NSJobChartIndex: Record "NS_Job Chart Index";
        NSJobChartIndex2: Record "NS_Job Chart Index";
        NSInt: Integer;
        NSNoofJobs: Integer;
        NSIndex: Integer;
        NSJobNoText: Text[50];
    begin
        Clear(NSNoofJobs);
        Clear(NSJobNoText);
        Clear(BusinessChartBuffer);
        NSNoofJobs := 4;

        NSJobChartSetup.Reset();
        NSJobChartSetup.SetRange("NS_User ID", UserId);
        if not NSJobChartSetup.FindFirst() then
            page.RunModal(Page::"NS_Job_Chart Setup");
        if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." <> '')
            and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
            BusinessChartBuffer.Initialize();

            if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then
                BusinessChartBuffer.AddMeasure('$ Value', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type")
            else
                BusinessChartBuffer.AddMeasure('$ Value', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type");

            BusinessChartBuffer.SetXAxis('Job', BusinessChartBuffer."Data Type"::String);

            NSJobChartIndex.Reset();
            NSJobChartIndex.SetRange("NS_Document No.", NSJobChartSetup."NS_Job No.");
            if NSJobChartIndex.FindSet() then begin
                repeat
                    BusinessChartBuffer.AddColumn(NSJobChartIndex."NS_Value Description" + ', ' + NSJobChartIndex."NS_Document No." + ', ' + NSJobChartIndex."NS_Job Description");
                    if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then begin
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, NSJobChartIndex."NS_Index Value");
                    end else
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, 0);
                    NSIndex := NSIndex + 1;
                until NSJobChartIndex.Next() = 0
            end;
        end;
        if (NSJobChartSetup."NS_Project Manager No." <> '') and (NSJobChartSetup."NS_Job No." = '')
            and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
            BusinessChartBuffer.Initialize();

            if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type")
            else
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type");

            BusinessChartBuffer.SetXAxis('Job', BusinessChartBuffer."Data Type"::String);


            NSJobChartIndex.Reset();
            NSJobChartIndex.SetRange("NS_Document No.", NSJobChartSetup."NS_Job No.");
            if NSJobChartIndex.FindSet() then begin
                repeat
                    BusinessChartBuffer.AddColumn(NSJobChartIndex."NS_Value Description" + ', ' + NSJobChartIndex."NS_ChartProject Mgr. Name");
                    if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then begin
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, NSJobChartIndex."NS_Index Value");
                    end else
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, 0);
                    NSIndex := NSIndex + 1;
                until NSJobChartIndex.Next() = 0
            end;
        end;
        if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." = '')
            and (NSJobChartSetup."NS_Gen. Bus. Posting Group" <> '') and (NSJobChartSetup."NS_Hours Details" = false) then begin
            BusinessChartBuffer.Initialize();

            if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type")
            else
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type");

            BusinessChartBuffer.SetXAxis('Job', BusinessChartBuffer."Data Type"::String);


            NSJobChartIndex.Reset();
            NSJobChartIndex.SetRange("NS_Document No.", NSJobChartSetup."NS_Job No.");
            if NSJobChartIndex.FindSet() then begin
                repeat
                    BusinessChartBuffer.AddColumn(NSJobChartIndex."NS_Value Description" + ', ' + NSJobChartIndex."NS_Gen. Bus. Posting Group");
                    if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then begin
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, NSJobChartIndex."NS_Index Value");
                    end else
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, 0);
                    NSIndex := NSIndex + 1;
                until NSJobChartIndex.Next() = 0
            end;
        end;
        //For Hours Details - Start
        if (NSJobChartSetup."NS_Project Manager No." = '') and (NSJobChartSetup."NS_Job No." <> '')
            and (NSJobChartSetup."NS_Gen. Bus. Posting Group" = '') and (NSJobChartSetup."NS_Hours Details" = true) then begin
            BusinessChartBuffer.Initialize();

            if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type")
            else
                BusinessChartBuffer.AddMeasure('$ ', 1, BusinessChartBuffer."Data Type"::Decimal, NSJobChartSetup."NS_Chart Type");

            BusinessChartBuffer.SetXAxis('Job', BusinessChartBuffer."Data Type"::String);

            NSJobChartIndex.Reset();
            NSJobChartIndex.SetRange("NS_Document No.", NSJobChartSetup."NS_Job No.");
            if NSJobChartIndex.FindSet() then begin
                repeat
                    BusinessChartBuffer.AddColumn(NSJobChartIndex."NS_Value Description" + ' ' + NSJobChartSetup."NS_Job No." + ' ' + NSJobChartIndex."NS_Job Description");
                    if NSJobChartSetup."NS_Job Values" = NSJobChartSetup."NS_Job Values"::"$ Value" then begin
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, NSJobChartIndex."NS_Index Value");
                    end else
                        BusinessChartBuffer.SetValueByIndex(0, NSIndex, 0);
                    NSIndex := NSIndex + 1;
                until NSJobChartIndex.Next() = 0
            end;
        end;
        //For Hours Details - end
    end;

    /// <summary>
    /// NS_FillJobCostCategory.
    /// </summary>
    /// <param name="NS_JobNo">VAR Code[20].</param>
    //PE-115.DK.1.0 START
    procedure NS_FillJobCostCategory(var NS_JobNo: Code[20])
    var
        NSJPLCostCat: Record "Job Planning Line";
        NSJobCostCat: Code[20];
        NSNumberFilter: Record NSNumberFilter;
    begin
        NSNumberFilter.DeleteAll();
        NSNumberFilter.Reset();
        NSNumberFilter.SetFilter(Type, '%1', NSNumberFilter.Type::"NS_Job Cost Category");
        NSNumberFilter.SetFilter("Document No.", '%1', NS_JobNo);
        if NSNumberFilter.FindSet() then;
        Clear(NSJobCostCat);
        NSJPLCostCat.Reset();
        NSJPLCostCat.SetCurrentKey("NS_Cost Category");
        NSJPLCostCat.SetFilter("Job No.", '%1', NS_JobNo);
        NSJPLCostCat.SetFilter("NS_Cost Category", '<>%1', '');
        if NSJPLCostCat.FindSet() then begin
            repeat
                if NSJobCostCat <> NSJPLCostCat."NS_Cost Category" then begin
                    NSJobCostCat := NSJPLCostCat."NS_Cost Category";
                    NSNumberFilter.Init();
                    NSNumberFilter.Type := NSNumberFilter.Type::"NS_Job Cost Category";
                    NSNumberFilter."Document No." := NS_JobNo;
                    NSNumberFilter."No." := NSJobCostCat;
                    NSNumberFilter.Insert();
                end;
            until NSJPLCostCat.Next() = 0;
        end;
    end;

    /// <summary>
    /// NS_FillJobSegment.
    /// </summary>
    /// <param name="NS_JobNo">VAR Code[20].</param>
    procedure NS_FillJobSegment(var NS_JobNo: Code[20])
    var
        NSJPLSegmentCod: Record "Job Planning Line";
        NSJobSegment: Code[20];
        NSNumberFilter: Record NSNumberFilter;
    begin
        NSNumberFilter.DeleteAll();
        NSNumberFilter.Reset();
        NSNumberFilter.SetFilter(Type, '%1', NSNumberFilter.Type::"NS_Job Segment");
        NSNumberFilter.SetFilter("Document No.", '%1', NS_JobNo);
        if NSNumberFilter.FindSet() then;
        Clear(NSJobSegment);
        NSJPLSegmentCod.Reset();
        NSJPLSegmentCod.SetCurrentKey("NS_Segment Code");
        NSJPLSegmentCod.SetFilter("Job No.", '%1', NS_JobNo);
        NSJPLSegmentCod.SetFilter("NS_Segment Code", '<>%1', '');
        if NSJPLSegmentCod.FindSet() then begin
            repeat
                if NSJobSegment <> NSJPLSegmentCod."NS_Segment Code" then begin
                    NSJobSegment := NSJPLSegmentCod."NS_Segment Code";
                    NSNumberFilter.Init();
                    NSNumberFilter.Type := NSNumberFilter.Type::"NS_Job Segment";
                    NSNumberFilter."Document No." := NS_JobNo;
                    NSNumberFilter."No." := NSJobSegment;
                    NSNumberFilter.Insert();
                end;
            until NSJPLSegmentCod.Next() = 0;
        end

    end;
    //PE-115.DK.1.0 START
}