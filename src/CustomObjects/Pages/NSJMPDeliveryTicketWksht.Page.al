page 14021428 "NS_JMP Delivery Ticket Wksht"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Worksheet;
    Caption = 'JMP Delivery Ticket Wksht';
    Permissions = TableData "NS_Export/Import Excel Header" = rimd,
                  TableData "NS_Export / Import Excel Line" = rimd;
    RefreshOnActivate = true;
    SourceTable = "NS_Job Material Planning";
    SourceTableView = WHERE("NS_Total Quantity Staged" = FILTER(> 0));
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            field("Worksheet Job No."; Rec."NS_Worksheet Job No.")
            {
                ApplicationArea = All;
                Lookup = true;
                LookupPageID = "Job List";
                TableRelation = Job."No.";
                ToolTip = 'Specifies the Worksheet Job No.';
            }
            repeater(Group)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Type';
                }
                field("Part No."; Rec."NS_Part No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Part No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field("Total Quantity Staged"; Rec."NS_Total Quantity Staged")
                {
                    ApplicationArea = All;
                    Caption = 'Total Qty. Avail. to Ship';

                    ToolTip = 'Total Qty. Avail. to Ship';
                    Editable = false;
                }
                field("Inventory Qty. Staged"; Rec."NS_Inventory Qty. Staged")
                {
                    ApplicationArea = All;
                    Caption = 'Available from Staged Inventory';

                    ToolTip = 'Available from Staged Inventory';
                    Editable = false;
                    Enabled = false;

                    trigger OnAssistEdit();
                    var
                        JobJnlTbl: Record "Job Journal Line";
                        JobJnlPge: Page "Job Journal";
                    begin
                    end;
                }
                field("Invt. Qty. to Ship"; Rec."NS_Invt. Qty. to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Ship Qty';

                    ToolTip = 'Inventory Ship Qty';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate();
                    begin
                        if "NS_Invt. Qty. to Ship" > "NS_Inventory Qty. Staged" then begin
                            MESSAGE(STRSUBSTNO(Text0001, "NS_Inventory Qty. Staged"));
                            "NS_Invt. Qty. to Ship" := 0;
                            "NS_Total Qty. Ready to Ship" := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                        end else begin
                            "NS_Total Qty. Ready to Ship" := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                        end;
                        if "NS_Invt. Qty. to Ship" <> xRec."NS_Invt. Qty. to Ship" then
                            MODIFY;
                    end;
                }
                field("PO Qty Staged"; Rec."NS_PO Qty Staged")
                {
                    ApplicationArea = All;
                    Caption = 'Available From Staged PO''s';

                    ToolTip = 'Available From Staged PO''s';
                    Editable = false;
                }
                field("PO Qty. to Ship"; Rec."NS_PO Qty. to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'PO Ship Qty.';

                    ToolTip = 'PO Ship Qty.';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate();
                    begin
                        if "NS_PO Qty. to Ship" > "NS_PO Qty Staged" then begin
                            MESSAGE(STRSUBSTNO(tEXT0002Lbl, "NS_PO Qty Staged"));
                            "NS_PO Qty. to Ship" := 0;
                            "NS_Total Qty. Ready to Ship" := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                        end else begin
                            "NS_Total Qty. Ready to Ship" := "NS_Invt. Qty. to Ship" + "NS_PO Qty. to Ship";
                        end;
                        if "NS_PO Qty. to Ship" <> xRec."NS_PO Qty. to Ship" then
                            MODIFY;
                    end;
                }
                field("Total Quantity Ready to Ship"; Rec."NS_Total Qty. Ready to Ship")
                {
                    ApplicationArea = All;
                    Caption = 'Total Qty. to Ship';

                    ToolTip = 'Total Qty. to Ship';
                    Editable = false;
                }
                field("Box Text"; Rec."NS_Box Text")
                {
                    ApplicationArea = All;
                    Caption = 'Box ID';
                    ToolTip = 'Box Text';
                }
                field("Job Site Vndr Qty"; Rec."NS_Job Site Vndr Qty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Site Vndr Qty';
                }
                field("Job Site From Inv."; Rec."NS_Job Site From Inv.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Site From Inv.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(PrintDeliveryTicket)
                {
                    ApplicationArea = All;
                    Caption = 'Print Job Delivery Ticket';

                    ToolTip = 'Print Job Delivery Ticket';
                    Ellipsis = true;
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        DeliveryTicket: Report "NS_Delivery Ticket JMP";
                        lJobMatPlan: Record "NS_Job Material Planning";
                    begin
                        REPORT.RUN(14021402, true, false, Rec);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        if "NS_Invt. Qty. to Ship" = 0 then
            "NS_Invt. Qty. to Ship" := "NS_Inventory Qty. Staged";
        if "NS_PO Qty. to Ship" = 0 then
            "NS_PO Qty. to Ship" := "NS_PO Qty Staged";
        //"Total Quantity Ready to Ship" := "Inventory Qty. Staged" + "PO Qty Staged";
        VALIDATE("NS_Total Qty. Ready to Ship", "NS_Inventory Qty. Staged" + "NS_PO Qty Staged");
    end;

    trigger OnAfterGetRecord();
    begin
        if "NS_Invt. Qty. to Ship" = 0 then
            "NS_Invt. Qty. to Ship" := "NS_Inventory Qty. Staged";
        if "NS_PO Qty. to Ship" = 0 then
            "NS_PO Qty. to Ship" := "NS_PO Qty Staged";
        //"Total Quantity Ready to Ship" := "Inventory Qty. Staged" + "PO Qty Staged";
        VALIDATE("NS_Total Qty. Ready to Ship", "NS_Inventory Qty. Staged" + "NS_PO Qty Staged");
    end;

    var
        //JMP: Record "PP_Job Material Planning";
        Text0001: Label 'You Can''t Ship more that %1 units from Inventory';
        JobNo: Code[20];
        // InventoryQtytoShip: Decimal;
        // PurchaseOrderQtytoShip: Decimal;
        // TotalQtytoShip: Decimal;
        // BoxID: Text[30];
        tEXT0002Lbl: Label 'You Can''t Ship more than %1 Units from Staged PO''s';

    procedure NS_InitVar(lJobNo: Code[20]);
    begin
        JobNo := lJobNo;
    end;
}

