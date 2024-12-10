//
//  Four.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/3/24.
//

import Foundation

class Four: Problem {
    
    var puzzle: [[Character]] = [];
    
    let target = "XMAS";
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    enum Direction: CaseIterable {
        case N, NE, E, SE, S, SW, W, NW;
    }
    
    func prep() {
        for line in input {
            if (line.isEmpty) {
                continue;
            }
            var chars: [Character] = []
            for character in line {
                chars.append(character);
            }
            puzzle.append(chars);
        }
    }
    
    func execPart1() {
        var total = 0;
        for (y, line) in puzzle.enumerated() {
            for (x, _) in line.enumerated() {
                for dir in Direction.allCases {
                    total += recursiveSearch(x: x, y: y, substring: "", direction: dir)
                }
            }
        }
        print("Total: \(total)")
        
        // 391046 is too high!
        // 2319 is too low
    }
    
    func recursiveSearch(x: Int, y: Int, substring: String, direction: Direction) -> Int {
        if (!target.hasPrefix(substring)) {
            //print("pruning early for substring \(substring)")
            return 0;
        }
        //if (substring.count == target.count) {
            //print("Returning 0 because string \(substring) reached max size")
        //    return 0;
        //}
        let newSubstring = "\(substring)\(puzzle[y][x])"
        if (newSubstring == target) {
            print("Found \(substring) at \(x), \(y), \(direction), \(substring)!!")
            return 1;
        }
        
        var total = 0;

        
        // west
        if (x > 0 && direction == Direction.W) {
            total += recursiveSearch(x: x - 1, y: y, substring: newSubstring, direction: direction)
        }
        // northwest
        if (x > 0 && y > 0 && direction == Direction.NW) {
            total += recursiveSearch(x: x - 1, y: y - 1, substring: newSubstring, direction: direction)
        }
        // north
        if (y > 0 && direction == Direction.N) {
            total += recursiveSearch(x: x, y: y - 1, substring: newSubstring, direction: direction)
        }
        // northeast
        if (x < puzzle[0].count - 1 && y > 0 && direction == Direction.NE) {
            total += recursiveSearch(x: x + 1, y: y - 1, substring: newSubstring, direction: direction)
        }
        // east
        if (x < puzzle[0].count - 1 && direction == Direction.E) {
            total += recursiveSearch(x: x + 1, y: y, substring: newSubstring, direction: direction)
        }
        // southeast
        if (x < puzzle[0].count - 1 && y < puzzle.count - 1 && direction == Direction.SE) {
            total += recursiveSearch(x: x + 1, y: y + 1, substring: newSubstring, direction: direction)
        }
        // south
        if (y < puzzle.count - 1 && direction == Direction.S) {
            total += recursiveSearch(x: x, y: y + 1, substring: newSubstring, direction: direction)
        }
        // southwest
        if (x > 0 && y < puzzle.count - 1 && direction == Direction.SW) {
            total += recursiveSearch(x: x - 1, y: y + 1, substring: newSubstring, direction: direction)
        }
        
        return total;
    }
    
    func execPart2() {
        var total = 0;
        for (y, line) in puzzle.enumerated() {
            for (x, _) in line.enumerated() {
                if (isXmas(x: x, y: y)) {
                    print("Match at \(x) \(y)")
                    total += 1;
                }
            }
        }
        print("Total: \(total)")
    }
    
    func isXmas(x: Int, y: Int) -> Bool {
        if (x == 0 || x == puzzle[0].count - 1 || y == 0 || y == puzzle.count - 1) {
            return false;
        }
        let center = puzzle[y][x]
        let nw = String(puzzle[y - 1][x - 1])
        let se = String(puzzle[y + 1][x + 1])
        let ne = String(puzzle[y - 1][x + 1])
        let sw = String(puzzle[y + 1][x - 1])
        return center == "A"
        && (( nw == "M" && se == "S") || (nw == "S" && se == "M"))
        && (( sw == "M" && ne == "S") || (sw == "S" && ne == "M"));
    }
}
