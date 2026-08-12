page 14021447 "NS_Assembly BOM Lines"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    AutoSplitKey = true;
    Caption = 'Assembly BOM Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "NS_Assembly BOM Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Quantity per"; Rec."NS_Quantity per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity per';
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    var
                        PP_PickAPOCode: Page "NS_Pick APO Code";
                        Description: Text[50];
                        // >> Upgrade
                        JobAct: Code[20];
                    // << Upgrade
                    begin
                        CLEAR(PP_PickAPOCode);
                        PP_PickAPOCode.LOOKUPMODE(true);
                        // >> Upgrade
                        //PP_PickAPOCode.NS_SetInput('', "NS_Job Task No.", 0);
                        PP_PickAPOCode.NS_SetInput('', "NS_Job Task No.", JobAct, 0);
                        // << Upgrade
                        if PP_PickAPOCode.RUNMODAL() = ACTION::LookupOK then
                            // >> Upgrade
                            //PP_PickAPOCode.NS_GetResult("NS_Job Task No.", Description);
                            PP_PickAPOCode.NS_GetResult("NS_Job Task No.", Description, JobAct);
                        // << Upgrade
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

