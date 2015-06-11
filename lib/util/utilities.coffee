## Refactoring createLinks to use path.

@createLinks = (x, y) ->
  linksArray = []
  # iterates over all of the links
  for nodeId,i in x[0]
    temp = {}
    # iterates over all nodes in node array to get source
    for nodeKey,ii in y
      if x[0][i] is nodeKey
        temp.source = ii
        break
    # iterates over all nodes in node array to get target
    for nodeKey,jj in y
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

@removeDuplicates = (array1, array2) ->
  idArray = []
  reduced = []
  combined = array1.concat(array2)
  for obj in combined
    if idArray.indexOf(obj.id) is -1
      idArray.push obj.id
      reduced.push obj
  return reduced
