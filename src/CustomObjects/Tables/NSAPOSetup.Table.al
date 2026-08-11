table 14021493 NS_APOSetup
//PRJ-1348.NK.1.0 24May2022 New Table Create
//PE-92.RM.1.0 27May2023 | Added some code
{
    DataClassification = ToBeClassified;
    Caption = 'APOS Setup';
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Activity Code"; Text[20])
        {
            Caption = 'Activity Code';
            DataClassification = CustomerContent;
            TableRelation = NS_APOCaptionMaster.NS_Code where(NS_Type = filter(Activity));
        }
        field(3; "Process Code"; Text[20])
        {
            Caption = 'Process Code';
            DataClassification = CustomerContent;
            TableRelation = NS_APOCaptionMaster.NS_Code where(NS_Type = filter(Process));
        }
        field(4; "Operation Code"; Text[20])
        {
            Caption = 'Operation Code';
            DataClassification = CustomerContent;
            TableRelation = NS_APOCaptionMaster.NS_Code where(NS_Type = filter(Operation));
        }
        field(5; "Section Code"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Section Code';
            TableRelation = NS_APOCaptionMaster.NS_Code where(NS_Type = filter(Section));
        }
        //PE-92.RM.1.0 23May2023 Start
        field(6; "NS_User task Alert No. of Days"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'User Task Alert No. of Days';
        }

        //PE-92.RM.1.0 23May2023 end
        //PE-185.NC.1.0 10Oct2023 Start
        field(7; "NS_EnableUserTaskCategory"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable User Task Category';
        }
        //PE-185.NC.1.0 10Oct2023 End
        //PE-168.JS.1.0 04DEC2023 Start
        field(36; "NS_Temperature Measuring Scale"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Celsius,Fahrenheit;
            caption = 'Temperature Measuring Scale';
        }
        //PE-168.JS.1.0 04DEC2023 end
        //PRJCTPR-275.PS.1.0 22Dec2023 Start
        field(14021100; "NS_Job Daliy Log Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
            Caption = 'Job Daily Log Doc. No.';   //PRJCTPR-235.JS.1.0 23JAN2024
        }
        //PRJCTPR-275.PS.1.0 22Dec2023 End
        //PE-288.JS.1.0 06MAY2024-Start
        field(14021105; "NS_PunchList No."; code[20])
        {
            DataClassification = CustomerContent;
            caption = 'Punch List No.';
            TableRelation = "No. Series";
        }
        //PE-288.JS.1.0 06MAY2024-end
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}