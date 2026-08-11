codeunit 14021122 "NS_PPAppSecureManagement"
{

    Permissions = tabledata "NS_PPClientLicenseInformation" = rimd;



    var
        [NonDebuggable]
        NS_Int: Integer;//PRJ-1686.GK.1.0 26Oct2022|Added
                        //UserName: label 'jetinder.saini';
                        // UserName: label 'Appsecuser';
    [NonDebuggable]
    // Password: Label 'DCeCJagUw+anlq5R0sAFfrEUu5jfse7rwz+JWSC7W7g=';     //PRJ-1237.JS.1.0  line commented //PRJ-1686.GK.1.0 26Oct2022|Comment
    //Password: Label 'BiLOKM226QO+mBFw7uv9beU1e+Q6PxvGzt4w+U6mRwg=';   //PRJ-1237.JS.1.0 line commented
    //Password: Label 'fqeopdXxeEqzEoL4B+sSgiT4zYvdk3vHWZM5QQRiEUk=';
    // Password: label 'MrU0K+GJ99poYU+Fq7mN+i2IdDpmPwUMCCeXHr24ZEQ=';

    procedure NS_GetJsonTokenText(JsonObject: JsonObject; TokenKey: Text) Jsontoken: JsonToken;
    begin
        if not JsonObject.get(TokenKey, Jsontoken) then
            Error('Could not find Token key');

    end;

    // [NonDebuggable]
    procedure NS_GetClientLicenseDetail(Var EtagVar: text[250]; EtagRequested: Boolean): Boolean
    var
        TestAppLicence: Record "NS_PPClientLicenseInformation";
        URL, ResponseText, LicenceId, CompanyName1 : Text;
        Active, Trial, Expired : boolean;
        InstallingContactEmail: text[100];
        ContactNo: code[20];
        InstallingPerson: code[50];
        ValiFrom, ValidUpto : date;
        WebRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpClientVar: HttpClient;
        WebReseponse: HttpResponseMessage;
        Odatacontext: JsonObject;
        i: Integer;
        TypeHelper: Codeunit "Type Helper";
        LicenceKeyValue: Text[250];
        NapApp: Record "NAV App Setting";
        HttpContentVar: HttpContent;
        TenantIdVar: text[250];
        JsonTokenVar, JToken : JsonToken;
        JsonArrayVar: JsonArray;
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        ETag: text[250];
        VlU, VlF : text;

    begin
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        Clear(URL);
        TenantIdVar := '''' + TenantId() + '''';
        TenantIdVar := CopyStr(TenantIdVar, 1, StrLen(TenantIdVar));
        URL := 'https://api.businesscentral.dynamics.com/v2.0/netsmartz.com/PPNAV17/api/netsmartz/applicence1/v1.0/companies(9257fcbf-4323-eb11-bb73-000d3a244a02)/eapplicences1?$filter=tenantid%20eq%20' + TenantIdVar;
        // URL := 'http://52.167.173.31:18758/BC18APPSECURITY/api/netsmartz/applicence1/v1.0/companies(74e35bd0-2590-eb11-bb66-000d3abcddd1)/eapplicences1?$filter=licenceid%20eq%20' + COPYSTR(NSTestLicense."NS_Licence Id", 2, 36);
        ContentHeaders.Clear();
        HttpContentVar.GetHeaders(ContentHeaders);
        WebRequest.SetRequestUri(URL);
        WebRequest.Method('Get');
        ClearLastError;
        //PRJ-1686.GK.1.0 26Oct2022 start
        //NS_AddHttpBasicAuthHeader(UserName, Password, HttpClientVar);
        NS_AddHttpOAuthHeader(HttpClientVar);
        //PRJ-1686.GK.1.0 26Oct2022 end
        HttpClientVar.Send(WebRequest, WebReseponse);
        WebReseponse.Content.ReadAs(ResponseText);
        if not WebReseponse.IsSuccessStatusCode then
            exit(false)
        else begin
            WebReseponse.Content.ReadAs(ResponseText);
            JToken.ReadFrom(ResponseText);
            Odatacontext := JToken.AsObject();
            Odatacontext.SelectToken('value', JsonTokenVar);
            JsonArrayVar := JsonTokenVar.AsArray();

            For i := 0 to JsonArrayVar.count() - 1 do begin
                JsonArrayVar.get(i, JsonTokenVar);
                Odatacontext := JsonTokenVar.AsObject();
                ETag := NS_GetJsonTokenText(Odatacontext, '@odata.etag').AsValue().AsText();
                IF ETag <> '' then
                    EtagVar := ETag;
                LicenceId := NS_GetJsonTokenText(Odatacontext, 'licenceid').AsValue().AsText();
                Trial := NS_GetJsonTokenText(Odatacontext, 'IsTrial').AsValue().AsBoolean();
                Active := NS_GetJsonTokenText(Odatacontext, 'active').AsValue().AsBoolean();
                ValiFrom := NS_GetJsonTokenText(Odatacontext, 'validfrom').AsValue().AsDate();
                ValidUpto := NS_GetJsonTokenText(Odatacontext, 'validupto').AsValue().AsDate();
                CompanyName1 := NS_GetJsonTokenText(Odatacontext, 'companynamenew').AsValue().AsText();
                TenantIdVar := NS_GetJsonTokenText(Odatacontext, 'tenantid').AsValue().AsText();
                Expired := NS_GetJsonTokenText(Odatacontext, 'expired').AsValue().AsBoolean();
                InstallingContactEmail := NS_GetJsonTokenText(Odatacontext, 'InstallingPersonEmail').AsValue().AsText();
                InstallingPerson := NS_GetJsonTokenText(Odatacontext, 'InstallingPerson').AsValue().AsText();
                ContactNo := NS_GetJsonTokenText(Odatacontext, 'ContactNo').AsValue().AsCode();
                IF Not EtagRequested then
                    NS_UpdateClientDetails2(Expired, Active, Trial, ValiFrom, ValidUpto, InstallingPerson, InstallingContactEmail, LicenceId, ContactNo);
            end;
        end;
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end
    end;

    [NonDebuggable]
    procedure NS_UpdateClientDetails2(Expired: Boolean; Active: boolean; IsTrial: boolean; VaildFrom: date; ValidUpTo: date; InstallingPerson: code[50]; ContactEMail: text[100]; LicenseID: text; ContactNo: code[20])
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        LicenseIDLocal: text;
    begin
        IF NOT NSTestLicense.FindFirst() then begin
            NSTestLicense.Init();
            NSTestLicense."NS_Licence Id" := LicenseID;
            NSTestLicense.VALIDATE(NS_IsActive, Active);
            NSTestLicense."NS_Valid From" := VaildFrom;
            NSTestLicense."NS_Valid Upto" := ValidUpTo;
            NSTestLicense.NS_IsTrial := IsTrial;
            NSTestLicense.NS_InstallingPerson := InstallingPerson;
            NSTestLicense.NS_InstallingPersonEmail := ContactEMail;
            NSTestLicense.NS_IsExpired := Expired;
            NSTestLicense."NS_Tenant ID" := TenantId();
            NSTestLicense.NS_ContactNo := ContactNo;
            NSTestLicense.Insert();
        end else begin
            NSTestLicense."NS_Licence Id" := LicenseID;
            NSTestLicense.VALIDATE(NS_IsActive, Active);
            NSTestLicense."NS_Valid From" := VaildFrom;
            NSTestLicense."NS_Valid Upto" := ValidUpTo;
            NSTestLicense.NS_IsTrial := IsTrial;
            NSTestLicense.NS_InstallingPerson := InstallingPerson;
            NSTestLicense.NS_InstallingPersonEmail := ContactEMail;
            NSTestLicense.NS_IsExpired := Expired;
            NSTestLicense."NS_Tenant ID" := TenantId();
            NSTestLicense.NS_ContactNo := ContactNo;
            NSTestLicense.Modify();
        end;
    end;

    [Obsolete('Will be replaced by NS_UpdateClientDetails2')]
    [NonDebuggable]
    procedure NS_UpdateClientDetails(Expired: Boolean; Active: boolean; IsTrial: boolean; VaildFrom: date; ValidUpTo: date; InstallingPerson: code[50]; ContactEMail: text[100]; LicenseID: text)
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
        LicenseIDLocal: text;
    begin
        IF NOT NSTestLicense.FindFirst() then begin
            NSTestLicense.Init();
            NSTestLicense."NS_Licence Id" := LicenseID;
            NSTestLicense.VALIDATE(NS_IsActive, Active);
            NSTestLicense."NS_Valid From" := VaildFrom;
            NSTestLicense."NS_Valid Upto" := ValidUpTo;
            NSTestLicense.NS_IsTrial := IsTrial;
            NSTestLicense.NS_InstallingPerson := InstallingPerson;
            NSTestLicense.NS_InstallingPersonEmail := ContactEMail;
            NSTestLicense.NS_IsExpired := Expired;
            NSTestLicense."NS_Tenant ID" := TenantId();

            NSTestLicense.Insert();
        end;
    end;

    [NonDebuggable]
    procedure NS_AddHttpBasicAuthHeader(UserName: Text[100]; Password: Text[100]; var HttpClient: HttpClient);
    var
        AuthString: Text;
        Base64Helpers: Codeunit "Base64 Convert";
    begin
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        //AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        //AuthString := Base64Helpers.ToBase64(AuthString);
        //AuthString := STRSUBSTNO('Basic %1', AuthString);
        //HttpClient.DefaultRequestHeaders().Add('Authorization', AuthString);
        //PRJ-1641.JS.1.0 23SEP2022 - end
    end;

    //PRJ-1686.GK.1.0 26Oct2022 start
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

    /// <summary>
    /// NS_AddHttpOAuthHeader.
    /// </summary>
    /// <param name="HttpClient">VAR HttpClient.</param>
    [NonDebuggable]
    procedure NS_AddHttpOAuthHeader(var HttpClient: HttpClient);
    var
        NSAccessToken: Text;
    begin
        Clear(NSAccessToken);
        NSAccessToken := NS_GetAccessToken();
        HttpClient.DefaultRequestHeaders().Add('Authorization', 'Bearer ' + NSAccessToken);
    end;
    //PRJ-1686.GK.1.0 26Oct2022 end



    [NonDebuggable]
    procedure NS_SetClientLicenseDetail(): Boolean
    var
        URL, Authorization, ResponseText : Text;
        WebRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpClientVar: HttpClient;
        WebReseponse: HttpResponseMessage;
        HttpContentVar: HttpContent;
        PayLoad: text[1024];
        NSTestAppLicense: Record "NS_PPClientLicenseInformation";
        LicenseID: Label '{"licenceid":';
        IsTrialVar: text[5];
        ActiveVar: text[5];
        AppRequestedVar, InstalledVar, RenewVar, ServerUpdateWithExpiryVar : text[5];
        HttpHeaderVar: HttpHeaders;
        UserRec: Record User;
        LicenseReqVar: text[5];
        DateVar: text[20];
    begin
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        Clear(PayLoad);
        Clear(ActiveVar);
        Clear(IsTrialVar);
        Clear(NSTestAppLicense);
        IF NSTestAppLicense.FindFirst() then;
        IF NSTestAppLicense.NS_ServerUpdateWithExpiry then
            ServerUpdateWithExpiryVar := 'true'
        else
            ServerUpdateWithExpiryVar := 'false';
        IF NSTestAppLicense.NS_Renew then
            RenewVar := 'true'
        else
            RenewVar := 'false';
        IF NSTestAppLicense.NS_Installed then
            InstalledVar := 'true'
        else
            InstalledVar := 'false';
        IF NSTestAppLicense.NS_AppRequested then
            AppRequestedVar := 'true'
        else
            AppRequestedVar := 'false';

        IF NSTestAppLicense.NS_IsTrial then
            IsTrialVar := 'true'
        else
            IsTrialVar := 'false';
        IF NSTestAppLicense.NS_ISActive then
            ActiveVar := 'true'
        else
            ActiveVar := 'false';

        if NSTestAppLicense.NS_LicenseRequested then
            LicenseReqVar := 'true'
        else
            LicenseReqVar := 'false';

        PayLoad := LicenseID + '"' + COPYSTR(NSTestAppLicense."NS_Licence Id", 2, 36) + '",';
        PayLoad := PayLoad + '"active":' + '"' + ActiveVar + '",';
        PayLoad := PayLoad + '"tenantid":' + '"' + Format(NSTestAppLicense."NS_Tenant ID") + '",';
        PayLoad := PayLoad + '"IsTrial":' + '"' + IsTrialVar + '",';
        PayLoad := PayLoad + '"validfrom":' + '"' + NS_CalCulateValidUpToValidFrom(NSTestAppLicense."NS_Valid From") + '",';
        PayLoad := PayLoad + '"validupto":' + '"' + NS_CalCulateValidUpToValidFrom(NSTestAppLicense."NS_Valid Upto") + '",';
        PayLoad := PayLoad + '"companynamenew":' + '"' + Format(NSTestAppLicense.NS_CompanyName) + '",';
        PayLoad := PayLoad + '"InstallingPerson":' + '"' + Format(NSTestAppLicense.NS_InstallingPerson) + '",';
        PayLoad := PayLoad + '"LicenseRequested":' + '"' + Format(LicenseReqVar) + '",';
        PayLoad := PayLoad + '"LicenseRequestedDate":' + '"' + NS_CalCulateValidUpToValidFrom(NSTestAppLicense.NS_LicenseRequestedDate) + '",';
        PayLoad := PayLoad + '"InstallingPersonEmail":' + '"' + Format(NSTestAppLicense.NS_InstallingPersonEmail) + '"}';
        Payload := CopyStr(PayLoad, 1, StrLen(PayLoad));
        Clear(URL);

        URL := 'https://api.businesscentral.dynamics.com/v2.0/netsmartz.com/PPNAV17/api/netsmartz/applicence1/v1.0/companies(9257fcbf-4323-eb11-bb73-000d3a244a02)/eapplicences1';
        // URL := 'http://52.167.173.31:18758/BC18APPSECURITY/api/netsmartz/applicence1/v1.0/companies(74e35bd0-2590-eb11-bb66-000d3abcddd1)/eapplicences1';
        HttpContentVar.WriteFrom(Payload);
        HttpContentVar.GetHeaders(HttpHeaderVar);
        HttpHeaderVar.Clear();
        HttpHeaderVar.Add('Content-Type', 'application/json');
        WebRequest.Content := HttpContentVar;
        WebRequest.SetRequestUri(URL);
        WebRequest.Method('Post');
        ClearLastError;
        //PRJ-1686.GK.1.0 26Oct2022 start
        //NS_AddHttpBasicAuthHeader(UserName, Password, HttpClientVar);
        NS_AddHttpOAuthHeader(HttpClientVar);
        //PRJ-1686.GK.1.0 26Oct2022 end
        HttpClientVar.Send(WebRequest, WebReseponse);
        if not WebReseponse.IsSuccessStatusCode then
            exit(false)
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end
    end;

    [NonDebuggable]
    procedure NS_CalCulateValidUpToValidFrom(DateToBeConvert: date): text[20]
    var
        Day, month, year : integer;
        AddZero: Boolean;
        DateVar: text[20];
    begin
        day := DATE2DMY(DateToBeConvert, 1);
        month := DATE2DMY(DateToBeConvert, 2);
        year := DATE2DMY(DateToBeConvert, 3);

        IF (month < 10) AND (day < 10) then
            DateVar := StrSubstNo(FORMAT(year) + '-' + '0' + FORMAT(month) + '-' + '0' + FORMAT(day))
        else
            IF month < 10 then
                DateVar := StrSubstNo(FORMAT(year) + '-' + '0' + FORMAT(month) + '-' + FORMAT(day))
            else
                if day < 10 then
                    DateVar := StrSubstNo(FORMAT(year) + '-' + FORMAT(month) + '-' + '0' + FORMAT(day))
                else
                    DateVar := StrSubstNo(FORMAT(year) + '-' + FORMAT(month) + '-' + FORMAT(day));
        Exit(DateVar);
    end;


    [NonDebuggable]
    procedure NS_UpdateClientDetailsOnServer(): Boolean
    var
        TestAppLicence: Record "NS_PPClientLicenseInformation";
        URL, ResponseText, LicenceId, CompanyName1 : Text;
        Active, Trial, Expired : boolean;
        InstallingContactEmail: text[100];
        InstallingPerson: code[50];
        ValiFrom, ValidUpto : date;
        WebRequest: HttpRequestMessage;
        HttpHeaderVar: HttpHeaders;
        HttpClientVar: HttpClient;
        WebReseponse: HttpResponseMessage;
        Odatacontext: JsonObject;
        i: Integer;
        TypeHelper: Codeunit "Type Helper";
        LicenceKeyValue: Text[250];
        NapApp: Record "NAV App Setting";
        HttpContentVar: HttpContent;
        TenantId: guid;
        JsonTokenVar, JToken : JsonToken;
        JsonArrayVar: JsonArray;
        NSTestAppLicense: Record "NS_PPClientLicenseInformation";
        Etag: text[250];
        PayLoad: text[1024];
        IsTrialVar: text[5];
        ActiveVar: text[5];
        AppRequested: text[5];
        LicenseReqVar: text[5];
        ExpiredVar: text[5];
        LicenseID: Label '{"licenceid":';
        SortedEtag: text[250];
    begin
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start
        NS_GetClientLicenseDetail(Etag, True);
        SortedEtag := DELCHR(Etag, '=', '\');
        Clear(URL);
        IF NSTestAppLicense.FindFirst() then;
        IF NSTestAppLicense.NS_AppRequested then
            AppRequested := 'true'
        else
            AppRequested := 'false';
        IF NSTestAppLicense.NS_IsTrial then
            IsTrialVar := 'true'
        else
            IsTrialVar := 'false';
        IF NSTestAppLicense.NS_ISActive then
            ActiveVar := 'true'
        else
            ActiveVar := 'false';

        if NSTestAppLicense.NS_LicenseRequested then
            LicenseReqVar := 'true'
        else
            LicenseReqVar := 'false';

        IF NSTestAppLicense.NS_IsExpired then
            ExpiredVar := 'true'
        else
            ExpiredVar := 'false';

        PayLoad := LicenseID + '"' + COPYSTR(NSTestAppLicense."NS_Licence Id", 2, 36) + '",';
        PayLoad := PayLoad + '"active":' + '"' + ActiveVar + '",';
        PayLoad := PayLoad + '"expired":' + '"' + ExpiredVar + '",';
        PayLoad := PayLoad + '"tenantid":' + '"' + Format(NSTestAppLicense."NS_Tenant ID") + '",';
        PayLoad := PayLoad + '"IsTrial":' + '"' + IsTrialVar + '",';
        PayLoad := PayLoad + '"companynamenew":' + '"' + Format(NSTestAppLicense.NS_CompanyName) + '",';
        PayLoad := PayLoad + '"InstallingPerson":' + '"' + Format(NSTestAppLicense.NS_InstallingPerson) + '",';
        PayLoad := PayLoad + '"LicenseRequested":' + '"' + Format(LicenseReqVar) + '",';
        PayLoad := PayLoad + '"ContactNo":' + '"' + Format(NSTestAppLicense.NS_ContactNo) + '",';
        PayLoad := PayLoad + '"AppRequested":' + '"' + AppRequested + '",';
        PayLoad := PayLoad + '"InstallingPersonEmail":' + '"' + Format(NSTestAppLicense.NS_InstallingPersonEmail) + '"}';
        Payload := CopyStr(PayLoad, 1, StrLen(PayLoad));


        URL := StrSubstNo('https://api.businesscentral.dynamics.com/v2.0/netsmartz.com/PPNAV17/api/netsmartz/applicence1/v1.0/companies(9257fcbf-4323-eb11-bb73-000d3a244a02)/eapplicences1(%1)', COPYSTR(NSTestAppLicense."NS_Licence Id", 2, 36));
        // URL := StrSubstNo('http://52.167.173.31:18758/BC18APPSECURITY/api/netsmartz/applicence1/v1.0/companies(74e35bd0-2590-eb11-bb66-000d3abcddd1)/eapplicences1(%1)', COPYSTR(NSTestAppLicense."NS_Licence Id", 2, 36));
        HttpContentVar.WriteFrom(Payload);
        HttpContentVar.GetHeaders(HttpHeaderVar);
        HttpHeaderVar.Clear();
        HttpHeaderVar.Add('Content-Type', 'application/json');
        WebRequest.Content := HttpContentVar;
        WebRequest.SetRequestUri(URL);
        WebRequest.Method('Patch');
        ClearLastError;
        //PRJ-1686.GK.1.0 26Oct2022 start
        //NS_AddHttpBasicAuthHeader(UserName, Password, HttpClientVar);
        NS_AddHttpOAuthHeader(HttpClientVar);
        //PRJ-1686.GK.1.0 26Oct2022 end
        HttpClientVar.DefaultRequestHeaders.Add('If-Match', SortedEtag);
        HttpClientVar.Send(WebRequest, WebReseponse);
        if not WebReseponse.IsSuccessStatusCode then
            exit(false)
        else
            exit(true);
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end
    end;

    [EventSubscriber(ObjectType::Page, Page::NS_PPClientLicenseInformation, 'OnAfterLicenseActivationRequested', '', false, false)]
    local procedure NS_UpdateClientOnServer()
    Var
        TenantLice: codeunit "Tenant License State";
    begin
        IF Not NS_UpdateClientDetailsOnServer() then
            error('');
    end;

    [EventSubscriber(ObjectType::Page, Page::NS_PPClientLicenseInformation, 'OnAfterAppRequested', '', false, false)]
    local procedure NS_UpdateClientOnApprequest()
    begin
        IF Not NS_UpdateClientDetailsOnServer() then
            error('');
    end;

    [NonDebuggable]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::NS_PPAppSecInstall, 'OnAfterFreshInstall', '', false, false)]
    local procedure NS_CreateTrialInstanceForNewCustomer()
    begin
        NS_SetClientLicenseDetail;
    end;

    [NonDebuggable]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::NS_PPAppSecInstall, 'OnAfterCheckExistingCustomerStatus', '', false, false)]
    local procedure NS_CheckStatusOfExistingCustomer(TenantID: Code[20]; var IsExist: Boolean)
    var
        Etag: text[250];
    begin

        CheckClientExistence(TenantID, IsExist);
        IF IsExist then
            NS_GetClientLicenseDetail(Etag, false);

    end;

    // [NonDebuggable]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Conf./Personalization Mgt.", 'OnRoleCenterOpen', '', true, true)]
    local procedure NS_CheckSubscriptionStatus_OnOpenRoleCenter()
    var
        GLSetup: Record "General Ledger Setup";
        Etag: text[250];
        NSPPSetStatusNotification: Codeunit NS_PPSetStatusNotification;
    begin
        NS_CheckLicenseExpire();
        NS_GetClientLicenseDetail(Etag, false);
        OnCheckClientSubscription();

    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckClientSubscription()
    begin
    end;

    procedure NS_ActivateLicense(TrialNotification: Notification)
    var
        NS_PPClientLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        Page.RunModal(Page::NS_PPClientLicenseInformation);
    end;

    [NonDebuggable]
    procedure NS_CheckLicenseExpire()
    var
        NSTestLicense: Record "NS_PPClientLicenseInformation";
    begin
        IF NSTestLicense.FindFirst() then
            IF not NSTestLicense.NS_ServerUpdateWithExpiry then
                IF NSTestLicense."NS_Valid Upto" = Today then begin
                    NSTestLicense.NS_IsExpired := true;
                    NSTestLicense.NS_IsActive := false;
                    NSTestLicense.NS_ServerUpdateWithExpiry := true;
                    NSTestLicense.Modify();
                    IF Not NS_UpdateClientDetailsOnServer() then
                        error('');
                end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NS_Event Subscr. Codeunit 12", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSEventSubscrCodeunit12()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NS_Event Subscr. Codeunit 90", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSEventSubscrCodeunit90()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NS_Job Jnl.-Post Line", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSJobJnlPostLine()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NS_Progress BillingMakeSaleDoc", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSProgressBillingMakeSalesDoc()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"NS_Progress BillingNewDocument", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSProgressBillingNewDocument()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Page, Page::"NS_Subcontract PO", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSSubcontractPO()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Table, Database::"NS_Job Forecast", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSJobForecast()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Table, Database::"NS_Job Material Planning", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSJobMaterialPlanning()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Table, Database::"NS_Job Quote Header", 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSJobQuoteHeader()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    [EventSubscriber(ObjectType::Table, Database::NS_Subcontract, 'OnCheckPPLicenseExpire', '', false, false)]
    local procedure NSSubcontract()
    var
        NSPPLicenseInformation: Record NS_PPClientLicenseInformation;
    begin
        If NSPPLicenseInformation.FindFirst() then
            IF NSPPLicenseInformation.NS_IsExpired then
                IsError();
    end;

    procedure IsError()
    begin
        Error('Your ProjectPro License has been expired, please renew your PP license to continue with ProjectPro Services');
    end;



    procedure CheckClientExistence(TenantID: code[20]; Var IsExist: Boolean)
    var
        URL, ResponseText : Text;
        WebRequest: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpClientVar: HttpClient;
        WebReseponse: HttpResponseMessage;
        HttpContentVar: HttpContent;
        PayLoad: text[1024];
        NSTestAppLicense: Record "NS_PPClientLicenseInformation";
        HttpHeaderVar: HttpHeaders;
        Odatacontext: JsonObject;
        OdataToken: JsonToken;
    begin
        //PRJ-1686.GK.1.0 26Oct2022 start
        //PRJ-1641.JS.1.0 23SEP2022 - Start

        URL := 'https://api.businesscentral.dynamics.com/v2.0/netsmartz.com/PPNAV17/ODataV4/LicenseStatus_TenantActiveLicenseExist?company=9257fcbf-4323-eb11-bb73-000d3a244a02';
        PayLoad := StrSubstNo('{"tenantID" : "%1"}', LowerCase(TenantID));

        HttpContentVar.WriteFrom(Payload);
        HttpContentVar.GetHeaders(HttpHeaderVar);
        HttpHeaderVar.Clear();
        HttpHeaderVar.Add('Content-Type', 'application/json');
        WebRequest.Content := HttpContentVar;
        WebRequest.SetRequestUri(URL);

        WebRequest.Method('Post');
        ClearLastError;
        //PRJ-1686.GK.1.0 26Oct2022 start
        //NS_AddHttpBasicAuthHeader(UserName, Password, HttpClientVar);
        NS_AddHttpOAuthHeader(HttpClientVar);
        //PRJ-1686.GK.1.0 26Oct2022 end
        HttpClientVar.Send(WebRequest, WebReseponse);
        if WebReseponse.IsSuccessStatusCode then begin
            WebReseponse.Content.ReadAs(ResponseText);
            OdataToken.ReadFrom(ResponseText);
            Odatacontext := OdataToken.AsObject();
            Odatacontext.SelectToken('value', OdataToken);
            IsExist := OdataToken.AsValue().AsBoolean();
        end;
        //PRJ-1641.JS.1.0 23SEP2022 - end
        //PRJ-1686.GK.1.0 26Oct2022 end
    end;

}