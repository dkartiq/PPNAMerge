tableextension 14021108 NS_SalesHeader extends "Sales Header"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-131.SK.1.0 Added code for populating the "Gen. Bus. Posting Group" from diffrent setups on condition basis.
    //CTSI-150.AS.1.0 28Sept2020 Added new field
    //PRJ-415.MS.1.0 flow of salesperson from Job to SI
    //PRJ-911.GK.1.0 10Sep2021 |Validate Default job retention on job No.
    //PRJ-999.JS.1.0 12Nov2021 | Add Code for Dimension
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1099.JS.1.0 31Dec2021 | Modify code for dimension on condition basis
    //PRJ-1201.AS.1.0 03MARCH2022  | Add one field
    //PRJ-1304.RM.1.0 22April2022 | Added a Field
    //PRJ-1519.NK.1.0 16Jul2022 | Added Code
    //PRJ-1624.NK.1.0 22Sep2022 | Added Field
    //PRJCTPR-192.DK.1.0 09OCT2023 | Make a Procedure
    //PRJCTPR-252.HS.1.0 28Dec2023| Added code
    //PRJCTPR-304.HS.1.0 24Jan2024 | Added Code

    fields
    {

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NS_SalesLine: Record "Sales Line";
                NS_JobLinks: Record "NS_Job Links";
                NS_JobPlanningLine: Record "Job Planning Line";
                NS_Job: Record Job;
                IncompatibleLines: Boolean;
                JobSetup: Record "Jobs Setup";
                CustomerRec: Record Customer;
                NS_ProgrBillHead: Record "NS_Progress Billing Header";  //PRJ-1099.JS.1.0 30Dec2021
                NS_DefaultDim: Record "Default Dimension";  //PRJ-1099.JS.1.0 30Dec2021
            begin
                //ProjectPro - start
                //PRJ-1610.GK.1.0 09Sept2022 start
                if Rec."NS_Job No." <> '' then begin
                    if NS_Job.Get("NS_Job No.") then;
                    if JobSetup.Get() then;
                    IF NS_Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                        Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Add New
                    else
                        IF JobSetup."NS_Gen. Bus. Posting Group" <> '' then
                            Validate("Gen. Bus. Posting Group", JobSetup."NS_Gen. Bus. Posting Group")
                        else
                            IF CustomerRec.Get(Rec."Sell-to Customer No.") then
                                IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                                    Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
                    //PRJ-131.SK.1.0 End
                end else begin
                    IF CustomerRec.Get(Rec."Sell-to Customer No.") then
                        IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                            Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
                end;
                //PRJ-1610.GK.1.0 09Sept2022 end
                if "NS_Job No." = '' then
                    exit;

                IF JobSetup.Get() then;
                with NS_SalesLine do begin
                    IncompatibleLines := false;
                    RESET;
                    SETRANGE("Document Type", Rec."Document Type");
                    SETRANGE("Document No.", Rec."No.");
                    if FINDFIRST then
                        repeat
                            if "Job No." <> '' then
                                if not NS_JobLinks.GET("Job No.", Rec."NS_Job No.") then
                                    IncompatibleLines := true;
                        until (NEXT = 0) or IncompatibleLines;

                    if IncompatibleLines then
                        if not CONFIRM(Text14021100lbl, true, Rec."NS_Job No.") then
                            ERROR(Text14021101Lbl)
                        else begin
                            RESET;
                            SETRANGE("Document Type", Rec."Document Type");
                            SETRANGE("Document No.", Rec."No.");
                            if FIND('-') then
                                repeat
                                    if "Job No." > '' then begin
                                        "Job No." := Rec."NS_Job No.";

                                        //Check Job Task No.
                                        if "Job Task No." > '' then begin
                                            NS_JobPlanningLine.RESET;
                                            NS_JobPlanningLine.SETRANGE("Job No.", "Job No.");
                                            NS_JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
                                            if NS_JobPlanningLine.ISEMPTY then
                                                "Job Task No." := '';
                                        end;

                                        MODIFY;
                                    end;
                                until NEXT = 0;
                        end;
                end;
                "Currency Code" := '';
                if NS_Job.GET(Rec."NS_Job No.") then begin
                    if "NS_Multiple Retention on Lines" = false then //PRJ-1624.NK.1.0 07Oct2022
                        Validate("NS_Retention Percent", NS_Job."NS_Default Job Retention"); //PRJ-911.GK.1.0 10Sep2021
                    if NS_Job."Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Currency Code");
                    if NS_Job."Invoice Currency Code" > '' then
                        VALIDATE("Currency Code", NS_Job."Invoice Currency Code");

                    //PRJ-131.SK.1.0 Start
                    // IF NS_Job."NS_Gen. Bus. Posting Group" <> '' then//PRJ-831.AS.1.0 12OCT2021 Comment old
                    //    Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group")//PRJ-831.AS.1.0 12OCT2021 Comment old
                    //PRJ-999.JS.1.0  12Nov2021 Start
                    JobSetup.Get();   //PRJ-1087.JS.1.0 18Dec2021 add line
                    if JobSetup."NS_Flow Job Card Dimension" = true then begin    //PRJ-1087.JS.1.0 18Dec2021 add line
                        Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                        Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                        Rec."Dimension Set ID" := NS_GetDimensionNoFromJob(Rec."NS_Job No.");
                        //PRJ-1099.JS.1.0 30Dec2021-Start
                    end else begin   //PRJ-1087.JS.1.0 18Dec2021 add line
                                     //PRJ-999.JS.1.0 10Nov2021 - end  //PRJ-1049.JS.1.0 02Dec2021
                        NS_DefaultDim.Reset();
                        NS_DefaultDim.SetRange("Table ID", 23);
                        NS_DefaultDim.SetRange("No.", Rec."Sell-to Customer No.");
                        if NS_DefaultDim.IsEmpty() then begin
                            Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            Rec."Dimension Set ID" := NS_ProgrBillHead.GetDimensionNoFromJob(Rec."NS_Job No.");
                        end;
                    end;
                    //PRJ-1099.JS.1.0 30Dec2021-End     
                    CreateDimFromDefaultDim(Rec.FieldNo("NS_Job No.")); //PRJCTPR-199.JS.1.0 line adeed

                    //PRJ-1610.GK.1.0 09Sept2022 start-comment
                    //IF NS_Job."NS_Gen. Bus. Posting Group New" <> '' then//PRJ-831.AS.1.0 12OCT2021 Add New
                    //Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New")//PRJ-831.AS.1.0 12OCT2021 Add New
                    //else
                    // IF JobSetup."NS_Gen. Bus. Posting Group" <> '' then
                    //  Validate("Gen. Bus. Posting Group", JobSetup."NS_Gen. Bus. Posting Group")
                    //else
                    // IF CustomerRec.Get(Rec."Sell-to Customer No.") then
                    //   IF CustomerRec."Gen. Bus. Posting Group" <> '' then
                    //      Validate("Gen. Bus. Posting Group", CustomerRec."Gen. Bus. Posting Group");
                    //PRJ-131.SK.1.0 End
                    //PRJ-1610.GK.1.0 09Sept2022 end
                    validate("External Document No.", NS_Job."NS_Customer PO Number");//CTSI-179.MS.1.0
                    "Salesperson Code" := NS_Job."NS_Salesperson Code";//PRJ-415


                end;
                //ProjectPro - end
            end;
        }
        field(14021130; "NS_Retention InvoiceDiscAmount"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Inv. Discount Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."),
                                                                         "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Invoice Disc. Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021136; "NS_Retention Base Amount"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."),
                                                                         "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            FieldClass = FlowField;

            trigger OnValidate();
            var
                JobsSetup: Record "Jobs Setup";
            begin
            end;
        }
        field(14021137; "NS_Retention Base Before Tax"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                "Document No." = FIELD("No."),
                                                                "NS_Retention Applies" = CONST(true)));
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 15; //PRJ-1519.NK.1.0 16Jul2022
            trigger OnValidate();
            var
                GLSetup: Record 98;
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                GLSetup.GET;
                if "NS_Retention Percent" = 0 then begin
                    if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
                       (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                        NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin
                        "NS_Retention Amount (LCY)" := 0;
                        "NS_Retention Amount" := 0;
                    end;
                    if ("NS_Retention Amount (LCY)" = 0) and ("NS_Retention Amount" = 0) then
                        "NS_Retention Date" := 0D;
                end else begin
                    //TESTFIELD("Retention Document", FALSE);
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(NS_RetentionBase("Document Type", "No.") * ("NS_Retention Percent" / 100),
                                                          GLSetup."Amount Rounding Precision");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end;
                //ProjectPro - end
            end;
        }
        field(14021139; "NS_Retention Amount (LCY)"; Decimal)
        {
            Caption = 'Retention Amount ($)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                if "NS_Retention Amount (LCY)" <> 0 then begin
                    if "NS_Retention Document" = false then //PRJ-1648.PS.1.0 16DEC2022
                        TESTFIELD("NS_Retention Document", false);
                    "NS_Retention Percent" := 0;
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount" := "NS_Retention Amount (LCY)";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount" := ROUND(CurrExchRate.ExchangeAmtLCYToFCY("Posting Date", "Currency Code", "NS_Retention Amount (LCY)",
                                                    CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                    NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end else
                    "NS_Retention Amount" := 0;
                //ProjectPro - end
            end;
        }
        field(14021140; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CurrExchRate: Record 330;
            begin
                //ProjectPro - start
                NS_JobsSetup.GET;
                if "NS_Retention Amount" <> 0 then begin
                    if "NS_Retention Document" = false then  //PRJ-1648.PS.1.0 16DEC2022
                        TESTFIELD("NS_Retention Document", false);
                    "NS_Retention Percent" := 0;
                    if "Currency Code" = '' then begin
                        "NS_Retention Amount (LCY)" := "NS_Retention Amount";
                    end else begin
                        NS_Currency.GET("Currency Code");
                        "NS_Retention Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "NS_Retention Amount",
                                                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code")),
                                                          NS_Currency."Amount Rounding Precision");
                    end;
                    if "NS_Retention Date" = 0D then
                        if NS_JobsSetup."NS_Sales Retention Period" <> '' then
                            "NS_Retention Date" := CALCDATE('+' + NS_JobsSetup."NS_Sales Retention Period", "Posting Date");
                end else
                    "NS_Retention Amount (LCY)" := 0;
                //ProjectPro - end
            end;
        }
        field(14021145; "NS_Retention Date"; Date)
        {
            Caption = 'Retention Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if CurrFieldNo <> 0 then begin
                    if "NS_Retention Date" > 0D then
                        if ("NS_Retention Date" > 0D) and ("NS_Retention Document" = false) then //PRJ-1648.PS.1.0 16DEC2022
                            TESTFIELD("NS_Retention Document", false);

                    if "NS_Retention Amount (LCY)" <> 0 then
                        TESTFIELD("NS_Retention Date");
                end;
                //ProjectPro - end
            end;
        }
        field(14021146; "NS_Retention Document"; Boolean)
        {
            Caption = 'Retention Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NS_SalesLine: Record "Sales Line";  //PRJCTPR-304.HS.1.0 24Jan2024 
                NS_SalesLineL: Record "Sales Line";// PRJCTPR-333.PS.1.0 19March2024
                NS_Jobsetup: Record "Jobs Setup";// PRJCTPR-333.PS.1.0 19March2024
                SalesHeader: Record "Sales Header"; //FGH-163.SM.240424  //PRJCTPR-358.JS.1.0 24APR2024
                IsHandled: Boolean; //FGH-163.SM.240424 //PRJCTPR-358.JS.1.0 24APR2024
            begin
                //FGH-163.SM.240424 START  //PRJCTPR-358.JS.1.0 24APR2024
                OnBeforeOnValidateRetentionDocument(SalesHeader, IsHandled);
                If IsHandled then
                    exit;
                //FGH-163.SM.240424 END  //PRJCTPR-358.JS.1.0 24APR2024
                //ProjectPro - start
                if "NS_Retention Document" = true then begin
                    TESTFIELD("NS_Retention Amount (LCY)", 0);
                    TESTFIELD("NS_Retention Percent", 0);
                    TESTFIELD("NS_Retention Date", 0D);
                end;

                if NS_Jobsetup.Get() then;

                //ProjectPro - end
                // PRJCTPR-333.PS.1.0 19March2024 Start
                if Rec."NS_Retention Document" then begin
                    NS_SalesLine.Reset();
                    NS_SalesLine.SetRange("Document No.", Rec."No.");
                    if not NS_SalesLine.FindFirst() then begin
                        NS_SalesLineL.Init();
                        NS_SalesLineL.Validate("Document Type", Rec."Document Type");
                        NS_SalesLineL.Validate("Document No.", Rec."No.");
                        NS_SalesLineL.Validate("Line No.", 10000);
                        NS_SalesLineL.Type := NS_SalesLineL.type::NS_Ledger;
                        NS_SalesLineL.Validate("No.", NS_Jobsetup."NS_Retention Receivable Ledger");
                        NS_SalesLineL.Insert();

                    end else begin
                        // PRJCTPR-333.PS.2.0 02April2024 Start
                        // PRJCTPR-333.PS.2.0 02April2024 Start
                        Message('The lines already exist on Invoice No. %1 Enabling it will delete all the lines and a new line with type ledger and No. %2 will be created.', Rec."No.", NS_JobSetup."NS_Retention Receivable Ledger");
                        if not confirm('Are you sure you want to continue?', true, true) then
                            Error('');
                        // PRJCTPR-333.PS.2.0 02April2024 End
                        // PRJCTPR-333.PS.2.0 02April2024 End
                        NS_SalesLine.DeleteAll();
                        NS_SalesLineL.Init();
                        NS_SalesLineL.Validate("Document Type", Rec."Document Type");
                        NS_SalesLineL.Validate("Document No.", Rec."No.");
                        NS_SalesLineL.Validate("Line No.", 10000);
                        NS_SalesLineL.Type := NS_SalesLineL.type::NS_Ledger;
                        NS_SalesLineL.Validate("No.", NS_Jobsetup."NS_Retention Receivable Ledger");
                        NS_SalesLineL.Insert();

                    end;

                end;
                if not Rec."NS_Retention Document" then begin
                    // PRJCTPR-333.PS.2.0 02April2024 Start
                    if not confirm('There exists a line with the type Ledger and No. %1 Disabling it will delete the line. Are you sure you want to continue?', true, NS_JobSetup."NS_Retention Receivable Ledger", true) then
                        Error('');
                    // PRJCTPR-333.PS.2.0 02April2024 End
                    NS_SalesLine.Reset();
                    NS_SalesLine.SetRange("Document No.", Rec."No.");
                    NS_SalesLine.SetRange(Type, NS_SalesLine.Type::NS_Ledger);
                    NS_SalesLine.SetRange("No.", NS_Jobsetup."NS_Retention Receivable Ledger");
                    if NS_SalesLine.findset() then begin
                        repeat
                            NS_SalesLine.Validate("Unit Price", 0);
                            NS_SalesLine.Validate("Unit Cost (LCY)", 0);
                            NS_SalesLine.Validate("Unit Cost", 0);
                            NS_SalesLine.Validate(Quantity, 0);
                            NS_SalesLine.Validate(Description, '');
                            NS_SalesLine.type := NS_SalesLine.Type::" ";
                            NS_SalesLine."No." := '';
                            NS_SalesLine.Modify(true);
                        until NS_SalesLine.Next = 0;
                    end;
                end;

                // PRJCTPR-304.HS.1.0 23Jan2024 Start
                // if not Rec."NS_Retention Document" then begin
                //     NS_SalesLine.Reset();
                //     NS_SalesLine.SetRange("Document No.", Rec."No.");
                //     if NS_SalesLine.FindFirst() then begin
                //         if (NS_SalesLine.Type = NS_SalesLine.Type::NS_Ledger) and (NS_SalesLine."No." = 'RETENTION') then
                //             Error('You cannot disable "Retention Document" due to existing lines with "Type = Ledger".');
                //     end;
                // end;
                // PRJCTPR-304.HS.1.0 24Jan2024 End  
                // PRJCTPR-333.PS.1.0 19March2024 End  


            end;
        }
        field(14021325; "NS_Progress Billing Document"; Boolean)
        {
            Caption = 'Progress Billing Document';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021327; "NS_From Progress Billing No."; Code[20])
        {
            Caption = 'From Progress Billing No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021328; "NS_From ProgressBillingReq.No."; Integer)
        {
            Caption = 'From Progress Billing Req. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021329; "NS_From ProgressBillingVer.No."; Integer)
        {
            Caption = 'From Progress Billing Ver. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021330; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
        //CTSI-150.AS.1.0 28Sept2020 - start
        field(14021350; "NS_Use % Billing format"; Boolean)
        {
            Caption = 'Use % Billing Format';
            Description = 'Boolean Use % Billing Format';
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - end
        field(14021400; "NS_Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Entered By"; Code[50])
        {
            Caption = 'Entered By';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Core Credit Override"; Boolean)
        {
            Caption = 'Core Credit Override';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; NS_Collector; Code[10])
        {
            Caption = 'Collector';
            Description = 'ProjectPro';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Credit Approved By"; Code[50])
        {
            Caption = 'Credit Approved By';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Credit Approved On"; DateTime)
        {
            Caption = 'Credit Approved On';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Invoice Delivery Method"; Code[10])
        {
            Caption = 'Invoice Delivery Method';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        //PRJ-1201.AS.1.0 03MARCH2022  start
        field(14021407; "NS_Add Job Address"; Boolean)
        {
            Caption = 'Add Job Address';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        //PRJ-1201.AS.1.0 03MARCH2022  end
        //PRJ-1304.RM.1.0 Start
        field(14021408; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'Draw No.';
            // TableRelation = NS_Draw."NS_No.";//PRJ-1304.RM.2.0 //PRJCTPR-252.HS.1.0 28Dec2023 Commented
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),  //PRJCTPR-252.HS.1.0 28Dec2023
                                              NS_Closed = CONST(false));
            DataClassification = CustomerContent;
        }
        //PRJ-1304.RM.1.0 End
        //PRJ-1624.NK.1.0 22Sep2022 Start
        field(14021486; "NS_Multiple Retention on Lines"; Boolean)
        {
            Caption = 'Multiple Retention on Lines';
            DataClassification = CustomerContent;
            Description = 'Multiple Retention on Lines';
        }
        //PRJ-1624.NK.1.0 22Sep2022 End

        //PE-302.JS.1.0 29MAY24-Start
        field(14021311; "NS_AppliesToDocument Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'AppliesToDocument Type';
            DataClassification = CustomerContent;
            Description = '"Applies To Document Type" is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            //Editable = false;
        }
        field(14021312; "NS_AppliesToDocument No."; code[20])
        {
            Caption = 'AppliesToDocument No.';
            DataClassification = CustomerContent;
            Description = '"Applies To Document No." is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            //Editable = false;

            trigger OnValidate()
            var
                NSGenJnlLine: Record "Gen. Journal Line";
                NSGenJnlApply: Codeunit "Gen. Jnl.-Apply";
                NSApplyCustEntries: Page "Apply Customer Entries";
                IsHandled: Boolean;
            begin
                IsHandled := false;
                NS_OnBeforeLookupAppliesToDocNo(Rec, NSCustLedgEntry, IsHandled);
                if IsHandled then
                    exit;

                TestField("Bal. Account No.", '');
                NSCustLedgEntry.SetApplyToFilters("Bill-to Customer No.", "NS_AppliesToDocument Type".AsInteger(), "NS_AppliesToDocument No.", Amount);
                NS_OnAfterSetApplyToFilters(NSCustLedgEntry, Rec);

                NSApplyCustEntries.SetSales(Rec, NSCustLedgEntry, Rec.FieldNo("NS_AppliesToDocument No."));
                NSApplyCustEntries.SetTableView(NSCustLedgEntry);
                NSApplyCustEntries.SetRecord(NSCustLedgEntry);
                NSApplyCustEntries.LookupMode(true);
                if NSApplyCustEntries.RunModal() = ACTION::LookupOK then begin
                    NSApplyCustEntries.GetCustLedgEntry(NSCustLedgEntry);
                    NSGenJnlApply.CheckAgainstApplnCurrency(
                      "Currency Code", NSCustLedgEntry."Currency Code", NSGenJnlLine."Account Type"::Customer, true);
                    "NS_AppliesToDocument Type" := NSCustLedgEntry."Document Type";
                    "NS_AppliesToDocument No." := NSCustLedgEntry."Document No.";
                    NS_OnAfterAppliesToDocNoOnLookup(Rec, NSCustLedgEntry);
                end;
                Clear(NSApplyCustEntries);
            end;
        }
        //PE-302.JS.1.0 29MAY24-end        

    }

    procedure NS_RetentionBase(DocumentType: enum "Sales Document Type"; No: Code[20]): Decimal;
    var
        SalesHeader: Record 36;
        SalesLine: Record 37;
        TotalRetention: Decimal;
    BEGIN
        //ProjectPro - start
        TotalRetention := 0;
        NS_JobsSetup.GET;

        IF SalesHeader.GET(DocumentType, No) THEN
            IF (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") OR
               (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
                NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") THEN BEGIN
                SalesHeader.CALCFIELDS("NS_Retention Base Before Tax", "NS_Retention InvoiceDiscAmount");
                TotalRetention := SalesHeader."NS_Retention Base Before Tax" - SalesHeader."NS_Retention InvoiceDiscAmount";
            END ELSE BEGIN
                SalesHeader.CALCFIELDS("NS_Retention Base Amount", "NS_Retention InvoiceDiscAmount");
                TotalRetention := SalesHeader."NS_Retention Base Amount" - SalesHeader."NS_Retention InvoiceDiscAmount";
            END;

        EXIT(TotalRetention);
        //ProjectPro - end
    END;

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_Currency: Record Currency;
        NS_JobCust: Record Customer;
        NSCustLedgEntry: Record "Cust. Ledger Entry";   //PE-302.JS.1.0 30MAY2024
        Text14021100lbl: Label 'There are lines that are not part of this job.  All Job Numbers will be set to %1.\If a Job Task Number does not exist on the new job, it will be cleared.\Do you want to continue?';
        Text14021101Lbl: Label 'The Job No. has not been modified.';

    //PRJ-999.JS.1.0  12Nov2021 Start
    procedure NS_GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
    var
        DefaultDimension: Record "Default Dimension";
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        DimensionNo := 0;
        with DefaultDimension do begin
            DefaultDimension.RESET();
            DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimension.SETRANGE("No.", JobNo);
            if DefaultDimension.FINDSET() then
                repeat
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
            DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
        end;
    end;
    //PRJ-999.JS.1.0  12Nov2021 end 
    //PRJCTPR-192.DK.1.0 09OCT2023 Start
    /// <summary>
    /// NS_SetShipToAddress.
    /// </summary>
    /// <param name="NS_ShipToName">Text[100].</param>
    /// <param name="NS_ShipToName2">Text[50].</param>
    /// <param name="NS_ShipToAddress">Text[100].</param>
    /// <param name="NS_ShipToAddress2">Text[50].</param>
    /// <param name="NS_ShipToCity">Text[30].</param>
    /// <param name="NS_ShipToPostCode">Code[20].</param>
    /// <param name="NS_ShipToCounty">Text[30].</param>
    /// <param name="NS_ShipToCountryRegionCode">Code[10].</param>
    /// <param name="NS_ShipToContact">Text[100].</param>
    /// <param name="NS_ShipToCode">Code[10].</param>
    procedure NS_SetShipToAddress(NS_ShipToName: Text[100]; NS_ShipToName2: Text[50]; NS_ShipToAddress: Text[100]; NS_ShipToAddress2: Text[50]; NS_ShipToCity: Text[30]; NS_ShipToPostCode: Code[20]; NS_ShipToCounty: Text[30]; NS_ShipToCountryRegionCode: Code[10]; NS_ShipToContact: Text[100]; NS_ShipToCode: Code[10])
    begin
        "Ship-to Name" := NS_ShipToName;
        "Ship-to Name 2" := NS_ShipToName2;
        "Ship-to Address" := NS_ShipToAddress;
        "Ship-to Address 2" := NS_ShipToAddress2;
        "Ship-to City" := NS_ShipToCity;
        "Ship-to Post Code" := NS_ShipToPostCode;
        "Ship-to County" := NS_ShipToCounty;
        "Ship-to Country/Region Code" := NS_ShipToCountryRegionCode;
        "Ship-to Contact" := NS_ShipToContact;
        "Ship-to code" := NS_ShipToCode;
    end;
    //FGH-163.SM.240424 START  //PRJCTPR-358.JS.1.0 24APR2024
    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnValidateRetentionDocument(Var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;
    //FGH-163.SM.240424 END  //PRJCTPR-358.JS.1.0 24APR2024
    //PRJCTPR-192.DK.1.0 09OCT2023 End

    //PE-302.JS.1.0 30MAY2024-Start
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeLookupAppliesToDocNo(var SalesHeader: Record "Sales Header"; var CustLedgEntry: Record "Cust. Ledger Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterSetApplyToFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure NS_OnAfterAppliesToDocNoOnLookup(var SalesHeader: Record "Sales Header"; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;
    //PE-302.JS.1.0 30MAY2024-end

    /*+----------------------------------------------------------
  +ProjectPro
  + - Added field(s):
  +    14021100 Job No.
  +    14021130 Invoice Discount Amount
  +    14021136 Retention Base Amount
  +    14021137 Retention Base Before Tax
  +    14021138 Retention Percent
  +    14021139 Retention Amount (LCY)
  +    14021140 Retention Amount
  +    14021145 Retention Date
  +    14021146 Retention Document
  +    14021325 Progress Billing Document
  +    14021327 From Progress Billing No.
  +    14021328 From Progress Billing Req. No.
  +    14021329 From Progress Billing Ver. No.
  +    14021330 Retention Ledger Code
  +    14021400 Free Freight
  +    14021401 Entered By
  +    14021402 Core Credit Override
  +    14021403 Collector
  +    14021404 Credit Approved By
  +    14021405 Credit Approved On
  +    14021406 Invoice Delivery Method
  +
  + - Added function(s):
  +    RetentionBase
  +
  + - Added global variable(s):
  +     PP_JobsSetup
  +     PP_Currency
  +     PP_JobCust
  +
  + - Added global text constant(s):
  +     Text14021100
  +     Text14021101
  +
  + - Modification(s):
  +    - Set Customer Posting Group as Editable = Yes
  +    - Added field value for 'Customer Posting Group' after a Job No. is entered
  +    - Modification for retention in foreign currency
  +    - Modified Retention Base function to calcfields on the correct field
  +    - Modifed InitFromContact, InitFromTemplate to set shipping fields
  +    - Added number settings initialization to fields
  +       - In Sell-to Customer No. OnValidate()
  +       - In InitFromContact()
  +       - In InitFromTemplate
  +       Shipping No.
  +       Posting No.
  +       Return Receipt No.
  +       Prepayment No.
  +       Prepmt. Cr. Memo No.
  +   - TestSalesLineFieldsBeforeRecreate - Removed Testfield on Job No.
  +   - CreateSalesLine - Set Job No.
  +----------------------------------------------------------*/
}

