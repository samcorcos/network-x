Template.main.rendered = ->
  Session.setDefault "isGraph", false

  Tracker.autorun (c) ->
    if Session.get "isGraph", true
      createGraph()

@createGraph = ->
  # Constants
  width = 900
  height = 600
  radius = 20

  # Setting color to 20
  color = d3.scale.category20()

  # Set up force layout
  force = d3.layout.force()
    .charge(-500)
    .linkDistance(80)
    .size([width, height])

  # Append SVG
  svg = d3.select('#network').append('svg')
    .attr('viewBox', "0 0 " + width + " " + height)
    .attr("preserveApectRatio", "xMidYMid meet")

  graph = Session.get "graph"

  force.nodes(graph.nodes)
    .links(graph.links)
    .start()

  link = svg.selectAll('.link')
    .data(graph.links)
    .enter().append('line')
    .attr('class', 'link')
    .style("marker-end",  "url(#suit)")
    .style 'stroke-width', (d) ->
      2 # Math.sqrt(d.value) # TODO we don't have weight, but we can add it!

  node = svg.selectAll('.node')
    .data(graph.nodes)
    .enter().append('circle')
    .attr('class', 'node')
    .attr('r', radius)
    .style('fill', (d) ->
      color(d.label)
    ).call(force.drag)

  svg.append("defs").selectAll("marker")
    .data(["suit", "licensing", "resolved"])
  .enter().append("marker")
    .attr("id", (d) ->
      d
    ).attr("viewBox", "0 -5 10 10")
    .attr("refX", 25)
    .attr("refY", 0)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
  .append("path")
    .attr("d", "M0,-5L10,0L0,5 L10,0 L0, -5")
    .style("stroke", "#999")
    .style("opacity", "0.6")

  force.on 'tick', ->
    link.attr('x1', (d) ->
      d.source.x
    ).attr('y1', (d) ->
      d.source.y
    ).attr('x2', (d) ->
      d.target.x
    ).attr 'y2', (d) ->
      d.target.y
    node.attr('cx', (d) ->
      d.x
    ).attr 'cy', (d) ->
      d.y
    return
