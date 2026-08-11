   //PE-115.DK.1.0 5july2023 START
   // This Method is showing Job wise Column chart Start
   function NSbar(NS_JobNo,NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText)
   {
    document.getElementById('controlAddIn').innerHTML='';
    // PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center><div>Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
    document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
    // '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  // Commented
    // PE-115.HS.1.0 23Oct2023 End
    const xValues = [NSBudgetedCostText, NSUsagecostText,NSBudgetedPriceText,NSInvoicePriceText];
    const yValues = [NSBudgetedCost, NSUsagecost,NSBudgetedPrice , NSInvoicePrice];
    const barColors = ["#3e7bac", "#943b33","#8ac7df","#dd5837"];
    new Chart("myChart", {
    type: "bar",
  data: {
    yValueFormatString: "#,###.00\"%\"",
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
    },
    //PRJCTPR-350.DK.1.0 Start
    scales: {
      yAxes: [{
          ticks: {
              callback: function(value) {
                  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      }]
  },
  tooltips: 
{
    callbacks: 
    {
        label: function(tooltipItem, data) 
        {
           const title = data.labels[tooltipItem.index];
           const dataset = data.datasets[tooltipItem.datasetIndex];
           const value = dataset.data[tooltipItem.index]; 
           return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
        }
    },
}
  //PRJCTPR-350.DK.1.0 End
  }
});
 }
 // This Method is showing Job wise Column chart End

 // This Method is showing Job cost category wise Column chart Start
   function NSCOSTCATEGORYBar(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText)
   {
    document.getElementById('controlAddIn').innerHTML='';
    // PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center></div>Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>'; Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
// PE-115.HS.1.0 23Oct2023 End

    const xValues = [NSBudgetedCostText,NSUsagecostText, NSBudgetedPriceText, NSUsagepriceText];
const yValues = [NSBudgetedCost1,NSUsagecost1, NSBudgetedPrice1, NSUsageprice1];
const barColors = ["#3484a6", "#a32f6e","#6f9c3a","#6a3f89"];

new Chart("myChart", {
  type: "bar",
  data: {
    labels: xValues,
    yValueFormatString: "#,###.00\"%\"",
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
options: {
  legend: {display: false},
  title: {
    display: true,
    // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
  },
  //PRJCTPR-350.DK.1.0 Start
  scales: {
    yAxes: [{
        ticks: {
            callback: function(value) {
                return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
        }
    }]
},
tooltips: 
{
  callbacks: 
  {
      label: function(tooltipItem, data) 
      {
         const title = data.labels[tooltipItem.index];
         const dataset = data.datasets[tooltipItem.datasetIndex];
         const value = dataset.data[tooltipItem.index]; 
         return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
      }
  },
}
//PRJCTPR-350.DK.1.0 End
}
});
   }
   // This Method is showing Job cost category wise Column chart End
function NSRevrecBar2(NS_JobNo, NS_Discription, NSBudgetedCost, NSForCastedText, NSBudgetedPrice, NSBudgetedPrText, NSUsagecost, NSActualCostText, NSRecognizedRevenue, NSRecognizedRevenueText, NSGrossProfit, NSGrossProfitText)
{
  document.getElementById('controlAddIn').innerHTML='';
  // PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center><div>Forecasted vs Revenue Recognized</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Forecasted vs Revenue Recognized</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
//PE-115.HS.1.0 23Oct2023 End
    const xValues = [NSForCastedText, NSActualCostText,NSBudgetedPrText,NSRecognizedRevenueText,NSGrossProfitText];
    const yValues = [NSBudgetedCost, NSUsagecost,NSBudgetedPrice , NSRecognizedRevenue,NSGrossProfit];
    const barColors = ["#4C3152", "#7f2828","#5ba8fc","#cf671e","#dac6fd"];
    new Chart("myChart", {
    type: "bar",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
    },
    //PRJCTPR-350.DK.1.0 Start
    scales: {
      yAxes: [{
          ticks: {
              callback: function(value) {
                  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      }]
  },
  tooltips: 
  {
    callbacks: 
    {
        label: function(tooltipItem, data) 
        {
           const title = data.labels[tooltipItem.index];
           const dataset = data.datasets[tooltipItem.datasetIndex];
           const value = dataset.data[tooltipItem.index]; 
           return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
        }
    },
  }
  //PRJCTPR-350.DK.1.0 End
  }
});
}
   // This Method is showing Job wise Revenue Recognition Summary Details Column chart Start
   function NSRevrecBar(NS_JobNo, NS_Discription, NSCurrentEst, NSCurrentEstText, NSActualCosttoDate, NSActualCosttoDateText, NSCurrentContract, NSCurrentContractText, NSBillingtoDate, NSBillingtoDateText)
   {
    document.getElementById('controlAddIn').innerHTML='';
    // PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center><div>Forecasted vs Actual cost</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Forecasted vs Actual cost</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
//PE-115.HS.1.0 23Oct2023 End

const xValues = [NSCurrentEstText, NSActualCosttoDateText,NSCurrentContractText,NSBillingtoDateText];
    const yValues = [NSCurrentEst, NSActualCosttoDate,NSCurrentContract , NSBillingtoDate];
    const barColors = ["#00bfff", "#800000","#b3d9ff","#ff0000"];
    new Chart("myChart", {
    type: "bar",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
    },
    //PRJCTPR-350.DK.1.0 Start
    scales: {
      yAxes: [{
          ticks: {
              callback: function(value) {
                  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
              }
          }
      }]
  },
  tooltips: 
  {
    callbacks: 
    {
        label: function(tooltipItem, data) 
        {
           const title = data.labels[tooltipItem.index];
           const dataset = data.datasets[tooltipItem.datasetIndex];
           const value = dataset.data[tooltipItem.index]; 
           return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
        }
    },
  }
  //PRJCTPR-350.DK.1.0 End
  }
});

   }
   // This Method is showing Job wise Revenue Recognition Summary Details Column chart End

   // The use of this method shows the quantity amount of job wise job planning line and job ledger entry. showing  Column chart Start
   function NSBudgetedHourbar(NS_JobNo, NS_Discription, NSBudgetedCost2, NSBudgetedCostText, NSUsagecost2, NSUsagecostText)
   {
    document.getElementById('controlAddIn').innerHTML='';
    //PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center> <div>Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>'; Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
// PE-115.HS.1.0 23Oct2023 End


    const xValues = [NSBudgetedCostText,NSUsagecostText];
const yValues = [NSBudgetedCost2,NSUsagecost2];
const barColors = [ "#3f5589","#8e1811"];

new Chart("myChart", {
  type: "bar",
  
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription //PE-115.HS.1.0 23Oct2023 Commented
    }
  }
});
   }
 // The use of this method shows the quantity amount of job wise job planning line and job ledger entry. showing  Column chart END

