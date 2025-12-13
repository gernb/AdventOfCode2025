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

struct IdentifiableCoordinate: Hashable, Identifiable {
  let id: UUID
  var x: Int
  var y: Int

  var up: Self { .init(x: x, y: y - 1) }
  var down: Self { .init(x: x, y: y + 1) }
  var left: Self { .init(x: x - 1, y: y) }
  var right: Self { .init(x: x + 1, y: y) }
  var upLeft: Self { .init(x: x - 1, y: y - 1) }
  var upRight: Self { .init(x: x + 1, y: y - 1) }
  var downLeft: Self { .init(x: x - 1, y: y + 1) }
  var downRight: Self { .init(x: x + 1, y: y + 1) }

  var adjacent: [Self] { [upLeft, up, upRight, left, right, downLeft, down, downRight] }

  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y
  }
}
extension IdentifiableCoordinate {
  init(x: Int, y: Int) {
    self.init(id: .init(), x: x, y: y)
  }
  init(string: any StringProtocol) {
    let numbers = string.components(separatedBy: ",").compactMap(Int.init)
    self.init(id: .init(), x: numbers[0], y: numbers[1])
  }
}

func floodFill(
  from start: IdentifiableCoordinate,
  initial filled: Set<IdentifiableCoordinate>,
  xRange: ClosedRange<Int>,
  yRange: ClosedRange<Int>
) -> Set<IdentifiableCoordinate> {
  var filled = filled
  var queue: Set<IdentifiableCoordinate> = [start]
  while queue.isEmpty == false {
    let coord = queue.removeFirst()
    coord.adjacent.forEach { next in
      guard xRange.contains(next.x) && yRange.contains(next.y) else { return }
      if filled.contains(next) == false && queue.contains(next) == false {
        filled.insert(next)
        queue.insert(next)
      }
    }
  }
  return filled
}

extension Pair where T == IdentifiableCoordinate {
  func contains(_ other: Set<IdentifiableCoordinate>) -> Bool {
    if other.contains(IdentifiableCoordinate(x: xRange.lowerBound, y: yRange.lowerBound)) ||
      other.contains(IdentifiableCoordinate(x: xRange.upperBound, y: yRange.lowerBound)) ||
      other.contains(IdentifiableCoordinate(x: xRange.lowerBound, y: yRange.upperBound)) ||
      other.contains(IdentifiableCoordinate(x: xRange.upperBound, y: yRange.upperBound))
    {
      return true
    }
    return !squares().isDisjoint(with: other)
  }

  func squares() -> Set<IdentifiableCoordinate> {
    let result = xRange.flatMap { x in
      yRange.map { IdentifiableCoordinate(x: x, y: $0) }
    }
    return Set(result)
  }

  var xRange: ClosedRange<Int> {
    min(a.x, b.x) ... max(a.x, b.x)
  }
  var yRange: ClosedRange<Int> {
    min(a.y, b.y) ... max(a.y, b.y)
  }
}

enum Part2 {
  static func run(_ source: InputData) {
    let redSquares = source.lines.map(IdentifiableCoordinate.init(string:))

    var compacted: [IdentifiableCoordinate.ID: IdentifiableCoordinate] = redSquares.reduce(into: [:]) { result, square in
      result[square.id] = square
    }
    var rows: [Int: Set<IdentifiableCoordinate.ID>] = [:]
    var columns: [Int: Set<IdentifiableCoordinate.ID>] = [:]
    for square in redSquares {
      rows[square.y, default: []].insert(square.id)
      columns[square.x, default: []].insert(square.id)
    }

    // compact the red squares by removing empty rows and columns
    var columnCount = 0
    for column in columns.keys.sorted() {
      columnCount += 1
      for id in columns[column]! {
        compacted[id]?.x = columnCount
      }
    }
    var rowCount = 0
    for row in rows.keys.sorted() {
      rowCount += 1
      for id in rows[row]! {
        compacted[id]?.y = rowCount
      }
    }

    // connect the red squares in the compacted grid
    var loop = Set(compacted.values)
    for (index, redSquare) in redSquares.enumerated() {
      let nextId =
        if (index + 1) < redSquares.count {
          redSquares[index + 1].id
        } else {
          redSquares[0].id
        }
      let square = compacted[redSquare.id]!
      let next = compacted[nextId]!
      if square.y == next.y {
        let xRange =
          if next.x > square.x {
            square.x + 1 ..< next.x
          } else {
            next.x + 1 ..< square.x
          }
        for x in xRange {
          let coord = IdentifiableCoordinate(x: x, y: square.y)
          loop.insert(coord)
        }
      } else {
        let yRange =
          if next.y > square.y {
            square.y + 1 ..< next.y
          } else {
            next.y + 1 ..< square.y
          }
        for y in yRange {
          let coord = IdentifiableCoordinate(x: square.x, y: y)
          loop.insert(coord)
        }
      }
    }

    // flood fill the _exterior_ of the polygon
    let exteriorSquares = floodFill(
      from: .init(x: 0, y: 0),
      initial: loop,
      xRange: 0 ... (columnCount + 1),
      yRange: 0 ... (rowCount + 1)
    )
    .subtracting(loop)

    // find rectangles that do not overlap any "exterior" area (squares)
    let squares = Array(compacted.values)
    let validPairs: [Pair<IdentifiableCoordinate>] = squares.indices.reduce(into: []) { result, index in
      let a = squares[index]
      for b in squares.dropFirst(index + 1) {
        let pair = Pair(a: a, b: b)
        guard pair.contains(exteriorSquares) == false else { continue }
        result.append(pair)
      }
    }

    // find the validPair with the largest area (in the original coord space)
    let original: [IdentifiableCoordinate.ID: IdentifiableCoordinate] = redSquares.reduce(into: [:]) { result, square in
      result[square.id] = square
    }
    let areas = validPairs.map { pair in
      let a = original[pair.a.id]!
      let b = original[pair.b.id]!
      return (1 + abs(a.x - b.x)) * (1 + abs(a.y - b.y))
    }
    .sorted()
    let largest = areas.last!
    print("Part 2 (\(source)): \(largest)")
  }
}
