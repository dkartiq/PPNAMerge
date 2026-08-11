page 14021220 "NS_Project File Name"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    PageType = Card;
    Caption = 'Project File Name';
    SourceTable = Job;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the No.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Description';
            }
            field("OS File Name"; Rec."NS_OS File Name")
            {
                ApplicationArea = All;
                Caption = 'Full File Path and Name';
                ToolTip = 'Specifies the Full File Path and Name';
            }
        }
    }

    actions
    {
    }
}

