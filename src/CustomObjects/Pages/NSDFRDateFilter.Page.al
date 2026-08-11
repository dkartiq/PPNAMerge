page 14021455 "NS_DFR Date  Filter"
{

    //JD-10.MS.1.0 create new dialog page for DFR report date filter
    //PE-75.RM.1.0 17May2023 | Added tootlip
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
                    ToolTip = 'Specifies the Starting Date from when the User wants to print the report';  //PE-75.RM.1.0 17May2023 
                }
                field("DFR End Date"; EndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the End Date till when the User wants to print the report'; //PE-75.RM.1.0 17May2023 
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

