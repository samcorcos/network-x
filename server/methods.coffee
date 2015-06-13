@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

###

Options:

1) Tags + index + query
2) Tags + index
3) Tags + query
4) Tags
5) Index
6) Index + query
7) Name


###


Meteor.methods
  search: (query, index, tags) ->
    ## If there is no index, run for everything ##
    if tags.length > 0 and index and query
      console.log "tags, index, query"

    if tags.length > 0 and index and not query
      console.log "tags and index"

    if tags.length > 0 and query and not index
      console.log "tags and query"

    if tags.length > 0 and not query and not index
      console.log "tags"

    if index and not tags.length > 0 and not query
      console.log "index"

    if index and query and not tags.length > 0
      console.log "index and names"

    if query and not tags.length > 0 and not index
      console.log "query"

    # if !index
    #   ## Case-insensitive search query by name ##
    #   nodesA = Neo4j.query "MATCH (a) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
    #   nodesB = Neo4j.query "MATCH (a)-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
    #   nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...
    #
    #   linkIds = Neo4j.query "MATCH (a)-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
    #   links = createLinks linkIds, R.pluck('id')(nodes)
    #
    #   return graph = { links:links, nodes:nodes }
    #
    # ## If there is an index, run a more efficient query ##
    # if index
    #   ## Case-insensitive search query by name ##
    #   nodesA = Neo4j.query "MATCH (a:#{index}) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
    #   nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
    #   nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...
    #
    #   linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
    #   links = createLinks linkIds, R.pluck('id')(nodes)
    #
    #   return graph = { links:links, nodes:nodes }

    #
    #
    # if tags
    #   nodesA = Neo4j.query "MATCH (a:Company)-[]-() WHERE '#{tags}' in a.tags RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
    #   nodesB = Neo4j.query "MATCH (a:Company)-[]-(b) WHERE '#{tags}' in a.tags RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
    #   nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...
    #
    #   linkIds = Neo4j.query "MATCH (a:Company)-[r]-(b) WHERE '#{tags}' in a.tags RETURN {source:id(a), target:id(b), type:type(r)} as links"
    #   links = createLinks linkIds, R.pluck('id')(nodes)
    #
    #   return graph = { links:links, nodes:nodes }

  getGraph: () ->
    ## Returns all data in the graph ##
    nodes = Neo4j.query "MATCH (a) RETURN {name:a.name, label:labels(a)[0], id:id(a)} as nodes"

    linkIds = Neo4j.query "MATCH (a)-[r]->(b) RETURN {source:id(a), target:id(b), type:type(r)} as links"

    ## createLinks takes in a link with ids and the full node list, then converts it to something that D3 can use: array indeces
    links = createLinks linkIds, R.pluck('id')(nodes)

    return graph = { links:links, nodes:nodes }

  getTags: -> Neo4j.query "MATCH (a) UNWIND a.tags AS x RETURN DISTINCT x"

  createNode: (label, name, tags) -> Neo4j.query "MERGE (a:#{label} {name:'#{name}'})"

  getNodes: (query) -> Neo4j.query "MATCH (a) WHERE a.name =~ '(?i)#{query}.+' RETURN DISTINCT {name:a.name} as nodes"

  getLinkTypes: -> Neo4j.query "MATCH ()-[r]-() RETURN DISTINCT type(r)"

  createLink: (source, type, target) -> Neo4j.query "MATCH (a {name:'#{source}'}) MATCH (b {name:'#{target}'}) MERGE (a)-[r:#{type}]-(b)"
