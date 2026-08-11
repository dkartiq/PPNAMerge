page 14021411 "NS_Job Quote Scope of Work"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-735.JS.1.0 01Dec2021 | Add procedure

    Caption = 'Scope of Work';
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Scope of Work";

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


    //PRJ-735.JS.1.0 01Dec2021
    actions
    {
        area(processing)
        {
            action(DefaultScopeofworkList)
            {
                Caption = 'Default SOW List';
                Image = ViewPage;
                ApplicationArea = All;
                ToolTip = 'Select Default Scope of work';

                trigger OnAction()
                var
                    DefSOWList: Page "NS_Job Quote Def SOW SelcList";
                begin
                    DefSOWList.NS_InitValue(NS_JobQuoteNoGlb, NS_SegmentCodeNoGlb);
                    DefSOWList.Editable(true);
                    if DefSOWList.RUNMODAL() = ACTION::OK then
                        CurrPage.UPDATE();
                end;
            }
        }
    }

    var
        NS_JobQuoteNoGlb: Code[20];
        NS_SegmentCodeNoGlb: Code[20];


    /// <summary>
    /// NS_InitValue.
    /// </summary>
    /// <param name="JobQuoteNo">Code[20].</param>
    /// <param name="SegmentCodeNo">Code[20].</param>
    procedure NS_InitValue(JobQuoteNo: Code[20]; SegmentCodeNo: Code[20])
    begin
        NS_JobQuoteNoGlb := JobQuoteNo;
        NS_SegmentCodeNoGlb := SegmentCodeNo;
    end;
    //PRJ-735.JS.1.0 01Dec2021 - end

}

