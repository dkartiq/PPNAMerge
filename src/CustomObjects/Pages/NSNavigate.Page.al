//PPDA.1.0 Commented Start
// page 14021476 "NS_Navigate"
// {
//     // version NAVW113.02,NAVNA13.02,PPNA11.00

//     // +---------------------------------------------------------------------------------------------
//     // +ProjectPro
//     // +  - Added field(s):
//     // +
//     // +  - Added function(s):
//     // +     SetDocLedger
//     // +
//     // +  - Added global variable(s):
//     // +     PP_JobsSetup
//     // +     PP_SalesSetup
//     // +     PP_PurchSetup
//     // +     PP_NewLedgerNo
//     // +     PP_LedgerNoFilter
//     // +     PP_RetentionLedgerCode
//     // +     PP_SubcontractLedgEntry
//     // +
//     // +  - Added global text constant(s):
//     // +     Text14021100
//     // +
//     // +  - Modification(s):
//     // +     - OnOpenPage - Read setup records -
//     // +                       PP_JobsSetup
//     // +                       PP_SalesSetup
//     // +                       PP_PurchSetup
//     // +     - SetDoc - Added clear filters of PP_NewLedgerNo
//     // +     - FindRecords - When LedgerNoFilter has value set Retention Ledger Code Filter on table involved
//     // +                       and set the PP_RetentionLedgerCode.Code
//     // +                           CustLedgEntry
//     // +                           DtldCustLedgEntry
//     // +                           VendLedgEntry
//     // +                           DtldVendLedgEntry
//     // +                   - Add same type of entry in the series for Subcontract Ledger Entries
//     // +                   - Blocked error message if a Ledger No Filter exists
//     // +     - ShowRecords - Add processing for Subcontract Ledger Entry
//     // +     - SetDocNo - Set PP_LedgerNoFilter to the filter value of Ledger No. if retention ledgers are used
//     // +     - FindRecordsOnOpen - Added PP_NewLedgerNo to condition of filter setting
//     // +-----------------------------------------------------------------------------------------------

//     ApplicationArea = Basic, Suite, FixedAssets, Service, CostAccounting;
//     Caption = 'PP Navigate';
//     DataCaptionExpression = NS_GetCaptionText();
//     DeleteAllowed = false;
//     InsertAllowed = false;
//     ModifyAllowed = false;
//     PageType = Worksheet;
//     PromotedActionCategories = 'New,Process,Report,Find By';
//     SaveValues = false;
//     SourceTable = "Document Entry";
//     SourceTableTemporary = true;
//     UsageCategory = Tasks;

//     layout
//     {
//         area(content)
//         {
//             group(Document)
//             {
//                 Caption = 'Document';
//                 Visible = DocumentVisible;
//                 field(DocNoFilter; DocNoFilter)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Document No.';
//                     ToolTip = 'Specifies the document number of an entry that is used to find all documents that have the same document number. You can enter a new document number in this field to search for another set of documents.';

//                     trigger OnValidate()
//                     begin
//                         NS_SetDocNo(DocNoFilter);
//                         ContactType := ContactType::" ";
//                         ContactNo := '';
//                         ExtDocNo := '';
//                         NS_ClearTrackingInfo;
//                         NS_DocNoFilterOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//                 field(PostingDateFilter; PostingDateFilter)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Posting Date';
//                     ToolTip = 'Specifies the posting date for the document that you are searching for. You can insert a filter if you want to search for a certain interval of dates.';

//                     trigger OnValidate()
//                     begin
//                         NS_SetPostingDate(PostingDateFilter);
//                         ContactType := ContactType::" ";
//                         ContactNo := '';
//                         ExtDocNo := '';
//                         NS_ClearTrackingInfo;
//                         NS_PostingDateFilterOnAfterValida;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//             }
//             group("Business Contact")
//             {
//                 Caption = 'Business Contact';
//                 Visible = BusinessContactVisible;
//                 field(ContactType; ContactType)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Business Contact Type';
//                     OptionCaption = ' ,Vendor,Customer,Bank Account';
//                     ToolTip = 'Specifies if you want to search for customers, vendors, or bank accounts. Your choice determines the list that you can access in the Business Contact No. field.';

//                     trigger OnValidate()
//                     begin
//                         NavigateDeposit := (ContactType = ContactType::"Bank Account");
//                         NS_SetDocNo('');
//                         NS_SetPostingDate('');
//                         NS_ClearTrackingInfo;
//                         NS_ContactTypeOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//                 field(ContactNo; ContactNo)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Business Contact No.';
//                     ToolTip = 'Specifies the number of the customer, vendor, or bank account that you want to find entries for.';

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         Vend: Record Vendor;
//                         Cust: Record Customer;
//                         BankAcc: Record "Bank Account";
//                     begin
//                         case ContactType of
//                             ContactType::Vendor:
//                                 if PAGE.RunModal(0, Vend) = ACTION::LookupOK then begin
//                                     Text := Vend."No.";
//                                     exit(true);
//                                 end;
//                             ContactType::Customer:
//                                 if PAGE.RunModal(0, Cust) = ACTION::LookupOK then begin
//                                     Text := Cust."No.";
//                                     exit(true);
//                                 end;
//                             ContactType::"Bank Account":
//                                 if PAGE.RunModal(0, BankAcc) = ACTION::LookupOK then begin
//                                     Text := BankAcc."No.";
//                                     exit(true);
//                                 end;
//                         end;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         NS_SetDocNo('');
//                         NS_SetPostingDate('');
//                         NS_ClearTrackingInfo;
//                         NS_ContactNoOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//                 field(ExtDocNo; ExtDocNo)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'External Document No.';
//                     ToolTip = 'Specifies the document number assigned by the vendor.';

//                     trigger OnValidate()
//                     begin
//                         NS_SetDocNo('');
//                         NS_SetPostingDate('');
//                         NS_ClearTrackingInfo;
//                         NS_ExtDocNoOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//             }
//             group("Item Reference")
//             {
//                 Caption = 'Item Reference';
//                 Visible = ItemReferenceVisible;
//                 field(SerialNoFilter; SerialNoFilter)
//                 {
//                     ApplicationArea = ItemTracking;
//                     Caption = 'Serial No.';
//                     ToolTip = 'Specifies the posting date of the document when you have opened the Navigate window from the document. The entry''s document number is shown in the Document No. field.';

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         SerialNoInformationList: Page "Serial No. Information List";
//                     begin
//                         Clear(SerialNoInformationList);
//                         if SerialNoInformationList.RunModal = ACTION::LookupOK then begin
//                             Text := SerialNoInformationList.GetSelectionFilter;
//                             exit(true);
//                         end;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         NS_ClearInfo;
//                         NS_SerialNoFilterOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//                 field(LotNoFilter; LotNoFilter)
//                 {
//                     ApplicationArea = ItemTracking;
//                     Caption = 'Lot No.';
//                     ToolTip = 'Specifies the number that you want to find entries for.';

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         LotNoInformationList: Page "Lot No. Information List";
//                     begin
//                         Clear(LotNoInformationList);
//                         if LotNoInformationList.RunModal = ACTION::LookupOK then begin
//                             Text := LotNoInformationList.GetSelectionFilter;
//                             exit(true);
//                         end;
//                     end;

//                     trigger OnValidate()
//                     begin
//                         NS_ClearInfo;
//                         NS_LotNoFilterOnAfterValidate;
//                         NS_FilterSelectionChanged;
//                     end;
//                 }
//             }
//             group(Notification)
//             {
//                 Caption = 'Notification';
//                 InstructionalText = 'The filter has been changed. Choose Find to update the list of related entries.';
//                 Visible = FilterSelectionChangedTxtVisible;
//             }
//             repeater(Control16)
//             {
//                 Editable = false;
//                 ShowCaption = false;
//                 field("Entry No."; Rec."Entry No.")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
//                     Visible = false;
//                 }
//                 field("Table ID"; Rec."Table ID")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     ToolTip = 'Specifies the table that the entry is stored in.';
//                     Visible = false;
//                 }
//                 field("Table Name"; Rec."Table Name")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Related Entries';
//                     ToolTip = 'Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.';
//                 }
//                 field("No. of Records"; Rec."No. of Records")
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'No. of Entries';
//                     DrillDown = true;
//                     ToolTip = 'Specifies the number of documents that the Navigate facility has found in the table with the selected entries.';

//                     trigger OnDrillDown()
//                     begin
//                         NS_ShowRecords;
//                     end;
//                 }
//             }
//             group(Source)
//             {
//                 Caption = 'Source';
//                 field(DocType; DocType)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Document Type';
//                     Editable = false;
//                     Enabled = DocTypeEnable;
//                     ToolTip = 'Specifies the type of the selected document. Leave the Document Type field blank if you want to search by posting date. The entry''s document number is shown in the Document No. field.';
//                 }
//                 field(SourceType; SourceType)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Source Type';
//                     Editable = false;
//                     Enabled = SourceTypeEnable;
//                     ToolTip = 'Specifies the source type of the selected document or remains blank if you search by posting date. The entry''s document number is shown in the Document No. field.';
//                 }
//                 field(SourceNo; SourceNo)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Source No.';
//                     Editable = false;
//                     Enabled = SourceNoEnable;
//                     ToolTip = 'Specifies the source number of the selected document. The entry''s document number is shown in the Document No. field.';
//                 }
//                 field(SourceName; SourceName)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Source Name';
//                     Editable = false;
//                     Enabled = SourceNameEnable;
//                     ToolTip = 'Specifies the source name on the selected entry. The entry''s document number is shown in the Document No. field.';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             group(Process)
//             {
//                 Caption = 'Process';
//                 action(Show)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Show Related Entries';
//                     Enabled = ShowEnable;
//                     Image = ViewDocumentLine;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ToolTip = 'View the related entries of the type that you have chosen.';

//                     trigger OnAction()
//                     begin
//                         NS_ShowRecords;
//                     end;
//                 }
//                 action(Find)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Fi&nd';
//                     Image = Find;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ToolTip = 'Apply a filter to search on this page.';

//                     trigger OnAction()
//                     begin
//                         NS_FindPush;
//                         FilterSelectionChangedTxtVisible := false;
//                     end;
//                 }
//                 action(Print)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = '&Print';
//                     Ellipsis = true;
//                     Enabled = PrintEnable;
//                     Image = Print;
//                     Promoted = true;
//                     PromotedCategory = Process;
//                     PromotedIsBig = true;
//                     ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

