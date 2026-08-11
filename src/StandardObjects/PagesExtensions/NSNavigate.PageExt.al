pageextension 14021245 NS_NavigateExt extends Navigate
{
    // version NAVW111.00.00.23572,NAVNA11.00.00.23572,PPNA11.00
    //SPLN1.00 2019-02-07 DMT Added code and page "PP Navigate". "PP Navigate" is copy of P344 and added PP code.
    //"PP Navigate" will run instead of P344 if NS_NewLedgerNo variable has been assigned before P344.RUN.
    //PRJ-1330.NK.1.0 25Apr2022 | Change Caption
    Caption = 'Find entries'; //PRJ-1330.NK.1.0 25Apr2022

    var
        NS_NewLedgerNo: Code[20];
        NewDocNo: Code[20];
        NewPostingDate: Date;
        p: Codeunit "NS_Parameters for Table Events";

    trigger OnOpenPage();
    var
    // NS_Navigate: page "NS_Navigate";//PPDA.1.0 Commented
    begin
        //SPLN1.00 Start
        p.NS_GetNS_Navigate(NewPostingDate, NewDocNo, NS_NewLedgerNo);
        p.NS_SetNS_Navigate(0D, '', '');
        if NS_NewLedgerNo <> '' then begin
            //PPDA.1.0 Commented Start
            // NS_Navigate.NS_SetDocLedger(NS_NewLedgerNo, NewPostingDate, NewDocNo);
            // NS_Navigate.Run;
            //PPDA.1.0 Commented End
            Error('');
        end;
        //SPLN1.00 End
    end;


    procedure SetDocLedger(LedgerNo: Code[20]; PostingDate: Date; DocNo: Code[20]);
    begin
        p.NS_SetNS_Navigate(PostingDate, DocNo, LedgerNo);
    end;
}

