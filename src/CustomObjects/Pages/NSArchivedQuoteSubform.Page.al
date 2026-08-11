page 14021439 "NS_Archived Quote Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-872.JS.1.0  13Sep2021

    AutoSplitKey = true;
    Caption = 'Archived Quote Subform';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021
    PageType = ListPart;
    ShowFilter = true;
    SourceTable = "NS_Job Quote Line Archive";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTableView = WHERE(NS_Type = FILTER(<> Template));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "No. 2";
                field("Quote No."; Rec."NS_Quote No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quote no.';
                }
                field("Quote Line No."; Rec."NS_Quote Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quote line no.';
                    Visible = false;
                }
                field("Attached to Line No."; Rec."NS_Attached to Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the attached to line no.';
                    Visible = false;
                }
                field("Attached Lines Exist"; Rec."NS_Attached Lines Exist")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies whether any attached lines exist.';
                    Visible = false;
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    OptionCaption = '" ,G/L Account,Item,Resource,Task"';
                    ToolTip = 'Specifies the type.';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the no.';
                    Visible = false;
                }
                field("No. 2"; Rec."NS_No. 2")
                {
                    ApplicationArea = All;
                    Caption = 'Mfg. Item No.';
                    ToolTip = 'Specifies the no. 2.';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        NS_SearchItem;
                    end;
                }
                field("Manufacturer Code"; Rec."NS_Manufacturer Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the manugacturer code.';
                    Visible = false;
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant code.';
                }
                field("Category Code"; Rec."NS_Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                    Visible = false;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit of measure code.';
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code.';
                    Visible = false;
                }
                field("Tax Area Code"; Rec."NS_Tax Area Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax area code.';
                    Visible = false;
                }
                field("Tax Liable"; Rec."NS_Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies wether the line is tax liable.';
                    Visible = false;
                }
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cost category.';
                }
                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the revenue category.';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Quantity (Base)"; Rec."NS_Quantity (Base)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the quantity (base)';
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."NS_Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity per unit of measure.';
                    Visible = false;
                }
                field("Vendor No."; Rec."NS_Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor no.';
                }
                field("Vendor Name"; Rec."NS_Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor name.';
                }
                field("Vendor Contact"; Rec."NS_Vendor Contact")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the vendor contact.';
                    Visible = false;
                }
                field("Vendor Contact No."; Rec."NS_Vendor Contact No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the vendor contract no.';
                    Visible = false;
                }
                field("Vendor Quote No."; Rec."NS_Vendor Quote No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the vendor quote no.';
                    Visible = false;
                }
                field("Vendor Cost"; Rec."NS_Vendor Cost")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the vendor cost.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unit cost.';
                    Visible = false;
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total cost.';
                }
                field(Markup; Rec.NS_Markup)
                {
                    ApplicationArea = All;
                    Caption = 'Markup %';
                    ToolTip = 'Specifies the markup percentage.';
                }
                field("Item List Price"; Rec."NS_Item List Price")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the item list price.';
                    Visible = false;
                }
                field("Contract Price Found"; Rec."NS_Contract Price Found")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies whether the contract price has been found.';
                    Visible = false;
                }
                field("Unit Price"; Rec."NS_Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price.';
                }
                field("Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies whether to use the tax amount.';
                    Visible = false;
                }
                field("Total Price"; Rec."NS_Total Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total price.';
                }
                field("Line Discount Amount"; Rec."NS_Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount amount.';
                }
                field("Line Discount %"; Rec."NS_Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line discount percentage.';
                }
                field("Gross Margin %"; Rec."NS_Gross Margin %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross margin percentage.';
                }
                field("Gross Margin"; Rec."NS_Gross Margin")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the gross margin amount.';
                }
                field(Amount; Rec.NS_Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount.';
                }
                field("Sales Tax Amount"; Rec."NS_Sales Tax Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the sales tax amount.';
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."NS_Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount Including VAT';
                    Visible = false;
                }
                field("Sales Quote No."; Rec."NS_Sales Quote No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the sales quote no.';
                    Visible = false;

                    trigger OnLookup(VAr Text: Text): Boolean;
                    begin
                        if "NS_Sales Quote No." <> '' then
                            if SalesHeader.GET(SalesHeader."Document Type"::Quote, "NS_Sales Quote No.") then
                                PAGE.RUN(PAGE::"Sales Quote", SalesHeader);
                    end;
                }
                field("Sales Quote Line No."; Rec."NS_Sales Quote Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the sales quote line no.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("NS_Scope of &Work")
                {
                    ApplicationArea = All;
                    Caption = 'Scope of &Work';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "NS_Archived Quote ScopeofWork";
                    RunPageLink = "NS_Quote No." = FIELD("NS_Quote No."),
                                  NS_Revision = FIELD(NS_Revision);
                    ToolTip = 'View the scope of work.';
                }
                action("<NS_Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Task Lines';
                    ToolTip = 'View the task lines.';

                    trigger OnAction();
                    var
                        QTaskLine: Record "NS_Archived Quote Task";
                        QTaskLinePg: Page "NS_Archived Quote Task";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            QTaskLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            QTaskLine.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            QTaskLine.SETRANGE(NS_Revision, NS_Revision);
                        end else begin
                            QTaskLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            QTaskLine.SETRANGE(NS_Revision, NS_Revision);
                        end;
                        PAGE.RUN(1002, QTaskLine);
                    end;
                }
                action("<NS_Planning Lines Task>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Task';
                    Image = PlanningWorksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'View the planning lines by task.';

                    trigger OnAction();
                    var
                        PlanningLine: Record "NS_Archived QuotePlanningLine";
                        PlanningLinePg: Page "NS_Archived QuotePlanningLines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            PlanningLine.SETRANGE(NS_Revision, NS_Revision);
                        end else begin
                            PlanningLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE(NS_Revision, NS_Revision);
                        end;
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
                action("<NS_Planning Lines Single>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Single';
                    Enabled = false;
                    Image = Planning;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    ToolTip = 'View the single planning line.';
                    Visible = false;

                    trigger OnAction();
                    var
                        PlanningLine: Record "NS_Archived QuotePlanningLine";
                        PlanningLinePg: Page "NS_Archived QuotePlanningLines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("NS_Job Task No.", "NS_Job Task No.");
                            PlanningLine.SETRANGE(NS_Type, NS_Type);
                            PlanningLine.SETRANGE("NS_No.", "NS_No.");
                            PlanningLine.SETRANGE(NS_Revision, NS_Revision);
                        end else begin
                            PlanningLine.SETRANGE("NS_Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE(NS_Revision, NS_Revision);
                        end;
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_Type := xRec.NS_Type;
    end;

    var
        //QuoteHeader: Record "PP_Job Quote Header";
        SalesHeader: Record "Sales Header";
    //AttributeMgt: Codeunit "Job Quote Mgt.";
    //QuoteMgt: Codeunit "Job Quote Mgt.";
    //Text14021400Lbl: Label 'Line Type %1 is not allowed in this section.';

    procedure NS_SearchItem();
    var
        _No: Code[20];
    begin
    end;

    //SMPL Replaced "Job Task Lines" name reference to ID 1002
}

