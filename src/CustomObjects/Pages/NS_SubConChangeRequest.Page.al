//PE-177.DK.1.0 Start created new Page for  SubCon change Request List

/// <summary>
/// Page NS_SubConChangeRequestList (ID 14021298).
/// </summary>
page 14021298 NS_SubConChangeRequestList
{
    Caption = 'Subcontract Change Request List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = NS_Subcontract;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    Caption = 'Change Request No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("NS_Sub-LeveltoSubcontractNo."; Rec."NS_Sub-LeveltoSubcontractNo.")
                {
                    ApplicationArea = All;
                    Caption = 'Sub-Level Subcontract No.';
                    Editable = false;
                }
                field("NS_Manager Subcontract Status"; Rec."NS_Manager Subcontract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Manager Status';
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(NS_MergeAll)
            {
                ApplicationArea = All;
                Caption = 'Merge All';
                Promoted = false;
                Image = CreateDocument;
                Visible = false; //PE-177.DK.3.0 23Jan2024
                ToolTip = 'Create change order for all change requests.';
                trigger OnAction();
                begin
                    //PE-177.DK.3.0 23Jan2024 Start
                    //PE-177.DK.2.0 22Nov2023 Start
                    // if Confirm('Do you Wish to Mearge Exiting Change Order?') then begin
                    //     NS_SubconCahReqTrf.NS_CreateChangeOrderFromCR(Rec."NS_No.", Rec."NS_Sub-LeveltoSubcontractNo.", true);
                    //     NS_SubconCahReqTrf.RunModal();
                    // end else
                    //     NS_CreateChangeOrderFromCR(true);
                    //PE-177.DK.2.0 22Nov2023 End
                    //PE-177.DK.3.0 23Jan2024 End
                end;
            }
            action(NS_MergeSelected)
            {
                ApplicationArea = All;
                //PE-177.DK.3.0 23Jan2024 Start
                //Caption = 'Merge Selected'; 
                Caption = 'Merge';
                Promoted = true;
                PromotedIsBig = true;
                //PE-177.DK.3.0 23Jan2024 End
                Image = CreateDocument;
                ToolTip = 'Create change order for the selected change requests.';
                trigger OnAction()
                begin
                    //PE-177.DK.3.0 23Jan2024 Start
                    //PE-177.DK.2.0 22Nov2023 Start
                    // if Confirm('Do you Wish to Mearge Exiting Change Order?') then begin
                    Clear(NS_SubconCahReqTrf);
                    NS_SubconCahReqTrf.NS_CreateChangeOrderFromCR(Rec."NS_No.", Rec."NS_Sub-LeveltoSubcontractNo.", true);
                    NS_SubconCahReqTrf.RunModal();
                    //PE-177.DK.2.0 22Nov2023 End
                    NS_ChangeOrderNo := NS_SubconCahReqTrf.RetunValue();
                    NS_ChangeRequestfalse := NS_SubconCahReqTrf.NS_ClosePageRetrun();
                    if not NS_ChangeRequestfalse then begin
                        if NS_ChangeOrderNo <> '' then
                            NS_GetFromSubcontractChangeRequestLine(NS_ChangeOrderNo, Rec."NS_No.", Rec."NS_Sub-LeveltoSubcontractNo.", true)
                        else
                            NS_CreateChangeOrderFromCR(true);
                    end;
                    //PE-177.DK.3.0 23Jan2024 End
                end;
            }

        }
    }
    var
        //PE-177.DK.3.0 23Jan2024 Start
        NS_SubconCahReqTrf: Report "NS_SubconCahReqTrfToChaOrder";//PE-177.DK.2.0 22Nov2023
        NS_ChangeOrderNo: Code[20];
        NS_ChangeRequestNo: Code[20];
        NS_ChangeRequestfalse: Boolean;
    //PE-177.DK.3.0 23Jan2024 Start

    /// <summary>
    /// NS_CreateChangeOrderFromCR.
    /// </summary>
    /// <param name="IsSelected">Boolean.</param>
    procedure NS_CreateChangeOrderFromCR(IsSelected: Boolean)
    var
        NS_SubCon: Record NS_Subcontract;
        NS_lcChangeOrderNo: Code[20];
        NS_LiLineNo: Integer;
        NS_SubConCard: Page "NS_Subcontract Card";
        //PE-177.DK.3.0 23Jan2024 Start
        NS_SubConCArd1: Record NS_Subcontract;
        NS_SubconCahReqTr: Report NS_SubconCahReqTrfToChaOrder;
        NS_SubcontractLines: Page "NS_Subcontract Lines";
        NS_SubconLineTbl: Record "NS_Subcontract Lines"; //PE-177.DK.4.0 02Feb2024 
        NS_SubconLineNewTbl: Record "NS_Subcontract Lines"; //PE-177.DK.4.0 02Feb2024
    //PE-177.DK.3.0 23Jan2024 Start
    begin
        //PE-177.DK.3.0 23Jan2024 Start
        // if Confirm('Do you wish to Marge Existing Change order ?') then
        //     NS_SubcontractLines.NS_CreateChangeReq(false);
        NS_LiLineNo := 10000;
        if IsSelected then
            CurrPage.SetSelectionFilter(NS_SubCon);
        NS_SubConCArd1.Reset();
        NS_SubConCArd1.SetRange("NS_Sub-LeveltoSubcontractNo.", Rec."NS_Sub-LeveltoSubcontractNo.");
        NS_SubConCArd1.SetRange("NS_Subcon Class", NS_SubConCArd1."NS_Subcon Class"::"Change Order");
        if NS_SubConCArd1.FindSet() then
            NS_lcChangeOrderNo := NS_SubCon.NS_CreateCOHeader(NS_SubConCArd1) //PE-177.DK.4.0 02Feb2024
        else
            NS_lcChangeOrderNo := NS_SubCon.NS_CreateCOHeader(Rec);//PE-177.DK.4.0 02Feb2024
        //PE-177.DK.3.0 23Jan2024 End
        if NS_lcChangeOrderNo <> '' then begin
            if not IsSelected then begin
                NS_SubCon.reset;
                NS_SubCon.setrange("NS_Sub-LeveltoSubcontractNo.", Rec."NS_Sub-LeveltoSubcontractNo.");
                NS_SubCon.SetRange("NS_Manager Subcontract Status", NS_SubCon."NS_Manager Subcontract Status"::Approval);//PE-177.DK.3.0 23Jan2024
                NS_SubCon.SetRange("NS_Subcon Class", NS_SubCon."NS_Subcon Class"::"Change Request");
                if NS_SubCon.FindSet() then;
            end else
                if NS_SubCon.FindSet() then;
            repeat
                //PE-177.DK.4.0 02Feb2024 Start
                NS_SubconLineTbl.Reset();
                NS_SubconLineTbl.SetRange("NS_Subcontract No.", NS_SubCon."NS_No.");
                if NS_SubconLineTbl.FindFirst() then
                    repeat
                        NS_SubconLineNewTbl.init();
                        NS_SubconLineNewTbl.TransferFields(NS_SubconLineTbl);
                        NS_SubconLineNewTbl."NS_Subcontract No." := NS_lcChangeOrderNo;
                        NS_SubconLineNewTbl."NS_Line No." := NS_LiLineNo;
                        NS_SubconLineNewTbl."NS_Change Request No." := NS_SubCon."NS_No.";
                        NS_SubconLineNewTbl.Insert();
                        NS_LiLineNo += 10000;
                    until NS_SubconLineTbl.next() = 0;
                //PE-177.DK.4.0 02Feb2024 End
                NS_SubCon.Validate(NS_Status, NS_SubCon.NS_Status::Completed);
                NS_SubCon."NS_Manager Subcontract Status" := NS_SubCon."NS_Manager Subcontract Status"::Completed;
                NS_SubCon.NS_MergedtoChangeOrderNo := NS_lcChangeOrderNo; //PE-177.Dk.5.0 08Feb2024
                NS_SubCon.Modify(false);
            until NS_SubCon.Next() = 0;
        end;
        IF CONFIRM('Subcontract No.' + ' ' + NS_lcChangeOrderNo + ' ' + 'has been created. Go to new Subcontract?') THEN BEGIN
            NS_SubCon.Reset();
            NS_SubCon.SetRange("NS_No.", NS_lcChangeOrderNo);
            NS_SubConCard.SETRECORD(NS_SubCon);
            Page.Run(Page::"NS_Subcontract Card", NS_SubCon);
        end;
    end;
    //PE-177.DK.3.0 23Jan2024 Start
    /// <summary>
    /// NS_GetFromSubcontractChangeRequestLine.
    /// </summary>
    /// <param name="NS_No">Code[20].</param>
    /// <param name="NSLeveltoSubcontractNo">code[20].</param>
    /// <param name="ChangeReqNo">Code[20].</param>
    /// <param name="NSChangeOrdger">Boolean.</param>
    procedure NS_GetFromSubcontractChangeRequestLine(NS_No: Code[20]; NSLeveltoSubcontractNo: code[20]; ChangeReqNo: Code[20]; NSChangeOrdger: Boolean);
    var
        NS_SubconLine: Record "NS_Subcontract Lines";
        NS_PassSubconLine: Record "NS_Subcontract Lines";
        NS_SubconLineNew: Record "NS_Subcontract Lines";
        NS_SubConHr: Record NS_Subcontract;
        SubConCardL: Page "NS_Subcontract Card";
        LastLineNo: Integer;
        NS_count: Integer;
    begin
        CurrPage.SetSelectionFilter(NS_SubConHr);
        NS_SubConHr.setrange("NS_Sub-LeveltoSubcontractNo.", Rec."NS_Sub-LeveltoSubcontractNo.");
        NS_SubConHr.SetRange("NS_Manager Subcontract Status", NS_SubConHr."NS_Manager Subcontract Status"::Approval);
        NS_SubConHr.SetRange("NS_Subcon Class", NS_SubConHr."NS_Subcon Class"::"Change Request");
        if NS_SubConHr.FindSet() then begin
            repeat
                NS_count := 0;
                LastLineNo := 0;
                NS_SubconLineNew.RESET();
                NS_SubconLineNew.SETRANGE("NS_Subcontract No.", NS_No);
                if NS_SubconLineNew.FINDSet() then begin
                    NS_count := NS_SubconLineNew.Count + 1;
                    LastLineNo := NS_count * 10000;
                end;
                NS_PassSubconLine.Reset();
                NS_PassSubconLine.SetRange("NS_Subcontract No.", NS_SubConHr."NS_No.");
                if NS_PassSubconLine.findset() then begin
                    repeat
                        NS_SubconLine.INIT();
                        NS_SubconLine.TransferFields(NS_PassSubconLine);
                        NS_SubconLine."NS_Subcontract No." := NS_No;
                        NS_SubconLine."NS_Line No." := LastLineNo;
                        NS_SubconLine."NS_Change Request No." := NS_SubConHr."NS_No.";
                        if NS_SubconLine.Insert() then
                            LastLineNo := LastLineNo + 10000;
                    until NS_PassSubconLine.Next() = 0;
                    NS_SubConHr.Validate(NS_Status, NS_SubConHr.NS_Status::Completed);
                    NS_SubConHr."NS_Manager Subcontract Status" := NS_SubConHr."NS_Manager Subcontract Status"::Completed;
                    NS_SubConHr.NS_MergedtoChangeOrderNo := NS_ChangeOrderNo;
                    NS_SubConHr.Modify(false);
                end;
            until NS_SubConHr.Next = 0;
            // if CONFIRM('Subcontract No. ' + NS_SubconLineNew."NS_No." + ' has been created. Go to new Subcontract?') then begin
            //     SubConCardL.SetRecord(NS_SubconLineNew);
            //     SubConCardL.Run();
            // end;
        end;
    end;
    /// <summary>
    /// Setdefintion.
    /// </summary>
    /// <param name="OrderNo">Code[20].</param>
    /// <param name="NSChangeRequestNo">Code[20].</param>
    procedure Setdefintion(OrderNo: Code[20]; NSChangeRequestNo: Code[20])
    begin
        NS_ChangeOrderNo := OrderNo;
        NS_ChangeRequestNo := NSChangeRequestNo;

    end;

    procedure Setdefintion(OrderNo: Code[20]; NSChangeRequestNo: Code[20]; ClosePage: Boolean)
    begin
        NS_ChangeOrderNo := OrderNo;
        NS_ChangeRequestNo := NSChangeRequestNo;
        NS_ChangeRequestfalse := ClosePage;
    end;
    //PE-177.DK.3.0 23Jan2024 Start
}