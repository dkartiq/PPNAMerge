//PE-323.AT.1.0 13Jun24 | Added New Page.
page 14021107 "NS_Linked Resources"
{

    ApplicationArea = All;
    Caption = 'Linked Resources';
    PageType = List;
    SourceTable = "NS_Linked Resources";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("NS_Linked Resource"; Rec."NS_Linked Resource")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specified the Resource No. to be linked with the item.';
                }
                field("NS_Resource Name"; rec."NS_Resource Name")
                {
                    ApplicationArea = All;
                }
                field("NS_Labor Hr. per Qty"; Rec."NS_Labor Hr. per Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many labor hour of the resources are required to be linked with the item.';
                }

                field(NS_Default; Rec.NS_Default)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select at least one resource by default that will appear on the Job Planning page under the "Default Linked Resource" field.';
                }
            }
        }
    }

    //PE-323 AT 12july2024 Start
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckDefault();
    end;

    procedure CheckDefault()
    var
        NS_LinkedResources: Record "NS_Linked Resources";
        NS_LinkedResources1: Record "NS_Linked Resources";
    begin
        if NS_LinkedResources.Get(Rec."NS_Item No.", Rec."NS_Linked Resource") then begin
            NS_LinkedResources1.SetRange("NS_Item No.", Rec."NS_Item No.");
            NS_LinkedResources1.SetRange("NS_Default", true);
            if not NS_LinkedResources1.FindFirst() then
                Error(Error01);
        end;
    end;

    var
        Error01: Label 'You must specify the Default Linked Resource.';
    //PE-323 AT 12july2024 end
}
