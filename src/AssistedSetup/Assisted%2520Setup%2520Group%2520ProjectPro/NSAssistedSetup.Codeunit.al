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
        YouTubeVideoLinkBasicTxt: Label 'https://www.youtube.com/watch?v=OzaiOjsV6uU', Locked = true, Comment = '%1 - Video Id';
        YouTubeVideoLinkSubcontractTxt: Label 'https://www.youtube.com/watch?v=zzztvU7OaeY', Locked = true, Comment = '%1 - Video Id';
        YouTubeVideoLinkJMPTxt: Label 'https://www.youtube.com/watch?v=dwF8THer3M8', Locked = true, Comment = '%1 - Video Id';
        YouTubeVideoLinkProgBillTxt: Label 'https://www.youtube.com/watch?v=Z1g77HgDsO0', Locked = true, Comment = '%1 - Video Id';


    //Basic Assisted setup Start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]   //PRJCTPR-155.JS.1.0 09SEP2023 line commented
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    local procedure PPOnRegisterAssistedSetup();
    var
        //AssistedSetup: Codeunit "Assisted Setup";     //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";   //PRJCTPR-155.JS.1.0 09SEP2023 line added        
        AssistedSetupGroup: Enum "Assisted Setup Group";
        NSGuidedExperienceType: enum "Guided Experience Type"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        //PRJCTPR-155.JS.1.0 09SEP2023 - Start       
        // AssistedSetup.Add(NS_GetAppId(), Page::NS_BasicSetupPage, ExtensionSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
        //     StrSubstNo(YouTubeVideoLinkBasicTxt), VideoCategory::NS_VideoCategory,
        //     ExtensionSetupHelpUrlTxt, ExtensionSetupTxt);
        AssistedSetup.InsertVideo(ExtensionSetupLbl, ExtensionSetupTxt, 'This Vedio for ProjectPro Basic Setup', 10,
            StrSubstNo(YouTubeVideoLinkBasicTxt), VideoCategory::NS_VideoCategory);
        GlobalLanguage(1033);
        //AssistedSetup.AddTranslation(Page::NS_BasicSetupPage, 1033, ExtensionSetupLbl);
        AssistedSetup.AddTranslationForSetupObjectTitle(NSGuidedExperienceType::"Manual Setup", NSObjectType::Page, 14021225, 1033, ExtensionSetupLbl);
        //PRJCTPR-155.JS.1.0 09SEP2023 - Start
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatus();
    end;

    procedure NS_UpdateStatus()
    var
        ExtensionSetup: Record "Jobs Setup";
        //AssistedSetup: Codeunit "Assisted Setup";     //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    begin
        if ExtensionSetup.Get() and (ExtensionSetup."NS_Default Job Class" <> 0) then
            //AssistedSetup.Complete(Page::NS_BasicSetupPage);      //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            AssistedSetup.CompleteAssistedSetup(NSObjectType::Page, 14021225);  //PRJCTPR-155.JS.1.0 09SEP2023 line added
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
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    local procedure NS_PPProgressBillingOnRegisterAssistedSetup();
    var
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSGuidedExperienceType: enum "Guided Experience Type"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added        
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        //PRJCTPR-155.JS.1.0 09SEP2023 - Start
        // AssistedSetup.Add(NS_GetAppId(), Page::NS_ProgressBillingSetupPage, ProgressBillSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
        //     StrSubstNo(YouTubeVideoLinkProgBillTxt), VideoCategory::NS_VideoCategory,
        //     ExtensionSetupHelpUrlTxt, ProgressBillSetupTxt);
        AssistedSetup.InsertVideo(ProgressBillSetupLbl, ProgressBillSetupTxt, 'This Vedio for ProjectPro Progress Billing Setup', 10,
    StrSubstNo(YouTubeVideoLinkProgBillTxt), VideoCategory::NS_VideoCategory);

        GlobalLanguage(1033);
        //AssistedSetup.AddTranslation(Page::NS_ProgressBillingSetupPage, 1033, ProgressBillSetupLbl);
        AssistedSetup.AddTranslationForSetupObjectTitle(NSGuidedExperienceType::"Manual Setup", NSObjectType::Page, 14021226, 1033, ProgressBillSetupLbl);
        //PRJCTPR-155.JS.1.0 09SEP2023 - end
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusProgressBillingAssistedSetup();
    end;

    procedure NS_UpdateStatusProgressBillingAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        //AssistedSetup: Codeunit "Assisted Setup"; //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added 
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_AIA Form Code" <> '') then
            //AssistedSetup.Complete(Page::NS_ProgressBillingSetupPage);  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            AssistedSetup.CompleteAssistedSetup(NSObjectType::Page, 14021226);  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    end;

    //Progress Billing Assisted Setup End



    //Retention Assisted setup start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    local procedure NS_PPRetentionOnRegisterAssistedSetup();
    var
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";    //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSGuidedExperienceType: enum "Guided Experience Type"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added        
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        //PRJCTPR-155.JS.1.0 09Sep2023 - Start
        // AssistedSetup.Add(NS_GetAppId(), Page::NS_RetentionSetupPage, RetentionSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
        //     StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
        //     ExtensionSetupHelpUrlTxt, RetentionSetupTxt);
        AssistedSetup.InsertVideo('ProjectPro Retention Setup', RetentionSetupLbl, RetentionSetupTxt, 10,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory);

        GlobalLanguage(1033);
        //AssistedSetup.AddTranslation(Page::NS_RetentionSetupPage, 1033, RetentionSetupLbl);
        AssistedSetup.AddTranslationForSetupObjectTitle(NSGuidedExperienceType::"Manual Setup", NSObjectType::Page, 14021227, 1033, RetentionSetupLbl);
        //PRJCTPR-155.JS.1.0 09Sep2023 - end
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusRetentionAssistedSetup();
    end;

    procedure NS_UpdateStatusRetentionAssistedSetup()
    var
        ExtensionSetup: Record "Sales & Receivables Setup";
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Sales Retention Inactive") then
            //AssistedSetup.Complete(Page::NS_RetentionSetupPage);  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            AssistedSetup.CompleteAssistedSetup(NSObjectType::Page, 14021227);  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    end;

    //Retention Assisted setup End


    //Subcontract Assisted Setup Start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]   //PRJCTPR-155.JS.1.0 09SEP2023 line added
    local procedure NS_PPSubcontractOnRegisterAssistedSetup();
    var
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSGuidedExperienceType: enum "Guided Experience Type"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added        
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        //PRJCTPR-155.JS.1.0 09SEP2023 - Start
        // AssistedSetup.Add(NS_GetAppId(), Page::NS_SubcontractSetupPage, SubcontractSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
        //     StrSubstNo(YouTubeVideoLinkSubcontractTxt), VideoCategory::NS_VideoCategory,
        //     ExtensionSetupHelpUrlTxt, SubcontractSetupTxt);
        AssistedSetup.InsertVideo('Assisted Edit Subcontract', SubcontractSetupLbl, SubcontractSetupTxt, 10,
            StrSubstNo(YouTubeVideoLinkSubcontractTxt), VideoCategory::NS_VideoCategory);

        GlobalLanguage(1033);
        //AssistedSetup.AddTranslation(Page::NS_SubcontractSetupPage, 1033, SubcontractSetupLbl);
        AssistedSetup.AddTranslationForSetupObjectTitle(NSGuidedExperienceType::"Manual Setup", NSObjectType::Page, 14021228, 1033, SubcontractSetupLbl);
        //PRJCTPR-155.JS.1.0 09SEP2023 - end
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusSubcontractAssistedSetup();
    end;

    procedure NS_UpdateStatusSubcontractAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added 
    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Subcontract Default UOM" <> '') then
            //AssistedSetup.Complete(Page::NS_SubcontractSetupPage); //PRJCTPR-155.JS.1.0 09SEP2023 line commented
            AssistedSetup.CompleteAssistedSetup(NSObjectType::Page, 14021228);  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    end;
    //Subcontract Assisted Setup End




    //JobQuote Assisted Setup Start
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]  //PRJCTPR-155.JS.1.0 09SEP2023 line added
    local procedure NS_PPJobQuoteOnRegisterAssistedSetup();
    var
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSGuidedExperienceType: enum "Guided Experience Type"; //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage();

        //Group: MNB My Extension Group
        //PRJCTPR-155.JS.1.0 09SEP2023 - Start
        // AssistedSetup.Add(NS_GetAppId(), Page::NS_JobQuoteSetupPage, JobQuoteSetupLbl, AssistedSetupGroup::NS_ProjectProAssistedSetupGroup,
        //     StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory,
        //     ExtensionSetupHelpUrlTxt, JobQuoteSetupTxt);

        AssistedSetup.InsertVideo('Assisted Edit Job Quote', JobQuoteSetupLbl, JobQuoteSetupTxt, 10,
            StrSubstNo(YouTubeVideoLinkTxt), VideoCategory::NS_VideoCategory);

        GlobalLanguage(1033);
        //AssistedSetup.AddTranslation(Page::NS_SubcontractSetupPage, 1033, JobQuoteSetupLbl);
        AssistedSetup.AddTranslationForSetupObjectTitle(NSGuidedExperienceType::"Manual Setup", NSObjectType::Page, 14021229, 1033, ExtensionSetupLbl);
        //PRJCTPR-155.JS.1.0 09SEP2023 - end
        GlobalLanguage(CurrentGlobalLanguage);
        NS_UpdateStatusJobQuoteAssistedSetup();
    end;

    procedure NS_UpdateStatusJobQuoteAssistedSetup()
    var
        ExtensionSetup: Record "Jobs Setup";
        //AssistedSetup: Codeunit "Assisted Setup";  //PRJCTPR-155.JS.1.0 09SEP2023 line commented
        AssistedSetup: Codeunit "Guided Experience";  //PRJCTPR-155.JS.1.0 09SEP2023 line added
        NSObjectType: ObjectType;  //PRJCTPR-155.JS.1.0 09SEP2023 line added

    begin
        if ExtensionSetup.Get() AND (ExtensionSetup."NS_Use Default Tasks" <> ExtensionSetup."NS_Use Default Tasks"::" ") then
            //AssistedSetup.Complete(Page::NS_SubcontractSetupPage);
            AssistedSetup.CompleteAssistedSetup(NSObjectType::Page, 14021229);  //PRJCTPR-155.JS.1.0 09SEP2023 line added            
    end;
    //JobQuote Assisted Setup End
}