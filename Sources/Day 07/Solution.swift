//
//  Solution.swift
//  Day 07
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Square {
  case start, splitter
}

struct Coordinate: Hashable, CustomStringConvertible {
  var x: Int
  var y: Int

  var description: String { "(\(x), \(y))" }

  var up: Self { .init(x: x, y: y - 1) }
  var down: Self { .init(x: x, y: y + 1) }
  var left: Self { .init(x: x - 1, y: y) }
  var right: Self { .init(x: x + 1, y: y) }

  var neighbours: [Self] { [up, left, right, down] }
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

enum Part1 {
  static func run(_ source: InputData) {
    let diagram = parseGrid(from: source.lines) { coord, char in
      switch char {
      case "S": Square.start
      case "^": .splitter
      default: nil
      }
    }
    let start = diagram.first { $0.value == .start }!.key
    let bottom = source.lines.count - 1
    var reached: Set<Coordinate> = []
    var queue: Set<Coordinate> = [start]
    while var coord = queue.popFirst() {
      while true {
        coord = coord.down
        if coord.y == bottom { break }
        if diagram[coord] == .splitter {
          reached.insert(coord)
          queue.insert(coord.left)
          queue.insert(coord.right)
          break
        }
      }
    }
    print("Part 1 (\(source)): \(reached.count)")
  }
}

// MARK: - Part 2

@MainActor
enum Part2 {
  static var diagram: [Coordinate: Square]!
  static var bottom: Int!
  static var memo: [Coordinate: Int] = [:]

  static func split(coord: Coordinate) -> Int {
    if let value = memo[coord] {
      return value
    }

    var left = coord.left.down
    while left.y < bottom && diagram[left] != .splitter {
      left = left.down
    }
    let leftValue = left.y == bottom ? 1 : split(coord: left)

    var right = coord.right.down
    while right.y < bottom && diagram[right] != .splitter {
      right = right.down
    }
    let rightValue = right.y == bottom ? 1 : split(coord: right)

    let value = leftValue + rightValue
    memo[coord] = value
    return value
  }

  static func run(_ source: InputData) {
    diagram = parseGrid(from: source.lines) { coord, char in
      switch char {
      case "S": Square.start
      case "^": .splitter
      default: nil
      }
    }
    bottom = source.lines.count - 1
    var coord = diagram.first { $0.value == .start }!.key
    while diagram[coord] != .splitter {
      coord = coord.down
    }
    let count = split(coord: coord)
    print("Part 2 (\(source)): \(count)")
  }
}
