table 14021326 "NS_Progress Billing Line"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +  - CTSI-20.MS.1.0  Adding new "Revenue category" key 
    // +  - GLEI-11.MS.1.0001 added 4 new fields and added new function	
    //PRJ-203:AS:21APRIL2020 Duplicated GLEI-11 & CTSI-20
    //PRJ-301.AS.1.0 Incresed length from 50 to 100 chars
    //CTSI-41.AS.1.0 21MAY2020 Added Revenue Category Description Field.
    //PRJ-385.AM.1.0 1OCT2020 Resolved Issue Of Work Retention Amount Field Not Populating
    //TM-10.AM.1.0 | Added Field.
    //PRJ-471.MS.1.0 add new code for retention
    //PRJ-980.RM.1.0 22Oct2021 | Increase decimal places from 2 to 8
    // +------------------------------------------------------------

    Caption = 'Progress Billing Line';

    fields
    {
        field(1; "NS_Progress Billing No."; Code[20])
        {
            Caption = 'Progress Billing No.';
            NotBlank = true;
            TableRelation = "NS_Progress Billing Header"."NS_No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            NotBlank = true;
            TableRelation = "NS_Progress Billing Header"."NS_Requisition No." WHERE("NS_No." = FIELD("NS_Progress Billing No."));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = CustomerContent;
            TableRelation = "NS_Progress Billing Header"."NS_Version No." WHERE("NS_No." = FIELD("NS_Progress Billing No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."));
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Item No."; Code[5])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(12; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(13; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(16; NS_Description; Text[100])//PRJ-301.AS.1.0 Incresed length from 50 to 100 chars
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Billing Method"; Option)
        {
            Caption = 'Billing Method';
            InitValue = "%";
            OptionCaption = ' ,%,Unit,L/S';//PRJ-464.AM.1.0
            OptionMembers = " ","%",Unit,"L/S";//PRJ-464.AM.1.0
            DataClassification = CustomerContent;
        }
        field(21; "NS_Contract Quantity"; Decimal)
        {
            Caption = 'Contract Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Contract Quantity" <> 0 then
                    if "NS_Billing Method" <> "NS_Billing Method"::Unit then
                        ERROR(Text002);
            end;
        }
        field(22; "NS_Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(25; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(26; NS_Total; Decimal)
        {
            Caption = 'Total';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                case "NS_Billing Method" of
                    "NS_Billing Method"::"%":
                        NS_Quantity := (NS_Total / "NS_Base Amount") * 100;
                    "NS_Billing Method"::Unit:
                        NS_Quantity := NS_Total / "NS_Base Amount";
                    "NS_Billing Method"::"L/S":
                        NS_Quantity := NS_Total;
                end;

                NS_LineCalculations(Rec);
            end;
        }
        field(30; "NS_Work Amount"; Decimal)
        {
            Caption = 'Work Amount';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Work Retention Percent"; Decimal)
        {
            Caption = 'Work Retention Percent';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 8;     //PRJ-980.MS.1.0  21Oct2021

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(33; "NS_Work Retention Amount"; Decimal)
        {
            Caption = 'Work Retention Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(34; "NS_Effective Work Retention"; Decimal)
        {
            Caption = 'Effective Work Retention';
            DataClassification = CustomerContent;
        }
        field(35; "NS_Stored Materials Amount"; Decimal)
        {
            Caption = 'Stored Materials Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(36; "NS_Material Retention Percent"; Decimal)
        {
            Caption = 'Material Retention Percent';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(37; "NS_Material Retention Amount"; Decimal)
        {
            Caption = 'Material Retention Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(38; "NS_EffectiveMaterialRetention"; Decimal)
        {
            Caption = 'Effective Material Retention';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(41; "NS_Line Amount With Retention"; Decimal)
        {
            Caption = 'Line Amount With Retention';
            DataClassification = CustomerContent;
        }
        field(51; "NS_Billed Work Retention Amt"; Decimal)
        {
            Caption = 'Billed Work Retention Amt';
            DataClassification = CustomerContent;
        }
        field(52; "NS_Billed MaterialRetentionAmt"; Decimal)
        {
            Caption = 'Billed Material Retention Amt';
            DataClassification = CustomerContent;
        }
        field(107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(110; "NS_Section Code"; Code[10])
        {
            Caption = 'Section Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(200; "NS_Forecast Worksheet Count"; Integer)
        {
            Caption = 'Forecast Worksheet Count';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(201; "NS_Average Percent Complete"; Decimal)
        {
            Caption = 'Average Percent Complete';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(202; "NS_Forecasted Completed Cost"; Decimal)
        {
            Caption = 'Forecasted Completed Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(203; "NS_Job Ledger Entry TotalPrice"; Decimal)
        {
            Caption = 'Job Ledger Entry Total Price';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(204; "NS_Job Ledger Entry Total Cost"; Decimal)
        {
            Caption = 'Job Ledger Entry Total Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(205; "NS_Task Budget"; Decimal)
        {
            Caption = 'Task Budget';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(206; "NS_Utilized Cost"; Decimal)
        {
            Caption = 'Utilized Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(207; "NS_Finished Contract Price"; Decimal)
        {
            Caption = 'Finished Contract Price';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(220; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
        }
        //TM-32.AM.1.0
        field(221; "NS_Segment Name"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Takeoff Segments"."NS_Segment Name" WHERE("NS_Job No." = FIELD("NS_Job No."), "NS_Segment Code" = FIELD("NS_Segment Code")));
            Caption = 'Segment Name';
            Editable = false;
            FieldClass = FlowField;
        }
        //TM-32.AM.1.0
        field(208; "NS_Unit of Measure Code"; code[10])
        {
            caption = 'Unit of Measure Code';
            Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
            DataClassification = CustomerContent;
        }
        field(209; "NS_Planing Line No."; Integer)
        {
            Caption = 'Job Planning Line No.';
            Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
            DataClassification = CustomerContent;
        }
        field(211; "NS_Scheduled Values"; Decimal)
        {
            Caption = 'Scheduled Values';
            Editable = false;
            Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
            DataClassification = CustomerContent;
        }
        field(213; "NS_Current Work Unit"; Decimal)
        {
            Caption = 'Current Work Unit';
            Editable = false;
            Description = 'GLEI-11.MS.1.0001,//PRJ-203:AS:21APRIL2020';
            DataClassification = CustomerContent;
        }
        //CTSI-41.AS.1.0 21MAY2020 - START
        field(214; "NS_Revenue Cat Description"; Text[100])
        {
            Caption = 'Revenue Cat. Description';
            Description = 'Revenue Cat. Description';
            DataClassification = SystemMetadata;
        }
        //CTSI-41.AS.1.0 21MAY2020 - END
    }

    keys
    {
        key(Key1; "NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Line No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Billed Work Retention Amt", "NS_Billed MaterialRetentionAmt";
        }
        key(Key2; "NS_Progress Billing No.", "NS_Requisition No.", "NS_Line No.", "NS_Version No.", "NS_Item No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Billed Work Retention Amt", "NS_Billed MaterialRetentionAmt";
        }
        key(Key3; "NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Billed Work Retention Amt", "NS_Billed MaterialRetentionAmt";
        }
        key(Key4; "NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Item No.", "NS_Job No.", "NS_Revenue Category", "NS_Job Task No.")
        {
        }
        key(key5; "NS_Revenue Category")   //adding new key for billing inv report CTSI-20	  //PRJ-203:AS:21APRIL2020
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "NS_Progress Billing No." = '' then ERROR('Progress Billing No. cannot be blank'); //PP)1
        ProgressBillingHeader.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        if "NS_Item No." = '' then
            "NS_Billing Method" := "NS_Billing Method"::" ";
    end;

    trigger OnModify();
    begin
        ProgressBillingHeader.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressBillingHeader."NS_Sales Document No." > '' then
            ERROR(Text001);

        // Recalculate all latter requisitions with the new values
        with ProgressBillingLine do begin
            GLSetup.GET();
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '>%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressBillingHeader.NS_Status = ProgressBillingHeader.NS_Status::Open then begin
                        //"NS_Work Amount" := NS_Total - NS_LastTotal(ProgressBillingLine) + xRec.NS_Total - Rec.NS_Total;
                        Validate("NS_Work Amount", NS_Total - NS_LastTotal(ProgressBillingLine) + xRec.NS_Total - Rec.NS_Total);// #RG008
                        "NS_Work Retention Amount" := ROUND("NS_Work Amount" * ("NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
                        "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100),
                                                             GLSetup."Amount Rounding Precision");
                        MODIFY();
                    end
                until NEXT() = 0;
        end;
    end;

    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        GLSetup: Record "General Ledger Setup";
        Text001: Label 'This requisition has had a receivables document generated.\There can be no further changes to this version.\\Please make a new version if changes are needed.';
        Text002: Label 'Contract Quantity is only used when Billing Method is ''Unit''.\\It identified how many total units there are in the contract.';

    procedure NS_LineCalculations(var Rec: Record "NS_Progress Billing Line");
    begin
        GLSetup.GET();

        with Rec do begin
            ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");

            case "NS_Billing Method" of
                "NS_Billing Method"::"%":
                    NS_Total := (NS_Quantity / 100) * "NS_Base Amount";
                "NS_Billing Method"::Unit:
                    NS_Total := NS_Quantity * "NS_Base Amount";
                "NS_Billing Method"::"L/S":
                    NS_Total := NS_Quantity;
                else
                    NS_Total := 0;
            end;

            if ProgressBillingHeader."NS_Round Amounts" then
                NS_Total := ROUND(NS_Total, 1.0)
            else
                NS_Total := ROUND(NS_Total, GLSetup."Amount Rounding Precision");

            // "NS_Work Amount" := NS_Total - NS_LastTotal(Rec);
            Validate("NS_Work Amount", NS_Total - NS_LastTotal(Rec));// #RG008

            //Calculate the effective work retention
            //PRJ-385.AM.1.0 Orignal Code Commented start
            //if ProgressBillingHeader."NS_Work Retention Percent" > 0 then
            //    "NS_Effective Work Retention" := ROUND(NS_Total * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
            //                                         GLSetup."Amount Rounding Precision")
            // else begin
            //     if "Work Retention Percent" <> 0 then
            //         "Work Retention Amount" := ROUND(Total * ("Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
            //     "Effective Work Retention" := "Work Retention Amount";
            // end;
            //PRJ-385.AM.1.0 Orignal Code Commented end
            //PRJ-385.AM.1.0 start    
            if (ProgressBillingHeader."NS_Work Retention Percent" > 0) and ("NS_Work Retention Percent" <> 0) then begin //PRJ-471.MS.1.0
                "NS_Work Retention Amount" := ROUND(NS_Total * ("NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
                "NS_Effective Work Retention" := ROUND(NS_Total * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision");
            end else begin
                if "NS_Work Retention Percent" <> 0 then
                    "NS_Work Retention Amount" := ROUND(NS_Total * ("NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision")
                else
                    "NS_Work Retention Amount" := 0;  //PRJ-471.MS.1.0
                "NS_Effective Work Retention" := "NS_Work Retention Amount";

            end;
            //PRJ-385.AM.1.0 End

            //Calculate the effective material retention
            if (ProgressBillingHeader."NS_Material Retention Percent" > 0) and ("NS_Material Retention Percent" <> 0) then //PRJ-471.MS.1.0
                "NS_EffectiveMaterialRetention" := ROUND("NS_Stored Materials Amount" *
                                                        (ProgressBillingHeader."NS_Material Retention Percent" / 100),
                                                        GLSetup."Amount Rounding Precision")
            else begin
                if "NS_Material Retention Percent" <> 0 then
                    "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100),
                    GLSetup."Amount Rounding Precision")
                else
                    "NS_Material Retention Amount" := 0;//PRJ-471.MS.1.0
                "NS_EffectiveMaterialRetention" := "NS_Material Retention Amount";
            end;

            "NS_Billed Work Retention Amt" := NS_LastWorkEffectiveRetention(Rec) - "NS_Effective Work Retention";
            "NS_Billed MaterialRetentionAmt" := NS_LastMaterialEffectiveRetention(Rec) - "NS_EffectiveMaterialRetention";

            "NS_Line Amount" := "NS_Work Amount" + "NS_Stored Materials Amount";
            "NS_Line Amount With Retention" := "NS_Line Amount" - "NS_Effective Work Retention" - "NS_EffectiveMaterialRetention";
            MODIFY();
        end;
    end;

    procedure NS_LastBase(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        NS_LastBaseAmount: Decimal;
    begin
        //Returns the last "Base Amount" for a line on a job
        //  If this is the first requisition for the job then skip this routine

        if "NS_Requisition No." > 1 then begin
            NS_LastBaseAmount := 0;

            with ProgressBillingLine do begin
                RESET();
                SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
                SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
                SETRANGE("NS_Line No.", Rec."NS_Line No.");
                if FINDSET() then
                    repeat
                        ProgressBillingHeader_Loc.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                        if ProgressBillingHeader_Loc.NS_Status <> ProgressBillingHeader_Loc.NS_Status::Void then
                            if "NS_Billing Method" = "NS_Billing Method"::Unit then
                                NS_LastBaseAmount := ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                NS_LastBaseAmount := "NS_Base Amount";
                    until NEXT() = 0
                else begin
                    SETFILTER("NS_Requisition No.", '%1', Rec."NS_Requisition No.");
                    if FINDSET() then
                        repeat
                            if "NS_Billing Method" = "NS_Billing Method"::Unit then
                                NS_LastBaseAmount := ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                NS_LastBaseAmount := "NS_Base Amount";
                        until NEXT() = 0;
                end;
            end;
        end else
            if Rec."NS_Billing Method" = Rec."NS_Billing Method"::Unit then
                NS_LastBaseAmount := ROUND(Rec."NS_Base Amount" * Rec."NS_Contract Quantity", 0.01)
            else
                NS_LastBaseAmount := Rec."NS_Base Amount";

        exit(NS_LastBaseAmount);
    end;

    procedure NS_LastTotal(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        NS_LastTotalAmount: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastTotalAmount := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    if ProgressBillingHeader_Loc.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.") then
                        if ProgressBillingHeader_Loc.NS_Status <> ProgressBillingHeader_Loc.NS_Status::Void then
                            NS_LastTotalAmount := NS_Total;
                until NEXT() = 0;
        end;

        exit(NS_LastTotalAmount);
    end;

    procedure NS_LastWorkEffectiveRetention(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        NS_LastWorkEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastWorkEffectiveRetentionAmt := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                        NS_LastWorkEffectiveRetentionAmt := "NS_Effective Work Retention";
                until NEXT() = 0;
        end;

        exit(NS_LastWorkEffectiveRetentionAmt);
    end;

    procedure NS_LastMaterialEffectiveRetention(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        LastMatEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        LastMatEffectiveRetentionAmt := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                        LastMatEffectiveRetentionAmt := "NS_EffectiveMaterialRetention";
                until NEXT() = 0;
        end;

        exit(LastMatEffectiveRetentionAmt);
    end;

    procedure NS_LastProgressBillStoredMatLine(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingLine_Loc: Record "NS_Progress Billing Line";
        LastStoredMaterial: Decimal;
    begin
        //Returns the stored material amount on the previous progress bill
        LastStoredMaterial := 0;
        with ProgressBillingLine_Loc do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER("NS_Version No.", '<%1', Rec."NS_Version No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastStoredMaterial := "NS_Stored Materials Amount";
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_TotalWorkPreviousBilling(Reco: Record "NS_Progress Billing Header"): Decimal;
    var
        PrevBilling: Decimal;
    begin
        //Returns the Work Previous Billings for an entire job
        PrevBilling := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Reco."NS_No.");
            if Reco."NS_Requisition No." > 0 then
                SETFILTER("NS_Requisition No.", '<%1', Reco."NS_Requisition No.");
            if FINDSET() then
                repeat
                    ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                        PrevBilling := PrevBilling + "NS_Work Amount";
                until NEXT() = 0;
        end;

        exit(PrevBilling);
        //PRJ-203:AS:21APRIL2020 - start
    end;

    procedure NS_GetPreviousWorkunit(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        JobsSetup_Loc: Record "Jobs Setup";
        LastWorkUnit: Decimal;
    begin
        //GLEI-11.MS.1.0001 
        //Returns the last work unit for a line on a job
        LastWorkUnit := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    if ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.") then
                        if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                            LastWorkUnit := NS_Quantity;

                until NEXT() = 0;
        end;

        exit(LastWorkUnit);
        //PRJ-203:AS:21APRIL2020 - end
    end;
}

