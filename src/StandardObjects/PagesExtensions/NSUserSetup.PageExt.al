pageextension 14021141 NS_UserSetup extends "User Setup"
{
    // version NAVW111.00,PPNA11.00
    //JD-54.AM.1.0 Added Field on page .
    //CTSI-274.AM.1.0 Added new field
    //CTSI-254.AM.1.0 Added New Field.
    //PRJ-975.GK.1.0 21Oct2021 |Add new field.
    layout
    {
        addafter(Email)
        {
            field("NS_Allow FA Posting From"; Rec."Allow FA Posting From")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allow FA Posting From';
            }
            field("NS_Allow FA Posting To"; Rec."Allow FA Posting To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allow FA Posting To';
            }
            //JD-54.AM.1.0 Start
            field("NS_Unlock DFR"; Rec."NS_Unlock DFR")
            {
                ApplicationArea = all;
                Caption = 'Unlock DFR';
            }
            //JD-54.AM.1.0 Start

            field("NS_Allow Forecast Deletion"; REC."NS_Allow Forecast Deletion")
            {
                ApplicationArea = all;
                Description = 'CTSI-207.MS.1.0';
            }

            //CTSI-254.AM - Start
            field("NS_Modify Project Summary Details"; REC."NS_Modify Project Summary Details")
            {
                ApplicationArea = all;
                Description = '//PRJ-585.AS.1.0 16MARCH2021';
            }
            //CTSI-254.AM
            field("NS_Access to Job Burden Allocation Batch"; REC."NS_Access to Job Burden Allocation Batch")
            {
                ApplicationArea = all;
            }
            //CTSI-254.AM
            //CTSI-254.AM - End
            //CTSI-274.AM.1.0 start
            field("NS_AccessTo Rev.RecognitionReport"; REC."NS_AccessTo Rev.RecognitionReport")
            {
                ApplicationArea = all;
            }
            //CTSI-274.AM.1.0 End
            field("NS_Overwrite JFW Date Setup"; REC."NS_Overwrite JFW Date Setup")
            {
                ApplicationArea = all;
                Description = 'CTSI-268';
            }
            field("NS_Modify Revenue Recognized Job"; REC."NS_Modify Revenue Recognized Job")
            {
                ApplicationArea = all;
                Description = 'CTSI-285.MS.1.0';
            }
            //PRJ-975.GK.1.0 21Oct2021 start
            field("NS_Enable Lien Release Print"; Rec."NS_Enable Lien Release Print")
            {
                ToolTip = 'Specifies the value of the Enable Lien Release Print field.';
                ApplicationArea = All;
                Description = 'PRJ-975.GK.1.0';
            }
            //PRJ-975.GK.1.0 21Oct2021 end

        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Allow FA Posting From
    //   +     Allow FA Posting To
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