//                     trigger OnAction()
//                     var
//                         ItemTrackingNavigate: Report "Item Tracking Navigate";
//                         DocumentEntries: Report "Document Entries";
//    NSItemTracing: page "Item Tracing";  //PE-267.JS.1.0 05MAR2024
//    NSTraceMethod2: Option "Origin->Usage","Usage->Origin"; //PE-267.JS.1.0 05MAR2024
//    NSShowComponents2: Option No,"Item-tracked Only",All; //PE-267.JS.1.0 05MAR2024
//                     begin
//                         if NS_ItemTrackingSearch then begin
//                             Clear(ItemTrackingNavigate);
//                             ItemTrackingNavigate.TransferDocEntries(Rec);
//                             ItemTrackingNavigate.TransferRecordBuffer(TempRecordBuffer);
//PE-267.JS.1.0 05MAR2024 - Start
//ItemTrackingNavigate.TransferFilters(SerialNoFilter, LotNoFilter, '', '');                            
//NSItemTracing.SetItemFilters(NSTraceMethod2::"Usage->Origin", NSShowComponents2::All, SerialNoFilter, LotNoFilter, '', '');
//PE-267.JS.1.0 05MAR2024 - end
//                             ItemTrackingNavigate.Run;
//                         end else begin
//                             //PPDA.1.0 Start
//                             OnBeforeSetDocumentEntries(Rec, DocNoFilter, PostingDateFilter, NavigateDeposit);
//                             // DocumentEntries.TransferDocEntries(Rec);
//                             // DocumentEntries.TransferFilters(DocNoFilter, PostingDateFilter);
//                             // if NavigateDeposit then
//                             //     DocumentEntries.SetExternal;
//                             // DocumentEntries.Run;
//                             //PPDA.1.0 End
//                         end;
//                     end;
//                 }
//             }
//             group(FindGroup)
//             {
//                 Caption = 'Find by';
//                 action(FindByDocument)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Find by Document';
//                     Image = Documents;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ToolTip = 'View entries based on the specified document number.';

//                     trigger OnAction()
//                     begin
//                         FindBasedOn := FindBasedOn::Document;
//                         NS_UpdateFindByGroupsVisibility;
//                     end;
//                 }
//                 action(FindByBusinessContact)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Find by Business Contact';
//                     Image = ContactPerson;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ToolTip = 'Filter entries based on the specified contact or contact type.';

//                     trigger OnAction()
//                     begin
//                         FindBasedOn := FindBasedOn::"Business Contact";
//                         NS_UpdateFindByGroupsVisibility;
//                     end;
//                 }
//                 action(FindByItemReference)
//                 {
//                     ApplicationArea = Basic, Suite;
//                     Caption = 'Find by Item Reference';
//                     Image = ItemTracking;
//                     Promoted = true;
//                     PromotedCategory = Category4;
//                     PromotedIsBig = true;
//                     ToolTip = 'Filter entries based on the specified serial number or lot number.';

//                     trigger OnAction()
//                     begin
//                         FindBasedOn := FindBasedOn::"Item Reference";
//                         NS_UpdateFindByGroupsVisibility;
//                     end;
//                 }
//             }
//         }
//     }

//     trigger OnInit()
//     begin
//         SourceNameEnable := true;
//         SourceNoEnable := true;
//         SourceTypeEnable := true;
//         DocTypeEnable := true;
//         PrintEnable := true;
//         ShowEnable := true;
//         DocumentVisible := true;
//         FindBasedOn := FindBasedOn::Document;
//     end;

//     trigger OnOpenPage()
//     begin
//         UpdateForm := true;
//         NS_FindRecordsOnOpen;
//         //ProjectPro - start
//         PP_JobsSetup.Get;
//         PP_SalesSetup.Get;
//         PP_PurchSetup.Get;
//         //ProjectPro - end
//     end;

//     var
//         Text000: Label 'The business contact type was not specified.';
//         Text001: Label 'There are no posted records with this external document number.';
//         Text002: Label 'Counting records...';
//         Text003: Label 'Posted Sales Invoice';
//         Text004: Label 'Posted Sales Credit Memo';
//         Text005: Label 'Posted Sales Shipment';
//         Text006: Label 'Issued Reminder';
//         Text007: Label 'Issued Finance Charge Memo';
//         Text008: Label 'Posted Purchase Invoice';
//         Text009: Label 'Posted Purchase Credit Memo';
//         Text010: Label 'Posted Purchase Receipt';
//         Text011: Label 'The document number has been used more than once.';
//         Text012: Label 'This combination of document number and posting date has been used more than once.';
//         Text013: Label 'There are no posted records with this document number.';
//         Text014: Label 'There are no posted records with this combination of document number and posting date.';
//         Text015: Label 'The search results in too many external documents. Specify a business contact no.';
//         Text016: Label 'The search results in too many external documents. Use Navigate from the relevant ledger entries.';
//         Text017: Label 'Posted Return Receipt';
//         Text018: Label 'Posted Return Shipment';
//         Text019: Label 'Posted Transfer Shipment';
//         Text020: Label 'Posted Transfer Receipt';
//         Text021: Label 'Sales Order';
//         Text022: Label 'Sales Invoice';
//         Text023: Label 'Sales Return Order';
//         Text024: Label 'Sales Credit Memo';
//         Text025: Label 'Posted Assembly Order';
//         sText003: Label 'Posted Service Invoice';
//         sText004: Label 'Posted Service Credit Memo';
//         sText005: Label 'Posted Service Shipment';
//         sText021: Label 'Service Order';
//         sText022: Label 'Service Invoice';
//         sText024: Label 'Service Credit Memo';
//         Text99000000: Label 'Production Order';
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         Cust: Record Customer;
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         Vend: Record Vendor;
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         Bank: Record "Bank Account";
//         SOSalesHeader: Record "Sales Header";
//         SISalesHeader: Record "Sales Header";
//         SROSalesHeader: Record "Sales Header";
//         SCMSalesHeader: Record "Sales Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         SalesShptHeader: Record "Sales Shipment Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         SalesInvHeader: Record "Sales Invoice Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ReturnRcptHeader: Record "Return Receipt Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
//         SOServHeader: Record "Service Header";
//         SIServHeader: Record "Service Header";
//         SCMServHeader: Record "Service Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ServShptHeader: Record "Service Shipment Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ServInvHeader: Record "Service Invoice Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ServCrMemoHeader: Record "Service Cr.Memo Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         IssuedReminderHeader: Record "Issued Reminder Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PurchRcptHeader: Record "Purch. Rcpt. Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PurchInvHeader: Record "Purch. Inv. Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ReturnShptHeader: Record "Return Shipment Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ProductionOrderHeader: Record "Production Order";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PostedAssemblyHeader: Record "Posted Assembly Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         TransShptHeader: Record "Transfer Shipment Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         TransRcptHeader: Record "Transfer Receipt Header";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PostedWhseShptLine: Record "Posted Whse. Shipment Line";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         GLEntry: Record "G/L Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         VATEntry: Record "VAT Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         CustLedgEntry: Record "Cust. Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         VendLedgEntry: Record "Vendor Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         EmplLedgEntry: Record "Employee Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         DtldEmplLedgEntry: Record "Detailed Employee Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ItemLedgEntry: Record "Item Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         PhysInvtLedgEntry: Record "Phys. Inventory Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ResLedgEntry: Record "Res. Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         JobLedgEntry: Record "Job Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         JobWIPEntry: Record "Job WIP Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         JobWIPGLEntry: Record "Job WIP G/L Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ValueEntry: Record "Value Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         BankAccLedgEntry: Record "Bank Account Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         CheckLedgEntry: Record "Check Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ReminderEntry: Record "Reminder/Fin. Charge Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         FALedgEntry: Record "FA Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         InsuranceCovLedgEntry: Record "Ins. Coverage Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         CapacityLedgEntry: Record "Capacity Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         ServLedgerEntry: Record "Service Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         WarrantyLedgerEntry: Record "Warranty Ledger Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         WhseEntry: Record "Warehouse Entry";
//         TempRecordBuffer: Record "Record Buffer" temporary;
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         CostEntry: Record "Cost Entry";
//         [SecurityFiltering(SecurityFilter::Filtered)]

//         //PPDA.1.0 Start
//         // PostedDepositHeader: Record "Posted Deposit Header";
//         // [SecurityFiltering(SecurityFilter::Filtered)]
//         // PostedDepositLine: Record "Posted Deposit Line";
//         // [SecurityFiltering(SecurityFilter::Filtered)]
//         //PPDA.1.0 End
//         IncomingDocument: Record "Incoming Document";
//         TextManagement: Codeunit "Filter Tokens";
//         ItemTrackingNavigateMgt: Codeunit "Item Tracking Navigate Mgt.";
//         Window: Dialog;
//         DocNoFilter: Text;
//         PostingDateFilter: Text;
//         NewDocNo: Code[20];
//         ContactNo: Code[250];
//         ExtDocNo: Code[250];
//         NewPostingDate: Date;
//         DocType: Text[100];
//         SourceType: Text[30];
//         SourceNo: Code[20];
//         SourceName: Text[50];
//         ContactType: Option " ",Vendor,Customer,"Bank Account";
//         DocExists: Boolean;
//         NavigateDeposit: Boolean;
//         USText001: Label 'Before you can navigate on a deposit, you must create and activate a key group called "NavDep". If you cannot do this yourself, ask your system administrator.';
//         NewSerialNo: Code[50];
//         NewLotNo: Code[50];
//         SerialNoFilter: Text;
//         LotNoFilter: Text;
//         [InDataSet]
//         ShowEnable: Boolean;
//         [InDataSet]
//         PrintEnable: Boolean;
//         [InDataSet]
//         DocTypeEnable: Boolean;
//         [InDataSet]
//         SourceTypeEnable: Boolean;
//         [InDataSet]
//         SourceNoEnable: Boolean;
//         [InDataSet]
//         SourceNameEnable: Boolean;
//         UpdateForm: Boolean;
//         FindBasedOn: Option Document,"Business Contact","Item Reference";
//         [InDataSet]
//         DocumentVisible: Boolean;
//         [InDataSet]
//         BusinessContactVisible: Boolean;
//         [InDataSet]
//         ItemReferenceVisible: Boolean;
//         [InDataSet]
//         FilterSelectionChangedTxtVisible: Boolean;
//         PageCaptionTxt: Label 'Selected - %1';
//         PP_JobsSetup: Record "Jobs Setup";
//         PP_SalesSetup: Record "Sales & Receivables Setup";
//         PP_PurchSetup: Record "Purchases & Payables Setup";
//         PP_NewLedgerNo: Code[20];
//         PP_LedgerNoFilter: Code[1000];
//         PP_RetentionLedgerCode: Record "NS_Retention Ledger Code";
//         PP_SubcontractLedgEntry: Record "NS_Subcontract Ledger Entry";
//         Text14021100: Label 'Detailed ';

