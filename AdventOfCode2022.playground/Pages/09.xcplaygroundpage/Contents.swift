import Foundation

//
// --- Day 9: Rope Bridge ---
//

// MARK: - Input

let input = try Input.09.load(as: [String].self)

// MARK: - Helpers 1

struct Pos: Hashable {
  var x: Int
  var y: Int
}

func drawPath(_ path: Set<Pos>) {
  guard let xMin = path.map({ $0.x }).min(),
        let xMax = path.map({ $0.x }).max(),
        let yMin = path.map({ $0.y }).min(),
        let yMax = path.map({ $0.y }).max() else { return }
  print("Path:")
  for y in (yMin...yMax).reversed() {
    var val = ""
    for x in xMin...xMax {
      val += path.contains(Pos(x: x, y: y)) ? "#" : "."
    }
    print(val)
  }
  print("\n\n")
}

func moveRope(
  _ dir: String,
  _ dist: Int,
  _ rope: inout [Pos]
) -> Set<Pos> {
  var tailMap = Set<Pos>()
  for _ in 0..<dist {
    // Move Head
    var head = rope[0]
    switch dir {
      case "U": head.y += 1
      case "D": head.y -= 1
      case "R": head.x += 1
      case "L": head.x -= 1
      case _: print("Invalid move")
    }
    rope[0] = head
    
    // Mpve Remaining Rope
    for i in 1..<rope.count {
      var current = rope[i]
      let last = rope[i-1]
      updateTail(last, &current)
      rope[i] = current
      if i == rope.count - 1 { tailMap.insert(current) }
    }
  }
  return tailMap
}

func updateTail(_ head: Pos, _ tail: inout Pos) {
  let x = head.x - tail.x
  let y = head.y - tail.y
  
  var xInc = 0
  var yInc = 0
  
  if abs(x) > 1 {
    xInc = x > 0 ? 1 : -1
    yInc = y
  } else if abs(y) > 1 {
    yInc = y > 0 ? 1 : -1
    xInc = x
  }
  
  tail.x += xInc
  tail.y += yInc
}

func traverse(instructions: [String], ropeLength: Int, tailMap: inout Set<Pos>) {
  var rope = Array(repeating: Pos(x: 0, y: 0), count: ropeLength)
  tailMap.insert(Pos(x: 0, y: 0))
  
  for line in instructions {
    let move = line.components(separatedBy: " ")
    guard move.count == 2,
      let dist = Int(move[1]) else { continue }
    
    tailMap = tailMap.union(moveRope(move[0], dist, &rope))
  }
}

// MARK: - Solution 1
func Solution1(_ input: [String], _ shouldDraw: Bool) -> Int {
  var result = Set<Pos>()
  traverse(instructions: input, ropeLength: 2, tailMap: &result)
  if shouldDraw { drawPath(result) }
  return result.count
}

// 6486
Solution1(input, false)

//
//  --- Part Two ---
//

// MARK: - Solution 2

func Solution2(_ input: [String], _ shouldDraw: Bool) -> Int {
  var result = Set<Pos>()
  traverse(instructions: input, ropeLength: 10, tailMap: &result)
  if shouldDraw { drawPath(result) }
  return result.count
}

// 2678
Solution2(input, false)
