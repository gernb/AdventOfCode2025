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
// Implementation of the design found here: https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/

extension Array where Element == Int {
  func pressingButton(_ button: [Int]) -> Self {
    var joltages = self
    for idx in button {
      joltages[idx] -= 1
    }
    return joltages
  }
}

extension Int {
  var isEven: Bool { isMultiple(of: 2) }
  var isOdd: Bool { !isEven }

  func bits(width: Int) -> [Bool] {
    (0 ..< width)
      .map { (1 << $0) & self > 0 }
      .reversed()
  }
}

@MainActor
enum Part2 {
  static var buttons: [[Int]] = []

  private static var lightsMemo: [[Bool]: [[Int]]] = [:]
  static func allButtons(for lights: [Bool]) -> [[Int]] {
    if let cached = lightsMemo[lights] {
      return cached
    }

    let combinations: [[Int]] = (0 ..< (1 << buttons.count)).reduce(into: []) { result, combo in
      let press = combo.bits(width: buttons.count)
      let idxs = press.enumerated()
        .filter { $0.element }
        .map(\.offset)
      let finalLights = idxs.reduce(0.bits(width: lights.count)) { partialResult, idx in
        partialResult.pressingButton(buttons[idx])
      }
      if finalLights == lights {
        result.append(idxs)
      }
    }
    lightsMemo[lights] = combinations
    return combinations
  }

  private static var joltagesMemo: [[Int]: Int] = [:]
  static func buttonPresses(for joltages: [Int]) -> Int? {
    guard joltages.allSatisfy({ $0 >= 0 }) else {
      return nil
    }
    // stop if all zeros
    if joltages.reduce(0, +) == 0 {
      return 0
    }

    if let cached = joltagesMemo[joltages] {
      return cached == .max ? nil : cached
    }

    let lights = joltages.map(\.isOdd)
    let combos = allButtons(for: lights)
    let counts = combos.map { combo in
      let nextJoltages = combo.reduce(joltages) { partialResult, idx in
        partialResult.pressingButton(buttons[idx])
      }
      .map { $0 / 2 }
      return buttonPresses(for: nextJoltages).map { 2 * $0 + combo.count } ?? .max
    }
    let count = counts.min() ?? .max

    joltagesMemo[joltages] = count
    return count == .max ? nil : count
  }

  static func run(_ source: InputData) {
    let machines = source.lines.map(Machine.init)
    let presses = machines.map { machine in
      buttons = machine.buttons
      lightsMemo.removeAll()
      joltagesMemo.removeAll()
      return buttonPresses(for: machine.joltages)!
    }
    let result = presses.reduce(0, +)
    print("Part 2 (\(source)): \(result)")
  }
}
