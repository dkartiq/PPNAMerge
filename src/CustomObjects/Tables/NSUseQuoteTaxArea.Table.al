table 14021430 "NS_Use Quote Tax Area"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Use Quote Tax Area';

    fields
    {
        field(10; "NS_Use Tax Area Code"; Code[10])
        {
            Caption = 'Use Tax Area Code';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Use Tax Percentage"; Decimal)
        {
            Caption = 'Use Tax Percentage';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Use Tax Area Code")
        {
        }
    }

    fieldgroups
    {
    }
}

