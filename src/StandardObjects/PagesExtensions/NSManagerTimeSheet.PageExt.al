pageextension 14021379 NSManagerTimeSheet extends "Manager Time Sheet"
{
    //PRJ-772.AS.1.0 Added this page extension
    //PRJ-841.JS.1.0 16Aug2021 | add field Resource skill code
    //PRJ-842.JS.1.0 16Aug2021 | add field Resource Segment code
    layout
    {
        addafter(ResourceNo)
        {
            field(NS_TSRecResourecName; TSRec."NS_Resource Name")
            {
                Caption = 'Lead Resource Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Lead Resource Name for Crew Time Sheet';
            }

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
            field("NS_Resource Name"; Rec."NS_Resource Name")
            {
                Caption = 'Resource Name';
                ApplicationArea = All;
                ToolTip = 'Resource Name';
            }
            field("NS_Work Type Code"; Rec."NS_Work Type Code")
            {
                Caption = 'Work Type';
                ToolTip = 'Specifies the value for the Work Type';
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
            field("NS_Skill Code"; Rec."NS_Skill Code")
            {
                ToolTip = 'Specifies the value of the resouce Skill';
                ApplicationArea = All;
                Editable = false;
            }
            //PRJ-841.JS.1.0 16Aug2021-end
            //PRJ-842.JS.1.0 16Aug2021-end            
        }
    }

    actions
    {
        // Add changes to page actions here
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

            // if NoOfPeriod = 1 then
            //     ColumnHide1 := true;
            // if NoOfPeriod = 2 then
            //     ColumnHide2 := true;
            // if NoOfPeriod = 3 then
            //     ColumnHide3 := true;
            // if NoOfPeriod = 4 then
            //     ColumnHide4 := true;
            // if NoOfPeriod = 5 then
            //     ColumnHide5 := true;
            // if NoOfPeriod = 6 then
            //     ColumnHide6 := true;
            // if NoOfPeriod = 7 then
            //     ColumnHide7 := true;
        end;
    end;
}