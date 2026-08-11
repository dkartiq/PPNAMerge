page 14021226 NS_ProgressBillingSetupPage
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Progress Billing Setup';

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
                    Caption = 'Welcome to ProjectPro Progress Billing Assisted Setup';
                    InstructionalText = 'To use ProjectPro Progress Billing feature you must fill some mandatory information for first use.';
                }
                group(NS_LetsGo)
                {
                    Caption = 'Lets Go';
                    InstructionalText = 'Choose Next to specify Progress Billing setup information';
                }

            }
            group(NS_Step2)
            {
                Visible = CurrPageNo = 2;
                Caption = 'Specify AIA related values';
                InstructionalText = 'This is used in Progress Billing...';
                field(AIAFormCode; AIAFormCode)
                {
                    ApplicationArea = all;
                    Caption = 'AIA Form Code';

                }
                field(AIAFormExpirationDate; AIAFormExpirationDate)
                {
                    ApplicationArea = all;
                    Caption = 'AIA Expiration Date';
                }
                field(AIAG702ShowWithPageNo; AIAG702ShowWithPageNo)
                {
                    ApplicationArea = all;
                    Caption = 'AIA G702 Show with Page No.';
                }
                field(AIAG703STartAsPageNo; AIAG703STartAsPageNo)
                {
                    ApplicationArea = all;
                    Caption = 'AIA G703 Start as Page No.';
                }
                field(GenProdPosGroup; GenProdPosGroup)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. Prod. Posting Group';
                    TableRelation = "Gen. Product Posting Group".Code;
                }
            }
            group(NS_Step3)
            {
                Visible = CurrPageNo = 3;
                Caption = 'Finish Progress Billing Assisted Setup';
                InstructionalText = 'Choose finish to complete the Progress Billing Assisted Setup';
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
                begin
                    IF JobSetup.Get() then begin
                        JobSetup."NS_AIA Form Code" := AIAFormCode;
                        JobSetup."NS_AIA Form Expiration Date" := AIAFormExpirationDate;
                        JobSetup."NS_AIA G702 Show With Page No." := AIAG702ShowWithPageNo;
                        JobSetup."NS_AIA G703 Start As Page No." := AIAG703STartAsPageNo;
                        //JobSetup."NS_Prog. Bill Gen. ProdPostGr." := GenProdPosGroup;//PRJ-1684.AS.1.0 Commented
                        JobSetup."NS_ProgBillGenProdPostGr New" := GenProdPosGroup;//PRJ-1684.AS.1.0 Add
                        JobSetup.Modify(true);
                    end
                    else begin
                        JobSetup.Init();
                        JobSetup."NS_AIA Form Code" := AIAFormCode;
                        JobSetup."NS_AIA Form Expiration Date" := AIAFormExpirationDate;
                        JobSetup."NS_AIA G702 Show With Page No." := AIAG702ShowWithPageNo;
                        JobSetup."NS_AIA G703 Start As Page No." := AIAG703STartAsPageNo;
                        //JobSetup."NS_Prog. Bill Gen. ProdPostGr." := GenProdPosGroup;//PRJ-1684.AS.1.0 Commented
                        JobSetup."NS_ProgBillGenProdPostGr New" := GenProdPosGroup;//PRJ-1684.AS.1.0 Add
                        JobSetup.insert(true);
                    end;
                    CurrPage.close;
                end;

            }
        }
    }

    var
        CurrPageNo: Integer;
        AIAFormCode: code[20];
        AIAFormExpirationDate: date;
        AIAG702ShowWithPageNo: Integer;
        AIAG703STartAsPageNo: Integer;
        GenProdPosGroup: code[20];
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
            //if AssistedSetup.ExistsAndIsNotComplete(Page::NS_ProgressBillingSetupPage) then  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            if AssistedSetup.AssistedSetupExistsAndIsNotComplete(NSObjectType::Page, 14021226) then  //PRJCTPR-155.JS.1.0 09SEP2023 line added            
                if not Confirm(NotSetUpQst, false) then
                    Error('');
        PPAssistedSetupMgt.NS_UpdateStatusProgressBillingAssistedSetup();
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