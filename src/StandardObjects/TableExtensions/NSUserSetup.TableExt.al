tableextension 14021241 NS_UserSetupext extends "User Setup"
{
    //JD-54.AM.1.0 Created new Table Ext to extend User setup Table & added a new field.
    //CTSI-274.AM.1.0 Added new field.
    //CTSI-254.AM.1.0 Added New Field
    //PRJ-626.GK.1.0 30Aug2021 |Added caption of fields
    //PRJ-975.GK.1.0 21Oct2021 |Add new field.
    //PRJ-917.NK.1.0 09Mar2022 | Add One field.
    //PE-19.RM.1.0 09Feb2023 | Added a new field
    // PRJCTPR-191.HS.1.0 7Nov2023| Add Caption
    fields
    {
        field(14021100; "NS_Unlock DFR"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        //CTSI-274.AM.1.0 start
        field(14021149; "NS_AccessTo Rev.RecognitionReport"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Access to Revenue Recognition Report'; //Caption = 'Access To Rev.Recognition Report'; //PE-295.DK.1.0 change caption "Access To Rev.Recognition Report" to "Access to Revenue Recognition Report"
        }
        //CTSI-274.AM.1.0 End
        field(14021150; "NS_Job Locked"; Boolean)
        {
            Caption = 'Job Locked';
            Description = 'CTSI-172.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021152; "NS_Allow Forecast Deletion"; Boolean)
        {
            Caption = 'Allow Forecast Deletion';
            Description = 'CTSI-207.MS.1.0';
            DataClassification = CustomerContent;
        }
        field(14021153; "NS_Modify Project Summary Details"; Boolean)
        {
            Caption = 'Modify Project Summary Details';//PRJ-626.GK.1.0 30Aug2021
            Description = '//PRJ-585.AS.1.0 16MARCH2021';
            DataClassification = CustomerContent;
        }
        //CTSI-254.AM
        field(14021154; "NS_Access to Job Burden Allocation Batch"; Boolean)
        {
            Caption = 'Access to Job Burden Allocation Batch';//PRJ-626.GK.1.0 30Aug2021
            DataClassification = CustomerContent;
        }
        //CTSI-254.AM 
        field(14021155; "NS_Overwrite JFW Date Setup"; Boolean)
        {
            Caption = 'Overwrite JFW Date Setup';//PRJ-626.GK.1.0 30Aug2021
            DataClassification = CustomerContent;
            Description = 'CTSI-268';
        }
        field(14021156; "NS_Modify Revenue Recognized Job"; Boolean)
        {
            Caption = 'Modify Revenue Recognized Job';//PRJ-626.GK.1.0 30Aug2021
            DataClassification = CustomerContent;
            Description = 'CTSI-285';
        }
        //PRJ-975.GK.1.0 21Oct2021 start
        field(14021157; "NS_Enable Lien Release Print"; Boolean)
        {
            Caption = 'Enable Lien Release Print';
            DataClassification = CustomerContent;
            Description = 'PRJ-975';
        }
        //PRJ-975.GK.1.0 21Oct2021 end
        //PRJ-917.NK.1.0 09Mar2022 Start 
        field(14021160; "NS_Allow To Block APO"; Boolean)
        {
            Caption = 'Allow To Block APO';
            DataClassification = CustomerContent;
            Description = 'PRJ-917';
        }
        //PRJ-917.NK.1.0 09Mar2022 End

        //PRJ-1405.AS.1.0 02MAY2022 START
        field(14021161; "NS_Force change work UOM"; Boolean)
        {
            Caption = 'Force change work UOM';
            Description = 'Force change work UOM';
            DataClassification = CustomerContent;
        }
        //PRJ-1405.AS.1.0 02MAY2022 END
        //PE-19.RM.1.0 09Feb2023 Start
        field(14021162; "NS_Allow CPR functionality"; Boolean)
        {
            Caption = 'Allow CPR Functionality';
            Description = 'Allow User Certified Payroll Report functionality';
            DataClassification = CustomerContent;
        }
        //PE-19.RM.1.0 09Feb2023 End

        //PRJCTPR-93.PS.1.0 10April2023 Start

        field(14021163; "NS_JMP Template WKS. Name"; Code[10])
        {
            Caption = 'JMP Template Worksheet Name';
            Description = 'JMP Batch  Worksheet Name ';
            DataClassification = CustomerContent;
            // TableRelation = "Requisition Wksh. Name"."Worksheet Template Name"; //PRJCTPR-205.PS.1.0 05OCT2023 Commented
            TableRelation = "Req. Wksh. Template".Name; //PRJCTPR-205.PS.1.0 05OCT2023
        }

        field(14021164; "NS_JMP Batch Name"; Code[10])
        {
            Caption = 'JMP Batch Name';
            Description = 'JMP Batch Name ';
            DataClassification = CustomerContent;
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("NS_JMP Template WKS. Name"));
        }
        field(14021165; "NS_Req JMP Doc. No."; Code[20])
        {
            Caption = 'Req JMP Doc. No.';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
            Editable = false;
        }

        //PRJCTPR-93.PS.1.0 10April2023 End 
        //PRJCTPR-180.AS.1.0 28Aug2023 start
        field(14021166; "NS_AllowDelPrgBilllines"; Boolean)
        {
            // Caption = 'Allow deletion of Progress Bill lines from table';  PRJCTPR-191.HS.1.0 7Nov2023 Commented
            Caption = 'Access to Remove Progress Billing No. '; //PRJCTPR-191.HS.1.0 7Nov2023
            Description = 'Allow deletion of Progress Bill lines from table';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-180.AS.1.0 28Aug2023 end

        //PRJCTPR-147.PS.2.0 20Sep2023 Start
        field(14021167; "NS_Allow to Acc Manager Status"; Boolean)
        {
            Caption = 'Modify Project''s Manager Status';//Caption = 'Allow to Access Manager Status'; //PRJCTPR-395.DK.1.0 27June2024
            Description = 'Allow to access Manager Status';
            DataClassification = CustomerContent;
        }
        //PRJCTPR-147.PS.2.0 20Sep2023 End
        //PE-177.DK.1.0 10Nov2023 Start
        field(14021168; "NS_Allow Repot Stat on SubCon"; Boolean)
        {
            Caption = 'Allow Access to Reporting Status on SubContract';
            Description = 'Allow Access to Reporting Status on SubContract';
            DataClassification = CustomerContent;
        }
        //PE-177.DK.1.0 10Nov23 End

        //PE-200.AS.9.0 START
        field(14021169; "NS_Allow PayWhenPaid"; Boolean)
        {
            Caption = 'Allow Pay When Paid';
            Description = 'Allow Pay When Paid';
            DataClassification = CustomerContent;
        }
        field(14021170; "NS_AllowDrawNoChange"; Boolean)
        {
            Caption = 'Allow Draw No. Change';
            Description = 'Allow Draw No. Change';
            DataClassification = CustomerContent;
        }
        //PE-200.AS.9.0 END

        //PE-253.PS.1.0 15feb2024 Start

        field(14021171; "NS_Allow posting Job Journal"; Boolean)
        {
            Caption = 'Allow Submittal of Job Work Units.';
            Description = 'Allow Submittal of Job Work Units.';
            DataClassification = CustomerContent;
        }
        //PE-253.PS.1.0 15feb2024 End

        //PE-296.DK.1.0 30May2024 Start 
        field(14021173; "NS_Allow PPLicence Activation"; Boolean)
        {
            Caption = 'Allow admin rights for ProjectPro Licence Activation';
            DataClassification = CustomerContent;
        }
        //PE-296.DK.1.0 30May2024 End
        //PE-312.JS.1.0 11Jun2024-Start
        field(14021288; "NS_Allow NegEst. Cost2Complete"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Negative Est. Cost to Complete on JFW';
        }
        //PE-312.JS.1.0 11Jun2024-end
        //PE-295.JS.1.0 11Jun2024-Start
        field(14021289; "NS_Allow To Delete Rev. Rec"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Rev. Rec. Entries Deletion';
        }
        //PE-295.JS.1.0 11Jun2024-end 
    }

    var
        myInt: Integer;
}