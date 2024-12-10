//
//  Three.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/2/24.
//

import Foundation

class Three: Problem {
    
    var instructions: [String.Index: String] = [:];
    
    init() throws {
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        let regex = try Regex("mul[(]\\d{1,3},\\d{1,3}[)]")
        for line in input {
            if (line.isEmpty) { continue };
            
            let indexes = line.ranges(of: regex).map { range in range.lowerBound }
            let matches = line.matches(of: regex).map { match in String(match.output[0].substring!); };
            
            for (i, index) in indexes.enumerated() {
                instructions[index] = matches[i];
            }
        }
        
        let doRegex = try Regex("do[(][)]");
        
        for line in input {
            if (line.isEmpty) { continue };
            
            let indexes = line.ranges(of: doRegex).map { range in range.lowerBound }
            let matches = line.matches(of: doRegex).map { match in String(match.output[0].substring!); };
            
            for (i, index) in indexes.enumerated() {
                instructions[index] = matches[i];
            }
        }
        
        let dontRegex = try Regex("don[']t[(][)]");
        
        for line in input {
            if (line.isEmpty) { continue };
            
            let indexes = line.ranges(of: dontRegex).map { range in range.lowerBound }
            let matches = line.matches(of: dontRegex).map { match in String(match.output[0].substring!); };
            
            for (i, index) in indexes.enumerated() {
                instructions[index] = matches[i];
            }
        }
        print("\(instructions)");
    }
    
    func execPart1() throws {
        var sum = 0;
        for index in instructions.keys {
            let instruction = instructions[index]!;
            if (!instruction.contains(try Regex("mul"))) {
                continue;
            }
//            print("Start index for first \(match[0].output[0].range) start index for second \(match[1].output[0].range)")
//            print("For \(instruction) multiplying \(first) and \(second) = \(Int(first)! * Int(second)!)")
            sum += try performMult(instruction: instruction)
        }
        
        print("Sum is: \(sum)");
        
    }
    
    func execPart2() throws {
        let indexes = instructions.keys.sorted();
        var enabled = true;
        
        var sum = 0;
        for i in indexes {
            let instruction = instructions[i]!;
            if (instruction.contains(try Regex("mul")) && enabled) {
                sum += try performMult(instruction: instruction)
            } else if (instruction.contains(try Regex("do[(][)]"))) {
                enabled = true;
            } else if (instruction.contains(try Regex("don[']t[(][)]"))) {
                enabled = false;
            } else if (instruction.contains(try Regex("mul"))) {
            } else {
                print("warn: Unknown instruction encountered: \(instruction)");
            }
        }
        
        print("Sum: \(sum)")
    }
    
    func performMult(instruction: String) throws -> Int {
        let regex = try Regex("\\d{1,3}");
        let match = instruction.matches(of: regex)
        let first = match[0].output[0].substring!
        let second = match[1].output[0].substring!
        
        return Int(first)! * Int(second)!;
    }
    
}
