enumextension 14021106 NS_JobPlanningLineType extends "Job Planning Line Type"
{
    value(14021100; "NS_Resource (Group)")
    {
        Caption = 'Resource (Group) Obsolete';   //PE-306.JS.1.0 06JUN2024
        //PRJCTPR-322.AT START
        ObsoleteState = Pending;
        ObsoleteReason = 'Not use in standard BC';
        ObsoleteTag = 'Resource (Group) will obselete in Projectpro upcoming release 25.0.XX.XXXX';
        //PRJCTPR-322.AT END
    }
}