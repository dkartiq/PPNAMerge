pageextension 14021228 NS_JobJournal extends "Job Journal"
{
    // version NAVW111.00.00.23572,PPNA11.00
    //PRJ-116.SK.1.0 BLocked code for making SKill class visible.
    //PPAL-64.MS.1.0 added new action of reverse labor entries
    //TM-10.AM.1.0 30OCT2020 | added validation on Post Action.
    //TM-10.AM.1.0 3DEC2020 | Added field.
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-841.JS.1.0 16Aug2021 | Add field
    //PRJ-842.JS.1.0 16Aug2021 | Add field
    //PRJ-1643.RM.1.0 09Dec2022 | Made some fields visible    
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
    //PE-144.RM.1.0 08Aug2023 | Obsolete action button
    layout
    {
        //Unsupported feature: Change Visible on ""Line Discount Amount"(Control 18)". Please convert manually.
        //Unsupported feature: Change Visible on ""Line Discount %"(Control 44)". Please convert manually.
        //Unsupported feature: Change Visible on ""Applies-to Entry"(Control 66)". Please convert manually.

        //Unsupported feature: CodeInsertion on ""Posting Date"(Control 4)". Please convert manually.
        //trigger OnValidate();
        //CurrPage.UPDATE;

        //Unsupported feature: CodeModification on ""Job No."(Control 2).OnValidate". Please convert manually.
        //trigger "(Control 2)();
        //CurrPage.UPDATE;

        //Unsupported feature: CodeInsertion on ""Job Task No."(Control 86)". Please convert manually.
        //trigger OnValidate();
        //CurrPage.UPDATE;

        //Unsupported feature: CodeModification on ""No."(Control 10).OnValidate". Please convert manually.
        //trigger OnValidate();        
        //CurrPage.UPDATE;

        //Unsupported feature: CodeInsertion on ""Work Type Code"(Control 48)". Please convert manually.
        //CurrPage.UPDATE;


        //Unsupported feature: CodeInsertion on "Quantity(Control 14)". Please convert manually.
        //trigger OnValidate();
        //CurrPage.UPDATE;
        moveafter(Quantity; "Unit of Measure Code")//PRJ-492.N.S.1.0
        modify("Work Type Code")
        {
            Visible = false;//PRJ-492.RS.1.0 11May2021
        }
        addfirst(Control1)
        {
            field("NS_Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = All;
                Editable = true;//PRJ-619.AS.1.0
                ToolTip = 'Specifies the Entry Type';

            }

        }
        //TM-10.AM.1.0 start
        addafter("Job Task No.")
        {
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specify the Segment Code';
                //Visible = false;//PRJ-492.RS.1.0 11May2021 //PRJ-492.RS.1.0 25May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
            }
            field("NS_FA Res.No."; Rec."NS_FA Res.No.")
            {
                Caption = 'FA Res.No.';
                Editable = false;
                ApplicationArea = All;
                Description = 'PRJ-490.AM.1.0';
                Visible = false;//PRJ-492.N.S.1.0
            }
        }
        //TM-10.AM.1.0 end
        addafter("Document No.")
        {
            field("NS_External Relationship Type"; Rec."NS_External Relationship Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the External Relationship Type';
                // Visible = false; //PRJ-492.AS.1.0 //PRJ-1643.RM.1.0 09Dec2022 commented
                Visible = true; //PRJ-1643.RM.1.0 09Dec2022  
            }
            field("NS_External Relationship No."; Rec."NS_External Relationship No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the External Relationship No.';
                // Visible = false; //PRJ-492.AS.1.0 //PRJ-1643.RM.1.0 09Dec2022 commented
                Visible = true; //PRJ-1643.RM.1.0 09Dec2022  
            }
            field("NS_External Relationship Name"; Rec."NS_External Relationship Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the External Relationship Name';
                // Visible = false; //PRJ-492.AS.1.0 //PRJ-1643.RM.1.0 09Dec2022 commented
                Visible = true; //PRJ-1643.RM.1.0 09Dec2022  
            }
        }
        addafter(Description)
        {
            field("NS_Jobsite Work"; Rec."NS_Jobsite Work")
            {
                ApplicationArea = All;
                Caption = 'Jobsite Work';

                ToolTip = 'Jobsite Work';
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Payroll Work State"; Rec."NS_Payroll Work State")
            {
                ApplicationArea = All;
                Caption = 'Payroll Work State';

                ToolTip = 'Payroll Work State';
                Visible = NS_AdvancedJobLaborActive;
            }
        }
        addafter("Variant Code")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
        addafter("Work Type Code")
        {
            field("NS_Skill Class"; '')//PE-68 Dk.1.0 10April2023
            {
                ApplicationArea = All;
                Caption = 'Skill Class';
                ToolTip = 'Skill Class';
                // Visible = NS_AdvancedJobLaborActive;//PRJ-116.SK.1.0 Blocked this
                //PRJ-492.AS.1.0
                Visible = false;//PE-68 Dk.1.0 10April2023
                trigger OnValidate();
                begin
                    //ProjectPro - start
                    CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
            //PE-68 Dk.1.0 10April2023 Start
            field("NS_Skill Class New"; Rec."NS_Skill Class New")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Skill Class';
                ToolTip = 'Skill Class';
                trigger OnValidate();
                begin
                    CurrPage.UPDATE;
                end;
            }
            //PE-68 Dk.1.0 10April2023 End
        }
        addafter("Unit Cost (LCY)")
        {
            field("NS_Burden Amount"; Rec."NS_Burden Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Burden Amount';
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Burden Job Cost Category"; Rec."NS_Burden Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Burden Job Cost Category';
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Payroll Burden Amount"; Rec."NS_Payroll Burden Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Payroll Burden Amount';
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Payroll Burden Job Cost Cat"; Rec."NS_Payroll Burden Job Cost Cat")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Payroll Burden Job Cost Category';
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Units';
            }
        }
        addafter("Total Cost")
        {
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Unit of Measure';
                Visible = false; //PRJ-492.AS.1.0
            }
        }
        addafter("Transaction Type")
        {
            field("NS_Chargeable"; Rec.Chargeable)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Chargeable';
                Visible = false;
            }
        }
        addafter("Transport Method")
        {
            field("NS_Job Posting Only"; Rec."Job Posting Only")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether is is for job posting only.';
                Visible = false;
            }
            field("NS_Country/Region Code"; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Country/Region Code';
                Visible = false;
            }
        }

        //PRJ-772-Start
        addafter("Gen. Bus. Posting Group")
        {
            field("NS_Crew Time Sheet Line"; Rec."NS_Crew Time Sheet Line")
            {
                ToolTip = 'Specifies the value of the Crew Time Sheet Line field';
                ApplicationArea = All;
            }
            field("NS_Crew Code"; Rec."NS_Crew Code")
            {
                ToolTip = 'Specifies the value of the Crew Code field';
                ApplicationArea = All;
            }
            field("NS_Crew Time Sheet Ref. No."; Rec."NS_Crew Time Sheet Ref. No.")
            {
                ToolTip = 'Specifies the value of the Crew Time Sheet Ref. No. field';
                ApplicationArea = All;
            }
            //PRJ-841.JS.1.0 16Aug2021-Start
            field("NS_Skill Code"; '')//PE-68 Dk.1.0 10April2023
            {
                Visible = false;//PE-68 Dk.1.0 10April2023
                ToolTip = 'Specifies the value of the resource Skill';
                ApplicationArea = All;
                Editable = false;
            }
            //PRJ-841.JS.1.0 16Aug2021-end
            //PRJCTPR-2.RM.1.0 13Dec2022 start
            field("NS_Union Code"; Rec."NS_Union Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Union Code';
            }
            //PRJCTPR-2.RM.1.0 13Dec2022 end

        }
        //PRJ-772.JS.1.0 21JULY2021-End
        //PE-146.NK.1.0 09Aug2023 Start
        addafter("NS_Crew Time Sheet Line")
        {
            field(NS_Staged; Rec.NS_Staged)
            {
                ApplicationArea = all;
                Caption = 'Staged';
            }
        }
        //PE-146.NK.1.0 09Aug2023 end

        addfirst(FactBoxes)
        {
            part(NS_Control1100773020; "NS_Job Journal Labor FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                              "Journal Batch Name" = FIELD("Journal Batch Name"),
                              "Line No." = FIELD("Line No.");
                Visible = NS_AdvancedJobLaborActive;
            }
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                //PRJCTPR-60 NK.1.0 13march2022 start
                if (Rec.Type = Rec.Type::"G/L Account") then
                    if GLAccount.Get(Rec."No.") then begin
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                        //    Rec.Modify();
                    end else begin

                        if (Rec.Type = Rec.Type::"G/L Account") and (Rec."Job No." <> '') then
                            PP_JobPlanningLine1.Reset();
                        PP_JobPlanningLine1.SetRange(Type, PP_JobPlanningLine1.Type::"G/L Account");
                        PP_JobPlanningLine1.SetRange("Job No.", Rec."Job No.");
                        PP_JobPlanningLine1.SetRange("No.", Rec."No.");
                        PP_JobPlanningLine1.SetRange("Job Task No.", Rec."Job Task No.");

                        if PP_JobPlanningLine1.FindSet() then
                            Rec."NS_Job Cost Category" := PP_JobPlanningLine1."NS_Cost Category";
                        //    Rec.Modify();

                    end;
                //PRJCTPR-60.NK.1.0 13march2022 end

            end;
        }
        modify("Job No.")
        {
            trigger OnBeforeValidate()
            begin
                //PRJCTPR-60 NK.1.0 13march2022 start
                if (Rec.Type = Rec.Type::"G/L Account") then
                    if GLAccount.Get(Rec."No.") then begin
                        Rec."NS_Job Cost Category" := GLAccount."NS_Cost Category";
                    end else begin
                        if (Rec.Type = Rec.Type::"G/L Account") and (Rec."Job No." <> '') then
                            PP_JobPlanningLine1.Reset();
                        PP_JobPlanningLine1.SetRange("Job No.", Rec."Job No.");
                        PP_JobPlanningLine1.SetRange(Type, PP_JobPlanningLine1.Type::"G/L Account");
                        PP_JobPlanningLine1.SetRange("No.", Rec."No.");
                        PP_JobPlanningLine1.SetRange("Job Task No.", Rec."Job Task No.");
                        if PP_JobPlanningLine1.FindFirst() then begin
                            Rec."NS_Job Cost Category" := PP_JobPlanningLine1."NS_Cost Category";
                        end;

                    end;
                //PRJCTPR-60.NK.1.0 13march2022 end
            end;
        }

    }
    actions
    {
        //TM-10.AM.1.0 Start
        modify("P&ost")
        {
            trigger OnBeforeAction()
            var
            begin
                JobSetup.get();
                if JobSetup."NS_Job Segment Mandatory" then begin
                    lJobJnlLine.Reset();
                    lJobJnlLine.SetCurrentKey("Line No.");
                    lJobJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    lJobJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    lJobJnlLine.SetRange("Job No.", Rec."Job No.");
                    lJobJnlLine.SetRange("Document No.", Rec."Document No.");
                    if lJobJnlLine.FindSet() then begin
                        repeat
                            lJobJnlLine.TestField("NS_Segment Code");
                        until lJobJnlLine.Next() = 0;
                    end;
                end;
            end;
        }
        //TM-10.AM.1.0 End

        //PRJ-772 - START
        addafter(SuggestLinesFromTimeSheets)
        {
            action(NS_SuggestLineForCrewTimeSheet)
            {
                ApplicationArea = All;
                Caption = 'Suggest Lines For Crew Timesheet';

                ToolTip = 'Suggest Lines For Crew Timesheet';
                Image = ICPartner;
                trigger OnAction()
                var
                    NSSuggestCrewJobLines: report "NS_Suggest Crew Job Jnl. Lines";
                begin
                    Clear(NSSuggestCrewJobLines);
                    NSSuggestCrewJobLines.NS_etJobJnlLine(Rec);
                    NSSuggestCrewJobLines.Run();
                end;
                //RunObject = report "NS_Suggest Crew Job Jnl. Lines";
            }
        }
        //PRJ-772 - END

        addafter(SuggestLinesFromTimeSheets)
        {
            action("NS_Copy Line to Crew Members")
            {
                ApplicationArea = All;
                Caption = 'Copy Line to Crew Members';

                ToolTip = 'Copy Line to Crew Members';
                Image = ICPartner;
                Visible = false; //PRJ-772

                trigger OnAction();
                var
                    NS_CopyLineToCrewMembers: Report "NS_Copy Job Jnl lines for Crew";
                begin
                    //ProjectPro - start
                    Rec.NS_CopyJobJnlLineToCrewMembers;
                    //ProjectPro - end
                end;
            }
            action(NS_GetStagedItems)
            {
                ApplicationArea = All;
                 Caption = 'Get Staged Items (Obsolete)';

                ToolTip = 'This function has been Obsoleted and will get removed from front end soon.';//PE-146.NK.1.0 09Aug2023 Start
               // Caption = 'Get Staged Items'; //PE-146.NK.1.0 09Aug2023
                Visible = false; //PE-144.RM.1.0 08Aug2023 start
                ObsoleteState = Pending;
                ObsoleteReason = 'Will be removed in the upcoming version';
                ObsoleteTag = 'Will be removed in the upcoming version'; //PE-144.RM.1.0 08Aug2023 End
              //  ToolTip = 'Get Staged Items';//PE-146.NK.1.0 09Aug2023
                Ellipsis = true;
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    GetReceiptLines: Report "NS_Get Receipt Lines - Job";
                begin
                    TESTFIELD("Journal Template Name");
                    TESTFIELD("Journal Batch Name");
                    CLEAR(GetReceiptLines);
                    GetReceiptLines.SetBatch("Journal Template Name", "Journal Batch Name");
                    GetReceiptLines.SetDocNo("Document No.");
                    GetReceiptLines.RUNMODAL;
                end;
            }
            //PE-146.NK.1.0 Start 09Aug2023
            action(NS_StageAllItems)
            {
                ApplicationArea = All;
                Caption = 'Stage All Items';
                ToolTip = 'This process will mark all Inventory Items for Staging and will also enable the Items to use on the Delivery Ticket.';
                Ellipsis = true;
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    NS_jobJournalLine: Record "Job Journal Line";
                begin
                    NS_jobJournalLine.Reset();
                    if NS_jobJournalLine.FindSet() then
                        repeat
                            NS_jobJournalLine.NS_Staged := true;
                            NS_jobJournalLine.Modify();
                        until NS_jobJournalLine.Next() = 0;
                end;
            }
            //PE-146.NK.1.0 end 09Aug2023
            action(NS_ReverseJLE)
            {
                ApplicationArea = All;
                Caption = 'Reverse Labor Entries';
                Ellipsis = true;
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                Description = 'PPAL-64.MS.1.0';

                trigger OnAction();
                var
                    JobJnlLine: Record "Job Journal Line";
                begin
                    TESTFIELD("Journal Template Name");
                    TESTFIELD("Journal Batch Name");
                    JobJnlLine.RESET;
                    JobJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    JobJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    REPORT.RUN(14021385, true, false, JobJnlLine);
                    CurrPage.UPDATE(true);
                end;
            }
        }
    }

    var
    //     lJobJnlLine: Record "Job Journal Line";
    //     lPurchReceiptLine: Record "Purch. Rcpt. Line";
    //     lJobMaterialPlan: Record "PP_Job Material Planning";

    var
        NS_HumanResourcesSetup: Record "Human Resources Setup";
        lJobJnlLine: Record "Job Journal Line";//TM-10.AM.1.0
        JobSetup: Record "Jobs Setup";
        JobJnlManagement: Codeunit JobJnlManagement;
        GLAccount: Record "G/L Account";//PRJCTPR-60.NK.1.0 start13march2023

        PP_JobPlanningLine1: Record "Job Planning Line"; //PRJCTPR-60.NK.1.0 start13march2023


        NS_AdvancedJobLaborActive: Boolean;
        CurrentJnlBatchName: Code[10];

    trigger OnOpenPage();
    begin
        NS_HumanResourcesSetup.GET;
        NS_AdvancedJobLaborActive := NS_HumanResourcesSetup."NS_Advanced Job Labor isActive";
    end;

    procedure NS_SetJournalBatch(JournalTemplate: Code[20]; JournalBatch: Code[20]);
    begin
        //ProjectPro - start
        "Journal Template Name" := JournalTemplate;
        "Journal Batch Name" := JournalBatch;

        CurrPage.SAVERECORD;
        CurrentJnlBatchName := JournalBatch;
        JobJnlManagement.SetName(CurrentJnlBatchName, Rec);
        JobJnlManagement.LookupName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(false);
        //ProjectPro - end
    end;

    procedure NS_SetJournalBatch2(NS_JournalTemplate: Code[20]; NS_JournalBatch: Code[20]);
    var
        NS_JobBatches: Record "Job Journal Batch";
    begin
        //ProjectPro - start
        "Journal Template Name" := NS_JournalTemplate;
        "Journal Batch Name" := NS_JournalBatch;
        JobJnlManagement.OpenJnlBatch(NS_JobBatches);
        //ProjectPro - end
    end;
}

