//PE-115.DK.1.0 5july2023 START
var addin = document.getElementById('controlAddIn');
addin.clientWidth=400;
addin.clientHeight=400;
//addin.innerHTML='<button onclick="loadCanvas();" id="btnPieChart" style="display:none">show</button><br><div id="wrapper"><center><canvas style="margin-right: -190px;" id="myChart" width="400" height="400"></canvas></center></div>';
//addin.innerHTML='<div id="wrapper"><center><canvas style="margin-right: -190px;" id="myChart" width="400" height="400"></canvas></center></div>';
//addin.innerHTML='<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
console.log(addin); 
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('IAddInReady',[]);
//PE-115.DK.1.0 5july2023 END

