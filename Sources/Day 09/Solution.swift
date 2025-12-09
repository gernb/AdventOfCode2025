//
//  Solution.swift
//  Day 09
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct Coordinate: Hashable, CustomStringConvertible {
  var x: Int
  var y: Int

  var description: String { "(\(x), \(y))" }
}
extension Coordinate {
  // 7,1
  init(string: any StringProtocol) {
    let numbers = string.components(separatedBy: ",").compactMap(Int.init)
    self.init(x: numbers[0], y: numbers[1])
  }
}

struct Pair<T>: Hashable where T: Hashable {
  let a: T
  let b: T
}
extension Pair where T == Coordinate {
  var area: Int {
    (1 + abs(a.x - b.x)) * (1 + abs(a.y - b.y))
  }
}

enum Part1 {
  static func run(_ source: InputData) {
    let squares = source.lines.map(Coordinate.init(string:))
    let areas: [Pair<Coordinate>: Int] = squares.indices.reduce(into: [:]) { result, index in
      let a = squares[index]
      for b in squares.dropFirst(index + 1) {
        let pair = Pair(a: a, b: b)
        result[pair] = pair.area
      }
    }
    let largest = areas.max { $0.value < $1.value }!
    print("Part 1 (\(source)): \(largest.value)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
