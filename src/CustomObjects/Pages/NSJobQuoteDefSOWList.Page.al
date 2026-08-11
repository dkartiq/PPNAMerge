page 14021452 "NS_Job Quote Def SOW SelcList"
{

    //PRJ-735.JS.1.0 | New Page default SOW List

    Caption = 'Job Quote Default SOW Selection List';
    DataCaptionFields = "NS_Code";
    PageType = List;
    SourceTable = "NS_Job Quote Def Scope of Work";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(NS_Selected; Rec.NS_Selected)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Selection';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
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
            }
        }
    }

    actions
    {
    }

    var
        NS_JobQuoteNoGlb: Code[20];
        NS_SegmentCodeNoGlb: Code[20];

    procedure NS_InitValue(JobQuoteNo: Code[20]; SegmentCodeNo: Code[20])
    begin
        NS_JobQuoteNoGlb := JobQuoteNo;
        NS_SegmentCodeNoGlb := SegmentCodeNo;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (CloseAction in [ACTION::OK, ACTION::LookupOK]) then
            Rec.NS_CreateSOWLines(Rec, NS_JobQuoteNoGlb, NS_SegmentCodeNoGlb);
    end;



}

