page 14021348 "NS_ProjPro Service Role Center"
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
                part(Control1904652008; "Service Dispatcher Activities")
                {
                    ApplicationArea = All;
                }
                part(Control1100773000; NS_PPManagerActivities4)
                {
                    ApplicationArea = All;
                }
            }
            group(Control1900724708)
            {
                part(Control21; "My Job Queue")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = All;
                }
                part(Control1905989608; "My Items")
                {
                    ApplicationArea = All;
                }
                part(Control31; "Report Inbox Part")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                systempart(Control1901377608; MyNotes)
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
            action("NS_ervice Ta&sks")
            {
                ApplicationArea = All;
                Caption = 'Service Ta&sks';
                Image = ServiceTasks;
                RunObject = Report "Service Tasks";
            }
            action("NS_Service &Load Level")
            {
                ApplicationArea = All;
                Caption = 'Service &Load Level';
                Image = "Report";
                RunObject = Report "Service Load Level";
            }
            action("NS_Resource &Usage")
            {
                ApplicationArea = All;
                Caption = 'Resource &Usage';
                Image = "Report";
                RunObject = Report "Service Item - Resource Usage";
            }
            separator(Separator9)
            {
            }
            action("NS_Service I&tems Out of Warranty")
            {
                ApplicationArea = All;
                Caption = 'Service I&tems Out of Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            separator(Separator14)
            {
            }
            action("NS_Profit Service &Contracts")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Contracts';
                Image = "Report";
                RunObject = Report "Service Profit (Contracts)";
            }
            action("NS_Profit Service &Orders")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Orders';
                Image = "Report";
                RunObject = Report "Service Profit (Serv. Orders)";
            }
            action("NS_Profit Service &Items")
            {
                ApplicationArea = All;
                Caption = 'Profit Service &Items';
                Image = "Report";
                RunObject = Report "Service Profit (Service Items)";
            }
        }
        area(embedding)
        {
            action("NS_Service Contract Quotes")
            {
                ApplicationArea = All;
                Caption = 'Service Contract Quotes';
                RunObject = Page "Service Contract Quotes";
            }
            action(NS_ServiceContracts)
            {
                ApplicationArea = All;
                Caption = 'Service Contracts';
                Image = ServiceAgreement;
                RunObject = Page "Service Contracts";
            }
            action(NS_ServiceContractsOpen)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Image = Edit;
                RunObject = Page "Service Contracts";
                RunPageView = WHERE("Change Status" = FILTER(Open));
                ShortCutKey = 'Return';
            }
            action("NS_Service Quotes")
            {
                ApplicationArea = All;
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page "Service Quotes";
            }
            action("NS_Service Orders")
            {
                ApplicationArea = All;
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page "Service Orders";
            }
            action("NS_Standard Service Codes")
            {
                ApplicationArea = All;
                Caption = 'Standard Service Codes';
                Image = ServiceCode;
                RunObject = Page "Standard Service Codes";
            }
            action(NS_Loaners)
            {
                ApplicationArea = All;
                Caption = 'Loaners';
                Image = Loaners;
                RunObject = Page "Loaner List";
            }
            action(NS_Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(PP_Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                RunObject = Page "Vendor List";
            }
            action("NS_Service Items")
            {
                ApplicationArea = All;
                Caption = 'Service Items';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action(NS_Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action("NS_Item Journals")
            {
                ApplicationArea = All;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Item),
                                    Recurring = CONST(false));
            }
            action("NS_Requisition Worksheets")
            {
                ApplicationArea = All;
                Caption = 'Requisition Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST("Req."),
                                    Recurring = CONST(false));
            }
            action(NS_Jobs)
            {
                ApplicationArea = All;
                Caption = 'Jobs';
                RunObject = Page "Job List";
            }
            action(NS_Quotes)
            {
                ApplicationArea = All;
                Caption = 'Quotes';
                RunObject = Page "NS_Job Quote List";
            }
            action(NS_Subcontracts)
            {
                ApplicationArea = All;
                Caption = 'Subcontracts';
                Image = CalculateRemainingUsage;
                RunObject = Page "NS_Subcontract List";
            }
            action("NS_Progress Billings")
            {
                ApplicationArea = All;
                Caption = 'Progress Billings';
                Image = CalculateInvoiceDiscount;
                RunObject = Page "NS_Progress Billing List";
            }
        }
        area(sections)
        {
            group("NS_Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("NS_Posted Service Shipments")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Service Shipments";
                }
                action("NS_Posted Service Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Invoices';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Service Invoices";
                }
                action("NS_Posted Service Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Service Credit Memos';
                    RunObject = Page "Posted Service Credit Memos";
                }
            }
        }
        area(creation)
        {
            group("&Service")
            {
                Caption = '&Service';
                Image = Tools;
                action("NS_Service Contract &Quote")
                {
                    ApplicationArea = All;
                    Caption = 'Service Contract &Quote';
                    Image = AgreementQuote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract Quote";
                    RunPageMode = Create;
                }
                action("NS_Service &Contract")
                {
                    ApplicationArea = All;
                    Caption = 'Service &Contract';
                    Image = Agreement;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract";
                    RunPageMode = Create;
                }
                action("NS_Service Q&uote")
                {
                    ApplicationArea = All;
                    Caption = 'Service Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Quote";
                    RunPageMode = Create;
                }
                action("NS_Service &Order")
                {
                    ApplicationArea = All;
                    Caption = 'Service &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Order";
                    RunPageMode = Create;
                }
            }
            action("NS_Sales Or&der")
            {
                ApplicationArea = All;
                Caption = 'Sales Or&der';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
            }
            action("NS_Transfer &Order")
            {
                ApplicationArea = All;
                Caption = 'Transfer &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Transfer Order";
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
            action("NS_Service Tas&ks")
            {
                ApplicationArea = All;
                Caption = 'Service Tas&ks';
                Image = ServiceTasks;
                RunObject = Page "Service Tasks";
            }
            action("NS_C&reate Contract Service Orders")
            {
                ApplicationArea = All;
                Caption = 'C&reate Contract Service Orders';
                Image = "Report";
                RunObject = Report "Create Contract Service Orders";
            }
            action("NS_Create Contract In&voices")
            {
                ApplicationArea = All;
                Caption = 'Create Contract In&voices';
                Image = "Report";
                RunObject = Report "Create Contract Invoices";
            }
            action("NS_Post &Prepaid Contract Entries")
            {
                ApplicationArea = All;
                Caption = 'Post &Prepaid Contract Entries';
                Image = "Report";
                RunObject = Report "Post Prepaid Contract Entries";
            }
            separator(Separator27)
            {

            }
            action("NS_Order Pla&nning")
            {
                ApplicationArea = All;
                Caption = 'Order Pla&nning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("NS_St&andard Service Codes")
            {
                ApplicationArea = All;
                Caption = 'St&andard Service Codes';
                Image = ServiceCode;
                RunObject = Page "Standard Service Codes";
            }
            action("NS_Dispatch Board")
            {
                ApplicationArea = All;
                Caption = 'Dispatch Board';
                Image = ListPage;
                RunObject = Page "Dispatch Board";
            }
            separator(History)
            {
                Caption = 'History';

                IsHeader = true;
            }
            action("NS_Item &Tracing")
            {
                ApplicationArea = All;
                Caption = 'Item &Tracing';

                ToolTip = 'Item &Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
            }
            action("NS_Navi&gate")
            {
                ApplicationArea = All;
                Caption = 'Navi&gate';

                ToolTip = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

