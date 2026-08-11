report 14021166 "NS_Initialize Job Link List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Initialize Job Link List';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                //Get number of seperators
                NumberOfSeperators := 0;
                for i := 1 to STRLEN("No.") do begin
                    if STRPOS(JobsSetup."NS_Job No. Separators", COPYSTR(Job."No.", i, 1)) > 0 then
                        NumberOfSeperators := NumberOfSeperators + 1;
                end;

                //Create initial Master or Primary type record
                with JobLinks do begin
                    INIT;
                    "NS_Job No." := Job."No.";
                    if ("NS_Sub-Level to Job No." = '') and (NumberOfSeperators = 0) then
                        "NS_Parent Job No." := Job."No."
                    else
                        "NS_Parent Job No." := Job."NS_Sub-Level to Job No.";

                    if INSERT then;
                end;

                //Create a Secondary type to the Master Job, if necessary
                if NumberOfSeperators > 1 then begin
                    MasterJobNo := '';
                    for i := 1 to STRLEN("No.") do begin
                        if STRPOS(JobsSetup."NS_Job No. Separators", COPYSTR(Job."No.", i, 1)) > 0 then begin
                            MasterJobNo := COPYSTR(Job."No.", 1, i - 1);
                            i := STRLEN("No.");
                        end;
                    end;

                    with JobLinks do begin
                        INIT;
                        "NS_Job No." := Job."No.";
                        "NS_Parent Job No." := MasterJobNo;
                        if INSERT then;
                    end;

                end;
            end;

            trigger OnPreDataItem();
            begin
                JobLinks.RESET;
                JobLinks.DELETEALL;

                JobsSetup.GET;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1100773004)
                {
                    field("WARNING!!    WARNING!!    WARNING!!    WARNING!!"; '')
                    {
                        Caption = 'WARNING!!    WARNING!!    WARNING!!    WARNING!!';
                        ApplicationArea = All;
                    }
                    field(Control1100773002; '')
                    {
                        ApplicationArea = All;
                    }
                    field("This routine will clear ALL job links and create new links based"; '')
                    {
                        Caption = 'This routine will clear ALL job links and create new links based';
                        ApplicationArea = All;
                    }
                    field("on the ""Sub-Level to Job No."" field in the Job cards.  Any"; '')
                    {
                        Caption = 'on the "Sub-Level to Job No." field in the Job cards.  Any';
                        ApplicationArea = All;
                    }
                    field("additional links that were created manually will have to be"; '')
                    {
                        Caption = 'additional links that were created manually will have to be';
                        ApplicationArea = All;
                    }
                    field("recreated."; '')
                    {
                        Caption = 'recreated.';
                        ApplicationArea = All;
                    }
                    field(Control1100773008; '')
                    {
                        ApplicationArea = All;
                    }
                    field("Job links are automatically created as new jobs and change"; '')
                    {
                        Caption = 'Job links are automatically created as new jobs and change';
                        ApplicationArea = All;
                    }
                    field("orders are created and deleted.  Manual changes can be made"; '')
                    {
                        Caption = 'orders are created and deleted.  Manual changes can be made';
                        ApplicationArea = All;
                    }
                    field("from the Job page."; '')
                    {
                        Caption = 'from the Job page.';
                        ApplicationArea = All;
                    }
                    field(Control1100773015; '')
                    {
                        ApplicationArea = All;
                    }
                    field("The main purpose in using this function is to create job links"; '')
                    {
                        Caption = 'The main purpose in using this function is to create job links';
                        ApplicationArea = All;
                    }
                    field("for an upgraded installation where Job cards have been"; '')
                    {
                        Caption = 'for an upgraded installation where Job cards have been';
                        ApplicationArea = All;
                    }
                    field("migrated and now new links need to be created."; '')
                    {
                        Caption = 'migrated and now new links need to be created.';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        JobLinks: Record "NS_Job Links";
        JobsSetup: Record "Jobs Setup";
        MasterJobNo: Code[20];
        i: Integer;
        NumberOfSeperators: Integer;
    // InitialScreenLine01: Label 'WARNING!!  WARNING!!  WARNING!!  WARNING!!  WARNING!!';
    // InitialScreenLine02: Label '';
    // InitialScreenLine03: Label 'This routine will clear ALL job links and create new links based on the';
}

