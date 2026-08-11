page 14021407 "NS_Job Quote List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-322.MS.1.0 swap the order of quote no. and template for open card on web client
    // +------------------------------------------------------------
    //PRJ-1085.RM.1.0 16Dec2021 | Added Page url
    //PRJ-1579.RM.1.0 18Aug2022 | Added tooltip
     //PRJCTPR-130.RM.1.0 18July2023 | Added an action button
    ContextSensitiveHelpPage = 'user-guide/job-quotes/defining-a-job-quote/'; //PRJ-1085.RM.1.0 16Dec2021

    Caption = 'Quote List';
    CardPageID = "NS_Job Quote";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    PromotedActionCategories = 'New,Process,Reports,Supplemental,Tasks,Team,Workflow,Filters';
    SourceTable = "NS_Job Quote Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Quote No."; Rec."NS_Quote No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quote No.';
                }
                field(Template; Rec.NS_Template)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Template';
                }

                field("Description/Nickname"; Rec."NS_Description/Nickname")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description/Nickname';
                }
                field("Quote Type Code"; Rec."NS_Quote Type Code")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Quote Type Code';
                    Visible = false;
                }
                field("Proposal Date"; Rec."NS_Proposal Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Proposal Date';
                }
                field("Accepted at Date"; Rec."NS_Accepted at Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Accepted at Date';
                }
                //PE-300.Dk.1.0  29May2024 Start
                field(Status; Rec."NS_Quote Status")  //PE-300.JS.1.0 21JUN2024
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Status';
                }
                //PE-300.Dk.1.0  29May2024 End
                //PRJ-1155.AS.1.0 21JAN2022 START
                field("NS_Total Contract Price"; Rec."NS_Total Contract Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Contract Price';
                    Editable = false;
                }
                //PRJ-1155.AS.1.0 21JAN2022 END
                field("Link-to Quote No."; Rec."NS_Link-to Quote No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Link-to Quote No.';
                    Visible = false;
                }
                field(Revision; Rec.NS_Revision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies theRevision';
                }
                field("Sell-to Customer No."; Rec."NS_Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the Sell-to Customer No.'; //PRJ-1579.RM.1.0 
                    ToolTip = 'Select the Customer No.'; //PRJ-1579.RM.1.0 
                }
                field("Sell-to Customer Name"; Rec."NS_Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the Sell-to Customer Name'; //PRJ-1579.RM.1.0 
                    ToolTip = 'Sepcifies the name of the Customer'; //PRJ-1579.RM.1.0 
                }
                field("Salesperson Code"; Rec."NS_Salesperson Code New")//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Code';
                }
                field("Salesperson Name"; Rec."NS_Salesperson Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Salesperson Name';
                }
                field("Contact No."; Rec."NS_Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contact No.';
                }
                field("Contact Name"; Rec."NS_Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Contact Name';
                }
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Job Description"; Rec."NS_Job Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Description';
                }
                field("Job Type"; Rec."NS_Job Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Type';
                }
                field("Sales Quote No."; Rec."NS_Sales Quote No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the Sales Quote No.';
                    Visible = false;
                }
                //PE-300-DK.1.0 29May2024 Start
                field("Probability to Close"; Rec."NS_QuotePro to Close")  //PE-300.JS.1.0 21JUN2024
                {
                    Caption = 'Probability to Close';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Probability to Close';
                    Visible = false;
                }
                //PE-300-DK.1.0 29May2024 End
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(NS_CopyDocument)
            {
                ApplicationArea = All;
                ToolTip = 'Copy Document';
                Caption = '&Copy Document';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_CopyDocumentJQ(Rec, "NS_Sell-to Customer No.");
                end;
            }
            action(NS_PrintDocument)
            {
                ApplicationArea = All;
                Caption = '&Print Document';
                Image = PrintDocument;
                ToolTip = 'Print Document';
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    QuoteMgt.NS_PrintQuote(Rec, false);
                end;
            }
            action(NS_ShareQuote)
            {
                ApplicationArea = All;
                Caption = 'S&hare Quote';
                Enabled = false;
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Share Quote';

                trigger OnAction();
                begin
                    QuoteMgt.NS_ShareQuote(Rec);
                end;
            }
            action(NS_AssignQuote)
            {
                ApplicationArea = All;
                ToolTip = 'Assign Quote';
                Caption = 'Assign Quote';
                Enabled = false;
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_Assign(Rec);
                    CurrPage.UPDATE(false);
                end;
            }
            action(NS_CopyToLibrary)
            {
                ApplicationArea = All;
                ToolTip = 'Copy To Library';
                Caption = 'Copy to &Library';
                Enabled = false;
                Image = SaveasStandardJournal;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_CopyQuoteToLibrary(Rec);
                end;
            }
            action(NS_MakeOrder)
            {
                ApplicationArea = All;
                ToolTip = 'Make Order';
                Caption = 'Make Order';
                Enabled = false;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_MakeOrder("NS_Quote No.");
                end;
            }
            action(NS_PipelineReport)
            {
                ApplicationArea = All;
                ToolTip = 'Pipeline Report';
                Caption = 'Pipeline Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "NS_Quote Pipeline Report";
            }
             //PRJCTPR-130.RM.1.0 19July2023 start
            action(JobQuoteEstimation)
            {
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Caption = 'Job Quote Estimation Report';
                ToolTip = 'This Report shows the estimate of the Job Quote Cost & Job Quote Price details.';
                trigger OnAction();
                var
                    JobQuoteHdr: Record "NS_Job Quote Header";
                begin
                    Commit();
                    JobQuoteHdr.Reset();
                    JobQuoteHdr.SetRange("NS_Quote No.", Rec."NS_Quote No.");
                    REPORT.RUNMODAL(14021332, true, false, JobQuoteHdr);
                end;
            }
            //PRJCTPR-130.RM.1.0 19July2023 End
            action(NS_PreservePricing)
            {
                ApplicationArea = All;
                ToolTip = 'Preserve Pricing';
                Caption = 'Preserve Pricing';
                Enabled = false;
                Image = SalesPrices;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                Visible = false;

                trigger OnAction();
                begin
                    QuoteMgt.NS_SetPricePreserve(Rec, false);
                end;
            }
            action(PipelineUpdate)
            {
                ApplicationArea = All;
                Caption = 'P&ipeline Update';
                Image = Report2;
                Promoted = true;
                ToolTip = 'Pipeline Update';
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    _QuotePipelineUpdate: Page "NS_Job Quote Pipeline Upd ";
                begin
                    CLEAR(_QuotePipelineUpdate);
                    _QuotePipelineUpdate.NS_SetQuote("NS_Quote No.", false);
                    _QuotePipelineUpdate.RUNMODAL();
                end;
            }
        }
    }

    var
        //UserSetup: Record "User Setup";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
    //QuoteListFiltered: Boolean;
    //ShowLibraryQuotes: Option "User Only","User + Library","Library Only";
}

