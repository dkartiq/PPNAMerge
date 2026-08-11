tableextension 14021218 NS_Contact extends Contact
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00

    fields
    {
        field(14021405; "NS_Credit Approval Complete"; Date)
        {
            Caption = 'Credit Approval Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +      14021405 Credit Approval Complete
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - OnDelete: Remove Contact Customer Relation records
//   +     - GetCompNo: Add filter by Type on Contact
//   +-----------------------------------------------------------------------------------------------