//     [Scope('Cloud')]
//     procedure NS_SetDoc(PostingDate: Date; DocNo: Code[20])
//     begin
//         //ProjectPro - start
//         Clear(PP_NewLedgerNo);
//         //ProjectPro - end
//         NewDocNo := DocNo;
//         NewPostingDate := PostingDate;
//     end;

//     local procedure NS_FindExtRecords()
//     var
//         [SecurityFiltering(SecurityFilter::Filtered)]
//         VendLedgEntry2: Record "Vendor Ledger Entry";
//         FoundRecords: Boolean;
//         DateFilter2: Text;
//         DocNoFilter2: Text;
//     begin
//         FoundRecords := false;
//         case ContactType of
//             ContactType::Vendor:
//                 begin
//                     VendLedgEntry2.SetCurrentKey("External Document No.");
//                     VendLedgEntry2.SetFilter("External Document No.", ExtDocNo);
//                     VendLedgEntry2.SetFilter("Vendor No.", ContactNo);
//                     if VendLedgEntry2.FindSet then begin
//                         repeat
//                             NS_MakeExtFilter(
//                               DateFilter2,
//                               VendLedgEntry2."Posting Date",
//                               DocNoFilter2,
//                               VendLedgEntry2."Document No.");
//                         until VendLedgEntry2.Next = 0;
//                         NS_SetPostingDate(DateFilter2);
//                         NS_SetDocNo(DocNoFilter2);
//                         NS_FindRecords;
//                         FoundRecords := true;
//                     end;
//                 end;
//             ContactType::Customer:
//                 begin
//                     DeleteAll;
//                     "Entry No." := 0;
//                     NS_FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Order, Text021, SOSalesHeader);
//                     NS_FindUnpostedSalesDocs(SISalesHeader."Document Type"::Invoice, Text022, SISalesHeader);
//                     NS_FindUnpostedSalesDocs(SROSalesHeader."Document Type"::"Return Order", Text023, SROSalesHeader);
//                     NS_FindUnpostedSalesDocs(SCMSalesHeader."Document Type"::"Credit Memo", Text024, SCMSalesHeader);
//                     if SalesShptHeader.ReadPermission then begin
//                         SalesShptHeader.Reset;
//                         SalesShptHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
//                         SalesShptHeader.SetFilter("Sell-to Customer No.", ContactNo);
//                         SalesShptHeader.SetFilter("External Document No.", ExtDocNo);
//                         NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Shipment Header", 0, Text005, SalesShptHeader.Count);
//                     end;
//                     if SalesInvHeader.ReadPermission then begin
//                         SalesInvHeader.Reset;
//                         SalesInvHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
//                         SalesInvHeader.SetFilter("Sell-to Customer No.", ContactNo);
//                         SalesInvHeader.SetFilter("External Document No.", ExtDocNo);
//                         NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Invoice Header", 0, Text003, SalesInvHeader.Count);
//                     end;
//                     if ReturnRcptHeader.ReadPermission then begin
//                         ReturnRcptHeader.Reset;
//                         ReturnRcptHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
//                         ReturnRcptHeader.SetFilter("Sell-to Customer No.", ContactNo);
//                         ReturnRcptHeader.SetFilter("External Document No.", ExtDocNo);
//                         NS_InsertIntoDocEntry(Rec, DATABASE::"Return Receipt Header", 0, Text017, ReturnRcptHeader.Count);
//                     end;
//                     if SalesCrMemoHeader.ReadPermission then begin
//                         SalesCrMemoHeader.Reset;
//                         SalesCrMemoHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
//                         SalesCrMemoHeader.SetFilter("Sell-to Customer No.", ContactNo);
//                         SalesCrMemoHeader.SetFilter("External Document No.", ExtDocNo);
//                         NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Cr.Memo Header", 0, Text004, SalesCrMemoHeader.Count);
//                     end;
//                     NS_FindUnpostedServDocs(SOServHeader."Document Type"::Order, sText021, SOServHeader);
//                     NS_FindUnpostedServDocs(SIServHeader."Document Type"::Invoice, sText022, SIServHeader);
//                     NS_FindUnpostedServDocs(SCMServHeader."Document Type"::"Credit Memo", sText024, SCMServHeader);
//                     if ServShptHeader.ReadPermission then
//                         if ExtDocNo = '' then begin
//                             ServShptHeader.Reset;
//                             ServShptHeader.SetCurrentKey("Customer No.");
//                             ServShptHeader.SetFilter("Customer No.", ContactNo);
//                             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Shipment Header", 0, sText005, ServShptHeader.Count);
//                         end;
//                     if ServInvHeader.ReadPermission then
//                         if ExtDocNo = '' then begin
//                             ServInvHeader.Reset;
//                             ServInvHeader.SetCurrentKey("Customer No.");
//                             ServInvHeader.SetFilter("Customer No.", ContactNo);
//                             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Invoice Header", 0, sText003, ServInvHeader.Count);
//                         end;
//                     if ServCrMemoHeader.ReadPermission then
//                         if ExtDocNo = '' then begin
//                             ServCrMemoHeader.Reset;
//                             ServCrMemoHeader.SetCurrentKey("Customer No.");
//                             ServCrMemoHeader.SetFilter("Customer No.", ContactNo);
//                             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Cr.Memo Header", 0, sText004, ServCrMemoHeader.Count);
//                         end;

//                     DocExists := FindFirst;

//                     NS_UpdateFormAfterFindRecords;
//                     FoundRecords := DocExists;
//                 end;
//             else
//                 Error(Text000);
//         end;

//         if not FoundRecords then begin
//             NS_SetSource(0D, '', '', 0, '');
//             Message(Text001);
//         end;
//     end;

