page 14021388 "NS_Job Journal Labor"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Job Journal';
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Job Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = All;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(VAR Text: Text): Boolean;
                begin
                    CurrPage.SAVERECORD;
                    JobJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(false);
                end;

                trigger OnValidate();
                begin
                    JobJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    NS_CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("PP Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Type';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Type';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Posting Date';

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document Date';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("PP External Relationship Type"; Rec."NS_External Relationship Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the External Relationship Type';
                }
                field("PP External Relationship No."; Rec."NS_External Relationship No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the External Relationship No.';
                }
                field("PP External Relationship Name"; Rec."NS_External Relationship Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the External Relationship Name';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the External Document No.';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                        CurrPage.UPDATE;
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate();
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                        CurrPage.UPDATE;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("PP Jobsite Work"; Rec."NS_Jobsite Work")
                {
                    ApplicationArea = All;
                    Caption = 'Jobsite Work';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("PP Payroll Work State"; Rec."NS_Payroll Work State")
                {
                    ApplicationArea = All;
                    Caption = 'Payroll Work State';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Planning Line No.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gen. Prod. Posting Group';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                field("PP Job Cost Category"; Rec."NS_Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Cost Category';
                }
                field("PP Job Revenue Category"; Rec."NS_Job Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Revenue Category';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Shortcut Dimension 1 code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Shortcut Dimension 2 code';
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(VAr Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(VAr Text: Text): Boolean;
                    begin
                        LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bin Code';
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("PP Skill Class"; '') //PE-68 Dk.1.0 10April2023
                {
                    ApplicationArea = All;
                    Caption = 'Skill Class';
                    Visible = false;//PE-68 Dk.1.0 10April2023
                                    /// Visible = PP_AdvancedJobLaborActive;//PE-68 Dk.1.0 10April2023
                    ToolTip = 'Skill Class';
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                //PE-68 Dk.1.0 10April2023 Start
                field("PP Skill Class New"; Rec."NS_Skill Class New")
                {
                    ApplicationArea = All;
                    Caption = 'Skill Class';
                    Visible = PP_AdvancedJobLaborActive;
                    ToolTip = 'Skill Class';

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                //PE-68 Dk.1.0 10April2023 End
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Code';
                    Visible = false;

                    trigger OnAssistEdit();
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date");
                        if ChangeExchangeRate.RUNMODAL = ACTION::OK then
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);

                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining Qty.';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost (LCY)';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost (LCY)';
                }
                field("PP Burden Amount"; Rec."NS_Burden Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden Amount';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("PP Burden Job Cost Category"; Rec."NS_Burden Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Burden Job Cost Category';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("PP Payroll Burden Amount"; Rec."NS_Payroll Burden Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payroll Burden Amount';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("PP Payroll Burden Job Cost Cat"; Rec."NS_Payroll Burden Job Cost Cat")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Payroll Burden Job Cost Category';
                    Visible = PP_AdvancedJobLaborActive;
                }
                field("PP Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("PP Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost (LCY)';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price';
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price (LCY)';
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount';
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount (LCY)';
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount Amount';
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount %';
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price (LCY)';
                    Visible = false;
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Applies-to Entry';
                    Visible = false;
                }
                field("Applies-from Entry"; Rec."Applies-from Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Applies-from Entry';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Country/Region Code';
                    Visible = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Transaction Type';
                    Visible = false;
                }
                field("PP Chargeable"; Rec.Chargeable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Chargeable';
                    Visible = false;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Transport Method';
                    Visible = false;
                }
                field("PP Job Posting Only"; Rec."Job Posting Only")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Posting Only';
                    Visible = false;
                }
                field("PP Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Country/Region Code';
                    Visible = false;
                }
                field("Time Sheet No."; Rec."Time Sheet No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Time Sheet No.';
                    Visible = false;
                }
                field("Time Sheet Line No."; Rec."Time Sheet Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Time Sheet Line No.';
                    Visible = false;
                }
                field("Time Sheet Date"; Rec."Time Sheet Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Time Sheet Date';
                    Visible = false;
                }
            }
            group(Control73)
            {
                fixed(Control1902114901)
                {
                    group("Job Description")
                    {
                        Caption = 'Job Description';
                        field(JobDescription; JobDescription)
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the job description.';
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            ApplicationArea = All;
                            Caption = 'Account Name';
                            Editable = false;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1100773016; "NS_Job Journal Labor FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
                Visible = PP_AdvancedJobLaborActive;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(ItemTrackingLines)
                {
                    ApplicationArea = All;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines(false);
                    end;
                }
            }
            group("&Job")
            {
                Caption = '&Job';
                Image = Job;
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("Job No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageView = SORTING("Job No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalcRemainingUsage)
                {
                    ApplicationArea = All;
                    Caption = 'Calc. Remaining Usage';
                    Ellipsis = true;
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        JobCalcRemainingUsage: Report "Job Calc. Remaining Usage";
                    begin
                        TESTFIELD("Journal Template Name");
                        TESTFIELD("Journal Batch Name");
                        CLEAR(JobCalcRemainingUsage);
                        JobCalcRemainingUsage.SetBatch("Journal Template Name", "Journal Batch Name");
                        JobCalcRemainingUsage.SetDocNo("Document No.");
                        JobCalcRemainingUsage.RUNMODAL;
                    end;
                }
                action(SuggestLinesFromTimeSheets)
                {
                    ApplicationArea = All;
                    Caption = 'Suggest Lines from Time Sheets';
                    Ellipsis = true;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        SuggestJobJnlLines: Report "Suggest Job Jnl. Lines";
                    begin
                        SuggestJobJnlLines.SetJobJnlLine(Rec);
                        SuggestJobJnlLines.RUNMODAL;
                    end;
                }
                action("NS Copy Line to Crew Members")
                {
                    ApplicationArea = All;
                    Caption = 'Copy Line to Crew Members';
                    Image = ICPartner;

                    trigger OnAction();
                    var
                        PP_CopyLineToCrewMembers: Report "NS_Copy Job Jnl lines for Crew";
                    begin
                        NS_CopyJobJnlLineToCrewMembers;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = All;
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction();
                    begin
                        JobJnlReconcile.SetJobJnlLine(Rec);
                        JobJnlReconcile.RUN;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = All;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction();
                    begin
                        ReportPrint.PrintJobJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    ApplicationArea = All;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post", Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(false);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = All;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction();
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        COMMIT;
        if not ReserveJobJnlLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveJobJnlLine.DeleteLine(Rec);
    end;

    trigger OnInit();
    begin
        PP_HumanResourcesSetup.GET();
        PP_AdvancedJobLaborActive := PP_HumanResourcesSetup."NS_Advanced Job Labor isActive";
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetUpNewLine(xRec);
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("Journal Batch Name" <> '') and ("Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := "Journal Batch Name";
            JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        JobJnlManagement.TemplateSelection(PAGE::"Job Journal", false, Rec, JnlSelected);
        if not JnlSelected then
            ERROR('');
        JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;
    // >> Upgrade


    var
        PP_HumanResourcesSetup: Record "Human Resources Setup";
        JobJnlReconcile: Page "Job Journal Reconcile";
        JobJnlManagement: Codeunit JobJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        JobDescription: Text[50];
        AccName: Text[50];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        PP_AdvancedJobLaborActive: Boolean;
        CurrentJnlBatchName: Code[10];


    local procedure NS_CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        JobJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(false);
    end;
}

