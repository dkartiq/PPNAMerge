page 14021352 "NS_ProjectPro My Subcontracts"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'ProjectPro - My Subcontracts';
    PageType = ListPart;
    SourceTable = "NS_My Subcontract";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Subcontract No."; Rec."NS_Subcontract No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract No.';

                    trigger OnValidate();
                    begin
                        NS_GetSubcontract();
                    end;
                }
                field("Subcontract.""Buy-from Vendor No."""; Subcontract."NS_Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    ToolTip = 'Buy-From Vendor No.';
                }
                field(SubcontractorName; SubcontractorName)
                {
                    ApplicationArea = All;
                    Caption = 'Subcontractor Name';
                    Tooltip = 'Subcontractor Name';
                }
                field("Subcontract.Description"; Subcontract.NS_Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Subcontract Description';
                }
                field(SubcontractDetailJobNo; SubcontractDetailJobNo)
                {
                    ApplicationArea = All;
                    Caption = 'Job No.';
                    ToolTip = 'Job No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                Tooltip = 'Open';

                trigger OnAction();
                begin
                    NS_OpenSubcontractCard();
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        NS_GetSubcontract();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(Subcontract);
    end;

    trigger OnOpenPage();
    begin
        SETRANGE("NS_User ID", USERID);
    end;

    var
        Vendor: Record Vendor;
        Subcontract: Record NS_Subcontract;
        SubcontractDetail: Record "NS_Subcontract Lines";
        SubcontractorName: Text[100];


        SubcontractDetailJobNo: Code[20];

    procedure NS_OpenSubcontractCard();
    begin
        if Subcontract.GET("NS_Subcontract No.") then
            PAGE.RUN(PAGE::"NS_Subcontract Card", Subcontract);
    end;

    procedure NS_GetSubcontract();
    begin
        if not Subcontract.GET("NS_Subcontract No.") then
            CLEAR(Subcontract);

        if Vendor.GET(Subcontract."NS_Buy-from Vendor No.") then
            SubcontractorName := Vendor.Name
        else
            SubcontractorName := '';

        SubcontractDetail.RESET();
        SubcontractDetail.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
        if SubcontractDetail.FINDFIRST() then
            SubcontractDetailJobNo := SubcontractDetail."NS_Job No."
        else
            SubcontractDetailJobNo := '';
    end;
}

