report 14021191 "NS_LoadProjectionsIntoForecast"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Load Projections Into Forecast';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Job Forecast"; "NS_Job Forecast")
        {

            trigger OnPreDataItem();
            begin
                with JobForecastProjections do begin
                    RESET();
                    SETCURRENTKEY("NS_Task Manager", "NS_Job No.", "NS_Job Task No.", "NS_Projection Date");
                    if "Job Forecast".GETFILTER("NS_Task Manager") > '' then
                        SETRANGE("NS_Task Manager", "Job Forecast".GETFILTER("NS_Task Manager"));
                    if "Job Forecast".GETFILTER("NS_Job No.") > '' then
                        SETRANGE("NS_Job No.", "Job Forecast".GETFILTER("NS_Job No."));
                    SETFILTER("NS_Projection Date", '<=%1', AsOfDate);
                    if FINDFIRST() then
                        repeat
                            JobForecastMod.RESET();
                            JobForecastMod.SETRANGE("NS_Job No.", "NS_Job No.");
                            JobForecastMod.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            JobForecastMod.FINDLAST();
                            JobForecastMod.VALIDATE("NS_Status Date", "NS_Projection Date");
                            JobForecastMod.VALIDATE("NS_Percent Complete", "NS_Percent Complete");
                            JobForecastMod.MODIFY();
                        until NEXT() = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AsOfDate; AsOfDate)
                    {
                        Caption = 'Get Projections As Of Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            AsOfDate := NextBillDate;
        end;
    }

    labels
    {
    }

    var
        JobForecastProjections: Record "NS_Job Forecast Projections";
        JobForecastMod: Record "NS_Job Forecast";
        AsOfDate: Date;
        NextBillDate: Date;

    procedure Set(NextBillDateIn: Date);
    begin
        NextBillDate := NextBillDateIn;
    end;
}

