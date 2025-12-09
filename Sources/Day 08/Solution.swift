//
//  Solution.swift
//  Day 08
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct Coordinate: Hashable, CustomStringConvertible {
  var x: Int
  var y: Int
  var z: Int

  static let zero: Self = .init(x: 0, y: 0, z: 0)

  var description: String { "(\(x), \(y), \(z))" }

  func distance(to other: Self) -> Double {
    sqrt(pow(Double(x - other.x), 2) + pow(Double(y - other.y), 2) + pow(Double(z - other.z), 2))
  }
}
extension Coordinate {
  // 162,817,812
  init(string: any StringProtocol) {
    let numbers = string.components(separatedBy: ",").compactMap(Int.init)
    self.init(x: numbers[0], y: numbers[1], z: numbers[2])
  }
}

struct Pair<T>: Hashable where T: Hashable {
  let a: T
  let b: T
  var set: Set<T> {
    [a, b]
  }
}

enum Part1 {
  static func run(_ source: InputData) {
    let junctions = source.lines.map(Coordinate.init(string:))

    let distances: [Pair<Coordinate>: Double] = junctions.indices.reduce(into: [:]) { result, index in
      let a = junctions[index]
      for b in junctions.dropFirst(index + 1) {
        result[Pair(a: a, b: b)] = a.distance(to: b)
      }
    }

    let shortest = distances.sorted { $0.value < $1.value }
    var circuits: [Set<Coordinate>] = []
    for count in (0 ..< source.joinCount) {
      let pair = shortest[count].key
      let indexOfA = circuits.firstIndex { $0.contains(pair.a) }
      let indexOfB = circuits.firstIndex { $0.contains(pair.b) }
      switch (indexOfA, indexOfB) {
      case (.none, .none):
        circuits.append(pair.set)
      case (.none, .some(let index)), (.some(let index), .none):
        circuits[index].formUnion(pair.set)
      case (.some(let a), .some(let b)):
        guard a != b else { continue }
        circuits[a].formUnion(circuits[b])
        circuits.remove(at: b)
      }
    }

    let result = circuits.map { $0.count }
      .sorted { $0 > $1 }
      .prefix(3)
      .reduce(1, *)
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
