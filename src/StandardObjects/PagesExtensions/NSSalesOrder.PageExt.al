pageextension 14021112 NS_SalesOrder extends "Sales Order"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-552.SK.1.0 Added caption
     //PRJ-659.RS.1.0 18June21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    if "NS_Job No." <> xRec."NS_Job No." then
                        CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
        }
        addafter(Control1900201301)
        //addafter(Prepayment)
        {
            group(NS_Retention)
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; NS_RetentionBaseAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Retention Base Amount'; //PRJ-552.SK.1.0 Added Caption//PRJ-659.RS.1.0 18June21
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionPercentEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountLCYEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountEditable;
                    ToolTip = 'Specifies the Retention Amount';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionDateEditable;
                    ToolTip = 'Specifies the Retention Date';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionPercentEditable: Boolean;
        NS_RetentionAmountLCYEditable: Boolean;
        NS_RetentionAmountEditable: Boolean;
        NS_RetentionDateEditable: Boolean;
        NS_RetentionBaseAmount: Decimal;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        NS_RetentionCalcs();
        //ProjectPro - end
    end;

    procedure NS_RetentionCalcs();
    begin
        //ProjectPro - start
        NS_RetentionBaseAmount := NS_RetentionBase("Document Type", "No.");

        if "NS_Retention Percent" <> 0 then begin
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        end else
            if "NS_Retention Amount (LCY)" <> 0 then begin
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            end;

        if "NS_Retention Document" then begin
            "NS_Retention Percent" := 0;
            "NS_Retention Amount (LCY)" := 0;
            "NS_Retention Amount" := 0;
            "NS_Retention Date" := 0D;
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
            NS_RetentionDateEditable := false;
        end else begin
            NS_RetentionPercentEditable := true;
            NS_RetentionAmountLCYEditable := true;
            NS_RetentionAmountEditable := true;
            NS_RetentionDateEditable := true;
        end;

        if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
           (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;

        if "NS_Progress Billing Document" then begin
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    /* Documentation
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     PP_RetentionBaseAmount
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +
      +  - Added function(s):
      +     PP_RetentionCalcs
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_RetentionBaseAmount
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +    - OnOpenPage  - Read Job Setup record
      +                  - Initiate variables
      +    - OnAfterGetRecord - Call PP_RetentionCalcs
      +    - Added Retention fasttab with retention related fields
      +
      + -SMP
      +  -Modified Page triggers
      +   -OnAfterGetRecord 
      +   -OnOpenPage
      +-----------------------------------------------------------------------------------------------
      */

}

