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
        EnvInfoCU: Codeunit "Environment Information";//PRJ-1686.GK.1.0 03Nov2022
    begin
        // >> Upgrade
        exit;
        // << Upgrade
        //PRJ-1686.GK.1.0 22Nov2022 start
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        if EnvInfoCU.IsSaaS() then begin //PRJ-1686.GK.1.0 03Nov2022
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
        end;
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end
        //PRJ-1686.GK.1.0 22Nov2022 end
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