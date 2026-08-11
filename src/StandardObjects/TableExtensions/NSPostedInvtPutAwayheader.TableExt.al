tableextension 14021234 NS_PostedInvtPutAwayheader extends "Posted Invt. Put-away Header"
{
    // version NAVW111.00.00.20783,PPNA11.00

    trigger OnBeforeDelete()
    begin

        if not Location.GET("Location Code") then begin
            Location.init();
            Location.Code := "Location Code";
            Location."Bin Mandatory" := false;
            Location.Insert(false);
            IsLocationInserted := true;
        end
        else begin
            NS_LocationBinMandatory := Location."Bin Mandatory";
            Location."Bin Mandatory" := false;
            Location.Modify(false);
            IsLocationInserted := false;
        end;
    end;

    trigger OnAfterDelete()
    begin
        if (IsLocationInserted) then
            Location.Delete()
        else begin
            Location."Bin Mandatory" := NS_LocationBinMandatory;
            Location.Modify(false)
        end;
    end;

    var

        Location: Record Location;
        NS_LocationBinMandatory: Boolean;
        IsLocationInserted: Boolean;
}

//   +---------------------------------------------------------------------------------------------
//   +ProjectPro
//   +  - Added field(s):
//   +
//   +  - Added function(s):
//   +
//   +  - Added global variable(s):
//   +
//   +  - Added global text constant(s):
//   +
//   +  - Modification(s):
//   +     - OnDelete - Removed call to CheckLocation
//   +-----------------------------------------------------------------------------------------------