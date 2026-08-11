report 14021479 NS_NewCrewTimeSheet
{
    // PE-156.HS.1.0. 31August2023 | Created New Report 
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = ' Crew Time Sheet Report';

    RDLCLayout = './Layouts/NS_CrewTimesheet.rdl';
    dataset
    {
        dataitem(NS_TimesheetHdrCustom; NS_TimesheetHdrCustom)
        {
            column(NS_No_; "NS_No.") { }
            column(NS_Work_Period_Start_Date_; format("NS_Work Period Start Date ")) { }
            column(NS_Work_Period_End_Date_; format("NS_Work Period End Date ")) { }
            column(NS_Description_NS_TimesheetHdrCustom; NS_Description) { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            column(CompanyInformationAdd; CompanyInformation.Address) { }
            column(CompanyInformationadd2; CompanyInformation."Address 2") { }
            column(CompanyInformationcity; CompanyInformation.City) { }
            column(CompanyInformationRegion; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation.County) { }
            column(CompanyInformationPhone; CompanyInformation."Phone No.") { }
            column(NS_CompanyFullAddress; NS_CompanyFullAddress) { }
            dataitem(NS_TimeSheetLineCustom; NS_TimeSheetLineCustom)
            {
                RequestFilterFields = "NS_Job No.", "NS_Resource No.", "NS_Working Date";
                DataItemLink = "NS_TimeSheetNo." = field("NS_No.");
                DataItemLinkReference = NS_TimesheetHdrCustom;
                column(NS_WorkTypeCode_NS_TimeSheetLineCustom; "NS_Work Type Code") { }
                column(NS_WorkingDate_NS_TimeSheetLineCustom; format("NS_Working Date")) { }
                column(NS_Job_No_; "NS_Job No.") { }
                column(NS_Resource_No_; "NS_Resource No.") { }
                column(NS_JobTaskNo_NS_TimeSheetLineCustom; "NS_Job Task No.") { }
                column(NS_Resource_Name_New; "NS_Resource Name New") { }
                column(NS_LeadPerson_NS_TimeSheetLineCustom; "NS_Lead Person") { }
                column(NS_Resource_Working_Hours; "NS_Resource Working Hours") { }
                column(NS_Status_NS_TimeSheetLineCustom; NS_Status) { }
                column(NS_Skill_Code_New; "NS_Skill Code New") { }
                column(NS_Description_NS_TimeSheetLineCustom; NS_Description) { }
                column(NS_TimeSheetNo_; "NS_TimeSheetNo.") { }
                column(NS_ResourceName; NS_ResourceName) { }

                trigger OnPreDataItem()
                begin
                    NS_TimeSheetLineCustom.SetRange("NS_Working Date", NS_startdate, NS_EndDate);

                end;

                trigger OnAfterGetRecord()
                var
                    NS_TimeSheetLineCustom1: Record NS_TimeSheetLineCustom;
                begin
                    NS_TimeSheetLineCustom1.Reset();
                    NS_TimeSheetLineCustom1.SetFilter("NS_Resource No.", '%1', NS_TimeSheetLineCustom."NS_Lead Person");
                    if NS_TimeSheetLineCustom1.FindSet() then
                        NS_ResourceName := NS_TimeSheetLineCustom1."NS_Resource Name New";
                end;
            }

            trigger OnPreDataItem()
            begin
                NS_TimesheetHdrCustom.Setrange("NS_No.", NS_TimeSheetNo);
                CompanyInformation.GET;
            end;

            trigger OnAfterGetRecord()
            begin
                NS_TimesheetHdrCustom."NS_Work Period Start Date " := NS_startdate;
                NS_TimesheetHdrCustom."NS_Work Period End Date " := NS_EndDate;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(NsTimeSheetNo; Ns_TimeSheetNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Time Sheet No.';
                    }
                    field(NsStartDate; NS_startdate)
                    {
                        ApplicationArea = all;
                        Caption = 'Start Date';
                        trigger OnValidate()
                        var
                            myInt: Integer;
                            startdate2: Date;
                        begin
                            NS_TimesheetHdrCustom.Reset();
                            NS_TimesheetHdrCustom.Setrange("NS_No.", NS_TimeSheetNo);
                            if NS_TimesheetHdrCustom.FindSet() then;
                            if (NS_startdate < NS_TimesheetHdrCustom."NS_Work Period Start Date ") then
                                Error('Date you have selected is not within the range of working date. Please enter correct range.');
                        end;
                    }
                    field(NSEndDate; NS_EndDate)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                        trigger OnValidate()
                        begin
                            NS_TimesheetHdrCustom.Reset();
                            NS_TimesheetHdrCustom.Setrange("NS_No.", NS_TimeSheetNo);
                            if NS_TimesheetHdrCustom.FindSet() then;
                            if (NS_EndDate > NS_TimesheetHdrCustom."NS_Work Period End Date ") then
                                Error('Date you have selected is not within the range of working date. Please enter correct range.');
                        end;
                    }

                }
            }
        }
    }
    procedure NSSetDate(NS_No: code[20]; Start_Date: Date; End_Date: Date)
    begin

        NS_TimeSheetNo := NS_No;
        NS_startdate := Start_Date;
        NS_EndDate := End_Date;

    end;

    var
        NS_startdate: Date;
        NS_TimeSheetNo: code[20];
        NS_EndDate: Date;
        NS_ResourceName: text[100];
        NS_CompanyInformationAdd: Text[250];
        NS_CompanyInformationadd2: Text[250];
        NS_CompanyInformationcity: Text;
        NS_CompanyInformationRegion: Code[20];
        NS_CompanyInformationpost: Code[20];
        NS_CompanyInformationCountry: Text[250];
        NS_CompanyFullAddress: Text[250];
        CompanyInformation: Record "Company Information";
}