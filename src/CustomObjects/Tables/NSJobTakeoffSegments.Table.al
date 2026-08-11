table 14021400 "NS_Job Takeoff Segments"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //TM-10.AM.1.0 24NOV2020 | Added new fields in table.
    //PRJ-1312.NK.1.0 03May2022 | Add Code
    Caption = 'Job Takeoff Segments';
    DataCaptionFields = "NS_Segment Code", "NS_Segment Name";
    LookupPageID = "NS_Drawing Segment";

    fields
    {
        field(5; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Drawing,Welding,Template';
            OptionMembers = Drawing,Welding,Template;
            DataClassification = CustomerContent;

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


            trigger OnValidate();
            begin
                if "NS_Mark-up" <> xRec."NS_Mark-up" then
                    QuoteMgt.NS_CalcSegmentAmounts(Rec, xRec, 0);

            end;
        }
        field(140; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            DataClassification = CustomerContent;


            trigger OnValidate();
            begin
                if "NS_Gross Profit" <> xRec."NS_Gross Profit" then
                    QuoteMgt.NS_CalcSegmentAmounts(Rec, xRec, 1);

            end;
        }
        field(150; "NS_Gross Profit Percent"; Decimal)
        {
            Caption = 'Gross Profit Percent';
            DataClassification = CustomerContent;


            trigger OnValidate();
            begin
                if "NS_Gross Profit Percent" <> xRec."NS_Gross Profit Percent" then
                    QuoteMgt.NS_CalcSegmentAmounts(Rec, xRec, 2);

            end;
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


            trigger OnValidate();
            var
                TJobTakOff: Record "NS_Job Takeoff Segments";
                JobQuoteHead: Record "NS_Job Quote Header";
                TotalPrice: Decimal;
            begin
                Testfield("NS_Freeze Total Contract Price", false);   //PRJCTPR-319.JS.1.0
                if "NS_Total Contract Price" <> xRec."NS_Total Contract Price" then begin
                    QuoteMgt.NS_CalcSegmentAmounts(Rec, xRec, 3);
                    //PRJ-1312.NK.1.0 03May2022 Start
                    TotalPrice := 0;
                    TJobTakOff.Reset();
                    TJobTakOff.SetRange("NS_Job No.", Rec."NS_Job No.");
                    TJobTakOff.CalcSums("NS_Total Contract Price");
                    TotalPrice += TJobTakOff."NS_Total Contract Price";
                    if TotalPrice <> 0 then begin
                        JobQuoteHead.Reset();
                        JobQuoteHead.SetRange("NS_Quote No.", Rec."NS_Job No.");
                        if JobQuoteHead.FindFirst() then begin
                            JobQuoteHead."NS_Total Contract Price" := TotalPrice;
                            JobQuoteHead.Modify();
                        end;
                    end;
                    //PRJ-1312.NK.1.0 03May2022 End
                end;
            end;
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
        //TM-10.AM.1.0 24NOV2020 Start
        field(165; "NS_Segment Description"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Segment Description';
        }
        field(166; "NS_Billing Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Type';
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
        }
        field(167; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(168; "NS_Estimated Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Estimated Quantity';
            trigger OnValidate()
            var
            begin
                "NS_Total Cost" := "NS_Estimated Quantity" * "NS_Unit Rate";

            end;
        }
        field(169; "NS_Unit Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Caption = 'Unit Rate';
            trigger OnValidate()
            var
            begin
                "NS_Total Cost" := "NS_Estimated Quantity" * "NS_Unit Rate";
            end;

        }
        field(170; "NS_Total Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Cost';
            Editable = false;
        }

        //PRJCTPR-319.JS.1.0 07MAR2024 - Start
        field(171; "NS_Freeze Total Contract Price"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Freeze Total Contract Price';

            trigger OnValidate()
            begin
                if "NS_Freeze Total Contract Price" = true then begin
                    rec.TestField("NS_Segment Code");
                    rec.TestField("NS_Total Contract Price");
                end;
            end;

        }
        //PRJCTPR-319.JS.1.0 07MAR2024 - end       
        //TM-10.AM.1.0 24NOV2020 End

        //PPRJ-774.AS.1.0 07JULY2021 - Start Commented to Remove
        // field(171; NS_Revision; Integer)//PPRJ-774.AS.1.0 Added this field as it was not in Archivequotesegments table
        // {
        //     DataClassification = CustomerContent;

        // }
        //PPRJ-774.AS.1.0 07JULY2021 - End Commented to Remove
    }

    keys
    {
        key(Key1; NS_Type, "NS_Job No.", "NS_Segment Code", "NS_Size of Weld")
        {
        }
        key(key2; "NS_Total Contract Price")//PRJ-1155.AS.1.0 Added Key
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Segment Code", "NS_Segment Name")
        {
        }
    }

    trigger OnDelete();
    var
        JobPlanningLine: Record "Job Planning Line";
        JobQuoteHeader: Record "NS_Job Quote Header";
    begin

        if "NS_Is Total" then
            ERROR(Text001Lbl);
        //PRJ-1312.NK.1.0 03May2022 start
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", Rec."NS_Job No.");
        JobPlanningLine.SetRange("NS_Segment Code", Rec."NS_Segment Code");
        if JobPlanningLine.FindFirst() then
            repeat
                JobPlanningLine.Validate("NS_Segment Code", '');
                JobPlanningLine.Modify();
            until JobPlanningLine.Next() = 0;
        //PRJ-1312.NK.1.0 03May2022 end
    end;

    trigger OnInsert();
    begin

        if "NS_Is Total" then
            ERROR(Text001Lbl);

        if "NS_Segment Code" = '' then
            ERROR(Text003Lbl);

        if "NS_Segment Code" = 'TOTAL' then
            ERROR(Text004Lbl);

        if "NS_Segment Code" = 'NA' then
            ERROR(Text005Lbl);
    end;

    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";

        Text001Lbl: Label 'You may not manually insert/delete a totaling field.';
        Text003Lbl: Label 'Blank Drawing Codes are not allowed.';
        Text004Lbl: Label 'Drawing code TOTAL is reserved and not allowed.';
        Text005Lbl: Label 'Drawing code NA is reserved and not allowed.';
}