//     local procedure NS_FindRecords()
//     begin
//         Window.Open(Text002);
//         Reset;
//         DeleteAll;
//         "Entry No." := 0;
//         NS_FindIncomingDocumentRecords;
//         NS_FindEmployeeRecords;
//         NS_FindSalesShipmentHeader;
//         if SalesInvHeader.ReadPermission then begin
//             SalesInvHeader.Reset;
//             SalesInvHeader.SetFilter("No.", DocNoFilter);
//             SalesInvHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Invoice Header", 0, Text003, SalesInvHeader.Count);
//         end;
//         if ReturnRcptHeader.ReadPermission then begin
//             ReturnRcptHeader.Reset;
//             ReturnRcptHeader.SetFilter("No.", DocNoFilter);
//             ReturnRcptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Return Receipt Header", 0, Text017, ReturnRcptHeader.Count);
//         end;
//         if SalesCrMemoHeader.ReadPermission then begin
//             SalesCrMemoHeader.Reset;
//             SalesCrMemoHeader.SetFilter("No.", DocNoFilter);
//             SalesCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Cr.Memo Header", 0, Text004, SalesCrMemoHeader.Count);
//         end;
//         if ServShptHeader.ReadPermission then begin
//             ServShptHeader.Reset;
//             ServShptHeader.SetFilter("No.", DocNoFilter);
//             ServShptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Shipment Header", 0, sText005, ServShptHeader.Count);
//         end;
//         if ServInvHeader.ReadPermission then begin
//             ServInvHeader.Reset;
//             ServInvHeader.SetFilter("No.", DocNoFilter);
//             ServInvHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Invoice Header", 0, sText003, ServInvHeader.Count);
//         end;
//         if ServCrMemoHeader.ReadPermission then begin
//             ServCrMemoHeader.Reset;
//             ServCrMemoHeader.SetFilter("No.", DocNoFilter);
//             ServCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Cr.Memo Header", 0, sText004, ServCrMemoHeader.Count);
//         end;
//         if IssuedReminderHeader.ReadPermission then begin
//             IssuedReminderHeader.Reset;
//             IssuedReminderHeader.SetFilter("No.", DocNoFilter);
//             IssuedReminderHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Issued Reminder Header", 0, Text006, IssuedReminderHeader.Count);
//         end;
//         if IssuedFinChrgMemoHeader.ReadPermission then begin
//             IssuedFinChrgMemoHeader.Reset;
//             IssuedFinChrgMemoHeader.SetFilter("No.", DocNoFilter);
//             IssuedFinChrgMemoHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Issued Fin. Charge Memo Header", 0, Text007, IssuedFinChrgMemoHeader.Count);
//         end;
//         if PurchRcptHeader.ReadPermission then begin
//             PurchRcptHeader.Reset;
//             PurchRcptHeader.SetFilter("No.", DocNoFilter);
//             PurchRcptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Purch. Rcpt. Header", 0, Text010, PurchRcptHeader.Count);
//         end;
//         if PurchInvHeader.ReadPermission then begin
//             PurchInvHeader.Reset;
//             PurchInvHeader.SetFilter("No.", DocNoFilter);
//             PurchInvHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Purch. Inv. Header", 0, Text008, PurchInvHeader.Count);
//         end;
//         if ReturnShptHeader.ReadPermission then begin
//             ReturnShptHeader.Reset;
//             ReturnShptHeader.SetFilter("No.", DocNoFilter);
//             ReturnShptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Return Shipment Header", 0, Text018, ReturnShptHeader.Count);
//         end;
//         if PurchCrMemoHeader.ReadPermission then begin
//             PurchCrMemoHeader.Reset;
//             PurchCrMemoHeader.SetFilter("No.", DocNoFilter);
//             PurchCrMemoHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Purch. Cr. Memo Hdr.", 0, Text009, PurchCrMemoHeader.Count);
//         end;
//         if ProductionOrderHeader.ReadPermission then begin
//             ProductionOrderHeader.Reset;
//             ProductionOrderHeader.SetRange(
//               Status,
//               ProductionOrderHeader.Status::Released,
//               ProductionOrderHeader.Status::Finished);
//             ProductionOrderHeader.SetFilter("No.", DocNoFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Production Order", 0, Text99000000, ProductionOrderHeader.Count);
//         end;
//         if PostedAssemblyHeader.ReadPermission then begin
//             PostedAssemblyHeader.Reset;
//             PostedAssemblyHeader.SetFilter("No.", DocNoFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Assembly Header", 0, Text025, PostedAssemblyHeader.Count);
//         end;
//         if TransShptHeader.ReadPermission then begin
//             TransShptHeader.Reset;
//             TransShptHeader.SetFilter("No.", DocNoFilter);
//             TransShptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Transfer Shipment Header", 0, Text019, TransShptHeader.Count);
//         end;
//         if TransRcptHeader.ReadPermission then begin
//             TransRcptHeader.Reset;
//             TransRcptHeader.SetFilter("No.", DocNoFilter);
//             TransRcptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Transfer Receipt Header", 0, Text020, TransRcptHeader.Count);
//         end;
//         if PostedWhseShptLine.ReadPermission then begin
//             PostedWhseShptLine.Reset;
//             PostedWhseShptLine.SetCurrentKey("Posted Source No.", "Posting Date");
//             PostedWhseShptLine.SetFilter("Posted Source No.", DocNoFilter);
//             PostedWhseShptLine.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Whse. Shipment Line", 0, PostedWhseShptLine.TableCaption, PostedWhseShptLine.Count);
//         end;
//         if PostedWhseRcptLine.ReadPermission then begin
//             PostedWhseRcptLine.Reset;
//             PostedWhseRcptLine.SetCurrentKey("Posted Source No.", "Posting Date");
//             PostedWhseRcptLine.SetFilter("Posted Source No.", DocNoFilter);
//             PostedWhseRcptLine.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Whse. Receipt Line", 0, PostedWhseRcptLine.TableCaption, PostedWhseRcptLine.Count);
//         end;
//         if GLEntry.ReadPermission then begin
//             GLEntry.Reset;
//             GLEntry.SetCurrentKey("Document No.", "Posting Date");
//             GLEntry.SetFilter("Document No.", DocNoFilter);
//             GLEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"G/L Entry", 0, GLEntry.TableCaption, GLEntry.Count);
//         end;
//         if VATEntry.ReadPermission then begin
//             VATEntry.Reset;
//             VATEntry.SetCurrentKey("Document No.", "Posting Date");
//             VATEntry.SetFilter("Document No.", DocNoFilter);
//             VATEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"VAT Entry", 0, VATEntry.TableCaption, VATEntry.Count);
//         end;
//         if CustLedgEntry.ReadPermission then begin
//             CustLedgEntry.Reset;
//             CustLedgEntry.SetCurrentKey("Document No.");
//             CustLedgEntry.SetFilter("Document No.", DocNoFilter);
//             CustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             //ProjectPro - start
//             if PP_LedgerNoFilter > '' then begin
//                 CustLedgEntry.SetFilter("NS_Retention Ledger Code", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.Get(PP_JobsSetup."NS_Retention Receivable Ledger", PP_LedgerNoFilter);
//             end
//             else
//                 //ProjectPro - end
//                 NS_InsertIntoDocEntry(Rec, DATABASE::"Cust. Ledger Entry", 0, CustLedgEntry.TableCaption, CustLedgEntry.Count);
//         end;
//         if DtldCustLedgEntry.ReadPermission then begin
//             DtldCustLedgEntry.Reset;
//             DtldCustLedgEntry.SetCurrentKey("Document No.");
//             DtldCustLedgEntry.SetFilter("Document No.", DocNoFilter);
//             DtldCustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             //ProjectPro - start
//             if PP_LedgerNoFilter > '' then begin
//                 DtldCustLedgEntry.SetFilter("NS_Retention Ledger Code", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.Get(PP_JobsSetup."NS_Retention Receivable Ledger", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.NS_Code := Text14021100 + PP_RetentionLedgerCode.NS_Description;
//             end
//             else
//                 //ProjectPro - end
//                 NS_InsertIntoDocEntry(Rec, DATABASE::"Detailed Cust. Ledg. Entry", 0, DtldCustLedgEntry.TableCaption, DtldCustLedgEntry.Count);
//         end;
//         if ReminderEntry.ReadPermission then begin
//             ReminderEntry.Reset;
//             ReminderEntry.SetCurrentKey(Type, "No.");
//             ReminderEntry.SetFilter("No.", DocNoFilter);
//             ReminderEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Reminder/Fin. Charge Entry", 0, ReminderEntry.TableCaption, ReminderEntry.Count);
//         end;
//         if VendLedgEntry.ReadPermission then begin
//             VendLedgEntry.Reset;
//             VendLedgEntry.SetCurrentKey("Document No.");
//             VendLedgEntry.SetFilter("Document No.", DocNoFilter);
//             VendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             //ProjectPro - start
//             if PP_LedgerNoFilter > '' then begin
//                 VendLedgEntry.SetFilter("NS_Retention Ledger Code", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.Get(PP_JobsSetup."NS_Retention Payable Ledger", PP_LedgerNoFilter);
//             end
//             else
//                 //ProjectPro - end
//                 NS_InsertIntoDocEntry(Rec, DATABASE::"Vendor Ledger Entry", 0, VendLedgEntry.TableCaption, VendLedgEntry.Count);
//         end;
//         if DtldVendLedgEntry.ReadPermission then begin
//             DtldVendLedgEntry.Reset;
//             DtldVendLedgEntry.SetCurrentKey("Document No.");
//             DtldVendLedgEntry.SetFilter("Document No.", DocNoFilter);
//             DtldVendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             //ProjectPro - start
//             if PP_LedgerNoFilter > '' then begin
//                 DtldVendLedgEntry.SetFilter("NS_Retention Ledger Code", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.Get(PP_JobsSetup."NS_Retention Payable Ledger", PP_LedgerNoFilter);
//                 PP_RetentionLedgerCode.NS_Code := Text14021100 + PP_RetentionLedgerCode.NS_Description;
//             end
//             else
//                 //ProjectPro - end
//                 NS_InsertIntoDocEntry(Rec, DATABASE::"Detailed Vendor Ledg. Entry", 0, DtldVendLedgEntry.TableCaption, DtldVendLedgEntry.Count);
//         end;
//         if ItemLedgEntry.ReadPermission then begin
//             ItemLedgEntry.Reset;
//             ItemLedgEntry.SetCurrentKey("Document No.");
//             ItemLedgEntry.SetFilter("Document No.", DocNoFilter);
//             ItemLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Item Ledger Entry", 0, ItemLedgEntry.TableCaption, ItemLedgEntry.Count);
//         end;
//         if ValueEntry.ReadPermission then begin
//             ValueEntry.Reset;
//             ValueEntry.SetCurrentKey("Document No.");
//             ValueEntry.SetFilter("Document No.", DocNoFilter);
//             ValueEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Value Entry", 0, ValueEntry.TableCaption, ValueEntry.Count);
//         end;
//         if PhysInvtLedgEntry.ReadPermission then begin
//             PhysInvtLedgEntry.Reset;
//             PhysInvtLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             PhysInvtLedgEntry.SetFilter("Document No.", DocNoFilter);
//             PhysInvtLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Phys. Inventory Ledger Entry", 0, PhysInvtLedgEntry.TableCaption, PhysInvtLedgEntry.Count);
//         end;
//         if ResLedgEntry.ReadPermission then begin
//             ResLedgEntry.Reset;
//             ResLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             ResLedgEntry.SetFilter("Document No.", DocNoFilter);
//             ResLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Res. Ledger Entry", 0, ResLedgEntry.TableCaption, ResLedgEntry.Count);
//         end;
//         NS_FindJobRecords;
//         if BankAccLedgEntry.ReadPermission then begin
//             BankAccLedgEntry.Reset;
//             BankAccLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             BankAccLedgEntry.SetFilter("Document No.", DocNoFilter);
//             BankAccLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Bank Account Ledger Entry", 0, BankAccLedgEntry.TableCaption, BankAccLedgEntry.Count);
//         end;
//         if CheckLedgEntry.ReadPermission then begin
//             CheckLedgEntry.Reset;
//             CheckLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             CheckLedgEntry.SetFilter("Document No.", DocNoFilter);
//             CheckLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Check Ledger Entry", 0, CheckLedgEntry.TableCaption, CheckLedgEntry.Count);
//         end;
//         if FALedgEntry.ReadPermission then begin
//             FALedgEntry.Reset;
//             FALedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             FALedgEntry.SetFilter("Document No.", DocNoFilter);
//             FALedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"FA Ledger Entry", 0, FALedgEntry.TableCaption, FALedgEntry.Count);
//         end;
//         if MaintenanceLedgEntry.ReadPermission then begin
//             MaintenanceLedgEntry.Reset;
//             MaintenanceLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             MaintenanceLedgEntry.SetFilter("Document No.", DocNoFilter);
//             MaintenanceLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Maintenance Ledger Entry", 0, MaintenanceLedgEntry.TableCaption, MaintenanceLedgEntry.Count);
//         end;
//         if InsuranceCovLedgEntry.ReadPermission then begin
//             InsuranceCovLedgEntry.Reset;
//             InsuranceCovLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             InsuranceCovLedgEntry.SetFilter("Document No.", DocNoFilter);
//             InsuranceCovLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(
//             Rec, DATABASE::"Ins. Coverage Ledger Entry", 0, InsuranceCovLedgEntry.TableCaption, InsuranceCovLedgEntry.Count);
//         end;
//         if CapacityLedgEntry.ReadPermission then begin
//             CapacityLedgEntry.Reset;
//             CapacityLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             CapacityLedgEntry.SetFilter("Document No.", DocNoFilter);
//             CapacityLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Capacity Ledger Entry", 0, CapacityLedgEntry.TableCaption, CapacityLedgEntry.Count);
//         end;
//         if WhseEntry.ReadPermission then begin
//             WhseEntry.Reset;
//             WhseEntry.SetCurrentKey("Reference No.", "Registering Date");
//             WhseEntry.SetFilter("Reference No.", DocNoFilter);
//             WhseEntry.SetFilter("Registering Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Warehouse Entry", 0, WhseEntry.TableCaption, WhseEntry.Count);
//         end;

//         if ServLedgerEntry.ReadPermission then begin
//             ServLedgerEntry.Reset;
//             ServLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
//             ServLedgerEntry.SetFilter("Document No.", DocNoFilter);
//             ServLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Service Ledger Entry", 0, ServLedgerEntry.TableCaption, ServLedgerEntry.Count);
//         end;
//         if WarrantyLedgerEntry.ReadPermission then begin
//             WarrantyLedgerEntry.Reset;
//             WarrantyLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
//             WarrantyLedgerEntry.SetFilter("Document No.", DocNoFilter);
//             WarrantyLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Warranty Ledger Entry", 0, WarrantyLedgerEntry.TableCaption, WarrantyLedgerEntry.Count);
//         end;

