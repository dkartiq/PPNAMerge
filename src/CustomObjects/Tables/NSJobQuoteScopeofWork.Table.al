table 14021414 "NS_Job Quote Scope of Work"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0�17June21�|�NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    Caption = 'Scope of Work';
    DrillDownPageID = "NS_Job Quote Scope of Work";
    LookupPageID = "NS_Job Quote Scope of Work";

    fields
    {
        field(10; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                ScopeOfWork: Record "NS_Job Quote Scope of Work";
            begin
                ScopeOfWork.RESET();
                ScopeOfWork.SETRANGE("NS_Quote No.", "NS_Quote No.");
                if ScopeOfWork.FINDLAST() then
                    "NS_Line No." := ScopeOfWork."NS_Line No." + 10000
                else
                    "NS_Line No." := 10000;
            end;
        }
        field(20; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(40; NS_Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50; "NS_Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(60; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Quote No."));

            trigger OnValidate();
            var
                lSegment: Record "NS_Job Takeoff Segments";
            begin
                lSegment.SETRANGE("NS_Job No.", "NS_Quote No.");
                lSegment.SETRANGE("NS_Segment Code", "NS_Segment Code");
                if lSegment.FINDFIRST() then
                    "NS_Segment Name" := lSegment."NS_Segment Name";
            end;
        }
        field(70; "NS_Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
            DataClassification = CustomerContent;
        }
        field(80; "NS_Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Quote Def Scope of Work".NS_Code;

            trigger OnValidate();
            var
                DefScope: Record "NS_Job Quote Def Scope of Work";
                lSegment: Record "NS_Job Takeoff Segments";
            begin
                if (NS_Code <> xRec.NS_Code) and (NS_Code <> '') then begin
                    DefScope.SETRANGE(NS_Code, NS_Code);
                    if DefScope.FINDFIRST() then begin
                        NS_Description := DefScope.NS_Description;
                        "NS_Description 2" := DefScope."NS_Description 2";
                        lSegment.SETRANGE("NS_Job No.", "NS_Quote No.");
                        lSegment.SETRANGE("NS_Segment Code", "NS_Segment Code");
                        if lSegment.FINDFIRST() then
                            "NS_Segment Name" := lSegment."NS_Segment Name";
                    end;
                end;
            end;
        }
        field(90; "NS_Text Value"; Text[250])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;
        }
        field(100; NS_Details; Text[50])
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
        }
        field(101; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';//PRJ-659.RS.1.0�17June21
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", "NS_Quote Line No.", "NS_Line No.", "NS_Segment Code")
        {
        }
    }

    fieldgroups
    {
    }
}

