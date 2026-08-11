tableextension 14021241 NS_UserSetupext extends "User Setup"
{
    //JD-54.AM.1.0 Created new Table Ext to extend User setup Table & added a new field.
    //CTSI-274.AM.1.0 Added new field.
    //CTSI-254.AM.1.0 Added New Field
    //PRJ-626.GK.1.0 30Aug2021 |Added caption of fields
    //PRJ-975.GK.1.0 21Oct2021 |Add new field.
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
            Caption = 'Access To Rev.Recognition Report';
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


    }

    var
        myInt: Integer;
}