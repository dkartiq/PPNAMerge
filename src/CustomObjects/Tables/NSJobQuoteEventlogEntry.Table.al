table 14021417 "NS_Job Quote Event Log Entry"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Event Log Entry';

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(501; "NS_Object Type"; Option)
        {
            Caption = 'Object Type';
            DataClassification = CustomerContent;
            OptionCaption = 'TableData,Table,Report,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber';
            OptionMembers = TableData,"Table","Report","Codeunit","XMLport",MenuSuite,"Page","Query",System,FieldNumber;
        }
        field(502; "NS_Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = CustomerContent;
        }
        field(601; "NS_Notification to be Sent"; Boolean)
        {
            Caption = 'Notification to be Sent';
            DataClassification = CustomerContent;
        }
        field(602; "NS_Notification Sent"; Boolean)
        {
            Caption = 'Notification Sent';
            DataClassification = CustomerContent;
        }
        field(611; "NS_Notification EMailAddresses"; Text[250])
        {
            Caption = 'Notification E-Mail Addresses';
            DataClassification = CustomerContent;
        }
        field(1001; NS_Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = '" ,Success,Error,Message"';
            OptionMembers = " ",Success,Error,Message;
        }
        field(1011; "NS_Message Text"; Text[250])
        {
            Caption = 'Message Text';
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Error Text"; Text[250])
        {
            Caption = 'Error Text';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
        }
        key(Key2; "NS_Code", "NS_Created at Date")
        {
        }
        key(Key3; "NS_Object Type", "NS_Object ID")
        {
        }
        key(Key4; "NS_Notification to be Sent", "NS_Notification Sent")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "NS_Created by" := USERID[50];
        "NS_Created at Date" := TODAY;
        "NS_Created at Time" := TIME;
    end;

    procedure DeleteEntriesOlderThanSevenDays();
    var
        _EventLogEntry: Record "NS_Job Quote Event Log Entry";

        _Text000Lbl: Label 'Delete entries older than 7 days?';
    begin
        if GUIALLOWED then
            if not CONFIRM(_Text000Lbl, false) then
                exit;

        with _EventLogEntry do begin
            SETCURRENTKEY(NS_Code, "NS_Created at Date");
            SETRANGE("NS_Created at Date", 0D, CALCDATE('<-8D>', WORKDATE()));
            DELETEALL();
        end;
    end;

    procedure NewEventLogEntry(_Code: Code[10]; _ObjectType: Option TableData,"Table","Report","Codeunit","XMLport",MenuSuite,"Page","Query",System,FieldNumber; _ObjectID: Integer; _Status: Integer; _MessageText: Text[250]; _ErrorText: Text[250]; _SendNotification: Boolean; _NotificationEmailAddresses: Text[250]);
    var
        _EventLogEntry: Record "NS_Job Quote Event Log Entry";
    begin
        with _EventLogEntry do begin
            INIT();
            "NS_Entry No." := 0;
            NS_Code := _Code;
            "NS_Object Type" := _ObjectType;
            "NS_Object ID" := _ObjectID;
            NS_Status := _Status;
            "NS_Message Text" := _MessageText;
            "NS_Error Text" := _ErrorText;
            "NS_Notification to be Sent" := _SendNotification;
            "NS_Notification EMailAddresses" := _NotificationEmailAddresses;
            INSERT(true);
        end;
    end;
}

