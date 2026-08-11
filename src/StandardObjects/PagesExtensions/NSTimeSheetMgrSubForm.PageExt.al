/// <summary>
/// PageExtension NS_Time Sheet SubForm (ID 14021177) extends Record Time Sheet Lines Subform.
/// </summary>
///PRJ-1144.JS.1.0 | New Pages
/// //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
pageextension 14021374 "NS_Time Sheet Mgr SubForm" extends "Time Sheet Lines Subform"
{
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022

    layout
    {
        addafter("Cause of Absence Code")
        {

            field("NS_Crew code"; Rec."NS_Crew code")
            {
                ToolTip = 'Specifies the value of the Crew code';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Lead Person"; Rec."NS_Lead Person")
            {
                ToolTip = 'Specifies the value of the Lead crew';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ToolTip = 'Specifies the value of the Segment Code';
                ApplicationArea = All;
            }

            field("NS_Resource Name New"; Rec."NS_Resource Name New")
            {
                ToolTip = 'Specifies the value of the Resource Name';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Skill Class"; '')//PE-68 Dk.1.0 10April2023
            {
                ToolTip = 'Specifies the Skill Class';
                ApplicationArea = All;
                Editable = false;
                Visible = false;//PE-68 Dk.1.0 10April2023

            }
            //PE-68 Dk.1.0 10April2023 Start
            field("NS_Skill Class New"; Rec."NS_Skill Class New")
            {
                ToolTip = 'Specifies the Skill Class';
                ApplicationArea = All;
                Editable = false;
            }
            //PE-68 Dk.1.0 10April2023 End
            field("NS_Resource No."; Rec."NS_Resource No.")
            {
                ToolTip = 'Specifies the Resource No.';
                ApplicationArea = All;
                Editable = false;
            }

            field("NS_Rejected Remark"; Rec."NS_Rejected Remark")
            {
                ToolTip = 'Specifies the value of the Manager Rejected Remark';
                ApplicationArea = All;
            }
            //PRJCTPR-2.RM.1.0 13Dec2022 start
            field("NS_Union Code"; Rec."NS_Union Code")
            {
                ToolTip = 'Specifies the Union Code';
                ApplicationArea = All;
            }
            //PRJCTPR-2.RM.1.0 13Dec2022 end
        }

    }

    var


    trigger OnOpenPage();

    begin

    end;

}