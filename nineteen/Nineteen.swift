//
//  Nineteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/18/24.
//

import Foundation

class Nineteen: Problem {
    
    var patterns = Set<String>();
    
    var designs = [String]();
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var availablePatterns = true;
        for line in input {
            if (line.isEmpty) {
                availablePatterns = false;
                continue;
            }
            if (availablePatterns) {
                patterns = Set(line.components(separatedBy: ", "));
                continue;
            }
            designs.append(line);
        }
    }

    var unfeasibleDesigns = Set<String>();
    
    func execPart1() throws {
        print(patterns)
        print(designs)
        var sum = 0;
        for design in designs {
            if (isDesignFeasible(design: design)) {
                sum += 1;
            } else {
                unfeasibleDesigns.insert(design);
            }
        }
        print("Possible designs count: \(sum)");
    }
    
    
    func isDesignFeasible(design: String) -> Bool {
        if (patterns.contains(design)) {
            return true;
        }
        
        if (design.count == 1) {
            unfeasibleDesigns.insert(design);
            return false;
        }
        
        for i in 1..<design.count {
            let index = design.index(design.startIndex, offsetBy: i);
            let substring1 = String(design[..<index]);
            let substring2 = String(design[index...]);
            if (patterns.contains(substring1) && isDesignFeasible(design: substring2)) {
                return true;
            }
        }
        
        return false;
    }
    
    func execPart2() throws{
        var sum = 0;
        for design in designs {
            if (isDesignFeasible(design: design)) {
//                print("Considering: \(design)")
                let feasibleCombos = getFeasibleCombos(design: design, target: design);
                sum += feasibleCombos;
//                print("Found \(feasibleCombos) for \(design)")
            }
        }
        print("Feasible design permutation count: \(sum)");
    }
    
    var cache = [String:Int]();
    
    func getFeasibleCombos(design: String, target: String) -> Int {
        if (unfeasibleDesigns.contains(design)) {
            return 0;
        }
        
        var feasibleComboCount = 0;
        if (patterns.contains(design)) {
            feasibleComboCount += 1;
        }
        
        if (design.count == 1) {
            return feasibleComboCount;
        }
        
        
        for i in 1..<design.count {
            let index = design.index(design.startIndex, offsetBy: i);
            let substring1 = String(design[..<index]);
            let substring2 = String(design[index...]);
            if (patterns.contains(substring1)) {
//                print("target: \(target) - for \(substring1) + \(substring2)")
                if (cache.keys.contains(substring2)) {
                    feasibleComboCount += cache[substring2]!
                    continue;
                }
                let feasibleCount = getFeasibleCombos(design: substring2, target: target);
//                print("target: \(target) - for \(substring1) + \(substring2) feasibleCount: \(feasibleCount)")
                if (feasibleCount == 0) {
                    unfeasibleDesigns.insert(substring2);
                } else {
                    cache[substring2] = feasibleCount;
                }
                feasibleComboCount += feasibleCount;
            }
        }
        
        return feasibleComboCount;
    }
}
