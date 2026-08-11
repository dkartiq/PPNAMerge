tableextension 14021240 NS_ReturnShipmentLineExt extends "Return Shipment Line"
{


    fields
    {
        field(14021100; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            Description = 'PRJ-372.MS.1.0';
            DataClassification = CustomerContent;

        }
        //PRJ-1012.AS.1.0 START
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = '';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        //PRJ-1012.AS.1.0 START

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }

    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021100 Job No.
//   +
//   +-----------------------------------------------------------------------------------------------