//PE-241.DK.1.0 14March2024 |Create New Js File
var et;
var canvasdata1;
var UserTaskLabel1, UserTaskLabel2, UserTaskLabel3, UserTaskLabel4, UserTaskLabel5, UserTaskLabel6, UserTaskLabel7;
var HyperlinkSEQ1,HyperlinkSEQ2,HyperlinkSEQ3,HyperlinkSEQ4,HyperlinkSEQ5,HyperlinkSEQ6,HyperlinkSEQ7,HyperlinkSEQ8,HyperlinkSEQ9,HyperlinkSEQ10,HyperlinkSEQ11,HyperlinkSEQ12,HyperlinkSEQ13,HyperlinkSEQ14,HyperlinkSEQ15,HyperlinkSEQ16,HyperlinkSEQ17,HyperlinkSEQ18,HyperlinkSEQ19,HyperlinkSEQ20,HyperlinkSEQ21;
var NS_UserTaskCat1
let now = new Date();
let hours = now.getHours();
let minutes = now.getMinutes();
let seconds = now.getSeconds();

console.log(`Current Time: ${hours}:${minutes}:${seconds}`);
function NS_InitializeUserTaskLabel( NS_UserTaskCat, NS_UserTaskCat2, NS_UserTaskCat3, NS_UserTaskCat4, NS_UserTaskCat5, NS_UserTaskCat6, NS_UserTaskCat7)
{
     UserTaskLabel1=NS_UserTaskCat;
     UserTaskLabel2=NS_UserTaskCat2;
     UserTaskLabel3=NS_UserTaskCat3;
     UserTaskLabel4=NS_UserTaskCat4;
     UserTaskLabel5=NS_UserTaskCat5;
     UserTaskLabel6=NS_UserTaskCat6;
     UserTaskLabel7=NS_UserTaskCat7;
}

function NS_InitializeUserTaskGraphis(HyperlinkText,NS_OverdueDate,NS_Next7DayDate,NS_GreatherThanDate,NS_OverdueDate2, NS_Next7DayDate2, NS_GreatherThanDate2,NS_OverdueDate3, NS_Next7DayDate3, NS_GreatherThanDate3,NS_OverdueDate4, NS_Next7DayDate4, NS_GreatherThanDate4,NS_OverdueDate5, NS_Next7DayDate5, NS_GreatherThanDate5,NS_OverdueDate6, NS_Next7DayDate6, NS_GreatherThanDate6,NS_OverdueDate7, NS_Next7DayDate7, NS_GreatherThanDate7,NS_OverDue){
  document.getElementById('controlAddIn').innerHTML='<main class="main-content position-relative max-height-vh-100 h-100 border-radius-lg "><div class="row mt-4"><div class="col-lg-12 col-md-6 mt-4 mb-4"><div class="card z-index-2 "> <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent"><div class="bg-gradient-success shadow-success border-radius-lg py-3 pe-1"><div class="chart" ><canvas id="createCurrYearHccGapChartNew" style="display: block;height: 300px;width: 751px;"></canvas></div></div></div></div></div></main>';
var chartDataNew = {
  type: 'horizontalBar',
  data: {
     labels: [UserTaskLabel1, UserTaskLabel2, UserTaskLabel3, UserTaskLabel4, UserTaskLabel5, UserTaskLabel6, UserTaskLabel7],
     datasets: [{
      label: NS_OverDue[0],
             backgroundColor: '#fc1303',
        data: [NS_OverdueDate,NS_OverdueDate2,NS_OverdueDate3,NS_OverdueDate4,NS_OverdueDate5,NS_OverdueDate6,NS_OverdueDate7],
     }, {
      label: NS_OverDue[1],
      backgroundColor: '#fcf403',
        data: [NS_Next7DayDate,NS_Next7DayDate2,NS_Next7DayDate3,NS_Next7DayDate4,NS_Next7DayDate5,NS_Next7DayDate6,NS_Next7DayDate7]

     }, {
      label: NS_OverDue[2],
       backgroundColor: '#2abf22',
       data: [NS_GreatherThanDate,NS_GreatherThanDate2,NS_GreatherThanDate3,NS_GreatherThanDate4,NS_GreatherThanDate5,NS_GreatherThanDate6,NS_GreatherThanDate7]
     }]
  },
  options: {
     responsive: true,
     backgroundColor:'#fff',
     plugins: {
      datalabels: {
          color: 'black',
         // display: 'auto',
          // formatter: function(value, context) {
          //     return `$${value.replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`;
          // }
      },
      legend: {
          position: 'top' 
      }
  },
    //  legend: {
    //     display: false
    //  },
     scales: {
      display:false,
        yAxes: [{
           stacked: true,
           gridLines: {
            display: false
          }   
        }],
        xAxes: [{
           stacked: true,
           ticks: {
            display: false
          },
           gridLines: {
            display: false
          }
        }]
     },
    animation: {
      onComplete: function () {
          var chartInstance = this.chart;
          var ctx = chartInstance.ctx;
          ctx.textAlign = 'Left';
          ctx.textBaseline = 'middle';
          this.data.datasets.forEach(function (dataset, i) {
            debugger
              var meta = chartInstance.controller.getDatasetMeta(i);
              if (!meta.hidden) {
                meta.data.forEach(function(element, index) {
                    // Draw the text in black, with the specified font
                    ctx.fillStyle = 'rgb(0, 0, 0)';
                    var fontSize = 16;
                    var fontStyle = 'normal';
                    var fontFamily = 'Helvetica Neue';
                    ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);
                    // Just naively convert to string for now
                    var dataString = dataset.data[index].toString();
                   
                    // Make sure alignment settings are correct
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    var padding = 1;
                    var position = element.tooltipPosition();
                    if (dataString=='0'){
                      ctx.fillText('', position.x - 80, position.y + 5 - (fontSize / 4));
                    } else
                    {
                      ctx.fillText(dataString, position.x - 80, position.y + 5 - (fontSize / 4));
                    }
                    
                });
            }
          });
     }
  }
  }
  
}

