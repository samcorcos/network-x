@createLinks = (linkIds, nodeArray) ->
  findIndex = (link) ->
    ## For each node in the node array, replace the target and source with the index ##
    temp = link
    for nodeId,i in nodeArray
      temp.weight = 1
      if link.source == nodeId then temp.source = i
      if link.target == nodeId then temp.target = i
    return temp
  R.map(findIndex, linkIds)
