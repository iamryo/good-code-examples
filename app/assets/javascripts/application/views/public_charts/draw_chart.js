'use strict';

// Procedurally, drawChart does the following:
// 1. Call drawChart with a data set, nodeId, isDetailChart boolean, and
//    nodeType (metric module or other type of chart)
// 2. Set chart target values, lines, and labels
// 3. Set the D3 x/y scale domains (input)
// 4. Set the D3 range (chart output)
// 5. Draw bars
// 5a. if isDetailChart, add href links to each bar to change selected provider
// 5b. else just append <g> to svg
// 6. Position and style bars
// 6a. Iterate over all bars and update value className if provider meets target
//     value (classes = [.target_met || .target_not_met])
// 6b. Add target value className to bar
// 6c. Add target value className to chart header value text
// 6d. Highlight selected provider bar
// 7. Draw lines
// 7a. Determine position of left line, text in between, right line for each
//     line data, e.g. "National Average" or "Best"

Nightingale.Views['public_charts-drawChart'] = Backbone.View.extend({

  // initialize: function(data, nodeId, isDetailChart, nodeType) {
  initialize: function(options) {
    this.options = options
    this.parentElement = $(options.nodeId).parent();
    this.parentWidth = this.parentElement.width();
    this.parentHeight = this.parentElement.height();
    this.dataset = options.data.bars;
    this.lineData = options.data.lines;
    this.maxBarWidth = 30;
    this.padding = 15;
    this.dataIsAvailable = this.dataset.length;
    this.nodeIsMetricModule = options.nodeType === 'metric_module';
    this.height = this._getHeight();
    this.width = this._getWidth();

    this._setTargetLines();
    this._setScaleDomains();
    // this._setScaleRanges();

    this.yScale = d3.scale.linear()
          .domain(this.yScaleDomain)
          .rangeRound([this.padding, this.height - this.padding]);
    this.xScale = d3.scale.ordinal()
        .domain(this.xScaleDomain)
        .rangeRoundBands([0, this.width], 0.1);

    this.chart = d3.select(options.nodeId)
      .attr('width', this.width)
      .attr('height', this.height);

    this._drawBars();
    this._drawLines();
  },

  _setTargetLines: function() {
    if (this.nodeIsMetricModule) {
      this.targetLineLabel = 'Target';
      this.targetValue = this._getTargetValue(1);
      this.scaleMin = 0.97; // minimum adjustment factor
      this.showPercent = '';
    } else {
      this.targetLineLabel = 'National Avg';
      this.targetValue = this._getTargetValue(50);
      this.scaleMin = 0;
      this.showPercent = '%';
    }
  },

  _setScaleDomains: function() {
    if (this.dataIsAvailable) {
      this.xScaleDomain = d3.range(this.dataset.length);
      this.yScaleDomain = [this.scaleMin, this.yScaleDomainMax()];
      this.targetValue = this.lineData[1].value;
    } else {
      this.scaleMin = 0;
      this.xScaleDomain = 11; // arbitrary value
      this.yScaleDomain = [this.scaleMin, this.targetValue];
    }
  },

  _setScaleRanges: function() {
    // this.yScale = d3.scale.linear()
    //     .domain(this.yScaleDomain)
    //     .rangeRound([this.padding, this.height - this.padding]);

    // this.xScale = d3.scale.ordinal()
    //   .domain(this.xScaleDomain)
    //   .rangeRoundBands([0, this.width], 0.1);
  },

  _drawBars: function() {
    this.bar = this.chart.selectAll('g')
     .data(this.dataset)
     .enter().append('g');

    if (this.options.isDetailChart) {
      this.link = this.bar.append('svg:a')
        .attr('xlink:href', function(d) { return d.uri; });
    } else {
      this.link = this.bar.append('g');
    }
  },

  _drawLines: function() {
    for (var i = 0; i < this.lineData.length; i++) {
      var lineEndPosition;
      var lineStartPosition;
      var textXPosition;
      var textYPosition;
      var className = this.lineData[i].label.toLowerCase().split(' ').join('-');

      if (this.options.isDetailChart) {
        lineStartPosition = 0;
        lineEndPosition = 20;
        textXPosition = 30;
      } else {
        lineStartPosition = -10;
        lineEndPosition = width + 10;
        textXPosition = width + 20;
      }

        debugger
      var lineLeft = this.chart.append('line')
        .data([this.lineData[i]])
        .attr('x1', lineStartPosition)
        .attr('y1', function(d) { return this.height - this.yScale(d.value); })
        .attr('x2', lineEndPosition)
        .attr('y2', function(d) { return this.height - this.yScale(d.value); })
        .attr('class', function(d) { return className; });

      var text = this.chart.append('text')
        .data([this.lineData[i]])
        .text(function(d) { return d.label + ': ' + d.value + showPercent; })
        .attr('x', textXPosition)
        .attr('y', function(d) {
          if (textYPosition) {
            return getTextYPosition(d);
          }
          textYPosition = this.height - this.yScale(d.value) + 4;
          return textYPosition;
        })
        .attr('class', function(d) { return className; });

      if (this.options.isDetailChart) {
        var textWidth = $('text.' + className).width();

        var lineRight = this.chart.append('line')
          .data([this.lineData[i]])
          .attr('x1', textWidth + 40)
          .attr('y1', function(d) {
            return this.height - this.yScale(d.value);
          })
          .attr('x2', width)
          .attr('y2', function(d) {
            return this.height - this.yScale(d.value);
          })
          .attr('class', function(d) { return className; });
      }
    }
  },

  _getHeight: function() {
    return this.parentHeight - this.padding;
  },

  _getWidth: function() {
    if (this.options.isDetailChart) {
      return this.parentWidth;
    } else {
      return this.parentWidth / 6;
    }
  },

  _getTargetValue: function(defaultValue) {
    if (this.dataIsAvailable) {
      return this.lineData[1].value;
    }
    return defaultValue;
  },

  _getBestValueMethod: function() {
    var defaultValue = 'maximum';

    if (this.dataIsAvailable) {
      return this.lineData[1].bestValueMethod || defaultValue;
    }
    return defaultValue;
  },

  _yScaleDomainMax: function() {
    return Math.max(
      targetValue,
      d3.max(dataset, function(d) { return d.value; })
    );
  },

  _targetMet: function(dataValue) {
    if (this._getBestValueMethod() === 'maximum') {
      return dataValue >= this.getTargetValue();
    }
    return dataValue <= this.getTargetValue();
  },

  _getBarWidth: function() {
    if (this.options.isDetailChart && xScale.rangeBand() > maxBarWidth) {
      return maxBarWidth;
    }

    return xScale.rangeBand();
  },

  _xPosition: function(i) {
    if (this.options.isDetailChart) {
      var chartMidpoint = this.width / 2;
      var datasetMidpoint = this.dataset.length / 2;
      var maxBarWidthAndPadding = this._getBarWidth() + 3;
      var positionWithIndex = maxBarWidthAndPadding * i;
      var firstBarPosition = datasetMidpoint * maxBarWidthAndPadding;

      return chartMidpoint - (firstBarPosition - positionWithIndex);
    }

    return xScale(i);
  },

  getTextYPosition: function(d) {
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
  },
});
