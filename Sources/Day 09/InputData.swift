//
//  InputData.swift
//  Day 09
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 9
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", data: $0) }
    ]}

    let name: String
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        data:
"""
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
""")
}
