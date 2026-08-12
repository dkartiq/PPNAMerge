table 14021341 "NS_Progress Payment Line"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-889.GK.1.0 13Sep2021 | Create two new fields and fetch these field values.
    //PRJ-1194.NK.1.0 14Mar2022 | Add Condition.

    Caption = 'Progress Payment Line';

    fields
    {
        field(1; "NS_Progress Payment No."; Code[20])
        {
            Caption = 'Progress Payment No.';
            NotBlank = true;
            TableRelation = "NS_Progress Payment Header"."NS_No.";
            DataClassification = CustomerContent;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            NotBlank = true;
            TableRelation = "NS_Progress Payment Header"."NS_Requisition No." WHERE("NS_No." = FIELD("NS_Progress Payment No."));
            DataClassification = CustomerContent;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            TableRelation = "NS_Progress Payment Header"."NS_Version No." WHERE("NS_No." = FIELD("NS_Progress Payment No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."));
            DataClassification = CustomerContent;
        }
        field(4; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "NS_Item No."; Code[5])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(12; "NS_Cost Category"; Code[10])
        {
            Caption = 'Cost Category';
            TableRelation = "NS_Job Cost Category".NS_Code;
            DataClassification = CustomerContent;
        }
        field(13; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(14; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(16; "NS_Task Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            //PRJ-1652.GK.1.0 29Sept2022 start
            ObsoleteState = Pending;
            ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_Task Description New" because of length mismatch with Job Task';
            ObsoleteTag = '20.0.15.41354';
            //PRJ-1652.GK.1.0 29Sept2022 end
        }
        field(20; "NS_Payment Method"; Option)
        {
            Caption = 'Payment Method';
            InitValue = "%";
            OptionCaption = '" ,%,Unit,L/S"';
            OptionMembers = " ","%",Unit,"L/S";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Payment Method" <> xRec."NS_Payment Method" then begin
                    "NS_Base Amount" := 0;
                    "NS_Base Quantity" := 0;
                    "NS_Contract Quantity" := 0;
                    NS_Quantity := 0;
                    NS_Total := 0;
                end;
            end;
        }
        field(21; "NS_Contract Quantity"; Decimal)
        {
            Caption = 'Contract Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Contract Quantity" <> 0 then
                    if "NS_Payment Method" <> "NS_Payment Method"::Unit then
                        ERROR(Text002);
            end;
        }
        field(22; "NS_Base Amount"; Decimal)
        {
            Caption = 'Base Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(23; "NS_Base Quantity"; Decimal)
        {
            Caption = 'Base Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Payment Method" <> "NS_Payment Method"::Unit then begin
                    "NS_Base Quantity" := 0;
                    MESSAGE(Text003);
                end else
                    // >> Upgrade
                    //NS_LineCalculations(Rec);
                    NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(25; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(26; NS_Total; Decimal)
        {
            Caption = 'Total';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                case "NS_Payment Method" of
                    "NS_Payment Method"::"%":
                        NS_Quantity := (NS_Total / "NS_Base Amount") * 100;
                    "NS_Payment Method"::Unit:
                        if ("NS_Base Amount" <> 0) and ("NS_Base Quantity" <> 0) then
                            NS_Quantity := NS_Total / ("NS_Base Amount" / "NS_Base Quantity")
                        else begin
                            NS_Total := 0;
                            MESSAGE(Text004);
                        end;
                    "NS_Payment Method"::"L/S":
                        NS_Quantity := NS_Total;
                end;
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(30; "NS_Work Amount"; Decimal)
        {
            Caption = 'Work Amount';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Work Retention Percent"; Decimal)
        {
            Caption = 'Work Retention Percent';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(33; "NS_Work Retention Amount"; Decimal)
        {
            Caption = 'Work Retention Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(34; "NS_Effective Work Retention"; Decimal)
        {
            Caption = 'Effective Work Retention';
            DataClassification = CustomerContent;
        }
        field(35; "NS_Stored Materials Amount"; Decimal)
        {
            Caption = 'Stored Materials Amount';
            DataClassification = CustomerContent;
            Editable = false; //PRJCTPR-113.NC.1.0 24May2023
            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(36; "NS_Material Retention Percent"; Decimal)
        {
            Caption = 'Material Retention Percent';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(37; "NS_Material Retention Amount"; Decimal)
        {
            Caption = 'Material Retention Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                // >> Upgrade
                //NS_LineCalculations(Rec);
                NS_LineCalculations(Rec, true); // #RG008
                // << Upgrade
            end;
        }
        field(38; "NS_EffectiveMaterialRetention"; Decimal)
        {
            Caption = 'Effective Material Retention';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(41; "NS_Line Amount With Retention"; Decimal)
        {
            Caption = 'Line Amount With Retention';
            DataClassification = CustomerContent;
        }
        field(51; "NS_Payed Work Retention Amt"; Decimal)
        {
            Caption = 'Payed Work Retention Amt';
            DataClassification = CustomerContent;
        }
        field(52; "NS_Payed MaterialRetentionAmt"; Decimal)
        {
            Caption = 'Payed Material Retention Amt';
            DataClassification = CustomerContent;
        }
        field(75; NS_Type; Option)
        {
            Caption = 'Type';
            // >> Upgrade
            // OptionCaption = ' ,Resource,Item,G/L Account';
            // OptionMembers = " ",Resource,Item,"G/L Account";
            OptionCaption = ' ,Resource,Item,G/L Account,Fixed Asset';
            OptionMembers = " ",Resource,Item,"G/L Account","Fixed Asset";
            // << Upgrade
            DataClassification = CustomerContent;
        }
        field(76; "NS_No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "NS_Subcontract Lines"."NS_No.";
            DataClassification = CustomerContent;

            trigger OnLookup();
            var
                SubcontractDetail: Record "NS_Subcontract Lines";
                SubcontractDetails: Page "NS_Subcontract Lines";
            begin
                case NS_Type of
                    NS_Type::Resource:
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::Resource);
                            if PAGE.RUNMODAL(PAGE::"NS_Subcontract Detail List", SubcontractDetail) = ACTION::LookupOK then begin
                                "NS_No." := SubcontractDetail."NS_No.";
                                //"NS_No. Description" := SubcontractDetail.NS_Description;//PRJ-1623.GK.1.0 08Sept2022
                                "NS_No. Description New" := SubcontractDetail.NS_Description; //PRJ-1623.GK.1.0 08Sept2022
                            end;
                        end;
                    NS_Type::Item:
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::Item);
                            if PAGE.RUNMODAL(PAGE::"NS_Subcontract Detail List", SubcontractDetail) = ACTION::LookupOK then begin
                                "NS_No." := SubcontractDetail."NS_No.";
                                //"NS_No. Description" := SubcontractDetail.NS_Description;//PRJ-1623.GK.1.0 08Sept2022
                                "NS_No. Description New" := SubcontractDetail.NS_Description; //PRJ-1623.GK.1.0 08Sept2022
                            end;
                        end;
                    NS_Type::"G/L Account":
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::"G/L Account");
                            if PAGE.RUNMODAL(PAGE::"NS_Subcontract Detail List", SubcontractDetail) = ACTION::LookupOK then begin
                                "NS_No." := SubcontractDetail."NS_No.";
                                //"NS_No. Description" := SubcontractDetail.NS_Description;//PRJ-1623.GK.1.0 08Sept2022
                            end;
                        end;
                    // >> Upgrade
                    // >> 001
                    NS_Type::"Fixed Asset":
                        begin
                            SubcontractDetail.Reset;
                            SubcontractDetail.SetRange("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SetRange(NS_Type, NS_Type::"Fixed Asset");
                            if PAGE.RunModal(PAGE::"NS_Subcontract Detail List", SubcontractDetail) = ACTION::LookupOK then begin
                                "NS_No." := SubcontractDetail."NS_No.";
                                "NS_No. Description New" := SubcontractDetail.NS_Description; //PRJ-1623.GK.1.0 08Sept2022
                            end;
                        end;
                // << 001
                // << Upgrade
                end;
            end;

            trigger OnValidate();
            var
                PrepmtMgt: Codeunit "Prepayment Mgt.";
            begin
                case NS_Type of
                    NS_Type::Resource:
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::Resource);
                            SubcontractDetail.SETRANGE("NS_No.", "NS_No.");
                            if SubcontractDetail.COUNT() = 0 then
                                ERROR(Text005, "NS_No.", FORMAT(NS_Type::Resource));
                        end;
                    NS_Type::Item:
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::Item);
                            SubcontractDetail.SETRANGE("NS_No.", "NS_No.");
                            if SubcontractDetail.COUNT() = 0 then
                                ERROR(Text005, "NS_No.", FORMAT(NS_Type::Item));
                        end;
                    NS_Type::"G/L Account":
                        begin
                            SubcontractDetail.RESET();
                            SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SETRANGE(NS_Type, NS_Type::"G/L Account");
                            SubcontractDetail.SETRANGE("NS_No.", "NS_No.");
                            if SubcontractDetail.COUNT() = 0 then
                                ERROR(Text005, "NS_No.", FORMAT(NS_Type::Item));
                        end;
                    // >> Upgrade
                    // >> 001
                    NS_Type::"Fixed Asset":
                        begin
                            SubcontractDetail.Reset;
                            SubcontractDetail.SetRange("NS_Subcontract No.", "NS_Subcontract No.");
                            SubcontractDetail.SetRange(NS_Type, NS_Type::"Fixed Asset");
                            SubcontractDetail.SetRange("NS_No.", "NS_No.");
                            if SubcontractDetail.Count = 0 then
                                Error(Text005, "NS_No.", Format(NS_Type::"Fixed Asset"));
                        end;
                // << 001
                // << Upgrade
                end;
            end;
        }
        field(77; "NS_No. Description"; Text[50])
        {
            Caption = 'No. Description';
            DataClassification = CustomerContent;
            //PRJ-1623.GK.1.0 08Sept2022 start
            ObsoleteState = Pending;
            ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_No. Description New" because of length mismatch with Puchase Line';
            ObsoleteTag = '20.0.8.41354';
            //PRJ-1623.GK.1.0 08Sept2022 end
        }
        field(107; "NS_Activity Code"; Code[10])
        {
            Caption = 'Activity Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(108; "NS_Process Code"; Code[10])
        {
            Caption = 'Process Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(109; "NS_Operation Code"; Code[10])
        {
            Caption = 'Operation Code';
            Description = 'Not for data entry!';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(200; "NS_Forecast Worksheet Count"; Integer)
        {
            Caption = 'Forecast Worksheet Count';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(201; "NS_Average Percent Complete"; Decimal)
        {
            Caption = 'Average Percent Complete';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(202; "NS_Forecasted Completed Cost"; Decimal)
        {
            Caption = 'Forecasted Completed Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(203; "NS_Job Ledger EntryTotalPrice"; Decimal)
        {
            Caption = 'Job Ledger Entry Total Price';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(204; "NS_Job Ledger Entry Total Cost"; Decimal)
        {
            Caption = 'Job Ledger Entry Total Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(205; "NS_Task Budget"; Decimal)
        {
            Caption = 'Task Budget';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(206; "NS_Utilized Cost"; Decimal)
        {
            Caption = 'Utilized Cost';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        field(207; "NS_Finished Contract Price"; Decimal)
        {
            Caption = 'Finished Contract Price';
            Description = 'Process temporary work field';
            DataClassification = CustomerContent;
        }
        //PRJ-889.GK.1.0 13Sep2021 start
        field(208; "NS_Progress Payment Amount"; Decimal)
        {
            Caption = 'Progress Payment Amount';
            Description = 'Current Progress Payment Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(209; "NS_Posted Payments"; Decimal)
        {
            Caption = 'Posted Payments';
            Description = 'Posted Progress Payment Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-889.GK.1.0 13Sep2021 end
        //PRJ-1106.GK.1.0 29Dec2021 start
        field(210; "NS_PO Line No."; Integer)
        {
            Caption = 'PO Line No.';
            Description = 'Sub Contract PO Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-1106.GK.1.0 29Dec2021 end
        //PRJ-1623.GK.1.0 08Sept2022 start
        field(211; "NS_No. Description New"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        //PRJ-1623.GK.1.0 08Sept2022 end
        //PRJ-1652.GK.1.0 29Sept2022 start
        field(212; "NS_Task Description New"; Text[100])
        {
            Caption = 'Task Description';
            DataClassification = CustomerContent;
        }
        //PRJ-1652.GK.1.0 29Sept2022 end
    }

    keys
    {
        key(Key1; "NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.", "NS_Line No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Payed Work Retention Amt", "NS_Payed MaterialRetentionAmt";
        }
        key(Key2; "NS_Progress Payment No.", "NS_Requisition No.", "NS_Line No.", "NS_Version No.", "NS_Item No.", "NS_Subcontract No.", NS_Type, "NS_No.", "NS_Cost Category", "NS_Job No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Payed Work Retention Amt", "NS_Payed MaterialRetentionAmt";
        }
        key(Key3; "NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.", "NS_Subcontract No.", NS_Type, "NS_No.", "NS_Cost Category", "NS_Job No.", "NS_Job Task No.")
        {
            SumIndexFields = "NS_Work Amount", "NS_Stored Materials Amount", "NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Amount", "NS_Line Amount With Retention", "NS_Payed Work Retention Amt", "NS_Payed MaterialRetentionAmt";
        }
        key(Key4; "NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.", "NS_Item No.", "NS_Subcontract No.", NS_Type, "NS_No.", "NS_Cost Category", "NS_Job No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //RESTORE THIS
        //ProgressPaymentHeader.GET("Progress Payment No.","Requisition No.","Version No.");
        //IF ProgressPaymentHeader.Status >= ProgressPaymentHeader.Status::Invoiced THEN
        //  ERROR(Text001);
    end;

    trigger OnInsert();
    begin
        ProgressPaymentHeader.JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
        if "NS_Item No." = '' then
            "NS_Payment Method" := "NS_Payment Method"::" ";
    end;

    trigger OnModify();
    begin
        ProgressPaymentHeader.JobTaskNoToAPO("NS_Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code");
        ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
        if ProgressPaymentHeader.NS_Status >= ProgressPaymentHeader.NS_Status::Invoiced then
            ERROR(Text001);

        // Recalculate all latter requisitions with the new values
        with ProgressPaymentLine do begin
            GLSetup.GET();
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '>%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET then
                repeat
                    ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressPaymentHeader.NS_Status = ProgressPaymentHeader.NS_Status::Open then begin
                        "NS_Work Amount" := NS_Total - NS_LastTotal(ProgressPaymentLine) + xRec.NS_Total - Rec.NS_Total;
                        "NS_Work Retention Amount" := ROUND("NS_Work Amount" * ("NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
                        "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100),
                                                             GLSetup."Amount Rounding Precision");
                        MODIFY();
                    end
                until NEXT() = 0;
        end;
    end;

    var
        ProgressPaymentHeader: Record "NS_Progress Payment Header";
        ProgressPaymentLine: Record "NS_Progress Payment Line";
        GLSetup: Record "General Ledger Setup";
        Text001: Label 'This requisition has had a payables document generated.\There can be no further changes to this version.\\Please make a new version if changes are needed.';
        Text002: Label 'Contract Quantity is only used when Payment Method is ''Unit''.\\It identified how many total units there are in the contract.';
        SubcontractDetail: Record "NS_Subcontract Lines";
        SubcontractLineList: Page "NS_Subcontract Detail List";
        Text003: Label 'Base Quantity can only be used with Payment Method of Unit.';
        Text004: Label 'There must be values for Base Amount and Base Quantity before a total can be entered for a line with Payment Method of Unit.';
        Text005: Label 'There is no %1 value for %2.  Please enter an existing %2 value.';
    // >> Upgrade
    //procedure NS_LineCalculations(var Rec: Record "NS_Progress Payment Line");
    procedure NS_LineCalculations(var Rec: Record "NS_Progress Payment Line"; IsCalcRetention: Boolean)
    // << Upgrade
    var
        BaseCost: Decimal;
        PurchLine: Record "Purchase Line";
    begin
        GLSetup.GET();

        with Rec do begin
            ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");

            case "NS_Payment Method" of
                "NS_Payment Method"::"%":
                    NS_Total := (NS_Quantity / 100) * "NS_Base Amount";
                "NS_Payment Method"::Unit:
                    begin
                        BaseCost := 0;
                        if "NS_Base Quantity" <> 0 then
                            BaseCost := ROUND("NS_Base Amount" / "NS_Base Quantity", GLSetup."Amount Rounding Precision")
                        else
                            BaseCost := "NS_Base Amount";
                        NS_Total := NS_Quantity * BaseCost;
                    end;
                "NS_Payment Method"::"L/S":
                    NS_Total := NS_Quantity;
                else
                    NS_Total := 0;
            end;

            if ProgressPaymentHeader."NS_Round Amounts" then
                NS_Total := ROUND(NS_Total, 1.0)
            else
                NS_Total := ROUND(NS_Total, GLSetup."Amount Rounding Precision");

            "NS_Work Amount" := NS_Total - NS_LastTotal(Rec);

            if Rec."NS_Work Retention Percent" <> 0 then  //PRJ-1194.NK.1.0 31Mar2022
                Rec."NS_Work Retention Amount" := ROUND(Rec.NS_Total * (Rec."NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision"); //PRJ-1194.NK.1.0 31Mar2022

            //Calculate the effective work retention
            // >> Upgrade
            // #RG008 Start
            // >> 003
            if IsCalcRetention then
                // >> Upgrade
                OnNS_LineCalculations(ProgressPaymentHeader, Rec)
            // SubConMgmt.UpdateProgressPaymentRetention(ProgressPaymentHeader, Rec)
            // << Upgrade
            else
                "NS_Work Retention Amount" := 0;
            // << 003
            "NS_Effective Work Retention" := 0;
            // #RG008 End
            // << Upgrade
            if ProgressPaymentHeader."NS_Work Retention Percent" > 0 then
                "NS_Effective Work Retention" := ROUND(NS_Total * (ProgressPaymentHeader."NS_Work Retention Percent" / 100),
                                                    GLSetup."Amount Rounding Precision")
            else begin
                if "NS_Work Retention Percent" <> 0 then
                    "NS_Work Retention Amount" := ROUND(NS_Total * ("NS_Work Retention Percent" / 100), GLSetup."Amount Rounding Precision");
                "NS_Effective Work Retention" := "NS_Work Retention Amount";
            end;

            if Rec."NS_Work Retention Percent" = 0 then //PRJ-1194.NK.1.0 14Mar2022
                Rec."NS_Work Retention Amount" := 0;  //PRJ-1194.NK.1.0 14Mar2022

            //Calculate the effective material retention
            if ProgressPaymentHeader."NS_Material Retention Percent" > 0 then
                "NS_EffectiveMaterialRetention" := ROUND("NS_Stored Materials Amount" *
                                                        (ProgressPaymentHeader."NS_Material Retention Percent" / 100),
                                                        GLSetup."Amount Rounding Precision")
            else begin
                if "NS_Material Retention Percent" <> 0 then
                    "NS_Material Retention Amount" := ROUND("NS_Stored Materials Amount" * ("NS_Material Retention Percent" / 100),
                    GLSetup."Amount Rounding Precision");
                "NS_EffectiveMaterialRetention" := "NS_Material Retention Amount";
            end;

            "NS_Payed Work Retention Amt" := NS_LastWorkEffectiveRetention(Rec) - "NS_Effective Work Retention";
            "NS_Payed MaterialRetentionAmt" := NS_LastMaterialEffectiveRetention(Rec) - "NS_EffectiveMaterialRetention";

            "NS_Line Amount" := "NS_Work Amount" + "NS_Stored Materials Amount";
            "NS_Line Amount With Retention" := "NS_Line Amount" - "NS_Effective Work Retention" - "NS_EffectiveMaterialRetention";
            //PRJ-889.GK.1.0 13Sep2021 start
            "NS_Progress Payment Amount" := 0;
            "NS_Posted Payments" := 0;
            if PurchLine.GET(PurchLine."Document Type"::Order, ProgressPaymentHeader."NS_Purchase Order No.", "NS_Line No.") then
                "NS_Posted Payments" := PurchLine."Line Amount" - PurchLine."Outstanding Amount (LCY)";
            //Rec."NS_Progress Payment Amount" := (((Rec."NS_Base Amount" * Rec."NS_Base Quantity") * Rec.NS_Quantity) / 100) - Rec."NS_Posted Payments"; //PRJ-1300.GK.1.0 28Apr2022 |Comment
            //Rec."NS_Progress Payment Amount" := (((Rec."NS_Base Amount" * Rec."NS_Base Quantity") * Rec.NS_Quantity) / 100) - Rec."NS_Posted Payments" + "NS_Stored Materials Amount";//PRJ-1300.GK.1.0 28Apr2022|Added //PRJCTPR-113.NC.1.0 17May2023 Comment
            Rec."NS_Progress Payment Amount" := "NS_Work Amount" + "NS_Stored Materials Amount" - NS_GetLastStoredMaterialsAmt(Rec); //PRJCTPR-113.NC.1.0 17May2023 
                                                                                                                                     //PRJ-889.GK.1.0 13Sep2021 end
                                                                                                                                     //PRJCTPR-318.JS.1.0 15FEB2024 - Start
            if (ProgressPaymentHeader."NS_Retention Reduction Invoice" = true) and
                (ProgressPaymentHeader."NS_Work Retention Percent" + ProgressPaymentHeader."NS_Material Retention Percent" = 0) then begin
                Rec."NS_Work Retention Amount" := 0;
                Rec."NS_Work Retention Percent" := 0;
            end;
            //PRJCTPR-318.JS.1.0 15FEB2024 - end        
            MODIFY();
        end;
    end;

    procedure NS_LastBase(Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentHeader_Loc: Record "NS_Progress Payment Header";
        JobsSetup: Record "Jobs Setup";
        NS_LastBaseAmount: Decimal;
    begin
        //Returns the last "Base Amount" for a line on a job
        //  If this is the first requisition for the job then skip this routine

        if "NS_Requisition No." > 1 then begin
            NS_LastBaseAmount := 0;

            with ProgressPaymentLine do begin
                RESET();
                SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
                SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
                SETRANGE("NS_Line No.", Rec."NS_Line No.");
                if FINDSET() then
                    repeat
                        ProgressPaymentHeader_Loc.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                        if ProgressPaymentHeader_Loc.NS_Status <> ProgressPaymentHeader_Loc.NS_Status::Void then
                            if "NS_Payment Method" = "NS_Payment Method"::Unit then
                                NS_LastBaseAmount := ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                NS_LastBaseAmount := "NS_Base Amount";
                    until NEXT() = 0
                else begin
                    SETFILTER("NS_Requisition No.", '%1', Rec."NS_Requisition No.");
                    if FINDSET() then
                        repeat
                            if "NS_Payment Method" = "NS_Payment Method"::Unit then
                                NS_LastBaseAmount := ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                NS_LastBaseAmount := "NS_Base Amount";
                        until NEXT() = 0;
                end;
            end;
        end else
            if Rec."NS_Payment Method" = Rec."NS_Payment Method"::Unit then
                NS_LastBaseAmount := ROUND(Rec."NS_Base Amount" * Rec."NS_Contract Quantity", 0.01)
            else
                NS_LastBaseAmount := Rec."NS_Base Amount";

        exit(NS_LastBaseAmount);
    end;

    procedure NS_LastTotal(var Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentHeader_Loc: Record "NS_Progress Payment Header";
        NS_LastTotalAmount: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastTotalAmount := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    if ProgressPaymentHeader_Loc.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.") then
                        if ProgressPaymentHeader_Loc.NS_Status <> ProgressPaymentHeader_Loc.NS_Status::Void then
                            NS_LastTotalAmount := NS_Total;
                until NEXT() = 0;
        end;

        exit(NS_LastTotalAmount);
    end;

    //PRJCTPR-113.NC.1.0 17May2023 Start
    procedure NS_GetLastStoredMaterialsAmt(var Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentHeader_Loc: Record "NS_Progress Payment Header";
        NS_StoredMaterialAmt: Decimal;
    begin
        NS_StoredMaterialAmt := 0;
        ProgressPaymentLine.RESET();
        ProgressPaymentLine.SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
        ProgressPaymentLine.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressPaymentLine.SETRANGE("NS_Line No.", Rec."NS_Line No.");
        if ProgressPaymentLine.FINDSET() then
            repeat
                if ProgressPaymentHeader_Loc.GET(ProgressPaymentLine."NS_Progress Payment No.", ProgressPaymentLine."NS_Requisition No.", ProgressPaymentLine."NS_Version No.") then
                    if ProgressPaymentHeader_Loc.NS_Status <> ProgressPaymentHeader_Loc.NS_Status::Void then
                        NS_StoredMaterialAmt := ProgressPaymentLine."NS_Stored Materials Amount";
            until ProgressPaymentLine.NEXT() = 0;
        exit(NS_StoredMaterialAmt);
    end;
    //PRJCTPR-113.NC.1.0 17May2023 End

    procedure NS_LastWorkEffectiveRetention(var Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        NS_LastWorkEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        NS_LastWorkEffectiveRetentionAmt := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressPaymentHeader.NS_Status <> ProgressPaymentHeader.NS_Status::Void then
                        NS_LastWorkEffectiveRetentionAmt := "NS_Effective Work Retention";
                until NEXT() = 0;
        end;

        exit(NS_LastWorkEffectiveRetentionAmt);
    end;

    procedure NS_LastMaterialEffectiveRetention(var Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        LastMatEffectiveRetentionAmt: Decimal;
    begin
        //Returns the last total for a line on a job
        LastMatEffectiveRetentionAmt := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDSET() then
                repeat
                    ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressPaymentHeader.NS_Status <> ProgressPaymentHeader.NS_Status::Void then
                        LastMatEffectiveRetentionAmt := "NS_EffectiveMaterialRetention";
                until NEXT() = 0;
        end;

        exit(LastMatEffectiveRetentionAmt);
    end;

    procedure LastProgressPaylStoredMatLine(Rec: Record "NS_Progress Payment Line"): Decimal;
    var
        ProgressPaymentLine_Loc: Record "NS_Progress Payment Line";
        LastStoredMaterial: Decimal;
    begin
        //Returns the stored material amount on the previous progress payment
        LastStoredMaterial := 0;
        with ProgressPaymentLine_Loc do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_Progress Payment No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER("NS_Version No.", '<%1', Rec."NS_Version No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastStoredMaterial := "NS_Stored Materials Amount";
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_TotalWorkPreviousPayment(Rec: Record "NS_Progress Payment Header"): Decimal;
    var
        PrevPayment: Decimal;
    begin
        //Returns the Work Previous Payments for an entire job
        PrevPayment := 0;
        with ProgressPaymentLine do begin
            RESET();
            SETRANGE("NS_Progress Payment No.", Rec."NS_No.");
            if Rec."NS_Requisition No." > 0 then
                SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            if FINDSET() then
                repeat
                    ProgressPaymentHeader.GET("NS_Progress Payment No.", "NS_Requisition No.", "NS_Version No.");
                    if ProgressPaymentHeader.NS_Status <> ProgressPaymentHeader.NS_Status::Void then
                        PrevPayment := PrevPayment + "NS_Work Amount";
                until NEXT() = 0;
        end;

        exit(PrevPayment);
    end;

    //SMPL Replaced TextConst with labels
}