//This method represents the job-wise pie Chart Start
   function NSPie(NS_JobNo,NS_Discription, NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText){
  
    document.getElementById('controlAddIn').innerHTML='';
    //PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center><div>Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';    Commented
    // '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>'; Commented
    document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
    //PE-115.HS.1.0 23Oct2023 End
    
    const xValues = [NSBudgetedCostText, NSUsagecostText,NSBudgetedPriceText,NSInvoicePriceText];

const yValues = [NSBudgetedCost, NSUsagecost,NSBudgetedPrice , NSInvoicePrice];
const barColors = [
  "#3e7bac", 
  "#943b33",
  "#8ac7df",
  "#dd5837" 
];

new Chart("myChart", {
  type: "pie",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
    },
    //PRJCTPR-350.DK.1.0 Start
  tooltips: 
  {
    callbacks: 
    {
        label: function(tooltipItem, data) 
        {
           const title = data.labels[tooltipItem.index];
           const dataset = data.datasets[tooltipItem.datasetIndex];
           const value = dataset.data[tooltipItem.index]; 
           return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
        }
    },
  }
  //PRJCTPR-350.DK.1.0 End
  }
});
  }
//This method represents the job-wise pie Chart End

//This method shows the job wise cost category wise pie chart Start
  function NSCOSTCATEGORYPIE(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText)
  {
    document.getElementById('controlAddIn').innerHTML='';
    //PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center></div>Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
    document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
    //PE-115.HS.1.0 23Oct2023 End
    const xValues = [NSBudgetedCostText,NSUsagecostText, NSBudgetedPriceText, NSUsagepriceText];

const yValues = [NSBudgetedCost1,NSUsagecost1,NSBudgetedPrice1,NSUsageprice1];
const barColors = [
  "#3484a6",
   "#a32f6e",
   "#6f9c3a",
   "#6a3f89"
];

new Chart("myChart", {
  type: "pie",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    legend: {display: false},
    title: {
      display: true,
      // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
    },
    //PRJCTPR-350.DK.1.0 Start
  tooltips: 
  {
    callbacks: 
    {
        label: function(tooltipItem, data) 
        {
           const title = data.labels[tooltipItem.index];
           const dataset = data.datasets[tooltipItem.datasetIndex];
           const value = dataset.data[tooltipItem.index]; 
           return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
        }
    },
  }
  //PRJCTPR-350.DK.1.0 End
  }
});
  }
  //This method shows the job wise cost category wise pie chart

