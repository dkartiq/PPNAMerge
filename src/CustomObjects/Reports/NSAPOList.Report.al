report 14021150 "NS_APO List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1571.NK.1.0 18Aug2022 Add Code
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/NSAPO List.rdl';

    Caption = 'APO List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Type Loop"; "NS_Job Activity")
        {
            DataItemTableView = SORTING(NS_Type, NS_Code) ORDER(Ascending);
            RequestFilterFields = "NS_Code", NS_Description;
            column(Type_Loop_Type; NS_Type)
            {
                OptionCaption = 'Cost,Revenue';
            }
            column(Type_Loop_Code; NS_Code)
            {
            }
            column(ShowProcesses; ShowProcesses)
            {
            }
            column(ShowOperations; ShowOperations)
            {
            }
            dataitem("Job Activity"; "NS_Job Activity")
            {
                DataItemLink = NS_Type = FIELD(NS_Type);
                DataItemTableView = SORTING(NS_Type, NS_Code) ORDER(Ascending);
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(COMPANYNAME; COMPANYNAME)
                {
                }
                //PRJ-1571.NK.1.0 23Aug2022 Start
                column(JobActivity; JobActivity)
                {

                }
                column(JobProcess; JobProcess)
                {

                }
                column(JobOperation; JobOperation)
                {

                }
                //PRJ-1571.NK.1.0 23Aug2022 End
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(USERID; USERID)
                {
                }
                column(Job_Activity_Type; NS_Type)
                {
                }
                column(Job_Activity_Code; NS_Code)
                {
                }
                column(Job_Activity_Description; NS_Description)
                {
                }
                column(Job_Activity__Search_Code_; "NS_Search Code")
                {
                }
                column(APO_ListCaption; APO_ListCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Job_Activity_TypeCaption; FIELDCAPTION(NS_Type))
                {
                }
                column(Job_Activity_CodeCaption; Job_Activity_CodeCaptionLbl)
                {
                }
                column(Job_Activity_DescriptionCaption; FIELDCAPTION(NS_Description))
                {
                }
                column(Process_CodeCaption; Process_CodeCaptionLbl)
                {
                }
                column(Operation_CodeCaption; Operation_CodeCaptionLbl)
                {
                }
                column(Job_Activity__Search_Code_Caption; FIELDCAPTION("NS_Search Code"))
                {
                }
                dataitem("Job Process"; "NS_Job Process")
                {
                    DataItemLink = NS_Type = FIELD(NS_Type), "NS_Activity Code" = FIELD(NS_Code);
                    DataItemTableView = SORTING(NS_Type, "NS_Activity Code", NS_Code) ORDER(Ascending);
                    column(Job_Process_Type; NS_Type)
                    {
                    }
                    column(Job_Process__Activity_Code_; "NS_Activity Code")
                    {
                    }
                    column(Job_Process_Code; NS_Code)
                    {
                    }
                    column(Job_Process_Description; NS_Description)
                    {
                    }
                    column(Job_Process__Search_Code_; "NS_Search Code")
                    {
                    }
                    dataitem("<Job Operation>"; "NS_Job Operation")
                    {
                        DataItemLink = NS_Type = FIELD(NS_Type), "NS_Activity Code" = FIELD("NS_Activity Code"), "NS_Process Code" = FIELD(NS_Code);
                        DataItemTableView = SORTING(NS_Type, "NS_Activity Code", "NS_Process Code", NS_Code) ORDER(Ascending) WHERE(NS_Code = FILTER(<> ''));
                        PrintOnlyIfDetail = true;
                        column(Job_Operation__Type; NS_Type)
                        {
                        }
                        column(Job_Operation___Activity_Code_; "NS_Activity Code")
                        {
                        }
                        column(Job_Operation___Process_Code_; "NS_Process Code")
                        {
                        }
                        column(Job_Operation__Code; NS_Code)
                        {
                        }
                        column(Job_Operation__Description; NS_Description)
                        {
                        }
                        column(Job_Operation___Search_Code_; "NS_Search Code")
                        {
                        }
                    }
                }

                trigger OnPreDataItem();
                begin
                    COPYFILTERS("Type Loop");
                    SETRANGE(NS_Type, "Type Loop".NS_Type);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if (NS_Type = TypeHold) and (not FirstType) then
                    CurrReport.SKIP
                else begin
                    if not FirstType then
                        CurrReport.NEWPAGE
                    else
                        FirstType := false;
                    TypeHold := NS_Type;
                end;
            end;

            trigger OnPreDataItem();
            begin
                CLEAR(TypeHold);
                FirstType := true;
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1101239001)
                {
                    field(ShowProcesses; ShowProcesses)
                    {
                        ApplicationArea = All;
                        CaptionClass = '50995,1,0'; //PRJ-1571.NK.1.0 18Aug2022
                    }
                    field(ShowOperations; ShowOperations)
                    {
                        ApplicationArea = All;
                        CaptionClass = '50995,2,0'; //PRJ-1571.NK.1.0 18Aug2022
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
    //PRJ-1571.NK.1.0 23Aug2022 Start
    trigger OnPreReport()
    var
        ApoSetup: Record NS_APOSetup;
        JobsSetup: Record "Jobs Setup";
    begin
        JobActivity := '';
        JobProcess := '';
        JobOperation := '';
        if JobsSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if ApoSetup.Get() then; //PRJ-1348.NK.1.0 08Sep2022
        if JobsSetup."NS_Activate Task Pick List" then begin
            JobActivity := ApoSetup."Activity Code";
            JobProcess := ApoSetup."Process Code";
            JobOperation := ApoSetup."Operation Code";
        end else begin
            JobActivity := 'Activity Code';
            JobProcess := 'Process Code';
            JobOperation := 'Operation Code';
        end;
        //PRJ-1348.NK.1.0 12Jul2022 End
    end;
    //PRJ-1571.NK.1.0 23Aug2022 End

    var
        TypeHold: Option;
        FirstType: Boolean;
        ShowProcesses: Boolean;
        ShowOperations: Boolean;
        APO_ListCaptionLbl: Label 'APO List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Job_Activity_CodeCaptionLbl: Label 'Activity Code';
        Process_CodeCaptionLbl: Label 'Process Code';
        Operation_CodeCaptionLbl: Label 'Operation Code';
        JobActivity: Text; //PRJ-1571.NK.1.0 23Aug2022
        JobProcess: Text; //PRJ-1571.NK.1.0 23Aug2022
        JobOperation: Text; //PRJ-1571.NK.1.0 23Aug2022
}

