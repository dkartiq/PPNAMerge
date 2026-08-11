tableextension 14021102 NS_GLEntry extends "G/L Entry"
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //PRJ-490.AM.1.0 Added Fields.

    fields
    {
        field(14021128; "NS_Prepayment for Job No."; Code[20])
        {
            Caption = 'Prepayment for Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021129; "NS_Bal. Ledger No."; Code[20])
        {
            Caption = 'Bal. Ledger No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                NS_DimensionValue: Record "Dimension Value";
                NS_JobsSetup: Record "Jobs Setup";
            begin
            end;
        }
        field(14021290; "NS_Is IE Created"; Boolean)
        {
            Caption = 'Is IE Created';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021291; "NS_IE Source"; Code[20])
        {
            Caption = 'IE Source';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021292; "NS_IE Target"; Code[20])
        {
            Caption = 'IE Target';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_FA Job No."; Code[20])
        {
            Caption = 'FA Job No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
        field(14021417; "NS_FA Job Task No."; Code[20])
        {
            Caption = ' FA Job Task No.';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
        field(14021418; "NS_FA Segment Code"; Code[20])
        {
            Caption = 'FA Segment Code';
            Description = 'PRJ-490.AM.1.0';
            DataClassification = CustomerContent;

        }
    }
    /* +------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021128 Prepayment for Job No.
      +     14021129 Bal. Ledger No.
      +     14021290 Is IE Created
      +     14021291 IE Source
      +     14021292 IE Target
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Modifcation(s):
      +------------------------------------------------------------*/

}

