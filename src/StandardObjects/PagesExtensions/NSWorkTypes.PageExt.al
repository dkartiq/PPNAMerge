pageextension 14021231 NS_WorkTypes extends "Work Types"
{
    // version NAVW111.00.PPNA11.00

    layout
    {
        addafter("Unit of Measure Code")
        {
            field("NS_Wage Type"; rec."NS_Wage Type")
            {
                ApplicationArea = All;
                Caption = 'Wage Type';

                ToolTip = 'Wage Type';
                Visible = NS_3rdPartyPayrollActive;
            }
            field("NS_Earning Code"; Rec."NS_Earning Code")
            {
                ApplicationArea = All;
                Caption = 'Earning Code';

                ToolTip = 'Earning Code';
                Visible = NS_3rdPartyPayrollActive;
            }
        }
    }

    var
        NS_HumanResourcesSetup: Record "Human Resources Setup";

        NS_3rdPartyPayrollActive: Boolean;

    trigger OnOpenPage();
    begin

        //ProjectPro - start
        NS_HumanResourcesSetup.GET;
        NS_3rdPartyPayrollActive := NS_HumanResourcesSetup."NS_Advanced Job Labor isActive";
        //ProjectPro - end

    end;

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     PP Wage Type
    //   +     PP Earning Code
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +     NS_3rdPartyPayrollActive
    //   +     NS_HumanResourcesSetup
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage    - Read NS_HumanResourcesSetup
    //   +                     - Set NS_3rdPartyPayrollActive
    //   +-----------------------------------------------------------------------------------------------
}

