tableextension 14021107 NS_Item extends Item
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks  Custmization for Twinoaks
    //PRJ-1335.NK.1.0 02May2022 Add One Field.
    fields
    {
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Cost Category";
        }
        //PRJ-568.AS.1.0 - START
        field(14021102; "NS_Linked Resource"; Code[20])
        {
            CaptionML = ENU = 'Linked Resource',
                        ENC = 'Linked Resource';
            Description = 'Linked Resource';
            TableRelation = Resource."No.";
            DataClassification = CustomerContent;
        }
        //PRJ-568.AS.1.0 - END
        field(14021400; "NS_Parent Item No."; Code[20])
        {
            Caption = 'Attached Item No.';
            Description = 'Project Pro';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(14021401; "Ns_Parent Item UOM"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            Description = 'Project Pro';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_Parent Item No."));
        }
        field(14021402; "NS_Quantity Per Parent Item"; Decimal)
        {
            Caption = 'Quantity Per';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'Project Pro';
            InitValue = 1;
        }
        field(14021403; "NS_Parent Item Description"; Text[50])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("NS_Parent Item No.")));
            Caption = 'Description';
            Description = 'Project Pro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021404; "NS_Quoting Item"; Boolean)
        {
            Caption = 'Quoting Item';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_JMP Manufacturer"; Text[50])
        {
            Caption = 'JMP Manufacturer';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021406; NS_Size; Decimal)
        {
            Caption = 'Size';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                CalcWeldTime;
                //ProjectPro - end
            end;
        }
        field(14021407; "NS_No. of Welds"; Decimal)
        {
            Caption = 'No. of Welds';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                CalcWeldTime;
                //ProjectPro - end
            end;
        }
        field(14021408; "NS_Weld Estimate Code"; Code[10])
        {
            Caption = 'Weld Estimate Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                CalcWeldTime;
                //ProjectPro - end
            end;
        }
        field(14021409; "NS_Labor Hours per Weld"; Decimal)
        {
            Caption = 'Labor Hours per Weld';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Labor Hours per Qty."; Decimal)
        {
            Caption = 'Labor Hours per Qty.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4; //PRJ-1075.GK.1.0 13Dec2021
        }
        field(14021411; NS_Manufacturer; Text[50])
        {
            Caption = 'Manufacturer';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021412; "NS_Qty. on Job Journals"; Decimal)
        {
            CalcFormula = Sum ("Job Journal Line".Quantity WHERE(Type = FILTER(Item),
                                                                 "No." = FIELD("No."),
                                                                 NS_Staged = FILTER(false)));
            Caption = 'Qty. on Job Journals';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
        field(14021413; "NS_Quote Costs"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Costs';
            trigger OnValidate()
            begin
                Rec."NS_Quote Costs Modified Date" := Today;
            end;
        }
        field(14021414; "NS_Quote Costs Modified Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Costs Modified Date';
            Editable = false;
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
        //PRJ-1335.NK.1.0 02May2022 Start
        field(14021415; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        //PRJ-1335.NK.1.0 02May2022 End
    }

    trigger OnBeforeInsert()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        InvtSetup: Record "Inventory Setup";
    begin
        IF "No." = '' THEN
            IF DocumentNoVisibility.ItemNoSeriesIsDefault THEN BEGIN
                InvtSetup.Get();
                //ProjectPro - end
                NoSeriesMgt.InitSeries(InvtSetup."Item Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                "Costing Method" := InvtSetup."Default Costing Method";
            END;

    end;

    PROCEDURE CalcWeldTime();
    VAR
        WeldMatrix: Record "NS_Job Takeoff Segments";
    BEGIN
        //ProjectPro - start
        IF NS_Size = 0 THEN BEGIN
            "NS_Labor Hours per Weld" := 0;
            "NS_Labor Hours per Qty." := 0;
            EXIT;
        END;

        WeldMatrix.SETRANGE(NS_Type, WeldMatrix.NS_Type::Welding);
        ;
        WeldMatrix.SETRANGE("NS_Size of Weld", NS_Size);
        IF WeldMatrix.FINDFIRST THEN
            "NS_Labor Hours per Weld" := WeldMatrix."NS_Weld Time (Hours)";

        "NS_Labor Hours per Qty." := ROUND("NS_Labor Hours per Weld" * "NS_No. of Welds", 0.01);

        //ProjectPro - end
    END;
    /*+------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category
      +     14021400 Parent Item No.
      +     14021401 Parent Item UOM
      +     14021402 Quantity per Parent Item
      +     14021403 Parent Item Description
      +     14021404 Quoting Item
      +     14021405 JMP Manufacturer
      +     14021406 Size
      +     14021407 No. of Welds
      +     14021408 Weld Estimate Code
      +     14021409 Labor Hours per Weld
      +     14021410 Labor Hours per Qty.
      +     14021411 Manufacturer
      +     14021412 Qty. on Job Journals
      +
      +  - Added function(s):
      +      CalcWeldTime
      +
      +  - Added global variable(s)
      +
      +  - Modification(s):
      +------------------------------------------------------------*/

}

