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
  static func indexOfLargestDigit(startingAt index: Int, excluding count: Int, battery: Battery) -> Int {
    // get index of largest digit excluding the last count digits
    battery.enumerated()
      .dropFirst(index)
      .dropLast(count)
      .max { $0.element < $1.element }!
      .offset
  }

  static func run(_ source: InputData) {
    let batteries = parse(source.lines)
    let joltages = batteries.map { battery in
      var indicies: [Int] = []
      var previousIndex = -1
      for count in (0 ... 11).reversed() {
        let index = indexOfLargestDigit(startingAt: previousIndex + 1, excluding: count, battery: battery)
        indicies.append(index)
        previousIndex = index
      }
      var value = 0
      for index in indicies {
        value = value * 10 + battery[index]
      }
      return value
    }
    let result = joltages.reduce(0, +)
    print("Part 2 (\(source)): \(result)")
  }
}
