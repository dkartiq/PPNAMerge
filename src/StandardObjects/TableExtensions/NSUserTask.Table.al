tableextension 14021335 NS_UserTask extends "User Task"
{
    //PE-74.NK.1.0 10Apr2023 | Create New Table Extensions   
    //PE-92.RM.1.0 27May2023 | Added some code
    fields
    {
        //PE-92.RM.1.0 25May2023 Start
        modify("Due DateTime")
        {
            trigger OnAfterValidate()
            begin
                "NS_Due Date" := DT2Date("Due DateTime");
            end;
        }
        //PE-92.RM.1.0 25May2023 end
        field(14021100; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
            trigger OnValidate()
            begin
                if Rec."NS_Job No." <> xRec."NS_Job No." then begin
                    Rec."NS_Task Category" := Rec."NS_Task Category"::" ";
                    "NS_Task Item" := '';
                    "NS_Requisition No." := 0;
                    "NS_Version No." := 0;
                    "NS_Task No." := '';
                end;
            end;
        }
        field(14021101; "NS_Task Category"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Task Category';
            OptionCaption = ' ,Job Material Planning,Job Quote,Job Task,Progress Billing,Subcontract';
            OptionMembers = " ","Job Material Planning","Job Quote","Job Task","Progress Billing",Subcontract;
            trigger OnValidate()
            begin
                if Rec."NS_Task Category" <> xRec."NS_Task Category" then begin
                    "NS_Task Item" := '';
                    "NS_Requisition No." := 0;
                    "NS_Version No." := 0;
                end;
            end;
        }
        field(14021102; "NS_Task Item"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Task Item';
        }
        field(14021103; "NS_Requisition No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition No.';
        }
        field(14021104; "NS_Version No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Version No.';
        }
        field(14021105; "NS_Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("NS_Job No."));
        }
        //PE-92.RM.1.0 25May2023 Start
        field(14021106; "NS_Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date';
        }
        //PE-92.RM.1.0 25May2023 End
        //PE-185.NC.1.0 05Oct2023 Start
        field(14021107; "NS_User Task Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'User Task Category';
            trigger OnLookup()
            var
                NSNumberFilter: Record NSNumberFilter;
            begin
                NSNumberFilter.SetRange(type, NSNumberFilter.Type::"NS_User Task Category");
                NSNumberFilter.SetFilter("Document No.", '%1', 'USER');
                if PAGE.RunModal(PAGE::"NSUserTaskCategory", NSNumberFilter) = ACTION::LookupOK then
                    "NS_User Task Category" := NSNumberFilter."No.";
            end;
        }
        //PE-185.NC.1.0 05Oct2023 End
    }

}