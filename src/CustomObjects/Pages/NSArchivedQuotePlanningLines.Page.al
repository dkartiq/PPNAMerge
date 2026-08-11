page 14021440 "NS_Archived QuotePlanningLines"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0�18June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    //PRJ-872.JS.1.0  13Sep2021
    //PRJ-1221.JS,10 24FEB2022 | change code for SMTP setup
    AutoSplitKey = true;
    Caption = 'Archived Quote Planning Lines';
    DataCaptionExpression = NS_Caption();
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    PromotedActionCategories = 'New,Process,Report,Outlook';
    SaveValues = true;
    SourceTable = "NS_Archived QuotePlanningLine";
    SourceTableView = SORTING("NS_Job No.", "NS_Job Task No.", "NS_Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Control1100773025)
            {
                Visible = BySegment;
                field(SegmentCode; SegmentCode)
                {
                    ApplicationArea = All;
                    Caption = 'Segment Code';
                    TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
                    ToolTip = 'Specifies the segment code.';
                    Visible = BySegment;

                    trigger OnValidate();
                    var
                        lPlanningLines: Record "Job Planning Line";
                    begin
                        lPlanningLines.SETRANGE("Job No.", "NS_Job No.");
                        lPlanningLines.SETRANGE("NS_Segment Code", '');
                        if TaskNo <> '' then
                            lPlanningLines.SETRANGE("Job Task No.", TaskNo);
                        if lPlanningLines.FINDSET(true, false) then begin
                            if CONFIRM(Text14021400Lbl, false, SegmentCode) then begin
                                repeat
                                    lPlanningLines.VALIDATE("NS_Segment Code", SegmentCode);
                                    lPlanningLines.MODIFY();
                                until lPlanningLines.NEXT() = 0;
                            end else begin
                                SETRANGE("NS_Segment Code", SegmentCode);
                            end;
                        end else begin
                            SETRANGE("NS_Segment Code", SegmentCode);
                        end;
                        if SegmentCode <> '' then
                            SegCode := SegmentCode;

                        SegmentName := '';
                        if SegmentCode <> '' then begin
                            JobTakeoffSegments.RESET;
                            JobTakeoffSegments.SETRANGE("NS_Job No.", JobNo2);
                            JobTakeoffSegments.SETRANGE("NS_Segment Code", SegmentCode);
                            if JobTakeoffSegments.FINDFIRST then
                                SegmentName := JobTakeoffSegments."NS_Segment Name";
                        end;

                        CurrPage.UPDATE();
                    end;
                }
                field("Segment Desc."; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the segment name.';

                    //Caption = 'Specifies the segment name.';//PRJ-659.RS.1.0�18June21 Commented
                    Caption = 'segment name';//PRJ-659.RS.1.0�18June21
                }
            }
            repeater(Control1)
            {
                field("NS Line Job Description"; PP_LineJobDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Line Job Description';

                    ToolTip = 'Line Job Description';
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = ItemNotFound;
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the job task to which the planning line is linked.';
                    Visible = JobTaskNoVisible;
                }
                field("Line Type"; Rec."NS_Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of planning line.';
                }
                field("Usage Link"; Rec."NS_Usage Link")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the Usage Link field applies to the job planning line. When this check box is selected, usage entries are linked to the job planning line. Selecting this check box creates a link to the job planning line from places where usage has been posted, such as the job journal or a purchase line. You can select this check box only if the line type of the job planning line is Budget or Both Budget and Billable.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_UsageLinkOnAfterValidate();
                    end;
                }
                field("Planning Date"; Rec."NS_Planning Date")
                {
                    ApplicationArea = Jobs;
                    Editable = PlanningDateEditable;
                    ToolTip = 'Specifies the date of the planning line. You can use the planning date for filtering the totals of the job, for example, if you want to see the scheduled usage for a specific month of the year.';

                    trigger OnValidate();
                    begin
                        NS_PlanningDateOnAfterValidate();
                    end;
                }
                field("Planned Delivery Date"; Rec."NS_Planned Delivery Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date that is planned to deliver the item connected to the job planning line. For a resource, the planned delivery date is the date that the resource performs services with respect to the job.';
                }
                field("Currency Date"; Rec."NS_Currency Date")
                {
                    ApplicationArea = Jobs;
                    Editable = CurrencyDateEditable;
                    ToolTip = 'Specifies the date that will be used to find the exchange rate for the currency in the Currency Date field.';
                    Visible = false;
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = Jobs;
                    Editable = DocumentNoEditable;
                    ToolTip = 'Specifies a document number for the planning line.';
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the planning line''s entry number.';
                    Visible = false;
                }
                field("PP Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';
                    Visible = false;
                }
                field("PP Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost category.';
                }
                field("PP Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the revenue category.';
                }
                field("PP Adjustment"; Rec.NS_Adjustment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the adjustment amount.';
                    Visible = false;
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = Jobs;
                    Editable = TypeEditable;
                    Style = Unfavorable;
                    StyleExpr = ItemNotFound;
                    ToolTip = 'Specifies the type of account to which the planning line relates.';

                    trigger OnValidate();
                    begin
                        NS_NoOnAfterValidate;
                    end;
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = Jobs;
                    Editable = NoEditable;
                    Style = Unfavorable;
                    StyleExpr = ItemNotFound;
                    ToolTip = 'Specifies the number of the account to which the resource, item or general ledger account is posted, depending on your selection in the Type field.';

                    trigger OnValidate();
                    begin
                        NS_NoOnAfterValidate();
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = Jobs;
                    Editable = DescriptionEditable;
                    ToolTip = 'Specifies the name of the resource, item, or G/L account to which this entry applies. You can change the description. A maximum of 50 characters, both numbers and letters, are allowed.';
                }
                field("Gen. Bus. Posting Group"; Rec."NS_Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Editable = true;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Gen. Prod. Posting Group"; Rec."NS_Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Editable = true;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ApplicationArea = Jobs;
                    Editable = VariantCodeEditable;
                    ToolTip = 'Specifies an item variant code if the Type field is Item.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_VariantCodeOnAfterValidate;
                    end;
                }
                field("Retention Ledger Code"; Rec."NS_Retention Ledger Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retention Ledger Code';
                }
                field("PP Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Shortcut Dimension 1 Code';
                }
                field("PP Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'PP Shortcut Dimension 2 Code'; //PE-75.RM.1.0 23May2023 
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    Editable = LocationCodeEditable;
                    ToolTip = 'Specifies a location code for an item.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_LocationCodeOnAfterValidate();
                    end;
                }
                field("PP Skill Class"; Rec."NS_Skill Class")
                {
                    ApplicationArea = All;
                    Caption = 'Skill Class';
                    Editable = PP_SkillClassEditable;
                    ToolTip = 'Specifies the Skill Class';
                }
                field("Work Type Code"; Rec."NS_Work Type Code")
                {
                    ApplicationArea = Jobs;
                    Editable = WorkTypeCodeEditable;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                    Visible = false;
                }
                field("PP Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of Work Units';
                }
                field("PP Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
                field("PP Progress Billing Method"; Rec."NS_Progress Billing Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Progress Billing Method';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    Editable = UnitOfMeasureCodeEditable;
                    ToolTip = 'Specifies a unit of measure code, which is used in determining the unit price. This code specifies how the quantity is measured. The code is retrieved from the corresponding item or resource card.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_UnitofMeasureCodeOnAfterValida();
                    end;
                }
                field(Reserve; Rec.NS_Reserve)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether or not a reservation can be made for items on the current line. The field is not applicable if the Type field is set to Resource, Cost, or G/L Account.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ReserveOnAfterValidate;
                    end;
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the number of units of the resource, item, or general ledger account that should be specified on the planning line. If you later change the No., the quantity you have entered remains on the line.';

                    trigger OnValidate();
                    begin
                        NS_QuantityOnAfterValidate();
                    end;
                }
                field("Reserved Quantity"; Rec."NS_Reserved Quantity")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity of the item that is reserved for the job planning line.';
                    Visible = false;
                }
                field("Quantity (Base)"; Rec."NS_Quantity (Base)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'This field is automatically updated. The quantity in the field is the Quantity expressed in base units of measure.';
                    Visible = false;
                }
                field("Remaining Qty."; Rec."NS_Remaining Qty.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining quantity of the resource, item, or G/L Account that remains to complete a job. The quantity is calculated as the difference between Quantity and Qty. Posted.';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."NS_Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct unit cost, in the local currency, of one unit of the selected Type and No.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = Jobs;
                    Editable = UnitCostEditable;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the unit cost for the selected Type and No. on the planning line. The unit cost is in the job currency, which comes from the Currency Code field on the Job Card.';
                }
                field("Unit Cost (LCY)"; Rec."NS_Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the unit cost for the selected Type and No. on the planning line. The unit cost is in the local currency.';
                    Visible = false;
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.';
                }
                field("Remaining Total Cost"; Rec."NS_Remaining Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.';
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."NS_Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the total cost for the planning line. The amount is in the local currency.';
                }
                field("Remaining Total Cost (LCY)"; Rec."NS_Remaining Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total cost ($) for the planning line. The amount is in the local currency.';
                    Visible = false;
                }
                field("Unit Price"; Rec."NS_Unit Price")
                {
                    ApplicationArea = Jobs;
                    Editable = UnitPriceEditable;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the unit price, in the job currency, of the selected Type and No..';
                }
                field("Unit Price (LCY)"; Rec."NS_Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    Editable = true;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the unit price of the selected Type and No.';
                    Visible = false;
                }
                field("PP Rate Type"; Rec."NS_Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type';
                    Visible = false;
                }
                field("PP Rate Type Value"; Rec."NS_Rate Type Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type Value';
                    Visible = false;
                }
                field("Line Amount"; Rec."NS_Line Amount")
                {
                    ApplicationArea = Jobs;
                    Editable = LineAmountEditable;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Line Amount Incl. Tax"; Rec."NS_Line Amount Incl. Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount Incl. Tax';
                }
                field("Remaining Line Amount"; Rec."NS_Remaining Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount of the planning line, in the job currency, which comes from the Currency Code field in the Job Card.';
                    Visible = false;
                }
                field("Line Amount (LCY)"; Rec."NS_Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the net amount in ($) (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                    Visible = false;
                }
                field("PP Not To Exceed"; Rec."NS_Not To Exceed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount Not To Exceed';
                    Visible = false;
                }
                field("Remaining Line Amount (LCY)"; Rec."NS_Remaining Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the net amount of the planning line in the local currency.';
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."NS_Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    Editable = LineDiscountAmountEditable;
                    ToolTip = 'Specifies the amount of the discount that applies to the planning line.';
                    Visible = false;
                }
                field("Line Discount %"; Rec."NS_Line Discount %")
                {
                    ApplicationArea = Jobs;
                    Editable = LineDiscountPctEditable;
                    ToolTip = 'Specifies the line discount percentage.';
                    Visible = false;
                }
                field("Total Price"; Rec."NS_Total Price")
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the total price in the job currency on the planning line.';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."NS_Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    Style = Attention;
                    StyleExpr = PP_BelowCost;
                    ToolTip = 'Specifies the total price on the planning line. The total price is in the local currency.';
                    Visible = false;
                }
                field("Gross Profit"; Rec."NS_Gross Profit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit';
                }
                field("Gross Profit Percentage"; Rec."NS_Gross Profit Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gross Profit Percentage';
                }
                field("Qty. Posted"; Rec."NS_Qty. Posted")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Qty. to Transfer to Journal"; Rec."NS_Qty. to Transfer to Journal")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity you want to transfer to the job journal. Its default value is calculated as quantity minus the quantity that has already been posted, if the Apply Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Total Cost"; Rec."NS_Posted Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Total Cost (LCY)"; Rec."NS_Posted Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost ($) that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Line Amount"; Rec."NS_Posted Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total posted line that has been posted to the job ledger, if the Apply Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Line Amount (LCY)"; Rec."NS_Posted Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total posted line ($) that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Qty. Transferred to Invoice"; Rec."NS_Qty. Transferred to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that has been transferred to a sales invoice or credit memo.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        NS_DrillDownJobInvoices();
                    end;
                }
                field("Qty. to Transfer to Invoice"; Rec."NS_Qty. to Transfer to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity you want to transfer to the sales invoice or credit memo. The value in this field is calculated as Quantity - Qty. Transferred to Invoice.';
                    Visible = false;
                }
                field("Qty. Invoiced"; Rec."NS_Qty. Invoiced")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that been posted through a sales invoice.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        NS_DrillDownJobInvoices;
                    end;
                }
                field("Qty. to Invoice"; Rec."NS_Qty. to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    Visible = false;
                }
                field("Invoiced Amount (LCY)"; Rec."NS_Invoiced Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in local currency, the sales amount that was invoiced for this planning line.';

                    trigger OnDrillDown();
                    begin
                        NS_DrillDownJobInvoices;
                    end;
                }
                field("Invoiced Cost Amount (LCY)"; Rec."NS_Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the cost amount that was invoiced for this planning line.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        NS_DrillDownJobInvoices;
                    end;
                }
                field("User ID"; Rec."NS_User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who last modified the planning line.';
                    Visible = false;
                }
                field("Serial No."; Rec."NS_Serial No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the serial number that is applied to the posted item if the planning line was created from the posting of a job journal line.';
                    Visible = false;
                }
                field("Lot No."; Rec."NS_Lot No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the lot number that is applied to the posted item if the planning line was created from the posting of a job journal line.';
                    Visible = false;
                }
                field("Job Contract Entry No."; Rec."NS_Job Contract Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Ledger Entry Type"; Rec."NS_Ledger Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry type of the job ledger entry associated with the planning line.';
                    Visible = false;
                }
                field("Ledger Entry No."; Rec."NS_Ledger Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number of the job ledger entry associated with the job planning line.';
                    Visible = false;
                }
                field("System-Created Entry"; Rec."NS_System-Created Entry")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies that an entry has been created by Microsoft Dynamics NAV and is related to a job ledger entry. The check box is selected automatically.';
                    Visible = false;
                }
                field(Overdue; NS_Overdue)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Specifies that the job is overdue. ';
                    Visible = false;
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                }
                field("Matrix Updated"; Rec."NS_Matrix Updated")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Matrix Updated';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
        NS_SetEditable("NS_Qty. Transferred to Invoice" = 0);

        if "NS_Item Not Found" then
            ItemNotFound := true
        else
            ItemNotFound := false;

        if "NS_Unit Cost" > "NS_Unit Price" then
            PP_BelowCost := true
        else
            PP_BelowCost := false;
    end;

    trigger OnAfterGetRecord();
    begin
        NS_SetLineJobDescription();

        if "NS_Item Not Found" then
            ItemNotFound := true
        else
            ItemNotFound := false;

        if "NS_Unit Cost" > "NS_Unit Price" then
            PP_BelowCost := true
        else
            PP_BelowCost := false;
    end;

    trigger OnInit();
    var
        //PRJ-1221.JS,10 24FEB2022 - start
        //SMTPMailSetup: Record "SMTP Mail Setup";
        NSEmailSetup: record "Email Account";
        //MailManagement: Codeunit "Mail Management";
        NSEmailAccount: Codeunit "Email Account";
    //PRJ-1221.JS,10 24FEB2022 - end

    begin
        UnitCostEditable := true;
        LineAmountEditable := true;
        LineDiscountPctEditable := true;
        LineDiscountAmountEditable := true;
        UnitPriceEditable := true;
        WorkTypeCodeEditable := true;
        LocationCodeEditable := true;
        VariantCodeEditable := true;
        UnitOfMeasureCodeEditable := true;
        DescriptionEditable := true;
        NoEditable := true;
        TypeEditable := true;
        DocumentNoEditable := true;
        CurrencyDateEditable := true;
        PlanningDateEditable := true;

        JobTaskNoVisible := true;

        //PRJ-1221.JS.1.0 24FEB2022 - start
        //CanSendToCalendar := MailManagement.IsSMTPEnabled and not SMTPMailSetup.ISEMPTY;  
        CanSendToCalendar := NSEmailAccount.IsAnyAccountRegistered() and not NSEmailSetup.IsEmpty;
        //PRJ-1221.JS.1.0 24FEB2022 - end
        PP_SkillClassEditable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if SegCode <> '' then
            VALIDATE("NS_Segment Code", SegCode);
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if "NS_System-Created Entry" then begin
            if CONFIRM(Text001Lbl, false) then
                "NS_System-Created Entry" := false
            else
                ERROR('');
        end;
    end;

    trigger OnOpenPage();
    var
        Job: Record Job;
    begin
        if Job.GET(JobNo) then
            CurrPage.EDITABLE(not (Job.Blocked = Job.Blocked::All));

        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;

        if PP_ShowJobNo > '' then begin
            SETFILTER("NS_Job No.", PP_ShowJobNo);
            SETFILTER("NS_Line Type", '%1|%2', PP_ShowLineType, 2);
            if PP_ShowAdjustmentLines = 'YES' then
                SETFILTER(NS_Adjustment, '>%1', '')
            else
                if PP_ShowAdjustmentLines = 'NO' then
                    SETFILTER(NS_Adjustment, '=%1', '');
        end;

        if JobNo2 <> '' then
            SETRANGE("NS_Job No.", JobNo2);
        if TaskNo <> '' then
            SETRANGE("NS_Job Task No.", TaskNo);
        if SegCode <> '' then begin
            SETRANGE("NS_Segment Code", SegCode);
            SegmentCode := SegCode;
        end else
            SegmentCode := '';
        SETRANGE(NS_Revision, RevisionValue);

        SegmentName := '';
        if SegmentCode <> '' then begin
            JobTakeoffSegments.RESET;
            JobTakeoffSegments.SETRANGE("NS_Job No.", JobNo2);
            JobTakeoffSegments.SETRANGE("NS_Segment Code", SegmentCode);
            if JobTakeoffSegments.FINDFIRST() then
                SegmentName := JobTakeoffSegments."NS_Segment Name";
        end;
    end;

    var
        //JobCreateInvoice: Codeunit "Job Create-Invoice";
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;
        Text001Lbl: Label 'This job planning line was automatically generated. Do you want to continue?';
        JobNo: Code[20];
        [InDataSet]
        JobTaskNoVisible: Boolean;
        [InDataSet]
        PlanningDateEditable: Boolean;
        [InDataSet]
        CurrencyDateEditable: Boolean;
        [InDataSet]
        DocumentNoEditable: Boolean;
        [InDataSet]
        TypeEditable: Boolean;
        [InDataSet]
        NoEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        UnitOfMeasureCodeEditable: Boolean;
        [InDataSet]
        VariantCodeEditable: Boolean;
        [InDataSet]
        LocationCodeEditable: Boolean;
        [InDataSet]
        WorkTypeCodeEditable: Boolean;
        [InDataSet]
        UnitPriceEditable: Boolean;
        [InDataSet]
        LineDiscountAmountEditable: Boolean;
        [InDataSet]
        LineDiscountPctEditable: Boolean;
        [InDataSet]
        LineAmountEditable: Boolean;
        [InDataSet]
        UnitCostEditable: Boolean;
        //Text002: Label 'The %1 was successfully transferred to a %2.';
        CanSendToCalendar: Boolean;
        PP_Job: Record Job;
        PP_ShowJobNo: Code[20];
        //PP_JobDescription: Text[50];
        PP_LineJobDescription: Text[50];
        PP_ShowLineType: Option;
        PP_ShowAdjustmentLines: Code[10];
        PP_SkillClassEditable: Boolean;
        PP_BelowCost: Boolean;
        ItemNotFound: Boolean;
        JobNo2: Code[20];
        TaskNo: Code[20];
        Text14021400Lbl: Label 'Do you wish to apply this Segment Code %1 to all unassigned planning lines?';
        BySegment: Boolean;
        SegmentCode: Code[20];
        SegCode: Code[20];
        CalledFromGetBudgLines: Boolean;
        SubcontractNo: Code[20];
        SegmentName: Text;
        JobTakeoffSegments: Record "NS_Job Takeoff Segments";
        PurchaseOrderNo: Code[20];
        RevisionValue: Integer;

    local procedure NS_CreateSalesInvoice(CrMemo: Boolean);
    var
        JobPlanningLine: Record "Job Planning Line";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        TESTFIELD("NS_Line No.");
        JobPlanningLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(JobPlanningLine);
        JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)
    end;

    local procedure NS_SetEditable(Edit: Boolean);
    begin
        PlanningDateEditable := Edit;
        CurrencyDateEditable := Edit;
        DocumentNoEditable := Edit;
        TypeEditable := Edit;
        NoEditable := Edit;
        DescriptionEditable := Edit;
        UnitOfMeasureCodeEditable := Edit;
        VariantCodeEditable := Edit;
        LocationCodeEditable := Edit;
        WorkTypeCodeEditable := Edit;
        UnitPriceEditable := Edit;
        LineDiscountAmountEditable := Edit;
        LineDiscountPctEditable := Edit;
        LineAmountEditable := Edit;
        UnitCostEditable := Edit;
        PP_SkillClassEditable := Edit;
    end;

    procedure NS_SetActiveField(ActiveField2: Integer);
    begin
        ActiveField := ActiveField2;
    end;

    procedure NS_SetJobNo(No: Code[20]);
    begin
        JobNo := No;
    end;

    procedure NS_SetJobTaskNoVisible(NewJobTaskNoVisible: Boolean);
    begin
        JobTaskNoVisible := NewJobTaskNoVisible;
    end;

    local procedure NS_PerformAutoReserve();
    begin
        if (NS_Reserve = NS_Reserve::Always) and
           ("NS_Remaining Qty. (Base)" <> 0)
        then begin
            CurrPage.SAVERECORD();
            NS_AutoReserve();
            CurrPage.UPDATE(false);
        end;
    end;

    local procedure NS_UsageLinkOnAfterValidate();
    begin
        NS_PerformAutoReserve();
    end;

    local procedure NS_PlanningDateOnAfterValidate();
    begin
        if "NS_Planning Date" <> xRec."NS_Planning Date" then
            NS_PerformAutoReserve();
    end;

    local procedure NS_NoOnAfterValidate();
    begin
        if "NS_No." <> xRec."NS_No." then
            NS_PerformAutoReserve();
    end;

    local procedure NS_VariantCodeOnAfterValidate();
    begin
        if "NS_Variant Code" <> xRec."NS_Variant Code" then
            NS_PerformAutoReserve();
    end;

    local procedure NS_LocationCodeOnAfterValidate();
    begin
        if "NS_Location Code" <> xRec."NS_Location Code" then
            NS_PerformAutoReserve();
    end;

    local procedure NS_UnitofMeasureCodeOnAfterValida();
    begin
        NS_PerformAutoReserve();
    end;

    local procedure NS_ReserveOnAfterValidate();
    begin
        NS_PerformAutoReserve();
    end;

    local procedure NS_QuantityOnAfterValidate();
    begin
        NS_PerformAutoReserve;
        if (NS_Type = NS_Type::Item) and (NS_Quantity <> xRec.NS_Quantity) then
            CurrPage.UPDATE(true);
    end;

    procedure NS_SetFilters(JobNo: Code[20]; LineType: Option);
    begin
        PP_ShowJobNo := JobNo;
        PP_ShowLineType := LineType;
    end;

    local procedure NS_SetLineJobDescription();
    begin
        PP_LineJobDescription := '';
        if PP_Job.GET("NS_Job No.") then
            PP_LineJobDescription := PP_Job.Description;
    end;

    procedure NS_SetShowAdjustmentLines(PassedShowAdjLines: Code[10]);
    begin
        PP_ShowAdjustmentLines := PassedShowAdjLines;
    end;

    procedure NS_InitVar(lJobNo: Code[20]; lTaskNo: Code[20]; TrueFalse: Boolean; lSegCode: Code[20]; lRevision: Integer);
    begin
        JobNo2 := lJobNo;
        TaskNo := lTaskNo;
        BySegment := TrueFalse;
        SegCode := lSegCode;
        SegmentCode := lSegCode;
        RevisionValue := lRevision;
    end;

    procedure NS_SetGetFrom(PassGetFromGetBudg: Boolean; PassSubcontract: Code[20]; PassPurchaseOrder: Code[20]);
    begin
        CalledFromGetBudgLines := PassGetFromGetBudg;
        SubcontractNo := PassSubcontract;
        PurchaseOrderNo := PassPurchaseOrder;
    end;

    local procedure NS_CreateSubContractDetail(var PP_PassJobPlanningLine: Record "Job Planning Line");
    var
        PP_SubcontractDetail: Record "NS_Subcontract Lines";
        PP_SubcontractReference: Record NS_Subcontract;
        PP_JobsSetup: Record "Jobs Setup";
        PP_SubcontractHeader: Record NS_Subcontract;
        PP_NextLineNo: Integer;
    begin
        with PP_SubcontractDetail do begin
            if PP_PassJobPlanningLine.FINDSET then
                repeat
                    RESET;
                    SETRANGE("NS_Subcontract No.", SubcontractNo);
                    SETRANGE(NS_Type, PP_PassJobPlanningLine.Type);
                    case NS_Type of
                        NS_Type::Resource:
                            SETRANGE(NS_Type, NS_Type::Resource);
                        NS_Type::Item:
                            SETRANGE(NS_Type, NS_Type::Item);
                        NS_Type::"G/L Account":
                            SETRANGE(NS_Type, NS_Type::"G/L Account");
                    end;
                    SETRANGE("NS_No.", PP_PassJobPlanningLine."No.");
                    if FINDLAST then
                        PP_NextLineNo := "NS_Line No." + 10000
                    else
                        PP_NextLineNo := 10000;
                    INIT();
                    "NS_Subcontract No." := SubcontractNo;
                    "NS_Line No." := PP_NextLineNo;
                    "NS_Job No." := PP_PassJobPlanningLine."Job No.";
                    "NS_Job Task No." := PP_PassJobPlanningLine."Job Task No.";
                    PP_SubcontractReference.NS_JobTaskNoToAPO(PP_PassJobPlanningLine."Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                    "NS_Job Cost Category" := PP_PassJobPlanningLine."NS_Cost Category";
                    case NS_Type of
                        NS_Type::Resource:
                            NS_Type := NS_Type::Resource;
                        NS_Type::Item:
                            NS_Type := NS_Type::Item;
                        NS_Type::"G/L Account":
                            NS_Type := NS_Type::"G/L Account";
                    end;
                    "NS_No." := PP_PassJobPlanningLine."No.";
                    NS_Description := PP_PassJobPlanningLine.Description;
                    NS_Quantity := PP_PassJobPlanningLine.Quantity;

                    //Determine the Unit of Measure code to use on this line.  If it can't be determined then leave blank
                    PP_JobsSetup.GET();
                    if PP_JobsSetup."NS_Subcontract Use of UOM" <> PP_JobsSetup."NS_Subcontract Use of UOM"::None then
                        if PP_JobsSetup."NS_Subcontract Use of UOM" = PP_JobsSetup."NS_Subcontract Use of UOM"::"Always Default" then
                            "NS_Unit of Measure Code" := PP_JobsSetup."NS_Subcontract Default UOM"
                        else
                            if PP_PassJobPlanningLine."Unit of Measure Code" = '' then
                                "NS_Unit of Measure Code" := PP_JobsSetup."NS_Subcontract Default UOM"
                            else
                                "NS_Unit of Measure Code" := PP_PassJobPlanningLine."Unit of Measure Code";

                    "NS_Direct Unit Cost" := PP_PassJobPlanningLine."Direct Unit Cost (LCY)";
                    "NS_Unit Cost" := PP_PassJobPlanningLine."Unit Cost (LCY)";
                    "NS_Work Units" := PP_PassJobPlanningLine."NS_Work Units";
                    "NS_Work Unit of Measure" := PP_PassJobPlanningLine."NS_Work Unit of Measure";
                    PP_SubcontractHeader.GET(SubcontractNo);
                    "NS_Dimension Set ID" := PP_SubcontractHeader."NS_Dimension Set ID";
                    VALIDATE("NS_Unit Cost");
                    INSERT();
                    PP_PassJobPlanningLine."NS_Subcontract No." := SubcontractNo;
                    "NS_Job Planning Line No." := PP_PassJobPlanningLine."Line No.";
                    PP_PassJobPlanningLine.MODIFY();
                until PP_PassJobPlanningLine.NEXT() = 0;
        end;
    end;

    local procedure NS_CreatePurchaseOrderDetail(var PP_PassJobPlanningLine: Record "Job Planning Line"; PP_PurchOrderNo: Code[20]);
    var
        PP_PurchaseLine: Record "Purchase Line";
        PP_Job: Record Job;
        PP_JobsSetup: Record "Jobs Setup";
        PP_PurchaseHeader: Record "Purchase Header";
        PP_LastLineNo: Integer;
    begin
        with PP_PurchaseLine do begin
            PP_PurchaseHeader.GET(PP_PurchaseHeader."Document Type"::Order, PP_PurchOrderNo);
            if PP_PassJobPlanningLine.FINDSET then
                repeat
                    //Get the last Line no. in the purchase lines
                    RESET();
                    SETRANGE("Document Type", "Document Type"::Order);
                    SETRANGE("Document No.", PP_PurchOrderNo);
                    PP_LastLineNo := 0;
                    if FINDLAST() then
                        PP_LastLineNo := "Line No.";

                    //Make new purchase line record
                    INIT();
                    "Document Type" := PP_PurchaseHeader."Document Type";
                    "Document No." := PP_PurchaseHeader."No.";
                    PP_LastLineNo := PP_LastLineNo + 10000;
                    "Buy-from Vendor No." := PP_PurchaseHeader."Buy-from Vendor No.";
                    "Pay-to Vendor No." := PP_PurchaseHeader."Buy-from Vendor No.";
                    "Line No." := PP_LastLineNo;
                    "Job No." := PP_PassJobPlanningLine."Job No.";
                    "Job Task No." := PP_PassJobPlanningLine."Job Task No.";
                    PP_Job.NS_JobTaskNoToAPO(PP_PassJobPlanningLine."Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                    "NS_Job Cost Category" := PP_PassJobPlanningLine."NS_Cost Category";
                    case PP_PassJobPlanningLine.Type of
                        PP_PassJobPlanningLine.Type::Resource:
                            Type := Type::Resource;
                        PP_PassJobPlanningLine.Type::Item:
                            Type := Type::Item;
                        PP_PassJobPlanningLine.Type::"G/L Account":
                            Type := Type::"G/L Account";
                    end;
                    "No." := PP_PassJobPlanningLine."No.";
                    Description := PP_PassJobPlanningLine.Description;
                    "Description 2" := PP_PassJobPlanningLine."Description 2";
                    VALIDATE(Quantity, PP_PassJobPlanningLine.Quantity);
                    "Unit of Measure Code" := PP_PassJobPlanningLine."Unit of Measure Code";
                    "NS_Direct Unit Cost (LCY)" := PP_PassJobPlanningLine."Direct Unit Cost (LCY)";
                    "Unit Cost" := PP_PassJobPlanningLine."Unit Cost";
                    VALIDATE("Unit Cost (LCY)", PP_PassJobPlanningLine."Unit Cost (LCY)");
                    "NS_Work Units" := PP_PassJobPlanningLine."NS_Work Units";
                    "NS_Work Unit of Measure" := PP_PassJobPlanningLine."NS_Work Unit of Measure";
                    "Dimension Set ID" := PP_PassJobPlanningLine."NS_Dimension Set ID";
                    "Bin Code" := PP_PassJobPlanningLine."Bin Code";
                    "Currency Code" := PP_PassJobPlanningLine."Currency Code";
                    "Gen. Bus. Posting Group" := PP_PassJobPlanningLine."Gen. Bus. Posting Group";
                    "Gen. Prod. Posting Group" := PP_PassJobPlanningLine."Gen. Prod. Posting Group";
                    "Location Code" := PP_PassJobPlanningLine."Location Code";
                    "Shortcut Dimension 1 Code" := PP_PassJobPlanningLine."NS_Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PP_PassJobPlanningLine."NS_Shortcut Dimension 2 Code";
                    "NS_Subcontract No." := PP_PassJobPlanningLine."NS_Subcontract No.";
                    "Variant Code" := PP_PassJobPlanningLine."Variant Code";
                    "NS_Work Type Code" := PP_PassJobPlanningLine."Work Type Code";
                    "NS_Currency Factor" := PP_PassJobPlanningLine."Currency Factor";
                    "Job Currency Factor" := PP_PassJobPlanningLine."Currency Factor";
                    "Job Line Amount" := PP_PassJobPlanningLine."Line Amount";
                    "Job Line Amount (LCY)" := PP_PassJobPlanningLine."Line Amount (LCY)";
                    "Job Line Discount %" := PP_PassJobPlanningLine."Line Discount %";
                    "Job Line Discount Amount" := PP_PassJobPlanningLine."Line Discount Amount";
                    "Job Line Disc. Amount (LCY)" := PP_PassJobPlanningLine."Line Discount Amount (LCY)";
                    "VAT %" := PP_PassJobPlanningLine."VAT %";
                    "VAT Base Amount" := PP_PassJobPlanningLine."VAT Line Amount";
                    "NS_Line Type" := PP_PassJobPlanningLine."Line Type";
                    INSERT();
                until PP_PassJobPlanningLine.NEXT = 0;
        end;
    end;
}

