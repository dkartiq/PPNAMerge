//PE-241.DK.1.0 14March2024 | Create New Controladdin NS_UserTaskGraphics 
/// <summary>
/// ControlAddIn NS_UserTaskGraphis.
/// </summary>
controladdin NS_UserTaskGraphics
{
    RequestedHeight = 1200;
    RequestedWidth = 1200;
    // VerticalStretch = true;
    // VerticalShrink = true;
    // HorizontalStretch = true;
    // HorizontalShrink = true;
    // RequestedHeight = 400;
    // RequestedWidth = 1280;
    //Scripts = 'NSProjectProcanvasjs.min.js', 'NSProjectProJobScript.js';
    Scripts = 'JsScript\material-dashboard.min.js', 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js', 'JsScript\NS_chartjs-plugin.js', 'JsScript\NS_UserTask.js';
    //Scripts = 'https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous', 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.min.js', 'JsScript\NS_chartjs-plugin.js', 'https://cdn.jsdelivr.net/npm/chart.js', 'JsScript\NS_UserTask.js';
    StyleSheets = 'StyleSheet\material-dashboard.min.css', 'StyleSheet\material-dashboard.css';
    StartupScript = 'NSProjectProStartup.js';
    event IAddInReady();
    procedure NS_InitializeUserTaskGraphis(HyperlinkText: JsonArray; NS_OverdueDate: Code[20]; NS_Next7DayDate: Code[20]; NS_GreatherThanDate: Code[20]; NS_OverdueDate2: Code[20]; NS_Next7DayDate2: Code[20]; NS_GreatherThanDate2: Code[20]; NS_OverdueDate3: Code[20]; NS_Next7DayDate3: Code[20]; NS_GreatherThanDate3: Code[20]; NS_OverdueDate4: Code[20]; NS_Next7DayDate4: Code[20]; NS_GreatherThanDate4: Code[20]; NS_OverdueDate5: Code[20]; NS_Next7DayDate5: Code[20]; NS_GreatherThanDate5: Code[20]; NS_OverdueDate6: Code[20]; NS_Next7DayDate6: Code[20]; NS_GreatherThanDate6: Code[20]; NS_OverdueDate7: Code[20]; NS_Next7DayDate7: Code[20]; NS_GreatherThanDate7: Code[20]; NS_Label: JsonArray)
    //Procedure Demo(NS_Label: Code[20]; NS_Value: Integer);
    procedure NS_InitializeUserTaskLabel(NS_UserTaskCat: code[20]; NS_UserTaskCat2: code[20]; NS_UserTaskCat3: code[20]; NS_UserTaskCat4: Code[20]; NS_UserTaskCat5: Code[20]; NS_UserTaskCat6: code[20]; NS_UserTaskCat7: code[20])
    procedure NS_HyperLink(HyperlinkTextSEQ1: Text[500];
        HyperlinkTextSEQ2: Text[500];
        HyperlinkTextSEQ3: Text[500];
        HyperlinkTextSEQ4: Text[500];
        HyperlinkTextSEQ5: Text[500];
        HyperlinkTextSEQ6: Text[500];
        HyperlinkTextSEQ7: Text[500];
        HyperlinkTextSEQ8: Text[500];
        HyperlinkTextSEQ9: Text[500];
        HyperlinkTextSEQ10: Text[500];
        HyperlinkTextSEQ11: Text[500];
        HyperlinkTextSEQ12: Text[500];
        HyperlinkTextSEQ13: Text[500];
        HyperlinkTextSEQ14: Text[500];
        HyperlinkTextSEQ15: Text[500];
        HyperlinkTextSEQ16: Text[500];
        HyperlinkTextSEQ17: Text[500];
        HyperlinkTextSEQ18: Text[500];
        HyperlinkTextSEQ19: Text[500];
        HyperlinkTextSEQ20: Text[500];
        HyperlinkTextSEQ21: Text[500])
}