page 14021362 "NS_ProjPro Purc.ManRoleCenter"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1907662708; "Purchase Agent Activities")
                {
                    ApplicationArea = All;
                }
                part(Control1100773001; "NS_Progress Payment Statistics")
                {
                    ApplicationArea = All;
                }
                part(Control1902476008; "My Vendors")
                {
                    ApplicationArea = All;
                }
            }
            group(Control1900724708)
            {
                part(Control25; "Purchase Performance")
                {
                    ApplicationArea = All;
                }
                part(Control21; "Inventory Performance")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            //PPDA.1.0.TBA Start
            // action("Top __ Vendor List")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Top __ Vendor List';
            //     RunObject = Report "Top __ Vendor List";
            // }
            // action("Vendor/Item Statistics")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Vendor/Item Statistics';
            //     RunObject = Report "Vendor/Item Statistics";
            // }
            //PPDA.1.0.TBA End
            separator(Separator28)
            {
            }

            //PPDA.1.0.TBA Start
            // action("Availability Projection")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Availability Projection';
            //     RunObject = Report "Availability Projection";
            // }
            // action("Purchase Order Status")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Purchase Order Status';
            //     RunObject = Report "Purchase Order Status";
            // }
            // action("Vendor Purchases by Item")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Vendor Purchases by Item';
            //     RunObject = Report "Vendor Purchases by Item";
            // }
            // action("Item Cost and Price List")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Item Cost and Price List';
            //     RunObject = Report "Item Cost and Price List";
            // }
            //PPDA.1.0.TBA End
            separator(Separator1020000)
            {
            }
            //PPDA.1.0.TBA Start
            // action("Outstanding Order Stat. by PO")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Outstanding Order Stat. by PO';
            //     Image = "Report";
            //     RunObject = Report "Outstanding Order Stat. by PO";
            // }
            // action("Outstanding Purch. Order Aging")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Outstanding Purch. Order Aging';
            //     Image = "Report";
            //     RunObject = Report "Outstanding Purch. Order Aging";
            // }
            // action("Outstanding Purch.Order Status")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Outstanding Purch.Order Status';
            //     Image = "Report";
            //     RunObject = Report "Outstanding Purch.Order Status";
            // }
            // action("Purchase Advice")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Purchase Advice';
            //     Image = "Report";
            //     RunObject = Report "Purchase Advice";
            // }
            //PPDA.1.0.TBA End
        }
        area(embedding)
        {
            action(PurchaseOrders)
            {
                ApplicationArea = All;
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(PurchaseOrdersPendConf)
            {
                ApplicationArea = All;
                Caption = 'Pending Confirmation';
                RunObject = Page "Purchase Order List";
                RunPageView = WHERE(Status = FILTER(Open));
            }
            action(PurchaseOrdersPartDeliv)
            {
                ApplicationArea = All;
                Caption = 'Partially Delivered';
                RunObject = Page "Purchase Order List";
                RunPageView = WHERE(Status = FILTER(Released),
                                    Receive = FILTER(true),
                                    "Completely Received" = FILTER(false));
            }
            action("Purchase Quotes")
            {
                ApplicationArea = All;
                Caption = 'Purchase Quotes';
                RunObject = Page "Purchase Quotes";
            }
            action("Blanket Purchase Orders")
            {
                ApplicationArea = All;
                Caption = 'Blanket Purchase Orders';
                RunObject = Page "Blanket Purchase Orders";
            }
            action("Purchase Invoices")
            {
                ApplicationArea = All;
                Caption = 'Purchase Invoices';
                RunObject = Page "Purchase Invoices";
            }
            action("Purchase Return Orders")
            {
                ApplicationArea = All;
                Caption = 'Purchase Return Orders';
                RunObject = Page "Purchase Return Order List";
            }
            action("Purchase Credit Memos")
            {
                ApplicationArea = All;
                Caption = 'Purchase Credit Memos';
                RunObject = Page "Purchase Credit Memos";
            }
            action("Assembly Orders")
            {
                ApplicationArea = All;
                Caption = 'Assembly Orders';
                RunObject = Page "Assembly Orders";
            }
            action("Sales Orders")
            {
                ApplicationArea = All;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action("Nonstock Items")
            {
                ApplicationArea = All;
                Caption = 'Nonstock Items';
                Image = NonStockItem;
                RunObject = Page "Catalog Item List";
            }
            action("Stockkeeping Units")
            {
                ApplicationArea = All;
                Caption = 'Stockkeeping Units';
                Image = SKU;
                RunObject = Page "Stockkeeping Unit List";
            }
            action("Purchase Analysis Reports")
            {
                ApplicationArea = All;
                Caption = 'Purchase Analysis Reports';
                RunObject = Page "Analysis Report Purchase";
                RunPageView = WHERE("Analysis Area" = FILTER(Purchase));
            }
            action("Inventory Analysis Reports")
            {
                ApplicationArea = All;
                Caption = 'Inventory Analysis Reports';
                RunObject = Page "Analysis Report Inventory";
                RunPageView = WHERE("Analysis Area" = FILTER(Inventory));
            }
            action("Item Journals")
            {
                ApplicationArea = All;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Item),
                                    Recurring = CONST(false));
            }
            action("Purchase Journals")
            {
                ApplicationArea = All;
                Caption = 'Purchase Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Purchases),
                                    Recurring = CONST(false));
            }
            action(RequisitionWorksheets)
            {
                ApplicationArea = All;
                Caption = 'Requisition Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST("Req."),
                                    Recurring = CONST(false));
            }
            action(SubcontractingWorksheets)
            {
                ApplicationArea = All;
                Caption = 'Subcontracting Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST("For. Labor"),
                                    Recurring = CONST(false));
            }
            action("Standard Cost Worksheets")
            {
                ApplicationArea = All;
                Caption = 'Standard Cost Worksheets';
                RunObject = Page "Standard Cost Worksheet Names";
            }
            action(Jobs)
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                RunObject = Page "Job List";
            }
            action(Quotes)
            {
                ApplicationArea = All;
                Caption = 'Quotes';
                RunObject = Page "NS_Job Quote List";
            }
            action(Subcontracts)
            {
                ApplicationArea = All;
                Caption = 'Subcontracts';
                Image = CalculateRemainingUsage;
                RunObject = Page "NS_Subcontract List";
            }
            action("Progress Billings")
            {
                ApplicationArea = All;
                Caption = 'Progress Billings';
                Image = CalculateInvoiceDiscount;
                RunObject = Page "NS_Progress Billing List";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Assembly Orders';
                    RunObject = Page "Posted Assembly Orders";
                }
            }
        }
        area(creation)
        {
            action("Purchase &Quote")
            {
                ApplicationArea = All;
                Caption = 'Purchase &Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
            }
            action("Purchase &Invoice")
            {
                ApplicationArea = All;
                Caption = 'Purchase &Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Purchase &Order")
            {
                ApplicationArea = All;
                Caption = 'Purchase &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Return Order")
            {
                ApplicationArea = All;
                Caption = 'Purchase &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("&Purchase Journal")
            {
                ApplicationArea = All;
                Caption = '&Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action("Item &Journal")
            {
                ApplicationArea = All;
                Caption = 'Item &Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            action("Order Plan&ning")
            {
                ApplicationArea = All;
                Caption = 'Order Plan&ning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Separator38)
            {
            }

            action("Requisition &Worksheet")
            {
                ApplicationArea = All;
                Caption = 'Requisition &Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST("Req."),
                                    Recurring = CONST(false));
            }
            action("Pur&chase Prices")
            {
                ApplicationArea = All;
                Caption = 'Pur&chase Prices';
                Image = Price;
                RunObject = Page "Purchase Prices";
            }
            action("Purchase &Line Discounts")
            {
                ApplicationArea = All;
                Caption = 'Purchase &Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Purchase Line Discounts";
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = All;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }

    // SMPL - renamed "Nonstock Item List" to "Catalog Item List"
}

