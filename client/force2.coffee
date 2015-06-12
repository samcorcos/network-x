Template.main.rendered = ->
  Session.setDefault "graph", []
  network = new Graph('#network', [600,900])

  Tracker.autorun ->
    graph = -> Session.get 'graph'
    network.update(graph) if graph

class Graph
  ## Constants ##
  radius = 20
  padding = 1
  color = d3.scale.category20()

  constructor: (selector, [height, width]) ->
    @nodes = []
    @links = []

    ## Append SVG ##
    @svg = d3.select("#{selector}").append('svg')
      .attr('viewBox', "0 0 #{width} #{height}")
      .attr("preserveApectRatio", "xMidYMid meet")

    ## Set up force layout ##
    @force = d3.layout.force()
      .charge(-500)
      .linkDistance(50)
      .size([width, height])

    # ## Tick when you start? ##
    # @start = @R.once =>
    #   @force.on("tick", @tick)

  tick: ->
    collide = (alpha) ->
      quadtree = d3.geom.quadtree(graph.nodes)
      (d) ->
        rb = 2 * radius + padding
        nx1 = d.x - rb
        nx2 = d.x + rb
        ny1 = d.y - rb
        ny2 = d.y + rb
        quadtree.visit (quad, x1, y1, x2, y2) ->
          if quad.point and quad.point != d
            x = d.x - (quad.point.x)
            y = d.y - (quad.point.y)
            l = Math.sqrt(x * x + y * y)
            if l < rb
              l = (l - rb) / l * alpha
              d.x -= x *= l
              d.y -= y *= l
              quad.point.x += x
              quad.point.y += y
          x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1
        return

    link.attr('x1', (d) -> d.source.x)
      .attr('y1', (d) -> d.source.y)
      .attr('x2', (d) -> d.target.x)
      .attr('y2', (d) -> d.target.y)

    d3.selectAll('circle')
      .attr('cx', (d) -> d.x)
      .attr('cy', (d) -> d.y)

    d3.selectAll('text')
      .attr('x', (d) -> d.x)
      .attr('y', (d) -> d.y)

    # collision detection
    node.each(collide(0.5))

  update: (graph) ->
    @force.nodes(graph.nodes)
      .links(graph.links)
      .start()

    @link = svg.selectAll('.link')
      .data(graph.links)
      .enter().append('line')
      .attr('class', 'link')
      .style("marker-end",  "url(#suit)")
      .style 'stroke-width', (d) ->
        2 # Math.sqrt(d.value) # TODO we don't have weight, but we can add it!

    @node = svg.selectAll('.node')
      .data(graph.nodes)
      .enter().append('g')
      .attr('class', 'node')
      .call(force.drag)

    node.append('circle')
      .attr('r', radius)
      .style 'fill', (d) -> color(d.label)

    node.append('text')
      .attr('dx', '-1.8em')
      .attr('dy', '0.35em')
      .text (d) -> d.name

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
