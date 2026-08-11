/// <summary>
/// Report ChangeRequesttoChangeOrder (ID 14021289).
/// </summary>
/// PE-193.PS.2.0 Create Process Only report 
report 14021299 NS_ChangeRequesttoChangeOrder
{
    Caption = 'Change Request Transfer to Change Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) where(Number = filter(1));
            trigger OnPreDataItem()
            var
                NS_lcChangeOrderNo: Code[20];
                NS_ChangeRequest: Record job;
                IsSelected: Boolean;
            begin

            end;
        }
    }


    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CreateNewInvoice; NS_NewChangeOrder)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create New Change Order';
                        ToolTip = 'Specifies if the batch job creates a new sales invoice.';
                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            if NS_NewChangeOrder = true then
                                ChangeOrderNo := '';
                        end;
                    }

                    field(AppendToSalesInvoiceNo; ChangeOrderNo)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Append to Change Order No.';
                        ToolTip = 'Specifies the number of the sales invoice that you want to append the lines to if you did not select the Create New Sales Invoice field.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(NS_Job);
                            if NSLeveltoJObNo <> '' then begin
                                NS_Job.SetRange("NS_Job Class", NS_Job."NS_Job Class"::"Change Order");
                                NS_Job.SetRange("NS_Sub-Level to Job No.", NSLeveltoJObNo);
                                if PAGE.RunModal(0, NS_Job) = ACTION::LookupOK then
                                    ChangeOrderNo := NS_Job."No.";
                            end;

                            if ChangeOrderNo = '' then
                                InitReport()
                            else
                                NS_NewChangeOrder := false;

                        end;

                        trigger OnValidate()
                        var
                            myInt: Integer;
                        begin
                            if ChangeOrderNo = '' then
                                InitReport()
                            else
                                NS_NewChangeOrder := false;
                        end;
                    }

                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        var
            myInt: Integer;
        begin
            //PE-193.PS.2.0 08Dec2023 Start
            NS_NewChangeOrder := true;
            ChangeOrderNo := '';
            //PE-193.PS.2.0 08Dec2023 End
            Clear(NS_Closepage);
            if ChangeOrderNo = '' then
                InitReport();
        end;


        trigger OnQueryClosePage(CancelButtom: Action): Boolean
        var
            myInt: Integer;
        begin
            if CancelButtom = Action::Cancel then begin
                NS_Closepage := true;
                NS_ChangeRequestPage.Setdefintion(ChangeOrderNo, NSChangeReqNo, NS_Closepage);
            end;



        end;

    }
    trigger OnPostReport()
    var

    begin
        NS_ChangeRequestPage.Setdefintion(ChangeOrderNo, NSChangeReqNo, NS_Closepage);
    end;

    /// <summary>
    /// InitReport.
    /// </summary>
    procedure InitReport()
    begin
        NS_NewChangeOrder := true;
        ChangeOrderNo := '';
    end;

    /// <summary>
    /// RetunValue.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    /// <returns>Return value of type Code[20].</returns>
    procedure NS_RetunValue(): Code[20]
    begin
        exit(ChangeOrderNo);
    end;
    /// <summary>
    /// ClosePageRetrun.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure NS_ClosePageRetrun(): Boolean
    begin
        exit(NS_Closepage);
    end;


    var
        Job: Record Job;
        NS_Job: Record Job;
        PostingDate: Date;
        InvoicePostingDate: Date;
        Done: Boolean;
        ChangeOrderNo: Code[20];
        NSChangeReqNo: Code[20];
        NSbuyFromVendorNo: Code[20];
        NSLeveltoJObNo: Code[20];
        NS_NewChangeOrder: Boolean;
        NS_JobPlaningLine: Page "Job Planning Lines";
        NS_JobPlaningLineNew: Record "Job Planning Line";
        NS_Closepage: Boolean;
        NS_ChangeRequestPage: Page NS_ChangeRequestList;
    /// <summary>
    /// NS_CreateChangeOrderFromCR.
    /// </summary>
    /// <param name="NS_No">Code[20].</param>
    /// <param name="LeveltoSubLeveljobNo">Code[20].</param>
    /// <param name="BoolValue">Boolean.</param>
    procedure NS_CreateChangeOrderFromCR(NS_No: Code[20]; LeveltoSubLeveljobNo: Code[20]; BoolValue: Boolean)
    begin
        ChangeOrderNo := NS_No;
        NSLeveltoJObNo := LeveltoSubLeveljobNo;
        NSChangeReqNo := NS_No;
    end;
}

