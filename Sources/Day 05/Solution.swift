//
//  Solution.swift
//  Day 05
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
  static func parse(_ lines: [String]) -> (ranges: [ClosedRange<Int>], availableIds: [Int]) {
    let parts = lines.split(separator: "")
    let ranges: [ClosedRange<Int>] = parts[0].reduce(into: []) { result, line in
      let numbers = line.components(separatedBy: "-").compactMap(Int.init)
      result.append(numbers[0] ... numbers[1])
    }
    let availableIds = parts[1].compactMap(Int.init)
    return (ranges, availableIds)
  }

  static func run(_ source: InputData) {
    let (ranges, availableIds) = parse(source.lines)
    let available = availableIds.count { id in
      for range in ranges {
        if range.contains(id) {
          return true
        }
      }
      return false
    }
    print("Part 1 (\(source)): \(available)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    var ranges = Part1.parse(source.lines)
      .ranges
      .sorted { $0.lowerBound < $1.lowerBound }
    var keepGoing = true
    while keepGoing {
      keepGoing = false
      for index in ranges.indices.dropLast() {
        if ranges[index].overlaps(ranges[index + 1]) {
          ranges[index] = ranges[index].lowerBound ... max(ranges[index].upperBound, ranges[index + 1].upperBound)
          ranges.remove(at: index + 1)
          keepGoing = true
          break
        }
      }
    }
    let count = ranges.reduce(0) { $0 + $1.count }
    print("Part 2 (\(source)): \(count)")
  }
}
