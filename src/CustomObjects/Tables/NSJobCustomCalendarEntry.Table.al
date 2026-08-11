table 14021171 "NS_Job Custom Calendar Entry"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Custom Calendar Entry';

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
        field(5; NS_Date; Date)
        {
            Caption = 'Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_UpdateExceptionEntry();
            end;
        }
        field(7; NS_Nonworking; Boolean)
        {
            Caption = 'Nonworking';
            Editable = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_UpdateExceptionEntry();
            end;
        }
    }

    keys
    {
        key(Key1; "NS_Source Type", "NS_Source Code", "NS_Additional Source Code", "NS_Job Calendar Code", NS_Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;
        ServMgtsetup: Record "Service Mgt. Setup";
        ShippingAgentService: Record "Shipping Agent Services";

    procedure NS_UpdateExceptionEntry();
    var
        CalendarException: Record "NS_Job Custom Calendar Change";
    begin
        CalendarException.SETRANGE("NS_Source Type", "NS_Source Type");
        CalendarException.SETRANGE("NS_Source Code", "NS_Source Code");
        CalendarException.SETRANGE("NS_Job Calendar Code", "NS_Job Calendar Code");
        CalendarException.SETRANGE(NS_Date, NS_Date);
        CalendarException.DELETEALL();
        CalendarException.INIT();
        CalendarException."NS_Source Type" := "NS_Source Type";
        CalendarException."NS_Source Code" := "NS_Source Code";
        CalendarException."NS_Job Calendar Code" := "NS_Job Calendar Code";
        CalendarException.NS_Date := NS_Date;
        CalendarException.NS_Nonworking := NS_Nonworking;
        CalendarException.NS_Description := NS_Description;
        CalendarException.INSERT();
    end;

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
                if ServMgtsetup.GET() then
                    exit("NS_Source Code" + ' ' + ServMgtsetup.TABLECAPTION);
        end;
    end;
}

