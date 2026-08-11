page 14021225 NS_BasicSetupPage
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'ProjectPro Basic Setup';

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
                    Caption = 'Welcome to ProjectPro Basic Assisted Setup';
                    InstructionalText = 'To use ProjectPro Basic  you must fill some mandatory information for first use.';
                }
                group(NS_LetsGo)
                {
                    Caption = 'Lets Go';
                    InstructionalText = 'Choose Next to specify Basic setup information';
                }

            }
            group(NS_Step2)
            {
                Visible = CurrPageNo = 2;
                Caption = 'Specify Basic setup values';
                InstructionalText = 'This is used in ProjectPro Basic Setup...';
                field(DefaultJobClass; DefaultJobClass)
                {
                    ApplicationArea = all;
                    Caption = 'Default Job Class';
                    ToolTip = 'Specifies the categorization of job class while creating a new Job';

                }
                field(APOSeparators; APOSeparators)
                {
                    ApplicationArea = all;
                    Caption = 'APO Separators';
                    ToolTip = 'Specifies the default separators while creating job task lines between Activities, Process and Operations codes';
                }
                field(GenBusPosGroup; GenBusPosGroup)
                {
                    ApplicationArea = all;
                    Caption = 'Gen. Bus. Posting Group';
                    TableRelation = "Gen. Business Posting Group".code;
                    ToolTip = 'Specifies default Gen. Bus. Posting group code to be pick in Purchase and Sales documents if there is no Gen. Bus. Posting group is mentioned on the Job card';
                }
                field(JobNos; JobNos)
                {
                    ApplicationArea = all;
                    Caption = 'Job Nos.';
                    TableRelation = "No. Series";
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Job No. To see the number series that have been setup in the No. Series table, click the drop down arrow in the field';
                }
                field(UseJobMatPlanActive; UseJobMatPlanActive)
                {
                    ApplicationArea = all;
                    Caption = 'Use Job Material Plan Active';
                    ToolTip = 'Specifies whether job material planning functionality to be use against the job';
                }
                field(ChangeOrderSeprator; ChangeOrderSeprator)
                {
                    ApplicationArea = all;
                    Caption = 'Change Order No. Separator';
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Change Orders created from Master Job. To see the number series that have been setup in the No. Series table, click the drop down arrow in the field';
                }
            }
            group(NS_Step3)
            {
                Visible = CurrPageNo = 3;
                Caption = 'Finish Basic Assisted Setup';
                InstructionalText = 'Choose finish to complete the Basic Assisted Setup';
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
                        JobSetup."NS_Default Job Class" := DefaultJobClass;
                        JobSetup."NS_APO Separators" := APOSeparators;
                        JobSetup."NS_Gen. Bus. Posting Group" := GenBusPosGroup;
                        JobSetup."Job Nos." := JobNos;
                        JobSetup."NS_Use Job Mat'l Plan Active" := UseJobMatPlanActive;
                        JobSetup."NS_Change Order No. Separator" := ChangeOrderSeprator;
                        JobSetup.Modify(true);
                    end
                    else begin
                        JobSetup.Init();
                        JobSetup."NS_Default Job Class" := DefaultJobClass;
                        JobSetup."NS_APO Separators" := APOSeparators;
                        JobSetup."NS_Gen. Bus. Posting Group" := GenBusPosGroup;
                        JobSetup."Job Nos." := JobNos;
                        JobSetup."NS_Use Job Mat'l Plan Active" := UseJobMatPlanActive;
                        JobSetup."NS_Change Order No. Separator" := ChangeOrderSeprator;
                        JobSetup.Insert(true);
                    end;
                    CurrPage.close;
                end;

            }

        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PPAssistedSetupMgt: Codeunit NS_AssistedSetupMgt;
        //AssistedSetup: Codeunit "Assisted Setup";   //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    begin
        if CloseAction = Action::OK then
            //if AssistedSetup.ExistsAndIsNotComplete(Page::NS_BasicSetupPage) then  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            if AssistedSetup.AssistedSetupExistsAndIsNotComplete(NSObjectType::Page, 14021225) then  //PRJCTPR-155.JS.1.0 09SEP2023 line added
                if not Confirm(NotSetUpQst, false) then
                    Error('');
        PPAssistedSetupMgt.NS_UpdateStatus();
    end;


    trigger OnInit()
    begin
        CurrPageNo := 1;
        NS_LoadTopBanners();
    end;

    local procedure NS_LoadTopBanners();
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



    var



        DefaultJobClass: Option ,"Master Job",SubJob,"Change Order","Extra Work",Proposed,Template,"Work Order";
        APOSeparators: Text[10];
        GenBusPosGroup: Code[20];
        UseJobMatPlanActive: Boolean;
        JobNos: Code[20];
        CurrPageNo: Integer;

        FinishActionEnabled: boolean;
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStd: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        ChangeOrderSeprator: Text[10];
        TopBannerVisible: boolean;

        MediaResourcesStd: Record "Media Resources";
        NotSetUpQst: Label 'The extension is not set up.\\Are you sure that you want to close this guide?';



}