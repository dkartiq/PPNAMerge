/// <summary>
/// Table NS_ResourceSkillClass (ID 14021489).
/// </summary>
//PRJ-1557.GK.1.0 26Aug2022|Create New Table for Resource Skill Class
table 14021489 "NS_ResourceSkillClass"
{
    DataClassification = CustomerContent;
    Caption = 'Resource Skill Class';
    LookupPageId = 14021489;

    fields
    {
        field(1; "NS_Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource No.';

        }
        field(2; "NS_Skill Class Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "NS_Skill Class";
            Caption = 'Skill Class Code';
            trigger OnValidate()
            var
                NS_SkillClass: Record "NS_Skill Class";
            begin
                if "NS_Skill Class Code" <> '' then begin
                    if NS_SkillClass.Get("NS_Skill Class Code") then
                        "NS_Skill Class Description" := NS_SkillClass.NS_Description;
                end else
                    "NS_Skill Class Description" := '';

            end;
        }
        field(3; "NS_Skill Class Description"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Skill Class Description';
            Editable = false;

        }
        field(4; "NS_Default"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default';
            trigger OnValidate()
            var
                NSResourceSkillClass: Record NS_ResourceSkillClass;
                NSResource: record resource;  //PE-152.JS.1. 0 21aug2023
            begin
                if NS_Default = true then begin
                    NSResourceSkillClass.Reset();
                    NSResourceSkillClass.SetRange("NS_Resource No.", "NS_Resource No.");
                    NSResourceSkillClass.SetRange(NS_Default, true);
                    if NSResourceSkillClass.FindFirst() then
                        Error(NSTxt001Lbl);

                    //PE-152.JS.1. 0 21aug2023 - Start
                    If NSResource.Get("NS_Resource No.") then begin
                        NSResource."NS_Skill Class Code" := rec."NS_Skill Class Code";
                        NSResource.modify();
                    end;
                end else
                    If NSResource.Get("NS_Resource No.") then begin
                        NSResource."NS_Skill Class Code" := '';
                        NSResource.modify();
                    end;
                //PE-152.JS.1. 0 21aug2023 - end
            end;

        }
    }

    keys
    {
        key(Key1; "NS_Resource No.", "NS_Skill Class COde")
        {
            Clustered = true;
        }
    }

    var
        NSTxt001Lbl: Label 'You can not add more than one Default Skill Class on a Resource';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        NSResource1: record Resource;   //PE-152.JS.1.0 21Aug2023
    begin
        //PE-152.JS.1.0 21Aug2023 - Start
        if NSResource1.get(rec."NS_Resource No.") then begin
            if NSResource1."NS_Skill Class Code" = rec."NS_Skill Class Code" then begin
                NSResource1."NS_Skill Class Code" := '';
                NSResource1.Modify();
            end;
        end;
        //PE-152.JS.1.0 21Aug2023 - end
    end;

    trigger OnRename()
    begin

    end;

}