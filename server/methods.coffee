@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person
  searchPeople: (name, others...) ->
    x = Neo4j.query "MATCH (a:Person {name:'#{name}'})--(b) RETURN a,b" if name
    idArray = []
    reduced = []
    combined = x[0].concat(x[1])
    for obj in combined
      if idArray.indexOf(obj.id) is -1
        idArray.push obj.id
        reduced.push obj
    return reduced

  # A method to search :Company
  searchCompany: (name, industry, others...) ->
    # Matches all companies that contain the proper name
    if name
      x = Neo4j.query "MATCH (a:Company {name:'#{name}'})--(b) RETURN a,b"
      idArray = []
      reduced = []
      combined = x[0].concat(x[1])
      for obj in combined
        if idArray.indexOf(obj.id) is -1
          idArray.push obj.id
          reduced.push obj
      return reduced

    # Matches all companies that contain the industry
    if industry
      x = Neo4j.query "MATCH (a:Company)--(b) WHERE '#{industry}' IN a.industry RETURN a,b" if industry
      idArray = []
      reduced = []
      combined = x[0].concat(x[1])
      for obj in combined
        if idArray.indexOf(obj.id) is -1
          idArray.push obj.id
          reduced.push obj
      return reduced

  getGraph: () ->
    # Returns all data in the graph
    y = Neo4j.query "MATCH (a) RETURN a,labels(a),id(a)"
    nodes = createNodes(y)

    x = Neo4j.query "MATCH (a)-[r]->(b) RETURN id(a),type(r),id(b)" # TODO if we want to add things like "date of creation", this is where we do it
    links = createLinks(x, y[2])

    graph =
      links: links
      nodes: nodes

    return graph
