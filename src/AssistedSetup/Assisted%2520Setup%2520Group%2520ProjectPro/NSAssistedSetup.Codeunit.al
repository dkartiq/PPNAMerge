codeunit 14021120 NS_AssistedSetupMgt
{
    var
        ExtensionSetupLbl: Label 'Set up ProjectPro Basic', Locked = true;
        ExtensionSetupTxt: Label 'Set up ProjectPro basic Setup fields';
        ProgressBillSetupLbl: label 'Set up ProjectPro Progress Billing', Locked = true;
        ProgressBillSetupTxt: label 'Set up ProjectPro Progress Billing feature.';
        RetentionSetupTxt: label 'Set up ProjectPro Retention feature fields';
        RetentionSetupLbl: label 'Set up ProjectPro Retention';
        SubcontractSetupTxt: Label 'Set up ProjectPro Subcontract feature fields';
        SubcontractSetupLbl: Label 'Set up ProjectPro Subcontract';
        JobQuoteSetupTxt: Label 'Set up ProjectPro JobQuote feature fields';
        JobQuoteSetupLbl: Label 'Set up ProjectPro JobQuote';
        ExtensionSetupHelpUrlTxt: Label 'https://www.projectpro365.com/who-we-help/';
        YouTubeVideoLinkTxt: Label 'https://www.youtube.com/embed/VubixyOOY2g', Locked = true, Comment = '%1 - Video Id';



    //Basic Assisted setup Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure PPOnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        AssistedSetup.Add(NS_GetAppId(), Page::NS_BasicSetupPage, ExtensionSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
            ExtensionSetupHelpUrlTxt, ExtensionSetupTxt);
        GlobalLanguage(1033);
        AssistedSetup.AddTranslation(Page::NS_BasicSetupPage, 1033, ExtensionSetupLbl);
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatus();
    end;

    procedure NS_UpdateStatus()
    var
        ExtensionSetup: Record "Jobs Setup";
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if ExtensionSetup.Get() and (ExtensionSetup."NS_Default Job Class" <> 0) then
            AssistedSetup.Complete(Page::NS_BasicSetupPage);
    end;
    //Basic Assisted setup End
    local procedure NS_GetAppId(): Guid
    var
        EmptyGuid: Guid;
        Info: ModuleInfo;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;






    //Progress Billing Assisted Setup Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure NS_PPProgressBillingOnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        AssistedSetup.Add(NS_GetAppId(), Page::NS_ProgressBillingSetupPage, ProgressBillSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
            ExtensionSetupHelpUrlTxt, ProgressBillSetupTxt);
        GlobalLanguage(1033);
        AssistedSetup.AddTranslation(Page::NS_ProgressBillingSetupPage, 1033, ProgressBillSetupLbl);
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusProgressBillingAssistedSetup();
    end;

    procedure NS_UpdateStatusProgressBillingAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_AIA Form Code" <> '') then
            AssistedSetup.Complete(Page::NS_ProgressBillingSetupPage);
    end;

    //Progress Billing Assisted Setup End



    //Retention Assisted setup start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure NS_PPRetentionOnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        AssistedSetup.Add(NS_GetAppId(), Page::NS_RetentionSetupPage, RetentionSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
            ExtensionSetupHelpUrlTxt, RetentionSetupTxt);
        GlobalLanguage(1033);
        AssistedSetup.AddTranslation(Page::NS_RetentionSetupPage, 1033, RetentionSetupLbl);
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusRetentionAssistedSetup();
    end;

    procedure NS_UpdateStatusRetentionAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Sales Retention Period" <> '') then
            AssistedSetup.Complete(Page::NS_RetentionSetupPage);
    end;

    //Retention Assisted setup End


    //Subcontract Assisted Setup Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure NS_PPSubcontractOnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        AssistedSetup.Add(NS_GetAppId(), Page::NS_SubcontractSetupPage, SubcontractSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
            ExtensionSetupHelpUrlTxt, SubcontractSetupTxt);
        GlobalLanguage(1033);
        AssistedSetup.AddTranslation(Page::NS_SubcontractSetupPage, 1033, SubcontractSetupLbl);
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusSubcontractAssistedSetup();
    end;

    procedure NS_UpdateStatusSubcontractAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Subcontract Default UOM" <> '') then
            AssistedSetup.Complete(Page::NS_SubcontractSetupPage);
    end;
    //Subcontract Assisted Setup End




    //JobQuote Assisted Setup Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure NS_PPJobQuoteOnRegisterAssistedSetup();
    var
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        AssistedSetup.Add(NS_GetAppId(), Page::NS_JobQuoteSetupPage, JobQuoteSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
            ExtensionSetupHelpUrlTxt, JobQuoteSetupTxt);
        GlobalLanguage(1033);
        AssistedSetup.AddTranslation(Page::NS_SubcontractSetupPage, 1033, JobQuoteSetupLbl);
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusJobQuoteAssistedSetup();
    end;

    procedure NS_UpdateStatusJobQuoteAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        AssistedSetup: Codeunit "Assisted Setup";
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Use Default Tasks" <> ExtensionSetup."NS_Use Default Tasks"::" ") then
            AssistedSetup.Complete(Page::NS_SubcontractSetupPage);
    end;
    //JobQuote Assisted Setup End
}