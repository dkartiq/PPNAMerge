tableextension 14021204 NS_JobSetup extends "Jobs Setup"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-39.SK.1.0 - Modified TableRelation property with Table "AllObjWithCaption"
    //PRJ-67.SK.1.0 - Blocked tableRelation Properties on some fields
    //PRJ-291.MS.1.0 added new field
    //PPAL-64.MS.1.0 -added new field 
    //CTSI-95.MS.1.0 added new field
    //CTSI-115.AS.1.0 Added new field
    //PRJ-400.AM.1.0 8OCT2020 | Changed Captions.
    //PPAL-91.AS.1.0 10SEPT2020 Done code to give error for Option 2
    //CTSI-268.MS.1.0 added new field
    //CTSI-254.MS.1.0 added 2 new field
    //PRJ-361.AS.2.0 11SEPT2020 Added New field
    //PRJ-384.AS.1.0 11SEPT2020 Removed inverted commas from "Use Default Tasks" field
    //TM-10.AM.1.0 20OCT2020 | Added New Boolean Field .
    //PRJ-530.AS.1.0 8FEB2021 Commented & Added code
    //PRJ-665.N.S.1.0 Add table relation on FA Batch name & FA template Name
    //PRJ-866.JS.1.0  19Aug2021 | Add one field
    //PRJ-881.JS.1.0 25Aug2021 | Add table relation
    //PRJ-889.GK.1.0 13Sep2021 | Add Field "Progress Payment Disabled".
    //PRJ-929.GK.1.0 22Sep2021| Add field Use Tax Percentage.
    //PRJ-659.RM.1.0 06-OCT-2021 | Update Calformula of field.
    //PRJ-979.GK.1.0 12Oct | Add Table Relation.
    //PRJ-973.GK.1.0 13Oct2021 | Add one field
    fields
    {
        field(14021101; "NS_Cost Category Required"; Boolean)
        {
            Caption = 'Cost Category Required';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Revenue Category Required"; Boolean)
        {
            Caption = 'Revenue Category Required';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Cost Category Required Bud"; Boolean)
        {
            Caption = 'Cost Category Required Budget';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Revenue Cat. Required Bud"; Boolean)
        {
            Caption = 'Revenue Category Required Budget';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Draw Nos."; Code[10])
        {
            Caption = 'Draw Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Concurrent Users"; Integer)
        {
            Caption = 'Concurrent Users';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Draw Default Payment Terms"; DateFormula)
        {
            Caption = 'Draw Default Payment Terms';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Calculate Indirect Burden"; Boolean)
        {
            Caption = 'Calculate Indirect Burden';
            Description = 'ProjectPro';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_PB Sales Invoice Nos."; Code[10])
        {
            Caption = 'Sales Invoice Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_APO Separators"; Text[10])
        {
            Caption = 'APO Separators';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Activity Code Position"; Integer)
        {
            Caption = 'Activity Code Position within Job Task No.';
            Description = 'ProjectPro';
            InitValue = 1;
            MaxValue = 2;
            MinValue = 1;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if ("NS_Activity Code Position" = 2) and ("NS_APO Separators" = '') then
                    ERROR(Text14021102_Msg);
                //ProjectPro - end
            end;
        }
        field(14021112; "NS_APO Sep Change In Progress"; Boolean)
        {
            Caption = 'APO Sep Change In Progress';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021113; "NS_PB Sales Credit Memo Nos."; Code[10])
        {
            Caption = 'Sales Credit Memo Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021114; "NS_PB Posted Invoice Nos."; Code[10])
        {
            Caption = 'Posted Invoice Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Job No. Separators"; Text[10])
        {
            Caption = 'Job No. Separators';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Job List Indent Increment"; Integer)
        {
            Caption = 'Job List Indent Increment';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021117; "NS_Job List Default Level"; Integer)
        {
            Caption = 'Job List Default Level';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021118; "NS_Job List Bolding"; Option)
        {
            Caption = 'Job List Bolding';
            Description = 'ProjectPro';
            OptionCaption = 'None,Masters,Headers';
            OptionMembers = "None",Masters,Headers;
            DataClassification = CustomerContent;
        }
        field(14021119; "NS_Job List Auto Link Create"; Boolean)
        {
            Caption = 'Job List Auto Link Create';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021120; "NS_Direct Post Resource Usage"; Boolean)
        {
            Caption = 'Direct Post Resource Usage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021121; "NS_Item JNL Use Budgeted Cost"; Boolean)
        {
            Caption = 'Item Journal Use Budgeted Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021122; "NS_Default Job Class"; Option)
        {
            Caption = 'Default Job Class';
            Description = 'ProjectPro';
            OptionCaption = ' ,Master Job,SubJob,Change Order,Extra Work,Proposed';
            OptionMembers = " ","Master Job",SubJob,"Change Order","Extra Work",Proposed;
            DataClassification = CustomerContent;
        }
        field(14021123; "NS_Post Labor Burden RateToJob"; Boolean)
        {
            Caption = 'Post Labor Burden Rate To Job';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021124; "NS_Warning on Zero Multiplier"; Boolean)
        {
            Caption = 'Warning on Zero Multiplier';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021125; "NS_Extended WIP"; Boolean)
        {
            Caption = 'Extended WIP';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021126; "NS_Default Deposit JobTaskNo."; Code[35])
        {
            Caption = 'Default Deposit Job Task No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021127; "NS_Default Forecast Type"; Option)
        {
            Caption = 'Default Forecast Type';
            Description = 'ProjectPro';
            OptionCaption = '% of  Budget,% of Projected';
            OptionMembers = "% of  Budget","% of Projected";
            DataClassification = CustomerContent;
        }
        field(14021128; "NS_Forecast Percent For HrsReq"; Decimal)
        {
            Caption = 'Forecast Percent For Hours Req';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021129; "NS_Allow UpdatesToOrigPlanning"; Boolean)
        {
            Caption = 'Allow Updates To Orig Planning';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021130; "NS_PB Posted Cr. Memo Nos."; Code[10])
        {
            Caption = 'Posted Credit Memo Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021131; "NS_Labor to JobOffset - Credit"; Code[20])
        {
            Caption = 'Labor to Job Offset - Credit';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021132; "NS_Post Job Labor to G/L"; Boolean)
        {
            Caption = 'Post Job Labor to G/L';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021133; "NS_A/R RetentionTaxCalcMethod"; Option)
        {
            Caption = 'A/R Retention Tax Calc Method';
            Description = 'ProjectPro';
            OptionCaption = '1 - Calc tax on sale then apply a retention value based on taxed sale amount,2 - Calc tax on sale then apply retention determined by progress billing,3 - Calc tax on sale less the retention determined by progress billing';
            OptionMembers = "1 - Calc tax on sale then apply a retention value based on taxed sale amount","2 - Calc tax on sale then apply retention determined by progress billing","3 - Calc tax on sale less the retention determined by progress billing";
            DataClassification = CustomerContent;
            //PPAL-91.AS.1.0 10SEPT2020 - START
            trigger OnValidate()
            begin
                if "NS_A/R RetentionTaxCalcMethod" = "NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing" then
                    Error('You can  only  select Option 1 and Option 3');
            end;
            //PPAL-91.AS.1.0 10SEPT2020 - END
        }
        field(14021134; "NS_A/P RetentionTaxCalcMethod"; Option)
        {
            Caption = 'A/P Retention Tax Calc Method';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            OptionCaption = '1 - Calc tax on purchase then apply a retention value based on taxed purchase amount,2 - Calc tax on purchase then apply retention amount,3 - Calc tax on purchase less the retention amount';
            OptionMembers = "1 - Calc tax on purchase then apply a retention value based on taxed purchase amount","2 - Calc tax on purchase then apply retention amount","3 - Calc tax on purchase less the retention amount";
            //PPAL-91.AS.1.0 10SEPT2020 - START
            trigger OnValidate()
            begin
                if "NS_A/P RetentionTaxCalcMethod" = "NS_A/P RetentionTaxCalcMethod"::"2 - Calc tax on purchase then apply retention amount" then
                    Error('You can  only  select Option 1 and Option 3');
            end;
            //PPAL-91.AS.1.0 10SEPT2020 - END
        }
        field(14021135; "NS_Labor to Job Batch Name"; Code[10])
        {
            Caption = 'Labor to Job Batch Name';
            Description = 'ProjectPro';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('GENERAL'));
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Retention Receivable Ledger"; Code[20])
        {
            Caption = 'Retention Receivable Ledger';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_Retention Payable Ledger"; Code[20])
        {
            Caption = 'Retention Payable Ledger';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Calc ReceivableRetBeforeTax"; Boolean)
        {
            Caption = 'Calc Receivable Retention Before Tax';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021139; "NS_Calc Payable Ret Before Tax"; Boolean)
        {
            Caption = 'Calc Payable Retention Before Tax';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Sales Retention Period"; Text[30])
        {
            Caption = 'Sales Retention Period';
            // CharAllowed = '09YYMMDDQQ';//PRJ-530.AS.1.0 8FEB2021 Commented
            CharAllowed = '09ddmmyyqqDDMMYYQQ';//PRJ-530.AS.1.0 8FEB2021 Added

            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            //PRJ-530.AS.1.0 8FEB2021 - start
            trigger OnValidate()
            begin
                Rec."NS_Sales Retention Period" := UpperCase(Rec."NS_Sales Retention Period");
            end;
            //PRJ-530.AS.1.0 8FEB2021 - end
        }
        field(14021141; "NS_Purchase Retention Period"; Text[30])
        {
            Caption = 'Purchase Retention Period';
            //CharAllowed = '09YYMMDDQQ';//PRJ-530.AS.1.0 8FEB2021 Commented
            CharAllowed = '09ddmmyyqqDDMMYYQQ';//PRJ-530.AS.1.0 8FEB2021 Added
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            //PRJ-530.AS.1.0 8FEB2021 - start
            trigger OnValidate()
            begin
                Rec."NS_Purchase Retention Period" := UpperCase(Rec."NS_Purchase Retention Period");
            end;
            //PRJ-530.AS.1.0 8FEB2021 - end
        }
        field(14021142; "NS_Billing Job Task No."; Code[20])//PRJ-881.JS.1.0 25Aug2021
        {
            Caption = 'Billing Job Task No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Activity".NS_Code where(NS_Type = filter(Revenue), "NS_Job Setup Job Quote" = filter(true));//PRJ-881.JS.1.0 25Aug2021
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_G/L Account forContractLine"; Code[20])
        {
            Caption = 'G/L Account for Contract Line';
            Description = 'ProjectPro';
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
        }
        field(14021144; "NS_Total Task No."; Code[20])//PRJ-881.JS.1.0 25Aug2021
        {
            Caption = 'Total Task No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Activity".NS_Code where(NS_Type = filter(cost), "NS_Job Setup Job Quote" = filter(true));//PRJ-881.JS.1.0 25Aug2021
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_HighlightPrice LessThanCost"; Boolean)
        {
            Description = 'ProjectPro';
            Caption = 'Highlight Price Less Than Cost';
            DataClassification = CustomerContent;
        }
        field(14021146; "NS_Auto Lock Planning Lines"; Boolean)
        {
            Caption = 'Auto Lock Planning Lines';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_KPI CalculationStartingDate"; Date)
        {
            Caption = 'KPI Calculation Starting Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_KPI CalculationStartingDate" = 0D then
                    "NS_KPI Calculation Ending Date" := 0D
                else
                    if ("NS_KPI CalculationStartingDate" > "NS_KPI Calculation Ending Date") or
                       ("NS_KPI Calculation Ending Date" = 0D) then
                        "NS_KPI Calculation Ending Date" := CALCDATE('<CM>', "NS_KPI CalculationStartingDate");
                //ProjectPro - end
            end;
        }
        field(14021151; "NS_KPI Calculation Ending Date"; Date)
        {
            Caption = 'KPI Calculation Ending Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_KPI Calculation Ending Date" = 0D then
                    "NS_KPI CalculationStartingDate" := 0D
                else
                    if "NS_KPI Calculation Ending Date" < "NS_KPI CalculationStartingDate" then
                        ERROR(Text14021100_Msg);
                //ProjectPro - end
            end;
        }
        field(14021155; "NS_Advanced Burden Allocation"; Boolean)//CTSI-254.AS.1.0 25MARCH2021
        {
            Caption = 'Advanced Burden Allocation';
            Description = '//CTSI-254.AS.1.0 25MARCH2021';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                GenJnlLine.RESET();
                GenJnlLine.SETRANGE("Journal Template Name", "NS_Burden G/L Journal Template");
                GenJnlLine.SETRANGE("Journal Batch Name", "NS_Burden G/L Journal Batch");
                if GenJnlLine.FindFirst() then
                    Error('The general journal batch "%1" must be blank.', "NS_Burden G/L Journal Batch");
            end;
        }
        field(14021156; "NS_Burden G/L Journal Template"; Code[10])//CTSI-254.AS.1.0 25MARCH2021
        {
            Caption = 'Burden G/L Journal Template';
            Description = 'Burden G/L Journal Template';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14021157; "NS_Burden G/L Journal Batch"; Code[10])//CTSI-254.AS.1.0 25MARCH2021
        {
            Caption = 'Burden G/L Journal Batch';
            Description = 'Burden G/L Journal Batch';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = field("NS_Burden G/L Journal Template"));
        }
        field(14021159; "NS_Auto Post Burden to G/L"; Boolean)//CTSI-254.AS.1.0 25MARCH2021
        {
            Caption = 'Auto Post Burden to G/L';
            Description = '//CTSI-254.AS.1.0 25MARCH2021';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GenJnlLine: Record "Gen. Journal Line";
            begin
                GenJnlLine.RESET();
                GenJnlLine.SETRANGE("Journal Template Name", "NS_Burden G/L Journal Template");
                GenJnlLine.SETRANGE("Journal Batch Name", "NS_Burden G/L Journal Batch");
                if GenJnlLine.FindFirst() then
                    Error('The general journal batch "%1" must be blank.', "NS_Burden G/L Journal Batch");
            end;
        }

        field(14021160; "NS_Burden Alloc From - Credit"; Code[20])
        {
            Caption = 'Burden Alloc From - Credit';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021161; "NS_Burden Alloc To - Debit"; Code[20])
        {
            Caption = 'Burden Alloc To - Debit';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021162; "NS_Burden Alloc Dimension"; Code[20])
        {
            Caption = 'Burden Alloc Dimension';
            Description = 'ProjectPro';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(14021163; "NS_Burden AllocProjectDimValue"; Code[20])
        {
            Caption = 'Burden Alloc Project Dim Value';
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("NS_Burden Alloc Dimension"));
            DataClassification = CustomerContent;
        }
        field(14021164; "NS_Burden AllocServiceDimValue"; Code[20])
        {
            Caption = 'Burden Alloc Service Dim Value';
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("NS_Burden Alloc Dimension"));
            DataClassification = CustomerContent;
        }
        field(14021165; "NS_Burden Required"; Boolean)
        {
            Caption = 'Burden Required';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021166; "NS_Payroll Burden Job Cost Cat"; Code[10])
        {
            Caption = 'Payroll Burden Job Cost Cat';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;
        }
        field(14021167; "NS_Burden Job Cost Category"; Code[10])
        {
            Caption = 'Burden Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;
        }
        field(14021168; "NS_Burden Alloc Secondary Dim"; Code[20])
        {
            Caption = 'Burden Alloc Secondary Dim';
            Description = 'ProjectPro';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(14021169; "NS_Allow Posting Date on JFW As of Date Filter"; Date)
        {
            Caption = 'Allow Posting Date on JFW As of Date Filter';
            Description = 'CTSI-268.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021170; "NS_Mandatory Dimension"; Code[20])
        {
            Caption = 'Mandatory Dimension';
            TableRelation = Dimension;
            Description = 'CTSI-254.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021171; "NS_Mandatory Dimension Value"; Code[20])
        {
            Caption = 'Mandatory Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("NS_Mandatory Dimension"));
            Description = 'CTSI-254.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021172; "NS_Default Job Task No."; Code[20])
        {
            Caption = 'Default Job Task No.';
            TableRelation = "Job Task"."Job Task No.";
            Description = 'CTSI-254.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021173; "NS_Mandatory Dimension Rev."; Code[20])
        {
            Caption = 'Additional Dimension';
            TableRelation = Dimension;
            Description = 'CTSI-274.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021174; "NS_Mandatory Dimension Value Rev."; Code[20])
        {
            Caption = 'Additional Dimension Value';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("NS_Mandatory Dimension Rev."));
            Description = 'CTSI-274.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021175; "NS_Default Job Task No. Rev."; Code[20])
        {
            Caption = 'Default Job Task No.';
            TableRelation = "Job Task"."Job Task No.";
            Description = 'CTSI-274.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021176; "NS_Burden G/L Journal Template Rev."; Code[10])//CTSI-274.MS.1.0 25MARCH2021
        {
            Caption = 'Rev. Rec. G/L Journal Template';
            Description = 'Rev. Rec. G/L Journal Template';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
        field(14021177; "NS_Burden G/L Journal Batch Rev."; Code[10])//CTSI-274.MS.1.0 25MARCH2021
        {
            Caption = 'Rev. Rec. G/L Journal Batch';
            Description = 'Rev. Rec. G/L Journal Batch';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = field("NS_Burden G/L Journal Template Rev."));
            DataClassification = CustomerContent;
        }
        field(14021190; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Description = 'ProjectPro';
            TableRelation = IF ("NS_Job Calendar Source" = CONST("Base Navision Calendar")) "Base Calendar".Code
            ELSE
            IF ("NS_Job Calendar Source" = CONST("Job Calendar")) "NS_Job Calendar".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021191; "NS_Job Calendars Not Used"; Boolean)
        {
            Caption = 'Job Calendars Not Used';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021192; "NS_Job Calendar Source"; Option)
        {
            Caption = 'Job Calendar Source';
            Description = 'ProjectPro';
            OptionCaption = 'Base Navision Calendar,Job Calendar';
            OptionMembers = "Base Navision Calendar","Job Calendar";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Job Calendar Source" <> xRec."NS_Job Calendar Source" then begin
                    "NS_Job Calendar Code" := '';
                    MESSAGE(Text14021101_Msg);
                end;
                //ProjectPro - end
            end;
        }
        field(14021193; "NS_Job Calendar Type"; Option)
        {
            CalcFormula = Lookup("Jobs Setup"."NS_Job Calendar Source");
            Caption = 'Job Calendar Type';
            Description = 'ProjectPro';
            FieldClass = FlowField;
            OptionCaption = 'Base Navision Calendar,Job Calendar';
            OptionMembers = "Base Navision Calendar","Job Calendar";
        }
        field(14021194; "NS_Change Order No. Separator"; Text[10])
        {
            Caption = 'Change Order No. Separator';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021200; "NS_Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            Description = 'ProjectPro';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract Nos."; Code[10])
        {
            Caption = 'Subcontract Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Subcontract Default UOM"; Code[10])
        {
            Caption = 'Subcontract Default UOM';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure"; //PRJ-979.GK.1.0 12Oct
        }
        field(14021302; "NS_Subcontract Use of UOM"; Option)
        {
            Caption = 'Subcontract Use of UOM';
            Description = 'ProjectPro';
            OptionCaption = 'None,Always Default,Default only if none provided';
            OptionMembers = "None","Always Default","Default only if none provided";
            DataClassification = CustomerContent;
        }
        field(14021310; "NS_Subcontract No. Separators"; Text[10])
        {
            Caption = 'Subcontract No. Separators';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021311; "NS_Subcont ListIndentIncrement"; Integer)
        {
            Caption = 'Subcontract List Indent Increment';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021312; "NS_SubcontractListDefaultLevel"; Integer)
        {
            Caption = 'Subcontract List Default Level';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021313; "NS_Subcontract List Bolding"; Option)
        {
            Caption = 'Subcontract List Bolding';
            Description = 'ProjectPro';
            OptionCaption = 'None,Masters,Headers';
            OptionMembers = "None",Masters,Headers;
            DataClassification = CustomerContent;
        }
        field(14021314; "NS_Subcont ListAutoLinkCreate"; Boolean)
        {
            Caption = 'Subcontract List Auto Link Create';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021315; "NS_Lien Release Document 01"; Integer)
        {
            Caption = 'Lien Release Document 01';
            Description = 'ProjectPro';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report)); //PRJ-39.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021316; "NS_Lien Release Document01Name"; Text[80])
        {
            // CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
            //                                                             "Object ID" = FIELD("NS_Lien Release Document 01")));//PRJ-659.RM.1.0 06-OCT-2021 Comment

            //PRJ-659.RM.1.0 06-OCT-2021 Start
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("NS_Lien Release Document 01")));
            //PRJ-659.RM.1.0 06-OCT-2021 End
            Caption = 'Lien Release Document 01 Name';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021317; "NS_Lien Release Document 02"; Integer)
        {
            Caption = 'Lien Release Document 02';
            Description = 'ProjectPro';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));//PRJ-39.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021318; "NS_Lien Release Document02Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("NS_Lien Release Document 02")));
            Caption = 'Lien Release Document 02 Name';
            Description = 'ProjectPro';
            FieldClass = FlowField;

        }
        field(14021319; "NS_Subcontract Draw Nos."; Code[10])
        {
            Caption = 'Subcontract Draw Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021325; "NS_AIA Preprinted Allowed"; Boolean)
        {
            Caption = 'AIA Preprinted Allowed';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021326; "NS_AIA Form Code"; Code[20])
        {
            Caption = 'AIA Form Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021327; "NS_AIA Form Expiration Date"; Date)
        {
            Caption = 'AIA Form Expiration Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021328; "NS_Progress Billing Rounding"; Boolean)
        {
            Caption = 'Progress Billing Rounding';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021329; "NS_Prog. Bill Gen. ProdPostGr."; Code[10])
        {
            Caption = 'Progress Billing Gen. Prod. Post. Gr.';
            Description = 'ProjectPro';
            TableRelation = "Gen. Product Posting Group".Code;
            DataClassification = CustomerContent;
        }
        field(14021330; "NS_ProgressBillStandardInvoice"; Integer)
        {
            Caption = 'Progress Billing Standard Invoice';
            Description = 'ProjectPro';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));//PRJ-39.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021331; "NS_Progress Bill Std Inv Name"; Text[80])
        {
            // CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
            //                                                             "Object ID" = FIELD("NS_ProgressBillStandardInvoice"))); //PRJ-659.RM.1.0 06-OCT-2021
            //PRJ-659.RM.1.0 06-OCT-2021 Start
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("NS_ProgressBillStandardInvoice")));
            //PRJ-659.RM.1.0 06-OCT-2021 End
            Caption = 'Progress Billing Std Invoice Name';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021332; "NS_Sales Document Type"; Option)
        {
            Caption = 'Sales Document Type';
            Description = 'ProjectPro';
            OptionCaption = 'Order,Invoice';
            OptionMembers = "Order",Invoice;
            DataClassification = CustomerContent;
        }
        field(14021333; "NS_Copy Requisition Comments"; Boolean)
        {
            Caption = 'Copy Requisition Comments';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021334; "NS_Copy Version Comments From"; Option)
        {
            Caption = 'Copy Version Comments From';
            Description = 'ProjectPro';
            OptionCaption = 'None,Previous Version,First Version';
            OptionMembers = "None","Previous Version","First Version";
            DataClassification = CustomerContent;
        }
        field(14021335; "NS_Prog BillSalespersonDimCode"; Code[20])
        {
            Caption = 'Prog Bill Salesperson Dim Code';
            Description = 'ProjectPro';
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }
        field(14021336; "NS_AIA G702 Show With Page No."; Integer)
        {
            Caption = 'AIA G702 Show With Page No.';
            Description = 'ProjectPro';
            MinValue = 0;
            //TableRelation = AllObjWithCaption."Object ID" where("Object Type" = CONST(Page)); //PRJ-39.SK.1.0 //PRJ-67.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021337; "NS_AIA G703 Start As Page No."; Integer)
        {
            Caption = 'AIA G703 Start As Page No.';
            Description = 'ProjectPro';
            MinValue = 1;
            //TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page)); //PRJ-39.SK.1.0 //PRJ-67.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021338; "NS_Prog PayAIAPreprintAllowed"; Boolean)
        {
            Caption = 'Prog Pay AIA Preprint Allowed';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021339; "NS_Prog Pay AIA Form Code"; Code[20])
        {
            Caption = 'Prog Pay AIA Form Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021340; "NS_Prog Pay AIA Form Exp Date"; Date)
        {
            Caption = 'Prog Pay AIA Form Exp Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021341; "NS_Prog Pay Rounding"; Boolean)
        {
            Caption = 'Progress Payment Rounding';//PRJ-400.AM.1.0 Caption Changed 
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021342; "NS_Prog Pay Gen. Prod. PostGr."; Code[10])
        {
            Caption = 'Prog Pay Gen. Prod. Post Gr.';
            Description = 'ProjectPro';
            TableRelation = "Gen. Product Posting Group".Code;
            DataClassification = CustomerContent;
        }
        field(14021343; "NS_Prog Pay Standard Invoice"; Integer)
        {
            Caption = 'Progress Payment Std Inv Report ID';//PRJ-400.AM.1.0 Caption Changed 
            Description = 'ProjectPro';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));//PRJ-39.SK.1.0
            DataClassification = CustomerContent;
        }
        field(14021344; "NS_Prog Pay Std Inv Name"; Text[80])
        {
            // CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
            //                                                             "Object ID" = FIELD("NS_Prog Pay Standard Invoice"))); //PRJ-659.RM.1.0 06-OCT-2021
            //PRJ-659.RM.1.0 06-OCT-2021 Start
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("NS_Prog Pay Standard Invoice")));
            //PRJ-659.RM.1.0 06-OCT-2021 End
            Caption = 'Progress Payment Std Invoice Name';//PRJ-400.AM.1.0 Caption Changed 
            Description = 'ProjectPro';
            FieldClass = FlowField;

        }
        field(14021345; "NS_Prog Pay Payment Doc Type"; Option)
        {
            Caption = 'Prog Pay Payment Document Type';
            Description = 'ProjectPro';
            OptionCaption = 'Order,Invoice';
            OptionMembers = "Order",Invoice;
            DataClassification = CustomerContent;
        }
        field(14021346; "NS_Prog Pay Copy Req Comments"; Boolean)
        {
            Caption = 'Copy Requisition Comments';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021347; "NS_Prog Pay CopyVerCommntsFrom"; Option)
        {
            Caption = 'Prog Pay Copy Ver Commnts From';
            Description = 'ProjectPro';
            OptionCaption = 'None,Previous Version,First Version';
            OptionMembers = "None","Previous Version","First Version";
            DataClassification = CustomerContent;
        }
        field(14021348; "NS_Prog Pay Purchaser Dim Code"; Code[20])
        {
            Caption = 'Prog Pay Salesperson Dim Code';
            Description = 'ProjectPro';
            TableRelation = Dimension.Code;
            DataClassification = CustomerContent;
        }
        field(14021349; "NS_Prog Pay AIA G702ShowPageNo"; Integer)
        {
            Caption = 'Prog Pay AIA G702 Show Page No';
            Description = 'ProjectPro';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(14021350; "NS_Prog Pay AIA G703StartPage"; Integer)
        {
            Caption = 'Prog Pay AIA G703 Start Page';
            Description = 'ProjectPro';
            MinValue = 1;
            DataClassification = CustomerContent;
        }
        field(14021351; "NS_Progress Billing Nos."; Code[10])
        {
            Caption = 'Progress Billing Nos.';
            Description = 'ProjectPro';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(14021352; "NS_ProgressBillingFirstNo. Def"; Boolean)
        {
            Caption = 'Progress Billing First No. Def';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
        field(14021353; "NS_Allow Negative Item Job Jnl"; Boolean)
        {
            Caption = 'Allow Negative Item Job Journal';
            Description = 'CTSI-186.MS.1.0';
            DataClassification = CustomerContent;
        }
        //PRJ-543.AS.1.0 18FEB2021 - START
        field(14021354; "NS_Forecast Amount Rounding"; Decimal)
        {
            Caption = 'Forecast Amount Rounding';
            Description = 'PRJ-543.AS.1.0 18FEB2021';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            //InitValue = 0.01;
        }
        //PRJ-543.AS.1.0 18FEB2021 - END

        field(14021375; "NS_Allow Timesheet&JobJnlPost"; Boolean)
        {
            Caption = 'Allow Timesheet & Job Jnl Post';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021398; "NS_Req JMP Doc. No."; Code[20])
        {
            Caption = 'Req JMP Doc. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021399; "NS_ExpandedJobMaterialPlanning"; Boolean)
        {
            Caption = 'Expanded Job Material Planning';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_Job Quote No. Series"; Code[10])
        {
            Caption = 'Quote No. Series';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Job Attribute No. Series"; Code[10])
        {
            Caption = 'Attribute No. Series';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Sales Quote No. Series"; Code[10])
        {
            Caption = 'Sales Quote No. Series';
            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_ResourceNo. forContractLine"; Code[20])
        {
            Caption = 'Resource No. for Contract Line';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021420; "NS_ResourceNo. forInstallLine"; Code[20])
        {
            Caption = 'Resource No. for Install Line';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021425; "NS_ResourceNo. forServiceLine"; Code[20])
        {
            Caption = 'Resource No. for Service Line';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021430; "NS_Install Category Code"; Code[10])
        {
            Caption = 'Install Category Code';
            Description = 'ProjectPro';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(14021435; "NS_G/L AccountNo.-ServiceLine"; Code[20])
        {
            Caption = 'G/L Account No. - Service Line';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021440; "NS_Service Line Description"; Text[50])
        {
            Caption = 'Service Line Description';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021445; "NS_Service Category Code"; Code[10])
        {
            Caption = 'Service Category Code';
            Description = 'ProjectPro';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(14021446; "NS_Use Default Tasks"; Option)
        {
            Caption = 'Use Default Tasks';
            Description = 'ProjectPro';
            OptionCaption = ' ,Default,JobType';//PRJ-384.AS.1.0 11SEPT2020
            OptionMembers = " ",Default,JobType;
            DataClassification = CustomerContent;
        }
        field(14021450; "NS_Job Mat'l Planning Location"; Code[20])
        {
            Caption = 'Job Mat''l Planning Location';
            Description = 'ProjectPro';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(14021455; "NS_Use Job Mat'l Plan Active"; Boolean)
        {
            Caption = 'Use Job Mat''l Plan Active';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021456; "NS_PurchaseResourcesWithOrders"; Option)
        {
            Caption = 'Purchase Resources with Orders';
            Description = 'ProjectPro';
            OptionCaption = 'Invoice,Order';
            OptionMembers = Invoice,"Order";
            DataClassification = CustomerContent;
        }
        field(14021457; "NS_Dimension for Labor Rates"; code[20])
        {
            Caption = 'Global Dim. 1 for Labor Rates';
            Description = 'CTSI-95.MS.1.0';
            TableRelation = Dimension;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GenLedSetup: Record "General Ledger Setup";
            begin
                //CTSI-113.MS.1.0 start
                if GenLedSetup.get then;
                if (GenLedSetup."Global Dimension 1 Code" = "NS_Dimension for Labor Rates") then begin
                end else
                    if (GenLedSetup."Global Dimension 2 Code" = "NS_Dimension for Labor Rates") then begin
                    end else
                        Error('Please select the Global Dimension which is define in Gen. Ledger Setup');
                //CTSI-113.MS.1.0 end
            end;
        }

        field(14021458; "NS_Dimension for Burden Rates"; code[20])
        {
            Caption = 'Dimension for Burden Rates';
            Description = 'CTSI-136.MS.1.0';
            TableRelation = Dimension;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                GenLedSetup: Record "General Ledger Setup";
            begin
                //CTSI-136.MS.1.0 start
                if GenLedSetup.get then;
                if (GenLedSetup."Global Dimension 1 Code" = "NS_Dimension for Burden Rates") then begin

                end else
                    if (GenLedSetup."Global Dimension 2 Code" = "NS_Dimension for Burden Rates") then begin

                    end else
                        Error('Please select the Global Dimension which is define in Gen. Ledger Setup');
                //CTSI-136.MS.1.0 end
            end;
        }
        field(14021459; "NS_Required GM% Var for JFW Comments"; Decimal)
        {
            Caption = 'Required GM% Var for JFW Comments';
            DataClassification = CustomerContent;
            Description = 'CTSI-268';
        }

        field(14021462; "NS_Burden Alloc Dim"; Code[20])
        {
            Caption = 'Burden Alloc Dim';
            Description = 'ProjectPro';
            TableRelation = Dimension;
            DataClassification = CustomerContent;
        }
        field(14021465; "NS_ProgressBillingDefG/L Act."; Code[20])
        {
            Caption = 'Progress Billing Def. G/L Act.';
            Description = 'ProjectPro';
            TableRelation = "G/L Account"."No.";
            DataClassification = CustomerContent;
        }
        field(14021466; "NS_Progress Billing DefDescr1"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 1';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021467; "NS_ProgressBillingDefDescr. 2"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021468; "NS_ProgressBillingDefDescr. 3"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 3';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021469; "NS_ProgressBillingDefDescr. 4"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 4';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021470; "NS_ProgressBillingDefDescr. 5"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 5';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021471; "NS_ProgressBillingDefDescr. 6"; Text[50])
        {
            Caption = 'Progress Billing Def. Descr. 6';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021472; "NS_ProgressBillingDef. Pct. 1"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 1';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021473; "NS_ProgressBillingDef. Pct. 2"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021474; "NS_ProgressBillingDef. Pct. 3"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 3';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021475; "NS_ProgressBillingDef. Pct. 4"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 4';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021476; "NS_ProgressBillingDef. Pct. 5"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 5';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021477; "NS_ProgressBillingDef. Pct. 6"; Decimal)
        {
            Caption = 'Progress Billing Def. Pct. 6';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021496; "NS_Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            Description = 'ProjectPro';
            TableRelation = "Gen. Business Posting Group".Code;
            DataClassification = CustomerContent;
        }
        field(14021497; "NS_Work Order No. Series"; Code[10])
        {
            Caption = 'Work Order No. Series';
            Description = 'ProjectPro';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(14021498; "NS_Received Accrual Batch Name"; Code[10])
        {
            Caption = 'Received Accrual Batch Name';
            Description = 'ProjectPro';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = CONST('GENERAL'));
            DataClassification = CustomerContent;
        }
        field(14021499; "NS_LaborAllocated toJob -Debit"; Code[20])
        {
            Caption = 'Labor Allocated to Job - Debit';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021495; "NS_Get Job Segment"; Boolean)
        {
            Caption = 'Get Job Segment';
            Description = 'PRJ-291.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021478; "NS_Job Cost Cat.for Rev.LaborEnt."; Code[10])
        {
            Caption = 'Job Cost Cat.for Rev.Labor Ent.';
            Description = 'PPAL-64.MS.1.0';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_GBPG for Job Forecast"; Code[200])//CTSI-115.AS.1.0 Added new field
        {
            Caption = 'GBPG for Job Forecast';
            Description = 'GBPG for Job Forecast';
            DataClassification = SystemMetadata;
        }
        field(14021402; "NS_Show Default task in Copy Job"; Boolean)//PRJ-361.AS.2.0 11SEPT2020
        {
            Caption = 'Show Default task in Copy Job';
            Description = 'We need to use this bool only to rearrange copy job functionality';
            DataClassification = CustomerContent;
        }
        //TM-10.AM.1.0 start
        field(14021403; "NS_Job Segment Mandatory"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Job Segment Mandatory';
        }
        //TM-10.AM.1.0 end
        //PRJ-490.AM.1.0 start
        field(14021404; "NS_FA Job Template Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'FA Job Template Name';
            TableRelation = "Job Journal Template";//PRJ-665.N.S.1.0

        }
        field(14021407; "NS_Check Master Job No."; Boolean)//PRJ-604.AS.1.0
        {
            DataClassification = CustomerContent;
            Caption = 'Check Master Job No.';
        }
        field(14021406; "NS_FA Job Batch Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'FA Job Batch Name';
            TableRelation = "Job Journal Batch".Name where("Journal Template Name" = field("NS_FA Job Template Name"));//PRJ-665.N.S.1.0
        }
        //PRJ-490.AM.1.0 End
        field(14021408; "NS_Unapply UsageLink on Subcon"; Boolean)    //PRJ-866.JS.1.0  19Aug2021
        {
            DataClassification = CustomerContent;
            Caption = 'Unapply Usage Link on Subcontract';
        }
        //PRJ-889.GK.1.0 13Sep2021 Start
        field(14021409; "NS_Progress Payment Enable"; Option)
        {
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';
            DataClassification = CustomerContent;
            Caption = 'Progress Payment Enable';
        }
        //PRJ-889.GK.1.0 13Sep2021 End

        //PRJ-929.GK.1.0 22Sep2021 start
        field(14021490; "NS_Use Tax Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Default Use Tax Percentage';
            MinValue = 0;
        }
        //PRJ-929.GK.1.0 22Sep2021 end
        //PRJ-973.GK.1.0 13Oct2021 start
        field(14021491; "NS_Use Job Plan. Line Entries"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Job Planning Line Entries';
        }
        //PRJ-973.GK.1.0 13Oct2021 end

        //PRJ-1040.AS.1.0 START Added Field
        field(14021492; "NS_Notify Insurance Exp"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Insurance Expiration Notify';
            InitValue = false;
        }
        //PRJ-1040.AS.1.0 END
    }

    var
        Text14021100_Msg: Label 'The KPI Calculation Ending Date must not be earlier than the Starting Date.';
        Text14021101_Msg: Label 'The Job Setup Card must be re-opened before a new Job Calendar Code can be chosen.';
        Text14021102_Msg: Label 'Since the Activity Code Starts in the second position of the Job Task No.,\there must be at least one APO separator character.';
}

//   +------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021101 Cost Category Required          14021138 Calc Receivable Ret Before Tax  14021325 AIA Preprinted Allowed         14021415 Resource No. for Contract Line
//   +     14021102 Revenue Category Required      14021139 Calc Payable Ret Before Tax    14021326 AIA Form Code                  14021420 Resource No. for Install Line
//   +     14021103 Cost Category Required Bud      14021140 Sales Retention Period          14021327 AIA Form Expiration Date        14021425 Resource No. for Service Line
//   +     14021104 Revenue Category Required Bud  14021141 Purchase Retention Period      14021328 Progress Billing Rounding      14021430 Install Category Code
//   +     14021105 Draw Nos.                      14021150 KPI Calculation Starting Date  14021329 Prog. Bill Gen. Prod. Post Gr.  14021435 G/L Account No. - Service Line
//   +     14021106 Concurrent Users                14021151 KPI Calculation Ending Date    14021330 Progress Bill Standard Invoice  14021440 Service Line Description
//   +     14021107 Draw Default Payment Terms      14021160 Burden Alloc From - Credit      14021331 Progress Bill Std Inv Name      14021445 Service Category Code
//   +     14021108 Calculate Indirect Burden      14021161 Burden Alloc To - Debit        14021332 Sales Document Type            14021446 Use Default Tasks
//   +     14021109 PB Sales Invoice Nos.          14021162 Burden Alloc Dimension          14021333 Copy Requisition Comments      14021450 Job Mat'l Planning Location
//   +     14021110 APO Separators                  14021163 Burden Alloc Project Dim Value  14021334 Copy Version Comments From      14021455 Use Job Mat'l Plan Active
//   +     14021111 Activity Code Position          14021164 Burden Alloc Service Dim Value  14021335 Prog Bill Salesperson Dim Code  14021456 Purchase Resources with Orders
//   +     14021112 APO Sep Change In Progress      14021165 Burden Required                14021336 AIA G702 Show With Page No.    14021462 Burden Alloc Dim
//   +     14021113 PB Sales Credit Memo Nos.      14021166 Payroll Burden Job Cost Cat    14021337 AIA G703 Start As Page No.      14021465 Progress Billing Def. G/L Act.
//   +     14021114 PB Posted Invoice Nos.          14021167 Burden Job Cost Category        14021338 Prog Pay AIA Preprint Allowed  14021466 Progress Billing Def. Descr. 1
//   +     14021115 Job No. Separators              14021168 Burden Alloc Secondary Dim      14021339 Prog Pay AIA Form Code          14021467 Progress Billing Def. Descr. 2
//   +     14021116 Job List Indent Increment      14021190 Job Calendar Code              14021340 Prog Pay AIA Form Exp Date      14021468 Progress Billing Def. Descr. 3
//   +     14021117 Job List Default Level          14021191 Job Calendars Not Used          14021341 Prog Pay Rounding              14021469 Progress Billing Def. Descr. 4
//   +     14021118 Job List Bolding                14021192 Job Calendar Source            14021342 Prog Pay Gen. Prod. Post Gr.    14021470 Progress Billing Def. Descr. 5
//   +     14021119 Job List Auto Link Create      14021193 Job Calendar Type                14021343 Prog Pay Standard Invoice      14021471 Progress Billing Def. Descr. 6
//   +     14021120 Direct Post Resource Usage      14021194 Change Order No. Separator       14021344 Prog Pay Std Inv Name          14021472 Progress Billing Def. Pct. 1
//   +     14021121 Item Journal Use Budgeted Cost  14021200 Prepayment No. Series            14021345 Prog Pay Payment Document Type  14021473 Progress Billing Def. Pct. 2
//   +     14021122 Default Job Class              14021300 Subcontract Nos.                 14021346 Prog Pay Copy Req Comments      14021474 Progress Billing Def. Pct. 3
//   +     14021123 Post Labor Burden Rate To Job  14021301 Subcontract Default UOM          14021347 Prog Pay Copy Ver Commnts From  14021475 Progress Billing Def. Pct. 4
//   +     14021124 Warning on Zero Multiplier      14021302 Subcontract Use of UOM           14021348 Prog Pay Purchaser Dim Code    14021476 Progress Billing Def. Pct. 5
//   +     14021125 Extended WIP                    14021310 Subcontract No. Separators       14021349 Prog Pay AIA G702 Show Page No  14021477 Progress Billing Def. Pct. 6
//   +     14021126 Default Deposit Job Task No.    14021311 Subcont List Indent Increment    14021350 Prog Pay AIA G703 Start Page    14021496 Gen. Bus. Posting Group
//   +     14021127 Default Forecast Type          14021312 Subcontract List Default Level   14021351 Progress Billing Nos.          14021497 Work Order No. Series
//   +     14021128 Forecast Percent For Hours Req  14021313 Subcontract List Bolding         14021352 Progress Billing First No. Def  14021498 Received Accrual Batch Name
//   +     14021129 Allow Updates To Orig Planning  14021314 Subcont List Auto Link Create    14021375 Allow Timesheet & Job Jnl Post  14021499 Labor Allocated to Job - Debit
//   +     14021130 PB Posted Credit Memo Nos.      14021315 Lien Release Document 01         14021398 Req JMP Doc. No.                14021500 Labor to Job Offset - Credit
//   +     14021133 A/R Retention Tax Calc Method  14021316 Lien Release Document 01 Name    14021399 Expanded Job Material Planning  14021501 Post Job Labor to G/L
//   +     14021134 A/P Retention Tax Calc Method  14021317 Lien Release Document 02         14021400 Job Quote No. Series            14021502 Labor to Job Batch Name
//   +     14021136 Retention Receivable Ledger    14021318 Lien Release Document 02 Name    14021405 Job Attribute No. Series        14021503 Billing Job Task No.
//   +     14021137 Retention Payable Ledger        14021319 Subcontract Draw Nos.            14021410 Sales Quote No. Series          14021504 G/L Account for Contract Line
//   +                                                                                                                             14021505 Total Task No.
//   +     14021506 Highlight Price Less Than Cost   14021146 Auto Lock Planning Lines.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s)
//   +     Text14021100
//   +     Text14021101
//   +     Text14021102
//   +
//   +  - Modified:
//   + PRJ-291.MS.1.0 added new field
//   +------------------------------------------------------------