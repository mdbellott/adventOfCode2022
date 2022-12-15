import Foundation

//
// --- Day 1: Calorie Counting ---
//

// MARK: - Input

let input = try Input.01.load(as: [String].self)

// MARK: - Solution 1

func Solution1(_ input: [String]) -> Int {
  var result = 0
  var current = 0
  for i in 0..<input.count {
    if input[i] == "" {
      result = max(result, current)
      current = 0
    } else {
      current += Int(input[i]) ?? 0
    }
  }
  return result
}

Solution1(input)

//
// --- Part Two ---
//

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  var top3 = [Int]()
  var current = 0
  for i in 0..<input.count {
    if input[i] == "" {
      if top3.count < 3 {
        top3.append(current)
        top3.sort()
      } else if top3[0] < current {
        top3[0] = current
        top3.sort()
      }
      current = 0
    } else {
      current += Int(input[i]) ?? 0
    }
  }
  return top3[0] + top3[1] + top3[2]
}

Solution2(input)
