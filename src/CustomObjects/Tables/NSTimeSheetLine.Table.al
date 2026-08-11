table 14021317 "NS_TimeSheetLineCustom"
{
    //PRJ-772.AS.1.0 12July2021 New table
    //PRJ-841.JS.1.0 16Aug2021 | Added new fields
    //PRJ-842.JS.1.0 20Aug2021 | add new field
    //PRJ-924.JS.1.0 17Sep2021 | Add new field
    //PRJ-659.RM.1.0 06-OCT-2021  | Updated caption of Table
    //PRJ-1074.AS.1.0 28DEC2021 : Obselete the old field "NS_Resource Name" and added "NS_Resource Name New" in place of that for all codes
    //PRJ-1144.JS.1.0 31JAN2022 | Add fields
    //PRJ-1281.RM.1.0 18April2022 | Changed caption of the field
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
    //PE-156.HS.1.0 8September2023| Changed caption 
    Caption = 'Time Sheet Line';  //PRJ-659.RM.1.0 06-OCT-2021 //PE-156.HS.1.0 8September2023
    fields
    {
        field(1; "NS_TimeSheetNo."; Code[20])
        {
            Caption = 'Time Sheet No.';
            NotBlank = true;
            DataClassification = CustomerContent;
            Editable = false;  //PRJ-1144.JS.1.0
        }
        field(2; "NS_LineNo."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Editable = false;  //PRJ-1144.JS.1.0
        }

        field(3; NS_Description; Text[100])
        {
            Caption = 'Description';//PRJ-841.JS.1.0 Caption change
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin

            end;
        }
        field(4; "NS_Job No."; code[20])
        {
            Caption = 'Job No.';
            Description = 'Specifies Job No.';
            TableRelation = Job."No.";
            DataClassification = CustomerContent;
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            var
                //PE-152.JS.1.0 21aug2023 - Start
                NSJobRec: record Job;
                NSJobCrews: record "NS_Job Crews";
                NSCrewLines: record "NS_Crew Line";
                NSCrewtimeSheetHdr: record NS_TimesheetHdrCustom;
                jbrec2: Record job;//PE-211.AS
                NSNSHRSetup: Record "Human Resources Setup";  //PE-274.JS.1.0 12APR2024
                NSNoSeriesMgt: codeunit NoSeriesManagement; //PE-274.JS.1.0 12APR2024
            //PE-152.JS.1.0 21aug2023 - end
            begin
                if NSNSHRSetup.get() then;  //PE-274.JS.1.0 12APR2024
                Rec.testfield(NS_Status, Rec.NS_Status::Open);

                //PE-211.AS start
                if Rec."NS_Job No." <> '' then
                    if jbrec2.get(Rec."NS_Job No.") then
                        Rec."NS_Field Manager" := jbrec2."NS_Field Manager";
                //PE-211.AS end

                //PE-152.JS.1.0 21aug2023 - start
                if ("NS_Job No." <> '') and ("NS_Crew code" = '') and ("NS_Add New Line") then begin
                    if "NS_Add New Line" = true then begin
                        NSJobCrews.Reset();
                        NSJobCrews.setrange("NS_Job No.", rec."NS_Job No.");
                        NSJobCrews.setrange("NS_Default Crew", true);
                        if NSJobCrews.FindFirst() then begin
                            "NS_Crew code" := NSJobCrews."NS_Crew Code";
                            NSCrewLines.Reset();
                            NSCrewLines.SetRange(NS_Code, NSJobCrews."NS_Crew Code");
                            NSCrewLines.setrange("NS_Lead Person", true);
                            if NSCrewLines.FindFirst then begin
                                "NS_Lead Person" := NSCrewLines."NS_Resource No.";
                                if NSCrewtimeSheetHdr.get("NS_TimeSheetNo.") then begin
                                    if NSCrewtimeSheetHdr."NS_Crew code" = '' then begin
                                        NSCrewtimeSheetHdr."NS_Crew code" := NSJobCrews."NS_Crew Code";
                                        NSCrewtimeSheetHdr.Modify();
                                    end;
                                end;
                            end;

                        end else
                            error('Please define default crew code on job No. %1', "NS_Job No.")
                    end;
                    //PE-274.JS.1.0 12APR2024 - Start
                end else begin
                    if rec."NS_Job No." <> '' then begin
                        NSJobCrews.Reset();
                        NSJobCrews.setrange("NS_Job No.", rec."NS_Job No.");
                        NSJobCrews.setrange("NS_Default Crew", true);
                        if NSJobCrews.FindFirst() then begin
                            "NS_Crew code" := NSJobCrews."NS_Crew Code";
                            NSCrewLines.Reset();
                            NSCrewLines.SetRange(NS_Code, NSJobCrews."NS_Crew Code");
                            NSCrewLines.setrange("NS_Lead Person", true);
                            if NSCrewLines.FindFirst then begin
                                "NS_Lead Person" := NSCrewLines."NS_Resource No.";
                            end;
                        end;
                        rec."NS_Time Sheet Owner User ID" := UserId;
                        rec."NS_Time Sheet Approver User ID" := UserId;
                        rec."NS_Unique Line ID" := NSNoSeriesMgt.GetNextNo(NSNSHRSetup."NS_Timesheet Unique Line Nos.", Today, true);
                        if NSCrewtimeSheetHdr.get("NS_TimeSheetNo.") then begin
                            rec.NS_TimeSheetCrewWorkDays := NSCrewtimeSheetHdr.NS_TimeSheetCrewWorkDays;
                        end;
                        rec.Modify();
                    end;
                end;
                //PE-274.JS.1.0 12APR2024 - end
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(5; "NS_Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            Description = 'Specifies Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("NS_Job No."), "Job Task Type" = Const(Posting));
            DataClassification = CustomerContent;
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(6; "NS_Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'Specifies Resource No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ResourceRec: Record Resource;
                NS_Employee: Record Employee;  //PRJCTPR-2.RM.1.0 13Dec2022
                NSJobResourcePrice: record "Job Resource Price";  //PE-152.JS.1.0 21Aug2023
                NSResourceSkillClass: record NS_ResourceSkillClass; //PE-152.JS.1.0 21Aug2023
                HumanResSetup: Record "Human Resources Setup";
                ResRec: Record Resource;
            begin
                if HumanResSetup.Get() then;   //PRJCTPR-337.JS.1.0 13MAR0224 line added
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
                if ResourceRec.Get("NS_Resource No.") then;    //PE-274.JS.1.0 02APR2024
                "NS_CTS Resource Group No." := ResourceRec."Resource Group No.";  //PE-274.JS.1.0 02APR2024
                                                                                  // if ResourceRec.Get("NS_Resource No.") then
                                                                                  // "NS_Resource Name" := ResourceRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Commented code for old field "NS_Resource Name"
                "NS_Resource Name New" := ResourceRec.Name;//PRJ-1074.AS.1.0 28DEC2021 Add New code for new field "NS_Resource Name New"
                                                           //PRJCTPR-2.RM.1.0 13Dec2022 start
                NS_Employee.RESET();
                NS_Employee.SETCURRENTKEY("Resource No.");
                NS_Employee.SETRANGE("Resource No.", Rec."NS_Resource No."); //PRJ-1135.NK.1.0
                IF NS_Employee.FINDFIRST() THEN
                    "NS_Union Code" := NS_Employee."Union Code"
                ELSE
                    "NS_Union Code" := '';
                //PRJCTPR-2.RM.1.0 13Dec2022 end
                //PE-152.JS.1.0 21Aug2023 - Start
                if ("NS_Resource No." <> '') and ("NS_Add New Line" = true) then begin
                    //PE-274.JS.1.0 11APR2024- Start
                    // if "NS_Job Task No." <> '' then begin
                    //     NSJobResourcePrice.Reset();
                    //     NSJobResourcePrice.setrange("Job No.", "NS_Job No.");
                    //     NSJobResourcePrice.setrange(Code, "NS_Resource No.");
                    //     NSJobResourcePrice.setrange("Job Task No.", "NS_Job Task No.");
                    //     if NSJobResourcePrice.FindFirst() then
                    //         "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                    // end;
                    // if "NS_Skill Code New" = '' then begin
                    //     NSJobResourcePrice.Reset();
                    //     NSJobResourcePrice.setrange("Job No.", "NS_Job No.");
                    //     NSJobResourcePrice.setrange(Code, "NS_Resource No.");
                    //     if NSJobResourcePrice.FindFirst() then
                    //         "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                    // end;
                    // if "NS_Skill Code New" = '' then begin
                    //     NSResourceSkillClass.Reset();
                    //     NSResourceSkillClass.setrange("NS_Resource No.", "NS_Resource No.");
                    //     NSResourceSkillClass.setrange(NS_Default, true);
                    //     if NSResourceSkillClass.FindFirst then
                    //         rec."NS_Skill Code New" := NSResourceSkillClass."NS_Skill Class Code";
                    // end;
                    //if "NS_Skill Code New" = '' then //PRJCTPR-337.JS.1.0 13MAR0224 line commented
                    //  error('Please define resource default skill class code'); //PRJCTPR-337.JS.1.0 13MAR0224 line commented
                    NSJobResourcePrice.Reset();
                    NSJobResourcePrice.SetRange(Type, NSJobResourcePrice.Type::Resource);
                    NSJobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                    NSJobResourcePrice.SetFilter("Job Task No.", '%1', "NS_Job Task No.");
                    NSJobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                    if NSJobResourcePrice.findset() then begin
                        "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                    end;
                    if "NS_Skill Code New" = '' then begin
                        NSJobResourcePrice.Reset();
                        NSJobResourcePrice.SetRange(Type, NSJobResourcePrice.Type::Resource);
                        NSJobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                        NSJobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                        if NSJobResourcePrice.findset() then begin
                            "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                        end;
                    end;
                    if "NS_Skill Code New" = '' then begin
                        NSJobResourcePrice.Reset();
                        NSJobResourcePrice.SetRange(Type, NSJobResourcePrice.Type::"Group(Resource)");
                        NSJobResourcePrice.SetRange(Code, "NS_CTS Resource Group No.");
                        NSJobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                        if NSJobResourcePrice.findset() then begin
                            "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                        end;
                    end;
                    if "NS_Skill Code New" = '' then begin
                        NSJobResourcePrice.Reset();
                        NSJobResourcePrice.SetRange(Type, NSJobResourcePrice.Type::All);
                        NSJobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                        if NSJobResourcePrice.findset() then begin
                            "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                            //PE-224.JS.1.0 10APR2024 - Start
                        end;
                    end;
                    if "NS_Skill Code New" = '' then begin
                        NSResourceSkillClass.Reset();
                        NSResourceSkillClass.setrange("NS_Resource No.", "NS_Resource No.");
                        NSResourceSkillClass.setrange(NS_Default, true);
                        if NSResourceSkillClass.FindFirst then begin
                            if rec."NS_Skill Code New" = '' then
                                rec."NS_Skill Code New" := NSResourceSkillClass."NS_Skill Class Code";
                        end;
                    end;
                    if "NS_Skill Code New" = '' then begin
                        NSJobResourcePrice.Reset();
                        NSJobResourcePrice.SetRange(Type, NSJobResourcePrice.Type::Resource);
                        NSJobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                        NSJobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                        if PAGE.RUNMODAL(0, NSJobResourcePrice) = ACTION::LookupOK then
                            "NS_Skill Code New" := NSJobResourcePrice."NS_Skill Class Code New";
                    end;
                    //end;
                    //PE-224.JS.1.0 10APR2024 - end
                    //end;
                    //end;
                    //rec.Modify();
                    //end;
                    //PE-274.JS.1.0 11APR2024- end  
                end else begin
                    if ("NS_Resource No." = '') and ("NS_Add New Line" = true) then begin
                        rec."NS_Skill Code New" := '';
                        rec.Modify();
                    end;
                end;
                //PE-152.JS.1.0 21Aug2023 - end

                //PE-158.AS.1.0 04SEPT2023 START
                //if HumanResSetup.Get() then;  //PRJCTPR-337.JS.1.0 13MAR0224 line added
                if HumanResSetup.NS_EnableResourceSkillClass = TRUE then begin
                    if ResRec.Get(Rec."NS_Resource No.") then begin
                        Rec."NS_Skill Code New" := ResRec."NS_Skill Class Code";
                        rec.Modify();
                    end;
                end;
                //PE-158.AS.1.0 04SEPT2023 END
            end;
        }
        field(7; "NS_Resource Name"; Code[20])
        {
            ObsoleteState = Pending;//PRJ-1074.AS.1.0 28DEC2021 Obselete
            ObsoleteReason = 'Will be removed in next build';//PRJ-1074.AS.1.0 28DEC2021 Obselete
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            Editable = false;//PRJ-1074.AS.1.0 06JAN2022
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(8; "NS_Working Hours"; Integer)
        {
            Caption = 'Working Hours';
            Description = '';
            DataClassification = CustomerContent;
            //PRJ-841.JS.1.0 16Aug2021-Start
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
            //PRJ-841.JS.1.0 16Aug2021-end
        }
        field(9; "NS_Crew code"; code[20])
        {
            Caption = 'Crew Code';//PE-164.DK.1.0 3oct2023
            Description = '';
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "NS_Lead Person"; code[20])
        {
            Caption = 'Crew Lead '; //PE-164.DK.1.0 3oct2023
            Description = 'Specifies Lead crew';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "NS_Working Date"; Date)
        {
            Caption = 'Work Date'; //PE-156.HS.1.0 8September2023
            Description = 'Specifies Working Date';
            DataClassification = CustomerContent;
            //PRJ-1144.JS.1.0 03Feb2022- Start
            //Editable = false;
            trigger OnValidate()
            var
                //PE-152.JS.1.0 21aug2023 - Start
                NSJobRec: record Job;
                NSJobCrews: record "NS_Job Crews";
                NSCrewLines: record "NS_Crew Line";
                NSCrewtimeSheetHdr: record NS_TimesheetHdrCustom;
                NSCrewtimeSheetHdr1: record NS_TimesheetHdrCustom;
                NSCrewTimeSheetLine1: record "NS_TimeSheetLineCustom";
                NSCrewTimeSheetLine2: record "NS_TimeSheetLineCustom";
            //PE-152.JS.1.0 21aug2023 - end
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
                //PE-152.JS.1.0 21aug2023 - Start
                if ("NS_Job No." <> '') and ("NS_Crew code" <> '') and ("NS_Add New Line" = true) then begin
                    if "NS_Working Date" <> 0D then begin
                        rec.TestField("NS_Resource No.");
                        rec.testfield("NS_Resource Working Hours");
                        NSCrewtimeSheetHdr.NS_CTSUpdateWorkStartandEndDate(rec."NS_TimeSheetNo.", "NS_Working Date");
                        rec.Modify();
                    end;
                end;
                //PE-152.JS.1.0 21aug2023 - end
            end;
            //PRJ-1144.JS.1.0 03Feb2022- end
        }
        field(12; NS_Status; Option)
        {
            Caption = 'Status';

            Description = 'Specifies Status';
            Editable = false;
            DataClassification = CustomerContent;
            OptionCaption = 'Open,Submitted,Approved,Rejected,Posted';
            OptionMembers = Open,Submitted,Approved,Rejected,Posted;
        }
        field(13; "NS_Unique Line ID"; Code[20])
        {
            Caption = 'Unique Line ID';
            Description = 'Specifies unique line ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "NS_TimeSheetCrewWorkDays"; integer)
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            MaxValue = 7;
            MinValue = 1;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "NS_Work Type Code"; Code[10])
        {
            //PE-135.Dk.1.0 21July2023 START
            //Caption = 'Work Type';
            Caption = 'Work Type Code';
            //PE-135.Dk.1.0 21July2023 END
            TableRelation = "Work Type";
            //Editable = false;                 //PRJ-841.JS.1.0 16Aug2021
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;
        }

        field(16; "NS_Skill Code"; Code[10])   //PRJ-841.JS.1.0 16Aug2021
        {
            Caption = 'Skill Class Code'; //PRJ-1281.RM.1.0
            DataClassification = CustomerContent;
            //PE-68.Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68.Dk.1.0 10April2023 End
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

            trigger OnLookup()
            var
                JobResourcePrice: Record "Job Resource Price";
            begin
                JobResourcePrice.Reset();
                JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                //JobResourcePrice.SetFilter("Job Task No.", '%1', "NS_Job Task No.");
                JobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                    "NS_Skill Code" := JobResourcePrice."NS_Skill Class Code";
            end;
        }
        //PE-68.Dk.1.0 10April2023 Start
        field(18; "NS_Skill Code New"; Code[20])
        {
            Caption = 'Skill Class Code';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

            trigger OnLookup()
            var
                JobResourcePrice: Record "Job Resource Price";
            begin
                //PE-274.JS.1.0 02APR2024 - Start
                JobResourcePrice.Reset();
                JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                JobResourcePrice.SetFilter("Job Task No.", '%1', "NS_Job Task No.");
                JobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                if JobResourcePrice.findset() then begin
                    if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                        "NS_Skill Code New" := JobResourcePrice."NS_Skill Class Code New";
                end else begin
                    JobResourcePrice.Reset();
                    JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                    JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                    JobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                    if JobResourcePrice.findset() then begin
                        if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                            "NS_Skill Code New" := JobResourcePrice."NS_Skill Class Code New";
                    end else begin
                        JobResourcePrice.Reset();
                        JobResourcePrice.SetRange(Type, JobResourcePrice.Type::"Group(Resource)");
                        JobResourcePrice.SetRange(Code, "NS_CTS Resource Group No.");
                        JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                        if JobResourcePrice.findset() then begin
                            if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                                "NS_Skill Code New" := JobResourcePrice."NS_Skill Class Code New";
                        end else begin
                            JobResourcePrice.Reset();
                            JobResourcePrice.SetRange(Type, JobResourcePrice.Type::All);
                            JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                            if JobResourcePrice.findset() then begin
                                if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                                    "NS_Skill Code New" := JobResourcePrice."NS_Skill Class Code New";
                                //PE-274.JS.1.0 10APR2024 - Start
                            end else begin
                                JobResourcePrice.Reset();
                                JobResourcePrice.SetRange(Type, JobResourcePrice.Type::Resource);
                                JobResourcePrice.Setfilter("Job No.", '%1', "NS_Job No.");
                                //JobResourcePrice.SetFilter("Job Task No.", '%1', "NS_Job Task No.");
                                JobResourcePrice.SetFilter(code, '%1', "NS_Resource No.");
                                if PAGE.RUNMODAL(0, JobResourcePrice) = ACTION::LookupOK then
                                    "NS_Skill Code New" := JobResourcePrice."NS_Skill Class Code New";
                            end;

                            //PE-274.JS.1.0 10APR2024 - end
                        end;
                    end;
                end;
            end;
            //PE-274.JS.1.0 02APR2024 - end
            //PE-68.Dk.1.0 10April2023 End
        }
        field(17; "NS_Segment Code"; Code[20])  //PRJ-842.JS.1.0 20Aug2021
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

        }

        //PRJ-924.JS.1.0 17Sep2021-Start
        field(19; "NS_Resource Working Hours"; Decimal)
        {
            Caption = 'Working Hours';
            Description = '';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            MaxValue = 8;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Rec.testfield(NS_Status, Rec.NS_Status::Open);
            end;

        }
        //PRJ-924.JS.1.0 17Sep2021-Start

        field(20; "NS_Resource Name New"; Text[100])//PRJ-1074.AS.1.0 28DEC2021
        {
            Caption = 'Resource Name';
            Description = 'Specifies Resource Name';
            Editable = false;//PRJ-1074.AS.1.0 06JAN2022
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }

        field(21; "NS_Ready To Submit"; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (NS_Status = NS_Status::Approved) or (NS_Status = NS_Status::Posted) then
                    Error('You are not allow to open Approved or Posted Timesheet lines');
                if "NS_Ready To Submit" = true then begin
                    TestField("NS_TimeSheetNo.");
                    TestField("NS_Job No.");
                    TestField("NS_Job Task No.");
                    TestField("NS_Crew code");
                    TestField("NS_Resource No.");
                    TestField("NS_Lead Person");
                    TestField("NS_Resource Working Hours");
                    TestField("NS_Resource Name New");
                end;
            end;
        }
        field(22; "NS_Rejected Remark"; text[100])
        {
            Caption = 'Rejected Remark';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-1452.GK.1.0 13June2022 start
        field(23; "NS_Time Sheet Owner User ID"; Code[50])
        {
            Caption = 'Time Sheet Owner User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        field(952; "NS_Time Sheet Approver User ID"; Code[50])
        {
            Caption = 'Time Sheet Approver User ID';
            DataClassification = CustomerContent;
            TableRelation = "User Setup";
        }
        //PRJ-1452.GK.1.0 13June2022 end
        //PRJCTPR-2.RM.1.0 13Dec2022 start
        field(953; "NS_Union Code"; Code[10])
        {
            Caption = 'Union Code';
            DataClassification = CustomerContent;
            TableRelation = Union;
        }
        //PRJCTPR-2.RM.1.0 13Dec2022 end
        //PE-152.JS.1.0 21aug2023 - Start
        field(954; "NS_Add New Line"; boolean)
        {
            Caption = 'Add New Line';
            DataClassification = CustomerContent;
            editable = false;
        }
        //PE-152.JS.1.0 21aug2023 - End
        //PE-211.AS start
        field(14021488; "NS_Field Manager"; Code[50])
        {
            Caption = 'Field Manager';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PE-211.AS end  

        //PE-274.JS.1.0 02APR2024 - Start
        field(14021489; "NS_CTS Resource Group No."; Code[20])
        {
            Caption = 'Resource Group No.';
            TableRelation = "Resource Group";
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PE-274.JS.1.0 02APR2024 - end
    }

    keys
    {
        key(Key1; "NS_TimeSheetNo.", "NS_LineNo.")
        {
            Clustered = true;
        }
        key(Key2; "NS_Working Date")      //PE-152.JS.1.0 21Aug2023 Add new key
        {

        }
    }

    var
        NSLabel001: Label 'Work Date should be as per "Crew Time Sheet Header" on weekly basis between %1..%2'; //PE-274.PS.1.0 Added

    trigger OnInsert()
    var
        jbrec: Record Job;//PE-211.AS
    begin
        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec.get(Rec."NS_Job No.") then
                Rec."NS_Field Manager" := jbrec."NS_Field Manager";
        //PE-211.AS end
    end;

    trigger OnModify()
    var
        jbrec1: Record Job;//PE-211.AS
    begin
        //PE-211.AS start
        if Rec."NS_Job No." <> '' then
            if jbrec1.get(Rec."NS_Job No.") then
                Rec."NS_Field Manager" := jbrec1."NS_Field Manager";
        //PE-211.AS end
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}