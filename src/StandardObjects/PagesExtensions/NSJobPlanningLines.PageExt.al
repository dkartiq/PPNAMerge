pageextension 14021278 NS_JobPlanningLines extends "Job Planning Lines"
{
    //  "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // 001 23.10.2021  PREM  bugfix
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +     "PP Line Job Description"
    // +     "PP Subcontract No."
    // +     "PP Cost Category"
    // +     "PP Revenue Category"
    // +     "PP Adjustment"
    // +     "PP Shortcut Dimension 1 Code"
    // +     "PP Shortcut Dimension 2 Code"
    // +     "PP Skill Class"
    // +     "PP Work Units"
    // +     "PP Work Unit of Measure"
    // +     "PP Progress Billing Method"
    // +     "PP Rate Type"
    // +     "PP Rate Type Value"
    // +     "PP Not To Exceed"
    // +     "Retention Ledger Code"
    // +     "Segment Code"
    // +     "Segment Name"
    // +     "Matrix Updated"
    // +
    // +  - Added function(s):
    // +     - SetFilters() - this is a feature to allow program to be called with a Line Type filter
    // +     - NS_CreatePurchaseOrderDetail() to allow for multi-line get from Purchase Order from Job Planning Lines
    // +
    // +  - Added global variable(s):
    // +     NS_BelowCost
    // +     NS_Job
    // +     NS_ShowJobNo
    // +     NS_JobDescription
    // +     NS_ShowLineType
    // +     NS_ShowAdjustmentLines
    // +     NS_SkillClassEditable
    // +     NS_BelowCost
    // +     ItemNotFound
    // +     JobNo2
    // +     TaskNo
    // +     BySegment
    // +     SegmentCode
    // +     SegCode
    // +     CalledFromGetBudgLines
    // +     SubcontractNo
    // +     SegmentName
    // +     JobTakeoffSegments
    // +     PurchaseOrderNo
    // +
    // +  - Added Text Constant(s):
    // +     Text14021400
    // +     Text14021401
    // +     Text14021402
    // +
    // +  - Modification(s):
    // +     - Set SourceTableView: to SORTING(Job No.,Entry Type,Job Task No.,Cost Category,Revenue Category,Type,No.,Variant Code)
    // +                            ORDER(Ascending)
    // +     - Set SaveValues and DelayedInsert properties to Yes
    // +     - Set columns as visible: Gen. Bus. Posting Group, Gen. Prod. Posting Group
    // +     - Set column as not visible: Total Price
    // +     - Set columns as editable: Quantity, Quantity (Base)
    // +     - OnInit() and SetEditable: set NS_SkillClassEditable variable
    // +     - Modified page properties to sort by Job No., Job Task No., Line No.
    // +     - Modified CreateSubcontractDetail() to use all fields in key of 'Subcontract Lines' table
    // +     - Modified CreateSubcontractDetail() to be cleaner code
    // +     - Modified CreateSubcontractDetail to set Job Planning Line No. prior to calling INSERT.
    // +     - Correct the assignment of Type field when creating new Subcontract Detail Lines
    // +     - Modified NS_CreatePurchaseOrderDetail to set the Job Plannine Line No.
    // +     - Added Job Cost Budget and Job Actual to Budget (Price) to the Report menu
    // +     - Renamed function Get Sales/Credit Memo as Show Sales Document
    // +     - Added Copy Job Planning to Original ribbon choice
    // +     - Added copy of 'Unit of Measure' to line during CreateSubContractDetail
    // +     - Added Subcontract Dimensions when detail lines are being created.
    // +     - Modified Lock Planning Lines to Original Action to account for renamed function in Job Table.
    // +     - Added transfer of Job Task Description to Subcontract card.
    // +     - Added Action Items GetJobSegements, GetJobTaskSegments
    // +------------------------------------------------------------
    //PRJ-170.MS.1.0 - Added code for highlighted red color on the basis of job setup
    //JD-10.MS.1.0  added new field and action
    //PRJ-271/PRJ-272 VT1.0 21-05-20
    //PRJ-278.AS.1.0 26MAY2020 Cleared the caption.	//PPAL-34.AS.1.0 27JUNE2020
    //PRJ-301.AS.1.0 Increase length from 50 to 100
    //JD-49.MS.1.0 editable 2 fields
    //PPAL-54.MS.1.0 resolve the issue of selecting job plng line
    //JD-54.AM.1.0 Added 1 field.
    //JD-54.AM.1.0 Added code on  page triggers.	
    //PRJ-389.MS.1.0  added new code for PO get Job Plng line
    //PPAL-171.AM.1.0 | Added Code to flow segment code.
    //JD-48.AS.1.0 31OCT2020 Added code to not modify segment code
    //PRJ-492.RS.1.0 10May2021 | Hide/Unhide Fields 
    //PRJ-659.RS.1.0�22June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    //PRJ-768.JS.1.0 26July2021 | Add tooltip in fields available on page
    //PRJ-866.JS.1.0  17Aug2021 | Code commented
    //PRJ-866.JS.1.0  19Aug2021 | Assign Job Planning Line No.
    //PRJ-895.GK.1.0 27Aug2021 | Added fields Use Tax Sku & Use Tax Amount
    //PRJ-936.JS.1.0 23Sep2021 | Restructure the code as per change required
    //PRJ-913.JS.1.0 15Set2021 | Add code for flow dimension value from job tasks lines
    //PRJ-929.GK.1.0 22Sep2021 | Added three fields.
    //PRJ-906.GK.1.0 04Oct2021 | Added Code
    //PRJ-659.RM.1.0 06-Oct-2021 | Remove NS_ from fields' caption
    //PRJ-973.GK.1.0 13Oct2021 | Add one field.

    layout
    {
        modify(Type)
        {
            Style = Unfavorable;
            StyleExpr = ItemNotFound;
        }
        modify("No.")
        {
            Style = Unfavorable;
            StyleExpr = ItemNotFound;
        }
        modify(Quantity)
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
            //PRJ-588.AS.1.0 16MARCH2021 - START
            trigger OnBeforeValidate()
            begin
                if (rec."Line Type" <> Rec."Line Type"::Budget) and (Rec."NS_Progress Billing Method" = Rec."NS_Progress Billing Method"::"%") then begin
                    if (Rec.Quantity > 1) then
                        Error('Qty cannot be greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                    if (Rec.Quantity < 0) then
                        Error('Qty cannot be  greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                end;
            end;
            //PRJ-588.AS.1.0 16MARCH2021 - END
            //PRJ-936.JS.1.0 23Sep2021-Start
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
            //PRJ-936.JS.1.0 23Sep2021-End
        }
        modify("Unit Cost")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Unit Cost (LCY)")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
            //PRJ-936.JS.1.0 23Sep2021-Start
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
            //PRJ-936.JS.1.0 23Sep2021-end
        }
        modify("Total Cost")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Total Cost (LCY)")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Unit Price")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
            //PRJ-936.JS.1.0 23Sep2021-Start
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
            //PRJ-936.JS.1.0 23Sep2021-end
        }
        modify("Unit Price (LCY)")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
            //PRJ-936.JS.1.0 23Sep2021-Start
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
            //PRJ-936.JS.1.0 23Sep2021-end         
        }
        modify("Line Amount")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Line Amount (LCY)")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Total Price")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        modify("Total Price (LCY)")
        {
            Style = Attention;
            StyleExpr = NS_BelowCost;
        }
        addfirst(Content)
        {
            group(NS_Control1100773025)
            {
                Caption = '';//PRJ-278.AS.1.0 26MAY2020	 //PPAL-34.AS.1.0 27JUNE2020
                Visible = BySegment;
                field(NS_SegmentCode; SegmentCode)
                {
                    ApplicationArea = All;
                    Caption = 'Segment Code';
                    TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
                    Visible = BySegment;

                    trigger OnValidate();
                    var
                        lPlanningLines: Record "Job Planning Line";
                    begin
                        lPlanningLines.SETRANGE("Job No.", "Job No.");
                        lPlanningLines.SETRANGE("NS_Segment Code", '');
                        if TaskNo <> '' then
                            lPlanningLines.SETRANGE("Job Task No.", TaskNo);
                        if lPlanningLines.FINDSET(true, false) then begin
                            if CONFIRM(Text14021400, false, SegmentCode) then begin
                                repeat
                                    lPlanningLines.VALIDATE("NS_Segment Code", SegmentCode);
                                    lPlanningLines.MODIFY;
                                until lPlanningLines.NEXT = 0;
                            end else begin
                                SETRANGE("NS_Segment Code", SegmentCode);
                            end;
                        end else begin
                            SETRANGE("NS_Segment Code", SegmentCode);
                        end;
                        if SegmentCode <> '' then
                            SegCode := SegmentCode;
                        //ProjectPro - start
                        SegmentName := '';
                        if SegmentCode <> '' then begin
                            JobTakeoffSegments.RESET;
                            JobTakeoffSegments.SETRANGE("NS_Job No.", JobNo2);
                            JobTakeoffSegments.SETRANGE("NS_Segment Code", SegmentCode);
                            if JobTakeoffSegments.FINDFIRST then
                                SegmentName := JobTakeoffSegments."NS_Segment Name";
                        end;
                        //ProjectPro - end
                        CurrPage.UPDATE;
                    end;
                }
                field("NS_Segment Desc."; SegmentName)
                {
                    Caption = 'Segment Description'; //PRJ-659.RM.1.0 06-Oct-2021 
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the segment name.';
                }
            }
        }

        //PRJ-563.AS.1.0 19MARCH2021 - START
        addafter(Description)
        {
            field("NS_Assembley BOM"; Rec."NS_Assembley BOM")
            {
                ApplicationArea = All;
                Caption = 'Assembly BOM';
                Editable = false;
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies that the Item Item is having an Assembley BOM attached or not';   //PRJ-768.JS.1.0 23July2021

                trigger OnDrillDown()
                var
                    AssemBOMRec: Record "NS_Assembley BOM Components";
                begin
                    AssemBOMRec.Reset();
                    AssemBOMRec.SetRange("NS_Job No.", rec."Job No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."No.");
                    AssemBOMRec.SetRange("NS_Job Task No.", rec."Job Task No.");
                    AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                    if AssemBOMRec.FindSet() then
                        page.Run(Page::"NS_Assembley BOM Components", AssemBOMRec);
                end;
            }
        }
        //PRJ-563.AS.1.0 19MARCH2021 - END
        addfirst(Control1)
        {
            field("NS_Line Job Description"; NS_LineJobDescription)
            {
                ApplicationArea = All;
                Caption = 'Line Job Description';
                Editable = false;
                Style = Unfavorable;
                StyleExpr = ItemNotFound;
            }
        }

        //PRJ-568.AS.1.0 - START
        addafter("No.")
        {
            field("NS_Get Linked Resource"; Rec."NS_Get Linked Resource")
            {
                ApplicationArea = All;
                Caption = 'Get Linked Resource';
                Editable = GetLinkEditable;
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies the  Get Linked Resource for the Job';  //PRJ-768.JS.1.0 26July2021
                trigger OnValidate()
                var
                    JPLRec: Record "Job Planning Line";
                    JPLRec2: Record "Job Planning Line";
                    jobTblRec: Record Job;
                    Res: Record Resource;
                    Res2: Record Resource;
                    JobTaskRec: Record "Job Task";//PRJ-568.AS.1.0 18MAR2021
                begin
                    if (Rec.Type = Rec.Type::Item) and (Rec."NS_Get Linked Resource" = true) and (Rec."NS_Linked Resource" <> '') then begin
                        JPLRec.reset;
                        JPLRec.SetRange("Job No.", Rec."Job No.");
                        JPLRec.SetRange("Job Task No.", Rec."Job Task No.");
                        JPLRec.SetRange("NS_Resource Line No.", Rec."Line No.");
                        if JPLRec.FindFirst() then
                            Error('Already a Resource entry exists for this line, cannot insert again');

                        JPLRec.Reset();
                        JPLRec.SetRange("Job No.", Rec."Job No.");
                        //JPLRec.SetRange("Line No.", Rec."Line No.");
                        if JPLRec.FindLast() then begin
                            JPLRec2.INIT;
                            JPLRec2."Line No." := JPLRec."Line No." + 10000;
                            JPLRec2."NS_Resource Line No." := Rec."Line No.";
                            JPLRec2."NS_Entry Type" := Rec."NS_Entry Type";
                            JPLRec2."Line Type" := Rec."Line Type";
                            JPLRec2."Document No." := Rec."Document No.";
                            JPLRec2."Document Date" := Rec."Document Date";
                            JPLRec2."Planning Date" := Rec."Planning Date";
                            JPLRec2."NS_Shortcut Dimension 1 Code" := Rec."NS_Shortcut Dimension 1 Code";
                            JPLRec2."NS_Shortcut Dimension 2 Code" := Rec."NS_Shortcut Dimension 2 Code";
                            // JPLRec2."DFR Created" := Rec."DFR Created";
                            // JPLRec2."DFR Locked" := Rec."DFR Locked";
                            // JPLRec2."DFR No." := rec."DFR No.";
                            // JPLRec2."Vendor No." := Rec."Vendor No.";
                            // JPLRec2."Vendor Quote No." := Rec."Vendor Quote No.";
                            // JPLRec2."Quote No." := Rec."Quote No.";
                            // JPLRec2."Quote Line No." := Rec."Quote Line No.";
                            JPLRec2."Planned Delivery Date" := Rec."Planned Delivery Date";
                            // JPLRec2."Progress Billing Line" := Rec."Progress Billing Line";
                            JPLRec2."NS_Progress Billing Method" := Rec."NS_Progress Billing Method";
                            // JPLRec2."Purchase Order No." := Rec."Purchase Order No.";
                            JPLRec2.Type := JPLRec2.Type::Resource;
                            JPLRec2."No." := Rec."NS_Linked Resource";
                            IF Res.GET("NS_Linked Resource") Then begin
                                IF Res."NS_Job Revenue Category" <> '' THEN
                                    JPLRec2."NS_Revenue Category" := Res."NS_Job Revenue Category";
                                IF Res."NS_Job Cost Category" <> '' THEN
                                    JPLRec2."NS_Cost Category" := Res."NS_Job Cost Category";
                                JPLRec2.Description := Res.Name;
                                JPLRec2."Description 2" := Res."Name 2";
                                JPLRec2."Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                                JPLRec2."Resource Group No." := Res."Resource Group No.";
                                JPLRec2."Unit of Measure Code" := Res."Base Unit of Measure";
                                JPLRec2."Unit Cost" := Res."Unit Cost";
                                JPLRec2."Unit Price" := Res."Unit Price";
                            end;
                            JPLRec2.Validate(Quantity, Rec.Quantity * Rec."NS_Labor Hours per Qty.");
                            JPLRec2."Planning Date" := Rec."Planning Date";
                            JPLRec2."Planned Delivery Date" := Rec."Planned Delivery Date";
                            JPLRec2."NS_Parent Linked Item" := Rec."No.";
                            JPLRec2."NS_Labor Hours per Qty." := Rec."NS_Labor Hours per Qty.";
                            if Rec."Job No." <> '' then
                                JPLRec2."Job No." := Rec."Job No.";
                            //PRJ-568.AS.1.0 18MAR2021 - start
                            IF Res.GET("NS_Linked Resource") Then begin
                                if Res."NS_Default Job Task No" <> '' then begin
                                    if not JobTaskRec.Get(Rec."Job No.", Res."NS_Default Job Task No") then
                                        Error('You cannot insert Resouce Line having Job Task No. %1 not defined in Task lines of Job %2', Res."NS_Default Job Task No", Rec."Job No.");
                                    JPLRec2."Job Task No." := Res."NS_Default Job Task No";
                                end
                                else
                                    JPLRec2."Job Task No." := Rec."Job Task No.";
                            end;
                            //PRJ-568.AS.1.0 18MAR2021 - end
                            //if Rec."Job Task No." <> '' then //PRJ-568.AS.1.0 18MAR2021 Comment
                            //    JPLRec2."Job Task No." := Rec."Job Task No."; //PRJ-568.AS.1.0 18MAR2021 Comment
                            if jobTblRec.get(Rec."Job No.") then;
                            //JPLRec2."Gen. Bus. Posting Group" := jobTblRec."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
                            JPLRec2."Gen. Bus. Posting Group" := jobTblRec."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                            JPLRec2."Customer Price Group" := jobTblRec."Customer Price Group";
                            JPLRec2."NS_Segment Code" := Rec."NS_Segment Code";
                            JPLRec2."NS_Segment Name" := Rec."NS_Segment Name";
                            JPLRec2."NS_Segment Type" := Rec."NS_Segment Type";
                            JPLRec2."User ID" := Rec."User ID";
                            JPLRec2.INSERT;
                        end;
                    end;
                    currpage.update := true;
                end;
            }
        }
        addafter(Quantity)
        {
            field("NS_Linked Resource"; Rec."NS_Linked Resource")
            {
                ApplicationArea = All;
                Caption = 'Linked Resource';
                Editable = false;
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies the  Linked Resource for the Job';  //PRJ-768.JS.1.0 26July2021
            }
            field("NS_Parent Linked Item"; REC."NS_Parent Linked Item")
            {
                ApplicationArea = All;
                Caption = 'Parent Linked Item';
                Editable = false;
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies the  Parent Linked Item for the Job';  //PRJ-768.JS.1.0 26July2021
            }
            field("NS_Labor Hours per Qty."; REC."NS_Labor Hours per Qty.")
            {
                ApplicationArea = All;
                Caption = 'Labor Hours per Qty.';
                Editable = GetLinkEditable;
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies the  Labor Hours per Qty. for the Job';  //PRJ-768.JS.1.0 26July2021
            }
            field("NS_Resource Line No."; REC."NS_Resource Line No.")
            {
                ApplicationArea = All;
                Caption = 'Resource Line No.';
                Visible = false;//PRJ-492.RS.1.0 10May2021
                ToolTip = 'Specifies the  Resource Line No. for the Job';  //PRJ-768.JS.1.0 26July2021
            }
        }
        //PRJ-568.AS.1.0 - END

        addafter("Line No.")
        {
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                Caption = 'Subcontract No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Subcontract No. for the Job';  //PRJ-768.JS.1.0 26July2021
                Visible = false;
            }
            //PRJ-271/PRJ-272 VT1.0 21-05-20 begin
            field("NS Subcontract Line No."; Rec."NS_Subcontract Line No.")
            {
                Caption = 'Subcontract Line No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Subcontract Line No. for the Job';  //PRJ-768.JS.1.0 26July2021
                Visible = false;
            }
            //PRJ-271/PRJ-272 VT1.0 21-05-20 end
            field("NS_Adjustment"; Rec.NS_Adjustment)
            {
                Caption = 'Adjustment';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Adjustment Type for the Job';   //PRJ-768.JS.1.0 26July2021
                Visible = false;
            }
        }
        addafter("Variant Code")
        {
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                Caption = 'Retention Ledger Code';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Retention Ledger Code for the Job'; //PRJ-768.JS.1.0 26July2021
                Visible = false;//PRJ-492.RS.1.0 10May2021

            }
            field("NS_Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
            {
                Caption = 'Shortcut Dimension 1 Code';
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the  Shortcut Dimension 1 Code for the Job';  //PRJ-768.JS.1.0 23July2021
            }
            field("NS_Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
            {
                Caption = 'Shortcut Dimension 2 Code';
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the  Shortcut Dimension 2 Code for the Job';  //PRJ-768.JS.1.0 23July2021
            }
        }
        addafter("Location Code")
        {
            field("NS_Skill Class"; Rec."NS_Skill Class")
            {
                ApplicationArea = All;
                Caption = 'Skill Class';
                Editable = NS_SkillClassEditable;
                Visible = false; //PRJ-492.AS.1.0
                ToolTip = 'Specifies the  Skill Class for the Job';  //PRJ-768.JS.1.0 23July2021
            }
            field("NS_DFR Created"; "NS_DFR Created")
            {
                ApplicationArea = all;
                Caption = 'DFR Created';
                Description = 'JD-10.MS.1.0';
                Editable = true; //JD-49.MS.1.0
                Visible = false; //PRJ-492.AS.1.0
                ToolTip = 'Specifies the  DFR Created for the Job';  //PRJ-768.JS.1.0 23July2021

            }
            //JD-54.AM.1.0 Start
            field("NS_DFR Locked"; "NS_DFR Locked")
            {
                ApplicationArea = all;
                Caption = 'DFR Locked';
                Editable = false;
                Visible = false; //PRJ-492.AS.1.0
                ToolTip = 'Specifies the  DFR Locked for the Job';  //PRJ-768.JS.1.0 23July2021
            }
            //JD-54.AM.1.0 End
        }
        addafter("Unit Price (LCY)")
        {
            field("NS_Rate Type"; Rec."NS_Rate Type")
            {
                Caption = 'Rate Type';
                ApplicationArea = All;
                ToolTip = 'Specifies the Rate Type for the job';  //PRJ-768.JS.1.0 23July2021
                Visible = false;
            }
            field("NS_Rate Type Value"; Rec."NS_Rate Type Value")
            {
                Caption = 'Rate Type Value';
                ApplicationArea = All;
                ToolTip = 'Specifies the Rate Type Value for the job';  //PRJ-768.JS.1.0 23July2021
                Visible = false;
            }
        }
        addafter("Line Amount")
        {
            field("NS_Line Amount Incl. Tax"; Rec."NS_Line Amount Incl. Tax")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Line Amount Incl. Tax fot the Job';  //PRJ-768.JS.1.0 26July2021
                Visible = false;   //PRJ-492.RS.1.0 10May2021
            }
        }
        addafter("Line Amount (LCY)")
        {
            field("NS_Not To Exceed"; Rec."NS_Not To Exceed")
            {
                Caption = 'Not To Exceed';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Not To Exceed for the Job'; //PRJ-768.JS.1.0 26July2021
                Visible = false;
            }
        }
        addafter(Overdue)
        {
            field("NS_Segment Name"; Rec."NS_Segment Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Segment Name';
                Visible = false; //PRJ-492.AS.1.0
            }
            field("NS_Matrix Updated"; Rec."NS_Matrix Updated")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the  Matrix Updated for the Job';   //PRJ-768.JS.1.0 26July2021
                Visible = false;//PRJ-492.RS.1.0 10May2021
            }
        }
        //PRJ-492.RS.1.0 10May2021 Start
        addafter(Description)
        {
            field("NS_Cost Category"; Rec."NS_Cost Category")
            {
                Caption = 'Cost Category';
                ApplicationArea = All;
                ToolTip = 'Specifies the  Cost Category for the Job'; //PRJ-768.JS.1.0 23July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021
            }
            field("NS_Revenue Category"; Rec."NS_Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the  Revenue Category for the Job';    //PRJ-768.JS.1.0 23July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                //Visible = true;//PRJ-492.RS.1.0 10May2021 //PRJ-492.RS.2.0 27May2021 Comment
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the  Work Units for the Job';  //PRJ-768.JS.1.0 26July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                // Visible = true;//PRJ-492.RS.1.0 10May2021 //PRJ-492.RS.2.0 27May2021 Comment
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the  Work Unit of Measure for the Job';    //PRJ-768.JS.1.0 26July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                //Visible = true;//PRJ-492.RS.1.0 10May2021 //PRJ-492.RS.2.0 27May2021 Comment
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Progress Billing Method"; Rec."NS_Progress Billing Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Progress Billing Method for the Job';  //PRJ-768.JS.1.0 26July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 10May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 10May2021

                //PRJ-588.AS.1.0 21APRILH2021 - START
                trigger OnValidate()
                begin
                    if (rec."Line Type" <> Rec."Line Type"::Budget) and (Rec."NS_Progress Billing Method" = Rec."NS_Progress Billing Method"::"%") then begin
                        if (Rec.Quantity > 1) then
                            Error('Qty cannot be greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                        if (Rec.Quantity < 0) then
                            Error('Qty cannot be  greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                    end;
                end;
                //PRJ-588.AS.1.0 21APRIL2021 - END
            }
        }
        addafter("Qty. to Transfer to Journal")
        {
            field("NS_Qty. Posted"; "Qty. Posted")
            {
                Caption = 'Qty. Posted';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Remaining Qty."; "Remaining Qty.")
            {
                Caption = 'Remaining Qty.';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Qty. to Transfer to Invoice"; "Qty. to Transfer to Invoice")
            {
                Caption = 'Qty. to Transfer to Invoice';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Qty. Transferred to Invoice"; "Qty. Transferred to Invoice")
            {
                Caption = 'Qty. Transferred to Invoice';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Qty. to Invoice"; "Qty. to Invoice")
            {
                Caption = 'Qty. to Invoice';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Qty. Invoiced"; "Qty. Invoiced")
            {
                Caption = 'Qty. Invoiced';
                ApplicationArea = All;
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
        }
        addafter("Invoiced Amount (LCY)")
        {
            field("NS_Gross Profit"; Rec."NS_Gross Profit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gross Profit for the job';  //PRJ-768.JS.1.0 26July2021
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
            field("NS_Gross Profit Percentage"; Rec."NS_Gross Profit Percentage")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the  Gross Profit Percentage for the Job';  //PRJ-768.JS.1.0 26July2021
                Visible = false;//PRJ-492.RS.2.0 27May2021
            }
        }
        modify("Qty. to Transfer to Journal")//PRJ-492.RS.2.0 24May2021
        {
            ApplicationArea = All;
        }
        addafter("Job Task No.")
        {
            //PRJ-929.GK.1.0 22Sep2021 start
            field("NS_Use Tax"; Rec."NS_Use Tax")
            {
                ToolTip = 'Specifies the value of the Use Tax field';
                ApplicationArea = All;
                Caption = 'Use Tax';
                Visible = false;
            }
            field("NS_Use Tax Amounts"; Rec."NS_Use Tax Amounts")
            {
                ToolTip = 'Specifies the value of the Use Tax Amount field';
                ApplicationArea = All;
                Caption = 'Use Tax Amount';
                Visible = false;
            }
            field("NS_Use Tax Percentage"; Rec."NS_Use Tax Percentage")
            {
                ToolTip = 'Specifies the value of the Use Tax Percentage field';
                ApplicationArea = All;
                Visible = false;
                Caption = 'Use Tax Percentage';
            }
            field("NS_Total Cost with Use Tax"; Rec."NS_Total Cost with Use Tax")
            {
                ToolTip = 'Specifies the value of the Total Cost with Use Tax field';
                ApplicationArea = All;
                Visible = false;
                Caption = 'Total Cost with Use Tax';
            }
            //PRJ-929.GK.1.0 22Sep2021 end
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Segment Code for the Job';  //PRJ-768.JS.1.0 26July2021
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 25May2021  Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021 
            }
            //PRJ-973.GK.1.0 13Oct2021 start
            field("NS_Use Job Plan. Line Entries"; Rec."NS_Use Job Plan. Line Entries")
            {
                ToolTip = 'Specifies the boolean if Progress Billing flow same G/L in Sales Document.';
                ApplicationArea = All;
                Editable = NS_UseJobPlanningBoolean;
            }
            //PRJ-973.GK.1.0 13Oct2021 end
            //PRJ-895.GK.1.0 27Aug2021 start
            field("NS_Use Tax SKU"; Rec."NS_Use Tax SKU")
            {
                ApplicationArea = All;
                ToolTip = 'Specify the Use Tax Sku';
                Visible = false;//PRJ-929.GK.1.0
            }
            field("NS_Use Tax Amount"; Rec."NS_Use Tax Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specify the Use Tax Amount';
                Visible = false;//PRJ-929.GK.1.0
            }
            //PRJ-895.GK.1.0 27Aug2021 end
        }
        addafter("NS_Gross Profit Percentage")
        {
            field("NS_DFR No."; Rec."NS_DFR No.")
            {
                ApplicationArea = all;
                Caption = 'DFR No.';
                Description = 'JD-10.MS.1.0';
                Editable = true;//JD-49.MS.1.0
                //Visible = false; //PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                //Visible = true;//PRJ-492.RS.1.0 25May2021 //PRJ-492.RS.2.0 27May2021 Comment
                Visible = false;//PRJ-492.RS.2.0 27May2021
                ToolTip = 'Specifies the  DFR No. for the Job';  //PRJ-768.JS.1.0 26July2021
            }
        }
        //PRJ-492.RS.1.0 10May2021 end
    }
    actions
    {
        addafter("&Reservation Entries")
        {
            action(NS_GetJobSegments)
            {
                ApplicationArea = All;
                Caption = 'Get Job Segments';
                Image = Job;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;

                trigger OnAction();
                var
                    JobSegment: Page "NS_Job Takeoff Worksheet";
                begin
                    JobSegment.NS_InitPage("Job No.", '');
                    JobSegment.RUNMODAL;
                end;
            }
            action(NS_GetJobTaskSegments)
            {
                ApplicationArea = All;
                Caption = 'Get Job Task Segments';
                Image = JobListSetup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    JobSegment: Page "NS_Job Takeoff Worksheet";
                begin
                    JobSegment.NS_InitPage("Job No.", "Job Task No.");
                    JobSegment.RUNMODAL;
                end;
            }
            action(NS_CreateSalesInvoiceNew)  //JD-10.MS.1.0
            {
                ApplicationArea = All;
                Caption = 'Create DFR Sales Invoice ';
                Image = CreateJobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction();
                var
                    JobCreateInvoice: Codeunit 1002;
                    JobPlanningLine: Record "Job Planning Line";
                    inputDialog: Dialog;
                    ValidDate: Text;
                    DFRdateFilter: Page 14021455;
                begin
                    DFRdateFilter.RunModal();
                    DFRdateFilter.NS_GetPlanningdate(StartDate, EndDate);
                    if (StartDate = 0D) or (EndDate = 0D) then
                        Error('Please select the Planning date');
                    JobPlanningLine.COPY(Rec);
                    JobPlanningLine.SetFilter("Line Type", '%1', JobPlanningLine."line Type"::Billable);//JD-44.NS.1.0 12Aug2020 code comment
                    JobPlanningLine.SetFilter("Line Type", '<>%1', JobPlanningLine."Line Type"::Budget); //JD-44.NS.1.0 12Aug2020
                    JobPlanningLine.SetFilter("NS_DFR No.", '<>%1', '');
                    JobPlanningLine.SetRange("Planning Date", StartDate, EndDate);
                    JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, false);
                end;
            }
            //JD-54.AM.1.0 start
            action(NS_UnlockLockDFR)
            {
                ApplicationArea = all;
                Caption = 'Lock/UnLock DFR';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = report LockUnlockDFRs;
                trigger OnAction()
                var
                begin
                    Report.Run(14021424, true);

                end;
            }
            //JD-54.AM.1.0 end

        }
        addafter(DemandOverview)
        {
            separator(NS_Separator1100773027)
            {
            }
            action(NS_ImportExcelSht)
            {
                ApplicationArea = All;
                Caption = 'Excel Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;//PRJ-473.AS.1.0 20JAN2021

                trigger OnAction();
                var
                    q: Integer;
                    ImportHdrPg: Page "NS_Export / Import Header";
                begin
                    ImportHdrPg.NS_SetJobNo("Job No.");
                    q := q;
                    ImportHdrPg.RUNMODAL;
                end;
            }
            group(NS_Lock)
            {
                Caption = 'Lock';
                action("NS_Lock Planning Lines to Original")
                {
                    ApplicationArea = All;
                    Image = CopyBudget;
                    Caption = 'Lock Planning Lines to Original'; //PRJ-659.RS.1.0�22June21 New Added

                    trigger OnAction();
                    begin
                        //ProjectPro - start
                        NS_Job.NS_CopyPlanningToLocked("Job No.");
                        //ProjectPro - end
                    end;
                }
            }
        }
        addafter("Jobs - Transaction Detail")
        {
            //PPDA.1.0.TBA Start
            // action("NS_Job Cost Budget")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Job Cost Budget';
            //     Promoted = true;
            //     PromotedCategory = "Report";
            //     RunObject = Report "Job Cost Budget";
            // }

            // action("NS_Job Actual to Budget Price")
            // {
            //     Caption = 'Job Actual to Budget Price';
            //     ApplicationArea = all;
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = "Report";
            //     RunObject = Report "Job Actual to Budget (Price)";
            // }
            //PPDA.1.0.TBA End
        }
    }
    //JD-54.AM.1.0 Start
    trigger OnModifyRecord(): Boolean
    var
    begin
        if Rec."NS_DFR Locked" then
            Error('You cannot Modify Locked Job Planning line');

        //JD-48.AS.1.0 31OCT2020 - start
        if xRec."NS_Segment Code" <> '' then begin
            if xRec."NS_Segment Code" <> Rec."NS_Segment Code" then
                ERROR('You cannot change the %1, %2, %3 of this %4.', FIELDCAPTION("Job No."), FIELDCAPTION("Job Task No."), FIELDCAPTION("NS_Segment Code"), TABLECAPTION);
        end;
        //JD-48.AS.1.0 31OCT2020 - end
    end;
    //JD-54.AM.1.0 End

    var
        NS_Job: Record Job;
        GetLinkEditable: Boolean;//PRJ-568
        NS_ShowJobNo: Code[20];
        NS_JobDescription: Text[50];
        NS_LineJobDescription: Text[100];//PRJ-301.AS.1.0 Increase length from 50 to 100
        NS_UseJobPlanningBoolean: Boolean; //PRJ-973.GK.1.0 13Oct2021 |Add Boolean
        NS_ShowLineType: Option;
        NS_ShowAdjustmentLines: Code[10];
        NS_SkillClassEditable: Boolean;
        NS_BelowCost: Boolean;
        ItemNotFound: Boolean;
        JobNo2: Code[20];
        TaskNo: Code[20];
        Text14021400: Label 'Do you wish to apply this Segment Code %1 to all unassigned planning lines?';
        BySegment: Boolean;
        SegmentCode: Code[20];
        SegCode: Code[20];
        CalledFromGetBudgLines: Boolean;
        SubcontractNo: Code[20];
        SegmentName: Text;
        JobTakeoffSegments: Record "NS_Job Takeoff Segments";
        PurchaseOrderNo: Code[20];
        Text14021401: Label 'YES';
        Text14021402: Label 'NO';
        StartDate: Date;
        EndDate: Date;
        JobPlaningLineVar: Record "Job Planning Line";//PRJ-271/PRJ-272 VT1.0 21-05-20

    trigger OnAfterGetCurrRecord();
    var
        Jobssetup: Record "Jobs Setup"; //PRJ-170.MS.1.0 Added
    begin
        NS_SkillClassEditable := ("Qty. Transferred to Invoice" = 0);

        if "NS_Item Not Found" then
            ItemNotFound := true
        else
            ItemNotFound := false;
        JobsSetup.GET; //PRJ-170.MS.1.0 Added
        IF JobsSetup."NS_HighlightPrice LessThanCost" THEN BEGIN  //PRJ-170.MS.1.0 Added
            if "Unit Cost" > "Unit Price" then
                NS_BelowCost := true
            else
                NS_BelowCost := false;
        end; //PRJ-170.MS.1.0 Added

        //PRJ-568.AS.1.0 - START
        if Rec.Type <> Rec.Type::Item then
            GetLinkEditable := false;

        if Rec.Type = Rec.Type::Item then
            GetLinkEditable := true;
        //PRJ-568.AS.1.0 - END
        //PRJ-973.GK.1.0 13Oct2021 start
        If ((Rec."Line Type" <> Rec."Line Type"::Budget) AND (Rec.Type = Rec.Type::"G/L Account")) then
            NS_UseJobPlanningBoolean := true
        else
            NS_UseJobPlanningBoolean := false;
        //PRJ-973.GK.1.0 13Oct2021 end
    end;

    trigger OnAfterGetRecord();
    var
        JobsSetup: Record "Jobs Setup";
    begin
        SetLineJobDescription;
        IF "NS_Item Not Found" THEN
            ItemNotFound := TRUE
        ELSE
            ItemNotFound := FALSE;

        JobsSetup.GET;
        IF JobsSetup."NS_HighlightPrice LessThanCost" THEN BEGIN
            IF "Unit Cost" > "Unit Price" THEN
                NS_BelowCost := TRUE
            ELSE
                NS_BelowCost := FALSE;
        END;

        //PRJ-568.AS.1.0 - START
        if Rec.Type <> Rec.Type::Item then
            GetLinkEditable := false;

        if Rec.Type = Rec.Type::Item then
            GetLinkEditable := true;
        //PRJ-568.AS.1.0 - END
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        if SegCode <> '' then
            VALIDATE("NS_Segment Code", SegCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetLineJobDescription;
    end;

    trigger OnOpenPage();
    begin
        GetLinkEditable := true;//PRJ-568.AS.1.0
        NS_SkillClassEditable := TRUE;
        IF NS_ShowJobNo > '' THEN BEGIN
            SETFILTER("Job No.", NS_ShowJobNo);
            SETFILTER("Line Type", '%1|%2', NS_ShowLineType, 2);
            IF NS_ShowAdjustmentLines = Text14021401 THEN
                SETFILTER(NS_Adjustment, '>%1', '')
            ELSE
                IF NS_ShowAdjustmentLines = Text14021402 THEN
                    SETFILTER(NS_Adjustment, '=%1', '');
        END;

        IF JobNo2 <> '' THEN
            SETRANGE("Job No.", JobNo2);
        IF TaskNo <> '' THEN
            SETRANGE("Job Task No.", TaskNo);
        IF SegCode <> '' THEN BEGIN
            SETRANGE("NS_Segment Code", SegCode);
            SegmentCode := SegCode;
        END ELSE
            SegmentCode := '';

        SegmentName := '';
        IF SegmentCode <> '' THEN BEGIN
            JobTakeoffSegments.RESET;
            JobTakeoffSegments.SETRANGE("NS_Job No.", JobNo2);
            JobTakeoffSegments.SETRANGE("NS_Segment Code", SegmentCode);
            IF JobTakeoffSegments.FINDFIRST THEN
                SegmentName := JobTakeoffSegments."NS_Segment Name";
        END;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if (CalledFromGetBudgLines) and (CloseAction in [ACTION::OK, ACTION::LookupOK]) then begin
            //CurrPage.SETSELECTIONFILTER(Rec);
            CurrPage.SETSELECTIONFILTER(JobPlaningLineVar);//PRJ-271/PRJ-272 VT1.0 21-05-20
            if JobPlaningLineVar.FindSet() then
                //  if not JobPlaningLineVar.IsEmpty then
            if SubcontractNo > '' then
                    CreateSubContractDetail(JobPlaningLineVar)
                else
                    NS_CreatePurchaseOrderDetail(JobPlaningLineVar, PurchaseOrderNo); //PRJ-389 changes var rec to JobPlaningLineVar
        end;
    end;

    procedure SetFilters(JobNo: Code[20]; LineType: Option);
    begin
        //ProjectPro - start
        NS_ShowJobNo := JobNo;
        NS_ShowLineType := LineType;
        //ProjectPro - end
    end;

    local procedure SetLineJobDescription();
    begin
        //ProjectPro - start
        NS_LineJobDescription := '';
        if NS_Job.GET("Job No.") then
            // >> 001
            //NS_LineJobDescription := NS_Job.Description;
            NS_LineJobDescription := CopyStr(NS_Job.Description, 1, MaxStrLen(NS_LineJobDescription));
        // << 001
        //ProjectPro - end
    end;

    procedure SetShowAdjustmentLines(PassedShowAdjLines: Code[10]);
    begin
        //ProjectPro - start
        NS_ShowAdjustmentLines := PassedShowAdjLines;
        //ProjectPro - end
    end;

    procedure InitVar(lJobNo: Code[20]; lTaskNo: Code[20]; TrueFalse: Boolean; lSegCode: Code[20]);
    begin
        JobNo2 := lJobNo;
        TaskNo := lTaskNo;
        BySegment := TrueFalse;
        SegCode := lSegCode;
        SegmentCode := lSegCode;
    end;

    procedure SetGetFrom(PassGetFromGetBudg: Boolean; PassSubcontract: Code[20]; PassPurchaseOrder: Code[20]);
    begin
        //ProjectPro
        CalledFromGetBudgLines := PassGetFromGetBudg;
        SubcontractNo := PassSubcontract;
        //ProjectPro - start
        PurchaseOrderNo := PassPurchaseOrder;
        //ProjectPro - end
    end;

    local procedure CreateSubContractDetail(var NS_PassJobPlanningLine: Record "Job Planning Line");
    var
        NS_SubcontractDetail: Record "NS_Subcontract Lines";
        NS_SubcontractReference: Record NS_Subcontract;
        NS_JobsSetup: Record "Jobs Setup";
        NS_SubcontractHeader: Record NS_Subcontract;
        NS_NextLineNo: Integer;
        NS_JobTask: Record "Job Task";
        JobSetup: Record "Jobs Setup";      //PRJ-866.JS.1.0 19Aug2021
        NS_JobTask1: Record "Job Task";   //PRJ-913.JS.1.0 14Set2021
        NS_BillingHeader: Record "NS_Progress Billing Header"; //PRJ-913.JS.1.0 14Set2021
        NS_Jobs: Record Job;    //PRJ-906.GK.1.0 04Oct2021 

    begin
        //ProjectPro - start
        JobSetup.Get();    //PRJ-866.JS.1.0 19Aug2021
        with NS_SubcontractDetail do begin
            if NS_PassJobPlanningLine.FINDSET then //PRJ-271/PRJ-272 VT1.0 21-05-20
                repeat
                    if (NS_PassJobPlanningLine."NS_Subcontract No." <> '') and (NS_PassJobPlanningLine."NS_Subcontract Line No." > 0) then//PRJ-271/PRJ-272 VT1.0 21-05-20
                        Error('Sub Contract Line Already Exist with Subcontract No. %1 Line No. %2', NS_PassJobPlanningLine."NS_Subcontract No.", NS_PassJobPlanningLine."NS_Subcontract Line No.");//PRJ-271/PRJ-272 VT1.0 21-05-20
                    RESET;
                    //  SETRANGE("NS_Subcontract No.", SubcontractNo);
                    //  SETRANGE(NS_Type, NS_PassJobPlanningLine.Type);	 
                    SetCurrentKey("NS_Subcontract No.", "NS_Line No.");
                    SETRANGE("NS_Subcontract No.", SubcontractNo);
                    //case Type of
                    //    Type::Resource:
                    //        SETRANGE(NS_Type, Type::Resource);
                    //    Type::Item:
                    //        SETRANGE(NS_Type, Type::Item);
                    //    Type::"G/L Account":
                    //        SETRANGE(NS_Type, Type::"G/L Account");
                    //end;
                    //SETRANGE("NS_No.", NS_PassJobPlanningLine."No.");
                    //PRJ-271/PRJ-272 VT1.0 21-05-20 end
                    if FINDLAST then
                        NS_NextLineNo := "NS_Line No." + 10000 //PPAL-54.MS.1.0
                    else
                        NS_NextLineNo := 10000;
                    INIT;
                    "NS_Subcontract No." := SubcontractNo;
                    "NS_Line No." := NS_NextLineNo;//PPAL-54.MS.1.0
                    "NS_Job No." := NS_PassJobPlanningLine."Job No.";//PPAL-54.MS.1.0
                    "NS_Job Task No." := NS_PassJobPlanningLine."Job Task No.";
                    "NS_JPL Line No." := NS_PassJobPlanningLine."Line No.";   //PRJ-866.JS.1.0  18Aug2021
                    NS_JobTask.GET("Job No.", "Job Task No.");//PPAL-54.MS.1.0
                    "NS_Job Task Description" := NS_JobTask.Description;
                    NS_SubcontractReference.NS_JobTaskNoToAPO(NS_PassJobPlanningLine."Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
                    "NS_Job Cost Category" := NS_PassJobPlanningLine."NS_Cost Category";
                    case NS_PassJobPlanningLine.Type of
                        NS_PassJobPlanningLine.Type::Resource: //PPAL-54.MS.1.0
                            NS_Type := NS_Type::Resource;
                        NS_PassJobPlanningLine.Type::Item:
                            NS_Type := NS_Type::Item;
                        NS_PassJobPlanningLine.Type::"G/L Account":
                            NS_Type := NS_Type::"G/L Account";
                    end;
                    "NS_No." := NS_PassJobPlanningLine."No.";//PPAL-54.MS.1.0
                    NS_Description := NS_PassJobPlanningLine.Description;
                    NS_Quantity := NS_PassJobPlanningLine.Quantity;

                    //Determine the Unit of Measure code to use on this line.  If it can't be determined then leave blank
                    NS_JobsSetup.GET;
                    if NS_JobsSetup."NS_Subcontract Use of UOM" <> NS_JobsSetup."NS_Subcontract Use of UOM"::None then
                        if NS_JobsSetup."NS_Subcontract Use of UOM" = NS_JobsSetup."NS_Subcontract Use of UOM"::"Always Default" then
                            "NS_Unit of Measure Code" := NS_JobsSetup."NS_Subcontract Default UOM"
                        else
                            if NS_PassJobPlanningLine."Unit of Measure Code" = '' then
                                "NS_Unit of Measure Code" := NS_JobsSetup."NS_Subcontract Default UOM"
                            else
                                "NS_Unit of Measure Code" := NS_PassJobPlanningLine."Unit of Measure Code";

                    "NS_Direct Unit Cost" := NS_PassJobPlanningLine."Direct Unit Cost (LCY)";
                    "NS_Unit Cost" := NS_PassJobPlanningLine."Unit Cost (LCY)";
                    "NS_Work Units" := NS_PassJobPlanningLine."NS_Work Units";
                    "NS_Work Unit of Measure" := NS_PassJobPlanningLine."NS_Work Unit of Measure";
                    //PRJ-906.GK.1.0 04Oct2021 - Start
                    IF NS_SubcontractHeader.GET(SubcontractNo) then begin
                        "NS_Dimension Set ID" := NS_SubcontractHeader."NS_Dimension Set ID";
                        IF NS_Jobs.get(NS_PassJobPlanningLine."Job No.") then begin
                            NS_SubcontractHeader."NS_Retention Percent" := NS_Jobs."NS_Default Job Retention";
                            NS_SubcontractHeader.Modify();
                        end;
                    end;
                    //PRJ-906.GK.1.0 04Oct2021 - end
                    VALIDATE("NS_Unit Cost");
                    //PRJ-866.JS.1.0  19Aug2021-Start
                    IF JobSetup."NS_Unapply UsageLink on Subcon" = false then
                        "NS_Job Planning Line No." := NS_PassJobPlanningLine."Line No."
                    else
                        "NS_Job Planning Line No." := 0;
                    //PRJ-866.JS.1.0  19Aug2021-end

                    //PRJ-913.JS.1.0  14Sep2021-Start
                    if NS_JobTask1.GET(NS_PassJobPlanningLine."Job No.", NS_PassJobPlanningLine."Job Task No.") then
                        IF ((NS_JobTask1."Global Dimension 1 Code" <> '') and (NS_JobTask1."Global Dimension 2 Code" <> '')) then
                            "NS_Dimension Set ID" := NS_BillingHeader.NS_GetDimensionNoFromJobTask(NS_PassJobPlanningLine."Job No.", NS_PassJobPlanningLine."Job Task No.");
                    //PRJ-913.JS.1.0  14Sep2021-End

                    INSERT;
                    NS_PassJobPlanningLine."NS_Subcontract No." := SubcontractNo;
                    NS_PassJobPlanningLine."NS_Subcontract Line No." := NS_SubcontractDetail."NS_Line No.";//PRJ-271/PRJ-272 VT1.0 21-05-20

                    NS_PassJobPlanningLine.MODIFY;
                until NS_PassJobPlanningLine.NEXT = 0;
        end;
    end;

    local procedure NS_CreatePurchaseOrderDetail(var NS_PassJobPlanningLine: Record "Job Planning Line"; NS_PurchOrderNo: Code[20]);
    var
        NS_PurchaseLine: Record "Purchase Line";
        NS_Job: Record Job;
        NS_JobsSetup: Record "Jobs Setup";
        NS_PurchaseHeader: Record "Purchase Header";
        NS_LastLineNo: Integer;
    begin
        //ProjectPro
        NS_JobsSetup.Get();     //PRJ-866.JS.1.0 19Aug2021
        with NS_PurchaseLine do begin
            NS_PurchaseHeader.GET(NS_PurchaseHeader."Document Type"::Order, NS_PurchOrderNo);
            if NS_PassJobPlanningLine.FINDSET then
                repeat
                    //Get the last Line no. in the purchase lines
                    RESET;
                    SETRANGE("Document Type", "Document Type"::Order);
                    SETRANGE("Document No.", NS_PurchOrderNo);
                    NS_LastLineNo := 0;
                    if FINDLAST then
                        NS_LastLineNo := "Line No.";

                    //Make new purchase line record
                    INIT;
                    "Document Type" := NS_PurchaseHeader."Document Type";
                    "Document No." := NS_PurchaseHeader."No.";
                    NS_LastLineNo := NS_LastLineNo + 10000;
                    "Buy-from Vendor No." := NS_PurchaseHeader."Buy-from Vendor No.";
                    "Pay-to Vendor No." := NS_PurchaseHeader."Buy-from Vendor No.";
                    "Line No." := NS_LastLineNo;
                    "Job No." := NS_PassJobPlanningLine."Job No.";
                    "Job Task No." := NS_PassJobPlanningLine."Job Task No.";
                    NS_Job.NS_JobTaskNoToAPO(NS_PassJobPlanningLine."Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                    "NS_Job Cost Category" := NS_PassJobPlanningLine."NS_Cost Category";
                    case NS_PassJobPlanningLine.Type of
                        NS_PassJobPlanningLine.Type::Resource:
                            Type := Type::Resource;
                        NS_PassJobPlanningLine.Type::Item:
                            Type := Type::Item;
                        NS_PassJobPlanningLine.Type::"G/L Account":
                            Type := Type::"G/L Account";
                    end;
                    "Location Code" := NS_PassJobPlanningLine."Location Code";
                    validate("No.", NS_PassJobPlanningLine."No."); //PRJ-389 validate no.
                    Description := NS_PassJobPlanningLine.Description;
                    "Description 2" := NS_PassJobPlanningLine."Description 2";
                    VALIDATE(Quantity, NS_PassJobPlanningLine.Quantity);
                    "Unit of Measure Code" := NS_PassJobPlanningLine."Unit of Measure Code";
                    validate("Direct Unit Cost", NS_PassJobPlanningLine."Unit Cost");//PRJ-389
                    "Direct Unit Cost (LCY)" := NS_PassJobPlanningLine."Direct Unit Cost (LCY)";
                    "Unit Cost" := NS_PassJobPlanningLine."Unit Cost";
                    VALIDATE("Unit Cost (LCY)", NS_PassJobPlanningLine."Unit Cost (LCY)");
                    "NS_Work Units" := NS_PassJobPlanningLine."NS_Work Units";
                    "NS_Work Unit of Measure" := NS_PassJobPlanningLine."NS_Work Unit of Measure";
                    "Dimension Set ID" := NS_PassJobPlanningLine."NS_Dimension Set ID";
                    "Bin Code" := NS_PassJobPlanningLine."Bin Code";
                    "Currency Code" := NS_PassJobPlanningLine."Currency Code";
                    "Gen. Bus. Posting Group" := NS_PassJobPlanningLine."Gen. Bus. Posting Group";
                    "Gen. Prod. Posting Group" := NS_PassJobPlanningLine."Gen. Prod. Posting Group";
                    //"Location Code" := NS_PassJobPlanningLine."Location Code";
                    //"Shortcut Dimension 1 Code" := NS_PassJobPlanningLine."NS_Shortcut Dimension 1 Code";  //PRJ-389 comment
                    //"Shortcut Dimension 2 Code" := NS_PassJobPlanningLine."NS_Shortcut Dimension 2 Code"; //PRJ-389 comment
                    "NS_Subcontract No." := NS_PassJobPlanningLine."NS_Subcontract No.";
                    "Variant Code" := NS_PassJobPlanningLine."Variant Code";
                    "Work Type Code" := NS_PassJobPlanningLine."Work Type Code";
                    "Currency Factor" := NS_PassJobPlanningLine."Currency Factor";
                    "Job Currency Factor" := NS_PassJobPlanningLine."Currency Factor";
                    "Job Line Amount" := NS_PassJobPlanningLine."Line Amount";
                    //PRJ-866.JS.1.0  19Aug2021-Start
                    "Unit Price" := NS_PassJobPlanningLine."Unit Price";
                    "Unit Price (LCY)" := NS_PassJobPlanningLine."Unit Price (LCY)";
                    "Job Unit Price" := NS_PassJobPlanningLine."Unit Price";
                    "Job Unit Price (LCY)" := NS_PassJobPlanningLine."Unit Price (LCY)";
                    //PRJ-866.JS.1.0  19Aug2021-end
                    "Job Line Amount (LCY)" := NS_PassJobPlanningLine."Line Amount (LCY)";
                    "Job Line Discount %" := NS_PassJobPlanningLine."Line Discount %";
                    "Job Line Discount Amount" := NS_PassJobPlanningLine."Line Discount Amount";
                    "Job Line Disc. Amount (LCY)" := NS_PassJobPlanningLine."Line Discount Amount (LCY)";
                    "VAT %" := NS_PassJobPlanningLine."VAT %";
                    "VAT Base Amount" := NS_PassJobPlanningLine."VAT Line Amount";
                    "Line Type" := NS_PassJobPlanningLine."Line Type";
                    "NS_Segment Code" := NS_PassJobPlanningLine."NS_Segment Code";//PPAL-171.AM.1.0 

                    if NS_Job.GET(NS_PassJobPlanningLine."Job No.") and (NS_Job."Apply Usage Link") then
                        "Job Planning Line No." := NS_PassJobPlanningLine."Line No.";
                    //PRJ-389 start
                    //PRJ-866.JS.1.0  19Aug2021-Start
                    IF NS_JobsSetup."NS_Unapply UsageLink on Subcon" = true then
                        "Job Planning Line No." := 0;
                    //PRJ-866.JS.1.0  19Aug2021-end   
                    "NS_job Revenue Category" := NS_PassJobPlanningLine."NS_Revenue Category";
                    if NS_PassJobPlanningLine."NS_Shortcut Dimension 1 Code" <> '' then
                        "Shortcut Dimension 1 Code" := NS_PassJobPlanningLine."NS_Shortcut Dimension 1 Code"
                    else
                        "Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    if NS_PassJobPlanningLine."NS_Shortcut Dimension 2 Code" <> '' then
                        "Shortcut Dimension 2 Code" := NS_PassJobPlanningLine."NS_Shortcut Dimension 2 Code"
                    else
                        "Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    //PRJ-389 end
                    INSERT;
                until NS_PassJobPlanningLine.NEXT = 0;
        end;
    end;
}

