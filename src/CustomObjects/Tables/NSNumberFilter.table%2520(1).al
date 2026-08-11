
table 14021345 "NSNumberFilter"
{
    DataClassification = CustomerContent;
    //TableType = Temporary;
    //PRJ-1474.NK.1.0 26July2022 New table create
    LookupPageId = "NSNumberFilter List";
    DrillDownPageId = "NSNumberFilter List";
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(3; "Type"; Enum "NS_Type Filter")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        //PE-185.NC.1.0 05Oct2023 Start
        field(4; "NS_User Task Cue Sequence"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'User Task Cue Sequence';
            trigger OnValidate()
            var
                NSNumberFilter: Record NSNumberFilter;
                NSNumberFilter2: Record NSNumberFilter;
            begin
                NSNumberFilter.Reset();
                NSNumberFilter.SetCurrentKey("NS_User Task Cue Sequence");
                NSNumberFilter.Ascending(true);
                NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
                NSNumberFilter.SetRange("NS_User Task Cue Sequence", "NS_User Task Cue Sequence");
                if NSNumberFilter.FindFirst() then
                    Error('Sorry! you can not enter more than one time');
                Rec."Document No." := 'USER'; //PRJCTPR-270.HS.1.0 8Feb2024
            end;
        }
        //PE-185.NC.1.0 05Oct2023 End
    }

    keys
    {
        key(Key1; "Type", "Document No.", "No.")
        {
            Clustered = true;
        }
        key(key2; "Document No.")
        {

        }
        key(key3; "Type")
        { }
        key(key4; "NS_User Task Cue Sequence") { } //PE-185.NC.1.0 05Oct2023
    }

    var
        myInt: Record Item;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}