pageextension 14021116 NS_SalesOrderSubform extends "Sales Order Subform"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,NAVMX11.00.00.25466,PPNA11.00
    //PRJ-89.SK.1.0 Modified code
    //PRJ-1221.JS.1.0 | change regarding creoss reference no. functionality
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJCTPR-75 DK.1.0. 2March2023 | Job no field Visiable false
    //PRJCTPR-75 DK.1.0. 9March2023 | Job Task No. field Visiable false
    Caption = 'Lines'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        //PRJ-492.N.S.1.0 Start
        modify("Location Code")
        {
            Visible = false;
        }
        //moveafter("Amount Including VAT"; "Tax Area Code")//PRJ-492 Test Commented this V17 Code
        moveafter("Line Amount"; "Tax Area Code")//PRJ-492 Test Added this in place of addafter("Amount Including VAT")
        moveafter("Tax Area Code"; "Tax Group Code")

        //PRJ-492.N.S.1.0 End

        modify(Type)
        {
            //Visible = false; //PRJ-89.SK.1.0 Blocked
            //Enabled = false; //PRJ-89.SK.1.0 Blocked

            //PRJ-89.SK.1.0 Start
            trigger OnAfterValidate()
            begin
                IF xRec."No." <> '' THEN
                    RedistributeTotalsOnAfterValidate();
                NS_UpdateEditableOnRow();
                NS_UpdateTypeText();
            end;
            //PRJ-89.SK.1.0 End
        }
        //PRJ-89.SK.1.0 Start
        // addbefore(FilteredTypeField)
        // {
        //     field(TypeNew; Type)
        //     {
        //         Caption = 'Type';
        //         ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';
        //         ApplicationArea = Advanced;
        //         trigger OnValidate();
        //         begin
        //             NoOnAfterValidate;
        //             SetLocationCodeMandatory;

        //             IF xRec."No." <> '' THEN
        //                 RedistributeTotalsOnAfterValidate;
        //             UpdateEditableOnRow;
        //             UpdateTypeText;
        //         end;
        //     }
        // }
        //PRJ-89.SK.1.0 End

        modify("No.")
        {
            // Visible = false; //PRJ-89.SK.1.0 Blocked
            // Enabled = false; //PRJ-89.SK.1.0 Blocked

            //PRJ-89.SK.1.0 Start
            trigger OnAfterValidate()
            begin
                IF xRec."No." <> '' THEN
                    RedistributeTotalsOnAfterValidate;
                NS_UpdateTypeText;
            end;
            //PRJ-89.SK.1.0 End
        }

        //PRJ-89.SK.1.0 Start
        // addafter(FilteredTypeField)
        // {
        //     field("NoNew"; "No.")
        //     {
        //         Caption = 'No.';
        //         ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
        //         ApplicationArea = Basic, Suite;
        //         trigger OnValidate();
        //         begin
        //             NoOnAfterValidate;
        //             UpdateEditableOnRow;
        //             ShowShortcutDimCode(ShortcutDimCode);

        //             QuantityOnAfterValidate;
        //             IF xRec."No." <> '' THEN
        //                 RedistributeTotalsOnAfterValidate;
        //             UpdateTypeText;
        //         end;
        //     }
        // }
        //PRJ-89.SK.1.0 End

        //PRJ-1221.JS.1.0 24FEB2022 - Start
        // modify("Cross-Reference No.")
        // {
        //     Visible = false;
        //     Enabled = false;
        // }

        modify("Item Reference No.")
        {
            Visible = false;
            Enabled = false;
        }


        addafter("No.")
        {
            field("NS_Cross-Reference No New"; Rec."Item Reference No.")   //PRJ-1221.JS.1.0 24FEB2022
            {
                Caption = 'Item Reference No.';   //PRJ-1221.JS.1.0 24FEB2022
                ToolTip = 'Specifies the Item Reference item number. If you enter a Item Reference between yours and your vendors or customers item number, then this number will override the standard item number when you enter the Item Reference number on a sales or purchase document.';  //PRJ-1221.JS.1.0 24FEB2022
                ApplicationArea = Basic, Suite;
                Visible = false;
                trigger OnValidate();
                begin
                    NS_NoOnAfterValidate();   //PRJ-1221.JS.1.0 24FEB2022
                end;

                trigger OnLookup(VAR Text: Text): Boolean;
                var
                    ItemRefMgt: codeunit "Item Reference Management";  //PRJ-1221.JS.1.0 24FEB2022
                begin
                    //Rec.CrossReferenceNoLookUp(); //PRJ-1135.NK.1.0  //PRJ-1221.JS.1.0 24FEB2022 line commented
                    ItemRefMgt.SalesReferenceNoLookup(Rec);  //PRJ-1221.JS.1.0 24FEB2022 line added
                    NS_NoOnAfterValidate();
                end;
            }
        }
        //PRJ-1221.JS.1.0 24FEB2022 - end

        modify(Description)
        {
            Visible = false;
            Enabled = false;
        }
        addafter("VAT Prod. Posting Group")
        {
            field(NS_Description; Description)
            {
                Caption = 'Description';
                ToolTip = 'Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.';
                ApplicationArea = Basic, Suite;
                trigger OnValidate();
                begin
                    NS_UpdateEditableOnRow;

                    IF "No." = xRec."No." THEN
                        EXIT;

                    NS_NoOnAfterValidate;
                    ShowShortcutDimCode(ShortcutDimCode);
                    IF xRec."No." <> '' then
                        RedistributeTotalsOnAfterValidate;
                    NS_UpdateTypeText;
                end;
            }
        }
        //PRJ-492.N.S.1.0 Start
        // addafter("Variant Code")
        // {
        //     field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Gen. Bus. Posting Group';
        //     }
        //     field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the Gen. Prod. Posting Group';
        //     }
        // }
        //PRJ-492.N.S.1.0 Start
        addafter("Tax Group Code")
        {
            field("NS_VAT Base Amount"; Rec."VAT Base Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT Base Amount';
            }
        }
        //PPDA.1.0.TBA Start
        // addafter("Amount Including VAT")
        // {
        //     field("NS_Retention Applies"; Rec."NS_Retention Applies")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies whether Retention Applies';
        //     }
        // }
        //PPDA.1.0.TBA End


        //addafter("Qty. Assigned")//PRJ-492.N.S.1.0
        addafter(Description)//PRJ-492.N.S.1.0
        {
            field("NS_Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                Visible = false;//PRJCTPR-75 DK.1.0. 2March2023
                ToolTip = 'Specifies the qJob No.';

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the qJob Task No.';
                Visible = false;//PRJCTPR-75 Dk.1.0 9March2023
                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            //PRJ-492.N.S.1.0 Start

            field("NS_Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Bus. Posting Group';
            }
            field("NS_Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Gen. Prod. Posting Group';
            }

            //PRJ-492.N.S.1.0 End
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the qJob Cost Category';
                Visible = false; //PRJ-492.AS.1.0

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the qJob Revenue Category';
                Visible = false; //PRJ-492.AS.1.0

                trigger OnValidate();
                begin
                    //ProjectPro - start
                    NS_Job.CorrectForBlankFields("Job No.", "Job No.", "NS_Job Cost Category", "NS_Job Revenue Category", "Job Task No.");
                    //ProjectPro - end
                end;
            }
            field("NS_Segment Code"; "NS_Segment Code")
            {
                ApplicationArea = all;
                Visible = false; //PRJ-492.AS.1.0
            }
            //TM-32.AM.1.0
            field("NS_Segment Name"; "NS_Segment Name")
            {
                ApplicationArea = all;
                Visible = false; //PRJ-492.AS.1.0
            }
            //TM-32.AM.1.0
        }
    }
    actions
    {
        addafter("Related Information")
        {
            action("NS_Get Job Planning Line")
            {
                ApplicationArea = All;
                Caption = 'Get Job &Planning Line';

                trigger OnAction();
                begin
                    //ProjectPro - start
                    NS_GetJobPlanningLines("Sell-to Customer No.");
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        NS_Resource: Record Resource;
        TempOptionLookupBuffer: Record 1670;

        NS_Job: Record Job;
        Text14021101: Label 'No Job Planning lines can be found to bring forward.';
        TypeAsText: Text[30];
        LocationCodeMandatory: Boolean;
        IsCommentLine: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        TotalSalesHeader: Record 36;
        InvDiscAmountEditable: Boolean;
        SalesCalcDiscountByType: Codeunit 56;
        Currency: Record 4;
        ShortcutDimCode: ARRAY[8] OF Code[20];

    //PPDA.1.0 Start
    trigger OnNewRecord(BelowxRec: Boolean);
    var
        SalesHeader: Record 36;
    begin
        //ProjectPro - start
        "NS_Retention Applies" := TRUE;
        IF SalesHeader.GET("Document Type", "Document No.") THEN
            "Job No." := SalesHeader."NS_Job No.";
        //ProjectPro - end
    end;
    //PPDA.1.0 End

    trigger OnOpenPage();
    begin
        Currency.InitRoundingPrecision;
    end;

    trigger OnAfterGetCurrRecord();
    begin
        NS_GetTotalSalesHeader;
        NS_UpdateEditableOnRow;
    end;

    local procedure NS_NoOnAfterValidate();
    begin
        InsertExtendedText(FALSE);
        //ProjectPro - start
        IF Type = Type::Resource THEN BEGIN
            NS_Resource.GET("No.");
            "NS_Job Revenue Category" := NS_Resource."NS_Job Revenue Category";
        END;
        //ProjectPro - end
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;

        NS_SaveAndAutoAsmToOrder;

        IF Reserve = Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            IF ("Outstanding Qty. (Base)" <> 0) AND ("No." <> xRec."No.") THEN BEGIN
                AutoReserve;
                CurrPage.UPDATE(FALSE);
            END;
        END;
    end;

    local procedure NS_SaveAndAutoAsmToOrder();
    begin
        IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
            CurrPage.SAVERECORD;
            AutoAsmToOrder;
            CurrPage.UPDATE(FALSE);
        end;
    end;

    procedure NS_GetJobPlanningLines(CustNo: Code[20]);
    var
        NS_JobPlanningLine: Record "Job Planning Line";
        NS_SalesHeader: Record "Sales Header";
        NS_SalesLine: Record "Sales Line";
        NS_JobNo: Code[20];
        NS_JobTaskNo: Code[35];
        NS_LineNo: Integer;
        NS_GetJobPlanningLine: Page "NS_Get Job Planning Line";
    begin
        //ProjectPro - start
        if "Job No." = '' then begin
            NS_SalesHeader.GET("Document Type", "Document No.");
            NS_SalesHeader.TESTFIELD("NS_Job No.");
            NS_JobNo := NS_SalesHeader."NS_Job No.";
        end else
            NS_JobNo := "Job No.";
        NS_JobPlanningLine.RESET;
        NS_JobPlanningLine.SETRANGE("Job No.", NS_JobNo);
        NS_GetJobPlanningLine.NS_SetGetFrom("Document Type", 1, "Document No.");
        NS_GetJobPlanningLine.SETTABLEVIEW(NS_JobPlanningLine);
        NS_GetJobPlanningLine.NS_Set('', NS_JobNo, '', '', '', 0);
        NS_GetJobPlanningLine.RUNMODAL;
        CLEAR(NS_GetJobPlanningLine);
        //ProjectPro - end
    end;

    local procedure NS_UpdateTypeText();
    VAR
        RecRef: RecordRef;
    BEGIN
        //Create FormatOption fix
        RecRef.GETTABLE(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    LOCAL PROCEDURE SetLocationCodeMandatory();
    VAR
        InventorySetup: Record 313;
    BEGIN
        InventorySetup.GET;
        LocationCodeMandatory := InventorySetup."Location Mandatory" AND (Type = Type::Item);
    END;

    LOCAL PROCEDURE NS_UpdateEditableOnRow();
    VAR
        SalesLine: Record 37;
    BEGIN
        IsCommentLine := NOT HasTypeToFillMandatoryFields;
        IF NOT IsCommentLine THEN
            UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
            UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalSalesHeader."No." <> '' THEN BEGIN
            SalesLine.SETRANGE("Document No.", TotalSalesHeader."No.");
            SalesLine.SETRANGE("Document Type", TotalSalesHeader."Document Type");
            IF NOT SalesLine.ISEMPTY THEN
                InvDiscAmountEditable :=
                  SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    END;

    LOCAL PROCEDURE NS_GetTotalSalesHeader();
    BEGIN
        IF NOT TotalSalesHeader.GET("Document Type", "Document No.") THEN
            CLEAR(TotalSalesHeader);
        IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
            IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;
            END
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate();
    VAR
        UpdateIsDone: Boolean;
    BEGIN
        IF Type = Type::Item THEN
            CASE Reserve OF
                Reserve::Always:
                    BEGIN
                        CurrPage.SAVERECORD;
                        AutoReserve;
                        CurrPage.UPDATE(FALSE);
                        UpdateIsDone := TRUE;
                    END;
                Reserve::Optional:
                    IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
                        CurrPage.SAVERECORD;
                        CurrPage.UPDATE(FALSE);
                        UpdateIsDone := TRUE;
                    END;
            END;

        IF (Type = Type::Item) AND
           (Quantity <> xRec.Quantity) AND
           NOT UpdateIsDone
        THEN
            CurrPage.UPDATE(TRUE);
    END;

    /* Documentation;
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     Gen. Bus. Posting Group
      +     Gen. Prod. Posting Group
      +     PP VAT Base Amount
      +     Retention Applies
      +     Job No.
      +     Job Task No.
      +     Job Cost Category
      +     Job Revenue Category
      +
      +  - Added function(s):
      +     PP_GetJobPlanningLines
      +
      +  - Added global variable(s):
      +     PP_Resource
      +      PP_Job
      +
      +  - Added global text constant(s):
      +      Text14021101
      +
      +  - Modification(s):
      +     - Menus:
      +         NoOnAfterValidate - Get Resourse record if Type is Resourse
      +-SMP
      +  -Recreated fields
      +   -Description
      +   -Cross-Reference No.
      +   -No.
      +   -Type
      +  -Rewritten procedures
      +   -QuantityOnAfterValidate
      +   -GetTotalSalesHeader 
      +   -UpdateEditableOnRow 
      +   -SetLocationCodeMandatory 
      +   -UpdateTypeText 
      +   -NoOnAfterValidate
      +  -Extemted page triggers
      +   -OnOpenPage
      +   -OnAfterGetRecord
      +-----------------------------------------------------------------------------------------------
    */

}

