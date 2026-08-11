codeunit 14021123 NS_PPSetStatusNotification
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    var
        RanToday: Boolean;


    [Obsolete('Will be removed in next major')]
    procedure SetRanForTheSession()

    begin
        RanToday := true;
    end;

    [Obsolete('Will be removed in next major')]
    procedure IsRanForTheCurrSession(): Boolean
    begin
        exit(RanToday);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::NS_PPAppSecureManagement, 'OnCheckClientSubscription', '', false, false)]
    local procedure NS_OnCheckTrialLicense()
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        TrialNotification: Notification;
        TrialExpiresMsg: Label 'Thank you for trying out the ProjectPro App. Your trial period expires in %1 days. Do you want to activate license?';
        BuySubscriptionActionText: Label 'Activate License...';
    begin
        exit;
        IF NSTestLicense.FindFirst() then begin
            IF NSTestLicense.NS_IsTrial AND not NSTestLicense.NS_LicenseRequested then begin
                with TrialNotification do begin
                    Message := StrSubstNo(TrialExpiresMsg, NSTestLicense."NS_Valid Upto" - Today);
                    Scope := NotificationScope::LocalScope;
                    AddAction(BuySubscriptionActionText, Codeunit::NS_PPAppSecureManagement, 'NS_ActivateLicense');
                    Send();
                end;
            end;
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::NS_PPAppSecureManagement, 'OnCheckClientSubscription', '', false, false)]
    local procedure NS_OnCheckExpiringLicense()
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        TrialNotification: Notification;
        LicenseExpiresMsg: Label 'Your License expires in %1 days!';
        BuySubscriptionActionText: Label 'Renew License...';
    begin
        IF NSTestLicense.FindFirst() then begin
            IF (NSTestLicense.NS_IsActive) AND (NSTestLicense."NS_Valid Upto" - Today <= 5) then begin
                with TrialNotification do begin
                    Message := StrSubstNo(LicenseExpiresMsg);
                    Scope := NotificationScope::LocalScope;
                    AddAction(BuySubscriptionActionText, Codeunit::NS_PPAppSecureManagement, 'NS_ActivateLicense');
                    Send();
                end;
            end;
        end;

    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::NS_PPAppSecureManagement, 'OnCheckClientSubscription', '', false, false)]
    local procedure NS_OnCheckDependentAppInstalled()
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        TrialNotification: Notification;
        DependentAppDoesNotFound: Label 'For providing full access of ProjectPro app, we have developed a dependent app also that you should install before exploring ProjectPro';
        BuySubscriptionActionText: Label 'Request Dependent App...';
    begin
        exit;
        IF NSTestLicense.FindFirst() then begin
            IF not NSTestLicense.NS_AppRequested then begin
                with TrialNotification do begin
                    Message := StrSubstNo(DependentAppDoesNotFound);
                    Scope := NotificationScope::LocalScope;
                    AddAction(BuySubscriptionActionText, Codeunit::NS_PPAppSecureManagement, 'NS_ActivateLicense');
                    Send();
                end;
            end;
        end;

    end;



}