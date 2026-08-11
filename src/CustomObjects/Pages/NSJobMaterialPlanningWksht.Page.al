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
    PageType = Worksheet;
    Caption = 'Job Material Planning Wksht';
    Permissions = TableData "NS_Export/Import Excel Header" = rimd,
                  TableData "NS_Export / Import Excel Line" = rimd,
                  tabledata "Purch. Rcpt. Line" = rimd; //PRJ-256.MS.1.0
    RefreshOnActivate = true;
    SourceTable = "NS_Job Material Planning";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTableView = sorting("NS_Worksheet Job No.", "NS_Order Code", "NS_Job Plannine Line No.", NS_Level)
    ORDER(Ascending);//PRJ-563.AS.1.0 24MAY2020

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
                    ToolTip = 'Job No.';
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
                field("Segment Code"; "NS_Segment Code")
                {
                    ApplicationArea = all;
                    Description = 'TM-10.AM.1.0';
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
                field("NS_Assembly Item on Job."; "NS_Assembly Item on Job.")//PRJ-563
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
                field("NS_Quantity Per"; "NS_Quantity Per")//PRJ-563
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
                        NS_ItemAvail;
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
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

                    ToolTip = 'Inv. Qty (Job Jrnl)';

                    trigger OnAssistEdit();
                    var
                        JobJnlTbl: Record "Job Journal Line";
                        JobJnlPge: Page "Job Journal";
                        lJobJnlBatch: Record "Job Journal Batch";
                        JobJnlMgt: Codeunit JobJnlManagement;
                    begin
                        lJobJnlBatch.RESET;
                        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
                        if lJobJnlBatch.GET(JOBLbl, CopyStr("NS_Worksheet Job No.", 1, 10)) then//PRJ-134 VIKAS
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
                }
                field("PO Return Qty. Shipped"; Rec."NS_PO Return Qty. Shipped")
                {
                    ApplicationArea = All;
                    Caption = 'PO Return Qty. Shipped';
                    Description = 'PRJ-372.MS.1.0';
                    Editable = false;
                }
                field("PO Return Qty. Invoiced"; Rec."NS_PO Return Qty. Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'PO Return Qty. Invoiced';
                    Description = 'PRJ-372.MS.1.0';
                    Editable = false;
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
                field("NS_Use Tax Amount"; Rec."NS_Use Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usee Tax Amount';
                }
                //PRJ-895.GK.1.0 27Aug2021 end
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
                        NS_GetandLoadActuals("NS_Worksheet Job No.", '');
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
                        Resource.SETRANGE(Name, "NS_Job Manager");
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
                    begin
                        JobsSetup.GET;
                        JobsSetup."NS_Req JMP Doc. No." := "NS_Document No.";
                        JobsSetup.MODIFY;
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
                    begin
                        JobsSetup.GET;
                        JobsSetup."NS_Req JMP Doc. No." := '';
                        JobsSetup.MODIFY();
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
                        PurchaseResourceList.NS_InitVar("NS_Worksheet Job No.", LineType::Resource);
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
                    Caption = 'Purchase G/L';//PRJ-659.RS.1.0�22June21 New Added
                    Enabled = false;
                    Image = GL;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction();
                    var
                        PurchaseResourceList: Page "NS_JMP Purch. Res. G/L";
                    begin
                        PurchaseResourceList.NS_InitVar("NS_Worksheet Job No.", LineType::"G/L Account");
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
                        NS_CopyPlanningLines("NS_Worksheet Job No.", '', false);
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
                        NS_CopyPlanningLines("NS_Worksheet Job No.", '', true);
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
                        lJMP.SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
                        lJMP.SETRANGE("NS_Document No.", "NS_Document No.");
                        lJMP.SETFILTER("NS_Date Ordered By", '<=%1', WORKDATE);
                        if lJMP.FINDFIRST then;

                        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then begin //PRJ-134 VIKAS
                        if lJobJnlBatch.GET(JOBLbl, CopyStr("NS_Worksheet Job No.", 1, 10)) then begin //PRJ-134 VIKAS
                            if not CONFIRM(Text0001Lbl, false, "NS_Worksheet Job No.") then
                                JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch)
                            else
                                AddJnlLines("NS_Worksheet Job No.", "NS_Document No.", lJMP."NS_Date Ordered By");
                        end else begin
                            LoadJobJnl.InitVar("NS_Worksheet Job No.", "NS_Document No.", lJMP."NS_Date Ordered By", false);
                            LoadJobJnl.RUNMODAL();
                            COMMIT;
                            lJobJnlBatch.RESET();
                            //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
                            if lJobJnlBatch.GET(JOBLbl, CopyStr("NS_Worksheet Job No.", 1, 10)) then //PRJ-134 VIKAS
                                JobJnlMgt.TemplateSelectionFromBatch(lJobJnlBatch);
                        end;
                    end;
                }
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
                        NS_UpdateDelivery("NS_Worksheet Job No.");
                        lJMP.RESET();
                        lJMP.SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
                        lJMP.SETFILTER("NS_Total Quantity Staged", '>%1', 0);
                        DeliveryTicketPg.SETTABLEVIEW(lJMP);
                        DeliveryTicketPg.RUNMODAL();
                        CurrPage.UPDATE();
                    end;
                }
            }
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
                        ImportHdrPg.NS_SetJobNo("NS_Worksheet Job No.");
                        ImportHdrPg.RUNMODAL;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        VALIDATE(NS_Quantity);
        NS_ItemAvail();
    end;

    trigger OnAfterGetRecord();
    begin
        VALIDATE(NS_Quantity);
        NS_ItemAvail();
    end;

    var
        //"`": Integer;
        JobsSetup: Record "Jobs Setup";
        ReqWksht: Page "Req. Worksheet";


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
        lJMP.SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
        lJMP.SETRANGE("NS_Document No.", "NS_Document No.");
        lJMP.SETFILTER("NS_Date Ordered By", '<=%1', WORKDATE);
        if lJMP.FINDLAST() then;

        LoadJobJnl.InitVar("NS_Worksheet Job No.", "NS_Document No.", lJMP."NS_Date Ordered By", true);
        LoadJobJnl.RUNMODAL();
        COMMIT();
        lJobJnlBatch.RESET();
        //if lJobJnlBatch.GET(JOB, "Worksheet Job No.") then //PRJ-134 VIKAS
        if lJobJnlBatch.GET(JOBLbl, CopyStr("NS_Worksheet Job No.", 1, 10)) then //PRJ-134 VIKAS
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

