//PRJ-659.RM.1.0 22Oct2021 start| add new extension.
pageextension 14021449 NS_JobStatisticsExt extends "Job Statistics"
{
    layout
    {
        // Add changes to page layout here
        modify(Resource)
        {
            Caption = '                                  Resource';
        }
        modify(Item)
        {
            Caption = '                                         Item';
        }
        modify("G/L Account")
        {
            Caption = '                             G/L Account';
        }
        modify(Total)
        {
            Caption = '                                       Total';
        }
        modify(Control1903193001)
        {
            Caption = '                                  Resource';
        }
        modify(Control1904522201)
        {
            Caption = '                                         item';
        }
        modify(Control1904320401)
        {
            Caption = '                             G/L Account';
        }
        modify(Control1905314101)
        {
            Caption = '                                       Total';
        }
    }



    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
//PRJ-659.RM.1.0 22Oct2021 end