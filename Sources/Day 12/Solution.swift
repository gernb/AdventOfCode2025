//
//  Solution.swift
//  Day 12
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
  static func run(_ source: InputData) {
    let lines = source.lines.split(separator: "").last!
    let result = lines.reduce(0) { result, line in
      let parts = line.components(separatedBy: ": ")
      let treeArea = parts[0].components(separatedBy: "x").compactMap(Int.init).reduce(1, *)
      let packageArea = parts[1].components(separatedBy: " ").compactMap(Int.init).reduce(0, +) * 9
      if packageArea <= treeArea {
        return result + 1
      } else {
        return result
      }
    }
    print("Part 1 (\(source)): \(result)")
  }
}
