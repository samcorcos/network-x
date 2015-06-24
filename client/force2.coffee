class @Graph
  # Constants
  width = 900
  height = 700
  radius = 20
  padding = 1
  color = d3.scale.category20()

  constructor: () ->
    $( "svg" ).remove()

    # Append SVG
    @viewBox = d3.select('#network').append('svg')
      .attr('viewBox', "0 0 #{width} #{height}")
      .attr("preserveApectRatio", "xMidYMid meet")

    @svg = @viewBox.append('svg:g')

    # Set up force layout
    @force = d3.layout.force()
      .charge(-500)
      .linkDistance(50)
      .linkStrength(0.6)
      .size([width, height])

    @d3zoom = d3.behavior.zoom()
    @translateOffset = [0,0];
    @currentTranslate = 0;
    @scale = 1;

  rescale: ->
    if (@panDisabled)
      d3X = d3.event.translate[0] || 0
      d3Y = d3.event.translate[1] || 0
      @translateOffset = [d3X - @currentTranslate[0], d3Y - @currentTranslate[1]]
    else
      @currentTranslate = [d3.event.translate[0] - @translateOffset[0], d3.event.translate[1] - @translateOffset[1]]
      @scale = d3.event.scale
      @svg.attr("transform",
          "translate(" + @currentTranslate + ")" +
          " scale(" + @scale + ")")

  addZoomBehaviour: ->
    self = this
    rescaleThis = ->
      self.rescale.call(self)
    @viewBox.call(@d3zoom.on "zoom", rescaleThis)

  disableZoom: ->
    @viewBox.call(@d3zoom.on "zoom", null)

  update: ->
    graph = Session.get "graph"
    self = @
    @addZoomBehaviour()

    @force.nodes(graph.nodes)
      .links(graph.links)
      .start()

    link = @svg.selectAll('.link')
      .data(graph.links)
      .enter().append('line')
      .attr('data-type', (d) -> d.type)
      .attr('class', 'link')
      .style("marker-end",  "url(#suit)") ## TODO this was a copy and paste. should be fixed later
      .style 'stroke-width', (d) ->
        2 # Math.sqrt(d.value) # TODO we don't have weight, but we can add it!

    node = @svg.selectAll('.node')
      .data(graph.nodes)
      .enter().append('g')
      .attr('class', 'node')
      .call(@force.drag)

    node.on 'mousedown', ->
      self.panDisabled = true;
    window.onmouseup = ->
      self.panDisabled = false;

    node.append('circle')
      .attr('r', radius)
      .attr('data-id', (d) -> d.id)
      .attr('data-label', (d) -> d.label)
      .attr('data-name', (d) -> d.name)
      .attr('data-description', (d) -> d.description)
      .style 'fill', (d) -> color(d.label)

    node.append('text')
      .attr('dx', '-1.8em')
      .attr('dy', '0.35em')
      .text (d) -> d.name

    @svg.append("defs").selectAll("marker")
      .data(["suit"])                       ## TODO There's something weird going on here. I just copied and pasted
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

    @force.on 'tick', ->
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
