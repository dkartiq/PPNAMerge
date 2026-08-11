table 14021403 "NS_Job Quote Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PPAL-147.AS.1.0 18SEPT2020 Added code to update Unit cost & Total Unit cost on Job Plannning line
    //PPAL-147.AS.2.0 30SEPT2020
    //PPAL-147.AM.3.0 12OCT2020 | Added & Commented code.
    //PPAL-147.AM.3.0 12OCT2020 | Changed code and assigned base field UOM .
    //PPAL-172.MS.1.0 added code for package functionality
    // +------------------------------------------------------------

    Caption = 'Quote Line';

    fields
    {
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Quote Line No."; Integer)
        {
            Caption = 'Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(18; "NS_Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateAttachedToLineNo(Rec);
            end;
        }
        field(21; NS_Revision; Integer)
        {
            Caption = 'Revision';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateShortcutDimCodeForLine(Rec, 1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(41; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateShortcutDimCodeForLine(Rec, 2, "NS_Shortcut Dimension 2 Code");
            end;
        }
        field(108; "NS_Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
            DataClassification = CustomerContent;
        }
        field(109; "NS_Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = CustomerContent;
        }
        field(111; "NS_Address No."; Code[20])
        {
            Caption = 'Address No.';
            TableRelation = "Ship-to Address".Code;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateAddressNo(Rec);
            end;
        }
        field(112; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_UpdateJobPlanningLines(FIELDNO("NS_Location Code"));
                NS_UpdateJobPlanningLinesforOtherEntries(FIELDNO("NS_Location Code"));//PPAL-147.AS.2.0 30SEPT2020
            end;
        }
        field(301; "NS_Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Quote));
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(302; "NS_Sales Quote Line No."; Integer)
        {
            Caption = 'Sales Quote Line No.';
            DataClassification = CustomerContent;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                QuoteMgt.NS_ShowDocDimForLine(Rec);
            end;
        }
        field(1000; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = true;
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Quote No."),
                                                             "Job Task Type" = CONST(Posting));

            trigger OnValidate();
            begin
                if "NS_Job Task No." = '' then
                    ERROR('Job Task No. Must Be Selected before you Can Proceed');
            end;
        }
        field(3001; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            InitValue = Item;
            // OptionCaption = '" ,G/L Account,Item,Resource,Task,Package"';//PPAL-147.AS.2.0 30SEPT2020 Commented
            OptionCaption = ' ,G/L Account,Item,Resource,Task,Package';//PPAL-147.AS.2.0 30SEPT2020 Added
            OptionMembers = " ","G/L Account",Item,Resource,Task,Template;
        }
        field(3006; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Template)) Job WHERE("NS_Job Class" = CONST(Template))
            ELSE
            IF (NS_Type = CONST(Task)) "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Quote No."),
                                                                                        "Job Task Type" = CONST(Posting));

            trigger OnValidate();
            var
                JobTask: Record "Job Task";
            //JobPlanningLine: Record "Job Planning Line";
            begin
                if (NS_Type <> NS_Type::Template) and (NS_Type <> NS_Type::Task) then
                    if "NS_Job Task No." = '' then
                        ERROR('Job Task No. Must Be Selected before you Can Proceed');
                case NS_Type of

                    NS_Type::Item:

                        if ("NS_No." <> xRec."NS_No.") and (xRec."NS_No." <> '') then
                            if Item.GET("NS_No.") then begin
                                NS_Description := Item.Description;
                                QuoteMgt.NS_LoadFromItem(Rec, Item);
                            end;



                    NS_Type::"G/L Account":

                        if ("NS_No." <> xRec."NS_No.") and (xRec."NS_No." <> '') then
                            if GLAcct.GET("NS_No.") then begin
                                NS_Description := GLAcct.Name;
                                QuoteMgt.NS_LoadFromGLAct(GLAcct, Rec);
                            end;

                    NS_Type::Resource:

                        if ("NS_No." <> xRec."NS_No.") and (xRec."NS_No." <> '') then
                            if Resource.GET("NS_No.") then begin
                                NS_Description := Resource.Name;
                                QuoteMgt.NS_LoadFromResource(Rec, Resource);
                            end;


                    NS_Type::Task:

                        if ("NS_No." <> xRec."NS_No.") then
                            if JobTask.GET("NS_Quote No.", "NS_No.") then
                                NS_Description := JobTask.Description;


                    NS_Type::Template:

                        if TmplJob.GET("NS_No.") then
                            NS_Description := TmplJob.Description;

                end;
            end;
        }
        field(3007; "NS_No. 2"; Code[30])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(3011; NS_Description; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3021; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateQuantity2(Rec);
                "NS_Total Cost" := "NS_Unit Cost" * NS_Quantity;
                "NS_Total Price" := "NS_Unit Price" * NS_Quantity;
                QuoteMgt.NS_OnValidateUnitPrice(Rec, Rec.FIELDNO(NS_Quantity));
            end;
        }
        field(3022; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = CustomerContent;
        }
        field(3026; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            IF (NS_Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("NS_No."));
        }
        field(3027; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(3041; "NS_Category Code"; Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "Item Category";
            DataClassification = CustomerContent;
        }
        field(3051; "NS_Attribute Set Entry No."; Integer)
        {
            Caption = 'Attribute Set Entry No.';
            DataClassification = CustomerContent;
        }
        field(3091; "NS_Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO("NS_Unit Cost"));
                NS_UpdateJobPlanningLines(FIELDNO("NS_Unit Cost"));//PPAL-147.AS.1.0 18SEPT2020
                NS_UpdateJobPlanningLinesforOtherEntries(FIELDNO("NS_Unit Cost"));//PPAL-147.AS.2.0 30SEPT2020
            end;
        }
        field(3092; "NS_Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            DataClassification = CustomerContent;
        }
        field(3094; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3096; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            DataClassification = CustomerContent;
        }
        field(3097; "NS_Sales Tax Amount"; Decimal)
        {
            Caption = 'Sales Tax Amount';
            DataClassification = CustomerContent;
        }
        field(3101; "NS_Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO("NS_Unit Price"));
                NS_UpdateJobPlanningLines(FIELDNO("NS_Unit Price"));
                NS_UpdateJobPlanningLinesforOtherEntries(FIELDNO("NS_Unit Price"));//PPAL-147.AS.2.0 30SEPT2020
            end;
        }
        field(3103; "NS_Item List Price"; Decimal)
        {
            CalcFormula = Lookup(Item."Unit Price" WHERE("No." = FIELD("NS_No.")));
            Caption = 'Item List Price';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3104; "NS_Contract Price Found"; Boolean)
        {
            Caption = 'Contract Price Found';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3106; "NS_Total Price"; Decimal)
        {
            Caption = 'Total Price';
            DataClassification = CustomerContent;
        }
        field(3121; NS_Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO(NS_Amount));
            end;
        }
        field(3122; "NS_Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including Tax';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3131; NS_Markup; Decimal)
        {
            Caption = 'Markup';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO(NS_Markup));
            end;
        }
        field(3136; "NS_Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO("NS_Line Discount Amount"));
            end;
        }
        field(3137; "NS_Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO("NS_Line Discount %"));
            end;
        }
        field(3138; "NS_Gross Margin %"; Decimal)
        {
            Caption = 'Gross Margin %';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3139; "NS_Gross Margin"; Decimal)
        {
            Caption = 'Gross Margin';
            DataClassification = CustomerContent;
        }
        field(3151; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateVariantCode(Rec);
            end;
        }
        field(3201; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateVendorNo(Rec);
            end;
        }
        field(3202; "NS_Vendor Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(3203; "NS_Vendor Contact"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Vendor Contact';
            DataClassification = CustomerContent;
        }
        field(3204; "NS_Vendor Contact No."; Code[20])
        {
            Caption = 'Vendor Contact No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Contact;
        }
        field(3211; "NS_Vendor Quote No."; Text[30])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = CustomerContent;
        }
        field(3221; "NS_Vendor Cost"; Decimal)
        {
            Caption = 'Vendor Cost';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUnitPrice(Rec, FIELDNO("NS_Vendor Cost"));
            end;
        }
        field(3231; "NS_Attached Lines Exist"; Boolean)
        {
            CalcFormula = Exist("NS_Job Quote Line" WHERE("NS_Quote No." = FIELD("NS_Quote No."),
                                                        "NS_Attached to Line No." = FIELD("NS_Quote Line No.")));
            Caption = 'Attached Lines Exist';
            Editable = false;
            FieldClass = FlowField;
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
        field(5011; "NS_Modified by"; Code[50])
        {
            Caption = 'Modified by';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            DataClassification = CustomerContent;
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            DataClassification = CustomerContent;
        }
        field(5701; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";

            trigger OnValidate();
            begin
                NS_JobsSetup.GET();

                if (NS_JobsSetup."NS_Cost Category Required Bud") and ("NS_Cost Category" = '') then
                    ERROR(Text14021104Lbl, "NS_Quote No.", "NS_Quote Line No.");
                NS_UpdateJobPlanningLines(FIELDNO("NS_Cost Category"));//PPAL-147.AS.2.0 30SEPT2020
                NS_UpdateJobPlanningLinesforOtherEntries(FIELDNO("NS_Cost Category"));//PPAL-147.AS.2.0 30SEPT2020
            end;
        }
        field(14021102; "NS_Revenue Category"; Code[10])
        {
            Caption = 'Revenue Category';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";

            trigger OnValidate();
            begin
                NS_JobsSetup.GET();

                if (NS_JobsSetup."NS_Revenue Cat. Required Bud") and ("NS_Revenue Category" = '') then
                    ERROR(Text14021106lbl, "NS_Quote No.", "NS_Quote Line No.");
                NS_UpdateJobPlanningLines(FIELDNO("NS_Revenue Category"));///PPAL-147.AS.2.0 30SEPT2020
                NS_UpdateJobPlanningLinesforOtherEntries(FIELDNO("NS_Revenue Category"));///PPAL-147.AS.2.0 30SEPT2020
            end;
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", "NS_Quote Line No.")
        {
        }
        key(Key2; "NS_Category Code", "NS_No.")
        {
        }
        key(Key3; "NS_Category Code", "NS_Quote Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        QuoteMgt.NS_OnDeleteJobQuoteLine(Rec);
    end;

    trigger OnInsert();
    begin
        QuoteMgt.NS_OnInsertQuoteLine(Rec);
    end;

    trigger OnModify();
    begin
        QuoteMgt.NS_OnModifyQuoteLine(Rec);
    end;

    trigger OnRename();
    begin
        ERROR('You cannot change the %1, %2, %3 of this %4.', FIELDCAPTION("NS_Quote No."), FIELDCAPTION("NS_Quote Line No."), FIELDCAPTION("NS_Job Task No."), TABLECAPTION);//PPAL-147.AS.2.0 01OCT2020
        QuoteMgt.NS_OnRenameQuoteLine(Rec, xRec);
        QuoteMgt.NS_OnRenameQuoteLinePackage(Rec, xRec, '');//PPAL-172.MS.1.0
    end;

    var
        QuoteHeader: Record "NS_Job Quote Header";
        TmplJob: Record Job;
        Item: Record Item;
        NS_JobsSetup: Record "Jobs Setup";

        GLAcct: Record "G/L Account";
        Resource: Record Resource;
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";

        //Text14021103Lbl: Label 'A cost category cannot be entered on a Contract type line.';
        Text14021104Lbl: Label 'There must be a cost category for job %1 on line %2.', Comment = '%1 = "NS_Quote No." ; %2 = "NS_Quote Line No."';
        //Text14021105Lbl: Label 'A revenue category cannot be entered on a Schedule type line.';
        Text14021106Lbl: Label 'There must be a revenue category for job %1 on line %2.', Comment = '%1 = "NS_Quote No." ; %2 = "NS_Quote Line No."';

    procedure GetQuoteHeader(_QuoteLine: Record "NS_Job Quote Line");
    begin
        if QuoteHeader."NS_Quote No." <> _QuoteLine."NS_Quote No." then
            if not QuoteHeader.GET(_QuoteLine."NS_Quote No.") then
                QuoteHeader.INIT();
    end;

    local procedure NS_UpdateJobPlanningLines(FieldNumber: Integer);
    var
        JPL: Record "Job Planning Line";
    begin
        if NS_Type = NS_Type::Task then
            exit;

        JPL.SETRANGE("Job No.", "NS_Quote No.");
        JPL.SETRANGE("Job Task No.", "NS_Job Task No.");
        JPL.SETRANGE("No.", "NS_No.");
        JPL.SETRANGE("NS_Entry Type", JPL."NS_Entry Type"::Both);
        JPL.SETRANGE("Line Type", JPL."Line Type"::"Both Budget and Billable");
        case NS_Type of
            NS_Type::Item:
                JPL.SETRANGE(Type, JPL.Type::Item);
            NS_Type::"G/L Account":
                JPL.SETRANGE(Type, JPL.Type::"G/L Account");
            NS_Type::Resource:
                JPL.SETRANGE(Type, JPL.Type::Resource);
        end;

        if JPL.FINDSET() then
            repeat
                case FieldNumber of
                    FIELDNO("NS_Location Code"):
                        begin
                            JPL."Location Code" := "NS_Location Code";
                            JPL."NS_Cost Category" := "NS_Cost Category";//PPAL-147.AS.2.0 30SEPT2020
                            JPL."NS_Revenue Category" := "NS_Revenue Category";//PPAL-147.AS.2.0 30SEPT2020
                        end;
                    FIELDNO("NS_Unit Price"):
                        begin
                            JPL.NS_TempNo := JPL."No.";
                            JPL.NS_TempLocation := JPL."Location Code";
                            JPL.NS_TempVariant := JPL."Variant Code";
                            JPL.NS_TempUM := JPL."Unit of Measure Code";
                            JPL.NS_TempWorkType := JPL."Work Type Code";
                            JPL.VALIDATE("Unit Price (LCY)", "NS_Unit Price");
                        end;
                    FIELDNO("NS_Unit Cost"):
                        begin
                            JPL.NS_TempNo := JPL."No.";
                            JPL.NS_TempLocation := JPL."Location Code";
                            JPL.NS_TempVariant := JPL."Variant Code";
                            JPL.NS_TempUM := JPL."Unit of Measure Code";
                            JPL.NS_TempWorkType := JPL."Work Type Code";
                            JPL."NS_Cost Category" := "NS_Cost Category";//PPAL-147.AS.2.0 30SEPT2020
                            JPL."NS_Revenue Category" := "NS_Revenue Category";//PPAL-147.AS.2.0 30SEPT2020
                            JPL.VALIDATE("Unit cost (LCY)", "NS_Unit cost");//PPAL-163.MS.1.0
                        end;
                    //PPAL-147.AS.2.0 30SEPT2020 - start
                    FIELDNO("NS_Cost Category"):
                        begin
                            JPL."NS_Cost Category" := "NS_Cost Category";//PPAL-147.AS.2.0 30SEPT2020
                            JPL."NS_Revenue Category" := "NS_Revenue Category";//PPAL-147.AS.2.0 30SEPT2020
                        end;

                    FIELDNO("NS_Revenue Category"):
                        begin
                            JPL."NS_Cost Category" := "NS_Cost Category";//PPAL-147.AS.2.0 30SEPT2020
                            JPL."NS_Revenue Category" := "NS_Revenue Category";//PPAL-147.AS.2.0 30SEPT2020
                        end;
                //PPAL-147.AS.2.0 30SEPT2020 - end
                end;
                JPL."Contract Line" := true;//PPAL-147.AS.2.0 30SEPT2020
                JPL.MODIFY;
            until JPL.NEXT = 0;
    end;


    //PPAL-147.AS.2.0 30SEPT2020 - start
    local procedure NS_UpdateJobPlanningLinesforOtherEntries(FieldNumber: Integer);
    var
        JPL: Record "Job Planning Line";
    begin
        if NS_Type = NS_Type::Task then
            exit;

        JPL.SETRANGE("Job No.", "NS_Quote No.");
        JPL.SETRANGE("Job Task No.", "NS_Job Task No.");
        JPL.SETRANGE("No.", "NS_No.");
        JPL.SETFILTER("NS_Entry Type", '<>%1', JPL."NS_Entry Type"::Both);
        //JPL.SetFilter("Line Type", '<>%1', JPL."Line Type"::"Both Budget and Billable");//PPAl-147.AM.3.0 Commented Code
        JPL.SetRange("Line Type", JPL."Line Type"::Budget);//PPAL-147.AM.3.0

        case NS_Type of
            NS_Type::Item:
                begin
                    JPL.SETRANGE(Type, JPL.Type::Item);
                end;
            NS_Type::"G/L Account":
                begin
                    JPL.SETRANGE(Type, JPL.Type::"G/L Account");
                end;
            NS_Type::Resource:
                begin
                    JPL.SETRANGE(Type, JPL.Type::Resource);
                end;
        end;

        if JPL.FINDSET then
            repeat
                case FieldNumber of
                    FIELDNO("NS_Location Code"):
                        begin
                            JPL."Location Code" := "NS_Location Code";
                            JPL."NS_Cost Category" := "NS_Cost Category";
                            JPL."NS_Revenue Category" := "NS_Revenue Category";
                        end;
                    FIELDNO("NS_Unit Price"):
                        begin
                            JPL.NS_TempNo := JPL."No.";
                            JPL.NS_TempLocation := JPL."Location Code";
                            JPL.NS_TempVariant := JPL."Variant Code";
                            JPL."Unit of Measure Code" := "NS_Unit of Measure Code";//PPAL-147.AM.3.0
                            JPL.NS_TempWorkType := JPL."Work Type Code";
                            JPL."NS_Cost Category" := "NS_Cost Category";
                            JPL."NS_Revenue Category" := "NS_Revenue Category";
                            JPL.VALIDATE("Unit Price (LCY)", "NS_Unit Price");
                        end;
                    FIELDNO("NS_Unit Cost"):
                        begin
                            JPL.NS_TempNo := JPL."No.";
                            JPL.NS_TempLocation := JPL."Location Code";
                            JPL.NS_TempVariant := JPL."Variant Code";
                            JPL."Unit of Measure Code" := "NS_Unit of Measure Code";//PPAL-147.AM.3.0
                            JPL.NS_TempWorkType := JPL."Work Type Code";
                            JPL."NS_Cost Category" := "NS_Cost Category";
                            JPL."NS_Revenue Category" := "NS_Revenue Category";
                            JPL.VALIDATE("Unit Cost (LCY)", "NS_Unit Cost");
                        end;

                    FIELDNO("NS_Cost Category"):
                        begin
                            JPL."NS_Cost Category" := "NS_Cost Category";
                            JPL."NS_Revenue Category" := "NS_Revenue Category";
                        end;

                    FIELDNO("NS_Revenue Category"):
                        begin
                            JPL."NS_Cost Category" := "NS_Cost Category";
                            JPL."NS_Revenue Category" := "NS_Revenue Category";
                        end;

                end;
                JPL.MODIFY;
            until JPL.NEXT = 0;
    end;
    //PPAL-147.AS.2.0 30SEPT2020 - end
}