function NSSEGEMENTPIE(NS_JobNo, NS_Discription, NSBudgetedCost2, NSBudgetedCostText, NSBudgetedPrice2, NSBudgetedPriceText, NSUsagecost2, NSUsagecostText, NSUsageprice2, NSUsagepriceText)
{
  document.getElementById('controlAddIn').innerHTML='';
  document.getElementById('controlAddIn').innerHTML='<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
'<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
  const xValues = [NSBudgetedCostText, NSBudgetedPriceText,NSUsagecostText, NSUsagepriceText];

const yValues = [NSBudgetedCost2,NSBudgetedPrice2,NSUsagecost1,NSUsageprice2];
const barColors = [
"#b91d47",
"#00aba9",
"#2b5797",
"#e8c3b9",
"#1e7145"
];

new Chart("myChart", {
type: "pie",
data: {
  labels: xValues,
  datasets: [{
    backgroundColor: barColors,
    data: yValues
  }]
},
options: {

  title: {
    display: true,
    text: NS_JobNo  + ' ' + NS_Discription
  }
}
});
}
function NSBudgetedHourPie(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSUsagecost1, NSUsagecostText)
{
  document.getElementById('controlAddIn').innerHTML='';
  //PE-115.HS.1.0 23Oct2023 Start
  // document.getElementById('controlAddIn').innerHTML='<center><div>Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>'; Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';

 //PE-115.HS.1.0 23Oct2023 End

  const xValues = [NSBudgetedCostText, NSUsagecostText];

const yValues = [NSBudgetedCost1,NSUsagecost1];
const barColors = [
  "#3f5589",
  "#8e1811"
];

new Chart("myChart", {
type: "pie",
data: {
  labels: xValues,
  datasets: [{
    backgroundColor: barColors,
    data: yValues
  }]
},
options: {

  title: {
    display: true,
    // text: NS_JobNo  + ' ' + NS_Discription //PE-115.HS.1.0 23Oct2023 Commented
  }
}
});
}

  function NSDoughnut(NS_JobNo,NS_Discription,NSBudgetedCost, NSBudgetedCostText, NSBudgetedPrice, NSBudgetedPriceText, NSInvoicePrice, NSInvoicePriceText, NSUsagecost, NSUsagecostText)
  {
    document.getElementById('controlAddIn').innerHTML='';
    //PE-115.HS.1.0 23Oct2023 Start
    // document.getElementById('controlAddIn').innerHTML='<center><div>Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>'; Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Budget Vs Actual</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
 //PE-115.HS.1.0 23Oct2023 End
    const xValues = [NSBudgetedCostText, NSUsagecostText,NSBudgetedPriceText,NSInvoicePriceText];

    const yValues = [NSBudgetedCost, NSUsagecost,NSBudgetedPrice , NSInvoicePrice];
    const barColors = [
      "#3e7bac", 
      "#943b33",
      "#8ac7df",
      "#dd5837" 
    ];
    new Chart("myChart", {
      type: "doughnut",
      data: {
        labels: xValues,
        datasets: [{
          backgroundColor: barColors,
          data: yValues
        }]
      },
      options: {
        legend: {display: false},
        title: {
          display: true,
          // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
        },
        //PRJCTPR-350.DK.1.0 Start
      tooltips: 
      {
        callbacks: 
        {
            label: function(tooltipItem, data) 
            {
               const title = data.labels[tooltipItem.index];
               const dataset = data.datasets[tooltipItem.datasetIndex];
               const value = dataset.data[tooltipItem.index]; 
               return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
            }
        },
      }
      //PRJCTPR-350.DK.1.0 End
      }
    });

  }
  
