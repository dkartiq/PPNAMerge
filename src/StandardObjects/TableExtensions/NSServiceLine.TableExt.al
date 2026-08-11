tableextension 14021230 NS_ServiceLine extends "Service Line"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,PPNA11.00

    fields
    {
        //PRJCTPR-222.JS.1.0 09NOV2023 - Start
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                NSItem: Record item;
                NSResource: Record Resource;
                NSGLAccount: Record "G/L Account";
            begin
                case Type of
                    Type::Item:
                        begin
                            if "No." <> '' then
                                if NSItem.Get("No.") then
                                    rec."NS_Job Cost Category" := NSItem."NS_Job Cost Category";
                        end;
                    Type::Resource:
                        if "No." <> '' then
                            if NSResource.Get("No.") then
                                rec."NS_Job Cost Category" := NSResource."NS_Job Cost Category";
                    Type::"G/L Account":
                        if "No." <> '' then
                            if NSGLAccount.Get("No.") then
                                rec."NS_Job Cost Category" := NSGLAccount."NS_Cost Category";
                end;
            end;
        }
        //PRJCTPR-222.JS.1.0 09NOV2023 - end
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = "NS_Subcontract Lines"."NS_Subcontract No." WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
    }
}

// +---------------------------------------------------------------------------------------------
// +ProjectPro
// +  - Added field(s):
// +     14021101 Job Cost Category
// +     14021102 Job Revenue Category
// +     14021300 Subcontract No.
// +     14021301 Retention Ledger Code
// +
// +  - Modification(s):
// +     - Add Keys
// +         Shortcut Dimension 2 Code,Bill-to Customer No.,Document Type
// +     - Fields:
// +         Job Planning Line No. - OnValidate() - assign default values for fields
// +                                                     Job Cost Category
// +                                                     Job Revenue Category
// +-----------------------------------------------------------------------------------------------