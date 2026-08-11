report 14021204 "NS_Carry Out Act Msg. - Req."
{
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +     "PO by Job"
    // +
    // +  - Modification(s):
    // +     - Added "PO by Job" to Request Page.
    // +     - Updated Request Page properties to not save settings
    // +------------------------------------------------------------

    Caption = 'Job Carry Out Action Msg. - Req.';//PE-141.NK.1.0 03Aug2023 updated name
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;

    dataset
    {
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_PrintOrders; PrintOrders)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Print Orders';
                        ToolTip = 'Specifies whether to print the purchase orders after they are created.';
                    }
                    field("NS_PO by Job"; "PO by Job")
                    {
                        Caption = 'PO by Job';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PurchOrderHeader."Order Date" := WORKDATE;
            PurchOrderHeader."Posting Date" := WORKDATE;
            PurchOrderHeader."Expected Receipt Date" := WORKDATE;
            IF ReqWkshTmpl.Recurring THEN
                EndOrderDate := WORKDATE
            ELSE
                EndOrderDate := 0D;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        UseOneJnl(ReqLine);
    end;

    var
        Text000: Label 'cannot be filtered when you create orders';
        Text001: Label 'There is nothing to create.';
        Text003: Label 'You are now in worksheet %1.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        PurchOrderHeader: Record "Purchase Header";
        ReqWkshMakeOrders: Codeunit "Req. Wksh.-Make Order";
        EndOrderDate: Date;
        PrintOrders: Boolean;
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        "PO by Job": Boolean;

    procedure SetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        ReqLine.COPY(NewReqLine);
        ReqWkshTmpl.GET(NewReqLine."Worksheet Template Name");
    end;

    [Scope('Cloud')]
    procedure GetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        NewReqLine.COPY(ReqLine);
    end;

    [Scope('Cloud')]
    procedure SetReqWkshName(var NewReqWkshName: Record "Requisition Wksh. Name")
    begin
        ReqWkshName.COPY(NewReqWkshName);
        ReqWkshTmpl.GET(NewReqWkshName."Worksheet Template Name");
    end;

    local procedure UseOneJnl(var ReqLine: Record "Requisition Line")
    begin
        WITH ReqLine DO BEGIN
            ReqWkshTmpl.GET("Worksheet Template Name");
            IF ReqWkshTmpl.Recurring AND (GETFILTER("Order Date") <> '') THEN
                FIELDERROR("Order Date", Text000);
            TempJnlBatchName := "Journal Batch Name";
            ReqWkshMakeOrders.Set(PurchOrderHeader, EndOrderDate, PrintOrders);
            ReqWkshMakeOrders.CarryOutBatchAction(ReqLine);

            IF "Line No." = 0 THEN
                MESSAGE(Text001)
            ELSE
                IF NOT HideDialog THEN
                    IF TempJnlBatchName <> "Journal Batch Name" THEN
                        MESSAGE(
                          Text003,
                          "Journal Batch Name");

            IF NOT FIND('=><') OR (TempJnlBatchName <> "Journal Batch Name") THEN BEGIN
                RESET;
                FILTERGROUP := 2;
                SETRANGE("Worksheet Template Name", "Worksheet Template Name");
                SETRANGE("Journal Batch Name", "Journal Batch Name");
                FILTERGROUP := 0;
                "Line No." := 1;
            END;
        END;
    end;

    procedure InitializeRequest(ExpirationDate: Date; OrderDate: Date; PostingDate: Date; ExpectedReceiptDate: Date; YourRef: Text[50])
    begin
        EndOrderDate := ExpirationDate;
        PurchOrderHeader."Order Date" := OrderDate;
        PurchOrderHeader."Posting Date" := PostingDate;
        PurchOrderHeader."Expected Receipt Date" := ExpectedReceiptDate;
        PurchOrderHeader."Your Reference" := YourRef;
    end;

    [Scope('Cloud')]
    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

