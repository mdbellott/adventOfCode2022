import Foundation

//
// --- Day 9: Rope Bridge ---
//

// MARK: - Input

let input = try Input.11.load(as: [String].self)

// MARK: - Helpers 1

enum Operation {
  case Add(a: Int)
  case Mult(m: Int)
  case Square
  
  func execute(_ old: Int) -> Int {
    switch self {
      case let .Add(a): return old + a
      case let .Mult(m): return old * m
      case .Square: return old * old
    }
  }
}

struct Test {
  let div: Int
  let trueThrow: Int
  let falseThrow: Int
  
  func executeThrow(_ val: Int) -> Int {
    return val % div == 0 ? trueThrow : falseThrow
  }
}

struct Monkey {
  var name: Int
  var items: [Int]
  
  var operation: Operation
  var test: Test
  
  var business: Int = 0
}

func parseMonkeys(input: [String]) -> [Monkey] {
  var result = [Monkey]()

  var i = 0
  while i < input.count {
    let info = input[i].components(separatedBy: " ").filter { !$0.isEmpty }
    
    guard !info.isEmpty else {
      i += 1
      continue
    }

    // New Monkey
    if info[0] == "Monkey" {
      
      var name = Int(info[1].trimmingCharacters(in: CharacterSet(charactersIn:":")))
      var items: [Int]?
      var operation: Operation?
      var test: Test?
      
      // Parse Monkey
      var parsingMonkey = true
      while parsingMonkey {
        i += 1
        let monkeyInfo = input[i].components(separatedBy: " ").filter { !$0.isEmpty }
        
        // Items
        if monkeyInfo[0] == "Starting" {
          var tmp = [Int]()
          for j in 2..<monkeyInfo.count {
            tmp.append(
              Int(monkeyInfo[j]
                .trimmingCharacters(in: CharacterSet(charactersIn: ","))
              ) ?? -1)
          }
          items = tmp
        }
        
        //Operation
        else if monkeyInfo[0] == "Operation:" {
          if monkeyInfo[3] == "old" && monkeyInfo[5] == "old" { operation = .Square }
          else if monkeyInfo[4] == "*", let val = Int(monkeyInfo[5]) { operation = .Mult(m: val) }
          else if monkeyInfo[4] == "+", let val = Int(monkeyInfo[5]) { operation = .Add(a: val) }
        }
        
        // Test
        else if monkeyInfo[0] == "Test:" {
          let trueInfo = input[i+1].components(separatedBy: " ").filter { !$0.isEmpty }
          let falseInfo = input[i+2].components(separatedBy: " ").filter { !$0.isEmpty }
          if let div = Int(monkeyInfo[3]), let trueThrow = Int(trueInfo[5]), let falseThrow = Int(falseInfo[5]) {
            test = Test(div: div, trueThrow: trueThrow, falseThrow: falseThrow)
            i+=2
            parsingMonkey = false
          }
        }
        
        // Invalid Input
        else { parsingMonkey = false }
      }
      
      // Build Monkey
      if let mName = name, let mItems = items, let mOperation = operation, let mTest = test {
        result.append(Monkey(name: mName, items: mItems, operation: mOperation, test: mTest))
      }
    }
    
    i += 1
  }
  
  return result
}

func monkeyBusiness(_ monkeys: [Monkey], _ rounds: Int, _ lcmMod: Int? = nil) -> Int {
  var monkeys = monkeys
  
  for _ in 0..<rounds {
    for m in 0..<monkeys.count {
      var monkey = monkeys[m]
      
      // Inspect Items
      for item in monkey.items {
        
        // Run operation and test
        let updated: Int
        // Part 2
        if let lcm = lcmMod { updated = monkey.operation.execute(item) % lcm }
        // Part 1
        else { updated = monkey.operation.execute(item) / 3}
        
        let dest = monkey.test.executeThrow(updated)
        
        // Throw the item
        var destMonkey = monkeys[dest]
        destMonkey.items.append(updated)
        monkeys[dest] = destMonkey
        
        // Update monkey business
        monkey.business += 1
      }
      
      // All items have been thrown
      monkey.items.removeAll()
      monkeys[m] = monkey
    }
  }
  
  // Calculate Monkey Business
  var business = (monkeys.map { $0.business }).sorted { $0 > $1 }
  guard business.count > 2 else { return -1 }
  return business[0] * business[1]
}

// MARK: - Solution 1

func Solution1(_ input: [String]) -> Int {
  let monkeys = parseMonkeys(input: input)
  return monkeyBusiness(monkeys, 20)
}

Solution1(input)

//
//  --- Part Two ---
//

// MARK: - Helpers 2

func findLCM(_ monkeys: [Monkey]) -> Int {
  var lcm = 1
  monkeys.map { lcm *= $0.test.div }
  return lcm
}

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  let monkeys = parseMonkeys(input: input)
  let lcm = findLCM(monkeys)
  return monkeyBusiness(monkeys, 10000, lcm)
}

Solution2(input)
