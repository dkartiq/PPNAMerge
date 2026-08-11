tableextension 14021141 NS_ShipToAddress extends "Ship-to Address"
{
    // version NAVW111.00,NAVNA11.00,PPNA11.00
    //PRJ-464.AM.1.0 | Inverted comma in Option issue resolve.

    fields
    {
        field(14021415; "NS_Table ID"; Integer)
        {
            Caption = 'Table ID';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_Address Type"; Option)
        {
            Caption = 'Address Type';
            Description = 'Project Pro';
            OptionCaption = ' ,Sell-to,Bill-to,Ship-to';//PRJ-464.AM.1.0 
            OptionMembers = " ","Sell-to","Bill-to","Ship-to";
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            DataClassification = CustomerContent;
            Description = 'Project Pro';
        }
        field(14021418; "NS_No."; Code[20])
        {
            Caption = 'No.';
            Description = 'Project Pro';
            TableRelation = "NS_Job Quote Header"."NS_Job No.";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "NS_No.")
        {
        }
    }
}

//   +------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +     14021415 Table ID
//   +     14021416 Address Type
//   +     14021417 Contact No.
//   +     14021418 No.
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s)
//   +
//   +  - Modified:
//   +     - Added Key(s):
//   +         No.
//   +------------------------------------------------------------
