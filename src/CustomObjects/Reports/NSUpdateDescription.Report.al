report 14021395 "NS_UpdateDescription"
//PRJ-838.AS.1.0 New Batch report
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Description,Item Name in Assembly BOM component, JMP';

    dataset
    {
        dataitem("NS_Assembley BOM Components"; "NS_Assembley BOM Components")
        {
            DataItemTableView = SORTING("NS_Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                if ("NS_Assembley BOM Components".NS_Description <> '') and ("NS_Assembley BOM Components"."NS_Description New" = '') then begin
                    "NS_Assembley BOM Components"."NS_Description New" := "NS_Assembley BOM Components".NS_Description;
                    "NS_Assembley BOM Components".NS_Description := '';
                    "NS_Assembley BOM Components".Modify(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
            end;

        }
        dataitem("NS_Job Material Planning"; "NS_Job Material Planning")
        {
            DataItemTableView = SORTING("NS_Worksheet Job No.");
            trigger OnAfterGetRecord()
            var
            begin
                if ("NS_Job Material Planning"."NS_Item Name" <> '') and ("NS_Job Material Planning"."NS_Item Name New" = '') then begin
                    "NS_Job Material Planning"."NS_Item Name New" := "NS_Job Material Planning"."NS_Item Name";
                    "NS_Job Material Planning"."NS_Item Name" := '';
                    "NS_Job Material Planning".modify(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPostReport()
    var
    begin
        Message('Successfully Updated Description,Item Name in Assembly BOM component, JMP');
    end;

    trigger OnPreReport()
    var
    begin
    end;

    var
}