page 14021100 "NS_Job MaterialPlanningJournal"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Job Material Planning Journal';
    PageType = List;
    SourceTable = "NS_JMP Journal Line";
    ApplicationArea = Jobs;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Job No.';
                }
                field("JMP Line No."; Rec."NS_JMP Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Line No.';
                }
                field("JMP Document No."; Rec."NS_JMP Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Document No.';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Description';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Quantity';
                }
                field("Bal. Req"; Rec."NS_Bal. Req")
                {
                    ApplicationArea = All;
                    ToolTip = 'Balance Req.';
                }
                field("Vendor No."; Rec."NS_Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Vendor No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NS_Purchase)
            {
                ApplicationArea = All;
                Caption = 'Purchase';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Purchase';

                trigger OnAction();
                var
                begin
                    NS_CreatePurchaseOrders("NS_Job No.", USERID);
                    CurrPage.UPDATE();
                end;
            }
        }
    }

    trigger OnClosePage();
    begin
        CleanupJournal(USERID);
    end;

    trigger OnOpenPage();
    begin
        CleanupJournal(USERID);
        LoadJournalLines("NS_Job No.");
    end;
}

