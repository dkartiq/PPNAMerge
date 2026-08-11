pageextension 14021292 NS_EmployeeCard extends "Employee Card"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-119.SK.1.0  Added actions
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Employee Card'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Mobile Phone No.")
        {
            field("NS_Default Work State"; Rec."NS_Default Work State")
            {
                ApplicationArea = All;
                Caption = 'Default Work State';
            }
        }
    }
    //PRJ-119.SK.1.0 start
    actions
    {
        //addafter("Con&fidential Info. Overview")
        addafter("Co&nfidential Info. Overview")
        {
            separator(NS_Separator1100773001)
            {
            }
            action("NS_Employee Wage Rates")
            {
                ApplicationArea = All;
                Caption = 'Employee Wage &Rates';
                Image = Costs;
                RunObject = Page "NS_Employee Wage Rates";
                RunPageLink = "NS_Employee No." = FIELD("No.");
            }
            action("NS_Employee Burden Details")
            {
                ApplicationArea = All;
                Caption = 'Employee Burden Details';
                Image = ApplyEntries;
                RunObject = Page "NS_Employee Burden Details";
                RunPageLink = "NS_Employee No." = FIELD("No.");
            }
        }
    }
    //PRJ-119.SK.1.0 End

}

/*
  +------------------------------------------------------------
  +ProjectPro
  +  - Added field(s):
  +     "PP Default Work State"
  +------------------------------------------------------------
*/



