page 14021343 "NS_Progress Payment List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Progress Payment List';
    CardPageID = "NS_Progress Payment Header";
    Editable = false;
    PageType = List;
    SourceTable = "NS_Progress Payment Header";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition No.';
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Version No.';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition Date';
                }
                field("Subcontract.""No."""; Subcontract."NS_No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field("Subcontract.Description"; Subcontract.NS_Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field(SubcontractDescription; SubcontractDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Job Description';
                }
                field(VendorNo; VendorNo)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period To';
                    Visible = false;
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        SubcontractDescription := '';
        VendorNo := '';
        VendorName := '';
        if "NS_Subcontract No." <> '' then
            if Subcontract.GET("NS_Subcontract No.") then begin
                SubcontractDescription := Subcontract.NS_Description;
                VendorNo := Subcontract."NS_Buy-from Vendor No.";
                if VendorNo <> '' then
                    if Vendor.GET(VendorNo) then
                        VendorName := Vendor.Name;
            end;
    end;

    var
        Subcontract: Record NS_Subcontract;
        Vendor: Record Vendor;
        SubcontractDescription: Text[50];
        VendorNo: Code[20];
        VendorName: Text[50];
}

