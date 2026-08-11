pageextension 14021378 NSTimeSheetLineJobDetail extends "Time Sheet Line Job Detail"
{
    //PE-61.NK.1.0 16Mar2023 Create New
    layout
    {
        addafter(Chargeable)
        {
            field("NS_Skill Class"; '') //PE-68 Dk.1.0 10April2023
            {
                ApplicationArea = all;
                Visible = false;//PE-68 Dk.1.0 10April2023
                ToolTip = '';
            }
            //PE-68 Dk.1.0 10April2023 Start
            field("NS_Skill Class New"; Rec."NS_Skill Class New")
            {
                ApplicationArea = all;
                ToolTip = '';
            }
            //PE-68 Dk.1.0 10April2023 End
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TimeSheetHead: Record "Time Sheet Header";
        Resource: Record Resource;
    begin
        if TimeSheetHead.Get(Rec."Time Sheet No.") then;
        if Resource.Get(TimeSheetHead."Resource No.") then;
        Rec."NS_Resource No." := TimeSheetHead."Resource No.";
        Rec."NS_Resource Name New" := Resource.Name;
        //PE-68 Dk.1.0 10April2023 Start
        // if Rec."NS_Skill Class" = '' then
        //     Rec."NS_Skill Class" := Resource."NS_Skill Class Code";
        if Rec."NS_Skill Class New" = '' then
            Rec."NS_Skill Class New" := Resource."NS_Skill Class Code";
        //PE-68 Dk.1.0 10April2023 End
        Rec.Modify();
    end;
}