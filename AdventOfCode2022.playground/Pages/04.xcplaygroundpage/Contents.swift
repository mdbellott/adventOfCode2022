import Foundation

/*
 --- Day 4: Camp Cleanup ---

 Space needs to be cleared before the last supplies can be unloaded from the ships, and so several Elves have been assigned the job of cleaning up sections of the camp. Every section has a unique ID number, and each Elf is assigned a range of section IDs.

 However, as some of the Elves compare their section assignments with each other, they've noticed that many of the assignments overlap. To try to quickly find overlaps and reduce duplicated effort, the Elves pair up and make a big list of the section assignments for each pair (your puzzle input).

 For example, consider the following list of section assignment pairs:

 2-4,6-8
 2-3,4-5
 5-7,7-9
 2-8,3-7
 6-6,4-6
 2-6,4-8
 For the first few pairs, this list means:

 Within the first pair of Elves, the first Elf was assigned sections 2-4 (sections 2, 3, and 4), while the second Elf was assigned sections 6-8 (sections 6, 7, 8).
 The Elves in the second pair were each assigned two sections.
 The Elves in the third pair were each assigned three sections: one got sections 5, 6, and 7, while the other also got 7, plus 8 and 9.
 This example list uses single-digit section IDs to make it easier to draw; your actual list might contain larger numbers. Visually, these pairs of section assignments look like this:

 .234.....  2-4
 .....678.  6-8

 .23......  2-3
 ...45....  4-5

 ....567..  5-7
 ......789  7-9

 .2345678.  2-8
 ..34567..  3-7

 .....6...  6-6
 ...456...  4-6

 .23456...  2-6
 ...45678.  4-8
 Some of the pairs have noticed that one of their assignments fully contains the other. For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6. In pairs where one assignment fully contains the other, one Elf in the pair would be exclusively cleaning sections their partner will already be cleaning, so these seem like the most in need of reconsideration. In this example, there are 2 such pairs.

 In how many assignment pairs does one range fully contain the other?
 */

// MARK: - Input

let input = try Input.04.load(as: [String].self)

// MARK: - Solution 1

func Solution1(_ input: [String]) -> Int {
  var total = 0
  for pair in input {
    let task = pair.components(separatedBy: CharacterSet(charactersIn: ",-")).map { Int($0) ?? -1 }
    guard task.count == 4 else { continue }
    if (task[0] <= task[2] && task[3] <= task[1]) ||
        (task[2] <= task[0] && task[1] <= task[3]) {
      total += 1
    }
  }
  return total
}

Solution1(input)

/*
 --- Part Two ---

 As you finish identifying the misplaced items, the Elves come to you with another issue.

 For safety, the Elves are divided into groups of three. Every Elf carries a badge that identifies their group. For efficiency, within each group of three Elves, the badge is the only item type carried by all three Elves. That is, if a group's badge is item type B, then all three Elves will have item type B somewhere in their rucksack, and at most two of the Elves will be carrying any other item type.

 The problem is that someone forgot to put this year's updated authenticity sticker on the badges. All of the badges need to be pulled out of the rucksacks so the new authenticity stickers can be attached.

 Additionally, nobody wrote down which item type corresponds to each group's badges. The only way to tell which item type is the right one is by finding the one item type that is common between all three Elves in each group.

 Every set of three lines in your list corresponds to a single group, but each group can have a different badge item type. So, in the above example, the first group's rucksacks are the first three lines:

 vJrwpWtwJgWrhcsFMMfFFhFp
 jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
 PmmdzqPrVvPwwTWBwg
 And the second group's rucksacks are the next three lines:

 wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
 ttgJtRGJQctTZtZT
 CrZsJsPPZsGzwwsLwLmpwMDw
 In the first group, the only item type that appears in all three rucksacks is lowercase r; this must be their badges. In the second group, their badge item type must be Z.

 Priorities for these items must still be found to organize the sticker attachment efforts: here, they are 18 (r) for the first group and 52 (Z) for the second group. The sum of these is 70.

 Find the item type that corresponds to the badges of each three-Elf group. What is the sum of the priorities of those item types?
 */

// MARK: - Solution 2

func Solution2(_ input: [String]) -> Int {
  var total = 0
  for pair in input {
    let task = pair.components(separatedBy: CharacterSet(charactersIn: ",-")).map { Int($0) ?? -1 }
    guard task.count == 4 else { continue }
    if (task[0] <= task[2] && task[2] <= task[1]) ||
        (task[2] <= task[0] && task[0] <= task[3]) {
      total += 1
    }
  }
  return total
}

Solution2(input)
