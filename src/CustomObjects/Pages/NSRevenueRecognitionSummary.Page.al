page 14021304 NS_RevenueRecognitionSummary
{
    //CTSI-274.AM.1.0 Added New page 
    //PRJ-830.AS.1.0 06AUG2021 Removed NS Captions from fields
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = NS_RevenueRecSummaryTab;
    Caption = 'Revenue Recognition Summary Details';
    // Editable = Editbool;
    //PRJ-588.AS.1.0 04MAY2021 Arranged field columns
    //PRJ-983.GK.1.0 14Oct2021 | Added new caption.

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."NS_Entry No.")
                {
                    Caption = 'Entry No.';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Posting Date"; REC."NS_Posting Date")
                {
                    Caption = 'Posting Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Entry Type"; REC."NS_Entry Type")
                {
                    Caption = 'Entry Type';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Job No."; REC."NS_Job No.")
                {
                    Caption = 'Job No.';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Job Description"; REC."NS_Job Description")
                {
                    Caption = 'Job Description';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field("Current Contract"; REC."NS_Current Contract")
                {
                    Caption = 'Current Contract';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Billings to Date"; "NS_Billings to Date")
                {
                    Caption = 'Billings to Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }

                field("Actual Costs To Date"; REC."NS_Actual Costs To Date")
                {
                    Caption = 'Actual Costs To Date';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Period Costs"; REC."NS_Period Costs")
                {
                    Caption = 'Period Costs';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Current(TCE) Est. Cost at Completion"; REC."NS_Current(TCE) Est. Cost at Completion")
                {
                    ApplicationArea = All;
                    Caption = 'Current (TCE) Est. Cost at Completion';
                }
                field("POC %"; REC."NS_POC %")
                {
                    Caption = 'POC %';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Gross Revenue"; REC."NS_Gross Revenue")//PRJ-588.AS.1.0 04MAY2021
                {
                    Caption = 'Gross Revenue';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Gross Profit"; REC."NS_Gross Profit")//PRJ-588.AS.1.0 04MAY2021
                {
                    Caption = 'Gross Profit';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Current GM %"; REC."NS_Current GM %")
                {
                    Caption = 'Current GM %';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field("Over Billings"; "NS_Over Billings")
                {
                    Caption = 'Over Billings';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }
                field("Under Billings"; "NS_Under Billings")
                {
                    Caption = 'Under Billings';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                }
                field("Net Revenue"; REC."NS_Net Revenue")
                {
                    Caption = 'Net Revenue';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = All;
                }
                field("Net Profit"; REC."NS_Net Profit")
                {
                    Caption = 'Net Profit';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                }
                field(Voided; REC.NS_Voided)
                {
                    Caption = 'Voided';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Posted; REC.NS_Posted)
                {
                    Caption = 'Posted';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Editable = false;
                }
                // field("True-Up Posted"; "True-Up Posted")
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // } //CTSI-286 rollback
                field("Over/Under Billings Posted"; "NS_Over/Under Billings Posted")
                {
                    Caption = 'Over/Under Billings Posted';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                    Editable = false;
                }
                field("True-Up Value"; REC."NS_True-Up Value")
                {
                    //Caption = 'True-Up Value';//PRJ-830.AS.1.0 06AUG2021 //PRJ-983.GK.1.0 14Oct2021 | Comment Code
                    Caption = 'G/L Amt. Posted'; //PRJ-983.GK.1.0 14Oct2021| Add Code
                    ApplicationArea = all;
                    Editable = false;
                    Description = 'CTSI-286.MS.1.0';
                }
                field("Billing Amt. Posted"; "NS_Billing Amt. Posted")
                {
                    Caption = 'Billing Amt. Posted';//PRJ-830.AS.1.0 06AUG2021
                    ApplicationArea = all;
                    Description = 'PRJ-830.MS.1.0';
                    Editable = false;
                }
                field("NS_Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")//PRJ-950.AS.1.0
                {
                    CaptionClass = '1,1,1';
                    Caption = 'Global Dimension 1 Code';
                    ApplicationArea = all;
                    Description = '//PRJ-950.AS.1.0';
                    Editable = false;
                }
                field("NS_Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")//PRJ-950.AS.1.0
                {
                    CaptionClass = '1,1,2';
                    Caption = 'Global Dimension 2 Code';
                    ApplicationArea = all;
                    Description = '//PRJ-950.AS.1.0';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerategenJournal)
            {
                ApplicationArea = All;
                Caption = 'Generate General Journal';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = report GenerateGeneralJournal;
                trigger OnAction()
                begin
                    if UserSetup.get(UserId) then
                        if UserSetup."NS_AccessTo Rev.RecognitionReport" then begin
                            GeneraleGenJournalRep.RunModal();
                            Clear(GeneraleGenJournalRep);
                        end else
                            Error('You are not authorized to Generate General Journal.');
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        if UserSetup.get(UserId) then
            if UserSetup."NS_AccessTo Rev.RecognitionReport" then
                CurrPage.Editable := true
            else
                CurrPage.Editable := false;
    end;


    var
        myInt: Integer;
        UserSetup: Record "User Setup";
        EditBool: Boolean;
        GeneraleGenJournalRep: Report NS_GenerateGeneralJournal;
}