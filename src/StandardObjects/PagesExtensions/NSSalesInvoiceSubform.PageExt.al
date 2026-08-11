pageextension 14021117 NS_SalesInvoiceSubform extends "Sales Invoice Subform"
{
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-148.SK.1.0 Added property on "Job No."
    //CTSI-42.AS.1.0 21MAY2020 Added Revenue Category Description Field
    //TM-10.AM.1.0 | Added Field.
    //PRJ-492.RS.1.0 11May2021 | Hide/Unhide Fields
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    //PRJ-1360.RM.1.0 17May2022 | Added some code
    //PRJ-1624.NK.1.0 22Sep2022 | Added Fields
    layout
    {
        //PRJCTPR-333.PS.1.0 19March2024 Start
        modify(Type)
        {
            Editable = NS_TypeEditeable;
        }
        modify("No.")
        {
            Editable = NS_TypeEditeable;
        }
        //PRJCTPR-333.PS.1.0 19March2024 End 
        //PRJ-492.N.S.1.0 Start
        modify("Location Code")
        {
            Visible = false;
        }
        //PRJ-1332.GK.1.0 25Apr2022 start
        modify("Unit Price")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }
        modify("Line Discount %")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }
        modify("Line Discount Amount")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }
        modify("Inv. Discount Amount")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }
        modify("Line Amount")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }

        modify("Total Amount Excl. VAT")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }
        modify("Total Amount Incl. VAT")
        {
            Editable = NS_EditableProgbillSalesInvoiceSub;
        }

        //PRJ-1332.GK.1.0 25Apr2022 end
        moveafter("Tax Area Code"; "Tax Group Code")
        //PRJ-492.N.S.1.0 END
        modify("Job No.")
        {

            //PRJ-148.SK.1.0 Start
            Editable = true;
            Visible = true;
            //PRJ-148.SK.1.0 End

            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                //ProjectPro - end
            end;
        }
        //PRJ-492.RS.1.0 11May2021 Start
        //PRJCTPR-320.NC.1.0 13Feb2024 Start
        modify("Tax Group Code")
        {
            trigger OnAfterValidate()
            var
                DocumentTotals: Codeunit "Document Totals";
            begin
                DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
                CurrPage.Update();
            end;
        }
        //PRJCTPR-320.NC.1.0 13Feb2024 Start
        moveafter("No."; "Job No.")
        moveafter("Job No."; "Job Task No.")
        //PRJ-492.RS.1.0 11May2021 end

        /* modify("Job Task No.")
         {
             Visible = false;
             Enabled = false;
         }*/

        //moveafter(Description; "Job No.")//PRJ-492.N.S.1.0//PRJ-492.RS.1.0 11May2021 Comment
        addafter("Job No.")
        {
            field("NS_JobTaskNo."; Rec."Job Task No.")
            {
                Caption = 'Job Task No.';
                ToolTip = 'Specifies the number of the related job task.';
                ApplicationArea = Jobs;
                Editable = true;
                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Segment Code"; Rec."NS_Segment Code")
            {
                ApplicationArea = All;
                Description = 'TM-10.AM.1.0';
                Caption = 'Segment Code';//Caption correct
                //Visible = false; //PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021
            }
            //TM-32.AM.1.0
            field("NS_Segment Name"; "NS_Segment Name")
            {
                ApplicationArea = all;
                Visible = false; //PRJ-492.AS.1.0
            }
            //TM-32.AM.1.0
        }



        //addafter("Variant Code")//PRJ-492.N.S.1.0
        /* addafter("Tax Group Code")//PRJ-492.N.S.1.0
         {
             field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the qGen. Bus. Posting Group';
             }
             field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
             {
                 ApplicationArea = All;
                 ToolTip = 'Specifies the qGen. Prod. Posting Group';
             }
         }*/
        addafter("Job Task No.")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
                Visible = false; //PRJ-492.AS.1.0

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")//PRJ-492.RS.1.0 11May2021
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the qGen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")//PRJ-492.RS.1.0 11May2021
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the qGen. Prod. Posting Group';
            }
        }
        //PRJ-492.RS.1.0 11May2021 Start
        addafter(Description)
        {
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
                //Visible = false; //PRJ-492.AS.1.0//PRJ-492.RS.1.0 11May2021 Comment
                Visible = true;//PRJ-492.RS.1.0 11May2021

                trigger OnValidate();
                var
                    RevRec: Record "NS_Job Revenue Category"; //PRJ-1360.RM.1.0  
                begin
                    //PRJ-1360.RM.1.0 start
                    if RevRec.Get(Rec."NS_Job Revenue Category") then
                        Rec."NS_Revenue Cat Description" := RevRec.NS_Description
                    else
                        Rec."NS_Revenue Cat Description" := '';
                    //PRJ-1360.RM.1.0 end
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            //CTSI-42.AS.1.0 21MAY2020 - START
            field("NS_Revenue Cat Description"; REC."NS_Revenue Cat Description")
            {
                ApplicationArea = all;
                Description = 'Specifies Revenue Category Description';
                Editable = true;
                trigger OnValidate()
                var
                    SalesLine_L: Record "Sales Line";
                begin
                    SalesLine_L.Reset;
                    SalesLine_L.SetRange("Document Type", SalesLine_L."Document Type"::Invoice);
                    SalesLine_L.SetRange("Document No.", Rec."Document No.");
                    SalesLine_L.SetRange("NS_Job Revenue Category", Rec."NS_Job Revenue Category");
                    if SalesLine_L.FindSet then
                        repeat
                            SalesLine_L."NS_Revenue Cat Description" := Rec."NS_Revenue Cat Description";
                            SalesLine_L.Modify();
                            CurrPage.Update(false);
                        until SalesLine_L.Next = 0;
                end;
            }
            //CTSI-42.AS.1.0 21MAY2020 - END

            //PRJ-509.8.0 Start
            field("NS_VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            //PRJ-509.8.0 End
        }
        moveafter("Line Amount"; "Tax Area Code")
        moveafter("Tax Area Code"; "Tax Group Code")
        addafter("Shortcut Dimension 2 Code")//PRJ-492.RS.1.0 25May2021 
        {
            field("NS_DFR No."; Rec."NS_DFR No.")
            {
                ApplicationArea = all;
                Description = 'JD-10.MS.1.0';
                Editable = false;
                //Visible = false; //PRJ-492.AS.1.0 //PRJ-492.RS.1.0 25May2021  Comment
                Visible = true;//PRJ-492.RS.1.0 25May2021 
            }
            //PRJ-1624.NK.1.0 22Sep2022 Start
            field("NS_Retention %"; Rec."NS_Retention %")
            {
                ApplicationArea = all;
                Caption = 'Retention %';
                ToolTip = 'Specifies the Retention %';
            }
            field("NS_Retention Amount"; Rec."NS_Retention Amount")
            {
                ApplicationArea = all;
                Caption = 'Retention Amount';
                ToolTip = 'Specifies the Retention Amount';
            }
            //PRJ-1624.NK.1.0 22Sep2022 End
        }
        //PRJ-492.RS.1.0 11May2021 end
    }
    actions
    {
        addafter("F&unctions")
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';
                ToolTip = 'Get Job &Planning Line';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetJobBudgetLocal("Sell-to Customer No.");
                    //ProjectPro - end
                end;
            }
            action("NS_Get Usage")
            {
                ApplicationArea = All;
                Caption = 'Get &Usage';
                ToolTip = 'Get Usage';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetJobLedgerLocal;
                    //ProjectPro - end
                end;
            }
            action("NS_Prepayment Lines")
            {
                ApplicationArea = All;
                Caption = 'Get Prepay&ment Lines';
                ToolTip = 'Get Prepayment Lines';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetPrepayment;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";
        NS_NoNonediteable: Boolean;//PRJCTPR-333.PS.1.0 11April2024

    var
        NS_GetJobUsage: Report "NS_Get Job Usage";
        NS_Job: Record Job;
        NS_Resource: Record Resource;
        Text14021100: Label 'Job No. not entered on the sales header.';
        NS_GenLedgEntry: Record "G/L Entry";
        Text14021101: Label 'Prepayment applied';
        NS_EditableProgbillSalesInvoiceSub: Boolean; //PRJ-1332.GK.1.0 25Apr2022


        NS_TypeEditeable: Boolean; //PRJCTPR-333.PS.1.0 19March2024 


    trigger OnNewRecord(BelowxRec: Boolean);
    var
        SalesHeader: Record 36;
        NS_SalesHeader: Record 36;
    begin
        //ProjectPro - start
        "NS_Retention Applies" := TRUE;
        IF SalesHeader.GET("Document Type", "Document No.") THEN
            "Job No." := SalesHeader."NS_Job No.";
        //ProjectPro - end
    end;
    //PRJ-1332.GK.1.0 25Apr2022 start
    trigger OnAfterGetCurrRecord()
    var
        Salesheader: Record "Sales Header";
        Jobsetup: Record "Jobs Setup";
        NS_SalesHeader: Record "Sales Header"; //PRJCTPR-333.PS.1.0 20March2024
        NS_JobSteup: Record "Jobs Setup"; //PRJCTPR-333.PS.1.0 20March2024
    begin
        if Jobsetup.Get() AND (Jobsetup."NS_Res Amt in Progbill Inv" = true) then begin
            if Salesheader.Get(Rec."Document Type", Rec."Document No.") then
                if Salesheader."NS_Progress Billing Document" = true then
                    NS_EditableProgbillSalesInvoiceSub := false
                else
                    NS_EditableProgbillSalesInvoiceSub := true;
        end else begin
            NS_EditableProgbillSalesInvoiceSub := true;
        end;
        // end;
        //PRJCTPR-333.PS.1.0 20March2024 Start 

        NS_TypeEditeable := true;
        NS_TypeEditeable := NSTypeNonEditeable;

        //PRJCTPR-333.PS.1.0 20March2024 End 

    end;
    //PRJ-1332.GK.1.0 25Apr2022 end

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        NS_TypeEditeable := NSTypeNonEditeable;
    end;

    Local procedure NSTypeNonEditeable(): Boolean
    var
        NS_SalesHeader: Record "Sales Header";
    begin
        NS_NoNonediteable := true;
        NS_SalesHeader.Reset();
        NS_SalesHeader.SetRange("Document Type", Rec."Document Type");
        NS_SalesHeader.SetRange("No.", Rec."Document No.");
        NS_SalesHeader.SetRange("NS_Retention Document", true);
        if NS_SalesHeader.FindFirst() then
            NS_NoNonediteable := false;
        exit(NS_NoNonediteable);

    end;

    //PRJCTPR-333.PS.1.0 20March2024 End 


    procedure NS_NoOnAfterValidate();
    begin
        InsertExtendedText(FALSE);

        //ProjectPro - start
        IF Type = Type::Resource THEN BEGIN
            IF NS_Resource.GET("No.") THEN
                "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
        END;
        //ProjectPro - end
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND (xRec."No." <> '') THEN
            CurrPage.SAVERECORD;
    end;

    procedure NS_GetJobLedgerLocal();
    begin
        //ProjectPro - start
        NS_GetJobUsage.SetCurrentSalesLine(Rec);
        NS_GetJobUsage.RUNMODAL;
        CLEAR(NS_GetJobUsage);
        //ProjectPro - end
    end;

    procedure NS_GetJobBudgetLocal(CustNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_Job: Record Job;
        NS_SalesHeader: Record "Sales Header";
        NS_SalesLine: Record "Sales Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    begin
        //ProjectPro - start
        if "Job No." = '' then begin
            NS_SalesHeader.GET("Document Type", "Document No.");
            NS_SalesHeader.TESTFIELD("NS_Job No.");
            NS_JobNo := NS_SalesHeader."NS_Job No.";
        end else
            NS_JobNo := "Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_GetJobPlanningLine.NS_SetGetFrom("Document Type", 1, "Document No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;
        CLEAR(NS_GetJobPlanningLine);
        //ProjectPro - end
    end;

    procedure NS_GetPrepayment();
    var
        NS_CustLedgEntry: Record "Cust. Ledger Entry";
        NS_Job: Record Job;
        NS_Customer: Record Customer;
        NS_SalesHeader: Record "Sales Header";
        NS_SalesLine: Record "Sales Line";
        NS_GeneralPostingSetup: Record "General Posting Setup";
        NS_BalanceToUse: Decimal;
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_EntryNo: Integer;
        NS_GetPrepaymentLines: Page "NS_Get Prepayment LinesHistory";
    begin
        //ProjectPro - start
        NS_SalesHeader.GET("Document Type", "Document No.");
        if NS_SalesHeader."NS_Job No." > '' then begin
            NS_Job.GET(NS_SalesHeader."NS_Job No.");
            NS_Customer.GET(NS_SalesHeader."Sell-to Customer No.");
            NS_GetPrepaymentLines.NS_Set(NS_SalesHeader."NS_Job No.");
            if NS_GetPrepaymentLines.RUNMODAL = ACTION::LookupOK then begin
                NS_GetPrepaymentLines.NS_Get(NS_EntryNo, NS_BalanceToUse);
                NS_LineNo := 0;
                NS_SalesLine.RESET;
                NS_SalesLine.SETRANGE("Document Type", NS_SalesHeader."Document Type");
                NS_SalesLine.SETRANGE("Document No.", NS_SalesHeader."No.");
                if NS_SalesLine.FINDLAST then
                    NS_LineNo := NS_SalesLine."Line No.";
                NS_LineNo := NS_LineNo + 10000;

                with NS_SalesLine do begin
                    INIT;
                    "Line No." := NS_LineNo;
                    VALIDATE(Type, Type::"G/L Account");
                    // NS_GeneralPostingSetup.GET(NS_Customer."Gen. Bus. Posting Group", NS_Job."NS_Gen. Prod. Posting Group");//PRJ-831.AS.1.0 12OCT2021 Comment old
                    NS_GeneralPostingSetup.GET(NS_Customer."Gen. Bus. Posting Group", NS_Job."NS_Gen. Prod. Posting Group New");//PRJ-831.AS.1.0 12OCT2021 Add New
                    NS_GeneralPostingSetup.TESTFIELD("Sales Prepayments Account");
                    VALIDATE("No.", NS_GeneralPostingSetup."Sales Prepayments Account");
                    "Gen. Bus. Posting Group" := NS_Customer."Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
                    "Gen. Prod. Posting Group" := NS_Job."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                    Description := Text14021101;
                    Quantity := -1;
                    "Outstanding Quantity" := Quantity;
                    "Qty. to Invoice" := Quantity;
                    "Qty. to Ship" := Quantity;
                    "Quantity (Base)" := Quantity;
                    "Outstanding Qty. (Base)" := Quantity;
                    "Qty. to Invoice (Base)" := Quantity;
                    "Qty. to Ship (Base)" := Quantity;
                    VALIDATE("Unit Price", NS_BalanceToUse);
                    "Tax Liable" := false;
                    "NS_Retention Applies" := false;
                    INSERT;
                end;
            end;
        end else
            ERROR(Text14021100);
        //ProjectPro - end
    end;

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Gen. Bus. Posting Group
      +     Gen. Prod. Posting Group
      +     Job Cost Category
      +     Job Revenue Category
      +
      +  - Added function(s):
      +     PP_GetJobLedger
      +     PP_GetJobBudget
      +     PP_GetPrepayment
      +
      +  - Added global variable(s):
      +     PP_GetJobUsage
      +     PP_Job
      +     PP_Resource
      +     PP_GenLedgEntry
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +
      +  - Modification(s):
      +     - OnNewRecord
      +         Set Retention No.
      +         Set Job No.
      +     - Modified controls:
      +         Add call to PP_Job.CorrectForBlankFields on fields
      +             Job No.
      +             Job Task No.
      +     - Menus:
      +         Modify functions
      +           NoOnAfterValidate - Read Resource and set Job Revenue Category
      +-----------------------------------------------------------------------------------------------
    */

}

