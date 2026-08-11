table 14021100 "NS_JMP Journal Line"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    //PRJ-659.RM.1.0 06-OCT-2021  | Updated Table's Caption
    Caption = 'JMP Journal Line'; //PRJ-659.RM.1.0 06-OCT-2021 
    fields
    {
        field(1; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
        }
        field(2; "NS_JMP Line No."; Integer)
        {
            Caption = 'JMP Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "NS_JMP Document No."; Code[20])
        {
            Caption = 'JMP Document No.';
            DataClassification = CustomerContent;
        }
        field(4; NS_Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = Resource,Item;
            OptionCaption = 'Resource,Item';
        }
        field(5; "NS_No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (NS_Type = CONST(Item)) Item
            ELSE
            IF (NS_Type = CONST(Resource)) Resource;
        }
        field(6; NS_Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(7; NS_Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(8; "NS_Bal. Req"; Decimal)
        {
            Caption = 'Bal. Req';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "NS_User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(10; "NS_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(11; "NS_Date Ordered By"; Date)
        {
            Caption = 'Date Ordered By';
            DataClassification = CustomerContent;
        }
        field(12; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(13; NS_Details; Text[100])
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Job No.", "NS_JMP Line No.")
        {

        }
    }

    fieldgroups
    {
    }

    procedure CleanupJournal(UserID: Code[50]);
    var
        JMPJournalLine: Record "NS_JMP Journal Line";
    begin
        JMPJournalLine.SETRANGE("NS_Job No.", "NS_Job No.");
        JMPJournalLine.SETRANGE("NS_User ID", UserID);
        if JMPJournalLine.FINDSET() then
            JMPJournalLine.DELETEALL();
    end;

    procedure LoadJournalLines(JobNo: Code[20]);
    var
        JMP: Record "NS_Job Material Planning";
        JournalLine: Record "NS_JMP Journal Line";
    begin
        JMP.SETRANGE("NS_Worksheet Job No.", JobNo);
        JMP.SETRANGE("NS_Purchase Res. G/L", true);
        JMP.SETFILTER("NS_Bal. Req", '>%1', 0);
        if JMP.FINDSET() then
            repeat
                JournalLine.INIT();
                JournalLine."NS_Job No." := JMP."NS_Worksheet Job No.";
                JournalLine."NS_JMP Line No." := JMP."NS_Line No.";
                JournalLine."NS_JMP Document No." := JMP."NS_Document No.";
                JournalLine.NS_Type := JMP.NS_Type;
                JournalLine."NS_No." := JMP."NS_Part No.";
                JournalLine.NS_Description := JMP.NS_Description;
                JournalLine.NS_Quantity := JMP."NS_Bal. Req";
                JournalLine."NS_Bal. Req" := JMP."NS_Bal. Req";
                JournalLine."NS_User ID" := USERID();
                JournalLine."NS_Vendor No." := JMP.NS_Vendor;
                JournalLine."NS_Date Ordered By" := JMP."NS_Date Ordered By";
                JournalLine."NS_Job Task No." := JMP."NS_Order Code";
                JournalLine.NS_Details := JMP.NS_Details;
                JournalLine.INSERT(true);
            until JMP.NEXT() = 0;
    end;

    procedure NS_CreatePurchaseOrders(JobNo: Code[20]; UserID: Code[50]);
    var
        JournalLine: Record "NS_JMP Journal Line";
        Resource: Record Resource;
        JMP: Record "NS_Job Material Planning";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        JobSetup: Record "Jobs Setup";
        Job: Record Job;
        TempVendor: Record Vendor temporary;
        Text001_Msg: Label 'Purchase Documents have been created';
        LineNo: Integer;


    begin

        //determine unique vendors
        JournalLine.SETRANGE("NS_Job No.", JobNo);
        JournalLine.SETRANGE("NS_User ID", UserID);
        JournalLine.SETFILTER(NS_Quantity, '<>%1', 0);
        if JournalLine.FINDSET() then begin
            TempVendor.DELETEALL();
            repeat
                if not TempVendor.GET(JournalLine."NS_Vendor No.") then begin
                    TempVendor.INIT();
                    TempVendor."No." := JournalLine."NS_Vendor No.";
                    TempVendor.INSERT();
                end;
            until JournalLine.NEXT() = 0;
        end;

        TempVendor.RESET();
        if TempVendor.FINDSET() then begin
            JobSetup.GET();

            repeat
                Job.GET(JobNo);

                //create purchase header
                PurchHeader.INIT();
                case JobSetup.NS_PurchaseResourcesWithOrders of
                    JobSetup.NS_PurchaseResourcesWithOrders::Invoice:
                        PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;

                    JobSetup.NS_PurchaseResourcesWithOrders::Order:
                        PurchHeader."Document Type" := PurchHeader."Document Type"::Order
                end;
                PurchHeader.VALIDATE("Buy-from Vendor No.", TempVendor."No.");
                PurchHeader.INSERT(true);
                PurchHeader."NS_Retention Date" := CALCDATE(JobSetup."NS_Sales Retention Period", PurchHeader."Document Date");
                PurchHeader.VALIDATE("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
                PurchHeader.VALIDATE("Shortcut Dimension 2 Code", Job."Global Dimension 2 Code");
                PurchHeader."NS_Job No." := JobNo;
                PurchHeader.MODIFY();

                //create purchase lines
                LineNo := 10000;
                JournalLine.RESET();
                JournalLine.SETRANGE("NS_Job No.", JobNo);
                JournalLine.SETRANGE("NS_User ID", UserID);
                JournalLine.SETFILTER(NS_Quantity, '<>%1', 0);
                JournalLine.SETRANGE("NS_Vendor No.", TempVendor."No.");
                if JournalLine.FINDSET() then
                    repeat
                        PurchLine.INIT();
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine."Document No." := PurchHeader."No.";
                        if JournalLine.NS_Type = JournalLine.NS_Type::Resource then begin
                            if Resource.GET(JournalLine."NS_No.") then
                                PurchLine."Buy-from Vendor No." := Resource."Vendor No.";
                        end else
                            PurchLine."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                        case JournalLine.NS_Type of
                            JournalLine.NS_Type::Item:
                                PurchLine.Type := PurchLine.Type::Item;
                            JournalLine.NS_Type::Resource:
                                PurchLine.Type := PurchLine.Type::Resource;
                        end;

                        PurchLine.VALIDATE(Type);
                        PurchLine.VALIDATE("No.", JournalLine."NS_No.");
                        PurchLine."Expected Receipt Date" := JournalLine."NS_Date Ordered By";
                        PurchLine."Quantity (Base)" := JournalLine.NS_Quantity;
                        PurchLine.Quantity := JournalLine.NS_Quantity;
                        //PurchLine.Description := JournalLine.Description;
                        if (JournalLine.NS_Type = JournalLine.NS_Type::Resource) and Resource.GET(JournalLine."NS_No.") then begin
                            PurchLine."Unit of Measure" := Resource."Base Unit of Measure";
                            PurchLine."Direct Unit Cost" := Resource."Direct Unit Cost";
                            PurchLine.VALIDATE("Unit Cost (LCY)", Resource."Unit Cost");
                            PurchLine."Qty. per Unit of Measure" := 1;
                        end;
                        PurchLine."NS_JMP Document No." := JournalLine."NS_JMP Document No.";
                        PurchLine."Currency Code" := PurchHeader."Currency Code";
                        PurchLine.VALIDATE("Job No.", JournalLine."NS_Job No.");
                        PurchLine."NS_JMP Details" := JournalLine.NS_Details;
                        PurchLine."Job Task No." := JournalLine."NS_Job Task No.";
                        PurchLine.VALIDATE(Quantity);
                        PurchLine.INSERT(true);

                        JMP.SETRANGE("NS_Worksheet Job No.", JournalLine."NS_Job No.");
                        JMP.SETRANGE("NS_Line No.", JournalLine."NS_JMP Line No.");
                        if JMP.FINDFIRST() then begin
                            JMP.NS_UpdateBalReq(JMP);
                            if JMP."NS_Bal. Req" = 0 then
                                JMP."NS_Purchase Res. G/L" := false;
                            JMP.MODIFY();
                        end;
                    until JournalLine.NEXT() = 0;

            until TempVendor.NEXT() = 0;

            MESSAGE(Text001_Msg);
        end;
    end;
}

