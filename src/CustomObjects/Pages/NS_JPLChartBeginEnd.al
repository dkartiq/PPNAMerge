/// <summary>
/// ControlAddIn NSJobPlaningBeginEnd.
/// </summary>
//PE-115.DK.1.0 19July2023 Start
controladdin NSJobPlaningBeginEnd
{
    Scripts = 'NSProjectProcanvasjs.min.js', 'NSProjectProJobScript.js';
    StartupScript = 'addin/src/NSProjectProStartup.js';
    //StyleSheets = 'Progress1.css';
    RequestedHeight = 1200;
    RequestedWidth = 1200;
    RefreshScript = 'addin/src/NSProjectProChart.js';
    /// <summary>
    /// IAddInReady.
    /// </summary>
    event IAddInReady();
    procedure NSJPL(NS_JobNo: Code[20]; NS_Discription: Text[100]; Totalling: JsonArray; "Schedule (Total Cost)": JsonArray; "Usage (Total Cost)": JsonArray; "Contract (Total Price)": JsonArray; "Contract (Invoiced Price)": JsonArray);
}
page 14021373 NS_JobPlanningLineChart
{
    Caption = 'ProjectPro Job Task Chart';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {

            usercontrol(NSJpl; NSJobPlaningBeginEnd)
            {
                ApplicationArea = all;
                trigger IAddInReady()
                var
                begin

                end;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
        NSSchedularr: JsonArray;
        NSContractArr: JsonArray;
        NSJobTask: JsonArray;
        NSUsageTotaCost: JsonArray;
        NSContractInvoicedPrice: JsonArray;
    begin
        NS_JobTask.Reset();
        NS_JobTask.SetRange("Job No.", NS_JobNo);
        NS_JobTask.SetRange("Job Task Type", NS_JobTask."Job Task Type"::"End-Total");
        if NS_JobTask.FindFirst() then begin
            repeat
                NS_JobTask.CalcFields("Schedule (Total Cost)", "Usage (Total Cost)", "Contract (Total Price)", "Contract (Invoiced Price)");
                if NS_JobTask."Schedule (Total Cost)" <> 0 then begin
                    myInt := myInt + 1;
                    //PRJCTPR-350.DK.1.0 Start
                    //NS_TotAndDis := NS_JobTask.Totaling + ' ' + NS_JobTask.Description;
                    NS_TotAndDis := NS_JobTask.Description;
                    //PRJCTPR-350.DK.1.0 End
                    NS_RemaningDis := DelStr(NS_TotAndDis, 20);
                    NSJobTask.Add(NS_RemaningDis);
                    NSSchedularr.Add(NS_JobTask."Schedule (Total Cost)");
                    NSUsageTotaCost.Add(NS_JobTask."Usage (Total Cost)");
                    NSContractArr.Add(NS_JobTask."Contract (Total Price)");
                    NSContractInvoicedPrice.Add(NS_JobTask."Contract (Invoiced Price)")
                end;
            until NS_JobTask.Next() = 0;
            CurrPage.NSJpl.NSJPL(NS_JobNo, NS_Discription, NSJobTask, NSSchedularr, NSUsageTotaCost, NSContractArr, NSContractInvoicedPrice);
        end;
    end;

    procedure NSSetJobNo(NSJobNo: Code[20]; NSDiscription: Text[100])
    begin
        NS_JobNo := NSJobNo;
        NS_Discription := NSDiscription;
    end;

    var
        myInt: Integer;
        Bool: Boolean;
        Bool1: Boolean;
        NS_JobNo: Code[20];
        NS_Discription: Text[100];
        NS_TotAndDis: Text[200];
        NS_Job: Record Job;
        NS_JobTask: Record "Job Task";
        NS_RemaningDis: Text[200];
        NS_Jobplanning: Record "Job Planning Line";
}
//PE-115.DK.1.0 19July2023 End