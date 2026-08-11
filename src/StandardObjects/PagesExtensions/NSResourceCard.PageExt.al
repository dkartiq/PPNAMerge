pageextension 14021129 NS_ResourceCard extends "Resource Card"
{
    // version NAVW111.00.00.21836,NAVNA11.00.00.21836,PPNA11.00
    //PRJ-490.MS.1.0 added new field
    //PRJ-991.GK.2.0 22Oct2021

    layout
    {
        //PRJ-568.AS.1.0 18FEB2021 - START
        addafter("Time Sheet Approver User ID")
        {
            field("NS_Default Job Task No"; Rec."NS_Default Job Task No")
            {
                ApplicationArea = All;
                Caption = 'Default Job Task No.';
                Editable = true;
            }
        }
        //PRJ-568.AS.1.0 18FEB2021 - END
        addafter("Last Date Modified")
        {
            field(NS_EmployeeNo; NS_EmployeeNo)
            {
                ApplicationArea = All;
                Caption = 'Employee No.';

                ToolTip = 'Employee No.';
                Editable = false;
                TableRelation = Employee;
                Visible = NS_EmployeeNoVisible;
            }
        }
        addafter("IC Partner Purch. G/L Acc. No.")
        {
            field("NS_Job Cost Category"; Rec."NS_Job Cost Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Cost Category';
            }
            field("NS_Job Revenue Category"; Rec."NS_Job Revenue Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Revenue Category';
            }
            field("NS_Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Vendor No.';
            }
            field("NS_Resource is Purchasable"; Rec."NS_Resource is Purchasable")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the whether the Resource is Purchasable';
            }

        }
        addafter("Time Sheet Approver User ID")
        {
            field("NS_Res. FA No."; "NS_Res. FA No.")
            {
                ApplicationArea = all;
                Description = 'PRJ-490.MS.1.0';
            }
            //PRJ-991.GK.2.0 22Oct2021 start
            field("NS_No. Of Active Jobs"; Rec."NS_No. Of Active Jobs")
            {
                ToolTip = 'Count of the value of the No. Of Active Jobs.';
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    NS_jobCrewResource: Page "NS_ Job Crew Resource List";
                    NS_JCR: Record "NS_Job Crew Resource";
                begin
                    NS_JCR.Reset();
                    NS_JCR.FilterGroup(2);
                    NS_JCR.SetRange("NS_Resource No.", Rec."No.");
                    NS_JCR.FilterGroup(0);
                    NS_jobCrewResource.SetTableView(NS_JCR);
                    NS_jobCrewResource.RunModal();

                end;
            }
            //PRJ-991.GK.2.0 22Oct2021 end

        }
    }
    actions
    {
        modify("&Prices")
        {
            Caption = 'Cost/&Price';
        }
    }

    var
        NS_Employee: Record Employee;

        NS_EmployeeNo: Code[20];
        NS_EmployeeNoVisible: Boolean;

    trigger OnOpenPage();
    begin
        //ProjectPro - start
        IF NOT NS_Employee.READPERMISSION THEN
            NS_EmployeeNoVisible := FALSE
        ELSE
            NS_EmployeeNoVisible := TRUE;
        //ProjectPro - end
    end;

    trigger OnAfterGetRecord();
    begin
        //ProjectPro - start
        IF NS_Employee.READPERMISSION THEN BEGIN
            NS_Employee.RESET();
            NS_Employee.SETCURRENTKEY("Resource No.");
            NS_Employee.SETRANGE("Resource No.", "No.");
            IF NS_Employee.FINDFIRST() THEN
                NS_EmployeeNo := NS_Employee."No."
            ELSE
                NS_EmployeeNo := '';
        END;
        //ProjectPro - end
    END;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //ProjectPro - start
        NS_EmployeeNo := '';
        //ProjectPro - end
    end;

    /* Documentation
      +---------------------------------------------------------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     PP_EmployeeNo
      +     PP Job Cost Category
      +     PP Job Revenue Category
      +     Vendor No.
      +     Resource is Purchasable
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +     PP_EmployeeNo
      +     PP_Employee
      +     PP_EmployeeNoVisible
      +
      +  - Added global text constant(s):
      +
      +  - Modification(s):
      +     - OnOpenPage - Set PP_EmployeeNoVisible based on READPERMISSION
      +     - OnAfterGetRecord - Set PP_EmployeeNo to be displayed based on READPERMISSION
      +     - OnNewRecord - Set PP_EmployeeNo to blank
      +     - Menus:
      +        - Modify action list:
      +           Modify title from Prices to Cost/Price
      +-----------------------------------------------------------------------------------------------
    */

}

