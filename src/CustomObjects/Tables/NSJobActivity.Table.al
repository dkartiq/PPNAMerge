table 14021153 "NS_Job Activity"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-449.AS.1.0 19NOV2020 Increased decription length from 30 to 100 chars
    //PRJ-881.JS.1.0 24Aug2021 | Add one field
    //PRJ-917.NK.1.0 09Mar2022 | Add Three fields
    Caption = 'Job Activity';
    DrillDownPageID = "NS_Activities List";
    LookupPageID = "NS_Activities List";

    fields
    {
        field(1; NS_Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Cost,Revenue';
            OptionMembers = Cost,Revenue;
            DataClassification = CustomerContent;
        }
        field(2; "NS_Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; "NS_Search Code"; Code[10])
        {
            Caption = 'Search Code';
            DataClassification = CustomerContent;
        }
        field(4; NS_Description; Text[100])//PRJ-449.AS.1.0 19NOV2020
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "NS_Total Cost"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                     "NS_Activity Code" = FIELD(NS_Code),
                                                                     "NS_Process Code" = CONST(''),
                                                                     "NS_Operation Code" = CONST(''),
                                                                     "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                     "Entry Type" = CONST(Usage),
                                                                     "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Cost';
            FieldClass = FlowField;
        }
        field(7; "NS_Total Price"; Decimal)
        {
            CalcFormula = - Sum("Job Ledger Entry"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                       "NS_Activity Code" = FIELD(NS_Code),
                                                                       "NS_Process Code" = CONST(''),
                                                                       "NS_Operation Code" = CONST(''),
                                                                       "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                       "Entry Type" = CONST(Sale),
                                                                       "Posting Date" = FIELD("NS_Date Filter")));
            Caption = 'Total Price';
            FieldClass = FlowField;
        }
        field(8; "NS_Total Budget Cost"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                      "NS_Activity Code" = FIELD(NS_Code),
                                                                      "NS_Process Code" = CONST(''),
                                                                      "NS_Operation Code" = CONST(''),
                                                                      "NS_Entry Type" = CONST(Cost),
                                                                      "NS_Cost Category" = FIELD("NS_Cost Category Filter")));
            Caption = 'Total Budget Cost';
            FieldClass = FlowField;
        }
        field(9; "NS_Total Budget Price"; Decimal)
        {
            CalcFormula = - Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("NS_Job No. Filter"),
                                                                        "NS_Activity Code" = FIELD(NS_Code),
                                                                        "NS_Process Code" = CONST(''),
                                                                        "NS_Operation Code" = CONST(''),
                                                                        "NS_Entry Type" = CONST(Both),
                                                                        "NS_Cost Category" = FIELD("NS_Revenue Category Filter")));
            Caption = 'Total Budget Price';
            FieldClass = FlowField;
        }
        field(20; "NS_Job No. Filter"; Code[20])
        {
            Caption = 'Job No. Filter';
            FieldClass = FlowFilter;
        }
        field(21; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(22; "NS_Cost Category Filter"; Code[10])
        {
            Caption = 'Cost Category Filter';
            FieldClass = FlowFilter;
        }
        field(23; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';
            FieldClass = FlowFilter;
        }
        field(30; "NS_Default onto each Job"; Boolean)
        {
            Caption = 'Default onto each Job';
            DataClassification = CustomerContent;
        }
        field(31; "NS_Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
            DataClassification = CustomerContent;
        }
        field(32; NS_Totaling; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = CustomerContent;
        }
        field(33; "NS_New Page"; Boolean)
        {
            Caption = 'New Page';
            DataClassification = CustomerContent;
        }
        field(34; "NS_No. of Blank Lines"; Integer)
        {
            Caption = 'No. of Blank Lines';
            DataClassification = CustomerContent;
        }
        field(35; NS_Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
        }
        field(40; "NS_DefaultProjectBurdenPerc"; Decimal)
        {
            Caption = 'Default Project Burden Percent';
            DataClassification = CustomerContent;
        }
        field(41; "NS_DefaultServiceBurdenPerc"; Decimal)
        {
            Caption = 'Default Service Burden Percent';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_DefaultTaskforJobType"; Code[20])
        {
            Caption = 'Default Task for Job Type';
            TableRelation = "NS_Job Type".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Job Setup Job Quote"; Boolean)  //PRJ-881.JS.1.0  24Aug2021
        {
            Caption = 'Job Setup Job Quote';
            DataClassification = CustomerContent;
        }
        //PRJ-917.NK.1.0 09Mar2022 Start
        field(14021411; "NS_Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                JobProcess: Record "NS_Job Process";
                JobOperation: Record "NS_Job Operation";
                NS_Sections: Record NS_Sections;
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get(UserId) then;
                UserSetup.TestField("NS_Allow To Block APO");
                if NS_Blocked then begin
                    JobProcess.Reset();
                    JobProcess.SetRange("NS_Activity Code", Rec.NS_Code);
                    if JobProcess.FindFirst() then
                        repeat
                            JobProcess.NS_Blocked := true;
                            JobProcess.Modify();
                            JobOperation.Reset();
                            JobOperation.SetRange("NS_Activity Code", Rec.NS_Code);
                            JobOperation.SetRange("NS_Process Code", JobProcess.NS_Code);
                            if JobOperation.FindFirst() then
                                repeat
                                    JobOperation.NS_Blocked := true;
                                    JobOperation.Modify();
                                    NS_Sections.Reset();
                                    NS_Sections.SetRange("NS_Activity Code", Rec.NS_Code);
                                    NS_Sections.SetRange("NS_Process Code", JobProcess.NS_Code);
                                    NS_Sections.SetRange("NS_Operation Code", JobOperation.NS_Code);
                                    if NS_Sections.FindFirst() then
                                        repeat
                                            NS_Sections.NS_Blocked := true;
                                            NS_Sections.Modify();
                                        until NS_Sections.Next() = 0;
                                until JobOperation.Next() = 0;
                        until JobProcess.Next() = 0;
                end else begin
                    JobProcess.Reset();
                    JobProcess.SetRange("NS_Activity Code", Rec.NS_Code);
                    if JobProcess.FindFirst() then
                        repeat
                            JobProcess.NS_Blocked := false;
                            JobProcess.Modify();
                            JobOperation.Reset();
                            JobOperation.SetRange("NS_Activity Code", Rec.NS_Code);
                            JobOperation.SetRange("NS_Process Code", JobProcess.NS_Code);
                            if JobOperation.FindFirst() then
                                repeat
                                    JobOperation.NS_Blocked := false;
                                    JobOperation.Modify();
                                    NS_Sections.Reset();
                                    NS_Sections.SetRange("NS_Activity Code", Rec.NS_Code);
                                    NS_Sections.SetRange("NS_Process Code", JobProcess.NS_Code);
                                    NS_Sections.SetRange("NS_Operation Code", JobOperation.NS_Code);
                                    if NS_Sections.FindFirst() then
                                        repeat
                                            NS_Sections.NS_Blocked := false;
                                            NS_Sections.Modify();
                                        until NS_Sections.Next() = 0;
                                until JobOperation.Next() = 0;
                        until JobProcess.Next() = 0;

                end;
            end;
        }
        field(14021412; "NS_Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021413; "NS_Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-917.NK.1.0 09Mar2022 End

    }

    keys
    {
        key(Key1; NS_Type, "NS_Code")
        {
        }
        key(Key2; "NS_Search Code")
        {
        }
        key(Key3; "NS_Default onto each Job")
        {
        }
        key(Key4; "NS_DefaultTaskforJobType")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        JobOperation.RESET();
        JobOperation.SETRANGE(NS_Type, NS_Type);
        JobOperation.SETRANGE("NS_Activity Code", NS_Code);
        JobOperation.DELETEALL();

        JobProcess.RESET();
        JobProcess.SETRANGE(NS_Type, NS_Type);
        JobProcess.SETRANGE("NS_Activity Code", NS_Code);
        JobProcess.DELETEALL();
    end;

    trigger OnRename();
    begin
        JobProcess.RESET();
        JobProcess.SETRANGE(NS_Type, NS_Type);
        JobProcess.SETRANGE("NS_Activity Code", NS_Code);
        if JobProcess.FINDSET() then
            repeat
                JobProcess."NS_Activity Code" := NS_Code;
                JobProcess.MODIFY();
            until JobProcess.NEXT() = 0;

        JobOperation.RESET();
        JobOperation.SETRANGE(NS_Type, NS_Type);
        JobOperation.SETRANGE("NS_Activity Code", NS_Code);
        if JobOperation.FINDSET() then
            repeat
                JobOperation."NS_Activity Code" := NS_Code;
                JobOperation.MODIFY();
            until JobOperation.NEXT() = 0;
    end;
    //PRJ-917.NK.1.0 09Mar2022 Start
    trigger OnModify()
    begin
        "NS_Last Modified By" := UserId();
        "NS_Last Modified Date" := WorkDate();
    end;
    //PRJ-917.NK.1.0 09Mar2022 End    

    var
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
}

