tableextension 14021227 NS_ItemVariant extends "Item Variant"
{
    // version NAVW17.00,PPNA11.00

    fields
    {
        field(14021400; "NS_Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Core Credit Item"; Boolean)
        {
            Caption = 'Core Credit Item';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Core Credit Amount"; Decimal)
        {
            Caption = 'Core Credit Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Core Credit Item Charge"; Code[20])
        {
            Caption = 'Core Credit Item Charge';
            Description = 'ProjectPro';
            TableRelation = "Item Charge";
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Core Value"; Decimal)
        {
            Caption = 'Core Value';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021405; NS_Default; Boolean)
        {
            Caption = 'Default';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                ItemVariant: Record "Item Variant";
            begin
                ItemVariant.SETRANGE("Item No.", "Item No.");
                ItemVariant.SETFILTER(Code, '<>%1', Code);
                ItemVariant.SETRANGE(NS_Default, true);
                if ItemVariant.FINDFIRST then
                    ERROR(Text14021400, ItemVariant.Code);
            end;
        }
    }

    var
        Text14021400: Label 'Variant %1 is already set as default, please remove default for variant %1 to set default for this variant.';
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021400 Unit Price
//   +     14021401 Core Credit Item
//   +     14021402 Core Credit Amount
//   +     14021403 Core Credit Item Charge
//   +     14021404 Core Value
//   +     14021405 Default
//   +
//   +  - Added global text constant(s):
//   +     Text14021400
//   +
//   +-----------------------------------------------------------------------------------------------