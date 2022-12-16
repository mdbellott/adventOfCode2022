import Foundation

//
// --- Day 9: Rope Bridge ---
//

// MARK: - Input

let input = try Input.12.load(as: [String].self)

// MARK: - Helpers 1

struct Pos: Hashable {
  let x: Int
  let y: Int
}

func findStartAndEnd(_ chart: [[Character]]) -> (Pos, Pos) {
  var start = Pos(x: -1, y: -1)
  var end = Pos(x: -1, y: -1)
  for y in 0..<chart.count {
    for x in 0..<chart[y].count {
      if chart[y][x] == "S" { start = Pos(x: x, y: y) }
      if chart[y][x] == "E" { end = Pos(x: x, y: y) }
    }
  }
  return (start, end)
}

func isTraverable(_ start: Character, _ end: Character, _ inverted: Bool) -> Bool {
  var start = start
  var end = end
  if start == "S" { start = "a" }
  if start == "E" { start = "z" }
  if end == "S" { end = "a" }
  if end == "E" { end = "z" }
  
  guard let startAscii = start.asciiValue,
        let endAscii = end.asciiValue else { return false }
  
  let startHeight = (Int(startAscii) - 96)
  let endHeight = (Int(endAscii) - 96)
  // Part 2
  if inverted { return (startHeight - endHeight) < 2 }
  // Part 1
  else { return (endHeight - startHeight) < 2 }
}

func traversableNeighbors(from: Pos, _ chart: [[Character]], _ visited: Set<Pos>, _ inverted: Bool) -> [Pos] {
  guard !chart.isEmpty else { return [] }
  
  var neighbors = [Pos]()
  let val = chart[from.y][from.x]
  let height = chart.count - 1
  let width = chart[0].count - 1
  
  // Left
  if from.x > 0 {
    let to = Pos(x: from.x-1, y: from.y)
    let toVal = chart[to.y][to.x]
    if !visited.contains(to),
        isTraverable(val, toVal, inverted) { neighbors.append(to) }
  }
  // Right
  if from.x < width {
    let to = Pos(x: from.x+1, y: from.y)
    let toVal = chart[to.y][to.x]
    if !visited.contains(to),
        isTraverable(val, toVal, inverted) { neighbors.append(to) }
  }
  // Down
  if from.y > 0 {
    let to = Pos(x: from.x, y: from.y-1)
    let toVal = chart[to.y][to.x]
    if !visited.contains(to),
        isTraverable(val, toVal, inverted) { neighbors.append(to) }
  }
  // Up
  if from.y < height {
    let to = Pos(x: from.x, y: from.y+1)
    let toVal = chart[to.y][to.x]
    if !visited.contains(to),
        isTraverable(val, toVal, inverted) { neighbors.append(to) }
  }
  
  return neighbors
}

// Djikstra
func traverse(_ chart: [[Character]], start: Pos, end: Pos, options: [Pos] = []) -> Int {
  
  var distance = chart.map { $0.map { _ in Int.max } }
  var visited = Set<Pos>()
  var toVisit = Set<Pos>()
  
  distance[start.y][start.x] = 0
  visited.insert(start)
  toVisit.insert(start)
  
  var current = start
  while !toVisit.isEmpty {
    toVisit.remove(current)
    visited.insert(current)
    
    for neighbor in traversableNeighbors(from: current, chart, visited, !options.isEmpty) {
      let dist = distance[current.y][current.x] + 1
      if dist < distance[neighbor.y][neighbor.x] {
        distance[neighbor.y][neighbor.x] = dist
        toVisit.insert(Pos(x: neighbor.x, y: neighbor.y))
        visited.remove(Pos(x: neighbor.x, y: neighbor.y))
      }
    }
    
    if let next = toVisit.min(by: { distance[$0.y][$0.x] < distance[$1.y][$1.x] }) {
      current = next
    }
  }
  
  if !options.isEmpty {
    // Part 2
    var shortest = Int.max
    for opt in options { shortest = min(shortest, distance[opt.y][opt.x]) }
    return shortest
  } else {
    // Part 1
    return distance[end.y][end.x]
  }
}


// MARK: - Solution 1

//func Solution1(_ input: [String]) -> Int {
//  let chart: [[Character]] = input.map { Array<Character>($0) }.filter { !$0.isEmpty }
//  let startEnd = findStartAndEnd(chart)
//  return traverse(chart, start: startEnd.0, end: startEnd.1)
//}
//
//Solution1(input)

//
//  --- Part Two ---
//

// MARK: - Helpers 2

func findStartAndEndOptions(_ chart: [[Character]]) -> (Pos, Pos, [Pos]) {
  var start = Pos(x: -1, y: -1)
  var end = Pos(x: -1, y: -1)
  var options = [Pos]()
  for y in 0..<chart.count {
    for x in 0..<chart[y].count {
      if chart[y][x] == "S" { end = Pos(x: x, y: y) }
      if chart[y][x] == "a" { options.append(Pos(x: x, y: y)) }
      if chart[y][x] == "E" { start = Pos(x: x, y: y) }
    }
  }
  return (start, end, options)
}

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  let chart: [[Character]] = input.map { Array<Character>($0) }.filter { !$0.isEmpty }
  // Invert the search
  let startEndOptions = findStartAndEndOptions(chart)
  // Find the shortest option
  return traverse(chart, start: startEndOptions.0, end: startEndOptions.1, options: startEndOptions.2)

}

Solution2(input)
