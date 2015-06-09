# # http://bl.ocks.org/mbostock/4062045
#
# class Graph
#   constructor: (selector, [height, width]) ->
#     @nodes = []
#     @links = []
#
#     # create an svg element to the body with resizing
#     @svg = d3.select(selector)
#         .append("svg")
#         .attr("viewBox", "0 0 " + width + " " + height)
#         .attr("preserveAspectRatio", "xMidYMid meet")
#
#     # init the force layout
#     @force = d3.layout.force()
#       .size([width, height])
#       .nodes(@nodes)
#       .links(@links)
#       .start()
#
#     @start = @R.once =>
#       @force.on("tick", @tick)
#
#   tick: ->
#     @link.attr("d", (data) -> "M" + data.source.x + "," + data.source.y + "L" + data.target.x + "," + data.target.y)
#     @node.attr("cx", (data) -> data.x).attr("cy", (data) -> data.y)
#     @label.attr("transform", (data) -> "translate(" + data.x + "," + data.y + ")")
#     return
#
#   stop: ->
#     @force.stop()
#     @nodes = []
#     @links = []
#     @force = null
#     d3.remove(@svg)
#     @svg = null
#
#   display: (addNodes, addLinks) ->
#     # merge nodes and links:
#     # its very important that we mutate the arrays and objects rather than
#     # replace them because d3 has a reference to the specific object.
#
#     # for every node in nodes, see if you can find a node with the same id
#     # and if you do, make sure the properties are the same. Otherwise, update
#     # those properties. Otherwise, append the node to the array.
#     for newNode in newNodes
#       found = false
#       for node in @nodes
#         if node.id is newNode.id
#           found = true
#           for key,value in newNode
#             node[key] = value
#           break
#       unless found
#         @nodes.push(newNode)
#
#     # for every link, see if it exists in links, and update the properties if
#     # necessary. otherwise, find the referenced nodes by id and set the source
#     # and target object references
#     for newLink in newLinks
#       found = false
#       for link in @links
#         if link.id is newLink.id
#           found = true
#           for key,value in R.omit(['source', 'target'], newLink)
#             link[key] = value
#           break
#       unless found
#         for node in @nodes
#           if node.id is newLink.source
#             newLink.source = node
#             break
#         for node in @nodes
#           if node.id is newLink.target
#             newLink.target = node
#             break
#         @links.push(newLink)
#
#     @link = @svg.selectAll(".link")
#       .data(@links)
#       .enter()
#       .append("path")
#       .attr("class", "link")
#     @link.exit().remove()
#
#     @node = @svg.selectAll(".node")
#       .data(@nodes)
#       .enter()
#       .append("circle")
#       .attr("class", "node")
#       .attr("r", 7)
#     @node.exit().remove()
#
#     @label = @svg.selectAll(".label")
#       .data(@nodes)
#       .enter()
#       .append("text")
#       .attr("dx", 12)
#       .attr("dy", ".35em")
#       .text((data) -> data.name)
#     @label.exit().remove()
#
#     @start()
#
# # Template.force.onRendered ->
# #   @graph = new Graph('#force', 500, 500)
#
# # Template.force.events
# #   'click .submit-search': () ->
# #     Meteor.call 'search', @find('.search').value, (result, error) =>
# #       @graph.display(result.nodes, result.edges)
#
# # Template.force.onDestroyed ->
# #   @graph.stop()
