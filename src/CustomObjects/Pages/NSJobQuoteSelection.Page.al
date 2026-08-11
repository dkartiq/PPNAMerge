page 14021408 "NS_Job Quote Selection"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Job Quote Sel. Buf.";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.NS_Indentation;
                ShowAsTree = true;
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = GroupLine;
                    ToolTip = 'Specifies the Description';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    DecimalPlaces = 0 : 5;
                    Editable = NOT GroupLine;
                    ToolTip = 'Specifies the Quantity';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the No.';
                    Visible = false;
                }
                field("No. 2"; Rec."NS_No. 2")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the No. 2';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("NS_Sort by Description")
            {
                ApplicationArea = All;
                ToolTip = 'Sort By Description';
                Caption = 'Sort by Description';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SETCURRENTKEY("NS_Category Code", NS_Type, NS_Description);
                    CurrPage.UPDATE(false);
                end;
            }
            action("NS_Sort by Mfg. Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sort by Mfg. Item No.';
                Caption = 'Sort by Mfg. Item No.';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    SETCURRENTKEY("NS_Category Code", NS_Type, "NS_No. 2");
                    CurrPage.UPDATE(false);
                end;
            }
            action(NS_Confirm)
            {
                ApplicationArea = All;
                ToolTip = 'Confirm';
                Caption = 'Confirm';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction();
                begin
                    QuoteMgt.NS_QuoteSelectionCopyResults(Rec);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        GroupLine := NS_Type = 0;
    end;

    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        [InDataSet]
        GroupLine: Boolean;
}

