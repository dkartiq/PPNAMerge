table 14021438 "NS_Percentage of Completion"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com 
    //PRJ-94.ms.1.0 Create new Table
    // +------------------------------------------------------------
    //CTSI-94.AS.1.0 10AUG2020 Added fields Recognized Profit, Recognized Profit % 
    //PRJ-301.MS.1.0 change leg from 10 to 20
    //PRJ-626.GK.1.0 30Aug2021 |Add field caption
    //PRJ-1015.JS.1.0  14Oct2021 | Add one Key
    //PRJ-1098.NK.0.0 11Feb2022 |Add Two Fields
    //PRJ-1387.NK.1.0 12May2022 | Add One Field
    Caption = 'Percentage of Completion';

    fields
    {
        field(1; "NS_Entry No"; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;

        }
        field(2; "NS_TotalForecastCompletedCost"; Decimal)
        {
            Caption = 'Total Forecasted Completed Cost';
            DataClassification = SystemMetadata;
            ;



        }
        field(3; "NS_Total Forecasted Variance"; Decimal)
        {
            Caption = 'Total Forecasted Variance';
            DataClassification = SystemMetadata;
        }
        field(4; "NS_Total Contract Revenue"; Decimal)
        {
            Caption = 'Total Contract Revenue';
            DataClassification = SystemMetadata;
        }
        field(5; "NS_Total Cost to Date"; Decimal)
        {
            Caption = 'Total Cost to Date';
            DataClassification = SystemMetadata;
        }
        field(6; "NS_Total Budget Remaining"; Decimal)
        {
            Caption = 'Total Budget Remaining';
            DataClassification = SystemMetadata;
        }
        field(7; "NS_Forecasted Cost Remaining"; Decimal)
        {
            Caption = 'Forecasted Cost Remaining';
            DataClassification = SystemMetadata;
        }
        field(8; "NS_Net Cost Variance"; Decimal)
        {
            Caption = 'Net Cost Variance';
            DataClassification = SystemMetadata;
        }
        field(9; "NS_Job Percent Complete"; Decimal)
        {
            Caption = 'Job Percent Complete';//PRJ-353.AS.1.0 Corrected caption
            DataClassification = SystemMetadata;
        }
        field(10; "NS_Revenue Earned"; Decimal)
        {
            Caption = 'Revenue Earned';
            DataClassification = SystemMetadata;
        }
        field(11; "NS_Gross Margin"; Decimal)
        {
            Caption = 'Gross Margin';
            DataClassification = SystemMetadata;
        }
        field(12; "NS_Gross Margin Percent"; Decimal)
        {
            Caption = 'Gross Margin Percent';
            DataClassification = SystemMetadata;
        }
        field(13; "NS_Posting Date"; date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(14; "NS_Total Budgeted Costs"; Decimal)
        {
            Caption = 'Total Budgeted Costs';
            DataClassification = SystemMetadata;
        }
        field(15; "NS_Job No."; Code[20]) //PRJ-301.MS.1.0 change leg from 10 to 20
        {
            Caption = 'Job No.';
            DataClassification = SystemMetadata;
        }
        field(16; "NS_Recognized Profit"; Decimal)//CTSI-94.AS.1.0 10AUG2020
        {
            Caption = 'Recognized Profit';
            DataClassification = SystemMetadata;
        }
        field(17; "NS_Recognized Profit Percent"; Decimal)//CTSI-94.AS.1.0 10AUG2020
        {
            Caption = 'Recognized Profit %';
            DataClassification = SystemMetadata;
        }
        field(18; NS_RecRevFlag; boolean)
        {
            Caption = 'RecRevFlag'; //PRJ-626.GK.1.0 30Aug2021
            DataClassification = CustomerContent;
            Description = 'CTSI-274';
        }
        field(19; NS_EntryFromBatchJob; Boolean) //PRJ-1098.NK.0.0 11Feb2022
        {
            Caption = 'Entry from Batch Job';
            DataClassification = CustomerContent;
            Description = 'Entry From Batch Job';
            Editable = false;
        }
        field(20; NS_JFWBatchDocumentNo; Code[20]) //PRJ-1098.NK.0.0 15Feb2022
        {
            Caption = 'JFW Batch Document No.';
            DataClassification = CustomerContent;
            Description = 'JFW Batch Document No.';
            Editable = false;
        }
        // +ProjectPro

        field(21; NS_Void; Boolean)   //PRJ-1387.NK.1.0 12May2022
        {
            DataClassification = CustomerContent;
            caption = 'Void';
            Description = 'PRJ-1387';

        }
    }

    keys
    {
        key(Key1; "NS_Entry No")
        {
        }

        key(Key2; "NS_Job No.")     //PRJ-1015.JS.1.0  14Oct2021
        {

        }
        key(Key3; "NS_Posting Date")   //PE-148.JS.1.0 16Aug2023
        {
        }
    }

    fieldgroups
    {
    }
}

