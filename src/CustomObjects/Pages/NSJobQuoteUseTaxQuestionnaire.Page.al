page 14021412 "NS_JobQuoteUseTaxQuestionnaire"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Use Tax Questionnaire';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    ShowFilter = false;
    SourceTable = "NS_Job Quote Header";

    layout
    {
        area(content)
        {
            group(NS_Eligibility)
            {
                Caption = 'Eligibility';
                field("Use Tax Qualify Response 1"; Rec."NS_Use Tax Qualify Response 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Eligibility';
                    Caption = '1. Is any of the property going to be permanently attached to the ground, building or other real property?';
                }
                field("Use Tax Qualify Response 2"; Rec."NS_Use Tax Qualify Response 2")
                {
                    ApplicationArea = All;
                    ToolTip = '2. Will the removal of any of the property cause substantial damage to the surrounding area?';

                    Caption = '2. Will the removal of any of the property cause substantial damage to the surrounding area?';
                }
                field("Use Tax Qualify Response 3"; Rec."NS_Use Tax Qualify Response 3")
                {
                    ApplicationArea = All;
                    ToolTip = '3. Will removal of the property cause substantial damage to the surrounding area?';

                    Caption = '3. Will removal of the property cause substantial damage to the surrounding area?';
                    Visible = false;
                }
                field("Use Tax Qualify Response 4"; Rec."NS_Use Tax Qualify Response 4")
                {
                    ApplicationArea = All;
                    ToolTip = '4. Is the tangible personal property installed with concrete?';

                    Caption = '4. Is the tangible personal property installed with concrete?';
                    Visible = false;
                }
                field("Use Tax Qualify Response 5"; Rec."NS_Use Tax Qualify Response 5")
                {
                    ApplicationArea = All;
                    Caption = '5. Will the property be installed underground?';
                    ToolTip = '5. Will the property be installed underground?';

                    Visible = false;
                }
                field("Use Tax Qualify Response 6"; Rec."NS_Use Tax Qualify Response 6")
                {
                    ApplicationArea = All;
                    Caption = '6. Will the property need to be replaced regularly?';
                    Visible = false;
                    ToolTip = '6. Will the property need to be replaced regularly?';

                }
                field("Use Tax Qualify Response 7"; Rec."NS_Use Tax Qualify Response 7")
                {
                    ApplicationArea = All;
                    ToolTip = '7. Is the property installed above ground by bolts only?';

                    Caption = '7. Is the property installed above ground by bolts only?';
                    Visible = false;
                }
                field("Use Tax Qualify Response 8"; Rec."NS_Use Tax Qualify Response 8")
                {
                    ApplicationArea = All;
                    Caption = '8. Will the property be permanently installed in a building, for example in a basement or wiring/plumbing within the walls?';
                    Visible = false;
                    ToolTip = '8. Will the property be permanently installed in a building, for example in a basement or wiring/plumbing within the walls?';

                }
                field("Use Tax Qualify Response 9"; Rec."NS_Use Tax Qualify Response 9")
                {
                    ApplicationArea = All;
                    Caption = '9. Does the property become part of an existing building, structure or real property?';
                    Visible = false;
                    ToolTip = '9. Does the property become part of an existing building, structure or real property?';

                }
                field("Use Tax Qualify Response 10"; Rec."NS_Use Tax Qualify Response 10")
                {
                    ApplicationArea = All;
                    Caption = '10. Does the property lose its identity when installed?';
                    Visible = false;
                    ToolTip = '10. Does the property lose its identity when installed?';

                }
            }
            group(Required)
            {
                Caption = 'Required';
                field("Use Tax- Contractor Status"; Rec."NS_Use Tax- Contractor Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Contractor Status';
                }
                field("Use Tax- Contract Type"; Rec."NS_Use Tax- Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Contract Type';
                }
                field("Use Tax- Property Type"; Rec."NS_Use Tax- Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Property Type';
                }
                field("Use Tax- Project Type"; Rec."NS_Use Tax- Project Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Project Type';
                }
                field("Use Tax- Downstr. Cont. Status"; Rec."NS_Use Tax- DownstrContStatus")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Downstr. Cont. Status';
                }
                field("Use Tax- Charge Type"; Rec."NS_Use Tax- Charge Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Charge Type';
                }
                field("Use Tax- ChargeType Detail"; Rec."NS_Use Tax- ChargeType Detail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- ChargeType Detail';
                }
                field("Use Tax- Potent. Proj. Exempt."; Rec."NS_Use Tax-PotentProjExempt.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Use Tax- Potent. Proj. Exempt.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        if "NS_Quote No." = '' then
            ERROR(Text000Lbl, TABLECAPTION);
    end;

    var
        Text000Lbl: Label 'This page must be launched from the %1.', Comment = '%1=TABLECAPTION';
}

