page 14021275 "NS_ProgBillLinesToDelete"
{
    //PRJCTPR-180.AS.1.0 28Aug2023 Created list page

    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "NS_Progress Billing Line";
    Caption = 'Progress Billing Lines Deletion';
    Permissions = tabledata "NS_Progress Billing Line" = rimd;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_Progress Billing No."; Rec."NS_Progress Billing No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;

                }
                field("NS_Item No."; Rec."NS_Item No.")
                {
                    ApplicationArea = All;

                }
                field(NS_Total; Rec.NS_Total)
                {
                    ApplicationArea = All;

                }
                field("NS_Work Amount"; Rec."NS_Work Amount")
                {
                    ApplicationArea = All;

                }
                field(NS_Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    var
        Usersetup: Record "User Setup";

    trigger OnDeleteRecord(): Boolean
    var
        PBLine: Record "NS_Progress Billing Line";
    begin
        if not Usersetup.NS_AllowDelPrgBilllines then
            Error('The current user %1 does not have a permission to delete the Progress Billing lines', USERID);


        PBLine.Reset();
        PBLine.SetRange("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
        PBLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
        PBLine.SetRange("NS_Version No.", Rec."NS_Version No.");
        PBLine.DeleteAll();
    end;

    trigger OnModifyRecord(): Boolean
    var
        PBLine: Record "NS_Progress Billing Line";
    begin
        Error('The current user %1 does not have a permission to modify the Progress Billing lines', USERID);
    end;


    trigger OnOpenPage()
    begin
        if Usersetup.Get(UserId) then;
    end;

    trigger OnAfterGetRecord()
    begin
        if Usersetup.Get(UserId) then;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Usersetup.Get(UserId) then;
    end;
}