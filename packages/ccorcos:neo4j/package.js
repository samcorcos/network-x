Package.describe({
  name: 'ccorcos:neo4j',
  summary: 'Neo4j API for Meteor',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'coffeescript', 
    'http',
    'kevohagan:ramda'
  ], 'server');
  api.addFiles('src/driver.coffee', 'server');
  api.export('Neo4jDB')
});
