pageextension 14021130 NS_ResourceList extends "Resource List"
{
    // version NAVW111.00.00.22292,NAVNA11.00.00.22292,PPNA11.00
    //PRJ-991.GK.2.0 22Oct2021 | add field
    layout
    {
        addafter("Search Name")
        {
            field("NS_No. Of Active Jobs"; Rec."NS_No. Of Active Jobs")
            {
                ApplicationArea = all;
                trigger OnDrillDown()
                var
                    NS_jobCrewResource: Page "NS_ Job Crew Resource List";
                    NS_JCR: Record "NS_Job Crew Resource";
                begin
                    NS_JCR.Reset();
                    NS_JCR.FilterGroup(2);
                    NS_JCR.SetRange("NS_Resource No.", Rec."No.");
                    NS_JCR.FilterGroup(0);
                    NS_jobCrewResource.SetTableView(NS_JCR);
                    NS_jobCrewResource.RunModal();

                end;
            }
        }
    }

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
      +     - Menus:
      +        - Modify action list:
      +           Modify title from Prices to Cost/Price
      +-----------------------------------------------------------------------------------------------
    */

}

