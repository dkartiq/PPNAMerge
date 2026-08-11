tableextension 14021124 NS_PurchRcptHeader extends "Purch. Rcpt. Header"
{
    // version NAVW111.00.00.20783,NAVNA11.00.00.20783,PPNA11.00
    //PRJ-1380.NK.1.0 13May2022 | Add Fields
    fields
    {


        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
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
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
        //PRJ-1380.NK.1.0 13May2022 Start
        field(14021330; "NS_Job Purchaser"; Code[20])
        {
            Caption = 'Job Purchaser';
            Description = 'PRJ-1380.NK.1.0';
            DataClassification = CustomerContent;
        }
        field(14021331; "NS_Job Manager"; Code[20])
        {
            Caption = 'Job Manager';
            Description = 'PRJ-1380.NK.1.0';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        //PRJ-1380.NK.1.0 13May2022 End
    }

    var
        PP_PurchSetup: Record "Purchases & Payables Setup";
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021104 Draw No.
      +     14021300 Subcontract No.
      +     14021301 Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_PurchSetup
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Navigate() - set filter to call NavigateForm page as appropriate
      +-----------------------------------------------------------------------------------------------*/
}

