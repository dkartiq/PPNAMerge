table 14021170 "NS_Job Custom Calendar Change"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Custom Calendar Change';

    fields
    {
        field(1; "NS_Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'Company,Customer,Vendor,Location,Shipping Agent,Service';
            OptionMembers = Company,Customer,Vendor,Location,"Shipping Agent",Service;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Source Code"; Code[20])
        {
            Caption = 'Source Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Additional Source Code"; Code[20])
        {
            Caption = 'Additional Source Code';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Editable = false;
            TableRelation = "NS_Job Calendar";
            DataClassification = CustomerContent;
        }
        field(5; "NS_Recurring System"; Option)
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
        field(6; NS_Date; Date)
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
        field(7; NS_Day; Option)
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
        field(8; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; NS_Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(10; "NS_Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Source Type", "NS_Source Code", "NS_Additional Source Code", "NS_Job Calendar Code", "NS_Recurring System", NS_Date, NS_Day, "NS_Entry No.")
        {
        }
        key(Key2; "NS_Entry No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(NS_DropDown; "NS_Source Type", "NS_Source Code", "NS_Additional Source Code")
        {
        }
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

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
        ShippingAgentService: Record "Shipping Agent Services";
        DateTable: Record Date;
        ServMgtSetup: Record "Service Mgt. Setup";

    procedure GetCaption(): Text[250];
    begin
        case "NS_Source Type" of
            "NS_Source Type"::Company:
                exit(COMPANYNAME);
            "NS_Source Type"::Customer:
                if Customer.GET("NS_Source Code") then
                    exit("NS_Source Code" + ' ' + Customer.Name);
            "NS_Source Type"::Vendor:
                if Vendor.GET("NS_Source Code") then
                    exit("NS_Source Code" + ' ' + Vendor.Name);
            "NS_Source Type"::Location:
                if Location.GET("NS_Source Code") then
                    exit("NS_Source Code" + ' ' + Location.Name);
            "NS_Source Type"::"Shipping Agent":
                if ShippingAgentService.GET("NS_Source Code", "NS_Additional Source Code") then
                    exit("NS_Source Code" + ' ' + "NS_Additional Source Code" + ' ' + ShippingAgentService.Description);
            "NS_Source Type"::Service:
                if ServMgtSetup.GET() then
                    exit("NS_Source Code" + ' ' + ServMgtSetup.TABLECAPTION);
        end;
    end;

    procedure NS_UpdateDayName();
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

