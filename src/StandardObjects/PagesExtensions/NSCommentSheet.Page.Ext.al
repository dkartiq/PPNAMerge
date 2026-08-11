pageextension 14021156 NS_CommentSheetExt extends "Comment Sheet"
{
    // version NAVW111.00,,PPNA11.00,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Comment Sheet'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {


    }


    trigger OnOpenPage()
    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        CommentLine: Record "Comment Line";
    begin
        if AsofDateForecast <> 0D then begin
            rec.Date := AsofDateForecast;
        end;
    end;

    var
        AsofDateForecast: Date;
        JobNo: Code[20];

    procedure NS_SetAsofDate(Asofdate: Date; ParajobNo: code[20]);
    begin
        AsofDateForecast := Asofdate;
        JobNo := ParaJobNo;
    end;

}

