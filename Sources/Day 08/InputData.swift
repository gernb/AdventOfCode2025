//
//  InputData.swift
//  Day 08
//
//  Copyright © 2025 peter bohac. All rights reserved.
//

struct InputData: CustomStringConvertible {
    static let day = 8
    static func part1(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", joinCount: 1000, data: $0) }
    ]}
    static func part2(_ challengeData: String?) -> [Self?] {[
        .example,
        challengeData.map { Self(name: "challenge", joinCount: 1000, data: $0) }
    ]}

    let name: String
    let joinCount: Int
    let data: String

    var lines: [String] { data.components(separatedBy: .newlines) }
    var description: String { name }

    static let example = Self(
        name: "example",
        joinCount: 10,
        data:
"""
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
""")
}
