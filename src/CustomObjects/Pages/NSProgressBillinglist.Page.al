page 14021327 "NS_Progress Billing List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-301.AS.1.0 - Increased length
    //CTSI-121.N.S.1.0 18 Aug2020 add field manager & Person responsible
    Caption = 'Progress Billing List';
    CardPageID = "NS_Progress Billing Header";
    Editable = false;
    PageType = List;
    SourceTable = "NS_Progress Billing Header";
    SourceTableView = WHERE(NS_Status = FILTER(<> Paid));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                field("Requisition No."; Rec."NS_Requisition No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition No.';
                }
                field("Version No."; Rec."NS_Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Version No.';
                }
                field(Status; Rec.NS_Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                field("Requisition Date"; Rec."NS_Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Requisition Date';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field(JobDescription; JobDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Job Description';
                }
                field(CustNo; CustNo)
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                }
                field(CustName; CustName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field("Period To"; Rec."NS_Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Period To';
                    Visible = false;
                }
                field("Sales Document Type"; Rec."NS_Sales Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document Type';
                    Visible = false;
                }
                field("Sales Document No."; Rec."NS_Sales Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sales Document No.';
                    Visible = false;
                }
                field(Final; Rec.NS_Final)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Final';
                }
                //CTSI-121.N.S.1.0 18 Aug2020 Start
                field(Manager; Rec.NS_Manager)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the manager';
                }
                field("Person Responsible"; Rec."NS_Person Responsible")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the Person Responsible';
                }
                //CTSI-121.N.S.1.0 18 Aug2020 End

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        JobDescription := '';
        CustNo := '';
        CustName := '';
        if "NS_Job No." <> '' then
            if Job.GET("NS_Job No.") then begin
                JobDescription := Job.Description;
                CustNo := Job."Bill-to Customer No.";
                if CustNo <> '' then
                    if Customer.GET(CustNo) then
                        CustName := Customer.Name;
            end;
    end;

    var
        Job: Record Job;
        Customer: Record Customer;
        JobDescription: Text[100];//PRJ-301.AS.1.0 Incresed length from 50 to 100 chars
        CustNo: Code[20];
        CustName: Text[100];//PRJ-301.AS.1.0 Incresed length from 50 to 100 chars
        SalesDocumentType: Enum "Sales Document Type";
}

