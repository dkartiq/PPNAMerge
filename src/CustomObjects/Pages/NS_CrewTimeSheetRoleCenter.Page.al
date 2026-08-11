page 14021259 NS_CrewTimeSheetRoleCenter
{
    //PE-211.AS.2.0 Created New Page

    Caption = 'Crew Time Sheet Role Center';
    PageType = List;
    SourceTable = NS_TimeSheetLineCustom;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("NS_TimeSheetNo."; Rec."NS_TimeSheetNo.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(NS_Description; Rec.NS_Description)
                {
                    Caption = 'Work Description';
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
                field("NS_Resource No."; Rec."NS_Resource No.")
                {
                    ApplicationArea = All;

                }

                field("NS_Resource Name"; Rec."NS_Resource Name New")
                {
                    ApplicationArea = All;

                }

                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;

                }
                field("NS_Resource Working Hours"; Rec."NS_Resource Working Hours")
                {
                    Caption = 'Working Hours';
                    ApplicationArea = All;
                    ToolTip = 'Specify Resource working hours';
                }

                field("NS_Crew code"; Rec."NS_Crew code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NS_Lead Person"; Rec."NS_Lead Person")
                {
                    ApplicationArea = All;
                    Visible = false;//PE-224.AS.2.0 

                }
                field("NS_LineNo."; Rec."NS_LineNo.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("NS_Working Date"; Rec."NS_Working Date")
                {
                    ApplicationArea = All;

                }
                field(NS_Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                }
                field("NS_Work Type Code"; Rec."NS_Work Type Code")
                {
                    ToolTip = 'Specifies the value of the Work Type field';
                    ApplicationArea = All;
                }

                field("NS_Skill Code"; '')
                {
                    ToolTip = 'Specifies the value of the Skill Code field';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("NS_Skill Code New"; Rec."NS_Skill Code New")
                {
                    ToolTip = 'Specifies the value of the Skill Code field';
                    ApplicationArea = All;
                }
                field("NS_Segment Code"; Rec."NS_Segment Code")
                {
                    ToolTip = 'Specifies the value of the Segment Code field';
                    ApplicationArea = All;
                }

                field("NS_Rejected Remark"; Rec."NS_Rejected Remark")
                {
                    ToolTip = 'Specifies the value of the Managers Rejected Remark for Time Sheet';
                    ApplicationArea = All;
                }
                field("NS_Time Sheet Owner User ID"; Rec."NS_Time Sheet Owner User ID")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Owner User ID field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("NS_Time Sheet Approver User ID"; Rec."NS_Time Sheet Approver User ID")
                {
                    ToolTip = 'Specifies the value of the Time Sheet Approver User ID field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

                field("NS_Union Code"; Rec."NS_Union Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Union Code';
                }
            }
        }

    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnAfterGetCurrRecord()
    begin

    end;

}
