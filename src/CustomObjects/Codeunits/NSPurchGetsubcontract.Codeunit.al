codeunit 14021300 "NS_Purch.-Get Subcontract"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    TableNo = "Purchase Header";

    trigger OnRun();
    var
        SubcontractDetail: Record "NS_Subcontract Lines";
        PurchaseLine: Record "Purchase Line";
        NewLineNo: Integer;
    begin
        SubcontractList.LOOKUPMODE(true);
        SubcontractList.NS_SetVendor(Rec."Buy-from Vendor No.");
        if SubcontractList.RUNMODAL = ACTION::LookupOK then begin
            SubcontractList.GETRECORD(SubcontractHeader);

            SubcontractDetail.RESET;
            SubcontractDetail.SETRANGE("NS_Subcontract No.", SubcontractHeader."NS_No.");
            if SubcontractDetail.FINDSET then begin
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                PurchaseLine.SETRANGE("Document No.", Rec."No.");
                if PurchaseLine.FINDLAST then
                    NewLineNo := PurchaseLine."Line No." + 10000
                else
                    NewLineNo := 10000;

                if (Rec."NS_Retention Percent" = 0) and (SubcontractHeader."NS_Retention Percent" > 0) then begin
                    Rec."NS_Retention Percent" := SubcontractHeader."NS_Retention Percent";
                    Rec.VALIDATE("NS_Retention Percent");
                    Rec.MODIFY;
                end;

                repeat
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := Rec."Document Type";
                    PurchaseLine."Document No." := Rec."No.";
                    PurchaseLine."Line No." := NewLineNo;
                    PurchaseLine."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
                    PurchaseLine."Pay-to Vendor No." := Rec."Pay-to Vendor No.";
                    case SubcontractDetail.NS_Type of
                        SubcontractDetail.NS_Type::Resource:
                            PurchaseLine.Type := PurchaseLine.Type::Resource;
                        SubcontractDetail.NS_Type::Item:
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        SubcontractDetail.NS_Type::"G/L Account":
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    end;
                    PurchaseLine."No." := SubcontractDetail."NS_No.";
                    PurchaseLine.VALIDATE("No.");
                    PurchaseLine.Description := SubcontractDetail.NS_Description;
                    PurchaseLine."Job No." := SubcontractDetail."NS_Job No.";
                    PurchaseLine."NS_Subcontract No." := SubcontractDetail."NS_Subcontract No.";
                    PurchaseLine."Job Task No." := SubcontractDetail."NS_Job Task No.";
                    PurchaseLine."NS_Job Cost Category" := SubcontractDetail."NS_Job Cost Category";
                    PurchaseLine.Quantity := SubcontractDetail.NS_Quantity;
                    PurchaseLine."Unit of Measure" := SubcontractDetail."NS_Unit of Measure Code";
                    PurchaseLine."Direct Unit Cost" := SubcontractDetail."NS_Direct Unit Cost";
                    PurchaseLine."Unit Cost (LCY)" := SubcontractDetail."NS_Unit Cost";
                    if PurchaseLine.Type.AsInteger() > 0 then begin
                        PurchaseLine.VALIDATE(Quantity);
                        PurchaseLine.VALIDATE("Unit Cost");
                        PurchaseLine.VALIDATE("Unit Cost (LCY)");
                    end;
                    if Rec."NS_Retention Percent" > 0 then
                        PurchaseLine."NS_Retention Applies" := true;
                    PurchaseLine.INSERT;
                    NewLineNo := NewLineNo + 10000;
                until SubcontractDetail.NEXT = 0;
            end;
        end;
    end;

    var
        SubcontractHeader: Record NS_Subcontract;
        SubcontractList: Page "NS_Subcontract List";
}

