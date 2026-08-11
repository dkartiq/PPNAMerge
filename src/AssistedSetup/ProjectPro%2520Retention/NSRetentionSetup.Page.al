page 14021227 NS_RetentionSetupPage
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Retention Setup';

    layout
    {
        area(Content)
        {
            group(NS_StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStd; MediaResourcesStd."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(NS_FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(NS_Step1)
            {
                Visible = CurrPageNo = 1;
                Caption = '';
                group(NS_WelcomeText)
                {
                    Caption = 'Welcome to ProjectPro Retention Assisted Setup';
                    InstructionalText = 'To use ProjectPro Retention feature you must fill some mandatory information for first use.';
                }
                group(NS_LetsGo)
                {
                    Caption = 'Lets Go';
                    InstructionalText = 'Choose Next to specify Retention setup information';
                }

            }
            group(NS_Step2)
            {
                Visible = CurrPageNo = 2;
                Caption = 'Specify Retention related values';
                InstructionalText = 'This is used in Retention feature of ProjectPro...';
                field(SalesRetentionPeriod; SalesRetentionPeriod)
                {
                    ApplicationArea = all;
                    Caption = 'Sales Retention Period';
                    CharAllowed = '09YYMMDDQQ';
                    ToolTip = 'Specifies the days, how long Retention amount can be hold by Customer';

                }
                field(PurchaseRetentionPeriod; PurchaseRetentionPeriod)
                {
                    ApplicationArea = all;
                    Caption = 'Purchase Retention Period';
                    CharAllowed = '09YYMMDDQQ';
                    ToolTip = 'Specifies the days, how long Retention amount of your vendors you can hold';
                }
                field(RetentionReceivableLedger; RetentionReceivableLedger)
                {
                    ApplicationArea = all;
                    Caption = 'Retention Receivable Ledger';
                    ToolTip = 'Specifies the default value when system post the retention in to customer ledger entry to identify the retention entry';
                    TableRelation = "NS_Retention Ledger Code".NS_Code;
                }
                field(RetentionPaybleLedger; RetentionPaybleLedger)
                {
                    ApplicationArea = all;
                    Caption = 'Retention Payble Ledger';
                    ToolTip = 'Specifies the default value when system post the retention in to vendor ledger entry to identify the retention entry';
                    TableRelation = "NS_Retention Ledger Code".NS_Code;
                }
                field(ProgressBillingNos; ProgressBillingNos)
                {
                    ApplicationArea = all;
                    Caption = 'Progress Billing Nos.';
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Progress Billing. To see the number series that have been setup in the No. Series table, click the drop down arrow in the field';
                    TableRelation = "No. Series";
                }
                field(PurchaseRetentionInactive; PurchaseRetentionInactive)
                {
                    ApplicationArea = all;
                    Caption = 'Purchase Retention Inactive';
                    ToolTip = 'Select this field to Yes, if you do not want to calculate Retention  from the system in case of Purchase documents';

                }
                field(SalesRetentionInactive; SalesRetentionInactive)
                {
                    ApplicationArea = all;
                    Caption = 'Sales Retention Inactive';
                    ToolTip = 'Select this field to Yes, if you do not want to calculate Retention  from the system in case of Sales documents';

                }
                field(NormalVendorLedgerNo; NormalVendorLedgerNo)
                {
                    ApplicationArea = all;
                    Caption = 'Normal Vendor Ledger No.';
                    ToolTip = 'Specifies the default value when system post the normal entry in to vendor ledger entry to identify the main entry';
                    TableRelation = "NS_Retention Ledger Code".NS_Code;
                }
                field(NormalCustomerLedgerNo; NormalCustomerLedgerNo)
                {
                    ApplicationArea = all;
                    Caption = 'Normal Customer Ledger No.';
                    ToolTip = 'Specifies the default value when system post the retention in to customer ledger entry to identify the main entry';
                    TableRelation = "NS_Retention Ledger Code".NS_Code;
                }
                // field(RetentionReceivablesAccount; RetentionReceivablesAccount)
                // {
                //     ApplicationArea = all;
                //     Caption = 'Retention Receivables Account';
                //     ToolTip = 'Specifies the general ledger account to use when you post retention receivable from customers in this posting group';
                //     TableRelation = "G/L Account"."No.";
                // }
                // field(RetentionPaybleAccount; RetentionPaybleAccount)
                // {
                //     ApplicationArea = all;
                //     Caption = 'Retention Payble Account';
                //     ToolTip = 'Specifies the general ledger account to use when you post retention payable from vendors in this posting group';
                //     TableRelation = "G/L Account"."No.";
                // }

            }
            group(NS_Step3)
            {
                Visible = CurrPageNo = 3;
                Caption = 'Finish Retention Assisted Setup';
                InstructionalText = 'Choose finish to complete the Retention Assisted Setup';
            }


        }
    }

    actions
    {
        area(Processing)
        {
            action(NS_Next)
            {
                ApplicationArea = All;
                Enabled = (CurrPageNo >= 1) AND (CurrPageNo < 3);
                Visible = (CurrPageNo >= 1) AND (CurrPageNo < 3);
                InFooterBar = true;
                Promoted = true;
                Caption = 'Next';
                Image = NextRecord;
                trigger OnAction()
                begin
                    CurrPageNo := CurrPageNo + 1;
                end;
            }
            action(NS_Back)
            {
                ApplicationArea = all;
                Enabled = (CurrPageNo <= 3) AND (CurrPageNo > 1);
                InFooterBar = true;
                Promoted = true;
                Caption = 'Back';
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    CurrPageNo := CurrPageNo - 1;
                end;
            }
            action(NS_finish)
            {
                ApplicationArea = all;
                Enabled = CurrPageNo = 3;
                InFooterBar = true;
                Promoted = true;
                Caption = 'Finish';
                Image = Approve;

                trigger OnAction()
                var
                    JobSetup: Record "Jobs Setup";
                    CusPosGrp: Record "Customer Posting Group";
                    VendPosGrp: Record "Vendor Posting Group";
                    SalesRecSetup: Record "Sales & Receivables Setup";
                    PurchRecSetup: Record "Purchases & Payables Setup";
                begin
                    IF JobSetup.Get() then begin
                        JobSetup."NS_Sales Retention Period" := SalesRetentionPeriod;
                        JobSetup."NS_Purchase Retention Period" := PurchaseRetentionPeriod;
                        JobSetup."NS_Retention Receivable Ledger" := RetentionReceivableLedger;
                        JobSetup."NS_Retention Payable Ledger" := RetentionPaybleLedger;
                        JobSetup."NS_Progress Billing Nos." := ProgressBillingNos;
                        JobSetup.Modify(true);
                    end
                    else begin
                        JobSetup.Init();
                        JobSetup."NS_Sales Retention Period" := SalesRetentionPeriod;
                        JobSetup."NS_Purchase Retention Period" := PurchaseRetentionPeriod;
                        JobSetup."NS_Retention Receivable Ledger" := RetentionReceivableLedger;
                        JobSetup."NS_Retention Payable Ledger" := RetentionPaybleLedger;
                        JobSetup."NS_Progress Billing Nos." := ProgressBillingNos;
                        JobSetup.insert(true);
                    end;

                    IF SalesRecSetup.Get() then begin
                        SalesRecSetup."NS_Sales Retention Inactive" := SalesRetentionInactive;
                        SalesRecSetup."NS_Normal Customer Ledger No." := NormalCustomerLedgerNo;
                        SalesRecSetup.Modify();
                    end else begin
                        SalesRecSetup.Init();
                        SalesRecSetup."NS_Sales Retention Inactive" := SalesRetentionInactive;
                        SalesRecSetup."NS_Normal Customer Ledger No." := NormalCustomerLedgerNo;
                        SalesRecSetup.Insert(true);
                    end;

                    IF PurchRecSetup.Get() then begin
                        PurchRecSetup."NS_Purchase Retention Inactive" := PurchaseRetentionInactive;
                        PurchRecSetup."NS_Normal Vendor Ledger No." := NormalVendorLedgerNo;
                        PurchRecSetup.Modify();
                    end else begin
                        PurchRecSetup.Init();
                        PurchRecSetup."NS_Purchase Retention Inactive" := PurchaseRetentionInactive;
                        PurchRecSetup."NS_Normal Vendor Ledger No." := NormalVendorLedgerNo;
                        PurchRecSetup.Insert(true);
                    end;
                    CurrPage.close;
                end;

            }
        }
    }

    var
        CurrPageNo: Integer;
        SalesRetentionPeriod: Text[30];
        PurchaseRetentionPeriod: Text[30];
        RetentionReceivableLedger: Code[20];//TableRel reteled.code
        RetentionPaybleLedger: Code[20];//TableRel reteled.code
        ProgressBillingNos: Code[10]; //TableRel Noseries
        PurchaseRetentionInactive: Boolean;
        SalesRetentionInactive: Boolean;
        NormalVendorLedgerNo: code[20];//TableRel RetentionLedCode.code
        NormalCustomerLedgerNo: code[20]; //TableRel RetentionLedCode.code
        RetentionReceivablesAccount: Code[20]; //TableRel GLAccount
        RetentionPaybleAccount: code[20]; //TableRel GLAccount
        TopBannerVisible: boolean;

        FinishActionEnabled: boolean;
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStd: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStd: Record "Media Resources";
        PPAssistedSetupMgt: Codeunit NS_AssistedSetupMgt;
        NotSetUpQst: Label 'The extension is not set up.\\Are you sure that you want to close this guide?';



    trigger OnInit()
    begin
        CurrPageNo := 1;
        LoadTopBanners();
    end;

    trigger OnQueryClosePage(CloseAction: action): boolean
    var
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    begin
        if CloseAction = Action::OK then
            //if AssistedSetup.ExistsAndIsNotComplete(Page::NS_RetentionSetupPage) then  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            if AssistedSetup.AssistedSetupExistsAndIsNotComplete(NSObjectType::Page, 14021227) then  //PRJCTPR-155.JS.1.0 09SEP2023 line added
                if not Confirm(NotSetUpQst, false) then
                    Error('');
        PPAssistedSetupMgt.NS_UpdateStatusRetentionAssistedSetup();
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStd.Get('AssistedSetup-NoText-400px.png',
           Format(CurrentClientType())) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',
           Format(CurrentClientType()))
        then
            if MediaResourcesStd.Get(MediaRepositoryStd."Media Resources Ref") and
               MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
            then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;
}