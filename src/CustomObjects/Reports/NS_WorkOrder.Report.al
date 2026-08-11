//PE-311.PP.1.0 11JUN2024 | enhancement done in work order report.
report 14021488 "NS_WorkOrder"
{
    DefaultLayout = RDLC;
    Caption = 'Work Order';
    RDLCLayout = './Layouts/NS_WorkOrder.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "NS_Contract Date";
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            column(WorkOrderNo; Job."No.") { }
            column(WorkOrderDate; Workdate)
            {
            }

            column(WorkOrderManager; Job.NS_Manager)
            {
            }
            column(ManagerName; ManagerName)
            {

            }
            column(JobNoLbl; JobNoLbl)
            {

            }
            column(HeadingLbl; HeadingLbl)
            {

            }
            column(Bracket; Bracket)
            {
            }
            column(SignOfLbl; SignOfLbl) { }
            column(RepresenLbl; RepresenLbl) { }
            column(Totallbl; Totallbl) { }
            column(ShipToName; ShipToName) { }
            column(WorkOrderCustAddress; JobAddress)
            {
            }
            column(WorkOrderCustAddress2; JobAddress2)
            {
            }
            column(WorkOrderCustName; "Bill-to Name")
            {
            }
            column(WorkOrderCustPhone; JobPhone)
            {
            }
            column(WorkOrderDescription; Job.Description)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompAddress)
            {
            }
            column(CompanyPhone; CompPhone)
            {
            }
            column(CompanyLogo; CompanyInfo.Picture)
            {
            }
            column(FooterSignatureLabel; SignatureLabel)
            {
            }
            column(FooterDateLabel; DateLabel)
            {
            }
            column(FooterCustSignatureLabel; CustSignatureLabel)
            {
            }
            column(SignatureLbl; SignatureLbl) { }
            column(PreparedByLbl; PreparedByLbl) { }
            column(Userid; Username) { }
            column(dateLbl; DateLbl) { }
            column(AllWorkInstructions; AllWorkInstructions) { }
            dataitem("NS_Work Type Info"; "NS_Work Type Info")
            {
                DataItemTableView = sorting("NS_Job No.");
                DataItemLink = "NS_Job No." = FIELD("No.");
                column(NS_WorkAssignedDate; Format(NS_Date, 0, '<Month,2>/<Day,2>/<Year4>'))
                {
                }
                column(NS_Work_Description; "NS_Work Description")
                {
                }
                column(NS_Work_Type; "NS_Work Type")
                {
                }
                column(NS_WorkRequestedDate; Format("NS_Work Requested Date", 0, '<Month,2>/<Day,2>/<Year4>'))
                {
                }

                trigger OnPreDataItem()
                begin
                    SetFilter("NS_Work Type", WO_RefNoFilter);
                end;

                trigger OnAfterGetRecord()
                begin
                    if ("NS_Include Line") and ("NS_Work Instructions".Trim() <> '') then
                        AllWorkInstructions := AllWorkInstructions + "NS_Work Instructions" + '. ';
                end;
            }
            dataitem("Job Cost Category"; "NS_Job Cost Category")
            {
                DataItemTableView = SORTING(NS_Code) ORDER(Ascending);
                PrintOnlyIfDetail = true;
                column(JobCostCategory; NS_Code)
                {
                }
                column(JobCostCatDesc; NS_Type)
                {
                }
                column(Priority; Priority) { }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);
                    column(Detail_CostCategory; TempJPLine."NS_Cost Category")//AM
                    {
                    }
                    column(Detail_WorkOrderDate; TempJPLine."Planning Date")
                    {
                    }
                    column(Detail_Type; TempJPLine.Type)
                    {
                    }
                    column(Detail_No; TempJPLine."No.") //AM
                    {
                    }
                    column(Detail_Description; TempJPLine.Description)//AM
                    {
                    }
                    column(Detail_Quantity; TempJPLine.Quantity)//AM
                    {
                    }
                    column(Detail_Rate; TempJPLine."Unit Price")
                    {
                    }
                    column(Detail_Total; TempJPLine."Line Amount")
                    {
                    }
                    //PRJ-223.MS.1.0 Start
                    column(Skill_Code; TempJPLine."NS_Skill Class")//AM
                    {

                    }
                    column(Work_TYpe_Code; TempJPLine."Work Type Code")//AM
                    {
                    }
                    //PRJ-223.MS.1.0 End
                    column(UOMCode; TempJPLine."Unit of Measure Code")//AM
                    {
                    }
                    column(JobCCategory; TempJPLine."NS_Cost Category")
                    {
                    }
                    column(TaskCodeName; TaskCodeName) { }
                    column(TempJPLineTaskNo; TempJPLine."Job Task No.") { }
                    column(TempJPLineNo; TempJPLine."Line No.") { }
                    trigger OnPreDataItem();
                    begin
                        TempJPLine.RESET();
                        TempJPLine.SETRANGE("Job No.", Job."No.");
                        TempJPLine.SETRANGE("NS_Cost Category", "Job Cost Category".NS_Code);
                        if FilterString <> '' then
                            TempJPLine.SetFilter("Job Task No.", '%1', FilterString);
                        TempLedgEntryCount := TempJPLine.COUNT;
                        SETRANGE(Number, 1, TempLedgEntryCount);
                        RowCount := 0;
                    end;

                    trigger OnAfterGetRecord();
                    begin
                        RowCount += 1;
                        if RowCount = 1 then
                            TempJPLine.FINDFIRST()
                        else
                            TempJPLine.NEXT();

                        //Task Code Name
                        Clear(TaskCodeName);
                        JobTaskRec.Reset();
                        JobTaskRec.SetRange("Job No.", TempJPLine."Job No.");
                        JobTaskRec.SetRange("Job Task No.", TempJPLine."Job Task No.");
                        if JobTaskRec.FindFirst() then
                            TaskCodeName := JobTaskRec.Description
                        else
                            TaskCodeName := '';
                    end;
                }
                trigger OnAfterGetRecord()
                var
                begin
                    if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Labor then
                        Priority := 1
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Equipment then
                        Priority := 2
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Material then
                        Priority := 3
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Subcontract then
                        Priority := 4
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Manufacturing then
                        Priority := 5
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Overhead then
                        Priority := 6
                    else if "Job Cost Category".NS_Type = "Job Cost Category".NS_Type::Miscellaneous then
                        Priority := 7
                    else
                        Priority := 8;
                end;
            }

            trigger OnAfterGetRecord();
            var
                EntryNo: Integer;
                ShipToAddress: Record "Ship-to Address";
                JobSetup: Record "Jobs Setup";
                NS_WorkTypeInfo: Record "NS_Work Type Info";
                user: Record User;
                FilterString: Text[1024];
                TempFilterString: Text[20];
                MaxFilterLength: Integer;
            begin
                Clear(Username);
                user.Reset();
                user.SetRange("User Name", USERID);
                if user.FindFirst() then
                    Username := user."Full Name"
                else
                    Username := User."User Name";

                TestField(Job."NS_Contract Date");

                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);
                TempJPLine.DELETEALL();
                JobAddress := Job."NS_Job Address 1" + ', ' + Job."NS_Job Address 2";
                JobAddress2 := Job."NS_Job City" + ' ' + Job."NS_Job County" + ' ' + Job."NS_Job Post Code";
                JobPhone := job."NS_Job Phone";

                Clear(ShipToName);
                if "NS_Job Ship-to Code" <> '' then begin
                    if JobSetup."NS_Sell-to Cust_Ship-to Code" then
                        ShipToAddress.GET("Sell-to Customer No.", "NS_Job Ship-to Code")
                    else
                        ShipToAddress.GET("Bill-to Customer No.", "NS_Job Ship-to Code");
                    ShipToName := ShipToAddress.Name;
                End;

                CompAddress := CompanyInfo.Address;
                if CompanyInfo."Address 2" <> '' then
                    CompAddress := CompAddress + ', ' + CompanyInfo."Address 2";
                CompAddress := CompAddress + ', ' + CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
                CompPhone := 'Phone: ' + CompanyInfo."Phone No." + ' Fax: ' + CompanyInfo."Fax No.";
                SignatureLabel := STRSUBSTNO(Text001, CompanyInfo.Name);

                Clear(FilterString);
                MaxFilterLength := MAXSTRLEN(FilterString);
                if WO_RefNoFilter <> '' then Begin
                    NS_WorkTypeInfo.reset;
                    NS_WorkTypeInfo.SetRange("NS_Job No.", Job."No.");
                    NS_WorkTypeInfo.Setfilter("NS_Work Type", WO_RefNoFilter);
                    NS_WorkTypeInfo.SetFilter("NS_Work Task No.", '<>%1', '');
                end else begin
                    NS_WorkTypeInfo.reset;
                    NS_WorkTypeInfo.SetRange("NS_Job No.", Job."No.");
                    NS_WorkTypeInfo.SetFilter("NS_Work Task No.", '<>%1', '');
                end;
                if NS_WorkTypeInfo.FindSet() then
                    repeat
                        TempFilterString := NS_WorkTypeInfo."NS_Work Task No.";
                        if STRLEN(FilterString) + STRLEN(TempFilterString) + 1 > MaxFilterLength then
                            break;
                        if FilterString <> '' then
                            FilterString := FilterString + '|';
                        FilterString := FilterString + TempFilterString;
                    until NS_WorkTypeInfo.Next() = 0;

                EntryNo := 0;
                CostCategory.RESET();
                CostCategory.FINDSET();
                repeat
                    PurchRecHeader.RESET();
                    PurchRecHeader.SETRANGE("NS_Job No.", Job."No.");
                    if PurchRecHeader.FINDSET() then begin
                        repeat
                            PurchRecLine.RESET();
                            PurchRecLine.SETRANGE("Document No.", PurchRecHeader."No.");
                            PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                            PurchRecLine.SETRANGE("Quantity Invoiced", 0);
                            if FilterString <> '' then
                                PurchRecLine.SETfilter("Job Task No.", '%1', FilterString);
                            if PurchRecLine.FINDSET() then
                                repeat
                                    EntryNo += 10000;
                                    TempJPLine.INIT();
                                    case PurchRecLine.Type of
                                        PurchRecLine.Type::Item:
                                            TempJPLine.Type := TempJPLine.Type::Item;
                                        PurchRecLine.Type::"G/L Account":
                                            TempJPLine.Type := TempJPLine.Type::"G/L Account";
                                    end;
                                    TempJPLine.Quantity := PurchRecLine.Quantity;
                                    TempJPLine."Unit Price" := PurchRecLine."Unit Price (LCY)";
                                    TempJPLine."Line Amount" := PurchRecLine.Quantity * PurchRecLine."Unit Price (LCY)";
                                    TempJPLine.INSERT();
                                until PurchRecLine.NEXT() = 0;
                        until PurchRecHeader.NEXT() = 0;
                    end else begin
                        PurchRecLine.RESET();
                        PurchRecLine.SETRANGE("Job No.", Job."No.");
                        PurchRecLine.SETRANGE("NS_Job Cost Category", CostCategory.NS_Code);
                        PurchRecLine.SETRANGE("Quantity Invoiced", 0);
                        if FilterString <> '' then
                            PurchRecLine.SETFILTER("Job Task No.", FilterString);
                        if PurchRecLine.FINDSET() then
                            repeat
                                EntryNo += 10000;
                                TempJPLine.INIT();
                                TempJPLine."Line No." := EntryNo;//AM
                                case PurchRecLine.Type of
                                    PurchRecLine.Type::Item:
                                        TempJPLine.Type := TempJPLine.Type::Item;
                                    PurchRecLine.Type::"G/L Account":
                                        TempJPLine.Type := TempJPLine.Type::"G/L Account";
                                end;
                                TempJPLine.Quantity := PurchRecLine.Quantity;
                                TempJPLine."Unit Price" := PurchRecLine."Unit Price (LCY)";
                                TempJPLine."Line Amount" := PurchRecLine.Quantity * PurchRecLine."Unit Price (LCY)";
                                TempJPLine.INSERT();
                            until PurchRecLine.NEXT() = 0;
                    end;

                    JobPlanningLine.RESET();
                    JobPlanningLine.SETRANGE("Job No.", Job."No.");
                    JobPlanningLine.SETRANGE("NS_Cost Category", CostCategory.NS_Code);
                    JobPlanningLine.SetRange("NS_Contract Forecast Date", job."NS_Contract Date");
                    if FilterString <> '' then
                        JobPlanningLine.SetFilter("Job Task No.", FilterString);
                    if JobPlanningLine.FINDSET() then
                        repeat
                            EntryNo += 10000;
                            TempJPLine.INIT();
                            TempJPLine := JobPlanningLine;
                            TempJPLine."Line No." := EntryNo;
                            TempJPLine.INSERT();
                        until JobPlanningLine.NEXT() = 0;
                until CostCategory.NEXT() = 0;

                //MANAGER NAME
                Clear(ManagerName);
                if NS_Manager > '' then begin
                    Resource.GET(NS_Manager);
                    ManagerName := Resource.Name;
                end else
                    ManagerName := '';
            end;

            trigger OnPreDataItem();
            begin
                if JobNoFilter <> '' then
                    Job.SETFILTER("No.", JobNoFilter);

                JobNo := Job.GetFilter("No.");
                IF JobNo = '' then
                    Error('You must select a Job No.');
                if NOT JobRec.Get(JobNo) then
                    Error('You can only select one Job No.');
            end;
        }

    }


    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("WO Ref No Filter"; WO_RefNoFilter)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }
    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then;
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnInitReport()
    var
        NS_JobRec: Record Job;
    begin
        NS_JobRec.Reset();
        NS_JobRec.SetRange("No.", "NS_Work Type Info"."NS_Job No.");
    end;

    var
        JobAddress: Text[120];
        JobAddress2: Text[120];
        JobPhone: text[60];
        ActivityCodes: Text[1000];
        JobDescription: Text[1000];
        CompAddress: Text[120];
        CompAddress2: Text[120];
        CompPhone: Text[60];
        CompanyInfo: Record "Company Information";
        JobLedgEntry: Record "Job Ledger Entry";
        JobPlanningLine: Record "Job Planning Line";
        PurchRecLine: Record "Purch. Rcpt. Line";
        PurchRecHeader: Record "Purch. Rcpt. Header";
        CostCategory: Record "NS_Job Cost Category";
        TempJobLedgEntry: Record "Job Ledger Entry" temporary;
        TempJPLine: Record "Job Planning Line" temporary;
        Text001: Label '%1 Signature';
        DateLabel: Label 'Date';
        CustSignatureLabel: Label 'Customer Signature';
        CostCategoryCode: Code[20];
        CompName: Text[120];
        TempLedgEntryCount: Integer;
        RowCount: Integer;
        SignatureLabel: Text[70]; //PRJ-195.MS.1.0 Modified //AM
        JobNoFilter: Text[60];
        ManagerName: Text;

        JobNoLbl: Label 'Job No.:';
        HeadingLbl: Label 'Work Order';
        //Date: Date;
        EndDate: date;
        Resource: Record Resource;

        LabQty: Decimal;
        LabAmount: Decimal;
        Month: Integer;
        Year: Integer;
        JobNo: Text;
        JobRec: Record Job;
        JobCC: Record "NS_Job Cost Category";
        JobCC2: Record "NS_Job Cost Category";
        JobCCType: Option;
        Bracket: Label ')';
        Totallbl: Label 'Total ';
        TaskCodeName: Text[100];
        JobTaskRec: Record "Job Task";
        SignOfLbl: Label 'Signature Of ';
        RepresenLbl: Label ' Representative/Date';
        Priority: Integer;
        E: Text;
        M: Text;
        LEMOption: Option;
        ShipToName: Text[200];

        SignatureLbl: Label 'Signature: __________________________';
        PreparedByLbl: Label 'Prepared By: ';
        DateLbl: Label 'Date: ';
        AllWorkInstructions: Text[2000];
        Username: Text[200];
        FilterString: text[100];
        WO_RefNoFilter: Text[100];


    procedure SetFilter(PassJobNoFilter: Text[60]);
    begin
        JobNoFilter := PassJobNoFilter;
    end;
}

