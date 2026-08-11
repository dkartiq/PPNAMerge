page 14021309 "NS_Subcontract Links"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Subcontract Links';
    PageType = Card;
    SourceTable = "NS_Subcontract Links";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            field("Subcontract:"; '')
            {
                ApplicationArea = All;
                CaptionClass = FORMAT(SubcDesc);
                Caption = 'Subcontract:';

                ToolTip = 'Subcontract:';
                Editable = false;
            }
            repeater(Control1100773000)
            {
                field("Parent Subcontract No."; Rec."NS_Parent Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Parent Subcontract No.';

                    trigger OnValidate();
                    begin
                        NS_ParentSubcontractNoOnAfterVali();
                    end;
                }
                field(SubcDescription; SubcDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        SubcontractHeader.GET("NS_Parent Subcontract No.");
        SubcDescription := SubcontractHeader.NS_Description;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        SubcDescription := '';
    end;

    trigger OnOpenPage();
    begin
        CLEAR(ParentSubcontract);
        if "NS_Subcontract No." > '' then
            ParentSubcontract.GET("NS_Subcontract No.");
        SubcDesc := COPYSTR(ParentSubcontract."NS_No." + ' - ' + ParentSubcontract.NS_Description, 1, 50);
    end;

    var
        SubcontractHeader: Record NS_Subcontract;
        ParentSubcontract: Record NS_Subcontract;
        //SubcontractLinkCheck: Record "PP_Subcontract Links";
        SubcDesc: Text[50];
        SubcDescription: Text[50];

    local procedure NS_ParentSubcontractNoOnAfterVali();
    begin
        SubcontractHeader.GET("NS_Parent Subcontract No.");
        SubcDescription := SubcontractHeader.NS_Description
    end;
}

