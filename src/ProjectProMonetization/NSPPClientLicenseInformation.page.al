page 14021230 "NS_PPClientLicenseInformation"
{
    Caption = 'ProjectPro License Detail';
    PageType = List;
    SourceTable = "NS_PPClientLicenseInformation";
    UsageCategory = Administration;
    ApplicationArea = all;
    InsertAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "NS_PPClientLicenseInformation" = rimd;//PE-259.AT
    layout
    {
        area(Content)
        {
            repeater(NS_LicenseDetail)
            {
                Caption = 'License Detail';
                field(NS_LicenceId; Rec."NS_Licence Id")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field(NS_Active; Rec.NS_IsActive)
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = IsActive;
                    Editable = false;

                }
                field(NS_IsExpired; Rec.NS_IsExpired)
                {
                    ApplicationArea = all;
                    Style = Attention;
                    StyleExpr = IsExpired;
                    Editable = false;
                }
                field(NS_IsTrial; Rec.NS_IsTrial)
                {
                    ApplicationArea = all;
                    Style = Ambiguous;
                    StyleExpr = IsTrial;
                    Editable = false;
                }
                field(NS_ValiFrom; Rec."NS_Valid From")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field(NS_ValidUpto; Rec."NS_Valid Upto")
                {
                    ApplicationArea = all;
                    Editable = false;

                }

                field(NS_InstallingPerson; Rec.NS_InstallingPerson)
                {
                    ApplicationArea = all;
                }
                field(NS_InstallingPersonEmail; Rec.NS_InstallingPersonEmail)
                {
                    ApplicationArea = all;
                }
                field(NS_ContactNo; rec.NS_ContactNo)
                {
                    ApplicationArea = all;
                }
            }
        }


    }
    actions
    {

        area(Processing)
        {
            action(NSActivateLicense)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'Activate License';
                trigger OnAction()
                var
                    NSUserSetup: Record "User Setup";
                begin
                    //PE-296.JS.1.0 03JUN2024-Start
                    if NSUserSetup.get(UserId) then
                        if NSUserSetup."NS_Allow PPLicence Activation" = true then begin
                            IF not rec.NS_LicenseRequested then
                                IF Rec.NS_IsTrial or Rec.NS_IsExpired or Rec.NS_Renew then
                                    IF (Rec.NS_InstallingPerson = '') OR (Rec.NS_InstallingPersonEmail = '') or (Rec.NS_ContactNo = '') then
                                        Error('Please provides details in Extension Manager, Contact Email and (Contact No.) fields, so our sales team can connect to you')
                                    else begin
                                        Rec.NS_LicenseRequested := true;
                                        rec.NS_LicenseRequestedDate := today;
                                        rec.NS_Renew := false;
                                        Rec.Modify();
                                        OnAfterLicenseActivationRequested();  //PRJ-1641.JS.1.0 23SEP2022 //PRJ-1686.GK.1.0 26Oct2022
                                        Message('Your request has been submitted successfully, our sales team will contact you on the email provided');
                                    end else
                                    Message('License is already activated')
                            else
                                Message('License has been already requested');
                        end else
                            Error('Please connect your system admin');
                    //PE-296.JS.1.0 03JUN2024-end 
                end;
            }
            action(NSAppRequested)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'App Request';
                trigger OnAction()
                begin
                    IF not Rec.NS_AppRequested then
                        IF (Rec.NS_InstallingPersonEmail = '') then
                            Error('Please provides details in "Contact Email" field, so our ProjectPro team can share the shared Drive link with you')
                        else begin
                            Rec.NS_AppRequested := true;
                            Rec.Modify();
                            OnAfterAppRequested();    //PRJ-1641.JS.1.0 23SEP2022 //PRJ-1686.GK.1.0 26Oct2022
                            Message('Your request has been submitted successfully, you will get a OneDrive link including the App File shortly');
                        end else
                        Message('App File already requested');
                end;
            }
            //PRJ-1686.GK.1.0 04Nov2022 start
            action(NSGetTenantId)
            {
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Get Tenant ID';
                ApplicationArea = All;
                trigger OnAction()
                var
                    //PRJ-1686.GK.5.0 22Dec2022 start
                    myAppInfo: ModuleInfo;
                    NSTestAppSource: Record "NS_PPClientLicenseInformation";
                    AppSecureManagement: Codeunit NS_PPAppSecureManagement;
                    TenantInformation: Codeunit "Azure AD Tenant";
                    EnvirnmentInfo: Codeunit "Environment Information";
                    IsExist: Boolean;
                    EnvInfoCU: Codeunit "Environment Information";
                    NSTestAppSource1: Record "NS_PPClientLicenseInformation";
                    NSTestAppSource2: Record "NS_PPClientLicenseInformation";
                //PRJ-1686.GK.5.0 22Dec2022 end
                begin
                    Message(TenantId());
                    //PRJ-1686.GK.5.0 22Dec2022 start
                    if EnvInfoCU.IsSaaS() then begin
                        NSTestAppSource2.Reset();
                        NSTestAppSource2.SetFilter("NS_Tenant ID", '<>%1', TenantId());
                        if NSTestAppSource2.FindSet() then begin
                            NSTestAppSource2.DeleteAll();
                        end;
                        NSTestAppSource1.Reset();
                        NSTestAppSource1.SetRange("NS_Tenant ID", TenantId());
                        if not NSTestAppSource1.FindFirst() then begin
                            NavApp.GetCurrentModuleInfo(myAppInfo);
                            NS_EnableWebServiceAccess();
                            NSTestAppSource.Init();
                            NSTestAppSource.NS_IsTrial := true;
                            NSTestAppSource."NS_Tenant ID" := TenantId();
                            NSTestAppSource.NS_IsActive := false;
                            NSTestAppSource.NS_IsExpired := false;
                            NSTestAppSource."NS_Valid From" := Today;
                            NSTestAppSource."NS_Valid Upto" := CALCDATE('+30D', today);
                            NSTestAppSource.NS_LicenseRequested := false;
                            NSTestAppSource.NS_LicenseRequestedDate := Today;
                            NSTestAppSource.NS_AppRequested := false;
                            NSTestAppSource.NS_Installed := false;
                            NSTestAppSource.NS_Renew := false;
                            NSTestAppSource.NS_ServerUpdateWithExpiry := false;
                            IF EnvirnmentInfo.IsSaaSInfrastructure() then
                                NSTestAppSource.NS_CompanyName := TenantInformation.GetAadTenantDomainName();
                            NSTestAppSource.Insert(true);
                            AppSecureManagement.NS_SetClientLicenseDetail();
                        end;
                    end;
                    //PRJ-1686.GK.5.0 22Dec2022 end
                end;
            }
            //PRJ-1686.GK.1.0 04Nov2022 end
            //PRJ-1686.GK.1.0 11Nov2022 start             
            action(NSGetAccessToken)
            {
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Get Access Token';
                ApplicationArea = All;
                Visible = false; //PRJ-1686.GK.5.0 22Dec2022
                trigger OnAction()
                var
                    //PRJ-1686.GK.2.0 15Nov2022 start
                    myAppInfo: ModuleInfo;
                    NSTestAppSource: Record "NS_PPClientLicenseInformation";
                    AppSecureManagement: Codeunit NS_PPAppSecureManagement;
                    TenantInformation: Codeunit "Azure AD Tenant";
                    EnvirnmentInfo: Codeunit "Environment Information";
                    IsExist: Boolean;
                    EnvInfoCU: Codeunit "Environment Information";
                //PRJ-1686.GK.2.0 15Nov2022 end
                begin
                    //PRJ-1686.GK.5.0 22Dec2022 start-comment
                    // Message(NS_GetAccessToken());
                    // //PRJ-1686.GK.2.0 15Nov2022 start
                    // if EnvInfoCU.IsSaaS() then begin //PRJ-1686.GK.1.0 03Nov2022
                    //     NavApp.GetCurrentModuleInfo(myAppInfo); // Get info about the currently executing module
                    //                                             // if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
                    //                                             //     begin
                    //     NS_EnableWebServiceAccess();
                    //     NSTestAppSource.Init();
                    //     NSTestAppSource.NS_IsTrial := true;
                    //     NSTestAppSource."NS_Tenant ID" := TenantId();
                    //     NSTestAppSource.NS_IsActive := false;
                    //     NSTestAppSource.NS_IsExpired := false;
                    //     NSTestAppSource."NS_Valid From" := Today;
                    //     NSTestAppSource."NS_Valid Upto" := CALCDATE('+15D', today);
                    //     NSTestAppSource.NS_LicenseRequested := false;
                    //     NSTestAppSource.NS_LicenseRequestedDate := Today;
                    //     NSTestAppSource.NS_AppRequested := false;
                    //     NSTestAppSource.NS_Installed := false;
                    //     NSTestAppSource.NS_Renew := false;
                    //     NSTestAppSource.NS_ServerUpdateWithExpiry := false;
                    //     IF EnvirnmentInfo.IsSaaSInfrastructure() then
                    //         NSTestAppSource.NS_CompanyName := TenantInformation.GetAadTenantDomainName();
                    //     NSTestAppSource.Insert(true);
                    //     AppSecureManagement.NS_SetClientLicenseDetail();
                    // end;
                    //PRJ-1686.GK.2.0 15Nov2022 end
                    //PRJ-1686.GK.5.0 22Dec2022 end-comment
                end;
            }
            action(NSUpdateClientDetails)
            {
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Update Client Details';
                ApplicationArea = All;
                Visible = false; //PRJ-1686.GK.5.0 22Dec2022
                trigger OnAction()
                var
                    AppSecureManagement: Codeunit NS_PPAppSecureManagement;
                    Etag: text[250];
                begin
                    //PRJ-1686.GK.5.0 22Dec2022 start-comment
                    // Message(NS_GetAccessToken());
                    // AppSecureManagement.NS_CheckLicenseExpire();
                    // AppSecureManagement.NS_GetClientLicenseDetail(Etag, false);
                    //PRJ-1686.GK.5.0 22Dec2022 end
                end;
            }
            //PRJ-1686.GK.1.0 11Nov2022 end


        }
    }

    trigger OnOpenPage()
    var
        AppSecure: Codeunit NS_PPAppSecureManagement;
        IsExist: Boolean;
        eta: text;
    begin
        SetStyle();
    end;

    trigger OnAfterGetRecord()
    begin
        SetStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStyle();
    end;

    procedure SetStyle()

    begin
        IF Rec.NS_IsActive then
            IsActive := true;
        IF Rec.NS_IsTrial then
            IsTrial := true;
        IF rec.NS_IsExpired then
            IsExpired := true;
    end;


    var
        IsActive: Boolean;
        IsExpired: Boolean;
        IsTrial: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLicenseActivationRequested()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAppRequested()
    begin
    end;
    //PRJ-1686.GK.1.0 11Nov2022 start|Need for testing.
    /// <summary>
    /// NS_GetAccessToken.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure NS_GetAccessToken(): Text
    var
        NSlClient: HttpClient;
        NSlResponse: HttpResponseMessage;
        NslContent: HttpContent;
        NSlHeaders: HttpHeaders;
        NSlUrl: Text;
        NSlJsonObj: JsonObject;
        NSlJsonToken: JsonToken;
        NSToken: text;
        NSlClientID: text[250];
        NSlSecret: text[250];
        NSBaseTxt: Text[1024];
        NSAPITokenLocal: Text;
    begin
        NSlUrl := 'https://login.microsoftonline.com/' + 'add67cd2-c8b2-416c-b171-b61b22be92f4' + '/oauth2/v2.0/token';
        NSlClientID := '94369b48-2306-4823-b813-79918b663e01';
        NSlSecret := 'sQh8Q~5On62LSkWFHTV~BAIisV9VfTgpSsSWZb8E';
        NSBaseTxt := 'grant_type=client_credentials' + '&scope=https://api.businesscentral.dynamics.com/.default' + '&client_id=' + NSlClientID + '&client_secret=' + NSlSecret;
        NslContent.Clear();
        NSlContent.WriteFrom(NSBaseTxt);
        NSlHeaders.Clear();
        NslContent.GetHeaders(NSlHeaders);
        NslHeaders.Remove('Content-Type');
        NslHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        NSlContent.GetHeaders(NSlHeaders);
        if NSlClient.Post(NSlUrl, NslContent, NSlResponse) then begin
            if NSlResponse.HttpStatusCode = 200 then begin
                NSlResponse.Content().ReadAs(NSToken);
                NslJsonObj.ReadFrom(NSToken);
                NSlJsonObj.Get('access_token', NSlJsonToken);
                NSlJsonToken.WriteTo(NSAPITokenLocal);
                NSAPITokenLocal := DelChr(NSAPITokenLocal, '=', '"');
                Exit(NSAPITokenLocal);
            end else
                exit(GetLastErrorText());
        end
    end;
    //PRJ-1686.GK.1.0 11Nov2022 end

    //PRJ-1686.GK.2.0 15Nov2022 start
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
    //PRJ-1686.GK.2.0 15Nov2022 end
}