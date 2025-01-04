//
//  Twentyfour.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/24/24.
//

import Foundation

class Twentyfour: Problem {
    
    var values = [String:Int]();
    
    var ops = [(String, String, String, String)]();
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var parsingWires = true;
        for line in input {
            if (line.isEmpty) {
                parsingWires = false;
                continue;
            }
            if (parsingWires) {
                let tokens = line.components(separatedBy: ": ");
                values[tokens[0]] = Int(tokens[1])!;
            } else {
                let tokens = line.components(separatedBy: " ")
                ops.append((tokens[0], tokens[1], tokens[2], tokens[4]));
            }
        }
        print(values)
    }
    
    func execPart1() -> String {
        
        var currOps = Array(ops);
        while !currOps.isEmpty {
            var newOps: [(String, String, String, String)] = [];
            for (_, op) in currOps.enumerated() {
                if (values.keys.contains(op.0) && values.keys.contains(op.2)) {
                    var operation: (Int, Int) -> Int = {first, second in first & second };
                    if (op.1 == "XOR") { operation = {first, second in first ^ second } }
                    else if (op.1 == "OR") { operation = {first, second in first | second } }
                    
                    values[op.3] = operation(values[op.0]!, values[op.2]!)
//                    print("\(values[op.0]!) (\(op.0)) \(op.1) \(values[op.2]!) (\(op.2)) yields \(values[op.3]!) to \(op.3)")
                } else {
                    newOps.append(op);
                }
            }
            currOps = newOps;
        }
        
        let registers = values.keys.filter({ $0.hasPrefix("z")}).sorted().reversed().map({ String(values[$0]!) }).joined();
        print("\(values.keys.filter({ $0.hasPrefix("z")}).sorted().reversed().joined(separator: ",")) :: \(registers)");
        
        return registers;
    }
    
    func execPart2() throws {
        // analyze ops. what are the operations that result in each of the Z registers?
        
        values = [:];
        try prep();
        
        values["x44"] = 0;
        values["y44"] = 0;
        
        let x = values.keys.filter({ $0.hasPrefix("x")}).sorted().reversed().map({ String(values[$0]!) }).joined();
        let y = values.keys.filter({ $0.hasPrefix("y")}).sorted().reversed().map({ String(values[$0]!) }).joined();
        
        let xInt = Int(x, radix: 2)!
        let yInt = Int(y, radix: 2)!;
        let z = "0" + String(xInt + yInt, radix: 2);

        print("\(x): \(xInt)");
        print("\(y): \(yInt)");
        print("\(z): \(xInt + yInt))")
        print("Actual:")
//        print("\(execPart1())")
        
        // 011001111010011101101100100100011111011100110
        // 011010000010011101110000100100100011011100110
        
        // diffs: z12, z13, z14, z15, z24, z25, z26, z37, z38, z39, z40, z41
        // z12: mgj XOR wsv = (x12 XOR y12) XOR (qff OR stw)
        // z13: hnt XOR fbm = (y13 XOR x13) XOR (hbq OR dcm)
        // z14: qwb XOR vmp = (x14 XOR y14) XOR (msq OR pjj)
        // z15: pbk XOR kqc = (y15 XOR x15) XOR (dtc OR ggg)
        // z24: qqp XOR dmw = (x24 XOR y24) XOR (cts XOR bcd)
        // z25: frw XOR hdp = (x25 XOR y25) XOR (njt OR kqp)
        // z26: jkt XOR dbp = (x26 XOR y26) XOR (kcs OR hgq)
        // z37: hjw XOR fhv = (x37 XOR y37) XOR (rpw OR fbq)
        // z38: bhh XOR pgm = (y38 XOR x38) XOR (smv OR wwg)
        // z39: rms XOR pwt = (y39 XOR x39) XOR (hsh OR rrb)
        // z40: fkd XOR fwt = (x40 XOR y40) XOR (fhc OR ggh)
        // z41: qnn XOR hvw = (y41 XOR x41) XOR (drs OR ghn)
        
        // z11 is missing x11 XOR y11 (it does have x11 AND y11);
        // z16 is missing x16 XOR y16 (it does have x16 AND y16);
        //
        
        // wfw, z16,  <-- def two
        // dfn, pbv,
        // ?, ?
        // ?, ? 
        
        var rules = [String:[String]]();
        for op in ops {
            rules[op.3] = [op.0, op.1, op.2];
        }
        for _ in 0..<5 {
            for (rule, ruleOps) in rules {
                var newOps = [String]();
                for op in ruleOps {
                    if (op.hasPrefix("x") || op.hasPrefix("y") || op == "AND" || op == "OR" || op == "XOR" || op == ")" || op == "(") {
                        newOps.append(op);
                        continue;
                    }
                    newOps.append(contentsOf: ["("] + rules[op]! + [")"]);
                }
                rules[rule] = newOps;
            }
        }
        
        var currOps = Array(ops);
        while !currOps.isEmpty {
            var newOps: [(String, String, String, String)] = [];
            for (_, op) in currOps.enumerated() {
                if (values.keys.contains(op.0) && values.keys.contains(op.2)) {
                    var operation: (Int, Int) -> Int = {first, second in first & second };
                    if (op.1 == "XOR") { operation = {first, second in first ^ second } }
                    else if (op.1 == "OR") { operation = {first, second in first | second } }
                    
                    var dest = op.3;
                    if (op.3 == "z16") {
                        dest = "pbv";
                    } else if (op.3 == "pbv") {
                        dest = "z16";
                    } else if (op.3 == "z23") {
                        dest = "qqp";
                    } else if (op.3 == "qqp") {
                        dest = "z23";
                    } else if (op.3 == "z36") {
                        dest = "fbq";
                    } else if (op.3 == "fbq") {
                        dest = "z36";
                    } else if (op.3 == "qnw") {
                        dest = "qff";
                    } else if (op.3 == "qff") {
                        dest = "qnw";
                    }
                    
                    values[dest] = operation(values[op.0]!, values[op.2]!)
//                    print("\(values[op.0]!) (\(op.0)) \(op.1) \(values[op.2]!) (\(op.2)) yields \(values[op.3]!) to \(op.3)")
                } else {
                    newOps.append(op);
                }
            }
            currOps = newOps;
        }
        
        
        let registers = values.keys.filter({ $0.hasPrefix("z")}).sorted().reversed().map({ String(values[$0]!) }).joined();
        print("\(values.keys.filter({ $0.hasPrefix("z")}).sorted().reversed().joined(separator: ",")) :: \(registers)");
        
        print("X - \(x): \(xInt)");
        print("Y - \(y): \(yInt)");
        print("Z - \(z): \(xInt + yInt))")
        print("Actual:")
        print("Z - \(registers): \(Int(registers, radix: 2)!)")
        
                
        
        print(rules.keys.filter { $0.hasPrefix("z") }.sorted().map {"\($0): \(rules[$0]!.joined(separator: " "))"}.joined(separator: "\n"))
        
        
        // z01: ( y00 AND x00 ) XOR ( y01 XOR x01 )
        
        // z02: ( ( ( y00 AND x00 ) AND ( y01 XOR x01 ) ) OR ( x01 AND y01 ) )
        // zN: (xN XOR yN) XOR ((zN-1[0] AND zN-1[1]) OR (xN-1 AND yN-1))
        
        // z03: (x03 XOR y03) XOR ( (x02 XOR y02) AND ( ( ( y00 AND x00 ) AND ( y01 XOR x01 ) ) OR ( x01 AND y01 ) ) ) ) OR (x02 AND y02);
        
        // fbq,pbv,qff,qnw,qqp,z16,z23,z36
        
    }

    
    
}
