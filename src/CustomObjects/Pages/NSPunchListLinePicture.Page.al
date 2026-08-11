/// <summary>
/// Page NSPPPunchListPicture (ID 14021337).
/// </summary>

page 14021337 NS_PunchListPicturePage
{
    //PE-288.JS.1.0 06MAY2024 | Created new Page
    Caption = 'Punch List Image';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = NS_PunchListDailyTasks;



    layout
    {
        area(content)
        {
            field(NSPP_Content; Rec.NSPP_Content)
            {
                Caption = 'Content';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Content field.';
            }
        }
    }

    var
        NSPPTenentMedia: record "Tenant Media";

    trigger OnOpenPage()
    begin
        NSPPTenentMedia.Reset();
        NSPPTenentMedia.setrange(ID, rec."NSPP_Tenent Media ID");
        if NSPPTenentMedia.FindFirst() then begin
            NSPPTenentMedia.CalcFields(Content);
            rec.NSPP_Content := NSPPTenentMedia.Content;
        end;
    end;

}