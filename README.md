
# filter by tags

# figure out the "expand-by-one" option

# get more data onto nodes for click event to display with popover

# To Do

- [x] bootstrap some fake data into neo4j
  - [ ] figure out the best way to add crimes to database (as a node, or as a property on an edge?)
- [ ] ability to add data
  - [ ] with labels
  - [ ] ability to add labels after-the-fact
- [ ] search
  - [x] tags
    - [x] get rid of hardcoded tags
    - [ ] filter by tags
  - [x] names
  - [x] types
  - [ ] custom/advanced queries
    - [ ] shortest path between two nodes
    - [ ] largest clique
- [ ] results
  - [ ] if more than N results, show in a list
  - [ ] else show in a graph
  - [ ] how exactly is this data presented?
- [x] d3 graph
  - [ ] hover to show details
  - [ ] click on a button to fetch more from that node and add to the graph
  - [ ] display link type on graph
  - [ ] get data to update responsively (rather than the current hack)


get live filtering working to allow for links

filter by tags

figure out "expand-by-one" option on click

get more data into nodes (description) for popover display




# Getting Started

Install and setup Neo4j

    brew install neo4j
    npm install -g neo4j

Then start Neo4j and start Meteor

    neo4j start
    meteor

You should be able to see the Neo4j browser at the Neo4j url (default: http://localhost:7474/).

When you're done, be sure to stop Neo4j as well

    neo4j stop

To reset Neo4j, delete `data/graph.db`. If you used brew to install Neo4j, then the path will be similar to the following:

    rm -rf /usr/local/Cellar/neo4j/2.1.7/libexec/data/graph.db

Or you can use the following queries to delete all relationships and all nodes

    match ()-[r]->(), (n) delete r,n
