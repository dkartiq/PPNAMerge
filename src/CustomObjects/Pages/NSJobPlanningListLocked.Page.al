page 14021172 "NS_Job Planning List (Locked)"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // 002 24-11-2021  PREM  Job Filter
    //   001 12-11-2021  PREM  RG007-P0485-62-1 JPL Lock actions
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-895.GK.1.0 27Aug2021| Added two fields Use Tax Sku & Use Tax Amount
    //PRJ-1420.NK.1.0 30May2022 | Add Field
    Caption = 'Job Planning List (Locked)';
    PageType = List;
    SourceTable = "NS_Locked Job Planning Line";
    SourceTableView = SORTING("NS_Job No.", "NS_Entry Type", "NS_Job Task No.", "NS_Cost Category", "NS_Revenue Category", NS_Type, "NS_No.", "NS_Variant Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry Type"; "NS_Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Type';
                }
                field("Line Type"; Rec."NS_Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Type';
                }
                field("Planning Date"; Rec."NS_Planning Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Planning Date';
                }
                field("Currency Date"; Rec."NS_Currency Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Date';
                    Visible = false;
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';
                    Visible = false;
                }
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category';
                }
                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Category';
                }
                field(Adjustment; Rec.NS_Adjustment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Adjustment';
                    Visible = false;
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                    Visible = false; //PRJ-1420.NK.1.0 30May2022
                }
                //PRJ-1420.NK.1.0 30May2022 Start
                field(NS_DescriptionNew; Rec.NS_DescriptionNew)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-1420.NK.1.0 30May2022 End
                field("Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.2.0 13OCT2021 Changed Field reference from "NS_Gen. Bus. Posting Group" to "NS_Gen. Bus. Posting Group New"
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group';
                }
                field("Gen. Prod. Posting Group"; Rec."NS_Gen. Prod. Posting Group New")//PRJ-831.AS.2.0 13OCT2021 Changed Field reference from "NS_Gen. Prod. Posting Group" to "NS_Gen. Prod. Posting Group New"
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Gen. Prod. Posting Group';
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specify Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specify Shortcut Dimension 2 Code';
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                }
                field(Quantity; NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Quantity (Base)"; Rec."NS_Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity (Base)';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Unit Cost (LCY)"; Rec."NS_Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost (LCY)';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."NS_Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost (LCY)';
                    Visible = false;
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Total Cost (LCY)"; Rec."NS_Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost (LCY)';
                    Visible = false;
                }
                field("Skill Class"; Rec."NS_Skill Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                }
                field("Work Type Code"; Rec."NS_Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
                field("Progress Billing Method"; Rec."NS_Progress Billing Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Progress Billing Method';
                }
                field("Unit Price"; Rec."NS_Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price';
                }
                field("Unit Price (LCY)"; Rec."NS_Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price (LCY)';
                    Visible = false;
                }
                field("Rate Type"; Rec."NS_Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type';
                    Visible = false;
                }
                field("Rate Type Value"; Rec."NS_Rate Type Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type Value';
                    Visible = false;
                }
                field("Line Amount"; Rec."NS_Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount';
                }
                field("Line Amount (LCY)"; Rec."NS_Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount (LCY)';
                    Visible = false;
                }
                field("Not To Exceed"; Rec."NS_Not To Exceed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Not To Exceed';
                    Visible = false;
                }
                field("Line Discount %"; Rec."NS_Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount %';
                }
                field("Line Discount Amount"; Rec."NS_Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount Amount';
                }
                field("Total Price"; Rec."NS_Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."NS_Total Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price (LCY)';
                    Visible = false;
                }
                field("Ledger Entry Type"; Rec."NS_Ledger Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ledger Entry Type';
                }
                field("Ledger Entry No."; Rec."NS_Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ledger Entry No.';
                }
                field("System-Created Entry"; Rec."NS_System-Created Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System-Created Entry';
                    Visible = false;
                }
                field("Qty. Invoiced"; Rec."NS_Qty. Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qty. Invoiced';
                }
                field("Remaining Qty."; Rec."NS_Remaining Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining Qty.';
                }
                field("Invoiced Cost Amount (LCY)"; Rec."NS_Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Cost Amount (LCY)';
                }
                field("Invoiced Amount (LCY)"; Rec."NS_Invoiced Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Amount (LCY)';
                }
                field("User ID"; Rec."NS_User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID';
                    Visible = false;
                }
                field("Serial No."; Rec."NS_Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Serial No.';
                    Visible = false;
                }
                field("Lot No."; Rec."NS_Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Lot No.';
                    Visible = false;
                }
                field("Job Contract Entry No."; Rec."NS_Job Contract Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Contract Entry No.';
                }
                //PRJ-895.GK.1.0 27Aug2021 start
                field("NS_Use Tax SKU"; Rec."NS_Use Tax SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Use Tax Sku';
                    Visible = true;
                }
                field("NS_Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Use Tax Amount';
                    Visible = true;
                }
                //PRJ-895.GK.1.0 27Aug2021 end
            }
        }
    }

    trigger OnOpenPage();
    begin
        JobSetup.GET();
        CurrPage.EDITABLE(false);
        if JobSetup."NS_Allow UpdatesToOrigPlanning" then
            CurrPage.EDITABLE(true);

        if PP_ShowJobNo > '' then begin
            SETFILTER("NS_Job No.", PP_ShowJobNo);
            SETFILTER("NS_Line Type", '%1|%2', PP_ShowLineType, 2);
            if PP_ShowAdjustmentLines = Text14021140_Lbl then
                SETFILTER(NS_Adjustment, '>%1', '')
            else
                if PP_ShowAdjustmentLines = Text14021141_Lbl then
                    SETFILTER(NS_Adjustment, '=%1', '');
        end;
        //MHNA-6.NK.1.0 start 06march2023

        NS_SkillClassEditable := TRUE;
        IF NS_ShowJobNo > '' THEN BEGIN
            Rec.SETFILTER("NS_Job No.", NS_ShowJobNo);
            Rec.SETFILTER("NS_Line Type", '%1|%2', NS_ShowLineType, 2);
            IF Rev_ShowAdjustmentLines = Text14021401 THEN
                Rec.SETFILTER(NS_Adjustment, '>%1', '')
            ELSE
                IF Rev_ShowAdjustmentLines = Text14021402 THEN
                    Rec.SETFILTER(NS_Adjustment, '=%1', '');
        END;
        //MHNA-6.NK.1.0 end 06march2023
    end;

    var
        JobSetup: Record "Jobs Setup";
        PP_ShowJobNo: Code[20];
        PP_ShowLineType: Option;
        PP_ShowAdjustmentLines: Code[10];
        Text14021140_Lbl: Label 'YES';
        Text14021141_Lbl: Label 'NO';
        //MHNA-6.NK.1.0 start 06march2023 start
        Rev_ShowAdjustmentLines: Code[10]; //MHNA-6.NK.1.0 start 06march2023
        NS_SkillClassEditable: Boolean;
        NS_ShowJobNo: Code[20];
        Text14021402: Label 'NO';
        NS_ShowLineType: Option;
        Text14021401: Label 'YES';
        // >> Upgrade
        JobNoFilterG: Text;

    PROCEDURE SetJobFilter(JobNoFilter: Text);
    BEGIN
        // >> 001 New Function <<
        JobNoFilterG := JobNoFilter;
    END;
    // << Upgrade
    procedure NS_SetFilters(JobNo: Code[20]; LineType: Option);
    begin
        PP_ShowJobNo := JobNo;
        PP_ShowLineType := LineType;
    end;

    procedure NS_SetShowAdjustmentLines(PassedShowAdjLines: Code[10]);
    begin
        PP_ShowAdjustmentLines := PassedShowAdjLines;
    end;
    //MHNA-6.NK.1.0 start 06march2023
    procedure Rev_SetShowAdjustmentLines(PassedShowAdjLines_Rev: Code[10]);
    begin

        Rev_ShowAdjustmentLines := PassedShowAdjLines_Rev;

    end;

    procedure SetFilters(JobNo: Code[20]; LineType: Option);
    begin

        NS_ShowJobNo := JobNo;
        NS_ShowLineType := LineType;

    end;
    //MHNA-6.NK.1.0 start 06march2023
}

