pageextension 14021130 NS_ResourceList extends "Resource List"
{
    // version NAVW111.00.00.22292,NAVNA11.00.00.22292,PPNA11.00
    //PRJ-991.GK.2.0 22Oct2021 | add field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Resources'; //PRJ-1330.NK.1.0 25Apr2022
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
            //PE-152.JS.1.0 24Aug2023 - Start
            field("NS_Skill Class Code"; Rec."NS_Skill Class Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the resource default Skill Class Code';
                editable = false;
                caption = 'Default Skill Class Code';
            }
            //PE-152.JS.1.0 24Aug2023 - End
            //PE-253.PS.1.0 19Feb2024 Start
            field("NS_Production Work Units"; Rec."NS_Production Work Units")
            {
                ApplicationArea = All;
                Caption = 'Production Work Units';
                ToolTip = 'Enable it if you want to use this resource for posting work units from the Job Daily Log through Job Journal.';

            }
            //PE-253.PS.1.0 19Feb2024 End 
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

