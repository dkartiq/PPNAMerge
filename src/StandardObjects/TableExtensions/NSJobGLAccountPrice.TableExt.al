tableextension 14021217 NS_JobGLAccountPrice extends "Job G/L Account Price"
{
    // version NAVW19.00,PPNA11.00
    //PRJ-209 VT1.0 13-04-20 Code Added
    fields
    {
        modify("Unit Price")
        {
            trigger OnBeforeValidate()

            begin
                //SPLN1.00 start
                NS_UnitCostFactor := "Unit Cost Factor";
                //SPLN1.00 end
            end;

            trigger OnAfterValidate();
            begin
                //SPLN1.00 start
                "Unit Cost Factor" := NS_UnitCostFactor;
                //SPLN1.00 end
                //ProjectPro - start
                if "Unit Cost" <> 0 then
                    if "Unit Cost Factor" <> 0 then //PRJ-209 VT1.0 13-04-20
                        VALIDATE("Unit Cost Factor", "Unit Price" / "Unit Cost")
                    else
                        VALIDATE("Unit Cost Factor", 0);
                //ProjectPro - end                
            end;
        }

        modify("Unit Cost Factor")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_CalculateUnitPrice;
                if ("Unit Cost" <> 0) and ("Unit Price" <> 0) then
                    "NS_Markup %" := ROUND(100 * ("Unit Price" / "Unit Cost" - 1), NS_GLSetup."Amount Rounding Precision")
                else
                    "NS_Markup %" := 0;
                //ProjectPro - end
            end;
        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if "Unit Cost" <> 0 then //PRJ-209 VT1.0 13-04-20
                    NS_CalculateUnitPrice;
                //ProjectPro - end
            end;
        }
        field(14021157; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
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
        field(14021156; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
    }

    PROCEDURE NS_CalculateUnitPrice();
    BEGIN
        //ProjectPro - start
        NS_GLSetup.GET;
        IF "Unit Cost" <> 0 THEN
            IF "Unit Cost Factor" <> 0 THEN
                "Unit Price" := ROUND("Unit Cost" * "Unit Cost Factor", NS_GLSetup."Amount Rounding Precision")
            ELSE
                "Unit Price" := ROUND("Unit Cost", NS_GLSetup."Amount Rounding Precision");
        //ProjectPro - end
    END;

    var
        NS_UnitCostFactor: Decimal;
        NS_GLSetup: Record "General Ledger Setup";
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021156 Line No.
//   +     14021157 Revenue Category
//   +     14021160 Margin %
//   +
//   +  - Added function(s):
//   +     CalculateUnitPrice
//   +     UpdateWorkOrder
//   +
//   +  - Added global variable(s):
//   +     PP_GLSetup
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - Modify Key
//   +         Original: Job No.,Job Task No.,G/L Account No.,Currency Code
//   +         Modified: Job No.,Job Task No.,G/L Account No.,Line No.,Currency Code
//   +     - Fields:
//   +         Job Task No.      - Increased to 35 long
//   +         Unit Price        - Modify Unit Cost Factor setting
//   +         Unit Cost Factor  - OnValidate() - Added call CalculateUnitPrice()
//   +                                          - Set Markup %
//   +         Unit Cost         - OnValidate() - Added call CalculateUnitPrice()
//   +-----------------------------------------------------------------------------------------------

