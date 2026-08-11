pageextension 14021262 NS_BlanketPurchOrderSubForm extends "Blanket Purchase Order Subform"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,NSNA11.00

    layout
    {

        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                //ProjectPro - start
                IF Type = Type::NS_Ledger THEN BEGIN
                    NS_Resource.GET("No.");
                    "NS_Job Cost Category" := NS_Resource."NS_Job Cost Category";
                END
                //ProjectPro - end
            end;
        }

        addafter("VAT Prod. Posting Group")
        {
            field("NS Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        addafter("Quantity Invoiced")
        {
            field("NS Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_Resource: Record Resource;

    //   +------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     "NS Gen. Bus. Posting Group"
    //   +     "NS Gen. Prod. Posting Group"
    //   +     "NS Job No."
    //   +     "NS Job Task No."
    //   +     "NS Job Cost Category"
    //   +     "NS Job Revenue Category"
    //   +
    //   +  - Added global variable(s):
    //   +     NS_Job
    //   +     NS_Resource
    //   +
    //   +  - Modification(s):
    //   +     - No. - OnValidate() - set default Job Cost Category from Resource
    //   +     - OnValidate() of Job fields: If Job No. is blank then clear Job Task No., Job Cost Category, and Job Revenue Category
    //   +------------------------------------------------------------
}

