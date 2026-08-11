table 14021190 "NS_Project Link Buffer"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Project Link Buffer';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Master Job No."; Code[20])
        {
            Caption = 'Master Job No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Job Type"; Text[30])
        {
            Caption = 'Job Type';
            DataClassification = CustomerContent;
        }
        field(15; "NS_Task No."; Code[20])
        {
            Caption = 'Task No.';
            DataClassification = CustomerContent;
        }
        field(16; "NS_Task Name"; Text[50])
        {
            Caption = 'Task Name';
            DataClassification = CustomerContent;
        }
        field(17; "NS_Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
            DataClassification = CustomerContent;
        }
        field(18; "NS_Task Before"; Code[20])
        {
            Caption = 'Task Before';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Parent Job No."; Code[20])
        {
            Caption = 'Parent Job No.';
            DataClassification = CustomerContent;
        }
        field(21; "NS_Parent Task No."; Code[20])
        {
            Caption = 'Parent Task No.';
            DataClassification = CustomerContent;
        }
        field(25; NS_Predecessor; Text[50])
        {
            Caption = 'Predecessor';
            DataClassification = CustomerContent;
        }
        field(26; NS_Successors; Text[50])
        {
            Caption = 'Successors';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Outline Level"; Integer)
        {
            Caption = 'Outline Level';
            DataClassification = CustomerContent;
        }
        field(31; NS_Level; Code[20])
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(33; "NS_Finish Date"; Date)
        {
            Caption = 'Finish Date';
            DataClassification = CustomerContent;
        }
        field(35; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Budgeted Cost"; Decimal)
        {
            Caption = 'Budgeted Cost';
            DataClassification = CustomerContent;
        }
        field(41; "NS_Usage Cost"; Decimal)
        {
            Caption = 'Usage Cost';
            DataClassification = CustomerContent;
        }
        field(42; "NS_Budgeted Price"; Decimal)
        {
            Caption = 'Budgeted Price';
            DataClassification = CustomerContent;
        }
        field(44; "NS_Est Hours"; Decimal)
        {
            Caption = 'Est Hours';
            DataClassification = CustomerContent;
        }
        field(45; "NS_Act Hours"; Decimal)
        {
            Caption = 'Act Hours';
            DataClassification = CustomerContent;
        }
        field(46; NS_Duration; Decimal)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        }
        field(47; NS_Lag; Decimal)
        {
            Caption = 'Lag';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Line No.")
        {
        }
        key(Key2; "NS_Job No.", "NS_Task No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

