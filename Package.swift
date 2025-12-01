// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2025",
    platforms: [.macOS(.v26)],
    targets: [
        .executableTarget(
            name: "Day01",
            path: "Sources/Day 01"
        ),
        .executableTarget(
            name: "Day02",
            path: "Sources/Day 02"
        ),
        .executableTarget(
            name: "Day03",
            path: "Sources/Day 03"
        ),
        .executableTarget(
            name: "Day04",
            path: "Sources/Day 04"
        ),
        .executableTarget(
            name: "Day05",
            path: "Sources/Day 05"
        ),
        .executableTarget(
            name: "Day06",
            path: "Sources/Day 06"
        ),
        .executableTarget(
            name: "Day07",
            path: "Sources/Day 07"
        ),
        .executableTarget(
            name: "Day08",
            path: "Sources/Day 08"
        ),
        .executableTarget(
            name: "Day09",
            path: "Sources/Day 09"
        ),
        .executableTarget(
            name: "Day10",
            path: "Sources/Day 10"
        ),
        .executableTarget(
            name: "Day11",
            path: "Sources/Day 11"
        ),
        .executableTarget(
            name: "Day12",
            path: "Sources/Day 12"
        ),
    ]
)
