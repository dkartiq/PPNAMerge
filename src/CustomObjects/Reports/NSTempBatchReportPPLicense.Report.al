report 14021398 "NS_TempBatchRepeort PPLicense"
{

    //PRJ-1184.JS.1.0 15FEB2022 New Batch report Not used to Publish

    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Temp Batch Report PP License';
    //Permissions = 

    dataset
    {
        dataitem(NS_PPClientLicenseInformation; NS_PPClientLicenseInformation)
        {
            trigger OnAfterGetRecord()
            begin
                NS_PPClientLicenseInformation.DeleteAll();
            end;

            trigger OnPreDataItem()
            begin
            end;
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
        Message('PP Client License Information Get Deleted');
    end;

    trigger OnPreReport()
    var
    begin
    end;

    var
        jobRec: Record Job;
}