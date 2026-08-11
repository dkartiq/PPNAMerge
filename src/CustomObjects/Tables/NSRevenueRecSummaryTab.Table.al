table 14021193 NS_RevenueRecSummaryTab
{
    //CTSI-274.AM.1.0 Added New Table 
    DataClassification = ToBeClassified;
    Caption = 'Revenue Recognition Summary Details';
    LookupPageId = NS_RevenueRecognitionSummary;
    DrillDownPageId = NS_RevenueRecognitionSummary;

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "NS_Posting Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(3; "NS_Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Finance,JFW;
            OptionCaption = 'Finance,JFW';
        }
        field(4; "NS_Job No."; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "NS_Current Contract"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "NS_Current(TCE) Est. Cost at Completion"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "NS_Actual Costs To Date"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "NS_Period Costs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "NS_POC %"; Decimal)
        {
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 5;
        }
        field(11; "NS_Current GM %"; Decimal)
        {
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 5;
        }
        field(12; "NS_Gross Revenue"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "NS_Gross Profit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "NS_Net Revenue"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "NS_Net Profit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "NS_Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        // field(17; "True-Up Posted"; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // } //CTSI-286 rollback

        field(18; NS_Voided; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "NS_Gen.Doc.No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Document No.';
        }
        // field(20; TrueupDoc; boolean)
        // {
        //     DataClassification = CustomerContent;
        // } //CTSI-286 rollback
        field(21; NS_CheckBool; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "NS_Stat. Cont. GM (As of)"; Decimal)
        {
            DataClassification = CustomerContent;//Statistics page calculations
        }
        field(25; "NS_Stat. GM% (As of)"; Decimal)//Statistics page calculations
        {
            DataClassification = CustomerContent;
        }
        field(26; "NS_True-Up Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'CTSI-286.MS.1.0';
        }
        field(27; "NS_Billings to Date"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Billings to Date';
        }
        field(28; "NS_Under Billings"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Under Billings';
        }
        field(29; "NS_Over Billings"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Over Billings';
        }
        field(30; "NS_Over/Under Billings Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Over/Under Billings Posted';
        }
        field(31; "NS_Billing Amt. Posted"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Billing Amt. Posted';
        }

        field(32; "NS_Global Dimension 1 Code"; Code[20])//PRJ-950.AS.1.0 ADD FIELD
        {
            //CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(33; "NS_Global Dimension 2 Code"; Code[20])//PRJ-950.AS.1.0 ADD FIELD
        {
            //CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }


    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
    begin

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