pageextension 14021230 NS_ResourceJnlExt extends "Resource Journal"
{
    // version NAVW111.00.00.23572,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Resource Journals'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("NS Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Units';
            }
            field("NS Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Unit of Measure';
            }
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Work Units
    //   +     Work Unit of Measure
    //   +-----------------------------------------------------------------------------------------------

}

