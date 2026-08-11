table 14021161 "NS_APO Links Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-820.JS.1.0�02Aug2021 | Add fields for get Cost and Revenue code
    //PRJ-1348.NK.1.0 24May2022 | Add Property
    Caption = 'APO Links Line';

    fields
    {
        field(1; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Template,Job';
            OptionMembers = Template,Job;
            TableRelation = "NS_APO Links Header".NS_Type;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "NS_APO Links Header".NS_Code WHERE(NS_Type = FIELD(NS_Type));
            DataClassification = CustomerContent;
        }
        field(11; "NS_Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Source Type" <> xRec."NS_Source Type" then begin
                    "NS_Source Activity Code" := '';
                    "NS_Source Process Code" := '';
                    "NS_Source Operation Code" := '';
                    "NS_Source Category" := '';
                end;
            end;
        }
        field(12; "NS_Source Activity Code"; Code[10])
        {
            Caption = 'Source Activity Code';
            NotBlank = true;
            TableRelation = "NS_Job Activity".NS_Code WHERE(NS_Type = FIELD("NS_Source Type"));
            DataClassification = CustomerContent;
            CaptionClass = '50997,0,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate();
            begin
                if "NS_Source Activity Code" <> xRec."NS_Source Activity Code" then begin
                    "NS_Source Process Code" := '';
                    "NS_Source Operation Code" := '';
                    //PRJ-820.JS.1.0�02Aug2021-Start
                    "NS_Cost Source Task Code" := '';
                    NS_CreateSourceTaskCode("NS_Source Activity Code", "NS_Source Process Code",
                    "NS_Source Operation Code", "NS_Source Section Code", "NS_Cost Source Task Code");
                    //Message('...%1..', "NS_Cost Source Task Code");
                    //PRJ-820.JS.1.0�02Aug2021-end    
                end;
            end;
        }
        field(13; "NS_Source Process Code"; Code[10])
        {
            Caption = 'Source Process Code';
            TableRelation = "NS_Job Process".NS_Code WHERE(NS_Type = FIELD("NS_Source Type"),
                                                      "NS_Activity Code" = FIELD("NS_Source Activity Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50997,1,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate();
            begin
                if "NS_Source Process Code" <> xRec."NS_Source Process Code" then
                    "NS_Source Operation Code" := '';
                //PRJ-820.JS.1.0�02Aug2021-Start
                "NS_Cost Source Task Code" := '';
                NS_CreateSourceTaskCode("NS_Source Activity Code", "NS_Source Process Code",
                "NS_Source Operation Code", "NS_Source Section Code", "NS_Cost Source Task Code");
                //Message('...%1..', "NS_Cost Source Task Code");
                //PRJ-820.JS.1.0�02Aug2021-end                       
            end;
        }
        field(14; "NS_Source Operation Code"; Code[10])
        {
            Caption = 'Source Operation Code';
            TableRelation = "NS_Job Operation".NS_Code WHERE(NS_Type = FIELD("NS_Source Type"),
                                                        "NS_Activity Code" = FIELD("NS_Source Activity Code"),
                                                        "NS_Process Code" = FIELD("NS_Source Process Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50997,2,0'; //PRJ-1348.NK.1.0 24May2022
            //PRJ-820.JS.1.0�02Aug2021-Start
            trigger OnValidate()
            begin
                "NS_Cost Source Task Code" := '';
                NS_CreateSourceTaskCode("NS_Source Activity Code", "NS_Source Process Code",
                "NS_Source Operation Code", "NS_Source Section Code", "NS_Cost Source Task Code");
                //Message('...%1..', "NS_Cost Source Task Code");
            end;
            //PRJ-820.JS.1.0�02Aug2021-end
        }

        field(15; "NS_Source Category"; Code[10])
        {
            Caption = 'Source Category';
            TableRelation = IF ("NS_Source Type" = CONST(Cost)) "NS_Job Cost Category".NS_Code
            ELSE
            IF ("NS_Source Type" = CONST(Revenue)) "NS_Job Revenue Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(51; "NS_Destination Type"; Option)
        {
            Caption = 'Matching Type';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Destination Type" <> xRec."NS_Destination Type" then begin
                    "NS_Destination Activity Code" := '';
                    "NS_Destination Process Code" := '';
                    "NS_Destination Operation Code" := '';
                    "NS_Destination Category" := '';
                end;
            end;
        }
        field(52; "NS_Destination Activity Code"; Code[10])
        {
            Caption = 'Matching Activity Code';
            NotBlank = true;
            TableRelation = "NS_Job Activity".NS_Code WHERE(NS_Type = FIELD("NS_Destination Type"));
            DataClassification = CustomerContent;
            CaptionClass = '50996,0,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate();
            begin
                if "NS_Destination Activity Code" <> xRec."NS_Destination Activity Code" then begin
                    "NS_Destination Process Code" := '';
                    "NS_Destination Operation Code" := '';
                    //PRJ-820.JS.1.0�02Aug2021-Start                   
                    "NS_Rev. Dest. Task Code" := '';
                    NS_CreateSourceTaskCode("NS_Destination Activity Code", "NS_Destination Process Code",
                    "NS_Destination Operation Code", "NS_Destination Section Code", "NS_Rev. Dest. Task Code");
                    //Message('2...%1..', "NS_Rev. Dest. Task Code");
                    //PRJ-820.JS.1.0�02Aug2021-end                    
                end;
            end;
        }
        field(53; "NS_Destination Process Code"; Code[10])
        {
            Caption = 'Matching Process Code';
            TableRelation = "NS_Job Process".NS_Code WHERE(NS_Type = FIELD("NS_Destination Type"),
                                                      "NS_Activity Code" = FIELD("NS_Destination Activity Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50996,1,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate();
            begin
                if "NS_Destination Process Code" <> xRec."NS_Destination Process Code" then
                    "NS_Destination Operation Code" := '';
                //PRJ-820.JS.1.0�02Aug2021-Start                   
                "NS_Rev. Dest. Task Code" := '';
                NS_CreateSourceTaskCode("NS_Destination Activity Code", "NS_Destination Process Code",
                "NS_Destination Operation Code", "NS_Destination Section Code", "NS_Rev. Dest. Task Code");
                //Message('2...%1..', "NS_Rev. Dest. Task Code");
                //PRJ-820.JS.1.0�02Aug2021-end                    
            end;
        }
        field(54; "NS_Destination Operation Code"; Code[10])
        {
            Caption = 'Matching Operation Code';
            TableRelation = "NS_Job Operation".NS_Code WHERE(NS_Type = FIELD("NS_Destination Type"),
                                                        "NS_Activity Code" = FIELD("NS_Destination Activity Code"),
                                                        "NS_Process Code" = FIELD("NS_Destination Process Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50996,2,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate()
            begin
                //PRJ-820.JS.1.0�02Aug2021-Start                   
                "NS_Rev. Dest. Task Code" := '';
                NS_CreateSourceTaskCode("NS_Destination Activity Code", "NS_Destination Process Code",
                "NS_Destination Operation Code", "NS_Destination Section Code", "NS_Rev. Dest. Task Code");
                //Message('2...%1..', "NS_Rev. Dest. Task Code");
                //PRJ-820.JS.1.0�02Aug2021-end
            end;
        }
        field(55; "NS_Destination Category"; Code[10])
        {
            Caption = 'Matching Category';
            TableRelation = IF ("NS_Destination Type" = CONST(Cost)) "NS_Job Cost Category".NS_Code
            ELSE
            IF ("NS_Destination Type" = CONST(Revenue)) "NS_Job Revenue Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(56; "NS_Cost Source Task Code"; Code[20])         //PRJ-820.JS.1.0�02Aug2021
        {
            Caption = 'Source Task Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(57; "NS_Rev. Dest. Task Code"; Code[20])          //PRJ-820.JS.1.0�02Aug2021
        {
            Caption = 'Destination Task Code';
            Editable = false;
            DataClassification = CustomerContent;
        }

        //PRJ-820.JS.1.0�03Aug2021-Start
        field(58; "NS_Source Section Code"; Code[10])
        {
            Caption = 'Source Section Code';
            TableRelation = "NS_Sections".NS_Code WHERE(NS_Type = FIELD("NS_Source Type"),
                                                        "NS_Activity Code" = FIELD("NS_Source Activity Code"),
                                                        "NS_Process Code" = FIELD("NS_Source Process Code"),
                                                        "NS_Operation Code" = field("NS_Source Operation Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50997,3,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate()
            begin
                "NS_Cost Source Task Code" := '';
                NS_CreateSourceTaskCode("NS_Source Activity Code", "NS_Source Process Code",
                "NS_Source Operation Code", "NS_Source Section Code", "NS_Cost Source Task Code");
            end;
        }
        field(59; "NS_Destination Section Code"; Code[10])
        {
            Caption = 'Matching Section Code';
            TableRelation = "NS_Sections".NS_Code WHERE(NS_Type = FIELD("NS_Destination Type"),
                                                        "NS_Activity Code" = FIELD("NS_Destination Activity Code"),
                                                        "NS_Process Code" = FIELD("NS_Destination Process Code"),
                                                        "NS_Operation Code" = field("NS_Destination Operation Code"));
            DataClassification = CustomerContent;
            CaptionClass = '50996,3,0'; //PRJ-1348.NK.1.0 24May2022
            trigger OnValidate()
            begin
                //PRJ-820.JS.1.0�02Aug2021-Start                   
                "NS_Rev. Dest. Task Code" := '';
                NS_CreateSourceTaskCode("NS_Destination Activity Code", "NS_Destination Process Code",
                "NS_Destination Operation Code", "NS_Destination Section Code", "NS_Rev. Dest. Task Code");
                //Message('2...%1..', "NS_Rev. Dest. Task Code");
                //PRJ-820.JS.1.0�02Aug2021-end
            end;
        }

    }

    keys
    {
        key(Key1; NS_Type, "NS_Code", "NS_Source Type", "NS_Source Activity Code", "NS_Source Process Code", "NS_Source Operation Code", "NS_Source Category", "NS_Destination Type", "NS_Destination Activity Code", "NS_Destination Process Code", "NS_Destination Operation Code", "NS_Destination Category")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "NS_Source Type" = "NS_Destination Type" then
            ERROR(Text001_txt);
    end;

    var
        Text001_Txt: Label 'The Source Type can not be the same as the Destination Type.';

    //SMPL Replaced TextConst to Labels (TextConst is deprecated syntax)

    local procedure NS_CreateSourceTaskCode(Activity: Code[10]; Process: Code[10]; Operation: Code[10]; SourSection: Code[10]; var NSLineTaskCode: Code[20])//PRJ-820
    var
        NSJobSetup: Record "Jobs Setup";
    begin
        NSLineTaskCode := '';
        NSJobSetup.Get();
        if Activity > '' then
            NSLineTaskCode := Activity;
        if Process > '' then
            NSLineTaskCode := NSLineTaskCode + NSJobSetup."NS_APO Separators" + Process;
        if Operation > '' then
            NSLineTaskCode := NSLineTaskCode + NSJobSetup."NS_APO Separators" + Operation;
        if SourSection > '' then
            NSLineTaskCode := NSLineTaskCode + NSJobSetup."NS_APO Separators" + SourSection;
    end;

    local procedure NS_CreateDestTaskCode(Activity: Code[10]; Process: Code[10]; Operation: Code[10]; var NSLineTaskCode: Code[20])//PRJ-820
    var
        NSJobSetup: Record "Jobs Setup";
    begin
        NSLineTaskCode := '';
        NSJobSetup.Get();
        if Activity > '' then
            NSLineTaskCode := Activity;
        if Process > '' then
            NSLineTaskCode := NSLineTaskCode + NSJobSetup."NS_APO Separators" + Process;
        if Operation > '' then
            NSLineTaskCode := NSLineTaskCode + NSJobSetup."NS_APO Separators" + Operation;
    end;
}

