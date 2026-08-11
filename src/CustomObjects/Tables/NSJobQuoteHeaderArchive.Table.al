table 14021422 "NS_Job Quote Header Archive"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------
    //PRJ-867.GK.1.0 18Aug2021 - Sales person length to be increased

    Caption = 'Quote Header';
    DrillDownPageID = "NS_Archived Job Quote";
    LookupPageID = "NS_Archived Job Quote";

    fields
    {
        field(11; "NS_Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            DataClassification = CustomerContent;
        }
        field(14; "NS_Description/Nickname"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Description/Nickname';
            DataClassification = CustomerContent;
        }
        field(16; "NS_Quote Type Code"; Code[10])
        {
            Caption = 'Quote Type Code';
            TableRelation = "NS_Job Quote Type";
            DataClassification = CustomerContent;
        }
        field(21; NS_Revision; Integer)
        {
            Caption = 'Revision';
            DataClassification = CustomerContent;
        }
        field(22; "NS_Link-to Quote No."; Code[20])
        {
            Caption = 'Link-to Quote No.';
            TableRelation = "NS_Job Quote Header";
            DataClassification = CustomerContent;
        }
        field(27; "NS_Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method";
        }
        field(29; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50; "NS_Equipment Only"; Boolean)
        {
            Caption = 'Equipment Only';
            DataClassification = CustomerContent;
        }
        field(51; "NS_Proposal Date"; Date)
        {
            Caption = 'Proposal Date';
            DataClassification = CustomerContent;
        }
        field(61; NS_Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Open,,,,Inactive,,,,Review,,,,Released,,,,Accepted,,,,Closed';
            OptionMembers = Open,,,,Inactive,,,,Review,,,,Released,,,,Accepted,,,,Closed;
        }
        field(66; "NS_Probability to Close"; Option)
        {
            Caption = 'Probability to Close';
            DataClassification = CustomerContent;
            OptionCaption = 'Draft,Budget Only,25,,,50,,75,,90,100,,,,,,,,,,Lost,,,,,,,,,,Canceled,,,,,,,Opportunity';
            OptionMembers = Draft,"Budget Only","25",,,"50",,"75",,"90","100",,,,,,,,,,Lost,,,,,,,,,,Canceled,,,,,,,Opportunity;
        }
        field(71; NS_Template; Boolean)
        {
            Caption = 'Template';
            DataClassification = CustomerContent;
        }
        field(99; "NS_External Document No."; Code[35])
        {
            Caption = 'Customer PO No.';
            DataClassification = CustomerContent;
        }
        field(101; "NS_Sell-to Customer No."; Code[20])
        {
            Caption = 'Site Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(102; "NS_Sell-to Customer Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Site Customer Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(106; "NS_Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(107; "NS_Bill-to Customer Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Bill-to Customer Name';
            DataClassification = CustomerContent;
        }
        field(110; "NS_Use Tax Liable"; Option)
        {
            Caption = 'Use Tax Liable';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(112; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(113; "NS_Bill-to Address"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Bill-to Address';
            DataClassification = CustomerContent;
        }
        field(114; "NS_Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            DataClassification = CustomerContent;
        }
        field(115; "NS_Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Bill-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("NS_Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("NS_Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(116; "NS_Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
            DataClassification = CustomerContent;
        }
        field(117; "NS_Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("NS_Bill-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("NS_Bill-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("NS_Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(118; "NS_Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(119; "NS_Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
            DataClassification = CustomerContent;
        }
        field(121; "NS_Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms";
        }
        field(141; "NS_Salesperson Code"; Code[10]) //PRJ-867.GK.1.0 18Aug2021 //PRJ-867.AS.1.0 23SEPT2021 Rollback code done by GK
        {
            ObsoleteState = Pending;//PRJ-867.AS.1.0 23SEPT2021
            ObsoleteReason = 'Will be removed in Next Build';//PRJ-867.AS.1.0 23SEPT2021
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
            // TableRelation = "Salesperson/Purchaser";//PRJCTPR-47.AS.1.0 TABLE RELATION REMOVED
        }
        field(142; "NS_Salesperson Code New"; Code[20])//PRJ-867.AS.1.0 23SEPT2021 Add New field
        {
            Caption = 'Salesperson Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(161; "NS_Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(162; "NS_Contact Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Contact Name';
            DataClassification = CustomerContent;
        }
        field(201; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;
        }
        field(206; "NS_Job Type"; Option)
        {
            Caption = 'Job Type';
            OptionCaption = '" ,Construction,Equipment,Service"';
            OptionMembers = " ",Construction,Equipment,Service;
            DataClassification = CustomerContent;
        }
        field(301; "NS_Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Quote));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(303; "NS_Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = CustomerContent;
        }
        field(313; "NS_Date Converted to Order"; Date)
        {
            Caption = 'Date Converted to Order';
            DataClassification = CustomerContent;
        }
        field(480; "NS_Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
        }
        field(990; "NS_Preserve Pricing Flag"; Boolean)
        {
            Caption = 'Preserve Pricing Flag';
            DataClassification = CustomerContent;
        }
        field(1000; "NS_Owner No."; Code[20])
        {
            Caption = 'Owner No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(1001; "NS_Owner Name"; Text[50])
        {
            Caption = 'Owner Name';
            DataClassification = CustomerContent;
        }
        field(1010; "NS_General Contractor No."; Code[20])
        {
            Caption = 'General Contractor No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(1011; "NS_General Contractor Name"; Text[50])
        {
            Caption = 'General Contractor Name';
            DataClassification = CustomerContent;
        }
        field(1020; "NS_Architect/Engineer No."; Code[20])
        {
            Caption = 'Architect/Engineer No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(1021; "NS_Architect/Engineer Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Architect/Engineer Name';
            DataClassification = CustomerContent;
        }
        field(1030; "NS_Project Manager No."; Code[20])
        {
            Caption = 'Project Manager No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(1031; "NS_Project Manager Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Project Manager Name';
            DataClassification = CustomerContent;
        }
        field(1040; "NS_Estimator No."; Code[20])
        {
            Caption = 'Estimator No.';
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(1041; "NS_Estimator Name"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Estimator Name';
            DataClassification = CustomerContent;
        }
        field(1046; "NS_Date Submitted to Estimator"; Date)
        {
            Caption = 'Date Submitted to Estimator';
            DataClassification = CustomerContent;
        }
        field(1051; "NS_Job Class"; Option)
        {
            Caption = 'Job Class';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Master Job,SubJob,Change Order,Extra Work,Proposed';
            OptionMembers = " ","Master Job",SubJob,"Change Order","Extra Work",Proposed;
        }
        field(1052; "NS_Sub-Level to Job No."; Code[20])
        {
            Caption = 'Sub-Level to Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job;
        }
        field(1091; "NS_Estimated Start Date"; Date)
        {
            Caption = 'Estimated Start Date';
            DataClassification = CustomerContent;
        }
        field(1092; "NS_Estimated Completion Date"; Date)
        {
            Caption = 'Estimated Completion Date';
            DataClassification = CustomerContent;
        }
        field(1201; "NS_Retainage %"; Decimal)
        {
            Caption = 'Retainage %';
            DataClassification = CustomerContent;
        }
        field(1211; "NS_Certified Payroll"; Option)
        {
            Caption = 'Certified Payroll';
            OptionCaption = '" ,Yes,No"';
            OptionMembers = " ",Yes,No;
            DataClassification = CustomerContent;
        }
        field(1221; NS_Bond; Boolean)
        {
            Caption = 'Bond';
            DataClassification = CustomerContent;
        }
        field(1231; "NS_Job Type Code"; Code[10])
        {
            Caption = 'Job Type Code';
            TableRelation = "NS_Job Type";
            DataClassification = CustomerContent;
        }
        field(1241; "NS_Billing Cutoff Day of Month"; Integer)
        {
            Caption = 'Billing Cutoff Day of Month';
            DataClassification = CustomerContent;
        }
        field(1242; "NS_CCIP/OCIP/RCOIP Insurance"; Boolean)
        {
            Caption = 'CCIP/OCIP/RCOIP Insurance';
            DataClassification = CustomerContent;
        }
        field(1243; "NS_Lien Waiver Required"; Boolean)
        {
            Caption = 'Lien Waiver Required';
            DataClassification = CustomerContent;
        }
        field(1300; "NS_----- Use Tax -----"; Boolean)
        {
            Caption = '----- Use Tax -----';
            DataClassification = CustomerContent;
        }
        field(1301; "NS_Use Tax Qualify Response 1"; Option)
        {
            Caption = 'Use Tax Qualify Response 1';
            DataClassification = CustomerContent;
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
        }
        field(1302; "NS_Use Tax Qualify Response 2"; Option)
        {
            Caption = 'Use Tax Qualify Response 2';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1303; "NS_Use Tax Qualify Response 3"; Option)
        {
            Caption = 'Use Tax Qualify Response 3';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1304; "NS_Use Tax Qualify Response 4"; Option)
        {
            Caption = 'Use Tax Qualify Response 4';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1305; "NS_Use Tax Qualify Response 5"; Option)
        {
            Caption = 'Use Tax Qualify Response 5';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1306; "NS_Use Tax Qualify Response 6"; Option)
        {
            Caption = 'Use Tax Qualify Response 6';
            DataClassification = CustomerContent;
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
        }
        field(1307; "NS_Use Tax Qualify Response 7"; Option)
        {
            Caption = 'Use Tax Qualify Response 7';
            DataClassification = CustomerContent;
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
        }
        field(1308; "NS_Use Tax Qualify Response 8"; Option)
        {
            Caption = 'Use Tax Qualify Response 8';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1309; "NS_Use Tax Qualify Response 9"; Option)
        {
            Caption = 'Use Tax Qualify Response 9';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1310; "NS_Use Tax Qualify Response 10"; Option)
        {
            Caption = 'Use Tax Qualify Response 10';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1351; "NS_Use Tax- Contractor Status"; Option)
        {
            Caption = 'Contractor Status';
            OptionCaption = '" ,Prime,Sub"';
            OptionMembers = " ",Prime,Sub;
            DataClassification = CustomerContent;
        }
        field(1352; "NS_Use Tax- Contract Type"; Option)
        {
            Caption = 'Contract Type';
            InitValue = "Lump Sum";
            OptionCaption = '" ,Lump Sum,T&M"';
            OptionMembers = " ","Lump Sum","T&M";
            DataClassification = CustomerContent;
        }
        field(1353; "NS_Use Tax- Property Type"; Option)
        {
            Caption = 'Property Type';
            DataClassification = CustomerContent;
            InitValue = Commercial;
            OptionCaption = '" ,Commercial,Residential"';
            OptionMembers = " ",Commercial,Residential;
        }
        field(1354; "NS_Use Tax- Project Type"; Option)
        {
            Caption = 'Project Type';
            OptionCaption = '" ,New,Remodel,Repair"';
            OptionMembers = " ",New,Remodel,Repair;
            DataClassification = CustomerContent;
        }
        field(1355; "NS_Use Tax-Downstr Cont Status"; Option)
        {
            Caption = 'Downstream Contractor Status';
            InitValue = Sub;
            OptionCaption = '" ,Prime,Sub"';
            OptionMembers = " ",Prime,Sub;
            DataClassification = CustomerContent;
        }
        field(1356; "NS_Use Tax- Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = '" ,Labor,Materials,Not Allocated"';
            OptionMembers = " ",Labor,Materials,"Not Allocated";
            DataClassification = CustomerContent;
        }
        field(1357; "NS_Use Tax- ChargeType Detail"; Option)
        {
            Caption = 'ChargeType Detail';
            OptionCaption = '" ,Self-generated,Rebill from Sub"';
            OptionMembers = " ","Self-generated","Rebill from Sub";
            DataClassification = CustomerContent;
        }
        field(1358; "NS_Use Tax- Potent Proj Exempt"; Option)
        {
            Caption = 'Potential Project Exemption';
            OptionCaption = 'Not Applicable,Federal,State,Municipal,Non-Profit,Hospitals,TBD';
            OptionMembers = "Not Applicable",Federal,State,Municipal,"Non-Profit",Hospitals,TBD;
            DataClassification = CustomerContent;
        }
        field(1359; "NS_Use Tax Code"; Code[10])
        {
            Caption = 'Use Tax Code';
            TableRelation = "NS_Export / Import Excel Line".NS_KeyIndex;
            DataClassification = CustomerContent;
        }
        field(1360; "NS_Use Tax %"; Decimal)
        {
            Caption = 'Use Tax %';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(1361; "NS_Use Tax Amount"; Decimal)
        {
            Caption = 'Use Tax Amount';
            DataClassification = CustomerContent;
        }
        field(1362; "NS_Use Tax Amount (LCY)"; Decimal)
        {
            Caption = 'Use Tax Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(1700; "NS_----- Other -----"; Boolean)
        {
            Caption = '----- Other -----';
            DataClassification = CustomerContent;
        }
        field(1701; "NS_Deposit Required"; Decimal)
        {
            Caption = 'Deposit Required';
            DataClassification = CustomerContent;
        }
        field(1751; "NS_Print Sales Tax"; Boolean)
        {
            Caption = 'Print Sales Tax';
            DataClassification = CustomerContent;
        }
        field(1801; "NS_Estimated Month to Close"; Option)
        {
            Caption = 'Estimated Month to Close';
            OptionCaption = '" ,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"';
            OptionMembers = " ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
            DataClassification = CustomerContent;
        }
        field(1802; "NS_Estimated Month to Bill"; Option)
        {
            Caption = 'Estimated Month to Bill';
            OptionCaption = '" ,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"';
            OptionMembers = " ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
            DataClassification = CustomerContent;
        }
        field(1803; "NS_Estimated % to Bill"; Decimal)
        {
            Caption = 'Estimated % to Bill';
            DataClassification = CustomerContent;
        }
        field(5001; "NS_Created by"; Code[50])
        {
            Caption = 'Created by';
            DataClassification = CustomerContent;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
        }
        field(5006; "NS_Salesperson/User ID"; Code[50])
        {
            Caption = 'JF Salesperson/User ID';
            DataClassification = CustomerContent;
        }
        field(5011; "NS_Modified by"; Code[50])
        {
            Caption = 'Modified by';
            TableRelation = User;
            DataClassification = CustomerContent;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            DataClassification = CustomerContent;
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            DataClassification = CustomerContent;
        }
        field(5021; "NS_Accepted by"; Code[50])
        {
            Caption = 'Accepted by';
            TableRelation = User;
            DataClassification = CustomerContent;
        }
        field(5022; "NS_Accepted at Date"; Date)
        {
            Caption = 'Accepted at Date';
            DataClassification = CustomerContent;
        }
        field(5023; "NS_Accepted at Time"; Time)
        {
            Caption = 'Accepted at Time';
            DataClassification = CustomerContent;
        }
        field(5031; "NS_Duplicated-from Quote No."; Code[20])
        {
            Caption = 'Duplicated-from Quote No.';
            DataClassification = CustomerContent;
        }
        field(5051; "NS_Sell-toCustomerTemplateCode"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            //TableRelation = "Customer Template";   //PRJCTPR-155.JS.1.0 line commented
            TableRelation = "Customer Templ.";  //PRJCTPR-155.JS.1.0 line added
            DataClassification = CustomerContent;
        }
        field(5053; "NS_Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
        }
        field(5054; "NS_Bill-toCustomerTemplateCode"; Code[10])
        {
            Caption = 'Bill-to Customer Template Code';
            //TableRelation = "Customer Template";   //PRJCTPR-155.JS.1.0 line commented
            TableRelation = "Customer Templ.";  //PRJCTPR-155.JS.1.0 line added        
            DataClassification = CustomerContent;
        }
        field(5400; "NS_Lump Sum"; Boolean)
        {
            Caption = 'Lump Sum';
            DataClassification = CustomerContent;
        }
        field(5750; "NS_Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            DataClassification = CustomerContent;
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(5790; "NS_Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = CustomerContent;
        }
        field(6001; "NS_Copy in Progress"; Boolean)
        {
            Caption = 'Copy in Progress';
            DataClassification = CustomerContent;
        }
        field(10000; "NS_----- Flowfields -----"; Boolean)
        {
            Caption = '----- Flowfields -----';
            DataClassification = CustomerContent;
        }
        field(10141; "NS_Salesperson Name"; Text[100])//PRJ-301.MS.1.0
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("NS_Salesperson Code New")));//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            Caption = 'Salesperson Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10201; "NS_Job Description"; Text[100])//PRJ-301.MS.1.0
        {
            CalcFormula = Lookup(Job.Description WHERE("No." = FIELD("NS_Job No.")));
            Caption = 'Job Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13121; NS_Amount; Decimal)
        {
            CalcFormula = Sum("NS_Job Quote Line".NS_Amount WHERE("NS_Quote No." = FIELD("NS_Quote No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13122; "NS_Amount Including VAT"; Decimal)
        {
            CalcFormula = Sum("NS_Job Quote Line"."NS_Amount Including VAT" WHERE("NS_Quote No." = FIELD("NS_Quote No.")));
            Caption = 'Amount Including Tax';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13139; "NS_Gross Margin"; Decimal)
        {
            CalcFormula = Sum("NS_Job Quote Line"."NS_Gross Margin" WHERE("NS_Quote No." = FIELD("NS_Quote No.")));
            Caption = 'Gross Margin';
            FieldClass = FlowField;
        }
        field(14000705; "NS_Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
            DataClassification = CustomerContent;
        }
        field(14021100; "NS_Job Address 1"; Text[100])//PRJ-301.MS.1.0
        {
            Caption = 'Job Address 1';
            DataClassification = CustomerContent;
        }
        field(14021101; "NS_Job Address 2"; Text[50])
        {
            Caption = 'Job Address 2';
            DataClassification = CustomerContent;
        }
        field(14021102; "NS_Job City"; Text[50])
        {
            Caption = 'Job City';
            DataClassification = CustomerContent;
        }
        field(14021103; "NS_Job County"; Text[30])
        {
            Caption = 'Job State';
            DataClassification = CustomerContent;
        }
        field(14021104; "NS_Job Post Code"; Code[20])
        {
            Caption = 'Job Zip Code';
            TableRelation = "Post Code";
            DataClassification = CustomerContent;
        }
        field(14021105; "NS_Job Country/Region Code"; Code[10])
        {
            Caption = 'Job Country/Region Code';
            Editable = true;
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(14021106; "NS_Job Ship-to Code"; Code[10])
        {
            Caption = 'Job Ship-to Code';
            DataClassification = CustomerContent;
        }
        field(14021110; "NS_Segment No."; Code[20])
        {
            Caption = 'Segment No.';
            DataClassification = CustomerContent;
        }
        field(14021111; "NS_Segment Line No."; Integer)
        {
            Caption = 'Segment Line No.';
            DataClassification = CustomerContent;
        }
        field(14021140; "NS_Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
            DataClassification = CustomerContent;
        }
        field(14021141; "NS_Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
            Editable = true;
            DataClassification = CustomerContent;
        }
        field(14021142; "NS_Tax Group Code"; Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";
            DataClassification = CustomerContent;
        }
        field(14021145; "NS_VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = CustomerContent;
        }
        field(14021146; "NS_VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
        }
        field(14021400; NS_Archived; DateTime)
        {
            Caption = 'Archived';
            DataClassification = CustomerContent;
        }
        field(14021417; "NS_Use Tax SKU"; Code[20])
        {
            Caption = 'Use Tax SKU';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14021418; "NS_Schedule 1 Description"; Text[50])
        {
            Caption = 'Schedule 1 Description';
            DataClassification = CustomerContent;
        }
        field(14021419; "NS_Schedule 2 Description"; Text[50])
        {
            Caption = 'Schedule 2 Description';
            DataClassification = CustomerContent;
        }
        field(14021420; "NS_Schedule 3 Description"; Text[50])
        {
            Caption = 'Schedule 3 Description';
            DataClassification = CustomerContent;
        }
        field(14021421; "NS_Schedule 4 Description"; Text[50])
        {
            Caption = 'Schedule 4 Description';
            DataClassification = CustomerContent;
        }
        field(14021422; "NS_Schedule 1 Percentage"; Decimal)
        {
            Caption = 'Schedule 1 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021423; "NS_Schedule 2 Percentage"; Decimal)
        {
            Caption = 'Schedule 2 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021424; "NS_Schedule 3 Percentage"; Decimal)
        {
            Caption = 'Schedule 3 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021425; "NS_Schedule 4 Percentage"; Decimal)
        {
            Caption = 'Schedule 4 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021426; "NS_Schedule 5 Description"; Text[50])
        {
            Caption = 'Schedule 5 Description';
            DataClassification = CustomerContent;
        }
        field(14021427; "NS_Schedule 6 Description"; Text[50])
        {
            Caption = 'Schedule 6 Description';
            DataClassification = CustomerContent;
        }
        field(14021428; "NS_Schedule 5 Percentage"; Decimal)
        {
            Caption = 'Schedule 5 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021429; "NS_Schedule 6 Percentage"; Decimal)
        {
            Caption = 'Schedule 6 Percentage';
            DataClassification = CustomerContent;
        }
        field(14021430; "NS_Total Purchase Price"; Decimal)
        {
            Caption = 'Total Purchase Price';
            DataClassification = CustomerContent;
        }
        field(14021431; "NS_Schedule 1 Amount"; Decimal)
        {
            Caption = 'Schedule 1 Amount';
            DataClassification = CustomerContent;
        }
        field(14021432; "NS_Schedule 2 Amount"; Decimal)
        {
            Caption = 'Schedule 2 Amount';
            DataClassification = CustomerContent;
        }
        field(14021433; "NS_Schedule 3 Amount"; Decimal)
        {
            Caption = 'Schedule 3 Amount';
            DataClassification = CustomerContent;
        }
        field(14021434; "NS_Schedule 4 Amount"; Decimal)
        {
            Caption = 'Schedule 4 Amount';
            DataClassification = CustomerContent;
        }
        field(14021435; "NS_Schedule 5 Amount"; Decimal)
        {
            Caption = 'Schedule 5 Amount';
            DataClassification = CustomerContent;
        }
        field(14021436; "NS_Schedule 6 Amount"; Decimal)
        {
            Caption = 'Schedule 6 Amount';
            DataClassification = CustomerContent;
        }
        field(14021437; "NS_Schedule 1 Task"; Code[20])
        {
            Caption = 'Schedule 1 Task';
            DataClassification = CustomerContent;
        }
        field(14021438; "NS_Schedule 2 Task"; Code[20])
        {
            Caption = 'Schedule 2 Task';
            DataClassification = CustomerContent;
        }
        field(14021439; "NS_Schedule 3 Task"; Code[20])
        {
            Caption = 'Schedule 3 Task';
            DataClassification = CustomerContent;
        }
        field(14021440; "NS_Schedule 4 Task"; Code[20])
        {
            Caption = 'Schedule 4 Task';
            DataClassification = CustomerContent;
        }
        field(14021441; "NS_Schedule 5 Task"; Code[20])
        {
            Caption = 'Schedule 5 Task';
            DataClassification = CustomerContent;
        }
        field(14021442; "NS_Schedule 6 Task"; Code[20])
        {
            Caption = 'Schedule 6 Task';
            DataClassification = CustomerContent;
        }
        field(14021443; "NS_Contract Line Method"; Option)
        {
            Caption = 'Contract Line Method';
            OptionCaption = 'Default,Percentage,Segment';
            OptionMembers = Default,Percentage,Segment;
            DataClassification = CustomerContent;
        }
        field(14021444; "NS_Billing Job Task No."; Code[20])
        {
            Caption = 'Billing Job Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
        }
        field(14021445; "NS_Job Posting Group"; Code[10])
        {
            ObsoleteState = Pending;//PRJ-993.AS.1.0 18OCT2021
            ObsoleteReason = 'Will be removed in Next build'; //PRJ-993.AS.1.0 12OCT2021
            Caption = 'Job Posting Group';//PRJ-993.AS.1.0 18OCT2021
            DataClassification = CustomerContent;
            //TableRelation = "Job Posting Group";//PE-233.AS.2.0 COMMENT
        }
        field(14021446; "NS_Minimum Selling Price"; Decimal)
        {
            Caption = 'Minimum Selling Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4;
            Editable = false;
        }
        field(14021447; "NS_Selling Price"; Decimal)
        {
            Caption = 'Selling Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4;
        }
        field(14021448; "NS_Total Contract Price"; Decimal)
        {
            Caption = 'Total Contract Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4;
        }
        field(14021449; "NS_Minimum Selling Price G.M.%"; Decimal)
        {
            Caption = 'Minimum Selling Price G.M. %';
            DataClassification = CustomerContent;
        }
        field(14021450; "NS_Selling Price G.M. %"; Decimal)
        {
            Caption = 'Selling Price G.M. %';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021451; "NS_Total Contract Price G.M. %"; Decimal)
        {
            Caption = 'Total Contract Price G.M. %';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(14021453; "NS_Job Posting Group New"; Code[20])//PRJ-993.AS.1.0 18OCT2021 Add field "NS_Job Posting Group New"
        {
            Caption = 'Job Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Job Posting Group";
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.", NS_Revision)
        {
        }
        key(Key2; "NS_Link-to Quote No.", NS_Revision)
        {
        }
        key(Key3; "NS_Sales Quote No.")
        {
        }
        key(Key4; NS_Status, "NS_Sales Order No.")
        {
        }
        key(Key5; "NS_Created by")
        {
        }
        key(Key6; "NS_Salesperson/User ID")
        {
        }
    }

    fieldgroups
    {
    }

    procedure UnarchiveQuote(ArchQuote: Record "NS_Job Quote Header Archive");
    var
        ArchQuoteLine: Record "NS_Job Quote Line Archive";
        QuoteLine: Record "NS_Job Quote Line";
        ArchPlanLine: Record "NS_Archived QuotePlanningLine";
        PlanLine: Record "Job Planning Line";
        ArchTask: Record "NS_Archived Quote Task";
        JobTask: Record "Job Task";
        ArchSegment: Record "NS_Archived Quote Segments";
        Segment: Record "NS_Job Takeoff Segments";
        ArchSOW: Record "NS_Archived Quote ScopeofWork";
        SOW: Record "NS_Job Quote Scope of Work";
        JobQuote: Record "NS_Job Quote Header";
        QuoteMgt: Codeunit "NS_Job Quote Mgt.";
    begin
        JobQuote.INIT();
        JobQuote.TRANSFERFIELDS(ArchQuote);
        JobQuote.NS_Revision := 0;
        JobQuote."NS_Quote No." := '';
        JobQuote."NS_Duplicated-from Quote No." := ArchQuote."NS_Quote No.";
        JobQuote."NS_Revision Reference" := ArchQuote.NS_Revision;//PRJ-1163.AS.2.0
        QuoteMgt.NS_OnInsertQuote(JobQuote, true);
        JobQuote.INSERT();

        if JobQuote."NS_Shortcut Dimension 1 Code" <> '' then
            JobQuote.VALIDATE("NS_Shortcut Dimension 1 Code");
        if JobQuote."NS_Shortcut Dimension 2 Code" <> '' then
            JobQuote.VALIDATE("NS_Shortcut Dimension 2 Code");
        JobQuote.MODIFY(true);

        ArchQuoteLine.SETRANGE("NS_Quote No.", ArchQuote."NS_Quote No.");
        ArchQuoteLine.SETRANGE(NS_Revision, ArchQuote.NS_Revision);
        if ArchQuoteLine.FINDSET() then
            repeat
                QuoteLine.INIT();
                QuoteLine.TRANSFERFIELDS(ArchQuoteLine);
                QuoteLine."NS_Quote No." := JobQuote."NS_Quote No.";
                // QuoteLine.NS_Revision := 0; //PRJ-1163.AS.3.0 COMMENT
                QuoteLine.NS_Revision := JobQuote."NS_Revision Reference";//PRJ-1163.AS.3.0 ADD
                QuoteLine.INSERT();
            until ArchQuoteLine.NEXT() = 0;

        //PRJ-1163.AS.2.0 03MARCH2022 START COMMENTED FUNCTION
        // ArchPlanLine.SETRANGE("NS_Quote No.", ArchQuote."NS_Quote No.");
        // ArchPlanLine.SETRANGE(NS_Revision, ArchQuote.NS_Revision);
        // if ArchPlanLine.FINDSET() then
        //     repeat
        //         PlanLine.INIT();
        //         PlanLine.TRANSFERFIELDS(ArchPlanLine);
        //         PlanLine."NS_Quote No." := JobQuote."NS_Quote No.";
        //         PlanLine."Job No." := JobQuote."NS_Job No.";
        //         PlanLine.INSERT();
        //     until ArchPlanLine.NEXT() = 0;
        //PRJ-1163.AS.2.0 03MARCH2022 END COMMENTED FUNCTION

        ArchTask.SETRANGE("NS_Quote No.", ArchQuote."NS_Quote No.");
        ArchTask.SETRANGE(NS_Revision, ArchQuote.NS_Revision);
        if ArchTask.FINDSET() then
            repeat
                JobTask.INIT();
                JobTask.TRANSFERFIELDS(ArchTask);
                JobTask."NS_Quote No." := JobQuote."NS_Quote No.";
                JobTask."Job No." := JobQuote."NS_Job No.";
                JobTask."NS_Revision No." := JobQuote."NS_Revision Reference";
                JobTask.INSERT();
            until ArchTask.NEXT() = 0;

        NS_MoveRevisiondatatoJobPlanLine(ArchQuote, JobQuote);//PRJ-1163.AS.2.0 03MARCH2022 Added Cod

        ArchSOW.SETRANGE("NS_Quote No.", ArchQuote."NS_Quote No.");
        ArchSOW.SETRANGE(NS_Revision, ArchQuote.NS_Revision);
        if ArchSOW.FINDSET then
            repeat
                SOW.INIT();
                SOW.TRANSFERFIELDS(ArchSOW);
                SOW."NS_Quote No." := JobQuote."NS_Quote No.";
                SOW."NS_Job No." := JobQuote."NS_Job No.";
                SOW.INSERT();
            until ArchSOW.NEXT = 0;

        ArchSegment.SETRANGE("NS_Job No.", ArchQuote."NS_Quote No.");
        ArchSegment.SETRANGE(NS_Revision, ArchQuote.NS_Revision);
        if ArchSegment.FINDSET() then
            repeat
                Segment.INIT();
                // Segment.TRANSFERFIELDS(ArchSegment);//PRJ-1163.AS.2.0 03MARCH2022 COMMENTED
                //PRJ-1163.AS.2.0 03MARCH2022 - start Added code
                Segment.NS_Type := ArchSegment.NS_Type;
                Segment."NS_Job No." := JobQuote."NS_Job No.";
                Segment."NS_Segment Code" := ArchSegment."NS_Segment Code";
                Segment."NS_Size of Weld" := ArchSegment."NS_Size of Weld";
                Segment."NS_Segment Name" := ArchSegment."NS_Segment Name";
                Segment."NS_Is Total" := ArchSegment."NS_Is Total";
                Segment."NS_Weld Time (Hours)" := ArchSegment."NS_Weld Time (Hours)";
                Segment.NS_Default := ArchSegment.NS_Default;
                Segment."NS_Schedule (Total Cost)" := ArchSegment."NS_Schedule (Total Cost)";
                Segment."NS_Schedule (Total Price)" := ArchSegment."NS_Schedule (Total Price)";
                Segment."NS_Remaining (Total Cost)" := ArchSegment."NS_Remaining (Total Cost)";
                Segment."NS_Remaining (Total Price)" := ArchSegment."NS_Remaining (Total Price)";
                Segment."NS_Amt. Rcd. Not Invoiced" := ArchSegment."NS_Amt. Rcd. Not Invoiced";
                Segment."NS_Mark-up" := ArchSegment."NS_Mark-up";
                Segment."NS_Gross Profit" := ArchSegment."NS_Gross Profit";
                Segment."NS_Gross Profit Percent" := ArchSegment."NS_Gross Profit Percent";
                Segment."NS_Line Amount Incl. Tax" := ArchSegment."NS_Line Amount Incl. Tax";
                Segment."NS_Total Contract Price" := ArchSegment."NS_Total Contract Price";
                Segment."NS_Template No." := ArchSegment."NS_Template No.";
                Segment."NS_Work Units" := ArchSegment."NS_Work Units";
                Segment."NS_Work Unit of Measure" := ArchSegment."NS_Work Unit of Measure";
                Segment.INSERT;
            //PRJ-1163.AS.2.0 03MARCH2022 - end Added code
            until ArchSegment.NEXT() = 0;


        MESSAGE('Job Quote: ' + JobQuote."NS_Quote No." + ' has been successfully created');
    end;


    //PRJ-1163.AS.2.0 03MARCH2022 - start Function to move ArchiveJPL data to JPL data
    procedure NS_MoveRevisiondatatoJobPlanLine(qQuoteHeader_L: Record "NS_Job Quote Header Archive"; qQuotHdrT: Record "NS_Job Quote Header");
    var
        PlanLine_L: Record "Job Planning Line";
        ArchivePlanLine_L: Record "NS_Archived QuotePlanningLine";
        PLLine: Record "Job Planning Line";
    begin
        ArchivePlanLine_L.RESET;
        ArchivePlanLine_L.SetCurrentKey("NS_Job No.", "NS_Job Task No.", "NS_Line No.");
        ArchivePlanLine_L.SETRANGE("NS_Job No.", qQuoteHeader_L."NS_Job No.");
        ArchivePlanLine_L.SetRange(NS_Revision, qQuoteHeader_L.NS_Revision);
        if ArchivePlanLine_L.FINDSET then
            repeat
                PlanLine_L.INIT;
                PlanLine_L."Job No." := qQuotHdrT."NS_Job No.";
                PlanLine_L."Job Task No." := ArchivePlanLine_L."NS_Job Task No.";
                PlanLine_L."Line No." := ArchivePlanLine_L."NS_Line No.";
                //PlanLine_L."NS_Quote No." := ArchivePlanLine_L."NS_Quote No.";//girish
                PlanLine_L.Description := ArchivePlanLine_L.NS_Description;
                PlanLine_L."Description 2" := ArchivePlanLine_L."NS_Description 2";
                PlanLine_L."Planning Date" := ArchivePlanLine_L."NS_Planning Date";
                PlanLine_L."Planning Due Date" := ArchivePlanLine_L."NS_Planning Date";
                PlanLine_L."Planned Delivery Date" := ArchivePlanLine_L."NS_Planned Delivery Date";
                PlanLine_L."Document No." := ArchivePlanLine_L."NS_Document No.";
                PlanLine_L.Type := ArchivePlanLine_L.NS_Type;
                PlanLine_L."No." := ArchivePlanLine_L."NS_No.";
                PlanLine_L.Description := ArchivePlanLine_L.NS_Description;
                PlanLine_L.Quantity := ArchivePlanLine_L.NS_Quantity;
                PlanLine_L."Direct Unit Cost (LCY)" := ArchivePlanLine_L."NS_Direct Unit Cost (LCY)";
                PlanLine_L."Unit Cost (LCY)" := ArchivePlanLine_L."NS_Unit Cost (LCY)";
                PlanLine_L."Total Cost (LCY)" := ArchivePlanLine_L."NS_Total Cost (LCY)";
                PlanLine_L."Unit Price (LCY)" := ArchivePlanLine_L."NS_Unit Price (LCY)";
                PlanLine_L."Total Price (LCY)" := ArchivePlanLine_L."NS_Total Price (LCY)";
                PlanLine_L."Resource Group No." := ArchivePlanLine_L."NS_Resource Group No.";
                PlanLine_L."Unit of Measure Code" := ArchivePlanLine_L."NS_Unit of Measure Code";
                PlanLine_L."Location Code" := ArchivePlanLine_L."NS_Location Code";
                PlanLine_L."Last Date Modified" := ArchivePlanLine_L."NS_Last Date Modified";
                PlanLine_L."User ID" := ArchivePlanLine_L."NS_User ID";
                PlanLine_L."Work Type Code" := ArchivePlanLine_L."NS_Work Type Code";
                PlanLine_L."Customer Price Group" := ArchivePlanLine_L."NS_Customer Price Group";
                PlanLine_L."Country/Region Code" := ArchivePlanLine_L."NS_Country/Region Code";
                PlanLine_L."Gen. Bus. Posting Group" := ArchivePlanLine_L."NS_Gen. Bus. Posting Group";
                PlanLine_L."Gen. Prod. Posting Group" := ArchivePlanLine_L."NS_Gen. Prod. Posting Group";
                PlanLine_L."Document Date" := ArchivePlanLine_L."NS_Document Date";
                PlanLine_L."Job Task No." := ArchivePlanLine_L."NS_Job Task No.";
                PlanLine_L."Line Amount (LCY)" := ArchivePlanLine_L."NS_Line Amount (LCY)";
                PlanLine_L."Unit Cost" := ArchivePlanLine_L."NS_Unit Cost";
                PlanLine_L."Total Cost" := ArchivePlanLine_L."NS_Total Cost";
                PlanLine_L."Unit Price" := ArchivePlanLine_L."NS_Unit Price";
                PlanLine_L."Total Price" := ArchivePlanLine_L."NS_Total Price";
                PlanLine_L."Line Amount" := ArchivePlanLine_L."NS_Line Amount";
                PlanLine_L."Line Discount Amount" := ArchivePlanLine_L."NS_Line Discount Amount";
                PlanLine_L."Cost Factor" := ArchivePlanLine_L."NS_Cost Factor";
                PlanLine_L."Serial No." := ArchivePlanLine_L."NS_Serial No.";
                PlanLine_L."Lot No." := ArchivePlanLine_L."NS_Lot No.";
                PlanLine_L."Line Discount %" := ArchivePlanLine_L."NS_Line Discount %";
                PlanLine_L."Line Type" := ArchivePlanLine_L."NS_Line Type";
                PlanLine_L."Currency Code" := ArchivePlanLine_L."NS_Currency Code";
                PlanLine_L."Currency Date" := ArchivePlanLine_L."NS_Currency Date";
                PlanLine_L."Currency Factor" := ArchivePlanLine_L."NS_Currency Factor";
                PlanLine_L."Schedule Line" := ArchivePlanLine_L."NS_Schedule Line";
                PlanLine_L."Contract Line" := ArchivePlanLine_L."NS_Contract Line";
                PlanLine_L."Job Contract Entry No." := ArchivePlanLine_L."NS_Job Contract Entry No.";
                PlanLine_L."Invoiced Amount (LCY)" := ArchivePlanLine_L."NS_Invoiced Amount (LCY)";
                PlanLine_L."Invoiced Cost Amount (LCY)" := ArchivePlanLine_L."NS_Invoiced Cost Amount (LCY)";
                PlanLine_L."VAT Unit Price" := ArchivePlanLine_L."NS_VAT Unit Price";
                PlanLine_L."Line Discount Amount" := ArchivePlanLine_L."NS_VAT Line Discount Amount";
                PlanLine_L."VAT Line Amount" := ArchivePlanLine_L."NS_VAT Line Amount";
                PlanLine_L."VAT %" := ArchivePlanLine_L."NS_VAT %";
                PlanLine_L."Description 2" := ArchivePlanLine_L."NS_Description 2";
                //PlanLine_L."Job Ledger Entry No." := ArchivePlanLine_L."NS_Job Ledger Entry No.";
                PlanLine_L.Status := ArchivePlanLine_L.NS_Status;
                PlanLine_L."Ledger Entry Type" := ArchivePlanLine_L."NS_Ledger Entry Type";
                PlanLine_L."Ledger Entry No." := ArchivePlanLine_L."NS_Ledger Entry No.";
                PlanLine_L."System-Created Entry" := ArchivePlanLine_L."NS_System-Created Entry";
                PlanLine_L."Usage Link" := ArchivePlanLine_L."NS_Usage Link";
                PlanLine_L."Remaining Qty." := ArchivePlanLine_L."NS_Remaining Qty.";
                PlanLine_L."Remaining Qty. (Base)" := ArchivePlanLine_L."NS_Remaining Qty. (Base)";
                PlanLine_L."Remaining Total Cost" := ArchivePlanLine_L."NS_Remaining Total Cost";
                PlanLine_L."Remaining Total Cost (LCY)" := ArchivePlanLine_L."NS_Remaining Total Cost (LCY)";
                PlanLine_L."Remaining Line Amount" := ArchivePlanLine_L."NS_Remaining Line Amount";
                PlanLine_L."Remaining Line Amount (LCY)" := ArchivePlanLine_L."NS_Remaining Line Amount (LCY)";
                PlanLine_L."Qty. Posted" := ArchivePlanLine_L."NS_Qty. Posted";
                PlanLine_L."Qty. to Transfer to Journal" := ArchivePlanLine_L."NS_Qty. to Transfer to Journal";
                PlanLine_L."Posted Total Cost" := ArchivePlanLine_L."NS_Posted Total Cost";
                PlanLine_L."Posted Total Cost (LCY)" := ArchivePlanLine_L."NS_Posted Total Cost (LCY)";
                PlanLine_L."Posted Line Amount" := ArchivePlanLine_L."NS_Posted Line Amount";
                PlanLine_L."Posted Line Amount (LCY)" := ArchivePlanLine_L."NS_Posted Line Amount (LCY)";
                PlanLine_L."Qty. Transferred to Invoice" := ArchivePlanLine_L."NS_Qty. Transferred to Invoice";
                PlanLine_L."Qty. to Transfer to Invoice" := ArchivePlanLine_L."NS_Qty. to Transfer to Invoice";
                PlanLine_L."Qty. Invoiced" := ArchivePlanLine_L."NS_Qty. Invoiced";
                PlanLine_L."Qty. to Invoice" := ArchivePlanLine_L."NS_Qty. to Invoice";
                PlanLine_L."Reserved Quantity" := ArchivePlanLine_L."NS_Reserved Quantity";
                PlanLine_L."Reserved Qty. (Base)" := ArchivePlanLine_L."NS_Reserved Qty. (Base)";
                PlanLine_L.Reserve := ArchivePlanLine_L.NS_Reserve;
                PlanLine_L.Planned := ArchivePlanLine_L.NS_Planned;
                PlanLine_L."Variant Code" := ArchivePlanLine_L."NS_Variant Code";
                PlanLine_L."Bin Code" := ArchivePlanLine_L."NS_Bin Code";
                PlanLine_L."Qty. per Unit of Measure" := ArchivePlanLine_L."NS_Qty. per Unit of Measure";
                PlanLine_L."Quantity (Base)" := ArchivePlanLine_L."NS_Quantity (Base)";
                PlanLine_L."Requested Delivery Date" := ArchivePlanLine_L."NS_Requested Delivery Date";
                PlanLine_L."Promised Delivery Date" := ArchivePlanLine_L."NS_Promised Delivery Date";
                PlanLine_L."Planned Delivery Date" := ArchivePlanLine_L."NS_Planned Delivery Date";
                PlanLine_L."Service Order No." := ArchivePlanLine_L."NS_Service Order No.";
                PlanLine_L."NS_Cost Category" := ArchivePlanLine_L."NS_Cost Category";
                PlanLine_L."NS_Revenue Category" := ArchivePlanLine_L."NS_Revenue Category";
                PlanLine_L."NS_Cost Factor Set By Category" := ArchivePlanLine_L."NS_Cost Factor Set By Category";
                PlanLine_L."NS_Shortcut Dimension 1 Code" := ArchivePlanLine_L."NS_Shortcut Dimension 1 Code";
                PlanLine_L."NS_Shortcut Dimension 2 Code" := ArchivePlanLine_L."NS_Shortcut Dimension 2 Code";
                PlanLine_L."NS_Activity Code" := ArchivePlanLine_L."NS_Activity Code";
                PlanLine_L."NS_Process Code" := ArchivePlanLine_L."NS_Process Code";
                PlanLine_L."NS_Operation Code" := ArchivePlanLine_L."NS_Operation Code";
                PlanLine_L."NS_Section Code" := ArchivePlanLine_L."NS_Section Code";
                PlanLine_L."NS_Work Units" := ArchivePlanLine_L."NS_Work Units";
                PlanLine_L."NS_Work Unit of Measure" := ArchivePlanLine_L."NS_Work Unit of Measure";
                PlanLine_L."NS_Skill Class" := ArchivePlanLine_L."NS_Skill Class";
                PlanLine_L."NS_Entry Type" := ArchivePlanLine_L."NS_Entry Type";
                PlanLine_L."NS_Adjustment" := ArchivePlanLine_L.NS_Adjustment;
                PlanLine_L."NS_Rate Type" := ArchivePlanLine_L."NS_Rate Type";
                PlanLine_L."NS_Rate Type Value" := ArchivePlanLine_L."NS_Rate Type Value";
                PlanLine_L."NS_Not To Exceed" := ArchivePlanLine_L."NS_Not To Exceed";
                PlanLine_L."NS_Subcontract No." := ArchivePlanLine_L."NS_Subcontract No.";
                PlanLine_L."NS_Subcontract Line No." := ArchivePlanLine_L."NS_Subcontract Line No.";
                PlanLine_L."NS_Progress Billing Method" := ArchivePlanLine_L."NS_Progress Billing Method";
                PlanLine_L."NS_Progress Payment Method" := ArchivePlanLine_L."NS_Progress Payment Method";
                PlanLine_L.NS_TempNo := ArchivePlanLine_L.NS_TempNo;
                PlanLine_L.NS_TempLocation := ArchivePlanLine_L.NS_TempLocation;
                PlanLine_L.NS_TempVariant := ArchivePlanLine_L.NS_TempVariant;
                PlanLine_L.NS_TempUM := ArchivePlanLine_L.NS_TempUM;
                PlanLine_L.NS_TempWorkType := ArchivePlanLine_L.NS_TempWorkType;
                PlanLine_L.NS_TempSkillClass := ArchivePlanLine_L.NS_TempSkillClass;
                PlanLine_L.NS_Welding := ArchivePlanLine_L.NS_Welding;
                PlanLine_L."NS_Size of Weld" := ArchivePlanLine_L."NS_Size of Weld";
                PlanLine_L."NS_Weld Time (Hours)" := ArchivePlanLine_L."NS_Weld Time (Hours)";
                PlanLine_L."NS_No. 2" := ArchivePlanLine_L."NS_No. 2";
                PlanLine_L."NS_Quote No." := qQuotHdrT."NS_Quote No.";
                PlanLine_L."NS_Quote Line No." := ArchivePlanLine_L."NS_Quote Line No.";
                PlanLine_L."NS_Purchase Order No." := ArchivePlanLine_L."NS_Purchase Order No.";
                PlanLine_L."NS_Use Tax SKU" := ArchivePlanLine_L."NS_Use Tax SKU";
                PlanLine_L."NS_Use Tax Amount" := ArchivePlanLine_L."NS_Use Tax Amount";
                PlanLine_L."NS_Vendor No." := ArchivePlanLine_L."NS_Vendor No.";
                PlanLine_L."NS_Vendor Quote No." := ArchivePlanLine_L."NS_Vendor Quote No.";
                PlanLine_L."NS_Manufacturer Code" := ArchivePlanLine_L."NS_Manufacturer Code";
                PlanLine_L."NS_Defaulted Entry" := ArchivePlanLine_L."NS_Defaulted Entry";
                PlanLine_L."NS_Gross Profit" := ArchivePlanLine_L."NS_Gross Profit";
                PlanLine_L."NS_Total Number of Welds" := ArchivePlanLine_L."NS_Total Number of Welds";
                PlanLine_L."NS_Gross Profit Percentage" := ArchivePlanLine_L."NS_Gross Profit Percentage";
                PlanLine_L."NS_Original Total Price" := ArchivePlanLine_L."NS_Original Total Price";
                PlanLine_L."NS_Original Total Price (LCY)" := ArchivePlanLine_L."NS_Original Total Price (LCY)";
                PlanLine_L."NS_Original Quantity" := ArchivePlanLine_L."NS_Original Quantity";
                PlanLine_L."NS_Item Not Found" := ArchivePlanLine_L."NS_Item Not Found";
                PlanLine_L."NS_Segment Type" := ArchivePlanLine_L."NS_Segment Type";
                PlanLine_L."NS_Segment Code" := ArchivePlanLine_L."NS_Segment Code";
                PlanLine_L."NS_Segment Name" := ArchivePlanLine_L."NS_Segment Name";
                PlanLine_L."NS_Matrix Updated" := ArchivePlanLine_L."NS_Matrix Updated";
                PlanLine_L."NS_Progress Billing Line" := ArchivePlanLine_L."NS_Progress Billing Line";
                PlanLine_L."NS_Dimension Set ID" := ArchivePlanLine_L."NS_Dimension Set ID";
                PlanLine_L."NS_Retention Ledger Code" := ArchivePlanLine_L."NS_Retention Ledger Code";
                PlanLine_L."NS_Line Amount Incl. Tax" := ArchivePlanLine_L."NS_Line Amount Incl. Tax";
                PlanLine_L.Insert();
            //end;
            until ArchivePlanLine_L.NEXT = 0;
    end;
    //PRJ-1163.AS.2.0 03MARCH2022 - end
}

