//
//  Seventeen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/16/24.
//

import Foundation

class Seventeen: Problem {
    
    var computer: Computer = Computer(a: 0, b: 0, c: 0, program: []);
    
    var startA = 0;
    var startB = 0;
    var startC = 0;
    var program: [Int] = [];
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
//        try super.init(filename: "small-sample.txt", filepath: #file)
        try super.init(filepath: #file)
        self.computer = try prep();
    }
    
    func prep() throws -> Computer {
        for line in input {
            if line.isEmpty {
                continue;
            }
            let tokens = line.components(separatedBy: ": ")
            if (tokens[0].contains("Register A")) {
                startA = Int(tokens[1])!
            } else if (tokens[0].contains("Register B")) {
                startB = Int(tokens[1])!
            } else if (tokens[0].contains("Register C")) {
                startC = Int(tokens[1])!
            } else if (tokens[0].contains("Program")) {
                program = tokens[1].components(separatedBy: ",").map { Int($0)! }
            }
        }
        return Computer(a: startA, b: startB, c: startB, program: program);
    }
    
    func execPart1() throws {
        computer.log = true;
        print(computer.run());
    }
    
    func execPart2() throws {
        print("-- PART 2 --")
        
        let t = { a in
            ((a % 8) ^ (a >> ((a % 8) ^ 7))) % 8
        }
        for i in 0..<64 {
            print("t=\(i): \(t(i))")
        }
        print("\(((34 % 8) ^ (34 >> ((34 % 8) ^ 7))) % 8)")
        
        print("program: \(program)")
        var sum = 0;
        for i in 1...program.count {
            let target = program[program.count - i];
            //            let last3 = sum % 8;
//            sum = findDigits(target: target, sum: sum)!;
            //            sum = (sum << 3) + newLast3;
            print("temp sum: \(sum)")
        }
        
        
        print("sum: \(sum)");
        
        print("\((1387662 << 7) ^ 1928307)")
        print("TEST: \(Computer(a: (1387656 << 7) ^ 1925235, b: startB, c: startC, program: program, log: false).run())")
        
        // 130786637902608 is too low!
        // 16738793670324
        
        // keep manually trying!!!
        for i in (0 << 6)..<(0 << 6)+262144 {
            let results = Computer(a: i, b: startB, c: startC, program: program, log: false).run()
            if (results == "2,4") {
                print("found 2,4 at: \(i)");
            } else if (results == "1,7,5,5,3,0") {
                print("found 1,7,5,5,3,0 at: \(i)");
//            } else if (results == "3,4,4") {
//                print("found 3,4,4 at: \(i)");
//            } else if results == "7,5,0" {
//                print("found 7,5,0 at: \(i)");
//            } else if results == "4,1,7" {
//                print("found 4,7,1 at: \(i)");
//            } else if (results == "2,4") {
//                print("found 2,4 at: \(i)")
            }
            /**
             
             
             found 4,1,7,5,5,3,0 at: 1925235
             found 4,1,7,5,5,3,0 at: 1928307
             found 4,1,7,5,5,3,0 at: 1979123
             found 4,1,7,5,5,3,0 at: 1991280
             found 4,1,7,5,5,3,0 at: 1991283
             found 4,1,7,5,5,3,0 at: 1993843
             
             
             found 1,7,7,5,0,3,4 at: 1387656
             found 1,7,7,5,0,3,4 at: 1387662
             found 1,7,7,5,0,3,4 at: 1396960
             found 1,7,7,5,0,3,4 at: 1405152
             */
        }
        
        print("Processing from \(248910*262144) to \((248910*262144)+262144) with jumpAt: \(248910)")
        for i in (248910*262144)..<(248910*262144)+262144{
//            print("Workin on \(i)")
            let results = Computer(a: i, b: startB, c: startC, program: program, log: false, jumpAt: 248910).run()
            if (results == "7,5,0,3,4,4") {
                print("found 7,5,0,3,4,4 at: \(i)");
            }
        }
        
        print("Processing from \(65250284722*4096) to \((65250284722*4096)+4096) with jumpAt: \(65250284722)")
        for i in (65250284722*4096)..<(65250284722*4096)+4096{
//            print("Workin on \(i)")
            let results = Computer(a: i, b: startB, c: startC, program: program, log: false, jumpAt: 65250284722).run()
            if (results == "2,4,1,7") {
                print("found 2,4,1,7 at: \(i)");
            }
        }
        
        print("Testing...");
        let expected = program.map { "\($0)" }.joined(separator: ",");
        let results = Computer(a: 267265166222235, b: startB, c: startC, program: program, log: false).run()
        print("Program: \(expected)")
        print("Results: \(results)")
        if (expected == results) {
            print("found solution with sum=\(sum)")
        }
        
//        let target = program.map { "\($0)" }.joined(separator: ",");
//        var result = "";
//        var i = 35184372088832;
//        while (result != target) {
//            if (i % 1000000 == 0) {
//                print("Tested \(i) values")
//            }
//            i += 1;
//            computer = Computer(a: i, b: startB, c: startC, program: program)
//            result = computer.run();
//        }
//        print("Found i=\(i) which resulted in a quine");
        
        // between: 
        //  35,184,372,088,836
        // 130,786,637,902,608
        
        // 20,442,771,480,211
        // 281,474,976,710,656
        
        // b = (a % 8) ^  7
        // c = a / 8
        // a = a / 8
        // b = ((a % 8) ^ 7) ^ (a / 8)
        // b = (((a % 8) ^ 7) ^ (a / 8)) ^ 7
        // return b % 8
        
        // b ^ 7
        
        // target: 2,4,1,7,7,5,0,3,4,4,1,7,5,5,3,0
    }
    
