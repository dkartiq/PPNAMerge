table 14021164 "NS_Crew Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    ////PRJ-744.JS.1.0�23July2021 Add field NS_Active
    //PRJ-949.GK.1.0 01Oct2021 |Added Code
    //PRJ-991.GK.2.0 22Oct2021 | Added code
    //PRJ-1270.NK.1.0 29Mar2022 | Added code
    Caption = 'Crew Line';

    fields
    {
        field(1; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;

        }
        field(10; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;
            DataClassification = CustomerContent;
            //PRJ-949.GK.1.0 01Oct2021 start
            trigger OnValidate()
            var
                NS_CrewLine: Record "NS_Crew Line"; //PRJ-991.GK.2.0 22Oct2021
                Txt14021141Lbl: Label 'Resource Line already exist.'; //PRJ-991.GK.2.0 22Oct2021
                ReSource: Record Resource; //PRJ-1270.NK.1.0 29Mar2022
                Txt14021142Lbl: Label 'Sorry! Resource is Blocked.'; //PRJ-1270.NK.1.0 29Mar2022
            begin
                //PRJ-991.GK.2.0 22Oct2021 start
                NS_CrewLine.Reset();
                NS_CrewLine.SetRange(NS_Code, NS_Code);
                NS_CrewLine.SetRange("NS_Resource No.", "NS_Resource No.");
                if not NS_CrewLine.IsEmpty() then
                    Error(Txt14021141Lbl);
                //PRJ-991.GK.2.0 22Oct2021 end
                //PRJ-1270.NK.1.0 29Mar2022 Start
                if ReSource.get("NS_Resource No.") then;
                if ReSource.Blocked then
                    Error(Txt14021142Lbl);
                //PRJ-1270.NK.1.0 29Mar2022 End

                if "NS_Resource No." <> '' then
                    Validate(NS_Active, true);

            end;
            //PRJ-949.GK.1.0 01Oct2021 end
        }
        field(11; "NS_Resource Name"; Text[50])
        {
            CalcFormula = Lookup(Resource.Name WHERE("No." = FIELD("NS_Resource No.")));
            Caption = 'Resource Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "NS_Lead Person"; Boolean)
        {
            Caption = 'Lead Person';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
               //PRJ-772.JS.1.0 - START
               IF "NS_Lead Person" = true then
                    NS_Active := true;
                    //PRJ-772.JS.1.0 - END
            end;
        }
        field(13; "NS_Active"; Boolean)         //PRJ-772.JS.1.0�23July2021
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                NS_JobCrewResource: Record "NS_Job Crew Resource"; //PRJ-991.GK.2.0 22Oct2021
                NS_JobCrews: Record "NS_Job Crews";//PRJ-991.GK.2.0 22Oct2021
                NS_Job: Record Job;
            begin
                IF NS_Active = false then
                    TestField("NS_Lead Person", false);
                //PRJ-991.GK.2.0 22Oct2021 start
                if NS_Active = true then begin
                    NS_JobCrews.Reset();
                    NS_JobCrews.SetRange("NS_Crew Code", NS_Code);
                    NS_JobCrews.SetRange(NS_Active, true);
                    if NS_JobCrews.FindSet() then
                        repeat
                            if NS_Job.Get(NS_JobCrews."NS_Job No.") AND (NS_Job.Status = NS_Job.Status::Open) then begin
                                NS_jobCrewResource.Init();
                                NS_jobCrewResource."NS_Crew Code" := NS_Code;
                                NS_jobCrewResource."NS_Job No." := NS_JobCrews."NS_Job No.";
                                NS_jobCrewResource."NS_Resource No." := "NS_Resource No.";
                                NS_jobCrewResource.Insert();
                            end;
                        until NS_JobCrews.Next() = 0;
                end else begin
                    NS_JobCrews.Reset();
                    NS_JobCrews.SetRange("NS_Crew Code", NS_Code);
                    if NS_JobCrews.FindSet() then
                        repeat
                            NS_JobCrewResource.Reset();
                            NS_JobCrewResource.SetRange("NS_Crew Code", NS_Code);
                            NS_JobCrewResource.SetRange("NS_Resource No.", "NS_Resource No.");
                            NS_JobCrewResource.SetRange("NS_Job No.", NS_JobCrews."NS_Job No.");
                            if NS_JobCrewResource.FindFirst() then
                                repeat
                                    NS_JobCrewResource.Delete();
                                until NS_JobCrewResource.Next() = 0;

                        until NS_JobCrews.Next() = 0;
                end;
                //PRJ-991.GK.2.0 22Oct2021 end

            end;
        }
    }

    keys
    {
        key(Key1; "NS_Code", "NS_Line No.")
        {
        }
    }
    //PRJ-991.GK.2.0 22Oct2021 start
    trigger OnDelete()
    var
        NS_JobCrewResource: Record "NS_Job Crew Resource";
        NS_JobCrews: Record "NS_Job Crews";
    begin
        NS_JobCrews.Reset();
        NS_JobCrews.SetRange("NS_Crew Code", NS_Code);
        if NS_JobCrews.FindSet() then
            repeat
                NS_JobCrewResource.Reset();
                NS_JobCrewResource.SetRange("NS_Crew Code", NS_Code);
                NS_JobCrewResource.SetRange("NS_Resource No.", "NS_Resource No.");
                NS_JobCrewResource.SetRange("NS_Job No.", NS_JobCrews."NS_Job No.");
                if NS_JobCrewResource.FindFirst() then
                    repeat
                        NS_JobCrewResource.Delete();
                    until NS_JobCrewResource.Next() = 0;

            until NS_JobCrews.Next() = 0;
        //PRJ-991.GK.2.0 22Oct2021 end
    end;



}

