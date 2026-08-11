//PRJ-797.MS.1.0 create new Enum
enum 14021107 NSManagerJobStatus
{ //',Estimating,Quoting,Verbal App,Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed'
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; " ") { }
    value(1; Estimating) { }
    value(2; Quoting) { }
    value(3; "Verbal App") { }
    // >> Upgrade
    // value(4; Approval) { }
    value(4; "Budget Review") { }
    //value(5; Planning) { }
    value(5; Manufacturing) { }
    //value(6; Running) { }
    value(6; Handover) { }
    //value(7; Hold) { }
    value(7; "Site Works") { }
    value(8; Completed) { }
    //value(9; Billed) { }
    // << Upgrade
    value(9; "Closed - no more Cost") { }
    value(10; Paid) { }
    value(11; Closed) { }


}