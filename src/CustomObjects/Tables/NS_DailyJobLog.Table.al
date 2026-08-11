/// <summary>
/// Table Daily Job Log (ID 14021999).
/// </summary>
/// Create New table for Daily Job Log //PE-168.PS.1.0 15Sep2023
/// //PE-168.HS.1.0 10Nov2023
table 14021399 "NS_Daily Job Log"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "NS_No.", "NS_Job No.", NS_Description;
    Caption = 'Job Daily Log'; //PE-168.HS.1.0 22Nov2023
    fields
    {
        field(1; "NS_No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

        }
        field(2; "NS_Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Job;
            Caption = 'Job No.';
            trigger OnValidate()
            var
                jbrec2: Record job;//PE-211.AS
            begin
                if Rec."Date of Creation" = 0D then begin
                    Rec."Date of Creation" := WorkDate();
                    Rec."Time of Creation" := Time;
                    Rec."Created By" := UserId;
                end;

                //PE-211.AS start
                if Rec."NS_Job No." <> '' then
                    if jbrec2.get(Rec."NS_Job No.") then
                        Rec."NS_Field Manager" := jbrec2."NS_Field Manager";
                //PE-211.AS end
            end;

        }
        field(3; "NS_Job Address 1"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Address 1';

        }
        field(4; "NS_Job Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Address 2';

        }
        field(5; "NS_City"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Job City';

        }
        field(6; "NS_Log Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Log Date';

        }
        field(7; "NS_Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';

        }
        field(8; "NS_Job County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Job State';

        }
        field(9; "NS_Job Zip Code"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Zip Code';

        }
        field(10; "NS_Country"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Country';

        }
        field(11; "NS_Manager"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Manager';
            TableRelation = Resource."No.";
            trigger OnValidate()
            var
                myInt: Integer;
                NSResourse: Record Resource;
            begin
                if NSResourse.Get(Rec.NS_Manager) then;
                if Rec.NS_Manager <> '' then
                    Rec."NS_Project Manager Name" := NSResourse.Name;
            end;

        }
        field(12; "NS_Project Manager No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Manager No.';

        }
        field(13; "Multiple Selectiions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Multiple Selectiions';
        }
        field(14; "NS_Project Manager Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Manager Name';

        }
        field(15; Others; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Others';

        }
        field(16; "NS_Contract Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Date';

        }

        field(17; "NS_Estimated Completion Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Job Est. Compl. Date';  //PE-168.HS.1.0 16Nov2023
        }
        field(18; "NS_Actual Work Completion %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Work Completion %';

        }
        field(19; "NS_Worker Count"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Worker Count';

        }

        field(20; "NS_Risk or Delay"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Risk or Delay';

        }

        field(21; "NS_Accidents/Safety Issues"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Accidents/Safety Issues';
        }
        field(22; "NS_Job Tasks"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Tasks';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(23; "NS_PO / SC"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PO / SC';
        }
        //PE-211.AS start
        field(14021488; "NS_Field Manager"; Code[50])
        {
            Caption = 'Field Manager';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PE-211.AS end

        field(24; "NS_CRM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CRM No.';
        }
        field(25; "NS_Completion Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'PM Est. Compl. Date';  //PE-168.HS.1.0 16Nov2023
        }
        field(26; "Windy"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Windy';

        }
        field(27; Rainy; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Rainy';

        }
        field(28; Clear; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Clear';
        }
        field(29; Dusty; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Dusty';

        }
        field(30; Muddy; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Muddy';
        }
        field(31; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(32; "Date of Creation"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Time of Creation"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Work Shift"; Enum NSDailyJobLogWorkShift)
        {
            DataClassification = CustomerContent;
        }
        field(35; Temperature; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(36; "Measuring Scale"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Celsius,Fahrenheit;
        }
        field(37; "Weather/Temperature Other"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(38; "Site Condition Other"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(39; "Status"; Enum NSDailyJobLogStatus)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            ExtendedDatatype = EMail;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "E-Mail" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("E-Mail");
            end;
        }
        field(41; "No of Email Send"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PE-217.DK.1.0 27Dec2023 Start
        field(42; "NS_Signature"; Blob)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
            SubType = Bitmap;

        }
        //PE-217.DK.1.0 27Dec2023 End

    }

    keys
    {
        key(Key1; "NS_No.")
        {
            Clustered = true;
        }
    }

    var
        NSNoSeries: Codeunit NoSeriesManagement;
        NS_JobSetup: Record "Jobs Setup";

    trigger OnInsert()
    var
        NSJobLogTaskSetup: record NS_APOSetup;
        jbrec3: Record Job; //PE-211.AS
    begin
        if Rec."NS_No." <> xRec."NS_No." then begin

        end;
        if Rec."NS_No." <> '' then
            if NSJobLogTaskSetup.get() then
                rec."Measuring Scale" := NSJobLogTaskSetup."NS_Temperature Measuring Scale";

        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec3.get(Rec."NS_Job No.") then
                Rec."NS_Field Manager" := jbrec3."NS_Field Manager";
        //PE-211.AS end
    end;

    trigger OnModify()
    var
        jbrec4: Record Job; //PE-211.AS
    begin
        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec4.get(Rec."NS_Job No.") then
                Rec."NS_Field Manager" := jbrec4."NS_Field Manager";
        //PE-211.AS end
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
    //PE-217.DK.1.0 27Dec2023 Start

    procedure SignDocument(var Base64Text: Text)
    var
        Base64Cu: Codeunit "Base64 Convert";
        RecordRef: RecordRef;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        ImageBase64String: Text;
    begin
        Base64Text := Base64Text.Replace('data:image/png;base64,', '');
        TempBlob.CreateOutStream(OutStream);
        // Message('%1', TempBlob);
        Base64Cu.FromBase64(Base64Text, OutStream);
        RecordRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecordRef, Rec.FieldNo("NS_Signature"));
        RecordRef.Modify();
    end;
    //PE-217.DK.1.0 27Dec2023 End

}