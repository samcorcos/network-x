
# filter by tags

# figure out the "expand-by-one" option

# get more data onto nodes for click event to display with popover

# To Do

- [x] bootstrap some fake data into neo4j
  - [ ] figure out the best way to add crimes to database (as a node, or as a property on an edge?)
- [x] ability to add data
  - [x] with labels
  - [ ] ability to add labels after-the-fact
- [ ] search
  - [x] tags
    - [x] get rid of hardcoded tags
    - [x] filter by tags
    - [ ] tags need to be inclusive, not exclusive
  - [x] names
  - [x] types
  - [ ] custom/advanced queries
    - [ ] clustering? interesting algorithms?
    - [ ] shortest path between two nodes
    - [ ] largest clique
- [ ] results
  - [ ] limit results and show warning
  - [ ] ...allow someone to display all data requested if they want to
- [x] d3 graph
  - [ ] click to show details
  - [ ] click on a button to fetch more from that node and add to the graph or remove node from graph
  - [ ] display link type on graph
  - [ ] get data to update responsively (rather than the current hack)
  - [ ] implement zoom and pan
  - [ ] resize nodes based on sqrt of incoming connections and weight of those connections




figure out "expand-by-one" option on click

shortest path between two nodes?

get more data into nodes (description) for popover display

#TODO

1. Simplify queries in methods using Ramda and map reduce
2. Iterate over tags array parameter to make tag queries inclusive rather than exclusive
3. Change the "create links" and "create nodes" to be global within the scope of D3
  1. Then, create new functions that manipulate these arrays rather than destroy them and create new ones

Doing this will solve: 1) The D3 update problem, 2) The tags problem, 3) The reusability of methods with inputs

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
