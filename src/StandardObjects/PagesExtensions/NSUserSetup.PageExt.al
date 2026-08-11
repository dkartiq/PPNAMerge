pageextension 14021141 NS_UserSetup extends "User Setup"
{
    // version NAVW111.00,PPNA11.00
    //JD-54.AM.1.0 Added Field on page .
    //CTSI-274.AM.1.0 Added new field
    //CTSI-254.AM.1.0 Added New Field.
    //PRJ-975.GK.1.0 21Oct2021 |Add new field.
    //PRJ-917.NK.1.0 09Mar2022 | Add One field.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    //PRJ-1579.RM.1.0 31Aug2022 | Added a tooltip
    //PE-19.RM.1.0 09Feb2023 | Added a new field
    Caption = 'User Setup'; //PRJ-1330.NK.1.0 25Apr2022
    //PE-170.HS.1.0 27Sept2023 | Changed Tooltip
    //PRJCTPR-209.HS.1.0 27Oct2023 | Add tooltip and caption
    // PRJCTPR-191.HS.1.0 6Nov2023 | Added tooltip
    layout
    {
        addafter(Email)
        {
            field("NS_Allow FA Posting From"; Rec."Allow FA Posting From")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allow FA Posting From';
            }
            field("NS_Allow FA Posting To"; Rec."Allow FA Posting To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Allow FA Posting To';
            }
            //JD-54.AM.1.0 Start
            field("NS_Unlock DFR"; Rec."NS_Unlock DFR")
            {
                ApplicationArea = all;
                Caption = 'Unlock DFR';
                ToolTip = 'If this boolean is checked, then it will allow the user to unlock the DFR'; //PRJ-1579.RM.1.0 
            }
            //JD-54.AM.1.0 Start

            field("NS_Allow Forecast Deletion"; REC."NS_Allow Forecast Deletion")
            {
                ApplicationArea = all;
                Description = 'CTSI-207.MS.1.0';
                //ToolTip = 'If this boolean is checked then the specific user is allowed to delete the posted entry of JFW, If not checked then the user will not have the permission for the same.'; //PRJ-1579.RM.1.0 //PE-295.JS.1.0 11JUN2024-Commented
                ToolTip = 'Specifies if the user has access to run the “Forecast Entry Deletion Batch” to delete the job forecast worksheet and open rev. rec. summary details.'; //PE-295.JS.1.0 11JUN2024 - line added
            }
            //CTSI-254.AM - Start
            //PE-295.JS.1.0 11JUN2024-Start
            field("NS_Allow To Delete Rev. Rec"; Rec."NS_Allow To Delete Rev. Rec")
            {
                Caption = 'Allow Rev. Rec. Entries Deletion';
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has access to delete the open rev. rec. summary details for a job which also has posted rev. rec. entries along with job forecast entries when running �Forecast Entry Deletion Batch".', Comment = '%';
            }
            //PE-295.JS.1.0 11JUN2024-end            
            field("NS_Modify Project Summary Details"; REC."NS_Modify Project Summary Details")
            {
                ApplicationArea = all;
                Description = '//PRJ-585.AS.1.0 16MARCH2021';
                //ToolTip = 'If this boolean is checked then the user is allowed to modify Project Summary Details of Job Forecast Worksheet, if not checked then the user will not have the permission to modify the Project Summary details of Job Forecast Worksheet.'; //PRJ-1579.RM.1.0 //PE-295.JS.1.0 11JUN2024 line commented
                ToolTip = 'Specifies if the user has access to modify the “Project Summary Details” on the Job Forecast Worksheet.'; //PE-295.JS.1.0 11JUN2024 line added  
            }
            //CTSI-254.AM
            field("NS_Access to Job Burden Allocation Batch"; REC."NS_Access to Job Burden Allocation Batch")
            {
                ApplicationArea = all;
                ToolTip = 'If this boolean is checked then the user is allowed to run this "Advanced Job Burden Allocation to G/L" batch, if not checked then the user is not allowed to run this batch'; //PRJ-1579.RM.1.0
            }
            //CTSI-254.AM
            //CTSI-254.AM - End
            //CTSI-274.AM.1.0 start
            field("NS_AccessTo Rev.RecognitionReport"; REC."NS_AccessTo Rev.RecognitionReport")
            {
                ApplicationArea = all;
                //ToolTip = 'If this boolean is not checked then the user not have the authorization to run the Revenue Recognition Summary Detail funtionality and if this boolean is checked then the user can run Revenue Recognition Summary Detail funtionality'; //PRJ-1579.RM.1.0 //PE-295.JS.1.0 11JUN2024 line commented
                ToolTip = 'Specifies if the user has access to run the “Revenue Recognition Report/Batch".'; //PE-295.JS.1.0 11JUN2024 line added
            }
            //CTSI-274.AM.1.0 End
            field("NS_Overwrite JFW Date Setup"; REC."NS_Overwrite JFW Date Setup")
            {
                ApplicationArea = all;
                Description = 'CTSI-268';
                ToolTip = 'If this boolean is checked then the user can overwrite the mentioned date that is mentioned in Job Setup for JFW As of Date filter. And if this boolean is not checked then the user don''t have the permission to do so.'; //PRJ-1579.RM.1.0 
            }
            field("NS_Modify Revenue Recognized Job"; REC."NS_Modify Revenue Recognized Job")
            {
                ApplicationArea = all;
                Description = 'CTSI-285.MS.1.0';
                // ToolTip = 'If this boolean is checked then the user can modify the Revenue Recognization of the job on Reveue Recognition Summary Details page, if this boolean is not checked then the user don''t have the permission of this functionality.';//PRJ-1579.RM.1.0 //PE-170.HS.1.0 27Sept2023 Commented
                Tooltip = 'Specifies if the user has access to run “Revenue Recognition Batch/Report”, modify the details on the “Revenue Recognition Summary Details” page, and modify the “Revenue Recognized” Boolean on the Job Card.'; //PE-170.HS.1.0 27Sept2023
            }

            //PRJ-1405.AS.1.0 02MAY2022 START
            field("NS_Force change work UOM"; Rec."NS_Force change work UOM")
            {
                //PRJCTPR-209.HS.1.0 27Oct2023 Start
                // ToolTip = 'Specifies the Force change Work UOM'; Commented
                ToolTip = 'Specifies if user can change the Work UOM on Job Task Lines having Job Ledger Entries associated with it.';
                Caption = 'Access to Change Work UOM';
                //PRJCTPR-209.HS.1.0 27Oct2023 End
                ApplicationArea = All;
            }
            //PRJ-1405.AS.1.0 02MAY2022 END

            //PRJ-975.GK.1.0 21Oct2021 start
            field("NS_Enable Lien Release Print"; Rec."NS_Enable Lien Release Print")
            {
                ToolTip = 'Specifies the value of the Enable Lien Release Print field.';
                ApplicationArea = All;
                Description = 'PRJ-975.GK.1.0';
            }
            //PRJ-975.GK.1.0 21Oct2021 end
            //PRJ-917.NK.1.0 09Mar2022 Start
            field("NS_Allow To Block APO"; Rec."NS_Allow To Block APO")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the Allow To Blocked APO';
                Description = 'PRJ-917';
            }
            //PRJ-917.NK.1.0 09Mar2022 End
            //PE-19.RM.1.0 09Feb2023 Start
            field("NS_Allow CPR functionality"; Rec."NS_Allow CPR functionality")
            {
                ApplicationArea = all;
                ToolTip = 'Allow User Certified Payroll functionality';
            }
            //PE-19.RM.1.0 09Feb2023 End


        }
        addafter(PhoneNo)
        {
            //PRJCTPR-93.PS.1.0 10April2023 Start
            field("NS_JMP Template WKS. Name"; Rec."NS_JMP Template WKS. Name") //PRJCTPR-101.NC.1.0 21Apr2023
            {
                ApplicationArea = all;
                ToolTip = 'Batch Name flow on JMP Line';
            }
            field("NS_JMP Batch Name"; Rec."NS_JMP Batch Name")
            {
                ApplicationArea = all;
                ToolTip = 'Batch Name flow on JMP Line';
            }
            //PRJCTPR-93.PS.1.0 10April2023 End
            //PRJCTPR-180.AS.1.0 28Aug2023 start
            field(NS_AllowDelPrgBilllines; Rec.NS_AllowDelPrgBilllines)
            {
                ApplicationArea = all;
                // ToolTip = 'This allows user to delete the Progress Bill lines from page Progress Billing Lines Deletion. This is only used when the user has deleted the header and the lines are still in the system which prevents the user from creating a requisitionor version'; // PRJCTPR-191.HS.1.0 6Nov2023 Commented
                ToolTip = 'Specifies if you have permission to remove the reference of progress billing from the job planning lines using the batch "Remove Progress Billing No.".'; //PRJCTPR-191.HS.1.0 6Nov2023
            }
            //PRJCTPR-180.AS.1.0 28Aug2023 end
            //PRJCTPR-147.PS.2.0 20Sep2023  Start

            field("NS_Allow to Acc Manager Status"; Rec."NS_Allow to Acc Manager Status")
            {
                ToolTip = 'Specifies if the user has access to change the “Manager Status” on a Project card where Project Class is set to “Change Request”'; //PRJCTPR-395.DK.1.0 27June2024
                ApplicationArea = all;
            }
            //PRJCTPR-147.PS.2.0 20Sep2023 End 
            //PE-177.DK.1.0 10Nov2023 Start
            field("NS_Allow Repot Stat on SubCon"; Rec."NS_Allow Repot Stat on SubCon")
            {
                ApplicationArea = all;
            }
            //PE-177.DK.1.0 10Nov2023 End

            //PE-200.AS.9.0 START
            field("NS_Allow PayWhenPaid"; Rec."NS_Allow PayWhenPaid")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has access to run “Pay When Paid Batch”, and modify the due dates on the “vendor ledger entries” page for any draw no.';
            }
            field(NS_AllowDrawNoChange; Rec.NS_AllowDrawNoChange)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the user has access to Change “Darw No.” on the Posted Purchase Invoice and “Vendor Ledger Entries” page.';
            }
            //PE-200.AS.9.0 END

            //PE-253.PS.1.0 15feb2024 Start
            field("NS_Allow posting Job Journal"; Rec."NS_Allow posting Job Journal")
            {
                ApplicationArea = all;
                Caption = 'Allow Submittal of Job Work Units';
                ToolTip = 'Specifies if the user has access to Change “Darw No.” on the Posted Purchase Invoice and “Vendor Ledger Entries” page.';
            }
            //PE-253.PS.1.0 15feb2024 End

            //PE-296.JS.1.0 03JUN2024-Start
            field("NS_Allow PPLicence Activation"; Rec."NS_Allow PPLicence Activation")
            {
                Caption = 'Allow Admin rights for PPLicence Activation';
                ApplicationArea = All;
                ToolTip = 'Enable this field allow admin rights for ProjectPro Licence Activation field.', Comment = '%';
            }
            //PE-296.JS.1.0 03JUN2024-end
            //PE-312.JS.1.0 11JUN2024-Start
            field("NS_Allow NegEst. Cost2Complete"; Rec."NS_Allow NegEst. Cost2Complete")
            {
                ApplicationArea = All;
                ToolTip = 'If enabled, allow admin rights to enable “Allow Negative Est. Cost to Complete on JFW” boolean field on job setup', Comment = '%';
            }
            //PE-312.JS.1.0 11JUN2024-end
        }
    }

    //   +---------------------------------------------------------------------------------------------
    //   +ProjectPro
    //   +  - Added field(s):
    //   +     Allow FA Posting From
    //   +     Allow FA Posting To
    //   +
    //   +  - Added function(s):
    //   +
    //   +  - Added global variable(s):
    //   +
    //   +  - Added global text constant(s):
    //   +
    //   +  - Modification(s):
    //   +-----------------------------------------------------------------------------------------------

}

