table 14021156 NS_Sections
{
    //PRJ-688.AM.1.0 Created New table .
    //PRJ-917.NK.1.0 09Mar2022 | Add Three fields
    Caption = 'Sections';
    DrillDownPageId = NS_SectionsList;
    LookupPageId = NS_SectionsList;

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
        field(4; "NS_Operation Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Operation Code';
            TableRelation = "NS_Job Operation".NS_Code where(NS_Type = field(NS_Type),
            "NS_Activity Code" = field("NS_Activity Code"), "NS_Process Code" = field("NS_Process Code"));
        }
        field(5; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if STRLEN("NS_Activity Code") + STRLEN("NS_Process Code") + StrLen("NS_Operation Code") + STRLEN(NS_Code) > 20 then begin
                    MESSAGE(STRSUBSTNO(Text14021400_Txt, FORMAT(20 - STRLEN("NS_Activity Code") - STRLEN("NS_Process Code") - StrLen("NS_Operation Code"))));
                    NS_Code := '';
                end;
            end;
        }
        field(6; "NS_Search Code"; Code[10])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(7; NS_Description; Text[100])
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
        //PRJ-917.NK.1.0 09Mar2022 Start
        field(14021411; "NS_Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get(UserId) then;
                UserSetup.TestField("NS_Allow To Block APO");
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
        key(Key1; NS_Type, "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Code")
        {
        }
        key(Key2; "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Search Code")
        {
        }
        key(Key3; "NS_Default onto each Job")
        {
        }
    }

    fieldgroups
    {
    }
    //PRJ-917.NK.1.0 09Mar2022 Start
    trigger OnModify()
    begin
        "NS_Last Modified By" := UserId();
        "NS_Last Modified Date" := WorkDate();
    end;
    //PRJ-917.NK.1.0 09Mar2022 End 

    var
        Text14021400_Txt: Label '"You have exceeded the Maximum String Length of 20.\There are a Maximum of %1 Charecters left "', Comment = '%1 = Charactor length';
}

