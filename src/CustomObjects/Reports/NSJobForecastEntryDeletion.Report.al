report 14021389 "NS_Job Forecast Entry Deletion"
////CTSI-203.AM.1.0 Create new report
/// PRJ-547.N.S.1.0  Add confirm message to delete the Forecast entry
//PRJ-659.RS.1.0 1July21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Job Forecast Entry Deletion';//PRJ-659.RS.1.0 1July21 Caption Added

    dataset
    {
        dataitem(Job; Job)
        {

            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "NS_Gen. Bus. Posting Group New", NS_Manager;//PRJ-831.AS.1.0 12OCT2021 Replaced Job Table field Gen Bus Posting Grp with Gen Bus Posting Grp New
            dataitem("NS_Job Forecast"; "NS_Job Forecast")
            {
                DataItemTableView = SORTING("NS_Job No.");
                DataItemLink = "NS_Job No." = field("No.");
                trigger OnAfterGetRecord()
                var
                begin
                    "NS_Job Forecast".DeleteAll();
                end;

            }
            //PRJ-547.AS.1.0 22FEB2021 - START
            dataitem("NS_Percentage of Completion"; "NS_Percentage of Completion")
            {
                DataItemTableView = SORTING("NS_Job No.");
                DataItemLink = "NS_Job No." = field("No.");
                trigger OnAfterGetRecord()
                var
                begin
                    "NS_Percentage of Completion".DeleteAll();
                end;

            }
            //PRJ-547.AS.1.0 22FEB2021 - END
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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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
    trigger OnPostReport()
    var
    begin
        if Confirmbool = true then
            Message('Job Forcast Entries, Project Summary Details entries has been deleted');//PRJ-547.AS.1.0 22FEB2021
    end;

    //PRJ-547.AS.1.0 22FEB2021 - start
    trigger OnPreReport()
    var
    begin
        if not CONFIRM('Do you want to delete Job Forcast Entries and Project Summary Details Entries', true) then begin
            Confirmbool := false;
            exit;
        end
        else
            Confirmbool := true;
    end;
    //PRJ-547.AS.1.0 22FEB2021 - end

    var
        myInt: Integer;
        Confirmbool: Boolean;
}