//         if CostEntry.ReadPermission then begin
//             CostEntry.Reset;
//             CostEntry.SetCurrentKey("Document No.", "Posting Date");
//             CostEntry.SetFilter("Document No.", DocNoFilter);
//             CostEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Cost Entry", 0, CostEntry.TableCaption, CostEntry.Count);
//         end;

//         //PPDA.1.0 Start

//         // if PostedDepositHeader.ReadPermission then begin
//         //     PostedDepositHeader.Reset;
//         //     PostedDepositHeader.SetFilter("No.", DocNoFilter);
//         //     NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Header", 0, PostedDepositHeader.TableCaption, PostedDepositHeader.Count);
//         // end;
//         // if PostedDepositLine.ReadPermission then begin
//         //     PostedDepositLine.Reset;
//         //     PostedDepositLine.SetCurrentKey("Document No.", "Posting Date");
//         //     PostedDepositLine.SetFilter("Document No.", DocNoFilter);
//         //     PostedDepositLine.SetFilter("Posting Date", PostingDateFilter);
//         //     NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Line", 0, PostedDepositLine.TableCaption, PostedDepositLine.Count);
//         // end;
//         //PPDA.1.0 End

//         NS_OnAfterNavigateFindRecords(Rec, DocNoFilter, PostingDateFilter);
//         //ProjectPro - start
//         if PP_SubcontractLedgEntry.ReadPermission then begin
//             PP_SubcontractLedgEntry.Reset;
//             PP_SubcontractLedgEntry.SetCurrentKey("NS_Document No.", "NS_Posting Date");
//             PP_SubcontractLedgEntry.SetFilter("NS_Document No.", DocNoFilter);
//             PP_SubcontractLedgEntry.SetFilter("NS_Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"NS_Subcontract Ledger Entry", 0, PP_SubcontractLedgEntry.TableCaption, PP_SubcontractLedgEntry.Count);
//         end;
//         //ProjectPro - end
//         DocExists := FindFirst;

//         NS_SetSource(0D, '', '', 0, '');
//         if DocExists then begin
//             if (NS_NoOfRecords(DATABASE::"Cust. Ledger Entry") + NS_NoOfRecords(DATABASE::"Vendor Ledger Entry") <= 1) and
//                (NS_GetDocumentCount <= 1)
//             then begin
//                 // Service Management
//                 if NS_NoOfRecords(DATABASE::"Service Ledger Entry") = 1 then begin
//                     ServLedgerEntry.FindFirst;
//                     if ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract" then
//                         NS_SetSource(
//                           ServLedgerEntry."Posting Date", Format(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
//                           2, ServLedgerEntry."Service Contract No.")
//                     else
//                         NS_SetSource(
//                           ServLedgerEntry."Posting Date", Format(ServLedgerEntry."Document Type"), ServLedgerEntry."Document No.",
//                           2, ServLedgerEntry."Service Order No.")
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Warranty Ledger Entry") = 1 then begin
//                     WarrantyLedgerEntry.FindFirst;
//                     NS_SetSource(
//                       WarrantyLedgerEntry."Posting Date", '', WarrantyLedgerEntry."Document No.",
//                       2, WarrantyLedgerEntry."Service Order No.")
//                 end;

//                 // Sales
//                 if NS_NoOfRecords(DATABASE::"Cust. Ledger Entry") = 1 then begin
//                     CustLedgEntry.FindFirst;
//                     NS_SetSource(
//                       CustLedgEntry."Posting Date", Format(CustLedgEntry."Document Type"), CustLedgEntry."Document No.",
//                       1, CustLedgEntry."Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Detailed Cust. Ledg. Entry") = 1 then begin
//                     DtldCustLedgEntry.FindFirst;
//                     NS_SetSource(
//                       DtldCustLedgEntry."Posting Date", Format(DtldCustLedgEntry."Document Type"), DtldCustLedgEntry."Document No.",
//                       1, DtldCustLedgEntry."Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Sales Invoice Header") = 1 then begin
//                     SalesInvHeader.FindFirst;
//                     NS_SetSource(
//                       SalesInvHeader."Posting Date", Format("Table Name"), SalesInvHeader."No.",
//                       1, SalesInvHeader."Bill-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Sales Cr.Memo Header") = 1 then begin
//                     SalesCrMemoHeader.FindFirst;
//                     NS_SetSource(
//                       SalesCrMemoHeader."Posting Date", Format("Table Name"), SalesCrMemoHeader."No.",
//                       1, SalesCrMemoHeader."Bill-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Return Receipt Header") = 1 then begin
//                     ReturnRcptHeader.FindFirst;
//                     NS_SetSource(
//                       ReturnRcptHeader."Posting Date", Format("Table Name"), ReturnRcptHeader."No.",
//                       1, ReturnRcptHeader."Sell-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Sales Shipment Header") = 1 then begin
//                     SalesShptHeader.FindFirst;
//                     NS_SetSource(
//                       SalesShptHeader."Posting Date", Format("Table Name"), SalesShptHeader."No.",
//                       1, SalesShptHeader."Sell-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Posted Whse. Shipment Line") = 1 then begin
//                     PostedWhseShptLine.FindFirst;
//                     NS_SetSource(
//                       PostedWhseShptLine."Posting Date", Format("Table Name"), PostedWhseShptLine."Posted Source No.",
//                       1, PostedWhseShptLine."Destination No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Issued Reminder Header") = 1 then begin
//                     IssuedReminderHeader.FindFirst;
//                     NS_SetSource(
//                       IssuedReminderHeader."Posting Date", Format("Table Name"), IssuedReminderHeader."No.",
//                       1, IssuedReminderHeader."Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") = 1 then begin
//                     IssuedFinChrgMemoHeader.FindFirst;
//                     NS_SetSource(
//                       IssuedFinChrgMemoHeader."Posting Date", Format("Table Name"), IssuedFinChrgMemoHeader."No.",
//                       1, IssuedFinChrgMemoHeader."Customer No.");
//                 end;

//                 if NS_NoOfRecords(DATABASE::"Service Invoice Header") = 1 then begin
//                     ServInvHeader.FindFirst;
//                     NS_SetSource(
//                       ServInvHeader."Posting Date", Format("Table Name"), ServInvHeader."No.",
//                       1, ServInvHeader."Bill-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Service Cr.Memo Header") = 1 then begin
//                     ServCrMemoHeader.FindFirst;
//                     NS_SetSource(
//                       ServCrMemoHeader."Posting Date", Format("Table Name"), ServCrMemoHeader."No.",
//                       1, ServCrMemoHeader."Bill-to Customer No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Service Shipment Header") = 1 then begin
//                     ServShptHeader.FindFirst;
//                     NS_SetSource(
//                       ServShptHeader."Posting Date", Format("Table Name"), ServShptHeader."No.",
//                       1, ServShptHeader."Customer No.");
//                 end;

//                 // Purchase
//                 if NS_NoOfRecords(DATABASE::"Vendor Ledger Entry") = 1 then begin
//                     VendLedgEntry.FindFirst;
//                     NS_SetSource(
//                       VendLedgEntry."Posting Date", Format(VendLedgEntry."Document Type"), VendLedgEntry."Document No.",
//                       2, VendLedgEntry."Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Detailed Vendor Ledg. Entry") = 1 then begin
//                     DtldVendLedgEntry.FindFirst;
//                     NS_SetSource(
//                       DtldVendLedgEntry."Posting Date", Format(DtldVendLedgEntry."Document Type"), DtldVendLedgEntry."Document No.",
//                       2, DtldVendLedgEntry."Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Purch. Inv. Header") = 1 then begin
//                     PurchInvHeader.FindFirst;
//                     NS_SetSource(
//                       PurchInvHeader."Posting Date", Format("Table Name"), PurchInvHeader."No.",
//                       2, PurchInvHeader."Pay-to Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") = 1 then begin
//                     PurchCrMemoHeader.FindFirst;
//                     NS_SetSource(
//                       PurchCrMemoHeader."Posting Date", Format("Table Name"), PurchCrMemoHeader."No.",
//                       2, PurchCrMemoHeader."Pay-to Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Return Shipment Header") = 1 then begin
//                     ReturnShptHeader.FindFirst;
//                     NS_SetSource(
//                       ReturnShptHeader."Posting Date", Format("Table Name"), ReturnShptHeader."No.",
//                       2, ReturnShptHeader."Buy-from Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Purch. Rcpt. Header") = 1 then begin
//                     PurchRcptHeader.FindFirst;
//                     NS_SetSource(
//                       PurchRcptHeader."Posting Date", Format("Table Name"), PurchRcptHeader."No.",
//                       2, PurchRcptHeader."Buy-from Vendor No.");
//                 end;
//                 if NS_NoOfRecords(DATABASE::"Posted Whse. Receipt Line") = 1 then begin
//                     PostedWhseRcptLine.FindFirst;
//                     NS_SetSource(
//                       PostedWhseRcptLine."Posting Date", Format("Table Name"), PostedWhseRcptLine."Posted Source No.",
//                       2, '');
//                 end;

//                 //PPDA.1.0 Start
//                 OnBeforeSetSourceForDeposit();
//                 // if NS_NoOfRecords(DATABASE::"Posted Deposit Header") = 1 then begin
//                 //     PostedDepositHeader.FindFirst;
//                 //     NS_SetSource(
//                 //       PostedDepositHeader."Posting Date", Format("Table Name"), PostedDepositHeader."No.",
//                 //       4, PostedDepositHeader."Bank Account No.");
//                 // end;
//                 //PPDA.1.0 End
//             end else begin
//                 if DocNoFilter <> '' then
//                     if PostingDateFilter = '' then
//                         Message(Text011)
//                     else
//                         //ProjectPro - start
//                         if PP_LedgerNoFilter <> '' then
//                             //ProjectPro - end
//                             Message(Text012);
//             end;
//         end else
//             if PostingDateFilter = '' then
//                 Message(Text013)
//             else
//                 Message(Text014);

//         if UpdateForm then
//             NS_UpdateFormAfterFindRecords;
//         Window.Close;
//     end;

