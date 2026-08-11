/// <summary>
/// Table NS_Job Crews (ID 14021224).
/// </summary>
// PRJ-949.GK.1.0 01Oct2021 |Add new Table.
//PRJ-991.GK.2.0 22Oct2021 | Added Code.

table 14021224 "NS_Job Crews"
{
    DataClassification = CustomerContent;
    Caption = 'Job Crews';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
            TableRelation = Job;

        }
        field(2; "NS_Crew Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Crew Code';
            TableRelation = NS_Crew where(NS_Active = const(true));
            trigger OnValidate()
            var
                NS_CrewLines: Record "NS_Crew Line";
                NS_CrewLines2: Record "NS_Crew Line"; //PRJ-991.GK.2.0 22Oct2021 
                NS_jobCrewResource: Record "NS_Job Crew Resource"; //PRJ-991.GK.2.0 22Oct2021 
            begin
                NS_CrewLines.Reset();
                NS_CrewLines.SetRange(NS_Code, "NS_Crew Code");
                NS_CrewLines.SetRange("NS_Lead Person", true);
                if NS_CrewLines.FindFirst() then begin
                    Validate("NS_Lead Person", NS_CrewLines."NS_Resource No.");
                    //Validate(NS_Active, true); //PRJ-991.GK.2.0 22Oct2021|Comment

                end;
            end;
        }
        field(3; "NS_Lead Person"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Resource;
            Caption = 'Lead Person Code';
            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "NS_Lead Person" <> '' then
                    if Resource.Get("NS_Lead Person") then
                        Validate("NS_Lead Person Name", Resource.Name);
            end;
        }
        field(4; "NS_Total Crew Member"; Integer)
        {
            Caption = 'Total Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field("NS_Crew Code")));
            Editable = false;
        }
        field(5; "NS_Active Crew Member"; Integer)
        {
            Caption = 'Active Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field("NS_Crew Code"), NS_Active = filter(true)));
            Editable = false;
        }
        field(6; "NS_Inactive Crew Member"; Integer)
        {
            Caption = 'Inactive Crew Member';
            FieldClass = FlowField;
            CalcFormula = count("NS_Crew Line" WHERE(NS_Code = field("NS_Crew Code"), NS_Active = filter(false)));
            Editable = false;
        }
        field(7; NS_Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NS_InactiveResMessage: label 'This will Inactive the Crew No. %1 for Job no. %2, Do you want to continue?';
                //PRJ-991.GK.2.0 22Oct2021 start
                NS_CrewLines2: Record "NS_Crew Line";
                NS_jobCrewResource: Record "NS_Job Crew Resource";
                NS_Job: Record Job;
                //PRJ-991.GK.2.0 22Oct2021 end
            begin
                IF NS_Active = false then
                    if not Confirm(StrSubstNo(NS_InactiveResMessage, "NS_Crew Code", "NS_Job No.")) then
                        NS_Active := true
                    else
                        NS_Active := false;
                //PRJ-991.GK.2.0 22Oct2021  start
                if NS_Active = true then begin
                    if NS_Job.Get("NS_Job No.") then
                        NS_Job.TestField(Status, NS_Job.Status::Open);
                end;
                if NS_Active = true then begin
                    NS_CrewLines2.Reset();
                    NS_CrewLines2.SetRange(NS_Code, "NS_Crew Code");
                    NS_CrewLines2.SetRange(NS_Active, true);
                    if NS_CrewLines2.FindFirst() then
                        repeat
                            NS_jobCrewResource.Init();
                            NS_jobCrewResource."NS_Crew Code" := NS_CrewLines2.NS_Code;
                            NS_jobCrewResource."NS_Job No." := "NS_Job No.";
                            NS_jobCrewResource."NS_Resource No." := NS_CrewLines2."NS_Resource No.";
                            NS_jobCrewResource.Insert;
                        until NS_CrewLines2.Next() = 0;
                end else begin
                    NS_jobCrewResource.Reset();
                    NS_jobCrewResource.SetRange("NS_Job No.", "NS_Job No.");
                    NS_jobCrewResource.SetRange("NS_Crew Code", "NS_Crew Code");
                    if NS_jobCrewResource.FindFirst() then
                        repeat
                            NS_jobCrewResource.Delete;
                        until NS_jobCrewResource.Next() = 0;
                end;

                //PRJ-991.GK.2.0 22Oct2021  end




            end;
        }
        field(8; "NS_Lead Person Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Lead Person Name';
        }


    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Crew Code")
        {
            Clustered = true;
        }
    }
    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;
    //PRJ-991.GK.2.0 22Oct2021 start
    trigger OnDelete()
    var
        NS_jobCrewResource: Record "NS_Job Crew Resource";

    begin

        NS_jobCrewResource.Reset();
        NS_jobCrewResource.SetRange("NS_Job No.", "NS_Job No.");
        NS_jobCrewResource.SetRange("NS_Crew Code", "NS_Crew Code");
        if NS_jobCrewResource.FindFirst() then
            repeat
                NS_jobCrewResource.Delete;
            until NS_jobCrewResource.Next() = 0;
    end;
    //PRJ-991.GK.2.0 22Oct2021 end

    trigger OnRename()
    begin

    end;

}