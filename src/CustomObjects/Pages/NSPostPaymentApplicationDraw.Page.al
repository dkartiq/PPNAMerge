page 14021223 "NS_Post PaymentApplicationDraw"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Post Application';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocNo; DocNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the Document No.';
                }
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the Posting Date';
                }
                field(UpdateDueDate; UpdateDueDate)
                {
                    ApplicationArea = All;
                    Caption = 'Update Draw No. document  due dates';
                    ToolTip = 'Specifies the Update Draw No. document  due dates';
                }
            }
        }
    }

    actions
    {
    }

    var
        DocNo: Code[20];
        PostingDate: Date;
        UpdateDueDate: Boolean;

    procedure NS_SetValues(NewDocNo: Code[20]; NewPostingDate: Date; NewUpdateDueDate: Boolean);
    begin
        DocNo := NewDocNo;
        PostingDate := NewPostingDate;
        UpdateDueDate := NewUpdateDueDate;
    end;

    procedure NS_GetValues(var NewDocNo: Code[20]; var NewPostingDate: Date; var NewUpdateDueDate: Boolean);
    begin
        NewDocNo := DocNo;
        NewPostingDate := PostingDate;
        NewUpdateDueDate := UpdateDueDate;
    end;
}

