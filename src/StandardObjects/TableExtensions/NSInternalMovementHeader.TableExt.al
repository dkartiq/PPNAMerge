tableextension 14021235 NS_InternalMovementHeader extends "Internal Movement Header"
{
    // version NAVW111.00.00.20783,PPNA11.00
    //PRJ-903.JS.1.0  10Sep2021 | Correct code for warehouse user not exist error

    fields
    {
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                //ProjectPro - start
                IF USERID <> '' THEN BEGIN
                    FilterGroup(2);
                    SETRANGE("Location Code", "Location Code");
                    FilterGroup(0)
                END;
                //ProjectPro - end

            end;
        }
    }

    var
        Text000: Label 'You must first set up user %1 as a warehouse employee.';

    procedure NS_OpenInternalMovementHeaderEvent(var InternalMovHdrRec: Record "Internal Movement Header"; var WhseEmployee: Record "Warehouse Employee"; var InternalMovementHeader: Record "Internal Movement Header")
    var
        CurrentLocationCode: Code[10];
        WmsManagement: Codeunit "WMS Management";
    begin
        with InternalMovHdrRec do begin
            //ProjectPro - start          
            IF USERID <> '' THEN BEGIN
                //PRJ-903.JS.1.0  10Sep2021
                IF InternalMovementHeader."Location Code" = '' then begin
                    WhseEmployee.SETRANGE("Location Code", WmsManagement.GetDefaultLocation());
                    WhseEmployee.SETRANGE("User ID", USERID);
                end else
                    WhseEmployee.SETRANGE("User ID", USERID);
                //PRJ-903.JS.1.0  10Sep2021    
                IF WhseEmployee.ISEMPTY THEN
                    ERROR(Text000, USERID);
                //ProjectPro - end

                WhseEmployee.SETRANGE("Location Code", InternalMovementHeader."Location Code");
                IF NOT WhseEmployee.ISEMPTY THEN
                    CurrentLocationCode := InternalMovementHeader."Location Code"
                ELSE
                    //ProjectPro - start
                    //CurrentLocationCode := GetDefaultOrFirstAllowedLocation;
                    CurrentLocationCode := WmsManagement.GetDefaultLocation;
                //ProjectPro - end

                InternalMovementHeader.FilterGroup(2);
                InternalMovementHeader.SETRANGE("Location Code", CurrentLocationCode);
                InternalMovementHeader.FilterGroup(0);
            END else begin
                //Remove of Assigned filter by stdandard code
                InternalMovementHeader.FilterGroup(2);
                InternalMovementHeader.SETRANGE("Location Code");
                InternalMovementHeader.FilterGroup(0)
            end;
        end;
    end;

    procedure LookupInternalMovementHeaderEvent(VAR InternalMovementHeader: Record "Internal Movement Header")
    begin
        //ProjectPro - start
        IF USERID <> '' THEN BEGIN
            //ProjectPro - end
            InternalMovementHeader.FILTERGROUP := 2;
            InternalMovementHeader.SETRANGE("Location Code");
        end;
        IF PAGE.RUNMODAL(0, InternalMovementHeader) = ACTION::LookupOK THEN;
        //ProjectPro - start
        IF USERID <> '' THEN BEGIN
            //ProjectPro - end
            InternalMovementHeader.SETRANGE("Location Code", InternalMovementHeader."Location Code");
            InternalMovementHeader.FILTERGROUP := 0;
        end;
    end;

    procedure GetDefaultOrFirstAllowedLocation() LocationCode: Code[10]
    var
        WhseEmployeesatLocations: Query "Whse. Employees at Locations";
        NoAllowedLocationsErr: label 'Internal movement is not possible at any locations where you are a warehouse employee.';
    begin
        WhseEmployeesatLocations.SETRANGE(User_ID, USERID);
        WhseEmployeesatLocations.SETRANGE(Bin_Mandatory, TRUE);
        WhseEmployeesatLocations.SETRANGE(Directed_Put_away_and_Pick, FALSE);

        WhseEmployeesatLocations.SETRANGE(Default, TRUE);
        IF GetFirstLocationCodeFromLocationsofWhseEmployee(LocationCode, WhseEmployeesatLocations) THEN
            EXIT(LocationCode);

        WhseEmployeesatLocations.SETRANGE(Default);
        IF GetFirstLocationCodeFromLocationsofWhseEmployee(LocationCode, WhseEmployeesatLocations) THEN
            EXIT(LocationCode);

        ERROR(NoAllowedLocationsErr);
    end;

    procedure GetFirstLocationCodeFromLocationsofWhseEmployee(VAR LocationCode: Code[10]; VAR WhseEmployeesatLocations: Query "Whse. Employees at Locations"): Boolean
    begin
        WhseEmployeesatLocations.TOPNUMBEROFROWS(1);
        IF WhseEmployeesatLocations.OPEN THEN
            IF WhseEmployeesatLocations.READ THEN BEGIN
                LocationCode := WhseEmployeesatLocations.Code;
                WhseEmployeesatLocations.CLOSE;
                EXIT(TRUE);
            END;

        EXIT(FALSE);

    end;
}

