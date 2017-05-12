$(document).ready(function(){
  var rFactor = function(){ return Math.round(Math.random()*100); };

  var barData = {
        labels : zonesLabels,
        datasets : [
          {
            fillColor : '#23b7e5',
            strokeColor : '#23b7e5',
            highlightFill: '#23b7e5',
            highlightStroke: '#23b7e5',
            data : zonesData
          }
        ]
    };
    
  var barOptions = {
    scaleBeginAtZero : true,
    scaleShowGridLines : true,
    scaleGridLineColor : 'rgba(0,0,0,.05)',
    scaleGridLineWidth : 1,
    barShowStroke : true,
    barStrokeWidth : 2,
    borderWidth: 10,
    barValueSpacing : 5,
    barDatasetSpacing : 1,
    responsive: false
  };

  var barctx = document.getElementById("zones-chart").getContext("2d");
  var barChart = new Chart(barctx).Bar(barData, barOptions);
});