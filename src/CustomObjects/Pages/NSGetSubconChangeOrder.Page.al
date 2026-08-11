/// <summary>
/// Page NS_GetSubConChangeOrder (ID 14021492).
/// </summary>
//PRJ-1036.GK.1.0 22Nov2021 Add new page
page 14021492 NS_GetSubConChangeOrder
{
    PageType = StandardDialog;
    Caption = 'Please select change order Job No.';
    layout
    {
        area(Content)
        {
            group("Change Order Job Number")
            {
                field("Change Order Job"; ChangeOrderJob)
                {
                    ApplicationArea = All;
                    ToolTip = 'Change Order Job'; //PE-75.RM.1.0 23May2023
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LocJob: Record Job;
                    begin
                        LocJob.Reset();
                        LocJob.FilterGroup(2);
                        LocJob.SetRange("NS_Job Class", LocJob."NS_Job Class"::"Change Order");
                        LocJob.SetRange("NS_Sub-Level to Job No.", gSubContract."NS_Job No.");
                        LocJob.FilterGroup(0);
                        If LocJob.FindSet() then;
                        if Page.RunModal(Page::"Job List", LocJob) = Action::LookupOK then begin
                            ChangeOrderJob := LocJob."No.";
                        end
                    end;

                    trigger OnValidate()
                    var
                        LocJob: Record Job;
                    begin
                        if ChangeOrderJob > '' then begin
                            LocJob.Reset();
                            LocJob.SetRange("No.", ChangeOrderJob);
                            If LocJob.FindFirst() then begin
                                if LocJob."NS_Sub-Level to Job No." <> gSubContract."NS_Job No." then
                                    Error('Job %1 does not belong to change order of Subcontract Master Job %2', ChangeOrderJob, gSubContract."NS_Job No.");
                                if LocJob."NS_Job Class" <> LocJob."NS_Job Class"::"Change Order" then
                                    Error('Job Class on Job %1 should be change order', ChangeOrderJob);
                            end else
                                Error('No Change Order found');
                        end;
                    end;
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }

    var
        myInt: Integer;
        ChangeOrderJob: Text;
        gSubContract: Record NS_Subcontract;


    procedure GetValues(VAR pChangeOrderFilter: Text)
    begin
        pChangeOrderFilter := ChangeOrderJob;
    end;

    procedure SetSubCon(NSSubContract: Record NS_Subcontract)
    begin
        gSubContract := NSSubContract;
    end;
}