page 14021175 "NS_Job Types List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-194.AS.1.0 - 03APRIL2020 - Given Permission of Insert, modify, delete to the page.
    //PRJ-194.AS.1.0 - 03APRIL2020 - Changed page type from worksheet to list, beacuse Insert modify delete was not working in that. 

    Caption = 'Job Types List';
    //Editable = false; //PRJ-194.AS.1.0 - Commented
    Editable = true; //PRJ-194.AS.1.0 - Added
    //PageType = Worksheet; //PRJ-194.AS.1.0 - 3APRIL2020 commented
    PageType = List;//PRJ-194.AS.1.0 - 3APRIL2020 Added
    SourceTable = "NS_Job Type";
    UsageCategory = Administration;
    ApplicationArea = all;
    InsertAllowed = true;//PRJ-194.AS.1.0 - 3APRIL2020 Added
    ModifyAllowed = true;//PRJ-194.AS.1.0 - 3APRIL2020 Added
    DeleteAllowed = true;//PRJ-194.AS.1.0 - 3APRIL2020 Added

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
            }
        }
    }

    actions
    {
    }
}

