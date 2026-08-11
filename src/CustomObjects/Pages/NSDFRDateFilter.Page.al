page 14021455 "NS_DFR Date  Filter"
{

    //JD-10.MS.1.0 create new dialog page for DFR report date filter

    Caption = 'DFR Date  Filter';
    PageType = StandardDialog;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("DFR Start Date"; Startdate)
                {
                    ApplicationArea = All;
                }
                field("DFR End Date"; EndDate)
                {
                    ApplicationArea = All;
                }

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

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin

    end;

    var

        StartDate: Date;
        EndDate: Date;

    procedure NS_GetPlanningdate(VAR ParaStartDate: Date; VAR ParaEndDate: Date);
    begin
        ParaStartDate := StartDate;
        ParaEndDate := EndDate;
    end;
}

