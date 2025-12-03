//
//  Solution.swift
//  Day 03
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

typealias Battery = [Int]

func parse(_ lines: [String]) -> [Battery] {
  lines.map { line in
    line.map(String.init).compactMap(Int.init)
  }
}

enum Part1 {
  static func run(_ source: InputData) {
    let batteries = parse(source.lines)
    let joltages = batteries.map { battery in
      // get index of largest digit excluding the last digit
      let index = battery.enumerated()
        .dropLast()
        .max { $0.element < $1.element }!
        .offset
      // get largest digit after that one
      let value = battery.dropFirst(index + 1)
        .max { $0 < $1 }!
      return battery[index] * 10 + value
    }
    let result = joltages.reduce(0, +)
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
