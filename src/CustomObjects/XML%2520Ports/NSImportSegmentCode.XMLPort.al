xmlport 14021378 "NS_Import Segment Codes"
{
    //TM-10.AM.1.0 25NOV2020 | Created New XML Port to import Segment Codes.
    Direction = Import;
    Format = VariableText;
    DefaultFieldsValidation = true;


    schema
    {
        textelement(ImportSegmentCodes)
        {
            XmlName = 'ImportSegmentCodes';
            tableelement("NS_Job Takeoff Segments"; "NS_Job Takeoff Segments")
            {

                XmlName = 'JobSegments';
                fieldelement(JobNo; "NS_Job Takeoff Segments"."NS_Job No.")
                {
                }
                fieldelement(SegmentCode; "NS_Job Takeoff Segments"."NS_Segment Code")
                {
                }
                fieldelement(SegmentName; "NS_Job Takeoff Segments"."NS_Segment Name")
                {

                }
                fieldelement(SegmentDescription; "NS_Job Takeoff Segments"."NS_Segment Description")
                {

                }
                fieldelement(BillingType; "NS_Job Takeoff Segments"."NS_Billing Type")
                {

                }
                fieldelement(UnitOfMeasure; "NS_Job Takeoff Segments"."NS_Unit of Measure Code")
                {

                }
                fieldelement(Quantity; "NS_Job Takeoff Segments"."NS_Estimated Quantity")
                {

                }
                fieldelement(UnitRate; "NS_Job Takeoff Segments"."NS_Unit Rate")
                {

                }
                fieldelement(TotalCost; "NS_Job Takeoff Segments"."NS_Total Cost")
                {

                }

                trigger OnAfterInitRecord()

                begin

                    IF FirstlineBool then begin
                        FirstlineBool := false;
                        currXMLport.Skip();
                    end;
                end;
            }

        }
    }

    trigger OnPreXmlPort()
    var
    begin
        FirstlineBool := true;
    end;


    trigger OnPostXmlPort()
    var
    begin
        Message('Data Imported Successfully.');
    end;

    var

        FirstlineBool: Boolean;
}

