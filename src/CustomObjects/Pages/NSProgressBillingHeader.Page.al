page 14021325 "NS_Progress Billing Header"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +  - GLEI-11.MS.1.0001 added new action of Progress Invoice with unit	
    //PRJ-203:AS:21APRIL2020 Duplicated GLEI-11 work
    //CTSI-41.AS.1.0 08MAY2020 Added New action to run report "AIA G703 - Revenue wise"
    //CTSI-41.AS.1.0 13May2020 : Changed Caption
    //CTSI-41.AS.1.0 21MAY2020 Added Revenue Category Description Field.
    // +------------------------------------------------------------
    //PRJ-301.AS.1.0 : Increased length of chars
    //PPAL-106.AS.1.0 13AUG20 Done code in Progress billing header to modify work retention percent on progress billing line & also commented an error
    //CTSI-105.AS.1.0 Done code in Progress billing header to modify work retention percent on progress billing line & also commented an error //PPAL-106
    //CTSI-121.N.S.1.0 18Aug2020 add field manager & person responsible
    // Code Commented PRJ-338.AS.1.0 08Sept2020 Commented code
    //PRJ-764.RS.1.0 30June21 | Voided progress billings not viewable
    //PRJ-820.JS.1.0�03Aug2021 | Add action button Suggest Billing by Task under Functions   
    //PRJ-858.GK.1.0 24Aug2021 | Add action for Combined AIA G702 and AIA G703. 
    //PRJ-999.JS.1.0 10Nov2021 | Add Code
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1519.NK.1.0 22Jul2022 | Added field
    //PRJ-1624.NK.1.0 22Sep2022 | Added Field
    //PRJ-1711.RM.1.0 24Nov2022 | Added a tooltip 
    //PRJ-1708.JS.1.0 02DEC2022 | Add logic 
    //PE-215.HS.1.0 15Jan2024 | Added tooltip
    // PRJCTPR-293.HS.1.0 19Jan2024 | Added Code
    Caption = 'Progress Billing';
    PageType = Card;
    SourceTable = "NS_Progress Billing Header";
    UsageCategory = Documents;
    ApplicationArea = Jobs;
    ContextSensitiveHelpPage = 'user-guide/progress-billing/progress-billings/'; //PRJ-1085.RM.1.0 16Dec2021

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Editable = "No.Editable";
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate();
                    begin
                        ProgressBillingHeader.RESET();
                        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                        if ProgressBillingHeader.FINDFIRST() then
                            ERROR(Text009Lbl)
                        else begin
                            "NS_Requisition No." := 1;
                            "NS_Version No." := 0;
                        end;

                        if STRLEN("NS_Job No.") > 0 then
                            if Job.GET("NS_Job No.") then begin
                                JobName := Job.Description;
                                Rec."NS_Invoiced Currency Code" := Job."Invoice Currency Code";//PRJCTPR-364.PS.1.0 07May2024
                                NS_GetCustomerName();
                                if "NS_Work Retention Percent" = 0 then
                                    "NS_Work Retention Percent" := Job."NS_Default Job Retention";
                                if "NS_Material Retention Percent" = 0 then
                                    if (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                                       (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then
                                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
                            end else begin
                                JobName := '';
                                CustomerNo := '';
                                CustomerName := '';
                            end;
                    end;
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition No.';

                    ToolTip = 'Requisition No.';
                    Editable = false;
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    Caption = 'Version No.';

                    ToolTip = 'Version No.';
                    Editable = false;
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';

                    ToolTip = 'Job No.';
                    Editable = "Job No.Editable";

                    trigger OnValidate();
                    begin
                        NS_JobNoOnAfterValidate();
                    end;
                }
                field(JobName; JobName)
                {
                    ApplicationArea = All;
                    Caption = 'Job Name';

                    ToolTip = 'Job Name';
                    Editable = false;
                }
                field("Draw No."; Rec."NS_Draw No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Draw No.';
                }
                field(CustomerNo; CustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';

                    ToolTip = 'Customer No.';
                    Editable = false;
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';

                    ToolTip = 'Customer Name';
                    Editable = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 Start
                field(Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the manager';
                }
                field(ManagerName; ManagerName)
                {
                    ApplicationArea = All;
                    Caption = 'Manager Name';
                    Editable = false;


                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Person Responsible';
                }
                field(PersonResponsibleName; PersonResponsibleName)
                {
                    ApplicationArea = all;
                    Caption = 'Person Responsible Name';
                    Editable = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 End
                field("Round Amounts"; Rec."NS_Round Amounts")
                {
                    ApplicationArea = All;
                    Editable = "Round AmountsEditable";
                    ToolTip = 'Specifies the Round Amounts';

                    trigger OnValidate();
                    begin
                        NS_RoundAmountsOnAfterValidate();
                    end;
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    Caption = 'Final';

                    ToolTip = 'Final';
                    Editable = FinalEditable;
                }
                //PRJ-1624.NK.1.0 22Sep2022 Start
                field("NS_Multiple Retention on Lines"; Rec."NS_Multiple Retention on Lines")
                {
                    ApplicationArea = all;
                    Caption = 'Multiple Retention % on Lines';
                    // ToolTip = 'In order to enter different retention percentages on each line turn on "Multiple Retention Lines". This specifies that progress billing lines may have multiple retention percentages.'; //PRJ-1711.RM.1.0 24Nov2022 commented
                    ToolTip = 'If the "Multiple Retention Line" button is on, it will allow you to put in different Retention % or values at the Progress Billing Line Level.'; //PRJ-1711.RM.1.0 24Nov2022
                    trigger OnValidate()
                    begin
                        if Rec."NS_Multiple Retention on Lines" then begin
                            RetEditable := false;
                            Rec.validate("NS_Material Retention Percent", 0);
                            Rec.Validate("NS_Work Retention Percent", 0);
                        end else
                            RetEditable := true;
                    end;
                }
                //PRJ-1624.NK.1.0 22Sep2022 End
                field("Owner Contact Type"; Rec."NS_Owner Contact Type")
                {
                    ApplicationArea = All;
                    Caption = 'Owner Contact';

                    ToolTip = 'Owner Contact';
                    Editable = "Owner Contact TypeEditable";

                    trigger OnValidate();
                    begin
                        NS_OwnerContactTypeOnAfterValidat();
                    end;
                }
                field("Owner Contact Code"; Rec."NS_Owner Contact Code")
                {
                    ApplicationArea = All;
                    Editable = "Owner Contact CodeEditable";
                    LookupPageID = "NS_Job Contacts List";
                    ToolTip = 'Specifies the Owner Contact Code';
                }
                field("Arch Eng Contact Type"; Rec."NS_Arch Eng Contact Type")
                {
                    ApplicationArea = All;
                    Caption = 'Arch/Eng Contact';

                    ToolTip = 'Arch/Eng Contact';
                    Editable = "Arch Eng Contact TypeEditable";
                }
                field("Arch Eng Contact Code"; Rec."NS_Arch Eng Contact Code")
                {
                    ApplicationArea = All;
                    Editable = "Arch Eng Contact CodeEditable";
                    LookupPageID = "NS_Job Contacts List";
                    ToolTip = 'Specifies the Arch Eng Contact Code';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';

                    ToolTip = 'Status';
                    Editable = StatusEditable;

                    trigger OnValidate();
                    begin
                        if NS_Status = NS_Status::Void then
                            ERROR(Text010Lbl);
                    end;
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';

                    ToolTip = 'Document No.';
                    Editable = false;
                }
                //PRJ-1332.GK.2.0 12May2022 start
                field("NS_Posted Sales Invoice No."; Rec."NS_Posted Sales Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.';
                    ApplicationArea = All;
                }
                //PRJ-1332.GK.2.0 12May2022 end
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Date';

                    ToolTip = 'Requisition Date';
                    Editable = "Requisition DateEditable";
                }
                field("Period To"; Rec."NS_Period To")
                {
                    Caption = 'Period To';

                    ToolTip = 'Period To';
                    ApplicationArea = All;
                    Editable = "Period ToEditable";
                }

                //PRJ-1648.PS.1.0 07OCT2022 - Start

                field("NS_R_Reduction & Invoicing"; Rec."NS_R_Reduction & Invoicing")
                {
                    Caption = 'Retention Reduction & Invoicing';
                    ApplicationArea = All;
                    ToolTip = 'Enable this boolean if the Retention% is reduced and further billing is done on same Progress Bill';
                    //ENU = 'Enable this boolean if the Retention% is reduced and further billing is done on same Progress Bill';
                }
                //PRJ-1648.PS.1.0 07OCT2022 - End
                //PE-22.JS.1.0 21FEB2023 - Start
                field("NS_Invoiced Currency Code"; Rec."NS_Invoiced Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced Currency Code';
                    ToolTip = 'This field present the FCY Currency Code from the Job Card Invoiced Currency Code. Use to create the Sales Invoice in FCY from Progress Billings';

                }
                //PE-22.JS.1.0 21FEB2023 - end
                //PE-320.JS.1.0 04July2024-Start
                field("NS_Disable Auto Post Cr. Memo"; Rec."NS_Disable Auto Post Cr. Memo")
                {
                    Caption = 'Disable Auto Post Cr. Memo';
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if you want to disable the auto credit memo post and application upon creating "New Version". This will allow you only to void the current requisition and the credit memo has to be created/posted/applied manually against the related posted invoice.', Comment = '%';
                }
                //PE-320.JS.1.0 04July2024-end
            }
            part(Control16; "NS_Progress Billing Subform")
            {
                ApplicationArea = All;
                SubPageLink = "NS_Progress Billing No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No.");
                // SubPageView = ORDER(Ascending);
            }
            group(Retention)
            {
                Caption = 'Retention';
                Editable = RetEditable; //PRJ-1624.NK.1.0 22Sep2022
                field("Work Retention %"; Rec."NS_Work Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = "Work Retention %Editable";
                    ToolTip = 'Enter the Retention Percentage which will be calcualted on the Work Amount'; //PRJ-1519.NK.1.0 08Sep2022

                    trigger OnValidate();
                    var
                        TProgBillLine: Record "NS_Progress Billing Line";//PPAL-106.AS.1.0 13AUG20	 //CTSI-105.AS.1.0
                    begin
                        //CTSI-105.AS.1.0 - START
                        //PPAL-106.AS.1.0 13AUG20 - START
                        TProgBillLine.Reset();
                        TProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        TProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        TProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        IF TProgBillLine.FindSet then
                            repeat
                                //PRJ-1519.NK.1.0 14Sep2022 Block Start
                                // if TProgBillLine."NS_Work Amount" <> 0 then
                                //     TProgBillLine."NS_Work Retention Percent" := rec."NS_Work Retention Percent"
                                // else
                                //     TProgBillLine."NS_Work Retention Percent" := 0;
                                //PRJ-1519.NK.1.0 14Sep2022 Block End
                                TProgBillLine."NS_Work Retention Percent" := rec."NS_Work Retention Percent"; //PRJ-1519.NK.1.0 14Sep2022
                                TProgBillLine.Modify;
                                CurrPage.Update(false);
                            until TProgBillLine.Next = 0;
                        //CTSI-105.AS.1.0 - end
                        //PPAL-106.AS.1.0 13AUG20 - end

                        if "NS_Work Retention Percent" <> 0 then
                            NS_CheckLineWorkRetention();
                        NS_WorkRetentionPercentOnAfterVal();
                    end;
                }
                field("Material Retention Percent"; Rec."NS_Material Retention Percent")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    //Caption = 'Material Retention %'; //PRJ-1519.NK.1.0 29Aug2022 Block
                    Caption = 'Material Retention Percent'; //PRJ-1519.NK.1.0 29Aug2022
                    //ToolTip = 'Material Retention %'; //PRJ-1519.NK.1.0 29Aug2022 Block
                    ToolTip = 'Enter the Retention Percentage which will be calcualted on the Stored Material Amount'; //PRJ-1519.NK.1.0 08Sep2022
                    Editable = MaterialRetentionPercentEditab;

                    trigger OnValidate();
                    var
                        TProgBillLine: Record "NS_Progress Billing Line";  //PRJ-1519.NK.1.0 29Aug2022
                    begin
                        //PRJ-1519.NK.1.0 29Aug2022 Start
                        TProgBillLine.Reset();
                        TProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        TProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        TProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        IF TProgBillLine.FindSet() then
                            repeat
                                TProgBillLine."NS_Material Retention Percent" := rec."NS_Material Retention Percent";
                                TProgBillLine."NS_Stored Material Retention %" := Rec."NS_Material Retention Percent";
                                TProgBillLine."NS_Stored Mat. Retention Amt" := ROUND(TProgBillLine."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100), 0.0001);
                                TProgBillLine.Modify();
                                CurrPage.Update(false);
                            until TProgBillLine.Next() = 0;
                        //PRJ-1519.NK.1.0 29Aug2022 End
                        if Rec."NS_Material Retention Percent" <> 0 then //PRJ-1131.NK.1.0
                            NS_CheckLineMaterialRetention();
                        NS_MaterialRetentionPercentOnAfte();
                    end;
                }
                field("Manual Retention Amount"; Rec."NS_Manual Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = ManualRetentionAmountEditable;
                    ToolTip = 'Enter the Work Retention Amount which will be equally distributed among all the lines, where the Work Amount is present.'; //PRJ-1519.NK.1.0 08Sep2022
                    //PRJ-1519.NK.1.0 22Jul2022 Start
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                    //PRJ-1519.NK.1.0 22Jul2022 End
                }
                field("NS_Manual Stored Mat. Ret. Amt"; rec."NS_Manual Stored Mat. Ret. Amt")
                {
                    ApplicationArea = All;
                    Editable = ManualRetentionAmountEditable;
                    ToolTip = 'Enter the Stored material Retention Amount which will be equally distributed among all the lines, where the Stored Material Amount is present.'; //PRJ-1519.NK.1.0 08Sep2022
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;

                }
                //PRJ-1519.NK.1.0 22Jul2022 Start
                field("NS_Lines Total Retention Amt"; Rec."NS_Lines Total Retention Amt")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field shows the Total value of Work retention for all the lines.'; //PRJ-1519.NK.1.0 08Sep2022
                }
                field("NS_Stored Material Ret. Amt"; rec."NS_Stored Material Ret. Amt")
                {
                    ApplicationArea = all;
                    ToolTip = 'This Field shows the Total value of Stored Material Retention Amount for all the lines.'; //PRJ-1519.NK.1.0 08Sep2022

                }
                field("Total Retention Amount"; Rec."NS_Lines Total Retention Amt" + rec."NS_Stored Material Ret. Amt")
                {
                    ApplicationArea = all;
                    ToolTip = 'Total Retention Amount is the sum of Work Retention Amount and Stored Material Retention Amount'; //PRJ-1519.NK.1.0 08Sep2022
                }
                //PRJ-1519.NK.1.0 22Jul2022 End
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Requisition")
            {
                Caption = '&Requisition';
                action(NS_Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';

                    ToolTip = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "NS_Progress Billing Statistics";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                    ShortCutKey = 'F7';
                }
                //PE-118.NC.1.0 02Aug2023 Start
                action("NS_GetJobPlanningLines")
                {
                    ApplicationArea = all;
                    Caption = 'Get Job Planning Lines';
                    ToolTip = 'This option enables user to select the required Billable Job Planning Lines (Schedule of Value) based on the related Job and its sub-Levels. Selecting Planning Lines from this option will only show exclusive lines which do not exist on the Progress Billing Lines.';
                    Promoted = true;
                    Enabled = EnableGJPL;
                    PromotedCategory = Process;
                    Image = GetEntries;
                    trigger OnAction()
                    var
                        NS_GetJobPlanningLines: Report NS_GetJobPlanningLines;
                    begin
                        Rec.TestField("NS_Job No.");
                        Rec.TestField("NS_Requisition No.");
                        rec.TestField("NS_Requisition Date");
                        Rec.TestField("NS_Period To");
                        NS_GetJobPlanningLines.NS_GetOpenProgessBilling(Rec."NS_Job No.", true, Rec."NS_No.", Rec."NS_Requisition No.", Rec."NS_Version No.");
                        NS_GetJobPlanningLines.RunModal();
                    end;
                }
                //PE-118.NC.1.0 02Aug2023 End
                action("NS_Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';

                    ToolTip = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "NS_ProgressBillingCommentSheet";
                    RunPageLink = "NS_No." = FIELD("NS_No."),
                                  "NS_Requisition No." = FIELD("NS_Requisition No."),
                                  "NS_Version No." = FIELD("NS_Version No.");
                }
            }
            group("NS_&Job")
            {
                Caption = '&Job';
                action(NS_Card)
                {
                    Caption = 'Card';

                    ToolTip = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("NS_Job No.");
                    ApplicationArea = All;
                }
                action("NS_Job Contacts")
                {
                    ApplicationArea = All;
                    Caption = 'Job Contacts';

                    ToolTip = 'Job Contacts';
                    Image = TeamSales;
                    RunObject = Page "NS_Job Contacts List";
                    RunPageLink = "NS_Job No." = FIELD("NS_Job No.");
                }
            }
        }
        area(processing)
        {
            action("NS_Price &Budget")
            {
                ApplicationArea = All;
                Caption = 'Price &Budget';

                ToolTip = 'Price &Budget';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Planning Lines";
                RunPageLink = "Job No." = FIELD("NS_Job No.");
                RunPageView = SORTING("Job No.", "NS_Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Cost Category", Type, "No.", "Variant Code")
                              ORDER(Ascending)
                              WHERE("Line Type" = FILTER(Billable | "Both Budget and Billable"));
            }
            //PRJ-999.JS.1.0 09Nov2021 -Start
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View Dimensions';

                trigger OnAction();
                begin
                    Rec.NS_ShowDocDim();
                    CurrPage.SAVERECORD();
                end;
            }
            //PRJ-999.JS.1.0 09Nov2021 -end
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(NS_GetBillings)
                {
                    ApplicationArea = All;
                    Caption = 'Get Billings';

                    ToolTip = 'Get Billings';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = true;
                    Enabled = GateBilling; //PE-118.NC.1.0 03Aug2023
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        //JobPlanningLine: Record "Job Planning Line";
                        GetContract: Report "NS_Get Contact forProgressBill";
                        JobRec: Record Job;

                    begin
                        if "NS_No." > '' then
                            if NS_Status = NS_Status::Open then begin
                                if "NS_Job No." <> '' then
                                    JobRec.SETFILTER("No.", "NS_Job No.");
                                //PE-151.JS.1.0 10JULY2023 - Start
                                if (rec."NS_Requisition Date" = 0D) or (rec."NS_Period To" = 0D) then
                                    Error('Please enter "Requisition Date" and "Period To Date."');
                                //PE-151.JS.1.0 10JULY2023 - end  
                                GetContract.SetParameters("NS_No.", "NS_Requisition No.", "NS_Version No.");
                                GetContract.SETTABLEVIEW(JobRec);
                                GetContract.RUNMODAL;
                                CLEAR(GetContract);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                action(NS_GetBillingForecase)
                {
                    ApplicationArea = All;
                    Caption = 'Get Billing Forecast';

                    ToolTip = 'Get Billing Forecast';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;
                    Visible = false;//PRJ-820
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            if NS_Status = NS_Status::Open then begin
                                GetBillingForecast.SetParameters("NS_No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.");
                                GetBillingForecast.RUNMODAL;
                                CLEAR(GetBillingForecast);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                action(NS_CopyComments)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Comments';
                    // ToolTip = 'Copy Comments';   //PRJCTPR-293.HS.1.0 30Jan2024 commented
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;
                    // PRJCTPR-293.HS.1.0 19Jan2024 Start
                    RunObject = page "NS_Progress BillingCommentList";
                    RunPageLink = "NS_No." = field("NS_No."), "NS_Requisition No." = field("NS_Requisition No."), "NS_Version No." = field("NS_Version No.");
                    ToolTip = 'Copy the comments from one requisition to another or add a new comment for current requisition.';
                    // PRJCTPR-293.HS.1.0 19Jan2024 End
                    trigger OnAction();
                    begin
                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            Rec.NS_CopyCommentLines(Rec); //PRJ-1131.NK.1.0
                    end;
                }
                action(NS_GetJobForecasts)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Forecasts';

                    ToolTip = 'Get Job Forecasts';
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;
                    Visible = false;//PRJ-820
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        if "NS_No." > '' then
                            NS_GetJobForecast(Rec);
                    end;
                }

                //PRJ-820.JS.1.0�03Aug2021-Start
                action(NS_SuggestBillingByTask)
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Billing By Task';

                    ToolTip = 'Calculate Suggested Billing By Task on the basis of APO Link';   //PRJCTPR-235.JS.1.0 22DEC2023                    
                    Ellipsis = true;
                    Image = SuggestVendorBills;
                    Promoted = false;

                    trigger OnAction();
                    begin
                        if Rec."NS_No." > '' then
                            if Rec.NS_Status = Rec.NS_Status::Open then begin
                                //GetBillingByTask.SetParameters(Rec."NS_No.", Rec."NS_Requisition No.", Rec."NS_Version No.", Rec."NS_Job No.");   //PRJCTPR-235.JS.1.0 line commented
                                GetBillingByTask.SetParameters(Rec."NS_No.", Rec."NS_Requisition No.", Rec."NS_Version No.", Rec."NS_Job No.", rec."NS_Period To");   //PRJCTPR-235.JS.1.0 line added
                                GetBillingByTask.RUNMODAL;
                                CLEAR(GetBillingByTask);
                            end else
                                ERROR(Text011Lbl);
                    end;
                }
                //PRJ-820.JS.1.0�03Aug2021-end
                separator(Separator1000000004)
                {
                }
                action(NewRequisition)
                {
                    ApplicationArea = All;
                    Caption = 'New Requisition';
                    Visible = false;//PRJ-1036.GK.1.0 22Nov2021
                    ToolTip = 'New Requisition';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        //Result := NewRequisition(Rec);
                        Result := PBNewDocument.NS_NewRequisition(Rec);
                        if Result <> -1 then begin
                            SETRANGE("NS_Requisition No.", Result);
                            SETRANGE("NS_Version No.", 0);
                            SETRANGE("NS_Requisition No.");
                            SETRANGE("NS_Version No.");
                        end;
                    end;
                }
                action(NS_NewVersion)
                {
                    ApplicationArea = All;
                    Caption = 'New Version';
                    Visible = false; //PRJ-1036.GK.1.0 22Nov2021
                    ToolTip = 'New Version';
                    Image = NewWarehouseShipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                    begin
                        if "NS_No." > '' then begin
                            //Result := NewVersion(Rec);
                            Result := PBNewDocument.NS_NewVersion(Rec);
                            if Result <> -1 then begin
                                SETRANGE("NS_Version No.", Result);
                                SETRANGE("NS_Version No.");
                            end;
                        end;
                    end;
                }

                //PRJ-1036.GK.1.0 22Nov2021 start
                action(MGL_NewRequisition)
                {
                    ApplicationArea = All;
                    Caption = 'New Requisition';

                    ToolTip = 'New Requisition';
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                        PBNewDocument: Codeunit "NS_Progress BillingNewDocument";
                        COJob: Record Job;
                        ChangeOrderJobCount: Integer;
                        COExists: Boolean;
                        Text51010: Label 'There are %1 new change Orders, would you like to add them to this requisition';
                        Text51011Lbl: Label 'This function can only be run on Open versions.';
                    begin
                        //Result := NewRequisition(Rec);
                        COJob.Reset();
                        COJob.SetRange("NS_Sub-Level to Job No.", Rec."NS_Job No.");
                        COJob.SetRange("NS_Job Class", COJob."NS_Job Class"::"Change Order");
                        COJob.SetRange(Status, COJob.Status::Open);
                        COJob.SetRange("NS_Progress Billing Sub-Level", false);
                        COJob.SetFilter("NS_Progress Billing No.", '%1', '');
                        ChangeOrderJobCount := COJob.Count;
                        COExists := COJob.FindFirst();
                        if COExists then begin
                            if Confirm(StrSubstNo(text51010, ChangeOrderJobCount), false) then begin
                                //if Rec.NS_Status = Rec.NS_Status::Open then begin   //PRJ-1216.JS.7.0 29MAR2022  line blocked
                                if (Rec.NS_Status = Rec.NS_Status::Open) or (Rec.NS_Status = Rec.NS_Status::Invoiced) then begin  //PRJ-1216.JS.7.0 29MAR2022  line added
                                    Result := PBNewDocument.NS_NewRequisitionCO(Rec);
                                    if Result <> -1 then begin
                                        rec.SETRANGE("NS_Requisition No.", Result);
                                        rec.SETRANGE("NS_Version No.", 0);
                                        rec.SETRANGE("NS_Requisition No.");
                                        rec.SETRANGE("NS_Version No.");
                                    end;
                                end else
                                    Error(Text51011Lbl);
                            end else begin
                                Result := PBNewDocument.NS_NewRequisition(Rec);
                                if Result <> -1 then begin
                                    rec.SETRANGE("NS_Requisition No.", Result);
                                    rec.SETRANGE("NS_Version No.", 0);
                                    rec.SETRANGE("NS_Requisition No.");
                                    rec.SETRANGE("NS_Version No.");
                                end;
                            end;
                        end else begin
                            Result := PBNewDocument.NS_NewRequisition(Rec);
                            if Result <> -1 then begin
                                rec.SETRANGE("NS_Requisition No.", Result);
                                rec.SETRANGE("NS_Version No.", 0);
                                rec.SETRANGE("NS_Requisition No.");
                                rec.SETRANGE("NS_Version No.");
                            end;
                        end;
                    end;
                }
                action(MGL_NewVersion)
                {
                    ApplicationArea = All;
                    Caption = 'New Version';

                    ToolTip = 'New Version';
                    Image = NewWarehouseShipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        Result: Integer;
                        PBNewDocument: Codeunit "NS_Progress BillingNewDocument";
                        COJob: Record Job;
                        NS_SalesSetup: Record "Sales & Receivables Setup";  //PE-302.JS.1.0 10JUN2024
                        NSSalesHeaderApplyCud: Codeunit "NS_Sales Header Apply"; //PE-302.JS.1.0 10JUN2024
                        COExists: Boolean;
                        ChangeOrderJobCount: Integer;
                        Text51010: Label 'There are %1 new change Orders, would you like to add them to this requisition';
                        Text51011Lbl: Label 'This function can only be run on Open versions.';
                        Text51012Lbl: Label 'You have to delete the unposted Sales Invoice No. %1';//PRJ-744.GK.1.0 18May2022
                        Text51013Lbl: Label 'You have to create a Credit Memo for the Posted Sales Invoice No. %1';//PRJ-744.GK.1.0 18May2022
                        Text51014Lbl: Label 'A new credit memo will be created for the Posted Sales Invoice No. %1';//PRJ-1523.GK.1.0 28July2022
                        Text51015Lbl: Label 'Credit memo has been Posted, Do you want to open Credit Memo?'; //PRJ-1523.GK.1.0 28July2022
                        SalesInvoiceHeader: Record "Sales Invoice Header"; //PRJ-1523.GK.1.0 28July2022
                        CPSI: Codeunit "Correct Posted Sales Invoice"; //PRJ-1523.GK.1.0 28July2022
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header"; //PRJ-1523.GK.1.0 28July2022
                        Text51016Lbl: Label 'Are you certain you want to make a New Version for this requisition?'; //PRJCTPR-190.NC.1.0 25Sep2023
                    begin
                        //MGLBC-28
                        //PRJCTPR-190.NC.1.0 18Sep2023 Start
                        if Rec.NS_Status = Rec.NS_Status::Void then
                            error('The current Status of the requisition %1 is %2. To create a new version, the status must be Invoiced.', rec."NS_No." + '.' + Format(Rec."NS_Requisition No.") + '.' + Format(Rec."NS_Version No."), Rec.NS_Status);
                        if not Confirm(Text51016Lbl, false) then
                            exit;
                        //PRJCTPR-190.NC.1.0 18Sep2023 End
                        //PRJ-744.GK.1.0 18May2022 start
                        //PRJCTPR-378.DK.1.0 10June2024 Start
                        //if (Rec."NS_Posted Sales Invoice No." = '') AND (Rec."NS_Sales Document No." <> '') then begin
                        // Message(Text51012Lbl, Rec."NS_Sales Document No.");
                        // end;
                        //PRJCTPR-378.DK.1.0 10June2024 End
                        if rec."NS_Disable Auto Post Cr. Memo" = false then begin  //PE-320.JS.1.0 04July2024 line added
                            if (Rec."NS_Posted Sales Invoice No." <> '') AND (Rec."NS_Sales Document No." <> '') then begin
                                //PRJCTPR-306.PS.1.0 08Feb2024 Start Commented 
                                //PRJ-1523.GK.1.0 28July2022 start
                                //Message(Text51013Lbl, Rec."NS_Posted Sales Invoice No.");
                                // if SalesInvoiceHeader.Get(Rec."NS_Posted Sales Invoice No.") then begin
                                //     Message(Text51014Lbl, Rec."NS_Posted Sales Invoice No.");
                                //     if CPSI.Run(SalesInvoiceHeader) then begin
                                //         if Confirm(Text51015Lbl) then begin
                                //             SalesCrMemoHeader.Reset();
                                //             SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                //             SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Rec."NS_Posted Sales Invoice No.");
                                //             if SalesCrMemoHeader.FindFirst() then begin
                                //                 Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                //             end;

                                //         end;
                                //     end;
                                // end;
                                //PRJ-1523.GK.1.0 28July2022 end
                                //PRJCTPR-306.PS.1.0 08Feb2024 End Commented 
                                //PRJCTPR-306.PS.1.0 08Feb2024 Start
                                SalesInvoiceHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_Job No.");
                                SalesInvoiceHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                SalesInvoiceHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No."); // PRJCTPR-353.PS.1.0 15April2024
                                if SalesInvoiceHeader.FindSet() then begin
                                    //PRJCTPR-378.DK.1.0 10June2024 Start
                                    if (Rec."NS_Posted Sales Invoice No." <> '') AND (Rec."NS_Sales Document No." <> '') AND (Rec.NS_Final = true) then begin
                                        if Confirm('This is a Final Requisition. Are you sure you want to continue?') then begin
                                            //PRJCTPR-378.DK.1.0 10June2024 End
                                            Message(Text51014Lbl, Rec."NS_Posted Sales Invoice No.");
                                            repeat
                                                CPSI.Run(SalesInvoiceHeader)
                                            Until SalesInvoiceHeader.Next = 0;
                                            if Confirm(Text51015Lbl) then begin
                                                //PE-302.JS.1.0 10JUN2024-Start
                                                if NS_SalesSetup.get() then;
                                                if NS_SalesSetup."NS_AutoApplySCM After Posting" = false then begin
                                                    SalesCrMemoHeader.Reset();
                                                    SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                                    SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Rec."NS_Posted Sales Invoice No.");
                                                    if SalesCrMemoHeader.FindFirst() then begin
                                                        Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                    end;
                                                end else begin
                                                    SalesCrMemoHeader.Reset();
                                                    SalesCrMemoHeader.SetRange("NS_AppliesToDocument Type", SalesCrMemoHeader."NS_AppliesToDocument Type"::Invoice);
                                                    SalesCrMemoHeader.setrange("NS_AppliesToDocument No.", Rec."NS_Posted Sales Invoice No.");
                                                    if SalesCrMemoHeader.FindFirst() then begin
                                                        Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                    end else begin
                                                        SalesCrMemoHeader.Reset();
                                                        SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                                        SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Rec."NS_Posted Sales Invoice No.");
                                                        if SalesCrMemoHeader.FindFirst() then begin
                                                            Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                        end;
                                                    end;
                                                end;
                                            end else begin
                                                SalesCrMemoHeader.Reset();
                                                SalesCrMemoHeader.SetRange("NS_AppliesToDocument Type", SalesCrMemoHeader."NS_AppliesToDocument Type"::Invoice);
                                                SalesCrMemoHeader.setrange("NS_AppliesToDocument No.", Rec."NS_Posted Sales Invoice No.");
                                                if SalesCrMemoHeader.FindFirst() then begin
                                                    if NS_SalesSetup.get() then;
                                                    if NS_SalesSetup."NS_AutoApplySCM After Posting" = true then begin
                                                        if ((SalesCrMemoHeader."NS_From Progress Billing No." <> '') and (SalesCrMemoHeader."NS_Retention Percent" <> 0)) then begin
                                                            NSSalesHeaderApplyCud.NSApplyNormalSCMFromNormalInvoice(SalesCrMemoHeader);
                                                            NSSalesHeaderApplyCud.NSApplyRetentionSCMFromRetentionInvoice(SalesCrMemoHeader);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            //PE-302.JS.1.0 10JUN2024-end
                                        End;
                                        //PRJCTPR-378.DK.1.0 10June2024 Start
                                    end else begin
                                        Message(Text51014Lbl, Rec."NS_Posted Sales Invoice No.");
                                        repeat
                                            CPSI.Run(SalesInvoiceHeader)
                                        Until SalesInvoiceHeader.Next = 0;
                                        if Confirm(Text51015Lbl) then begin
                                            //PE-302.JS.1.0 10JUN2024-Start
                                            if NS_SalesSetup.get() then;
                                            if NS_SalesSetup."NS_AutoApplySCM After Posting" = false then begin
                                                SalesCrMemoHeader.Reset();
                                                SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                                SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Rec."NS_Posted Sales Invoice No.");
                                                if SalesCrMemoHeader.FindFirst() then begin
                                                    Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                end;
                                            end else begin
                                                SalesCrMemoHeader.Reset();
                                                SalesCrMemoHeader.SetRange("NS_AppliesToDocument Type", SalesCrMemoHeader."NS_AppliesToDocument Type"::Invoice);
                                                SalesCrMemoHeader.setrange("NS_AppliesToDocument No.", Rec."NS_Posted Sales Invoice No.");
                                                if SalesCrMemoHeader.FindFirst() then begin
                                                    Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                end else begin
                                                    SalesCrMemoHeader.Reset();
                                                    SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                                    SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Rec."NS_Posted Sales Invoice No.");
                                                    if SalesCrMemoHeader.FindFirst() then begin
                                                        Page.Run(Page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                                    end;
                                                end;
                                            end;
                                        end else begin
                                            SalesCrMemoHeader.Reset();
                                            SalesCrMemoHeader.SetRange("NS_AppliesToDocument Type", SalesCrMemoHeader."NS_AppliesToDocument Type"::Invoice);
                                            SalesCrMemoHeader.setrange("NS_AppliesToDocument No.", Rec."NS_Posted Sales Invoice No.");
                                            if SalesCrMemoHeader.FindFirst() then begin
                                                if NS_SalesSetup.get() then;
                                                if NS_SalesSetup."NS_AutoApplySCM After Posting" = true then begin
                                                    if ((SalesCrMemoHeader."NS_From Progress Billing No." <> '') and (SalesCrMemoHeader."NS_Retention Percent" <> 0)) then begin
                                                        NSSalesHeaderApplyCud.NSApplyNormalSCMFromNormalInvoice(SalesCrMemoHeader);
                                                        NSSalesHeaderApplyCud.NSApplyRetentionSCMFromRetentionInvoice(SalesCrMemoHeader);
                                                    end;
                                                end;
                                            end;
                                        end;
                                        //PE-302.JS.1.0 10JUN2024-end
                                    end;
                                End;
                                //PRJCTPR-378.DK.1.0 10June2024 End
                                //PRJCTPR-306.PS.1.0 08Feb2024 End


                            end;
                            //PRJ-744.GK.1.0 18May2022 end
                            IF Rec."NS_No." > '' then begin
                                COJob.Reset();
                                COJob.SetRange("NS_Sub-Level to Job No.", Rec."NS_Job No.");
                                COJob.SetRange(Status, COJob.Status::Open);
                                COJob.SetRange("NS_Job Class", COjob."NS_Job Class"::"Change Order");
                                COJob.SetRange("NS_Progress Billing Sub-Level", false);
                                COJob.SetFilter("NS_Progress Billing No.", '%1', '');
                                ChangeOrderJobCount := COJob.Count;
                                COExists := COJob.FindFirst();
                                if COExists then begin
                                    if Confirm(StrSubstNo(text51010, ChangeOrderJobCount), false) then begin
                                        //if Rec.NS_Status = Rec.NS_Status::Open then begin //PRJ-1216.JS.7.0 29MAR2022  line blocked
                                        if (Rec.NS_Status = Rec.NS_Status::Open) or (Rec.NS_Status = Rec.NS_Status::Invoiced) then begin  //PRJ-1216.JS.7.0 29MAR2022  line added
                                            Result := PBNewDocument.NS_NewVersionCO(Rec);
                                            if Result <> -1 then begin
                                                Rec.SETRANGE("NS_Version No.", Result);
                                                Rec.SETRANGE("NS_Version No.");
                                            end;
                                        end else
                                            Error(Text51011Lbl);
                                    end
                                end
                                //PRJCTPR-378.DK.1.0 10June2024 Start
                                else begin
                                    if (Rec."NS_Posted Sales Invoice No." = '') AND (Rec."NS_Sales Document No." = '') AND (Rec.NS_Final = true) then begin
                                        if Confirm('This is a Final Requisition. Are you sure you want to continue?') then begin //Dinesh
                                            Result := PBNewDocument.NS_NewVersion(Rec);
                                            if Result <> -1 then begin
                                                Rec.SETRANGE("NS_Version No.", Result);
                                                Rec.SETRANGE("NS_Version No.");
                                            end;
                                        end;
                                    end;
                                    if (Rec."NS_Posted Sales Invoice No." <> '') AND (Rec."NS_Sales Document No." <> '') AND (Rec.NS_Final = true) then begin
                                        //PRJCTPR-378.DK.1.0 10June2024 End
                                        Result := PBNewDocument.NS_NewVersion(Rec);
                                        if Result <> -1 then begin
                                            Rec.SETRANGE("NS_Version No.", Result);
                                            Rec.SETRANGE("NS_Version No.");
                                        end;
                                    end;
                                    //PRJCTPR-378.DK.1.0 10June2024 Start
                                    if (Rec."NS_Posted Sales Invoice No." = '') AND (Rec."NS_Sales Document No." <> '') AND (Rec.NS_Final = true) then begin
                                        if Confirm('This is a Final Requisition. Are you sure you want to continue?') then begin //Dinesh
                                            Message(Text51012Lbl, Rec."NS_Sales Document No.");
                                            Result := PBNewDocument.NS_NewVersion(Rec);
                                            if Result <> -1 then begin
                                                Rec.SETRANGE("NS_Version No.", Result);
                                                Rec.SETRANGE("NS_Version No.");
                                            end;
                                        end;
                                    end
                                    else begin
                                        if Rec.NS_Final = false then begin
                                            Result := PBNewDocument.NS_NewVersion(Rec);
                                            if Result <> -1 then begin
                                                Rec.SETRANGE("NS_Version No.", Result);
                                                Rec.SETRANGE("NS_Version No.");
                                            end;
                                        end;
                                        //PRJCTPR-378.DK.1.0 10June2024 End
                                    end
                                end;
                            end;
                            //PE-320.JS.1.0 04July2024-Start
                        end else begin
                            if Rec."NS_No." > '' then begin
                                Result := PBNewDocument.NS_NewVersion(Rec);
                                if Result <> -1 then begin
                                    Rec.SETRANGE("NS_Version No.", Result);
                                    Rec.SETRANGE("NS_Version No.");
                                end;
                            end;
                        end;
                        //PE-320.JS.1.0 04July2024-end
                    end;
                }
                //PRJ-1036.GK.1.0 22Nov2021 end

                separator(Separator1000000006)
                {
                }
                action(NS_MakeSalesDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Make Sales Document';

                    ToolTip = 'Make Sales Document';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        NSProgressBillingLine: Record "NS_Progress Billing Line"; //PRJCTPR-174.PS.1.0 Start 08Aug2023
                    begin
                        //PRJCTPR-174.PS.1.0 Start 08Aug2023 Start 
                        if Rec."NS_R_Reduction & Invoicing" = true then begin
                            NSWorkAmtLine := NS_CheckPBLineWorkAmount();
                            NSRetPercentage := NS_GetPreviousRetetionkunit();

                            if (NSWorkAmtLine = 0) or (NSRetPercentage = 0) then begin
                                Error('To use the “Retention Reduction & Invoicing” functionality, the Retention % has to be reduced in regard to previous requisition and some additional billing should be present for current requisition.The Sales Invoice cannot be created as one of the criteria is not fulfilled.If you are preparing a Retention Invoice Only with no additional billings, we recommend turning off the "Retention Reduction & Invoicing" feature.')
                            end else begin
                                Rec.CalcFields("NS_Lines Total Retention Amt");
                                if Rec."NS_Manual Retention Amount" <> 0 then
                                    if rec."NS_Manual Retention Amount" <> Round((Rec."NS_Lines Total Retention Amt"), 0.01, '=') then
                                        Error('Manual Retention Amount %1 not match with Line Total Retention Amount %2', rec."NS_Manual Retention Amount", Rec."NS_Lines Total Retention Amt");
                                //PRJ-1519.NK.1.0 22Jul2022 End
                                if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                                    if Rec.NS_Status = Rec.NS_Status::Void then //PRJ-1131.NK.1.0
                                        MESSAGE(Text012Lbl)
                                    else
                                        if (Rec."NS_Sales Document No." = '') and (Rec.NS_Status = Rec.NS_Status::Open) then begin //PRJ-1131.NK.1.0
                                            if Rec."NS_Period To" = 0D then //PRJ-1131.NK.1.0
                                                ERROR(Text013Lbl);
                                            //Rec.TestField(NS_Final);//PRJ-1332.GK.1.0 25Apr2022
                                            if CONFIRM(Text014Lbl, true) then begin
                                                PBDocProcess.Run;  //PRJ-1648.PS.1.0 16Dec2022
                                                PBDocProcess.NS_MakeReceivablesDocument(Rec);
                                            end else begin
                                                //   MESSAGE(Text015Lbl);//PRJCTPR-236.AT.1.0  07Dec2023 Commented
                                            end;
                                            //MakeReceivablesDocument(Rec);
                                        End;
                            end;
                        end else begin

                            //PRJCTPR-174.PS.1.0 Start 08Aug2023 End 
                            //PRJ-1519.NK.1.0 22Jul2022 Start
                            Rec.CalcFields("NS_Lines Total Retention Amt");
                            if Rec."NS_Manual Retention Amount" <> 0 then
                                if rec."NS_Manual Retention Amount" <> Round((Rec."NS_Lines Total Retention Amt"), 0.01, '=') then
                                    Error('Manual Retention Amount %1 not match with Line Total Retention Amount %2', rec."NS_Manual Retention Amount", Rec."NS_Lines Total Retention Amt");
                            //PRJ-1519.NK.1.0 22Jul2022 End
                            if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                                if Rec.NS_Status = Rec.NS_Status::Void then //PRJ-1131.NK.1.0
                                    MESSAGE(Text012Lbl)
                                else
                                    if (Rec."NS_Sales Document No." = '') and (Rec.NS_Status = Rec.NS_Status::Open) then begin //PRJ-1131.NK.1.0
                                        if Rec."NS_Period To" = 0D then //PRJ-1131.NK.1.0
                                            ERROR(Text013Lbl);
                                        //Rec.TestField(NS_Final);//PRJ-1332.GK.1.0 25Apr2022
                                        if CONFIRM(Text014Lbl, true) then begin
                                            PBDocProcess.Run;  //PRJ-1648.PS.1.0 16Dec2022
                                            PBDocProcess.NS_MakeReceivablesDocument(Rec);
                                        end else begin
                                            //  MESSAGE(Text015Lbl); //PRJCTPR-236.AT.1.0  07Dec2023 Commented
                                        end;
                                        //MakeReceivablesDocument(Rec);
                                    End;
                        End;
                    end;
                }
                action(NS_ViewSalesDocument)
                {
                    ApplicationArea = All;
                    Caption = 'View Sales Document';

                    tooltip = 'View Sales Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        SalesHeader: Record "Sales Header";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        if Rec."NS_Sales Document No." > '' then //PRJ-1131.NK.1.0
                            case Rec."NS_Sales Document Type" of //PRJ-1131.NK.1.0

                                Rec."NS_Sales Document Type"::Order: //PRJ-1131.NK.1.0
                                    if SalesHeader.GET(SalesHeader."Document Type"::Order, Rec."NS_Sales Document No.") then //PRJ-1131.NK.1.0
                                        PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader)
                                    else begin
                                        SalesInvoiceHeader.RESET();
                                        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", Rec."NS_Sales Document No."); //PRJ-1131.NK.1.0
                                        if SalesInvoiceHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader)
                                        else
                                            ERROR(Text016Lbl);
                                    end;

                                Rec."NS_Sales Document Type"::Invoice: //PRJ-1131.NK.1.0

                                    if SalesHeader.GET(SalesHeader."Document Type"::Invoice, Rec."NS_Sales Document No.") then begin
                                        //PRJ-1648.PS.1.0 07OCT2022 - Start

                                        SalesHeader.Reset();
                                        //SalesHeader.SetRange("NS_From Progress Billing No.", Rec."NS_Job No."); //PRJCTPR-367.PS.1.0 //Commemted
                                        SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_No.");//PRJCTPR-367.PS.1.0 Added
                                        SalesHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                        SalesHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No.");  // PRJCTPR-353.PS.1.0 24April2024
                                        if SalesHeader.FindFirst() then
                                            PAGE.RUNMODAL(PAGE::"Sales Invoice List", SalesHeader)
                                    end else begin
                                        SalesInvoiceHeader.RESET();
                                        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        // SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", Rec."NS_Sales Document No."); //PRJ-1131.NK.1.0//Commented by PS Under //PRJ-1648.PS.1.0 07OCT2022
                                        SalesInvoiceHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                        // SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_Job No."); //PRJCTPR-367.PS.1.0 //Commemted
                                        SalesInvoiceHeader.SetRange("NS_From Progress Billing No.", Rec."NS_No.");//PRJCTPR-367.PS.1.0 Added
                                        SalesInvoiceHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                        SalesHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No.");  // PRJCTPR-353.PS.1.0 24April2024
                                        if SalesInvoiceHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Invoices", SalesInvoiceHeader)
                                        else
                                            ERROR(Text017Lbl);
                                    end;

                                //PRJ-1648.PS.1.0 07OCT2022 - End

                                Rec."NS_Sales Document Type"::Credit: //PRJ-1131.NK.1.0

                                    if SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", Rec."NS_Sales Document No.") then //PRJ-1131.NK.1.0
                                        PAGE.RUNMODAL(PAGE::"Sales Credit Memo", SalesHeader)
                                    else begin
                                        SalesCrMemoHeader.RESET();
                                        SalesCrMemoHeader.SETCURRENTKEY("Pre-Assigned No.");
                                        SalesCrMemoHeader.SETRANGE("Pre-Assigned No.", Rec."NS_Sales Document No."); //PRJ-1131.NK.1.0
                                        if SalesCrMemoHeader.FINDFIRST() then
                                            PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader)
                                        else
                                            ERROR(Text018Lbl);
                                    end;
                            end;
                    end;
                }
                //PE-22.JS.1.0 09FEB2022 - Start
                action(NS_ViewRetRedSalesDocument)
                {
                    ApplicationArea = All;
                    Caption = 'View Sales Document-Ret.Red';

                    tooltip = 'View Pending Sales Document in case user create sales invoice and retention reduction from single progress billing';
                    Image = View;
                    Promoted = true;
                    Visible = NSRetRedPBDocument;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if rec."NS_R_Reduction & Invoicing" = true then
                            if Rec."NS_Sales Document No." > '' then
                                case Rec."NS_Sales Document Type" of
                                    Rec."NS_Sales Document Type"::Order:
                                        if rec."NS_R_Reduction & Invoicing" = true then begin
                                            SalesHeader.Reset();
                                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                                            SalesHeader.SetRange("NS_From Progress Billing No.", Rec."NS_No.");
                                            SalesHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No."); // PRJCTPR-353.PS.1.0 24April2024
                                            if SalesHeader.FindFirst() then
                                                PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader)
                                            else
                                                error(Text020Lbl);
                                        end;
                                    Rec."NS_Sales Document Type"::Invoice:
                                        if rec."NS_R_Reduction & Invoicing" = true then begin
                                            SalesHeader.Reset();
                                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                                            SalesHeader.SetRange("NS_From Progress Billing No.", Rec."NS_No.");
                                            SalesHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No."); // PRJCTPR-353.PS.1.0 24April2024
                                            if SalesHeader.FindFirst() then
                                                PAGE.RUNMODAL(PAGE::"Sales Invoice List", SalesHeader)
                                            else
                                                error(Text020Lbl);
                                        end;
                                    Rec."NS_Sales Document Type"::Credit:
                                        if rec."NS_R_Reduction & Invoicing" = true then begin
                                            SalesHeader.Reset();
                                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                                            SalesHeader.SetRange("NS_From Progress Billing No.", Rec."NS_No.");
                                            SalesHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingReq.No.", Rec."NS_Requisition No.");
                                            SalesHeader.SetRange("NS_From ProgressBillingVer.No.", Rec."NS_Version No."); // PRJCTPR-353.PS.1.0 24April2024
                                            if SalesHeader.FindFirst() then
                                                PAGE.RUNMODAL(PAGE::"Sales Credit Memo", SalesHeader)
                                            else
                                                error(Text020Lbl);
                                        end;
                                end;
                    end;
                }
                //PE-22.JS.1.0 09FEB2022 - end
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
            group("Prin&t")
            {
                Caption = 'Prin&t';
                action(NS_ProgressInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice';
                    // ToolTip = 'Progress Invoice'; //PE-215.HS.1.0 15Jan2024
                    ToolTip = 'This report can also be viewed on word layout using custom report layout option.';//PE-215.HS.1.0 15Jan2024
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End

                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin //PRJ-1131.NK.1.0
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(JobsSetup."NS_ProgressBillStandardInvoice", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PE-207.NC.1.0 06Nov2023 Start
                action(NS_ProgressInvoiceCO)
                {
                    ApplicationArea = All;
                    Caption = 'Combined CO Progress Invoice';
                    ToolTip = 'Combined CO Progress Invoice';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    trigger OnAction();
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End

                        if Rec."NS_No." > '' then
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No.");
                                REPORT.RUNMODAL(14021338, true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PE-207.NC.1.0 06Nov2023 End
                //PRJ-203:AS:21APRIL2020 - start
                action(NS_ProgressInvoicewithunit)
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice with Units';
                    // ToolTip = 'Progress Invoice with Units'; //PE-215.HS.1.0 15Jan2024 Commented
                    ToolTip = 'This report can also be viewed on word layout using custom report layout option.';//PE-215.HS.1.0 15Jan2024
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    begin

                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        //GLEI-11.MS.1.0001 Added new action 
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(Report::"NS_Progress Billing with Units", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-203:AS:21APRIL2020 - end

                //CTSI-85.AS.1.0 26JUN2020 - Start
                action("NS_Progress invoice - Revenue Wise")
                {
                    ApplicationArea = All;
                    Caption = 'Progress Invoice-Rev. Cat. Summ';
                    tooltip = 'This report is based on the use of Revenue Category Codes for summarization of billing lines.';   //PE-275.JS.1.0 19MAR2024
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin


                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin //PRJ-1131.NK.1.0
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No."); //PRJ-1131.NK.1.0
                                REPORT.RUNMODAL(REPORT::"NS_Progress Bill InvRevCatSumm", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE('This is a VOID requisition.');
                    end;
                }
                //CTSI-85.AS.1.0 26JUN2020 - End

                action(NS_AIAG702)
                {
                    ApplicationArea = All;
                    Caption = 'AIA G702';

                    ToolTip = 'AIA G702';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunPageOnRec = true;

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin //PRJ-1131.NK.1.0
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No."); //PRJ-1131.NK.1.0
                                REPORT.RUNMODAL(REPORT::"NS_AIA G702", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                action(NS_AIAG703)
                {
                    ApplicationArea = All;
                    Caption = 'AIA G703';

                    ToolTip = 'AIA G703';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No."); //PRJ-1131.NK.1.0
                                REPORT.RUNMODAL(REPORT::"NS_AIA G703", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //CTSI-41.AS.1.0 08MAY2020 - start
                action("NS_AIAG703 - Revenue Wise")
                {
                    ApplicationArea = All;
                    Caption = 'G703-Rev. Cat. Summ';//CTSI-41.AS.1.0 13May2020
                    tooltip = 'This report is based on the use of Revenue Category Codes for summarization of billing lines.'; //PE-275.JS.1.0 line added
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        if Rec."NS_No." > '' then //PRJ-1131.NK.1.0
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin //PRJ-1131.NK.1.0
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No."); //PRJ-1131.NK.1.0
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No."); //PRJ-1131.NK.1.0
                                REPORT.RUNMODAL(REPORT::"NS_AIA G703 - Revenue Wise", true, false, ProgressBillingHeader);
                            end else
                                MESSAGE('This is a VOID requisition.');
                    end;
                }
                //CTSI-41.AS.1.0 08MAY2020 - End
                //PRJ-858.GK.1.0 24Aug2021 start 
                action("NS_Combined AIA G702 and AIA G703")
                {
                    ApplicationArea = All;
                    Caption = 'Combined AIA G702 and AIA G703';
                    //ToolTip = 'Combined AIA G702 and AIA G703';  //PE-275.JS.1.0 line commented
                    ToolTip = 'This report does not support the use of the "Change Order" checkbox';  //PE-275.JS.1.0 line added
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                        Prams: Text;
                        MyReport: Report "NS_AIA G702";
                    begin

                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        //PRJ-1519.NK.1.0 22Jul2022 Start
                        Rec.CalcFields("NS_Lines Total Retention Amt");
                        if Rec."NS_Manual Retention Amount" <> 0 then
                            if rec."NS_Manual Retention Amount" <> Round((Rec."NS_Lines Total Retention Amt"), 0.01, '=') then
                                Error('Manual Retention Amount %1 not match with Line Total Retention Amount %2', rec."NS_Manual Retention Amount", Rec."NS_Lines Total Retention Amt");
                        //PRJ-1519.NK.1.0 22Jul2022 End
                        if "NS_No." > '' then
                            if NS_Status <> NS_Status::Void then begin
                                ProgressBillingHeader.RESET;
                                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", "NS_Version No.");
                                REPORT.RUNMODAL(REPORT::NS_Combined_AIAG702andAIAG703, true, false, ProgressBillingHeader);

                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-858.GK.1.0 24Aug2021 end

                //PRJ-1708.JS.1.0 13DEC2022 - Start
                action("NS_Combined CO AIAG702-N-AIAG703")
                {
                    ApplicationArea = All;
                    Caption = 'Combined CO AIA G702 and AIA G703';
                    // ToolTip = 'Combined Including Change Orders AIA G702 and AIA G703'; //PE-45.RM.1.0 14Feb2023 commented
                    ToolTip = 'This report works on based on the fields "Contract Forecast Date" and "Change Order" checkbox'; //PE-45.RM.1.0 14Feb2023
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction();
                    var
                        ProgressBillingHeader: Record "NS_Progress Billing Header";
                        Prams: Text;
                        MyReport: Report "NS_AIA G702";
                    begin
                        //PRJCTPR-366.PS.1.0 09May2024 Start
                        NS_ProgressBillingLine.Reset();
                        NS_ProgressBillingLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                        NS_ProgressBillingLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgressBillingLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                        if NS_ProgressBillingLine.FindSet() then begin
                            repeat
                                if Rec."NS_Period To" < NS_ProgressBillingLine."NS_Contract Forecast Date" then
                                    Error('The Report could not be generated because the "Period To Date" on the header is earlier than the "Contract Forecast Date" on line %1.', NS_ProgressBillingLine."NS_Line No.");
                            Until NS_ProgressBillingLine.Next = 0;
                        end;
                        //PRJCTPR-366.PS.1.0 09May2024 End
                        Rec.CalcFields("NS_Lines Total Retention Amt");
                        if Rec."NS_Manual Retention Amount" <> 0 then
                            if rec."NS_Manual Retention Amount" <> Round((Rec."NS_Lines Total Retention Amt"), 0.01, '=') then
                                Error('Manual Retention Amount %1 not match with Line Total Retention Amount %2', rec."NS_Manual Retention Amount", Rec."NS_Lines Total Retention Amt");

                        if Rec."NS_No." > '' then
                            if Rec.NS_Status <> Rec.NS_Status::Void then begin
                                NS_CheckPBLinesForContractForecastDate();    //PRJ-1708.JS.1.0 02DEC2022
                                ProgressBillingHeader.RESET();
                                ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No.");
                                ProgressBillingHeader.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
                                ProgressBillingHeader.SETRANGE("NS_Version No.", Rec."NS_Version No.");
                                REPORT.RUNMODAL(REPORT::NS_Comb_N2AIAG702andAIAG703, true, false, ProgressBillingHeader);
                            end else
                                MESSAGE(Text019Lbl);
                    end;
                }
                //PRJ-1708.JS.1.0 13DEC2022 - End
            }
        }
        area(reporting)
        {
        }
    }

    trigger OnAfterGetRecord();
    begin
        if "NS_Requisition No." = 1 then begin
            ProgressBillingHeader.RESET();
            ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
            if ProgressBillingHeader.COUNT <= 1 then
                "No.Editable" := true
            else
                "No.Editable" := false;
        end else
            "No.Editable" := false;

        if NS_Status > NS_Status::Open then begin
            "Job No.Editable" := false;
            "Owner Contact TypeEditable" := false;
            "Owner Contact CodeEditable" := false;
            "Arch Eng Contact TypeEditable" := false;
            "Arch Eng Contact CodeEditable" := false;
            "Requisition DateEditable" := false;
            "Period ToEditable" := false;
            StatusEditable := false;
            "Round AmountsEditable" := false;
            "Work Retention %Editable" := false;
            MaterialRetentionPercentEditab := false;
            ManualRetentionAmountEditable := false;
        end else begin
            "Job No.Editable" := true;
            "Owner Contact TypeEditable" := true;
            "Owner Contact CodeEditable" := true;
            "Arch Eng Contact TypeEditable" := true;
            "Arch Eng Contact CodeEditable" := true;
            "Requisition DateEditable" := true;
            "Period ToEditable" := true;
            StatusEditable := true;
            "Round AmountsEditable" := true;
            "Work Retention %Editable" := true;
            MaterialRetentionPercentEditab := true;
            ManualRetentionAmountEditable := true;
        end;

        if NS_Status <> NS_Status::Void then begin
            StatusEditable := true;
            FinalEditable := true;
        end;

        //PE-22.JS.1.0 09FEB2023-Start
        if Rec."NS_R_Reduction & Invoicing" = true then
            NSRetRedPBDocument := true
        else
            NSRetRedPBDocument := false;
        //PE-22.JS.1.0 09FEB2023-ends    
        //PRJ-1332.JS.1.0 03MAY2022 code commented-Start
        // //PRJ-1332.GK.1.0 25Apr2022 start
        // if Rec.NS_Status = Rec.NS_Status::"Invoice Posted" then begin
        //     StatusEditable := false;
        // end;
        // //PRJ-1332.GK.1.0 25Apr2022 end
        //PRJ-1332.JS.1.0 03MAY2022 code commented-end

        if NS_Final then
            FinalEditable := false
        else
            FinalEditable := true;

        if Job.GET("NS_Job No.") then begin
            JobName := Job.Description;
            Rec."NS_Invoiced Currency Code" := Job."Invoice Currency Code"; //PRJCTPR-364.PS.1.0 07May2024
            NS_GetCustomerName();
            CustomerNo := Job."Bill-to Customer No.";
            if Customer.GET(Job."Bill-to Customer No.") then
                CustomerName := Customer.Name
            else
                CustomerName := Text001Lbl;
        end else begin
            JobName := '';
            CustomerNo := '';
            CustomerName := '';
        end;
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if ResourceRec.Get(NS_Manager) then
            ManagerName := ResourceRec.Name
        else
            ManagerName := '';
        if ResourceRec.Get("NS_Person Responsible") then
            PersonResponsibleName := ResourceRec.Name
        else
            PersonResponsibleName := '';
        //CTSI-121.N.S.1.0 18Aug2020 End;
        //PRJ-1624.NK.1.0 22Sep2022 Start
        if Rec."NS_Multiple Retention on Lines" then
            RetEditable := false
        else
            RetEditable := true;
        //PRJ-1624.NK.1.0 22Sep2022 End
        //PE-118.NC.1.0 03Aug2023 Start
        if JobSetup.Get() then;
        if JobSetup."NS_Enable Get Job Planning Lin" then begin
            EnableGJPL := true;
            GateBilling := false;
        end else begin
            EnableGJPL := false;
            GateBilling := true;
        end;
        //PE-118.NC.1.0 03Aug2023 End
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        PBHeader: Record "NS_Progress Billing Header";
        OK: Boolean;
    begin
        PBHeader.RESET();
        PBHeader.SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
        PBHeader.SETRANGE("NS_No.", "NS_No.");
        PBHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." + 1);
        if PBHeader.FINDFIRST() then
            ERROR(Text002Lbl);
        //PRJCTPR-180.NC.1.0 18Sep2023 Start
        if Rec.NS_Status <> rec.NS_Status::Open then
            Error('The current status of the requisition %1 is %2. Hence, it cannot be deleted. To delete a requisition, the status must be Open.', Rec."NS_No." + '.' + Format(Rec."NS_Requisition No.") + '.' + Format(Rec."NS_Version No."), Rec.NS_Status);
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No.");
        ProgressBillingHeader.SetRange(NS_Status, Rec.NS_Status::Open);
        ProgressBillingHeader.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
        ProgressBillingHeader.SetFilter("NS_Version No.", '>%1', 0);
        if ProgressBillingHeader.FindFirst() then
            Error('The current status of the requisition %1 is %2. Hence, it cannot be deleted.', ProgressBillingHeader."NS_No." + '.' + Format(ProgressBillingHeader."NS_Requisition No.") + '.' + Format(ProgressBillingHeader."NS_Version No."), ProgressBillingHeader.NS_Status);
        //PRJCTPR-180.NC.1.0 18Sep2023 End

        OK := CONFIRM(Text003Lbl + FORMAT("NS_Requisition No.") + Text004Lbl + "NS_No." + Text005Lbl + FORMAT("NS_Requisition No.") + Text004Lbl + "NS_No." + Text006Lbl);

        if not OK then
            ERROR(Text007Lbl);
    end;

    trigger OnInit();
    begin
        FinalEditable := true;
        ManualRetentionAmountEditable := true;
        MaterialRetentionPercentEditab := true;
        "Work Retention %Editable" := true;
        "Round AmountsEditable" := true;
        StatusEditable := true;
        "Period ToEditable" := true;
        "Requisition DateEditable" := true;
        "Arch Eng Contact CodeEditable" := true;
        "Arch Eng Contact TypeEditable" := true;
        "Owner Contact CodeEditable" := true;
        "Owner Contact TypeEditable" := true;
        "Job No.Editable" := true;
        "No.Editable" := true;
        //PE-118.NC.1.0 03Aug2023 Start
        if JobSetup.Get() then;
        if JobSetup."NS_Enable Get Job Planning Lin" then begin
            EnableGJPL := true;
            GateBilling := false;
        end else begin
            EnableGJPL := false;
            GateBilling := true;
        end;
        //PE-118.NC.1.0 03Aug2023 End
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
    begin
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
        if ProgressBillingHeader.FINDFIRST() then
            ERROR(Text001Lbl)
        else begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
        end;
        //PE-118.NC.1.0 03Aug2023 Start
        if JobSetup.Get() then;
        if JobSetup."NS_Enable Get Job Planning Lin" then begin
            EnableGJPL := true;
            GateBilling := false;
        end else begin
            EnableGJPL := false;
            GateBilling := true;
        end;
        //PE-118.NC.1.0 03Aug2023 End
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        if "NS_Job No." <> xRec."NS_Job No." then begin
            ;
            //            with ProgressBillingHeader do begin
            ProgressBillingHeader.reset();
            SETRANGE("NS_No.", "NS_No.");
            if FINDSET() then
                repeat
                    "NS_Job No." := Rec."NS_Job No.";
                    MODIFY();
                until NEXT() = 0;
        end;

        NS_CalculateRequisition(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        JobName := '';
        CustomerNo := '';
        CustomerName := '';
        "NS_Round Amounts" := JobsSetup."NS_Progress Billing Rounding";
        "NS_Owner Contact Type" := "NS_Owner Contact Type"::Owner;
        "No.Editable" := true;
        if (GETFILTER("NS_Job No.") <> '') and JobsSetup."NS_ProgressBillingFirstNo. Def" then
            if ("NS_No." = '') and ("NS_Requisition No." = 0) then begin
                "NS_No." := GETFILTER("NS_Job No.");
                "NS_Requisition No." := 1;
            end;
        if GETFILTER("NS_Job No.") <> '' then
            "NS_Job No." := GETFILTER("NS_Job No.");
        //PRJ-999.JS.1.0  09Nov2021 Start    
        if Job.GET("NS_Job No.") then begin
            Rec."NS_Global Dimension 1 Code" := Job."Global Dimension 1 Code";
            Rec."NS_Global Dimension 2 Code" := Job."Global Dimension 2 Code";
            Rec."NS_Dimension Set ID" := GetDimensionNoFromJob("NS_Job No.");
        end;
        //PRJ-999.JS.1.0  09Nov2021 end               
    end;

    trigger OnOpenPage();
    begin
        //SETFILTER(NS_Status, '<> Void');//PRJ-764.RS.1.0 30June21 Commented
        JobsSetup.GET();
        //CTSI-121.N.S.1.0 18Aug2020 Start
        if ResourceRec.Get(NS_Manager) then
            ManagerName := ResourceRec.Name
        else
            ManagerName := '';
        if ResourceRec.Get("NS_Person Responsible") then
            PersonResponsibleName := ResourceRec.Name
        else
            PersonResponsibleName := '';
        //CTSI-121.N.S.1.0 18Aug2020 End;
        //PRJ-1624.NK.1.0 22Sep2022 Start
        if Rec."NS_Multiple Retention on Lines" then
            RetEditable := false
        else
            RetEditable := true;
        //PRJ-1624.NK.1.0 22Sep2022 End
    end;

    var
        NSWorkAmtLine: Decimal;//PRJCTPR-174.PS.1.0 10Aug2023
        NSRetPercentage: Decimal; //PRJCTPR-174.PS.1.0 10Aug2023
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";

        NS_ProgressBillingHeader: Record "NS_Progress Billing Header"; //PRJCTPR-366.PS.1.0 10May2024
        NS_ProgressBillingLine: Record "NS_Progress Billing Line";//PRJCTPR-366.PS.1.0 10May2024
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        Customer: Record Customer;
        GetBillingForecast: Report "NS_Get Billing Forecast";
        GetContractForProgressBill: Report "NS_Get Contact forProgressBill";

        GetBillingByTask: Report "NS_Suggest Billing Task Lines";//PRJ-820
        PBDocProcess: Codeunit "NS_Progress BillingMakeSaleDoc";
        PBNewDocument: Codeunit "NS_Progress BillingNewDocument";

        CustomerNo: Code[20];
        NSRetRedPBDocument: Boolean;   //PE-22.JS.2.0 09FEB2022
        LineRetention: Boolean;
        JobSetup: Record "Jobs Setup";  //PE-118.NC.1.0 03Aug2023
        EnableGJPL: Boolean; //PE-118.NC.1.0 03Aug2023
        GateBilling: Boolean; //PE-118.NC.1.0 03Aug2023
        RetEditable: Boolean; //PRJ-1624.NK.1.0 22Sep2022

        JobName: Text[100];//PRJ-301.AS.1.0 Increase length 50 to 100
        CustomerName: Text[100];//PRJ-301.AS.1.0 Increase length from 50 to 100 chars
        [InDataSet]


        "No.Editable": Boolean;
        [InDataSet]
        "Job No.Editable": Boolean;
        [InDataSet]
        "Owner Contact TypeEditable": Boolean;
        [InDataSet]
        "Owner Contact CodeEditable": Boolean;
        [InDataSet]
        "Arch Eng Contact TypeEditable": Boolean;
        [InDataSet]
        "Arch Eng Contact CodeEditable": Boolean;
        [InDataSet]
        "Requisition DateEditable": Boolean;
        [InDataSet]
        "Period ToEditable": Boolean;
        [InDataSet]
        StatusEditable: Boolean;
        [InDataSet]
        "Round AmountsEditable": Boolean;
        [InDataSet]
        "Work Retention %Editable": Boolean;
        [InDataSet]
        MaterialRetentionPercentEditab: Boolean;
        [InDataSet]
        ManualRetentionAmountEditable: Boolean;
        [InDataSet]
        FinalEditable: Boolean;
        Text001Lbl: Label 'UNKNOWN!!';
        Text002Lbl: Label 'This is not the last requisition in the series.\Only the last requisition in the series can be deleted.';
        Text003Lbl: Label '"WARNING!\\This function will DELETE all versions of requisition "';
        Text004Lbl: Label '" for Progress Billing No. "';
        Text005Lbl: Label '"\\Any sales documents, posted and unposted, will remain as they are.  However all the detail of how those documents were generated will be lost.\\If this is what is needed, click Yes.\If this is not desired, click No.\\Do you want to delete Requisition "';
        Text006Lbl: Label '?';
        Text007Lbl: Label 'Deletion has been halted.';
        Text008Lbl: Label 'A value cannot be entered here because there are retention values in the line items.';
        Text009Lbl: Label 'There are already requisitions for this job.\\Use the new menu to make a new requisition or version.';
        Text010Lbl: Label 'You cannot set the status to VOID. Create a new version or set the value of this version to zero.';
        Text011Lbl: Label 'This function can only be run on Open versions.';
        Text012Lbl: Label 'This requisition is VOID and cannot be invoiced.';
        Text013Lbl: Label 'The Period To date is not filled in.';
        Text014Lbl: Label 'Are you certain you want to make a Sales Receivables Document for this requisition?';
        Text015Lbl: Label 'A Sales Receivables Document has already been generated for this requisition.';
        Text016Lbl: Label 'There is no sales order for this requisition.';
        Text017Lbl: Label 'There is no sales invoice for this requisition.';
        Text018Lbl: Label 'There is no sales credit memo for this requisition.';
        Text019Lbl: Label 'This is a VOID requisition.';

        Text020Lbl: Label 'All document get posted for this requisition.';  //PE-22.JS.2.0 09FEB2022
        ManagerName: Text[100];//CTSI-121.N.S.1.0 18Aug2020
        PersonResponsibleName: Text[100];//CTSI-121.N.S.1.0 18Aug2020
        ResourceRec: Record Resource; //CTSI-121.N.S.1.0 18Aug2020

    procedure NS_GetCustomerName();
    begin
        CustomerNo := Job."Bill-to Customer No.";
        if Customer.GET(Job."Bill-to Customer No.") then
            CustomerName := Customer.Name
        else
            CustomerName := Text001Lbl;
    end;

    procedure NS_CheckLineWorkRetention();
    begin
        LineRetention := false;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if (ProgressBillingLine."NS_Work Retention Percent" <> 0) or
                   (ProgressBillingLine."NS_Work Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressBillingLine.NEXT() = 0;

        // if LineRetention then
        //     ERROR(Text008Lbl);//PPAL-106.AS.1.0 13AUG20 Code commented

        NS_UpdateLines();
    end;

    procedure NS_CheckLineMaterialRetention();
    begin
        LineRetention := false;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if (ProgressBillingLine."NS_Material Retention Percent" <> 0) or
                   (ProgressBillingLine."NS_Material Retention Amount" <> 0) then
                    LineRetention := true;
            until ProgressBillingLine.NEXT() = 0;

        // if LineRetention then
        //     ERROR(Text008Lbl);// Code Commented PRJ-338.AS.1.0 08Sept2020

        NS_UpdateLines();
    end;

    procedure NS_UpdateLines();
    begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                MODIFY;
            until ProgressBillingLine.NEXT() = 0;
    end;

    procedure NS_RoundingRecalculate();
    begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                ProgressBillingLine.MODIFY();
            until ProgressBillingLine.NEXT() = 0;
        CurrPage.UPDATE(false);
    end;

    procedure NS_CalcTotals();
    begin
        MODIFY();

        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingLine.VALIDATE(NS_Quantity);
                ProgressBillingLine.MODIFY();
            until ProgressBillingLine.NEXT() = 0;
        CurrPage.UPDATE(false);
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        if Job.GET("NS_Job No.") then begin
            JobName := Job.Description;
            NS_GetCustomerName();
            if "NS_Work Retention Percent" = 0 then
                "NS_Work Retention Percent" := Job."NS_Default Job Retention";
            if "NS_Material Retention Percent" = 0 then
                if JobsSetup."NS_Calc ReceivableRetBeforeTax" then
                    if (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                       (JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then
                        "NS_Material Retention Percent" := "NS_Work Retention Percent";
        end else begin
            JobName := '';
            CustomerNo := '';
            CustomerName := '';
        end;
    end;

    local procedure NS_RoundAmountsOnAfterValidate();
    begin
        MODIFY();
        NS_RoundingRecalculate();
    end;

    local procedure NS_OwnerContactTypeOnAfterValidat();
    begin
        if "NS_Owner Contact Type" <> xRec."NS_Owner Contact Type" then
            "NS_Owner Contact Code" := '';
    end;

    local procedure NS_WorkRetentionPercentOnAfterVal();
    begin
        NS_UpdateLines();
    end;

    local procedure NS_MaterialRetentionPercentOnAfte();
    begin
        NS_UpdateLines();
    end;

    //PRJ-1708.JS.1.0 02DEC2022 - Start
    /// <summary>
    /// NS_CheckPBLinesForContractForecastDate.
    /// </summary>
    procedure NS_CheckPBLinesForContractForecastDate();
    begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", Rec."NS_Version No.");
        ProgressBillingLine.Setfilter("NS_Contract Forecast Date", '%1', 0D);
        if ProgressBillingLine.FindFirst() then
            Error('Please mention contract forecast date on progress billing line no. %1', ProgressBillingLine."NS_Line No.");   //PRJCTPR-235.JS.1.0 23JAN2024
        //PRJ-1708.JS.1.0 02DEC2022 - end 
    end;

    /// <summary>
    /// NS_CheckPBLineWorkAmount.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    //PRJCTPR-174.PS.1.0 08Aug2023 Start 
    procedure NS_CheckPBLineWorkAmount(): Decimal;
    begin
        NSWorkAmtLine := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", Rec."NS_Version No.");
        if ProgressBillingLine.findset() then begin
            repeat
                NSWorkAmtLine += ProgressBillingLine."NS_Work Amount";
            until ProgressBillingLine.Next = 0;
        end;
        Exit(NSWorkAmtLine);
    End;

    //PRJCTPR-174.PS.1.0 08Aug2023 End 

    /// <summary>
    /// NS_GetPreviousRetetionkunit.
    /// </summary>
    /// <returns>Return value of type Decimal.</returns>
    /// PRJCTPR-174.PS.1.0 10aug2023 Start
    procedure NS_GetPreviousRetetionkunit(): Decimal;
    var

    begin

        NSRetPercentage := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", Rec."NS_Version No.");
        if ProgressBillingLine.findset() then begin
            repeat
                NSRetPercentage += ProgressBillingLine."NS_PreviousRetPer %" - ProgressBillingLine."NS_Work Retention Percent";

            until ProgressBillingLine.Next = 0;
        end;
        Exit(NSRetPercentage);
    End;



    /// PRJCTPR-174.PS.1.0 10aug2023 End 

}

