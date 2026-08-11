pageextension 14021279 NS_JobResourcePrices extends "Job Resource Prices"
{
    //Version List=NAVW111.00.00.19846,PPNA11.00;
    //PPAL-100.NS.1.0 Visible some fields
    //PRJ-464.AM.1.0 23NOV2020 | Added field in layout.
    //PPAL-166.Am.1.0 | Added Caption property.

    Caption = 'Job Resource Cost/Price';
    layout
    {
        modify("Currency Code")
        {
            Visible = false;
        }
        addbefore(Type)
        {
            field("NS_Skill Class Code"; Rec."NS_Skill Class Code")
            {
                Caption = 'Skill Class Code';//PPAL-166.AM.1.0
                ToolTip = 'Specifies the Skill Class Code';
                ApplicationArea = Jobs;
            }

        }
        //PRJ-464.AM.1.0 Start
        addafter(Code)
        {
            field("NS_Unit of Measure Code"; Rec."NS_Unit of Measure Code")
            {
                ApplicationArea = all;
            }
        }
        //PRJ-464.AM.1.0 End

        addafter("Currency Code")
        {
            field("NS_Skill Rate"; Rec."NS_Skill Rate")
            {
                Caption = 'Skill Rate';//PPAL-166.AM.1.0
                ToolTip = 'Specifies the Skill Rate';
                Visible = false;
                ApplicationArea = Default;
            }
            field("NS_Fringe Rate"; Rec."NS_Fringe Rate")
            {
                Caption = 'Fringe Rate';//PPAL-166.Am.1.0
                ToolTip = 'Specifies the Fringe Rate';
                Visible = false;
                ApplicationArea = Default;
            }
            field("NS_Unit Cost"; Rec."NS_Unit Cost")
            {
                Caption = 'Unit Cost';//PPAL-166.Am.1.0
                ToolTip = 'Specifies the Unit Cost';
                ApplicationArea = All;//PPAL-100.NS.1.0
                Visible = true;//PPAL-100.NS.1.0

            }
            field("NS_Markup %"; Rec."NS_Markup %")
            {
                ToolTip = 'Specifies the Markup %';
                ApplicationArea = All;//PPAL-100.NS.1.0
                Caption = 'Markup %';//PPAL-166.Am.1.0
                Visible = true;//PPAL-100.NS.1.0
            }
        }
        modify("Unit Cost Factor")
        {
            Visible = false;

        }
        //PPAL-100.NS.1.0 - start
        modify("Line Discount %")
        {
            Visible = true;
            ApplicationArea = All;//PPAL-100.NS.1.0
        }
        //PPAL-100.NS.1.0 - end
        addafter("Unit Cost Factor")
        {
            field("NS_Cost Type"; Rec."NS_Cost Type")
            {
                Caption = 'Cost Type';//PPAL-166.AM.1.0
                ToolTip = 'Specifies the Cost Type';
                ApplicationArea = All;//PPAL-100.NS.1.0
                Visible = true;//PPAL-100.NS.1.0
            }
            field("NS_Cost Burden Multiplier"; Rec."NS_Cost Burden Multiplier")
            {
                ToolTip = 'Specifies the Cost Burden Multiplier';
                ApplicationArea = All;//PPAL-100.NS.1.0
                Visible = true;//PPAL-100.NS.1.0
            }
        }
    }
    actions
    {
        addfirst(Creation)
        {
            action("NS_Load Planning")
            {
                ApplicationArea = All;
                Caption = 'Load Planning'; //PPAL-166.AM.1.0
                Promoted = true;
                PromotedIsBig = true;
                Image = Planning;
                PromotedCategory = Process;
                trigger OnAction();
                VAR
                    JobPlanningLine: Record 1003;
                BEGIN
                    JobPlanningLine.RESET;
                    JobPlanningLine.SETRANGE("Job No.", "Job No.");
                    JobPlanningLine.SETRANGE(Type, JobPlanningLine.Type::Resource);
                    IF JobPlanningLine.FINDSET(FALSE, FALSE) THEN BEGIN
                        DELETEALL;
                        REPEAT
                            INIT;
                            "Job No." := JobPlanningLine."Job No.";
                            "Job Task No." := JobPlanningLine."Job Task No.";
                            Type := JobPlanningLine.Type;
                            Code := JobPlanningLine."No.";
                            "Work Type Code" := JobPlanningLine."Work Type Code";
                            "NS_Skill Class Code" := JobPlanningLine."NS_Skill Class";
                            "Currency Code" := JobPlanningLine."Currency Code";
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Cost Factor" := JobPlanningLine."Cost Factor";
                            "Line Discount %" := JobPlanningLine."Line Discount %";
                            Description := JobPlanningLine.Description;
                            "Apply Job Price" := TRUE;
                            "Apply Job Discount" := TRUE;
                            "NS_Cost Type" := "NS_Cost Type"::Fixed;
                            ;
                            "NS_Cost Burden Multiplier" := JobPlanningLine."Cost Factor";
                            "NS_Unit Cost" := JobPlanningLine."Unit Cost";
                            INSERT;
                        UNTIL JobPlanningLine.NEXT = 0;
                    END;
                END;
            }
        }
    }

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     "PP Unit Cost"
      +     "PP Cost Type"
      +     "PP Cost Burden Multiplier"
      +     "PP Skill Class Code"
      +     "PP Skill Rate"
      +     "PP Fringe Rate"
      +
      +  - Modification(s):
      +     - Added Action Item for Load Planning
      +     - Changed display Order of Unit Cost % Mark-up % & Unit Price.
      +     - Removed code for "Unit Cost Factor" OnValidate
      +------------------------------------------------------------
    */
}