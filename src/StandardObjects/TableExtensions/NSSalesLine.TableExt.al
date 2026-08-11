tableextension 14021109 NS_SalesLine extends "Sales Line"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-53.SK.1.0 Added code for initialize the "currency"
    //JD-10.MS.1.0 Added new field
    //CTSI-42.AS.1.0 08May2020 Adding new key for inv report 
    //CTSI-42.AS.1.0 21MAY2020 Added Revenue Category Description Field
    //PRJ-264.AS.1.0 02JUNE2020 - Modified Table relation for No. field to add retention ledger code relation
    //PRJ-389.MS.1.0  added filter for get job plng line
    //TM-10.AM.1.0 | Added Field.
    //CTSI-150.AS.1.0 added new fields
    //PRJ-1015.JS.1.0 22Oct2021 | field Added
    //PRJ-1039.JS.1.0 12Nov2021 | Add code
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1248.NK.1.0 16Mar2022 | Add code
    //PRJ-1603.NK.1.0 07Sep2022 | Add Code
    //PRJ-1624.NK.1.0 22Sep2022 | Added Fields
    //PRJCTPR-304.HS.1.0 24Jan2024 | Added Code
    fields
    {
        //PRJ-264.AS.1.0 02JUNE2020 - start
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text" ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                            "Account Type" = CONST(Posting), Blocked = CONST(false)) ELSE
            IF (Type = CONST("G/L Account"), "System-Created Entry" = CONST(true)) "G/L Account" ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge" ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER(<> "Credit Memo" & <> "Return Order")) Item WHERE(Blocked = CONST(false), "Sales Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item), "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST(Resource)) Resource ELSE
            IF (Type = CONST(NS_Ledger)) "NS_Retention Ledger Code";

            //PRJ-1087.JS.1.0 18Dec2021 - Satrt
            trigger OnAfterValidate()
            var
                NS_JobSetup: Record "Jobs Setup";
                NS_Jobs: Record job;
                NS_BillingHeader: Record "NS_Progress Billing Header";
                NS_JobsSetup: Record "Jobs Setup";
                SalesHeader: Record "Sales Header"; //PRJ-1248.NK.1.0 16Mar2022
            begin
                if not rec."System-Created Entry" then begin //PRJ-1603.NK.1.0 07Sep2022
                    if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then //PRJ-1248.NK.1.0 16Mar2022
                        Rec.validate("Job No.", SalesHeader."NS_Job No."); //PRJ-1248.NK.1.0 16Mar2022
                end; //PRJ-1603.NK.1.0 07Sep2022
                //PRJ-1308.GK.1.0 05May2022 start-Comment
                // If Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Jobs.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                //PRJ-1308.GK.1.0 05May2022 end
            end;
            //PRJ-1087.JS.1.0 18Dec2021 - end
        }
        //PRJ-264.AS.1.0 02JUNE2020 - end
        modify(Amount)
        {
            trigger OnAfterValidate()
            var
                SalesTaxCalculate: Codeunit "Sales Tax Calculate";
                CodeUnit50020: Codeunit "NS_Event Subscr. Tables";
                SalesHeader: Record "Sales Header";
                Currency: Record Currency;
                IsHandled: Boolean;
            begin
                SalesHeader.Get("Document Type", "Document No.");
                //PRJ-53.SK.1.0 Start
                IF Currency.Get(SalesHeader."Currency Code") THEN begin
                    SalesHeader.TestField("VAT Base Discount %", 0);
                    Rec."VAT Base Amount" := Round(Rec.Amount, Currency."Amount Rounding Precision")
                end else begin
                    Currency.InitRoundingPrecision();
                    SalesHeader.TestField("VAT Base Discount %", 0);
                    Rec."VAT Base Amount" := Round(Rec.Amount, Currency."Amount Rounding Precision");
                end;
                //PRJ-53.SK.1.0 End
                //ProjectPro - start
                CodeUnit50020.NS_T37NS_AdjustVATBaseAmount(Rec, SalesHeader);
                //ProjectPro - end


                OnBeforeSetAmountIncludingVAT(Rec."Amount Including VAT", IsHandled);
                IF Not IsHandled then
                    Rec."Amount Including VAT" :=
                      Rec.Amount +
                      SalesTaxCalculate.CalculateTax(
                        Rec."Tax Area Code", Rec."Tax Group Code", Rec."Tax Liable", SalesHeader."Posting Date",
                        Rec."VAT Base Amount", Rec."Quantity (Base)", SalesHeader."Currency Factor");
                if Rec."VAT Base Amount" <> 0 then
                    Rec."VAT %" :=
                      //ProjectPro - start
                      //ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                      Round(100 * (Rec."Amount Including VAT" - Rec.Amount) / Rec."VAT Base Amount", 0.00001)
                //ProjectPro - end
                else
                    Rec."VAT %" := 0;
                Rec."Amount Including VAT" := Round(Rec."Amount Including VAT", Currency."Amount Rounding Precision");
            end;
        }
        modify("Amount Including VAT")
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                Currency: Record Currency;
            begin
                SalesHeader.Get("Document Type", "Document No.");
                //PRJ-53.SK.1.0 Start
                IF NOT Currency.Get(SalesHeader."Currency Code") then
                    Currency.InitRoundingPrecision();
                //PRJ-53.SK.1.0 END
                if Rec.Amount <> 0 then
                    Rec."VAT %" :=
                      //ProjectPro - start
                      //ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      Round(100 * (Rec."Amount Including VAT" - Rec.Amount) / Rec."VAT Base Amount", 0.00001)
                //ProjectPro - end
                else
                    Rec."VAT %" := 0;
                Rec.Amount := Round(Rec.Amount, Currency."Amount Rounding Precision");
                Rec."VAT Base Amount" := Rec.Amount;
            end;
        }
        //Unsupported feature: Change Editable on ""VAT %"(Field 25)". Please convert manually.
        //Unsupported feature: Change Editable on ""Amount Including VAT"(Field 30)". Please convert manually.
        //Unsupported feature: PropertyDeletion on ""Job No."(Field 45)". Please convert manually.

        //PRJ-1015.JS.1.0  22Oct2021 start
        modify("Job No.")
        {
            trigger OnAfterValidate()
            var
                NS_Jobs: Record job;
                NS_BillingHeader: Record "NS_Progress Billing Header";  //PRJ-1087.JS.1.0 18Dec2021
                NS_JobsSetup: Record "Jobs Setup";   //PRJ-1087.JS.1.0 18Dec2021
                NS_SalesHeader: Record "Sales Header"; //PRJCTPR-17.PS.1.0 28March2022
            begin
                if Rec."Job No." <> '' then
                    if NS_jobs.get(Rec."Job No.") then
                        //Rec."NS_Sub-Level to Job No." := NS_Jobs."NS_Sub-Level to Job No.";  //PRJ-1039.JS.1.0 12Nov2021 line commented
                        //PRJ-1039.JS.1.0 12Nov2021 - Start
                        if NS_Jobs."NS_Sub-Level to Job No." = '' then
                            Rec."NS_Sub-Level to Job No." := NS_Jobs."No."
                        else
                            Rec."NS_Sub-Level to Job No." := NS_Jobs."NS_Sub-Level to Job No.";
                //PRJ-1039.JS.1.0 12Nov2021 - end   
                //PRJ-1308.GK.1.0 05May2022 start-Comment 
                // //PRJ-1087.JS.1.0 18Dec2021 - Start
                // If Rec."Job No." <> '' then begin
                //     NS_JobsSetup.Get();
                //     if NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                //         NS_Jobs.Get(Rec."Job No.");
                //         Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
                //         Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
                //         Rec."Dimension Set ID" := NS_BillingHeader.GetDimensionNoFromJob(Rec."Job No.");
                //     end;
                // end;
                // //PRJ-1087.JS.1.0 18Dec2021 - end
                //PRJ-1308.GK.1.0 05May2022 end

                // PRJCTPR-17.PS.1.0 28March2023 Start
                if (rec."Job No." <> '') AND (rec.Type <> rec.Type::" ") then begin
                    if (NS_SalesHeader.get(Rec."Document Type"::Invoice, Rec."Document No.")) AND (NS_SalesHeader."NS_Job No." <> '') then
                        if Rec."Job No." <> NS_SalesHeader."NS_Job No." then
                            Error('Job No. Should be %1', NS_SalesHeader."NS_Job No.");
                end;
                //PRJCTPR-17.PS.1.0 28March2023 End 
            end;
        }
        //PRJ-1015.JS.1.0  22Oct2021 end

        //PRJ-1087.JS.1.0 18Dec2021-Start
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            var
                NS_JobSetup: Record "Jobs Setup";  //PRJ-1087.JS.1.0 18Dec2021                
                NS_JobTesks: Record "Job Task";  //PRJ-1087.JS.1.0 18Dec2021
                NS_BillingHeader: Record "NS_Progress Billing Header";//PRJ-1087.JS.1.0 18Dec2021
                //PRJCTPR-199.JS.1.0 11DEC2023 - start
                NS_Jobs: Record job;
                NSDimBufferTemp: record "Dimension Buffer" temporary;
                NSItemRec: record item;
                NSGLRec: record "G/L Account";
                NSResource: record resource;
                NSDefaultDim: record "Default Dimension";
                NSJobTaskDimension: record "Job Task Dimension";
                NSDimMgt: codeunit DimensionManagement;
                NSGLedgSetup: record "General Ledger Setup";
            //PRJCTPR-199.JS.1.0 11DEC2023 - end
            begin
                //PRJ-1308.GK.1.0 05May2022 start-Comment
                // if Rec."Job No." <> '' then
                //     if Rec."Job Task No." <> '' then begin
                //         NS_JobSetup.Get();
                //         if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
                //             NS_JobTesks.get(Rec."Job No.", Rec."Job Task No.");
                //             Rec."Shortcut Dimension 1 Code" := NS_JobTesks."Global Dimension 1 Code";
                //             Rec."Shortcut Dimension 2 Code" := NS_JobTesks."Global Dimension 2 Code";
                //             Rec."Dimension Set ID" := NS_BillingHeader.NS_GetDimensionNoFromJobTask(Rec."Job No.", Rec."Job Task No.");
                //         end;
                //     end;
                //PRJ-1308.GK.1.0 05May2022 end

                //PRJCTPR-199.JS.1.0 20NOV2023 - Start
                clear(NSDimBufferTemp);
                if NS_JobSetup.get() then;
                if NSGLedgSetup.get() then;
                if NS_JobSetup."NS_Flow Job Card Dimension" = true then begin
                    if (rec."Job No." <> '') and (rec."Job Task No." <> '') then begin
                        NSJobTaskDimension.reset();
                        NSJobTaskDimension.setrange("Job No.", rec."Job No.");
                        NSJobTaskDimension.setrange("Job Task No.", rec."Job Task No.");
                        if NSJobTaskDimension.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 37;
                                NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSJobTaskDimension.next = 0;
                    end;
                    case rec.Type of
                        rec.Type::Item:
                            begin
                                if NSItemRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 27);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::Resource:
                            begin
                                if NSResource.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 156);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::"G/L Account":
                            begin
                                if NSGLRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 15);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.SetFilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                rec.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                rec.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;

                    //if rec."Line No." <> 0 then begin
                    rec."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);
                    //end;
                end;
                if NS_JobSetup."NS_Flow Job Card Dimension" = false then begin
                    if (rec."Job No." <> '') and (rec."Job Task No." <> '') then begin
                        NSJobTaskDimension.reset();
                        NSJobTaskDimension.setrange("Job No.", rec."Job No.");
                        NSJobTaskDimension.setrange("Job Task No.", rec."Job Task No.");
                        NSJobTaskDimension.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-324.JS.1.0 23FEB2024
                        if NSJobTaskDimension.findset() then
                            repeat
                                NSDimBufferTemp.Init();
                                NSDimBufferTemp."Table ID" := 37;
                                NSDimBufferTemp."Dimension Code" := NSJobTaskDimension."Dimension Code";
                                NSDimBufferTemp.Insert();
                                NSDimBufferTemp."Dimension Value Code" := NSJobTaskDimension."Dimension Value Code";
                                NSDimBufferTemp.Modify();
                            until NSJobTaskDimension.next = 0;
                    end;
                    case rec.Type of
                        rec.Type::Item:
                            begin
                                if NSItemRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 27);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::Resource:
                            begin
                                if NSResource.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 156);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                        rec.Type::"G/L Account":
                            begin
                                if NSGLRec.get(rec."No.") then begin
                                    NSDefaultDim.Reset();
                                    NSDefaultDim.setrange("Table ID", 15);
                                    NSDefaultDim.setrange("No.", rec."No.");
                                    NSDefaultDim.setfilter("Dimension Value Code", '<>%1', '');  //PRJCTPR-311.JS.1.0 11FEB2024
                                    if NSDefaultDim.findset() then
                                        repeat
                                            NSDimBufferTemp.reset();
                                            NSDimBufferTemp.setrange("Table ID", 37);
                                            NSDimBufferTemp.setrange("Dimension Code", NSDefaultDim."Dimension Code");
                                            if not NSDimBufferTemp.findfirst() then begin
                                                NSDimBufferTemp.Init();
                                                NSDimBufferTemp."Table ID" := 37;
                                                NSDimBufferTemp."Dimension Code" := NSDefaultDim."Dimension Code";
                                                NSDimBufferTemp.Insert();
                                                NSDimBufferTemp."Dimension Value Code" := NSDefaultDim."Dimension Value Code";
                                                NSDimBufferTemp.Modify();
                                            end;
                                        until NSDefaultDim.next = 0;
                                end;
                            end;
                    end;
                    NSDimBufferTemp.reset();
                    if NSDimBufferTemp.findset() then
                        repeat
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 1 Code" then
                                rec.validate("Shortcut Dimension 1 Code", NSDimBufferTemp."Dimension Value Code");
                            if NSDimBufferTemp."Dimension Code" = NSGLedgSetup."Global Dimension 2 Code" then
                                rec.validate("Shortcut Dimension 2 Code", NSDimBufferTemp."Dimension Value Code");
                        until NSDimBufferTemp.next = 0;

                    rec."Dimension Set ID" := NSDimMgt.CreateDimSetIDFromDimBuf(NSDimBufferTemp);

                end;
                //PRJCTPR-199.JS.1.0 20NOV2023 - end                                
            end;
        }
        //PRJ-1087.JS.1.0 18Dec2021-end

        // PRJCTPR-304.HS.1.0 24Jan2024 Start
        modify(Type)
        {
            trigger OnAfterValidate()
            var
                NS_SalesHeader: Record "Sales Header";
                NS_JobSteup: Record "Jobs Setup";//PRJCTPR-333.PS.1.0 11March2024
            begin
                //PRJCTPR-333.PS.1.0 11March2024 Start 


                // NS_SalesHeader.Reset();
                // NS_SalesHeader.SetRange("No.", Rec."Document No.");
                // if NS_SalesHeader.FindFirst() then begin
                //     if (NS_SalesHeader."NS_Retention Document") and (Rec.Type <> Rec.Type::NS_Ledger) then
                //         Error('You can only select "Type = Ledger� when "Retention Document" is enabled.');
                // end;
                if NS_JobSteup.Get() then;

                if NS_SalesHeader.Get(Rec."Document Type", Rec."Document No.") then;

                if (NS_SalesHeader."NS_Retention Document") and (Rec.Type = Rec.Type::NS_Ledger) then
                    Rec.Validate("No.", NS_JobSteup."NS_Retention Receivable Ledger");

                if (NS_SalesHeader."NS_Retention Document") and (Rec.Type <> Rec.Type::NS_Ledger) then
                    Error('You can only select "Type = Ledger� when "Retention Document" is enabled.');
                if not (NS_SalesHeader."NS_Retention Document") and (Rec.Type = Rec.Type::NS_Ledger) then
                    Error('You must enable "Retention Document" to select Type=Ledger.');
                //PRJCTPR-333.PS.1.0 11March2024 End 
            end;
        }
        // PRJCTPR-304.HS.1.0 24Jan2024 End

        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Retention Applies"; Boolean)
        {
            Caption = 'Retention Applies';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            InitValue = true;

            trigger OnValidate();
            begin
                //ProjectPro - start
                TestStatusOpen;
                //ProjectPro - end
            end;
        }
        field(14021136; "NS_Balance To Print"; Decimal)
        {
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        field(14021400; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(14021401; "NS_PP Cost"; Decimal)
        {
            Caption = 'PP Cost';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_List Price"; Decimal)
        {
            Caption = 'List Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Gross Margin"; Integer)
        {
            Caption = 'Gross Margin';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if (CurrFieldNo = FIELDNO("NS_Gross Margin")) and
                   ("NS_Gross Margin" <> 0) then
                    NS_CalcUnitPricefromGrossMargin;
            end;
        }
        field(14021404; "NS_No. 2"; Code[30])
        {
            Caption = 'Mfg. Item No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateNo2OnSalesLine(Rec);
            end;
        }
        field(14021405; "NS_Core Credit Relation"; Code[20])
        {
            Caption = 'Core Credit Relation';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021406; "NS_Core CreditRelationVariant"; Code[10])
        {
            Caption = 'Core Credit Relation Variant';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021407; "NS_Contract Price Found"; Boolean)
        {
            Caption = 'Contract Price Found';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021408; "NS_Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            Description = 'ProjectPro';
            TableRelation = Manufacturer;
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Original Order Qty."; Decimal)
        {
            Caption = 'Original Order Qty.';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021410; "NS_First Shipment"; Boolean)
        {
            Caption = 'First Shipment';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_First Shipment Complete"; Boolean)
        {
            Caption = 'First Shipment Complete';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            Editable = false;
        }
        field(14021412; "NS_Exclude from Usage"; Boolean)
        {
            Caption = 'Exclude from Usage';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021413; "NS_Demand Date"; Date)
        {
            Caption = 'Demand Date';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        //CTSI-42.AS.1.0 21MAY2020 - START
        field(14021431; "NS_Revenue Cat Description"; Text[100])
        {
            Caption = 'Revenue Cat. Description';
            Description = 'Revenue Cat. Description';
            DataClassification = CustomerContent;
        }
        //CTSI-42.AS.1.0 21MAY2020 - END
        //CTSI-150.AS.1.0 28Sept2020 - start
        field(14021432; "NS_From Prog. Billing Base Amount"; Decimal)
        {
            Caption = 'From Prog. Billing Base Amount';
            Description = 'From Prog. Billing Base Amount';
            DataClassification = CustomerContent;
        }
        //CTSI-150.AS.1.0 28Sept2020 - end

        field(14021414; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            DataClassification = CustomerContent;
        }
        //TM-32.AM.1.0
        field(14021415; "NS_Segment Name"; Text[50])
        {
            CalcFormula = Lookup("NS_Job Takeoff Segments"."NS_Segment Name" WHERE("NS_Job No." = FIELD("Job No."), "NS_Segment Code" = FIELD("NS_Segment Code")));
            Caption = 'Segment Name';
            FieldClass = FlowField;
        }
        //TM-32.AM.1.0
        field(14021430; "NS_DFR No."; code[20])
        {
            Caption = 'DFR No.';
            Description = 'JD-10.MS.1.0';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021433; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0  19Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;
            Editable = false;
        }
        //PRJ-1624.NK.1.0 22Sep2022 Start
        field(14021486; "NS_Retention %"; Decimal)
        {
            Caption = 'Retention %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 15;
            Description = 'Retention %';
            trigger OnValidate()
            var
                SaleHead: record "Sales Header";
                SaleHeader: record "Sales Header";
                SaleLine: record "Sales Line";
                TotReteAmt: decimal;
                GLSetup: Record "General Ledger Setup"; //PRJCTPR-376.NC.1.0 24May2024
            begin
                SaleHeader.reset();
                SaleHeader.SetRange("Document Type", "Document Type");
                SaleHeader.setrange("No.", Rec."Document No.");
                SaleHeader.setRange("NS_Multiple Retention on Lines", true);
                if SaleHeader.findfirst then begin
                    if "NS_Retention %" <> 0 then begin
                        // "NS_Retention Amount" := "Line Amount" * "NS_Retention %" / 100; //PRJCTPR-376.NC.1.0 24May2024 Block
                        if GLSetup.Get() then; //PRJCTPR-376.NC.1.0 24May2024
                        "NS_Retention Amount" := Round(("Line Amount" * "NS_Retention %" / 100), GLSetup."Amount Rounding Precision"); //PRJCTPR-376.NC.1.0 24May2024
                        "NS_Retention Applies" := true;
                    end else begin
                        "NS_Retention Amount" := 0;
                        "NS_Retention Applies" := false;
                    end;
                    TotReteAmt := 0;
                    SaleLine.reset();
                    SaleLine.setrange("Document No.", Rec."Document No.");
                    SaleLine.setfilter("Line No.", '<>%1', Rec."Line No.");
                    OnBeforeFindSalesLineForCalculateRetention(SaleLine);//FGH-163.SM.29022024 //PE-269.JS.1.0
                    if SaleLine.findset() then
                        repeat
                            TotReteAmt += SaleLine."NS_Retention Amount";
                        until SaleLine.Next() = 0;
                    TotReteAmt := TotReteAmt + "NS_Retention Amount";
                    SaleHead.reset();
                    SaleHead.SetRange("Document Type", Rec."Document Type");
                    SaleHead.setrange("No.", Rec."Document No.");
                    if SaleHead.findfirst then begin
                        SaleHead.Validate("NS_Retention Amount", TotReteAmt);
                        SaleHead.modify();
                    end;
                end;
            end;
        }
        field(14021487; "NS_Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            DataClassification = CustomerContent;
            Description = 'Retention Amount';
            trigger OnValidate()
            var
                SaleHead: record "Sales Header";
                SaleHeader: record "Sales Header";
                SaleLine: record "Sales Line";
                TotReteAmt: decimal;
            begin
                SaleHeader.reset();
                SaleHeader.SetRange("Document Type", "Document Type");
                SaleHeader.setrange("No.", Rec."Document No.");
                SaleHeader.setRange("NS_Multiple Retention on Lines", true);
                if SaleHeader.findfirst then begin
                    if "NS_Retention Amount" <> 0 then begin
                        "NS_Retention %" := "NS_Retention Amount" * 100 / "Line Amount";
                        "NS_Retention Applies" := true;
                    end else begin
                        "NS_Retention %" := 0;
                        "NS_Retention Applies" := false;
                    end;
                    TotReteAmt := 0;
                    SaleLine.reset();
                    SaleLine.setrange("Document No.", Rec."Document No.");
                    SaleLine.setfilter("Line No.", '<>%1', Rec."Line No.");
                    OnBeforeFindSalesLineForCalculateRetention(SaleLine);//FGH-163.SM.29022024 //PE-269.JS.1.0
                    if SaleLine.findset() then
                        repeat
                            TotReteAmt += SaleLine."NS_Retention Amount";
                        until SaleLine.Next() = 0;
                    TotReteAmt := TotReteAmt + "NS_Retention Amount";
                    SaleHead.reset();
                    SaleHead.SetRange("Document Type", Rec."Document Type");
                    SaleHead.setrange("No.", Rec."Document No.");
                    if SaleHead.findfirst then begin
                        SaleHead.Validate("NS_Retention Amount", TotReteAmt);
                        SaleHead.modify();
                    end;
                end;
            end;
        }
        //PRJ-1624.NK.1.0 22Sep2022 End

    }
    keys
    {
        key(Key1; "NS_Retention Applies")
        {
        }
        key(key5; "NS_Job Revenue Category")   //adding new key for inv report //CTSI-42.AS.1.0 
        {

        }
    }

    //FGH-163.SM.29022024 //PE-269.JS.1.0 START
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindSalesLineForCalculateRetention(var salesLine: Record "Sales Line")
    begin

    end;
    //FGH-163.SM.29022024 //PE-269.JS.1.0 END

    PROCEDURE CalcGrossMargin();
    VAR
        CalcMargin: Decimal;
    BEGIN
        CASE TRUE OF
            "Unit Cost" <> 0:
                BEGIN
                    CalcMargin := (ROUND("Unit Price" / "Unit Cost", 1) * 100);
                    CASE TRUE OF
                        (CalcMargin < -2147483647):
                            VALIDATE("NS_Gross Margin", -2147483647);
                        (CalcMargin > 2147483647):
                            VALIDATE("NS_Gross Margin", 2147483647);
                        ELSE
                            VALIDATE("NS_Gross Margin", CalcMargin);
                    END;
                END;
            "NS_PP Cost" <> 0:
                BEGIN
                    CalcMargin := (ROUND("Unit Price" / "NS_PP Cost", 1) * 100);
                    CASE TRUE OF
                        (CalcMargin < -2147483647):
                            VALIDATE("NS_Gross Margin", -2147483647);
                        (CalcMargin > 2147483647):
                            VALIDATE("NS_Gross Margin", 2147483647);
                        ELSE
                            VALIDATE("NS_Gross Margin", CalcMargin);
                    END;
                END ELSE
                        "NS_Gross Margin" := 100;
        END;
    END;

    PROCEDURE NS_CalcUnitPricefromGrossMargin();
    BEGIN
        IF ("Unit Cost" = 0) AND
          ("NS_PP Cost" = 0) THEN
            ERROR(Text14021400Lbl);
        IF "Unit Cost" <> 0 THEN BEGIN
            VALIDATE("Unit Price", ROUND("Unit Cost" + ("Unit Cost" * ("NS_Gross Margin" / 100)), 0.01))
        END ELSE BEGIN
            IF "NS_PP Cost" <> 0 THEN
                VALIDATE("Unit Price", ROUND("NS_PP Cost" + ("NS_PP Cost" * ("NS_Gross Margin" / 100)), 0.01))
        END;
    END;

    PROCEDURE GetPurchCode(DropShip: Boolean; SpecialOrder: Boolean; VAR PurchCode: Code[10]);
    VAR
        Purchasing: Record 5721;
    BEGIN
        CASE TRUE OF
            DropShip AND SpecialOrder:
                ERROR(Text14021401Lbl);
            DropShip:
                BEGIN
                    Purchasing.RESET;
                    Purchasing.SETRANGE("Drop Shipment", TRUE);
                    IF Purchasing.FINDFIRST THEN
                        PurchCode := Purchasing.Code;
                END;
            SpecialOrder:
                BEGIN
                    Purchasing.RESET;
                    Purchasing.SETRANGE("Special Order", TRUE);
                    IF Purchasing.FINDFIRST THEN
                        PurchCode := Purchasing.Code;
                END;
        END;
    END;

    PROCEDURE SetDropShipbyLocation();
    BEGIN
        IF ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) AND
           (Type = Type::Item) THEN BEGIN
            VALIDATE("Purchasing Code", '');
        END;
    END;

    PROCEDURE SetDefaultVariant();
    VAR
        ItemVariant: Record 5401;
    BEGIN
        ItemVariant.RESET;
        ItemVariant.SETRANGE("Item No.", "No.");
        ItemVariant.SETRANGE(NS_Default, TRUE);
        IF ItemVariant.FINDFIRST THEN
            VALIDATE("Variant Code", ItemVariant.Code);
    END;

    PROCEDURE NS_GetJobLedger();
    BEGIN
        NS_GetJobUsage.SetCurrentSalesLine(Rec);
        NS_GetJobUsage.RUNMODAL;
        CLEAR(NS_GetJobUsage);
        //ProjectPro - end
    END;

    PROCEDURE NS_GetJobBudget(CustNo: Code[20]);
    VAR
        NS_JobPlanningLine: Record 1003;
        NS_Job: Record 167;
        NS_SalesHeader: Record 36;
        NS_SalesLine: Record 37;
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    BEGIN
        IF "Job No." = '' THEN BEGIN
            NS_SalesHeader.GET("Document Type", "Document No.");
            NS_SalesHeader.TESTFIELD("NS_Job No.");
            NS_JobNo := NS_SalesHeader."NS_Job No.";
        END ELSE
            NS_JobNo := "Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_JobPlanningLine.SetFilter("Line Type", '%1|%2', NS_JobPlanningLine."Line Type"::Billable,
                                                       NS_JobPlanningLine."Line Type"::"Both Budget and Billable");//PRJ-389.MS.1.0
        NS_GetJobPlanningLine.NS_SetGetFrom("Document Type", 1, "Document No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;

        CLEAR(NS_GetJobPlanningLine);
    END;

    PROCEDURE NS_AdjustVATBaseAmount(VAR SalesHeader: Record "Sales Header");
    VAR
        NS_GLSetup: Record 98;
        NS_JobsSetup: Record 315;
    BEGIN
        //ProjectPro - start
        IF SalesHeader."NS_Retention Percent" = 0 THEN
            EXIT;

        IF NS_JobsSetup.GET THEN BEGIN
            IF NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" = NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing" THEN
                "VAT Base Amount" := Amount - ROUND("VAT Base Amount" * (SalesHeader."NS_Retention Percent" / 100), NS_GLSetup."Amount Rounding Precision");
        END;
        //ProjectPro - end
    END;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetAmountIncludingVAT(Var AmountIncludeVAT: Decimal; VAR IsHandled: boolean)
    begin
    end;
    //PE-301.NC.1.0 14Jun2024 Start
    PROCEDURE NS_GetJobBudgetNew(CustNo: Code[20]; SalesHeader: Record "Sales Header");
    VAR
        NS_JobPlanningLine: Record 1003;
        NS_Job: Record 167;
        NS_SalesHeader: Record 36;
        NS_SalesLine: Record 37;
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    BEGIN
        SalesHeader.TESTFIELD("NS_Job No.");
        NS_JobNo := SalesHeader."NS_Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_JobPlanningLine.SetFilter("Line Type", '%1|%2', NS_JobPlanningLine."Line Type"::Billable,
                                                       NS_JobPlanningLine."Line Type"::"Both Budget and Billable");//PRJ-389.MS.1.0
        NS_GetJobPlanningLine.NS_SetGetFrom(SalesHeader."Document Type", 1, SalesHeader."No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;

        CLEAR(NS_GetJobPlanningLine);
    END;
    //PE-301.NC.1.0 14Jun2024 End

    var
        //PurchCode: Code[10];
        NS_GetJobUsage: Report "NS_Get Job Usage";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        Text14021400Lbl: Label 'Unable to calculate price from gross margin.  This item does not have a Unit Cost or Non-Stock Cost value.';
        Text14021401Lbl: Label 'A Purchasing Code cannot be Drop Ship and Special Order.';

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added fields:
      +     14021101 Job Cost Category
      +     14021102 Job Revenue Category
      +     14021135 Retention Applies
      +     14021136 Balance To Print
      +     14021400 Status
      +     14021401 PP Cost
      +     14021402 List Price
      +     14021403 Gross Margin
      +     14021404 No. 2
      +     14021405 Core Credit Relation
      +     14021406 Core Credit Relation Variant
      +     14021407 Contract Price Found
      +     14021408 Manufacturer Code
      +     14021409 Original Order Qty.
      +     14021410 First Shipment
      +     14021411 First Shipment Complete
      +     14021412 Exclude from Usage
      +     14021413 Demand Date
      +
      +  - Added function(s):
      +     PP_GetJobLedger  - Should be the sames a P47
      +     PP_GetJobBudget  - Should be the sames a P47
      +     CalcGrossMargin
      +     CalcUnitPricefromGrossMargin
      +     GetPurchCode
      +     SetDropShipByLocation
      +     SetDefaultVariant
      +
      +  - Added global variable(s):
      +     PurchCode
      +     QuoteMgt
      +     PP_GetJobUsage
      +
      +  - Added global text constant(s):
      +     Text14021400
      +     Text14021401
      +
      +  - Modification(s):
      +     - Added Keys:
      +         Retention Applies
      +         Document Type,Document No.,Job No.,Job Revenue Category,Job Task No.
      +     - Modified OnLookup for:
      +         Amount
      +         UpdateVATAmounts()
      +         UpdateVATOnLines
      +         Job Task No.
      +     - Added OnLookup code to Job Task No.
      +     - Added OnValidate to avoid GET of non-existant Standard Text to No.
      +     - Modify to allow field modifictions Job Task No.
      +     - Modify Type field by adding Ledger to the end of the OptionString
      +     - Modify the Editable property to Yes
      +         VAT %
      +         Amount Including VAT
      +         Job No.
      +     - Modify Calculation of VAT %
      +-----------------------------------------------------------------------------------------------*/
}

