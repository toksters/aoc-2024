//
//  one.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 11/30/24.
//

import Foundation

class One: Problem {
            
    var right: [Int] = []

    var left: [Int] = [];
    
    init() throws {
        try super.init(filepath: #file)
        prep();
    }
    
    func prep() {
        for line in input {
            let tokens = line.components(separatedBy: "   ");
            if (tokens.count != 2) {
                print("skipping line \(line)")
                continue;
            }
            left.append(Int(tokens[0])!)
            right.append(Int(tokens[1])!)
        }
    }
    
    func execPart1() {
        prep();
        let sortedRight = right.sorted()
        let sortedLeft = left.sorted()
        
        var total = 0;
        for (i, rightVal) in sortedRight.enumerated() {
            total = total + abs(rightVal - sortedLeft[i]);
        }
        
        print("TOTAL: \(total)")
    }
    
    func execPart2() {
        var cache: [Int: Int] = [:];
        var total = 0;
        for (_, leftVal) in left.enumerated() {
            if let hit = cache[leftVal] {
                total += leftVal * hit;
                continue;
            }
            var count = 0;
            for (_, rightVal) in right.enumerated() {
                if (leftVal == rightVal) {
                    count += 1;
                }
            }
            cache[leftVal] = count;
            total += count * leftVal;
        }
        
        print("TOTAL: \(total)")
    }
    
}
