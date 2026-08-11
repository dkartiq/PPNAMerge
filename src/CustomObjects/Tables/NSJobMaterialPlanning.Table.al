table 14021421 "NS_Job Material Planning"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-224.AS.1.0 - 15APRIL2020 - Incresed Desciption field to 100 characters.
    //PRJ-130.MS.1.0 add code and new function
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PRJ-260.MS.1.0 code changes for std. field inplacce of cust. manu. field
    //PPAL-50.SK.1.0 modified code on "MakeResourcePurchDoc" action	   
    //PRJ-372.MS.1.0 added new fields
    //PPAL-93.AS.1.0 10SEPT2020 Done code to insert Document No., Date Order By in JMP from JPL 
    //PRJ-408.MS.1.0 changes unit cost decimal place to 5
    //PRJ-404.AM.1.0 9OCT2020 | Added Code to flow description while creating PO from JMP
    //TM-10.AM.1.0 | Added Field and code.
    //PRJ-650 Add project Pro in Error message or Warning message
    //PRJ-634.N.S.1.0 condition on resoure only show purchable item when select dropdown
    //PRJ-895.GK.1.0 27Aug2021 | Added two fields &  changes in the code.
    Caption = 'Job Material Planning';

    fields
    {
        field(1; "NS_Worksheet Job No."; Code[20])
        {
            Caption = 'Worksheet Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if Jobs.GET("NS_Worksheet Job No.") then;
            end;
        }
        field(2; "NS_Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Date Ordered By"; Date)
        {
            Caption = 'Date Ordered By';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Date Required"; Date)
        {
            Caption = 'Date Required';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Order Code"; Code[20])
        {
            Caption = 'Order Code';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Worksheet Job No."));
            DataClassification = CustomerContent;
        }
        field(7; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Resource,Item,G/L Account,Text,Resource (Group)';
            OptionMembers = Resource,Item,"G/L Account",Text,"Resource (Group)";
        }
        field(8; "NS_Part No."; Code[20])
        {
            Caption = 'Part No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) Item."No."
            ELSE
            //IF (NS_Type = CONST(Resource)) Resource;//PRJ-634.N.S.1.0 comment
            IF (NS_Type = CONST(Resource)) Resource where("NS_Resource is Purchasable" = const(true));//PRJ-634.N.S.1.0

            trigger OnValidate();
            var
            //lJobJnlLine: Record "Job Journal Line";
            //lItemLedgerEntry: Record "Item Ledger Entry";
            //iQuantity: Decimal;
            begin
                if Items.GET("NS_Part No.") then begin
                    if Rec."NS_Part No." <> xRec."NS_Part No." then begin
                        NS_Type := NS_Type::Item;
                        NS_Manufacturer := Items."Manufacturer Code";//PRJ-130.MS.1.0 code comment	  //PRJ-260 
                        //NS_Manufacturer := Items.NS_Manufacturer;//PRJ-130.MS.1.0 //PRJ-260code comment
                        NS_Description := Items.Description;
                        NS_Details := Items."Description 2";
                        NS_Vendor := Items."Vendor No.";
                        "NS_Unit Cost" := Items."Unit Cost";
                    end;
                end else begin
                    NS_Type := NS_Type::Resource;
                    "NS_Unit Cost" := 0;
                    if Resource.GET("NS_Part No.") then begin
                        Resource.CALCFIELDS("Usage (Cost)");
                        "NS_Unit Cost" := Resource."Usage (Cost)";
                        NS_Description := Resource.Name;//PPAL-50.SK.1.0 Added 
                        NS_Vendor := Resource."Vendor No."; //PPAL-50.SK.1.0 Added 
                        "NS_Purchase Res. G/L" := Resource."NS_Resource is Purchasable"; //PPAL-50.SK.1.0 Added 
                    end;
                end;
                "NS_Total Cost" := ROUND("NS_Unit Cost" * NS_Quantity, GLSetup."Amount Rounding Precision");

                NS_ItemAvail();
            end;
        }
        field(9; NS_Description; Text[100])//PRJ-224:AS:15APRIL2020
        {
            Caption = 'Description';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(10; NS_Details; Text[100])
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
        }
        field(11; NS_Manufacturer; Text[50])
        {
            Caption = 'Manufacturer';
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(12; NS_Vendor; Code[20])
        {
            Caption = 'Vendor';
            TableRelation = Vendor."No.";
            DataClassification = CustomerContent;
            //PRJ-130.MS.1.0 start
            trigger OnLookup()
            var
                Vend: Record Vendor;
            begin
                IF NS_LookupVendor(Vend, TRUE) THEN
                    VALIDATE(NS_Vendor, Vend."No.");
            end;
            //PRJ-130.MS.1.0 end
        }
        field(13; "NS_Inv. Qty"; Decimal)
        {
            CalcFormula = Sum("Job Journal Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                 "Job Task No." = FIELD("NS_Order Code"),
                                                                 "No." = FIELD("NS_Part No."),
                                                                 NS_Staged = FILTER(false),
                                                                 "Document No." = FIELD("NS_Document No.")));
            Caption = 'Inv. Qty';
            FieldClass = FlowField;
        }
        field(14; "NS_PO Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                            "Job Task No." = FIELD("NS_Order Code"),
                                                                            "No." = FIELD("NS_Part No."),
                                                                            "Outstanding Quantity" = FILTER(<> 0),
                                                                            "NS_JMP Document No." = FIELD("NS_Document No.")));
            Caption = 'PO Qty';
            FieldClass = FlowField;
        }
        field(15; "NS_PO Qty Rcd"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                  "Job Task No." = FIELD("NS_Order Code"),
                                                                  "No." = FIELD("NS_Part No."),
                                                                  "NS_JMP Document No." = FIELD("NS_Document No."),
                                                                  NS_Staged = CONST(true)));
            Caption = 'PO Qty Rcd';
            FieldClass = FlowField;
        }
        field(16; "NS_Job Site"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                  "Job Task No." = FIELD("NS_Order Code"),
                                                                  "No." = FIELD("NS_Part No."),
                                                                  NS_Staged = FILTER(false)));
            Caption = 'Job Site';
            FieldClass = FlowField;
        }
        field(17; "NS_Bal. Req"; Decimal)
        {
            Caption = 'Bal. Req';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CALCFIELDS("NS_Inv. Qty", "NS_PO Qty", "NS_Job Site", "NS_PO Qty Rcd", "NS_Quantity Invoiced", "NS_Posted Quantity", "NS_PO Return Qty. Shipped", "NS_PO Return Qty");//PRJ-372 added one more field
                //"NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty"; //PRJ-372 Comment	   
                "NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty" + "NS_PO Return Qty. Shipped" + "NS_PO Return Qty"; //PRJ-372.MS.1.0
                if "NS_Bal. Req" < 0 then
                    "NS_Bal. Req" := 0;

                NS_ItemAvail();
            end;
        }
        field(18; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                CALCFIELDS("NS_Inv. Qty", "NS_PO Qty", "NS_Job Site", "NS_PO Qty Rcd", "NS_Quantity Invoiced", "NS_Posted Quantity", "NS_PO Return Qty. Shipped", "NS_PO Return Qty"); //PRJ-372 add one field
                //"NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty";//PRJ-372 Comment	  
                "NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty" + "NS_PO Return Qty. Shipped" + "NS_PO Return Qty"; //PRJ-372.MS.1.0
                if "NS_Bal. Req" < 0 then
                    "NS_Bal. Req" := 0;

                NS_ItemAvail();
                "NS_Total Cost" := ROUND("NS_Unit Cost" * NS_Quantity, GLSetup."Amount Rounding Precision");
            end;
        }
        field(19; "NS_Job Name"; Text[100])	////PRJ-301.MS.1.0
        {
            CalcFormula = Lookup(Job.Description WHERE("No." = FIELD("NS_Worksheet Job No.")));
            Caption = 'Job Name';
            FieldClass = FlowField;
        }
        field(20; "NS_Inv. Avail"; Decimal)
        {
            Caption = 'Inv. Avail';
            Editable = false;
            FieldClass = Normal;
            DataClassification = CustomerContent;
        }
        field(21; "NS_Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
        }
        field(22; "NS_Quantity Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                 "Job Task No." = FIELD("NS_Order Code"),
                                                                 "No." = FIELD("NS_Part No."),
                                                                 "NS_JMP Document No." = FIELD("NS_Document No.")));
            Caption = 'Quantity Invoiced';
            FieldClass = FlowField;
        }
        field(23; "NS_PO Qty Staged"; Decimal)
        {
            CalcFormula = Sum("Purch. Rcpt. Line"."NS_Staged Quantity" WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                           "Job Task No." = FIELD("NS_Order Code"),
                                                                           "No." = FIELD("NS_Part No."),
                                                                           NS_Staged = FILTER(true),
                                                                           "NS_JMP Document No." = FIELD("NS_Document No."),
                                                                           "NS_Journal Status" = CONST(Posted)));
            Caption = 'PO Qty Staged';
            FieldClass = FlowField;
        }
        field(24; "NS_Job Site From Inv."; Decimal)
        {
            Caption = 'Job Site From Inv.';
            DecimalPlaces = 0 : 0;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(25; "NS_Job Description"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Job Description';
            DataClassification = CustomerContent;
        }
        field(26; "NS_Customer Account Name"; Text[100])
        {
            Caption = 'Customer Account Name';
            DataClassification = CustomerContent;
        }
        field(27; "NS_Job Site Vndr Qty"; Decimal)
        {
            Caption = 'Job Site Vndr Qty';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(28; "NS_Job Manager"; Text[100])	//PRJ-301.MS.1.0
        {
            Caption = 'Job Manager';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(29; "NS_Use Available Inventory"; Boolean)
        {
            Caption = 'Use Available Inventory';
            DataClassification = CustomerContent;
        }
        field(30; "NS_Total Qty. Ready to Ship"; Decimal)
        {
            Caption = 'Total Quantity Ready to Ship';
            DataClassification = CustomerContent;
        }
        field(31; "NS_Inventory Qty. Staged"; Decimal)
        {
            Caption = 'Inventory Qty. Staged';
            DataClassification = CustomerContent;
        }
        field(32; "NS_Box Text"; Text[30])
        {
            Caption = 'Box Text';
            DataClassification = CustomerContent;
        }
        field(33; "NS_PO Qty. to Ship"; Decimal)
        {
            Caption = 'PO Qty. to Ship';
            DataClassification = CustomerContent;
        }
        field(34; "NS_Invt. Qty. to Ship"; Decimal)
        {
            Caption = 'Invt. Qty. to Ship';
            DataClassification = CustomerContent;
        }
        field(35; "NS_Total Quantity Staged"; Decimal)
        {
            Caption = 'Total Quantity Staged';
            DataClassification = CustomerContent;
        }
        field(36; "NS_Posted Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                 "Job Task No." = FIELD("NS_Order Code"),
                                                                 Type = CONST(Item),
                                                                 "Document No." = FIELD("NS_Document No."),
                                                                 "No." = FIELD("NS_Part No.")));
            Caption = 'Posted Quantity';
            FieldClass = FlowField;
        }
        field(37; "NS_Task Description"; Text[100])	  //PRJ-301.MS.1.0
        {
            CalcFormula = Lookup("Job Task".Description WHERE("Job Task No." = FIELD("NS_Order Code")));
            Caption = 'Task Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "NS_Purchase Res. G/L"; Boolean)
        {
            Caption = 'Purchase Res. G/L';
            DataClassification = CustomerContent;
        }
        field(39; "NS_Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DecimalPlaces = 0 : 5;//PRJ-408
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Total Cost" := ROUND("NS_Unit Cost" * NS_Quantity, GLSetup."Amount Rounding Precision");
            end;
        }
        field(40; "NS_Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(41; "NS_Job Plannine Line No."; Integer)
        {
            Caption = 'Job Plannine Line No.';
            DataClassification = CustomerContent;
        }
        field(45; "NS_Job Purchaser"; Code[20])
        {
            Caption = 'Job Purchaser';
            TableRelation = Resource;
            DataClassification = CustomerContent;
            Description = 'CTSI-110.MS.1.0';
        }
        field(42; "NS_PO Return Qty. Shipped"; Decimal)
        {
            CalcFormula = Sum("Return Shipment Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                  "Job Task No." = FIELD("NS_Order Code"),
                                                                  "No." = FIELD("NS_Part No."),
                                                                  "NS_JMP Document No." = FIELD("NS_Document No.")));
            Caption = 'PO Return Qty. Shipped';
            Description = 'PRJ-372.MS.1.0';
            FieldClass = FlowField;
            trigger OnLookup()
            var
                ReturnShipLine: Record "Return Shipment Line";
            begin
                ReturnShipLine.Reset();
                ReturnShipLine.SetRange("Job No.", "NS_Worksheet Job No.");
                ReturnShipLine.SetRange("Job Task No.", "NS_Order Code");
                ReturnShipLine.SetRange("No.", "NS_Part No.");
                ReturnShipLine.SetRange("NS_JMP Document No.", "NS_Document No.");
                if FindFirst() then begin
                    Page.Run(Page::"Posted Return Shipment Lines", ReturnShipLine)
                end;
            end;
        }
        field(43; "NS_PO Return Qty. Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purch. Cr. Memo Line".Quantity WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                  "Job Task No." = FIELD("NS_Order Code"),
                                                                  "No." = FIELD("NS_Part No."),
                                                                  "NS_JMP Document No." = FIELD("NS_Document No.")));
            Caption = 'PO Return Qty. Invoiced';
            Description = 'PRJ-372.MS.1.0';
            FieldClass = FlowField;
        }
        field(44; "NS_PO Return Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Job No." = FIELD("NS_Worksheet Job No."),
                                                                            "Job Task No." = FIELD("NS_Order Code"),
                                                                            "No." = FIELD("NS_Part No."),
                                                                            "Outstanding Quantity" = FILTER(<> 0),
                                                                            "NS_JMP Document No." = FIELD("NS_Document No."),
                                                                             "Document Type" = filter("Return Order")));
            Caption = 'PO Return Qty';
            FieldClass = FlowField;
            Description = 'PRJ-372.MS.1.0';
        }
        field(46; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Description = 'TM-10.AM.1.0';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Worksheet Job No."));
            DataClassification = CustomerContent;
        }

        field(47; "NS_Assembly Item on Job."; Code[20])//PRJ-563
        {
            Caption = 'Assembly Item on Job';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Type" = CONST(Resource)) Resource
            ELSE
            IF ("NS_Type" = CONST(Item)) Item
            ELSE
            IF ("NS_Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("NS_Type" = const(Text)) "Standard Text"
            else
            if ("NS_Type" = CONST("Resource (Group)")) "Resource Group";
        }

        field(48; "NS_Item Name"; Text[50])//PRJ-563
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate();
            begin
            end;

        }

        field(49; "NS_Quantity Per"; Decimal)//PRJ-563
        {
            Caption = 'Quantity Per';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
            end;
        }

        field(50; "NS_Level"; Integer)//PRJ-563.AS.1.0 24MAY2020 
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
            end;
        }
        field(51; "NS_Main Item"; Code[20])//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Main Item';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) Item."No."
            ELSE
            IF (NS_Type = CONST(Resource)) Resource;

            trigger OnValidate();
            var
            begin

            end;
        }
        field(52; "NS_Item Type"; Option)//PRJ-563.AS.1.0 24MAY2020
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Normal,Assembly';
            OptionMembers = Normal,Assembly;
        }

        field(53; "NS_Item Name New"; Text[100])//PRJ-838.AS.1.0
        {
            Caption = 'Item Name';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate();
            begin
            end;

        }
        //PRJ-895.GK.1.0 27Aug2021 start
        field(54; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(55; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-895.GK.1.0 27Aug2021 end
    }

    keys
    {
        key(Key1; "NS_Worksheet Job No.", "NS_Line No.")
        {
        }
        key(Key2; "NS_Job Manager", "NS_Worksheet Job No.")
        {
        }
        key(Key3; "NS_Part No.", "NS_Document No.")
        {
        }
        key(Key4; "NS_Box Text")
        {
        }
        key(Key5; "NS_Worksheet Job No.", NS_Type, "NS_Part No.", "NS_Bal. Req", "NS_Date Ordered By")
        {
        }
        key(Key6; "NS_Worksheet Job No.", "NS_Order Code", "NS_Job Plannine Line No.", NS_Level)//PRJ-563.AS.1.0 24MAY2020
        {

        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        lJob: Record Job;
        lResource: Record Resource;
        lItem: Record Item;
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
    begin
        "NS_Line No." := NS_LastLineNo("NS_Worksheet Job No.") + 10000;
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
        JobSetup.GET();
        "NS_Location Code" := JobSetup."NS_Job Mat'l Planning Location";
        if lJob.GET("NS_Worksheet Job No.") then begin
            if lResource.GET(lJob.NS_Manager) then
                "NS_Job Manager" := lResource.Name;
            "NS_Customer Account Name" := lJob."Bill-to Name";
            "NS_Job Description" := lJob.Description;
        end;
        if lItem.GET("NS_Part No.") then
            "NS_Order Code" := lItem."Inventory Posting Group";
    end;

    trigger OnModify();
    var
    //iQuantity: Decimal;
    begin
        JobSetup.GET();
        GLSetup.GET();
    end;
    //PRJ-130.MS.1.0 Start
    trigger OnDelete()
    var
        ReqLine: Record 246;
    begin
        TestField("NS_PO Qty", 0);
        ReqLine.Reset();
        ReqLine.SetRange("No.", Rec."NS_Part No.");
        ReqLine.SetRange("NS_Job Planning Line No.", Rec."NS_Job Plannine Line No.");
        ReqLine.SetRange("NS_Job No.", Rec."NS_Worksheet Job No.");
        if ReqLine.FindFirst() then
            Error('Requisition line is exist for Planning Line no. %1', rec."NS_Line No.");
    end;
    //PRJ-130.MS.1.0 end

    var
        Jobs: Record Job;
        Items: Record Item;
        JobSetup: Record "Jobs Setup";
        //ItemLedgerEntry: Record "Item Ledger Entry";
        Contact: Record Contact;
        Resource: Record Resource;
        GLSetup: Record "General Ledger Setup";

    local procedure NS_LastLineNo("JobNo.": Code[20]): Integer;
    var
        JobMP: Record "NS_Job Material Planning";
    begin
        JobMP.RESET();
        JobMP.SETRANGE("NS_Worksheet Job No.", "JobNo.");
        if JobMP.FINDLAST() then
            exit(JobMP."NS_Line No.")
        else
            exit(0);
    end;

    procedure NS_UpdateBalReq(var JobMatRec: Record "NS_Job Material Planning");
    begin
        JobMatRec.CALCFIELDS("NS_Inv. Qty", "NS_PO Qty", "NS_Job Site", "NS_PO Qty Rcd", "NS_Quantity Invoiced", "NS_PO Return Qty. Shipped", "NS_PO Return Qty");//PRJ-372 added one more field
        //JobMatRec."NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty";	 //PRJ-372 Comment
        JobMatRec."NS_Bal. Req" := NS_Quantity - ("NS_Inv. Qty" + "NS_Job Site From Inv.") - "NS_PO Qty" - "NS_PO Qty Rcd" - "NS_Inventory Qty. Staged" - "NS_Job Site Vndr Qty" + "NS_PO Return Qty. Shipped" + "NS_PO Return Qty"; //PRJ-372.MS.1.0
        //JobMatRec.MODIFY;
    end;

    procedure NS_GetandLoadActuals(pJobNo: Code[20]; pDocumentNo: Code[20]);
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        JobMatPlan: Record "NS_Job Material Planning";
        ResourceTbl: Record Resource;//PRJ-634.AS.1.0
    begin
        if CONFIRM('Are you sure you want to reload actuals? Y/N') then begin
            JobMatPlan.RESET();
            JobMatPlan.SETRANGE("NS_Worksheet Job No.", pJobNo);
            if JobMatPlan.FINDFIRST() then
                JobMatPlan.DELETEALL();
        end;

        JobLedgerEntry.RESET();
        JobLedgerEntry.SETRANGE("Job No.", pJobNo);
        JobLedgerEntry.SETRANGE(Type, NS_Type::Resource);
        if JobLedgerEntry.FINDFIRST() then
            repeat
                IF ResourceTbl.Get(JobLedgerEntry."No.") then begin //PRJ-634.AS.1.0 Added Code inside condition of purchase resource - start
                    if ResourceTbl."NS_Resource is Purchasable" = true then begin //PRJ-634.AS.1.0 Added Code inside condition of purchase resource - start
                        JobMatPlan.RESET();
                        JobMatPlan."NS_Worksheet Job No." := pJobNo;
                        JobMatPlan."NS_Line No." := NS_LastLineNo(pJobNo) + 10000;
                        JobMatPlan."NS_Document No." := pDocumentNo;
                        JobMatPlan."NS_Date Ordered By" := 0D;
                        JobMatPlan."NS_Date Required" := 0D;
                        JobMatPlan."NS_Order Code" := JobLedgerEntry."Job Task No."; //Job Task
                        JobMatPlan.NS_Type := JobMatPlan.NS_Type::Resource;
                        JobMatPlan."NS_Part No." := JobLedgerEntry."No.";
                        JobMatPlan.NS_Description := JobLedgerEntry.Description;
                        JobMatPlan.NS_Quantity := JobLedgerEntry.Quantity;
                        if Jobs.GET(JobLedgerEntry."Job No.") then begin
                            if Contact.GET(COPYSTR(Jobs."NS_Customer Account", 1, 20)) then
                                JobMatPlan."NS_Customer Account Name" := Contact.Name;

                            if Resource.GET(Jobs."Person Responsible") then
                                "NS_Job Manager" := Resource.Name
                            else
                                "NS_Job Manager" := '';

                            JobMatPlan."NS_Job Description" := Jobs.Description;
                        end;
                        JobMatPlan.VALIDATE(NS_Quantity);
                        JobMatPlan.INSERT();
                    end;//PRJ-634.AS.1.0 Added Code inside condition of purchase resource - End
                end;//PRJ-634.AS.1.0 Added Code inside condition of purchase resource - End
            until JobLedgerEntry.NEXT() = 0;
    end;

    procedure NS_CopyPlanningLines(pJobNo: Code[20]; pDocumentNo: Code[20]; Update: Boolean);
    var
        JobMatPlan: Record "NS_Job Material Planning";
        JobPlanLines: Record "Job Planning Line";
        item: Record Item; //PRJ-130.MS.1.0
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
        AssemBOMRec: Record "NS_Assembley BOM Components";//PRJ-563
        AssemBOMRecLeveL2: Record "NS_Assembley BOM Components";//PRJ-563
        ResourceRec: Record resource; //PRJ-563
        JobMatPlan1: Record "NS_Job Material Planning";//PRJ-563
        Resource1: Record Resource;//PRJ-563
        item1: Record Item; //PRJ-563
        ResourceTbl: Record Resource;//PRJ-634.AS.1.0
                                     // >> Upgrade
        Job: Record Job;
    // << Upgrade
    begin
        // >> Upgrade
        OnBeforeNS_CopyPlanningLines(Job, pJobNo);
        // << Upgrade
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
        JobSetup.GET();
        if not Update then
            if CONFIRM('Are you sure you want to erase the current batch? Y/N') then begin
                JobMatPlan.RESET();
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", pJobNo);
                JobMatPlan.DELETEALL();
            end;

        JobPlanLines.RESET();
        JobPlanLines.SETRANGE("Job No.", pJobNo);
        //JobPlanLines.SETRANGE("NS_Copied to JMP", false);//PRJ-130.MS.1.0 code comment
        JobPlanLines.SetFilter("Line Type", '<>%1', JobPlanLines."Line Type"::Billable);//PRJ-837.AS.1.0
        if not JobSetup."NS_ExpandedJobMaterialPlanning" then
            JobPlanLines.SETFILTER(Type, '%1|%2', JobPlanLines.Type::Item, JobPlanLines.Type::Resource);
        if JobPlanLines.FINDSET(false, false) then
            repeat

                JobMatPlan.RESET();
                JobMatPlan.SETRANGE("NS_Worksheet Job No.", pJobNo);
                JobMatPlan.SETRANGE(NS_Type, JobPlanLines.Type);
                JobMatPlan.SETRANGE("NS_Order Code", JobPlanLines."Job Task No.");
                JobMatPlan.SETRANGE("NS_Job Plannine Line No.", JobPlanLines."Line No.");
                if JobMatPlan.FINDFIRST() then begin
                    JobMatPlan.VALIDATE(NS_Quantity, JobPlanLines.Quantity);
                    JobMatPlan.MODIFY();
                end else begin

                    //PRJ-634.AS.1.0 Added Code inside condition of purchase resource - start <<<<<<<
                    IF (JobPlanLines.Type = JobPlanLines.Type::Resource) then
                        if ResourceTbl.Get(JobPlanLines."No.") then
                            if ResourceTbl."NS_Resource is Purchasable" = true then begin //PRJ-634.AS.1.0 Added Code inside condition of purchase resource - start
                                JobMatPlan.INIT();
                                JobMatPlan."NS_Worksheet Job No." := pJobNo;
                                JobMatPlan."NS_Line No." := NS_LastLineNo(pJobNo) + 10000;
                                //PPAL-93.AS.1.0 10SEPT2020 Commented - start
                                //if pDocumentNo <> '' then
                                //    JobMatPlan."NS_Document No." := pDocumentNo
                                //else
                                //    JobMatPlan."NS_Document No." := JobPlanLines."NS_Segment Code";
                                //PPAL-93.AS.1.0 10SEPT2020 Commented - end		
                                JobMatPlan."NS_Document No." := JobPlanLines."Document No.";//PPAL-93.AS.1.0 10SEPT2020
                                JobMatPlan."NS_Date Ordered By" := JobPlanLines."Planning Date";//PPAL-93.AS.1.0 10SEPT2020
                                JobMatPlan."NS_Date Ordered By" := 0D;
                                JobMatPlan."NS_Date Required" := JobPlanLines."Planning Date";
                                JobMatPlan."NS_Order Code" := JobPlanLines."Job Task No.";
                                JobMatPlan.NS_Type := JobPlanLines.Type;
                                JobMatPlan."NS_Part No." := JobPlanLines."No.";
                                JobMatPlan.NS_Description := JobPlanLines.Description;
                                JobMatPlan.NS_Quantity := JobPlanLines.Quantity;
                                if Jobs.GET(JobPlanLines."Job No.") then begin
                                    if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                        JobMatPlan."NS_Customer Account Name" := Contact.Name;

                                    if Resource.GET(Jobs."Person Responsible") then
                                        "NS_Job Manager" := Resource.Name
                                    else
                                        "NS_Job Manager" := '';
                                    JobMatPlan."NS_Job Description" := Jobs.Description;
                                end;

                                if JobPlanLines.Type = JobPlanLines.Type::Resource then begin
                                    Resource.RESET();
                                    if Resource.GET(JobPlanLines."No.") then
                                        if Resource."NS_Resource is Purchasable" then begin
                                            JobMatPlan."NS_Purchase Res. G/L" := true;
                                            JobMatPlan.NS_Vendor := Resource."Vendor No."; //PPAL-50.SK.1.0 Added
                                        end
                                        else
                                            JobMatPlan."NS_Purchase Res. G/L" := false;

                                end;
                                // >> Upgrade
                                // >> pv00.00
                                OnAfterCreateJobMaterialLineBeforeValidateQuantity(JobMatPlan, JobPlanLines);
                                // << pv00.00
                                // << Upgrade
                                JobMatPlan.VALIDATE(NS_Quantity);
                                JobMatPlan."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                                JobMatPlan."NS_Location Code" := JobPlanLines."Location Code";
                                JobMatPlan."NS_Unit Cost" := JobPlanLines."Unit Cost";
                                JobMatPlan."NS_Total Cost" := JobPlanLines.Quantity * JobPlanLines."Unit Cost";
                                JobMatPlan."NS_Segment Code" := JobPlanLines."NS_Segment Code";//TM-10.AM.1.0
                                if item.Get(JobPlanLines."No.") then begin //PRJ-130.MS.1.0
                                                                           //JobMatPlan.NS_Manufacturer := item.NS_Manufacturer; //PRJ-130.MS.1.0 //PRJ-260 code comment
                                    JobMatPlan.NS_Manufacturer := item."Manufacturer Code";//PRJ-260
                                    JobMatPlan.NS_Vendor := item."Vendor No.";
                                end;     //PRJ-130.MS.1.0
                                         //PRJ-563.AS.1.0 24MAY2020 start
                                JobMatPlan."NS_Main Item" := JobPlanLines."NS_Main Item";
                                JobMatPlan.NS_Level := JobPlanLines.NS_Level;
                                JobMatPlan."NS_Item Type" := JobPlanLines."NS_Item Type";
                                //PRJ-563.AS.1.0 24MAY2020 end
                                //PRJ-895.GK.1.0 27Aug2021 start
                                JobMatPlan."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                                JobMatPlan."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                                //PRJ-895.GK.1.0 27Aug2021 end
                                // >> Upgrade
                                OnBeforeInsertNS_CopyPlanningLines(JobMatPlan, JobPlanLines);

                                // << Upgrade

                                JobMatPlan.INSERT;

                            end;

                end;//PRJ-634.AS.1.0 Added Code inside condition of purchase resource - end>>>>>>>>>>>>>>>>>

                //PRJ-634.AS.1.0 Added Code inside condition for Items - start <<<<<<<<<<
                IF (JobPlanLines.Type = JobPlanLines.Type::Item) then begin
                    JobMatPlan.INIT();
                    JobMatPlan."NS_Worksheet Job No." := pJobNo;
                    JobMatPlan."NS_Line No." := NS_LastLineNo(pJobNo) + 10000;
                    //PPAL-93.AS.1.0 10SEPT2020 Commented - start
                    //if pDocumentNo <> '' then
                    //    JobMatPlan."NS_Document No." := pDocumentNo
                    //else
                    //    JobMatPlan."NS_Document No." := JobPlanLines."NS_Segment Code";
                    //PPAL-93.AS.1.0 10SEPT2020 Commented - end		
                    JobMatPlan."NS_Document No." := JobPlanLines."Document No.";//PPAL-93.AS.1.0 10SEPT2020
                    JobMatPlan."NS_Date Ordered By" := JobPlanLines."Planning Date";//PPAL-93.AS.1.0 10SEPT2020
                    JobMatPlan."NS_Date Ordered By" := 0D;
                    JobMatPlan."NS_Date Required" := JobPlanLines."Planning Date";
                    JobMatPlan."NS_Order Code" := JobPlanLines."Job Task No.";
                    JobMatPlan.NS_Type := JobPlanLines.Type;
                    JobMatPlan."NS_Part No." := JobPlanLines."No.";
                    JobMatPlan.NS_Description := JobPlanLines.Description;
                    JobMatPlan.NS_Quantity := JobPlanLines.Quantity;
                    if Jobs.GET(JobPlanLines."Job No.") then begin
                        if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                            JobMatPlan."NS_Customer Account Name" := Contact.Name;

                        if Resource.GET(Jobs."Person Responsible") then
                            "NS_Job Manager" := Resource.Name
                        else
                            "NS_Job Manager" := '';
                        JobMatPlan."NS_Job Description" := Jobs.Description;
                    end;

                    if JobPlanLines.Type = JobPlanLines.Type::Resource then begin
                        Resource.RESET();
                        if Resource.GET(JobPlanLines."No.") then
                            if Resource."NS_Resource is Purchasable" then begin
                                JobMatPlan."NS_Purchase Res. G/L" := true;
                                JobMatPlan.NS_Vendor := Resource."Vendor No."; //PPAL-50.SK.1.0 Added
                            end
                            else
                                JobMatPlan."NS_Purchase Res. G/L" := false;

                    end;

                    JobMatPlan.VALIDATE(NS_Quantity);
                    JobMatPlan."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                    JobMatPlan."NS_Location Code" := JobPlanLines."Location Code";
                    JobMatPlan."NS_Unit Cost" := JobPlanLines."Unit Cost";
                    JobMatPlan."NS_Total Cost" := JobPlanLines.Quantity * JobPlanLines."Unit Cost";
                    JobMatPlan."NS_Segment Code" := JobPlanLines."NS_Segment Code";//TM-10.AM.1.0
                    if item.Get(JobPlanLines."No.") then begin //PRJ-130.MS.1.0
                                                               //JobMatPlan.NS_Manufacturer := item.NS_Manufacturer; //PRJ-130.MS.1.0 //PRJ-260 code comment
                        JobMatPlan.NS_Manufacturer := item."Manufacturer Code";//PRJ-260
                        JobMatPlan.NS_Vendor := item."Vendor No.";
                    end;     //PRJ-130.MS.1.0
                             //PRJ-563.AS.1.0 24MAY2020 start
                    JobMatPlan."NS_Main Item" := JobPlanLines."NS_Main Item";
                    JobMatPlan.NS_Level := JobPlanLines.NS_Level;
                    JobMatPlan."NS_Item Type" := JobPlanLines."NS_Item Type";
                    //PRJ-563.AS.1.0 24MAY2020 end
                    //PRJ-895.GK.1.0 27Aug2021 start
                    JobMatPlan."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                    JobMatPlan."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                    //PRJ-895.GK.1.0 27Aug2021 end
                    JobMatPlan.INSERT;
                end;
                //PRJ-634.AS.1.0 Added Code inside condition for Items - end>>>>>>>>


                JobPlanLines."NS_Copied to JMP" := true;
                JobPlanLines.MODIFY();

                //PRJ-563.AS.1.0 - CONDITION START
                //PRJ-634.AS.1.0 Added Code inside condition of Item - start
                AssemBOMRec.Reset();
                AssemBOMRec.SetCurrentKey("NS_Ref. JPL Parent Item No.", "NS_Item Type");
                AssemBOMRec.SetRange("NS_Job No.", JobPlanLines."Job No.");
                AssemBOMRec.SetRange(NS_Type, NS_Type::Item);
                AssemBOMRec.SetRange("NS_Job Task No.", JobPlanLines."Job Task No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Line No.", JobPlanLines."Line No.");
                if AssemBOMRec.Findset() then BEGIN
                    repeat
                        JobMatPlan1.INIT();
                        JobMatPlan1."NS_Worksheet Job No." := pJobNo;
                        JobMatPlan1."NS_Line No." := NS_LastLineNo(pJobNo) + 10000;
                        JobMatPlan1."NS_Document No." := JobPlanLines."Document No.";
                        JobMatPlan1."NS_Date Ordered By" := JobPlanLines."Planning Date";
                        JobMatPlan1."NS_Date Ordered By" := 0D;
                        JobMatPlan1."NS_Date Required" := JobPlanLines."Planning Date";
                        JobMatPlan1."NS_Assembly Item on Job." := AssemBOMRec."NS_Ref. JPL Parent Item No.";
                        if item1.Get(AssemBOMRec."NS_Ref. JPL Parent Item No.") then begin
                            JobMatPlan1.NS_Manufacturer := item1."Manufacturer Code";
                            JobMatPlan1.NS_Vendor := item1."Vendor No.";
                            // JobMatPlan1."NS_Item Name" := item1.Description;//PRJ-838 COMMENT
                            JobMatPlan1."NS_Item Name New" := item1.Description;//PRJ-838 ADD
                        end;
                        JobMatPlan1."NS_Quantity Per" := AssemBOMRec."NS_Quantity Per";
                        JobMatPlan1."NS_Order Code" := JobPlanLines."Job Task No.";
                        JobMatPlan1.NS_Type := AssemBOMRec.NS_Type;
                        JobMatPlan1."NS_Part No." := AssemBOMRec."NS_No.";
                        // JobMatPlan1.NS_Description := AssemBOMRec.NS_Description; //new //PRJ-838 COMMENT
                        JobMatPlan1.NS_Description := AssemBOMRec."NS_Description New"; //PRJ-838 ADD
                        if item1.Get(AssemBOMRec."NS_No.") then begin
                            JobMatPlan1.NS_Description := item1.Description;
                            //JobMatPlan1."NS_Unit Cost" := item1."Unit Cost";//PRJ-563.AS.4.0 23JUN2021 Comment
                        end;
                        if ResourceRec.Get(AssemBOMRec."NS_No.") then begin
                            JobMatPlan1.NS_Description := ResourceRec.Name;
                            //JobMatPlan1."NS_Unit Cost" := ResourceRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021 Comment
                        end;
                        JobMatPlan1."NS_Unit Cost" := AssemBOMRec."NS_Unit Cost";//PRJ-563.AS.4.0 23JUN2021 Add
                        JobMatPlan1.NS_Quantity := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                        if Jobs.GET(JobPlanLines."Job No.") then begin
                            if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                JobMatPlan1."NS_Customer Account Name" := Contact.Name;

                            if Resource1.GET(Jobs."Person Responsible") then
                                "NS_Job Manager" := Resource1.Name
                            else
                                "NS_Job Manager" := '';
                            JobMatPlan1."NS_Job Description" := Jobs.Description;
                        end;

                        if JobMatPlan1.NS_Type = JobMatPlan1.NS_Type::Resource then begin
                            Resource1.RESET();
                            if Resource1.GET(JobMatPlan1."NS_Part No.") then
                                if Resource1."NS_Resource is Purchasable" then begin
                                    JobMatPlan1."NS_Purchase Res. G/L" := true;
                                    JobMatPlan1.NS_Vendor := Resource1."Vendor No.";
                                end
                                else
                                    JobMatPlan1."NS_Purchase Res. G/L" := false;

                        end;

                        JobMatPlan1.VALIDATE(NS_Quantity);
                        JobMatPlan1."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                        JobMatPlan1."NS_Location Code" := JobPlanLines."Location Code";
                        JobMatPlan1."NS_Total Cost" := JobMatPlan1.NS_Quantity * JobPlanLines."Unit Cost";
                        JobMatPlan1."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                        //PRJ-563.AS.1.0 24MAY2020 start
                        JobMatPlan1."NS_Main Item" := AssemBOMRec."NS_Main Item";
                        JobMatPlan1.NS_Level := AssemBOMRec.NS_Level;
                        JobMatPlan1."NS_Item Type" := AssemBOMRec."NS_Item Type";
                        //PRJ-563.AS.1.0 24MAY2020 end
                        //PRJ-895.GK.1.0 27Aug2021 start
                        JobMatPlan1."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                        JobMatPlan1."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                        //PRJ-895.GK.1.0 27Aug2021 end
                        JobMatPlan1.INSERT;
                    //PRJ-634.AS.1.0 Added Code inside condition of Item - End
                    until AssemBOMRec.Next() = 0;//PRJ-563.AS.1.0 - CONDITION END
                END;

                //PRJ-563.AS.1.0 - CONDITION START
                //PRJ-634.AS.1.0 Added Code inside condition of Purchasable Resource - start
                AssemBOMRec.Reset();
                AssemBOMRec.SetCurrentKey("NS_Ref. JPL Parent Item No.", "NS_Item Type");
                AssemBOMRec.SetRange("NS_Job No.", JobPlanLines."Job No.");
                AssemBOMRec.SetRange(NS_Type, NS_Type::Resource);
                AssemBOMRec.SetRange("NS_Job Task No.", JobPlanLines."Job Task No.");
                AssemBOMRec.SetRange("NS_Ref. JPL Line No.", JobPlanLines."Line No.");
                if AssemBOMRec.Findset() then BEGIN
                    repeat
                        IF ResourceTbl.Get(AssemBOMRec."NS_No.") then
                            if ResourceTbl."NS_Resource is Purchasable" = true then begin
                                JobMatPlan1.INIT();
                                JobMatPlan1."NS_Worksheet Job No." := pJobNo;
                                JobMatPlan1."NS_Line No." := NS_LastLineNo(pJobNo) + 10000;
                                JobMatPlan1."NS_Document No." := JobPlanLines."Document No.";
                                JobMatPlan1."NS_Date Ordered By" := JobPlanLines."Planning Date";
                                JobMatPlan1."NS_Date Ordered By" := 0D;
                                JobMatPlan1."NS_Date Required" := JobPlanLines."Planning Date";
                                JobMatPlan1."NS_Assembly Item on Job." := AssemBOMRec."NS_Ref. JPL Parent Item No.";
                                if item1.Get(AssemBOMRec."NS_Ref. JPL Parent Item No.") then begin
                                    JobMatPlan1.NS_Manufacturer := item1."Manufacturer Code";
                                    JobMatPlan1.NS_Vendor := item1."Vendor No.";
                                    // JobMatPlan1."NS_Item Name" := item1.Description;//PRJ-838 COMMENT
                                    JobMatPlan1."NS_Item Name New" := item1.Description;//PRJ-838 ADD
                                end;
                                JobMatPlan1."NS_Quantity Per" := AssemBOMRec."NS_Quantity Per";
                                JobMatPlan1."NS_Order Code" := JobPlanLines."Job Task No.";
                                JobMatPlan1.NS_Type := AssemBOMRec.NS_Type;
                                JobMatPlan1."NS_Part No." := AssemBOMRec."NS_No.";
                                // JobMatPlan1.NS_Description := AssemBOMRec.NS_Description; //PRJ-838 COMMENT
                                JobMatPlan1.NS_Description := AssemBOMRec."NS_Description New"; //PRJ-838 ADD
                                if item1.Get(AssemBOMRec."NS_No.") then begin
                                    JobMatPlan1.NS_Description := item1.Description;
                                    // JobMatPlan1."NS_Unit Cost" := item1."Unit Cost"; //PRJ-563.AS.4.0 23JUN2021 Comment
                                end;
                                if ResourceRec.Get(AssemBOMRec."NS_No.") then begin
                                    JobMatPlan1.NS_Description := ResourceRec.Name;
                                    //  JobMatPlan1."NS_Unit Cost" := ResourceRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021 Comment
                                end;
                                JobMatPlan1."NS_Unit Cost" := AssemBOMRec."NS_Unit Cost";//PRJ-563.AS.4.0 23JUN2021 Add
                                JobMatPlan1.NS_Quantity := AssemBOMRec."NS_Quantity Per" * AssemBOMRec."NS_Quantity of Assembly Item on Job";
                                if Jobs.GET(JobPlanLines."Job No.") then begin
                                    if Contact.GET(COPYSTR(Jobs."Bill-to Customer No.", 1, 20)) then
                                        JobMatPlan1."NS_Customer Account Name" := Contact.Name;

                                    if Resource1.GET(Jobs."Person Responsible") then
                                        "NS_Job Manager" := Resource1.Name
                                    else
                                        "NS_Job Manager" := '';
                                    JobMatPlan1."NS_Job Description" := Jobs.Description;
                                end;

                                if JobMatPlan1.NS_Type = JobMatPlan1.NS_Type::Resource then begin
                                    Resource1.RESET();
                                    if Resource1.GET(JobMatPlan1."NS_Part No.") then
                                        if Resource1."NS_Resource is Purchasable" then begin
                                            JobMatPlan1."NS_Purchase Res. G/L" := true;
                                            JobMatPlan1.NS_Vendor := Resource1."Vendor No.";
                                        end
                                        else
                                            JobMatPlan1."NS_Purchase Res. G/L" := false;

                                end;

                                JobMatPlan1.VALIDATE(NS_Quantity);
                                JobMatPlan1."NS_Job Plannine Line No." := JobPlanLines."Line No.";
                                JobMatPlan1."NS_Location Code" := JobPlanLines."Location Code";
                                JobMatPlan1."NS_Total Cost" := JobMatPlan1.NS_Quantity * JobPlanLines."Unit Cost";
                                JobMatPlan1."NS_Segment Code" := JobPlanLines."NS_Segment Code";
                                //PRJ-563.AS.1.0 24MAY2020 start
                                JobMatPlan1."NS_Main Item" := AssemBOMRec."NS_Main Item";
                                JobMatPlan1.NS_Level := AssemBOMRec.NS_Level;
                                JobMatPlan1."NS_Item Type" := AssemBOMRec."NS_Item Type";
                                //PRJ-563.AS.1.0 24MAY2020 end
                                //PRJ-895.GK.1.0 27Aug2021 start
                                JobMatPlan1."NS_Use Tax Amount" := JobPlanLines."NS_Use Tax Amount";
                                JobMatPlan1."NS_Use Tax SKU" := JobPlanLines."NS_Use Tax SKU";
                                //PRJ-895.GK.1.0 27Aug2021 end
                                JobMatPlan1.INSERT;

                            end;
                    until AssemBOMRec.Next() = 0;
                End;
            //PRJ-563.AS.1.0 - CONDITION END
            //PRJ-634.AS.1.0 Added Code inside condition of Purchasable Resource - End

            until JobPlanLines.NEXT() = 0;
    end;


    procedure NS_ExportToExcel(pJobNo: Code[20]);
    begin
    end;

    procedure ImportFromExcel(pJobNo: Code[20]);
    begin
    end;

    procedure NS_ItemAvail();
    var
        //iQuantity: Decimal;
        JobJnlLine: Record "Job Journal Line";
        ILE: Record "Item Ledger Entry";
    begin
        if NS_Type = NS_Type::Item then begin
            JobJnlLine.RESET();
            JobJnlLine.SETCURRENTKEY("Job No.", Type, "No.");
            JobJnlLine.SETRANGE(Type, JobJnlLine.Type::Item);
            JobJnlLine.SETRANGE("No.", "NS_Part No.");
            JobJnlLine.CALCSUMS(Quantity);
            ILE.RESET();
            ILE.SETRANGE("Item No.", "NS_Part No.");
            ILE.CALCSUMS(Quantity);
            if (ILE.Quantity - JobJnlLine.Quantity) < 0 then
                "NS_Inv. Avail" := 0
            else
                "NS_Inv. Avail" := ILE.Quantity - JobJnlLine.Quantity;
        end;
    end;

    procedure NS_MakeResourcePurchDoc(VendorNo: Code[20]; TrueFalse: Boolean; LineType: Option Resource,Item,"G/L Account",Text,"Resource (Group)",Template);
    var
        PurchaseHeader: Record "Purchase Header";
        JobMaterialPlanning: Record "NS_Job Material Planning";
        lJob: Record Job;

        //Job: Record Job;
        PurchSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        //VendLedgerEntry: Record "Vendor Ledger Entry";
        //SalesInvoiceLine: Record "Sales Invoice Line";
        //SalesCrMemoLine: Record "Sales Cr.Memo Line";
        NoSeriesRelationship: Record "No. Series Relationship";
        //SubconDtl: Record "Subcontract Lines";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        //PreviousRetention: Decimal;
        //RetBalance: Decimal;
        //Used: Boolean;
        Go: Boolean;
        //PurchaseDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        PurchaseDocumentNo: Code[20];
        //FirstJobNo: Code[20];
        //Text0001Lbl: Label 'There is no value to this Subcontract.\No purchase document can be created.';
        Text0002Lbl: Label 'Purchase order document creation stopped.';
        Text0003Lbl: Label 'Purchase invoice document creation stopped.';
        Text0004Lbl: Label '"Purchase Order "';
        Text0005Lbl: Label '"Purchase Invoice "';
        Text0006Lbl: Label '" created from Job Material Planning.\\Would you like to go there now?"';
    begin
        JobsSetup.GET();
        JobMaterialPlanning.SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
        JobMaterialPlanning.SETRANGE(NS_Type, LineType);
        JobMaterialPlanning.SETRANGE("NS_Purchase Res. G/L", true);
        JobMaterialPlanning.SETRANGE(NS_Vendor, VendorNo);
        // if JobMaterialPlanning.IsEmpty then begin //PPAL-50.SK.1.0 Blocked
        IF JobMaterialPlanning.FINDSET(TRUE, FALSE) then begin //PPAL-50.SK.1.0 Added
            JobsSetup.GET();
            PurchaseHeader.INIT();
            case JobsSetup."NS_PurchaseResourceswithOrders" of
                JobsSetup."NS_PurchaseResourceswithOrders"::Invoice:

                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;


                JobsSetup."NS_PurchaseResourceswithOrders"::Order:

                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order
            end;

            PurchaseHeader."Buy-from Vendor No." := VendorNo;
            PurchSetup.GET();
            lJob.GET("NS_Worksheet Job No.");
            if PurchaseHeader."No." = '' then
                case PurchaseHeader."Document Type" of
                    PurchaseHeader."Document Type"::Order:
                        begin
                            PurchSetup.TESTFIELD("Order Nos.");
                            NoSeriesRelationship.RESET();
                            NoSeriesRelationship.SETRANGE(Code, PurchSetup."Order Nos.");
                            if NoSeriesRelationship.COUNT > 1 then begin
                                if NoSeriesMgt.SelectSeries(PurchSetup."Order Nos.", PurchaseHeader."No. Series", PurchaseHeader."No. Series") then
                                    PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text0002Lbl);
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
                                if NoSeriesMgt.SelectSeries(PurchSetup."Invoice Nos.", PurchaseHeader."No. Series", PurchaseHeader."No. Series") then
                                    PurchaseDocumentNo := NoSeriesMgt.GetNextNo(PurchaseHeader."No. Series", WORKDATE(), true)
                                else
                                    ERROR(Text0003Lbl);
                            end else
                                NoSeriesMgt.InitSeries(PurchSetup."Invoice Nos.", '', WORKDATE(), PurchaseDocumentNo, PurchaseHeader."No. Series");
                            //Get Receiving No.
                            if PurchSetup."Receipt on Invoice" then begin
                                PurchSetup.TESTFIELD("Posted Receipt Nos.");
                                PurchaseHeader."Receiving No. Series" := PurchSetup."Posted Receipt Nos.";
                            end;
                        end;
                end;

            PurchaseHeader."No." := PurchaseDocumentNo;
            PurchaseHeader.InitRecord();
            PurchaseHeader.VALIDATE("Buy-from Vendor No.");
            PurchaseHeader."NS_Retention Date" := CALCDATE(JobsSetup."NS_Sales Retention Period", PurchaseHeader."Document Date");
            PurchaseHeader."Shortcut Dimension 1 Code" := lJob."Global Dimension 1 Code";
            PurchaseHeader."Shortcut Dimension 2 Code" := lJob."Global Dimension 2 Code";
            PurchaseHeader.VALIDATE("NS_Retention Amount");
            PurchaseHeader."NS_Job No." := "NS_Worksheet Job No.";
            PurchaseHeader."NS_Job Name" := lJob.Description;//PRJ-404.AM.1.0 
            PurchaseHeader.INSERT();

            //Set up Purchase Lines
            NS_MakeResourcePurchDocLines(PurchaseHeader, LineType, VendorNo);

            //Show appropriate completion message
            if TrueFalse then begin
                Go := false;
                case PurchaseHeader."Document Type" of
                    PurchaseHeader."Document Type"::Order:
                        begin
                            Go := CONFIRM(Text0004Lbl + PurchaseHeader."No." + Text0006Lbl, true);
                            if Go then
                                PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader);
                        end;
                    PurchaseHeader."Document Type"::Invoice:
                        begin
                            Go := CONFIRM(Text0005Lbl + PurchaseHeader."No." + Text0006Lbl, true);
                            if Go then
                                PAGE.RUN(PAGE::"Purchase Invoice", PurchaseHeader);
                        end;
                end;
            end;
        end;
    end;

    procedure NS_MakeResourcePurchDocLines(PurchaseHeader: Record "Purchase Header"; LineType: Option Resource,Item,"G/L Account",Text,"Resource (Group)",Template; VendorNo: Code[20]);
    var
        PurchaseLine: Record "Purchase Line";
        JobPlanLine: Record "Job Planning Line";

        JobMatPlan: Record "NS_Job Material Planning";
        lResource: Record Resource;
        //SubcontractDetail: Record "Subcontract Lines";
        LineNumber: Integer;


    begin
        //Create Normal Payables Document Lines
        PurchaseLine.RESET();
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FINDLAST() then
            LineNumber := PurchaseLine."Line No."
        else
            LineNumber := 0;

        RESET();
        SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
        case LineType of
            LineType::Resource:
                JobMatPlan.SETFILTER(NS_Type, '%1', NS_Type::Resource);
            LineType::"G/L Account":
                JobMatPlan.SETFILTER(NS_Type, '%1', NS_Type::"G/L Account");
        end;
        JobMatPlan.SETRANGE("NS_Purchase Res. G/L", true);
        JobMatPlan.SETRANGE(NS_Vendor, VendorNo);
        JobMatPlan.SETFILTER("NS_Bal. Req", '<>%1', 0);
        if JobMatPlan.FINDSET(true, false) then
            repeat
                //Build the purchase line
                PurchaseLine.INIT();
                PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                if LineType = LineType::Resource then begin
                    if lResource.GET(JobMatPlan."NS_Part No.") then
                        PurchaseLine."Buy-from Vendor No." := lResource."Vendor No.";
                end else
                    PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                PurchaseLine."Document No." := PurchaseHeader."No.";
                LineNumber := LineNumber + 10000;
                PurchaseLine."Line No." := LineNumber;
                case NS_Type of
                    JobMatPlan.NS_Type::Resource:
                        PurchaseLine.Type := PurchaseLine.Type::Resource;
                    JobMatPlan.NS_Type::"G/L Account":
                        PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                end;
                if PurchaseLine.Type.AsInteger() <> 0 then begin
                    PurchaseLine.VALIDATE(Type);
                    PurchaseLine."No." := JobMatPlan."NS_Part No.";
                    PurchaseLine.VALIDATE("No.");
                    PurchaseLine."Expected Receipt Date" := JobMatPlan."NS_Date Ordered By";
                    PurchaseLine.Description := JobMatPlan.NS_Description;
                    PurchaseLine.Quantity := JobMatPlan."NS_Bal. Req";
                    lResource.RESET();
                    if lResource.GET(JobMatPlan."NS_Part No.") then begin
                        PurchaseLine."Unit of Measure" := lResource."Base Unit of Measure";
                        PurchaseLine."Direct Unit Cost" := lResource."Unit Cost";
                        PurchaseLine.VALIDATE("Unit Cost (LCY)", lResource."Unit Cost");
                        PurchaseLine."Qty. per Unit of Measure" := 1;
                    end;
                    PurchaseLine."NS_JMP Document No." := JobMatPlan."NS_Document No.";
                    PurchaseLine."Quantity (Base)" := JobMatPlan."NS_Bal. Req";
                    PurchaseLine.VALIDATE(Quantity);
                    PurchaseLine."Currency Code" := PurchaseHeader."Currency Code";
                    PurchaseLine."Job No." := JobMatPlan."NS_Worksheet Job No.";
                    JobPlanLine.RESET();
                    JobPlanLine.SETRANGE("Job No.", JobMatPlan."NS_Worksheet Job No.");
                    JobPlanLine.SETRANGE("Job Task No.", JobMatPlan."NS_Order Code");
                    JobPlanLine.SETRANGE(Type, JobPlanLine.Type::Resource);
                    JobPlanLine.SETRANGE("No.", JobMatPlan."NS_Part No.");
                    if JobPlanLine.FINDFIRST() then
                        PurchaseLine."NS_Job Cost Category" := JobPlanLine."NS_Cost Category";
                    PurchaseLine."Job Task No." := JobMatPlan."NS_Order Code";
                    if PurchaseHeader."NS_Retention Percent" > 0 then
                        PurchaseLine."NS_Retention Applies" := true;
                    PurchaseLine."NS_JMP Details" := JobMatPlan.NS_Details;
                end;
                PurchaseLine.INSERT();
                JobMatPlan."NS_PO Qty" += PurchaseLine.Quantity;
                JobMatPlan.NS_UpdateBalReq(JobMatPlan);
                if JobMatPlan."NS_Bal. Req" = 0 then
                    JobMatPlan."NS_Purchase Res. G/L" := false;
                JobMatPlan.MODIFY();
            until JobMatPlan.NEXT() = 0;
    end;

    procedure NS_LookupVendor(VAR Vend: Record Vendor; PreferItemVendorCatalog: Boolean): Boolean //PRJ-130.MS.1.0 new func.
    var
        ItemVend: Record "Item Vendor";
        LookupThroughItemVendorCatalog: Boolean;
        IsHandled: Boolean;
        IsVendorSelected: Boolean;
    begin
        IF (NS_Type = NS_Type::Item) AND ItemVend.READPERMISSION THEN BEGIN
            ItemVend.INIT;
            ItemVend.SETRANGE("Item No.", "NS_Part No.");
            ItemVend.SETRANGE("Vendor No.", NS_Vendor);
            IF NOT ItemVend.FINDLAST THEN BEGIN
                ItemVend."Item No." := "NS_Part No.";
                ItemVend."Vendor No." := NS_Vendor;
            END;
            ItemVend.SETRANGE("Vendor No.");
            LookupThroughItemVendorCatalog := NOT ItemVend.ISEMPTY OR PreferItemVendorCatalog;
        END;

        IF LookupThroughItemVendorCatalog THEN BEGIN
            IF PAGE.RUNMODAL(0, ItemVend) = ACTION::LookupOK THEN
                EXIT(Vend.GET(ItemVend."Vendor No."));
        END ELSE BEGIN
            Vend."No." := NS_Vendor;
            EXIT(PAGE.RUNMODAL(0, Vend) = ACTION::LookupOK);
        END;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_CopyPlanningLines(var Job: Record Job; var pJobNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateJobMaterialLineBeforeValidateQuantity(var JobMaterialPlanning: Record "NS_Job Material Planning"; JobPlanningLine: Record "Job Planning Line")
    begin
        // >> pv00.00
        // << pv00.00
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNS_CopyPlanningLines(var JobMatPlan: Record "NS_Job Material Planning"; var JobPlanningLine: Record "Job Planning Line")
    begin
    end;

    // << Upgrade
}

