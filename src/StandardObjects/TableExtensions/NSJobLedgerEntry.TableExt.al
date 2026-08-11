tableextension 14021132 NS_JobLedgerEntry extends "Job Ledger Entry"
{
    // version NAVW111.00.00.24232,PPNA11.00
    //PRJ-9.SK.1.0 Added fields "Job Cost Category Tmp" , "Job Revenue Category Tmp","Activity Code","Process Code","Operation Code"
    //PRJ-301.AS.1.0 Increased length from 50 to 100 chars
    //TM-10.AM.1.0 | Added field.
    //PRJ-772.JS.1.0 26JULY2021 | field added
    //PRJ-817.JS.1.0 04Aug2021 | Add field work unit completed
    //PRJ-841.JS.1.0 16Aug2021 | field added skill code
    //PRJ-1015.JS.1.0 10Oct2021 | Add one field
    //PRJ-1571.NK.1.0 18Aug2022 | Add Code
    //PRJCTPR-2.RM.1.0 13Dec2022 | Added a new field
    fields
    {
        modify(Type)
        {
            OptionCaption = 'Resource,Item,G/L Account,Ledger';

            //Unsupported feature: Change OptionString on "Type(Field 5)". Please convert manually.

        }
        modify("Entry Type")
        {
            OptionCaption = 'Usage,Sale,Release,Earn,Payment';

            //Unsupported feature: Change OptionString on ""Entry Type"(Field 64)". Please convert manually.

        }
        field(14021101; "NS_Job Cost Category"; Code[10])
        {
            Caption = 'Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category";
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job Revenue Category"; Code[10])
        {
            Caption = 'Job Revenue Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Revenue Category";
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Work Units"; Decimal)
        {
            Caption = 'Work Units';
            DecimalPlaces = 2 : 2;
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Work Unit of Measure"; Code[10])
        {
            Caption = 'Work Unit of Measure';
            Description = 'ProjectPro';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(14021112; "NS_Burden Amount"; Decimal)
        {
            Caption = 'Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021113; "NS_Burden Type"; Option)
        {
            Caption = 'Burden Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Project,Service';
            OptionMembers = " ",Project,Service;
            DataClassification = CustomerContent;
        }
        field(14021114; "NS_Burden Amount Posted to G/L"; Decimal)
        {
            Caption = 'Burden Amount Posted to G/L';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021115; "NS_Burden Posting Document No."; Code[20])
        {
            Caption = 'Burden Posting Document No.';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021116; "NS_Burden Job Cost Category"; Code[10])
        {
            Caption = 'Burden Job Cost Category';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;
        }
        field(14021117; "NS_Burden Export"; Boolean)//CTSI-254
        {
            Caption = 'Burden Export';
            Description = 'Burden Export';
            DataClassification = CustomerContent;
        }
        field(14021120; "NS_External Relationship Type"; Option)
        {
            Caption = 'External Relationship Type';
            Description = 'ProjectPro';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(14021121; "NS_External Relationship No."; Code[20])
        {
            Caption = 'External Relationship No.';
            Description = 'ProjectPro';
            TableRelation = IF ("NS_External Relationship Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("NS_External Relationship Type" = CONST(Vendor)) Vendor."No.";
            DataClassification = CustomerContent;
        }
        field(14021122; "NS_External Relationship Name"; Text[100])	//PRJ-301.AS.1.0 Increased length from 50 to 100 chars
        {
            Caption = 'External Relationship Name';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021130; "NS_Payroll Burden Amount"; Decimal)
        {
            Caption = 'Payroll Burden Amount';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021134; "NS_Payroll Burden Job Cost Cat"; Code[10])
        {
            Caption = 'Payroll Burden Job Cost Cat';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Cost Category".NS_Code WHERE(NS_Type = CONST(Labor));
            DataClassification = CustomerContent;
        }
        field(14021135; "NS_Employee Wage Rate"; Decimal)
        {
            Caption = 'Employee Wage Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021136; "NS_Employee Fringe - Insurance"; Decimal)
        {
            Caption = 'Employee Fringe - Insurance';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021137; "NS_Employee Fringe - Vacation"; Decimal)
        {
            Caption = 'Employee Fringe - Vacation';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021138; "NS_Employee Fringe - Education"; Decimal)
        {
            Caption = 'Employee Fringe - Education';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021139; "NS_Employee Fringe - Misc. 1"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 1';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Employee Fringe - Misc. 2"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 2';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Employee Fringe - Misc. 3"; Decimal)
        {
            Caption = 'Employee Fringe - Misc. 3';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Employee Fringe Total"; Decimal)
        {
            Caption = 'Employee Fringe Total';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021143; "NS_Prevailing Wage Rate"; Decimal)
        {
            Caption = 'Prevailing Wage Rate';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
        }
        field(14021144; "NS_Prevailing Fringe Rate"; Decimal)
        {
            Caption = 'Prevailing Fringe Rate';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_Wage Calculation Basis"; Text[80])
        {
            Caption = 'Wage Calculation Basis';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021150; "NS_Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021186; "NS_Skill Class"; Code[10])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Skill Class";
            //PE-68 Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68 Dk.1.0 10April2023 End
        }
        //PE-68 Dk.1.0 10April2023 Start
        field(14021187; "NS_Skill Class New"; Code[20])
        {
            Caption = 'Skill Class';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            TableRelation = "NS_Skill Class";
        }
        //PE-68 Dk.1.0 10April2023 End
        field(14021300; "NS_Subcontract No."; Code[20])
        {
            Caption = 'Subcontract No.';
            Description = 'ProjectPro';
            TableRelation = NS_Subcontract;
            DataClassification = CustomerContent;
        }
        field(14021301; "NS_Retention Ledger Code"; Code[20])
        {
            Caption = 'Retention Ledger Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Retention Ledger Code".NS_Code;
            DataClassification = CustomerContent;
        }
        field(14021375; "NS_Payroll Work State"; Text[30])
        {
            Caption = 'Payroll Work State';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021376; "NS_Jobsite Work"; Boolean)
        {
            Caption = 'Jobsite Work';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021377; "NS_Job Cost Category Tmp"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Job Revenue Category';
        }

        //PRJ-9.SK.1.0 Start
        field(14021378; "NS_Job Revenue Category Tmp"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Job Revenue Category';
        }
        field(14021379; "NS_Activity Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Activity Code';
            CaptionClass = '50999,0,0'; //PRJ-1571.NK.1.0 18Aug2022
            Editable = false;
        }
        field(14021380; "NS_Process Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Process Code';
            CaptionClass = '50999,1,0'; //PRJ-1571.NK.1.0 18Aug2022
            Editable = false;
        }
        field(14021381; "NS_Operation Code"; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Operation Code';
            CaptionClass = '50999,2,0'; //PRJ-1571.NK.1.0 18Aug2022
            Editable = false;
        }
        //PRJ-9.SK.1.0 End
        //PRJ-688.AM.1.0
        field(14021384; "NS_Section Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Section Code';
            CaptionClass = '50999,3,0'; //PRJ-1571.NK.1.0 18Aug2022
            Editable = false;
        }
        //PRJ-688.AM.1.0
        field(14021382; "NS_Segment Code"; Code[20])
        {
            Caption = 'Segment Code';
            Editable = false;
            Description = 'TM-10.AM.1.0';
            DataClassification = CustomerContent;
        }
        field(14021383; "NS_FA Res.No."; Code[20])
        {
            Caption = 'FA Res. No.';
            Description = 'PRJ-490';
            DataClassification = CustomerContent;
        }
        field(14021385; "NS_Crew Time Sheet Line"; Boolean)      //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Time Sheet Line';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }

        field(14021386; "NS_Crew Code"; Code[20])               //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Code';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021387; "NS_Crew Name"; Text[50])               //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Name';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021388; "NS_Crew Time Sheet Ref. No."; Code[20])     //PRJ-772.JS.1.0 21JULY2021
        {
            Caption = 'Crew Time Sheet Ref. No.';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021389; "NS_Crew Time Unique Line ID"; Code[20])     //PRJ-772.JS.1.0 26JULY2021
        {
            Caption = 'Crew Time Unique Line ID';
            Description = 'ProjectPro';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021421; "NS_Work Unit Completed"; Decimal)     //PRJ-817.JS.1.0�04Aug2021
        {
            Caption = 'Work Unit Completed';
            DataClassification = CustomerContent;
            MinValue = 0;
            Editable = false;
        }
        field(14021422; "NS_Skill Code"; Code[10])   //PRJ-841.JS.1.0 04Aug2021
        {
            Caption = 'Skill Code';
            Editable = false;
            DataClassification = CustomerContent;
            //PE-68 Dk.1.0 10April2023 Start
            ObsoleteReason = 'Replace with New Field by increasing code length from 10 to 20';
            ObsoleteState = Pending;
            ObsoleteTag = 'This field will remove in ProjectPro upcoming build 22.0.XX.49984';
            //PE-68 Dk.1.0 10April2023 End

        }
        //PE-68 Dk.1.0 10April2023 Start
        field(14021424; "NS_Skill Code New"; Code[20])
        {
            Caption = 'Skill Code';
            Editable = false;
            DataClassification = CustomerContent;

        }
        //PE-68 Dk.1.0 10April2023 End

        field(14021423; "NS_Sub-Level to Job No."; Code[20])    //PRJ-1015.JS.1.0 10Oct2021
        {
            Caption = 'Sub-Level to Job No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Job;
        }
        //PRJ-1696.GK.1.0 15Dec2022 start
        field(14021426; "NS_Interim Entry"; Boolean)
        {
            Caption = 'Interim Entry';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021427; "NS_Accural Status"; Enum "NS_Accrual Status")
        {
            Caption = 'Accural Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021428; "NS_Receipt No."; Code[20])
        {
            Caption = 'Receipt No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021429; "NS_Receipt Line No."; Integer)
        {
            Caption = 'Receipt Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //PRJ-1696.GK.1.0 15Dec2022 end
        //PRJCTPR-2.RM.1.0 13Dec2022 start
        field(14021430; "NS_Union Code"; Code[10])
        {
            Caption = 'Union Code';
            DataClassification = CustomerContent;
            TableRelation = Union;
        }
        //PRJCTPR-2.RM.1.0 13Dec2022 end
    }

    trigger OnBeforeInsert();
    begin
        //ProjectPro - start
        NS_Job.NS_JobTaskNoToAPO("Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        NS_BurdenSettings;
        //ProjectPro - end
    end;

    trigger OnBeforeModify();
    begin
        //ProjectPro - start
        NS_Job.NS_JobTaskNoToAPO("Job Task No.", "NS_Activity Code", "NS_Process Code", "NS_Operation Code", "NS_Section Code");//PRJ-688.AM.1.0
        NS_BurdenSettings;
        NS_BurdenSettings;
        //ProjectPro - end
    end;

    var
        NS_Job: Record Job;
        Text14021100Lbl: Label '%1 in Job Setup can not be blank when using labor burdens.';

    PROCEDURE NS_BurdenSettings();
    VAR
        NS_GLSetup: Record 98;
        NS_JobsSetup: Record 315;
    BEGIN
        //ProjectPro - start
        NS_GLSetup.GET;
        NS_JobsSetup.GET;
        IF "NS_Burden Amount" <> 0 THEN
            IF "NS_Burden Job Cost Category" = '' THEN
                IF NS_JobsSetup."NS_Burden Job Cost Category" <> '' THEN
                    "NS_Burden Job Cost Category" := NS_JobsSetup."NS_Burden Job Cost Category"
                ELSE
                    ERROR(Text14021100Lbl, NS_JobsSetup.FIELDCAPTION("NS_Burden Job Cost Category"));
        IF "NS_Payroll Burden Amount" <> 0 THEN
            IF "NS_Payroll Burden Job Cost Cat" = '' THEN
                IF NS_JobsSetup."NS_Payroll Burden Job Cost Cat" <> '' THEN
                    "NS_Payroll Burden Job Cost Cat" := NS_JobsSetup."NS_Payroll Burden Job Cost Cat"
                ELSE
                    ERROR(Text14021100Lbl, NS_JobsSetup.FIELDCAPTION("NS_Payroll Burden Job Cost Cat"));
        //  "Total Cost" := ROUND("Unit Cost" * Quantity, NS_GLSetup."Appln. Rounding Precision") + "NS_Payroll Burden Amount" + "NS_Burden Amount";//PRJ-623.MS.1.0 Code comment
        //ProjectPro - end
    END;
    /*+---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021101 Job Cost Category          14021120 External Relationship Type    14021142 Employee Fringe Total
      +     14021102 Job Revenue Category        14021121 External Relationship No.    14021143 Prevailing Wage Rate
      +     14021107 Activity Code              14021122 External Relationship Name    14021144 Prevailing Fringe Rate
      +     14021108 Process Code                14021130 Payroll Burden Amount        14021145 Wage Calculation Basis
      +     14021109 Operation Code              14021134 Payroll Burden Job Cost Cat  14021150 Exclude Entry
      +     14021110 Work Units                  14021135 Employee Wage Rate            14021186 Skill Class
      +     14021111 Work Unit of Measure        14021136 Employee Fringe - Insurance  14021300 Subcontract No.
      +     14021112 Burden Amount              14021137 Employee Fringe - Vacation    14021301 Retention Ledger Code
      +     14021113 Burden Type                14021138 Employee Fringe - Education  14021375 Payroll Work State
      +     14021114 Burden Amount Posted to G/L14021139 Employee Fringe - Misc. 1    14021376 Jobsite Work
      +     14021115 Burden Posting Document No.14021140 Employee Fringe - Misc. 2
      +     14021116 Burden Job Cost Category    14021141 Employee Fringe - Misc. 3
      +
      +  - Added function(s):
      +     PP_BurdenSettings
      +
      +  - Added global variable(s):
      +     PP_Job
      +
      +  - Added global text constant(s):
      +     Text14021100
      +
      +  - Modification(s):
      +     - Added Keys:
      +         Job No.,Entry Type,Posting Date,Type,Global Dimension 1 Code,Global Dimension 2 Code,Job Cost Category,Job Revenue Category
      +         Job No.,Activity Code,Process Code,Operation Code,Job Cost Category,Entry Type,Posting Date
      +         Job No.,Activity Code,Process Code,Operation Code,Job Revenue Category,Entry Type,Posting Date
      +         Job No.,Entry Type,Type,Job Posting Group
      +         Job No.,Entry Type,Activity Code,Process Code,Operation Code,Job Cost Category,Job Revenue Category,Type,No.,Resource Group No.,Posting Date
      +         Ledger Entry Type,Ledger Entry No.
      +         Job No.,Activity Code,Process Code,Operation Code,Job Cost Category,Job Revenue Category,Type,No.,Resource Group No.,Posting Date
      +     - Modified Key
      +         Primary key - Added SumIndexField of Quantity
      +     - OnInsert added calls to
      +         Job.JobTaskNoToAPO
      +         PP_BurdenSettings
      +     - OnModify added calls to
      +         Job.JobTaskNoToAPO
      +         PP_BurdenSettings
      +     - Modify Fields
      +         Type - added Ledger to the end of the Optionstring
      +         Entry Type - added Release,Earn,Payment to the end of the OptionString
      +-----------------------------------------------------------------------------------------------*/
}

