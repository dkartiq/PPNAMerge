query 14021412 "NS_JobPlanningLineBI"
{
    //PRJ-1195.AS.1.0 Created New Query object for Job Ledger entries fields inn Power Bi
    Caption = 'Job Planning Line BI';
    QueryType = Normal;

    elements
    {
        dataitem(Job_Planning_Line; "Job Planning Line")
        {
            column(Job_No_; "Job No.")
            {
            }
            column(Job_Task_No_; "Job Task No.")
            {
            }
            column(Line_Type; "Line Type")
            {
            }
            column(Line_No_; "Line No.")
            {
            }
            column(Planning_Date; "Planning Date")
            {
            }
            column(NS_Cost_Category; "NS_Cost Category")
            {
            }
            column(Total_Cost; "Total Cost")
            {
            }
            column(Total_Cost__LCY_; "Total Cost (LCY)")
            {
            }
            column(Line_Amount; "Line Amount")
            {
            }
            column(Line_Amount__LCY_; "Line Amount (LCY)")
            {
            }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Quantity_Base; "Quantity (Base)")
            {
            }
            column(Direct_Unit_Cost_LCY; "Direct Unit Cost (LCY)")
            {
            }
            column(Unit_Cost_LCY; "Unit Cost (LCY)")
            {
            }
            column(Total_Cost_LCY; "Total Cost (LCY)")
            {
            }
            column(Unit_Price_LCY; "Unit Price (LCY)")
            {
            }
            column(Total_Price_LCY; "Total Price (LCY)")
            {
            }
            column(Line_Amount_LCY; "Line Amount (LCY)")
            {
            }
            column(Type; Type)
            {
            }
            column(No_; "No.")
            { }
        }
    }
    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}