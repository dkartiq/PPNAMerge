pageextension 14021261 NS_BlanketSalesOrderSubForm extends "Blanket Sales Order Subform"
{
    // version NAVW111.00.00.23019,NAVNA11.00.00.23019,PPNA11.00

    layout
    {
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                //ProjectPro - start
                IF Type = Type::Resource THEN BEGIN
                    NS_Resource.GET("No.");
                    "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
                END;
                //ProjectPro - end
            end;
        }

        addafter("VAT Prod. Posting Group")
        {
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }
        }
        addafter("Quantity Invoiced")
        {
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
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
    //   +     "PP Gen. Bus. Posting Group"
    //   +     "PP Gen. Prod. Posting Group"
    //   +     "PP Job No."
    //   +     "PP Job Task No."
    //   +     "PP Job Cost Category"
    //   +     "PP Job Revenue Category"
    //   +
    //   +  - Added global variable(s):
    //   +     PP_Job
    //   +     PP_Resource
    //   +
    //   +  - Modification(s):
    //   +     - No. - OnValidate() - if Type = Resource, then set default value of Job Revenue Category from related record in Resource table
    //   +     - If Job No. is blank then clear Job Task No., Job Cost Category, and Job Revenue Category
    //   +------------------------------------------------------------

}

