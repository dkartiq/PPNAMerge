pageextension 14021478 NS_CopyJobExtension extends "Copy Job"
{
    //PRJ-361.AS.2.0 11SEPT2020 Creted Copy Job Page extension to rearrange copy job functionality
    Caption = 'Copy Job Ext.';
    layout
    {

    }
    var
        JobSetup_Global: Record "Jobs Setup";


    trigger OnOpenPage();

    begin
        JobSetup_Global.Get;
        JobSetup_Global."NS_Show Default task in Copy Job" := true;
        JobSetup_Global.Modify();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        JobSetup_Global."NS_Show Default task in Copy Job" := false;
        JobSetup_Global.Modify();
    end;
}