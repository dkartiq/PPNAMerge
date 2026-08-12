tableextension 14021111 NS_PurchaseLine extends "Purchase Line"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-162.SK.1.0 Added code for populating "Line Type" from "Job No."
    //PRJ-190.MS.1.0 added new Type Chage type for validate job no.
    //PRJ-216.MS.1.0 added new Type Chage type for fixed asset validate job no.
    //PRJ-247-CTSI-23.MS.1.0  added new code for GBPG 	 
    //PRJ-212 VT1.0 23-04-20 Code Added and Commented
    //PRJ-212 VT1.0 04-05-20
    //PRJ-268 VT1.0 18-05-20 Code Added
    //PRJ-288/GLEI-71 VT1.0 29-05-20 Code Commented
    //PRJ-206.MS.1.0 new changes for Retention
    //PPAL-91.N.S.1.0 26aug2020 new change for Retention
    //TM-10.AM.1.0 | Added Field.
    //PRJ-465.MS.1.0 added type ledger when select type ledger
    //PRJ-470.MS.1.0 added code for type ledger 
    //PRJ-490.MS.1.0 added new field
    //PRJ-615.N.S.1.0 Add Retention base amount in qty to receive field
    //PRJ-817.JS.1.0 26July21 | field added
    //PRJ-817.JS.1.0�04Aug2021 | Add one field work unit completed
    //PRJ-866.JS.1.0 17Aug2021 | Add one new field
    //PRJ-939.JS.1.0 29Sep2021 | code added
    //PRJ-1015.JS.1.0 22Oct2021 | field added
    //PRJ-1039.JS.1.0 12Nov2021 | Code added
    //PRJ-1087.JS.1.0 18Dec2021 | add condition for dimension    
    //PRJ-1233.JS.1.0 02MAR2022 | change in the code
    //PRJ-1314.JS.1.0 18APR2022 | make procedure Obsolete
    //PRJ-1411.RM.1.0 08June2022 | Added some code 
    //PRJ-1469.GK.2.0 04Oct2022 | Change condition
    //PRJ-1740.SD.1.0 15Dec2022 | Code addded to update "Job Cost Category" from Resource. 
    //PRJCTPR-32.JS.1.0 13FEB2023 | correct code for job line type    
    //PRJCTPR-279.HS.1.0 15Jan2024 | Added Code
    // PRJCTPR-303.HS.1.0 23Jan2024 | Added Code
    fields
    {

        modify("No.")
        {
            TableRelation = If (Type = const(NS_Ledger)) "NS_Retention Ledger Code";

            trigger OnAfterValidate()
            var
                //PRJ-1087.JS.1.0 18Dec2021 - Satrt
                NS_JobSetup: Record "Jobs Setup";
                NS_Jobs: Record job;
                NS_BillingHeader: Record "NS_Progress Billing Header";
                NSJobCostCategory: record "NS_Job Cost Category";   //PRJCTPR-185.JS.1.0 01Sep2023
                                                                    //PRJ-1087.JS.1.0 18Dec2021 - end
                PLRec: Record "Purchase Line";//PE-204.AS.4.0
                PLRec2: Record "Purchase Line";//PE-204.AS.4.0
                //PRJCTPR-279.HS.1.0 15Jan2024 Start
                NS_VendorPostGroup: Record "Vendor Posting Group";
                NS_Vendor: Record Vendor;
                NS_GLAccount: Record "G/L Account";
                NS_PurchaseHeader: Record "Purchase Header";
            //PRJCTPR-279.HS.1.0 15Jan2024 End
            begin
                //PE-204.AS.4.0 START
                if (Rec."Document Type" = Rec."Document Type"::Invoice) AND (Rec.Type = Rec.Type::NS_Ledger) AND (Rec."No." = 'RETENTION') then begin
                    PLRec.Reset();
                    PLRec.SetRange("Document Type", PLRec."Document Type"::Invoice);
                    PLRec.SetRange("Document No.", Rec."Document No.");
                    PLRec.SetRange(Type, PLRec.Type::NS_Ledger);
                    PLRec.SetRange("No.", 'RETENTION');
                    if PLRec.FindFirst() then begin
                        //PRJCTPR-354.DK.1.0 Start
                        PLRec.DeleteAll();
                        // Error('You cannot enter more than 1 line with Type "Ledger" and No. "RETENTION"');
                        //PRJCTPR-354.DK.1.0 End
                    end;
                end;
                //PE-204.AS.4.0 END
                //PRJCTPR-354.DK.1.0 Start
                if (Rec."Document Type" = Rec."Document Type"::"Credit Memo") AND (Rec.Type = Rec.Type::NS_Ledger) AND (Rec."No." = 'RETENTION') then begin
                    PLRec.Reset();
                    PLRec.SetRange("Document Type", PLRec."Document Type"::"Credit Memo");
                    PLRec.SetRange("Document No.", Rec."Document No.");
                    PLRec.SetRange(Type, PLRec.Type::NS_Ledger);
                    PLRec.SetRange("No.", 'RETENTION');
                    if PLRec.FindFirst() then begin
                        PLRec.DeleteAll();
                    end;
                end;
                //PRJCTPR-354.DK.1.0 End
                NS_AssignDefaultValuesToTaxFields();

                PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                //PRJ-1308.GK.1.0 05May2022 Start -Comment
                //PRJ-1087.JS.1.0 18Dec2021 - Start
                // If Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Jobs.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                //PRJ-1087.JS.1.0 18Dec2021 - end 
                //PRJ-1308.GK.1.0 05May2022 end             
                //PRJ-1740.SD.2.0 04Jan2023 -End
                //PRJCTPR-60 NK.1.0 13march2022 start
                if (Rec.Type = Rec.Type::"G/L Account") then
                    if GLAccount.Get(Rec."No.") then begin
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                        //PRJCTPR-185.JS.1.0 31Aug2023 - Start                        
                        if Rec."NS_Job Cost Category" = '' then begin
                            NSJobCostCategory.Reset();
                            NSJobCostCategory.SetCurrentKey("NS_G/L Account No.");
                            NSJobCostCategory.SetRange("NS_G/L Account No.", rec."No.");
                            if NSJobCostCategory.FindFirst() then
                                rec."NS_Job Cost Category" := NSJobCostCategory.NS_Code;
                        end;
                        //PRJCTPR-185.JS.1.0 31Aug2023 - end                        
                    end else begin
                        if (Rec.Type = Rec.Type::"G/L Account") and
                           (Rec."Job No." <> '') then
                            PP_JobPlanningLine1.Reset();
                        PP_JobPlanningLine1.SetRange("Job No.", Rec."Job No.");
                        PP_JobPlanningLine1.SetRange(Type, PP_JobPlanningLine1.Type::"G/L Account");
                        PP_JobPlanningLine1.SetRange("No.", Rec."No.");
                        PP_JobPlanningLine1.SetRange("Job Task No.", Rec."Job Task No.");
                        if PP_JobPlanningLine1.FindSet() then
                            Rec."NS_Job Cost Category" := PP_JobPlanningLine1."NS_Cost Category";

                    end;
                //PRJCTPR-60.NK.1.0 13march2022 end

                //PRJCTPR-279.HS.1.0 15Jan2024 Start
                NS_PurchaseHeader.Reset();
                NS_PurchaseHeader.SetRange("No.", Rec."Document No.");
                if NS_PurchaseHeader.FindFirst() then begin
                    if (Rec.Type = Rec.Type::NS_Ledger) and (Rec."No." = 'RETENTION') then begin //PRJCTPR-333.PS.1.0 02April2024
                        if NS_Vendor.Get(rec."Buy-from Vendor No.") then;
                        NS_VendorPostGroup.Reset();
                        NS_VendorPostGroup.SetRange(Code, NS_Vendor."Vendor Posting Group");
                        if NS_VendorPostGroup.FindFirst() then begin
                            if NS_GLAccount.Get(NS_VendorPostGroup."NS_Retention Payables Account") then
                                Rec."Gen. Prod. Posting Group" := NS_GLAccount."Gen. Prod. Posting Group";
                        end;
                    end;
                end;
                //PRJCTPR-279.HS.1.0 15Jan2024 End
            End;
        }
        //PRJCTPR-303.HS.1.0 23Jan2024 Start
        modify(Type)
        {
            trigger OnAfterValidate()
            var
                NS_PurchaseHeader: Record "Purchase Header";
                NS_JobSteup: Record "Jobs Setup";
            begin
                //PRJCTPR-333.PS.1.0 11March2024 Start 

                // NS_PurchaseHeader.SetRange("No.", Rec."Document No.");
                // if NS_PurchaseHeader.FindFirst() then begin
                //     if (NS_PurchaseHeader."NS_Retention Document") and (Rec.Type <> Rec.Type::NS_Ledger) then
                //         Error('You can only select "Type = Ledger” when "Retention Document" is enabled.')
                // end;


                if NS_JobSteup.Get() then;

                if NS_PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then;

                if (NS_PurchaseHeader."NS_Retention Document") and (Rec.Type = Rec.Type::NS_Ledger) then
                    Rec.Validate("No.", NS_JobSteup."NS_Retention Payable Ledger");

                if (NS_PurchaseHeader."NS_Retention Document") and (Rec.Type <> Rec.Type::NS_Ledger) then
                    Error('You can only select "Type = Ledger” when "Retention Document" is enabled.');

                if not (NS_PurchaseHeader."NS_Retention Document") and (Rec.Type = Rec.Type::NS_Ledger) then
                    Error('You must enable "Retention Document" to select Type=Ledger.');

                //PRJCTPR-333.PS.1.0 11March2024 End 
            end;
        }
        //PRJCTPR-303.HS.1.0 23Jan2024 End

        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    JobMatPlanning.RESET();
                    JobMatPlanning.SETRANGE(NS_Type, JobMatPlanning.NS_Type::Resource);
                    JobMatPlanning.SETRANGE("NS_Part No.", "No.");
                    IF JobMatPlanning.FINDFIRST() THEN BEGIN
                        JobMatPlanning.VALIDATE("NS_Bal. Req");
                        JobMatPlanning.MODIFY();
                    END;
                END;
                CreateTempJobLineTempPP();//VIKAS JOB PRICE
                //PPAL-91.N.S.1.0 26aug2020 Start
                NS_JobsSetup.get;
                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                    if "VAT %" <> 0 then
                        "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                    else
                        "NS_Retention Base Amount" := "Amount Including VAT";
                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount"
                end;
                //PPAL-91.N.S.1.0 26aug2020 end;
            end;

        }
        //PRJ-615.N.S.1.0 Start
        modify("qty. to receive")
        {
            trigger OnAfterValidate()
            begin
                NS_SetRetentionBase;//PRJ-615.N.S.1.0
            end;
        }
        //PRJ-615.N.S.1.0 End

        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                NS_SetRetentionBase;
            end;
        }

        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                //PRJ-212 VT1.0 23-04-20 begin
                // IF lJob.GET("Job No.") THEN BEGIN
                //     IF lJobCostCategoryPrice.GET("Job No.", "Job Cost Category") THEN
                //         "Unit Price (LCY)" := "Direct Unit Cost" * lJobCostCategoryPrice."NS_Unit Cost Factor";
                //     IF Type = Type::"G/L Account" THEN BEGIN
                //         lJobGLAccountPrice.SETRANGE("Job No.", "Job No.");
                //         lJobGLAccountPrice.SETRANGE("G/L Account No.", "No.");
                //         IF lJobGLAccountPrice.FINDFIRST THEN
                //             "Unit Price (LCY)" := "Direct Unit Cost" * lJobGLAccountPrice."Unit Cost Factor";
                //         lJobGLAccountPrice.RESET;
                //         lJobGLAccountPrice.SETRANGE("Job No.", "Job No.");
                //         lJobGLAccountPrice.SETRANGE("Job Task No.", "Job Task No.");
                //         lJobGLAccountPrice.SETRANGE("G/L Account No.", "No.");
                //         IF lJobGLAccountPrice.FINDFIRST THEN
                //             "Unit Price (LCY)" := "Direct Unit Cost" * lJobGLAccountPrice."Unit Cost Factor";
                //     END ELSE
                //         IF Type = Type::Item THEN BEGIN
                //             lJobItemPrice.SETRANGE("Job No.", "Job No.");
                //             lJobItemPrice.SETRANGE("Item No.", "No.");
                //             IF lJobItemPrice.FINDFIRST THEN
                //                 "Unit Price (LCY)" := "Direct Unit Cost" * lJobItemPrice."Unit Cost Factor";
                //             lJobItemPrice.RESET;
                //             lJobItemPrice.SETRANGE("Job No.", "Job No.");
                //             lJobItemPrice.SETRANGE("Job Task No.", "Job Task No.");
                //             lJobItemPrice.SETRANGE("Item No.", "No.");
                //             IF lJobItemPrice.FINDFIRST THEN
                //                 "Unit Price (LCY)" := "Direct Unit Cost" * lJobItemPrice."Unit Cost Factor";
                //         END ELSE
                //             IF Type = Type::Resource THEN BEGIN
                //                 lJobResourcePrice.SETRANGE("Job No.", "Job No.");
                //                 lJobResourcePrice.SETRANGE(Code, "No.");
                //                 IF lJobResourcePrice.FINDFIRST THEN
                //                     "Unit Price (LCY)" := "Direct Unit Cost" * lJobResourcePrice."Unit Cost Factor";
                //                 lJobResourcePrice.RESET;
                //                 lJobResourcePrice.SETRANGE("Job No.", "Job No.");
                //                 lJobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                //                 lJobResourcePrice.SETRANGE(Code, "No.");
                //                 IF lJobResourcePrice.FINDFIRST THEN
                //                     "Unit Price (LCY)" := "Direct Unit Cost" * lJobResourcePrice."Unit Cost Factor";
                //             END;
                // END;  
                //PRJ-212 VT1.0 23-04-20 end     
                CreateTempJobLineTempPP();//PRJ-212 VT1.0 04-05-20
                //PPAL-91.N.S.1.0 26aug2020 Start
                NS_JobsSetup.get;
                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                    if "VAT %" <> 0 then
                        "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                    else
                        "NS_Retention Base Amount" := "Amount Including VAT";
                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount"
                end;
                //PPAL-91.N.S.1.0 26aug2020 end;  
            end;
        }

        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            var
                LineDisc: Decimal;
            begin
                if "NS_Subcontract No." <> '' then begin
                    LineDisc := Rec."Line Discount %";
                    //Rec := xRec;//PRJ-288/GLEI-71 VT1.0 29-05-20
                    Rec."Line Discount %" := LineDisc;
                end;
            end;
        }

        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            var
                LineDiscAmt: Decimal;
            begin
                if "NS_Subcontract No." <> '' then begin
                    LineDiscAmt := Rec."Line Discount Amount";
                    Rec := xRec;
                    Rec."Line Discount Amount" := LineDiscAmt;
                end;
            end;
        }

        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                GetPurchHeader;
                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            PurchHeader.TESTFIELD("VAT Base Discount %", 0);
                            "VAT Base Amount" := Amount;
                            //ProjectPro - start
                            NS_AdjustVATBaseAmount;
                            //ProjectPro - end
                            IF "Use Tax" THEN
                                "Amount Including VAT" := "VAT Base Amount"
                            ELSE BEGIN
                                "Amount Including VAT" :=
                                  Amount +
                                  ROUND(
                                    SalesTaxCalculate.CalculateTax(
                                      "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                      "VAT Base Amount", "Quantity (Base)", PurchHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                IF "VAT Base Amount" <> 0 THEN
                                    "VAT %" :=
                                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                                ELSE
                                    "VAT %" := 0;
                                //PPAL-91.N.S.1.0 26aug2020 Start
                                NS_JobsSetup.get;
                                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                                    if "VAT %" <> 0 then
                                        "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                                    else
                                        "NS_Retention Base Amount" := "Amount Including VAT";
                                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount"
                                end;
                                //PPAL-91.N.S.1.0 26aug2020 end;
                            END;
                        END;
                end;
            end;
        }
        //PPAL-91.N.S.1.0 26aug2020 Start
        modify("Tax Group Code")
        {
            trigger OnAfterValidate()
            begin
                IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                ELSE
                    "VAT %" := 0;

                NS_JobsSetup.get;
                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                    if "VAT %" <> 0 then
                        "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                    else
                        "NS_Retention Base Amount" := "Amount Including VAT";
                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount"
                end;
            END;
        }
        //PPAL-91.N.S.1.0 26aug2020 End

        modify("Amount Including VAT")
        {
            trigger OnBeforeValidate()
            begin
                IF "NS_Subcontract Payment Value" <> 0 THEN
                    "Amount Including VAT" := "NS_Subcontract Payment Value";
            end;

            trigger OnAfterValidate()
            begin
                GetPurchHeader;
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            PurchHeader.TESTFIELD("VAT Base Discount %", 0);
                            IF "Use Tax" THEN BEGIN
                                Amount := "Amount Including VAT";
                                "VAT Base Amount" := Amount;
                            END ELSE BEGIN
                                Amount :=
                                  ROUND(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      "Tax Area Code", "Tax Group Code", "Tax Liable", PurchHeader."Posting Date",
                                      "Amount Including VAT", "Quantity (Base)", PurchHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                "VAT Base Amount" := Amount;
                                //ProjectPro - start
                                NS_AdjustVATBaseAmount;
                                //ProjectPro - end
                                IF "VAT Base Amount" <> 0 THEN
                                    "VAT %" :=
                                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount", 0.00001)
                                ELSE
                                    "VAT %" := 0;
                            END;
                        END;

                end;
                InitOutstandingAmount;
                UpdateUnitCost;
            end;
        }

        modify("Job No.")
        {
            trigger OnBeforeValidate();
            var
                NS_Job: Record Job;  //PRJ-1087.JS.1.0 18Dec2021
                NS_BillingHeader: Record "NS_Progress Billing Header";  //PRJ-1087.JS.1.0 18Dec2021
            begin
                if "Job No." <> '' then begin
                    GetPurchHeader();
                    //if PurchHeader."NS_Job No." <> '' then   //PE-260.JS.1.0 20FEB2024 line commented
                    if (PurchHeader."NS_Job No." <> '') and (PurchHeader."NS_Multiple Jobs on Lines" = false) then  //PE-260.JS.1.0 20FEB2024 line added
                        if not NS_JobLinks.GET("Job No.", PurchHeader."NS_Job No.") then
                            if rec."Job No." <> PurchHeader."NS_Job No." then    //PE-260.JS.1.0 20FEB2024 line added
                                ERROR(Text14021100_Txt, PurchHeader."NS_Job No.");
                end;
                //PRJ-145.SK.1.0 Start
                //     NS_JobsSetup.GET;
                //     "Gen. Bus. Posting Group" := NS_JobsSetup."Gen. Bus. Posting Group";
                // end else
                //     "Gen. Bus. Posting Group" := PurchHeader."Gen. Bus. Posting Group";
                //PRJ-145.SK.1.0 End
                //PRJ-1308.GK.1.0 05May2022 start-Comment
                // //PRJ-1087.JS.1.0 18Dec2021 - Start
                // If Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Job.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                // //PRJ-1087.JS.1.0 18Dec2021 - end  
                //PRJ-1308.GK.1.0 05May2022 end              

                //PRJ-1233.JS.1.0 02MAR2022-Start
                //IF NOT (Type IN [Type::Item, Type::"G/L Account", Type::Resource, Type::NS_Ledger, Type::"Charge (Item)", Type::"Fixed Asset", Type::" "]) THEN //PRJ-190.MS.1.0 added new Type "Charge(Item)" and "Fixed Asset" for validate job no.
                //    FIELDERROR("Job No.", STRSUBSTNO(Text012_Txt, FIELDCAPTION(Type), Type));
                //PRJ-1233.JS.1.0 02MAR2022-end    
            end;

            trigger OnAfterValidate()
            var
                NS_Job: Record job;
                RecVendor: Record Vendor;
                NS_BillingHeader: Record "NS_Progress Billing Header";  //PRJ-1087.JS.1.0 18Dec2021
            begin
                NS_AssignDefaultValuesToTaxFields;
                //PRJ-162.SK.1.0 Start
                IF NS_Job.Get(Rec."Job No.") then begin   //PRJ-1015.JS.1.0  22Oct2021
                    //PRJCTPR-32.JS.1.0 13FEB2023 - Start
                    //Validate("Job Line Type", NS_Job."NS_Line Type"); //PRJCTPR-32.JS.1.0 13FEB2023 Line commented
                    if NS_Job."NS_Line Type" = NS_Job."NS_Line Type"::" " then
                        rec."Job Line Type" := rec."Job Line Type"::" ";
                    if NS_Job."NS_Line Type" = NS_Job."NS_Line Type"::Billable then
                        rec."Job Line Type" := rec."Job Line Type"::Billable;
                    if NS_Job."NS_Line Type" = NS_Job."NS_Line Type"::Budget then
                        rec."Job Line Type" := rec."Job Line Type"::Budget;
                    if NS_Job."NS_Line Type" = NS_Job."NS_Line Type"::"Both Budget and Billable" then
                        rec."Job Line Type" := rec."Job Line Type"::"Both Budget and Billable";
                    //PRJCTPR-32.JS.1.0 13FEB2023 - end      
                    //"NS_Sub-Level to Job No." := NS_Job."NS_Sub-Level to Job No.";   //PRJ-1015.JS.1.0  22Oct2021 //PRJ-1039.JS.1.0 12Nov2021line commented
                    //PRJ-1039.JS.1.0 12Nov2021-Start
                    if NS_Job."NS_Sub-Level to Job No." = '' then
                        Rec."NS_Sub-Level to Job No." := NS_Job."No."
                    else
                        Rec."NS_Sub-Level to Job No." := NS_Job."NS_Sub-Level to Job No.";
                    //PRJ-1039.JS.1.0 12Nov2021-Start                                
                end;   //PRJ-1015.JS.1.0  22Oct2021
                //PRJ-162.SK.1.0 End
                "NS_Segment Code" := ''; //TM-10.AM.1.0
                //CTSI-23.MS.1.0001 Start //PRJ-247
                GetPurchHeader();
                if PurchHeader."NS_Job No." = '' then begin
                    if NS_Job.get(Rec."Job No.") then; //PRJ-247
                                                       // if NS_Job."NS_Gen. Bus. Posting Group" <> '' then //PRJ-831.AS.1.0 12OCT2021 Comment old
                                                       //Validate(rec."Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group") //PRJ-831.AS.1.0 12OCT2021 Comment old

                    if NS_Job."NS_Gen. Bus. Posting Group New" <> '' then //PRJ-831.AS.1.0 12OCT2021 Add New
                        Validate(rec."Gen. Bus. Posting Group", NS_Job."NS_Gen. Bus. Posting Group New") //PRJ-831.AS.1.0 12OCT2021 Add New
                    else begin
                        if RecVendor.Get(rec."Buy-from Vendor No.") then
                            Validate("Gen. Bus. Posting Group", RecVendor."Gen. Bus. Posting Group");
                    end;
                end;
                //CTSI-23.MS.1.0001 end //PRJ-247
                //PRJ-1308.GK.1.0 05May2022 start-Comment
                // //PRJ-1087.JS.1.0 18Dec2021 - Start
                // if Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Job.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                // //PRJ-1087.JS.1.0 18Dec2021 - end
                //PRJ-1308.GK.1.0 05May2022 end

            end;
        }

        //PRJ-212 VT1.0 04-05-20 begin
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                //PRJ-1087.JS.1.0 18Dec2021 - Start
                NS_JobSetup: Record "Jobs Setup";
                NS_PurchHead: Record "Purchase Header";
                NS_Jobs: Record job;
                NS_JobTesks: Record "Job Task";
                NS_BillingHeader: Record "NS_Progress Billing Header";
                //PRJ-1087.JS.1.0 18Dec2021 - end
                //PRJCTPR-199.JS.1.0 20NOV2023 - Start    
                NSDimBufferTemp: record "Dimension Buffer" temporary;
                NSItemRec: record item;
                NSGLRec: record "G/L Account";
                NSResource: record resource;
                NSDefaultDim: record "Default Dimension";
                NSJobTaskDimension: record "Job Task Dimension";
                NSDimMgt: codeunit DimensionManagement;
                NSGLedgSetup: record "General Ledger Setup";
            //PRJCTPR-199.JS.1.0 20NOV2023 - end
            begin
                //PRJCTPR-199.JS.1.0 20NOV2023 - Start
                clear(NSDimBufferTemp);
                if NS_JobSetup.get() then;
                if NSGLedgSetup.get() then;
                if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
                    if (rec."Job No." <> '') and (rec."Job Task No." <> '') then begin
                        NSJobTaskDimension.reset();
                        NSJobTaskDimension.setrange("Job No.", rec."Job No.");
                        NSJobTaskDimension.setrange("Job Task No.", rec."Job Task No.");
                        if NSJobTaskDimension.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 39;
                                NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSJobTaskDimension.next = 0;
                    end;
                    case rec.Type of
                        rec.Type::Item:
                            begin
                                if NSItemRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 27);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::Resource:
                            begin
                                if NSResource.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 156);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::"G/L Account":
                            begin
                                if NSGLRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 15);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                rec.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                rec.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;

                    //if rec."Line No." <> 0 then begin
                    rec."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                    //rec.Modify();
                    //end;
                end;
                if NS_JobSetup."NS_Flow Job Card Dimension" = false then begin
                    if (rec."Job No." <> '') and (rec."Job Task No." <> '') then begin
                        NSJobTaskDimension.reset();
                        NSJobTaskDimension.setrange("Job No.", rec."Job No.");
                        NSJobTaskDimension.setrange("Job Task No.", rec."Job Task No.");
                        NSJobTaskDimension.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                        if NSJobTaskDimension.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 39;
                                NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSJobTaskDimension.next = 0;
                    end;
                    case rec.Type of
                        rec.Type::Item:
                            begin
                                if NSItemRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 27);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::Resource:
                            begin
                                if NSResource.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 156);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::"G/L Account":
                            begin
                                if NSGLRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 15);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 39);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 39;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                rec.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                rec.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;


                    rec."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);

                end;
                //PRJCTPR-199.JS.1.0 20NOV2023 - end                
                CreateTempJobLineTempPP();//VIKAS JOB PRICE
                //PRJ-1308.GK.1.0 05May2022 start-Comment
                // //PRJ-1087.JS.1.0 18Dec2021 Start
                // if Rec."Job No." <> '' then
                //     if Rec."Job Task No." <> '' then begin
                //         NS_JobSetup.Get();
                //         if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
                //             NS_JobTesks.get(Rec."Job No.", Rec."Job Task No.");
                //             Rec."Shortcut Dimension 1 Code" := NS_JobTesks."Global Dimension 1 Code";
                //             Rec."Shortcut Dimension 2 Code" := NS_JobTesks."Global Dimension 2 Code";
                //             Rec."Dimension Set ID" := NS_BillingHeader.NS_GetDimensionNoFromJobTask(Rec."Job No.", Rec."Job Task No.");
                //         end;
                //     end;
                //PRJ-1308.GK.1.0 05May2022 end
            end;
            //PRJ-1087.JS.1.0 18Dec2021 End

        }
        //PRJ-212 VT1.0 04-05-20 end

        //PRJ-1087.JS.1.0 18Dec2021 Start
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                NS_JobSetup: Record "Jobs Setup";
                NS_Jobs: Record job;
                NS_BillingHeader: Record "NS_Progress Billing Header";
            begin
                //PRJ-1087.JS.1.0 18Dec2021 - Start
                //PRJCTPR-199.JS.1.0 11DEC2023 - start below code commented
                // If Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Jobs.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                //PRJCTPR-199.JS.1.0 11DEC2023 - end
                //PRJ-1087.JS.1.0 18Dec2021 - end                
            end;

        }
        //PRJ-1087.JS.1.0 18Dec2021 End        

        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                IF "NS_Subcontract No." <> '' THEN begin
                    Rec := xRec;
                    "Line Discount Amount" := 0;
                end;

                GetPurchHeader;
                "Line Amount" := ROUND("Line Amount", Currency."Amount Rounding Precision");
            end;
        }

        modify("Job Planning Line No.")
        {
            trigger OnBeforeValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                if "Job Planning Line No." <> 0 then
                    IF "NS_Subcontract No." <> '' THEN begin
                        JobPlanningLine.Get("Job No.", "Job Task No.", "Job Planning Line No.");
                        p.NS_T39SetJobPlanningLineNo_UsageLink(JobPlanningLine."Usage Link");
                        JobPlanningLine."Usage Link" := TRUE; //to allow to pass Validate code
                        JobPlanningLine.Modify();
                    end;
            end;

            trigger OnAfterValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
                if "Job Planning Line No." <> 0 then
                    IF "NS_Subcontract No." <> '' THEN begin
                        JobPlanningLine.Get("Job No.", "Job Task No.", "Job Planning Line No.");
                        JobPlanningLine."Usage Link" := p.NS_T39GetJobPlanningLineNo_UsageLink(); //restore original value
                        JobPlanningLine.Modify();
                    end;
            end;
        }

        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code;  //PRJCTPR-185.JS.1.0 31Aug2023
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                NS_JobCostCategory: Record "NS_Job Cost Category";
                NSJobCostCategory: record "NS_Job Cost Category";  //PRJCTPR-185.JS.1.0
            begin
                //ProjectPro - start
                if NS_JobCostCategory.GET("NS_Job Cost Category") then begin
                    if NS_JobCostCategory."NS_G/L Account No." <> '' then begin
                        case Type of
                            Type::"G/L Account":
                                begin
                                    if "No." <> NS_JobCostCategory."NS_G/L Account No." then begin //PRJ-268 VT1.0 18-05-20
                                        VALIDATE(Type, Type::"G/L Account");
                                        VALIDATE("No.", NS_JobCostCategory."NS_G/L Account No.");
                                        //PRJCTPR-185.JS.1.0 31Aug2023 - Start
                                        if Rec."NS_Job Cost Category" = '' then begin
                                            NSJobCostCategory.Reset();
                                            NSJobCostCategory.SetCurrentKey("NS_G/L Account No.");
                                            NSJobCostCategory.SetRange("NS_G/L Account No.", rec."No.");
                                            if NSJobCostCategory.FindFirst() then
                                                rec."NS_Job Cost Category" := NSJobCostCategory.NS_Code;
                                        end;
                                        //PRJCTPR-185.JS.1.0 31Aug2023 - end                                        
                                    end;//PRJ-268 VT1.0 18-05-20
                                    if NS_JobCostCategory."NS_Activity Code" <> '' then
                                        VALIDATE("Job Task No.", NS_JobCostCategory."NS_Activity Code");
                                end;
                            Type::Resource:
                                begin
                                    if NS_JobCostCategory."NS_Activity Code" <> '' then
                                        VALIDATE("Job Task No.", NS_JobCostCategory."NS_Activity Code");
                                end;
                        end;
                    end
                    //PRJ-212 VT1.0 23-04-20 begin
                    else begin
                        CreateTempJobLineTempPP();////PRJ-212 VT1.0 04-05-20
                                                  /* IF JobTaskIsSet THEN BEGIN
                                                       CreateTempJobJnlLine(TRUE);
                                                       UpdateJobPrices;
                                                   END; */ //VIKAS JOB PRICE 
                                                           //PRJ-212 VT1.0 23-04-20 end
                    end;
                    "NS_Bal. Accrual Account No." := NS_JobCostCategory."NS_Bal. Account No.";
                    "NS_Accrual Account No." := NS_JobCostCategory."NS_G/L Account No.";
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
        field(14021112; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            Description = 'ProjectPro';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Committed Amount (LCY)" <> xRec."NS_Committed Amount (LCY)" then
                    if Type <> Type::NS_Ledger then
                        ERROR(Text14021101_Txt)
                    else

                        if Quantity <> 0 then
                            VALIDATE(Quantity, xRec.Quantity);
                //ProjectPro - end
            end;
        }
        field(14021115; "NS_Committed Quantity"; Decimal)
        {
            Caption = 'Committed Quantity';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Committed Qty. (Base)"; Decimal)
        {
            Caption = 'Committed Qty. (Base)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021117; "NS_Committed Amount (LCY)"; Decimal)
        {
            Caption = 'Committed Amount (LCY)';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Currency2: Record Currency;
            begin
                //ProjectPro - start
                //PRJ-1618.AS.1.0 START COMMENT
                GetPurchHeader;
                NS_Currency.InitRoundingPrecision;
                // if PurchHeader."Currency Code" <> '' then
                //     "NS_Committed Amount (LCY)" :=
                //     ROUND(
                //       CurrExchRate.ExchangeAmtLCYToFCY(
                //         GetDate, "Currency Code",
                //         "NS_Committed Amount", PurchHeader."Currency Factor"),
                //       NS_Currency."Amount Rounding Precision")
                // else
                //     "NS_Committed Amount" :=
                //     ROUND("NS_Committed Amount (LCY)", Currency2."Amount Rounding Precision");
                //PRJ-1618.AS.1.0 END COMMENT
                //ProjectPro - end

                //PRJ-1618.AS.1.0 START 
                if PurchHeader."Currency Code" = '' then
                    "NS_Committed Amount" :=
                     ROUND("NS_Committed Amount (LCY)", Currency2."Amount Rounding Precision");
                //PRJ-1618.AS.1.0 END
            end;
        }
        field(14021118; "NS_Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Currency2: Record Currency;
            begin
                //ProjectPro - start
                // GetPurchHeader;//PRJ-1618.AS.1.0
                NS_Currency.InitRoundingPrecision;
                if PurchHeader."Currency Code" <> '' then begin

                    //PRJ-1618.AS.1.0 START
                    "NS_Committed Amount" := ROUND(
                    rec."Amount Including VAT" * rec."NS_Committed Quantity" / Rec.Quantity,
                    NS_Currency."Amount Rounding Precision");
                    //PRJ-1618.AS.1.0 END

                    //PRJ-1618.AS.1.0 START COMMENT
                    // "NS_Committed Amount" :=
                    // ROUND(
                    //   CurrExchRate.ExchangeAmtFCYToLCY(
                    //     GetDate, "Currency Code",
                    //     "NS_Committed Amount (LCY)", PurchHeader."Currency Factor"),
                    //   NS_Currency."Amount Rounding Precision")
                    //PRJ-1618.AS.1.0 END COMMENT

                    //PRJ-1618.AS.1.0 START
                    "NS_Committed Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate, "Currency Code",
                        "NS_Committed Amount", PurchHeader."Currency Factor"),
                      NS_Currency."Amount Rounding Precision")
                    //PRJ-1618.AS.1.0 END

                end
                else
                    "NS_Committed Amount (LCY)" :=
                    ROUND("NS_Committed Amount", Currency2."Amount Rounding Precision");
                //ProjectPro - end
            end;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            CaptionML = ENU = 'Retention Applies',
                        ENC = 'Retention Applies';
            Description = 'ProjectPro';
            InitValue = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                TestStatusOpen;
                // TestExpenseCapitalize;//PPDA.1.0 Commented
                UpdateAmounts;
                //ProjectPro - end
            end;
        }
        field(14021136; "NS_Balance To Print"; Decimal)
        {
            Caption = 'Balance To Print';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Retention Base Amount"; Decimal)
        {
            Caption = 'Retention Base Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021144; "NS_Retention Base Before Tax"; Decimal)
        {
            Caption = 'Retention Base Before Tax';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021305; "NS_Subcontract Payment Percent"; Decimal)
        {
            Caption = 'Subcontract Payment Percent';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            MaxValue = 100;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_SetRetentionBase;
                //ProjectPro - end
            end;
        }
        field(14021306; "NS_Subcontract Payment Value"; Decimal)
        {
            Caption = 'Subcontract Payment Value';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                NS_SetRetentionBase;
                //ProjectPro - end
            end;
        }
        field(14021400; NS_Staged; Boolean)
        {
            Caption = 'Staged';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Accrual Account No."; Code[20])
        {
            Caption = 'Accrual Account No.';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Bal. Accrual Account No."; Code[20])
        {
            Caption = 'Bal. Accrual Account No.';
            Description = 'ProjectPro';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_JMP Details"; Text[30])
        {
            Caption = 'JMP Details';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //PRJCTPR-256.JS.1.0 14DEC2023 - Start
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by new field “JMP Details” with increased length 100 characters';
            ObsoleteTag = 'Repleace in ProjectPro Upcomming release 23.0.XX.XXXX';
            //PRJCTPR-256.JS.1.0 14DEC2023 - end
            //PRJCTPR-256.JS.1.0 14DEC2023 - start
            trigger OnValidate()
            begin
                if rec."NS_JMP Details" <> '' then
                    rec."NS_JMP Details" := copystr(rec."NS_JMP Details", 1, 20);
            end;
            //PRJCTPR-256.JS.1.0 14DEC2023 - end  
        }
        field(14021409; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_FA Job Usage"; Boolean)
        {
            Caption = 'FA Job Usage';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Rec.Type <> Rec.Type::"Fixed Asset" then
                    Error('This is valid only for Type Fixed Asset');

                if NOT rec."NS_FA Job Usage" then begin
                    "NS_FA Job No." := '';
                    "NS_FA Job Task No." := '';
                    //  "NS_FA Segment Code" := ''; //PE-81.Dk.1.0 04May2023
                end;

            end;
        }
        field(14021416; "NS_FA Job No."; Code[20])
        {
            Caption = 'FA Job No.';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;
            TableRelation = Job;
            trigger OnValidate()
            begin
                TestField("NS_FA Job Usage", true);
            end;
        }
        field(14021417; "NS_FA Job Task No."; Code[20])
        {
            Caption = ' FA Job Task No.';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_FA Job No."));
            trigger OnValidate()
            begin
                TestField("NS_FA Job Usage", true);
            end;
        }
        field(14021418; "NS_FA Segment Code"; Code[20])
        {
            Caption = 'FA Segment Code';
            Description = 'PRJ-490.MS.1.0';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_FA Job No."));
            trigger OnValidate()
            begin
                // TestField("NS_FA Job Usage", true);  //PE-81.Dk.1.0 04May2023
            end;
        }

        //PRJ-817.JS.1.0 26July21 Start
        field(14021419; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DataClassification = CustomerContent;
            MinValue = 0;

        }
        field(14021420; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure".Code;
            DataClassification = CustomerContent;

        }
        //PRJ-817.JS.1.0 26July21 Start
        field(14021421; "NS_Work Unit Completed"; Decimal)         //PRJ-817.JS.1.0�04Aug2021
        {
            Caption = 'Work Unit Completed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }

        field(14021422; "NS_Job Planning Line No."; Integer)         //PRJ-866.JS.1.0 17Aug2021
        {
            Caption = 'JPL No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }
        //PRJ-1411.RM.1.0 start
        field(14021434; "NS_JMP Line No."; Integer)
        {
            caption = 'JMP Line No.';
            description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;

        }
        //PRJ-1411.RM.1.0 end
        //PRJCTPR-256.JS.1.0 - Start
        field(14021322; "NS_PPJMP Details"; Text[100])
        {
            Caption = 'JMP Details';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-256.JS.1.0 - end

        //PE-260.JS.1.0 20FEB2024 - Start
        field(14021323; "NS_Multiple Jobs on Lines"; Boolean)
        {
            Caption = 'Multiple Jobs on Purchase Lines';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-260.JS.1.0 20FEB2024 - end  

    }
    keys
    {
        key(Key2; "NS_Retention Applies")
        {
            SumIndexFields = "NS_Retention Base Amount", "NS_Retention Base Before Tax";
        }
        key(Key3; "NS_Subcontract No.")
        {
            SumIndexFields = "NS_Committed Amount (LCY)", "NS_Committed Amount";
        }
    }

    trigger OnInsert()//PRJ-1740.SD.1.0 15Dec2022 -Start
    begin
        CheckResource();
    end;//PRJ-1740.SD.1.0 15Dec2022 -End

    trigger OnAfterInsert()//PRJ-1740.SD.1.0 15Dec2022 -Start
    var
        JobCostCategory: Code[20];
        NSJobCostCategory: Record "NS_Job Cost Category"; //PRJCTPR-185.AT.1.0  31OCT2023
    begin
        JobCostCategory := CheckResource();
        If JobCostCategory <> '' then begin
            "NS_Job Cost Category" := JobCostCategory;
            Modify();
        end;
        //PRJCTPR-185.AT.1.0  31OCT2023 - Start
        if Rec."NS_Job Cost Category" = '' then begin
            NSJobCostCategory.Reset();
            NSJobCostCategory.SetCurrentKey("NS_G/L Account No.");
            NSJobCostCategory.SetRange("NS_G/L Account No.", rec."No.");
            if NSJobCostCategory.FindFirst() then
                rec."NS_Job Cost Category" := NSJobCostCategory.NS_Code;
            Modify();
        end;
        //PRJCTPR-185.AT.1.0  31OCT2023 - end 
    end;//PRJ-1740.SD.1.0 15Dec2022 -End

    trigger OnModify()//PRJ-1740.SD.1.0 15Dec2022 -Start
    var
        JobCostCategory: Code[20];
    begin
        JobCostCategory := CheckResource();
        If JobCostCategory <> '' then begin
            "NS_Job Cost Category" := JobCostCategory;
            Modify();
        end;
    end;//PRJ-1740.SD.1.0 15Dec2022 -End

    local procedure CheckResource() JobCostCategory: Code[20] //PRJ-1740.SD.1.0 15Dec2022 -Start
    var
        NSFARec: Record "Fixed Asset";   //PRJ-1740.SD.1.0 15Dec2022
        NSResRec: Record Resource;     //PRJ-1740.SD.1.0 15Dec2022
        Text14021100: Label 'There must be a cost category for Resource %1 on Fixed Asset %2'; //PRJ-1740.SD.1.0 15Dec2022
    begin
        if Type = Type::"Fixed Asset" then
            if NSFARec.Get("No.") then
                if NSResRec.Get(NSFARec."NS_FA Res. No.") then
                    if NS_JobsSetup.Get() then
                        if (NS_JobsSetup."NS_Cost Category Required Bud") and (NS_JobsSetup."NS_Cost Category Required") then
                            if NSResRec."NS_Job Cost Category" = '' then
                                ERROR(Text14021100, NSResRec."No.", NSFARec."No.")
                            else
                                exit(NSResRec."NS_Job Cost Category");
    end;//PRJ-1740.SD.1.0 15Dec2022 -End

    trigger OnAfterDelete()
    var
        T_39: Record 39;//PPAL-91.N.S.1.0 26aug2020
        T_39_rec: Record 39;//PPAL-91.N.S.1.0 26aug2020
    begin
        //ProjectPro - start
        IF Type = Type::Item THEN BEGIN
            JobMatPlanning.RESET();
            JobMatPlanning.SETRANGE(NS_Type, JobMatPlanning.NS_Type::Resource);
            JobMatPlanning.SETRANGE("NS_Part No.", "No.");
            IF JobMatPlanning.FINDFIRST() THEN BEGIN
                JobMatPlanning.VALIDATE("NS_Bal. Req");
                JobMatPlanning.MODIFY();
            END;
        END;
        //ProjectPro - end
        //PPAL-91.N.S.1.0 26aug2020 Start
        NS_JobsSetup.Get();
        if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
            T_39.Reset();
            T_39.SetRange("Document No.", "Document No.");
            T_39.SetRange("Document Type", "Document Type");
            T_39.SetFilter("VAT %", '<>%1', 0);
            if T_39.FindFirst then begin
                T_39_rec.get(T_39."Document Type", T_39."Document No.", T_39."Line No.");
                T_39_rec."NS_Retention Base Amount" := T_39."Amount Including VAT";
                T_39_rec."NS_Retention Base Before Tax" := T_39."Amount Including VAT";
                T_39_rec.Modify();
            end;
        end;
        //PPAL-91.N.S.1.0 26aug2020 End        
    end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.
    //Unsupported feature: PropertyChange. Please convert manually.

    var
        lJob: Record Job;
        lJobItemPrice: Record "Job Item Price";
        lJobCostCategoryPrice: Record "NS_Job Cost Category Price";
        lJobResourcePrice: Record "Job Resource Price";
        lJobGLAccountPrice: Record "Job G/L Account Price";
        NS_JobsSetup: Record "Jobs Setup";
        NS_JobLinks: Record "NS_Job Links";
        NS_JobTaskLines: Page "Job Task Lines";
        Text14021100_Txt: Label 'The Job No. is not part of Job %1 entered in the header.', Comment = '%1 = Job No.';
        Text14021101_Txt: Label 'Work Type only pertains to a Resource transaction.';
        NS_Currency: Record Currency;
        NS_JobCurrencyFactorHold: Decimal;
        NS_JobCurrencyCodeHold: Code[20];
        NS_Resource: Record Resource;
        NS_ResourceFindPrice: Codeunit "Resource-Find Price";
        NS_ResourceFindCost: Codeunit "Resource-Find Cost";
        JobMatPlanning: Record "NS_Job Material Planning";
        Text14021102_Txt: Label 'Percent calculations can only apply to G/L Account types.';
        JobDemandOnly: Boolean;
        StatusCheckSuspended: Boolean;
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ItemCharge: Record "Item Charge";
        CurrExchRate: Record "Currency Exchange Rate";
        Item: Record Item;
        PostingSetupMgt: Codeunit PostingSetupManagement;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        Text012_Txt: Label 'must not be specified when %1 = %2';
        p: Codeunit "NS_Parameters for Table Events";
        EditBool: Boolean;
        GLAccount: Record "G/L Account";//PRJCTPR-60.NK.1.0 start13march2023

        PP_JobPlanningLine1: Record "Job Planning Line"; //PRJCTPR-60.NK.1.0 start13march2023



    procedure GetJobCosts();
    VAR
        JobItemPrice: Record "Job Item Price";
        JobResourcePrice: Record "Job Resource Price";
        JobGLPrice: Record "Job G/L Account Price";
        lJobCostCategoryPrice: Record "NS_Job Cost Category Price";
    BEGIN
        GetPurchHeader(); //SPLN1.00
        //ProjectPro - start
        IF lJobCostCategoryPrice.GET("Job No.", "NS_Job Cost Category") THEN BEGIN
            "Unit Price (LCY)" := "Unit Cost (LCY)" * lJobCostCategoryPrice."NS_Unit Cost Factor";
            VALIDATE("Job Unit Price", "Unit Price (LCY)");
        END;
        //ProjectPro - end
        CASE Type OF
            Type::"G/L Account":
                BEGIN
                    JobGLPrice.SETRANGE("Job No.", PurchHeader."NS_Job No.");
                    IF JobGLPrice.FINDSET(FALSE, FALSE) THEN
                        NS_GetGLCosts(JobGLPrice);
                END;

            Type::Item:
                BEGIN
                    JobItemPrice.SETRANGE("Job No.", PurchHeader."NS_Job No.");
                    IF JobItemPrice.FINDSET(FALSE, FALSE) THEN
                        NS_GetItemCosts(JobItemPrice);
                END;

            Type::Resource:
                BEGIN
                    JobResourcePrice.SETRANGE("Job No.", PurchHeader."NS_Job No.");
                    IF JobResourcePrice.FINDSET(FALSE, FALSE) THEN
                        NS_GetResourceCosts(JobResourcePrice);
                END;
        END;
    END;

    LOCAL PROCEDURE NS_GetGLCosts(JobGLPrice: Record "Job G/L Account Price");
    BEGIN
        //ProjectPro - start
        IF "Job Task No." <> '' THEN BEGIN
            JobGLPrice.SETRANGE("Job Task No.", "Job Task No.");
            JobGLPrice.SETRANGE("G/L Account No.", "No.");
            JobGLPrice.SETFILTER("Unit Cost", '<>%1', 0);
            IF JobGLPrice.FINDFIRST THEN BEGIN
                "Unit Cost (LCY)" := JobGLPrice."Unit Cost";
                "Unit Price (LCY)" := JobGLPrice."Unit Price";
            END;
            JobGLPrice.SETRANGE("Unit Cost");
            JobGLPrice.SETFILTER("Unit Cost Factor", '<>%1', 0);
            IF JobGLPrice.FINDFIRST THEN BEGIN
                "Unit Cost (LCY)" := JobGLPrice."Unit Cost";
                "Unit Price (LCY)" := JobGLPrice."Unit Price" * (1 + JobGLPrice."Unit Cost Factor" / 100);
            END;
        END ELSE BEGIN
            JobGLPrice.SETRANGE("G/L Account No.", "No.");
            JobGLPrice.SETFILTER("Unit Cost", '<>%1', 0);
            IF JobGLPrice.FINDFIRST THEN BEGIN
                "Unit Cost (LCY)" := JobGLPrice."Unit Cost";
                "Unit Price (LCY)" := JobGLPrice."Unit Price";
            END;
            JobGLPrice.SETRANGE("Unit Cost");
            JobGLPrice.SETFILTER("Unit Cost Factor", '<>%1', 0);
            IF JobGLPrice.FINDFIRST THEN BEGIN
                "Unit Cost (LCY)" := JobGLPrice."Unit Cost";
                "Unit Price (LCY)" := JobGLPrice."Unit Price" * (1 + JobGLPrice."Unit Cost Factor" / 100);
            END;
        END;
        //ProjectPro - end
    END;

    LOCAL PROCEDURE NS_GetItemCosts(JobItemPrice: Record "Job Item Price");
    VAR
        lItem: Record Item;
        JobItemPriceFound: Boolean;
    BEGIN
        //ProjectPro - start
        IF lItem.GET("No.") THEN;
        IF "Job Task No." <> '' THEN BEGIN
            JobItemPrice.SETRANGE("Job Task No.", "Job Task No.");
            JobItemPrice.SETRANGE("Item No.", "No.");
            JobItemPrice.SETFILTER("NS_Unit Cost", '<>%1', 0);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                "Unit Cost (LCY)" := JobItemPrice."NS_Unit Cost";
                "Unit Price (LCY)" := JobItemPrice."Unit Price";
            END;
            JobItemPrice.SETRANGE("NS_Unit Cost");
            JobItemPrice.SETFILTER("Unit Cost Factor", '<>%1', 0);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                IF lItem."Last Direct Cost" <> 0 THEN BEGIN
                    "Unit Cost (LCY)" := lItem."Last Direct Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := lItem."Unit Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END;
            END;
            JobItemPrice.SETRANGE("Unit Cost Factor");
            JobItemPrice.SETRANGE("Item No.");
            JobItemPrice.SETRANGE(NS_Type, JobItemPrice.NS_Type::All);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                IF lItem."Last Direct Cost" <> 0 THEN BEGIN
                    "Unit Cost (LCY)" := lItem."Last Direct Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := lItem."Unit Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END;
            END;
        END ELSE BEGIN
            JobItemPrice.SETRANGE("Item No.", "No.");
            JobItemPrice.SETFILTER("NS_Unit Cost", '<>%1', 0);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                "Unit Cost (LCY)" := JobItemPrice."NS_Unit Cost";
                "Unit Price (LCY)" := JobItemPrice."Unit Price";
            END;
            JobItemPrice.SETRANGE("NS_Unit Cost");
            JobItemPrice.SETFILTER("Unit Cost Factor", '<>%1', 0);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                IF lItem."Last Direct Cost" <> 0 THEN BEGIN
                    "Unit Cost (LCY)" := lItem."Last Direct Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := lItem."Unit Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END;
            END;
            JobItemPrice.SETRANGE("Unit Cost Factor");
            JobItemPrice.SETRANGE("Item No.");
            JobItemPrice.SETRANGE(NS_Type, JobItemPrice.NS_Type::All);
            IF JobItemPrice.FINDFIRST THEN BEGIN
                JobItemPriceFound := TRUE;
                IF lItem."Last Direct Cost" <> 0 THEN BEGIN
                    "Unit Cost (LCY)" := lItem."Last Direct Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END ELSE BEGIN
                    "Unit Cost (LCY)" := lItem."Unit Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                    "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
                END;
            END;
        END;
        IF NOT JobItemPriceFound THEN BEGIN
            IF lItem."Last Direct Cost" <> 0 THEN BEGIN
                "Unit Cost (LCY)" := lItem."Last Direct Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
            END ELSE BEGIN
                "Unit Cost (LCY)" := lItem."Unit Cost" * (1 + JobItemPrice."Unit Cost Factor" / 100);
                "Unit Price (LCY)" := lItem."Unit Price" * (1 - JobItemPrice."Line Discount %" / 100);
            END;
        END;
        //ProjectPro - end
    END;

    LOCAL PROCEDURE NS_GetResourceCosts(JobResourcePrice: Record "Job Resource Price");
    VAR
        Resource: Record Resource;
        ResourcePrice: Record "Job Resource Price";
    BEGIN
        //ProjectPro - start
        IF Resource.GET("No.") THEN;
        IF "Job Task No." <> '' THEN BEGIN
            CASE JobResourcePrice.Type OF
                JobResourcePrice.Type::Resource:
                    BEGIN
                        IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END ELSE BEGIN
                            "Unit Cost (LCY)" := Resource."Unit Cost";
                            "Unit Price (LCY)" := Resource."Unit Price";
                        END;
                    END;
                JobResourcePrice.Type::"Group(Resource)":
                    BEGIN
                        Resource.RESET;
                        Resource.SETRANGE("Resource Group No.", "No.");
                        IF Resource.FINDFIRST THEN BEGIN
                            IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                                "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                                "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                            END ELSE BEGIN
                                "Unit Cost (LCY)" := Resource."Unit Cost";
                                "Unit Price (LCY)" := Resource."Unit Price";
                            END;
                        END;
                    END;
                JobResourcePrice.Type::All:
                    BEGIN
                        IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END ELSE BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END;
                    END;
            END;
        END ELSE BEGIN
            CASE JobResourcePrice.Type OF
                JobResourcePrice.Type::Resource:
                    BEGIN
                        IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END ELSE BEGIN
                            "Unit Cost (LCY)" := Resource."Unit Cost";
                            "Unit Price (LCY)" := Resource."Unit Price";
                        END;
                    END;
                JobResourcePrice.Type::"Group(Resource)":
                    BEGIN
                        Resource.RESET;
                        Resource.SETRANGE("Resource Group No.", "No.");
                        IF Resource.FINDFIRST THEN BEGIN
                            IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                                "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                                "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                            END ELSE BEGIN
                                "Unit Cost (LCY)" := Resource."Unit Cost";
                                "Unit Price (LCY)" := Resource."Unit Price";
                            END;
                        END;
                    END;
                JobResourcePrice.Type::All:
                    BEGIN
                        IF JobResourcePrice."NS_Unit Cost" <> 0 THEN BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END ELSE BEGIN
                            "Unit Cost (LCY)" := JobResourcePrice."NS_Unit Cost";
                            "Unit Price (LCY)" := JobResourcePrice."Unit Price";
                        END;
                    END;
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SetJobDemandOnly(PassJobDemand: Boolean);
    BEGIN
        JobDemandOnly := PassJobDemand;
    END;

    PROCEDURE NS_SetRetentionBase();
    var //PPAL-91.N.S.1.0 26aug2020
        NS_JobsSetup: Record "Jobs Setup";//PPAL-91.N.S.1.0 26aug2020
    BEGIN
        //ProjectPro - start
        "NS_Retention Base Amount" := 0;
        "NS_Retention Base Before Tax" := 0;
        IF "NS_Retention Applies" AND (Quantity <> 0) THEN BEGIN
            IF "NS_Subcontract No." = '' THEN BEGIN
                // "PP_Retention Base Amount" := "Amount Including VAT";//PRJ-206.MS.1.0 code comment
                // "PP_Retention Base Before Tax" := "Line Amount"; //PRJ-206.MS.1.0 code comment
                "NS_Retention Base Amount" := "Qty. to Receive" * "Direct Unit Cost"; //PJR-206.MS.1.0  
                "NS_Retention Base Before Tax" := "Qty. to Receive" * "Direct Unit Cost";//PJR-206.MS.1.0 
                ; //PJR-206.MS.1.0 

                //PRJ-939.JS.1.0 - Start  
                if "Document Type" = "Document Type"::"Credit Memo" then begin
                    "NS_Retention Base Amount" := Quantity * "Direct Unit Cost";
                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount";
                end;
                //PRJ-939.JS.1.0 - end   

            END ELSE BEGIN
                "NS_Retention Base Amount" := "Qty. to Receive" * "Direct Unit Cost"; //PJR-206.MS.1.0  
                "NS_Retention Base Before Tax" := "Qty. to Receive" * "Direct Unit Cost";//PRJ-206.MS.1.0 
                                                                                         //PRJ-206.MS.1.0 code comment
                                                                                         //"PP_Retention Base Amount" := "Qty. to Receive";
                                                                                         //"PP_Retention Base Before Tax" := "Qty. to Receive";
                                                                                         //IF Type <> Type::"G/L Account" THEN BEGIN
                                                                                         //    "PP_Retention Base Amount" := "PP_Retention Base Amount" * "Direct Unit Cost";
                                                                                         //    "PP_Retention Base Before Tax" := "PP_Retention Base Before Tax" * "Direct Unit Cost";
                                                                                         //END;
                                                                                         //PRJ-206.MS.1.0 code comment
                                                                                         //PPAL-91.N.S.1.0 26aug2020 Start
                NS_JobsSetup.Get();
                if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                    if "VAT %" <> 0 then
                        "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                    else
                        "NS_Retention Base Amount" := "Amount Including VAT";
                    "NS_Retention Base Before Tax" := "NS_Retention Base Amount";
                end;
                //PPAL-91.N.S.1.0 26aug2020 End
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_AssignDefaultValuesToTaxFields();
    VAR
        NS_Job: Record 167;
        GLAcc: Record "G/L Account";
    BEGIN
        //ProjectPro - start
        CASE Type OF
            Type::"G/L Account":
                IF GLAcc.GET("No.") THEN BEGIN
                    "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                    "Tax Group Code" := GLAcc."Tax Group Code";
                END;
            Type::Item:
                IF "No." <> '' THEN BEGIN
                    GetItem;
                    "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                    "Tax Group Code" := Item."Tax Group Code";
                END;
            Type::Resource:
                IF NS_Resource.GET("No.") THEN BEGIN
                    "VAT Prod. Posting Group" := NS_Resource."VAT Prod. Posting Group";
                    "Tax Group Code" := NS_Resource."Tax Group Code";
                END;
            Type::"Charge (Item)":
                IF ItemCharge.GET("No.") THEN BEGIN
                    "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                    "Tax Group Code" := ItemCharge."Tax Group Code";
                END;
        END;
        IF Type <> Type::" " THEN
            IF Type <> Type::"Fixed Asset" THEN
                IF "VAT Prod. Posting Group" <> '' THEN
                    VALIDATE("VAT Prod. Posting Group");
        IF "Job No." <> '' THEN
            IF NS_Job.GET("Job No.") THEN BEGIN
                IF NS_Job."NS_Tax Group Code New" <> '' THEN
                    IF "Tax Group Code" <> NS_Job."NS_Tax Group Code New" THEN
                        VALIDATE("Tax Group Code", NS_Job."NS_Tax Group Code New");
                IF NS_Job."NS_VAT Prod. Posting Group" <> '' THEN
                    IF "VAT Prod. Posting Group" <> NS_Job."NS_VAT Prod. Posting Group" THEN
                        VALIDATE("VAT Prod. Posting Group", NS_Job."NS_VAT Prod. Posting Group");
                GetPurchHeader;
                IF PurchHeader."NS_Job No." = '' THEN
                    IF NS_Job."NS_VAT Bus. Posting Group" <> '' THEN
                        VALIDATE("VAT Bus. Posting Group", NS_Job."NS_VAT Bus. Posting Group");
                //Note: according to the Microsoft business rules, the Tax Area Code can only be assigned at the header level
                //      and the purchase lines cannot have a mixture of Tax Area Code values
            END;
        //ProjectPro - end
    END;

    PROCEDURE NS_CalcRetentionBaseAmounts(VAR PurchaseLine: Record 39);
    VAR
        JobsSetup: Record 315;
        GLSetup: Record 98;
        PercentBeingUsed: Decimal;
        TaxPercent: Decimal;
        AmountBeingUsed: Decimal;
    BEGIN
        //ProjectPro - start
        "NS_Retention Base Amount" := 0;
        "NS_Retention Base Before Tax" := 0;
        TaxPercent := 0;
        JobsSetup.GET;
        GLSetup.GET;
        WITH PurchaseLine DO BEGIN
            PercentBeingUsed := 0;
            IF "Unit of Measure Code" = JobsSetup."NS_Subcontract Default UOM" THEN BEGIN
                AmountBeingUsed := "Qty. to Receive" - "Quantity Received";
                IF Amount <> 0 THEN
                    TaxPercent := ("Amount Including VAT" - Amount) / Amount;
                "NS_Retention Base Amount" := ROUND(AmountBeingUsed + (AmountBeingUsed * TaxPercent), GLSetup."Amount Rounding Precision");
                "NS_Retention Base Before Tax" := AmountBeingUsed;
            END ELSE BEGIN
                "NS_Retention Base Before Tax" := Amount;
                "NS_Retention Base Amount" := "Amount Including VAT";
            END;
            //PPAL-91.N.S.1.0 26aug2020 Start
            NS_JobsSetup.Get();
            if NS_JobsSetup."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/P RetentionTaxCalcMethod"::"1 - Calc tax on purchase then apply a retention value based on taxed purchase amount" then begin
                if "VAT %" <> 0 then
                    "NS_Retention Base Amount" := (Quantity * "Direct Unit Cost" * "VAT %" / 100) + Quantity * "Direct Unit Cost"
                else
                    "NS_Retention Base Amount" := "Amount Including VAT";
                "NS_Retention Base Before Tax" := "NS_Retention Base Amount";
            end;
            //PPAL-91.N.S.1.0 26aug2020 End
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_AdjustVATBaseAmount();
    VAR
        NS_GLSetup: Record "General Ledger Setup";
        NS_JobsSetup_Local: Record "Jobs Setup";
    BEGIN
        GetPurchHeader(); //SPLN1.00
        //ProjectPro - start
        IF PurchHeader."NS_Retention Percent" = 0 THEN
            EXIT;
        IF NS_JobsSetup_Local.GET THEN BEGIN
            IF NS_JobsSetup_Local."NS_A/P RetentionTaxCalcMethod" = NS_JobsSetup_Local."NS_A/P RetentionTaxCalcMethod"::"3 - Calc tax on purchase less the retention amount" THEN
                "VAT Base Amount" := "VAT Base Amount" - ROUND("VAT Base Amount" * (PurchHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
        END;
        //ProjectPro - end
    END;

    LOCAL PROCEDURE TestStatusOpen();
    BEGIN
        IF StatusCheckSuspended THEN
            EXIT;
        GetPurchHeader;
        IF NOT "System-Created Entry" THEN
            IF HasTypeToFillMandatoryFields THEN;
        PurchHeader.TESTFIELD(Status, PurchHeader.Status::Open.AsInteger());
    END;

    //PRJ-1314.JS.1.0 18APR2022 - Start
    [Obsolete('Now this procedure is available in Business Central Standard in Purchase Line and will be removed in ProjectPro upcomming release')] //PRJCTPR-168.JS.1.0 27July2023
    // Upgrade
    //PROCEDURE SuspendStatusCheck(Suspend: Boolean);
    PROCEDURE NS_SuspendStatusCheck(Suspend: Boolean);
    // << Upgrade
    BEGIN
        StatusCheckSuspended := Suspend;
    END;
    //PRJ-1314.JS.1.0 18APR2022 - end

    LOCAL PROCEDURE GetPurchHeader();
    BEGIN
        Rec.TESTFIELD("Document No.");
        IF ("Document Type" <> PurchHeader."Document Type") OR ("Document No." <> PurchHeader."No.") THEN BEGIN
            //PurchHeader.GET("Document Type", "Document No.");//PRJ-1096.GK.1.0 28Dec2021-comment
            if PurchHeader.GET("Document Type", "Document No.") then; //PRJ-1096.GK.1.0 28Dec2021 -Add
            IF PurchHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE BEGIN
                PurchHeader.TESTFIELD("Currency Factor");
                Currency.GET(PurchHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
        END;
    END;

    LOCAL PROCEDURE ReservEntryExist(): Boolean;
    VAR
        NewReservEntry: Record "Reservation Entry";
    BEGIN
        SetReservationFilters(NewReservEntry);
        NewReservEntry.SETRANGE("Reservation Status", NewReservEntry."Reservation Status"::Reservation,
          NewReservEntry."Reservation Status"::Tracking);

        EXIT(NOT NewReservEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE GetItem();
    BEGIN
        Rec.TESTFIELD("No.");
        IF Item."No." <> "No." THEN
            Item.GET("No.");
    END;

    //SPLN1.00 TTU added function to get JobDemandOnly
    procedure GetJobDemandOnly(): Boolean;
    begin
        EXIT(JobDemandOnly);
    end;

    ////PRJ-212 VT1.0 04-05-20 Begin
    local procedure CreateTempJobLineTempPP()
    var
        myInt: Integer;
        TempJobJnlLine: Record "Job Journal Line" temporary;
    begin
        if ("Job No." <> '') and ("Job Task No." <> '') then begin//PRJ-268 VT1.0 18-05-20
            GetPurchHeader;
            CLEAR(TempJobJnlLine);
            TempJobJnlLine.DontCheckStdCost;
            TempJobJnlLine.VALIDATE("Job No.", "Job No.");
            TempJobJnlLine.VALIDATE("Job Task No.", "Job Task No.");
            TempJobJnlLine.VALIDATE("Posting Date", PurchHeader."Posting Date");
            TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");

            IF Type = Type::"G/L Account" THEN
                TempJobJnlLine.validate(Type, TempJobJnlLine.Type::"G/L Account")
            else
                if Type = Type::Resource THEN
                    TempJobJnlLine.validate(Type, TempJobJnlLine.Type::Resource)
                else
                    if Type = Type::NS_Ledger THEN
                        TempJobJnlLine.validate(Type, TempJobJnlLine.Type::NS_Ledger) //PRJ-465.MS.1.0      
                    ELSE
                        TempJobJnlLine.validate(Type, TempJobJnlLine.Type::Item);


            //PRJ-1469.GK.2.0 04Oct2022 - Start
            //TempJobJnlLine.VALIDATE("No.", "No.");
            TempJobJnlLine."No." := "No.";
            //PRJ-1469.GK.2.0 04Oct2022 - Start            
            TempJobJnlLine.validate(Quantity, Quantity);
            TempJobJnlLine.VALIDATE("Variant Code", "Variant Code");
            TempJobJnlLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            TempJobJnlLine.Validate("NS_Job Cost Category", "NS_Job Cost Category");
            if "Direct Unit Cost" <> 0 then
                TempJobJnlLine.Validate("Unit Cost", "Direct Unit Cost");
            UpdateJobPrices_PP(TempJobJnlLine);
        end;
    end;

    local procedure UpdateJobPrices_PP(TempJobJnlLine: Record "Job Journal Line")
    var
        myInt: Integer;
    begin
        IF "Receipt No." = '' THEN BEGIN
            "Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
            "Job Unit Price" := TempJobJnlLine."Unit Price";
            "Job Total Price" := TempJobJnlLine."Total Price";
            "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
            "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
            "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
            "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
            "Job Line Amount" := TempJobJnlLine."Line Amount";
            "Job Line Discount %" := TempJobJnlLine."Line Discount %";
            "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
        END
    end;

    //PRJ-212 VT1.0 04-05-20 end

    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021112 Work Type Code
      +     14021115 Committed Quantity
      +     14021116 Committed Qty. (Base)
      +     14021117 Committed Amount (LCY)
      +     14021118 Committed Amount
      +     14021135 Retention Applies
      +     14021136 Balance To Print
      +     14021140 Retention Base Amount
      +     14021144 Retention Base Before Tax
      +     14021300 Subcontract No.
      +     14021305 Subcontract Payment Percent
      +     14021306 Subcontract Payment
      +     14021400 Staged
      +     14021401 JMP Document No.
      +     14021406 Accrual Account No.
      +     14021407 Bal. Accrual Account No.
      +     14021408 JMP Details
      +
      +  - Added function(s):
      +     SetRetentionBase
      +     PP_AssignDefaultValuesToTaxFields
      +     GetJobCosts
      +     GetGLCosts
      +     GetItemCosts
      +     GetResourceCosts
      +     SetJobDemandOnly
      +     PP_CalcRetentionBaseAmounts
      +     PP_AdjustVATBaseAmount
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_JobLinks
      +     PP_JobTaskLines
      +     PP_Currency
      +     PP_JobCurrencyFactorHold
      +     PP_JobCurrencyCodeHold
      +     PP_Resource
      +     PP_ResourceFindPrice
      +     PP_ResourceFindCost
      +     JobMatPlanning
      +     JobDemandOnly
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +     Text14021102
      +
      +  - Modification(s):
      +     - Added Key(s)
      +         Job No.
      +         Retention Applies
      +         Subcontract No.
      +     - OnDelete()
      +         Update the Balance Required balance field
      +     - OnValidate() modified fields
      +         Type
      +         No.
      +         Quantity
      +         Qty. to Invoice
      +         Job No.
      +         Job Task No.
      +         Job Planning Line No.
      +         Direct Unit Cost
      +         Job Cost Category
      +     - OnLookup() modified fields
      +         Type
      +     - Modifications to allow Resources to be processed
      +         In Type field specified Resource as the third option string element
      +         Added Ledger to the end of option strings
      +     - Modifications to the following standard processes
      +         InitOutstanding
      +         InitOutstandingAmount
      +         UpdateUOMQtyPerStockQty
      +         SetJobDemandOnly
      +     - Set 'Amount Including VAT' to be 'Subcontract Payment Value' if there is one.
      +-----------------------------------------------------------------------------------------------*/
}

