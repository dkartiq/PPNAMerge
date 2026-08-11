codeunit 14021401 "NS_Job Quote Price Mgt."
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        DiagnosticsSetting: Option " ",On,Off;
        FilterCustPriceGroup: Code[20];
        FilterDim1Code: Code[20];
        FilterDim2Code: Code[20];
        FilterEntityNo: Code[20];
        FilterItemCatCode: Code[20];
        FilterItemDiscGroup: Code[20];
        FilterMfgCode: Code[10];
        FilterNo: Code[20];
        FilterPostCode: Code[20];
        FilterProdGrpCode: Code[10];
        FilterResGroup: Code[20];
        FilterServiceOrderType: Code[10];
        FilterServicePriceGroup: Code[10];
        FilterServiceZone: Code[10];
        FilterUnitOfMeasure: Code[10];
        FilterVariant: Code[10];
        FilterMinimumQuantity: Decimal;
        FilterEntityType: Integer;
        FilterType: Integer;
        FilterWorkType: Code[10];
        // FilterCustPostGroup: Code[10];//PRJ-621.N.S.1.0 
        FilterCustPostGroup: Code[20];//PRJ-621.N.S.1.0
        FilterServContractNo: Code[20];
        FilterCountyName: Code[30];
        RecordsFoundForFilters: Label 'Records found: %1 for filters %2';
        PriceReturned: Label 'Price returned: %1';
        FindSalesLinePriceText: Label 'FindSalesLinePrice %1 %2 %3 called by FIELDNO(%4) Dim1 %5 Dim2 %6 Qty %7';
        SplitLine: Label '-------------------------------------------------------------------------------';

    procedure NS_CalcBestPrice(var _PriceEntry: Record "NS_Job Quote Price Entry"; _UnitPrice: Decimal; var _PriceFound: Boolean): Decimal;
    var
        _TempBuf: Record "BOM Buffer" temporary;
        _Price: Decimal;
        _EntryNo: Integer;
    begin
        // prepare temporary placeholder for prices

        CLEAR(_TempBuf);
        _TempBuf.DELETEALL;

        // filter Price Entry table

        with _PriceEntry do begin
            SETFILTER("NS_Shortcut Dimension 1 Code", '%1', '');
            if FilterDim1Code <> '' then
                SETFILTER("NS_Shortcut Dimension 1 Code", '%1|%2', '', FilterDim1Code);
            SETFILTER("NS_Shortcut Dimension 2 Code", '%1', '');
            if FilterDim2Code <> '' then
                SETFILTER("NS_Shortcut Dimension 2 Code", '%1|%2', '', FilterDim2Code);
            SETRANGE("NS_Entity Type", FilterEntityType);
            SETFILTER("NS_Entity No.", '%1', '');
            if FilterEntityNo <> '' then
                SETFILTER("NS_Entity No.", '%1|%2', '', FilterEntityNo);
            SETRANGE(NS_Type, FilterType);
            SETFILTER("NS_No.", '%1', '');
            if FilterNo <> '' then
                SETFILTER("NS_No.", '%1|%2', '', FilterNo);
            SETFILTER("NS_Service Order Type Code", '%1', '');
            if FilterServiceOrderType <> '' then
                SETFILTER("NS_Service Order Type Code", '%1|%2', '', FilterServiceOrderType);
            SETFILTER("NS_Service Price Group Code", '%1', '');
            if FilterServicePriceGroup <> '' then
                SETFILTER("NS_Service Price Group Code", '%1|%2', '', FilterServicePriceGroup);
            SETFILTER("NS_Service Zone Code", '%1', '');
            if FilterServiceZone <> '' then
                SETFILTER("NS_Service Zone Code", '%1|%2', '', FilterServiceZone);
            if FilterCountyName <> '' then
                SETFILTER("NS_County Name", '%1|%2', '', FilterCountyName);
            if FilterPostCode <> '' then
                SETFILTER("NS_Post Code", '%1|%2', '', FilterPostCode);
            SETFILTER("NS_Minimum Quantity", '0..');
            if FilterMinimumQuantity <> 0 then
                SETFILTER("NS_Minimum Quantity", '..%1', FilterMinimumQuantity);
            SETFILTER("NS_Variant Code", '%1', '');
            if FilterVariant <> '' then
                SETFILTER("NS_Variant Code", '%1|%2', '', FilterVariant);
            SETFILTER("NS_Unit of Measure Code", '%1', '');
            if FilterUnitOfMeasure <> '' then
                SETFILTER("NS_Unit of Measure Code", '%1|%2', '', FilterUnitOfMeasure);
            SETFILTER("NS_Effective Date", '%1|..%2', 0D, WORKDATE);
            SETFILTER("NS_Expiration Date", '%1|%2..', 0D, WORKDATE);
            if FilterWorkType <> '' then
                SETFILTER("NS_Work Type", '%1|%2', '', FilterWorkType);
            if FilterItemCatCode <> '' then
                SETFILTER("NS_Item Category Code", '%1|%2', '', FilterItemCatCode);
            if FilterMfgCode <> '' then
                SETFILTER("NS_Manufacturer Code", '%1|%2', '', FilterMfgCode);
            if FilterProdGrpCode <> '' then
                SETFILTER("NS_Product Group Code", '%1|%2', '', FilterProdGrpCode);
        end;

        // add one temp record for every matching price entry found
        //   searching for initial, filtered entity type & entity no & type & no.

        if _PriceEntry.FINDSET(false) then
            repeat
                _EntryNo += 1;
                _TempBuf.INIT;
                _TempBuf."Entry No." := _EntryNo;
                _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                _TempBuf.INSERT;
            until _PriceEntry.NEXT = 0;

        NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));

        // widen our search; attempt to find price entries by item discount group if initial filtered type was item
        //   still same, initial, filtered entity type & entity no.

        if FilterType = _PriceEntry.NS_Type::Item then
            if FilterItemDiscGroup <> '' then
                with _PriceEntry do begin
                    SETRANGE(NS_Type, NS_Type::"Item Discount Group");
                    SETRANGE("NS_No.", FilterItemDiscGroup);
                    if FINDSET(false) then
                        repeat
                            _EntryNo += 1;
                            _TempBuf.INIT;
                            _TempBuf."Entry No." := _EntryNo;
                            _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                            _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                            _TempBuf.INSERT;
                        until NEXT = 0;
                    NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                    SETRANGE(NS_Type, FilterType);
                    SETRANGE("NS_No.", FilterNo);
                end;

        // attempt to find price entries by resource group if initial filtered type was resource

        if FilterType = _PriceEntry.NS_Type::Resource then
            if FilterResGroup <> '' then
                with _PriceEntry do begin
                    SETRANGE(NS_Type, NS_Type::"Resource Group");
                    SETRANGE("NS_No.", FilterResGroup);
                    if FINDSET(false) then
                        repeat
                            _EntryNo += 1;
                            _TempBuf.INIT;
                            _TempBuf."Entry No." := _EntryNo;
                            _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                            _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                            _TempBuf.INSERT;
                        until NEXT = 0;
                    NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                    SETRANGE(NS_Type, FilterType);
                    SETRANGE("NS_No.", FilterNo);
                end;

        // CUSTOMER RELATED SUBFILTERS
        if FilterEntityType = _PriceEntry."NS_Entity Type"::Customer then
            //
            // widen our search; attempt to find price entries where entity type = customer price group
            //
            if FilterCustPriceGroup <> '' then
                //
                // here we are finding specific items or resources for the customer discount group
                //
                with _PriceEntry do begin
                    SETRANGE("NS_Entity Type", "NS_Entity Type"::"Customer Price Group");
                    SETRANGE("NS_Entity No.", FilterCustPriceGroup);
                    if FINDSET(false) then
                        repeat
                            _EntryNo += 1;
                            _TempBuf.INIT;
                            _TempBuf."Entry No." := _EntryNo;
                            _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                            _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                            _TempBuf.INSERT;
                        until NEXT = 0;
                    NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                    // still searching by entity type = customer discount group ... if initial type was item, search by item discount group
                    if FilterType = _PriceEntry.NS_Type::Item then
                        if FilterItemDiscGroup <> '' then
                            with _PriceEntry do begin
                                SETRANGE(NS_Type, NS_Type::"Item Discount Group");
                                SETRANGE("NS_No.", FilterItemDiscGroup);
                                if FINDSET(false) then
                                    repeat
                                        _EntryNo += 1;
                                        _TempBuf.INIT;
                                        _TempBuf."Entry No." := _EntryNo;
                                        _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                        _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                        _TempBuf.INSERT;
                                    until NEXT = 0;
                            end;
                    NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                    SETRANGE(NS_Type, FilterType);
                    SETRANGE("NS_No.", FilterNo);
                    // still searching by entity type = customer discount group ... if initial type was resource, search by resource group
                    if FilterType = _PriceEntry.NS_Type::Resource then
                        if FilterResGroup <> '' then
                            with _PriceEntry do begin
                                SETRANGE(NS_Type, NS_Type::"Resource Group");
                                SETRANGE("NS_No.", FilterResGroup);
                                if FINDSET(false) then
                                    repeat
                                        _EntryNo += 1;
                                        _TempBuf.INIT;
                                        _TempBuf."Entry No." := _EntryNo;
                                        _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                        _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                        _TempBuf.INSERT;
                                    until NEXT = 0;
                            end;
                    NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                    SETRANGE(NS_Type, FilterType);
                    SETRANGE("NS_No.", FilterNo);
                end;

        // attempt to find price entries by CUSTOMER POSTING GROUP if applicable
        if FilterCustPostGroup <> '' then
            // here we are finding specific items or resources for the customer posting group
            with _PriceEntry do begin
                SETRANGE("NS_Entity Type", "NS_Entity Type"::"Customer Posting Group");
                SETRANGE("NS_Entity No.", FilterCustPostGroup);
                if FINDSET(false) then
                    repeat
                        _EntryNo += 1;
                        _TempBuf.INIT;
                        _TempBuf."Entry No." := _EntryNo;
                        _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                        _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                        _TempBuf.INSERT;
                    until NEXT = 0;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                // still searching by entity type = customer posting group ... if initial type was item, search by item discount group
                if FilterType = _PriceEntry.NS_Type::Item then
                    if FilterItemDiscGroup <> '' then
                        with _PriceEntry do begin
                            SETRANGE(NS_Type, NS_Type::"Item Discount Group");
                            SETRANGE("NS_No.", FilterItemDiscGroup);
                            if FINDSET(false) then
                                repeat
                                    _EntryNo += 1;
                                    _TempBuf.INIT;
                                    _TempBuf."Entry No." := _EntryNo;
                                    _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                    _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                    _TempBuf.INSERT;
                                until NEXT = 0;
                        end;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                SETRANGE(NS_Type, FilterType);
                SETRANGE("NS_No.", FilterNo);
                // still searching by entity type = customer posting group ... if initial type was resource, search by resource group
                if FilterType = _PriceEntry.NS_Type::Resource then
                    if FilterResGroup <> '' then
                        with _PriceEntry do begin
                            SETRANGE(NS_Type, NS_Type::"Resource Group");
                            SETRANGE("NS_No.", FilterResGroup);
                            if FINDSET(false) then
                                repeat
                                    _EntryNo += 1;
                                    _TempBuf.INIT;
                                    _TempBuf."Entry No." := _EntryNo;
                                    _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                    _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                    _TempBuf.INSERT;
                                until NEXT = 0;
                        end;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                SETRANGE(NS_Type, FilterType);
                SETRANGE("NS_No.", FilterNo);
            end;

        // attempt to find price entries where entity type = service contract no.

        if FilterServContractNo <> '' then
            // here we are finding specific items or resources for the service contract no.
            with _PriceEntry do begin
                SETRANGE("NS_Entity Type", "NS_Entity Type"::"Service Contract No.");
                SETRANGE("NS_Entity No.", FilterServContractNo);
                if FINDSET(false) then
                    repeat
                        _EntryNo += 1;
                        _TempBuf.INIT;
                        _TempBuf."Entry No." := _EntryNo;
                        _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                        _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                        _TempBuf.INSERT;
                    until NEXT = 0;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                // still searching by entity type = service contract no. ... if initial type was item, search by item discount group
                if FilterType = _PriceEntry.NS_Type::Item then
                    if FilterItemDiscGroup <> '' then
                        with _PriceEntry do begin
                            SETRANGE(NS_Type, NS_Type::"Item Discount Group");
                            SETRANGE("NS_No.", FilterItemDiscGroup);
                            if FINDSET(false) then
                                repeat
                                    _EntryNo += 1;
                                    _TempBuf.INIT;
                                    _TempBuf."Entry No." := _EntryNo;
                                    _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                    _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                    _TempBuf.INSERT;
                                until NEXT = 0;
                        end;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                SETRANGE(NS_Type, FilterType);
                SETRANGE("NS_No.", FilterNo);
                // still searching by entity type = service contract no. ... if initial type was resource, search by resource group
                if FilterType = _PriceEntry.NS_Type::Resource then
                    if FilterResGroup <> '' then
                        with _PriceEntry do begin
                            SETRANGE(NS_Type, NS_Type::"Resource Group");
                            SETRANGE("NS_No.", FilterResGroup);
                            if FINDSET(false) then
                                repeat
                                    _EntryNo += 1;
                                    _TempBuf.INIT;
                                    _TempBuf."Entry No." := _EntryNo;
                                    _TempBuf."Total Cost" := NS_CalcUnitPrice(_PriceEntry, _UnitPrice);
                                    _TempBuf."Low-Level Code" := _PriceEntry."NS_Entry No.";
                                    _TempBuf.INSERT;
                                until NEXT = 0;
                        end;
                NS_Diagnostics(STRSUBSTNO(RecordsFoundForFilters, _PriceEntry.COUNT, _PriceEntry.GETFILTERS));
                SETRANGE(NS_Type, FilterType);
                SETRANGE("NS_No.", FilterNo);
            end;

        _TempBuf.SETCURRENTKEY("Total Cost");
        _PriceFound := _TempBuf.FINDFIRST;
        if _PriceFound then begin
            NS_Diagnostics(STRSUBSTNO(PriceReturned, _TempBuf."Total Cost"));
            exit(_TempBuf."Total Cost");
        end else
            exit(0);
    end;

    procedure NS_CalcUnitPrice(_PriceEntry: Record "NS_Job Quote Price Entry"; _UnitPrice: Decimal): Decimal;
    begin
        with _PriceEntry do
            case NS_Method of
                NS_Method::Fixed:
                    exit("NS_Method Value");
                NS_Method::Discount:
                    exit(_UnitPrice - (("NS_Method Value" / 100) * _UnitPrice));
                NS_Method::Markup:
                    exit((_UnitPrice * (1 - ("NS_Vendor Discount" / 100))) / (1 - ("NS_Method Value" / 100)));
            end;
    end;

    procedure NS_FindSalesLinePrice(_SalesHeader: Record "Sales Header"; _SalesLine: Record "Sales Line"; _CalledByFieldNo: Integer; var _PriceFound: Boolean): Decimal;
    var
        _Customer: Record Customer;
        _Item: Record Item;
        _PriceEntry: Record "NS_Job Quote Price Entry";
        _Resource: Record Resource;
        _UnitPrice: Decimal;
    begin
        NS_Diagnostics(STRSUBSTNO(FindSalesLinePriceText
                              , FORMAT(_SalesLine."Document Type")
                              , _SalesLine."Document No."
                              , FORMAT(_SalesLine."Line No.")
                              , FORMAT(_CalledByFieldNo)
                              , _SalesLine."Shortcut Dimension 1 Code"
                              , _SalesLine."Shortcut Dimension 2 Code"
                              , FORMAT(_SalesLine.Quantity)));

        FilterDim1Code := _SalesLine."Shortcut Dimension 1 Code";
        FilterDim2Code := _SalesLine."Shortcut Dimension 2 Code";

        FilterEntityType := _PriceEntry."NS_Entity Type"::Customer;
        FilterEntityNo := _SalesHeader."Bill-to Customer No.";

        if _Customer.GET(_SalesHeader."Sell-to Customer No.") then
            FilterCountyName := _Customer."NS_County Name";

        FilterPostCode := _Customer."Post Code";

        if _Customer.GET(_SalesHeader."Bill-to Customer No.") then
            FilterCustPriceGroup := _Customer."Customer Price Group";

        FilterCustPostGroup := _SalesHeader."Customer Posting Group";

        FilterType := _SalesLine.Type.AsInteger();
        FilterNo := _SalesLine."No.";

        case _SalesLine.Type of
            _SalesLine.Type::Item:
                if _Item.GET(_SalesLine."No.") then begin
                    FilterItemDiscGroup := _Item."Item Disc. Group";
                    _UnitPrice := _Item."Unit Price";
                end;
            _SalesLine.Type::Resource:
                if _Resource.GET(_SalesLine."No.") then begin
                    FilterResGroup := _Resource."Resource Group No.";
                    FilterWorkType := _SalesLine."Work Type Code";
                    _UnitPrice := _Resource."Unit Price";
                end;
            else
                exit(0);
        end;

        FilterMinimumQuantity := _SalesLine.Quantity;
        FilterUnitOfMeasure := _SalesLine."Unit of Measure Code";
        FilterVariant := _SalesLine."Variant Code";

        FilterItemCatCode := _SalesLine."Item Category Code";
        FilterMfgCode := _SalesLine."NS_Manufacturer Code";
        //SPLN. Obsolete field FilterProdGrpCode := _SalesLine."Product Group Code";

        exit(NS_CalcBestPrice(_PriceEntry, _UnitPrice, _PriceFound));
    end;

    procedure NS_FindServLinePrice(_ServHeader: Record "Service Header"; _ServLine: Record "Service Line"; _CalledByFieldNo: Integer; var _PriceFound: Boolean): Decimal;
    var
        _Customer: Record Customer;
        _Item: Record Item;
        _PriceEntry: Record "NS_Job Quote Price Entry";
        _Resource: Record Resource;
        _ServCost: Record "Service Cost";
        _UnitPrice: Decimal;
    begin
        NS_Diagnostics(STRSUBSTNO(FindSalesLinePriceText
                              , FORMAT(_ServLine."Document Type")
                              , _ServLine."Document No."
                              , FORMAT(_ServLine."Line No.")
                              , FORMAT(_CalledByFieldNo)
                              , _ServLine."Shortcut Dimension 1 Code"
                              , _ServLine."Shortcut Dimension 2 Code"
                              , FORMAT(_ServLine.Quantity)));

        FilterDim1Code := _ServLine."Shortcut Dimension 1 Code";
        FilterDim2Code := _ServLine."Shortcut Dimension 2 Code";

        FilterEntityType := _PriceEntry."NS_Entity Type"::Customer;
        FilterEntityNo := _ServHeader."Bill-to Customer No.";

        if _Customer.GET(_ServHeader."Customer No.") then
            FilterCountyName := _Customer."NS_County Name";

        FilterPostCode := _Customer."Post Code";

        if _Customer.GET(_ServHeader."Bill-to Customer No.") then
            FilterCustPriceGroup := _Customer."Customer Price Group";

        FilterCustPostGroup := _ServHeader."Customer Posting Group";
        FilterServContractNo := _ServHeader."Contract No.";

        FilterType := _ServLine.Type.AsInteger();
        FilterNo := _ServLine."No.";

        case _ServLine.Type of
            _ServLine.Type::Item:
                begin
                    FilterType := _PriceEntry.NS_Type::Item;
                    if _Item.GET(_ServLine."No.") then begin
                        FilterItemDiscGroup := _Item."Item Disc. Group";
                        _UnitPrice := _Item."Unit Price";
                    end;
                end;
            _ServLine.Type::Resource:
                begin
                    FilterType := _PriceEntry.NS_Type::Resource;
                    if _Resource.GET(_ServLine."No.") then begin
                        FilterResGroup := _Resource."Resource Group No.";
                        FilterWorkType := _ServLine."Work Type Code";
                        _UnitPrice := _Resource."Unit Price";
                    end;
                end;
            _ServLine.Type::Cost:
                begin
                    FilterType := _PriceEntry.NS_Type::Cost;
                    if _ServCost.GET(_ServLine."No.") then
                        _UnitPrice := _ServCost."Default Unit Price";
                end;
            else
                exit(0);
        end;

        FilterServiceOrderType := _ServHeader."Service Order Type";
        FilterServicePriceGroup := _ServLine."Service Price Group Code";
        FilterServiceZone := _ServHeader."Service Zone Code";

        FilterMinimumQuantity := _ServLine.Quantity;
        FilterUnitOfMeasure := _ServLine."Unit of Measure Code";
        FilterVariant := _ServLine."Variant Code";

        FilterItemCatCode := _ServLine."Item Category Code";
        //SPLN Obsolete field. FilterProdGrpCode := _ServLine."Product Group Code";

        exit(NS_CalcBestPrice(_PriceEntry, _UnitPrice, _PriceFound));
    end;

    procedure NS_InitializeEntityFields(var _PriceEntry: Record "NS_Job Quote Price Entry");
    begin
        _PriceEntry."NS_Entity Name" := '';
    end;

    procedure NS_InitializeNoFields(var _PriceEntry: Record "NS_Job Quote Price Entry");
    begin
        _PriceEntry."NS_No. 2" := '';
        _PriceEntry.NS_Description := '';
        _PriceEntry."NS_Unit of Measure Code" := '';
        _PriceEntry."NS_Variant Code" := '';
        _PriceEntry."NS_Minimum Quantity" := 1;
    end;

    procedure NS_LookupPriceOnItemVariant(_SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary) _VariantPriceFound: Boolean;
    var
        _ItemVariant: Record "Item Variant";
    begin
        if _SalesLine."Variant Code" = '' then
            exit;

        _ItemVariant.SETRANGE("Item No.", _SalesLine."No.");
        _ItemVariant.SETRANGE(Code, _SalesLine."Variant Code");
        if _ItemVariant.FINDFIRST then
            if (_ItemVariant."NS_Unit Price" <> 0) and (_ItemVariant."NS_Unit Price" < TempSalesPrice."Unit Price") then begin
                _VariantPriceFound := true;
                TempSalesPrice."Unit Price" := _ItemVariant."NS_Unit Price";
            end;
    end;

    procedure NS_OnValidateEntityNo(var _PriceEntry: Record "NS_Job Quote Price Entry");
    var
        _Customer: Record Customer;
        _CustomerPriceGroup: Record "Customer Price Group";
        CustomerPostingGroup: Record "Customer Posting Group";
        ServiceContract: Record "Service Contract Header";
    begin
        NS_InitializeEntityFields(_PriceEntry);

        if _PriceEntry."NS_Entity No." = '' then
            exit;

        with _PriceEntry do
            case "NS_Entity Type" of
                "NS_Entity Type"::Customer:
                    if _Customer.GET("NS_Entity No.") then
                        "NS_Entity Name" := _Customer.Name;
                "NS_Entity Type"::"Customer Price Group":
                    if _CustomerPriceGroup.GET("NS_Entity No.") then
                        "NS_Entity Name" := _CustomerPriceGroup.Description;
                "NS_Entity Type"::"Customer Posting Group":
                    if CustomerPostingGroup.GET("NS_Entity No.") then
                        "NS_Entity Name" := CustomerPostingGroup.Code;
                "NS_Entity Type"::"Service Contract No.":
                    begin
                        ServiceContract.RESET;
                        ServiceContract.SETRANGE("Contract Type", ServiceContract."Contract Type"::Contract);
                        ServiceContract.SETRANGE("Contract No.", "NS_Entity No.");
                        if ServiceContract.FINDFIRST then
                            "NS_Entity Name" := ServiceContract.Description;
                    end;
            end;
    end;

    procedure NS_OnValidateNo(var _PriceEntry: Record "NS_Job Quote Price Entry");
    var
        _Item: Record Item;
        _ItemDiscountGroup: Record "Item Discount Group";
        _Resource: Record Resource;
        _ResourceGroup: Record "Resource Group";
        _ServCost: Record "Service Cost";
    begin
        NS_InitializeNoFields(_PriceEntry);

        if _PriceEntry."NS_No." = '' then
            exit;

        with _PriceEntry do
            case NS_Type of
                NS_Type::Item:                           // option value 2
                    if _Item.GET("NS_No.") then begin
                        "NS_No. 2" := _Item."No. 2";
                        NS_Description := _Item.Description;
                        "NS_Unit of Measure Code" := _Item."Base Unit of Measure";
                    end;
                NS_Type::Resource:                       // 3
                    if _Resource.GET("NS_No.") then begin
                        NS_Description := _Resource.Name;
                        "NS_Unit of Measure Code" := _Resource."Base Unit of Measure";
                    end;
                NS_Type::Cost:                           // 4
                    if _ServCost.GET("NS_No.") then begin
                        NS_Description := _ServCost.Description;
                        "NS_Unit of Measure Code" := _ServCost."Unit of Measure Code";
                    end;
                NS_Type::"Item Discount Group":          // 17
                    if _ItemDiscountGroup.GET("NS_No.") then
                        NS_Description := _ItemDiscountGroup.Description;
                NS_Type::"Resource Group":               // 18
                    if _ResourceGroup.GET("NS_No.") then
                        NS_Description := _ResourceGroup.Name;
            end;
    end;

    procedure NS_SetFilterCountyName(_FilterCountyName: Code[30]);
    begin
        FilterCountyName := _FilterCountyName;
    end;

    procedure NS_SetFilterCustPriceGroup(_Code: Code[20]);
    begin
        FilterCustPriceGroup := _Code;
    end;

    procedure NS_SetFilterCustPostGroup(_Code: Code[20]);
    begin
        FilterCustPostGroup := _Code;
    end;

    procedure NS_SetFilterDim1Code(_Code: Code[20]);
    begin
        FilterDim1Code := _Code;
    end;

    procedure NS_SetFilterDim2Code(_Code: Code[20]);
    begin
        FilterDim2Code := _Code;
    end;

    procedure NS_SetFilterEntityNo(_Code: Code[20]);
    begin
        FilterEntityNo := _Code;
    end;

    procedure NS_SetFilterItemDiscGroup(_Code: Code[20]);
    begin
        FilterItemDiscGroup := _Code;
    end;

    procedure NS_SetFilterItemCatCode(_FilterItemCatCode: Code[10]);
    begin
        FilterItemCatCode := _FilterItemCatCode;
    end;

    procedure NS_SetFilterMfgCode(_FilterMfgCode: Code[10]);
    begin
        FilterMfgCode := _FilterMfgCode;
    end;

    procedure NS_SetFilterNo(_Code: Code[20]);
    begin
        FilterNo := _Code;
    end;

    procedure NS_SetFilterPostCode(_FilterPostCode: Code[20]);
    begin
        FilterPostCode := _FilterPostCode;
    end;

    procedure NS_SetFilterProdGrpCode(_FilterProdGrpCode: Code[10]);
    begin
        FilterProdGrpCode := _FilterProdGrpCode;
    end;

    procedure NS_SetFilterResGroup(_Code: Code[20]);
    begin
        FilterResGroup := _Code;
    end;

    procedure NS_SetFilterServiceOrderType(_Code: Code[10]);
    begin
        FilterServiceOrderType := _Code;
    end;

    procedure NS_SetFilterServContractNo(_Code: Code[20]);
    begin
        FilterServContractNo := _Code;
    end;

    procedure NS_SetFilterServicePriceGroup(_Code: Code[10]);
    begin
        FilterServicePriceGroup := _Code;
    end;

    procedure NS_SetFilterServiceZone(_Code: Code[10]);
    begin
        FilterServiceZone := _Code;
    end;

    procedure NS_SetFilterUnitOfMeasure(_Code: Code[10]);
    begin
        FilterUnitOfMeasure := _Code;
    end;

    procedure NS_SetFilterMinimumQuantity(_Decimal: Decimal);
    begin
        FilterMinimumQuantity := _Decimal;
    end;

    procedure NS_SetFilterEntityType(_Integer: Integer);
    begin
        FilterEntityType := _Integer;
    end;

    procedure NS_SetFilterType(_Integer: Integer);
    begin
        FilterType := _Integer;
    end;

    procedure NS_SetFilterVariant(_FilterVariant: Code[10]);
    begin
        FilterVariant := _FilterVariant;
    end;

    procedure NS_SetFilterWorkType(_Code: Code[10]);
    begin
        FilterWorkType := _Code;
    end;

    procedure NS_Diagnostics(_Text: Text);
    var
        _UserSetup: Record "User Setup";
        _WriteHeader: Boolean;
        _File: File;
        _Filename: Label 'c:\temp\PricingDiagnostics.txt';
        _k: Integer;
        _m: Integer;
        _TempStr: Text[1024];
    begin
        /*IF DiagnosticsSetting = DiagnosticsSetting::" " THEN
          IF NOT _UserSetup.GET(USERID) THEN
            DiagnosticsSetting := DiagnosticsSetting::Off
          ELSE
          IF _UserSetup."Pricing Diagnostics" THEN BEGIN
            DiagnosticsSetting := DiagnosticsSetting::On;
            _WriteHeader := TRUE;
          END ELSE
            DiagnosticsSetting := DiagnosticsSetting::Off;
        
        IF DiagnosticsSetting = DiagnosticsSetting::Off THEN
          EXIT;
        
        _File.WRITEMODE(TRUE);
        _File.TEXTMODE(TRUE);
        CASE EXISTS(_Filename) OF
          FALSE:
            IF NOT _File.CREATE(_Filename) THEN BEGIN
              DiagnosticsSetting := DiagnosticsSetting::Off;
              EXIT;
            END;
          TRUE:
            IF NOT _File.OPEN(_Filename) THEN BEGIN
              DiagnosticsSetting := DiagnosticsSetting::Off;
              EXIT;
            END ELSE
              _File.SEEK(_File.LEN);
        END;
        IF _WriteHeader THEN BEGIN
          _File.WRITE(SplitLine);
          _File.WRITE(STRSUBSTNO('%1 %2',USERID,FORMAT(CURRENTDATETIME)));
        END;
        FOR _k := 1 TO ROUND(STRLEN(_Text) / 1024,1,'>') DO BEGIN
          _TempStr := COPYSTR(_Text,_m + 1,1024);
          _File.WRITE(_TempStr);
          _m += 1024;
        END;
        _File.CLOSE;*/

    end;
}

