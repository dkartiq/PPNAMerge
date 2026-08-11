codeunit 14021100 "NS_ProjectPro Table Events"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-445.AS.1.0 18NOV2020 Added & commented code


    trigger OnRun();
    begin
    end;

    local procedure "---TAB1014---"();
    begin
    end;

    [EventSubscriber(ObjectType::Table, 1014, 'OnAfterInsertEvent', '', false, false)]
    local procedure NS_JobGLAccountPriceOnAfterInsert(var Rec: Record "Job G/L Account Price"; RunTrigger: Boolean);
    begin
        if not RunTrigger then
            exit;

        NS_UpdateWorkOrder(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 1014, 'OnAfterModifyEvent', '', false, false)]
    local procedure NS_JobGLAccountPriceOnAfterModify(var Rec: Record "Job G/L Account Price"; var xRec: Record "Job G/L Account Price"; RunTrigger: Boolean);
    begin
        if not RunTrigger then
            exit;

        NS_UpdateWorkOrder(Rec);
    end;

    local procedure NS_UpdateWorkOrder(PassGLPrice: Record "Job G/L Account Price");
    var
        WOGLPrice: Record "Job G/L Account Price";
        WOJob: Record Job;
    begin
        WOJob.RESET();
        WOJob.SETRANGE("NS_Sub-Level to Job No.", PassGLPrice."Job No.");
        //Filter to exclude work orders that are approved
        if WOJob.FINDSET() then
            repeat
                // if WOGLPrice.GET(WOJob."No.", PassGLPrice."Job Task No.", PassGLPrice."G/L Account No.",//PRJ-445.AS.1.0 18NOV2020 Commented
                //                     PassGLPrice."NS_Line No.", PassGLPrice."Currency Code") then begin//PRJ-445.AS.1.0 18NOV2020 Commented
                //PRJ-445.AS.1.0 18NOV2020 - start
                WOGLPrice.Reset;
                WOGLPrice.SetRange("Job No.", WOJob."No.");
                WOGLPrice.SetRange("G/L Account No.", PassGLPrice."G/L Account No.");
                WOGLPrice.SetRange("NS_Line No.", PassGLPrice."NS_Line No.");
                WOGLPrice.SetRange("Currency Code", PassGLPrice."Currency Code");
                if WOGLPrice.FindFirst then begin
                    //PRJ-445.AS.1.0 18NOV2020 - end
                    WOGLPrice."Unit Price" := PassGLPrice."Unit Price";
                    WOGLPrice."Unit Cost Factor" := PassGLPrice."Unit Cost Factor";
                    WOGLPrice."Line Discount %" := PassGLPrice."Line Discount %";
                    WOGLPrice."Unit Cost" := PassGLPrice."Unit Cost";
                    WOGLPrice.VALIDATE("NS_Markup %", PassGLPrice."NS_Markup %");
                    WOGLPrice.MODIFY(false);
                end else begin
                    WOGLPrice.RESET;
                    WOGLPrice := PassGLPrice;
                    WOGLPrice."Job No." := WOJob."No.";
                    WOGLPrice.INSERT(false);
                end;
            until WOJob.NEXT = 0;
    end;

    local procedure "---TAB5200---"();
    begin
        /**** Employee ****/

    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterDeleteEvent', '', false, false)]
    local procedure NS_EmployeeOnAfterDelete(var Rec: Record Employee; RunTrigger: Boolean);
    var
        EmployeeWageRate: Record "NS_Employee Wage Rate";
        EmployeeBurdenDetail: Record "NS_Employee Burden Detail";
        HRSetup: Record "Human Resources Setup";
    begin
        if not RunTrigger then
            exit;

        if HRSetup.GET and (HRSetup."NS_Advanced Job Labor isActive") then begin
            EmployeeWageRate.RESET;
            EmployeeWageRate.SETRANGE("NS_Employee No.", Rec."No.");
            EmployeeWageRate.DELETEALL(false);

            EmployeeBurdenDetail.RESET;
            EmployeeBurdenDetail.SETRANGE("NS_Employee No.", Rec."No.");
            EmployeeBurdenDetail.DELETEALL(false);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterValidateEvent', 'Resource No.', false, false)]
    local procedure NS_EmployeeOnAfterValidateResourceNo(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer);
    var
        HRSetup: Record "Human Resources Setup";
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        Text14021100: Label 'The %1 checkmark has been cleared on %2 %3.';
        Text14021101: Label '%1 %2 has the %3 field checked.\Removing the %4 from this entry will cause %5 to be cleared.\Do you want to continue?';
        Text14021102: Label '%1 %2 cannot be removed until all time sheet lines have been processed for this resource.';
        Text14021103: Label '%1 %2 is already assigned to employee %3.\A resource can only be assigned to one employee.';
        Res: Record Resource;
    begin
        if HumanResSetup.GET and (HumanResSetup."NS_Advanced Job Labor isActive") then begin
            if Rec."Resource No." <> xRec."Resource No." then begin

                if Rec."Resource No." <> '' then begin
                    Employee.RESET;
                    Employee.SETCURRENTKEY("Resource No.");
                    Employee.SETRANGE("Resource No.", Rec."Resource No.");
                    if Employee.FINDFIRST then
                        ERROR(Text14021103, Rec.FIELDCAPTION("Resource No."), Rec."Resource No.", Employee."No.");
                end;

                if xRec."Resource No." <> '' then begin
                    if Res.GET(xRec."Resource No.") then begin
                        if NS_ExistUnprocessedTimeSheets(Res."No.") then
                            ERROR(Text14021102, Rec.FIELDCAPTION("Resource No."), Res."No.");

                        if Res."Use Time Sheet" then
                            if CONFIRM(Text14021101, false, Rec.FIELDCAPTION("Resource No."), Res."No.", Res.FIELDCAPTION("Use Time Sheet"), Rec.FIELDCAPTION("Resource No."),
                                        Res.FIELDCAPTION("Use Time Sheet")) then begin
                                Res."Use Time Sheet" := false;
                                Res.MODIFY(false);
                                MESSAGE(Text14021100, Res.FIELDCAPTION("Use Time Sheet"), Rec.FIELDCAPTION("Resource No."), Res."No.");
                            end;
                    end;
                end;
            end;
        end;
    end;

    procedure NS_ExistUnprocessedTimeSheets(NS_ResourceNo: Code[20]): Boolean;
    var
        NS_TimeSheetHeader: Record "Time Sheet Header";
        NS_TimeSheetLine: Record "Time Sheet Line";
    begin
        NS_TimeSheetHeader.RESET;
        NS_TimeSheetHeader.SETCURRENTKEY("Resource No.");
        NS_TimeSheetHeader.SETRANGE("Resource No.", NS_ResourceNo);
        if NS_TimeSheetHeader.FINDSET then
            repeat
                NS_TimeSheetLine.SETRANGE("Time Sheet No.", NS_TimeSheetHeader."No.");
                NS_TimeSheetLine.SETRANGE(Posted, false);
                if not NS_TimeSheetLine.ISEMPTY then
                    exit(true);
            until NS_TimeSheetHeader.NEXT = 0;

        exit(false);
    end;

    local procedure "---TAB10140---"();
    begin
        /**** Deposit Header ****/

    end;

    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Table, 10140, 'OnAfterInsertEvent', '', false, false)]
    // local procedure NS_DepositHeaderOnAfterInsert(var Rec: Record "Deposit Header"; RunTrigger: Boolean);
    // var
    //     SalesReceivablesSetup: Record "Sales & Receivables Setup";
    // begin
    //     if not RunTrigger then
    //         exit;

    //     SalesReceivablesSetup.GET();
    //     Rec."NS_Retention Ledger Code" := SalesReceivablesSetup."NS_Normal Customer Ledger No.";
    //     Rec.MODIFY(false);
    // end;
    //PPDA.1.0 End
}

