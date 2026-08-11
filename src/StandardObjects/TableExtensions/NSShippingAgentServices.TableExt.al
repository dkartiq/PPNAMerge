tableextension 14021228 NS_ShippingAgentServices extends "Shipping Agent Services"
{
    // version NAVW17.00,PPNA11.00

    fields
    {
        field(14021168; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021168 Job Calendar Code
//   +
//   +-----------------------------------------------------------------------------------------------