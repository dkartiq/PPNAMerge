table 14021407 "NS_Job Quote Type Relation"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //SMPL - Replaced "Object" table to "AllObj"

    Caption = 'Quote Type Relation';

    fields
    {
        field(1; "NS_Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CALCFIELDS("NS_Table Name");
            end;
        }
        field(11; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Table ID" = CONST(15)) "G/L Account"
            ELSE
            IF ("NS_Table ID" = CONST(27)) Item
            ELSE
            IF ("NS_Table ID" = CONST(156)) Resource;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                NS_GetItemInfo();
            end;
        }
        field(21; "NS_Quote Type Code"; Code[10])
        {
            Caption = 'Quote Type Code';
            DataClassification = CustomerContent;
            TableRelation = "NS_Job Quote Type";

            trigger OnValidate();
            begin
                CALCFIELDS("Quote Type Description");
            end;
        }
        field(101; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(102; "Quote Type Description"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Quote Type".NS_Description WHERE(NS_Code = FIELD("NS_Quote Type Code")));
            Caption = 'Quote Type Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3007; "NS_No. 2"; Code[30])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(3041; "NS_Category Code"; Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(5011; "NS_Modified by"; Code[50])
        {
            Caption = 'Modified by';
            Editable = false;
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10000; "NS_Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObj."Object Name" WHERE("Object Type" = CONST(Table),
                                                    "Object ID" = FIELD("NS_Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "NS_Table ID", "NS_No.", "NS_Quote Type Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        QuoteMgt.NS_GetDescriptionQuoteTypeRelation(Rec);

        "NS_Created by" := USERID[50];
        "NS_Created at Date" := TODAY;
        "NS_Created at Time" := TIME;
    end;

    trigger OnModify();
    begin
        "NS_Modified by" := USERID[50];
        "NS_Modified at Date" := TODAY;
        "NS_Modified at Time" := TIME;
    end;

    var
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";

    procedure NS_GetItemInfo();
    var
        _Item: Record Item;
    begin
        if "NS_No." = '' then begin
            "NS_No. 2" := '';
            NS_Description := '';
            "NS_Category Code" := '';
            exit;
        end;

        case "NS_Table ID" of
            DATABASE::Item:
                if _Item.GET("NS_No.") then begin
                    "NS_No. 2" := _Item."No. 2";
                    NS_Description := _Item.Description;
                    "NS_Category Code" := _Item."Item Category Code";
                end;
        end;
    end;
}

