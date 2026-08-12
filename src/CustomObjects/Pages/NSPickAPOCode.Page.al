page 14021203 "NS_Pick APO Code"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-917.NK.1.0 11Mar2022 Error for Blocked.
    //PRJ-1348.NK.1.0 24May2022 Add Property
    //Caption = 'Pick APO Code'; //PRJ-1348.NK.1.0 26May2022 Block
    Caption = 'Pick Task Codes'; //PRJ-1348.NK.1.0 26May2022
    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            field(ActCd; ActivityCode)
            {
                ApplicationArea = All;
                Caption = 'Activity Code';
                CaptionClass = '50999,0,0'; //PRJ-1348.NK.1.0 24May2022
                ToolTip = 'Specifies the Activity Code';

                trigger OnLookup(VAR Text: Text): Boolean;
                var
                    JobAct: Record "NS_Job Activity";
                    // >> Upgrade
                    IsHandled: Boolean;
                // << Upgrade
                begin
                    JobAct.RESET();
                    // >> Upgrade
                    OnBeforeLookupActcd(JobAct);

                    // << Upgrade
                    if JobTaskType = JobTaskType::Cost then
                        JobAct.SETRANGE(NS_Type, JobAct.NS_Type::Cost)
                    else
                        if JobTaskType = JobTaskType::Price then
                            JobAct.SETRANGE(NS_Type, JobAct.NS_Type::Revenue);
                    // >> Upgrade
                    OnBeforeLookupActcd2(JobAct, JobNo);

                    // << Upgrade
                    if PAGE.RUNMODAL(PAGE::"NS_Activities List", JobAct) = ACTION::LookupOK then begin
                        ActivityCode := JobAct.NS_Code;
                        if JobAct.NS_Type = JobAct.NS_Type::Cost then
                            JobActivity.GET(JobActivity.NS_Type::Cost, ActivityCode)
                        else
                            JobActivity.GET(JobActivity.NS_Type::Revenue, ActivityCode);
                        ActivityDescription := JobActivity.NS_Description;
                        //PRJ-917.NK.1.0 09Mar2022 Start
                        if JobActivity.NS_Blocked then
                            Error('Sorry! This Activity is blocked.');
                        //PRJ-917.NK.1.0 09Mar2022 end
                    end;
                    NS_SetProcessOperation();
                end;

                trigger OnValidate();
                begin
                    NS_GetActivityDescription();
                    NS_SetProcessOperation();
                end;
            }
            field(ActivityDescription; ActivityDescription)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Activity Description';
                Caption = 'Activity Description';
                CaptionClass = '50998,0,0'; //PRJ-1348.NK.1.0 24May2022
            }
            field(ProcCd; ProcessCode)
            {
                ApplicationArea = All;
                Caption = 'Process Code';
                Enabled = ProcCdEnable;
                ToolTip = 'Specifies the Process Code';
                CaptionClass = '50999,1,0'; //PRJ-1348.NK.1.0 24May2022
                trigger OnLookup(VAr Text: Text): Boolean;
                var
                    JobProc: Record "NS_Job Process";
                begin
                    JobProc.RESET();
                    if JobTaskType = JobTaskType::Cost then
                        JobProc.SETRANGE(NS_Type, JobProc.NS_Type::Cost)
                    else
                        if JobTaskType = JobTaskType::Price then
                            JobProc.SETRANGE(NS_Type, JobProc.NS_Type::Revenue);
                    JobProc.SETRANGE("NS_Activity Code", ActivityCode);
                    if PAGE.RUNMODAL(PAGE::"NS_Processes List", JobProc) = ACTION::LookupOK then begin
                        ProcessCode := JobProc.NS_Code;
                        if JobProc.NS_Type = JobProc.NS_Type::Cost then
                            JobProcess.GET(JobProcess.NS_Type::Cost, ActivityCode, ProcessCode)
                        else
                            JobProcess.GET(JobProcess.NS_Type::Revenue, ActivityCode, ProcessCode);
                        ProcessDescription := JobProcess.NS_Description;
                        //PRJ-917.NK.1.0 09Mar2022 Start
                        if JobProcess.NS_Blocked then
                            Error('Sorry! This Process is blocked.');
                        //PRJ-917.NK.1.0 09Mar2022 end
                    end;
                    NS_SetProcessOperation();
                end;

                trigger OnValidate();
                begin
                    NS_GetProcessDescription();
                    NS_SetProcessOperation();
                    NS_ProcessCodeOnAfterValidate();
                end;
            }
            field(ProcessDescription; ProcessDescription)
            {
                ApplicationArea = All;
                Caption = 'Process Description';
                Editable = false;
                ToolTip = 'Specifies the Process Description';
                CaptionClass = '50998,1,0'; //PRJ-1348.NK.1.0 24May2022
            }
            field(OpCd; OperationCode)
            {
                ApplicationArea = All;
                Caption = 'Operation Code';
                Editable = OpCdEditable;
                Enabled = OpCdEnable;
                ToolTip = 'Specifies the Operation Code';
                CaptionClass = '50999,2,0'; //PRJ-1348.NK.1.0 24May2022
                trigger OnLookup(VAr Text: Text): Boolean;
                var
                    JobOper: Record "NS_Job Operation";
                begin
                    JobOper.RESET();
                    if JobTaskType = JobTaskType::Cost then
                        JobOper.SETRANGE(NS_Type, JobOper.NS_Type::Cost)
                    else
                        if JobTaskType = JobTaskType::Price then
                            JobOper.SETRANGE(NS_Type, JobOper.NS_Type::Revenue);
                    JobOper.SETRANGE("NS_Activity Code", ActivityCode);
                    JobOper.SETRANGE("NS_Process Code", ProcessCode);
                    if PAGE.RUNMODAL(PAGE::"NS_Operations List", JobOper) = ACTION::LookupOK then begin
                        OperationCode := JobOper.NS_Code;
                        if JobOper.NS_Type = JobOper.NS_Type::Cost then
                            JobOperation.GET(JobOperation.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode)
                        else
                            JobOperation.GET(JobOperation.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode);
                        OperationDescription := JobOperation.NS_Description;
                        //PRJ-917.NK.1.0 09Mar2022 Start
                        if JobOperation.NS_Blocked then
                            Error('Sorry! This Operation is blocked.');
                        //PRJ-917.NK.1.0 09Mar2022 end

                    end;
                    NS_SetProcessOperation();
                end;

                trigger OnValidate();
                begin
                    NS_GetOperationDescription();
                    NS_SetProcessOperation();
                end;
            }
            field(OperationDescription; OperationDescription)
            {
                ApplicationArea = All;
                Caption = 'Operation Description';
                Editable = false;
                ToolTip = 'Specifies the Operation Description';
                CaptionClass = '50998,2,0'; //PRJ-1348.NK.1.0 24May2022
            }
            //PRJ-688.AM.1.0 Start
            field(SectionCode; SectionCode)
            {
                ApplicationArea = All;
                Caption = 'Section Code';
                Editable = Sectioneditable;
                Enabled = SectionEnable;
                ToolTip = 'Specifies the Section Code';
                CaptionClass = '50999,3,0'; //PRJ-1348.NK.1.0 24May2022
                trigger OnLookup(VAr Text: Text): Boolean;
                var
                    JobSection: Record NS_Sections;
                begin
                    JobSection.RESET();
                    if JobTaskType = JobTaskType::Cost then
                        JobSection.SETRANGE(NS_Type, JobSection.NS_Type::Cost)
                    else
                        if JobTaskType = JobTaskType::Price then
                            JobSection.SETRANGE(NS_Type, JobSection.NS_Type::Revenue);
                    JobSection.SETRANGE("NS_Activity Code", ActivityCode);
                    JobSection.SETRANGE("NS_Process Code", ProcessCode);
                    JobSection.SetRange("NS_Operation Code", OperationCode);
                    if PAGE.RUNMODAL(PAGE::NS_SectionsList, JobSection) = ACTION::LookupOK then begin
                        SectionCode := JobSection.NS_Code;
                        if JobSection.NS_Type = JobSection.NS_Type::Cost then
                            JobSection.GET(JobSection.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode, SectionCode)
                        else
                            JobSection.GET(JobSection.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode, SectionCode);
                        SectionDescription := JobSection.NS_Description;
                        //PRJ-917.NK.1.0 09Mar2022 Start
                        if JobSection.NS_Blocked then
                            Error('Sorry! This Section is blocked.');
                        //PRJ-917.NK.1.0 09Mar2022 end
                    end;
                    NS_SetProcessOperation();
                end;

                trigger OnValidate();
                begin
                    NS_GetSectionDescription();
                    NS_SetProcessOperation();
                end;
            }
            field(SectionDescription; SectionDescription)
            {
                ApplicationArea = All;
                Caption = 'Section Description';
                Editable = false;
                ToolTip = 'Specifies the Section Description';
                CaptionClass = '50998,3,0'; //PRJ-1348.NK.1.0 24May2022
            }
            //PRJ-688.AM.1.0 End
            field(JobTaskNo; JobTaskNo)
            {
                ApplicationArea = All;
                Caption = 'Job Task No.';
                Editable = false;
                ToolTip = 'Specifies the Job Task No.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if ActivityCode > '' then
            ProcCdEnable := true;
        if ProcessCode > '' then
            OpCdEditable := true;
        //PRJ-688.AM.1.0
        if OperationCode > '' then
            Sectioneditable := true;
        //PRJ-688.AM.1.0

    end;

    trigger OnInit();
    begin
        OpCdEnable := true;
        ProcCdEnable := true;
        OpCdEditable := true;
        Sectioneditable := true;//PRJ-688.AM.1.0
        SectionEnable := true;//PRJ-688.AM.1.0
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        NS_SetProcessOperation();
    end;

    trigger OnOpenPage();
    begin
        JobsSetup.GET();
        if JobsSetup."NS_APO Separators" > '' then begin
            Separator1 := COPYSTR(JobsSetup."NS_APO Separators", 1, 1);
            if STRLEN(JobsSetup."NS_APO Separators") > 1 then
                Separator2 := COPYSTR(JobsSetup."NS_APO Separators", 2, 1)
            else
                Separator2 := COPYSTR(JobsSetup."NS_APO Separators", 1, 1);

            //PRJ-688.AM.1.0 Start
            if STRLEN(JobsSetup."NS_APO Separators") > 1 then
                Separator3 := COPYSTR(JobsSetup."NS_APO Separators", 3, 2)
            else
                Separator3 := COPYSTR(JobsSetup."NS_APO Separators", 1, 1);
            //PRJ-688.AM.1.0 End
        end;
        NS_SetProcessOperation();

        NS_GetActivityDescription();
        NS_GetProcessDescription();
        NS_GetOperationDescription();
        NS_GetSectionDescription();//PRJ-688.AM.1.0
    end;

    var
        JobActivity: Record "NS_Job Activity";
        JobProcess: Record "NS_Job Process";
        JobOperation: Record "NS_Job Operation";
        JobSection: Record NS_Sections;//PRJ-688.AM.1.0
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        ActivityCode: Code[10];
        ProcessCode: Code[10];
        OperationCode: Code[10];
        SectionCode: Code[10];//PRJ-688.AM.1.0
        JobTaskNo: Code[35];
        JobNo: Code[20];
        JobTaskType: Option Cost,Price;
        ActivityDescription: Text[100];//PRJ-449.AM.1.0
        ProcessDescription: Text[100];//PRJ-449.AM.1.0
        OperationDescription: Text[100];//PRJ-449.AM.1.0
        SectionDescription: Text[100];//PRJ-688.AM.1.0
        Separator1: Text[1];
        Separator2: Text[1];
        Separator3: Text[1];//PRJ-688.AM.1.0

        [InDataSet]
        OpCdEditable: Boolean;
        [InDataSet]
        ProcCdEnable: Boolean;
        [InDataSet]
        OpCdEnable: Boolean;
        //PRJ-688.AM.1.0
        [InDataSet]
        SectionEnable: Boolean;
        [InDataSet]
        Sectioneditable: Boolean;

    //PRJ-688.AM.1.0

    procedure NS_GetActivityDescription();
    begin
        if ActivityCode > '' then begin
            if JobTaskType = JobTaskType::Cost then
                JobActivity.GET(JobActivity.NS_Type::Cost, ActivityCode)
            else
                if JobTaskType = JobTaskType::Price then
                    JobActivity.GET(JobActivity.NS_Type::Revenue, ActivityCode);
            if not JobActivity.GET(JobActivity.NS_Type::Cost, ActivityCode) then
                JobActivity.GET(JobActivity.NS_Type::Revenue, ActivityCode);
            // >> Upgrade
            OnNS_GetActivityDescription(JobActivity);
            // << Upgrade
            ActivityDescription := JobActivity.NS_Description;
        end else
            ActivityDescription := '';
    end;

    procedure NS_GetProcessDescription();
    begin
        if ProcessCode > '' then begin
            if JobTaskType = JobTaskType::Cost then
                JobProcess.GET(JobProcess.NS_Type::Cost, ActivityCode, ProcessCode)
            else
                if JobTaskType = JobTaskType::Price then
                    JobProcess.GET(JobProcess.NS_Type::Revenue, ActivityCode, ProcessCode);
            if not JobProcess.GET(JobProcess.NS_Type::Cost, ActivityCode, ProcessCode) then
                JobProcess.GET(JobProcess.NS_Type::Revenue, ActivityCode, ProcessCode);
            ProcessDescription := JobProcess.NS_Description;
        end else
            ProcessDescription := '';
    end;

    procedure NS_GetOperationDescription();
    begin
        if OperationCode > '' then begin
            if JobTaskType = JobTaskType::Cost then
                JobOperation.GET(JobOperation.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode)
            else
                if JobTaskType = JobTaskType::Price then
                    JobOperation.GET(JobOperation.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode);
            if not JobOperation.GET(JobOperation.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode) then
                JobOperation.GET(JobOperation.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode);
            OperationDescription := JobOperation.NS_Description;
        end else
            OperationDescription := '';
    end;
    //PRJ-688.AM.1.0 Start
    procedure NS_GetSectionDescription();
    begin
        if SectionCode > '' then begin
            if JobTaskType = JobTaskType::Cost then
                JobSection.GET(JobSection.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode, SectionCode)
            else
                if JobTaskType = JobTaskType::Price then
                    JobSection.GET(JobSection.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode, SectionCode);
            if not JobSection.GET(JobSection.NS_Type::Cost, ActivityCode, ProcessCode, OperationCode, SectionCode) then
                JobSection.GET(JobSection.NS_Type::Revenue, ActivityCode, ProcessCode, OperationCode, SectionCode);
            SectionDescription := JobSection.NS_Description;
        end else
            SectionDescription := '';
    end;
    //PRJ-688.AM.1.0 End

    procedure NS_SetProcessOperation();
    begin
        if ActivityCode = '' then begin
            ActivityDescription := '';
            ProcessCode := '';
        end;

        if ProcessCode = '' then begin
            ProcessDescription := '';
            OperationCode := '';
        end;

        if OperationCode = '' then begin//PRJ-688.AM.1.0
            OperationDescription := '';
            SectionCode := '';//PRJ-688.AM.1.0

        end;//PRJ-688.AM.1.0

        if ProcessCode > '' then
            OpCdEnable := true
        else
            OpCdEnable := false;

        if ActivityCode > '' then
            ProcCdEnable := true
        else
            ProcCdEnable := false;
        //PRJ-688.AM.1.0 Start
        if OperationCode > '' then
            SectionEnable := true
        else
            SectionEnable := false;
        //PRJ-688.AM.1.0 End

        JobTaskNo := ActivityCode;
        if ProcessCode > '' then
            JobTaskNo := JobTaskNo + Separator1 + ProcessCode;
        if OperationCode > '' then
            JobTaskNo := JobTaskNo + Separator2 + OperationCode;
        //PRJ-688.AM.1.0 Start
        if SectionCode > '' then
            JobTaskNo := JobTaskNo + Separator3 + SectionCode;
        //PRJ-688.AM.1.0 End
    end;
    // >> Upgrade
    // procedure NS_SetInput(JobNoIn: Code[20]; JobTaskNoIn: Code[35]; TaskTypeIn: Option Cost,Price);
    procedure NS_SetInput(JobNoIn: Code[20]; JobTaskNoIn: Code[35]; JobAct: Code[20]; TaskTypeIn: Option Cost,Price);
    // << Upgrade
    begin
        JobNo := JobNoIn;
        JobTaskNo := JobTaskNoIn;
        JobTaskType := TaskTypeIn;

        if JobTaskNo > '' then
            Job.NS_JobTaskNoToAPO(JobTaskNo, ActivityCode, ProcessCode, OperationCode, SectionCode)//PRJ-688.AM.1.0
        else begin
            ActivityCode := '';
            ProcessCode := '';
            OperationCode := '';
        end;
        // >> Upgrade
        if JobAct <> '' then
            ActivityCode := JobAct;
        // << Upgrade
    end;

    procedure NS_GetResult(var JobTskNo: Code[35]; var JobTskDesc: Text[100];var JobTskAct: Code[20]): Code[35];//PRJ-449.Am.1.0
    begin
        JobTskNo := JobTaskNo;
        // >> Upgrade
        JobTskAct := ActivityCode;
        // << Upgrade
        if ActivityDescription > '' then
            JobTskDesc := ActivityDescription;

        if ProcessDescription > '' then
            JobTskDesc := ProcessDescription;

        if OperationDescription > '' then
            JobTskDesc := OperationDescription;

        exit;
    end;

    local procedure NS_ProcessCodeOnAfterValidate();
    begin
        NS_SetProcessOperation();
    end;

    local procedure NS_OperationCodeOnAfterInput(var Text: Text[1024]);
    begin
        OperationCode := '';
    end;

    local procedure NS_ActivityCodeOnInputChange(var Text: Text[1024]);
    begin
        ProcessCode := '';
        OperationCode := '';
        NS_SetProcessOperation();
    end;

    local procedure NS_ProcessCodeOnInputChange(var Text: Text[1024]);
    begin
        OperationCode := '';
        NS_SetProcessOperation();
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupActcd(var JobAct: Record "NS_Job Activity")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupActcd2(var JobAct: Record "NS_Job Activity"; var JobNo: Code[20])
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnNS_GetActivityDescription(var JobActivity: Record "NS_Job Activity")
    begin

    end;

    // << Upgrade
}

