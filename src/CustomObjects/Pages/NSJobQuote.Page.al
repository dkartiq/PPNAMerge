page 14021405 "NS_Job Quote"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-278.AS.1.0 28MAY2020 Added Action "PrintDocumentBySegmentSOW"//PPAL-34.AS.1.0 27JUNE2020
    //PRJ-398.AM.1.0 8OCT2020 | Added code on ONLOOKUP trigger of Job No. field.
    //PRJ-409.AS.1.0 Changed page for Dimensions Button
    //PRJ-872.JS.1.0  13Sep2021 | link quote revisions
    //PRJ-933.JS.1.0  05Oct2021 | Add one field
    //PRJ-1043.GK.1.0 10Nov2021 | Change caption.
    //PRJ-1077.AS.1.0 15DEC21 Moved Estimated start date, Estimated completion date from Job Tab to General tab
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1179.RM.1.0 10Feb2022 | Modified code of area(factbox)
    //PRJ-1215.JS.1.0 23Feb2022 | correct code 
    //PRJ-1279.NK.1.0 04Apr2022 | Add code  
    //PRJ-1312.NK.1.0 03May2022 | Add Code
    //PRJ-1487.NK.1.0 01Jul2022 | Added Code
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
    //PRJCTPR-23.NK.1.0 06jan2023| added subpage view and subpagelink on task total and segment total Tab
    //PE-6.NK.1.0 24Mar2022 Add New Field
    //PRJCTPR-130.RM.1.0 18July2023 Adde some code.
    Caption = 'Job Quote';
    PageType = Card;
    RefreshOnActivate = true; //PRJ-1312.NK.1.0 03May2022
    //PromotedActionCategories = 'New,Process,Reports,Supplemental,Tasks,Team,Workflow,Jobs'; //PE-221.NC.1.0 22Jan2024 Block
    PromotedActionCategories = 'New,Process,Reports,Supplemental,Tasks,Team,Workflow,Jobs,Analytics'; //PE-221.NC.1.0 22Jan2024
    SourceTable = "NS_Job Quote Header";
     ContextSensitiveHelpPage = 'user-guide/job-quotes/defining-a-job-quote/'; //PRJ-1085.RM.1.0 16Dec2021

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
                field("Description/Nickname"; Rec."NS_Description/Nickname")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Description/Nickname';
                }

                //PE-128.PS.1.0 12March2024 Start
                field("Job No. Series"; Rec."NS_Job No. Series")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Specifies the no. series to be used for job no. used when the quote is converted into job.';
                    trigger OnLookup(Var Test: Text): Boolean
                    var
                        NS_NoSeriesPage: Page "No. Series";
                        NS_NSSeriesRec: Record "No. Series";
                        NS_NoSeriesRelationship: Record "No. Series Relationship";
                        NS_JobSetup: Record "Jobs Setup";
                    begin
                        if NS_JobSetup.Get() then;
                        NS_NSSeriesRec.Reset();
                        NS_NoSeriesRelationship.SetRange(Code, NS_JobSetup."Job Nos.");
                        if NS_NoSeriesRelationship.FindSet() then
                            repeat
                                NS_NSSeriesRec.Code := NS_NoSeriesRelationship."Series Code";
                                NS_NSSeriesRec.Mark := true;
                            until NS_NoSeriesRelationship.Next() = 0;
                        if NS_NSSeriesRec.Get(NS_JobSetup."Job Nos.") then
                            NS_NSSeriesRec.Mark := true;
                        NS_NSSeriesRec.MarkedOnly := true;
                        if PAGE.RunModal(0, NS_NSSeriesRec) = ACTION::LookupOK then
                            Rec.Validate("NS_Job No. Series", NS_NSSeriesRec.Code);
                    end;
                }

                field("NS_Manual Job No."; Rec."NS_Manual Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify if you have any specific Job No. to be used for Job No. when the quote is converted into a job. Please note that this can only be defined if the above field is selected with the "Manual" option On.';

                }
                //PE-128.PS.1.0 12March2024 End

                field("Quote Type Code"; Rec."NS_Quote Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quote Type Code';
                    Visible = false;
                }
                field("Proposal Date"; Rec."NS_Proposal Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Proposal Date';
                    Visible = true;
                }
                field("Link-to Quote No."; Rec."NS_Link-to Quote No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Link-to Quote No.';
                }
                field(Revision; Rec.NS_Revision)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the  Revision';
                }
                field("Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer No.';
                    Importance = Promoted;
                    ToolTip = 'Select the Customer No.'; //PRJ-1579.RM.3.0
                }
                field("Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Sell-to Customer Name';
                    Importance = Promoted;
                    ToolTip = 'Sepcifies the name of the Customer'; //PRJ-1579.RM.2.0 
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
                //PE-300.DK.1.0 29May2024 Start
                field("Probability to Close"; Rec."NS_QuotePro to Close")   //PE-300.JS.1.0 21JUN2024
                {
                    Caption = 'Probability to Close';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Probability to Close';
                }
                //PE-300.DK.1.0 29May2024 End
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

                    trigger OnValidate();
                    begin

                        if not "NS_Equipment Only" then begin
                            CurrPage.SAVERECORD;
                            COMMIT;
                            QuoteMgt.NS_VerifyUseTaxEligibility(Rec, false);
                        end;
                    end;
                }
                field(Template; Rec.NS_Template)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Template';

                    trigger OnValidate();
                    begin
                        QuoteMgt.NS_OnValidateTemplate(Rec);
                        CurrPage.UPDATE(false);
                    end;
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
                //PE-6.NK.1.0 24Mar2022 Start
                field(NS_Opportunity; Rec.NS_Opportunity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Opportunity';

                }
                //PE-6.NK.1.0 24Mar2022 End
                //PE-300.JS.1.0 21JUN2024-Start
                field(Status; Rec."NS_Quote Status")
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Status';
                }
                //PE-300.JS.1.0 21JUN2024-Start
                //PRJ-1156.AS.1.0 21JAN2022 START
                field("NS_Date Converted to Order"; Rec."NS_Date Converted to Order")
                {
                    ApplicationArea = All;
                    //Caption = 'Date Converted to Order';//PRJ-1156.AS.2.0 25FEB2022 Commented
                    Caption = 'Date Converted to Job';//PRJ-1156.AS.2.0 25FEB2022 Added
                    // ToolTip = 'Specifies the Date Converted to Order';//PRJ-1156.AS.2.0 25FEB2022 Commented
                    ToolTip = 'Specifies the Date Converted to Job';//PRJ-1156.AS.2.0 25FEB2022 Added
                    Editable = false;
                }
                //PRJ-1156.AS.1.0 21JAN2022 END
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
                field("Job Posting Group"; Rec."NS_Job Posting Group New")//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header instead of old field "NS_Job Posting Group"
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Posting Group';
                }
                field("NS_Data From API"; Rec."NS_Data From API")    //PRJ-933.JS.1.0   05Oct2021
                {
                    ToolTip = 'Specifies the value of the Data inserted using API';
                    ApplicationArea = All;
                    Visible = false;
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
                field("Item Quote Costs"; Rec."NS_Item Quote Costs")
                {
                    ApplicationArea = all;
                    editable = false;
                }
                field("Labour Rate"; Rec."NS_Labour Rate")
                {
                    ApplicationArea = all;
                    editable = false;
                    // ToolTip = 'If enabled, the item card "Quote Cost" will be used. If disabled then item standard cost will be used. If this option is grayed out then to enable go to "Job Setup".'; //PRJ-1579.RM.1.0  //PRJ-1579.RM.2.0 commented                 
                    ToolTip = 'If enabled, the Item Card "Quote Cost" will be used. If disabled then Item Standard Cost will be used. If this option is "grayed" out then to enable go to "Job Setup".'; //PRJ-1579.RM.2.0               
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End

                field("Estimated Start Date"; Rec."NS_Estimated Start Date")//PRJ-1077.AS.1.0 15DEC21
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Estimated Start Date';
                }
                field("Estimated Completion Date"; Rec."NS_Estimated Completion Date")//PRJ-1077.AS.1.0 15DEC21
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Estimated Completion Date';
                }
                //PRJ-1443.AS.1.0 START
                field("NS_EnblGLNResGMCalc"; Rec."NS_EnblGLNResGMCalc")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies Enable Resources in Gross Marg. Calc.';

                    trigger OnValidate()
                    begin
                        // CurrPage.UPDATE(false);
                    end;
                }
                //PRJ-1443.AS.1.0 END
                //PE-221.NC.1.0 29Dec2023 Start
                field("NS_Total Units"; Rec."NS_Total Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Units field.';
                }
                field("NS_Unit of Measure Code"; Rec."NS_Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }

                //PE-221.NC.1.0 29Dec2023 End

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

                    trigger OnValidate();
                    begin
                        QuoteMgt.NS_OnValidateLocationCode(Rec);
                        CurrPage.UPDATE(false);
                    end;
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
            part(Lines; "NS_Job Quote Subform")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No.");
            }
            part("Package Lines"; "NS_Job Quote Package SubForm")
            {
                ApplicationArea = All;
                Caption = 'Package Lines';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No.");
                UpdatePropagation = Both;
            }
            part("Assembly BOM Lines"; "NS_Job QuoteAssemblyBOMSubform")
            {
                ApplicationArea = All;
                Caption = 'Assembly BOM Lines';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No.");
            }
            part("Task Totals"; "NS_Job Quote Task TotalSubform")
            {
                ApplicationArea = All;
                Caption = 'Task Totals';
                SubPageLink = "NS_Quote No." = FIELD("NS_Quote No."), "Job No." = field("NS_Job No.");//PRJCTPR-23.NK.1.0  06jan2023 
            }
            part("Segment Totals"; "NS_Job Quote Segment TotalSubF")
            {
                ApplicationArea = All;
                Caption = 'Segment Totals';
                SubPageView = where("NS_Job No." = filter(<> ''));//PRJCTPR-23.NK.1.0  06jan2023
                SubPageLink = "NS_Job No." = field("NS_Job No.");

                //  UpdatePropagation = Both; //comment //PRJCTPR-23.NK.1.0  06jan2023
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
                    ToolTip = 'Specifies the "Minimum Selling Price G.M. %';
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
                field("Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shortcut Dimension 2 Code';
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
                    DrillDown = true;//PRJ-398.AS.1.0 20JAN2021

                    //PRJ-398.AM.1.0 Start
                    // trigger Onlookup(var text: Text): Boolean //PRJ-398.AS.1.0 20JAN2021 Comment
                    trigger OnDrillDown()//PRJ-398.AS.1.0 20JAN2021 Added
                    var
                        RecJob: Record Job;
                        JobListPg: Page "Job List";
                    begin
                        RecJob.Reset();
                        RecJob.SetRange("No.", Rec."NS_Job No.");
                        if RecJob.FindFirst() then
                            Page.RunModal(89, RecJob);
                    end;
                    //PRJ-398.AM.1.0 End
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
                    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
                    trigger OnValidate()
                    Var
                        Rec_LabourRatebyTask: Record "NS_Labor rate by task list";
                        Rec_JPL: Record "Job Planning Line";//PRJ-1068.GK.1.0 07Dec2021
                        Rec_Resource: Record Resource;//PRJ-1068.GK.1.0 07Dec2021
                    begin
                        IF Rec."NS_Labour Rate" then begin
                            Rec_LabourRatebyTask.Reset();
                            Rec_LabourRatebyTask.SetRange("NS_Job Type Code", Rec."NS_Job Type Code");
                            IF NOT Rec_LabourRatebyTask.FindFirst() then
                                Error('Please define the Job Type Code %1 in Labor by Task Table', Rec."NS_Job Type Code");
                        end;
                        //PRJ-1068.GK.1.0 07Dec2021 start
                        IF Rec."NS_Labour Rate" then begin
                            IF Confirm('Do you want to update all Job Planning Lines for this Quote with new Labor rate ?') then begin
                                Rec_LabourRatebyTask.Reset();
                                Rec_LabourRatebyTask.SetRange("NS_Job Type Code", Rec."NS_Job Type Code");
                                IF Rec_LabourRatebyTask.FindFirst() then;
                                IF Rec_LabourRatebyTask."NS_Labor Rate" = 0 then
                                    Error('Please define the Labor rate value in Labour Rates by Task Table for Job Task Code %1', Rec_LabourRatebyTask."NS_Job Type Code");

                                Rec_JPL.Reset();
                                Rec_JPL.SetRange("Job No.", Rec."NS_Quote No.");
                                Rec_JPL.SetRange(Type, Rec_JPL.Type::Resource);
                                IF Rec_JPL.FindSet() then
                                    repeat
                                        IF Rec_Resource.Get(Rec_JPL."No.") then;
                                        IF Rec_Resource.Type = Rec_Resource.Type::Person then begin
                                            Rec_JPL.validate("Unit Cost", Rec_LabourRatebyTask."NS_Labor Rate");
                                            Rec_JPL.Modify();
                                        end;
                                    until Rec_JPL.next = 0;
                                //Message('Process Complete !');
                            end;
                        end;
                        //PRJ-1068.GK.1.0 07Dec2021 end
                    end;

                    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
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
                    ToolTip = 'Specifies the General Contractor Name';
                }
                field("Architect/Engineer No."; Rec."NS_Architect/Engineer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Architect/Engineer No.';
                }
                field("Architect/Engineer Name"; Rec."NS_Architect/Engineer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Architect/Engineer Name';
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
                    ToolTip = 'Specifies the Schedule 3 Percentage';
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
        area(factboxes)
        {
            part(Control1100773066; "NS_QuoteBudget/BillableFactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("NS_Job No.");
            }
            part(Attributes; "NS_Job Quote Attribute Set Ent")
            {
                ApplicationArea = All;
                Caption = 'Attributes';
                Provider = Lines;
            }
            part(Features; "NS_Job Quote Feature Text")
            {
                ApplicationArea = All;
                Caption = 'Features';
                Provider = Lines;
            }
            systempart(Control1240060019; Links)
            {
                ApplicationArea = RecordLinks; //PRJ-1113.GK.1.0 12Jan2022
            }
            //PRJ-1113.GK.1.0 12Jan2022 start
            part("Attached Documents"; "Document Attachment Factbox")
            {
                //Visible = false; //PRJ-1487.NK.1.0 01Jul2022 block //PRJCTPR-342.DK.1.0 block again
                ApplicationArea = All;
                ObsoleteState = Pending;

                //ObsoleteState = Pending; //PRJ-1487.NK.1.0 01Jul2022 Block
                SubPageLink = "Table ID" = CONST(14021402), "No." = field("NS_Quote No."); //PRJ-1487.NK.1.0 01Jul2022
                //ObsoleteReason = 'This functionality will be removed in our upcoming release because it is replaced by another factbox named as "Attachments"';//PRJ-1487.NK.1.0 01Jul2022 Block
            }
            //PRJ-1179.RM.1.0 10Feb2022
            part("NS_job Quote Factbox"; "NS Job Quote Factbox")//PRJ-1179.RM.1.0 10Feb2022
            {
                Visible = false; //PRJ-1487.NK.1.0 01Jul2022 
                ApplicationArea = All;
                Caption = 'Attachments';
                ObsoleteState = Pending; //PRJ-1487.NK.1.0 01Jul2022
                SubPageLink = "Table ID" = CONST(14021402), "No." = field("NS_Quote No."); //PRJ-1179.RM.1.0 10Feb2022
                ObsoleteReason = 'This functionality will be removed in our upcoming release because it is replaced by another factbox named as "Attachments"';//PRJ-1487.NK.1.0 01Jul2022
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }

            //PRJ-1113.GK.1.0 12Jan2022 end
        }
    }

    actions
    {
        area(navigation)
        {
            group("Qu&ote")
            {
                Caption = 'Qu&ote';
                action("Di&mensions")
                {
                    ApplicationArea = All;
                    Caption = 'Di&mensions';
                    Image = Dimensions;
                    Promoted = true;//PRJ-409.AS.1.0
                    PromotedCategory = Category7;//PRJ-409.AS.1.0
                    PromotedIsBig = true;//PRJ-409.AS.1.0
                    RunObject = page "Default Dimensions";//PRJ-409.AS.1.0
                    RunPageLink = "Table ID" = CONST(14021402), "No." = FIELD("NS_Quote No.");//PRJ-409.AS.1.0
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions.';

                    //PRJ-409.AS.1.0 - start comment
                    // trigger OnAction();
                    // begin
                    //  QuoteMgt.NS_ShowDocDim(Rec);
                    //     CurrPage.SAVERECORD;
                    // end;
                    //PRJ-409.AS.1.0 - end comment
                }
                action(Addresses)
                {
                    ApplicationArea = All;
                    Caption = 'Addresses';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Set ship to address.';

                    trigger OnAction();
                    var
                        ShiptoAddress: Record "Ship-to Address";
                        ShiptoList: Page "Ship-to Address List";
                        ShiptoAddress2: Record "Ship-to Address";
                    begin
                        Commit();   //PRJ-1279.NK.1.0 04Apr2022
                        Clear(ShiptoList);    //PRJ-1279.NK.1.0 04Apr2022
                        ShiptoAddress.SETCURRENTKEY("NS_No.");
                        ShiptoAddress.ASCENDING(false);
                        ShiptoAddress.SETRANGE("Customer No.", "NS_Sell-to Customer No.");
                        ShiptoList.SETTABLEVIEW(ShiptoAddress);
                        ShiptoList.LOOKUPMODE(true);
                        if ShiptoList.RUNMODAL = ACTION::LookupOK then begin
                            ShiptoList.GETRECORD(ShiptoAddress);
                            ShiptoAddress2.SETRANGE("Customer No.", ShiptoAddress."Customer No.");
                            ShiptoAddress2.SETRANGE(Code, ShiptoAddress.Code);
                            ShiptoAddress2.SETRANGE("NS_Table ID", DATABASE::"NS_Job Quote Header");
                            ShiptoAddress2.SETRANGE("NS_No.", "NS_Job No.");
                            if not ShiptoAddress2.FINDFIRST then begin
                                ShiptoAddress2.RESET;
                                ShiptoAddress2.INIT;
                                ShiptoAddress2 := ShiptoAddress;
                                ShiptoAddress2."NS_Table ID" := DATABASE::"NS_Job Quote Header";
                                ShiptoAddress2."NS_No." := "NS_Job No.";
                                if ShiptoAddress2.INSERT then;
                            end;
                        end;
                    end;
                }
                action("Planning Lines Segment")
                {
                    ApplicationArea = All;
                    Image = Planning;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View planning lines by segment.';

                    trigger OnAction();
                    var
                        PlanningLines: Record "Job Planning Line";
                        PlanningLinesPg: Page "Job Planning Lines";
                    begin
                        Commit();   //PRJ-1279.NK.1.0 04Apr2022
                        Clear(PlanningLinesPg); //PRJ-1279.NK.1.0 04Apr2022
                        PlanningLinesPg.InitVar("NS_Job No.", '', true, '');
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL = ACTION::OK then;
                    end;
                }
                action("Planning Lines")
                {
                    ApplicationArea = All;
                    Image = PlanningWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View planning lines.';

                    trigger OnAction();
                    var
                        PlanningLines: Record "Job Planning Line";
                        PlanningLinesPg: Page "Job Planning Lines";
                    begin
                        Commit();   //PRJ-1279.NK.1.0 04Apr2022
                        Clear(PlanningLinesPg); //PRJ-1279.NK.1.0 04Apr2022
                        PlanningLinesPg.InitVar("NS_Job No.", '', false, '');
                        PlanningLinesPg.EDITABLE(true);
                        if PlanningLinesPg.RUNMODAL = ACTION::OK then;
                    end;
                }
                action("NS Planning Lines (Editable)")
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines (&Editable)';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "NS_Job PlanningList(Editable)";
                    RunPageLink = "Job No." = FIELD("NS_Job No.");
                    ToolTip = 'View planning lines editable.';
                }
                action("<Page Job Task Lines>")
                {
                    ApplicationArea = All;
                    Caption = 'Job &Task Lines';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 1002;
                    RunPageLink = "Job No." = FIELD("NS_Job No.");
                    ShortCutKey = 'Shift+Ctrl+T';
                    ToolTip = 'View task lines.';
                }
                action(Segments)
                {
                    ApplicationArea = All;
                    Image = Segment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View job quote segments.';

                    trigger OnAction();
                    var
                        JobSegment: Record "NS_Job Takeoff Segments";
                        JobSegmentPg: Page "NS_Drawing Segment";
                        JobSegment2: Record "NS_Job Takeoff Segments";
                    begin
                        JobSegment.RESET;
                        JobSegment.SETRANGE("NS_Job No.", "NS_Job No.");
                        if not JobSegment.FINDFIRST then begin
                            JobSegment.RESET;
                            JobSegment.SETRANGE(NS_Default, true);
                            if JobSegment.FINDSET(false, false) then begin
                                if CONFIRM(Text14021400, true, "NS_Job No.") then begin
                                    JobSegment2.RESET;
                                    repeat
                                        JobSegment2 := JobSegment;
                                        JobSegment2."NS_Job No." := "NS_Job No.";
                                        JobSegment2.NS_Default := false;
                                        if JobSegment2.INSERT then;
                                    until JobSegment.NEXT = 0;
                                    JobSegment.RESET;
                                    JobSegment.SETRANGE("NS_Job No.", "NS_Job No.");
                                    JobSegmentPg.SETTABLEVIEW(JobSegment);
                                    JobSegmentPg.RUN;
                                end else begin
                                    JobSegmentPg.SETTABLEVIEW(JobSegment);
                                    JobSegmentPg.RUN;
                                end;
                            end else begin
                                JobSegmentPg.SETTABLEVIEW(JobSegment);
                                JobSegmentPg.RUN;
                            end;
                        end else begin
                            JobSegmentPg.SETTABLEVIEW(JobSegment);
                            JobSegmentPg.RUN;
                        end;
                    end;
                }
                action("Scope of Work")
                {
                    ApplicationArea = All;
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'View scope of work.';

                    trigger OnAction();
                    var
                        ScopeOfWork: Record "NS_Job Quote Scope of Work";
                        ScopeOfWorkPg: Page "NS_Job Quote Scope of Work";
                    begin
                        ScopeOfWork.RESET;
                        ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Job No.");
                        ScopeOfWorkPg.SETTABLEVIEW(ScopeOfWork);
                        ScopeOfWorkPg.RUN;
                    end;
                }
                //PRJ-872.JS.1.0  13Sep2021
                action("QuoteRevisions")
                {
                    ApplicationArea = All;
                    Caption = 'Revisions';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "NS_Archived Quote List";
                    RunPageLink = "NS_Quote No." = FIELD("NS_Quote No.");
                    ToolTip = 'View quote revisions for current quote';
                }
                //PRJ-872.JS.1.0  13Sep2021
                //PE-178.JS.1.0 16NOV2023 - Start
                action(NSProjectProAI)
                {
                    ApplicationArea = All;
                    Caption = 'ProjectPro AI';
                    Image = Info;
                    Promoted = true;
                    PromotedCategory = Process;
                    //InFooterBar = true;
                    trigger OnAction()
                    begin
                        Hyperlink('https://webchat.botframework.com/embed/ChatBotAIUS-bot?s=AsNjejE0XXs.6dxHmclWNW1hYkEGoPRwb_tzwWFLSo4r2tDOwbZRxmc');
                    end;
                }
                //PE-178.JS.1.0 16NOV2023 - end                                   
            }
        }
        area(processing)
        {
            action(CreateRevision)
            {
                ApplicationArea = All;
                Caption = 'Create New Re&vision';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Create a new job quote revision.';

                trigger OnAction();
                begin
                    QuoteMgt.NS_CreateRevisionJQ(Rec);
                end;
            }
            action(CopyDocument)
            {
                ApplicationArea = All;
                Caption = 'Copy Document';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Copy job quote document';

                trigger OnAction();
                var
                    CustomerList: Page "Customer List";
                    CustomerNo: Code[20];
                    CustomerLU: Record Customer;
                begin
                    Commit();  //PRJ-1215.JS.1.0 line added
                    Clear(CustomerList);  //PRJ-1215.JS.1.0 line added
                    CustomerList.LOOKUPMODE(true);
                    if CustomerList.RUNMODAL() = ACTION::LookupOK then begin  //PRJ-1215.JS.1.0 add open and close braket
                        CustomerList.GETRECORD(CustomerLU);
                        CustomerNo := CustomerLU."No.";
                    end;
                    if CustomerNo = '' then
                        ERROR(Text14021401);
                    QuoteMgt.NS_CopyDocumentJQ(Rec, CustomerNo);
                end;
            }
            action(SelectItems)
            {
                ApplicationArea = All;
                Caption = 'Select Items';
                Enabled = false;
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+I';
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_QuoteSelection(Rec);
                end;
            }
            //PE-221.NC.1.0 22Jan2024 Start
            group("NS_Quote Analytics")
            {
                Caption = 'Quote Analytics';
                Image = Statistics;
                action("NS_Standard Estimate Report")
                {
                    ApplicationArea = All;
                    Caption = 'Quote Unit Analysis';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category9;
                    RunObject = Page NS_QuoteUnitAnalysis;
                    RunPageLink = "NS_Quote No." = field("NS_Quote No.");
                }
            }
            //PE-221.NC.1.0 22Jan2024 End
            action(MakeOrder)
            {
                ApplicationArea = All;
                Caption = 'Make Order';
                Enabled = false;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    if QuoteMgt.NS_MakeOrder("NS_Quote No.") then
                        CurrPage.CLOSE;
                end;
            }
            action(ReopenQuote)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = false;
                Visible = false;
                Tooltip = 'Reopen';

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetStatusOpen(Rec);
                end;
            }
            action(ReviewQuote)
            {
                ApplicationArea = All;
                Caption = 'Review';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = false;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetStatusReview(Rec);
                end;
            }
            action(ReleaseQuote)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = false;
                ShortCutKey = 'Ctrl+F9';
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetStatusReleased(Rec);
                end;
            }
            action(ShareQuote)
            {
                ApplicationArea = All;
                Caption = 'Share Quote';
                Enabled = false;
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category6;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_ShareQuote(Rec);
                end;
            }
            action(AssignQuote)
            {
                ApplicationArea = All;
                Caption = 'Assign Quote';
                Enabled = false;
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_Assign(Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            action(JobQuote)
            {
                ApplicationArea = All;
                Caption = 'Job Quote';
                Image = Quote;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                begin
                    QuoteMgt.NS_ShowJobQuote(Rec);
                end;
            }
            action(SalesQuote)
            {
                ApplicationArea = All;
                Caption = 'Sales Quote';
                Enabled = false;
                Image = Quote;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_ShowSalesQuote(Rec);
                end;
            }
            action(ImportInstallation)
            {
                ApplicationArea = All;
                Caption = 'Import Installation';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category8;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_ImportInstallation("NS_Quote No.");
                    CurrPage.UPDATE(false);
                end;
            }
            action("Installation Lines")
            {
                ApplicationArea = All;
                Caption = 'Installation Lines';
                Image = ViewPage;
                Promoted = true;
                PromotedCategory = Category8;
                RunObject = Page "NS_Job Quote Install Imp. ";
                Visible = false;
            }
            action(ConvertToJobDetail)
            {
                ApplicationArea = All;
                Caption = 'Convert to Job';
                Image = ExplodeRouting;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category8;
                ToolTip = 'Convert job quote to a job.';

                trigger OnAction();
                var
                    lJobPlanLine: Record "Job Planning Line";
                    Contact: Record Contact;
                    ContBusRel: Record "Contact Business Relation";
                    Cust: Record Customer;
                    jobtbl: Record Job;//PRJ-914.AS.1.0
                    NS_NoSeries: Record "No. Series";//PE-128.PS.2.0 29March2024
                begin
                    //PRJ-914.AS.1.0 start
                    jobtbl.Reset();
                    jobtbl.SetRange("NS_Created from Quote No.", Rec."NS_Quote No.");//PRJ-1131.RM.1.0
                    if jobtbl.FindFirst() then
                        Error('Job Quote No. %1 is already converted to Job Order No. %2', Rec."NS_Quote No.", jobtbl."No.");//PRJ-1131.RM.1.0
                                                                                                                             //PRJ-914.AS.1.0 end

                    //PE-128.PS.2.0 29March2024 Start
                    if Rec."NS_Job No. Series" <> '' then begin
                        if NS_NoSeries.Get(Rec."NS_Job No. Series") then;
                        If (NS_NoSeries."Manual Nos." = true) And (Rec."NS_Manual Job No." = '') And (NS_NoSeries."Default Nos." = false) then
                            Error('You must define a value in the "Manual Job no." field on the Quote %1 before converting it into a Job.', Rec."NS_Quote No.")
                    end else
                        Error('You must define a value in the "Job No. Series" field on the Quote "%1" before converting into a Job.', Rec."NS_Quote No.");




                    //PE-128.PS.2.0 29March2024 End 

                    //create customer if only a contact was setup
                    if ("NS_Sell-to Customer No." = '') and Contact.GET("NS_Contact No.") then begin


                        if not ContBusRel.FindByContact(ContBusRel."Link to Table"::Customer.AsInteger(), Contact."No.") then begin
                            Contact.SetHideValidationDialog(true);
                            // Contact.CreateCustomer(Contact.ChooseCustomerTemplate);//PRJ-1620.AS.1.0 COMMENTED
                            Contact.CreateCustomerFromTemplate((Contact.ChooseNewCustomerTemplate()));//PRJ-1620.AS.1.0 ADD
                        end;

                        //Check if a customer has already been created
                        ContBusRel.SETCURRENTKEY("Link to Table", "Contact No.");
                        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                        ContBusRel.SETRANGE("Contact No.", Contact."No.");
                        if ContBusRel.FINDFIRST then begin
                            "NS_Sell-to Customer No." := ContBusRel."No.";
                            if Cust.GET(ContBusRel."No.") then
                                "NS_Sell-to Customer Name" := Cust.Name;
                            MODIFY;
                        end;
                    end;

                    lJobPlanLine.NS_CalcScheduleofValues(Rec);
                    COMMIT;
                    QuoteMgt.NS_ConvertQuoteJob(Rec);
                end;
            }
            action(PrintDocument)
            {
                ApplicationArea = All;
                //Caption = '&Print Document'; //PRJ-1043.GK.1.0 10Nov2021 line comment
                Caption = '&Print By Lines'; //PRJ-1043.GK.1.0 10Nov2021
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetBySegment(false);
                    QuoteMgt.NS_PrintQuote(Rec, false);
                end;
            }
            action(PrintDocumentBySegment)
            {
                ApplicationArea = All;
                //Caption = 'Print By Segment Document'; //PRJ-1043.GK.1.0 10Nov2021
                Caption = 'Print By Segments'; //PRJ-1043.GK.1.0 10Nov2021
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetBySegment(true);
                    QuoteMgt.NS_PrintQuote(Rec, false);
                end;
            }
            //PRJ-1046.RM.1.0 11Nov2021 Start
            action(PrintDocumentByTask)
            {
                ApplicationArea = All;
                Caption = 'Print By Tasks';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JobQuoteHdr: Record "NS_Job Quote Header";
                begin
                    Commit(); //PRJ-1279.NK.1.0 04Apr2022
                    JobQuoteHdr.Reset;
                    JobQuoteHdr.SetRange("NS_Quote No.", Rec."NS_Quote No.");
                    REPORT.RUNMODAL(14021497, true, false, JobQuoteHdr);
                end;
            }
            //PRJ-1046.RM.1.0 11Nov2021 End
            action(PrintDocumentBySegmentWithScopeOfWork)
            {
                ApplicationArea = All;
                Caption = 'Print with Segment Scope of Work';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false; //PRJ-278.AS.1.0 28MAY2020 //PPAL-34.AS.1.0 27JUNE2020

                trigger OnAction();
                begin
                    Commit();   //PRJ-1279.NK.1.0 04Apr2022
                    Clear(QuoteMgt); //PRJ-1279.NK.1.0 04Apr2022
                    QuoteMgt.NS_SetBySegment(true);
                    QuoteMgt.PrintQuoteWithSegmentScope(Rec, false);
                end;
            }
            //PRJ-278.AS.1.0 28MAY2020 - start //PPAL-34.AS.1.0 27JUNE2020
            action(PrintDocumentBySegmentSOW)
            {
                ApplicationArea = All;
                //Caption = 'Print with Segment Scope of Work'; //PRJ-1043.GK.1.0 10Nov2021
                Caption = 'Print By Segment With SOW'; //PRJ-1043.GK.1.0 10Nov2021
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    JobQuoteHdr: Record "NS_Job Quote Header";
                begin
                    Commit(); //PRJ-1279.NK.1.0 04Apr2022
                    JobQuoteHdr.Reset;
                    JobQuoteHdr.SetRange("NS_Quote No.", Rec."NS_Quote No.");
                    REPORT.RUNMODAL(14021423, true, false, JobQuoteHdr);
                end;
            }
            //PRJ-278.AS.1.0 28MAY2020 - end //PPAL-34.AS.1.0 27JUNE2020
            action("NS CustomReports")
            {
                ApplicationArea = All;
                Caption = 'Custom &Reports';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Run custom reports.';

                trigger OnAction();
                var
                    CustomReports: Page "Custom Report Layouts";
                begin
                    Commit();   //PRJ-1279.NK.1.0 04Apr2022
                    Clear(CustomReports); //PRJ-1279.NK.1.0 04Apr2022
                    CustomReports.RUNMODAL;
                    CLEAR(CustomReports);
                end;
            }
              //PRJCTPR-130.RM.1.0 19July2023 start
            action(JobQuoteEstimation)
            {
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Caption = 'Job Quote Estimation Report';
                ToolTip = 'This Report shows the estimate of the Job Quote Cost & Job Quote Price details.';
                trigger OnAction();
                var
                    JobQuoteHdr: Record "NS_Job Quote Header";
                begin
                    Commit();
                    JobQuoteHdr.Reset();
                    JobQuoteHdr.SetRange("NS_Quote No.", Rec."NS_Quote No.");
                    REPORT.RUNMODAL(14021332, true, false, JobQuoteHdr);
                end;
            }
            //PRJCTPR-130.RM.1.0 19July2023 End
            action(UseTaxQuestionnaire)
            {
                ApplicationArea = All;
                Caption = 'Use Tax Questionnaire';
                Enabled = false;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Category8;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_OpenUseTaxQuestionnaire(Rec);
                end;
            }
            action(PreservePricing)
            {
                ApplicationArea = All;
                Caption = 'Preserve Pricing';
                Image = SalesPrices;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetPricePreserve(Rec, true);
                end;
            }
            action(Resync)
            {
                ApplicationArea = All;
                Caption = 'Resync';
                Enabled = false;
                Image = AutofillQtyToHandle;
                Visible = false;

                trigger OnAction();
                begin
                    SELECTLATESTVERSION;
                    CurrPage.UPDATE(false);
                    QuoteMgt.NS_Resync(Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            action(Inactive)
            {
                ApplicationArea = All;
                Caption = 'Inactive';
                Image = FileContract;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Toggle status between open and inactive.';
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_Inactive(Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            action(PipelineUpdate)
            {
                ApplicationArea = All;
                Caption = 'P&ipeline Update';
                Image = Report2;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                var
                    _QuotePipelineUpdate: Page "NS_Job Quote Pipeline Upd ";
                begin
                    Commit(); //PRJ-1279.NK.1.0 04Apr2022
                    CLEAR(_QuotePipelineUpdate);
                    _QuotePipelineUpdate.NS_SetQuote("NS_Quote No.", false);
                    _QuotePipelineUpdate.RUNMODAL;
                end;
            }
            action(ContractLines)
            {
                ApplicationArea = All;
                Caption = 'Contract Lines';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    lPlanningLine: Record "Job Planning Line";
                    TotPerc: Decimal;
                begin
                    case "NS_Contract Line Method" of
                        "NS_Contract Line Method"::Default:
                            begin
                            end;
                        "NS_Contract Line Method"::Percentage:
                            begin
                                TotPerc := Rec."NS_Schedule 1 Percentage" + Rec."NS_Schedule 2 Percentage" + Rec."NS_Schedule 3 Percentage" + Rec."NS_Schedule 4 Percentage" + Rec."NS_Schedule 5 Percentage" + Rec."NS_Schedule 6 Percentage";
                                if TotPerc <> 100 then
                                    ERROR(Text14021402 + FORMAT(TotPerc));
                                lPlanningLine.NS_CalcScheduleofValues(Rec);
                            end;
                        "NS_Contract Line Method"::Segment:
                            begin
                            end;
                    end;
                end;
            }
            action("Job Cost Budget")
            {
                ApplicationArea = All;
                Image = CostLedger;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                ToolTip = 'Run job cost budget report.';

                trigger OnAction();
                var
                    lJob: Record Job;
                    lJobCostBudget: Report "NS_Job Cost Budget withSorting";
                begin
                    Commit();   //PRJ-1279.NK.1.0 04Apr2022
                    Clear(lJobCostBudget); //PRJ-1279.NK.1.0 04Apr2022
                    lJob.SETRANGE("No.", "NS_Quote No.");
                    lJobCostBudget.SETTABLEVIEW(lJob);
                    lJobCostBudget.RUNMODAL;
                end;
            }
            group("Take-Off")
            {
                Caption = 'Take-Off';
                action(GetJobSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Segments';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    ToolTip = 'View job segments.';

                    trigger OnAction();
                    var
                        JobSegment: Page "NS_Job Takeoff Worksheet";
                    begin
                        Commit();   //PRJ-1279.NK.1.0 04Apr2022
                        Clear(JobSegment); //PRJ-1279.NK.1.0 04Apr2022
                        JobSegment.NS_InitPage("NS_Job No.", '');
                        JobSegment.RUNMODAL;
                    end;
                }
            }
            group("Segment Interactions")
            {
                Caption = 'Segment Interactions';
                action("Create &Interaction")
                {
                    AccessByPermission = TableData Attachment = R;
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create &Interaction';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create an interaction with a specified contact.';

                    trigger OnAction();
                    begin
                        Commit(); //PRJ-1279.NK.1.0 04Apr2022
                        NS_CreateInteraction;
                    end;
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "NS_Job Quote No." = FIELD("NS_Quote No.");
                    RunPageView = SORTING("NS_Job Quote No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
                action("Factor & Markup")
                {
                    ApplicationArea = all;
                    Caption = 'Factor & Markup';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "NS_Job Cost Category Prices";
                    RunPageLink = "NS_Job No." = FIELD("NS_Quote No.");
                    trigger OnAction();
                    begin
                    end;
                }
                 //PE-6.NK.1.0 21APR2022 Start
                action("Create Opportunity")
                {
                    ApplicationArea = all;
                    Caption = 'Create Opportunity';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        Opportunity: Record Opportunity;
                        MrkSetup: Record "Marketing Setup";
                        OpporNo: Code[20];
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                    begin
                        Rec.TestField("NS_Contact No.");
                        if not Confirm('Do you want to Create Opportunity?', false) then
                            exit;
                        MrkSetup.Get();
                        OpporNo := NoSeriesMgt.GetNextNo(MrkSetup."Opportunity Nos.", Today, true);
                        Opportunity.Init();
                        Opportunity.validate("No.", OpporNo);
                        Opportunity.Description := Rec."NS_Description/Nickname";
                        Opportunity.Validate("Contact No.", Rec."NS_Contact No.");
                        Opportunity.NS_JobQuoteNo := Rec."NS_Quote No.";
                        Opportunity.Validate("Salesperson Code", Rec."NS_Salesperson Code New");
                        Opportunity."Creation Date" := Today();
                        Opportunity.Insert();
                    end;
                }
                action("NS_Update Opportunity")
                {
                    ApplicationArea = all;
                    Caption = 'Update Opportunity';
                    Image = UpdateUnitCost;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        NS_Opportunity: Record Opportunity;
                    begin
                        if NS_Opportunity.Get(Rec.NS_Opportunity) then begin
                            NS_Opportunity."NS_Contract Price" := Rec."NS_Total Contract Price";
                            NS_Opportunity.Modify();
                        end;
                    end;
                }
                //PE-6.NK.1.0 21APR2022 End

                action("NS_Update Labor Rates")
                {
                    ApplicationArea = all;
                    Caption = 'Update Labor Rates';
                    Image = Process;
                    Promoted = true;
                    Visible = false;//PRJ-1068.GK.1.0 07Dec2021
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        Rec_LabourRatebyTask: Record "NS_Labor rate by task list";
                        Rec_JPL: Record "Job Planning Line";
                        Rec_Resource: Record Resource;
                    begin
                        IF Rec."NS_Labour Rate" then begin
                            IF Confirm('Do you want to update all Job Planning Lines for this Quote with new Labor rate ?') then begin
                                Rec_LabourRatebyTask.Reset();
                                Rec_LabourRatebyTask.SetRange("NS_Job Type Code", Rec."NS_Job Type Code");
                                IF Rec_LabourRatebyTask.FindFirst() then;
                                IF Rec_LabourRatebyTask."NS_Labor Rate" = 0 then
                                    Error('Please define the Labor rate value in Labour Rates by Task Table for Job Task Code %1', Rec_LabourRatebyTask."NS_Job Type Code");

                                Rec_JPL.Reset();
                                Rec_JPL.SetRange("Job No.", Rec."NS_Quote No.");
                                Rec_JPL.SetRange(Type, Rec_JPL.Type::Resource);
                                IF Rec_JPL.FindSet() then
                                    repeat
                                        IF Rec_Resource.Get(Rec_JPL."No.") then;
                                        IF Rec_Resource.Type = Rec_Resource.Type::Person then begin
                                            Rec_JPL.validate("Unit Cost", Rec_LabourRatebyTask."NS_Labor Rate");
                                            Rec_JPL.Modify();
                                        end;
                                    until Rec_JPL.next = 0;
                                Message('Process Complete !');
                            end;
                        end;
                    end;
                }

                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
            }
        }
    }

    trigger OnOpenPage()
    var
        TJobTakOff: Record "NS_Job Takeoff Segments";
    begin
        ////Rec.NS_TotalContractPrice(); //PRJ-1312.NK.1.0 09May2022 Block
        //PRJ-1312.NK.1.0 03May2022 Start Block
        //PRJ-1155.AS.1.0 START
        // TJobTakOff.Reset();
        // TJobTakOff.SetRange("NS_Job No.", Rec."NS_Job No.");
        // TJobTakOff.CalcSums("NS_Total Contract Price");
        // if TJobTakOff."NS_Total Contract Price" <> 0 then begin
        //     Rec.VALIDATE("NS_Total Contract Price", TJobTakOff."NS_Total Contract Price");
        //     Rec.Modify();
        // end;
        //PRJ-1155.AS.1.0 END
        //PRJ-1312.NK.1.0 03May2022 End Block
    end;


    trigger OnAfterGetCurrRecord();
    var
        TJobTakOff: Record "NS_Job Takeoff Segments";//PRJ-1155.AS.1.0
    begin
        Rec.NS_UpdateMinSellPrice();//PRJ-1131.RM.1.0
        Rec.NS_TotalContractPrice(); //PRJ-1312.NK.1.0 03May2022
        //PRJ-1312.NK.1.0 03May2022 Start Block
        //PRJ-1155.AS.1.0 START
        // TJobTakOff.Reset();
        // TJobTakOff.SetRange("NS_Job No.", Rec."NS_Job No.");
        // TJobTakOff.CalcSums("NS_Total Contract Price");
        // if TJobTakOff."NS_Total Contract Price" <> 0 then begin
        //     Rec.VALIDATE("NS_Total Contract Price", TJobTakOff."NS_Total Contract Price");
        //     Rec.Modify();
        // end;
        //PRJ-1155.AS.1.0 END
        //PRJ-1312.NK.1.0 03May2022 End Block
    end;

    trigger OnAfterGetRecord();
    var
        TJobTakOff: Record "NS_Job Takeoff Segments";
    begin
        Rec.NS_UpdateMinSellPrice();

        //PRJ-1155.AS.1.0 START
        rec.NS_TotalContractPrice(); //PRJ-1312.NK.1.0 03May2022
        //PRJ-1312.NK.1.0 03May2022 Start Block
        // TJobTakOff.Reset();
        // TJobTakOff.SetRange("NS_Job No.", Rec."NS_Job No.");
        // TJobTakOff.CalcSums("NS_Total Contract Price");
        // if TJobTakOff."NS_Total Contract Price" <> 0 then begin
        //     Rec.VALIDATE("NS_Total Contract Price", TJobTakOff."NS_Total Contract Price");
        //     Rec.Modify();
        // end;
        //PRJ-1155.AS.1.0 END
        //PRJ-1312.NK.1.0 03May2022 End Block
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if GETFILTER("NS_Sell-to Customer No.") <> '' then
            if Customer.GET(GETFILTER("NS_Sell-to Customer No.")) then
                VALIDATE("NS_Sell-to Customer No.", Customer."No.");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        q: Integer;
    begin
        q := q;
    end;

    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        UserSetup: Record "User Setup";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        QuoteListFiltered: Boolean;
        Text14021400: Label 'Currently there are not any segments for Quote %1, Do you wish to use the Defaults?';
        Text14021401: Label 'A Site Customer must be chosen';
        Text14021402: Label '"Total Schedule Percentage must be 100% : "';
}

