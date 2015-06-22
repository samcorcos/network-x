neo4jUsername = Meteor.settings.neo4j.username
neo4jPassword = Meteor.settings.neo4j.password

Neo4j = new Neo4jDB("http://#{neo4jUsername}:#{neo4jPassword}@networkx.sb05.stations.graphenedb.com:24789")
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  search: (query, index, tags) ->

    ## This is the query you use to match, either with or without an index ##
    nIndex = "(a:#{index})-[]-(b)"
    lIndex = "(a:#{index})-[r]-(b)"
    nXIndex = "(a)-[]-(b)"
    lXIndex = "(a)-[r]-(b)"

    notJ = " NOT labels(a)[0] = 'Jurisdiction' AND NOT labels(b)[0] = 'Jurisdiction' "

    name = "a.name =~ '(?i)#{query}'"

    ## This gives you a list of tag queries, either inclusive or exclusive, then takes off the first operator so it can be matched ##
    iTags = R.reduce(((acc, tag) -> acc + "XOR '#{tag}' in a.tags "), "", tags).substring(4)
    eTags = R.reduce(((acc, tag) -> acc + "AND '#{tag}' in a.tags "), "", tags).substring(4)

    nReturn = "{name:a.name, label:labels(a)[0], id:id(a)}, {name:b.name, label:labels(b)[0], id:id(b)}"
    lReturn = "{source:id(a), target:id(b), type:type(r)} as links"

    if tags.length > 0 and index and query
      rows = Neo4j.query "MATCH #{nIndex} WHERE #{eTags} AND #{name} AND #{notJ} RETURN DISTINCT #{nReturn}"
      ## Gets all nodes, flattens them into one array, returns new array with only unique nodes ##
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lIndex} WHERE #{eTags} AND #{name} AND #{notJ} RETURN #{lReturn}"
      ## TODO this is the part I need to change for the purposes of updating D3 ##
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and index and not query
      rows = Neo4j.query "MATCH #{nIndex} WHERE #{iTags} AND #{notJ} RETURN DISTINCT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lIndex} WHERE #{iTags} AND #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and query and not index
      rows = Neo4j.query "MATCH #{nXIndex} WHERE #{eTags} AND #{name} AND #{notJ} RETURN DISTCINT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lXIndex} WHERE #{eTags} AND #{name} AND #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if tags.length > 0 and not query and not index
      rows = Neo4j.query "MATCH #{nXIndex} WHERE #{iTags} AND #{notJ} RETURN DISTINCT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lXIndex} WHERE #{iTags} AND #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if index and not tags.length > 0 and not query
      rows = Neo4j.query "MATCH #{nIndex} WHERE #{notJ} RETURN DISTINCT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lIndex} WHERE #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if index and query and not tags.length > 0
      rows = Neo4j.query "MATCH #{nIndex} WHERE #{name} AND #{notJ} RETURN DISTINCT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lIndex} WHERE #{name} AND #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes }

    if query and not tags.length > 0 and not index
      rows = Neo4j.query "MATCH #{nXIndex} WHERE #{name} AND #{notJ} RETURN DISTINCT #{nReturn}"
      nodes = R.uniqWith((a,b) -> a.id is b.id)(R.flatten(rows))

      linkIds = Neo4j.query "MATCH #{lXIndex} WHERE #{name} AND #{notJ} RETURN #{lReturn}"
      links = createLinks linkIds, R.pluck('id')(nodes)

      return graph = { links:links, nodes:nodes}

  getGraph: () ->
    ## Returns all data in the graph ##
    nodes = Neo4j.query "MATCH (a) WHERE NOT labels(a)[0] = 'Jurisdiction' RETURN {name:a.name, label:labels(a)[0], id:id(a)} as nodes"

    linkIds = Neo4j.query "MATCH (a)-[r]->(b) WHERE NOT labels(a)[0] = 'Jurisdiction' AND NOT labels(b)[0] = 'Jurisdiction' RETURN {source:id(a), target:id(b), type:type(r)} as links"

    ## createLinks takes in a link with ids and the full node list, then converts it to something that D3 can use: array indeces
    links = createLinks linkIds, R.pluck('id')(nodes)

    return graph = { links:links, nodes:nodes }

  getTags: -> Neo4j.query "MATCH (a) UNWIND a.tags AS x RETURN DISTINCT x"

  createNode: (label, name, tags) -> Neo4j.query "MERGE (a:#{label} {name:'#{name}'})"

  getNodes: (query) -> Neo4j.query "MATCH (a) WHERE a.name =~ '(?i)#{query}.+' RETURN DISTINCT {name:a.name} as nodes"

  getLinkTypes: -> Neo4j.query "MATCH ()-[r]-() RETURN DISTINCT type(r)"

  createLink: (source, type, target) -> Neo4j.query "MATCH (a {name:'#{source}'}) MATCH (b {name:'#{target}'}) MERGE (a)-[r:#{type}]-(b)"
