table 14021340 "NS_Progress Payment Header"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-499.MS.1.0 new changes for progress payment
    //PRJ-1194.NK.1.0 02Mar2022 | Create New Field.
    //PRJCTPR-279.HS.1.0 15Jan2024 | Added Code
    Caption = 'Progress Payment Header';
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
                    JobsSetup.GET;
                    NoSeriesMgt.TestManual(JobsSetup."NS_Subcontract Nos.");
                end;
            end;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subconract No.';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(6; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
        }
        field(8; "NS_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
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
        }
        field(21; "NS_Work Retention Percent"; Decimal)
        {
            Caption = 'Work Retention Percent';
            DataClassification = CustomerContent;
            MinValue = 0; //PRJ-1194.NK 
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
            CalcFormula = Exist("NS_Progress PaymentCommentLine" WHERE("NS_No." = FIELD("NS_No."),
                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "NS_Line Work Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_Work Amount" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No."),
                                                                           "NS_Subcontract No." = FIELD("NS_Subcontract No. Filter"),
                                                                           "NS_Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                           "NS_Activity Code" = FIELD("NS_Activity Code Filter"),
                                                                           "NS_Process Code" = FIELD("NS_Process Code Filter"),
                                                                           "NS_Operation Code" = FIELD("NS_Operation Code Filter")));
            Caption = 'Line Work Amount';
            FieldClass = FlowField;
        }
        field(32; "NS_Line Material Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_Stored Materials Amount" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
                                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Line Material Amount';
            FieldClass = FlowField;
        }
        field(37; "NS_Requisition Total"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_Line Amount" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Requisition Total';
            FieldClass = FlowField;
        }
        field(43; "NS_Effective Work Retention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_Effective Work Retention" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
                                                                                        "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                        "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Effective Work Retention';
            FieldClass = FlowField;
        }
        field(44; "NS_Effective MaterialRetention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_EffectiveMaterialRetention" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
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
            TableRelation = "NS_Job Contact".NS_Code WHERE("NS_Job No." = FIELD("NS_Job No."));
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
                                                      NS_Type = FIELD("NS_Owner Contact Type"));
            DataClassification = CustomerContent;
        }
        field(60; "NS_Subcontract Draw No."; Code[25])
        {
            Caption = 'Subcontract Draw No.';
            // TableRelation = "NS_Subcontract Draw"."NS_No." WHERE("NS_Subcontract No." = FIELD("NS_No."),
            //                                                 NS_Closed = CONST(false));//PE-183.AS.1.0 COMMENTED OLD TR
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                            NS_Closed = CONST(false));//PE-183.AS.1.0 Add corrected
            DataClassification = CustomerContent;
        }
        field(500; "NS_Subcontract No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
        }
        field(501; "NS_Cost Category Filter"; Code[10])
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
                if "NS_Manual Retention Amount" = 0 then begin//PE-183.AS.1.0 end   Putted old code inside begin..end
                    if xRec."NS_Manual Retention Amount" <> 0 then begin
                        "NS_Work Retention Percent" := 0;
                        "NS_Material Retention Percent" := 0;
                    end;
                    CalcFields(Rec.NS_RetentionBaseAmt);
                    Rec.NS_RetentionAmt := (Rec.NS_RetentionBaseAmt * Rec."NS_Work Retention Percent") / 100;//PE-183.AS.1.0 Added
                end;//PE-183.AS.1.0 end

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
                    Rec.NS_RetentionAmt := 0;//PE-183.AS.1.0
                end;
            end;
        }
        //PRJ-1194.NK.1.0 02Mar2022 Start
        field(602; "NS_Retention Reduction Invoice"; Boolean)
        {
            Caption = 'Retention Reduction Invoice';
            DataClassification = CustomerContent;
        }
        //PRJ-1194.NK.1.0 02Mar2022 End

        //PE-183.AS.1.0 START
        field(603; "NS_RetentionBaseAmt"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Payment Line"."NS_Work Amount" WHERE("NS_Progress Payment No." = FIELD("NS_No."),
                                                                                        "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                        "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Retention Base Amount';
            FieldClass = FlowField;
            Editable = false;
        }
        field(604; "NS_RetentionAmt"; Decimal)
        {
            Caption = 'Retention Amount';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
            end;
        }
        //PE-183.AS.1.0 END
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
        ProgressPaymentLine: Record "NS_Progress Payment Line";
    begin
        ProgressPaymentLine.RESET();
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
        ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentLine.DELETEALL();

        ProgressPaymentCommentLine.RESET();
        ProgressPaymentCommentLine.SETRANGE("NS_No.", "NS_No.");
        ProgressPaymentCommentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
        ProgressPaymentCommentLine.DELETEALL();

        DELETE();
    end;

    trigger OnInsert();
    var
        LastProgressPaymentHeader: Record "NS_Progress Payment Header";
    begin
        if "NS_Subcontract No." = '' then
            if GETFILTER("NS_Subcontract No.") <> '' then
                "NS_Subcontract No." := GETFILTER("NS_Subcontract No.");
        if "NS_Requisition No." = 0 then begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
        end;
    end;

    trigger OnModify();
    begin
        if xRec.NS_Status > NS_Status then
            ERROR(Text01);
    end;

    var
        JobsSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineRetention: Boolean;
        Text01: Label 'Status values cannot be set backwards.\\You must make a new version.';
        Text02: Label 'The lines on the Purchase document have Qty. to Receive and Qty. to Invoice  updated.';
        Text10: Label 'Have you completed the adjustments to the Progress Payment Lines?';
        Text11: Label 'The sum of the Work Amounts and Material Amounts on the lines cannot be 0.';
        Text12: Label 'You must set the Manual Retention Amount to 0 before changing the retention percent.';
        Text13: Label 'The draw number %1 has already been used for progress payment %2 - %3.  Do you want to override that with this payment?';
        Text14: Label 'There must be an existing requisition showing.';
        Text14021102: Label 'There must be a value for Quantity.';//PRJ-499.MS.1.0
        Text14021104: Label 'There has already been %1  received, and this is coming to %2.';//PRJ-499.MS.1.0
        Vendor: Record Vendor;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ProgressPaymentCommentLine: Record "NS_Progress PaymentCommentLine";

    procedure NS_CalculateRequisition(var ProgressPaymentHeader: Record "NS_Progress Payment Header");
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        PreviousWork: Decimal;
    begin
        with ProgressPaymentHeader do begin

            //Calculate all related progress Payment lines
            ProgressPaymentLine.RESET();
            ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", "NS_No.");
            ProgressPaymentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
            ProgressPaymentLine.SETRANGE("NS_Version No.", "NS_Version No.");
            if ProgressPaymentLine.FINDSET() then
                repeat
                    // >> Upgrade
                    //ProgressPaymentLine.NS_LineCalculations(ProgressPaymentLine);
                    ProgressPaymentLine.NS_LineCalculations(ProgressPaymentLine, true);
                    // << Upgrade
                    ProgressPaymentLine.MODIFY();
                until ProgressPaymentLine.NEXT() = 0;

            //Update header fields
            CALCFIELDS("NS_Effective Work Retention", "NS_Effective MaterialRetention");
            "NS_Total Retention" := "NS_Effective Work Retention" + "NS_Effective MaterialRetention";
            MODIFY();
        end;
    end;

    procedure NS_ProgressPayBaseAmount(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        Subcontract: Record NS_Subcontract;
        BaseAmount: Decimal;
    begin
        //Returns the "Base Amount" total on the progress payment passed in.
        BaseAmount := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_No.");
            SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
            SETRANGE("NS_Version No.", Rec."NS_Version No.");
            if FINDSET() then
                repeat
                    if "NS_Payment Method" > 0 then begin
                        Subcontract.GET("NS_Subcontract No.");
                        if not Subcontract."NS_Progress Payment Sub-Level" then begin
                            if "NS_Payment Method" = "NS_Payment Method"::Unit then
                                BaseAmount := BaseAmount + ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                BaseAmount := BaseAmount + "NS_Base Amount";
                        end;
                    end;
                until NEXT() = 0;
        end;

        exit(BaseAmount);
    end;

    procedure NS_PreviousProgressPayRetention(Rec: Record "NS_Progress Payment Header"; SubcontractNo: Code[20]; RevenueCategory: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]): Decimal;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        PreviousRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the all previous progress payments.
        //This routine only looks at progress Payment records, not Purchase records
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"

        PreviousRetention := 0;
        with ProgressPaymentHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if SubcontractNo > '' then
                SETFILTER("NS_Subcontract No. Filter", SubcontractNo);
            if RevenueCategory > '' then
                SETFILTER("NS_Cost Category Filter", RevenueCategory);
            if ActivityCode > '' then
                SETFILTER("NS_Activity Code Filter", ActivityCode);
            if ProcessCode > '' then
                SETFILTER("NS_Process Code Filter", ProcessCode);
            if OperationCode > '' then
                SETFILTER("NS_Operation Code Filter", OperationCode);
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_Effective MaterialRetention");
                PreviousRetention := "NS_Effective Work Retention" + "NS_Effective MaterialRetention";
            end;
        end;

        exit(PreviousRetention);
    end;

    procedure NS_ProgressPayPreviousTotalEarn(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        PrevEarning: Decimal;
    begin
        //Returns the "Total Earnings" on an entire progress Payment sequence up to Rec's requisition
        //  This is done by adding the "Line Work Amount" of all the previous requisitions
        PrevEarning := 0;
        if Rec."NS_Requisition No." > 1 then
            with ProgressPaymentHeader do begin
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

    procedure NS_LastProgressPayRetention(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        LastRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the previous progress payment
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"
        LastRetention := 0;
        with ProgressPaymentHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_Effective MaterialRetention");
                LastRetention := "NS_Effective Work Retention" + "NS_Effective MaterialRetention";
            end;
        end;

        exit(LastRetention);
    end;

    procedure NS_LastProgressPayStoredMat(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Line Material Amount" on the previous progress payment
        LastStoredMaterial := 0;
        with ProgressPaymentHeader do begin
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

    procedure NS_LastProgressPayStoredMatLine(Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Stored Material Amount" on the previous progress payment line
        LastStoredMaterial := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastStoredMaterial := "NS_Stored Materials Amount";
        end;

        exit(LastStoredMaterial);
    end;

    procedure LastProgressPayTCS(Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        LastLineTCS: Decimal;
    begin
        //Returns the "Total Completed and Stored" on the previous progress payment
        LastLineTCS := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastLineTCS := "NS_Work Amount" + "NS_Stored Materials Amount" + NS_LastTotal(ProgressPaymentLine);
        end;

        exit(LastLineTCS);
    end;

    procedure NS_ProgressPayPreviousInvoice(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        LastInvoiceAmount: Decimal;
        LineMaterialAmount1: Decimal;
        LineMaterialAmount2: Decimal;
    begin
        //Returns the value of the previous progress payment (Current Payment Due)
        //   This is done by adding all previous "Requisition Total"s and subtracting out only the
        //     previous "Effective Work Retention" and "Effective Material Retention".
        LastInvoiceAmount := 0;
        LineMaterialAmount1 := 0;
        LineMaterialAmount2 := 0;
        with ProgressPaymentHeader do begin
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
                CALCFIELDS("NS_Effective Work Retention", "NS_Effective MaterialRetention", "NS_Line Material Amount");
                LastInvoiceAmount := LastInvoiceAmount -
                                     "NS_Effective Work Retention" -
                                     "NS_Effective MaterialRetention" -
                                     LineMaterialAmount1;
            end;
        end;

        exit(LastInvoiceAmount);
    end;

    procedure NS_GetChangeOrderValues(SubcontractNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        Subcontract: Record NS_Subcontract;
    begin
        //Returns values of the change orders in a Subcontract
        //   This is done by catagorizing "Budget Price" into four category values that are passed back.
        //     Additions have a positive budget value, deductions have a negative budget value.
        //     All Subcontracts to be accumulated must have a status of 'Order' or higher.
        //     Price budgets must have a type of 'Contract'.
        //     Values are considered 'Current' if the Subcontract's "Contract Date" is between PeriodFrom and PeriodTo.
        //     Values are considered 'Previous' if the Subcontract's "Contract Date" is before PeriodFrom.
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        Subcontract.RESET();
        Subcontract.SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.", "NS_Contract Date");
        Subcontract.SETRANGE("NS_Sub-LeveltoSubcontractNo.", SubcontractNo);
        if Subcontract.FINDSET() then
            repeat
                if (Subcontract."NS_Contract Date" > 0D) and
                   (Subcontract.NS_Status >= Subcontract.NS_Status::Order) and
                   (Subcontract."NS_Contract Date" <= PeriodTo) then begin
                    Subcontract.CALCFIELDS("NS_Budgeted Cost (LCY)");
                    if Subcontract."NS_Budgeted Cost (LCY)" > 0 then
                        if (Subcontract."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousAdditions := PreviousAdditions + Subcontract."NS_Budgeted Cost (LCY)"
                        else
                            CurrentAdditions := CurrentAdditions + Subcontract."NS_Budgeted Cost (LCY)"
                    else
                        if (Subcontract."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousDeductions := PreviousDeductions - Subcontract."NS_Budgeted Cost (LCY)"
                        else
                            CurrentDeductions := CurrentDeductions - Subcontract."NS_Budgeted Cost (LCY)";
                end;
            until Subcontract.NEXT() = 0;
    end;

    procedure NS_GetPeriodFromDate(ProgressPaymentNo: Code[20]; PeriodTo: Date) PeriodFromDate: Date;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
    begin
        //Find the Period From date for a progress Payment requisition.
        //   This is done by finding the "Period To" date on the previous requisition.
        PeriodFromDate := 0D;
        with ProgressPaymentHeader do begin
            RESET();
            SETCURRENTKEY("NS_No.", "NS_Period To");
            SETRANGE("NS_No.", ProgressPaymentNo);
            SETRANGE("NS_Period To", 0D, PeriodTo);
            SETFILTER(NS_Status, '<> Void');
            if FINDLAST() then
                if NEXT(-1) <> 0 then
                    PeriodFromDate := "NS_Period To";
        end;
    end;

    procedure NS_IsInvoiced(ProgPaymentHeader: Record "NS_Progress Payment Header"; ForwardBackward: Option Forward,Backward) ReturnCode: Integer;
    var
        PPHeader: Record "NS_Progress Payment Header";
    begin
        //Return Codes:
        //  0 : An unexpected error occured in processing
        //  1 : There is an invoiced requisition in the direction requested
        //  2 : There is no invoiced requisition in the direction requested
        //  3 : The starting Progress Payment requisition passed in does not exist
        ReturnCode := 0;
        if (ProgPaymentHeader."NS_No." = '') or (ProgPaymentHeader."NS_Requisition No." = 0) then
            ReturnCode := 3
        else
            with PPHeader do begin
                RESET();
                SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
                SETRANGE("NS_No.", ProgPaymentHeader."NS_No.");
                SETRANGE("NS_Requisition No.", ProgPaymentHeader."NS_Requisition No.");
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

    procedure NewRequisition(var PaymentHeader: Record "NS_Progress Payment Header"): Integer;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        ProgressPaymentLine2: Record "NS_Progress Payment Line";
        ProgressPaymentCommentLine: Record "NS_Progress PaymentCommentLine";
        ProgressPaymentCommentLine2: Record "NS_Progress PaymentCommentLine";
        JobsSetup: Record "Jobs Setup";
        NewNumber: Integer;
        // >> Upgrade
        Subcontract: Record NS_Subcontract;
    // << Upgrade
    begin
        NewNumber := -1;
        with PaymentHeader do begin
            if "NS_No." > '' then begin
                JobsSetup.GET();
                ProgressPaymentHeader.RESET();
                ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
                if ProgressPaymentHeader.FINDLAST() then begin
                    INIT();
                    "NS_No." := ProgressPaymentHeader."NS_No.";
                    "NS_Requisition No." := ProgressPaymentHeader."NS_Requisition No." + 1;
                    "NS_Version No." := 0;
                    "NS_Subcontract No." := ProgressPaymentHeader."NS_Subcontract No.";
                    "NS_Job No." := ProgressPaymentHeader."NS_Job No.";
                    "NS_Purchase Order No." := ProgressPaymentHeader."NS_Purchase Order No.";
                    "NS_Owner Contact Type" := ProgressPaymentHeader."NS_Owner Contact Type";
                    "NS_Owner Contact Code" := ProgressPaymentHeader."NS_Owner Contact Code";
                    "NS_Requisition Date" := TODAY();
                    NS_Status := NS_Status::Open;
                    "NS_Work Retention Percent" := ProgressPaymentHeader."NS_Work Retention Percent";
                    "NS_Material Retention Percent" := ProgressPaymentHeader."NS_Material Retention Percent";
                    "NS_Round Amounts" := ProgressPaymentHeader."NS_Round Amounts";
                    NS_Final := false;
                    // >> Upgrade
                    OnBeforeInsertNewRequisition(PaymentHeader, Subcontract);
                    // << Upgrade
                    INSERT();

                    ProgressPaymentLine.RESET();
                    ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", ProgressPaymentHeader."NS_No.");
                    ProgressPaymentLine.SETRANGE("NS_Requisition No.", ProgressPaymentHeader."NS_Requisition No.");
                    ProgressPaymentLine.SETRANGE("NS_Version No.", ProgressPaymentHeader."NS_Version No.");
                    if ProgressPaymentLine.FINDSET() then
                        repeat
                            ProgressPaymentLine2.INIT();
                            ProgressPaymentLine2.TRANSFERFIELDS(ProgressPaymentLine);
                            ProgressPaymentLine2."NS_Requisition No." := PaymentHeader."NS_Requisition No.";
                            ProgressPaymentLine2."NS_Version No." := 0;
                            ProgressPaymentLine2.INSERT();
                            // >> Upgrade
                            OnBeforeInsertNewRequisition2(ProgressPaymentLine2, ProgressPaymentLine);
                            ProgressPaymentLine2.NS_LineCalculations(ProgressPaymentLine2, false); // #RG008
                            // << Upgrade
                            ProgressPaymentLine2.MODIFY();
                        until ProgressPaymentLine.NEXT() = 0;

                    CALCFIELDS("NS_Line Work Amount");
                    "NS_Current Payment Due" := "NS_Line Work Amount" - "NS_Total Retention";
                    MODIFY();

                    if JobsSetup."NS_Copy Requisition Comments" then begin
                        ProgressPaymentCommentLine.RESET();
                        ProgressPaymentCommentLine.SETRANGE("NS_No.", ProgressPaymentHeader."NS_No.");
                        ProgressPaymentCommentLine.SETRANGE("NS_Requisition No.", ProgressPaymentHeader."NS_Requisition No.");
                        ProgressPaymentCommentLine.SETRANGE("NS_Version No.", ProgressPaymentHeader."NS_Version No.");
                        if ProgressPaymentCommentLine.FINDSET() then
                            repeat
                                ProgressPaymentCommentLine2.INIT();
                                ProgressPaymentCommentLine2.TRANSFERFIELDS(ProgressPaymentCommentLine);
                                ProgressPaymentCommentLine2."NS_Requisition No." := PaymentHeader."NS_Requisition No.";
                                ProgressPaymentCommentLine2."NS_Version No." := 0;
                                ProgressPaymentCommentLine2.INSERT();
                            until ProgressPaymentCommentLine.NEXT() = 0;
                    end;

                    NewNumber := "NS_Requisition No.";
                end;
            end else
                MESSAGE(Text14);
        end;

        exit(NewNumber);
    end;

    procedure NewVersion(var PaymentHeader: Record "NS_Progress Payment Header"): Integer;
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentHeader2: Record "NS_Progress Payment Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        ProgressPaymentLine2: Record "NS_Progress Payment Line";
        ProgressPaymentCommentLine: Record "NS_Progress PaymentCommentLine";
        ProgressPaymentCommentLine2: Record "NS_Progress PaymentCommentLine";
        JobsSetup: Record "Jobs Setup";
        NewNumber: Integer;
        Text0001: Label 'The next requisition must not be invoiced before\making a new version for this requisition.';
        Text0002: Label 'There must be an existing requisition showing.';
        Text0003: Label 'The existing requisition must not be Paid.';
        Text0004: Label 'This requisition is final.';
        // >> Upgrade
        Subcontract: Record NS_Subcontract;
    // << Upgrade
    begin
        NewNumber := -1;

        if NS_IsInvoiced(PaymentHeader, 0) <> 2 then
            ERROR(Text0001);

        with PaymentHeader do begin
            if not NS_Final then
                if (NS_Status < NS_Status::Paid) or (NS_Status = NS_Status::Void) then
                    if "NS_No." > '' then begin
                        JobsSetup.GET();
                        NS_Status := NS_Status::Void;
                        MODIFY();
                        ProgressPaymentHeader.RESET();
                        ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
                        ProgressPaymentHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                        if ProgressPaymentHeader.FINDLAST() then begin
                            ProgressPaymentHeader2.INIT();
                            ProgressPaymentHeader2.TRANSFERFIELDS(ProgressPaymentHeader);
                            ProgressPaymentHeader2."NS_No." := ProgressPaymentHeader."NS_No.";
                            ProgressPaymentHeader2."NS_Requisition No." := ProgressPaymentHeader."NS_Requisition No.";
                            ProgressPaymentHeader2."NS_Version No." := ProgressPaymentHeader."NS_Version No." + 1;
                            ProgressPaymentHeader2.NS_Status := NS_Status::Open;
                            // >> Upgrade
                            OnNewVersion1(ProgressPaymentHeader, ProgressPaymentHeader2, Subcontract);
                            // << Upgrade
                            ProgressPaymentHeader2.INSERT();

                            ProgressPaymentLine.RESET();
                            ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", PaymentHeader."NS_No.");
                            ProgressPaymentLine.SETRANGE("NS_Requisition No.", PaymentHeader."NS_Requisition No.");
                            ProgressPaymentLine.SETRANGE("NS_Version No.", PaymentHeader."NS_Version No.");
                            if ProgressPaymentLine.FINDSET() then
                                repeat
                                    ProgressPaymentLine2.INIT();
                                    ProgressPaymentLine2.TRANSFERFIELDS(ProgressPaymentLine);
                                    ProgressPaymentLine2."NS_Version No." := ProgressPaymentHeader2."NS_Version No.";
                                    ProgressPaymentLine2.INSERT();
                                    // >> Upgrade
                                    //ProgressPaymentLine2.NS_LineCalculations(ProgressPaymentLine2);
                                    ProgressPaymentLine2.NS_LineCalculations(ProgressPaymentLine2, false); // #RG008
                                                                                                           // << Upgrade
                                until ProgressPaymentLine.NEXT() = 0;

                            CALCFIELDS("NS_Line Work Amount");
                            "NS_Current Payment Due" := "NS_Line Work Amount" - "NS_Total Retention";
                            MODIFY();

                            if JobsSetup."NS_Copy Version Comments From" <> JobsSetup."NS_Copy Version Comments From"::None then begin
                                ProgressPaymentCommentLine.RESET();
                                ProgressPaymentCommentLine.SETRANGE("NS_No.", ProgressPaymentHeader."NS_No.");
                                ProgressPaymentCommentLine.SETRANGE("NS_Requisition No.", ProgressPaymentHeader."NS_Requisition No.");
                                if JobsSetup."NS_Copy Version Comments From" = JobsSetup."NS_Copy Version Comments From"::"Previous Version" then
                                    ProgressPaymentCommentLine.SETRANGE("NS_Version No.", ProgressPaymentHeader."NS_Version No.")
                                else
                                    ProgressPaymentCommentLine.SETRANGE("NS_Version No.", 0);
                                if ProgressPaymentCommentLine.FINDSET() then
                                    repeat
                                        ProgressPaymentCommentLine2.INIT();
                                        ProgressPaymentCommentLine2.TRANSFERFIELDS(ProgressPaymentCommentLine);
                                        ProgressPaymentCommentLine2."NS_Version No." := ProgressPaymentHeader2."NS_Version No.";
                                        ProgressPaymentCommentLine2.INSERT();
                                    until ProgressPaymentCommentLine.NEXT() = 0;
                            end;

                            NewNumber := ProgressPaymentHeader2."NS_Version No.";
                        end;
                    end else
                        MESSAGE(Text0002)
                else
                    MESSAGE(Text0003)
            else
                MESSAGE(Text0004);
        end;

        exit(NewNumber);
    end;

    procedure CopyCommentLines(PaymentHeader: Record "NS_Progress Payment Header");
    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentCommentLine: Record "NS_Progress PaymentCommentLine";
        ProgressPaymentCommentLine2: Record "NS_Progress PaymentCommentLine";
        LastLine: Integer;
    begin
        with PaymentHeader do begin
            if "NS_No." > '' then begin
                //Get Last Comment Line of Current Progress Payment Header
                ProgressPaymentCommentLine.RESET();
                ProgressPaymentCommentLine.SETRANGE("NS_No.", "NS_No.");
                ProgressPaymentCommentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressPaymentCommentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressPaymentCommentLine.FINDLAST() then
                    LastLine := ProgressPaymentCommentLine."NS_Line No."
                else
                    LastLine := 0;

                ProgressPaymentHeader.RESET();
                ProgressPaymentHeader.SETRANGE("NS_No.", "NS_No.");
                if "NS_Requisition No." > 0 then
                    ProgressPaymentHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." - 1)
                else
                    ProgressPaymentHeader.SETRANGE("NS_Requisition No.", 0);
                if ProgressPaymentHeader.FINDLAST() then begin
                    ProgressPaymentCommentLine.RESET();
                    ProgressPaymentCommentLine.SETRANGE("NS_No.", ProgressPaymentHeader."NS_No.");
                    ProgressPaymentCommentLine.SETRANGE("NS_Requisition No.", ProgressPaymentHeader."NS_Requisition No.");
                    ProgressPaymentCommentLine.SETRANGE("NS_Version No.", ProgressPaymentHeader."NS_Version No.");
                    if ProgressPaymentCommentLine.FINDSET() then
                        repeat
                            ProgressPaymentCommentLine2.INIT();
                            ProgressPaymentCommentLine2.TRANSFERFIELDS(ProgressPaymentCommentLine);
                            ProgressPaymentCommentLine2."NS_Requisition No." := "NS_Requisition No.";
                            ProgressPaymentCommentLine2."NS_Version No." := "NS_Version No.";
                            LastLine := LastLine + 10000;
                            ProgressPaymentCommentLine2."NS_Line No." := LastLine;
                            ProgressPaymentCommentLine2.INSERT();
                        until ProgressPaymentCommentLine.NEXT() = 0;
                end;
            end;
        end;
    end;

    procedure GetJobForecast(PaymentHeader: Record "NS_Progress Payment Header");
    var
        GetJobForecasts: Report "NS_Get Job Forecast";
    begin
        GetJobForecasts.SetJobLedgEntry(PaymentHeader."NS_No.", PaymentHeader."NS_Requisition No.", PaymentHeader."NS_Version No.", PaymentHeader."NS_Job No.");
        GetJobForecasts.RUNMODAL();
    end;

    procedure UpdatePurchaseOrderLines(PaymentHeader: Record "NS_Progress Payment Header"; PurchaseHeader: Record "Purchase Header"; Subcontract: Record NS_Subcontract);
    var
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        PurchaseLine: Record "Purchase Line";
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobPostingGroup: Record "Job Posting Group";
        JobsSetup: Record "Jobs Setup";
        JobTask: Record "Job Task";
        GLSetup: Record "General Ledger Setup";
        CurrentPercent: Decimal;
        AdditionalPercent: Decimal;
        PreviousStoredMaterial: Decimal;
        StoredMaterialToPay: Decimal;
        LineNumber: Integer;
        ModCount: Integer;
        PurHdrRec: Record "Purchase Header"; //PE-183.AS.1.0
        // >> Upgrade
        TotalPOValue: Decimal;
        SubconPaymentValue: Decimal;
        ClaimPercent: Decimal;
        QtyToReceive: Decimal;
    // << Upgrade
    begin
        //Update the Payables Document Lines
        // >> Upgrade
        OnBeforeUpdatePurchaseOrderLines(PaymentHeader, PurchaseHeader);
        // << Upgrade
        with ProgressPaymentLine do begin
            JobsSetup.GET();
            GLSetup.GET();
            LineNumber := 0;
            ModCount := 0;
            RESET();
            SETRANGE("NS_Progress Payment No.", PaymentHeader."NS_No.");
            SETRANGE("NS_Requisition No.", PaymentHeader."NS_Requisition No.");
            SETRANGE("NS_Version No.", PaymentHeader."NS_Version No.");
            // >> Upgrade
            // >> 003
            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SetRange("Document No.", PaymentHeader."NS_Purchase Order No.");
            PurchaseLine.CalcSums("Line Amount");
            TotalPOValue := PurchaseLine."Line Amount";
            ProgressPaymentLine.CalcSums(NS_Total);
            SubconPaymentValue := ProgressPaymentLine.NS_Total;
            ClaimPercent := SubconPaymentValue / TotalPOValue;
            // << 003
            // << Upgrade
            if FINDSET() then
                repeat
                    //Look for line retention calculations
                    if ("NS_Work Retention Percent" <> 0) or
                       ("NS_Work Retention Amount" <> 0) or
                       ("NS_Material Retention Percent" <> 0) or
                       ("NS_Material Retention Amount" <> 0) then
                        LineRetention := true;

                    //Find amount of Stored Materials to Pay
                    PreviousStoredMaterial := NS_LastProgressPayStoredMatLine(ProgressPaymentLine);
                    if "NS_Stored Materials Amount" - PreviousStoredMaterial > 0 then
                        StoredMaterialToPay := "NS_Stored Materials Amount" - PreviousStoredMaterial
                    else
                        StoredMaterialToPay := 0;

                    //Calculate and modify the "Qty. to Receive" on the Purchase Line
                    //if PurchaseLine.GET(PurchaseLine."Document Type"::Order, "NS_Purchase Order No.", "NS_Line No.") then begin //PRJ-1106.GK.1.0 29Dec2021 |Comment
                    if PurchaseLine.GET(PurchaseLine."Document Type"::Order, "NS_Purchase Order No.", "NS_PO Line No.") then begin //PRJ-1106.GK.1.0 29Dec2021 |add new line
                                                                                                                                   //PurchaseLine."Qty. to Receive" := NS_Total - PurchaseLine."Quantity Received";//PRJ-499.MS.1.0 comment
                                                                                                                                   //PurchaseLine.VALIDATE(PurchaseLine."Qty. to Receive");PRJ-499.MS.1.0 comment
                                                                                                                                   //PRJ-499.MS.1.0 start
                                                                                                                                   // >> Upgrade
                                                                                                                                   //if (PurchaseLine."NS_Subcontract Payment Percent" = 0) and (PurchaseLine."Quantity Received" < PurchaseLine.Quantity) then
                                                                                                                                   // if PurchaseLine.Quantity <> 0 then
                                                                                                                                   //   PurchaseLine."NS_Subcontract Payment Percent" := PurchaseLine."Quantity Received" / PurchaseLine.Quantity * 100
                                                                                                                                   //else
                                                                                                                                   // ERROR(Text14021102);
                                                                                                                                   //PurchaseLine.validate("NS_Subcontract Payment Percent", NS_Quantity);
                                                                                                                                   //PurchaseLine."NS_Subcontract Payment Value" := PurchaseLine."Quantity (Base)" * (PurchaseLine."NS_Subcontract Payment Percent" / 100) * PurchaseLine."Direct Unit Cost";
                                                                                                                                   //PurchaseLine."Qty. to Receive" := (PurchaseLine."Quantity (Base)" * (PurchaseLine."NS_Subcontract Payment Percent" / 100)) - PurchaseLine."Quantity Received";
                                                                                                                                   //if PurchaseLine."Qty. to Receive" < 0 then
                                                                                                                                   //  ERROR(Text14021104, FORMAT(PurchaseLine."Quantity Received"), FORMAT(PurchaseLine."Quantity Received" + PurchaseLine."Qty. to Receive"));
                                                                                                                                   //PurchaseLine.VALIDATE("Amount Including VAT");
                                                                                                                                   //PurchaseLine.VALIDATE("Qty. to Receive");
                                                                                                                                   //This code added
                        if ProgressPaymentLine."NS_No." <> '' then begin
                            if PurchaseLine.Quantity <> 0 then
                                PurchaseLine."NS_Subcontract Payment Percent" := ProgressPaymentLine.NS_Quantity
                            else
                                PurchaseLine."NS_Subcontract Payment Percent" := 0;

                            PurchaseLine.Validate("NS_Subcontract Payment Value", ProgressPaymentLine.NS_Total);

                        end else begin
                            if PurchaseLine.Quantity <> 0 then
                                PurchaseLine."NS_Subcontract Payment Percent" := Round(ClaimPercent * 100, 0.0001, '=')
                            else
                                PurchaseLine."NS_Subcontract Payment Percent" := 0;

                            PurchaseLine.Validate("NS_Subcontract Payment Value", PurchaseLine."Line Amount" * ClaimPercent);

                        end;

                        QtyToReceive := Round((PurchaseLine."NS_Subcontract Payment Value" / PurchaseLine."Line Amount") * PurchaseLine.Quantity, 0.000001, '=') - PurchaseLine."Quantity Received";
                        if (PurchaseLine."Line Amount" <> 0) and (QtyToReceive > 0) then
                            PurchaseLine.Validate("Qty. to Receive", QtyToReceive)
                        else
                            PurchaseLine.Validate("Qty. to Receive", 0);

                        // << 003

                        // >> 006
                        OnBeforeUpdatePurchaseOrderLines2(PurchaseLine, ProgressPaymentLine);
                        //PurchaseLine."Progress Payment Retention Amt" := ProgressPaymentLine."NS_Work Retention Amount";
                        // << 006
                        // << Upgrade
                        //PRJ-499.MS.1.0 end
                        PurchaseLine.MODIFY();
                        ModCount := ModCount + 1;
                    end;
                until NEXT() = 0;

            //Update the Progress Payment Header Status
            PaymentHeader.NS_Status := PaymentHeader.NS_Status::Invoiced;
            PaymentHeader.MODIFY();

            //PE-183.AS.1.0 start
            // Commit();
            if PurHdrRec.get(PurHdrRec."Document Type"::Order, PaymentHeader."NS_Purchase Order No.") then begin
                PurHdrRec."NS_Retention Amount (LCY)" := PaymentHeader.NS_RetentionAmt;
                PurHdrRec."NS_Retention Percent" := PaymentHeader."NS_Work Retention Percent";
                PurHdrRec."NS_Draw No." := PaymentHeader."NS_Subcontract Draw No.";
                PurHdrRec.Modify();
            end;
            //PE-183.AS.1.0 end
            // >> Upgrade
            OnAfterUpdatePurchaseOrderLines(PurchaseHeader);
            //MESSAGE(Text02);
            // << Upgrade
        end;
    end;

    procedure NS_JobTaskNoSeparatorCount(JobTaskNo: Code[35]) SepCount: Integer;
    var
        JobsSetup: Record "Jobs Setup";
        i: Integer;
    begin
        SepCount := 0;

        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();

        if JobsSetup."NS_APO Separators" > '' then
            for i := 1 to STRLEN(JobTaskNo) do begin
                if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then
                    SepCount := SepCount + 1;
            end;
    end;

    procedure JobTaskNoToAPO(JobTaskNo: Code[35]; var ActivityCode: Code[10]; var ProcessCode: Code[10]; var OperationCode: Code[10]);
    var
        JobsSetup: Record "Jobs Setup";
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
        Segment1 := '';
        Segment2 := '';
        Segment3 := '';
        Segment4 := '';

        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();

        case NS_JobTaskNoSeparatorCount(JobTaskNo) of
            0:
                Segment1 := COPYSTR(JobTaskNo, 1, 10);
            1:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin
                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, STRLEN(JobTaskNo) - i), 1, 10);
                        i := STRLEN(JobTaskNo);
                    end;
            2:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin
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
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin

                                //Found the second separator.  Now look for the third starting from here.
                                for k := j + 1 to STRLEN(JobTaskNo) do
                                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, k, 1)) > 0 then begin
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
        end else begin
            ActivityCode := Segment2;
            ProcessCode := Segment3;
            OperationCode := Segment4;
        end;
    end;

    procedure APOToJobTaskNo(ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]) JobTaskNo: Text[35];
    var
        JobsSetup_Loc: Record "Jobs Setup";
    begin
        //This routine simply puts together the Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the second segment of the Job Task No. then you must use the JAPOtoJobTaskNo routine.

        JobTaskNo := '';
        JobsSetup_Loc.GET();
        if JobsSetup_Loc."NS_APO Separators" = '' then;


        if ActivityCode > '' then begin
            JobTaskNo := ActivityCode;
            if ProcessCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + ProcessCode;
                if OperationCode > '' then
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + OperationCode;
            end;
        end;
    end;

    procedure JAPOToJobTaskNo(TaskNo: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]) JobTaskNo: Text[35];
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
                    if OperationCode > '' then
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                end;
            end;
        end;
    end;

    procedure GetDate(PurchaseHeader: Record "Purchase Header"): Date;
    begin
        if PurchaseHeader."Posting Date" <> 0D then
            exit(PurchaseHeader."Posting Date");
        exit(WORKDATE);
    end;

    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNewRequisition(var PaymentHeader: Record "NS_Progress Payment Header"; var Subcontract: Record NS_Subcontract)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNewRequisition2(var ProgressPaymentLine2: Record "NS_Progress Payment Line"; var ProgressPaymentLine: Record "NS_Progress Payment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNewVersion1(var ProgressPaymentHeader: Record "NS_Progress Payment Header"; var ProgressPaymentHeader2: Record "NS_Progress Payment Header"; var Subcontract: Record NS_Subcontract)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdatePurchaseOrderLines(var PaymentHeader: Record "NS_Progress Payment Header"; var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdatePurchaseOrderLines2(var PurchaseLine: Record "Purchase Line"; var ProgressPaymentLine: Record "NS_Progress Payment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdatePurchaseOrderLines(var PurchaseHeader: Record "Purchase Header")
    begin
    end;
    // << Upgrade

    //PRJ-1194.NK.1.0 02Mar2022 Start
    procedure CreateRetentionReductionInv(PaymentHeader: Record "NS_Progress Payment Header"; vendorNo: Code[20]);
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseDocumentNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchInvHead: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ProgrPaymLine: Record "NS_Progress Payment Line";
        NSProgressPaymentHead: record "NS_Progress Payment Header"; //PRJCTPR-318.JS.1.0 12FEB2024
        NSPaymrntTerms: record "Payment Terms";  //PRJCTPR-294.JS.1.0 12FEB2024
        NSPreviousLineRetentionAmt: Decimal; //PRJCTPR-318.JS.1.0 14FEB2024
        NSRetentionPercentOnHeader: Decimal; //PRJCTPR-318.JS.1.0 14FEB2024
        LineAmt: Decimal;
        Answer: Boolean;
        text0001: Label 'Purchase Invoice ';
        text0002: Label '\Would you like to go there now?';
        NS_RetenLedCode: Record "NS_Retention Ledger Code";
        Jobs: Record job;
        PurchHeader: Record "Purchase Header";
        // PRJCTPR-279.HS.1.0 15Jan2024  Start
        NS_VendorPostGroup: Record "Vendor Posting Group";
        NS_Vendor: Record Vendor;
        NS_GLAccount: Record "G/L Account";
    //PRJCTPR-279.HS.1.0 15Jan2024 End
    begin
        clear(NSPreviousLineRetentionAmt);   //PRJCTPR-318.JS.1.0 14FEB2024
        clear(NSRetentionPercentOnHeader);  //PRJCTPR-318.JS.1.0 14FEB2024
        PurchaseDocumentNo := '';
        if PurchSetup.Get() then;
        PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchSetup."Invoice Nos.", WORKDATE(), true);
        PurchInvHead.init();
        PurchInvHead."Document Type" := PurchInvHead."Document Type"::Invoice;
        PurchInvHead."No." := PurchaseDocumentNo;
        PurchInvHead.Validate("Buy-from Vendor No.", vendorNo);
        PurchInvHead."Vendor Order No." := PaymentHeader."NS_Purchase Order No.";
        PurchInvHead."NS_Subcontract No." := PaymentHeader."NS_Subcontract No.";
        PurchInvHead.Validate("NS_Job No.", PaymentHeader."NS_Job No.");
        PurchInvHead."NS_Retention Document" := true;
        PurchInvHead.Insert(true);
        //PRJCTPR-294.JS.1.0 05JAN2024 - Start
        if NS_Vendor.get(vendorNo) then begin
            if (NS_Vendor."Payment Terms Code" = '') and (PurchInvHead."Due Date" = 0D) then
                PurchInvHead.validate("Due Date", Today)
            else begin
                if NSPaymrntTerms.get(NS_Vendor."Payment Terms Code") then
                    PurchInvHead.validate("Due Date", CalcDate(NSPaymrntTerms."Due Date Calculation", Today));
            end;
            PurchInvHead.modify();
        end;
        //PRJCTPR-294.JS.1.0 05JAN2024 - end

        PurchLine.Init();
        PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
        PurchLine."Document No." := PurchaseDocumentNo;
        PurchLine."Line No." := 10000;
        PurchLine.Type := PurchLine.Type::NS_Ledger;
        PurchLine.validate("No.", 'RETENTION');
        if NS_RetenLedCode.Get('RETENTION') then
            PurchLine.Description := NS_RetenLedCode.NS_Description;

        PurchLine.Validate(Quantity, 1);
        LineAmt := 0;
        ProgrPaymLine.Reset();
        ProgrPaymLine.SetRange("NS_Subcontract No.", PaymentHeader."NS_Subcontract No.");
        ProgrPaymLine.SetRange("NS_Progress Payment No.", PaymentHeader."NS_No.");
        ProgrPaymLine.SetRange("NS_Requisition No.", PaymentHeader."NS_Requisition No.");
        ProgrPaymLine.SetRange("NS_Version No.", PaymentHeader."NS_Version No.");
        if ProgrPaymLine.FindFirst() then begin
            ProgrPaymLine.CalcSums("NS_Work Retention Amount");
            LineAmt += ProgrPaymLine."NS_Work Retention Amount";

            PurchLine."Job Task No." := ProgrPaymLine."NS_Job Task No.";
        end;
        //PRJCTPR-318.JS.1.0 12FEB2024 - Start
        NSRetentionPercentOnHeader := PaymentHeader."NS_Work Retention Percent" + PaymentHeader."NS_Material Retention Percent";
        NSProgressPaymentHead.Reset();
        NSProgressPaymentHead.setrange("NS_Subcontract No.", PaymentHeader."NS_Subcontract No.");
        NSProgressPaymentHead.setrange("NS_No.", PaymentHeader."NS_No.");
        NSProgressPaymentHead.setrange(NS_Status, NSProgressPaymentHead.NS_Status::Invoiced);
        if NSProgressPaymentHead.FindLast() then begin
            ProgrPaymLine.Reset();
            ProgrPaymLine.SetRange("NS_Subcontract No.", NSProgressPaymentHead."NS_Subcontract No.");
            ProgrPaymLine.SetRange("NS_Progress Payment No.", NSProgressPaymentHead."NS_No.");
            ProgrPaymLine.SetRange("NS_Requisition No.", NSProgressPaymentHead."NS_Requisition No.");
            ProgrPaymLine.SetRange("NS_Version No.", NSProgressPaymentHead."NS_Version No.");
            if ProgrPaymLine.FindFirst() then begin
                ProgrPaymLine.CalcSums("NS_Work Retention Amount");
                NSPreviousLineRetentionAmt := ProgrPaymLine."NS_Work Retention Amount";
            end;
        end;
        //PRJCTPR-318.JS.1.0 12FEB2024 - Start
        if Jobs.Get(PaymentHeader."NS_Job No.") then;
        //PRJ-1489.GK.1.0 start
        //PurchLine."Gen. Prod. Posting Group" := Jobs."NS_Gen. Prod. Posting Group"; 
        // PurchLine."Gen. Prod. Posting Group" := Jobs."NS_Gen. Prod. Posting Group New";  //PRJCTPR-279.HS.1.0 15Jan2024 Commented
        //PRJ-1489.GK.1.0 end
        //PRJCTPR-279.HS.1.0 15Jan2024 Start
        if NS_Vendor.Get(vendorNo) then;
        NS_VendorPostGroup.Reset();
        NS_VendorPostGroup.SetRange(Code, NS_Vendor."Vendor Posting Group");
        if NS_VendorPostGroup.FindFirst() then begin
            if NS_GLAccount.Get(NS_VendorPostGroup."NS_Retention Payables Account") then
                PurchLine."Gen. Prod. Posting Group" := NS_GLAccount."Gen. Prod. Posting Group";
        end;
        //PRJCTPR-279.HS.1.0 15Jan2024 End
        PurchLine.Validate("Direct Unit Cost", LineAmt);
        //PRJCTPR-318.JS.1.0 14FEB2024 - Start
        if NSRetentionPercentOnHeader > 0 then
            PurchLine.Validate("Direct Unit Cost", NSPreviousLineRetentionAmt - LineAmt)
        else
            PurchLine.Validate("Direct Unit Cost", LineAmt);
        //PRJCTPR-318.JS.1.0 14FEB2024 - end
        PurchLine."NS_Subcontract No." := PaymentHeader."NS_Subcontract No."; //PRJ-1194.NK.1.0 09May2022
        PurchLine.Insert();
        //PRJ-1194.NK.1.1 02Mar2022  Start
        Rec.NS_Status := Rec.NS_Status::Invoiced;
        Rec.Modify();
        if PurchHeader.get(PurchHeader."Document Type"::Order, Rec."NS_Purchase Order No.") then begin
            PurchHeader.Status := PurchHeader.Status::Open;
            PurchHeader.Modify();
        end;
        Commit();
        if PurchHeader.get(PurchHeader."Document Type"::Order, Rec."NS_Purchase Order No.") then begin
            PurchHeader.validate("NS_Retention Percent", Rec."NS_Work Retention Percent");
            PurchHeader.Status := PurchHeader.Status::Released;
            PurchHeader.Modify();
        end;
        //PRJ-1194.NK.1.1 02Mar2022  End

        //Message(text0001, PurchaseDocumentNo);
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", PurchaseDocumentNo);
        if CONFIRM(text0001 + PurchaseDocumentNo + text0002, true) then
            PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", PurchaseDocumentNo);
        PAGE.RUN(51, PurchaseHeader);
    end;
    //PRJ-1194.NK.1.0 02Mar2022 End
}

