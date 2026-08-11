page 14021229 NS_JobQuoteSetupPage
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Job Quote Setup';

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
                    Caption = 'Welcome to ProjectPro Job Quote Setup Assisted Setup';
                    InstructionalText = 'To use ProjectPro Job Quote feature you must fill some mandatory information for first use.';
                }
                group(NS_LetsGo)
                {
                    Caption = 'Lets Go';
                    InstructionalText = 'Choose Next to specify Job Quote setup information';
                }

            }
            group(NS_Step2)
            {
                Visible = CurrPageNo = 2;
                Caption = 'Specify Job Quote related values';
                InstructionalText = 'This is used in Job Quote feature of ProjectPro...';
                field(UseDefaultTasks; UseDefaultTasks)
                {
                    ApplicationArea = all;
                    Caption = 'Use Default Tasks';
                    Tooltip = 'Specifies whether job can have its pre-defined template to copy everytime when there is a need to create new job. Though while copying the default template system will prompt to copy the template or not';
                    OptionCaption = ' ,Default,JobType';
                }
                field(BillingJobTaskNo; BillingJobTaskNo)
                {
                    ApplicationArea = all;
                    Caption = 'Billing Job Task No.';
                    ToolTip = 'Specifies default heading while managing with job quoting in case of billing task number. Syste carry forwards this value to new job created from job quote';
                }
                field(TotalTaskNo; TotalTaskNo)
                {
                    ApplicationArea = all;
                    Caption = 'Total Task No.';
                    ToolTip = 'Specifies default heading while managing with job quoting in case of budget total task number. Syste carry forwards this value to new job created from job quote';
                }



            }
            group(NS_Step3)
            {
                Visible = CurrPageNo = 3;
                Caption = 'Finish Job Quote Assisted Setup';
                InstructionalText = 'Choose finish to complete the Job Quote Assisted Setup';
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
                        JobSetup."NS_Use Default Tasks" := UseDefaultTasks;
                        JobSetup."NS_Billing Job Task No." := BillingJobTaskNo;
                        JobSetup."NS_Total Task No." := TotalTaskNo;
                        JobSetup.Modify(true);
                    end
                    else begin
                        JobSetup.Init();
                        JobSetup."NS_Use Default Tasks" := UseDefaultTasks;
                        JobSetup."NS_Billing Job Task No." := BillingJobTaskNo;
                        JobSetup."NS_Total Task No." := TotalTaskNo;
                        JobSetup.insert(true);
                    end;

                    CurrPage.close;
                end;

            }
        }
    }

    var
        CurrPageNo: Integer;
        UseDefaultTasks: Option ,Default,JobType;
        BillingJobTaskNo: code[20];
        TotalTaskNo: Code[20];
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
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if CloseAction = Action::OK then
            if AssistedSetup.ExistsAndIsNotComplete(Page::NS_JobQuoteSetupPage) then
                if not Confirm(NotSetUpQst, false) then
                    Error('');
        PPAssistedSetupMgt.NS_UpdateStatusJobQuoteAssistedSetup();
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