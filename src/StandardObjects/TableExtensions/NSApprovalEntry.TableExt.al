tableextension 14021210 NS_ApprovalEntry extends "Approval Entry"
{
    // version NAVW111.00.00.20783,PPNA11.00

    fields
    {

        //PPNA16.0 Comment Start
        // modify(Status)
        // {
        //     OptionCaption = 'Created,Open,Canceled,Rejected,Approved,Review,Message';
        //     //SPLN: Option values: Review,Message not in use 
        //     //Unsupported feature: Change OptionString on "Status(Field 9)". Please convert manually.
        // }
        //PPNA16.0 Comment End
        field(14021400; "NS_Document Margin %"; Decimal)
        {
            Caption = 'Document Margin %';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Equipment Margin %"; Decimal)
        {
            Caption = 'Equipment Margin %';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Labor Margin %"; Decimal)
        {
            Caption = 'Labor Margin %';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Equipment Only"; Boolean)
        {
            Caption = 'Equipment Only';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Entity Type"; Option)
        {
            Caption = 'Entity Type';
            Description = 'Project Pro';
            OptionCaption = 'Customer,Vendor';
            OptionMembers = Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Entity No."; Code[20])
        {
            Caption = 'Entity No.';
            Description = 'Project Pro';
            TableRelation = IF ("NS_Entity Type" = CONST(Customer)) Customer
            ELSE
            IF ("NS_Entity Type" = CONST(Vendor)) Vendor;
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Entity Name"; Text[50])
        {
            Caption = 'Entity Name';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Last Entry"; Boolean)
        {
            Caption = 'Last Entry';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Entry Text"; Text[250])
        {
            Caption = 'Entry Text';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Release Attempted"; Boolean)
        {
            Caption = 'Release Attempted';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_Install/Service"; Boolean)
        {
            Caption = 'Install/Service';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_Install/Service Approved"; Boolean)
        {
            Caption = 'Install/Service Approved';
            Description = 'Project Pro';
            DataClassification = CustomerContent;
        }
        field(14021412; "NS_Document Area"; Option)
        {
            Caption = 'Document Area';
            Description = 'Project Pro';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
            DataClassification = CustomerContent;
        }
    }
}
