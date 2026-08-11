report 14021205 "NS_Calculate Plan - Req. Wksh."
{
    //a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added field(s):
    // +
    // +
    // +  - Added function(s):
    // +     FilterToJobItems
    // +
    // +  - Added global variable(s):
    // +     JobNoFilter
    // +     UseJobDemandOnly
    // +     CurrentDocumentNo
    // +
    // +  - Modification(s):
    // +     - Modified OnAfterGetRecord to call SetParm.
    // +     - Modified "Item - OnPreDataItem" to call FilterToJobItems.
    // +     - Modified SetTemplAndWorksheet to assign CurrentDocumentNo.
    // +------------------------------------------------------------

    Caption = 'Calculate Plan - Req. Wksh.';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Jobs;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Low-Level Code")
                                WHERE(Type = CONST(Inventory));

            RequestFilterFields = "No.", "Search Description", "Location Filter";

            trigger OnAfterGetRecord()
            begin
                IF Counter MOD 5 = 0 THEN
                    Window.UPDATE(1, "No.");
                Counter := Counter + 1;

                IF SkipPlanningForItemOnReqWksh(Item) THEN
                    CurrReport.SKIP;

                PlanningAssignment.SETRANGE("Item No.", "No.");

                ReqLine.LOCKTABLE;
                ActionMessageEntry.LOCKTABLE;

                PurchReqLine.SETRANGE("No.", "No.");
                PurchReqLine.MODIFYALL("Accept Action Message", FALSE);
                PurchReqLine.DELETEALL(TRUE);

                ReqLineExtern.SETRANGE(Type, ReqLine.Type::Item);
                ReqLineExtern.SETRANGE("No.", "No.");
                IF ReqLineExtern.FIND('-') THEN
                    REPEAT
                        ReqLineExtern.DELETE(TRUE);
                    UNTIL ReqLineExtern.NEXT = 0;
                // >> Upgrade
                //InvtProfileOffsetting.NS_SetParm(UseForecast, ExcludeForecastBefore, CurrWorksheetType, '');
                InvtProfileOffsetting.NS_SetParm(UseForecast, ExcludeForecastBefore, CurrWorksheetType, JobNoFilter);
                // << Upgrade
                InvtProfileOffsetting.NS_CalculatePlanFromWorksheet(
                  Item,
                  MfgSetup,
                  CurrTemplateName,
                  CurrWorksheetName,
                  FromDate,
                  ToDate,
                  TRUE,
                  //ProjectPro - start
                  //RespectPlanningParm);
                  RespectPlanningParm,
                  UseJobDemandOnly,
                  JobNoFilter,
                  CurrentDocumentNo);
                //ProjectPro - end

                IF PlanningAssignment.FIND('-') THEN
                    REPEAT
                        IF PlanningAssignment."Latest Date" <= ToDate THEN BEGIN
                            PlanningAssignment.Inactive := TRUE;
                            PlanningAssignment.MODIFY;
                        END;
                    UNTIL PlanningAssignment.NEXT = 0;

                COMMIT;
            end;

            trigger OnPreDataItem()
            begin
                SKU.SETCURRENTKEY("Item No.");
                COPYFILTER("Variant Filter", SKU."Variant Code");
                COPYFILTER("Location Filter", SKU."Location Code");

                COPYFILTER("Variant Filter", PlanningAssignment."Variant Code");
                COPYFILTER("Location Filter", PlanningAssignment."Location Code");
                PlanningAssignment.SETRANGE(Inactive, FALSE);
                PlanningAssignment.SETRANGE("Net Change Planning", TRUE);

                ReqLineExtern.SETCURRENTKEY(Type, "No.", "Variant Code", "Location Code");
                COPYFILTER("Variant Filter", ReqLineExtern."Variant Code");
                COPYFILTER("Location Filter", ReqLineExtern."Location Code");
                // >> Upgrade
                ReqLineExtern.SetFilter("NS_Job No.", JobNoFilter); //FDD
                // << Upgrade

                PurchReqLine.SETCURRENTKEY(
                  Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date");
                PurchReqLine.SETRANGE(Type, PurchReqLine.Type::Item);
                COPYFILTER("Variant Filter", PurchReqLine."Variant Code");
                COPYFILTER("Location Filter", PurchReqLine."Location Code");
                PurchReqLine.SETFILTER("Worksheet Template Name", ReqWkshTemplateFilter);
                PurchReqLine.SETFILTER("Journal Batch Name", ReqWkshFilter);
                // >> Upgrade
                PurchReqLine.SetFilter("NS_Job No.", JobNoFilter); // FDD
                                                                   // << Upgrade
                                                                   //ProjectPro  - start
                IF UseJobDemandOnly THEN
                    FilterToJobItems(Item);
                //ProjectPro  - end
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(NS_Options)
                {
                    Caption = 'Options';
                    field(NS_StartingDate; FromDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date to use for new orders. This date is used to evaluate the inventory.';
                    }
                    field(NS_EndingDate; ToDate)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date where the planning period ends. Demand is not included beyond this date.';
                    }
                    field(NS_UseForecast; UseForecast)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Use Forecast';
                        TableRelation = "Production Forecast Name".Name;
                        ToolTip = 'Specifies a forecast that should be included as demand when running the planning batch job.';
                    }
                    field(NS_ExcludeForecastBefore; ExcludeForecastBefore)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Exclude Forecast Before';
                        ToolTip = 'Specifies how much of the selected forecast to include, by entering a date before which forecast demand is not included.';
                    }
                    field(NS_RespectPlanningParm; RespectPlanningParm)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Respect Planning Parameters for Supply Triggered by Safety Stock';
                        ToolTip = 'Specifies that planning lines triggered by safety stock will respect the following planning parameters: Reorder Point, Reorder Quantity, Reorder Point, and Maximum Inventory in addition to all order modifiers. If you do not select this check box, planning lines triggered by safety stock will only cover the exact demand quantity.';
                    }
                    field(NS_JobNoFilter; JobNoFilter)
                    {
                        Caption = 'Job No. Filter';

                        ToolTip = 'Job No. Filter';
                        TableRelation = Job;
                        ApplicationArea = all;
                        // >> Upgrade
                        trigger OnValidate()
                        var
                            RequisitionLine: Record "Requisition Line";
                        begin
                            //FDD109 Start
                            RequisitionLine.SetFilter("NS_Job No.", JobNoFilter);
                            if not RequisitionLine.IsEmpty then
                                Message(Text50000);
                            //FDD109 End
                        end;
                        // << Upgrade
                    }
                    field(NS_UseJobDemandOnly; UseJobDemandOnly)
                    {
                        Caption = 'Use Job Demand Only';

                        ToolTip = 'Use Job Demand Only';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MfgSetup.GET;
            UseForecast := MfgSetup."Current Production Forecast";

            OnAfterOnOpenPage;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ProductionForecastEntry: Record "Production Forecast Entry";
    begin
        Counter := 0;
        IF FromDate = 0D THEN
            ERROR(Text002);
        IF ToDate = 0D THEN
            ERROR(Text003);
        PeriodLength := ToDate - FromDate + 1;
        IF PeriodLength <= 0 THEN
            ERROR(Text004);

        IF (Item.GETFILTER("Variant Filter") <> '') AND
           (MfgSetup."Current Production Forecast" <> '')
        THEN BEGIN
            ProductionForecastEntry.SETRANGE("Production Forecast Name", MfgSetup."Current Production Forecast");
            Item.COPYFILTER("No.", ProductionForecastEntry."Item No.");
            IF MfgSetup."Use Forecast on Locations" THEN
                Item.COPYFILTER("Location Filter", ProductionForecastEntry."Location Code");
            IF NOT ProductionForecastEntry.ISEMPTY THEN
                ERROR(Text005);
        END;

        ReqLine.SETRANGE("Worksheet Template Name", CurrTemplateName);
        ReqLine.SETRANGE("Journal Batch Name", CurrWorksheetName);

        Window.OPEN(
          Text006 +
          Text007);
    end;

    var

        ReqLine: Record "Requisition Line";
        ActionMessageEntry: Record "Action Message Entry";
        ReqLineExtern: Record "Requisition Line";
        PurchReqLine: Record "Requisition Line";
        SKU: Record "Stockkeeping Unit";
        PlanningAssignment: Record "Planning Assignment";
        MfgSetup: Record "Manufacturing Setup";
        InvtProfileOffsetting: Codeunit "NS_Invent. Profile Offsetting";
        Window: Dialog;
        CurrWorksheetType: Option Requisition,Planning;
        Text002: Label 'Enter a starting date.';
        Text003: Label 'Enter an ending date.';
        Text004: Label 'The ending date must not be before the order date.';
        Text005: Label 'You must not use a variant filter when calculating MPS from a forecast.';
        Text006: Label 'Calculating the plan...\\';
        Text007: Label 'Item No.  #1##################';
        PeriodLength: Integer;
        CurrTemplateName: Code[10];
        CurrWorksheetName: Code[10];
        FromDate: Date;
        ToDate: Date;
        ReqWkshTemplateFilter: Code[50];
        ReqWkshFilter: Code[50];
        Counter: Integer;
        UseForecast: Code[10];
        ExcludeForecastBefore: Date;
        RespectPlanningParm: Boolean;
        JobNoFilter: Code[20];
        UseJobDemandOnly: Boolean;
        CurrentDocumentNo: Code[20];
        // >> Upgrade
        Text50000: label 'There are Items in Requisition Worksheets for this Job Filter. Items cannot be duplicated and existing lines will be deleted. Ensure you apply the correct Item Filters to avoid deleting Items incorrectly.;ENA=There are Items in Requisition Worksheets for this Job Filter. Items cannot be duplicated and existing lines will be deleted. Ensure you apply the correct Item Filters to avoid deleting Items incorrectly.';

    // << Upgrade

    [Scope('Cloud')]
    procedure SetTemplAndWorksheet(TemplateName: Code[10]; WorksheetName: Code[10]; DocumentNo: Code[20])
    begin
        CurrTemplateName := TemplateName;
        CurrWorksheetName := WorksheetName;
        //ProjectPro - start
        CurrentDocumentNo := DocumentNo;
        //ProjectPro - end
    end;

    [Scope('Cloud')]
    procedure InitializeRequest(StartDate: Date; EndDate: Date)
    begin
        FromDate := StartDate;
        ToDate := EndDate;
    end;

    local procedure SkipPlanningForItemOnReqWksh(Item: Record Item): Boolean
    var
        SkipPlanning: Boolean;
    begin
        WITH Item DO
            IF (CurrWorksheetType = CurrWorksheetType::Requisition) AND
               ("Replenishment System" = "Replenishment System"::Purchase) AND
               ("Reordering Policy" <> "Reordering Policy"::" ")
            THEN
                EXIT(FALSE);

        WITH SKU DO BEGIN
            SETRANGE("Item No.", Item."No.");
            IF FIND('-') THEN
                REPEAT
                    IF (CurrWorksheetType = CurrWorksheetType::Requisition) AND
                       ("Replenishment System" IN ["Replenishment System"::Purchase,
                                                   "Replenishment System"::Transfer]) AND
                       ("Reordering Policy" <> "Reordering Policy"::" ")
                    THEN
                        EXIT(FALSE);
                UNTIL NEXT = 0;
        END;

        SkipPlanning := TRUE;
        OnAfterSkipPlanningForItemOnReqWksh(Item, SkipPlanning);
        EXIT(SkipPlanning);
    end;

    local procedure FilterToJobItems(var lItem: Record Item)
    var
        "Job Planning Lines": Record "Job Planning Line";
        JobMatPlan: Record "NS_Job Material Planning";
    begin
        //ProjectPro - start
        JobMatPlan.RESET;
        JobMatPlan.SETCURRENTKEY("NS_Worksheet Job No.", "NS_Line No.");
        IF JobNoFilter <> '' THEN
            JobMatPlan.SETRANGE("NS_Worksheet Job No.", JobNoFilter);
        JobMatPlan.SETFILTER("NS_Bal. Req", '>%1', 0);
        JobMatPlan.SETRANGE(NS_Type, JobMatPlan.NS_Type::Item);
        IF JobMatPlan.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF lItem.GET(JobMatPlan."NS_Part No.") THEN BEGIN
                    lItem.MARK(TRUE);
                    lItem.MODIFY;
                END;
            UNTIL JobMatPlan.NEXT = 0;
        lItem.MARKEDONLY(TRUE);
        //ProjectPro - end
    end;

    [IntegrationEvent(false, False)]
    local procedure OnAfterOnOpenPage()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSkipPlanningForItemOnReqWksh(Item: Record Item; var SkipPlanning: Boolean)
    begin
    end;
}

