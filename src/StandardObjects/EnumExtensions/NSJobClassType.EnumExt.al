//PRJ-1677.AS.1.0 create new Enum
enum 14021109 NSJobClassTypeEnum
{ //' ,Master Job,SubJob,Change Order,Extra Work,Proposed,Template,Work Order'
  //" ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template,"Work Order";
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; " ") { }
    value(1; "Master Job") { }
    value(2; SubJob) { }
    value(3; "Change Order") { }
    value(4; "Extra Work") { }
    value(5; Proposed) { }
    value(6; Template) { }
    value(7; "Work Order") { }
    value(8; "Change Request") { }//PRJ-1677.AS.2.0
}