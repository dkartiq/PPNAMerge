tableextension 14021195 NS_Opportunity extends Opportunity
{
    //PE-6.NK.1.0 24Mar2022 | Add one field
    fields
    {
        field(14021300; "NS_JobQuoteNo"; Code[20])
        {
            Caption = 'Job Quote No';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //Editable = false;
            TableRelation = "NS_Job Quote Header"."NS_Quote No.";
            trigger OnLookup()
            var
                JobQuoteHeader: Record "NS_Job Quote Header";
            begin
                JobQuoteHeader.Reset();
                JobQuoteHeader.SetRange("NS_Quote No.", Rec.NS_JobQuoteNo);
                if JobQuoteHeader.FindFirst() then
                    PAGE.RunModal(PAGE::"NS_Job Quote List", JobQuoteHeader);
            end;
        }
        field(14021301; "NS_JobOrderNo"; Code[20])
        {
            Caption = 'Job Order No';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //Editable = false;
            TableRelation = Job."No.";
            trigger OnLookup()
            var
                Job: Record Job;
            begin
                Job.Reset();
                Job.SetRange("No.", Rec.NS_JobOrderNo);
                if Job.FindFirst() then
                    PAGE.RunModal(PAGE::"Job List", Job);
            end;
        }
        field(14021302; "NS_Contract Price"; Decimal)
        {
            Caption = 'Contract Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
    }
}