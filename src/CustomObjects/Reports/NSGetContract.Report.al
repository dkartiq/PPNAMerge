report 14021168 "NS_Get Contract"
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Get Contract';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            dataitem("Job Planning Line"; "Job Planning Line")
            {
                RequestFilterFields = "Job No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code";

                trigger OnAfterGetRecord();
                begin
                    if Job."No." <> "Job No." then
                        Job.GET("Job No.");

                    if Type <> Type::Text then begin
                        if ((not JobPostingGroup.GET(Job."Job Posting Group")) and (not Warned)) or
                           ((JobPostingGroup."Recognized Sales Account" = '') and (not Warned)) then begin
                            MESSAGE(Text002, Job."Job Posting Group");
                            Warned := true;
                        end;
                    end;

                    SalesLine.INIT;
                    SalesLine."Document Type" := "Sales Header"."Document Type";
                    SalesLine."Document No." := "Sales Header"."No.";
                    LastLineNo := LastLineNo + 10000;
                    SalesLine."Line No." := LastLineNo;
                    SalesLine.Description := Description;
                    if Type <> Type::Text then begin
                        SalesLine.Type := SalesLine.Type::"G/L Account";
                        SalesLine.VALIDATE("No.", JobPostingGroup."Recognized Sales Account");
                        SalesLine.Description := Description;
                        SalesLine."Variant Code" := "Variant Code";
                        SalesLine."Job No." := "Job No.";
                        SalesLine."Job Task No." := Job.APOToJobTaskNo("NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
                        SalesLine."NS_Job Revenue Category" := "NS_Revenue Category";
                        // >> Upgrade
                        // SalesLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                        // SalesLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                        SalesLine.Validate("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");//FDD108
                        SalesLine.Validate("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");//FDD108
                        // << Upgrade
                        SalesLine."Unit of Measure" := "Unit of Measure Code";
                        SalesLine.Quantity := Quantity;
                        SalesLine.VALIDATE(Quantity);
                        SalesLine."Quantity (Base)" := "Quantity (Base)";
                        SalesLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
                        SalesLine."Unit Cost" := "Unit Cost";
                        SalesLine."Unit Price" := "Unit Price";
                        SalesLine.VALIDATE("Unit Price");
                        // >> Upgrade
                        //SalesLine."VAT Calculation Type" := SalesLine."VAT Calculation Type"::"Sales Tax";//FDD108
                        // << Upgrade 
                        SalesLine."Tax Area Code" := "Sales Header"."Tax Area Code";
                        SalesLine."Tax Liable" := "Sales Header"."Tax Liable";
                        SalesLine."Shortcut Dimension 1 Code" := "NS_Shortcut Dimension 1 Code";
                        SalesLine."Shortcut Dimension 2 Code" := "NS_Shortcut Dimension 2 Code";
                        // >> Upgrade
                        //SalesLine."Dimension Set ID" := "NS_Dimension Set ID";
                        // << Upgrade
                        SalesLine."Location Code" := "Location Code";
                    end;
                    SalesLine.INSERT;
                end;

                trigger OnPreDataItem();
                begin
                    SETFILTER("Line Type", '%1|%2', "Line Type"::Billable, "Line Type"::"Both Budget and Billable");

                    //Find Last Line Number in Sales Line table for the Invoice
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", "Sales Header"."Document Type");
                    SalesLine.SETRANGE("Document No.", "Sales Header"."No.");
                    if SalesLine.FINDLAST then
                        LastLineNo := SalesLine."Line No."
                    else
                        LastLineNo := 0;
                end;
            }
        }
    }

    requestpage
    {

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

    trigger OnInitReport();
    begin
        "Job Planning Line".SETRANGE(Type);
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesLine: Record "Sales Line";
        Job: Record Job;
        // JobActivity: Record "NS_Job Activity";
        // JobProcess: Record "NS_Job Process";
        // JobOperation: Record "NS_Job Operation";
        JobPostingGroup: Record "Job Posting Group";
        LastLineNo: Integer;
        Warned: Boolean;
        Text001: Label 'Cannot find a Recognized Sales Account in the Job Posting Group for Revenue Category %1';
        Text002: Label 'Cannot find a Recognized Sales Account in the Job Posting Group for %1';
}

