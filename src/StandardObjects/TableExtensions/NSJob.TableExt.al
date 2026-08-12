/// <summary>
/// TableExtension NS_Job (ID 14021131) extends Record Job.
/// </summary>
tableextension 14021131 NS_Job extends Job
{
    // a3b03edf-3f59-46a5-9644-a1f4a6b1d289
    // version NAVW111.00.00.24232,NAVNA11.00.00.24232,PPNA11.00
    //PRJ-78.SK.1.0 Modified the OptionCaption for "Contract Type" field
    //PRJ-83.SK.1.0 Modified the field lenght
    //PRJ-120.SK.1.0 Added "Gen. Bus. Posting Group" field on Job table
    //PRJ-156.SK.1.0 Extended option string "Contract Type"
    //PRJ-181.MS.1.0 Change var PP_LockedJobPlanningLine from Job planning line to locked planning line in CopyPlanningToLocked function
    //PRJ-214:AS:09APRIL2020 : Done code for sell to customer no. & sell to customer name in function "CreateChangeOrder".
    //PRJ-199:16APRIL2020 : Added "Job Setup" variable in functions LoadTasksOperation(),LoadTasksProcess(),LoadTasksActivity() to bring Job task codes back while using default job setup.
    //JD-10.MS.1.0  Added new field DFR no.
    //PRJ-270.AS.1.0.21MAY2020 Added & Commented Code
    //PRJ-301.AS.1.0 Increased Length from 80 to 100 characters
    // PRJ-301.AS.1.0 For Sell-to Customer error Increased length from 50 to 100 chars
    //PRJ-321.MS.1.0 changes the code for committedd cost		 
    //PRJ-313.AS.1.0 15JULY2020 Done code to flow Burden percent value for activity
    //CTSI-115.AS.1.0 Added new field
    //CTSI-131.MS.1.0 delete cost cat.lins when del job
    //CTSI-152.AS.1.0 14Sept2020 Commented old validation for excluded job forecast field
    //PRJ-361.AS.1.0 31AUG2020 Rolled Back Code
    //PRJ-361.AS.2.0 11SEPT2020 Done code to block functionality for copy job
    //PRJ-464.AM.1.0 3DEC2020 | Modied No. field code to validate No. on Segment table wnen no. is modified.
    //PRJ-464.AM.1.0 4DEC2020 | Added 3 field to copy when creating work order and change order .
    //PPAL-171.AM.1.0 08DEC2020 | Flow of segment list when creating work order and change order .
    //ppal-174.AS.1.0 28DEC2020 Commented & Added Code
    //JD-48.AS.1.0 31OCT2020 Added Forecast method field
    //JD-48.AS.2.0 Added
    //PRJ-677.N.S.1.0 Add Job Status Date condition
    //CTSI-150.AS.1.0 28Sept2020 Added new field
    //PRJ-751.RS.1.0 14June21 | Cloned of TMF: 10: Product Change: Change the names associated with the Manager Job Status on Job Card (88)//PRJ-751.AS.1.0 06July2021 Roll back because it was wrong
    //CTSI-196.MS.1.0 added new field
    //PRJ-797.MS.1.0 change option field(NS_Manager Job Status) to Enum
    //PRJ-877.JS.1.0 20Aug2021 | Add condition while deleting a job without job ledger entry
    //PRJ-923.GK.1.0 21Sep2021 | Add code for validate Gen. Bus. Posting Group.
    //PRJ-929.GK.1.0 22Sep2021 | Added new field Use Tax Percentage & validate from  job setup.
    // PRJ-949.GK.1.0 01Oct2021 | Added new field No. of Active Crews
    //PRJ-973.GK.1.0 13Oct2021 | Add one field.
    //PRJ-991.GK.1.0 14Oct2021 | Add one field
    //PRJ-1015.JS.1.0 05Oct2021 | Add on New field
    //PRJ-1002.GK.1.0 21Oct2021 | Add AND Condition
    //PRJ-1042.JS.1.0 15Dec2021 | Add code to set detault job tasks
    //FGH-16.SK.1.0 | 13JAN2022 | Added code and field to support Rev Rec customisation
    //PRJ-1285.RM.1.0 04April2022 | commented
    //PRJ-1286.NK.1.0 05Apr2022 | Add Code to Create Change Order
    //PRJ-1299.JS.1.0 18APR2022 | Add option
    //PRJ-371.NK.1.0 12May2022 | Add Code For Delete Job Forcast
    //PRJ-1380.NK.1.0 12May2022 | Add Field
    //PRJ-1368.RM.1.0 23May2022 | Corrected grammatical error
    //PRJ-1355.JS.1.0 23MAY2022 | Add Code
    //PRJ-1420.NK.1.0 30May2022 | Add Code
    //PRJ-1437.NK.1.0 09Jun2022 | Add Code
    //PRJ-1458.RM.1.0 16June2022 | Added a new field.
    //PRJ-1574.RM.1.0 12Aug2022 | Added a caption
    //PRJ-1571.NK.1.0 17Aug2022 | Add Code
    //PRJ-1585.NK.1.0 25Aug2022 | Add Code
    //PRJ-1608.RM.1.0 20Sep2022 | Added some code
    //PRJCTPR-39.JS.1.0 23JAN2023 | allow negatinve value
    //PRJCTPR-39.JS.1.0 23JAN2023 | allow negatinve value
    //PRJCTPR-50.JS.1.0 30JAN2023 | GUIALLOWED then for NS_Use Default Tasks                                                    
    //PRJCTPR-48.Dk.1.0  27Jan 2023    | Added some Code  
    //PRJCTPR-58.RM.1.0 22Feb2023 | Added some code 
    //PE-6.NK.1.0 28Mar2022 | Add one field.   
    //PE-149.RM.1.0 21Aug2023 | Added a field.       
    //PRJCTPR-197 Dk.1.0 31March2023 | Job No. Rewrite Issue.
    //PRJCTPR-289.HS.1.0 16Jan2024 | Added code
    //PE-246.HS.1.0 1Feb2024 | Added Code
    //PRJCTPR-338.DK.1.0 19March | Add some Code
    fields
    {
        //PRJ-464.AM.1.0 Start
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                SegmentRec: Record "NS_Job Takeoff Segments";
                SegmentValTransfer: Record "NS_Job Takeoff Segments";
            begin
                if Rec."No." <> xRec."No." then begin
                    SegmentRec.Reset();
                    SegmentRec.SetRange("NS_Job No.", xRec."No.");
                    if SegmentRec.FindSet() then
                        repeat
                            SegmentValTransfer := SegmentRec;
                            SegmentValTransfer.Rename(SegmentRec.NS_Type, Rec."No.", SegmentRec."NS_Segment Code", SegmentRec."NS_Size of Weld");
                        until SegmentRec.Next() = 0;
                end;
            end;
        }
        //PRJ-464.AM.1.0 End


        modify(Description)
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                IF (Description <> xRec.Description) OR ("NS_Contract For" = '') THEN
                    "NS_Contract For" := Description;
                //ProjectPro - end
            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnBeforeValidate()
            var
                Cust: Record Customer;
                IsHandleProjecPro: Boolean;//PRJ-1526.AS.1.0
            begin
                NS_OnBeforeBillToCustomerNoValidate(IsHandleProjecPro, Rec);//PRJ-1526.AS.1.0

                IF not IsHandleProjecPro then begin//PRJ-1526.AS.1.0 START ----- Added in IshandleProjectpro condition
                    IF ("Bill-to Customer No." = '') OR ("Bill-to Customer No." <> xRec."Bill-to Customer No.") THEN
                        //ProjectPro - start
                        IF (JobLedgEntryExist OR JobPlanningLineExist) AND (Status.AsInteger() >= Status::Open.AsInteger()) THEN
                            //ProjectPro - end
                            ERROR(AssociatedEntriesExistErr, FIELDCAPTION("Bill-to Customer No."), TABLECAPTION);
                END;//PRJ-1526.AS.1.0 END Added in IshandleProjectpro condition

                IF "Bill-to Customer No." <> '' THEN BEGIN
                    Cust.GET("Bill-to Customer No.");
                    //ProjectPro - start
                    "NS_Job Country/Region Code" := Cust."Country/Region Code";
                    "NS_Tax Liable" := Cust."Tax Liable";
                    "NS_Tax Area Code" := Cust."Tax Area Code";
                    //ProjectPro - end

                end else
                    //ProjectPro - start
                    "NS_Job Country/Region Code" := '';
                //ProjectPro - end
            end;

            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                IF "Bill-to Customer No." <> '' THEN BEGIN
                    Cust.GET("Bill-to Customer No.");
                    //ProjectPro - start
                    "NS_Job Country/Region Code" := Cust."Country/Region Code";
                    "NS_Tax Liable" := Cust."Tax Liable";
                    "NS_Tax Area Code" := Cust."Tax Area Code";
                    //PRJ-923.GK.1.0 21Sep2021 start
                    if (Cust."Gen. Bus. Posting Group" <> '') AND ("NS_Gen. Bus. Posting Group New" = '') then   //PRJ-1002.GK.1.0 21Oct2021 | Add AND Condition
                        //Validate("NS_Gen. Bus. Posting Group", Cust."Gen. Bus. Posting Group");//PRJ-831.AS.1.0 12OCT2021 Comment old
                         Validate("NS_Gen. Bus. Posting Group New", Cust."Gen. Bus. Posting Group");//PRJ-831.AS.1.0 12OCT2021 Add New
                    //PRJ-923.GK.1.0 21Sep2021 end
                    //ProjectPro - end
                end;
            end;
        }

        modify(Status)
        {
            trigger OnBeforeValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
                NS_Job: Record Job;
                FiletrSublevel: Code[20];
                Subleveljobs: Record Job;
                JObCount: Integer;
                InvoiceBilled: array[3] of Decimal;//PE-47.PS.1.0 28Feb2023
                JobTask: Record "Job Task";//PE-47.PS.1.0 28Feb2023
                InvoiceAmount: Decimal;//PE-47.PS.1.0 28Feb2023
                BilledAmount: Decimal;//PE-47.PS.1.0 28Feb2023
                JobRec: Record Job;//PE-47.PS.1.0 28Feb2023
                JobCounts: Integer;//PE-47.PS.1.0 05April2023
                JobNo: Code[20];//PE-47.PS.1.0 05April2023
                JobCountsCode: Text[10];//PE-47.PS.1.0 06April2023
                Jobsetup: Record "Jobs Setup";
                ConfirmationBool: Boolean;

            begin
                IF xRec.Status <> Status THEN BEGIN
                    //ProjectPro - start                  
                    IF Status = Status::Completed THEN BEGIN
                        IF xRec.Status = Status::Planning THEN BEGIN
                            JobsSetup.GET;
                            //  IF ("NS_Indirect Burden Type" = 0) AND JobsSetup."NS_Burden Required" THEN //PE-193.PS.1.0 17Oct2023 Commented 
                            IF ("NS_Indirect Burden Type" = 0) AND (JobsSetup."NS_Burden Required") And (Rec."NS_Job Class" <> Rec."NS_Job Class"::"Change Request") then //PE-193.PS.1.0 17Oct2023 
                                ERROR(Text14021105);
                        END;
                        //VALIDATE(Complete, TRUE);//PRJ-270.AS.1.0.21MAY2020 Commented Code //PE-167.VC.1.1 20Sep2023
                        Complete := TRUE;//PRJ-270.AS.1.0.21MAY2020 Added Code
                        GET("No.");
                        Status := Status::Completed;
                        Complete := TRUE;
                        //PRJCTPR-58.RM.1.0 start
                        //PE-287.JS.1.0 02MAY2024-Start
                        //Rec."NS_Completion Date" := WorkDate();
                        //MODIFY;
                        //END else
                        //Rec."NS_Completion Date" := 0D;                        
                        if (Status = Status::Completed) and (rec."NS_UpdJFWForecastCompCostOnJT" = true) then begin
                            if (rec."NS_POC Method" = rec."NS_POC Method"::" ") or (rec."NS_POC Method" = rec."NS_POC Method"::"NS_Job forecast") then begin
                                if confirm(NS_Text14021410Lbl, true) then begin
                                    Complete := TRUE;
                                    GET("No.");
                                    Status := Status::Completed;
                                    Rec."NS_Completion Date" := WorkDate();
                                    "NS_Revenue Recognized" := true;
                                end else begin
                                    Complete := false;
                                    Status := xrec.Status;
                                end;
                            end;
                        end;
                        MODIFY;
                    END else begin
                        if rec.status <> rec.status::completed then begin
                            //if rec.status = rec.status::Open then begin //PRJCTPR-389.NC.1.0 26Jan2024 Block
                            if ((xRec.Status = xRec.Status::Completed) and (Rec.Status = Rec.Status::Open)) then begin //PRJCTPR-389.NC.1.0 26Jan2024
                                if confirm(NS_Text14021411Lbl, true) then
                                    rec."Last Date Modified" := today
                                else begin
                                    rec."Last Date Modified" := xrec."Last Date Modified";
                                    rec.Status := xrec.Status;
                                    rec.Complete := xRec.Complete;
                                end;
                            end;
                        end;
                    end;
                    //PE-287.JS.1.0 02MAY2024-end                       
                    //PRJCTPR-58.RM.1.0 End
                    //ProjectPro - end
                    //PE-167.VC.1.2 22Sep2023 Start
                    // IF xRec.Status = xRec.Status::Completed THEN
                    //     IF DIALOG.CONFIRM(StatusChangeQst) THEN
                    //         VALIDATE(Complete, FALSE)
                    //     ELSE
                    //         Status := xRec.Status;
                    // MODIFY;
                    //PE-167.VC.1.2 22Sep2023 End
                    JobPlanningLine.SETCURRENTKEY("Job No.");
                    JobPlanningLine.SETRANGE("Job No.", "No.");
                    JobPlanningLine.MODIFYALL(Status, Status);
                END;
                //PE-47.PS.1.0 28Feb2023 start
                JobsSetup.get();
                if (JobsSetup."NS_Enable Job Backlog Feature.") and (Rec."NS_Job Class" <> Rec."NS_Job Class"::"Change Request") then begin //PE-193.PS.1.0 17Oct2023 
                    if Rec.Status = Rec.Status::Completed then begin
                        FiletrSublevel := '@*' + Rec."No." + '*';
                        NS_Job.SetFilter("No.", FiletrSublevel);
                        if NS_Job.FindSet() then begin
                            Clear(JobCounts);
                            // JobCounts := NS_Job.Count;
                            // JobCountsCode := Format(JobCounts);
                            Subleveljobs.SetRange("NS_Sub-Level to Job No.", NS_Job."No.");
                            Subleveljobs.SetFilter(Status, '<>%1', NS_Job.status::Completed);
                            if Subleveljobs.findset then begin
                                JobCounts := Subleveljobs.Count;
                                JobCountsCode := Format(JobCounts);
                                // if not CONFIRM('This master Job No. ' + Rec."No." + ' have additional ' + JobCountsCode + '  Changes Order / Sub Level Jobs open, do you want to first update Sub Level Job status to completed. Do you want to continue..', false) then //PE-173.PS.1.0 03Oct2023 Commented 
                                if not CONFIRM('The Master Job ' + Rec."No." + ' has one or more open Sub-Level Jobs. Do you want to close the Sub-Level Jobs first by setting their Status to "Completed"?', false) then //PE-173.PS.1.0 03Oct2023
                                    Error('');

                            end;
                        End;
                    End;

                    if JobsSetup."NS_Inclued SubJob & Change Ord" = true then begin
                        if rec.Status = Rec.Status::Completed then begin
                            JobRec.Reset();
                            JobRec.SetRange("NS_Sub-Level to Job No.", Rec."No.");
                            if JobRec.FindSet() then
                                repeat
                                    Clear(InvoiceAmount);
                                    Clear(BilledAmount);
                                    JobTask.Reset();
                                    JobTask.SetRange("Job No.", JobRec."No.");
                                    JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                                    if JobTask.FindSet() then
                                        repeat
                                            JobTask.CalcFields("Contract (Total Price)");
                                            JobTask.CalcFields("Contract (Invoiced Price)");
                                            BilledAmount += JobTask."Contract (Total Price)";
                                            InvoiceAmount += JobTask."Contract (Invoiced Price)";
                                        until JobTask.Next() = 0;
                                    if InvoiceAmount <> BilledAmount then
                                        //Error('Job No. %1 Billable Amount of %2 is still pending to Invoiced, this will not allow you to backlog clearing', JobRec."No.", InvoiceAmount - BilledAmount); //PE-173.PS.1.0 04Oct2023  Commented
                                        Error('The backlog cannot be cleared because the billable amount of %2 is still pending to be invoiced for sub-level job %1.', JobRec."No.", InvoiceAmount - BilledAmount); //PE-173.PS.1.0 04Oct2023
                                until JobRec.Next() = 0;
                            Clear(InvoiceAmount);
                            Clear(BilledAmount);
                            JobTask.Reset();
                            JobTask.SetRange("Job No.", Rec."No.");
                            JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                            if JobTask.FindSet() then
                                repeat
                                    JobTask.CalcFields("Contract (Total Price)");
                                    JobTask.CalcFields("Contract (Invoiced Price)");
                                    BilledAmount += JobTask."Contract (Total Price)";
                                    InvoiceAmount += JobTask."Contract (Invoiced Price)";
                                until JobTask.Next() = 0;
                            if InvoiceAmount - BilledAmount < 0 then
                                Error('Please run the open batch job backlog batch');
                        end;
                    end;

                    if (rec.Status = rec.Status::Completed) AND (rec."NS_New Run B_OpenJob B Log" = false) then  //PRJCTPR-122.PS.1.0 14Jun2023
                        Error('Please run the open batch job backlog batch');
                    if (rec.Status = rec.Status::Completed) AND (rec."NS_New Run B_OpenJob B Log") AND (rec."NS_Open Job Backlog" <> 0) then begin  //PRJCTPR-122.PS.1.0 14Jun2023
                        if (rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Closed) OR (rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Running) OR (rec."NS_Manager Job Status" = rec."NS_Manager Job Status"::Completed) then begin
                            if not Confirm('Do you want to set this job to completed and clear the backlog values?', false) then begin
                                rec."NS_New Run B_OpenJob B Log" := false; //PRJCTPR-122.PS.1.0 14Jun2023
                                Rec.Validate(Status, xRec.Status);
                                exit;
                            end
                            else begin
                                Clear(InvoiceAmount);
                                Clear(BilledAmount);
                                JobTask.Reset();
                                JobTask.SetRange("Job No.", Rec."No.");
                                JobTask.SetRange("Job Task Type", JobTask."Job Task Type"::Posting);
                                if JobTask.FindSet() then
                                    repeat
                                        JobTask.CalcFields("Contract (Total Price)");
                                        JobTask.CalcFields("Contract (Invoiced Price)");
                                        BilledAmount += JobTask."Contract (Total Price)";
                                        InvoiceAmount += JobTask."Contract (Invoiced Price)";
                                    until JobTask.Next() = 0;
                                if (Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Running) AND (InvoiceAmount - BilledAmount = 0) then begin
                                    Rec."NS_Open Job Backlog" := 0;
                                    Rec."NS_New Run B_OpenJob B Log" := true;  //PRJCTPR-122.PS.1.0 14Jun2023
                                    Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount;  //PRJCTPR-122.PS.1.0 14Jun2023
                                end
                                else
                                    if (Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Closed) OR ((Rec."NS_Manager Job Status" = Rec."NS_Manager Job Status"::Completed)) AND (InvoiceAmount - BilledAmount >= 0) then begin
                                        Rec."NS_Open Job Backlog" := 0;
                                        Rec."NS_New Run B_OpenJob B Log" := true;  //PRJCTPR-122.PS.1.0 14Jun2023
                                        Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount; //PRJCTPR-122.PS.1.0 14Jun2023
                                    end;
                                If (InvoiceAmount - BilledAmount < 0) then begin
                                    Message('Backlog is pending please check the Invoiced vs billable');
                                    Rec."NS_New Run B_OpenJob B Log" := false;  //PRJCTPR-122.PS.1.0 14Jun2023
                                    Rec."NS_New Billable/Inv Dif" := InvoiceAmount - BilledAmount; //PRJCTPR-122.PS.1.0 14Jun2023
                                end;
                            end;
                        end;
                    end;

                    //PE-47.PS.1.0 28Feb2023 End
                end;
            end;
        }
        //PRJ-1437.NK.1.0 09Jun2022 Start
        modify("Job Posting Group")
        {
            trigger OnAfterValidate()
            var
                JobTast: Record "Job Task";
                RecJob: Record Job;
            begin
                JobTast.Reset();
                JobTast.SetRange("Job No.", Rec."No.");
                if JobTast.FindFirst() then
                    JobTast.ModifyAll("Job Posting Group", Rec."Job Posting Group");
            end;
        }
        //PRJ-1437.NK.1.0 09Jun2022 End

        //PE-47.PS.1.0 28Feb2023  Start 

        field(14021494; "NS_Run Batch Open Job Backlog New"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Run Batch Open Job Backlog';
            //PRJCTPR-122.PS.1.0 19Jun2023 Start
            ObsoleteState = Removed; //PRJCTPR.164.JS.1.0 24JULY2023
            ObsoleteReason = 'Because of length  the table field name NS_Run Batch Open Job Backlog New  must not exceed 30 characters.';
            ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';
            //PRJCTPR-122.PS.1.0 19Jun2023 End

        }
        field(14021495; "NS_Billable/Invoiced Difference"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Run Batch Open Job Backlog';
            //PRJCTPR-122.PS.1.0 19Jun2023 Start
            ObsoleteState = Removed; //PRJCTPR.164.JS.1.0 24JULY2023
            ObsoleteReason = 'Because of length  the table field name NS_Billable/Invoiced Difference  must not exceed 30 characters.';
            ObsoleteTag = 'ProjectPro upcoming release 22.0.XXX.00';

            //PRJCTPR-122.PS.1.0 19Jun2023 End
        }
        field(14021498; "NS_New Run B_OpenJob B Log"; Boolean)  //PRJCTPR-122.PS.1.0 14Jun2023
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021499; "NS_New Billable/Inv Dif"; Decimal) //PRJCTPR-122.PS.1.0 14Jun2023
        {
            DataClassification = CustomerContent;
            Editable = false;

        }
        //PE-47.PS.1.0 28Feb2023  End


        field(14021100; "NS_Job Address 1"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Job Address 1';
            Description = 'ProjectPro Base Job Data';
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Job Address 2"; Text[50])
        {
            Caption = 'Job Address 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job City"; Text[50])
        {
            Caption = 'Job City';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = IF ("Bill-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                PostCode: Record 225;
            begin
                //ProjectPro - start
                PostCode.ValidateCity(
                  "NS_Job City", "NS_Job Post Code", "NS_Job County", "NS_Job Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
                //ProjectPro - end
            end;
        }
        field(14021103; "NS_Job County"; Text[30])
        {
            Caption = 'Job State';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Job Post Code"; Code[20])
        {
            Caption = 'Job Zip Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "Post Code";
            ValidateTableRelation = false; //PRJ-1585.NK.1.0 25Aug2022
            trigger OnValidate();
            var
                PostCode: Record 225;
            begin
                //ProjectPro - start
                PostCode.ValidatePostCode(
                  "NS_Job City", "NS_Job Post Code", "NS_Job County", "NS_Job Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
                //ProjectPro - end
            end;
            //PRJ-1585.NK.1.0 25Aug2022 Start
            trigger OnLookup()
            var
                PostCode: Record 225;
            begin
                PostCode.LookupPostCode(
                  "NS_Job City", "NS_Job Post Code", "NS_Job County", "NS_Job Country/Region Code");
            end;
            //PRJ-1585.NK.1.0 25Aug2022 End
        }
        field(14021105; "NS_Job Country/Region Code"; Code[10])
        {
            Caption = 'Job Country/Region Code';
            Description = 'ProjectPro';
            Editable = true;
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Job Contact"; Text[30])
        {
            Caption = 'Job Contact';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Job Phone"; Text[30])
        {
            Caption = 'Job Phone';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Job Ship-to Code"; Code[10])
        {
            Caption = 'Job Ship-to Code';
            Description = 'ProjectPro';
            //PRJCTPR-192.DK.1.0 15SEP2023 Start
            //TableRelation = "Ship-to Address".code WhERE("Customer No." = FIELD("Bill-to Customer No."));
            //TableRelation = "Ship-to Address".code WhERE("Customer No." = FIELD("Sell-to Customer No.")); //Please Removed this Line
            DataClassification = CustomerContent;
            //PRJCTPR-192.DK.1.0 15SEP2023 End
        }
        //PRJ-1458.RM.1.0 Start
        field(14021451; "NS_Delievery Instruction"; Text[100])
        {
            DataClassification = CustomerContent;
            //Caption = 'Delievery Instruction'; //PRJ-1574.RM.1.0 commented
            Caption = 'Delivery Instructions'; //PRJ-1574.RM.1.0
            Description = 'ProjectPro';

        }
        //PRJ-1458.RM.1.0 end
        field(14021110; "NS_Sub-Level to Job No."; Code[20])
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = Job;

            trigger OnValidate();
            var
                NS_JobNew: Record Job;
            begin
                //PRJ-589.AM Start
                if "No." <> '' then
                    if "NS_Sub-Level to Job No." = "No." then
                        ERROR(Text14021107, FIELDCAPTION("NS_Sub-Level to Job No."), FIELDCAPTION("No."));
                //PRJ-589.AM End
                //ProjectPro - start
                if (xRec."NS_Sub-Level to Job No." <> Rec."NS_Sub-Level to Job No.") and
                   ("NS_Sub-Level to Job No." > '') then begin
                    if "NS_Sub-Level to Job No." = "No." then
                        ERROR(Text14021107, FIELDCAPTION("NS_Sub-Level to Job No."), FIELDCAPTION("No."));
                    if GUIALLOWED then
                        if CONFIRM(Text14021104, true, "NS_Sub-Level to Job No.") then begin
                            NS_JobNew.GET("NS_Sub-Level to Job No.");
                            "Search Description" := NS_JobNew."Search Description";
                            Description := NS_JobNew.Description;
                            "Description 2" := NS_JobNew."Description 2";
                            "Bill-to Customer No." := NS_JobNew."Bill-to Customer No.";
                            "Creation Date" := TODAY;
                            "Starting Date" := 0D;
                            "Ending Date" := 0D;
                            Status := Status::Planning;
                            "Person Responsible" := NS_JobNew."Person Responsible";
                            VALIDATE("Global Dimension 1 Code", NS_JobNew."Global Dimension 1 Code");
                            VALIDATE("Global Dimension 2 Code", NS_JobNew."Global Dimension 2 Code");
                            "Job Posting Group" := NS_JobNew."Job Posting Group";
                            Blocked := Blocked::" ";
                            "Customer Disc. Group" := NS_JobNew."Customer Disc. Group";
                            "Customer Price Group" := NS_JobNew."Customer Price Group";
                            "Language Code" := NS_JobNew."Language Code";
                            "Bill-to Name" := NS_JobNew."Bill-to Name";
                            "Bill-to Address" := NS_JobNew."Bill-to Address";
                            "Bill-to Address 2" := NS_JobNew."Bill-to Address 2";
                            "Bill-to City" := NS_JobNew."Bill-to City";
                            "Bill-to County" := NS_JobNew."Bill-to County";
                            "Bill-to Post Code" := NS_JobNew."Bill-to Post Code";
                            "No. Series" := NS_JobNew."No. Series";
                            "Bill-to Country/Region Code" := NS_JobNew."Bill-to Country/Region Code";
                            "WIP Method" := NS_JobNew."WIP Method";
                            "Currency Code" := NS_JobNew."Currency Code";
                            "Bill-to Contact No." := NS_JobNew."Bill-to Contact No.";
                            "Bill-to Contact" := NS_JobNew."Bill-to Contact";
                            "WIP Posting Date" := NS_JobNew."WIP Posting Date";
                            "WIP Posting Method" := NS_JobNew."WIP Posting Method";
                            "Invoice Currency Code" := NS_JobNew."Invoice Currency Code";
                            "Exch. Calculation (Cost)" := NS_JobNew."Exch. Calculation (Cost)";
                            "Exch. Calculation (Price)" := NS_JobNew."Exch. Calculation (Price)";
                            "Allow Schedule/Contract Lines" := NS_JobNew."Allow Schedule/Contract Lines";
                            "NS_Job Address 1" := NS_JobNew."NS_Job Address 1";
                            "NS_Job Address 2" := NS_JobNew."NS_Job Address 2";
                            "NS_Job City" := NS_JobNew."NS_Job City";
                            "NS_Job County" := NS_JobNew."NS_Job County";
                            "NS_Job Post Code" := NS_JobNew."NS_Job Post Code";
                            "NS_Job Country/Region Code" := NS_JobNew."NS_Job Country/Region Code";
                            "NS_Job Contact" := NS_JobNew."NS_Job Contact";
                            "NS_Job Phone" := NS_JobNew."NS_Job Phone";
                            "NS_Job Ship-to Code" := NS_JobNew."NS_Job Ship-to Code";
                            "NS_Temp Linked Parent Job No." := NS_JobNew."NS_Temp Linked Parent Job No.";
                            "NS_Last Job For Job List" := NS_JobNew."NS_Last Job For Job List";
                            //PRJCTPR-197 Dk.1.0  Start
                            //"NS_Job Type" := NS_JobNew."NS_Job Type";
                            "NS_Job Type New" := NS_JobNew."NS_Job Type New";
                            //PRJCTPR-197 Dk.1.0 End
                            NS_Estimator := NS_JobNew.NS_Estimator;
                            NS_Manager := NS_JobNew.NS_Manager;
                            "NS_Manager Job Status" := NS_JobNew."NS_Manager Job Status";
                            "NS_Job Status Date" := 0D;
                            "NS_Estimated Start Date" := 0D;
                            "NS_Estimated Completion Date" := 0D;
                            "NS_Completion Date" := 0D;
                            "NS_Job Posting Date" := NS_JobNew."NS_Job Posting Date";
                            "NS_Recognition Date" := NS_JobNew."NS_Recognition Date";
                            "NS_Unit of Measure" := '';
                            "NS_Total Units" := 0;
                            "NS_Billing method" := NS_JobNew."NS_Billing method";
                            "NS_Recognition Method" := NS_JobNew."NS_Recognition Method";
                            "NS_Default Job Retention" := NS_JobNew."NS_Default Job Retention";
                            "NS_Tax Area Code" := NS_JobNew."NS_Tax Area Code";
                            "NS_Tax Liable" := NS_JobNew."NS_Tax Liable";
                            "NS_Tax Group Code New" := NS_JobNew."NS_Tax Group Code New";
                            "NS_VAT Bus. Posting Group" := NS_JobNew."NS_VAT Bus. Posting Group";
                            "NS_VAT Prod. Posting Group" := NS_JobNew."NS_VAT Prod. Posting Group";
                            "NS_Actual Percent Complete" := 0;
                            "NS_Actual PercentCompleteDate" := 0D;
                            "NS_Actual Units Complete" := 0;
                            "NS_Actual Units Complete Date" := 0D;
                            "NS_Job Revenue Posting" := NS_JobNew."NS_Job Revenue Posting";
                            "NS_Progress Billing No." := NS_JobNew."NS_Progress Billing No.";
                            "NS_Progress Billing Sub-Level" := NS_JobNew."NS_Progress Billing Sub-Level";
                            "NS_Customer Job No." := NS_JobNew."NS_Customer Job No.";
                            "NS_Customer PO Number" := '';
                            "NS_Contract No." := NS_JobNew."NS_Contract No.";
                            "NS_Contract Date" := NS_JobNew."NS_Contract Date";
                            "NS_Contract For" := NS_JobNew."NS_Contract For";
                            "NS_Job Purchaser" := NS_JobNew."NS_Job Purchaser";//PRJ-1380.NK.1.0 12May2022
                        end;
                end;

                if xRec."NS_Sub-Level to Job No." <> Rec."NS_Sub-Level to Job No." then begin
                    NS_JobLinks.DeleteJobLinks("No.");
                    NS_JobLinks.CreateJobLinks("No.", "NS_Sub-Level to Job No.");
                    COMMIT;
                end;

                if "NS_Sub-Level to Job No." <> '' then
                    "No. Series" := '';
                //ProjectPro - end
            end;
        }
        field(14021111; "NS_Temp Linked Parent Job No."; Code[20])
        {
            Caption = 'Temp Linked Parent Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Last Job For Job List"; Boolean)
        {
            Caption = 'Last Job for Job List';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        //PRJ-1616.AS.1.0 START
        field(14021113; "NS_CopyJob"; Boolean)
        {
            Caption = 'Copy Job';
            Description = 'Copy Job';
            DataClassification = CustomerContent;
        }
        //PRJ-1616.AS.1.0 END
        field(14021115; "NS_Job Type"; Code[10])
        {
            Caption = 'Job Type (Obsolete)';  //PRJCTPR-298.JS.1.0 16JAN2024
            Description = 'ProjectPro';
            TableRelation = "NS_Job Type".NS_Code;
            DataClassification = CustomerContent;
            //PRJCTPR-197 DK.1.0 Start
            // ObsoleteState = Pending;//PRJCTPR-298.JS Comment
            ObsoleteState = Removed;//PRJCTPR-298.JS Add
            ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_Job Type New" because of length mismatch with';
            ObsoleteTag = 'This field will remove in ProjectPro Upcoming App build no 21.0.xx.49984';
            //PRJCTPR-197 DK.1.0 End
        }
        // PRJCTPR-197 DK.1.0 Start
        field(14021157; "NS_Job Type New"; Code[20])
        {
            Caption = 'Job Type';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Type".NS_Code;
            DataClassification = CustomerContent;
        }
        //PRJCTPR-197 DK.1.0 End
        field(14021116; "NS_Job Class"; Enum NSJobClassTypeEnum)//PRJ-1677.AS.1.0 change from option to enum
        {
            Caption = 'Job Class';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            // OptionCaption = ' ,Master Job,SubJob,Change Order,Extra Work,Proposed,Template,Work Order';//PRJ-1677.AS.1.0 Commented
            // OptionMembers = " ","Master Job",SubJob,"Change Order","Extra Work",Proposed,Template,"Work Order";//PRJ-1677.AS.1.0 Commented

            trigger OnValidate();
            begin
                //ProjectPro - start
                if ("NS_Job Class" <> "NS_Job Class"::"Master Job") then
                    "No. Series" := '';
                //ProjectPro - end
            end;
        }
        field(14021117; "NS_Time And Material"; Boolean)
        {
            Caption = 'Time And Material';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            //PRJ-162.SK.1.0 Start
            trigger OnValidate()
            begin
                IF "NS_Time And Material" then begin
                    "Apply Usage Link" := true;
                    "Allow Schedule/Contract Lines" := true;
                    "NS_Line Type" := "NS_Line Type"::"Both Budget and Billable";
                end;
            end;
            //PRJ-162.SK.1.0 End
        }
        field(14021118; "NS_Indirect Burden Type"; Option)
        {
            Caption = 'Indirect Burden Type';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            OptionCaption = ' ,Project,Service,Admin';
            OptionMembers = " ",Project,Service,Admin;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Indirect Burden Type" <> xRec."NS_Indirect Burden Type" then
                    if xRec."NS_Indirect Burden Type" = 0 then begin
                        NS_JobTask.RESET;
                        NS_JobTask.SETRANGE("Job No.", "No.");
                        if NS_JobTask.FINDSET then
                            repeat
                                NS_JobTask."NS_Burden Percent" := NS_JobTask.NS_GetDefaultAPOBurdenPercent(Rec, NS_JobTask."Job Task No.");
                                NS_JobTask.MODIFY;
                            until NS_JobTask.NEXT = 0
                    end else
                        ERROR(Text14021106);
                //ProjectPro - end
            end;
        }
        field(14021119; "NS_Salesperson Code"; Code[20]) //PRJ-83.SK.1.0 Modified the field lenght
        {
            Caption = 'Salesperson Code';
            Description = 'ProjectPro';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(14021120; NS_Estimator; Code[20])
        {
            Caption = 'Estimator';
            Description = 'ProjectPro';
            TableRelation = Resource WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;
        }
        field(14021121; NS_Manager; Code[20])
        {
            Caption = 'Manager';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(14021122; "NS_Manager Job Status"; Enum NSManagerJobStatus)//PRJ-797.MS.1.0 change from option to enum
        {
            //BlankZero = true;
            Caption = 'Manager Job Status';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            //PRJ-751.AS.1.0 06July2021 Roll back because it was wrong . All commented done by RS - start
            //OptionCaption = ',Estimating,Quoting,Verbal App,Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed';
            //OptionCaption = ',Estimating,Quoting,Submitted,Verbal App,Approved,Running,Hold,Completed,Billed,Paid,Closed';
            //OptionMembers = ,Estimating,Quoting,"Submitted","Verbal App",Approved,Running,Hold,Completed,Billed,Paid,Closed;////PRJ-751.RS.1.0 14June21
            //PRJ-751.AS.1.0 06July2021 Roll back because it was wrong. All commented done by RS - end
            //OptionCaption = ',Estimating,Quoting,Verbal App,Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed';//PRJ-751.AS.1.0 06July2021 Previous changes done again////PRj-797 comment
            //OptionMembers = ,Estimating,Quoting,"Verbal App",Approval,Planning,Running,Hold,Completed,Billed,Paid,Closed;//PRJ-751.AS.1.0 06July2021 Previous changes done again//PRj-797 comment
            //PRJ-677.N.S.1.0 Start
            trigger OnValidate()
            begin
                "NS_Job Status Date" := Today;
                //PRJCTPR-147.PS.2.0 20Sep2023 Start

                if NSUserSetup.get(UserId) then;
                //PRJCTPR-395.DK.1.0 27June2024 Start
                // if not NSUserSetup."NS_Allow to Acc Manager Status" then begin
                //     Error('You can not Modify Manager Status because of you dont have perrmission');
                // end;
                // //PRJCTPR-147.PS.2.0 20Sep2023 End
                if (Rec."NS_Job Class" = Rec."NS_Job Class"::"Change Request") then
                    if (not NSUserSetup."NS_Allow to Acc Manager Status") then
                        Error('You do not have access to modify the Manager Status.');
                //PRJCTPR-395.DK.1.0 27June2024 End
                //PRJCTPR-147.PS.2.0 20Sep2023 End

            end;
            //PRJ-677.N.S.1.0 END
        }
        field(14021123; "NS_Job Status Date"; Date)
        {
            Caption = 'Job Status Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-1443.AS.1.0 START
        field(14021429; "NS_EnblGLNResGMCalc"; Boolean)
        {
            Caption = 'Enable Resources in Gross Marg. Calc.';
            Description = 'Enable Resources in Gross Marg. Calc.';
            DataClassification = CustomerContent;
        }
        //PRJ-1443.AS.1.0 END
        field(14021125; "NS_Estimated Start Date"; Date)
        {
            Caption = 'Estimated Start Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021126; "NS_Estimated Completion Date"; Date)
        {
            Caption = 'Estimated Completion Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021127; "NS_Completion Date"; Date)
        {
            Caption = 'Completion Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021128; "NS_Job Posting Date"; Date)
        {
            Caption = 'Job Posting Date';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021129; "NS_Recognition Date"; Date)
        {
            Caption = 'Recognition Date';

            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021130; "NS_Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021131; "NS_Total Units"; Decimal)
        {
            Caption = 'Total Units';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021132; "NS_Revenue Recognized"; Boolean)
        {
            CaptionML = ENU = 'Revenue Recognized',
                        ENC = 'Revenue Recognized';
            Description = 'CTSI-285.MS.1.0';
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                UserSetup: Record "User Setup";
            begin
                if UserSetup.get(UserId) then;
                if not UserSetup."NS_Modify Revenue Recognized Job" then
                    Error('You do not have permission to modify this.');
            end;
        }
        field(14021134; "NS_Billing Day of Month"; Text[6])
        {
            Caption = 'Billing Day of Month';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                InputValid: Boolean;
                NumericInput: Integer;
            begin
                //ProjectPro - start
                InputValid := false;
                "NS_Billing Day of Month" := UPPERCASE("NS_Billing Day of Month");

                if (STRLEN("NS_Billing Day of Month") > 0) and
                   (STRLEN("NS_Billing Day of Month") <= 2) then begin
                    EVALUATE(NumericInput, "NS_Billing Day of Month");
                    if (NumericInput >= 1) and (NumericInput <= 28) then begin
                        InputValid := true;
                    end;
                end else
                    if ("NS_Billing Day of Month" = Text14021108) or
                       ("NS_Billing Day of Month" = Text14021109) or
                       ("NS_Billing Day of Month" = Text14021110) or
                       ("NS_Billing Day of Month" = Text14021111) or
                       ("NS_Billing Day of Month" = '') then
                        InputValid := true;

                if not InputValid then
                    ERROR(Text14021112);
                //ProjectPro - end
            end;
        }
        field(14021135; "NS_Billing Method"; Option)
        {
            BlankZero = true;
            Caption = 'Billing Method';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            OptionCaption = ',Fixed,T&E,T&E Not to Exceed,Cost+Fixed Fee';
            OptionMembers = ,"Fixed","T&E","T&E Not to Exceed","Cost+Fixed Fee";
        }
        field(14021136; "NS_Recognition Method"; Option)
        {
            Caption = 'Recognition Method';

            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            InitValue = "Percentage of Completion";
            OptionCaption = 'Percentage of Completion,Completed Contract';

            OptionMembers = "Percentage of Completion","Completed Contract";
        }
        field(14021137; "NS_Default Job Retention"; Decimal)
        {
            Caption = 'Default Job Retention';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Forecast Type"; Option)
        {
            Caption = 'Forecast Type';
            Description = 'ProjectPro';
            OptionCaption = '% of Projected,% of  Budget';
            OptionMembers = "% of Projected","% of Budget";
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro Sales tax defaults';
            TableRelation = "Tax Area";
        }
        field(14021141; "NS_Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            Editable = true;
        }
        field(14021142; "NS_Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code (Obsolete)'; //PRJCTPR-298.JS.1.0 16JAN2024
            //ZEL-7.GK.1.0 30Mar2023 start
            // ObsoleteState = Pending;//PRJCTPR-298.JS Comment
            ObsoleteState = Removed;//PRJCTPR-298.JS Add
            ObsoleteReason = 'This field is marked for removal and replaced by new field "NS_Tax Group Code New" because microsoft has increase field length of standard "Tax Group Code" field';
            ObsoleteTag = '21.0.10.49984';
            //ZEL-7.GK.1.0 30Mar2023 end
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "Tax Group";
        }

        //PRJCTPR-298.JS START

        field(14021438; "NS_Tax Group Code New"; Code[20])
        {
            Caption = 'Tax Group Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "Tax Group";
        }
        //PRJCTPR-298.JS END
        field(14021145; "NS_VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            Description = 'ProjectPro';
            TableRelation = "VAT Business Posting Group";
            DataClassification = CustomerContent;
        }
        field(14021146; "NS_VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            Description = 'ProjectPro';
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Actual Percent Complete"; Decimal)
        {
            Caption = 'Actual Percent Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //FGH-16.SK.1.0 Start
            trigger OnValidate()

            begin
                if Rec."NS_Actual Percent Complete" <> xRec."NS_Actual Percent Complete" then
                    Rec."NS_Actual PercentCompleteDate" := Today;
            end;
            //FGH-16.SK.1.0 End
        }
        field(14021151; "NS_Actual PercentCompleteDate"; Date)
        {
            Caption = 'Actual Percent Complete Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Actual Units Complete"; Decimal)
        {
            Caption = 'Actual Units Complete';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            //FGH-16.SK.1.0 Start
            trigger OnValidate()

            begin
                if Rec."NS_Actual Units Complete" <> xRec."NS_Actual Units Complete" then
                    Rec."NS_Actual Units Complete Date" := today;
            end;
            //FGH-16.SK.1.0 End
        }
        field(14021153; "NS_Actual Units Complete Date"; Date)
        {
            Caption = 'Actual Units Complete Date';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021154; "NS_Job Revenue Posting"; Option)
        {
            Caption = 'Job Revenue Posting';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            InitValue = Earned;
            OptionCaption = 'None,Earned';
            OptionMembers = "None",Earned;
        }
        field(14021155; "NS_Progress Billing No."; Code[20])
        {
            Caption = 'Progress Billing No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021156; "NS_Progress Billing Sub-Level"; Boolean)
        {
            Caption = 'Progress Billing Sub-Level';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021160; "NS_Customer Job No."; Text[30])
        {
            Caption = 'Customer Job No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro Customer Interface Data';
        }
        field(14021161; "NS_Customer PO Number"; Text[20])
        {
            Caption = 'Customer PO Number';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021162; "NS_Contract No."; Text[30])
        {
            Caption = 'Contract No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021163; "NS_Contract Date"; Date)
        {
            Caption = 'Contract Date';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            //PRJ-1468.GK.1.0 06July2022 start
            trigger OnValidate()
            var
                JobPlanningLines: Record "Job Planning Line";
            begin
                if Rec."NS_Contract Date" <> xRec."NS_Contract Date" then begin
                    JobPlanningLines.Reset();
                    JobPlanningLines.SetRange("Job No.", Rec."No.");
                    if JobPlanningLines.FindSet() then
                        repeat
                            JobPlanningLines."NS_Contract Forecast Date" := Rec."NS_Contract Date";
                            JobPlanningLines.Modify();
                        until JobPlanningLines.Next() = 0;
                end;

            end;
            //PRJ-1468.GK.1.0 06July2022 end
        }
        field(14021164; "NS_Contract For"; Text[100]) //PRJ-301.AS.1.0 Increased Length from 80 to 100 characters
        {
            Caption = 'Contract For';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021165; "NS_Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Contract Fixed,Contract Not To Exceed,Time and Material,Contract Fixed - AIA'; //PRJ-78.SK.1.0 //PRJ-156.SK.1.0 Added
            OptionMembers = " ","Contract Fixed","Contract Not To Exceed","Time and Material","Contract Fixed - AIA"; //PRJ-156.SK.1.0 Added
        }
        field(14021166; "NS_Contract Sell Price"; Decimal)
        {
            Caption = 'Contract Sell Price';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021170; "NS_Requires Certified Payroll"; Boolean)
        {
            Caption = 'Requires Certified Payroll';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        field(14021171; "NS_Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Description = 'ProjectPro';
            //TableRelation = "Gen. Product Posting Group".Code;//PRJ-1684.AS.1.0 BLOCKED TABLE RELATION
            ObsoleteState = Removed; //PRJ-120.SK.1.0 //PRJ-1489.GK.1.0 
            ObsoleteReason = 'Unused'; //PRJ-120.SK.1.0
            DataClassification = CustomerContent;
        }
        //PRJ-120.SK.1.0 Start
        field(14021172; "NS_Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            ObsoleteState = Removed; //PRJ-831.AS.1.0 12OCT2021 //PRJ-1489.GK.1.0 
            ObsoleteReason = 'Will be removed in Next build'; //PRJ-831.AS.1.0 12OCT2021
            //TableRelation = "Gen. Business Posting Group".Code;//PRJ-1684.AS.1.0 BLOCKED TABLE RELATION
        }
        //PRJ-120.SK.1.0 Start

        field(14021173; "NS_Gen. Bus. Posting Group New"; Code[20])//PRJ-831.AS.1.0 12OCT2021
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            Description = '//PRJ-831.AS.1.0 12OCT2021';
            TableRelation = "Gen. Business Posting Group".Code;
        }

        field(14021174; "NS_Gen. Prod. Posting Group New"; Code[20]) //PRJ-831.AS.1.0 12OCT2021
        {
            Caption = 'Gen. Prod. Posting Group';
            Description = '//PRJ-831.AS.1.0 12OCT2021';
            TableRelation = "Gen. Product Posting Group".Code;
            DataClassification = CustomerContent;
            //PRJ-1608.RM.1.0 start                                                        
            trigger OnValidate()
            var
                NSPlngLine: Record "Job Planning line";
                NSRes: Record Resource;
                NSItemvar: Record Item;
                NSGLAccount: Record "G/L Account";
            begin
                NSPlngLine.Reset();
                NSPlngLine.SetRange("Job No.", Rec."No.");
                if NSPlngLine.FindSet() then
                    repeat
                        if Rec."NS_Gen. Prod. Posting Group New" <> '' then begin
                            NSPlngLine."Gen. Prod. Posting Group" := Rec."NS_Gen. Prod. Posting Group New";
                        end else begin
                            if NSPlngLine.Type = NSPlngLine.type::Resource then begin
                                IF NSRes.GET(NSPlngLine."No.") Then
                                    NSPlngLine."Gen. Prod. Posting Group" := NSRes."Gen. Prod. Posting Group";
                            end;
                            if NSPlngLine.Type = NSPlngLine.type::Item then begin
                                if NSItemvar.get(NSPlngLine."No.") then
                                    NSPlngLine."Gen. Prod. Posting Group" := NSItemvar."Gen. Prod. Posting Group";
                            end;
                            if NSPlngLine.Type = NSPlngLine.Type::"G/L Account" then begin
                                if NSGLAccount.Get(NSPlngLine."No.") then
                                    NSPlngLine."Gen. Prod. Posting Group" := NSGLAccount."Gen. Prod. Posting Group";
                            end;
                        end;
                        NSPlngLine.Modify();
                    until NSPlngLine.Next() = 0
            end;
            //PRJ-1608.RM.1.0 end
        }
        field(14021190; "NS_OS File Name"; Text[150])
        {
            Caption = 'OS File name';
            DataClassification = CustomerContent;
            Description = 'Project Pro File name for MS Project';
        }
        field(14021191; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            DataClassification = CustomerContent;
            Description = 'ProjectPro Override value to code in job setup table';
            //PRJCTPR-308.Dk.1.0 08Feb2024 Start
            TableRelation = IF ("NS_Job Calendar Type" = CONST("Base Navision Calendar")) "Base Calendar".Code
            //PRJCTPR-308.Dk.1.0 08Feb2024 End
            ELSE
            IF ("NS_Job Calendar Type" = CONST("Job Calendar")) "NS_Job Calendar".NS_Code;
        }
        field(14021200; "NS_Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';

            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021201; "NS_Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                //ProjectPro - start
                CALCFIELDS("NS_Schedule Total Cost");
                if ("NS_Prepayment %" <> xRec."NS_Prepayment %") then
                    "NS_Prepayment Amount" := "NS_Schedule Total Cost" * ("NS_Prepayment %" / 100);
                //ProjectPro - end
            end;
        }
        field(14021202; "NS_Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';

            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021203; "NS_Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            DataClassification = CustomerContent;

            Description = 'ProjectPro';
            InitValue = true;
        }
        field(14021204; "NS_Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';

            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021205; "NS_Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';

            Description = 'ProjectPro';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(14021206; "NS_Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';

            Description = 'ProjectPro';
            TableRelation = "Payment Terms";
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                PaymentTerms: Record "Payment Terms";
            begin
                //ProjectPro - start
                if ("NS_Prepmt. Payment Terms Code" <> '') and ("Starting Date" <> 0D) then begin
                    PaymentTerms.GET("NS_Prepmt. Payment Terms Code");
                    "NS_Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Starting Date");
                    VALIDATE("NS_Prepmt. Payment Discount %", PaymentTerms."Discount %")
                end else begin
                    VALIDATE("NS_Prepayment Due Date", "Starting Date");
                    VALIDATE("NS_Prepmt. Payment Discount %", 0);
                end;
                //ProjectPro - end
            end;
        }
        field(14021207; "NS_Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';

            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            MaxValue = 100;
            MinValue = 0;
        }
        field(14021208; "NS_Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';

            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021209; "NS_Prepayment Amount"; Decimal)
        {
            Caption = 'Prepayment Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021210; "NS_Schedule Total Cost"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price (LCY)" WHERE("Job No." = FIELD("No."),
                                                                             "Schedule Line" = FILTER(true)));
            Caption = 'Schedule Total Cost';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021250; "NS_Cost Category Filter"; Code[10])
        {
            Caption = 'Cost Category Filter';

            Description = 'ProjectPro Flow Filters';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Cost Category";
        }
        field(14021251; "NS_Revenue Category Filter"; Code[10])
        {
            Caption = 'Revenue Category Filter';

            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Revenue Category";
        }
        //JD-48.AS.2.0  - start
        field(14021215; "NS_Segment Code Filter"; Code[20])
        {
            CaptionML = ENU = 'Segment Code Filter',
                        ENC = 'Segment Code Filter';
            Description = 'Segment Code Filter';
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Takeoff Segments";
        }
        field(14021252; "NS_Job Task No. Filter"; Code[35])
        {
            Caption = 'Job Task No. Filter';

            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "Job Task";
        }
        field(14021253; "NS_Exclude Entry Filter"; Boolean)
        {
            Caption = 'Exclude Entry Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
        }
        field(14021255; "NS_Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';

            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14021256; "NS_Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';

            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14021257; "NS_Entry Type Filter"; Option)
        {
            Caption = 'Entry Type Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            OptionCaption = 'Usage,Sale,Release,Earn';
            OptionMembers = Usage,Sale,Release,Earn;
        }
        field(14021258; "NS_Adjustment Filter"; Code[10])
        {
            Caption = 'Adjustment Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "NS_Adjustment Type";
        }
        field(14021259; "NS_Budget Type Filter"; Option)
        {
            Caption = 'Budget Type Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,Account (G/L),Group (Resource),Contract';
            OptionMembers = Resource,Item,"Account (G/L)","Group (Resource)",Contract;
        }
        field(14021260; "NS_Item No. Filter"; Code[20])
        {
            Caption = 'Item No. Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = Item."No.";
        }
        field(14021261; "NS_Type Filter"; Option)
        {
            Caption = 'Type Filter (Obsolete)'; //PE-306.JS.1.0 06MAY2024
            ObsoleteState = Pending;    //PE-306.JS.1.0 06MAY2024
            ObsoleteReason = 'Change from type option to type enum, as per changes in BC standard.'; //PE-306.JS.1.0 06MAY2024
            ObsoleteTag = 'Will change in ProjectPro upcoming app version 24.0.XX.XXXX'; //PE-306.JS.1.0 06MAY2024
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,G/L Account,Ledger';

            OptionMembers = Resource,Item,"G/L Account",Ledger;
        }
        //PE-306.JS.1.0 06MAY2024-Start
        field(14021263; "NS_TypeEnumFilter"; enum "Job Planning Line Type")
        {
            Caption = 'Type Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
        }
        //PE-306.JS.1.0 06MAY2024-end
        field(14021262; "NS_Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
        }
        field(14021265; "NS_Activity Filter"; Code[10])
        {
            Caption = 'Activity Filter';
            Description = 'ProjectPro';
            CaptionClass = '50994,0,0'; //PRJ-1571.NK.1.0 17Aug2022
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Activity";
        }
        field(14021266; "NS_Process Filter"; Code[10])
        {
            Caption = 'Process Filter';
            Description = 'ProjectPro';
            CaptionClass = '50994,1,0'; //PRJ-1571.NK.1.0 17Aug2022
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Process";
        }
        field(14021267; "NS_Operation Filter"; Code[10])
        {
            Caption = 'Operation Filter';
            Description = 'ProjectPro';
            CaptionClass = '50994,2,0'; //PRJ-1571.NK.1.0 17Aug2022
            FieldClass = FlowFilter;
            TableRelation = "NS_Job Operation";
        }
        field(14021300; "NS_Budgeted Cost (LCY)"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("No."),
                                                                            "Line Type" = FILTER(Budget | "Both Budget and Billable"),
                                                                            "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                            "NS_Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                            Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                            "Planning Date" = FIELD("Posting Date Filter"),
                                                                            NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                            "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                            "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                            "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Cost ($)';
            Description = 'ProjectPro Flow Fields';
            FieldClass = FlowField;
        }
        field(14021301; "NS_Budgeted Price (LCY)"; Decimal)
        {
            //CalcFormula = Sum("Job Planning Line"."Total Price (LCY)" WHERE("Job No." = FIELD("No."),    //PE-287.JS.1.0 08MAY2024 line commented
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("No."),       //PE-287.JS.1.0 08MAY2024 line added
                                                                             "Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                             "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                             "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                             Type = FIELD("NS_TypeEnumFilter"), //PE-306.JS.1.0
                                                                             "Planning Date" = FIELD("Posting Date Filter"),
                                                                             NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                             "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                             "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Price ($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021302; "NS_Budgeted Cost Quantity"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("No."),
                                                                           "Line Type" = FILTER(Budget | "Both Budget and Billable"),
                                                                           "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                           "NS_Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                           Type = FIELD("NS_TypeEnumFilter"), //PE-306.JS.1.0
                                                                           "Planning Date" = FIELD("Posting Date Filter"),
                                                                           NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                           "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                           "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                           "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Cost Quantity';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021303; "NS_Budgeted Price Quantity"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("No."),
                                                                           "Line Type" = FILTER(Budget | "Both Budget and Billable"),
                                                                           "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                           "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                           Type = FIELD("NS_TypeEnumFilter"), //PE-306.JS.1.0
                                                                           "Planning Date" = FIELD("Planning Date Filter"),
                                                                           NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                           "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                           "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                           "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Price Quantity';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021304; "NS_Budgeted Res. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("No."),
                                                                           Type = CONST(Resource),
                                                                           "No." = FIELD("Resource Filter"),
                                                                           "Planning Date" = FIELD("NS_Date Filter")));
            Caption = 'Budgeted Res. Qty.';

            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021305; "NS_Budgeted Res. Gr. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE(Type = CONST("NS_Resource (Group)"),
                                                                        "Job No." = FIELD("No."),
                                                                      "Resource Group No." = FIELD("Resource Gr. Filter"),
                                                                    "Planning Date" = FIELD("NS_Date Filter")));
            Caption = 'Budgeted Res. Gr. Qty.';

            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021310; "NS_Usage (Cost) (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("No."),
                                                                           "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                           "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "NS_Segment Code" = field("NS_Segment Code Filter"),//JD-48.AS.2.0
                                                                           Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                           "Posting Date" = FIELD("NS_Date Filter"),
                                                                           "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                           "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                           "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Cost) ($)';

            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021311; "NS_Usage (Price) (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Ledger Entry"."Total Price (LCY)" WHERE("Job No." = FIELD("No."),
                                                                            "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                            "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                            "Entry Type" = CONST(Usage),
                                                                            Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                            "Posting Date" = FIELD("NS_Date Filter"),
                                                                            "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                            "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                            "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                            "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Price) ($)';

            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021312; "NS_Actual Cost Quantity(Usage)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("No."),
                                                                 "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                 "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                 "Entry Type" = CONST(Usage),
                                                                 Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                 "Posting Date" = FIELD("Posting Date Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                 "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                 "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Cost) Quantity (Usage)';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021313; "NS_Actual PriceQuantity(Usage)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("No."),
                                                                 "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                 "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                 "Entry Type" = CONST(Usage),
                                                                 Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                 "Posting Date" = FIELD("Posting Date Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                 "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                 "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Price) Quantity (Usage)';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021314; "NS_Actual Cost Quantity (Sale)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("No."),
                                                                  "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                  "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                  "Entry Type" = CONST(Sale),
                                                                  Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                  "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                  "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                  "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Cost) Quantity (Sale)';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021315; "NS_Actual Price Quantity(Sale)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("No."),
                                                                  "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                  "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                  "Entry Type" = CONST(Sale),
                                                                  Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                  "Posting Date" = FIELD("Posting Date Filter"),
                                                                  "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                  "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                  "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Usage (Price) Quantity (Sale)';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021330; "NS_Invoiced Price (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job Ledger Entry"."Total Price (LCY)" WHERE("Job No." = FIELD("No."),
                                                                             "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                             "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                             "Entry Type" = CONST(Sale),
                                                                             Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                             "Posting Date" = FIELD("NS_Date Filter"),
                                                                             "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                             "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Invoiced Price ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021331; "NS_Amt. Paid (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("NS_Job No." = FIELD("No."),
                                                                                 "Document Type" = CONST(Payment),
                                                                                 "Posting Date" = FIELD("Posting Date Filter"),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("NS_Global Dimension 2 Filter"),
                                                                                 "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Amt. Paid ($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021335; "NS_Amt. Posted To G/L"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry"."Amt. Posted to G/L" WHERE("Job No." = FIELD("No."),
                                                                             "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                             "NS_Job Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                             "NS_Job Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                             "Entry Type" = FIELD("NS_Entry Type Filter"),
                                                                             Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                             "Posting Date" = FIELD("Posting Date Filter"),
                                                                             "Global Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                             "NS_Exclude Entry" = FIELD("NS_Exclude Entry Filter"),
                                                                             "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Amt. Posted To G/L';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021336; "NS_Amt. Recognized"; Decimal)
        {
            Caption = 'Amt. Recognized';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021340; "NS_Locked Planning Lines Exist"; Boolean)
        {
            CalcFormula = Exist("NS_Locked Job Planning Line" WHERE("NS_Job No." = FIELD("No.")));
            Caption = 'Locked Planning Lines Exist';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021341; "NS_Locked Budget Cost (LCY)"; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Total Cost (LCY)" WHERE("NS_Job No." = FIELD("No."),
                                                                                   "NS_Line Type" = FILTER(Budget | "Both Budget and Billable"),
                                                                                   "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                                   "NS_Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                                   NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                                   "NS_Planning Date" = FIELD("Posting Date Filter"),
                                                                                   NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                                   "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                   "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                                   "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Original Budget Cost ($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021342; "NS_Locked Budget Price (LCY)"; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Total Price (LCY)" WHERE("NS_Job No." = FIELD("No."),
                                                                                    "NS_Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                                    "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                                    "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                                    NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                                    "NS_Planning Date" = FIELD("Posting Date Filter"),
                                                                                    NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                                    "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                    "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                                    "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Original Budget Price ($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021343; "NS_Locked Budget Cost Qty."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Quantity (Base)" WHERE("NS_Job No." = FIELD("No."),
                                                                                  "NS_Line Type" = FILTER(Budget | "Both Budget and Billable"),
                                                                                  "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                                  "NS_Cost Category" = FIELD("NS_Cost Category Filter"),
                                                                                  NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                                  "NS_Planning Date" = FIELD("Posting Date Filter"),
                                                                                  NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                                  "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                  "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                  "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Original Budget Cost Qty.';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021344; "NS_Locked Budget Price Qty."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Quantity (Base)" WHERE("NS_Job No." = FIELD("No."),
                                                                                  "NS_Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                                  "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                                  "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                                  NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                                  "NS_Planning Date" = FIELD("Planning Date Filter"),
                                                                                  NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                                  "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                  "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                  "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Original Budget Price Qty.';
            Description = 'ProjectPro';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14021345; "NS_Locked Budget Res. Qty."; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Quantity (Base)" WHERE("NS_Job No." = FIELD("No."),
                                                                                  NS_Type = CONST(Resource),
                                                                                  "NS_No." = FIELD("Resource Filter"),
                                                                                  "NS_Planning Date" = FIELD("NS_Date Filter")));
            Caption = 'Original Budget Res. Qty.';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021346; "NS_Locked Budget Res. Gr. Qty."; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Quantity (Base)" WHERE(NS_Type = CONST("Resource (Group)"),
                                                                                  "NS_Job No." = FIELD("No."),
                                                                                  "NS_Resource Group No." = FIELD("Resource Gr. Filter"),
                                                                                  "NS_Planning Date" = FIELD("NS_Date Filter")));
            Caption = 'Original Budget Res. Gr. Qty.';
            DecimalPlaces = 0 : 5;
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021350; "NS_Job Calendar Type"; Option)
        {
            CalcFormula = Lookup("Jobs Setup"."NS_Job Calendar Source");
            Caption = 'Job Calendar Type';
            Description = 'ProjectPro';
            FieldClass = FlowField;
            //PRJCTPR-308.DK.1.0 08Feb2023 Start
            // OptionCaption = 'Base Navision Calendar,Job Calendar';
            OptionMembers = "Base Navision Calendar","Job Calendar";
            OptionCaption = 'Business Central Calendar,Job Calendar';//Added
            //PRJCTPR-308.DK.1.0 08Feb2023 End
        }
        //PRJCTPR-308.DK.1.0 08Feb2023 Start
        field(14021355; NS_JobCalendarType; Enum NS_JobCalenderType)
        {
            CalcFormula = Lookup("Jobs Setup"."NS_JobCalendarSource");
            Caption = 'Job Calendar Type';
            Description = 'ProjectPro';
            FieldClass = FlowField;

        }
        //PRJCTPR-308.DK.1.0 08Feb2023 End
        field(14021351; "NS_Retention Ledger Filter"; Code[20])
        {
            Caption = 'Retention Ledger Filter';
            Description = 'ProjectPro';
            FieldClass = FlowFilter;
            TableRelation = "NS_Retention Ledger Code".NS_Code;
        }
        field(14021352; "NS_Forecast Method"; Option)//JD-48.AS.1.0 31OCT2020
        {

            //PRJ-1299.JS.1.0 02MAY2022 Start    
            Description = 'Forecast Method';
            DataClassification = CustomerContent;
            Caption = 'Forecast Method';
            OptionMembers = "Job Forecast by Task Code","Job Forecast by Segment Code","Job Forecast by Task Totals";

            trigger OnValidate()
            var
                NSJobSetup: Record "Jobs Setup";
                NSJobForecast: Record "NS_Job Forecast";   //PRJ-1355.JS.1.0 23MAY2022
            begin
                //PRJ-1355.JS.1.0 23MAY2022 - Start
                if Rec."NS_Forecast Method" <> xRec."NS_Forecast Method" then begin
                    NSJobForecast.Reset();
                    NSJobForecast.setrange("NS_Job No.", rec."No.");
                    if NSJobForecast.FindFirst() then
                        Error('Job forecast is already exist with forecast method %1', Rec."NS_Forecast Method");
                end;
                //PRJ-1355.JS.1.0 23MAY2022 - end
                //PRJ-1299.JS.2.0 23MAY2022 - start
                NSJobSetup.get();
                if NSJobSetup."NS_Forecast By Task Total" then
                    if rec."NS_Forecast Method" <> Rec."NS_Forecast Method"::"Job Forecast by Task Totals" then
                        error('As per job setup Forecast Method should be Job Forecast by Tasks Total')
            end;
            //PRJ-1299.JS.2.0 02MAY2022 end

        }
        field(14021354; "NS_Last Forecast Posted Date"; date)
        {
            Description = 'CTSI-196.MS.1.0';
            Caption = 'Last Forecast Posted Date';
            DataClassification = CustomerContent;
        }
        field(14021400; "NS_AP Comment"; Text[80])
        {
            Caption = 'AP Comment';
            Description = 'ProjectPro Job Quote fields';
            DataClassification = CustomerContent;
        }
        field(14021401; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021402; "NS_Job Site Customer No."; Code[20])
        {
            Caption = 'Job Site Customer No.';
            Description = 'ProjectPro';
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                QuoteMgt.NS_JobOnValidateJobSiteCustNo(Rec);
                //ProjectPro - end
            end;
        }
        field(14021403; "NS_Job Site Customer Name"; Text[50])
        {
            Caption = 'Job Site Customer Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Owner No."; Code[20])
        {
            Caption = 'Owner No.';
            Description = 'ProjectPro';
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                QuoteMgt.NS_JobOnValidateOwnerNo(Rec);
                //ProjectPro - end
            end;
        }
        field(14021406; "NS_Owner Name"; Text[50])
        {
            Caption = 'Owner Name';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021407; "NS_General Contractor No."; Code[20])
        {
            Caption = 'General Contractor No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = Contact;

            trigger OnValidate();
            begin
                //ProjectPro - start
                QuoteMgt.NS_GetName(DATABASE::Job
                                , FIELDNO("NS_General Contractor No.")
                                , "NS_General Contractor No."
                                , "NS_General Contractor Name");
                //ProjectPro - end
            end;
        }
        field(14021408; "NS_General Contractor Name"; Text[50])
        {
            Caption = 'General Contractor Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021409; "NS_Architect/Engineer No."; Code[20])
        {
            Caption = 'Architect/Engineer No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = Contact;

            trigger OnValidate();
            begin
                //ProjectPro - start
                QuoteMgt.NS_GetName(DATABASE::Job
                                , FIELDNO("NS_Architect/Engineer No.")
                                , "NS_Architect/Engineer No."
                                , "NS_Architect/Engineer Name");
                //ProjectPro - end
            end;
        }
        field(14021410; "NS_Architect/Engineer Name"; Text[50])
        {
            Caption = 'Architect/Engineer Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021411; "NS_Project Manager No."; Code[20])
        {
            Caption = 'Project Manager No.';
            Description = 'ProjectPro';
            TableRelation = Resource;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                QuoteMgt.NS_GetName(DATABASE::Job
                                , FIELDNO("NS_Project Manager No.")
                                , "NS_Project Manager No."
                                , "NS_Project Manager Name");
                //ProjectPro - end
            end;
        }
        field(14021412; "NS_Project Manager Name"; Text[50])
        {
            Caption = 'Project Manager Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021413; NS_Bond; Boolean)
        {
            Caption = 'Bond';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021414; "NS_Billing Cutoff Day of Month"; Integer)
        {
            Caption = 'Billing Cutoff Day of Month';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021415; "NS_CCIP/OCIP/RCOIP Insurance"; Boolean)
        {
            Caption = 'CCIP/OCIP/RCOIP Insurance';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021416; "NS_Lien Waiver Required"; Boolean)
        {
            Caption = 'Lien Waiver Required';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_Customer Account"; Text[50])
        {
            Caption = 'Customer Account';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021419; "NS_Created from Quote No."; Code[20])
        {
            Caption = 'Created from Quote No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021420; "NS_Quote Revision"; Integer)
        {
            Caption = 'Quote Revision';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021421; "NS_Use Job Material Planning"; Boolean)
        {
            Caption = 'Use Job Material Planning';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021422; "NS_Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Description = 'ProjectPro';
            TableRelation = Customer;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                Cust: Record Customer;
            begin
                //ProjectPro - start
                if ("NS_Sell-to Customer No." <> xRec."NS_Sell-to Customer No.") then
                    if Cust.GET("NS_Sell-to Customer No.") then begin
                        "NS_Sell-to Customer Name" := Cust.Name;
                        Validate("Sell-to Customer No.", "NS_Sell-to Customer No."); //PRJCTPR-148 AT.1.0
                    end;
                if ("Bill-to Customer No." = '') and ("Sell-to Customer No." <> '') then
                    VALIDATE("Bill-to Customer No.", "Sell-to Customer No.");
                //ProjectPro - end
            end;
        }
        field(14021423; "NS_Sell-to Customer Name"; Text[100])// PRJ-301.AS.1.0 For Sell-to Customer error Increased length from 50 to 100 chars
        {
            Caption = 'Sell-to Customer Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        //PRJ-162.SK.1.0 Start
        field(14021424; "NS_Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //PRJ-1359.AS.1.0 02JUNE2022 START
                if Rec."NS_Time And Material" then begin
                    if Rec."NS_Line Type" = Rec."NS_Line Type"::Billable then begin
                        Rec."Apply Usage Link" := false;
                        Message('Apply usage link will be set to false');
                    end;
                end;
                //PRJ-1359.AS.1.0 02JUNE2022 END
            end;
        }
        //PRJ-162.SK.1.0 End
        field(14021430; "NS_DFR Nos."; Code[10])
        {
            Caption = 'DFR Nos.';
            Description = 'JD-10.MS.1.0';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

        field(14021433; "NS_Exclude from Job Forecast"; Boolean)//CTSI-115.AS.1.0 Added new field
        {
            Caption = 'Exclude from Job Forecast';
            Description = 'Boolean to exclude Job forecast while posting';
            DataClassification = SystemMetadata;
            //CTSI-152.AS.1.0 14Sept2020- START
            //trigger OnValidate()
            //begin
            //    if Rec."NS_Sub-Level to Job No." = '' then
            //        Error('You must select Sub-level to Job No. first');
            //end;
            //CTSI-152.AS.1.0 14Sept2020- END
        }
        field(14021434; "NS_Use % Billing format"; Boolean)//CTSI-150.AS.1.0 28Sept2020 Added new field
        {
            Caption = 'Use % Billing Format';
            Description = 'Boolean Use % Billing Format';
            DataClassification = CustomerContent;
        }
        //PRJ-929.GK.1.0 22Sep2021 start
        field(14021440; "NS_Use Tax Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Tax Percentage';
            MinValue = 0;
            trigger OnValidate()
            var
                NS_JobPlaningLines: Record "Job Planning Line";
            begin
                NS_JobPlaningLines.Reset();
                NS_JobPlaningLines.SetRange("Job No.", "No.");
                NS_JobPlaningLines.SetRange("Line Type", NS_JobPlaningLines."Line Type"::Budget, NS_JobPlaningLines."Line Type"::"Both Budget and Billable");
                if NS_JobPlaningLines.FindFirst() then
                    repeat
                        NS_JobPlaningLines.Validate("NS_Use Tax Percentage", "NS_Use Tax Percentage");
                        NS_JobPlaningLines.Modify();
                    until NS_JobPlaningLines.Next() = 0;
            end;
        }
        //PRJ-929.GK.1.0 22Sep2021 end

        field(14021441; "NS_Include Sub Levels"; Boolean)   //PRJ-1015.JS.1.0 05Oct2021 Added new field
        {
            Caption = 'Forecast to Include Sub Levels';
            Description = 'Include Sub Levels Boolean use for True or false value';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                NSForeCastWorkSheet: Record "NS_Job Forecast";
            begin
                If Rec."NS_Include Sub Levels" = true then
                    Rec.TestField("NS_Sub-Level to Job No.", '');
                if rec."NS_Include Sub Levels" = false then begin
                    NSForeCastWorkSheet.Reset();
                    NSForeCastWorkSheet.SetRange("NS_Job No.", rec."No.");
                    if NSForeCastWorkSheet.FindFirst() then
                        error('You cannot make forecaset to include sub levels fales because Job forecast lines exist for job no. %1', Rec."No.");
                end
            end;
        }

        /// PRJ-949.GK.1.0 01Oct2021 start
        field(14021442; "NS_No. Of Active Crews"; Integer)
        {
            Caption = 'No. Of Active Crews';
            FieldClass = FlowField;
            CalcFormula = count("NS_Job Crews" where("NS_Job No." = field("No."), NS_Active = filter(true)));
            Editable = false;
        }
        /// PRJ-949.GK.1.0 01Oct2021 end
        //PRJ-991.GK.1.0 14Oct2021 start
        field(14021444; "NS_No. Of Inactive Crews"; Integer)
        {
            Caption = 'No. Of Inactive Crews';
            FieldClass = FlowField;
            CalcFormula = count("NS_Job Crews" where("NS_Job No." = field("No."), NS_Active = filter(false)));
            Editable = false;
        }
        //PRJ-991.GK.1.0 14Oct2021 end
        //PRJ-973.GK.1.0 13Oct2021 start
        field(14021443; "NS_Use Job Plan. Line Entries"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Use Job Planning Line Entries';
            trigger OnValidate()
            var
                NS_JobPlaningLines: Record "Job Planning Line";

            begin
                NS_JobPlaningLines.Reset();
                NS_JobPlaningLines.SetRange("Job No.", "No.");
                NS_JobPlaningLines.SetRange("Line Type", NS_JobPlaningLines."Line Type"::Billable, NS_JobPlaningLines."Line Type"::"Both Budget and Billable");
                NS_JobPlaningLines.SetRange(Type, NS_JobPlaningLines.Type::"G/L Account");
                if NS_JobPlaningLines.FindSet() then begin
                    if not Confirm(NS_ConfirmMesssage) then
                        exit;
                    repeat
                        NS_JobPlaningLines.Validate("NS_Use Job Plan. Line Entries", "NS_Use Job Plan. Line Entries");
                        NS_JobPlaningLines.Modify();
                    until NS_JobPlaningLines.Next() = 0;
                end;

            end;
        }
        //PRJ-973.GK.1.0 13Oct2021 end

        field(14021445; "NS_Root Job No."; Code[20])   //PRJ-1015.JS.1.0 18Oct2021 Added new field
        {
            Caption = 'Root Job No.';
            Description = 'Root Job No. use for True or false value';
            DataClassification = CustomerContent;
            Editable = false;

        }
        //FGH-16.SK.1.0 Start
        field(14021446; "NS_POC Method"; enum NS_POCMethod)
        {
            DataClassification = CustomerContent;

            //FGH-16.AS.1.0 18JAN2022 START
            trigger OnValidate()
            var
                RevRecSummDetails: Record NS_RevenueRecSummaryTab;
                NSJobsSetup: record "Jobs Setup";  //PE-272.JS.1.0 14MAR2024
                NSRevRecSummDetails: Record NS_RevenueRecSummaryTab;   //PRJCTPR-371.JS.1.0 16MAY2024
                NSCheckRecordCountPosted: Integer; //PRJCTPR-371.JS.1.0 16MAY2024
                NSCheckRecordCountUnPosted: Integer; //PRJCTPR-371.JS.1.0 16MAY2024
            begin
                if NSJobsSetup.get() then;  //PE-272.JS.1.0 14MAR2024 line added
                //PE-174.JS.1.0 31JAN2024 - Start                
                if NSJobsSetup."NS_Enable POC Method Change" = false then begin  //PE-272.JS.1.0 14MAR2024 line added
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.setrange("NS_POC Method", xrec."NS_POC Method");
                    if RevRecSummDetails.findfirst() then
                        error('You cannot change the "POC Method" because related open entries already exist in "Revenue Recognition Summary Details". You must delete the related open entires from "Revenue Recognition Summary Details" before changing the current POC method.');
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(NS_Voided, false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Posted = false) and (RevRecSummDetails."NS_Over/Under Billings Posted" = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(RevRecSummDetails.NS_Posted, false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Voided = false) and (RevRecSummDetails."NS_Over/Under Billings Posted" = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(RevRecSummDetails."NS_Over/Under Billings Posted", false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Voided = false) and (RevRecSummDetails.NS_Posted = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.setrange("NS_Mark POC Method Update", true);
                    IF RevRecSummDetails.FindSet() then
                        RevRecSummDetails.ModifyAll(RevRecSummDetails."NS_POC Method", Rec."NS_POC Method");
                end else begin  //PE-272.JS.1.0 14MAR2024  line added  //PE-281.JS.1.0 10APR2024 -Start
                                //PRJCTPR-371.JS.1.0 16MAY2024-Start
                    Clear(NSCheckRecordCountPosted);
                    Clear(NSCheckRecordCountUnPosted);
                    if xRec."NS_POC Method" <> xRec."NS_POC Method"::" " then begin
                        NSRevRecSummDetails.Reset();
                        NSRevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                        if NSRevRecSummDetails.findset() then begin
                            repeat
                                if ((NSRevRecSummDetails.NS_Posted = false) and (NSRevRecSummDetails.NS_Voided = false) and
                                (NSRevRecSummDetails."NS_Over/Under Billings Posted" = false)) then
                                    NSCheckRecordCountUnPosted := NSCheckRecordCountUnPosted + 1
                                else
                                    NSCheckRecordCountPosted := NSCheckRecordCountPosted + 1;
                            until NSRevRecSummDetails.Next() = 0;
                        end;

                        if NSCheckRecordCountUnPosted = 0 then begin
                            if NSCheckRecordCountPosted > 0 then begin
                                NSRevRecSummDetails.Reset();
                                NSRevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                                if NSRevRecSummDetails.findfirst() then begin
                                    if xRec."NS_POC Method" <> xRec."NS_POC Method"::"NS_Manual Job%" then
                                        if rec."NS_POC Method" <> rec."NS_POC Method"::"NS_Manual Job%" then
                                            error('You can change the POC Method only to "Manual Job %", because all entries in "Revenue Recognition Summary Details" are posted.');
                                end;
                            end;
                        end;
                    end;
                    //PRJCTPR-371.JS.1.0 15MAY2024-end
                    //PE-281.JS.1.0 10APR2024 -Start    
                    //PE-174.JS.1.0 31JAN2024 - Start
                    //PE-281.JS.1.0 11APR2024 -Start
                    // RevRecSummDetails.Reset();
                    // RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");                 
                    // IF RevRecSummDetails.FindSet() then
                    //     RevRecSummDetails.ModifyAll(RevRecSummDetails."NS_POC Method", Rec."NS_POC Method");
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(NS_Voided, false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Posted = false) and (RevRecSummDetails."NS_Over/Under Billings Posted" = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(RevRecSummDetails.NS_Posted, false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Voided = false) and (RevRecSummDetails."NS_Over/Under Billings Posted" = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.SetRange(RevRecSummDetails."NS_Over/Under Billings Posted", false);
                    IF RevRecSummDetails.FindSet() then
                        repeat
                            if (RevRecSummDetails.NS_Voided = false) and (RevRecSummDetails.NS_Posted = false) then begin
                                RevRecSummDetails."NS_Mark POC Method Update" := true;
                                RevRecSummDetails.Modify();
                            end;
                        until RevRecSummDetails.next() = 0;
                    RevRecSummDetails.Reset();
                    RevRecSummDetails.SetRange("NS_Job No.", Rec."No.");
                    RevRecSummDetails.setrange("NS_Mark POC Method Update", true);
                    IF RevRecSummDetails.FindSet() then
                        RevRecSummDetails.ModifyAll(RevRecSummDetails."NS_POC Method", Rec."NS_POC Method");
                end;
                //PE-281.JS.1.0 11APR2024 -end
                //PE-287.JS.1.0 29APR2024 - Start
                if (rec."NS_POC Method" = rec."NS_POC Method"::"NS_Job forecast") or
                (rec."NS_POC Method" = rec."NS_POC Method"::"NS_Markup%") then begin
                    if NSJobsSetup."NS_UpdJFWForecastCompCostOnJT" = true then
                        rec."NS_UpdJFWForecastCompCostOnJT" := true
                    else
                        rec."NS_UpdJFWForecastCompCostOnJT" := false;
                end else
                    rec."NS_UpdJFWForecastCompCostOnJT" := false;
                //PE-287.JS.1.0 29APR2024 - end    
            end;
            //FGH-16.AS.1.0 18JAN2022 END
        }
        field(14021447; "NS_POC Method Value"; Decimal)
        {
            DataClassification = CustomerContent;
            MaxValue = 100;
            MinValue = -100;        //PRJCTPR-39.JS.1.0 23JAN2023
            InitValue = 1;

            trigger OnValidate()
            begin
                IF Rec."NS_POC Method Value" <> xRec."NS_POC Method Value" then
                    "NS_POC Method Value Date" := today;
            end;
        }
        field(14021448; "NS_POC Method Value Date"; date)
        {
            DataClassification = CustomerContent;
        }
        //FGH-16.SK.1.0 End
        //PRJ-1380.NK.1.0 12May2022 Start
        field(14021449; "NS_Job Purchaser"; Code[20])
        {
            Caption = 'Job Purchaser';
            Description = 'PRJ-1380.NK.1.0';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        //PRJ-1380.NK.1.0 12May2022 End
        //PRJ-1262.GK.1.0 03June2022 start
        field(14021450; "NS_Open Job Backlog"; Decimal)
        {
            Caption = 'Open Job Backlog';
            Description = 'PRJ-1262.GK.1.0 03June2022';
            DataClassification = CustomerContent;
        }
        //PRJ-1262.GK.1.0 03June2022 end
        //PRJ-1454.NK.1.0 05Sep2022 Start
        field(14021486; "NS_Budgeted Price (LCY) Cont."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price (LCY)" WHERE("Job No." = FIELD("No."),
                                                                             "Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                             "Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                             "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                             Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                             "NS_Contract Forecast Date" = FIELD("Posting Date Filter"),
                                                                             NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                             "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                             "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Price ($) Cont. Date';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        //PRJ-1454.NK.1.0 05Sep2022 End

        //PE-200.AS.6.0 START
        field(14021487; "NS_PaywhenpaidTermsCode"; Code[10])
        {
            Caption = 'Pay When Paid Term';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms";//PE-200.AS.8.0

            trigger OnValidate();
            var
                PaymentTermsRec: Record "Payment Terms";//PE-200.AS.8.0
            begin
                //PE-200.AS.8.0 start add
                if ("NS_PaywhenpaidTermsCode" <> '') then begin
                    if PaymentTermsRec.GET("NS_PaywhenpaidTermsCode") then;
                    "NS_PaywhenpaidTermsCode" := FORMAT(PaymentTermsRec."Due Date Calculation");
                end;
                //PE-200.AS.8.0 end add
            end;
        }
        //PE-200.AS.6.0 END

        //PE-211.AS.2.0 start
        field(14021488; "NS_Field Manager"; Code[50])
        {
            Caption = 'Field Manager';
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
        }
        //PE-211.AS.2.0 end
        // PE-47.PS.1.0 01March2023 Start 
        field(14021491; "NS_Run Batch Open Job Backlog"; Boolean)
        {
            DataClassification = CustomerContent;
            // Caption = 'Run Batch Open Job Backlog'; //PE-173.PS.1.0 09Oct2023 Commented
            Caption = 'Open Job Backlog Updated';//PE-173.PS.1.0 09Oct2023 
        }

        // PE-47.PS.1.0 01March2023 End
        //MHNA-6.NK.1.0 start 03March2023
        field(14021492; "NS_ Locked Budgeted Rev "; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Total Price (LCY)" WHERE("NS_Job No." = FIELD("No."),
                                                                             "NS_Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                             "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                             "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                             NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                             "NS_Planning Date" = FIELD("Posting Date Filter"),
                                                                             NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                             "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                             "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                             "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Budgeted Price Rev ($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        field(14021493; "NS_Locked Bill Rev Cost (LCY)"; Decimal)
        {
            CalcFormula = Sum("NS_Locked Job Planning Line"."NS_Total Price (LCY)" WHERE("NS_Job No." = FIELD("No."),
                                                                                   "NS_Line Type" = FILTER(Billable | "Both Budget and Billable"),
                                                                                   "NS_Job Task No." = FIELD("NS_Job Task No. Filter"),
                                                                                   "NS_Revenue Category" = FIELD("NS_Revenue Category Filter"),
                                                                                   NS_Type = FIELD("NS_TypeEnumFilter"),  //PE-306.JS.1.0
                                                                                   "NS_Planning Date" = FIELD("Posting Date Filter"),
                                                                                   NS_Adjustment = FIELD("NS_Adjustment Filter"),
                                                                                   "NS_Shortcut Dimension 1 Code" = FIELD("NS_Global Dimension 1 Filter"),
                                                                                   "NS_Shortcut Dimension 2 Code" = FIELD("NS_Global Dimension 2 Filter"),
                                                                                   "NS_Retention Ledger Code" = FIELD("NS_Retention Ledger Filter")));
            Caption = 'Original Budget Cost  Rev($)';
            Description = 'ProjectPro';
            FieldClass = FlowField;
        }
        //MHNA-6.NK.1.0 end 03March2023
        //PE-6.NK.1.0 28Mar2022 Start
        field(14021496; "NS_Opportunity"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Opportunity';
            Editable = false;
        }
        //PE-6.NK.1.0 24Mar2022 End
        //PRJCTPR-11.GK.1.0 20Apr2023 start
        field(14021497; "NS_County"; Text[250])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-11.GK.1.0 20Apr2023 end
        //PE-149.RM.1.0 28Aug2023 start
        field(14021211; "NS_ActInvdLessActCost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        //PE-149.RM.1.0 28Aug2023 end
        //PE-173.PS.1.0 09Oct2023 Start 
        field(14021212; "NS_Last Run Open Job Backlog"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Run Open Job Backlog';
        }
        //PE-173.PS.1.0 09Oct2023 End
        //PE-193.PS.1.0 16Oct2023 Start
        field(14021213; "NS_Margin %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Margin %';

        }
        field(14021214; "NS_Change Request to Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Change Request to Job No.';
            Editable = false; //PE-193.PS.3.0 21Dec2023
            TableRelation = Job;
        }
        //PE-193.PS.1.0 16Oct2023 End 
        //PE-193.PS.3.0 21Dec2023 Start
        field(14021216; "NS_Change Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Merged to Change Order No.';
            Editable = false;
            TableRelation = Job;
        }
        //PE-193.PS.3.0 21Dec2023 End
        //PE-249.JS.1.0 08FEB2024 - Start
        field(14021225; "NS_Mandate Revenue Category"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mandate Revenue Category';
        }
        //PE-249.JS.1.0 08FEB2024 - end

        //PE-270.AS.1.0 START
        field(14021226; "NS_EnableOverrideForecastonJFW"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Override Forecast on JFW';
        }
        //PE-270.AS.1.0 END
        //PE-287.JS.1.0 18APR2024 - Start
        field(14021287; "NS_UpdJFWForecastCompCostOnJT"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable JFW Forecasted Completed Cost on JTL';

            trigger OnValidate()
            begin
                //PE-299.JS.1.0 21MAY2024-Start
                if NS_UpdJFWForecastCompCostOnJT = false then
                    "NS_Push-OrV2JFWForecastedonJTL" := false;
                //PE-299.JS.1.0 21MAY2024-end

                if rec.NS_UpdJFWForecastCompCostOnJT = true then
                    if (rec."NS_POC Method" <> rec."NS_POC Method"::" ") and
                        (rec."NS_POC Method" <> rec."NS_POC Method"::"NS_Job forecast") then
                        error('The POC Method of the job should be Blank or Job Forecast to modify the setup.');
            end;
        }
        //PE-287.JS.1.0 18APR2024 - end
        //PE-299.JS.1.0 17MAY024-Start
        field(14021286; "NS_Push-OrV2JFWForecastedonJTL"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Push Override Values to JFW Forecasted on JTL';

            trigger OnValidate()
            begin
                if "NS_Push-OrV2JFWForecastedonJTL" = true then begin
                    if NS_UpdJFWForecastCompCostOnJT = false then
                        error('Please ensure that "Enable JFW Forecasted Completed Cost on JTL" setup is enabled.');
                end;
            end;
        }
        //PE-299.JS.1.0 17MAY024-end 

        //PE-301.NC.1.0 10Jun2024 Start
        field(14021387; "NS_Pur/Sale UOM for B&B JPL"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pur/Sale UOM for B&B JPL';
        }
        //PE-301.NC.1.0 10Jun2024 End        

    }
    keys
    {
        key(Key1; "NS_Sub-Level to Job No.", "NS_Contract Date")
        {
        }
        key(Key2; "NS_Last Job For Job List")
        {
        }
        key(Key3; "NS_Manager Job Status")
        {
        }
        // PRJCTPR-197 DK.1.0 Start
        // key(Key4; "NS_Job Class", "NS_Job Type")
        // {
        // }
        key(Key5; "NS_Job Class", "NS_Job Type New")
        {
        }
        // PRJCTPR-197 DK.1.0 End
    }

    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    trigger OnBeforeDelete();
    var
        NS_JobTest: Record 167;
        JobPlanningLine: Record 1003;
        JobSegments: Record "NS_Job Takeoff Segments";
        PerctOfComp: Record "NS_Percentage of Completion";//CTSI-141
    begin
        //ProjectPro - start
        if Status = Status::Open then
            ERROR(Text14021100);

        if "NS_Job Class" = "NS_Job Class"::Template then
            if not CONFIRM(Text14021400, false, "No.", "NS_Job Class", "No.") then
                ERROR(Text14021401);

        NS_JobTest.RESET;
        NS_JobTest.SETCURRENTKEY("NS_Sub-Level to Job No.", "NS_Contract Date");
        NS_JobTest.SETRANGE("NS_Sub-Level to Job No.", "No.");
        if NS_JobTest.FINDFIRST then
            ERROR(Text14021102, NS_JobTest."No.");
        //ProjectPro - end
        //CTSI-141.ms.1.0 start
        PerctOfComp.Reset();
        PerctOfComp.SetRange("NS_Job No.", "No.");
        if PerctOfComp.FindFirst() then
            Error(text14021405);
        //CTSI-141.ms.1.0 end    
    end;

    trigger OnAfterDelete();
    var
        JobPlanningLine: Record 1003;
        JobSegments: Record "NS_Job Takeoff Segments";
        JobCostCat: Record "NS_Job Cost Category Price";
        TcostbyCode: Record "NS_Cost Cat by Code";//PRJ-1052.AS.1.0
        JobForct: Record "NS_Job Forecast";
    begin
        //ProjectPro - start
        JobPlanningLine.SETRANGE("Job No.", "No.");
        JobPlanningLine.DELETEALL;
        //ProjectPro - end

        //ProjectPro - start
        NS_JobLedgerEntry.RESET;
        NS_JobLedgerEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
        NS_JobLedgerEntry.SETRANGE("Job No.", "No.");
        IF NS_JobLedgerEntry.FindFirst() then      //PRJ-877.JS.1.0 20Aug2021
            NS_JobLedgerEntry.DELETEALL;

        NS_JobContact.RESET;
        NS_JobContact.SETCURRENTKEY("NS_Job No.", NS_Type, NS_Code);
        NS_JobContact.SETRANGE("NS_Job No.", "No.");
        NS_JobContact.DELETEALL;

        NS_JobLinks.DeleteJobLinks("No.");

        JobSegments.SETRANGE("NS_Job No.", "No.");
        JobSegments.DELETEALL;
        //ProjectPro - end
        //CTSI-131.MS.1.0 start
        JobCostCat.Reset();
        JobCostCat.SetRange("NS_Job No.", "No.");
        JobCostCat.DeleteAll();
        //CTSI-131.MS.1.0 end
        //PRJ-371.NK.1.0 12May2022 Start
        JobForct.Reset();
        JobForct.SetRange("NS_Job No.", "No.");
        JobForct.DeleteAll();
        //PRJ-371.NK.1.0 12May2022 End

        //PRJ-1052.AS.1.0 START
        TcostbyCode.Reset();
        TcostbyCode.SetRange("NS_Job No", "No.");
        TcostbyCode.DeleteAll();
        //PRJ-1052.AS.1.0 END
    end;

    trigger OnBeforeInsert();
    var
        NS_NoSeriesLine: Record 309;
        NS_NoSeriesRelationship: Record 310;
        SeriesMatchFound: Boolean;
        NS_JobTypes: Page "NS_Job Types List";
        NS_JobType: Record "NS_Job Type";
        q: Integer;
        JobsSetup2: Record "Jobs Setup";
    begin
        //PE-151.JS.1.0 28July2023 - Start below code commented
        // JobsSetup2.GET;
        // ProjectPro - start
        // PRJ-1368.GK.1.0 13June2022 start-Changes in code
        // if JobsSetup2."NS_Show Default task in Copy Job" = false then begin //PRJ-361.AS.2.0 11SEPT2020 - start
        //     if (not FromQuote) and (JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::Default) then
        //         if GUIALLOWED then   //PRJCTPR-50.JS.1.0 30JAN2023
        //             if CONFIRM(Text14021402, true) then begin
        //                 SkipTasks := false;
        //                 q := q;
        //             end else
        //                 SkipTasks := true;
        //     if (not FromQuote) and (JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::JobType) then
        //         if GUIALLOWED then   //PRJCTPR-50.JS.1.0 30JAN2023
        //             if CONFIRM(Text14021403Lbl, true) then begin
        //                 SkipTasks := false;
        //                 q := q;
        //                 if JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::JobType then begin
        //                     if NS_JobTypes.RUNMODAL = ACTION::OK then begin
        //                         NS_JobTypes.GETRECORD(NS_JobType);
        //                         PRJCTPR-197 Dk.1.0 Start
        //                         "NS_Job Type" := NS_JobType.NS_Code;
        //                         "NS_Job Type New" := NS_JobType.NS_Code;
        //                         PRJCTPR-197 Dk.1.0 End
        //                     end;
        //                 end;
        //             end else
        //                 SkipTasks := true;
        // end;//PRJ-361.AS.2.0 11SEPT2020 - end
        //PRJ-1368.GK.1.0 13June2022 end
        //PE-151.JS.1.0 28July2023 - end below code commented
        //ProjectPro - end
    end;

    trigger OnAfterInsert();
    var
        JobsSetup2: Record "Jobs Setup";
        //PE-151.JS.1.0 28July2023 - Start
        NS_NoSeriesLine: Record 309;
        NS_NoSeriesRelationship: Record 310;
        SeriesMatchFound: Boolean;
        NS_JobTypes: Page "NS_Job Types List";
        NS_JobType: Record "NS_Job Type";
        q: Integer;
    //PE-151.JS.1.0 28July2023 - end         
    begin
        Commit(); //PE-151.JS.1.0 28July2023 line added
        if JobsSetup2.Get() then;  //PE-151.JS.1.0 28July2023 line corrected old statement JobsSetup2.Get()    
        //PE-151.JS.1.0 28July2023 - Start
        if JobsSetup2."NS_Show Default task in Copy Job" = false then begin
            if (not FromQuote) and (JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::Default) then
                if GUIALLOWED then   //PRJCTPR-50.JS.1.0 30JAN2023
                    if CONFIRM(Text14021402, true) then begin
                        SkipTasks := false;
                        q := q;
                    end else
                        SkipTasks := true;
            if (not FromQuote) and (JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::JobType) then
                if GUIALLOWED then   //PRJCTPR-50.JS.1.0 30JAN2023
                    if CONFIRM(Text14021403Lbl, true) then begin
                        SkipTasks := false;
                        q := q;
                        if JobsSetup2."NS_Use Default Tasks" = JobsSetup2."NS_Use Default Tasks"::JobType then begin
                            if NS_JobTypes.RUNMODAL = ACTION::OK then begin
                                NS_JobTypes.GETRECORD(NS_JobType);
                                "NS_Job Type New" := NS_JobType.NS_Code; //PRJCTPR-225.NC.1.0 
                            end;
                        end;
                    end else
                        SkipTasks := true;
        end;
        //PE-151.JS.1.0 28July2023 - End
        //ProjectPro - start
        "NS_Forecast Type" := JobsSetup2."NS_Default Forecast Type";
        //PE-275.JS.1.0 20MAR2024 - start
        //PE-281.JS.1.0 18APR2024 - Start
        if JobsSetup2."NS_Job default POC Method" = JobsSetup2."NS_Job default POC Method"::" " then
            rec."NS_POC Method" := rec."NS_POC Method"::"NS_Job forecast"
        else
            rec."NS_POC Method" := JobsSetup2."NS_Job default POC Method";
        //PE-281.JS.1.0 18APR2024 - end
        rec."NS_Push-OrV2JFWForecastedonJTL" := JobsSetup2."NS_Push-OrV2JFWForecastedonJTL";   //PE-299.JS.1.0 17MAY2024
        if "NS_Contract Date" = 0D then
            "NS_Contract Date" := Workdate;
        //PE-275.JS.1.0 20MAR2024 - end            
        //PRJ-1299.JS.1.0 18APR2022 - Start        
        "NS_Mandate Revenue Category" := JobsSetup2."NS_Mandate Revenue Category";  //PE-249.JS.1.0 11FEB2024
        if JobsSetup2."NS_Forecast By Task Total" = true then
            Rec."NS_Forecast Method" := Rec."NS_Forecast Method"::"Job Forecast by Task Totals";
        //PRJ-1299.JS.1.0 18APR2022 - end    
        if JobsSetup2."NS_Show Default task in Copy Job" = false then begin //PRJ-361.AS.2.0 11SEPT2020 - start <<Added old code under condition
            NS_JobLinks.CreateJobLinks("No.", "NS_Sub-Level to Job No.");
            LoadTasks;
        end;//PRJ-361.AS.2.0 11SEPT2020 - end Added old code under condition>>
        //PRJ-923.GK.1.0 21Sep2021 start
        if JobsSetup2.Get() AND (JobsSetup2."NS_Gen. Bus. Posting Group" <> '') then //PRJ-1002.GK.1.0 21Oct2021 | Change Condition
            // Validate("NS_Gen. Bus. Posting Group", JobsSetup2."NS_Gen. Bus. Posting Group");//PRJ-831.AS.1.0 12OCT2021 Comment old
            Validate("NS_Gen. Bus. Posting Group New", JobsSetup2."NS_Gen. Bus. Posting Group");//PRJ-831.AS.1.0 12OCT2021 Add New
        //PRJ-923.GK.1.0 21Sep2021 end
        //PRJ-929.GK.1.0 22Sep2021 start
        if JobsSetup2."NS_Use Tax Percentage" <> 0 then
            Validate("NS_Use Tax Percentage", JobsSetup2."NS_Use Tax Percentage");
        Validate("NS_Use Job Plan. Line Entries", JobsSetup2."NS_Use Job Plan. Line Entries"); //PRJ-973.GK.1.0 13Oct2021
        //PRJ-929.GK.1.0 22Sep2021 end
        Modify(false); //SPLN1.00
        //ProjectPro - end
    end;

    var
        WIPQst: Text;
        NS_JobTaskNo: Code[20];
        NS_JobLinks: Record "NS_Job Links";
        NS_JobOperation: Record "NS_Job Operation";
        NS_JobTask: Record "Job Task";
        NS_JobProcess: Record "NS_Job Process";
        NS_JobActivity: Record "NS_Job Activity";
        NS_JobTaskCheck: Record "Job Task";
        NS_JobLedgerEntry: Record "Job Ledger Entry";
        NS_JobContact: Record "NS_Job Contact";
        NS_JobCostCategory: Record "NS_Job Cost Category";
        NS_GLSetup: Record "General Ledger Setup";
        NS_SalesSetup: Record "Sales & Receivables Setup";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
        SkipTasks: Boolean;
        FromQuote: Boolean;
        GLSetup: Record "General Ledger Setup";
        Text14021100: label 'Jobs with Status = Open cannot be deleted.';
        Text14021101: Label 'Unknown!';
        Text14021102: Label 'This job cannot be deleted because it has sub-level Job %1 attached to it.\You must delete the sub-level job first.';
        Text14021103: label 'Warning..  There is a Job Burden Multiplier of zero for\Resource=%1 Job=%2 Work Type= %3\\This may result in an incorrect value for the Job rate.';
        Text14021104: Label 'Would you like to copy job card information from job %1';
        Text14021105: label 'This job can not change status until the Indirect Burden Type has been set.';
        Text14021106: Label 'The Indirect Burden Type can not be changed after it has been set.';
        Text14021107: Label 'The %1 cannot be set the same as the Job %2.';
        text14021405: Label 'You can not delete this job because Project Summary Details line exist for this job';
        Text14021108: Label '29LAST';
        Text14021109: Label '30LAST';
        Text14021110: Label '31LAST';
        Text14021111: Label 'LAST';
        Text14021112: Label 'Valid values are 1 through 28, 29LAST, 30LAST, 31LAST and LAST';
        Text14021113: Label 'The original budget for this job already exists and can not be changed from here.';
        Text14021400: Label 'Job No. %1 is a %2 Job.\Are you SURE you want to delete Job No. %3';
        Text14021401: Label 'Action Cancelled by Request';
        //Text14021402: Label 'Do You want to Use Default Tasks of Type %1'; //PRJ-1368.RM.1.0 commented
        Text14021402: Label 'Do you want to use Default Tasks?'; //PRJ-1368.RM.1.0
        Text14021403Lbl: Label 'Do you want to use Default Tasks by Job Type ?', Comment = '%1=JobsSetup."Use Default Tasks"';  //PRJ-1368.GK.1.0 13June2022 

        NS_ConfirmMesssage: Label 'This will update all "Billable" & "Both Budget and Billable" Job Planning Lines with Type "G/L Account". Do you want to continue?';  //PRJ-973.GK.1.0 13Oct2021

        NS_Text14021410Lbl: Label 'Once the job is marked as Completed, it will be set to Revenue Recognized. Do you want to continue?';  //PE-287.JS.1.0 02MAY2024
        NS_Text14021411Lbl: Label 'The job is set to Revenue Recognized and changing the status will not remove this. Do you want to continue?';  //PE-287.JS.1.0 02MAY2024
        CopiedJob: Boolean;
        DisableLoadTasks: Boolean;
        SupressDefaultTasksDialog: Boolean;
        SupressDimConfirmDialogs: Boolean;
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        StatusChangeQst: Label 'This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?';
        AssociatedEntriesExistErr: Label 'You cannot change %1 because one or more entries are associated with this %2.';
        NSUserSetup: Record "User Setup"; //PRJCTPR-147.PS.2.20Sep2023

    PROCEDURE "MarkJobSub-Levels"(VAR ListOfJobs: Record 167; JobNo: Code[20]);
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        //This is a subroutine to MarkSub-Levels only
        IF JobNo > '' THEN
            WITH ListOfJobs DO BEGIN
                GET(JobNo);
                MARK(TRUE);
                NS_JobSearch.RESET;
                NS_JobSearch.SETRANGE("NS_Sub-Level to Job No.", JobNo);
                IF NS_JobSearch.FINDSET THEN
                    REPEAT
                        "MarkJobSub-Levels"(ListOfJobs, NS_JobSearch."No.");
                    UNTIL NS_JobSearch.NEXT = 0;
            END;
        //ProjectPro - end
    END;

    PROCEDURE BudgetedLaborHours(VAR Job: Record 167) Answer: Decimal;
    VAR
        NS_JobPlanningLine: Record 1003;
        NS_JobCostCategory: Record "NS_Job Cost Category";
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobPlanningLine DO BEGIN
            RESET;
            SETCURRENTKEY("Job No.", "NS_Subcontract No.", "NS_Entry Type", "Job Task No.",
                          "NS_Cost Category", Type, "No.", "Variant Code", "Planning Date", NS_Adjustment, "Line No.");
            SETRANGE("Job No.", Job."No.");
            SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);
            SETFILTER("NS_Cost Category", Job.GETFILTER("NS_Cost Category Filter"));
            SETFILTER("Planning Date", Job.GETFILTER("NS_Date Filter"));
            IF FINDSET THEN
                REPEAT
                    IF NS_JobCostCategory.NS_Code <> "NS_Cost Category" THEN
                        IF NS_JobCostCategory.GET("NS_Cost Category") THEN;
                    IF NS_JobCostCategory.NS_Code = "NS_Cost Category" THEN
                        IF NS_JobCostCategory.NS_Type = NS_JobCostCategory.NS_Type::Labor THEN BEGIN
                            Answer := Answer + Quantity;
                        END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE ActualLaborHours(VAR Job: Record 167) Answer: Decimal;
    VAR
        NS_JobLedgerEntry: Record 169;
        NS_JobCostCategory: Record "NS_Job Cost Category";
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobLedgerEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Job No.", "Entry Type", "NS_Activity Code", "NS_Process Code", "NS_Operation Code",
                          "NS_Job Cost Category", "NS_Job Revenue Category", Type, "No.", "Resource Group No.", "Posting Date");
            SETRANGE("Job No.", Job."No.");
            SETRANGE("Entry Type", "Entry Type"::Usage);
            SETFILTER("NS_Job Cost Category", Job.GETFILTER("NS_Cost Category Filter"));
            SETRANGE(Type, Type::Resource);
            SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
            IF FINDSET THEN
                REPEAT
                    IF NS_JobCostCategory.NS_Code <> "NS_Job Cost Category" THEN
                        IF NS_JobCostCategory.GET("NS_Job Cost Category") THEN;
                    IF NS_JobCostCategory.NS_Code = "NS_Job Cost Category" THEN
                        IF NS_JobCostCategory.NS_Type = NS_JobCostCategory.NS_Type::Labor THEN
                            Answer := Answer + Quantity;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE RetentionInvoiced(VAR Job: Record 167) Answer: Decimal;
    VAR
        NS_CustLedgEntry: Record 21;
        NS_SalesInvoiceLine: Record 113;
        NS_JobsSetup: Record 315;
        NS_SalesSetup: Record 311;
        NS_CorrectJob: Boolean;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        NS_JobsSetup.GET;
        NS_SalesSetup.GET;
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
            NS_CustLedgEntry.RESET;
            NS_CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
            NS_CustLedgEntry.SETRANGE("Customer No.", Job."Bill-to Customer No.");
            NS_CustLedgEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
            NS_CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
            IF NS_CustLedgEntry.FINDSET THEN
                REPEAT
                    NS_CorrectJob := FALSE;
                    NS_SalesInvoiceLine.RESET;
                    NS_SalesInvoiceLine.SETRANGE("Document No.", NS_CustLedgEntry."Document No.");
                    IF NS_SalesInvoiceLine.FINDSET THEN
                        REPEAT
                            IF NS_SalesInvoiceLine."Job No." = Job."No." THEN
                                NS_CorrectJob := TRUE;
                        UNTIL (NS_SalesInvoiceLine.NEXT = 0) OR NS_CorrectJob;
                    IF NS_CorrectJob THEN
                        Answer := Answer + NS_CustLedgEntry."Amount (LCY)";
                UNTIL NS_CustLedgEntry.NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE RetentionBalance(VAR Job: Record 167; RevenueCategory: Code[10]; JobTaskNo: Code[35]) Answer: Decimal;
    VAR
        NS_CustLedgEntry: Record 21;
        NS_SalesInvoiceLine: Record 113;
        NS_SalesCrMemoLine: Record 115;
        NS_SalesSetup: Record 311;
        NS_JobsSetup: Record 315;
        NS_ActivityCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SLActivityCode: Code[10];
        NS_SLProcessCode: Code[10];
        NS_SLOperationCode: Code[10];
        NS_SLSectionCode: Code[10];//PRJ-688.AM.1.0
        NS_AddInAmount: Decimal;
        NS_CorrectJob: Boolean;
    BEGIN
        //ProjectPro - start
        //This routine will return the balance of retention for a Job, Revenue Category, and Job Task.
        //This value is derived from the values in sales documents.
        Answer := 0;
        NS_JobsSetup.GET;
        NS_SalesSetup.GET;
        NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0
        IF NOT NS_SalesSetup."NS_Sales Retention Inactive" THEN BEGIN
            NS_CustLedgEntry.RESET;
            NS_CustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
            NS_CustLedgEntry.SETRANGE("Customer No.", Job."Bill-to Customer No.");
            NS_CustLedgEntry.SETFILTER("Posting Date", Job.GETFILTER("NS_Date Filter"));
            NS_CustLedgEntry.SETRANGE("NS_Retention Ledger Code", NS_JobsSetup."NS_Retention Receivable Ledger");
            IF NS_CustLedgEntry.FINDSET THEN
                REPEAT

                    //Look to see if this sales document is for the correct Job
                    NS_CorrectJob := TRUE;
                    CASE NS_CustLedgEntry."Document Type" OF
                        NS_CustLedgEntry."Document Type"::Invoice:
                            BEGIN
                                NS_SalesInvoiceLine.RESET;
                                NS_SalesInvoiceLine.SETRANGE("Document No.", NS_CustLedgEntry."Document No.");
                                IF NS_SalesInvoiceLine.FINDSET THEN
                                    REPEAT
                                        IF NS_SalesInvoiceLine."Job No." <> Job."No." THEN
                                            NS_CorrectJob := FALSE;
                                        IF (RevenueCategory > '') AND (NS_SalesInvoiceLine."NS_Job Revenue Category" <> RevenueCategory) THEN
                                            NS_CorrectJob := FALSE;
                                        NS_JobTaskNoToAPO(NS_SalesInvoiceLine."Job Task No.", NS_SLActivityCode, NS_SLProcessCode, NS_SLOperationCode, NS_SLSectionCode);//PRJ-688.AM.1.0
                                        IF (NS_ActivityCode > '') AND (NS_SLActivityCode <> NS_ActivityCode) THEN
                                            NS_CorrectJob := FALSE;
                                        IF (NS_ProcessCode > '') AND (NS_SLProcessCode <> NS_ProcessCode) THEN
                                            NS_CorrectJob := FALSE;
                                        IF (NS_OperationCode > '') AND (NS_SLOperationCode <> NS_OperationCode) THEN
                                            NS_CorrectJob := FALSE;
                                        IF (NS_SectionCode > '') AND (NS_SLSectionCode <> NS_SectionCode) THEN //PRJ-688.AM.1.0
                                            NS_CorrectJob := FALSE;//PRJ-688.AM.1.0
                                    UNTIL (NS_SalesInvoiceLine.NEXT = 0) OR NS_CorrectJob;
                                IF NS_CorrectJob THEN BEGIN
                                    NS_CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                    NS_AddInAmount := NS_CustLedgEntry."Remaining Amt. (LCY)";
                                END ELSE
                                    NS_AddInAmount := 0;
                            END;
                        NS_CustLedgEntry."Document Type"::"Credit Memo":
                            BEGIN
                                NS_SalesCrMemoLine.RESET;
                                NS_SalesCrMemoLine.SETRANGE("Document No.", NS_CustLedgEntry."Document No.");
                                IF NS_SalesCrMemoLine.FINDSET THEN
                                    REPEAT
                                        IF NS_SalesCrMemoLine."Job No." <> Job."No." THEN
                                            NS_CorrectJob := FALSE;
                                        IF (RevenueCategory > '') AND (NS_SalesCrMemoLine."NS_Job Revenue Category" <> RevenueCategory) THEN
                                            NS_CorrectJob := FALSE;
                                        NS_JobTaskNoToAPO(NS_SalesCrMemoLine."Job Task No.", NS_SLActivityCode, NS_SLProcessCode, NS_SLOperationCode, NS_SLSectionCode);//PRJ-688.AM.1.0
                                        IF (NS_ActivityCode > '') AND (NS_SLActivityCode <> NS_ActivityCode) THEN
                                            NS_CorrectJob := FALSE;
                                        IF (NS_ProcessCode > '') AND (NS_SLProcessCode <> NS_ProcessCode) THEN
                                            NS_CorrectJob := FALSE;
                                        IF (NS_OperationCode > '') AND (NS_SLOperationCode <> NS_OperationCode) THEN
                                            NS_CorrectJob := FALSE;
                                    UNTIL (NS_SalesCrMemoLine.NEXT = 0) OR NS_CorrectJob;
                                IF NS_CorrectJob THEN BEGIN
                                    NS_CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                                    NS_AddInAmount := -NS_CustLedgEntry."Remaining Amt. (LCY)";
                                END ELSE
                                    NS_AddInAmount := 0;
                            END;
                    END;

                    //If this CustLedgEntry is part of the Job, then add it in
                    IF NS_CorrectJob THEN BEGIN
                        Answer := Answer + NS_AddInAmount;
                    END;

                UNTIL NS_CustLedgEntry.NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE "MarkSub-Levels"(VAR Job: Record 167; "IncludeSub-Levels": Boolean);
    VAR
        NS_JobList: Record 167;
    BEGIN
        //ProjectPro - start
        //Make sure to Job.SETFILTER("No.",xxx) on master job number desired
        //     before calling this routine.
        //The master job passed in will be MARKED.
        //
        IF Job.GETFILTER("No.") > '' THEN
            WITH Job DO BEGIN
                CLEARMARKS;
                MARKEDONLY(FALSE);
                IF GETFILTERS() > '' THEN BEGIN
                    NS_JobList.RESET;
                    NS_JobList.COPYFILTERS(Job);
                    RESET;
                    IF NS_JobList.FINDSET THEN
                        REPEAT
                            IF "IncludeSub-Levels" THEN
                                "MarkJobSub-Levels"(Job, NS_JobList."No.")
                            ELSE BEGIN
                                GET(NS_JobList."No.");
                                MARK(TRUE);
                            END;
                        UNTIL NS_JobList.NEXT = 0;
                    MARKEDONLY(TRUE);
                END ELSE
                    IF "IncludeSub-Levels" THEN BEGIN
                        "MarkJobSub-Levels"(Job, Job."No.");
                        MARKEDONLY(TRUE);
                    END ELSE
                        SETRANGE("NS_Sub-Level to Job No.", '');
            END;
        //ProjectPro - end
    END;

    PROCEDURE NS_SLsBudgetedCost(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Cost (LCY)");
                        Answer := Answer + "NS_Budgeted Cost (LCY)" + NS_SLsBudgetedCost(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_LockedSLsBudgetedCost(VAR ParentJob: Record 167) Result: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Result := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Locked Budget Cost (LCY)");
                        Result := Result + "NS_Locked Budget Cost (LCY)" + NS_LockedSLsBudgetedCost(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;
    //PE-133.NC.1.0 21July2023 Start
    PROCEDURE NS_LockedSubLevelRevCost(VAR ParentJob: Record 167) Result: Decimal;
    VAR
        NS_JobSearch: Record 167;
        JobNoFilter: code[30];
    BEGIN
        if StrLen(format(ParentJob."No.")) < 18 then
            JobNoFilter := '@*' + format(ParentJob."No.") + '*'
        else
            JobNoFilter := format(ParentJob."No.");
        Result := 0;
        NS_JobSearch.RESET();
        NS_JobSearch.SETCURRENTKEY("NS_Sub-Level to Job No.");
        NS_JobSearch.SetFilter("NS_Sub-Level to Job No.", '%1', JobNoFilter);
        NS_JobSearch.SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
        NS_JobSearch.SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
        NS_JobSearch.SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
        NS_JobSearch.SetFilter(Status, '>=%1', NS_JobSearch.Status::Open);
        IF NS_JobSearch.FINDSET() THEN
            REPEAT
                NS_JobSearch.CALCFIELDS("NS_Locked Budget Price (LCY)");
                Result += NS_JobSearch."NS_Locked Budget Price (LCY)";
            UNTIL NS_JobSearch.NEXT() = 0;
    END;
    //PE-133.NC.1.0 21July2023 End
    PROCEDURE SLsBudgetedCostQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Cost Quantity");
                        Answer := Answer + "NS_Budgeted Cost Quantity" + SLsBudgetedCostQty(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;
    //PE-193.PS.3.0 28Dec2023 Start
    /// <summary>
    /// NS_ChangeRequestBillingprice.
    /// </summary>
    /// <param name="Var NS_JobChangeReq">Record Job.</param>
    /// <returns>Return variable ChangeRequesvaluePrice of type Decimal.</returns>
    procedure NS_ChangeRequestBillingprice(Var NS_JobChangeReq: Record Job) ChangeRequesvaluePrice: Decimal;
    var
        NS_JobChangeRequestvalue: Record Job;
    BEGIN
        ChangeRequesvaluePrice := 0;
        NS_JobChangeRequestvalue.Reset();
        NS_JobChangeRequestvalue.SetRange("NS_Change Request to Job No.", NS_JobChangeReq."No.");
        NS_JobChangeRequestvalue.SetRange("NS_Job Class", NS_JobChangeReq."NS_Job Class"::"Change Request");
        NS_JobChangeRequestvalue.SetFilter(Status, '%1|%2', NS_JobChangeRequestvalue.Status::Open, NS_JobChangeRequestvalue.Status::Planning);
        NS_JobChangeRequestvalue.SetFilter("NS_Manager Job Status", '<>%1', NS_JobChangeRequestvalue."NS_Manager Job Status"::Completed);
        if NS_JobChangeRequestvalue.FindSet() then begin
            repeat
                NS_JobChangeRequestvalue.CALCFIELDS("NS_Budgeted Price (LCY)");
                ChangeRequesvaluePrice += NS_JobChangeRequestvalue."NS_Budgeted Price (LCY)";
            UNTIL NS_JobChangeRequestvalue.Next = 0;
        end;
    end;


    procedure NS_ChangeRequestBillingCost(Var NS_ParentJobCost: Record Job) CHangeRequesvalueCost: Decimal;
    var
        NS_JobChangeReq: Record Job;
    BEGIN
        CHangeRequesvalueCost := 0;
        NS_JobChangeReq.Reset();
        NS_JobChangeReq.SetRange("NS_Change Request to Job No.", NS_ParentJobCost."No.");
        NS_JobChangeReq.SetRange("NS_Job Class", NS_JobChangeReq."NS_Job Class"::"Change Request");
        NS_JobChangeReq.SetFilter(Status, '%1|%2', NS_JobChangeReq.Status::Open, NS_JobChangeReq.Status::Planning);
        NS_JobChangeReq.SetFilter("NS_Manager Job Status", '<>%1', NS_JobChangeReq."NS_Manager Job Status"::Completed);
        if NS_JobChangeReq.FindSet() then begin
            repeat
                NS_JobChangeReq.CALCFIELDS("NS_Budgeted Cost (LCY)");
                CHangeRequesvalueCost += NS_JobChangeReq."NS_Budgeted Cost (LCY)";
            UNTIL NS_JobChangeReq.Next = 0;
        end;
    End;
    //PE-193.PS.3.0 28Dec2023 End

    PROCEDURE NS_SLsBudgetedPrice(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    SETFILTER("NS_Budget Type Filter", ParentJob.GETFILTER("NS_Budget Type Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Price (LCY)");
                        Answer := Answer + "NS_Budgeted Price (LCY)" + NS_SLsBudgetedPrice(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_LockedSLsBudgetedPrice(VAR ParentJob: Record 167) Result: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Result := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    SETFILTER("NS_Budget Type Filter", ParentJob.GETFILTER("NS_Budget Type Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Locked Budget Cost (LCY)");
                        Result := Result + "NS_Locked Budget Cost (LCY)" + NS_LockedSLsBudgetedCost(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsBudgetedPriceQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    SETFILTER("NS_Budget Type Filter", ParentJob.GETFILTER("NS_Budget Type Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Price Quantity");
                        Answer := Answer + "NS_Budgeted Price Quantity" + SLsBudgetedPriceQty(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_SLsBudgetedLaborHours(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
        NS_JobPlanningLine: Record 1003;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        NS_JobSearch.RESET;
        NS_JobSearch.SETCURRENTKEY("NS_Sub-Level to Job No.");
        NS_JobSearch.SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
        IF NS_JobSearch.FINDSET THEN
            REPEAT
                WITH NS_JobPlanningLine DO BEGIN
                    RESET;
                    SETCURRENTKEY("Job No.", "NS_Subcontract No.", "Job Task No.",
                                  "NS_Cost Category", Type, "No.", "Variant Code");
                    SETRANGE("Job No.", NS_JobSearch."No.");
                    SETFILTER("Planning Date", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER(NS_Adjustment, ParentJob.GETFILTER("NS_Adjustment Filter"));
                    SETRANGE("NS_Entry Type", "NS_Entry Type"::Cost);

                    IF FINDSET THEN
                        REPEAT
                            IF NS_JobCostCategory.NS_Code <> "NS_Cost Category" THEN
                                IF NS_JobCostCategory.GET("NS_Cost Category") THEN;
                            IF NS_JobCostCategory.NS_Code = "NS_Cost Category" THEN
                                IF NS_JobCostCategory.NS_Type = NS_JobCostCategory.NS_Type::Labor THEN
                                    IF NS_JobSearch.Status.AsInteger() >= Status::Order THEN
                                        Answer := Answer + Quantity;
                        UNTIL NEXT = 0;


                END;
                Answer := Answer + NS_SLsBudgetedLaborHours(NS_JobSearch);
            UNTIL NS_JobSearch.NEXT = 0;
        //ProjectPro - end
    END;

    PROCEDURE "SLsUsage(Cost)"(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    CALCFIELDS("NS_Usage (Cost) (LCY)");
                    Answer := Answer + "NS_Usage (Cost) (LCY)" + "SLsUsage(Cost)"(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsActualCostQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    CALCFIELDS("NS_Actual Cost Quantity(Usage)");
                    Answer := Answer + "NS_Actual Cost Quantity(Usage)" + SLsActualCostQty(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE "SLsUsage(Price)"(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            //PE-306.JS.1.0 06JUN2024-Start
            //NS_JobSearch.SETFILTER("NS_Type Filter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            NS_JobSearch.SETFILTER("NS_TypeEnumFilter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            //PE-306.JS.1.0 06JUN2024-end
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
            IF FINDSET THEN
                REPEAT
                    CALCFIELDS("NS_Usage (Price) (LCY)");
                    Answer := Answer + "NS_Usage (Price) (LCY)" + "SLsUsage(Price)"(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsActualPriceQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            //PE-306.JS.1.0 06JUN2024-Start
            //NS_JobSearch.SETFILTER("NS_Type Filter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            NS_JobSearch.SETFILTER("NS_TypeEnumFilter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            //PE-306.JS.1.0 06JUN2024-end
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
            IF FINDSET THEN
                REPEAT
                    CALCFIELDS("NS_Actual Price Quantity(Sale)");
                    Answer := Answer + "NS_Actual Price Quantity(Sale)" + SLsActualPriceQty(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsUsageLaborHours(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
        NS_JobLedgerEntry: Record 169;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        NS_JobSearch.RESET;
        NS_JobSearch.SETCURRENTKEY("NS_Sub-Level to Job No.");
        NS_JobSearch.SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
        IF NS_JobSearch.FINDSET THEN
            REPEAT
                WITH NS_JobLedgerEntry DO BEGIN
                    RESET;
                    SETCURRENTKEY("Job No.", "Job Task No.",
                                  "NS_Job Cost Category", "NS_Job Revenue Category", "Entry Type");
                    SETRANGE("Job No.", NS_JobSearch."No.");
                    SETFILTER("Posting Date", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Job Cost Category", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETRANGE(Type, Type::Resource);
                    SETRANGE("Entry Type", "Entry Type"::Usage);
                    IF FINDSET THEN
                        REPEAT
                            IF NS_JobCostCategory.NS_Code <> "NS_Job Cost Category" THEN
                                IF NS_JobCostCategory.GET("NS_Job Cost Category") THEN;
                            IF NS_JobCostCategory.NS_Code = "NS_Job Cost Category" THEN
                                IF NS_JobCostCategory.NS_Type = NS_JobCostCategory.NS_Type::Labor THEN
                                    IF NS_JobSearch.Status.AsInteger() > NS_JobSearch.Status::Planning.AsInteger() THEN
                                        Answer := Answer + Quantity;
                        UNTIL NEXT = 0;
                END;
                Answer := Answer + SLsUsageLaborHours(NS_JobSearch);
            UNTIL NS_JobSearch.NEXT = 0;
        //ProjectPro - end
    END;

    PROCEDURE SLsInvoicedPrice(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            //PE-306.JS.1.0 06JUN2024-Start
            //NS_JobSearch.SETFILTER("NS_Type Filter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            NS_JobSearch.SETFILTER("NS_TypeEnumFilter", '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
            //PE-306.JS.1.0 06JUN2024-end
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
            IF FINDSET THEN
                REPEAT
                    CALCFIELDS("NS_Invoiced Price (LCY)");
                    Answer := Answer + "NS_Invoiced Price (LCY)" + SLsInvoicedPrice(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsPaymentReceived(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            SETRANGE("NS_Entry Type Filter", NS_JobLedgerEntry."Entry Type"::NS_Payment);
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            IF FINDSET THEN
                REPEAT
                    CALCFIELDS("NS_Amt. Paid (LCY)");
                    Answer := Answer + "NS_Amt. Paid (LCY)" + SLsPaymentReceived(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsPaymentsMade(VAR ParentJob: Record 167; DocumentNo: Code[20]) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
        NS_ParentVendorLedgEntry: Record 25;
        NS_VendorLedgEntry: Record 25;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            NS_ParentVendorLedgEntry.RESET;
            NS_ParentVendorLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
            NS_ParentVendorLedgEntry.SETRANGE("Document No.", DocumentNo);
            NS_ParentVendorLedgEntry.SETRANGE("Document Type", NS_ParentVendorLedgEntry."Document Type"::Payment);
            IF NS_ParentVendorLedgEntry.FINDFIRST THEN;

            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    NS_VendorLedgEntry.RESET;
                    NS_VendorLedgEntry.SETCURRENTKEY("NS_Job No.", "Vendor No.");
                    NS_VendorLedgEntry.SETRANGE("NS_Job No.", "No.");
                    NS_VendorLedgEntry.SETRANGE("Vendor No.", NS_ParentVendorLedgEntry."Vendor No.");
                    IF NS_VendorLedgEntry.FINDSET THEN
                        REPEAT
                            NS_VendorLedgEntry.CALCFIELDS(Amount);
                            Answer := Answer + NS_VendorLedgEntry.Amount;
                        UNTIL NS_VendorLedgEntry.NEXT = 0;
                    Answer := Answer + SLsPaymentsMade(NS_JobSearch, DocumentNo);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsBudgetedResQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Res. Qty.");
                        IF Status.AsInteger() > Status::Planning.AsInteger() THEN
                            Answer := Answer + "NS_Budgeted Res. Qty." + SLsBudgetedResQty(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsBudgetedResGrQty(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Adjustment Filter", ParentJob.GETFILTER("NS_Adjustment Filter"));
                    IF Status.AsInteger() >= Status::Open.AsInteger() THEN BEGIN
                        CALCFIELDS("NS_Budgeted Res. Gr. Qty.");
                        IF Status.AsInteger() > Status::Planning.AsInteger() THEN
                            Answer := Answer + "NS_Budgeted Res. Gr. Qty." + SLsBudgetedResGrQty(NS_JobSearch);
                    END;
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRetentionInvoiced(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
            IF FINDSET THEN
                REPEAT
                    Answer := Answer + RetentionInvoiced(NS_JobSearch) + SLsRetentionInvoiced(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRetentionBalance(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    Answer := Answer + RetentionBalance(NS_JobSearch, '', '') + SLsRetentionBalance(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsWIPCosts(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Usage));
                    CALCFIELDS("Total WIP Cost Amount");
                    Answer := Answer + "Total WIP Cost Amount" + SLsWIPCosts(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsWIPSales(VAR ParentJOb: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJOb."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJOb.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJOb.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Sale));
                    CALCFIELDS("Total WIP Sales Amount");
                    Answer := Answer + "Total WIP Sales Amount" + SLsWIPSales(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsWIPCostsGL(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Usage));
                    CALCFIELDS("Total WIP Cost G/L Amount");
                    Answer := Answer + "Total WIP Cost G/L Amount" + SLsWIPCostsGL(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsWIPSalesGL(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Sale));
                    CALCFIELDS("Total WIP Sales G/L Amount");
                    Answer := Answer + "Total WIP Sales G/L Amount" + SLsWIPSalesGL(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRecogCosts(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Usage));
                    CALCFIELDS("Recog. Costs Amount");
                    Answer := Answer + "Recog. Costs Amount" + SLsRecogCosts(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRecogSales(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Sale));
                    CALCFIELDS("Recog. Sales Amount");
                    Answer := Answer + "Recog. Sales Amount" + SLsRecogSales(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRecogCostsGL(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Cost Category Filter", ParentJob.GETFILTER("NS_Cost Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Usage));
                    CALCFIELDS("Recog. Costs G/L Amount");
                    Answer := Answer + "Recog. Costs G/L Amount" + SLsRecogCostsGL(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE SLsRecogSalesGL(VAR ParentJob: Record 167) Answer: Decimal;
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := 0;
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJob."No.");
            IF FINDSET THEN
                REPEAT
                    SETFILTER("NS_Date Filter", ParentJob.GETFILTER("NS_Date Filter"));
                    SETFILTER("NS_Revenue Category Filter", ParentJob.GETFILTER("NS_Revenue Category Filter"));
                    SETFILTER("NS_Entry Type Filter", FORMAT("NS_Entry Type Filter"::Sale));
                    CALCFIELDS("Recog. Sales G/L Amount");
                    Answer := Answer + "Recog. Sales G/L Amount" + SLsRecogSalesGL(NS_JobSearch);
                UNTIL NEXT = 0;
        END;
        //ProjectPro - end
    END;

    PROCEDURE CalculatedPercentComplete(VAR Job: Record 167; "IncludeSub-Levels": Boolean): Decimal;
    VAR
        NS_ActualCost: Decimal;
        NS_SubLevelsCost: Decimal;
        NS_PctComplete: Decimal;
    BEGIN
        //ProjectPro - start
        Job.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Usage (Cost) (LCY)");
        NS_ActualCost := Job."NS_Usage (Cost) (LCY)";

        //Find Revisions Cost and Price
        IF "IncludeSub-Levels" THEN
            NS_SubLevelsCost := NS_SLsBudgetedCost(Job)
        ELSE
            NS_SubLevelsCost := 0;
        IF "NS_Budgeted Cost (LCY)" + NS_SubLevelsCost <> 0 THEN
            NS_PctComplete := ROUND((NS_ActualCost / (Job."NS_Budgeted Cost (LCY)" + NS_SubLevelsCost)), 0.0001)
        ELSE
            NS_PctComplete := 0;

        NS_PctComplete := NS_PctComplete * 100;
        EXIT(NS_PctComplete);
        //ProjectPro - end
    END;

    PROCEDURE NS_SeparatorCount(JobNo: Code[20]) SepCount: Integer;
    VAR
        NS_JobsSetup: Record 315;
        i: Integer;
    BEGIN
        //ProjectPro - start
        SepCount := 0;

        IF NS_JobsSetup."NS_Job No. Separators" = '' THEN
            NS_JobsSetup.GET;

        IF NS_JobsSetup."NS_Job No. Separators" > '' THEN
            FOR i := 1 TO STRLEN(JobNo) DO BEGIN
                IF STRPOS(NS_JobsSetup."NS_Job No. Separators", COPYSTR(JobNo, i, 1)) > 0 THEN
                    SepCount := SepCount + 1;
            END;
        //ProjectPro - end
    END;

    PROCEDURE ParentJobNo(JobNo: Code[20]) ParentJob: Code[20];
    VAR
        NS_JobsSetup: Record 315;
        NS_TotalSepCount: Integer;
        i: Integer;
    BEGIN
        //ProjectPro - start
        ParentJob := '';

        IF JobNo > '' THEN BEGIN
            NS_TotalSepCount := NS_SeparatorCount(JobNo);

            NS_JobsSetup.GET;

            IF NS_JobsSetup."NS_Job No. Separators" > '' THEN
                FOR i := 1 TO STRLEN(JobNo) DO BEGIN
                    IF NS_SeparatorCount(COPYSTR(JobNo, 1, i)) = NS_TotalSepCount THEN BEGIN
                        ParentJob := COPYSTR(JobNo, 1, i - 1);
                        i := STRLEN(JobNo);
                    END;
                END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_SetLastJobListFlag();
    VAR
        NS_JobToModify: Record 167;
        NS_LastJobNo: Code[20];
    BEGIN
        //ProjectPro - start
        WITH Job DO BEGIN
            NS_LastJobNo := '';

            //Find the last master Job
            RESET;
            IF FINDSET THEN BEGIN
                IF NS_SeparatorCount("No.") = 0 THEN BEGIN
                    REPEAT
                        NS_LastJobNo := "No.";
                    UNTIL (NEXT = 0) OR (NS_SeparatorCount("No.") > 0);
                END;
            END;

            //Now look for the last subJob for the master just found
            NS_LastJobNo := FindLastJobNo(NS_LastJobNo);

            IF NS_LastJobNo > '' THEN BEGIN
                GET(NS_LastJobNo);

                //Check if the Job is already flagged
                IF NOT "NS_Last Job For Job List" THEN BEGIN
                    //Clear out any previously flagged last Job
                    RESET;
                    SETCURRENTKEY("NS_Last Job For Job List");
                    SETRANGE("NS_Last Job For Job List", TRUE);
                    IF FINDSET THEN
                        REPEAT
                            NS_JobToModify.GET("No.");
                            NS_JobToModify."NS_Last Job For Job List" := FALSE;
                            NS_JobToModify.MODIFY;
                        UNTIL NEXT = 0;

                    //Now set the new last Job
                    GET(NS_LastJobNo);
                    "NS_Last Job For Job List" := TRUE;
                    MODIFY;
                END;
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE FindLastJobNo(ParentJbNo: Code[20]) Answer: Code[20];
    VAR
        NS_JobSearch: Record 167;
    BEGIN
        //ProjectPro - start
        Answer := '';
        WITH NS_JobSearch DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Sub-Level to Job No.");
            SETRANGE("NS_Sub-Level to Job No.", ParentJbNo);
            IF FINDSET THEN
                REPEAT
                    Answer := "No.";
                UNTIL NEXT = 0;
            IF Answer > '' THEN
                Answer := FindLastJobNo(Answer)
            ELSE
                Answer := ParentJbNo;
        END;
        //ProjectPro - end
    END;

    PROCEDURE GetJobResourceCost(ResourceNo: Code[20]; CostCategory: Code[10]; JobNo: Code[20]; JobTaskNo: Code[35]; WorkType: Code[10]; CurrencyCode: Code[10]; RateType: Integer): Decimal;
    VAR
        NS_ParentJob: Record 167;
        NS_Resource: Record 156;
        NS_ResourceGroup: Record 152;
        NS_JobsSetup: Record 315;
        NS_JobResourcePrice: Record 1012;
        NS_JobPlanningLine: Record 1003;
        NS_JobTask: Code[35];
        NS_ActivityCode: Code[10];
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_ResourceGroupCode: Code[20];
        NS_RateOut: Decimal;
        NS_Level: Integer;
        NS_Found: Boolean;
    BEGIN
        //ProjectPro - start
        //RateType Requested 1 - Job Labor Rate
        //                   2 - Burdened Job Labor Rate

        //The rate is tried in the following order:
        //
        // Look at the specific Resource for the Job
        //
        //  1.  Look for the specific ResourceNo in the specific JobNo in the Job Card on the Cost/Price button
        //        Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //  2.  Look at each level of Activity/Process/Operation
        //        Within each of these levels
        //          Look for the specific ResourceNo in the specific JobNo in the Planning Lines
        //          Look for the specific ResourceNo's Resource Group in the specific JobNo in the Planning Lines
        //  3.  Look in the parents of the JobNo for the specific ResourceNo
        //        Look for the specific ResourceNo in the specific JobNo in the Job Card on the Cost/Price button
        //          Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //        Look at each level of Activity/Process/Operation
        //          Within each of these levels
        //            Look for the specific ResourceNo in the specific JobNo in the Planning Lines
        //            Look for the specific ResourceNo's Resource Group in the specific JobNo in the Planning Lines
        //
        // Look in ANY Job
        //
        //  4.  Look for the Specific ResourceGroupNo for a blank (any) Job
        //  5.  Look for the Specific ResourceNo for a blank (any) Job
        //
        //If not found at this point then a zero will be returned and
        //   the calling routine's default behavior should be used.

        NS_RateOut := 0;
        NS_Found := FALSE;

        NS_JobsSetup.GET;
        NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0
        NS_JobTask := JobTaskNo;

        IF NS_Resource.GET(ResourceNo) AND Job.GET(JobNo) THEN BEGIN

            // CASE 1
            //Look for this Resource, for this specific Job.
            IF NS_JobResourcePrice.GET(JobNo, NS_JobTask, NS_JobResourcePrice.Type::Resource, ResourceNo, WorkType, CurrencyCode) THEN BEGIN
                NS_Found := TRUE;
                NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
            END;

            IF (NOT NS_Found) AND (NS_OperationCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', NS_SectionCode);//PRJ-688.AM.1.0
                IF NS_JobResourcePrice.GET(JobNo, NS_JobTask, NS_JobResourcePrice.Type::Resource, ResourceNo, WorkType, CurrencyCode) THEN BEGIN
                    NS_Found := TRUE;
                    NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ProcessCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', NS_SectionCode);//PRJ-688.AM.1.0
                IF NS_JobResourcePrice.GET(JobNo, NS_JobTask, NS_JobResourcePrice.Type::Resource, ResourceNo, WorkType, CurrencyCode) THEN BEGIN
                    NS_Found := TRUE;
                    NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ActivityCode > '') THEN BEGIN
                NS_JobTask := '';
                IF NS_JobResourcePrice.GET(JobNo, NS_JobTask, NS_JobResourcePrice.Type::Resource, ResourceNo, WorkType, CurrencyCode) THEN BEGIN
                    NS_Found := TRUE;
                    NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
                END;
            END;

            // CASE 2
            IF NOT NS_Found THEN BEGIN
                NS_JobTask := JobTaskNo;
                NS_ResourceGroupCode := NS_Resource."Resource Group No.";
                NS_Level := 4;
                NS_JobPlanningLine.RESET;
                NS_JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Subcontract No.", "Job Task No.", "NS_Cost Category", Type, "No.", "Variant Code");
                NS_JobPlanningLine.SETRANGE("Job No.", JobNo);
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                NS_JobPlanningLine.SETRANGE("NS_Cost Category", CostCategory);
                REPEAT
                    //Resource
                    NS_JobPlanningLine.SETRANGE(Type, NS_JobPlanningLine.Type::Resource);
                    NS_JobPlanningLine.SETRANGE("No.", ResourceNo);
                    IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                        NS_Found := TRUE;
                        NS_RateOut := NS_JobPlanningLine."Unit Cost";
                    END;

                    IF NOT NS_Found THEN BEGIN
                        //Resource Group
                        NS_JobPlanningLine.SETRANGE(Type, NS_JobPlanningLine.Type::"NS_Resource (Group)");
                        NS_JobPlanningLine.SETRANGE("No.", NS_ResourceGroupCode);
                        IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                            NS_Found := TRUE;
                            NS_RateOut := NS_JobPlanningLine."Unit Cost";
                        END;
                    END;

                    IF NOT NS_Found THEN BEGIN
                        NS_Level := NS_Level - 1;
                        CASE NS_Level OF
                            3:
                                BEGIN
                                    NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', '');//PRJ-688.AM.1.0
                                    NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                                END;
                            2:
                                BEGIN
                                    NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', '');//PRJ-688.AM.1.0
                                    NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                                END;
                            1:
                                BEGIN
                                    NS_JobTask := '';
                                    NS_JobPlanningLine.SETRANGE("Job Task No.");
                                END;
                            0:
                                ;
                        END;
                    END;

                UNTIL NS_Found OR (NS_Level = 0);
            END;

            // CASE 3
            IF (NOT NS_Found) AND (Job."NS_Sub-Level to Job No." > '') THEN
                IF NS_ParentJob.GET(NS_ParentJob."NS_Sub-Level to Job No.") THEN BEGIN
                    JobNo := NS_ParentJob."No.";
                    NS_RateOut := GetJobResourceCost(ResourceNo, CostCategory, JobNo, JobTaskNo, WorkType, CurrencyCode, RateType);
                    IF NS_RateOut > 0 THEN
                        NS_Found := TRUE;
                END;

            // CASE 4
            IF NOT NS_Found THEN BEGIN
                NS_JobResourcePrice.RESET;
                NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::"Group(Resource)");
                NS_JobResourcePrice.SETRANGE(Code, NS_ResourceGroupCode);
                IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
                END;
            END;

            // CASE 5
            IF NOT NS_Found THEN BEGIN
                NS_JobResourcePrice.RESET;
                NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::Resource);
                NS_JobResourcePrice.SETRANGE(Code, ResourceNo);
                IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_RateOut := NS_JobResourcePrice."NS_Unit Cost";
                END;
            END;
        END;

        //Now return the correct rate based on the RateType requested
        IF NS_Found AND (RateType = 2) THEN BEGIN
            IF NS_JobsSetup."NS_Post Labor Burden RateToJob" THEN BEGIN
                IF (NS_JobResourcePrice."NS_Cost Burden Multiplier" = 0) AND
                   (NS_JobsSetup."NS_Warning on Zero Multiplier") THEN
                    MESSAGE(Text14021103, NS_JobResourcePrice.Code, NS_JobResourcePrice."Job No.", NS_JobResourcePrice."Work Type Code");
                NS_GLSetup.GET;
                NS_RateOut := ROUND(NS_JobResourcePrice."Unit Cost Factor" * NS_JobResourcePrice."NS_Cost Burden Multiplier",
                                    NS_GLSetup."Amount Rounding Precision");
            END;
        END;

        EXIT(NS_RateOut);
        //ProjectPro - end
    END;

    PROCEDURE GetJobItemCost(ItemNo: Code[20]; VariantCode: Code[10]; CostCategory: Code[10]; UnitOfMeasureCode: Code[10]; JobNo: Code[20]; JobTaskNo: Code[35]; CurrencyCode: Code[10]): Decimal;
    VAR
        NS_ParentJob: Record 167;
        NS_Item: Record 27;
        NS_JobsSetup: Record 315;
        NS_JobItemPrice: Record 1013;
        NS_JobPlanningLine: Record 1003;
        NS_JobTask: Code[35];
        NS_ActivityCode: Code[10];
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_CostOut: Decimal;
        NS_Found: Boolean;
    BEGIN
        //ProjectPro - start
        //The item Cost is tried in the following order:
        //  1.  Look for the specific ItemNo in the specific JobNo in the Job Card on the Cost/Price Button
        //        Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //  2.  Look for the specific ItemNo in the specific JobNo in the Planning Lines
        //        Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //  3.  Look in the parents of the JobNo for the specific ItemNo
        //      In each parent:
        //        First Look for the specific ItemNo in the specific JobNo in the Job Card on the Cost/Price Button
        //          Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //        Then Look for the specific ItemNo in the specific JobNo in the Planning Lines
        //          Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //
        //If not found at this point then a zero will be returned and
        //   the calling routine's default behavior should be used.

        NS_CostOut := 0;
        NS_Found := FALSE;

        NS_JobsSetup.GET;
        NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0
        NS_JobTask := JobTaskNo;

        IF NS_Item.GET(ItemNo) AND Job.GET(JobNo) THEN BEGIN

            //Job's Cost/Price
            IF NS_JobItemPrice.GET(JobNo, NS_JobTask, ItemNo, VariantCode, UnitOfMeasureCode, CurrencyCode, NS_JobItemPrice.NS_Type::Item) THEN BEGIN
                NS_Found := TRUE;
                NS_CostOut := NS_JobItemPrice."NS_Unit Cost";
            END;

            IF (NOT NS_Found) AND (NS_OperationCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', '');//PRJ-688.AM.1.0
                IF NS_JobItemPrice.GET(JobNo, NS_JobTask, ItemNo, VariantCode, UnitOfMeasureCode, CurrencyCode, NS_JobItemPrice.NS_Type::Item) THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobItemPrice."NS_Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ProcessCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', '');//PRJ-688.AM.1.0
                IF NS_JobItemPrice.GET(JobNo, NS_JobTask, ItemNo, VariantCode, UnitOfMeasureCode, CurrencyCode, NS_JobItemPrice.NS_Type::Item) THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobItemPrice."NS_Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ActivityCode > '') THEN BEGIN
                NS_JobTask := '';
                IF NS_JobItemPrice.GET(JobNo, NS_JobTask, ItemNo, VariantCode, UnitOfMeasureCode, CurrencyCode, NS_JobItemPrice.NS_Type::Item) THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobItemPrice."NS_Unit Cost";
                END;
            END;

            //Job's Planning Lines
            IF NOT NS_Found THEN BEGIN
                NS_JobTask := JobTaskNo;
                NS_JobPlanningLine.RESET;
                NS_JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Subcontract No.", "Job Task No.", "NS_Cost Category", Type, "No.", "Variant Code");
                NS_JobPlanningLine.SETRANGE("Job No.", JobNo);
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                NS_JobPlanningLine.SETRANGE("NS_Cost Category", CostCategory);
                NS_JobPlanningLine.SETRANGE(Type, NS_JobPlanningLine.Type::Item);
                NS_JobPlanningLine.SETRANGE("No.", ItemNo);
                NS_JobPlanningLine.SETRANGE("Variant Code", VariantCode);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_OperationCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', '');//PRJ-688.AM.1.0
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ProcessCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', '');//PRJ-688.AM.1.0
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ActivityCode > '') THEN BEGIN
                NS_JobTask := '';
                NS_JobPlanningLine.SETRANGE("Job Task No.");
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            //Parent Jobs
            IF (NOT NS_Found) AND (Job."NS_Sub-Level to Job No." > '') THEN
                IF NS_ParentJob.GET(NS_ParentJob."NS_Sub-Level to Job No.") THEN BEGIN
                    JobNo := NS_ParentJob."No.";
                    NS_CostOut := GetJobItemCost(ItemNo, VariantCode, CostCategory, UnitOfMeasureCode, JobNo, JobTaskNo, CurrencyCode);
                END;
        END;

        EXIT(NS_CostOut);
        //ProjectPro - end
    END;

    PROCEDURE GetJobGLCost(GLNo: Code[20]; CostCategory: Code[10]; JobNo: Code[20]; JobTaskNo: Code[35]; CurrencyCode: Code[10]): Decimal;
    VAR
        NS_ParentJob: Record 167;
        NS_GLAccount: Record 15;
        NS_JobsSetup: Record 315;
        NS_JobGLAccountPrice: Record 1014;
        NS_JobPlanningLine: Record 1003;
        NS_JobTask: Code[35];
        NS_ActivityCode: Code[10];
        NS_ProcessCode: Code[10];
        NS_OperationCode: Code[10];
        NS_SectionCode: Code[10];//PRJ-688.AM.1.0
        NS_CostOut: Decimal;
        NS_Found: Boolean;
    BEGIN
        //ProjectPro - start
        //The item Cost is tried in the following order:
        //  1.  Look for the specific GLNo in the specific JobNo in the Job Card on the Cost/Price Button
        //        Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //  2.  Look for the specific GLNo in the specific JobNo in the Planning Lines
        //        Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //  3.  Look in the parents of the JobNo for the specific GLNo
        //      In each parent:
        //        First Look for the specific GLNo in the specific JobNo in the Job Card on the Cost/Price Button
        //          Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //        Then Look for the specific GLNo in the specific JobNo in the Planning Lines
        //          Within this search look at the three levels of Activity/Process/Operation.  Select the Cost that most closely matches.
        //
        //If not found at this point then a zero will be returned and
        //   the calling routine's default behavior should be used.

        NS_CostOut := 0;
        NS_Found := FALSE;

        NS_JobsSetup.GET;
        NS_JobTaskNoToAPO(JobTaskNo, NS_ActivityCode, NS_ProcessCode, NS_OperationCode, NS_SectionCode);//PRJ-688.AM.1.0
        NS_JobTask := JobTaskNo;

        IF NS_GLAccount.GET(GLNo) AND Job.GET(JobNo) THEN BEGIN

            //Job's Cost/Price
            NS_JobGLAccountPrice.RESET;
            NS_JobGLAccountPrice.SETRANGE("Job No.", JobNo);
            NS_JobGLAccountPrice.SETRANGE("Job Task No.", NS_JobTask);
            NS_JobGLAccountPrice.SETRANGE("G/L Account No.", GLNo);
            NS_JobGLAccountPrice.SETRANGE("Currency Code", CurrencyCode);
            IF NS_JobGLAccountPrice.FINDLAST THEN BEGIN
                NS_Found := TRUE;
                NS_CostOut := NS_JobGLAccountPrice."Unit Cost";
            END;

            IF (NOT NS_Found) AND (NS_OperationCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', '');//PRJ-688.AM.1.0
                NS_JobGLAccountPrice.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobGLAccountPrice.FINDLAST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobGLAccountPrice."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ProcessCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', '');//PRJ-688.AM.1.0
                NS_JobGLAccountPrice.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobGLAccountPrice.FINDLAST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobGLAccountPrice."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ActivityCode > '') THEN BEGIN
                NS_JobTask := '';
                NS_JobGLAccountPrice.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobGLAccountPrice.FINDLAST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobGLAccountPrice."Unit Cost";
                END;
            END;

            //Job's Planning Lines
            IF NOT NS_Found THEN BEGIN
                NS_JobTask := JobTaskNo;
                NS_JobPlanningLine.RESET;
                NS_JobPlanningLine.SETCURRENTKEY("Job No.", "NS_Subcontract No.", "Job Task No.", "NS_Cost Category", Type, "No.", "Variant Code");
                NS_JobPlanningLine.SETRANGE("Job No.", JobNo);
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                NS_JobPlanningLine.SETRANGE("NS_Cost Category", CostCategory);
                NS_JobPlanningLine.SETRANGE(Type, NS_JobPlanningLine.Type::"G/L Account");
                NS_JobPlanningLine.SETRANGE("No.", GLNo);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_OperationCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, NS_ProcessCode, '', '');//PRJ-688.AM.1.0
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ProcessCode > '') THEN BEGIN
                NS_JobTask := APOToJobTaskNo(NS_ActivityCode, '', '', '');//PRJ-688.AM.1.0
                NS_JobPlanningLine.SETRANGE("Job Task No.", NS_JobTask);
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            IF (NOT NS_Found) AND (NS_ActivityCode > '') THEN BEGIN
                NS_JobTask := '';
                NS_JobPlanningLine.SETRANGE("Job Task No.");
                IF NS_JobPlanningLine.FINDFIRST THEN BEGIN
                    NS_Found := TRUE;
                    NS_CostOut := NS_JobPlanningLine."Unit Cost";
                END;
            END;

            //Parent Jobs
            IF (NOT NS_Found) AND (Job."NS_Sub-Level to Job No." > '') THEN
                IF NS_ParentJob.GET(NS_ParentJob."NS_Sub-Level to Job No.") THEN BEGIN
                    JobNo := NS_ParentJob."No.";
                    NS_CostOut := GetJobGLCost(GLNo, CostCategory, JobNo, JobTaskNo, CurrencyCode);
                END;
        END;

        EXIT(NS_CostOut);
        //ProjectPro - end
    END;

    PROCEDURE CorrectForBlankFields(VAR JobNo: Code[20]; VAR SubCont: Code[20]; VAR CostCat: Code[10]; VAR RevCat: Code[10]; VAR JobTaskNo: Code[10]);
    BEGIN
        //ProjectPro - start
        //This routine will keep consistency amoung the various fields.
        //
        //So there can be no "Job Task No." if there is no "Job No."
        //   there can be no "Cost Category" if there is no "Job No."

        //Sometimes not all fields are avaiable.  For example "Subcontract No." is generally not available
        //  in the sales area.  For a call in that area substitute "Job No." again for the "Subcontract No."
        //  parameter.  Cost and Reveneue category have also been duplicated in this manner in other areas.

        IF (JobNo = '') AND (SubCont = '') THEN BEGIN
            SubCont := '';
            CostCat := '';
            RevCat := '';
            JobTaskNo := '';
        END;
        //ProjectPro - end
    END;

    PROCEDURE JobTaskNoSeparatorCount(JobTaskNo: Code[35]) SepCount: Integer;
    VAR
        NS_JobsSetup: Record 315;
        i: Integer;
    BEGIN
        //ProjectPro - start
        SepCount := 0;

        IF NS_JobsSetup."NS_APO Separators" = '' THEN
            NS_JobsSetup.GET;

        IF NS_JobsSetup."NS_APO Separators" > '' THEN
            FOR i := 1 TO STRLEN(JobTaskNo) DO BEGIN
                IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 THEN
                    SepCount := SepCount + 1;
            END;
        //ProjectPro - end
    END;

    PROCEDURE NS_JobTaskNoToAPO(JobTaskNo: Code[35]; VAR ActivityCode: Code[10]; VAR ProcessCode: Code[10]; VAR OperationCode: Code[10]; VAR SectionCode: Code[10]);//PRJ-688.AM.1.0
    VAR
        NS_JobsSetup: Record 315;
        NS_Segment1: Text[30];
        NS_Segment2: Text[30];
        NS_Segment3: Text[30];
        NS_Segment4: Text[30];
        i: Integer;
        j: Integer;
        k: Integer;
    BEGIN
        //ProjectPro - start
        //The double COPYSTRs in this routine are to ensure that the APO codes are only 10 characters long reguardless
        //    of how many characters between the separaters there may be.

        ActivityCode := '';
        ProcessCode := '';
        OperationCode := '';
        SectionCode := '';//PRJ-688.AM.1.0
        NS_Segment1 := '';
        NS_Segment2 := '';
        NS_Segment3 := '';
        NS_Segment4 := '';

        IF NS_JobsSetup."NS_APO Separators" = '' THEN
            NS_JobsSetup.GET;

        CASE JobTaskNoSeparatorCount(JobTaskNo) OF
            0:
                NS_Segment1 := COPYSTR(JobTaskNo, 1, 10);
            1:
                FOR i := 1 TO STRLEN(JobTaskNo) DO
                    IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 THEN BEGIN
                        NS_Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                        NS_Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, STRLEN(JobTaskNo) - i), 1, 10);
                        i := STRLEN(JobTaskNo);
                    END;
            2:
                FOR i := 1 TO STRLEN(JobTaskNo) DO
                    IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 THEN BEGIN

                        //Found the first separator.  Now look for the second starting from here.
                        FOR j := i + 1 TO STRLEN(JobTaskNo) DO
                            IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 THEN BEGIN
                                //Now have both separators.  Break up the string.
                                NS_Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                NS_Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                NS_Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, STRLEN(JobTaskNo) - j), 1, 10);
                                //end both loops
                                i := STRLEN(JobTaskNo);
                                j := STRLEN(JobTaskNo);
                            END;

                    END;
            3:
                FOR i := 1 TO STRLEN(JobTaskNo) DO
                    IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, i, 1)) > 0 THEN BEGIN

                        //Found the first separator.  Now look for the second starting from here.
                        FOR j := i + 1 TO STRLEN(JobTaskNo) DO
                            IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, j, 1)) > 0 THEN BEGIN

                                //Found the second separator.  Now look for the third starting from here.
                                FOR k := j + 1 TO STRLEN(JobTaskNo) DO
                                    IF STRPOS(NS_JobsSetup."NS_APO Separators", COPYSTR(JobTaskNo, k, 1)) > 0 THEN BEGIN
                                        //Now have all three separators.  Break up the string.
                                        NS_Segment1 := COPYSTR(COPYSTR(JobTaskNo, 1, i - 1), 1, 10);
                                        NS_Segment2 := COPYSTR(COPYSTR(JobTaskNo, i + 1, j - i - 1), 1, 10);
                                        NS_Segment3 := COPYSTR(COPYSTR(JobTaskNo, j + 1, k - j - 1), 1, 10);
                                        NS_Segment4 := COPYSTR(COPYSTR(JobTaskNo, k + 1, STRLEN(JobTaskNo) - k), 1, 10);
                                        //end both loops
                                        i := STRLEN(JobTaskNo);
                                        j := STRLEN(JobTaskNo);
                                        k := STRLEN(JobTaskNo);
                                    END;
                            END;

                    END;

        END;

        IF NS_JobsSetup."NS_Activity Code Position" = 1 THEN BEGIN
            ActivityCode := NS_Segment1;
            ProcessCode := NS_Segment2;
            OperationCode := NS_Segment3;
            SectionCode := NS_Segment4;//PRJ-688.AM.1.0
        END ELSE BEGIN
            ActivityCode := NS_Segment2;
            ProcessCode := NS_Segment3;
            OperationCode := NS_Segment4;
        END;
        //ProjectPro - end
    END;

    PROCEDURE APOToJobTaskNo(ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    VAR
        NS_JobsSetup: Record 315;
    BEGIN
        //ProjectPro - start
        //This routine simply puts together the Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the second segment of the Job Task No. then you must use the JAPOtoJobTaskNo routine.

        JobTaskNo := '';

        IF NS_JobsSetup."NS_APO Separators" = '' THEN
            NS_JobsSetup.GET;

        IF ActivityCode > '' THEN BEGIN
            JobTaskNo := ActivityCode;
            IF ProcessCode > '' THEN BEGIN
                JobTaskNo := JobTaskNo + COPYSTR(NS_JobsSetup."NS_APO Separators", 1, 1) + ProcessCode;
                IF OperationCode > '' THEN
                    JobTaskNo := JobTaskNo + COPYSTR(NS_JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                if SectionCode > '' then //PRJ-688.AM.1.0
                    JobTaskNo := JobTaskNo + COPYSTR(NS_JobsSetup."NS_APO Separators", 1, 1) + SectionCode;//PRJ-688.AM.1.0
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE JAPOToJobTaskNo(TaskNo: Code[10]; ActivityCode: Code[10]; ProcessCode: Code[10]; OperationCode: Code[10]; SectionCode: Code[10]) JobTaskNo: Text[35];//PRJ-688.AM.1.0
    BEGIN
        //ProjectPro - start
        //This routine simply puts together the Job Task No., Activity, Process and Operation codes passed in into a Job Task No.
        //
        //The separator used will be the first chararacter of the APO separator list.
        //
        //If the Activity Code is actually the first segment of the Job Task No. then you must use the APOtoJobTaskNo routine.

        JobTaskNo := '';

        IF JobsSetup."NS_APO Separators" = '' THEN
            JobsSetup.GET;

        IF TaskNo > '' THEN BEGIN
            JobTaskNo := TaskNo;
            IF ActivityCode > '' THEN BEGIN
                JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ActivityCode;
                IF ProcessCode > '' THEN BEGIN
                    JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + ProcessCode;
                    IF OperationCode > '' THEN
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + OperationCode;
                    if SectionCode > '' then //PRJ-688.AM.1.0
                        JobTaskNo := JobTaskNo + COPYSTR(JobsSetup."NS_APO Separators", 1, 1) + SectionCode;//PRJ-688.AM.1.0
                END;
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_CalculateJobFinancials(PassedJob: Record 167; VAR ActualCostToDate: ARRAY[3] OF Decimal; VAR InvoiceBilled: ARRAY[3] OF Decimal; VAR PaymentReceived: ARRAY[3] OF Decimal; VAR CommittedCost: Decimal; PassedSubLevels: Boolean);
    VAR
        NS_MTD: Text[30];
        NS_YTD: Text[30];
        NS_JobLedgerEntry: Record 169;
        NS_PurchaseLine: Record 39;
        NS_DtldCustLedgEntry: Record 379;
        NS_JobCalc: Record 167;
        CommittedCostLocal: Decimal;
        CommittedCostLocal2: Decimal;
        IsHandle: Boolean;//FGH-163.SM.29022024 //PE-269.JS.1.0 05MAR2024
    BEGIN
        //ProjectPro - start
        //This function calculates Actual Cost, Invoices Billed, Payments Received, and Committed Cost for a job

        NS_JobCalc := PassedJob;
        NS_JobCalc.RESET;
        CLEAR(ActualCostToDate);
        CLEAR(InvoiceBilled);
        CLEAR(PaymentReceived);
        CommittedCost := 0;
        CommittedCostLocal := 0;//PRJ-321.MS.1.0
        CommittedCostLocal2 := 0;//PRJ-321.MS.1.0
        //FGH-163.SM.29022024  PE-269.JS.1.0 05MAR2024 START
        OnBeforeCalculateJobFinancials(IsHandle, PassedJob, ActualCostToDate, InvoiceBilled, PaymentReceived, CommittedCost, PassedSubLevels);
        If IsHandle then
            exit;
        //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 END
        //Set Period Dates
        NS_MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        NS_YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        //Find Actual-Cost-To-Date
        NS_CalculateActualCostToDate(NS_JobCalc, ActualCostToDate, PassedSubLevels);

        //Find Committed Cost
        WITH NS_PurchaseLine DO BEGIN
            //PRJ-321.MS.1.0 start
            RESET;
            SETCURRENTKEY("Job No.");
            SETRANGE("Job No.", NS_JobCalc."No.");
            SetFilter("Document Type", '%1', "Document Type"::"Return Order");
            CALCSUMS("NS_Committed Amount (LCY)");
            CommittedCost := "NS_Committed Amount (LCY)";
            //PRJ-321.MS.1.0 end
            RESET;
            SETCURRENTKEY("Job No.");
            SETRANGE("Job No.", NS_JobCalc."No.");
            SetFilter("Document Type", '%1', "Document Type"::Order);
            CALCSUMS("NS_Committed Amount (LCY)");
            CommittedCostLocal2 := "NS_Committed Amount (LCY)"; //PRJ-321.MS.1.0
            CommittedCost := CommittedCostLocal2 - CommittedCostLocal;//PRJ-321.MS.1.0
            //CommittedCost := "Committed Amount (LCY)"//PRJ-321.MS.1.0 comment
        END;

        //Find Invoice Billed
        CalculateInvoiceBilled(NS_JobCalc, InvoiceBilled, PassedSubLevels);

        //Find Payments Received
        WITH NS_DtldCustLedgEntry DO BEGIN
            RESET;
            SETCURRENTKEY("NS_Job No.", "Document Type", "Posting Date");
            SETRANGE("NS_Job No.", NS_JobCalc."No.");
            SETRANGE("Document Type", "Document Type"::Payment);
            SETRANGE("Posting Date", 0D, WORKDATE);
            CALCSUMS("Amount (LCY)");
            PaymentReceived[3] := "Amount (LCY)";
            IF PassedSubLevels THEN
                PaymentReceived[3] := PaymentReceived[3] + SLsPaymentReceived(NS_JobCalc);
            PaymentReceived[3] := PaymentReceived[3] * -1;

            SETFILTER("Posting Date", NS_YTD);
            CALCSUMS("Amount (LCY)");
            PaymentReceived[2] := "Amount (LCY)";
            IF PassedSubLevels THEN BEGIN
                NS_JobCalc.SETFILTER("NS_Date Filter", NS_YTD);
                PaymentReceived[2] := PaymentReceived[2] + SLsPaymentReceived(NS_JobCalc);
                NS_JobCalc.SETRANGE("NS_Date Filter");
            END;
            PaymentReceived[2] := PaymentReceived[2] * -1;

            SETFILTER("Posting Date", NS_MTD);
            CALCSUMS("Amount (LCY)");
            PaymentReceived[1] := "Amount (LCY)";
            IF PassedSubLevels THEN BEGIN
                NS_JobCalc.SETFILTER("NS_Date Filter", NS_MTD);
                PaymentReceived[1] := PaymentReceived[1] + SLsPaymentReceived(NS_JobCalc);
                NS_JobCalc.SETRANGE("NS_Date Filter");
            END;
            PaymentReceived[1] := PaymentReceived[1] * -1;
        END;
        //ProjectPro - end
    END;

    PROCEDURE NS_CalculateJobStatistics(PassedJob: Record 167; ActualCostToDate: ARRAY[3] OF Decimal; InvoiceBilled: ARRAY[3] OF Decimal; "Sub-LevelsCost": Decimal; "Sub-LevelsPrice": Decimal; CommittedCost: Decimal; PassedSubLevels: Boolean; VAR CalcValues: ARRAY[8, 40] OF Decimal);
    VAR
        NS_TotalBudgetedCost: Decimal;
        NS_TotalContract: Decimal;
        NS_CalcPctComplete: Decimal;
        NS_ActualPctComplete: Decimal;
        NS_Qty: Integer;
        NS_TypedTotal: Decimal;
        NS_Amount: Decimal;
        NS_CustLedgEntryRetention: Record 21;
        NS_SalesSetup: Record 311;
        NS_SalesInvoiceLine: Record 113;
        NS_SalesCrMemoLine: Record 115;
        NS_VendLedgEntryRetention: Record 25;
        NS_PurchSetup: Record 312;
        NS_PurchInvLine: Record 123;
        NS_PurchCrMemoLine: Record 125;
        NS_JobLedgEntry2: Record 169;
        NS_JobCostCategory: Record "NS_Job Cost Category";
        NS_JobCostCategory2: Record "NS_Job Cost Category";
        NS_JobRevenueCategory: Record "NS_Job Revenue Category";
        NS_JobRevenueCategory2: Record "NS_Job Revenue Category";
        NS_JobCalc: Record 167;
    BEGIN
        //ProjectPro - start
        //This function calculates various statistics for a job

        NS_SalesSetup.GET;
        NS_PurchSetup.GET;
        JobsSetup.GET;
        NS_JobCalc := PassedJob;
        NS_JobCalc.RESET;
        NS_JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)", "NS_Budgeted Price (LCY)");
        NS_TotalBudgetedCost := NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost";
        NS_TotalContract := NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice";

        //Calculate Percent Completed
        IF NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost" <> 0 THEN
            NS_CalcPctComplete := ROUND((ActualCostToDate[3] / (NS_JobCalc."NS_Budgeted Cost (LCY)" + "Sub-LevelsCost")), 0.0001)
        ELSE
            NS_CalcPctComplete := 0;

        //Find Actual Percent Complete
        IF (NS_JobCalc."NS_Actual Percent Complete" > 0) AND
           (NS_JobCalc."NS_Manager Job Status" < NS_JobCalc."NS_Manager Job Status"::Completed) THEN
            NS_ActualPctComplete := NS_JobCalc."NS_Actual Percent Complete"
        ELSE
            IF NS_JobCalc."NS_Manager Job Status" >= NS_JobCalc."NS_Manager Job Status"::Completed THEN
                NS_ActualPctComplete := 100
            ELSE
                NS_ActualPctComplete := NS_CalcPctComplete * 100;

        WITH NS_JobCalc DO BEGIN
            //[1,1] - Budget - Actual Costs To Date
            CalcValues[1, 1] := ActualCostToDate[3];

            //[1,2] - Budget - Actual Costs To Date %
            IF NS_TotalBudgetedCost <> 0 THEN
                CalcValues[1, 2] := CalcValues[1, 1] / NS_TotalBudgetedCost
            ELSE
                CalcValues[1, 2] := 0;

            //[1,3] - Budget - Est. Budget Remaining
            CalcValues[1, 3] := NS_TotalBudgetedCost - ActualCostToDate[3];

            //[1,4] - Budget - Est. Budget Remaining %
            IF NS_TotalBudgetedCost <> 0 THEN
                CalcValues[1, 4] := CalcValues[1, 3] / NS_TotalBudgetedCost
            ELSE
                CalcValues[1, 4] := 0;

            //[1,5] - Budget - Estimated Profit (Loss)
            CalcValues[1, 5] := NS_TotalContract - NS_TotalBudgetedCost;

            //[1,6] - Budget - Estimated Profit (Loss) %
            IF NS_TotalContract <> 0 THEN
                CalcValues[1, 6] := CalcValues[1, 5] / NS_TotalContract
            ELSE
                CalcValues[1, 6] := 0;

            //[1,7] - Budget - Est. Units
            CalcValues[1, 7] := "NS_Total Units";

            //[1,8] - Budget - Est. Unit Rates
            IF CalcValues[1, 7] <> 0 THEN
                CalcValues[1, 8] := NS_TotalBudgetedCost / CalcValues[1, 7]
            ELSE
                CalcValues[1, 8] := 0;

            //[1,9] - Budget - Committed
            CalcValues[1, 9] := CommittedCost;

            //[1,10] - Budget - Committed %
            IF NS_TotalBudgetedCost <> 0 THEN
                CalcValues[1, 10] := CommittedCost / NS_TotalBudgetedCost
            ELSE
                CalcValues[1, 10] := 0;

            //[1,11] - Budget - Actual % Complete
            CalcValues[1, 11] := NS_ActualPctComplete;

            //[1,12] - Budget - NOT USED
            CalcValues[1, 12] := 0;

            //[1,13] - Budget - Act. Budget Remaining
            IF NS_ActualPctComplete <> 0 THEN
                CalcValues[1, 13] := (ActualCostToDate[3] / (NS_ActualPctComplete / 100)) - ActualCostToDate[3]
            ELSE
                CalcValues[1, 13] := 0;

            //[1,14] - Budget - Act. Budget Remaining %
            IF (ActualCostToDate[3] <> 0) AND (NS_ActualPctComplete <> 0) THEN
                CalcValues[1, 14] := CalcValues[1, 13] / (ActualCostToDate[3] / (NS_ActualPctComplete / 100))
            ELSE
                CalcValues[1, 14] := 0;

            //[1,15] - Budget - Act. Current Profit (Loss)
            CalcValues[1, 15] := (NS_TotalContract * (NS_ActualPctComplete / 100)) - ActualCostToDate[3];

            //[1,16] - Budget - Act. Current Profit (Loss) %
            IF ActualCostToDate[3] <> 0 THEN
                CalcValues[1, 16] := CalcValues[1, 15] / ActualCostToDate[3]
            ELSE
                CalcValues[1, 16] := 0;

            //[1,17] - Budget - Act. Units
            CalcValues[1, 17] := "NS_Actual Units Complete";

            //[1,18] - Budget - Act. Unit Rates
            IF CalcValues[1, 17] <> 0 THEN
                CalcValues[1, 18] := ActualCostToDate[3] / CalcValues[1, 17]
            ELSE
                CalcValues[1, 18] := 0;

            //[1,19] - Budget - Commited
            CalcValues[1, 19] := CommittedCost;

            //[1,20] - Budget - Committed %
            IF NS_ActualPctComplete <> 0 THEN
                CalcValues[1, 20] := ActualCostToDate[3] / (NS_ActualPctComplete / 100)
            ELSE
                CalcValues[1, 20] := 0;

            IF CalcValues[1, 20] <> 0 THEN
                CalcValues[1, 20] := CommittedCost / CalcValues[1, 20];

            //[2,1] - Projections - Actual Cost To Date
            CalcValues[2, 1] := ActualCostToDate[3];

            //[2,2] - Projections - ActualCost To Date %
            CalcValues[2, 2] := NS_ActualPctComplete;

            //[2,3] - Projections - Projected Total Costs
            IF NS_ActualPctComplete <> 0 THEN
                CalcValues[2, 3] := ActualCostToDate[3] / (NS_ActualPctComplete / 100)
            ELSE
                CalcValues[2, 3] := 0;

            //[2,4] - Projections - NOT USED
            CalcValues[2, 4] := 0;

            //[2,5] - Projections - Projected Costs Variance
            CalcValues[2, 5] := NS_TotalBudgetedCost - CalcValues[2, 3];

            //[2,6] - Projections - Projected Costs Variance %
            IF NS_TotalBudgetedCost <> 0 THEN
                CalcValues[2, 6] := CalcValues[2, 5] / NS_TotalBudgetedCost
            ELSE
                CalcValues[2, 6] := 0;

            //[2,7] - Projections - Projected Profit (Loss)
            CalcValues[2, 7] := NS_TotalContract - CalcValues[2, 3];

            //[2,8] - Projections - Projected Profit (Loss) %
            IF NS_TotalContract <> 0 THEN
                CalcValues[2, 8] := CalcValues[2, 7] / NS_TotalContract
            ELSE
                CalcValues[2, 8] := 0;

            //[2,9] - Projections - Est. Units
            CalcValues[2, 9] := "NS_Actual Units Complete";

            //[2,10] - Projections - Est. Unit Rates
            IF "NS_Total Units" <> 0 THEN
                CalcValues[2, 10] := NS_TotalBudgetedCost / "NS_Total Units"
            ELSE
                CalcValues[2, 10] := 0;

            //[2,11] - Projections - Committed
            CalcValues[2, 11] := CommittedCost;

            //[2,12] - Projections - Committed %
            IF NS_TotalBudgetedCost <> 0 THEN
                CalcValues[2, 12] := CalcValues[2, 11] / NS_TotalBudgetedCost
            ELSE
                CalcValues[2, 12] := 0;

            //[2,13] - Projections - Projected Cost To Complete
            CalcValues[2, 13] := CalcValues[2, 3] * ((100 - NS_ActualPctComplete) / 100);

            //[2,14] - Projections - NOT USED
            CalcValues[2, 14] := 0;

            //[2,15] - Projections - Projected % Costs To Complete
            CalcValues[2, 15] := 100 - NS_ActualPctComplete;

            //[2,16] - Projections - NOT USED
            CalcValues[2, 16] := 0;

            //[2,17] - Projections - Projected Profit Variance
            CalcValues[2, 17] := (NS_TotalContract - CalcValues[2, 3]) - (NS_TotalContract - NS_TotalBudgetedCost);

            //[2,18] - Projections - Projected Profit Variance %
            IF CalcValues[2, 7] <> 0 THEN
                CalcValues[2, 18] := (CalcValues[2, 7] - CalcValues[1, 5]) / CalcValues[2, 7]
            ELSE
                CalcValues[2, 18] := 0;

            //[2,19] - Projections - Projected Units
            CalcValues[2, 19] := "NS_Total Units";

            //[2,20] - Projections - Projected Unit Rate
            IF "NS_Total Units" <> 0 THEN
                CalcValues[2, 20] := CalcValues[2, 3] / "NS_Total Units"
            ELSE
                CalcValues[2, 20] := 0;

            //[2,21] - Projections - Unit Rate Variance
            CalcValues[2, 21] := CalcValues[2, 10] - CalcValues[2, 20];

            //[2,22] - Projections - Unit Rate Variance %
            IF CalcValues[2, 10] <> 0 THEN
                CalcValues[2, 22] := (CalcValues[2, 10] - CalcValues[2, 20]) / CalcValues[2, 10]
            ELSE
                CalcValues[2, 22] := 0;

            //[2,23] - Projections - Committed
            CalcValues[2, 23] := CommittedCost;

            //[2,24] - Projections - Committed %
            IF CalcValues[2, 3] <> 0 THEN
                CalcValues[2, 24] := CommittedCost / CalcValues[2, 3]
            ELSE
                CalcValues[2, 24] := 0;
        END;

        //[3,1] - Status - A/R Retention Balance
        CLEAR(CalcValues[3, 1]);

        NS_CustLedgEntryRetention.SETRANGE("NS_Job No.", PassedJob."No.");
        NS_CustLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        IF NS_CustLedgEntryRetention.FINDSET THEN
            REPEAT
                //PRJCTPR-220.DK.1.0 06NOV2023 Start
                //     NS_CustLedgEntryRetention.CALCFIELDS(Amount);
                //     //PRJCTPR-48.Dk.0.1 Start
                //     //  CalcValues[3, 1] += ABS(NS_CustLedgEntryRetention.Amount);
                //     if (NS_CustLedgEntryRetention.Amount) > 0 then
                //         CalcValues[3, 1] += ABS(NS_CustLedgEntryRetention.Amount);
                //     if (NS_CustLedgEntryRetention.Amount) < 0 then
                //         CalcValues[3, 1] -= ABS(NS_CustLedgEntryRetention.Amount);
                // //PRJCTPR-48.Dk.0.1 end
                NS_CustLedgEntryRetention.CALCFIELDS(Amount, "Remaining Amt. (LCY)");

                //  CalcValues[3, 1] += ABS(NS_CustLedgEntryRetention.Amount);
                if (NS_CustLedgEntryRetention.Amount) > 0 then
                    CalcValues[3, 1] += ABS(NS_CustLedgEntryRetention."Remaining Amt. (LCY)");
                if (NS_CustLedgEntryRetention.Amount) < 0 then
                    CalcValues[3, 1] -= ABS(NS_CustLedgEntryRetention."Remaining Amt. (LCY)");
            //PRJCTPR-220.DK.1.0 06NOV2023 End
            UNTIL NS_CustLedgEntryRetention.NEXT = 0;


        //[3,2] - Status - A/P Retention Balance
        CLEAR(CalcValues[3, 2]);

        NS_VendLedgEntryRetention.SETRANGE("NS_Job No.", PassedJob."No.");
        NS_VendLedgEntryRetention.SETRANGE("NS_Retention Ledger Code", JobsSetup."NS_Retention Receivable Ledger");
        IF NS_VendLedgEntryRetention.FINDSET THEN
            REPEAT
                NS_VendLedgEntryRetention.CALCFIELDS(Amount);
                CalcValues[3, 2] += ABS(NS_VendLedgEntryRetention.Amount);
            UNTIL NS_VendLedgEntryRetention.NEXT = 0;

        //[3,3] & [3,4] - Status - Not used

        //[3,5] - Status - Contract Billed Percent
        IF NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice" <> 0 THEN
            CalcValues[3, 5] := ROUND((InvoiceBilled[3] / (NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice")) * 100, 0.01)
        ELSE
            CalcValues[3, 5] := 0;
        //[3,6] - Status - Over/Under Billed
        IF (Status <> Status::Completed) AND ("NS_Actual Percent Complete" <> 100) THEN BEGIN
            IF NS_CalcPctComplete <= 1 THEN
                CalcValues[3, 6] := InvoiceBilled[3] - ((NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice") * NS_CalcPctComplete)
            ELSE
                CalcValues[3, 6] := InvoiceBilled[3] - ((NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice") * 1);
        END ELSE
            CalcValues[3, 6] := 0;

        //[3,7] - Status - Contract Back Log
        CalcValues[3, 7] := (NS_JobCalc."NS_Budgeted Price (LCY)" + "Sub-LevelsPrice") - InvoiceBilled[3];

        //Start of currency (dollar amount) calculations on Cost Category Totals
        //[4,1] - Cost Category Matrix
        FOR NS_Qty := 1 TO 40 DO
            CLEAR(CalcValues[4, NS_Qty]);

        //Fill in Budget Cost
        WITH NS_JobCostCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Cost Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
                    NS_Amount := NS_JobCalc."NS_Budgeted Cost (LCY)";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[4, 1] := CalcValues[4, 1] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[4, 5] := CalcValues[4, 5] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[4, 9] := CalcValues[4, 9] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[4, 13] := CalcValues[4, 13] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[4, 17] := CalcValues[4, 17] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[4, 21] := CalcValues[4, 21] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[4, 25] := CalcValues[4, 25] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Cost Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Budgeted Cost (LCY)");
            CalcValues[4, 29] := NS_JobCalc."NS_Budgeted Cost (LCY)" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Levels
            WITH NS_JobCostCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        NS_Amount := NS_SLsBudgetedCost(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[4, 1] := CalcValues[4, 1] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[4, 5] := CalcValues[4, 5] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[4, 9] := CalcValues[4, 9] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[4, 13] := CalcValues[4, 13] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[4, 17] := CalcValues[4, 17] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[4, 21] := CalcValues[4, 21] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[4, 25] := CalcValues[4, 25] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Cost Category Filter");
                NS_Amount := NS_SLsBudgetedCost(NS_JobCalc);
                CalcValues[4, 29] := CalcValues[4, 29] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Actual Cost
        WITH NS_JobCostCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Cost Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Usage (Cost) (LCY)");
                    NS_Amount := NS_JobCalc."NS_Usage (Cost) (LCY)";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[4, 2] := CalcValues[4, 2] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[4, 6] := CalcValues[4, 6] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[4, 10] := CalcValues[4, 10] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[4, 14] := CalcValues[4, 14] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[4, 18] := CalcValues[4, 18] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[4, 22] := CalcValues[4, 22] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[4, 26] := CalcValues[4, 26] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Cost Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Usage (Cost) (LCY)");
            CalcValues[4, 30] := NS_JobCalc."NS_Usage (Cost) (LCY)" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Levels
            WITH NS_JobCostCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        NS_Amount := "SLsUsage(Cost)"(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[4, 2] := CalcValues[4, 2] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[4, 6] := CalcValues[4, 6] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[4, 10] := CalcValues[4, 10] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[4, 14] := CalcValues[4, 14] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[4, 18] := CalcValues[4, 18] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[4, 22] := CalcValues[4, 22] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[4, 26] := CalcValues[4, 26] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Cost Category Filter");
                NS_Amount := "SLsUsage(Cost)"(NS_JobCalc);
                CalcValues[4, 30] := CalcValues[4, 30] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Variance & Variance %
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[4, (NS_Qty * 4) + 3] := CalcValues[4, (NS_Qty * 4) + 1] - CalcValues[4, (NS_Qty * 4) + 2];
            CalcValues[4, (NS_Qty * 4) + 4] := VariancePercent(CalcValues[4, (NS_Qty * 4) + 3], CalcValues[4, (NS_Qty * 4) + 1]);
        END;

        //Fill in total line
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[4, 33] := CalcValues[4, 33] + CalcValues[4, (NS_Qty * 4) + 1];
            CalcValues[4, 34] := CalcValues[4, 34] + CalcValues[4, (NS_Qty * 4) + 2];
            CalcValues[4, 35] := CalcValues[4, 35] + CalcValues[4, (NS_Qty * 4) + 3];
            CalcValues[4, 36] := VariancePercent(CalcValues[4, 35], CalcValues[4, 33]);
        END;

        //Start of currency (dollar amount) calculations on Revenue Category Totals
        //[5,1] - Revenue Category Matrix
        FOR NS_Qty := 1 TO 40 DO
            CLEAR(CalcValues[5, NS_Qty]);

        //Fill in Budget Revenue
        WITH NS_JobRevenueCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
                    NS_Amount := NS_JobCalc."NS_Budgeted Price (LCY)";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[5, 1] := CalcValues[5, 1] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[5, 5] := CalcValues[5, 5] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[5, 9] := CalcValues[5, 9] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[5, 13] := CalcValues[5, 13] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[5, 17] := CalcValues[5, 17] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[5, 21] := CalcValues[5, 21] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[5, 25] := CalcValues[5, 25] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Budgeted Price (LCY)");
            CalcValues[5, 29] := NS_JobCalc."NS_Budgeted Price (LCY)" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Levels
            WITH NS_JobRevenueCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_Code);
                        NS_Amount := NS_SLsBudgetedPrice(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[5, 1] := CalcValues[5, 1] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[5, 5] := CalcValues[5, 5] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[5, 9] := CalcValues[5, 9] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[5, 13] := CalcValues[5, 13] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[5, 17] := CalcValues[5, 17] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[5, 21] := CalcValues[5, 21] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[5, 25] := CalcValues[5, 25] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
                NS_Amount := NS_SLsBudgetedPrice(NS_JobCalc);
                CalcValues[5, 29] := CalcValues[5, 29] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Actual Price
        WITH NS_JobRevenueCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Revenue Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
                    NS_Amount := NS_JobCalc."NS_Invoiced Price (LCY)";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[5, 2] := CalcValues[5, 2] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[5, 6] := CalcValues[5, 6] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[5, 10] := CalcValues[5, 10] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[5, 14] := CalcValues[5, 14] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[5, 18] := CalcValues[5, 18] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[5, 22] := CalcValues[5, 22] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[5, 26] := CalcValues[5, 26] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Invoiced Price (LCY)");
            CalcValues[5, 30] := NS_JobCalc."NS_Invoiced Price (LCY)" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Levels
            WITH NS_JobRevenueCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Revenue Category Filter", NS_Code);
                        NS_Amount := SLsInvoicedPrice(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[5, 2] := CalcValues[5, 2] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[5, 6] := CalcValues[5, 6] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[5, 10] := CalcValues[5, 10] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[5, 14] := CalcValues[5, 14] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[5, 18] := CalcValues[5, 18] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[5, 22] := CalcValues[5, 22] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[5, 26] := CalcValues[5, 26] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Revenue Category Filter");
                NS_Amount := SLsInvoicedPrice(NS_JobCalc);
                CalcValues[5, 30] := CalcValues[5, 30] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Variance & Variance %
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[5, (NS_Qty * 4) + 3] := CalcValues[5, (NS_Qty * 4) + 1] - CalcValues[5, (NS_Qty * 4) + 2];
            CalcValues[5, (NS_Qty * 4) + 4] := VariancePercent(CalcValues[5, (NS_Qty * 4) + 3], CalcValues[5, (NS_Qty * 4) + 1]);
        END;

        //Fill in total line
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[5, 33] := CalcValues[5, 33] + CalcValues[5, (NS_Qty * 4) + 1];
            CalcValues[5, 34] := CalcValues[5, 34] + CalcValues[5, (NS_Qty * 4) + 2];
            CalcValues[5, 35] := CalcValues[5, 35] + CalcValues[5, (NS_Qty * 4) + 3];
            CalcValues[5, 36] := VariancePercent(CalcValues[5, 35], CalcValues[5, 33]);
        END;

        //Start of quantity calculations on Cost Category Totals
        //[6,1] - Cost Category Quantity Matrix
        FOR NS_Qty := 1 TO 40 DO
            CLEAR(CalcValues[6, NS_Qty]);

        //Fill in Budget quantities
        WITH NS_JobCostCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Cost Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Budgeted Cost Quantity");
                    NS_Amount := NS_JobCalc."NS_Budgeted Cost Quantity";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[6, 1] := CalcValues[6, 1] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[6, 5] := CalcValues[6, 5] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[6, 9] := CalcValues[6, 9] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[6, 13] := CalcValues[6, 13] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[6, 17] := CalcValues[6, 17] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[6, 21] := CalcValues[6, 21] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[6, 25] := CalcValues[6, 25] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Cost Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Budgeted Cost Quantity");
            CalcValues[6, 29] := NS_JobCalc."NS_Budgeted Cost Quantity" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Level Quantities
            WITH NS_JobCostCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        NS_Amount := SLsBudgetedCostQty(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[6, 1] := CalcValues[6, 1] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[6, 5] := CalcValues[6, 5] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[6, 9] := CalcValues[6, 9] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[6, 13] := CalcValues[6, 13] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[6, 17] := CalcValues[6, 17] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[6, 21] := CalcValues[6, 21] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[6, 25] := CalcValues[6, 25] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Cost Category Filter");
                NS_Amount := SLsBudgetedCostQty(NS_JobCalc);
                CalcValues[6, 29] := CalcValues[6, 29] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Actual Quantities
        WITH NS_JobCostCategory DO BEGIN
            NS_TypedTotal := 0;
            RESET;
            IF FINDSET THEN
                REPEAT
                    NS_JobCalc.SETFILTER("NS_Cost Category Filter", NS_Code);
                    NS_JobCalc.CALCFIELDS("NS_Actual Cost Quantity(Usage)");
                    NS_Amount := NS_JobCalc."NS_Actual Cost Quantity(Usage)";
                    CASE NS_Type OF
                        NS_Type::Labor:
                            CalcValues[6, 2] := CalcValues[6, 2] + NS_Amount;
                        NS_Type::Material:
                            CalcValues[6, 6] := CalcValues[6, 6] + NS_Amount;
                        NS_Type::Equipment:
                            CalcValues[6, 10] := CalcValues[6, 10] + NS_Amount;
                        NS_Type::Subcontract:
                            CalcValues[6, 14] := CalcValues[6, 14] + NS_Amount;
                        NS_Type::Manufacturing:
                            CalcValues[6, 18] := CalcValues[6, 18] + NS_Amount;
                        NS_Type::Overhead:
                            CalcValues[6, 22] := CalcValues[6, 22] + NS_Amount;
                        NS_Type::Miscellaneous:
                            CalcValues[6, 26] := CalcValues[6, 26] + NS_Amount;
                    END;
                    NS_TypedTotal := NS_TypedTotal + NS_Amount;
                UNTIL NEXT = 0;
            NS_JobCalc.SETRANGE("NS_Cost Category Filter");
            NS_JobCalc.CALCFIELDS("NS_Actual Cost Quantity(Usage)");
            CalcValues[6, 30] := NS_JobCalc."NS_Actual Cost Quantity(Usage)" - NS_TypedTotal;
        END;

        IF PassedSubLevels THEN
            //Add in Sub-Level Quantities
            WITH NS_JobCostCategory2 DO BEGIN
                NS_TypedTotal := 0;
                RESET;
                IF FINDSET THEN
                    REPEAT
                        NS_JobCalc.SETRANGE("NS_Cost Category Filter", NS_Code);
                        NS_Amount := SLsActualCostQty(NS_JobCalc);
                        CASE NS_Type OF
                            NS_Type::Labor:
                                CalcValues[6, 2] := CalcValues[6, 2] + NS_Amount;
                            NS_Type::Material:
                                CalcValues[6, 6] := CalcValues[6, 6] + NS_Amount;
                            NS_Type::Equipment:
                                CalcValues[6, 10] := CalcValues[6, 10] + NS_Amount;
                            NS_Type::Subcontract:
                                CalcValues[6, 14] := CalcValues[6, 14] + NS_Amount;
                            NS_Type::Manufacturing:
                                CalcValues[6, 18] := CalcValues[6, 18] + NS_Amount;
                            NS_Type::Overhead:
                                CalcValues[6, 22] := CalcValues[6, 22] + NS_Amount;
                            NS_Type::Miscellaneous:
                                CalcValues[6, 26] := CalcValues[6, 26] + NS_Amount;
                        END;
                        NS_TypedTotal := NS_TypedTotal + NS_Amount;
                    UNTIL NEXT = 0;
                NS_JobCalc.SETRANGE("NS_Cost Category Filter");
                NS_Amount := SLsActualCostQty(NS_JobCalc);
                CalcValues[6, 30] := CalcValues[6, 30] + NS_Amount - NS_TypedTotal;
            END;

        //Fill in Variance & Variance %
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[6, (NS_Qty * 4) + 3] := CalcValues[6, (NS_Qty * 4) + 1] - CalcValues[6, (NS_Qty * 4) + 2];
            CalcValues[6, (NS_Qty * 4) + 4] := VariancePercent(CalcValues[6, (NS_Qty * 4) + 3], CalcValues[6, (NS_Qty * 4) + 1]);
        END;

        //Fill in total line
        FOR NS_Qty := 0 TO 7 DO BEGIN
            CalcValues[6, 33] := CalcValues[6, 33] + CalcValues[6, (NS_Qty * 4) + 1];
            CalcValues[6, 34] := CalcValues[6, 34] + CalcValues[6, (NS_Qty * 4) + 2];
            CalcValues[6, 35] := CalcValues[6, 35] + CalcValues[6, (NS_Qty * 4) + 3];
            CalcValues[6, 36] := VariancePercent(CalcValues[6, 35], CalcValues[6, 33]);
        END;
        //ProjectPro - end
    END;

    PROCEDURE VariancePercent(Numerator: Decimal; Denominator: Decimal): Decimal;
    BEGIN
        //ProjectPro - start
        IF Denominator = 0 THEN
            IF Numerator = 0 THEN
                EXIT(0)
            ELSE
                EXIT(-100)
        ELSE
            EXIT(ROUND((Numerator / Denominator) * 100, 0.01));
        //ProjectPro - end
    END;

    PROCEDURE NS_CalculateActualCostToDate(PassedJob: Record 167; VAR ActualCostToDate: ARRAY[3] OF Decimal; PassedSubLevels: Boolean);
    VAR
        NS_JobLedgerEntry: Record 169;
        NS_YTD: Text[30];
        NS_MTD: Text[30];
    BEGIN
        //ProjectPro - start
        NS_MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        NS_YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        CLEAR(ActualCostToDate);
        WITH NS_JobLedgerEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
            SETRANGE("Job No.", PassedJob."No.");
            SETRANGE("Entry Type", "Entry Type"::Usage);
            SETRANGE("Posting Date", 0D, WORKDATE);
            CALCSUMS("Total Cost (LCY)");
            ActualCostToDate[3] := "Total Cost (LCY)";
            IF PassedSubLevels THEN BEGIN
                PassedJob.SETRANGE("NS_Date Filter", 0D, WORKDATE);
                ActualCostToDate[3] := ActualCostToDate[3] + "SLsUsage(Cost)"(PassedJob);
                PassedJob.SETRANGE("NS_Date Filter");
            END;

            SETFILTER("Posting Date", NS_YTD);
            CALCSUMS("Total Cost (LCY)");
            ActualCostToDate[2] := "Total Cost (LCY)";
            IF PassedSubLevels THEN BEGIN
                PassedJob.SETFILTER("NS_Date Filter", NS_YTD);
                ActualCostToDate[2] := ActualCostToDate[2] + "SLsUsage(Cost)"(PassedJob);
                PassedJob.SETRANGE("NS_Date Filter");
            END;

            SETFILTER("Posting Date", NS_MTD);
            CALCSUMS("Total Cost (LCY)");
            ActualCostToDate[1] := "Total Cost (LCY)";
            IF PassedSubLevels THEN BEGIN
                PassedJob.SETFILTER("NS_Date Filter", NS_MTD);
                ActualCostToDate[1] := ActualCostToDate[1] + "SLsUsage(Cost)"(PassedJob);
                PassedJob.SETRANGE("NS_Date Filter");
            END;
        END;
        //ProjectPro - end
    END;

    PROCEDURE CalculateInvoiceBilled(PassedJob: Record 167; VAR InvoiceBilled: ARRAY[3] OF Decimal; PassedSubLevels: Boolean);
    VAR
        NS_JobLedgerEntry: Record 169;
        NS_MTD: Text[30];
        NS_YTD: Text[30];
    BEGIN
        //ProjectPro - start
        NS_MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        NS_YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        CLEAR(InvoiceBilled);
        WITH NS_JobLedgerEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
            SETRANGE("Job No.", PassedJob."No.");
            SETRANGE("Entry Type", "Entry Type"::Sale);
            SETRANGE("Posting Date", 0D, WORKDATE);
            SETFILTER(Type, '<>%1', Type::NS_Ledger);
            CALCSUMS("Total Price (LCY)");
            InvoiceBilled[3] := -"Total Price (LCY)";
            IF PassedSubLevels THEN
                InvoiceBilled[3] := InvoiceBilled[3] + SLsInvoicedPrice(PassedJob);

            SETFILTER("Posting Date", NS_YTD);
            CALCSUMS("Total Price (LCY)");
            InvoiceBilled[2] := -"Total Price (LCY)";
            IF PassedSubLevels THEN BEGIN
                PassedJob.SETFILTER("NS_Date Filter", NS_YTD);
                InvoiceBilled[2] := InvoiceBilled[2] + SLsInvoicedPrice(PassedJob);
                PassedJob.SETRANGE("NS_Date Filter");
            END;

            SETFILTER("Posting Date", NS_MTD);
            CALCSUMS("Total Price (LCY)");
            InvoiceBilled[1] := -"Total Price (LCY)";
            IF PassedSubLevels THEN BEGIN
                PassedJob.SETFILTER("NS_Date Filter", NS_MTD);
                InvoiceBilled[1] := InvoiceBilled[1] + SLsInvoicedPrice(PassedJob);
                PassedJob.SETRANGE("NS_Date Filter");
            END;
        END;
        //ProjectPro - end
    END;
    //PRJCTPR-187.PS.1.0 11Sep2023 Start
    PROCEDURE CalculateInvBilledExcluedSubandChagesOrder(PassedJob: Record 167; VAR InvoiceBilled: ARRAY[3] OF Decimal; PassedSubLevels: Boolean);
    VAR
        NS_JobLedgerEntry: Record 169;
        NS_MTD: Text[30];
        NS_YTD: Text[30];
    BEGIN
        //ProjectPro - start
        NS_MTD := FORMAT(DMY2DATE(1, DATE2DMY(WORKDATE, 2), DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());
        NS_YTD := FORMAT(DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3))) + '..' + FORMAT(WORKDATE());

        CLEAR(InvoiceBilled);
        //PRJ-1136.NK.1.0 Start
        //WITH NS_JobLedgerEntry DO BEGIN
        NS_JobLedgerEntry.RESET();
        NS_JobLedgerEntry.SETCURRENTKEY("Job No.", "Entry Type", "Posting Date", Type);
        NS_JobLedgerEntry.SETRANGE("Job No.", PassedJob."No.");
        NS_JobLedgerEntry.SETRANGE("Entry Type", NS_JobLedgerEntry."Entry Type"::Sale);
        NS_JobLedgerEntry.SETRANGE("Posting Date", 0D, WORKDATE);
        NS_JobLedgerEntry.SETFILTER(Type, '<>%1', NS_JobLedgerEntry.Type::NS_Ledger);
        NS_JobLedgerEntry.CALCSUMS("Total Price (LCY)");
        InvoiceBilled[3] := -NS_JobLedgerEntry."Total Price (LCY)";
        IF PassedSubLevels THEN
            InvoiceBilled[3] := InvoiceBilled[3];

        NS_JobLedgerEntry.SETFILTER("Posting Date", NS_YTD);
        NS_JobLedgerEntry.CALCSUMS("Total Price (LCY)");
        InvoiceBilled[2] := -NS_JobLedgerEntry."Total Price (LCY)";
        IF PassedSubLevels THEN BEGIN
            PassedJob.SETFILTER("NS_Date Filter", NS_YTD);
            InvoiceBilled[2] := InvoiceBilled[2];
            PassedJob.SETRANGE("NS_Date Filter");
        END;

        NS_JobLedgerEntry.SETFILTER("Posting Date", NS_MTD);
        NS_JobLedgerEntry.CALCSUMS("Total Price (LCY)");
        InvoiceBilled[1] := -NS_JobLedgerEntry."Total Price (LCY)";
        IF PassedSubLevels THEN BEGIN
            PassedJob.SETFILTER("NS_Date Filter", NS_MTD);
            InvoiceBilled[1] := InvoiceBilled[1];
            PassedJob.SETRANGE("NS_Date Filter");
        END;

        //ProjectPro - end
    END;

    //PRJCTPR-187.PS.1.0 11Sep2023 End 

    PROCEDURE GetBillDate(BillDateIn: Date; JobNoIn: Code[20]) BillDate: Date;
    VAR
        Job: Record 167;
        BillDay: Integer;
        BillMonth: Integer;
        BillYear: Integer;
    BEGIN
        //ProjectPro - start
        //Returns the proper bill date for a job based on date passed in.
        //If a Job is billed on the 20th and the BillDateIn is 6/1/13 then the function returns 6/20/13
        //If BillDateIn is 6/25/13 then the function returns 6/20/13
        //Errors return 0D

        IF (BillDateIn > 0D) AND (Job.GET(JobNoIn)) THEN BEGIN
            BillMonth := DATE2DMY(BillDateIn, 2);
            BillYear := DATE2DMY(BillDateIn, 3);

            //Find Billing Day
            IF STRLEN(Job."NS_Billing Day of Month") = 0 THEN
                BillDay := DATE2DMY(BillDateIn, 1);

            IF (STRLEN(Job."NS_Billing Day of Month") = 1) OR
               (STRLEN(Job."NS_Billing Day of Month") = 2) THEN
                EVALUATE(BillDay, Job."NS_Billing Day of Month");

            IF STRLEN(Job."NS_Billing Day of Month") > 2 THEN BEGIN
                IF ((Job."NS_Billing Day of Month" = Text14021110) OR
                    (Job."NS_Billing Day of Month" = Text14021111)) THEN BEGIN
                    IF (BillMonth = 1) OR
                       (BillMonth = 3) OR
                       (BillMonth = 5) OR
                       (BillMonth = 7) OR
                       (BillMonth = 8) OR
                       (BillMonth = 10) OR
                       (BillMonth = 12) THEN
                        BillDay := 31;
                END;
                IF (BillDay = 0) AND
                   ((Job."NS_Billing Day of Month" = Text14021109) OR
                    (Job."NS_Billing Day of Month" = Text14021110) OR
                    (Job."NS_Billing Day of Month" = Text14021111)) THEN BEGIN
                    IF BillMonth <> 2 THEN
                        BillDay := 30;
                END;
                IF BillDay = 0 THEN BEGIN
                    IF BillMonth = 2 THEN BEGIN
                        IF (BillYear / 4) = ROUND(BillYear / 4, 1) THEN
                            BillDay := 29
                        ELSE
                            BillDay := 28;
                    END ELSE
                        BillDay := 29;
                END;
            END;

            BillDate := DMY2DATE(BillDay, BillMonth, BillYear);
        END ELSE
            BillDate := 0D;
        //ProjectPro - end
    END;

    PROCEDURE InitVar(lSkipTasks: Boolean; lFromQuote: Boolean);
    BEGIN
        SkipTasks := lSkipTasks;
        FromQuote := lFromQuote;
    END;

    // >> Upgrade
    //LOCAL PROCEDURE LoadTasks();
    PROCEDURE LoadTasks()
    // << Upgrade
    BEGIN
        IF NOT DisableLoadTasks THEN BEGIN
            LoadTasksOperation;
            LoadTasksProcess;
            LoadTasksActivity;
        END;
    END;

    LOCAL PROCEDURE LoadTasksActivity();
    var//PRJ-199:16APRIL2020
        JobsSetup: Record "Jobs Setup";//PRJ-199:16APRIL2020
                                       // >> Upgrade1
        SeqNo: Integer;
    // << Upgrade1
        NS_JobTask: Record "Job Task";    //PRJ-1042.JS.1.0
        //PRJCTPR-338.DK.1.0 19March Start
        NS_Job: Record Job;
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Job Task Dimension";
        SubleveJobNo: Code[20];//  //PRJCTPR-362.PS.1.0 01May2024 
    //PRJCTPR-338.DK.1.0 19March End
    BEGIN
        JobsSetup.Get;//PRJ-199:16APRIL2020
                      // >> Upgrade1
        SeqNo := 100; // >> 019 <<
                      // << Upgrade1
        IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::Default) AND (NOT SkipTasks) THEN BEGIN
            NS_JobActivity.RESET;
            NS_JobActivity.SETCURRENTKEY("NS_Default onto each Job");
            NS_JobActivity.SETRANGE("NS_Default onto each Job", TRUE);
            IF NS_JobActivity.FINDSET THEN
                REPEAT
                    IF NOT NS_JobTaskCheck.GET("No.", NS_JobActivity.NS_Code) THEN BEGIN
                        NS_JobTask.INIT;
                        NS_JobTask."Job No." := "No.";
                        NS_JobTask."Job Task No." := NS_JobActivity.NS_Code;
                        NS_JobTask.Description := NS_JobActivity.NS_Description;
                        NS_JobTask."Job Task Type" := NS_JobActivity."NS_Job Task Type";
                        NS_JobTask.Totaling := NS_JobActivity.NS_Totaling;
                        NS_JobTask."Job Posting Group" := JobsSetup."Default Job Posting Group"; //PRJ-1437.NK.1.0 09Jun2022
                        NS_JobTask."New Page" := NS_JobActivity."NS_New Page";
                        NS_JobTask."No. of Blank Lines" := NS_JobActivity."NS_No. of Blank Lines";
                        NS_JobTask.Indentation := NS_JobActivity.NS_Indentation;
                        NS_JobTask."NS_Burden Percent" := NS_JobActivity.NS_DefaultProjectBurdenPerc; //PRJ-313.AS.1.0 15JULY20202
                        IF NS_JobActivity."NS_Total Price" <> 0 THEN BEGIN
                            NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobActivity."NS_Total Price" - NS_JobActivity."NS_Total Cost") / NS_JobActivity."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                            NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobActivity."NS_Total Cost" / NS_JobActivity."NS_Total Price")) * 100;
                        END;
                        NS_JobTask."NS_Gross Profit" := NS_JobActivity."NS_Total Price" - NS_JobActivity."NS_Total Cost";
                        IF FromQuote THEN
                            NS_JobTask."NS_Quote No." := "No.";
		        OnBeforeInsertJobTask(NS_JobTask, SeqNo); // >> Upgrade << 
                        //PRJ-1406.GK.1.0 18May2022 start
                        OnLoadTaskActivityOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobActivity);
                        //PRJ-1406.GK.1.0 18May2022 end
                        // //PRJCTPR-362.PS.1.0 01May2024 Start
                        if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                            SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                            NS_InsertDimension(SubleveJobNo, NS_JobTask);
			    
                            if NS_Job.Get(SubleveJobNo) then;
                            NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                        end;


                        // //PRJCTPR-362.PS.1.0 01May2024 End 
                        NS_JobTask.INSERT;

                    END;
                UNTIL NS_JobActivity.NEXT = 0;
            NS_JobTask.NS_IndentJobTask(Rec."No.");   //PRJ-1042.JS.1.0  add line
        END ELSE BEGIN
            IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::JobType) AND (NOT SkipTasks) THEN BEGIN
                NS_JobActivity.RESET;
                NS_JobActivity.SETCURRENTKEY("NS_DefaultTaskforJobType");
                //PRJCTPR-197 Dk.1.0 Start
                //  NS_JobActivity.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type");
                NS_JobActivity.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type New");
                //PRJCTPR-197 Dk.1.0 End
                IF NS_JobActivity.FINDSET THEN
                    REPEAT
                        IF NOT NS_JobTaskCheck.GET("No.", NS_JobActivity.NS_Code) THEN BEGIN
                            NS_JobTask.INIT;
                            NS_JobTask."Job No." := "No.";
                            NS_JobTask."Job Task No." := NS_JobActivity.NS_Code;
                            NS_JobTask.Description := NS_JobActivity.NS_Description;
                            NS_JobTask."Job Task Type" := NS_JobActivity."NS_Job Task Type";
                            NS_JobTask.Totaling := NS_JobActivity.NS_Totaling;
                            NS_JobTask."Job Posting Group" := JobsSetup."Default Job Posting Group"; //PRJ-1437.NK.1.0 09Jun2022
                            NS_JobTask."New Page" := NS_JobActivity."NS_New Page";
                            NS_JobTask."No. of Blank Lines" := NS_JobActivity."NS_No. of Blank Lines";
                            NS_JobTask.Indentation := NS_JobActivity.NS_Indentation;
                            IF NS_JobActivity."NS_Total Price" <> 0 THEN BEGIN
                                NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobActivity."NS_Total Price" - NS_JobActivity."NS_Total Cost") / NS_JobActivity."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                                NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobActivity."NS_Total Cost" / NS_JobActivity."NS_Total Price")) * 100;
                            END;
                            NS_JobTask."NS_Gross Profit" := NS_JobActivity."NS_Total Price" - NS_JobActivity."NS_Total Cost";
                            IF FromQuote THEN
                                NS_JobTask."NS_Quote No." := "No.";
			    OnBeforeInsertJobTask(NS_JobTask, SeqNo); // >> Upgrade <<
                            //PRJ-1406.GK.1.0 18May2022 start
                            OnLoadTaskActivityOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobActivity);
                            //PRJ-1406.GK.1.0 18May2022 end
                            // //PRJCTPR-362.PS.1.0 01May2024 Start


                            if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                                SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                                NS_InsertDimension(SubleveJobNo, NS_JobTask);
                                if NS_Job.Get(SubleveJobNo) then;
                                NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                                NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            end;






                            // //PRJCTPR-362.PS.1.0 01May2024 End 
                            NS_JobTask.INSERT;

                        END;
                    UNTIL NS_JobActivity.NEXT = 0;
                NS_JobTask.NS_IndentJobTask(Rec."No.");   //PRJ-1042.JS.1.0  add line
            END;
        END;
    END;

    LOCAL PROCEDURE LoadTasksProcess();
    var//PRJ-199:16APRIL2020
        JobsSetup: Record "Jobs Setup";//PRJ-199:16APRIL2020
                                       //PRJCTPR-338.DK.1.0 19March Start
        NS_Job: Record Job;
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Job Task Dimension";
        SubleveJobNo: Code[20];//  //PRJCTPR-362.PS.1.0 01May2024
    //PRJCTPR-338.DK.1.0 19March End
    BEGIN
        JobsSetup.Get;//PRJ-199:16APRIL2020
        IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::Default) AND (NOT SkipTasks) THEN BEGIN
            NS_JobProcess.RESET;
            NS_JobProcess.SETCURRENTKEY("NS_Default onto each Job");
            NS_JobProcess.SETRANGE("NS_Default onto each Job", TRUE);
            IF NS_JobProcess.FINDSET THEN
                REPEAT
                    NS_JobTaskNo := APOToJobTaskNo(NS_JobProcess."NS_Activity Code", NS_JobProcess.NS_Code, '', '');//PRJ-688.AM.1.0
                    IF NOT NS_JobTaskCheck.GET("No.", NS_JobTaskNo) THEN BEGIN
                        NS_JobTask.INIT;
                        NS_JobTask."Job No." := "No.";
                        NS_JobTask."Job Task No." := NS_JobTaskNo;
                        NS_JobTask.Description := NS_JobProcess.NS_Description;
                        //PRJ-1042.JS.1.0 15Dec21 Start
                        NS_JobTask."Job Task Type" := NS_JobProcess."NS_Job Task Type";
                        NS_JobTask.Totaling := NS_JobProcess.NS_Totaling;
                        //PRJ-1042.JS.1.0 15Dec21 end   
                        IF NS_JobProcess."NS_Total Price" <> 0 THEN BEGIN
                            NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobProcess."NS_Total Price" - NS_JobProcess."NS_Total Cost") / NS_JobProcess."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                            NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobProcess."NS_Total Cost" / NS_JobProcess."NS_Total Price")) * 100;
                        END;
                        NS_JobTask."NS_Gross Profit" := NS_JobProcess."NS_Total Price" - NS_JobProcess."NS_Total Cost";
                        IF FromQuote THEN
                            NS_JobTask."NS_Quote No." := "No.";
                        //PRJ-1406.GK.1.0 18May2022 start
                        OnLoadTaskProcessOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobProcess);
                        //PRJ-1406.GK.1.0 18May2022 end

                        // //PRJCTPR-362.PS.1.0 01May2024 Start

                        if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                            SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                            NS_InsertDimension(SubleveJobNo, NS_JobTask);
                            if NS_Job.Get(SubleveJobNo) then;
                            NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                        end;

                        // //PRJCTPR-362.PS.1.0 01May2024 End 

                        NS_JobTask.INSERT;

                    END;
                UNTIL NS_JobProcess.NEXT = 0;
            NS_JobTask.NS_IndentJobTask(Rec."No.");   //PRJ-1042.JS.1.0  add line
        END ELSE BEGIN
            IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::JobType) AND (NOT SkipTasks) THEN BEGIN
                NS_JobProcess.RESET;
                NS_JobProcess.SETCURRENTKEY("NS_DefaultTaskforJobType");
                //PRJCTPR-197 Dk.1.0 Start
                // NS_JobProcess.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type");
                NS_JobProcess.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type New");
                //PRJCTPR-197 Dk.1.0 End
                IF NS_JobProcess.FINDSET THEN
                    REPEAT
                        NS_JobTaskNo := APOToJobTaskNo(NS_JobProcess."NS_Activity Code", NS_JobProcess.NS_Code, '', '');//PRJ-688.AM.1.0
                        IF NOT NS_JobTaskCheck.GET("No.", NS_JobTaskNo) THEN BEGIN
                            NS_JobTask.INIT;
                            NS_JobTask."Job No." := "No.";
                            NS_JobTask."Job Task No." := NS_JobTaskNo;
                            NS_JobTask.Description := NS_JobProcess.NS_Description;
                            //PRJ-1042.JS.1.0 15Dec21 Start
                            NS_JobTask."Job Task Type" := NS_JobProcess."NS_Job Task Type";
                            NS_JobTask.Totaling := NS_JobProcess.NS_Totaling;
                            //PRJ-1042.JS.1.0 15Dec21 end   
                            IF NS_JobProcess."NS_Total Price" <> 0 THEN BEGIN
                                NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobProcess."NS_Total Price" - NS_JobProcess."NS_Total Cost") / NS_JobProcess."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                                NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobProcess."NS_Total Cost" / NS_JobProcess."NS_Total Price")) * 100;
                            END;
                            NS_JobTask."NS_Gross Profit" := NS_JobProcess."NS_Total Price" - NS_JobProcess."NS_Total Cost";
                            IF FromQuote THEN
                                NS_JobTask."NS_Quote No." := "No.";
                            //PRJ-1406.GK.1.0 18May2022 start
                            OnLoadTaskProcessOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobProcess);
                            //PRJ-1406.GK.1.0 18May2022 end
                            //PRJCTPR-362.PS.1.0 01May2024 Start


                            // //PRJCTPR-362.PS.1.0 01May2024 Start
                            if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                                SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                                NS_InsertDimension(SubleveJobNo, NS_JobTask);
                                if NS_Job.Get(SubleveJobNo) then;
                                NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                                NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            end;
                            //Code for Job Quote Dimention Update on Job Task line  Start

                            // if NS_jobQuoteHeader.Get("No.") then;
                            // //if NS_jobQuoteHeader."NS_Created by Job" <> '' then begin
                            // NS_InsertDimensionQuotetaskLine(Rec."NS_Sub-Level to Job No.", NS_JobTask);
                            //end;


                            //Code for Job Quote Dimention Update on Job Task line E
                            // //PRJCTPR-362.PS.1.0 01May2024 End
                            NS_JobTask.INSERT;

                        END;
                    UNTIL NS_JobProcess.NEXT = 0;
                NS_JobTask.NS_IndentJobTask(Rec."No.");   //PRJ-1042.JS.1.0  add line
            END;
        END;
    END;

    LOCAL PROCEDURE LoadTasksOperation();
    var//PRJ-199:16APRIL2020
        JobsSetup: Record "Jobs Setup";//PRJ-199:16APRIL2020
                                       //PRJCTPR-338.DK.1.0 19March Start
        NS_Job: Record Job;
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Job Task Dimension";
        SubleveJobNo: Code[20];//  //PRJCTPR-362.PS.1.0 01May2024
    //PRJCTPR-338.DK.1.0 19March End
    BEGIN
        JobsSetup.Get;//PRJ-199:16APRIL2020
        IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::Default) AND (NOT SkipTasks) THEN BEGIN
            NS_JobOperation.RESET;
            NS_JobOperation.SETCURRENTKEY("NS_Default onto each Job");
            NS_JobOperation.SETRANGE("NS_Default onto each Job", TRUE);
            IF NS_JobOperation.FINDSET THEN
                REPEAT
                    NS_JobTaskNo := APOToJobTaskNo(NS_JobOperation."NS_Activity Code", NS_JobOperation."NS_Process Code", NS_JobOperation.NS_Code, '');//PRJ-688.AM.1.0
                    IF NOT NS_JobTaskCheck.GET("No.", NS_JobTaskNo) THEN BEGIN
                        NS_JobTask.INIT;
                        NS_JobTask."Job No." := "No.";
                        NS_JobTask."Job Task No." := NS_JobTaskNo;
                        NS_JobTask.Description := NS_JobOperation.NS_Description;
                        IF NS_JobOperation."NS_Total Price" <> 0 THEN BEGIN
                            NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobOperation."NS_Total Price" - NS_JobOperation."NS_Total Cost") / NS_JobOperation."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                            NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobOperation."NS_Total Cost" / NS_JobOperation."NS_Total Price")) * 100;
                        END;
                        NS_JobTask."NS_Gross Profit" := NS_JobOperation."NS_Total Price" - NS_JobOperation."NS_Total Cost";
                        IF FromQuote THEN
                            NS_JobTask."NS_Quote No." := "No.";
                        //PRJ-1406.GK.1.0 18May2022 start
                        OnLoadTaskOperationOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobOperation);
                        //PRJ-1406.GK.1.0 18May2022 end
                        // //PRJCTPR-362.PS.1.0 01May2024 Start
                        if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                            SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                            NS_InsertDimension(SubleveJobNo, NS_JobTask);
                            if NS_Job.Get(SubleveJobNo) then;
                            NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                            NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                        end;

                        // //PRJCTPR-362.PS.1.0 01May2024 End 
                        NS_JobTask.INSERT;

                    END;
                UNTIL NS_JobOperation.NEXT = 0;
        END ELSE BEGIN
            IF (JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::JobType) AND (NOT SkipTasks) THEN BEGIN
                NS_JobOperation.RESET;
                NS_JobOperation.SETCURRENTKEY("NS_DefaultTaskforJobType");
                //PRJCTPR-197 DK.1.0 Start
                // NS_JobOperation.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type");
                NS_JobOperation.SETRANGE("NS_DefaultTaskforJobType", "NS_Job Type New");
                //PRJCTPR-197 DK.1.0 End
                IF NS_JobOperation.FINDSET THEN
                    REPEAT
                        NS_JobTaskNo := APOToJobTaskNo(NS_JobOperation."NS_Activity Code", NS_JobOperation."NS_Process Code", NS_JobOperation.NS_Code, '');//PRJ-688.AM.1.0
                        IF NOT NS_JobTaskCheck.GET("No.", NS_JobTaskNo) THEN BEGIN
                            NS_JobTask.INIT;
                            NS_JobTask."Job No." := "No.";
                            NS_JobTask."Job Task No." := NS_JobTaskNo;
                            NS_JobTask.Description := NS_JobOperation.NS_Description;
                            IF NS_JobOperation."NS_Total Price" <> 0 THEN BEGIN
                                NS_JobTask."NS_Mark-up" := ROUND(1 - ((NS_JobOperation."NS_Total Price" - NS_JobOperation."NS_Total Cost") / NS_JobOperation."NS_Total Price"), NS_GLSetup."Amount Rounding Precision");
                                NS_JobTask."NS_Gross Profit Percentage" := (1 - (NS_JobOperation."NS_Total Cost" / NS_JobOperation."NS_Total Price")) * 100;
                            END;
                            NS_JobTask."NS_Gross Profit" := NS_JobOperation."NS_Total Price" - NS_JobOperation."NS_Total Cost";
                            IF FromQuote THEN
                                NS_JobTask."NS_Quote No." := "No.";
                            //PRJ-1406.GK.1.0 18May2022 start
                            OnLoadTaskOperationOnBeforeInsertJobTaskLines(NS_JobTask, NS_JobOperation);
                            //PRJ-1406.GK.1.0 18May2022 end
                            // //PRJCTPR-362.PS.1.0 01May2024 Start

                            if (Rec."NS_Sub-Level to Job No." <> '') OR (Rec."NS_Change Request to Job No." <> '') then begin
                                SubleveJobNo := Rec."NS_Sub-Level to Job No." + Rec."NS_Change Request to Job No.";
                                NS_InsertDimension(SubleveJobNo, NS_JobTask);
                                if NS_Job.Get(SubleveJobNo) then;
                                NS_JobTask."Global Dimension 1 Code" := NS_Job."Global Dimension 1 Code";
                                NS_JobTask."Global Dimension 2 Code" := NS_Job."Global Dimension 2 Code";
                            end;


                            // //PRJCTPR-362.PS.1.0 01May2024 End 
                            NS_JobTask.INSERT;

                        END;
                    UNTIL NS_JobOperation.NEXT = 0;
            END;
        END;
    END;

    PROCEDURE CreateChangeOrder(PassJob: Record 167);
    VAR
        JobsSetup: Record 315;
        NewJob: Record 167;
        JobPage: Page 88;
        SegmentsRec: Record "NS_Job Takeoff Segments"; //PPAL-171.AM.1.0 
        TargetSegmentRec: Record "NS_Job Takeoff Segments";//PPAL-171.AM.1.0
        DefaultDimRec: Record "Default Dimension";//ppal-174.AS.1.0 28DEC2020
        DefaultDimRec2: Record "Default Dimension";//ppal-174.AS.1.0 28DEC2020
        PassJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobs2: Record Job; //PRJ-1015.JS.1.0   12Oct2021
    BEGIN
        JobsSetup.GET;
        WITH NewJob DO BEGIN
            INIT;
            NewJob.SetCopyJob(TRUE);
            "No." := GetNextChangeOrderNo(PassJob."No.", JobsSetup."NS_Change Order No. Separator");
            // "Global Dimension 1 Code" := PassJob."Global Dimension 1 Code";//ppal-174.AS.1.0 28DEC2020 Commented
            // // "Global Dimension 2 Code" := "Global Dimension 2 Code";//ppal-174.AS.1.0 28DEC2020 Commented
            "No. Series" := '';
            NewJob."NS_Sub-Level to Job No." := PassJob."No."; //PE-120.NC.1.0 26Jun2023
            INSERT(TRUE);
            NS_CreateMainJobTask(PassJob."No.", NewJob."No."); //PRJ-1286.NK.1.0 05Apr2022
            "Search Description" := PassJob."Search Description";
            Description := PassJob.Description;
            "Description 2" := PassJob."Description 2";
            "Bill-to Customer No." := PassJob."Bill-to Customer No.";
            "Creation Date" := TODAY;
            "Starting Date" := 0D;
            "Ending Date" := 0D;
            Status := Status::Planning;
            "Person Responsible" := PassJob."Person Responsible";
            // VALIDATE("Global Dimension 1 Code");//ppal-174.AS.1.0 28DEC2020 Commented
            // VALIDATE("Global Dimension 2 Code");//ppal-174.AS.1.0 28DEC2020 Commented
            "Global Dimension 1 Code" := PassJob."Global Dimension 1 Code";//ppal-174.AS.1.0 28DEC2020 Added
            "Global Dimension 2 Code" := PassJob."Global Dimension 2 Code";//ppal-174.AS.1.0 28DEC2020 Added
            "Job Posting Group" := PassJob."Job Posting Group";
            Blocked := Blocked::" ";
            "Customer Disc. Group" := PassJob."Customer Disc. Group";
            "Customer Price Group" := PassJob."Customer Price Group";
            "Language Code" := PassJob."Language Code";
            "Bill-to Name" := PassJob."Bill-to Name";
            "Bill-to Address" := PassJob."Bill-to Address";
            "Bill-to Address 2" := PassJob."Bill-to Address 2";
            "Bill-to City" := PassJob."Bill-to City";
            "Bill-to County" := PassJob."Bill-to County";
            "Bill-to Post Code" := PassJob."Bill-to Post Code";
            "No. Series" := PassJob."No. Series";
            "Bill-to Country/Region Code" := PassJob."Bill-to Country/Region Code";
            "WIP Method" := PassJob."WIP Method";
            "Currency Code" := PassJob."Currency Code";
            "Bill-to Contact No." := PassJob."Bill-to Contact No.";
            "Bill-to Contact" := PassJob."Bill-to Contact";
            //PRJ-214:AS:09APRIL2020 - START
            "NS_Sell-to Customer No." := PassJob."NS_Sell-to Customer No.";
            "NS_Sell-to Customer Name" := PassJob."NS_Sell-to Customer Name";
            //PRJ-214:AS:09APRIL2020 - END
            //PRJCTPR-200.NC.1.0 29SEP2023 Start
            NewJob."Sell-to Customer No." := PassJob."Sell-to Customer No.";
            NewJob."Sell-to Customer Name" := PassJob."Sell-to Customer Name";
            //PRJCTPR-200.NC.1.0 29SEP2023 End
            //NewJob.Validate("Sell-to Customer No.", PassJob."Sell-to Customer No."); //PRJCTPR-338.PS.2.0 17April2024 Commented
            NewJob."Sell-to Customer No." := PassJob."Sell-to Customer No."; //PRJCTPR-338.PS.2.0 17April2024 Removed validation 
            NewJob."Sell-to Customer Name" := PassJob."Sell-to Customer Name";
            //PRJ-464.AM.1.0 start
            "NS_Salesperson Code" := PassJob."NS_Salesperson Code";
            //"NS_Gen. Bus. Posting Group" := PassJob."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            "NS_Gen. Bus. Posting Group New" := PassJob."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
            //"NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            "NS_Gen. Prod. Posting Group New" := PassJob."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
            //PRJ-464.AM.1.0 end
            "WIP Posting Date" := PassJob."WIP Posting Date";
            "WIP Posting Method" := PassJob."WIP Posting Method";
            "Invoice Currency Code" := PassJob."Invoice Currency Code";
            "Exch. Calculation (Cost)" := PassJob."Exch. Calculation (Cost)";
            "Exch. Calculation (Price)" := PassJob."Exch. Calculation (Price)";
            "Allow Schedule/Contract Lines" := PassJob."Allow Schedule/Contract Lines";
            "NS_Job Address 1" := PassJob."NS_Job Address 1";
            "NS_Job Address 2" := PassJob."NS_Job Address 2";
            "NS_Job City" := PassJob."NS_Job City";
            "NS_Job County" := PassJob."NS_Job County";
            "NS_Job Post Code" := PassJob."NS_Job Post Code";
            "NS_Job Country/Region Code" := PassJob."NS_Job Country/Region Code";
            "NS_Job Contact" := PassJob."NS_Job Contact";
            "NS_Job Phone" := PassJob."NS_Job Phone";
            "NS_Job Ship-to Code" := PassJob."NS_Job Ship-to Code";
            "NS_Temp Linked Parent Job No." := PassJob."NS_Temp Linked Parent Job No.";
            "NS_Last Job For Job List" := PassJob."NS_Last Job For Job List";

            // PRJCTPR-197 Dk.1.0 Start
            // "NS_Job Type" := PassJob."NS_Job Type";
            "NS_Job Type New" := PassJob."NS_Job Type New";
            // PRJCTPR-197 Dk.1.0 End
            NS_Estimator := PassJob.NS_Estimator;
            NS_Manager := PassJob.NS_Manager;
            "NS_Manager Job Status" := PassJob."NS_Manager Job Status";
            "NS_Job Status Date" := 0D;
            "NS_Estimated Start Date" := 0D;
            "NS_Estimated Completion Date" := 0D;
            "NS_Completion Date" := 0D;
            "NS_Job Posting Date" := PassJob."NS_Job Posting Date";
            "NS_Recognition Date" := PassJob."NS_Recognition Date";
            "NS_Unit of Measure" := '';
            "NS_Total Units" := 0;
            "NS_Billing method" := PassJob."NS_Billing method";
            "NS_Recognition Method" := PassJob."NS_Recognition Method";
            "NS_Default Job Retention" := PassJob."NS_Default Job Retention";
            "NS_Tax Area Code" := PassJob."NS_Tax Area Code";
            "NS_Tax Liable" := PassJob."NS_Tax Liable";
            "NS_Tax Group Code New" := PassJob."NS_Tax Group Code New";
            "NS_VAT Bus. Posting Group" := PassJob."NS_VAT Bus. Posting Group";
            "NS_VAT Prod. Posting Group" := PassJob."NS_VAT Prod. Posting Group";
            "NS_Actual Percent Complete" := 0;
            "NS_Actual PercentCompleteDate" := 0D;
            "NS_Actual Units Complete" := 0;
            "NS_Actual Units Complete Date" := 0D;
            "NS_Job Revenue Posting" := PassJob."NS_Job Revenue Posting";
            // NewJob."NS_Progress Billing No." := PassJob."NS_Progress Billing No.";//PRJ-1285.RM.1.0 commented
            "NS_Progress Billing Sub-Level" := PassJob."NS_Progress Billing Sub-Level";
            "NS_Customer Job No." := PassJob."NS_Customer Job No.";
            "NS_Customer PO Number" := '';
            "NS_Contract No." := PassJob."NS_Contract No.";
            "NS_Contract Date" := PassJob."NS_Contract Date";
            "NS_Contract For" := PassJob."NS_Contract For";
            //NewJob."NS_Sub-Level to Job No." := PassJob."No."; //PE-120.NC.1.0 26Jun2023 Block
            "NS_Job Class" := "NS_Job Class"::"Change Order";
            NewJob."NS_Job Purchaser" := PassJob."NS_Job Purchaser"; //PRJ-1380.NK.1.0 12May2022

            //PRJ-1015.JS.1.0  12Oct2021 - Start
            if PassJob."NS_Job Class" = PassJob."NS_Job Class"::"Master Job" then
                NewJob."NS_Root Job No." := PassJob."No."
            else
                NewJob."NS_Root Job No." := PassJob."NS_Root Job No.";
            //PRJ-1015.JS.1.0  12Oct2021 - Start    

            //ppal-174.AS.1.0 28DEC2020 start
            DefaultDimRec.Reset;
            DefaultDimRec.SetRange("Table ID", 167);
            DefaultDimRec.SetRange("No.", PassJob."No.");
            if DefaultDimRec.FindSet then
                repeat
                    DefaultDimRec2.Init;
                    DefaultDimRec2."Table ID" := 167;
                    DefaultDimRec2."No." := NewJob."No.";
                    DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                    DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                    DefaultDimRec2.Insert;
                until DefaultDimRec.Next = 0;
            //ppal-174.AS.1.0 28DEC2020 end
            MODIFY;
        end;

        //PPAL-171.AM.1.0 Start
        //Segment List flow start
        SegmentsRec.Reset();
        SegmentsRec.SetRange("NS_Job No.", PassJob."No.");
        if SegmentsRec.FindSet() then
            repeat
                TargetSegmentRec.Init();
                TargetSegmentRec.validate("NS_Job No.", NewJob."No.");
                TargetSegmentRec."NS_Segment Code" := SegmentsRec."NS_Segment Code";
                TargetSegmentRec.NS_Type := SegmentsRec.NS_Type;
                TargetSegmentRec."NS_Size of Weld" := SegmentsRec."NS_Size of Weld";
                TargetSegmentRec."NS_Segment Name" := SegmentsRec."NS_Segment Name";
                TargetSegmentRec."NS_Segment Description" := SegmentsRec."NS_Segment Description";
                TargetSegmentRec."NS_Billing Type" := SegmentsRec."NS_Billing Type";
                TargetSegmentRec."NS_Unit of Measure Code" := SegmentsRec."NS_Unit of Measure Code";
                TargetSegmentRec.validate("NS_Estimated Quantity", SegmentsRec."NS_Estimated Quantity");
                TargetSegmentRec.Validate("NS_Unit Rate", SegmentsRec."NS_Unit Rate");
                TargetSegmentRec.Validate("NS_Total Cost", SegmentsRec."NS_Total Cost");
                TargetSegmentRec.Insert();
            until SegmentsRec.Next() = 0;

        //Segment List Flow End
        //PPAL-171.AM.1.0  End

        //PRJ-1015.JS.1.0  12Oct2021 - Start
        if NewJobs2.get(NewJob."NS_Root Job No.") then begin
            if NewJobs2."NS_Include Sub Levels" = true then begin
                PassJobTask.Reset();
                PassJobTask.SetRange("Job No.", NewJobs2."No.");
                if PassJobTask.FindFirst() then
                    repeat
                        //PRJCTPR-289.HS.1.0 16Jan2024 Start
                        NewJobTask.Reset();
                        NewJobTask.SetRange("Job No.", NewJob."No.");
                        NewJobTask.SetRange("Job Task No.", PassJobTask."Job Task No.");
                        if not NewJobTask.FindFirst() then begin
                            //PRJCTPR-289.HS.1.0 16Jan2024 End
                            NewJobTask.Init();
                            //NewJobTask.TransferFields(PassJobTask);
                            NewJobTask."Job No." := NewJob."No.";
                            NewJobTask.Validate("Job Task No.", PassJobTask."Job Task No.");
                            NewJobTask."Job Task Type" := PassJobTask."Job Task Type"; //PRJCTPR-289.HS.1.0 14FEB2024
                            NewJobTask.Insert();
                        end;
                    until PassJobTask.Next() = 0;
            end;
        end;
        //PRJ-1015.JS.1.0  12Oct2021 - end      

        IF CONFIRM('Job No. ' + NewJob."No." + ' has been created. Go to new Job?') THEN BEGIN
            JobPage.SETRECORD(NewJob);
            JobPage.RUN;
        END;
    END;
    //PRJ-1286.NK.1.0 05Apr2022 Start
    local procedure NS_CreateMainJobTask(OldJobNo: Code[20]; NewJobNo: Code[20])
    var
        jobTast: Record "Job Task";
        OldJobTast: Record "Job Task";
        //PRJCTPR-338.DK.2.0 19March Start
        NS_Job: Record Job;
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Job Task Dimension";
    //PRJCTPR-338.DK.2.0 19March End
    begin
        if not Rec."NS_Include Sub Levels" then begin
            jobTast.Reset();
            jobTast.SetRange("Job No.", NewJobNo);
            if jobTast.IsEmpty() then begin
                if Confirm('Do you wish to use Master Job Tasks?', false) then begin
                    OldJobTast.Reset();
                    OldJobTast.SetRange("Job No.", OldJobNo);
                    if OldJobTast.FindFirst() then
                        repeat
                            jobTast.Init();
                            jobTast.TransferFields(OldJobTast);
                            jobTast."Job No." := NewJobNo;
                            //PRJCTPR-338.DK.2.0 19March Start
                            DefaultDimRec.Reset();
                            DefaultDimRec.SetRange("Table ID", 167);
                            DefaultDimRec.SetRange("No.", OldJobNo);
                            if DefaultDimRec.FindSet() then
                                repeat
                                    DefaultDimRec2.Init();
                                    DefaultDimRec2."Job No." := jobTast."Job No.";
                                    DefaultDimRec2."Job Task No." := jobTast."Job Task No.";
                                    DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                                    DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                                    DefaultDimRec2.Insert();
                                until DefaultDimRec.Next() = 0;
                            //PRJCTPR-338.DK.2.0 19March End
                            jobTast.Insert();
                        until OldJobTast.Next() = 0;
                end;
            end;
        end;
        //PRJCTPR-289.HS.1.0 14FEB2024 - start
        if Rec."NS_Include Sub Levels" = true then begin
            jobTast.Reset();
            jobTast.SetRange("Job No.", NewJobNo);
            if jobTast.IsEmpty() then begin
                if Confirm('Do you wish to use Master Job Tasks?', false) then begin
                    OldJobTast.Reset();
                    OldJobTast.SetRange("Job No.", OldJobNo);
                    if OldJobTast.FindFirst() then
                        repeat
                            jobTast.Init();
                            jobTast.TransferFields(OldJobTast);
                            jobTast."Job No." := NewJobNo;
                            jobTast.Insert();
                        until OldJobTast.Next() = 0;
                end;
            end;
        end;
        //PRJCTPR-289.HS.1.0 14FEB2024 - end
    end;
    //PRJ-1286.NK.1.0 05Apr2022 End

    LOCAL PROCEDURE GetNextChangeOrderNo(PassJobNo: Code[20]; PassJobSeparator: Text[10]): Code[20];
    VAR
        JobRec: Record 167;
        NS_JobSetup: Record "Jobs Setup";     //PE-246.HS.1.0 1Feb2024 
    BEGIN
        if NS_JobSetup.Get() then;    //PE-246.HS.1.0 1Feb2024 
        if (NS_JobSetup."NS_Change Ordr NumberingFormat" = '') then begin   //PE-246.HS.1.0 1Feb2024 
            JobRec.RESET;
            Job.SETFILTER("No.", '%1', PassJobNo + PassJobSeparator + '*');
            IF Job.FINDLAST THEN BEGIN
                EXIT(INCSTR(Job."No."));
            END ELSE
                EXIT(PassJobNo + PassJobSeparator + '001');
        end    //PE-246.HS.1.0 1Feb2024 
        else
            //PE-246.HS.1.0 1Feb2024 Start
            begin
            Job.Reset();
            Job.SETFILTER("No.", '%1', PassJobNo + PassJobSeparator + '*');
            IF Job.FindLast() THEN Begin
                EXIT(INCSTR(Job."No."));
            end ELSE
                EXIT(PassJobNo + PassJobSeparator + NS_JobSetup."NS_Change Ordr NumberingFormat");
        end;
        //PE-246.HS.1.0 1Feb2024 End
    END;

    PROCEDURE CreateWorkOrder(PassJob: Record 167);
    VAR
        JobsSetup: Record 315;
        NewJob: Record 167;
        JobPage: Page 88;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SegmentsRec: Record "NS_Job Takeoff Segments"; //PPAL-171.AM.1.0 
        TargetSegmentRec: Record "NS_Job Takeoff Segments";//PPAL-171.AM.1.0 
        PassJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobs2: Record Job; //PRJ-1015.JS.1.0   12Oct2021 
        DefaultDimRec: Record "Default Dimension";//PRJCTPR-362.PS.1.0 2024
        DefaultDimRec2: Record "Default Dimension";//PRJCTPR-362.PS.1.0 2024

    BEGIN

        JobsSetup.GET;
        JobsSetup.TESTFIELD("NS_Work Order No. Series");
        WITH NewJob DO BEGIN
            INIT;
            NewJob.SetCopyJob(TRUE);
            NoSeriesMgt.InitSeries(JobsSetup."NS_Work Order No. Series", xRec."No. Series", 0D, "No.", "No. Series");
            //"No." := GetNextChangeOrderNo(PassJob."No.",JobsSetup."Change Order No. Separator");
            "No. Series" := '';

            NewJob."NS_Sub-Level to Job No." := PassJob."No."; //PRJCTPR-362.PS.1.0 15May2024
            INSERT(TRUE);
            "Search Description" := PassJob."Search Description";
            Description := PassJob.Description;
            "Description 2" := PassJob."Description 2";
            "Bill-to Customer No." := PassJob."Bill-to Customer No.";
            "Creation Date" := TODAY;
            "Starting Date" := 0D;
            "Ending Date" := 0D;
            Status := Status::Planning;
            "Person Responsible" := PassJob."Person Responsible";
            // VALIDATE("Global Dimension 1 Code"); //PRJCTPR-362.PS.1.0 Commented
            // VALIDATE("Global Dimension 2 Code"); //PRJCTPR-362.PS.1.0 Commented
            "Job Posting Group" := PassJob."Job Posting Group";
            Blocked := Blocked::" ";
            "Customer Disc. Group" := PassJob."Customer Disc. Group";
            "Customer Price Group" := PassJob."Customer Price Group";
            "Language Code" := PassJob."Language Code";
            "Bill-to Name" := PassJob."Bill-to Name";
            "Bill-to Address" := PassJob."Bill-to Address";
            "Bill-to Address 2" := PassJob."Bill-to Address 2";
            "Bill-to City" := PassJob."Bill-to City";
            "Bill-to County" := PassJob."Bill-to County";
            "Bill-to Post Code" := PassJob."Bill-to Post Code";
            "No. Series" := PassJob."No. Series";
            "Bill-to Country/Region Code" := PassJob."Bill-to Country/Region Code";
            "WIP Method" := PassJob."WIP Method";
            "Currency Code" := PassJob."Currency Code";
            "Bill-to Contact No." := PassJob."Bill-to Contact No.";
            "Bill-to Contact" := PassJob."Bill-to Contact";
            "WIP Posting Date" := PassJob."WIP Posting Date";
            "WIP Posting Method" := PassJob."WIP Posting Method";
            "Invoice Currency Code" := PassJob."Invoice Currency Code";
            "Exch. Calculation (Cost)" := PassJob."Exch. Calculation (Cost)";
            "Exch. Calculation (Price)" := PassJob."Exch. Calculation (Price)";
            "Allow Schedule/Contract Lines" := PassJob."Allow Schedule/Contract Lines";
            "NS_Job Address 1" := PassJob."NS_Job Address 1";
            "NS_Job Address 2" := PassJob."NS_Job Address 2";
            "NS_Job City" := PassJob."NS_Job City";
            "NS_Job County" := PassJob."NS_Job County";
            "NS_Job Post Code" := PassJob."NS_Job Post Code";
            "NS_Job Country/Region Code" := PassJob."NS_Job Country/Region Code";
            "NS_Job Contact" := PassJob."NS_Job Contact";
            "NS_Job Phone" := PassJob."NS_Job Phone";
            "NS_Job Ship-to Code" := PassJob."NS_Job Ship-to Code";
            "NS_Temp Linked Parent Job No." := PassJob."NS_Temp Linked Parent Job No.";
            "NS_Last Job For Job List" := PassJob."NS_Last Job For Job List";
            NewJob."Global Dimension 1 Code" := PassJob."Global Dimension 1 Code"; //PRJCTPR-362.PS.1.0 31May2024
            NewJob."Global Dimension 2 Code" := PassJob."Global Dimension 2 Code"; //PRJCTPR-362.PS.1.0 31May2024
            //PRJCTPR-197 Dk.1.0 Start
            // NewJob."NS_Job Type" := PassJob."NS_Job Type";
            NewJob."NS_Job Type New" := PassJob."NS_Job Type New";
            //PRJCTPR-197 Dk.1.0 End
            NS_Estimator := PassJob.NS_Estimator;
            NS_Manager := PassJob.NS_Manager;
            //"Manager Job Status" := PassJob."Manager Job Status";
            "NS_Manager Job Status" := "NS_Manager Job Status"::Running;
            //PRJ-464.AM.1.0 start
            "NS_Salesperson Code" := PassJob."NS_Salesperson Code";
            //"NS_Gen. Bus. Posting Group" := PassJob."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            "NS_Gen. Bus. Posting Group New" := PassJob."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
            //"NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
            "NS_Gen. Prod. Posting Group New" := PassJob."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
            //PRJ-464.AM.1.0 end
            "NS_Job Status Date" := 0D;
            "NS_Estimated Start Date" := 0D;
            "NS_Estimated Completion Date" := 0D;
            "NS_Completion Date" := 0D;
            "NS_Job Posting Date" := PassJob."NS_Job Posting Date";
            "NS_Recognition Date" := PassJob."NS_Recognition Date";
            "NS_Unit of Measure" := '';
            "NS_Total Units" := 0;
            "NS_Billing method" := PassJob."NS_Billing method";
            "NS_Recognition Method" := PassJob."NS_Recognition Method";
            "NS_Default Job Retention" := PassJob."NS_Default Job Retention";
            "NS_Tax Area Code" := PassJob."NS_Tax Area Code";
            "NS_Tax Liable" := PassJob."NS_Tax Liable";
            "NS_Tax Group Code New" := PassJob."NS_Tax Group Code New";
            "NS_VAT Bus. Posting Group" := PassJob."NS_VAT Bus. Posting Group";
            "NS_VAT Prod. Posting Group" := PassJob."NS_VAT Prod. Posting Group";
            "NS_Actual Percent Complete" := 0;
            "NS_Actual PercentCompleteDate" := 0D;
            "NS_Actual Units Complete" := 0;
            "NS_Actual Units Complete Date" := 0D;
            "NS_Job Revenue Posting" := PassJob."NS_Job Revenue Posting";
            "NS_Progress Billing No." := PassJob."NS_Progress Billing No.";
            "NS_Progress Billing Sub-Level" := PassJob."NS_Progress Billing Sub-Level";
            "NS_Customer Job No." := PassJob."NS_Customer Job No.";
            "NS_Customer PO Number" := '';
            "NS_Contract No." := PassJob."NS_Contract No.";
            "NS_Contract Date" := PassJob."NS_Contract Date";
            "NS_Contract For" := PassJob."NS_Contract For";
            "NS_Sub-Level to Job No." := PassJob."No.";
            "NS_Job Class" := "NS_Job Class"::"Work Order";
            //PRJCTPR-200.NC.1.0 04Oct2023 Start
            NewJob."NS_Sell-to Customer No." := PassJob."NS_Sell-to Customer No.";
            NewJob."NS_Sell-to Customer Name" := PassJob."NS_Sell-to Customer Name";
            NewJob.Validate("Sell-to Customer No.", PassJob."Sell-to Customer No.");
            NewJob."Sell-to Customer Name" := PassJob."Sell-to Customer Name";
            //PRJCTPR-200.NC.1.0 04Oct2023 End
            NewJob."NS_Job Purchaser" := PassJob."NS_Job Purchaser"; //PRJ-1380.NK.1.0 12May2022
            //PRJ-1015.JS.1.0  12Oct2021 - Start
            if PassJob."NS_Job Class" = PassJob."NS_Job Class"::"Master Job" then
                NewJob."NS_Root Job No." := PassJob."No."
            else
                NewJob."NS_Root Job No." := PassJob."NS_Root Job No.";
            //PRJ-1015.JS.1.0  12Oct2021 - Start
            MODIFY;
            CopyCostPricing(NewJob, PassJob);
        END;
        //PPAL-171.AM.1.0 Start
        //Segment List flow start
        SegmentsRec.Reset();
        SegmentsRec.SetRange("NS_Job No.", PassJob."No.");
        if SegmentsRec.FindSet() then
            repeat
                TargetSegmentRec.Init();
                TargetSegmentRec.validate("NS_Job No.", NewJob."No.");
                TargetSegmentRec."NS_Segment Code" := SegmentsRec."NS_Segment Code";
                TargetSegmentRec.NS_Type := SegmentsRec.NS_Type;
                TargetSegmentRec."NS_Size of Weld" := SegmentsRec."NS_Size of Weld";
                TargetSegmentRec."NS_Segment Name" := SegmentsRec."NS_Segment Name";
                TargetSegmentRec."NS_Segment Description" := SegmentsRec."NS_Segment Description";
                TargetSegmentRec."NS_Billing Type" := SegmentsRec."NS_Billing Type";
                TargetSegmentRec."NS_Unit of Measure Code" := SegmentsRec."NS_Unit of Measure Code";
                TargetSegmentRec.validate("NS_Estimated Quantity", SegmentsRec."NS_Estimated Quantity");
                TargetSegmentRec.Validate("NS_Unit Rate", SegmentsRec."NS_Unit Rate");
                TargetSegmentRec.Validate("NS_Total Cost", SegmentsRec."NS_Total Cost");
                TargetSegmentRec.Insert();
            until SegmentsRec.Next() = 0;

        //Segment List Flow End
        // PPAL-171.AM.1.0  End
        //PRJCTPR-362.PS.1.0 2024 Start

        DefaultDimRec.Reset();
        DefaultDimRec.SetRange("Table ID", 167);
        DefaultDimRec.SetRange("No.", PassJob."No.");
        if DefaultDimRec.FindSet() then
            repeat
                DefaultDimRec2.Init();
                DefaultDimRec2."Table ID" := 167;
                DefaultDimRec2."No." := NewJob."No.";
                DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                DefaultDimRec2.Insert();
            until DefaultDimRec.Next() = 0;

        //PRJCTPR-362.PS.1.0 2024 End 

        //PRJ-1015.JS.1.0  12Oct2021 - Start
        if NewJobs2.get(NewJob."NS_Root Job No.") then begin
            if NewJobs2."NS_Include Sub Levels" = true then begin
                PassJobTask.Reset();
                PassJobTask.SetRange("Job No.", NewJobs2."No.");
                if PassJobTask.FindFirst() then
                    repeat
                        NewJobTask.Init();
                        //NewJobTask.TransferFields(PassJobTask);
                        NewJobTask."Job No." := NewJob."No.";
                        NewJobTask."Job Task No." := PassJobTask."Job Task No.";//PRJCTPR-362.PS.1.0 15May2024
                        NewJobTask."Job Task Type" := PassJobTask."Job Task Type"; //PRJCTPR-289.HS.1.0 14FEB2024
                        NewJobTask.Insert()
                    until PassJobTask.Next() = 0;
            end;
        end;
        //PRJ-1015.JS.1.0  12Oct2021 - end   

        IF CONFIRM('Job No. ' + NewJob."No." + ' has been created. Go to new Job?') THEN BEGIN
            JobPage.SETRECORD(NewJob);
            JobPage.RUN;
        END;
    END;

    //PRJ-914.AS.1.0 20OCT2021 START
    PROCEDURE NS_CreateChangeOrderQuoatation(PassJob: Record 167);
    VAR
        JobsSetup: Record 315;
        NewJob: Record "NS_Job Quote Header";
        JobPage: Page "NS_Job Quote";
        SegmentsRec: Record "NS_Job Takeoff Segments";
        TargetSegmentRec: Record "NS_Job Takeoff Segments";
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Default Dimension";
        NSMgmtCU: Codeunit NoSeriesManagement;
        JobForecasttable: Record "NS_Job Forecast";
    BEGIN
        JobsSetup.GET;

        NewJob.INIT;
        NewJob."NS_Quote No." := NSMgmtCU.GetNextNo(JobsSetup."NS_Job Quote No. Series", WORKDATE, true);
        NewJob.Validate("NS_Quote No.");
        NewJob.INSERT(TRUE);
        NewJob."NS_Created by Job" := PassJob."No.";
        NewJob.Validate("NS_Sell-to Customer No.", PassJob."NS_Sell-to Customer No.");
        NewJob."NS_Sell-to Customer Name" := PassJob."NS_Sell-to Customer Name";
        NewJob."NS_Shortcut Dimension 1 Code" := PassJob."Global Dimension 1 Code";
        NewJob."NS_Shortcut Dimension 2 Code" := PassJob."Global Dimension 2 Code";
        //NewJob.Validate("NS_Job No.", NewJob."NS_Quote No.");//temp
        NewJob."NS_Job Description" := PassJob.Description;
        NewJob."NS_Description/Nickname" := PassJob.Description;

        NewJob."NS_Created at Date" := TODAY;
        NewJob."NS_Estimated Start Date" := 0D;

        //PE-300.Dk.1.0  29May2024 Start
        //NewJob.NS_Status := NewJob.NS_Status::Open;
        NewJob."NS_Quote Status" := NewJob."NS_Quote Status"::Open;
        //PE-300.Dk.1.0  29May2024 End

        NewJob."NS_Job Posting Group New" := PassJob."Job Posting Group";
        NewJob."NS_Job Post Code" := PassJob."NS_Job Post Code";
        NewJob."NS_VAT Bus. Posting Group" := PassJob."NS_VAT Bus. Posting Group";
        NewJob."NS_VAT Prod. Posting Group" := PassJob."NS_VAT Prod. Posting Group";

        NewJob."NS_Use Tax %" := PassJob."NS_Use Tax Percentage";

        NewJob.Validate("NS_Bill-to Customer No.", PassJob."Bill-to Customer No.");
        NewJob."NS_Bill-to Customer Name" := PassJob."Bill-to Name";
        NewJob."NS_Bill-to Customer Name" := PassJob."Bill-to Address";
        NewJob."NS_Bill-to Address 2" := PassJob."Bill-to Address 2";
        NewJob."NS_Bill-to City" := PassJob."Bill-to City";
        NewJob."NS_Bill-to County" := PassJob."Bill-to County";
        NewJob."NS_Bill-to Post Code" := PassJob."Bill-to Post Code";

        NewJob."NS_Bill-to Country/Region Code" := PassJob."Bill-to Country/Region Code";
        NewJob."NS_Bill-to Name 2" := PassJob."Bill-to Name 2";

        NewJob."NS_Bill-to Contact No." := PassJob."Bill-to Contact No.";
        NewJob.validate("NS_Salesperson Code New", PassJob."NS_Salesperson Code");


        NewJob."NS_Job Address 1" := PassJob."NS_Job Address 1";
        NewJob."NS_Job Address 2" := PassJob."NS_Job Address 2";
        NewJob."NS_Job City" := PassJob."NS_Job City";
        NewJob."NS_Job County" := PassJob."NS_Job County";
        NewJob."NS_Job Post Code" := PassJob."NS_Job Post Code";
        NewJob."NS_Job Country/Region Code" := PassJob."NS_Job Country/Region Code";

        NewJob."NS_Job Ship-to Code" := PassJob."NS_Job Ship-to Code";
        NewJob."NS_Estimator No." := PassJob.NS_Estimator;
        NewJob."NS_Estimated Start Date" := PassJob."NS_Estimated Start Date";
        NewJob."NS_Estimated Completion Date" := PassJob."NS_Estimated Completion Date";

        NewJob."NS_Project Manager No." := PassJob."NS_Project Manager No.";
        NewJob."NS_Project Manager Name" := PassJob."NS_Project Manager Name";

        NewJob."NS_Estimated Start Date" := 0D;
        NewJob."NS_Estimated Completion Date" := 0D;
        NewJob."NS_Proposal Date" := PassJob."NS_Job Posting Date";


        NewJob."NS_Total Contract Price" := 0;

        NewJob."NS_Tax Group Code" := PassJob."NS_Tax Group Code New";
        NewJob."NS_Tax Area Code" := PassJob."NS_Tax Area Code";
        NewJob."NS_Tax Liable" := PassJob."NS_Tax Liable";
        NewJob."NS_Tax Group Code" := PassJob."NS_Tax Group Code New";
        NewJob."NS_VAT Bus. Posting Group" := PassJob."NS_VAT Bus. Posting Group";
        NewJob."NS_VAT Prod. Posting Group" := PassJob."NS_VAT Prod. Posting Group";

        NewJob."NS_General Contractor No." := PassJob."NS_Contract No.";
        NewJob."NS_General Contractor Name" := PassJob."NS_General Contractor Name";
        NewJob."NS_Use Tax- Contract Type" := PassJob."NS_Contract Type";
        NewJob."NS_Use Tax- Contractor Status" := PassJob."NS_Contract Type";
        NewJob."NS_Owner No." := PassJob."NS_Owner No.";
        NewJob."NS_Owner Name" := PassJob."NS_Owner Name";
        NewJob."NS_Architect/Engineer No." := PassJob."NS_Architect/Engineer No.";
        NewJob."NS_Architect/Engineer Name" := PassJob."NS_Architect/Engineer Name";

        NewJob."NS_Sub-Level to Job No." := PassJob."No.";
        "NewJob"."NS_Job Class" := "NewJob"."NS_Job Class"::"Change Order";
        NewJob."NS_Payment Terms Code" := PassJob."NS_Prepmt. Payment Terms Code";


        //NS_CopyMasterJobTasksToJobChangeOrderQuote(PassJob, NewJob);//PRJ-914.AS.1.0 Commented for Now
        //NS_CopyMasterJPLToJobChangeOrderQuote(PassJob, NewJob);//PRJ-914.AS.1.0 commented for Now
        NewJob.Modify(TRUE);

        // JobForecasttable.reset;
        // JobForecasttable.SetRange("NS_Job No.", NewJob."NS_Quote No.");
        // JobForecasttable.DeleteAll();

        //PRJ-1191.AS.1.0 start
        DefaultDimRec.Reset;
        DefaultDimRec.SetRange("Table ID", 167);
        DefaultDimRec.SetRange("No.", PassJob."No.");
        if DefaultDimRec.FindSet then
            repeat
                DefaultDimRec2.Init;
                //DefaultDimRec2."Table ID" := 14021405;//PRJ-1191.AS.1.0 Commented
                DefaultDimRec2."Table ID" := 14021402;//PRJ-1191.AS.1.0 Added
                DefaultDimRec2."No." := NewJob."NS_Quote No.";
                DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";//PRJ-1191.AS.2.0 Added 02MAR2022
                DefaultDimRec2."Value Posting" := DefaultDimRec."Value Posting";
                DefaultDimRec2.Insert;
            until DefaultDimRec.Next = 0;
        //PRJ-1191.AS.1.0 end

        // SegmentsRec.Reset();
        // SegmentsRec.SetRange("NS_Job No.", PassJob."No.");
        // if SegmentsRec.FindSet() then
        //     repeat
        //         TargetSegmentRec.Init();
        //         TargetSegmentRec.validate("NS_Job No.", NewJob."NS_Quote No.");
        //         TargetSegmentRec."NS_Segment Code" := SegmentsRec."NS_Segment Code";
        //         TargetSegmentRec.NS_Type := SegmentsRec.NS_Type;
        //         TargetSegmentRec."NS_Size of Weld" := SegmentsRec."NS_Size of Weld";
        //         TargetSegmentRec."NS_Segment Name" := SegmentsRec."NS_Segment Name";
        //         TargetSegmentRec."NS_Segment Description" := SegmentsRec."NS_Segment Description";
        //         TargetSegmentRec."NS_Billing Type" := SegmentsRec."NS_Billing Type";
        //         TargetSegmentRec."NS_Unit of Measure Code" := SegmentsRec."NS_Unit of Measure Code";
        //         TargetSegmentRec.validate("NS_Estimated Quantity", SegmentsRec."NS_Estimated Quantity");
        //         TargetSegmentRec.Validate("NS_Unit Rate", SegmentsRec."NS_Unit Rate");
        //         TargetSegmentRec.Validate("NS_Total Cost", SegmentsRec."NS_Total Cost");
        //         TargetSegmentRec.Insert();
        //     until SegmentsRec.Next() = 0;



        IF CONFIRM('Job Quote No. ' + NewJob."NS_Quote No." + ' has been created. Go to new Job Quote?') THEN BEGIN
            JobPage.SETRECORD(NewJob);
            JobPage.RUN;
        END;
    END;
    //PRJ-914.AS.1.0 20OCT2021 END


    //PRJ-914.AS.1.0 - START
    local procedure NS_CopyMasterJobTasksToJobChangeOrderQuote(Masterjob: Record Job; NewQuote: Record "NS_Job Quote Header");
    var
        QuoteJobTask: Record "Job Task";
        JobTask: Record "Job Task";
    begin
        //*Code to copy Master Job Task lines to Change order Quote tasks*//
        QuoteJobTask.SETRANGE("Job No.", Masterjob."No.");
        if QuoteJobTask.FINDSET(true, true) then
            repeat
                JobTask.INIT;
                //JobTask := QuoteJobTask;
                JobTask."Job No." := NewQuote."NS_Quote No.";
                JobTask."NS_Quote No." := NewQuote."NS_Quote No.";
                if not JobTask.INSERT then
                    JobTask.MODIFY;
            until QuoteJobTask.NEXT = 0;
    end;
    //PRJ-914.AS.1.0 - END


    //PRJ-914.AS.1.0 - START
    local procedure NS_CopyMasterJPLToJobChangeOrderQuote(Masterjob: Record Job; NewQuote: Record "NS_Job Quote Header");
    var
        //*Code to copy Master Job Planning lines to Change order Quote Job planning lines*//
        QuoteJPL: Record "Job Planning Line";
        JPL: Record "Job Planning Line";
    begin
        QuoteJPL.SETRANGE("Job No.", Masterjob."No.");
        if QuoteJPL.FINDSET(true, true) then
            repeat
                JPL.INIT;
                JPL := QuoteJPL;
                JPL."Job No." := NewQuote."NS_Quote No.";
                JPL.INSERT();
            until QuoteJPL.NEXT = 0;
    end;
    //PRJ-914.AS.1.0 - END

    LOCAL PROCEDURE CopyCostPricing(NewJob: Record 167; OldJob: Record 167);
    VAR
        ResPrice: Record 1012;
        ItemPrice: Record 1013;
        GLPrice: Record 1014;
        NewResPrice: Record 1012;
        NewItemPrice: Record 1013;
        NewGLPrice: Record 1014;
        CCPrice: Record "NS_Job Cost Category Price";
        NewCCPrice: Record "NS_Job Cost Category Price";
    BEGIN
        //Copy Job Resource Price
        ResPrice.RESET;
        ResPrice.SETRANGE("Job No.", OldJob."No.");
        IF ResPrice.FINDSET THEN
            REPEAT
                NewResPrice.INIT;
                NewResPrice := ResPrice;
                NewResPrice."Job No." := NewJob."No.";
                NewResPrice.INSERT;
            UNTIL ResPrice.NEXT = 0;

        //Copy Job Resource Item Price
        ItemPrice.RESET;
        ItemPrice.SETRANGE("Job No.", OldJob."No.");
        IF ItemPrice.FINDSET THEN
            REPEAT
                NewItemPrice.INIT;
                NewItemPrice := ItemPrice;
                NewItemPrice."Job No." := NewJob."No.";
                NewItemPrice.INSERT;
            UNTIL ItemPrice.NEXT = 0;

        //Copy Job G/L Account Price
        GLPrice.RESET;
        GLPrice.SETRANGE("Job No.", OldJob."No.");
        IF GLPrice.FINDSET THEN
            REPEAT
                NewGLPrice.INIT;
                NewGLPrice := GLPrice;
                NewGLPrice."Job No." := NewJob."No.";
                NewGLPrice.INSERT;
            UNTIL GLPrice.NEXT = 0;

        //Copy Job G/L Account Price
        CCPrice.RESET;
        CCPrice.SETRANGE("NS_Job No.", OldJob."No.");
        IF CCPrice.FINDSET THEN
            REPEAT
                NewCCPrice.INIT;
                NewCCPrice := CCPrice;
                NewCCPrice."NS_Job No." := NewJob."No.";
                NewCCPrice.INSERT;
            UNTIL CCPrice.NEXT = 0;
    END;

    PROCEDURE SetCopyJob(PassCopyJob: Boolean);
    BEGIN
        CopiedJob := PassCopyJob;
    END;

    PROCEDURE GetCopiedJob(): Boolean
    begin
        exit(CopiedJob);
    end;


    PROCEDURE NS_CopyPlanningToLocked(JobNoToCopy: Code[20]);
    VAR
        NS_LockedJobPlanningLine: Record "NS_Locked Job Planning Line"; //PRJ-181.MS.1.0
        NS_JobPlanningLine: Record 1003;
        LockedExists: Label 'The locked planning for this job already exists and can not be changed here.';
        CopyWarning: Label 'WARNING: Performing this action will copy the current planning lines to a locked area with no further modifications and be shown as originals going forward.\Any further changes to planning will be shown as modifications to the original.\\Should this be done?;ENC=WARNING: Performing this action will copy the current planning lines to a locked area with no further modifications and be shown as originals going forward.\Any further changes to planning will be shown as modifications to the original.\\Should this be done?';
        CopyStopped: Label 'Copy to original planning area was not done.';
        SuccessMessage: Label 'Planning lines have been copied to original and locked.';
        NoSuccessMessage: Label 'No planning lines have been copied.';
        Success: Boolean;
    BEGIN
        //Copies Job Planning lines from Job Planning Line to Locked Job Planning Line table

        Success := FALSE;

        WITH NS_JobPlanningLine DO BEGIN
            NS_LockedJobPlanningLine.SETRANGE("NS_Job No.", JobNoToCopy);
            IF NS_LockedJobPlanningLine.FINDFIRST THEN
                ERROR(LockedExists);
            NS_LockedJobPlanningLine.RESET;

            IF NOT CONFIRM(CopyWarning, FALSE) THEN
                ERROR(CopyStopped);

            //Perform the copy here
            RESET;
            SETRANGE("Job No.", JobNoToCopy);
            IF FINDFIRST THEN BEGIN
                REPEAT
                    //NS_LockedJobPlanningLine.TRANSFERFIELDS(NS_JobPlanningLine);//PRJ-1053.AS.1.0 Commented transferfield code

                    //PRJ-1053.AS.1.0 - started
                    NS_LockedJobPlanningLine.Init();
                    NS_LockedJobPlanningLine."NS_Line No." := NS_JobPlanningLine."Line No.";
                    NS_LockedJobPlanningLine."NS_Job No." := NS_JobPlanningLine."Job No.";
                    NS_LockedJobPlanningLine."NS_Planning Date" := NS_JobPlanningLine."Planning Date";
                    NS_LockedJobPlanningLine."NS_Document No." := NS_JobPlanningLine."Document No.";
                    NS_LockedJobPlanningLine.NS_Type := NS_JobPlanningLine.Type;
                    NS_LockedJobPlanningLine."NS_No." := NS_JobPlanningLine."No.";
                    //NS_LockedJobPlanningLine.NS_Description := NS_JobPlanningLine.Description; //PRJ-1420.NK.1.0 30May2022 Block
                    NS_LockedJobPlanningLine.NS_DescriptionNew := NS_JobPlanningLine.Description; //PRJ-1420.NK.1.0 30May2022
                    NS_LockedJobPlanningLine.NS_Quantity := NS_JobPlanningLine.Quantity;
                    NS_LockedJobPlanningLine."NS_Direct Unit Cost (LCY)" := NS_JobPlanningLine."Direct Unit Cost (LCY)";
                    NS_LockedJobPlanningLine."NS_Unit Cost (LCY)" := NS_JobPlanningLine."Unit Cost (LCY)";
                    NS_LockedJobPlanningLine."NS_Total Cost (LCY)" := NS_JobPlanningLine."Total Cost (LCY)";
                    NS_LockedJobPlanningLine."NS_Unit Price (LCY)" := NS_JobPlanningLine."Unit Price (LCY)";
                    NS_LockedJobPlanningLine."NS_Total Price (LCY)" := NS_JobPlanningLine."Total Price (LCY)";
                    NS_LockedJobPlanningLine."NS_Resource Group No." := NS_JobPlanningLine."Resource Group No.";
                    NS_LockedJobPlanningLine."NS_Unit of Measure Code" := NS_JobPlanningLine."Unit of Measure Code";
                    NS_LockedJobPlanningLine."NS_Location Code" := NS_JobPlanningLine."Location Code";
                    NS_LockedJobPlanningLine."NS_Last Date Modified" := NS_JobPlanningLine."Last Date Modified";
                    NS_LockedJobPlanningLine."NS_User ID" := NS_JobPlanningLine."User ID";
                    NS_LockedJobPlanningLine."NS_Work Type Code" := NS_JobPlanningLine."Work Type Code";
                    NS_LockedJobPlanningLine."NS_Customer Price Group" := NS_JobPlanningLine."Customer Price Group";
                    NS_LockedJobPlanningLine."NS_Country/Region Code" := NS_JobPlanningLine."Country/Region Code";
                    NS_LockedJobPlanningLine."NS_Gen. Bus. Posting Group New" := NS_JobPlanningLine."Gen. Bus. Posting Group";
                    NS_LockedJobPlanningLine."NS_Gen. Prod. Posting Group New" := NS_JobPlanningLine."Gen. Prod. Posting Group";
                    NS_LockedJobPlanningLine."NS_Document Date" := NS_JobPlanningLine."Document Date";
                    NS_LockedJobPlanningLine."NS_Job Task No." := NS_JobPlanningLine."Job Task No.";
                    NS_LockedJobPlanningLine."NS_Line Amount (LCY)" := NS_JobPlanningLine."Line Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_Unit Cost" := NS_JobPlanningLine."Unit Cost";
                    NS_LockedJobPlanningLine."NS_Total Cost" := NS_JobPlanningLine."Total Cost";
                    NS_LockedJobPlanningLine."NS_Unit Price" := NS_JobPlanningLine."Unit Price";
                    NS_LockedJobPlanningLine."NS_Total Price" := NS_JobPlanningLine."Total Price";
                    NS_LockedJobPlanningLine."NS_Line Amount" := NS_JobPlanningLine."Line Amount";
                    NS_LockedJobPlanningLine."NS_Line Discount Amount" := NS_JobPlanningLine."Line Discount Amount";
                    NS_LockedJobPlanningLine."NS_Line Discount Amount (LCY)" := NS_JobPlanningLine."Line Discount Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_Cost Factor" := NS_JobPlanningLine."Cost Factor";
                    NS_LockedJobPlanningLine."NS_Serial No." := NS_JobPlanningLine."Serial No.";
                    NS_LockedJobPlanningLine."NS_Lot No." := NS_JobPlanningLine."Lot No.";
                    NS_LockedJobPlanningLine."NS_Line Discount %" := NS_JobPlanningLine."Line Discount %";
                    NS_LockedJobPlanningLine."NS_Line Type" := NS_JobPlanningLine."Line Type";
                    NS_LockedJobPlanningLine."NS_Currency Code" := NS_JobPlanningLine."Currency Code";
                    NS_LockedJobPlanningLine."NS_Currency Date" := NS_JobPlanningLine."Currency Date";
                    NS_LockedJobPlanningLine."NS_Currency Factor" := NS_JobPlanningLine."Currency Factor";
                    NS_LockedJobPlanningLine."NS_Schedule Line" := NS_JobPlanningLine."Schedule Line";
                    NS_LockedJobPlanningLine."NS_Contract Line" := NS_JobPlanningLine."Contract Line";
                    NS_LockedJobPlanningLine."NS_Job Contract Entry No." := NS_JobPlanningLine."Job Contract Entry No.";
                    NS_LockedJobPlanningLine."NS_Invoiced Amount (LCY)" := NS_JobPlanningLine."Invoiced Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_Invoiced Cost Amount (LCY)" := NS_JobPlanningLine."Invoiced Cost Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_VAT Unit Price" := NS_JobPlanningLine."VAT Unit Price";
                    NS_LockedJobPlanningLine."NS_VAT Line Discount Amount" := NS_JobPlanningLine."VAT Line Discount Amount";
                    NS_LockedJobPlanningLine."NS_VAT Line Amount" := NS_JobPlanningLine."VAT Line Amount";
                    NS_LockedJobPlanningLine."NS_VAT %" := NS_JobPlanningLine."VAT %";
                    NS_LockedJobPlanningLine."NS_Description 2" := NS_JobPlanningLine."Description 2";
                    NS_LockedJobPlanningLine."NS_Job Ledger Entry No." := NS_JobPlanningLine."Job Ledger Entry No.";
                    NS_LockedJobPlanningLine.NS_Status := NS_JobPlanningLine.Status;
                    NS_LockedJobPlanningLine."NS_Ledger Entry Type" := NS_JobPlanningLine."Ledger Entry Type";
                    NS_LockedJobPlanningLine."NS_Ledger Entry No." := NS_JobPlanningLine."Ledger Entry No.";
                    NS_LockedJobPlanningLine."NS_System-Created Entry" := NS_JobPlanningLine."System-Created Entry";
                    NS_LockedJobPlanningLine."NS_Usage Link" := NS_JobPlanningLine."Usage Link";
                    NS_LockedJobPlanningLine."NS_Remaining Qty." := NS_JobPlanningLine."Remaining Qty.";
                    NS_LockedJobPlanningLine."NS_Remaining Qty. (Base)" := NS_JobPlanningLine."Remaining Qty. (Base)";
                    NS_LockedJobPlanningLine."NS_Remaining Total Cost (LCY)" := NS_JobPlanningLine."Remaining Total Cost (LCY)";
                    NS_LockedJobPlanningLine."NS_Remaining Line Amount" := NS_JobPlanningLine."Remaining Line Amount";
                    NS_LockedJobPlanningLine."NS_Remaining Line Amount (LCY)" := NS_JobPlanningLine."Remaining Line Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_Qty. Posted" := NS_JobPlanningLine."Qty. Posted";
                    NS_LockedJobPlanningLine."NS_Qty. to Transfer to Journal" := NS_JobPlanningLine."Qty. to Transfer to Journal";
                    NS_LockedJobPlanningLine."NS_Posted Total Cost" := NS_JobPlanningLine."Posted Total Cost";
                    NS_LockedJobPlanningLine."NS_Posted Total Cost (LCY)" := NS_JobPlanningLine."Posted Total Cost (LCY)";
                    NS_LockedJobPlanningLine."NS_Posted Line Amount" := NS_JobPlanningLine."Posted Line Amount";
                    NS_LockedJobPlanningLine."NS_Posted Line Amount (LCY)" := NS_JobPlanningLine."Posted Line Amount (LCY)";
                    NS_LockedJobPlanningLine."NS_Qty. Transferred to Invoice" := NS_JobPlanningLine."Qty. Transferred to Invoice";
                    NS_LockedJobPlanningLine."NS_Qty. to Transfer to Invoice" := NS_JobPlanningLine."Qty. to Transfer to Invoice";
                    NS_LockedJobPlanningLine."NS_Qty. Invoiced" := NS_JobPlanningLine."Qty. Invoiced";
                    NS_LockedJobPlanningLine."NS_Qty. to Invoice" := NS_JobPlanningLine."Qty. to Invoice";
                    NS_LockedJobPlanningLine."NS_Reserved Quantity" := NS_JobPlanningLine."Reserved Quantity";
                    NS_LockedJobPlanningLine."NS_Reserved Qty. (Base)" := NS_JobPlanningLine."Reserved Qty. (Base)";
                    NS_LockedJobPlanningLine.NS_Reserve := NS_JobPlanningLine.Reserve;
                    NS_LockedJobPlanningLine.NS_Planned := NS_JobPlanningLine.Planned;
                    NS_LockedJobPlanningLine."NS_Variant Code" := NS_JobPlanningLine."Variant Code";
                    NS_LockedJobPlanningLine."NS_Bin Code" := NS_JobPlanningLine."Bin Code";
                    NS_LockedJobPlanningLine."NS_Qty. per Unit of Measure" := NS_JobPlanningLine."Qty. per Unit of Measure";
                    NS_LockedJobPlanningLine."NS_Quantity (Base)" := NS_JobPlanningLine."Quantity (Base)";
                    NS_LockedJobPlanningLine."NS_Requested Delivery Date" := NS_JobPlanningLine."Requested Delivery Date";
                    NS_LockedJobPlanningLine."NS_Promised Delivery Date" := NS_JobPlanningLine."Promised Delivery Date";
                    NS_LockedJobPlanningLine."NS_Planned Delivery Date" := NS_JobPlanningLine."Planned Delivery Date";
                    NS_LockedJobPlanningLine."NS_Service Order No." := NS_JobPlanningLine."Service Order No.";
                    NS_LockedJobPlanningLine."NS_Cost Category" := NS_JobPlanningLine."NS_Cost Category";
                    NS_LockedJobPlanningLine."NS_Revenue Category" := NS_JobPlanningLine."NS_Revenue Category";
                    NS_LockedJobPlanningLine."NS_Cost Factor Set By Category" := NS_JobPlanningLine."NS_Cost Factor Set By Category";
                    NS_LockedJobPlanningLine."NS_Shortcut Dimension 1 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 1 Code";
                    NS_LockedJobPlanningLine."NS_Shortcut Dimension 2 Code" := NS_JobPlanningLine."NS_Shortcut Dimension 2 Code";
                    NS_LockedJobPlanningLine."NS_Activity Code" := NS_JobPlanningLine."NS_Activity Code";
                    NS_LockedJobPlanningLine."NS_Process Code" := NS_JobPlanningLine."NS_Process Code";
                    NS_LockedJobPlanningLine."NS_Operation Code" := NS_JobPlanningLine."NS_Operation Code";
                    NS_LockedJobPlanningLine."NS_Section Code" := NS_JobPlanningLine."NS_Section Code";
                    NS_LockedJobPlanningLine."NS_Work Units" := NS_JobPlanningLine."NS_Work Units";
                    NS_LockedJobPlanningLine."NS_Work Unit of Measure" := NS_JobPlanningLine."NS_Work Unit of Measure";
                    NS_LockedJobPlanningLine."NS_Skill Class" := NS_JobPlanningLine."NS_Skill Class";
                    NS_LockedJobPlanningLine."NS_Entry Type" := NS_JobPlanningLine."NS_Entry Type";
                    NS_LockedJobPlanningLine.NS_Adjustment := NS_JobPlanningLine.NS_Adjustment;
                    NS_LockedJobPlanningLine."NS_Rate Type" := NS_JobPlanningLine."NS_Rate Type";
                    NS_LockedJobPlanningLine."NS_Rate Type Value" := NS_JobPlanningLine."NS_Rate Type Value";
                    NS_LockedJobPlanningLine."NS_Not To Exceed" := NS_JobPlanningLine."NS_Not To Exceed";
                    NS_LockedJobPlanningLine."NS_Subcontract No." := NS_JobPlanningLine."NS_Subcontract No.";
                    NS_LockedJobPlanningLine."NS_Subcontract Line No." := NS_JobPlanningLine."NS_Subcontract Line No.";
                    NS_LockedJobPlanningLine."NS_Progress Billing Method" := NS_JobPlanningLine."NS_Progress Billing Method";
                    NS_LockedJobPlanningLine."NS_Progress Payment Method" := NS_JobPlanningLine."NS_Progress Payment Method";
                    NS_LockedJobPlanningLine.NS_TempNo := NS_JobPlanningLine.NS_TempNo;
                    NS_LockedJobPlanningLine.NS_TempLocation := NS_JobPlanningLine.NS_TempLocation;
                    NS_LockedJobPlanningLine.NS_TempVariant := NS_JobPlanningLine.NS_TempVariant;
                    NS_LockedJobPlanningLine.NS_TempUM := NS_JobPlanningLine.NS_TempUM;
                    NS_LockedJobPlanningLine.NS_TempWorkType := NS_JobPlanningLine.NS_TempWorkType;
                    NS_LockedJobPlanningLine.NS_TempSkillClass := NS_JobPlanningLine.NS_TempSkillClass;
                    NS_LockedJobPlanningLine.NS_Welding := NS_JobPlanningLine.NS_Welding;
                    NS_LockedJobPlanningLine."NS_Size of Weld" := NS_JobPlanningLine."NS_Size of Weld";
                    NS_LockedJobPlanningLine."NS_Weld Time (Hours)" := NS_JobPlanningLine."NS_Weld Time (Hours)";
                    NS_LockedJobPlanningLine."NS_No. 2" := NS_JobPlanningLine."NS_No. 2";
                    NS_LockedJobPlanningLine."NS_Quote No." := NS_JobPlanningLine."NS_Quote No.";
                    NS_LockedJobPlanningLine."NS_Quote Line No." := NS_JobPlanningLine."NS_Quote Line No.";
                    NS_LockedJobPlanningLine."NS_Purchase Order No." := NS_JobPlanningLine."NS_Purchase Order No.";
                    NS_LockedJobPlanningLine."NS_Use Tax SKU" := NS_JobPlanningLine."NS_Use Tax SKU";
                    NS_LockedJobPlanningLine."NS_Use Tax Amount" := NS_JobPlanningLine."NS_Use Tax Amount";
                    NS_LockedJobPlanningLine."NS_Vendor No." := NS_JobPlanningLine."NS_Vendor No.";
                    NS_LockedJobPlanningLine."NS_Vendor Quote No." := NS_JobPlanningLine."NS_Vendor Quote No.";
                    NS_LockedJobPlanningLine."NS_Manufacturer Code" := NS_JobPlanningLine."NS_Manufacturer Code";
                    NS_LockedJobPlanningLine."NS_Defaulted Entry" := NS_JobPlanningLine."NS_Defaulted Entry";
                    NS_LockedJobPlanningLine."NS_Total Number of Welds" := NS_JobPlanningLine."NS_Total Number of Welds";
                    NS_LockedJobPlanningLine."NS_Gross Profit" := NS_JobPlanningLine."NS_Gross Profit";
                    NS_LockedJobPlanningLine."NS_Gross Profit Percentage" := NS_JobPlanningLine."NS_Gross Profit Percentage";
                    NS_LockedJobPlanningLine."NS_Original Total Price" := NS_JobPlanningLine."NS_Original Total Price";
                    NS_LockedJobPlanningLine."NS_Original Total Price (LCY)" := NS_JobPlanningLine."NS_Original Total Price (LCY)";
                    NS_LockedJobPlanningLine."NS_Original Quantity" := NS_JobPlanningLine."NS_Original Quantity";
                    NS_LockedJobPlanningLine."NS_Item Not Found" := NS_JobPlanningLine."NS_Item Not Found";
                    NS_LockedJobPlanningLine."NS_Segment Type" := NS_JobPlanningLine."NS_Segment Type";
                    NS_LockedJobPlanningLine."NS_Segment Code" := NS_JobPlanningLine."NS_Segment Code";
                    NS_LockedJobPlanningLine."NS_Segment Name" := NS_JobPlanningLine."NS_Segment Name";
                    NS_LockedJobPlanningLine."NS_Matrix Updated" := NS_JobPlanningLine."NS_Matrix Updated";
                    NS_LockedJobPlanningLine."NS_Progress Billing Line" := NS_JobPlanningLine."NS_Progress Billing Line";
                    NS_LockedJobPlanningLine."NS_Dimension Set ID" := NS_JobPlanningLine."NS_Dimension Set ID";
                    NS_LockedJobPlanningLine."NS_Retention Ledger Code" := NS_JobPlanningLine."NS_Retention Ledger Code";
                    NS_LockedJobPlanningLine."NS_Line Amount Incl. Tax" := NS_JobPlanningLine."NS_Line Amount Incl. Tax";
                    NS_LockedJobPlanningLine."NS_Template No." := NS_JobPlanningLine."NS_Template No.";
                    NS_LockedJobPlanningLine.INSERT();
                //PRJ-1053.AS.1.0 - ended
                UNTIL NEXT = 0;
                Success := TRUE;
            END;

            IF Success THEN
                MESSAGE(SuccessMessage)
            ELSE
                MESSAGE(NoSuccessMessage);
        END;
    END;

    PROCEDURE SetDisableLoadTasks(PassDisableLoadTasks: Boolean);
    BEGIN
        DisableLoadTasks := PassDisableLoadTasks;
    END;

    PROCEDURE SetSupressDimConfirmDialogs(PassSupressDimConfirmDialogs: Boolean);
    BEGIN
        SupressDimConfirmDialogs := PassSupressDimConfirmDialogs;
    END;

    PROCEDURE GetSupressDimConfirmDialogs(): Boolean;
    begin
        exit(SupressDimConfirmDialogs);
    end;

    LOCAL procedure JobLedgEntryExist(): Boolean
    var
        JobLedgEntry: Record "Job Ledger Entry";
    begin
        CLEAR(JobLedgEntry);
        JobLedgEntry.SETCURRENTKEY("Job No.");
        JobLedgEntry.SETRANGE("Job No.", "No.");
        EXIT(JobLedgEntry.FINDFIRST);
    end;

    LOCAL procedure JobPlanningLineExist(): Boolean
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.INIT;
        JobPlanningLine.SETRANGE("Job No.", "No.");
        EXIT(JobPlanningLine.FINDFIRST);
    end;


    ////////////////////////////////////////////////////PPPPPPPPPPP///////////////////
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertJobTask(var JobTask: Record "Job Task"; var SeqNo: Integer)
    begin
    end;
    // << Upgrade
    PROCEDURE CreateSubJob(PassJob: Record 167);
    VAR
        JobsSetup: Record 315;
        NewJob: Record 167;
        JobPage: Page 88;
        SegmentsRec: Record "NS_Job Takeoff Segments";
        TargetSegmentRec: Record "NS_Job Takeoff Segments";
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Default Dimension";
        PassJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobTask: Record "Job Task";   //PRJ-1015.JS.1.0   12Oct2021
        NewJobs2: Record Job; //PRJ-1015.JS.1.0   12Oct2021         

    BEGIN
        JobsSetup.GET;
        //WITH NewJob DO BEGIN
        NewJob.INIT;
        NewJob.SetCopyJob(TRUE);
        NewJob."No." := GetNextChangeOrderNo(PassJob."No.", JobsSetup."NS_Change Order No. Separator");

        NewJob."No. Series" := '';
        NewJob."NS_Sub-Level to Job No." := PassJob."No.";//PE-120.NC.1.0 26Jun2023
        NewJob.INSERT(TRUE);
        NewJob."Search Description" := PassJob."Search Description";
        NewJob.Description := PassJob.Description;
        NewJob."Description 2" := PassJob."Description 2";
        NewJob."Bill-to Customer No." := PassJob."Bill-to Customer No.";
        NewJob."Creation Date" := TODAY;
        NewJob."Starting Date" := 0D;
        NewJob."Ending Date" := 0D;
        NewJob.Status := Status::Planning;
        NewJob."Person Responsible" := PassJob."Person Responsible";
        NewJob."Global Dimension 1 Code" := PassJob."Global Dimension 1 Code";
        NewJob."Global Dimension 2 Code" := PassJob."Global Dimension 2 Code";
        NewJob."Job Posting Group" := PassJob."Job Posting Group";
        NewJob.Blocked := Blocked::" ";
        NewJob."Customer Disc. Group" := PassJob."Customer Disc. Group";
        NewJob."Customer Price Group" := PassJob."Customer Price Group";
        NewJob."Language Code" := PassJob."Language Code";
        NewJob."Bill-to Name" := PassJob."Bill-to Name";
        NewJob."Bill-to Address" := PassJob."Bill-to Address";
        NewJob."Bill-to Address 2" := PassJob."Bill-to Address 2";
        NewJob."Bill-to City" := PassJob."Bill-to City";
        NewJob."Bill-to County" := PassJob."Bill-to County";
        NewJob."Bill-to Post Code" := PassJob."Bill-to Post Code";
        NewJob."No. Series" := PassJob."No. Series";
        NewJob."Bill-to Country/Region Code" := PassJob."Bill-to Country/Region Code";
        NewJob."WIP Method" := PassJob."WIP Method";
        NewJob."Currency Code" := PassJob."Currency Code";
        NewJob."Bill-to Contact No." := PassJob."Bill-to Contact No.";
        NewJob."Bill-to Contact" := PassJob."Bill-to Contact";
        NewJob."NS_Sell-to Customer No." := PassJob."NS_Sell-to Customer No.";
        NewJob."NS_Sell-to Customer Name" := PassJob."NS_Sell-to Customer Name";
        //PRJCTPR-200.NC.1.0 29SEP2023 Start
        NewJob."Sell-to Customer No." := PassJob."Sell-to Customer No.";
        NewJob."Sell-to Customer Name" := PassJob."Sell-to Customer Name";
        //PRJCTPR-200.NC.1.0 29SEP2023 End
        NewJob."NS_Salesperson Code" := PassJob."NS_Salesperson Code";
        //PRJ-1489.GK.1.0 start 
        NewJob."NS_Gen. Bus. Posting Group New" := PassJob."NS_Gen. Bus. Posting Group New";
        NewJob."NS_Gen. Prod. Posting Group New" := PassJob."NS_Gen. Prod. Posting Group New";
        // NewJob."NS_Gen. Bus. Posting Group" := PassJob."NS_Gen. Bus. Posting Group";
        // NewJob."NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";
        //PRJ-1489.GK.1.0 end
        NewJob."WIP Posting Date" := PassJob."WIP Posting Date";
        NewJob."WIP Posting Method" := PassJob."WIP Posting Method";
        NewJob."Invoice Currency Code" := PassJob."Invoice Currency Code";
        NewJob."Exch. Calculation (Cost)" := PassJob."Exch. Calculation (Cost)";
        NewJob."Exch. Calculation (Price)" := PassJob."Exch. Calculation (Price)";
        NewJob."Allow Schedule/Contract Lines" := PassJob."Allow Schedule/Contract Lines";
        NewJob."NS_Job Address 1" := PassJob."NS_Job Address 1";
        NewJob."NS_Job Address 2" := PassJob."NS_Job Address 2";
        NewJob."NS_Job City" := PassJob."NS_Job City";
        NewJob."NS_Job County" := PassJob."NS_Job County";
        NewJob."NS_Job Post Code" := PassJob."NS_Job Post Code";
        NewJob."NS_Job Country/Region Code" := PassJob."NS_Job Country/Region Code";
        NewJob."NS_Job Contact" := PassJob."NS_Job Contact";
        NewJob."NS_Job Phone" := PassJob."NS_Job Phone";
        NewJob."NS_Job Ship-to Code" := PassJob."NS_Job Ship-to Code";
        NewJob."NS_Temp Linked Parent Job No." := PassJob."NS_Temp Linked Parent Job No.";
        NewJob."NS_Last Job For Job List" := PassJob."NS_Last Job For Job List";
        //PRJCTPR-197 Dk.1.0 Start
        // NewJob."NS_Job Type" := PassJob."NS_Job Type";
        NewJob."NS_Job Type New" := PassJob."NS_Job Type New";
        //PRJCTPR-197 Dk.1.0 ENd
        NewJob.NS_Estimator := PassJob.NS_Estimator;
        NewJob.NS_Manager := PassJob.NS_Manager;
        NewJob."NS_Manager Job Status" := PassJob."NS_Manager Job Status";
        NewJob."NS_Job Status Date" := 0D;
        NewJob."NS_Estimated Start Date" := 0D;
        NewJob."NS_Estimated Completion Date" := 0D;
        NewJob."NS_Completion Date" := 0D;
        NewJob."NS_Job Posting Date" := PassJob."NS_Job Posting Date";
        NewJob."NS_Recognition Date" := PassJob."NS_Recognition Date";
        NewJob."NS_Unit of Measure" := '';
        NewJob."NS_Total Units" := 0;
        NewJob."NS_Billing method" := PassJob."NS_Billing method";
        NewJob."NS_Recognition Method" := PassJob."NS_Recognition Method";
        NewJob."NS_Default Job Retention" := PassJob."NS_Default Job Retention";
        NewJob."NS_Tax Area Code" := PassJob."NS_Tax Area Code";
        NewJob."NS_Tax Liable" := PassJob."NS_Tax Liable";
        NewJob."NS_Tax Group Code New" := PassJob."NS_Tax Group Code New";
        NewJob."NS_VAT Bus. Posting Group" := PassJob."NS_VAT Bus. Posting Group";
        NewJob."NS_VAT Prod. Posting Group" := PassJob."NS_VAT Prod. Posting Group";
        NewJob."NS_Actual Percent Complete" := 0;
        NewJob."NS_Actual PercentCompleteDate" := 0D;
        NewJob."NS_Actual Units Complete" := 0;
        NewJob."NS_Actual Units Complete Date" := 0D;
        NewJob."NS_Job Revenue Posting" := PassJob."NS_Job Revenue Posting";
        NewJob."NS_Progress Billing No." := PassJob."NS_Progress Billing No.";
        NewJob."NS_Progress Billing Sub-Level" := PassJob."NS_Progress Billing Sub-Level";
        NewJob."NS_Customer Job No." := PassJob."NS_Customer Job No.";
        NewJob."NS_Customer PO Number" := '';
        NewJob."NS_Contract No." := PassJob."NS_Contract No.";
        NewJob."NS_Contract Date" := PassJob."NS_Contract Date";
        NewJob."NS_Contract For" := PassJob."NS_Contract For";
        //NewJob."NS_Sub-Level to Job No." := PassJob."No.";//PE-120.NC.1.0 26Jun2023 Block
        NewJob."NS_Job Class" := "NS_Job Class"::SubJob;

        //PRJ-1015.JS.1.0  12Oct2021 - Start
        if PassJob."NS_Job Class" = PassJob."NS_Job Class"::"Master Job" then
            NewJob."NS_Root Job No." := PassJob."No."
        else
            NewJob."NS_Root Job No." := PassJob."NS_Root Job No.";
        //PRJ-1015.JS.1.0  12Oct2021 - Start

        DefaultDimRec.Reset;
        DefaultDimRec.SetRange("Table ID", 167);
        DefaultDimRec.SetRange("No.", PassJob."No.");
        if DefaultDimRec.FindSet then
            repeat
                DefaultDimRec2.Init;
                DefaultDimRec2."Table ID" := 167;
                DefaultDimRec2."No." := NewJob."No.";
                DefaultDimRec2."Dimension Code" := DefaultDimRec."Dimension Code";
                DefaultDimRec2."Dimension Value Code" := DefaultDimRec."Dimension Value Code";
                DefaultDimRec2.Insert;
            until DefaultDimRec.Next = 0;

        NewJob.MODIFY;
        //end;

        //Segment List flow start
        SegmentsRec.Reset();
        SegmentsRec.SetRange("NS_Job No.", PassJob."No.");
        if SegmentsRec.FindSet() then
            repeat
                TargetSegmentRec.Init();
                TargetSegmentRec.validate("NS_Job No.", NewJob."No.");
                TargetSegmentRec."NS_Segment Code" := SegmentsRec."NS_Segment Code";
                TargetSegmentRec.NS_Type := SegmentsRec.NS_Type;
                TargetSegmentRec."NS_Size of Weld" := SegmentsRec."NS_Size of Weld";
                TargetSegmentRec."NS_Segment Name" := SegmentsRec."NS_Segment Name";
                TargetSegmentRec."NS_Segment Description" := SegmentsRec."NS_Segment Description";
                TargetSegmentRec."NS_Billing Type" := SegmentsRec."NS_Billing Type";
                TargetSegmentRec."NS_Unit of Measure Code" := SegmentsRec."NS_Unit of Measure Code";
                TargetSegmentRec.validate("NS_Estimated Quantity", SegmentsRec."NS_Estimated Quantity");
                TargetSegmentRec.Validate("NS_Unit Rate", SegmentsRec."NS_Unit Rate");
                TargetSegmentRec.Validate("NS_Total Cost", SegmentsRec."NS_Total Cost");
                TargetSegmentRec.Insert();
            until SegmentsRec.Next() = 0;

        //Segment List Flow End

        //PRJ-1015.JS.1.0  12Oct2021 - Start
        if NewJobs2.get(NewJob."NS_Root Job No.") then begin
            if NewJobs2."NS_Include Sub Levels" = true then begin
                PassJobTask.Reset();
                PassJobTask.SetRange("Job No.", NewJobs2."No.");
                if PassJobTask.FindFirst() then
                    repeat
                        //PRJCTPR-289.HS.1.0 16Jan2024 Start
                        NewJobTask.Reset();
                        NewJobTask.SetRange("Job No.", NewJob."No.");
                        NewJobTask.SetRange("Job Task No.", PassJobTask."Job Task No.");
                        if not NewJobTask.FindFirst() then begin
                            //PRJCTPR-289.HS.1.0 16Jan2024 End
                            NewJobTask.Init();
                            //NewJobTask.TransferFields(PassJobTask);
                            NewJobTask."Job No." := NewJob."No.";
                            NewJobTask.Validate("Job Task No.", PassJobTask."Job Task No.");
                            NewJobTask."Job Task Type" := PassJobTask."Job Task Type"; //PRJCTPR-289.HS.1.0 14FEB2024
                            NewJobTask.Insert()
                        end;
                    until PassJobTask.Next() = 0;
            end;
        end;
        //PRJ-1015.JS.1.0  12Oct2021 - end   


        IF CONFIRM('Sub Job No. ' + NewJob."No." + ' has been created. Go to Sub Job?') THEN BEGIN
            JobPage.SETRECORD(NewJob);
            JobPage.RUN;
        END;
    END;
    //PRJ-1406.GK.1.0 18May2022 start
    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskActivityOnBeforeInsertJobTaskLine(var Rec: Record "Job Task")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskProcessOnBeforeInsertJobTaskLine(var Rec: Record "Job Task")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskOperationOnBeforeInsertJobTaskLine(var Rec: Record "Job Task")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskActivityOnBeforeInsertJobTaskLines(var Rec: Record "Job Task"; NSJobActivity: Record "NS_Job Activity")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskProcessOnBeforeInsertJobTaskLines(var Rec: Record "Job Task"; NSJobProcess: Record "NS_Job Process")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadTaskOperationOnBeforeInsertJobTaskLines(var Rec: Record "Job Task"; NSJobOperation: Record "NS_Job Operation")
    begin

    end;
    //PRJ-1406.GK.1.0 18May2022 end

    //PRJ-1526.AS.1.0 20JULY2022 START
    [IntegrationEvent(false, false)]
    local procedure NS_OnBeforeBillToCustomerNoValidate(var IsHandlePP: Boolean; var Rec: Record Job)
    begin
    end;
    //PRJ-1526.AS.1.0 20JULY2022 END 
    //PRJCTPR-147.NK.1.0 start1 7Aug2023

    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 START
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateJobFinancials(var IsHandled: Boolean; PassedJob: Record 167; VAR ActualCostToDate: ARRAY[3] OF Decimal; VAR InvoiceBilled: ARRAY[3] OF Decimal; VAR PaymentReceived: ARRAY[3] OF Decimal; VAR CommittedCost: Decimal; PassedSubLevels: Boolean)
    begin
    end;
    //FGH-163.SM.29022024 PE-269.JS.1.0 05MAR2024 END
    PROCEDURE NS_CreateChangeRequest(NS_PassJob: Record 167);
    VAR
        NS_JobsSetup: Record 315;
        NS_NewJob: Record 167;
        NS_JobPage: Page 88;
        NS_SegmentsRec: Record "NS_Job Takeoff Segments";
        NS_TargetSegmentRec: Record "NS_Job Takeoff Segments";
        NS_DefaultDimRec: Record "Default Dimension";
        NS_DefaultDimRec2: Record "Default Dimension";
        NS_PassJobTask: Record "Job Task";
        NS_NewJobTask: Record "Job Task";
        NS_NewJobs2: Record Job;
    BEGIN
        NS_JobsSetup.GET;
        //WITH NewJob DO BEGIN
        NS_NewJob.INIT();
        NS_NewJob.SetCopyJob(TRUE);
        NS_NewJob."No." := NS_GetNextRequestOrderNo();
        NS_NewJob."No. Series" := '';
        NS_NewJob."NS_Change Request to Job No." := NS_PassJob."No.";//PRJCTPR-362.PS.2.0 10May2024
        NS_NewJob.INSERT(TRUE);
        NS_CreateMainJobTask(NS_PassJob."No.", NS_NewJob."No.");
        NS_NewJob."Search Description" := NS_PassJob."Search Description";
        NS_NewJob.Description := NS_PassJob.Description;
        NS_NewJob."Description 2" := NS_PassJob."Description 2";
        NS_NewJob."Bill-to Customer No." := NS_PassJob."Bill-to Customer No.";
        NS_NewJob."Creation Date" := TODAY();
        NS_NewJob."Starting Date" := 0D;
        NS_NewJob."Ending Date" := 0D;
        NS_NewJob.Status := NS_NewJob.Status::Planning;
        NS_NewJob."Person Responsible" := NS_PassJob."Person Responsible";
        NS_NewJob."Global Dimension 1 Code" := NS_PassJob."Global Dimension 1 Code";
        NS_NewJob."Global Dimension 2 Code" := NS_PassJob."Global Dimension 2 Code";
        NS_NewJob."Job Posting Group" := NS_PassJob."Job Posting Group";
        NS_NewJob.Blocked := NS_NewJob.Blocked::" ";
        NS_NewJob."Customer Disc. Group" := NS_PassJob."Customer Disc. Group";
        NS_NewJob."Customer Price Group" := NS_PassJob."Customer Price Group";
        NS_NewJob."Language Code" := NS_PassJob."Language Code";
        NS_NewJob."Bill-to Name" := NS_PassJob."Bill-to Name";
        NS_NewJob."Bill-to Address" := NS_PassJob."Bill-to Address";
        NS_NewJob."Bill-to Address 2" := NS_PassJob."Bill-to Address 2";
        NS_NewJob."Bill-to City" := NS_PassJob."Bill-to City";
        NS_NewJob."Bill-to County" := NS_PassJob."Bill-to County";
        NS_NewJob."Bill-to Post Code" := NS_PassJob."Bill-to Post Code";
        NS_NewJob."No. Series" := NS_PassJob."No. Series";
        NS_NewJob."Bill-to Country/Region Code" := NS_PassJob."Bill-to Country/Region Code";
        NS_NewJob."WIP Method" := NS_PassJob."WIP Method";
        NS_NewJob."Currency Code" := NS_PassJob."Currency Code";
        NS_NewJob."Bill-to Contact No." := NS_PassJob."Bill-to Contact No.";
        NS_NewJob."Bill-to Contact" := NS_PassJob."Bill-to Contact";
        //PE-193.PS.3.0  10April2024 Start
        NS_NewJob."NS_Sell-to Customer No." := NS_PassJob."NS_Sell-to Customer No.";
        NS_NewJob."NS_Sell-to Customer Name" := NS_PassJob."NS_Sell-to Customer Name";
        NS_NewJob."Sell-to Customer No." := NS_PassJob."NS_Sell-to Customer No.";
        NS_NewJob."Sell-to Customer Name" := NS_PassJob."NS_Sell-to Customer Name";
        //PE-193.PS.3.0  10April2024
        NS_NewJob."NS_Salesperson Code" := NS_PassJob."NS_Salesperson Code";
        //"NS_Gen. Bus. Posting Group" := PassJob."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        NS_NewJob."NS_Gen. Bus. Posting Group New" := NS_PassJob."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                  //"NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        NS_NewJob."NS_Gen. Prod. Posting Group New" := NS_PassJob."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                    //PRJ-464.AM.1.0 end
        NS_NewJob."WIP Posting Date" := NS_PassJob."WIP Posting Date";
        NS_NewJob."WIP Posting Method" := NS_PassJob."WIP Posting Method";
        NS_NewJob."Invoice Currency Code" := NS_PassJob."Invoice Currency Code";
        NS_NewJob."Exch. Calculation (Cost)" := NS_PassJob."Exch. Calculation (Cost)";
        NS_NewJob."Exch. Calculation (Price)" := NS_PassJob."Exch. Calculation (Price)";
        NS_NewJob."Allow Schedule/Contract Lines" := NS_PassJob."Allow Schedule/Contract Lines";
        NS_NewJob."NS_Job Address 1" := NS_PassJob."NS_Job Address 1";
        NS_NewJob."NS_Job Address 2" := NS_PassJob."NS_Job Address 2";
        NS_NewJob."NS_Job City" := NS_PassJob."NS_Job City";
        NS_NewJob."NS_Job County" := NS_PassJob."NS_Job County";
        NS_NewJob."NS_Job Post Code" := NS_PassJob."NS_Job Post Code";
        NS_NewJob."NS_Job Country/Region Code" := NS_PassJob."NS_Job Country/Region Code";
        NS_NewJob."NS_Job Contact" := NS_PassJob."NS_Job Contact";
        NS_NewJob."NS_Job Phone" := NS_PassJob."NS_Job Phone";
        NS_NewJob."NS_Job Ship-to Code" := NS_PassJob."NS_Job Ship-to Code";
        NS_NewJob."NS_Temp Linked Parent Job No." := NS_PassJob."NS_Temp Linked Parent Job No.";
        NS_NewJob."NS_Last Job For Job List" := NS_PassJob."NS_Last Job For Job List";
        //NS_NewJob."NS_Job Type" := NS_PassJob."NS_Job Type";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_Job Type New" := NS_PassJob."NS_Job Type New";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob.NS_Estimator := NS_PassJob.NS_Estimator;
        NS_NewJob.NS_Manager := NS_PassJob.NS_Manager;
        NS_NewJob."NS_Manager Job Status" := NS_PassJob."NS_Manager Job Status";
        NS_NewJob."NS_Job Status Date" := 0D;
        NS_NewJob."NS_Estimated Start Date" := 0D;
        NS_NewJob."NS_Estimated Completion Date" := 0D;
        NS_NewJob."NS_Completion Date" := 0D;
        NS_NewJob."NS_Job Posting Date" := NS_PassJob."NS_Job Posting Date";
        NS_NewJob."NS_Recognition Date" := NS_PassJob."NS_Recognition Date";
        NS_NewJob."NS_Unit of Measure" := '';
        NS_NewJob."NS_Total Units" := 0;
        NS_NewJob."NS_Billing method" := NS_PassJob."NS_Billing method";
        NS_NewJob."NS_Recognition Method" := NS_PassJob."NS_Recognition Method";
        NS_NewJob."NS_Default Job Retention" := NS_PassJob."NS_Default Job Retention";
        NS_NewJob."NS_Tax Area Code" := NS_PassJob."NS_Tax Area Code";
        NS_NewJob."NS_Tax Liable" := NS_PassJob."NS_Tax Liable";
        //NS_NewJob."NS_Tax Group Code" := NS_PassJob."NS_Tax Group Code";   //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_Tax Group Code New" := NS_PassJob."NS_Tax Group Code New";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_VAT Bus. Posting Group" := NS_PassJob."NS_VAT Bus. Posting Group";
        NS_NewJob."NS_VAT Prod. Posting Group" := NS_PassJob."NS_VAT Prod. Posting Group";
        NS_NewJob."NS_Actual Percent Complete" := 0;
        NS_NewJob."NS_Actual PercentCompleteDate" := 0D;
        NS_NewJob."NS_Actual Units Complete" := 0;
        NS_NewJob."NS_Actual Units Complete Date" := 0D;
        NS_NewJob."NS_Job Revenue Posting" := NS_PassJob."NS_Job Revenue Posting";
        NS_NewJob."NS_Progress Billing Sub-Level" := NS_PassJob."NS_Progress Billing Sub-Level";
        NS_NewJob."NS_Customer Job No." := NS_PassJob."NS_Customer Job No.";
        NS_NewJob."NS_Customer PO Number" := '';
        NS_NewJob."NS_Contract No." := NS_PassJob."NS_Contract No.";
        NS_NewJob."NS_Contract Date" := NS_PassJob."NS_Contract Date";
        NS_NewJob."NS_Contract For" := NS_PassJob."NS_Contract For";
        //NS_NewJob."NS_Sub-Level to Job No." := NS_PassJob."No.";//PE-193.PS.1.0 03Nov2023
        NS_NewJob."NS_Change Request to Job No." := NS_PassJob."No.";
        NS_NewJob."NS_Job Class" := "NS_Job Class"::"Change Request";
        NS_NewJob."NS_Job Purchaser" := NS_PassJob."NS_Job Purchaser";

        if NS_PassJob."NS_Job Class" = NS_PassJob."NS_Job Class"::"Master Job" then
            NS_NewJob."NS_Root Job No." := NS_PassJob."No."
        else
            NS_NewJob."NS_Root Job No." := NS_PassJob."NS_Root Job No.";

        NS_DefaultDimRec.Reset();
        NS_DefaultDimRec.SetRange("Table ID", 167);
        NS_DefaultDimRec.SetRange("No.", NS_PassJob."No.");
        if NS_DefaultDimRec.FindSet() then
            repeat
                NS_DefaultDimRec2.Init();
                NS_DefaultDimRec2."Table ID" := 167;
                NS_DefaultDimRec2."No." := NS_NewJob."No.";
                NS_DefaultDimRec2."Dimension Code" := NS_DefaultDimRec."Dimension Code";
                NS_DefaultDimRec2."Dimension Value Code" := NS_DefaultDimRec."Dimension Value Code";
                NS_DefaultDimRec2.Insert();
            until NS_DefaultDimRec.Next() = 0;
        NS_NewJob.MODIFY;
        //end;

        //Segment List flow start
        NS_SegmentsRec.Reset();
        NS_SegmentsRec.SetRange("NS_Job No.", NS_PassJob."No.");
        if NS_SegmentsRec.FindSet() then
            repeat
                NS_TargetSegmentRec.Init();
                NS_TargetSegmentRec.validate("NS_Job No.", NS_NewJob."No.");
                NS_TargetSegmentRec."NS_Segment Code" := NS_SegmentsRec."NS_Segment Code";
                NS_TargetSegmentRec.NS_Type := NS_SegmentsRec.NS_Type;
                NS_TargetSegmentRec."NS_Size of Weld" := NS_SegmentsRec."NS_Size of Weld";
                NS_TargetSegmentRec."NS_Segment Name" := NS_SegmentsRec."NS_Segment Name";
                NS_TargetSegmentRec."NS_Segment Description" := NS_SegmentsRec."NS_Segment Description";
                NS_TargetSegmentRec."NS_Billing Type" := NS_SegmentsRec."NS_Billing Type";
                NS_TargetSegmentRec."NS_Unit of Measure Code" := NS_SegmentsRec."NS_Unit of Measure Code";
                NS_TargetSegmentRec.validate("NS_Estimated Quantity", NS_SegmentsRec."NS_Estimated Quantity");
                NS_TargetSegmentRec.Validate("NS_Unit Rate", NS_SegmentsRec."NS_Unit Rate");
                NS_TargetSegmentRec.Validate("NS_Total Cost", NS_SegmentsRec."NS_Total Cost");
                NS_TargetSegmentRec.Insert();
            until NS_SegmentsRec.Next() = 0;

        //Segment List Flow End
        //PRJCTPR-326.PS.1.0 28Feb2024 Start
        // if NS_NewJobs2.get(NS_NewJob."NS_Root Job No.") then begin
        //     if NS_NewJobs2."NS_Include Sub Levels" = true then begin
        //         NS_PassJobTask.Reset();
        //         NS_PassJobTask.SetRange("Job No.", NS_NewJobs2."No.");
        //         if NS_PassJobTask.FindFirst() then
        //             repeat
        //                 NS_NewJobTask.Init();

        //                 NS_NewJobTask."Job No." := NS_NewJob."No.";
        //                 NS_NewJobTask.Validate("Job Task No.", NS_PassJobTask."Job Task No.");
        //                 NS_NewJobTask.Insert()
        //             until NS_PassJobTask.Next() = 0;
        //     end;
        // end;
        //PRJCTPR-326.PS.1.0 28Feb2024 End
        //PE-193.PS.1.0 07Nov2023 Start

        IF CONFIRM('Change Request No. ' + NS_NewJob."No." + ' has been created. Go to Change Request?') THEN BEGIN
            NS_JobPage.SETRECORD(NS_NewJob);
            NS_JobPage.RUN;
        END;
    END;
    //PE-193.PS.1.0 07Nov2023 End
    LOCAL PROCEDURE NS_GetNextRequestOrderNo(): Code[20];
    VAR
        NS_JobRec: Record 167;
        NS_lcuNoSeries: Codeunit NoSeriesManagement;
        NS_lcNoSeries: Code[20];
        NS_lrJobSetup: Record "Jobs Setup";
    BEGIN
        NS_lrJobSetup.Get();
        NS_lcNoSeries := NS_lcuNoSeries.GetNextNo(NS_lrJobSetup."NS_Change Req No. Series", Today, true);
        exit(NS_lcNoSeries);
    END;

    procedure NS_CreateCOHeader(prMasterJob: Record Job): Code[20]
    var
        NS_lbChangeOrderHeaderCreated: Boolean;
        NS_jobcr: Record Job;
        NS_JobSetup: Record "Jobs Setup";
        NS_NewJob: Record Job;
        NS_JobNoNewRecord: Code[20];
    begin
        NS_jobcr := prMasterJob;
        //Message(jobcr."No.");
        NS_JobSetup.GET;
        NS_JobNoNewRecord := NS_GetNextChangeOrderNoNew(prMasterJob, NS_JobSetup."NS_Change Order No. Separator");
        NS_NewJob.INIT();
        NS_NewJob."No." := NS_JobNoNewRecord;
        NS_NewJob."No. Series" := '';
        NS_NewJob."Search Description" := NS_jobcr."Search Description";
        NS_NewJob.Description := NS_jobcr.Description;
        NS_NewJob."Description 2" := NS_jobcr."Description 2";
        NS_NewJob."Bill-to Customer No." := NS_jobcr."Bill-to Customer No.";
        NS_NewJob."Creation Date" := TODAY();
        NS_NewJob."Starting Date" := 0D;
        NS_NewJob."Ending Date" := 0D;
        NS_NewJob.Status := NS_NewJob.Status::Planning;
        NS_NewJob."Person Responsible" := NS_jobcr."Person Responsible";
        // VALIDATE("Global Dimension 1 Code");//ppal-174.AS.1.0 28DEC2020 Commented
        // VALIDATE("Global Dimension 2 Code");//ppal-174.AS.1.0 28DEC2020 Commented
        NS_NewJob."Global Dimension 1 Code" := NS_jobcr."Global Dimension 1 Code";//ppal-174.AS.1.0 28DEC2020 Added
        NS_NewJob."Global Dimension 2 Code" := NS_jobcr."Global Dimension 2 Code";//ppal-174.AS.1.0 28DEC2020 Added
        NS_NewJob."Job Posting Group" := NS_jobcr."Job Posting Group";
        NS_NewJob.Blocked := NS_NewJob.Blocked::" ";
        NS_NewJob."Customer Disc. Group" := NS_jobcr."Customer Disc. Group";
        NS_NewJob."Customer Price Group" := NS_jobcr."Customer Price Group";
        NS_NewJob."Language Code" := NS_jobcr."Language Code";
        NS_NewJob."Bill-to Name" := NS_jobcr."Bill-to Name";
        NS_NewJob."Bill-to Address" := NS_jobcr."Bill-to Address";
        NS_NewJob."Bill-to Address 2" := NS_jobcr."Bill-to Address 2";
        NS_NewJob."Bill-to City" := NS_jobcr."Bill-to City";
        NS_NewJob."Bill-to County" := NS_jobcr."Bill-to County";
        NS_NewJob."Bill-to Post Code" := NS_jobcr."Bill-to Post Code";
        NS_NewJob."No. Series" := NS_jobcr."No. Series";
        NS_NewJob."Bill-to Country/Region Code" := NS_jobcr."Bill-to Country/Region Code";
        NS_NewJob."WIP Method" := NS_jobcr."WIP Method";
        NS_NewJob."Currency Code" := NS_jobcr."Currency Code";
        NS_NewJob."Bill-to Contact No." := NS_jobcr."Bill-to Contact No.";
        NS_NewJob."Bill-to Contact" := NS_jobcr."Bill-to Contact";

        // NS_NewJob."NS_Sell-to Customer No." := NS_jobcr."NS_Sell-to Customer No."; //PE-193.PS.2.0 04Dec2023 Commented
        // NS_NewJob."NS_Sell-to Customer Name" := NS_jobcr."NS_Sell-to Customer Name"; //PE-193.PS.2.0 04Dec2023 Commented

        NS_NewJob."NS_Sell-to Customer No." := NS_jobcr."Sell-to Customer No."; //PE-193.PS.2.0 04Dec2023 
        NS_NewJob."NS_Sell-to Customer Name" := NS_jobcr."Sell-to Customer Name"; //PE-193.PS.2.0 04Dec2023
        NS_NewJob."Sell-to Customer No." := NS_jobcr."Sell-to Customer No.";//PE-193.PS.2.0 04Dec2023
        NS_NewJob."Sell-to Customer Name" := NS_jobcr."Sell-to Customer Name";//PE-193.PS.2.0 04Dec2023

        NS_NewJob."NS_Salesperson Code" := NS_jobcr."NS_Salesperson Code";

        NS_NewJob."NS_Gen. Bus. Posting Group New" := NS_jobcr."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                //"NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
        NS_NewJob."NS_Gen. Prod. Posting Group New" := NS_jobcr."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                  //PRJ-464.AM.1.0 end
        NS_NewJob."WIP Posting Date" := NS_jobcr."WIP Posting Date";
        NS_NewJob."WIP Posting Method" := NS_jobcr."WIP Posting Method";
        NS_NewJob."Invoice Currency Code" := NS_jobcr."Invoice Currency Code";
        NS_NewJob."Exch. Calculation (Cost)" := NS_jobcr."Exch. Calculation (Cost)";
        NS_NewJob."Exch. Calculation (Price)" := NS_jobcr."Exch. Calculation (Price)";
        NS_NewJob."Allow Schedule/Contract Lines" := NS_jobcr."Allow Schedule/Contract Lines";
        NS_NewJob."NS_Job Address 1" := NS_jobcr."NS_Job Address 1";
        NS_NewJob."NS_Job Address 2" := NS_jobcr."NS_Job Address 2";
        NS_NewJob."NS_Job City" := NS_jobcr."NS_Job City";
        NS_NewJob."NS_Job County" := NS_jobcr."NS_Job County";
        NS_NewJob."NS_Job Post Code" := NS_jobcr."NS_Job Post Code";
        NS_NewJob."NS_Job Country/Region Code" := NS_jobcr."NS_Job Country/Region Code";
        NS_NewJob."NS_Job Contact" := NS_jobcr."NS_Job Contact";
        NS_NewJob."NS_Job Phone" := NS_jobcr."NS_Job Phone";
        NS_NewJob."NS_Job Ship-to Code" := NS_jobcr."NS_Job Ship-to Code";
        NS_NewJob."NS_Temp Linked Parent Job No." := NS_jobcr."NS_Temp Linked Parent Job No.";
        NS_NewJob."NS_Last Job For Job List" := NS_jobcr."NS_Last Job For Job List";
        //NS_NewJob."NS_Job Type" := NS_jobcr."NS_Job Type";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_Job Type New" := NS_jobcr."NS_Job Type New";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob.NS_Estimator := NS_jobcr.NS_Estimator;
        NS_NewJob.NS_Manager := NS_jobcr.NS_Manager;
        // NS_NewJob."NS_Manager Job Status" := NS_jobcr."NS_Manager Job Status";//PE-193.PS.2.0 12Dec2023 Commneted
        NS_NewJob."NS_Manager Job Status" := NS_jobcr."NS_Manager Job Status"::" "; //PE-193.PS.2.0 12Dec2023
        NS_NewJob."NS_Job Status Date" := 0D;
        NS_NewJob."NS_Estimated Start Date" := 0D;
        NS_NewJob."NS_Estimated Completion Date" := 0D;
        NS_NewJob."NS_Completion Date" := 0D;
        NS_NewJob."NS_Job Posting Date" := NS_jobcr."NS_Job Posting Date";
        NS_NewJob."NS_Recognition Date" := NS_jobcr."NS_Recognition Date";
        NS_NewJob."NS_Unit of Measure" := '';
        NS_NewJob."NS_Total Units" := 0;
        NS_NewJob."NS_Billing method" := NS_jobcr."NS_Billing method";
        NS_NewJob."NS_Recognition Method" := NS_jobcr."NS_Recognition Method";
        NS_NewJob."NS_Default Job Retention" := NS_jobcr."NS_Default Job Retention";
        NS_NewJob."NS_Tax Area Code" := NS_jobcr."NS_Tax Area Code";
        NS_NewJob."NS_Tax Liable" := NS_jobcr."NS_Tax Liable";
        //NS_NewJob."NS_Tax Group Code" := NS_jobcr."NS_Tax Group Code";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_Tax Group Code New" := NS_jobcr."NS_Tax Group Code New";  //PRJCTPR-298.JS.1.0 16JAN2024
        NS_NewJob."NS_VAT Bus. Posting Group" := NS_jobcr."NS_VAT Bus. Posting Group";
        NS_NewJob."NS_VAT Prod. Posting Group" := NS_jobcr."NS_VAT Prod. Posting Group";
        NS_NewJob."NS_Actual Percent Complete" := 0;
        NS_NewJob."NS_Actual PercentCompleteDate" := 0D;
        NS_NewJob."NS_Actual Units Complete" := 0;
        NS_NewJob."NS_Actual Units Complete Date" := 0D;
        NS_NewJob."NS_Job Revenue Posting" := NS_jobcr."NS_Job Revenue Posting";
        // NewJob."NS_Progress Billing No." := PassJob."NS_Progress Billing No.";//PRJ-1285.RM.1.0 commented
        NS_NewJob."NS_Progress Billing Sub-Level" := NS_jobcr."NS_Progress Billing Sub-Level";
        NS_NewJob."NS_Customer Job No." := NS_jobcr."NS_Customer Job No.";
        NS_NewJob."NS_Customer PO Number" := '';
        NS_NewJob."NS_Contract No." := NS_jobcr."NS_Contract No.";
        NS_NewJob."NS_Contract Date" := NS_jobcr."NS_Contract Date";
        NS_NewJob."NS_Contract For" := NS_jobcr."NS_Contract For";
        // NS_NewJob."NS_Sub-Level to Job No." := NS_jobcr."NS_Sub-Level to Job No."; //PE-193.PS.1.0 15Nov2023 Commneted
        NS_NewJob."NS_Sub-Level to Job No." := NS_jobcr."NS_Change Request to Job No."; //PE-193.PS.1.0 15Nov2023
        if NS_jobcr."NS_Change Request to Job No." = '' then
            NS_NewJob."NS_Sub-Level to Job No." := NS_jobcr."NS_Sub-Level to Job No.";
        NS_NewJob."NS_Job Class" := NS_NewJob."NS_Job Class"::"Change Order";
        NS_NewJob."NS_Job Purchaser" := NS_jobcr."NS_Job Purchaser";
        // NS_NewJob.INSERT(true);//PE-193.PS.2.0 8Dec2023 Commented 
        NS_NewJob.INSERT();//PE-193.PS.2.0 8Dec2023
        exit(NS_NewJob."No.");
    end;

    procedure NS_CreateCOTasklines(pcOldJobNo: Code[20]; pcNewJobNo: Code[20])
    var
    begin
        NS_CreateMainJobTaskNew(pcOldJobNo, pcNewJobNo);
    end;

    procedure NS_CreateCOPlanningLines(pcOldJobNo: Code[20]; pcNewJobNo: Code[20])
    var
        myInt: Integer;
    begin
        NS_MyProcedure(pcOldJobNo, pcNewJobNo);
    end;

    PROCEDURE NS_CreateChangeOrderNew(PassJob: Record 167);
    VAR
        NS_JobsSetup: Record 315;
        NS_NewJob: Record 167;
        NS_JobPage: Page 88;
        NS_SegmentsRec: Record "NS_Job Takeoff Segments";
        NS_TargetSegmentRec: Record "NS_Job Takeoff Segments";
        NS_DefaultDimRec: Record "Default Dimension";
        NS_DefaultDimRec2: Record "Default Dimension";
        NS_PassJobTask: Record "Job Task";
        NS_NewJobTask: Record "Job Task";
        NS_NewJobs2: Record Job;
        NS_NumSeriesMngt: Codeunit NoSeriesManagement;
        NS_JobNoNewRecord: code[50];
        NS_JobSetup: Record "Jobs Setup";
        NS_JObNumber: code[50];
        NS_jobcr: Record Job;
        NS_lbChangeOrderHeaderCreated: Boolean;
        NS_liNoOfRequest: Integer;
    BEGIN
        Clear(NS_lbChangeOrderHeaderCreated);
        Clear(NS_JobNoNewRecord);
        NS_jobcr.reset;
        NS_jobcr.setrange("NS_Sub-Level to Job No.", PassJob."NS_Sub-Level to Job No.");
        NS_jobcr.SetRange("NS_Manager Job Status", NS_jobcr."NS_Manager Job Status"::Approval);
        NS_jobcr.SetRange("NS_Job Class", NS_jobcr."NS_Job Class"::"Change Request");
        NS_liNoOfRequest := NS_jobcr.Count;
        if NS_jobcr.findset then
            repeat
                if not NS_lbChangeOrderHeaderCreated then begin
                    Message(NS_jobcr."No.");
                    NS_JobSetup.GET;
                    NS_JobNoNewRecord := NS_GetNextChangeOrderNoNew(PassJob, NS_JobSetup."NS_Change Order No. Separator");
                    NS_NewJob.INIT();
                    NS_NewJob."No." := NS_JobNoNewRecord;
                    NS_NewJob."No. Series" := '';
                    NS_NewJob.INSERT(true);

                    NS_NewJob."Search Description" := NS_jobcr."Search Description";
                    NS_NewJob.Description := NS_jobcr.Description;
                    NS_NewJob."Description 2" := NS_jobcr."Description 2";
                    NS_NewJob."Bill-to Customer No." := NS_jobcr."Bill-to Customer No.";
                    NS_NewJob."Creation Date" := TODAY();
                    NS_NewJob."Starting Date" := 0D;
                    NS_NewJob."Ending Date" := 0D;
                    NS_NewJob.Status := NS_NewJob.Status::Planning;
                    NS_NewJob."Person Responsible" := NS_jobcr."Person Responsible";
                    // VALIDATE("Global Dimension 1 Code");//ppal-174.AS.1.0 28DEC2020 Commented
                    // VALIDATE("Global Dimension 2 Code");//ppal-174.AS.1.0 28DEC2020 Commented
                    NS_NewJob."Global Dimension 1 Code" := NS_jobcr."Global Dimension 1 Code";//ppal-174.AS.1.0 28DEC2020 Added
                    NS_NewJob."Global Dimension 2 Code" := NS_jobcr."Global Dimension 2 Code";//ppal-174.AS.1.0 28DEC2020 Added
                    NS_NewJob."Job Posting Group" := NS_jobcr."Job Posting Group";
                    NS_NewJob.Blocked := NS_NewJob.Blocked::" ";
                    NS_NewJob."Customer Disc. Group" := NS_jobcr."Customer Disc. Group";
                    NS_NewJob."Customer Price Group" := NS_jobcr."Customer Price Group";
                    NS_NewJob."Language Code" := NS_jobcr."Language Code";
                    NS_NewJob."Bill-to Name" := NS_jobcr."Bill-to Name";
                    NS_NewJob."Bill-to Address" := NS_jobcr."Bill-to Address";
                    NS_NewJob."Bill-to Address 2" := NS_jobcr."Bill-to Address 2";
                    NS_NewJob."Bill-to City" := NS_jobcr."Bill-to City";
                    NS_NewJob."Bill-to County" := NS_jobcr."Bill-to County";
                    NS_NewJob."Bill-to Post Code" := NS_jobcr."Bill-to Post Code";
                    NS_NewJob."No. Series" := NS_jobcr."No. Series";
                    NS_NewJob."Bill-to Country/Region Code" := NS_jobcr."Bill-to Country/Region Code";
                    NS_NewJob."WIP Method" := NS_jobcr."WIP Method";
                    NS_NewJob."Currency Code" := NS_jobcr."Currency Code";
                    NS_NewJob."Bill-to Contact No." := NS_jobcr."Bill-to Contact No.";
                    NS_NewJob."Bill-to Contact" := NS_jobcr."Bill-to Contact";
                    NS_NewJob."NS_Sell-to Customer No." := NS_jobcr."NS_Sell-to Customer No.";
                    NS_NewJob."NS_Sell-to Customer Name" := NS_jobcr."NS_Sell-to Customer Name";
                    NS_NewJob."NS_Salesperson Code" := NS_jobcr."NS_Salesperson Code";
                    //"NS_Gen. Bus. Posting Group" := PassJob."NS_Gen. Bus. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
                    NS_NewJob."NS_Gen. Bus. Posting Group New" := NS_jobcr."NS_Gen. Bus. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                            //"NS_Gen. Prod. Posting Group" := PassJob."NS_Gen. Prod. Posting Group";//PRJ-831.AS.1.0 12OCT2021 Comment old
                    NS_NewJob."NS_Gen. Prod. Posting Group New" := NS_jobcr."NS_Gen. Prod. Posting Group New";//PRJ-831.AS.1.0 12OCT2021 Add New
                                                                                                              //PRJ-464.AM.1.0 end
                    NS_NewJob."WIP Posting Date" := NS_jobcr."WIP Posting Date";
                    NS_NewJob."WIP Posting Method" := NS_jobcr."WIP Posting Method";
                    NS_NewJob."Invoice Currency Code" := NS_jobcr."Invoice Currency Code";
                    NS_NewJob."Exch. Calculation (Cost)" := NS_jobcr."Exch. Calculation (Cost)";
                    NS_NewJob."Exch. Calculation (Price)" := NS_jobcr."Exch. Calculation (Price)";
                    NS_NewJob."Allow Schedule/Contract Lines" := NS_jobcr."Allow Schedule/Contract Lines";
                    NS_NewJob."NS_Job Address 1" := NS_jobcr."NS_Job Address 1";
                    NS_NewJob."NS_Job Address 2" := NS_jobcr."NS_Job Address 2";
                    NS_NewJob."NS_Job City" := NS_jobcr."NS_Job City";
                    NS_NewJob."NS_Job County" := NS_jobcr."NS_Job County";
                    NS_NewJob."NS_Job Post Code" := NS_jobcr."NS_Job Post Code";
                    NS_NewJob."NS_Job Country/Region Code" := NS_jobcr."NS_Job Country/Region Code";
                    NS_NewJob."NS_Job Contact" := NS_jobcr."NS_Job Contact";
                    NS_NewJob."NS_Job Phone" := NS_jobcr."NS_Job Phone";
                    NS_NewJob."NS_Job Ship-to Code" := NS_jobcr."NS_Job Ship-to Code";
                    NS_NewJob."NS_Temp Linked Parent Job No." := NS_jobcr."NS_Temp Linked Parent Job No.";
                    NS_NewJob."NS_Last Job For Job List" := NS_jobcr."NS_Last Job For Job List";
                    //NS_NewJob."NS_Job Type" := NS_jobcr."NS_Job Type"; //PRJCTPR-298.JS.1.0 16JAN2024
                    NS_NewJob."NS_Job Type New" := NS_jobcr."NS_Job Type New"; //PRJCTPR-298.JS.1.0 16JAN2024
                    NS_NewJob.NS_Estimator := NS_jobcr.NS_Estimator;
                    NS_NewJob.NS_Manager := NS_jobcr.NS_Manager;
                    NS_NewJob."NS_Manager Job Status" := NS_jobcr."NS_Manager Job Status";
                    NS_NewJob."NS_Job Status Date" := 0D;
                    NS_NewJob."NS_Estimated Start Date" := 0D;
                    NS_NewJob."NS_Estimated Completion Date" := 0D;
                    NS_NewJob."NS_Completion Date" := 0D;
                    NS_NewJob."NS_Job Posting Date" := NS_jobcr."NS_Job Posting Date";
                    NS_NewJob."NS_Recognition Date" := NS_jobcr."NS_Recognition Date";
                    NS_NewJob."NS_Unit of Measure" := '';
                    NS_NewJob."NS_Total Units" := 0;
                    NS_NewJob."NS_Billing method" := NS_jobcr."NS_Billing method";
                    NS_NewJob."NS_Recognition Method" := NS_jobcr."NS_Recognition Method";
                    NS_NewJob."NS_Default Job Retention" := NS_jobcr."NS_Default Job Retention";
                    NS_NewJob."NS_Tax Area Code" := NS_jobcr."NS_Tax Area Code";
                    NS_NewJob."NS_Tax Liable" := NS_jobcr."NS_Tax Liable";
                    //NS_NewJob."NS_Tax Group Code" := NS_jobcr."NS_Tax Group Code";   //PRJCTPR-298.JS.1.0 16JAN2024
                    NS_NewJob."NS_Tax Group Code New" := NS_jobcr."NS_Tax Group Code New";   //PRJCTPR-298.JS.1.0 16JAN2024
                    NS_NewJob."NS_VAT Bus. Posting Group" := NS_jobcr."NS_VAT Bus. Posting Group";
                    NS_NewJob."NS_VAT Prod. Posting Group" := NS_jobcr."NS_VAT Prod. Posting Group";
                    NS_NewJob."NS_Actual Percent Complete" := 0;
                    NS_NewJob."NS_Actual PercentCompleteDate" := 0D;
                    NS_NewJob."NS_Actual Units Complete" := 0;
                    NS_NewJob."NS_Actual Units Complete Date" := 0D;
                    NS_NewJob."NS_Job Revenue Posting" := NS_jobcr."NS_Job Revenue Posting";
                    // NewJob."NS_Progress Billing No." := PassJob."NS_Progress Billing No.";//PRJ-1285.RM.1.0 commented
                    NS_NewJob."NS_Progress Billing Sub-Level" := NS_jobcr."NS_Progress Billing Sub-Level";
                    NS_NewJob."NS_Customer Job No." := NS_jobcr."NS_Customer Job No.";
                    NS_NewJob."NS_Customer PO Number" := '';
                    NS_NewJob."NS_Contract No." := NS_jobcr."NS_Contract No.";
                    NS_NewJob."NS_Contract Date" := NS_jobcr."NS_Contract Date";
                    NS_NewJob."NS_Contract For" := NS_jobcr."NS_Contract For";
                    NS_NewJob."NS_Sub-Level to Job No." := NS_jobcr."NS_Sub-Level to Job No.";
                    NS_NewJob."NS_Job Class" := NS_NewJob."NS_Job Class"::"Change Order";
                    NS_NewJob."NS_Job Purchaser" := NS_jobcr."NS_Job Purchaser";

                    if NS_NewJob.MODIFY then
                        NS_lbChangeOrderHeaderCreated := true;

                end;

                NS_jobcr."NS_Manager Job Status" := NS_jobcr."NS_Manager Job Status"::" ";
                NS_jobcr.Modify(false);
                NS_CreateMainJobTaskNew(NS_jobcr."No.", NS_JobNoNewRecord);
                NS_MyProcedure(NS_jobcr."No.", NS_JobNoNewRecord);
            until NS_jobcr.Next() = 0;
        NS_jobcr.Reset();
        NS_jobcr.SetRange("No.", NS_JobNoNewRecord);
        if NS_jobcr.FindFirst() then begin
            if confirm('Do you want to open new change order %1', false, NS_JobNoNewRecord) then
                Page.Run(page::"Job Card", NS_jobcr);
        end;
    END;

    local procedure NS_CreateMainJobTaskNew(OldJobNo: Code[20]; NewJobNo: Code[20])
    var
        NS_jobTast: Record "Job Task";
        NS_OldJobTast: Record "Job Task";
    begin
        //if not Rec."NS_Include Sub Levels" then begin
        NS_OldJobTast.Reset();
        NS_OldJobTast.SetRange("Job No.", OldJobNo);
        if NS_OldJobTast.FindSet() then
            repeat
                if not NS_jobTast.Get(NewJobNo, NS_OldJobTast."Job Task No.") then begin
                    NS_jobTast.Init();
                    NS_jobTast.TransferFields(NS_OldJobTast);
                    NS_jobTast."Job No." := NewJobNo;
                    NS_jobTast.Insert();
                end;
            until NS_OldJobTast.Next() = 0;
    end;

    local procedure NS_MyProcedure(OldJobNo: Code[20]; NewJobNo: Code[20])
    var
        NS_JPL: Record "Job Planning Line";
        NS_NewJPL: Record "Job Planning Line";
        NS_JPL2: Record "Job Planning Line";
        NS_LiLineNo: Integer;
    begin
        NS_JPL.Reset();
        NS_JPL.SetRange("Job No.", OldJobNo);
        if NS_JPL.FindSet() then
            repeat
                NS_JPL2.Reset();
                NS_JPL2.SetRange("Job No.", NewJobNo);
                if NS_JPL2.FindLast() then
                    NS_LiLineNo := NS_JPL2."Line No." + 10000
                else
                    NS_LiLineNo := 10000;
                NS_NewJPL.Init();
                NS_NewJPL.TransferFields(NS_JPL);
                NS_NewJPL."Job No." := NewJobNo;
                NS_NewJPL."Line No." := NS_LiLineNo;
                NS_NewJPL.Insert();
                Commit();
            until NS_JPL.Next() = 0;
    end;

    procedure NS_MyProcedure1(pOldJob: Record Job; NewJobNo: Code[20])
    var
        NS_JPL: Record "Job Planning Line";
        NS_NewJPL: Record "Job Planning Line";
        NS_JPL2: Record "Job Planning Line";
        NS_LiLineNo: Integer;
        NS_OldJob: Record Job;
        NS_licount: Integer;
    begin
        NS_licount := pOldJob.Count;
        NS_LiLineNo := 10000;
        NS_OldJob := pOldJob;
        if NS_OldJob.FindSet() then
            repeat
                NS_JPL.Reset();
                NS_JPL.SetRange("Job No.", NS_OldJob."No.");
                if NS_JPL.FindSet() then
                    repeat
                        NS_NewJPL.Init();
                        NS_NewJPL.TransferFields(NS_JPL);
                        NS_NewJPL."Job No." := NewJobNo;
                        NS_NewJPL."Line No." := NS_LiLineNo;
                        if NS_NewJPL.Insert() then
                            NS_LiLineNo += 10000;
                    until NS_JPL.Next() = 0;
            until NS_OldJob.next() = 0;
    end;

    PROCEDURE NS_GetNextChangeOrderNoNew(PassJobNo: Record Job; PassJobSeparator: Text[10]): Code[20];
    VAR
        NS_JobRec: Record 167;
        NS_NewChangeOdrNo: Code[20];
        NS_JobSetup: Record "Jobs Setup";  //PE-246.HS.1.0 1Feb2024 
    BEGIN
        if NS_JobSetup.Get() then;    //PE-246.HS.1.0 1Feb2024 
        if (NS_JobSetup."NS_Change Ordr NumberingFormat" = '') then begin   //PE-246.HS.1.0 1Feb2024 
            NS_JobRec.Reset();

            NS_JobRec.SetRange("NS_Sub-Level to Job No.", PassJobNo."NS_Sub-Level to Job No.");//PE-193.PS.1.0 06Nov2023 Commented
                                                                                               //  NS_JobRec.SetRange("NS_Job Class", PassJobNo."NS_Job Class"::"Change Order");//PE-193.PS.2.0 04Dec2023
                                                                                               //NS_JobRec.SetRange("NS_Change Request to Job No.", PassJobNo."NS_Change Request to Job No.");//PE-193.PS.1.0 06Nov2023
                                                                                               // NS_JobRec.SetRange("NS_Job Class", NS_JobRec."NS_Job Class"::"Change Order");
            if NS_JobRec.FindLast() then begin
                if NS_JobRec."NS_Job Class" = NS_JobRec."NS_Job Class"::"Change Order" then
                    NS_NewChangeOdrNo := (INCSTR(NS_JobRec."No."))
                else
                    NS_NewChangeOdrNo := (PassJobNo."NS_Change Request to Job No." + PassJobSeparator + '001'); //PE-193.PS.1.0 06Nov2023 Commented
                                                                                                                //NS_NewChangeOdrNo := (PassJobNo."NS_Change Request to Job No." + PassJobSeparator + '001'); //PE-193.PS.1.0 06Nov2023
                exit(NS_NewChangeOdrNo);

            end;
        end  //PE-246.HS.1.0 1Feb2024 

        //PE-246.HS.1.0 1Feb2024 Start
        else begin
            NS_JobRec.SetRange("NS_Sub-Level to Job No.", PassJobNo."NS_Sub-Level to Job No.");
            if NS_JobRec.FindLast() then begin
                if NS_JobRec."NS_Job Class" = NS_JobRec."NS_Job Class"::"Change Order" then
                    NS_NewChangeOdrNo := (INCSTR(NS_JobRec."No."))
                else
                    NS_NewChangeOdrNo := (PassJobNo."NS_Change Request to Job No." + PassJobSeparator + NS_JobSetup."NS_Change Ordr NumberingFormat");
                exit(NS_NewChangeOdrNo);

            end;
        end
        //PE-246.HS.1.0 1Feb2024 End
    END;


    //PRJCTPR-147.NK.1.0 end 17Aug2023
    //PRJCTPR-362.PS.1.0 01May2024 Start
    procedure NS_InsertDimension(SublevelNo: Code[20]; NS_JobTask: Record "Job Task")
    var
        NS_Jobocal: Record Job;
        NS_DefaultDimRec: Record "Default Dimension";
        NS_DefaultDimRec2: Record "Job Task Dimension";
        DefaultDimRec: Record "Default Dimension";
        DefaultDimRec2: Record "Job Task Dimension";
    begin
        if NS_Jobocal.Get(SublevelNo) then begin
            DefaultDimRec.Reset();
            DefaultDimRec.SetRange("Table ID", 167);
            DefaultDimRec.SetRange("No.", SublevelNo);
            if DefaultDimRec.FindSet() then
                repeat
                    DefaultDimRec2.Init();
                    DefaultDimRec2."Job No." := NS_JobTask."Job No.";
                    DefaultDimRec2."Job Task No." := NS_JobTask."Job Task No.";
                    DefaultDimRec2.Validate("Dimension Code", DefaultDimRec."Dimension Code");
                    DefaultDimRec2.Validate("Dimension Value Code", DefaultDimRec."Dimension Value Code");
                    DefaultDimRec2.Insert();
                until DefaultDimRec.Next() = 0;
        end;
    end;
    //PRJCTPR-362.PS.1.0 01May2024 End
    //PRJ-1015.JS.1.0 10Oct2021 - Start

    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Job Address 1                14021155 Progress Billing No.            14021305 Budgeted Res. Gr. Qty.
      +     14021101 Job Address 2              14021156 Progress Billing Sub-Level      14021310 Usage (Cost) (LCY)
      +     14021102 Job City                    14021160 Customer Job No.                14021311 Usage (Price) (LCY)
      +     14021103 Job County                  14021161 Customer PO Number              14021312 Actual Cost Quantity (Usage)
      +     14021104 Job Post Code              14021162 Contract No.                    14021313 Actual Price Quantity (Usage)
      +     14021105 Job Country/Region Code    14021163 Contract Date                  14021314 Actual Cost Quantity (Sale)
      +     14021106 Job Contact                14021164 Contract For                    14021315 Actual Price Quantity (Sale)
      +     14021107 Job Phone                  14021165 Contract Type                  14021330 Invoiced Price (LCY)
      +     14021108 Job Ship-to Code            14021166 Contract Sell Price            14021331 Amt. Paid (LCY)
      +     14021110 Sub-Level to Job No.        14021170 Requires Certified Payroll      14021335 Amt. Posted To G/L
      +     14021111 Temp Linked Parent Job No.  14021171 Gen. Prod. Posting Group        14021336 Amt.Recognized
      +     14021112 Last Job For Job List      14021190 OS File Name                    14021340 Locked Planning Lines Exist
      +     14021115 Job Type                    14021191 Job Calendar Code              14021341 Locked Budget Cost (LCY)
      +     14021116 Job Class                  14021200 Prepayment No.                  14021342 Locked Budget Price (LCY)
      +     14021117 Time And Material          14021201 Prepayment %                    14021343 Locked Budget Cost Qty.
      +     14021118 Indirect Burden Type        14021202 Prepayment No. Series          14021344 Locked Budget Price Qty.
      +     14021119 Salesperson Code            14021203 Compress Prepayment            14021345 Locked Budget Res. Qty.
      +     14021120 Estimator                  14021204 Prepayment Due Date            14021346 Locked Budget Res. Gr. Qty.
      +     14021121 Manager                    14021205 Prepmt. Cr. Memo No. Series    14021350 Job Calendar Type
      +     14021122 Manager Job Status          14021206 Prepmt. Payment Terms Code      14021351 Retention Ledger Filter
      +     14021123 Job Status Date            14021207 Prepmt. Payment Discount %      14021400 AP Comment
      +     14021125 Estimated Start Date        14021208 Prepmt. Cr. Memo No.            14021401 Quote No.
      +     14021126 Estimated Completion Date  14021209 Prepayment Amount              14021402 Job Site Customer No.
      +     14021127 Completion Date            14021210 Schedule Total Cost            14021403 Job Site Customer Name
      +     14021128 Job Posting Date            14021250 Cost Category Filter            14021405 Owner No.
      +     14021129 Recognition Date            14021251 Revenue Category Filter        14021406 Owner Name
      +     14021130 Unit of Measure            14021252 Job Task No. Filter            14021407 General Contractor No.
      +     14021131 Total Units                14021253 Exclude Entry Filter            14021408 General Contractor Name
      +     14021134 Billing Day of Month        14021255 Global Dimension 1 Filter      14021409 Architect/Engineer No.
      +     14021135 Billing Method              14021256 Global Dimension 2 Filter      14021410 Architect/Engineer Name
      +     14021136 Recognition Method          14021257 Entry Type Filter              14021411 Project Manager No.
      +     14021137 Default Job Retention      14021258 Adjustment Filter              14021412 Project Manager Name
      +     14021138 Forecast Type              14021259 Budget Type Filter              14021413 Bond
      +     14021140 Tax Area Code              14021260 Item No. Filter                14021414 Billing Cutoff Day of Month
      +     14021141 Tax Liable                  14021261 Type Filter                    14021415 CCIP/OCIP/RCOIP Insurance
      +     14021142 Tax Group Code              14021262 Date Filter                    14021416 Lien Waiver Required
      +     14021145 VAT Bus. Posting Group      14021265 Activity Filter                14021417 Use Tax SKU
      +     14021146 VAT Prod. Posting Group    14021266 Process Filter                  14021418 Customer Account
      +     14021150 Actual Percent Complete    14021267 Operation Filter                14021419 Created from Quote No.
      +     14021151 Actual Percent Complete    14021300 Budgeted Cost (LCY)            14021420 Quote Revision
      +     14021152 Actual Units Complete      14021301 Budgeted Price (LCY)            14021421 Use Job Material Planning
      +     14021153 Actual Units Complete Date  14021302 Budgeted Cost Quantity          14021422 Sell-to Customer No.
      +     14021154 Job Revenue Posting        14021303 Budgeted Price Quantity        14021423 Sell-to Customer Name
      +                                           14021304 Budgeted Res. Qty
      +
      +  - Added function(s):
      +     MarkJobSub-Levels          SLsBudgetedResGrQty          APOToJobTaskNo
      +     BudgetedLaborHours        SLsRetentionInvoiced        JAPOToJobTaskNo
      +     ActualLaborHours          SLsRetentionBalance          CalculateJobFinancials
      +     RetentionInvoiced          SLsWIPCosts                  CalculateJobStatistics
      +     RetentionBalance          SLsWIPSales                  VariancePercent
      +     MarkSub-Levels            SLsWIPCostsGL                CalculateActualCostToDate
      +     SLsBudgetedCost            SLsWIPSalesGL                CalculateInvoiceBilled
      +     LockedSLsBudgetedCost      SLsRecogCosts                GetBillDate
      +     SLsBudgetedCostQty        SLsRecogSales                InitVar
      +     SLsBudgetedPrice          SLsRecogCostsGL              LoadTasks
      +     LockedSLsBudgetedPrice    SLsRecogSalesGL              LoadTasksActivity
      +     SLsBudgetedPriceQty        CalculatedPercentComplete    LoadTasksProcess
      +     SLsBudgetedLaborHours      SeparatorCount              LoadTasksOperation
      +     SLsUsage(Cost)            ParentJobNo                  CreateChangeOrder
      +     SLsActualCostQty          SetLastJobListFlag          GetNextChangeOrderNo
      +     SLsUsage(Price)            FindLastJobNo                CreateWorkOrder
      +     SLsActualPriceQty          GetJobResourceCost          CopyCostPricing
      +     SLsUsageLaborHours        GetJobItemCost              SetCopyJob
      +     SLsInvoicedPrice          GetJobGLCost                CopyPlanningToLocked
      +     SLsPaymentReceived        CorrectForBlankFields        SetDisableLoadTasks
      +     SLsPaymentsMade            JobTaskNoSeparatorCount      SetSupressDimConfirmDialogs
      +     SLsBudgetedResQty          JobTaskNoToAPO
      +
      +  - Added global variable(s):
      +     WIPQst                PP_GLSetup
      +     PP_JobTaskNo          PP_SalesSetup
      +     PP_JobLinks           QuoteMgt
      +     PP_JobOperation       SkipTasks
      +     PP_JobTask            FromQuote
      +     PP_JobProcess         GLSetup
      +     PP_JobActivity        CopiedJob
      +     PP_JobTaskCheck       DisableLoadTasks
      +     PP_JobLedgerEntry     SupressDefaultTasksDialog
      +     PP_JobContact         SupressDimConfirmDialogs
      +     PP_JobCostCategory
      +
      +  - Added global text constant(s):
      +     Text14021100      Text14021109
      +     Text14021101      Text14021110
      +     Text14021102      Text14021111
      +     Text14021103      Text14021112
      +     Text14021104      Text14021113
      +     Text14021105      Text14021400
      +     Text14021106      Text14021401
      +     Text14021107      Text14021402
      +     Text14021108
      +
      +  - Modification(s):
      +     - Added Keys:
      +        Sub-Level to Job No.,Contract Date
      +        Last Job For Job List,No.
      +        Manager Job Status
      +        Job Class,Job Type
      +
      +     - Table Properties
      +         LookupPage to Job List page
      +         DrillDownPage to Job List page
      +
      +     - OnInsert:
      +         - Populate default job tasks
      +         - Stop manually entered Job No. from updating Job No. Series to ensure No. Series stays correct for next Job
      +         - Set Forecast Type
      +         - Create Job Links
      +         - Load related tasks
      +
      +     - OnDelete:
      +        - Error if the Job Status is Open
      +        - Verify delete if the Job is a Template
      +        - Error if job has sub-level job attached to it
      +        - Delete associated records in ProjectPro tables
      +           Job Planning Line
      +           Job Ledger Entry
      +           Job Contact
      +           Job Links
      +           Job Segments
      +
      +     - Fields
      +         Description             - OnValidate - Set 'Contract For' to Description based on circumstances
      +         Job Class               - OnValidate - set "No. Series" to blank so that the SubJob No. does not get used when creating the next Job No.
      +         Sub-level to Job No.    - OnValidate - set "No. Series" to blank so that the SubJob No. does not get used when creating the next Job No.
      +         Status                  - OnValidate - Require an Indirect Burden Type before changing from Planning status
      +                                 - Removed InitValue=Order
      +         Person Responsible      - Removed TableRelation
      +         Bill-to Customer No.    - OnValidate - Modify condition for an error
      +
      +     - Functions
      +         ValidateShortcutDimCode
      +         UpdateCust
      +         UpdateJobTaskDimension
      +-----------------------------------------------------------------------------------------------*/
}

