'use strict';

Nightingale.drawChart = function(data, nodeId, isDetailChart, nodeType) {
  var scaleMin;
  var height;
  var width;
  var xScaleDomain;
  var yScaleDomain;
  var targetLineLabel;
  var targetValue;
  var showPercent;
  var link;
  var textYPosition;
  var parentElement = $(nodeId).parent();
  var parentWidth = parentElement.width();
  var parentHeight = parentElement.height();
  var dataset = data.bars;
  var lineData = data.lines;
  var maxBarWidth = 30;
  var padding = 15;
  var dataIsAvailable = dataset.length;
  var nodeIsMetricModule = nodeType === 'metric_module';

  var getTargetValue = function(defaultValue) {
    if (dataIsAvailable) {
      return lineData[1].value;
    }
    return defaultValue;
  };

  var getBestValueMethod = function() {
    var defaultValue = 'maximum';

    if (dataIsAvailable) {
      return lineData[1].bestValueMethod || defaultValue;
    }
    return defaultValue;
  };

  if (isDetailChart) {
    height = parentHeight - padding;
    width = parentWidth;
  } else {
    height = parentHeight - padding;
    width = parentWidth / 6;
  }

  if (nodeIsMetricModule) {
    targetLineLabel = 'Target';
    targetValue = getTargetValue(1);
    scaleMin = 0.97; // minimum adjustment factor
    showPercent = '';
  } else {
    targetLineLabel = 'National Avg';
    targetValue = getTargetValue(50);
    scaleMin = 0;
    showPercent = '%';
  }

  var yScaleDomainMax = function() {
    return Math.max(
      targetValue,
      d3.max(dataset, function(d) { return d.value; })
    );
  };

  if (dataIsAvailable) {
    xScaleDomain = d3.range(dataset.length);
    yScaleDomain = [scaleMin, yScaleDomainMax()];
    targetValue = lineData[1].value;
  } else {
    scaleMin = 0;
    xScaleDomain = 11; // arbitrary value
    yScaleDomain = [scaleMin, targetValue];
  }

  var targetMet = function(dataValue, targetValue) {
    if (getBestValueMethod() === 'maximum') {
      return dataValue > targetValue;
    }
    return dataValue < targetValue;
  };

  var yScale = d3.scale.linear()
    .domain(yScaleDomain)
    .rangeRound([padding, height - padding]);

  var xScale = d3.scale.ordinal()
    .domain(xScaleDomain)
    .rangeRoundBands([0, width], 0.1);

  var barWidth = function() {
    if (isDetailChart && xScale.rangeBand() > maxBarWidth) {
      return maxBarWidth;
    }

    return xScale.rangeBand();
  };

  var xPosition = function(i) {
    if (isDetailChart) {
      var chartMidpoint = width / 2;
      var datasetMidpoint = dataset.length / 2;
      var maxBarWidthAndPadding = barWidth() + 3;
      var positionWithIndex = maxBarWidthAndPadding * i;
      var firstBarPosition = datasetMidpoint * maxBarWidthAndPadding;

      return chartMidpoint - (firstBarPosition - positionWithIndex);
    }

    return xScale(i);
  };

  var getTextYPosition = function(d) {
    var minDistance = 16;
    var calcTextYPos = height - yScale(d.value) + 4;
    var minDistanceMet = Math.abs(calcTextYPos - textYPosition) > minDistance;

    if (minDistanceMet) {
      return calcTextYPos;
    } else {
      if (calcTextYPos < textYPosition) {
        return textYPosition - minDistance;
      } else {
        return textYPosition + minDistance;
      }
    }
  };

  var chart = d3.select(nodeId)
    .attr('width', width)
    .attr('height', height);

  var bar = chart.selectAll('g')
    .data(dataset)
    .enter().append('g');

  if (isDetailChart) {
    link = bar.append('svg:a')
      .attr('xlink:href', function(d) { return d.uri; });
  } else {
    link = bar.append('g');
  }

  link.append('rect')
    .attr('x', function(d, i) { return xPosition(i); })
    .attr('y', function(d) { return height - yScale(d.value); })
    .attr('height', function(d) { return yScale(d.value); })
    .attr('width', barWidth)
    .attr('class', function(d) {
      var selectedProviderName = $('.provider_name').text().trim();
      var className = 'target_not_met';

      for (var i = 0; i < lineData.length; i++) {
        if (lineData[i].label === targetLineLabel) {
          if (targetMet(d.value, lineData[i].value)) {
            className = 'target_met';
          }
        }
      }

      parentElement.parent().addClass(className);

      if (d.tooltip.providerName === selectedProviderName) {
        if (isDetailChart) {
          $('.adjustment_value').addClass(className);
        }
        return className + ' selected';
      }
    });

  for (var i = 0; i < lineData.length; i++) {
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
      .attr('class', function(d) { return className; });

    var text = chart.append('text')
      .data([lineData[i]])
      .text(function(d) { return d.label + ': ' + d.value + showPercent; })
      .attr('x', textXPosition)
      .attr('y', function(d) {
        if (textYPosition) {
          return getTextYPosition(d);
        }
        textYPosition = height - yScale(d.value) + 4;
        return textYPosition;
      })
      .attr('class', function(d) { return className; });

    if (isDetailChart) {
      var textWidth = $('text.' + className).width();

      var lineRight = chart.append('line')
        .data([lineData[i]])
        .attr('x1', textWidth + 40)
        .attr('y1', function(d) { return height - yScale(d.value); })
        .attr('x2', width)
        .attr('y2', function(d) { return height - yScale(d.value); })
        .attr('class', function(d) { return className; });
    }
  }
};
