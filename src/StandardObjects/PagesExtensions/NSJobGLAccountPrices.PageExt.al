pageextension 14021281 NS_JobGLAccountPrices extends "Job G/L Account Prices"
{
    //Version List=NAVW111.00.00.19846,PPNA11.00;
    //PRJ-700.AS.1.0 04JUNE2021 Resolved Mark up % field not showing in Sanbox URL issue
    Caption = 'Job G/L Account Cost/Price';
    layout
    {
        addafter("Unit Cost Factor")
        {
            field("NS_Markup %"; Rec."NS_Markup %")
            {
                Caption = 'Markup %';
                ToolTip = 'Specifies the Markup %';
                //ApplicationArea = Default;//PRJ-700.AS.1.0 04JUNE2021 COMMENT OLD CODE
                ApplicationArea = All;//PRJ-700.AS.1.0 04JUNE2021 NEW CODE
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
                Caption = 'Load Planning';
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
                    JobPlanningLine.SETRANGE(Type, JobPlanningLine.Type::"G/L Account");
                    IF JobPlanningLine.FINDSET(FALSE, FALSE) THEN BEGIN
                        DELETEALL;
                        REPEAT
                            INIT;
                            "Job No." := JobPlanningLine."Job No.";
                            "Job Task No." := JobPlanningLine."Job Task No.";
                            "G/L Account No." := JobPlanningLine."No.";
                            "Currency Code" := JobPlanningLine."Currency Code";
                            "Unit Price" := JobPlanningLine."Unit Price";
                            "Unit Cost Factor" := JobPlanningLine."Cost Factor";
                            "Line Discount %" := JobPlanningLine."Line Discount %";
                            "Unit Cost" := JobPlanningLine."Unit Cost";
                            Description := JobPlanningLine.Description;
                            "NS_Line No." := JobPlanningLine."Line No.";
                            "NS_Revenue Category" := JobPlanningLine."NS_Revenue Category";
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
      +     "Markup %"
      +
      +  - Modification(s):
      +     - Recaptioned page from Job G/L Account Prices to Job G/L Account Cost/Price
      +     - Added Action Item for Load Planning,
      +     - Changed Display Order of Cost and Pricing fields.
      +     - Removed code for "Unit Cost Factor" OnValidate
      +------------------------------------------------------------
    */
}