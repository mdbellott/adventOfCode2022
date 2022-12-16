import Foundation

//
// --- Day 10: Cathode-Ray Tube ---
//

// MARK: - Input

let input = try Input.10.load(as: [String].self)

// MARK: - Helpers 1

func measureSignals(_ instructions: [String], _ significant: Set<Int>) -> Int {
  var cycle = 0
  var value = 1
  var result = 0
  
  for line in instructions {
    let instruction = line.components(separatedBy: " ")
    guard !instruction.isEmpty && !instruction[0].isEmpty else { continue }
    
    cycle += 1
    if significant.contains(cycle) { result += (cycle * value)}
    
    if instruction[0] == "addx" {
      guard let amt = Int(instruction[1]) else { continue }
      
      cycle += 1
      if significant.contains(cycle) { result += (cycle * value) }
      
      value += amt
    }
  }
  
  return result
}

// MARK: - Solution 1

func Solution1(_ input: [String]) -> Int {
  return measureSignals(input, [20, 60, 100, 140, 180, 220])
}

Solution1(input)

//
//  --- Part Two ---
//

// MARK: - Helper 2

func updateAndDrawRow(_ value: Int, _ cycle: Int, _ row: inout String) {
  let pixel = (cycle % 40) != 0 ? (cycle % 40) - 1 : 39
  row += abs(pixel - value) <= 1 ? "#" : "."

  if pixel == 39 {
    print(row)
    row = ""
  }
}

func drawPixels(_ instructions: [String]){
  var cycle = 0
  var value = 1
  var row = ""
  
  for line in instructions {
    let instruction = line.components(separatedBy: " ")
    guard !instruction.isEmpty && !instruction[0].isEmpty else { continue }
    
    // Start Cyle
    cycle += 1
    updateAndDrawRow(value, cycle,  &row)
    
    // During Cycle
    if instruction[0] == "addx" {
      guard let amt = Int(instruction[1]) else { continue }
      
      cycle += 1
      updateAndDrawRow(value, cycle, &row)
      
      // End of Cylce
      value += amt
    }
  }
}


// MARK: - Solution 2

func Solution2(_ input: [String]) {
  print("CRT Render")
  drawPixels(input)
}

Solution2(input)
