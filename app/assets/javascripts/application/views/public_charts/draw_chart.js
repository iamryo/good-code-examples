'use strict';

var drawChart = function(data, nodeId, isDetailChart) {
  var scaleMin;
  var height;
  var width;
  var parentElement = $(nodeId).parent()
  var parentWidth = parentElement.width();
  var dataset = data.bars;
  var lineData = data.lines;
  var maxBarWidth = 30;
  var padding = 15;

  if (isDetailChart) {
    height = 300;
    width = parentWidth;
    scaleMin = d3.min(dataset, function(d) { return d.value - 0.01; });
  } else {
    height = 100;
    width = parentWidth / 6
    scaleMin = 0;
  }

  var yScale = d3.scale.linear()
    .domain([scaleMin, d3.max(dataset, function(d) { return d.value; })])
    .range([padding, height - padding]);

  var xScale = d3.scale.ordinal()
    .domain(d3.range(dataset.length))
    .rangeRoundBands([0, width], 0.1);

  var barWidth = function() {
    if (isDetailChart || xScale.rangeBand() > maxBarWidth) {
      return maxBarWidth;
    }

    return xScale.rangeBand();
  };

  var xPosition = function(i) {
    if (isDetailChart) {
      var chartMidpoint = width / 2;
      var datasetMidpoint = dataset.length / 2;
      var maxBarWidthAndPadding = maxBarWidth + 3;
      var positionWithIndex = maxBarWidthAndPadding * i;
      var firstBarPosition = datasetMidpoint * maxBarWidthAndPadding;

      return (chartMidpoint - (firstBarPosition - positionWithIndex));
    }

    return xScale(i);
  }

  var chart = d3.select(nodeId)
    .attr('width', width)
    .attr('height', height);

  var bar = chart.selectAll('g')
    .data(dataset)
    .enter().append('g');

  bar.append('rect')
    .attr('y', function(d) { return height - yScale(d.value); })
    .attr('x', function(d, i) { return xPosition(i); })
    .attr('height', function(d) { return yScale(d.value); })
    .attr('width', barWidth)
    .attr('class', function(d) {
      var selectedProviderName = $('.provider_name').text().trim();
      var className = 'target_not_met';

      for (var i = 0; i < lineData.length; i++) {
        if (lineData[i].label === 'Target') {
          if (d.value >= lineData[i].value) {
            className = 'target_met';
          }
        }
      }

      parentElement.parent().addClass(className);

      if (d.tooltip.providerName === selectedProviderName) {
        return className + ' selected';
      }
    });

  for (var i = 0; i < lineData.length; i++) {
    var textPosition;
    var lineEndPosition;
    var lineStartPosition;
    var textXPosition;
    var className = lineData[i].label.toLowerCase().split(' ').join('-');

    if (isDetailChart) {
      lineStartPosition = 0;
      lineEndPosition = 20;
      textXPosition = 30;
    } else {
      lineStartPosition = -10;
      lineEndPosition = width + 10;
      textXPosition = width + 20;
    }

    var lineLeft = chart.append('line')
      .data([lineData[i]])
      .attr('x1', lineStartPosition)
      .attr('y1', function(d) { return height - yScale(d.value); })
      .attr('x2', lineEndPosition)
      .attr('y2', function(d) { return height - yScale(d.value); })
      .attr('class', function(d) {
        return className;
      });

    var text = chart.append('text')
      .data([lineData[i]])
      .text(function(d) {
        return d.label + ': ' + d.value;
      })
      .attr('x', textXPosition)
      .attr('y', function(d) {
        return height - yScale(d.value) + 4;
      })
      .attr('class', function(d) {
        return className;
      });

    if (isDetailChart) {
      var textWidth = $('text.' + className).width();

      var lineRight = chart.append('line')
        .data([lineData[i]])
        .attr('x1', textWidth + 40)
        .attr('y1', function(d) { return height - yScale(d.value); })
        .attr('x2', width)
        .attr('y2', function(d) { return height - yScale(d.value); })
        .attr('class', function(d) {
          return className;
        });
    }
  }
};
