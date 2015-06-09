@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person
  searchPeople: (name, others...) ->
    return Neo4j.query "MATCH (a:Person {name:'#{name}'}) RETURN (a)"

  # A method to search :Company
  searchCompany: (name, industry, others...) ->
    # Matches all companies that contain the proper name
    return Neo4j.query "MATCH (a:Company {name:'#{name}'}) RETURN (a)" if name

    # Matches all companies that contain the industry
    return Neo4j.query "MATCH (a:Company) WHERE '#{industry}' IN a.industry RETURN (a)" if industry

  getGraph: () ->
    # Returns all data in the graph
    x = Neo4j.query "MATCH (a)-[r]->(b) RETURN (a),type(r),(b)"
    y = createLinks(x[0], x[1], x[2])
    return y
