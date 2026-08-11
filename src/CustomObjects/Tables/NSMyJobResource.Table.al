table 14021352 "NS_My Job Resource"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'My Job Resource';

    fields
    {
        field(1; "NS_User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_User ID", "NS_Job No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Added %1 new %2';

    procedure AddEntities(FilterStr: Text[250]);
    var
        Job: Record Job;
        "Count": Integer;
    begin
        Count := 0;
        Job.SETFILTER("No.", FilterStr);
        if Job.FINDSET() then
            repeat
                "NS_User ID" := USERID;
                "NS_Job No." := Job."No.";
                if INSERT() then
                    Count += 1;
            until Job.NEXT() = 0;

        MESSAGE(Text001, Count, Job.TABLECAPTION);
    end;
}

