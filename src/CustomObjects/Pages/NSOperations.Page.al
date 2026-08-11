page 14021158 NS_Operations
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Operations';
    DataCaptionFields = "NS_Process Code";
    PageType = list;//PRJ-688.AM.1.0
    SourceTable = "NS_Job Operation";
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
    //PRJ-688.AM.1.0 Start
    actions
    {
        area(processing)
        {
            action("&Sections")
            {
                ApplicationArea = All;
                Caption = 'Sections';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page NS_Sections;
                RunPageLink = NS_Type = FIELD(NS_Type),
                              "NS_Activity Code" = FIELD("NS_Activity Code"),
                              "NS_Process Code" = FIELD("NS_Process Code"),
                              "NS_Operation Code" = Field(NS_Code);

                ToolTip = 'Specifies the &Sections';
            }
        }
    }
    //PRJ-688.AM.1.0 End
}

