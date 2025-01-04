//
//  Twentyfive.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/27/24.
//

import Foundation

class Twentyfive: Problem {
    
    var locks = Array<Set<Point>>();
    
    var keys = Array<Set<Point>>();
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var curr = Set<Point>();
        var isKey = false;
        var isNewMap = true;
        var y = 0;
        for line in input {
            if (isNewMap && line == ".....") {
                print("Setting is key true for \(line)")
                isKey = true
            }
            isNewMap = false;
            if (line.isEmpty) {
                isNewMap = true;
                if (isKey) {
                    keys.append(curr);
                    print("Appending: \(curr) to keys")
                } else {
                    locks.append(curr);
                    print("Appending: \(curr) to locks")
                }
                curr = Set<Point>();
                y = 0;
                isKey = false;
                continue;
            }
            for (x, char) in line.enumerated() {
                if (char == "#") {
                    curr.insert(Point(x, y));
                }
            }
            y += 1;
        }
    }
    
    func execPart1() throws {
        var fitCount = 0;
        for key in keys {
            for lock in locks {
                if (key.intersection(lock).isEmpty) {
                    fitCount += 1;
                }
            }
        }
        print(fitCount)
    }
    
    func execPart2() throws{
        // implement
    }
}
