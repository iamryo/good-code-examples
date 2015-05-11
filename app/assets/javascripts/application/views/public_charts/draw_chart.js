var drawChart = function(data, nodeId, isDetailChart) {
  var width = $(nodeId).parent().width();
  var height;
  var barPadding = 3;
  var barWidth = 30;
  var dataset = data.bars;
  var lineData = data.lines;
  var chartWidth = dataset.length * (barWidth + barPadding);

  if (isDetailChart) {
    height = 300;
  } else {
    height = 200;
  };

  var y = d3.scale.linear()
    .rangeRound([height, 0]);

  var chart = d3.select(nodeId)
    .attr('width', function(d) {
      return chartWidth;
    })
    .attr('height', height);

  y.domain([
    d3.min(dataset, function(d) { return d.value - .05 }),
    d3.max(dataset, function(d) { return d.value })]
  );

  // y.domain([0.99, d3.max(dataset, function(d) { return d.value; })]);

  // var barWidth = width / dataset.length;
  // var barWidth = width / dataset.length - barPadding;

  var bar = chart.selectAll('g')
    .data(dataset)
    .enter().append('g');

  bar.append('rect')
    .attr('y', function(d) { return y(d.value); })
    // .attr('x', function(d, i) {
    //   return i * (width / dataset.length)
    // })
    .attr('x', function(d, i) {
      return i * (barWidth + barPadding)
    })
    .attr('height', function(d) { return height - y(d.value); })
    .attr('width', barWidth)
    .attr('class', function(d) {
      var selectedProviderName = $('.provider_name').text().trim();
      if (d.tooltip.provider_name === selectedProviderName) {
        return 'selected';
      };
    });

  var line = chart.append('line')
    .data(lineData)
    .attr('x1', 0)
    .attr('y1', function(d) { return y(d.value); })
    .attr('x2', function(d) { return chartWidth })
    .attr('y2', function(d) { return y(d.value); })
    .attr('stroke-width', 1)
    .attr('stroke', 'red')
    .attr('stroke-dasharray', '3, 3')
    .attr('class', function(d) { return d.label.toLowerCase(); })
}
