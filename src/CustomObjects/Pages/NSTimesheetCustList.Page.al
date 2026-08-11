page 14021332 NS_TimesheeCustomizedList
{
    //PRJ-772.AS.1.0 12July2021 New page
    //PRJCTPR-28.GK.1.0 16March2023 start
    CardPageID = NS_TimesheetCustomizeCard;
    // CardPageID = NS_TimesheetCustomizeDocument; //Requried only for Mobile app
    //PRJCTPR-28.GK.1.0 16March2023 end
    //PE-156.HS.1.0 12SEPT2023| Added Caption
    Caption = 'Crew Time Sheet List';
    Editable = false;
    PageType = List;
    SourceTable = "NS_TimesheetHdrCustom";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_No."; Rec."NS_No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Time Sheet No.'; //PE-156.HS.1.0 12SEPT2023
                }
                field("NS_Description"; Rec."NS_Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Work Period Start Date "; Rec."NS_Work Period Start Date ")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Work Period End Date "; Rec."NS_Work Period End Date ")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Crew code"; Rec."NS_Crew code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Lead crew"; Rec."NS_Lead crew")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}