table 14021446 "NS_Cost Cat by Code"
{
    //PRJ-1052.AS.1.0 Created New Table for Cost categories with codes grouping

    DataClassification = ToBeClassified;
    Caption = 'Cost category by code';
    fields
    {

        field(1; "NS_Job No"; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;

        }
        field(2; "NS_Cost Category"; Code[20])
        {
            Caption = 'Cost Category';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Budget Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Planning Line"."Total Cost (LCY)" where("Job No." = field("NS_Job No"),
            "NS_Cost Category" = field("NS_Cost Category"),
            "Line Type" = FILTER(Budget | "Both Budget and Billable")));
            Caption = 'Budget Cost';
            Description = 'Budget Cost';

        }
        field(4; "NS_Actual Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Job Ledger Entry"."Total Cost (LCY)" where("Job No." = field("NS_Job No"),
          "NS_Job Cost Category" = field("NS_Cost Category")));
            Caption = 'Actual Cost';
        }
        field(5; "NS_Cost Variance"; Decimal)
        {
            Caption = 'Cost Variance';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Cost Vaiance%"; Decimal)
        {
            Caption = 'Cost Vaiance%';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(7; NS_CheckBool; boolean)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "NS_Job No", "NS_Cost Category")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
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


    procedure SetParameter(NoIN: Code[20])
    var
        TcostCat: Record "NS_Cost Cat by Code";
    begin
        TcostCat.reset;
        TcostCat.SetRange("NS_Job No", NoIN);
        if TcostCat.FindSet() then
            repeat
                TcostCat.CalcFields(TcostCat."NS_Budget Cost", TcostCat."NS_Actual Cost");

                if (TcostCat."NS_Budget Cost" = 0) and (TcostCat."NS_Actual Cost" = 0) then
                    TcostCat.NS_CheckBool := true
                else
                    TcostCat.NS_CheckBool := false;
                TcostCat.Modify();
            until TcostCat.Next() = 0;
    end;
}