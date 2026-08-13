page 14021300 "NS_Subcontract Card"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-257 VT1.0 06-05-20
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PPAL-113.AS.1.0 10SEPT2020 Done code to mandatory Subcontract Default UOM field in a condition 
    //PRJ-383.N.S.1.0 16Sep2020 condition on make purchase document
    //PRJ-383.AS.1.0 Added code to flow Person responsible and Person responsible name
    //PRJ-616.N.S.1.0 Add Restrication on new line insert when  Subcontract PO is posted
    //PRJ-780.RS.1.0 28June2021 | Incorrect spelling on "subcontract" in Subcontract card
    //PRJ-961.RM.1.0 09Oct2021 | Change caption of a field
    //PRJ-659.RM.1.0 22Oct2021 | Aligned columns to right
    //PRJ-999.JS.1.0 03Nov2021 | Add fields
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1131.NK.1.0 11Jan2022 | Removed with statement
    //PRJ-1160.NK.1.0 03Feb2022 | Removed Fields from Budget Tab
    //PRJ-1194.NK.1.0 12Apr2022 | Add Code
    //PRJ-1342.RM.1.0 24May2022 | Updated caption of field
    //PRJ-1416.JS.1.0 24MAY2022 | Add condition
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    //PRJ-1724.RP.1.0 03Dec2022 | changes caption and tooltip
    // PRJCTPR-6.Dk.1.0 26Dec2022 |move  Invoice & payment fast tab should come after the Constants fast tab followed by Manager.
    //ZEL-12.RM.1.0 13Apr2023 | Added some code
    //PE-74.NK.1.0 18Apr2023 | Added Code
    //PRJCTPR-332.Dk.1.0 07March2023 | Added some code
    Caption = 'Subcontract Card';
    PageType = Card;
    SourceTable = NS_Subcontract;
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    Permissions = tabledata 39 = rmd; //PRJ-1106.GK.1.0 29Dec2021
    //ContextSensitiveHelpPage = 'user-guide/subcontracts/subcontract-management/'; //PRJ-1085.RM.1.0 16Dec2021

    layout
    {
        area(content)
        {
            group(SubcontractTabs)
            {
                Caption = 'General';
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                    // >> Upgrade
                    Editable = false;
                    // << Upgrade
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then //PRJ-1131.NK.1.0
                            CurrPage.UPDATE();
                    end;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        CLEAR(SubcontractList);
                        SubcontractList.LOOKUPMODE(true);
                        SubcontractList.SETTABLEVIEW(Rec);
                        SubcontractList.SETRECORD(Rec);
                        if SubcontractList.RUNMODAL = ACTION::LookupOK then
                            SubcontractList.GETRECORD(Rec);
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Description';
                    // >> Upgrade
                    //Editable = NOT Variation;
                    // << Upgrade
                }
                field("Buy-from Vendor No."; Rec."NS_Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                    // >> Upgrade
                    Editable = NOT Variation;
                    // << Upgrade
                    trigger OnValidate();
                    begin
                        NS_BuyfromVendorNoOnAfterValidate();
                    end;
                }
                field("Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from Name';
                }
                field("Buy-from Address"; Rec."NS_Buy-from Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from Address';
                    // >> Upgrade
                    Importance = Additional;
                    // << Upgrade
                }
                field("Buy-from Address 2"; Rec."NS_Buy-from Address 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the "Buy-from Address 2';
                    // >> Upgrade
                    Importance = Additional;
                    // << Upgrade
                }
                field("Buy-from City"; Rec."NS_Buy-from City")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from City';
                    // >> Upgrade
                    Importance = Additional;
                    // << Upgrade
                }
                field(County; Rec.NS_County)
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from State'; //PRJ-961.RM.1.0 09Oct2021 
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from State'; //PRJ-961.RM.1.0 09Oct2021
                                                              // >> Upgrade
                    Importance = Additional;
                    // << Upgrade
                }
                field("Buy-from Contact"; Rec."NS_Buy-from Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from Contact';
                }
                field("Buy-from Post Code"; Rec."NS_Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Buy-from Post Code';
                    // >> Upgrade
                    Importance = Additional;
                    // << Upgrade
                }
                field("Sub-Level to Subcontract No."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub-Level to Subcontract No.';
                    // >> Upgrade
                    Editable = NOT Variation;
                    // << Upgrade
                }
                //PE-177.DK.3.0 23Jan2024 Start
                field(NS_MergedtoChangeOrderNo; Rec.NS_MergedtoChangeOrderNo)
                {
                    Caption = 'Merged to Change Order No.';
                    ToolTip = 'Specify the Change Order No. into which the Change Request has been merged.'; //PE-177.DK.5.0 08Feb2024
                    ApplicationArea = all;
                    Editable = false;
                }
                //PE-177.DK.3.0 23Jan2024 Start
                field("Search Description"; Rec."NS_Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Search Description';
                    // >> Upgrade
                    Editable = NOT Variation;
                    // << Upgrade
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Person Responsible';

                    trigger OnValidate();
                    begin
                        NS_PersonResponsibleOnAfterValida();
                    end;
                }
                field(PersonResponsibleName; PersonResponsibleName)
                {
                    ApplicationArea = All;
                    Caption = 'Person Responsible Name';
                    Editable = false;
                    ToolTip = 'Specifies the Person Responsible Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    var
                        IncompatibleLines: Boolean;
                        Job_L: Record Job;//PRJ-383.AS.1.0 12OCT2020 
                        Resouce_L: Record Resource;//PRJ-383.AS.1.0 12OCT2020 
                    begin
                        //PRJ-383.AS.1.0 12OCT2020  - start
                        if Rec."NS_Job No." <> '' then begin //PRJ-1131.NK.1.0
                            if Job_L.get(Rec."NS_Job No.") then begin //PRJ-1131.NK.1.0
                                Rec."NS_Person Responsible" := Job_L."Person Responsible"; //PRJ-1131.NK.1.0
                                if Resouce_L.Get(Rec."NS_Person Responsible") then //PRJ-1131.NK.1.0
                                    PersonResponsibleName := Resouce_L.Name;
                            end;
                        end;
                        //PRJ-383.AS.1.0 12OCT2020 - end
                        if Rec."NS_Job No." <> '' then begin //PRJ-1131.NK.1.0
                                                             //PRJ-1131.NK.1.0 11Jan2022 Start
                                                             //with SubcontractDetail do begin
                            IncompatibleLines := false;
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                            if SubcontractDetail.FINDSET() then
                                repeat
                                    if SubcontractDetail."NS_Job No." <> '' then
                                        if not JobLinks.GET(SubcontractDetail."NS_Job No.", Rec."NS_Job No.") then
                                            IncompatibleLines := true;
                                until (SubcontractDetail.NEXT() = 0) or IncompatibleLines;

                            if IncompatibleLines then
                                if not CONFIRM(Text1001Lbl, true, Rec."NS_Job No.") then
                                    ERROR(Text1002Lbl)
                                else begin
                                    SubcontractDetail.RESET();
                                    SubcontractDetail.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                                    if SubcontractDetail.FINDSET() then
                                        repeat
                                            if SubcontractDetail."NS_Job No." <> '' then begin
                                                SubcontractDetail."NS_Job No." := Rec."NS_Job No.";

                                                //Check Job Task No.
                                                if SubcontractDetail."NS_Job Task No." > '' then begin
                                                    JobPlanningLine.RESET();
                                                    JobPlanningLine.SETRANGE("Job No.", SubcontractDetail."NS_Job No.");
                                                    JobPlanningLine.SETRANGE("Job Task No.", SubcontractDetail."NS_Job Task No.");
                                                    if JobPlanningLine.COUNT() = 0 then
                                                        SubcontractDetail."NS_Job Task No." := '';
                                                end;
                                                SubcontractDetail.MODIFY();
                                            end;
                                        until SubcontractDetail.NEXT() = 0;
                                end;
                            //end;
                            //PRJ-1131.NK.1.0 11Jan2022 End
                            Rec.NS_ClearExistingDimensions(Rec."NS_No."); //PRJ-1131.NK.1.0
                            Rec.NS_SetDimensions(Rec."NS_No.", Rec."NS_Job No."); //PRJ-1131.NK.1.0
                        end;
                        // >> Upgrade
                        // >> 002
                        SetHideForecast();
                        // << 002
                        // << Upgrade
                    end;
                }
                field("Purchase Document No."; Rec."NS_Purchase Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Document No.';//PRJ-257 VT1.0 06-05-20
                    Editable = false;
                    // ToolTip = 'Specifies the No.'; //PRJ-1579.RM.1.0 commented
                    ToolTip = 'Specifies the Purchase Document No.'; //PRJ-1579.RM.1.0

                }
                field("Last Date Modified"; Rec."NS_Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Last Date Modified';
                }
            }
            part(DetailLines; "NS_Subcontract Lines")
            {
                ApplicationArea = Suite;
                SubPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                UpdatePropagation = Both;
            }
            group(Constants)
            {
                Caption = 'Constants';
                field("Vendor Job No."; Rec."NS_Vendor Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor''s Job No.';
                    ToolTip = 'Specifies the Vendor''s Job No.';
                }
                field("Creation Date"; Rec."NS_Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Creation Date';
                    // >> Upgrade
                    Editable = false;
                    // << Upgrade
                }
                field("Starting Date"; Rec."NS_Starting Date")    //PE-267.JS.1.0 11MAR2024
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
                field("Ending Date"; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ending Date';
                }
                field("Completion Date"; Rec."NS_Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Completion Date';
                }
                field("Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Retention Percent';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                    //PRJCTPR-332.Dk.1.0 07March2023 Start
                    // Editable = NSReturnManagerStatus; //PE-177.DK.1.0 10Nov2023
                    Editable = NS_SetstatusEditable;
                    //PRJCTPR-332.Dk.1.0 07March2023 End
                }
                //PRJ-533.AS.1.0 - START
                field("NS_Subcon Class"; Rec."NS_Subcon Class") //PRJ-1131.NK.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcon Class';
                }
                //PRJ-533.AS.1.0 - END
            }
            group("Invoice And Payments")  //PRJCTPR-6.Dk.1.0 26Dec2022 start
            {
                Caption = 'Invoice and Payments'; //PRJCTPR-6.Dk..1.0 26Dec2022
                fixed(Control1905768101)
                {
                    group("Period to Date")
                    {
                        Caption = '                                        Period to Date';  //PRJ-659.RM.1.0 22Oct2021
                        field(InvoiceReceivedPTD; InvoiceReceived[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Invoice Received';
                            Editable = false;
                            ToolTip = 'Specifies the Invoice Received';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
                                ShowVLEEntries.SETRANGE("Posting Date", DMY2DATE(1, DATE2DMY(WORKDATE(), 2), DATE2DMY(WORKDATE(), 3)), WORKDATE());
                                ShowVLEEntries.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL();
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                        field(PaymentMadePTD; PaymentMade[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Payment Made';
                            Editable = false;
                            ToolTip = 'Specifies the Payment Made';

                            trigger OnDrillDown();
                            begin
                                ShowSubcontractRec.RESET();
                                ShowSubcontractRec := Rec;
                                ShowSubcontractRec.SETRANGE("NS_Date Filter", DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), WORKDATE());
                                DetailedVendorLedgEntries.SetFilters(ShowSubcontractRec, "Sub-Levels");
                                DetailedVendorLedgEntries.RUNMODAL();
                                CLEAR(DetailedVendorLedgEntries);
                            end;
                        }
                        field(RetentionHeldPTD; RetentionHeld[1])
                        {
                            ApplicationArea = All;
                            Caption = 'Retention Held';
                            DrillDown = true;
                            DrillDownPageID = "Vendor Ledger Entries";
                            ToolTip = 'Specifies the Retention Held';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET;
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
                                ShowVLEEntries.SETRANGE("Posting Date", DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3)), WORKDATE());
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL;
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                    }
                    group("Year to Date")
                    {
                        Caption = '                                            Year to Date'; //PRJ-659.RM.1.0 22Oct2021
                        field(InvoiceReceivedYTD; InvoiceReceived[2])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the invoice amount received.';
                            Caption = ' ';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
                                ShowSubcontractRec.SETRANGE("NS_Posting Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE());
                                ShowVLEEntries.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL();
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                        field(PaymentMadeYTD; PaymentMade[2])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = ' ';
                            ToolTip = 'Specifies the payment made amount.';

                            trigger OnDrillDown();
                            begin
                                ShowSubcontractRec.RESET();
                                ShowSubcontractRec := Rec;
                                ShowSubcontractRec.SETRANGE("NS_Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE(), 3)), WORKDATE());
                                DetailedVendorLedgEntries.SetFilters(ShowSubcontractRec, "Sub-Levels");
                                DetailedVendorLedgEntries.RUNMODAL();
                                CLEAR(DetailedVendorLedgEntries);
                            end;
                        }
                        field(RetentionHeldYTD; RetentionHeld[2])
                        {
                            ApplicationArea = All;
                            Caption = ' ';
                            ToolTip = 'Specifies the retention amount held.';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
                                ShowVLEEntries.SETRANGE("Posting Date", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE());
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL;
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                    }
                    group("Contract to Date")
                    {
                        //     Caption = '                                     Contract to Date'; //PRJ-659.RM.1.0 22Oct2021

                        Caption = '                                           Total to Date'; //PRJCTPR-6.Dk.1.0 22Oct2021
                        field(InvoiceReceivedJTD; InvoiceReceived[3])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the Invoice Recevied';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
                                ShowVLEEntries.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL;
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                        field(PaymentMadeJTD; PaymentMade[3])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the payment made amount.';
                            Caption = 'Payment Made Amount';

                            trigger OnDrillDown();
                            begin
                                ShowSubcontractRec.RESET();
                                ShowSubcontractRec := Rec;
                                ShowSubcontractRec.SETRANGE("NS_Date Filter", 0D, DMY2DATE(31, 12, 9999));
                                DetailedVendorLedgEntries.SetFilters(ShowSubcontractRec, "Sub-Levels");
                                DetailedVendorLedgEntries.RUNMODAL;
                                CLEAR(DetailedVendorLedgEntries);
                            end;
                        }
                        field(RetentionHeldJTD; RetentionHeld[3])
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the retention held amount.';
                            Caption = 'Retention Held Amount';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL;
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                    }
                }
            }
            //PRJCTPR-6.Dk.1.0 26Dec2022 end
            group(Manager)
            {
                Caption = 'Manager';
                field("Manager Subcontract Status"; Rec."NS_Manager Subcontract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Reporting Status';
                    ToolTip = 'Specifies the Reporting Status';
                    Editable = NSReturnManagerStatus;//PE-177.DK.1.0 10Nov2023
                    trigger OnValidate();
                    begin
                        NS_ManagerSubcontractStatusOnAfte();
                    end;
                }
                field("Subcontract Status Date"; Rec."NS_Subcontract Status Date")
                {
                    ApplicationArea = All;
                    Caption = 'Status Date';
                    ToolTip = 'Specifies the Status Date';
                    // >> Upgrade
                    Editable = false;
                    // << Upgrade
                }
                field("Estimated Start Date"; Rec."NS_Estimated Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Estimated Start Date';
                }
                field(StartingDate; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
                field("Estimated Completion Date"; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = All;
                    Caption = 'Estimated Ending Date';
                    ToolTip = 'Specifies the Estimated Ending Date';
                }
                field(EndingDate; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ending Date';
                }
            }
            group(Budget)
            {
                Caption = 'Budget';
                field("CalcValues[1,1]"; CalcValues[1, 1])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Costs To Date';
                    DrillDown = true;
                    DrillDownPageID = "NS_Purchase Line List";
                    Editable = false;
                    // ToolTip = 'Actual Cost Job to Date'; //PRJ-1579.RM.1.0  commented
                    // ToolTip = 'Specifies the Actual cost fo the job to date'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Specify the Actual Cost for the Job to Date'; //PRJ-1579.RM.2.0 
                    trigger OnValidate();
                    begin
                        PurchaseLineList.NS_SetVendor(Rec."NS_Buy-from Vendor No."); //PRJ-1131.NK.1.0
                        PurchaseLineList.RUNMODAL;
                        CLEAR(PurchaseLineList);
                    end;
                }
                field("CalcValues[1,2] * 100"; CalcValues[1, 2] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Total Budgeted Cost';
                    Editable = false;
                    ToolTip = '"Percent of [Actual Costs To Date] / [Total Budgeted Cost] "';
                }
                field("CalcValues[1,3]"; CalcValues[1, 3])
                {
                    ApplicationArea = All;
                    Caption = 'Est. Contract Remaining';
                    Editable = false;
                    ToolTip = '[Total Budgeted Cost] - [Actual Costs To Date]';
                }
                field("CalcValues[1,4] * 100"; CalcValues[1, 4] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Total Budgeted Cost';
                    Editable = false;
                    ToolTip = '"Percent of [Est. Budget Remaining] / [Total Budgeted Cost] "';
                }
                field("CalcValues[1,5]"; CalcValues[1, 5])
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract Variance';
                    Editable = false;
                    ToolTip = '[Total Contract] - [Total Budgeted Cost]';
                }
                field("CalcValues[1,6] * 100"; CalcValues[1, 6] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Total Budgeted Cost';
                    Editable = false;
                    ToolTip = '"Percent of [Esitamted Profit (Loss)] / [Total Budgeted Cost] "';
                }
                field("CalcValues[1,7]"; CalcValues[1, 7])
                {
                    ApplicationArea = All;
                    Caption = 'Est. Units and Unit Rates';
                    Editable = false;
                    Visible = false;    //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Total Units] from General Tab';
                }
                field("CalcValues[1,8]"; CalcValues[1, 8])
                {
                    ApplicationArea = All;
                    Caption = '     Budgeted Cost per Unit';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Total Budgeted Cost] / [Total Units] from General Tab';
                }
                field("CalcValues[1,40]"; CalcValues[1, 40])
                {
                    ApplicationArea = All;
                    Caption = 'Total Budgeted Costs';
                    Editable = false;
                    ToolTip = 'Specifies the Total Budgeted Costs';
                }
                field("CalcValues[1,14] * 100"; CalcValues[1, 14] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Entered Complete';
                    Editable = false;
                    //Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = 'Percent of [Act. Budget Remaining] / ([Actual Costs To Date] / ([Entered Complete] / 100))';
                }
                field("CalcValues[1,9]"; CalcValues[1, 9])
                {
                    ApplicationArea = All;
                    Caption = 'Committed (Budget)';
                    DrillDownPageID = "Purchase List";
                    Editable = false;
                    ToolTip = '[Committed Costs]  ->  Total of open Purchase Orders';

                    trigger OnDrillDown();
                    begin
                        CommittedLineList.NS_SetSubcontract(Rec."NS_No."); //PRJ-1131.NK.1.0
                        CommittedLineList.RUNMODAL;
                        CLEAR(CommittedLineList);
                    end;
                }
                field("CalcValues[1,10] * 100"; CalcValues[1, 10] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Total Budgeted Cost';
                    Editable = false;
                    ToolTip = '"Percent of [Committed (Budget)] / [Total Budgeted Cost] "';
                }

                field("CalcValues[1,11]"; CalcValues[1, 11])
                {
                    ApplicationArea = All;
                    Caption = 'Entered Complete [Calculated]';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Actual Percent Complete] from General Tab';
                }
                field("CalcValues[1,13]"; CalcValues[1, 13])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Budget Remaining';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Actual Costs To Date] / ([Entered Complete] / 100)';
                }

                field("CalcValues[1,15]"; CalcValues[1, 15])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Subcontract Variance';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Total Contract] * ([Entered Complete] / 100) - [Actual Costs To Date]';
                }
                field("CalcValues[1,16] * 100"; CalcValues[1, 16] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Actual Costs to Date';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = 'Percent of [Actual Current Profit (Loss)] / [Actual Costs to Date]';
                }
                field("CalcValues[1,17]"; CalcValues[1, 17])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Units and Unit Rates';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = '[Actual Units Complete] from General Tab';
                }
                field("CalcValues[1,18]"; CalcValues[1, 18])
                {
                    ApplicationArea = All;
                    Caption = '     Avg. Cost per Unit Complete';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = 'Percent of [Actual Costs To Date] / [Actual Units Complete] from General Tab';
                }
                field("CalcValues[1,19]"; CalcValues[1, 19])
                {
                    ApplicationArea = All;
                    Caption = 'Committed (Projection)';
                    Editable = false;
                    ToolTip = '[Committed Costs] - > Total of Open Purchase Orders';

                    trigger OnDrillDown();
                    begin
                        CommittedLineList.NS_SetSubcontract(rec."NS_No."); //PRJ-1131.NK.1.0
                        CommittedLineList.RUNMODAL;
                        CLEAR(CommittedLineList);
                    end;
                }
                field("CalcValues[1,20] * 100"; CalcValues[1, 20] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Entered Complete';
                    Editable = false;
                    Visible = false;   //PRJ-1160.NK.1.0 03Feb2022
                    ToolTip = 'Percent of [Committed (Projection)] / ([Actual Costs To Date] / ([Entered Complete] / 100))';
                }
            }
            group(Costs)
            {
                Caption = 'Costs';
                fixed(Control1902254501)
                {

                    group(Control1903653001)
                    {
                        Caption = '                                     Budget'; //PRJ-659.RM.1.0 22Oct2021
                        field("CalcValues[2,1]"; CalcValues[2, 1])
                        {
                            ApplicationArea = All;
                            Caption = 'Labor';
                            Editable = false;
                            ToolTip = 'Budgeted Labor Type Total';
                        }
                        field("CalcValues[2,5]"; CalcValues[2, 5])
                        {
                            ApplicationArea = All;
                            Caption = 'Material';
                            Editable = false;
                            ToolTip = 'Budgeted Material Type Total';
                        }
                        field("CalcValues[2,9]"; CalcValues[2, 9])
                        {
                            ApplicationArea = All;
                            Caption = 'Equipment';
                            Editable = false;
                            ToolTip = 'Budgeted Equipment Type Total';
                        }
                        field("CalcValues[2,13]"; CalcValues[2, 13])
                        {
                            ApplicationArea = All;
                            Caption = 'Subcontract';
                            Editable = false;
                            ToolTip = 'Budgeted Subcontract Type Total';
                        }
                        field("CalcValues[2,17]"; CalcValues[2, 17])
                        {
                            ApplicationArea = All;
                            Caption = 'Manufacturing';
                            Editable = false;
                            ToolTip = 'Budgeted Manufacturing Type Total';
                        }
                        field("CalcValues[2,21]"; CalcValues[2, 21])
                        {
                            ApplicationArea = All;
                            Caption = 'Overhead';
                            Editable = false;
                            ToolTip = 'Budgeted Overhead Type Total';
                        }
                        field("CalcValues[2,25]"; CalcValues[2, 25])
                        {
                            ApplicationArea = All;
                            Caption = 'Miscellaneous';
                            DrillDown = true;
                            DrillDownPageID = "NS_Committed Line List";
                            Editable = false;
                            ToolTip = 'Budgeted Miscellaneous Type Total';
                        }
                        field("CalcValues[2,29]"; CalcValues[2, 29])
                        {
                            ApplicationArea = All;
                            Caption = 'Uncategorized';
                            Editable = false;
                            ToolTip = 'Budgeted Uncategorized Type Total';
                        }
                        field("CalcValues[2,33]"; CalcValues[2, 33])
                        {
                            ApplicationArea = All;
                            Caption = 'Totals';
                            Editable = false;
                            ToolTip = 'Total Budgeted Cost';
                        }
                    }
                    group(Actual)
                    {
                        Caption = '                                       Actual'; //PRJ-659.RM.1.0 22Oct2021
                        field("CalcValues[2,2]"; CalcValues[2, 2])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Labor Type Total';
                        }
                        field("CalcValues[2,6]"; CalcValues[2, 6])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Material Type Total';
                        }
                        field("CalcValues[2,10]"; CalcValues[2, 10])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Equipment Type Total';
                        }
                        field("CalcValues[2,14]"; CalcValues[2, 14])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Subcontract Type Total';
                        }
                        field("CalcValues[2,18]"; CalcValues[2, 18])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Manufacturing Type Total';
                        }
                        field("CalcValues[2,22]"; CalcValues[2, 22])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Overhead Type Total';
                        }
                        field("CalcValues[2,26]"; CalcValues[2, 26])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Miscellaneous Type Total';
                        }
                        field("CalcValues[2,30]"; CalcValues[2, 30])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Actual Uncategorized Type Total';
                        }
                        field("CalcValues[2,34]"; CalcValues[2, 34])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Job To Date Actual Cost';
                        }
                    }
                    group(Variance)
                    {
                        Caption = '                                   Variance'; //PRJ-659.RM.1.0 22Oct2021
                        field("CalcValues[2,3]"; CalcValues[2, 3])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Labor Budget]] - [Labor Actual]';
                        }
                        field("CalcValues[2,7]"; CalcValues[2, 7])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Material Budget]] - [Material Actual]';
                        }
                        field("CalcValues[2,11]"; CalcValues[2, 11])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Equipment Budget]] - [Equipment Actual]';
                        }
                        field("CalcValues[2,15]"; CalcValues[2, 15])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Subcontract Budget]] - [Subcontract Actual]';
                        }
                        field("CalcValues[2,19]"; CalcValues[2, 19])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Manufacturing Budget]] - [Manufacturing Actual]';
                        }
                        field("CalcValues[2,23]"; CalcValues[2, 23])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Overhead Budget]] - [Overhead Actual]';
                        }
                        field("CalcValues[2,27]"; CalcValues[2, 27])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Miscellaneous Budget]] - [Miscellaneous Actual]';
                        }
                        field("CalcValues[2,31]"; CalcValues[2, 31])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Uncategorized Budget]] - [Uncategoriezed Actual]';
                        }
                        field("CalcValues[2,35]"; CalcValues[2, 35])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = '[Total Budgeted]] - [Total Actual]';
                        }
                    }
                    group("Variance %")
                    {
                        Caption = '                                Variance %'; //PRJ-659.RM.1.0 22Oct2021
                        field("CalcValues[2,4]"; CalcValues[2, 4])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Labor Variance]] / [Labor Budget]';
                        }
                        field("CalcValues[2,8]"; CalcValues[2, 8])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Material Variance]] / [Material Budget]';
                        }
                        field("CalcValues[2,12]"; CalcValues[2, 12])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Equipment Variance]] / [Equipment Budget]';
                        }
                        field("CalcValues[2,16]"; CalcValues[2, 16])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Subcontract Variance]] / [Subcontract Budget]';
                        }
                        field("CalcValues[2,20]"; CalcValues[2, 20])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Manufacturing Variance]] / [Manufacturing Budget]';
                        }
                        field("CalcValues[2,24]"; CalcValues[2, 24])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Overhead Variance]] / [Overhead Budget]';
                        }
                        field("CalcValues[2,28]"; CalcValues[2, 28])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Miscellaneous Variance]] / [Miscellaneous Budget]';
                        }
                        field("CalcValues[2,32]"; CalcValues[2, 32])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Uncategorized Variance]] / [Uncategorized Budget]';
                        }
                        field("CalcValues[2,36]"; CalcValues[2, 36])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Percent of [Total Variance]] / [Total Budget]';
                        }
                    }
                }
            }
            group(StatusGroup)
            {
                Caption = 'Status';
                field(CreationDate; Rec."NS_Creation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Creation Date';
                }
                field(EstimatedStartDate; Rec."NS_Estimated Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Estimated Start Date';
                }
                //PE-267.JS.1.0 11MAR2024 Start
                field(Starting_Date; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Starting Date (Obsolete)';
                    Editable = false;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                    // ToolTip = 'Specifies the Actual Starting date of work to be performed'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0  commented
                    ToolTip = 'Specify the Actual Starting Date of Work to be performed'; //PRJ-1579.RM.2.0 
                }
                field(NSStartingDate; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Starting Date';
                    Editable = false;
                    // ToolTip = 'Specifies the Actual Starting date of work to be performed'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0  commented
                    ToolTip = 'Specify the Actual Starting Date of Work to be performed'; //PRJ-1579.RM.2.0 
                }
                //PE-267.JS.1.0 11MAR2024 End
                field(EstimatedCompletionDate; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Estimated Completion Date';
                }
                //PE-267.JS.1.0 11MAR2024 Start
                field(Ending_Date; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Ending Date (Obsolete)';
                    Editable = false;
                    ToolTip = 'Specifies the Actual Ending Date';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Will be removed in next build';
                    ObsoleteTag = 'ProjectPro upcoming release 23.0.XXX.00';
                }
                field(NSEndingDate; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Ending Date';
                    Editable = false;
                    ToolTip = 'Specifies the Actual Ending Date';
                }
                //PE-267.JS.1.0 11MAR2024 End
                field(CompletionDate; Rec."NS_Completion Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Completion Date';
                }
                field(BudgetedCost; BudgetedCost)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    Editable = false;
                    ToolTip = 'Specifies the Contract Amount';
                    Width = 10000;
                }
                field("Sub-LevelsCost"; "Sub-LevelsCost")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Sub-Levels';
                    Editable = false;
                    ToolTip = 'Specifies the Contract Sub-Levels';

                    trigger OnDrillDown();
                    begin
                        "Sub-LevelSubcontracts".COPY(Rec);
                        "Sub-LevelSubcontracts".RESET;
                        "Sub-LevelSubcontracts".SETFILTER("NS_Sub-LeveltoSubcontractNo.", Rec."NS_No."); //PRJ-1131.NK.1.0
                        PAGE.RUN(PAGE::"NS_Subcontract List", "Sub-LevelSubcontracts");
                    end;
                }
                field("BudgetedCost + ""Sub-LevelsCost"""; BudgetedCost + "Sub-LevelsCost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Subcontract';
                    Editable = false;
                    ToolTip = 'Specifies the Total Subcontract';
                }

            }

        }

        //PRJ-532.AS.1.0 - start
        area(factboxes)
        {
            part("NS_SubContract Card Factbox"; "NS_SubContract Card Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "NS_No." = FIELD("NS_No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }

        }
        //PRJ-532.AS.1.0 - end

    }

    actions
    {
        area(navigation)
        {
            group("&Subcontract")
            {
                Caption = '&Subcontract';
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(NS_Subcontract),
                                  "No." = FIELD("NS_No.");
                    ToolTip = 'View comments';
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View Dimensions';

                    trigger OnAction();
                    begin
                        Rec.NS_ShowDocDim(); //PRJ-1131.NK.1.0
                        CurrPage.SAVERECORD();
                    end;
                }
                action("Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger Entries';
                    Image = JobLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "NS_Subcontract Ledger Entries";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View ledger entries';
                }
                //PE-74.NK.1.0 19Apr2023 Start
                action("NS_User Tasks")
                {
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedCategory = Process;
                    Caption = 'User Tasks';
                    Image = Task;
                    ToolTip = 'View this User Tasks.';
                    trigger OnAction()
                    var
                        UserTask: Record "User Task";
                        UserTask2: Record "User Task";
                    begin
                        UserTask.Reset();
                        UserTask.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if UserTask.IsEmpty then begin
                            UserTask2.Init();
                            UserTask2."NS_Job No." := Rec."NS_Job No.";
                            UserTask2.Insert();
                            Commit();
                            UserTask.Reset();
                            UserTask.SetRange("NS_Job No.", Rec."NS_Job No.");
                            PAGE.RunModal(PAGE::"User Task Card", UserTask);
                        end else begin
                            UserTask.Reset();
                            UserTask.SetRange("NS_Job No.", Rec."NS_Job No.");
                            PAGE.RunModal(PAGE::"User Task List", UserTask);
                        end;
                    end;
                }
                //PE-74.NK.1.0 19Apr2023 End
                action("Subcontract Links")
                {
                    ApplicationArea = All;
                    Caption = '&Links';
                    Tooltip = 'Links';
                    Image = Links;
                    RunObject = Page "NS_Subcontract Links";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    RunPageView = SORTING("NS_Subcontract No.", "NS_Parent Subcontract No.");
                }
                action("Show Vendor Insurance")
                {
                    ApplicationArea = All;
                    Caption = 'Show Vendor Insurance';
                    Image = ServiceAgreement;
                    ToolTip = 'Show Vendor Insurance';

                    trigger OnAction();
                    var
                        VendorInsurance: Record "NS_Vendor Insurance";
                        VendorInsurances: Page "NS_Vendor Insurances";
                    begin
                        VendorInsurance.SETRANGE("NS_Vendor No.", Rec."NS_Buy-from Vendor No."); //PRJ-1131.NK.1.0
                        VendorInsurance.SETFILTER("NS_Expiration Date", '>=%1', WORKDATE);
                        VendorInsurances.SETTABLEVIEW(VendorInsurance);
                        VendorInsurances.RUN;
                    end;
                }
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
            group(Functions)
            {
                Caption = 'Functions';
                action("Get Job Budget Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Budget Lines';
                    Visible = false;//PRJ-1036.GK.1.0 22Nov2021
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Tooltip = 'Get Job Budget Lines';

                    trigger OnAction();
                    var
                        JobPlanningLine: Record "Job Planning Line";
                        JobPlanningLine_Loc: Record "Job Planning Line";//PPAL-113.AS.1.0 10SEPT2020
                        JobsSetup_Loc: Record "Jobs Setup";//PPAL-113.AS.1.0 10SEPT2020
                        NextLineNo: Integer;
                        JobPlanningList: Page "Job Planning Lines";

                        PurchHeader: Record "Purchase Header";//PRJ-616.N.S.1.0
                    begin
                        //PRJ-616.N.S.1.0 Start
                        if Rec."NS_Purchase Document No." <> '' then begin
                            if not PurchHeader.get(PurchHeader."Document Type"::Order, Rec."NS_Purchase Document No.") then
                                Error('You have already posted the PO No. %1, Please create a New Subcontract', Rec."NS_Purchase Document No.");
                        end;
                        //PRJ-616.N.S.1.0 End
                        //PPAL-113.AS.1.0 10SEPT2020 - START
                        JobsSetup_Loc.Get;

                        IF JobsSetup_Loc."NS_Subcontract Use of UOM" = JobsSetup."NS_Subcontract Use of UOM"::"Default only if none provided" then begin
                            JobPlanningLine_Loc.Reset;
                            JobPlanningLine_Loc.SETRANGE("Job No.", Rec."NS_Job No.");
                            JobPlanningLine_Loc.SETFILTER("Line Type", '%1|%2', JobPlanningLine_Loc."Line Type"::Budget,
                                                          JobPlanningLine_Loc."Line Type"::"Both Budget and Billable");
                            JobPlanningLine_Loc.SetFilter(Type, '%1|%2', JobPlanningLine_Loc.Type::Resource, JobPlanningLine_Loc.Type::"G/L Account");
                            JobPlanningLine_Loc.SetFilter("Unit of Measure Code", '=%1', '');
                            if JobPlanningLine_Loc.FindFirst then begin
                                if JobsSetup_Loc."NS_Subcontract Default UOM" = '' then
                                    //Error('Subcontract Default UOM field is mandatory in Job setup, Please fill it first to proceed') //PRJCTPR-150.PS.1.0 12Jul2023 Commented 
                                    Error('The Unit of Measure code cannot be blank on both Job Planning Line and Job Setup (Subcontract Default UOM). Please fill either of the value to proceed.'); //PRJCTPR-150.PS.1.0 12Jul2023
                            end;
                        end;
                        //PPAL-113.AS.1.0 10SEPT2020 - END
                        //PRJ-1131.NK.1.0 11Jan2022 Start
                        //with JobPlanningLine do begin
                        JobPlanningList.LOOKUPMODE := true;
                        JobPlanningLine.SETRANGE("Job No.", Rec."NS_Job No.");
                        JobPlanningLine.SETFILTER("Line Type", '%1|%2', JobPlanningLine."Line Type"::Budget,
                                                      JobPlanningLine."Line Type"::"Both Budget and Billable");
                        JobPlanningList.SETTABLEVIEW(JobPlanningLine);
                        JobPlanningList.SetGetFrom(true, Rec."NS_No.", '');
                        JobPlanningList.RUNMODAL;
                        CLEAR(JobPlanningList);
                        //end;
                        //PRJ-1131.NK.1.0 11Jan2022 End
                    end;
                }

                //PRJ-1036.GK.1.0 22Nov2021 start
                action("Get Job Budget Lines1")
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Budget Lines';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Tooltip = 'Get Job Budget Lines';

                    trigger OnAction();
                    var
                        JobPlanningLine: Record "Job Planning Line";
                        JobPlanningLine_Loc: Record "Job Planning Line";//PPAL-113.AS.1.0 10SEPT2020
                        JobsSetup_Loc: Record "Jobs Setup";//PPAL-113.AS.1.0 10SEPT2020
                        NextLineNo: Integer;
                        JobPlanningList: Page "Job Planning Lines";
                        PurchHeader: Record "Purchase Header";//PRJ-616.N.S.1.0
                        GetChangeOrderPage: Page NS_GetSubConChangeOrder;
                        ChangeOrderJobFilter: Text;
                        LocJob: Record Job;
                        changeOrderExist: Boolean;
                        Rec_SubconLines: Record "NS_Subcontract Lines";
                        Rec_Jobtask: Record "Job Task";
                        NS_PurchLine: Record "Purchase Line"; //PRJ-1106.GK.1.0 29Dec2021
                    begin
                        //PRJ-616.N.S.1.0 Start
                        if Rec."NS_Purchase Document No." <> '' then begin
                            if not PurchHeader.get(PurchHeader."Document Type"::Order, Rec."NS_Purchase Document No.") then
                                Error('You have already posted the PO No. %1, Please create a New Subcontract', Rec."NS_Purchase Document No.");
                        end;
                        //PRJ-616.N.S.1.0 End
                        //PPAL-113.AS.1.0 10SEPT2020 - START
                        JobsSetup_Loc.Get;

                        IF JobsSetup_Loc."NS_Subcontract Use of UOM" = JobsSetup."NS_Subcontract Use of UOM"::"Default only if none provided" then begin
                            JobPlanningLine_Loc.Reset;
                            JobPlanningLine_Loc.SETRANGE("Job No.", Rec."NS_Job No.");
                            JobPlanningLine_Loc.SETFILTER("Line Type", '%1|%2', JobPlanningLine_Loc."Line Type"::Budget,
                                                          JobPlanningLine_Loc."Line Type"::"Both Budget and Billable");
                            JobPlanningLine_Loc.SetFilter(Type, '%1|%2', JobPlanningLine_Loc.Type::Resource, JobPlanningLine_Loc.Type::"G/L Account");
                            JobPlanningLine_Loc.SetFilter("Unit of Measure Code", '=%1', '');
                            if JobPlanningLine_Loc.FindFirst then begin
                                if JobsSetup_Loc."NS_Subcontract Default UOM" = '' then
                                    Error('Subcontract Default UOM field is mandatory in Job setup, Please fill it first to proceed')
                            end;
                        end;
                        //PPAL-113.AS.1.0 10SEPT2020 - END

                        IF (Rec."NS_Subcon Class" = Rec."NS_Subcon Class"::"Change Order") OR (Rec."NS_Subcon Class" = Rec."NS_Subcon Class"::"Master Job") then begin
                            LocJob.Reset();
                            LocJob.SetRange("NS_Job Class", LocJob."NS_Job Class"::"Change Order");
                            LocJob.SetRange("NS_Sub-Level to Job No.", Rec."NS_Job No.");
                            changeOrderExist := LocJob.FindFirst();
                            If changeOrderExist then begin
                                if Confirm('Select Job Planning Lines from a change Order.', False) then begin
                                    GetChangeOrderPage.SetSubCon(Rec);
                                    GetChangeOrderPage.RunModal();
                                    GetChangeOrderPage.GetValues(ChangeOrderJobFilter);
                                    //PRJ-1131.NK.1.0 Start
                                    //with JobPlanningLine do begin
                                    JobPlanningList.LOOKUPMODE := true;
                                    If ChangeOrderJobFilter > '' then
                                        JobPlanningLine.SetFilter("Job No.", '%1|%2', Rec."NS_Job No.", ChangeOrderJobFilter)
                                    else
                                        JobPlanningLine.SETRANGE("Job No.", Rec."NS_Job No.");
                                    JobPlanningLine.SETFILTER("Line Type", '%1|%2', JobPlanningLine."Line Type"::Budget,
                                                                  JobPlanningLine."Line Type"::"Both Budget and Billable");
                                    JobPlanningList.SETTABLEVIEW(JobPlanningLine);
                                    JobPlanningList.SetGetFrom(true, Rec."NS_No.", '');
                                    JobPlanningList.RUNMODAL;
                                    CLEAR(JobPlanningList);
                                    //end;
                                    //PRJ-1131.NK.1.0 End
                                end else
                                    NS_OpenJobPlanningLinesPage();
                            end else
                                NS_OpenJobPlanningLinesPage();
                        end else
                            NS_OpenJobPlanningLinesPage();
                        //New Change
                        Rec_SubconLines.Reset();
                        Rec_SubconLines.SetRange("NS_Subcontract No.", Rec."NS_No.");
                        IF Rec_SubconLines.FindSet() then
                            repeat
                                //PRJ-1106.GK.1.0 29Dec2021 start
                                NS_PurchLine.Reset();
                                NS_PurchLine.SetRange("Document Type", NS_PurchLine."Document Type"::Order);
                                NS_PurchLine.SetRange("Document No.", Rec_SubconLines."NS_PO No.");
                                NS_PurchLine.SetRange("Line No.", Rec_SubconLines."NS_PO Line No.");
                                NS_PurchLine.SetFilter("Quantity Received", '<>%1', 0);
                                if NS_PurchLine.FindFirst() then
                                    exit;
                                //PRJ-1106.GK.1.0 29Dec2021 end
                                IF Rec_Jobtask.Get(Rec_SubconLines."NS_Job No.", Rec_SubconLines."NS_Job Task No.") then;
                                Rec_SubconLines."NS_Job Task Description" := Rec_Jobtask.Description;
                                Rec_SubconLines.Modify();
                            until Rec_SubconLines.next = 0;
                    end;
                }

                //PRJ-1036.GK.1.0 22Nov2021 end

                separator(Separator1000000014)
                {
                }
                //PRJ-533.AS.1.0 16FEB2020 - START
                action("NS_Create Change Order")
                {
                    ApplicationArea = All;
                    Caption = 'Create Change Order';
                    Promoted = false;

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        Rec.NS_SubConCreateChangeOrder(); //PRJ-1131.NK.1.0
                        //ProjectPro - end
                    end;
                }
                //PRJ-533.AS.1.0 16FEB2020 - END    
                //PE-177.DK.1.0 10Nov2023 Start
                action("NS_SubConCreate Change Request")
                {
                    ApplicationArea = all;
                    Caption = 'Create Change Request';
                    Promoted = false;
                    Image = ChangeBatch;
                    trigger OnAction()
                    var
                        myInt: Integer;
                    begin
                        IF CONFIRM('Do you wish to create a Change request?') THEN
                            Rec.NS_SubConChangeRequest(Rec);
                    end;
                }
                action("NS_SubConMerge Change Request")
                {
                    ApplicationArea = all;
                    Caption = 'Merge Change Request';
                    Promoted = false;
                    Image = ChangeBatch;
                    trigger OnAction();
                    var
                        NS_SubCon: Record NS_Subcontract;
                    begin
                        NS_SubCon.ClearMarks();
                        NS_SubCon.Reset();
                        NS_SubCon.SetRange("NS_Sub-LeveltoSubcontractNo.", Rec."NS_No.");
                        NS_SubCon.SetRange("NS_Subcon Class", NS_SubCon."NS_Subcon Class"::"Change Request");
                        NS_SubCon.SetRange("NS_Manager Subcontract Status", NS_SubCon."NS_Manager Subcontract Status"::Approval); //PE-177.DK.3.0 23Jan2024
                        PAGE.RUN(PAGE::"NS_SubConChangeRequestList", NS_SubCon);
                    end;
                }
                //PE-177.DK.1.0 10Nov2023 End                            
                action(MakePurchaseDocument)
                {
                    ApplicationArea = All;
                    // Caption = 'Make Purchase Document';  //PRJ-1342.RM.1.0 commented
                    //Caption = 'Make/Add Lines To Purchase Document'; //PRJ-1342.RM.1.0 //PRJ-1724.RP.1.0 03Dec2022 commented
                    Caption = 'Create PO or Add Lines to PO'; //PRJ-1724.RP.1.0 03Dec2022
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create new Purchase Order Or Add Lines to existing Purchase Order'; //PRJ-1724.RP.1.0 03Dec2022
                    //ToolTip = 'Make/Add Lines To Purchase Document'; //PRJ-1342.RM.1.0 //PRJ-1724.RP.1.0 03Dec2022 commented 
                    // tooltip = 'Make Purchase Document'; //PRJ-1342.RM.1.0 commented

                    trigger OnAction();
                    begin
                        //PRJ-383.N.S.1.0 16sep2020 start
                        if not Confirm('Do you want to create the purchase order') then
                            exit
                        else
                            //PRJ-383.N.S.1.0 16Sep2020 end
                        Rec.NS_MakePurchaseDocument(Rec); //PRJ-1131.NK.1.0
                    end;
                }
                action(PurchaseDocument)
                {
                    ApplicationArea = All;
                    //Caption = 'Purchase Document'; //PRJ-1724.RP.1.0 03Dec2022 commented
                    Caption = 'View Purchase Order'; //PRJ-1724.RP.1.0 03Dec2022
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    ToolTip = 'To view Existing Purchase Order'; //PRJ-1724.RP.1.0 03Dec2022 
                    //ToolTip = 'Purchase Document'; //PRJ-1724.RP.1.0 03Dec2022 commented
                    trigger OnAction();
                    var
                        PurchHeader: Record "Purchase Header";
                        PurchInvHeader: Record "Purch. Inv. Header"; //PRJ-1194.NK.1.0 12Apr2022
                    begin
                        PurchHeader.RESET();
                        PurchHeader.SETRANGE("No.", Rec."NS_Purchase Document No."); //PRJ-1131.NK.1.0
                        if PurchHeader.FINDFIRST() then
                            PAGE.RUNMODAL(PAGE::"NS_Subcontract PO", PurchHeader)
                        else begin
                            //PRJ-1194.NK.1.0 12Apr2022 Start 
                            PurchInvHeader.Reset();
                            PurchInvHeader.SetRange("NS_Subcontract No.", Rec."NS_No.");
                            if PurchInvHeader.FindLast() then
                                Page.RunModal(Page::"Posted Purchase Invoice", PurchInvHeader)
                        end;
                        //ERROR(Text1003_Txt);
                        //PRJ-1194.NK.1.0 12Apr2022 End
                    end;
                }
                //PRJ-1106.GK.1.0 29Dec2021 start
                action(UpdatePurchaseDocument)
                {
                    ApplicationArea = All;
                    //Caption = 'Update Purchase Document'; //PRJ-1724.RP.1.0 03Dec2022 commented
                    Caption = 'Update Purchase Order'; //PRJ-1724.RP.1.0 03Dec2022  
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'To update changes on Purchase Order Lines from Subcontract Card Line details';  //PRJ-1724.RP.1.0 03Dec2022 

                    trigger OnAction()
                    var
                        NS_PurchLine: Record "Purchase Line";
                        NS_PurInvHeader: Record "Purch. Inv. Header";
                        NS_PurInvLine: Record "Purch. Inv. Line";
                        NS_SubConLine: Record "NS_Subcontract Lines";
                        NS_PurPaySetup: Record "Purchases & Payables Setup";  //PRJ-1416.JS.1.0 24MAY2022

                    begin
                        NS_PurPaySetup.get();  //PRJ-1416.JS.1.0 24MAY2022
                        NS_SubConLine.Reset();
                        NS_SubConLine.SetRange("NS_Subcontract No.", Rec."NS_No.");
                        if NS_SubConLine.FindSet() then
                            repeat
                                NS_PurchLine.Reset();
                                NS_PurchLine.SetRange("Document Type", NS_PurchLine."Document Type"::Order);
                                NS_PurchLine.SetRange("Document No.", NS_SubConLine."NS_PO No.");
                                NS_PurchLine.SetRange("Line No.", NS_SubConLine."NS_PO Line No.");
                                NS_PurchLine.SetFilter("Quantity Received", '%1', 0);
                                if NS_PurchLine.FindFirst() then begin
                                    NS_PurchLine.Validate("No.", NS_SubConLine."NS_No.");
                                    NS_PurchLine.Validate(Quantity, NS_SubConLine.NS_Quantity);
                                    NS_PurchLine.Validate("NS_Job Cost Category", NS_SubConLine."NS_Job Cost Category");
                                    NS_PurchLine.Validate("Unit of Measure Code", NS_SubConLine."NS_Unit of Measure Code");
                                    NS_PurchLine.Validate("Direct Unit Cost", NS_SubConLine."NS_Unit Cost");
                                    NS_PurchLine.Validate("NS_Subcontract No.", NS_SubConLine."NS_Subcontract No.");
                                    NS_PurchLine.Modify();
                                end
                            until NS_SubConLine.Next() = 0;
                        //PRJ-1416.JS.1.0 24MAY2022 - Start    
                        if NS_PurPaySetup."NS_Block Line Dele. Subcon PO" = false then begin
                            NS_PurchLine.Reset();
                            NS_PurchLine.SetRange("Document Type", NS_PurchLine."Document Type"::Order);
                            NS_PurchLine.SetRange("Document No.", Rec."NS_Purchase Document No.");
                            if NS_PurchLine.FindSet() then
                                repeat
                                    NS_SubConLine.Reset();
                                    NS_SubConLine.SetRange("NS_PO No.", NS_PurchLine."Document No.");
                                    NS_SubConLine.SetRange("NS_PO Line No.", NS_PurchLine."Line No.");
                                    if not NS_SubConLine.FindFirst() then
                                        NS_PurchLine.Delete();
                                until NS_PurchLine.Next() = 0;
                        end;
                        //PRJ-1416.JS.1.0 24MAY2022 - end
                        Message('Purchase Document has been updated');
                    end;

                }
                //PRJ-1106.GK.1.0 29Dec2021 end
                //ZEL-12.RM.1.0 19Apr2023 start
                action("NS_Insurance")
                {
                    Caption = 'Vendor Insurances';
                    ToolTip = 'Vendor Insurances';
                    Image = ServiceAgreement;
                    RunObject = Page "NS_Vendor Insurances";
                    RunPageLink = "NS_Vendor No." = FIELD("NS_Buy-from Vendor No.");
                    RunPageView = SORTING("NS_Vendor No.", "NS_Insurance Type", "NS_Policy No.");
                    ApplicationArea = All;
                }
                //ZEL-12.RM.1.0 19Apr2023 end
            }
        }

        area(reporting)
        {
            action(SubcontractStatusByVendor)
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Vendor';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status byVendor";
                ToolTip = 'Run Subcontract Status by Vendor report';
            }
            action(SubcontractStatusByJob)
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Job';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status by Job";
                ToolTip = 'Run Subcontract Status by Job report.';
            }
            //ZEL-12.RM.1.0 13Apr2023 Start
            action("NS_Vendor Insurance List")
            {
                ApplicationArea = All;
                Caption = 'Vendor Insurance List';
                ToolTip = 'Vendor Insurance List';
                Image = "Report";
                trigger OnAction()
                var
                    NS_VendorTab: Record Vendor;
                begin
                    NS_VendorTab.Reset();
                    NS_VendorTab.SetRange("No.", Rec."NS_Buy-from Vendor No.");
                    Report.RunModal(Report::"NS_Vendor Insurance List", true, false, NS_VendorTab);
                end;
            }
            //ZEL-12.RM.1.0 13Apr2023 End
            //PE-23.NC.1.0 16May2023 Start
            action("NS_Commitment Report")
            {
                ApplicationArea = All;
                Caption = 'Commitment Report';
                Image = "Report";
                Promoted = false;
                ToolTip = 'Run Commitment Report.';
                trigger OnAction()
                var
                    RecJob: Record Job;
                begin
                    RecJob.Reset();
                    RecJob.SetRange("No.", Rec."NS_Job No.");
                    Report.RunModal(Report::NS_CommitmentReport, true, false, RecJob);
                end;
            }
            //PE-23.NC.1.0 16May2023 End

            //PRJCTPR-53.NK.1.0 24July2023 start
            action(NSSubcontarctAgreement)
            {
                ApplicationArea = All;
                Caption = 'Subcontract Agreement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NS_subcontract: Report "NS_Subcontract Agreement1";
                    NS_subcontractRec: Record NS_Subcontract;
                    NS_subcontractRecNew: Record NS_Subcontract;
                begin
                    NS_subcontractRecNew.Reset();
                    NS_subcontractRecNew.SetRange("NS_No.", Rec."NS_No.");
                    Report.RunModal(Report::"NS_Subcontract Agreement1", true, false, NS_subcontractRecNew);
                end;
            }
            //PRJCTPR-53.NK.1.0 24July2023 End
            action("NS CustomReports")
            {
                ApplicationArea = All;
                Caption = 'Custom &Reports';
                Image = Report2;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Runb custom reports.';

                trigger OnAction();
                var
                    CustomReports: Page "Custom Report Layouts";
                begin
                    CustomReports.RUNMODAL;
                    CLEAR(CustomReports);
                end;
            }
        }

    }

    trigger OnAfterGetRecord();
    begin
        // >> Upgrade
        OnPreOnAfterGetRecord(Rec, Variation);
        // >> 002
        SetHideForecast();
        // << 002
        // << Upgrade
        NS_CalcStatistics;
        NS_GetPersonResponsibleName;
        NSReturnManagerStatus := NSManagerStatusEdite(); //PE-177.DK.1.0 10Nov2023 

    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var//PRJ-383.AS.1.0 12OCT2020 
        Resource_L: Record Resource;//PRJ-383.AS.1.0 12OCT2020 
    begin
        Rec."NS_Subcon Class" := Rec."NS_Subcon Class"::"Master Job";//PRJ-533.AS.1.0 //PRJ-1131.NK.1.0
        NS_GetPersonResponsibleName;
        if Rec.GETFILTER("NS_Job No.") <> '' then begin //PRJ-1131.NK.1.0
            Rec."NS_Job No." := Rec.GETFILTER("NS_Job No."); //PRJ-1131.NK.1.0
            if Job.GET(Rec."NS_Job No.") then begin     //PRJ-999.JS.1.0  05Nov2021 line added //PRJ-1131.NK.1.0
                Rec."NS_Dimension Set ID" := Rec.GetDimensionNoFromJob(Rec."NS_Job No.");
                //PRJ-999.JS.1.0  05Nov2021 Start
                Rec."NS_Global Dimension 1 Code" := Job."Global Dimension 1 Code";
                Rec."NS_Global Dimension 2 Code" := Job."Global Dimension 2 Code";
                //PRJ-999.JS.1.0  05Nov2021 end
            end;    //PRJ-999.JS.1.0  05Nov2021 line added               
            //PRJ-383.AS.1.0 12OCT2020  - start
            Rec."NS_Person Responsible" := Job."Person Responsible"; //PRJ-1131.NK.1.0
            if Resource_L.Get(Job."Person Responsible") then
                PersonResponsibleName := Resource_L.Name;
            //PRJ-383.AS.1.0 12OCT2020  -  end
        end;

    end;

    trigger OnOpenPage();
    begin
        JobsSetup.GET();
        PurchSetup.GET();
        NS_SetstatusEditable := NS_Subcontractstatus();//PRJCTPR-332.Dk.1.0 07March2023
    end;

    var
        SubcontractDetail: Record "NS_Subcontract Lines";
        SubcontractDetail2: Record "NS_Subcontract Lines";
        "Sub-LevelSubcontracts": Record NS_Subcontract;
        SubcontractCalc: Record NS_Subcontract;
        ShowSubcontractRec: Record NS_Subcontract;
        SubcontractTemp: Record NS_Subcontract;
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        SubcontractLedgEntry2: Record "NS_Subcontract Ledger Entry";
        SubcontractLinks: Record "NS_Subcontract Links";
        VendorLedgEntry: Record "Vendor Ledger Entry";
        ShowVLEEntries: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendorLedgEntryRetention: Record "Vendor Ledger Entry";
        PurchaseLine: Record "Purchase Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SubcontractPlanningLine: Record "Job Planning Line";
        SubcontractPlanningLine2: Record "Job Planning Line";
        JobCostCategory: Record "NS_Job Cost Category";
        JobCostCategory2: Record "NS_Job Cost Category";
        JobRevenueCategory: Record "NS_Job Revenue Category";
        JobRevenueCategory2: Record "NS_Job Revenue Category";
        PurchSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Resource: Record Resource;
        JobLinks: Record "NS_Job Links";
        JobPlanningLine: Record "Job Planning Line";
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        Job: Record Job;
        BudgetedCost: Decimal;
        "Sub-LevelsCost": Decimal;
        InvoiceReceived: array[3] of Decimal;
        PaymentMade: array[3] of Decimal;
        Retention: array[3] of Decimal;
        CommittedCost: Decimal;
        Amount: Decimal;
        MTD: Text[30];
        YTD: Text[30];
        PersonResponsibleName: Text[100];//PRJ-301.MS.1.0
        TotalBudgetedCost: Decimal;
        TotalContract: Decimal;
        CalcPctComplete: Decimal;
        CalcValues: array[2, 40] of Decimal;
        ActualPercentComplete: Decimal;
        EstimatedTotalUnits: Decimal;
        EstimatedTotalUnitsUOM: Code[10];
        ActualTotalUnits: Decimal;
        ActualTotalUnitsUOM: Code[10];
        i: Integer;
        "Sub-Levels": Boolean;
        EstimatedMixedUnits: Boolean;
        ActualMixedUnits: Boolean;
        Text1000: Label 'Unknown';
        "Sub-LevelsJobList": Page "Job List";
        SubcontractLedgerEntries: Page "NS_Subcontract Ledger Entries";
        PurchaseLineList: Page "NS_Purchase Line List";
        CommittedLineList: Page "NS_Committed Line List";
        SubcontractList: Page "NS_Subcontract List";
        DetailedVendorLedgEntries: Page "Detailed Vendor Ledg. Entries";
        Text1001Lbl: Label 'There are lines that are not part of this job.  All Job Numbers will be set to %1.\If a Job Task Number does not exist on the new job, it will be cleared.\Do you want to continue?';
        Text1002Lbl: Label 'The Job No. has not been modified.';
        RetentionHeld: array[3] of Decimal;
        VendorLedgerEntries: Page "Vendor Ledger Entries";

        //PE-177.DK.1.0 10Nov2023 Start
        NS_SubconCRManagerStatus: Boolean;
        NSReturnManagerStatus: Boolean;
        NS_SetstatusEditable: Boolean; //PRJCTPR-332.Dk.1.0 07March2023
        NS_SubconStatus: Boolean; //PRJCTPR-332.Dk.1.0 07March2023
        // >> Upgrade
        Variation: Boolean;

    protected var
        PracticalCompletionDate: Date;
        [InDataSet]
        HideForecast: Boolean;
        Text1004: Label 'Do you want to copy PO Lines to subcontract?';
        Text1003_Txt: Label 'A Purchase Order for this Subcontract does not exist.';//PRJ-780.RS.1.0 28June2021
        ShowMasterSubConMaxRetention: Boolean;
        [InDataSet]
        RetentionBankGuarantee: Boolean;
        [InDataSet]
        RetentionCash: Boolean;
        ShowSiteLocGoogleMapsLbl: Label 'Show Site Location on Google Maps';
    // << Upgrade

    procedure NS_CalcStatistics();
    begin
        //Start of all calculations of the Status tab
        "Sub-Levels" := true;
        SubcontractCalc := Rec;
        SubcontractCalc.RESET;

        //Find Budgeted Cost
        SubcontractCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
        BudgetedCost := SubcontractCalc."NS_Budgeted Cost (LCY)";

        //Find Revisions Cost and Price
        CLEAR("Sub-LevelsCost");
        "Sub-LevelsCost" := Rec.NS_SLsBudgetedCost(SubcontractCalc); //PRJ-1131.NK.1.0

        //Set Period Dates
        MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        //Find Committed Cost
        //PRJ-1131.NK.1.0 Start
        //with PurchaseLine do begin
        PurchaseLine.RESET;
        PurchaseLine.SETCURRENTKEY("NS_Subcontract No.");
            // >> Upgrade
                PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order); // #RG008
            // << Upgrade
        PurchaseLine.SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
        PurchaseLine.CALCSUMS("NS_Committed Amount");
        CommittedCost := PurchaseLine."NS_Committed Amount";
        //end;
        //PRJ-1131.NK.1.0 End

        //Find Invoice Received
        //PRJ-1131.NK.1.0 Start
        //with VendorLedgEntry do begin
        CLEAR(InvoiceReceived);
        VendorLedgEntry.RESET();
        VendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        VendorLedgEntry.SETRANGE("NS_Subcontract No.", Rec."NS_No."); //PRJ-1131.NK.1.0
        VendorLedgEntry.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
        VendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
        VendorLedgEntry.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
        if VendorLedgEntry.FINDFIRST() then
            repeat
                VendorLedgEntry.CALCFIELDS("Amount (LCY)");
                InvoiceReceived[3] := InvoiceReceived[3] - VendorLedgEntry."Purchase (LCY)";
            until VendorLedgEntry.NEXT() = 0;
        if "Sub-Levels" then
            InvoiceReceived[3] := InvoiceReceived[3] + Rec.NS_SLsInvoicedCost(SubcontractCalc); //PRJ-1131.NK.1.0

        VendorLedgEntry.SETFILTER("Posting Date", YTD);
        VendorLedgEntry.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
        if VendorLedgEntry.FINDFIRST() then
            repeat
                VendorLedgEntry.CALCFIELDS("Amount (LCY)");
                InvoiceReceived[2] := InvoiceReceived[2] - VendorLedgEntry."Purchase (LCY)";
            until VendorLedgEntry.NEXT() = 0;
        if "Sub-Levels" then begin
            SubcontractCalc.SETFILTER("NS_Posting Date Filter", YTD);
            InvoiceReceived[2] := InvoiceReceived[2] + Rec.NS_SLsInvoicedCost(SubcontractCalc); //PRJ-1131.NK.1.0
            SubcontractCalc.SETRANGE("NS_Posting Date Filter");
        end;

        VendorLedgEntry.SETFILTER("Posting Date", MTD);
        VendorLedgEntry.SetRange("NS_Retention Document", false); //PRJ-1194.NK.1.0 09May2022 
        if VendorLedgEntry.FINDFIRST() then
            repeat
                VendorLedgEntry.CALCFIELDS("Amount (LCY)");
                InvoiceReceived[1] := InvoiceReceived[1] - VendorLedgEntry."Purchase (LCY)";
            until VendorLedgEntry.NEXT() = 0;
        if "Sub-Levels" then begin
            SubcontractCalc.SETFILTER("NS_Posting Date Filter", MTD);
            InvoiceReceived[1] := InvoiceReceived[1] + Rec.NS_SLsInvoicedCost(SubcontractCalc); //PRJ-1131.NK.1.0
            SubcontractCalc.SETRANGE("NS_Posting Date Filter");
        end;

        //end;
        //PRJ-1131.NK.1.0 End

        //Find Payments Made
        CLEAR(PaymentMade);
        SourceCodeSetup.GET();
        //PRJ-1131.NK.1.0 Start
        //with DetailedVendorLedgEntry do begin
        DetailedVendorLedgEntry.RESET();
        DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
        DetailedVendorLedgEntry.SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
        DetailedVendorLedgEntry.SETRANGE("Posting Date", 0D, WORKDATE);
        DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        PaymentMade[3] := DetailedVendorLedgEntry."Amount (LCY)";
        if "Sub-Levels" then
            PaymentMade[3] := PaymentMade[3] + Rec.NS_SLsPaymentMade(SubcontractCalc); //PRJ-1131.NK.1.0

        DetailedVendorLedgEntry.SETFILTER("Posting Date", YTD);
        DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        PaymentMade[2] := DetailedVendorLedgEntry."Amount (LCY)";
        if "Sub-Levels" then begin
            SubcontractCalc.SETFILTER("NS_Posting Date Filter", YTD);
            PaymentMade[2] := PaymentMade[2] + Rec.NS_SLsPaymentMade(SubcontractCalc); //PRJ-1131.NK.1.0
            SubcontractCalc.SETRANGE("NS_Posting Date Filter");
        end;

        DetailedVendorLedgEntry.SETFILTER("Posting Date", MTD);
        DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
        PaymentMade[1] := DetailedVendorLedgEntry."Amount (LCY)";
        if "Sub-Levels" then begin
            SubcontractCalc.SETFILTER("NS_Posting Date Filter", MTD);
            PaymentMade[1] := PaymentMade[1] + Rec.NS_SLsPaymentMade(SubcontractCalc); //PRJ-1131.NK.1.0
            SubcontractCalc.SETRANGE("NS_Posting Date Filter");
        end;
        //end;
        //PRJ-1131.NK.1.0 End
        //PRJ-1131.NK.1.0 Start 
        //with VendorLedgEntryRetention do begin
        CLEAR(RetentionHeld);
        VendorLedgEntryRetention.RESET();
        VendorLedgEntryRetention.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
        VendorLedgEntryRetention.SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
        VendorLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
        VendorLedgEntryRetention.SETRANGE("Posting Date", 0D, WORKDATE);
        if VendorLedgEntryRetention.FINDFIRST() then
            repeat
                VendorLedgEntryRetention.CALCFIELDS("Remaining Amount");
                RetentionHeld[3] -= VendorLedgEntryRetention."Remaining Amount";
            until VendorLedgEntryRetention.NEXT() = 0;
        VendorLedgEntryRetention.SETFILTER("Posting Date", YTD);
        if VendorLedgEntryRetention.FINDFIRST() then
            repeat
                VendorLedgEntryRetention.CALCFIELDS("Remaining Amount");
                RetentionHeld[2] -= VendorLedgEntryRetention."Remaining Amount";
            until VendorLedgEntryRetention.NEXT() = 0;
        VendorLedgEntryRetention.SETFILTER("Posting Date", MTD);
        if VendorLedgEntryRetention.FINDFIRST() then
            repeat
                VendorLedgEntryRetention.CALCFIELDS("Remaining Amount");
                RetentionHeld[1] -= VendorLedgEntryRetention."Remaining Amount";
            until VendorLedgEntryRetention.NEXT() = 0;
        //end;
        //PRJ-1131.NK.1.0 End
        //Find Calculated Values

        //Calculate Common Values
        TotalBudgetedCost := BudgetedCost + "Sub-LevelsCost";

        //Calculate Percent Completed
        if BudgetedCost + "Sub-LevelsCost" <> 0 then
            CalcPctComplete := ROUND((InvoiceReceived[3] / (BudgetedCost + "Sub-LevelsCost")), 0.0001)
        else
            CalcPctComplete := 0;

        //Calculate EstimatedTotalUnits
        EstimatedTotalUnits := 0;
        EstimatedTotalUnitsUOM := '';
        EstimatedMixedUnits := false;
        //PRJ-1131.NK.1.0 11Jan2022 Start
        //with SubcontractDetail do begin
        SubcontractDetail.RESET();
        SubcontractDetail.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
        if SubcontractDetail.FINDSET() then
            repeat
                if EstimatedTotalUnitsUOM = '' then
                    EstimatedTotalUnitsUOM := SubcontractDetail."NS_Work Unit of Measure";
                if SubcontractDetail."NS_Work Unit of Measure" <> EstimatedTotalUnitsUOM then begin
                    EstimatedTotalUnits := 0;
                    EstimatedTotalUnitsUOM := '';
                    EstimatedMixedUnits := true;
                end else
                    EstimatedTotalUnits := EstimatedTotalUnits + SubcontractDetail."NS_Work Units";
            until (SubcontractDetail.NEXT = 0) or EstimatedMixedUnits;
        //end;
        //PRJ-1131.NK.1.0 11Jan2022 End

        //Calculate ActualTotalUnits
        ActualTotalUnits := 0;
        ActualTotalUnitsUOM := '';
        ActualMixedUnits := false;
        //PRJ-1131.NK.1.0 Start
        //with SubcontractLedgEntry do begin
        SubcontractLedgEntry.RESET();
        SubcontractLedgEntry.SETRANGE("NS_Subcontract No.", Rec."NS_No.");
        if SubcontractLedgEntry.FINDSET() then
            repeat
                if ActualTotalUnitsUOM = '' then
                    ActualTotalUnitsUOM := SubcontractLedgEntry."NS_Work Unit of Measure";
                if SubcontractLedgEntry."NS_Work Unit of Measure" <> ActualTotalUnitsUOM then begin
                    ActualTotalUnits := 0;
                    ActualTotalUnitsUOM := '';
                    ActualMixedUnits := true;
                end else
                    ActualTotalUnits := ActualTotalUnits + SubcontractLedgEntry."NS_Work Units";
            until (SubcontractLedgEntry.NEXT = 0) or ActualMixedUnits;
        //end;
        //PRJ-1131.NK.1.0 End
        //Calculate ActualPercentComplete
        ActualPercentComplete := 0;
        if (EstimatedTotalUnits <> 0) and
           ((EstimatedTotalUnitsUOM = ActualTotalUnitsUOM) or
            ((ActualTotalUnitsUOM = '') and not ActualMixedUnits)) then
            ActualPercentComplete := ROUND((ActualTotalUnits / EstimatedTotalUnits) * 100, 2);

        //Calculate values in Budget and Costs Tabs
        NS_StatusBudgetCalc;
        NS_StatusCostCategoryCalc;
    end;

    procedure NS_StatusBudgetCalc();
    begin
        //Start of calculations on Budget tab
        //PRJ-1131.NK.1.0 Start
        //with SubcontractCalc do begin
        //[1,1] - Budget - Actual Costs To Date
        CalcValues[1, 1] := InvoiceReceived[3];

        //[1,2] - Budget - Actual Coists To Date %
        if TotalBudgetedCost <> 0 then
            CalcValues[1, 2] := CalcValues[1, 1] / TotalBudgetedCost
        else
            CalcValues[1, 2] := 0;

        //[1,3] - Budget - Est. Budget Remaining
        CalcValues[1, 3] := TotalBudgetedCost - InvoiceReceived[3];

        //[1,4] - Budget - Est. Budget Remaining %
        if TotalBudgetedCost <> 0 then
            CalcValues[1, 4] := CalcValues[1, 3] / TotalBudgetedCost
        else
            CalcValues[1, 4] := 0;

        //[1,5] - Budget - Estimated Profit (Loss)
        if InvoiceReceived[3] > TotalBudgetedCost then //PRJ-1160.NK.1.0 03Feb2022
            CalcValues[1, 5] := ABS(TotalBudgetedCost - InvoiceReceived[3])
        ELSE //PRJ-1160.NK.1.0 03Feb2022
            CalcValues[1, 5] := 0; //PRJ-1160.NK.1.0 03Feb2022


        //[1,6] - Budget - Estimated Profit (Loss) %
        if TotalBudgetedCost <> 0 then begin
            if InvoiceReceived[3] > TotalBudgetedCost then //PRJ-1160.NK.1.0 03Feb2022
                CalcValues[1, 6] := Abs(CalcValues[1, 5] / TotalBudgetedCost)
            ELSE //PRJ-1160.NK.1.0 03Feb2022
                CalcValues[1, 6] := 0; //PRJ-1160.NK.1.0 03Feb2022
        END else
            CalcValues[1, 6] := 0;

        //[1,7] - Budget - Est. Units
        CalcValues[1, 7] := EstimatedTotalUnits;

        //[1,8] - Budget - Est. Unit Rates
        if CalcValues[1, 7] <> 0 then
            CalcValues[1, 8] := TotalBudgetedCost / CalcValues[1, 7]
        else
            CalcValues[1, 8] := 0;

        //[1,9] - Budget - Committed
        CalcValues[1, 9] := CommittedCost;

        //[1,10] - Budget - Committed %
        if TotalBudgetedCost <> 0 then
            CalcValues[1, 10] := CommittedCost / TotalBudgetedCost
        else
            CalcValues[1, 10] := 0;

        //[1,11] - Budget - Actual % Complete
        CalcValues[1, 11] := ActualPercentComplete;

        //[1,12] - Budget - NOT USED
        CalcValues[1, 12] := 0;

        //[1,13] - Budget - Act. Budget Remaining
        if ActualPercentComplete <> 0 then
            CalcValues[1, 13] := (InvoiceReceived[3] / (ActualPercentComplete / 100)) - InvoiceReceived[3]
        else
            CalcValues[1, 13] := 0;

        //[1,14] - Budget - Act. Budget Remaining %
        if ActualPercentComplete <> 0 then
            CalcValues[1, 14] := (InvoiceReceived[3] / (ActualPercentComplete / 100)) * ((100 - ActualPercentComplete) / 100)
        else
            CalcValues[1, 14] := 100;

        if CalcValues[1, 14] <> 0 then
            CalcValues[1, 14] := CalcValues[1, 13] / CalcValues[1, 14];

        //[1,15] - Budget - Act. Current Profit (Loss)
        CalcValues[1, 15] := (TotalContract * (ActualPercentComplete / 100)) - InvoiceReceived[3];

        //[1,16] - Budget - Act. Current Profit (Loss) %
        if InvoiceReceived[3] <> 0 then
            CalcValues[1, 16] := CalcValues[1, 15] / InvoiceReceived[3]
        else
            CalcValues[1, 16] := 0;

        //[1,17] - Budget - Act. Units
        CalcValues[1, 17] := ActualTotalUnits;

        //[1,18] - Budget - Act. Unit Rates
        if CalcValues[1, 17] <> 0 then
            CalcValues[1, 18] := InvoiceReceived[3] / CalcValues[1, 17]
        else
            CalcValues[1, 18] := 0;

        //[1,19] - Budget - Commited
        CalcValues[1, 19] := CommittedCost;

        //[1,20] - Budget - Committed %
        if ActualPercentComplete <> 0 then
            CalcValues[1, 20] := InvoiceReceived[3] / (ActualPercentComplete / 100)
        else
            CalcValues[1, 20] := 0;

        if CalcValues[1, 20] <> 0 then
            CalcValues[1, 20] := CommittedCost / CalcValues[1, 20];

        //[1,40] - Total Budgeted Cost
        CalcValues[1, 40] := TotalBudgetedCost;
        //end;
        //PRJ-1131.NK.1.0 End
    end;

    procedure NS_StatusCostCategoryCalc();
    begin
        //Start of calculations on Cost Category Totals sub-tab of Status tab

        //[2,1] - Cost Category Matrix
        for i := 1 to 40 do
            CLEAR(CalcValues[2, i]);

        //Fill in Budget Cost
        SubcontractDetail.RESET();
        SubcontractDetail.SETCURRENTKEY("NS_Subcontract No.", "NS_Job No.", "NS_Activity Code", "NS_Process Code",
                                        "NS_Operation Code", "NS_Job Cost Category");
        SubcontractDetail.SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
        if SubcontractDetail.FINDSET() then
            repeat
                Amount := SubcontractDetail."NS_Total Cost";
                if SubcontractDetail."NS_Job Cost Category" = '' then
                    CalcValues[2, 29] := CalcValues[2, 29] + Amount
                else
                    //PRJ-1131.NK.1.0 11Jan2022 Start
                    //with JobCostCategory do begin
                    if JobCostCategory.GET(SubcontractDetail."NS_Job Cost Category") then
                        case JobCostCategory.NS_Type of
                            JobCostCategory.NS_Type::Labor:
                                CalcValues[2, 1] := CalcValues[2, 1] + Amount;
                            JobCostCategory.NS_Type::Material:
                                CalcValues[2, 5] := CalcValues[2, 5] + Amount;
                            JobCostCategory.NS_Type::Equipment:
                                CalcValues[2, 9] := CalcValues[2, 9] + Amount;
                            JobCostCategory.NS_Type::Subcontract:
                                CalcValues[2, 13] := CalcValues[2, 13] + Amount;
                            JobCostCategory.NS_Type::Manufacturing:
                                CalcValues[2, 17] := CalcValues[2, 17] + Amount;
                            JobCostCategory.NS_Type::Overhead:
                                CalcValues[2, 21] := CalcValues[2, 21] + Amount;
                            JobCostCategory.NS_Type::Miscellaneous:
                                CalcValues[2, 25] := CalcValues[2, 25] + Amount;
                        end
                    else
                        CalcValues[2, 29] := CalcValues[2, 29] + Amount;
            //end;
            //PRJ-1131.NK.1.0 11Jan2022 End
            until SubcontractDetail.NEXT() = 0;

        if "Sub-Levels" then
            //Add in Sub-Level Orders
            //PRJ-1131.NK.1.0 11Jan2022 Start
            //with JobCostCategory2 do begin
                JobCostCategory2.RESET();
        if JobCostCategory2.FINDSET() then
            repeat
                SubcontractCalc.SETRANGE("NS_Cost Category Filter", JobCostCategory2.NS_Code);
                Amount := Rec.NS_SLsBudgetedCost(SubcontractCalc); //PRJ-1131.NK.1.0
                SubcontractCalc.SETRANGE("NS_Cost Category Filter");
                case JobCostCategory2.NS_Type of
                    JobCostCategory2.NS_Type::Labor:
                        CalcValues[2, 1] := CalcValues[2, 1] + Amount;
                    JobCostCategory2.NS_Type::Material:
                        CalcValues[2, 5] := CalcValues[2, 5] + Amount;
                    JobCostCategory2.NS_Type::Equipment:
                        CalcValues[2, 9] := CalcValues[2, 9] + Amount;
                    JobCostCategory2.NS_Type::Subcontract:
                        CalcValues[2, 13] := CalcValues[2, 13] + Amount;
                    JobCostCategory2.NS_Type::Manufacturing:
                        CalcValues[2, 17] := CalcValues[2, 17] + Amount;
                    JobCostCategory2.NS_Type::Overhead:
                        CalcValues[2, 21] := CalcValues[2, 21] + Amount;
                    JobCostCategory2.NS_Type::Miscellaneous:
                        CalcValues[2, 25] := CalcValues[2, 25] + Amount;
                end;
            until JobCostCategory2.NEXT() = 0;
        //end;
        //PRJ-1131.NK.1.0 11Jan2022 End

        //Fill in Actual Cost
        SubcontractLedgEntry2.RESET();
        SubcontractLedgEntry2.SETCURRENTKEY("NS_Subcontract No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                                        "NS_Job Cost Category", "NS_Entry Type");
        SubcontractLedgEntry2.SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
        SubcontractLedgEntry2.SETRANGE("NS_Entry Type", SubcontractLedgEntry2."NS_Entry Type"::Purchase);
        if SubcontractLedgEntry2.FINDSET() then
            repeat
                Amount := SubcontractLedgEntry2."NS_Total Cost (LCY)";
                if SubcontractLedgEntry2."NS_Job Cost Category" = '' then
                    CalcValues[2, 30] := CalcValues[2, 30] + Amount
                else
                    //PRJ-1131.NK.1.0 Start
                    //with JobCostCategory do begin
                    if JobCostCategory.GET(SubcontractLedgEntry2."NS_Job Cost Category") then
                        case JobCostCategory.NS_Type of
                            JobCostCategory.NS_Type::Labor:
                                CalcValues[2, 2] := CalcValues[2, 2] + Amount;
                            JobCostCategory.NS_Type::Material:
                                CalcValues[2, 6] := CalcValues[2, 6] + Amount;
                            JobCostCategory.NS_Type::Equipment:
                                CalcValues[2, 10] := CalcValues[2, 10] + Amount;
                            JobCostCategory.NS_Type::Subcontract:
                                CalcValues[2, 14] := CalcValues[2, 14] + Amount;
                            JobCostCategory.NS_Type::Manufacturing:
                                CalcValues[2, 18] := CalcValues[2, 18] + Amount;
                            JobCostCategory.NS_Type::Overhead:
                                CalcValues[2, 22] := CalcValues[2, 22] + Amount;
                            JobCostCategory.NS_Type::Miscellaneous:
                                CalcValues[2, 26] := CalcValues[2, 26] + Amount;
                        end
                    else
                        CalcValues[2, 30] := CalcValues[2, 30] + Amount;
            //end;
            //PRJ-1131.NK.1.0 End
            until SubcontractLedgEntry2.NEXT() = 0;

        if "Sub-Levels" then
            //Add in Sub-Levels Orders
            //PRJ-1131.NK.1.0 Start
            //with JobCostCategory2 do begin
                JobCostCategory2.RESET();
        if JobCostCategory2.FINDSET() then
            repeat
                SubcontractCalc.SETRANGE("NS_Cost Category Filter", JobCostCategory2.NS_Code);
                Amount := Rec."NS_SLsUsage(Cost)"(SubcontractCalc); //PRJ-1131.NK.1.0
                SubcontractCalc.SETRANGE("NS_Cost Category Filter");
                case JobCostCategory2.NS_Type of
                    JobCostCategory2.NS_Type::Labor:
                        CalcValues[2, 2] := CalcValues[2, 2] + Amount;
                    JobCostCategory2.NS_Type::Material:
                        CalcValues[2, 6] := CalcValues[2, 6] + Amount;
                    JobCostCategory2.NS_Type::Equipment:
                        CalcValues[2, 10] := CalcValues[2, 10] + Amount;
                    JobCostCategory2.NS_Type::Subcontract:
                        CalcValues[2, 14] := CalcValues[2, 14] + Amount;
                    JobCostCategory2.NS_Type::Manufacturing:
                        CalcValues[2, 18] := CalcValues[2, 18] + Amount;
                    JobCostCategory2.NS_Type::Overhead:
                        CalcValues[2, 22] := CalcValues[2, 22] + Amount;
                    JobCostCategory2.NS_Type::Miscellaneous:
                        CalcValues[2, 26] := CalcValues[2, 26] + Amount;
                end;
            until JobCostCategory2.NEXT() = 0;
        //end;
        //PRJ-1131.NK.1.0 End
        //Fill in Variance & Variance %
        for i := 0 to 7 do begin
            CalcValues[2, (i * 4) + 3] := CalcValues[2, (i * 4) + 1] - CalcValues[2, (i * 4) + 2];
            CalcValues[2, (i * 4) + 4] := NS_VariancePercent(CalcValues[2, (i * 4) + 3], CalcValues[2, (i * 4) + 1]);
        end;

        //Fill in total line
        for i := 0 to 7 do begin
            CalcValues[2, 33] := CalcValues[2, 33] + CalcValues[2, (i * 4) + 1];
            CalcValues[2, 34] := CalcValues[2, 34] + CalcValues[2, (i * 4) + 2];
            CalcValues[2, 35] := CalcValues[2, 35] + CalcValues[2, (i * 4) + 3];
            CalcValues[2, 36] := NS_VariancePercent(CalcValues[2, 35], CalcValues[2, 33]);
        end;
    end;

    procedure NS_VariancePercent(Numerator: Decimal; Denominator: Decimal): Decimal;
    begin
        if Denominator = 0 then
            if Numerator = 0 then
                exit(0)
            else
                exit(-100)
        else
            exit(ROUND((Numerator / Denominator) * 100, 0.01));
    end;

    procedure NS_GetPersonResponsibleName();
    // >> Upgrade
    var
        Salesperson: Record "Salesperson/Purchaser";
    // << Upgrade
    begin
        if Rec."NS_Person Responsible" > '' then //PRJ-1131.NK.1.0
            // >> Upgrade
            //if Resource.GET(Rec."NS_Person Responsible") then //PRJ-1131.NK.1.0
                //PersonResponsibleName := Resource.Name
            if Salesperson.Get("NS_Person Responsible") then
                PersonResponsibleName := Salesperson.Name
            // << Upgrade
            else
                PersonResponsibleName := Text1000
        else
            PersonResponsibleName := '';
    end;

    local procedure NS_BuyfromVendorNoOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    local procedure NS_PersonResponsibleOnAfterValida();
    begin
        NS_GetPersonResponsibleName();
    end;

    local procedure NS_ManagerSubcontractStatusOnAfte();
    begin
        NS_CalcStatistics;
    end;

    //PRJ-1036.GK.1.0 22Nov2021 start
    local procedure NS_OpenJobPlanningLinesPage()
    var

        NS_JobPlanningLine: Record "Job Planning Line";
        JobPlanningListPage: Page "Job Planning Lines";
    begin
        //PRJ-1131.NK.1.0 11Jan2022 Start
        //with NS_JobPlanningLine do begin
        JobPlanningListPage.LOOKUPMODE := true;
        NS_JobPlanningLine.SETRANGE("Job No.", Rec."NS_Job No.");
        NS_JobPlanningLine.SETFILTER("Line Type", '%1|%2', NS_JobPlanningLine."Line Type"::Budget,
                                      NS_JobPlanningLine."Line Type"::"Both Budget and Billable");
        JobPlanningListPage.SETTABLEVIEW(NS_JobPlanningLine);
        JobPlanningListPage.SetGetFrom(true, Rec."NS_No.", '');
        JobPlanningListPage.RUNMODAL;
        CLEAR(JobPlanningListPage);
        //end;
        //PRJ-1131.NK.1.0 11Jan2022 End
    end;
    //PRJ-1036.GK.1.0 22Nov2021 end
    // >> Upgrade
    local procedure SetHideForecast()
    begin
        // >> 002 New Function
        if "NS_Job No." = '' then
            HideForecast := true
        else
            HideForecast := false
        // << 002
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreOnAfterGetRecord(var SubContract: Record NS_Subcontract; var Variation: Boolean)
    begin
    end;
    // << Upgrade
    //PE-177.DK.1.0 10Nov2023 Start
    local procedure NSManagerStatusEdite(): Boolean
    var
        myInt: Integer;
        NS_Job: Record NS_Subcontract;
    begin
        NS_SubconCRManagerStatus := true;
        NS_Job.SetRange("NS_No.", Rec."NS_No.");
        NS_Job.SetRange("NS_Subcon Class", NS_Job."NS_Subcon Class"::"Change Request");
        NS_Job.SetRange("NS_Manager Subcontract Status", NS_Job."NS_Manager Subcontract Status"::Completed);
        if NS_Job.FindFirst() then
            NS_SubconCRManagerStatus := false;
        exit(NS_SubconCRManagerStatus);
    end;
    //PE-177.DK.1.0 10Nov2023 End
    //PRJCTPR-332.Dk.1.0 07March2023 Start
    procedure NS_Subcontractstatus(): Boolean
    var
        myInt: Integer;
        NS_Job: Record NS_Subcontract;
    begin
        NS_Job.SetRange("NS_No.", Rec."NS_No.");
        NS_Job.SetRange("NS_Subcon Class", NS_Job."NS_Subcon Class"::"Change Request");
        if NS_Job.FindFirst() then begin
            NS_SubconStatus := false;
        end else
            NS_SubconStatus := true;
        exit(NS_SubconStatus);
    end;
    //PRJCTPR-332.Dk.1.0 07March2023 End
}

