'use strict';

var drawChart = function(data, nodeId, isDetailChart) {
  var scaleMin;
  var height;
  var width = $(nodeId).parent().width();
  var dataset = data.bars;
  var lineData = data.lines;
  var chartWidth = $(nodeId).parent().width();
  var padding = 15;

  if (isDetailChart) {
    height = 300;
    scaleMin = d3.min(dataset, function(d) { return d.value - 0.01; });
  } else {
    height = 200;
    scaleMin = 0;
  }

  var yScale = d3.scale.linear()
    .domain([scaleMin, d3.max(dataset, function(d) { return d.value; })])
    .range([padding, height - padding]);

  var xScale = d3.scale.ordinal()
    .domain(d3.range(dataset.length))
    .rangeRoundBands([0, width], 0.1);

  var chart = d3.select(nodeId)
    .attr('width', function(d) {
      return chartWidth;
    })
    .attr('height', height);

  var bar = chart.selectAll('g')
    .data(dataset)
    .enter().append('g');

  bar.append('rect')
    .attr('y', function(d) { return height - yScale(d.value); })
    .attr('x', function(d, i) { return xScale(i); })
    .attr('height', function(d) { return yScale(d.value); })
    .attr('width', xScale.rangeBand())
    .attr('class', function(d) {
      var selectedProviderName = $('.provider_name').text().trim();
      if (d.tooltip.providerName === selectedProviderName) {
        return 'selected';
      }
    });

  for (var i = 0; i < lineData.length; i++) {
    var line = chart.append('line')
      .data([lineData[i]])
      .attr('x1', 0)
      .attr('y1', function(d) { return height - yScale(d.value); })
      .attr('x2', chartWidth)
      .attr('y2', function(d) { return height - yScale(d.value); })
      .attr('class', function(d) {
        return d.label.toLowerCase().split(' ').join('-');
      });

    var text = chart.append('text')
      .data([lineData[i]])
      .text(function(d) {
        return d.label + ': ' + d.value;
      })
      .attr('text-anchor', 'left')
      .attr('x', 0)
      .attr('y', function(d) {
        return height - yScale(d.value) + 4;
      });
  }
};
