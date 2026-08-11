page 14021495 "NS_Assembley BOM Components"
{
    //PRJ-563.AS.1.0 19MARCH2021 New Page created
    //PRJ-563.AS.4.0 23JUN2021 Added Unit cost field
    Caption = 'Assembly BOM Components';//PRJ-563.AS.2.0
    PageType = List;
    SourceTable = "NS_Assembley BOM Components";
    UsageCategory = Lists;
    ApplicationArea = Jobs;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("NS_Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';

                    trigger OnValidate();
                    begin
                    end;
                }
                field("NS_Job Task No."; Rec."NS_Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job Task No.';

                    trigger OnValidate();
                    begin
                    end;
                }
                field("NS_Line No."; Rec."NS_Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';

                    trigger OnValidate();
                    begin
                    end;
                }

                field(NS_Type; Rec.NS_Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Type';

                    trigger OnValidate();
                    begin
                    end;
                }

                field("NS_No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the NS_No.';

                    trigger OnValidate();
                    var
                        ItemRec: Record Item;
                        ResourceRec: Record Resource;
                        AssemBOMRecT: Record "NS_Assembley BOM Components";
                    begin
                        if NS_Type = NS_Type::Item then begin
                            if ItemRec.get(Rec."NS_No.") then begin
                                "NS_Unit of Measure Code" := ItemRec."Base Unit of Measure";
                                //PRJ-563.AS.1.0 24MAY2020 - start
                                ItemRec.CalcFields("Assembly BOM");
                                if ItemRec."Assembly BOM" = true then
                                    "NS_Item Type" := "NS_Item Type"::Assembly
                                else
                                    "NS_Item Type" := "NS_Item Type"::Normal;
                                "NS_Unit Cost" := ItemRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                                //PRJ-563.AS.1.0 24MAY2020 - end
                            end;
                        end;

                        if NS_Type = NS_Type::Resource then begin
                            if ResourceRec.get(rec."NS_No.") then begin
                                "NS_Unit of Measure Code" := ResourceRec."Base Unit of Measure";
                                "NS_Unit Cost" := ResourceRec."Unit Cost";//PRJ-563.AS.4.0 23JUN2021
                            end;
                        end;
                        "NS_Quantity Per" := 0;
                        if xRec."NS_No." <> Rec."NS_No." then begin
                            AssemBOMRecT.Reset();
                            AssemBOMRecT.SetRange("NS_Job No.", xRec."NS_Job No.");
                            AssemBOMRecT.SetRange("NS_Job Task No.", xRec."NS_Job Task No.");
                            AssemBOMRecT.SetRange("NS_Ref. JPL Line No.", xRec."NS_Ref. JPL Line No.");
                            AssemBOMRecT.SetRange("NS_Ref. JPL Parent Item No.", xRec."NS_No.");
                            if AssemBOMRecT.FindSet() then
                                AssemBOMRecT.DeleteAll();
                        end;
                    end;


                    trigger OnDrillDown()
                    var
                        AssemBOMRec: Record "NS_Assembley BOM Components";
                    begin
                        AssemBOMRec.Reset();
                        AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                        AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."NS_No.");
                        AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                        AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                        if AssemBOMRec.FindSet() then
                            page.Run(Page::"NS_Assembley BOM Components", AssemBOMRec);
                    end;
                }
                // field(NS_Description; Rec.NS_Description)//PRJ-838 COMMENT
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Description';

                //     trigger OnValidate();
                //     begin
                //     end;
                // }

                field("NS_Description New"; REC."NS_Description New")//PRJ-838 ADD
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';

                    trigger OnValidate();
                    begin
                    end;
                }
                field("NS_Quantity Per"; Rec."NS_Quantity Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity Per';

                    trigger OnValidate();
                    begin
                    end;
                }
                field("NS_Unit of Measure Code"; Rec."NS_Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("NS_Quantity of Assembly Item on Job"; Rec."NS_Quantity of Assembly Item on Job")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity of Assembly Item on Job';
                }
                field("NS_Expected Quantity"; Rec."NS_Expected Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Expected Quantity';
                }
                field("NS_Unit Cost"; "NS_Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit Cost';
                }
                field("NS_Assembly BOM"; Rec."NS_Assembly BOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Remaining Quantity';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        AssemBOMRec: Record "NS_Assembley BOM Components";
                    begin
                        AssemBOMRec.Reset();
                        AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
                        AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", Rec."NS_No.");
                        AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
                        AssemBOMRec.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
                        if AssemBOMRec.FindSet() then
                            page.Run(Page::"NS_Assembley BOM Components", AssemBOMRec);
                    end;
                }
                // field("NS_Main Item"; Rec."NS_Main Item")//PRJ-563.AS.1.0 24MAY2020
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Main Item';
                // }
                // field(NS_Level; Rec.NS_Level)//PRJ-563.AS.1.0 24MAY2020
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Level';
                // }
                // field("NS_Item Type"; Rec."NS_Item Type")//PRJ-563.AS.1.0 24MAY2020
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the Item Type';
                // }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
    end;

    trigger OnAfterGetRecord();
    begin
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        AssemBOMRecT: Record "NS_Assembley BOM Components";
    begin
        AssemBOMRecT.Reset();
        AssemBOMRecT.SetRange("NS_Job No.", rec."NS_Job No.");
        AssemBOMRecT.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
        AssemBOMRecT.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
        AssemBOMRecT.SetRange("NS_Ref. JPL Parent Item No.", Rec."NS_No.");
        if AssemBOMRecT.FindSet() then
            AssemBOMRecT.DeleteAll();

    end;

    trigger OnInit();
    begin
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
    end;

    trigger OnModifyRecord(): Boolean
    var

    begin

    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    var
        AssemBOMRec: Record "NS_Assembley BOM Components";
        AssemBOMRec3: Record "NS_Assembley BOM Components";
        JPL: Record "Job Planning Line";
    begin
        AssemBOMRec.Reset();
        AssemBOMRec.SetRange("NS_Job No.", rec."NS_Job No.");
        AssemBOMRec.SetRange("NS_Job Task No.", rec."NS_Job Task No.");
        AssemBOMRec.SetRange("NS_Ref. JPL Line No.", xRec."NS_Ref. JPL Line No.");
        AssemBOMRec.SetRange("NS_Ref. JPL Parent Item No.", XRec."NS_Ref. JPL Parent Item No.");
        if AssemBOMRec.FindLast() then begin
            rec."NS_Ref. JPL Line No." := AssemBOMRec."NS_Ref. JPL Line No.";
            rec."NS_Ref. JPL Parent Item No." := AssemBOMRec."NS_Ref. JPL Parent Item No.";

            AssemBOMRec3.Reset();
            AssemBOMRec3.SetRange("NS_Job No.", Rec."NS_Job No.");
            AssemBOMRec3.SetRange("NS_Job Task No.", Rec."NS_Job Task No.");
            AssemBOMRec3.SetRange("NS_Ref. JPL Line No.", Rec."NS_Ref. JPL Line No.");
            if AssemBOMRec3.FindLast() then
                rec."NS_Line No." := AssemBOMRec3."NS_Line No." + 10000
            else
                Rec."NS_Line No." := 10000;

            //PRJ-563.AS.1.0 24MAY2020 - start
            JPL.Reset();
            JPL.SetRange("Job No.", AssemBOMRec."NS_Job No.");
            JPL.SetRange("Job Task No.", AssemBOMRec."NS_Job Task No.");
            JPL.SetRange("Line No.", AssemBOMRec."NS_Ref. JPL Line No.");
            if JPL.FindFirst() then
                "NS_Main Item" := JPL."No.";

            NS_Level := xRec.NS_Level;
            //PRJ-563.AS.1.0 24MAY2020 - end
        end;
    end;

}

