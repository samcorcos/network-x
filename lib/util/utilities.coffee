@createLinks = (x, y) ->
  linksArray = []
  console.log x,y
  # iterates over all of the links
  for nodeId,i in x[0]
    temp = {}
    # iterates over all nodes in node array to get source
    for nodeKey,ii in y
      console.log nodeKey, "nodekey1"
      if x[0][i] is nodeKey
        temp.source = ii
        break
    # iterates over all nodes in node array to get target
    for nodeKey,jj in y
      console.log nodeKey, "nodekey2"
      if x[2][i] is nodeKey
        temp.target = jj
        break
    linksArray.push temp
  return linksArray

@createNodes = (x) ->
  nodesArray = []
  for nodeA, i in x[0]
    a = x[0][i]
    a.label = x[1][i][0]
    a.id = x[2][i]
    nodesArray.push a
  return nodesArray

@getUnique = (value, index, self) ->
  self.indexOf(value) == index
