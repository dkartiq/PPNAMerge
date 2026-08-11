pageextension 14021123 NS_PurchaseOrderSubForm extends "Purchase Order Subform"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-82.SK.1.0 Start Blocked previous code and added new code , means used the original No. field instead of creating new onw.
    //PRJ-277.MS.1.0 code comment 
    //TM-10.AM.1.0 | Added Field & Code.
    //PRJ-490.MS.1.0 added new field
    //PRJ-492.RS.1.0 10May2021 | Hide/Unhide Fields 
    //PRJ-817.JS.1.0�26July2021 | Add fields
    //PRJ-856.GK.1.0 20Aug2021 |Added new condition for Subcontract PO Qty. to Invoice validation.
    //PRJ-1165.JS.1.0 24JAN2022 | correction for retention ledger
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJCTPR-37.JS.1.0 13JAN2023 | line commented to update Amount including VAT, command place in wrong event
    //PE-210.HS.1.0 23Nov2023| Add Code

    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("No.")
        {
            //PRJ-82.SK.1.0 Start
            //Visible = false; 
            //Enabled = false;
            trigger OnBeforeValidate()
            var
                NSJobCostCategory: record "NS_Job Cost Category"; //PRJCTPR-185.JS.1.0 01Sep2023s
            begin
                //PRJ-1165.JS.1.0 24JAN2022-Start
                IF Rec.Type = Rec.Type::NS_Ledger THEN BEGIN
                    //NS_Resource.GET("No.");
                    //"NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
                    if NS_Resource.GET(Rec."No.") then
                        Rec."NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
                    //PRJ-1165.JS.1.0 24JAN2022-end
                END;
                //PRJCTPR-60 NK.1.0 13feb2022 start
                if Rec.Type = Rec.Type::"G/L Account" then begin
                    if GLAccount.Get(Rec."No.") then
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                    //PRJCTPR-185.JS.1.0 01Sep2023 - Start
                    if Rec."NS_Job Cost Category" = '' then begin
                        NSJobCostCategory.Reset();
                        NSJobCostCategory.SetCurrentKey("NS_G/L Account No.");
                        NSJobCostCategory.SetRange("NS_G/L Account No.", rec."No.");
                        if NSJobCostCategory.FindFirst() then
                            rec."NS_Job Cost Category" := NSJobCostCategory.NS_Code;
                    end;
                    if Rec."Line No." <> 0 then //PRJCTPR-185.AT.1.0  31OCT2023
                        Rec.Modify();
                    //PRJCTPR-185.JS.1.0 01Sep2023 - end                        
                end;
                //PRJCTPR-60.NK.1.0 13feb2022 end
            end;
            //PRJ-82.SK.1.0 End

        }
        //PRJ-82.SK.1.0 Start
        // addafter(FilteredTypeField)
        // {
        //     field("No.2"; "No.")
        //     {
        //         Caption = 'No.';
        //         ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
        //         ApplicationArea = Suite;
        //         trigger OnValidate();
        //         begin
        //             ShowShortcutDimCode(ShortcutDimCode);
        //             //ProjectPro - start
        //             IF Type = Type::Ledger THEN BEGIN
        //                 PP_Resource.GET("No.");
        //                 "Job Cost Category" := PP_Resource."Job Cost Category";
        //             END;
        //             //ProjectPro - end
        //             NoOnAfterValidate;

        //             IF xRec."No." <> '' THEN
        //                 RedistributeTotalsOnAfterValidate;
        //             UpdateTypeText;
        //         end;
        //     }
        // }
        //PRJ-82.SK.1.0 End

        modify("Qty. to Receive")
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start

                //IF ("Unit of Measure Code" = PP_JobSetup."PP_Subcontract Default UOM") AND PP_SubcontractType(Type.AsInteger()) THEN BEGIN	//PRJ-277.MS.1.0 comment
                "NS_Subcontract Payment Value" := ("Quantity Received" + "Qty. to Receive") * "Direct Unit Cost";
                IF "Quantity (Base)" * "Direct Unit Cost" <> 0 THEN
                    "NS_Subcontract Payment Percent" := ((("Qty. to Receive" + "Quantity Received") * "Direct Unit Cost") / "Line Amount") * 100
                ELSE
                    ERROR(Text14021100);
                //Rec.VALIDATE("Amount Including VAT");     //PRJCTPR-37.JS.1.0 13JAN2023 line commented
                Rec.NS_SetRetentionBase();
                //PRJ-1135.NK.1.0 end
                //END;  //PRJ-277.MS.1.0 comment

                //ProjectPro - end

            end;
        }

        modify("Qty. to Invoice")
        {
            trigger OnBeforeValidate();
            begin
                //ProjectPro - start


                IF ("Unit of Measure Code" = NS_JobSetup."NS_Subcontract Default UOM") AND NS_SubcontractType(Type.AsInteger()) AND ("NS_Subcontract No." <> '') THEN  //PRJ-856.GK.1.0 20Aug2021 checking the PO should be create from Subcontract.
                    ERROR(Text14021103);


                //ProjectPro - end
            end;
        }

        modify("Job No.")
        {
            Visible = true;
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }

        //PPDA.1.0.TBA Start
        // modify("IRS 1099 Liable")
        // {
        //     Visible = true;
        // }
        //PPDA.1.0.TBA End
        //PE-210.HS.1.0 23Nov2023 Start
        modify("Direct Unit Cost")
        {
            StyleExpr = NS_color;
            trigger OnAfterValidate()
            begin
                Clear(NS_color);
                if NS_JobSetup.Get() then;
                if NS_JobSetup.NS_CostExceedsColor then begin
                    NS_JPL.Reset();
                    NS_JPL.SetRange("Job No.", rec."Job No.");
                    NS_JPL.SetRange("Job Task No.", rec."Job Task No.");
                    NS_JPL.SetRange("Line No.", rec."NS_Job Planning Line No.");
                    if NS_JPL.FindSet() then begin
                        if rec."Direct Unit Cost" > NS_JPL."Unit Cost" then
                            NS_color := 'Unfavorable'
                        else
                            NS_color := 'standard';
                    end;
                end
            end;

        }
        //PE-210.HS.1.0 23Nov2023 End
        addafter("Job No.")
        {
            field("NS_Retention Base Amount"; Rec."NS_Retention Base Amount")
            {
                ApplicationArea = All;
                Visible = false; //PRJ-492.AS.1.0
            }

        }
        //addafter("Job Task No.")//PRJ-492.N.S.1.0
        addbefore("Location Code")//PRJ-492.N.S.1.0
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Visible = false;

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Committed Quantity"; Rec."NS_Committed Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the "Committed Quantity';
                Visible = false; //PRJ-492.AS.1.0 //Doubt
            }
        }
        //addafter("Variant Code")//PRJ-492.N.S.1.0 
        /* addafter("Tax Group Code")//PRJ-492.N.S.1.0 
         {
             field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the Gen. Bus. Posting Group';
             }
             field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the Gen. Prod. Posting Group';
             }
         }*/
        addafter(Description)
        {
            field("NS_Work Type Code"; Rec."NS_Work Type Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Type Code';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
        addafter("Location Code")
        {
            field(NS_Staged; NS_Staged)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Staged';
                Visible = false; //PRJ-492.AS.1.0 //Doubt
            }
        }
        //PRJ-492.N.S.1.0 Start
        addafter("Direct Unit Cost")
        {
            field("NS_Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Amount Including VAT';
            }
        }
        //PRJ-492.N.S.1.0 End
        addafter("Line Discount %")
        {
            //PRJ-492.N.S.1.0 Start
            // field("NS_Amount Including VAT"; Rec."Amount Including VAT")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the Amount Including VAT';
            // }
            //PRJ-492.N.S.1.0 End
            field("NS_Retention Applies"; Rec."NS_Retention Applies")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Applies';
                Visible = false; //PRJ-492.AS.1.0 //Doubt
            }
        }
        addafter("Inv. Disc. Amount to Invoice")
        {
            field("NS_Subcontract Payment Percent"; Rec."NS_Subcontract Payment Percent")
            {
                ApplicationArea = All;
                BlankZero = true;
                Editable = true; //NS_SubcontractPaymentEditable; //PRJ-277.MS.1.0 code comment
                ToolTip = 'Specifies the Subcontract Payment Percent';
                Visible = false; //PRJ-492.AS.1.0 //Doubt

                trigger OnValidate();
                begin
                    //ProjectPro - start

                    //if ("Unit of Measure Code" = NS_JobSetup."NS_Subcontract Default UOM") and NS_SubcontractType(Type.AsInteger()) then begin  //PRJ-277.MS.1.0 comment
                    if ("NS_Subcontract Payment Percent" = 0) and ("Quantity Received" < Quantity) then
                        if Quantity <> 0 then
                            "NS_Subcontract Payment Percent" := "Quantity Received" / Quantity * 100
                        else
                            ERROR(Text14021102);
                    "NS_Subcontract Payment Value" := "Quantity (Base)" * ("NS_Subcontract Payment Percent" / 100) * "Direct Unit Cost";
                    "Qty. to Receive" := ("Quantity (Base)" * ("NS_Subcontract Payment Percent" / 100)) - "Quantity Received";
                    if "Qty. to Receive" < 0 then
                        ERROR(Text14021104, FORMAT("Quantity Received"), FORMAT("Quantity Received" + "Qty. to Receive"));
                    VALIDATE("Amount Including VAT");
                    VALIDATE("Qty. to Receive");
                    NS_SetRetentionBase;
                    //end; //PRJ-277.MS.1.0 comment


                    //ProjectPro - end
                end;
            }
            field("NS_Subcontract Payment Value"; Rec."NS_Subcontract Payment Value")
            {
                ApplicationArea = All;
                BlankZero = true;
                Editable = True;//NS_SubcontractPaymentEditable;//PRJ-277.MS.1.0 code comment
                ToolTip = 'Specifies the Subcontract Payment Value';
                Visible = false; //PRJ-492.AS.1.0

                trigger OnValidate();
                begin
                    //ProjectPro - start


                    //if ("Unit of Measure Code" = NS_JobSetup."NS_Subcontract Default UOM") and NS_SubcontractType(Type.AsInteger()) then begin//PRJ-277.MS.1.0 comment
                    if ("NS_Subcontract Payment Value" = 0) and ("Quantity Received" < Quantity) then
                        "NS_Subcontract Payment Value" := "Quantity Received" * "Direct Unit Cost";
                    if "Quantity (Base)" * "Direct Unit Cost" <> 0 then
                        "NS_Subcontract Payment Percent" := ("NS_Subcontract Payment Value" / ("Quantity (Base)" * "Direct Unit Cost")) * 100
                    else
                        ERROR(Text14021101);
                    if "Direct Unit Cost" <> 0 then
                        "Qty. to Receive" := ("NS_Subcontract Payment Value" / "Direct Unit Cost") - "Quantity Received"
                    else
                        ERROR(Text14021101);
                    if "Qty. to Receive" < 0 then
                        ERROR(Text14021104, FORMAT("Quantity Received"), FORMAT("Quantity Received" + "Qty. to Receive"));
                    VALIDATE("Qty. to Receive");
                    VALIDATE("Amount Including VAT");
                    NS_SetRetentionBase;
                    //end; //PRJ-277.MS.1.0 comment


                    //ProjectPro - end
                end;
            }
        }

        // moveafter("Quantity Invoiced"; "IRS 1099 Liable") //PPDA.1.0.TBA Commenetd //PRJ-492.RS.1.0 10May2021
        addafter("Line No.")
        {
            field("NS_FA Job Usage"; "NS_FA Job Usage")
            {
                ApplicationArea = all;
                Description = 'PRJ-490.MS.1.0';
                Visible = false;//PRJ-492.N.S.1.0
            }
            //PRJ-490.AM.1.0 Start
            field("NS_FA Job No."; "NS_FA Job No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0
            }
            field("NS_FA Job Task No."; "NS_FA Job Task No.")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0
            }
            //PRJ-490.AM.1.0 End   
        }

        //PRJ-817.JS.1.0�26July2021-Start
        addafter("Unit of Measure Code")
        {
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ToolTip = 'Specifies the value of the Work Units field';
                ApplicationArea = All;
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ToolTip = 'Specifies the value of the Work Unit of Measure field';
                ApplicationArea = All;
            }

        }
        //PRJ-817.JS.1.0�26July2021-End

        moveafter("No."; "Job No.")

        //moveafter("NS_Subcontract No."; "Job Task No.")

        //movebefore("GST/HST"; "Job Task No.")//PRJ-492.N.S.1.0//PRJ-492.RS.1.0 10May2021 Comment
        modify("Job Task No.")
        {
            Visible = true;
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }

        //PRJ-492.RS.1.0 10May2021 Start
        moveafter("Job No."; "Job Task No.")
        //PPDA.1.0 Comment - start
        // modify("GST/HST")
        // {
        //     Visible = false;
        // }
        //PPDA.1.0 Comment - end
        modify("Bin Code")
        {
            Visible = false;
        }
        addafter("Job Task No.")
        {
            field("NS_FA Segment Code"; "NS_FA Segment Code")
            {
                ApplicationArea = all;
                Visible = false;//PRJ-492.N.S.1.0 
                ToolTip = 'Select the Segment '; //PRJ-1579.RM.1.0 

            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = All;
                Caption = 'Segment Code';
                ToolTip = 'Select the Segment '; //PRJ-1579.RM.2.0 
                Description = 'TM-10.AM.1.0';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 25May2021 comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
            }
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        moveafter("Expected Receipt Date"; "Reserved Quantity")
        moveafter("Direct Unit Cost"; "Line Amount")
        moveafter("Line Amount"; "Tax Area Code")
        movebefore("NS_Amount Including VAT"; "Tax Group Code")
        moveafter("Quantity Received"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        moveafter("Quantity Invoiced"; "Promised Receipt Date")
        moveafter("Promised Receipt Date"; "Planned Receipt Date")
        moveafter("Planned Receipt Date"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Reserved Quantity")
        //moveafter("Reserved Quantity"; "IRS 1099 Liable")//PRJ-492 Test Commented this V17 Code
        //moveafter("IRS 1099 Liable"; "Qty. to Assign")//PRJ-492 Test Commented this V17 Code
        moveafter("Reserved Quantity"; "Qty. to Assign")//PRJ-492 Test Added this code in place of above commented code
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter("Qty. Assigned"; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        moveafter("No."; Description)
        addafter("Shortcut Dimension 2 Code")
        {
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_JMP Document No."; Rec."NS_JMP Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Material Planning Document No.';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021
            }
            field("NS_JMP Details"; Rec."NS_JMP Details")
            {
                ApplicationArea = All;
                caption = 'JMP Details (Obsolete)';   //PRJCTPR-256.JS.1.0 14DEC2023
                ToolTip = 'Specifies the Job Material Planning Details';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021
                //PRJCTPR-256.JS.1.0 14DEC2023 - Start
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by new field “JMP Details” with increased length 100 characters';
                ObsoleteTag = 'Repleace in ProjectPro Upcomming release 23.0.XX.XXXX';
                //PRJCTPR-256.JS.1.0 14DEC2023 - end
            }
            //PRJCTPR-256.JS.1.0 14DEC2023 - Start
            field("NS_PPJMP Details"; Rec."NS_PPJMP Details")
            {
                caption = 'JMP Details';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Material Planning line Details';
            }
            //PRJCTPR-256.JS.1.0 14DEC2023 - end
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;

        }
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;//(PM Code)
        }
        modify("Qty. to Assign")//PRJ-492.RS.2.0 21May2021
        {
            ApplicationArea = all;
        }
        modify("Qty. Assigned")//PRJ-492.RS.2.0 21May2021
        {
            ApplicationArea = all;
        }
        modify("Shortcut Dimension 1 Code")//PRJ-492.RS.2.0 21May2021
        {
            ApplicationArea = all;
        }
        modify("Shortcut Dimension 2 Code")//PRJ-492.RS.2.0 21May2021
        {
            ApplicationArea = All;
        }
        addafter("NS_Gen. Prod. Posting Group")
        {
            field("NS_Depreciation Book Code"; Rec."Depreciation Book Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Depreciation Book Code';
                Caption = 'Depreciation Book Code';
                //Visible = false;//PRJ-492.N.S.1.0 //PRJ-492.RS.2.0 27May2021 Comment
                Visible = true;//PRJ-492.RS.2.0 27May2021
            }
        }
        //PRJ-492.RS.1.0 10May2021 end
    }
    actions
    {
        addafter(OrderTracking)
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';

                trigger OnAction();
                var
                    JobPlanningList: Page "NS_Get Job Planning Line";
                    PP_JobPlanningLine: Record "job planning line";
                    PP_PurchaseHeader: Record "Purchase header";
                begin
                    //CTSI-155.MS.1.0 start
                    PP_PurchaseHeader.GET("Document Type", "Document No.");
                    PP_PurchaseHeader.TESTFIELD("NS_Job No.");
                    JobPlanningList.LOOKUPMODE := true;
                    PP_JobPlanningLine.RESET;
                    PP_JobPlanningLine.SETRANGE("Job No.", PP_PurchaseHeader."NS_Job No.");
                    JobPlanningList.SETTABLEVIEW(PP_JobPlanningLine);
                    JobPlanningList.NS_SetGetFrom("Document Type", 2, "Document No.");
                    JobPlanningList.NS_Set('', PP_PurchaseHeader."NS_Job No.", '', '', '', 0);
                    JobPlanningList.RUNMODAL;
                    CLEAR(JobPlanningList);
                    //CTSI-155.MS.1.0 end
                    //ProjectPro - start
                    //NS_GetJobBudget(''); //CTSI-155 comment
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        NS_GLSetup: Record "General Ledger Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";
        Text002: Label 'A value can not be entered here since this is a G/L Account entry with a %1 Unit of measure.';
        NS_UnitOfMeasure: Record "Unit of Measure";
        NS_JobSetup: Record "Jobs Setup";
        NS_OrigLinePercent: Decimal;
        NS_OrigLineAmount: Decimal;
        NS_OrigLineQtyToReceive: Decimal;
        NS_OrigLineQtyToInv: Decimal;
        NS_UOMSubcontractDesc: Text[10];
        JobNo: Code[20];
        Text14021102: Label 'There must be a value for Quantity.';
        Text14021103: Label 'Direct entry of Qty. to Invoice on subcontract lines is not allowed.  Enter the value into Qty. to Receive.';
        Text14021104: Label 'There has already been %1  received, and this is coming to %2.';
        Text14021100: Label 'There must be a value for Quantity and Direct Unit Cost.';
        Text14021101: Label 'There must be a value for Direct Unit Cost.';
        NS_SubcontractPaymentEditable: Boolean;
        PurchaseHeader: Record 38;
        ShortcutDimCode: ARRAY[8] OF Code[20];
        UnitofMeasureCodeIsChangeable: Boolean;
        IsCommentLine: Boolean;
        TransferExtendedText: Codeunit 378;
        TypeAsText: Text[30];
        TempOptionLookupBuffer: Record 1670;
        EditBool: Boolean;
        GLAccount: Record "G/L Account"; //PRJCTPR-60.NK.1.0 13feb2022
        NS_color: Text; //PE-210.HS.1.0 23Nov2023
        NS_JPL: Record "Job Planning Line";  //PE-210.HS.1.0 23Nov2023

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        NS_OrigLinePercent := 0;
        NS_OrigLineAmount := 0;
        NS_OrigLineQtyToReceive := 0;
        NS_OrigLineQtyToInv := 0;


        IF NS_SubcontractType(Type.AsInteger()) AND ("Unit of Measure" = NS_UOMSubcontractDesc) THEN BEGIN
            NS_OrigLinePercent := "NS_Subcontract Payment Percent";
            NS_OrigLineAmount := "NS_Subcontract Payment Value";
            NS_OrigLineQtyToReceive := "Qty. to Receive";
            NS_OrigLineQtyToInv := "Qty. to Invoice";
            //PRJ-277.MS.1.0 code comment
            //IF "Qty. to Receive" = 1 - "Quantity Received" THEN BEGIN
            //"Qty. to Receive" := 0;
            //"Qty. to Invoice" := 0;
            //END;
            //PRJ-277.MS.1.0 code comment
        END;
        //ProjectPro - end

        //PE-210.HS.1.0 23Nov2023 Start
        Clear(NS_color);
        if NS_JobSetup.Get() then;
        if NS_JobSetup.NS_CostExceedsColor then begin
            NS_JPL.Reset();
            NS_JPL.SetRange("Job No.", rec."Job No.");
            NS_JPL.SetRange("Job Task No.", rec."Job Task No.");
            NS_JPL.SetRange("Line No.", rec."NS_Job Planning Line No.");
            if NS_JPL.FindSet() then begin
                if rec."Direct Unit Cost" > NS_JPL."Unit Cost" then
                    NS_color := 'Unfavorable'
                else
                    NS_color := 'standard';
            end;
        end
        //PE-210.HS.1.0 23Nov2023 End
    end;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_GLSetup.GET;
        NS_PurchSetup.GET;
        NS_JobSetup.GET;
        NS_UOMSubcontractDesc := '';
        IF NS_JobSetup."NS_Subcontract Default UOM" > '' THEN BEGIN
            IF NS_UnitOfMeasure.GET(NS_JobSetup."NS_Subcontract Default UOM") THEN
                NS_UOMSubcontractDesc := NS_UnitOfMeasure.Description;
        END;
        //ProjectPro - end
    end;


    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //ProjectPro - start
        "NS_Retention Applies" := TRUE;
        IF Type <> Type::" " THEN
            IF PurchaseHeader.GET("Document Type", "Document No.") THEN
                IF PurchaseHeader."NS_Job No." <> '' THEN
                    VALIDATE("Job No.", PurchaseHeader."NS_Job No.");
        //ProjectPro - end
    end;

    procedure NS_GetJobBudget(VendNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_Job: Record Job;
        NS_PurchHeader: Record "Purchase Header";
        NS_PurchLine: Record "Purchase Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
    begin
        //ProjectPro - start
        if NS_Job.GET(JobNo) then
            "Job No." := JobNo
        else
            TESTFIELD("Job No.");
        NS_JobPlanningLine."Job No." := "Job No.";
        NS_JobPlanningLine."NS_Entry Type" := NS_JobPlanningLine."NS_Entry Type"::Cost;
        NS_GetJobPlanningLine.NS_Set(VendNo,
                                  NS_JobPlanningLine."Job No.",
                                  NS_JobPlanningLine."NS_Cost Category",
                                  NS_JobPlanningLine."NS_Revenue Category",
                                  NS_JobPlanningLine."Job Task No.",
                                  NS_JobPlanningLine."NS_Entry Type");

        if NS_GetJobPlanningLine.RUNMODAL = ACTION::LookupOK then begin
            NS_GetJobPlanningLine.NS_Get(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_JobPlanningLine.GET(NS_JobNo, NS_JobTaskNo, NS_LineNo);
            NS_PurchHeader.GET("Document Type", "Document No.");
            NS_LineNo := 0;
            NS_PurchLine.RESET;
            NS_PurchLine.SETRANGE("Document Type", NS_PurchHeader."Document Type");
            NS_PurchLine.SETRANGE("Document No.", NS_PurchHeader."No.");
            if NS_PurchLine.FINDLAST then
                NS_LineNo := NS_PurchLine."Line No.";
            NS_LineNo := NS_LineNo + 10000;

            with NS_PurchLine do begin
                INIT;
                "Document Type" := NS_PurchHeader."Document Type";
                "Document No." := NS_PurchHeader."No.";
                "Line No." := NS_LineNo;
                case NS_JobPlanningLine.Type of
                    NS_JobPlanningLine.Type::Resource:
                        Type := Type::Resource;
                    NS_JobPlanningLine.Type::Item:
                        Type := Type::Item;
                    NS_JobPlanningLine.Type::"G/L Account":
                        Type := Type::"G/L Account";
                end;
                VALIDATE(Type);
                VALIDATE("No.", NS_JobPlanningLine."No.");
                "Variant Code" := NS_JobPlanningLine."Variant Code";
                Description := NS_JobPlanningLine.Description;
                "Gen. Bus. Posting Group" := NS_JobPlanningLine."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := NS_JobPlanningLine."Gen. Prod. Posting Group";
                VALIDATE("Location Code", NS_JobPlanningLine."Location Code");
                "Bin Code" := NS_JobPlanningLine."Bin Code";
                "Unit of Measure Code" := NS_JobPlanningLine."Unit of Measure Code";
                "Unit Cost" := NS_JobPlanningLine."Unit Cost";
                "Unit Cost (LCY)" := NS_JobPlanningLine."Unit Cost (LCY)";
                "Direct Unit Cost" := NS_JobPlanningLine."Unit Cost";
                VALIDATE(Quantity, NS_JobPlanningLine.Quantity);
                "Job No." := NS_JobPlanningLine."Job No.";
                "Job Task No." := NS_JobPlanningLine."Job Task No.";
                "NS_Job Cost Category" := NS_JobPlanningLine."NS_Cost Category";
                "NS_Job Revenue Category" := NS_JobPlanningLine."NS_Revenue Category";
                "Shortcut Dimension 1 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                "Dimension Set ID" := NS_JobPlanningLine."NS_Dimension Set ID";
                "Job Planning Line No." := NS_JobPlanningLine."Line No.";
                "NS_Segment Code" := NS_JobPlanningLine."NS_Segment Code";//TM-10.AM.1.0
                INSERT;
            end;
        end;

        CLEAR(NS_GetJobPlanningLine);
        //ProjectPro - end
    end;

    procedure NS_SetJobNo(pJobNo: Code[20]);
    begin
        JobNo := pJobNo;
    end;

    local procedure NS_SubcontractType(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",Ledger): Boolean;
    begin
        if (Type = Type::"G/L Account") or (Type = Type::Resource) then
            exit(true)
        else
            exit(false);
    end;

    local procedure NS_SetSubcontractValuesEditableStatus();
    begin
        if "Unit of Measure Code" <> NS_JobSetup."NS_Subcontract Default UOM" then begin
            NS_SubcontractPaymentEditable := false;
            "NS_Subcontract Payment Percent" := 0;
            "NS_Subcontract Payment Value" := 0;
        end else
            NS_SubcontractPaymentEditable := true;
        CurrPage.UPDATE;
    end;

    LOCAL PROCEDURE NoOnAfterValidate();
    BEGIN
        UpdateEditableOnRow;
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow();
    BEGIN
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
        IsCommentLine := Type = Type::" ";
    END;

    LOCAL PROCEDURE InsertExtendedText(Unconditionally: Boolean);
    BEGIN
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    /* Documentation
       +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Subcontract No.
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +     Committed Quantity
      +     PP Gen. Bus. Posting Group
      +     PP Gen. Prod. Posting Group
      +     PP Work Type Code
      +     Staged
      +     PP Amount Including VAT
      +     PP Retention Applies
      +     PP_SubcontractPaymentEditable
      +     Subcontract Payment Percent
      +     Subcontract Payment Value
      +     Qty. to Receive
      +     JMP Document No.
      +     JMP Details"
      +
      +  - Added function(s):
      +     PP_GetJobBudget
      +     PP_SetJobNo
      +     PP_SubcontractType
      +     PP_SetSubcontractValuesEditableStatus
      +
      +  - Added global variable(s):
      +     PP_GetJobPlanningLine
      +     PP_Job
      +     PP_Resource
      +     PP_GLSetup
      +     PP_PurchSetup
      +     PP_UnitOfMeasure
      +     PP_JobSetup
      +     PP_OrigLinePercent
      +     PP_OrigLineAmount
      +     PP_OrigLineQtyToReceive
      +     PP_OrigLineQtyToInv
      +     PP_UOMSubcontractDesc
      +     JobNo
      +     PP_SubcontractPaymentEditable
      +
      +  - Added global text constant(s):
      +     Text002
      +     Text14021102
      +     Text14021103
      +     Text14021104
      +     Text14021100
      +     Text14021101
      +
      +  - Modification(s):
      +     - OnInit
      +         PP_GLSetup;
      +         PP_PurchSetup.GET;
      +         PP_JobSetup.GET;
      +         Init Variables
      +
      +     - OnAfterGetRecord - Field Calculations
      +         Set originals line vaules for subcontacts
      +
      +     - OnNewRecord
      +         Set Job No to one that is defined on the header
      +         Set Retention Applies TRUE
      +
      +     - Added action list:
      +         PP Get Job Planning Line
      +
      +     - Modified controls:
      +         No.             - OnValidate - Type::Ledger processing
      +         Job No.         - OnValidate - Call CorrectForBlankFields
      +                         - Visibility set TRUE
      +         Job Task No.    - OnValidate - Call PP_Job.CorrectForBlankFields
      +                         - Visibility set TRUE
      +         Qty. to Invoice - OnValidate - Error if Qty to Invoice is entered on a Subcontract line
      +         Qty. to Receive - OnValidate - Set subcontract values
      +         Qty. to Invoice - OnValidate - Error if Qty to Invoice is entered on a Subcontract line
      +     - Default standard fields to visable
      +         Job No.
      +         Job Task No.
      +         IRS 1099 Liable
      +
      + -SMP
      +  -Modified Page Triggers
      +   -Moved ccustom code from init to OnOpenPage
      +   -OnAfterGetRecord
      +   -OnNewRecord
      +  -Rewritten field
      +   -No.
      +  -Modified Fields
      +   -Qty. to Receive
      +   -Qty. to Invoice
      +   -Job No. and moved
      +   -Job Task No.
      +-----------------------------------------------------------------------------------------------
      */

}

