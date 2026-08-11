table 14021433 "NS_Archived Quote Segments"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0�18June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    Caption = 'Job Takeoff Segments';
    DataCaptionFields = "NS_Segment Code", "NS_Segment Name";
    LookupPageID = "NS_Drawing Segment";

    fields
    {
        field(5; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Drawing,Welding,Template';
            OptionMembers = Drawing,Welding,Template;
        }
        field(10; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Is Total"; Boolean)
        {
            Caption = 'Is Total';
            DataClassification = CustomerContent;
        }
        field(50; "NS_Size of Weld"; Decimal)
        {
            Caption = 'Size of Weld';
            DataClassification = CustomerContent;
        }
        field(60; "NS_Weld Time (Hours)"; Decimal)
        {
            Caption = 'Weld Time (Hours)';
            DataClassification = CustomerContent;
        }
        field(70; NS_Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = CustomerContent;
        }
        field(80; "NS_Schedule (Total Cost)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                            "NS_Segment Code" = FIELD("NS_Segment Code"),
                                                                            "Schedule Line" = CONST(true)));
            Caption = 'Schedule (Total Cost)';
            FieldClass = FlowField;
        }
        field(90; "NS_Schedule (Total Price)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                             "NS_Segment Code" = FIELD("NS_Segment Code"),
                                                                             "Schedule Line" = CONST(true)));
            Caption = 'Schedule (Total Price)';
            FieldClass = FlowField;
        }
        field(100; "NS_Remaining (Total Cost)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Remaining Total Cost (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                      "NS_Segment Code" = FIELD("NS_Segment Code"),
                                                                                      "Schedule Line" = CONST(true)));
            Caption = 'Remaining (Total Cost)';
            FieldClass = FlowField;
        }
        field(110; "NS_Remaining (Total Price)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Remaining Line Amount (LCY)" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                       "NS_Segment Code" = FIELD("NS_Segment Code"),
                                                                                       "Schedule Line" = CONST(true)));
            Caption = 'Remaining (Total Price)';
            FieldClass = FlowField;
        }
        field(120; "NS_Amt. Rcd. Not Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                      "Job No." = FIELD("NS_Job No.")));
            Caption = 'Amt. Rcd. Not Invoiced';
            FieldClass = FlowField;
        }
        field(130; "NS_Mark-up"; Decimal)
        {
            Caption = 'Mark-up';
            DataClassification = CustomerContent;
        }
        field(140; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            DataClassification = CustomerContent;
        }
        field(150; "NS_Gross Profit Percent"; Decimal)
        {
            Caption = 'Gross Profit Percent';
            DataClassification = CustomerContent;
        }
        field(160; "NS_Line Amount Incl. Tax"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."NS_Line Amount Incl. Tax" WHERE("Job No." = FIELD("NS_Job No."),
                                                                                 "NS_Segment Code" = FIELD("NS_Segment Code"),
                                                                                 "Schedule Line" = CONST(true)));
            Caption = 'Line Amount Incl. Tax';
            FieldClass = FlowField;
        }
        field(161; "NS_Total Contract Price"; Decimal)
        {
            Caption = 'Total Contract Price';
            DataClassification = CustomerContent;
        }
        field(162; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            DataClassification = CustomerContent;
        }
        field(163; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;
        }
        field(164; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(165; NS_Revision; Integer)//PPRJ-774.AS.1.0 Rollback old id to 165 of field NS_Revision
        {
            Caption = 'Revision';//PRJ-659.RS.1.0�18June21 New Added
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; NS_Type, "NS_Job No.", "NS_Segment Code", "NS_Size of Weld", NS_Revision)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Segment Code", "NS_Segment Name")
        {
        }
    }
}