//     local procedure NS_FindJobRecords()
//     begin
//         if JobLedgEntry.ReadPermission then begin
//             JobLedgEntry.Reset;
//             JobLedgEntry.SetCurrentKey("Document No.", "Posting Date");
//             JobLedgEntry.SetFilter("Document No.", DocNoFilter);
//             JobLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Job Ledger Entry", 0, JobLedgEntry.TableCaption, JobLedgEntry.Count);
//         end;
//         if JobWIPEntry.ReadPermission then begin
//             JobWIPEntry.Reset;
//             JobWIPEntry.SetFilter("Document No.", DocNoFilter);
//             JobWIPEntry.SetFilter("WIP Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Job WIP Entry", 0, JobWIPEntry.TableCaption, JobWIPEntry.Count);
//         end;
//         if JobWIPGLEntry.ReadPermission then begin
//             JobWIPGLEntry.Reset;
//             JobWIPGLEntry.SetCurrentKey("Document No.", "Posting Date");
//             JobWIPGLEntry.SetFilter("Document No.", DocNoFilter);
//             JobWIPGLEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Job WIP G/L Entry", 0, JobWIPGLEntry.TableCaption, JobWIPGLEntry.Count);
//         end;
//     end;

//     local procedure NS_FindIncomingDocumentRecords()
//     begin
//         if IncomingDocument.ReadPermission then begin
//             IncomingDocument.Reset;
//             IncomingDocument.SetFilter("Document No.", DocNoFilter);
//             IncomingDocument.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Incoming Document", 0, IncomingDocument.TableCaption, IncomingDocument.Count);
//         end;
//     end;

//     local procedure NS_FindSalesShipmentHeader()
//     begin
//         if SalesShptHeader.ReadPermission then begin
//             SalesShptHeader.Reset;
//             SalesShptHeader.SetFilter("No.", DocNoFilter);
//             SalesShptHeader.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Shipment Header", 0, Text005, SalesShptHeader.Count);
//         end;
//     end;

//     local procedure NS_FindEmployeeRecords()
//     begin
//         if EmplLedgEntry.ReadPermission then begin
//             EmplLedgEntry.Reset;
//             EmplLedgEntry.SetCurrentKey("Document No.");
//             EmplLedgEntry.SetFilter("Document No.", DocNoFilter);
//             EmplLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Employee Ledger Entry", 0, EmplLedgEntry.TableCaption, EmplLedgEntry.Count);
//         end;
//         if DtldEmplLedgEntry.ReadPermission then begin
//             DtldEmplLedgEntry.Reset;
//             DtldEmplLedgEntry.SetCurrentKey("Document No.");
//             DtldEmplLedgEntry.SetFilter("Document No.", DocNoFilter);
//             DtldEmplLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Detailed Employee Ledger Entry", 0, DtldEmplLedgEntry.TableCaption, DtldEmplLedgEntry.Count);
//         end;
//     end;

//     local procedure NS_UpdateFormAfterFindRecords()
//     begin
//         NS_OnBeforeUpdateFormAfterFindRecords;

//         ShowEnable := DocExists;
//         PrintEnable := DocExists;
//         CurrPage.Update(false);
//         DocExists := FindFirst;
//         if DocExists then;
//     end;

//     [Scope('Cloud')]
//     procedure NS_InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Enum "Sales Document Type"; DocTableName: Text[1024]; DocNoOfRecords: Integer)
//     begin
//         if DocNoOfRecords = 0 then
//             exit;

//         with TempDocumentEntry do begin
//             Init;
//             "Entry No." := "Entry No." + 1;
//             "Table ID" := DocTableID;
//             "Document Type" := DocType.AsInteger();
//             "Table Name" := CopyStr(DocTableName, 1, MaxStrLen("Table Name"));
//             "No. of Records" := DocNoOfRecords;
//             Insert;
//         end;
//     end;

//     local procedure NS_NoOfRecords(TableID: Integer): Integer
//     begin
//         SetRange("Table ID", TableID);
//         if not FindFirst then
//             Init;
//         SetRange("Table ID");
//         exit("No. of Records");
//     end;

//     local procedure NS_SetSource(PostingDate: Date; DocType2: Text[100]; DocNo: Text[50]; SourceType2: Integer; SourceNo2: Code[20])
//     begin
//         if SourceType2 = 0 then begin
//             DocType := '';
//             SourceType := '';
//             SourceNo := '';
//             SourceName := '';
//         end else begin
//             DocType := DocType2;
//             SourceNo := SourceNo2;
//             SetRange("Document No.", DocNo);
//             SetRange("Posting Date", PostingDate);
//             DocNoFilter := GetFilter("Document No.");
//             PostingDateFilter := GetFilter("Posting Date");
//             case SourceType2 of
//                 1:
//                     begin
//                         SourceType := Cust.TableCaption;
//                         if not Cust.Get(SourceNo) then
//                             Cust.Init;
//                         SourceName := Cust.Name;
//                     end;
//                 2:
//                     begin
//                         SourceType := Vend.TableCaption;
//                         if not Vend.Get(SourceNo) then
//                             Vend.Init;
//                         SourceName := Vend.Name;
//                     end;
//                 4:
//                     begin
//                         SourceType := Bank.TableCaption;
//                         if not Bank.Get(SourceNo) then
//                             Bank.Init;
//                         SourceName := Bank.Name;
//                     end;
//             end;
//         end;
//         DocTypeEnable := SourceType2 <> 0;
//         SourceTypeEnable := SourceType2 <> 0;
//         SourceNoEnable := SourceType2 <> 0;
//         SourceNameEnable := SourceType2 <> 0;
//     end;

//     local procedure NS_ShowRecords()
//     var
//         IsHandled: Boolean;
//     begin
//         IsHandled := false;
//         NS_OnBeforeNavigateShowRecords("Table ID", DocNoFilter, PostingDateFilter, NS_ItemTrackingSearch, Rec, IsHandled);
//         if IsHandled then
//             exit;

//         if NS_ItemTrackingSearch then
//             ItemTrackingNavigateMgt.Show("Table ID")
//         else
//             case "Table ID" of
//                 DATABASE::"Incoming Document":
//                     PAGE.Run(PAGE::"Incoming Document", IncomingDocument);
//                 DATABASE::"Sales Header":
//                     NS_ShowSalesHeaderRecords;
//                 DATABASE::"Sales Invoice Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvHeader)
//                     else
//                         PAGE.Run(PAGE::"Posted Sales Invoices", SalesInvHeader);
//                 DATABASE::"Sales Cr.Memo Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader)
//                     else
//                         PAGE.Run(PAGE::"Posted Sales Credit Memos", SalesCrMemoHeader);
//                 DATABASE::"Return Receipt Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Return Receipt", ReturnRcptHeader)
//                     else
//                         PAGE.Run(0, ReturnRcptHeader);
//                 DATABASE::"Sales Shipment Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Sales Shipment", SalesShptHeader)
//                     else
//                         PAGE.Run(0, SalesShptHeader);
//                 DATABASE::"Issued Reminder Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Issued Reminder", IssuedReminderHeader)
//                     else
//                         PAGE.Run(0, IssuedReminderHeader);
//                 DATABASE::"Issued Fin. Charge Memo Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Issued Finance Charge Memo", IssuedFinChrgMemoHeader)
//                     else
//                         PAGE.Run(0, IssuedFinChrgMemoHeader);
//                 DATABASE::"Purch. Inv. Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader)
//                     else
//                         PAGE.Run(PAGE::"Posted Purchase Invoices", PurchInvHeader);
//                 DATABASE::"Purch. Cr. Memo Hdr.":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHeader)
//                     else
//                         PAGE.Run(PAGE::"Posted Purchase Credit Memos", PurchCrMemoHeader);
//                 DATABASE::"Return Shipment Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Return Shipment", ReturnShptHeader)
//                     else
//                         PAGE.Run(0, ReturnShptHeader);
//                 DATABASE::"Purch. Rcpt. Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
//                     else
//                         PAGE.Run(0, PurchRcptHeader);
//                 DATABASE::"Production Order":
//                     PAGE.Run(0, ProductionOrderHeader);
//                 DATABASE::"Posted Assembly Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Assembly Order", PostedAssemblyHeader)
//                     else
//                         PAGE.Run(0, PostedAssemblyHeader);
//                 DATABASE::"Transfer Shipment Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Transfer Shipment", TransShptHeader)
//                     else
//                         PAGE.Run(0, TransShptHeader);
//                 DATABASE::"Transfer Receipt Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Transfer Receipt", TransRcptHeader)
//                     else
//                         PAGE.Run(0, TransRcptHeader);
//                 DATABASE::"Posted Whse. Shipment Line":
//                     PAGE.Run(0, PostedWhseShptLine);
//                 DATABASE::"Posted Whse. Receipt Line":
//                     PAGE.Run(0, PostedWhseRcptLine);
//                 DATABASE::"G/L Entry":
//                     PAGE.Run(0, GLEntry);
//                 DATABASE::"VAT Entry":
//                     PAGE.Run(0, VATEntry);
//                 DATABASE::"Detailed Cust. Ledg. Entry":
//                     PAGE.Run(0, DtldCustLedgEntry);
//                 DATABASE::"Cust. Ledger Entry":
//                     PAGE.Run(0, CustLedgEntry);
//                 DATABASE::"Reminder/Fin. Charge Entry":
//                     PAGE.Run(0, ReminderEntry);
//                 DATABASE::"Vendor Ledger Entry":
//                     PAGE.Run(0, VendLedgEntry);
//                 DATABASE::"Detailed Vendor Ledg. Entry":
//                     PAGE.Run(0, DtldVendLedgEntry);
//                 DATABASE::"Employee Ledger Entry":
//                     NS_ShowEmployeeLedgerEntries;
//                 DATABASE::"Detailed Employee Ledger Entry":
//                     NS_ShowDetailedEmployeeLedgerEntries;
//                 DATABASE::"Item Ledger Entry":
//                     PAGE.Run(0, ItemLedgEntry);
//                 DATABASE::"Value Entry":
//                     PAGE.Run(0, ValueEntry);
//                 DATABASE::"Phys. Inventory Ledger Entry":
//                     PAGE.Run(0, PhysInvtLedgEntry);
//                 DATABASE::"Res. Ledger Entry":
//                     PAGE.Run(0, ResLedgEntry);
//                 DATABASE::"Job Ledger Entry":
//                     PAGE.Run(0, JobLedgEntry);
//                 DATABASE::"Job WIP Entry":
//                     PAGE.Run(0, JobWIPEntry);
//                 DATABASE::"Job WIP G/L Entry":
//                     PAGE.Run(0, JobWIPGLEntry);
//                 DATABASE::"Bank Account Ledger Entry":
//                     PAGE.Run(0, BankAccLedgEntry);
//                 DATABASE::"Check Ledger Entry":
//                     PAGE.Run(0, CheckLedgEntry);
//                 DATABASE::"FA Ledger Entry":
//                     PAGE.Run(0, FALedgEntry);
//                 DATABASE::"Maintenance Ledger Entry":
//                     PAGE.Run(0, MaintenanceLedgEntry);
//                 DATABASE::"Ins. Coverage Ledger Entry":
//                     PAGE.Run(0, InsuranceCovLedgEntry);
//                 DATABASE::"Capacity Ledger Entry":
//                     PAGE.Run(0, CapacityLedgEntry);
//                 DATABASE::"Warehouse Entry":
//                     PAGE.Run(0, WhseEntry);
//                 DATABASE::"Service Header":
//                     NS_ShowServiceHeaderRecords;
//                 DATABASE::"Service Invoice Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Service Invoice", ServInvHeader)
//                     else
//                         PAGE.Run(0, ServInvHeader);
//                 DATABASE::"Service Cr.Memo Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Service Credit Memo", ServCrMemoHeader)
//                     else
//                         PAGE.Run(0, ServCrMemoHeader);
//                 DATABASE::"Service Shipment Header":
//                     if "No. of Records" = 1 then
//                         PAGE.Run(PAGE::"Posted Service Shipment", ServShptHeader)
//                     else
//                         PAGE.Run(0, ServShptHeader);
//                 DATABASE::"Service Ledger Entry":
//                     PAGE.Run(0, ServLedgerEntry);
//                 DATABASE::"Warranty Ledger Entry":
//                     PAGE.Run(0, WarrantyLedgerEntry);
//                 DATABASE::"Cost Entry":
//                     PAGE.Run(0, CostEntry);

