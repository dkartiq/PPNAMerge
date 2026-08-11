page 14021214 "NS_Job List (Formatted)"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJCTPR-230.HS.1.0 8Dec2023 | Obselete level L6 to L10
    Caption = 'Job List';
    CardPageID = "Job Card";
    PageType = Card;
    SourceTable = Job;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            field(JobNo; JobNo)
            {
                ApplicationArea = All;
                Caption = 'Job No.';
                ToolTip = 'Specifies the Job No.';
                TableRelation = Job."No."; //PE-120.NC.1.0 27Jun2023

                trigger OnValidate();
                begin
                    NS_JobNoOnAfterValidate;
                end;
            }
            field(Level; Level)
            {
                ApplicationArea = All;
                Caption = 'Level';
                Editable = false;
                ToolTip = 'Specifies the Level';
            }
            repeater(SubForm)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Specifies the Job No.';
                    Visible = false;
                }
                field("Job No."; JobCode1)
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job No. 2"; JobCode2)
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Specifies the Job No.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(JobClass; Rec."NS_Job Class")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Class';
                }
                field("Budgeted Cost"; BudgetedCost)
                {
                    ApplicationArea = All;
                    Caption = 'Budgeted Cost';
                    ToolTip = 'Specifies the Budgeted Cost';
                }
                field("Budgeted Price"; BudgetedPrice)
                {
                    ApplicationArea = All;
                    Caption = 'Budgeted Price';
                    ToolTip = 'Specifies the Budgeted Price';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the Bill-to Customer No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                    Visible = false;
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the Person Responsible';
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the Job Posting Group';
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search Description';
                }
            }
            field(Control1000000012; '')
            {
                ApplicationArea = All;
                CaptionClass = Text19073773Lbl;

            }
        }
        area(factboxes)
        {
            part(Control1907568407; "NS_Job A/R A/P BalancesFactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Job")
            {
                Caption = '&Job';
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View the job card.';

                    trigger OnAction();
                    var
                        JobRec: Record Job;
                        JobCard: Page "Job Card";
                    begin
                        JobRec.RESET;
                        JobRec.SETRANGE("No.", "No.");
                        CLEAR(JobCard);
                        JobCard.SETTABLEVIEW(JobRec);
                        JobCard.RUN;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job),
                                  "No." = FIELD("No.");
                    ToolTip = 'View the comments.';
                }
                action(Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(167),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View the dimensions.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the ledger entries';
                }
                action("Job Task Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Lines';
                    Image = TaskList;
                    ToolTip = 'View the job task lines';

                    trigger OnAction();
                    var
                        JTLines: Page "Job Task Lines";
                    begin
                        JTLines.NS_SetJobNo("No.");
                        JTLines.RUN();
                    end;
                }
                action("Job &Planning Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Job &Planning Lines';
                    Image = ListPage;
                    RunObject = Page "Job Planning Lines";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the job planning lines';
                }
                action("Job Planning Lines (&Editable)")
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines (&Editable)';
                    Image = ServiceLedger;
                    RunObject = Page "NS_Job PlanningList(Editable)";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the editable job planning lines.';
                }
                action("Su&bcontracts")
                {
                    ApplicationArea = All;
                    Caption = 'Su&bcontracts';
                    Image = CalculateRemainingUsage;
                    ToolTip = 'View the subcontracts';

                    trigger OnAction();
                    begin
                        JobSubcontractList.NS_Set("No.");
                        JobSubcontractList.RUNMODAL;
                        CLEAR(JobSubcontractList);
                    end;
                }
                action("Lin&ks")
                {
                    ApplicationArea = All;
                    Caption = 'Lin&ks';
                    Image = Links;
                    RunObject = Page "NS_Job Links";
                    RunPageLink = "NS_Job No." = FIELD("No.");
                    RunPageView = SORTING("NS_Job No.", "NS_Parent Job No.");
                    ToolTip = 'View the links.';
                }
                action("Job C&ontacts")
                {
                    ApplicationArea = All;
                    Caption = 'Job C&ontacts';
                    Image = TeamSales;
                    RunObject = Page "NS_Job Contacts List";
                    RunPageLink = "NS_Job No." = FIELD("No.");
                    ToolTip = 'View the job contacts';
                }
                action(Statistics)
                {
                    ApplicationArea = All;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View the job statistics.';
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                action(Resource)
                {
                    ApplicationArea = All;
                    Caption = 'Resource';
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the resource';
                }
                action(Item)
                {
                    ApplicationArea = All;
                    Caption = 'Item';
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the item.';
                }
                action("G/L Account")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account';
                    Image = ValueLedger;
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the G/L account.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                action(Action1000000013)
                {
                    ApplicationArea = All;
                    Caption = 'Job Task Lines';
                    Image = TaskList;
                    ToolTip = 'View the job task lines.';

                    trigger OnAction();
                    var
                        JTLines: Page "Job Task Lines";
                    begin
                        JTLines.NS_SetJobNo("No.");
                        JTLines.RUN;
                    end;
                }
                action(Action1000000014)
                {
                    ApplicationArea = All;
                    Caption = 'Job &Planning Lines';
                    Image = ListPage;
                    RunObject = Page "Job Planning Lines";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the job planning lines.';
                }
                action(Action1100773014)
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines (&Editable)';
                    Image = ServiceLedger;
                    RunObject = Page "NS_Job PlanningList(Editable)";
                    RunPageLink = "Job No." = FIELD("No.");
                    ToolTip = 'View the job planning lines editable.';
                }
                separator(Separator1000000017)
                {
                }
                action("Resource Allocated per Job")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                    ToolTip = 'View the resources allocated per job.';
                }
                separator(a)
                {
                    Caption = 'a';
                }
                action("Res. &Gr. Allocated per Job")
                {
                    ApplicationArea = All;
                    Caption = 'Res. &Gr. Allocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                }
            }
        }
        area(processing)
        {
            action(Button1)
            {
                ApplicationArea = All;
                Caption = 'L1';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 1 then
                        Level := 0
                    else
                        Level := 1;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button2)
            {
                ApplicationArea = All;
                Caption = 'L2';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 2 then
                        Level := 0
                    else
                        Level := 2;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button3)
            {
                ApplicationArea = All;
                Caption = 'L3';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 3 then
                        Level := 0
                    else
                        Level := 3;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button4)
            {
                ApplicationArea = All;
                Caption = 'L4';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 4 then
                        Level := 0
                    else
                        Level := 4;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button5)
            {
                ApplicationArea = All;
                Caption = 'L5';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 5 then
                        Level := 0
                    else
                        Level := 5;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button6)
            {
                Caption = 'L6';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                //PRJCTPR-230.HS.1.0 8Dec2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                //PRJCTPR-230.HS.1.0 8Dec2023 End

                trigger OnAction();
                begin
                    if Level = 6 then
                        Level := 0
                    else
                        Level := 6;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button7)
            {
                ApplicationArea = All;
                Caption = 'L7';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                //PRJCTPR-230.HS.1.0 8Dec2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                //PRJCTPR-230.HS.1.0 8Dec2023 End


                trigger OnAction();
                begin
                    if Level = 7 then
                        Level := 0
                    else
                        Level := 7;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button8)
            {
                ApplicationArea = All;
                Caption = 'L8';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                //PRJCTPR-230.HS.1.0 8Dec2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                //PRJCTPR-230.HS.1.0 8Dec2023 End

                trigger OnAction();
                begin
                    if Level = 8 then
                        Level := 0
                    else
                        Level := 8;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button9)
            {
                ApplicationArea = All;
                Caption = 'L9';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                //PRJCTPR-230.HS.1.0 8Dec2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                //PRJCTPR-230.HS.1.0 8Dec2023 End

                trigger OnAction();
                begin
                    if Level = 9 then
                        Level := 0
                    else
                        Level := 9;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
            action(Button10)
            {
                ApplicationArea = All;
                Caption = 'L10';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                //PRJCTPR-230.HS.1.0 8Dec2023 Start
                Visible = false;
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in next build';
                ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
                //PRJCTPR-230.HS.1.0 8Dec2023 End

                trigger OnAction();
                begin
                    if Level = 10 then
                        Level := 0
                    else
                        Level := 10;
                    NS_SetButtons;
                    NS_SetPointer;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        i: Integer;
    begin
        if "NS_Temp Linked Parent Job No." = '' then
            "NS_Temp Linked Parent Job No." := "No.";

        BoldThisLine := false;
        with JobLinks do begin
            RESET;
            SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
            if JobsSetup."NS_Job List Bolding" > JobsSetup."NS_Job List Bolding"::None then
                NS_Bolding;
        end;

        JobCode1 := '';
        for i := 1 to NS_SeparatorCount("No.") * JobsSetup."NS_Job List Indent Increment" do
            JobCode1 := JobCode1 + ' ';
        JobCode1 := JobCode1 + "No.";
        JobCode2 := "No.";
        CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        BudgetedCost := "NS_Budgeted Cost (LCY)";
        BudgetedPrice := "NS_Budgeted Price (LCY)";
        if Level = NS_SeparatorCount("No.") then begin
            BudgetedCost := BudgetedCost + NS_SLsBudgetedCost(Rec);
            BudgetedPrice := BudgetedPrice + NS_SLsBudgetedPrice(Rec);
        end;
        NS_JobCode1OnFormat;
        NS_JobCode2OnFormat;
        NS_DescriptionOnFormat;
        NS_JobClassOnFormat;
        NS_BudgetedCostOnFormat;
        NS_BudgetedPriceOnFormat;
        NS_BilltoCustomerNoOnFormat;
        NS_StatusOnFormat;
        NS_PersonResponsibleOnFormat;
        NS_JobPostingGroupOnFormat;
        NS_GlobalDimension1CodeOnFormat;
        NS_GlobalDimension2CodeOnFormat;
        NS_SearchDescriptionOnFormat;
    end;

    trigger OnInit();
    begin
        JobsSetup.GET;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    var
        NextRec: Record Job;
        StepsTaken: Integer;
    begin
        if Steps <> 0 then begin
            if "NS_Temp Linked Parent Job No." = '' then
                if NS_SeparatorCount("No.") = 0 then
                    "NS_Temp Linked Parent Job No." := Rec."No.";

            //Call the routine to find the "Job No." that should be returned to the caller
            StepsTaken := NS_JobLinkNextRecord(Steps, Rec, NextRec);
            Rec := NextRec;
        end;

        exit(StepsTaken);
    end;

    trigger OnOpenPage();
    var
        HoldProjNo: Code[20];
        JobToModify: Record Job;
    begin
        Level := JobsSetup."NS_Job List Default Level";
        NS_SetButtons;
        NS_SetLastJobListFlag;
    end;

    var
        Job2: Record Job;
        JobLinks: Record "NS_Job Links";
        JobsSetup: Record "Jobs Setup";
        BudgetedCost: Decimal;
        BudgetedPrice: Decimal;
        Level: Integer;
        JobCode1: Text[40];
        JobCode2: Text[40];
        BoldThisLine: Boolean;
        JobNo: Code[20];
        [InDataSet]
        "Job No.Emphasize": Boolean;
        [InDataSet]
        "Job No. 2Emphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        JobClassEmphasize: Boolean;
        [InDataSet]
        "Budgeted CostEmphasize": Boolean;
        [InDataSet]
        "Budgeted PriceEmphasize": Boolean;
        [InDataSet]
        "Bill-to Customer No.Emphasize": Boolean;
        [InDataSet]
        StatusEmphasize: Boolean;
        [InDataSet]
        "Person ResponsibleEmphasize": Boolean;
        [InDataSet]
        "Job Posting GroupEmphasize": Boolean;
        [InDataSet]
        GlobalDimension1CodeEmphasize: Boolean;
        [InDataSet]
        GlobalDimension2CodeEmphasize: Boolean;
        [InDataSet]
        "Search DescriptionEmphasize": Boolean;
        Button1Height: Integer;
        Button2Height: Integer;
        Button3Height: Integer;
        Button4Height: Integer;
        Button5Height: Integer;
        Button6Height: Integer;
        Button7Height: Integer;
        Button8Height: Integer;
        Button9Height: Integer;
        Button10Height: Integer;
        Text19073773Lbl: Label 'Maximum Level:';
        JobSubcontractList: Page "NS_Job Subcontract List";

    procedure NS_SetButtons();
    begin
        //Reset All Buttons
        Button1Height := 550;
        Button2Height := 550;
        Button3Height := 550;
        Button4Height := 550;
        Button5Height := 550;
        Button6Height := 550;
        Button7Height := 550;
        Button8Height := 550;
        Button9Height := 550;
        Button10Height := 550;

        case Level of
            1:
                Button1Height := 700;
            2:
                Button2Height := 700;
            3:
                Button3Height := 700;
            4:
                Button4Height := 700;
            5:
                Button5Height := 700;
            6:
                Button6Height := 700;
            7:
                Button7Height := 700;
            8:
                Button8Height := 700;
            9:
                Button9Height := 700;
            10:
                Button10Height := 700;
        end;
    end;

    procedure NS_SetPointer();
    begin
        if JobNo > '' then begin
            if GET(JobNo) then;
        end else
            if GET("NS_Temp Linked Parent Job No.") then;
        JobLinks.RESET;
        JobLinks.SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
        CurrPage.UPDATE(false)
    end;

    procedure NS_Bolding();
    var
        JobLinks2: Record "NS_Job Links";
    begin
        with JobLinks do begin
            if JobsSetup."NS_Job List Bolding" = JobsSetup."NS_Job List Bolding"::Headers then begin
                SETRANGE("NS_Parent Job No.", Rec."No.");
                if FINDSET() then;
                case COUNT of
                    0:
                        ;
                    1:
                        begin
                            if "NS_Job No." = "NS_Parent Job No." then begin
                                if NS_SeparatorCount(Rec."No.") = 0 then begin
                                    BoldThisLine := true;
                                end;
                            end else begin
                                if NS_SeparatorCount(Rec."No.") > 0 then begin
                                    BoldThisLine := true;
                                end;
                            end;
                        end;
                    else begin
                            if FINDSET() then
                                repeat
                                    JobLinks2.RESET();
                                    JobLinks2.SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
                                    JobLinks2.SETRANGE("NS_Parent Job No.", "No.");
                                    if JobLinks.COUNT > 1 then
                                        BoldThisLine := true;
                                until NEXT() = 0;
                        end;
                end;
            end else begin
                if NS_SeparatorCount(Rec."No.") = 0 then
                    BoldThisLine := true;
            end;
        end;
    end;

    procedure NS_SetParameters(var JobRec: Record Job);
    begin
        Job2 := JobRec;
        CurrPage.LOOKUPMODE(true);
    end;

    procedure NS_GetParameters(var JobNo: Code[20]);
    begin
        JobNo := Rec."No.";
    end;

    procedure NS_JobLinkNextRecord(Steps: Integer; JobRecIn: Record Job; var JobRecOut: Record Job): Integer;
    var
        LastGoodRecordForward: Record "NS_Job Links";
        LastGoodRecordBackward: Record "NS_Job Links";
        JobNumOut: Code[20];
        ParentJobNumOut: Code[20];
        StepsTaken: Integer;
        i: Integer;
        EOF: Boolean;
    begin
        StepsTaken := 0;
        EOF := false;
        CLEAR(LastGoodRecordForward);
        CLEAR(LastGoodRecordBackward);
        JobRecOut := JobRecIn;

        with JobLinks do begin

            //Read the starting record
            if JobRecIn."NS_Temp Linked Parent Job No." = '' then
                JobRecIn."NS_Temp Linked Parent Job No." := JobRecIn."No.";

            RESET();
            SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
            SETRANGE("NS_Job No.", JobRecIn."No.");
            if NS_SeparatorCount(JobRecIn."NS_Temp Linked Parent Job No.") = 0 then
                SETRANGE("NS_Parent Job No.", JobRecIn."NS_Temp Linked Parent Job No.");
            if FINDSET() then;
            SETRANGE("NS_Parent Job No.");

            if JobNo > '' then begin
                RESET();
                SETCURRENTKEY("NS_Parent Job No.", "NS_Job No.");
                SETFILTER("NS_Job No.", JobNo + '*');
            end else
                SETRANGE("NS_Job No.");

            //Get the records needed
            if Steps > 0 then
                for i := 1 to Steps do begin
                    if not EOF then begin
                        if NS_GoForward(EOF) then begin
                            LastGoodRecordForward := JobLinks;
                            StepsTaken := StepsTaken + 1;
                        end;
                    end;
                end
            else
                for i := 1 to -Steps do begin
                    if not EOF then begin
                        if NS_GoBackward(EOF) then begin
                            LastGoodRecordBackward := JobLinks;
                            StepsTaken := StepsTaken - 1;
                        end;
                    end;
                end;
        end;

        //Send back the Job record to use
        if StepsTaken <> 0 then begin
            if Steps <> 0 then begin
                if Steps > 0 then begin
                    JobNumOut := LastGoodRecordForward."NS_Job No.";
                    ParentJobNumOut := LastGoodRecordForward."NS_Parent Job No.";
                end else begin
                    JobNumOut := LastGoodRecordBackward."NS_Job No.";
                    ParentJobNumOut := LastGoodRecordBackward."NS_Parent Job No.";
                end;
                JobRecOut.GET(JobNumOut);
                if ParentJobNumOut = '' then
                    ParentJobNumOut := JobNumOut;
                JobRecOut."NS_Temp Linked Parent Job No." := ParentJobNumOut;
            end;
        end;

        exit(StepsTaken);
    end;

    procedure NS_GoForward(var EOF1: Boolean): Boolean;
    var
        SepCount: Integer;
        ParentSepCount: Integer;
        Result: Integer;
        BeginJobNo: Code[20];
        GoodRecord: Boolean;
        EOF2: Boolean;
    begin
        GoodRecord := false;

        with JobLinks do begin
            repeat
                Result := NEXT();
                if Result > 0 then begin
                    SepCount := NS_SeparatorCount("NS_Job No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                    if (SepCount <= Level) and
                       (ParentSepCount = 0) then begin
                        GoodRecord := true;
                    end;
                end else begin
                    EOF1 := true;
                    if SepCount > Level then begin
                        EOF2 := false;
                        repeat
                            if NEXT(-1) = 0 then
                                EOF2 := true;
                            if (SepCount <= Level) and
                               (ParentSepCount = 0) then begin
                                GoodRecord := true;
                            end;
                        until ((NS_SeparatorCount("NS_Job No.") <= Level) and
                               (NS_SeparatorCount("NS_Parent Job No.") = 0))
                              or EOF2;
                    end;
                end;
            until EOF1 or GoodRecord;
        end;

        exit(GoodRecord);
    end;

    procedure NS_GoBackward(var EOF1: Boolean): Boolean;
    var
        SepCount: Integer;
        ParentSepCount: Integer;
        Result: Integer;
        GoodRecord: Boolean;
        EOF2: Boolean;
    begin
        GoodRecord := false;

        with JobLinks do begin
            repeat
                Result := NEXT(-1);
                if (Result < 0) and not EOF1 then begin
                    SepCount := NS_SeparatorCount("NS_Job No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                    if (SepCount > Level) and
                       (ParentSepCount = 0) then begin
                        EOF2 := false;
                        repeat
                            if NEXT(-1) = 0 then
                                EOF2 := true;
                            SepCount := NS_SeparatorCount("NS_Job No.");
                            ParentSepCount := NS_SeparatorCount("NS_Parent Job No.");
                        until ((SepCount <= Level) and
                               (ParentSepCount = 0))
                              or EOF2;
                    end;
                    if (SepCount <= Level) and
                       (ParentSepCount = 0) then begin
                        GoodRecord := true;
                    end;
                end else
                    EOF1 := true;
            until EOF1 or GoodRecord;
        end;

        exit(GoodRecord);
    end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        NS_SetPointer
    end;

    local procedure NS_JobCode1OnFormat();
    begin
        if BoldThisLine then
            "Job No.Emphasize" := true;
    end;

    local procedure NS_JobCode2OnFormat();
    begin
        if BoldThisLine then
            "Job No. 2Emphasize" := true;
    end;

    local procedure NS_DescriptionOnFormat();
    begin
        if BoldThisLine then
            DescriptionEmphasize := true;
    end;

    local procedure NS_JobClassOnFormat();
    begin
        if BoldThisLine then
            JobClassEmphasize := true;
    end;

    local procedure NS_BudgetedCostOnFormat();
    begin
        if BoldThisLine then
            "Budgeted CostEmphasize" := true;
    end;

    local procedure NS_BudgetedPriceOnFormat();
    begin
        if BoldThisLine then
            "Budgeted PriceEmphasize" := true;
    end;

    local procedure NS_BilltoCustomerNoOnFormat();
    begin
        if BoldThisLine then
            "Bill-to Customer No.Emphasize" := true;
    end;

    local procedure NS_StatusOnFormat();
    begin
        if BoldThisLine then
            StatusEmphasize := true;
    end;

    local procedure NS_PersonResponsibleOnFormat();
    begin
        if BoldThisLine then
            "Person ResponsibleEmphasize" := true;
    end;

    local procedure NS_JobPostingGroupOnFormat();
    begin
        if BoldThisLine then
            "Job Posting GroupEmphasize" := true;
    end;

    local procedure NS_GlobalDimension1CodeOnFormat();
    begin
        if BoldThisLine then
            GlobalDimension1CodeEmphasize := true;
    end;

    local procedure NS_GlobalDimension2CodeOnFormat();
    begin
        if BoldThisLine then
            GlobalDimension2CodeEmphasize := true;
    end;

    local procedure NS_SearchDescriptionOnFormat();
    begin
        if BoldThisLine then
            "Search DescriptionEmphasize" := true;
    end;
}

