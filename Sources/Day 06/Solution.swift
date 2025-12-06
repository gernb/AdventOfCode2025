//
//  Solution.swift
//  Day 06
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Entry {
  case number(Int)
  case multiply
  case add

  var value: Int? {
    guard case .number(let num) = self else { return nil }
    return num
  }
  var op: (([Int]) -> Int)? {
    switch self {
    case .multiply: { $0.reduce(1, *) }
    case .add: { $0.reduce(0, +) }
    case .number: nil
    }
  }
}

func parse(_ lines: [String]) -> [[Entry]] {
  lines.map { line in
    line.trimmingCharacters(in: .whitespaces)
      .components(separatedBy: " ")
      .compactMap { string in
        return switch string {
        case "*": .multiply
        case "+": .add
        case "": nil
        default: .number(Int(string)!)
      }
    }
  }
}

enum Part1 {
  static func run(_ source: InputData) {
    let homework = parse(source.lines)
    let numbersCount = homework.count - 1
    let answers = homework[0].indices.map { index in
      let values = (0 ..< numbersCount).map {
        homework[$0][index].value!
      }
      return homework[numbersCount][index].op!(values)
    }
    let result = answers.reduce(0, +)
    print("Part 1 (\(source)): \(result)")
  }
}

// MARK: - Part 2

enum Part2 {
  static func run(_ source: InputData) {
    print("Part 2 (\(source)): TODO")
  }
}
