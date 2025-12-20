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

@MainActor
enum Part2 {
  static var nodes: [String: Node] = [:]
  static var memo: [[String]: Int] = [:]

  static func countPaths(from start: String, to end: String, visited: Set<String> = []) -> Int {
    if start == end {
      return 1
    }
    if let cached = memo[[start, end]] {
      return cached
    }
    let visited = visited.union([start])
    var count = 0
    if let connections = nodes[start]?.connections {
      for next in connections where visited.contains(next) == false {
        count += countPaths(from: next, to: end, visited: visited)
      }
    }
    memo[[start, end]] = count
    return count
  }

  static func run(_ source: InputData) {
    nodes = Node.parse(source.lines)
    memo.removeAll()
    let pathsFromSVRtoFFT = countPaths(from: "svr", to: "fft")
    let pathsFromSVRtoDAC = countPaths(from: "svr", to: "dac")

    let pathsFromFFTtoDAC = countPaths(from: "fft", to: "dac")
    let pathsFromDACtoFFT = countPaths(from: "dac", to: "fft")

    let pathsFromFFTtoOUT = countPaths(from: "fft", to: "out")
    let pathsFromDACtoOUT = countPaths(from: "dac", to: "out")

    let result =
      pathsFromSVRtoDAC * pathsFromDACtoFFT * pathsFromFFTtoOUT +
      pathsFromSVRtoFFT * pathsFromFFTtoDAC * pathsFromDACtoOUT
    print("Part 2 (\(source)): \(result)")
  }
}
