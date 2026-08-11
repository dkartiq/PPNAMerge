table 14021160 "NS_APO Links Header"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'APO Links Header';
    LookupPageID = "NS_APO Links List";

    fields
    {
        field(1; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Template,Job';
            OptionMembers = Template,Job;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (NS_Type = CONST(Job)) Job."No.";
            DataClassification = CustomerContent;
        }
        field(3; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; NS_Type, "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001_Txt: Label 'APO Template %1 does not exist.', Comment = '%1 = APO Template Name';
        Text002_Txt: Label 'There must be a Code entered before trying to copy to it.';

    procedure NS_CopyFromTemplate(ToCode: Code[20]);
    var
        APOLinksHeader: Record "NS_APO Links Header";
        APOLinksLine: Record "NS_APO Links Line";
        APOLinksNewLine: Record "NS_APO Links Line";
        GetAPOCode: Page "NS_Get APO Links Code";
        FromCode: Code[20];

    begin
        if ToCode = '' then
            ERROR(Text002_Txt);

        GetAPOCode.RUNMODAL();
        FromCode := GetAPOCode.NS_GetCode;
        if APOLinksHeader.GET(NS_Type::Template, FromCode) then
            with APOLinksLine do begin
                RESET();
                SETRANGE(NS_Type, NS_Type::Template);
                SETRANGE(NS_Code, FromCode);
                if FINDFIRST() then
                    repeat
                        APOLinksNewLine.INIT();
                        APOLinksNewLine.NS_Type := NS_Type::Job;
                        APOLinksNewLine.NS_Code := ToCode;
                        APOLinksNewLine."NS_Source Type" := "NS_Source Type"::Cost;
                        APOLinksNewLine."NS_Source Activity Code" := "NS_Source Activity Code";
                        APOLinksNewLine."NS_Source Process Code" := "NS_Source Process Code";
                        APOLinksNewLine."NS_Source Operation Code" := "NS_Source Operation Code";
                        APOLinksNewLine."NS_Source Category" := "NS_Source Category";
                        APOLinksNewLine."NS_Destination Type" := "NS_Destination Type";
                        APOLinksNewLine."NS_Destination Activity Code" := "NS_Destination Activity Code";
                        APOLinksNewLine."NS_Destination Process Code" := "NS_Destination Process Code";
                        APOLinksNewLine."NS_Destination Operation Code" := "NS_Destination Operation Code";
                        APOLinksNewLine."NS_Destination Category" := "NS_Destination Category";
                        APOLinksNewLine.INSERT();
                    until APOLinksLine.NEXT() = 0
            end
        else
            ERROR(Text001_Txt, FromCode);
    end;

    procedure NS_Translate(Job: Code[20]; Type: Option Cost,Revenue; var Activity: Code[10]; var Process: Code[10]; var Operation: Code[10]; var Category: Code[10]);
    var
        APOLinksLine: Record "NS_APO Links Line";
    begin
        with APOLinksLine do begin
            RESET();
            SETRANGE(NS_Type, NS_Type::Job);
            SETRANGE(NS_Code, Job);
            SETRANGE("NS_Source Type", Type);
            if Activity > '' then
                SETRANGE("NS_Source Activity Code", Activity);
            if Process > '' then
                SETRANGE("NS_Source Process Code", Process);
            if Operation > '' then
                SETRANGE("NS_Source Operation Code", Operation);
            if Category > '' then
                SETRANGE("NS_Source Category", Category);
            if FINDFIRST() then begin
                Activity := "NS_Destination Activity Code";
                Process := "NS_Destination Process Code";
                Operation := "NS_Destination Operation Code";
                Category := "NS_Destination Category";
            end else begin
                Activity := '';
                Process := '';
                Operation := '';
                Category := '';
            end;
        end;
    end;

    //SMPL Replaced TextConst to Labels (TextConst is deprecated syntax)
}

