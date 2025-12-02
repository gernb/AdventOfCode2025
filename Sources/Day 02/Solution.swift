//
//  Solution.swift
//  Day 02
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
  static func parse(_ line: String) -> [ClosedRange<Int>] {
    line.components(separatedBy: ",")
      .map {
        let numbers = $0.components(separatedBy: "-").compactMap(Int.init)
        return numbers[0] ... numbers[1]
      }
  }

  static func run(_ source: InputData) {
    var invalidIds: [Int] = []

    // brute force
    for range in parse(source.data) {
      for idNum in range {
        let id = String(idNum)
        guard id.count.isMultiple(of: 2) else { continue }
        let halfLen = id.count / 2
        if id.prefix(halfLen) == id.suffix(halfLen) {
          invalidIds.append(idNum)
        }
      }
    }

    let result = invalidIds.reduce(0, +)
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
