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
    let rtlLines = source.lines.map { $0.reversed() }
    let numbersCount = rtlLines.count - 1
    var answers: [Int] = []
    var values: [Int] = []
    for index in rtlLines[0].indices {
      let numbers = (0 ..< numbersCount).compactMap { Int(String(rtlLines[$0][index])) }
      guard numbers.isEmpty == false else {
        continue
      }
      let value = numbers.reduce(0) { $0 * 10 + $1 }
      values.append(value)
      let op = rtlLines[numbersCount][index]
      if op != " " {
        let answer = switch rtlLines[numbersCount][index] {
        case "*": values.reduce(1, *)
        case "+": values.reduce(0, +)
        default: fatalError()
        }
        answers.append(answer)
        values.removeAll()
      }
    }
    let result = answers.reduce(0, +)
    print("Part 2 (\(source)): \(result)")
  }
}
