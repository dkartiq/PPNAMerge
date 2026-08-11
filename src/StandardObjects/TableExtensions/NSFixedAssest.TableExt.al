tableextension 14021244 NS_FixedAsset extends "Fixed Asset"
{
    //PRJ-490.MS.1.0 create new field

    fields
    {
        field(14021100; "NS_FA Res. No."; Code[20])
        {
            Caption = 'FA Res. No.';
            Description = 'PRJ-490';
            DataClassification = CustomerContent;
            TableRelation = Resource."No." where(Type = filter(<> person));
            trigger OnValidate()
            var
            begin
                ResRec.Reset();
                ResRec.SetRange("No.", Rec."NS_FA Res. No.");
                if ResRec.FindFirst() then begin
                    ResRec."NS_Res. FA No." := Rec."No.";
                    ResRec.Modify();
                end;
            end;
        }
    }
    var
        ResRec: Record Resource;
}
