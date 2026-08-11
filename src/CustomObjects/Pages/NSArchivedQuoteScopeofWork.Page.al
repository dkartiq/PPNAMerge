page 14021442 "NS_Archived Quote ScopeofWork"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0 17June21 | NS_ should be removed from every page rest mention the page ID and Name.
    //PRJ-872.JS.1.0  13Sep2021

    Caption = 'Archived Quote Scope of Work';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "NS_Archived Quote ScopeofWork";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Editable = false;     //PRJ-872.JS.1.0  13Sep2021

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    Caption = 'Job No.';//PRJ-659.RS.1.0 17June21
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Code';
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Segment Name';
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Line No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Description 2"; Rec."NS_Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description 2';
                }
                field(Details; Rec.NS_Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Details';
                }
            }
        }
    }

    actions
    {
    }
}