    func findDigits(target: Int, sum: Int) -> Int? {
        for potAddition in 0..<8 {
            let potNewSum = (sum << 3) + potAddition;
            let inverse = potAddition ^ 7;
            print("target: \(target) trying potential new addition \(potAddition): \(potNewSum) with inverse: \(inverse) = \((potAddition ^ ((potNewSum >> inverse))) % 8)")
            if (potAddition ^ (potNewSum >> inverse)) % 8 == target {
                return potNewSum;
            }
        }
        print("could not find new sum for sum \(sum)")
        return nil
    }
    
    class Computer {
        
        // registers
        var a: Int;
        var b: Int;
        var c: Int;
        
        var program: [Int];
        
        var clock = 0;
        
        var output: [Int] = [];
        
        var log = false;
        
        var jumpAt: Int;
        
        init(a: Int, b: Int, c: Int, program: [Int], log: Bool = false, jumpAt: Int = 0) {
            self.a = a;
            self.b = b;
            self.c = c;
            self.program = program;
            self.log = log;
            self.jumpAt = jumpAt;
        }
        
        func run() -> String {
            while(step()) {
                
            }
//            print("Program finished")
            return output.map {"\($0)"}.joined(separator: ",");
        }
        
        func step() -> Bool {
            if (program.count <= clock || output.count > 20) {
//                print("Halted")
                return false;
            }
            let op = program[clock];
            let operand = getOperand(program[clock + 1]);
            
            execute(op, operand);
            
            clock += 2;
            return true;
        }
        
        func execute(_ op: Int, _ operand: Int) {
            switch(op) {
            case 0: adv(operand); break;
            case 1: bxl(operand); break;
            case 2: bst(operand); break;
            case 3: jnz(operand); break;
            case 4: bxc(); break;
            case 5: output.append(out(operand)); break;
            case 6: bdv(operand); break;
            case 7: cdv(operand); break;
            default: print("Illegal operation found \(op)!!!!!!")
            }
        }
        
        func adv(_ operand: Int) {
            if (log) { print("adv (\(a), \(b), \(c)): setting reg a to \(a) / 2^\(operand) = \(a / Int(pow(Double(2), Double(operand))))") }
            a = a / Int(pow(Double(2), Double(operand)))
        }
        
        func bxl(_ operand: Int) {
            if (log) { print("bxl (\(a), \(b), \(c)): setting reg b to \(b) xor \(operand) = \(b ^ operand)") }
            b = b ^ operand;
        }
        
        func bst(_ operand: Int) {
            if (log) { print("bst (\(a), \(b), \(c)): setting reg b to \(operand) % 8 = \(operand % 8)") }
            b = operand % 8;
        }
        
        func jnz(_ operand: Int) {
            if (a == jumpAt) {
                return;
            }
            if (log) { print("jnz (\(a), \(b), \(c)): jumping the clock to \(operand)") }
            clock = operand - 2;
        }
        
        func bxc() {
            if (log) { print("bxc (\(a), \(b), \(c)): setting reg b to bitwise xor \(b) ^ \(c) = \(b ^ c)") }
            b = b ^ c;
        }
        
        func out(_ operand: Int) -> Int {
            if (log) { print("out (\(a), \(b), \(c)): appending \(operand % 8) to output\n\(output)\n") }
            return operand % 8
        }
        
        func bdv(_ operand: Int) {
            if (log) { print("bdv (\(a), \(b), \(c)): setting reg b = \(a) / 2^\(operand) = \(a / Int(pow(Double(2), Double(operand))))") }
            b = a / Int(pow(Double(2), Double(operand)))
        }
        
        func cdv(_ operand: Int) {
            if (log) { print("cdv (\(a), \(b), \(c)): setting reg c = \(a) / 2^\(operand) = \(a / Int(pow(Double(2), Double(operand))))") }
            c = a / Int(pow(Double(2), Double(operand)))
        }
        
        func getOperand(_ combo: Int) -> Int {
            if (combo == 4) {
                return a;
            } else if (combo == 5) {
                return b;
            } else if (combo == 6) {
                return c;
            }
            return combo;
        }
        
        
        
    }
}
