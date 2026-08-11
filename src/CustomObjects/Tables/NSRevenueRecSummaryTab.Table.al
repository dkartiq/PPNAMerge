table 14021193 NS_RevenueRecSummaryTab
{
    //CTSI-274.AM.1.0 Added New Table 
    //PRJ-1041.AS.1.0 Added Dimension SetID field and function to attach Dimensions of Job
    //FGH-16.SK.1.0 | 13JAN2022 | Added field and code to support Rev Rec customisation
    //PRJ-1159.JS.1.0 21JAN2022 | add key
    //PRJ-1098.NK.0.0 11Feb2022 |Add Two Fields
    //PRJ-1413.NK.0.0 23May2022 | Add Entry type Option
    //PRJ-1463.NK.0.0 17Jun2022 | Add Two Fields
    //PE-174.AS.1.0 16NOV2023 Add 4 fields
    DataClassification = ToBeClassified;
    Caption = 'Revenue Recognition Summary Details';
    LookupPageId = NS_RevenueRecognitionSummary;
    DrillDownPageId = NS_RevenueRecognitionSummary;

    fields
    {
        field(1; "NS_Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "NS_Posting Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(3; "NS_Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Finance,JFW,Batch; //PRJ-1413.NK.0.0 23May2022
            OptionCaption = 'Finance,JFW,Batch'; //PRJ-1413.NK.0.0 23May2022
            //PRJ-1413.NK.0.0 23May2022 Start
            trigger OnValidate()
            begin
                if NS_EntryFromBatchJob then
                    if "NS_Entry Type" <> "NS_Entry Type"::Batch then
                        Error('Sorry! You can not change Entry Type.');
            end;
            //PRJ-1413.NK.0.0 23May2022 End
        }
        field(4; "NS_Job No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Job; //PRJ-1383.GK.1.0 02June2022
        }
        field(5; "NS_Job Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "NS_Current Contract"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "NS_Current(TCE) Est. Cost at Completion"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "NS_Actual Costs To Date"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "NS_Period Costs"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "NS_POC %"; Decimal)
        {
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 5;
        }
        field(11; "NS_Current GM %"; Decimal)
        {
            DataClassification = CustomerContent;
            //DecimalPlaces = 0 : 5;
        }
        field(12; "NS_Gross Revenue"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "NS_Gross Profit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "NS_Net Revenue"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(15; "NS_Net Profit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "NS_Posted"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        // field(17; "True-Up Posted"; Boolean)
        // {
        //     DataClassification = CustomerContent;
        // } //CTSI-286 rollback

        field(18; NS_Voided; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(19; "NS_Gen.Doc.No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Gen. Document No.';
        }
        // field(20; TrueupDoc; boolean)
        // {
        //     DataClassification = CustomerContent;
        // } //CTSI-286 rollback
        field(21; NS_CheckBool; boolean)
        {
            DataClassification = CustomerContent;
        }
        field(24; "NS_Stat. Cont. GM (As of)"; Decimal)
        {
            DataClassification = CustomerContent;//Statistics page calculations
        }
        field(25; "NS_Stat. GM% (As of)"; Decimal)//Statistics page calculations
        {
            DataClassification = CustomerContent;
        }
        field(26; "NS_True-Up Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'CTSI-286.MS.1.0';
        }
        field(27; "NS_Billings to Date"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Billings to Date';
        }
        field(28; "NS_Under Billings"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Under Billings';
        }
        field(29; "NS_Over Billings"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Over Billings';
        }
        field(30; "NS_Over/Under Billings Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Over/Under Billings Posted';
        }
        field(31; "NS_Billing Amt. Posted"; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'PRJ-830.MS.1.0';
            Caption = 'Billing Amt. Posted';
        }

        field(32; "NS_Global Dimension 1 Code"; Code[20])//PRJ-950.AS.1.0 ADD FIELD
        {
            //CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(33; "NS_Global Dimension 2 Code"; Code[20])//PRJ-950.AS.1.0 ADD FIELD
        {
            //CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        //PRJ-1041.AS.1.0 START
        field(34; "NS_Dimension Set ID"; Integer)
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
        //PRJ-1041.AS.1.0 END
        //FGH-16.SK.1.0 Start
        field(35; "NS_POC Method"; Enum NS_POCMethod)
        {
            DataClassification = CustomerContent;
        }
        //FGH-16.SK.1.0 End
        //PRJ-1098.NK.0.0 18Feb2022 Start
        field(36; NS_EntryFromBatchJob; Boolean)
        {
            Caption = 'Entry from Batch Job';
            DataClassification = CustomerContent;
            Description = 'Entry From Batch Job';
            Editable = false;
        }
        field(37; NS_JFWBatchDocumentNo; Code[20])
        {
            Caption = 'JFW Batch Document No.';
            DataClassification = CustomerContent;
            Description = 'JFW Batch Document No.';
            Editable = false;
        }
        //PRJ-1098.NK.0.0 18Feb2022 Start
        field(38; NS_UpdateFromBatchJob; Boolean)
        {
            Caption = 'Update from Batch Job';
            DataClassification = CustomerContent;
            Description = 'Update From Batch Job';
            Editable = false;
        }
        //PRJ-1098.NK.0.0 18Feb2022 End
        //PRJ-1098.NK.0.0 19May2022 Start
        field(39; "NS_JobTarget%"; Decimal)
        {
            Caption = 'Job Target %" ';
            DataClassification = CustomerContent;
            Description = 'Job Target %" ';
            Editable = false;
        }
        //PRJ-1098.NK.0.0 19May2022 End
        //PRJ-1463.NK.0.0 17Jun2022 Start
        field(40; "NS_EstMarkup%"; Decimal)
        {
            Caption = 'Est. Markup % ';
            DataClassification = CustomerContent;
            Description = 'Est. Markup % ';
            Editable = false;
        }
        field(41; "NS_EstGrossProfit%"; Decimal)
        {
            Caption = 'Est. Gross Profit % ';
            DataClassification = CustomerContent;
            Description = 'Est. Gross Profit % ';
            Editable = false;
        }
        //PRJ-1463.NK.0.0 17Jun2022 End

        //PE-136.JS.1.0 03Aug2023 - Start
        field(45; "NS_Reversed Gen. Posted"; boolean)
        {
            caption = 'Reversed Gen. Posted';
            DataClassification = CustomerContent;
            editable = false;
        }
        field(46; "NS_GenJnl Posted Doc. No."; code[20])
        {
            caption = 'Gen. Jnl. Posted Document No.';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-136.JS.1.0 03Aug2023 - end
        //PE-174.AS.1.0 16NOV2023 START
        field(47; "NS_TCE Override"; boolean)
        {
            caption = 'TCE Over-ride';
            DataClassification = CustomerContent;
            editable = TRUE;
            //PE-174.JS.1.0 06FEB2023 - Start
            trigger OnValidate()
            begin
                if rec."NS_Over/Under Billings Posted" = true then
                    error('The Over/Under Billings have been posted for this line, hence TCE cannot be overridden for this entry.')
            end;
            //PE-174.JS.1.0 06FEB2023 - end

        }
        field(48; "NS_Ref No."; Integer)
        {
            Caption = 'Ref No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(49; "NS_New TCE Ref"; Integer)
        {
            Caption = 'New TCE Ref';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; "NS_TCE Over-ridden"; boolean)
        {
            caption = 'TCE Over-ridden';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-174.AS.1.0 16NOV2023 END

        //PE-174.AS.4.0 22NOV2023 start
        field(51; "NS_PrevEntry Type"; Option)
        {
            Caption = 'Previous Entry Type';
            DataClassification = CustomerContent;
            OptionMembers = "",Finance,JFW,Batch;
            OptionCaption = '",Finance,JFW,Batch';
            Editable = false;
        }
        //PE-174.AS.4.0 22NOV2023 end

        //PE-281.JS.1.0 11Apr2024 - Start
        field(52; "NS_Mark POC Method Update"; boolean)
        {
            caption = 'Mark for POC Method Update';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-281.JS.1.0 11Apr2024 - end        
    }

    keys
    {
        key(Key1; "NS_Entry No.")
        {
            Clustered = true;
        }
        key(key2; "NS_Job No.", "NS_Posting Date")     //PRJ-1159.JS.1.0 21JAN2022
        {

        }
    }

    var
        DimMgt: Codeunit DimensionManagement;//PRJ-1041.AS.1.0 
        myInt: Integer;

    trigger OnInsert()
    var
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        //PE-281.JS.1.0 11Apr2023 - Start
        if (rec.NS_Posted = true) or (rec."NS_Over/Under Billings Posted" = true) then
            error('You are not allowed to delete posted entries.');
        //PE-281.JS.1.0 11Apr2023 - end    
    end;

    trigger OnRename()
    begin

    end;

    //PRJ-1041.AS.1.0 START
    procedure NS_ShowDocDim();
    var
        OldDimSetID: Integer;
        textno: Text;
    begin
        OldDimSetID := "NS_Dimension Set ID";
        "NS_Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "NS_Dimension Set ID", Format("NS_Entry No."), "NS_Global Dimension 1 Code", "NS_Global Dimension 2 Code");
    end;
    //PRJ-1041.AS.1.0 END

    //PRJ-1041.AS.1.0 START
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
    //PRJ-1041.AS.1.0 END

    //PE-174.AS.1.0 16NOV2023 START
    procedure NS_CopyRevRecLinesForOverRide(SourceRevRecTble: Record NS_RevenueRecSummaryTab)
    var
        RevRecSummRecord: Record NS_RevenueRecSummaryTab;
        TargetRevRecSummRecord: Record NS_RevenueRecSummaryTab;
        SourceRevRecTbleCopy: Record NS_RevenueRecSummaryTab;
    begin
        if SourceRevRecTble."NS_POC Method" = SourceRevRecTble."NS_POC Method"::"NS_Job forecast" then begin   //PE-174.JS.1.0 31JAN2024 line added
            RevRecSummRecord.Reset();
            RevRecSummRecord.SetCurrentKey("NS_Entry No.");
            RevRecSummRecord.SetFilter("NS_Entry No.", '<>%1', 0);
            if RevRecSummRecord.FindLast() then begin
                TargetRevRecSummRecord.Init();
                TargetRevRecSummRecord."NS_Entry No." := RevRecSummRecord."NS_Entry No." + 1;
                TargetRevRecSummRecord.TransferFields(SourceRevRecTble, false);
                TargetRevRecSummRecord."NS_Entry Type" := TargetRevRecSummRecord."NS_Entry Type"::Finance;
                TargetRevRecSummRecord."NS_Ref No." := SourceRevRecTble."NS_Entry No.";
                TargetRevRecSummRecord."NS_TCE Over-ridden" := true;
                TargetRevRecSummRecord."NS_TCE Override" := false;
                TargetRevRecSummRecord."NS_New TCE Ref" := 0;
                TargetRevRecSummRecord."NS_Period Costs" := SourceRevRecTble."NS_Period Costs";
                TargetRevRecSummRecord."NS_Actual Costs To Date" := SourceRevRecTble."NS_Actual Costs To Date";
                TargetRevRecSummRecord.Insert(true);

                SourceRevRecTbleCopy.Reset();
                SourceRevRecTbleCopy.SetRange("NS_Entry No.", SourceRevRecTble."NS_Entry No.");
                if SourceRevRecTbleCopy.FindFirst() then begin
                    SourceRevRecTbleCopy."NS_New TCE Ref" := TargetRevRecSummRecord."NS_Entry No.";
                    SourceRevRecTbleCopy."NS_TCE Override" := true;
                    SourceRevRecTbleCopy."NS_TCE Over-ridden" := false;
                    SourceRevRecTbleCopy.Modify(true);
                end;
            end;
        end;   //PE-174.JS.1.0 31JAN2024 line added
        //PE-174.JS.1.0 31JAN2024 start
        if SourceRevRecTble."NS_POC Method" = SourceRevRecTble."NS_POC Method"::NS_BudgettoActualCost then begin
            RevRecSummRecord.Reset();
            RevRecSummRecord.SetCurrentKey("NS_Entry No.");
            RevRecSummRecord.SetFilter("NS_Entry No.", '<>%1', 0);
            if RevRecSummRecord.FindLast() then begin
                TargetRevRecSummRecord.Init();
                TargetRevRecSummRecord."NS_Entry No." := RevRecSummRecord."NS_Entry No." + 1;
                TargetRevRecSummRecord.TransferFields(SourceRevRecTble, false);
                TargetRevRecSummRecord."NS_Entry Type" := TargetRevRecSummRecord."NS_Entry Type"::Finance;
                TargetRevRecSummRecord."NS_Ref No." := SourceRevRecTble."NS_Entry No.";
                TargetRevRecSummRecord."NS_TCE Over-ridden" := true;
                TargetRevRecSummRecord."NS_TCE Override" := false;
                TargetRevRecSummRecord."NS_New TCE Ref" := 0;
                TargetRevRecSummRecord."NS_Period Costs" := SourceRevRecTble."NS_Period Costs";
                TargetRevRecSummRecord."NS_Actual Costs To Date" := SourceRevRecTble."NS_Actual Costs To Date";
                TargetRevRecSummRecord.Insert(true);

                SourceRevRecTbleCopy.Reset();
                SourceRevRecTbleCopy.SetRange("NS_Entry No.", SourceRevRecTble."NS_Entry No.");
                if SourceRevRecTbleCopy.FindFirst() then begin
                    SourceRevRecTbleCopy."NS_New TCE Ref" := TargetRevRecSummRecord."NS_Entry No.";
                    SourceRevRecTbleCopy."NS_TCE Override" := true;
                    SourceRevRecTbleCopy."NS_TCE Over-ridden" := false;
                    SourceRevRecTbleCopy.Modify(true);
                end;
            end;
        end;
        //PE-174.JS.1.0 31JAN2024 end
    end;
    //PE-174.AS.1.0 16NOV2023 END

    //PE-174.AS.3.0 start
    procedure NS_NewTCERefVoid()
    var
        RevRecSummRecord: Record NS_RevenueRecSummaryTab;
    begin
        RevRecSummRecord.Reset();
        RevRecSummRecord.SetCurrentKey("NS_Entry No.");
        RevRecSummRecord.SetFilter("NS_New TCE Ref", '<>%1', 0);
        if RevRecSummRecord.FindSet() then
            repeat
                RevRecSummRecord.NS_Voided := true;
                RevRecSummRecord.Modify(true);
            until RevRecSummRecord.Next() = 0;
    end;
    //PE-174.AS.3.0 end
}