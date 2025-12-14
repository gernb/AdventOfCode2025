//
//  Solution.swift
//  Day 10
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

struct Machine {
  let lights: [Bool]
  let buttons: [[Int]]
  let joltages: [Int]
}
extension Machine {
  // [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  init(_ line: String) {
    let parts = line.components(separatedBy: " ")
    self.init(
      lights: Self.lights(from: parts[0]),
      buttons: parts.dropFirst().dropLast().map(Self.ints(from:)),
      joltages: Self.ints(from: parts.last!)
    )
  }

  private static func lights(from string: String) -> [Bool] {
    string.dropFirst().dropLast().map { $0 == "#" }
  }

  private static func ints(from string: String) -> [Int] {
    string.dropFirst().dropLast().components(separatedBy: ",").compactMap(Int.init)
  }
}

extension Array where Element == Bool {
  func pressingButton(_ button: [Int]) -> Self {
    var lights = self
    for idx in button {
      lights[idx].toggle()
    }
    return lights
  }
}

func findShortestPath<Node: Hashable>(from start: Node, using getNextNodes: ((Node) -> [Node]?)) -> [Node]? {
  typealias Path = [Node]
  var visited: [Node: Path] = [:]
  var queue: [(node: Node, path: Path)] = [(start, [])]

  while queue.isEmpty == false {
    var (node, path) = queue.removeFirst()
    guard let nextNodes = getNextNodes(node) else {
      return path + [node]
    }
    path.append(node)
    for nextNode in nextNodes {
      if let previousPath = visited[nextNode], previousPath.count <= path.count {
        continue
      }
      if queue.contains(where: { $0.node == nextNode }) {
        continue
      }
      queue.append((nextNode, path))
    }
    visited[node] = path
  }

  // No possible path exists
  return nil
}

enum Part1 {
  static func buttonPresses(for machine: Machine) -> [Int] {
    struct Node: Hashable {
      let lights: [Bool]
      var button: Int?
    }
    let start = Array(repeating: false, count: machine.lights.count)
    let presses = findShortestPath(from: Node(lights: start)) { current in
      guard current.lights != machine.lights else {
        return nil
      }
      return machine.buttons.enumerated().map { idx, button in
        return Node(
          lights: current.lights.pressingButton(button),
          button: idx
        )
      }
    }
    return presses!.compactMap(\.button)
  }

  static func run(_ source: InputData) {
    let machines = source.lines.map(Machine.init)
    let presses = machines.map(buttonPresses(for:))
    let result = presses.map(\.count).reduce(0, +)
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
