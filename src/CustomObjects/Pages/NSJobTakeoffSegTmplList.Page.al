page 14021421 "NS_Job Takeoff Seg. Tmpl. List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    DataCaptionFields = NS_Type;
    Caption = 'Job Takeoff Seg. Tmpl. List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Takeoff Segments";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Template Code';
                    ToolTip = 'Job No.';
                }
                field("Segment Name"; Rec."NS_Segment Name")
                {
                    ApplicationArea = All;
                    Caption = 'Template Name';
                    ToolTip = 'Segment Name';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage();
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
    end;

    trigger OnOpenPage();
    begin
        NS_LoadTemplates();
    end;

    local procedure NS_LoadTemplates();
    var
        JobSegments: Record "NS_Job Takeoff Segments";
    begin
        DELETEALL();
        JobSegments.SETRANGE(NS_Type, NS_Type::Template);
        JobSegments.SETRANGE("NS_Segment Code", '0');
        if JobSegments.FINDSET(false, false) then
            repeat
                Rec := JobSegments;
                INSERT();
            until JobSegments.NEXT() = 0;
    end;
}

