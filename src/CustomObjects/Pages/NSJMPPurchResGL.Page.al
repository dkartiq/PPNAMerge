page 14021435 "NS_JMP Purch. Res. G/L"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-1306.NK.1.0 19APR2022 | Correct Code
    //PRJ-1579.RM.1.0 22Aug2022 | Added some code
    PageType = List;
    Caption = 'JMP Purch. Res. G/L';
    SourceTable = "NS_Job Material Planning";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    SourceTableView = SORTING("NS_Worksheet Job No.", NS_Type, "NS_Part No.", "NS_Bal. Req", "NS_Date Ordered By")
                      WHERE("NS_Bal. Req" = FILTER(> 0));
    InsertAllowed = false;//PRJ-1426.GK.1.0 02June2022

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purchase Res. G/L"; Rec."NS_Purchase Res. G/L")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Purchase Res. G/L';
                }
                field("Order Code"; Rec."NS_Order Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Order Code';
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
                field(Vendor; Rec.NS_Vendor)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                    // ToolTip = 'Vendor No.'; //PRJ-1579.RM.1.0 commented
                    // ToolTip = 'Specifies the vendor no.'; //PRJ-1579.RM.1.0 //PRJ-1579.RM.2.0 commented
                    ToolTip = 'Specifies the Vendor No.'; //PRJ-1579.RM.2.0
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Bal. Req"; Rec."NS_Bal. Req")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Bal. Req';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PP_Purchase)
            {
                ApplicationArea = All;
                Caption = 'Purchase';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Purchase';

                trigger OnAction();
                var
                    VendorNo: Code[20];
                    lVendor: Record Vendor;
                    x: Integer;
                    TrueFalse: Boolean;
                    tmpVend: Record Vendor temporary;
                    JmpVend: Record "NS_Job Material Planning";
                    Text00001LBl: Label '%1 Invoices were generated for Line Type %2', Comment = '%1=x,%2=LineType';
                    LastVendor: Code[20];
                begin
                    x := 0;
                    LastVendor := '';
                    SETFILTER(NS_Vendor, '%1', '');
                    if FINDFIRST then
                        ERROR(Text001Lbl)
                    else
                        SETRANGE(NS_Vendor);

                    JmpVend.SETCURRENTKEY("NS_Worksheet Job No.", NS_Type, NS_Vendor);
                    JmpVend.SETRANGE("NS_Worksheet Job No.", "NS_Worksheet Job No.");
                    JmpVend.SETRANGE("NS_Purchase Res. G/L", true);
                    JmpVend.SETFILTER("NS_Bal. Req", '<>%1', 0);
                    JmpVend.SETRANGE(NS_Type, LineType);
                    if JmpVend.FINDSET(false, false) then
                        repeat
                            tmpVend.INIT();
                            tmpVend."No." := JmpVend.NS_Vendor;
                            if tmpVend.INSERT() then;
                        until JmpVend.NEXT() = 0;
                    TrueFalse := tmpVend.COUNT() = 1;

                    lVendor.SETCURRENTKEY("NS_Resource Provider");
                    if lVendor.FINDSET(false, false) then
                        repeat
                            //PRJ-1131.RM.1.0.001 10Jan2022 start
                            Rec.SETRANGE(NS_Vendor, lVendor."No.");
                            //PRJ-1367.GK.1.0 11May2022 start
                            Rec.SetFilter("NS_Document No.", '<>%1', '');
                            Rec.SetFilter("NS_Date Ordered By", '<>%1', 0D);
                            //PRJ-1367.GK.1.0 11May2022 end
                            if Rec.FINDFIRST() then begin
                                x += 1;
                                if lVendor."No." <> LastVendor then
                                    Rec.NS_MakeResourcePurchDoc(lVendor."No.", TrueFalse, LineType);
                                LastVendor := lVendor."No.";//PRJ-1131.RM.1.0.001 10Jan2022 end
                            end;
                        until lVendor.NEXT() = 0;

                    if not TrueFalse then
                        MESSAGE(STRSUBSTNO(Text00001Lbl, x, FORMAT(LineType)));
                    //CurrPage.UPDATE(); //PRJ-1306.NK.1.0 19APR2022 Block
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        //PRJ-1131.RM.1.0.001 10Jan2022 start
        Rec.SETRANGE("NS_Worksheet Job No.", JobNo);
        Rec.SETRANGE(NS_Type, LineType);
        if LineType = LineType::Resource then begin
            Rec.SETRANGE("NS_Purchase Res. G/L", true);//PRJ-1131.RM.1.0.001 10Jan2022 end
            //PRJ-1367.GK.1.0 11May2022 start
            Rec.SetFilter(NS_Vendor, '<>%1', '');
            Rec.SetFilter("NS_Document No.", '<>%1', '');
            Rec.SetFilter("NS_Date Ordered By", '<>%1', 0D);
            //PRJ-1367.GK.1.0 11May2022 end
        end;

    end;

    var
        JobNo: Code[20];
        LineType: Option Resource,Item,"G/L Account",Text,"Resource (Group)",Template;
        Text001Lbl: Label 'There Must be a Vendor No. for Each Line';

    procedure NS_InitVar(lJobNo: Code[20]; lType: Option Resource,Item,"G/L Account",Text,"Resource (Group)",Template);
    begin
        JobNo := lJobNo;
        LineType := lType;
    end;
}

