page 14021430 "NS_Export /Import Lines"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0 1July21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    AutoSplitKey = true;
    PageType = ListPart;
    Permissions = TableData "NS_Export/Import Excel Header" = rimd,
                  TableData "NS_Export / Import Excel Line" = rimd;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = "NS_Export / Import Excel Line";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Caption = 'Export /Import Lines';//PRJ-659.RS.1.0 1July21 Caption Added

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Field No."; Rec."NS_Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Field No.';
                }
                field("Field Name"; Rec."NS_Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Field Name';
                }
                field("Field Caption"; Rec."NS_Field Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Field Caption';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field(Source; Rec.NS_Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field(KeyIndex; Rec.NS_KeyIndex)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the KeyIndex';
                }
                field("Field Validate"; Rec."NS_Field Validate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Field Validate';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean;
    begin
        if NS_KeyIndex > 0 then
            ERROR(Text000Lbl);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        NS_CheckDublicate();
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        NS_CheckDublicate();
    end;

    var
        EIEHandler: Codeunit "NS_ExportImport Excel Handle";
        Text000Lbl: Label 'A field which is part of the primary key cannot be deleted.';
        Text001Lbl: Label 'Field no. %1 has already been selected for this mapping', Comment = '%1=Field No.';

    procedure NS_AutomapColumn();
    begin
        CLEAR(EIEHandler);
        EIEHandler.NS_AutoMapFields(Rec);
    end;

    procedure NS_CheckDublicate();
    var
        EIELines: Record "NS_Export / Import Excel Line";
    begin
        EIELines.RESET();
        EIELines.SETRANGE(NS_Code, NS_Code);
        EIELines.SETRANGE("NS_Table no.", "NS_Table no.");
        EIELines.SETRANGE("NS_Field No.", "NS_Field No.");
        if EIELines.FIND('-') then begin
            if EIELines."NS_Line No." <> "NS_Line No." then
                ERROR(Text001Lbl, "NS_Field No.");
        end;

    end;
}

