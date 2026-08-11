table 14021154 "NS_Job Process"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-449.AS.1.0 19NOV2020 Increased decription length from 30 to 100 chars
    //PRJ-1042.JS.1.0 15Dec2021 | add fields
    //PRJ-917.NK.1.0 09Mar2022 | Add Three fields
    Caption = 'Job Process';
    DrillDownPageID = "NS_Processes List";
    LookupPageID = "NS_Processes List";

    fields
    {
        field(1; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            TableRelation = "NS_Job Activity".NS_Code WHERE(NS_Type = FIELD(NS_Type));
            DataClassification = CustomerContent;
        }
        field(3; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if STRLEN("NS_Activity Code") + STRLEN(NS_code) > 20 then begin
                    MESSAGE(STRSUBSTNO(Text14021400_Txt, FORMAT(20 - STRLEN("NS_Activity Code"))));
                    NS_code := '';
                end;
            end;
        }
        field(4; "NS_Search Code"; Code[10])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(5; NS_Description; Text[100])//PRJ-449.AS.1.0 19NOV2020
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; "NS_Total Cost"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                     "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                     "NS_Process Code" = FIELD(NS_code),
                                                                     "NS_Operation Code" = CONST(''),
                                                                     "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                     "Entry Type" = CONST(Usage),
                                                                     "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Cost';
            FieldClass = FlowField;
        }
        field(8; "NS_Total Price"; Decimal)
        {
            CalcFormula = - Sum("Job Ledger Entry"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                       "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                       "NS_Process Code" = FIELD(NS_code),
                                                                       "NS_Operation Code" = CONST(''),
                                                                       "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                       "Entry Type" = CONST(Sale),
                                                                       "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Price';
            FieldClass = FlowField;
        }
        field(9; "NS_Total Budget Cost"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                      "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                      "NS_Process Code" = FIELD(NS_code),
                                                                      "NS_Operation Code" = CONST(''),
                                                                      "NS_Entry Type" = CONST(Cost),
                                                                      "NS_Cost Category" = FIELD("NS_Cost Category Filter")));
            Caption = 'Total Budget Cost';
            FieldClass = FlowField;
        }
        field(10; "NS_Total Budget Price"; Decimal)
        {
            CalcFormula = - Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                        "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                        "NS_Process Code" = FIELD(NS_code),
                                                                        "NS_Operation Code" = CONST(''),
                                                                        "NS_Entry Type" = CONST(Both),
                                                                        "NS_Cost Category" = FIELD("NS_Revenue Category Filter")));
            Caption = 'Total Budget Price';
            FieldClass = FlowField;
        }
        field(20; "NS_Job No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
        }
        field(21; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(22; "NS_Cost Category Filter"; Code[10])
        {
            Caption = 'Cost Category Filter';
            FieldClass = FlowFilter;
        }
        field(23; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';
            FieldClass = FlowFilter;
        }
        field(30; "NS_Default onto each Job"; Boolean)
        {
            Caption = 'Default onto each Job';
            DataClassification = CustomerContent;
        }
        field(40; "NS_DefaultProjectBurdenPercent"; Decimal)
        {
            Caption = 'Default Project Burden Percent';
            DataClassification = CustomerContent;
        }
        field(41; "NS_DefaultServiceBurdenPercent"; Decimal)
        {
            Caption = 'Default Service Burden Percent';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_DefaultTaskforJobType"; Code[20])
        {
            Caption = 'Default Task for Job Type';
            TableRelation = "NS_Job Type".NS_code;
            DataClassification = CustomerContent;
        }

        //PRJ-1042.JS.1.0 15Dec2021-Start
        field(14021401; "NS_Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
            DataClassification = CustomerContent;
        }
        field(14021402; NS_Totaling; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = CustomerContent;
        }
        //PRJ-1042.JS.1.0 15Dec2021-end
        //PRJ-917.NK.1.0 09Mar2022 Start
        field(14021411; "NS_Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                JobOperation: Record "NS_Job Operation";
                NS_Sections: Record NS_Sections;
            begin
                if UserSetup.Get(UserId) then;
                UserSetup.TestField("NS_Allow To Block APO");
                if NS_Blocked then begin
                    JobOperation.Reset();
                    JobOperation.SetRange("NS_Activity Code", "NS_Activity Code");
                    JobOperation.SetRange("NS_Process Code", NS_Code);
                    if JobOperation.FindFirst() then
                        repeat
                            JobOperation.NS_Blocked := true;
                            JobOperation.Modify();
                            NS_Sections.Reset();
                            NS_Sections.SetRange("NS_Activity Code", Rec."NS_Activity Code");
                            NS_Sections.SetRange("NS_Process Code", Rec.NS_Code);
                            NS_Sections.SetRange("NS_Operation Code", JobOperation.NS_Code);
                            if NS_Sections.FindFirst() then
                                repeat
                                    NS_Sections.NS_Blocked := true;
                                    NS_Sections.Modify();
                                until NS_Sections.Next() = 0;
                        until JobOperation.Next() = 0;
                end else begin
                    JobOperation.Reset();
                    JobOperation.SetRange("NS_Activity Code", "NS_Activity Code");
                    JobOperation.SetRange("NS_Process Code", NS_Code);
                    if JobOperation.FindFirst() then
                        repeat
                            JobOperation.NS_Blocked := false;
                            JobOperation.Modify();
                            NS_Sections.Reset();
                            NS_Sections.SetRange("NS_Activity Code", Rec."NS_Activity Code");
                            NS_Sections.SetRange("NS_Process Code", Rec.NS_Code);
                            NS_Sections.SetRange("NS_Operation Code", JobOperation.NS_Code);
                            if NS_Sections.FindFirst() then
                                repeat
                                    NS_Sections.NS_Blocked := false;
                                    NS_Sections.Modify();
                                until NS_Sections.Next() = 0;
                        until JobOperation.Next() = 0;
                end;
            end;
        }
        field(14021412; "NS_Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021413; "NS_Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-917.NK.1.0 09Mar2022 End

    }

    keys
    {
        key(Key1; NS_Type, "NS_Activity Code", "NS_code")
        {
        }
        key(Key2; "NS_Activity Code", "NS_Search Code")
        {
        }
        key(Key3; "NS_Default onto each Job")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        JobOperation.RESET();
        JobOperation.SETRANGE(NS_Type, NS_Type);
        JobOperation.SETRANGE("NS_Activity Code", "NS_Activity Code");
        JobOperation.SETRANGE("NS_Process Code", NS_code);
        JobOperation.DELETEALL();
    end;

    trigger OnRename();
    begin
        JobOperation.RESET();
        JobOperation.SETRANGE(NS_Type, NS_Type);
        JobOperation.SETRANGE("NS_Activity Code", "NS_Activity Code");
        JobOperation.SETRANGE("NS_Process Code", NS_code);
        if JobOperation.FINDSET() then
            repeat
                JobOperation."NS_Process Code" := NS_code;
                JobOperation.MODIFY();
            until JobOperation.NEXT() = 0;
    end;
    //PRJ-917.NK.1.0 09Mar2022 Start
    trigger OnModify()
    begin
        "NS_Last Modified By" := UserId();
        "NS_Last Modified Date" := WorkDate();
    end;
    //PRJ-917.NK.1.0 09Mar2022 End    
    var
        JobOperation: Record "NS_Job Operation";
        Text14021400_Txt: Label '"You have exceeded the Maximum String Length of 20.\There are a Maximum of %1 Charecters left "', Comment = '%1 = Charactor left';
}

