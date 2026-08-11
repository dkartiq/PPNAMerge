table 14021301 "NS_Subcontract Lines"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-271/PRJ-272 VT1.0 21-05-20 Code Added
    //PRJ-273/PRJ-274 VT1.0 21-05-20 Code Added
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PRJ-616.N.S.1.0 Add Restrication on new line insert when  Subcontract PO is posted
    //PRJ-866.JS.1.0 18Aug2021 | add one field
    //PRJ-948.JS.1.0  29Sep2021 | Add table releation

    Caption = 'Subcontract Lines';

    fields
    {
        field(1; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            NotBlank = true;
            DataClassification = CustomerContent;
            TableRelation = NS_Subcontract."NS_No.";   //PRJ-948.JS.1.0  29Sep2021  

        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            //TableRelation = "Job Planning Line"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));//PRJ-616.N.S.1.0 Comment
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No.")); //PRJ-616.N.S.1.0
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job Task Description"; Code[100]) //PRJ-301.MS.1.0
        {
            Caption = 'Job Task Description';
            // >> Upgrade
            // DataClassification = CustomerContent;
            //CalcFormula = Lookup("Job Task".Description WHERE("Job No." = FIELD("NS_Job No."),
            // "Job Task No." = FIELD("NS_Job Task No.")));
            Description = '#RG008';
            Editable = false;
            //FieldClass = FlowField;
            // << Upgrade
        }
        field(7; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(8; "NS_Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(10; NS_Type; Option)
        {
            Caption = 'Type';
            // OptionCaption = ' ,Resource,Item,G/L Account';
            // OptionMembers = " ",Resource,Item,"G/L Account";
            // >> Upgrade
            Description = '001 "Fixed Asset" added to Option String';
            OptionCaption = ' ,Resource,Item,G/L Account,Fixed Asset';
            OptionMembers = " ",Resource,Item,"G/L Account","Fixed Asset";
            // << Upgrade
            DataClassification = CustomerContent;
        }
        field(11; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                Resource: Record Resource;
                Item: Record Item;
                GLAccount: Record "G/L Account";
                // >> Upgrade
                FixedAsset: Record "Fixed Asset";
            // << Upgrade
            begin
                case NS_Type of
                    NS_Type::Resource:
                        begin
                            Resource.RESET();
                            if PAGE.RUNMODAL(0, Resource) = ACTION::LookupOK then begin
                                "NS_No." := Resource."No.";
                                NS_Description := Resource.Name;
                                "NS_Job Cost Category" := Resource."NS_Job Cost Category";//PRJ-616.N.S.1.0
                                "NS_Unit of Measure Code" := Resource."Base Unit of Measure";//PRJ-616.N.S.1.0
                                "NS_Unit Cost" := Resource."Unit Cost";//PRJ-616.N.S.1.0
                            end;
                        end;
                    NS_Type::Item:
                        begin
                            Item.RESET();
                            if PAGE.RUNMODAL(0, Item) = ACTION::LookupOK then begin
                                "NS_No." := Item."No.";
                                NS_Description := Item.Description;
                                "NS_Job Cost Category" := Item."NS_Job Cost Category";//PRJ-616.N.S.1.0
                                "NS_Unit of Measure Code" := Item."Base Unit of Measure";//PRJ-616.N.S.1.0
                                "NS_Unit Cost" := Item."Unit Cost";//PRJ-616.N.S.1.0
                            end;
                        end;
                    NS_Type::"G/L Account":
                        begin
                            GLAccount.RESET();
                            if PAGE.RUNMODAL(0, GLAccount) = ACTION::LookupOK then begin
                                "NS_No." := GLAccount."No.";
                                NS_Description := GLAccount.Name;
                            end;
                        end;
                    // >> Upgrade
                    // >> 001
                    NS_Type::"Fixed Asset":
                        begin
                            FixedAsset.Reset;
                            if PAGE.RunModal(0, FixedAsset) = ACTION::LookupOK then begin
                                FixedAsset.TestField(Inactive, false);
                                FixedAsset.TestField(Blocked, false);
                                "NS_No." := FixedAsset."No.";
                                NS_Description := FixedAsset.Description;
                            end;
                        end;
                // << 001
                // << Upgrade
                end;
            end;

            trigger OnValidate();
            // >> Upgrade
            var
                FixedAsset: Record "Fixed Asset";
            // << Upgrade
            begin
                if "NS_No." = '' then
                    exit;

                case NS_Type of
                    NS_Type::Resource:
                        begin
                            Resource.GET("NS_No.");
                            NS_Description := Resource.Name;
                            "NS_Direct Unit Cost" := Resource."Unit Cost";
                            "NS_Unit Cost" := Resource."Unit Cost";
                            "NS_Unit of Measure Code" := Resource."Base Unit of Measure";
                        end;
                    NS_Type::Item:
                        begin
                            Item.GET("NS_No.");
                            NS_Description := Item.Description;
                            "NS_Direct Unit Cost" := Item."Unit Cost";
                            "NS_Unit Cost" := Item."Unit Cost";
                            "NS_Unit of Measure Code" := Item."Base Unit of Measure";
                        end;
                    NS_Type::"G/L Account":
                        begin
                            GLAcc.GET("NS_No.");
                            GLAcc.CheckGLAcc();
                            GLAcc.TESTFIELD("Direct Posting", true);
                            NS_Description := GLAcc.Name;
                        end;
                    // >> Upgrade
                    // >> 001
                    NS_Type::"Fixed Asset":
                        begin
                            FixedAsset.Get("NS_No.");
                            FixedAsset.TestField(Inactive, false);
                            FixedAsset.TestField(Blocked, false);
                            NS_Description := FixedAsset.Description;
                        end;
                // << 001
                // << Upgrade
                end;
            end;
        }
        field(15; NS_Description; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Quantity (Base)" := NS_CalcBaseQty(NS_Quantity);
                "NS_Total Cost" := ROUND(NS_Quantity * "NS_Unit Cost");
            end;
        }
        field(21; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            "Unit of Measure".Code;
            DataClassification = CustomerContent;
        }
        field(22; "NS_Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(23; "NS_Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Total Cost" := ROUND(NS_Quantity * "NS_Unit Cost");
            end;
        }
        field(24; "NS_Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; "NS_Progress Payment Method"; Option)
        {
            Caption = 'Billing Method';
            OptionCaption = ' ,%,Unit,L/S';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;
        }
        field(32; "NS_Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;
        }
        field(33; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(34; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code");
            end;
        }
        field(100; "NS_Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("NS_Qty. per Unit of Measure", 1);
                VALIDATE(NS_Quantity, "NS_Quantity (Base)");
            end;
        }
        field(101; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(102; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
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
                "NS_Dimension Set ID" :=
                  DimMgt.EditDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2 %3 %4', "NS_Subcontract No.", DocumentType_lbl, "NS_No.", "NS_Line No."));
            end;
        }
        field(5402; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Job Planning Line No."; Integer)
        {
            Caption = 'Job Planning Line No.';
            DataClassification = CustomerContent;
        }
        //PRJ-273/PRJ-274 VT1.0 21-05-20 begin
        field(14021113; "NS_PO No."; Code[20])
        {
            Caption = 'PO No.';
            DataClassification = CustomerContent;
        }
        field(14021114; "NS_PO Line No."; Integer)
        {
            Caption = 'PO Line No.';
            DataClassification = CustomerContent;
        }
        //PRJ-273/PRJ-274 VT1.0 2105-20 end
        field(14021115; "NS_JPL Line No."; integer)     //PRJ-866.JS.1.0 18Aug2021
        {
            Caption = 'JPL Line No.';
            Editable = false;
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "NS_Subcontract No.", NS_Type, "NS_No.", "NS_Line No.")
        {
        }
        key(Key2; "NS_Subcontract No.", "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Line No.")
        {
            SumIndexFields = "NS_Total Cost", "NS_Quantity (Base)";
        }
        key(Key3; "NS_Job No.", "NS_Subcontract No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Job Cost Category", "NS_Line No.")
        {
            SumIndexFields = "NS_Total Cost", "NS_Quantity (Base)";
        }
        key(Key4; "NS_Subcontract No.", NS_Type, "NS_No.", "NS_Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Line No.")
        {
        }
        key(Key5; "NS_Subcontract No.", "NS_Line No.")//PRJ-271/PRJ-272 VT1.0 21-05-20
        {

        }
        key(Key6; "NS_PO No.", "NS_PO Line No.")//PRJ-273/PRJ-274 VT1.0 21-05-20
        {

        }
    }
    fieldgroups
    {
    }

    trigger OnInsert();
    var
        PurchaseHeader: Record "Purchase Header";//PRJ-616.N.S.1.0
        NS_Subcontract_Rec: Record NS_Subcontract;//PRJ-616.N.S.1.0
    begin
        //PRJ-616.N.S.1.0 Start
        if NS_Subcontract_Rec.Get(Rec."NS_Subcontract No.") and (NS_Subcontract_Rec."NS_Purchase Document No." <> '') then begin
            if not PurchaseHeader.get(PurchaseHeader."Document Type"::Order, NS_Subcontract_Rec."NS_Purchase Document No.") then
                Error('You have already posted the PO No. %1, Please create a New Subcontract', NS_Subcontract_Rec."NS_Purchase Document No.");
        end;
        //PRJ-616.N.S.1.0 END
        Subcontract.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
    end;

    trigger OnModify();
    begin
        Subcontract.NS_JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
    end;
    //PRJ-271/PRJ-272 VT1.0 21-05-20 begin
    trigger OnDelete()
    var
        JobPlanningLine: Record "Job Planning Line";
        SubContract: Record NS_Subcontract;

    begin
        SubContract.get("NS_Subcontract No.");
        //SubContract.TestField("NS_Purchase Document No.", '');//PRJ-616.N.S.1.0 Comment
        Rec.TestField("NS_PO No.", '');//PRJ-616.N.S.1.0
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("NS_Subcontract No.", "NS_Subcontract No.");
        JobPlanningLine.SetRange("NS_Subcontract Line No.", "NS_Line No.");
        if JobPlanningLine.FindFirst() then begin
            JobPlanningLine."NS_Subcontract No." := '';
            JobPlanningLine."NS_Subcontract Line No." := 0;
            JobPlanningLine.Modify();
        end;

    end;
    //PRJ-271/PRJ-272 VT1.0 21-05-20 end
    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Subcontract: Record NS_Subcontract;
        Resource: Record Resource;
        DimMgt: Codeunit DimensionManagement;
        DocumentType_Lbl: Label 'Subcontract';

    local procedure NS_CalcBaseQty(Qty: Decimal): Decimal;
    begin
        exit(ROUND(Qty * "NS_Qty. per Unit of Measure", 0.00001));
    end;

    procedure ShowVendorInsurance();
    var
        VendorInsurance: Record "NS_Vendor Insurance";
        VendorInsurances: Page "NS_Vendor Insurances";
    begin
        CLEAR(VendorInsurances);
        VendorInsurance.RESET();
        VendorInsurance.SETCURRENTKEY("NS_Vendor No.");
        VendorInsurance.SETRANGE("NS_Job No.", "NS_Job No.");
        VendorInsurances.SETTABLEVIEW(VendorInsurance);
        VendorInsurances.EDITABLE(false);
        VendorInsurances.RUN();
    end;

    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::NS_Subcontract, "NS_No.", FieldNumber, ShortcutDimCode);
        MODIFY();
    end;

    procedure ShowDimensions();
    begin
        "NS_Dimension Set ID" :=
          DimMgt.EditDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2', "NS_Subcontract No.", "NS_Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("NS_Dimension Set ID", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
    end;

    //SMPL Replaced DimensionManagement named reference to ID (symbols bug)
}

