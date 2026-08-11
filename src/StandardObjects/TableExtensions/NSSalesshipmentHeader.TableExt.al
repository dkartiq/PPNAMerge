tableextension 14021118 NS_SalesShipmentHeader extends "Sales Shipment Header"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00

    fields
    {

        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'ProjectPro';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
    var
    //PP_SalesSetup: Record "Sales & Receivables Setup";
    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job No.
      +     14021101 Retention Ledger Code
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Onlookup modified
      +         Applies-to Doc. No.
      +     - Added call to Navigate with Normal Customer Ledger No. parameter
      +-----------------------------------------------------------------------------------------------*/
}

