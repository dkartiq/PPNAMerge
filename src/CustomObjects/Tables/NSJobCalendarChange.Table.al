table 14021169 "NS_Job Calendar Change"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Calendar Change';
    DataCaptionFields = "NS_Job Calendar Code";

    fields
    {
        field(1; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Editable = false;
            TableRelation = "NS_Job Calendar";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Recurring System"; Option)
        {
            Caption = 'Recurring System';
            OptionCaption = '" ,Annual Recurring,Weekly Recurring"';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Recurring System" <> xRec."NS_Recurring System" then
                    case "NS_Recurring System" of
                        "NS_Recurring System"::"Annual Recurring":
                            NS_Day := NS_Day::" ";
                        "NS_Recurring System"::"Weekly Recurring":
                            NS_Date := 0D;
                    end;
            end;
        }
        field(3; NS_Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Recurring System" = "NS_Recurring System"::" ") or
                   ("NS_Recurring System" = "NS_Recurring System"::"Annual Recurring") then
                    TESTFIELD(NS_Date)
                else
                    TESTFIELD(NS_Date, 0D);
                NS_UpdateDayName();
            end;
        }
        field(4; NS_Day; Option)
        {
            Caption = 'Day';
            OptionCaption = '" ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday"';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Recurring System" = "NS_Recurring System"::"Weekly Recurring" then
                    TESTFIELD(NS_Day);
                NS_UpdateDayName();
            end;
        }
        field(5; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; NS_Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            InitValue = true;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job Calendar Code", "NS_Recurring System", NS_Date, NS_Day)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        NS_CheckEntryLine();
    end;

    trigger OnModify();
    begin
        NS_CheckEntryLine();
    end;

    trigger OnRename();
    begin
        NS_CheckEntryLine();
    end;

    procedure NS_UpdateDayName();
    var
        DateTable: Record Date;
    begin
        if (NS_Date > 0D) and
           ("NS_Recurring System" = "NS_Recurring System"::"Annual Recurring") then
            NS_Day := NS_Day::" "
        else begin
            DateTable.SETRANGE("Period Type", DateTable."Period Type"::Date);
            DateTable.SETRANGE("Period Start", NS_Date);
            if DateTable.FINDFIRST() then
                NS_Day := DateTable."Period No.";
        end;
        if (NS_Date = 0D) and (NS_Day = NS_Day::" ") then begin
            NS_Day := xRec.NS_Day;
            NS_Date := xRec.NS_Date;
        end;
        if "NS_Recurring System" = "NS_Recurring System"::"Annual Recurring" then
            TESTFIELD(NS_Day, NS_Day::" ");
    end;

    procedure NS_CheckEntryLine();
    begin
        case "NS_Recurring System" of
            "NS_Recurring System"::" ":
                begin
                    TESTFIELD(NS_Date);
                    TESTFIELD(NS_Day);
                end;
            "NS_Recurring System"::"Annual Recurring":
                begin
                    TESTFIELD(NS_Date);
                    TESTFIELD(NS_Day, NS_Day::" ");
                end;
            "NS_Recurring System"::"Weekly Recurring":
                begin
                    TESTFIELD(NS_Date, 0D);
                    TESTFIELD(NS_Day);
                end;
        end;
    end;
}

