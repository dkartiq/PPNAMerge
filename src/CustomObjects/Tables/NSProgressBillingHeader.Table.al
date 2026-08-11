table 14021325 "NS_Progress Billing Header"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //SMPL - Replaced DimensionManagement named reference to ID (symbols bug)
    //PRJ-243 VT1.0 07-05-20
    //CTSI-121.N.S.1.0 18Aug2020 Add field manager & person responsible
    //PRJ-913.JS.1.0�14Sep2021 |Add procedure to flow dimension set ID as per job task lines
    //PRJ-980.MS.1.0 21Oct2021 | increase decimal places from 2 to 8

    Caption = 'Progress Billing Header';
    DrillDownPageID = "NS_Progress Billing List";
    LookupPageID = "NS_Progress Billing List";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No." <> xRec."NS_No." then begin
                    JobsSetup.GET();
                    NoSeriesMgt.TestManual(JobsSetup."NS_Progress Billing Nos.");
                    "NS_No. Series" := '';
                end;
            end;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                q: Integer;
            begin
                q := q;
            end;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(10; "NS_Requisition Date"; Date)
        {
            Caption = 'Requisition Date';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Period To"; Date)
        {
            Caption = 'Period To';
            DataClassification = CustomerContent;
        }
        field(20; NS_Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Invoiced,Accepted,Paid,Void';
            OptionMembers = Open,Invoiced,Accepted,Paid,Void;
            DataClassification = CustomerContent;


            trigger OnValidate();
            var
                ProgressBillNewDoc: Codeunit "NS_Progress BillingNewDocument";
                VersionNo: Integer;
            begin
                if (Rec.NS_Status = Rec.NS_Status::Void) and (xRec.NS_Status <> Rec.NS_Status) then begin
                    VersionNo := ProgressBillNewDoc.NS_NewVersion(Rec);
                    if VersionNo > 0 then
                        MESSAGE('A new version (' + FORMAT(VersionNo) + ' for this requisition has been created')
                    else
                        MESSAGE('A new version for this requisition was not able to b created');
                end;
            end;
        }
        field(21; "NS_Work Retention Percent"; Decimal)
        {
            Caption = 'Work Retention Percent';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 8;     //PRJ-980.MS.1.0  21Oct2021

            trigger OnValidate();
            begin
                if "NS_Work Retention Percent" <> xRec."NS_Work Retention Percent" then
                    if "NS_Manual Retention Amount" <> 0 then
                        ERROR(Text12);
            end;
        }
        field(22; "NS_Material Retention Percent"; Decimal)
        {
            Caption = 'Material Retention Percent';
            DataClassification = CustomerContent;
        }
        field(30; NS_Comment; Boolean)
        {
            CalcFormula = Exist("NS_Progress BillingCommentLine" WHERE("NS_No." = FIELD("NS_No."),
                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "NS_Line Work Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Work Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No."),
                                                                           "NS_Job No." = FIELD("NS_Job No. Filter"),
                                                                           "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                           "NS_Activity Code" = FIELD("NS_Activity Code Filter"),
                                                                           "NS_Process Code" = FIELD("NS_Process Code Filter"),
                                                                           "NS_Operation Code" = FIELD("NS_Operation Code Filter")));
            Caption = 'Line Work Amount';
            FieldClass = FlowField;
        }
        field(32; "NS_Line Material Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Stored Materials Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Line Material Amount';
            FieldClass = FlowField;
        }
        field(37; "NS_Requisition Total"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Line Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Requisition Total';
            FieldClass = FlowField;
        }
        field(43; "NS_Effective Work Retention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Effective Work Retention" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                        "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                        "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Effective Work Retention';
            FieldClass = FlowField;
        }
        field(44; "NS_EffectiveMaterialRetention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_EffectiveMaterialRetention" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Effective Material Retention';
            FieldClass = FlowField;
        }
        field(45; "NS_Total Retention"; Decimal)
        {
            Caption = 'Total Retention';
            DataClassification = CustomerContent;
        }
        field(49; "NS_Current Payment Due"; Decimal)
        {
            Caption = 'Current Payment Due';
            DataClassification = CustomerContent;
        }
        field(50; "NS_Sales Document Type"; Option)
        {
            Caption = 'Sales Document Type';
            OptionCaption = 'Order,Invoice,Credit';
            OptionMembers = "Order",Invoice,Credit;
            DataClassification = CustomerContent;
        }
        field(51; "NS_Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
            DataClassification = CustomerContent;
        }
        field(52; NS_Final; Boolean)
        {
            Caption = 'Final';
            DataClassification = CustomerContent;
        }
        field(55; "NS_Owner Contact Type"; Option)
        {
            Caption = 'Owner Contact Type';
            OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
            OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
            DataClassification = CustomerContent;
        }
        field(56; "NS_Owner Contact Code"; Code[10])
        {
            Caption = 'Owner Contact Code';
            TableRelation = "NS_Job Contact".NS_Code WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                      NS_Type = FIELD("NS_Owner Contact Type"));
            DataClassification = CustomerContent;
        }
        field(57; "NS_Arch Eng Contact Type"; Option)
        {
            Caption = 'Arch Eng Contact Type';
            InitValue = "Architect/Engineer";
            OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
            OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
            DataClassification = CustomerContent;
        }
        field(58; "NS_Arch Eng Contact Code"; Code[10])
        {
            Caption = 'Arch Eng Contact Code';
            TableRelation = "NS_Job Contact".NS_Code WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                      NS_Type = FIELD("NS_Arch Eng Contact Type"));
            DataClassification = CustomerContent;
        }
        field(60; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            DataClassification = CustomerContent;
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
        }
        //CTSI-121.N.S.1.0 18Aug2020 Start
        field(61; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            FieldClass = FlowField;
            CalcFormula = lookup(Job.NS_Manager where("No." = field("NS_Job No.")));
            Editable = false;
        }
        field(62; "NS_Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Person Responsible" where("No." = field("NS_Job No.")));
            Editable = false;
        }
        //CTSI-121.N.S.1.0 18Aug2020 End
        field(500; "NS_Job No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
        }
        field(501; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';
            FieldClass = FlowFilter;
        }
        field(502; "NS_Activity Code Filter"; Code[10])
        {
            Caption = 'Activity Code Filter';
            FieldClass = FlowFilter;
        }
        field(503; "NS_Process Code Filter"; Code[10])
        {
            Caption = 'Process Code Filter';
            FieldClass = FlowFilter;
        }
        field(504; "NS_Operation Code Filter"; Code[10])
        {
            Caption = 'Operation Code Filter';
            FieldClass = FlowFilter;
        }
        //PRJ-688.AM.1.0
        field(505; "NS_Section Code Filter"; Code[10])
        {
            Caption = 'Section Code Filter';
            FieldClass = FlowFilter;
        }
        //PRJ-688.AM.1.0
        field(600; "NS_Round Amounts"; Boolean)
        {
            Caption = 'Round Amounts';
            DataClassification = CustomerContent;
        }
        field(601; "NS_Manual Retention Amount"; Decimal)
        {
            Caption = 'Manual Retention Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Manual Retention Amount" = 0 then
                    if xRec."NS_Manual Retention Amount" <> 0 then begin
                        "NS_Work Retention Percent" := 0;
                        "NS_Material Retention Percent" := 0;
                    end;

                if "NS_Manual Retention Amount" <> 0 then begin
                    CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount");
                    if "NS_Line Work Amount" + "NS_Line Material Amount" = 0 then
                        ERROR(Text11);
                    if CONFIRM(Text10) then begin
                        if "NS_Line Work Amount" <> 0 then
                            "NS_Work Retention Percent" := "NS_Manual Retention Amount" / "NS_Line Work Amount" * 100;
                        if "NS_Line Material Amount" <> 0 then
                            "NS_Material Retention Percent" := "NS_Manual Retention Amount" / "NS_Line Material Amount" * 100;
                    end else
                        "NS_Manual Retention Amount" := 0;
                end;
            end;
        }
        field(602; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_No.", "NS_Requisition No.", "NS_Version No.")
        {
        }
        key(Key2; "NS_No.", "NS_Period To", NS_Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
    begin
        ProgressBillingManagement.NS_ProgressBillDelete("NS_No.", "NS_Requisition No.", "NS_Version No.");
    end;

    trigger OnInsert();
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        Text001: Label 'There are already requisitions for this job.\\Use the new menu to make a new requisition or version.';
    begin
        if "NS_Job No." = '' then
            if GETFILTER("NS_Job No.") <> '' then
                // >> Upgrade
                // "NS_Job No." := GETFILTER("NS_Job No.");
                Validate("NS_Job No.", GETFILTER("NS_Job No."));
        // << Upgrade

        if "NS_No." = '' then begin
            JobsSetup.GET();
            JobsSetup.TESTFIELD("NS_Progress Billing Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."NS_Progress Billing Nos.", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;

        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
        if ProgressBillingHeader.FINDFIRST() then
            ERROR(Text001)
        else begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
            if "NS_Job No." > '' then
                if Job.GET("NS_Job No.") then begin
                    "NS_Work Retention Percent" := Job."NS_Default Job Retention";
                    "NS_Material Retention Percent" := Job."NS_Default Job Retention";
                end;
        end;
    end;

    trigger OnModify();
    begin
        if xRec.NS_Status > NS_Status then
            ERROR(Text01);
    end;

    var
        JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        Job: Record Job;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineRetention: Boolean;
        Text01: Label 'Status values cannot be set backwards.\\You must make a new version.';
        Text10: Label 'Have you completed the adjustments to the Progress Billing Lines?';
        Text11: Label 'The sum of the Work Amounts and Material Amounts on the lines cannot be 0.';
        Text12: Label 'You must set the Manual Retention Amount to 0 before changing the retention percent."';
        Customer: Record Customer;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        JobDimensionNo: Integer;
        PBDocProcess: Codeunit "NS_Progress BillingMakeSaleDoc";
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingManagement: Codeunit "NS_Progress Billing Management";

    procedure NS_CalculateRequisition(var ProgressBillingHeader: Record "NS_Progress Billing Header");
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PreviousWork: Decimal;
    begin
        with ProgressBillingHeader do begin

            //Calculate all related progress billing lines
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    ProgressBillingLine.NS_LineCalculations(ProgressBillingLine);
                    ProgressBillingLine.MODIFY();
                until ProgressBillingLine.NEXT() = 0;

            //Update header fields
            CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
            "NS_Total Retention" := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            MODIFY;
        end;
    end;

    procedure NS_ProgressBillBaseAmount(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        Job: Record Job;
        BaseAmount: Decimal;
    begin
        //Returns the "Base Amount" total on the progress bill passed in.
        BaseAmount := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_No.");
            SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
            SETRANGE("NS_Version No.", Rec."NS_Version No.");
            if FINDSET() then
                repeat
                    if "NS_Billing Method" > 0 then begin
                        Job.GET("NS_Job No.");
                        if not Job."NS_Progress Billing Sub-Level" then begin
                            if "NS_Billing Method" = "NS_Billing Method"::Unit then
                                BaseAmount := BaseAmount + ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                BaseAmount := BaseAmount + "NS_Base Amount";
                        end;
                    end;
                until NEXT() = 0;
        end;

        exit(BaseAmount);
    end;

    procedure NS_PreviousProgressBillRetention(Rec: Record "NS_Progress Billing Header"; JobNo: Code[20]; RevenueCategory: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]): Decimal;//PRJ-688.AM.1.0
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        PreviousRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the all previous progress bills.
        //This routine only looks at progress billing records, not sales records
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"

        PreviousRetention := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if JobNo > '' then
                SETFILTER("NS_Job No. Filter", JobNo);
            if RevenueCategory > '' then
                SETFILTER("NS_Revenue Category Filter", RevenueCategory);
            if ActivityCode > '' then
                SETFILTER("NS_Activity Code Filter", ActivityCode);
            if ProcessCode > '' then
                SETFILTER("NS_Process Code Filter", ProcessCode);
            if OperationCode > '' then
                SETFILTER("NS_Operation Code Filter", OperationCode);
            //PRJ-688.AM.1.0
            if SectionCode > '' then
                SetFilter("NS_Section Code Filter", SectionCode);
            //PRJ-688.AM.1.0
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
                PreviousRetention := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            end;
        end;

        exit(PreviousRetention);
    end;

    procedure NS_ProgressBillPreviousTotalEarn(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PrevEarning: Decimal;
    begin
        //Returns the "Total Earnings" on an entire progress billing sequence up to Rec's requisition
        //  This is done by adding the "Line Work Amount" of all the previous requisitions
        PrevEarning := 0;
        if Rec."NS_Requisition No." > 1 then
            with ProgressBillingHeader do begin
                RESET();
                SETRANGE("NS_No.", Rec."NS_No.");
                SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
                SETFILTER(NS_Status, '<>%1', NS_Status::Void);
                if FINDSET() then
                    repeat
                        CALCFIELDS("NS_Line Work Amount");
                        PrevEarning := PrevEarning + "NS_Line Work Amount";
                    until NEXT() = 0;
            end;

        exit(PrevEarning);
    end;

    procedure NS_LastProgressBillRetention(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the previous progress bill
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"
        LastRetention := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
                LastRetention := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            end;
        end;

        exit(LastRetention);
    end;

    procedure NS_LastProgressBillStoredMat(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Line Material Amount" on the previous progress bill
        LastStoredMaterial := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDLAST() then begin
                CALCFIELDS("NS_Line Material Amount");
                LastStoredMaterial := "NS_Line Material Amount";
            end;
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_LastProgressBillStoredMatLine(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Stored Material Amount" on the previous progress bill line
        LastStoredMaterial := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastStoredMaterial := "NS_Stored Materials Amount";
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_LastProgressBillTCS(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        LastLineTCS: Decimal;
    begin
        //Returns the "Total Completed and Stored" on the previous progress bill
        LastLineTCS := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastLineTCS := "NS_Work Amount" + "NS_Stored Materials Amount" + NS_LastTotal(ProgressBillingLine);
        end;

        exit(LastLineTCS);
    end;

    procedure NS_ProgressBillPreviousInvoice(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastInvoiceAmount: Decimal;
        LineMaterialAmount1: Decimal;
        LineMaterialAmount2: Decimal;
    begin
        //Returns the value of the previous progress bill (Current Payment Due)
        //   This is done by adding all previous "Requisition Total"s and subtracting out only the
        //     previous "Effective Work Retention" and "Effective Material Retention".
        LastInvoiceAmount := 0;
        LineMaterialAmount1 := 0;
        LineMaterialAmount2 := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDSET() then begin
                repeat
                    CALCFIELDS("NS_Requisition Total", "NS_Line Material Amount");
                    LastInvoiceAmount := LastInvoiceAmount + "NS_Requisition Total";
                    LineMaterialAmount1 := LineMaterialAmount1 + LineMaterialAmount2;
                    LineMaterialAmount2 := "NS_Line Material Amount";
                until NEXT() = 0;
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Material Amount");
                LastInvoiceAmount := LastInvoiceAmount -
                                     "NS_Effective Work Retention" -
                                     "NS_EffectiveMaterialRetention" -
                                     LineMaterialAmount1;
            end;
        end;

        exit(LastInvoiceAmount);
    end;

    procedure NS_GetChangeOrderValues(JobNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        Job: Record Job;
    begin
        //Returns values of the change orders in a Job
        //   This is done by catagorizing "Budget Price" into four category values that are passed back.
        //     Additions have a positive budget value, deductions have a negative budget value.
        //     All Jobs to be accumulated must have a status of 'Order' or higher.
        //     Price budgets must have a type of 'Contract'.
        //     Values are considered 'Current' if the Job's "Contract Date" is between PeriodFrom and PeriodTo.
        //     Values are considered 'Previous' if the Job's "Contract Date" is before PeriodFrom.
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        Job.RESET();
        Job.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
        Job.SETRANGE("NS_Sub-Level to Job No.", JobNo);
        Job.SetRange("NS_Progress Billing Sub-Level", true);//PRJ-243 VT1.0 07-05-20
        if Job.FINDSET() then
            repeat

                if (Job."NS_Contract Date" > 0D) and
                   (Job.Status.AsInteger() >= Job.Status::Open.AsInteger()) and
                   (Job."NS_Contract Date" <= PeriodTo) then begin
                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                    if Job."NS_Budgeted Price (LCY)" > 0 then
                        if (Job."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousAdditions := PreviousAdditions + Job."NS_Budgeted Price (LCY)"
                        else
                            CurrentAdditions := CurrentAdditions + Job."NS_Budgeted Price (LCY)"
                    else
                        if (Job."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousDeductions := PreviousDeductions - Job."NS_Budgeted Price (LCY)"
                        else
                            CurrentDeductions := CurrentDeductions - Job."NS_Budgeted Price (LCY)";
                end;


            until Job.NEXT() = 0;
    end;

    procedure NS_GetPeriodFromDate(ProgressBillingNo: Code[20]; PeriodTo: Date) PeriodFromDate: Date;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
    begin
        //Find the Period From date for a progress billing requisition.
        //   This is done by finding the "Period To" date on the previous requisition.
        PeriodFromDate := 0D;
        with ProgressBillingHeader do begin
            RESET();
            SETCURRENTKEY("NS_No.", "NS_Period To");
            SETRANGE("NS_No.", ProgressBillingNo);
            SETRANGE("NS_Period To", 0D, PeriodTo);
            SETFILTER(NS_Status, '<> Void');
            if FINDLAST() then
                if NEXT(-1) <> 0 then
                    PeriodFromDate := "NS_Period To";
        end;
    end;

    procedure NS_IsInvoiced(ProgBillHeader: Record "NS_Progress Billing Header"; ForwardBackward: Option Forward,Backward) ReturnCode: Integer;
    var
        PBHeader: Record "NS_Progress Billing Header";
    begin
        //Return Codes:
        //  0 : An unexpected error occured in processing
        //  1 : There is an invoiced requisition in the direction requested
        //  2 : There is no invoiced requisition in the direction requested
        //  3 : The starting Progress Billing requisition passed in does not exist
        ReturnCode := 0;
        if (ProgBillHeader."NS_No." = '') or (ProgBillHeader."NS_Requisition No." = 0) then
            ReturnCode := 3
        else
            with PBHeader do begin
                RESET();
                SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
                SETRANGE("NS_No.", ProgBillHeader."NS_No.");
                SETRANGE("NS_Requisition No.", ProgBillHeader."NS_Requisition No.");
                if FINDFIRST() then begin
                    case ForwardBackward of
                        ForwardBackward::Forward:
                            SETRANGE("NS_Requisition No.", "NS_Requisition No." + 1);
                        ForwardBackward::Backward:
                            SETRANGE("NS_Requisition No.", "NS_Requisition No." - 1);
                    end;
                    SETRANGE("NS_Version No.");
                    if "NS_Requisition No." = 0 then
                        ReturnCode := 1
                    else
                        if FINDLAST() then begin
                            if (NS_Status >= 1) and (NS_Status <> 4) then
                                ReturnCode := 1
                            else
                                ReturnCode := 2;
                        end else begin
                            if ForwardBackward = ForwardBackward::Forward then
                                ReturnCode := 2
                            else
                                ReturnCode := 1;
                        end;
                end else
                    ReturnCode := 3;
            end;
    end;

    procedure NS_CopyCommentLines(BillingHeader: Record "NS_Progress Billing Header");
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingCommentLine2: Record "NS_Progress BillingCommentLine";
        LastLine: Integer;
    begin
        with BillingHeader do begin
            if "NS_No." > '' then begin
                //Get Last Comment Line of Current Progress Billing Header
                ProgressBillingCommentLine.RESET();
                ProgressBillingCommentLine.SETRANGE("NS_No.", "NS_No.");
                ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressBillingCommentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressBillingCommentLine.FINDLAST() then
                    LastLine := ProgressBillingCommentLine."NS_Line No."
                else
                    LastLine := 0;

                ProgressBillingHeader.RESET();
                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                if "NS_Requisition No." > 0 then
                    ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." - 1)
                else
                    ProgressBillingHeader.SETRANGE("NS_Requisition No.", 0);
                if ProgressBillingHeader.FINDLAST() then begin
                    ProgressBillingCommentLine.RESET();
                    ProgressBillingCommentLine.SETRANGE("NS_No.", ProgressBillingHeader."NS_No.");
                    ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                    ProgressBillingCommentLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.");
                    if ProgressBillingCommentLine.FINDSET() then
                        repeat
                            ProgressBillingCommentLine2.INIT();
                            ProgressBillingCommentLine2.TRANSFERFIELDS(ProgressBillingCommentLine);
                            ProgressBillingCommentLine2."NS_Requisition No." := "NS_Requisition No.";
                            ProgressBillingCommentLine2."NS_Version No." := "NS_Version No.";
                            LastLine := LastLine + 10000;
                            ProgressBillingCommentLine2."NS_Line No." := LastLine;
                            ProgressBillingCommentLine2.INSERT();
                        until ProgressBillingCommentLine.NEXT() = 0;
                end;
            end;
        end;
    end;

    procedure NS_GetJobForecast(BillingHeader: Record "NS_Progress Billing Header");
    var
        GetJobForecasts: Report "NS_Get Job Forecast";
    begin
        GetJobForecasts.SetJobLedgEntry(BillingHeader."NS_No.", BillingHeader."NS_Requisition No.", BillingHeader."NS_Version No.", BillingHeader."NS_Job No.");
        GetJobForecasts.RUNMODAL();
    end;

    procedure NS_JobTaskNoSeparatorCount(JobTaskNo: Code[35]) SepCount: Integer;
    var
        JobsSetup_Loc: Record "Jobs Setup";
        i: Integer;
    begin
        SepCount := 0;

        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        if JobsSetup_Loc."NS_APO Separators" > '' then
            for i := 1 to STRLEN(JobTaskNo) do begin
                if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then
                    SepCount := SepCount + 1;
            end;
    end;

    procedure NS_JobTaskNoToAPO(JobTaskNo: Code[35]; var ActivityCode: Code[10]; var ProcessCode: Code[10]; var OperationCode: Code[10]; var SectionCode: Code[10]);//PRJ-688.AM.1.0
    var
        JobsSetup_Loc: Record "Jobs Setup";
        Segment1: Text[30];
        Segment2: Text[30];
        Segment3: Text[30];
        Segment4: Text[30];
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        //The double COPYSTRs in this routine are to ensure that the APO codes are only 10 characters long reguardless
        //    of how many characters between the separaters there may be.

        ActivityCode := '';
        ProcessCode := '';
        OperationCode := '';
        SectionCode := '';//PRJ-688.AM.1.0
        Segment1 := '';
        Segment2 := '';
        Segment3 := '';
        Segment4 := '';

        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        case NS_JobTaskNoSeparatorCount(JobTaskNo) of
            0:
                Segment1 := COPYSTR(JobTaskNo, 1, 10);
            1:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin
                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, STRLEN(JobTaskNo) - i), 1, 10);
                        i := STRLEN(JobTaskNo);
                    end;
            2:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin
                                //Now have both separators.  Break up the string.
                                Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, STRLEN(JobTaskNo) - j), 1, 10);
                                //end both loops
                                i := STRLEN(JobTaskNo);
                                j := STRLEN(JobTaskNo);
                            end;

                    end;
            3:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin

                                //Found the second separator.  Now look for the third starting from here.
                                for k := j + 1 to STRLEN(JobTaskNo) do
                                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, k, 1)) > 0 then begin
                                        //Now have all three separators.  Break up the string.
                                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                        Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, k - j - 1), 1, 10);
                                        Segment4 := COPYSTR(COPYSTR(JobTaskNo, k + 1, STRLEN(JobTaskNo) - k), 1, 10);
                                        //end both loops
                                        i := STRLEN(JobTaskNo);
                                        j := STRLEN(JobTaskNo);
                                        k := STRLEN(JobTaskNo);
                                    end;
                            end;
                    end;
        end;

        if JobsSetup."NS_Activity Code Position" = 1 then begin
            ActivityCode := Segment1;
            ProcessCode := Segment2;
            OperationCode := Segment3;
            SectionCode := Segment4;//PRJ-688.AM.1.0
        end else begin
            ActivityCode := Segment2;
            ProcessCode := Segment3;
            OperationCode := Segment4;
        end;
    end;

    procedure NS_APOToJobTaskNo(ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    var
        JobsSetup_Loc: Record "Jobs Setup";
    begin
        //This routine simply puts together the Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the second segment of the Job Task No. then you must use the JAPOtoJobTaskNo routine.

        JobTaskNo := '';
        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        if ActivityCode > '' then begin
            JobTaskNo := ActivityCode;
            if ProcessCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + ProcessCode;
                if OperationCode > '' then begin
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + OperationCode;
                    if SectionCode > '' then //PRJ-688.AM.1.0
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + SectionCode;
                end;//PRJ-688.AM.1.0
            end;
        end;
    end;

    procedure NS_JAPOToJobTaskNo(TaskNo: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    begin
        //This routine simply puts together the Job Task No., Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the first segment of the Job Task No. then you must use the APOtoJobTaskNo routine.

        JobTaskNo := '';
        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();

        if TaskNo > '' then begin
            JobTaskNo := TaskNo;
            if ActivityCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ActivityCode;
                if ProcessCode > '' then begin
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ProcessCode;
                    if OperationCode > '' then Begin
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                        if SectionCode > '' then//PRJ-688.AM.1.0
                            JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + SectionCode;
                    end;//PRJ-688.AM.1.0
                end;
            end;
        end;
    end;

    procedure NS_GetDate(SalesHeader: Record "Sales Header"): Date;
    begin
        if SalesHeader."Posting Date" <> 0D then
            exit(SalesHeader."Posting Date");
        exit(WORKDATE);
    end;

    procedure NS_GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
    var
        DefaultDimension: Record "Default Dimension";
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        //Get the new type of Dimension No. for the values in the Default Dimension table for the Job
        //  Create a temporary DimensionSet table to send to DimMgt for it to return the number assiged to
        //  that set.

        DimensionNo := 0;
        with DefaultDimension do begin
            DefaultDimension.RESET();
            DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimension.SETRANGE("No.", JobNo);
            if DefaultDimension.FINDSET() then
                repeat
                    //Find a "Dimension Value" record based on the "Default Dimension" field values
                    //  If one is found, then a new temp table entry can be made
                    DimensionValue.RESET();
                    DimensionValue.SETRANGE("Dimension Code", "Dimension Code");
                    DimensionValue.SETRANGE(Code, "Dimension Value Code");
                    if DimensionValue.FINDFIRST() then begin
                        DimensionSetEntryTemp.INIT();
                        DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                        DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                        DimensionSetEntryTemp.INSERT();
                    end;
                until DefaultDimension.NEXT() = 0;
            //Now pass the temp table to DimMgt to get the proper Dimension No.
            DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
        end;
    end;

    //PRJ-913.JS.1.0�13Sep2021-Start
    procedure NS_GetDimensionNoFromJobTask(JobNo: Code[20]; JobTaskNo: Code[20]) DimensionNo: Integer;
    var
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        JobTaskDimension: Record "Job Task Dimension";
        DimMgt: Codeunit DimensionManagement;

    begin
        DimensionNo := 0;
        JobTaskDimension.Reset();
        JobTaskDimension.SetRange("Job No.", JobNo);
        JobTaskDimension.SetRange("Job Task No.", JobTaskNo);
        if JobTaskDimension.FindSet() then
            repeat
                DimensionValue.RESET();
                DimensionValue.SETRANGE("Dimension Code", JobTaskDimension."Dimension Code");
                DimensionValue.SETRANGE(Code, JobTaskDimension."Dimension Value Code");
                if DimensionValue.FINDFIRST() then begin
                    DimensionSetEntryTemp.INIT();
                    DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                    DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                    DimensionSetEntryTemp.INSERT();
                end;
            until JobTaskDimension.NEXT() = 0;
        DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
    end;
    //PRJ-913.JS.1.0�13Sep2021-end

}

