/// <summary>
/// Report NS_SubconCahReqTrfToChaOrder (ID 14021241).
/// </summary>
/// PE-177.DK.2.0 22Nov2023 |Create new Process only Report
report 14021241 "NS_SubconCahReqTrfToChaOrder"
{
    //  UsageCategory = Documents; //PE-177.DK.3.0 23Jan2024
    Caption = 'Subcontract Change Request Transfer to Change Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) where(Number = filter(1));
            trigger OnPreDataItem()
            var
                NS_lcChangeOrderNo: Code[20];
                NS_SubCon: Record NS_Subcontract;
                IsSelected: Boolean;
            begin
            //PE-177.DK.3.0 23Jan2024 Start
                // NS_SubcontractLines.LOOKUPMODE := true;
                // if ChangeOrderNo <> '' then
                //     NS_SubcontractLinesNew.SETRANGE("NS_No.", ChangeOrderNo);
                // NS_SubcontractLines.SETTABLEVIEW(NS_SubcontractLinesNew);
                // if ChangeOrderNo <> '' then begin
                // NS_SubcontractLines.NS_GetFromSubcontractChangeRequestLine(ChangeOrderNo, NSLeveltoSubcontractNo, NSChangeReqNo, true);
                //     IsSelected := false;
                //     // if NS_lcChangeOrderNo <> '' then begin
                //     if not IsSelected then begin
                //         NS_SubCon.reset;
                //         NS_SubCon.setrange("NS_Sub-LeveltoSubcontractNo.", NSLeveltoSubcontractNo);
                //         NS_SubCon.SetRange("NS_Manager Subcontract Status", NS_SubCon."NS_Manager Subcontract Status"::Approval);
                //         NS_SubCon.SetRange("NS_Subcon Class", NS_SubCon."NS_Subcon Class"::"Change Request");
                //         if NS_SubCon.FindSet() then;
                //     end else
                //         if NS_SubCon.FindSet() then;
                //     repeat
                //         NS_SubCon.Validate(NS_Status, NS_SubCon.NS_Status::Completed);
                //         NS_SubCon."NS_Manager Subcontract Status" := NS_SubCon."NS_Manager Subcontract Status"::Completed;
                //         NS_SubCon.Modify(false);
                //     until NS_SubCon.Next() = 0;
                //     // end;
                // end;

                // CLEAR(NS_SubcontractLines);
                //PE-177.DK.3.0 23Jan2024 End
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
                    //PE-177.DK.3.0 23Jan2024 Start
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
                    
                    // field(NSChangeReqNo; NSChangeReqNo)
                    // {
                    //     ApplicationArea = Jobs;
                    //     Caption = 'Change Request No.';
                    //     ToolTip = 'Specifies the posting date for the document.';
                    // }
                    //PE-177.DK.3.0 23Jan2024 End
                    field(ChangeOrderNo; ChangeOrderNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Append to Change Order No.';
                        ToolTip = 'Specifies the number of the Change Request that you want to append the lines to if you did not select the Create New Change Order field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            NSSubCon2: Record "NS_Subcontract";
                        begin
                            NSSubCon.SetRange("NS_Subcon Class", NSSubCon."NS_Subcon Class"::"Change Order");
                            NSSubCon.SetRange("NS_Sub-LeveltoSubcontractNo.", NSLeveltoSubcontractNo);
                            if PAGE.RunModal(0, NSSubCon) = ACTION::LookupOK then
                                ChangeOrderNo := NSSubCon."NS_No.";
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
                        //PE-177.DK.3.0 23Jan2024 End
                    }

                }
            }
        }

        actions
        {
        }
//PE-177.DK.3.0 23Jan2024 Start
        trigger OnOpenPage()
        begin
           
            NS_NewChangeOrder := true;
            ChangeOrderNo := '';
         
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
        NS_ChangeRequestPage: Page NS_SubConChangeRequestList;
    begin
        NS_ChangeRequestPage.Setdefintion(ChangeOrderNo, NSChangeReqNo);
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
    procedure RetunValue(): Code[20]
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

        NSSubCon: Record "NS_Subcontract";
        NS_SubcontractLines: page "NS_Subcontract Lines";
        NS_SubcontractLinesNew: Record "NS_Subcontract Lines";
        NS_ChangeRequestPage: Page NS_SubConChangeRequestList;
        ChangeOrderNo: Code[20];
        NSChangeReqNo: Code[20];
        NSbuyFromVendorNo: Code[20];
        NSLeveltoSubcontractNo: Code[20];
        NSLeveltoJObNo: Code[20];
        NS_NewChangeOrder: Boolean;
        NS_Closepage: Boolean;


    /// <summary>
    /// NS_CreateChangeOrderFromCR.
    /// </summary>
    /// <param name="NS_No">Code[20].</param>
    /// <param name="LeveltoSubcontractNo">Code[20].</param>
    /// <param name="BoolValue">Boolean.</param>
    procedure NS_CreateChangeOrderFromCR(NS_No: Code[20]; LeveltoSubcontractNo: Code[20]; BoolValue: Boolean)
    begin
        NSChangeReqNo := NS_No;
        NSLeveltoSubcontractNo := LeveltoSubcontractNo;
        NSChangeReqNo := NS_No;
    end;
    //PE-177.DK.3.0 23Jan2024 End
}