//                 //PPDA.1.0 Start
//                 // DATABASE::"Posted Deposit Header":
//                 //     PAGE.Run(0, PostedDepositHeader);
//                 // DATABASE::"Posted Deposit Line":
//                 //     PAGE.Run(0, PostedDepositLine);
//                 //PPDA.1.0 End
//                 //ProjectPro - start
//                 DATABASE::"NS_Subcontract Ledger Entry":
//                     PAGE.Run(0, PP_SubcontractLedgEntry);
//             //ProjectPro - end
//             end;

//         NS_OnAfterNavigateShowRecords("Table ID", DocNoFilter, PostingDateFilter, NS_ItemTrackingSearch, Rec);
//     end;

//     local procedure NS_ShowSalesHeaderRecords()
//     begin
//         TestField("Table ID", DATABASE::"Sales Header");

//         case "Document Type" of
//             "Document Type"::Order:
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Sales Order", SOSalesHeader)
//                 else
//                     PAGE.Run(0, SOSalesHeader);
//             "Document Type"::Invoice:
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Sales Invoice", SISalesHeader)
//                 else
//                     PAGE.Run(0, SISalesHeader);
//             "Document Type"::"Return Order":
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Sales Return Order", SROSalesHeader)
//                 else
//                     PAGE.Run(0, SROSalesHeader);
//             "Document Type"::"Credit Memo":
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Sales Credit Memo", SCMSalesHeader)
//                 else
//                     PAGE.Run(0, SCMSalesHeader);
//         end;
//     end;

//     local procedure NS_ShowServiceHeaderRecords()
//     begin
//         TestField("Table ID", DATABASE::"Service Header");

//         case "Document Type" of
//             "Document Type"::Order:
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Service Order", SOServHeader)
//                 else
//                     PAGE.Run(0, SOServHeader);
//             "Document Type"::Invoice:
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Service Invoice", SIServHeader)
//                 else
//                     PAGE.Run(0, SIServHeader);
//             "Document Type"::"Credit Memo":
//                 if "No. of Records" = 1 then
//                     PAGE.Run(PAGE::"Service Credit Memo", SCMServHeader)
//                 else
//                     PAGE.Run(0, SCMServHeader);
//         end;
//     end;

//     local procedure NS_ShowEmployeeLedgerEntries()
//     begin
//         PAGE.Run(PAGE::"Employee Ledger Entries", EmplLedgEntry);
//     end;

//     local procedure NS_ShowDetailedEmployeeLedgerEntries()
//     begin
//         PAGE.Run(PAGE::"Detailed Empl. Ledger Entries", DtldEmplLedgEntry);
//     end;

//     local procedure NS_SetPostingDate(PostingDate: Text)
//     begin
//         TextManagement.MakeDateFilter(PostingDate);
//         SetFilter("Posting Date", PostingDate);
//         PostingDateFilter := GetFilter("Posting Date");
//     end;

//     local procedure NS_SetDocNo(DocNo: Text)
//     begin
//         SetFilter("Document No.", DocNo);
//         DocNoFilter := GetFilter("Document No.");
//         //ProjectPro - start
//         if (not PP_SalesSetup."NS_Sales Retention Inactive") or (not PP_PurchSetup."NS_Purchase Retention Inactive") then
//             PP_LedgerNoFilter := GetFilter("NS_Ledger No.");
//         //ProjectPro - end
//         PostingDateFilter := GetFilter("Posting Date");
//     end;

//     [Scope('Cloud')]
//     procedure NS_SetExternal()
//     begin
//         NavigateDeposit := true;
//     end;

//     local procedure NS_ClearSourceInfo()
//     begin
//         if DocExists then begin
//             DocExists := false;
//             DeleteAll;
//             ShowEnable := false;
//             NS_SetSource(0D, '', '', 0, '');
//             CurrPage.Update(false);
//         end;
//     end;

//     local procedure NS_MakeExtFilter(var DateFilter: Text; AddDate: Date; var DocNoFilter: Text; AddDocNo: Code[20])
//     begin
//         if DateFilter = '' then
//             DateFilter := Format(AddDate)
//         else
//             if StrPos(DateFilter, Format(AddDate)) = 0 then
//                 if MaxStrLen(DateFilter) >= StrLen(DateFilter + '|' + Format(AddDate)) then
//                     DateFilter := DateFilter + '|' + Format(AddDate)
//                 else
//                     NS_TooLongFilter;

//         if DocNoFilter = '' then
//             DocNoFilter := AddDocNo
//         else
//             if StrPos(DocNoFilter, AddDocNo) = 0 then
//                 if MaxStrLen(DocNoFilter) >= StrLen(DocNoFilter + '|' + AddDocNo) then
//                     DocNoFilter := DocNoFilter + '|' + AddDocNo
//                 else
//                     NS_TooLongFilter;
//     end;

//     local procedure NS_FindPush()
//     begin
//         if NavigateDeposit then
//             NS_FindDepositRecords
//         else
//             if (DocNoFilter = '') and (PostingDateFilter = '') and
//                (not NS_ItemTrackingSearch) and
//                ((ContactType <> 0) or (ContactNo <> '') or (ExtDocNo <> ''))
//             then
//                 NS_FindExtRecords
//             else
//                 if NS_ItemTrackingSearch and
//                    (DocNoFilter = '') and (PostingDateFilter = '') and
//                    (ContactType = 0) and (ContactNo = '') and (ExtDocNo = '')
//                 then
//                     NS_FindTrackingRecords
//                 else
//                     NS_FindRecords;
//     end;

//     local procedure NS_TooLongFilter()
//     begin
//         if ContactNo = '' then
//             Error(Text015);

//         Error(Text016);
//     end;

//     local procedure NS_FindUnpostedSalesDocs(DocType: enum "Sales Document Type"; DocTableName: Text[100]; var SalesHeader: Record "Sales Header")
//     begin
//         SalesHeader."SecurityFiltering"(SECURITYFILTER::Filtered);
//         if SalesHeader.ReadPermission then begin
//             SalesHeader.Reset;
//             SalesHeader.SetCurrentKey("Sell-to Customer No.", "External Document No.");
//             SalesHeader.SetFilter("Sell-to Customer No.", ContactNo);
//             SalesHeader.SetFilter("External Document No.", ExtDocNo);
//             SalesHeader.SetRange("Document Type", DocType);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Sales Header", DocType, DocTableName, SalesHeader.Count);
//         end;
//     end;

//     local procedure NS_FindUnpostedServDocs(DocType: enum "Service Document Type"; DocTableName: Text[100]; var ServHeader: Record "Service Header")
//     begin
//         ServHeader."SecurityFiltering"(SECURITYFILTER::Filtered);
//         if ServHeader.ReadPermission then
//             if ExtDocNo = '' then begin
//                 ServHeader.Reset;
//                 ServHeader.SetCurrentKey("Customer No.");
//                 ServHeader.SetFilter("Customer No.", ContactNo);
//                 ServHeader.SetRange("Document Type", DocType);
//                 NS_InsertIntoDocEntry(Rec, DATABASE::"Service Header", DocType, DocTableName, ServHeader.Count);
//             end;
//     end;

//     local procedure NS_FindTrackingRecords()
//     var
//         DocNoOfRecords: Integer;
//     begin
//         Window.Open(Text002);
//         DeleteAll;
//         "Entry No." := 0;

//         Clear(ItemTrackingNavigateMgt);
//         ItemTrackingNavigateMgt.FindTrackingRecords(SerialNoFilter, LotNoFilter, '', '');

//         ItemTrackingNavigateMgt.Collect(TempRecordBuffer);
//         TempRecordBuffer.SetCurrentKey("Table No.", "Record Identifier");
//         if TempRecordBuffer.Find('-') then
//             repeat
//                 TempRecordBuffer.SetRange("Table No.", TempRecordBuffer."Table No.");

//                 DocNoOfRecords := 0;
//                 if TempRecordBuffer.Find('-') then
//                     repeat
//                         TempRecordBuffer.SetRange("Record Identifier", TempRecordBuffer."Record Identifier");
//                         TempRecordBuffer.Find('+');
//                         TempRecordBuffer.SetRange("Record Identifier");
//                         DocNoOfRecords += 1;
//                     until TempRecordBuffer.Next = 0;

//                 NS_InsertIntoDocEntry(Rec, TempRecordBuffer."Table No.", 0, TempRecordBuffer."Table Name", DocNoOfRecords);

//                 TempRecordBuffer.SetRange("Table No.");
//             until TempRecordBuffer.Next = 0;

//         NS_OnAfterNavigateFindTrackingRecords(Rec, SerialNoFilter, LotNoFilter);

//         DocExists := Find('-');

//         NS_UpdateFormAfterFindRecords;
//         Window.Close;
//     end;

