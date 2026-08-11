pageextension 14021119 NS_PurchaseOrder extends "Purchase Order"
{
    // version NAVW111.00.00.24742,NAVNA11.00.00.24742,PPNA11.00
    //PRJ-120.SK.1.0 added coode
    //TM-10.AM.1.0 | Added validation on Post action .
    //PRJ-967.GK.1.0 11Oct2021 | Add one field
    //PRJ-999.JS.1.9 18Nov2021 | Add Code
    //PRJ-1087.JS.1.0 18Dec2021 | Add condition for dimension
    //PRJ-1099.JS.1.0 30Dec2021 | Modify code for dimension on condition basis
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1380.NK.1.0 13May2022 | Add Fields
    //PRJ-1480.VC.1.0 29Jun2022 | Modify code for NS_Add Job Address validation
    //PRJ-1510.NK.1.0 21Jul2022 | Add Code    
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    Caption = 'Purchase Order'; //PRJ-1330.NK.1.0 25Apr2022

    layout
    {
        addafter("Assigned User ID")
        {
            //PRJ-1380.NK.1.0 13May2022 Start
            field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
            {
                ApplicationArea = All;
                Caption = 'Job Purchaser';
                // ToolTip = 'Job Purchaser'; //PRJ-1579.RM.1.0 commented
                ToolTip = 'Specifies the Job Purchaser'; //PRJ-1579.RM.1.0 
                Description = 'PRJ-1380.NK.1.0';
            }
            field("NS_Job Manager"; Rec."NS_Job Manager")
            {
                ApplicationArea = All;
                Caption = 'Job Manager';
                // ToolTip = 'Job Manager'; //PRJ-1579.RM.1.0 commented
                // ToolTip = 'Specifies the Job manager'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                ToolTip = 'Specifies the Job Manager'; //PRJ-1579.RM.2.0 

                Description = 'PRJ-1380.NK.1.0';
            }
            //PRJ-1380.NK.1.0 13May2022 End
            field("NS_Job No."; Rec."NS_Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnValidate();
                var
                    NS_Job: Record Job; //PRJ-967.GK.1.0 11Oct2021
                    NS_ProgrBillHead: Record "NS_Progress Billing Header";  //PRJ-1099.JS.1.0 30Dec2021
                    NS_DefaultDim: Record "Default Dimension";  //PRJ-1099.JS.1.0 30Dec2021
                    JobsSetup: Record "Jobs Setup"; //PRJ-1510.NK.1.0 21Jul2022 
                begin
                    //ProjectPro - start
                    CurrPage.UPDATE;   //PRJ-1099.JS.1.0 30Dec2021 line commented
                    //ProjectPro - end
                    //PRJ-967.GK.1.0 11Oct2021 start
                    if Rec."NS_Job No." = '' then
                        Rec.TestField("NS_Add Job Address", false);
                    if (Rec."NS_Add Job Address") AND (Rec."NS_Job No." <> '') then begin
                        if NS_Job.get(Rec."NS_Job No.") then
                            Rec.SetShipToAddress('', '', NS_Job."NS_Job Address 1", NS_Job."NS_Job Address 2",
                                              NS_Job."NS_Job City", NS_Job."NS_Job Post Code", NS_Job."NS_Job County", NS_Job."NS_Job Country/Region Code");
                        ShipToOptions := ShipToOptions::"Default (Company Address)";
                        NS_ShipToEditable := false;
                        Modify();
                    end else begin
                        Rec.Validate("Location Code", '');
                        Rec.Validate("Sell-to Customer No.", '');
                        NS_ShipToEditable := true;

                    end;
                    //PRJ-967.GK.1.0 11Oct2021 end
                    //PRJ-1510.NK.1.0 21Jul2022 Start
                    JobsSetup.Get();
                    if JobsSetup."NS_Enable Job Address" then begin
                        if Rec."NS_Job No." <> '' then begin
                            Rec."NS_Add Job Address" := true;
                            if NS_Job.get(Rec."NS_Job No.") then
                                Rec.SetShipToAddress('', '', NS_Job."NS_Job Address 1", NS_Job."NS_Job Address 2",
                                                  NS_Job."NS_Job City", NS_Job."NS_Job Post Code", NS_Job."NS_Job County", NS_Job."NS_Job Country/Region Code");
                            ShipToOptions := ShipToOptions::"Custom Address";
                            NS_ShipToEditable := false;
                            Rec."Ship-to Name" := NS_Job.Description;
                            Rec.Modify();
                        end else begin
                            Rec."NS_Add Job Address" := false;
                            Rec.Validate("Location Code", '');
                            Rec.Validate("Sell-to Customer No.", '');
                            NS_ShipToEditable := true;
                            ShipToOptions := ShipToOptions::"Default (Company Address)";
                            Rec.Modify();
                        end;
                    end;
                    //PRJ-1510.NK.1.0 21Jul2022 End
                    //PRJCTPR-199.JS.1.0 11DEC23 start Below code commented
                    // if rec."NS_Job No." <> '' then begin
                    //     NS_JobsSetup.Get();  //PRJ-1087.JS.1.0 18Dec2021 add line
                    //     If NS_JobsSetup."NS_Flow Job Card Dimension" = true then begin //PRJ-1087.JS.1.0 18Dec2021 add line
                    //         IF Rec."NS_Job No." <> '' then
                    //             if NS_Job.Get(Rec."NS_Job No.") then begin
                    //                 Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    //                 Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    //                 Rec."Dimension Set ID" := Rec.GetDimensionNoFromJob(Rec."NS_Job No.");
                    //             end;
                    //         //PRJ-1099.JS.1.0 30Dec2021-Start        
                    //     end else
                    //         if NS_Job.get(Rec."NS_Job No.") then begin
                    //             NS_DefaultDim.Reset();
                    //             NS_DefaultDim.SetRange("Table ID", 23);
                    //             NS_DefaultDim.SetRange("No.", Rec."Buy-from Vendor No.");
                    //             if NS_DefaultDim.IsEmpty() then begin
                    //                 Rec."Shortcut Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                    //                 Rec."Shortcut Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                    //                 Rec."Dimension Set ID" := NS_ProgrBillHead.GetDimensionNoFromJob(Rec."NS_Job No.");
                    //             end;
                    //         end;
                    // end;
                    // //PRJ-1099.JS.1.0 30Dec2021-End
                    // CurrPage.UPDATE();   //PRJ-1099.JS.1.0 30Dec2021 add line                    
                    //PRJCTPR-199.JS.1.0 11DEC23 end Below code commented 
                end;
            }
            //PE-260.JS.1.0 20FEB2024 - Start
            field("NS_Multiple Jobs on Lines"; Rec."NS_Multiple Jobs on Lines")
            {
                caption = 'Multiple Jobs on Lines';  //PE-260.JS.1.0 12MAR2024
                ApplicationArea = All;
                ToolTip = 'If enabled, you can manually select multiple jobs on the purchase order/invoice lines, even if the job number is defined on the purchase order/invoice header. It is suggested to take different jobs but with similar "Tax Area Code" to avoid inconsistency in tax calculation. Please note that, this is not applicable for the purchase orders/invoices created via JMP and Subcontracts.';
            }
            //PE-260.JS.1.0 20FEB2024 - end            
            field("NS_Job Name"; Rec."NS_Job Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Name';
            }
            field("NS_Job Location"; Rec."NS_Job Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Location';
            }
            field("NS_Subcontract No."; Rec."NS_Subcontract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Subcontract No.';
            }
            field("NS_Draw No."; Rec."NS_Draw No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Draw No.';
            }
            //PRJ-120.SK.1.0 Start
            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                // ToolTip = 'General Bus. Pos. Grp.'; //PRJ-1579.RM.1.0  commented
                ToolTip = 'Specifies the General Bus. Pos. Grp.'; //PRJ-1579.RM.1.0 
            }
            //PRJ-120.SK.1.0 End
        }
        //PPDA.1.0.TBA Start
        addafter(Prepayment)
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
        //PRJ-967.GK.1.0 11Oct2021 start
        addafter(ShippingOptionWithLocation)
        {
            field("NS_Add Job Address"; Rec."NS_Add Job Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if Job No. is not blank';
                trigger OnValidate()
                var
                    NS_Job: Record Job;

                begin
                    if Rec."NS_Add Job Address" = true then
                        Rec.TestField("NS_Job No.");
                    if (Rec."NS_Add Job Address") AND (Rec."NS_Job No." <> '') then begin
                        if NS_Job.get(Rec."NS_Job No.") then
                            Rec.SetShipToAddress('', '', NS_Job."NS_Job Address 1", NS_Job."NS_Job Address 2",
                                              NS_Job."NS_Job City", NS_Job."NS_Job Post Code", NS_Job."NS_Job County", NS_Job."NS_Job Country/Region Code");
                        //PRJ-1480.VC.1.0 29Jun2022 start
                        //ShipToOptions := ShipToOptions::"Default (Company Address)";//PRJ-1480 Commented
                        ShipToOptions := ShipToOptions::"Custom Address";
                        //PRJ-1480.VC.1.0 29Jun2022 end
                        NS_ShipToEditable := false;
                        Rec."Ship-to Name" := NS_Job.Description;//PRJ-1344.RM.1.0
                        Rec.Modify(); //PRJ-1135.NK.1.0
                    end else begin
                        Rec.Validate("Location Code", '');
                        Rec.Validate("Sell-to Customer No.", '');
                        NS_ShipToEditable := true;
                        //PRJ-1480.VC.1.0 29Jun2022 Start
                        ShipToOptions := ShipToOptions::"Default (Company Address)";
                        //PRJ-1480.VC.1.0 29Jun2022 end
                    end;

                end;

            }
        }
        modify(ShippingOptionWithLocation)
        {
            Editable = NS_ShipToEditable;
        }
        //PRJ-967.GK.1.0 11Oct2021 end
    }
    actions
    {
        //TM-10.AM.1.0 start
        modify(Post)
        {
            trigger OnBeforeAction()
            var
            begin
                JobSetup.Get();
                if JobSetup."NS_Job Segment Mandatory" then
                    if PurchLineSegment.Type <> PurchLineSegment.Type::"Fixed Asset" then begin
                        PurchLineSegment.Reset();
                        PurchLineSegment.SetCurrentKey("Document No.", "Line No.");
                        PurchLineSegment.SetRange("Document No.", Rec."No.");
                        PurchLineSegment.SetRange("Document Type", Rec."Document Type");
                        PurchLineSegment.SetFilter("No.", '<>%1', '');
                        PurchLineSegment.SetFilter("Job No.", '<>%1', '');
                        if PurchLineSegment.FindSet() then begin
                            repeat
                                PurchLineSegment.TestField("NS_Segment Code");
                            until PurchLineSegment.Next() = 0;
                        end;
                    end;
            end;
        }

        //TM-10.AM.1.0 end
        addafter(GetRecurringPurchaseLines)
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';
                Image = JobLines;
                ToolTip = 'Get Job Planning Line';

                trigger OnAction();
                var
                    JobPlanningLine: Record "Job Planning Line";
                    NextLineNo: Integer;
                    JobPlanningList: Page "Job Planning Lines";
                begin
                    //ProjectPro - start
                    with JobPlanningLine do begin
                        JobPlanningList.LOOKUPMODE := true;
                        SETRANGE("Job No.", Rec."NS_Job No.");
                        SETFILTER("Line Type", '%1|%2', "Line Type"::Budget,
                                                      "Line Type"::"Both Budget and Billable");
                        JobPlanningList.SETTABLEVIEW(JobPlanningLine);
                        JobPlanningList.SetGetFrom(true, '', Rec."No.");
                        JobPlanningList.RUNMODAL;
                        CLEAR(JobPlanningList);
                    end;
                    //ProjectPro - end
                end;
            }
            action("NS_Progress Payments")
            {
                ApplicationArea = All;
                Caption = 'Progress Payments';
                Image = ProjectExpense;
                Promoted = true;
                PromotedCategory = Process;
                tooltip = 'Progress Payments';

                trigger OnAction();
                var
                    ProgressPaymentHeader: Record "NS_Progress Payment Header";
                begin
                    //ProjectPro - start
                    ProgressPaymentHeader.RESET;
                    ProgressPaymentHeader.SETRANGE("NS_No.", "NS_Subcontract No.");
                    PAGE.RUNMODAL(PAGE::"NS_Progress Payment List", ProgressPaymentHeader);
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
        PurchLineSegment: Record "Purchase Line";//TM-10.AM.1.0 
        JobSetup: Record "Jobs Setup";//TM-10.AM.1.0

        NS_RetentionBaseAmount: Decimal;
        [InDataSet]
        NS_RetentionPercentEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountLCYEditable: Boolean;
        [InDataSet]
        NS_RetentionAmountEditable: Boolean;
        [InDataSet]
        NS_RetentionDateEditable: Boolean;
        NS_ShipToEditable: Boolean; //PRJ-967.GK.1.0 11Oct2021
        NS_Text14021100: Label 'Purchase Order can not be deleted because Progress Payment is used.';

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
        NS_Jobs: Record Job;   //PRJ-999.JS.1.0 12Novv2021
        NS_JobSetup: Record "Jobs Setup";  //PRJ-1087.JS.1.0 18Dec2021
    begin
        //ProjectPro - start
        NS_RetentionCalcs;
        //ProjectPro - end
        //PRJ-999.JS.1.0 18Nov2021 Start
        //PRJ-1099.JS.1.0 30Dec2021-Start        
        // NS_JobsSetup.Get();  //PRJ-1087.JS.1.0 18Dec2021 add line
        // If NS_JobsSetup."NS_Flow Job Card Dimension" = true then  //PRJ-1087.JS.1.0 18Dec2021 add line
        //     IF Rec."NS_Job No." <> '' then
        //         if NS_Jobs.Get(Rec."NS_Job No.") then begin
        //             Rec."Shortcut Dimension 1 Code" := NS_Jobs."Global Dimension 1 Code";
        //             Rec."Shortcut Dimension 2 Code" := NS_Jobs."Global Dimension 2 Code";
        //             Rec."Dimension Set ID" := Rec.GetDimensionNoFromJob(Rec."NS_Job No.");
        //         end;
        //PRJ-1099.JS.1.0 30Dec2021-end        
        //PRJ-999.JS.1.0 18Nov2021 end
    end;
    //PRJ-967.GK.1.0 11Oct2021 start
    trigger OnAfterGetCurrRecord()
    var
        JobsSetup: Record "Jobs Setup"; //PRJ-1510.NK.1.0 21Jul2022
    begin
        if Rec."NS_Job No." = '' then
            NS_ShipToEditable := true;
        //PRJ-1510.NK.1.0 21Jul2022 Start
        JobsSetup.Get();
        if JobsSetup."NS_Enable Job Address" then
            if (Rec."NS_Add Job Address") AND (Rec."NS_Job No." <> '') then begin
                ShipToOptions := ShipToOptions::"Custom Address";
                NS_ShipToEditable := false;
            End;
    end;
    //PRJ-967.GK.1.0 11Oct2021 end

    //PE-252.PS.1.0 20Feb2024 Start
    trigger OnNewRecord(Bool: Boolean)
    var
        myInt: Integer;
    begin
        Rec.Validate("NS_Job No.", Rec.GetFilter("NS_Job No."));
    end;
    //PE-252.PS.1.0 20Feb2024 End 

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

        if NS_JobsSetup."NS_Calc Payable Ret Before Tax" then begin
            NS_RetentionAmountLCYEditable := false;
            NS_RetentionAmountEditable := false;
        end;
        //ProjectPro - end
    end;

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP Job No.
      +     Job Name
      +     Job Location
      +     PP Subcontract No.
      +     PP Draw No.
      +     - Retention Group - PP Retention
      +         PP Retention Base Amount
      +         PP Retention Percent
      +         PP Retention Amount (LCY);
      +         PP Retention Amount
      +         PP Retention Date;
      +
      +  - Added function(s):
      +     PP_RetentionCalcs
      +
      +  - Added global variable(s):
      +     PP_RetentionBaseAmount
      +     PP_RetentionPercentEditable
      +     PP_RetentionAmountLCYEditable
      +     PP_RetentionAmountEditable
      +     PP_RetentionDateEditable
      +     PP_JobsSetup
      +     PP_ProgressPaymentHeader
      +     PP_JobProgressPaymentList
      +
      +  - Added global text constant(s):
      +           PP_Text14021100
      +
      +  - Modification(s):
      +     - OnOpenPage - Read Jobs setup records
      +                  - Initialize variables
      +
      +     - OnAfterGetRecord  - Call PP_RetentionCalcs
      +
      +     - OnDeleteRecord    - Check that there are no Progress Payments Headers existing
      +
      +     - Added action list:
      +         PP Get Job Planning Line
      +         PP_Progress Payments
      +
      +     - Modify action list:
      +         Post - Added Call to PP Get Subcontract
      +
      + -SMP
      +  -Modified Page Triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      + OnDelete code moved to EventSubscriber(ObjectType::Codeunit, 364, 'OnBeforeInitDeleteHeader')
      +-----------------------------------------------------------------------------------------------
      */

}

