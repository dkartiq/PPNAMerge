page 14021413 "NS_Job Quote Item Search"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Item Search';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = Item;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group("Define Filters")
            {
                Caption = 'Define Filters';
                field(PP_FilterNo2; FilterNo2)
                {
                    ApplicationArea = All;
                    Caption = 'Mfg. Item No. Filter';
                    ToolTip = 'Mfg. Item No. Filter';

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
                field(PP_FilterDesc; FilterDesc)
                {
                    ApplicationArea = All;
                    Caption = 'Description Filter';
                    ToolTip = 'Description Filter';

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
                field(PP_FilterMfgCode; FilterMfgCode)
                {
                    ApplicationArea = All;
                    Caption = 'Mfg. Code Filter';
                    ToolTip = 'Mfg. Code Filter';

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
                field(PP_FilterNo; FilterNo)
                {
                    ApplicationArea = All;
                    Caption = 'J&F Item No. Filter';
                    ToolTip = 'J&F Item No. Filter';

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
                field(PP_FilterItemCat; FilterItemCat)
                {
                    ApplicationArea = All;
                    Caption = 'Item Category Filter';
                    ToolTip = 'Item Category Filter';

                    trigger OnLookup(VAr Text: Text): Boolean;
                    begin
                        NS_LookupFilterItemCat();
                    end;

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
                field(PP_FilterUnitPrice; FilterUnitPrice)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price Filter';
                    ToolTip = 'Unit Price Filter';

                    trigger OnValidate();
                    begin
                        NS_SetLoadFilters();
                        CurrPage.UPDATE(false);
                    end;
                }
            }
            group("Current Filters")
            {
                Caption = 'Current Filters';
                field(PP_FilterText; FilterText)
                {
                    ApplicationArea = All;
                    Caption = 'Filters';
                    Editable = false;
                    ToolTip = 'Filters';
                }
                field(PP_Reccount; Reccount)
                {
                    Caption = 'Records';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Recount';
                }
            }
            repeater(Group)
            {
                field("PP_No. 2"; Rec."No. 2")
                {
                    ApplicationArea = All;
                    Caption = 'Mfg. Item No.';
                    ToolTip = 'Mfg. Item No.';

                    Editable = false;
                }
                field("PP_Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Description';
                    Editable = false;
                }
                field("PP_Manufacturer Code"; Rec."Manufacturer Code")
                {
                    ApplicationArea = All;
                    Caption = 'Manufacturer Code';
                    Editable = false;
                    ToolTip = 'Specifies the Manufacturer Code';
                }
                field("PP_No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'J&F Item No.';
                    Editable = false;
                    ToolTip = 'J&F Item No.';
                }
                field("PP_Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Item Category Code';
                    Caption = 'Item Category Code';
                }
                field("PP_Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Unit Price';
                    Caption = 'Unit Price';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_Car&d")
            {
                ApplicationArea = All;
                Caption = 'Car&d';
                ToolTip = 'Car&d';

                Image = EditLines;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("No.");
                ShortCutKey = 'Shift+F7';
            }
            action("NS_Sort by Description")
            {
                ApplicationArea = All;
                Caption = 'Sort by Description';
                ToolTip = 'Sort by Description';

                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SETCURRENTKEY("Search Description");
                    CurrPage.UPDATE(false);
                end;
            }
            action("NS_Sort by Mfg. Item No.")
            {
                ApplicationArea = All;
                Caption = 'Sort by Mfg. Item No.';
                ToolTip = 'Sort by Mfg. Item No.';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SETCURRENTKEY("No. 2");
                    CurrPage.UPDATE(false);
                end;
            }
            action("NS_Reset All Filters")
            {
                ApplicationArea = All;
                Caption = 'Reset All Filters';

                ToolTip = 'Reset All Filters';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CLEAR(FilterDesc);
                    CLEAR(FilterItemCat);
                    CLEAR(FilterMfgCode);
                    CLEAR(FilterNo);
                    CLEAR(FilterNo2);
                    CLEAR(FilterUnitPrice);
                    NS_SetLoadFilters();
                    CurrPage.UPDATE(false);
                end;
            }
            action(NS_Confirm)
            {
                ApplicationArea = All;
                ToolTip = 'Confirm';
                Caption = 'Confirm';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction();
                begin
                    ItemNoSelected := "No.";
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        NS_SetLoadFilters();
    end;

    var
        FilterDesc: Code[250];
        FilterItemCat: Code[250];
        FilterMfgCode: Code[250];
        FilterNo: Code[250];
        FilterNo2: Code[250];
        FilterUnitPrice: Code[250];
        ItemNoSelected: Code[20];
        Reccount: Integer;
        FilterText: Text[250];

    procedure NS_FilterChar(_string: Text[250]): Boolean;
    begin
        exit((STRPOS(_string, '*') <> 0) or
             (STRPOS(_string, '|') <> 0) or
             (STRPOS(_string, '..') <> 0) or
             (STRPOS(_string, '&') <> 0) or
             (STRPOS(_string, '@') <> 0) or
             (STRPOS(_string, '?') <> 0) or
             (STRPOS(_string, '<') <> 0) or
             (STRPOS(_string, '>') <> 0));
    end;

    procedure NS_GetItemNoSelected(): Code[20];
    begin
        exit(ItemNoSelected);
    end;

    procedure NS_LookupFilterItemCat();
    var
        _ItemCat: Record "Item Category";
    begin
        if FilterItemCat <> '' then begin
            _ItemCat.SETFILTER(Code, FilterItemCat);
            if _ItemCat.FINDFIRST() then;
            _ItemCat.SETRANGE(Code);
        end;
        if PAGE.RUNMODAL(PAGE::"Item Categories", _ItemCat) = ACTION::LookupOK then
            FilterItemCat := _ItemCat.Code;
        NS_SetLoadFilters();
        CurrPage.UPDATE(false);
    end;

    procedure NS_SetLoadFilters();
    begin
        SETFILTER("Item Category Code", FilterItemCat);
        SETFILTER("Manufacturer Code", FilterMfgCode);
        if FilterNo <> '' then
            if not NS_FilterChar(FilterNo) then
                FilterNo := COPYSTR('*' + FilterNo + '*', 1, MAXSTRLEN(FilterNo));
        SETFILTER("No.", FilterNo);
        if FilterNo2 <> '' then
            if not NS_FilterChar(FilterNo2) then
                FilterNo2 := COPYSTR('*' + FilterNo2 + '*', 1, MAXSTRLEN(FilterNo2));
        SETFILTER("No. 2", FilterNo2);
        if FilterDesc <> '' then
            if not NS_FilterChar(FilterDesc) then
                FilterDesc := COPYSTR('*' + FilterDesc + '*', 1, MAXSTRLEN(FilterDesc));
        SETFILTER("Search Description", FilterDesc);
        SETFILTER("Unit Price", FilterUnitPrice);

        Reccount := COUNT;
        FilterText := COPYSTR(GETFILTERS, 1, MAXSTRLEN(FilterText));
    end;
}

