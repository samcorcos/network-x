@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  search: (query, index, tags...) ->
    ## If there is no index, run for everything ##
    if !index
      ## Case-insensitive search query by name ##
      nodesA = Neo4j.query "MATCH (a)-[]-() WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a)-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a)-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    ## If there is an index, run a more efficient query ##
    if index
      ## Case-insensitive search query by name ##
      nodesA = Neo4j.query "MATCH (a:#{index})-[]-() WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

  getTags: -> Neo4j.query "MATCH (a) UNWIND a.tags AS x RETURN DISTINCT x"


  getGraph: () ->
    ## Returns all data in the graph ##
    nodes = Neo4j.query "MATCH (a) RETURN {name:a.name, label:labels(a)[0], id:id(a)} as nodes"

    linkIds = Neo4j.query "MATCH (a)-[r]->(b) RETURN {source:id(a), target:id(b), type:type(r)} as links"

    ## createLinks takes in a link with ids and the full node list, then converts it to something that D3 can use: array indeces
    links = createLinks linkIds, R.pluck('id')(nodes)

    return graph = { links:links, nodes:nodes }
    #
    #
    # if industry
    #   nodesA = Neo4j.query "MATCH (a:Company)-[]-() WHERE '#{industry}' in a.industry RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
    #   nodesB = Neo4j.query "MATCH (a:Company)-[]-(b) WHERE '#{industry}' in a.industry RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
    #   nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...
    #
    #   linkIds = Neo4j.query "MATCH (a:Company)-[r]-(b) WHERE '#{industry}' in a.industry RETURN {source:id(a), target:id(b), type:type(r)} as links"
    #   links = createLinks linkIds, R.pluck('id')(nodes)
    #
    #   return graph = { links:links, nodes:nodes }
