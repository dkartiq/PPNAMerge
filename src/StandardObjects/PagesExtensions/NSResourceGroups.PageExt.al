pageextension 14021128 NS_ResourceGroups extends "Resource Groups"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Resource Groups'; //PRJ-1330.NK.1.0 25Apr2022
    actions
    {
        modify("&Prices")
        {
            Caption = 'Cost/&Price';
        }
    }

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - Modify action list:
      +         Modify title from Prices to Cost/Price
      +-----------------------------------------------------------------------------------------------
    */
}

