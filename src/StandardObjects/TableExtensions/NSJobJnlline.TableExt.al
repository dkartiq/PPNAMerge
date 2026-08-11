tableextension 14021139 NS_JobJnlLine extends "Job Journal Line"
{
    // version NAVW111.00.00.23019,PPNA11.00
    //PRJ-114.SK.1.0
    //PRJ-118.SK.1.0 Added code
    //PRJ-162.SK.1.0 Added T&M functionality
    //PRJ-163.SK.1.0 Added code for Bypassing TimeSheet No.
    //PRJ-246 MS added new field   
    //PRJ-212 VT1.0 15-04-20 Code Added
    //PRJ-211 VT1.0 20-04-20 Code Added	 
    //PRJ-301.AS.1.0 Increased length from 50 to 100 chars
    //PRJ-356.MS.1.0 code comment which is not used and give error of permission
    //PRJ-268 Vikas fixed this
    //TM-10.AM.1.0 | Added Field & Code.
    //PRJ-753.SK.1.0  | Added code for bypassing currency code issue
    //PRJ-472.JS.1.0 | Add field NS_Crew Time Sheet Line,NS_Crew Code,NS_Crew Name,Crew Time Sheet Ref. No.
    //PRJ-817.JS.1.0 04Aug2021 | Add fields work unit completed
    //PRJ-841.JS.1.0 16Aug2021 | Add field Segment code
    //PRJ-842.JS.1.0 16Aug2021 | Add field Skill Code

    fields
    {
        modify(Type)
        {
            OptionCaption = 'Resource,Item,G/L Account,Ledger';

            //Unsupported feature: Change OptionString on "Type(Field 6)". Please convert manually.

        }

        //Unsupported feature: Change TableRelation on ""No."(Field 8)". Please convert manually.

        modify("Entry Type")
        {
            OptionCaption = 'Usage,Sale,Release,Earn,Payment';


            //Unsupported feature: Change OptionString on ""Entry Type"(Field 61)". Please convert manually.

        }

        modify("Job No.")
        {
            trigger OnAfterValidate();
            begin

                //ProjectPro - start
                NS_AssignPayrollWorkState;
                NS_AssignDefaultSkillClass;
                NS_CalculateWageRate;
                PopulateJobRelatedFields; //PRJ-162.SK.1.0 Added

                //ProjectPro - end    
                "NS_Segment Code" := '';//TM-10.AM.1.0                 
            end;
        }


        //Unsupported feature: CodeModification on ""Posting Date"(Field 4).OnValidate". Please convert manually.
        modify("Posting Date")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_CalculateWageRate;
                //ProjectPro - end
            end;
        }


        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                // p.T210SetTimeSheetNo(Rec."Time Sheet No."); //PRJ-163.SK.1.0 Blocked

                NS_JobsSetup.GET;
                IF Rec.Type = Rec.Type::Resource Then //PRJ-163.SK.1.0 Added
                    IF NS_JobsSetup."NS_Allow Timesheet&JobJnlPost" THEN
                        IF Rec."Time Sheet No." = '' then
                            Rec."Time Sheet No." := 'DUMY';
            end;

            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if Type = Type::"G/L Account" then begin
                    "Unit Cost (LCY)" := NS_UnitCostLCYHold;
                    VALIDATE("Unit Cost (LCY)");
                end;
                if NS_DirectCostOverride then
                    "Direct Unit Cost (LCY)" := "Unit Cost (LCY)";
                //ProjectPro - end
            end;
        }


        //Unsupported feature: CodeModification on "Quantity(Field 10).OnValidate". Please convert manually.
        modify(Quantity)
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_CalculateWageRate;

                if Type = Type::Item then begin
                    JobMatPlanning.RESET;
                    JobMatPlanning.SETRANGE(NS_Type, JobMatPlanning.NS_Type::Resource);
                    JobMatPlanning.SETRANGE("NS_Part No.", "No.");
                    if JobMatPlanning.FINDFIRST then begin
                        JobMatPlanning.VALIDATE("NS_Bal. Req");
                        JobMatPlanning.MODIFY;
                    end;
                end;
                //ProjectPro - end
            end;
        }


        //Unsupported feature: CodeModification on ""Unit Cost (LCY)"(Field 13).OnValidate". Please convert manually.
        modify("Unit Cost (LCY)")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if "Unit Cost (LCY)" <> xRec."Unit Cost (LCY)" then
                    if NS_CalculateBurden then
                        "NS_Wage Calculation Basis" := Text14021101;
                //ProjectPro - end             
            end;
        }

        //Unsupported feature: CodeModification on ""Unit of Measure Code"(Field 18).OnValidate". Please convert manually.
        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            begin
                GetGLSetup();
                CASE Type OF
                    Type::Item:
                        BEGIN
                            //"Qty. per Unit of Measure" := 1; //PRJ-114.SK.1.0 Blocked this code
                            GetJob;
                            InitRoundingPrecisions;
                            UpdateUnitCost;
                            NS_PurchPriceCalcMgt.FindJobJnlLinePrice(Rec, CurrFieldNo);
                            IF NS_DirectCostOverride THEN
                                "Direct Unit Cost (LCY)" := "Unit Cost (LCY)";
                        END;
                    Type::"G/L Account":
                        BEGIN
                            If "Unit Cost (LCY)" = "Unit Cost" then //PRJ-753.SK.1.0 Added
                                VALIDATE("Unit Cost (LCY)", "Unit Cost");
                        END;
                END;
                VALIDATE(Quantity);
            end;
        }

        //Unsupported feature: CodeModification on ""Work Type Code"(Field 33).OnValidate". Please convert manually.
        modify("Work Type Code")
        {
            trigger OnAfterValidate()
            begin
                //ProjectPro - start
                //VALIDATE(Quantity); //SPLN: this line of code will be executed before 
                NS_CalculateWageRate;
                //ProjectPro - end
            end;
        }

        //Unsupported feature: PropertyDeletion on ""Entry Type"(Field 61)". Please convert manually.

        //Unsupported feature: CodeModification on ""Job Task No."(Field 1000).OnValidate". Please convert manually.
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            var
                JobTask: Record "Job Task";
                NextDimSetID: Integer;
                NS_DimensionsUpdated: Boolean;
                NS_TempDimSetEntry: Record "Dimension Set Entry" temporary; //PRJ-118.SK.1.0 Added Temporary
            begin
                //ProjectPro - start
                NS_AssignDefaultSkillClass;
                NS_CalculateWageRate;
                NS_DimensionsUpdated := FALSE;
                NS_DimensionSetEntry.RESET;
                NS_DimensionSetEntry.SETRANGE("Dimension Set ID", "Dimension Set ID");
                IF NS_DimensionSetEntry.FINDSET THEN
                    REPEAT
                        NS_TempDimSetEntry := NS_DimensionSetEntry;
                        NS_TempDimSetEntry.INSERT;
                    UNTIL NS_DimensionSetEntry.NEXT = 0;

                NS_JobTaskDimension.RESET;
                NS_JobTaskDimension.SETRANGE("Job No.", "Job No.");
                NS_JobTaskDimension.SETRANGE("Job Task No.", "Job Task No.");
                IF NS_JobTaskDimension.FINDSET THEN
                    REPEAT
                        IF NS_JobTaskDimension."Dimension Code" <> '' THEN BEGIN
                            NS_TempDimSetEntry.SETRANGE("Dimension Code", NS_JobTaskDimension."Dimension Code");
                            IF NS_TempDimSetEntry.FINDFIRST THEN BEGIN
                                IF NS_TempDimSetEntry."Dimension Value Code" <> NS_JobTaskDimension."Dimension Value Code" THEN BEGIN
                                    NS_TempDimSetEntry.VALIDATE("Dimension Value Code", NS_JobTaskDimension."Dimension Value Code");
                                    NS_TempDimSetEntry.MODIFY(TRUE);
                                    NS_DimensionsUpdated := TRUE;
                                END;
                            END ELSE BEGIN
                                NS_TempDimSetEntry.INIT;
                                NS_TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
                                NS_TempDimSetEntry.VALIDATE("Dimension Code", NS_JobTaskDimension."Dimension Code");
                                NS_TempDimSetEntry.VALIDATE("Dimension Value Code", NS_JobTaskDimension."Dimension Value Code");
                                NS_TempDimSetEntry.INSERT(TRUE);
                                NS_DimensionsUpdated := TRUE;
                            END;
                        END;
                    UNTIL NS_JobTaskDimension.NEXT = 0;

                IF NS_DimensionsUpdated THEN BEGIN
                    "Dimension Set ID" := DimMgt.GetDimensionSetID(NS_TempDimSetEntry);
                    DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                END;
                //ProjectPro - end
            end;
        }

        //Unsupported feature: CodeModification on ""Unit Cost"(Field 1011).OnValidate". Please convert manually.
        modify("Unit Cost")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if "Unit Cost" <> xRec."Unit Cost" then
                    if NS_CalculateBurden then
                        "NS_Wage Calculation Basis" := Text14021101;
                //ProjectPro - end
            end;
        }

        //Unsupported feature: CodeModification on ""Variant Code"(Field 5402).OnValidate". Please convert manually.
        modify("Variant Code")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if NS_DirectCostOverride then
                    "Direct Unit Cost (LCY)" := "Unit Cost (LCY)";
                //ProjectPro - end
                Validate(Quantity); //SPLN1.00
            end;
        }

        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                JobCostCategoryRec: Record "NS_Job Cost Category";
            begin
                //ProjectPro - start
                if JobCostCategoryRec.GET("NS_Job Cost Category") then
                    if JobCostCategoryRec."NS_Activity Code" <> '' then
                        Validate("Job Task No.", JobCostCategoryRec."NS_Activity Code");//PRJ-212 VT1.0 15-04-20 end
                if JobCostCategoryRec."NS_G/L Account No." <> '' then begin
                    //PRJ-212 VT1.0 15-04-20 Begin
                    if (Type = Type::"G/L Account") and ("No." <> JobCostCategoryRec."NS_G/L Account No.") then begin //PRJ-268 VT1.0 18-05-20
                        VALIDATE(Type, Type::"G/L Account");
                        VALIDATE("No.", JobCostCategoryRec."NS_G/L Account No.");
                    end;//PRJ-268 VT1.0 18-05-20
                end else begin
                    //PRJ-212 VT1.0 15-04-20 end
                    Validate("Unit Cost");
                end;
                //ProjectPro - end
            end;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Cost-Revenue Type"; Option)
        {
            Caption = 'Cost-Revenue Type';
            Description = 'ProjectPro';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Cost Factor Set By Category"; Boolean)
        {
            Caption = 'Cost Factor Set By Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021120; "NS_External Relationship Type"; Option)
        {
            Caption = 'External Relationship Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(14021121; "NS_External Relationship No."; Code[20])
        {
            Caption = 'External Relationship No.';
            Description = 'ProjectPro';
            TableRelation = IF ("NS_External Relationship Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("NS_External Relationship Type" = CONST(Vendor)) Vendor."No.";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Cust: Record Customer;
            begin
                //ProjectPro - start
                if ("NS_External Relationship No." > '') and ("NS_External Relationship Type" = 0) then
                    ERROR(Text14021100, FIELDCAPTION("NS_External Relationship Type"));

                if "NS_External Relationship No." > '' then begin
                    "NS_External Relationship Name" := '';
                    case "NS_External Relationship Type" of
                        "NS_External Relationship Type"::Customer:
                            if Cust.GET("NS_External Relationship No.") then
                                "NS_External Relationship Name" := Cust.Name;
                        "NS_External Relationship Type"::Vendor:
                            if NS_Vendor.GET("NS_External Relationship No.") then
                                "NS_External Relationship Name" := NS_Vendor.Name;
                    end;

                end;
                //ProjectPro - end
            end;
        }
        field(14021122; "NS_External Relationship Name"; Text[100])//PRJ-301.AS.1.0 Increased length from 50 to 100 chars
        {
            Caption = 'External Relationship Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Employee Wage Rate"; Decimal)
        {
            Caption = 'Employee Wage Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Employee Fringe - Insurance"; Decimal)
        {
            Caption = 'Employee Fringe - Insurance';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_Employee Fringe - Vacation"; Decimal)
        {
            Caption = 'Employee Fringe - Vacation';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Employee Fringe - Education"; Decimal)
        {
            Caption = 'Employee Fringe - Education';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021139; "NS_Employee Fringe - Misc. 1"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 1';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Employee Fringe - Misc. 2"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 2';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Employee Fringe - Misc. 3"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 3';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Employee Fringe Total"; Decimal)
        {
            Caption = 'Employee Fringe Total';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_Prevailing Wage Rate"; Decimal)
        {
            Caption = 'Prevailing Wage Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021144; "NS_Prevailing Fringe Rate"; Decimal)
        {
            Caption = 'Prevailing Fringe Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_Wage Calculation Basis"; Text[80])
        {
            Caption = 'Wage Calculation Basis';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Balance Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance Cost ($)';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            Editable = false;
        }
        field(14021151; "NS_Balance Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Balance Cost ($)';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Burden Amount"; Decimal)
        {
            Caption = 'Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Burden Amount" <> 0 then begin
                    NS_JobsSetup.GET;
                    "NS_Burden Job Cost Category" := NS_JobsSetup."NS_Burden Job Cost Category";
                end;
                //ProjectPro - end
            end;
        }
        field(14021153; "NS_Burden Job Cost Category"; Code[10])
        {
            Caption = 'Burden Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Payroll Burden Amount"; Decimal)
        {
            Caption = 'Payroll Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Payroll Burden Amount" <> 0 then begin
                    NS_JobsSetup.GET;
                    "NS_Payroll Burden Job Cost Cat" := NS_JobsSetup."NS_Payroll Burden Job Cost Cat";
                end;
                //ProjectPro - end
            end;
        }
        field(14021155; "NS_Payroll Burden Job Cost Cat"; Code[10])
        {
            Caption = 'Payroll Burden Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021186; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                //UpdateAllAmountsExt; //PRJ-9.SK.1.0 Commented
                NS_CalculateWageRate;
                //ProjectPro - end
            end;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021375; "NS_Payroll Work State"; Text[30])
        {
            Caption = 'Payroll Work State';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021376; "NS_Jobsite Work"; Boolean)
        {
            Caption = 'Jobsite Work';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_AssignPayrollWorkState;
                //ProjectPro - end
            end;
        }
        field(14021400; NS_Staged; Boolean)
        {
            Caption = 'Staged';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021401; "NS_Purch. Receipt Doc. No."; Code[20])
        {
            Caption = 'Purch. Receipt Doc. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Purch. Receipt Line No."; Integer)
        {
            Caption = 'Purch. Receipt Line No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Box Ref."; Text[10])
        {
            Caption = 'Box Ref.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Adj. entry"; Boolean)
        {
            Description = 'PRJ-246.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021383; "NS_FA Res.No."; Code[20])
        {
            Caption = 'FA Res. No.';
            Description = 'PRJ-490';
            DataClassification = CustomerContent;
        }
        field(14021384; "NS_Crew Time Sheet Line"; Boolean)      //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Time Sheet Line';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021385; "NS_Crew Code"; Code[20])               //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021386; "NS_Crew Name"; Text[50])               //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Name';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021387; "NS_Crew Time Sheet Ref. No."; Code[20])     //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Time Sheet Ref. No.';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021388; "NS_Crew Time Unique Line ID"; Code[20])     //PRJ-772.JS.1.0 26JULY2021
        {
            Caption = 'Crew Time Unique Line ID';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021189; "NS_Crew Time Sheet Date"; Date)
        {
            Caption = 'Crew Time Sheet Date';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021421; "NS_Work Unit Completed"; Decimal)   //PRJ-817.JS.1.0�04Aug2021-end  
        {
            Caption = 'Work Unit Completed';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }

        field(14021422; "NS_Skill Code"; Code[10])   //PRJ-842.JS.1.0 16Aug2021-start Length with 10 chars
        {
            Caption = 'Skill Code';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }


    trigger OnDelete();
    var
        PurchRcptLine: Record 121;
    begin
        //ProjectPro - start
        if Type = Type::Item then begin
            JobMatPlanning.RESET;
            JobMatPlanning.SETRANGE(NS_Type, JobMatPlanning.NS_Type::Resource);
            JobMatPlanning.SETRANGE("NS_Part No.", "No.");
            if JobMatPlanning.FINDFIRST then begin
                JobMatPlanning.VALIDATE("NS_Bal. Req");
                JobMatPlanning.MODIFY;
            end;
            //PRJ-356.MS.1.0 start comment
            //PurchRcptLine.RESET;
            // PurchRcptLine.SETRANGE("Job No.", "Job No.");
            // PurchRcptLine.SETRANGE("Job Task No.", "Job Task No.");
            // PurchRcptLine.SETRANGE(NS_Staged, true);
            // PurchRcptLine.SETRANGE("NS_JMP Document No.", "Document No.");
            // PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
            // PurchRcptLine.SETRANGE("No.", "No.");
            // if PurchRcptLine.FINDFIRST then begin
            //     PurchRcptLine."NS_Journal Status" := PurchRcptLine."NS_Journal Status"::" ";
            //     PurchRcptLine.MODIFY;
            // end;
            //PRJ-356.MS.1.0 end comment
        end;
        //ProjectPro - end
    end;

    var
        NS_Job: Record Job;
        NS_DirectCostOverride: Boolean;
        NS_UnitCostLCYHold: Decimal;
        NS_PurchPriceCalcMgt: Codeunit 7010;
        NS_Vendor: Record Vendor;
        NS_JobsSetup: Record "Jobs Setup";
        NS_EmployeeBurdenDetail: Record "NS_Employee Burden Detail";
        NS_Employee: Record Employee;
        NS_JobResourcePrice: Record "Job Resource Price";
        NS_EmployeeWageRate: Record "NS_Employee Wage Rate";
        NS_Resource: Record Resource;
        NS_DimensionSetEntry: Record "Dimension Set Entry";
        NS_JobTaskDimension: Record "Job Task Dimension";
        JobMatPlanning: Record "NS_Job Material Planning";
        Text14021100: Label '%1 cannot be blank.';
        Text14021101: Label 'Wage Rate (Unit Cost) entered by user.';
        Text000: Label 'You cannot change %1 when %2 is %3.';
        Job: Record Job;
        UnitAmountRoundingPrecision: Decimal;
        AmountRoundingPrecision: Decimal;
        UnitAmountRoundingPrecisionFCY: Decimal;
        AmountRoundingPrecisionFCY: Decimal;
        Item: Record Item;
        CurrExchRate: Record "Currency Exchange Rate";
        SKU: Record "Stockkeeping Unit";
        ResCost: Record "Resource Cost";
        GLSetup: Record "General Ledger Setup";
        HasGotGLSetup: Boolean;
        DimMgt: Codeunit DimensionManagement;
        p: Codeunit "NS_Parameters for Table Events";

    LOCAL procedure InitRoundingPrecisions()
    var
        Currency: Record Currency;
    begin
        IF (AmountRoundingPrecision = 0) OR
           (UnitAmountRoundingPrecision = 0) OR
           (AmountRoundingPrecisionFCY = 0) OR
           (UnitAmountRoundingPrecisionFCY = 0)
        THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

            IF "Currency Code" <> '' THEN BEGIN
                Currency.GET("Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
                Currency.TESTFIELD("Unit-Amount Rounding Precision");
            END;
            AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
        END;
    end;

    LOCAL procedure GetGLSetup()
    begin
        IF HasGotGLSetup THEN
            EXIT;
        GLSetup.GET;
        HasGotGLSetup := TRUE;
    end;

    LOCAL procedure GetJob()
    begin
        TESTFIELD("Job No.");
        IF "Job No." <> Job."No." THEN
            Job.GET("Job No.");
    end;

    LOCAL procedure RetrieveCostPrice(): Boolean
    begin
        CASE Type OF
            Type::Item:
                IF ("No." <> xRec."No.") OR
                   ("Location Code" <> xRec."Location Code") OR
                   ("Variant Code" <> xRec."Variant Code") OR
                   (Quantity <> xRec.Quantity) OR
                   ("Unit of Measure Code" <> xRec."Unit of Measure Code") AND
                   (("Applies-to Entry" = 0) AND ("Applies-from Entry" = 0))
                THEN
                    EXIT(TRUE);
            Type::Resource:
                IF ("No." <> xRec."No.") OR
                   ("Work Type Code" <> xRec."Work Type Code") OR
                   //ProjectPro - start
                   ("NS_Skill Class" <> xRec."NS_Skill Class") OR
                   (Quantity <> xRec.Quantity) OR
                   //ProjectPro - end
                   ("Unit of Measure Code" <> xRec."Unit of Measure Code")
                THEN
                    EXIT(TRUE);
            Type::"G/L Account":
                IF "No." <> xRec."No." THEN
                    EXIT(TRUE);
            ELSE
                EXIT(FALSE);
        END;
        EXIT(FALSE);
    end;

    LOCAL procedure GetSKU(): Boolean
    begin
        IF (SKU."Location Code" = "Location Code") AND
       (SKU."Item No." = "No.") AND
       (SKU."Variant Code" = "Variant Code")
    THEN
            EXIT(TRUE);

        IF SKU.GET("Location Code", "No.", "Variant Code") THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    LOCAL procedure UpdateUnitCost()
    var
        RetrievedCost: Decimal;
        Res: Record Resource;
    begin
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
            IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                //PRJ-9.SK.1.0 Start
                // IF NOT Rec.GetDontCheckStdCost THEN BEGIN
                //     // Prevent manual change of unit cost on items with standard cost
                //     IF (("Unit Cost" <> xRec."Unit Cost") OR ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")) AND
                //        (("No." = xRec."No.") AND ("Location Code" = xRec."Location Code") AND
                //         ("Variant Code" = xRec."Variant Code") AND ("Unit of Measure Code" = xRec."Unit of Measure Code"))
                //     THEN
                //         ERROR(
                //           Text000,
                //           FIELDCAPTION("Unit Cost"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method");
                // END;
                //PRJ-9.SK.1.0 End

                IF RetrieveCostPrice THEN BEGIN
                    IF GetSKU THEN
                        "Unit Cost (LCY)" := ROUND(SKU."Unit Cost" * "Qty. per Unit of Measure", UnitAmountRoundingPrecision)
                    ELSE
                        "Unit Cost (LCY)" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure", UnitAmountRoundingPrecision);
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Posting Date", "Currency Code",
                          "Unit Cost (LCY)", "Currency Factor"),
                        UnitAmountRoundingPrecisionFCY);
                END ELSE BEGIN
                    IF "Unit Cost" <> xRec."Unit Cost" THEN
                        "Unit Cost (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              "Posting Date", "Currency Code",
                              "Unit Cost", "Currency Factor"),
                            UnitAmountRoundingPrecision)
                    ELSE
                        "Unit Cost" := ROUND(
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              "Posting Date", "Currency Code",
                              "Unit Cost (LCY)", "Currency Factor"),
                            UnitAmountRoundingPrecisionFCY);
                END;
            END ELSE BEGIN
                IF RetrieveCostPrice THEN BEGIN
                    IF GetSKU THEN
                        RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
                    ELSE
                        RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Posting Date", "Currency Code",
                          RetrievedCost, "Currency Factor"),
                        UnitAmountRoundingPrecisionFCY);
                    "Unit Cost (LCY)" := ROUND(RetrievedCost, UnitAmountRoundingPrecision);
                END ELSE
                    "Unit Cost (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                        UnitAmountRoundingPrecision);
            END;
        END ELSE
            IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
                IF RetrieveCostPrice THEN BEGIN
                    ResCost.INIT;
                    ResCost.Code := "No.";
                    ResCost."Work Type Code" := "Work Type Code";
                    //ProjectPro - start
                    ResCost."NS_Job No." := "Job No.";
                    ResCost."NS_Job Task No." := "Job Task No.";
                    ResCost."NS_Currency Code" := "Currency Code";
                    //ProjectPro - end
                    CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost", ResCost);
                    "Direct Unit Cost (LCY)" := ROUND(ResCost."Direct Unit Cost" * "Qty. per Unit of Measure", UnitAmountRoundingPrecision);
                    RetrievedCost := ResCost."Unit Cost" * "Qty. per Unit of Measure";
                    "Unit Cost" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Posting Date", "Currency Code",
                          RetrievedCost, "Currency Factor"),
                        UnitAmountRoundingPrecisionFCY);
                    "Unit Cost (LCY)" := ROUND(RetrievedCost, UnitAmountRoundingPrecision);
                END ELSE
                    "Unit Cost (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          "Posting Date", "Currency Code",
                          "Unit Cost", "Currency Factor"),
                        UnitAmountRoundingPrecision);
            END ELSE
                "Unit Cost (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Posting Date", "Currency Code",
                      "Unit Cost", "Currency Factor"),
                    UnitAmountRoundingPrecision);
    end;

    LOCAL procedure UpdateTotalCost()
    begin
        "Total Cost" := ROUND("Unit Cost" * Quantity, AmountRoundingPrecisionFCY);
        "Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Posting Date", "Currency Code", "Total Cost", "Currency Factor"), AmountRoundingPrecision);
    end;

    LOCAL procedure HandleCostFactor()
    begin
        //ProjectPro - start
        //IF ("Cost Factor" <> 0) AND
        //   ((("Unit Cost" <> xRec."Unit Cost") OR ("Cost Factor" <> xRec."Cost Factor")) OR
        //    ((Quantity <> xRec.Quantity) OR ("Location Code" <> xRec."Location Code")))
        // THEN
        UpdateCostFactor; //PRJ-158/159 VT 26-03-20

        if Type = Type::Resource then//PRJ-158/159 VT 26-03-20
            UpdateUnitPrice()//PRJ-158/159 VT 26-03-20
        else begin//PRJ-158/159 VT 26-03-20
            IF ("Cost Factor" <> 0) THEN
                //ProjectPro - end
                "Unit Price" := ROUND("Unit Cost" * "Cost Factor", UnitAmountRoundingPrecisionFCY)
            ELSE
                IF (Item."Price/Profit Calculation" = Item."Price/Profit Calculation"::"Price=Cost+Profit") AND
                   (Item."Profit %" < 100) AND
                   ("Unit Cost" <> xRec."Unit Cost")
                THEN
                    "Unit Price" := ROUND("Unit Cost" / (1 - Item."Profit %" / 100), UnitAmountRoundingPrecisionFCY);

        end;
    end;

    LOCAL procedure UpdateUnitPrice()
    begin
        "Unit Price (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Posting Date", "Currency Code",
              "Unit Price", "Currency Factor"),
            UnitAmountRoundingPrecision);
    end;

    LOCAL procedure UpdateTotalPrice()
    begin
        "Total Price" := ROUND(Quantity * "Unit Price", AmountRoundingPrecisionFCY);
        "Total Price (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Posting Date", "Currency Code", "Total Price", "Currency Factor"), AmountRoundingPrecision);
    end;

    LOCAL procedure UpdateAmountsAndDiscounts()
    begin
        IF "Total Price" <> 0 THEN BEGIN
            IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
                "Line Amount" := ROUND("Line Amount", AmountRoundingPrecisionFCY);
                "Line Discount Amount" := "Total Price" - "Line Amount";
                "Line Amount (LCY)" := ROUND("Line Amount (LCY)", AmountRoundingPrecision);
                "Line Discount Amount (LCY)" := "Total Price (LCY)" - "Line Amount (LCY)";
                "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100, 0.00001);
            END ELSE
                IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
                    "Line Discount Amount" := ROUND("Line Discount Amount", AmountRoundingPrecisionFCY);
                    "Line Amount" := "Total Price" - "Line Discount Amount";
                    "Line Discount Amount (LCY)" := ROUND("Line Discount Amount (LCY)", AmountRoundingPrecision);
                    "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
                    "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100, 0.00001);
                END ELSE
                    IF ("Line Discount Amount" <> xRec."Line Discount Amount") OR ("Line Amount" <> xRec."Line Amount") OR
                       ("Total Price" <> xRec."Total Price") OR ("Line Discount %" <> xRec."Line Discount %")
                    THEN BEGIN
                        "Line Discount Amount" := ROUND("Total Price" * "Line Discount %" / 100, AmountRoundingPrecisionFCY);
                        "Line Amount" := "Total Price" - "Line Discount Amount";
                        "Line Discount Amount (LCY)" := ROUND("Total Price (LCY)" * "Line Discount %" / 100, AmountRoundingPrecision);
                        "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
                    END;
        END ELSE BEGIN
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
            "Line Amount (LCY)" := 0;
            "Line Discount Amount (LCY)" := 0;
        END;
    end;

    PROCEDURE NS_CalculateWageRate();
    VAR
        NS_EmployeeWageRate: Record "NS_Employee Wage Rate";
        HRSetup: Record 5218;
    BEGIN
        //ProjectPro - start
        IF HRSetup.GET AND HRSetup."NS_Advanced Job Labor isActive" THEN
            IF "Posting Date" <> 0D THEN
                IF "Job No." <> '' THEN
                    IF Type = Type::Resource THEN
                        IF "No." <> '' THEN BEGIN
                            NS_EmployeeWageRate.NS_CalculateWagesJobJournal(Rec);

                            InitRoundingPrecisions;
                            UpdateTotalCost;
                            HandleCostFactor;
                            UpdateUnitPrice;
                            UpdateTotalPrice;
                            UpdateAmountsAndDiscounts;

                            IF NS_CalculateBurden THEN;
                        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_CalculateBurden(): Boolean;
    BEGIN
        //ProjectPro - start
        IF "Posting Date" <> 0D THEN
            IF "Job No." <> '' THEN
                IF Type = Type::Resource THEN
                    IF "No." <> '' THEN BEGIN
                        "NS_Payroll Burden Amount" := NS_EmployeeBurdenDetail.NS_CalculateBurden("No.", "Unit Cost", Quantity, "Posting Date");
                        NS_JobsSetup.GET;
                        "NS_Payroll Burden Job Cost Cat" := NS_JobsSetup."NS_Payroll Burden Job Cost Cat";
                        EXIT(TRUE);
                    END;
        EXIT(FALSE);
        //ProjectPro - end
    END;

    PROCEDURE NS_CopyJobJnlLineToCrewMembers();
    VAR
        NS_CopyJobJnlLinesForCrew: Report "NS_Copy Job Jnl lines for Crew";
        NS_JobJnlLineToCopy: Record 210;
    BEGIN
        //ProjectPro - start
        TESTFIELD(Type, Type::Resource);
        CLEAR(NS_CopyJobJnlLinesForCrew);
        NS_JobJnlLineToCopy.RESET;
        NS_JobJnlLineToCopy.SETRANGE("Journal Template Name", "Journal Template Name");
        NS_JobJnlLineToCopy.SETRANGE("Journal Batch Name", "Journal Batch Name");
        NS_JobJnlLineToCopy.SETRANGE("Line No.", "Line No.");
        NS_CopyJobJnlLinesForCrew.SETTABLEVIEW(NS_JobJnlLineToCopy);
        NS_CopyJobJnlLinesForCrew.RUNMODAL;
        //ProjectPro - end
    END;

    PROCEDURE NS_AssignDefaultSkillClass();
    BEGIN
        //ProjectPro - start
        IF Type = Type::Resource THEN
            IF "No." <> '' THEN BEGIN
                NS_Employee.RESET;
                NS_Employee.SETCURRENTKEY("Resource No.");
                NS_Employee.SETRANGE("Resource No.", "No.");
                IF NS_Employee.FINDFIRST THEN
                    NS_EmployeeWageRate.RESET;
                NS_EmployeeWageRate.SETRANGE("NS_Employee No.", NS_Employee."No.");
                NS_EmployeeWageRate.SETFILTER("NS_Effective Date", '..%1', "Posting Date");
                NS_EmployeeWageRate.SETFILTER("NS_Skill Class", '<>%1', '');
                IF NS_EmployeeWageRate.FINDFIRST THEN
                    "NS_Skill Class" := NS_EmployeeWageRate."NS_Skill Class";
            END;

        IF "Job No." <> '' THEN
            IF Type = Type::Resource THEN
                IF "No." <> '' THEN BEGIN
                    //Match on Job Task No.,Type=Resource,Code=Resource No.
                    NS_JobResourcePrice.RESET;
                    NS_JobResourcePrice.SETRANGE("Job No.", "Job No.");
                    NS_JobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                    NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::Resource);
                    NS_JobResourcePrice.SETRANGE(Code, "No.");
                    IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                        IF NS_JobResourcePrice."NS_Skill Class Code" <> '' THEN
                            "NS_Skill Class" := NS_JobResourcePrice."NS_Skill Class Code";
                    END ELSE BEGIN
                        //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.
                        NS_JobResourcePrice.SETRANGE("Job Task No.", '');
                        IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                            IF NS_JobResourcePrice."NS_Skill Class Code" <> '' THEN
                                "NS_Skill Class" := NS_JobResourcePrice."NS_Skill Class Code";
                        END ELSE BEGIN
                            IF NS_Resource.GET("No.") THEN
                                IF NS_Resource."Resource Group No." <> '' THEN BEGIN
                                    //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.
                                    NS_JobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                                    NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::"Group(Resource)");
                                    NS_JobResourcePrice.SETRANGE(Code, NS_Resource."Resource Group No.");
                                    IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                        IF NS_JobResourcePrice."NS_Skill Class Code" <> '' THEN
                                            "NS_Skill Class" := NS_JobResourcePrice."NS_Skill Class Code";
                                    END ELSE BEGIN
                                        //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.
                                        NS_JobResourcePrice.SETRANGE("Job Task No.", '');
                                        IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                            IF NS_JobResourcePrice."NS_Skill Class Code" <> '' THEN
                                                "NS_Skill Class" := NS_JobResourcePrice."NS_Skill Class Code";
                                        END
                                    END;
                                END;
                        END;
                    END;
                END;
        //ProjectPro - end
    END;

    PROCEDURE NS_AssignPayrollWorkState();
    BEGIN
        //ProjectPro - start
        IF "NS_Jobsite Work" THEN BEGIN
            IF NS_Job.GET("Job No.") THEN
                IF NS_Job."NS_Job County" <> '' THEN
                    "NS_Payroll Work State" := NS_Job."NS_Job County";
        END ELSE BEGIN
            IF Type = Type::Resource THEN
                IF "No." <> '' THEN BEGIN
                    NS_Employee.RESET;
                    NS_Employee.SETCURRENTKEY("Resource No.");
                    NS_Employee.SETRANGE("Resource No.", "No.");
                    IF NS_Employee.FINDFIRST THEN
                        IF NS_Employee."NS_Default Work State" <> '' THEN
                            "NS_Payroll Work State" := NS_Employee."NS_Default Work State";
                END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE GetPurchReceiptLines();
    BEGIN
    END;

    PROCEDURE UpdateCostFactor();
    VAR
        JobCostCategoryPrice: Record "NS_Job Cost Category Price";
        JobItemPrice: Record 1013;
        JobResourcePrice: Record 1012;
        JobGLPrice: Record 1014;
    BEGIN
        //ProjectPro - start
        "Cost Factor" := 0;
        JobCostCategoryPrice.RESET;
        JobCostCategoryPrice.SETRANGE("NS_Job No.", "Job No.");
        JobCostCategoryPrice.SETRANGE("NS_Cost Category Code", "NS_Job Cost Category");
        IF JobCostCategoryPrice.FINDFIRST THEN BEGIN
            "Cost Factor" := JobCostCategoryPrice."NS_Unit Cost Factor";
            "NS_Cost Factor Set By Category" := TRUE;
        END;
        CASE Type OF
            Type::Item:
                BEGIN
                    JobItemPrice.RESET;
                    JobItemPrice.SETRANGE("Job No.", "Job No.");
                    JobItemPrice.SETRANGE("Item No.", "No.");
                    JobItemPrice.SETRANGE("Job Task No.", "Job Task No.");
                    IF JobItemPrice.FINDFIRST THEN BEGIN
                        "Cost Factor" := JobItemPrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := FALSE;
                    END ELSE BEGIN
                        JobItemPrice.RESET;
                        JobItemPrice.SETRANGE("Job No.", "Job No.");
                        JobItemPrice.SETRANGE("Item No.", "No.");
                        IF JobItemPrice.FINDFIRST THEN BEGIN
                            "Cost Factor" := JobItemPrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := FALSE;
                        END;
                    END;
                END;
            Type::Resource:
                BEGIN
                    //UpdateUnitPriceFromJobResPrice(Rec);//PRJ-158/159 VT 26-03-20//PRJ-571 comment
                    //exit; //PRJ-158/159 VT 26-03-20
                    JobResourcePrice.RESET;
                    JobResourcePrice.SETRANGE("Job No.", "Job No.");
                    JobResourcePrice.SETRANGE(Code, "No.");
                    JobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                    IF "Work Type Code" <> '' THEN
                        JobResourcePrice.SETRANGE("Work Type Code", "Work Type Code");
                    IF JobResourcePrice.FINDFIRST THEN BEGIN
                        "Cost Factor" := JobResourcePrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := FALSE;
                        //"Unit Price" := JobResourcePrice."Unit Price"; //PRJ-158/159 VT 26-03-20//PRJ-571 comment
                    END ELSE BEGIN
                        JobResourcePrice.RESET;
                        JobResourcePrice.SETRANGE("Job No.", "Job No.");
                        JobResourcePrice.SETRANGE(Code, "No.");
                        IF "Work Type Code" <> '' THEN
                            JobResourcePrice.SETRANGE("Work Type Code", "Work Type Code");
                        IF JobResourcePrice.FINDFIRST THEN BEGIN
                            "Cost Factor" := JobResourcePrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := FALSE;
                            //"Unit Price" := JobResourcePrice."Unit Price"; //PRJ-158/159 VT 26-03-20//PRJ-571 comment
                        END ELSE BEGIN
                            JobResourcePrice.RESET;
                            JobResourcePrice.SETRANGE("Job No.", "Job No.");
                            JobResourcePrice.SETRANGE(Code, "Resource Group No.");
                            IF "Work Type Code" <> '' THEN
                                JobResourcePrice.SETRANGE("Work Type Code", "Work Type Code");
                            IF JobResourcePrice.FINDFIRST THEN BEGIN
                                "Cost Factor" := JobResourcePrice."Unit Cost Factor";
                                "NS_Cost Factor Set By Category" := FALSE;
                                //"Unit Price" := JobResourcePrice."Unit Price"; //PRJ-158/159 VT 26-03-20//PRJ-571 comment
                            END;
                        END;
                    END;
                END;
            Type::"G/L Account":
                BEGIN
                    JobGLPrice.RESET;
                    JobGLPrice.SETRANGE("Job No.", "Job No.");
                    JobGLPrice.SETRANGE("G/L Account No.", "No.");
                    JobGLPrice.SETRANGE("Job Task No.", "Job Task No.");
                    IF JobGLPrice.FINDFIRST THEN BEGIN
                        "Cost Factor" := JobGLPrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := FALSE;
                    END ELSE BEGIN
                        JobGLPrice.RESET;
                        JobGLPrice.SETRANGE("Job No.", "Job No.");
                        JobGLPrice.SETRANGE("G/L Account No.", "No.");
                        IF JobGLPrice.FINDFIRST THEN BEGIN
                            "Cost Factor" := JobGLPrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := FALSE;
                        END;
                    END;
                END;
        END;
        //ProjectPro - end
    END;

    //PRj-162.SK.1.0 Start
    //PRJ-72 VT 06-03-20 End
    procedure InitRoundingPrecisionsPP(var AmountRoundingPrecision: Decimal; var AmountRoundingPrecisionFCY: Decimal; var UnitAmountRoundingPrecision: Decimal; var UnitAmountRoundingPrecisionFCY: Decimal)
    var
        Currency: Record Currency;
    begin
        if (AmountRoundingPrecision = 0) or
           (UnitAmountRoundingPrecision = 0) or
           (AmountRoundingPrecisionFCY = 0) or
           (UnitAmountRoundingPrecisionFCY = 0)
        then begin
            Clear(Currency);
            Currency.InitRoundingPrecision;
            AmountRoundingPrecision := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

            if "Currency Code" <> '' then begin
                Currency.Get("Currency Code");
                Currency.TestField("Amount Rounding Precision");
                Currency.TestField("Unit-Amount Rounding Precision");
            end;

            AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
            UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
        end;
    end;
    //PRJ-72 VT 06-03-20 End
    procedure PopulateJobRelatedFields()
    var
        NS_Job: Record job;
    begin
        IF NS_Job.Get(Rec."Job No.") then begin
            Validate("Line Type", NS_Job."NS_Line Type");
            //Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group");//PRJ-211 VT1.0 20-04-20 //PRJ-831.AS.1.0 12OCT2021 Comment old
            Validate("Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New");//PRJ-211 VT1.0 20-04-20 //PRJ-831.AS.1.0 12OCT2021 Add New
        end;
    end;
    //PRj-162.SK.1.0 End

    //PRJ-158/159 VT 26-03-20 begin
    local procedure UpdateUnitPriceFromJobResPrice(var JobJnlLine: Record "Job Journal Line")
    var
        myInt: Integer;
        JobResourcePrice: Record "Job Resource Price";
        Resource: Record Resource;
    begin
        if JobJnlLine.Type = JobJnlLine.Type::Resource then
            if JobJnlLine."No." <> '' then begin

                if JobJnlLine."Job No." <> '' then begin
                    //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                    JobResourcePrice.RESET;
                    JobResourcePrice.SETRANGE("Job No.", JobJnlLine."Job No.");
                    JobResourcePrice.SETRANGE("Job Task No.", JobJnlLine."Job Task No.");
                    JobResourcePrice.SETRANGE(Type, JobResourcePrice.Type::Resource);
                    JobResourcePrice.SETRANGE(Code, JobJnlLine."No.");
                    JobResourcePrice.SETRANGE("Work Type Code", JobJnlLine."Work Type Code");
                    JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                    if JobResourcePrice.FINDFIRST then begin
                        JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";

                    end else begin
                        //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                        JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                        if JobResourcePrice.FINDFIRST then begin
                            JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                        end else begin
                            //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                            JobResourcePrice.SETRANGE("Job Task No.", '');
                            JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                            if JobResourcePrice.FINDFIRST then begin
                                JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                            end else begin
                                //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                                JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                if JobResourcePrice.FINDFIRST then begin
                                    JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                                end else begin
                                    if Resource.GET(JobJnlLine."No.") then
                                        if Resource."Resource Group No." <> '' then begin
                                            //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                            JobResourcePrice.SETRANGE("Job Task No.", JobJnlLine."Job Task No.");
                                            JobResourcePrice.SETRANGE(Type, JobResourcePrice.Type::"Group(Resource)");
                                            JobResourcePrice.SETRANGE(Code, Resource."Resource Group No.");
                                            JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                                            if JobResourcePrice.FINDFIRST then begin
                                                JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                                            end else begin
                                                //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                                if JobResourcePrice.FINDFIRST then begin
                                                    JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                                                end else begin
                                                    //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                                    JobResourcePrice.SETRANGE("Job Task No.", '');
                                                    JobResourcePrice.SETRANGE("NS_Skill Class Code", JobJnlLine."NS_Skill Class");
                                                    if JobResourcePrice.FINDFIRST then begin
                                                        JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                                                    end else begin
                                                        //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                        JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                                        if JobResourcePrice.FINDFIRST then begin
                                                            JobJnlLine."Unit Price" := JobResourcePrice."Unit Price";
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
    end;
    //PRJ-158/159 VT 26-03-20

    /*+------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category            14021138 Employee Fringe - Education  14021154 Payroll Burden Amount
      +     14021102 Job Revenue Category          14021139 Employee Fringe - Misc. 1    14021155 Payroll Burden Job Cost Cat
      +     14021103 Cost-Revenue Type            14021140 Employee Fringe - Misc. 2    14021186 Skill Class
      +     14021104 Cost Factor Set By Category  14021141 Employee Fringe - Misc. 3    14021300 Subcontract No.
      +     14021110 Work Units                    14021142 Employee Fringe Total        14021301 Retention Ledger Code
      +     14021111 Work Unit of Measure          14021143 Prevailing Wage Rate          14021375 Payroll Work State
      +     14021120 External Relationship Type    14021144 Prevailing Fringe Rate        14021376 Jobsite Work
      +     14021121 External Relationship No.    14021145 Wage Calculation Basis        14021400 Staged
      +     14021122 External Relationship Name    14021150 Balance Cost (LCY)            14021401 Purch. Receipt Doc. No.
      +     14021135 Employee Wage Rate            14021151 Balance Price (LCY)          14021402 Purch. Receipt Line No.
      +     14021136 Employee Fringe - Insurance  14021152 Burden Amount                14021403 Box Ref.
      +     14021137 Employee Fringe - Vacation    14021153 Burden Job Cost Category


      +  - Added function(s):
      +     PP_CalculateWageRate
      +     PP_CalculateBurden
      +     PP_CopyJobJnlLineToCrewMembers
      +     PP_AssignDefaultSkillClass
      +     PP_AssignPayrollWorkState
      +     UpdateCostFactor
      +     GetPurchReceiptLines
      +
      +  - Added global variable(s):
      +     PP_Job : Record 167;
      +     PP_DirectCostOverride : Boolean;
      +     PP_UnitCostLCYHold : Decimal;
      +     PP_PurchPriceCalcMgt : Codeunit 7010;
      +     PP_Vendor : Record 23;
      +     PP_JobsSetup : Record 315;
      +     PP_EmployeeBurdenDetail : Record 14021377;
      +     PP_Employee : Record 5200;
      +     PP_JobResourcePrice : Record 1012;
      +     PP_EmployeeWageRate : Record 14021375;
      +     PP_Resource : Record 156;
      +     PP_DimensionSetEntry : Record 480;
      +     PP_JobTaskDimension : Record 1002;
      +     JobMatPlanning : Record 14021421;
      +     Text14021100 : TextConst 'ENU=%1 cannot be blank.';
      +     Text14021101 : TextConst 'ENU=Wage Rate (Unit Cost) entered by user.';
      +
      +  - Modified:
      +     - Added Keys
      +         Job No.,Type,No.
      +     - Permissions
      +         TableData - Dimension Set Entry  rimd
      +     - OnDelete
      +         Modify records
      +           JobMatPlanning
      +           PurchRcptLine
      +     - Fields
      +         Job No.              - OnValidate - Call to procedures
      +                                                  PP_AssignPayrollWorkState;
      +                                                  PP_AssignDefaultSkillClass;
      +                                                  PP_CalculateWageRate;
      +         Posting Date         - OnValidate - Call to PP_CalculateWageRate
      +         Type                 - Added Ledger to the end of the Option string
      +         No.                  - OnValidate - Populate
      +                                                  Job Cost Category
      +                                                  Job Revenue Category
      +                                                  Unit Cost (LCY)
      +                                                  Direct Unit Cost (LCY)
      +                                           - Modify TableRelation
      +         Quantity             - OnValidate - Call PP_CalculateWageRate
      +                                           - Update Job Planning Line Bal. Req field for Item types
      +         Unit Cost (LCY)      - OnValidate - Set value base on condition
      +                                                  Wage Calculation Basis if needed
      +         Unit of Measure Code - OnValidate - Populate
      +                                                  Direct Unit Cost (LCY)
      +                                                  Unit Cost (LCY)
      +                                           - Modification on record types of
      +                                                  Item
      +                                                  G/L Account
      +                              - OnLookup - Added lookups based on Type
      +         Work Type Code       - OnValidate - Call to PP_CalculateWageRate
      +         Entry Type           - Added Release,Earn,Payment to the end of the Option String
      +                              - Allow field to be editable
      +         Job Task No.         - OnValidate - copy Job task Dimension fields to Journal line
      +         Unit Cost            - OnValidate - Set Wage Calculation Basis if needed
      +         Skill Class          - OnValidate - Added procedure call
      +                                                  UpdateAllAmounts()
      +         Variant Code         - On Validate - Populate as needed
      +                                                  Direct Unit Cost (LCY)
      +     - Procedures
      +         UpdateUnitCost: Populate Resource Cost record
      +                             Job No.
      +                             Job Task No.
      +                             Currency Code
      +         HandleCostFactor: Modify the condition causing Unit Price not to be updated
      +         RetrieveCostPrice: Added condition to cause the the system to retrieve new CostPrice data if the Skill Class has been changed
      +         SetUpNewLine: Modify field values when Auto-F8 fields are set on new lines
      +                             Job No.
      +                             Job Task No.
      +         CopyFromResources:
      +             - "Allow Timesheet & Job Jnl Post" in Job Setup setting controls procssing
      +             - Added settings to
      +                 Job Cost Category
      +                 Job Revenue Category
      +             - Added calls to
      +                 PP_AssignPayrollWorkState;
      +                 PP_AssignDefaultSkillClass;
      +                 PP_CalculateWageRate;
      +       CopyFromAccount: Set values to fields rather than zero
      +       CopyFromItem:
      +         - Set Job Cost Category.
      +------------------------------------------------------------*/
}

