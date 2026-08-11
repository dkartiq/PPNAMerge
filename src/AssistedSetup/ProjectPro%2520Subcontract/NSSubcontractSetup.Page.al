page 14021228 NS_SubcontractSetupPage
{
    PageType = NavigatePage;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Subcontract Setup';

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
                    Caption = 'Welcome to ProjectPro Subcontract Assisted Setup';
                    InstructionalText = 'To use ProjectPro Subcontract feature you must fill some mandatory information for first use.';
                }
                group(NS_LetsGo)
                {
                    Caption = 'Lets Go';
                    InstructionalText = 'Choose Next to specify Subcontract setup information';
                }

            }
            group(NS_Step2)
            {
                Visible = CurrPageNo = 2;
                Caption = 'Specify Subcontract related values';
                InstructionalText = 'This is used in Subcontract feature of ProjectPro...';
                field(SubcontractDeafultUOM; SubcontractDeafultUOM)
                {
                    ApplicationArea = all;
                    Caption = 'Subcontract Default UOM';
                    Tooltip = 'Specifies the default unit of measure while creating the subcontract card from job';
                }
                field(SubcontractUseOfUOM; SubcontractUseOfUOM)
                {
                    ApplicationArea = all;
                    Caption = 'Subcontract use of UOM';
                    Tooltip = 'Setup giving you the flexbility to pick the Subcontract Deafult UOM if there is no unit of measure has been provided in planning lines';
                    OptionCaption = 'None,Always Default,Default only if none provided';
                }
                field(SubcontractNos; SubcontractNos)
                {
                    ApplicationArea = all;
                    Caption = 'Subcontract Nos.';
                    ToolTip = 'Specifies the code for the number series that will be used assign numbers to Subcontract numbers. To see the number series that have been setup in the No. Series table, click the drop down arrow in the field';
                    TableRelation = "No. Series";
                }


            }
            group(NS_Step3)
            {
                Visible = CurrPageNo = 3;
                Caption = 'Finish Subcontract Assisted Setup';
                InstructionalText = 'Choose finish to complete the Subcontract Assisted Setup';
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
                        JobSetup."NS_Subcontract Default UOM" := SubcontractDeafultUOM;
                        JobSetup."NS_Subcontract Use of UOM" := SubcontractUseOfUOM;
                        JobSetup."NS_Subcontract Nos." := SubcontractNos;
                        JobSetup.Modify(true);
                    end
                    else begin
                        JobSetup.Init();
                        JobSetup."NS_Subcontract Default UOM" := SubcontractDeafultUOM;
                        JobSetup."NS_Subcontract Use of UOM" := SubcontractUseOfUOM;
                        JobSetup."NS_Subcontract Nos." := SubcontractNos;
                        JobSetup.insert(true);
                    end;

                    CurrPage.close;
                end;

            }
        }
    }

    var
        CurrPageNo: Integer;
        SubcontractDeafultUOM: code[10];
        SubcontractUseOfUOM: Option None,"Always Default","Default only if none provided";
        SubcontractNos: code[10];
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
            if AssistedSetup.ExistsAndIsNotComplete(Page::NS_SubcontractSetupPage) then
                if not Confirm(NotSetUpQst, false) then
                    Error('');
        PPAssistedSetupMgt.NS_UpdateStatusSubcontractAssistedSetup();
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