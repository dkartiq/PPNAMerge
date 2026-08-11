/// <summary>
///PE-217.DK.1.0 27Dec2023 |Create New Controladdin for Weather
/// </summary>
controladdin NS_WeatherContrilAddIn
{
    RequestedHeight = 300;
    MinimumHeight = 300;
    MaximumHeight = 300;
    RequestedWidth = 700;
    MinimumWidth = 700;
    MaximumWidth = 700;
    VerticalStretch = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    VerticalShrink = true;
    Scripts = 'JsScript\NS_ProjectProWeather.js', 'JsScript\ProjectProWeatherjquery.min.js';
    // StyleSheets = 'StyleSheet\NS_StyleSheet.css';
    //StartupScript = 'JsScript\NS_Start.js';
    //Images = 'Image\WeatherImage.jpg';
    Procedure NS_GetJobAddress(Job: JsonObject);
}