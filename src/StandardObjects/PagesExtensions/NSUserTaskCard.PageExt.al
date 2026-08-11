pageextension 14021335 NS_UserTaskCard extends "User Task Card"
{
    //PE-74.NK.1.0 10Apr2023 | Create New Page Extensions
    layout
    {
        addlast("Task Item")
        {


            field(NS_JobNo; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job No. field.';
            }
            field("NS_Task No."; Rec."NS_Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task No. field.';
            }
            field("NS_Task Category"; Rec."NS_Task Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task Category field.';
            }
            field("NS_Task Item"; Rec."NS_Task Item")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Task Item field.';
                trigger OnLookup(var Text: Text): Boolean
                var
                    JobTask: Record "Job Task";
                    NS_Subcontract: Record NS_Subcontract;
                    NS_ProgBillHead: Record "NS_Progress Billing Header";
                    NS_JobMaterialPlanning: Record "NS_Job Material Planning";
                    NS_JobQuoteHeader: Record "NS_Job Quote Header";
                begin
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Material Planning" then begin
                        NS_JobMaterialPlanning.SetRange("NS_Worksheet Job No.", Rec."NS_Job No.");
                        if PAGE.RunModal(PAGE::"NS_Job Material Planning Wksht", NS_JobMaterialPlanning) = ACTION::LookupOK then
                            Rec."NS_Task Item" := NS_JobMaterialPlanning."NS_Worksheet Job No.";
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Quote" then begin
                        //NS_JobQuoteHeader.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if PAGE.RunModal(PAGE::"NS_Job Quote List", NS_JobQuoteHeader) = ACTION::LookupOK then begin
                            Rec."NS_Task Item" := NS_JobQuoteHeader."NS_Quote No.";
                            Rec."NS_Job No." := '';
                        end;
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Task" then begin
                        JobTask.SetRange("Job No.", Rec."NS_Job No.");
                        if PAGE.RunModal(PAGE::"Job Task List", JobTask) = ACTION::LookupOK then
                            Rec."NS_Task Item" := JobTask."Job Task No.";
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::Subcontract then begin
                        NS_Subcontract.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if PAGE.RunModal(PAGE::"NS_Job Subcontract List", NS_Subcontract) = ACTION::LookupOK then
                            Rec."NS_Task Item" := NS_Subcontract."NS_No.";
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Progress Billing" then begin
                        NS_ProgBillHead.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if PAGE.RunModal(PAGE::"NS_Job Progress Billing List", NS_ProgBillHead) = ACTION::LookupOK then begin
                            Rec."NS_Task Item" := NS_ProgBillHead."NS_No." + '.' + format(NS_ProgBillHead."NS_Requisition No.") + '.' + format(NS_ProgBillHead."NS_Version No.");
                            Rec."NS_Requisition No." := NS_ProgBillHead."NS_Requisition No.";
                            Rec."NS_Version No." := NS_ProgBillHead."NS_Version No.";
                        end;
                    end;
                end;
            }
            //PE-185.NC.1.0 10Oct2023 Start
            field("NS_User Task Category"; Rec."NS_User Task Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User Task Category field.';
            }
            //PE-185.NC.1.0 10Oct2023 End
        }
    }
    actions
    {
        modify("Go To Task Item")
        {
            Visible = false;
        }
        addafter("Go To Task Item")
        {
            action("NS_Go To Task Item")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Go To Task Item';
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = True;
                Image = Navigate;
                ToolTip = 'Open the page or report that is associated with this task.';
                trigger OnAction()
                var
                    NS_Job: Record Job;
                    NS_Subcontract: Record NS_Subcontract;
                    NS_ProgessBillHead: Record "NS_Progress Billing Header";
                    JobTask: Record "Job Task";
                    NS_JobMaterialPlanning: Record "NS_Job Material Planning";
                    NS_JobQuoteHeader: Record "NS_Job Quote Header";
                begin
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::Subcontract then begin
                        NS_Subcontract.Reset();
                        NS_Subcontract.SetRange("NS_Job No.", Rec."NS_Job No.");
                        NS_Subcontract.SetRange("NS_No.", Rec."NS_Task Item");
                        PAGE.RUNMODAL(PAGE::"NS_Subcontract Card", NS_Subcontract);
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Task" then begin
                        JobTask.Reset();
                        JobTask.SetRange("Job No.", Rec."NS_Job No.");
                        PAGE.RunModal(PAGE::"Job Task List", JobTask);
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Material Planning" then begin
                        NS_JobMaterialPlanning.SetRange("NS_Worksheet Job No.", Rec."NS_Job No.");
                        Page.RunModal(Page::"NS_Job Material Planning Wksht", NS_JobMaterialPlanning);
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Job Quote" then begin
                        NS_JobQuoteHeader.SetRange("NS_Quote No.", Rec."NS_Task Item");
                        PAGE.RunModal(PAGE::"NS_Job Quote", NS_JobQuoteHeader);
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::"Progress Billing" then begin
                        NS_ProgessBillHead.Reset();
                        NS_ProgessBillHead.SetRange("NS_Job No.", Rec."NS_Job No.");
                        NS_ProgessBillHead.SetRange("NS_Requisition No.", Rec."NS_Requisition No.");
                        NS_ProgessBillHead.SetRange("NS_Version No.", Rec."NS_Version No.");
                        PAGE.RunModal(PAGE::"NS_Progress Billing Header", NS_ProgessBillHead);
                    end;
                    if Rec."NS_Task Category" = Rec."NS_Task Category"::" " then begin
                        NS_Job.Reset();
                        NS_Job.SetRange("No.", Rec."NS_Job No.");
                        Page.RunModal(Page::"Job Card", NS_Job);
                    end;
                end;
            }
        }
    }

}