table 14021351 "NS_My Subcontract"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'My Subcontract';

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
        field(2; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            NotBlank = true;
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_User ID", "NS_Subcontract No.")
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
        Subcontract: Record NS_Subcontract;
        "Count": Integer;
    begin
        Count := 0;
        Subcontract.SETFILTER("NS_No.", FilterStr);
        if Subcontract.FINDSET() then
            repeat
                "NS_User ID" := USERID;
                "NS_Subcontract No." := Subcontract."NS_No.";
                if INSERT() then
                    Count += 1;
            until Subcontract.NEXT() = 0;

        MESSAGE(Text001, Count, Subcontract.TABLECAPTION);
    end;
}

