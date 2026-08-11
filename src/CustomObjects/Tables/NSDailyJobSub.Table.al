/// <summary>
/// Table NS_Daily JOb Log Sub. (ID 14021400).
/// </summary>
/// //PE-168.PS.1.0 18Sep2023 New table create
/// //PE-168.HS.1.0 17Nov2023 | Add Caption
table 14021479 "NS_Daily Job Log Sub."
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum NSDailyJobLogDoctype)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                NSDailyJobLog.Reset();
                NSDailyJobLog.SetRange("NS_No.", Rec."Documnet No.");
                if NSDailyJobLog.FindFirst() then
                    Rec."Entry Date" := NSDailyJobLog."NS_Log Date";
            end;
        }
        field(2; "Documnet No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Documnet Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Entry Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Sub Con. Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(8; Remark; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Actual Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Actual Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Risk/ Delay"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Risk,Delay;
            Caption = 'Risk/Delay'; //PE-168.HS.1.0 17Nov2023
        }
        field(12; "Accidents / Safety Issues"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Accidents,"Safety Issues";
        }
        field(13; "NS_Job Tasks"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Tasks';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Documnet Job No."), "Job Task Type" = filter(Posting));
        }
        field(14; "Task Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Remark 2"; Text[240])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Order Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Purchase Order,Subcontract Order';
            OptionMembers = " ","Order","Subcontract Order";
        }
        field(7; "PO/Sub Con. No."; Code[20])
        {
            DataClassification = CustomerContent;
            // Caption = 'PO/Subcon. No.'; //PE-168.DK.1.0 01NOV2023 //PE-168.HS.1.0 17Nov2023 Commented
            Caption = 'PO/Subcontractor No.'; //PE-168.HS.1.0 17Nov2023
            TableRelation = IF ("Order Type" = CONST(Order)) "Purchase Header"."No." where("Document Type" = filter(Order), "NS_Job No." = field("Documnet Job No."))
            ELSE
            IF ("Order Type" = CONST("Subcontract Order")) "NS_Subcontract"."NS_No." where("NS_Job No." = field("Documnet Job No."));
            trigger OnValidate()
            var
                PurchHead: Record "Purchase Header";
                NS_Subct: Record NS_Subcontract;
            begin
                if "Order Type" = "Order Type"::Order then begin
                    PurchHead.Reset();
                    PurchHead.SetRange("Document Type", PurchHead."Document Type"::Order);
                    PurchHead.SetRange("No.", "PO/Sub Con. No.");
                    if PurchHead.FindFirst() then begin
                        "Vendor No." := PurchHead."Buy-from Vendor No.";
                        "Vendor Name" := PurchHead."Buy-from Vendor Name";
                    end;
                end;
                if "Order Type" = "Order Type"::"Subcontract Order" then begin
                    NS_Subct.Reset();
                    NS_Subct.SetRange("NS_No.", "PO/Sub Con. No.");
                    if NS_Subct.FindFirst() then begin
                        NS_Subct.CalcFields("NS_Buy-from Name");
                        "Vendor No." := NS_Subct."NS_Buy-from Vendor No.";
                        "Vendor Name" := NS_Subct."NS_Buy-from Name";
                    end;
                end;
            end;
        }
        field(18; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(19; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }


        field(20; "Contacts No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Contact where(Type = filter(Person));
            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                if Contact.Get("Contacts No.") then
                    "Contacts Name" := Contact.Name
                else
                    "Contacts Name" := '';
                NS_VisitTime := Time;
            end;
        }
        field(21; "Contacts Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        //PE-168.DK.1.0 01NOV2023 Start
        field(22; NS_VisitTime; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Visit Time';
        }
        //PE-168.DK.1.0 01NOV2023 End
        //PE-253.PS.1.0 14Feb2024 Start
        field(23; NS_UM; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'UOM';
            TableRelation = "Unit of Measure".Code;//PE-253.PS.2..0 22Feb2024
        }
        field(24; NS_WorkUnitToday; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Unit Today';
        }
        field(25; NS_WorkUnitBudgeted; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Unit Budgeted';
        }
        field(26; NS_WorkUnitPrevious; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Units Previous';
        }
        field(27; NS_PostedJobJournal; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Posted Job Journals';
        }
        field(28; NS_CreatedJobJournal; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Job Journals';
        }

        //PE-253.PS.1.0 14Feb2024 End 
    }

    keys
    {
        key(Key1; "Document Type", "Documnet No.", "Documnet Job No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        NSDailyJobLog: Record "NS_Daily Job Log";

    trigger OnInsert()
    begin
        Rec."Actual Date" := WorkDate;
        Rec."Actual Time" := Time;
        NSDailyJobLog.Reset();
        NSDailyJobLog.SetRange("NS_No.", Rec."Documnet No.");
        if NSDailyJobLog.FindFirst() then
            Rec."Entry Date" := NSDailyJobLog."NS_Log Date";
    end;
    //PE-253.PS.1.0 16Feb2024 Start
    /// <summary>
    /// NS_CreateEntriesForJobJournals.
    /// </summary>
    /// <param name="NSDailyJobLog">Record "NS_Daily Job Log".</param>
    procedure NS_CreateEntriesForJobJournals(NSDailyJobLog: Record "NS_Daily Job Log")
    var
        NSJobjournals: Record "Job Journal Line";
        NSNoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        NSResource: Record Resource;
    begin
        //PE-253.PS.2.0 22Feb2024 Start
        Rec.Reset();
        Rec.SetRange("Documnet Job No.", NSDailyJobLog."NS_Job No.");
        Rec.SetRange("Documnet No.", NSDailyJobLog."NS_No.");
        Rec.SetRange(NS_PostedJobJournal, false);
        Rec.SetRange(NS_CreatedJobJournal, true);
        if Rec.findset then begin
            NS_ModifiesEntriesForJobJournals(NSDailyJobLog);
        end
        else begin
            //PE-253.PS.2.0 22Feb2024 End
            Rec.Reset();
            Rec.SetRange("Documnet Job No.", NSDailyJobLog."NS_Job No.");
            Rec.SetRange("Documnet No.", NSDailyJobLog."NS_No.");
            Rec.SetRange(NS_PostedJobJournal, false);
            if Rec.FindSet() then begin
                repeat
                    if Rec.NS_WorkUnitToday <> 0 then begin
                        NSJobjournals.SetRange("Journal Batch Name", 'DEFAULT');
                        NSJobjournals.SetRange("Journal Template Name", 'JOB');
                        if NSJobjournals.FindLast() then
                            LineNo := NSJobjournals."Line No.";
                        LineNo := LineNo + 10000;
                        NSJobjournals.Init();
                        NSJobjournals."Journal Template Name" := 'JOB';
                        NSJobjournals."Journal Batch Name" := 'DEFAULT';
                        NSJobjournals."Line No." := LineNo;
                        NSJobjournals."Job No." := NSDailyJobLog."NS_Job No.";
                        NSJobjournals."Job Task No." := rec."NS_Job Tasks";
                        NSResource.Reset();
                        NSResource.SetRange("NS_Production Work Units", true);
                        NSResource.SetRange(Blocked, false);
                        if NSResource.FindFirst() then begin
                            NSJobjournals.Type := NSJobjournals.Type::Resource;
                            NSJobjournals.Validate("No.", NSResource."No.");
                            NSJobjournals.Description := NSResource.Name;
                            NSJobjournals."Unit of Measure Code" := NSResource."Base Unit of Measure";
                        end else begin
                            Error('Production Resource does not exist. Please enable the Boolean "Production Work Units" on the resource card to post the Job Work Units.');
                        end;
                        NSJobjournals.Quantity := 1;
                        NSJobjournals."Unit Cost (LCY)" := 0;
                        NSJobjournals."Unit Price (LCY)" := 0;
                        NSJobjournals."Unit Cost" := 0;
                        NSJobjournals."Unit Price" := 0;
                        NSJobjournals."NS_Work Units" := Rec.NS_WorkUnitToday;
                        NSJobjournals."NS_Work Unit of Measure" := Rec.NS_UM;
                        NSJobjournals."Document No." := NSDailyJobLog."NS_No.";
                        NSJobjournals.Validate("Posting Date", NSDailyJobLog."NS_Log Date");  //PE-253.PS.2.0 22Feb2024
                        NSJobjournals.Insert();

                        Rec.NS_CreatedJobJournal := true;
                        Rec.Modify();
                    end;
                until Rec.Next = 0;
            end else
                Error('There are no lines available to submit.');
        end;


    end;
    //PE-253.PS.1.0 16Feb2024 End 

    //PE-253.PS.2.0 22Feb2024 Start 
    procedure NS_ModifiesEntriesForJobJournals(NSDailyJobLog: Record "NS_Daily Job Log")
    var
        NSJobjournals: Record "Job Journal Line";
        NSNoSeriesMgt: Codeunit NoSeriesManagement;
        LineNo: Integer;
        NSResource: Record Resource;
    begin
        Rec.Reset();
        // Rec.SetRange("NS_Job Tasks", NSDailyJobLog."NS_Job Tasks");
        Rec.SetRange("Documnet Job No.", NSDailyJobLog."NS_Job No.");
        Rec.SetRange("Documnet No.", NSDailyJobLog."NS_No.");
        Rec.SetRange(NS_PostedJobJournal, false);
        if Rec.FindSet() then begin
            repeat
                if Rec.NS_WorkUnitToday <> 0 then begin

                    NSJobjournals.Setrange("Journal Template Name", 'JOB');
                    NSJobjournals.Setrange("Journal Batch Name", 'DEFAULT');
                    NSJobjournals.Setrange("Job No.", NSDailyJobLog."NS_Job No.");
                    NSJobjournals.Setrange("Job Task No.", Rec."NS_Job Tasks");
                    if NSJobjournals.findset() then begin
                        NSResource.Reset();
                        NSResource.SetRange("NS_Production Work Units", true);
                        NSResource.SetRange(Blocked, false);
                        if NSResource.FindFirst() then begin
                            NSJobjournals.Type := NSJobjournals.Type::Resource;
                            NSJobjournals.Validate("No.", NSResource."No.");
                            NSJobjournals.Description := NSResource.Name;
                            NSJobjournals."Unit of Measure Code" := NSResource."Base Unit of Measure";
                        end else begin
                            Error('Production Resource does not exist. Please enable the Boolean "Production Work Units" on the resource card to post the Job Work Units.');
                        end;
                        NSJobjournals."Line No." := NSJobjournals."Line No.";
                        NSJobjournals.Quantity := 1;
                        NSJobjournals."Unit Cost (LCY)" := 0;
                        NSJobjournals."Unit Price (LCY)" := 0;
                        NSJobjournals."Unit Cost" := 0;
                        NSJobjournals."Unit Price" := 0;
                        NSJobjournals."NS_Work Units" := Rec.NS_WorkUnitToday;
                        NSJobjournals."NS_Work Unit of Measure" := Rec.NS_UM;
                        NSJobjournals."Document No." := NSDailyJobLog."NS_No.";
                        NSJobjournals.Validate("Posting Date", NSDailyJobLog."NS_Log Date");  //PE-253.PS.2.0 22Feb2024
                        NSJobjournals.Modify();
                    end else begin

                        Rec.Reset();
                        Rec.SetRange("Documnet Job No.", NSDailyJobLog."NS_Job No.");
                        Rec.SetRange("Documnet No.", NSDailyJobLog."NS_No.");
                        Rec.SetRange(NS_PostedJobJournal, false);
                        if Rec.FindSet() then begin
                            repeat
                                if Rec.NS_WorkUnitToday <> 0 then begin
                                    NSJobjournals.SetRange("Journal Batch Name", 'DEFAULT');
                                    NSJobjournals.SetRange("Journal Template Name", 'JOB');
                                    if NSJobjournals.FindLast() then
                                        LineNo := NSJobjournals."Line No.";
                                    LineNo := LineNo + 10000;
                                    NSJobjournals.Init();
                                    NSJobjournals."Journal Template Name" := 'JOB';
                                    NSJobjournals."Journal Batch Name" := 'DEFAULT';
                                    NSJobjournals."Line No." := LineNo;
                                    NSJobjournals."Job No." := NSDailyJobLog."NS_Job No.";
                                    NSJobjournals."Job Task No." := rec."NS_Job Tasks";
                                    NSResource.Reset();
                                    NSResource.SetRange("NS_Production Work Units", true);
                                    NSResource.SetRange(Blocked, false);
                                    if NSResource.FindFirst() then begin
                                        NSJobjournals.Type := NSJobjournals.Type::Resource;
                                        NSJobjournals.Validate("No.", NSResource."No.");
                                        NSJobjournals.Description := NSResource.Name;
                                        NSJobjournals."Unit of Measure Code" := NSResource."Base Unit of Measure";
                                    end else begin
                                        Error('Production Resource does not exist. Please enable the Boolean "Production Work Units" on the resource card to post the Job Work Units.');
                                    end;
                                    NSJobjournals.Quantity := 1;
                                    NSJobjournals."Unit Cost (LCY)" := 0;
                                    NSJobjournals."Unit Price (LCY)" := 0;
                                    NSJobjournals."Unit Cost" := 0;
                                    NSJobjournals."Unit Price" := 0;
                                    NSJobjournals."NS_Work Units" := Rec.NS_WorkUnitToday;
                                    NSJobjournals."NS_Work Unit of Measure" := Rec.NS_UM;
                                    NSJobjournals."Document No." := NSDailyJobLog."NS_No.";
                                    NSJobjournals.Validate("Posting Date", NSDailyJobLog."NS_Log Date");  //PE-253.PS.2.0 22Feb2024
                                    NSJobjournals.Insert();

                                    Rec.NS_CreatedJobJournal := true;
                                    Rec.Modify();
                                end;
                            until Rec.Next = 0;
                        end;

                    end;
                end;
            until Rec.Next = 0;
        end;


    end;

    //PE-253.PS.2.0 22Feb22024 End
}