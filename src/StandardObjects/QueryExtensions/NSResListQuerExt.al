query 14021413 "NS_Resource List Query"
{

    Caption = 'Resource List Query';
    QueryType = Normal;
    //PRJ-1195.AS.1.0 27APRIL2022 Created New Resource List Query

    elements
    {
        dataitem(Resource; Resource)
        {
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }
            column(Name_2; "Name 2")
            {

            }
            column(Type; Type)
            {

            }
            column(Base_Unit_of_Measure; "Base Unit of Measure")
            {

            }
            column(Unit_Cost; "Unit Cost")
            {

            }
            column(Unit_Price; "Unit Price")
            {

            }
            column(Price_Profit_Calculation; "Price/Profit Calculation")
            {

            }
            column(Profit__; "Profit %")
            {

            }
            column(Gen__Prod__Posting_Group; "Gen. Prod. Posting Group")
            {

            }
            column(Search_Name; "Search Name")
            {

            }
            column(Default_Deferral_Template_Code; "Default Deferral Template Code")
            { }
            column(NS_Default_Job_Task_No; "NS_Default Job Task No")
            { }
            column(Resource_Group_No_; "Resource Group No.")
            { }
            column(NS_Res__FA_No_; "NS_Res. FA No.")
            { }
            column(NS_Job_Revenue_Category; "NS_Job Revenue Category")
            { }
        }
    }


    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}