//
//  Seven.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/6/24.
//

import Foundation

class Seven: Problem {
    
    var equations: [Int:[Int]] = [:]
    
    var dupeEquations: [Int:[Int]] = [:]
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for line in input {
            if line.isEmpty { continue };
            let tokens = line.components(separatedBy: ": ");
            let value = Int(tokens[0])!;
            let operands = tokens[1].components(separatedBy: " ").map { Int($0)! }
            if (equations.keys.contains(value)) {
                print("equations already contains key \(value)");
                dupeEquations[value] = operands;
                continue;
            }
            equations[value] = operands;
        }
        print(dupeEquations)
        print(equations)
    }
    
    func execPart1() throws {
        var total = 0;
        var count = 0;
        for key in equations.keys {
            let operands = equations[key]!;
            let newOperands = Array(operands[1..<operands.count]);
            if (evalPossibleOperators(target: key, currentTotal: operands[0], operands: newOperands)) {
                total += key;
                count += 1;
            }
        }
        for key in dupeEquations.keys {
            let operands = dupeEquations[key]!;
            let newOperands = Array(operands[1..<operands.count]);
            if (evalPossibleOperators(target: key, currentTotal: operands[0], operands: newOperands)) {
                total += key;
                count += 1;
            }
        }
        print("Total is: \(total) from \(count) out of \(equations.count) equations")
        
        // 5030892082205 is too low!
    }
    
    // returns number of possibilities
    func evalPossibleOperators(target: Int, currentTotal: Int, operands: [Int]) -> Bool {
        // TODO change if division and subtraction are introduced
        if (currentTotal > target) {
            return false;
        }
        if (currentTotal == target) {
            return true;
        }
        if (operands.count == 0) {
            return false;
        }
        
        let newOperands = Array(operands[1..<operands.count]);
        let multBranch = evalPossibleOperators(target: target, currentTotal: currentTotal * operands[0], operands: newOperands);
        if (multBranch) {
            return true;
        }
        
        let sumBranch = evalPossibleOperators(target: target, currentTotal: currentTotal + operands[0], operands: newOperands)
        
        return sumBranch;
    }
    
    func execPart2() throws{
        var total = 0;
        var count = 0;
        for key in equations.keys {
            let operands = equations[key]!;
            let newOperands = Array(operands[1..<operands.count]);
            let result = evalPossibleOperatorsWithConcat(target: key, currentTotal: operands[0], operands: newOperands, operations: []);
            if (!result.isEmpty && verify(target: key, operands: operands, operators: result)) {
                print("\(key) works with \(result)")
                total += key;
                count += 1;
            }
        }
        for key in dupeEquations.keys {
            let operands = dupeEquations[key]!;
            let newOperands = Array(operands[1..<operands.count]);
            let result = evalPossibleOperatorsWithConcat(target: key, currentTotal: operands[0], operands: newOperands, operations: []);
            if (!result.isEmpty && verify(target: key, operands: operands, operators: result)) {
                total += key;
                count += 1;
            }
        }
        print("Part 2 Total is: \(total) from \(count) out of \(equations.count + dupeEquations.count) equations")
        
        // 91377457184931 is too high!
        // 91374869208200 is too low!
        // 91377448644679
    }
    
    func evalPossibleOperatorsWithConcat(target: Int, currentTotal: Int, operands: [Int], operations: [String]) -> [String] {
        if (currentTotal == target && operands.count == 0) {
//            print("\(target) met with \(operations)")
            return operations;
        }
        if (operands.count == 0) {
            return [];
        }
        
        let newOperands = Array(operands[1..<operands.count]);
        let concatValue = Int("\(currentTotal)\(operands[0])")!
        let concatBranch = evalPossibleOperatorsWithConcat(target: target, currentTotal: concatValue, operands: newOperands, operations: operations + ["||"]);
        if (!concatBranch.isEmpty) {
            return concatBranch;
        }
        
        let sumBranch = evalPossibleOperatorsWithConcat(target: target, currentTotal: currentTotal + operands[0], operands: newOperands, operations: operations + ["+"])
        if (!sumBranch.isEmpty) {
            return sumBranch;
        }
        
        let multBranch = evalPossibleOperatorsWithConcat(target: target, currentTotal: currentTotal * operands[0], operands: newOperands, operations: operations + ["*"]);
        if (!multBranch.isEmpty) {
            return multBranch;
        }
        
        return [];
    }
    
    func verify(target: Int, operands: [Int], operators: [String]) -> Bool {
        var total = operands[0];
        
        if (operators.count < operands.count - 1) {
            print("index out of range for target \(target) \(operands) \(operators) returning false");
            return false;
        }
        
        for i in 1..<operands.count {
            let operater = operators[i - 1];
            let operand = operands[i];
            if (operater == "||") {
                total = Int("\(total)\(operand)")!;
            } else if (operater == "*") {
                total = total * operand;
            } else if (operater == "+") {
                total = total + operand;
            }
        }
        
        if (total != target) {
            print("validation failed for \(target): \(operands) using \(operators)")
            return false;
        }
        return true;
    }
}
