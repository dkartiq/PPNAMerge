table 14021353 "NS_ProjectPro Job Cue"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1743.NK.1.0 11Dec2022 New Fields
    //PE-92.RM.1.0 27May2023 | Added some code
    //PRJCTPR-270.HS.1.0 4Jan2023 | Added and Blocked Some Code
    //PRJCTPR-270.HS.1.0 25Jan2024 | Added new fields
    Caption = 'ProjectPro Job Cue';

    fields
    {
        field(1; "NS_Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "NS_Jobs To Complete This Month"; Integer)
        {
            CalcFormula = Count(Job WHERE("NS_Manager Job Status" = CONST(Running),
                                           "NS_Estimated Completion Date" = FIELD("NS_Date Filter")));
            Caption = 'Jobs To Complete This Month';
            FieldClass = FlowField;
        }
        field(3; "NS_Retention Invoices Due"; Integer)
        {
            Caption = 'Retention Invoices Due';
            DataClassification = CustomerContent;
        }
        field(4; "NS_Job Profit below Estimate"; Integer)
        {
            Caption = 'Job Profit below Estimate';
            DataClassification = CustomerContent;
        }
        field(5; "NS_Open Job Purchase Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("NS_Job No." = FILTER(<> ''),
                                                         "Document Type" = CONST(Order),
                                                         Status = CONST(Open)));
            Caption = 'Open Job Purchase Orders';
            FieldClass = FlowField;
        }
        field(6; "NS_Job CostExceedsContBillings"; Integer)
        {
            Caption = 'Job Cost Exceeds Cont Billings';
            DataClassification = CustomerContent;
        }
        field(20; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "NS_Date Filter2"; Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
        }

        //PRJ-1262.GK.1.0 03June2022 start
        field(22; "NS_Open Job Backlog"; Decimal)
        {
            Caption = 'Open Job Backlog';
            FieldClass = FlowField;
            CalcFormula = sum(Job."NS_Open Job Backlog" where(Status = filter(Open | Planning), "NS_Open Job Backlog" = filter(<> 0)));

        }
        //PRJ-1262.GK.1.0 03June2022 end
        //PRJ-1743.NK.1.0 21Dec2022 Start
        field(23; "NS_Purch. Documents Due Today"; Integer)
        {
            CalcFormula = Count("Vendor Ledger Entry" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                              "Due Date" = FIELD("NS_Date Filter2"),
                                                             Open = CONST(true)));
            Caption = 'Purchase Documents Due Today';
            FieldClass = FlowField;
        }
        field(24; "NS_POs Pending Approval"; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order),
                                                         Status = FILTER("Pending Approval")));
            Caption = 'POs Pending Approval';
            FieldClass = FlowField;
        }
        field(25; "NS_SOs Pending Approval"; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = CONST(Order),
                                                      Status = FILTER("Pending Approval")));
            Caption = 'SOs Pending Approval';
            FieldClass = FlowField;
        }
        field(26; "NS_Purch Invoice Due Next Week"; Integer)
        {
            CalcFormula = Count("Vendor Ledger Entry" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                             "Due Date" = FIELD("NS_Due Next Week Filter"),
                                                             Open = CONST(true)));
            Caption = 'Purch. Invoices Due Next Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "NS_Purch Discounts Next Week"; Integer)
        {
            CalcFormula = Count("Vendor Ledger Entry" WHERE("Document Type" = FILTER(Invoice | "Credit Memo"),
                                                              "Pmt. Discount Date" = FIELD("NS_Due Next Week Filter"),
                                                             Open = CONST(true)));
            Caption = 'Purchase Discounts Next Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "NS_Due Next Week Filter"; Date)
        {
            Caption = 'Due Next Week Filter';
            FieldClass = FlowFilter;
        }
        field(29; "NS_Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }

        field(32; "NS_Non-Applied Payments"; Integer)
        {
            CalcFormula = Count("Bank Acc. Reconciliation" WHERE("Statement Type" = CONST("Payment Application")));
            Caption = 'Non-Applied Payments';
            FieldClass = FlowField;
        }
        field(33; "NS_Approved Incoming Documents"; Integer)
        {
            CalcFormula = Count("Incoming Document" WHERE(Status = CONST(Released)));
            Caption = 'Approved Incoming Documents';
            FieldClass = FlowField;
        }
        field(34; "NS_OCR Completed"; Integer)
        {
            CalcFormula = Count("Incoming Document" WHERE("OCR Status" = CONST(Success)));
            Caption = 'OCR Completed';
            FieldClass = FlowField;
        }
        //PRJ-1743.NK.1.0 21Dec2022 End
        //PE-92.RM.1.0 19May2023 Start
        field(35; "NS_Job Log"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Job Log'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }

        field(36; "NS_RFQ"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('RFQ'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023 
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block

        }
        field(37; "NS_RFI"; Integer)
        {
            CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('RFI'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100)));
            Caption = '';
            FieldClass = FlowField;
        }
        field(38; NS_Submittal; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Submittal'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent;
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(39; NS_Transmittal; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Transmittal'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            ;
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(40; NS_Safety; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Safety'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(41; "NS_Other User Task"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = filter(<> 'Safety' & <> 'Job Log' & <> 'RFQ' & <> 'RFI' & <> 'Submittal' & <> 'Transmittal'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(42; "NS_Job Log1"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Job Log'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent;//PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block

        }

        field(43; "NS_RFQ1"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('RFQ'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023 
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block

        }
        field(44; "NS_RFI1"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('RFI'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023 
            // FieldClass = FlowField; //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(45; NS_Submittal1; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Submittal'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100))); //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField;  //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(46; NS_Transmittal1; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Transmittal'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100)));  //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField;  //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(47; NS_Safety1; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('Safety'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100)));  //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField;  //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(48; "NS_Other User Task1"; Integer)
        {
            // CalcFormula = count("User Task" where("User Task Group Assigned To" = filter(<> 'Safety' & <> 'Job Log' & <> 'RFQ' & <> 'RFI' & <> 'Submittal' & <> 'Transmittal'), "NS_Due Date" = field("NS_Due Date Filter2"), "Percent Complete" = filter(<> 100)));  //PRJCTPR-270.HS.1.0 4Jan2023 Block
            Caption = '';
            DataClassification = CustomerContent; //PRJCTPR-270.HS.1.0 4Jan2023
            // FieldClass = FlowField;  //PRJCTPR-270.HS.1.0 4Jan2023 Block
        }
        field(49; "NS_Due Date Filter2"; Date)
        {
            Caption = 'Due Date Filter New';
            Editable = false;
            FieldClass = FlowFilter;
        }
        //PE-92.RM.1.0 19May2023 End
        //PRJCTPR-147.Nk.1.0 start 09Aug2023

        // field(50100; "OpenChangeRequest"; Integer) //PRJCTPR-147.PS.2.0 20Sep2023 Need to change field id due to not in our PP range 
        field(14021100; "OpenChangeRequest"; Integer)
        {
            Caption = 'Open Change Request';
            FieldClass = FlowField;
            CalcFormula = Count("Job" WHERE("NS_Job Class" = filter('Change Request'), Status = CONST(Open)));
        }
        //PRJCTPR-147.Nk.1.0 end 09Aug2023

        //PRJCTPR-270.HS.1.0 25Jan2024 Start
        field(14021101; "NS_Due in 3 days"; Integer)
        {
            Caption = 'Due in 3 Days';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Due in 7 days"; Integer)
        {
            Caption = 'Due in 7 Days';
            DataClassification = CustomerContent;
        }

        field(14021103; "NS_Due in More than 7 days"; Integer)
        {
            Caption = 'Due in more than 7 Days';
            DataClassification = CustomerContent;
        }

        field(14021104; "NS_Total Over Due"; Integer)
        {
            Caption = 'Total Over Due';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-270.HS.1.0 25Jan2024 End

        //PE-211.AS.10.0 START
        field(50; NS_RFQ_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;
        }
        field(51; NS_RFI_FM; Integer)
        {
            CalcFormula = count("User Task" where("User Task Group Assigned To" = Const('RFI'), "NS_Due Date" = field("NS_Due Date Filter"), "Percent Complete" = filter(<> 100)));
            Caption = '';
            FieldClass = FlowField;
        }
        field(52; NS_Submittal_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(53; NS_Transmittal_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(54; NS_Subcontract_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(55; NS_SAFETY_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(56; NS_Tasks_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(57; NS_RFI11_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(58; NS_RFQ1_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(59; NS_SUBMITTAL11_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(60; NS_TRANSMITTAL11_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(61; NS_SUBCONTRACT1_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(62; NS_Safety1_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        field(63; NS_TASKS11_FM; Integer)
        {
            Caption = '';
            DataClassification = CustomerContent;

        }
        //PE-211.AS.10.0 END
    }

    keys
    {
        key(Key1; "NS_Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
    //PE-185.NC.1.0 10Oct2023 Start
    procedure NS_CalcDate(): Date;
    var
        NS_APOSetup: Record NS_APOSetup;
        NS_Date: Date;
    begin
        if NS_APOSetup.Get() then
            if Format(NS_APOSetup."NS_User task Alert No. of Days") <> '' then
                NS_Date := CALCDATE('<+' + format(NS_APOSetup."NS_User task Alert No. of Days") + '>', Today)
            else
                NS_Date := WorkDate();
        exit(NS_Date);
    end;

    procedure NS_CalcCountSeq1(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'JOB LOG');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq2(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFQ');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq3(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFI');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq4(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq5(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SAFETY');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq6(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TRANSMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq7(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NSCode2 := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
            IF NSNumberFilter.FindFirst() then
                NSCode2 := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'Other User Task');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    //PE-211.AS.2.0 START 
    procedure NS_CalcCountSeq8(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFI');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq9(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFQ');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq10(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq11(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TRANSMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq12(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBCONTRACT');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq13(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SAFETY');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_CalcCountSeq14(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NSCode2 := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
            IF NSNumberFilter.FindFirst() then
                NSCode2 := NSNumberFilter."No.";

            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TASKS');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;
    //PE-211.AS.2.0 END

    procedure NS_OverJobCount1(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'JOB LOG');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount2(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFQ');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount3(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFI');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount4(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount5(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SAFETY');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount6(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TRANSMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount7(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NSCode2 := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
            IF NSNumberFilter.FindFirst() then
                NSCode2 := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'Other User Task');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;
    //PE-185.NC.1.0 10Oct2023 End

    //PE-211.AS.1.0 START
    procedure NS_OverJobCount8(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 1);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFI');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount9(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 2);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'RFQ');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;

    procedure NS_OverJobCount10(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 3);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;


    procedure NS_OverJobCount11(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 4);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TRANSMITTAL');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;


    procedure NS_OverJobCount12(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 5);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SUBCONTRACT');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;


    procedure NS_OverJobCount13(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 6);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", NSCode);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'SAFETY');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;


    procedure NS_OverJobCount14(): Integer;
    var
        NS_UserTask: Record "User Task";
        NSNumberFilter: Record NSNumberFilter;
        NS_APOSetup: Record NS_APOSetup;
        NSCode: Code[30];
        NSCode2: Code[30];
    begin
        if NS_APOSetup.Get() then;
        if NS_APOSetup.NS_EnableUserTaskCategory then begin
            NSCode := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 0);
            IF NSNumberFilter.FindFirst() then
                NSCode := NSNumberFilter."No.";
            NSCode2 := '';
            NSNumberFilter.Reset();
            NSNumberFilter.SetRange("Document No.", 'USER');
            NSNumberFilter.SetRange(Type, NSNumberFilter.Type::"NS_User Task Category");
            NSNumberFilter.SetRange("NS_User Task Cue Sequence", 7);
            IF NSNumberFilter.FindFirst() then
                NSCode2 := NSNumberFilter."No.";
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetFilter("NS_User Task Category", '%1|%2', NSCode, NSCode2);
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', 0D, CalcDate('<-1D>'), Today);
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end else begin
            NS_UserTask.Reset();
            NS_UserTask.SetFilter("Percent Complete", '<>%1', 100);
            NS_UserTask.SetRange("NS_User Task Category", 'TASKS');
            NS_UserTask.SetFilter("NS_Due Date", '%1..%2', Today, NS_CalcDate());
            if NS_UserTask.FindFirst() then
                exit(NS_UserTask.Count);
        end;
    end;
    //PE-211.AS.1.0 END
}

