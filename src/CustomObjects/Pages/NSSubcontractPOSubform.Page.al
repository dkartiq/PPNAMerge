page 14021312 "NS_Subcontract PO Subform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-108.SK.1.0 Added code for removing misleading captions
    //PRJ-111.SK.1.0 Blocked prperty on a field
    //PRJ-274 VT1.0 22-05-20
    //PRJ-277.MS.1.0  code for retention
    //PPAL-73.N.S.1.0 27Aug2020 Add field tax area code		
    //PRJ-383.N.S.1.0 16Sep2020 Add field
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-817.JS.1.0-11Aug2021 | Add fields work unit , work unit of measur , work unit completed
    //PRJ-1221.JS.1.0 24FEB2022 | Correct code for item cross reference
    //PRJ-1354.RM.1.0 16May2022 | Commented some code
    //PRJ-1563.JS.1.0 10Aug2022 | Correct Code
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));//PRJ-274 VT1.0 22-05-20  //PRJ-1563.JS.1.0 Uncomment line
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type';

                    trigger OnValidate();
                    begin
                        NS_NoOnAfterValidate();
                        TypeChosen := HasTypeToFillMandatoryFields();

                        if xRec."No." <> '' then
                            NS_RedistributeTotalsOnAfterValidate();
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    ShowMandatory = TypeChosen;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        if Type = Type::NS_Ledger then begin
                            PP_Resource.GET("No.");
                            "NS_Job Cost Category" := PP_Resource."NS_Job Cost Category";
                        end;
                        NS_NoOnAfterValidate();

                        if xRec."No." <> '' then
                            NS_RedistributeTotalsOnAfterValidate();
                    end;
                }
                //PRJ-492.N.S.1.0 Start
                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the item or service on the line.';
                }
                //PRJ-492.N.S.1.0 End
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Job No.';
                    Visible = true;//PRJ-492.RS.1.0 11May2021

                    trigger OnValidate();
                    begin
                        PP_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    end;
                }

                field("PP Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Subcontract No.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        PP_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    end;
                }

                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        PP_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    end;
                }
                //PRJ-492.RS.1.0 11May2021 Start
                field("NS_Segment Code"; "NS_Segment Code")
                {
                    ApplicationArea = All;//PRJ-492.RS.1.0 25May2021
                }
                //PRJ-492.N.S.1.0 Start
                field("PP Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group';
                }
                field("PP Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Gen. Prod. Posting Group';
                }
                field("Depreciation Book Code"; "Depreciation Book Code")
                {
                    ApplicationArea = All;//PRJ-492.RS.1.0 27May2021
                }
                //PRJ-492.N.S.1.0 End
                //PRJ-492.RS.1.0 11May2021 end
                field("PP Job Cost Category"; Rec."NS_Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Cost Category';

                    trigger OnValidate();
                    begin
                        PP_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    end;
                }
                field("PP Job Revenue Category"; Rec."NS_Job Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Revenue Category';
                    Visible = false;

                    trigger OnValidate();
                    begin

                        PP_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    end;
                }


                field("Committed Quantity"; Rec."NS_Committed Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Committed Quantity';
                    Visible = false;//PRJ-492.RS.1.0 11May2021
                }

                //PRJ-1221.JS.1.0 24FEB2022 - start

                field("Cross-Reference No."; '')//PE-59.GK.1.0 14Mar2023
                {
                    ApplicationArea = Suite;
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Because the field is removed by Base System Application';
                    Editable = false;
                    Enabled = false;
                    // HideValue = true;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;

                    // trigger OnLookup(VAR Text: Text): Boolean;
                    // begin
                    //     Rec.CrossReferenceNoLookUp(); //PRJ-1131.NK.1.0
                    //     NS_InsertExtendedText(false);
                    //     NS_NoOnAfterValidate;
                    // end;

                    // trigger OnValidate();
                    // begin
                    //     NS_CrossReferenceNoOnAfterValidat;
                    //     NS_NoOnAfterValidate;
                    // end;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the referenced item number. If you enter a referenced item number between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the referenced item number on a sales or purchase document.';
                    Visible = false;

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        ItemRefMagCodeunit: codeunit "Item Reference Management";
                    begin
                        //ItemRefMagCodeunit.CrossReferenceNoLookUp(); //PRJ-1131.NK.1.0
                        ItemRefMagCodeunit.PurchaseReferenceNoLookup(Rec);
                        NS_InsertExtendedText(false);
                        NS_NoOnAfterValidate();
                    end;

                    trigger OnValidate();
                    begin
                        NS_CrossReferenceNoOnAfterValidat();
                        NS_NoOnAfterValidate();
                    end;

                }
                //PRJ-1221.JS.1.0 24FEB2022 - end
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the IC Partner Code';
                    Visible = false;
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the IC Partner Ref. Type';
                    Visible = false;
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the IC Partner Reference';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                //PRJ-492.N.S.1.0 Start
                // field("PP Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Gen. Bus. Posting Group';
                // }
                // field("PP Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Gen. Prod. Posting Group';
                // }
                //PRJ-492.N.S.1.0 End
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Nonstock';
                    Visible = false;
                }
                //PPDA.1.0.TBA Start
                // field("GST/HST"; Rec."GST/HST")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Enabled = false;
                //     HideValue = true;
                //     ToolTip = ' Specifies the type of goods and services tax (GST) for the purchase line. You can select Acquisition, Self-Assessment, Rebate, New Housing Rebates, or Pension Rebate for the GST tax.';
                //     Visible = false;
                // }
                //PPDA.1.0.TBA End

                //PW.34.SK.1.0 Start  Moved to W1 dependent app
                // field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     Enabled = false;
                //     HideValue = true;
                //     ToolTip = 'Specifies the VAT Prod. Posting Group';
                //     Visible = false;

                //     trigger OnValidate();
                //     begin
                //         NS_RedistributeTotalsOnAfterValidate;
                //     end;
                // }
                //PW.34.Sk.1.0 End
                //PRJ-492.N.S.1.0 Start
                // field(Description; Rec.Description)
                // {
                //     ApplicationArea = Suite;
                //     ToolTip = 'Specifies a description of the item or service on the line.';
                // }
                //PRJ-492.N.S.1.0 End
                field("PP Work Type Code"; Rec."NS_Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';
                    Visible = false;
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies if your vendor will ship the items on the line directly to your customer.';
                    Visible = false;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Return Reason Code';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    // Editable = false; //PRJ-1354.RM.1.0 commented start
                    // Enabled = false;  
                    //HideValue = true;  
                    ToolTip = 'Specifies the Location Code';
                    // Visible = false; //PRJ-1354.RM.1.0 commented end
                }
                field(Staged; Rec.NS_Staged)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Staged';
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Bin Code';
                    Visible = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ShowMandatory = TypeChosen;
                    ToolTip = 'Specifies the Quantity';

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }

                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Reserved Quantity';
                    Visible = false;
                }
                field("Job Remaining Qty."; Rec."Job Remaining Qty.")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Job Remaining Qty.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTip = 'Specifies the unit of measure code for the item.';

                    trigger OnValidate();
                    begin
                        //PP_SetSubcontractCalcFieldAccess;//PRJ-277.MS.1.0 code comment
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ShowMandatory = TypeChosen;
                    ToolTip = 'Specifies the direct cost of one item unit.';

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Indirect Cost %';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost (LCY)';//Doubt
                    Visible = false;//PRJ-492.RS.1.0 11May2021
                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the Unit Price (LCY)';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the Tax Liable';
                    Visible = false;
                }
                //PPDA.1.0.TBA Start
                // field("Provincial Tax Area Code"; Rec."Provincial Tax Area Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                //     Visible = false;
                // }
                //PPDA.1.0.TBA End
                //PRJ-492.N.S.1.0 START
                // field("Tax Group Code"; Rec."Tax Group Code")
                // {
                //     ApplicationArea = Suite;
                //     ShowMandatory = true;
                //     ToolTip = 'Specifies the Tax Group Code';
                //     //Visible = false;PRJ-383.N.S.1.0 16Sep2020 code comment


                //     trigger OnValidate();
                //     begin
                //         NS_RedistributeTotalsOnAfterValidate;
                //     end;
                // }
                //PRJ-492.N.S.1.0 END
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax';
                    Visible = false;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the Tax Area Code';
                    Visible = true;//PRJ-492.RS.1.0 11May2021

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                //PRJ-492.N.S.1.0 START
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = Suite;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Tax Group Code';
                    //Visible = false;PRJ-383.N.S.1.0 16Sep2020 code comment


                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                //PRJ-492.N.S.1.0 END
                field("PP Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Amount Including VAT';//PRJ-492.RS.1.0 11May2021 Copy & Past  from another place
                }

                field("PP Retention Applies"; Rec."NS_Retention Applies")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether Retention Applies';

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the line discount percentage.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the discount amount that is granted on the line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Prepayment %';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Line Amount"; Rec."Prepmt. Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Prepmt. Line Amount';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Amt. Inv."; Rec."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Prepmt. Amt. Inv.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Allow Invoice Disc.';
                    Visible = false;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the invoice discount amount for the line.';
                    Visible = false;
                }
                field("Subcontract Payment Percent"; Rec."NS_Subcontract Payment Percent")
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    //Editable = PP_SubcontractPaymentFieldsEditable; //PRJ-111.SK.1.0 Blocked
                    ToolTip = 'Specifies the Subcontract Payment Percent';

                    trigger OnValidate();
                    begin

                        //if ("Unit of Measure Code" = PP_JobSetup."PP_Subcontract Default UOM") and PP_SubcontractType(Type.AsInteger()) then begin //PRJ-277.MS.1.0 comment
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
                        NS_SetRetentionBase();
                        //end; //PRJ-277.MS.1.0 comment


                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Subcontract Payment Value"; Rec."NS_Subcontract Payment Value")
                {
                    ApplicationArea = All;
                    // BlankZero = true;
                    Editable = PP_SubcontractPaymentFieldsEditable;
                    ToolTip = 'Specifies the Subcontract Payment Value';

                    trigger OnValidate();
                    begin

                        //if ("Unit of Measure Code" = PP_JobSetup."PP_Subcontract Default UOM") and PP_SubcontractType(Type.AsInteger()) then begin   //PRJ-277.MS.1.0 comment
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
                        NS_SetRetentionBase();
                        //end; //PRJ-277.MS.1.0 comment
                        NS_RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    Editable = NS_QtyEnabled; //PRJ-889.GK.1.0 13Sep2021

                    trigger OnValidate();
                    begin
                        //if ("Unit of Measure Code" = PP_JobSetup."PP_Subcontract Default UOM") and PP_SubcontractType(Type.AsInteger()) then begin//PRJ-277.MS.1.0 comment
                        "NS_Subcontract Payment Value" := ("Quantity Received" + "Qty. to Receive") * "Direct Unit Cost";
                        if "Quantity (Base)" * "Direct Unit Cost" <> 0 then
                            "NS_Subcontract Payment Percent" := ((("Qty. to Receive" + "Quantity Received") * "Direct Unit Cost") / "Line Amount") * 100
                        else
                            ERROR(Text14021100);
                        VALIDATE("Amount Including VAT");
                        NS_SetRetentionBase(); //PRJ-277.MS.1.0  
                        //PP_CalcRetentionBaseAmounts(Rec); //PRJ-277.MS.1.0 code comment
                        CurrPage.UPDATE;
                    end;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have already been invoiced.';
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    // Visible = false; //PRJ-383.N.S.1.0 16Sep2020 code comment
                    Editable = NS_QtyEnabled;  //PRJ-889.GK.1.0 13Sep2021
                    trigger OnValidate();
                    begin
                        if ("Unit of Measure Code" = PP_JobSetup."NS_Subcontract Default UOM") and NS_SubcontractType(Type.AsInteger()) then
                            ERROR(Text14021103);
                    end;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have already been invoiced.';
                    // Visible = false;//PRJ-383.N.S.1.0 16Sep2020 code comment
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Planned Receipt Date';
                    //Visible = false; //PRJ-492.AS.1.0 //DOUBT//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Expected Receipt Date';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the item is ordered. It is calculated backwards from the Planned Receipt Date field in combination with the Lead Time Calculation field.';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                //PPDA.1.0.TBA Start
                // field("IRS 1099 Liable"; Rec."IRS 1099 Liable")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the IRS 1099 Liable';
                //     Visible = false;
                // }
                //PPDA.1.0.TBA End
                field("Prepmt Amt to Deduct"; Rec."Prepmt Amt to Deduct")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Prepmt Amt to Deduct';
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; Rec."Prepmt Amt Deducted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Prepmt Amt Deducted';
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Allow Item Charge Assignment';
                    Visible = false;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Qty. to Assign';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        NS_UpdateForm(false);
                    end;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Qty. Assigned';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        NS_UpdateForm(false);
                    end;
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Planning Line No.';
                    Visible = false;
                }
                field("Job Line Type"; Rec."Job Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Type';
                    Visible = false;
                }
                field("Job Unit Price"; Rec."Job Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Unit Price';
                    Visible = false;
                }
                field("Job Line Amount"; Rec."Job Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Amount';
                    Visible = false;
                }
                field("Job Line Discount Amount"; Rec."Job Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Discount Amount';
                    Visible = false;
                }
                field("Job Line Discount %"; Rec."Job Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Discount %';
                    Visible = false;
                }
                field("Job Total Price"; Rec."Job Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Total Price';
                    Visible = false;
                }
                field("Job Unit Price (LCY)"; Rec."Job Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Unit Price (LCY)';
                    Visible = false;
                }
                field("Job Total Price (LCY)"; Rec."Job Total Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Total Price (LCY)';
                    Visible = false;
                }
                field("Job Line Amount (LCY)"; Rec."Job Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Amount (LCY)';
                    Visible = false;
                }
                field("Job Line Disc. Amount (LCY)"; Rec."Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Line Disc. Amount (LCY)';
                    Visible = false;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';
                    Visible = false;
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Promised Receipt Date';
                    Visible = false;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Lead Time Calculation';
                    Visible = false;
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Planning Flexibility';
                    Visible = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Prod. Order No.';
                    Visible = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Prod. Order Line No.';
                    Visible = false;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Operation No.';
                    Visible = false;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Work Center No.';
                    Visible = false;
                }
                field(Finished; Rec.Finished)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Finished';
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; Rec."Whse. Outstanding Qty. (Base)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Whse. Outstanding Qty. (Base)';
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Inbound Whse. Handling Time';
                    Visible = false;
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Blanket Order No.';
                    Visible = false;
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the Blanket Order Line No.';
                    Visible = false;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ToolTip = 'Specifies the item ledger entry number the line should be applied to.';
                    Visible = false;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    TableRelation = "Deferral Template"."Deferral Code";
                    ToolTip = 'Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        NS_ValidateSaveShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Document No.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;
                }
                field("JMP Document No."; Rec."NS_JMP Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the JMP Document No.';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }

                //PRJ-817.JS.1.0-11Aug2021-Start
                field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Work Unit of Measure field';
                    ApplicationArea = All;
                }
                field("NS_Work Units"; Rec."NS_Work Units")
                {
                    ToolTip = 'Specifies the value of the Work Units field';
                    ApplicationArea = All;
                }
                field("NS_Work Unit Completed"; Rec."NS_Work Unit Completed")
                {
                    ToolTip = 'Specifies the value of the Work Unit Completed field';
                    ApplicationArea = All;
                }
                //PRJ-817.JS.1.0-11Aug2021-End

            }
            group(Control43)
            {
                Caption = ''; //PRJ-108.SK.1.0 Added
                group(Control37)
                {
                    Caption = ''; //PRJ-108.SK.1.0 Added
                    field("Invoice Discount Amount"; TotalPurchaseLine."Inv. Discount Amount")
                    {
                        ApplicationArea = Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        Caption = 'Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies the amount that is calculated and shown in the Invoice Discount Amount field. The invoice discount amount is deducted from the value shown in the Total Amount Incl. Tax field.';

                        trigger OnValidate();
                        var
                            PurchaseHeader: Record "Purchase Header";
                        begin
                            PurchaseHeader.GET("Document Type", "Document No.");
                            PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalPurchaseLine."Inv. Discount Amount", PurchaseHeader);
                            CurrPage.UPDATE(false);
                        end;
                    }
                    field("Invoice Disc. Pct."; PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec))
                    {
                        ApplicationArea = Suite;
                        Caption = 'Invoice Discount %';
                        DecimalPlaces = 0 : 2;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met. The calculated discount amount is inserted in the Invoice Discount Amount field, but you can change it manually.';
                    }
                }
                group(Control19)
                {
                    Caption = ''; //PRJ-108.SK.1.0 Added
                    field("Total Amount Excl. VAT"; TotalPurchaseLine.Amount)
                    {
                        ApplicationArea = Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Amount Excl. Tax';
                        DrillDown = false;
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                    }
                    field("Total VAT Amount"; VATAmount)
                    {
                        ApplicationArea = Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Tax';
                        Editable = false;
                        Style = Subordinate;
                        StyleExpr = RefreshMessageEnabled;
                        ToolTip = 'Specifies the sum of Tax amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
                    {
                        ApplicationArea = Suite;
                        AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(PurchHeader."Currency Code");
                        Caption = 'Total Amount Incl. Tax';
                        Editable = false;
                        StyleExpr = TotalAmountStyle;
                    }
                    //PPDA.1.0.TBA Start
                    // field(RefreshTotals; RefreshMessageText)
                    // {
                    //     ApplicationArea = Suite;
                    //     DrillDown = true;
                    //     Editable = false;
                    //     Enabled = RefreshMessageEnabled;
                    //     ShowCaption = false;

                    //     trigger OnDrillDown();
                    //     begin
                    //         DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
                    //         DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
                    //           TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);

                    //         RecalculateTaxes;
                    //     end;
                    // }
                    //PPDA.1.0.TBA End
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = All;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = All;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        ApplicationArea = All;
                        AccessByPermission = TableData Location = R;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = All;
                        Caption = 'BOM Level';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                action("Reservation Entries")
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData Item = R;
                    Caption = 'Reservation Entries';

                    ToolTip = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction();
                    begin
                        ShowReservationEntries(true);
                    end;
                }
                action("Item Tracking Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Item &Tracking Lines';

                    ToolTip = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction();
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';

                    ToolTip = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    ToolTip = 'Co&mments';

                    Image = ViewComments;

                    trigger OnAction();
                    begin
                        ShowLineComments;
                    end;
                }
                action(ItemChargeAssignment)
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData "Item Charge" = R;
                    Caption = 'Item Charge &Assignment';
                    Image = ItemCosts;

                    trigger OnAction();
                    begin
                        ShowItemChargeAssgnt;
                    end;
                }
                action(DeferralSchedule)
                {
                    ApplicationArea = Suite;
                    Caption = 'Deferral Schedule';
                    Enabled = "Deferral Code" <> '';
                    Image = PaymentPeriod;

                    trigger OnAction();
                    begin
                        PurchHeader.GET("Document Type", "Document No.");
                        ShowDeferrals(PurchHeader."Posting Date", PurchHeader."Currency Code")
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("E&xplode BOM")
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData "BOM Component" = R;
                    Caption = 'E&xplode BOM';
                    Image = ExplodeBOM;

                    trigger OnAction();
                    begin
                        NS_ExplodeBOM;
                    end;
                }
                action("Insert Ext. Texts")
                {
                    AccessByPermission = TableData "Extended Text Header" = R;
                    ApplicationArea = Suite;
                    Caption = 'Insert &Ext. Text';
                    Image = Text;
                    ToolTip = 'Insert the extended item description that is set up for the item on the purchase document line.';

                    trigger OnAction();
                    begin
                        NS_InsertExtendedText(true);
                    end;
                }
                action(Reserve)
                {
                    ApplicationArea = All;
                    Caption = '&Reserve';
                    Ellipsis = true;
                    Image = Reserve;

                    trigger OnAction();
                    begin
                        FIND;
                        ShowReservation;
                    end;
                }
                action(OrderTracking)
                {
                    ApplicationArea = All;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;

                    trigger OnAction();
                    begin
                        NS_ShowTracking;
                    end;
                }
                action("NS Get Job Planning Line")
                {
                    ApplicationArea = All;
                    Caption = 'Get Job &Planning Line';

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_GetJobBudget('');
                        //ProjectPro - end
                    end;
                }
            }
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                group("Dr&op Shipment")
                {
                    Caption = 'Dr&op Shipment';
                    Image = Delivery;
                    action("Sales &Order")
                    {
                        AccessByPermission = TableData "Sales Shipment Header" = R;
                        ApplicationArea = Suite;
                        Caption = 'Sales &Order';
                        Image = Document;

                        trigger OnAction();
                        begin
                            NS_OpenSalesOrderForm;
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    Caption = 'Speci&al Order';
                    Image = SpecialOrder;
                    action(Action1901038504)
                    {
                        AccessByPermission = TableData "Sales Shipment Header" = R;
                        Caption = 'Sales &Order';
                        Image = Document;
                        ApplicationArea = All;

                        trigger OnAction();
                        begin
                            NS_OpenSpecOrderSalesOrderForm;
                        end;
                    }
                }
                action(BlanketOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Blanket Order';
                    Image = BlanketOrder;
                    ToolTip = 'View the blanket purchase order.';

                    trigger OnAction();
                    var
                        PurchaseHeader: Record "Purchase Header";
                        BlanketPurchaseOrder: Page "Blanket Purchase Order";
                    begin
                        TESTFIELD("Blanket Order No.");
                        PurchaseHeader.SETRANGE("No.", "Blanket Order No.");
                        if not PurchaseHeader.ISEMPTY then begin
                            BlanketPurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                            BlanketPurchaseOrder.EDITABLE := false;
                            BlanketPurchaseOrder.RUN;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        NS_UpdateEditableOnRow;
        if PurchHeader.GET("Document Type", "Document No.") then;

        DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
          TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);

        //PP_SetSubcontractCalcFieldAccess;//PRJ-277.MS.1.0 code comment
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        TypeChosen := HasTypeToFillMandatoryFields;
        CLEAR(DocumentTotals);
        PP_OrigLinePercent := 0;
        PP_OrigLineAmount := 0;
        PP_OrigLineQtyToReceive := 0;
        PP_OrigLineQtyToInv := 0;

        if NS_SubcontractType(Type.AsInteger()) and ("Unit of Measure" = PP_UOMSubcontractDesc) then begin	 //PRJ-277.MS.1.0 code comment
            PP_OrigLinePercent := "NS_Subcontract Payment Percent";
            PP_OrigLineAmount := "NS_Subcontract Payment Value";
            PP_OrigLineQtyToReceive := "Qty. to Receive";
            PP_OrigLineQtyToInv := "Qty. to Invoice";
            //PRJ-277.MS.1.0 code comment
            // if "Qty. to Receive" = 1 - "Quantity Received" then begin
            //     "Qty. to Receive" := 0;
            //     "Qty. to Invoice" := 0;
            // end;
            //end;  
            //PP_SetSubcontractCalcFieldAccess; 
            //PRJ-277.MS.1.0 code comment
        end;
        //PRJ-889.GK.1.0 13Sep2021 start

        NS_PurchHeader.Reset();
        NS_PurchHeader.SetRange("No.", Rec."Document No.");
        if NS_PurchHeader.FindFirst() then begin
            if NS_PurchHeader."NS_Progress Payment Enable" = NS_PurchHeader."NS_Progress Payment Enable"::No then
                NS_QtyEnabled := true
            else
                NS_QtyEnabled := false;
        end;
        //PRJ-889.GK.1.0 13Sep2021 end



    end;
    //PRJ-277.MS.1.0

    trigger OnDeleteRecord(): Boolean;
    var
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
        if (Quantity <> 0) and ItemExists("No.") then begin
            COMMIT();
            if not ReservePurchLine.DeleteLineConfirm(Rec) then
                exit(false);
            ReservePurchLine.DeleteLine(Rec);
        end;
    end;

    trigger OnInit();
    begin
        PP_GLSetup.GET;
        PP_PurchSetup.GET;
        PP_JobSetup.GET;
        PP_UOMSubcontractDesc := '';
        if PP_JobSetup."NS_Subcontract Default UOM" > '' then begin
            if PP_UnitOfMeasure.GET(PP_JobSetup."NS_Subcontract Default UOM") then
                PP_UOMSubcontractDesc := PP_UnitOfMeasure.Description;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        //if ApplicationAreaSetup.IsFoundationEnabled then   //PE-267.JS.1.0 05MAR2024 line commented
        if NSApplicationAreaMgmtFacade.IsFoundationEnabled() then  //PE-267.JS.1.0 05MAR2024 line added
            Rec.Type := Rec.Type::Item; //PRJ-1131.NK.1.0 11Jan2022
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //if ApplicationAreaSetup.IsFoundationEnabled then   //PE-267.JS.1.0 05MAR2024 line commented
        if NSApplicationAreaMgmtFacade.IsFoundationEnabled() then  //PE-267.JS.1.0 05MAR2024 line added
            Rec.Type := Rec.Type::Item //PRJ-1131.NK.1.0 11Jan2022
        else
            InitType;
        CLEAR(ShortcutDimCode);
        "NS_Retention Applies" := true;
        if Type <> Type::" " then
            if PurchHeader.GET("Document Type", "Document No.") then
                if PurchHeader."NS_Job No." <> '' then
                    VALIDATE("Job No.", PurchHeader."NS_Job No.");
        NS_SetSubcontractCalcFieldAccess;
    end;

    var
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        //ApplicationAreaSetup: Record "Application Area Setup";  //PE-267.JS.1.0 05MAR2024
        NSApplicationAreaMgmtFacade: codeunit "Application Area Mgmt. Facade"; //PE-267.JS.1.0 05MAR2024 
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array[8] of Code[20];
        VATAmount: Decimal;
        InvDiscAmountEditable: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TypeChosen: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        PP_GetJobPlanningLine: Page "NS_Get Job Planning Line";
        PP_Job: Record Job;
        PP_Resource: Record Resource;
        PP_GLSetup: Record "General Ledger Setup";
        PP_PurchSetup: Record "Purchases & Payables Setup";
        Text14021100: Label 'There must be a value for Quantity and Direct Unit Cost.';
        PP_UnitOfMeasure: Record "Unit of Measure";
        PP_JobSetup: Record "Jobs Setup";
        PP_OrigLinePercent: Decimal;
        PP_OrigLineAmount: Decimal;
        PP_OrigLineQtyToReceive: Decimal;
        PP_OrigLineQtyToInv: Decimal;
        PP_UOMSubcontractDesc: Text[10];
        JobNo: Code[20];
        Text14021101: Label 'There must be a value for Direct Unit Cost.';
        Text14021102: Label 'There must be a value for Quantity.';
        Text14021103: Label 'Direct entry of Qty. to Invoice on subcontract lines is not allowed.  Enter the value into Qty. to Receive.';
        Text14021104: Label 'There has already been %1  received, and this is coming to %2.';
        PP_SubcontractPaymentFieldsEditable: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;

        //PRJ-889.GK.1.0 13Sep2021 start

        NS_QtyEnabled: Boolean;
        NS_PurchHeader: Record "Purchase Header";

    //PRJ-889.GK.1.0 13Sep2021 end

    procedure NS_ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;

    local procedure NS_ExplodeBOM();
    begin
        if "Prepmt. Amt. Inv." <> 0 then
            ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
    end;

    local procedure NS_OpenSalesOrderForm();
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        TESTFIELD("Sales Order No.");
        SalesHeader.SETRANGE("No.", "Sales Order No.");
        SalesOrder.SETTABLEVIEW(SalesHeader);
        SalesOrder.EDITABLE := false;
        SalesOrder.RUN;
    end;

    local procedure NS_InsertExtendedText(Unconditionally: Boolean);
    begin
        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate then
            NS_UpdateForm(true);
    end;

    procedure NS_ShowTracking();
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetPurchLine(Rec);
        TrackingForm.RUNMODAL;
    end;

    local procedure NS_OpenSpecOrderSalesOrderForm();
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        TESTFIELD("Special Order Sales No.");
        SalesHeader.SETRANGE("No.", "Special Order Sales No.");
        SalesOrder.SETTABLEVIEW(SalesHeader);
        SalesOrder.EDITABLE := false;
        SalesOrder.RUN;
    end;

    procedure NS_UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    local procedure NS_NoOnAfterValidate();
    begin
        //PRJ-1563.JS.1.0 - Start
        //NS_UpdateEditableOnRow;        
        if Rec."Line No." <> 0 then
            NS_UpdateEditableOnRow;
        //PRJ-1563.JS.1.0 - end         
        NS_InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and //PRJ-1131.NK.1.0 11Jan2022
           (xRec."No." <> '')
        then
            CurrPage.SAVERECORD;
    end;

    local procedure NS_CrossReferenceNoOnAfterValidat();
    begin
        NS_InsertExtendedText(false);
    end;

    internal procedure NS_RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        PurchHeader.GET("Document Type", "Document No.");
        if DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) then begin
            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
            OnAfterRedistributeTotalsOnAfterValidate(Rec); //PPDA.1.0 Added
            // RecalculateTaxes;//PPDA.1.0 Commented
        end;
        CurrPage.UPDATE;
    end;

    local procedure NS_ValidateSaveShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    local procedure NS_UpdateEditableOnRow();
    begin
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
    end;

    procedure NS_RecalculateTaxes();
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.GET("Document Type", "Document No.");
        PurchaseLine.RESET;
        OnBeforeCalcSalesTaxLines(Rec, PurchaseHeader, PurchaseLine); //PPDA.1.0 Added
        // CalcSalesTaxLines(PurchaseHeader, PurchaseLine);//PPDA.1.0 Commented
        UpdateAmounts;
        FIND;
    end;

    procedure NS_GetJobBudget(VendNo: Code[20]);
    var
        PP_JobPlanningLine: Record "Job Planning Line";
        PP_Job: Record Job;
        PP_PurchHeader: Record "Purchase Header";
        PP_PurchLine: Record "Purchase Line";
        PP_JobNo: Code[20];
        PP_JobTaskNo: Code[35];
        PP_LineNo: Integer;
    begin
        if PP_Job.GET(JobNo) then
            "Job No." := JobNo
        else
            TESTFIELD("Job No.");
        PP_JobPlanningLine."Job No." := "Job No.";
        PP_JobPlanningLine."NS_Entry Type" := PP_JobPlanningLine."NS_Entry Type"::Cost;
        PP_GetJobPlanningLine.NS_Set(VendNo,
                                  PP_JobPlanningLine."Job No.",
                                  PP_JobPlanningLine."NS_Cost Category",
                                  PP_JobPlanningLine."NS_Revenue Category",
                                  PP_JobPlanningLine."Job Task No.",
                                  PP_JobPlanningLine."NS_Entry Type");

        if PP_GetJobPlanningLine.RUNMODAL = ACTION::LookupOK then begin
            PP_GetJobPlanningLine.NS_Get(PP_JobNo, PP_JobTaskNo, PP_LineNo);
            PP_JobPlanningLine.GET(PP_JobNo, PP_JobTaskNo, PP_LineNo);
            PP_PurchHeader.GET("Document Type", "Document No.");
            PP_LineNo := 0;
            PP_PurchLine.RESET;
            PP_PurchLine.SETRANGE("Document Type", PP_PurchHeader."Document Type");
            PP_PurchLine.SETRANGE("Document No.", PP_PurchHeader."No.");
            if PP_PurchLine.FINDLAST then
                PP_LineNo := PP_PurchLine."Line No.";
            PP_LineNo := PP_LineNo + 10000;

            with PP_PurchLine do begin
                INIT;
                "Document Type" := PP_PurchHeader."Document Type";
                "Document No." := PP_PurchHeader."No.";
                "Line No." := PP_LineNo;
                case PP_JobPlanningLine.Type of
                    PP_JobPlanningLine.Type::Resource:
                        Type := Type::Resource;
                    PP_JobPlanningLine.Type::Item:
                        Type := Type::Item;
                    PP_JobPlanningLine.Type::"G/L Account":
                        Type := Type::"G/L Account";
                end;
                VALIDATE(Type);
                VALIDATE("No.", PP_JobPlanningLine."No.");
                "Variant Code" := PP_JobPlanningLine."Variant Code";
                Description := PP_JobPlanningLine.Description;
                "Gen. Bus. Posting Group" := PP_JobPlanningLine."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := PP_JobPlanningLine."Gen. Prod. Posting Group";
                VALIDATE("Location Code", PP_JobPlanningLine."Location Code");
                "Bin Code" := PP_JobPlanningLine."Bin Code";
                "Unit of Measure Code" := PP_JobPlanningLine."Unit of Measure Code";
                "Unit Cost" := PP_JobPlanningLine."Unit Cost";
                "Unit Cost (LCY)" := PP_JobPlanningLine."Unit Cost (LCY)";
                "Direct Unit Cost" := PP_JobPlanningLine."Unit Cost";
                VALIDATE(Quantity, PP_JobPlanningLine.Quantity);
                "Job No." := PP_JobPlanningLine."Job No.";
                "Job Task No." := PP_JobPlanningLine."Job Task No.";
                "NS_Job Cost Category" := PP_JobPlanningLine."NS_Cost Category";
                "NS_Job Revenue Category" := PP_JobPlanningLine."NS_Revenue Category";
                "Shortcut Dimension 1 Code" := PP_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PP_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                "Dimension Set ID" := PP_JobPlanningLine."NS_Dimension Set ID";
                INSERT;
            end;
        end;

        CLEAR(PP_GetJobPlanningLine);
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

    local procedure NS_SetSubcontractCalcFieldAccess();
    begin
        if "Unit of Measure Code" = PP_JobSetup."NS_Subcontract Default UOM" then
            PP_SubcontractPaymentFieldsEditable := true
        else begin
            PP_SubcontractPaymentFieldsEditable := false;
            "NS_Subcontract Payment Percent" := 0;
            "NS_Subcontract Payment Value" := 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRedistributeTotalsOnAfterValidate(Var Rec: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcSalesTaxLines(Var Rec: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;
}

