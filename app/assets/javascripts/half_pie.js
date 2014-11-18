$(function () {
	console.log(gon.communicating_meters);

    $('#halfpie').highcharts({
		credits: {
			enabled: false
		},
        chart: {
			backgroundColor: null,
            plotBackgroundColor: null,
			margin: [0, 0, 0, 0],
            plotBorderWidth: 0,
            plotShadow: false
        },
		colors: ['#90ed7d', '#f7a35c'],
        title: {
            text: 'Meter<br>Analysis',
            align: 'center',
            verticalAlign: 'middle',
            y: 50
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                dataLabels: {
                    enabled: true,
                    distance: -50,
                    style: {
                        fontWeight: 'bold',
                        color: 'white',
                        textShadow: '0px 1px 2px black'
                    }
                },
                startAngle: -90,
                endAngle: 90,
                center: ['50%', '75%']
            }
        },
        series: [{
            type: 'pie',
            name: 'Meter Analysis',
            innerSize: '50%',
            data: [
                ['Communicating', gon.communicating_meters.communicating],
                ['Not Communicating', gon.communicating_meters.not_communicating]
            ]
        }]
    });
});
