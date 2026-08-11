pageextension 14021240 NS_ReqWorksheet extends "Req. Worksheet"
{
    // version NAVW111.00.00.19846,NAVNA11.00.00.19846,PPNA11.00
    //PRJ-58.SK.1.0 Added customised "CarryOutActionMessage" Action on this page.
    //TM-10.AM.1.0 | Added Field.
    //PRJ-492.RS.1.0 25May2021 | Hide/Unhide fields
    layout
    {
        addafter(CurrentJnlBatchName)
        {
            field(NS_DocNo; DocNo)
            {
                ApplicationArea = All;
                Caption = 'Document No.';

                ToolTip = 'Document No.';
            }
        }
        addafter("Transfer-from Code")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
            }
            field("NS_Job Task No."; Rec."NS_Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task No.';
            }
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = All;
                Description = 'TM-10.AM.1.0';
                //Visible = false;//PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
            }
        }
    }
    actions
    {

        modify(CalculatePlan)
        {
            Visible = false;
            Enabled = false;
        }
        //PRJ-58.SK.1.0 Start
        modify(CarryOutActionMessage)
        {
            Visible = false;
            Enabled = false;
        }
        addafter(Reserve)
        {
            action(NS_CarryOutActionMessage)
            {
                Caption = 'Carry &Out Action Message';
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';
                ApplicationArea = Planning;
                Image = CarryOutActionMessage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Ellipsis = true;

                trigger OnAction()
                var
                    PerformAction: report "NS_Carry Out Act Msg. - Req.";

                begin
                    PerformAction.SetReqWkshLine(Rec);
                    PerformAction.RUNMODAL;
                    PerformAction.GetReqWkshLine(Rec);
                    //CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");

                    CurrPage.UPDATE(FALSE);
                end;

            }
        }
        //PRJ-58.SK.1.0 End


        addafter("F&unctions")
        {
            action(NS_CalculatePlan_Copy)
            {

                Ellipsis = true;
                Caption = 'PP Calculate Plan';
                ToolTip = 'Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.';
                ApplicationArea = Planning;
                Promoted = true;
                PromotedIsBig = true;
                Image = CalculatePlan;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    DocNo: Code[20];
                    JobsSetup: Record "Jobs Setup";
                    CalculatePlan: Report "NS_Calculate Plan - Req. Wksh.";
                begin
                    JobsSetup.GET;
                    DocNo := JobsSetup."NS_Req JMP Doc. No.";
                    //ProjectPro - start Modify
                    CalculatePlan.SetTemplAndWorksheet("Worksheet Template Name", "Journal Batch Name", DocNo);
                    //ProjectPro - end Modify
                    CalculatePlan.RUNMODAL;
                    CLEAR(CalculatePlan);
                end;
            }
        }
    }

    PROCEDURE InitVar(lDocNo: Code[20]);
    BEGIN
        DocNo := lDocNo;
    END;

    var
        DocNo: Code[20];

    trigger OnOpenPage()
    var
        JobsSetup: Record "Jobs Setup";
    begin
        JobsSetup.GET;
        DocNo := JobsSetup."NS_Req JMP Doc. No.";
    end;

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Job No.
    //   +     Job Task No.
    //   +     Document No.
    //   +
    //   +  - Added function(s):
    //   +     InitVar
    //   +
    //   +  - Added global variable(s):
    //   +     DocNo
    //   +     JobsSetup
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +     - OnOpenPage - Read Job Setup record
    //   +                  - Set DocNo to JobsSetup.Req JMP Doc. No.
    //   +     - Added DocNo to call of CalculatePlan.SetTemplAndWorksheet
    //   +-----------------------------------------------------------------------------------------------

}

