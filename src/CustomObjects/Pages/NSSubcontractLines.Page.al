page 14021301 "NS_Subcontract Lines"
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-274 VT1.0 21-05-20 Code Added
    //PRJ-383.N.S.1.0 16Sep2020 Remove direct unit cost field
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-616.N.S.1.0 add task description when manually entry is inserted
    //PRJ-974.RM.1.0 09Oct2021 | Made field invisible from Page
    AutoSplitKey = true;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "NS_Subcontract Lines";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    // >> Upgrade
    SourceTableView = SORTING("NS_Subcontract No.", "NS_Line No.");
    // << Upgrade
    layout
    {
        area(content)
        {
            repeater(Control1100773000)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';
                }
                //PRJ-492.N.S.1.0 Start
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-492.N.S.1.0 End
                field(JobNo; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                        NS_JobNoOnAfterValidate();
                    end;
                }
                field("Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                        NS_JobTaskNoOnAfterValidate();
                    end;
                }
                field("Job Task Description"; Rec."NS_Job Task Description")
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';
                    ToolTip = 'Specifies the Task Description';
                }
                field("Job Cost Category"; Rec."NS_Job Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Cost Category';

                    trigger OnValidate();
                    begin
                        NS_JobCostCategoryOnAfterValidate();
                    end;
                }
                field("Starting Date"; Rec."NS_Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Starting Date';
                    Visible = false; //PRJ-492.AS.1.0 //Doubt
                }
                //PRJ-974.RM.1.0 09Oct2021 Start
                // field("Variant Code"; Rec."NS_Variant Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Variant Code';
                //     Visible = false;  //PRJ-974.RM.1.0 09Oct2021
                // }
                ////PRJ-974.RM.1.0 09Oct2021 End

                //PRJ-492.N.S.1.0 Start
                // field(Description; Rec.NS_Description)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Description';
                // }
                //PRJ-492.N.S.1.0 End
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("Direct Unit Cost"; Rec."NS_Direct Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Direct Unit Cost';
                    Visible = false;//PRJ-383.N.S.1.0 16Sep2020

                    trigger OnValidate();
                    begin
                        NS_DirectUnitCostOnAfterValidate();
                    end;
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Work Units"; Rec."NS_Work Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Units';
                    Visible = false; //PRJ-492.AS.1.0 //DOUBT
                }
                field("Work Unit of Measure"; Rec."NS_Work Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Work Unit of Measure';
                    Visible = false; //PRJ-492.AS.1.0 Doubt
                }
                //PRJ-974.RM.1.0 09Oct2021 Start
                // field("Progress Payment Method"; Rec."NS_Progress Payment Method")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Progress Payment Method';
                //     Visible = false; //PRJ-492.AS.1.0 //Doubt
                // }

                // field("Base Amount"; Rec."NS_Base Amount")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Base Amount';
                //     Visible = false; //PRJ-492.AS.1.0 //Doubt //PRJ-974.RM.1.0 09Oct2021
                // }
                //PRJ-974.RM.1.0 09Oct2021 End
                //PRJ-274 VT1.0 21-05-20 begin
                field("PO No."; Rec."NS_PO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO No.';
                }
                field("PO Line No."; Rec."NS_PO Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Line No.';
                    //Visible = false; //PRJ-492.AS.1.0  //Doubt//PRJ-492.RS.1.0 11May2021 Comment
                    Visible = true;//PRJ-492.RS.1.0 11May2021
                }
                //PRJ-274 VT1.0 21-05-20 end
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Line)
            {
                Caption = 'Line';
                action("NS_Show Vendor Insurance")
                {
                    ApplicationArea = All;
                    Caption = 'Show Vendor Insurance';

                    ToolTip = 'Show Vendor Insurance';
                    Image = ServiceAgreement;

                    trigger OnAction();
                    begin

                        NS_ShowVendorInsurance();
                    end;
                }
                action(NS_Dimensions)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensions';

                    ToolTip = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDimensions()
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        if Subcontract.GET("NS_Subcontract No.") then begin
            "NS_Dimension Set ID" := Subcontract."NS_Dimension Set ID";
            "NS_Job No." := Subcontract."NS_Job No.";
        end;
    end;

    var
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        Subcontract: Record NS_Subcontract;
    // DimMgt: Codeunit DimensionManagement;
    // DocumentType: Label 'Subcontract';

    procedure NS_ShowVendorInsurance();
    begin
        Rec.ShowVendorInsurance
    end;

    // procedure ShowVendorInsurance();
    // begin
    //     Rec.ShowVendorInsurance
    // end;

    local procedure NS_JobNoOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_JobTaskNoOnAfterValidate();
    var
        JobTaskRec: Record "Job Task";//PRJ-616.N.S.1.0
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");

        "NS_Job Task Description" := '';

        JobPlanningLine.RESET();
        JobPlanningLine.SETRANGE("Job No.", "NS_Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", "NS_Job Task No.");
        if JobPlanningLine.FINDFIRST() then
            "NS_Job Task Description" := JobPlanningLine.Description;
        //PRJ-616.N.S.1.0 Start
        if "NS_Job Task Description" = '' then begin

            if JobTaskRec.get(Rec."NS_Job No.", Rec."NS_Job Task No.") then
                "NS_Job Task Description" := JobTaskRec.Description
            else
                "NS_Job Task Description" := '';
        end;
        //PRJ-616.N.S.1.0 END
    end;

    local procedure NS_JobCostCategoryOnAfterValidate();
    begin
        Job.CorrectForBlankFields("NS_Job No.", "NS_Subcontract No.", "NS_Job Cost Category", "NS_Job Cost Category", "NS_Job Task No.");
    end;

    local procedure NS_DirectUnitCostOnAfterValidate();
    begin
        "NS_Unit Cost" := "NS_Direct Unit Cost";
        VALIDATE("NS_Unit Cost");
    end;
}

