//
//  Twentytwo.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/23/24.
//

import Foundation

class Twentytwo: Problem {
    
    var secrets = [Int]();
    
    var prices = [Int:[Int]]();
    
    var changes = [Int:[Int]]();
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for line in input {
            if (line.isEmpty) {
                continue;
            }
            secrets.append(Int(line)!);
        }
    }
    
    func execPart1() throws {
        // (n << shift 6 (64) XOR n) % 16777216
        // (n >> shift 5 (32) XOR n) % 16777216
        // (n << shift 11 (2048) XOR n) % 16777216
        
        var sum = 0;
        for secret in secrets {
            var curr = secret;
            var change = [0];
            var localPrices = [secret % 10];
            for _ in 0..<2000 {
                let next = nextSecret(curr);
                localPrices.append(next % 10);
                
                change.append((next % 10) - (curr % 10));
                
                curr = next;
            }
            changes[secret] = change;
            prices[secret] = localPrices;
//            print("2000th secret for \(secret) is \(curr)");
            sum += curr;
        }
        
        print("Sum: \(sum)")
    }
    
    func nextSecret(_ n: Int) -> Int {
        var secret = n;
        secret = ((secret << 6) ^ secret) % 16777216;
        secret = ((secret >> 5) ^ secret) % 16777216;
        return ((secret << 11) ^ secret) % 16777216;
    }
    
    func execPart2() throws {
//        for secret in secrets {
//            print("\(secret):\n\(prices[secret]![0..<20])\n\(changes[secret]![0..<20])")
//        }
        
        var patternCounts = [String:Int]();
        for secret in secrets {
            var localPatternCounts = [String:Int]();
            for i in 1..<changes[secret]!.count - 4 {
                let change = changes[secret]!;
                let pattern = "\(change[i]),\(change[i + 1]),\(change[i + 2]),\(change[i + 3])";
                if (!localPatternCounts.keys.contains(pattern)) {
//                    if (pattern == "-2,1,-1,3") {
//                        print("Adding price: \(prices[secret]![i + 3])")
//                    }
                    localPatternCounts[pattern] = prices[secret]![i + 3]
                }
            }
            for (key, value) in localPatternCounts {
//                if (key == "-2,1,-1,3") {
//                    print("Adding \(value) for \(key) for secret \(secret)")
//                    print("Setting overall value to \(patternCounts[key] ?? 0 + value)")
//                }
                patternCounts[key] = (patternCounts[key] ?? 0) + value;
            }
        }
        
//        print("Sum for -2,1,-1,3: \(patternCounts["-2,1,-1,3"]!)")
        
        var maxCount = 0;
        var maxPattern = "";
        for (key, value) in  patternCounts {
            if (value > maxCount) {
                maxPattern = key;
                maxCount = value;
            }
        }
        
        print("Max pattern: \(maxPattern) with count \(maxCount)")
    }
}
