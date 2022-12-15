import Foundation

//
//  --- Day 8: Treetop Tree House ---
//

// MARK: - Input

let input = try Input.08.load(as: [String].self)

// MARK: - Helpers 1

func detectVisibleTrees(input: [String]) -> Int {
  let grid = input.map { $0.map { Int(String($0)) ?? -1 } }
  let width = grid[0].count
  let height = grid.count - 1
  
  var visible = Set<String>()
  var currentMax = -1
  
  func checkTree(_ row: Int, _ col: Int) {
    let treeID: String = "\(row):\(col)"
    if grid[row][col] > currentMax {
      visible.insert(treeID)
      currentMax = grid[row][col]
    }
  }
  
  for row in 0..<height {
    currentMax = -1
    for col in 0..<width { checkTree(row, col) }
    
    currentMax = -1
    for col in (0..<width).reversed() { checkTree(row, col) }
  }
  
  for col in 0..<width {
    currentMax = -1
    for row in 0..<height { checkTree(row, col) }
    
    currentMax = -1
    for row in (0..<height).reversed() { checkTree(row, col) }
  }

  return visible.count
}

// MARK: - Solution 1

func Solution1(_ input: [String]) -> Int {
  return detectVisibleTrees(input: input)
}

Solution1(input)

//
//  --- Part Two ---
//

// MARK: - Helper 2

func maxVisibleTrees(input: [String]) -> Int {
  let grid = input.map { Array<Character>($0) }
  let width = grid[0].count
  let height = grid.count - 1
  
  var maxTrees = 0
  for row in 1..<height-1 {
    for col in 1..<width-1 {
      var count = 0, score = 1;
      let current = grid[row][col]
      
      // Up
      for i in (0..<row).reversed() {
        count += 1
        if grid[i][col] >= current { break }
      }
      score *= count
      count = 0
      
      // Down
      for i in (row+1..<height) {
        count += 1
        if grid[i][col] >= current { break }
      }
      score *= count
      count = 0
      
      // Left
      for j in (0..<col).reversed() {
        count += 1
        if grid[row][j] >= current { break }
      }
      score *= count
      count = 0
      
      // Down
      for j in (col+1..<width) {
        count += 1
        if grid[row][j] >= current { break }
      }
      score *= count
      count = 0
      
      maxTrees = max(maxTrees, (score))
    }
  }

  return maxTrees
}

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  return maxVisibleTrees(input: input)
}

Solution2(input)

