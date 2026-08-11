pageextension 14021133 NS_JobLedgerEntries extends "Job Ledger Entries"
{
    // version NAVW111.00.00.19846,PPNA11.00
    //TM-10.AM.1.0 | Added Field.
    //PRJ-841.JS.1.0 16Aug2021 | Add field
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
    Caption = 'Job Ledger Entries'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Job Task No.")
        {
            Visible = false;
            Enabled = false;
        }
        modify(Type)
        {
            Visible = false;
            Enabled = false;
        }
        //PRJ-1696.GK.1.0 15Dec2022 start
        addafter("Entry Type")
        {
            field("NS_Interim Entry"; Rec."NS_Interim Entry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Interim Entry field.';
            }
        }
        //PRJ-1696.GK.1.0 15Dec2022 end
        addafter("Job No.")
        {
            field("NS_Job Task No.2"; Rec."Job Task No.")
            {
                Caption = 'Job Task No.';
                ToolTip = 'Specifies the number of the related job task.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                Caption = 'Segment Code';
                Editable = false;
                ApplicationArea = All;
                Description = 'TM-10.AM.1.0';
            }
            field("NS_FA Res.No."; Rec."NS_FA Res.No.")
            {
                Caption = 'FA Res.No.';
                Editable = false;
                ApplicationArea = All;
                Description = 'PRJ-490.AM.1.0';
            }

        }


        addafter("Job Task No.")
        {
            field("NS_External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the External Document No.';
            }
            field("NS_External Relationship Type"; Rec."NS_External Relationship Type")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the External Relationship Type';
            }
            field("NS_External Relationship No."; Rec."NS_External Relationship No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the External Relationship No.';
            }
            field("NS_External Relationship Name"; Rec."NS_External Relationship Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the External Relationship Name';
            }
        }
        addafter(Description)
        {
            field("NS_Jobsite Work"; Rec."NS_Jobsite Work")
            {
                ApplicationArea = All;
                Caption = 'Jobsite Work';
                Editable = false;
                Visible = NS_AdvancedJobLaborActive;
            }
            field("NS_Payroll Work State"; Rec."NS_Payroll Work State")
            {
                ApplicationArea = All;
                Caption = 'Payroll Work State';
                Editable = false;
                Visible = NS_AdvancedJobLaborActive;
            }
        }
        //PRJ-1696.GK.1.0 15Dec2022 start
        addafter("Ledger Entry No.")
        {

            field("NS_Receipt No."; Rec."NS_Receipt No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt No. field.';
            }
            field("NS_Receipt Line No."; Rec."NS_Receipt Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receipt Line No. field.';
            }
            field("NS_Accural Status"; Rec."NS_Accural Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Accural Status field.';
            }

        }
        //PRJ-1696.GK.1.0 15Dec2022 end
        addafter("Job Posting Group")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Job Revenue Category';
            }
        }
        addafter("Work Type Code")
        {
            field("NS_Skill Class"; '') //PE-68.Dk.1.0 10April2023
            {
                ApplicationArea = All;
                Caption = 'Skill Class';
                Editable = false;
                ToolTip = 'Specifies the Skill Class';
                // Visible = NS_AdvancedJobLaborActive;
                Visible = false;//PE-68.Dk.1.0 10April2023

            }
            //PE-68.Dk.1.0 10April2023 Start
            field("NS_Skill Class New"; Rec."NS_Skill Class New")
            {
                ApplicationArea = All;
                Caption = 'Skill Class';
                Editable = false;
                ToolTip = 'Specifies the Skill Class';
                //Visible = NS_AdvancedJobLaborActive;
            }
            //PE-68.Dk.1.010April2023  End
            field("NS_Work Units"; Rec."NS_Work Units")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Work Units';
            }
            field("NS_Work Unit of Measure"; Rec."NS_Work Unit of Measure")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Work Unit of Measure';
            }

            field("NS_Skill Code"; '') //PRJ-841.JS.1.0 16Aug2021 //PE-68.Dk.1.0 10April2023
            {
                ToolTip = 'Specifies the value of the resource Skill';
                ApplicationArea = All;
                Editable = false;
                Visible = false;//PE-68.Dk.1.0 10April2023
            }
            //PRJ-841.JS.1.0 16Aug2021-start
            field("NS_Crew Code"; Rec."NS_Crew Code")
            {
                ToolTip = 'Specifies the value of the Crew Code';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Crew Time Sheet Line"; Rec."NS_Crew Time Sheet Line")
            {
                ToolTip = 'Specifies that it is Crew Time Sheet Line';
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Crew Time Sheet Ref. No."; Rec."NS_Crew Time Sheet Ref. No.")
            {
                ToolTip = 'Specifies the value of the Crew Time Sheet Ref. No.';
                ApplicationArea = All;
                Editable = false;
            }
            //PRJ-841.JS.1.0 16Aug2021-end

        }
        addafter(Quantity)
        {
            field("NS_Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("NS_Retention Ledger Code"; Rec."NS_Retention Ledger Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Ledger Code';
            }
        }
        addafter("Line Amount (LCY)")
        {
            field("NS_Burden Amount"; Rec."NS_Burden Amount")
            {
                ApplicationArea = All;
                Caption = 'Burden Amount';//PRJ-458.AS.1.0 12JAN2021
                Editable = false;
                ToolTip = 'Specifies the Burden Amount';
                //Visible = NS_AdvancedJobLaborActive;//PRJ-458.AS.1.0 12JAN2021 COMMENTED
                Visible = true;//PRJ-458.AS.1.0 12JAN2021 ADDED
            }
            field("NS_Burden Job Cost Category"; Rec."NS_Burden Job Cost Category")
            {
                ApplicationArea = All;
                Caption = 'Burden Job Cost Category';//PRJ-458.AS.1.0 12JAN2021
                Editable = false;
                ToolTip = 'Specifies the Burden Job Cost Category';
                //Visible = NS_AdvancedJobLaborActive;//PRJ-458.AS.1.0 12JAN2021 COMMENTED
                Visible = true;//PRJ-458.AS.1.0 12JAN2021 ADDED
            }
            field("NS_Payroll Burden Amount"; Rec."NS_Payroll Burden Amount")
            {
                ApplicationArea = All;
                Caption = 'Payroll Burden Amount';//PRJ-458.AS.1.0 12JAN2021
                Editable = false;
                ToolTip = 'Specifies the Payroll Burden Amount';
                //Visible = NS_AdvancedJobLaborActive;//PRJ-458.AS.1.0 12JAN2021 COMMENTED
                Visible = true;//PRJ-458.AS.1.0 12JAN2021 ADDED
            }
            field("NS_Payroll Burden Job Cost Cat"; Rec."NS_Payroll Burden Job Cost Cat")
            {
                ApplicationArea = All;
                Caption = 'Payroll Burden Job Cost Category';//PRJ-458.AS.1.0 12JAN2021
                Editable = false;
                ToolTip = 'Specifies the Payroll Burden Job Cost Category';
                //Visible = NS_AdvancedJobLaborActive;//PRJ-458.AS.1.0 12JAN2021 COMMENTED
                Visible = true;//PRJ-458.AS.1.0 12JAN2021 ADDED
            }
            field("NS_Burden Amount Posted to G/L"; Rec."NS_Burden Amount Posted to G/L")//PRJ-458.AS.1.0 12JAN2021
            {
                ApplicationArea = All;
                Caption = 'Burden Amount Posted to G/L';
                Editable = false;
                ToolTip = 'Specifies the Burden Amount Posted to G/Lt';
                Visible = false;
            }
            field("NS_Burden Posting Document No."; Rec."NS_Burden Posting Document No.")//PRJ-458.AS.1.0 12JAN2021
            {
                ApplicationArea = All;
                Caption = 'Burden Posting Document No.';
                Editable = false;
                ToolTip = 'Specifies the Burden Posting Document No.';
                Visible = false;
            }
        }
        addafter("DateTime Adjusted")
        {
            field("NS_Exclude Entry"; Rec."NS_Exclude Entry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Exclude Entry';
            }
        }

        modify("No.")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("NS_External Relationship Name")
        {
            field(NS_Type2; Rec.Type)
            {
                Caption = 'Type';
                ToolTip = 'Specifies the type of account to which the job ledger entry is posted.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_No.2"; Rec."No.")
            {
                Caption = 'No.';
                ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Job Posting Group")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Variant Code")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Work Type Code")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Location Code")
        {
            field("NS_Work Type Code2"; Rec."Work Type Code")
            {
                Caption = 'Work Type Code';
                ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify("Unit of Measure Code")
        {
            Visible = false;
            Enabled = false;
        }
        modify(Quantity)
        {
            Visible = false;
            Enabled = false;
        }
        addafter("NS_Work Unit of Measure")
        {
            field("NS_Unit of Measure Code2"; Rec."Unit of Measure Code")
            {
                Caption = 'Unit of Measure Code';
                ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field(NS_Quantity2; Rec.Quantity)
            {
                Caption = 'Quantity';
                ToolTip = 'Specifies the quantity that was posted on the entry.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify("Direct Unit Cost (LCY)")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Unit Price")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Total Cost (LCY)")
        {
            field("NS_Unit Price2"; Rec."Unit Price")
            {
                Caption = 'Unit Price';
                ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify("Line Amount")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Line Discount Amount")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Unit Cost (LCY)")
        {
            field("NS_Line Amount2"; Rec."Line Amount")
            {
                Caption = 'Line Amount';
                ToolTip = 'Specifies the value of products on the entry.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_Line Discount Amount2"; Rec."Line Discount Amount")
            {
                Caption = 'Line Discount Amount';
                ToolTip = 'Specifies the line discount amount for the posted entry, in the currency specified for the job.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_Line Discount %2"; Rec."Line Discount %")
            {
                Caption = 'Line Discount %';
                ToolTip = 'Specifies the line discount percent of the posted entry.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify("Amt. to Post to G/L")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Amt. Posted to G/L")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Original Unit Cost")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Original Total Cost")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Original Total Cost (ACY)")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Serial No.")
        {
            Visible = false;
            Enabled = false;
        }

        modify("Ledger Entry Type")
        {
            Visible = false;
            Enabled = false;
        }
        modify("Ledger Entry No.")
        {
            Visible = false;
            Enabled = false;
        }

        addafter("Lot No.")
        {
            field("NS_Ledger Entry Type2"; Rec."Ledger Entry Type")
            {
                Caption = 'Ledger Entry Type';
                ToolTip = 'Specifies the entry type that the job ledger entry is linked to.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_Ledger Entry No.2"; Rec."Ledger Entry No.")
            {
                Caption = 'Ledger Entry No.';
                ToolTip = 'Specifies the entry number (Resource, Item or G/L) to which the job ledger entry is linked.';
                ApplicationArea = Jobs;
                Editable = false;
            }
        }

        modify(Adjusted)
        {
            Visible = false;
            Enabled = false;
        }
        modify("DateTime Adjusted")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Entry No.")
        {
            field(NS_Adjusted2; Rec.Adjusted)
            {
                Caption = 'Adjusted';
                ToolTip = 'Specifies whether a job ledger entry has been modified or adjusted. The value in this field is inserted by the Adjust Cost - Item Entries batch job. The Adjusted check box is selected if applicable.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            field("NS_DateTime Adjusted2"; Rec."DateTime Adjusted")
            {
                Caption = 'DateTime Adjusted';
                ToolTip = 'Specifies the time stamp of a job ledger entry adjustment or modification.';
                ApplicationArea = Jobs;
                Editable = false;
            }
            //PRJCTPR-2.RM.1.0 13Dec2022 start
            field("NS_Union Code"; Rec."NS_Union Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Union Code';
            }
            //PRJCTPR-2.RM.1.0 13Dec2022 end
        }

        modify("Total Price (LCY)")
        {
            Visible = true;
        }
    }
    actions
    {
        addafter("Transfer To Planning Lines")
        {
            action("NS_Print Work Order")
            {
                Caption = 'Print Work Order';
                Image = Document;
                ApplicationArea = All;

                trigger OnAction();
                var
                    JobNoFilter: Text[60];
                    WOReport: Report "NS_Work Order (Job LedgerSumm)";
                begin
                    //ProjectPro - start
                    JobNoFilter := GETFILTER("Job No.");
                    if JobNoFilter <> '' then begin
                        WOReport.SetFilter(JobNoFilter);
                        WOReport.RUNMODAL;
                    end else
                        WOReport.RUNMODAL;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Job: Record Job;
        NS_JobLedgEntry2: Record "Job Ledger Entry";
        NS_ShowJobRec: Record Job;
        NS_ShowSubLevels: Boolean;
        NS_FilterSet: Boolean;
        NS_HumanResourcesSetup: Record "Human Resources Setup";
        NS_AdvancedJobLaborActive: Boolean;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        IF NS_FilterSet THEN BEGIN
            IF NS_ShowSubLevels THEN BEGIN
                RESET;
                NS_Job.RESET;
                NS_Job.SETRANGE("No.", NS_ShowJobRec."No.");
                IF NS_Job.FINDSET THEN
                    REPEAT
                        NS_Job."MarkSub-Levels"(NS_Job, TRUE);
                    UNTIL NS_Job.NEXT = 0;

                NS_Job.MARKEDONLY(TRUE);
                IF NS_Job.FINDSET THEN
                    REPEAT
                        NS_JobLedgEntry2.RESET;
                        NS_JobLedgEntry2.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
                        NS_JobLedgEntry2.SETRANGE("Job No.", NS_Job."No.");
                        NS_JobLedgEntry2.SETFILTER("Entry Type", NS_ShowJobRec.GETFILTER("NS_Entry Type Filter"));
                        NS_JobLedgEntry2.SETFILTER("Posting Date", NS_ShowJobRec.GETFILTER("NS_Date Filter"));
                        //PE-306.JS.1.0 06JUN2024-Start
                        //NS_JobLedgEntry2.SETFILTER(Type, NS_ShowJobRec.GETFILTER("NS_Type Filter"));
                        NS_JobLedgEntry2.SETFILTER(Type, NS_ShowJobRec.GETFILTER("NS_TypeEnumFilter"));
                        //PE-306.JS.1.0 06JUN2024-end
                        IF NS_JobLedgEntry2.FINDSET THEN
                            REPEAT
                                GET(NS_JobLedgEntry2."Entry No.");
                                MARK(TRUE);
                            UNTIL NS_JobLedgEntry2.NEXT = 0;
                    UNTIL NS_Job.NEXT = 0;


                NS_JobLedgEntry2.SETRANGE("Job No.", NS_ShowJobRec."No.");
                IF NS_JobLedgEntry2.FINDSET THEN
                    REPEAT
                        GET(NS_JobLedgEntry2."Entry No.");
                        MARK(TRUE);
                    UNTIL NS_JobLedgEntry2.NEXT = 0;
                MARKEDONLY(TRUE);
            END ELSE BEGIN
                RESET;
                SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
                IF NS_ShowJobRec."No." > '' THEN
                    SETRANGE("Job No.", NS_ShowJobRec."No.");
                IF NS_ShowJobRec.GETFILTER("NS_Date Filter") > '' THEN
                    SETFILTER("Posting Date", NS_ShowJobRec.GETFILTER("NS_Date Filter"));
                IF NS_ShowJobRec.GETFILTER("NS_Entry Type Filter") > '' THEN
                    Rec.SETFILTER("Entry Type", NS_ShowJobRec.GETFILTER("NS_Entry Type Filter"));    //PRJ-1135.RM.1.0
                //PE-306.JS.1.0 06JUN2024-Start
                // IF NS_ShowJobRec.GETFILTER("NS_Type Filter") > '' THEN
                //     Rec.SETFILTER(Type, NS_ShowJobRec.GETFILTER("NS_Type Filter"));    //PRJ-1135.RM.1.0
                IF NS_ShowJobRec.GETFILTER("NS_TypeEnumFilter") > '' THEN
                    Rec.SETFILTER(Type, NS_ShowJobRec.GETFILTER("NS_TypeEnumFilter"));    //PRJ-1135.RM.1.0                
                //PE-306.JS.1.0 06JUN2024-end    
                IF NS_ShowJobRec.GETFILTER("NS_Cost Category Filter") > '' THEN
                    SETFILTER("NS_Job Cost Category", NS_ShowJobRec.GETFILTER("NS_Cost Category Filter"));
                IF NS_ShowJobRec.GETFILTER("NS_Revenue Category Filter") > '' THEN
                    SETFILTER("NS_Job Revenue Category", NS_ShowJobRec.GETFILTER("NS_Revenue Category Filter"));
                IF NS_ShowJobRec.GETFILTER("NS_Activity Filter") > '' THEN
                    SETFILTER("NS_Activity Code", NS_ShowJobRec.GETFILTER("NS_Activity Filter"));
                IF NS_ShowJobRec.GETFILTER("NS_Process Filter") > '' THEN
                    SETFILTER("NS_Process Code", NS_ShowJobRec.GETFILTER("NS_Process Filter"));
                IF NS_ShowJobRec.GETFILTER("NS_Operation Filter") > '' THEN
                    SETFILTER("NS_Operation Code", NS_ShowJobRec.GETFILTER("NS_Operation Filter"));
            END;
        END;

        NS_HumanResourcesSetup.GET;
        NS_AdvancedJobLaborActive := NS_HumanResourcesSetup."NS_Advanced Job Labor isActive";
        //ProjectPro - end
    end;

    procedure NS_SetFilters(var JobRec: Record Job; "IncludeSub-Levels": Boolean);
    begin
        //ProjectPro - start
        NS_ShowJobRec := JobRec;
        NS_ShowJobRec.COPYFILTERS(JobRec);
        NS_ShowSubLevels := "IncludeSub-Levels";
        NS_FilterSet := true;
        //ProjectPro - end
    end;

    /*
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     External Document No.           PP Work Unit of Measure
      +     PP External Relationship Type   PP Global Dimension 1 Code
      +     PP External Relationship No.   PP Global Dimension 2 Code
      +     PP External Relationship Name   Retention Ledger Code
      +     PP Jobsite Work                 PP Burden Amount
      +     PP Payroll Work State           PP Burden Job Cost Category
      +     PP Job Cost Category           Burden Job Cost Category
      +     PP Job Revenue Category         PP Payroll Burden Amount
      +     PP Skill Class                 PP Payroll Burden Job Cost Cat
      +     PP Work Units                   Exclude Entry
      +
      +  - Added function(s):
      +     SetFilters
      +
      +  - Added global variable(s):
      +     PP_Job
      +     PP_JobLedgEntry2
      +     PP_ShowJobRec
      +     PP_ShowSubLevels
      +     PP_FilterSet
      +     PP_HumanResourcesSetup
      +     PP_AdvancedJobLaborActive
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage - Set filters as needed using Marks and Filters
      +     - Added action list:
      +         Print Work Order
      +     - Modified controls:
      +         Set Editable=FALSE to following fields -
      +           Job Task No.                Amt. to Post to G/L
      +           Type                        Amt. Posted to G/L
      +           Gen. Prod. Posting Group    Original Unit Cost
      +           Job Posting Group            Original Total Cost
      +           Variant Code                Original Total Cost (ACY)
      +           Work Type Code              Serial No.
      +           Unit of Measure Code        Ledger Entry Type
      +           Direct Unit Cost (LCY)      Ledger Entry No.
      +           Unit Price                  Adjusted
      +           Line Amount                  DateTime Adjusted
      +           Line Discount Amount        Exclude Entry
      +           Line Discount %
      +     - Set Visible=TRUE
      +         Total Price (LCY)
      +-----------------------------------------------------------------------------------------------
    */
}

