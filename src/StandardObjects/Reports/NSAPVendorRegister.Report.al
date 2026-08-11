report 14021222 "NS_AP - Vendor Register"
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
    // +     PP_PurchSetup
    // +
    // +  - Modification(s):
    // +     - OnPreReport() - get Purchases & Payables Setup record
    // +     - Vendor Ledger Entry - OnPreDataItem: add filter on Retention Ledger Code if needed
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSAP - Vendor Register.rdl';

    Caption = 'AP - Vendor Register';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Register"; "G/L Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Creation Date", "Source Code", "Journal Batch Name";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }

            column(USERID; USERID)
            {
            }
            column(TIME; TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f'))
            {
            }
            column(TABLECAPTION__________FilterString; TABLECAPTION + ': ' + FilterString)
            {
            }
            column(FilterString; FilterString)
            {
            }
            column(Vendor_Ledger_Entry__TABLECAPTION__________FilterString2; "Vendor Ledger Entry".TABLECAPTION + ': ' + FilterString2)
            {
            }
            column(FilterString2; FilterString2)
            {
            }
            column(G_L_Register__No__; "No.")
            {
            }
            column(SourceCodeText; SourceCodeText)
            {
            }
            column(SourceCode_Description; SourceCode.Description)
            {
            }
            column(Vendor_Journal_RegisterCaption; Vendor_Journal_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Applies_to_Doc__No__Caption; "Vendor Ledger Entry".FIELDCAPTION("Applies-to Doc. No."))
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__Caption; "Vendor Ledger Entry".FIELDCAPTION("Vendor No."))
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption; "Vendor Ledger Entry".FIELDCAPTION("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption; "Vendor Ledger Entry".FIELDCAPTION("Document Type"))
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amt___LCY__Caption; "Vendor Ledger Entry".FIELDCAPTION("Remaining Amt. (LCY)"))
            {
            }
            column(Vendor_Ledger_Entry__Amount__LCY__Caption; "Vendor Ledger Entry".FIELDCAPTION("Amount (LCY)"))
            {
            }
            column(Vendor_Ledger_Entry__Document_No__Caption; "Vendor Ledger Entry".FIELDCAPTION("Document No."))
            {
            }
            column(VendorNameCaption; VendorNameCaptionLbl)
            {
            }
            column(Register_No_Caption; Register_No_CaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                RequestFilterFields = "Vendor No.", "Document Type";
                column(Vendor_Ledger_Entry__Vendor_No__; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(Vendor_Ledger_Entry_Description; Description)
                {
                }
                column(Vendor_Ledger_Entry__Remaining_Amt___LCY__; "Remaining Amt. (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Amount__LCY__; "Amount (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Applies_to_Doc__No__; "Applies-to Doc. No.")
                {
                }
                column(VendorName; VendorName)
                {
                }
                column(G_L_Register___To_Entry_No______G_L_Register___From_Entry_No_____1; "G/L Register"."To Entry No." - "G/L Register"."From Entry No." + 1)
                {
                    //SPLN DecimalPlaces = 0 : 0;
                }
                column(Vendor_Ledger_Entry__Remaining_Amt___LCY___Control39; "Remaining Amt. (LCY)")
                {
                }
                column(Vendor_Ledger_Entry__Amount__LCY___Control40; "Amount (LCY)")
                {
                }
                column(VendorEntries; VendorEntries)
                {
                    //SPLN DecimalPlaces = 0 : 0;
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Number_of_entries_recorded__this_posting_Caption; Number_of_entries_recorded__this_posting_CaptionLbl)
                {
                }
                column(Number_of_Vendor_entries__this_posting_Caption; Number_of_Vendor_entries__this_posting_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CALCFIELDS("Amount (LCY)", "Remaining Amt. (LCY)");
                    IF NOT Vendor.GET("Vendor No.") THEN
                        CLEAR(Vendor);
                    VendorName := Vendor.Name;
                    VendorEntries := VendorEntries + 1;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Entry No.", "G/L Register"."From Entry No.", "G/L Register"."To Entry No.");
                    CurrReport.CREATETOTALS("Amount (LCY)", "Remaining Amt. (LCY)");
                    VendorEntries := 0;
                    //ProjectPro - start
                    IF NOT NS_PurchSetup."NS_Purchase Retention Inactive" THEN
                        SETRANGE("NS_Retention Ledger Code", NS_PurchSetup."NS_Normal Vendor Ledger No.");
                    //ProjectPro - end
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF "Source Code" <> '' THEN BEGIN
                    SourceCodeText := SourceCode.TABLECAPTION + ': ' + "Source Code";
                    IF NOT SourceCode.GET("Source Code") THEN
                        CLEAR(SourceCode);
                END ELSE BEGIN
                    CLEAR(SourceCodeText);
                    CLEAR(SourceCode);
                END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        FilterString := "G/L Register".GETFILTERS;
        FilterString2 := "Vendor Ledger Entry".GETFILTERS;
        CompanyInformation.GET;
        //ProjectPro - start
        NS_PurchSetup.GET;
        //ProjectPro - end
    end;

    var
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        SourceCode: Record "Source Code";
        TypeHelper: Codeunit "Type Helper";
        VendorName: Text[50];
        FilterString: Text;
        FilterString2: Text;
        SourceCodeText: Text[25];
        VendorEntries: Integer;
        Vendor_Journal_RegisterCaptionLbl: Label 'Vendor Journal Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        DescriptionCaptionLbl: Label 'Description';
        VendorNameCaptionLbl: Label 'Name';
        Register_No_CaptionLbl: Label 'Register No:';
        Number_of_entries_recorded__this_posting_CaptionLbl: Label 'Number of entries recorded (this posting)';
        Number_of_Vendor_entries__this_posting_CaptionLbl: Label 'Number of Vendor entries (this posting)';
        NS_PurchSetup: Record "Purchases & Payables Setup";
}

