table 14021325 "NS_Progress Billing Header"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //SMPL - Replaced DimensionManagement named reference to ID (symbols bug)
    //PRJ-243 VT1.0 07-05-20
    //CTSI-121.N.S.1.0 18Aug2020 Add field manager & person responsible
    //PRJ-913.JS.1.0�14Sep2021 |Add procedure to flow dimension set ID as per job task lines
    //PRJ-980.MS.1.0 21Oct2021 | increase decimal places from 2 to 8
    //PRJ-999.JS.1.0 09Nov2021 | Add fields    
    //PRJ-1132.NK.1.0 13Jan2022 | Removed with statement
    //PRJ-1216.JS.1.0 04MAR2022 | Create new procedure
    //PRJ-1216.JS.2.0 25MAR2022 | Correct code as per Normal Tax
    //PRJ-1216.JS.3.0 28MAR2022
    //PRJ-1519.NK.1.0 15Jul2022 | Added Code
    //PRJ-1624.NK.1.0 22Sep2022 | Added Field
    //PRJ-1632.RM.1.0 28Sept2022 | Added some code
    //PE-53.RM.1.0 07March2023 | Added a field
    //PE-22.JS.1.0 21FEB2023 | Add new field
    Caption = 'Progress Billing Header';
    DrillDownPageID = "NS_Progress Billing List";
    LookupPageID = "NS_Progress Billing List";

    fields
    {
        field(1; "NS_No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_No." <> xRec."NS_No." then begin
                    JobsSetup.GET();
                    NoSeriesMgt.TestManual(JobsSetup."NS_Progress Billing Nos.");
                    "NS_No. Series" := '';
                end;
            end;
        }
        field(2; "NS_Requisition No."; Integer)
        {
            Caption = 'Requisition No.';
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                q: Integer;
            begin
                q := q;
            end;
        }
        field(3; "NS_Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
            // //PRJ-999.JS.1.0  09Nov2021 Start
            // trigger OnValidate()
            // var
            //     Job_L: Record Job;
            // begin
            //     if Job_L.get("NS_Job No.") then Begin
            //         "NS_Person Responsible" := Job_L."Person Responsible";
            //         Rec."NS_Global Dimension 1 Code" := Job_L."Global Dimension 1 Code";
            //         Rec."NS_Global Dimension 2 Code" := Job_L."Global Dimension 2 Code";
            //         Rec."NS_Dimension Set ID" := GetDimensionNoFromJob("NS_Job No.");
            //     end;
            // end;
            // //PRJ-999.JS.1.0  09Nov2021 end            
        }
        field(10; "NS_Requisition Date"; Date)
        {
            Caption = 'Requisition Date';
            DataClassification = CustomerContent;
        }
        field(11; "NS_Period To"; Date)
        {
            Caption = 'Period To';
            DataClassification = CustomerContent;
        }
        field(20; NS_Status; Option)
        {
            Caption = 'Status';
            //PRJ-1332.JS.1.0 03MAY2022 Change - Start
            //OptionCaption = 'Open,Invoiced,Accepted,Paid,Void,Invoice Posted';//PRJ-1332.GK.1.0 25Apr2022 Add new option
            //OptionMembers = Open,Invoiced,Accepted,Paid,Void,"Invoice Posted"; //PRJ-1332.GK.1.0 25Apr2022 Add new option
            OptionCaption = 'Open,Invoiced,Accepted,Paid,Void';
            OptionMembers = Open,Invoiced,Accepted,Paid,Void;
            //PRJ-1332.JS.1.0 03MAY2022 Change - end
            DataClassification = CustomerContent;


            trigger OnValidate();
            var
                ProgressBillNewDoc: Codeunit "NS_Progress BillingNewDocument";
                VersionNo: Integer;
            begin
                if (Rec.NS_Status = Rec.NS_Status::Void) and (xRec.NS_Status <> Rec.NS_Status) then begin
                    VersionNo := ProgressBillNewDoc.NS_NewVersion(Rec);
                    if VersionNo > 0 then
                        MESSAGE('A new version (' + FORMAT(VersionNo) + ' for this requisition has been created')
                    else
                        MESSAGE('A new version for this requisition was not able to b created');
                end;
            end;
        }
        field(21; "NS_Work Retention Percent"; Decimal)
        {
            Caption = 'Work Retention Percent';
            DataClassification = CustomerContent;
            //DecimalPlaces = 2 : 8;     //PRJ-980.MS.1.0  21Oct2021 //PRJ-1519.NK.1.0 15Jul2022 Block
            DecimalPlaces = 2 : 15; //PRJ-1519.NK.1.0 15Jul2022
            trigger OnValidate();
            begin
                if "NS_Work Retention Percent" <> xRec."NS_Work Retention Percent" then
                    if "NS_Manual Retention Amount" <> 0 then
                        ERROR(Text12);
            end;
        }
        field(22; "NS_Material Retention Percent"; Decimal)
        {
            Caption = 'Material Retention Percent';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 15; //PRJ-1519.NK.1.0 15Jul2022
            //PRJ-1519.NK.1.0 30Aug2022 Start
            trigger OnValidate()
            begin
                if "NS_Material Retention Percent" <> xRec."NS_Material Retention Percent" then
                    if "NS_Manual Stored Mat. Ret. Amt" <> 0 then
                        ERROR(Text13);
            end;
            //PRJ-1519.NK.1.0 30Aug2022 End
        }
        field(30; NS_Comment; Boolean)
        {
            CalcFormula = Exist("NS_Progress BillingCommentLine" WHERE("NS_No." = FIELD("NS_No."),
                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "NS_Line Work Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Work Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No."),
                                                                           "NS_Job No." = FIELD("NS_Job No. Filter"),
                                                                           "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                           "NS_Activity Code" = FIELD("NS_Activity Code Filter"),
                                                                           "NS_Process Code" = FIELD("NS_Process Code Filter"),
                                                                           "NS_Operation Code" = FIELD("NS_Operation Code Filter")));
            Caption = 'Line Work Amount';
            FieldClass = FlowField;
        }
        field(32; "NS_Line Material Amount"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Stored Materials Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                       "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                       "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Line Material Amount';
            FieldClass = FlowField;
        }
        field(37; "NS_Requisition Total"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Line Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                           "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                           "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Requisition Total';
            FieldClass = FlowField;
        }
        field(43; "NS_Effective Work Retention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Effective Work Retention" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                        "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                        "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Effective Work Retention';
            FieldClass = FlowField;
        }
        field(44; "NS_EffectiveMaterialRetention"; Decimal)
        {
            CalcFormula = Sum("NS_Progress Billing Line"."NS_EffectiveMaterialRetention" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
            Caption = 'Effective Material Retention';
            FieldClass = FlowField;
        }
        field(45; "NS_Total Retention"; Decimal)
        {
            Caption = 'Total Retention';
            DataClassification = CustomerContent;
        }
        field(49; "NS_Current Payment Due"; Decimal)
        {
            Caption = 'Current Payment Due';
            DataClassification = CustomerContent;
        }
        field(50; "NS_Sales Document Type"; Option)
        {
            Caption = 'Sales Document Type';
            OptionCaption = 'Order,Invoice,Credit';
            OptionMembers = "Order",Invoice,Credit;
            DataClassification = CustomerContent;
        }
        field(51; "NS_Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.';
            DataClassification = CustomerContent;
        }
        field(52; NS_Final; Boolean)
        {
            Caption = 'Final';
            DataClassification = CustomerContent;
        }
        field(55; "NS_Owner Contact Type"; Option)
        {
            Caption = 'Owner Contact Type';
            OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
            OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
            DataClassification = CustomerContent;
        }
        field(56; "NS_Owner Contact Code"; Code[10])
        {
            Caption = 'Owner Contact Code';
            TableRelation = "NS_Job Contact".NS_Code WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                      NS_Type = FIELD("NS_Owner Contact Type"));
            DataClassification = CustomerContent;
        }
        field(57; "NS_Arch Eng Contact Type"; Option)
        {
            Caption = 'Arch Eng Contact Type';
            InitValue = "Architect/Engineer";
            OptionCaption = 'Other,Owner,General Contractor,Architect/Engineer,Construction Manager,Job Manager,Job';
            OptionMembers = Other,Owner,"General Contractor","Architect/Engineer","Construction Manager","Job Manager",Job;
            DataClassification = CustomerContent;
        }
        field(58; "NS_Arch Eng Contact Code"; Code[10])
        {
            Caption = 'Arch Eng Contact Code';
            TableRelation = "NS_Job Contact".NS_Code WHERE("NS_Job No." = FIELD("NS_Job No."),
                                                      NS_Type = FIELD("NS_Arch Eng Contact Type"));
            DataClassification = CustomerContent;
        }
        field(60; "NS_Draw No."; Code[25])
        {
            Caption = 'Draw No.';
            DataClassification = CustomerContent;
            TableRelation = NS_Draw."NS_No." WHERE("NS_Job No." = FIELD("NS_Job No."),
                                              NS_Closed = CONST(false));
        }
        //CTSI-121.N.S.1.0 18Aug2020 Start
        field(61; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            FieldClass = FlowField;
            CalcFormula = lookup(Job.NS_Manager where("No." = field("NS_Job No.")));
            Editable = false;
        }
        field(62; "NS_Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Person Responsible" where("No." = field("NS_Job No.")));
            Editable = false;
        }
        //CTSI-121.N.S.1.0 18Aug2020 End
        field(500; "NS_Job No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
        }
        field(501; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';
            FieldClass = FlowFilter;
        }
        field(502; "NS_Activity Code Filter"; Code[10])
        {
            Caption = 'Activity Code Filter';
            FieldClass = FlowFilter;
        }
        field(503; "NS_Process Code Filter"; Code[10])
        {
            Caption = 'Process Code Filter';
            FieldClass = FlowFilter;
        }
        field(504; "NS_Operation Code Filter"; Code[10])
        {
            Caption = 'Operation Code Filter';
            FieldClass = FlowFilter;
        }
        //PRJ-688.AM.1.0
        field(505; "NS_Section Code Filter"; Code[10])
        {
            Caption = 'Section Code Filter';
            FieldClass = FlowFilter;
        }
        //PRJ-688.AM.1.0
        field(600; "NS_Round Amounts"; Boolean)
        {
            Caption = 'Round Amounts';
            DataClassification = CustomerContent;
        }
        field(601; "NS_Manual Retention Amount"; Decimal)
        {
            //Caption = 'Manual Retention Amount'; //PRJ-1519.NK.1.0 30Aug2022 Block
            Caption = 'Manual Work Retention Amount'; //PRJ-1519.NK.1.0 30Aug2022
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                ProgBillLine: Record "NS_Progress Billing Line"; //PRJ-1519.NK.1.0 16Jul2022
                TotRetAmt: Decimal; //PRJ-1519.NK.1.0 19Jul2022
            begin
                if "NS_Manual Retention Amount" = 0 then
                    if xRec."NS_Manual Retention Amount" <> 0 then begin
                        "NS_Work Retention Percent" := 0;
                        "NS_Material Retention Percent" := 0;
                    end;

                //PRJ-1519.NK.1.0 19Jul2022 Start
                TotRetAmt := 0;
                ProgBillLine.Reset();
                ProgBillLine.SetRange("NS_Job No.", Rec."NS_Job No.");
                ProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                ProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                ProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                IF ProgBillLine.FindSet() then
                    repeat
                        TotRetAmt += ProgBillLine.NS_Total;
                    until ProgBillLine.Next() = 0;
                //PRJ-1519.NK.1.0 19Jul2022 End

                if "NS_Manual Retention Amount" <> 0 then begin
                    CALCFIELDS("NS_Line Work Amount", "NS_Line Material Amount");
                    if "NS_Line Work Amount" + "NS_Line Material Amount" = 0 then
                        ERROR(Text11);
                    if CONFIRM(Text10) then begin
                        //if "NS_Line Work Amount" <> 0 then //PRJ-1519.NK.1.0 19Jul2022 Block
                        //"NS_Work Retention Percent" := "NS_Manual Retention Amount" / "NS_Line Work Amount" * 100; //PRJ-1519.NK.1.0 19Jul2022 Block
                        if TotRetAmt <> 0 then //PRJ-1519.NK.1.0 19Jul2022
                            "NS_Work Retention Percent" := "NS_Manual Retention Amount" / TotRetAmt * 100; //PRJ-1519.NK.1.0 19Jul2022
                                                                                                           //if "NS_Line Material Amount" <> 0 then //PRJ-1519.NK.1.0 30Aug2022 Block
                                                                                                           //  "NS_Material Retention Percent" := "NS_Manual Retention Amount" / "NS_Line Material Amount" * 100;//PRJ-1519.NK.1.0 30Aug2022 Block
                    end //else
                        //"NS_Manual Retention Amount" := 0; //PRJ-1519.NK.1.0 30Aug2022 Block
                end;
                //PRJ-1519.NK.1.0 16Jul2022 Start
                ProgBillLine.Reset();
                ProgBillLine.SetRange("NS_Job No.", Rec."NS_Job No.");
                ProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                ProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                ProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                IF ProgBillLine.FindSet() then
                    repeat
                        if ProgBillLine."NS_Work Amount" <> 0 then
                            ProgBillLine.validate("NS_Work Retention Percent", rec."NS_Work Retention Percent")
                        else
                            ProgBillLine.Validate("NS_Work Retention Percent", 0);
                        ProgBillLine.Modify();
                    until ProgBillLine.Next() = 0;
                //PRJ-1519.NK.1.0 15Jul2022 End 
            end;
        }
        field(602; "NS_No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }

        //PRJ-999.JS.1.0 09Nov2021-Start
        field(603; "NS_Global Dimension 1 Code"; Code[20])
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
        field(604; "NS_Global Dimension 2 Code"; Code[20])
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
        //PRJ-999.JS.1.0 09Nov2021-end 

        //PRJ-1332.GK.2.0 12May2022 start  
        field(481; "NS_Posted Sales Invoice No."; Code[20])
        {
            Caption = 'Posted Sales Invoice No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //PRJ-1332.GK.2.0 12May2022 end
        //PRJ-1519.NK.1.0 22Jul2022 Start
        field(483; "NS_Lines Total Retention Amt"; Decimal)
        {
            //Caption = 'Lines Total Retention Amount'; //PRJ-1519.NK.1.0 30Aug2022 Block
            Caption = 'Work Retention Amount'; //PRJ-1519.NK.1.0 30Aug2022
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Work Retention Amount" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
        }
        field(484; "NS_Manual Stored Mat. Ret. Amt"; Decimal)
        {
            Caption = 'Manual Stored Material Retention Amount';
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                ProgBillLine: Record "NS_Progress Billing Line";
                TotStoreRetAmt: Decimal;
            begin
                if NOT CONFIRM(Text10) then
                    exit;
                TotStoreRetAmt := 0;
                ProgBillLine.Reset();
                ProgBillLine.SetRange("NS_Job No.", Rec."NS_Job No.");
                ProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                ProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                ProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                IF ProgBillLine.FindSet() then
                    repeat
                        TotStoreRetAmt += ProgBillLine."NS_Stored Materials Amount";
                    until ProgBillLine.Next() = 0;
                if TotStoreRetAmt <> 0 then
                    "NS_Material Retention Percent" := "NS_Manual Stored Mat. Ret. Amt" / TotStoreRetAmt * 100
                else
                    "NS_Material Retention Percent" := 0;

                ProgBillLine.Reset();
                ProgBillLine.SetRange("NS_Job No.", Rec."NS_Job No.");
                ProgBillLine.SetRange("NS_Progress Billing No.", Rec."NS_No.");
                ProgBillLine.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                ProgBillLine.SetRange("NS_Version No.", Rec."NS_Version No.");
                IF ProgBillLine.FindSet() then
                    repeat
                        if ProgBillLine."NS_Stored Materials Amount" <> 0 then
                            ProgBillLine.validate("NS_Material Retention Percent", rec."NS_Material Retention Percent")
                        else
                            ProgBillLine.validate("NS_Material Retention Percent", 0);
                        ProgBillLine.Modify();
                    until ProgBillLine.Next() = 0;
            end;
        }
        field(485; "NS_Stored Material Ret. Amt"; Decimal)
        {
            Caption = 'Stored Material Retention Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Stored Mat. Retention Amt" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
        }
        //PRJ-1519.NK.1.0 22Jul2022 End
        //PRJ-1624.NK.1.0 22Sep2022 Start
        field(486; "NS_Multiple Retention on Lines"; Boolean)
        {
            Caption = 'Multiple Retention on Lines';
            DataClassification = CustomerContent;
            Description = 'Multiple Retention on Lines';
        }
        //PRJ-1624.NK.1.0 22Sep2022 End
        //PRJ-1632.RM.1.0 start
        field(487; "NS_Amount Due"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(488; "NS_Total Amt."; Decimal)
        {
            Caption = 'Total';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("NS_Progress Billing Line".NS_Total WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
        }
        //PRJ-1632.RM.1.0 end

        //PRJ-1648.PS.1.0 09OCT2022 - Start

        field(489; "NS_R_Reduction & Invoicing"; Boolean)
        {
            DataClassification = CustomerContent;

        }

        field(490; "NS_Lines Total Retention New"; Decimal)
        {

            Caption = 'Work Retention Amount New'; //PRJ-1648.PS.1.0 19Dec2022
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("NS_Progress Billing Line"."NS_Line Label Retetion" WHERE("NS_Progress Billing No." = FIELD("NS_No."),
                                                                                            "NS_Requisition No." = FIELD("NS_Requisition No."),
                                                                                            "NS_Version No." = FIELD("NS_Version No.")));
        }
        //PRJ-1648.PS.1.0 09OCT2022 - End

        //PE-22.JS.1.0 21FEB2023 - Start
        field(510; "NS_Invoiced Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoiced Currency Code';
            Description = 'Invoiced Currency Code';
            Editable = false;
        }
        //PE-22.JS.1.0 21FEB2023 - end

        //PE-53.RM.1.0 07March2023 Start
        field(491; "NS_Balance Due"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance Due';
        }

        field(492; "NS_Billed Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Billed Amount';
        }
        //PE-53.RM.1.0 07March2023 End

        //PE-211.AS start
        field(14021488; "NS_Field Manager"; Code[50])
        {
            Caption = 'Field Manager';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PE-211.AS end
        //PE-320.JS.1.0 04July2024-Start
        field(14021490; "NS_Disable Auto Post Cr. Memo"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Disable Auto Post Cr. Memo';

            trigger OnValidate()
            begin
                if rec."NS_Disable Auto Post Cr. Memo" = true then begin
                    if rec.NS_Status <> rec.NS_Status::Invoiced then
                        Error('Progress billing status should be invoiced.');
                end;
            end;

        }
        //PE-320.JS.1.0 04July2024-end 
    }

    keys
    {
        key(Key1; "NS_No.", "NS_Requisition No.", "NS_Version No.")
        {
        }
        key(Key2; "NS_No.", "NS_Period To", NS_Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
    begin
        ProgressBillingManagement.NS_ProgressBillDelete("NS_No.", "NS_Requisition No.", "NS_Version No.");
    end;

    trigger OnInsert();
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        Text001: Label 'There are already requisitions for this job.\\Use the new menu to make a new requisition or version.';
        jbrec: Record job;//PE-211.AS
        IsHandled: Boolean; //PE-255 AT.1.0 13Feb2024
    begin
        //PE-255 AT.1.0 13Feb2024 Start
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled);
        if IsHandled then
            exit;
        //PE-255 AT.1.0 13Feb2024 End
        if "NS_Job No." = '' then
            if GETFILTER("NS_Job No.") <> '' then
                // >> Upgrade
                // "NS_Job No." := GETFILTER("NS_Job No.");
                Validate("NS_Job No.", GETFILTER("NS_Job No."));
        // << Upgrade

        if "NS_No." = '' then begin
            JobsSetup.GET();
            JobsSetup.TESTFIELD("NS_Progress Billing Nos.");
            NoSeriesMgt.InitSeries(JobsSetup."NS_Progress Billing Nos.", xRec."NS_No. Series", 0D, "NS_No.", "NS_No. Series");
        end;

        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
        if ProgressBillingHeader.FINDFIRST() then
            ERROR(Text001)
        else begin
            "NS_Requisition No." := 1;
            "NS_Version No." := 0;
            if "NS_Job No." > '' then
                if Job.GET("NS_Job No.") then begin
                    "NS_Work Retention Percent" := Job."NS_Default Job Retention";
                    "NS_Material Retention Percent" := Job."NS_Default Job Retention";
                    //PRJ-999.JS.1.0 12Nov2021 - Start
                    "NS_Global Dimension 1 Code" := Job."Global Dimension 1 Code";
                    "NS_Global Dimension 2 Code" := Job."Global Dimension 2 Code";
                    "NS_Dimension Set ID" := GetDimensionNoFromJob("NS_Job No.");
                    //PRJ-999.JS.1.0 12Nov2021 - end  

                    //PE-211.AS start
                    "NS_Field Manager" := Job."NS_Field Manager";
                    //PE-211.AS end
                end;
        end;

        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec.get(Rec."NS_Job No.") then
                rec."NS_Field Manager" := jbrec."NS_Field Manager";
        //PE-211.AS end
    end;

    trigger OnModify();
    var
        jbrec1: record job;//PE-211.AS
    begin
        if xRec.NS_Status > NS_Status then
            ERROR(Text01);

        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec1.get(Rec."NS_Job No.") then
                rec."NS_Field Manager" := jbrec1."NS_Field Manager";
        //PE-211.AS end
    end;

    var
        JobsSetup: Record "Jobs Setup";
        GLSetup: Record "General Ledger Setup";
        Job: Record Job;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineRetention: Boolean;
        Text01: Label 'Status values cannot be set backwards.\\You must make a new version.';
        Text10: Label 'Have you completed the adjustments to the Progress Billing Lines?';
        Text11: Label 'The sum of the Work Amounts and Material Amounts on the lines cannot be 0.';
        Text12: Label 'You must set the Manual Retention Amount to 0 before changing the retention percent."';
        Text13: Label 'You must set the Manual Stored Material Retention Amount to 0 before changing the material retention percent."';
        Customer: Record Customer;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        JobDimensionNo: Integer;
        PBDocProcess: Codeunit "NS_Progress BillingMakeSaleDoc";
        DimMgt: Codeunit DimensionManagement;   //PRJ-999.JS.1.0 09Nov2021        
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingManagement: Codeunit "NS_Progress Billing Management";

    procedure NS_CalculateRequisition(var ProgressBillingHeader: Record "NS_Progress Billing Header");
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PreviousWork: Decimal;
    begin
        with ProgressBillingHeader do begin

            //Calculate all related progress billing lines
            ProgressBillingLine.RESET();
            ProgressBillingLine.SETRANGE("NS_Progress Billing No.", "NS_No.");
            ProgressBillingLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
            ProgressBillingLine.SETRANGE("NS_Version No.", "NS_Version No.");
            if ProgressBillingLine.FINDSET() then
                repeat
                    ProgressBillingLine.NS_LineCalculations(ProgressBillingLine);
                    ProgressBillingLine.MODIFY();
                until ProgressBillingLine.NEXT() = 0;

            //Update header fields
            CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
            "NS_Total Retention" := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            MODIFY;
        end;
    end;

    procedure NS_ProgressBillBaseAmount(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        Job: Record Job;
        BaseAmount: Decimal;
    begin
        //Returns the "Base Amount" total on the progress bill passed in.
        BaseAmount := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_No.");
            SETRANGE("NS_Requisition No.", Rec."NS_Requisition No.");
            SETRANGE("NS_Version No.", Rec."NS_Version No.");
            SetRange("NS_Change Order", false); //PE-142.NC.1.0 11Aug2023
            if FINDSET() then
                repeat
                    if "NS_Billing Method" > 0 then begin
                        Job.GET("NS_Job No.");
                        if not Job."NS_Progress Billing Sub-Level" then begin
                            if "NS_Billing Method" = "NS_Billing Method"::Unit then
                                BaseAmount := BaseAmount + ROUND("NS_Base Amount" * "NS_Contract Quantity", 0.01)
                            else
                                BaseAmount := BaseAmount + "NS_Base Amount";
                        end;
                    end;
                until NEXT() = 0;
        end;

        exit(BaseAmount);
    end;

    procedure NS_PreviousProgressBillRetention(Rec: Record "NS_Progress Billing Header"; JobNo: Code[20]; RevenueCategory: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]): Decimal;//PRJ-688.AM.1.0
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        PreviousRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the all previous progress bills.
        //This routine only looks at progress billing records, not sales records
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"

        PreviousRetention := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if JobNo > '' then
                SETFILTER("NS_Job No. Filter", JobNo);
            if RevenueCategory > '' then
                SETFILTER("NS_Revenue Category Filter", RevenueCategory);
            if ActivityCode > '' then
                SETFILTER("NS_Activity Code Filter", ActivityCode);
            if ProcessCode > '' then
                SETFILTER("NS_Process Code Filter", ProcessCode);
            if OperationCode > '' then
                SETFILTER("NS_Operation Code Filter", OperationCode);
            //PRJ-688.AM.1.0
            if SectionCode > '' then
                SetFilter("NS_Section Code Filter", SectionCode);
            //PRJ-688.AM.1.0
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
                PreviousRetention := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            end;
        end;

        exit(PreviousRetention);
    end;

    procedure NS_ProgressBillPreviousTotalEarn(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingLine: Record "NS_Progress Billing Line";
        PrevEarning: Decimal;
    begin
        //Returns the "Total Earnings" on an entire progress billing sequence up to Rec's requisition
        //  This is done by adding the "Line Work Amount" of all the previous requisitions
        PrevEarning := 0;
        if Rec."NS_Requisition No." > 1 then
            with ProgressBillingHeader do begin
                RESET();
                SETRANGE("NS_No.", Rec."NS_No.");
                SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
                SETFILTER(NS_Status, '<>%1', NS_Status::Void);
                if FINDSET() then
                    repeat
                        CALCFIELDS("NS_Line Work Amount");
                        PrevEarning := PrevEarning + "NS_Line Work Amount";
                    until NEXT() = 0;
            end;

        exit(PrevEarning);
    end;

    procedure NS_LastProgressBillRetention(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastRetention: Decimal;
    begin
        //Returns the "Retention Amount" on the previous progress bill
        //  "Retention Amount" is calculated as the sum of "Effective Work Retention" and "Effective Material Retention"
        LastRetention := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDLAST() then begin
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention");
                LastRetention := "NS_Effective Work Retention" + "NS_EffectiveMaterialRetention";
            end;
        end;

        exit(LastRetention);
    end;

    procedure NS_LastProgressBillStoredMat(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Line Material Amount" on the previous progress bill
        LastStoredMaterial := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDLAST() then begin
                CALCFIELDS("NS_Line Material Amount");
                LastStoredMaterial := "NS_Line Material Amount";
            end;
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_LastProgressBillStoredMatLine(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        LastStoredMaterial: Decimal;
    begin
        //Returns the "Stored Material Amount" on the previous progress bill line
        LastStoredMaterial := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastStoredMaterial := "NS_Stored Materials Amount";
        end;

        exit(LastStoredMaterial);
    end;

    procedure NS_LastProgressBillTCS(Rec: Record "NS_Progress Billing Line"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        LastLineTCS: Decimal;
    begin
        //Returns the "Total Completed and Stored" on the previous progress bill
        LastLineTCS := 0;
        with ProgressBillingLine do begin
            RESET();
            SETRANGE("NS_Progress Billing No.", Rec."NS_Progress Billing No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETRANGE("NS_Line No.", Rec."NS_Line No.");
            if FINDLAST() then
                LastLineTCS := "NS_Work Amount" + "NS_Stored Materials Amount" + NS_LastTotal(ProgressBillingLine);
        end;

        exit(LastLineTCS);
    end;

    procedure NS_ProgressBillPreviousInvoice(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastInvoiceAmount: Decimal;
        LineMaterialAmount1: Decimal;
        LineMaterialAmount2: Decimal;
    begin
        //Returns the value of the previous progress bill (Current Payment Due)
        //   This is done by adding all previous "Requisition Total"s and subtracting out only the
        //     previous "Effective Work Retention" and "Effective Material Retention".
        LastInvoiceAmount := 0;
        LineMaterialAmount1 := 0;
        LineMaterialAmount2 := 0;
        with ProgressBillingHeader do begin
            RESET();
            SETRANGE("NS_No.", Rec."NS_No.");
            SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
            SETFILTER(NS_Status, '<>%1', NS_Status::Void);
            if FINDSET() then begin
                repeat
                    CALCFIELDS("NS_Requisition Total", "NS_Line Material Amount");
                    LastInvoiceAmount := LastInvoiceAmount + "NS_Requisition Total";
                    LineMaterialAmount1 := LineMaterialAmount1 + LineMaterialAmount2;
                    LineMaterialAmount2 := "NS_Line Material Amount";
                until NEXT() = 0;
                CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Material Amount");
                LastInvoiceAmount := LastInvoiceAmount -
                                     "NS_Effective Work Retention" -
                                     "NS_EffectiveMaterialRetention" -
                                     LineMaterialAmount1;
            end;
        end;

        exit(LastInvoiceAmount);
    end;

    procedure NS_GetChangeOrderValues(JobNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        Job: Record Job;
    begin
        //Returns values of the change orders in a Job
        //   This is done by catagorizing "Budget Price" into four category values that are passed back.
        //     Additions have a positive budget value, deductions have a negative budget value.
        //     All Jobs to be accumulated must have a status of 'Order' or higher.
        //     Price budgets must have a type of 'Contract'.
        //     Values are considered 'Current' if the Job's "Contract Date" is between PeriodFrom and PeriodTo.
        //     Values are considered 'Previous' if the Job's "Contract Date" is before PeriodFrom.
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        Job.RESET();
        Job.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
        Job.SETRANGE("NS_Sub-Level to Job No.", JobNo);
        Job.SetRange("NS_Progress Billing Sub-Level", true);//PRJ-243 VT1.0 07-05-20
        if Job.FINDSET() then
            repeat

                if (Job."NS_Contract Date" > 0D) and
                   (Job.Status.AsInteger() >= Job.Status::Open.AsInteger()) and
                   (Job."NS_Contract Date" <= PeriodTo) then begin
                    Job.CALCFIELDS("NS_Budgeted Price (LCY)");
                    if Job."NS_Budgeted Price (LCY)" > 0 then
                        if (Job."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousAdditions := PreviousAdditions + Job."NS_Budgeted Price (LCY)"
                        else
                            CurrentAdditions := CurrentAdditions + Job."NS_Budgeted Price (LCY)"
                    else
                        if (Job."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousDeductions := PreviousDeductions - Job."NS_Budgeted Price (LCY)"
                        else
                            CurrentDeductions := CurrentDeductions - Job."NS_Budgeted Price (LCY)";
                end;


            until Job.NEXT() = 0;
    end;
    //PRJCTPR-208.NC.1.0 30Oct2023 Start
    procedure NS_GetChangeOrderValuesPL(JobNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        NSJob: Record Job;
        NSJobNumfilter: code[20];
        NSProgressBillingLines: Record "NS_Progress Billing Line";
        NSPreviousMonthStartDate: Date;
        NSPreviousMonthEndDate: Date;

    begin
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        NSPreviousMonthStartDate := 0D;
        NSPreviousMonthEndDate := 0D;
        NSPreviousMonthStartDate := CalcDate('-1M', rec."NS_Requisition Date");
        NSPreviousMonthEndDate := CalcDate('+CM', NSPreviousMonthStartDate);

        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '>%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            repeat
                NSJob.Reset();
                NSJob.SetRange("No.", NSProgressBillingLines."NS_Job No.");
                NSJob.SetRange("NS_Job Class", NSJob."NS_Job Class"::"Change Order");
                if NSJob.FindFirst() then begin
                    if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                        CurrentAdditions := CurrentAdditions + ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01)
                    else
                        CurrentAdditions := CurrentAdditions + NSProgressBillingLines."NS_Base Amount";
                end;
            until NSProgressBillingLines.NEXT() = 0;
        end;

        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '<%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            repeat
                NSJob.Reset();
                NSJob.SetRange("No.", NSProgressBillingLines."NS_Job No.");
                NSJob.SetRange("NS_Job Class", NSJob."NS_Job Class"::"Change Order");
                if NSJob.FindFirst() then begin
                    if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                        CurrentDeductions := CurrentDeductions + Abs(ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01))
                    else
                        CurrentDeductions := CurrentDeductions + Abs(NSProgressBillingLines."NS_Base Amount");
                end;
            until NSProgressBillingLines.NEXT() = 0;
        end;

        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '<%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '>%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            repeat
                NSJob.Reset();
                NSJob.SetRange("No.", NSProgressBillingLines."NS_Job No.");
                NSJob.SetRange("NS_Job Class", NSJob."NS_Job Class"::"Change Order");
                if NSJob.FindFirst() then begin
                    if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                        PreviousAdditions := PreviousAdditions + ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01)
                    else
                        PreviousAdditions := PreviousAdditions + NSProgressBillingLines."NS_Base Amount";
                end;
            until NSProgressBillingLines.NEXT() = 0;
        end;

        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '<%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '<%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            repeat
                NSJob.Reset();
                NSJob.SetRange("No.", NSProgressBillingLines."NS_Job No.");
                NSJob.SetRange("NS_Job Class", NSJob."NS_Job Class"::"Change Order");
                if NSJob.FindFirst() then begin
                    if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                        PreviousDeductions := PreviousDeductions + Abs(ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01))
                    else
                        PreviousDeductions := PreviousDeductions + Abs(NSProgressBillingLines."NS_Base Amount");
                end;
            until NSProgressBillingLines.NEXT() = 0;
        end;
    end;
    //PRJCTPR-208.NC.1.0 30Oct2023 End
    //PRJ-1648.PS.1.0 21Dec2022 Start 
    procedure NS_GetPeriodFromDate(ProgressBillingNo: Code[20]; PeriodTo: Date) PeriodFromDate: Date;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
    begin
        //Find the Period From date for a progress billing requisition.
        //   This is done by finding the "Period To" date on the previous requisition.
        PeriodFromDate := 0D;
        with ProgressBillingHeader do begin
            RESET();
            SETCURRENTKEY("NS_No.", "NS_Period To");
            SETRANGE("NS_No.", ProgressBillingNo);
            SETRANGE("NS_Period To", 0D, PeriodTo);
            SETFILTER(NS_Status, '<> Void');
            if FINDLAST() then
                if NEXT(-1) <> 0 then
                    PeriodFromDate := "NS_Period To";
        end;
    end;

    procedure NS_IsInvoiced(ProgBillHeader: Record "NS_Progress Billing Header"; ForwardBackward: Option Forward,Backward) ReturnCode: Integer;
    var
        PBHeader: Record "NS_Progress Billing Header";
    begin
        //Return Codes:
        //  0 : An unexpected error occured in processing
        //  1 : There is an invoiced requisition in the direction requested
        //  2 : There is no invoiced requisition in the direction requested
        //  3 : The starting Progress Billing requisition passed in does not exist
        ReturnCode := 0;
        if (ProgBillHeader."NS_No." = '') or (ProgBillHeader."NS_Requisition No." = 0) then
            ReturnCode := 3
        else
            with PBHeader do begin
                RESET();
                SETCURRENTKEY("NS_No.", "NS_Requisition No.", "NS_Version No.");
                SETRANGE("NS_No.", ProgBillHeader."NS_No.");
                SETRANGE("NS_Requisition No.", ProgBillHeader."NS_Requisition No.");
                if FINDFIRST() then begin
                    case ForwardBackward of
                        ForwardBackward::Forward:
                            SETRANGE("NS_Requisition No.", "NS_Requisition No." + 1);
                        ForwardBackward::Backward:
                            SETRANGE("NS_Requisition No.", "NS_Requisition No." - 1);
                    end;
                    SETRANGE("NS_Version No.");
                    if "NS_Requisition No." = 0 then
                        ReturnCode := 1
                    else
                        if FINDLAST() then begin
                            if (NS_Status >= 1) and (NS_Status <> 4) then//PRJ-1216.GK.1.0 Add
                                ReturnCode := 1
                            else
                                ReturnCode := 2;
                        end else begin
                            if ForwardBackward = ForwardBackward::Forward then
                                ReturnCode := 2
                            else
                                ReturnCode := 1;
                        end;
                end else
                    ReturnCode := 3;
            end;
    end;

    procedure NS_CopyCommentLines(BillingHeader: Record "NS_Progress Billing Header");
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        ProgressBillingCommentLine: Record "NS_Progress BillingCommentLine";
        ProgressBillingCommentLine2: Record "NS_Progress BillingCommentLine";
        LastLine: Integer;
    begin
        with BillingHeader do begin
            if "NS_No." > '' then begin
                //Get Last Comment Line of Current Progress Billing Header
                ProgressBillingCommentLine.RESET();
                ProgressBillingCommentLine.SETRANGE("NS_No.", "NS_No.");
                ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", "NS_Requisition No.");
                ProgressBillingCommentLine.SETRANGE("NS_Version No.", "NS_Version No.");
                if ProgressBillingCommentLine.FINDLAST() then
                    LastLine := ProgressBillingCommentLine."NS_Line No."
                else
                    LastLine := 0;

                ProgressBillingHeader.RESET();
                ProgressBillingHeader.SETRANGE("NS_No.", "NS_No.");
                if "NS_Requisition No." > 0 then
                    ProgressBillingHeader.SETRANGE("NS_Requisition No.", "NS_Requisition No." - 1)
                else
                    ProgressBillingHeader.SETRANGE("NS_Requisition No.", 0);
                if ProgressBillingHeader.FINDLAST() then begin
                    ProgressBillingCommentLine.RESET();
                    ProgressBillingCommentLine.SETRANGE("NS_No.", ProgressBillingHeader."NS_No.");
                    ProgressBillingCommentLine.SETRANGE("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
                    ProgressBillingCommentLine.SETRANGE("NS_Version No.", ProgressBillingHeader."NS_Version No.");
                    if ProgressBillingCommentLine.FINDSET() then
                        repeat
                            ProgressBillingCommentLine2.INIT();
                            ProgressBillingCommentLine2.TRANSFERFIELDS(ProgressBillingCommentLine);
                            ProgressBillingCommentLine2."NS_Requisition No." := "NS_Requisition No.";
                            ProgressBillingCommentLine2."NS_Version No." := "NS_Version No.";
                            LastLine := LastLine + 10000;
                            ProgressBillingCommentLine2."NS_Line No." := LastLine;
                            ProgressBillingCommentLine2.INSERT();
                        until ProgressBillingCommentLine.NEXT() = 0;
                end;
            end;
        end;
    end;

    procedure NS_GetJobForecast(BillingHeader: Record "NS_Progress Billing Header");
    var
        GetJobForecasts: Report "NS_Get Job Forecast";
    begin
        GetJobForecasts.SetJobLedgEntry(BillingHeader."NS_No.", BillingHeader."NS_Requisition No.", BillingHeader."NS_Version No.", BillingHeader."NS_Job No.");
        GetJobForecasts.RUNMODAL();
    end;

    procedure NS_JobTaskNoSeparatorCount(JobTaskNo: Code[35]) SepCount: Integer;
    var
        JobsSetup_Loc: Record "Jobs Setup";
        i: Integer;
    begin
        SepCount := 0;

        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        if JobsSetup_Loc."NS_APO Separators" > '' then
            for i := 1 to STRLEN(JobTaskNo) do begin
                if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then
                    SepCount := SepCount + 1;
            end;
    end;

    procedure NS_JobTaskNoToAPO(JobTaskNo: Code[35]; var ActivityCode: Code[10]; var ProcessCode: Code[10]; var OperationCode: Code[10]; var SectionCode: Code[10]);//PRJ-688.AM.1.0
    var
        JobsSetup_Loc: Record "Jobs Setup";
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
        SectionCode := '';//PRJ-688.AM.1.0
        Segment1 := '';
        Segment2 := '';
        Segment3 := '';
        Segment4 := '';

        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        case NS_JobTaskNoSeparatorCount(JobTaskNo) of
            0:
                Segment1 := COPYSTR(JobTaskNo, 1, 10);
            1:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin
                        Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                        Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, STRLEN(JobTaskNo) - i), 1, 10);
                        i := STRLEN(JobTaskNo);
                    end;
            2:
                for i := 1 to STRLEN(JobTaskNo) do
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin
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
                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 then begin

                        //Found the first separator.  Now look for the second starting from here.
                        for j := i + 1 to STRLEN(JobTaskNo) do
                            if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 then begin

                                //Found the second separator.  Now look for the third starting from here.
                                for k := j + 1 to STRLEN(JobTaskNo) do
                                    if STRPOS(JobsSetup_Loc."NS_APO Separators", COPYSTR(JobTaskNo, k, 1)) > 0 then begin
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
            SectionCode := Segment4;//PRJ-688.AM.1.0
        end else begin
            ActivityCode := Segment2;
            ProcessCode := Segment3;
            OperationCode := Segment4;
        end;
    end;

    procedure NS_APOToJobTaskNo(ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    var
        JobsSetup_Loc: Record "Jobs Setup";
    begin
        //This routine simply puts together the Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the second segment of the Job Task No. then you must use the JAPOtoJobTaskNo routine.

        JobTaskNo := '';
        if JobsSetup_Loc."NS_APO Separators" = '' then
            JobsSetup_Loc.GET();

        if ActivityCode > '' then begin
            JobTaskNo := ActivityCode;
            if ProcessCode > '' then begin
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + ProcessCode;
                if OperationCode > '' then begin
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + OperationCode;
                    if SectionCode > '' then //PRJ-688.AM.1.0
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup_Loc."NS_APO Separators", 1, 1) + SectionCode;
                end;//PRJ-688.AM.1.0
            end;
        end;
    end;

    procedure NS_JAPOToJobTaskNo(TaskNo: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    begin
        //This routine simply puts together the Job Task No., Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
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
                    if OperationCode > '' then Begin
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                        if SectionCode > '' then//PRJ-688.AM.1.0
                            JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + SectionCode;
                    end;//PRJ-688.AM.1.0
                end;
            end;
        end;
    end;

    procedure NS_GetDate(SalesHeader: Record "Sales Header"): Date;
    begin
        if SalesHeader."Posting Date" <> 0D then
            exit(SalesHeader."Posting Date");
        exit(WORKDATE);
    end;

    procedure NS_GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
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

    //PRJ-913.JS.1.0�13Sep2021-Start
    procedure NS_GetDimensionNoFromJobTask(JobNo: Code[20]; JobTaskNo: Code[20]) DimensionNo: Integer;
    var
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        JobTaskDimension: Record "Job Task Dimension";
        DimMgt: Codeunit DimensionManagement;

    begin
        DimensionNo := 0;
        JobTaskDimension.Reset();
        JobTaskDimension.SetRange("Job No.", JobNo);
        JobTaskDimension.SetRange("Job Task No.", JobTaskNo);
        if JobTaskDimension.FindSet() then
            repeat
                DimensionValue.RESET();
                DimensionValue.SETRANGE("Dimension Code", JobTaskDimension."Dimension Code");
                DimensionValue.SETRANGE(Code, JobTaskDimension."Dimension Value Code");
                if DimensionValue.FINDFIRST() then begin
                    DimensionSetEntryTemp.INIT();
                    DimensionSetEntryTemp."Dimension Code" := DimensionValue."Dimension Code";
                    DimensionSetEntryTemp."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    DimensionSetEntryTemp."Dimension Value Code" := DimensionValue.Code;
                    DimensionSetEntryTemp.INSERT();
                end;
            until JobTaskDimension.NEXT() = 0;
        DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
    end;
    //PRJ-913.JS.1.0�13Sep2021-end

    //PRJ-999.JS.1.0   09Nov2021 - Start
    procedure NS_ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"NS_Progress Billing Header", "NS_No.", FieldNumber, ShortcutDimCode);
        MODIFY();
    end;

    procedure NS_ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "NS_Dimension Set ID";
        "NS_Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "NS_Dimension Set ID", "NS_No.", "NS_Global Dimension 1 Code", "NS_Global Dimension 2 Code");
    end;

    procedure GetDimensionNoFromJob(JobNo: Code[20]) DimensionNo: Integer;
    var
        DefaultDimension: Record "Default Dimension";
        DimensionSetEntryTemp: Record "Dimension Set Entry" temporary;
        DimensionValue: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
    begin
        DimensionNo := 0;
        with DefaultDimension do begin
            DefaultDimension.RESET();
            DefaultDimension.SETRANGE("Table ID", DATABASE::Job);
            DefaultDimension.SETRANGE("No.", JobNo);
            if DefaultDimension.FINDSET() then
                repeat
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
            DimensionNo := DimMgt.GetDimensionSetID(DimensionSetEntryTemp);
        end;
    end;
    //PRJ-999.JS.1.0   09Nov2021 - end     

    //PRJ-1216.JS.1.0 03MAR2022 - Start
    procedure NS_ProgressBillPreviousInvoiceNew(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        PostesSalesInvHead: Record "Sales Invoice Header";
        PostedSalesInvLine: Record "Sales Invoice Line";
        NSCurrency: Record Currency;  //PE-22.JS.1.0 13FEB2023
        LastInvoiceAmount: Decimal;
        LineMaterialAmount1: Decimal;
        LineMaterialAmount2: Decimal;
        LineRetentionAmount: Decimal;
        LastInvoiceAmount2: Decimal;
        LineAmountIncludingTax: Decimal;
        TotalRetentionAmount: Decimal;
        SalsesCreditMemoHdr: record "Sales Cr.Memo Header";//PRJCTPR-274.AS.1.0
        TotalRetentionAmtSCM: Decimal;//PRJCTPR-274.AS.1.0
    begin
        //Returns the value of the previous progress bill (Current Payment Due)
        //   This is done by adding all previous "Requisition Total"s and subtracting out only the
        //     previous "Effective Work Retention" and "Effective Material Retention".
        LastInvoiceAmount := 0;
        LineMaterialAmount1 := 0;
        LineMaterialAmount2 := 0;
        LineRetentionAmount := 0;
        LastInvoiceAmount2 := 0;
        LineAmountIncludingTax := 0;
        TotalRetentionAmount := 0;
        TotalRetentionAmtSCM := 0;//PRJCTPR-274.AS.1.0

        //PRJ-1132.NK.1.0 Start
        //with ProgressBillingHeader do begin
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No.");
        ProgressBillingHeader.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingHeader.SETFILTER(NS_Status, '<>%1', ProgressBillingHeader.NS_Status::Void);
        if ProgressBillingHeader.FINDSET() then begin
            repeat
                ProgressBillingHeader.CALCFIELDS("NS_Requisition Total", "NS_Line Material Amount");
                //LastInvoiceAmount := LastInvoiceAmount + ProgressBillingHeader."NS_Requisition Total";
                //LineMaterialAmount1 := LineMaterialAmount1 + LineMaterialAmount2;
                //LineMaterialAmount2 := ProgressBillingHeader."NS_Line Material Amount";
                //LineRetentionAmount := LineRetentionAmount + ProgressBillingHeader."NS_Total Retention";
                if ProgressBillingHeader.NS_Status = ProgressBillingHeader.NS_Status::Invoiced then begin
                    //OR (ProgressBillingHeader.NS_Status = ProgressBillingHeader.NS_Status::"Invoice Posted") then begin //PRJ-1289.JS.1.0| Add OR new condition //PRJ-1332.JS.1.0 03MAR2022 comment or condition
                    PostesSalesInvHead.Reset();
                    // PostesSalesInvHead.SetRange("Pre-Assigned No.", ProgressBillingHeader."NS_Sales Document No.");//PE-15.PS.1.0 12Jan2023
                    PostesSalesInvHead.SetRange("NS_From ProgressBillingReq.No.", ProgressBillingHeader."NS_Requisition No."); //PE-15.PS.1.0 12Jan2023
                    PostesSalesInvHead.SetRange("NS_From Progress Billing No.", ProgressBillingHeader."NS_No."); //PE-15.PS.1.0 12Jan2023
                    PostesSalesInvHead.SetRange("NS_From ProgressBillingVer.No.", ProgressBillingHeader."NS_Version No.");//PE-15.PS.1.0 12Jan2023
                    if PostesSalesInvHead.FindSet() then begin //PE-15.PS.1.0 12Jan2023
                        repeat  //PE-15.PS.1.0 12Jan2023
                            if NSCurrency.get(PostesSalesInvHead."Currency Code") then;//PE-22.JS.1.0 14FEB2023 
                            PostedSalesInvLine.Reset();
                            PostedSalesInvLine.SetRange("Document No.", PostesSalesInvHead."No.");
                            PostedSalesInvLine.SetFilter("Line Amount", '<>%1', 0);
                            if PostedSalesInvLine.FindSet() then begin
                                //PRJ-1216.JS.2.0  25MAR2022- Start
                                PostedSalesInvLine.CalcSums("VAT Base Amount", "Line Amount");  //PRJ-1216.JS.2.0  25MAR2022- Start
                                                                                                //if PostedSalesInvLine."VAT Base Amount" <> 0 then
                                                                                                //    LastInvoiceAmount2 := LastInvoiceAmount2 + PostedSalesInvLine."VAT Base Amount"
                                                                                                //else
                                                                                                //PE-22.JS.1.0 14FEB2023 Start
                                if (PostesSalesInvHead."Currency Factor" <> 0) and (PostesSalesInvHead."Currency Code" <> '') then
                                    LineAmountIncludingTax := LineAmountIncludingTax + Round((PostedSalesInvLine."Line Amount" / PostesSalesInvHead."Currency Factor"), NSCurrency."Amount Rounding Precision")
                                else
                                    LineAmountIncludingTax := LineAmountIncludingTax + PostedSalesInvLine."Line Amount";
                                //PE-22.JS.1.0 14FEB2023 End
                                //LastInvoiceAmount2 := LastInvoiceAmount2 + PostedSalesInvLine."VAT Base Amount";
                            end;
                            //PRJ-1216.JS.4.0 28MAR2022
                            //PE-22.JS.1.0 14FEB2023 - start
                            if (PostesSalesInvHead."Currency Factor" <> 0) and (PostesSalesInvHead."Currency Code" <> '') then begin
                                if NSCurrency.get(PostesSalesInvHead."Currency Code") then;
                                if PostesSalesInvHead."NS_Retention Amount" <> 0 then
                                    TotalRetentionAmount := TotalRetentionAmount + Round((PostesSalesInvHead."NS_Retention Amount" / PostesSalesInvHead."Currency Factor"), NSCurrency."Amount Rounding Precision");
                            end else
                                //PE-22.JS.1.0 14FEB2023 - end
                                if PostesSalesInvHead."NS_Retention Amount" <> 0 then
                                    TotalRetentionAmount := TotalRetentionAmount + PostesSalesInvHead."NS_Retention Amount";
                        //if ((PostesSalesInvHead."NS_Retention Amount" <> 0) and (LineAmountIncludingTax <> 0)) then
                        //   LastInvoiceAmount2 := LineAmountIncludingTax - PostesSalesInvHead."NS_Retention Amount";
                        //PRJ-1216.JS.2.0 25MAR2022 - end    
                        Until PostesSalesInvHead.Next() = 0;   //PE-15.PS.1.0 12Jan2023
                    end
                    //PRJCTPR-274.AS.1.0 START
                    else
                        if NOT PostesSalesInvHead.FindSet() then begin
                            SalsesCreditMemoHdr.Reset();
                            SalsesCreditMemoHdr.SetRange("NS_From ProgressBillingReq.No.", ProgressBillingHeader."NS_Requisition No.");
                            SalsesCreditMemoHdr.SetRange("NS_From Progress Billing No.", ProgressBillingHeader."NS_No.");
                            SalsesCreditMemoHdr.SetRange("NS_From ProgressBillingVer.No.", ProgressBillingHeader."NS_Version No.");
                            if SalsesCreditMemoHdr.FindFirst() then begin
                                if SalsesCreditMemoHdr."NS_Retention Amount" <> 0 then
                                    TotalRetentionAmtSCM := TotalRetentionAmtSCM + SalsesCreditMemoHdr."NS_Retention Amount";
                            end;

                            LastInvoiceAmount := LastInvoiceAmount + ProgressBillingHeader."NS_Requisition Total";
                            LineRetentionAmount := LineRetentionAmount - TotalRetentionAmtSCM;
                        end
                        //PRJCTPR-274.AS.1.0 END
                        else begin
                            LastInvoiceAmount := LastInvoiceAmount + ProgressBillingHeader."NS_Requisition Total";
                            //LineMaterialAmount1 := LineMaterialAmount1 + LineMaterialAmount2;
                            //LineMaterialAmount2 := ProgressBillingHeader."NS_Line Material Amount";
                            LineRetentionAmount := LineRetentionAmount + ProgressBillingHeader."NS_Total Retention";
                        end;
                end;
                //PRJ-1216.JS.8.0 31MAR2022 - start
                if TotalRetentionAmount + LineRetentionAmount <> 0 then
                    LastInvoiceAmount2 := (LastInvoiceAmount + LineAmountIncludingTax) - (TotalRetentionAmount + LineRetentionAmount)
                else
                    LastInvoiceAmount2 := LineAmountIncludingTax + LastInvoiceAmount;
            //PRJ-1216.JS.8.0 31MAR2022 - end           
            //PRJ-1216.JS.4.0 28MAR2022     
            until ProgressBillingHeader.NEXT() = 0;
            ProgressBillingHeader.CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Material Amount");
            LastInvoiceAmount := LastInvoiceAmount -
                                 ProgressBillingHeader."NS_Effective Work Retention" -
                                 ProgressBillingHeader."NS_EffectiveMaterialRetention" -
                                 LineMaterialAmount1 - LineRetentionAmount;
        end;
        //end;
        //PRJ-1132.NK.1.0 End

        //exit(LastInvoiceAmount);
        exit(LastInvoiceAmount2);
    end;

    procedure NS_ProgressBillPreviousInvoiceNewOne(Rec: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastInvoiceAmount: Decimal;
        LineMaterialAmount1: Decimal;
        LineMaterialAmount2: Decimal;
        EffectiveWorkRetention: Decimal;   //PRJ-1216.JS.3.0 28MAR2022

    begin
        //Returns the value of the previous progress bill (Current Payment Due)
        //   This is done by adding all previous "Requisition Total"s and subtracting out only the
        //     previous "Effective Work Retention" and "Effective Material Retention".
        LastInvoiceAmount := 0;
        LineMaterialAmount1 := 0;
        LineMaterialAmount2 := 0;
        EffectiveWorkRetention := 0;  //PRJ-1216.JS.3.0 28MAR2022

        //PRJ-1132.NK.1.0 Start
        //with ProgressBillingHeader do begin
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", Rec."NS_No.");
        ProgressBillingHeader.SETFILTER("NS_Requisition No.", '<%1', Rec."NS_Requisition No.");
        ProgressBillingHeader.SETFILTER(NS_Status, '<>%1', ProgressBillingHeader.NS_Status::Void);
        if ProgressBillingHeader.FINDSET() then begin
            repeat
                ProgressBillingHeader.CALCFIELDS("NS_Requisition Total", "NS_Line Material Amount");
                LastInvoiceAmount := LastInvoiceAmount + ProgressBillingHeader."NS_Requisition Total";
                LineMaterialAmount1 := LineMaterialAmount1 + LineMaterialAmount2;
                LineMaterialAmount2 := ProgressBillingHeader."NS_Line Material Amount";
            until ProgressBillingHeader.NEXT() = 0;
            ProgressBillingHeader.CALCFIELDS("NS_Effective Work Retention", "NS_EffectiveMaterialRetention", "NS_Line Material Amount");

            //PRJ-1216.JS.3.0 28MAR2022 start
            IF ProgressBillingHeader."NS_Work Retention Percent" <> 0 then
                If ProgressBillingHeader."NS_Effective Work Retention" = 0 then
                    EffectiveWorkRetention := round((ProgressBillingHeader."NS_Requisition Total" * ProgressBillingHeader."NS_Work Retention Percent") / 100, 0.01, '=');


            // LastInvoiceAmount := LastInvoiceAmount -
            //                      ProgressBillingHeader."NS_Effective Work Retention" -
            //                      ProgressBillingHeader."NS_EffectiveMaterialRetention" -
            //                      LineMaterialAmount1;

            LastInvoiceAmount := LastInvoiceAmount -
                                 ProgressBillingHeader."NS_Effective Work Retention" -
                                 ProgressBillingHeader."NS_EffectiveMaterialRetention" -
                                 LineMaterialAmount1 - EffectiveWorkRetention;
            //PRJ-1216.JS.3.0 28MAR2022 end                                                       
        end;
        //end;
        //PRJ-1132.NK.1.0 End

        exit(LastInvoiceAmount);
    end;

    //PRJ-1216.JS.1.0 03MAR2022 - end      

    //PRJ-1708.JS.1.0 15DEC2022 - Start
    /// <summary>
    /// NS_GetChangeOrderValuesNew.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="PeriodFrom">Date.</param>
    /// <param name="PeriodTo">Date.</param>
    /// <param name="PreviousAdditions">VAR Decimal.</param>
    /// <param name="PreviousDeductions">VAR Decimal.</param>
    /// <param name="CurrentAdditions">VAR Decimal.</param>
    /// <param name="CurrentDeductions">VAR Decimal.</param>
    procedure NS_GetChangeOrderValuesNew(JobNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        NSJob: Record Job;
        NSJobNumfilter: code[20];
    begin
        //Returns values of the change orders in a Job
        //   This is done by catagorizing "Budget Price" into four category values that are passed back.
        //     Additions have a positive budget value, deductions have a negative budget value.
        //     All Jobs to be accumulated must have a status of 'Order' or higher.
        //     Price budgets must have a type of 'Contract'.
        //     Values are considered 'Current' if the Job's "Contract Date" is between PeriodFrom and PeriodTo.
        //     Values are considered 'Previous' if the Job's "Contract Date" is before PeriodFrom.
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;

        NSJobNumfilter := '';
        NSJobNumfilter := '*' + format(JobNo) + '*';
        NSJob.RESET();
        NSJob.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
        NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', NSJobNumfilter);
        NSJob.SetRange("NS_Progress Billing Sub-Level", true);
        if NSJob.FINDSET() then
            repeat
                if (NSJob."NS_Contract Date" > 0D) and
                   (NSJob.Status.AsInteger() >= NSJob.Status::Open.AsInteger()) and
                   (NSJob."NS_Contract Date" <= PeriodTo) then begin
                    NSJob.CALCFIELDS("NS_Budgeted Price (LCY)");
                    if NSJob."NS_Budgeted Price (LCY)" > 0 then
                        if (NSJob."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousAdditions := PreviousAdditions + NSJob."NS_Budgeted Price (LCY)"
                        else
                            CurrentAdditions := CurrentAdditions + NSJob."NS_Budgeted Price (LCY)"
                    else
                        if (NSJob."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
                            PreviousDeductions := PreviousDeductions - NSJob."NS_Budgeted Price (LCY)"
                        else
                            CurrentDeductions := CurrentDeductions - NSJob."NS_Budgeted Price (LCY)";
                end;
            until NSJob.NEXT() = 0;
    end;

    /// <summary>
    /// NS_GetChangeOrderValuesBasedonPBLines.
    /// </summary>
    /// <param name="JobNo">Code[20].</param>
    /// <param name="PeriodFrom">Date.</param>
    /// <param name="PeriodTo">Date.</param>
    /// <param name="PreviousAdditions">VAR Decimal.</param>
    /// <param name="PreviousDeductions">VAR Decimal.</param>
    /// <param name="CurrentAdditions">VAR Decimal.</param>
    /// <param name="CurrentDeductions">VAR Decimal.</param>
    procedure NS_GetChangeOrderValuesBasedonPBLines(JobNo: Code[20]; PeriodFrom: Date; PeriodTo: Date; var PreviousAdditions: Decimal; var PreviousDeductions: Decimal; var CurrentAdditions: Decimal; var CurrentDeductions: Decimal);
    var
        NSJob: Record Job;
        NSJobNumfilter: code[20];
        NSProgressBillingLines: Record "NS_Progress Billing Line";
        NSPreviousMonthStartDate: Date;
        NSPreviousMonthEndDate: Date;

    begin
        //Returns values of the change orders in a Job
        //   This is done by catagorizing "Budget Price" into four category values that are passed back.
        //     Additions have a positive budget value, deductions have a negative budget value.
        //     All Jobs to be accumulated must have a status of 'Order' or higher.
        //     Price budgets must have a type of 'Contract'.
        //     Values are considered 'Current' if the Job's "Contract Date" is between PeriodFrom and PeriodTo.
        //     Values are considered 'Previous' if the Job's "Contract Date" is before PeriodFrom.
        PreviousAdditions := 0;
        PreviousDeductions := 0;
        CurrentAdditions := 0;
        CurrentDeductions := 0;
        NSPreviousMonthStartDate := 0D;
        NSPreviousMonthEndDate := 0D;
        NSPreviousMonthStartDate := CalcDate('-1M', rec."NS_Requisition Date");
        NSPreviousMonthEndDate := CalcDate('+CM', NSPreviousMonthStartDate);

        //Goto progress billing line Currenct additions
        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '>%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            //NSProgressBillingLines.CalcSums("NS_Base Amount"); //PRJCTPR-208.NC.1.0 26Oct2023 Block
            //CurrentAdditions := NSProgressBillingLines."NS_Base Amount"; //PRJCTPR-208.NC.1.0 26Oct2023 Block
            //PRJCTPR-208.NC.1.0 26Oct2023 Start
            repeat
                if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                    CurrentAdditions := CurrentAdditions + ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01)
                else
                    CurrentAdditions := CurrentAdditions + NSProgressBillingLines."NS_Base Amount";
            until NSProgressBillingLines.NEXT() = 0;
            //PRJCTPR-208.NC.1.0 26Oct2023 End
        end;

        //Goto progress billing line Currenct deductions
        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '<%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            //NSProgressBillingLines.CalcSums("NS_Base Amount"); //PRJCTPR-208.NC.1.0 26Oct2023 Block
            //CurrentDeductions := ABS(NSProgressBillingLines."NS_Base Amount"); //PRJCTPR-208.NC.1.0 26Oct2023 Block
            //PRJCTPR-208.NC.1.0 26Oct2023 Start
            repeat
                if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                    CurrentDeductions := CurrentDeductions + Abs(ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01))
                else
                    CurrentDeductions := CurrentDeductions + Abs(NSProgressBillingLines."NS_Base Amount");
            until NSProgressBillingLines.NEXT() = 0;
            //PRJCTPR-208.NC.1.0 26Oct2023 End
        end;

        //Goto progress billing line Previous months addition
        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '<%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '>%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            //NSProgressBillingLines.CalcSums("NS_Base Amount"); //PRJCTPR-208.NC.1.0 16Oct2023 Block
            //PreviousAdditions := NSProgressBillingLines."NS_Base Amount"; //PRJCTPR-208.NC.1.0 16Oct2023 Block
            //PRJCTPR-208.NC.1.0 16Oct2023 Start
            repeat
                if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                    PreviousAdditions := PreviousAdditions + ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01)
                else
                    PreviousAdditions := PreviousAdditions + NSProgressBillingLines."NS_Base Amount";
            until NSProgressBillingLines.NEXT() = 0;
            //PRJCTPR-208.NC.1.0 16Oct2023 End
        end;

        //Goto progress billing line Previous months deduction
        NSProgressBillingLines.Reset();
        NSProgressBillingLines.Setrange("NS_Progress Billing No.", Rec."NS_No.");
        NSProgressBillingLines.setrange("NS_Requisition No.", rec."NS_Requisition No.");
        NSProgressBillingLines.setrange("NS_Version No.", rec."NS_Version No.");
        NSProgressBillingLines.Setrange("NS_Change Order", true);
        NSProgressBillingLines.setfilter("NS_Contract Forecast Date", '<%1', rec."NS_Period To");
        NSProgressBillingLines.setfilter("NS_Base Amount", '<%1', 0);
        if NSProgressBillingLines.FindSet() then begin
            //NSProgressBillingLines.CalcSums("NS_Base Amount"); //PRJCTPR-208.NC.1.0 16Oct2023 Block
            //PreviousDeductions := ABS(NSProgressBillingLines."NS_Base Amount");  //PRJCTPR-208.NC.1.0 16Oct2023 Block
            //PRJCTPR-208.NC.1.0 16Oct2023 Start
            repeat
                if NSProgressBillingLines."NS_Billing Method" = NSProgressBillingLines."NS_Billing Method"::Unit then
                    PreviousDeductions := PreviousDeductions + Abs(ROUND(NSProgressBillingLines."NS_Base Amount" * NSProgressBillingLines."NS_Contract Quantity", 0.01))
                else
                    PreviousDeductions := PreviousDeductions + Abs(NSProgressBillingLines."NS_Base Amount");
            until NSProgressBillingLines.NEXT() = 0;
            //PRJCTPR-208.NC.1.0 16Oct2023 End
        end;

        // NSJobNumfilter := '';
        // NSJobNumfilter := '*' + format(JobNo) + '*';
        // NSJob.RESET();
        // NSJob.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
        // NSJob.SetFilter("NS_Sub-Level to Job No.", '%1', NSJobNumfilter);
        // NSJob.SetRange("NS_Progress Billing Sub-Level", true);
        // if NSJob.FINDSET() then
        //     repeat
        //         if (NSJob."NS_Contract Date" > 0D) and
        //            (NSJob.Status.AsInteger() >= NSJob.Status::Open.AsInteger()) and
        //            (NSJob."NS_Contract Date" <= PeriodTo) then begin
        //             NSJob.CALCFIELDS("NS_Budgeted Price (LCY)");
        //             if NSJob."NS_Budgeted Price (LCY)" > 0 then
        //                 if (NSJob."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
        //                     PreviousAdditions := PreviousAdditions + NSJob."NS_Budgeted Price (LCY)"
        //                 else
        //                     CurrentAdditions := CurrentAdditions + NSJob."NS_Budgeted Price (LCY)"
        //             else
        //                 if (NSJob."NS_Contract Date" <= PeriodFrom) and (PeriodFrom > 0D) then
        //                     PreviousDeductions := PreviousDeductions - NSJob."NS_Budgeted Price (LCY)"
        //                 else
        //                     CurrentDeductions := CurrentDeductions - NSJob."NS_Budgeted Price (LCY)";
        //         end;
        //     until NSJob.NEXT() = 0;
    end;
    //PRJ-1708.JS.1.0 15DEC2022 - end 


    //PRJ-1648.PS.1.0 21Dec2022 Start 

    procedure NS_LastRetentionTotalInvoice(P_ProgressBillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        LastRetentiontotalAmount: Decimal;
        ProgressBillingLine: Record "NS_Progress Billing Line";

    begin
        LastRetentiontotalAmount := 0;
        ProgressBillingHeader.RESET();
        ProgressBillingHeader.SETRANGE("NS_No.", P_ProgressBillingHeader."NS_No.");
        ProgressBillingHeader.SETFILTER("NS_Requisition No.", '<%1', P_ProgressBillingHeader."NS_Requisition No.");
        ProgressBillingHeader.SETFILTER(NS_Status, '<>%1', ProgressBillingHeader.NS_Status::Void);
        if ProgressBillingHeader.FINDLAST() then begin
            ProgressBillingLine.Reset();
            ProgressBillingLine.SetRange("NS_Progress Billing No.", ProgressBillingHeader."NS_No.");
            ProgressBillingLine.SetRange("NS_Requisition No.", ProgressBillingHeader."NS_Requisition No.");
            ProgressBillingLine.SetRange("NS_Version No.", ProgressBillingHeader."NS_Version No.");
            if ProgressBillingLine.FindSet() then begin
                repeat
                    LastRetentiontotalAmount += ProgressBillingLine."NS_Work Ret Amt Reduction";
                until ProgressBillingLine.Next = 0;
            end;
        end;
        exit(LastRetentiontotalAmount);
    end;


    procedure NS_CurrentRetentionTotalInvoice(P_ProgressBillingHeader: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        CurrentRettotalAmt: Decimal;
        ProgressBillingLine: Record "NS_Progress Billing Line";

    begin
        CurrentRettotalAmt := 0;
        ProgressBillingLine.Reset();
        ProgressBillingLine.SetRange("NS_Progress Billing No.", P_ProgressBillingHeader."NS_No.");
        ProgressBillingLine.SetRange("NS_Requisition No.", P_ProgressBillingHeader."NS_Requisition No.");
        ProgressBillingLine.SetRange("NS_Version No.", P_ProgressBillingHeader."NS_Version No.");
        if ProgressBillingLine.FindSet() then begin
            repeat
                CurrentRettotalAmt += ProgressBillingLine."NS_Work Ret Amt Reduction";
            until ProgressBillingLine.Next = 0;
        end;
        exit(CurrentRettotalAmt);
    end;
    //PRJ-1648.PS.1.0 21Dec2022 End 
    //PRJCTPR-208.NC.1.0 27Oct2023 Start   
    procedure NS_RequisitionTotal(Reco: Record "NS_Progress Billing Header"): Decimal;
    var
        ProgressBillingLine: Record "NS_Progress Billing Line";
        ProgressBillingHeader: Record "NS_Progress Billing Header";
        RecJob: Record Job;
        TotReqAmt: Decimal;

    begin
        TotReqAmt := 0;
        ProgressBillingLine.RESET();
        ProgressBillingLine.SETRANGE("NS_Progress Billing No.", Reco."NS_No.");
        ProgressBillingLine.SETRANGE("NS_Requisition No.", Reco."NS_Requisition No.");
        ProgressBillingLine.SETRANGE("NS_Version No.", Reco."NS_Version No.");
        if ProgressBillingLine.FINDSET() then
            repeat
                ProgressBillingHeader.GET(ProgressBillingLine."NS_Progress Billing No.", ProgressBillingLine."NS_Requisition No.", ProgressBillingLine."NS_Version No.");
                if ProgressBillingHeader.NS_Status <> ProgressBillingHeader.NS_Status::Void then begin
                    RecJob.Reset();
                    RecJob.SetRange("No.", ProgressBillingLine."NS_Job No.");
                    RecJob.SetFilter("NS_Job Class", '<>%1', RecJob."NS_Job Class"::"Change Order");
                    if RecJob.FindFirst() then begin
                        if ProgressBillingLine."NS_Change Order" then
                            TotReqAmt := TotReqAmt
                        else
                            //TotReqAmt := TotReqAmt + ProgressBillingLine."NS_Work Amount"; //PRJCTPR-384.JS.1.0 line commented 08Apr2024
                            TotReqAmt := TotReqAmt + ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount"; //PRJCTPR-384.JS.1.0 08Apr2024 line added
                    end else
                        //TotReqAmt := TotReqAmt + ProgressBillingLine."NS_Work Amount";  //PRJCTPR-384.JS.1.0 line commented 08Apr2024
                            TotReqAmt := TotReqAmt + ProgressBillingLine."NS_Work Amount" + ProgressBillingLine."NS_Stored Materials Amount"; //PRJCTPR-384.JS.1.0 08Apr2024 line added
                end;
            until ProgressBillingLine.NEXT() = 0;

        exit(TotReqAmt);
    end;
    //PRJCTPR-208.NC.1.0 27Oct2023 End
    //PE-255 AT.1.0 13Feb2024 Start
    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var NS_ProgressBillingHeader: Record "NS_Progress Billing Header"; var IsHandled: Boolean)
    begin
    end;
    //PE-255 AT.1.0 13Feb2024 End
}

