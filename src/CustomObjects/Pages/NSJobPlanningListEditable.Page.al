page 14021217 "NS_Job PlanningList(Editable)"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-325.AS.1.0 16JULY2020 Given insert modify & delete permission on page & also added some code
    //PRJ-301.MS.1.0 change length from 50 to 100
    //JD-54.AM.1.0 Added 3 new fields on page & one action .
    //JD-54.AM.1.0 Added code on 2 page triggers.
    //PRJ-492.RS.1.0 21May2021 | Hide/Unhide Fields
    //PRJ-761.AS.1.0 Done code for line description job value
    //PRJ-770.RS.1.0 12July2021 | Error in job planning line during the function "Edit Planning lines"
    //PRJ-895.GK.1.0 27Aug2021 | Added two field Use Tax Sku & Use Tax Amount.
    //PRJ-1717.SD.1.06Dec2022 | Added Code for Drill Down Page "Job Invoices".    
    Caption = 'Job Planning List (Editable)';
    DataCaptionExpression = Caption;
    DelayedInsert = true;
    AutoSplitKey = true;//PRJ-563.AS.3.0
    Editable = true;
    InsertAllowed = true;//PRJ-325.AS.1.0 16JULY2020
    ModifyAllowed = true;//PRJ-325.AS.1.0 16JULY2020
    DeleteAllowed = true;//PRJ-325.AS.1.0 16JULY2020
    PageType = Worksheet;//PPAL-107.AS.1.0 13AUG2020 No change
    SourceTable = "Job Planning Line";
    SourceTableView = SORTING("Job No.", "Job Task No.", "Line No.")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            field(JobNo; JobNo)
            {
                ApplicationArea = All;
                Caption = 'Job No.';
                ToolTip = 'Specifies the Job No.';

                trigger OnLookup(VAR Text: Text): Boolean;
                begin
                    Job."No." := JobNo;
                    if PAGE.RUNMODAL(0, Job) = ACTION::LookupOK then begin
                        Job.GET(Job."No.");
                        JobNo := Job."No.";
                        JobDescription := Job.Description;
                        SETRANGE("Job No.", JobNo);
                        CurrPage.UPDATE();
                    end;
                end;

                trigger OnValidate();
                begin
                    Job.GET(JobNo);
                    JobDescription := Job.Description;
                    NS_JobNoOnAfterValidate();
                end;
            }
            field(JobDescription; JobDescription)
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Description';
                Caption = 'Job Description';
            }
            repeater(Control1)
            {
                field("Entry Type"; Rec."NS_Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Entry Type';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Currency Date"; Rec."Currency Date")//PRJ-492.RS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Currency Date';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("NS_Line Job Description"; NS_LineJobDescription)//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    Caption = 'Line Job Description';
                    Editable = false;
                    //Style = Unfavorable;
                    //StyleExpr = ItemNotFound;
                }
                field("Job Task No."; Rec."Job Task No.")//PRJ-492.RS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                    //Visible = false; //PRJ-492.AS.1.0 //DOUBT //PRJ-492.RS.1.0 25May2021  comment
                    Visible = true;//PRJ-492.RS.1.0 25May2021 
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Type';
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Planning Date';
                }
                field("Planned Delivery Date"; "Planned Delivery Date")//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that is planned to deliver the item connected to the job planning line. For a resource, the planned delivery date is the date that the resource performs services with respect to the job.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Document No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';
                    Visible = false;
                }

                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Category';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field(Adjustment; Rec.NS_Adjustment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Adjustment';
                    Visible = false;
                    Caption = 'Adjustment';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field("NS_Get Linked Resource"; Rec."NS_Get Linked Resource")
                {
                    ApplicationArea = All;
                    Caption = 'Get Linked Resource';
                    Editable = GetLinkEditable;
                    Visible = false;//PRJ-492.RS.1.0 21May2021

                    trigger OnValidate()
                    var
                        JPLRec: Record "Job Planning Line";
                        JPLRec2: Record "Job Planning Line";
                        jobTblRec: Record Job;
                        Res: Record Resource;
                        Res2: Record Resource;
                        JobTaskRec: Record "Job Task";//PRJ-568.AS.1.0 18MAR2021
                        JQHeader: Record "NS_Job Quote Header";//PRJ-1068.AS.1.0
                        TLaborRatebyTask: Record "NS_Labor rate by task list";//PRJ-1068.AS.1.0
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
                            JPLRec.SetRange("Job Task No.",Rec."Job Task No.");
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
                                JPLRec2."Planned Delivery Date" := Rec."Planned Delivery Date";
                                JPLRec2."NS_Progress Billing Method" := Rec."NS_Progress Billing Method";
                                JPLRec2.Type := JPLRec2.Type::Resource;
                                JPLRec2."No." := Rec."NS_Linked Resource";
                                IF Res.GET(rec."NS_Linked Resource") Then begin
                                    IF Res."NS_Job Revenue Category" <> '' THEN
                                        JPLRec2."NS_Revenue Category" := Res."NS_Job Revenue Category";
                                    IF Res."NS_Job Cost Category" <> '' THEN
                                        JPLRec2."NS_Cost Category" := Res."NS_Job Cost Category";
                                    JPLRec2.Description := Res.Name;
                                    JPLRec2."Description 2" := Res."Name 2";
                                    JPLRec2."Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                                    JPLRec2."Resource Group No." := Res."Resource Group No.";
                                    JPLRec2."Unit of Measure Code" := Res."Base Unit of Measure";
                                    //PRJ-1068.AS.1.0 START
                                    if Res.Type = Res.Type::Person then begin
                                        if JQHeader.get(Rec."Job No.") then begin
                                            if JQHeader."NS_Job Type Code" <> '' then begin
                                                TLaborRatebyTask.Reset();
                                                TLaborRatebyTask.SetRange("NS_Job Type Code", JQHeader."NS_Job Type Code");
                                                if TLaborRatebyTask.FindFirst() then
                                                    JPLRec2.Validate("Unit Cost", TLaborRatebyTask."NS_Labor Rate");
                                            end;
                                        end;
                                    end;

                                    if NOT JQHeader.get(Rec."Job No.") then
                                        JPLRec2."Unit Cost" := Res."Unit Cost";
                                    //PRJ-1068.AS.1.0 END
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
                                // JPLRec2."Gen. Bus. Posting Group" := jobTblRec."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-895.GK.1.0 27Aug2021 start
                field("NS_Use Tax SKU"; Rec."NS_Use Tax SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Use Tax Sku';
                    Visible = true;
                }
                field("NS_Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Use Tax Amount';
                    Visible = true;
                }
                //PRJ-895.GK.1.0 27Aug2021 end

                //PRJ-563.AS.1.0 - start Commented not to give
                //field("NS_Assembley BOM"; Rec."NS_Assembley BOM")
                //{
                //    ApplicationArea = All;
                //    Caption = 'Assembley BOM';
                //    Editable = false;

                //    trigger OnDrillDown()
                //    var
                //        AssemBOMRec: Record "NS_Assembley BOM Components";
                //        BOMComponentRec: Record "BOM Component";
                //    begin
                //        AssemBOMRec.Reset();
                //        AssemBOMRec.SetRange("NS_Job No.", rec."Job No.");
                //        AssemBOMRec.SetRange("NS_Job Task No.", rec."Job Task No.");
                //        AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."No.");
                //        //AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."Line No.");
                //        if AssemBOMRec.FindSet() then
                //            page.Run(Page::"NS_Assembley BOM Components", AssemBOMRec);
                //    end;
                //}
                //PRJ-563.AS.1.0 - end Commented

                //PRJ-492.N.S.1.0 Start
                // field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                // {
                //     ApplicationArea = All;
                //     Editable = true;
                //     ToolTip = 'Specifies the Gen. Bus. Posting Group';
                // }
                // field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                // {
                //     ApplicationArea = All;
                //     Editable = true;
                //     ToolTip = 'Specifies the Gen. Prod. Posting Group';
                // }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                    //Visible = false;//PRJ-492.RS.1.0 21May2021//PRJ-761.AS.1.0 Commented
                    Visible = true;//PRJ-761.AS.1.0 Added Location change
                }
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 21May2021 Comment
                }
                //PRJ-492.N.S.1.0 End
                //PRJ-492.RS.1.0 21May2021 Start
                field("NS_Revenue Category"; "NS_Revenue Category")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("NS_Work Units"; "NS_Work Units")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("NS_Work Unit of Measure"; "NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("Progress Billing Method"; Rec."NS_Progress Billing Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Progress Billing Method';
                    //Visible = false; //PRJ-492.AS.1.0 //doubt //PRJ-492.RS.1.0 21May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 21May2021

                    //PRJ-588.AS.1.0 16MARCH2021 - START
                    trigger OnValidate()
                    var
                        NS_JobSetup: Record "Jobs Setup"; // PE-229.HS.1.0 14Dec2023
                    begin
                        if NS_JobSetup.Get() then; // PE-229.HS.1.0 14Dec2023
                        if not NS_JobSetup."NS_Disable Qty for % Method" then begin    // PE-229.HS.1.0 14Dec2023
                            if (rec."Line Type" <> Rec."Line Type"::Budget) and (Rec."NS_Progress Billing Method" = Rec."NS_Progress Billing Method"::"%") then begin
                                if (Rec.Quantity > 1) then
                                    Error('Qty cannot be greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                                if (Rec.Quantity < 0) then
                                    Error('Qty cannot be  greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                            end;
                        end;
                    end;  // PE-229.HS.1.0 14Dec2023
                    //PRJ-588.AS.1.0 16MARCH2021 - END
                }
                //PRJ-492.RS.1.0 21May2021 End
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."NS_Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."NS_Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //PRJ-492.N.S.1.0 STa
                // field("Location Code"; Rec."Location Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Location Code';
                // }
                //JD-54.AM.1.0 Start
                field("NS_DFR Created"; Rec."NS_DFR Created")
                {
                    ApplicationArea = all;
                    Description = 'JD-10.MS.1.0';
                    Editable = true;
                    Visible = false; //PRJ-492.AS.1.0   //Doubt
                }
                field("NS_DFR Locked"; Rec."NS_DFR Locked")
                {
                    ApplicationArea = all;
                    Description = 'JD-54.AM.1.0';
                    Editable = false;
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                //JD-54.AM.1.0 End

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                    //PRJ-588.AS.1.0 16MARCH2021 - START
                    trigger OnValidate()
                    var
                        //PRJ-1068.GK.1.0 07Dec2021 start
                        JPLRec: Record "Job Planning Line";
                        JPLRec2: Record "Job Planning Line";
                        jobTblRec: Record Job;
                        Res: Record Resource;
                        Res2: Record Resource;
                        JobTaskRec: Record "Job Task";
                        NS_JobSetup: Record "Jobs Setup"; // PE-229.HS.1.0 14Dec2023
                    //PRJ-1068.GK.1.0 07Dec2021 end
                    begin
                        if NS_JobSetup.Get() then; // PE-229.HS.1.0 14Dec2023
                        if not NS_JobSetup."NS_Disable Qty for % Method" then begin    // PE-229.HS.1.0 14Dec2023
                            if (rec."Line Type" <> Rec."Line Type"::Budget) and (Rec."NS_Progress Billing Method" = Rec."NS_Progress Billing Method"::"%") then begin
                                if (Rec.Quantity > 1) then
                                    Error('Qty cannot be greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                                if (Rec.Quantity < 0) then
                                    Error('Qty cannot be  greater than 1 for Line type Billable Or Both Budget and Billable, in case of Progress Billing Method = %');
                            end;
                        end;
                    end;  // PE-229.HS.1.0 14Dec2023
                    //PRJ-588.AS.1.0 16MARCH2021 - END
                }
                field("Unit Cost"; Rec."Unit Cost")//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Total Cost"; Rec."Total Cost")//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Unit Price"; Rec."Unit Price")//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price';
                }
                field("Line Amount"; Rec."Line Amount")//PRJ-492.RS.1.0 21May2021
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount';
                }
                //PRJ-492.RS.1.0 21May2021 Start
                field("Qty. to Transfer to Journal"; "Qty. to Transfer to Journal")
                {
                    ApplicationArea = All;
                }
                field("Qty. Posted"; "Qty. Posted")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining Qty.';
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("Qty. to Transfer to Invoice"; "Qty. to Transfer to Invoice")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("Qty. Transferred to Invoice"; "Qty. Transferred to Invoice")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                    //PRJ-1717.SD.1.06Dec2022
                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                    //PRJ-1717.SD.1.06Dec2022
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    ApplicationArea = All;
                    Visible = false; //PRJ-492.RS.2.0 27May2021
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qty. Invoiced';
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Amount (LCY)';
                }
                field("NS_Gross Profit"; "NS_Gross Profit")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("NS_Gross Profit Percentage"; "NS_Gross Profit Percentage")
                {
                    ApplicationArea = All;
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                field("NS_DFR No."; Rec."NS_DFR No.")
                {
                    ApplicationArea = all;
                    Description = 'JD-10.MS.1.0';
                    Editable = true;
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt //PRJ-492.RS.1.0 25May2021 comment
                    //Visible = true;//PRJ-492.RS.1.0 25May2021 //PRJ-492.RS.2.0 27May2021 Comment
                    Visible = false;//PRJ-492.RS.2.0 27May2021
                }
                //PRJ-492.RS.1.0 21May2021 End
                field("NS_Linked Resource"; REC."NS_Linked Resource")
                {
                    ApplicationArea = All;
                    Caption = 'Linked Resource';
                    Editable = false;
                    Visible = false;//PRJ-492.RS.1.0 21May2021 End
                }
                field("NS_Parent Linked Item"; REC."NS_Parent Linked Item")
                {
                    ApplicationArea = All;
                    Caption = 'Parent Linked Item';
                    //Editable = false;
                    Visible = false;//PRJ-492.RS.1.0 21May2021 End
                }
                field("NS_Labor Hours per Qty."; REC."NS_Labor Hours per Qty.")
                {
                    ApplicationArea = All;
                    Caption = 'Labor Hours per Qty.';
                    Editable = GetLinkEditable;
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                //PRJ-568.AS.1.0 - END
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity (Base)';
                    Visible = false;
                }
                //PRJ-492.N.S.1.0 STa
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                //JD-54.AM.1.0 Start
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost (LCY)';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Direct Unit Cost (LCY)';
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost (LCY)';
                    Visible = false;
                }
                field("Skill Class"; Rec."NS_Skill Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Skill Class';
                    Visible = false; //PRJ-492.AS.1.0 //doubt
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Type Code';
                    Visible = false;//PRJ-492.RS.1.0 21May2021 
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                    Visible = false; //PRJ-492.AS.1.0 //doubt
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price (LCY)';
                    Visible = false;
                }
                field("Rate Type"; Rec."NS_Rate Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type';
                    Visible = false;
                }
                field("Rate Type Value"; Rec."NS_Rate Type Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Rate Type Value';
                    Visible = false;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Amount (LCY)';
                    Visible = false;
                }
                field("Not To Exceed"; Rec."NS_Not To Exceed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Not To Exceed';
                    Visible = false;
                }
                //PRJ-492.N.S.1.0 Start
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Gen. Bus. Posting Group';
                    //Visible = false;//PRJ-492.RS.1.0 21May2021//PRJ-761.AS.1.0 Commented
                    Visible = true;//PRJ-761.AS.1.0 Added
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the Gen. Prod. Posting Group';
                    //Visible = false;//PRJ-492.RS.1.0 21May2021//PRJ-761.AS.1.0 Commented
                    Visible = true;//PRJ-761.AS.1.0 Added
                }
                //PRJ-492.N.S.1.0 End
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount %';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line Discount Amount';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price (LCY)';
                    Visible = false;
                }
                field("Ledger Entry Type"; Rec."Ledger Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ledger Entry Type';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Ledger Entry No."; Rec."Ledger Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ledger Entry No.';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the System-Created Entry';
                    Visible = false;
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Invoiced Cost Amount (LCY)';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Serial No.';
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Lot No.';
                    Visible = false;
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Contract Entry No.';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                    Visible = false; //PRJ-492.AS.1.0 //DOUBT
                }
                field("Usage Link"; Rec."Usage Link")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage Link';
                    Visible = false;//PRJ-492.RS.1.0 21May2021
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Edit Planning Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Edit Planning Lines';
                    Ellipsis = true;
                    Image = EditLines;
                    ToolTip = 'Edit job planning lines';
                    Visible = false;//PRJ-770.RS.1.0 12July2021 Commented

                    trigger OnAction();
                    var
                        JT: Record "Job Task";
                    begin
                        TESTFIELD("Job No.");
                        TESTFIELD("Job Task No.");
                        JT.GET("Job No.", "Job Task No.");
                        JT.FILTERGROUP := 2;
                        JT.SETRANGE("Job No.", "Job No.");
                        JT.SETRANGE("Job Task Type", JT."Job Task Type"::Posting);
                        JT.FILTERGROUP := 0;
                        PAGE.RUNMODAL(PAGE::"Job Planning Lines", JT);
                    end;
                }
                action("Create &Sales Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create sales invoice';

                    trigger OnAction();
                    begin
                        NS_CreateSalesInvoice(false);
                    end;
                }
                action("Create Sales &Credit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Create Sales &Credit Memo';
                    Ellipsis = true;
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create sales and credit memo.';

                    trigger OnAction();
                    begin
                        NS_CreateSalesInvoice(true);
                    end;
                }
                //JD-54.AM.1.0 Start

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
                //JD-54.AM.1.0 End

                action("Show Sales Document")
                {
                    ApplicationArea = All;
                    Caption = 'Show Sales Document';
                    Ellipsis = true;
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Show sales document';

                    trigger OnAction();
                    var
                        Sub: Codeunit "NS_Event Subscr. Codeunits";

                    begin
                        Sub.NS_C1002NS_GetSalesInvoice(Rec);
                    end;
                }
            }
            group("Original Job Planning")
            {
                Caption = 'Original Job Planning';
                action("Lock Planning Lines to Original")
                {
                    ApplicationArea = All;
                    Caption = 'Lock Planning Lines to Original';
                    Image = CopyBudget;
                    ToolTip = 'Lock job planning lines';

                    trigger OnAction();
                    begin
                        Job.NS_CopyPlanningToLocked("Job No.");
                    end;
                }
                action("View Locked Planning Lines")
                {
                    ApplicationArea = All;
                    Caption = 'View Locked Planning Lines';
                    Image = CopyBudget;
                    RunObject = Page "NS_Job Planning List (Locked)";
                    RunPageLink = "NS_Job No." = FIELD("Job No.");
                    ToolTip = 'View locked job planning lines';
                }
            }
            group(Jobs)
            {
                Caption = 'Jobs';
                action(NS_GetJobSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Segments';

                    ToolTip = 'Get Job Segments';
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
                action(GetJobTaskSegments)
                {
                    ApplicationArea = All;
                    Caption = 'Get Job Task Segments';
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Get job task segments.';

                    trigger OnAction();
                    var
                        JobSegment: Page "NS_Job Takeoff Worksheet";
                    begin
                        JobSegment.NS_InitPage("Job No.", "Job Task No.");
                        JobSegment.RUNMODAL;
                    end;
                }
            }
        }
    }
    //JD-54.AM.1.0 Start
    trigger OnModifyRecord(): Boolean
    var
    begin
        if Rec."NS_DFR Locked" then
            Error('You cannot Modify Locked Job Planning line');

    end;
    //JD-54.AM.1.0 End

    //PRJ-568.AS.1.0 - Start
    trigger OnAfterGetRecord()
    var
    begin
        SetLineJobDescription();//PRJ-761.AS.1.0
        if Rec.Type <> Rec.Type::Item then
            GetLinkEditable := false;

        if Rec.Type = Rec.Type::Item then
            GetLinkEditable := true;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        if Rec.Type <> Rec.Type::Item then
            GetLinkEditable := false;

        if Rec.Type = Rec.Type::Item then
            GetLinkEditable := true;
    end;
    //PRJ-568.AS.1.0 - End

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SetLineJobDescription();//PRJ-761.AS.1.0
        "NS_Quote No." := "Job No.";
    end;

    trigger OnOpenPage();
    begin
        GetLinkEditable := true;//PRJ-568.AS.1.0
        if ActiveField = 1 then;
        if ActiveField = 2 then;
        if ActiveField = 3 then;
        if ActiveField = 4 then;
        if ShowJobNo > '' then begin
            SETFILTER("Job No.", ShowJobNo);
            SETFILTER("Line Type", '%1|Both Schedule and Contract', ShowLineType);
        end;

        //PRJ-325.AS.1.0 16JULY2020 - start
        JobNo := JobNoSentIn;
        if JobTable.get(JobNo) then
            JobDescription := JobTable.Description
        //PRJ-325.AS.1.0 16JULY2020 - end
    end;

    var
        Job: Record Job;
        GetLinkEditable: Boolean; //PRJ-568.AS.1.0
        JobTable: Record job;//PRJ-325.AS.1.0 16JULY2020
        //JobCreateInvoice: Codeunit "Job Create-Invoice";
        ActiveField: Option " ",Cost,CostLCY,PriceLCY,Price;
        ShowJobNo: Code[20];
        ShowLineType: Option;
        JobDescription: Text[100];//PRJ-301.MS.1.0
        JobNo: Code[20];
        StartDate: Date;//JD-54.AM.1.0 
        EndDate: Date;//JD-54.AM.1.0
        DFRBool: Boolean;//JD-54.AM.1.0
        EditDFR: Boolean;
        JobNoSentIn: Code[20];//PRJ-325.AS.1.0 16JULY2020
        NS_LineJobDescription: Text[100];//PRJ-492.RS.1.0 21May2021
        NS_Job: Record Job;//PRJ-492.RS.1.0 21May2021

    procedure NS_CreateSalesInvoice(CrMemo: Boolean);
    var
        JobPlanningLine: Record "Job Planning Line";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        TESTFIELD("Line No.");
        JobPlanningLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(JobPlanningLine);
        JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)
    end;

    procedure NS_SetActiveField(ActiveField2: Integer);
    begin
        ActiveField := ActiveField2;
    end;

    procedure NS_SetFilters(JobNo: Code[20]; LineType: Option);
    begin
        ShowJobNo := JobNo;
        ShowLineType := LineType;
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        SETRANGE("Job No.", JobNo);
        CurrPage.UPDATE;
    end;
    //PRJ-325.AS.1.0 16JULY2020 - start
    procedure NS_Set(JobNoIn: Code[20]);
    begin
        JobNoSentIn := JobNoIn;
    end;
    //PRJ-325.AS.1.0 16JULY2020 - end
    //PRJ-492.RS.1.0 21May2021 start
    local procedure SetLineJobDescription();
    begin
        //ProjectPro - start
        NS_LineJobDescription := '';
        if NS_Job.GET("Job No.") then
            NS_LineJobDescription := NS_Job.Description;
        //ProjectPro - end
    end;
    //PRJ-492.RS.1.0 21May2021 end
}

