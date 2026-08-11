page 14021232 "NS_Delivery ticket Archive JMP"
{
    //PRJ-1361.AS.1.0 Created New Page
    //PRJ-1458.RM.1.0 21June2022 | Added some code
    Caption = 'Delivery Ticket Archive';
    PageType = List;
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTable = "NS_Delivery ticket Archive";
    SourceTableView = sorting("NS_Worksheet Job No.", NS_Revision) ORDER(ASCENDING);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Job No."; Rec."NS_Worksheet Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Job No.';
                    Caption = 'Job No.';
                }
                field("NS_Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                    Caption = 'Line No.';
                }
                field(NS_Revision; Rec.NS_Revision)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Revision';
                    Caption = 'Revision';
                }
                field("Order Code"; Rec."NS_Order Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order Code';
                    Caption = 'Job Task Code';
                }
                field("Segment Code"; Rec."NS_Segment Code")
                {
                    ToolTip = 'Specifies the Segment Code';
                    ApplicationArea = all;
                }
                field("Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Document No."; Rec."NS_Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the "Document No.';
                }
                field("Date Ordered By"; Rec."NS_Date Ordered By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date Ordered By';
                }
                field("Date Required"; Rec."NS_Date Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Date Required';
                }
                field("NS_Assembly Item on Job."; Rec."NS_Assembly Item on Job.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                }
                field("NS_Item Name New"; REC."NS_Item Name New")
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                }
                field("NS_Quantity Per"; Rec."NS_Quantity Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Assembly Item on Job.';
                }
                field("Location Code"; Rec."NS_Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                }
                field(Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';
                }
                field("Part No."; Rec."NS_Part No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Part No.';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("NS_Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Unit of Measure Code';
                }
                field("NS_Base UOM"; Rec."NS_Base UOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Base UOM';
                }
                field("NS_Base UOM (Qty)"; Rec."NS_Base UOM (Qty)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Base UOM (Qty)';
                }
                field(Details; Rec.NS_Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Details';
                }
                field(Manufacturer; Rec.NS_Manufacturer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Manufacturer';
                }
                field(Vendor; Rec.NS_Vendor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Vendor';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Unit Cost"; Rec."NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("Total Cost"; Rec."NS_Total Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Total Cost';
                }
                field("Inv. Qty"; Rec."NS_Inv. Qty")
                {
                    ApplicationArea = All;
                    Caption = 'Inv. Qty (Job Jrnl)';
                    ToolTip = 'Specifies the Inv. Qty (Job Jrnl)';
                }
                field("PO Qty Staged"; Rec."NS_PO Qty Staged")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PO Qty Staged';
                }
                field("Bal. Req"; Rec."NS_Bal. Req")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Bal. Req';
                }
                field("NS_Main Item"; Rec."NS_Main Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Main Item';
                }
                field(NS_Level; Rec.NS_Level)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Level';
                }
                field("NS_Item Type"; Rec."NS_Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item Type';
                }
                field("NS_Global Dimension 1 Code"; Rec."NS_Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("NS_Global Dimension 2 Code"; Rec."NS_Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."NS_Variant Code")
                {
                    ToolTip = 'Specifies the value of the Item Variant Code';
                    ApplicationArea = All;
                }
                field("NS_Job Purchaser"; Rec."NS_Job Purchaser")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Job Purchaser';
                    Caption = 'Job Purchaser';
                    Description = '';
                }
                field("NS_Box Text"; Rec."NS_Box Text")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Box Text';
                    Caption = 'Box Text';
                    Description = 'Box Text';
                    Editable = false;
                }
                field("NS_Total Qty. Ready to Ship"; Rec."NS_Total Qty. Ready to Ship")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Total Qty. Ready to Ship';
                    Caption = 'Total Qty. Ready to Ship';
                    Description = 'Total Qty. Ready to Ship';
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(PrintDeliveryTicket)
                {
                    ApplicationArea = All;
                    Caption = 'Print Job Delivery Ticket';

                    ToolTip = 'Print Job Delivery Ticket';
                    Ellipsis = true;
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        DelArch: Record "NS_Delivery ticket Archive";
                        DeliveryTicket: Report "NS_Delivery Ticket JMP";
                        lJobMatPlan: Record "NS_Job Material Planning";
                        DelArchReport: Report "NS_DeliveryTicketJMPArchive";
                    begin
                        DelArch.Reset;
                        DelArch.SetRange("NS_Worksheet Job No.", rec."NS_Worksheet Job No.");
                        DelArch.setrange(NS_Revision, Rec.NS_Revision);
                        DelArchReport.SetTableView(DelArch);
                        // DelArchReport.RunModal(); //PRJ-1458.RM.1.0 21June2022 commented
                        Report.RunModal(14021232, true, false, DelArch); //PRJ-1458.RM.1.0 21June2022
                    end;
                }
            }
        }
    }

}