function NSCOSTCATEGORYPIEoughnut(NS_JobNo, NS_Discription, NSBudgetedCost1, NSBudgetedCostText, NSBudgetedPrice1, NSBudgetedPriceText, NSUsagecost1, NSUsagecostText, NSUsageprice1, NSUsagepriceText)
{
  document.getElementById('controlAddIn').innerHTML='';
   //PE-115.HS.1.0 23Oct2023 Start
//   document.getElementById('controlAddIn').innerHTML='<center></div>Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';   Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Cost Categories</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
 //PE-115.HS.1.0 23Oct2023 End
  const xValues = [NSBudgetedCostText,NSUsagecostText, NSBudgetedPriceText,NSUsagepriceText];
  const yValues = [NSBudgetedCost1,NSUsagecost1,NSBudgetedPrice1, NSUsageprice1];
  const barColors = [
    "#3484a6",
     "#a32f6e",
     "#6f9c3a",
     "#6a3f89"
  ];
  
  new Chart("myChart", {
    type: "doughnut",
    data: {
      labels: xValues,
      datasets: [{
        backgroundColor: barColors,
        data: yValues
      }]
    },
    options: {
      legend: {display: false},
      title: {
        display: true,
        // text: NS_JobNo  + ' ' +NS_Discription // PE-115.HS.1.0 23Oct2023 Commented
      },
      //PRJCTPR-350.DK.1.0 Start
    tooltips: 
    {
      callbacks: 
      {
          label: function(tooltipItem, data) 
          {
             const title = data.labels[tooltipItem.index];
             const dataset = data.datasets[tooltipItem.datasetIndex];
             const value = dataset.data[tooltipItem.index]; 
             return title + ': ' + Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");    
          }
      },
    }
    //PRJCTPR-350.DK.1.0 End
    }
    
  });
}
function NSSEGDoughnut(NS_JobNo, NS_Discription, NSBudgetedCost2, NSBudgetedCostText, NSBudgetedPrice2, NSBudgetedPriceText, NSUsagecost2, NSUsagecostText, NSUsageprice2, NSUsagepriceText)
{
  document.getElementById('controlAddIn').innerHTML='';
  document.getElementById('controlAddIn').innerHTML='<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
'<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';
  const xValues = [NSBudgetedCostText, NSBudgetedPriceText,NSUsagecostText, NSUsagepriceText];

  const yValues = [NSBudgetedCost2, NSBudgetedPrice2,NSUsagecost2, NSUsageprice2];
  const barColors = [
    "#b91d47",
    "#00aba9",
    "#2b5797",
    "#e8c3b9",
    "#1e7145"
  ];

  new Chart("myChart", {
    type: "doughnut",
    data: {
      labels: xValues,
      datasets: [{
        backgroundColor: barColors,
        data: yValues
      }]
    },
    options: {
      title: {
        display: true,
        text: NS_JobNo  + ' ' + NS_Discription
      }
    }
  });
}
function NSBudgetedHourDoughnut(NS_JobNo, NS_Discription, NSBudgetedCost2, NSBudgetedCostText, NSUsagecost2, NSUsagecostText)
{
  document.getElementById('controlAddIn').innerHTML='';
   //PE-115.HS.1.0 23Oct2023 Start
//   document.getElementById('controlAddIn').innerHTML='<center><div>Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
// '<center><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';  Commented
document.getElementById('controlAddIn').innerHTML='<center><div><div style="font-family: system-ui;position: relative;z-index: 99999999;left: 4px; top: 42px;">'+NS_JobNo+' '+NS_Discription+'</div><div style="font-family: system-ui;">Job Hours Analysis(Lab)</div><canvas id="myChart" style="margin-right:24px;width:100%;max-width:600px"></canvas><center>';

 //PE-115.HS.1.0 23Oct2023 End
  const xValues = [NSBudgetedCostText,NSUsagecostText];

  const yValues = [NSBudgetedCost2,NSUsagecost2];
  const barColors = [
    "#3f5589",
    "#8e1811"
  ];

  new Chart("myChart", {
    type: "doughnut",
    data: {
      labels: xValues,
      datasets: [{
        backgroundColor: barColors,
        data: yValues
      }]
    },
    options: {
      title: {
        display: true,
        // text: NS_JobNo  + ' ' + NS_Discription //PE-115.HS.1.0 23Oct2023 Commented
      }
    }
  });
}
  
  
   function NSJPL(NS_JobNo,NS_Discription,Totalling,ScheduleTotalCost,NSUsageTotaCost, ContractTotalPrice,NSContractInvoicedPrice)
   {
    document.getElementById('controlAddIn').innerHTML='';
    document.getElementById('controlAddIn').innerHTML='<center><div style="background-color: white; position: relative;top: 639px; right: 550px;z-index: 99999999;height:100px;width:100px;"></div><div style="width: 1200px; height: 600px;position: absolute; user-select: none;" id="chartContainer" ></div><center>';
    var chart = new CanvasJS.Chart("chartContainer", {
      animationEnabled: true,
      title:{
        fontSize:20,
        text: NS_Discription
      },
      axisY: {
        title: "Job No" + ' ' + NS_JobNo,
        yValueFormatString:"#,##,###.00\"%\"",
        includeZero: true
      },
      legend: {
        cursor:"pointer",
        itemclick : toggleDataSeries
      },
      toolTip: {
        shared: true,
        content: toolTipFormatter
      },
      data:
      [{
        type: "bar",
        showInLegend: true,
       
        name: "Budget Total Cost",
        color: "Green",
        dataPoints: [
          { y: ScheduleTotalCost[0], label: Totalling[0] },
          { y: ScheduleTotalCost[1], label: Totalling[1] },
          { y: ScheduleTotalCost[2], label: Totalling[2] },
          { y: ScheduleTotalCost[3], label: Totalling[3] },
          { y: ScheduleTotalCost[4], label: Totalling[4] },
          { y: ScheduleTotalCost[5], label: Totalling[5] },
          { y: ScheduleTotalCost[6], label: Totalling[6] },
          { y: ScheduleTotalCost[7], label: Totalling[7] },
          { y: ScheduleTotalCost[8], label: Totalling[8] },
          { y: ScheduleTotalCost[9], label: Totalling[9] },
        ]
      },
      {
      type: "bar",
      showInLegend: true,
      name: "Actual Total Cost",
      color: "Red",
      dataPoints: [
        { y: NSUsageTotaCost[0], label: Totalling[0] },
        { y: NSUsageTotaCost[1], label: Totalling[1] },
        { y: NSUsageTotaCost[2], label: Totalling[2] },
        { y: NSUsageTotaCost[3], label: Totalling[3] },
        { y: NSUsageTotaCost[4], label: Totalling[4] },
        { y: NSUsageTotaCost[5], label: Totalling[5] },
        { y: NSUsageTotaCost[6], label: Totalling[6] },
        { y: NSUsageTotaCost[7], label: Totalling[7] },
        { y: NSUsageTotaCost[8], label: Totalling[8] },
        { y: NSUsageTotaCost[9], label: Totalling[9] },
      ]
    },
      {
        type: "bar",
        showInLegend: true,
        name: "Budget Total Price",
        color: "Blue",
        dataPoints: [
          { y: ContractTotalPrice[0], label: Totalling[0] },
          { y: ContractTotalPrice[1], label: Totalling[1] },
          { y: ContractTotalPrice[2], label: Totalling[2] },
          { y: ContractTotalPrice[3], label: Totalling[3] },
          { y: ContractTotalPrice[4], label: Totalling[4] },
          { y: ContractTotalPrice[5], label: Totalling[5] },
          { y: ContractTotalPrice[6], label: Totalling[6] },
          { y: ContractTotalPrice[7], label: Totalling[7] },
          { y: ContractTotalPrice[8], label: Totalling[8] },
          { y: ContractTotalPrice[9], label: Totalling[9] },
        ]
      },
      {
        type: "bar",
        showInLegend: true,
        name: "Invoice Total Price",
        color: "Yellow",
        dataPoints: [
          { y: NSContractInvoicedPrice[0], label: Totalling[0] },
          { y: NSContractInvoicedPrice[1], label: Totalling[1] },
          { y: NSContractInvoicedPrice[2], label: Totalling[2] },
          { y: NSContractInvoicedPrice[3], label: Totalling[3] },
          { y: NSContractInvoicedPrice[4], label: Totalling[4] },
          { y: NSContractInvoicedPrice[5], label: Totalling[5] },
          { y: NSContractInvoicedPrice[6], label: Totalling[6] },
          { y: NSContractInvoicedPrice[7], label: Totalling[7] },
          { y: NSContractInvoicedPrice[8], label: Totalling[8] },
          { y: NSContractInvoicedPrice[9], label: Totalling[9] },
        ]
      },
    ]
    });
    chart.render();

    function toolTipFormatter(e) {
      var str = "";
      var total = 0 ;
      var str3;
      var str2 ;
      for (var i = 0; i < e.entries.length; i++){
        var str1 = "<span style= \"color:"+e.entries[i].dataSeries.color + "\">" + e.entries[i].dataSeries.name + "</span>: <strong>"+  e.entries[i].dataPoint.y + "</strong> <br/>" ;
        total = e.entries[i].dataPoint.y + total;
        str = str.concat(str1);
      }
      str2 = "<strong>" + e.entries[0].dataPoint.label + "</strong> <br/>";
      str3 = "<span style = \"color:Tomato\">Total: </span><strong>" + total + "</strong><br/>";
      return (str2.concat(str)).concat(str3);
    }

    function toggleDataSeries(e) {
      if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
        e.dataSeries.visible = false;
      }
      else {
        e.dataSeries.visible = true;
      }
      chart.render();
    }

    }


    

  //PE-115.DK.1.0 5july2023 END