//     local procedure NS_GetDocumentCount() DocCount: Integer
//     begin
//         DocCount :=
//           NS_NoOfRecords(DATABASE::"Sales Invoice Header") + NS_NoOfRecords(DATABASE::"Sales Cr.Memo Header") +
//           NS_NoOfRecords(DATABASE::"Sales Shipment Header") + NS_NoOfRecords(DATABASE::"Issued Reminder Header") +
//           NS_NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") + NS_NoOfRecords(DATABASE::"Purch. Inv. Header") +
//           NS_NoOfRecords(DATABASE::"Return Shipment Header") + NS_NoOfRecords(DATABASE::"Return Receipt Header") +
//           NS_NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") + NS_NoOfRecords(DATABASE::"Purch. Rcpt. Header") +
//           NS_NoOfRecords(DATABASE::"Service Invoice Header") + NS_NoOfRecords(DATABASE::"Service Cr.Memo Header") +
//           NS_NoOfRecords(DATABASE::"Service Shipment Header") +
//           NS_NoOfRecords(DATABASE::"Transfer Shipment Header") + NS_NoOfRecords(DATABASE::"Transfer Receipt Header");
//         //NS_NoOfRecords(DATABASE::"Posted Deposit Header") + NS_NoOfRecords(DATABASE::"Posted Deposit Header"); //PPDA.1.0 Commented

//         OnAfterGetDocumentCount(DocCount);
//     end;

//     [Scope('Cloud')]
//     procedure NS_SetTracking(SerialNo: Code[50]; LotNo: Code[50])
//     begin
//         NewSerialNo := SerialNo;
//         NewLotNo := LotNo;
//     end;

//     local procedure NS_ItemTrackingSearch(): Boolean
//     begin
//         exit((SerialNoFilter <> '') or (LotNoFilter <> ''));
//     end;

//     local procedure NS_ClearTrackingInfo()
//     begin
//         SerialNoFilter := '';
//         LotNoFilter := '';
//     end;

//     local procedure NS_ClearInfo()
//     begin
//         NS_SetDocNo('');
//         NS_SetPostingDate('');
//         ContactType := ContactType::" ";
//         ContactNo := '';
//         ExtDocNo := '';
//     end;

//     local procedure NS_FindDepositRecords()
//     begin
//         Window.Open(Text002);
//         DeleteAll;
//         "Entry No." := 0;
//         if GLEntry.ReadPermission then begin
//             GLEntry.Reset;
//             if not GLEntry.SetCurrentKey("External Document No.", "Posting Date") then
//                 Error(USText001);
//             GLEntry.SetFilter("External Document No.", ExtDocNo);
//             GLEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"G/L Entry", 0, GLEntry.TableCaption, GLEntry.Count);
//         end;
//         if CustLedgEntry.ReadPermission then begin
//             CustLedgEntry.Reset;
//             if not CustLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
//                 Error(USText001);
//             CustLedgEntry.SetFilter("External Document No.", ExtDocNo);
//             CustLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Cust. Ledger Entry", 0, CustLedgEntry.TableCaption, CustLedgEntry.Count);
//         end;
//         if VendLedgEntry.ReadPermission then begin
//             VendLedgEntry.Reset;
//             if not VendLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
//                 Error(USText001);
//             VendLedgEntry.SetFilter("External Document No.", ExtDocNo);
//             VendLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Vendor Ledger Entry", 0, VendLedgEntry.TableCaption, VendLedgEntry.Count);
//         end;
//         if BankAccLedgEntry.ReadPermission then begin
//             BankAccLedgEntry.Reset;
//             if not BankAccLedgEntry.SetCurrentKey("External Document No.", "Posting Date") then
//                 Error(USText001);
//             BankAccLedgEntry.SetFilter("External Document No.", ExtDocNo);
//             BankAccLedgEntry.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Bank Account Ledger Entry", 0, BankAccLedgEntry.TableCaption, BankAccLedgEntry.Count);
//         end;
//         if PostedDepositHeader.ReadPermission then begin
//             PostedDepositHeader.Reset;
//             PostedDepositHeader.SetFilter("No.", ExtDocNo);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Header", 0, PostedDepositHeader.TableCaption, PostedDepositHeader.Count);
//         end;
//         if PostedDepositLine.ReadPermission then begin
//             PostedDepositLine.Reset;
//             PostedDepositLine.SetCurrentKey("Deposit No.");
//             PostedDepositLine.SetFilter("Deposit No.", ExtDocNo);
//             PostedDepositLine.SetFilter("Posting Date", PostingDateFilter);
//             NS_InsertIntoDocEntry(Rec, DATABASE::"Posted Deposit Line", 0, PostedDepositLine.TableCaption, PostedDepositLine.Count);
//         end;
//         DocExists := FindFirst;

//         NS_SetSource(0D, '', '', 0, '');
//         if DocExists then begin
//             if NS_NoOfRecords(DATABASE::"Posted Deposit Header") = 1 then begin
//                 PostedDepositHeader.FindFirst;
//                 NS_SetSource(
//                   PostedDepositHeader."Posting Date", Format("Table Name"), PostedDepositHeader."No.",
//                   4, PostedDepositHeader."Bank Account No.");
//             end else begin
//                 if ExtDocNo <> '' then
//                     if PostingDateFilter = '' then
//                         Message(Text011)
//                     else
//                         Message(Text012);
//             end;
//         end else
//             if PostingDateFilter = '' then
//                 Message(Text013)
//             else
//                 Message(Text014);

//         NS_UpdateFormAfterFindRecords;
//         Window.Close;
//     end;

//     local procedure NS_DocNoFilterOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_PostingDateFilterOnAfterValida()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_ExtDocNoOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_ContactTypeOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_ContactNoOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_SerialNoFilterOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     local procedure NS_LotNoFilterOnAfterValidate()
//     begin
//         NS_ClearSourceInfo;
//     end;

//     [Scope('Cloud')]
//     procedure NS_FindRecordsOnOpen()
//     begin
//         //ProjectPro - start
//         //IF (NewDocNo = '') AND (NewPostingDate = 0D) AND (NewSerialNo = '') AND (NewLotNo = '') THEN BEGIN
//         if (PP_NewLedgerNo = '') and (NewDocNo = '') and (NewPostingDate = 0D) and (NewSerialNo = '') and (NewLotNo = '') then begin
//             //ProjectPro - end
//             DeleteAll;
//             ShowEnable := false;
//             PrintEnable := false;
//             NS_SetSource(0D, '', '', 0, '');
//         end else
//             if (NewSerialNo <> '') or (NewLotNo <> '') then begin
//                 NS_SetSource(0D, '', '', 0, '');
//                 SetRange("Serial No. Filter", NewSerialNo);
//                 SetRange("Lot No. Filter", NewLotNo);
//                 SerialNoFilter := GetFilter("Serial No. Filter");
//                 LotNoFilter := GetFilter("Lot No. Filter");
//                 NS_ClearInfo;
//                 NS_FindTrackingRecords;
//             end else begin
//                 //ProjectPro - start
//                 if PP_NewLedgerNo > '' then
//                     SetRange("NS_Ledger No.", PP_NewLedgerNo);
//                 //ProjectPro - end
//                 SetRange("Document No.", NewDocNo);
//                 SetRange("Posting Date", NewPostingDate);
//                 PostingDateFilter := GetFilter("Posting Date");
//                 ContactType := ContactType::" ";
//                 ContactNo := '';
//                 ExtDocNo := '';
//                 NS_ClearTrackingInfo;
//                 DocNoFilter := '';
//                 if NavigateDeposit then begin
//                     ExtDocNo := GetFilter("Document No.");
//                     NS_FindDepositRecords;
//                 end else begin
//                     DocNoFilter := GetFilter("Document No.");
//                     NS_FindRecords;
//                 end;
//             end;
//     end;

//     [Scope('Cloud')]
//     procedure NS_UpdateNavigateForm(UpdateFormFrom: Boolean)
//     begin
//         UpdateForm := UpdateFormFrom;
//     end;

//     [Scope('Cloud')]
//     procedure NS_ReturnDocumentEntry(var TempDocumentEntry: Record "Document Entry" temporary)
//     begin
//         SetRange("Table ID");  // Clear filter.
//         FindSet;
//         repeat
//             TempDocumentEntry.Init;
//             TempDocumentEntry := Rec;
//             TempDocumentEntry.Insert;
//         until Next = 0;
//     end;

//     local procedure NS_UpdateFindByGroupsVisibility()
//     begin
//         DocumentVisible := false;
//         BusinessContactVisible := false;
//         ItemReferenceVisible := false;

//         case FindBasedOn of
//             FindBasedOn::Document:
//                 DocumentVisible := true;
//             FindBasedOn::"Business Contact":
//                 BusinessContactVisible := true;
//             FindBasedOn::"Item Reference":
//                 ItemReferenceVisible := true;
//         end;

//         CurrPage.Update;
//     end;

//     local procedure NS_FilterSelectionChanged()
//     begin
//         FilterSelectionChangedTxtVisible := true;
//     end;

//     local procedure NS_GetCaptionText(): Text
//     begin
//         if "Table Name" <> '' then
//             exit(StrSubstNo(PageCaptionTxt, "Table Name"));

//         exit('');
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGetDocumentCount(var DocCount: Integer)
//     begin
//     end;

//     [IntegrationEvent(false, TRUE)]
//     local procedure NS_OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure NS_OnAfterNavigateFindTrackingRecords(var DocumentEntry: Record "Document Entry"; SerialNoFilter: Text; LotNoFilter: Text)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure NS_OnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure NS_OnBeforeNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry" temporary; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(TRUE, TRUE)]
//     local procedure NS_OnBeforeUpdateFormAfterFindRecords()
//     begin
//     end;

//     procedure NS_SetDocLedger(LedgerNo: Code[20]; PostingDate: Date; DocNo: Code[20])
//     begin
//         //ProjectPro - start
//         PP_NewLedgerNo := LedgerNo;
//         NewDocNo := DocNo;
//         NewPostingDate := PostingDate;
//         //ProjectPro - end
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeSetDocumentEntries(Rec: Record "Document Entry"; DocNoFilter: text; PostingDateFilter: text; NavigateDeposit: Boolean)
//     begin
//     end;

//     [IntegrationEvent(true, false)]
//     local procedure OnBeforeSetSourceForDeposit()
//     begin
//     end;
// }

//PPDA.1.0 Commented End