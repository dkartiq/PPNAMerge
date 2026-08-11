pageextension 14021271 NS_DefultDimensionsMultiple extends "Default Dimensions-Multiple"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Default Dimensions-Multiple'; //PRJ-1330.NK.1.0 25Apr2022

    var
        TempDefaultDim2: Record 352;

    procedure SetMultiSubContract(var Subcontract: Record NS_Subcontract);
    begin
        //ProjectPro - start
        ClearTempDefaultDim;
        with Subcontract do
            if FINDSET then
                repeat
                    CopyDefaultDimToDefaultDim(DATABASE::NS_Subcontract, "No.");
                until NEXT = 0;
        //ProjectPro - end
    end;

    /*
      +------------------------------------------------------------
      +ProjectPro
      +  - Added function(s):
      +     SetMultiSubcontract()
      +------------------------------------------------------------
    */
}

