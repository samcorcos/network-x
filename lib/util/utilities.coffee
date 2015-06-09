@createLinks = (a, r, b) ->
  # The final links array must be in this format: var links = [{ source: 0, target: 1 }];
  linksArray = []

  # Must have the properties "source", "target", and "type": a is the source, r the type, and b is the target
  # They will, by definition, have the same number of items in each array

  for nodeA, i in a
    temp =
      source: a[i]
      target: b[i]
      type: r[i]
    linksArray.push temp

  return linksArray
