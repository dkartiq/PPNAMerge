page 14021450 NS_JobListTemplateWise
{
    //PPAL-172.AS.1.0 12 DEC2020 New Page Created

    //Caption = 'Job List'; //PRJ-1051.GK.1.0
    Caption = 'Package List'; //PRJ-1051.GK.1.0
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "NS_Job Quote Line";
    UsageCategory = Administration;
    ApplicationArea = all;
    SourceTableView = WHERE(NS_Type = FILTER(Template));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    OptionCaption = '" ,,,,,Package"';
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                        if NS_Type <> xRec.NS_Type then
                            if NS_Type <> NS_Type::Template then begin
                                MESSAGE(STRSUBSTNO(Text14021400Lbl, FORMAT(NS_Type::Template)));
                                NS_Type := NS_Type::Template;
                            end;
                    end;
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate()
                    var
                        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
                    begin
                        case NS_Type of
                            NS_Type::Template:
                                begin
                                    "NS_Unit of Measure Code" := 'EA';
                                    "NS_Qty. per Unit of Measure" := 1;
                                    NS_Quantity := 1;
                                    CurrPage.SAVERECORD();
                                    if ("NS_No." <> xRec."NS_No.") and (Rec."NS_No." <> '') then begin
                                        if xRec."NS_No." = '' then
                                            QuoteMgt.NS_LoadFromJobTmplPackage("NS_Quote No.", "NS_No.", SegCode)
                                        else
                                            QuoteMgt.NS_OnRenameQuoteLinePackage(Rec, xRec, SegCode);
                                    end;
                                end;
                        end;
                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }

            }
        }
    }

    var
        JobNo: Code[20];
        Text14021400Lbl: Label 'Only Lines of Type %1 are allowed in this section.', Comment = '%1=PP_Type::Template';
        QuoteNo: Code[20];
        SegCode: Code[20];



    trigger OnOpenPage()
    begin

        SetRange("NS_Quote No.", QuoteNo);
        if NS_Type <> xRec.NS_Type then
            if NS_Type <> NS_Type::Template then begin
                NS_Type := NS_Type::Template;
            end;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        NS_Type := NS_Type::Template;
    end;

    trigger OnAfterGetRecord();
    begin
        NS_Type := NS_Type::Template;
    end;

    procedure NS_getQuoteNo(QNo: Code[20]; QSegCode: code[20])
    begin
        QuoteNo := QNo;
        SegCode := QSegCode;
    end;

}

