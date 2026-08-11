//PRJ-797.MS.1.0 create new Enum
enum 14021107 NSManagerJobStatus
{ //',Estimating,Quoting,Verbal App,Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed'
    Extensible = true;
    AssignmentCompatibility = true;
    value(0; " ") { }
    value(1; Estimating) { }
    value(2; Quoting) { }
    value(3; "Verbal App") { }
    value(4; Approval)
    {
        Caption = 'Approved'; //PE-193.PS.1.0 29Nov2023
    }
    value(5; Planning) { }
    value(6; Running) { }
    value(7; Hold) { }
    value(8; Completed) { }
    value(9; Billed) { }
    value(10; Paid) { }
    value(11; Closed) { }


}