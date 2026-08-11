pageextension 14021114 NS_SalesCreditMemo extends "Sales Credit Memo"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //TM-10.AM.1.0 30OCT2020 | added validation on Post Action.
    //PRJ-999.JS.1.0 19Nov2021 | add code to flow dimension
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1099.JS.1.0 31Dec2021 | Modify code for dimension on condition basis
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Sales Credit Memo'; //PRJ-1330.NK.1.0 25Apr2022

    layout
    {
        addafter("Assigned User ID")
        {
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

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
            //PE-302.JS.1.0 30MAY2023-Start
            field("NS_AppliesToDocument Type"; Rec."NS_AppliesToDocument Type")
            {
                Caption = 'ProjectPro Applies Doc. Type';
                ApplicationArea = All;
                ToolTip = '"Applies To Document Type" is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            }
            field("NS_AppliesToDocument No."; Rec."NS_AppliesToDocument No.")
            {
                Caption = 'ProjectPro Applies Doc. No.';
                ApplicationArea = All;
                ToolTip = '"Applies To Document No." is required to resolve posting issue with other ISV running with ProjectPro on same environment';
            }
            //PE-302.JS.1.0 30MAY2023-end
            field("NS_Retention Document"; Rec."NS_Retention Document")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Retention Document';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_RetentionCalcs;
                    //ProjectPro - end
                end;
            }
        }
        addafter("Foreign Trade")
        {
            group("NS_Retention")
            {
                Caption = 'Retention';
                field("NS_Retention Base Amount"; NS_RetentionBaseAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Base Amount';
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
                    Editable = NS_RetentionAmountLCYEditable;
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
    actions
    {
        //TM-10.AM.1.0 Start
        modify(Post)
        {
            trigger OnBeforeAction()
            var
            begin
                JobSetup.Get();
                if JobSetup."NS_Job Segment Mandatory" then
                    if SalesLineSegment.Type <> SalesLineSegment.Type::"Fixed Asset" then begin
                        SalesLineSegment.Reset();
                        SalesLineSegment.SetCurrentKey("Document No.", "Line No.");
                        SalesLineSegment.SetRange("Document No.", Rec."No.");
                        SalesLineSegment.SetRange("Document Type", Rec."Document Type");
                        SalesLineSegment.SetFilter("No.", '<>%1', '');
                        SalesLineSegment.SetFilter("Job No.", '<>%1', '');
                        if SalesLineSegment.FindSet() then begin
                            repeat
                                SalesLineSegment.TestField("NS_Segment Code");
                            until SalesLineSegment.Next() = 0;
                        end;
                    end;
            end;
        }
        //TM-10.AM.1.0 End

        addbefore(CopyDocument)
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';
                Image = JobLines;

                trigger OnAction();
                begin
                    //ProjectPro - start
                    CurrPage.SalesLines.PAGE.GetJobBudget("Sell-to Customer No.");
                    //ProjectPro - end
                end;
            }
            action("NS_Get Retention")
            {
                ApplicationArea = All;
                Caption = 'Get R&etention';
                Image = SuggestCustomerPayments;

                trigger OnAction();
                begin
                    //ProjectPro - start
                    if "NS_Retention Document" then
                        NS_GetJobRLedger
                    else
                        MESSAGE(Text14021100);
                    //ProjectPro - end
                end;
            }
            separator(NS_Separator1100773001)
            {
            }
        }
    }

    var
        NS_JobsSetup: Record "Jobs Setup";
        NS_GLSetup: Record "General Ledger Setup";
        SalesLineSegment: Record "Sales Line";//TM-10.AM.1.0
        JobSetup: Record "Jobs Setup";//TM-10.AM.1.0

        NS_RetentionDateEditable: Boolean;
        NS_RetentionAmountEditable: Boolean;
        NS_RetentionAmountLCYEditable: Boolean;
        NS_RetentionPercentEditable: Boolean;
        NS_RetentionBaseAmount: Decimal;
        NS_CustLedgEntry: Record "Cust. Ledger Entry";
        NS_SalesHeader: Record "Sales Header";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_GetSalesRetentionList: Page "NS_Get Sales Retention List";
        Text14021100: Label 'This function can only be used when Retention Document is checked.';


    trigger OnAfterGetRecord();
    var
        NS_Jobs: record job;   //PRJ-999.JS.1.0 18Nov2021
        NS_JobSetup: Record "Jobs Setup";    //PRJ-1087.JS.1.0 18Dec2021   
    begin
        //ProjectPro - start
        NS_RetentionCalcs;
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
        //PRJ-1099.JS.1.0 31Dec2021-End      
        //PRJ-999.JS.1.0 18Nov2021 end           
    end;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        NS_RetentionDateEditable := TRUE;
        NS_RetentionAmountEditable := TRUE;
        NS_RetentionAmountLCYEditable := TRUE;
        NS_RetentionPercentEditable := TRUE;
        NS_JobsSetup.GET;
        NS_GLSetup.GET;
        NS_SalesSetup.GET;
        //ProjectPro - end
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
        //ProjectPro - end
    end;

    procedure NS_GetJobRLedger();
    var
        NS_SalesLine: Record "Sales Line";
        NS_LineNumber: Integer;
        NS_ReturnAction: Action;
        Text0001: Label '"Retention for job "';
        NS_Job: Record Job;
    begin
        //ProjectPro - start
        NS_SalesHeader.COPY(Rec);
        NS_SalesHeader.SETRECFILTER;
        if not NS_SalesSetup."NS_Sales Retention Inactive" then begin
            NS_CustLedgEntry.RESET;
            NS_CustLedgEntry.SETRANGE("Customer No.", "Sell-to Customer No.");
            NS_CustLedgEntry.SETRANGE("Document Type", NS_CustLedgEntry."Document Type"::"Credit Memo");
            NS_CustLedgEntry.SETRANGE(Open, true);
            NS_GetSalesRetentionList.SETTABLEVIEW(NS_CustLedgEntry);
            NS_GetSalesRetentionList.NS_SetSalesHeader(NS_SalesHeader);

            if NS_GetSalesRetentionList.RUNMODAL = ACTION::OK then begin
                with NS_CustLedgEntry do begin

                    NS_SalesLine.RESET;
                    NS_SalesLine.SETRANGE("Document Type", NS_SalesHeader."Document Type");
                    NS_SalesLine.SETRANGE("Document No.", NS_SalesHeader."No.");
                    if NS_SalesLine.FINDLAST then
                        NS_LineNumber := NS_SalesLine."Line No."
                    else
                        NS_LineNumber := 0;
                    SETFILTER("NS_Retention Applies-to Amount", '<>0');
                    if FINDSET then
                        repeat

                            NS_SalesLine.INIT;
                            NS_SalesLine."Document Type" := NS_SalesHeader."Document Type";
                            NS_SalesLine."Sell-to Customer No." := NS_SalesHeader."Sell-to Customer No.";
                            NS_SalesLine."Document No." := NS_SalesHeader."No.";
                            NS_LineNumber := NS_LineNumber + 10000;
                            NS_SalesLine."Line No." := NS_LineNumber;
                            NS_SalesLine.Type := NS_SalesLine.Type::NS_Ledger;
                            NS_SalesLine.VALIDATE(Type);
                            NS_SalesLine."No." := NS_JobsSetup."NS_Retention Receivable Ledger";
                            NS_SalesLine.VALIDATE("No.");
                            NS_SalesLine.Description := Text0001 + "NS_Job No.";
                            NS_SalesLine."Job No." := NS_CustLedgEntry.NS_GetJobNo(NS_CustLedgEntry);
                            NS_SalesLine.Quantity := 1;
                            NS_SalesLine.VALIDATE(Quantity);
                            NS_SalesLine."Unit Price" := "NS_Retention Applies-to Amount";
                            NS_SalesLine.Amount := NS_SalesLine."Unit Price";
                            if NS_SalesHeader."Document Type" = NS_SalesHeader."Document Type"::"Credit Memo" then begin
                                NS_SalesLine."Unit Price" := -NS_SalesLine."Unit Price";
                                NS_SalesLine.Amount := -NS_SalesLine.Amount;
                            end;
                            NS_SalesLine.VALIDATE("Unit Price");
                            if NS_SalesLine."Tax Liable" then
                                if NS_SalesLine."Tax Area Code" <> '' then
                                    if NS_Job.GET("NS_Job No.") then
                                        NS_SalesLine.VALIDATE("Tax Group Code", NS_Job."NS_Tax Group Code New");
                            NS_SalesLine.INSERT;


                            "NS_Retention Applies-to Amount" := 0;
                            "Applies-to ID" := '';
                            MODIFY;
                        until NEXT = 0;
                end;
            end;
        end;

        CLEAR(NS_GetSalesRetentionList);
        //ProjectPro - end
    end;

    /* Documentation
    +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +         PP Job No
      +         PP Retention Document
      +     - Added Retention fasttab
      +         PP Retention Base Amount
      +         PP Retention Percent
      +         PP Retention Amount (LCY)
      +         PP Retention Amount
      +         PP Retention Date
      +
      +  - Added function(s):
      +     PP_RetentionCalcs
      +     PP_GetJobRLedger
      +
      +  - Added global variable(s):
      +     PP_JobsSetup
      +     PP_GLSetup
      +     PP_RetentionDateEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionPercentEditable
      +     PP_RetentionBaseAmount
      +     PP_CustLedgEntry
      +     PP_SalesHeader
      +     PP_SalesSetup
      +     PP_GetSalesRetentionList
      +
      +  - Added global text constant(s):
      +      Text14021100
      +
      +  - Modification(s):
      +     - OnOpenPage
      +         Read setup records
      +             PP_JobsSetup.GET;
      +             PP_GLSetup.GET;
      +             PP_SalesSetup.GET;
      +         Set global variables
      +             PP_RetentionDateEditable := TRUE;
      +             PP_RetentionAmountEditable := TRUE;
      +             PP_RetentionAmountLCYEditable := TRUE;
      +             PP_RetentionPercentEditable := TRUE;
      +     - OnAfterGetRecord - Call PP_RetentionCalcs
      +     - Added action list:
      +         - PP Get Job Planning Line
      +             - Call SalesLine.GetJobBudget
      +         - PP Get Retention
      +             - Call PP_GetJobRLedger
      + -SMP
      +  -Modified Triggers
      +   -OnOpenPage 
      +   -OnAfterGetRecord
      +
    +-----------------------------------------------------------------------------------------------
    */

}

