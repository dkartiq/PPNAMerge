tableextension 14021215 NS_JobResourcePrice extends "Job Resource Price"
{
    // version NAVW19.00,PPNA11.00
    //PRJ-152 VT 09-03-20 Table relation Added
    //PRJ-158/159 VT 02-04-20 Code  Code added and Commented as Skill Class is not the part of Key
    //PRJ-464.AM.1.0 23NOV2020 | Created a New field and code .
    fields
    {
        field(14021100; "NS_Skill Class Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "NS_Skill Class";//PRJ-152 VT 09-03-20
            Caption = 'Skill Class';

        }
        //PRJ-464.AM.1.0 Start
        field(14021103; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        //PRJ-464.AM.1.0 End

        modify(Code)
        {
            trigger OnAfterValidate();
            var
                Res: Record 156;
                ResGrp: Record 152;
            begin
                CASE Type OF
                    Type::Resource:
                        BEGIN
                            Res.GET(Code);
                            //ProjectPro - start
                            "NS_Unit Cost" := Res."Unit Cost";
                            "Unit Price" := Res."Unit Price";
                            "NS_Unit of Measure Code" := Res."Base Unit of Measure";//PRJ-464.AM.1.0
                            //ProjectPro - end
                        END;
                    Type::"Group(Resource)":
                        BEGIN
                            ResGrp.GET(Code);
                            //ProjectPro - start
                            "NS_Unit Cost" := ResGrp."Sales (Cost)";
                            "Unit Price" := ResGrp."Sales (Price)";
                            //ProjectPro - end
                        END;
                END;
            end;
        }

        modify("Unit Price")
        {
            trigger OnBeforeValidate();
            begin
                TempUnitCostFactor := "Unit Cost Factor";
            end;

            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if ("NS_Unit Cost" <> 0) and ("NS_Markup %" <> 0) then//PRJ-152 VT 11-03-20 begin
                    IF TempUnitCostFactor <> 0 THEN
                        VALIDATE("Unit Cost Factor", "Unit Price" / "NS_Unit Cost")
                    ELSE
                        VALIDATE("Unit Cost Factor", 0);
                //ProjectPro - end                   
            end;
        }

        modify("Unit Cost Factor")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_GLSetup.GET;
                IF "NS_Unit Cost" <> 0 THEN
                    IF "Unit Cost Factor" <> 0 THEN
                        "Unit Price" := ROUND("NS_Unit Cost" * "Unit Cost Factor", NS_GLSetup."Amount Rounding Precision");
                IF ("NS_Unit Cost" <> 0) AND ("Unit Price" <> 0) THEN
                    "NS_Markup %" := ROUND(100 * ("Unit Price" / "NS_Unit Cost" - 1), NS_GLSetup."Amount Rounding Precision")
                ELSE
                    "NS_Markup %" := 0;
                //ProjectPro - end
            end;
        }
        field(14021101; "NS_Skill Rate"; Decimal)
        {
            Caption = 'Skill Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Fringe Rate"; Decimal)
        {
            Caption = 'Fringe Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Cost Type"; Option)
        {
            Caption = 'Cost Type';
            Description = 'ProjectPro';
            OptionCaption = 'Fixed,% Extra,LCY Extra';
            OptionMembers = "Fixed","% Extra","LCY Extra";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "Work Type Code" = '' then
                    Rec.TESTFIELD("NS_Cost Type", "NS_Cost Type"::Fixed);
                //ProjectPro - end
            end;
        }
        field(14021151; "NS_Cost Burden Multiplier"; Decimal)
        {
            Caption = 'Cost Burden Multiplier';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Text14021100: Label 'Job Burden Multiplier must be 1.00\because burden is applied through payroll rather than in the time journal.';
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                if not NS_JobsSetup."NS_Post Labor Burden RateToJob" then
                    if "NS_Cost Burden Multiplier" <> 1 then
                        ERROR(Text14021100);
                //ProjectPro - end
            end;
        }
        field(14021152; "NS_Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_GLSetup.GET;
                if "NS_Unit Cost" <> 0 then
                    if "Unit Cost Factor" <> 0 then
                        "Unit Price" := ROUND("NS_Unit Cost" * "Unit Cost Factor", NS_GLSetup."Amount Rounding Precision")
                    else
                        "Unit Price" := ROUND("NS_Unit Cost", NS_GLSetup."Amount Rounding Precision");
                //ProjectPro - end
            end;
        }
        field(14021160; "NS_Markup %"; Decimal)
        {
            Caption = 'Markup %';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                VALIDATE("Unit Cost Factor", 1 + ("NS_Markup %" / 100));
                //ProjectPro - end
            end;
        }
    }

    trigger OnInsert();
    begin
        //ProjectPro - start
        NS_UpdateWorkOrder(Rec);
        //ProjectPro - end
    end;


    trigger OnModify();
    begin
        //ProjectPro - start
        NS_UpdateWorkOrder(Rec);
        //ProjectPro - end
    end;

    LOCAL PROCEDURE NS_UpdateWorkOrder(PassRecPrice: Record 1012);
    VAR
        WORecPrice: Record 1012;
        WOJob: Record 167;
    BEGIN
        WOJob.RESET;
        WOJob.SETRANGE("NS_Sub-Level to Job No.", PassRecPrice."Job No.");
        //Filter to exclude work orders that are approved
        IF WOJob.FINDSET THEN
            REPEAT
                //PRJ-158/159 VT 02-04-20 Code 
                //IF WORecPrice.GET(WOJob."No.", PassRecPrice."Job Task No.", PassRecPrice.Type, PassRecPrice.Code, PassRecPrice."Work Type Code", PassRecPrice."Skill Class Code", PassRecPrice."Currency Code") THEN BEGIN
                IF WORecPrice.GET(WOJob."No.", PassRecPrice."Job Task No.", PassRecPrice.Type, PassRecPrice.Code, PassRecPrice."Work Type Code", PassRecPrice."Currency Code") THEN BEGIN
                    WORecPrice."Unit Price" := PassRecPrice."Unit Price";
                    WORecPrice."Unit Cost Factor" := PassRecPrice."Unit Cost Factor";
                    WORecPrice."Line Discount %" := PassRecPrice."Line Discount %";
                    WORecPrice."NS_Skill Rate" := PassRecPrice."NS_Skill Rate";
                    WORecPrice."NS_Fringe Rate" := PassRecPrice."NS_Fringe Rate";
                    WORecPrice."NS_Cost Burden Multiplier" := PassRecPrice."NS_Cost Burden Multiplier";
                    WORecPrice."NS_Unit Cost" := PassRecPrice."NS_Unit Cost";
                    WORecPrice.VALIDATE("NS_Markup %", PassRecPrice."NS_Markup %");
                    WORecPrice.MODIFY;
                END ELSE BEGIN
                    WORecPrice.RESET;
                    WORecPrice := PassRecPrice;
                    WORecPrice."Job No." := WOJob."No.";
                    WORecPrice.INSERT;
                END;
            UNTIL WOJob.NEXT = 0;
    END;

    var
        TempUnitCostFactor: Decimal;
        NS_JobsSetup: Record "Jobs Setup";
        NS_GLSetup: Record "General Ledger Setup";
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Skill Class Code
//   +     14021101 Skill Rate
//   +     14021102 Fringe Rate
//   +     14021150 Cost Type
//   +     14021151 Cost Burden Multiplier
//   +     14021152 Unit Cost
//   +     14021160 Markup %
//   +
//   +  - Added function(s):
//   +     UpdateWorkOrder
//   +
//   +  - Added global variable(s):
//   +     PP_JobsSetup
//   +     PP_GLSetup
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - Added Keys:
//   +        Job No.,Job Task No.,Skill Class Code,Type,Code,Work Type Code,Currency Code
//   +     - Modify Keys:
//   +         Original: Job No.,Job Task No.,Type,Code,Work Type Code,Currency Code
//   +         Modified: Job No.,Job Task No.,Type,Code,Work Type Code,Skill Class Code,Currency Code
//   +     - OnInsert: Call to UpdateWorkOrder
//   +     - OnModify: Call to UpdateWorkOrder
//   +     - Fields:
//   +         Code              - OnValidate - Get values from Resource table
//   +                                                Unit Cost
//   +                                                Unit Price
//   +         Unit Price        - OnValidate - Set value for Unit Cost Factor
//   +         Unit Cost Factor  - OnValidate - Set value for Unit Price
//   +                                        - Set value for Markup %
//   +
//   +-----------------------------------------------------------------------------------------------