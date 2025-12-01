//
//  Solution.swift
//  Day 01
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

func parse(_ line: any StringProtocol) -> Int {
  let line = String(line)
  let direction = String(line.first!)
  let amount = Int(String(line.dropFirst()))!
  return direction == "R" ? amount : -1 * amount
}

enum Part1 {
  static let dial = 0 ... 99
  static func run(_ source: InputData) {
    var zeroCount = 0
    var arrow = 50

    for turn in source.lines.map(parse) {
      let next = (arrow + turn + dial.count) % dial.count
      if next == 0 {
        zeroCount += 1
      }
      arrow = next
    }

    print("Part 1 (\(source)): \(zeroCount)")
  }
}

// MARK: - Part 2

enum Part2 {
    static func run(_ source: InputData) {
        print("Part 2 (\(source)): TODO")
    }
}
