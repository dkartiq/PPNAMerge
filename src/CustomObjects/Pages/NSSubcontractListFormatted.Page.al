page 14021308 "NS_Subcontract List(Formatted)"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-257 VT1.0 06-05-20
    Caption = 'Subcontract List';
    PageType = Card;
    SourceTable = NS_Subcontract;
    //UsageCategory = Lists;//PRJ-610.AS.1.0 02APRIL2021 Commented
    // ApplicationArea = Jobs;//PRJ-610.AS.1.0 02APRIL2021 Commented

    layout
    {
        area(content)
        {
            field(SubcNo; SubcNo)
            {
                ApplicationArea = All;
                Caption = 'Subcontract No.';
                ToolTip = 'Specifies the subcontract no.';

                trigger OnValidate();
                begin
                    NS_SubcNoOnAfterValidate;
                end;
            }
            field(Level; Level)
            {
                ApplicationArea = All;
                Caption = 'Level';
                Editable = false;
                ToolTip = 'Specifies the subcontract level.';
            }
            repeater(SubForm)
            {
                Editable = false;
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract No.';
                    ToolTip = 'Specifies the no.';
                    Visible = true;//PRJ-257 VT1.0 06-05-20
                }
                field("Subcontract No."; SubcontractCode1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subcontract code';

                    Caption = 'Specifies the subcontract code';
                }
                field("Subcontract No. 2"; SubcontractCode2)
                {
                    ApplicationArea = All;
                    Caption = 'Subcontract No.';
                    ToolTip = 'Specifies the subcontract code 2.';
                    Visible = false;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Budgeted Cost"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the Budgeted Cost (LCY)';
                }
                field("Buy-from Vendor No."; Rec."NS_Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the Buy-from Vendor No.';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                    Visible = false;
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Specifies the Person Responsible';
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Global Dimension 1 Code';
                }
                field("Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    ToolTip = 'Global Dimension 2 Code';
                }
                field("Search Description"; Rec."NS_Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search Description';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Subcontract")
            {
                Caption = '&Subcontract';
                action(NS_Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "NS_Subcontract Card";
                    RunPageLink = "NS_No." = FIELD("NS_No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View the subcontract card.';
                }
                action("NS_Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(NS_Subcontract),
                                  "No." = FIELD("NS_No.");
                    ToolTip = 'View comments.';
                }
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(14021300),
                                  "No." = FIELD("NS_No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View/edit dimensions.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = Page "NS_Subcontract Ledger Entries";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    RunPageView = SORTING("NS_Subcontract No.", "NS_Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View subcontract ledger entries.';
                }
                action("&Links")
                {
                    ApplicationArea = All;
                    Caption = '&Links';
                    Image = Links;
                    RunObject = Page "NS_Subcontract Links";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    RunPageView = SORTING("NS_Subcontract No.", "NS_Parent Subcontract No.");
                    ToolTip = 'View links';
                }
            }
        }
        area(processing)
        {
            action(Button1)
            {
                ApplicationArea = All;
                Caption = 'L1';

                ToolTip = 'L1';
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

                ToolTip = 'L2';
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

                ToolTip = 'L3';
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

                ToolTip = 'L4';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 4 then
                        Level := 0
                    else
                        Level := 4;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button5)
            {
                ApplicationArea = All;
                Caption = 'L5';

                ToolTip = 'L5';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 5 then
                        Level := 0
                    else
                        Level := 5;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button6)
            {
                ApplicationArea = All;
                Caption = 'L6';

                ToolTip = 'L6';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 6 then
                        Level := 0
                    else
                        Level := 6;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button7)
            {
                ApplicationArea = All;
                Caption = 'L7';
                ToolTip = 'L7';

                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 7 then
                        Level := 0
                    else
                        Level := 7;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button8)
            {
                ApplicationArea = All;
                Caption = 'L8';

                ToolTip = 'L8';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 8 then
                        Level := 0
                    else
                        Level := 8;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button9)
            {
                ApplicationArea = All;
                Caption = 'L9';
                ToolTip = 'L9';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 9 then
                        Level := 0
                    else
                        Level := 9;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
            action(Button10)
            {
                ApplicationArea = All;
                Caption = 'L10';

                ToolTip = 'L10';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    if Level = 10 then
                        Level := 0
                    else
                        Level := 10;
                    NS_SetButtons();
                    NS_SetPointer();
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        i: Integer;
    begin
        if "NS_Temp LinkedParentSubcontNo." = '' then
            "NS_Temp LinkedParentSubcontNo." := "NS_No.";

        BoldThisLine := false;
        with SubcontractLinks do begin
            RESET;
            SETCURRENTKEY("NS_Parent Subcontract No.", "NS_Subcontract No.");

            if JobsSetup."NS_Subcontract List Bolding" > JobsSetup."NS_Subcontract List Bolding"::None then
                NS_Bolding;
        end;

        SubcontractCode1 := '';
        for i := 1 to NS_SeparatorCount("NS_No.") * JobsSetup."NS_Subcont ListIndentIncrement" do
            SubcontractCode1 := SubcontractCode1 + ' ';
        SubcontractCode1 := SubcontractCode1 + "NS_No.";

        SubcontractCode2 := "NS_No.";
        NS_SubcontractCode1OnFormat;
        NS_SubcontractCode2OnFormat;
        NS_DescriptionOnFormat;
        NS_BudgetedCostLCYOnFormat;
        NS_BuyfromVendorNoOnFormat;
        NS_StatusOnFormat;
        NS_PersonResponsibleOnFormat;
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
        NextRec: Record NS_Subcontract;
        StepsTaken: Integer;
    begin
        if Steps <> 0 then begin
            if "NS_Temp LinkedParentSubcontNo." = '' then
                if NS_SeparatorCount("NS_No.") = 0 then
                    "NS_Temp LinkedParentSubcontNo." := Rec."NS_No.";

            //Call the routine to find the "Subcontract No." that should be returned to the caller
            StepsTaken := NS_SubcontractLinkNextRecord(Steps, Rec, NextRec);
            Rec := NextRec;
        end;

        exit(StepsTaken);
    end;

    trigger OnOpenPage();
    var
        HoldSubcNo: Code[20];
        SubcontractToModify: Record NS_Subcontract;
    begin
        Level := JobsSetup."NS_SubcontractListDefaultLevel";
        NS_SetButtons;
        NS_SetLastSubcontractListFlag;
    end;

    var
        Subcontract2: Record NS_Subcontract;
        SubcontractLinks: Record "NS_Subcontract Links";
        JobsSetup: Record "Jobs Setup";
        Level: Integer;
        SubcontractCode1: Text[40];
        SubcontractCode2: Text[40];
        BoldThisLine: Boolean;
        SubcNo: Code[20];
        [InDataSet]
        "Subcontract No.Emphasize": Boolean;
        [InDataSet]
        "Subcontract No. 2Emphasize": Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        "Budgeted CostEmphasize": Boolean;
        [InDataSet]
        "Buy-from Vendor No.Emphasize": Boolean;
        [InDataSet]
        StatusEmphasize: Boolean;
        [InDataSet]
        "Person ResponsibleEmphasize": Boolean;
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
        if SubcNo > '' then begin
            if GET(SubcNo) then;
        end else
            if GET("NS_Temp LinkedParentSubcontNo.") then;
        SubcontractLinks.RESET();
        SubcontractLinks.SETCURRENTKEY("NS_Parent Subcontract No.", "NS_Subcontract No.");
        CurrPage.UPDATE(false)
    end;

    procedure NS_Bolding();
    var
        SubcontractLinks2: Record "NS_Subcontract Links";
    begin
        with SubcontractLinks do begin
            if JobsSetup."NS_Subcontract List Bolding" = JobsSetup."NS_Subcontract List Bolding"::Headers then begin
                SETRANGE("NS_Parent Subcontract No.", Rec."NS_No.");
                if FINDSET then;
                case COUNT of
                    0:
                        ;
                    1:
                        begin
                            if "NS_Subcontract No." = "NS_Parent Subcontract No." then begin
                                if NS_SeparatorCount(Rec."NS_No.") = 0 then begin
                                    BoldThisLine := true;
                                end;
                            end else begin
                                if NS_SeparatorCount(Rec."NS_No.") > 0 then begin
                                    BoldThisLine := true;
                                end;
                            end;
                        end;
                    else begin
                            if FINDSET then
                                repeat
                                    SubcontractLinks2.RESET;
                                    SubcontractLinks2.SETCURRENTKEY("NS_Parent Subcontract No.", "NS_Subcontract No.");
                                    SubcontractLinks2.SETRANGE("NS_Parent Subcontract No.", "NS_No.");
                                    if SubcontractLinks.COUNT > 1 then
                                        BoldThisLine := true;
                                until NEXT = 0;
                        end;
                end;
            end else begin
                if NS_SeparatorCount(Rec."NS_No.") = 0 then
                    BoldThisLine := true;
            end;
        end;
    end;

    procedure NS_SetParameters(var SubcontractRec: Record NS_Subcontract);
    begin
        Subcontract2 := SubcontractRec;
        CurrPage.LOOKUPMODE(true);
    end;

    procedure NS_SubcontractLinkNextRecord(Steps: Integer; SubcontractRecIn: Record NS_Subcontract; var SubcontractRecOut: Record NS_Subcontract): Integer;
    var
        LastGoodRecordForward: Record "NS_Subcontract Links";
        LastGoodRecordBackward: Record "NS_Subcontract Links";
        SubcontractNumOut: Code[20];
        ParentSubcontractNumOut: Code[20];
        StepsTaken: Integer;
        i: Integer;
        EOF: Boolean;
    begin
        StepsTaken := 0;
        EOF := false;
        CLEAR(LastGoodRecordForward);
        CLEAR(LastGoodRecordBackward);
        SubcontractRecOut := SubcontractRecIn;

        with SubcontractLinks do begin

            //Read the starting record
            if SubcontractRecIn."NS_Temp LinkedParentSubcontNo." = '' then
                SubcontractRecIn."NS_Temp LinkedParentSubcontNo." := SubcontractRecIn."NS_No.";

            RESET;
            SETCURRENTKEY("NS_Parent Subcontract No.", "NS_Subcontract No.");
            SETRANGE("NS_Subcontract No.", SubcontractRecIn."NS_No.");
            if NS_SeparatorCount(SubcontractRecIn."NS_Temp LinkedParentSubcontNo.") = 0 then
                SETRANGE("NS_Parent Subcontract No.", SubcontractRecIn."NS_Temp LinkedParentSubcontNo.");
            if FINDSET then;
            SETRANGE("NS_Parent Subcontract No.");

            if SubcNo > '' then begin
                RESET;
                SETCURRENTKEY("NS_Parent Subcontract No.", "NS_Subcontract No.");
                SETFILTER("NS_Subcontract No.", SubcNo + '*');
            end else
                SETRANGE("NS_Subcontract No.");

            //Get the records needed
            if Steps > 0 then
                for i := 1 to Steps do
                    if not EOF then begin
                        if NS_GoForward(EOF) then begin
                            LastGoodRecordForward := SubcontractLinks;
                            StepsTaken := StepsTaken + 1;
                        end;
                    end

                    else
                        for i := 1 to -Steps do
                            if not EOF then begin
                                if NS_GoBackward(EOF) then begin
                                    LastGoodRecordBackward := SubcontractLinks;
                                    StepsTaken := StepsTaken - 1;
                                end;
                            end;
        end;


        //Send back the Subcontract record to use
        if StepsTaken <> 0 then begin
            if Steps <> 0 then begin
                if Steps > 0 then begin
                    SubcontractNumOut := LastGoodRecordForward."NS_Subcontract No.";
                    ParentSubcontractNumOut := LastGoodRecordForward."NS_Parent Subcontract No.";
                end else begin
                    SubcontractNumOut := LastGoodRecordBackward."NS_Subcontract No.";
                    ParentSubcontractNumOut := LastGoodRecordBackward."NS_Parent Subcontract No.";
                end;
                SubcontractRecOut.GET(SubcontractNumOut);
                if ParentSubcontractNumOut = '' then
                    ParentSubcontractNumOut := SubcontractNumOut;
                SubcontractRecOut."NS_Temp LinkedParentSubcontNo." := ParentSubcontractNumOut;
            end;
        end;

        exit(StepsTaken);
    end;

    procedure NS_GoForward(var EOF1: Boolean): Boolean;
    var
        SepCount: Integer;
        ParentSepCount: Integer;
        Result: Integer;
        BeginProjNo: Code[20];
        GoodRecord: Boolean;
        EOF2: Boolean;
    begin
        GoodRecord := false;

        with SubcontractLinks do begin
            repeat
                Result := NEXT;
                if Result > 0 then begin
                    SepCount := NS_SeparatorCount("NS_Subcontract No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Subcontract No.");
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
                        until ((NS_SeparatorCount("NS_Subcontract No.") <= Level) and
                               (NS_SeparatorCount("NS_Parent Subcontract No.") = 0))
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

        with SubcontractLinks do begin
            repeat
                Result := NEXT(-1);
                if (Result < 0) and not EOF1 then begin
                    SepCount := NS_SeparatorCount("NS_Subcontract No.");
                    ParentSepCount := NS_SeparatorCount("NS_Parent Subcontract No.");
                    if (SepCount > Level) and
                       (ParentSepCount = 0) then begin
                        EOF2 := false;
                        repeat
                            if NEXT(-1) = 0 then
                                EOF2 := true;
                            SepCount := NS_SeparatorCount("NS_Subcontract No.");
                            ParentSepCount := NS_SeparatorCount("NS_Parent Subcontract No.");
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

    local procedure NS_SubcNoOnAfterValidate();
    begin
        NS_SetPointer
    end;

    local procedure NS_SubcontractCode1OnFormat();
    begin
        if BoldThisLine then
            "Subcontract No.Emphasize" := true;
    end;

    local procedure NS_SubcontractCode2OnFormat();
    begin
        if BoldThisLine then
            "Subcontract No. 2Emphasize" := true;
    end;

    local procedure NS_DescriptionOnFormat();
    begin
        if BoldThisLine then
            DescriptionEmphasize := true;
    end;

    local procedure NS_BudgetedCostLCYOnFormat();
    begin
        if BoldThisLine then
            "Budgeted CostEmphasize" := true;
    end;

    local procedure NS_BuyfromVendorNoOnFormat();
    begin
        if BoldThisLine then
            "Buy-from Vendor No.Emphasize" := true;
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

