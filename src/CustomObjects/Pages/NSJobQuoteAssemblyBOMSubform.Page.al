page 14021448 "NS_Job QuoteAssemblyBOMSubform"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-659.RS.1.0 1July21 | NS_�should�be�removed�from�every�page�rest�mention�the�page�ID�and�Name.

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "NS_Job Quote Assembly BOM Line";
    UsageCategory = Lists;
    ApplicationArea = Jobs;
    Caption = 'Job QuoteAssemblyBOMSubform';//PRJ-659.RS.1.0 1July21 Caption Added

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."NS_No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No.';

                    trigger OnValidate();
                    var
                        JobQuoteMgt: Codeunit "NS_Job Quote Mgt.";
                    begin
                        /*
                        IF ("No." <> xRec."No.") AND (Rec."No." <> '') THEN
                          JobQuoteMgt.LoadAssemblyBOM("Quote No.","No.");
                        */

                    end;
                }
                field(Description; Rec.NS_Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Description';
                }
                field(Quantity; Rec.NS_Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';

                    trigger OnValidate();
                    var
                        JobQuoteMgt: Codeunit "NS_Job Quote Mgt.";
                    begin
                        if (xRec.NS_Quantity = 0) and (Rec.NS_Quantity > 0) then
                            JobQuoteMgt.NS_LoadAssemblyBOM(Rec);
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

