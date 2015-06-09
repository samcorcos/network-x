@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person
  searchPeople: (name, others...) ->
    return Neo4j.query "MATCH (a:Person {name:'#{name}'}) RETURN (a)"

  # A method to search :Company
  searchCompany: (name, industry, others...) ->

    console.log name, industry

    # Matches all companies that contain the proper name
    return Neo4j.query "MATCH (a:Company {name:'#{name}'}) RETURN (a)" if name

    # Matches all companies that contain the industry
    return Neo4j.query "MATCH (a:Company) WHERE '#{industry}' IN a.industry RETURN (a)" if industry

  # Mathes all people
  findPeople: () ->
    console.log Neo4j.query "MATCH (a:Person) RETURN (a)"
