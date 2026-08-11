/// <summary>
/// Table NS_Where Used Job Calendar (ID 14021172).
/// </summary>
table 14021172 "NS_Where Used Job Calendar"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Where Used Job Calendar';

    fields
    {
        field(1; "NS_Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'Company,Customer,Vendor,Location,Shipping Agent,Service';
            OptionMembers = Company,Customer,Vendor,Location,"Shipping Agent",Service;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Source Code"; Code[20])
        {
            Caption = 'Source Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Additional Source Code"; Code[20])
        {
            Caption = 'Additional Source Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            TableRelation = "NS_Job Calendar";
            DataClassification = CustomerContent;
        }
        field(5; "NS_Source Name"; Text[50])
        {
            Caption = 'Source Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "NS_Job Custom Changes Exist"; Boolean)
        {
            Caption = 'Job Custom Changes Exist';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job Calendar Code", "NS_Source Type", "NS_Source Code", "NS_Source Name")
        {
        }
    }

    fieldgroups
    {
    }
}

