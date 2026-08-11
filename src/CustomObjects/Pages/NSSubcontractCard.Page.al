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
    Caption = 'Subcontract Card';
    PageType = Card;
    SourceTable = NS_Subcontract;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

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
                        if AssistEdit(xRec) then
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
                        if "NS_Job No." <> '' then begin
                            if Job_L.get("NS_Job No.") then begin
                                "NS_Person Responsible" := Job_L."Person Responsible";
                                if Resouce_L.Get("NS_Person Responsible") then
                                    PersonResponsibleName := Resouce_L.Name;
                            end;
                        end;
                        //PRJ-383.AS.1.0 12OCT2020 - end
                        if "NS_Job No." <> '' then begin
                            with SubcontractDetail do begin
                                IncompatibleLines := false;
                                RESET();
                                SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                                if FINDSET() then
                                    repeat
                                        if SubcontractDetail."NS_Job No." <> '' then
                                            if not JobLinks.GET("NS_Job No.", Rec."NS_Job No.") then
                                                IncompatibleLines := true;
                                    until (NEXT() = 0) or IncompatibleLines;

                                if IncompatibleLines then
                                    if not CONFIRM(Text1001Lbl, true, Rec."NS_Job No.") then
                                        ERROR(Text1002Lbl)
                                    else begin
                                        RESET();
                                        SETRANGE("NS_Subcontract No.", Rec."NS_No.");
                                        if FINDSET() then
                                            repeat
                                                if "NS_Job No." <> '' then begin
                                                    "NS_Job No." := Rec."NS_Job No.";

                                                    //Check Job Task No.
                                                    if "NS_Job Task No." > '' then begin
                                                        JobPlanningLine.RESET();
                                                        JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
                                                        JobPlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
                                                        if JobPlanningLine.COUNT() = 0 then
                                                            "NS_Job Task No." := '';
                                                    end;
                                                    MODIFY();
                                                end;
                                            until NEXT() = 0;
                                    end;
                            end;
                            NS_ClearExistingDimensions("NS_No.");
                            NS_SetDimensions("NS_No.", "NS_Job No.");
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
                    ToolTip = 'Specifies the No.';
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
                field("Starting Date"; Rec."NS_Starting Date")
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
                }
                //PRJ-533.AS.1.0 - START
                field("NS_Subcon Class"; "NS_Subcon Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcon Class';
                }
                //PRJ-533.AS.1.0 - END
            }
            group(Manager)
            {
                Caption = 'Manager';
                field("Manager Subcontract Status"; Rec."NS_Manager Subcontract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Reporting Status';
                    ToolTip = 'Specifies the Reporting Status';

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
                    ToolTip = 'Actual Cost Job to Date';

                    trigger OnValidate();
                    begin
                        PurchaseLineList.NS_SetVendor("NS_Buy-from Vendor No.");
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
                    ToolTip = '[Total Units] from General Tab';
                }
                field("CalcValues[1,8]"; CalcValues[1, 8])
                {
                    ApplicationArea = All;
                    Caption = '     Budgeted Cost per Unit';
                    Editable = false;
                    ToolTip = '[Total Budgeted Cost] / [Total Units] from General Tab';
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
                        CommittedLineList.NS_SetSubcontract("NS_No.");
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
                field("CalcValues[1,40]"; CalcValues[1, 40])
                {
                    ApplicationArea = All;
                    Caption = 'Total Budgeted Costs';
                    Editable = false;
                    ToolTip = 'Specifies the Total Budgeted Costs';
                }
                field("CalcValues[1,11]"; CalcValues[1, 11])
                {
                    ApplicationArea = All;
                    Caption = 'Entered Complete [Calculated]';
                    Editable = false;
                    ToolTip = '[Actual Percent Complete] from General Tab';
                }
                field("CalcValues[1,13]"; CalcValues[1, 13])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Budget Remaining';
                    Editable = false;
                    ToolTip = '[Actual Costs To Date] / ([Entered Complete] / 100)';
                }
                field("CalcValues[1,14] * 100"; CalcValues[1, 14] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Entered Complete';
                    Editable = false;
                    ToolTip = 'Percent of [Act. Budget Remaining] / ([Actual Costs To Date] / ([Entered Complete] / 100))';
                }
                field("CalcValues[1,15]"; CalcValues[1, 15])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Subcontract Variance';
                    Editable = false;
                    ToolTip = '[Total Contract] * ([Entered Complete] / 100) - [Actual Costs To Date]';
                }
                field("CalcValues[1,16] * 100"; CalcValues[1, 16] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Actual Costs to Date';
                    Editable = false;
                    ToolTip = 'Percent of [Actual Current Profit (Loss)] / [Actual Costs to Date]';
                }
                field("CalcValues[1,17]"; CalcValues[1, 17])
                {
                    ApplicationArea = All;
                    Caption = 'Actual Units and Unit Rates';
                    Editable = false;
                    ToolTip = '[Actual Units Complete] from General Tab';
                }
                field("CalcValues[1,18]"; CalcValues[1, 18])
                {
                    ApplicationArea = All;
                    Caption = '     Avg. Cost per Unit Complete';
                    Editable = false;
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
                        CommittedLineList.NS_SetSubcontract("NS_No.");
                        CommittedLineList.RUNMODAL;
                        CLEAR(CommittedLineList);
                    end;
                }
                field("CalcValues[1,20] * 100"; CalcValues[1, 20] * 100)
                {
                    ApplicationArea = All;
                    Caption = '     Prct of Entered Complete';
                    Editable = false;
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
                field(Starting_Date; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Starting Date';
                    Editable = false;
                }
                field(EstimatedCompletionDate; Rec."NS_Estimated Completion Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Estimated Completion Date';
                }
                field(Ending_Date; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Ending Date';
                    Editable = false;
                    ToolTip = 'Specifies the Actual Ending Date';
                }
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
                        "Sub-LevelSubcontracts".SETFILTER("NS_Sub-LeveltoSubcontractNo.", "NS_No.");
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
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
                                ShowVLEEntries.SETRANGE("Posting Date", DMY2DATE(1, DATE2DMY(WORKDATE(), 2), DATE2DMY(WORKDATE(), 3)), WORKDATE());
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
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
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
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
                                ShowSubcontractRec.SETRANGE("NS_Posting Date Filter", DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3)), WORKDATE());
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
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
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
                        Caption = '                                     Contract to Date'; //PRJ-659.RM.1.0 22Oct2021
                        field(InvoiceReceivedJTD; InvoiceReceived[3])
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the Invoice Recevied';

                            trigger OnDrillDown();
                            begin
                                ShowVLEEntries.RESET();
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
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
                                ShowVLEEntries.SETRANGE("NS_Subcontract No.", "NS_No.");
                                ShowVLEEntries.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
                                VendorLedgerEntries.SETTABLEVIEW(ShowVLEEntries);
                                VendorLedgerEntries.RUNMODAL;
                                CLEAR(VendorLedgerEntries);
                            end;
                        }
                    }
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
                        NS_ShowDocDim();
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
                        VendorInsurance.SETRANGE("NS_Vendor No.", "NS_Buy-from Vendor No.");
                        VendorInsurance.SETFILTER("NS_Expiration Date", '>=%1', WORKDATE);
                        VendorInsurances.SETTABLEVIEW(VendorInsurance);
                        VendorInsurances.RUN;
                    end;
                }
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
                                    Error('Subcontract Default UOM field is mandatory in Job setup, Please fill it first to proceed')
                            end;
                        end;
                        //PPAL-113.AS.1.0 10SEPT2020 - END
                        CLEAR(JobPlanningList);//PRJ-209.5.0 Added
                        with JobPlanningLine do begin
                            JobPlanningList.LOOKUPMODE := true;
                            SETRANGE("Job No.", Rec."NS_Job No.");
                            SETFILTER("Line Type", '%1|%2', "Line Type"::Budget,
                                                          "Line Type"::"Both Budget and Billable");
                            JobPlanningList.SETTABLEVIEW(JobPlanningLine);
                            JobPlanningList.SetGetFrom(true, Rec."NS_No.", '');
                            JobPlanningList.RUNMODAL;
                            // CLEAR(JobPlanningList);//PRJ-209.5.0Commented
                        end;
                    end;
                }
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
                        NS_SubConCreateChangeOrder();
                        //ProjectPro - end
                    end;
                }
                //PRJ-533.AS.1.0 16FEB2020 - END                                
                action(MakePurchaseDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Make Purchase Document';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    tooltip = 'Make Purchase Document';

                    trigger OnAction();
                    begin
                        //PRJ-383.N.S.1.0 16sep2020 start
                        if not Confirm('Do you want to create the purchase order') then
                            exit
                        else
                            //PRJ-383.N.S.1.0 16Sep2020 end
                        NS_MakePurchaseDocument(Rec);
                    end;
                }
                action(PurchaseDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    ToolTip = 'Purchase Document';
                    trigger OnAction();
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.RESET();
                        PurchHeader.SETRANGE("No.", "NS_Purchase Document No.");
                        if PurchHeader.FINDFIRST() then
                            PAGE.RUNMODAL(PAGE::"NS_Subcontract PO", PurchHeader)
                        else
                            ERROR(Text1003_Txt);
                    end;
                }
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
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var//PRJ-383.AS.1.0 12OCT2020 
        Resource_L: Record Resource;//PRJ-383.AS.1.0 12OCT2020 
    begin
        "NS_Subcon Class" := "NS_Subcon Class"::"Master Job";//PRJ-533.AS.1.0
        NS_GetPersonResponsibleName;
        if GETFILTER("NS_Job No.") <> '' then begin
            "NS_Job No." := GETFILTER("NS_Job No.");
            if Job.GET("NS_Job No.") then
                "NS_Dimension Set ID" := GetDimensionNoFromJob("NS_Job No.");
            //PRJ-383.AS.1.0 12OCT2020  - start
            "NS_Person Responsible" := Job."Person Responsible";
            if Resource_L.Get(Job."Person Responsible") then
                PersonResponsibleName := Resource_L.Name;
            //PRJ-383.AS.1.0 12OCT2020  -  end
        end;

    end;

    trigger OnOpenPage();
    begin
        JobsSetup.GET();
        PurchSetup.GET();
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
        "Sub-LevelsCost" := NS_SLsBudgetedCost(SubcontractCalc);

        //Set Period Dates
        MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        //Find Committed Cost
        with PurchaseLine do begin
            RESET;
            SETCURRENTKEY("NS_Subcontract No.");
            // >> Upgrade
            SetRange("Document Type", "Document Type"::Order); // #RG008
            // << Upgrade
            SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
            CALCSUMS("NS_Committed Amount");
            CommittedCost := "NS_Committed Amount";
        end;

        //Find Invoice Received
        with VendorLedgEntry do begin
            CLEAR(InvoiceReceived);
            RESET();
            SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
            SETRANGE("NS_Subcontract No.", "NS_No.");
            SETRANGE("NS_Retention Ledger Code", PurchSetup."NS_Normal Vendor Ledger No.");
            SETRANGE("Posting Date", 0D, WORKDATE);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Amount (LCY)");
                    InvoiceReceived[3] := InvoiceReceived[3] - "Purchase (LCY)";
                until NEXT() = 0;
            if "Sub-Levels" then
                InvoiceReceived[3] := InvoiceReceived[3] + NS_SLsInvoicedCost(SubcontractCalc);

            SETFILTER("Posting Date", YTD);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Amount (LCY)");
                    InvoiceReceived[2] := InvoiceReceived[2] - "Purchase (LCY)";
                until NEXT() = 0;
            if "Sub-Levels" then begin
                SubcontractCalc.SETFILTER("NS_Posting Date Filter", YTD);
                InvoiceReceived[2] := InvoiceReceived[2] + NS_SLsInvoicedCost(SubcontractCalc);
                SubcontractCalc.SETRANGE("NS_Posting Date Filter");
            end;

            SETFILTER("Posting Date", MTD);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Amount (LCY)");
                    InvoiceReceived[1] := InvoiceReceived[1] - "Purchase (LCY)";
                until NEXT() = 0;
            if "Sub-Levels" then begin
                SubcontractCalc.SETFILTER("NS_Posting Date Filter", MTD);
                InvoiceReceived[1] := InvoiceReceived[1] + NS_SLsInvoicedCost(SubcontractCalc);
                SubcontractCalc.SETRANGE("NS_Posting Date Filter");
            end;

        end;

        //Find Payments Made
        CLEAR(PaymentMade);
        SourceCodeSetup.GET();
        with DetailedVendorLedgEntry do begin
            RESET();
            SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
            SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
            SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
            SETRANGE("Posting Date", 0D, WORKDATE);
            CALCSUMS("Amount (LCY)");
            PaymentMade[3] := "Amount (LCY)";
            if "Sub-Levels" then
                PaymentMade[3] := PaymentMade[3] + NS_SLsPaymentMade(SubcontractCalc);

            SETFILTER("Posting Date", YTD);
            CALCSUMS("Amount (LCY)");
            PaymentMade[2] := "Amount (LCY)";
            if "Sub-Levels" then begin
                SubcontractCalc.SETFILTER("NS_Posting Date Filter", YTD);
                PaymentMade[2] := PaymentMade[2] + NS_SLsPaymentMade(SubcontractCalc);
                SubcontractCalc.SETRANGE("NS_Posting Date Filter");
            end;

            SETFILTER("Posting Date", MTD);
            CALCSUMS("Amount (LCY)");
            PaymentMade[1] := "Amount (LCY)";
            if "Sub-Levels" then begin
                SubcontractCalc.SETFILTER("NS_Posting Date Filter", MTD);
                PaymentMade[1] := PaymentMade[1] + NS_SLsPaymentMade(SubcontractCalc);
                SubcontractCalc.SETRANGE("NS_Posting Date Filter");
            end;
        end;

        with VendorLedgEntryRetention do begin
            CLEAR(RetentionHeld);
            RESET();
            SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
            SETRANGE("NS_Subcontract No.", SubcontractCalc."NS_No.");
            SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
            SETRANGE("Posting Date", 0D, WORKDATE);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Remaining Amount");
                    RetentionHeld[3] -= "Remaining Amount";
                until NEXT() = 0;
            SETFILTER("Posting Date", YTD);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Remaining Amount");
                    RetentionHeld[2] -= "Remaining Amount";
                until NEXT() = 0;
            SETFILTER("Posting Date", MTD);
            if FINDFIRST() then
                repeat
                    CALCFIELDS("Remaining Amount");
                    RetentionHeld[1] -= "Remaining Amount";
                until NEXT() = 0;
        end;

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
        with SubcontractDetail do begin
            RESET();
            SETRANGE("NS_Subcontract No.", "NS_No.");
            if FINDSET() then
                repeat
                    if EstimatedTotalUnitsUOM = '' then
                        EstimatedTotalUnitsUOM := "NS_Work Unit of Measure";
                    if "NS_Work Unit of Measure" <> EstimatedTotalUnitsUOM then begin
                        EstimatedTotalUnits := 0;
                        EstimatedTotalUnitsUOM := '';
                        EstimatedMixedUnits := true;
                    end else
                        EstimatedTotalUnits := EstimatedTotalUnits + "NS_Work Units";
                until (NEXT = 0) or EstimatedMixedUnits;
        end;

        //Calculate ActualTotalUnits
        ActualTotalUnits := 0;
        ActualTotalUnitsUOM := '';
        ActualMixedUnits := false;
        with SubcontractLedgEntry do begin
            RESET();
            SETRANGE("NS_Subcontract No.", "NS_No.");
            if FINDSET() then
                repeat
                    if ActualTotalUnitsUOM = '' then
                        ActualTotalUnitsUOM := "NS_Work Unit of Measure";
                    if "NS_Work Unit of Measure" <> ActualTotalUnitsUOM then begin
                        ActualTotalUnits := 0;
                        ActualTotalUnitsUOM := '';
                        ActualMixedUnits := true;
                    end else
                        ActualTotalUnits := ActualTotalUnits + "NS_Work Units";
                until (NEXT = 0) or ActualMixedUnits;
        end;

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

        with SubcontractCalc do begin
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
            CalcValues[1, 5] := TotalBudgetedCost - InvoiceReceived[3];

            //[1,6] - Budget - Estimated Profit (Loss) %
            if TotalBudgetedCost <> 0 then
                CalcValues[1, 6] := CalcValues[1, 5] / TotalBudgetedCost
            else
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
        end;
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
                    with JobCostCategory do begin
                        if GET(SubcontractDetail."NS_Job Cost Category") then
                            case NS_Type of
                                NS_Type::Labor:
                                    CalcValues[2, 1] := CalcValues[2, 1] + Amount;
                                NS_Type::Material:
                                    CalcValues[2, 5] := CalcValues[2, 5] + Amount;
                                NS_Type::Equipment:
                                    CalcValues[2, 9] := CalcValues[2, 9] + Amount;
                                NS_Type::Subcontract:
                                    CalcValues[2, 13] := CalcValues[2, 13] + Amount;
                                NS_Type::Manufacturing:
                                    CalcValues[2, 17] := CalcValues[2, 17] + Amount;
                                NS_Type::Overhead:
                                    CalcValues[2, 21] := CalcValues[2, 21] + Amount;
                                NS_Type::Miscellaneous:
                                    CalcValues[2, 25] := CalcValues[2, 25] + Amount;
                            end
                        else
                            CalcValues[2, 29] := CalcValues[2, 29] + Amount;
                    end;
            until SubcontractDetail.NEXT() = 0;

        if "Sub-Levels" then
            //Add in Sub-Level Orders
            with JobCostCategory2 do begin
                RESET();
                if FINDSET() then
                    repeat
                        SubcontractCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        Amount := NS_SLsBudgetedCost(SubcontractCalc);
                        SubcontractCalc.SETRANGE("NS_Cost Category Filter");
                        case NS_Type of
                            NS_Type::Labor:
                                CalcValues[2, 1] := CalcValues[2, 1] + Amount;
                            NS_Type::Material:
                                CalcValues[2, 5] := CalcValues[2, 5] + Amount;
                            NS_Type::Equipment:
                                CalcValues[2, 9] := CalcValues[2, 9] + Amount;
                            NS_Type::Subcontract:
                                CalcValues[2, 13] := CalcValues[2, 13] + Amount;
                            NS_Type::Manufacturing:
                                CalcValues[2, 17] := CalcValues[2, 17] + Amount;
                            NS_Type::Overhead:
                                CalcValues[2, 21] := CalcValues[2, 21] + Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[2, 25] := CalcValues[2, 25] + Amount;
                        end;
                    until NEXT() = 0;
            end;

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
                    with JobCostCategory do begin
                        if GET(SubcontractLedgEntry2."NS_Job Cost Category") then
                            case NS_Type of
                                NS_Type::Labor:
                                    CalcValues[2, 2] := CalcValues[2, 2] + Amount;
                                NS_Type::Material:
                                    CalcValues[2, 6] := CalcValues[2, 6] + Amount;
                                NS_Type::Equipment:
                                    CalcValues[2, 10] := CalcValues[2, 10] + Amount;
                                NS_Type::Subcontract:
                                    CalcValues[2, 14] := CalcValues[2, 14] + Amount;
                                NS_Type::Manufacturing:
                                    CalcValues[2, 18] := CalcValues[2, 18] + Amount;
                                NS_Type::Overhead:
                                    CalcValues[2, 22] := CalcValues[2, 22] + Amount;
                                NS_Type::Miscellaneous:
                                    CalcValues[2, 26] := CalcValues[2, 26] + Amount;
                            end
                        else
                            CalcValues[2, 30] := CalcValues[2, 30] + Amount;
                    end;
            until SubcontractLedgEntry2.NEXT() = 0;

        if "Sub-Levels" then
            //Add in Sub-Levels Orders
            with JobCostCategory2 do begin
                RESET();
                if FINDSET() then
                    repeat
                        SubcontractCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        Amount := "NS_SLsUsage(Cost)"(SubcontractCalc);
                        SubcontractCalc.SETRANGE("NS_Cost Category Filter");
                        case NS_Type of
                            NS_Type::Labor:
                                CalcValues[2, 2] := CalcValues[2, 2] + Amount;
                            NS_Type::Material:
                                CalcValues[2, 6] := CalcValues[2, 6] + Amount;
                            NS_Type::Equipment:
                                CalcValues[2, 10] := CalcValues[2, 10] + Amount;
                            NS_Type::Subcontract:
                                CalcValues[2, 14] := CalcValues[2, 14] + Amount;
                            NS_Type::Manufacturing:
                                CalcValues[2, 18] := CalcValues[2, 18] + Amount;
                            NS_Type::Overhead:
                                CalcValues[2, 22] := CalcValues[2, 22] + Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[2, 26] := CalcValues[2, 26] + Amount;
                        end;
                    until NEXT() = 0;
            end;

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
        if "NS_Person Responsible" > '' then
            // >> Upgrade
            // if Resource.GET("NS_Person Responsible") then
            //     PersonResponsibleName := Resource.Name
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
}

