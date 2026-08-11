tableextension 14021214 NS_JobPlanningLine extends "Job Planning Line"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-33.SK.1.0 Modified code for updating "Unit Cost" and "Unit Price" while picking up "No." in Line.
    //PRJ-72.SK.1.0 Modified Code since it is causing error.
    //PRJ-72 VT 06-03-20 Added a Function InitRoundingPrecisionsPP
    //PRJ-158 VT 13-03-20 - Code Added for Rounding Error
    //JD-10.MS.1.0 Added new fields	
    //PRJ-291.MS.1.0 added code for creationof segment entry on the basis of job setup
    //JD-54.AM.1.0 Added New field
    //PRJ-334.MS.1.0 added code for issue of unit price in planning line
    //JD-48.AS.2.0 Added code and function to remove JFW Segment code Entries
    //TM-10.AM.1.0 24NOV2020 | Added code on Onvalidate of Segment Code field to update 4 values upon segment code selection.
    //PRJ-704.N.S.1.0 change in updatesegmententry function
    //PRJ-913.JS.1.0 15Sep2021 | add code to flow dimension from task line lines
    //PRJ-929.GK.1.0 22Sep2021 | Added Three fields
    //PRJ-973.GK.1.0 13Oct2021 | Add one field and validate this field from Job.
    //PRJ-1015.JS.1.0 10Oct2021 | Add one field
    //PRJ-1182.AS.2.0 | Added events for PRJ-1226
    //PRJ-1335.NK.1.0 02May2022 Add Code
    //PRJ-1608.RM.1.0 20Sep2022 | Added some code
    //FOR-8.RM.1.0 13Apr2023 | Added some code
    //PRJCTPR-191.HS.1.0 29sept2023| Added two fields
    fields
    {

        //Unsupported feature: Change Editable on ""Job No."(Field 2)". Please convert manually.

        modify(Type)
        {
            trigger OnAfterValidate();
            begin
                //PRJCTPR-322.AT START
                if (Type = Type::"NS_Resource (Group)") then
                    Error('Resource (Group) will obselete in Projectpro upcoming release 25.0.XX.XXXX');
                //PRJCTPR-322.AT END

                //ProjectPro - start
                if (Type <> xRec.Type) and ("NS_Segment Code" <> '') then
                    UpdateSegmentEntry;
                //ProjectPro - end
            end;
        }


        modify("No.")
        {
            TableRelation = IF (Type = CONST("NS_Resource (Group)")) "Resource Group";

            trigger OnAfterValidate()
            var
                NSJob: Record Job; //PRJ-1608.RM.1.0
                                   //PRJ-563
                AssemBOMRec: Record "NS_Assembley BOM Components";//PRJ-563
                AssemBOMRec2: Record "NS_Assembley BOM Components";//PRJ-563
                AssemBOMRec3: Record "NS_Assembley BOM Components";//PRJ-563
                ASMBOM: Record "NS_Assembley BOM Components";//PRJ-1226.AS.1.0
                BOMComponentRec: Record "BOM Component";//PRJ-563
                itemrec: Record Item;//PRJ-563
                Resourcerec: Record Resource;//PRJ-463.AS.4.0
                NS_Job: Record Job; //PRJ-973.GK.1.0 13Oct2021
                Jobs: Record Job;  //PRJ-1015.JS.1.0 10Oct2021 //PRJ-929.GK.4.0 16Dec2021
                NS_GLAccount: Record "G/L Account";//PRJ-1089.GK.1.0 28Dec2021


            begin
                //PRJ-913.JS.1.0 15Sep2021-Start
                If Rec."Line No." <> 0 then begin
                    NS_JobTskLins.get(Rec."Job No.", "Job Task No.");
                    Rec.Validate("NS_Shortcut Dimension 1 Code", NS_JobTskLins."Global Dimension 1 Code");
                    Rec.Validate("NS_Shortcut Dimension 2 Code", NS_JobTskLins."Global Dimension 2 Code");
                    //PRJ-1015.JS.1.0 10Oct2021 - Start
                    If Jobs.Get(rec."Job No.") then
                        Rec."NS_Sub-Level to Job No." := Jobs."NS_Sub-Level to Job No.";
                    //PRJ-1015.JS.1.0 10Oct2021 - Start                      
                end;
                //PRJ-913.JS.1.0 15Sep2021-end                
                CASE Type OF
                    Type::Resource:
                        BEGIN
                            IF Res.GET("No.") Then; //PRJ-72.SK.1.0
                                                    //ProjectPro - start
                            IF Res."NS_Job Revenue Category" <> '' THEN
                                "NS_Revenue Category" := Res."NS_Job Revenue Category";
                            IF Res."NS_Job Cost Category" <> '' THEN
                                "NS_Cost Category" := Res."NS_Job Cost Category";
                            //ProjectPro - end
                            "Unit of Measure Code" := res."Base Unit of Measure";  //PRJCTPR-397.JS.1.0
                        END;
                    Type::Item:
                        BEGIN
                            GetItem;
                            //ProjectPro - start
                            IF Item."NS_Job Cost Category" <> '' THEN
                                "NS_Cost Category" := Item."NS_Job Cost Category";
                            //PRJ-1335.NK.1.0 02May2022 Start
                            if Item."NS_Revenue Category" <> '' then
                                if "Line Type" <> "Line Type"::Budget then
                                    "NS_Revenue Category" := Item."NS_Revenue Category";
                            //PRJ-1335.NK.1.0 02May2022 End
                            Item.CalcFields("Assembly BOM");
                            "NS_Assembley BOM" := Item."Assembly BOM";
                            //ProjectPro - end
                            "Unit of Measure Code" := NS_GetUOMfromItem("No."); //PE-301.NC.1.0 05Jun2024
                        END;
                    //ProjectPro - start
                    Type::"NS_Resource (Group)":
                        BEGIN
                            //NS_ResourceGroup.GET("No."); //PRJCTPR-322 comment
                            if NS_ResourceGroup.GET("No.") then ///PRJCTPR-322 Add
                                Description := NS_ResourceGroup.Name;
                        END;
                    //PRJ-1089.GK.1.0 28Dec2021 start
                    Type::"G/L Account":
                        begin
                            if NS_GLAccount.Get("No.") then
                                if NS_GLAccount."NS_Cost Category" <> '' then
                                    "NS_Cost Category" := NS_GLAccount."NS_Cost Category"
                                else
                                    "NS_Cost Category" := '';
                        end;
                //PRJ-1089.GK.1.0 28Dec2021 end
                //ProjectPro - end
                END;
                //ProjectPro - start

                //PRJ-563.AS.1.0 24MAY2020 - start
                If "NS_Assembley BOM" = true then
                    "NS_Item Type" := "NS_Item Type"::Assembly
                else
                    "NS_Item Type" := "NS_Item Type"::Normal;
                NS_Level := 0;
                "NS_Main Item" := "No.";
                //PRJ-563.AS.1.0 24MAY2020 - end

                NS_TempNo := "No.";
                NS_TempUM := "Unit of Measure Code";
                IF ("No." <> xRec."No.") AND ("NS_Segment Code" <> '') THEN
                    UpdateSegmentEntry;
                //ProjectPro - end
                if Job.get("Job No.") then; //PRj-394
                                            //"Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group";//PRj-394 //PRJ-831.AS.1.0 12OCT2021 Comment old
                "Gen. Bus. Posting Group" := Job."NS_Gen. Bus. Posting Group New";//PRj-394 //PRJ-831.AS.1.0 12OCT2021 Comment New

                //PRJ-1226.AS.4.0 - START PE-26.AS.1.0 START
                ASMBOM.Reset();
                ASMBOM.SetRange("NS_Job No.", rec."Job No.");
                ASMBOM.SetRange("NS_Job Task No.", rec."Job Task No.");
                ASMBOM.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                ASMBOM.DELETEALL();
                //PRJ-1226.AS.4.0 - END PE-26.AS.1.0 END

                //PRJ-563.AS.1.0 - START
                if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and ("NS_Assembley BOM" = true) then begin
                    BOMComponentRec.Reset();
                    BOMComponentRec.SetRange("Parent Item No.", Rec."No.");
                    BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
                    if BOMComponentRec.FindSet() then
                        repeat
                            AssemBOMRec.Reset();
                            AssemBOMRec.SetRange("NS_Job No.", rec."Job No.");
                            AssemBOMRec.SetRange("NS_Job Task No.", rec."Job Task No.");
                            AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                            AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", BOMComponentRec."Parent Item No.");
                            AssemBOMRec.SetRange("NS_Ref. ASMBOM Line No.", BOMComponentRec."Line No.");
                            if not AssemBOMRec.FindFirst() then begin
                                AssemBOMRec2.Init();
                                AssemBOMRec2."NS_Job No." := Rec."Job No.";
                                AssemBOMRec2."NS_Job Task No." := Rec."Job Task No.";

                                AssemBOMRec3.Reset();
                                AssemBOMRec3.SetRange("NS_Job No.", Rec."Job No.");
                                AssemBOMRec3.SetRange("NS_Job Task No.", Rec."Job Task No.");
                                if AssemBOMRec3.FindLast() then
                                    AssemBOMRec2."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
                                else
                                    AssemBOMRec2."NS_Line No." := 10000;

                                if BOMComponentRec.Type = BOMComponentRec.Type::Item then begin
                                    AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Item;
                                    AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                                    if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                        if itemrec.get(AssemBOMRec2."NS_No.") then begin
                                            itemrec.CalcFields("Assembly BOM");
                                            AssemBOMRec2."NS_Assembly BOM" := itemrec."Assembly BOM";
                                            // AssemBOMRec2.NS_Description := itemrec.Description;//PRJ-838 COMMENT
                                            AssemBOMRec2."NS_Description New" := itemrec.Description;//PRJ-838 ADD
                                            AssemBOMRec2."NS_Unit Cost" := itemrec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                        end;
                                    end;
                                end;

                                if BOMComponentRec.Type = BOMComponentRec.Type::Resource then begin
                                    AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Resource;
                                    AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                                    //if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                    if Resourcerec.get(AssemBOMRec2."NS_No.") then begin
                                        AssemBOMRec2."NS_Assembly BOM" := BOMComponentRec."Assembly BOM";
                                        // AssemBOMRec2.NS_Description := Resourcerec.Name;//PRJ-838 COMMENT
                                        AssemBOMRec2."NS_Description New" := Resourcerec.Name;//PRJ-838 ADD
                                        AssemBOMRec2."NS_Unit Cost" := Resourcerec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                    end;
                                    //end;
                                end;
                                AssemBOMRec2."NS_Quantity Per" := BOMComponentRec."Quantity per";
                                AssemBOMRec2."NS_Quantity of Assembly Item on Job" := Rec.Quantity;
                                AssemBOMRec2."NS_Unit of Measure Code" := BOMComponentRec."Unit of Measure Code";
                                AssemBOMRec2."NS_Expected Quantity" := AssemBOMRec2."NS_Quantity Per" * AssemBOMRec2."NS_Quantity of Assembly Item on Job";
                                AssemBOMRec2."NS_Ref. JPL Line No." := Rec."Line No.";
                                AssemBOMRec2."NS_Ref. JPL Parent Item No." := BOMComponentRec."Parent Item No.";
                                AssemBOMRec2."NS_Ref. ASMBOM Line No." := BOMComponentRec."Line No.";
                                AssemBOMRec2."NS_JPL DocNo" := Rec."Document No.";
                                //PRJ-563.AS.1.0 24MAY2020 - start
                                AssemBOMRec2.NS_Level := NS_Level + 1;
                                AssemBOMRec2."NS_Main Item" := "No.";
                                if AssemBOMRec2."NS_Assembly BOM" = true then
                                    AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Assembly
                                else
                                    AssemBOMRec2."NS_Item Type" := AssemBOMRec2."NS_Item Type"::Normal;
                                //PRJ-563.AS.1.0 24MAY2020 - end
                                OnBeforeInsertAssembleyBOMComponents(AssemBOMRec2);//PRJ-1182.AS.2.0 ADDED EVENT
                                AssemBOMRec2.Insert();
                                OnAfterInsertAssembleyBOMComponents(AssemBOMRec2);//PRJ-1182.AS.2.0 ADDED EVENT
                            end;
                        until BOMComponentRec.next = 0;
                end;
                //PRJ-563.AS.1.0 - END
                //PRJ-973.GK.1.0 13Oct2021 start
                IF NS_Job.GET("Job No.") AND ("Line Type" <> "Line Type"::Budget) AND (Type = Type::"G/L Account") then
                    Validate("NS_Use Job Plan. Line Entries", NS_Job."NS_Use Job Plan. Line Entries");
                //PRJ-973.GK.1.0 13Oct2021 end
                if Jobs.get("Job No.") then;
                //"NS_Contract Forecast Date" := Jobs."NS_Contract Date"; //PRJ-1189.GK.1.0 06apr2022 //PRJ-1468.GK.1.0 12July2022 comment
                //PRJ-1608.RM.1.0 Start
                if NSJob.Get("Job No.") then;
                if NSJob."NS_Gen. Prod. Posting Group New" <> '' then
                    Rec."Gen. Prod. Posting Group" := NSJob."NS_Gen. Prod. Posting Group New";
                //PRJ-1608.RM.1.0 End
            end;
        }

        //DMT
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                NS_TempNo := '';
            end;

            trigger OnAfterValidate();
            Var //PRJ-563.AS.2.0
                ItemTbl: Record item;//PRJ-563.AS.2.0
                AssemBOMRec: Record "NS_Assembley BOM Components";//PRJ-563
                AssemBOMRec2: Record "NS_Assembley BOM Components";//PRJ-563
                AssemBOMRec3: Record "NS_Assembley BOM Components";//PRJ-563
                BOMComponentRec: Record "BOM Component";//PRJ-563
                itemrec: Record Item;//PRJ-563

            begin
                //ProjectPro - start
                QuoteMgt.NS_CalcProfitAmounts("Job No.", "Job Task No.", Rec);
                if ("Quantity (Base)" <> xRec."Quantity (Base)") and ("NS_Segment Code" <> '') then
                    UpdateSegmentEntry;
                QuoteMgt.NS_CalcSegmentProfitAmounts("Job No.", "NS_Segment Code");
                //ProjectPro - end

                //PRJ-563.AS.1.0 - START
                if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and ("NS_Assembley BOM" = true) then begin
                    BOMComponentRec.Reset();
                    BOMComponentRec.SetRange("Parent Item No.", Rec."No.");
                    BOMComponentRec.SetFilter(Type, '<>%1', BOMComponentRec.Type::" ");//PRJ-563.AS.4.0 14APRIL2021
                    if BOMComponentRec.FindSet() then
                        repeat
                            AssemBOMRec.Reset();
                            AssemBOMRec.SetRange("NS_Job No.", rec."Job No.");
                            AssemBOMRec.SetRange("NS_Job Task No.", rec."Job Task No.");
                            AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                            AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", BOMComponentRec."Parent Item No.");
                            AssemBOMRec.SetRange("NS_Ref. ASMBOM Line No.", BOMComponentRec."Line No.");
                            if not AssemBOMRec.FindFirst() then begin
                                AssemBOMRec2.Init();
                                AssemBOMRec2."NS_Job No." := Rec."Job No.";
                                AssemBOMRec2."NS_Job Task No." := Rec."Job Task No.";

                                AssemBOMRec3.Reset();
                                AssemBOMRec3.SetRange("NS_Job No.", Rec."Job No.");
                                AssemBOMRec3.SetRange("NS_Job Task No.", Rec."Job Task No.");
                                if AssemBOMRec3.FindLast() then
                                    AssemBOMRec2."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
                                else
                                    AssemBOMRec2."NS_Line No." := 10000;

                                AssemBOMRec2.NS_Type := AssemBOMRec2.NS_Type::Item;
                                AssemBOMRec2."NS_No." := BOMComponentRec."No.";
                                if (AssemBOMRec2.NS_Type = AssemBOMRec2.NS_Type::Item) and (AssemBOMRec2."NS_No." <> '') then begin
                                    if itemrec.get(AssemBOMRec2."NS_No.") then begin
                                        itemrec.CalcFields("Assembly BOM");
                                        AssemBOMRec2."NS_Assembly BOM" := itemrec."Assembly BOM";
                                        // AssemBOMRec2.NS_Description := itemrec.Description;//PRJ-838 COMMENT
                                        AssemBOMRec2."NS_Description New" := itemrec.Description;//PRJ-838 ADD
                                    end;
                                end;
                                AssemBOMRec2."NS_Quantity Per" := BOMComponentRec."Quantity per";
                                AssemBOMRec2."NS_Quantity of Assembly Item on Job" := Rec.Quantity;
                                AssemBOMRec2."NS_Unit of Measure Code" := BOMComponentRec."Unit of Measure Code";
                                AssemBOMRec2."NS_Expected Quantity" := AssemBOMRec2."NS_Quantity Per" * AssemBOMRec2."NS_Quantity of Assembly Item on Job";
                                AssemBOMRec2."NS_Ref. JPL Line No." := Rec."Line No.";
                                AssemBOMRec2."NS_Ref. JPL Parent Item No." := BOMComponentRec."Parent Item No.";
                                AssemBOMRec2."NS_Ref. ASMBOM Line No." := BOMComponentRec."Line No.";
                                AssemBOMRec2.Insert();
                            end;
                        until BOMComponentRec.next = 0;
                end;
                AssemBOMRec.Reset();
                AssemBOMRec.SetRange("NS_Job No.", rec."Job No.");
                AssemBOMRec.SetRange("NS_Job Task No.", rec."Job Task No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."No.");
                if AssemBOMRec.Findset() then
                    repeat
                        AssemBOMRec."NS_Quantity of Assembly Item on Job" := Rec.Quantity;
                        AssemBOMRec."NS_Expected Quantity" := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                        AssemBOMRec.Modify();
                    until AssemBOMRec.next = 0;
                //PRJ-563.AS.1.0 - END
                //PRJ-929.GK.1.0 22Sep2021 start
                if "NS_Use Tax" = true then begin
                    Validate("NS_Use Tax Amounts", (("Unit Cost" * Quantity * "NS_Use Tax Percentage") / 100));
                end else begin
                    Validate("NS_Use Tax Amounts", 0);
                end;
                //PRJ-929.GK.1.0 22Sep2021 end
            end;
        }

        modify("Unit Cost")
        {
            trigger OnBeforeValidate()
            begin
                NS_TempNo := "No.";
            end;

            trigger OnAfterValidate()
            var
            begin
                //PRJ-929.GK.1.0 22Sep2021 - start
                if "NS_Use Tax" = true then begin
                    Validate("NS_Use Tax Amounts", (("Unit Cost" * Quantity * "NS_Use Tax Percentage") / 100));
                end else begin
                    Validate("NS_Use Tax Amounts", 0);
                end;
                //PRJ-929.GK.1.0 22Sep2021 - end

            end;
        }

        modify("Unit Price")
        {
            trigger OnBeforeValidate()
            begin
                NS_TempNo := "No.";
            end;

            trigger OnAfterValidate()
            begin
                Validate(Quantity);//PRJ-1531.GK.1.0 29Aug2022
            end;
        }

        modify("Unit Cost (LCY)")
        {
            trigger OnBeforeValidate()
            begin
                IF (Type <> Type::Item) OR
                   NOT Item.GET("No.") OR
                   (Item."Costing Method" <> Item."Costing Method"::Standard)
                then BEGIN
                    InitRoundingPrecisions;
                    //ProjectPro - start
                    "Direct Unit Cost (LCY)" := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Currency Date", "Currency Code",
                          "Unit Cost (LCY)", "Currency Factor"),
                        UnitAmountRoundingPrecisionFCY);
                    //ProjectPro - end
                END;
            end;
        }

        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_TempUM := "Unit of Measure Code";
                //ProjectPro - end
            end;
        }

        //Unsupported feature: CodeModification on ""Location Code"(Field 20).OnValidate". Please convert manually.
        modify("Location Code")
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_TempLocation := "Location Code";
                //ProjectPro - end
            end;
        }

        modify("Work Type Code")
        {
            trigger OnBeforeValidate()
            var
                NS_TempJobPlanningLine1: Record "Job Planning Line" temporary;
                NS_TempJobPlanningLine2: Record "Job Planning Line" temporary;
            begin
                //ProjectPro - start
                IF Type <> Type::Resource THEN
                    IF Type <> Type::"NS_Resource (Group)" THEN BEGIN
                        NS_TempJobPlanningLine1.INIT;
                        NS_TempJobPlanningLine1.Type := NS_TempJobPlanningLine1.Type::Resource;
                        NS_TempJobPlanningLine2.INIT;
                        NS_TempJobPlanningLine2.Type := NS_TempJobPlanningLine2.Type::"NS_Resource (Group)";
                        ERROR(Text14021100, FIELDCAPTION(Type), NS_TempJobPlanningLine1.Type, NS_TempJobPlanningLine2.Type);
                    END;
                IF Rec.Type = Rec.Type::Resource THEN
                    exit;
                //ProjectPro - end
            end;

            trigger OnAfterValidate()
            begin
                //ProjectPro - start
                NS_TempWorkType := "Work Type Code";
                NS_UpdateLineAmount;
                //ProjectPro - end                
            end;
        }

        modify("Job Task No.")
        {
            trigger OnAfterValidate();
            var
                JPL: Record "Job Planning Line";
            begin
                //ProjectPro - start
                JPL.RESET;
                JPL.SETRANGE("Job No.", "Job No.");
                JPL.SETRANGE("Job Task No.", "Job Task No.");
                if JPL.FINDLAST then
                    "Line No." := JPL."Line No." + 10000
                else
                    "Line No." := 10000;
                //ProjectPro - end
            end;
        }

        modify("Line Type")
        {
            trigger OnBeforeValidate()
            var
                NSResRec: Record Resource; //PRJCTPR-397.JS.1.0 04July2024
            begin
                //ProjectPro - start
                case "Line Type" of
                    "Line Type"::Budget:
                        "NS_Entry Type" := "NS_Entry Type"::Cost;
                    "Line Type"::Billable:
                        "NS_Entry Type" := "NS_Entry Type"::Price;
                    "Line Type"::"Both Budget and Billable":
                        "NS_Entry Type" := "NS_Entry Type"::Both;
                end;
                //FOR-8.RM.1.0 13Apr2023 Start
                // if ("Line Type" <> "Line Type"::Budget) or ("Line Type" = "Line Type"::"Both Budget and Billable") then
                //     "NS_Progress Billing Method" := "NS_Progress Billing Method"::"%";
                if ("Line Type" = "Line Type"::Billable) or ("Line Type" = "Line Type"::"Both Budget and Billable") then
                    "NS_Progress Billing Method" := "NS_Progress Billing Method"::"%"
                else
                    "NS_Progress Billing Method" := "NS_Progress Billing Method"::" ";
                //FOR-8.RM.1.0 13Apr2023 end
                if "No." <> '' then //PE-301.NC.1.0 13Jun2024
                    "Unit of Measure Code" := NS_GetUOMfromItem("No."); //PE-301.NC.1.0 13Jun2024

                //ProjectPro - end
                //PRJCTPR-397.JS.1.0 04July2024-Start
                if (Type = Type::Resource) and ("No." <> '') then
                    if NSResRec.get("No.") then
                        "Unit of Measure Code" := NSResRec."Base Unit of Measure";
                //PRJCTPR-397.JS.1.0 04July2024-end
            end;
        }

        modify("Variant Code")
        {
            trigger OnAfterValidate()
            begin
                //ProjectPro - start
                NS_TempVariant := "Variant Code";
                //ProjectPro - end
            end;
        }

        field(14021101; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Cost Category";

            trigger OnValidate();
            begin
                //ProjectPro - start
                if ("NS_Cost Category" <> '') and ("Line Type" = "Line Type"::Billable) then
                    ERROR(Text14021103);

                NS_JobsSetup.GET;

                if "Job No." <> '' then
                    if ("Line Type" = "Line Type"::Budget) or ("Line Type" = "Line Type"::"Both Budget and Billable") then
                        if (NS_JobsSetup."NS_Cost Category Required Bud") and ("NS_Cost Category" = '') then
                            ERROR(Text14021104, "Job No.", "Line No.");
                //ProjectPro - end
            end;
        }
        field(14021102; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NSJobs: record Job;  //PE-249.JS.1.0 09FEB2024
            begin
                //ProjectPro - start
                //PE-249.JS.1.0 09FEB2024
                if NS_JobsSetup.GET() then;
                if NSJobs.get("Job No.") then;
                //if ("NS_Revenue Category" <> '') and ("Line Type" = "Line Type"::Budget) then
                if ("NS_Revenue Category" <> '') and ("Line Type" = "Line Type"::Budget) and (NSJobs."NS_Mandate Revenue Category" = false) then
                    ERROR(Text14021105);

                //NS_JobsSetup.GET()
                //PE-249.JS.1.0 09FEB2024 - end

                if ("Line Type" = "Line Type"::Billable) and ("Job No." <> '') then
                    if (NS_JobsSetup."NS_Revenue Cat. Required Bud") and ("NS_Revenue Category" = '') then
                        ERROR(Text14021106, "Job No.", "Line No.");
                //ProjectPro - end
            end;
        }
        field(14021103; "NS_Cost Factor Set By Category"; Boolean)
        {
            Caption = 'Cost Factor Set By Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        //PRJ-563.AS.1.0 19MARCH2021 - START
        field(14021104; "NS_Assembley BOM"; Boolean)
        {
            Caption = 'Assembly BOM';
            // FieldClass = FlowField;
            // CalcFormula = Exist("BOM Component" WHERE("Parent Item No." = FIELD("No.")));
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-563.AS.1.0 19MARCH2021 - END

        field(14021105; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NSJobSetup: Record "Jobs Setup";  //PE-273.JS.1.0 15MAR2024                
            begin
                //PE-273.JS.1.0 15MAR2024 start
                if NSJobSetup.get() then
                    if NSJobSetup."NS_Enable Change Dim. on JPL" = false then
                        //ProjectPro - start
                        NS_ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code")
                    else begin
                        if rec."NS_Shortcut Dimension 1 Code" <> xrec."NS_Shortcut Dimension 1 Code" then begin
                            NS_ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
                        end;
                    end;
                //PE-273.JS.1.0 15MAR2024 end
                //ProjectPro - end
            end;
        }
        field(14021106; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NSJobSetup: Record "Jobs Setup";  //PE-273.JS.1.0 15MAR2024            
            begin
                //PE-273.JS.1.0 15MAR2024 start
                if NSJobSetup.get() then
                    if NSJobSetup."NS_Enable Change Dim. on JPL" = false then
                        //ProjectPro - start
                        NS_ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code")
                    else begin
                        if rec."NS_Shortcut Dimension 2 Code" <> xrec."NS_Shortcut Dimension 2 Code" then begin
                            NS_ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code")
                        end;
                    end;
                //PE-273.JS.1.0 15MAR2024 end        
                //ProjectPro - end
            end;
        }
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'ProjectPro - Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'ProjectPro - Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'ProjectPro - Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Copied to JMP"; Boolean)
        {
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(14021111; "NS_Section Code"; Code[10])
        {
            Caption = 'Section Code';
            Description = 'ProjectPro - Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-688.AM.1.0
        field(14021115; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021118; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;
            //PE-68 Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68 Dk.1.0 10April2023 End
            trigger OnValidate();
            var
            begin
                //ProjectPro - start
                //UpdateAllAmounts; //PRJ-9.SK.1.0 Commented as not found
                NS_UpdateLineAmount;

                NS_TempSkillClass := "NS_Skill Class";
                //ProjectPro - end
            end;
        }
        //PE-68.Dk.1.0 10April2023 Start
        field(14021119; "NS_Skill Class New"; Code[20])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            TableRelation = "NS_Skill Class";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            begin


                NS_UpdateLineAmount;
                // NS_TempSkillClass := "NS_Skill Class";
                NS_TempSkillClass := "NS_Skill Class New";

            end;
        }
        //PE-68.Dk.1.0 10April2023 End
        field(14021150; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'ProjectPro';
            OptionCaption = 'Cost,Both,Price';
            DataClassification = CustomerContent;
            OptionMembers = Cost,Both,Price;
        }
        field(14021151; NS_Adjustment; Code[10])
        {
            Caption = 'Adjustment';
            Description = 'ProjectPro';
            TableRelation = "NS_Adjustment Type".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Rate Type"; Option)
        {
            Caption = 'Rate Type';
            Description = 'ProjectPro';
            OptionCaption = '" ,Fixed,Time and Material,Cost Plus %,Cost Plus $"';
            OptionMembers = " ","Fixed","Time and Material","Cost Plus %","Cost Plus $";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Entry Type" = "NS_Entry Type"::Cost then
                    TESTFIELD("NS_Rate Type", 0)
                else
                    if ("Line Type" = "Line Type"::Billable) and ("NS_Rate Type" > 0) then
                        ERROR(Text14021107);
                //ProjectPro - end
            end;
        }
        field(14021153; "NS_Rate Type Value"; Decimal)
        {
            Caption = 'Rate Type Value';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if ("NS_Rate Type" in [0, "NS_Rate Type"::"Time and Material"]) or
                   ("NS_Entry Type" = "NS_Entry Type"::Cost) then
                    TESTFIELD("NS_Rate Type Value", 0);
                //ProjectPro - end
            end;
        }
        field(14021154; "NS_Not To Exceed"; Decimal)
        {
            Caption = 'Not To Exceed';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Entry Type" = "NS_Entry Type"::Cost then
                    TESTFIELD("NS_Rate Type Value", 0);
                //ProjectPro - end
            end;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract."NS_No.";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Subcontract No." = '' then begin
                    if xRec."NS_Subcontract No." > '' then
                        NS_ModifySubcontract(2, Rec, xRec);
                end else begin
                    if xRec."NS_Subcontract No." = '' then begin
                        if not NS_Subcontract.GET("NS_Subcontract No.") then
                            ERROR(Text14021108, "NS_Subcontract No.");

                        NS_ModifySubcontract(0, Rec, xRec);
                    end else
                        NS_ModifySubcontract(1, Rec, xRec);
                end;
                //ProjectPro - end
            end;
        }
        field(14021325; "NS_Subcontract Line No."; Integer)
        {
            Caption = 'Subcontract Line No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021326; "NS_Progress Billing Method"; Option)
        {
            Caption = 'Progress Billing Method';
            Description = 'ProjectPro';
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                //FOR-8.RM.1.0 13Apr2023 start
                // if "Line Type" = "Line Type"::Budget then
                //     ERROR(Text14021109);
                if ("Line Type" = "Line Type"::Budget) AND (Rec."NS_Progress Billing Method" <> Rec."NS_Progress Billing Method"::" ") then
                    ERROR(Text14021109);
                //FOR-8.RM.1.0 13Apr2023 End
                //ProjectPro - end
            end;
        }
        field(14021327; "NS_Progress Payment Method"; Option)
        {
            Caption = 'Progress Payment Method';
            Description = 'ProjectPro';
            OptionCaption = ' ,%,Unit,L/S';
            //   ENC = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;
        }
        field(14021328; "NS_Level"; Integer)//PRJ-563.AS.1.0 24MAY2020 
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
            end;
        }
        field(14021329; "NS_Main Item"; Code[20])//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Main Item';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Text)) "Standard Text";

            trigger OnValidate();
            var
            begin

            end;
        }
        field(14021330; "NS_Item Type"; Option)//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Normal,Assembly';
            OptionMembers = Normal,Assembly;
        }
        field(14021350; NS_TempNo; Code[20])
        {
            Caption = 'TempNo';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021351; NS_TempLocation; Code[10])
        {
            Caption = 'TempLocation';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021352; NS_TempVariant; Code[10])
        {
            Caption = 'TempVariant';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021353; NS_TempUM; Code[10])
        {
            Caption = 'TempUM';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021354; NS_TempWorkType; Code[10])
        {
            Caption = 'TempWorkType';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021355; NS_TempSkillClass; Code[10])
        {
            Caption = 'TempSkillClass';
            Description = 'ProjectPro - Not for data entry!';
            DataClassification = CustomerContent;
        }
        field(14021400; NS_Welding; Boolean)
        {
            Caption = 'Welding';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Size of Weld"; Decimal)
        {
            Caption = 'Size of Weld';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                JobWeldSU: Record "NS_Job Takeoff Segments";
            begin
                //ProjectPro - start
                if NS_Welding then begin
                    if JobWeldSU.GET(1, '', '', "NS_Size of Weld") then
                        "NS_Weld Time (Hours)" := JobWeldSU."NS_Weld Time (Hours)";
                end else
                    "NS_Weld Time (Hours)" := 0;
                //ProjectPro - end
            end;
        }
        field(14021402; "NS_Weld Time (Hours)"; Decimal)
        {
            Caption = 'Weld Time (Hours)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_No. 2"; Code[30])
        {
            Caption = 'Mfg. Item No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Description = 'ProjectPro';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Vendor Quote No."; Text[30])
        {
            Caption = 'Vendor Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            Description = 'ProjectPro';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021412; "NS_Defaulted Entry"; Boolean)
        {
            Caption = 'Defaulted Entry';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021413; "NS_Total Number of Welds"; Integer)
        {
            Caption = 'Total Number of Welds';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021414; "NS_Gross Profit"; Decimal)
        {
            Caption = 'Gross Profit';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_Gross Profit Percentage"; Decimal)
        {
            Caption = 'Gross Profit Percentage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_Original Total Price"; Decimal)
        {
            Caption = 'Original Total Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_Original Total Price (LCY)"; Decimal)
        {
            Caption = 'Original Total Price (LCY)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021419; "NS_Item Not Found"; Boolean)
        {
            Caption = 'Item Not Found';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021420; "NS_Segment Type"; Option)
        {
            Caption = 'Segment Type';
            Description = 'ProjectPro';
            OptionCaption = '" ,Drawing,Welding"';
            OptionMembers = " ",Drawing,Welding;
            TableRelation = "NS_Job Takeoff Segments".NS_Type;
            DataClassification = CustomerContent;
        }
        field(14021421; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Segment: Record "NS_Job Takeoff Segments";
                SegmentEntry: Record "NS_Job Takeoff Segment Entry";
                TrueFalse: Boolean;
            begin
                //ProjectPro - start
                if (xRec."NS_Segment Code" <> '') and (Rec."NS_Segment Code" = '') then begin
                    RemoveSegmentEntry(xRec."NS_Segment Code");
                    exit;
                end;

                SegmentEntry.SETRANGE("NS_Job No.", "Job No.");
                SegmentEntry.SETRANGE("NS_Job Task No.", "Job Task No.");
                SegmentEntry.SETRANGE(NS_Type, Type);
                SegmentEntry.SETRANGE("NS_No.", "No.");
                SegmentEntry.SETRANGE("NS_Segment Code", "NS_Segment Code");
                TrueFalse := SegmentEntry.FINDFIRST;

                if ("NS_Segment Code" <> xRec."NS_Segment Code") and (not TrueFalse) then begin
                    Segment.SETRANGE("NS_Job No.", "Job No.");
                    Segment.SETRANGE("NS_Segment Code", "NS_Segment Code");
                    if Segment.FINDFIRST then begin
                        "NS_Segment Name" := Segment."NS_Segment Name";
                        "Document No." := Segment."NS_Segment Code";
                        InsertSegmentEntry;
                    end else begin
                        if "NS_Segment Code" = '' then begin
                            "NS_Segment Name" := '';
                            "Document No." := '';
                        end else
                            ERROR(STRSUBSTNO(Text14021402, "NS_Segment Code", "Job No."));
                    end;
                end;

                if ("NS_Segment Code" <> xRec."NS_Segment Code") and (TrueFalse) then begin
                    Segment.SETRANGE("NS_Job No.", "Job No.");
                    Segment.SETRANGE("NS_Segment Code", "NS_Segment Code");
                    if Segment.FINDFIRST then begin
                        "NS_Segment Name" := Segment."NS_Segment Name";
                        "Document No." := Segment."NS_Segment Code";
                        UpdateSegmentEntry;
                    end else
                        ERROR(STRSUBSTNO(Text14021402, "NS_Segment Code", "Job No."));
                end;
                //ProjectPro - end
                //TM-10.AM.1.0 24NOV2020 Start
                if "Line Type" = "Line Type"::Billable then
                    if Type = Type::"G/L Account" then begin
                        Segment.Reset();
                        Segment.SETRANGE("NS_Job No.", "Job No.");
                        Segment.SETRANGE("NS_Segment Code", "NS_Segment Code");
                        if Segment.FINDFIRST then begin
                            Validate("Unit of Measure Code", Segment."NS_Unit of Measure Code");
                            Validate(Quantity, Segment."NS_Estimated Quantity");
                            Validate("Unit Price", Segment."NS_Unit Rate");
                            validate("Total Price", Segment."NS_Total Cost");
                            Validate("NS_Progress Billing Method", Segment."NS_Billing Type");
                        end;
                    end;
                //TM-10.AM.1.0 24NOV2020 End
            end;
        }
        field(14021422; "NS_Segment Name"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Takeoff Segments"."NS_Segment Name" WHERE("NS_Job No." = FIELD("Job No."),
                                                                              "NS_Segment Code" = FIELD("NS_Segment Code")));
            Caption = 'Segment Name';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Name";
        }
        field(14021423; "NS_Matrix Updated"; Boolean)
        {
            Caption = 'Matrix Updated';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021425; "NS_Progress Billing Line"; Boolean)
        {
            Caption = 'Progress Billing Line';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-568.AS.1.0 - START
        field(14021426; "NS_Get Linked Resource"; Boolean)
        {
            Caption = 'Linked Resource'; //PE-323 AT 12july2024
            Description = 'Linked Resource'; //PE-323 AT 12july2024
            DataClassification = CustomerContent;
        }

        field(14021427; "NS_Linked Resource"; Code[20])
        {
            CaptionML = ENU = 'Default Linked Resource', //PE-323 AT.01 03July2024
                        ENC = 'Default Linked Resource';//PE-323 AT.01 03July2024
            Description = 'Default Linked Resource';//PE-323 AT.01 03July2024
            TableRelation = Resource."No.";
            DataClassification = CustomerContent;
        }
        field(14021428; "NS_Parent Linked Item"; Code[20])
        {
            CaptionML = ENU = 'Parent Item',
                        ENC = 'Parent Item';
            Description = 'Parent Item';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
        }
        field(14021429; "NS_Labor Hours per Qty."; Decimal)
        {
            Caption = 'Labor Hours per Qty.';
            Description = 'Labor Hours per Qty.';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4; //PRJ-1075.GK.1.0 13Dec2021
        }
        field(14021433; "NS_Resource Line No."; Integer)
        {
            Caption = 'Resource Line No.';
            Description = 'Resource Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-568.AS.1.0 - END
        field(14021480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Description = 'ProjectPro';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }
        field(14021481; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021482; "NS_Line Amount Incl. Tax"; Decimal)
        {
            Caption = 'Line Amount Incl. Tax';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021483; "NS_Template No."; Code[20])
        {
            Caption = 'Template No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021430; "NS_DFR No."; code[20])
        {
            Caption = 'DFR No.';
            Description = 'JD-10.MS.1.0';
            //Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021431; "NS_DFR Created"; Boolean)
        {
            Caption = 'DFR Created';
            Description = 'JD-10.MS.1.0';
            DataClassification = CustomerContent;
        }
        //JD-54.AM.1.0 Start
        field(14021432; "NS_DFR Locked"; Boolean)
        {
            Caption = 'DFR Locked';
            DataClassification = CustomerContent;
        }
        //JD-54.AM.1.0 End
        //PRJ-929.GK.1.0 22Sep2021 start
        field(14021484; "NS_Use Tax Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Tax Percentage';
            Editable = false;
            MinValue = 0;
            trigger OnValidate()
            begin
                //PRJ-929.GK.1.0 22Sep2021 start
                if "NS_Use Tax" = true then begin
                    Validate("NS_Use Tax Amounts", (("Unit Cost" * Quantity * "NS_Use Tax Percentage") / 100));
                end else begin
                    Validate("NS_Use Tax Amounts", 0);
                end;
                //PRJ-929.GK.1.0 22Sep2021 end
            end;

        }
        field(14021485; "NS_Use Tax Amounts"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Tax Amount';
            Editable = false;
            trigger OnValidate()
            begin
                //PRJ-929.GK.1.0 22Sep2021 start
                if "NS_Use Tax Amounts" <> 0 then
                    Validate("NS_Total Cost with Use Tax", (Quantity * "Unit Cost") + "NS_Use Tax Amounts")
                else
                    Validate("NS_Total Cost with Use Tax", (Quantity * "Unit Cost"));
                //PRJ-929.GK.1.0 22Sep2021 end
            end;
        }
        field(14021486; "NS_Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                //PRJ-929.GK.1.0 22Sep2021 start
                if "Line Type" = "Line Type"::Billable then
                    Error(NS_Text14021403);

                if "NS_Use Tax" = true then begin
                    Validate("NS_Use Tax Amounts", (("Unit Cost" * Quantity * "NS_Use Tax Percentage") / 100));
                end else begin
                    Validate("NS_Use Tax Amounts", 0);
                end;
                //PRJ-929.GK.1.0 22Sep2021 end

            end;
        }
        field(14021487; "NS_Total Cost with Use Tax"; Decimal)
        {
            Caption = 'Total Cost with Use Tax';
            DataClassification = CustomerContent;
            Editable = false;


        }
        //PRJ-929.GK.1.0 22Sep2021 end
        //PRJ-973.GK.1.0 13Oct2021 start
        field(14021488; "NS_Use Job Plan. Line Entries"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Job Planning Line Entries';

        }
        //PRJ-973.GK.1.0 13Oct2021 end
        field(14021489; "NS_Sub-Level to Job No."; Code[20])   //PRJ-1015.JS.1.0 10Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
        field(14021493; "NS_Old Qty."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Old Qty';
        }
        //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
        //PRJ-1189.GK.1.0 06apr2022 start
        field(14021494; "NS_Contract Forecast Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Forecast Date';
        }
        //PRJ-1189.GK.1.0 06apr2022 end
        //PRJ-1417.NK.1.0 31May2022 Start
        field(14021496; "NS_Quote Category"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Category';
        }
        field(14021499; "NS_UpdateUnitPrice"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'UpdateUnitPrice';
            Editable = false;
        }
        //PRJ-1417.NK.1.0 31May2022 End
        //PE-118.NC.1.0 03Aug2023 Start 
        field(14021477; "NS_ProgessBillingNo"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Progress Billing No.';
        }
        //PE-118.NC.1.0 03Aug2023 End 
        //PE-142.NC.1.0 03Aug2023 Start
        field(14021478; "NS_Change Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Change Order';
        }
        //PE-142.NC.1.0 03Aug2023 End

        //PRJCTPR-147.PS.2.0 20Sep2023 Start

        field(14021479; "NS_Ext Reference No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'External Reference No.';
            Editable = false;
        }
        //PRJCTPR-147.PS.2.0 20Sep2023 End 

        //PRJCTPR-191.HS.1.0 29sept2023 Start
        field(14021121; "NS_Requisition No."; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021120; "NS_Version No."; Integer)
        {
            DataClassification = CustomerContent;
            editable = false;
        }
        //PRJCTPR-191.HS.1.0 29sept2023 End
        //PE-221.NC.1.0 07Mar2024 Start
        field(14021131; "NS_Job Quote No."; Code[20])
        {
            DataClassification = CustomerContent;
            editable = false;
            Caption = 'Job Quote No.';
        }
        //PE-221.NC.1.0 07Mar2024 End
    }
    keys
    {
        //Unsupported feature: PropertyChange on ""Job No.","Job Task No.","Line No."(Key)". Please convert manually.
        //Unsupported feature: PropertyChange on ""Job No.","Job Task No.","Schedule Line","Planning Date"(Key)". Please convert manually.
        //Unsupported feature: PropertyChange on ""Job No.","Job Task No.","Contract Line","Planning Date"(Key)". Please convert manually.
        key(Key8; "NS_Subcontract No.")
        {
        }
    }

    trigger OnDelete();
    var
        AssemBOMRecT: Record "NS_Assembley BOM Components";//PRJ-563.AS.1.0 24MAY2021
    begin
        //ProjectPro - start
        RemoveSegmentEntry("NS_Segment Code");
        //ProjectPro - end
        NS_RemoveJFWSegmentEntries();//JD-48.AS.2.0

        //PRJ-563.AS.1.0 24MAY2021 - START
        AssemBOMRecT.Reset();
        AssemBOMRecT.SetRange("NS_Job No.", Rec."Job No.");
        AssemBOMRecT.SetRange("NS_Job Task No.", Rec."Job Task No.");
        AssemBOMRecT.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
        if AssemBOMRecT.FindSet() then
            AssemBOMRecT.DeleteAll();
        //PRJ-563.AS.1.0 24MAY2021 - END
    end;

    trigger OnInsert();
    var
        Jobs: Record Job;
    begin
        //ProjectPro - start
        Job.NS_JobTaskNoToAPO("Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        //ProjectPro - end
        //PRJ-913.JS.1.0 15Sep2021-Start
        If Rec."Line No." <> 0 then begin
            NS_JobTskLins.get(Rec."Job No.", "Job Task No.");
            Rec.Validate("NS_Shortcut Dimension 1 Code", NS_JobTskLins."Global Dimension 1 Code");
            Rec.Validate("NS_Shortcut Dimension 2 Code", NS_JobTskLins."Global Dimension 2 Code");
            //PRJ-1015.JS.1.0 10Oct2021 - Start
            If Jobs.Get(rec."Job No.") then begin
                Rec."NS_Sub-Level to Job No." := Jobs."NS_Sub-Level to Job No.";
                Rec."NS_Ext Reference No." := Jobs."No."; //PRJCTPR-147.PS.2.0 20Sep2023
                Rec."NS_Job Quote No." := Jobs."No."; //PE-221.NC.1.0 07Mar2024

            end;
            //PRJ-1015.JS.1.0 10Oct2021 - Start             
        end;
        //PRJ-913.JS.1.0 15Sep2021-end  

        //PRJ-929.GK.1.0 22Sep2021 start
        if "Job No." <> '' then begin
            if Jobs.Get("Job No.") then
                "NS_Contract Forecast Date" := Jobs."NS_Contract Date";//PRJ-1468.GK.1.0 12July2022
            Validate("NS_Use Tax Percentage", Jobs."NS_Use Tax Percentage");
        end;
        //PRJ-929.GK.1.0 22Sep2021 end   
    end;

    trigger OnModify();
    var
        Jobs: Record Job;
        NS_JobSetup: Record "Jobs Setup"; //PE-273.JS.1.0 15MAR2024       
    begin
        if NS_JobSetup.get() then;   //PE-273.JS.1.0 15MAR2024
        //ProjectPro - start
        Job.NS_JobTaskNoToAPO("Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        NS_TempNo := "No.";
        NS_TempLocation := "Location Code";
        NS_TempVariant := "Variant Code";
        NS_TempUM := "Unit of Measure Code";
        NS_TempWorkType := "Work Type Code";
        NS_TempSkillClass := "NS_Skill Class";
        if NS_JobQuoteLine.GET(Rec."NS_Quote No.", Rec."NS_Quote Line No.") then begin
            NS_JobQuoteLine."NS_Location Code" := "Location Code";
            NS_JobQuoteLine.MODIFY;
        end;
        "NS_Copied to JMP" := false;
        //ProjectPro - end
        //PRJ-913.JS.1.0 15Sep2021-Start
        If Rec."Line No." <> 0 then begin
            NS_JobTskLins.get(Rec."Job No.", "Job Task No.");
            //PRJ-1015.JS.1.0 10Oct2021 - Start
            //PE-273.JS.1.0 15MAR2024 - start
            if NS_JobSetup."NS_Enable Change Dim. on JPL" = false then begin
                Rec.Validate("NS_Shortcut Dimension 1 Code", NS_JobTskLins."Global Dimension 1 Code");
                Rec.Validate("NS_Shortcut Dimension 2 Code", NS_JobTskLins."Global Dimension 2 Code");
            end;
            //PE-273.JS.1.0 15MAR2024 - end
            //PRJ-1015.JS.1.0 10Oct2021 - Start
            If Jobs.Get(rec."Job No.") then begin
                Rec."NS_Sub-Level to Job No." := Jobs."NS_Sub-Level to Job No.";
                Rec."NS_Ext Reference No." := Jobs."No."; //PRJCTPR-147.PS.2.0 20Sep2023
                Rec."NS_Job Quote No." := Jobs."No."; //PE-221.NC.1.0 07Mar2024

            end;
            //PRJ-1015.JS.1.0 10Oct2021 - Start             
        end;
        //PRJ-913.JS.1.0 15Sep2021-end  

        //PRJ-929.GK.1.0 22Sep2021 start
        if "Job No." <> '' then begin
            if Jobs.Get("Job No.") then
                Validate("NS_Use Tax Percentage", Jobs."NS_Use Tax Percentage");
        end;
        //PRJ-929.GK.1.0 22Sep2021 end     
    end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
        GetLinkedResourceEditable: Boolean;//PRJ-568
        Res: Record Resource;
        StandardText: Record "Standard Text";
        Job: Record Job;
        NS_ResourceGroup: Record "Resource Group";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        NS_TempJobPlanningLine1: Record "Job Planning Line" temporary;
        NS_TempJobPlanningLine2: Record "Job Planning Line" temporary;
        NS_JobsSetup: Record "Jobs Setup";
        NS_Subcontract: Record NS_Subcontract;
        NS_DimMgt: Codeunit DimensionManagement;
        NS_PurchPrcCalcMngt: Codeunit "Purch. Price Calc. Mgt.";
        NS_JobTskLins: Record "Job Task";     //PRJ-913.JS.1.0 15Sep2021
        NS_JobNo: Code[20];
        NS_Type: Option " ",Resource,Item,"G/L Account",Text,"Resource (Group)";
        NS_JobTask: Code[20];
        Text14021100: Label '%1 must be set to %2 or %3.';
        Text14021103: Label 'A cost category cannot be entered on a Contract type line.';
        Text14021104: Label 'There must be a cost category for job %1 on line %2.';
        Text14021105: Label 'A revenue category cannot be entered on a Schedule type line.';
        Text14021106: Label 'There must be a revenue category for job %1 on line %2.';
        Text14021107: Label 'Rate Type cannot be assigned to Contract lines.';
        Text14021108: Label 'There is no Subcontract %1.';
        Text14021109: Label 'Progress Billing Method cannot be assigned to Budget lines.';
        Text14021110: Label 'Warning!\The indicators for transferring and posting this line as an invoice are about to be cleared.\This line will have to be re-invoiced once this is done.\Are you sure this is what you want to do?';
        Text14021112: Label 'There is more than one Unit of Measure of this item.\The subcontract Work Units must be modified manually.';
        Text14021113: Label 'There is more then one line in this subcontract that would be affected.\The subcontract must be modified manually.';
        Text14021400: Label 'This will update all Planning Lines for this Job %1.\Do you Wish to Continue?';
        Text14021401: Label 'This will update the Planning Lines for Job %1 Task %2.\Do you Wish to Continue?';
        Text14021402: Label 'Segment Code %1 does not exist for Job %2';
        NS_Text14021403: Label 'Use Tax is not applicable on Billable line';//PRJ-929.GK.1.0
        NS_UseJobPlanningBoolean: Boolean;
        NS_JobQuoteLine: Record "NS_Job Quote Line";
        CurrExchRate: Record "Currency Exchange Rate";
        UnitAmountRoundingPrecision: Decimal;
        AmountRoundingPrecision: Decimal;
        UnitAmountRoundingPrecisionFCY: Decimal;
        AmountRoundingPrecisionFCY: Decimal;
        BypassQtyValidation: Boolean;
        SKU: Record "Stockkeeping Unit";
        ResCost: Record "Resource Cost";

    procedure NS_ModifySubcontract(FunctionZ: Option Add,Modify,Delete; var Rec: Record "Job Planning Line"; xRec: Record "Job Planning Line")
    var
        NS_SubcontractDetail: Record "NS_Subcontract Lines";
        NS_NewLineNo: Integer;
    begin
        //ProjectPro - start
        with NS_SubcontractDetail do begin
            case FunctionZ of
                FunctionZ::Add:
                    begin
                        Reset;
                        SetCurrentKey("NS_Subcontract No.", "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                        SetRange("NS_Subcontract No.", Rec."NS_Subcontract No.");
                        SetRange("NS_Job No.", Rec."Job No.");
                        SetRange("NS_Activity Code", Rec."NS_Activity Code");
                        SetRange("NS_Process Code", Rec."NS_Process Code");
                        SetRange("NS_Operation Code", Rec."NS_Operation Code");
                        SetRange("NS_Job Cost Category", Rec."NS_Cost Category");
                        case Count of
                            0:
                                begin
                                    Reset;
                                    SetRange("NS_Subcontract No.", Rec."NS_Subcontract No.");
                                    if FindLast then
                                        NS_NewLineNo := "Line No." + 10000
                                    else
                                        NS_NewLineNo := 10000;
                                    Init;
                                    "NS_Subcontract No." := Rec."NS_Subcontract No.";
                                    "NS_Line No." := NS_NewLineNo;
                                    "NS_Job No." := Rec."Job No.";
                                    "NS_Activity Code" := Rec."NS_Activity Code";
                                    "NS_Process Code" := Rec."NS_Process Code";
                                    "NS_Operation Code" := Rec."NS_Operation Code";
                                    "NS_Job Cost Category" := Rec."NS_Cost Category";
                                    NS_Description := Rec.Description;
                                    NS_Quantity := Rec.Quantity;
                                    "NS_Work Units" := Rec."NS_Work Units";
                                    "NS_Work Unit of Measure" := Rec."NS_Work Unit of Measure";
                                    Insert;
                                    Rec."NS_Subcontract Line No." := NS_NewLineNo;
                                end;
                            1:
                                begin
                                    FindFirst;
                                    Quantity := Quantity + Rec.Quantity;
                                    if "NS_Work Unit of Measure" = Rec."NS_Work Unit of Measure" then
                                        "NS_Work Units" := "NS_Work Units" + Rec."NS_Work Units"
                                    else
                                        Message(Text14021112);
                                    Modify;
                                end;
                            else
                                Message(Text14021113);
                        end;
                    end;
                FunctionZ::Modify:
                    begin
                        NS_ModifySubcontract(2, Rec, xRec);
                        NS_ModifySubcontract(0, Rec, xRec);
                    end;
                FunctionZ::Delete:
                    begin
                        Reset;
                        SetRange("NS_Subcontract No.", xRec."NS_Subcontract No.");
                        SetRange("NS_Line No.", xRec."NS_Subcontract Line No.");
                        case Count of
                            0:
                                ;
                            1:
                                begin
                                    FindFirst;
                                    Delete;
                                end;
                            else
                                Message(Text14021113);
                        end;
                    end;
            end;
        end;
        //ProjectPro - end
    end;

    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //ProjectPro - start
        NS_DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "NS_Dimension Set ID");
        //ProjectPro - end
    end;

    procedure CreateSOVContractLines(var NS_JobPlanningLine: Record "Job Planning Line"; NS_ContractJobNo: Code[20])
    var
        Text14021200: Label 'No entry could be found with %1 = Contract';
        Text14021201: Label 'The %1 on the Contract line must be greater than 0.';
        NS_ContractAmount: Decimal;
        NS_NextContractLineNo: Integer;
        NS_APOLinksLine: Record "NS_APO Links Line";
        NS_TEMPJobOperation: Record "NS_Job Operation" temporary;
        NS_LinkedTotalCost: Decimal;
        NS_TEMPJobPlanningLine: Record "Job Planning Line" temporary;
        Text14021202: Label 'Do you want to create SOV Contract lines?';
        Text14021203: Label 'There is no APO Link setup for Job %1.';
        NS_GLSetup: Record "General Ledger Setup";
    begin
        //ProjectPro - start

        //Find and remove existing Contract line
        NS_JobPlanningLine.Reset;
        NS_JobPlanningLine.SetCurrentKey("Job No.", "NS_Subcontract No.", "Line Type");
        NS_JobPlanningLine.SetRange("Job No.", NS_ContractJobNo);
        NS_JobPlanningLine.SetRange("NS_Subcontract No.", '');
        NS_JobPlanningLine.SetRange("Line Type", NS_JobPlanningLine."Line Type"::Billable);
        if not NS_JobPlanningLine.FindFirst then
            Error(Text14021200, NS_JobPlanningLine.FieldCaption("Line Type"));
        if NS_JobPlanningLine."Line Amount (LCY)" = 0 then
            Error(Text14021201, NS_JobPlanningLine.FieldCaption("Line Amount"));
        NS_APOLinksLine.Reset;
        NS_APOLinksLine.SetRange(NS_Type, NS_APOLinksLine.NS_Type::Job);
        NS_APOLinksLine.SetRange(NS_Code, NS_ContractJobNo);
        if not NS_APOLinksLine.FindFirst then
            Error(Text14021203, NS_ContractJobNo);

        if Confirm(Text14021202, false) then begin
            NS_GLSetup.Get;
            NS_ContractAmount := NS_JobPlanningLine."Line Amount";
            NS_TEMPJobPlanningLine.TransferFields(NS_JobPlanningLine, false);
            NS_JobPlanningLine.Delete(true);
            if NS_JobPlanningLine.FindLast then
                NS_NextContractLineNo := NS_JobPlanningLine."Line No." + 10000
            else
                NS_NextContractLineNo := 10000;

            //Accumulate Revenue totals
            NS_LinkedTotalCost := 0;
            NS_TEMPJobOperation.DeleteAll;
            NS_JobPlanningLine.Reset;
            NS_JobPlanningLine.SetCurrentKey("Job No.", "NS_Subcontract No.", "Line Type");
            NS_JobPlanningLine.SetRange("Job No.", NS_ContractJobNo);
            NS_JobPlanningLine.SetRange("NS_Subcontract No.", '');
            NS_JobPlanningLine.SetRange("Line Type", NS_JobPlanningLine."Line Type"::Budget);
            if NS_JobPlanningLine.FindSet then
                repeat
                    if NS_JobPlanningLine."Total Cost" <> 0 then begin
                        NS_APOLinksLine.Reset;
                        NS_APOLinksLine.SetRange(NS_Type, NS_APOLinksLine.NS_Type::Job);
                        NS_APOLinksLine.SetRange(NS_Code, NS_ContractJobNo);
                        NS_APOLinksLine.SetRange("NS_Source Type", NS_APOLinksLine."NS_Source Type"::Cost);
                        NS_APOLinksLine.SetRange("NS_Source Activity Code", NS_JobPlanningLine."NS_Activity Code");
                        NS_APOLinksLine.SetRange("NS_Source Process Code", NS_JobPlanningLine."NS_Process Code");
                        NS_APOLinksLine.SetRange("NS_Source Operation Code", NS_JobPlanningLine."NS_Operation Code");
                        if NS_APOLinksLine.FindFirst then
                            if not NS_TEMPJobOperation.Get(NS_TEMPJobOperation.NS_Type::Revenue, NS_APOLinksLine."NS_Destination Activity Code",
                                                           NS_APOLinksLine."NS_Destination Process Code", NS_APOLinksLine."NS_Destination Operation Code") then begin
                                NS_TEMPJobOperation.Init;
                                NS_TEMPJobOperation.NS_Type := NS_TEMPJobOperation.NS_Type::Revenue;
                                NS_TEMPJobOperation."NS_Activity Code" := NS_APOLinksLine."NS_Destination Activity Code";
                                NS_TEMPJobOperation."NS_Process Code" := NS_APOLinksLine."NS_Destination Process Code";
                                NS_TEMPJobOperation.NS_Code := NS_APOLinksLine."NS_Destination Operation Code";
                                NS_TEMPJobOperation."NS_DefaultProjectBurdenPercent" := NS_JobPlanningLine."Total Cost";
                                NS_LinkedTotalCost += NS_JobPlanningLine."Total Cost";
                                NS_TEMPJobOperation.Insert;
                            end else begin
                                NS_TEMPJobOperation."NS_DefaultProjectBurdenPercent" += NS_JobPlanningLine."Total Cost";
                                NS_LinkedTotalCost += NS_JobPlanningLine."Total Cost";
                                NS_TEMPJobOperation.Modify;
                            end;
                    end;
                until NS_JobPlanningLine.Next = 0;

            //Create SOV contract lines
            NS_TEMPJobOperation.Reset;
            if NS_TEMPJobOperation.FindSet then
                repeat
                    NS_JobPlanningLine.Init;
                    NS_JobPlanningLine.TransferFields(NS_TEMPJobPlanningLine);
                    NS_JobPlanningLine."Job No." := NS_ContractJobNo;
                    NS_JobPlanningLine."Job Task No." := NS_TEMPJobOperation."NS_Activity Code";
                    NS_JobPlanningLine."Line No." := NS_NextContractLineNo;
                    NS_JobPlanningLine.Description := NS_TEMPJobOperation."NS_Activity Code";
                    NS_JobPlanningLine.Validate("Unit Price", Round(((NS_TEMPJobOperation."NS_DefaultProjectBurdenPercent" / NS_LinkedTotalCost) * NS_ContractAmount),
                                                                   NS_GLSetup."Amount Rounding Precision"));
                    NS_JobPlanningLine.Insert(true);
                    NS_NextContractLineNo += 10000;
                until NS_TEMPJobOperation.Next = 0;
        end;
        NS_JobPlanningLine.Reset;
        NS_JobPlanningLine.SetCurrentKey("Job No.", "NS_Entry Type", "Job Task No.", "NS_Cost Category", "NS_Revenue Category", Type, "No.", "Variant Code");
        NS_JobPlanningLine.SetRange("Job No.", NS_ContractJobNo);
        //ProjectPro - end
    end;

    procedure NS_UpdateLineAmount()
    begin
        //ProjectPro - start
        if "Total Price" <> 0 then begin
            InitRoundingPrecisions();//PRJ-158 VT 13-03-20
            "Line Discount Amount" := Round("Total Price" * "Line Discount %" / 100, AmountRoundingPrecisionFCY);
            "Line Amount" := "Total Price" - "Line Discount Amount";
            "Line Amount (LCY)" := Round(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Currency Date", "Currency Code",
                "Line Amount", "Currency Factor"),
              AmountRoundingPrecision);

            "Line Discount Amount (LCY)" := Round(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Currency Date", "Currency Code",
                "Line Discount Amount", "Currency Factor"),
              AmountRoundingPrecision);
        end;
        //ProjectPro - end
    end;

    procedure UpdateJobPlan(lJobNo: Code[20])
    var
        PPJobPlanLine: Record "Job Planning Line";
        PPJobSegEnt: Record "NS_Job Takeoff Segment Entry";
        QuoteLine: Record "NS_Job Quote Line";
    begin
        if not Confirm(StrSubstNo(Text14021400, lJobNo)) then
            exit;
        PPJobSegEnt.SetCurrentKey("NS_Job No.");
        PPJobSegEnt.SetRange("NS_Job No.", lJobNo);
        PPJobSegEnt.SetRange(NS_Certified, false);
        if PPJobSegEnt.FindSet(true, false) then
            repeat
                PPJobPlanLine.Reset;
                PPJobPlanLine.SetRange("Job No.", PPJobSegEnt."NS_Job No.");
                PPJobPlanLine.SetRange("Job Task No.", PPJobSegEnt."NS_Job Task No.");
                PPJobPlanLine.SetRange("Line No.", PPJobSegEnt."NS_Line No.");
                PPJobPlanLine.SetRange(Type, PPJobSegEnt.NS_Type);
                PPJobPlanLine.SetRange("No.", PPJobSegEnt."NS_No.");
                if PPJobPlanLine.FindFirst then begin
                    GetJobSegEntQty(PPJobPlanLine);
                    NS_PurchPrcCalcMngt.FindJobPlanningLinePrice(PPJobPlanLine, FieldNo(Quantity));
                    PPJobPlanLine."Total Cost (LCY)" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Cost (LCY)";
                    PPJobPlanLine."Total Price (LCY)" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Price (LCY)";
                    PPJobPlanLine."Total Cost" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Cost";
                    PPJobPlanLine."Total Price" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Price";
                    PPJobPlanLine.Modify;
                end;
                PPJobSegEnt.NS_Certified := true;
                PPJobSegEnt.Modify;
                if PPJobSegEnt.NS_Type <= 2 then begin
                    QuoteLine.Reset;
                    QuoteLine.SetRange("NS_Quote No.", PPJobSegEnt."NS_Job No.");
                    QuoteLine.SetRange("NS_Job Task No.", PPJobSegEnt."NS_Job Task No.");
                    QuoteLine.SetRange(NS_Type, PPJobSegEnt.NS_Type);
                    QuoteLine.SetRange("NS_No.", PPJobSegEnt."NS_No.");
                    if QuoteLine.FindFirst then begin
                        QuoteLine.NS_Quantity := GetJobSegEntQty(PPJobPlanLine);
                        QuoteLine.Modify;
                    end;
                end;
            until PPJobSegEnt.Next = 0;
    end;

    local procedure GetJobSegEntQty(var PPJobPlanLine: Record "Job Planning Line"): Decimal
    var
        PPJobSegEnt: Record "NS_Job Takeoff Segment Entry";
    begin
        with PPJobPlanLine do begin
            PPJobSegEnt.SetCurrentKey("NS_Job No.", "NS_Job Task No.");
            PPJobSegEnt.SetRange("NS_Job No.", "Job No.");
            PPJobSegEnt.SetRange("NS_Job Task No.", "Job Task No.");
            PPJobSegEnt.SetRange(NS_Type, Type);
            PPJobSegEnt.SetRange("NS_No.", "No.");
            PPJobSegEnt.SetRange("NS_Line No.", "Line No.");
            PPJobSegEnt.CalcSums("NS_Segment Quantity");
            if NS_Welding then
                Quantity := PPJobSegEnt."NS_Segment Quantity" * "NS_Weld Time (Hours)"
            else
                Quantity := PPJobSegEnt."NS_Segment Quantity";
            Modify;
        end;
    end;

    local procedure GetItemWeldInfo()
    var
        lItem: Record Item;
        lJobPlanLine: Record "Job Planning Line";
    begin
        if Type <> Type::Item then
            exit;
        if not lItem.Get("No.") then
            exit;
        if Quantity = 0 then begin
            if (lItem."NS_No. of Welds" <> 0) and (lItem.NS_Size <> 0) then begin
                NS_Welding := true;
                "NS_Size of Weld" := lItem.NS_Size;
                "NS_Weld Time (Hours)" := lItem."NS_Labor Hours per Qty.";
            end;
        end else begin
            if (lItem."NS_No. of Welds" <> 0) and (lItem.NS_Size <> 0) then begin
                NS_Welding := true;
                "NS_Size of Weld" := lItem.NS_Size;
                "NS_Weld Time (Hours)" := lItem."NS_Labor Hours per Qty." * Quantity;
                "NS_Total Number of Welds" := lItem."NS_No. of Welds" * Quantity;
                Modify;
            end;
            lJobPlanLine.Reset;
            lJobPlanLine.SetRange("NS_Defaulted Entry", true);
            //lJobPlanLine.SETRANGE("Job No.","Job No.");
            if lJobPlanLine.FindSet(true, false) then
                repeat
                    lJobPlanLine.Quantity += lItem."NS_Labor Hours per Qty." * Quantity;
                    lJobPlanLine."Total Cost" += lJobPlanLine."Unit Cost" * lJobPlanLine.Quantity;
                    lJobPlanLine."Line Amount" += lJobPlanLine."Unit Price" * lJobPlanLine.Quantity;
                    lJobPlanLine."Total Cost (LCY)" += lJobPlanLine."Unit Cost (LCY)" * lJobPlanLine.Quantity;
                    lJobPlanLine."Line Amount (LCY)" += lJobPlanLine."Unit Price (LCY)" * lJobPlanLine.Quantity;
                    lJobPlanLine.Modify;
                until lJobPlanLine.Next = 0;
        end;
    end;

    procedure UpdateDefaultPlanLine()
    var
        lJobPlanLine: Record "Job Planning Line";
        lJobPlanLine2: Record "Job Planning Line";
        lItem: Record Item;
        lResource: Record Resource;
        lJobSegEnt: Record "NS_Job Takeoff Segment Entry";
        lQuantity: Decimal;
    begin
        lJobSegEnt.Reset;
        lJobSegEnt.SetRange("NS_Job No.", NS_JobNo);
        if NS_Type <> 0 then
            lJobSegEnt.SetRange(NS_Type, NS_Type - 1);
        if NS_JobTask <> '' then
            lJobSegEnt.SetRange("NS_Job Task No.", NS_JobTask);
        if lJobSegEnt.FindSet(false, false) then begin
            lJobSegEnt.CalcSums("NS_Segment Quantity");
            if lJobSegEnt.NS_Type = lJobSegEnt.NS_Type::Item then begin
                if lItem.Get(lJobSegEnt."NS_No.") then begin
                    lQuantity += lItem."NS_Labor Hours per Qty." * lJobSegEnt."NS_Segment Quantity";
                end;
            end else begin
                lQuantity += lJobSegEnt."NS_Segment Quantity";
            end;
        end;

        lJobPlanLine.Reset;
        lJobPlanLine.SetRange("Job No.", NS_JobNo);
        lJobPlanLine.SetRange("NS_Defaulted Entry", true);
        if lJobPlanLine.FindSet(true, false) then
            repeat
                lJobPlanLine.Validate(Quantity, lQuantity);
                lJobPlanLine.Modify;
            until lJobPlanLine.Next = 0;
    end;

    procedure InitVar(lJobNo: Code[20]; lType: Option " ",Resource,Item,"G/L Account",Text,"Resource (Group)"; lJobTask: Code[20])
    begin
        NS_JobNo := lJobNo;
        NS_Type := lType;
        NS_JobTask := lJobTask;
    end;

    procedure UpdateGrossProfit()
    var
        test: Record 1003;
    begin
        //PRJ-850.MS.1.0 comment start
        // if "Total Price" <> 0 then begin
        //     "NS_Gross Profit" := "Total Price" - "Total Cost";
        //     "NS_Gross Profit Percentage" := (1 - "Total Cost" / "Total Price") * 100;
        //PRJ-850.MS.1.0 comment start
        //PRJ-850.MS.1.0 start
        IF Rec."Line No." <> 0 then begin    //PRJ-936.JS.1.0 23Sep2021 Line added
            if "Line Amount" <> 0 then begin
                "NS_Gross Profit" := 0;
                "NS_Gross Profit Percentage" := 0;
                "NS_Gross Profit" := "Line Amount" - "Total Cost";
                "NS_Gross Profit Percentage" := (1 - "Total Cost" / "Line Amount") * 100;
                //Modify();   //PRJ-936.JS.1.0 23Sep2021 line commencted
                //PRJ-850.MS.1.0 start
            end else begin
                if "Unit Price" <> 0 then begin
                    "NS_Gross Profit" := 0;
                    "NS_Gross Profit Percentage" := 0;
                    "NS_Gross Profit" := "Unit Price" - "Unit Cost";
                    "NS_Gross Profit Percentage" := (1 - "Unit Cost" / "Unit Price") * 100;
                    //PRJ-936.JS.1.0 23Sep2021-Start
                end else begin
                    "NS_Gross Profit" := 0;
                    "NS_Gross Profit Percentage" := 0;
                end;
                //PRJ-936.JS.1.0 23Sep2021-end
            end;
        end;  //PRJ-936.JS.1.0 23Sep2021-line added

    end;

    procedure CreatePlanfromTakeOff(lJobNo: Code[20]; lJobTask: Code[20])
    var
        PPJobPlanLine: Record "Job Planning Line";
        PPJobSegEnt: Record "NS_Job Takeoff Segment Entry";
        QuoteLine: Record "NS_Job Quote Line";
        LineNo: Integer;
        PPJobSegment: Record "NS_Job Takeoff Segments";
        LineCt: Integer;
        PPlJobPlanLine: Record "Job Planning Line";
        tmpPPJobPlanLine: Record "Job Planning Line" temporary;
        TrueFalse: Boolean;
        q: Integer;
    begin
        if not Confirm(StrSubstNo(Text14021401, lJobNo, lJobTask)) then
            exit;

        PPlJobPlanLine.SetRange("Job No.", lJobNo);
        if lJobTask <> '' then
            PPlJobPlanLine.SetRange("Job Task No.", lJobTask);
        PPlJobPlanLine.SetRange("NS_Matrix Updated", false);
        //LineCt := PPlJobPlanLine.COUNT;
        if PPlJobPlanLine.FindSet(true, true) then
            repeat
                TrueFalse := false;
                PPJobSegEnt.Reset;
                PPJobSegEnt.SetRange("NS_Job No.", lJobNo);
                PPJobSegEnt.SetRange("NS_Job Task No.", PPlJobPlanLine."Job Task No.");
                PPJobSegEnt.SetRange(NS_Type, PPlJobPlanLine.Type);
                PPJobSegEnt.SetRange("NS_No.", PPlJobPlanLine."No.");
                PPJobSegEnt.SetRange(NS_Certified, false);
                if PPJobSegEnt.FindSet(true, false) then begin
                    TrueFalse := true;
                    repeat
                        LineCt += 1;
                        tmpPPJobPlanLine.Init;
                        tmpPPJobPlanLine := PPlJobPlanLine;
                        tmpPPJobPlanLine."Line No." := LineCt * 10000;
                        tmpPPJobPlanLine.Quantity := PPJobSegEnt."NS_Segment Quantity";
                        tmpPPJobPlanLine."NS_Segment Code" := PPJobSegEnt."NS_Segment Code";
                        tmpPPJobPlanLine."NS_Matrix Updated" := true;
                        PPJobSegment.Reset;
                        PPJobSegment.SetRange("NS_Job No.", PPJobSegEnt."NS_Job No.");
                        PPJobSegment.SetRange("NS_Segment Code", PPJobSegEnt."NS_Segment Code");
                        if PPJobSegment.FindFirst then
                            tmpPPJobPlanLine."NS_Segment Name" := PPJobSegment."NS_Segment Name"
                        else
                            tmpPPJobPlanLine."NS_Segment Name" := Format(PPJobSegEnt."NS_Segment Code");
                        if tmpPPJobPlanLine.Insert then begin
                            PPJobSegEnt.NS_Certified := true;
                            PPJobSegEnt.Modify;
                        end else begin
                            if tmpPPJobPlanLine.Modify then begin
                                PPJobSegEnt.NS_Certified := true;
                                PPJobSegEnt.Modify;
                            end;
                        end;
                    until PPJobSegEnt.Next = 0;
                end else begin
                    LineCt += 1;
                    tmpPPJobPlanLine.Init;
                    tmpPPJobPlanLine := PPlJobPlanLine;
                    tmpPPJobPlanLine."Line No." := LineCt * 10000;
                    if tmpPPJobPlanLine.Insert then;
                end;
            until PPlJobPlanLine.Next = 0;

        PPlJobPlanLine.Reset;
        PPlJobPlanLine.SetRange("Job No.", lJobNo);
        if lJobTask <> '' then
            PPlJobPlanLine.SetRange("Job Task No.", lJobTask);
        PPlJobPlanLine.SetRange("NS_Matrix Updated", false);
        PPlJobPlanLine.DeleteAll;

        tmpPPJobPlanLine.Reset;
        if tmpPPJobPlanLine.FindSet(false, false) then
            repeat
                PPJobPlanLine.Init;
                PPJobPlanLine := tmpPPJobPlanLine;
                PPJobPlanLine.Insert;
                NS_PurchPrcCalcMngt.FindJobPlanningLinePrice(PPJobPlanLine, FieldNo(Quantity));
                PPJobPlanLine."Total Cost (LCY)" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Cost (LCY)";
                PPJobPlanLine."Total Price (LCY)" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Price (LCY)";
                PPJobPlanLine."Total Cost" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Cost";
                PPJobPlanLine."Total Price" := PPJobPlanLine.Quantity * PPJobPlanLine."Unit Price";
                PPJobPlanLine."Line Amount" := PPJobPlanLine."Total Price";
                PPJobPlanLine.Modify;
                q := q;

            until tmpPPJobPlanLine.Next = 0;
    end;

    local procedure InsertSegmentEntry()
    var
        SegmentEntry: Record "NS_Job Takeoff Segment Entry";
        JobSetup: Record "Jobs Setup"; //PRJ-291.MS.1.0
    begin
        if JobSetup.Get() then; //PRJ-291.MS.1.0
        if JobSetup."NS_Get Job Segment" then begin //PRJ-291.MS.1.0
            SegmentEntry.Init;
            SegmentEntry."NS_Job No." := "Job No.";
            SegmentEntry."NS_Job Task No." := "Job Task No.";
            SegmentEntry.NS_Type := Type;
            SegmentEntry."NS_No." := "No.";
            SegmentEntry."NS_Segment Code" := "NS_Segment Code";
            SegmentEntry."NS_Segment Quantity" := Quantity;
            SegmentEntry.NS_Certified := true;
            SegmentEntry."NS_Line No." := "Line No.";
            SegmentEntry.Insert;
        end;
    end;

    local procedure UpdateSegmentEntry()
    var
        SegmentEntry: Record "NS_Job Takeoff Segment Entry";
        SegmentEntry2: Record "NS_Job Takeoff Segment Entry" temporary;
        JobSetup: Record "Jobs Setup"; //PRJ-291.MS.1.0
    begin
        if JobSetup.Get() then; //PRJ-291.MS.1.0
        if JobSetup."NS_Get Job Segment" then begin //PRJ-291.MS.1.0
            case CurrFieldNo of
                FieldNo(Type),
              FieldNo("No."),
              FieldNo("NS_Segment Code"):
                    if SegmentEntry.Get("Job No.", "Job Task No.", Type, "No.", "NS_Segment Code") then begin
                        SegmentEntry2 := SegmentEntry;
                        //SegmentEntry2.Rename("Job No.", "Job Task No.", Type, "No.", "NS_Segment Code");//PRJ-704.N.S.1.0 Comment
                        SegmentEntry.Rename("Job No.", "Job Task No.", Type, "No.", "NS_Segment Code"); //PRJ-704.N.S.1.0
                    end;
                FieldNo(Quantity):
                    begin
                        if SegmentEntry.Get("Job No.", "Job Task No.", Type, "No.", "NS_Segment Code") then begin
                            SegmentEntry."NS_Segment Quantity" := Quantity;
                            SegmentEntry.Modify;
                        end;
                    end;
            end;
        end;
    end;

    procedure NS_CalcScheduleofValues(var lJobQuote: Record "NS_Job Quote Header")
    var
        lPlanningLine: Record "Job Planning Line";
        lPlanningLine2: Record "Job Planning Line";
        lTask: Record "Job Task";
        TotalScheduledPrice: Decimal;
        LastTask: Code[20];
        x: Integer;
        LineNo: Integer;
        ScheduleDescription: array[6] of Text[50];
        SchedulePercentage: array[6] of Decimal;
        ScheduleAmount: array[6] of Decimal;
        SOVTask: Record "Job Task";
        JobNo: Code[20];
        InsertTotalTask: Boolean;
    begin
        JobNo := lJobQuote."NS_Quote No.";
        NS_JobsSetup.Get;
        lPlanningLine2.SetRange("Job No.", JobNo);
        if lPlanningLine2.FindLast then
            LineNo := lPlanningLine2."Line No." + 10000
        else
            LineNo := 10000;
        lPlanningLine.Reset;

        lTask.SetRange("Job No.", JobNo);
        lTask.SetFilter("Job Task Type", '%1|%2', lTask."Job Task Type"::"End-Total", lTask."Job Task Type"::Total);
        lTask.SetRange("Job Task No.", NS_JobsSetup."NS_Total Task No.");
        if lTask.FindLast then begin
            TotalScheduledPrice := lJobQuote."NS_Total Contract Price";
            LastTask := lTask."Job Task No.";
        end else
            Error('No End-Total Task Found!');

        if SchedOfValuesExist(JobNo) then
            ReCalcSchedOfValues(JobNo, TotalScheduledPrice)
        else begin
            ScheduleDescription[1] := lJobQuote."NS_Schedule 1 Description";
            SchedulePercentage[1] := lJobQuote."NS_Schedule 1 Percentage";
            ScheduleDescription[2] := lJobQuote."NS_Schedule 2 Description";
            SchedulePercentage[2] := lJobQuote."NS_Schedule 2 Percentage";
            ScheduleDescription[3] := lJobQuote."NS_Schedule 3 Description";
            SchedulePercentage[3] := lJobQuote."NS_Schedule 3 Percentage";
            ScheduleDescription[4] := lJobQuote."NS_Schedule 4 Description";
            SchedulePercentage[4] := lJobQuote."NS_Schedule 4 Percentage";
            ScheduleDescription[5] := lJobQuote."NS_Schedule 5 Description";
            SchedulePercentage[5] := lJobQuote."NS_Schedule 5 Percentage";
            ScheduleDescription[6] := lJobQuote."NS_Schedule 6 Description";
            SchedulePercentage[6] := lJobQuote."NS_Schedule 6 Percentage";

            lPlanningLine2.Reset;
            lPlanningLine2.SetRange("Job No.", JobNo);
            lPlanningLine2.SetRange("NS_Progress Billing Line", true);
            if not lPlanningLine2.FindFirst then begin
                for x := 1 to 6 do begin
                    if SchedulePercentage[x] <> 0 then begin
                        InsertTotalTask := true;
                        lPlanningLine.Init;
                        lPlanningLine."Job No." := JobNo;
                        lPlanningLine."Job Task No." := LastTask + '-' + Format(x);
                        lPlanningLine."Line No." := LineNo;
                        lPlanningLine."NS_Entry Type" := lPlanningLine."NS_Entry Type"::Price;
                        lPlanningLine."Line Type" := lPlanningLine."Line Type"::Billable;
                        lPlanningLine."Contract Line" := true;
                        lPlanningLine."Planning Date" := lPlanningLine2."Planning Date";
                        lPlanningLine."Document No." := lPlanningLine2."Document No.";
                        lPlanningLine.Type := lPlanningLine.Type::"G/L Account";
                        lPlanningLine."No." := NS_JobsSetup."NS_ProgressBillingDefG/L Act.";
                        lPlanningLine.Quantity := 1;
                        lPlanningLine.Description := ScheduleDescription[x];
                        lPlanningLine."Unit Price" := (SchedulePercentage[x] / 100) * TotalScheduledPrice;
                        lPlanningLine."Total Price" := (SchedulePercentage[x] / 100) * TotalScheduledPrice;
                        lPlanningLine."Line Amount (LCY)" := lPlanningLine."Total Price";
                        ScheduleAmount[x] := (SchedulePercentage[x] / 100) * TotalScheduledPrice;
                        lPlanningLine."NS_Progress Billing Line" := true;
                        lPlanningLine."Schedule Line" := false;
                        if not lPlanningLine.Insert then
                            lPlanningLine.Modify;
                        LineNo += 10000;
                        SOVTask.Reset;
                        SOVTask.Init;
                        SOVTask."Job No." := JobNo;
                        SOVTask."Job Task No." := LastTask + '-' + Format(x);
                        SOVTask.Description := ScheduleDescription[x];
                        SOVTask."Job Task Type" := SOVTask."Job Task Type"::Posting;
                        if not SOVTask.Insert then
                            SOVTask.Modify;
                        lJobQuote."NS_Schedule 1 Task" := LastTask + '-' + Format(x);
                        lJobQuote."NS_Schedule 2 Task" := LastTask + '-' + Format(x);
                        lJobQuote."NS_Schedule 3 Task" := LastTask + '-' + Format(x);
                        lJobQuote."NS_Schedule 4 Task" := LastTask + '-' + Format(x);
                        lJobQuote."NS_Schedule 5 Task" := LastTask + '-' + Format(x);
                        lJobQuote."NS_Schedule 6 Task" := LastTask + '-' + Format(x);
                        lJobQuote.Modify;
                    end;
                end;
                lJobQuote."NS_Schedule 1 Amount" := ScheduleAmount[1];
                lJobQuote."NS_Schedule 2 Amount" := ScheduleAmount[2];
                lJobQuote."NS_Schedule 3 Amount" := ScheduleAmount[3];
                lJobQuote."NS_Schedule 4 Amount" := ScheduleAmount[4];
                lJobQuote."NS_Schedule 5 Amount" := ScheduleAmount[5];
                lJobQuote."NS_Schedule 6 Amount" := ScheduleAmount[6];
                lJobQuote."NS_Schedule 1 Task" := LastTask + '-' + Format(1);
                lJobQuote."NS_Schedule 2 Task" := LastTask + '-' + Format(2);
                lJobQuote."NS_Schedule 3 Task" := LastTask + '-' + Format(3);
                lJobQuote."NS_Schedule 4 Task" := LastTask + '-' + Format(4);
                lJobQuote."NS_Schedule 5 Task" := LastTask + '-' + Format(5);
                lJobQuote."NS_Schedule 6 Task" := LastTask + '-' + Format(6);
                lJobQuote.Modify;
            end else begin
                lJobQuote."NS_Schedule 1 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 1 Percentage" / 100));
                lJobQuote."NS_Schedule 2 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 2 Percentage" / 100));
                lJobQuote."NS_Schedule 3 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 3 Percentage" / 100));
                lJobQuote."NS_Schedule 4 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 4 Percentage" / 100));
                lJobQuote."NS_Schedule 5 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 5 Percentage" / 100));
                lJobQuote."NS_Schedule 6 Amount" := Round(TotalScheduledPrice * (lJobQuote."NS_Schedule 6 Percentage" / 100));
                lJobQuote."NS_Schedule 1 Task" := LastTask + '-' + Format(1);
                lJobQuote."NS_Schedule 2 Task" := LastTask + '-' + Format(2);
                lJobQuote."NS_Schedule 3 Task" := LastTask + '-' + Format(3);
                lJobQuote."NS_Schedule 4 Task" := LastTask + '-' + Format(4);
                lJobQuote."NS_Schedule 5 Task" := LastTask + '-' + Format(5);
                lJobQuote."NS_Schedule 6 Task" := LastTask + '-' + Format(6);
                lJobQuote.Modify;
            end;

            if InsertTotalTask then begin
                SOVTask.Reset;
                SOVTask.Init;
                SOVTask."Job No." := JobNo;
                SOVTask."Job Task No." := LastTask + '-' + Format(9);
                SOVTask.Description := 'Total';
                SOVTask."Job Task Type" := SOVTask."Job Task Type"::"End-Total";
                SOVTask.Totaling := LastTask + '-1..' + LastTask + '-9';
                if not SOVTask.Insert then
                    SOVTask.Modify;
            end;
        end;
    end;

    local procedure SchedOfValuesExist(PassJobNo: Code[20]): Boolean
    var
        JobTask: Record "Job Task";
    begin
        JobTask.Reset;
        JobTask.SetRange("Job No.", PassJobNo);
        JobTask.SetFilter("Job Task No.", '%1', '99999-*');
        if JobTask.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    local procedure ReCalcSchedOfValues(PassJobNo: Code[20]; PassTotalPrice: Decimal)
    var
        lPlanningLine: Record "Job Planning Line";
        lPlanningLine2: Record "Job Planning Line";
        lTask: Record "Job Task";
        TotalScheduledPrice: Decimal;
        LastTask: Code[20];
        x: Integer;
        LineNo: Integer;
        ScheduleDescription: array[6] of Text[50];
        SchedulePercentage: array[6] of Decimal;
        lJobQuote: Record "NS_Job Quote Header";
        ScheduleAmount: array[6] of Decimal;
        SOVTask: Record "Job Task";
    begin
        lJobQuote.Get(PassJobNo);
        ScheduleDescription[1] := lJobQuote."NS_Schedule 1 Description";
        SchedulePercentage[1] := lJobQuote."NS_Schedule 1 Percentage";
        ScheduleDescription[2] := lJobQuote."NS_Schedule 2 Description";
        SchedulePercentage[2] := lJobQuote."NS_Schedule 2 Percentage";
        ScheduleDescription[3] := lJobQuote."NS_Schedule 3 Description";
        SchedulePercentage[3] := lJobQuote."NS_Schedule 3 Percentage";
        ScheduleDescription[4] := lJobQuote."NS_Schedule 4 Description";
        SchedulePercentage[4] := lJobQuote."NS_Schedule 4 Percentage";
        ScheduleDescription[5] := lJobQuote."NS_Schedule 5 Description";
        SchedulePercentage[5] := lJobQuote."NS_Schedule 5 Percentage";
        ScheduleDescription[6] := lJobQuote."NS_Schedule 6 Description";
        SchedulePercentage[6] := lJobQuote."NS_Schedule 6 Percentage";

        lTask.Reset;
        lTask.SetRange("Job No.", PassJobNo);
        lTask.SetRange("Job Task Type", lTask."Job Task Type"::Posting);
        lTask.SetFilter("Job Task No.", '%1', '99999-*');
        if lTask.FindSet then
            repeat
                Evaluate(x, CopyStr(lTask."Job Task No.", 7));
                lTask.Description := ScheduleDescription[x];
                lTask.Modify;
                lPlanningLine.Reset;
                lPlanningLine.SetRange("Job No.", PassJobNo);
                lPlanningLine.SetRange("Job Task No.", lTask."Job Task No.");
                if lPlanningLine.FindFirst then begin
                    lPlanningLine.Description := ScheduleDescription[x];
                    lPlanningLine."Unit Price" := Round((SchedulePercentage[x] / 100) * PassTotalPrice, 0.01);
                    lPlanningLine."Total Price" := lPlanningLine."Unit Price";
                    lPlanningLine."Line Amount (LCY)" := lPlanningLine."Total Price";
                    lPlanningLine.Modify;
                end;
                ScheduleAmount[x] := lPlanningLine."Total Price";
            until lTask.Next = 0;
        lJobQuote."NS_Schedule 1 Amount" := ScheduleAmount[1];
        lJobQuote."NS_Schedule 2 Amount" := ScheduleAmount[2];
        lJobQuote."NS_Schedule 3 Amount" := ScheduleAmount[3];
        lJobQuote."NS_Schedule 4 Amount" := ScheduleAmount[4];
        lJobQuote."NS_Schedule 5 Amount" := ScheduleAmount[5];
        lJobQuote."NS_Schedule 6 Amount" := ScheduleAmount[6];
        lJobQuote.Modify;
    end;

    procedure UpdateTotalCost()
    begin
        InitRoundingPrecisions;
        "Total Cost" := Round("Unit Cost" * Quantity, AmountRoundingPrecisionFCY);
        "Total Cost (LCY)" := Round(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date", "Currency Code",
              "Total Cost", "Currency Factor"),
            AmountRoundingPrecision);
    end;

    local procedure UpdateCostFactor()
    var
        JobCostCategoryPrice: Record "NS_Job Cost Category Price";
        JobItemPrice: Record "Job Item Price";
        JobResourcePrice: Record "Job Resource Price";
        JobGLPrice: Record "Job G/L Account Price";
    begin
        "Cost Factor" := 0;
        JobCostCategoryPrice.Reset;
        JobCostCategoryPrice.SetRange("NS_Job No.", "Job No.");
        JobCostCategoryPrice.SetRange("NS_Cost Category Code", "NS_Cost Category");
        if JobCostCategoryPrice.FindFirst then begin
            "Cost Factor" := JobCostCategoryPrice."NS_Unit Cost Factor";
            "NS_Cost Factor Set By Category" := true;
        end;
        case Type of
            Type::Item:
                begin
                    JobItemPrice.Reset;
                    JobItemPrice.SetRange("Job No.", "Job No.");
                    JobItemPrice.SetRange("Item No.", "No.");
                    JobItemPrice.SetRange("Job Task No.", "Job Task No.");
                    if JobItemPrice.FindFirst then begin
                        "Cost Factor" := JobItemPrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := false;
                    end else begin
                        JobItemPrice.Reset;
                        JobItemPrice.SetRange("Job No.", "Job No.");
                        JobItemPrice.SetRange("Item No.", "No.");
                        if JobItemPrice.FindFirst then begin
                            "Cost Factor" := JobItemPrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := false;
                        end;
                    end;
                end;
            Type::Resource:
                begin
                    JobResourcePrice.Reset;
                    JobResourcePrice.SetRange("Job No.", "Job No.");
                    JobResourcePrice.SetRange(Code, "No.");
                    JobResourcePrice.SetRange("Job Task No.", "Job Task No.");
                    if JobResourcePrice.FindFirst then begin
                        "Cost Factor" := JobResourcePrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := false;
                    end else begin
                        JobResourcePrice.Reset;
                        JobResourcePrice.SetRange("Job No.", "Job No.");
                        JobResourcePrice.SetRange(Code, "No.");
                        if JobResourcePrice.FindFirst then begin
                            "Cost Factor" := JobResourcePrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := false;
                        end;
                    end;
                end;
            Type::"G/L Account":
                begin
                    JobGLPrice.Reset;
                    JobGLPrice.SetRange("Job No.", "Job No.");
                    JobGLPrice.SetRange("G/L Account No.", "No.");
                    JobGLPrice.SetRange("Job Task No.", "Job Task No.");
                    if JobGLPrice.FindFirst then begin
                        "Cost Factor" := JobGLPrice."Unit Cost Factor";
                        "NS_Cost Factor Set By Category" := false;
                    end else begin
                        JobGLPrice.Reset;
                        JobGLPrice.SetRange("Job No.", "Job No.");
                        JobGLPrice.SetRange("G/L Account No.", "No.");
                        if JobGLPrice.FindFirst then begin
                            "Cost Factor" := JobGLPrice."Unit Cost Factor";
                            "NS_Cost Factor Set By Category" := false;
                        end;
                    end;
                end;
        end;
    end;

    local procedure RemoveSegmentEntry(SegmentCode: Code[20])
    var
        SegmentEntry: Record "NS_Job Takeoff Segment Entry";
    begin
        SegmentEntry.SetRange("NS_Job No.", "Job No.");
        SegmentEntry.SetRange("NS_Job Task No.", "Job Task No.");
        SegmentEntry.SetRange(NS_Type, Type);
        SegmentEntry.SetRange("NS_No.", "No.");
        SegmentEntry.SetRange("NS_Segment Code", SegmentCode);
        SegmentEntry.SetRange("NS_Line No.", "Line No.");
        if SegmentEntry.FindFirst then begin
            SegmentEntry.Delete;
            "NS_Segment Name" := '';
            "Document No." := '';
        end;
    end;

    //JD-48.AS.2.0 - START
    local procedure NS_RemoveJFWSegmentEntries()
    var
        JobForeCastbySeg: Record "NS_Job Forecast by Seg code";
    begin
        JobForeCastbySeg.Reset();
        JobForeCastbySeg.SetRange("NS_Job No.", Rec."Job No.");
        JobForeCastbySeg.SetRange("NS_Job Task No.", rec."Job Task No.");
        JobForeCastbySeg.SetRange("NS_Segment Code", rec."NS_Segment Code");
        if JobForeCastbySeg.FindFirst then begin
            JobForeCastbySeg.Delete;
        end;
    end;
    //JD-48.AS.2.0 - END

    local procedure GetItem()
    begin
        if "No." <> Item."No." then
            if not Item.Get("No.") then
                Clear(Item);
    end;

    procedure InitRoundingPrecisions()
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

    //PRJ-72 VT 06-03-20 Begin
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
    procedure CalcUnitPriceEvent(xJobPlanLine: Record "Job Planning Line"; Item: Record Item)
    begin
        InitRoundingPrecisions();
        UpdateCostFactor;
        IF ("Cost Factor" <> 0) THEN
            if ("Unit Cost" <> xJobPlanLine."Unit Cost") then //PRJ-334.MS.1.0
                "Unit Price" := ROUND("Unit Cost" * "Cost Factor", UnitAmountRoundingPrecisionFCY)
            ELSE
                IF (Item."Price/Profit Calculation" = Item."Price/Profit Calculation"::"Price=Cost+Profit") AND
                    (Item."Profit %" < 100) AND
                    ("Unit Cost" <> xJobPlanLine."Unit Cost")
                THEN
                    "Unit Price" := ROUND("Unit Cost" / (1 - Item."Profit %" / 100), UnitAmountRoundingPrecisionFCY);
    end;

    procedure UpdateAmountsAndDiscountsEvent(VAR JobPlanningLine: Record "Job Planning Line"; xJobPlanningLine: Record "Job Planning Line")
    begin
        //InitRoundingPrecisions();//PRJ-854.MS.1.0 comment
        //ProjectPro - start
        // IF "Total Price" = 0 THEN BEGIN
        //  "Line Amount" := 0;
        //  "Line Discount Amount" := 0;
        // END ELSE
        //  IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
        //    "Line Amount" := ROUND("Line Amount",AmountRoundingPrecisionFCY);
        //    "Line Discount Amount" := "Total Price" - "Line Amount";
        //    "Line Discount %" :=
        //      ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
        //  END ELSE
        //    IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
        //PRJ-854 comment start //PRJ-849
        //IF "Line Discount Amount" <> 0 THEN BEGIN
        //    //ProjectPro - end
        //    "Line Discount Amount" := ROUND("Line Discount Amount", AmountRoundingPrecisionFCY);
        //    "Line Amount" := "Total Price" - "Line Discount Amount";
        //    "Line Discount %" :=
        //      ROUND("Line Discount Amount" / "Total Price" * 100, 0.00001);
        //END ELSE
        //    IF ("Line Discount Amount" = xJobPlanningLine."Line Discount Amount") AND
        //       (("Line Amount" <> xJobPlanningLine."Line Amount") OR ("Line Discount %" <> xJobPlanningLine."Line Discount %") OR
        //        ("Total Price" <> xJobPlanningLine."Total Price"))
        //    THEN BEGIN
        //        "Line Discount Amount" :=
        //          ROUND("Total Price" * "Line Discount %" / 100, AmountRoundingPrecisionFCY);
        //        "Line Amount" := "Total Price" - "Line Discount Amount";
        //    END;

        //"Line Amount (LCY)" := ROUND(
        //    CurrExchRate.ExchangeAmtFCYToLCY(
        //      "Currency Date", "Currency Code",
        //      "Line Amount", "Currency Factor"),
        //    AmountRoundingPrecision);

        //"Line Discount Amount (LCY)" := ROUND(
        //    CurrExchRate.ExchangeAmtFCYToLCY(
        //      "Currency Date", "Currency Code",
        //      "Line Discount Amount", "Currency Factor"),
        //    AmountRoundingPrecision);
        //PRJ-854 comment start   //PRJ-849
        //ProjectPro - start
        IF Quantity <> "NS_Original Quantity" THEN BEGIN
            "NS_Original Total Price" := "Total Price";
            "NS_Original Total Price (LCY)" := "Total Price (LCY)";
            "NS_Original Quantity" := Quantity;
        END;
        //ProjectPro - end
    end;

    [IntegrationEvent(false, false)]//PRJ-1182.AS.2.0 ADDED EVENT
    local procedure OnBeforeInsertAssembleyBOMComponents(Var NS_AssembleyBOMComponents: Record "NS_Assembley BOM Components")
    begin
    end;

    [IntegrationEvent(false, false)]//PRJ-1182.AS.2.0 ADDED EVENT
    local procedure OnAfterInsertAssembleyBOMComponents(Var NS_AssembleyBOMComponents: Record "NS_Assembley BOM Components")
    begin
    end;

    //PE-301.NC.1.0 05Jun2024 Start
    procedure NS_GetUOMfromItem(ItemNo: Code[20]): Code[20];
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then;
        if "Line Type" = "Line Type"::Budget then begin
            if Item."Purch. Unit of Measure" <> '' then
                exit(Item."Purch. Unit of Measure");
            if Item."Ns_Parent Item UOM" <> '' then
                exit(Item."Ns_Parent Item UOM");
            if Item."Base Unit of Measure" <> '' then
                exit(Item."Base Unit of Measure");
        end;
        if "Line Type" = "Line Type"::"Both Budget and Billable" then begin
            if Item."Ns_Parent Item UOM" <> '' then
                exit(Item."Ns_Parent Item UOM");
            if Item."Base Unit of Measure" <> '' then
                exit(Item."Base Unit of Measure");
        end;
        if "Line Type" = "Line Type"::Billable then begin
            if Item."Sales Unit of Measure" <> '' then
                exit(Item."Sales Unit of Measure");
            if Item."Ns_Parent Item UOM" <> '' then
                exit(Item."Ns_Parent Item UOM");
            if Item."Base Unit of Measure" <> '' then
                exit(Item."Base Unit of Measure");
        end;
    end;

    procedure NS_GetUOMItemBB(ItemNo: Code[20]; JobNo: Code[20]; JobPlanLine: Record "Job Planning Line"): Code[20];
    var
        Item: Record Item;
        Job: Record Job;
    begin
        if Job.Get(JobNo) then;
        if Item.Get(ItemNo) then;
        if job."NS_Pur/Sale UOM for B&B JPL" then
            if Item."Purch. Unit of Measure" <> '' then
                exit(Item."Purch. Unit of Measure");
        exit(JobPlanLine."Unit of Measure Code");
    end;

    procedure NS_GetUOMSaleItemBB(ItemNo: Code[20]; JobNo: Code[20]; JobPlanLine: Record "Job Planning Line"): Code[20];
    var
        Item: Record Item;
        Job: Record Job;
    begin
        if Job.Get(JobNo) then;
        if Item.Get(ItemNo) then;
        if job."NS_Pur/Sale UOM for B&B JPL" then
            if Item."Sales Unit of Measure" <> '' then
                exit(Item."Sales Unit of Measure");
        exit(JobPlanLine."Unit of Measure Code");
    end;
    //PE-301.NC.1.0 05Jun2024 End

}