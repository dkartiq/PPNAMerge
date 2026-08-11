page 14021169 "NS_Job Cost Category Prices"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks  Custmization
    PageType = List;
    Caption = 'Job Cost Category Prices';
    SourceTable = "NS_Job Cost Category Price";
    //UsageCategory = Lists; PRJ-1058.GK.1.0 26Nov2021 Twinoaks
    //ApplicationArea = Jobs;  //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Commented

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."NS_Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
                }
                field("Cost Category Code"; Rec."NS_Cost Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cost Category Code';
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
                field("Degree of Difficulty"; Rec."NS_Degree of Difficulty")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Degree of Difficulty';

                }
                //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
                field("Markup %"; Rec."NS_Markup %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Markup %';

                }
            }

        }
    }
    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks Start
    actions
    {
        area(Processing)
        {
            action("Update")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                trigger OnAction()
                var
                    Rec_JPL: Record "Job Planning Line";
                    JPLRec: Record "Job Planning Line";//PRJ-1068.AS.1.0
                    Rec_JobCostprice: Record "NS_Job Cost Category Price";
                    JobCostprice: Record "NS_Job Cost Category Price"; //PRJ-1417.NK.1.0 17Aug2022
                    JobCostprice2: Record "NS_Job Cost Category Price"; //PRJ-1417.NK.1.0 17Aug2022
                    jobsetup: Record "Jobs Setup";//PRJ-1645.AS.1.0
                begin
                    if jobsetup.Get() then;//PRJ-1645.AS.1.0

                    if jobsetup.NS_EnblMrkupOnJPLCostCatg = false then BEGIN //PRJ-1645.AS.1.0 START Added Code under conditions
                        //PRJ-1068.AS.1.0 START Restructure old code
                        Rec_JPL.Reset();
                        Rec_JPL.SetRange("Job No.", Rec."NS_Job No.");
                        IF Rec_JPL.FindSet() then
                            repeat
                                IF Rec_JPL."NS_Old Qty." <> 0 then begin
                                    if Rec_JobCostprice.get(Rec_JPL."Job No.", Rec_JPL."NS_Cost Category") then;
                                    IF Rec_JobCostprice."NS_Degree of Difficulty" <> 0 then begin
                                        Rec_JPL.Validate(Quantity, Rec_JPL."NS_Old Qty." * Rec_JobCostprice."NS_Degree of Difficulty");
                                        if Rec_JPL.Type = Rec_JPL.Type::Resource then
                                            if Rec_JPL."NS_Labor Hours per Qty." <> 0 then begin
                                                JPLRec.reset;
                                                JPLRec.SetRange("Job No.", Rec_JPL."Job No.");
                                                JPLRec.SetRange("Line No.", Rec_JPL."NS_Resource Line No.");
                                                JPLRec.SetRange("Job Task No.", Rec_JPL."Job Task No.");
                                                if JPLRec.FindFirst() then;
                                                Rec_JPL.Validate(Quantity, JPLRec.Quantity * Rec_JobCostprice."NS_Degree of Difficulty" * JPLRec."NS_Labor Hours per Qty.");
                                            end;
                                    end;
                                    IF Rec_JobCostprice."NS_Markup %" <> 0 then
                                        Rec_JPL.Validate("Unit Price", Round(Rec_JPL."Unit Cost" + (Rec_JPL."Unit Cost" * (Rec_JobCostprice."NS_Markup %" / 100)))); //PRJ-1058.GK.1.0 01Dec2021 Line added change formula
                                end;
                                IF Rec_JPL."NS_Old Qty." = 0 then begin
                                    if Rec_JobCostprice.get(Rec_JPL."Job No.", Rec_JPL."NS_Cost Category") then;
                                    Rec_JPL."NS_Old Qty." := Rec_JPL.Quantity;
                                    IF Rec_JobCostprice."NS_Degree of Difficulty" <> 0 then begin
                                        Rec_JPL.Validate(Quantity, Rec_JPL.Quantity * Rec_JobCostprice."NS_Degree of Difficulty");
                                        if Rec_JPL.Type = Rec_JPL.Type::Resource then
                                            if Rec_JPL."NS_Labor Hours per Qty." <> 0 then begin
                                                JPLRec.reset;
                                                JPLRec.SetRange("Job No.", Rec_JPL."Job No.");
                                                JPLRec.SetRange("Line No.", Rec_JPL."NS_Resource Line No.");
                                                JPLRec.SetRange("Job Task No.", Rec_JPL."Job Task No.");
                                                if JPLRec.FindFirst() then;
                                                Rec_JPL.Validate(Quantity, JPLRec.Quantity * Rec_JobCostprice."NS_Degree of Difficulty" * JPLRec."NS_Labor Hours per Qty.");
                                            end;
                                    end;
                                    IF Rec_JobCostprice."NS_Markup %" <> 0 then
                                        Rec_JPL.Validate("Unit Price", Round(Rec_JPL."Unit Cost" + (Rec_JPL."Unit Cost" * (Rec_JobCostprice."NS_Markup %" / 100)))); //PRJ-1058.GK.1.0 01Dec2021 Line added change formula
                                end;
                                Rec_JPL.Modify();
                            until Rec_JPL.next = 0;
                        Message('Process Completed !');
                        //PRJ-1068.AS.1.0 END Restructure old code
                    END;//PRJ-1645.AS.1.0 END Added Code under conditions

                    if (jobsetup.NS_EnblMrkupOnJPLCostCatg = TRUE) AND (jobsetup.NS_LockMultiMrkpUpdateonJPL = true) then BEGIN //PRJ-1645.AS.1.0 START Added Code under conditions  //PRJ-1417.NK.1.0 26Aug2022 Start
                        JobCostprice.Reset();
                        JobCostprice.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if JobCostprice.FindFirst() then
                            repeat
                                JPLRec.Reset();
                                JPLRec.SetCurrentKey("Job No.", "Line No.");
                                JPLRec.SetRange("Job No.", JobCostprice."NS_Job No.");
                                JPLRec.SetFilter(NS_UpdateUnitPrice, '%1', false);
                                if JobCostprice."NS_Cost Category Code" <> '' then
                                    JPLRec.SetRange("NS_Cost Category", JobCostprice."NS_Cost Category Code");
                                if JobCostprice."NS_Quote Category" <> '' then
                                    JPLRec.SetRange("NS_Quote Category", JobCostprice."NS_Quote Category");
                                if JPLRec.FindFirst() then
                                    repeat
                                        IF JobCostprice."NS_Markup %" <> 0 then
                                            JPLRec.Validate("Unit Price", Round(JPLRec."Unit Cost" + (JPLRec."Unit Cost" * (JobCostprice."NS_Markup %" / 100))));
                                        JPLRec.NS_UpdateUnitPrice := TRUE;
                                        JPLRec.Modify();
                                    until JPLRec.Next() = 0;

                            until JobCostprice.Next() = 0;
                        //PRJ-1417.NK.1.0 26Aug2022 End
                        Message('Process Completed !');
                    END;

                    if (jobsetup.NS_EnblMrkupOnJPLCostCatg = TRUE) AND (jobsetup.NS_LockMultiMrkpUpdateonJPL = false) then BEGIN //PRJ-1645.AS.1.0 START Added Code under conditions                                                                                                     //PRJ-1417.NK.1.0 26Aug2022 Start
                        JobCostprice.Reset();
                        JobCostprice.SetRange("NS_Job No.", Rec."NS_Job No.");
                        if JobCostprice.FindFirst() then
                            repeat
                                JPLRec.Reset();
                                JPLRec.SetCurrentKey("Job No.", "Line No.");
                                JPLRec.SetRange("Job No.", JobCostprice."NS_Job No.");
                                if JobCostprice."NS_Cost Category Code" <> '' then
                                    JPLRec.SetRange("NS_Cost Category", JobCostprice."NS_Cost Category Code");
                                if JobCostprice."NS_Quote Category" <> '' then
                                    JPLRec.SetRange("NS_Quote Category", JobCostprice."NS_Quote Category");
                                if JPLRec.FindFirst() then
                                    repeat
                                        IF JobCostprice."NS_Markup %" <> 0 then
                                            JPLRec.Validate("Unit Price", Round(JPLRec."Unit Cost" + (JPLRec."Unit Cost" * (JobCostprice."NS_Markup %" / 100))));
                                        JPLRec.NS_UpdateUnitPrice := TRUE;
                                        JPLRec.Modify();
                                    until JPLRec.Next() = 0;

                            until JobCostprice.Next() = 0;
                        //PRJ-1417.NK.1.0 26Aug2022 End
                        Message('Process Completed !');
                    END;
                end;

            }
        }
    }
    //PRJ-1058.GK.1.0 26Nov2021 Twinoaks End
}

