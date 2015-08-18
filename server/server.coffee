Meteor.startup ->
  neo4jUsername = Meteor.settings.neo4j.username
  neo4jPassword = Meteor.settings.neo4j.password

  Neo4j = new Neo4jDB("http://#{neo4jUsername}:#{neo4jPassword}@networkx.sb05.stations.graphenedb.com:24789")
  stringify = Neo4jDB.stringify.bind(Neo4j)
