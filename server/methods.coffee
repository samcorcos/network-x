@Neo4j = new Neo4jDB()
stringify = Neo4j.stringify.bind(Neo4j)

Meteor.methods
  # A method to search :Person. By default, returns one degree of separation.
  searchPeople: (name, others...) ->
    # Matches any :Person node with the name inputted (case sensitive, not fuzzy)
    # Since it's returning (a) and (b), it will return a duplicate of (a) for every match with (b)
    # so we need to reduce it and get rid of duplicates.

    # First, I'm going to do it the lazy way, which consists of multiple server calls
    aNodes = Neo4j.query "MATCH (a:Person {name:'#{name}'})-[r]-(b) RETURN a,labels(a),id(a)"
    bNodes = Neo4j.query "MATCH (a:Person {name:'#{name}'})-[r]-(b) RETURN b,labels(b),id(b)"



    ###

    Solving for just one person - not allowing for multiple with the same name for this iteration.

    1. Find Person A and everyone he's connected to:  MATCH (a:Person {name:'#{name}'})-[r]-(b)
    2.

    Get the ids of all the nodes in the network

    ###


    x = Neo4j.query "MATCH (a:Person {name:'#{name}'})-[r]-(b) RETURN a,b,r" if name

    # Utility function that removes duplicates. Lives in utilities.coffee

    # I need (a) with labels and id, as well as (b) with labels and id

    # You create nodes after you've removed duplicates because you want a list of all unique nodes

    # You create links with the list before

    # return removeDuplicates(x)

  # A method to search :Company
  searchCompany: (name, industry, others...) ->
    # Matches all companies that contain the proper name
    if name
      x = Neo4j.query "MATCH (a:Company {name:'#{name}'})--(b) RETURN a,b"
      return removeDuplicates(x[0], x[1])

    # Matches all companies that contain the industry
    if industry
      x = Neo4j.query "MATCH (a:Company)--(b) WHERE '#{industry}' IN a.industry RETURN a,b"
      return removeDuplicates(x[0], x[1])

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
