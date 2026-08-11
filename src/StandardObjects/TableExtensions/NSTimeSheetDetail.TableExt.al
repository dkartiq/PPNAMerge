tableextension 14021212 NS_TimeSheetDetail extends "Time Sheet Detail"
{
    // version NAVW111.00,PPNA11.00
    //PRJ-841.JS.1.0 19Aug2021 | field Added
    //PRJ-842.JS.1.0 19Aug2021 | field Added 

    fields
    {
        modify(Date)
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if Date <> xRec.Date then begin
                    NS_TimeSheetHeader.GET("Time Sheet No.");
                    if (Date < NS_TimeSheetHeader."Starting Date") or
                        (Date > NS_TimeSheetHeader."Ending Date") then
                        ERROR(Text14021100, NS_TimeSheetHeader."Starting Date", NS_TimeSheetHeader."Ending Date");
                    NS_EmployeeWageRate.CalculateWagesTimeSheetDetail(Rec);
                    "NS_Burden Amount to Post" := NS_EmployeeBurdenDetail.NS_CalculateBurden("Resource No.", "NS_Wage Rate to Post", Quantity, Date);
                end;
                //ProjectPro - end
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate();
            begin
                //ProjectPro - start
                if Quantity <> xRec.Quantity then begin
                    if Quantity < "Posted Quantity" then
                        if not CONFIRM(Text14021101, true, FIELDCAPTION(Quantity), FIELDCAPTION("Posted Quantity")) then
                            ERROR(Text14021102, FIELDCAPTION(Quantity));
                    NS_EmployeeWageRate.CalculateWagesTimeSheetDetail(Rec);
                    "NS_Burden Amount to Post" := NS_EmployeeBurdenDetail.NS_CalculateBurden("Resource No.", "NS_Wage Rate to Post", Quantity, Date);
                end;
                //ProjectPro - end
            end;
        }

        field(14021100; "NS_Rate toPostCalculationBasis"; Text[80])
        {
            Caption = 'Rate to Post Calculation Basis';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Wage Rate to Post"; Decimal)
        {
            Caption = 'Wage Rate to Post';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Wage Rate to Post" <> xRec."NS_Wage Rate to Post" then begin
                    "NS_Rate toPostCalculationBasis" := Text14021103;
                    "NS_Burden Amount to Post" := NS_EmployeeBurdenDetail.NS_CalculateBurden("Resource No.", "NS_Wage Rate to Post", Quantity, Date);
                end;
                //ProjectPro - end
            end;
        }
        field(14021104; "NS_Fringe Rate to Post"; Decimal)
        {
            Caption = 'Fringe Rate to Post';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                //ProjectPro - start
                if "NS_Fringe Rate to Post" <> xRec."NS_Fringe Rate to Post" then
                    "NS_Rate toPostCalculationBasis" := Text14021103;
                //ProjectPro - end
            end;
        }
        field(14021105; "NS_Employee Wage Rate"; Decimal)
        {
            Caption = 'Employee Wage Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Employee Fringe - Insurance"; Decimal)
        {
            Caption = 'Employee Fringe - Insurance';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021107; "NS_Employee Fringe - Vacation"; Decimal)
        {
            Caption = 'Employee Fringe - Vacation';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021108; "NS_Employee Fringe - Education"; Decimal)
        {
            Caption = 'Employee Fringe - Education';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021109; "NS_Employee Fringe - Misc. 1"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 1';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Employee Fringe - Misc. 2"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 2';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Employee Fringe - Misc. 3"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 3';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Employee Fringe Total"; Decimal)
        {
            Caption = 'Employee Fringe Total';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021113; "NS_Prevailing Wage Rate"; Decimal)
        {
            Caption = 'Prevailing Wage Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021114; "NS_Prevailing Fringe Rate"; Decimal)
        {
            Caption = 'Prevailing Fringe Rate';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021130; "NS_Burden Amount to Post"; Decimal)
        {
            Caption = 'Burden Amount to Post';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }

        field(14021131; "NS_CrewTimeSheetLine"; Boolean)//PRJ-772.2.0
        {
            Caption = 'Crew TimeSheet Line';
            Description = 'Crew TimeSheet Line';
            DataClassification = CustomerContent;
        }

        field(14021132; "NS_Description"; text[100])//PRJ-772.2.0
        {
            Caption = 'Description';
            Description = 'CDescription';
            DataClassification = CustomerContent;
        }
        field(14021133; "NS_Crew Code"; Code[20])//PRJ-772.2.0
        {
            Caption = 'Crew Code';
            Description = 'Crew Code';
            editable = false;
            TableRelation = NS_Crew.NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021134; "NS_Crew Time Unique Line ID"; Code[20])  //PRJ-639.JS.1.0�26July2021
        {
            Caption = 'Crew Time Unique Line ID';
            Description = 'Specifies Crew time unique line ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021135; "NS_TimeSheetCrewWorkDays"; integer)
        {
            Caption = 'Time Sheet Work Days';
            Description = 'Specifies Time Sheet Work Days';
            MaxValue = 7;
            MinValue = 1;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021136; "NS_Crew Time Sheet Ref. No."; Code[20])
        {
            Caption = 'Crew Time Sheet Ref. No.';
            Description = 'Specifies Crew Time Sheet Ref. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021137; "NS_Work Type Code"; Code[10])
        {
            Caption = 'Work Type';
            TableRelation = "Work Type";
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Crew Time Sheet Date"; Date)
        {
            Caption = 'Crew Time Sheet Date';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021139; "NS_Skill Code"; Code[10])   //PRJ-841.JS.1.0 19Aug2021
        {
            Caption = 'Skill Code';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(14021140; "NS_Segment Code"; Code[20])    //PRJ-842.JS.1.0 19Aug2021
        {
            Caption = 'Segment Code';
            TableRelation = "NS_Job Takeoff Segments"."NS_Segment Code" WHERE("NS_Job No." = FIELD("Job No."));
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(14021141; "NS_Work Description"; Text[100])    //PRJ-842.JS.1.0 16Aug2021
        {
            Caption = 'Work Description';
            Editable = false;
            DataClassification = CustomerContent;
        }

    }


    var
        NS_TimeSheetHeader: Record "Time Sheet Header";
        Text14021100: Label 'The date must fall in the range from %1 to %2.';
        Text14021101: Label 'The %1 is less than the %2.\Are you sure you want to post a negative adjustment?';
        Text14021102: Label 'The %1 has been reset.';
        Text14021103: Label 'User entered rates.';
        Text14021104: Label 'System calculated based on Employee Rates.';
        Text14021105: Label 'System calculated based on Prevailing Rates.';
        Text14021106: Label 'System calculated, wage rate based on Prevailing Rate';
        Text14021107: Label 'System calculated, wage rate based on Employee Rate';
        Text14021108: Label ', with Fringe adjustment';
        Text14021109: Label ', no Fringe adjustment';
        Text14021110: Label '%1 entries cannot be deleted.';
        NS_Employee: Record Employee;
        NS_EmployeeBurdenDetail: Record "NS_Employee Burden Detail";
        NS_EmployeeWageRate: Record "NS_Employee Wage Rate";

    PROCEDURE NS_CalculateWages();
    VAR
        NS_EmployeeWageRate: Record "NS_Employee Wage Rate";
        NS_TimeSheetLine: Record 951;
        NS_JobResourcePrice: Record 1012;
        NS_Resource: Record 156;
    BEGIN
        //ProjectPro - start
        IF Quantity <> 0 THEN
            IF Type <> Type::Absence THEN
                IF NS_TimeSheetLine.GET("Time Sheet No.", "Time Sheet Line No.") THEN BEGIN
                    //Get Employee Card Wage Rates
                    NS_Employee.RESET;
                    NS_Employee.SETCURRENTKEY("Resource No.");
                    NS_Employee.SETRANGE("Resource No.", "Resource No.");
                    IF NS_Employee.FINDFIRST THEN BEGIN
                        //Match on Skill Class,Work Type Code,Effective Date
                        NS_EmployeeWageRate.RESET;
                        NS_EmployeeWageRate.SETCURRENTKEY("NS_Skill Class", "NS_Work Type Code", "NS_Effective Date");
                        NS_EmployeeWageRate.SETRANGE("NS_Employee No.", NS_Employee."No.");
                        NS_EmployeeWageRate.SETRANGE("NS_Skill Class", NS_TimeSheetLine."NS_Skill Class");
                        NS_EmployeeWageRate.SETRANGE("NS_Work Type Code", NS_TimeSheetLine."Work Type Code");
                        NS_EmployeeWageRate.SETFILTER("NS_Effective Date", '..%1', Date);
                        IF NS_EmployeeWageRate.FINDLAST THEN BEGIN
                            "NS_Employee Wage Rate" := NS_EmployeeWageRate."NS_Wage Rate";
                            "NS_Employee Fringe - Insurance" := NS_EmployeeWageRate."NS_Fringe - Insurance";
                            "NS_Employee Fringe - Vacation" := NS_EmployeeWageRate."NS_Fringe - Vacation Time";
                            "NS_Employee Fringe - Education" := NS_EmployeeWageRate."NS_Fringe - Education";
                            "NS_Employee Fringe - Misc. 1" := NS_EmployeeWageRate."NS_Fringe - Misc. 1";
                            "NS_Employee Fringe - Misc. 2" := NS_EmployeeWageRate."NS_Fringe - Misc. 2";
                            "NS_Employee Fringe - Misc. 3" := NS_EmployeeWageRate."NS_Fringe - Misc. 3";
                            "NS_Employee Fringe Total" := NS_EmployeeWageRate."NS_Fringe Total";
                        END ELSE BEGIN
                            //Match on Skill Class=<blank>,Work Type Code,Effective Date
                            NS_EmployeeWageRate.SETRANGE("NS_Skill Class", '');
                            IF NS_EmployeeWageRate.FINDFIRST THEN BEGIN
                                "NS_Employee Wage Rate" := NS_EmployeeWageRate."NS_Wage Rate";
                                "NS_Employee Fringe - Insurance" := NS_EmployeeWageRate."NS_Fringe - Insurance";
                                "NS_Employee Fringe - Vacation" := NS_EmployeeWageRate."NS_Fringe - Vacation Time";
                                "NS_Employee Fringe - Education" := NS_EmployeeWageRate."NS_Fringe - Education";
                                "NS_Employee Fringe - Misc. 1" := NS_EmployeeWageRate."NS_Fringe - Misc. 1";
                                "NS_Employee Fringe - Misc. 2" := NS_EmployeeWageRate."NS_Fringe - Misc. 2";
                                "NS_Employee Fringe - Misc. 3" := NS_EmployeeWageRate."NS_Fringe - Misc. 3";
                                "NS_Employee Fringe Total" := NS_EmployeeWageRate."NS_Fringe Total";
                            END;
                        END;
                    END;
                    //Get Job Resource Costs
                    IF Type = Type::Job THEN BEGIN
                        //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                        NS_JobResourcePrice.RESET;
                        NS_JobResourcePrice.SETRANGE("Job No.", "Job No.");
                        NS_JobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                        NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::Resource);
                        NS_JobResourcePrice.SETRANGE(Code, "Resource No.");
                        NS_JobResourcePrice.SETRANGE("Work Type Code", NS_TimeSheetLine."Work Type Code");
                        NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", NS_TimeSheetLine."NS_Skill Class");
                        IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                            "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                            "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                        END ELSE BEGIN
                            //Match on Job Task No.,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                            NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                            IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                            END ELSE BEGIN
                                //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code
                                NS_JobResourcePrice.SETRANGE("Job Task No.", '');
                                NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", NS_TimeSheetLine."NS_Skill Class");
                                IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                    "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                    "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                END ELSE BEGIN
                                    //Match on Job Task No.=<blank>,Type=Resource,Code=Resource No.,Work Type Code,Skill Class Code=<blank>
                                    NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                    IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                        "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                        "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                    END ELSE BEGIN
                                        IF NS_Resource.GET("Resource No.") THEN
                                            IF NS_Resource."Resource Group No." <> '' THEN BEGIN
                                                //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                                NS_JobResourcePrice.SETRANGE("Job Task No.", "Job Task No.");
                                                NS_JobResourcePrice.SETRANGE(Type, NS_JobResourcePrice.Type::"Group(Resource)");
                                                NS_JobResourcePrice.SETRANGE(Code, NS_Resource."Resource Group No.");
                                                NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", NS_TimeSheetLine."NS_Skill Class");
                                                IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                                    "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                                    "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                                END ELSE BEGIN
                                                    //Match on Job Task No.,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                    NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                                    IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                                        "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                                        "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                                    END ELSE BEGIN
                                                        //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code
                                                        NS_JobResourcePrice.SETRANGE("Job Task No.", '');
                                                        NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", NS_TimeSheetLine."NS_Skill Class");
                                                        IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                                            "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                                            "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                                        END ELSE BEGIN
                                                            //Match on Job Task No.=<blank>,Type=Group(Resource),Code=Resource Group No.,Work Type Code,Skill Class Code=<blank>
                                                            NS_JobResourcePrice.SETRANGE("NS_Skill Class Code", '');
                                                            IF NS_JobResourcePrice.FINDFIRST THEN BEGIN
                                                                "NS_Prevailing Wage Rate" := NS_JobResourcePrice."NS_Skill Rate";
                                                                "NS_Prevailing Fringe Rate" := NS_JobResourcePrice."NS_Fringe Rate";
                                                            END;
                                                        END;
                                                    END;
                                                END;
                                            END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    //Set Wage Rate to Post and Fringe Rate to Post
                    IF ("NS_Prevailing Wage Rate" = 0) AND ("NS_Employee Wage Rate" = 0) THEN BEGIN
                        "NS_Wage Rate to Post" := 0;
                        "NS_Fringe Rate to Post" := 0;
                        "NS_Rate toPostCalculationBasis" := '';
                    END ELSE BEGIN
                        IF ("NS_Prevailing Wage Rate" = 0) AND ("NS_Employee Wage Rate" <> 0) THEN BEGIN
                            "NS_Wage Rate to Post" := "NS_Employee Wage Rate";
                            "NS_Fringe Rate to Post" := "NS_Employee Fringe Total";
                            "NS_Rate toPostCalculationBasis" := Text14021104;
                        END ELSE BEGIN
                            IF ("NS_Employee Wage Rate" = 0) AND ("NS_Prevailing Wage Rate" <> 0) THEN BEGIN
                                "NS_Wage Rate to Post" := "NS_Prevailing Wage Rate";
                                "NS_Fringe Rate to Post" := "NS_Prevailing Fringe Rate";
                                "NS_Rate toPostCalculationBasis" := Text14021105;
                            END ELSE BEGIN
                                IF "NS_Prevailing Wage Rate" >= "NS_Employee Wage Rate" THEN BEGIN
                                    "NS_Wage Rate to Post" := "NS_Prevailing Wage Rate";
                                    "NS_Rate toPostCalculationBasis" := Text14021106;
                                    IF ("NS_Employee Wage Rate" + "NS_Employee Fringe Total") > ("NS_Prevailing Wage Rate" + "NS_Prevailing Fringe Rate") THEN BEGIN
                                        "NS_Fringe Rate to Post" := ("NS_Employee Wage Rate" + "NS_Employee Fringe Total") - "NS_Wage Rate to Post";
                                        "NS_Rate toPostCalculationBasis" := "NS_Rate toPostCalculationBasis" + Text14021108;
                                    END ELSE BEGIN
                                        "NS_Fringe Rate to Post" := "NS_Prevailing Fringe Rate";
                                        "NS_Rate toPostCalculationBasis" := "NS_Rate toPostCalculationBasis" + Text14021109;
                                    END;
                                END ELSE BEGIN
                                    "NS_Wage Rate to Post" := "NS_Employee Wage Rate";
                                    "NS_Rate toPostCalculationBasis" := Text14021107;
                                    IF ("NS_Prevailing Wage Rate" + "NS_Prevailing Fringe Rate") > ("NS_Employee Wage Rate" + "NS_Employee Fringe Total") THEN BEGIN
                                        "NS_Fringe Rate to Post" := ("NS_Prevailing Wage Rate" + "NS_Prevailing Fringe Rate") - "NS_Wage Rate to Post";
                                        "NS_Rate toPostCalculationBasis" := "NS_Rate toPostCalculationBasis" + Text14021108;
                                    END ELSE BEGIN
                                        "NS_Fringe Rate to Post" := "NS_Employee Fringe Total";
                                        "NS_Rate toPostCalculationBasis" := "NS_Rate toPostCalculationBasis" + Text14021109;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    //Set Burden Amount to Post
                    NS_CalculateBurden;
                END;
        //ProjectPro - end
    END;

    PROCEDURE NS_CalculateBurden();
    VAR
        NS_EmployeeBurdenDetail: Record "NS_Employee Burden Detail";
    BEGIN
        //ProjectPro - start
        IF "NS_Wage Rate to Post" <> 0 THEN BEGIN
            NS_Employee.RESET;
            NS_Employee.SETCURRENTKEY("Resource No.");
            NS_Employee.SETRANGE("Resource No.", "Resource No.");
            IF NS_Employee.FINDFIRST THEN BEGIN
                "NS_Burden Amount to Post" := 0;
                NS_EmployeeBurdenDetail.RESET;
                NS_EmployeeBurdenDetail.SETRANGE("NS_Employee No.", NS_Employee."No.");
                IF NS_EmployeeBurdenDetail.FINDSET THEN
                    REPEAT
                        IF NS_EmployeeBurdenDetail."NS_Burden Rate Type" = NS_EmployeeBurdenDetail."NS_Burden Rate Type"::"Flat Rate" THEN
                            "NS_Burden Amount to Post" += NS_EmployeeBurdenDetail."NS_Burden Rate per Hour" * Quantity
                        ELSE
                            "NS_Burden Amount to Post" += ((NS_EmployeeBurdenDetail."NS_Burden Rate per Hour" / 100) * ("NS_Wage Rate to Post" * Quantity));
                    UNTIL NS_EmployeeBurdenDetail.NEXT = 0;
            END;
        END;
        //ProjectPro - end
    END;
    /* +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021100 Rate to Post Calculation Basis
      +     14021103 Wage Rate to Post
      +     14021104 Fringe Rate to Post
      +     14021105 Employee Wage Rate
      +     14021106 Employee Fringe - Insurance
      +     14021107 Employee Fringe - Vacation
      +     14021108 Employee Fringe - Education
      +     14021109 Employee Fringe - Misc. 1
      +     14021110 Employee Fringe - Misc. 2
      +     14021111 Employee Fringe - Misc. 3
      +     14021112 Employee Fringe Total
      +     14021113 Prevailing Wage Rate
      +     14021114 Prevailing Fringe Rate
      +     14021130 Burden Amount to Post
      +
      +  - Added function(s):
      +     PP_CalculateWages
      +     PP_CalculateBurden
      +
      +  - Added global variable(s):
      +     PP_TimeSheetHeader
      +     PP_Employee
      +     PP_EmployeeBurdenDetail
      +     PP_EmployeeWageRate
      +
      +  - Added global text constant(s):
      +     Text14021100
      +     Text14021101
      +     Text14021102
      +     Text14021103
      +     Text14021104
      +     Text14021105
      +     Text14021106
      +     Text14021107
      +     Text14021108
      +     Text14021109
      +     Text14021110
      +
      +  - Modification(s):
      +     - OnDelete:  Do not allow Posted entries to be deleted
      +     - Fields
      +         Quantity - Editable=Yes
      +         Date     - OnValidate - Date entered must be within Starting-Ending Date range in Time Sheet Header including calls to
      +                                     CalculateWagesTimeSheetDetail
      +                                     CalculateBurden
      +         Quantity - OnValidate() - Confirm a negative adjustment entered including calls to
      +                                     CalculateWagesTimeSheetDetail
      +                                     CalculateBurden
      +                  - Editable=Yes
      +     - CopyFromTimeSheetLine: Added Resource No.
      +-----------------------------------------------------------------------------------------------*/
}

