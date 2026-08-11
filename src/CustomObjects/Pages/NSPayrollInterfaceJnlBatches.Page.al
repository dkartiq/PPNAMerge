page 14021379 "NS_PayrollInterfaceJnlBatches"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = List;
    UsageCategory = Lists;//PRJ-542.AM.1.0
    Caption = 'Payroll Interface Jnl Batches';
    SourceTable = "NS_Payroll Interface Jnl Batch";
    ApplicationArea = all;   //PRJ-1442.JS.1.0 07JUN2022

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.NS_Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Name';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("No. Series"; Rec."NS_No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. Series';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1100773007; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1100773008; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Journal")
            {
                ApplicationArea = All;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction();
                begin
                    NS_TemplateSelectionFromBatch(Rec);
                end;
            }
            group("Exp&ort")
            {
                Caption = 'Exp&ort';
                Image = Post;
                action("Test Report")
                {
                    ApplicationArea = All;
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction();
                    begin
                        NS_PrintPayrollInterfaceJnlBatch(Rec);
                    end;
                }
            }
        }
    }

    trigger OnInit();
    begin
        SETRANGE("NS_Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_SetupNewBatch;
    end;

    trigger OnOpenPage();
    begin
        NS_OpenJnlBatch(Rec);
    end;

    local procedure NS_DataCaption(): Text[250];
    var
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
    begin
        if not CurrPage.LOOKUPMODE then
            if GETFILTER("NS_Journal Template Name") <> '' then
                if GETRANGEMIN("NS_Journal Template Name") = GETRANGEMAX("NS_Journal Template Name") then
                    if PayrollInterfaceJnlTemplate.GET(GETRANGEMIN("NS_Journal Template Name")) then
                        exit(PayrollInterfaceJnlTemplate.NS_Name + ' ' + PayrollInterfaceJnlTemplate.NS_Description);
    end;

    local procedure NS_PrintPayrollInterfaceJnlBatch(PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch");
    var
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
    begin
        PayrollInterfaceJnlBatch.SETRECFILTER;
        PayrollInterfaceJnlTemplate.GET(PayrollInterfaceJnlBatch."NS_Journal Template Name");
        PayrollInterfaceJnlTemplate.TESTFIELD("NS_Test Report ID");
        REPORT.RUN(PayrollInterfaceJnlTemplate."NS_Test Report ID", true, false, PayrollInterfaceJnlBatch);
    end;
}

