codeunit 14021121 NS_PPAppSecInstall
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    Subtype = Install;
    Permissions = tabledata "NS_PPClientLicenseInformation" = rimd;

    trigger OnInstallAppPerDatabase();
    var
        myAppInfo: ModuleInfo;
        NSTestAppSource: Record "NS_PPClientLicenseInformation";
        AppSecureManagement: Codeunit NS_PPAppSecureManagement;
        TenantInformation: Codeunit "Azure AD Tenant";
        EnvirnmentInfo: Codeunit "Environment Information";
        IsExist: Boolean;
    begin
        // >> Upgrade
        exit;
        // << Upgrade
        NavApp.GetCurrentModuleInfo(myAppInfo); // Get info about the currently executing module
                                                // if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
                                                //     begin
        NS_EnableWebServiceAccess();
        OnAfterCheckExistingCustomerStatus(TenantId(), IsExist);
        IF NOT IsExist then begin
            NSTestAppSource.Init();
            NSTestAppSource.NS_IsTrial := true;
            NSTestAppSource."NS_Tenant ID" := TenantId();
            NSTestAppSource.NS_IsActive := false;
            NSTestAppSource.NS_IsExpired := false;
            NSTestAppSource."NS_Valid From" := Today;
            NSTestAppSource."NS_Valid Upto" := CALCDATE('+15D', today);
            NSTestAppSource.NS_LicenseRequested := false;
            NSTestAppSource.NS_LicenseRequestedDate := Today;
            NSTestAppSource.NS_AppRequested := false;
            NSTestAppSource.NS_Installed := false;
            NSTestAppSource.NS_Renew := false;
            NSTestAppSource.NS_ServerUpdateWithExpiry := false;
            IF EnvirnmentInfo.IsSaaSInfrastructure() then
                NSTestAppSource.NS_CompanyName := TenantInformation.GetAadTenantDomainName();
            NSTestAppSource.Insert(true);

            OnAfterFreshInstall();
        end;
        // end

    end;


    local procedure NS_EnableWebServiceAccess()
    var
        MyAppInfor: ModuleInfo;
        NavAppSettings: Record "NAV App Setting";
        TenantInfo: Codeunit "Environment Information";
    begin
        NavApp.GetCurrentModuleInfo(MyAppInfor);
        IF TenantInfo.IsSandbox() then begin
            NavAppSettings."App ID" := MyAppInfor.Id;
            NavAppSettings."Allow HttpClient Requests" := true;
            IF not NavAppSettings.Insert() then
                NavAppSettings.Modify();
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFreshInstall()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckExistingCustomerStatus(TenantID: code[20]; Var IsExist: Boolean)
    begin
    end;
}