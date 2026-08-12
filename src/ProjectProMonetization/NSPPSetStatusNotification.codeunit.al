codeunit 14021123 NS_PPSetStatusNotification
{
   // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    //PE-333.JS.1.0 22July2024 Changes related only for W1 App, if someone download the W1 app
    //System do ask for dependency App
    Permissions = tabledata "NS_PPClientLicenseInformation" = ri;//PE-259.AT

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
                    Message := StrSubstNo(LicenseExpiresMsg, NSTestLicense."NS_Valid Upto" - Today);//PRJ-1686.GK.1.0 02Nov2022
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
        NSAppSystemConstsnt: Codeunit "Application System Constants";  //PE-333.JS.1.0 22July2024
        NSApplicationVersion: Text; //PE-333.JS.1.0 22July2024
        NSVersionCode: Text; //PE-333.JS.1.0 22July2024
    begin
        //PE-333.JS.1.0 22July2024-Start - Apply only For W1/Global app
        clear(NSApplicationVersion);
        clear(NSVersionCode);
        NSApplicationVersion := NSAppSystemConstsnt.ApplicationVersion();
        NSVersionCode := CopyStr(NSApplicationVersion, 1, 2);
        if NSVersionCode <> 'W1' then begin
            //PE-333.JS.1.0 22July2024-end
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
        end;//PE-333.JS.1.0 22July2024 line added Apply only For W1/Global app
    end;



}