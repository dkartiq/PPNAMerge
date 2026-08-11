page 14021436 "NS_Job Quote CreateInteraction"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Create Interaction';
    DataCaptionExpression = NS_Caption();
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Segment Line";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Wizard Contact Name"; Rec."Wizard Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contact';
                    Editable = IsContactEditable;
                    Lookup = false;
                    ToolTip = 'Specifies the contact that you are interacting with.';

                    trigger OnAssistEdit();
                    var
                        Contact: Record Contact;
                    begin
                        if IsContactEditable then begin
                            if Contact.GET("Contact No.") then;
                            if PAGE.RUNMODAL(0, Contact) = ACTION::LookupOK then
                                NS_SetContactNo(Contact);
                        end;
                    end;

                    trigger OnValidate();
                    var
                        Contact: Record Contact;
                        FilterWithoutQuotes: Text;
                    begin
                        "Wizard Contact Name" := DELCHR("Wizard Contact Name", '<>');
                        if "Wizard Contact Name" = "Contact Name" then
                            exit;
                        if "Wizard Contact Name" = '' then
                            CLEAR(Contact)
                        else begin
                            FilterWithoutQuotes := CONVERTSTR("Wizard Contact Name", '''', '?');
                            Contact.SETFILTER(Name, '''@*' + FilterWithoutQuotes + '*''');
                            if not Contact.FINDFIRST then
                                CLEAR(Contact);
                        end;
                        NS_SetContactNo(Contact)
                    end;
                }
                field("Interaction Template Code"; Rec."Interaction Template Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Promoted;
                    NotBlank = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the type of the interaction.';

                    trigger OnValidate();
                    begin
                        NS_UpdateUIFlags;

                        if Campaign.GET("Campaign No.") then
                            "Campaign Description" := Campaign.Description;

                        if "Attachment No." <> xRec."Attachment No." then
                            NS_AttachmentReload;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Description';
                    Importance = Promoted;
                    NotBlank = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies what the interaction is about.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite, RelationshipMgmt;
                    Caption = 'Salesperson';
                    Editable = SalespersonCodeEditable;
                    ShowMandatory = true;
                    ToolTip = 'Salesperson';
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    ToolTip = 'Specifies the language that you will use in this interaction.';

                    trigger OnLookup(VAR Text: Text): Boolean;
                    begin
                        LanguageCodeOnLookup;
                        if "Attachment No." <> xRec."Attachment No." then
                            NS_AttachmentReload;
                    end;

                    trigger OnValidate();
                    begin
                        if "Attachment No." <> xRec."Attachment No." then
                            NS_AttachmentReload;
                    end;
                }
            }
            group(Content1)
            {
                Caption = 'Content';
                Visible = HTMLAttachment;
                field(HTMLContentBodyText; HTMLContentBodyText)
                {
                    ApplicationArea = RelationshipMgmt;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'HTML';

                    Caption = 'HTML';

                    trigger OnValidate();
                    begin
                        UpdateContentBodyTextInCustomLayoutAttachment(HTMLContentBodyText);
                    end;
                }
            }
            group(InteractionDetails)
            {
                Caption = 'Interaction Details';
                Enabled = IsMainInfoSet;
                field("Correspondence Type"; "Correspondence Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the type of correspondence that you use for this interaction: email, fax, or a printed letter.';

                    trigger OnValidate();
                    begin
                        ValidateCorrespondenceType;
                    end;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Date of Interaction';
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the interaction took place.';
                }
                field("Time of Interaction"; Rec."Time of Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the time when the interaction took place';
                }
                field("Information Flow"; Rec."Information Flow")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the direction of the interaction, inbound or outbound.';
                }
                field("Initiated By"; Rec."Initiated By")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies if the interaction was initiated by your company or by one of your contacts. The Us option indicates that your company was the initiator; the Them option indicates that a contact was the initiator.';
                }
                field(Evaluation; Rec.Evaluation)
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the evaluation of the interaction involving the contact in the segment.';
                }
                field("Interaction Successful"; Rec."Interaction Successful")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Was Successful';
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies if the interaction was successful. Clear this check box to indicate that the interaction was not a success.';
                }
                field("Cost (LCY)"; Rec."Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the cost of the interaction with the contact that this segment line applies to.';
                }
                field("Duration (Min.)"; Rec."Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies the duration of the interaction with the contact.';
                }
                field("Campaign Description"; Rec."Campaign Description")
                {
                    ApplicationArea = All;
                    Caption = 'Campaign';
                    Editable = CampaignDescriptionEditable;
                    Enabled = IsMainInfoSet;
                    Importance = Promoted;
                    Lookup = false;
                    TableRelation = Campaign;
                    ToolTip = 'Specifies the campaign that is related to the segment. The description is copied from the campaign card.';

                    trigger OnAssistEdit();
                    var
                        Campaign: Record Campaign;
                    begin
                        if GETFILTER("Campaign No.") = '' then begin
                            if Campaign.GET("Campaign No.") then;
                            if PAGE.RUNMODAL(0, Campaign) = ACTION::LookupOK then begin
                                VALIDATE("Campaign No.", Campaign."No.");
                                "Campaign Description" := Campaign.Description;
                            end;
                        end;
                    end;
                }
                field("Campaign Target"; Rec."Campaign Target")
                {
                    ApplicationArea = All;
                    Caption = 'Contact is Targeted';
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies that the segment involved in this interaction is the target of a campaign. This is used to measure the response rate of a campaign.';
                }
                field("Campaign Response"; Rec."Campaign Response")
                {
                    ApplicationArea = All;
                    Caption = 'Campaign Response';
                    Enabled = IsMainInfoSet;
                    Importance = Additional;
                    ToolTip = 'Specifies that the interaction created for the segment is the response to a campaign. For example, coupons that are sent as a response to a campaign.';
                }
                field("Opportunity Description"; Rec."Opportunity Description")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Opportunity';
                    Editable = OpportunityDescriptionEditable;
                    Enabled = IsMainInfoSet;
                    Importance = Promoted;
                    Lookup = false;
                    TableRelation = Opportunity;
                    ToolTip = 'Specifies a description of the opportunity that is related to the segment. The description is copied from the opportunity card.';

                    trigger OnAssistEdit();
                    var
                        Opportunity: Record Opportunity;
                    begin
                        FilterContactCompanyOpportunities(Opportunity);
                        if PAGE.RUNMODAL(0, Opportunity) = ACTION::LookupOK then begin
                            VALIDATE("Opportunity No.", Opportunity."No.");
                            "Opportunity Description" := Opportunity.Description;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Preview';
                Enabled = HTMLAttachment;
                Image = PreviewChecks;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Test the setup of the interaction.';
                Visible = HTMLAttachment;

                trigger OnAction();
                begin
                    //PreviewHTMLContent; //PPNA16.0 Blocked
                end;
            }
            action(Finish)
            {
                ApplicationArea = RelationshipMgmt;
                Enabled = IsMainInfoSet;
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Finish the interaction setup.';
                Visible = IsOnMobile;

                trigger OnAction();
                begin
                    //FinishWizard(true); //PPNA16.0 Blocked
                    IsFinished := true;
                    CurrPage.CLOSE;
                end;
            }
        }
        area(navigation)
        {
            action("Co&mments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = ViewComments;
                ToolTip = 'View or add comments.';

                trigger OnAction();
                begin
                    ShowComment;
                end;
            }
        }
    }

    trigger OnInit();
    begin
        SalespersonCodeEditable := true;
        OpportunityDescriptionEditable := true;
        CampaignDescriptionEditable := true;
        IsOnMobile := CURRENTCLIENTTYPE = CLIENTTYPE::Phone;
    end;

    trigger OnOpenPage();
    begin
        CampaignDescriptionEditable := false;
        OpportunityDescriptionEditable := false;
        IsContactEditable := (GETFILTER("Contact No.") = '') and (GETFILTER("Contact Company No.") = '');
        NS_UpdateUIFlags;

        if SalesPurchPerson.GET(GETFILTER("Salesperson Code")) then
            SalespersonCodeEditable := false;

        NS_AttachmentReload;

        IsFinished := false;
        CurrPage.UPDATE(false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if IsFinished then
            exit;

        // FinishWizard(CloseAction in [ACTION::OK, ACTION::LookupOK]);//PPNA16.0 Blocked
    end;

    var
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        Todo: Record "To-do";
        HTMLContentBodyText: Text;
        [InDataSet]
        CampaignDescriptionEditable: Boolean;
        [InDataSet]
        OpportunityDescriptionEditable: Boolean;
        [InDataSet]
        SalespersonCodeEditable: Boolean;
        IsMainInfoSet: Boolean;
        HTMLAttachment: Boolean;
        UntitledTxt: Label 'untitled';
        IsOnMobile: Boolean;
        IsFinished: Boolean;
        IsContactEditable: Boolean;

    local procedure NS_Caption(): Text[260];
    var
        Contact: Record Contact;
        CaptionStr: Text[260];
    begin
        if Contact.GET(GETFILTER("Contact Company No.")) then
            CaptionStr := COPYSTR(Contact."No." + ' ' + Contact.Name, 1, MAXSTRLEN(CaptionStr));
        if Contact.GET(GETFILTER("Contact No.")) then
            CaptionStr := COPYSTR(CaptionStr + ' ' + Contact."No." + ' ' + Contact.Name, 1, MAXSTRLEN(CaptionStr));
        if SalesPurchPerson.GET(GETFILTER("Salesperson Code")) then
            CaptionStr := COPYSTR(CaptionStr + ' ' + SalesPurchPerson.Code + ' ' + SalesPurchPerson.Name, 1, MAXSTRLEN(CaptionStr));
        if Campaign.GET(GETFILTER("Campaign No.")) then
            CaptionStr := COPYSTR(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description, 1, MAXSTRLEN(CaptionStr));
        if Todo.GET(GETFILTER("To-do No.")) then
            CaptionStr := COPYSTR(CaptionStr + ' ' + Todo."No." + ' ' + Todo.Description, 1, MAXSTRLEN(CaptionStr));

        if CaptionStr = '' then
            CaptionStr := UntitledTxt;

        exit(CaptionStr);
    end;

    local procedure NS_UpdateUIFlags();
    begin
        IsMainInfoSet := "Interaction Template Code" <> '';
    end;

    local procedure NS_AttachmentReload();
    begin
        //LoadAttachment(true);//PPNA16.0 Blocked
        HTMLAttachment := IsHTMLAttachment;
        if HTMLAttachment then
            HTMLContentBodyText := LoadContentBodyTextFromCustomLayoutAttachment;
    end;

    local procedure NS_SetContactNo(Contact: Record Contact);
    begin
        VALIDATE("Contact No.", Contact."No.");
        "Wizard Contact Name" := Contact.Name;
    end;
}

