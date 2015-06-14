@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  ## TODO This method looks like something that can refactored ##
  ## TODO Tags are currently *exclusive*, not inclusive ##
  search: (query, index, tags) ->
    if tags.length > 0 and index and query
      nodesA = Neo4j.query "MATCH (a:#{index}) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and index and not query
      nodesA = Neo4j.query "MATCH (a:#{index}) WHERE '#{tags}' in a.tags RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) WHERE '#{tags}' in a.tags RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) WHERE '#{tags}' in a.tags RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and query and not index
      nodesA = Neo4j.query "MATCH (a) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a)-[]-(b) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a)-[r]-(b) WHERE '#{tags}' in a.tags AND a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and not query and not index
      nodesA = Neo4j.query "MATCH (a) WHERE '#{tags}' in a.tags RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a)-[]-(b) WHERE '#{tags}' in a.tags RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a)-[r]-(b) WHERE '#{tags}' in a.tags RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if index and not tags.length > 0 and not query
      nodesA = Neo4j.query "MATCH (a:#{index}) RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if index and query and not tags.length > 0
      nodesA = Neo4j.query "MATCH (a:#{index}) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a:#{index})-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a:#{index})-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if query and not tags.length > 0 and not index
      nodesA = Neo4j.query "MATCH (a) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:a.name, label:labels(a)[0], id:id(a)} as nodes"
      nodesB = Neo4j.query "MATCH (a)-[]-(b) WHERE a.name =~ '(?i)#{query}' RETURN DISTINCT {name:b.name, label:labels(b)[0], id:id(b)} as nodes"
      nodes = nodesA.concat(nodesB) ## TODO there must be a way to do this in one query...

      linkIds = Neo4j.query "MATCH (a)-[r]-(b) WHERE a.name =~ '(?i)#{query}' RETURN {source:id(a), target:id(b), type:type(r)} as links"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

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
