report 14021498 NS_CrewTimeSheetList
{
    //PRJ-1055.RM.1.0 | Created New Report
    Caption = 'Crew Time Sheet List';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSCrew Time Sheet List.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(NS_TimesheetHdrCustom; NS_TimesheetHdrCustom)
        {
            RequestFilterFields = "NS_No.";
            RequestFilterHeading = 'General';
            column(NS_No_; "NS_No.")
            { }
            column(NS_Crew_code; "NS_Crew code")
            { }
            column(NS_Description; NS_Description)
            {
            }
            column(LeadCrew; LeadCrew)
            { }
            trigger OnAfterGetRecord()
            var

                NS_CrewLines: Record "NS_Crew Line";
            begin
                Clear(LeadCrew);
                NS_CrewLines.Reset();
                NS_CrewLines.SetRange(NS_Code, "NS_Crew code");
                NS_CrewLines.SetRange("NS_Lead Person", true);
                if NS_CrewLines.FindFirst() then
                    LeadCrew := NS_CrewLines."NS_Resource No.";
            end;


        }
        dataitem(NS_TimeSheetLineCustom; NS_TimeSheetLineCustom)
        {
            DataItemLinkReference = "NS_TimesheetHdrCustom";
            DataItemLink = "NS_TimeSheetNo." = field("NS_No.");
            RequestFilterHeading = 'Time Sheet Line';
            column(NS_TimeSheetNo_; "NS_TimeSheetNo.")
            {
            }
            column(NS_Job_No_; "NS_Job No.")
            {

            }
            column(NS_Job_Task_No_; "NS_Job Task No.")
            {

            }
            column(NS_Resource_No_; "NS_Resource No.")
            {

            }
            column(NS_Resource_Name; "NS_Resource Name")
            { }
            column(NS_Resource_Working_Hours; "NS_Resource Working Hours")
            { }

            column(NS_LineNo_; "NS_LineNo.")
            { }
            column(NS_Working_Date; "NS_Working Date")
            { }
            column(NS_Status; NS_Status)
            { }
            column(NS_Work_Type_Code; "NS_Work Type Code")
            { }
            column(NS_Skill_Code; "NS_Skill Code")
            { }
            column(NS_Segment_Code; "NS_Segment Code")
            { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    var
        LeadCrew: Code[20];
}