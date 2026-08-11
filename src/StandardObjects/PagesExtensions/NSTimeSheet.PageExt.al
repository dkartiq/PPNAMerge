pageextension 14021274 NS_TimeSheet extends "Time Sheet"
{
    // version NAVW111.00.00.23572,PPNA11.00
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +     "Skill Class"
    // +     "Correction"
    // +
    // +  - Added global variable(s):
    // +     NS_UserSetup
    // +     AllowCorrection
    // +
    // +  - Modification(s):
    // +     - OnOpenPage: Set variable to control whether or not Correction column is shown and editable
    // +     - ValidateQuantity: call Time Sheet Detail's NS_CalculateWages() after assigning Quantity
    // +     - set as Visible=TRUE: Cause of Absence Code, Job No., Job Task No., Work Type Code
    // +------------------------------------------------------------
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Time Sheet'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Cause of Absence Code")
        {
            field("NS_Skill Class"; '')//PE-68 Dk.1.0 10April2023
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Skill Class';
                Visible = false;//PE-68 Dk.1.0 10April2023

            }
            //PE-68 Dk.1.0 10April2023 Start
            field("NS_Skill Class New"; rec."NS_Skill Class New")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Skill Class';
            }
            //PE-68 Dk.1.0 10April2023 End
        }
        addafter("Assembly Order No.")
        {
            field(NS_Correction; Rec.NS_Correction)
            {
                ApplicationArea = All;
                Editable = AllowCorrection;
                ToolTip = 'Specifies whether to allow a Correction';
                Visible = AllowCorrection;
            }
        }
    }

    var
        AllowCorrection: Boolean;
        NS_UserSetup: Record "User Setup";
        CellData: ARRAY[32] OF Decimal;
        NoOfColumns: Integer;
        TimeSheetDetail: Record 952;
        ColumnRecords: ARRAY[32] OF Record 2000000007;
        TimeSheetHeader: Record 950;
        AllowEdit: Boolean;
        Text001: Label 'The type of time sheet line cannot be empty.';

    trigger OnOpenPage();

    begin
        AllowCorrection := false;
        NS_UserSetup.GET(USERID);
        if NS_UserSetup."Time Sheet Admin." then
            AllowCorrection := true;
    end;

}

