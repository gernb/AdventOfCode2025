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
    var invalidIds: [Int] = []

    // brute force
    for range in Part1.parse(source.data) {
      for idNum in range {
        let id = String(idNum)
        let halfLen = id.count / 2
        guard Set(Array(id)).count <= halfLen else { continue }
        var subIdLen = 1
        while subIdLen <= halfLen {
          defer { subIdLen += 1 }
          guard id.count.isMultiple(of: subIdLen) else { continue }
          let subIds = id.split(len: subIdLen)
          if subIds.allSatisfy({ $0 == subIds[0] }) {
            invalidIds.append(idNum)
            break
          }
        }
      }
    }

    let result = invalidIds.reduce(0, +)
    print("Part 2 (\(source)): \(result)")
  }
}

extension String {
  func split(len: Int) -> [Substring] {
    var result: [Substring] = []
    var start = 0
    while start < count {
      result.append(self.dropFirst(start).prefix(len))
      start += len
    }
    return result
  }
}
