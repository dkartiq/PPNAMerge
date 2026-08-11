page 14021235 NS_TimesheetCustomizedSubform
{
    //PRJ-772.AS.1.0 12July2021 New page
    //PRJ-841.JS.1.0 16Aug2021 | Add field
    //PRJ-842.JS.1.0 16Aug2021 | Add field
    //PRJ-924.JS.1.0 17Sep2021 | Add Field

    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = NS_TimeSheetLineCustom;
    AutoSplitKey = true;
    DelayedInsert = true;
    UsageCategory = Lists;
    ApplicationArea = All;


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
                field("NS_Resource Name"; Rec."NS_Resource Name")
                {
                    ApplicationArea = All;

                }

                //PRJ-924.JS.1.0 17Sep2021-Start
                field("NS_Working Hours"; Rec."NS_Working Hours")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;

                }
                field("NS_Resource Working Hours"; "NS_Resource Working Hours")
                {
                    Caption = 'Working Hours';
                    ApplicationArea = All;
                    ToolTip = 'Specify Resource working hours';
                }
                //PRJ-924.JS.1.0 17Sep2021-end

                field("NS_Crew code"; Rec."NS_Crew code")
                {
                    ApplicationArea = All;

                }
                field("NS_Lead Person"; Rec."NS_Lead Person")
                {
                    ApplicationArea = All;

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

                //PRJ-841.JS.1.0 16Aug2021-Start
                field("NS_Skill Code"; Rec."NS_Skill Code")
                {
                    ToolTip = 'Specifies the value of the Skill Code field';
                    ApplicationArea = All;
                }
                //PRJ-841.JS.1.0 16Aug2021-end
                //PRJ-842.JS.1.0 16Aug2021-start
                field("NS_Segment Code"; Rec."NS_Segment Code")
                {
                    ToolTip = 'Specifies the value of the Segment Code field';
                    ApplicationArea = All;
                }
                //PRJ-842.JS.1.0 16Aug2021-end

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
        IF Rec."NS_Status" = Rec."NS_Status"::Submitted then
            CurrPage.editable(false)
        ELSE
            CurrPage.editable(true);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec."NS_Status" = Rec."NS_Status"::Submitted then
            CurrPage.editable(false)
        ELSE
            CurrPage.editable(true);
    end;

}
