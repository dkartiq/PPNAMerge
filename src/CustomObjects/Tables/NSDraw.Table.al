table 14021185 NS_Draw
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Draw';
    LookupPageID = "NS_Draw List";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No." <> xRec."NS_No." then begin
                    JobsSetup.GET();
                    NoSeriesMgt.TestManual(JobsSetup."NS_Draw Nos.");
                    "NS_No. Series" := '';
                end;
            end;
        }
        field(10; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(20; NS_Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = CustomerContent;
        }
        field(30; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50; "NS_Sales Document Type"; Option)
        {
            Caption = 'Sales Document Type';
            OptionCaption = ' ,Invoice,Credit Memo';
            OptionMembers = " ",Invoice,"Credit Memo";
            DataClassification = CustomerContent;
        }
        field(51; "NS_Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
            TableRelation = IF ("NS_Sales Document Type" = CONST(Invoice)) "Sales Invoice Header"."No."
            ELSE
            IF ("NS_Sales Document Type" = CONST("Credit Memo")) "Sales Cr.Memo Header"."No.";
            DataClassification = CustomerContent;
        }
        field(52; "NS_Sales Document Date"; Date)
        {
            Caption = 'Sales Document Date';
            DataClassification = CustomerContent;
        }
        field(60; "NS_Progress Bill No."; Code[20])
        {
            Caption = 'Progress Bill No.';
            TableRelation = "NS_Progress Billing Header"."NS_No.";
            DataClassification = CustomerContent;
        }
        field(61; "NS_ProgressBillRequisitionNo."; Integer)
        {
            Caption = 'Progress Bill Requisition No.';
            TableRelation = "NS_Progress Billing Header"."NS_Requisition No." WHERE("NS_No." = FIELD("NS_Progress Bill No."));
            DataClassification = CustomerContent;
        }
        field(62; "NS_ProgressBillVersionNo."; Integer)
        {
            Caption = 'Progress Bill Version No.';
            TableRelation = "NS_Progress Billing Header"."NS_Version No." WHERE("NS_No." = FIELD("NS_Progress Bill No."),
                                                                           "NS_Requisition No." = FIELD("NS_ProgressBillRequisitionNo."));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.", "NS_Job No.")
        {
        }
        key(Key2; "NS_Progress Bill No.", "NS_ProgressBillRequisitionNo.")
        {
        }
        key(Key3; "NS_Sales Document Type", "NS_Sales Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "NS_No." = '' then begin
            JobsSetup.GET();
            JobsSetup.TESTFIELD("NS_Draw Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."NS_Draw Nos.", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;
    end;

    var
        JobsSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure NS_AssistEdit(OldDraw: Record NS_Draw): Boolean;
    var
        DrawRec: Record NS_Draw;
    begin
        with DrawRec do begin
            DrawRec := Rec;
            JobsSetup.GET();
            JobsSetup.TESTFIELD("NS_Draw Nos.");
            if NoSeriesMgt.SelectSeries(JobsSetup."NS_Draw Nos.", OldDraw."NS_No. Series", "NS_No. Series") then begin
                NoSeriesMgt.SetSeries("NS_No.");
                Rec := DrawRec;
                exit(true);
            end;
        end;
    end;
}

