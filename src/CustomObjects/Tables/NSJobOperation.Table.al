table 14021155 "NS_Job Operation"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-449.AS.1.0 19NOV2020 Increased decription length from 30 to 100 chars

    Caption = 'Job Operation';
    DrillDownPageID = "NS_Operations List";
    LookupPageID = "NS_Operations List";

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
        field(3; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            TableRelation = "NS_Job Process".NS_Code WHERE(NS_Type = FIELD(NS_Type),
                                                      "NS_Activity Code" = FIELD("NS_Activity Code"));
            DataClassification = CustomerContent;
        }
        field(4; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if STRLEN("NS_Activity Code") + STRLEN("NS_Process Code") + STRLEN(NS_Code) > 20 then begin
                    MESSAGE(STRSUBSTNO(Text14021400_Txt, FORMAT(20 - STRLEN("NS_Activity Code") - STRLEN("NS_Process Code"))));
                    NS_Code := '';
                end;
            end;
        }
        field(5; "NS_Search Code"; Code[10])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(6; NS_Description; Text[100])//PRJ-449.AS.1.0 19NOV2020
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "NS_Total Cost"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                     "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                     "NS_Process Code" = FIELD("NS_Process Code"),
                                                                     "NS_Operation Code" = FIELD(NS_Code),
                                                                     "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                     "Entry Type" = CONST(Usage),
                                                                     "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Cost';
            FieldClass = FlowField;
        }
        field(9; "NS_Total Price"; Decimal)
        {
            CalcFormula = - Sum("Job Ledger Entry"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                       "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                       "NS_Process Code" = FIELD("NS_Process Code"),
                                                                       "NS_Operation Code" = FIELD(NS_Code),
                                                                       "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                       "Entry Type" = CONST(Sale),
                                                                       "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Price';
            FieldClass = FlowField;
        }
        field(10; "NS_Total Budget Cost"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                      "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                      "NS_Process Code" = FIELD("NS_Process Code"),
                                                                      "NS_Operation Code" = FIELD(NS_Code),
                                                                      "NS_Entry Type" = CONST(Cost),
                                                                      "NS_Cost Category" = FIELD("NS_Cost Category Filter")));
            Caption = 'Total Budget Cost';
            FieldClass = FlowField;
        }
        field(11; "NS_Total Budget Price"; Decimal)
        {
            CalcFormula = - Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                        "NS_Activity Code" = FIELD("NS_Activity Code"),
                                                                        "NS_Process Code" = FIELD("NS_Process Code"),
                                                                        "NS_Operation Code" = FIELD(NS_Code),
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
            TableRelation = "NS_Job Type".NS_Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; NS_Type, "NS_Activity Code", "NS_Process Code", "NS_Code")
        {
        }
        key(Key2; "NS_Activity Code", "NS_Process Code", "NS_Search Code")
        {
        }
        key(Key3; "NS_Default onto each Job")
        {
        }
    }

    fieldgroups
    {
    }

    //PRJ-688.AM.1.0 Start
    trigger OnDelete();
    begin
        JobSections.RESET();
        JobSections.SETRANGE(NS_Type, NS_Type);
        JobSections.SETRANGE("NS_Activity Code", "NS_Activity Code");
        JobSections.SETRANGE("NS_Process Code", "NS_Process Code");
        JobSections.SetRange("NS_Operation Code", NS_Code);
        JobSections.DELETEALL();
    end;

    trigger OnRename();
    begin
        JobSections.RESET();
        JobSections.SETRANGE(NS_Type, NS_Type);
        JobSections.SETRANGE("NS_Activity Code", "NS_Activity Code");
        JobSections.SetRange("NS_Process Code", "NS_Process Code");
        JobSections.SETRANGE("NS_Operation Code", NS_code);
        if JobSections.FINDSET() then
            repeat
                JobSections."NS_Operation Code" := NS_code;
                JobSections.MODIFY();
            until JobSections.NEXT() = 0;
    end;
    //PRJ-688.AM.1.0 End

    var
        JobSections: Record NS_Sections;//PRJ-688.AM.1.0
        Text14021400_Txt: Label '"You have exceeded the Maximum String Length of 20.\There are a Maximum of %1 Charecters left "', Comment = '%1 = Charactor length';
}

