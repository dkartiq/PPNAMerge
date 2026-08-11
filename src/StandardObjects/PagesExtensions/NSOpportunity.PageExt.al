pageextension 14021195 NS_Opportunity extends "Opportunity Card"
{
    //PE-6.NK.1.0 24Mar2022 | Add Two fields
    layout
    {
        addbefore(Status)
        {
            //PE-6.NK.1.0 24Mar2022 Start
            field(NS_JobQuoteNo; Rec.NS_JobQuoteNo)
            {
                ApplicationArea = all;
                ToolTip = 'Job Quote No.';
                trigger OnLookup(var Text: Text): Boolean
                var
                    JobQuoteHeader: Record "NS_Job Quote Header";
                    JobSetup: Record "Jobs Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    JobQuoteNo: Code[20];
                    OpportunityEntry: Record "Opportunity Entry";
                    Customer: Record Customer;
                    ContactBusinessRelation: Record "Contact Business Relation";
                begin
                    if Rec.NS_JobQuoteNo <> '' then begin
                        JobQuoteHeader.Reset();
                        JobQuoteHeader.SetRange("NS_Quote No.", Rec.NS_JobQuoteNo);
                        PAGE.RUNMODAL(PAGE::"NS_Job Quote", JobQuoteHeader);
                    end else begin
                        if not Confirm('Do you want to Create Job Quote?', false) then
                            exit;
                        // OpportunityEntry.Reset();
                        // OpportunityEntry.SetRange("Opportunity No.", Rec."No.");
                        // OpportunityEntry.SetRange(NS_QuoteRequired, true);
                        // if OpportunityEntry.IsEmpty then
                        //     Error('Please select Quote Required in Sales Cycle Stages.');
                        if JobSetup.Get() then;
                        JobQuoteNo := NoSeriesMgt.GetNextNo(JobSetup."NS_Job Quote No. Series", Today, true);
                        JobQuoteHeader.Init();
                        JobQuoteHeader.validate("NS_Quote No.", JobQuoteNo);
                        JobQuoteHeader.Validate("NS_Contact No.", Rec."Contact No.");
                        JobQuoteHeader.Validate("NS_Job No.", JobQuoteNo);
                        JobQuoteHeader.NS_Opportunity := Rec."No.";
                        // ContactBusinessRelation.Reset();
                        // ContactBusinessRelation.SetRange("Contact No.", rec."Contact No.");
                        // if ContactBusinessRelation.FindFirst() then
                        //     JobQuoteHeader.validate("NS_Sell-to Customer No.", ContactBusinessRelation."No.");
                        Customer.Reset();
                        Customer.SetRange("Primary Contact No.", Rec."Contact No.");
                        if Customer.FindFirst() then
                            JobQuoteHeader.Validate("NS_Sell-to Customer No.", Customer."No.");
                        JobQuoteHeader.validate("NS_Salesperson Code New", Rec."Salesperson Code");
                        if JobQuoteHeader.Insert(true) then begin
                            Rec.NS_JobQuoteNo := JobQuoteNo;
                            Rec.Modify();
                        end;
                        Commit();
                        JobQuoteHeader.Reset();
                        JobQuoteHeader.SetRange("NS_Quote No.", Rec.NS_JobQuoteNo);
                        PAGE.RUNMODAL(PAGE::"NS_Job Quote", JobQuoteHeader);
                    end;
                end;
            }
            field(NS_JobOrderNo; Rec.NS_JobOrderNo)
            {
                ApplicationArea = all;
                ToolTip = 'Job No.';
            }
            //PE-6.NK.1.0 24Mar2022 End
        }
        addafter("Segment No.")
        {
            field("NS_Contract Price"; Rec."NS_Contract Price")
            {
                ApplicationArea = all;
                ToolTip = 'Contact Price';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Show Sales Quote")
        {
            //PE-6.NK.1.0 24Mar2022 Start
            action(NS_CreateJobQuote)
            {
                ApplicationArea = all;
                ToolTip = 'New Job Quote';
                Caption = 'New Job Quote';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    JobQuoteHeader: Record "NS_Job Quote Header";
                    JobSetup: Record "Jobs Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    JobQuoteNo: Code[20];
                    OpportunityEntry: Record "Opportunity Entry";
                    Customer: Record Customer;
                    ContactBusinessRelation: Record "Contact Business Relation";
                begin
                    if Rec.NS_JobQuoteNo <> '' then
                        Error('Job Quote is already exists.');
                    if not Confirm('Do you want to Create Job Quote?', false) then
                        exit;
                    // OpportunityEntry.Reset();
                    // OpportunityEntry.SetRange("Opportunity No.", Rec."No.");
                    // OpportunityEntry.SetRange(NS_QuoteRequired, true);
                    // if OpportunityEntry.IsEmpty then
                    //     Error('Please select Quote Required in Sales Cycle Stages.');
                    if JobSetup.Get() then;
                    JobQuoteNo := NoSeriesMgt.GetNextNo(JobSetup."NS_Job Quote No. Series", Today, true);
                    JobQuoteHeader.Init();
                    JobQuoteHeader.validate("NS_Quote No.", JobQuoteNo);
                    JobQuoteHeader.Validate("NS_Contact No.", Rec."Contact No.");
                    JobQuoteHeader.Validate("NS_Job No.", JobQuoteNo);
                    JobQuoteHeader.NS_Opportunity := Rec."No.";
                    // ContactBusinessRelation.Reset();
                    // ContactBusinessRelation.SetRange("Contact No.", rec."Contact No.");
                    // if ContactBusinessRelation.FindFirst() then
                    //     JobQuoteHeader.validate("NS_Sell-to Customer No.", ContactBusinessRelation."No.");
                    Customer.Reset();
                    Customer.SetRange("Primary Contact No.", Rec."Contact No.");
                    if Customer.FindFirst() then
                        JobQuoteHeader.Validate("NS_Sell-to Customer No.", Customer."No.");
                    JobQuoteHeader.validate("NS_Salesperson Code New", Rec."Salesperson Code");
                    if JobQuoteHeader.Insert(true) then begin
                        Rec.NS_JobQuoteNo := JobQuoteNo;
                        Rec.Modify();
                    end;
                    Commit();
                    JobQuoteHeader.Reset();
                    JobQuoteHeader.SetRange("NS_Quote No.", Rec.NS_JobQuoteNo);
                    PAGE.RUNMODAL(PAGE::"NS_Job Quote", JobQuoteHeader);
                end;
            }
            action(NS_ViewJobQuote)
            {
                ApplicationArea = all;
                ToolTip = 'Specify the View Job Quote';
                Caption = 'View Job Quote';
                Image = ViewJob;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    NS_JobQuoteHead: Record "NS_Job Quote Header";
                begin
                    NS_JobQuoteHead.Reset();
                    NS_JobQuoteHead.SetRange("NS_Quote No.", Rec.NS_JobQuoteNo);
                    PAGE.RUNMODAL(PAGE::"NS_Job Quote", NS_JobQuoteHead);
                end;
            }
            //PE-6.NK.1.0 24Mar2022 End   
            action(NS_CreateJobOrder)
            {
                ApplicationArea = all;
                ToolTip = 'New Job Order';
                Caption = 'New Job Order';
                Image = CreateDocument;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    RecJob: Record Job;
                    JobSetup: Record "Jobs Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    JobQuoteNo: Code[20];
                    OpportunityEntry: Record "Opportunity Entry";
                    Customer: Record Customer;
                    ContactBusinessRelation: Record "Contact Business Relation";
                begin
                    // if Rec.NS_JoborderNo <> '' then
                    // Error('Sorry! Job Order is already created.');
                    if not Confirm('Do you want to Create Job Order?', false) then
                        exit;
                    // OpportunityEntry.Reset();
                    // OpportunityEntry.SetRange("Opportunity No.", Rec."No.");
                    // OpportunityEntry.SetRange(NS_QuoteRequired, true);
                    // if OpportunityEntry.IsEmpty then
                    //     Error('Please select Quote Required in Sales Cycle Stages.');
                    if JobSetup.Get() then;
                    JobQuoteNo := NoSeriesMgt.GetNextNo(JobSetup."Job Nos.", Today, true);
                    RecJob.Init();
                    RecJob.validate("No.", JobQuoteNo);
                    RecJob.Validate("NS_Contract No.", rec."Contact No.");
                    RecJob.NS_Opportunity := Rec."No.";
                    // ContactBusinessRelation.Reset();
                    // ContactBusinessRelation.SetRange("Contact No.", rec."Contact No.");
                    // if ContactBusinessRelation.FindFirst() then
                    //     RecJob.validate("NS_Sell-to Customer No.", ContactBusinessRelation."No.");
                    Customer.Reset();
                    Customer.SetRange("Primary Contact No.", Rec."Contact No.");
                    if Customer.FindFirst() then
                        RecJob.Validate("NS_Sell-to Customer No.", Customer."No.");
                    RecJob.validate("NS_Salesperson Code", Rec."Salesperson Code");
                    if RecJob.Insert() then begin
                        Rec.NS_JoborderNo := JobQuoteNo;
                        Rec.Modify();
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}