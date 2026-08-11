page 14021438 "NS_Archived Job Quote"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-872.JS.1.0  13Sep2021

    Caption = 'Archived Job Quote';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Supplemental,Tasks,Team,Workflow,Jobs';
    SourceTable = "NS_Job Quote Header Archive";
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Quote No."; Rec."NS_Quote No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quote No.';
                }
                field(Revision; Rec.NS_Revision)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Revision';
                    Visible = false;
                }
                field("Description/Nickname"; Rec."NS_Description/Nickname")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Description/Nickname';
                }
                field("Quote Type Code"; Rec."NS_Quote Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quote Type Code';
                    Visible = false;
                }
                field("Proposal Date"; Rec."NS_Proposal Date")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal Due Date';

                    ToolTip = 'Proposal Due Date';
                    Visible = true;
                }
                field("Link-to Quote No."; Rec."NS_Link-to Quote No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Link-to Quote No.';
                }
                field("Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';

                    ToolTip = 'Sell-to Customer No.';
                    Importance = Promoted;
                }
                field("Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';

                    ToolTip = 'Sell-to Customer Name';
                    Importance = Promoted;
                }
                field("Contract Line Method"; Rec."NS_Contract Line Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contract Line Method';
                    Visible = false;
                }
                field("Salesperson Code"; Rec."NS_Salesperson Code New")//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Code';
                }
                field("Salesperson Name"; Rec."NS_Salesperson Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Name';
                }
                field("Salesperson/User ID"; Rec."NS_Salesperson/User ID")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'USER ID';
                }
                field("Free Freight"; Rec."NS_Free Freight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Free Freight';
                    Visible = false;
                }
                field("Contact No."; Rec."NS_Contact No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Contact No.';
                }
                field("Contact Name"; Rec."NS_Contact Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Contact Name';
                }
                field("Sell-to Customer Template Code"; Rec."NS_Sell-toCustomerTemplateCode")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Sell-to Customer Template Code';
                    Visible = false;
                }
                field("Probability to Close"; Rec."NS_Probability to Close")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Probability to Close';
                }
                field("Use Tax Liable"; Rec."NS_Use Tax Liable")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the Use Tax Liable';
                    Visible = false;
                }
                field("Equipment Only"; Rec."NS_Equipment Only")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the Equipment Only';
                    Visible = false;
                }
                field(Template; NS_Template)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Template';
                }
                field("Preserve Pricing Flag"; Rec."NS_Preserve Pricing Flag")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the Preserve Pricing Flag';
                    Visible = false;
                }
                field("Estimated Month to Close"; Rec."NS_Estimated Month to Close")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Estimated Month to Close';
                }
                field("Estimated Month to Bill"; Rec."NS_Estimated Month to Bill")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Estimated Month to Bill';
                }
                field("Estimated % to Bill"; Rec."NS_Estimated % to Bill")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Estimated % to Bill';
                }
                field("Lump Sum"; Rec."NS_Lump Sum")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Lump Sum';
                }
                field(Status; NS_Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Status';
                }
                field("Job Ship-to Code"; Rec."NS_Job Ship-to Code")
                {
                    ApplicationArea = All;
                    TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("NS_Sell-to Customer No."));
                    ToolTip = 'Specifies the Job Ship-to Code';

                    trigger OnValidate();
                    begin
                        if "NS_Job Ship-to Code" > '' then begin
                            ShipToAddress.GET("NS_Sell-to Customer No.", "NS_Job Ship-to Code");
                            "NS_Job Address 1" := ShipToAddress.Address;
                            "NS_Job Address 2" := ShipToAddress."Address 2";
                            "NS_Job City" := ShipToAddress.City;
                            "NS_Job County" := ShipToAddress.County;
                            "NS_Job Post Code" := ShipToAddress."Post Code";
                            "NS_Job Country/Region Code" := ShipToAddress."Country/Region Code";
                        end else begin
                            "NS_Job Address 1" := '';
                            "NS_Job Address 2" := '';
                            "NS_Job City" := '';
                            "NS_Job County" := '';
                            "NS_Job Post Code" := '';
                            "NS_Job Country/Region Code" := '';
                        end;
                    end;
                }
                field("Job Address 1"; Rec."NS_Job Address 1")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job Address 1';
                }
                field("Job Address 2"; Rec."NS_Job Address 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job Address 2';
                }
                field("Job City"; Rec."NS_Job City")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job City';
                }
                field("Job County"; Rec."NS_Job County")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job County';
                }
                field("Job Post Code"; Rec."NS_Job Post Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job Post Code';
                }
                field("Job Country/Region Code"; Rec."NS_Job Country/Region Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Job Country/Region Code';
                }
                field("Billing Job Task No."; Rec."NS_Billing Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Billing Job Task No.';
                }
                field("Job Posting Group"; Rec."NS_Job Posting Group New")//PRJ-993.AS.1.0 18OCT2021 Add new field "NS_Job Posting Group New" and obslete pending old field "NS_Job Posting Group" for Job Quote header Archive
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Posting Group';
                }
                field("Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shortcut Dimension 2 Code';
                }
            }
            group("Order")
            {
                Caption = 'Order';
                Editable = false;
                Enabled = false;
                Visible = false;
                field("Requested Delivery Date"; Rec."NS_Requested Delivery Date")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Requested Delivery Date';
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Location Code';
                }
                field("Shipment Method Code"; Rec."NS_Shipment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipment Method Code';
                }
                field("Shipping Advice"; Rec."NS_Shipping Advice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipping Advice';
                }
                field("Sales Quote No."; Rec."NS_Sales Quote No.")
                {
                    ApplicationArea = All;
                    Caption = 'NAV Sales Quote No.';

                    ToolTip = 'NAV Sales Quote No.';
                    Editable = false;

                }
                field(SalesOrderNoOnOrderTab; Rec."NS_Sales Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Sales Order No.';
                }
                field("Date Converted to Order"; Rec."NS_Date Converted to Order")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Date Converted to Order';
                }
                field("External Document No."; Rec."NS_External Document No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the External Document No.';
                }
            }
            part(Lines; "NS_Archived Quote Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No."),
                              NS_Revision = FIELD(NS_Revision);
            }
            part("Task Totals"; "NS_Archived Quote Task Part")
            {
                ApplicationArea = All;
                Caption = 'Task Totals';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No."),
                              NS_Revision = FIELD(NS_Revision);
            }
            part("Segment Totals"; "NS_Archived Quote Segments")
            {
                ApplicationArea = All;
                Caption = 'Segment Totals';
                SubPageLink = "NS_Job No." = FIELD("NS_Quote No."),
                              NS_Revision = FIELD(NS_Revision);
            }
            group(Margins)
            {
                Caption = 'Margins';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Minimum Selling Price"; Rec."NS_Minimum Selling Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Minimum Selling Price';
                }
                field("Selling Price"; Rec."NS_Selling Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Selling Price';
                }
                field("Total Contract Price"; Rec."NS_Total Contract Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Price';
                }
                field("Use Tax Code"; Rec."NS_Use Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax Code';
                    Visible = false;
                }
                field("Minimum Selling Price G.M. %"; Rec."NS_Minimum Selling Price G.M.%")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Minimum Selling Price G.M. %';
                }
                field("Selling Price G.M. %"; Rec."NS_Selling Price G.M. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Selling Price G.M. %';
                }
                field("Total Contract Price G.M. %"; Rec."NS_Total Contract Price G.M. %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Price G.M. %';
                }
                field("Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Use Tax Amount';
                    Visible = false;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."NS_Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Bill-to Customer No.';
                }
                field("Bill-to Customer Name"; Rec."NS_Bill-to Customer Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Bill-to Customer Name';
                }
                field("Bill-to Name 2"; Rec."NS_Bill-to Name 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Name 2';
                }
                field("Bill-to Address"; Rec."NS_Bill-to Address")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Address';
                }
                field("Bill-to Address 2"; Rec."NS_Bill-to Address 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Address 2';
                }
                field("Bill-to City"; Rec."NS_Bill-to City")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to City';
                }
                field("Bill-to County"; Rec."NS_Bill-to County")
                {
                    ApplicationArea = All;
                    Caption = 'Bill-to State';

                    ToolTip = 'Bill-to State';
                    Importance = Additional;
                }
                field("Bill-to Post Code"; Rec."NS_Bill-to Post Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Post Code';
                }
                field("Bill-to Country/Region Code"; Rec."NS_Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Country/Region Code';
                }
                field("Bill-to Contact No."; Rec."NS_Bill-to Contact No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Contact No.';
                }
                field("Bill-to Customer Template Code"; Rec."NS_Bill-toCustomerTemplateCode")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the Bill-to Customer Template Code';
                }
                field("Payment Terms Code"; Rec."NS_Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payment Terms Code';
                }
                field("Deposit Required"; Rec."NS_Deposit Required")
                {
                    ApplicationArea = All;
                    Caption = 'Deposit Required $';

                    ToolTip = 'Deposit Required $';
                    DecimalPlaces = 0 : 2;
                    Visible = false;
                }
                field("Print Sales Tax"; Rec."NS_Print Sales Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Print Sales Tax';
                    Visible = false;
                }
                field("Tax Area Code"; Rec."NS_Tax Area Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Area Code';
                }
                field("Tax Liable"; Rec."NS_Tax Liable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Liable';
                }
                field("Tax Group Code"; Rec."NS_Tax Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Tax Group Code';
                }
                field("VAT Bus. Posting Group"; Rec."NS_VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT Bus. Posting Group';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."NS_VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT Prod. Posting Group';
                    Visible = false;
                }
                field("Use Tax SKU"; Rec."NS_Use Tax SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax SKU';
                    Visible = false;
                }
            }
            group(Job)
            {
                Caption = 'Job';
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Description"; Rec."NS_Job Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Description';
                }
                field("Job Type"; Rec."NS_Job Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job Type';
                    Visible = false;
                }
                field("Job Type Code"; Rec."NS_Job Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Type Code';
                }
                field("Job Class"; Rec."NS_Job Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Class';
                }
                field("Sub-Level to Job No."; Rec."NS_Sub-Level to Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub-Level to Job No.';
                }
                field("Owner No."; Rec."NS_Owner No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Owner No.';
                }
                field("Owner Name"; Rec."NS_Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Owner Name';
                }
                field("General Contractor No."; Rec."NS_General Contractor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the General Contractor No.';
                }
                field("General Contractor Name"; Rec."NS_General Contractor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "General Contractor Name';
                }
                field("Architect/Engineer No."; Rec."NS_Architect/Engineer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Architect/Engineer No.';
                }
                field("Architect/Engineer Name"; Rec."NS_Architect/Engineer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Architect/Engineer Name';
                }
                field("Project Manager No."; Rec."NS_Project Manager No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Project Manager No.';
                }
                field("Project Manager Name"; Rec."NS_Project Manager Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Project Manager Name';
                }
                field("Estimator No."; Rec."NS_Estimator No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimator No.';
                }
                field("Estimator Name"; Rec."NS_Estimator Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimator Name';
                }
                field("Date Submitted to Estimator"; Rec."NS_Date Submitted to Estimator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date Submitted to Estimator';
                }
                field("Retainage %"; Rec."NS_Retainage %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retainage %';
                }
                field("Certified Payroll"; Rec."NS_Certified Payroll")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Certified Payroll';
                    Visible = false;
                }
                field(Bond; Rec.NS_Bond)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bond';
                    Visible = false;
                }
                field("CCIP/OCIP/RCOIP Insurance"; Rec."NS_CCIP/OCIP/RCOIP Insurance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the CCIP/OCIP/RCOIP Insurance';
                    Visible = false;
                }
                field("Lien Waiver Required"; Rec."NS_Lien Waiver Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Lien Waiver Required';
                    Visible = false;
                }
                field("Billing Cutoff Day of Month"; Rec."NS_Billing Cutoff Day of Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Billing Cutoff Day of Month';
                    Visible = false;
                }
                field("Estimated Start Date"; Rec."NS_Estimated Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Project Start Date';

                    ToolTip = 'Project Start Date';
                    Importance = Promoted;
                }
                field("Estimated Completion Date"; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = All;
                    Caption = 'Project End Date';

                    ToolTip = 'Project End Date';
                    Importance = Promoted;
                }
            }
            group("Schedule of Values")
            {
                Caption = 'Schedule of Values';

                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                Visible = false;
                field("Schedule 1 Description"; Rec."NS_Schedule 1 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 1 Description';
                }
                field("Schedule 1 Percentage"; Rec."NS_Schedule 1 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 1 Percentage';
                }
                field("Schedule 1 Amount"; Rec."NS_Schedule 1 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 1 Amount';
                }
                field("Schedule 2 Description"; Rec."NS_Schedule 2 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 2 Description';
                }
                field("Schedule 2 Percentage"; Rec."NS_Schedule 2 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 2 Percentage';
                }
                field("Schedule 2 Amount"; Rec."NS_Schedule 2 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 2 Amount';
                }
                field("Schedule 3 Description"; Rec."NS_Schedule 3 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 3 Description';
                }
                field("Schedule 3 Percentage"; Rec."NS_Schedule 3 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Schedule 3 Percentage';
                }
                field("Schedule 3 Amount"; Rec."NS_Schedule 3 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 3 Amount';
                }
                field("Schedule 4 Description"; Rec."NS_Schedule 4 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 4 Description';
                }
                field("Schedule 4 Percentage"; Rec."NS_Schedule 4 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 4 Percentage';
                }
                field("Schedule 4 Amount"; Rec."NS_Schedule 4 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 4 Amount';
                }
                field("Schedule 5 Description"; Rec."NS_Schedule 5 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 5 Description';
                }
                field("Schedule 5 Percentage"; Rec."NS_Schedule 5 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 5 Percentage';
                }
                field("Schedule 5 Amount"; Rec."NS_Schedule 5 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 5 Amount';
                }
                field("Schedule 6 Description"; Rec."NS_Schedule 6 Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 6 Description';
                }
                field("Schedule 6 Percentage"; Rec."NS_Schedule 6 Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 6 Percentage';
                }
                field("Schedule 6 Amount"; Rec."NS_Schedule 6 Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Schedule 6 Amount';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Qu&ote")
            {
                Caption = 'Qu&ote';
                action("NS_Planning Lines Segment")
                {
                    ApplicationArea = All;
                    Image = Planning;
                    Promoted = true;
                    Caption = 'Planning Lines Segment';//PRJ-1102.GK.1.0 13Jan2022
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Planning Lines Segment';

                    trigger OnAction();
                    var
                        PlanningLines: Record "NS_Archived QuotePlanningLine";
                        PlanningLinesPg: Page "NS_Archived QuotePlanningLines";
                    begin
                        PlanningLinesPg.NS_InitVar("NS_Job No.", '', true, '', NS_Revision);
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL() = ACTION::OK then;
                    end;
                }
                action("NS_Planning Lines")
                {
                    ApplicationArea = All;
                    Image = PlanningWorksheet;
                    Promoted = true;
                    Caption = 'Planning Lines';//PRJ-1102.GK.1.0 13Jan2022
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Planning lines';

                    trigger OnAction();
                    var
                        PlanningLines: Record "NS_Archived QuotePlanningLine";
                        PlanningLinesPg: Page "NS_Archived QuotePlanningLines";
                    begin
                        PlanningLinesPg.NS_InitVar("NS_Job No.", '', false, '', NS_Revision);
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL = ACTION::OK then;
                    end;
                }
                action("<NS_Page Job Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Job &Task Lines';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Job Task lines';
                    PromotedIsBig = true;
                    RunObject = Page "NS_Archived Quote Task";
                    RunPageLink = "NS_Job No." = FIELD("NS_Job No."),
                                  NS_Revision = FIELD(NS_Revision);
                    ShortCutKey = 'Shift+Ctrl+T';
                }
                action(NS_Segments)
                {
                    Image = Segment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Segments';//PRJ-1102.GK.1.0 13Jan2022
                    ApplicationArea = All;
                    ToolTip = 'Segments';

                    trigger OnAction();
                    var
                        JobSegment: Record "NS_Archived Quote Segments";
                        JobSegmentPg: Page "NS_Archived Quote Segments";
                    begin
                        JobSegment.RESET();
                        JobSegment.SETRANGE("NS_Job No.", "NS_Job No.");
                        JobSegment.SETRANGE(NS_Revision, NS_Revision);
                        if JobSegment.FINDFIRST() then begin
                            JobSegmentPg.SETTABLEVIEW(JobSegment);
                            JobSegmentPg.RUN();
                        end;
                    end;
                }
                action("NS_Scope of Work")
                {
                    ApplicationArea = All;
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Process;
                    Caption = 'Scope of Work';//PRJ-1102.GK.1.0 13Jan2022
                    PromotedIsBig = true;
                    ToolTip = 'Scope of work';

                    trigger OnAction();
                    var
                        ScopeOfWork: Record "NS_Archived Quote ScopeofWork";
                        ScopeOfWorkPg: Page "NS_Archived Quote ScopeofWork";
                    begin
                        ScopeOfWork.RESET;
                        ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                        ScopeOfWork.SETRANGE(NS_Revision, NS_Revision);
                        ScopeOfWorkPg.SETTABLEVIEW(ScopeOfWork);
                        ScopeOfWorkPg.RUN;
                    end;
                }
            }
        }
        area(processing)
        {
            action("NS_Unarchive Quote")
            {
                ApplicationArea = All;
                Caption = 'Unarchive Quote';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Unarchive Quote';
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JQuotehdr: Record "NS_Job Quote Header";//PRJ-1163.AS.2.0 
                begin
                    //PRJ-1163.AS.2.0 START
                    JQuotehdr.Reset();
                    JQuotehdr.SetRange("NS_Duplicated-from Quote No.", Rec."NS_Quote No.");
                    JQuotehdr.SetRange("NS_Revision Reference", Rec.NS_Revision);
                    if JQuotehdr.FindFirst() then
                        Error('This Revision No. %1.%2  has already been Unarchived', JQuotehdr."NS_Duplicated-from Quote No.", JQuotehdr."NS_Revision Reference");
                    //PRJ-1163.AS.2.0 END

                    // if not CONFIRM('Are you sure you wish to unarchive this quote?') then //PRJ-1163.AS.1.0 Commented
                    if CONFIRM('Are you sure you wish to unarchive this quote?') then //PRJ-1163.AS.1.0 Added
                        UnarchiveQuote(Rec);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if GETFILTER("NS_Sell-to Customer No.") <> '' then
            if Customer.GET(GETFILTER("NS_Sell-to Customer No.")) then
                VALIDATE("NS_Sell-to Customer No.", Customer."No.");
    end;

    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";

    //Text14021400Lbl: Label 'Currently there are not any segments for Quote %1, Do you wish to use the Defaults?';
}

