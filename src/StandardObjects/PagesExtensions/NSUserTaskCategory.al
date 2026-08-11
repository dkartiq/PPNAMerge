page 14021368 "NSUserTaskCategory"
{
    //PE-185.NC.1.0 05Oct2023 New Page create
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "NSNumberFilter";
    SourceTableView = sorting("NS_User Task Cue Sequence") where(Type = filter("NS_User Task Category"));
    Caption = 'User Task Category List';
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("NS_User Task Cue Sequence"; Rec."NS_User Task Cue Sequence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Task queue sequence field.';
                    ShowMandatory = true;
                    MinValue = 1;
                    MaxValue = 7;
                }
            }
        }
    }
    trigger OnClosePage()
    begin
        Rec.TestField("NS_User Task Cue Sequence");
    end;
}