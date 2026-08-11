table 14021183 "NS_Job Contact"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    Caption = 'Job Contact';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; NS_Type; enum NSJobContactType)//PRJ-905
        {
            Caption = 'Type';
            // OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
            // OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
            DataClassification = CustomerContent;
        }
        //PRJ-905.AS.1.0 - start old code
        // field(2; NS_Type; Option)
        // {
        //     Caption = 'Type';
        //     OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
        //     OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
        //     DataClassification = CustomerContent;
        // }
        //PRJ-905.AS.1.0 - End old code
        field(3; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(4; NS_Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ContBusRel: Record "Contact Business Relation";
                Contact: Record Contact;
            begin
                JobRec.GET("NS_Job No.");
                ContBusRel.RESET();
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                Contact.RESET();
                Contact.SETCURRENTKEY("Company No.");
                if PAGE.RUNMODAL(PAGE::"Contact List", Contact) = ACTION::LookupOK then begin
                    NS_Name := COPYSTR(Contact.Name, 1, 30);
                    "NS_Name 2" := COPYSTR(Contact."Name 2", 1, 30);
                    NS_Address := COPYSTR(Contact.Address, 1, 30);
                    "NS_Address 2" := COPYSTR(Contact."Address 2", 1, 30);
                    NS_City := Contact.City;
                    NS_County := Contact.County;
                    "NS_Post Code" := Contact."Post Code";
                    "NS_Primary Phone No." := Contact."Phone No.";
                    "NS_Primary Fax No." := Contact."Fax No.";
                    "NS_Primary Mobile No." := Contact."Mobile Phone No.";
                    "NS_Primary e-Mail" := COPYSTR(Contact."E-Mail", 1, 30);
                    "NS_Primary Home Page" := COPYSTR(Contact."Home Page", 1, 30);
                end;
            end;
        }
        field(5; "NS_Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(6; NS_Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(7; "NS_Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(8; NS_City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(9; NS_County; Text[30])
        {
            Caption = 'State';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;

            //PPAL-79.AS.1.0 30JULY2020 - START
            trigger OnValidate()
            var
                PostcodeRec: Record "Post Code";
            begin

                PostcodeRec.RESET;
                PostcodeRec.SETRANGE(Code, "NS_Post Code");
                IF PostCodeRec.Findfirst then begin
                    //VALIDATE(NS_City, PostCodeRec.City);
                    NS_City := PostcodeRec.City;
                    VALIDATE(NS_County, PostCodeRec.County);
                end;
            end;
            //PPAL-79.AS.1.0 30JULY2020 - END
        }
        field(20; "NS_Primary Phone No."; Text[30])
        {
            Caption = 'Primary Phone No.';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Primary Fax No."; Text[30])
        {
            Caption = 'Primary Fax No.';
            DataClassification = CustomerContent;
        }
        field(22; "NS_Primary Mobile No."; Text[30])
        {
            Caption = 'Primary Mobil No.';
            DataClassification = CustomerContent;
        }
        field(23; "NS_Primary e-Mail"; Text[80])
        {
            Caption = 'Primary e-Mail';
            DataClassification = CustomerContent;
        }
        field(24; "NS_Primary Home Page"; Text[80])
        {
            Caption = 'Primary Home Page';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Secondary Phone No."; Text[30])
        {
            Caption = 'Secondary Phone No.';
            DataClassification = CustomerContent;
        }
        field(31; "NS_Secondary Fax No."; Text[30])
        {
            Caption = 'Secondary Fax No.';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Secondary Mobiel No."; Text[30])
        {
            Caption = 'Secondary Mobil No.';
            DataClassification = CustomerContent;
        }
        field(33; "NS_Secondary e-Mail"; Text[80])
        {
            Caption = 'Secondary e-Mail';
            DataClassification = CustomerContent;
        }
        field(34; "NS_Secondary Home Page"; Text[80])
        {
            Caption = 'Secondary Home Page';
            DataClassification = CustomerContent;
        }
        field(100; "NS_Their Job No."; Text[30])
        {
            Caption = 'Their Job No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", NS_Type, "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        JobRec: Record Job;
}

