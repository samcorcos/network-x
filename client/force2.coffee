Template.main.rendered = ->
  Session.setDefault "isGraph", false

  Tracker.autorun (c) ->
    if Session.get "isGraph", true
      createGraph()


@createGraph = ->
  # Constants
  width = 900
  height = 600

  # Setting color to 20
  color = d3.scale.category20()

  # Set up force layout
  force = d3.layout.force()
    .charge(-120)
    .linkDistance(30)
    .size([width, height])

  # Append SVG
  svg = d3.select('#network').append('svg')
    .attr('viewBox', "0 0 " + width + " " + height)
    .attr("preserveApectRatio", "xMidYMid meet")

  graph = Session.get "graph"
  console.log "meep",graph

  force.nodes(graph.nodes)
    .links(graph.links)
    .start()

  link = svg.selectAll('.link')
    .data(graph.links)
    .enter().append('line')
    .attr('class', 'link')
    .style 'stroke-width', (d) ->
      2 # Math.sqrt(d.value) # TODO we don't have weight, but we can add it!

  node = svg.selectAll('.node')
    .data(graph.nodes)
    .enter().append('circle')
    .attr('class', 'node')
    .attr('r', 8)
    .style('fill', (d) ->
      color(d.label)
    ).call(force.drag)

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
