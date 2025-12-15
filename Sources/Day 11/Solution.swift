//
//  Solution.swift
//  Day 11
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

final class Node {
  let id: String
  let connections: [String]

  init(id: String, connections: [String]) {
    self.id = id
    self.connections = connections
  }
}
extension Node {
  static func parse(_ lines: [String]) -> [String: Node] {
    lines.reduce(into: [:]) { result, line in
      let node = Node(line)
      result[node.id] = node
    }
  }

  // you: bbb ccc
  convenience init(_ line: String) {
    let parts = line.components(separatedBy: ": ")
    self.init(id: parts[0], connections: parts[1].components(separatedBy: " "))
  }
}

// MARK: - Part 1

@MainActor
enum Part1 {
  static var nodes: [String: Node] = [:]

  static func allPaths(from path: [String], to end: String) -> [[String]] {
    let last = path.last!
    return nodes[last]!.connections.flatMap { next in
      let path = path + [next]
      if next == end {
        return [path]
      } else {
        return allPaths(from: path, to: end)
      }
    }
  }

  static func run(_ source: InputData) {
    nodes = Node.parse(source.lines)
    let paths = allPaths(from: ["you"], to: "out")
    let result = paths.count
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
