table 14021304 "NS_Subcontract Journal Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-817.JS.1.0�04Aug2021 | Add field work unit completed

    Caption = 'Subcontract Journal Line';

    fields
    {
        field(1; "NS_Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "NS_SubcontractJournalTemplate";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Subcontract No." = '' then begin
                    NS_CreateDim(
                      DATABASE::NS_Subcontract, "NS_Subcontract No.",
                      DimMgt.TypeToTableID2(NS_Type), "NS_No.", 0, '');
                    exit;
                end;

                SubcontractHeader.GET("NS_Subcontract No.");
                SubcontractHeader.TESTFIELD(NS_Blocked, 0);
                SubcontractHeader.TESTFIELD(NS_Status, SubcontractHeader.NS_Status::Order);

                NS_CreateDim(
                  DATABASE::NS_Subcontract, "NS_Subcontract No.",
                  DimMgt.TypeToTableID2(NS_Type), "NS_No.", 0, '');
            end;
        }
        field(4; "NS_Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                VALIDATE("NS_Document Date", "NS_Posting Date");
            end;
        }
        field(5; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(6; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account,Ledger';
            OptionMembers = Resource,Item,"G/L Account",Ledger;
            DataClassification = CustomerContent;
        }
        field(8; "NS_No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (NS_Type = CONST(Resource)) Resource
            ELSE
            IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST("G/L Account")) "G/L Account";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Variant Code" := '';
                if "NS_No." = '' then begin
                    NS_CreateDim(
                      DimMgt.TypeToTableID2(NS_Type), "NS_No.",
                      DATABASE::Job, "NS_Job No.", 0, '');
                    exit;
                end;

                case NS_Type of
                    NS_Type::Item:
                        begin
                            Item.GET("NS_No.");
                            NS_Description := Item.Description;
                            "NS_Unit Cost" := Item."Unit Cost";
                            "NS_Posting Group" := Item."Inventory Posting Group";
                            VALIDATE("NS_Unit of Measure Code", Item."Base Unit of Measure");
                        end;
                    NS_Type::"G/L Account":
                        begin
                            GLAcc.GET("NS_No.");
                            GLAcc.CheckGLAcc();
                            GLAcc.TESTFIELD("Direct Posting", true);
                            NS_Description := GLAcc.Name;
                        end;
                end;

                VALIDATE(NS_Quantity);

                NS_CreateDim(
                  DimMgt.TypeToTableID2(NS_Type), "NS_No.",
                  DATABASE::Job, "NS_Job No.", 0, '');
            end;
        }
        field(9; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(12; "NS_Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Type = NS_Type::Item then begin
                    Item.GET("NS_No.");
                    if Item."Costing Method" = Item."Costing Method"::Standard then
                        ERROR(
                          Text000_Txt,
                          FIELDCAPTION("NS_Unit Cost"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method");
                end;
                "NS_Total Cost" := ROUND(NS_Quantity * "NS_Unit Cost");
            end;
        }
        field(14; "NS_Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(18; "NS_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("NS_No."))
            ELSE
            "Unit of Measure";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Resource: Record Resource;
            begin
                case NS_Type of
                    NS_Type::Item:
                        begin
                            Item.GET("NS_No.");
                            NS_GetGLSetup;
                            "NS_Qty. per Unit of Measure" :=
                              UOMMgt.GetQtyPerUnitOfMeasure(Item, "NS_Unit of Measure Code");
                            "NS_Unit Cost" :=
                              ROUND(
                                Item."Unit Cost" * "NS_Qty. per Unit of Measure",
                                GLSetup."Unit-Amount Rounding Precision");
                        end;
                    NS_Type::"G/L Account":
                        "NS_Qty. per Unit of Measure" := 1;
                end;
                if CurrFieldNo = FIELDNO("NS_Unit of Measure Code") then
                    VALIDATE(NS_Quantity);
            end;
        }
        field(21; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if (NS_Type = NS_Type::Item) then begin
                    NS_GetLocation("NS_Location Code");
                    Location.TESTFIELD("Directed Put-away and Pick", false);
                end;
                "NS_Bin Code" := '';
                NS_CheckItemAvailable;
            end;
        }
        field(22; NS_Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(30; "NS_Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            Editable = false;
            TableRelation = IF (NS_Type = CONST(Item)) "Inventory Posting Group";
            DataClassification = CustomerContent;
        }
        field(31; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(32; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code");
            end;
        }
        field(33; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
            DataClassification = CustomerContent;
        }
        field(45; "NS_Job Task No."; Code[35])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
        }
        field(61; "NS_Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Editable = true;
            OptionCaption = 'Usage,Purchase,Payment';
            OptionMembers = Usage,Purchase,Payment;
            DataClassification = CustomerContent;
        }
        field(62; "NS_Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
        field(63; "NS_Profit %"; Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            DataClassification = CustomerContent;
        }
        field(66; "NS_Post Subcontract Entry Only"; Boolean)
        {
            Caption = 'Post Subcontract Entry Only';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if (NS_Type <> NS_Type::Item) then
                    ERROR(
                      Text000_Txt,
                      FIELDCAPTION("NS_Post Subcontract Entry Only"), FIELDCAPTION(NS_Type), SubcontractJnlLine.NS_Type);
                if (NS_Type = NS_Type::Item) and (not "NS_Post Subcontract Entry Only") then begin
                    NS_GetLocation("NS_Location Code");
                    Location.TESTFIELD("Directed Put-away and Pick", false);
                end;
            end;
        }
        field(73; "NS_Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Job Journal Batch".Name WHERE("Journal Template Name" = FIELD("NS_Journal Template Name"));
            DataClassification = CustomerContent;
        }
        field(74; "NS_Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            DataClassification = CustomerContent;
        }
        field(75; "NS_Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
            DataClassification = CustomerContent;
        }
        field(76; "NS_Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(77; "NS_Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
            DataClassification = CustomerContent;
        }
        field(81; "NS_Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
            DataClassification = CustomerContent;
        }
        field(82; "NS_Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
            DataClassification = CustomerContent;
        }
        field(83; "NS_Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(86; "NS_Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            TableRelation = "Entry/Exit Point";
            DataClassification = CustomerContent;
        }
        field(87; "NS_Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(88; "NS_External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(89; "NS_Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
            DataClassification = CustomerContent;
        }
        field(90; "NS_Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
            DataClassification = CustomerContent;
        }
        field(91; "NS_Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                TESTFIELD(NS_Type, NS_Type::Item);
                NS_SelectItemEntry(FIELDNO("NS_Serial No."));
            end;
        }
        field(92; "NS_Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(93; "NS_Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
            Editable = false;
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(94; "NS_Source Currency Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Source Currency Total Cost';
            Editable = false;
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
                NS_ShowDimensions;
            end;
        }
        field(5402; "NS_Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (NS_Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("NS_No."));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Variant Code" = '' then
                    exit;

                TESTFIELD(NS_Type, NS_Type::Item);

                ItemVariant.GET("NS_No.", "NS_Variant Code");
                NS_Description := ItemVariant.Description;
            end;
        }
        field(5403; "NS_Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("NS_Location Code"));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD("NS_Location Code");

                NS_CheckItemAvailable;
            end;
        }
        field(5404; "NS_Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(5410; "NS_Quantity (Base)"; Decimal)
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
        field(10051; "NS_Balancing Acc. No."; Code[20])
        {
            Caption = 'Balancing Acc. No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                TESTFIELD(NS_Type, NS_Type::"G/L Account");
            end;
        }
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Job No." = '' then begin
                    NS_CreateDim(
                      DATABASE::Job, "NS_Job No.",
                      DimMgt.TypeToTableID2(NS_Type), '', 0, '');
                    exit;
                end;

                Job.GET("NS_Job No.");
                Job.TESTFIELD(Blocked, 0);
                Job.TESTFIELD(Status, Job.Status::Open.AsInteger());

                NS_CreateDim(
                  DATABASE::Job, "NS_Job No.",
                  DimMgt.TypeToTableID2(NS_Type), '', 0, '');
            end;
        }
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            TableRelation = "NS_Job Cost Category";
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
        field(14021120; "NS_External Relationship Type"; Option)
        {
            Caption = 'External Relationship Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(14021121; "NS_External Relationship No."; Code[20])
        {
            Caption = 'External Relationship No.';
            TableRelation = IF ("NS_External Relationship Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("NS_External Relationship Type" = CONST(Vendor)) Vendor."No.";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_External Relationship No." > '') and ("NS_External Relationship Type" = 0) then
                    ERROR(Text001_Txt, FIELDCAPTION("NS_External Relationship Type"));

                if "NS_External Relationship No." > '' then begin
                    "NS_External Relationship Name" := '';
                    case "NS_External Relationship Type" of
                        "NS_External Relationship Type"::Customer:
                            if Customer.GET("NS_External Relationship No.") then
                                "NS_External Relationship Name" := Customer.Name;
                        "NS_External Relationship Type"::Vendor:
                            if Vendor.GET("NS_External Relationship No.") then
                                "NS_External Relationship Name" := Vendor.Name;
                    end;

                end;
            end;
        }
        field(14021122; "NS_External Relationship Name"; Text[100])
        {
            Caption = 'External Relationship Name';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Job Ledger Entry No."; Integer)
        {
            Caption = 'Job Ledger Entry No.';
            TableRelation = "Job Ledger Entry"."No.";
            DataClassification = CustomerContent;
        }
        field(14021151; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }

        field(14021421; "NS_Work Unit Completed"; Decimal)   //PRJ-817.JS.1.0�04Aug2021
        {
            Caption = 'Work Unit Completed';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No.")
        {
        }
        key(Key2; "NS_Journal Template Name", "NS_Journal Batch Name", NS_Type, "NS_No.", "NS_Unit of Measure Code", "NS_Work Type Code")
        {
        }
        key(Key3; "NS_Journal Template Name", "NS_Journal Batch Name", "NS_Subcontract No.", "NS_Work Units", "NS_Job Task No.", "NS_Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        LOCKTABLE();
        SubcontractJnlTemplate.GET("NS_Journal Template Name");
        SubcontractJnlBatch.GET("NS_Journal Template Name", "NS_Journal Batch Name");

        ValidateShortcutDimCode(1, "NS_Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "NS_Shortcut Dimension 2 Code");
    end;

    var

        Location: Record Location;
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        GLAcc: Record "G/L Account";
        Job: Record Job;
        SubcontractHeader: Record NS_Subcontract;
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        SubcontractJnlTemplate: Record "NS_SubcontractJournalTemplate";
        SubcontractJnlBatch: Record "NS_Subcontract Journal Batch";
        SubcontractJnlLine: Record "NS_Subcontract Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemVariant: Record "Item Variant";
        GLSetup: Record "General Ledger Setup";
        Customer: Record Customer;
        Vendor: Record Vendor;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UOMMgt: Codeunit "Unit of Measure Management";
        DimMgt: Codeunit DimensionManagement;

        SubcontractLedgEntries: Page "NS_Subcontract Ledger Entries";


        GLSetupRead: Boolean;
        Text001_Txt: Label '%1 cannot be blank.', Comment = '%1 = External Relation Type';
        Text000_Txt: Label 'You cannot change %1 when %2 is %3.', Comment = '%1 = Unit Cost, %2 = Costing Method, %3 = Costing Method';

    local procedure CalcBaseQty(Qty: Decimal): Decimal;
    begin
        TESTFIELD("NS_Qty. per Unit of Measure");
        exit(ROUND(Qty * "NS_Qty. per Unit of Measure", 0.00001));
    end;

    local procedure NS_SelectSubcontractEntry(CurrentFieldNo: Integer);
    begin
        SubcontractLedgEntry.SETCURRENTKEY("NS_Subcontract No.", NS_Positive, "NS_Posting Date");
        SubcontractLedgEntry.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");

        if "NS_Entry Type" = "NS_Entry Type"::Usage then
            SubcontractLedgEntry.SETRANGE(NS_Positive, "NS_Total Cost" < 0)
        else
            SubcontractLedgEntry.SETRANGE(NS_Positive, "NS_Total Cost" > 0);

        SubcontractLedgEntries.NS_SetSubcontractJnlLine(Rec);
        SubcontractLedgEntries.SETRECORD(SubcontractLedgEntry);
        SubcontractLedgEntries.SETTABLEVIEW(SubcontractLedgEntry);
        SubcontractLedgEntries.LOOKUPMODE(true);
        SubcontractLedgEntries.RUNMODAL();
        CLEAR(SubcontractLedgEntries);
    end;

    local procedure NS_SelectItemEntry(CurrentFieldNo: Integer);
    begin
        ItemLedgEntry.SETCURRENTKEY("Item No.", "Variant Code", Open);
        ItemLedgEntry.SETRANGE("Item No.", "NS_No.");
        ItemLedgEntry.SETRANGE(Open, true);
        if NS_Quantity <> 0 then
            ItemLedgEntry.SETRANGE(Positive, NS_Quantity > 0);
        if PAGE.RUNMODAL(PAGE::"Item Ledger Entries", ItemLedgEntry) = ACTION::LookupOK then
            "NS_Location Code" := ItemLedgEntry."Location Code";
    end;

    local procedure NS_CheckItemAvailable();
    begin
        if (CurrFieldNo <> 0) and
           (NS_Type = NS_Type::Item) and (NS_Quantity > 0)
        then begin
            ItemJnlLine."Item No." := "NS_No.";
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
            ItemJnlLine."Location Code" := "NS_Location Code";
            ItemJnlLine."Variant Code" := "NS_Variant Code";
            ItemJnlLine."Bin Code" := "NS_Bin Code";
            ItemJnlLine."Unit of Measure Code" := "NS_Unit of Measure Code";
            ItemJnlLine."Qty. per Unit of Measure" := "NS_Qty. per Unit of Measure";
            ItemJnlLine.Quantity := NS_Quantity;
            ItemCheckAvail.ItemJnlCheckLine(ItemJnlLine);
        end;
    end;

    procedure EmptyLine(): Boolean;
    begin
        exit(("NS_No." = '') and (NS_Quantity = 0));
    end;

    procedure SetUpNewLine(LastJobJnlLine: Record "Job Journal Line");
    begin
        SubcontractJnlTemplate.GET("NS_Journal Template Name");
        SubcontractJnlBatch.GET("NS_Journal Template Name", "NS_Journal Batch Name");
        SubcontractJnlLine.SETRANGE("NS_Journal Template Name", "NS_Journal Template Name");
        SubcontractJnlLine.SETRANGE("NS_Journal Batch Name", "NS_Journal Batch Name");
        if SubcontractJnlLine.FINDFIRST() then begin
            "NS_Posting Date" := LastJobJnlLine."Posting Date";
            "NS_Document Date" := LastJobJnlLine."Posting Date";
            "NS_Document No." := LastJobJnlLine."Document No.";
        end else begin
            "NS_Posting Date" := WORKDATE();
            "NS_Document Date" := WORKDATE();
            if SubcontractJnlBatch."NS_No. Series" <> '' then begin
                CLEAR(NoSeriesMgt);
                "NS_Document No." := NoSeriesMgt.TryGetNextNo(SubcontractJnlBatch."NS_No. Series", "NS_Posting Date");
            end;
        end;
        "NS_Recurring Method" := LastJobJnlLine."Recurring Method";
        "NS_Entry Type" := LastJobJnlLine."Entry Type";
        NS_Type := LastJobJnlLine.Type;
        "NS_Job No." := LastJobJnlLine."Job No.";
        "NS_Source Code" := SubcontractJnlTemplate."NS_Source Code";
        "NS_Reason Code" := SubcontractJnlBatch."NS_Reason Code";
        "NS_Posting No. Series" := SubcontractJnlBatch."NS_Posting No. Series";
    end;

    procedure NS_CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]);
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        _NSDefaultDimSource: List of [Dictionary of [Integer, Code[20]]];   //PRJCTPR-155.JS.1.0 08Sep2023
        _DimMgt: codeunit DimensionManagement; //PRJCTPR-155.JS.1.0 08Sep2023
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "NS_Shortcut Dimension 1 Code" := '';
        "NS_Shortcut Dimension 2 Code" := '';
        //PRJCTPR-155.JS.1.0 08Sep2023 - Start
        if (TableID[1] <> 0) and (No[1] <> '') then begin
            _DimMgt.AddDimSource(_NSDefaultDimSource, TableID[1], No[1]);
            "NS_Dimension Set ID" :=
              //DimMgt.GetDefaultDimID(TableID, No, "NS_Source Code", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code", 0, 0);  
              DimMgt.GetDefaultDimID(_NSDefaultDimSource, "NS_Source Code", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code", 0, 0);
        end;
        if (TableID[2] <> 0) and (No[2] <> '') then begin
            _DimMgt.AddDimSource(_NSDefaultDimSource, TableID[2], No[2]);
            "NS_Dimension Set ID" :=
              DimMgt.GetDefaultDimID(_NSDefaultDimSource, "NS_Source Code", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code", 0, 0);
        end;
        if (TableID[3] <> 0) and (No[3] <> '') then begin
            _DimMgt.AddDimSource(_NSDefaultDimSource, TableID[2], No[2]);
            "NS_Dimension Set ID" :=
              DimMgt.GetDefaultDimID(_NSDefaultDimSource, "NS_Source Code", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code", 0, 0);
        end;
        //PRJCTPR-155.JS.1.0 08Sep2023 - end  
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "NS_Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "NS_Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("NS_Dimension Set ID", ShortcutDimCode);
    end;

    local procedure NS_GetGLSetup();
    begin
        if not GLSetupRead then
            GLSetup.GET();
        GLSetupRead := true;
    end;

    local procedure NS_GetLocation(LocationCode: Code[10]);
    begin
        if LocationCode = '' then
            CLEAR(Location)
        else
            if Location.Code <> LocationCode then
                Location.GET(LocationCode);
    end;

    procedure NS_ShowDimensions();
    begin
        "NS_Dimension Set ID" :=
          DimMgt.EditDimensionSet("NS_Dimension Set ID", STRSUBSTNO('%1 %2 %3', "NS_Journal Template Name", "NS_Journal Batch Name", "NS_Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("NS_Dimension Set ID", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
    end;

    //SMPL Replaced DimensionManagement named reference to ID (symbols bug)
}

