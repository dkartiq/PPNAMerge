/// <summary>
/// TableExtension NS_GLAccountExt (ID 14021399) extends Record G/L Account.
/// </summary>
//PRJ-1089.GK.1.0 28Dec2021 |Add this table extension to create New field Cost Category.
tableextension 14021399 NS_GLAccountExt extends "G/L Account"
{
    fields
    {
        field(14021101; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Cost Category";
        }

    }

}