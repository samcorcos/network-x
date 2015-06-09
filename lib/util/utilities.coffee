@createLinks = (x) ->
  # x is an array of 7 items

  # The final links array must be in this format: var links = [{ source: 0, target: 1 }];
  linksArray = []

  # Must have the properties "source", "target", and "type": a is the source, r the type, and b is the target
  # They will, by definition, have the same number of items in each array

  # Must run once for each item in the array, combine all "a" and "b" items, respectively, and then include the "r" type
  for nodeA, i in x[0]
    a = x[0][i]
    a.label = x[1][i][0]
    a.id = x[2][i]

    b = x[4][i]
    b.label = x[5][i][0]
    b.id = x[6][i]

    r = x[3][i]

    temp =
      source: a
      target: b
      type: r
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
