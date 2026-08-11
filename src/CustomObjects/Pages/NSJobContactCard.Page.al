page 14021207 "NS_Job Contact Card"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Contact Card';
    PageType = Card;
    SourceTable = "NS_Job Contact";
    UsageCategory = Documents;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Code"; Rec.NS_Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Code';
                }
                field(Name; Rec.NS_Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the Name';
                }
                field("Name 2"; Rec."NS_Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Name 2';
                }
                field(Address; Rec.NS_Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the Address';
                }
                field("Address 2"; Rec."NS_Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Address 2';
                }
                field(City; Rec.NS_City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the City';
                }
                field(County; Rec.NS_County)
                {
                    ApplicationArea = All;
                    Caption = 'State';
                    ToolTip = 'Specifies the State';
                }
                field("Post Code"; Rec."NS_Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Zip Code';
                    ToolTip = 'Specifies the Zip Code';
                }
                field("Their Job No."; Rec."NS_Their Job No.")
                {
                    ApplicationArea = All;
                    Caption = 'Their Job No.';
                    ToolTip = 'Specifies the Their Job No.';
                }
            }
            group(Primary)
            {
                Caption = 'Primary';
                field("Primary Phone No."; Rec."NS_Primary Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the Phone No.';
                }
                field("Primary Fax No."; Rec."NS_Primary Fax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Fax No.';
                    ToolTip = 'Specifies the Fax No.';
                }
                field("Primary Mobile No."; Rec."NS_Primary Mobile No.")
                {
                    ApplicationArea = All;
                    Caption = 'Mobile No.';
                    ToolTip = 'Specifies the Mobile No.';
                }
                field("Primary e-Mail"; Rec."NS_Primary e-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'e-Mail';
                    ToolTip = 'Specifies the e-Mail';
                }
                field("Primary Home Page"; Rec."NS_Primary Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the Home Page';
                }
            }
            group(Secondary)
            {
                Caption = 'Secondary';
                field("Secondary Phone No."; Rec."NS_Secondary Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the Phone No.';
                }
                field("Secondary Fax No."; Rec."NS_Secondary Fax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Fax No.';
                    ToolTip = 'Specifies the Fax No.';
                }
                field("Secondary Mobiel No."; Rec."NS_Secondary Mobiel No.")
                {
                    ApplicationArea = All;
                    Caption = 'Mobile No.';
                    ToolTip = 'Specifies the Mobile No.';
                }
                field("Secondary e-Mail"; Rec."NS_Secondary e-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'e-Mail';
                    ToolTip = 'Specifies the e-Mail';
                }
                field("Secondary Home Page"; Rec."NS_Secondary Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the Home Page';
                }
            }
        }
    }

    actions
    {
    }
}

