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
    //PRJ-999.JS.1.0 01Nov2021 | Add dimension fields
    // +------------------------------------------------------------
    //PRJ-1519.NK.1.0 15Jul2022 | Added Code
    //PRJ-1624.NK.1.0 26Sep2022 | Block Code
    //PRJ-1708.JS.1.0 - 12DEC2022 | Add fields
    //PRJCTPR-191.HS.1.0 4OCT2023 | Added some code
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
            var
                ProgBillHead: Record "NS_Progress Billing Header";
                NS_Jpl: Record "Job Planning Line";  //PRJCTPR-191.HS.1.0 4Oct2023
            begin
                //PRJ-1519.NK.1.0 13Sep2022 Start
                if Rec.NS_Quantity <> xRec.NS_Quantity then begin
                    ProgBillHead.Reset();
                    ProgBillHead.SetRange("NS_Job No.", Rec."NS_Job No.");
                    ProgBillHead.SetRange("NS_No.", "NS_Progress Billing No.");
                    ProgBillHead.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                    ProgBillHead.SetRange("NS_Version No.", Rec."NS_Version No.");
                    ProgBillHead.SetFilter("NS_Work Retention Percent", '<>%1', 0);
                    IF ProgBillHead.FindSet() then
                        Rec.validate("NS_Work Retention Percent", ProgBillHead."NS_Work Retention Percent");
                end;
                //PRJ-1519.NK.1.0 13Sep2022 End
                NS_LineCalculations(Rec);
                //PRJCTPR-191.HS.1.0 4Oct2023 Start
                NS_Jpl.SetRange("Job Task No.", rec."NS_Job Task No.");
                NS_Jpl.SetRange("Job No.", rec."NS_Job No.");
                NS_Jpl.SetRange("Line No.", rec."NS_Planing Line No.");
                if NS_Jpl.FindFirst() then begin
                    NS_Jpl."NS_Version No." := Rec."NS_Version No.";
                    NS_Jpl."NS_Requisition No." := rec."NS_Requisition No.";
                    NS_Jpl.Modify();
                end;
            end;
            //PRJCTPR-191.HS.1.0 4Oct2023 End
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
            //DecimalPlaces = 2 : 8;     //PRJ-980.MS.1.0  21Oct2021 //PRJ-1519.NK.1.0 15Jul2022 Block
            DecimalPlaces = 2 : 15; //PRJ-1519.NK.1.0 15Jul2022
            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
            end;
        }
        field(33; "NS_Work Retention Amount"; Decimal)
        {
            Caption = 'Work Retention Amount';
            DataClassification = CustomerContent;
            //DecimalPlaces = 2 : 4; //PRJ-1519.NK.1.0 19Jul2022
            trigger OnValidate();
            begin
                //NS_LineCalculations(Rec); //PRJ-1519.NK.1.0 15Jul2022 Block
                NS_LineCalculationsWorkRetAmt(Rec); //PRJ-1519.NK.1.0 15Jul2022
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
            var
                ProgBillHead: Record "NS_Progress Billing Header"; //PRJ-1519.NK.1.0 13Sep2022
            begin
                //PRJ-1519.NK.1.0 13Sep2022 Start
                if "NS_Material Retention Percent" = 0 then begin
                    ProgBillHead.Reset();
                    ProgBillHead.SetRange("NS_Job No.", Rec."NS_Job No.");
                    ProgBillHead.SetRange("NS_No.", "NS_Progress Billing No.");
                    ProgBillHead.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                    ProgBillHead.SetRange("NS_Version No.", Rec."NS_Version No.");
                    ProgBillHead.SetFilter("NS_Material Retention Percent", '<>%1', 0);
                    IF ProgBillHead.FindSet() then
                        Rec.validate("NS_Material Retention Percent", ProgBillHead."NS_Material Retention Percent");
                end;
                //PRJ-1519.NK.1.0 13Sep2022 End
                NS_LineCalculations(Rec);
                Rec."NS_Old Stored Materials Amount" := xRec."NS_Stored Materials Amount"; //PRJ-1519.NK.1.0 24Aug2022 
                if Rec."NS_Stored Material Retention %" <> 0 then //PRJ-1624.NK.1.0 28Oct2022
                    "NS_Stored Mat. Retention Amt" := ROUND("NS_Stored Materials Amount" * (Rec."NS_Stored Material Retention %" / 100), 0.0001); //PRJ-1624.NK.1.0 28Oct2022
            end;
        }
        field(36; "NS_Material Retention Percent"; Decimal)
        {
            Caption = 'Material Retention Percent';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 15; //PRJ-1624.NK.1.0 04Nov2022
            trigger OnValidate();
            begin
                NS_LineCalculations(Rec);
                if ((Rec."NS_Material Retention Percent" <> 0) or (Rec."NS_Stored Materials Amount" <> 0)) then begin  //PE-15.PS.1.0 30Jan2023
                    Rec."NS_Stored Material Retention %" := "NS_Material Retention Percent";
                    //PRJ-1519.NK.1.0 12Sep2022 Start
                    if NS_LastStotrBilling(Rec) >= "NS_Stored Materials Amount" then
                        "NS_Stored Mat. Retention Amt" := ROUND((NS_LastStotrBilling(Rec) - "NS_Stored Materials Amount") * (Rec."NS_Stored Material Retention %" / 100), 0.0001)
                    else
                        //PRJ-1519.NK.1.0 12Sep2022 End
                        Rec."NS_Stored Mat. Retention Amt" := ROUND(Rec."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100), 0.0001);
                end;
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

        //PRJ-999.JS.1.0 01Nov2021 - Start
        field(215; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(216; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code");
            end;
        }

        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                "NS_Dimension Set ID" :=
                  DimMgt.EditDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2 %3 %4', "NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Line No."));
            end;
        }
        //PRJ-999.JS.1.0 01Nov2021 - end  
        //PRJ-1519.NK.1.0 10Aug2022 Start
        field(481; "NS_Stored Material Retention %"; Decimal)
        {
            Caption = 'Stored Material Retention Percentage';
            Description = 'Stored Material Retention Percentage';
            DecimalPlaces = 2 : 15;
            DataClassification = SystemMetadata;
            trigger OnValidate()
            begin

                //PRJ-1648.PS.1.0 12Dec2022 Start
                //PE-15.PS.1.0 11Jan2023 Start
                if Rec."NS_Stored Material Retention %" <> 0 then
                    Rec.Validate("NS_Material Retention Percent", Rec."NS_Stored Material Retention %");
                NS_LineCalculationsWorkRetAmt(Rec);
                //PE-15.PS.1.0 11Jan2023 End
                if ProgressBillingHeader.GET(Rec."NS_Progress Billing No.", Rec."NS_Requisition No.", Rec."NS_Version No.") then;
                if ProgressBillingHeader."NS_R_Reduction & Invoicing" = true then begin
                    "NS_Stored Mat. Retention Amt" := ROUND("NS_Stored Materials Amount" * (Rec."NS_Stored Material Retention %" / 100), 0.0001);
                    "NS_Line Storage_Retetion" := ROUND("NS_Stored Materials Amount" * (Rec."NS_Stored Material Retention %" / 100), 0.0001);
                    Rec."NS_Eff Store Work Ret Red" := Round(Rec.NS_LastStotrBilling(Rec) * (Rec."NS_Stored Material Retention %" / 100), 0.0001);
                end else

                    //PRJ-1648.PS.1.0 12Dec2022 End
                    //PRJ-1519.NK.1.0 12Sep2022 Start
                    //PE-15.PS.1.0 06Jan2023 Start
                    // if NS_LastStotrBilling(Rec) >= "NS_Stored Materials Amount" then
                    //     "NS_Stored Mat. Retention Amt" := ROUND((NS_LastStotrBilling(Rec) - "NS_Stored Materials Amount") * (Rec."NS_Stored Material Retention %" / 100), 0.0001)
                    // else
                    //PE-15.PS.1.0 06Jan2023 End 
                    //PRJ-1519.NK.1.0 12Sep2022 End
                    "NS_Stored Mat. Retention Amt" := ROUND("NS_Stored Materials Amount" * (Rec."NS_Stored Material Retention %" / 100), 0.0001);
            end;



        }
        field(482; "NS_Stored Mat. Retention Amt"; Decimal)
        {
            Caption = 'Stored Material Retention Amount';
            Description = 'Stored Material Retention Amount';
            DataClassification = SystemMetadata;
            //DecimalPlaces = 0 : 4; //PRJ-1624.NK.1.0 07Nov2022 Block
            DecimalPlaces = 2 : 4; //PRJ-1624.NK.1.0 07Nov2022 
            //PRJ-1624.NK.1.0 04Nov2022 Start
            trigger OnValidate()
            begin
                if ProgressBillingHeader.GET("NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.") then;
                if ProgressBillingHeader."NS_Multiple Retention on Lines" then begin
                    if rec."NS_Stored Materials Amount" <> 0 then
                        Rec."NS_Stored Material Retention %" := ROUND(("NS_Stored Mat. Retention Amt" * 100 / "NS_Stored Materials Amount"), 0.000000000000001);
                end;
            end;
            //PRJ-1624.NK.1.0 04Nov2022 End
        }
        field(483; "NS_Old Stored Materials Amount"; Decimal)
        {
            Caption = 'Old Stored Materials Amount';
            DataClassification = CustomerContent;
            Description = 'For calculation purposes';
        }
        //PRJ-1519.NK.1.0 10Aug2022 End

        //PRJ-1648.PS.1.0 06Dec2022 Start

        field(484; "NS_Work Ret Amt Reduction"; Decimal)
        {
            Caption = 'Work Retention Amount Retdution';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_LineCalculationsWorkRetAmt(Rec);
            end;
        }
        field(485; "NS_Effective Work Ret Red"; Decimal)
        {
            Caption = 'Effective Work Retention Retdution';
            DataClassification = CustomerContent;
        }

        field(486; "NS_Line Label Retetion"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(487; "NS_Line Storage_Retetion"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        //PRJ-1648.PS.1.0 27Dec2022
        field(489; "NS_Eff Store Work Ret Red"; Decimal)
        {
            Caption = 'Effective Work Store Retention Retdution';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                NS_LineCalculationsWorkRetAmt(Rec);
            end;
        }
        //PRJ-1648.PS.1.0 27Dec2022


        //PRJ-1648.PS.1.0 06Dec2022 End

        //PRJ-1708.JS.1.0 - 12DEC2022 - Start
        field(530; "NS_Contract Forecast Date"; Date)
        {
            Caption = 'Contract Forecast Date';
            DataClassification = CustomerContent;
            Description = 'Contract Forecast Date';

            trigger OnValidate()
            var
                NSJobs: Record Job;
            begin
                if NSJobs.get("NS_Job No.") then;
                if NSJobs."NS_Job Class" = NSJobs."NS_Job Class"::"Master Job" then
                    Error(Err_NSText);
                if "NS_Job No." <> '' then begin
                    if "NS_Contract Forecast Date" <> NSJobs."NS_Contract Date" then
                        "NS_CF Date Changed on PBLn" := true
                    else
                        "NS_CF Date Changed on PBLn" := false;
                    Rec.Modify();
                end;
            end;
        }
        field(531; "NS_Change Order"; Boolean)
        {
            Caption = 'Change Order';
            DataClassification = CustomerContent;
            Description = 'Change Order';

            trigger OnValidate()
            var
                NSJobs: Record Job;
            begin
                if NSJobs.get("NS_Job No.") then;
                if NSJobs."NS_Job Class" = NSJobs."NS_Job Class"::"Master Job" then
                    Error(Err_NSText);
                if "NS_Change Order" = true then
                    if "NS_Job No." <> '' then begin
                        if "NS_Contract Forecast Date" <> NSJobs."NS_Contract Date" then
                            "NS_CF Date Changed on PBLn" := true
                        else
                            "NS_CF Date Changed on PBLn" := false;
                        Rec.Modify();
                    end;
            end;

        }
        field(533; "NS_CF Date Changed on PBLn"; Boolean)
        {
            Caption = 'CF Date Changed on PB Line';
            DataClassification = CustomerContent;
            Description = 'Contract forecast date changed on PB Line';
            Editable = false;
        }
        //PRJ-1708.JS.1.0 - 12DEC2022 - End
        //PRJCTPR-174.PS.1.0 13Aug2023 Start
        field(534; "NS_PreviousRetPer %"; Decimal)
        {
            Caption = 'Previous Work Retention Percentage';
            DataClassification = CustomerContent;
            Description = 'Check validtion for double documents';
            Editable = false;
        }

        //PRJCTPR-174.PS.1.0 13Aug2023 End


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
        //PRJ-1132.NK.1.0 Start
        //with ProgressBillingLine do begin
        GLSetup.GET();
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '>%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.");
                if ProgressBillingHeader.NS_Status = ProgressBillingHeader.NS_Status::Open then begin
                    ProgressBillingLine."NS_Work Amount" := ProgressBillingLine.NS_Total - NS_LastTotal(ProgressBillingLine) + xRec.NS_Total - Rec.NS_Total;
                    ProgressBillingLine."NS_Work Retention Amount" := ROUND(ProgressBillingLine."NS_Work Amount" * (ProgressBillingLine."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
                    ProgressBillingLine."NS_Material Retention Amount" := ROUND(ProgressBillingLine."NS_Stored Materials Amount" * (ProgressBillingLine."NS_Material Retention Percent" / 100),
                                                         GLSetup."Amount Rounding Precision");
                    //PRJ-1648.PS.1.0 28Dec2022 Start 
                    ProgressBillingLine."NS_Eff Store Work Ret Red" := ROUND(NS_LastStotrBilling(Rec) *
                                                        (ProgressBillingHeader."NS_Material Retention Percent" / 100),
                                                        GLSetup."Amount Rounding Precision");
                    //PRJ-1648.PS.1.0 28Dec2022 End
                    ProgressBillingLine.MODIFY();
                end
            until ProgressBillingLine.NEXT() = 0;
        //end;
        //PRJ-1132.NK.1.0 End
    end;
    //PE-118.NC.1.0 03Aug2023 Start
    trigger OnDelete()
    var
        JobPlanLine: Record "Job Planning Line";
    begin
        JobPlanLine.Reset();
        JobPlanLine.SetRange("Job No.", Rec."NS_Job No.");
        JobPlanLine.SetRange("Job Task No.", Rec."NS_Job Task No.");
        JobPlanLine.SetRange("Line No.", Rec."NS_Planing Line No.");
        //PRJCTPR-191.HS.1.0 4OCT2023 START
        JobPlanLine.setrange(NS_ProgessBillingNo, rec."NS_Progress Billing No.");
        JobPlanLine.SetRange("NS_Requisition No.", rec."NS_Requisition No.");
        JobPlanLine.SetRange("NS_Version No.", rec."NS_Version No.");
        //PRJCTPR-191.HS.1.0 4OCT2023  END
        if JobPlanLine.FindFirst() then begin
            if NS_Quantity = 0 then begin
                JobPlanLine.NS_ProgessBillingNo := '';
                JobPlanLine."NS_Requisition No." := 0; //PRJCTPR-191.HS.1.0 4OCT2023 
                JobPlanLine."NS_Version No." := 0; //PRJCTPR-191.HS.1.0 4OCT2023 
                JobPlanLine.Modify();
            end
        end;
    end;
    //PE-118.NC.1.0 03Aug2023 End

    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;     //PRJ-999.JS.1.0  01Nov2021        
        Text001: Label 'This requisition has had a receivables document generated.\There can be no further changes to this version.\\Please make a new version if changes are needed.';
        Text002: Label 'Contract Quantity is only used when Billing Method is ''Unit''.\\It identified how many total units there are in the contract.';
        Err_NSText: Label 'Applicable only for sub level and change order jobs';  //PRJ-1708.JS.2.0 02DEC2022

    procedure NS_LineCalculations(var Rec: Record "NS_Progress Billing Line");
    begin
        GLSetup.GET();
        //PRJ-1132.NK.1.0 Start
        //with Rec do begin
        ProgressBillingHeader.GET(Rec."NS_Progress Billing No.", Rec."NS_Requisition No.", Rec."NS_Version No.");

        case Rec."NS_Billing Method" of
            Rec."NS_Billing Method"::"%":
                Rec.NS_Total := (Rec.NS_Quantity / 100) * Rec."NS_Base Amount";
            Rec."NS_Billing Method"::Unit:
                Rec.NS_Total := Rec.NS_Quantity * Rec."NS_Base Amount";
            Rec."NS_Billing Method"::"L/S":
                Rec.NS_Total := Rec.NS_Quantity;
            else
                Rec.NS_Total := 0;
        end;

        if ProgressBillingHeader."NS_Round Amounts" then
            Rec.NS_Total := ROUND(Rec.NS_Total, 1.0)
        else
            Rec.NS_Total := ROUND(Rec.NS_Total, GLSetup."Amount Rounding Precision");

        Rec."NS_Work Amount" := Rec.NS_Total - NS_LastTotal(Rec);

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

        //PRJ-1648.PS.1.0 13OCT2022 - Start

        if ProgressBillingHeader."NS_R_Reduction & Invoicing" = true then begin


            Rec."NS_Line Label Retetion" := Round(Rec."NS_Work Amount" * (Rec."NS_Work Retention Percent" / 100), 0.0001);  //PRJ-1648.PS.1.0 19Dec2022
            Rec."NS_Line Storage_Retetion" := Round(Rec."NS_Stored Materials Amount" * (Rec."NS_Stored Material Retention %" / 100), 0.0001); //PRJ-1648.PS.1.0 19Dec2022
            Rec."NS_Eff Store Work Ret Red" := Round(Rec.NS_LastStotrBilling(Rec) * (Rec."NS_Stored Material Retention %" / 100), 0.0001);
            if (ProgressBillingHeader."NS_Work Retention Percent" > 0) and (Rec."NS_Work Retention Percent" <> 0) then begin //PRJ-471.MS.1.0
                                                                                                                             //Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision"); PRJ-1519.NK.1.0 19Jul2022 Block
                Rec."NS_Work Ret Amt Reduction" := ROUND(NS_LastTotal(Rec) * (Rec."NS_Work Retention Percent" / 100), 0.0001); //PRJ-1519.NK.1.0 19Jul2022
                Rec."NS_Effective Work Ret Red" := ROUND(NS_LastTotal(Rec) * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision");
                Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), 0.0001); //PE-15.PS.1.0 09Jan2023
            end else begin
                if Rec."NS_Work Retention Percent" <> 0 then begin
                    Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision"); //PRJ-1519.NK.1.0 19Jul2022 Block  //PE-15.PS.1.0 09Jan2023
                    Rec."NS_Work Ret Amt Reduction" := ROUND(NS_LastTotal(Rec) * (Rec."NS_Work Retention Percent" / 100), 0.0001) //PRJ-1519.NK.1.0 19Jul2022 
                end else begin
                    Rec."NS_Work Ret Amt Reduction" := 0;  //PRJ-471.MS.1.0
                    Rec."NS_Effective Work Ret Red" := Rec."NS_Work Retention Amount";
                end;

            end;
            Rec."NS_Effective Work Ret Red" := Rec."NS_Work Ret Amt Reduction";  //PRJ-1648.PS.1.0 19Dec2022


        end else begin
            //PRJ-1648.PS.1.0 13OCT2022 End 

            if (ProgressBillingHeader."NS_Work Retention Percent" > 0) and (Rec."NS_Work Retention Percent" <> 0) then begin //PRJ-471.MS.1.0
                                                                                                                             //Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision"); PRJ-1519.NK.1.0 19Jul2022 Block
                Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), 0.0001); //PRJ-1519.NK.1.0 19Jul2022
                Rec."NS_Effective Work Retention" := ROUND(Rec.NS_Total * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision");

                //PRJ-1648.PS.1.0 06Dec2022 - Start 
                Rec."NS_Work Ret Amt Reduction" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), 0.0001); //PRJ-1519.NK.1.0 19Jul2022
                Rec."NS_Effective Work Ret Red" := ROUND(Rec.NS_Total * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision");
                //PRJ-1648.PS.1.0 06Dec2022 - End
            end else begin
                if Rec."NS_Work Retention Percent" <> 0 then begin //PRJ-1648.PS.1.0 06Dec2022
                    // Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision") //PRJ-1519.NK.1.0 19Jul2022 Block
                    Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), 0.0001); //PRJ-1519.NK.1.0 19Jul2022 
                    Rec."NS_Work Ret Amt Reduction" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), 0.0001);//PRJ-1648.PS.1.0 06Dec2022 
                end else begin
                    Rec."NS_Work Retention Amount" := 0;  //PRJ-471.MS.1.0
                    "NS_Work Ret Amt Reduction" := 0; //PRJ-1648.PS.1.0 06Dec2022 
                end;
                Rec."NS_Effective Work Retention" := Rec."NS_Work Retention Amount";
                Rec."NS_Effective Work Ret Red" := Rec."NS_Work Ret Amt Reduction"; //PRJ-1648.PS.1.0 06Dec2022 

            end;
        end;
        //PRJ-1648.PS.1.0 13OCT2022 

        //PRJ-385.AM.1.0 End
        //PRJ-1624.NK.1.0 26Sep2022 Start Block
        //PRJ-1519.NK.1.0 12Sep2022 Start
        // if ((Rec."NS_Stored Material Retention %" <> 0) and (Rec."NS_Stored Materials Amount" <> 0)) then begin
        //     // if NS_LastStotrBilling(Rec) > "NS_Stored Materials Amount" then
        //     //     "NS_Stored Mat. Retention Amt" := ROUND((NS_LastStotrBilling(Rec) - "NS_Stored Materials Amount") * (Rec."NS_Stored Material Retention %" / 100), 0.0001)
        //     // else
        //     //     Rec."NS_Stored Mat. Retention Amt" := ROUND(Rec."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100), 0.0001)
        // end;
        //PRJ-1519.NK.1.0 12Sep2022 End
        //PRJ-1624.NK.1.0 26Sep2022 End Block
        if Rec."NS_Stored Materials Amount" = 0 then begin
            Rec."NS_Stored Material Retention %" := 0;
            Rec."NS_Stored Mat. Retention Amt" := 0;
        end;


        //PRJ-1519.NK.1.0 10Aug2022 End

        //Calculate the effective material retention
        if (ProgressBillingHeader."NS_Material Retention Percent" > 0) and (Rec."NS_Material Retention Percent" <> 0) then //PRJ-471.MS.1.0
            Rec."NS_EffectiveMaterialRetention" := ROUND(Rec."NS_Stored Materials Amount" *
                                                    (ProgressBillingHeader."NS_Material Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision")
        else begin
            if Rec."NS_Material Retention Percent" <> 0 then
                Rec."NS_Material Retention Amount" := ROUND(Rec."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100),
                GLSetup."Amount Rounding Precision")
            else
                Rec."NS_Material Retention Amount" := 0;//PRJ-471.MS.1.0
            Rec."NS_EffectiveMaterialRetention" := Rec."NS_Material Retention Amount";
        end;
        //PRJ-1648.PS.1.0 07Dec2022 Start
        if ProgressBillingHeader."NS_R_Reduction & Invoicing" then begin
            //   Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetentionReduction(Rec) - Rec."NS_Effective Work Ret Red"  ////PRJ-1648.PS.1.0 07Dec2022
            //Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetention(Rec) - Rec."NS_Effective Work Ret Red"; //PRJCTPR-320.NC.1.0 06Feb2024 Block
            Rec."NS_Billed Work Retention Amt" := Rec.NS_LastBilledWorkRetAmt(Rec) - Rec."NS_Effective Work Ret Red"; //PRJCTPR-320.NC.1.0 06Feb2024
            // Rec."NS_Billed MaterialRetentionAmt" := Rec.NS_LastMaterialEffectiveRetention(Rec) - Rec."NS_EffectiveMaterialRetention";
            Rec."NS_Billed MaterialRetentionAmt" := Rec.NS_LastMaterialEffectiveRetention(Rec) - Rec."NS_Eff Store Work Ret Red";//PRJ_1648.PS.1.0 28DEC2022
        end else begin
            //Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetention(Rec) - Rec."NS_Effective Work Retention"; //PRJCTPR-320.NC.1.0 06Feb2024 Block
            Rec."NS_Billed Work Retention Amt" := Rec.NS_LastBilledWorkRetAmt(Rec) - Rec."NS_Effective Work Retention"; //PRJCTPR-320.NC.1.0 06Feb2024
            Rec."NS_Billed MaterialRetentionAmt" := Rec.NS_LastMaterialEffectiveRetention(Rec) - Rec."NS_EffectiveMaterialRetention";
        end;
        //PRJ-1648.PS.1.0 07Dec2022 End


        Rec."NS_Line Amount" := Rec."NS_Work Amount" + Rec."NS_Stored Materials Amount";
        Rec."NS_Line Amount With Retention" := Rec."NS_Line Amount" - Rec."NS_Effective Work Retention" - Rec."NS_EffectiveMaterialRetention";
        Rec.MODIFY();
        //end;
        //PRJ-1132.NK.1.0
    end;
    //PRJ-1519.NK.1.0 15Jul2022 Start
    procedure NS_LineCalculationsWorkRetAmt(var Rec: Record "NS_Progress Billing Line");
    begin
        GLSetup.GET();
        ProgressBillingHeader.GET(Rec."NS_Progress Billing No.", Rec."NS_Requisition No.", Rec."NS_Version No.");

        case Rec."NS_Billing Method" of
            Rec."NS_Billing Method"::"%":
                Rec.NS_Total := (Rec.NS_Quantity / 100) * Rec."NS_Base Amount";
            Rec."NS_Billing Method"::Unit:
                Rec.NS_Total := Rec.NS_Quantity * Rec."NS_Base Amount";
            Rec."NS_Billing Method"::"L/S":
                Rec.NS_Total := Rec.NS_Quantity;
            else
                Rec.NS_Total := 0;
        end;

        if ProgressBillingHeader."NS_Round Amounts" then
            Rec.NS_Total := ROUND(Rec.NS_Total, 1.0)
        else
            Rec.NS_Total := ROUND(Rec.NS_Total, GLSetup."Amount Rounding Precision");

        Rec."NS_Work Amount" := Rec.NS_Total - NS_LastTotal(Rec);
        //Rec."NS_Work Retention Percent" := 0;
        if rec."NS_Work Retention Amount" <> 0 then
            Rec."NS_Work Retention Percent" := ROUND(((Rec."NS_Work Retention Amount" / rec.NS_Total) * 100), GLSetup."Amount Rounding Precision")
        else
            Rec."NS_Work Retention Percent" := 0;
        //PRJ-1624.NK.1.0 04Nov2022 Start
        if ProgressBillingHeader."NS_Multiple Retention on Lines" then begin
            if rec.NS_Total <> 0 then
                Rec."NS_Work Retention Percent" := ROUND((rec."NS_Work Retention Amount" * 100 / Rec.NS_Total), 0.000000000000001)
        end;
        //PRJ-1624.NK.1.0 04Nov2022 End
        if Rec."NS_Material Retention Amount" <> 0 then
            Rec."NS_Material Retention Percent" := ROUND((Rec."NS_Material Retention Amount" / Rec."NS_Stored Materials Amount") * 100,
            GLSetup."Amount Rounding Precision")
        else
            Rec."NS_Material Retention Percent" := 0;

        if (ProgressBillingHeader."NS_Work Retention Percent" > 0) and (Rec."NS_Work Retention Percent" <> 0) then
            Rec."NS_Effective Work Retention" := ROUND(Rec.NS_Total * (ProgressBillingHeader."NS_Work Retention Percent" / 100),
                                                GLSetup."Amount Rounding Precision")
        else
            Rec."NS_Effective Work Retention" := Rec."NS_Work Retention Amount";


        if (ProgressBillingHeader."NS_Material Retention Percent" > 0) and (Rec."NS_Material Retention Percent" <> 0) then //PRJ-471.MS.1.0
            Rec."NS_EffectiveMaterialRetention" := ROUND(Rec."NS_Stored Materials Amount" *
                                                    (ProgressBillingHeader."NS_Material Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision")
        else begin
            if Rec."NS_Material Retention Percent" <> 0 then
                Rec."NS_Material Retention Amount" := ROUND(Rec."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100),
                GLSetup."Amount Rounding Precision")
            else
                Rec."NS_Material Retention Amount" := 0;
            Rec."NS_EffectiveMaterialRetention" := Rec."NS_Material Retention Amount";
        end;
        //PRJ-1648.PS.1.0 27Dec2022 Start 
        if ProgressBillingHeader."NS_R_Reduction & Invoicing" then begin
            if (ProgressBillingHeader."NS_Material Retention Percent" > 0) and (Rec."NS_Material Retention Percent" <> 0) then //PRJ-471.MS.1.0
                Rec."NS_Eff Store Work Ret Red" := ROUND(NS_LastStotrBilling(Rec) *
                                                        (ProgressBillingHeader."NS_Material Retention Percent" / 100),
                                                        GLSetup."Amount Rounding Precision")
            else begin
                if Rec."NS_Material Retention Percent" <> 0 then
                    Rec."NS_Eff Store Work Ret Red" := ROUND(Rec."NS_Stored Materials Amount" * (Rec."NS_Material Retention Percent" / 100),
                    GLSetup."Amount Rounding Precision")
                else
                    Rec."NS_Material Retention Amount" := 0;
                Rec."NS_Eff Store Work Ret Red" := Rec."NS_Material Retention Amount";
            end;
        end;
        //PRJ-1648.PS.1.0 27Dec2022 End 

        //PRJ-1648.PS.1.0 07Dec2022 Start 
        if ProgressBillingHeader."NS_R_Reduction & Invoicing" then begin
            //Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetentionReduction(Rec) - Rec."NS_Effective Work Ret Red"  //PRJ-1648.PS.1.0 07Dec2022
            //Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetention(Rec) - Rec."NS_Effective Work Ret Red" //PRJCTPR-320.NC.1.0 06Feb2024 Block
            Rec."NS_Billed Work Retention Amt" := Rec.NS_LastBilledWorkRetAmt(Rec) - Rec."NS_Effective Work Ret Red" //PRJCTPR-320.NC.1.0 06Feb2024
        end else begin
            //Rec."NS_Billed Work Retention Amt" := Rec.NS_LastWorkEffectiveRetention(Rec) - Rec."NS_Effective Work Retention"; //PRJCTPR-320.NC.1.0 06Feb2024 Block
            Rec."NS_Billed Work Retention Amt" := Rec.NS_LastBilledWorkRetAmt(Rec) - Rec."NS_Effective Work Retention"; //PRJCTPR-320.NC.1.0 06Feb2024
            Rec."NS_Billed MaterialRetentionAmt" := Rec.NS_LastMaterialEffectiveRetention(Rec) - Rec."NS_EffectiveMaterialRetention";
        end;
        //PRJ-1648.PS.1.0 07Dec2022 End

        Rec."NS_Line Amount" := Rec."NS_Work Amount" + Rec."NS_Stored Materials Amount";
        Rec."NS_Line Amount With Retention" := Rec."NS_Line Amount" - Rec."NS_Effective Work Retention" - Rec."NS_EffectiveMaterialRetention";
        Rec.MODIFY();
    end;
    //PRJ-1519.NK.1.0 15Jul2022 End
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
                //PRJCTPR-180.DK.1.0 05Sep2023 Start
                // SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
                SETFILTER("NS_Requisition No.", '<=%1', Rec."NS_Requisition No.");
                //PRJCTPR-180.DK.1.0 05Sep2023 End
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
    //PRJ-1519.NK.1.0 12Sep2022 Start
    procedure NS_LastStotrBilling(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        NS_LastStoreAmount: Decimal;
    begin
        NS_LastStoreAmount := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if ProgressBillingHeader_Loc.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.") then
                    if ProgressBillingHeader_Loc.NS_Status <> ProgressBillingHeader_Loc.NS_Status::Void then
                        NS_LastStoreAmount := ProgressBillingLine."NS_Stored Materials Amount";
            until ProgressBillingLine.NEXT() = 0;
        exit(NS_LastStoreAmount);
    end;
    //PRJ-1519.NK.1.0 12Sep2022 End

    procedure NS_LastWorkEffectiveRetention(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        NS_LastWorkEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastWorkEffectiveRetentionAmt := 0;
        //PRJ-1132.NK.1.0 Start
        //with ProgressBillingLine do begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.");
                if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                    NS_LastWorkEffectiveRetentionAmt := ProgressBillingLine."NS_Effective Work Retention";
                Clear(ProgressBillingLine."NS_Effective Work Retention");  //PRJ-1648.PS.1.0 15DEC2022
            until ProgressBillingLine.NEXT() = 0;
        //end;
        //PRJ-1132.NK.1.0 End
        exit(NS_LastWorkEffectiveRetentionAmt);
    end;


    //PRJ-1648.PS.1.0 07Dec2022 Start
    procedure NS_LastWorkEffectiveRetentionReduction(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        NS_LastWorkEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastWorkEffectiveRetentionAmt := 0;

        //with ProgressBillingLine do begin
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.");
                if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                    NS_LastWorkEffectiveRetentionAmt := ProgressBillingLine."NS_Effective Work Ret Red";
            until ProgressBillingLine.NEXT() = 0;
        //end;
        //PRJ-1132.NK.1.0 End
        exit(NS_LastWorkEffectiveRetentionAmt);
    end;

    //PRJ-1648.PS.1.0 07Dec2022 End

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

    //PRJ-999.JS.1.0  01Nov2021 - Start
    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"NS_Progress Billing Line", "NS_Progress Billing No.", FieldNumber, ShortcutDimCode);
        MODIFY();
    end;

    procedure ShowDimensions();
    begin
        //"NS_Dimension Set ID" :=
        DimMgt.EditDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2', "NS_Progress Billing No.", "NS_Requisition No.", "NS_Version No.", "NS_Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("NS_Dimension Set ID", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
    end;


    procedure GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
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
    //PRJ-999.JS.1.0   09Nov2021 - end
    /// <summary>
    /// NS_GetPreviousRetetionkunit.
    /// </summary>
    /// <param name="Rec">VAR Record "NS_Progress Billing Line".</param>
    /// <returns>Return value of type Decimal.</returns>
    /// 
    /// PRJCTPR-174.PS.1.0 10aug2023 Start
    procedure NS_GetPreviousRetetionkunit(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingHeader_Loc: Record "NS_Progress Billing Header";
        JobsSetup_Loc: Record "Jobs Setup";
        LastRetUnit: Decimal;
    begin

        LastRetUnit := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                if ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.") then
                    if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                        LastRetUnit := ProgressBillingLine."NS_Work Retention Percent";

            until ProgressBillingLine.NEXT() = 0;


        exit(LastRetUnit);

    end;
    /// PRJCTPR-174.PS.1.0 10aug2023 End 
    //PRJCTPR-320.NC.1.0 06Feb2024 Start
    procedure NS_LastBilledWorkRetAmt(var Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        NS_LastBilledWorkRetAmt: Decimal;
    begin
        NS_LastBilledWorkRetAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        ProgressBillingLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.");
                if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then
                    NS_LastBilledWorkRetAmt := ProgressBillingLine."NS_Work Retention Amount";
                Clear(ProgressBillingLine."NS_Work Retention Amount");
            until ProgressBillingLine.NEXT() = 0;
        exit(NS_LastBilledWorkRetAmt);
    end;
    //PRJCTPR-320.NC.1.0 06Feb2024 End
}

