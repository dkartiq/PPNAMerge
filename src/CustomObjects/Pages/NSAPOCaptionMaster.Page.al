page 14021394 NS_APOCaptionMaster
//PRJ-1348.NK.1.0 24May2022 New Page Create
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NS_APOCaptionMaster;
    Caption = 'APOS Caption Master';

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(NS_Code; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Code';
                    Caption = 'Code';
                }
                field(NS_Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description';
                    Caption = 'Description';
                    Editable = false;
                }
                field(NS_Source; Rec.NS_Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Source';
                    Caption = 'Source';
                    Editable = false;
                    Visible = false;
                }
                field(NS_Destination; Rec.NS_Destination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Matching';
                    Caption = 'Matching';
                    Editable = false;
                    Visible = false;
                }

            }
        }
    }


}