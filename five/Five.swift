//
//  Five.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/4/24.
//

import Foundation

import Foundation

class Five: Problem {
    
    var beforeRules: [Int: Set<Int>] = [:]; // number -> pages that must come before it
    var afterRules: [Int: Set<Int>] = [:]; // number -> pages that must come after it
    
    var pages: [[Int]] = [];
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var parsingRules = true;
        for line in input {
            if (line.isEmpty) {
                parsingRules = false;
                continue;
            }
            
            if (parsingRules) {
                let tokens = line.components(separatedBy: "|");
                let first = Int(tokens[0])!, second = Int(tokens[1])!;
                if var _ = beforeRules[second] {
                    beforeRules[second]!.insert(first);
                } else {
                    beforeRules[second] = [first];
                }
                if let _ = afterRules[first] {
                    afterRules[first]!.insert(second);
                } else {
                    afterRules[first] = [second];
                }
            } else {
                var page = line.components(separatedBy: ",").map { Int($0)! }
                pages.append(page);
            }
        }
        
        print("before rules: \(beforeRules)")
        print("after rules: \(afterRules)")
        print("pages: \(pages)")
    }
    
    func execPart1() throws -> [[Int]]{
        var validPages: [[Int]] = [];
        var invalidPages: [[Int]] = [];
        for page in pages {
            var pageValid = true;
            for j in 0..<page.count - 1 {
                for k in (j + 1)..<page.count {
                    let ref = page[j];
                    let comparison = page[k]
                    // must ref come before comparison
                    // must comparison come after rules?
                    let canJBeBeforeK = (beforeRules[comparison]?.contains(ref) ?? true)
                    && (afterRules[ref]?.contains(comparison) ?? true);
                    if (!canJBeBeforeK) {
//                        print("\(page) is not valid because \(page[j]) is not in beforeRules of \(page[k])!")
                        pageValid = false;
                        break;
                    }
                }
            }
            if (pageValid) {
                validPages.append(page);
            } else {
                invalidPages.append(page);
            }
            
        }
        
//        print("Valid pages are: \(validPages)");
        
        var sum = 0;
        for page in validPages {
            let middleIndex = page.count / 2;
            sum += page[middleIndex];
        }
        
        print("Sum: \(sum)")
        
        // 11842 is too high!
        return invalidPages;
    }
    
    func execPart2() throws {
        
//        var values: [Int:Int] = [:]
//        for i in 10...99 {
//            if (afterRules[i] == nil) {
//                continue
//            }
//
//            let numBefore = afterRules[i]?.count ?? 0;
//            var cascadingRuleCount = 0;
//            for afterRule in afterRules[i] ?? [] {
//                print("Afterrule: \(afterRule) has \(afterRules[afterRule]!)");
//                cascadingRuleCount += afterRules[afterRule]?.count ?? 0;
//                for postAfterRule in afterRules[afterRule] ?? [] {
//                    cascadingRuleCount += afterRules[postAfterRule]?.count ?? 0;
//                }
//            }
//            values[i] = numBefore + cascadingRuleCount;
//        }
//
//        var uniqueValues: Set<Int> = [];
//        for key in values.keys {
//            if (uniqueValues.contains(values[key]!)) {
//                print("key \(key) has the same value as another: \(values[key]!)")
//            } else {
//                uniqueValues.insert(values[key]!);
//            }
//        }
//
//        print("\(values)")
        
        
        var invalidPages = try execPart1();
        print("Invalid pages count \(invalidPages.count)")
        
        var sum = 0;
        for page in invalidPages {
//            let sorted = page.sorted { first, second in
//                let firstValue = values[first];
//                let secondValue = values[second];
//                if (firstValue == nil || secondValue == nil) {
////                    print("nil values encountered for first \(first), second \(second) on page \(page)")
//                }
//                return values[first] ?? 0 < values[second] ?? 0
//            }
//            print("\(page) sorted to be \(sorted)")
            var sorted = sortPage(page);
            print("sorted \(page) into \(sorted)")
            sum += sorted[sorted.count / 2]
        }
        
        print("Sum: \(sum)")
        
        // 6567 is too high!
    }
    
    func sortPage(_ page: [Int]) -> [Int] {
        if (page.count == 1) {
            return [page[0]];
        }
        if (page.isEmpty) {
            return [];
        }
        if (page.count == 2 && beforeRules[page[0]]?.contains(page[1]) ?? false) {
            return [page[1], page[0]];
        }
        if (page.count == 2 && beforeRules[page[1]]?.contains(page[0]) ?? false) {
            return [page[0], page[1]];
        }

        
        let pivot = page[0];
        var lesser: [Int] = [];
        var greater: [Int] = [];
        for i in 1..<page.count {
            // if element must be before pivot, put in lesser
            if (beforeRules[pivot]?.contains(page[i]) ?? false) {
                lesser.append(page[i]);
            } else {
                greater.append(page[i]);
            }
        }
        
        var result = sortPage(lesser);
        result.append(pivot)
        result.append(contentsOf: sortPage(greater))
        return result;
    }
}
