report 14021160 "NS_Job Cost Budget withSorting"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSJob Cost Budget with Sorting.rdl';

    Caption = 'Job Cost Budget with Sorting';

    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.", "Bill-to Customer No.", Status;
            column(Job_No_; "No.")
            {
            }
            column(Job_Planning_Date_Filter; "Planning Date Filter")
            {
            }
            column(ActivityFirst; ActivityFirst)
            {
            }
            dataitem(PageHeader; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(BudgetOptionText; BudgetOptionText)
                {
                }
                column(SortingOptionText; SortingOptionText)
                {
                }
                column(CompanyInformation_Name; CompanyInformation.Name)
                {
                }
                column(Title; Title)
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(USERID; USERID)
                {
                }
                column(TIME; TIME)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Job_TABLECAPTION_____Filters______JobFilter; Job.TABLECAPTION + ' Filters: ' + JobFilter)
                {
                }
                column(JobFilter; JobFilter)
                {
                }
                column(Job__Description_2_; Job."Description 2")
                {
                }
                column(Job_Description; Job.Description)
                {
                }
                column(Job_FIELDCAPTION__Ending_Date____________FORMAT_Job__Ending_Date__; Job.FIELDCAPTION("Ending Date") + ': ' + FORMAT(Job."Ending Date"))
                {
                }
                column(Job_FIELDCAPTION__Starting_Date____________FORMAT_Job__Starting_Date__; Job.FIELDCAPTION("Starting Date") + ': ' + FORMAT(Job."Starting Date"))
                {
                }
                column(PageHeader_Number; Number)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_DescriptionCaption; Job_DescriptionCaptionLbl)
                {
                }
                column(Job_Planning_Line__Job_Task_No__Caption; "Job Planning Line".FIELDCAPTION("Job Task No."))
                {
                }
                column(PADSTR____2____Job_Task__Indentation_____Job_Task__DescriptionCaption; PADSTR____2____Job_Task__Indentation_____Job_Task__DescriptionCaptionLbl)
                {
                }
                column(Job_Planning_Line_TypeCaption; "Job Planning Line".FIELDCAPTION(Type))
                {
                }
                column(Job_Planning_Line__No__Caption; "Job Planning Line".FIELDCAPTION("No."))
                {
                }
                column(Job_Planning_Line_QuantityCaption; "Job Planning Line".FIELDCAPTION(Quantity))
                {
                }
                column(Job_Planning_Line__Unit_Cost__LCY__Caption; "Job Planning Line".FIELDCAPTION("Unit Cost (LCY)"))
                {
                }
                column(Job_Planning_Line__Total_Cost__LCY__Caption; "Job Planning Line".FIELDCAPTION("Total Cost (LCY)"))
                {
                }
                column(Job_Planning_Line__Unit_Price__LCY__Caption; "Job Planning Line".FIELDCAPTION("Unit Price (LCY)"))
                {
                }
                column(Job_Planning_Line__Total_Price__LCY__Caption; "Job Planning Line".FIELDCAPTION("Total Price (LCY)"))
                {
                }
                dataitem("Job Task"; "Job Task")
                {
                    DataItemLink = "Job No." = FIELD("No.");
                    DataItemLinkReference = Job;
                    DataItemTableView = SORTING("Job No.", "Job Task No.");
                    column(Job_Task_Job_No_; "Job No.")
                    {
                    }
                    column(Job_Task_Job_Task_No_; "Job Task No.")
                    {
                    }
                    column(Job_Task_Task_Factor; ' ')
                    {
                    }
                    column(Job_Task_Description; Description)
                    {
                    }
                    dataitem(BlankLine; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(Job_Task___No__of_Blank_Lines_; "Job Task"."No. of Blank Lines")
                        {
                        }
                        column(BlankLine_Number; Number)
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            SETRANGE(Number, 1, "Job Task"."No. of Blank Lines");
                        end;
                    }
                    dataitem("Job Planning Line"; "Job Planning Line")
                    {
                        DataItemLink = "Job No." = FIELD("No."), "Planning Date" = FIELD("Planning Date Filter");
                        DataItemLinkReference = Job;
                        DataItemTableView = SORTING("Job No.", "Job Task No.", "Schedule Line", "Planning Date") WHERE(Type = FILTER(<> Text));
                        column(Job_Planning_Line__Job_Task_No__; "Job Task No.")
                        {
                        }
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description; PADSTR('', 2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Planning_Line_Type; Type)
                        {
                        }
                        column(Job_Planning_Line__No__; "No.")
                        {
                        }
                        column(Job_Planning_Line_Quantity; Quantity)
                        {
                        }
                        column(Job_Planning_Line__Unit_Cost__LCY__; "Unit Cost (LCY)")
                        {
                        }
                        column(Job_Planning_Line__Total_Cost__LCY__; "Total Cost (LCY)")
                        {
                        }
                        column(Job_Planning_Line__Unit_Price__LCY__; "Unit Price (LCY)")
                        {
                        }
                        column(Job_Planning_Line__Total_Price__LCY__; "Total Price (LCY)")
                        {
                        }
                        column(Job_Task___Job_Task_Type_; "Job Task"."Job Task Type")
                        {
                        }
                        column(Job_Planning_Line_Job_No_; "Job No.")
                        {
                        }
                        column(Job_Planning_Line_Line_No_; "Line No.")
                        {
                        }
                        column(Job_Planning_Line_Planning_Date; "Planning Date")
                        {
                        }
                        column(Job_Planning_Line_Description; Description)
                        {
                        }
                        column(Job_Planning_Line_Work_Units; "NS_Work Units")
                        {
                        }
                        column(Job_Planning_Line_Segment_Code; "NS_Segment Code")
                        {
                        }
                        column(Job_Planning_Line_Segment_Name; SegmentName)
                        {
                        }
                        column(Job_Planning_Line_ActivityCode; "NS_Activity Code")
                        {
                        }

                        trigger OnAfterGetRecord();
                        var
                            PPJobSegments: Record "NS_Job Takeoff Segments";
                        begin
                            PPJobSegments.SETRANGE(PPJobSegments.NS_Type, PPJobSegments.NS_Type::Drawing);
                            PPJobSegments.SETRANGE("NS_Job No.", "Job No.");
                            PPJobSegments.SETRANGE("NS_Segment Code", "NS_Segment Code");
                            if PPJobSegments.FINDFIRST then
                                SegmentName := PPJobSegments."NS_Segment Name"
                            else
                                SegmentName := "NS_Segment Code";
                        end;

                        trigger OnPreDataItem();
                        begin
                            CurrReport.CREATETOTALS("Total Cost (LCY)", "Total Price (LCY)");
                            //CurrReport.CREATETOTALS("Total Cost (LCY)","Total Price (LCY)",Quantity,"Work Units");
                            case "Job Task"."Job Task Type" of
                                "Job Task"."Job Task Type"::Posting:
                                    SETRANGE("Job Task No.", "Job Task"."Job Task No.");
                                "Job Task"."Job Task Type"::Heading, "Job Task"."Job Task Type"::"Begin-Total":
                                    CurrReport.BREAK;
                                "Job Task"."Job Task Type"::Total, "Job Task"."Job Task Type"::"End-Total":
                                    SETFILTER("Job Task No.", "Job Task".Totaling);
                            end;
                            case BudgetAmountsPer of
                                BudgetAmountsPer::Schedule:
                                    SETFILTER("Line Type", '%1|%2', "Line Type"::Budget, "Line Type"::"Both Budget and Billable");
                                BudgetAmountsPer::Contract:
                                    SETFILTER("Line Type", '%1|%2', "Line Type"::Billable, "Line Type"::"Both Budget and Billable");
                            end;

                            if not ShowZeroQuantity then
                                SETFILTER(Quantity, '<>%1', 0);

                            SETFILTER("NS_Segment Code", SegmentCode);
                            SETFILTER("NS_Activity Code", ActivityCode);
                        end;
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480007; PADSTR('', 2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Task___Job_Task_No__; "Job Task"."Job Task No.")
                        {
                        }
                        column(Job_Task___Job_Task_Type__Control1020002; "Job Task"."Job Task Type")
                        {
                        }
                        column(Job_Task___New_Page_; "Job Task"."New Page")
                        {
                        }
                        column(PADSTR____2____Job_Task__Indentation_____Job_Task__Description_Control1480009; PADSTR('', 2 * "Job Task".Indentation) + "Job Task".Description)
                        {
                        }
                        column(Job_Task___Job_Task_No___Control1480010; "Job Task"."Job Task No.")
                        {
                        }
                        column(Job_Planning_Line___Total_Cost__LCY__; "Job Planning Line"."Total Cost (LCY)")
                        {
                        }
                        column(Job_Planning_Line___Total_Price__LCY__; "Job Planning Line"."Total Price (LCY)")
                        {
                        }
                        column(Integer_Number; Number)
                        {
                        }
                    }

                    trigger OnPreDataItem();
                    begin
                        SETRANGE("Job Task Type", "Job Task Type"::Posting);
                    end;
                }
            }

            trigger OnAfterGetRecord();
            begin
                CurrReport.PAGENO := 1;
                Title := STRSUBSTNO(Text000, "No.");
            end;

            trigger OnPreDataItem();
            begin
                if SortingOption = SortingOption::"Activity/Segment" then begin
                    ActivityFirst := true;
                    SortingOptionText := 'Sorted by Activity then Segement';
                end else begin
                    ActivityFirst := false;
                    SortingOptionText := 'Sorted by Segment then Activity';
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BudgetAmountsPer; BudgetAmountsPer)
                    {
                        Caption = 'Budget Amounts Per';
                        OptionCaption = 'Schedule,Contract';
                        ApplicationArea = All;
                    }
                    field("Task / Segment Sorting"; SortingOption)
                    {
                        Caption = 'Task / Segment Sorting';
                        ApplicationArea = All;
                    }
                    field("Show Zero Quantities"; ShowZeroQuantity)
                    {
                        ApplicationArea = All;
                    }
                    field("Activity Code"; ActivityCode)
                    {
                        ApplicationArea = All;

                        trigger OnLookup(VAr Text: Text): Boolean;
                        var
                            JobActivity: Record "NS_Job Activity";
                        begin
                            CLEAR(JobActivity);
                            if PAGE.RUNMODAL(14021159, JobActivity) = ACTION::LookupOK then
                                ActivityCode := JobActivity.NS_Code;
                        end;
                    }
                    field("Segment Code"; SegmentCode)
                    {
                        ApplicationArea = All;

                        trigger OnLookup(VAr Text: Text): Boolean;
                        var
                            TempJobSegment: Record "NS_Job Takeoff Segments" temporary;
                            JobSegment: Record "NS_Job Takeoff Segments";
                        begin
                            CLEAR(JobSegment);
                            CLEAR(TempJobSegment);

                            if JobSegment.FINDSET then begin
                                repeat
                                    TempJobSegment.RESET;
                                    TempJobSegment.SETRANGE("NS_Segment Code", JobSegment."NS_Segment Code");
                                    if not TempJobSegment.FINDFIRST then begin
                                        TempJobSegment := JobSegment;
                                        TempJobSegment.INSERT;
                                    end;
                                until JobSegment.NEXT = 0;
                            end;
                            TempJobSegment.RESET;
                            if PAGE.RUNMODAL(50009, TempJobSegment) = ACTION::LookupOK then
                                SegmentCode := TempJobSegment."NS_Segment Code";
                        end;
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

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        JobFilter := Job.GETFILTERS;
        if BudgetAmountsPer = BudgetAmountsPer::Schedule then
            BudgetOptionText := Text003
        else
            BudgetOptionText := Text004;
    end;

    var
        CompanyInformation: Record "Company Information";
        JobFilter: Text;
        Title: Text[100];
        Text000: Label 'Job Cost Budget for Job: %1';
        BudgetAmountsPer: Option Schedule,Contract;
        BudgetOptionText: Text[50];
        Text003: Label 'Budgeted Amounts are per the Schedule';
        Text004: Label 'Budgeted Amounts are per the Contract';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_DescriptionCaptionLbl: Label 'Job Description';
        PADSTR____2____Job_Task__Indentation_____Job_Task__DescriptionCaptionLbl: Label 'Job Task Description';
        SortingOption: Option "Activity/Segment","Segment/Activity";
        [InDataSet]
        ActivityFirst: Boolean;
        SortingOptionText: Text[50];
        ShowZeroQuantity: Boolean;
        SegmentName: Text[100];
        ActivityCode: Code[10];
        SegmentCode: Code[20];

    procedure GetItemDescription(Type: Option Resource,Item,"G/L Account"; No: Code[20]): Text[50];
    var
        Res: Record Resource;
        Item: Record Item;
        GLAcc: Record "G/L Account";
    begin
        case Type of
            Type::Resource:
                if Res.GET(No) then
                    exit(Res.Name);
            Type::Item:
                if Item.GET(No) then
                    exit(Item.Description);
            Type::"G/L Account":
                if GLAcc.GET(No) then
                    exit(GLAcc.Name);
        end;
        exit('');
    end;
}

