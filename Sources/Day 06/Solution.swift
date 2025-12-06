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

struct RotatedMatrix: IteratorProtocol, Sequence {
  private let source: [String]
  private var column: String.Index?

  init(_ source: [String]) {
    self.source = source
    self.column = source.map(\.endIndex).max()
  }

  mutating func next() -> (any Sequence<Character>)? {
    guard let column else { return nil }
    defer {
      if column == source[0].startIndex {
        self.column = nil
      } else {
        self.column = source[0].index(before: column)
      }
    }
    return RowSequence(source: source, column: column, row: 0)
  }

  private struct RowSequence: IteratorProtocol, Sequence {
    let source: [String]
    let column: String.Index
    var row: Int
    mutating func next() -> Character? {
      guard row < source.count else { return nil }
      defer { row += 1 }
      if column < source[row].endIndex {
        return source[row][column]
      } else {
        return " "
      }
    }
  }
}

enum Part2 {
  static func run(_ source: InputData) {
    let assignment = RotatedMatrix(source.lines)
      .map { row in
        String(row).trimmingCharacters(in: .whitespaces)
      }
      .split(separator: "")
    let answers = assignment.map { lines in
      let values = lines.dropLast().compactMap(Int.init) +
        [Int(String(lines.last!.dropLast()).trimmingCharacters(in: .whitespaces))!]
      return switch lines.last!.last! {
      case "*": values.reduce(1, *)
      case "+": values.reduce(0, +)
      default: fatalError()
      }
    }
    let result = answers.reduce(0, +)
    print("Part 2 (\(source)): \(result)")
  }
}
