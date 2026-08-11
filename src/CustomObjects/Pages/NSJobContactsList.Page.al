page 14021215 "NS_Job Contacts List"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------

    Caption = 'Job Contacts List';
    DataCaptionFields = "NS_Job No.";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "NS_Job Contact";

    layout
    {
        area(content)
        {
            repeater(Control1100773000)
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
                    ToolTip = 'Specifies the Name';
                }
                field("Name 2"; Rec."NS_Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Name 2';
                    Visible = false;
                }
                field(Address; Rec.NS_Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Address';
                    Visible = false;
                }
                field("Address 2"; Rec."NS_Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Address 2';
                    Visible = false;
                }
                field(City; Rec.NS_City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the City';
                    Visible = false;
                }
                field(County; Rec.NS_County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the County';
                    Visible = false;
                }
                field("Post Code"; Rec."NS_Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Post Code';
                    Visible = false;
                }
                field("Primary Phone No."; Rec."NS_Primary Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Primary Phone No.';
                }
                field("Primary Fax No."; Rec."NS_Primary Fax No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Primary Fax No.';
                    Visible = false;
                }
                field("Primary Mobile No."; Rec."NS_Primary Mobile No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Primary Mobile No.';
                    Visible = false;
                }
                field("Primary e-Mail"; Rec."NS_Primary e-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Primary e-Mail';
                    Visible = false;
                }
                field("Primary Home Page"; Rec."NS_Primary Home Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Primary Home Page';
                    Visible = false;
                }
                field("Secondary Phone No."; Rec."NS_Secondary Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Secondary Phone No.';
                    Visible = false;
                }
                field("Secondary Fax No."; Rec."NS_Secondary Fax No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Secondary Fax No.';
                    Visible = false;
                }
                field("Secondary Mobiel No."; Rec."NS_Secondary Mobiel No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Secondary Mobiel No.';
                    Visible = false;
                }
                field("Secondary e-Mail"; Rec."NS_Secondary e-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Secondary e-Mail';
                    Visible = false;
                }
                field("Secondary Home Page"; Rec."NS_Secondary Home Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Secondary Home Page';
                    Visible = false;
                }
                field("Their Job No."; Rec."NS_Their Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Their Job No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Job Contact")
            {
                ApplicationArea = All;
                Caption = 'Job Contact';
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "NS_Job Contact Card";
                RunPageLink = "NS_Job No." = FIELD("NS_Job No.");
                RunPageOnRec = true;
                ToolTip = 'Job Contact';
            }
        }
    }
}

