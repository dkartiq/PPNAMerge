pageextension 14021111 NS_SalesQuote extends "Sales Quote"
{
    // version NAVW111.00.00.25466,NAVNA11.00.00.25466,PPNA11.00
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Sales Quote'; //PRJ-1330.NK.1.0 25Apr2022
    layout
    {
        modify("Sell-to Customer Templ. Code") //PRJ-1620.AS.1.0 as per V21 validation changed "Sell-to Customer Template Code" to "Sell-to Customer Templ. Code"
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Sell-to Contact")
        {
            field("NS_Sell to customer template code"; Rec."Sell-to Customer Templ. Code")//PRJ-1620.AS.1.0 as per V21 validation changed "Sell-to Customer Template Code" to "Sell-to Customer Templ. Code"
            {
                Caption = 'Customer Template Code';
                ToolTip = 'Specifies the code for the template to create a new customer';
                ApplicationArea = Basic, Suite;
                Enabled = EnableSellToCustomerTemplateCode;
                trigger OnValidate();
                begin
                    NS_ActivateFields;
                    //ProjectPro - start
                    //CurrPage.UPDATE;
                    IF "NS_Job No." <> xRec."NS_Job No." THEN
                        CurrPage.UPDATE;
                    //ProjectPro - end
                end;
            }
        }
    }

    var
        EnableSellToCustomerTemplateCode: Boolean;

    trigger OnOpenPage();
    begin
        EnableSellToCustomerTemplateCode := true;
    end;

    procedure NS_ActivateFields();
    begin
        EnableSellToCustomerTemplateCode := "Sell-to Customer No." = '';
    end;

    /* Documentation
    +---------------------------------------------------------------------------------------------
    +ProjectPro
    +  - Modification(s):
    +     - Modified controls:
    +        - Sell-to Customer Template Code - OnValidate - Only update page if Job No. has changed
    +  -Created variable EnableSellToCustomerTemplateCode and recreated standard procedures related to this variable
    +
    + -SMP 
    +  -Rewritten Fields
    +   -Sell-to Customer Template Code
    +-----------------------------------------------------------------------------------------------
    */

}

