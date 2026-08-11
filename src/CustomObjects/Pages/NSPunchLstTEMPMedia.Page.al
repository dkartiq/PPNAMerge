
/// <summary>
/// Page NSPPTempMedia (ID 14021104).
/// </summary>
page 14021104 NSPunchListTempMedia
{

    //PE-288.JS.1.0 06MAY2024 | Created new Page
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tenant Media";
    caption = 'ProjectPro Tenant Media';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which company this media is created in.';
                }
                field(NSPPContent; Rec.Content)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the picture of the media.';
                }
                field("Creating User"; Rec."Creating User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created the media.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the media.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the file.';
                }
                field(Height; Rec.Height)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Height field.';
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique identifier for this media.';
                }
                field("Mime Type"; Rec."Mime Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file type';
                }
                field("Prohibit Cache"; Rec."Prohibit Cache")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prohibit Cache field.';
                }
                field("Security Token"; Rec."Security Token")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the security token of this media.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Width field.';
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

                trigger OnAction()
                begin

                end;
            }
        }
    }
}