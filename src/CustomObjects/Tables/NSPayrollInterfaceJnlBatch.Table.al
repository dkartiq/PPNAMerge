table 14021379 "NS_Payroll Interface Jnl Batch"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Payroll Interface Jnl Batch';
    DataCaptionFields = NS_Name, NS_Description;
    LookupPageID = NS_PayrollInterfaceJnlBatches;

    fields
    {
        field(1; "NS_Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = NS_PayrollInterfaceJnlTemplate.NS_Name;
            DataClassification = CustomerContent;
        }
        field(2; NS_Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Journal Template Name", NS_Name)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", NS_Name);
        PayrollInterfaceJnlLine.DELETEALL(true);
    end;

    trigger OnInsert();
    begin
        LOCKTABLE;
        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
    end;

    trigger OnRename();
    begin
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", xRec."NS_Journal Template Name");
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", xRec.NS_Name);
        while PayrollInterfaceJnlLine.FINDFIRST() do
            PayrollInterfaceJnlLine.RENAME("NS_Journal Template Name", NS_Name, PayrollInterfaceJnlLine."NS_Line No.");
    end;

    var
        PayrollInterfaceJnlTemplate: Record NS_PayrollInterfaceJnlTemplate;
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        LastPayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        OpenFromBatch: Boolean;
        Text000: Label 'PAYROLL';//PRJ-542.AM.1.0
        Text001: Label 'Payroll Interface Jnl PAYCHEX';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';

    procedure NS_SetupNewBatch();
    begin
        PayrollInterfaceJnlTemplate.GET("NS_Journal Template Name");
        "NS_No. Series" := PayrollInterfaceJnlTemplate."NS_No. Series";
    end;

    procedure NS_TemplateSelection(PageID: Integer; var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line"; var JnlSelected: Boolean);
    var
        PayrollInterfaceJnlTemplate_Loc: Record "NS_PayrollInterfaceJnlTemplate";
    begin
        JnlSelected := true;

        PayrollInterfaceJnlTemplate_Loc.RESET();
        PayrollInterfaceJnlTemplate_Loc.SETRANGE("NS_Page ID", PageID);

        case PayrollInterfaceJnlTemplate_Loc.COUNT of
            0:
                begin
                    PayrollInterfaceJnlTemplate_Loc.INIT();
                    PayrollInterfaceJnlTemplate_Loc.NS_Name := Text000;
                    PayrollInterfaceJnlTemplate_Loc.NS_Description := Text001;
                    PayrollInterfaceJnlTemplate_Loc.VALIDATE("NS_Page ID");
                    PayrollInterfaceJnlTemplate_Loc.INSERT();
                    COMMIT();
                end;
            1:
                PayrollInterfaceJnlTemplate_Loc.FINDFIRST();
            else
                JnlSelected := PAGE.RUNMODAL(0, PayrollInterfaceJnlTemplate_Loc) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            PayrollInterfaceJnlLine.FILTERGROUP := 2;
            PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", PayrollInterfaceJnlTemplate_Loc.NS_Name);
            PayrollInterfaceJnlLine.FILTERGROUP := 0;
            if OpenFromBatch then begin
                PayrollInterfaceJnlLine."NS_Journal Template Name" := '';
                PAGE.RUN(PayrollInterfaceJnlTemplate_Loc."NS_Page ID", PayrollInterfaceJnlLine);
            end;
        end;
    end;

    procedure NS_TemplateSelectionFromBatch(var PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch");
    var
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
    begin
        OpenFromBatch := true;
        PayrollInterfaceJnlTemplate.GET(PayrollInterfaceJnlBatch."NS_Journal Template Name");
        PayrollInterfaceJnlTemplate.TESTFIELD("NS_Page ID");
        PayrollInterfaceJnlBatch.TESTFIELD(NS_Name);

        PayrollInterfaceJnlLine.FILTERGROUP := 2;
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Template Name", PayrollInterfaceJnlTemplate.NS_Name);
        PayrollInterfaceJnlLine.FILTERGROUP := 0;

        PayrollInterfaceJnlLine."NS_Journal Template Name" := '';
        PayrollInterfaceJnlLine."NS_Journal Batch Name" := PayrollInterfaceJnlBatch.NS_Name;
        PAGE.RUN(PayrollInterfaceJnlTemplate."NS_Page ID", PayrollInterfaceJnlLine);
    end;

    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line");
    begin
        NS_CheckTemplateName(PayrollInterfaceJnlLine.GETRANGEMAX("NS_Journal Template Name"), CurrentJnlBatchName);
        PayrollInterfaceJnlLine.FILTERGROUP := 2;
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", CurrentJnlBatchName);
        PayrollInterfaceJnlLine.FILTERGROUP := 0;
    end;

    procedure NS_OpenJnlBatch(var PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch");
    var
        PayrollInterfaceJnlTemplate: Record "NS_PayrollInterfaceJnlTemplate";
        PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line";
        JnlSelected: Boolean;
    begin
        if PayrollInterfaceJnlBatch.GETFILTER("NS_Journal Template Name") <> '' then
            exit;
        PayrollInterfaceJnlBatch.FILTERGROUP(2);
        if PayrollInterfaceJnlBatch.GETFILTER("NS_Journal Template Name") <> '' then begin
            PayrollInterfaceJnlBatch.FILTERGROUP(0);
            exit;
        end;
        PayrollInterfaceJnlBatch.FILTERGROUP(0);

        if not PayrollInterfaceJnlBatch.FINDFIRST() then begin
            if not PayrollInterfaceJnlTemplate.FINDFIRST() then
                NS_TemplateSelection(0, PayrollInterfaceJnlLine, JnlSelected);
            if PayrollInterfaceJnlTemplate.FINDFIRST() then
                NS_CheckTemplateName(PayrollInterfaceJnlTemplate.NS_Name, PayrollInterfaceJnlBatch.NS_Name);
        end;
        PayrollInterfaceJnlBatch.FINDSET();
        JnlSelected := true;
        if PayrollInterfaceJnlBatch.GETFILTER("NS_Journal Template Name") <> '' then
            PayrollInterfaceJnlTemplate.SETRANGE(NS_Name, PayrollInterfaceJnlBatch.GETFILTER("NS_Journal Template Name"));
        case PayrollInterfaceJnlTemplate.COUNT of
            1:
                PayrollInterfaceJnlTemplate.FINDFIRST();
            else
                JnlSelected := PAGE.RUNMODAL(0, PayrollInterfaceJnlTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            ERROR('');

        PayrollInterfaceJnlBatch.FILTERGROUP(2);
        PayrollInterfaceJnlBatch.SETRANGE("NS_Journal Template Name", PayrollInterfaceJnlTemplate.NS_Name);
        PayrollInterfaceJnlBatch.FILTERGROUP(0);
    end;

    procedure NS_CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10]);
    var
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
    begin
        PayrollInterfaceJnlBatch.SETRANGE("NS_Journal Template Name", CurrentJnlTemplateName);
        if not PayrollInterfaceJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not PayrollInterfaceJnlBatch.FINDFIRST() then begin
                PayrollInterfaceJnlBatch.INIT();
                PayrollInterfaceJnlBatch."NS_Journal Template Name" := CurrentJnlTemplateName;
                PayrollInterfaceJnlBatch.NS_SetupNewBatch;
                PayrollInterfaceJnlBatch.NS_Name := Text004;
                PayrollInterfaceJnlBatch.NS_Description := Text005;
                PayrollInterfaceJnlBatch.INSERT(true);
                COMMIT;
            end;
            CurrentJnlBatchName := PayrollInterfaceJnlBatch.NS_Name;
        end;
    end;

    procedure CheckName(CurrentJnlBatchName: Code[10]; var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line");
    var
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
    begin
        PayrollInterfaceJnlBatch.GET(PayrollInterfaceJnlLine.GETRANGEMAX("NS_Journal Template Name"), CurrentJnlBatchName);
    end;

    procedure NS_SetName(CurrentJnlBatchName: Code[10]; var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line");
    begin
        PayrollInterfaceJnlLine.FILTERGROUP := 2;
        PayrollInterfaceJnlLine.SETRANGE("NS_Journal Batch Name", CurrentJnlBatchName);
        PayrollInterfaceJnlLine.FILTERGROUP := 0;
        if PayrollInterfaceJnlLine.FINDSET() then;
    end;

    procedure LookupName(var CurrentJnlBatchName: Code[10]; var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line"): Boolean;
    var
        PayrollInterfaceJnlBatch: Record "NS_Payroll Interface Jnl Batch";
    begin
        COMMIT();
        PayrollInterfaceJnlBatch."NS_Journal Template Name" := PayrollInterfaceJnlLine.GETRANGEMAX("NS_Journal Template Name");
        PayrollInterfaceJnlBatch.NS_Name := PayrollInterfaceJnlLine.GETRANGEMAX("NS_Journal Batch Name");
        PayrollInterfaceJnlBatch.FILTERGROUP(2);
        PayrollInterfaceJnlBatch.SETRANGE("NS_Journal Template Name", PayrollInterfaceJnlBatch."NS_Journal Template Name");
        PayrollInterfaceJnlBatch.FILTERGROUP(0);
        if PAGE.RUNMODAL(0, PayrollInterfaceJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := PayrollInterfaceJnlBatch.NS_Name;
            NS_SetName(CurrentJnlBatchName, PayrollInterfaceJnlLine);
        end;
    end;

    procedure GetJobDescription(var PayrollInterfaceJnlLine: Record "NS_Payroll Interface Jnl Line"; var JobDescription: Text[50]);
    var
        Job: Record Job;
    begin
        if (PayrollInterfaceJnlLine."NS_Job No." = '') or
           (PayrollInterfaceJnlLine."NS_Job No." <> LastPayrollInterfaceJnlLine."NS_Job No.")
        then begin
            JobDescription := '';
            if Job.GET(PayrollInterfaceJnlLine."NS_Job No.") then
                JobDescription := Job.Description;
        end;

        LastPayrollInterfaceJnlLine := PayrollInterfaceJnlLine;
    end;
}

