tableextension 14021101 NS_Location extends Location
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00

    fields
    {
        field(14021168; "NS_Job Calendar Code"; Code[10])
        {
            Caption = 'Job Calendar Code';
            Description = 'ProjectPro';
            TableRelation = "NS_Job Calendar";
            DataClassification = CustomerContent;
        }
        field(14021400; NS_Branch; Code[20])
        {
            Caption = 'Branch';
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('BRANCH'));
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
        }
        field(14021401; NS_Department; Code[20])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
            Description = 'ProjectPro';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('DEPARTMENT'));
        }
        field(14021402; NS_Truck; Boolean)
        {
            Caption = 'Truck';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021403; "NS_Drop Ship Location"; Boolean)
        {
            Caption = 'Drop Ship Location';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;
        }
        field(14021404; "NS_Related Resource"; Code[20])
        {
            Caption = 'Related Resource';
            Description = 'ProjectPro';
            Editable = false;
            TableRelation = Resource;
            DataClassification = CustomerContent;
        }
        field(14021405; "NS_Prevent Negative Inventory"; Boolean)
        {
            Caption = 'Prevent Negative Inventory';
            Description = 'ProjectPro';
            DataClassification = CustomerContent;

        }
    }

    /*+--------------------------------------------
      +ProjectPro
      +  - Added field(s):
      +     14021168 Job Calendar Code
      +     14021400 Branch
      +     14021401 Department
      +     14021402 Truck
      +     14021403 Drop Ship Location
      +     14021404 Related Resource
      +     14021405 Prevent Negative Inventory
      +
      +  - Added function(s):
      +
      +  - Added global variable(s):
      +
      +  - Modifcation(s):
      +--------------------------------------------*/

}

