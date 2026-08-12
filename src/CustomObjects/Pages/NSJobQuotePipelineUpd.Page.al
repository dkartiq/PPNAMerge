page 14021419 "NS_Job Quote Pipeline Upd "
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Quote Pipeline Update';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group("Pipeline Fields")
            {
                field(PP_QuoteNo; QuoteNo)
                {
                    ApplicationArea = All;
                    Caption = 'Quote No.';
                    ToolTip = 'Quote No.';

                    trigger OnValidate();
                    begin
                        NS_SetQuote(QuoteNo, true);
                    end;
                }
                field(PP_Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description/Nickname';
                    ToolTip = 'Description/Nickname';

                    Editable = false;
                }
                field(PP_SiteCustomerNo; SiteCustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Site Customer No.';

                    ToolTip = 'Site Customer No.';
                    Editable = false;
                }
                field(PP_SiteCustomerName; SiteCustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Site Customer Name';
                    Editable = false;
                }
                field(JQSalesperson; JQSalesperson)
                {
                    ApplicationArea = All;
                    Caption = 'JQ Salesperson/User ID';
                    Editable = false;
                }
                field(EstMoToClose; EstMoToClose)
                {
                    ApplicationArea = All;
                    Caption = 'Est. Month to Close';
                }
                field(EstMoToBill; EstMoToBill)
                {
                    ApplicationArea = All;
                    Caption = 'Est. Month to Bill';
                }
                field(EstPctToBill; EstPctToBill)
                {
                    ApplicationArea = All;
                    Caption = 'Est. % to Bill';
                }
                field(ProbabilityToClose; ProbabilityToClose)
                {
                    ApplicationArea = All;
                    Caption = 'Probability to Close';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Reset)
            {
                ApplicationArea = All;
                Image = SuggestReconciliationLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    if QuoteNo = '' then
                        NS_ClearVars
                    else
                        NS_SetQuote(QuoteNo, true);
                end;
            }
            action(MarkInactiveAction)
            {
                ApplicationArea = All;
                Caption = 'Mark Inactive';
                Image = DeleteQtyToHandle;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction();
                begin
                    NS_MarkInactive;
                end;
            }
            action(Confirm)
            {
                ApplicationArea = All;
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction();
                begin
                    NS_UpdateQuote;
                end;
            }
        }
    }

    var
        QuoteHeader: Record "NS_Job Quote Header";
        JQSalesperson: Code[50];
        QuoteNo: Code[20];
        SiteCustomerNo: Code[20];
        EstPctToBill: Decimal;
        EstMoToBill: Option " ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
        EstMoToClose: Option " ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
        ProbabilityToClose: Option Draft,"Budget Only","25",,,"50",,"75",,"90","100",,,,,,,,,,Lost,,,,,,,,,,Canceled,,,,,,,Opportunity;

        NSProbabilityToClose: Enum "NS_QuotePro to Close";  //PE-300.JS.1.0 02JUN2024
        // >> Upgrade
        // Description: Text[50];
        // SiteCustomerName: Text[50];
        Description: Text[100];
        SiteCustomerName: Text[100];
        // << Upgrade
        Text000: Label 'Quote %1 has been updated.';
        Text001: Label 'Update quote?';
        Text002: Label 'In some cases, marking a quote inactive is not easily reversible.  Continue?';
        Text003: Label 'Done.';

    procedure NS_ClearVars();
    begin
        CLEAR(QuoteHeader);
        CLEAR(SiteCustomerNo);
        CLEAR(EstPctToBill);
        CLEAR(EstMoToBill);
        CLEAR(EstMoToClose);
        CLEAR(ProbabilityToClose);
        CLEAR(Description);
        CLEAR(SiteCustomerName);
        CLEAR(JQSalesperson);
    end;

    procedure NS_MarkInactive();
    begin
        QuoteHeader.GET(QuoteNo);
        //PE-300.Dk.1.0  29May2024 Start
        // if QuoteHeader.NS_Status > QuoteHeader.NS_Status::Released then
        //     QuoteHeader.FIELDERROR(NS_Status);
        // if CONFIRM(Text002, false) then begin
        //     QuoteHeader.NS_Status := QuoteHeader.NS_Status::Inactive;
        if QuoteHeader."NS_Quote Status".AsInteger() > QuoteHeader."NS_Quote Status".AsInteger() then
            QuoteHeader.FIELDERROR("NS_Quote Status");
        if CONFIRM(Text002, false) then begin
            QuoteHeader."NS_Quote Status" := QuoteHeader."NS_Quote Status"::Inactive;
            //PE-300.Dk.1.0  29May2024 End
            QuoteHeader.MODIFY;
            MESSAGE(Text003);
            CurrPage.CLOSE;
        end;
    end;

    procedure NS_SetQuote(_QuoteNo: Code[20]; _Update: Boolean);
    begin
        NS_ClearVars;

        if _Update then
            QuoteHeader.GET(_QuoteNo)
        else
            if not QuoteHeader.GET(_QuoteNo) then
                QuoteHeader.INIT;

        QuoteNo := QuoteHeader."NS_Quote No.";
        SiteCustomerNo := QuoteHeader."NS_Sell-to Customer No.";
        EstPctToBill := QuoteHeader."NS_Estimated % to Bill";
        EstMoToBill := QuoteHeader."NS_Estimated Month to Bill";
        EstMoToClose := QuoteHeader."NS_Estimated Month to Close";
        //PE-300-DK.1.0 29May2024 Start
        //ProbabilityToClose := QuoteHeader."NS_Probability to Close";
        NSProbabilityToClose := QuoteHeader."NS_QuotePro to Close";
        //PE-300-DK.1.0 29May2024 End
        Description := QuoteHeader."NS_Description/Nickname";
        SiteCustomerName := QuoteHeader."NS_Sell-to Customer Name";
        JQSalesperson := QuoteHeader."NS_Salesperson/User ID";

        if _Update then
            CurrPage.UPDATE(false);
    end;

    procedure NS_UpdateQuote();
    begin
        QuoteHeader.TESTFIELD("NS_Quote No.");
        if not CONFIRM(Text001, false) then
            exit;
        //PE-300-DK.1.0 29May2024 Start
        // QuoteHeader."NS_Probability to Close" := ProbabilityToClose;
        QuoteHeader."NS_QuotePro to Close" := NSProbabilityToClose;
        //PE-300-DK.1.0 29May2024 End
        QuoteHeader."NS_Estimated Month to Close" := EstMoToClose;
        QuoteHeader."NS_Estimated Month to Bill" := EstMoToBill;
        QuoteHeader."NS_Estimated % to Bill" := EstPctToBill;
        QuoteHeader.MODIFY;
        MESSAGE(Text000, QuoteHeader."NS_Quote No.");
        CurrPage.CLOSE;
    end;
}

