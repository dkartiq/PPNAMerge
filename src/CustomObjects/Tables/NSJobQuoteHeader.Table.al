table 14021402 "NS_Job Quote Header"
{
    // "a3b03edf-3f59-46a5-9644-a1f4a6b1d289"
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    //PRJ-301.MS.1.0 change length from 50 to 100
    //PRJ-398.AM.1.0 8OCT2020 | Commented Table relation Property of Job No. field
    // +------------------------------------------------------------
    //PRJ-867.GK.1.0 18Aug2021 - Sales person length to be increased
    //PRJ-933.JS.1.0 05OCT2021 | Add one field and code change
    //PRJ-993.AS.1.0 18OCT2021 Add new field "NS_Job Posting Group New" and obslete pending old field "NS_Job Posting Group"


    Caption = 'Quote Header';
    DrillDownPageID = "NS_Job Quote List";
    LookupPageID = "NS_Job Quote List";

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

            trigger OnValidate();
            begin
                "NS_Job Description" := "NS_Description/Nickname";
            end;
        }
        field(16; "NS_Quote Type Code"; Code[10])
        {
            Caption = 'Quote Type Code';
            TableRelation = "NS_Job Quote Type";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                "NS_Job Type Code" := "NS_Quote Type Code";
            end;
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
            TableRelation = "Shipment Method";
            DataClassification = CustomerContent;
        }
        field(29; "NS_Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateShortcutDimCode(Rec, 1, "NS_Shortcut Dimension 1 Code");
            end;
        }
        field(30; "NS_Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_ValidateShortcutDimCode(Rec, 2, "NS_Shortcut Dimension 2 Code");
            end;
        }
        field(50; "NS_Equipment Only"; Boolean)
        {
            Caption = 'Equipment Only';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateEquipmentOnly(Rec);
            end;
        }
        field(51; "NS_Proposal Date"; Date)
        {
            Caption = 'Proposal Date';
            DataClassification = CustomerContent;
        }
        field(61; NS_Status; Option)
        {
            Caption = 'Status';
            // >> Upgrade
            // OptionCaption = 'Open,,,,Inactive,,,,Review,,,,Released,,,,Accepted,,,,Closed';
            // OptionMembers = Open,,,,Inactive,,,,Review,,,,Released,,,,Accepted,,,,Closed;
            OptionMembers = Created,,,,"On Hold","Off Hold Pending WF",,Go,"Estimate Pending WF","Estimate Approved","Response Pending WF","Response Approved",Submitted,,,"Award Pending WF",Awarded,,,"Won Pending WF",Closed,,,Won,Lost;
            OptionCaption = 'Created,,,,On Hold,Off Hold Pending WF,,Go,Estimate Pending WF,Estimate Approved,Response Pending WF,Response Approved,Submitted,,,Award Pending WF,Awarded,,,Won Pending WF,Closed,,,Won,Lost';
            // << Upgrade
            DataClassification = CustomerContent;
        }
        field(66; "NS_Probability to Close"; Option)
        {
            Caption = 'Probability to Close';
            DataClassification = CustomerContent;
            // >> Upgrade
            //OptionCaption = 'Draft,Budget Only,25,,,50,,75,,90,100,,,,,,,,,,Lost,,,,,,,,,,Canceled,,,,,,,Opportunity';
            OptionCaption = '10 - Feasibility Pricing Submitted,25 - Budget Quote Submitted,50 - FBS Shortlisted for Project,,,50,,75 - FBS Nominated as Preferred Supplier,,90 - Letter of Award Issued/Verbal Award,100 - Project Won - FBS has Award Documentation,,,,,,,,,,0 - Project Lost,,,,,,,,,,Canceled,,,,,,,Opportunity';
            // OptionMembers = Draft,"Budget Only","25",,,"50",,"75",,"90","100",,,,,,,,,,Lost,,,,,,,,,,Canceled,,,,,,,Opportunity;
            // << Upgrade
            OptionMembers = "10 - Feasibility Pricing Submitted","25 - Budget Quote Submitted","50 - FBS Shortlisted for Project",,,"50",,"75 - FBS Nominated as Preferred Supplier",,"90 - Letter of Award Issued/Verbal Award","100 - Project Won - FBS has Award Documentation",,,,,,,,,,"0 - Project Lost",,,,,,,,,,Canceled,,,,,,,Opportunity;
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
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate();
            var
            //lCust: Record Customer;
            //lCust2: Record Customer;
            begin
                QuoteMgt.NS_OnValidateSelltoCustomerJQ(Rec);
            end;
        }
        field(102; "NS_Sell-to Customer Name"; Text[100]) //PRJ-301.MS.1.0
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

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateBillToCustomer(Rec);
            end;
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

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateUseTaxLiable(Rec);
            end;
        }
        field(112; "NS_Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(113; "NS_Bill-to Address"; Text[100])	//PRJ-301.MS.1.0
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
            TableRelation = IF ("NS_Bill-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("NS_Bill-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("NS_Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(
                  "NS_Bill-to City", "NS_Bill-to Post Code", "NS_Bill-to County", "NS_Bill-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
        }
        field(116; "NS_Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
            DataClassification = CustomerContent;
        }
        field(117; "NS_Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = IF ("NS_Bill-to Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("NS_Bill-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("NS_Bill-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode(
                  "NS_Bill-to City", "NS_Bill-to Post Code", "NS_Bill-to County", "NS_Bill-to Country/Region Code", (CurrFieldNo <> 0) and GUIALLOWED);
            end;
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
            TableRelation = "Payment Terms";
            DataClassification = CustomerContent;
        }
        field(141; "NS_Salesperson Code"; Code[10]) //PRJ-867.GK.1.0 18Aug2021 //PRJ-867.AS.1.0 23SEPT2021 Rollback code done by GK
        {
            ObsoleteState = Pending;//PRJ-867.AS.1.0 23SEPT2021
            ObsoleteReason = 'Will be removed in Next Build';//PRJ-867.AS.1.0 23SEPT2021
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateSalespersonCode(Rec);
            end;
        }
        field(142; "NS_Salesperson Code New"; Code[20])//PRJ-867.AS.1.0 23SEPT2021 Add New field
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateSalespersonCode(Rec);
            end;
        }
        field(161; "NS_Contact No."; Code[20])
        {

            Caption = 'Contact No.';
            //TableRelation = Contact; //PRJ-896.GK.1.0 08Sep2021--comment code
            DataClassification = CustomerContent;
            //PRJ-896.GK.1.0 08Sep2021 start
            trigger OnLookup()
            var
                Cust: Record Customer;
                // >> Upgrade
                Contact: Record Contact;
                ContactBusinessRelation: Record "Contact Business Relation";
            // << Upgrade
            begin
                // >> Upgrade
                // if ("NS_Contact No." <> '') and Cont.Get("NS_Contact No.") then
                //     Cont.SetRange("Company No.", Cont."Company No.")
                // else
                //     if Cust.Get("NS_Sell-to Customer No.") then begin
                //         if ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer, "NS_Sell-to Customer No.") then
                //             Cont.SetRange("Company No.", ContBusinessRelation."Contact No.");
                //     end else
                //         Cont.SetFilter("Company No.", '<>%1', '''');

                // if "NS_Contact No." <> '' then
                //     if Cont.Get("NS_Contact No.") then;
                // if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                //     xRec := Rec;
                //     Validate("NS_Contact No.", Cont."No.");
                // end;
                //FDD104 Start
                Contact.SetRange(Type, Contact.Type::Person);

                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", "NS_Sell-to Customer No.");
                ContactBusinessRelation.SetFilter("Contact No.", '<>%1', '');
                if ContactBusinessRelation.FindFirst then
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");

                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("NS_Contact No.", Contact."No.");
                //FDD104 End
                // << Upgrade
            end;
            //PRJ-896.GK.1.0 08Sep2021 end

            trigger OnValidate();
            // >> Upgrade
            var
                Opportunity: Record Opportunity;
            // << Upgrade
            begin
                QuoteMgt.NS_OnValidateContactNo(Rec);
                // >> Upgrade
                // #167 Start
                Modify(true);
                if Opportunity.Get("NS_Quote No.") and (Opportunity."Contact No." <> "NS_Contact No.") then begin
                    Opportunity.Validate("Contact No.", "NS_Contact No.");
                    Opportunity.Modify(true);
                end;
                // #167 End
                // << Upgrade
            end;
        }
        field(162; "NS_Contact Name"; Text[100])  //PRJ-301.MS.1.0
        {
            Caption = 'Contact Name';
            DataClassification = CustomerContent;
        }
        field(201; "NS_Job No."; Code[20])
        {
            Caption = 'Job No.';
            //TableRelation = Job;//PRJ-398.AM.1.0 Orignal code commented
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateJobNo(Rec);
            end;
        }
        field(206; "NS_Job Type"; Option)
        {
            Caption = 'Job Type';
            DataClassification = CustomerContent;
            OptionCaption = '" ,Construction,Equipment,Service"';
            OptionMembers = " ",Construction,Equipment,Service;
        }
        field(301; "NS_Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Quote));
            DataClassification = CustomerContent;
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

            trigger OnLookup();
            begin
                QuoteMgt.NS_ShowDocDim(Rec);
            end;
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

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateOwnerNo(Rec);
            end;
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

            trigger OnValidate();
            begin
                QuoteMgt.NS_GetName(DATABASE::"NS_Job Quote Header"
                                , FIELDNO("NS_General Contractor No.")
                                , "NS_General Contractor No."
                                , "NS_General Contractor Name");
            end;
        }
        // >> Upgrade
        //field(1011; "NS_General Contractor Name"; Text[50])
        field(1011; "NS_General Contractor Name"; Text[100])
        // << Upgrade
        {
            Caption = 'General Contractor Name';
            DataClassification = CustomerContent;
        }
        field(1020; "NS_Architect/Engineer No."; Code[20])
        {
            Caption = 'Architect/Engineer No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_GetName(DATABASE::"NS_Job Quote Header"
                                , FIELDNO("NS_Architect/Engineer No.")
                                , "NS_Architect/Engineer No."
                                , "NS_Architect/Engineer Name");
            end;
        }
        field(1021; "NS_Architect/Engineer Name"; Text[50])
        {
            Caption = 'Architect/Engineer Name';
            DataClassification = CustomerContent;
        }
        field(1030; "NS_Project Manager No."; Code[20])
        {
            Caption = 'Project Manager No.';
            TableRelation = Resource."No." WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_GetName(DATABASE::"NS_Job Quote Header"
                                , FIELDNO("NS_Project Manager No.")
                                , "NS_Project Manager No."
                                , "NS_Project Manager Name");
            end;
        }
        field(1031; "NS_Project Manager Name"; Text[100]) //PRJ-301.MS.1.0
        {
            Caption = 'Project Manager Name';
            DataClassification = CustomerContent;
        }
        field(1040; "NS_Estimator No."; Code[20])
        {
            Caption = 'Estimator No.';
            TableRelation = Resource."No." WHERE(Type = CONST(Person));
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                QuoteMgt.NS_OnValidateEstimatorNo(Rec);
            end;
        }
        field(1041; "NS_Estimator Name"; Text[100])	//PRJ-301.MS.1.0
        {
            Caption = 'Estimator Name';
            DataClassification = CustomerContent;
        }
        // >> Upgrade
        field(1042; "Installation Estimator No."; Code[20])
        {
            Caption = 'Installation Estimator No.';
            Description = 'FDD101';
            TableRelation = "Salesperson/Purchaser";
        }
        field(1043; "Installation Estimator Name"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Installation Estimator No.")));
            Caption = 'Installation Estimator Name';
            Description = 'FDD101';
            Editable = false;
            FieldClass = FlowField;
        }
        // << Upgrade
        field(1046; "NS_Date Submitted to Estimator"; Date)
        {
            Caption = 'Date Submitted to Estimator';
            DataClassification = CustomerContent;
        }
        field(1051; "NS_Job Class"; Option)
        {
            Caption = 'Job Class';
            OptionCaption = ' ,Master Job,SubJob,Change Order,Extra Work,Proposed';
            OptionMembers = " ","Master Job",SubJob,"Change Order","Extra Work",Proposed;
            DataClassification = CustomerContent;
        }
        field(1052; "NS_Sub-Level to Job No."; Code[20])
        {
            Caption = 'Sub-Level to Job No.';
            TableRelation = Job;
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            //NS_JobNew: Record Job;
            begin
            end;
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
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
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
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
        }
        field(1307; "NS_Use Tax Qualify Response 7"; Option)
        {
            Caption = 'Use Tax Qualify Response 7';
            OptionCaption = '" ,No,Yes"';
            OptionMembers = " ",No,Yes;
            DataClassification = CustomerContent;
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
            InitValue = Commercial;
            OptionCaption = '" ,Commercial,Residential"';
            OptionMembers = " ",Commercial,Residential;
            DataClassification = CustomerContent;
        }
        field(1354; "NS_Use Tax- Project Type"; Option)
        {
            Caption = 'Project Type';
            OptionCaption = '" ,New,Remodel,Repair"';
            OptionMembers = " ",New,Remodel,Repair;
            DataClassification = CustomerContent;
        }
        field(1355; "NS_Use Tax- DownstrContStatus"; Option)
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
        field(1358; "NS_Use Tax-PotentProjExempt."; Option)
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

            trigger OnValidate();
            var
                JobPlanLine: Record "Job Planning Line";
                //UseTaxableAmt: Decimal;
                UseTaxAreaTbl: Record "NS_Use Quote Tax Area";
            begin
                JobPlanLine.RESET();
                JobPlanLine.SETRANGE("Job No.", "NS_Job No.");
                JobPlanLine.SETRANGE(Type, JobPlanLine.Type::Item);
                JobPlanLine.CALCSUMS("Total Cost");
                if UseTaxAreaTbl.GET("NS_Use Tax Code") then
                    "NS_Use Tax Amount" := JobPlanLine."Total Cost" * (UseTaxAreaTbl."NS_Use Tax Percentage" / 100);
            end;
        }
        field(1360; "NS_Use Tax %"; Decimal)
        {
            Caption = 'Use Tax %';
            Editable = false;
            FieldClass = Normal;
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
            OptionCaption = ' ,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';//PRJ-464.AM.1.0
            OptionMembers = " ",Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec;
            DataClassification = CustomerContent;
        }
        field(1802; "NS_Estimated Month to Bill"; Option)
        {
            Caption = 'Estimated Month to Bill';
            OptionCaption = ' ,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';//PRJ-464.AM.1.0
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
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(5002; "NS_Created at Date"; Date)
        {
            Caption = 'Created at Date';
            DataClassification = CustomerContent;
            // >> Upgrade
            Editable = false;
            // << Upgrade
        }
        field(5003; "NS_Created at Time"; Time)
        {
            Caption = 'Created at Time';
            DataClassification = CustomerContent;
            // >> Upgrade
            Editable = false;
            // << Upgrade
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
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            // >> Upgrade
            Editable = false;
            // << Upgrade
        }
        field(5012; "NS_Modified at Date"; Date)
        {
            Caption = 'Modified at Date';
            DataClassification = CustomerContent;
            // >> Upgrade
            Editable = false;
            // << Upgrade
        }
        field(5013; "NS_Modified at Time"; Time)
        {
            Caption = 'Modified at Time';
            DataClassification = CustomerContent;
            // >> Upgrade
            Editable = false;
            // << Upgrade
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
            TableRelation = "Customer Template";
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
            TableRelation = "Customer Template";
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
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
            DataClassification = CustomerContent;
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
        field(10141; "NS_Salesperson Name"; Text[50])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("NS_Salesperson Code New")));//PRJ-867.AS.1.0 23SEPT2021 Changed field Sales Person code to Sales person code New
            Caption = 'Salesperson Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10201; "NS_Job Description"; Text[100]) //PRJ-301.MS.1.0
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
        // >> Upgrade
        field(14021160; "Customer Job No."; Text[30])
        {
            Caption = 'Customer Job No.';
            Description = 'ProjectPro Customer Interface Data';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //>>TG060818
                "Customer Job No." := UPPERCASE("Customer Job No.");
                //<<TG060818
            end;
        }
        // << Upgrade
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

            trigger OnValidate();
            begin
                if "NS_Schedule 1 Description" <> xRec."NS_Schedule 1 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021419; "NS_Schedule 2 Description"; Text[50])
        {
            Caption = 'Schedule 2 Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Schedule 2 Description" <> xRec."NS_Schedule 2 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021420; "NS_Schedule 3 Description"; Text[50])
        {
            Caption = 'Schedule 3 Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Schedule 3 Description" <> xRec."NS_Schedule 3 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021421; "NS_Schedule 4 Description"; Text[50])
        {
            Caption = 'Schedule 4 Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if "NS_Schedule 4 Description" <> xRec."NS_Schedule 4 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021422; "NS_Schedule 1 Percentage"; Decimal)
        {
            Caption = 'Schedule 1 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            //lPlanningLine: Record "Job Planning Line";
            //lPlanningLine2: Record "Job Planning Line";
            //x: Integer;
            begin
                if ("NS_Schedule 1 Percentage" <> xRec."NS_Schedule 1 Percentage") and ("NS_Schedule 1 Task" <> '') then begin
                    NS_TestPctTotal(1, "NS_Schedule 1 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 1 Task", 1, STRPOS("NS_Schedule 1 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 1 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 1 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021423; "NS_Schedule 2 Percentage"; Decimal)
        {
            Caption = 'Schedule 2 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            begin
                if ("NS_Schedule 2 Percentage" <> xRec."NS_Schedule 2 Percentage") and ("NS_Schedule 2 Task" <> '') then begin
                    NS_TestPctTotal(2, "NS_Schedule 2 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 2 Task", 1, STRPOS("NS_Schedule 2 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 2 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 2 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021424; "NS_Schedule 3 Percentage"; Decimal)
        {
            Caption = 'Schedule 3 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            begin
                if ("NS_Schedule 3 Percentage" <> xRec."NS_Schedule 3 Percentage") and ("NS_Schedule 3 Task" <> '') then begin
                    NS_TestPctTotal(3, "NS_Schedule 3 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 3 Task", 1, STRPOS("NS_Schedule 3 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 3 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 3 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021425; "NS_Schedule 4 Percentage"; Decimal)
        {
            Caption = 'Schedule 4 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            begin
                if ("NS_Schedule 4 Percentage" <> xRec."NS_Schedule 4 Percentage") and ("NS_Schedule 4 Task" <> '') then begin
                    NS_TestPctTotal(4, "NS_Schedule 4 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 4 Task", 1, STRPOS("NS_Schedule 4 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 4 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 4 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021426; "NS_Schedule 5 Description"; Text[50])
        {
            Caption = 'Schedule 5 Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            //QuoteTaskLines: Record "Job Task";
            begin
                if "NS_Schedule 5 Description" <> xRec."NS_Schedule 5 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021427; "NS_Schedule 6 Description"; Text[50])
        {
            Caption = 'Schedule 6 Description';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
            //QuoteTaskLines: Record "Job Task";
            begin
                if "NS_Schedule 6 Description" <> xRec."NS_Schedule 6 Description" then
                    NS_UpdateContractPlanningLine();
            end;
        }
        field(14021428; "NS_Schedule 5 Percentage"; Decimal)
        {
            Caption = 'Schedule 5 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            begin
                if ("NS_Schedule 5 Percentage" <> xRec."NS_Schedule 5 Percentage") and ("NS_Schedule 5 Task" <> '') then begin
                    NS_TestPctTotal(5, "NS_Schedule 5 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 5 Task", 1, STRPOS("NS_Schedule 5 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 5 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 5 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021429; "NS_Schedule 6 Percentage"; Decimal)
        {
            Caption = 'Schedule 6 Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                QuoteTaskLines: Record "Job Task";
            begin
                if ("NS_Schedule 6 Percentage" <> xRec."NS_Schedule 6 Percentage") and ("NS_Schedule 6 Task" <> '') then begin
                    NS_TestPctTotal(6, "NS_Schedule 6 Percentage");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 6 Task", 1, STRPOS("NS_Schedule 6 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 6 Amount" := ROUND(QuoteTaskLines."Schedule (Total Price)" * ("NS_Schedule 6 Percentage" / 100));
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
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

            trigger OnValidate();
            begin
                if ("NS_Schedule 1 Amount" <> xRec."NS_Schedule 1 Amount") and ("NS_Schedule 1 Task" <> '') then begin
                    NS_TestSOWAmount(1, "NS_Schedule 1 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 1 Task", 1, STRPOS("NS_Schedule 1 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 1 Percentage" := ROUND("NS_Schedule 1 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021432; "NS_Schedule 2 Amount"; Decimal)
        {
            Caption = 'Schedule 2 Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Schedule 2 Amount" <> xRec."NS_Schedule 2 Amount") and ("NS_Schedule 2 Task" <> '') then begin
                    NS_TestSOWAmount(2, "NS_Schedule 2 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 2 Task", 1, STRPOS("NS_Schedule 2 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 2 Percentage" := ROUND("NS_Schedule 2 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021433; "NS_Schedule 3 Amount"; Decimal)
        {
            Caption = 'Schedule 3 Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Schedule 3 Amount" <> xRec."NS_Schedule 3 Amount") and ("NS_Schedule 3 Task" <> '') then begin
                    NS_TestSOWAmount(3, "NS_Schedule 3 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 3 Task", 1, STRPOS("NS_Schedule 3 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 3 Percentage" := ROUND("NS_Schedule 3 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021434; "NS_Schedule 4 Amount"; Decimal)
        {
            Caption = 'Schedule 4 Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Schedule 4 Amount" <> xRec."NS_Schedule 4 Amount") and ("NS_Schedule 4 Task" <> '') then begin
                    NS_TestSOWAmount(4, "NS_Schedule 4 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 4 Task", 1, STRPOS("NS_Schedule 4 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 4 Percentage" := ROUND("NS_Schedule 4 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021435; "NS_Schedule 5 Amount"; Decimal)
        {
            Caption = 'Schedule 5 Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Schedule 5 Amount" <> xRec."NS_Schedule 5 Amount") and ("NS_Schedule 5 Task" <> '') then begin
                    NS_TestSOWAmount(5, "NS_Schedule 5 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 5 Task", 1, STRPOS("NS_Schedule 5 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 5 Percentage" := ROUND("NS_Schedule 5 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
        }
        field(14021436; "NS_Schedule 6 Amount"; Decimal)
        {
            Caption = 'Schedule 6 Amount';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                if ("NS_Schedule 6 Amount" <> xRec."NS_Schedule 6 Amount") and ("NS_Schedule 6 Task" <> '') then begin
                    NS_TestSOWAmount(6, "NS_Schedule 6 Amount", "NS_Total Contract Price");
                    QuoteTaskLines.RESET();
                    QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                    QuoteTaskLines.SETRANGE("Job Task No.", COPYSTR("NS_Schedule 6 Task", 1, STRPOS("NS_Schedule 6 Task", '-') - 1));
                    if QuoteTaskLines.FINDFIRST() then begin
                        QuoteTaskLines.CALCFIELDS("Schedule (Total Price)");
                        "NS_Schedule 6 Percentage" := ROUND("NS_Schedule 6 Amount" / QuoteTaskLines."Schedule (Total Price)" * 100);
                    end;
                    NS_UpdateContractPlanningLine();
                end;
            end;
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
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("NS_Job No."));
            DataClassification = CustomerContent;
        }
        field(14021445; "NS_Job Posting Group"; Code[20])
        {
            ObsoleteState = Pending; //PRJ-993.AS.1.0 12OCT2021
            ObsoleteReason = 'Will be removed in Next build'; //PRJ-993.AS.1.0 12OCT2021
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";
            DataClassification = CustomerContent;
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

            trigger OnValidate();
            begin
                JobsSetup.GET();
                QuoteTaskLines.RESET();
                QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
                if QuoteTaskLines.FINDFIRST() then begin
                    QuoteTaskLines.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                    if "NS_Selling Price" <> 0 then
                        "NS_Selling Price G.M. %" := (("NS_Selling Price" - QuoteTaskLines."Schedule (Total Cost)") / "NS_Selling Price") * 100
                    else
                        "NS_Selling Price G.M. %" := 0;
                end;
            end;
        }
        field(14021448; "NS_Total Contract Price"; Decimal)
        {
            Caption = 'Total Contract Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 4;

            trigger OnValidate();
            begin
                JobsSetup.GET();
                QuoteTaskLines.RESET();
                QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
                QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
                if QuoteTaskLines.FINDFIRST() then begin
                    QuoteTaskLines.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)", "NS_Line Amount Incl. Tax");
                    if "NS_Total Contract Price" <> 0 then
                        "NS_Total Contract Price G.M. %" := (("NS_Total Contract Price" - QuoteTaskLines."Schedule (Total Cost)") / "NS_Total Contract Price") * 100
                    else
                        "NS_Total Contract Price G.M. %" := 0;
                end;
            end;
        }
        field(14021449; "NS_Minimum Selling Price G.M.%"; Decimal)
        {
            Caption = 'Minimum Selling Price G.M. %';
            DataClassification = CustomerContent;

            trigger OnValidate();
            begin
                NS_UpdateMinSellPrice();
            end;
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

        field(14021452; "NS_Data From API"; Boolean)        //PRJ-933.JS.1.0  05Oct2021
        {
            Caption = 'Data From API';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14021453; "NS_Job Posting Group New"; Code[20]) //PRJ-993.AS.1.0 18OCT2021 Add new field
        {
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "NS_Quote No.")
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
        // >> Upgrade
        fieldgroup(DropDown; "NS_Quote No.", "NS_Description/Nickname")
        {
        }
        // << Upgrade
    }
    // >> Upgrade
    var
        GLSetup: Record "General Ledger Setup";
    // << Upgrade

    trigger OnDelete();
    begin
        QuoteMgt.NS_OnDeleteQuote(Rec);
    end;

    trigger OnInsert();
    var
        JobType: Record "NS_Job Type";
        QuoteType: Page "NS_Job Types";
        //QuoteTypeCode: Code[20];
        Licdate: date;//PRJ-516
        NoOfDays: Text;//PRJ-516
        EnvInfoCU: Codeunit "Environment Information";//PRJ-516
                                                      // >> Upgrade
        IsHanldled: Boolean;

    // << Upgrade
    begin
        //PRJ-516.ms.1.0 start
        if EnvInfoCU.IsSaaS() then begin
            //Licdate := DMY2Date(31, 3, 2021);//PRJ-516.AS.1.0 16MARCH2021 Comment
            // Licdate := DMY2Date(31, 5, 2021);//PRJ-516.AS.1.0 16MARCH2021 Added Change date
            // EVALUATE(NoOfDays, FORMAT(Licdate - WorkDate));
            // if (WorkDate > (Licdate - 6)) and (WorkDate <= Licdate) then
            //     Message('Your free trial is going to expire in %1 days.Please contact your administrator.', NoOfDays);
            // if WorkDate > Licdate then
            //     Error('Your free trial has expired.Please contact your administrator.');
            OnCheckPPLicenseExpire();
        end;
        //PRJ-516.ms.1.0 end
        JobsSetup.GET();

        if JobsSetup."NS_Use Default Tasks" > 0 then begin
            if "NS_Data From API" = false then begin       //PRJ-933.JS.1.0 05OCT2021
                                                           // >> Upgrade
                IsHanldled := false;
                SkipDialog(Rec, IsHanldled);
                if IsHanldled then
                    QuoteMgt.NS_OnInsertQuote(Rec, true)
                else

                    //if CONFIRM(Text14021400Lbl, true, FORMAT(JobsSetup."NS_Use Default Tasks")) then begin
                    IF CONFIRM(Text14021400Lbl, FALSE, FORMAT(JobsSetup."NS_Use Default Tasks")) THEN BEGIN  // >> 013 Set default action to FALSE <<
                                                                                                             // << Upgrade
                        if JobsSetup."NS_Use Default Tasks" = JobsSetup."NS_Use Default Tasks"::JobType then begin
                            QuoteType.LOOKUPMODE(true);
                            QuoteType.SETRECORD(JobType);
                            if QuoteType.RUNMODAL() = ACTION::LookupOK then begin
                                QuoteType.GETRECORD(JobType);
                                "NS_Quote Type Code" := JobType.NS_Code;
                                "NS_Job Type Code" := JobType.NS_Code;
                            end else
                                QuoteMgt.NS_SetDisableJobTaskLoad(true);
                        end;
                        QuoteMgt.NS_OnInsertQuote(Rec, false);
                    end else
                        QuoteMgt.NS_OnInsertQuote(Rec, true);
            end else  //PRJ-933.JS.1.0 05OCT2021
                QuoteMgt.NS_OnInsertQuote(Rec, true);   //PRJ-933.JS.1.0 05OCT2021                
        end else
            QuoteMgt.NS_OnInsertQuote(Rec, true);


        //"NS_Job Posting Group" := JobsSetup."Default Job Posting Group";//PRJ-993.AS.1.0 18OCT2021 comment old code for field "NS_Job Posting Group" for Job Quote header
        "NS_Job Posting Group New" := JobsSetup."Default Job Posting Group";//PRJ-993.AS.1.0 18OCT2021 Add new code for field "NS_Job Posting Group New" for Job Quote header
        "NS_Billing Job Task No." := JobsSetup."NS_Billing Job Task No.";
        // >> Upgrade
        OnAfterInsert(Rec);

        // << Upgrade
        QuoteMgt.NS_SetDisableJobTaskLoad(false);
        //PRJ-409.AS.1.0 - START
        DimMgmt.UpdateDefaultDim(
          DATABASE::"NS_Job Quote Header", "NS_Quote No.",
          "NS_Shortcut Dimension 1 Code", "NS_Shortcut Dimension 2 Code");
        //PRJ-409.AS.1.0 - END
    end;

    trigger OnModify();
    begin
        QuoteMgt.NS_OnModifyQuote(Rec);
    end;

    var
        JobsSetup: Record "Jobs Setup";
        QuoteTaskLines: Record "Job Task";
        PostCode: Record "Post Code";


        QuoteMgt: Codeunit "NS_Job Quote Mgt.";

        DimMgmt: Codeunit DimensionManagement;//PRJ-409.AS.1.0
        SegmentType: Option Welding,Drawing,Template;
        TrueFalse: Boolean;
        Text14021400Lbl: Label 'Do You want to Use Default Tasks of Type %1', Comment = '%1=JobsSetup."Use Default Tasks"';

    procedure NS_SetSegmentType(lSegmentType: Option Welding,Drawing,Template; lTrueFalse: Boolean);
    begin
        SegmentType := lSegmentType;
        TrueFalse := lTrueFalse;
    end;

    procedure NS_UpdateContractPlanningLine();
    var
        //lTask: Record "Job Task";
        lPlanningLine: Record "Job Planning Line";
        //LastTask: Code[20];
        JobsSetupLoc: Record "Jobs Setup";
        x: Integer;
    begin
        JobsSetup.GET();
        lPlanningLine.RESET();
        for x := 1 to 6 do begin
            lPlanningLine.SETRANGE("Job No.", "NS_Job No.");
            lPlanningLine.SETRANGE("NS_Progress Billing Line", true);
            lPlanningLine.SETRANGE("Line Type", lPlanningLine."Line Type"::Billable);
            lPlanningLine.SETRANGE(Type, lPlanningLine.Type::"G/L Account");
            lPlanningLine.SETRANGE("No.", JobsSetupLoc."NS_ProgressBillingDefG/L Act.");
            lPlanningLine.SETRANGE(Quantity, 1);
            if lPlanningLine.FINDFIRST() then begin
                if x = 1 then begin
                    lPlanningLine.Description := "NS_Schedule 1 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 1 Amount";
                end;

                if x = 2 then begin
                    lPlanningLine.Description := "NS_Schedule 2 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 2 Amount";
                end;

                if x = 3 then begin
                    lPlanningLine.Description := "NS_Schedule 3 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 3 Amount";
                end;

                if x = 4 then begin
                    lPlanningLine.Description := "NS_Schedule 4 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 4 Amount";
                end;

                if x = 5 then begin
                    lPlanningLine.Description := "NS_Schedule 5 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 5 Amount";
                end;

                if x = 6 then begin
                    lPlanningLine.Description := "NS_Schedule 6 Description";
                    lPlanningLine."Unit Price" := "NS_Schedule 6 Amount";
                end;
                lPlanningLine.MODIFY();
            end;
        end;
    end;

    procedure NS_TestPctTotal(Schedule: Integer; TestPct: Decimal);
    var
        TotalPct: Decimal;
        PctDelta: Decimal;
        StringPctDelta: Text[100];
        PctTxt01Lbl: Label 'The Total Percentages Cannot Exceed 100. You have entered %1 Total Percentages, Reduce A Different Schedule by %2 then Re-Enter %4 for Schedule %3', Comment = '%1=TotalPct;%2=PctDelta;%3= Schedule;%4=TestPct';
        PctTxt02Lbl: Label 'The Total Percentages Must Equal 100. You Have Entered %1 Total Percentages, There are %2 Percentages Remaining to be assigned.', Comment = '%1=TotalPct;%2=ABS(PctDelta)';
    begin
        TotalPct := "NS_Schedule 1 Percentage" + "NS_Schedule 2 Percentage" + "NS_Schedule 3 Percentage" +
             "NS_Schedule 4 Percentage" + "NS_Schedule 5 Percentage" + "NS_Schedule 6 Percentage";
        PctDelta := TotalPct - 100;
        if PctDelta > 0 then begin
            StringPctDelta := STRSUBSTNO(PctTxt01Lbl, TotalPct, PctDelta, Schedule, TestPct);
            ERROR(StringPctDelta);
        end;
        if PctDelta < 0 then
            MESSAGE(STRSUBSTNO(PctTxt02Lbl, TotalPct, ABS(PctDelta)));
    end;

    procedure NS_TestSOWAmount(Schedule: Integer; TestAmt: Decimal; ContractTotal: Decimal);
    var
        TotalAmt: Decimal;
        AmtDelta: Decimal;
        StringText: Text[50];
        AmtTxt01Lbl: Label 'The Total Amount Cannot Exceed %1. You have entered a Total of %2. Reduce another Amount by %3, then Re-enter %4 for Amount %5', Comment = '%1=ContractTotal; %2= TotalAmt:%3= ABS(AmtDelta);%4= TestAmt;%5=Schedule';
        AmtTxt02Lbl: Label 'The Total Amount Must Equal %1. You have entered a Total of %2. There is a Remaining Amount to be assigned of %3.', Comment = '%1=ContractTotal;%2= TotalAmt;%3= ABS(AmtDelta)';
    begin
        TotalAmt := "NS_Schedule 1 Amount" + "NS_Schedule 2 Amount" + "NS_Schedule 3 Amount" +
                    "NS_Schedule 4 Amount" + "NS_Schedule 5 Amount" + "NS_Schedule 6 Amount";

        AmtDelta := TotalAmt - ContractTotal;
        if AmtDelta > 0 then begin
            StringText := STRSUBSTNO(AmtTxt01Lbl, ContractTotal, TotalAmt, ABS(AmtDelta), TestAmt, Schedule);
            ERROR(StringText);
        end;
        if AmtDelta < 0 then
            MESSAGE(STRSUBSTNO(AmtTxt02Lbl, ContractTotal, TotalAmt, ABS(AmtDelta)));
    end;

    procedure NS_CreateInteraction();
    var
        TempSegmentLine: Record "Segment Line" temporary;
    begin
        TempSegmentLine.NS_CreateInteractionFromJobQuote(Rec);
    end;

    procedure NS_UpdateMinSellPrice();
    // >> Upgrade
    var
        IsHandled: Boolean;
    // << Upgrade
    begin
        // >> Upgrade
        OnBeforeNS_UpdateMinSellPrice(Rec, IsHandled);
        if IsHandled then
            exit;
        // << Upgrade
        JobsSetup.GET();
        QuoteTaskLines.RESET();
        QuoteTaskLines.SETRANGE("Job No.", "NS_Job No.");
        QuoteTaskLines.SETRANGE("Job Task No.", JobsSetup."NS_Total Task No.");
        if QuoteTaskLines.FINDFIRST() then begin
            QuoteTaskLines.CALCFIELDS("Schedule (Total Cost)", "Schedule (Total Price)", "NS_Line Amount Incl. Tax");
            "NS_Minimum Selling Price" := ROUND((QuoteTaskLines."Schedule (Total Cost)" / (1 - ("NS_Minimum Selling Price G.M.%" / 100))), 0.01);
            if "NS_Selling Price" = 0 then
                VALIDATE("NS_Selling Price", "NS_Minimum Selling Price");
            if "NS_Total Contract Price" = 0 then
                VALIDATE("NS_Total Contract Price", "NS_Minimum Selling Price");
            VALIDATE("NS_Use Tax Code");
            MODIFY();
        end;

    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPPLicenseExpire()
    begin
    end;
    // >> Upgrade
    [IntegrationEvent(false, false)]
    local procedure SkipDialog(var JobQuoteHeader: Record "NS_Job Quote Header"; var IsHanldled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsert(var JobQuoteHeader: Record "NS_Job Quote Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNS_UpdateMinSellPrice(var JobQuoteHeader: Record "NS_Job Quote Header"; var IsHandled: Boolean)
    begin
    end;
    // << Upgrade
}


