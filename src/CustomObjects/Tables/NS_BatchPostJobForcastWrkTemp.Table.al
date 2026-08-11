table 14021492 "NS_BatchPostJobForcastWrkTemp"
//PRJ-1098.NK.0.0 11Feb2022 New Table 
{
    DataClassification = ToBeClassified;
    Caption = 'Batch Post Job Forcast Wrk Temp';
    Permissions = tabledata "NS_BatchPostJobForcastWrkTemp" = rimd; //PRJCTPR-155.JS.1.0 18JULY2023
    fields
    {
        field(1; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.';
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(3; "As of Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'As of Date';
        }
        field(4; "POC Method"; enum NS_POCMethod)
        {
            DataClassification = CustomerContent;
            Caption = 'POC Method';
        }
        field(5; "Dept Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dept Code';
        }
        field(6; "Div Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Div Code';
        }
    }

    keys
    {
        key(Key1; "Job No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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

}