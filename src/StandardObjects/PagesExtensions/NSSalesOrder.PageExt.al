pageextension 14021112 NS_SalesOrder extends "Sales Order"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-552.SK.1.0 Added caption
    //PRJ-659.RS.1.0 18June21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.
    //PRJ-999.JS.1.0 19Nov2021 | Add code to flow job dimension
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1099.JS.1.0 31Dec2021 | Modify code for dimension on condition basis
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJCTPR-75 DK.1.0. 2March2023 | Job no field Editable & Visible false
    Caption = 'Sales Order'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';
                Visible = false;  //PRJCTPR-75 DK.1.0.2March2023
                Editable = false;//PRJCTPR-75 DK.1.0.2March2023
                trigger OnValidate();
                var
                    //PRJ-1099.JS.1.0 30Dec2021-start
                    NS_Job: Record Job;
                    NS_JobsSetup: Record "Jobs Setup";
                    NS_ProgrBillHead: Record "NS_Progress Billing Header";
                    NS_DefaultDim: Record "Default Dimension";
                begin
                    //ProjectPro - start
                    if Rec."NS_Job No." <> xRec."NS_Job No." then begin   //PRJ-1099.JS.1.0 add begin and Rec command
                        NS_JobsSetup.Get();
                        If NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin
                            IF Rec."NS_Job No." <> '' then
                                if NS_Job.Get(Rec."NS_Job No.") then begin
                                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                                    Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                                    Rec."Dimension Set ID" := NS_ProgrBillHead.GetDimensionNoFromJob(Rec."NS_Job No.");
                                end;
                        end else
                            if NS_Job.get(Rec."NS_Job No.") then begin
                                NS_DefaultDim.Reset();
                                NS_DefaultDim.SetRange("Table ID", 23);
                                NS_DefaultDim.SetRange("No.", Rec."Sell-to Customer No.");
                                if NS_DefaultDim.IsEmpty() then begin
                                    Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                                    Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                                    Rec."Dimension Set ID" := NS_ProgrBillHead.GetDimensionNoFromJob(Rec."NS_Job No.");
                                end;
                            end;
                    end;
                    CurrPage.UPDATE();
                    //PRJ-1099.JS.1.0 30Dec2021-end
                    //ProjectPro - end
                end;
            }
        }
        addafter(Control1900201301)
        //addafter(Prepayment)
        {
            group(NS_Retention)
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; NS_RetentionBaseAmount)
                {
                    Caption = 'Retention Base Amount';//PRJ-659.RS.1.0 18June21
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Retention Base Amount';
                }
                field("NS_Retention Percent"; Rec."NS_Retention Percent")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionPercentEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Percent';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount (LCY)"; Rec."NS_Retention Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountLCYEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Retention Amount (LCY)';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Amount"; Rec."NS_Retention Amount")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionAmountEditable;
                    ToolTip = 'Specifies the Retention Amount';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
                field("NS_Retention Date"; Rec."NS_Retention Date")
                {
                    ApplicationArea = All;
                    Editable = NS_RetentionDateEditable;
                    ToolTip = 'Specifies the Retention Date';

                    trigger OnValidate();
                    begin
                        //ProjectPro - start
                        TESTFIELD(Status, Status::Open.AsInteger());
                        //ProjectPro - end
                    end;
                }
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_RetentionPercentEditable: Boolean;
        NS_RetentionAmountLCYEditable: Boolean;
        NS_RetentionAmountEditable: Boolean;
        NS_RetentionDateEditable: Boolean;
        NS_RetentionBaseAmount: Decimal;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        NS_JobsSetup.GET;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    var
        NS_Jobs: record Job;  //PRJ-999.JS.1.0 18Nov2021
        NS_JobSetup: Record "Jobs Setup";  //PRJ-1087.JS.1.0 18Dec2021  
    begin
        //ProjectPro - start
        NS_RetentionCalcs();
        //ProjectPro - end
        //PRJ-999.JS.1.0 18Nov2021 Start
        //PRJ-1099.JS.1.0 31Dec2021-Start
        // NS_JobSetup.Get();   //PRJ-1087.JS.1.0 18Dec2021 add line
        // if NS_JobSetup."NS_Flow Job Card Dimension" = true then    //PRJ-1087.JS.1.0 18Dec2021 add line
        //     IF Rec."NS_Job No." <> '' then
        //         if NS_Jobs.Get(Rec."NS_Job No.") then begin
        //             Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
        //             Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
        //             Rec."Dimension Set ID" := Rec.NS_GetDimensionNoFromJob(Rec."NS_Job No.");
        //         end;
        //PRJ-1099.JS.1.0 31Dec2021-Start        
        //PRJ-999.JS.1.0 18Nov2021 end         
    end;

    procedure NS_RetentionCalcs();
    begin
        //ProjectPro - start
        NS_RetentionBaseAmount := NS_RetentionBase("Document Type", "No.");

        if "NS_Retention Percent" <> 0 then begin
            VALIDATE("NS_Retention Percent");
            VALIDATE("NS_Retention Date");
        end else
            if "NS_Retention Amount (LCY)" <> 0 then begin
                VALIDATE("NS_Retention Amount (LCY)");
                VALIDATE("NS_Retention Date");
            end;

        if "NS_Retention Document" then begin
            "NS_Retention Percent" := 0;
            "NS_Retention Amount (LCY)" := 0;
            "NS_Retention Amount" := 0;
            "NS_Retention Date" := 0D;
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
            NS_RetentionDateEditable := false;
        end else begin
            NS_RetentionPercentEditable := true;
            NS_RetentionAmountLCYEditable := true;
            NS_RetentionAmountEditable := true;
            NS_RetentionDateEditable := true;
        end;

        if (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"2 - Calc tax on sale then apply retention determined by progress billing") or
           (NS_JobsSetup."NS_A/R RetentionTaxCalcMethod" =
            NS_JobsSetup."NS_A/R RetentionTaxCalcMethod"::"3 - Calc tax on sale less the retention determined by progress billing") then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;

        if "NS_Progress Billing Document" then begin
            NS_RetentionPercentEditable := false;
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    /* Documentation
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Job No.
      +     PP_RetentionBaseAmount
      +     Retention Percent
      +     Retention Amount (LCY)
      +     Retention Amount
      +     Retention Date
      +
      +  - Added function(s):
      +     PP_RetentionCalcs
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_RetentionBaseAmount
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +    - OnOpenPage  - Read Job Setup record
      +                  - Initiate variables
      +    - OnAfterGetRecord - Call PP_RetentionCalcs
      +    - Added Retention fasttab with retention related fields
      +
      + -SMP
      +  -Modified Page triggers
      +   -OnAfterGetRecord 
      +   -OnOpenPage
      +-----------------------------------------------------------------------------------------------
      */

}

