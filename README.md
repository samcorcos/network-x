# To Do

- [x] bootstrap some fake data into neo4j
  - [ ] figure out the best way to add crimes to database (as a node, or as a property on an edge?)
- [x] ability to add data
  - [x] with labels
  - [ ] ability to add labels after-the-fact
- [ ] search
  - [ ] needs special filter for Jurisdiction
  - [x] tags
    - [x] get rid of hardcoded tags
    - [x] filter by tags
    - [x] tags need to be inclusive, not exclusive—but only in certain circumstances
      - [x] searches with a name query should be exclusive
      - [x] searches without a name query should be inclusive
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
- [ ] Add some kind of loading screen while query is taking place? Maybe this won't be necessary once we figure out responsive updating...

figure out "expand-by-one" option on click

shortest path between two nodes?

get more data into nodes (description) for popover display

#TODO June 20th

1. ~~Special filter for Jurisdiction (exclusive filter)~~
2. Make a filter in the side nav to filter out jurisdictions. All should start out checked. Then, inclusive filter.
3. Change the "create links" and "create nodes" to be global within the scope of D3
  1. Then, create new functions that manipulate these arrays rather than destroy them and create new ones
4. Have all tags start out as checked, then use inclusive filter.

Doing this will solve: 1) The D3 update problem, 2) The tags problem, 3) The reusability of methods with inputs
