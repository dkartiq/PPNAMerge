page 14021380 "NS_Payroll InterfaceJnlPAYCHEX"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-204.MS.1.0 Remove unwanted controls
    AutoSplitKey = true;
    Caption = 'Payroll Interface Jnl.Payroll';//PRJ-542.AM.1.0
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "NS_Payroll Interface Jnl Line";

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
                    PayrollInterfaceJnlBatch.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(false);
                end;

                trigger OnValidate();
                begin
                    PayrollInterfaceJnlBatch.CheckName(CurrentJnlBatchName, Rec);
                    CurrPage.SAVERECORD;
                    PayrollInterfaceJnlBatch.NS_SetName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            repeater(Group)
            {
                field("Export Status"; Rec."NS_Export Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Export Status';
                }
                field("FORMAT(""Export Status Date/Time"")"; FORMAT(Rec."NS_Export Status Date/Time"))
                {
                    ApplicationArea = All;
                    Caption = 'Export Date/Time';
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("Work Date"; Rec."NS_Work Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Date';
                }
                field("Employee No."; Rec."NS_Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee No.';
                }
                field("Employee Name"; Rec."NS_Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        PayrollInterfaceJnlBatch.GetJobDescription(Rec, JobDescription);
                    end;
                }
                field(Shift; Rec.NS_Shift)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shift';
                }
                field("D/E Type"; Rec."NS_D/E Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D/E Type';
                }
                field("D/E Code"; Rec."NS_D/E Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the D/E Code';
                }
                field(Rate; Rec.NS_Rate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate';
                }
                field(Hours; Rec.NS_Hours)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Hours';
                }
                field(Amount; Rec.NS_Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount';
                }
                field("Sequence No."; Rec."NS_Sequence No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sequence No.';
                }
                field("Override Dept."; Rec."NS_Override Dept.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Dept.';
                }
                field("Override Division"; Rec."NS_Override Division")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Division';
                }
                field("Override Branch"; Rec."NS_Override Branch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Branch';
                }
                field("Override State"; Rec."NS_Override State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override State';
                }
                field("Override Local"; Rec."NS_Override Local")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Override Local';
                }
                field("State/Local Misc. Field"; Rec."NS_State/Local Misc. Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the State/Local Misc. Field';
                }
                field("Rate No."; Rec."NS_Rate No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate No.';
                }
                field("Social Security No."; Rec."NS_Social Security No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Social Security No.';
                }
                field("Manual Check No."; Rec."NS_Manual Check No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Manual Check No.';
                }
                field("Job Ledger Entry No."; Rec."NS_Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Ledger Entry No.';
                }
            }
            //PRJ-204.MS.1.0 Start
            // group(Control1100773016)
            // {
            //     fixed(Control1100773004)
            //     {
            //         group("Job Description")
            //         {
            //             Caption = 'Job Description';
            //             field(JobDescription; JobDescription)
            //             {
            //                 ApplicationArea = All;
            //                 Editable = false;
            //                 ToolTip = 'Specifies the job description';
            //             }
            //         }
            //     }
            // }
            //PRJ-204.MS.1.0 End
        }
        area(factboxes)
        {
            systempart(Control1100773033; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1100773034; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                    RunPageLink = "No." = FIELD("NS_Job No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("NS_Job No.");
                    RunPageView = SORTING("Job No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("Journa&l")
            {
                Caption = 'Journa&l';
                action("Create Payroll Interf. Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Create Payroll Interface Entries';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create Payroll Interface Entries';

                    trigger OnAction();
                    var
                        PayrollInterfaceJnlLine2: Record "NS_Payroll Interface Jnl Line";
                    begin
                        PayrollInterfaceJnlLine2.RESET();
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
                        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
                        PayrollInterfaceJnlTemplate.TESTFIELD("NS_Create Entries Report ID");
                        REPORT.RUN(PayrollInterfaceJnlTemplate."NS_Create Entries Report ID", true, false, PayrollInterfaceJnlLine2);
                        CurrPage.UPDATE(true);
                    end;
                }
            }
            group("Exp&ort")
            {
                Caption = 'Exp&ort';
                Image = Post;
                action("ProofList Report")
                {
                    ApplicationArea = All;
                    Caption = 'ProofList Report';
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        PayrollInterfaceJnlLine2: Record "NS_Payroll Interface Jnl Line";
                    begin
                        PayrollInterfaceJnlLine2.RESET();
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
                        REPORT.RUN(14021383, true, false, PayrollInterfaceJnlLine2);
                        CurrPage.UPDATE(true);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = All;
                    Caption = 'Test Report';
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Test Report';

                    trigger OnAction();
                    begin
                        NS_PrintPayrollInterfaceJnlLine(Rec);
                    end;
                }
                action("Create Export file")
                {
                    ApplicationArea = All;
                    Caption = 'Create Export file';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create Export file';

                    trigger OnAction();
                    var
                        PayrollInterfaceJnlLine2: Record "NS_Payroll Interface Jnl Line";
                    begin
                        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
                        PayrollInterfaceJnlTemplate.TESTFIELD("NS_Export XMLport ID");
                        PayrollInterfaceJnlLine2.RESET();
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Export Status", PayrollInterfaceJnlLine2."NS_Export Status"::" ");
                        XMLPORT.RUN(PayrollInterfaceJnlTemplate."NS_Export XMLport ID", true, false, PayrollInterfaceJnlLine2);
                    end;
                }
                action("Clear Export Status")
                {
                    ApplicationArea = All;
                    Caption = 'Clear Export Status';
                    Image = CloseDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        PayrollInterfaceJnlLine2: Record "NS_Payroll Interface Jnl Line";
                    begin
                        PayrollInterfaceJnlLine2.RESET();
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
                        REPORT.RUN(14021378, true, false, PayrollInterfaceJnlLine2);
                        CurrPage.UPDATE(true);
                    end;
                }
                action("Archive Exported lines")
                {
                    ApplicationArea = All;
                    Caption = 'Archive Exported lines';
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        PayrollInterfaceJnlLine2: Record "NS_Payroll Interface Jnl Line";
                    begin
                        PayrollInterfaceJnlLine2.RESET();
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
                        PayrollInterfaceJnlLine2.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
                        REPORT.RUN(14021379, true, false, PayrollInterfaceJnlLine2);
                        CurrPage.UPDATE(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        PayrollInterfaceJnlBatch.GetJobDescription(Rec, JobDescription);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_SetUpNewLine(xRec);
    end;

    trigger OnOpenPage();
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := ("NS_Journal Batch Name" <> '') and ("NS_Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := "NS_Journal Batch Name";
            PayrollInterfaceJnlBatch.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        PayrollInterfaceJnlBatch.NS_TemplateSelection(PAGE::"NS_Payroll InterfaceJnlPAYCHEX", Rec, JnlSelected);
        if not JnlSelected then
            ERROR('');
        PayrollInterfaceJnlBatch.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        CurrentJnlBatchName: Code[10];
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
        JobDescription: Text[50];
        OpenedFromBatch: Boolean;
        Text000: Label 'PAYROLL';
        Text001: Label 'Payroll Interface Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        ReportPrint: Codeunit "Test Report-Print";

    local procedure NS_PrintPayrollInterfaceJnlLine(NewPayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line");
    var
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
    begin
        PayrollInterfaceJnlLine.COPY(NewPayrollInterfaceJnlLine);
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", PayrollInterfaceJnlLine."NS_Journal Template Name");
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", PayrollInterfaceJnlLine."NS_Journal Batch Name");
        PayrollInterfaceJnlTemplate.GET(PayrollInterfaceJnlLine."NS_Journal Template Name");
        PayrollInterfaceJnlTemplate.TESTFIELD("NS_Test Report ID");
        REPORT.RUN(PayrollInterfaceJnlTemplate."NS_Test Report ID", true, false, PayrollInterfaceJnlLine);
    end;
}

