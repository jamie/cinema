import React, { Component } from "react";
import * as d3 from "d3";
import styled from "styled-components";

const TimeBlockDiv = styled.div`
  & .axis path {
    fill: none;
    stroke: grey;
    shape-rendering: crispEdges;
  }
  & .grid .tick {
    stroke: lightgrey;
    opacity: 0.8;
    stroke-dasharray: 2, 12;
  }
  & .grid path {
    stroke-width: 0;
  }
  & rect.times.bar {
    fill: #006d2c;
    fill-opacity: 0.5;
    stroke: #006d2c;
    stroke-width: 1px;
  }
`;

export class TimeBlock extends Component {
  componentDidMount() {
    this.drawChart();
  }

  drawChart() {
    // const height = 30
    // const width = 420
    // const x = d3.scaleLinear()
    //   .domain([600,1440])
    //   .range([0, 420]) // Nominally 840, but I'm shrinking the scale
    // const data = this.props.showings.map((showing) => showing.time_m)
    // const svg = d3.select('#'+this.props.id)
    //   .append("svg")
    //   // .attr("width", width)
    //   // .attr("height", height)
    // svg.selectAll("rect")
    //   .data(data)
    //   .enter()
    //   .append("rect")
    //   .attr("x", (d, i) => i * 70)
    //   .attr("y", (d, i) => height - 10 * d)
    //   .attr("width", 65)
    //   .attr("height", (d, i) => d * 10)
    //   .attr("fill", "green")
    // Adapted/updated from http://bl.ocks.org/LauraHornbake/6248343
    var data = this.props.showings.map(s => s.d3_time);
    var dRange = [
      d3.min(data, function(d) {
        return d3.timeDay.floor(new Date(d.start));
      }),
      d3.max(data, function(d) {
        return d3.timeDay.ceil(new Date(d.stop));
      })
    ];
    var m = { top: 20, right: 15, bottom: 0, left: 0 },
      width = 360,
      barSize = 20,
      height = ((dRange[1] - dRange[0]) / (24 * 60 * 60 * 1000)) * barSize;
    var svg = d3
      .select("#" + this.props.id)
      .append("div")
      .attr("class", "d3-container container")
      .selectAll("svg")
      .data(d3.range(1))
      .enter()
      .append("svg")
      .attr("id", "viz")
      .attr("width", width + m.right + m.left)
      .attr("height", height + m.top + m.bottom)
      .append("g")
      .attr("transform", "translate(" + m.left + ", " + m.top + ")");
    // Scales, 24h basis, 10a-midnight
    var x = d3
      .scaleTime()
      .domain([0, 14])
      .range([0, width]);
    var y = d3
      .scaleTime()
      .domain(dRange)
      .range([0, height]);
    var tfh = d3
      .scaleTime()
      .domain([
        d3.timeHour(new Date(2014, 0, 1, 10, 0, 0)),
        d3.timeHour(new Date(2014, 0, 2, 0, 0, 0))
      ])
      .range([0, width]);
    /* add bars to chart */
    svg
      .append("g")
      .attr("class", "chart")
      .selectAll("rect")
      .data(data)
      .enter()
      .append("rect")
      .attr("class", "times bar")
      .attr("x", function(d) {
        var startDate = new Date(d.start),
          hr = startDate.getHours(),
          mn = startDate.getMinutes(),
          dur = hr - 10 + mn / 60; // -10 because we're rendering 0..14 hours of the day?
        return x(dur);
      })
      .attr("y", function(d) {
        return y(d3.timeDay.floor(new Date(d.start)));
      })
      .attr("width", function(d) {
        var hstart = new Date(d.start),
          hstop = new Date(d.stop);
        return x((hstop - hstart) / 3600000); //date operations return a timestamp in miliseconds, divide to convert to hours
      })
      .attr("height", barSize - 2)
      .attr("rx", 3)
      .attr("ry", 3)
      .text(function(d) {
        return d.start + " - " + d.stop;
      })
      .datum(function(d) {
        return Date.parse(d.start);
      });
    /*add axes and grid*/
    var xAxis = d3
      .axisTop(tfh)
      .ticks(6)
      .tickFormat(d3.timeFormat("%I %p"));
    var xGrid = d3.axisBottom(tfh).ticks(6);
    // var yAxis = d3.axisLeft(y)
    //   .tickFormat(d3.timeFormat("%m/%d"));
    svg
      .append("g")
      .attr("class", "x top axis")
      .call(xAxis);
    svg
      .append("g")
      .attr("class", "x grid")
      .call(xGrid.tickSize(height, 0, 0).tickFormat(""));
    // svg.append("g")
    //   .attr("class","y left axis")
    //   .call(yAxis);
  }

  render() {
    if (this.props.showings.length === 0) {
      return "N/A";
    } else {
      return <TimeBlockDiv id={this.props.id} />;
    }
  }
}

export default TimeBlock;
