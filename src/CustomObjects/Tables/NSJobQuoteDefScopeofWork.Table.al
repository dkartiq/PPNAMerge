table 14021413 "NS_Job Quote Def Scope of Work"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-735.JS.1.0 01Dec2021 | Add Procedure

    Caption = 'Default Scope of Work';
    DrillDownPageID = "NS_Job Quote Default SOW";
    LookupPageID = "NS_Job Quote Default SOW";

    fields
    {
        field(10; "NS_Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "NS_Code"; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(30; NS_Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; "NS_Description 2"; Text[250])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(50; NS_Selected; Boolean)
        {
            Caption = 'Selected';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Entry No.", "NS_Code")
        {
        }
    }

    fieldgroups
    {
    }

    //PRJ-735.JS.1.0 01Dec2021-Start
    procedure NS_CreateSOWLines(NS_PassJobQuoteDefSOW: Record "NS_Job Quote Def Scope of Work"; NS_JobQuoteNoGlb: code[20]; NS_SegmentCodeNoGlb: code[20])
    var
        NS_JobQuoteScopeofWork: Record "NS_Job Quote Scope of Work";
        NewNS_JobQuoteScopeofWork: Record "NS_Job Quote Scope of Work";
        NS_JobQuoteDefScopeofWork: Record "NS_Job Quote Def Scope of Work";
        NewNS_JobQuoteDefScopeofWork: Record "NS_Job Quote Def Scope of Work";
        NextLineNo: Integer;
    begin
        NS_JobQuoteDefScopeofWork.Reset();
        NS_JobQuoteDefScopeofWork.SetRange(NS_Selected, true);
        if NS_JobQuoteDefScopeofWork.FindSet() then
            repeat
                NS_JobQuoteScopeofWork.Reset();
                NS_JobQuoteScopeofWork.SetRange("NS_Quote No.", NS_JobQuoteNoGlb);
                IF NS_JobQuoteScopeofWork.FindLast() then
                    NextLineNo := NS_JobQuoteScopeofWork."NS_Line No.";

                If NextLineNo = 0 then
                    NextLineNo := 10000
                else
                    NextLineNo := NextLineNo + 10000;

                NewNS_JobQuoteScopeofWork.Init();
                NewNS_JobQuoteScopeofWork."NS_Quote No." := NS_JobQuoteNoGlb;
                NewNS_JobQuoteScopeofWork."NS_Quote Line No." := 0;
                NewNS_JobQuoteScopeofWork."NS_Line No." := NextLineNo;
                NewNS_JobQuoteScopeofWork."NS_Code" := NS_JobQuoteDefScopeofWork.NS_Code;
                NewNS_JobQuoteScopeofWork.NS_Description := NS_JobQuoteDefScopeofWork.NS_Description;
                NewNS_JobQuoteScopeofWork."NS_Description 2" := NS_JobQuoteDefScopeofWork."NS_Description 2";
                If NS_SegmentCodeNoGlb <> '' then
                    NewNS_JobQuoteScopeofWork."NS_Segment Code" := NS_SegmentCodeNoGlb;
                NewNS_JobQuoteScopeofWork.Insert();
            until NS_JobQuoteDefScopeofWork.Next() = 0;


        NewNS_JobQuoteDefScopeofWork.Reset();
        if NewNS_JobQuoteDefScopeofWork.FindSet() then
            NewNS_JobQuoteDefScopeofWork.ModifyAll(NS_Selected, false);

    end;
    //PRJ-735.JS.1.0 01Dec2021-Start    
}

