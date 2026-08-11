page 14021328 "NS_Job Progress Billing List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //CTSI-121.N.S.1.0 18Aug2020 Add field manager & person Responsible
    Caption = 'Job Progress Billing List';
    CardPageID = "NS_Progress Billing Header";
    DataCaptionFields = "NS_No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "NS_Progress Billing Header";

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
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition Date';
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period To';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document No.';
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final';
                    Visible = false;
                }
                //CTSI-121.N.S.1.0 18 Aug2020 Start
                field(Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the manager';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Person Responsible';
                }
                //CTSI-121.N.S.1.0 18 Aug2020 End
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Requisition")
            {
                ApplicationArea = All;
                Caption = 'Show Requisition';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Progress Billing Header";
                RunPageLink = "NS_No." = FIELD("NS_No."),
                              "NS_Requisition No." = FIELD("NS_Requisition No."),
                              "NS_Version No." = FIELD("NS_Version No.");
                RunPageView = SORTING("NS_No.", "NS_Requisition No.", "NS_Version No.");
            }
            separator(Separator1100773004)
            {
            }
            action(DeleteRequistion)
            {
                ApplicationArea = All;
                Caption = 'Delete Requistion';

                ToolTip = 'Delete Requistion';
                Image = Delete;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                begin
                    ProgressBillingManagement.NS_ProgressBillDelete("NS_No.", "NS_Requisition No.", "NS_Version No.");
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean;
    begin
        ProgressBillingManagement.NS_ProgressBillDelete("NS_No.", "NS_Requisition No.", "NS_Version No.");
    end;

    var
        ProgressBillingManagement: Codeunit "NS_Progress Billing Management";
}

