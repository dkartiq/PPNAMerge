codeunit 14021124 "NS_UpgradeDataCodeunit"
{  //PE-317 AT.1.0 25June2024 Start
    Permissions = tabledata "Job Task" = rimd;
    trigger OnRun()
    begin
    End;

    procedure UpdateJobTaskLine()
    var

        jtasklines: Record "Job Task";//PRJ-1264.AS.1.0
        NJob: Record job;//PRJ-1264.AS.1.0
        Activity: Code[10];//PRJ-1264.AS.1.0
        NProcess: Code[10];//PRJ-1264.AS.1.0
        Operation: Code[10];//PRJ-1264.AS.1.0
        Section1: Code[10];//PRJ-1264.AS.1.0
        JobActivity: Record "NS_Job Activity";//PRJ-1264.AS.1.0
        JobProcess: Record "NS_Job Process";//PRJ-1264.AS.1.0
        JobOperation: Record "NS_Job Operation";//PRJ-1264.AS.1.0
        JobSection: Record NS_Sections;//PRJ-1264.AS.1.0
    begin
        //PRJ-1264.AS.1.0 start
        jtasklines.Reset();
        if jtasklines.FindSet() then
            repeat
                // Clear(Activity);
                // Clear(NProcess);
                // Clear(Operation);
                // Clear(Section);
                NJob.NS_JobTaskNoToAPo(jtasklines."Job Task No.", Activity, NProcess, Operation, Section1);//PRJ-1264.AS.1.0            
                IF JobActivity.GET(JobActivity.NS_Type::Cost, Activity) THEN;
                IF JobProcess.GET(JobProcess.NS_Type::Cost, Activity, NProcess) THEN;
                IF JobOperation.get(JobOperation.NS_Type::Cost, Activity, NProcess, Operation) THEN;
                IF JobSection.get(JobSection.NS_Type::Cost, Activity, NProcess, Operation, Section1) THEN;

                if NProcess <> '' then BEGIN
                    NProcess := NProcess;
                end else begin
                    NProcess := '';

                end;
                if Operation <> '' then BEGIN
                    Operation := Operation;
                end else BEGIN
                    Operation := '';
                end;

                if Section1 <> '' then BEGIN
                    Section1 := Section1;
                end else BEGIN
                    Section1 := '';
                end;

                jtasklines.NS_Act := Activity;
                jtasklines.NS_Proc := NProcess;
                jtasklines.NS_Opr := Operation;
                jtasklines.NS_Sec := Section1;
                jtasklines.Modify();
            until jtasklines.Next() = 0;
        Commit();
        //PRJ-1264.AS.1.0 end
        //PRJ-1420.NK.1.0 30May2022 Start

    end;
}