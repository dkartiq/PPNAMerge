page 14021302 "NS_Subcontract List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    // +------------------------------------------------------------

    Caption = 'Subcontract List';
    CardPageID = "NS_Subcontract Card";
    DataCaptionFields = "NS_No.";
    PageType = List;
    SourceTable = NS_Subcontract;
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("NS_Subcon Class"; "NS_Subcon Class")//PRJ-533.AS.1.0
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcon Class';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Description"; Job.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job.Description';
                }
                field("Buy-from Name"; Rec."NS_Buy-from Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Buy-from Name';
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                }
                field("Ending Date"; Rec."NS_Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ending Date';
                }
                field("Completion Date"; Rec."NS_Completion Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Completion Date';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Person Responsible';
                }
                field("Budgeted Cost (LCY)"; Rec."NS_Budgeted Cost (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budgeted Cost (LCY)';
                }
                field("Usage (Cost) (LCY)"; Rec."NS_Usage (Cost) (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Usage (Cost) (LCY)';
                    Visible = false;
                }
                field("Subcontract Usage Cost (LCY)"; Rec."NS_SubcontractUsageCost(LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Subcontract Usage Cost (LCY)';
                }
                field("Sub-Level to Subcontract No."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sub-Level to Subcontract No.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Subcontract")
            {
                Caption = '&Subcontract';
                action("NS_Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(NS_Quote),
                                  "No." = FIELD("NS_No.");
                    ToolTip = 'View comments';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("NS_Dimensions-Single")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(14021300),
                                      "No." = FIELD("NS_No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View/edit dimensions.';
                    }
                    action("NS_Dimensions-&Multiple")
                    {
                        ApplicationArea = All;
                        Caption = 'Dimensions-&Multiple';
                        ToolTip = 'View/edit dimensions.';

                        trigger OnAction();
                        var
                            Subcontract: Record NS_Subcontract;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Subcontract);
                            DefaultDimMultiple.SetMultiSubContract(Subcontract);
                            DefaultDimMultiple.RUNMODAL();
                        end;
                    }
                }
                action("NS_Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = JobLedger;
                    RunObject = Page "NS_Subcontract Ledger Entries";
                    RunPageLink = "NS_Subcontract No." = FIELD("NS_No.");
                    RunPageView = SORTING("NS_Subcontract No.", "NS_Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View subcontract ledger entries.';
                }
            }
        }
        area(reporting)
        {
            action("NS_Subcontract Status by Vendor")
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Vendor';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status byVendor";
                ToolTip = 'Run Subcontract Status by Vendor report.';
            }
            action("NS_Subcontract Status by Job")
            {
                ApplicationArea = All;
                Caption = 'Subcontract Status by Job';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "NS_Subcontract Status by Job";
                ToolTip = 'Run Subcontract Status by Job report.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SubcontractDescription := '';
        VendorNo := '';
        VendorName := '';
        if "NS_No." <> '' then
            if Subcontract.GET("NS_No.") then begin
                SubcontractDescription := Subcontract.NS_Description;
                VendorNo := Subcontract."NS_Buy-from Vendor No.";
                if VendorNo <> '' then
                    if Vendor.GET(VendorNo) then
                        VendorName := Vendor.Name;
            end;
    end;

    trigger OnOpenPage();
    begin
        if VendorNo > '' then
            SETRANGE("NS_Buy-from Vendor No.", VendorNo);
    end;

    var
        Job: Record Job;
        Subcontract: Record NS_Subcontract;
        Vendor: Record Vendor;
        VendorNo: Code[20];
        SubcontractDescription: Text[50];
        VendorName: Text[100]; //PRJ-301.MS.1.0

    procedure NS_SetVendor(VendNo: Code[20]);
    begin
        VendorNo := VendNo;
    end;
}

