page 14021406 "NS_Job Quote Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PPAL-147.AS.2.0 30SEPT2020 Changed Loation of fields of after Unit of measure code 
    //PPAL-147.AS.2.0 30SEPT2020 Added Corrected captions also
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields 
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
    AutoSplitKey = true;
    Caption = 'Quote Subform';
    PageType = ListPart;
    SourceTable = "NS_Job Quote Line";
    SourceTableView = WHERE(NS_Type = FILTER(<> Template));
    UsageCategory = Lists;
    ApplicationArea = Jobs;

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
                    ToolTip = 'Specifies the Quote No.';
                }
                field("Quote Line No."; Rec."NS_Quote Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Quote Line No.';
                    Visible = false;
                }
                field("Attached to Line No."; Rec."NS_Attached to Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the Attached to Line No.';
                    Visible = false;
                }
                field("Attached Lines Exist"; Rec."NS_Attached Lines Exist")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Attached Lines Exist';
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
                    OptionCaption = ' ,G/L Account,Item,Resource,Task';//PPAL-147.AS.2.0 30SEPT2020 Added
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                        if NS_Type = NS_Type::Template then begin
                            MESSAGE(STRSUBSTNO(Text14021400Lbl, FORMAT(NS_Type::Template)));
                            NS_Type := NS_Type::Item;
                        end;
                        if NS_Type <> NS_Type::Template then
                            QuoteMgt.NS_OnValidateType(Rec, xRec);
                    end;
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                    Visible = true;

                    trigger OnValidate();
                    begin
                        QuoteHeader.GET("NS_Quote No.");

                        CurrPage.SAVERECORD();
                        QuoteMgt.NS_OnValidateNoQuoteLine(Rec);
                        CurrPage.UPDATE(false);
                    end;

                }
                //PRJ-492.RS.1.0 11May2021 Start
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';

                    trigger OnValidate();
                    begin
                        if NS_Type = NS_Type::" " then
                            if NS_Description <> xRec.NS_Description then begin
                                QuoteHeader.GET("NS_Quote No.");
                                CurrPage.SAVERECORD();
                                QuoteMgt.NS_OnValidateDescription(Rec);
                                CurrPage.SAVERECORD();
                            end;
                    end;
                }
                //PRJ-492.N.S.1.0 Start
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category';
                    Caption = 'Cost Category';
                }
                //PRJ-492.N.S.1.0 End
                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Category';
                    Caption = 'Revenue Category';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the Quantity';
                    Caption = 'Quantity';
                }
                //PRJ-492.RS.1.0 11May2021 end
                field("No. 2"; Rec."NS_No. 2")
                {
                    ApplicationArea = All;
                    Caption = 'No. 2';
                    ToolTip = 'No. 2';
                    Visible = false; //PRJ-492.AS.1.0

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        NS_SearchItem();
                    end;

                    trigger OnValidate();
                    begin
                        QuoteHeader.GET("NS_Quote No.");

                        case NS_Type of
                            NS_Type::" ",
                            NS_Type::Item:
                                begin
                                    NS_Type := NS_Type::Item;
                                    QuoteMgt.NS_ValidateNo2OnQuoteLine(Rec);
                                end;
                            NS_Type::"G/L Account",
                          NS_Type::Resource:
                                "NS_No." := "NS_No. 2";
                        end;
                        CurrPage.SAVERECORD();
                        QuoteMgt.NS_OnValidateNoQuoteLine(Rec);
                        CurrPage.UPDATE(false);
                    end;
                }
                field("Manufacturer Code"; Rec."NS_Manufacturer Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Manufacturer Code';
                    Caption = 'Manufacturer Code';

                    Visible = false;
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Caption = 'Variant Code';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field("Category Code"; Rec."NS_Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Category Code';
                    Caption = 'Category Code';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                //PPAL-147.AS.2.0 30SEPT2020 - start
                field("PP_Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Unit Cost';
                    Visible = true;
                }
                field("PP_Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Total Cost';
                }
                //PPAL-147.AS.2.0 30SEPT2020 - end
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                    Caption = 'Location Code'; //PPAL-29.MS.1.0
                    Visible = false;
                }
                field("Tax Area Code"; Rec."NS_Tax Area Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Area Code';
                    Visible = false;
                    Caption = 'Tax Area Code';
                }
                field("Tax Liable"; Rec."NS_Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Liable';
                    Visible = false;
                    Caption = 'Tax liable';
                }
                //PRJ-492.N.S.1.0 Start
                // field("Cost Category"; Rec."NS_Cost Category")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Cost Category';
                //     Caption = 'Cost Category';
                // }
                //PRJ-492.N.S.1.0 End
                field("Quantity (Base)"; Rec."NS_Quantity (Base)")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity (Base)';
                    Editable = false;
                    ToolTip = 'Specifies the Quantity (Base)';
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."NS_Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qty. per Unit of Measure';
                    Caption = 'Qty. per Unit of Measure';
                    Visible = false;
                }
                field("Vendor No."; Rec."NS_Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor No.';
                    Caption = 'Vendor No.';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field("Vendor Name"; Rec."NS_Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor Name';
                    Caption = 'Vendor Name';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field("Vendor Contact"; Rec."NS_Vendor Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Contact';
                    Enabled = false;
                    ToolTip = 'Specifies the "Vendor Contact';
                    Visible = false;
                }
                field("Vendor Contact No."; Rec."NS_Vendor Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Contact No.';
                    Enabled = false;
                    ToolTip = 'Specifies the Vendor Contact No.';
                    Visible = false;
                }
                field("Vendor Quote No."; Rec."NS_Vendor Quote No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Quote No.';
                    Enabled = false;
                    ToolTip = 'Specifies the Vendor Quote No.';
                    Visible = false;
                }
                field("Vendor Cost"; Rec."NS_Vendor Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Cost';
                    Enabled = false;
                    ToolTip = 'Specifies the Vendor Cost';
                    Visible = false;
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost';
                    Editable = true;
                    ToolTip = 'Specifies the Unit Cost';
                    Visible = false;
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Cost';
                    Editable = false;
                    ToolTip = 'Specifies the Total Cost';
                    Visible = false;//PRJ-492.RS.1.0 11May2021
                }
                field(Markup; Rec.NS_Markup)
                {
                    ApplicationArea = All;
                    Caption = 'Markup %';
                    // ToolTip = 'Markup %'; //PRJ-1579.RM.1.0 commented
                    ToolTip = 'Markup% is automatically calculated based on formula ((Total Price - Total Cost)/Total Cost*100). Also, manual entry of "Markup %" is allowed. ';//PRJ-1579.RM.1.0
                }
                field("Item List Price"; Rec."NS_Item List Price")
                {
                    ApplicationArea = All;
                    Caption = 'Item List Price';
                    Enabled = false;
                    ToolTip = 'Specifies the Item List Price';
                    Visible = false;
                }
                field("Contract Price Found"; Rec."NS_Contract Price Found")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Contract Price Found';
                    Caption = 'Contract price Found';
                    Visible = false;
                }
                field("Unit Price"; Rec."NS_Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                    ToolTip = 'Specifies the Unit Price';
                }
                field("Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    Caption = 'Use Tax Amount';
                    ToolTip = 'Specifies the Use Tax Amount';
                    Visible = false;
                }
                field("Total Price"; Rec."NS_Total Price")
                {
                    ApplicationArea = All;
                    Caption = 'Total Price';
                    Editable = false;
                    ToolTip = 'Specifies the Total Price';
                }
                field("Line Discount %"; Rec."NS_Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount %';
                    Caption = 'Line Discount %';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field("Line Discount Amount"; Rec."NS_Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount Amount';
                    Caption = 'Line Discount Amount';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field("Gross Margin %"; Rec."NS_Gross Margin %")
                {
                    ApplicationArea = All;
                    Caption = 'Gross Margin %';
                    ToolTip = 'Specifies the Gross Margin %';
                }
                field("Gross Margin"; Rec."NS_Gross Margin")
                {
                    ApplicationArea = All;
                    Caption = 'Gross Margin';
                    Editable = false;
                    ToolTip = 'Specifies the Gross Margin';
                    //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field(Amount; NS_Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount';
                    Caption = 'Amount';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field("Sales Tax Amount"; Rec."NS_Sales Tax Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Tax Amount';
                    Editable = false;
                    ToolTip = 'Specifies the Sales Tax Amount';
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."NS_Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount Including VAT';
                    Visible = false;
                    Caption = 'Amount Including VAT';
                }
                field("Sales Quote No."; Rec."NS_Sales Quote No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote No.';
                    Editable = false;
                    ToolTip = 'Specifies the Sales Quote No.';
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
                    ToolTip = 'Specifies the Sales Quote Line No.';
                    Visible = false;
                    Caption = 'Sales Quote Line No.';
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
                action(NS_Attributes)
                {
                    ApplicationArea = All;
                    Caption = 'Attributes';
                    ToolTip = 'Attributes';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_Attribute Set Entry No." = 0 then
                            "NS_Attribute Set Entry No." := AttributeMgt.NS_GetNextAttributeSetEntryNo;
                        AttributeMgt.NS_ShowAttributeSetEntries("NS_Attribute Set Entry No.");
                    end;
                }
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    ToolTip = 'Dimensions';
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        QuoteMgt.NS_ShowDocDimForLine(Rec);
                    end;
                }
                action("NS_Feature Text")
                {
                    ApplicationArea = All;
                    Caption = 'Feature Text';
                    ToolTip = 'Feature Text';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "NS_Job Quote Feature Text";
                }
                action("NS_Scope of &Work")
                {
                    ApplicationArea = All;
                    Caption = 'Scope of &Work';
                    ToolTip = 'Scope Of Work';
                    Image = EditList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "NS_Job Quote Scope of Work";
                }
                action(NS_Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Tooltip = 'Comments';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Comment List";
                }
                action("<NS_Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Task Lines';
                    Image = PlanningWorksheet;
                    ToolTip = 'Task Lines';

                    trigger OnAction();
                    var
                        QTaskLine: Record "Job Task";
                    //QTaskLinePg: Page "Job Task List";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            QTaskLine.SETRANGE("Job No.", "NS_Quote No.");
                            QTaskLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                        end else
                            QTaskLine.SETRANGE("Job No.", "NS_Quote No.");
                        PAGE.RUN(1002, QTaskLine);
                    end;
                }
                action("<NS_Planning Lines Task>")
                {
                    ApplicationArea = All;
                    ToolTip = 'Planning Lines Task';
                    Caption = 'Planning Lines Task';
                    Image = PlanningWorksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    var
                        PlanningLine: Record "Job Planning Line";
                    //PlanningLinePg: Page "Job Planning Lines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                        end else
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
                action("<NS_Planning Lines Single>")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Lines Single';
                    ToolTip = 'Planning Lines Single';
                    Enabled = false;
                    Image = Planning;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction();
                    var
                        PlanningLine: Record "Job Planning Line";
                    //PlanningLinePg: Page "Job Planning Lines";
                    begin
                        if NS_Type <> NS_Type::Template then begin
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                            PlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                            PlanningLine.SETRANGE(Type, NS_Type);
                            PlanningLine.SETRANGE("No.", "NS_No.");
                        end else
                            PlanningLine.SETRANGE("Job No.", "NS_Quote No.");
                        PAGE.RUN(PAGE::"Job Planning Lines", PlanningLine);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean;
    begin
        QuoteMgt.NS_OnDeleteQuoteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_Type := xRec.NS_Type;
    end;

    var
        QuoteHeader: Record "NS_Job Quote Header";
        SalesHeader: Record "Sales Header";
        AttributeMgt: Codeunit "NS_Job Quote Mgt.";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        Text14021400Lbl: Label 'Line Type %1 is not allowed in this section.', Comment = '%1=PP_Type::Template';

    procedure NS_SearchItem();
    var
        _No: Code[20];
    begin
        QuoteHeader.GET("NS_Quote No.");

        if NS_Type = NS_Type::Item then
            _No := QuoteMgt.NS_SearchItemNo("NS_No.")
        else
            _No := QuoteMgt.NS_SearchNo(DATABASE::"NS_Job Quote Line", NS_Type, "NS_No.");
        if _No <> '' then begin
            VALIDATE("NS_No.", _No);
            CurrPage.SAVERECORD();
            QuoteMgt.NS_OnValidateNoQuoteLine(Rec);
        end;
        CurrPage.UPDATE(false);
    end;

    //SMPL Replaced "Job Task Lines" name reference to ID
    //PPAL-147.AS.2.0 30SEPT2020 - start
    trigger OnModifyRecord(): Boolean
    begin
        if xRec."NS_Job Task No." <> '' then begin
            if xRec."NS_Job Task No." <> Rec."NS_Job Task No." then
                ERROR('You cannot change the %1, %2, %3 of this %4.', FIELDCAPTION("NS_Quote No."), FIELDCAPTION("NS_Quote Line No."), FIELDCAPTION("NS_Job Task No."), TABLECAPTION);
        end;
    end;
    //PPAL-147.AS.2.0 30SEPT2020 - end
}

