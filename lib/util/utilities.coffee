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

# @getUnique = (value, index, self) ->
#   self.indexOf(value) == index
#
# @removeDuplicates = (array1, array2) ->
#   idArray = []
#   reduced = []
#   combined = array1.concat(array2)
#   for obj in combined
#     if idArray.indexOf(obj.id) is -1
#       idArray.push obj.id
#       reduced.push obj
#   return reduced
