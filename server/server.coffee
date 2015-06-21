Meteor.startup ->
  neo4jUsername = Meteor.settings.neo4j.username
  neo4jPassword = Meteor.settings.neo4j.password
  process.env.GRAPHENEDB_URL = "http://#{neo4jUsername}:#{neo4jPassword}@networkx.sb05.stations.graphenedb.com:24789"
  console.log process.env
