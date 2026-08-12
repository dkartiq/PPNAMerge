page 14021204 "NS_Get Job Planning Line"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com

    //PRJ-389.MS.1.0  added new code for PO and SO get Job Plng line
    // +------------------------------------------------------------
    //TM-10.AM.1.0 | Added field.
    //PRJ-866.JS.0.1 17Aug2021 | flow unit price in purchase line
    //FOR-5.NK.1.0 02Mar2023 | Added Code
    Caption = 'Get Job Planning Line';
    DataCaptionFields = "Job No.";
    // >> Upgrade
    DataCaptionExpression = PageCaption;
    // << Upgrade
    Editable = true;
    PageType = Card;
    SourceTable = "Job Planning Line";

    layout
    {
        area(content)
        {
            field(JobNo; JobNo)
            {
                ApplicationArea = All;
                Caption = 'Job No.';
                TableRelation = Job;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    NS_JobNoOnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                Editable = false;
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';
                }
                field("Cost Category"; Rec."NS_Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category';
                }
                field("Revenue Category"; Rec."NS_Revenue Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revenue Category';
                }
                field("Activity Code"; Rec."NS_Activity Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Activity Code';
                }
                field("Process Code"; Rec."NS_Process Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Process Code';
                }
                field("Operation Code"; Rec."NS_Operation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Operation Code';
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
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Variant Code';
                    Visible = false;
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Planning Date';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer Price Group';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost (LCY)';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                    Visible = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Price';
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Price';
                    Visible = false;
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Description = 'TM-10.AM.1.0';
                    ToolTip = 'Segment Code'; //PE-75.RM.1.0 23May2023
                }

            }
        }
    }

    actions
    {
    }

    trigger OnInit();
    begin
        CurrPage.LOOKUPMODE := true;
    end;

    trigger OnOpenPage();
    begin
        RESET();
        if HoldCustNo > '' then begin
            Job.RESET();
            Job.SETCURRENTKEY("Bill-to Customer No.");
            Job.SETRANGE("Bill-to Customer No.", HoldCustNo);
            if Job.FINDSET() then
                repeat
                    SETRANGE("Job No.", Job."No.");
                    if FINDSET() then
                        repeat
                            MARK(true);
                        until NEXT() = 0;
                    SETRANGE("Job No.");
                until Job.NEXT() = 0;
            MARKEDONLY(true);
        end;

        if HoldJob > '' then
            SETRANGE("Job No.", HoldJob);
        if HoldCostCategory > '' then
            SETRANGE("NS_Cost Category", HoldCostCategory);
        if HoldRevCategory > '' then
            SETRANGE("NS_Revenue Category", HoldRevCategory);
        if HoldJobTaskNo > '' then
            SETRANGE("Job Task No.", HoldJobTaskNo);
        if HoldEntryType > 0 then
            SETFILTER("NS_Entry Type", '%1|%2', HoldEntryType, "NS_Entry Type"::Both);
        //PRJ-389 start    
        if SalesPurch = SalesPurch::Purchase then
            SetFilter("Line Type", '%1|%2', "Line Type"::Budget, "Line Type"::"Both Budget and Billable")
        else
            if SalesPurch = SalesPurch::Sales then
                SetFilter("Line Type", '%1|%2', "Line Type"::Billable, "Line Type"::"Both Budget and Billable");  //PRJ-1407.GK.1.0 18May2022|add semicolon for next code
        //PRJ-389 end
        //PRJ-1407.GK.1.0 18May2022 start
        OnOpenPageOnAfterSetfilters(Rec);
        //PRJ-1407.GK.1.0 18May2022 end
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction = ACTION::LookupOK then
            NS_LookupOKOnPush;

        if (DocNo <> '') and (CloseAction in [ACTION::OK, ACTION::LookupOK]) then begin
            CurrPage.SETSELECTIONFILTER(Rec);
            NS_CreateLines(Rec);
        end;
    end;
    // >> Upgrade
    trigger OnAfterGetRecord()
    var
        Job: Record Job;
    begin
        // #152 Start
        if Job.Get("Job No.") then
            PageCaption := Job."No." + ' · ' + Job.Description
        else
            PageCaption := '';
        // #152 End
    end;
    // << Upgrade
    var
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        HoldCustNo: Code[20];
        HoldJob: Code[20];
        HoldCostCategory: Code[10];
        HoldRevCategory: Code[10];
        HoldJobTaskNo: Code[35];
        HoldEntryType: Option;
        JobNo: Code[20];
        DocType: Enum "Sales Document Type";
        SalesPurch: Option " ",Sales,Purchase;
        DocNo: Code[20];
        // >> Upgrade
        PageCaption: Text;
    // << Upgrade

    procedure NS_Set(CustNoIn: Code[20]; JobIn: Code[20]; CostCat: Code[10]; RevCat: Code[10]; JobTaskNo: Code[35]; EntType: Option);
    begin
        HoldCustNo := CustNoIn;
        HoldJob := JobIn;
        HoldCostCategory := CostCat;
        HoldRevCategory := RevCat;
        HoldJobTaskNo := JobTaskNo;
        HoldEntryType := EntType;
    end;

    procedure NS_Get(var JobNo: Code[20]; var JobTaskNo: Code[35]; var LineNo: Integer);
    begin
        JobNo := "Job No.";
        JobTaskNo := "Job Task No.";
        LineNo := "Line No.";
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        SETRANGE("Job No.", JobNo);
    end;

    local procedure NS_LookupOKOnPush();
    begin
        HoldCostCategory := "NS_Cost Category";
        HoldRevCategory := "NS_Revenue Category";
        HoldJobTaskNo := "Job Task No.";
    end;

    procedure NS_SetGetFrom(PassDocType: Enum "Sales Document Type"; PassSalePurch: Option " ",Sales,Purchase; PassDocNum: Code[20]);
    begin
        DocType := PassDocType;
        SalesPurch := PassSalePurch;
        DocNo := PassDocNum;
    end;

    local procedure NS_CreateLines(var PassJobPlanningLine: Record "Job Planning Line");
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NSBillingHeader: record "NS_Progress Billing Header";   //PRJCTPR-199.JS.1.0 02NOV2023
        NSJobSetup: record "Jobs Setup";  //PRJCTPR-199.JS.1.0 02NOV2023
        LineNo: Integer;
        JobPlanningLine: Record "Job Planning Line"; //FOR-5.NK.1.0 03Mar2023
        PurchHead: Record "Purchase Header"; //FOR-5.NK.1.0 03Mar2023
        NSJobPlanningLine: Record "Job Planning Line";   //PRJCTPR-224.JS.1.0 05MAR2024
        NSJobs: record Job; //PRJCTPR-224.JS.1.0 05MAR2024
        NS_Currency: record Currency; //PRJCTPR-224.JS.1.0 05MAR2024
    begin
        if NSJobSetup.get() then; //PRJCTPR-199.JS.1.0 02NOV2023
        if PassJobPlanningLine.FINDSET() then
            repeat
                if SalesPurch = SalesPurch::Sales then begin
                    SalesHeader.GET(DocType, DocNo);
                    with SalesLine do begin
                        RESET();
                        SETRANGE("Document Type", DocType);
                        SETRANGE("Document No.", DocNo);
                        if FINDLAST() then
                            LineNo := "Line No." + 10000
                        else
                            LineNo := 10000;
                        "Line No." := LineNo;
                        "Document Type" := DocType;
                        "Document No." := DocNo;
                        case PassJobPlanningLine.Type of
                            PassJobPlanningLine.Type::Resource:
                                Type := Type::Resource;
                            PassJobPlanningLine.Type::Item:
                                Type := Type::Item;
                            PassJobPlanningLine.Type::"G/L Account":
                                Type := Type::"G/L Account";
                        end;
                        VALIDATE(Type);
                        VALIDATE("No.", PassJobPlanningLine."No.");
                        "Variant Code" := PassJobPlanningLine."Variant Code";
                        //"Description 2" := PassJobPlanningLine.Description;//PRJ-1701.RP.1.0 09NOV2022 COMMENTED CODE
                        "Description" := PassJobPlanningLine.Description;//PRJ-1701.RP.1.0 09NOV2022 ADDED CODE
                        "Description 2" := PassJobPlanningLine."Description 2";//PRJ-1701.RP.1.0 09NOV2022 ADDED CODE
                        "Gen. Bus. Posting Group" := PassJobPlanningLine."Gen. Bus. Posting Group";
                        "Gen. Prod. Posting Group" := PassJobPlanningLine."Gen. Prod. Posting Group";
                        if PassJobPlanningLine."Location Code" <> '' then //FOR-5.NK.1.0 10Mar2023 
                            SalesLine.VALIDATE("Location Code", PassJobPlanningLine."Location Code");
                        "Bin Code" := PassJobPlanningLine."Bin Code";
                        VALIDATE(Quantity, PassJobPlanningLine.Quantity);
                        //PE-301.NC.1.0 10Jun2024 Start
                        if ((PassJobPlanningLine."Line Type" = PassJobPlanningLine."Line Type"::"Both Budget and Billable") and (PassJobPlanningLine.Type = PassJobPlanningLine.Type::Item)) then
                            SalesLine."Unit of Measure Code" := Rec.NS_GetUOMSaleItemBB(PassJobPlanningLine."No.", PassJobPlanningLine."Job No.", PassJobPlanningLine)
                        else
                            //PE-301.NC.1.0 10Jun2024 End
                            "Unit of Measure Code" := PassJobPlanningLine."Unit of Measure Code";
                        "Unit Price" := PassJobPlanningLine."Unit Price";
                        "Job No." := PassJobPlanningLine."Job No.";
                        //SalesLine."Job Task No." := PassJobPlanningLine."Job Task No.";  //PRJCTPR-199.JS.1.0 11DEC2023 line commented
                        SalesLine.validate("Job Task No.", PassJobPlanningLine."Job Task No.");  //PRJCTPR-199.JS.1.0 11DEC2023 line addec
                        "NS_Segment Code" := PassJobPlanningLine."NS_Segment Code";//TM-10.AM.1.0 26NOV2020 
                        "NS_Job Cost Category" := PassJobPlanningLine."NS_Cost Category";
                        //"Shortcut Dimension 1 Code" := PassJobPlanningLine."PP_Shortcut Dimension 1 Code"; //PRJ-389 comment
                        //"Shortcut Dimension 2 Code" := PassJobPlanningLine."PP_Shortcut Dimension 2 Code";  //PRJ-389 comment
                        //"Dimension Set ID" := PassJobPlanningLine."PP_Dimension Set ID"; //PRJ-389 comment

                        //PRJ-389 start   
                        if Job.get(PassJobPlanningLine."Job No.") then;
                        "NS_job Revenue Category" := PassJobPlanningLine."NS_Revenue Category";

                        //PRJCTPR-224.JS.1.0 12MAR2024 - Start
                        if job."Invoice Currency Code" <> '' then begin
                            if (SalesHeader."Currency Code" <> '') and (SalesHeader."Currency Factor" <> 0) and (SalesHeader."NS_Job No." <> '') then begin
                                if NS_Currency.get(SalesHeader."Currency Code") then
                                    SalesLine.validate("Unit Price", Round(SalesLine."Unit Price" * SalesHeader."Currency Factor",
                                                            NS_Currency."Unit-Amount Rounding Precision"));
                            end;
                        end;
                        if (job."Currency Code" <> '') and (job."Invoice Currency Code" = '') then
                            SalesLine.validate("Unit Price", PassJobPlanningLine."Unit Price");
                        //PRJCTPR-224.JS.1.0 12MAR2024 - end
                        if PassJobPlanningLine."NS_Shortcut Dimension 1 Code" <> '' then
                            "Shortcut Dimension 1 Code" := PassJobPlanningLine."NS_Shortcut Dimension 1 Code"
                        else
                            "Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                        if PassJobPlanningLine."NS_Shortcut Dimension 2 Code" <> '' then
                            "Shortcut Dimension 2 Code" := PassJobPlanningLine."NS_Shortcut Dimension 2 Code"
                        else
                            "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                        //PRJ-389 end
                        INSERT;
                    end;
                end else
                    if SalesPurch = SalesPurch::Purchase then begin
                        PurchHeader.GET(DocType, DocNo);
                        //PE-260.JS.1.0 06MAR2024 - Start                        
                        if (PurchHeader."NS_Job No." <> '') and (PurchHeader."NS_Multiple Jobs on Lines" = false) then
                            if PurchHeader."NS_Job No." <> PassJobPlanningLine."Job No." then
                                error('Please enable "Multiple Jobs on Lines" in %1 No. %2 on "Purchase %3 Header"', DocType, DocNo, DocType);
                        //PE-260.JS.1.0 06MAR2024 - end
                        with PurchLine do begin
                            RESET();
                            SETRANGE("Document Type", DocType);
                            SETRANGE("Document No.", DocNo);
                            if FINDLAST() then
                                LineNo := "Line No." + 10000
                            else
                                LineNo := 10000;
                            "Document Type" := DocType;
                            "Document No." := DocNo;
                            "Line No." := LineNo;
                            case PassJobPlanningLine.Type of
                                PassJobPlanningLine.Type::Resource:
                                    Type := Type::Resource;
                                PassJobPlanningLine.Type::Item:
                                    Type := Type::Item;
                                PassJobPlanningLine.Type::"G/L Account":
                                    Type := Type::"G/L Account";
                            end;
                            VALIDATE(Type);
                            VALIDATE("No.", PassJobPlanningLine."No.");
                            "Variant Code" := PassJobPlanningLine."Variant Code";
                            //"Description 2" := PassJobPlanningLine.Description;//PRJ-1701.RP.1.0 09NOV2022 COMMENTED CODE
                            "Description" := PassJobPlanningLine.Description;//PRJ-1701.RP.1.0 09NOV2022 ADDED CODE
                            "Description 2" := PassJobPlanningLine."Description 2";//PRJ-1701.RP.1.0 09NOV2022 ADDED CODE
                            "Gen. Bus. Posting Group" := PassJobPlanningLine."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := PassJobPlanningLine."Gen. Prod. Posting Group";
                            VALIDATE("Location Code", PassJobPlanningLine."Location Code");
                            "Bin Code" := PassJobPlanningLine."Bin Code";
                            //PE-301.NC.1.0 10Jun2024 Start
                            if ((PassJobPlanningLine."Line Type" = PassJobPlanningLine."Line Type"::"Both Budget and Billable") and (PassJobPlanningLine.Type = PassJobPlanningLine.Type::Item)) then
                                PurchLine."Unit of Measure Code" := Rec.NS_GetUOMItemBB(PassJobPlanningLine."No.", PassJobPlanningLine."Job No.", PassJobPlanningLine)
                            else
                                //PE-301.NC.1.0 10Jun2024 End
                            "Unit of Measure Code" := PassJobPlanningLine."Unit of Measure Code";
                            "Unit Cost" := PassJobPlanningLine."Unit Cost";
                            "Unit Cost (LCY)" := PassJobPlanningLine."Unit Cost (LCY)";
                            "Direct Unit Cost" := PassJobPlanningLine."Unit Cost";
                            VALIDATE(Quantity, PassJobPlanningLine.Quantity);
                            //PRJ-866.JS.0.1 17Aug2021-Start
                            VALIDATE("Direct Unit Cost", PassJobPlanningLine."Unit Cost");
                            "Direct Unit Cost (LCY)" := PassJobPlanningLine."Direct Unit Cost (LCY)";
                            "Unit Price (LCY)" := PassJobPlanningLine."Unit Price (LCY)";
                            "Unit Price" := PassJobPlanningLine."Unit Price";
                            "Job Unit Price (LCY)" := PassJobPlanningLine."Unit Price (LCY)";
                            "Job Unit Price" := PassJobPlanningLine."Unit Price";
                            "NS_Job Planning Line No." := PassJobPlanningLine."Line No.";
                            //PRJ-866.JS.0.1 17Aug2021-End                                
                            "Job No." := PassJobPlanningLine."Job No.";
                            // "Job Task No." := PassJobPlanningLine."Job Task No.";//PRJCTPR-199.JS.1.0 11DEC2023 line commented
                            Validate("Job Task No.", PassJobPlanningLine."Job Task No.");  //PRJCTPR-199.JS.1.0 11DEC2023 line added
                            "NS_Segment Code" := PassJobPlanningLine."NS_Segment Code";//TM-10.AM.1.0 26NOV2020 
                            "NS_Job Cost Category" := PassJobPlanningLine."NS_Cost Category";
                            "NS_Job Revenue Category" := PassJobPlanningLine."NS_Revenue Category";
                            // "Shortcut Dimension 1 Code" := PassJobPlanningLine."PP_Shortcut Dimension 1 Code";//PRJ-389 comment
                            // "Shortcut Dimension 2 Code" := PassJobPlanningLine."PP_Shortcut Dimension 2 Code";//PRJ-389 comment
                            // "Dimension Set ID" := PassJobPlanningLine."PP_Dimension Set ID";//PRJ-389 comment
                            //PRJ-389 start  
                            if Job.get(PassJobPlanningLine."Job No.") then;
                            "NS_job Revenue Category" := PassJobPlanningLine."NS_Revenue Category";

                            //PRJCTPR-199.JS.1.0 12DEC2023 - start below code commented
                            // if PassJobPlanningLine."NS_Shortcut Dimension 1 Code" <> '' then
                            //     "Shortcut Dimension 1 Code" := PassJobPlanningLine."NS_Shortcut Dimension 1 Code"
                            // else
                            //     "Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
                            // if PassJobPlanningLine."NS_Shortcut Dimension 2 Code" <> '' then
                            //     "Shortcut Dimension 2 Code" := PassJobPlanningLine."NS_Shortcut Dimension 2 Code"
                            // else
                            //     "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
                            //PRJCTPR-199.JS.1.0 12DEC2023 - end
                            //PRJ-389 end
                            INSERT;

                            PassJobPlanningLine.VALIDATE("NS_Vendor No.", "NS_Vendor No.");
                            PassJobPlanningLine."NS_Purchase Order No." := "Document No.";
                            PassJobPlanningLine.VALIDATE("Remaining Qty.", "Remaining Qty.");
                            PassJobPlanningLine.VALIDATE("Remaining Total Cost", "Remaining Total Cost (LCY)");
                            PassJobPlanningLine.MODIFY();
                        end;
                    end;
            until PassJobPlanningLine.NEXT() = 0;
    end;
    //PRJ-1407.GK.1.0 18May2022 start
    [IntegrationEvent(false, false)]
    local procedure OnOpenPageOnAfterSetfilters(var Rec: Record "Job Planning Line")
    begin

    end;
    //PRJ-1407.GK.1.0 18May2022 end
}

