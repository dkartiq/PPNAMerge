table 14021307 "NS_Subcontract Links"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Links';

    fields
    {
        field(1; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            NotBlank = true;
            TableRelation = NS_Subcontract."NS_No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Parent Subcontract No."; Code[20])
        {
            Caption = 'Parent Subcontract No.';
            NotBlank = true;
            TableRelation = NS_Subcontract."NS_No.";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Subcontract No.", "NS_Parent Subcontract No.")
        {
        }
        key(Key2; "NS_Parent Subcontract No.", "NS_Subcontract No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure NS_CreateSubcontractLinks(SubcontractNo: Code[20]; Parent: Code[20]);
    var
        Subcontract: Record NS_Subcontract;
        JobsSetup: Record "Jobs Setup";
        SubcontractLinks: Record "NS_Subcontract Links";
        SubcontractNoWork: Code[20];
        NoOfSeparators: Integer;
        i: Integer;
    begin
        with SubcontractLinks do begin
            JobsSetup.GET();
            if JobsSetup."NS_Subcont ListAutoLinkCreate" then
                if SubcontractNo > '' then
                    if Parent > '' then begin
                        NoOfSeparators := Subcontract.NS_SeparatorCount(SubcontractNo);
                        if NoOfSeparators > 0 then begin
                            SubcontractNoWork := Parent;
                            for i := 1 to NoOfSeparators do
                                if SubcontractNoWork > '' then begin
                                    INIT();
                                    "NS_Subcontract No." := SubcontractNo;
                                    "NS_Parent Subcontract No." := SubcontractNoWork;
                                    if INSERT() then;
                                    SubcontractNoWork := Subcontract.NS_ParentSubcontractNo(SubcontractNoWork);
                                end else begin
                                    INIT();
                                    "NS_Subcontract No." := SubcontractNo;
                                    "NS_Parent Subcontract No." := SubcontractNo;
                                    if INSERT() then;
                                end;
                        end;
                    end;
        end;
    end;

    procedure NS_DeleteSubcontractLinks(SubcontractNo: Code[20]);
    var
        JobsSetup: Record "Jobs Setup";
        SubcontractLinks: Record "NS_Subcontract Links";
    begin
        with SubcontractLinks do
            if SubcontractNo > '' then begin
                JobsSetup.GET();
                if JobsSetup."NS_Subcont ListAutoLinkCreate" then begin
                    RESET();
                    SETCURRENTKEY("NS_Subcontract No.", "NS_Parent Subcontract No.");
                    SETRANGE("NS_Subcontract No.", SubcontractNo);
                    DELETEALL();
                end;
            end;
    end;
}

