page 14021497 NS_Sections
{
    // PRJ-688.AM.1.0 Added New page .

    Caption = 'Sections';
    DataCaptionFields = "NS_Operation Code";
    PageType = list;
    SourceTable = NS_Sections;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Activity Code"; Rec."NS_Activity Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Activity Code';
                }
                field("Process Code"; Rec."NS_Process Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Process Code';
                }
                field("NS_Operation Code"; Rec."NS_Operation Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Operation Code';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field("Search Code"; Rec."NS_Search Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Search Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Default onto each Job"; Rec."NS_Default onto each Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default onto each Job';
                }
                field("Default Project Burden Percent"; Rec."NS_DefaultProjectBurdenPercent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Project Burden Percent';
                }
                field("Default Service Burden Percent"; Rec."NS_DefaultServiceBurdenPercent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Service Burden Percent';
                }
                field("Default Task for Job Type"; Rec."NS_DefaultTaskforJobType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Default Task for Job Type';
                }
            }
        }
    }
}

