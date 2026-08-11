tableextension 14021216 NS_JobItemPrice extends "Job Item Price"
{
    // version NAVW110.00,PPNA11.00
    //PRJ-440.AS.1.0 18NOV2020 Added code, commented, Changed also
    //PRJ-440.AM.2.0 02DEC2020 Modified Code to resolve UOM error.
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                IF Item.GET("Item No.") Then begin
                    Description := Item.Description;
                    "Unit Price" := Item."Unit Price";
                    "NS_Unit Cost" := Item."Unit Cost";
                end;

            end;
        }
        field(14021159; NS_Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Item,All;
            OptionCaption = 'Item,All';
            Caption = 'Type';

        }
        field(14021162; "NS_Item No.2"; Code[20])
        {
            TableRelation = if (NS_Type = const(Item)) Item;
            DataClassification = CustomerContent;
            Caption = 'Item No.2';


            trigger OnValidate()
            var
                Item: Record Item;
            begin
                //ProjectPro - start
                //PRJ-440.AM.2.0 Start
                //Item.GET("Item No.");
                //VALIDATE("Unit of Measure Code",Item."Sales Unit of Measure");
                //IF NS_Type = NS_Type::Item THEN BEGIN //PRJ-440.AS.1.0 18NOV2020 Commented code

                //PRJ-440 comment //IF (NS_Type = NS_Type::Item) and ("NS_Item No.2" <> '') THEN BEGIN//PRJ-440.AS.1.0 18NOV2020 Added code
                //PRJ-440 comment  //Item.GET("NS_Item No.2");//PRJ-440.AS.1.0 18NOV2020 Added code
                //PRJ-440.AM.2.0 End

                Description := Item.Description;
                "Unit Price" := Item."Unit Price";
                "NS_Unit Cost" := Item."Unit Cost";

                //PRJ-440.AM.2.0 Start
                //VALIDATE("Unit of Measure Code", Item."Base Unit of Measure");//PRJ-440.AM.2.0 02DEC2020 commented code
                //PRJ-440 comment //ItemRec2 := Rec;//PRJ-440.AM.2.0

                //PRJ-440 comment //ItemRec2.Rename("Job No.", "Job Task No.", "NS_Item No.2", "Variant Code", Item."Base Unit of Measure", "Currency Code");//PRJ-440.AM.2.0 02DEC2020

                //"Item No." := "NS_Item No.2";//PRJ-440.AS.1.0 18NOV2020 Added code ////PRJ-440.AM.2.0 02DEC2020 Commented Code


                //SPLN 1.0 Start
                // Validate("Item No.");//PRJ-440.AS.1.0 18NOV2020 Commented code
                //SPLN 1.0 End
                //END;//PRJ-440 comment
                //ProjectPro - end
                //PRJ-440.AM.2.0 End
            end;
        }

        modify("Unit Price")
        {
            trigger OnBeforeValidate();
            begin
                //SPLN 1.0 Start
                NS_UnitCostFactor := "Unit Cost Factor";
                //SPLN 1.0 End

                //ProjectPro - start
                if "NS_Unit Cost" <> 0 then
                    VALIDATE("Unit Cost Factor", "Unit Price" / "NS_Unit Cost")
                else
                    VALIDATE("Unit Cost Factor", 0);
                //ProjectPro - end
            end;

            trigger OnAfterValidate()
            begin
                //SPLN 1.0 Start
                "Unit Cost Factor" := NS_UnitCostFactor;
                //SPLN 1.0 End
            end;
        }


        modify("Unit Cost Factor")
        {
            trigger OnBeforeValidate();
            begin
                "Unit Price" := 0;
                //ProjectPro - start
                NS_GLSetup.GET;
                if "NS_Unit Cost" <> 0 then
                    if "Unit Cost Factor" <> 0 then
                        "Unit Price" := ROUND("NS_Unit Cost" * "Unit Cost Factor", NS_GLSetup."Amount Rounding Precision");
                if ("NS_Unit Cost" <> 0) and ("Unit Price" <> 0) then
                    "NS_Markup %" := ROUND(100 * ("Unit Price" / "NS_Unit Cost" - 1), NS_GLSetup."Amount Rounding Precision")
                else
                    "NS_Markup %" := 0;
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

    trigger OnBeforeInsert()
    begin
        //SPLN 1.0 Start
        //PRJ-440.AM.2.0 start
        // NS_ItemNo := "NS_Item No.2";//PRJ-440.AS.1.0 18NOV2020 Item No. to ItemNo.2
        //"Item No." := '1';
        // "Item No." := '1500'; //PRJ-440 comment
        //PRJ-440.AM.2.0 End
        //SPLN 1.0 End
    end;

    trigger OnInsert()

    begin
        //SPLN 1.0 Start
        //PRJ-440.AM.2.0 Start
        //ItemRec2 := Rec;//PRJ-440.AM.2.0
        //ItemRec2.Rename("Job No.", "Job Task No.", NS_ItemNo, "Variant Code", "Unit of Measure Code", "Currency Code");//PRJ-440.AM.2.0
        //"Item No." := NS_ItemNo;//PRJ-440.AM.2.0 commented
        //"NS_Item No.2" := NS_ItemNo; //PRJ-440.AS.1.0 18NOV2020 Added
        //SPLN 1.0 End

        //ProjectPro - start
        //  TESTFIELD("Item No.");
        // IF NS_Type = NS_Type::Item THEN //PRJ-440.AS.1.0 18NOV2020 Code Commented
        //     TESTFIELD("Item No."); //PRJ-440.AS.1.0 18NOV2020 Code Commented
        //PRJ-440.AM.2.0 End
        NS_UpdateWorkOrder(Rec);
        //ProjectPro - end
    end;


    trigger OnModify()
    begin
        //ProjectPro - start
        //PRJ-440.AM.2.0 Start
        //  IF NS_Type = NS_Type::Item THEN
        //    TESTFIELD("NS_Item No.2");//PRJ-440.AS.1.0 18NOV2020 Item No. to ItemNo.2
        //PRJ-440.AM.2.0 End

        NS_UpdateWorkOrder(Rec);
        //ProjectPro - end
    end;

    LOCAL PROCEDURE NS_UpdateWorkOrder(PassItemPrice: Record 1013);
    VAR
        WOItemPrice: Record 1013;
        WOJob: Record 167;
    BEGIN
        WOJob.RESET;
        WOJob.SETRANGE("NS_Sub-Level to Job No.", PassItemPrice."Job No.");
        //Filter to exclude work orders that are approved
        IF WOJob.FINDSET THEN
            REPEAT
                IF WOItemPrice.GET(WOJob."No.", PassItemPrice."Job Task No.", PassItemPrice."Item No.",//PRJ-440.AS.1.0 18NOV2020 Old Code
                                                                                                       //PRJ-440 comment //IF WOItemPrice.GET(WOJob."No.", PassItemPrice."Job Task No.", PassItemPrice."NS_Item No.2",//PRJ-440.AS.1.0 18NOV2020 Changed ItemNo. to ItemNo.2
                                     PassItemPrice."Variant Code", PassItemPrice."Unit of Measure Code",
                                     PassItemPrice."Currency Code") THEN BEGIN//PRJ-440.AM.2.0 Removed Type From PK Fields
                    WOItemPrice."Unit Price" := PassItemPrice."Unit Price";
                    WOItemPrice."Unit Cost Factor" := PassItemPrice."Unit Cost Factor";
                    WOItemPrice."Line Discount %" := PassItemPrice."Line Discount %";
                    WOItemPrice."NS_Unit Cost" := PassItemPrice."NS_Unit Cost";
                    WOItemPrice.VALIDATE("NS_Markup %", PassItemPrice."NS_Markup %");
                    // WOItemPrice."Item No." := PassItemPrice."NS_Item No.2";//PRJ-440.AS.1.0 18NOV2020 Added code //PRJ-440.AM.2.0 Commented code
                    WOItemPrice.MODIFY;
                end;
            // END ELSE BEGIN //PRJ-440.AM.2.0 comment start
            //     WOItemPrice.RESET;
            //     WOItemPrice := PassItemPrice;
            //     WOItemPrice."Job No." := WOJob."No.";
            //     //WOItemPrice."Item No." := PassItemPrice."NS_Item No.2";//PRJ-440.AS.1.0 18NOV2020 Added code
            //     WOItemPrice.INSERT;
            // END; //PRJ-440.AM.2.0 comment End
            UNTIL WOJob.NEXT = 0;
    END;

    var
        NS_GLSetup: Record "General Ledger Setup";
        NS_ItemNo: Code[35];

        NS_UnitCostFactor: Decimal;
        ItemRec2: Record "Job Item Price";
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021152 Unit Cost
//   +     14021159 Type
//   +     14021160 Markup %
//   +
//   +  - Added function(s):
//   +     UpdateWorkOrder
//   +
//   +  - Added global variable(s):
//   +     PP_GLSetup
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - Modify Keys:
//   +           Original: Job No.,Job Task No.,Item No.,Variant Code,Unit of Measure Code,Currency Code
//   +           Modified: Job No.,Job Task No.,Item No.,Variant Code,Unit of Measure Code,Currency Code,Type
//   +     - OnInsert: - Item No. required when Type=Type::Item
//   +                 - Call to UpdateWorkOrder
//   +     - OnModify: - Item No. required when Type=Type::Item
//   +                 - Call to UpdateWorkOrder
//   +     - Fields:
//   +         Job Task No.:     - Increased to 35 long
//   +         Item No.:         - Modified TableRelation
//   +                           - OnValidate - only get Item record when Type is Item
//   +                                        - Set fields from Item table
//   +                                                Description
//   +                                                Unit Price
//   +                                                Unit Cost
//   +         Unit Cost Factor: - OnValidate - assign field values
//   +                                                Unit Price
//   +                                                Markup %
//   +-----------------------------------------------------------------------------------------------