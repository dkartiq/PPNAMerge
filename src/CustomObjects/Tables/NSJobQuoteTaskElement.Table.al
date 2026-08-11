table 14021429 "NS_Job Quote Task Element"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Quote Task Element';

    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(25; "NS_Imported from File"; Text[50])
        {
            Caption = 'Imported from File';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Date Created"; DateTime)
        {
            Caption = 'Date Created';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Date Last Modified"; DateTime)
        {
            Caption = 'Date Last Modified';
            DataClassification = CustomerContent;
        }
        field(50; "NS_Item ID"; Text[30])
        {
            Caption = 'Item ID';
            DataClassification = CustomerContent;
        }
        field(60; "NS_Check Sum"; Text[30])
        {
            Caption = 'Check Sum';
            DataClassification = CustomerContent;
        }
        field(70; "NS_Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
            DataClassification = CustomerContent;
        }
        field(80; "NS_User Code"; Text[30])
        {
            Caption = 'User Code';
            DataClassification = CustomerContent;
        }
        field(90; "NS_Link Code"; Text[30])
        {
            Caption = 'Link Code';
            DataClassification = CustomerContent;
        }
        field(100; "NS_Manufacturers Code"; Text[30])
        {
            Caption = 'Manufacturers Code';
            DataClassification = CustomerContent;
        }
        field(110; NS_Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(120; NS_Class; Text[30])
        {
            Caption = 'Class';
            DataClassification = CustomerContent;
        }
        field(130; NS_Instance; Text[30])
        {
            Caption = 'Instance';
            DataClassification = CustomerContent;
        }
        field(140; "NS_Item Type Name"; Text[30])
        {
            Caption = 'Item Type Name';
            DataClassification = CustomerContent;
        }
        field(150; "NS_Item Type"; Integer)
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(160; "NS_Sub Type Name"; Text[30])
        {
            Caption = 'Sub Type Name';
            DataClassification = CustomerContent;
        }
        field(170; "NS_Sub Type"; Integer)
        {
            Caption = 'Sub Type';
            DataClassification = CustomerContent;
        }
        field(180; "NS_Charge Type"; Integer)
        {
            Caption = 'Charge Type';
            DataClassification = CustomerContent;
        }
        field(190; "NS_EO Type"; Integer)
        {
            Caption = 'EO Type';
            DataClassification = CustomerContent;
        }
        field(200; "NS_Is Corner"; Boolean)
        {
            Caption = 'Is Corner';
            DataClassification = CustomerContent;
        }
        field(210; "NS_Is Placed"; Boolean)
        {
            Caption = 'Is Placed';
            DataClassification = CustomerContent;
        }
        field(220; "NS_Is Custom"; Boolean)
        {
            Caption = 'Is Custom';
            DataClassification = CustomerContent;
        }
        field(230; "NS_Is Wall Mounted"; Boolean)
        {
            Caption = 'Is Wall Mounted';
            DataClassification = CustomerContent;
        }
        field(240; "NS_Is Floorstanding"; Boolean)
        {
            Caption = 'Is Floorstanding';
            DataClassification = CustomerContent;
        }
        field(250; NS_Finish; Text[30])
        {
            Caption = 'Finish';
            DataClassification = CustomerContent;
        }
        field(260; NS_Hinge; Text[30])
        {
            Caption = 'Hinge';
            DataClassification = CustomerContent;
        }
        field(270; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(280; "NS_Is Foreign"; Boolean)
        {
            Caption = 'Is Foreign';
            DataClassification = CustomerContent;
        }
        field(290; "NS_Has Foreign"; Boolean)
        {
            Caption = 'Has Foreign';
            DataClassification = CustomerContent;
        }
        field(300; "NS_Type Cost 1 Fixed"; Decimal)
        {
            Caption = 'Type Cost 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(310; "NS_Type List 1 Fixed"; Decimal)
        {
            Caption = 'Type List 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(320; "NS_Type Retail 1 Fixed"; Decimal)
        {
            Caption = 'Type Retail 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(330; "NS_Type Cost 2 Fixed"; Decimal)
        {
            Caption = 'Type Cost 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(340; "NS_Type List 2 Fixed"; Decimal)
        {
            Caption = 'Type List 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(350; "NS_Type Retail 2 Fixed"; Decimal)
        {
            Caption = 'Type Retail 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(360; "NS_Type Cost 3 Fixed"; Decimal)
        {
            Caption = 'Type Cost 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(370; "NS_Type List 3 Fixed"; Decimal)
        {
            Caption = 'Type List 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(380; "NS_Type Retail 3 Fixed"; Decimal)
        {
            Caption = 'Type Retail 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(390; "NS_Type Cost 4 Fixed"; Decimal)
        {
            Caption = 'Type Cost 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(400; "NS_Type List 4 Fixed"; Decimal)
        {
            Caption = 'Type List 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(410; "Type Retail 4 Fixed"; Decimal)
        {
            Caption = 'Type Retail 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(420; "NS_Qty. Cost 1 Fixed"; Decimal)
        {
            Caption = 'Qty. Cost 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(430; "NS_Qty. List 1 Fixed"; Decimal)
        {
            Caption = 'Qty. List 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(440; "NS_Qty. Retail 1 Fixed"; Decimal)
        {
            Caption = 'Qty. Retail 1 Fixed';
            DataClassification = CustomerContent;
        }
        field(450; "NS_Qty. Cost 2 Fixed"; Decimal)
        {
            Caption = 'Qty. Cost 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(460; "NS_Qty. List 2 Fixed"; Decimal)
        {
            Caption = 'Qty. List 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(470; "NS_Qty. Retail 2 Fixed"; Decimal)
        {
            Caption = 'Qty. Retail 2 Fixed';
            DataClassification = CustomerContent;
        }
        field(480; "NS_Qty. Cost 3 Fixed"; Decimal)
        {
            Caption = 'Qty. Cost 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(490; "NS_Qty.List 3 Fixed"; Decimal)
        {
            Caption = 'Qty.List 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(500; "NS_Qty. Retail 3 Fixed"; Decimal)
        {
            Caption = 'Qty. Retail 3 Fixed';
            DataClassification = CustomerContent;
        }
        field(510; "NS_Qty. Cost 4 Fixed"; Decimal)
        {
            Caption = 'Qty. Cost 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(520; "NS_Qty. List 4 Fixed"; Decimal)
        {
            Caption = 'Qty. List 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(530; "NS_Qty. Retail 4 Fixed"; Decimal)
        {
            Caption = 'Qty. Retail 4 Fixed';
            DataClassification = CustomerContent;
        }
        field(540; "NS_Zone ID"; Text[30])
        {
            Caption = 'Zone ID';
            DataClassification = CustomerContent;
        }
        field(550; "NS_Absolute Position"; Text[30])
        {
            Caption = 'Absolute Position';
            DataClassification = CustomerContent;
        }
        field(560; NS_Direction; Text[30])
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
        }
        field(570; "NS_Normal Direction"; Text[30])
        {
            Caption = 'Normal Direction';
            DataClassification = CustomerContent;
        }
        field(580; "NS_Var Type 1"; Text[30])
        {
            Caption = 'Var Type 1';
            DataClassification = CustomerContent;
        }
        field(590; "NS_Var Type 2"; Text[30])
        {
            Caption = 'Var Type 2';
            DataClassification = CustomerContent;
        }
        field(600; "NS_Var Type 3"; Text[30])
        {
            Caption = 'Var Type 3';
            DataClassification = CustomerContent;
        }
        field(610; "NS_Var Type 4"; Text[30])
        {
            Caption = 'Var Type 4';
            DataClassification = CustomerContent;
        }
        field(620; "NS_Var Type 5"; Text[30])
        {
            Caption = 'Var Type 5';
            DataClassification = CustomerContent;
        }
        field(630; "NS_Var Type 6"; Text[30])
        {
            Caption = 'Var Type 6';
            DataClassification = CustomerContent;
        }
        field(640; "NS_Featute Set Reference"; Text[30])
        {
            Caption = 'Featute Set Reference';
            DataClassification = CustomerContent;
        }
        field(650; "NS_Line Item No."; Integer)
        {
            Caption = 'Line Item No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_Job Task No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

