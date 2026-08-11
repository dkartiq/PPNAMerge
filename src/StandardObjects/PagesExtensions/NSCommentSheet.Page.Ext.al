pageextension 14021156 NS_CommentSheetExt extends "Comment Sheet"
{
    // version NAVW111.00,,PPNA11.00,PPNA11.00
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

