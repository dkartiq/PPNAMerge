table 14021404 "NS_Job Quote Sel. Buf."
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PPAL-83.AS.1.0 04SEPT2020 Increased length from 20 chars to 500 chars
    Caption = 'Quote Selection Buffer';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(21; NS_Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
        }
        field(3001; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = '" ,G/L Account,Item,Resource"';
            OptionMembers = " ","G/L Account",Item,Resource;
            DataClassification = CustomerContent;
        }
        field(3006; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3007; "NS_No. 2"; Code[30])
        {
            Caption = 'Mfg. Item No.';
            DataClassification = CustomerContent;
        }
        field(3011; NS_Description; Text[500])//PPAL-83.AS.1.0 04SEPT2020
        {
            Caption = 'Description';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(3021; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(3026; "NS_Unit of Measure Code"; Code[20])//PPAL-83.AS.1.0 04SEPT2020
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
        }
        field(3041; "NS_Category Code"; Code[20])//PPAL-83.AS.1.0 04SEPT2020
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
        }
        field(3106; "NS_Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(3121; NS_Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(3122; "NS_Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            DataClassification = CustomerContent;
        }
        field(3136; "NS_Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;
        }
        field(3137; "NS_Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = CustomerContent;
        }
        field(3200; "NS_Equipment Subtotal"; Decimal)
        {
            Caption = 'Equipment Subtotal';
            DataClassification = CustomerContent;
        }
        field(3210; NS_Freight; Decimal)
        {
            Caption = 'Freight';
            DataClassification = CustomerContent;
        }
        field(3211; "NS_Installation Subtotal"; Decimal)
        {
            Caption = 'Installation Subtotal';
            DataClassification = CustomerContent;
        }
        field(3214; "NS_Bonds Subtotal"; Decimal)
        {
            Caption = 'Bonds Subtotal';
            DataClassification = CustomerContent;
        }
        field(3216; "NS_Service Subtotal"; Decimal)
        {
            Caption = 'Service Subtotal';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[100])//PPAL-83.AS.1.0 04SEPT2020 From 50 to 1oo
        {
            Caption = 'Created by';
            DataClassification = CustomerContent;
        }
        field(5002; "NS_Header Comment"; Boolean)
        {
            Caption = 'Header Comment';
            DataClassification = CustomerContent;
        }
        field(5003; NS_Name; Text[100])//PPAL-83.AS.1.0 04SEPT2020 From 50 to 1oo
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Category Code", NS_Type, NS_Description)
        {
        }
        key(Key3; "NS_Category Code", NS_Type, "NS_No. 2")
        {
        }
        key(Key4; "NS_Quote No.", "NS_Created by")
        {
        }
    }

    fieldgroups
    {
    }
}

