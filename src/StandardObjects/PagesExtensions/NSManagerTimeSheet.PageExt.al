pageextension 14021379 NSManagerTimeSheet extends "Manager Time Sheet"
{
    //PRJ-772.AS.1.0 Added this page extension
    //PRJ-841.JS.1.0 16Aug2021 | add field Resource skill code
    //PRJ-842.JS.1.0 16Aug2021 | add field Resource Segment code
    //PRJ-1242.NK.1.0 16Mar2022 | Unblock Code
    //PRJ-1281.RM.1.0 08April2022 | Added a new field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Manager Time Sheet'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter(ResourceNo)
        {
            //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" start
            // field(NS_TSRecResourecName; TSRec."NS_Resource Name")
            // {
            //     Caption = 'Lead Resource Name';
            //     ApplicationArea = All;
            //     Editable = false;
            //     ToolTip = 'Specifies the Lead Resource Name for Crew Time Sheet';
            // }
            //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" End

            //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" start
            field(NS_TSRecResourecName; TSRec."NS_Resource Name New")
            {
                Caption = 'Lead Resource Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Lead Resource Name for Crew Time Sheet';
            }
            //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" End

            field("NS_Crew Time Sheet Ref. No."; TSRec."NS_Crew Time Sheet Ref. No.")
            {
                Caption = 'Crew Time Sheet Ref. No.';
                ToolTip = 'Specifies the value of the Crew Time Sheet Reference Number';
                ApplicationArea = All;
                Editable = false;
            }
        }

        // Add changes to page layout here
        modify(ResourceNo)  //PRJ-772.AS.2.0
        {
            Caption = 'Lead Resource No.';
            ApplicationArea = All;
        }

        //modify()
        modify(Field1)
        {
            Visible = ColumnHide1;
        }
        modify(Field2)
        {
            Visible = ColumnHide2;
        }
        modify(Field3)
        {
            Visible = ColumnHide3;
        }
        modify(Field4)
        {
            Visible = ColumnHide4;
        }
        modify(Field5)
        {
            Visible = ColumnHide5;
        }
        modify(Field6)
        {
            Visible = ColumnHide6;

        }
        modify(Field7)
        {
            Visible = ColumnHide7;
        }

        addafter(Type)
        {
            field("NS_Job No."; Rec."Job No.")
            {
                Caption = 'Job No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value for Job No.';
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                Caption = 'Job Task No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value for Job Task No.';
            }
            field("NS_Resource No."; Rec."NS_Resource No.")
            {
                Caption = 'Resource No.';
                ApplicationArea = All;
                ToolTip = 'Resource No.';
            }
            //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" START
            // field("NS_Resource Name"; Rec."NS_Resource Name")
            // {
            //     Caption = 'Resource Name';
            //     ApplicationArea = All;
            //     ToolTip = 'Resource Name';
            // }
            //PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name" END

            //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" START
            field("NS_Resource Name"; Rec."NS_Resource Name New")
            {
                Caption = 'Resource Name';
                ApplicationArea = All;
                ToolTip = 'Resource Name';
            }
            //PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New" END

            field("NS_Work Type Code"; Rec."NS_Work Type Code")
            {
                Caption = 'Work Type';
                ToolTip = 'Specifies the value for the Work Type';
                Visible = false; //PE-68.DK.2.0 10july2023
                ApplicationArea = All;
            }
            //PRJ-841.JS.1.0 16Aug2021-Start
            //PRJ-842.JS.1.0 16Aug2021-Start
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ToolTip = 'Specifies the value of the Segment Code';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Skill Code"; '')//PE-68.Dk.1.0 10April2023
            {
                ToolTip = 'Specifies the value of the resouce Skill';
                ApplicationArea = All;
                //Editable = false;//PRJ-1281.RM.1.0
                Visible = false; //PE-68.Dk.1.0 10April2023
                Editable = true; //PRJ-1281.RM.1.0
                TableRelation = "NS_Skill Class";//PRJ-1281.RM.1.0
            }
            //PRJ-841.JS.1.0 16Aug2021-end
            //PRJ-842.JS.1.0 16Aug2021-end  
            //PE-68.Dk.1.0 10April2023 Start
            field("NS_Skill Code New"; Rec."NS_Skill Code New")
            {
                ToolTip = 'Specifies the value of the resouce Skill';
                ApplicationArea = All;
                Editable = true;
                //Visible = NS_IsPermissionToView;//PE-68.Dk.1.0 19may2023
                TableRelation = "NS_Skill Class";
            }
            field("NS_Union Code"; Rec."NS_Union Code")
            {
                ApplicationArea = all;
            }
            //PE-68.Dk.1.0 10April2023 End
        }
    }

    actions
    {
        // Add changes to page actions here
        //PRJ-1281.RM.1.0 08April2022 start
        modify(Approve)
        {
            trigger OnBeforeAction()
            var
                TimeSheetLine: Record "Time Sheet Line";
                HumanResSteup: Record "Human Resources Setup";
            begin
                HumanResSteup.Get();
                //PE-68.Dk.1.0 26may2023 Start
                //  if HumanResSteup."NS_Activate Skill Class" = true then begin
                if (HumanResSteup."NS_Activate Skill Class" = true) or (HumanResSteup."NS_Advanced Job Labor isActive" = true) then begin
                    //PE-68.Dk.1.0 26may2023 End
                    TimeSheetLine.reset();
                    TimeSheetLine.SetRange("Time Sheet No.", Rec."Time Sheet No.");
                    TimeSheetLine.SetFilter("NS_Resource No.", '<>%1', '');
                    //PE-68 Dk.1.0 10April2023 Start
                    // TimeSheetLine.SetFilter("NS_Skill Code", '%1', '');
                    TimeSheetLine.SetFilter("NS_Skill Code New", '%1', '');
                    // if TimeSheetLine.FindFirst() then 
                    //     TimeSheetLine.TestField("NS_Skill Code");
                    if TimeSheetLine.FindFirst() then
                        TimeSheetLine.TestField("NS_Skill Code New");
                    //PE-68 Dk.1.0 10April2023 End
                end;
            end;
        }
        //PRJ-1281.RM.1.0 08April2022  end

    }

    var
        TimeSheetDetail: Record "Time Sheet Detail";
        TSRec: Record "Time Sheet Header";

        [InDataSet]
        ColumnHide1: Boolean;
        [InDataSet]
        ColumnHide2: Boolean;
        [InDataSet]
        ColumnHide3: Boolean;
        [InDataSet]
        ColumnHide4: Boolean;
        [InDataSet]
        ColumnHide5: Boolean;
        [InDataSet]
        ColumnHide6: Boolean;
        [InDataSet]
        ColumnHide7: Boolean;
        [InDataSet]
        NS_IsPermissionToView: Boolean;//PE-68 Dk.1.0 24April2023

    //ColumnHide1:Boolean;


    trigger OnAfterGetRecord()
    var
        NoOfPeriod: Integer;
    begin
        ColumnHide1 := false;
        ColumnHide2 := false;
        ColumnHide3 := false;
        ColumnHide4 := false;
        ColumnHide5 := false;
        ColumnHide6 := false;
        ColumnHide7 := false;

        if TSRec.Get(Rec."Time Sheet No.") then;
        //for NoOfPeriod := 1 to (TSrec."Ending Date" - TSRec."Starting Date") do begin
        for NoOfPeriod := 1 to TSRec.NS_TimeSheetCrewWorkDays do begin
            if NoOfPeriod = 1 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    Rec."Time Sheet Starting Date") then
                    ColumnHide1 := true;
            if NoOfPeriod = 2 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide2 := true;
            if NoOfPeriod = 3 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide3 := true;
            if NoOfPeriod = 4 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide4 := true;
            if NoOfPeriod = 5 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide5 := true;
            if NoOfPeriod = 6 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide6 := true;
            if NoOfPeriod = 7 then
                if TimeSheetDetail.Get(Rec."Time Sheet No.", Rec."Line No.",
                    calcdate('+' + format(NoOfPeriod - 1) + 'D', Rec."Time Sheet Starting Date")) then
                    ColumnHide7 := true;
            //PRJ-1242.NK.1.0 16Mar2022 Start
            if NoOfPeriod = 1 then
                ColumnHide1 := true;
            if NoOfPeriod = 2 then
                ColumnHide2 := true;
            if NoOfPeriod = 3 then
                ColumnHide3 := true;
            if NoOfPeriod = 4 then
                ColumnHide4 := true;
            if NoOfPeriod = 5 then
                ColumnHide5 := true;
            if NoOfPeriod = 6 then
                ColumnHide6 := true;
            if NoOfPeriod = 7 then
                ColumnHide7 := true;
            //PRJ-1242.NK.1.0 16Mar2022 End
        end;
    end;
    //PE-68 Dk.1.0 24April2023 Start
    trigger OnOpenPage()
    var
    begin
        NS_IsPermissionToView := false;
        NS_IsPermissionToView := NS_IsHavePermissionToview();
    end;

    procedure NS_IsHavePermissionToview(): Boolean
    var
        HumanResource: Record "Human Resources Setup";
    begin
        if HumanResource.Get() then begin
            if HumanResource."NS_Activate Skill Class" then
                exit(true)
            else
                exit(false);
        end;
    end;


    //PE-68 Dk.1.0 24April2023 End

}