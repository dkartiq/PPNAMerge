report 14021424 NS_LockUnlockDFRs
{
    //JD-54.AM.1.0 Created New Report
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Lock/Unlock DFRs';
    ProcessingOnly = true;

    dataset

    {
        dataitem("Job Planning Line"; "Job Planning Line")
        {

            trigger OnPreDataItem()
            var
            begin
                if DFRNoFilter <> '' then
                    "Job Planning Line".SetFilter("NS_DFR No.", DFRNoFilter);
                if (StartDate <> 0D) AND (Enddate <> 0D) then
                    "Job Planning Line".SetRange("Planning Date", StartDate, Enddate);

            end;

            trigger OnAfterGetRecord()
            var
                JPL: Record "Job Planning Line";
            begin
                JPL.Reset();
                if DFRNoFilter <> '' then
                    JPL.SetFilter("NS_DFR No.", DFRNoFilter);
                if (StartDate <> 0D) AND (Enddate <> 0D) then
                    JPL.SetRange("Planning Date", StartDate, Enddate);
                JPL.SetRange("NS_DFR Locked", false);
                JPL.SetFilter("Line Type", '<>%1', "Line Type"::Budget);
                if JPL.FindSet() then
                    repeat
                        JPL."NS_DFR Locked" := true;
                        JPL.Modify();
                    until JPL.Next() = 0;


                if UnlockDFR then begin
                    JPL.Reset();
                    if DFRNoFilter <> '' then
                        JPL.SetFilter("NS_DFR No.", DFRNoFilter);
                    if (StartDate <> 0D) AND (Enddate <> 0D) then
                        JPL.SetRange("Planning Date", StartDate, Enddate);
                    JPL.SetFilter("Line Type", '<>%1', "Line Type"::Budget);
                    if JPL.FindSet() then
                        repeat
                            JPL."NS_DFR Locked" := false;
                            JPL.Modify();
                        until JPL.Next() = 0;
                end;
            end;
        }

    }




    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(UnlockDFR; UnlockDFR)
                    {
                        ApplicationArea = All;
                        Caption = 'Unlock DFR';
                        trigger OnValidate()
                        var
                        begin
                            if UserSetup.Get(UserId) then
                                if NOT UserSetup."NS_Unlock DFR" then
                                    Error('You do not have Permission to unlock DFR.');

                        end;

                    }
                    field(DFRNoFilter; DFRNoFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'DFR No.Filter';
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Planning Start Date ';
                        trigger OnValidate()
                        var
                        begin
                            IF EndDate <> 0D then begin
                                IF StartDate > EndDate then
                                    Error('Start date cannot be greater than End date');
                            end;

                        end;
                    }
                    field(Enddate; Enddate)
                    {
                        ApplicationArea = all;
                        Caption = 'Planning End Date';
                        trigger OnValidate()
                        var
                        begin
                            IF StartDate = 0D then
                                Error('Start date cannot be blank');
                            IF EndDate < StartDate then
                                Error('End date cannot be less than Start date');

                        end;
                    }

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
        myInt: Integer;
        UnlockDFR: Boolean;
        DFRNoFilter: Code[20];
        PlanningDateFilter: date;
        StartDate: date;
        Enddate: Date;
        UserSetup: Record "User Setup";
        DFRBool: Boolean;


}