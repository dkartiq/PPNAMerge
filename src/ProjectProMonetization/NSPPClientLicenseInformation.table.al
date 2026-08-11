table 14021230 "NS_PPClientLicenseInformation"
{
    DataPerCompany = false;
    Permissions = tabledata "NS_PPClientLicenseInformation" = rimd;

    fields
    {
        field(1; NS_CompanyName; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(2; "NS_Licence Id"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Licence Key';
        }
        field(3; NS_IsActive; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
            trigger OnValidate()
            begin
                IF Rec.NS_IsActive then begin
                    Rec.NS_LicenseRequested := false;
                    rec.NS_LicenseRequestedDate := 0D;
                    Rec.NS_ServerUpdateWithExpiry := false;
                    Rec.NS_IsExpired := false;
                end;
            end;

        }
        field(4; "NS_Valid From"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Valid From';
        }
        field(5; "NS_Valid Upto"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Valid UpTo';
        }
        field(6; "NS_Tenant ID"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; NS_IsTrial; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Trial';
        }
        field(8; NS_EnvironmentType; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Client Type';
        }
        field(9; NS_InstallingPerson; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Extension Manager';
        }
        field(10; NS_InstallingPersonEmail; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Email';
        }
        field(11; NS_IsExpired; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Expired';
        }
        field(12; NS_LicenseRequested; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; NS_LicenseRequestedDate; date)
        {
            DataClassification = CustomerContent;
        }
        field(14; NS_ContactNo; code[20])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Caption = 'Contact No.';
        }
        field(15; NS_ServerUpdateWithExpiry; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(16; NS_Renew; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(17; NS_Installed; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(18; NS_AppRequested; Boolean)
        {
            DataClassification = CustomerContent;
        }


    }
    keys
    {
        key(PK; "NS_Licence Id")
        {
            Clustered = true;
        }
    }
    var
    trigger OnInsert()
    var

    begin
        "NS_Licence Id" := CreateGuid();
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