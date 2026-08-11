report 14021303 "NS_Initialize Subcont LinkList"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------    
    Caption = 'Initialize Subcont Link List';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Subcontract; NS_Subcontract)
        {
            DataItemTableView = SORTING("NS_No.") ORDER(Ascending);

            trigger OnAfterGetRecord();
            begin
                //Get number of seperators
                NumberOfSeperators := 0;
                for i := 1 to STRLEN("NS_No.") do begin
                    if STRPOS(JobsSetup."NS_Subcontract No. Separators", COPYSTR(Subcontract."NS_No.", i, 1)) > 0 then
                        NumberOfSeperators := NumberOfSeperators + 1;
                end;

                //Create initial Master or Primary type record
                with SubcontractLinks do begin
                    INIT();
                    "NS_Subcontract No." := Subcontract."NS_No.";
                    if ("NS_Sub-LeveltoSubcontractNo." = '') and (NumberOfSeperators = 0) then
                        "NS_Parent Subcontract No." := Subcontract."NS_No."
                    else
                        "NS_Parent Subcontract No." := "NS_Sub-LeveltoSubcontractNo.";
                    if INSERT() then;
                end;

                //Create a Secondary type to the Master Subcontract, if necessary
                if NumberOfSeperators > 1 then begin
                    MasterSubcontractNo := '';
                    for i := 1 to STRLEN("NS_No.") do begin
                        if STRPOS(JobsSetup."NS_Subcontract No. Separators", COPYSTR(Subcontract."NS_No.", i, 1)) > 0 then begin
                            MasterSubcontractNo := COPYSTR(Subcontract."NS_No.", 1, i - 1);
                            i := STRLEN("NS_No.");
                        end;
                    end;

                    with SubcontractLinks do begin
                        INIT();
                        "NS_Subcontract No." := Subcontract."NS_No.";
                        "NS_Parent Subcontract No." := MasterSubcontractNo;
                        if INSERT() then;
                    end;

                end;
            end;

            trigger OnPreDataItem();
            begin
                SubcontractLinks.RESET();
                SubcontractLinks.DELETEALL();

                JobsSetup.GET();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1100773014)
                {
                    field("WARNING!!    WARNING!!    WARNING!!    WARNING!!"; '')
                    {
                        Caption = 'WARNING!!    WARNING!!    WARNING!!    WARNING!!';
                        ApplicationArea = All;
                    }
                    field(Control1100773012; '')
                    {
                        ApplicationArea = All;
                    }
                    field("This routine will clear ALL subcontract links and create new links"; '')
                    {
                        Caption = 'This routine will clear ALL subcontract links and create new links';
                        ApplicationArea = All;
                    }
                    field("based on the ""Sub-Level to Subcontract No."" field in the"; '')
                    {
                        Caption = 'based on the "Sub-Level to Subcontract No." field in the';
                        ApplicationArea = All;
                    }
                    field("Subcontract cards.  Any additional links that were created"; '')
                    {
                        Caption = 'Subcontract cards.  Any additional links that were created';
                        ApplicationArea = All;
                    }
                    field("manually will have to be recreated."; '')
                    {
                        Caption = 'manually will have to be recreated.';
                        ApplicationArea = All;
                    }
                    field(Control1100773007; '')
                    {
                        ApplicationArea = All;
                    }
                    field("Subcontract links are automatically created as new"; '')
                    {
                        Caption = 'Subcontract links are automatically created as new';
                        ApplicationArea = All;
                    }
                    field("subcontracts and change orders are created and deleted."; '')
                    {
                        Caption = 'subcontracts and change orders are created and deleted.';
                        ApplicationArea = All;
                    }
                    field("Manual changes can be made from the Subcontract page."; '')
                    {
                        Caption = 'Manual changes can be made from the Subcontract page.';
                        ApplicationArea = All;
                    }
                    field(Control1100773003; '')
                    {
                        ApplicationArea = All;
                    }
                    field("The main purpose in using this function is to create subcontract"; '')
                    {
                        Caption = 'The main purpose in using this function is to create subcontract';
                        ApplicationArea = All;
                    }
                    field("links for an upgraded installation where Subcontract cards have"; '')
                    {
                        Caption = 'links for an upgraded installation where Subcontract cards have';
                        ApplicationArea = All;
                    }
                    field("been migrated and now new links need to be created."; '')
                    {
                        Caption = 'been migrated and now new links need to be created.';
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
        SubcontractLinks: Record "NS_Subcontract Links";
        JobsSetup: Record "Jobs Setup";
        MasterSubcontractNo: Code[20];
        i: Integer;
        NumberOfSeperators: Integer;
}

