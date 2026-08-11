pageextension 14021280 NS_JobItemPrices extends "Job Item Prices"
{
    //PRJ-440.AM.2.0 | Changed field Properties.
    //PPAL-166.Am.1.0 | Added Caption property.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Job Item Prices'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {

        //SPLN 1.0 Start
        modify("Item No.")
        {
            Visible = true;//PRJ-440.AM.2.0
            Editable = true;//PRJ-440.AM.2.0
        }

        addafter("Item No.")
        {
            field("NS_Item No.2"; Rec."NS_Item No.2")
            {
                Caption = 'Item No.';
                ToolTip = 'Specifies the item that this price applies to. Choose the field to see the available items.';
                ApplicationArea = all;
                Visible = false;//PRJ-440.AM.2.0
            }
        }
        //SPLN 1.0 End

        addafter("Job Task No.")
        {
            field("NS_Type"; Rec.NS_Type)
            {
                ApplicationArea = All;
                Caption = 'Type';
            }
        }

        addafter("Currency Code")
        {
            field("NS_Unit Cost"; Rec."NS_Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Unit Cost';
            }
            field("NS_Markup %"; Rec."NS_Markup %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Markup %';
            }
        }

        modify("Unit Cost Factor")
        {
            Visible = false;
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("NS_Load Planning")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = Planning;
                PromotedCategory = Process;
                Caption = 'Load Planning';//PPAL-166.Am.1.0

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                begin
                    JobPlanningLine.RESET;
                    JobPlanningLine.SETRANGE("Job No.", "Job No.");
                    JobPlanningLine.SETRANGE(Type, JobPlanningLine.Type::Item);
                    IF JobPlanningLine.FINDSET(FALSE, FALSE) THEN BEGIN
                        DELETEALL;
                        REPEAT
                            INIT;
                            "Job No." := JobPlanningLine."Job No.";
                            "Job Task No." := JobPlanningLine."Job Task No.";
                            "Item No." := JobPlanningLine."No.";
                            "Variant Code" := JobPlanningLine."Variant Code";
                            "Unit of Measure Code" := JobPlanningLine."Unit of Measure Code";
                            "Currency Code" := JobPlanningLine."Currency Code";
                            NS_Type := JobPlanningLine.Type;
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Cost Factor" := JobPlanningLine."Cost Factor";
                            "Line Discount %" := JobPlanningLine."Line Discount %";
                            "Apply Job Price" := TRUE;
                            "Apply Job Discount" := TRUE;
                            "NS_Unit Cost" := JobPlanningLine."Unit Cost";
                            Description := JobPlanningLine.Description;
                            INSERT;
                        UNTIL JobPlanningLine.NEXT = 0;
                    END;
                end;
            }
        }
    }

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "PP Unit Cost"
    //   +     "PP Type"
    //   +     "Markup %"
    //   +
    //   +  - Modification(s):
    //   +     - Recaptioned page from Job Item Prices to Job Item Cost/Price
    //   +     - set DelayedInsert property to Yes
    //   +     - Added Action Item for Load Planning,
    //   +     - Changed display Order of Cost & Price fields.
    //   +     - removed code for "Unit Cost Factor" OnValidate
    //   +------------------------------------------------------------

    //   SMP 
    //      -Can't set DelayedInsert property to Yes

}