var type = 'zone';
var title = '', yTitle = '', subtitle = '', value = '', 
  backOption = '', lastValue = '', chartLabels = [], chartData = [];
var baseUrl = '/admin/dashboard/chart/';

$(document).ready(function(){
  init();
});

function init(parent) {
  $.get(baseUrl + type + '/' + parent, function( data ) {
    loadData(parent);
    loadChart();
  });
}

function loadData(parent) {
  console.log(type);
  switch(type) {
    case 'zone':
      title = 'Lista de zonas';
      yTitle = 'Secciones por zona';
      lastValue = '';
      value = '';
      type = 'section'
      backButton = { enable: false }
      event = {
            events: {
                click: function (event) {
                    init(this.series.data[this.x].category);
                }
            }
        };
      break;
    case 'section':
      title = 'Lista de secciones de ' + parent;
      yTitle = 'Manzanas por sección';
      type = 'square'
      lastValue = value;
      backButton = {
          text: 'Regresar',
          onclick: function () {
              type = 'zone'
              init(lastValue);
            }
        }
      event = {
            events: {
                click: function (event) {
                    init(this.series.data[this.x].category);
                }
            }
        };
      value = parent; 
      break;
    case 'square':
      title = 'Lista de simpatizantes de ' + parent;
      yTitle = 'Simpatizantes por manzana';
      type = ''
      lastValue = value;
      backButton = {
          text: 'Regresar',
          onclick: function () {
            type = 'section'
            init(lastValue);
          }
        };
      event = {};
      value = parent;
      break;
  }
}

function loadChart() {
  Highcharts.chart('chart-container', {
    chart: {
        type: 'column'
    },
    title: {
        text: title
    },
    subtitle: {
        text: ''
    },
    xAxis: {
        categories: chartLabels,
        crosshair: true
    },
    yAxis: {
        min: 0,
        title: {
            text: yTitle
        }
    },
    tooltip: {
        enabled: false
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '{point.y}'
            },
            point: event
        }
    },
    series: [{
        data: chartData
    }],
    exporting: {
        buttons: {
            customButton: {
                text: 'Custom Button',
                onclick: function () {
                    alert('You pressed the button!');
                }
            },
            customButton: backButton,
            contextButton: {
                enabled: false
            }  
        }
    },
    credits: {
        enabled: false
    },
    legend: {
        enabled: false
    },
  });
}