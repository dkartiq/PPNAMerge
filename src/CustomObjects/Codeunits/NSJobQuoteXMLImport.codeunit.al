codeunit 14021405 "NS_Job Quote XML Import"
{
    // version PPNA11.00

    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Developed and licensed by GEMKO Information Group Inc.
    // +  - www.dynamicsnavconstruction.com
    // +  - www.gemko.com
    // +------------------------------------------------------------


    trigger OnRun();
    begin
    end;

    var
        NodeList1: XmlNodeList;
        NodeList2: XmlNodeList;
        NodeList3: XmlNodeList;
        Element1: XmlElement;
        Element2: XmlElement;
        Element3: XmlElement;
        StrInStream: InStream;
        XMLFile: File;
        x: Integer;
        y: Integer;
        z: Integer;
        Text0001: Label 'Item';
        Doc: XmlDocument;
        InnerText: array[120] of Text[30];
        JobElement: Record "NS_Job Quote Task Element";
        JobPlanLine: Record "Job Planning Line";
        CurrencySymbol: Label '$';
        Done: Label 'Done!';
        txt: Text;
        Node: XmlNode;

    procedure NS_ImportXML(FileName: Text; JobNo: Code[20]; TaskNo: Code[20]);
    var
        lJobPlanLine: Record "Job Planning Line";
        NextLine: Integer;
        ChkItem: Record Item;
    begin
        //PPNA16.0 Blocked Start
        // XMLFile.OPEN(FileName);
        // XMLFile.CREATEINSTREAM(StrInStream);
        //PPNA16.0 Blocked End

        StrInStream.Read(txt);
        XmlDocument.ReadFrom(txt, Doc);
        NodeList1 := Doc.GetDescendantElements(Text0001);
        x := NodeList1.Count;

        lJobPlanLine.RESET;
        lJobPlanLine.SETRANGE("Job No.", JobNo);
        lJobPlanLine.SETRANGE("Job Task No.", TaskNo);
        if lJobPlanLine.FINDLAST then
            NextLine := lJobPlanLine."Line No."
        else
            NextLine := 0;

        for y := 0 to (NodeList1.Count - 1) do begin
            NodeList1.Get(y, Node);
            Element1 := Node.AsXMLElement();
            NodeList2 := Element1.GetChildNodes();
            if NodeList2.Count() <> 0 then begin
                for z := 0 to (NodeList2.Count() - 1) do begin
                    x := NodeList2.Count();
                    NodeList2.Get(z, Node);
                    Element2 := Node.AsXMLElement();
                    InnerText[z + 1] := COPYSTR(Element2.InnerText(), 1, 30);
                    if Element2.IsEmpty() then begin
                        NodeList3 := Element2.GetChildNodes();
                        if NodeList3.Count() <> 0 then begin
                            NodeList3.Get(0, Node);
                            Element3 := Node.AsXmlElement();
                        end;
                    end;
                end;
            end;
            z := z;
            //INSERT
            JobElement.RESET;
            JobElement."NS_Job No." := JobNo;
            JobElement."NS_Job Task No." := TaskNo;
            JobElement."NS_Line No." := (y + 1) * 1000;
            JobElement."NS_Imported from File" := FileName;
            JobElement."NS_Date Created" := CURRENTDATETIME;
            //JobElement."Date Last Modified"
            JobElement."NS_Item ID" := COPYSTR(Element1.InnerText(), 11, 8);
            JobElement."NS_Check Sum" := InnerText[1];
            if EVALUATE(JobElement."NS_Is Valid", InnerText[2]) then;
            JobElement."NS_User Code" := InnerText[3];
            JobElement."NS_Link Code" := InnerText[4];
            JobElement."NS_Manufacturers Code" := InnerText[5];
            JobElement.NS_Description := InnerText[6];
            JobElement.NS_Class := InnerText[7];
            JobElement.NS_Instance := InnerText[8];
            JobElement."NS_Item Type Name" := InnerText[9];
            if EVALUATE(JobElement."NS_Item Type", InnerText[10]) then;
            JobElement."NS_Sub Type Name" := InnerText[11];
            if EVALUATE(JobElement."NS_Sub Type", InnerText[12]) then;
            if EVALUATE(JobElement."NS_Charge Type", InnerText[13]) then;
            if EVALUATE(JobElement."NS_EO Type", InnerText[14]) then;
            if EVALUATE(JobElement."NS_Is Corner", InnerText[15]) then;
            if EVALUATE(JobElement."NS_Is Placed", InnerText[16]) then;
            if EVALUATE(JobElement."NS_Is Custom", InnerText[17]) then;
            if EVALUATE(JobElement."NS_Is Wall Mounted", InnerText[18]) then;
            if EVALUATE(JobElement."NS_Is Floorstanding", InnerText[19]) then;
            JobElement.NS_Finish := InnerText[20];
            JobElement.NS_Hinge := InnerText[21];
            if EVALUATE(JobElement.NS_Quantity, InnerText[22]) then;
            if EVALUATE(JobElement."NS_Is Foreign", InnerText[23]) then;
            if EVALUATE(JobElement."NS_Has Foreign", InnerText[24]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Cost 1 Fixed", InnerText[25]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type List 1 Fixed", InnerText[26]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Retail 1 Fixed", InnerText[27]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Cost 2 Fixed", InnerText[28]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type List 2 Fixed", InnerText[29]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Retail 2 Fixed", InnerText[30]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Cost 3 Fixed", InnerText[31]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type List 3 Fixed", InnerText[32]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Retail 3 Fixed", InnerText[33]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type Cost 4 Fixed", InnerText[34]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Type List 4 Fixed", InnerText[35]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."Type Retail 4 Fixed", InnerText[36]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Cost 1 Fixed", InnerText[37]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. List 1 Fixed", InnerText[38]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Retail 1 Fixed", InnerText[39]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Cost 2 Fixed", InnerText[40]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. List 2 Fixed", InnerText[41]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Retail 2 Fixed", InnerText[42]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Cost 3 Fixed", InnerText[43]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty.List 3 Fixed", InnerText[44]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Retail 3 Fixed", InnerText[45]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Cost 4 Fixed", InnerText[46]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. List 4 Fixed", InnerText[47]) then;
            InnerText[25] := COPYSTR(InnerText[25], STRPOS(InnerText[25], CurrencySymbol) + 1, 30);
            if EVALUATE(JobElement."NS_Qty. Retail 4 Fixed", InnerText[48]) then;
            JobElement."NS_Zone ID" := InnerText[49];
            JobElement."NS_Absolute Position" := InnerText[50];
            JobElement.NS_Direction := InnerText[51];
            JobElement."NS_Normal Direction" := InnerText[52];
            JobElement."NS_Var Type 1" := InnerText[53];
            JobElement."NS_Var Type 2" := InnerText[54];
            JobElement."NS_Var Type 3" := InnerText[55];
            JobElement."NS_Var Type 4" := InnerText[56];
            JobElement."NS_Var Type 5" := InnerText[57];
            JobElement."NS_Var Type 6" := InnerText[58];
            JobElement."NS_Featute Set Reference" := InnerText[59];
            if EVALUATE(JobElement."NS_Line Item No.", InnerText[60]) then;
            if not JobElement.INSERT then
                JobElement.MODIFY;

            NextLine += 10000;
            JobPlanLine.INIT;
            JobPlanLine."Job No." := JobNo;
            JobPlanLine."Job Task No." := TaskNo;
            JobPlanLine."Line No." := NextLine;
            JobPlanLine."NS_Entry Type" := JobPlanLine."NS_Entry Type"::Cost;
            JobPlanLine."Line Type" := JobPlanLine."Line Type"::"Both Budget and Billable";
            JobPlanLine."Document No." := FORMAT(TODAY);
            JobPlanLine.Type := JobPlanLine.Type::Item;

            if ChkItem.GET(InnerText[3]) then begin
                JobPlanLine.VALIDATE("No.", InnerText[3]);
                JobPlanLine."NS_Item Not Found" := false;
                if EVALUATE(JobPlanLine.Quantity, InnerText[22]) then
                    JobPlanLine.VALIDATE(Quantity);
                if EVALUATE(JobPlanLine."Unit Price (LCY)", InnerText[25]) then
                    JobPlanLine.VALIDATE("Unit Price (LCY)");
                if EVALUATE(JobPlanLine."Unit Price", InnerText[25]) then
                    JobPlanLine.VALIDATE("Unit Price");
            end else begin
                JobPlanLine."No." := InnerText[3];
                JobPlanLine."NS_Item Not Found" := true;
                if EVALUATE(JobPlanLine.Quantity, InnerText[22]) then;
                if EVALUATE(JobPlanLine."Unit Price (LCY)", InnerText[25]) then;
                if EVALUATE(JobPlanLine."Unit Price", InnerText[25]) then;
            end;

            JobPlanLine.Description := InnerText[6];
            JobPlanLine.INSERT;
        end;
        MESSAGE(Done);
    end;
}