var canvas = document.getElementById('createCurrYearHccGapChartNew');
var myChart = new Chart(canvas, chartDataNew);

canvas.onclick = function(evt) {
canvasdata1=myChart.getElementAtEvent(evt)[0];

et=evt;
//alert(evt);
if(canvasdata1._datasetIndex==0 && canvasdata1._index==0){

  window.open(HyperlinkSEQ1)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==0){
  window.open(HyperlinkSEQ2)

}else if(canvasdata1._datasetIndex==2 && canvasdata1._index==0){
  window.open(HyperlinkSEQ3)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==1){
  window.open(HyperlinkSEQ4)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==1){
  window.open(HyperlinkSEQ5)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==1){
  window.open(HyperlinkSEQ6)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==2){
  window.open(HyperlinkSEQ7)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==2){
  window.open(HyperlinkSEQ8)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==2){
  window.open(HyperlinkSEQ9)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==3){
  window.open(HyperlinkSEQ10)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==3){
  window.open(HyperlinkSEQ11)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==3){
  window.open(HyperlinkSEQ12)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==4){
  window.open(HyperlinkSEQ13)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==4){
  window.open(HyperlinkSEQ14)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==4){
  window.open(HyperlinkSEQ15)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==5){
  window.open(HyperlinkSEQ16)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==5){
  window.open(HyperlinkSEQ17)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==5){
  window.open(HyperlinkSEQ18)
}
else if(canvasdata1._datasetIndex==0 && canvasdata1._index==6){
  window.open(HyperlinkSEQ19)
}
else if(canvasdata1._datasetIndex==1 && canvasdata1._index==6){
  window.open(HyperlinkSEQ20)
}
else if(canvasdata1._datasetIndex==2 && canvasdata1._index==6){
  window.open(HyperlinkSEQ21)
}
else{

  window.open("https://youtube.com")
}
};

}
function NS_HyperLink(HyperlinkTextSEQ1,HyperlinkTextSEQ2,HyperlinkTextSEQ3,HyperlinkTextSEQ4,HyperlinkTextSEQ5,HyperlinkTextSEQ6,HyperlinkTextSEQ7,HyperlinkTextSEQ8,HyperlinkTextSEQ9,HyperlinkTextSEQ10,HyperlinkTextSEQ11,HyperlinkTextSEQ12,HyperlinkTextSEQ13,HyperlinkTextSEQ14,HyperlinkTextSEQ15,HyperlinkTextSEQ16,HyperlinkTextSEQ17,HyperlinkTextSEQ18,HyperlinkTextSEQ19,HyperlinkTextSEQ20,
  HyperlinkTextSEQ21)
    {
      HyperlinkSEQ1=HyperlinkTextSEQ1,
      HyperlinkSEQ2=HyperlinkTextSEQ2,
      HyperlinkSEQ3=HyperlinkTextSEQ3,
      HyperlinkSEQ4=HyperlinkTextSEQ4,
      HyperlinkSEQ5=HyperlinkTextSEQ5,
      HyperlinkSEQ6=HyperlinkTextSEQ6,
      HyperlinkSEQ7=HyperlinkTextSEQ7,
      HyperlinkSEQ8=HyperlinkTextSEQ8,
      HyperlinkSEQ9=HyperlinkTextSEQ9,
      HyperlinkSEQ10=HyperlinkTextSEQ10,
      HyperlinkSEQ11=HyperlinkTextSEQ11,
      HyperlinkSEQ12=HyperlinkTextSEQ12,
      HyperlinkSEQ13=HyperlinkTextSEQ13,
      HyperlinkSEQ14=HyperlinkTextSEQ14,
      HyperlinkSEQ15=HyperlinkTextSEQ15,
      HyperlinkSEQ16=HyperlinkTextSEQ16,
      HyperlinkSEQ17=HyperlinkTextSEQ17,
      HyperlinkSEQ18=HyperlinkTextSEQ18,
      HyperlinkSEQ19=HyperlinkTextSEQ19,
      HyperlinkSEQ20=HyperlinkTextSEQ20,
      HyperlinkSEQ21=HyperlinkTextSEQ21
    }
