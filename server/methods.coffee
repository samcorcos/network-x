@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person
  searchPeople: (name, others...) ->
    return Neo4j.query "MATCH (a:Person {name:'#{name}'}) RETURN a" if name

  # A method to search :Company
  searchCompany: (name, industry, others...) ->
    # Matches all companies that contain the proper name
    return Neo4j.query "MATCH (a:Company {name:'#{name}'}) RETURN a" if name

    # Matches all companies that contain the industry
    return Neo4j.query "MATCH (a:Company) WHERE '#{industry}' IN a.industry RETURN a" if industry

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
