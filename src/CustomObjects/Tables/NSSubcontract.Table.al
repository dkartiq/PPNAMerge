table 14021300 NS_Subcontract
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-257 VT1.0 06-05-20
    //PRJ-273 VT1.0 22-05-20
    //PRJ-274 VT1.0 22-05-20 Code Added
    //PRJ.302.MS.1.0 code comment due to unit cost comes from item card
    //PRJ-301-MS.1.0  change length from 50 to 100
    //PPAL-74.SK.1.0 - 13AUG2020 - Added VALIDATE on "Direct Unit Cost" instead of simple assignment.
    //PRJ-383.N.S.1.0 16Sep2020 Add condition onDelete trigger
    //PRJ-383.AS.1.0 12OCT2020 Added code to flow Person responsible and Person responsible name, Added code to throw correct error while deleting subcontract of status order
    //PRJ-533.AS.1.0 Added code & field
    //PRJ-676.RS.1.0 6June2021 | Custom Report Creation for V17
    //PRJ-715.RS.1.0 28May2021 | Dimensions not carrying over from Subcontract Card to PO
    //PRJ-676.RS.1.0 6June2021 | Custom Report Creation for V17
    //PRJ-751.RS.1.0 14June21 | Cloned of TMF: 10: Product Change: Change the names associated with the Manager Job Status on Job Card (88)//PRJ-751.AS.1.0 06July2021 Changes roll back , as it was wrong
    //PRJ-817.JS.1.0�04Aug2021 | Assign value from subcondetails to purchase line for work unit and work unit of measure
    //PRJ-826.GK.1.0 17Aug2021 - Write code to update the status date
    //PRJ-889.GK.1.0 13Sep2021 | Update Progress Payment Disable field
    //PRJ-913.JS.1.0 16Sep2021 | code added
    //PRJ-906.GK.1.0 05Oct2021 | Code added

    Caption = 'Subcontract';
    DataCaptionFields = "NS_No.", NS_Description;
    //DrillDownPageID = "NS_Subcontract List(Formatted)"; //PRJ-676.RS.1.0 6June2021
    //LookupPageID = "NS_Subcontract List(Formatted)";//PRJ-676.RS.1.0 6June2021
    DrillDownPageID = "NS_Subcontract List";
    LookupPageID = "NS_Subcontract List";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No." <> xRec."NS_No." then begin
                    JobsSetup.GET();
                    NoSeriesMgt.TestManual(JobsSetup."NS_Subcontract Nos.");
                    "NS_No. Series" := '';
                end;
            end;
        }
        field(2; "NS_Search Description"; Code[50])
        {
            Caption = 'Search Description';
            DataClassification = CustomerContent;
        }
        field(3; NS_Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Search Description" = UPPERCASE(xRec.NS_Description)) or ("NS_Search Description" = '') then
                    "NS_Search Description" := NS_Description;
            end;
        }
        field(4; "NS_Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
            DataClassification = CustomerContent;
        }
        field(6; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job."No." WHERE(Status = FILTER(< Completed));
            DataClassification = CustomerContent;
            //PRJ-383.AS.1.0 12OCT2020  - start
            trigger OnValidate()
            var
                Job_L: Record Job;
            begin
                if Job_L.get("NS_Job No.") then
                    "NS_Person Responsible" := Job_L."Person Responsible";
            end;
            //PRJ-383.AS.1.0 12OCT2020  - end
        }
        field(12; "NS_Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(13; "NS_Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(14; "NS_Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(19; NS_Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if NS_Status = xRec.NS_Status then
                    exit;

                // Subcontract Budget Entries
                with SubcontractPlanningLine do begin
                    SETCURRENTKEY("Job No.");
                    SETRANGE("Job No.", "No.");
                    if FINDSET() then
                        repeat
                            Status := Rec.NS_Status;
                            MODIFY();
                        until NEXT = 0;
                end;

                if (NS_Status = NS_Status::Completed) then
                    "NS_Completion Date" := WORKDATE;
                MODIFY();
            end;
        }
        field(20; "NS_Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            TableRelation = Resource WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;
        }
        field(21; "NS_Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(1, "NS_Global Dimension 1 Code");
                MODIFY();
            end;
        }
        field(22; "NS_Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_ValidateShortcutDimCode(2, "NS_Global Dimension 2 Code");
                MODIFY();
            end;
        }
        field(24; NS_Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Posting,All';
            OptionMembers = " ",Posting,All;
            DataClassification = CustomerContent;
        }
        field(29; "NS_Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(30; NS_Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(NS_Subcontract),
                                                      "No." = FIELD("NS_No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "NS_Shortcut Dimension 1 Code"; Code[20])
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
        field(32; "NS_Shortcut Dimension 2 Code"; Code[20])
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
        field(41; "NS_Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            DataClassification = CustomerContent;
        }
        field(49; "NS_Scheduled Res. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("NS_No."),
                                                                           "Schedule Line" = CONST(true),
                                                                           Type = CONST(Resource),
                                                                           "No." = FIELD("NS_Resource Filter"),
                                                                           "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Scheduled Res. Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "NS_Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(51; "NS_Posting Date Filter"; Date)
        {
            Caption = 'Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(55; "NS_Resource Gr. Filter"; Code[20])
        {
            Caption = 'Resource Gr. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Resource Group";
        }
        field(56; "NS_Scheduled Res. Gr. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("NS_No."),
                                                                           "Schedule Line" = CONST(true),
                                                                           Type = CONST(Resource),
                                                                           "Resource Group No." = FIELD("NS_Resource Gr. Filter"),
                                                                           "Planning Date" = FIELD("NS_Planning Date Filter")));
            Caption = 'Scheduled Res. Gr. Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; NS_Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
            DataClassification = CustomerContent;
        }
        field(58; "NS_Buy-from Name"; Text[100])//PRJ-301-MS.1.0 
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "NS_Buy-from Address"; Text[100])	//PRJ-301-MS.1.0 
        {
            CalcFormula = Lookup(Vendor.Address WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "NS_Buy-from Address 2"; Text[50])
        {
            CalcFormula = Lookup(Vendor."Address 2" WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "NS_Buy-from City"; Text[30])
        {
            CalcFormula = Lookup(Vendor.City WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; NS_County; Text[30])
        {
            CalcFormula = Lookup(Vendor.County WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'State';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(64; "NS_Buy-from Post Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."Post Code" WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Zip Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Post Code";
        }
        field(66; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(67; "NS_Buy-fromCountry/RegionCode"; Code[10])
        {
            CalcFormula = Lookup(Vendor."Country/Region Code" WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Country/Region Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(68; "NS_Buy-from Name 2"; Text[50])
        {
            CalcFormula = Lookup(Vendor."Name 2" WHERE("No." = FIELD("NS_Buy-from Vendor No.")));
            Caption = 'Buy-from Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                NS_ShowDocDim();
            end;
        }
        field(1001; "NS_Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Currency Code" <> xRec."NS_Currency Code" then
                    if not NS_SubcontractLedgEntryExist then
                        NS_CurrencyUpdateDetailLines
                    else
                        ERROR(Text000, FIELDCAPTION("NS_Currency Code"), TABLECAPTION);

                if "NS_Currency Code" <> '' then
                    "NS_Invoice Currency Code" := '';
            end;
        }
        field(1002; "NS_Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            DataClassification = CustomerContent;

            trigger OnLookup();
            begin
                if ("NS_Buy-from Vendor No." <> '') and Cont.GET("NS_Buy-from Contact No.") then
                    Cont.SETRANGE("Company No.", Cont."Company No.")
                else
                    if Vend.GET("NS_Buy-from Vendor No.") then begin
                        ContBusinessRelation.RESET();
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "NS_Buy-from Vendor No.");
                        if ContBusinessRelation.FINDFIRST() then
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.");
                    end else
                        Cont.SETFILTER("Company No.", '<>''''');

                if "NS_Buy-from Contact No." <> '' then
                    if Cont.GET("NS_Buy-from Contact No.") then;
                if PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    VALIDATE("NS_Buy-from Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate();
            begin
                if NS_Blocked >= NS_Blocked::Posting then
                    ERROR(Text000, FIELDCAPTION("NS_Buy-from Contact No."), TABLECAPTION);

                if ("NS_Buy-from Contact No." <> xRec."NS_Buy-from Contact No.") and
                   (xRec."NS_Buy-from Contact No." <> '')
                then begin
                    if ("NS_Buy-from Contact No." = '') and ("NS_Buy-from Vendor No." = '') then begin
                        INIT();
                        "NS_No. Series" := xRec."NS_No. Series";
                        VALIDATE(NS_Description, xRec.NS_Description);
                    end;
                end;

                if ("NS_Buy-from Vendor No." <> '') and ("NS_Buy-from Contact No." <> '') then begin
                    Cont.GET("NS_Buy-from Contact No.");
                    ContBusinessRelation.RESET();
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.", "NS_Buy-from Vendor No.");
                    if ContBusinessRelation.FINDFIRST() then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            ERROR(Text005, Cont."No.", Cont.Name, "NS_Buy-from Vendor No.");
                end;
                NS_UpdateBuyFromVend("NS_Buy-from Contact No.");
            end;
        }
        field(1003; "NS_Buy-from Contact"; Text[100])//PRJ-301-MS.1.0 
        {
            Caption = 'Buy-from Contact';
            DataClassification = CustomerContent;
        }
        field(1004; "NS_Planning Date Filter"; Date)
        {
            Caption = 'Planning Date Filter';
            FieldClass = FlowFilter;
        }
        field(1011; "NS_Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(1012; "NS_Exch. Calculation (Cost)"; Option)
        {
            Caption = 'Exch. Calculation (Cost)';
            OptionCaption = 'Fixed FCY,Fixed $';
            OptionMembers = "Fixed LCY","Fixed FCY";
            DataClassification = CustomerContent;
        }
        field(1013; "NS_Exch. Calculation (Price)"; Option)
        {
            Caption = 'Exch. Calculation (Price)';
            OptionCaption = 'Fixed FCY,Fixed $';
            OptionMembers = "Fixed FCY","Fixed LCY";
            DataClassification = CustomerContent;
        }
        field(1014; "NS_AllowSchedule/ContractLines"; Boolean)
        {
            Caption = 'Allow Schedule/Contract Lines';
            DataClassification = CustomerContent;
        }
        field(1015; NS_Complete; Boolean)
        {
            Caption = 'Complete';
            DataClassification = CustomerContent;
        }
        field(1019; "NS_Recog. Costs Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job WIP Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("NS_No."),
                                                                         Type = FILTER("Recognized Costs")));
            Caption = 'Recog. Costs Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1020; "NS_Recog. Costs G/L Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("NS_No."),
                                                                            Reversed = CONST(false),
                                                                            Type = FILTER("Recognized Costs")));
            Caption = 'Recog. Costs G/L Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1024; "NS_Next Invoice Date"; Date)
        {
            CalcFormula = Min("Job Planning Line"."Planning Date" WHERE("Job No." = FIELD("NS_No."),
                                                                         "Contract Line" = CONST(true),
                                                                         "Qty. Invoiced" = CONST(0)));
            Caption = 'Next Invoice Date';
            FieldClass = FlowField;
        }
        field(14021100; "NS_Subcontract Address 1"; Text[50])
        {
            Caption = 'Subcontract Address 1';
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Subcontract Address 2"; Text[50])
        {
            Caption = 'Subcontract Address 2';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Subcontract City"; Text[50])
        {
            Caption = 'Subcontract City';
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Subcontract County"; Text[30])
        {
            Caption = 'Job State';
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Subcontract Post Code"; Code[20])
        {
            Caption = 'Job Zip Code';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_SubcontractCountry/RegnCode"; Code[10])
        {
            Caption = 'Job Country/Region Code';
            Editable = true;
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Subcontract Contact"; Text[30])
        {
            Caption = 'Subcontract Contact';
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Subcontract Phone"; Text[30])
        {
            Caption = 'Subcontract Phone';
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Sub-LeveltoSubcontractNo."; Code[20])
        {
            Caption = 'Sub-Level to Subcontract No.';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                SubcontractNew: Record NS_Subcontract;
                SubcontractHeaderHold: Record NS_Subcontract;
            begin
                //PRJ-589.AM Start
                if "NS_No." <> '' then
                    if "NS_Sub-LeveltoSubcontractNo." = "NS_No." then
                        ERROR(Text14021107, FIELDCAPTION("NS_Sub-LeveltoSubcontractNo."), FIELDCAPTION("NS_No."));
                //PRJ-589.AM End
                if (xRec."NS_Sub-LeveltoSubcontractNo." <> Rec."NS_Sub-LeveltoSubcontractNo.") and
                   ("NS_Sub-LeveltoSubcontractNo." > '') then
                    if CONFIRM(Text011 + "NS_Sub-LeveltoSubcontractNo.") then begin
                        SubcontractNew.GET("NS_Sub-LeveltoSubcontractNo.");
                        "NS_Search Description" := SubcontractNew."NS_Search Description";
                        NS_Description := SubcontractNew.NS_Description;
                        "NS_Description 2" := SubcontractNew."NS_Description 2";
                        "NS_Buy-from Vendor No." := SubcontractNew."NS_Buy-from Vendor No.";
                        VALIDATE("NS_Buy-from Vendor No.");
                        "NS_Creation Date" := TODAY;
                        "NS_Starting Date" := 0D;
                        "NS_Ending Date" := 0D;
                        NS_Status := NS_Status::Planning;
                        "NS_Person Responsible" := SubcontractNew."NS_Person Responsible";
                        VALIDATE("NS_Global Dimension 1 Code", SubcontractNew."NS_Global Dimension 1 Code");
                        VALIDATE("NS_Global Dimension 2 Code", SubcontractNew."NS_Global Dimension 2 Code");
                        NS_Blocked := NS_Blocked::" ";
                        "NS_Language Code" := SubcontractNew."NS_Language Code";
                        "NS_Buy-from Name" := SubcontractNew."NS_Buy-from Name";
                        "NS_Buy-from Address" := SubcontractNew."NS_Buy-from Address";
                        "NS_Buy-from Address 2" := SubcontractNew."NS_Buy-from Address 2";
                        "NS_Buy-from City" := SubcontractNew."NS_Buy-from City";
                        NS_County := SubcontractNew.NS_County;
                        "NS_Buy-from Post Code" := SubcontractNew."NS_Buy-from Post Code";
                        "NS_No. Series" := SubcontractNew."NS_No. Series";
                        "NS_Buy-fromCountry/RegionCode" := SubcontractNew."NS_Buy-fromCountry/RegionCode";
                        "NS_Currency Code" := SubcontractNew."NS_Currency Code";
                        "NS_Buy-from Contact No." := SubcontractNew."NS_Buy-from Contact No.";
                        "NS_Buy-from Contact" := SubcontractNew."NS_Buy-from Contact";
                        "NS_Invoice Currency Code" := SubcontractNew."NS_Invoice Currency Code";
                        "NS_Exch. Calculation (Cost)" := SubcontractNew."NS_Exch. Calculation (Cost)";
                        "NS_Exch. Calculation (Price)" := SubcontractNew."NS_Exch. Calculation (Price)";
                        "NS_AllowSchedule/ContractLines" := SubcontractNew."NS_AllowSchedule/ContractLines";
                        "NS_Subcontract Status Date" := 0D;
                        "NS_Estimated Start Date" := 0D;
                        "NS_Estimated Completion Date" := 0D;
                        "NS_Completion Date" := 0D;
                    end;

                if xRec."NS_Sub-LeveltoSubcontractNo." <> Rec."NS_Sub-LeveltoSubcontractNo." then begin
                    SubcontractLinks.NS_DeleteSubcontractLinks("NS_No.");
                    SubcontractLinks.NS_CreateSubcontractLinks("NS_No.", "NS_Sub-LeveltoSubcontractNo.");
                    COMMIT();
                end;
            end;
        }
        field(14021111; "NS_Temp LinkedParentSubcontNo."; Code[20])
        {
            Caption = 'Temp Linked Parent Subcont No.';
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Last SubcontForSubcontList"; Boolean)
        {
            Caption = 'Last Subcont For Subcont List';
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Purchase Document Type"; Option)
        {
            Caption = 'Purchase Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
            DataClassification = CustomerContent;
        }
        field(14021116; "NS_Purchase Document No."; Code[20])
        {
            Caption = 'Purchase Document No.';
            DataClassification = CustomerContent;
        }
        field(14021122; "NS_Manager Subcontract Status"; Option)
        {
            BlankZero = true;
            Caption = 'Manager Subcontract Status';
            //PRJ-751.AS.1.0 06July2021 Changes Roll back as it was wrong . All commented done by RS- start
            //OptionCaption = ',Estimating,Quoting,Submitted,Verbal App,Approved,Running,Hold,Completed,Billed,Paid,Closed';//PRJ-751.RS.1.0 14June21 Sequence Changed
            //OptionMembers = ,Estimating,Quoting,Submitted,"Verbal App",Approved,Running,Hold,Completed,Billed,Paid,Closed;//PRJ-751.RS.1.0 14June21 Sequence Changed
            //PRJ-751.AS.1.0 06July2021 Changes Roll back as it was wrong . All commented done by RS- end
            OptionCaption = ',Estimating,Quoting,Verbal App,Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed';//PRJ-751.AS.1.0 06July2021 Previous chages done again
            OptionMembers = ,Estimating,Quoting,"Verbal App",Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed;//PRJ-751.AS.1.0 06July2021 Previous chages done again
            DataClassification = CustomerContent;
            //PRJ-826.GK.1.0 17Aug2021 start
            trigger OnValidate()
            begin
                "NS_Subcontract Status Date" := WorkDate();
            end;
            //PRJ-826.GK.1.0 17Aug2021 end
        }
        field(14021123; "NS_Subcontract Status Date"; Date)
        {
            Caption = 'Subcontract Status Date';
            DataClassification = CustomerContent;
            Editable = false; //PRJ-826.GK.1.0 17Aug2021
        }
        field(14021125; "NS_Estimated Start Date"; Date)
        {
            Caption = 'Estimated Start Date';
            DataClassification = CustomerContent;
        }
        field(14021126; "NS_Estimated Completion Date"; Date)
        {
            Caption = 'Estimated Completion Date';
            DataClassification = CustomerContent;
        }
        field(14021127; "NS_Completion Date"; Date)
        {
            Caption = 'Completion Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_DefaultSubcontractRetention"; Decimal)
        {
            Caption = 'Default Job Retention';
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Retention Percent"; Decimal)
        {
            Caption = 'Retention Percent';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
            DataClassification = CustomerContent;
        }
        field(14021154; "NS_Subcontract Cost Posting"; Option)
        {
            Caption = 'Subcontract Cost Posting';
            InitValue = Earned;
            OptionCaption = 'None,Earned';
            OptionMembers = "None",Earned;
            DataClassification = CustomerContent;
        }
        field(14021155; "NS_Progress Payment No."; Code[20])
        {
            Caption = 'Progress Payment No.';
            DataClassification = CustomerContent;
        }
        field(14021156; "NS_Progress Payment Sub-Level"; Boolean)
        {
            Caption = 'Progress Payment Sub-Level';
            DataClassification = CustomerContent;
        }
        field(14021160; "NS_Vendor Job No."; Text[30])
        {
            Caption = 'Vendor Job No.';
            DataClassification = CustomerContent;
        }
        field(14021162; "NS_Contract No."; Text[30])
        {
            Caption = 'Contract No.';
            DataClassification = CustomerContent;
        }
        field(14021163; "NS_Contract Date"; Date)
        {
            Caption = 'Contract Date';
            DataClassification = CustomerContent;
        }
        field(14021164; "NS_Contract For"; Text[80])
        {
            Caption = 'Contract For';
            DataClassification = CustomerContent;
        }
        field(14021165; "NS_Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = ' ,Contract Fixed,Contract Not To Exceed,Time and Material';
            OptionMembers = " ","Contract Fixed","Contract Not To Exceed","Time and Material";
            DataClassification = CustomerContent;
        }
        field(14021166; "NS_Contract Purchase Price"; Decimal)
        {
            Caption = 'Contract Purchase Price';
            DataClassification = CustomerContent;
        }
        field(14021250; "NS_Cost Category Filter"; Code[10])
        {
            Caption = 'Cost Category Filter';
            Description = 'Flow Filters';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Cost Category";
        }
        field(14021251; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Revenue Category";
        }
        field(14021252; "NS_Job Task No. Filter"; Code[35])
        {
            Caption = 'Job Task No. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Job Task";
        }
        field(14021255; "NS_Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14021256; "NS_Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14021257; "NS_Entry Type Filter"; Option)
        {
            Caption = 'Entry Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Usage,Purchase,Payment';
            OptionMembers = Usage,Purchase,Payment;
        }
        field(14021258; "NS_Adjustment Filter"; Code[10])
        {
            Caption = 'Adjustment Filter';
            FieldClass = FlowFilter;
        }
        field(14021259; "NS_Budget Type Filter"; Option)
        {
            Caption = 'Budget Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,Account (G/L),Group (Resource),Contract';
            OptionMembers = Resource,Item,"Account (G/L)","Group (Resource)",Contract;
        }
        field(14021261; "NS_Type Filter"; Option)
        {
            Caption = 'Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,G/L Account,Ledger';
            OptionMembers = Resource,Item,"G/L Account",Ledger;
        }
        field(14021262; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(14021265; "NS_Activity Filter"; Code[10])
        {
            Caption = 'Activity Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Activity";
        }
        field(14021266; "NS_Process Filter"; Code[10])
        {
            Caption = 'Process Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Process";
        }
        field(14021267; "NS_Operation Filter"; Code[10])
        {
            Caption = 'Operation Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Operation";
        }
        field(14021300; "NS_Budgeted Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Subcontract Lines"."NS_Total Cost" WHERE("NS_Subcontract No." = FIELD("NS_No."),
                                                                      "NS_Job Cost Category" = FIELD("NS_Cost Category Filter")));
            Caption = 'Budgeted Cost ($)';
            Description = 'Flow Fields';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021301; "NS_Subcon Class"; Option)
        {
            Caption = 'Subcontract Class';
            Description = '//PRJ-533.AS.1.0';
            OptionCaption = ' ,Master Subcontract,Change Order';
            OptionMembers = " ","Master Job","Change Order";
            DataClassification = CustomerContent;
        }
        field(14021302; "NS_Budgeted Cost Quantity"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Subcontract Lines"."NS_Quantity (Base)" WHERE("NS_Subcontract No." = FIELD("NS_No.")));
            Caption = 'Budgeted Cost Quantity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021310; "NS_Usage (Cost) (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Subcontract Ledger Entry"."NS_Total Cost (LCY)" WHERE("NS_Subcontract No." = FIELD("NS_No."),
                                                                                   "NS_Entry Type" = CONST(Usage)));
            Caption = 'Usage (Cost) ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021330; "NS_Invoiced Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Subcontract Ledger Entry"."NS_Total Cost (LCY)" WHERE("NS_Subcontract No." = FIELD("NS_No."),
                                                                                   "NS_Entry Type" = CONST(Purchase),
                                                                                   NS_Type = FILTER(<> Ledger)));
            Caption = 'Invoiced Cost ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021332; "NS_SubcontractUsageCost(LCY)"; Decimal)
        {
            CalcFormula = Sum("NS_Subcontract Ledger Entry"."NS_Total Cost (LCY)" WHERE("NS_Subcontract No." = FIELD("NS_No."),
                                                                                   "NS_Job Cost Category" = FIELD("NS_Cost Category Filter")));
            Caption = 'Subcontract Usage Cost (LCY)';
            FieldClass = FlowField;
        }
        field(14021333; "NS_Retention Ledger Filter"; Code[20])
        {
            Caption = 'Retention Ledger Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
    }

    keys
    {
        key(Key1; "NS_No.")
        {
        }
        key(Key2; "NS_Search Description")
        {
        }
        key(Key3; "NS_Buy-from Vendor No.")
        {
        }
        key(Key4; "NS_Sub-LeveltoSubcontractNo.", "NS_Buy-from Vendor No.")
        {
        }
        key(Key5; "NS_Last SubcontForSubcontList", "NS_No.")
        {
        }
    }

    fieldgroups
    {
        //PRJ-257 VT1.0 06-05-20
        fieldgroup(DropDown; "NS_No.", NS_Description, "NS_Job No.", "NS_Buy-from Vendor No.", "NS_Vendor Job No.", NS_Status, "NS_Sub-LeveltoSubcontractNo.")
        { }
    }

    trigger OnDelete();
    var
        SubcontractTest: Record NS_Subcontract;
    begin
        if NS_Status = NS_Status::Order then
            // ERROR(Text000);//PRJ-383.AS.1.0 12OCT2020 Commented old error
            Error('You cannot delete Subcontract with status = order');//PRJ-383.AS.1.0 12OCT2020 Added code

        SubcontractTest.RESET();
        SubcontractTest.SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
        SubcontractTest.SETRANGE("NS_Sub-LeveltoSubcontractNo.", "NS_No.");
        if SubcontractTest.FINDFIRST() then
            ERROR(Text010, SubcontractTest."NS_No.");

        NS_MoveSubcontractEntries(Rec);

        SubcontractTask.SETRANGE("Job No.", "NS_No.");
        SubcontractTask.DELETEALL();

        SubcontractPlanningLine.SETCURRENTKEY("NS_Subcontract No.");
        SubcontractPlanningLine.SETRANGE("NS_Subcontract No.", "NS_No.");
        //PRJ-383.N.S.1.0 16Sep2020 Start
        if SubcontractPlanningLine.FindSet then
            repeat
                SubcontractPlanningLine."NS_Subcontract Line No." := 0;
                SubcontractPlanningLine."NS_Subcontract No." := '';
                SubcontractPlanningLine.Modify();
            until SubcontractPlanningLine.Next = 0;
        //PRJ-383.N.S.1.0 16Sep2020 End
        //SubcontractPlanningLine.DELETEALL();	  //PRJ-383.N.S.1.0 16Sep2020 comment

        SubcontractLinks.RESET();
        SubcontractLinks.SETRANGE("NS_Subcontract No.", "NS_No.");
        SubcontractLinks.DELETEALL();

        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::NS_Quote);
        CommentLine.SETRANGE("No.", "NS_No.");
        CommentLine.DELETEALL();

        DimMgt.DeleteDefaultDim(DATABASE::NS_Subcontract, "NS_No.");

        SubcontractLinks.NS_DeleteSubcontractLinks("NS_No.");
        SubcontractLine.RESET();
        SubcontractLine.SETRANGE("NS_Subcontract No.", "NS_No.");
        SubcontractLine.DELETEALL();
    end;

    trigger OnInsert();
    var
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        if "NS_No." = '' then begin
            JobsSetup.GET();
            NoSeriesMgt.InitSeries(JobsSetup."NS_Subcontract Nos.", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;
        "NS_Subcon Class" := "NS_Subcon Class"::"Master Job";//PRJ-533
        NS_SetDimensions("NS_No.", "NS_Job No.");
        SubcontractLinks.NS_CreateSubcontractLinks("NS_No.", "NS_Sub-LeveltoSubcontractNo.");
    end;

    trigger OnModify();
    begin
        "NS_Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "NS_Last Date Modified" := TODAY;
    end;

    var
        JobsSetup: Record "Jobs Setup";
        Subcontract: Record NS_Subcontract;
        SubcontractLine: Record "NS_Subcontract Lines";
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        SubcontractPlanningLine: Record "Job Planning Line";
        SubcontractTask: Record "Job Task";
        CommentLine: Record "Comment Line";
        CostCategory: Record "NS_Job Cost Category";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SubcontractLinks: Record "NS_Subcontract Links";
        Cont: Record Contact;
        ContBusinessRelation: Record "Contact Business Relation";
        Vend: Record Vendor;
        SubcontractPurchaseParameter: Page NS_SubcontractPurchParameter;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        "Sub-LevelSubcontractStatus": Boolean;
        Hold: Decimal;
        Text000: Label 'You cannot change %1 because one or more entries are associated with this %2.';
        Text003: Label 'You must run the %1 and %2 functions to create and post the completion entries for this job.';
        Text004: Label 'This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?';
        Text005: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text006: Label 'Contact %1 %2 is not related to customer %3.';
        Text007: Label 'Contact %1 %2 is not related to a customer.';
        Text008: Label '%1 %2 must not be blocked with type %3.';
        Text009: Label 'You must run the %1 function to reverse the completion entries that have already been posted for this job.';
        Text010: Label 'A subcontract cannot be deleted when a sub-level is attached to it!\\To delete this subcontract, you must first delete sub-level subcontract %1';
        Text011: Label '"Would you like to copy subcontract card information from subcontract "';
        Text012: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text14021107: Label 'The %1 cannot be set same as the Subcontract %2.';//PRJ-589

    procedure AssistEdit(OldSubcontract: Record NS_Subcontract): Boolean;
    begin
        with Subcontract do begin
            Subcontract := Rec;
            JobsSetup.GET();
            if NoSeriesMgt.SelectSeries(JobsSetup."NS_Subcontract Nos.", OldSubcontract."NS_No. Series", "NS_No. Series") then begin
                NoSeriesMgt.SetSeries("NS_No.");
                Rec := Subcontract;
                exit(true);
            end;
        end;
    end;

    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::NS_Subcontract, "NS_No.", FieldNumber, ShortcutDimCode);
        MODIFY();
    end;

    procedure UpdateBuyFromCont(CustomerNo: Code[20]);
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        if Cust.GET(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "NS_Buy-from Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.RESET();
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "NS_Buy-from Vendor No.");
                if ContBusRel.FINDFIRST() then
                    "NS_Buy-from Vendor No." := ContBusRel."Contact No.";
            end;
            "NS_Buy-from Contact" := Cust.Contact;
        end;
    end;

    procedure NS_UpdateBuyFromVend(ContactNo: Code[20]);
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Vend: Record Vendor;
        Cont: Record Contact;
    begin
        if Cont.GET(ContactNo) then begin
            "NS_Buy-from Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
                "NS_Buy-from Contact" := Cont.Name
            else
                if Vend.GET("NS_Buy-from Vendor No.") then
                    "NS_Buy-from Contact" := Vend.Contact
                else
                    "NS_Buy-from Contact" := '';
        end else begin
            "NS_Buy-from Contact" := '';
            exit;
        end;

        ContBusinessRelation.RESET();
        ContBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FINDFIRST() then begin
            if "NS_Buy-from Vendor No." = '' then
                VALIDATE("NS_Buy-from Vendor No.", ContBusinessRelation."No.")
            else
                if "NS_Buy-from Vendor No." <> ContBusinessRelation."No." then
                    ERROR(Text006, Cont."No.", Cont.Name, "NS_Buy-from Vendor No.");
        end else
            ERROR(Text007, Cont."No.", Cont.Name);
    end;

    local procedure NS_SubcontractLedgEntryExist(): Boolean;
    var
        SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
    begin
        SubcontractLedgEntry.INIT();
        SubcontractLedgEntry.SETRANGE("NS_Subcontract No.", "NS_No.");
        exit(SubcontractLedgEntry.FINDFIRST);
    end;

    procedure NS_CurrencyUpdateDetailLines();
    var
        SubcontractDetail: Record "NS_Subcontract Lines";
    begin
        SubcontractDetail.SETRANGE("NS_Subcontract No.", "NS_No.");
        if SubcontractDetail.FINDSET() then
            repeat
                SubcontractDetail."NS_Currency Code" := "NS_Currency Code";
                SubcontractDetail.MODIFY();
            until SubcontractDetail.NEXT() = 0;
    end;

    procedure BudgetedLaborHours(var SubcontractHeader: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractPlanningLine: Record "Job Planning Line";
    begin
        Answer := 0;
        with SubcontractPlanningLine do begin
            RESET();
            SETCURRENTKEY("Job No.", "NS_Subcontract No.", "Job Task No.", "NS_Cost Category", Type, "No.", "Variant Code");
            SETRANGE("NS_Subcontract No.", SubcontractHeader."NS_No.");
            SETFILTER("Planning Date", SubcontractHeader.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Cost Category", SubcontractHeader.GETFILTER("NS_Cost Category Filter"));
            SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            if FINDSET() then
                repeat
                    if CostCategory.NS_Code <> "NS_Cost Category" then
                        if CostCategory.GET("NS_Cost Category") then;
                    if CostCategory.NS_Code = "NS_Cost Category" then
                        if CostCategory.NS_Type = CostCategory.NS_Type::Labor then
                            Answer := Answer + Quantity;
                until NEXT() = 0;
        end;
    end;

    procedure ActualLaborHours(var SubcontractHeader: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractLedgerEntry: Record "NS_Subcontract Ledger Entry";
    begin
        Answer := 0;
        with SubcontractLedgerEntry do begin
            RESET();
            SETCURRENTKEY("NS_Job No.", "NS_Job Task No.", "NS_Work Units", "NS_Work Units", "NS_Entry Type");
            SETRANGE("NS_Job No.", SubcontractHeader."NS_No.");
            SETRANGE(NS_Type, NS_Type::Resource);
            SETFILTER("NS_Posting Date", SubcontractHeader.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Work Units", SubcontractHeader.GETFILTER("NS_Cost Category Filter"));
            SETRANGE("NS_Entry Type", "NS_Entry Type"::Usage);
            if FINDSET() then
                repeat
                    if CostCategory.NS_Code <> "NS_Job Cost Category" then
                        if CostCategory.GET("NS_Job Cost Category") then;
                    if CostCategory.NS_Code = "NS_Job Cost Category" then
                        if CostCategory.NS_Type = CostCategory.NS_Type::Labor then
                            Answer := Answer + NS_Quantity;
                until NEXT() = 0;
        end;
    end;

    procedure NS_RetentionInvoiced(var SubcontractHeader: Record NS_Subcontract) Answer: Decimal;
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
        JobsSetup: Record "Jobs Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CorrectSubcontract: Boolean;
    begin
        Answer := 0;
        PurchSetup.GET();
        JobsSetup.GET();
        if not PurchSetup."NS_Purchase Retention Inactive" then begin
            VendLedgEntry.RESET();
            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
            VendLedgEntry.SETRANGE("Vendor No.", SubcontractHeader."NS_Buy-from Vendor No.");
            VendLedgEntry.SETFILTER("Posting Date", SubcontractHeader.GETFILTER("NS_Date Filter"));
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");
            if VendLedgEntry.FINDSET() then
                repeat
                    CorrectSubcontract := false;
                    PurchaseInvoiceLine.RESET();
                    PurchaseInvoiceLine.SETRANGE("Document No.", VendLedgEntry."Document No.");
                    if PurchaseInvoiceLine.FINDSET() then
                        repeat
                            if PurchaseInvoiceLine."NS_Subcontract No." = SubcontractHeader."NS_No." then
                                CorrectSubcontract := true;
                        until (PurchaseInvoiceLine.NEXT() = 0) or CorrectSubcontract;
                    if CorrectSubcontract then
                        Answer := Answer + VendLedgEntry."Amount (LCY)";
                until VendLedgEntry.NEXT() = 0;
        end;
    end;

    procedure NS_RetentionBalance(var SubcontractHeader: Record NS_Subcontract; CostCategory: Code[10]; JobTaskNo: Code[35]) Answer: Decimal;
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        PLActivityCode: Code[10];
        PLProcessCode: Code[10];
        PLOperationCode: Code[10];
        AddInAmount: Decimal;
        CorrectSubcontract: Boolean;
    begin
        //This routine will return the balance of retention for a Subcontract, Revenue Category, Activity, Process & Operation.
        //This value is derived from the values in purchase documents.
        Answer := 0;
        PurchSetup.GET();
        JobsSetup.GET();
        NS_JobTaskNoToAPO(JobTaskNo, ActivityCode, ProcessCode, OperationCode);
        if not PurchSetup."NS_Purchase Retention Inactive" then begin
            VendLedgEntry.RESET();
            VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
            VendLedgEntry.SETRANGE("Vendor No.", SubcontractHeader."NS_Buy-from Vendor No.");
            VendLedgEntry.SETFILTER("Posting Date", SubcontractHeader.GETFILTER("NS_Date Filter"));
            VendLedgEntry.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Payable Ledger");//
            if VendLedgEntry.FINDSET() then
                repeat
                    AddInAmount := 0;
                    //Look to see if this purchase document is for the correct Subcontract
                    CorrectSubcontract := true;
                    VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    case VendLedgEntry."Document Type" of
                        VendLedgEntry."Document Type"::Invoice:
                            begin
                                PurchInvLine.RESET();
                                PurchInvLine.SETRANGE("Document No.", VendLedgEntry."Document No.");
                                if PurchInvLine.FINDSET() then
                                    repeat
                                        if PurchInvLine."NS_Subcontract No." <> SubcontractHeader."NS_No." then
                                            CorrectSubcontract := false;
                                        if (CostCategory > '') and (PurchInvLine."NS_Job Cost Category" <> CostCategory) then
                                            CorrectSubcontract := false;
                                        NS_JobTaskNoToAPO(PurchInvLine."Job Task No.", PLActivityCode, PLProcessCode, PLOperationCode);
                                        if (ActivityCode > '') and (PLActivityCode <> ActivityCode) then
                                            CorrectSubcontract := false;
                                        if (ProcessCode > '') and (PLProcessCode <> ProcessCode) then
                                            CorrectSubcontract := false;
                                        if (OperationCode > '') and (PLOperationCode <> OperationCode) then
                                            CorrectSubcontract := false;
                                    until (PurchInvLine.NEXT() = 0) or not CorrectSubcontract;
                                if CorrectSubcontract then
                                    AddInAmount := VendLedgEntry."Remaining Amt. (LCY)";
                            end;
                        VendLedgEntry."Document Type"::"Credit Memo":
                            begin
                                PurchCrMemoLine.RESET();
                                PurchCrMemoLine.SETRANGE("Document No.", VendLedgEntry."Document No.");
                                if PurchCrMemoLine.FINDSET() then
                                    repeat
                                        if PurchCrMemoLine."NS_Subcontract No." <> SubcontractHeader."NS_No." then
                                            CorrectSubcontract := false;
                                        if (CostCategory > '') and (PurchCrMemoLine."NS_Job Cost Category" <> CostCategory) then
                                            CorrectSubcontract := false;
                                        NS_JobTaskNoToAPO(PurchCrMemoLine."Job Task No.", PLActivityCode, PLProcessCode, PLOperationCode);
                                        if (ActivityCode > '') and (PLActivityCode <> ActivityCode) then
                                            CorrectSubcontract := false;
                                        if (ProcessCode > '') and (PLProcessCode <> ProcessCode) then
                                            CorrectSubcontract := false;
                                        if (OperationCode > '') and (PLOperationCode <> OperationCode) then
                                            CorrectSubcontract := false;
                                    until (PurchCrMemoLine.NEXT() = 0) or not CorrectSubcontract;
                                if CorrectSubcontract then
                                    AddInAmount := -VendLedgEntry."Remaining Amt. (LCY)";
                            end;
                    end;

                    //If this VendLedgEntry is part of the Subcontract, then add it in
                    if CorrectSubcontract then
                        Answer := Answer + AddInAmount;

                until VendLedgEntry.NEXT() = 0;
        end;
    end;

    procedure "MarkSub-Levels"(var SubcontractHeader: Record NS_Subcontract; "IncludeSub-Levels": Boolean);
    var
        SubcontractList: Record NS_Subcontract;
    begin
        if SubcontractHeader.GETFILTER("NS_No.") > '' then
            with SubcontractHeader do begin
                CLEARMARKS;
                MARKEDONLY(false);
                if GETFILTERS() > '' then begin
                    SubcontractList.RESET();
                    SubcontractList.COPYFILTERS(SubcontractHeader);
                    RESET;
                    if SubcontractList.FINDSET() then
                        repeat
                            if "IncludeSub-Levels" then
                                "NS_MarkSubcontractSub-Levels"(SubcontractHeader, SubcontractList."NS_No.")
                            else begin
                                GET(SubcontractList."NS_No.");
                                MARK(true);
                            end;
                        until SubcontractList.NEXT() = 0;
                    MARKEDONLY(true);
                end else
                    if "IncludeSub-Levels" then begin
                        "NS_MarkSubcontractSub-Levels"(SubcontractHeader, SubcontractHeader."NS_No.");
                        MARKEDONLY(true);
                    end else
                        SETRANGE("NS_Sub-LeveltoSubcontractNo.", '');
            end;
    end;

    procedure "NS_MarkSubcontractSub-Levels"(var ListOfSubcontracts: Record NS_Subcontract; SubcontractNo: Code[20]);
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        if SubcontractNo > '' then
            with ListOfSubcontracts do begin
                GET(SubcontractNo);
                MARK(true);
                SubcontractSearch.RESET();
                SubcontractSearch.SETRANGE("NS_Sub-LeveltoSubcontractNo.", SubcontractNo);
                if SubcontractSearch.FINDSET() then
                    repeat
                        "NS_MarkSubcontractSub-Levels"(ListOfSubcontracts, SubcontractSearch."NS_No.");
                    until SubcontractSearch.NEXT() = 0;
            end;
    end;

    procedure NS_SLsBudgetedCost(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        Answer := 0;
        with SubcontractSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            if FINDSET() then
                repeat
                    SETFILTER("NS_Date Filter", ParentSubcontract.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentSubcontract.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentSubcontract.GETFILTER("NS_Adjustment Filter"));
                    if NS_Status >= NS_Status::Order then begin
                        CALCFIELDS("NS_Budgeted Cost (LCY)");
                        Answer := Answer + "NS_Budgeted Cost (LCY)" + NS_SLsBudgetedCost(SubcontractSearch);
                    end;
                until NEXT() = 0;
        end;
    end;

    procedure "NS_SLsUsage(Cost)"(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        Answer := 0;
        with SubcontractSearch do begin
            RESET;
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            if FINDSET then
                repeat
                    SETFILTER("NS_Date Filter", ParentSubcontract.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentSubcontract.GETFILTER("NS_Cost Category Filter"));
                    CALCFIELDS("NS_SubcontractUsageCost(LCY)");
                    Answer := Answer + "NS_SubcontractUsageCost(LCY)" + "NS_SLsUsage(Cost)"(SubcontractSearch);
                until NEXT() = 0;
        end;
    end;

    procedure NS_SLsUsageLaborHours(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
        SubcontractLedgerEntry: Record "NS_Subcontract Ledger Entry";
    begin
        Answer := 0;
        SubcontractSearch.RESET();
        SubcontractSearch.SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
        if SubcontractSearch.FINDSET() then
            repeat
                with SubcontractLedgerEntry do begin
                    RESET();
                    SETCURRENTKEY("NS_Subcontract No.", "NS_Job Task No.", "NS_Work Units", "NS_Entry Type");
                    SETRANGE("NS_Subcontract No.", SubcontractSearch."NS_No.");
                    SETFILTER("NS_Posting Date", ParentSubcontract.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Work Units", ParentSubcontract.GETFILTER("NS_Cost Category Filter"));
                    SETRANGE(NS_Type, NS_Type::Resource);
                    SETRANGE("NS_Entry Type", "NS_Entry Type"::Usage);
                    if FINDSET() then
                        repeat
                            if CostCategory.NS_Code <> "NS_Job Cost Category" then
                                if CostCategory.GET("NS_Job Cost Category") then;
                            if CostCategory.NS_Code = "NS_Job Cost Category" then
                                if CostCategory.NS_Type = CostCategory.NS_Type::Labor then
                                    if SubcontractSearch.NS_Status >= NS_Status::Order then
                                        Answer := Answer + NS_Quantity;
                        until NEXT() = 0;
                end;
                if SubcontractSearch.NS_Status >= NS_Status::Order then
                    Answer := Answer + NS_SLsUsageLaborHours(SubcontractSearch);
            until SubcontractSearch.NEXT() = 0;
    end;

    procedure NS_SLsInvoicedCost(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        Answer := 0;
        with SubcontractSearch do begin
            RESET();
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            SETFILTER("NS_Type Filter", '<>%1', SubcontractLedgEntry.NS_Type::Ledger);
            SETFILTER("NS_Date Filter", ParentSubcontract.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Cost Category Filter", ParentSubcontract.GETFILTER("NS_Cost Category Filter"));
            if FINDSET() then
                repeat
                    CALCFIELDS("NS_Invoiced Cost (LCY)");
                    Answer := Answer + "NS_Invoiced Cost (LCY)" + NS_SLsInvoicedCost(SubcontractSearch);
                until SubcontractSearch.NEXT() = 0;
        end;
    end;

    procedure NS_SLsPaymentMade(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
        Subcontract2: Record NS_Subcontract;
        PurchSetup: Record "Purchases & Payables Setup";
        Total: Decimal;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        Answer := 0;
        SourceCodeSetup.GET();
        with SubcontractSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            if FINDSET() then
                repeat
                    DetailedVendorLedgEntry.RESET();
                    DetailedVendorLedgEntry.SETCURRENTKEY("NS_Subcontract No.", "Source Code", "Posting Date");
                    DetailedVendorLedgEntry.SETRANGE("NS_Subcontract No.", SubcontractSearch."NS_No.");
                    DetailedVendorLedgEntry.SETRANGE("Source Code", SourceCodeSetup."Payment Journal");
                    DetailedVendorLedgEntry.SETFILTER("Posting Date", ParentSubcontract.GETFILTER("NS_Posting Date Filter"));
                    DetailedVendorLedgEntry.CALCSUMS("Amount (LCY)");
                    Answer := Answer + DetailedVendorLedgEntry."Amount (LCY)" + NS_SLsPaymentMade(SubcontractSearch);
                until SubcontractSearch.NEXT() = 0;
        end;
    end;

    procedure NS_SLsNS_RetentionInvoiced(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        Answer := 0;
        with SubcontractSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            SETFILTER("NS_Date Filter", ParentSubcontract.GETFILTER("NS_Date Filter"));
            if FINDSET() then
                repeat
                    Answer := Answer + NS_RetentionInvoiced(SubcontractSearch) + NS_SLsNS_RetentionInvoiced(SubcontractSearch);
                until SubcontractSearch.NEXT() = 0;
        end;
    end;

    procedure NS_SLsNS_RetentionBalance(var ParentSubcontract: Record NS_Subcontract) Answer: Decimal;
    var
        SubcontractSearch: Record NS_Subcontract;
    begin
        Answer := 0;
        with SubcontractSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontract."NS_No.");
            if FINDSET() then
                repeat
                    Answer := Answer + NS_RetentionBalance(SubcontractSearch, '', '') + NS_SLsNS_RetentionBalance(SubcontractSearch);
                until NEXT() = 0;
        end;
    end;

    procedure CalculatedPercentComplete(var SubcontractHeader: Record NS_Subcontract; "IncludeSub-Levels": Boolean): Decimal;
    var
        SubcontractLedgerEntry: Record "NS_Subcontract Ledger Entry";
        ActualCost: Decimal;
        "Sub-LevelsCost": Decimal;
        PctComplete: Decimal;
    begin
        SubcontractHeader.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Usage (Cost) (LCY)");
        ActualCost := SubcontractHeader."NS_Usage (Cost) (LCY)";
        //Find Revisions Cost and Price
        if "IncludeSub-Levels" then
            "Sub-LevelsCost" := NS_SLsBudgetedCost(SubcontractHeader)
        else
            "Sub-LevelsCost" := 0;
        if "NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 then
            PctComplete := ROUND((ActualCost / (SubcontractHeader."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
        else
            PctComplete := 0;

        PctComplete := PctComplete * 100;
        exit(PctComplete)
    end;

    procedure NS_SeparatorCount(JobNo: Code[20]) SepCount: Integer;
    var
        JobsSetup: Record "Jobs Setup";
        i: Integer;
    begin
        SepCount := 0;
        if JobsSetup."NS_Job No. Separators" = '' then
            JobsSetup.GET();
        if JobsSetup."NS_Job No. Separators" > '' then
            for i := 1 to STRLEN(JobNo) do begin
                if STRPOS(JobsSetup."NS_Job No. Separators", COPYSTR(JobNo, i, 1)) > 0 then
                    SepCount := SepCount + 1;
            end;
    end;

    procedure NS_ParentSubcontractNo(SubContNo: Code[20]) ParentSubcont: Code[20];
    var
        JobsSetup: Record "Jobs Setup";
        TotalSepCount: Integer;
        SepCount: Integer;
        i: Integer;
    begin
        ParentSubcont := '';
        if SubContNo > '' then begin
            TotalSepCount := NS_SeparatorCount(SubContNo);
            JobsSetup.GET();
            if JobsSetup."NS_Subcontract No. Separators" > '' then
                for i := 1 to STRLEN(SubContNo) do begin
                    if NS_SeparatorCount(COPYSTR(SubContNo, 1, i)) = TotalSepCount then begin
                        ParentSubcont := COPYSTR(SubContNo, 1, i - 1);
                        i := STRLEN(SubContNo);
                    end;
                end;
        end;
    end;

    procedure NS_SetLastSubcontractListFlag();
    var
        SubcontractHeader: Record NS_Subcontract;
        SubcontractHeaderToModify: Record NS_Subcontract;
        LastSubcNo: Code[20];
    begin
        with Subcontract do begin
            LastSubcNo := '';
            //Find the last master subcontract header
            RESET();
            if FINDSET() then begin
                if NS_SeparatorCount("NS_No.") = 0 then begin
                    repeat
                        LastSubcNo := "NS_No.";
                    until (NEXT() = 0) or (NS_SeparatorCount("NS_No.") > 0);
                end;
            end;
            //Now look for the last subjob for the master just found
            LastSubcNo := NS_FindLastSubcontractNo(LastSubcNo);

            if LastSubcNo > '' then begin
                GET(LastSubcNo);
                //Check if the job is already flagged
                if not "NS_Last SubcontForSubcontList" then begin
                    //Clear out any previously flagged last job
                    RESET;
                    SETCURRENTKEY("NS_Last SubcontForSubcontList");
                    SETRANGE("NS_Last SubcontForSubcontList", true);
                    if FINDSET() then
                        repeat
                            SubcontractHeaderToModify.GET("NS_No.");
                            SubcontractHeaderToModify."NS_Last SubcontForSubcontList" := false;
                            SubcontractHeaderToModify.MODIFY();
                        until NEXT() = 0;
                    //Now set the new last job
                    GET(LastSubcNo);
                    "NS_Last SubcontForSubcontList" := true;
                    MODIFY();
                end;
            end;
        end;
    end;

    procedure NS_FindLastSubcontractNo(ParentSubcontNo: Code[20]) Answer: Code[20];
    var
        SubcontractHeaderSearch: Record NS_Subcontract;
    begin
        Answer := '';
        with SubcontractHeaderSearch do begin
            RESET();
            SETCURRENTKEY("NS_Sub-LeveltoSubcontractNo.");
            SETRANGE("NS_Sub-LeveltoSubcontractNo.", ParentSubcontNo);
            if FINDSET() then
                repeat
                    Answer := "NS_No.";
                until NEXT() = 0;
            if Answer > '' then
                Answer := NS_FindLastSubcontractNo(Answer)
            else
                Answer := ParentSubcontNo;
        end;
    end;

    procedure NS_MakePurchaseDocument(var SubcontractHeader: Record NS_Subcontract);
    var
        PurchaseHeader: Record "Purchase Header";
        Job: Record Job;
        PurchSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NoSeriesRelationship: Record "No. Series Relationship";
        SubconDtl: Record "NS_Subcontract Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PreviousRetention: Decimal;
        RetBalance: Decimal;
        Used: Boolean;
        //PurchaseDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        PurchaseDocumentType: Enum "Purchase Document Type";
        PurchaseDocumentNo: Code[20];
        FirstJobNo: Code[20];
        Text0001: Label 'There is no value to this Subcontract.\No purchase document can be created.';
        Text0002: Label 'Purchase order document creation stopped.';
        Text0003: Label 'Purchase invoice document creation stopped.';
        Text0004: Label '"Purchase Order "';
        Text0005: Label '"Purchase Invoice "';
        Text0006: Label '" created from subcontract.\\Would you like to go there now?"';
        DetailDimSet: Integer;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
                                                      // >> Upgrade
        Go: Boolean;
        DeliverGoods: Boolean;
        IsHandled: Boolean;
    // << Upgrade

    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        //PRJ-273 VT1.0 22-05-20
        if not NS_CheckIfLineAvailbleForPO(SubcontractHeader) then
            Error('Purchase Document %1 already created', SubcontractHeader."NS_Purchase Document No.");
        ////PRJ-273 VT1.0 22-05-20
        JobsSetup.GET();
        Subcontract.GET(SubcontractHeader."NS_No.");
        SubcontractHeader.CALCFIELDS("NS_Budgeted Cost (LCY)");

        //Setup a new Purchase Header
        if SubcontractHeader."NS_Purchase Document No." = '' then begin///PRJ-274 VT1.0 22-05-20
            PurchaseHeader.INIT();

            //Determine if the document will be an Order, Invoice or Credit Memo
            case true of
                SubcontractHeader."NS_Budgeted Cost (LCY)" = 0:
                    begin
                        ERROR(Text0001);
                    end;
                SubcontractHeader."NS_Budgeted Cost (LCY)" > 0:
                    begin
                        // >> Upgrade
                        // >> 001
                        if "NS_Job No." = '' then
                            SubcontractPurchaseParameter.SetParemeter(true);
                        // << 001
                        // << Upgrade
                        if ACTION::OK = SubcontractPurchaseParameter.RUNMODAL then begin
                            // >> Upgrade
                            //SubcontractPurchaseParameter.NS_GetResults(PurchaseDocumentType, PurchaseDocumentNo);
                            SubcontractPurchaseParameter.NS_GetResults(PurchaseDocumentType, PurchaseDocumentNo, DeliverGoods);
                            // << Upgrade
                            PurchaseDocumentType := PurchaseDocumentType + 1;
                        end else begin
                            CLEAR(SubcontractPurchaseParameter);
                            exit;
                        end;
                        CLEAR(SubcontractPurchaseParameter);

                    end;
                SubcontractHeader."NS_Budgeted Cost (LCY)" < 0:
                    begin
                        PurchaseDocumentType := PurchaseDocumentType::"Credit Memo";
                    end;
            end;

            //Try to Find Existing Document
            if PurchaseDocumentNo > '' then
                PurchaseHeader.GET(PurchaseDocumentType, PurchaseDocumentNo)
            else begin
                //Set up the Purchase Header and Insert
                PurchaseHeader."Document Type" := (PurchaseDocumentType);
                PurchaseHeader."Buy-from Vendor No." := SubcontractHeader."NS_Buy-from Vendor No.";
                PurchSetup.GET();
                if PurchaseHeader."No." = '' then
                    case PurchaseHeader."Document Type" of
                        // >> Upgrade
                        PurchaseHeader."Document Type"::Quote:
                            begin
                                PurchSetup.TestField("Quote Nos.");
                                NoSeriesRelationship.Reset;
                                NoSeriesRelationship.SetRange(Code, PurchSetup."Quote Nos.");
                                if NoSeriesRelationship.Count > 1 then begin
                                    if NoSeriesMgt.SelectSeries(PurchSetup."Quote Nos.", xRec."NS_No. Series", PurchaseHeader."No. Series") then
                                        PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WorkDate(), true)
                                    else
                                        Error(Text0002);
                                end else
                                    NoSeriesMgt.InitSeries(PurchSetup."Quote Nos.", '', WorkDate(), PurchaseDocumentNo, PurchaseHeader."No. Series");

                                PurchSetup.TestField("Posted Receipt Nos.");
                                PurchaseHeader."Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                            end;
                        // << Upgrade
                        PurchaseHeader."Document Type"::Order:
                            begin
                                PurchSetup.TESTFIELD("Order Nos.");
                                NoSeriesRelationship.RESET();
                                NoSeriesRelationship.SETRANGE(Code, PurchSetup."Order Nos.");
                                if NoSeriesRelationship.COUNT > 1 then begin
                                    if NoSeriesMgt.SelectSeries(PurchSetup."Order Nos.", xRec."NS_No. Series", PurchaseHeader."No. Series") then
                                        PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WORKDATE(), true)
                                    else
                                        ERROR(Text0002);
                                end else
                                    NoSeriesMgt.InitSeries(PurchSetup."Order Nos.", '', WORKDATE(), PurchaseDocumentNo, PurchaseHeader."No. Series");

                                //Get Receiving No.
                                PurchSetup.TESTFIELD("Posted Receipt Nos.");
                                PurchaseHeader."Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                            end;
                        PurchaseHeader."Document Type"::Invoice:
                            begin
                                PurchSetup.TESTFIELD("Invoice Nos.");
                                NoSeriesRelationship.RESET();
                                NoSeriesRelationship.SETRANGE(Code, PurchSetup."Invoice Nos.");
                                if NoSeriesRelationship.COUNT > 1 then begin
                                    if NoSeriesMgt.SelectSeries(PurchSetup."Invoice Nos.", xRec."NS_No. Series", PurchaseHeader."No. Series") then
                                        PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WORKDATE(), true)
                                    else
                                        ERROR(Text0003);
                                end else
                                    NoSeriesMgt.InitSeries(PurchSetup."Invoice Nos.", '', WORKDATE(), PurchaseDocumentNo, PurchaseHeader."No. Series");

                                //Get Receiving No.
                                if PurchSetup."Receipt on Invoice" then begin
                                    PurchSetup.TESTFIELD("Posted Receipt Nos.");
                                    PurchaseHeader."Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                                end;
                            end;
                        //PRJ-274 VT1.0 22-05-20 Begin
                        PurchaseHeader."Document Type"::"Credit Memo":
                            begin
                                PurchSetup.TESTFIELD("Credit Memo Nos.");
                                NoSeriesRelationship.RESET;
                                NoSeriesRelationship.SETRANGE(Code, PurchSetup."Credit Memo Nos.");
                                if NoSeriesRelationship.COUNT > 1 then begin
                                    if NoSeriesMgt.SelectSeries(PurchSetup."Credit Memo Nos.", xRec."NS_No. Series", PurchaseHeader."No. Series") then
                                        PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WORKDATE(), true)
                                    else
                                        ERROR(Text0003);
                                end else
                                    NoSeriesMgt.InitSeries(PurchSetup."Credit Memo Nos.", '', WORKDATE(), PurchaseDocumentNo, PurchaseHeader."No. Series");

                                //Get Receiving No.
                                if PurchSetup."Return Shipment on Credit Memo" then begin
                                    PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                                    PurchaseHeader."Return Shipment No. Series" := PurchSetup."Posted Return Shpt. Nos.";
                                end;
                            end;
                    //PRJ-274 VT1.0 22-05-20 end
                    end;
            end;//PRJ-274 VT1.0 22-05-20
            if SubcontractHeader."NS_Purchase Document No." = '' then begin//PRJ-274 VT1.0 22-05-20
                PurchaseHeader."No." := PurchaseDocumentNo;
                PurchaseHeader.InitRecord;
                PurchaseHeader.VALIDATE("Buy-from Vendor No.");
                NoSeriesMgt.SetDefaultSeries(PurchaseHeader."Posting No. Series", PurchSetup."Posted Invoice Nos.");
                PurchaseHeader."NS_Retention Percent" := SubcontractHeader."NS_Retention Percent";
                PurchaseHeader."NS_Retention Date" := CALCDATE(JobsSetup."NS_Sales Retention Period", PurchaseHeader."Document Date");
                PurchaseHeader."Currency Code" := "NS_Currency Code";
                // >> Upgrade
                IsHandled := false;
                OnNS_MakePurchaseDocument1(SubcontractHeader, PurchaseHeader, IsHandled, FirstJobNo, SubconDtl, Job, DeliverGoods);
                //PurchaseHeader."Dimension Set ID" := SubcontractHeader."NS_Dimension Set ID";//PRJ-715.RS.1.0 28May2021
                if IsHandled then
                    // << Upgrade
                    PurchaseHeader.VALIDATE("NS_Job No.", SubcontractHeader."NS_Job No.");
                // >> Upgrade
                OnNS_MakePurchaseDocument2(SubcontractHeader, PurchaseHeader);

                // << Upgrade
                PurchaseHeader."Dimension Set ID" := SubcontractHeader."NS_Dimension Set ID";//PRJ-715.RS.1.0 28May2021
                PurchaseHeader."NS_Progress Payment Enable" := JobsSetup."NS_Progress Payment Enable"; //PRJ-889.GK.1.0 13Sep2021
                PurchaseHeader.Validate("NS_Retention Percent", SubcontractHeader."NS_Retention Percent"); //PRJ-906.GK.1.0 05Oct2021
                PurchaseHeader.INSERT();
            end;//PRJ-274 VT1.0 22-05-20
        end;

        //Set up Purchase Lines
        //PRJ-274 VT1.0 22-05-20 begin
        if SubcontractHeader."NS_Purchase Document No." <> '' then
            PurchaseHeader.Get(SubcontractHeader."NS_Purchase Document Type", SubcontractHeader."NS_Purchase Document No.");
        if PurchaseHeader.Status <> PurchaseHeader.Status::Open then
            Error('Line Cannot be Inserted as Document %1 Status is not Open', PurchaseHeader."No.");
        //PRJ-274 VT1.0 22-05-20 end
        NS_MakePurchaseDocumentLines(PurchaseHeader, SubcontractHeader);

        //Get Job No. from subcontract detail - first one found
        FirstJobNo := '';
        SubconDtl.RESET();
        SubconDtl.SETRANGE("NS_Subcontract No.", SubcontractHeader."NS_No.");
        if SubconDtl.FINDSET() then
            repeat
                if FirstJobNo = '' then
                    FirstJobNo := SubconDtl."NS_Job No.";
            until SubconDtl.NEXT() = 0;

        //Update Purchase Header
        PurchaseHeader.VALIDATE("NS_Retention Amount");
        // PurchaseHeader."NS_Job No." := FirstJobNo;// #152
        PurchaseHeader."NS_Subcontract No." := SubcontractHeader."NS_No.";
        // >> Upgrade
        OnNS_MakePurchaseDocument3(PurchaseHeader);

        // << Upgrade
        PurchaseHeader.MODIFY();

        //Update Subcontract Header with new Purchase Document No.
        SubcontractHeader."NS_Purchase Document No." := PurchaseHeader."No.";
        SubcontractHeader."NS_Purchase Document Type" := PurchaseHeader."Document Type";//PRJ-274 VT1.0 22-05-20
                                                                                        // >> Upgrade
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                SubcontractHeader.NS_Status := SubcontractHeader.NS_Status::Order;
            PurchaseHeader."Document Type"::Quote:
                SubcontractHeader.NS_Status := SubcontractHeader.NS_Status::Quote;
        end;
        // << Upgrade
        SubcontractHeader.MODIFY();
        // >> Upgrade
        OnNS_MakePurchaseDocument4(SubcontractHeader);
        // << Upgrade
        //Show appropriate completion message
        // >> Upgrade
        // if CONFIRM(Text0004 + PurchaseHeader."No." + Text0006, true) then
        //     PAGE.RUN(PAGE::"NS_Subcontract PO", PurchaseHeader);
        Go := false;
        Go := Confirm(StrSubstNo(Text0004, PurchaseHeader."Document Type") + PurchaseHeader."No." + Text0006, true);
        if Go then
            case PurchaseHeader."Document Type" of
                PurchaseHeader."Document Type"::Order:
                    PAGE.RunModal(PAGE::"NS_Subcontract PO", PurchaseHeader);
                PurchaseHeader."Document Type"::Quote:
                    PAGE.RunModal(PAGE::"Purchase Quote", PurchaseHeader);
                PurchaseHeader."Document Type"::Invoice:
                    PAGE.RunModal(PAGE::"Purchase Invoice", PurchaseHeader);
            end;
        // << Upgrade
    end;

    procedure NS_MakePurchaseDocumentLines(PurchaseHeader: Record "Purchase Header"; SubcontractHeader: Record NS_Subcontract);
    var
        PurchaseLine: Record "Purchase Line";
        SubcontractDetail: Record "NS_Subcontract Lines";
        JPLLines: Record "Job Planning Line";     //PRJ-866.JS.1.0   18Aug2021
        JobTask1: Record "job task";      //PRJ-913.JS.1.0  16Sep2021
        BillingHeader: Record "NS_Progress Billing Header";  //PRJ-913.JS.1.0    16Sep2021        
        LineNumber: Integer;
        HeaderDimSet: Integer;
        T_27: Record Item;//PRJ-383.N.S.1.0 16Sep2020
    begin
        JobsSetup.GET();

        //Create Normal Payables Document Lines
        with SubcontractDetail do begin
            PurchaseLine.RESET();
            PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            if PurchaseLine.FINDLAST() then
                LineNumber := PurchaseLine."Line No."
            else
                LineNumber := 0;

            RESET;
            SETRANGE("NS_Subcontract No.", SubcontractHeader."NS_No.");
            SetRange("NS_PO No.", '');//PRJ-274 VT1.0 22-05-20
            SetRange("NS_PO Line No.", 0);//PRJ-274 VT1.0 22-05-20
            if FINDSET then
                repeat
                    //Build the purchase line
                    PurchaseLine.INIT();
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    LineNumber := LineNumber + 10000;
                    PurchaseLine."Line No." := LineNumber;
                    // >> Upgrade
                    // >> 002
                    PurchaseLine.Insert(true);
                    // << 002
                    // << Upgrade
                    case NS_Type of
                        NS_Type::Resource:
                            PurchaseLine.Type := PurchaseLine.Type::Resource;
                        NS_Type::Item:
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        NS_Type::"G/L Account":
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    end;
                    // >> Upgrade
                    OnNS_MakePurchaseDocumentLines1(SubcontractDetail, PurchaseLine);
                    // << Upgrade
                    if PurchaseLine.Type.AsInteger() <> 0 then begin
                        PurchaseLine.VALIDATE(Type);
                        PurchaseLine."No." := "NS_No.";
                        if ((NS_Type = NS_Type::"G/L Account") or (NS_Type = NS_Type::Resource)) and
                           ("NS_Unit of Measure Code" = JobsSetup."NS_Subcontract Default UOM") then
                            PurchaseLine."Unit of Measure" := JobsSetup."NS_Subcontract Default UOM"
                        else
                            PurchaseLine."Unit of Measure" := "NS_Unit of Measure Code";
                        PurchaseLine.VALIDATE("No.");
                        //PRJ-383.N.S.1.0 16Sep2020 Start
                        if (NS_Type = NS_Type::"G/L Account") OR (NS_Type = NS_Type::Resource) then
                            PurchaseLine."Unit of Measure Code" := "NS_Unit of Measure Code";
                        if NS_Type = NS_Type::Item then begin
                            If "NS_No." <> '' then
                                T_27.Get("NS_No.");
                            PurchaseLine."Unit of Measure Code" := T_27."Base Unit of Measure";
                        end;
                        //PRJ-383.N.S.1.0 16Sep2020 End                  
                        PurchaseLine."Expected Receipt Date" := "NS_Starting Date";
                        PurchaseLine.Description := NS_Description;
                        PurchaseLine.Quantity := NS_Quantity;
                        //PRJ-206.MS.1.0 code comment start
                        //if ((NS_Type = NS_Type::"G/L Account") or (NS_Type = NS_Type::Resource)) and
                        //   ("NS_Unit of Measure Code" = JobsSetup."NS_Subcontract Default UOM") then begin
                        //    PurchaseLine."Unit of Measure" := JobsSetup."NS_Subcontract Default UOM";  //do it again
                        //    if NS_Type = NS_Type::"G/L Account" then begin
                        //        PurchaseLine."Direct Unit Cost" := 1;
                        //        PurchaseLine."Unit Cost" := 1;
                        //        PurchaseLine.VALIDATE("Unit Cost (LCY)", 1);
                        //        PurchaseLine."Qty. per Unit of Measure" := 1;
                        //        PurchaseLine.Quantity := "NS_Total Cost"
                        //    end else begin
                        //        PurchaseLine."Direct Unit Cost" := NS_Quantity;
                        //        PurchaseLine.Quantity := "NS_Unit Cost";
                        //    end;
                        //    PurchaseLine."Quantity (Base)" := PurchaseLine.Quantity;
                        //    PurchaseLine.VALIDATE(Quantity);
                        //end else begin
                        //PRJ-206.MS.1.0 code comment end
                        //Process normal lines
                        PurchaseLine."Unit of Measure" := "NS_Unit of Measure Code";  //do it again
                        // PurchaseLine."Direct Unit Cost" := "NS_Unit Cost"; //PPAL-74.SK.1.0 Commented
                        PurchaseLine.VALIDATE("Direct Unit Cost", "NS_Unit Cost"); //PPAL-74.SK.1.0 Added
                        PurchaseLine.VALIDATE("Unit Cost (LCY)", "NS_Unit Cost");
                        //PRJ-866.JS.1.0 18Aug2021-Start
                        JPLLines.Reset();
                        IF JPLLines.Get(SubcontractDetail."NS_Job No.", SubcontractDetail."NS_Job Task No.",
                                    SubcontractDetail."NS_JPL Line No.") then begin
                            PurchaseLine.Validate("Unit Price (LCY)", JPLLines."Unit Price (LCY)");
                            PurchaseLine.VALIDATE("Job Unit Price", JPLLines."Unit Price");
                            PurchaseLine.VALIDATE("Job Unit Price (LCY)", JPLLines."Unit Price");
                        end;
                        //PRJ-866.JS.1.0 18Aug2021-end
                        PurchaseLine."Qty. per Unit of Measure" := "NS_Qty. per Unit of Measure";
                        PurchaseLine."Quantity (Base)" := "NS_Quantity (Base)";
                        PurchaseLine.VALIDATE(Quantity);
                        //PRJ-866.JS.1.0 18Aug2021-Start
                        JPLLines.Reset();
                        IF JPLLines.Get(SubcontractDetail."NS_Job No.", SubcontractDetail."NS_Job Task No.",
                                    SubcontractDetail."NS_JPL Line No.") then begin
                            PurchaseLine.Validate("Unit Price (LCY)", JPLLines."Unit Price (LCY)");
                            PurchaseLine.VALIDATE("Job Unit Price", JPLLines."Unit Price");
                            PurchaseLine.VALIDATE("Job Unit Price (LCY)", JPLLines."Unit Price");
                            //PRJ-1029.GK.1.0 O9Nov2021 start
                            PurchaseLine.Validate("Job Line Amount (LCY)", JPLLines."Line Amount (LCY)");
                            PurchaseLine.Validate("Job Line Amount", JPLLines."Line Amount");
                            //PRJ-1029.GK.1.0 O9Nov2021 end
                        end;
                        //PRJ-866.JS.1.0 18Aug2021-end                        
                        PurchaseLine."Currency Code" := "NS_Currency Code";
                        PurchaseLine."Variant Code" := "NS_Variant Code";
                        PurchaseLine."Job No." := "NS_Job No.";
                        PurchaseLine."NS_Subcontract No." := "NS_Subcontract No.";
                        PurchaseLine."NS_Job Cost Category" := "NS_Job Cost Category";
                        PurchaseLine."Job Task No." := "NS_Job Task No.";
                        if PurchaseHeader."NS_Retention Percent" > 0 then
                            PurchaseLine."NS_Retention Applies" := true;
                        //PurchaseLine.VALIDATE("Unit of Measure Code", "NS_Unit of Measure Code");//PRJ.302.MS.1.0 comment
                    end;
                    PurchaseLine."Dimension Set ID" := "NS_Dimension Set ID";
                    //PRJ-913.JS.1.0 13Sep2021-Start                        
                    if JobTask1.GET(PurchaseLine."Job No.", PurchaseLine."Job Task No.") then
                        IF ((JobTask1."Global Dimension 1 Code" <> '') and (JobTask1."Global Dimension 2 Code" <> '')) then begin
                            PurchaseLine."Shortcut Dimension 1 Code" := JobTask1."Global Dimension 1 Code";
                            PurchaseLine."Shortcut Dimension 2 Code" := JobTask1."Global Dimension 2 Code";
                            PurchaseLine."Dimension Set ID" := BillingHeader.NS_GetDimensionNoFromJobTask(PurchaseLine."Job No.", PurchaseLine."Job Task No.");
                        end;
                    //PRJ-913.JS.1.0 13Sep2021-end 
                    PurchaseLine."Job Planning Line No." := "NS_Job Planning Line No.";
                    //PurchaseLine."NS_JMP Document No." := SubcontractHeader."NS_No.";	//PRJ-383.N.S.1.0 16Sep2020 Code comment
                    PurchaseLine."NS_JMP Document No." := ''; //PRJ-383.N.S.1.0 16Sep2020
                    PurchaseLine."NS_Work Units" := "NS_Work Units"; //PRJ-817.JS.1.0�04Aug2021
                    PurchaseLine."NS_Work Unit of Measure" := "NS_Work Unit of Measure"; //PRJ-817.JS.1.0�04Aug2021
                                                                                         // >> Upgrade
                                                                                         // >> 002
                                                                                         //PurchaseLine.INSERT(TRUE);
                    PurchaseLine.Modify(true);
                    // << 002
                    // << Upgrade
                    "NS_PO No." := PurchaseLine."Document No.";//PRJ-274 VT1.0 22-05-20
                    "NS_PO Line No." := PurchaseLine."Line No.";//PRJ-274 VT1.0 22-05-20
                    Modify();
                until NEXT() = 0;
        end;
    end;

    procedure CopySubcontractRecord(Rec: Record NS_Subcontract; SubcontractNo: Code[20]);
    var
        SubcontractHeaderHold: Record NS_Subcontract;
        SubcontractNew: Record NS_Subcontract;
    begin
        SubcontractHeaderHold := Rec;
        SubcontractNew.GET(SubcontractNo);

        Rec := SubcontractNew;
        Rec."NS_No." := SubcontractHeaderHold."NS_No.";
        Rec."NS_Sub-LeveltoSubcontractNo." := SubcontractHeaderHold."NS_Sub-LeveltoSubcontractNo.";
        Rec.NS_Status := Rec.NS_Status::Planning;
        Rec.NS_Blocked := 0;
        Rec.NS_Status := 0;
        Rec."NS_Subcontract Status Date" := 0D;
        Rec."NS_Estimated Start Date" := 0D;
        Rec."NS_Starting Date" := 0D;
        Rec."NS_Estimated Completion Date" := 0D;
        Rec."NS_Ending Date" := 0D;
        Rec."NS_Creation Date" := TODAY();
        Rec."NS_Completion Date" := 0D;

        //Link to Parent Subcontract
        with SubcontractLinks do begin
            INIT();
            SubcontractLinks."NS_Subcontract No." := Rec."NS_No.";
            SubcontractLinks."NS_Parent Subcontract No." := SubcontractHeaderHold."NS_Sub-LeveltoSubcontractNo.";
            INSERT();
        end;
    end;

    procedure NS_JobTaskNoNS_SeparatorCount(JobTaskNo: Code[35]) SepCount: Integer;
    var
        JobsSetup: Record "Jobs Setup";
        i: Integer;
    begin
        SepCount := 0;
        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();
        if JobsSetup."NS_APO Separators" > '' then
            for i := 1 to STRLEN(JobTaskNo) do begin
                if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then
                    SepCount := SepCount + 1;
            end;
    end;

    procedure NS_JobTaskNoToAPO(JobTaskNo: Code[35]; var ActivityCode: Code[10]; var ProcessCode: Code[10]; var OperationCode: Code[10]);
    var
        JobsSetup: Record "Jobs Setup";
        Segment1: Text[30];
        Segment2: Text[30];
        Segment3: Text[30];
        Segment4: Text[30];
        i: Integer;
        j: Integer;
        k: Integer;
    begin
        //The double COPYSTRs in this routine are to ensure that the APO codes are only 10 characters long reguardless
        //    of how many characters between the separaters there may be.

        ActivityCode := '';
        ProcessCode := '';
        OperationCode := '';
        Segment1 := '';
        Segment2 := '';
        Segment3 := '';
        Segment4 := '';

        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();

        case NS_JobTaskNoNS_SeparatorCount(JobTaskNo) of
            0:
                Segment1 := COPYSTR(JobTaskNo, 1, 10);
            1:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin
                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, STRLEN(JobTaskNo) - i), 1, 10);
                        i := STRLEN(JobTaskNo);
                    end;
            2:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin
                                //Now have both separators.  Break up the string.
                                Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, STRLEN(JobTaskNo) - j), 1, 10);
                                //end both loops
                                i := STRLEN(JobTaskNo);
                                j := STRLEN(JobTaskNo);
                            end;
                    end;
            3:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin

                                //Found the second separator.  Now look for the third starting from here.
                                for k := j + 1 to STRLEN(JobTaskNo) do
                                    if STRPOS(JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, k, 1)) > 0 then begin
                                        //Now have all three separators.  Break up the string.
                                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                        Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, k - j - 1), 1, 10);
                                        Segment4 := COPYSTR(COPYSTR(JobTaskNo, k + 1, STRLEN(JobTaskNo) - k), 1, 10);
                                        //end both loops
                                        i := STRLEN(JobTaskNo);
                                        j := STRLEN(JobTaskNo);
                                        k := STRLEN(JobTaskNo);
                                    end;
                            end;
                    end;
        end;

        if JobsSetup."NS_Activity Code Position" = 1 then begin
            ActivityCode := Segment1;
            ProcessCode := Segment2;
            OperationCode := Segment3;
        end else begin
            ActivityCode := Segment2;
            ProcessCode := Segment3;
            OperationCode := Segment4;
        end;
    end;

    procedure APOToJobTaskNo(ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]) JobTaskNo: Text[35];
    var
        JobsSetup: Record "Jobs Setup";
    begin
        //This routine simply puts together the Activity, Process and Operation codes passed in into a Job Task No.
        //The separator used will be the first chararacter of the APO separator list.
        //If the Activity Code is actually the second segment of the Job Task No. then you must use the JAPOtoJobTaskNo routine.

        JobTaskNo := '';
        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();
        if ActivityCode > '' then begin
            JobTaskNo := ActivityCode;
            if ProcessCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ProcessCode;
                if OperationCode > '' then
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
            end;
        end;
    end;

    procedure JAPOToJobTaskNo(TaskNo: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]) JobTaskNo: Text[35];
    begin
        //This routine simply puts together the Job Task No., Activity, Process and Operation codes passed in into a Job Task No.
        //The separator used will be the first chararacter of the APO separator list.
        //If the Activity Code is actually the first segment of the Job Task No. then you must use the APOtoJobTaskNo routine.

        JobTaskNo := '';
        if JobsSetup."NS_APO Separators" = '' then
            JobsSetup.GET();
        if TaskNo > '' then begin
            JobTaskNo := TaskNo;
            if ActivityCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ActivityCode;
                if ProcessCode > '' then begin
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ProcessCode;
                    if OperationCode > '' then
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                end;
            end;
        end;
    end;

    procedure NS_ClearExistingDimensions(SubcontractNo: Code[20]);
    var
        Subcontract: Record NS_Subcontract;
        DefaultDimension: Record "Default Dimension";
    begin
        if SubcontractNo > '' then
            if Subcontract.GET(SubcontractNo) then begin
                with DefaultDimension do begin
                    RESET();
                    SETRANGE("Table ID", DATABASE::NS_Subcontract);
                    SETRANGE("No.", SubcontractNo);
                    if FINDSET() then
                        repeat
                            DELETE();
                        until NEXT() = 0;
                end;
            end;
    end;

    procedure NS_SetDimensions(SubcontractNo: Code[20]; JobNo: Code[20]);
    var
        Subcontract: Record NS_Subcontract;
        SubcontractDefaultDimension: Record "Default Dimension";
        JobDefaultDimension: Record "Default Dimension";
    begin
        if (SubcontractNo > '') and (JobNo > '') then
            with SubcontractDefaultDimension do begin
                JobDefaultDimension.RESET();
                JobDefaultDimension.SETRANGE("Table ID", DATABASE::Job);
                JobDefaultDimension.SETRANGE("No.", JobNo);
                if JobDefaultDimension.FINDFIRST() then
                    repeat
                        RESET();
                        SETRANGE("Table ID", DATABASE::NS_Subcontract);
                        SETRANGE("No.", SubcontractNo);
                        SETRANGE("Dimension Code", JobDefaultDimension."Dimension Code");
                        if FINDFIRST() then begin
                            "Dimension Value Code" := JobDefaultDimension."Dimension Value Code";
                            "Value Posting" := JobDefaultDimension."Value Posting";
                            "Table Caption" := JobDefaultDimension."Table Caption";
                            "Multi Selection Action" := JobDefaultDimension."Multi Selection Action";
                            MODIFY();
                        end else begin
                            INIT();
                            "Table ID" := DATABASE::NS_Subcontract;
                            "No." := SubcontractNo;
                            "Dimension Code" := JobDefaultDimension."Dimension Code";
                            "Dimension Value Code" := JobDefaultDimension."Dimension Value Code";
                            "Value Posting" := JobDefaultDimension."Value Posting";
                            "Table Caption" := JobDefaultDimension."Table Caption";
                            "Multi Selection Action" := JobDefaultDimension."Multi Selection Action";
                            INSERT();
                        end;
                    until JobDefaultDimension.NEXT() = 0;
            end;
    end;

    procedure GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
    var
        DefaultDimension: Record "Default Dimension";
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        //Get the new type of Dimension No. for the values in the Default Dimension table for the Job
        //  Create a temporary DimensionSet table to send to DimMgt for it to return the number assiged to
        //  that set.

        DimensionNo := 0;
        with DefaultDimension do begin
            DefaultDimension.RESET();
            DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimension.SETRANGE("No.", JobNo);
            if DefaultDimension.FINDSET() then
                repeat
                    //Find a "Dimension Value" record based on the "Default Dimension" field values
                    //  If one is found, then a new temp table entry can be made
                    DimensionValue.RESET();
                    DimensionValue.SETRANGE("Dimension Code", "Dimension Code");
                    DimensionValue.SETRANGE(Code, "Dimension Value Code");
                    if DimensionValue.FINDFIRST() then begin
                        DimensionSetEntryTemp.INIT();
                        DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                        DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                        DimensionSetEntryTemp.INSERT();
                    end;
                until DefaultDimension.NEXT() = 0;
            //Now pass the temp table to DimMgt to get the proper Dimension No.
            DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
        end;
    end;

    procedure NS_ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "NS_Dimension Set ID";
        "NS_Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "NS_Dimension Set ID", "NS_No.", "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");

        if OldDimSetID <> "NS_Dimension Set ID" then begin
            MODIFY();
            if NS_SubcontractLinesExist then
                NS_UpdateAllLineDim("NS_Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure NS_UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not CONFIRM(Text012) then
            exit;

        SubcontractLine.RESET();
        SubcontractLine.SETRANGE("NS_Subcontract No.", "NS_No.");
        SubcontractLine.LOCKTABLE;
        if SubcontractLine.FINDSET() then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(SubcontractLine."NS_Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if SubcontractLine."NS_Dimension Set ID" <> NewDimSetID then begin
                    SubcontractLine."NS_Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      SubcontractLine."NS_Dimension Set ID", SubcontractLine."NS_Shortcut Dimension 1 Code", SubcontractLine."NS_Shortcut Dimension 2 Code");
                    SubcontractLine.MODIFY();
                end;
            until SubcontractLine.NEXT() = 0;
    end;

    procedure NS_SubcontractLinesExist(): Boolean;
    begin
        SubcontractLine.RESET();
        SubcontractLine.SETRANGE("NS_Subcontract No.", "NS_No.");
        exit(SubcontractLine.FINDFIRST());
    end;

    local procedure NS_MoveSubcontractEntries(Subcontract: Record NS_Subcontract);
    var
        NS_SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
        NS_SubcontractDetail: Record "NS_Subcontract Lines";
        PurchOrderLine: Record "Purchase Line";
        ServLedgEntry: Record "Service Ledger Entry";
        AccountingPeriod: Record "Accounting Period";
        Text001: Label 'You cannot delete %1 %2 because there are one or more open ledger entries.';
    begin
        //ProjectPro - start
        NS_SubcontractLedgEntry.SETCURRENTKEY("NS_Subcontract No.");
        NS_SubcontractLedgEntry.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
        NS_SubcontractLedgEntry.LOCKTABLE;

        PurchOrderLine.SETCURRENTKEY("Document Type");
        PurchOrderLine.SETFILTER(
          "Document Type", '%1|%2',
          PurchOrderLine."Document Type"::Order,
          PurchOrderLine."Document Type"::"Return Order");
        PurchOrderLine.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
        if PurchOrderLine.FINDFIRST() then
            ERROR(
              Text007,
              Subcontract.TABLECAPTION, Subcontract."NS_No.",
              PurchOrderLine."Document Type");

        NS_SubcontractLedgEntry.MODIFYALL("NS_Subcontract No.", '');

        ServLedgEntry.LOCKTABLE;

        NS_SubcontractDetail.RESET();
        NS_SubcontractDetail.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
        if NS_SubcontractDetail.FINDSET() then
            repeat
                ServLedgEntry.RESET();
                ServLedgEntry.SETRANGE("Job No.", NS_SubcontractDetail."NS_Job No.");
                ServLedgEntry.SETRANGE("NS_Subcontract No.", Subcontract."NS_No.");
                AccountingPeriod.SETRANGE(Closed, false);
                if AccountingPeriod.FINDFIRST() then
                    ServLedgEntry.SETFILTER("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                if ServLedgEntry.FINDFIRST() then
                    ERROR(
                      Text000,
                      Subcontract.TABLECAPTION, Subcontract."NS_No.");

                ServLedgEntry.SETRANGE("Posting Date");
                ServLedgEntry.SETRANGE(Open, true);
                if ServLedgEntry.FINDLAST() then
                    ERROR(
                     Text001,
                     Subcontract.TABLECAPTION, Subcontract."NS_No.");

                ServLedgEntry.SETRANGE(Open);
                ServLedgEntry.MODIFYALL("NS_Subcontract No.", '');
            until NS_SubcontractDetail.NEXT() = 0;
        //ProjectPro - end
    end;

    //PRJ-273/PRJ-274 VT1.0 22-05-20 begin
    local procedure NS_CheckIfLineAvailbleForPO(SubContractHdrParam: Record NS_Subcontract): Boolean
    var
        myInt: Integer;
        SubContractLines: Record "NS_Subcontract Lines";
    begin
        SubContractLines.Reset();
        SubContractLines.SetRange("NS_Subcontract No.", SubContractHdrParam."NS_No.");
        SubContractLines.SetRange("NS_PO No.", '');
        SubContractLines.SetRange("NS_PO Line No.", 0);
        if SubContractLines.FindFirst() then
            exit(true)
        else
            exit(false);
    end;
    //PRJ-273/PRJ-274 VT1.0 22-05-20 end
    //SMPL Replaced DimensionManagement named reference to ID (symbols bug)
    //SMPL TextConst replaced with label


    //PRJ-533.AS.1.0 16FEB2020 - START
    procedure NS_SubConCreateChangeOrder();
    var
        SubcontractNew_ChangeOrd: Record NS_Subcontract;
        SubConCard: Page "NS_Subcontract Card";
        Separator4SubContract: Text[10];
    begin
        Separator4SubContract := '.';
        WITH SubcontractNew_ChangeOrd DO BEGIN
            INIT;
            "NS_No." := NS_GetNextChangeOrderNo(Rec."NS_No.", Separator4SubContract);
            "NS_No. Series" := '';
            INSERT(TRUE);

            "NS_Search Description" := Rec."NS_Search Description";
            NS_Description := Rec.NS_Description;
            "NS_Description 2" := Rec."NS_Description 2";
            "NS_Buy-from Vendor No." := Rec."NS_Buy-from Vendor No.";
            VALIDATE("NS_Buy-from Vendor No.");
            "NS_Creation Date" := TODAY;
            "NS_Starting Date" := 0D;
            "NS_Ending Date" := 0D;
            NS_Status := NS_Status::Planning;
            "NS_Subcon Class" := "NS_Subcon Class"::"Change Order";
            "NS_Person Responsible" := Rec."NS_Person Responsible";
            VALIDATE("NS_Global Dimension 1 Code", Rec."NS_Global Dimension 1 Code");
            VALIDATE("NS_Global Dimension 2 Code", Rec."NS_Global Dimension 2 Code");
            NS_Blocked := NS_Blocked::" ";
            "NS_Sub-LeveltoSubcontractNo." := Rec."NS_No.";
            "NS_Job No." := rec."NS_Job No.";
            "NS_Language Code" := Rec."NS_Language Code";
            "NS_Buy-from Name" := Rec."NS_Buy-from Name";
            "NS_Buy-from Address" := Rec."NS_Buy-from Address";
            "NS_Buy-from Address 2" := Rec."NS_Buy-from Address 2";
            "NS_Buy-from City" := Rec."NS_Buy-from City";
            NS_County := Rec.NS_County;
            "NS_Buy-from Post Code" := Rec."NS_Buy-from Post Code";
            "NS_No. Series" := Rec."NS_No. Series";
            "NS_Buy-fromCountry/RegionCode" := Rec."NS_Buy-fromCountry/RegionCode";
            "NS_Currency Code" := Rec."NS_Currency Code";
            "NS_Buy-from Contact No." := Rec."NS_Buy-from Contact No.";
            "NS_Buy-from Contact" := Rec."NS_Buy-from Contact";
            "NS_Invoice Currency Code" := Rec."NS_Invoice Currency Code";
            "NS_Exch. Calculation (Cost)" := Rec."NS_Exch. Calculation (Cost)";
            "NS_Exch. Calculation (Price)" := Rec."NS_Exch. Calculation (Price)";
            "NS_AllowSchedule/ContractLines" := Rec."NS_AllowSchedule/ContractLines";
            "NS_Subcontract Status Date" := 0D;
            "NS_Estimated Start Date" := 0D;
            "NS_Estimated Completion Date" := 0D;
            "NS_Completion Date" := 0D;
            Modify();
        END;

        IF CONFIRM('Subcontract No. ' + SubcontractNew_ChangeOrd."NS_No." + ' has been created. Go to new Subcontract?') THEN BEGIN
            SubConCard.SETRECORD(SubcontractNew_ChangeOrd);
            SubConCard.RUN;
        END;
    end;
    //PRJ-533.AS.1.0 16FEB2020 - END


    //PRJ-533.AS.1.0 16FEB2020 - START
    LOCAL PROCEDURE NS_GetNextChangeOrderNo(PassSubContractCode: Code[20]; PassSubContractSeparator: Text[10]): Code[20];
    VAR
        NSSubcontractRec: Record NS_Subcontract;
    BEGIN
        NSSubcontractRec.RESET;
        NSSubcontractRec.SETFILTER("NS_No.", '%1', PassSubContractCode + PassSubContractSeparator + '*');
        IF NSSubcontractRec.FINDLAST THEN BEGIN
            EXIT(INCSTR(NSSubcontractRec."NS_No."));
        END ELSE
            EXIT(PassSubContractCode + PassSubContractSeparator + '001');
    END;
    //PRJ-533.AS.1.0 16FEB2020 - END    


    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnNS_MakePurchaseDocument1(var SubcontractHeader: Record NS_Subcontract; var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var FirstJobNo: Code[20]; var SubconDtl: Record "NS_Subcontract Lines"; var Job: Record Job; var DeliverGoods: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNS_MakePurchaseDocument2(var SubcontractHeader: Record NS_Subcontract; var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNS_MakePurchaseDocument3(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNS_MakePurchaseDocumentLines1(var SubcontractDetail: Record "NS_Subcontract Lines"; var PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNS_MakePurchaseDocument4(var SubcontractHeader: Record NS_Subcontract)
    begin
    end;
    // << Upgrade
}

