
/// <summary>
///PE-217.DK.1.0 27Dec2023 |Create New Controladdin for Signature Pad
/// </summary>
controladdin "NS_SignaturePad"
{
    MaximumHeight = 720;
    MinimumHeight = 400;
    MaximumWidth = 1920;
    MinimumWidth = 400;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    RequestedHeight = 400;
    RequestedWidth = 1280;
    Scripts = 'JsScript/sign.js', 'JsScript\signature_pad.min.js';
    StyleSheets = 'StyleSheet/style.css';
    event Ready()
    procedure InitializeSignaturePad()
     procedure SignetureImg(Image: Text)
    event Sign(Signature: Text)

}
//PE-217.DK.1.0 27Dec2023 End


