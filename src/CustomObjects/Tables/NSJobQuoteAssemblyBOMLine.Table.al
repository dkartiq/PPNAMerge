table 14021437 "NS_Job Quote Assembly BOM Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Quote Assembly BOM Line';

    fields
    {
        field(1; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Quote Header";
        }
        field(2; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = "NS_Assembly BOM Header";

            trigger OnValidate();
            var
                ABOM: Record "Ns_Assembly BOM Header";
            begin
                if "NS_No." = '' then
                    exit;

                ABOM.SETRANGE("NS_No.", "NS_No.");
                if ABOM.FINDFIRST() and (NS_Description = '') then
                    NS_Description := ABOM.NS_Description;
            end;
        }
        field(3; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; NS_Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", "NS_No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

