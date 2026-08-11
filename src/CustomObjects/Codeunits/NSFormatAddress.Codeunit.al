codeunit 14021116 "NS_Format Address"
{
    // version NAVW113.02,NAVNA13.02,PPNA11.00,SPLN

    // SPLN1.00 2019-01-22 Created. Copy of C365
    // +------------------------------------------------------------
    // +ProjectPro
    // +  - Added function(s):
    // +     JobBillTo
    // +     JobSite
    // +     JobContact
    // +
    // +  - Modification(s):
    // +     - FormatAddr:
    // +         - Replaced County Code with Country Name in addresses.
    //CTSI-301-86.MS.1.0 change length from 50 or 90 to Text
    // +------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        i: Integer;
        FormatAddress: Codeunit "Format Address";


    //PPDA.1.0 Start
    // [EventSubscriber(ObjectType::Codeunit, 365, 'OnBeforeFormatAddress', '', false, false)]
    // local procedure NS_C365OnBeforeFormatAddress(Country: Record "Country/Region"; var AddrArray: array[8] of Text; var Name: Text; var Name2: Text; var Contact: Text; var Addr: Text; var Addr2: Text; var City: Text; var PostCode: Code[20]; var County: Text[50]; var CountryCode: Code[10]; NameLineNo: Integer; Name2LineNo: Integer; AddrLineNo: Integer; Addr2LineNo: Integer; ContLineNo: Integer; PostCodeCityLineNo: Integer; CountyLineNo: Integer; CountryLineNo: Integer; var Handled: Boolean)//CTSI-86.MS.1.0
    // var
    //     NS_CompanyInformation: Record "Company Information";
    //     NS_CountryName: Text[50];
    //     Index: Integer;
    //     InsertText: Integer;
    // begin
    //     AddrArray[NameLineNo] := Name;
    //     AddrArray[Name2LineNo] := Name2;
    //     AddrArray[AddrLineNo] := Addr;
    //     AddrArray[Addr2LineNo] := Addr2;

    //     //ProjectPro - start
    //     NS_CompanyInformation.Get;
    //     if Country.Code = NS_CompanyInformation."Country/Region Code" then
    //         NS_CountryName := ''
    //     else
    //         NS_CountryName := Country.Name;
    //     //ProjectPro - end

    //     case Country."Address Format" of
    //         Country."Address Format"::"Post Code+City",
    //         Country."Address Format"::"City+County+Post Code",
    //         Country."Address Format"::"City+County+New Line+Post Code",
    //         Country."Address Format"::"Post Code+City+County",
    //         Country."Address Format"::"City+Post Code":
    //             begin
    //                 AddrArray[ContLineNo] := Contact;
    //                 NS_GeneratePostCodeCity(AddrArray[PostCodeCityLineNo], AddrArray[CountyLineNo], City, PostCode, County, Country);
    //                 //ProjectPro - start
    //                 //AddrArray[CountryLineNo] := Country.Name;
    //                 AddrArray[CountryLineNo] := NS_CountryName;
    //                 //ProjectPro - end
    //                 CompressArray(AddrArray);
    //             end;
    //         Country."Address Format"::"Blank Line+Post Code+City":
    //             begin
    //                 if ContLineNo < PostCodeCityLineNo then
    //                     AddrArray[ContLineNo] := Contact;
    //                 CompressArray(AddrArray);

    //                 Index := 1;
    //                 InsertText := 1;
    //                 repeat
    //                     if AddrArray[Index] = '' then begin
    //                         case InsertText of
    //                             2:
    //                                 NS_GeneratePostCodeCity(AddrArray[Index], AddrArray[Index + 1], City, PostCode, County, Country);

    //                             //ProjectPro - start
    //                             //3:
    //                             //  AddrArray[Index] := Country.Name;
    //                             3:
    //                                 AddrArray[Index] := NS_CountryName;
    //                             //ProjectPro - end

    //                             4:
    //                                 if ContLineNo > PostCodeCityLineNo then
    //                                     AddrArray[Index] := Contact;
    //                         end;
    //                         InsertText := InsertText + 1;
    //                     end;
    //                     Index := Index + 1;
    //                 until Index = 9;
    //             end;
    //     end;

    //     Handled := true;
    // end;
    //PPDA.1.0 End

    //PPDA.1.0 Start
    // local procedure NS_GeneratePostCodeCity(var PostCodeCityText: Text[90]; var CountyText: Text[50]; City: Text[50]; PostCode: Code[20]; County: Text[50]; Country: Record "Country/Region")
    // var
    //     DummyString: Text;
    //     OverMaxStrLen: Integer;
    // begin
    //     DummyString := '';
    //     OverMaxStrLen := MaxStrLen(PostCodeCityText);
    //     if OverMaxStrLen < MaxStrLen(DummyString) then
    //         OverMaxStrLen += 1;

    //     case Country."Address Format" of
    //         Country."Address Format"::"Post Code+City":
    //             begin
    //                 if PostCode <> '' then
    //                     PostCodeCityText := DelStr(PostCode + ' ' + City, OverMaxStrLen)
    //                 else
    //                     PostCodeCityText := City;
    //                 CountyText := County;
    //             end;
    //         Country."Address Format"::"City+County+Post Code":
    //             begin
    //                 CountyText := '';
    //                 if PostCode = '' then begin
    //                     if County = '' then
    //                         PostCodeCityText := City
    //                     else
    //                         PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(County) - 2) + ', ' + County;
    //                 end else
    //                     if County = '' then
    //                         PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
    //                     else
    //                         PostCodeCityText :=
    //                           DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - StrLen(County) - 4) +
    //                           ', ' + County + ' ' + PostCode;
    //             end;
    //         Country."Address Format"::"City+County+New Line+Post Code":
    //             begin
    //                 CountyText := PostCode;
    //                 if County = '' then
    //                     PostCodeCityText := City
    //                 else
    //                     PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(County) - 2) + ', ' + County;
    //             end;
    //         Country."Address Format"::"Post Code+City+County":
    //             begin
    //                 if PostCode <> '' then
    //                     PostCodeCityText := DelStr(PostCode + ' ' + City + ', ' + County, OverMaxStrLen)
    //                 else
    //                     PostCodeCityText := DelStr(City + ', ' + County, OverMaxStrLen);
    //             end;
    //         Country."Address Format"::"City+Post Code":
    //             begin
    //                 if PostCode <> '' then
    //                     PostCodeCityText := DelStr(City, MaxStrLen(PostCodeCityText) - StrLen(PostCode) - 1) + ', ' + PostCode
    //                 else
    //                     PostCodeCityText := City;
    //                 CountyText := County;
    //             end;
    //         Country."Address Format"::"Blank Line+Post Code+City":
    //             begin
    //                 if PostCode <> '' then
    //                     PostCodeCityText := DelStr(PostCode + ' ' + City, OverMaxStrLen)
    //                 else
    //                     PostCodeCityText := City;
    //                 CountyText := County;
    //             end;
    //     end;
    // end;
    //PPDA.1.0 End

    local procedure NS_SetLineNos(Country: Record "Country/Region"; var NameLineNo: Integer; var Name2LineNo: Integer; var AddrLineNo: Integer; var Addr2LineNo: Integer; var ContLineNo: Integer; var PostCodeCityLineNo: Integer; var CountyLineNo: Integer; var CountryLineNo: Integer)
    begin
        case Country."Contact Address Format" of
            Country."Contact Address Format"::First:
                begin
                    NameLineNo := 2;
                    Name2LineNo := 3;
                    ContLineNo := 1;
                    AddrLineNo := 4;
                    Addr2LineNo := 5;
                    PostCodeCityLineNo := 6;
                    CountyLineNo := 7;
                    CountryLineNo := 8;
                end;
            Country."Contact Address Format"::"After Company Name":
                begin
                    NameLineNo := 1;
                    Name2LineNo := 2;
                    ContLineNo := 3;
                    AddrLineNo := 4;
                    Addr2LineNo := 5;
                    PostCodeCityLineNo := 6;
                    CountyLineNo := 7;
                    CountryLineNo := 8;
                end;
            Country."Contact Address Format"::Last:
                begin
                    NameLineNo := 1;
                    Name2LineNo := 2;
                    ContLineNo := 8;
                    AddrLineNo := 3;
                    Addr2LineNo := 4;
                    PostCodeCityLineNo := 5;
                    CountyLineNo := 6;
                    CountryLineNo := 7;
                end;
        end;
    end;

    procedure NS_JobBillTo(var AddrArray: array[8] of Text[50]; var Job: Record Job)
    begin
        //ProjectPro - start
        with Job do
            FormatAddress.FormatAddr(
              AddrArray, "Bill-to Name", "Bill-to Name 2", '', "Bill-to Address", "Bill-to Address 2",
              "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code");
        //ProjectPro - end
    end;

    procedure NS_JobSite(var AddrArray: array[8] of Text[50]; var Job: Record Job)
    begin
        //ProjectPro - start
        with Job do
            FormatAddress.FormatAddr(
              AddrArray, '', '', '', "NS_Job Address 1", "NS_Job Address 2",
              "NS_Job City", "NS_Job Post Code", "NS_Job County", "NS_Job Country/Region Code");
        //ProjectPro - end
    end;

    procedure NS_JobContact(var AddrArray: array[8] of Text[50]; var JobCont: Record "NS_Job Contact")
    begin
        //ProjectPro - start
        with JobCont do
            FormatAddress.FormatAddr(
              AddrArray, NS_Name, "NS_Name 2", '', NS_Address, "NS_Address 2",
              NS_City, "NS_Post Code", NS_County, '');
        //ProjectPro - end
    end;
}

