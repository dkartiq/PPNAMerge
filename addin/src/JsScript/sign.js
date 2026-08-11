 //PE-217.DK.1.0 27Dec2023 Create New JS file Using Signature
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("Ready", "");
function InitializeSignaturePad() {
  let canvas = document.createElement("canvas");
  canvas.id = "signbox";
  canvas.width = 400;
  canvas.height = 200;

  let submitButton = document.createElement("button");
  submitButton.id = "signDocument";
  submitButton.innerHTML = "Sign document";
  let signatureLocation = document.getElementById("controlAddIn");

  signatureLocation.appendChild(canvas);
  signatureLocation.appendChild(submitButton);

  var signaturePad = new SignaturePad(canvas, {
    backgroundColor: "rgb(255, 255, 255)",
   
  });
  submitButton.addEventListener("click", function (event) {
    if (signaturePad.isEmpty()) {
      alert("Please enter signature...");
    } else {
      var base64String = signaturePad.toDataURL();
      Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("Sign",[base64String])
      signimg(base64String);
      signaturePad.clear();
     
    }
  });
}

function signimg(base64String)
{
  
  document.getElementById('controlAddIn').innerHTML='<div><img src="'+base64String+'" alt=" " /></div>';

}
function SignetureImg(SigImgText)
{
  document.getElementById('controlAddIn').innerHTML='<div><img src="'+SigImgText+'" alt=" " /></div>'; 
}



//TY