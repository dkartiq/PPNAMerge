report 14021207 "NS_Update Contact Classifi."
{
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +
    // +
    // +  - Added global variable(s):
    // +     PP_SalesSetup
    // +     PP_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport: Sales & Receivables Setup record, get Purchases & Payables Setup record
    // +     - FindCustomerValues: add filters to Retention Ledger Code if needed
    // +     - FindVendorValues: add filters to Retention Ledger Code if needed
    // +------------------------------------------------------------

    ApplicationArea = RelationshipMgmt;
    Caption = 'Job Update Contact Classification';//PE-141.NK.1.0 03Aug2023 updated name
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Profile Questionnaire Header"; "Profile Questionnaire Header")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code", Description, "Business Relation Code";
            dataitem("Profile Questionnaire Line"; "Profile Questionnaire Line")
            {
                DataItemLink = "Profile Questionnaire Code" = FIELD(Code);
                DataItemTableView = SORTING("Profile Questionnaire Code", "Line No.")
                                    WHERE(Type = CONST(Question),
                                          "Auto Contact Classification" = CONST(true),
                                          "Contact Class. Field" = FILTER(<> Rating));

                trigger OnAfterGetRecord()
                begin
                    Window.UPDATE(3, "Line No.");
                    IF NoOfQuestions = 0 THEN
                        NoOfQuestions := COUNT;
                    QuestionCount := QuestionCount + 1;
                    Window.UPDATE(4, ROUND(10000 * QuestionCount / NoOfQuestions, 1));
                    RecCount := 0;

                    ContactValue.DELETEALL;

                    IF (FORMAT("Starting Date Formula") = '') OR (FORMAT("Ending Date Formula") = '') THEN
                        ERROR(
                          Text005,
                          FIELDCAPTION("Starting Date Formula"),
                          FIELDCAPTION("Ending Date Formula"),
                          "Profile Questionnaire Header".Code,
                          Description);

                    IF "Classification Method" = "Classification Method"::" " THEN
                        ERROR(
                          Text008,
                          FIELDCAPTION("Classification Method"),
                          "Profile Questionnaire Header".Code,
                          Description);

                    AnswersExists("Profile Questionnaire Line", '', TRUE);
                    TotalValue := 0;

                    CASE TRUE OF
                        "Customer Class. Field" <> "Customer Class. Field"::" ":
                            FindCustomerValues("Profile Questionnaire Line");
                        "Vendor Class. Field" <> "Vendor Class. Field"::" ":
                            FindVendorValues("Profile Questionnaire Line");
                        "Contact Class. Field" <> "Contact Class. Field"::" ":
                            FindContactValues("Profile Questionnaire Line");
                    END;

                    MarkContactByMethod("Profile Questionnaire Line", '');
                end;

                trigger OnPreDataItem()
                begin
                    NoOfQuestions := 0;
                    QuestionCount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, Code);
                IF NoOfProfiles = 0 THEN
                    NoOfProfiles := COUNT;
                ProfileCount := ProfileCount + 1;
                Window.UPDATE(2, ROUND(10000 * ProfileCount / NoOfProfiles, 1));
                NoOfQuestions := 0;
            end;
        }
        dataitem("Integer"; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                UpdateRating('');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_Date; Date)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Date';
                        ToolTip = 'Specifies the date on which you update the contact classification.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Date := WORKDATE;
    end;

    trigger OnPreReport()
    begin
        Window.OPEN(
          Text000 +
          Text001 +
          Text002);
        //ProjectPro - start
        NS_SalesSetup.GET;
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;

    var
        Text000: Label 'Profile Questionnaire #1######## @2@@@@@@@@@@@@@\\';
        Text001: Label 'Question Line No.     #3######## @4@@@@@@@@@@@@@\';
        Text002: Label 'Finding Values        #5######## @6@@@@@@@@@@@@@\';
        Text003: Label '%1 results in a date before the result of the %2.';
        ContactValue: Record "Contact Value" temporary;
        Window: Dialog;
        Date: Date;
        NoOfProfiles: Integer;
        ProfileCount: Integer;
        NoOfQuestions: Integer;
        QuestionCount: Integer;
        NoOfRecs: Integer;
        RecCount: Integer;
        TotalValue: Decimal;
        Text004: Label 'Two or more questions are causing the rating calculation to loop.';
        Text005: Label 'You must specify %1 and %2 in Profile Questionnaire %3, question %4. To find additional errors, run the Test report.', Comment = '%1 = Starting Date Formula;%2 = Ending Date Formula;%3 = Profile Questionaire Code;%4 = Question Description';
        Text008: Label 'You must specify %1 in Profile Questionnaire %2, question %3. To find additional errors, run the Test report.', Comment = '%1 = Sorting Method;%2 = Profile Questionaire Code;%3 = Question Description';
        NS_SalesSetup: Record "Sales & Receivables Setup";
        NS_PurchSetup: Record "Purchases & Payables Setup";

    local procedure AnswersExists(var ProfileQuestionnaireLine: Record "Profile Questionnaire Line"; UpdateContNo: Code[20]; Delete: Boolean): Boolean
    var
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
    begin
        ContProfileAnswer.SETCURRENTKEY("Profile Questionnaire Code", "Line No.");
        ContProfileAnswer.SETRANGE("Profile Questionnaire Code", ProfileQuestionnaireLine."Profile Questionnaire Code");

        ProfileQuestnLine2.RESET;
        ProfileQuestnLine2 := ProfileQuestionnaireLine;
        ProfileQuestnLine2.SETRANGE(Type, ProfileQuestnLine2.Type::Question);
        ProfileQuestnLine2.SETRANGE("Profile Questionnaire Code", ProfileQuestionnaireLine."Profile Questionnaire Code");
        IF ProfileQuestnLine2.NEXT <> 0 THEN
            ContProfileAnswer.SETRANGE("Line No.", ProfileQuestionnaireLine."Line No.", ProfileQuestnLine2."Line No.")
        ELSE
            ContProfileAnswer.SETFILTER("Line No.", '%1..', ProfileQuestionnaireLine."Line No.");
        IF UpdateContNo <> '' THEN BEGIN
            ContProfileAnswer.SETRANGE("Contact No.", UpdateContNo);
            ContProfileAnswer.SETCURRENTKEY("Contact No.", "Profile Questionnaire Code", "Line No.");
        END;

        IF Delete THEN
            ContProfileAnswer.DELETEALL
        ELSE
            EXIT(NOT ContProfileAnswer.ISEMPTY);
    end;

    local procedure FindCustomerValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        ValueEntry: Record "Value Entry";
        CustContactNo: Code[20];
        NoOfInvoices: Integer;
        DaysOverdue: Integer;
        NoOfYears: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Cust.COUNT;
        IF Cust.FIND('-') THEN
            REPEAT
                RecCount := RecCount + 1;
                Window.UPDATE(5, Cust."No.");
                Window.UPDATE(6, ROUND(10000 * RecCount / NoOfRecs, 1));
                CustContactNo := ContactNo(ProfileQuestionnaireLine, DATABASE::Customer, Cust."No.");
                IF CustContactNo <> '' THEN BEGIN
                    Cust.RESET;
                    FromDate := CALCDATE(ProfileQuestionnaireLine."Starting Date Formula", Date);
                    ToDate := CALCDATE(ProfileQuestionnaireLine."Ending Date Formula", Date);
                    IF ToDate < FromDate THEN
                        ProfileQuestionnaireLine.FIELDERROR("Ending Date Formula",
                          STRSUBSTNO(Text003,
                            ProfileQuestionnaireLine.FIELDCAPTION("Ending Date Formula"),
                            ProfileQuestionnaireLine.FIELDCAPTION("Starting Date Formula")));
                    Cust.SETRANGE("Date Filter", FromDate, ToDate);
                    CASE ProfileQuestionnaireLine."Customer Class. Field" OF
                        ProfileQuestionnaireLine."Customer Class. Field"::"Sales (LCY)":
                            BEGIN
                                Cust.CALCFIELDS("Sales (LCY)");
                                InsertContactValue(ProfileQuestionnaireLine, CustContactNo, Cust."Sales (LCY)", 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Customer Class. Field"::"Profit (LCY)":
                            BEGIN
                                Cust.CALCFIELDS("Profit (LCY)");
                                InsertContactValue(ProfileQuestionnaireLine, CustContactNo, Cust."Profit (LCY)", 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Customer Class. Field"::"Sales Frequency (Invoices/Year)":
                            BEGIN
                                CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
                                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                                CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
                                CustLedgEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                                    CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := CustLedgEntry.COUNT;
                                NoOfYears := (ToDate - FromDate + 1) / 365;
                                InsertContactValue(ProfileQuestionnaireLine, CustContactNo, NoOfInvoices / NoOfYears, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Customer Class. Field"::"Avg. Invoice Amount (LCY)":
                            BEGIN
                                CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
                                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                                CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
                                CustLedgEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                                    CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := CustLedgEntry.COUNT;
                                IF NoOfInvoices <> 0 THEN BEGIN
                                    CustLedgEntry.CALCSUMS("Sales (LCY)");
                                    InsertContactValue(ProfileQuestionnaireLine, CustContactNo, CustLedgEntry."Sales (LCY)" / NoOfInvoices, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, CustContactNo, 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Customer Class. Field"::"Discount (%)":
                            BEGIN
                                CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
                                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                                CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
                                CustLedgEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                                    CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                                //ProjectPro - end
                                IF CustLedgEntry.FIND('-') THEN BEGIN
                                    CustLedgEntry.CALCSUMS("Sales (LCY)");
                                    ValueEntry.SETCURRENTKEY("Source Type", "Source No.", "Item No.", "Posting Date");
                                    ValueEntry.SETRANGE("Source Type", ValueEntry."Source Type"::Customer);
                                    ValueEntry.SETRANGE("Source No.", Cust."No.");
                                    ValueEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
                                    ValueEntry.CALCSUMS("Discount Amount");
                                    ValueEntry."Discount Amount" := -ValueEntry."Discount Amount";
                                    IF (CustLedgEntry."Sales (LCY)" + ValueEntry."Discount Amount") <> 0 THEN
                                        InsertContactValue(
                                          ProfileQuestionnaireLine, CustContactNo,
                                          100 * ValueEntry."Discount Amount" /
                                          (CustLedgEntry."Sales (LCY)" + ValueEntry."Discount Amount"), 0D, 0)
                                    ELSE
                                        InsertContactValue(ProfileQuestionnaireLine, CustContactNo, 0, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, CustContactNo, 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Customer Class. Field"::"Avg. Overdue (Day)":
                            BEGIN
                                CustLedgEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date");
                                CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
                                CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
                                CustLedgEntry.SETFILTER("Posting Date", Cust.GETFILTER("Date Filter"));
                                CustLedgEntry.SETRANGE(Open, FALSE);
                                //ProjectPro - start
                                IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN
                                    CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_SalesSetup."NS_Normal Customer Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := CustLedgEntry.COUNT;
                                IF NoOfInvoices <> 0 THEN BEGIN
                                    DaysOverdue := 0;
                                    CustLedgEntry.FIND('-');
                                    REPEAT
                                        IF CustLedgEntry."Closed at Date" > CustLedgEntry."Due Date" THEN
                                            DaysOverdue := DaysOverdue + (CustLedgEntry."Closed at Date" - CustLedgEntry."Due Date")
                                        ELSE
                                            IF CustLedgEntry."Closed at Date" = 0D THEN BEGIN
                                                CustLedgEntry2.RESET;
                                                CustLedgEntry2.SETCURRENTKEY("Closed by Entry No.");
                                                CustLedgEntry2.SETRANGE("Document Type", CustLedgEntry2."Document Type"::Payment);
                                                CustLedgEntry2.SETRANGE("Closed by Entry No.", CustLedgEntry."Entry No.");
                                                IF CustLedgEntry2.FINDFIRST AND
                                                   (CustLedgEntry2."Closed at Date" > CustLedgEntry."Due Date")
                                                THEN
                                                    DaysOverdue := DaysOverdue + (CustLedgEntry2."Closed at Date" - CustLedgEntry."Due Date");
                                            END;
                                    UNTIL CustLedgEntry.NEXT = 0;
                                    InsertContactValue(ProfileQuestionnaireLine, CustContactNo, DaysOverdue / NoOfInvoices, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, CustContactNo, 0, 0D, 0);
                            END;
                    END;
                END;
            UNTIL Cust.NEXT = 0
    end;

    local procedure FindVendorValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        ValueEntry: Record "Value Entry";
        VendContactNo: Code[20];
        NoOfInvoices: Integer;
        DaysOverdue: Integer;
        NoOfYears: Decimal;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Vend.COUNT;
        IF Vend.FIND('-') THEN
            REPEAT
                RecCount := RecCount + 1;
                Window.UPDATE(5, Vend."No.");
                Window.UPDATE(6, ROUND(10000 * RecCount / NoOfRecs, 1));
                VendContactNo := ContactNo(ProfileQuestionnaireLine, DATABASE::Vendor, Vend."No.");
                IF VendContactNo <> '' THEN BEGIN
                    Vend.RESET;
                    FromDate := CALCDATE(ProfileQuestionnaireLine."Starting Date Formula", Date);
                    ToDate := CALCDATE(ProfileQuestionnaireLine."Ending Date Formula", Date);
                    IF ToDate < FromDate THEN
                        ProfileQuestionnaireLine.FIELDERROR("Ending Date Formula",
                          STRSUBSTNO(Text003,
                            ProfileQuestionnaireLine.FIELDCAPTION("Ending Date Formula"),
                            ProfileQuestionnaireLine.FIELDCAPTION("Starting Date Formula")));
                    Vend.SETRANGE("Date Filter", FromDate, ToDate);
                    CASE ProfileQuestionnaireLine."Vendor Class. Field" OF
                        ProfileQuestionnaireLine."Vendor Class. Field"::"Purchase (LCY)":
                            BEGIN
                                Vend.CALCFIELDS("Purchases (LCY)");
                                Vend."Purchases (LCY)" := Vend."Purchases (LCY)";
                                InsertContactValue(ProfileQuestionnaireLine, VendContactNo, Vend."Purchases (LCY)", 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Vendor Class. Field"::"Purchase Frequency (Invoices/Year)":
                            BEGIN
                                VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
                                VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                                VendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
                                VendLedgEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := VendLedgEntry.COUNT;
                                NoOfYears := (ToDate - FromDate + 1) / 365;
                                InsertContactValue(ProfileQuestionnaireLine, VendContactNo, NoOfInvoices / NoOfYears, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Vendor Class. Field"::"Avg. Ticket Size (LCY)":
                            BEGIN
                                VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
                                VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                                VendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
                                VendLedgEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := VendLedgEntry.COUNT;
                                IF NoOfInvoices <> 0 THEN BEGIN
                                    VendLedgEntry.CALCSUMS("Purchase (LCY)");
                                    VendLedgEntry."Purchase (LCY)" := -VendLedgEntry."Purchase (LCY)";
                                    InsertContactValue(ProfileQuestionnaireLine, VendContactNo, VendLedgEntry."Purchase (LCY)" / NoOfInvoices, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, VendContactNo, 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Vendor Class. Field"::"Discount (%)":
                            BEGIN
                                VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
                                VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                                VendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
                                VendLedgEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
                                //ProjectPro - start
                                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                                //ProjectPro - end
                                IF VendLedgEntry.FIND('-') THEN BEGIN
                                    VendLedgEntry.CALCSUMS("Purchase (LCY)");
                                    VendLedgEntry."Purchase (LCY)" := -VendLedgEntry."Purchase (LCY)";
                                    ValueEntry.SETCURRENTKEY("Source Type", "Source No.", "Item No.", "Posting Date");
                                    ValueEntry.SETRANGE("Source Type", ValueEntry."Source Type"::Vendor);
                                    ValueEntry.SETRANGE("Source No.", Vend."No.");
                                    ValueEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
                                    ValueEntry.CALCSUMS("Discount Amount");
                                    IF (VendLedgEntry."Purchase (LCY)" + ValueEntry."Discount Amount") <> 0 THEN
                                        InsertContactValue(
                                          ProfileQuestionnaireLine, VendContactNo,
                                          100 * ValueEntry."Discount Amount" /
                                          (VendLedgEntry."Purchase (LCY)" + ValueEntry."Discount Amount"), 0D, 0)
                                    ELSE
                                        InsertContactValue(ProfileQuestionnaireLine, VendContactNo, 0, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, VendContactNo, 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Vendor Class. Field"::"Avg. Overdue (Day)":
                            BEGIN
                                VendLedgEntry.SETCURRENTKEY("Document Type", "Vendor No.", "Posting Date");
                                VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Invoice);
                                VendLedgEntry.SETRANGE("Vendor No.", Vend."No.");
                                VendLedgEntry.SETFILTER("Posting Date", Vend.GETFILTER("Date Filter"));
                                VendLedgEntry.SETRANGE(Open, FALSE);
                                //ProjectPro - start
                                IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                                    VendLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                                //ProjectPro - end
                                NoOfInvoices := VendLedgEntry.COUNT;
                                IF NoOfInvoices <> 0 THEN BEGIN
                                    DaysOverdue := 0;
                                    VendLedgEntry.FIND('-');
                                    REPEAT
                                        IF VendLedgEntry."Closed at Date" > VendLedgEntry."Due Date" THEN
                                            DaysOverdue := DaysOverdue + (VendLedgEntry."Closed at Date" - VendLedgEntry."Due Date")
                                        ELSE
                                            IF VendLedgEntry."Closed at Date" = 0D THEN BEGIN
                                                VendLedgEntry2.RESET;
                                                VendLedgEntry2.SETCURRENTKEY("Closed by Entry No.");
                                                VendLedgEntry2.SETRANGE("Document Type", VendLedgEntry2."Document Type"::Payment);
                                                VendLedgEntry2.SETRANGE("Closed by Entry No.", VendLedgEntry."Entry No.");
                                                IF VendLedgEntry2.FINDFIRST AND
                                                   (VendLedgEntry2."Closed at Date" > VendLedgEntry."Due Date")
                                                THEN
                                                    DaysOverdue := DaysOverdue + (VendLedgEntry2."Closed at Date" - VendLedgEntry."Due Date");
                                            END;
                                    UNTIL VendLedgEntry.NEXT = 0;
                                    InsertContactValue(ProfileQuestionnaireLine, VendContactNo, DaysOverdue / NoOfInvoices, 0D, 0);
                                END ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, VendContactNo, 0, 0D, 0);
                            END;
                    END;
                END;
            UNTIL Vend.NEXT = 0
    end;

    local procedure FindContactValues(ProfileQuestionnaireLine: Record "Profile Questionnaire Line")
    var
        Cont: Record Contact;
        ContNo: Code[20];
        NoOfYears: Decimal;
        WonCount: Integer;
        LostCount: Integer;
        FromDate: Date;
        ToDate: Date;
    begin
        NoOfRecs := Cont.COUNT;
        IF Cont.FIND('-') THEN
            REPEAT
                RecCount := RecCount + 1;
                Window.UPDATE(5, Cont."No.");
                Window.UPDATE(6, ROUND(10000 * RecCount / NoOfRecs, 1));
                ContNo := ContactNo(ProfileQuestionnaireLine, DATABASE::Contact, Cont."No.");
                IF ContNo <> '' THEN BEGIN
                    Cont.RESET;
                    FromDate := CALCDATE(ProfileQuestionnaireLine."Starting Date Formula", Date);
                    ToDate := CALCDATE(ProfileQuestionnaireLine."Ending Date Formula", Date);
                    IF ToDate < FromDate THEN
                        ProfileQuestionnaireLine.FIELDERROR("Ending Date Formula",
                          STRSUBSTNO(Text003,
                            ProfileQuestionnaireLine.FIELDCAPTION("Ending Date Formula"),
                            ProfileQuestionnaireLine.FIELDCAPTION("Starting Date Formula")));
                    Cont.SETRANGE("Date Filter", FromDate, ToDate);
                    CASE ProfileQuestionnaireLine."Contact Class. Field" OF
                        ProfileQuestionnaireLine."Contact Class. Field"::"Interaction Quantity":
                            BEGIN
                                Cont.CALCFIELDS("No. of Interactions");
                                InsertContactValue(ProfileQuestionnaireLine, Cont."No.", Cont."No. of Interactions", 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Contact Class. Field"::"Interaction Frequency (No./Year)":
                            BEGIN
                                Cont.CALCFIELDS("No. of Interactions");
                                NoOfYears := (ToDate - FromDate + 1) / 365;
                                InsertContactValue(ProfileQuestionnaireLine, Cont."No.", Cont."No. of Interactions" / NoOfYears, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Contact Class. Field"::"Avg. Interaction Cost (LCY)":
                            BEGIN
                                Cont.CALCFIELDS("No. of Interactions", "Cost (LCY)");
                                IF Cont."No. of Interactions" <> 0 THEN
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", Cont."Cost (LCY)" / Cont."No. of Interactions", 0D, 0)
                                ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Contact Class. Field"::"Avg. Interaction Duration (Min.)":
                            BEGIN
                                Cont.CALCFIELDS("No. of Interactions", "Duration (Min.)");
                                IF Cont."No. of Interactions" <> 0 THEN
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", Cont."Duration (Min.)" / Cont."No. of Interactions", 0D, 0)
                                ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", 0, 0D, 0);
                            END;
                        ProfileQuestionnaireLine."Contact Class. Field"::"Opportunity Won (%)":
                            BEGIN
                                Cont.SETRANGE("Action Taken Filter", Cont."Action Taken Filter"::Won);
                                Cont.CALCFIELDS("No. of Opportunities");
                                WonCount := Cont."No. of Opportunities";
                                Cont.SETRANGE("Action Taken Filter", Cont."Action Taken Filter"::Lost);
                                Cont.CALCFIELDS("No. of Opportunities");
                                LostCount := Cont."No. of Opportunities";
                                IF (LostCount + WonCount) <> 0 THEN
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", 100 * WonCount / (LostCount + WonCount), 0D, 0)
                                ELSE
                                    InsertContactValue(ProfileQuestionnaireLine, Cont."No.", 0, 0D, 0);
                            END;
                    END;
                END;
            UNTIL Cont.NEXT = 0
    end;

    local procedure ContactNo(ProfileQuestionnaireLine: Record "Profile Questionnaire Line"; TableID: Integer; No: Code[20]) ContactNo: Code[20]
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
    begin
        ProfileQuestnHeader.GET(ProfileQuestionnaireLine."Profile Questionnaire Code");
        IF TableID = DATABASE::Contact THEN
            ContactNo := No
        ELSE
            WITH ContBusRel DO BEGIN
                RESET;
                SETCURRENTKEY("Link to Table", "No.");
                CASE TableID OF
                    DATABASE::Customer:
                        SETRANGE("Link to Table", "Link to Table"::Customer);
                    DATABASE::Vendor:
                        SETRANGE("Link to Table", "Link to Table"::Vendor);
                END;
                SETRANGE("No.", No);
                IF FINDFIRST THEN
                    ContactNo := "Contact No."
                ELSE
                    EXIT('');
            END;

        Cont.GET(ContactNo);
        IF (ProfileQuestnHeader."Contact Type" = ProfileQuestnHeader."Contact Type"::Companies) AND
           (Cont.Type <> Cont.Type::Company)
        THEN
            EXIT('');

        IF ProfileQuestnHeader."Business Relation Code" = '' THEN
            EXIT(ContactNo);

        ContBusRel.RESET;
        IF TableID = DATABASE::Contact THEN
            ContBusRel.SETRANGE("Contact No.", Cont."Company No.")
        ELSE
            ContBusRel.SETRANGE("Contact No.", ContactNo);
        ContBusRel.SETRANGE("Business Relation Code", ProfileQuestnHeader."Business Relation Code");
        IF NOT ContBusRel.ISEMPTY THEN
            EXIT(ContactNo);
        ContactNo := '';
    end;

    local procedure InsertContactValue(ProfileQuestionnaireLine: Record "Profile Questionnaire Line"; ContactNo: Code[20]; Value: Decimal; UpdateDate: Date; QuestionsAnsweredPrc: Decimal)
    begin
        ContactValue.INIT;
        ContactValue."Contact No." := ContactNo;
        IF ProfileQuestionnaireLine."Classification Method" = ProfileQuestionnaireLine."Classification Method"::"Defined Value" THEN
            ContactValue.Value := ROUND(Value, 1 / POWER(10, ProfileQuestionnaireLine."No. of Decimals"))
        ELSE
            ContactValue.Value := Value;
        ContactValue."Last Date Updated" := UpdateDate;
        ContactValue."Questions Answered (%)" := QuestionsAnsweredPrc;
        ContactValue.INSERT;
        TotalValue := TotalValue + ContactValue.Value;
    end;

    local procedure MarkByDefinedValue(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line"; ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    begin
        ContactValue.RESET;
        IF ContactValue.FIND('-') THEN
            REPEAT
                IF InRange(ContactValue.Value, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") THEN
                    MarkContact(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, ContactValue."Contact No.",
                      ContactValue."Last Date Updated", ContactValue."Questions Answered (%)")
            UNTIL ContactValue.NEXT = 0;
    end;

    local procedure MarkByPercentageOfValue(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line"; ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    var
        AccAmount: Decimal;
        Prc: Decimal;
    begin
        ContactValue.RESET;
        ContactValue.SETCURRENTKEY(Value);

        IF ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."Sorting Method"::" " THEN
            ERROR(
              Text008,
              ProfileQuestnLineQuestion.FIELDCAPTION("Sorting Method"),
              ProfileQuestnLineQuestion."Profile Questionnaire Code",
              ProfileQuestnLineQuestion.Description);

        CASE ProfileQuestnLineQuestion."Sorting Method" OF
            ProfileQuestnLineQuestion."Sorting Method"::Descending:
                ContactValue.ASCENDING(FALSE);
            ProfileQuestnLineQuestion."Sorting Method"::Ascending:
                ContactValue.ASCENDING(TRUE);
        END;

        IF ContactValue.FINDSET THEN
            REPEAT

                AccAmount := AccAmount + ContactValue.Value;

                IF TotalValue <> 0 THEN
                    Prc := ROUND(100 * ContactValue.Value / TotalValue, 1 / POWER(10, ProfileQuestnLineQuestion."No. of Decimals"))
                ELSE
                    Prc := 0;
                IF InRange(Prc, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") THEN
                    MarkContact(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, ContactValue."Contact No.",
                      ContactValue."Last Date Updated", ContactValue."Questions Answered (%)");
            UNTIL ContactValue.NEXT = 0
    end;

    local procedure MarkByPercentageOfContacts(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line"; ProfileQuestnLineAnswer: Record "Profile Questionnaire Line")
    var
        ContactValueCount: Integer;
        RecNo: Integer;
        Prc: Decimal;
    begin
        ContactValue.RESET;
        ContactValue.SETCURRENTKEY(Value);

        IF ProfileQuestnLineQuestion."Sorting Method" = ProfileQuestnLineQuestion."Sorting Method"::" " THEN
            ERROR(
              Text008,
              ProfileQuestnLineQuestion.FIELDCAPTION("Sorting Method"),
              ProfileQuestnLineQuestion."Profile Questionnaire Code",
              ProfileQuestnLineQuestion.Description);

        CASE ProfileQuestnLineQuestion."Sorting Method" OF
            ProfileQuestnLineQuestion."Sorting Method"::Descending:
                ContactValue.ASCENDING(FALSE);
            ProfileQuestnLineQuestion."Sorting Method"::Ascending:
                ContactValue.ASCENDING(TRUE);
        END;

        IF ContactValue.FIND('-') THEN BEGIN
            ContactValueCount := ContactValue.COUNT;
            RecNo := 0;
            REPEAT
                RecNo := RecNo + 1;
                Prc := ROUND(100 * RecNo / ContactValueCount, 1 / POWER(10, ProfileQuestnLineQuestion."No. of Decimals"));
                IF InRange(Prc, ProfileQuestnLineAnswer."From Value", ProfileQuestnLineAnswer."To Value") THEN
                    MarkContact(
                      ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, ContactValue."Contact No.",
                      ContactValue."Last Date Updated", ContactValue."Questions Answered (%)")
            UNTIL ContactValue.NEXT = 0
        END;
    end;

    local procedure InRange(Value: Decimal; FromValue: Decimal; ToValue: Decimal): Boolean
    begin
        IF (FromValue <> 0) AND (ToValue <> 0) AND (Value >= FromValue) AND (Value <= ToValue) THEN
            EXIT(TRUE);
        IF (FromValue <> 0) AND (ToValue = 0) AND (Value >= FromValue) THEN
            EXIT(TRUE);
        IF (FromValue = 0) AND (ToValue <> 0) AND (Value <= ToValue) THEN
            EXIT(TRUE);
    end;

    local procedure MarkContact(ProfileQuestnLineQuestion: Record "Profile Questionnaire Line"; ProfileQuestnLineAnswer: Record "Profile Questionnaire Line"; ContNo: Code[20]; UpdateDate: Date; QuestionsAnsweredPrc: Decimal)
    var
        Cont: Record Contact;
        ContPers: Record Contact;
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnHeader2: Record "Profile Questionnaire Header";
    begin
        ProfileQuestnHeader2.GET(ProfileQuestnLineQuestion."Profile Questionnaire Code");

        Cont.GET(ContNo);
        IF (Cont.Type = Cont.Type::Company) AND
           (ProfileQuestnLineQuestion."Contact Class. Field" = ProfileQuestnLineQuestion."Contact Class. Field"::" ") AND
           (ProfileQuestnHeader2."Contact Type" <> ProfileQuestnHeader2."Contact Type"::Companies)
        THEN BEGIN
            ContPers.RESET;
            ContPers.SETCURRENTKEY("Company No.");
            ContPers.SETRANGE("Company No.", Cont."No.");
            ContPers.SETRANGE(Type, Cont.Type::Person);
            IF ContPers.FIND('-') THEN
                REPEAT
                    MarkContact(ProfileQuestnLineQuestion, ProfileQuestnLineAnswer, ContPers."No.", UpdateDate, QuestionsAnsweredPrc);
                UNTIL ContPers.NEXT = 0
        END;

        IF (ProfileQuestnHeader2."Contact Type" = ProfileQuestnHeader2."Contact Type"::People) AND
           (Cont.Type <> Cont.Type::Person)
        THEN
            EXIT;
        IF (ProfileQuestnHeader2."Contact Type" = ProfileQuestnHeader2."Contact Type"::Companies) AND
           (Cont.Type <> Cont.Type::Company)
        THEN
            EXIT;

        ContProfileAnswer.INIT;
        ContProfileAnswer."Contact No." := Cont."No.";
        ContProfileAnswer."Profile Questionnaire Code" := ProfileQuestnLineAnswer."Profile Questionnaire Code";
        ContProfileAnswer."Line No." := ProfileQuestnLineAnswer."Line No.";
        ContProfileAnswer."Contact Company No." := Cont."Company No.";
        ContProfileAnswer."Profile Questionnaire Priority" := ProfileQuestnHeader2.Priority;
        ContProfileAnswer."Answer Priority" := ProfileQuestnLineAnswer.Priority;
        ContProfileAnswer."Questions Answered (%)" := QuestionsAnsweredPrc;
        IF UpdateDate = 0D THEN
            ContProfileAnswer."Last Date Updated" := TODAY
        ELSE
            ContProfileAnswer."Last Date Updated" := UpdateDate;
        ContProfileAnswer.INSERT;
    end;

    [Scope('Cloud')]
    procedure UpdateRating(UpdateContNo: Code[20])
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
        Rating: Record Rating;
        RatingQuestion: Record Rating;
        Cont: Record Contact;
        Leaf: Boolean;
        Changed: Boolean;
        ContNo: Code[20];
        NoOfRatingLines: Integer;
        RatingLineNo: Integer;
        Points: Integer;
        UpdateDate: Date;
        QuestionsAnsweredPrc: Decimal;
    begin
        // Mark all non-calculated rating questions
        ProfileQuestnLine.RESET;
        ProfileQuestnLine.SETRANGE("Contact Class. Field", ProfileQuestnLine."Contact Class. Field"::Rating);
        IF "Profile Questionnaire Header".Code <> '' THEN
            ProfileQuestnLine.SETRANGE("Profile Questionnaire Code", "Profile Questionnaire Header".Code);
        IF NOT ProfileQuestnLine.FIND('-') THEN
            EXIT;
        REPEAT
            ProfileQuestnLine.MARK(TRUE);
            NoOfRatingLines := NoOfRatingLines + 1;
        UNTIL ProfileQuestnLine.NEXT = 0;
        ProfileQuestnLine.MARKEDONLY(TRUE);

        // Calculate Ratings
        REPEAT
            Changed := FALSE;
            IF ProfileQuestnLine.FIND('-') THEN
                REPEAT
                    Leaf := TRUE;
                    Rating.SETRANGE("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
                    Rating.SETRANGE("Profile Questionnaire Line No.", ProfileQuestnLine."Line No.");
                    IF Rating.FIND('-') THEN
                        REPEAT
                            ProfileQuestnLine2.GET(Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.");
                            RatingQuestion.SETRANGE("Profile Questionnaire Code", Rating."Rating Profile Quest. Code");
                            RatingQuestion.SETRANGE("Profile Questionnaire Line No.", ProfileQuestnLine2.FindQuestionLine);
                            IF RatingQuestion.FINDFIRST THEN BEGIN
                                ProfileQuestnLine2 := ProfileQuestnLine;
                                ProfileQuestnLine.GET(
                                  RatingQuestion."Profile Questionnaire Code", RatingQuestion."Profile Questionnaire Line No.");
                                IF ProfileQuestnLine.MARK THEN
                                    Leaf := FALSE;
                                ProfileQuestnLine := ProfileQuestnLine2;
                            END;
                        UNTIL (Rating.NEXT = 0) OR (NOT Leaf);

                    // Calculate Rating
                    IF Leaf THEN BEGIN
                        IF UpdateContNo = '' THEN BEGIN
                            RatingLineNo := RatingLineNo + 1;
                            Window.UPDATE(1, ProfileQuestnLine."Profile Questionnaire Code");
                            Window.UPDATE(3, ProfileQuestnLine."Line No.");
                            Window.UPDATE(4, ROUND(10000 * RatingLineNo / NoOfRatingLines, 1));
                            NoOfRecs := Cont.COUNT;
                            RecCount := 0;
                            TotalValue := 0;
                        END;
                        ContactValue.DELETEALL;
                        AnswersExists(ProfileQuestnLine, UpdateContNo, TRUE);
                        IF UpdateContNo <> '' THEN
                            Cont.SETRANGE("No.", UpdateContNo);
                        IF Cont.FIND('-') THEN
                            REPEAT
                                IF UpdateContNo = '' THEN BEGIN
                                    RecCount := RecCount + 1;
                                    Window.UPDATE(5, Cont."No.");
                                    Window.UPDATE(6, ROUND(10000 * RecCount / NoOfRecs, 1));
                                END;
                                ContNo := ContactNo(ProfileQuestnLine, DATABASE::Contact, Cont."No.");
                                IF ContNo <> '' THEN BEGIN
                                    Points := FindContactRatingValue(ProfileQuestnLine, Cont, UpdateDate, QuestionsAnsweredPrc);
                                    IF QuestionsAnsweredPrc >= ProfileQuestnLine."Min. % Questions Answered" THEN
                                        InsertContactValue(ProfileQuestnLine, Cont."No.", Points, UpdateDate, QuestionsAnsweredPrc);
                                END;
                            UNTIL Cont.NEXT = 0;
                        MarkContactByMethod(ProfileQuestnLine, UpdateContNo);
                        ProfileQuestnLine.MARK(FALSE);
                        Changed := TRUE;
                    END;
                UNTIL ProfileQuestnLine.NEXT = 0;
        UNTIL Changed = FALSE;

        IF ProfileQuestnLine.FIND('-') THEN
            ERROR(Text004);
    end;

    local procedure FindContactRatingValue(ProfileQuestnLine: Record "Profile Questionnaire Line"; Cont: Record Contact; var UpdateDate: Date; var QuestionsAnsweredPrc: Decimal) Value: Decimal
    var
        Rating: Record Rating;
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
        TempProfileQuestnLine: Record "Profile Questionnaire Line" temporary;
        NoOfAnsweredQuestions: Integer;
    begin
        UpdateDate := TODAY;
        Rating.SETRANGE("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
        Rating.SETRANGE("Profile Questionnaire Line No.", ProfileQuestnLine."Line No.");
        IF Rating.FIND('-') THEN
            REPEAT
                ProfileQuestionnaireLine.GET(Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.");
                ProfileQuestionnaireLine.GET(
                  ProfileQuestionnaireLine."Profile Questionnaire Code", ProfileQuestionnaireLine.FindQuestionLine);
                IF NOT TempProfileQuestnLine.GET(
                     ProfileQuestionnaireLine."Profile Questionnaire Code", ProfileQuestionnaireLine."Line No.")
                THEN BEGIN
                    TempProfileQuestnLine.INIT;
                    TempProfileQuestnLine."Profile Questionnaire Code" := ProfileQuestionnaireLine."Profile Questionnaire Code";
                    TempProfileQuestnLine."Line No." := ProfileQuestionnaireLine."Line No.";
                    TempProfileQuestnLine.INSERT;
                    IF AnswersExists(ProfileQuestionnaireLine, Cont."No.", FALSE) THEN
                        NoOfAnsweredQuestions := NoOfAnsweredQuestions + 1;
                END;

                IF ContProfileAnswer.GET(
                     Cont."No.", Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.")
                THEN BEGIN
                    Value := Value + Rating.Points;
                    IF ContProfileAnswer."Last Date Updated" < UpdateDate THEN
                        UpdateDate := ContProfileAnswer."Last Date Updated";
                END;
            UNTIL Rating.NEXT = 0;

        IF TempProfileQuestnLine.COUNT <> 0 THEN
            QuestionsAnsweredPrc := NoOfAnsweredQuestions / TempProfileQuestnLine.COUNT * 100
        ELSE
            QuestionsAnsweredPrc := 0;
    end;

    local procedure MarkContactByMethod(ProfileQuestnLine: Record "Profile Questionnaire Line"; UpdateContNo: Code[20])
    var
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
    begin
        ProfileQuestnLine2.RESET;
        ProfileQuestnLine2 := ProfileQuestnLine;
        ProfileQuestnLine2.SETRANGE("Profile Questionnaire Code", ProfileQuestnLine."Profile Questionnaire Code");
        IF ProfileQuestnLine2.FIND('>') AND
           (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Answer)
        THEN
            REPEAT
                IF UpdateContNo = '' THEN
                    Window.UPDATE(3, ProfileQuestnLine2."Line No.");
                CASE ProfileQuestnLine."Classification Method" OF
                    ProfileQuestnLine."Classification Method"::"Defined Value":
                        MarkByDefinedValue(ProfileQuestnLine, ProfileQuestnLine2);
                    ProfileQuestnLine."Classification Method"::"Percentage of Value":
                        MarkByPercentageOfValue(ProfileQuestnLine, ProfileQuestnLine2);
                    ProfileQuestnLine."Classification Method"::"Percentage of Contacts":
                        MarkByPercentageOfContacts(ProfileQuestnLine, ProfileQuestnLine2);
                END;
            UNTIL (ProfileQuestnLine2.NEXT = 0) OR
                  (ProfileQuestnLine2.Type = ProfileQuestnLine2.Type::Question);
    end;
}

