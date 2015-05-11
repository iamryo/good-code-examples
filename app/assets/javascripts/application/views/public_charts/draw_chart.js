var drawChart = function(data, node_id) {
  var width = $(node_id).parent().width(),
      height = $(node_id).parent().height();

  var y = d3.scale.linear()
    .range([height, 0]);

  var chart = d3.select(node_id)
    .attr('width', width)
    .attr('height', height);

  y.domain([
    d3.min(data.bars, function(d) { return d.value - 2 }),
    d3.max(data.bars, function(d) { return d.value })]
  );

  var barWidth = width / data.bars.length;

  var bar = chart.selectAll('g')
    .data(data.bars)
    .enter().append('g')
      .attr("transform", function(d, i) {
        return "translate(" + i * barWidth + ",0)";
      });

  bar.append('rect')
    .attr('y', function(d) { return y(d.value); })
    .attr('height', function(d) { return height - y(d.value); })
    .attr('width', barWidth - 1)
    .attr('class', function(d) {
      var selectedProviderName = $('.provider_name').text().trim();
      if (d.tooltip.provider_name === selectedProviderName) {
        return 'selected';
      };
    });

  bar.append("text")
    .attr("x", barWidth / 2)
    .attr("y", function(d) { return y(d.value) + 3; })
    .attr("dy", ".75em")
    .text(function(d) { return d.value; });
}
