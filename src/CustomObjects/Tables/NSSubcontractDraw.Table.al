table 14021308 "NS_Subcontract Draw"
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
                    NoSeriesMgt.TestManual(JobsSetup."NS_Subcontract Draw Nos.");
                    "NS_No. Series" := '';
                end;
            end;
        }
        field(10; "NS_Subcontract No."; Code[20])
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
        field(50; "NS_Purchase Document Type"; Option)
        {
            Caption = 'Purchase Document Type';
            OptionCaption = ' ,Invoice,Credit Memo';
            OptionMembers = " ",Invoice,"Credit Memo";
            DataClassification = CustomerContent;
        }
        field(51; "NS_Purchase Document No."; Code[20])
        {
            Caption = 'Purchase Document No.';
            TableRelation = IF ("NS_Purchase Document Type" = CONST(Invoice)) "Purch. Inv. Header"."No."
            ELSE
            IF ("NS_Purchase Document Type" = CONST("Credit Memo")) "Purch. Cr. Memo Hdr."."No.";
            DataClassification = CustomerContent;
        }
        field(52; "NS_Purchase Document Date"; Date)
        {
            Caption = 'Purchase Document Date';
            DataClassification = CustomerContent;
        }
        field(60; "NS_Progress Payment No."; Code[20])
        {
            Caption = 'Progress Payment No.';
            TableRelation = "NS_Progress Billing Header"."NS_No.";
            DataClassification = CustomerContent;
        }
        field(61; "NS_Progress Payment Req. No."; Integer)
        {
            Caption = 'Progress Payment Req. No.';
            TableRelation = "NS_Progress Billing Header"."NS_Requisition No." WHERE("NS_No." = FIELD("NS_Progress Payment No."), "NS_Requisition No." = FIELD("NS_Progress Payment Req. No."));
            DataClassification = CustomerContent;
        }
        field(62; "NS_ProgressPaymentVersionNo."; Integer)
        {
            Caption = 'Progress Payment Version No.';
            TableRelation = "NS_Progress Billing Header"."NS_Version No." WHERE("NS_No." = FIELD("NS_Progress Payment No."),
                                                                           "NS_Requisition No." = FIELD("NS_Progress Payment Req. No."));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.", "NS_Subcontract No.")
        {
        }
        key(Key2; "NS_Progress Payment No.", "NS_Progress Payment Req. No.")
        {
        }
        key(Key3; "NS_Purchase Document Type", "NS_Purchase Document No.")
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
            JobsSetup.TESTFIELD("NS_Subcontract Draw Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."NS_Subcontract Draw Nos.", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;
    end;

    var
        JobsSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    procedure AssistEdit(OldDraw: Record "NS_Subcontract Draw"): Boolean;
    var
        DrawRec: Record "NS_Subcontract Draw";
    begin
        with DrawRec do begin
            DrawRec := Rec;
            JobsSetup.GET();
            JobsSetup.TESTFIELD("NS_Draw Nos.");
            if NoSeriesMgt.SelectSeries(JobsSetup."NS_Subcontract Draw Nos.", OldDraw."NS_No. Series", "NS_No. Series") then begin
                NoSeriesMgt.SetSeries("NS_No.");
                Rec := DrawRec;
                exit(true);
            end;
        end;
    end;
}

