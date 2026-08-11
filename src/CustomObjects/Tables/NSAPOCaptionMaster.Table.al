table 14021494 NS_APOCaptionMaster
//PRJ-1348.NK.1.0 24May2022 New Table Create
{
    DataClassification = ToBeClassified;
    Caption = 'APOS Caption Master';
    DrillDownPageId = NS_APOCaptionMaster;
    LookupPageId = NS_APOCaptionMaster;

    fields
    {
        field(1; NS_Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
            OptionMembers = " ",Activity,Process,Operation,Section;
        }

        field(2; NS_Code; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            trigger OnValidate()
            begin
                NS_Code := NormalizeText(NS_Code);
                NS_UpdateText(NS_Code, NS_Text0003, NS_Description);
                NS_UpdateText(NS_Code, NS_Text0001, NS_Source);
                NS_UpdateText(NS_Code, NS_Text0002, NS_Destination);
                NS_UpdateText(NS_Text0004, NS_Code, NS_Report);
                NS_Description := NormalizeText(NS_Description);
                NS_Source := NormalizeText(NS_Source);
                NS_Destination := NormalizeText(NS_Destination);
                NS_Report := NormalizeText(NS_Report);
            end;

        }
        field(3; NS_Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(4; NS_Source; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Source';
        }
        field(5; NS_Destination; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Matching';
        }
        field(6; NS_Report; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Report Caption';
        }
    }

    keys
    {
        key(Key1; NS_Type, NS_Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; NS_Code, NS_Description, NS_Source, NS_Destination)
        {
        }
        fieldgroup(Brick; NS_Code, NS_Description, NS_Source, NS_Destination)
        {
        }
    }

    var
        NS_Text0001: Label 'Source';
        NS_Text0002: Label 'Matching';
        NS_Text0003: Label 'Description';
        NS_Text0004: Label 'Show';

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

    local procedure NS_UpdateText("Code": Code[20]; AddText: Text[30]; var Text: Text[80])
    begin
        if Text = '' then begin
            Text := LowerCase(Code);
            Text[1] := Code[1];
            if AddText <> '' then
                Text := StrSubstNo('%1 %2', Text, AddText);
        end;
    end;

    local procedure NormalizeText(OldText: Text[1024]) NewText: Text[1024]
    var
        J: Integer;
        I: Integer;
    begin
        J := 1;
        FOR I := 2 TO STRLEN(OldText) DO
            IF (OldText[I] IN [' ', ';', ',', '/', '(', ')', '&', '+', '-']) OR (I = STRLEN(OldText)) THEN BEGIN  // List of Seperators
                NewText += UPPERCASE(COPYSTR(OldText, J, 1)) + LOWERCASE(COPYSTR(OldText, J + 1, I - J));
                J := I + 1;
            END;
    end;

}