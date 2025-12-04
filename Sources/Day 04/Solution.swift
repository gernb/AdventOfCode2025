//
//  Solution.swift
//  Day 04
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

struct Coordinate: Hashable, CustomStringConvertible {
  var x: Int
  var y: Int

  static let origin: Self = .init(x: 0, y: 0)

  var description: String { "(\(x), \(y))" }

  var up: Self { .init(x: x, y: y - 1) }
  var down: Self { .init(x: x, y: y + 1) }
  var left: Self { .init(x: x - 1, y: y) }
  var right: Self { .init(x: x + 1, y: y) }
  var upLeft: Self { .init(x: x - 1, y: y - 1) }
  var upRight: Self { .init(x: x + 1, y: y - 1) }
  var downLeft: Self { .init(x: x - 1, y: y + 1) }
  var downRight: Self { .init(x: x + 1, y: y + 1) }

  var adjacent: [Self] { [upLeft, up, upRight, left, right, downLeft, down, downRight] }
}

func parseGrid<Tile>(from lines: [String], using builder: (Coordinate, Character) -> Tile?) -> [Coordinate: Tile] {
  lines.enumerated().reduce(into: [:]) { result, pair in
    let y = pair.offset
    result = pair.element.enumerated().reduce(into: result) { result, pair in
      let coord = Coordinate(x: pair.offset, y: y)
      result[coord] = builder(coord, pair.element)
    }
  }
}

enum Location {
  case empty, roll
}

// MARK: - Part 1

enum Part1 {
  static func run(_ source: InputData) {
    let grid: [Coordinate: Location] = parseGrid(from: source.lines) { coord, char in
      switch char {
      case ".": .empty
      case "@": .roll
      default: fatalError()
      }
    }
    let accessible = grid.filter { key, value in
      guard value == .roll else { return false }
      let adjacentRolls = key.adjacent.filter { grid[$0, default: .empty] == .roll }
      return adjacentRolls.count < 4
    }
    let result = accessible.count
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
