@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person
  searchPeople: (name, others...) ->
    Neo4j.query "MATCH (a:Person {name:#{name}}) RETURN (a)"

  searchCompany: (name, industry, others...) ->
    # Matches all companies that contain the proper name
    Neo4j.query "MATCH (a:Company {name:'#{name}'}) RETURN (a)"

    # Matches all companies that contain the industry
    # Neo4j.query "MATCH (a:Company) WHERE '#{industry}' IN a.industry RETURN (a)" if industry
