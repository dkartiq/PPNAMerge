page 14021230 "NS_PPClientLicenseInformation"
{
    Caption = 'ProjectPro License Detail';
    PageType = List;
    SourceTable = "NS_PPClientLicenseInformation";
    UsageCategory = Administration;
    ApplicationArea = all;
    InsertAllowed = false;
    DeleteAllowed = false;




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
                begin
                    IF not rec.NS_LicenseRequested then
                        IF Rec.NS_IsTrial or Rec.NS_IsExpired or Rec.NS_Renew then
                            IF (Rec.NS_InstallingPerson = '') OR (Rec.NS_InstallingPersonEmail = '') or (Rec.NS_ContactNo = '') then
                                Error('Please provides details in Extension Manager, Contact Email and (Contact No.) fields, so our sales team can connect to you')
                            else begin
                                Rec.NS_LicenseRequested := true;
                                rec.NS_LicenseRequestedDate := today;
                                rec.NS_Renew := false;
                                Rec.Modify();
                                OnAfterLicenseActivationRequested();
                                Message('Your request has been submitted successfully, our sales team will contact you on the email provided');
                            end else
                            Message('License is already activated')
                    else
                        Message('License has been already requested');
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
                            OnAfterAppRequested();
                            Message('Your request has been submitted successfully, you will get a OneDrive link including the App File shortly');
                        end else
                        Message('App File already requested');
                end;
            }
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
}