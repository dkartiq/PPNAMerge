pageextension 14021293 NS_EmployeeList extends "Employee List"
{
    // version NAVW111.00.00.22292,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Employees'; //PRJ-1330.NK.1.0 25Apr2022
    actions
    {
        //addafter("Con&fidential Info. Overview")
        addafter("Con&fidential Info. Overview")
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
                ToolTip = 'Employee Wage Rates';
            }
            action("NS_Employee Burden Details")
            {
                ApplicationArea = All;
                Caption = 'Employee Burden Details';
                Image = ApplyEntries;
                RunObject = Page "NS_Employee Burden Details";
                RunPageLink = "NS_Employee No." = FIELD("No.");
                ToolTip = 'Employee Burden Details';
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Modification(s):
      +     - Added to Page Actions: Employee Wage Rates and Employee Burden Factors
      +------------------------------------------------------------
    */
}

