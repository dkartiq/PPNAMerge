page 14021427 "NS_Job Material Planning Wksht"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-134.VT.1.0 Added code
    //PRJ-316.AS.1.0 30JUNE2020 Commented code & Added code
    //PPAL-18.AS.1.0 Code commented for Import/Export tool promoted category
    //PPAL-43.AS.1.0 13AUG20 Changed caption from order code to job task code
    //PRJ-256.MS.1.0 added permission

    //PRJ-372.MS.1.0 changes caption and added fields 
    //PPAL-110.AS.1.0 10 SEPT2020 Hide Purchase Resource New Button
    //TM-10.AM.1.0 | Added Field.
    //PRJ-492.RS.1.0 10May2021 | Hide/Unhide Fields 
    //PRJ-659.RS.1.0�22June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    //PRJ-895.GK.1.0 27Aug2021 | Add two fields Use Tax Sku & Use Tax Amount
    //PRJ-999.JS.1.0 09Nov2021 | Add fields and Action
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page Help link
    //PRJ-1117.JS.1.0 06Dec2022 | Add fields
    //PRJ-1131.RM.1.0 10Jan2022 | Removed with statement
    //PRJ-1171.JS.1.0 08FEB2022 | Make item Variant editable
    //PRJ-1380.NK.1.0 16May2022 | Added new fields
    //PRJ-1479.NK.1.0 29Jun2022 | Added Code
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
    //PE-25.NK.1.0  06jan2023   | added two digit decimal places at unit cost field.
    //PRJCTPR-30.RM.1.0 20Jan2023 | Made action button invisible
    PageType = Worksheet;
    Caption = 'Job Material Planning Wksht';
    Permissions = TableData "NS_Export/Import Excel Header" = rimd,
                  TableData "NS_Export / Import Excel Line" = rimd,
                  tabledata "Purch. Rcpt. Line" = rimd, //PRJ-256.MS.1.0
                  tabledata "User Setup" = rimd; //PRJCTPR-290.AT.1.0
    RefreshOnActivate = true;
    SourceTable = "NS_Job Material Planning";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTableView = sorting("NS_Worksheet Job No.", "NS_Order Code", "NS_Job Plannine Line No.", NS_Level)
    ORDER(Ascending);//PRJ-563.AS.1.0 24MAY2020
    ContextSensitiveHelpPage = 'user-guide/jmp-process/job-material-planning/'; //PRJ-1085.RM.1.0 16Dec2021

    layout
    {
        area(content)
        {
            field("Worksheet Job No."; Rec."NS_Worksheet Job No.")
            {
                ApplicationArea = All;
                Lookup = true;
                LookupPageID = "Job List";
                TableRelation = Job."No.";
                ToolTip = 'Specifies the Worksheet Job No.';
            }
            repeater(Group)
            {
                field("Job No."; Rec."NS_Worksheet Job No.")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Job No.'; //PRJ-1579.RM.1.0 commented
                    ToolTip = 'Specifies the Job No.'; //PRJ-1579.RM.1.0
                    Caption = 'Job No.';
                }
                //PRJ-492.N.S.1.0 Start
                field("Order Code"; Rec."NS_Order Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order Code';
                    Caption = 'Job Task Code';//PPAL-43.AS.1.0 13AUG20 
                }
                //PRJ-492.N.S.1.0 End
                field("Segment Code"; Rec."NS_Segment Code")    //PRJ-1131.RM.1.0
                {
                    ApplicationArea = all;
                    Description = 'TM-10.AM.1.0';
                    // ToolTip = 'select the Segment'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Select the Segment'; //PRJ-1579.RM.2.0
                    //Visible = false; //PRJ-492.AS.1.0  //Doubt //PRJ-492.RS.1.0 25May2021  Comment
                    Visible = true;//PRJ-492.RS.1.0 25May2021  
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Document No.';
                }
                field("Date Ordered By"; Rec."NS_Date Ordered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date Ordered By';
                }
                field("Date Required"; Rec."NS_Date Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date Required';
                }
                field("NS_Assembly Item on Job."; Rec."NS_Assembly Item on Job.")//PRJ-563     //PRJ-1131.RM.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                // field("NS_Item Name"; "NS_Item Name")//PRJ-563//PRJ-838 COMMENT
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Assembly Item on Job.';
                //     Visible = false;//PRJ-492.RS.1.0 10May2021
                // }
                field("NS_Item Name New"; REC."NS_Item Name New")//PRJ-563//PRJ-838 ADD
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                field("NS_Quantity Per"; Rec."NS_Quantity Per")//PRJ-563     //PRJ-1131.RM.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                //PRJ-492.N.S.1.0 Start
                // field("Order Code"; Rec."NS_Order Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Order Code';
                //     Caption = 'Job Task Code';//PPAL-43.AS.1.0 13AUG20 
                // }
                //PRJ-492.N.S.1.0 End
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Part No."; Rec."NS_Part No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Part No.';

                    trigger OnValidate();
                    begin
                        Rec.NS_ItemAvail;    //PRJ-1131.RM.1.0
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-1365.AS.1.0 START
                field("NS_Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Unit of Measure Code';
                }
                //PRJ-1365.AS.1.0 END

                //PRJ-1365.AS.2.0 START
                field("NS_Base UOM"; Rec."NS_Base UOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Base UOM';
                }
                field("NS_Base UOM (Qty)"; Rec."NS_Base UOM (Qty)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Base UOM (Qty)';
                }
                //PRJ-1365.AS.2.0 END
                field(Details; Rec.NS_Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Details';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                field(Manufacturer; Rec.NS_Manufacturer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Manufacturer';
                    Visible = false; //PRJ-492.AS.1.0 //DOubt
                }
                field(Vendor; Rec.NS_Vendor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                //PRJ-492.N.S.1.0 Start
                field("Inv. Avail"; Rec."NS_Inv. Avail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Inv. Avail';
                    //Visible = false; //PRJ-492.AS.1.0 //Doubt//PRJ-492.RS.1.0 10May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 10May2021

                }
                //PRJ-492.N.S.1.0 End 
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                    DecimalPlaces = 2 : 2;  //PE-25.NK.1.0  06jan2023
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Inv. Qty"; Rec."NS_Inv. Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Inv. Qty (Job Jrnl)';
                    // ToolTip = 'Specifies the Quantity of inventory in Job Journal'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    // ToolTip = 'Inv. Qty (Job Jrnl)'; //PRJ-1579.RM.1.0
                    ToolTip = 'Specifies the Quantity of Inventory in Job Journal'; //PRJ-1579.RM.2.0

                    trigger OnAssistEdit();
                    var
                        JobJnlTbl: Record "Job Journal Line";
                        JobJnlPge: Page "Job Journal";
                        lJobJnlBatch: Record "Job Journal Batch";
                        JobJnlMgt: Codeunit JobJnlManagement;
                    begin
                        lJobJnlBatch.RESET;
                        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
                        if lJobJnlBatch.GET(JOBLbl, CopyStr(Rec."NS_Worksheet Job No.", 1, 10)) then//PRJ-134 VIKAS     //PRJ-1131.RM.1.0
                            JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch);
                    end;
                }
                field("Inventory Qty. Staged"; Rec."NS_Inventory Qty. Staged")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Inventory Qty. Staged';
                }
                field("PO Qty"; Rec."NS_PO Qty")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the PO Qty';
                }
                field("PO Qty Rcd"; Rec."NS_PO Qty Rcd")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Qty Rcd';
                }
                field("PO Qty Staged"; Rec."NS_PO Qty Staged")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Qty Staged';
                }
                field("Quantity Invoiced"; Rec."NS_Quantity Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity Invoiced';
                    Caption = 'PO Qty. Invoiced'; //PRJ-372
                }
                field("PO Return Qty"; Rec."NS_PO Return Qty")
                {
                    ApplicationArea = All;
                    Caption = 'PO Return Qty.';
                    Description = 'PRJ-372.MS.1.0';
                    Editable = false;
                    // ToolTip = 'Specifies the returned qty of PO'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Specifies the returned Qty. of PO'; //PRJ-1579.RM.2.0
                }
                field("PO Return Qty. Shipped"; Rec."NS_PO Return Qty. Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'PO Return Qty. Shipped';
                    Description = 'PRJ-372.MS.1.0';
                    Editable = false;
                    // ToolTip = 'Specifies the returned qty Shipped'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Specifies the returned Qty. Shipped'; //PRJ-1579.RM.2.0
                }
                field("PO Return Qty. Invoiced"; Rec."NS_PO Return Qty. Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'PO Return Qty. Invoiced';
                    Description = 'PRJ-372.MS.1.0';
                    Editable = false;
                    // ToolTip = 'Specifies the returned qty Invoiced'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Specifies the returned Qty. Invoiced'; //PRJ-1579.RM.2.0
                }

                field("Job Site Vndr Qty"; Rec."NS_Job Site Vndr Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Site Vndr Qty';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                field("Job Site From Inv."; Rec."NS_Job Site From Inv.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Site From Inv.';
                    Visible = false;//PRJ-492.RS.1.0 10May2021
                }
                field("Bal. Req"; Rec."NS_Bal. Req")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bal. Req';
                }
                //PRJ-492.N.S.1.0 Start
                // field("Inv. Avail"; Rec."NS_Inv. Avail")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Inv. Avail';
                //     Visible = false; //PRJ-492.AS.1.0
                // }
                //PRJ-492.N.S.1.0 End 
                field("NS_Main Item"; Rec."NS_Main Item")//PRJ-563.AS.1.0 24MAY2020
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Main Item';
                    Visible = false;//PRJ-1224.AS.2.0 Added Visiblity
                }
                field(NS_Level; Rec.NS_Level)//PRJ-563.AS.1.0 24MAY2020
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Level';
                }
                field("NS_Item Type"; Rec."NS_Item Type")//PRJ-563.AS.1.0 24MAY2020
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Type';
                }
                //PRJ-895.GK.1.0 27Aug2021 start
                field("NS_Use Tax SKU"; Rec."NS_Use Tax SKU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax Sku';
                }
                //PRJ-929.GK.5.0 22Dec2021 start - Uncomment & Set visible false
                //PRJ-929.GK.3.0 23NOV2021 start-comment
                field("NS_Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usee Tax Amount';
                    Visible = false;
                    Editable = false;
                }
                //PRJ-929.GK.3.0 23NOV2021 end
                //PRJ-895.GK.1.0 27Aug2021 end
                //PRJ-929.GK.5.0 22Dec2021 end
                //PRJ-999.JS.1.0 09Nov2021 Start
                field("NS_Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NS_Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                    Editable = false;
                }

                //PRJ-999.JS.1.0 09Nov2021 End
                //PRJ-1117.JS.1.0 06Dec2022-Start
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ToolTip = 'Specifies the value of the Item Variant Code';
                    ApplicationArea = All;
                    //Editable = false;   //PRJ-1171.JS.1.0 08FEB2022
                }
                //PRJ-1117.JS.1.0 06Dec2022-end 
                //PRJ-1380.NK.1.0 16May2022 Start
                field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
                {
                    ApplicationArea = all;
                    // ToolTip = 'Job Purchaser'; //PRJ-1579.RM.1.0  commented
                    ToolTip = 'Shows the Job Purchase from the Job card'; //PRJ-1579.RM.1.0 
                    Caption = 'Job Purchaser';
                    Editable = false;
                    Description = 'PRJ-1380.NK.1.0';
                }
                field("NS_Job Manager"; Rec."NS_Job Manager")
                {
                    ApplicationArea = all;
                    // ToolTip = 'Job Manager'; //PRJ-1579.RM.1.0  commented
                    // ToolTip = 'Specifies the Job manager'; //PRJ-1579.RM.1.0  //PRJ-1579.RM.2.0  commented
                    ToolTip = 'Specifies the Job Manager'; //PRJ-1579.RM.2.0  
                    Caption = 'Job Manager';
                    Description = 'PRJ-1380.NK.1.0';
                    Editable = false;
                }
                //PRJ-1380.NK.1.0 16May2022 End 

                //PRJCTPR-93.PS.1.0 10April2023 Start
                field("NS_JMP Batch Name"; Rec."NS_JMP Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'JMB batch Name';
                    Caption = 'Batch Name';
                    trigger OnValidate()
                    var
                        NS_UserSetup: Record "User Setup";
                    begin
                        if NS_UserSetup.Get(UserId) then;
                        Rec."NS_JMP Batch Name" := NS_UserSetup."NS_JMP Batch Name";
                        Rec.Modify();
                    end;
                }
                //PRJCTPR-93.PS.1.0 10April2023 End            
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
                action("NS_Get Actual Job Material")
                {
                    ApplicationArea = All;
                    Caption = 'Get Actual Job Material';

                    ToolTip = 'Get Actual Job Material';
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.NS_GetandLoadActuals(Rec."NS_Worksheet Job No.", '');    //PRJ-1131.RM.1.0
                    end;
                }
                action(NS_PrintJobMaterialWorksheet)
                {
                    ApplicationArea = All;
                    Caption = 'Print Job Material Worksheet';

                    ToolTip = 'Print Job Material Worksheet';
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "NS_Job Material PlanningReport";

                    trigger OnAction();
                    var
                        JobMatlPlanWkshtRpt: Report "NS_Job Material PlanningReport";
                        JobMatlPlanWksht: Record "NS_Job Material Planning";
                        JobMngr: Code[20];
                        Resource: Record Resource;
                    begin
                        Resource.RESET;
                        Resource.SETRANGE(Name, Rec."NS_Job Manager");//PRJ-1131.RM.1.0
                        if Resource.FINDFIRST then
                            JobMngr := Resource."No.";
                        // JobMatlPlanWkshtRpt.InitVar("Worksheet Job No.", "Job Manager");//PRJ-316.AS.1.0 30JUNE2020 Commented code
                        // JobMatlPlanWkshtRpt.RUNMODAL;//PRJ-316.AS.1.0 30JUNE2020 commented code
                        //PRJ-316.AS.1.0 30JUNE2020 - START
                        JobMatlPlanWksht.Reset;
                        JobMatlPlanWksht.SetRange("NS_Worksheet Job No.", Rec."NS_Worksheet Job No.");
                        REPORT.RUNMODAL(14021370, true, false, JobMatlPlanWksht);
                        //PRJ-316.AS.1.0 30JUNE2020 - END
                    end;
                }
                action("NS_Requisition Worksheet by Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Worksheet by Doc No.';

                    ToolTip = 'Requisition Worksheet by Doc No.';
                    Image = Worksheet;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    var
                        NS_UserSetup: Record "User Setup";  //PRJCTPR-93.NK.1.0 17April2023
                    begin
                    //PRJCTPR-93.NC.1.0 03May2023 start  
                        if NS_UserSetup.Get(UserId) then;
                        if NS_UserSetup."NS_JMP Batch Name" <> '' then begin
                            if Rec."NS_JMP Batch Name" <> NS_UserSetup."NS_JMP Batch Name" then
                                Error('JMP batch Name should be same as per user setup JMP batch Name');
                        end;
                        NS_UserSetup."NS_Req JMP Doc. No." := Rec."NS_Document No.";
                        NS_UserSetup.MODIFY;
                        //PRJCTPR-93.NC.1.0 17April2023 end
                        //PRJ-1479.NK.1.0 29Jun2022 Start
                        //JobsSetup.GET; //PRJCTPR-93.NC.1.0 03May2023 block
                        //JobsSetup."NS_Req JMP Doc. No." := Rec."NS_Document No.";//PRJ-1131.RM.1.0 //PRJCTPR-93.NC.1.0 03May2023 Block
                        //JobsSetup.MODIFY; //PRJCTPR-93.NC.1.0 03May2023 Block
                        // JobMaterialPlan.Reset();
                        // JobMaterialPlan.SetFilter("NS_Req JMP Doc. No.", '<>%1', '');
                        // if JobMaterialPlan.FindFirst() then
                        //     JobMaterialPlan.ModifyAll("NS_Req JMP Doc. No.", '');
                        // Rec."NS_Req JMP Doc. No." := Rec."NS_Document No.";
                        // Rec.Modify();
                        //PRJ-1479.NK.1.0 29Jun2022 End
                        ReqWksht.RUN;
                    end;
                }
                action("NS_Req Wksht")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Worksheet';

                    ToolTip = 'Requisition Worksheet';
                    Image = PlanningWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        NSUserSetup: Record "User Setup";  //PRJCTPR-219.PS.1.0 02Nov2023
                    begin
                        //PRJ-1479.NK.1.0 29Jun2022 Start
                        // JobsSetup.GET;
                        // JobsSetup."NS_Req JMP Doc. No." := '';
                        // JobsSetup.MODIFY();
                        JobMaterialPlan.Reset();
                        JobMaterialPlan.SetFilter("NS_Req JMP Doc. No.", '<>%1', '');
                        if JobMaterialPlan.FindFirst() then
                            JobMaterialPlan.ModifyAll("NS_Req JMP Doc. No.", '');
                        //PRJ-1479.NK.1.0 29Jun2022 End
                        //PRJCTPR-219.PS.1.0 02Nov2023 Start
                        if NSUserSetup.Get(UserId) then;
                        NSUserSetup."NS_Req JMP Doc. No." := '';
                        NSUserSetup.MODIFY;
                        //PRJCTPR-219.PS.1.0 02Nov2023 End

                        ReqWksht.RUN();
                    end;
                }
                action("NS_Purchase Resources")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase Resources';
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Purchase Resources';//PRJ-659.RS.1.0�22June21 New Added

                    trigger OnAction();
                    var
                        PurchaseResourceList: Page "NS_JMP Purch. Res. G/L";
                    begin
                        PurchaseResourceList.NS_InitVar(Rec."NS_Worksheet Job No.", LineType::Resource);//PRJ-1131.RM.1.0
                        PurchaseResourceList.RUN;
                    end;
                }
                action("NS_Purchase Resources New")
                {
                    ApplicationArea = All;
                    Image = Resource;
                    Promoted = true;
                    ToolTip = 'Purchase Resources New';
                    Caption = 'Purchase Resources New';//PRJ-659.RS.1.0�22June21 New Added
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "NS_Job MaterialPlanningJournal";
                    RunPageLink = "NS_Job No." = FIELD("NS_Worksheet Job No.");
                    Visible = false;//PPAL-110.AS.1.0 10 SEPT2020
                    trigger OnAction();
                    var
                        PurchaseResourceList: Page "NS_JMP Purch. Res. G/L";
                    begin
                    end;
                }
                action("NS_Purchase G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'Purchase G/L';
                    Caption = 'Purchase G/L'; //PRJ-659.RS.1.0�22June21 New Added
                    // Enabled = false; //PRJCTPR-309.HS.1.0 26Feb2024 Commented 
                    Image = GL;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    // Visible = false; //PRJCTPR-309.HS.1.0 26Feb2024 Commented 

                    trigger OnAction();
                    var
                        PurchaseResourceList: Page "NS_JMP Purch. Res. G/L";
                    begin
                        PurchaseResourceList.NS_InitVar(Rec."NS_Worksheet Job No.", LineType::"G/L Account");//PRJ-1131.RM.1.0
                        PurchaseResourceList.RUN;
                    end;
                }
                action(NS_CopyPlanningLines)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Job Planning Lines';

                    ToolTip = 'Copy Job Planning Lines';
                    Image = GetLines;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        Rec.NS_CopyPlanningLines(Rec."NS_Worksheet Job No.", '', false);//PRJ-1131.RM.1.0
                    end;
                }
                action(NS_UpdatePlanningLines)
                {
                    ApplicationArea = All;
                    Caption = 'Update Job Planning Lines';

                    ToolTip = 'Update Job Planning Lines';
                    Image = GetLines;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        Message('You have changed the Product ID for Item/s having associated Purchase Document/s. Changes for such item will not be pulled on this window to avoid mismatch in Purchase document details.');//PRJCTPR-142.PS.1.0 26Jun2023
                        //Rec.NS_CopyPlanningLines(Rec."NS_Worksheet Job No.", '', true);//PRJ-1224.AS.1.0 Commented old code
                        Rec.NS_NewCopyPlanningLines(Rec."NS_Worksheet Job No.", '', true);    //PRJ-1224.AS.1.0 Added code
                        Rec.NS_OnAfterUpdateItemsPlanningLineinJMPs(Rec."NS_Worksheet Job No.", '');//PRJ-1224.AS.1.0 Added code
                        Rec.NS_OnAfterUpdateResourcePlanningLineinJMPs(Rec."NS_Worksheet Job No.", '');//PRJ-1224.AS.1.0 Added code
                    end;
                }
                action(NS_JobJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Job Journal';

                    ToolTip = 'Job Journal';
                    Image = JobJournal;
                    Promoted = true;

                    trigger OnAction();
                    var
                        JobJournal: Record "Job Journal Line";
                        JobJnlPg: Page "Job Journal";
                        lJMP: Record "NS_Job Material Planning";
                        LoadJobJnl: Report "NS_Load Job Jnl from JMP";
                        lJobJnlBatch: Record "Job Journal Batch";
                        JobJnlMgt: Codeunit JobJnlManagement;
                    begin
                        COMMIT();
                        lJMP.RESET();
                        lJMP.SETRANGE("NS_Worksheet Job No.", Rec."NS_Worksheet Job No.");//PRJ-1131.RM.1.0
                        lJMP.SETRANGE("NS_Document No.", Rec."NS_Document No.");//PRJ-1131.RM.1.0
                        lJMP.SETFILTER("NS_Date Ordered By", '<=%1', WORKDATE);
                        if lJMP.FINDFIRST then;

                        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then begin //PRJ-134 VIKAS
                        if lJobJnlBatch.GET(JOBLbl, CopyStr(Rec."NS_Worksheet Job No.", 1, 10)) then begin //PRJ-134 VIKAS   //PRJ-1131.RM.1.0
                            if not CONFIRM(Text0001Lbl, false, Rec."NS_Worksheet Job No.") then//PRJ-1131.RM.1.0
                                JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch)
                            else
                                AddJnlLines(Rec."NS_Worksheet Job No.", Rec."NS_Document No.", lJMP."NS_Date Ordered By");//PRJ-1131.RM.1.0
                        end else begin
                            LoadJobJnl.InitVar(Rec."NS_Worksheet Job No.", Rec."NS_Document No.", lJMP."NS_Date Ordered By", false);//PRJ-1131.RM.1.0
                            LoadJobJnl.RUNMODAL();
                            COMMIT;
                            lJobJnlBatch.RESET();
                            //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
                            if lJobJnlBatch.GET(JOBLbl, CopyStr(Rec."NS_Worksheet Job No.", 1, 10)) then //PRJ-134 VIKAS //PRJ-1131.RM.1.0
                                JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch);
                        end;
                    end;
                }
                //PE-178.JS.1.0 16NOV2023 - Start
                action(NSProjectProAI)
                {
                    ApplicationArea = All;
                    Caption = 'ProjectPro AI';
                    Image = Info;
                    Promoted = true;
                    PromotedCategory = Process;
                    //InFooterBar = true;
                    trigger OnAction()
                    begin
                        Hyperlink('https://webchat.botframework.com/embed/ChatBotAIUS-bot?s=AsNjejE0XXs.6dxHmclWNW1hYkEGoPRwb_tzwWFLSo4r2tDOwbZRxmc');
                    end;
                }
                //PE-178.JS.1.0 16NOV2023 - end                                    
                action("NS_Delivery Ticket")
                {
                    ApplicationArea = All;
                    Image = Delivery;
                    ToolTip = 'Delivery Ticket';
                    Caption = 'Delivery Ticket';//PRJ-659.RS.1.0�22June21 New Added
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        lJMP: Record "NS_Job Material Planning";
                        DeliveryTicketPg: Page "NS_JMP Delivery Ticket Wksht";
                    begin
                        NS_UpdateDelivery(Rec."NS_Worksheet Job No.");//PRJ-1131.RM.1.0
                        lJMP.RESET();
                        lJMP.SETRANGE("NS_Worksheet Job No.", Rec."NS_Worksheet Job No.");//PRJ-1131.RM.1.0
                        lJMP.SETFILTER("NS_Total Quantity Staged", '>%1', 0);
                        DeliveryTicketPg.SETTABLEVIEW(lJMP);
                        DeliveryTicketPg.RUNMODAL();
                        CurrPage.UPDATE();
                    end;
                }

                //PRJ-1538.DK.1.0 27July2022 - start - Only for CTSI JMP Performace
                action(NS_CopyPlanningLinesJMPPerformace)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Job Planning Lines JMP';
                    Visible = false; //PRJCTPR-30.RM.1.0 20Jan2023
                    ToolTip = 'Copy Job Planning Lines JMP';
                    Image = GetLines;


                    trigger OnAction();
                    var
                        NSAllSubSctibe: Codeunit NS_AllSubscriber;
                    begin
                        NSAllSubSctibe.NS_CopyPlanningLines(Rec, false);
                    end;
                }
                //PRJ-1538.DK.1.0 27July2022 - Only for CTSI JMP Performace
            }
            //PRJ-999.JS.1.0  09Nov2021 Start
            action(Dimensions)
            {
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View Dimensions';

                trigger OnAction();
                begin
                    Rec.NS_ShowDocDim();
                    CurrPage.SAVERECORD();
                end;
            }
            //PRJ-999.JS.1.0  09Nov2021 end
            group(Utilities)
            {
                Caption = 'Utilities';
                action(NS_ImportBOM)
                {
                    ApplicationArea = All;
                    Caption = 'Import/Export Tool';

                    ToolTip = 'Import/Export Tool';
                    Image = ImportExcel;
                    Promoted = true;
                    // PromotedCategory = Category4;//PPAL-18.AS.1.0 Code commented
                    PromotedIsBig = true;
                    Visible = false;//PRJ-473.AS.1.0 20JAN2021

                    trigger OnAction();
                    var
                        ImportHdrPg: Page "NS_Export / Import Header";
                    begin
                        ImportHdrPg.NS_SetJobNo(Rec."NS_Worksheet Job No.");//PRJ-1131.RM.1.0
                        ImportHdrPg.RUNMODAL;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        Rec.VALIDATE(NS_Quantity);//PRJ-1131.RM.1.0
        Rec.NS_ItemAvail();//PRJ-1131.RM.1.0
    end;

    trigger OnAfterGetRecord();
    begin
        //PRJCTPR-368.PS.1.0 Start
        Rec.CALCFIELDS("NS_Inv. Qty", "NS_PO Qty", "NS_Job Site", "NS_PO Qty Rcd", "NS_Quantity Invoiced", "NS_Posted Quantity", "NS_PO Return Qty. Shipped", "NS_PO Return Qty");
        Rec."NS_Bal. Req" := Rec.NS_Quantity - (Rec."NS_Inv. Qty" + Rec."NS_Job Site From Inv.") - Rec."NS_PO Qty" - Rec."NS_PO Qty Rcd" - Rec."NS_Inventory Qty. Staged" - Rec."NS_Job Site Vndr Qty" + Rec."NS_PO Return Qty. Shipped" + Rec."NS_PO Return Qty";
        if Rec."NS_Bal. Req" < 0 then
            Rec."NS_Bal. Req" := 0;
        Rec.Modify();
        //PRJCTPR-368.PS.1.0 End
        Rec.VALIDATE(NS_Quantity);//PRJ-1131.RM.1.0
        Rec.NS_ItemAvail();//PRJ-1131.RM.1.0
    end;

    var
        //"`": Integer;
        JobsSetup: Record "Jobs Setup";
        ReqWksht: Page "Req. Worksheet";
        JobMaterialPlan: Record "NS_Job Material Planning"; //PRJ-1479.NK.1.0 29Jun2022

        Text0001Lbl: Label 'Job %1 Journal Lines Already Exist.\ Do you want to add to them?', Comment = '%1=PP_Worksheet Job No.';
        //ReqLine: Record "Requisition Line";
        LineType: Option Resource,Item,"G/L Account",Text,"Resource (Group)",Template;
        JOBLbl: Label 'JOB';

    procedure AddJnlLines(JobNo: Code[20]; DocNo: Code[20]; OrderDate: Date);
    var
        lJMP: Record "NS_Job Material Planning";
        LoadJobJnl: Report "NS_Load Job Jnl from JMP";
        lJobJnlBatch: Record "Job Journal Batch";
        JobJnlMgt: Codeunit JobJnlManagement;
    begin
        lJMP.RESET();
        lJMP.SETRANGE("NS_Worksheet Job No.", Rec."NS_Worksheet Job No.");//PRJ-1131.RM.1.0
        lJMP.SETRANGE("NS_Document No.", Rec."NS_Document No.");//PRJ-1131.RM.1.0
        lJMP.SETFILTER("NS_Date Ordered By", '<=%1', WORKDATE);
        if lJMP.FINDLAST() then;

        LoadJobJnl.InitVar(Rec."NS_Worksheet Job No.", Rec."NS_Document No.", lJMP."NS_Date Ordered By", true);//PRJ-1131.RM.1.0
        LoadJobJnl.RUNMODAL();
        COMMIT();
        lJobJnlBatch.RESET();
        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
        if lJobJnlBatch.GET(JOBLbl, CopyStr(Rec."NS_Worksheet Job No.", 1, 10)) then //PRJ-134 VIKAS//PRJ-1131.RM.1.0
            JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch);
    end;

    procedure NS_UpdateDelivery(JobNo: Code[20]);
    var
        JobMatlPlanDelv: Record "NS_Job Material Planning";
    begin
        JobMatlPlanDelv.SETRANGE("NS_Worksheet Job No.", JobNo);
        if JobMatlPlanDelv.FINDSET() then
            repeat
                if JobMatlPlanDelv."NS_Invt. Qty. to Ship" = 0 then
                    JobMatlPlanDelv."NS_Invt. Qty. to Ship" := JobMatlPlanDelv."NS_Inventory Qty. Staged";
                if JobMatlPlanDelv."NS_PO Qty. to Ship" = 0 then
                    JobMatlPlanDelv."NS_PO Qty. to Ship" := JobMatlPlanDelv."NS_PO Qty Staged";
                JobMatlPlanDelv."NS_Total Qty. Ready to Ship" := JobMatlPlanDelv."NS_Inventory Qty. Staged" + JobMatlPlanDelv."NS_PO Qty Staged";
                JobMatlPlanDelv.MODIFY();
            until JobMatlPlanDelv.NEXT() = 0;
        COMMIT();
    end;
}

