//
//  Twentyone.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/21/24.
//

import Foundation

class Twentyone: Problem {
    
    let numeric = ["7": Point(0, 0), "8": Point(1, 0), "9": Point(2, 0), "4": Point(0, 1), "5": Point(1, 1), "6": Point(2, 1), "1": Point(0, 2), "2": Point(1, 2), "3": Point(2, 2), "0": Point(1, 3), "A": Point(2, 3)];
    
    let directional = ["^": Point(1, 0), "A": Point(2, 0), "<": Point(0, 1), "v": Point(1, 1), ">": Point(2, 1)]
   
    var codes = [String]();
    
    var numericShortestPaths = [String:[[Point]]]();
    
    var directionalShortestPaths = [String:[[Point]]]();
    
    var cache: [String:Int] = [:];
    
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
            codes.append(line);
        }
        for (k1, v1) in numeric {
            for (k2, v2) in numeric {
                if (k1 == k2) { continue; }
                numericShortestPaths["\(k1)\(k2)"] = findShortestPaths(map: numeric, curr: v1, target: v2)
            }
        }
        for (k1, v1) in directional {
            for (k2, v2) in directional {
                if (k1 == k2) { directionalShortestPaths["\(k1)\(k2)"] = []; continue; }
                let shortestDists = pruneNonShortestDistances(findShortestPaths(map: directional, curr: v1, target: v2));
                directionalShortestPaths["\(k1)\(k2)"] = shortestDists.count == 1 ? shortestDists : [shortestDists[0]]
            }
        }
        print("Directional shortest paths: \(directionalShortestPaths)")
        for (k, v) in directionalShortestPaths {
            if (v.count > 1) {
                print("\(k) still has multiple best solutions \(v)")
            }
        }
    }
    
    func pruneNonShortestDistances(_ paths: [[Point]]) -> [[Point]] {
        if paths.count == 1 {
            return paths;
        }
        
        let dirs = paths.reduce(into: [String:[Point]]()) {
            $0[translateToDirectional(path: $1)] = $1;
        }
        
        var collapsedCounts = [String:Int]();
        var smallestCount = 100000000;
        for dir in dirs.keys {
            var collapsed = "";
            for i in 1...dir.count {
                if (i == dir.count) {
                    collapsed += dir[i - 1]!;
                } else if (dir[i] != dir[i - 1]) {
                    collapsed += dir[i - 1]!;
                }
            }
            if (collapsed.count < dir.count) {
                print("Collapsed \(dir) to \(collapsed)")
            }
            if collapsed.count < smallestCount {
                smallestCount = collapsed.count;
            }
            collapsedCounts[dir] = collapsed.count;
        }
        
        var smallestPaths = [[Point]]();
        
        for (key, count) in collapsedCounts {
            if (count == smallestCount) {
                smallestPaths.append(dirs[key]!);
            }
        }
        
        return smallestPaths;
        
    }
    
    func execPart1() throws {
        // Keypad -> Directional
        var directionalCodes = codes.reduce(into: [String:[String]]()) { $0[$1] = translateFromNumericToDirectional("A" + $1)}
        print(directionalCodes);
        for (key, codes) in directionalCodes {
            directionalCodes[key] = pruneNonShortest(codes);
        }
        
        // Directional -> Directional
        var levelTwo = [String:[String]]();
        for (code, directionalCodesList) in directionalCodes {
            let newDirectional = directionalCodesList.map { translateFromDirectionalToDirectional("A" + $0) }.flatMap { $0 }
            levelTwo[code] = pruneNonShortest(newDirectional);
        }
        print("Finished level two calculations");
        // Directional -> Directional
        var levelThree = [String:[String]]();
        for (code, directionalCodesList) in levelTwo {
            let newDirectional = directionalCodesList.map { translateFromDirectionalToDirectional("A" + $0) }.flatMap { $0 }
            levelThree[code] = pruneNonShortest(newDirectional);
        }
        
        print("Finished level three calculations");
        
        var sum = 0;
        for (code, directionalCodesList) in levelThree {
            let newDirectional = directionalCodesList.sorted { $0.count < $1.count }
            let complexity = Int(code[..<code.index(code.startIndex, offsetBy: 3)])! * newDirectional[0].count;
            sum += complexity;
            print("Shortest direction for \(code) is \(newDirectional[0].count) with complexity: \(complexity)")
        }
        
        
        print("Total complexity: \(sum)")
    }
    
    func pruneNonShortest(_ codes: [String]) -> [String] {
        if (codes.count == 1) {
            return codes;
        }
        let sorted = codes.sorted{ $0.count < $1.count };
        var shortest = [String]();
        var shortestLen: Int? = nil;
        for code in sorted {
            if (shortestLen == nil) {
                shortestLen = code.count;
                shortest.append(code);
                continue;
            }
            if (code.count > shortestLen!) {
                break;
            }
            shortest.append(code);
        }
        print("pruned from \(codes.count) to \(shortest.count)")
        return shortest;
        
    }
    
    func translateFromDirectionalToDirectional(_ code: String) -> [String] {
        var directionalCodes = [String]();
        for i in 1..<code.count {
            let start = code.index(code.startIndex, offsetBy: i - 1)
            let end = code.index(code.startIndex, offsetBy: i)
            let substr = code[start...end]
//            print("Finding directional shortest path for \(substr)")
            let tempShortestPaths = directionalShortestPaths[String(substr)]!
//            print("Shortest paths for \(substr) are \(tempShortestPaths)")
            var newShortestPaths = [String]();
            if (tempShortestPaths.isEmpty) {
                if (i == 1) {
                    newShortestPaths.append("A");
                    continue;
                }
                for sp in directionalCodes {
                    newShortestPaths.append(sp + "A");
                }
            }
            for p in tempShortestPaths {
                if (i == 1) {
                    newShortestPaths.append(translateToDirectional(path: p) + "A");
                    continue;
                }
                for sp in directionalCodes {
                    newShortestPaths.append(sp + translateToDirectional(path: p) + "A");
                }
            }
            directionalCodes = newShortestPaths;
        }
//        print("Shortest path for \(code) are \(directionalCodes)")
        return directionalCodes;
    }
    
    func translateFromNumericToDirectional(_ code: String) -> [String] {
        var shortestPaths = [String]();
        for i in 1..<code.count {
            let start = code.index(code.startIndex, offsetBy: i - 1)
            let end = code.index(code.startIndex, offsetBy: i)
            let substr = code[start...end]
            let tempShortestPaths = numericShortestPaths[String(substr)]!
//            print("Path for \(substr) = \(tempShortestPaths)")
            var newShortestPaths = [String]();
            for p in tempShortestPaths {
                if (i == 1) {
                    newShortestPaths.append(translateToDirectional(path: p) + "A");
                    continue;
                }
                for sp in shortestPaths {
                    newShortestPaths.append(sp + translateToDirectional(path: p) + "A");
                }
            }
            shortestPaths = newShortestPaths;
        }
        print("Shortest numerical paths for \(code) are: \n\(shortestPaths)");
        return shortestPaths;

    }
    
    func findShortestPaths(map: [String:Point], curr: Point, target: Point) -> [[Point]] {
        let paths = findPaths(map: map, curr: curr, target: target, pathSoFar: [curr]).sorted(by: { $0.count < $1.count})
//        print("Paths from \(curr), \(target) = \(paths)")
        var shortestPaths: [[Point]] = [];
        var shortestCount: Int? = nil;
        for path in paths {
            if (shortestCount == nil) {
                shortestCount = path.count;
                shortestPaths.append(path)
            } else if (path.count == shortestCount!) {
                shortestPaths.append(path);
            } else if (path.count > shortestCount!) {
                return shortestPaths;
            }
        }
//        print("Shortest paths from \(curr), \(target) = \(shortestPaths)")
        return shortestPaths;
    }
    
    func findPaths(map: [String:Point], curr: Point, target: Point, pathSoFar: [Point]) -> [[Point]] {
        if (curr == target) {
            return Array([pathSoFar]);
        }
        
        let north = curr.getNorth();
        var shortestPaths = [[Point]]();
        if (map.values.contains(north) && !pathSoFar.contains(north)) {
            shortestPaths += findPaths(map: map, curr: north, target: target, pathSoFar: pathSoFar + [north])
        }
        
        let south = curr.getSouth();
        if (map.values.contains(south) && !pathSoFar.contains(south)) {
            shortestPaths += findPaths(map: map, curr: south, target: target, pathSoFar: pathSoFar + [south])
        }
        
        let east = curr.getEast();
        if (map.values.contains(east) && !pathSoFar.contains(east)) {
            shortestPaths += findPaths(map: map, curr: east, target: target, pathSoFar: pathSoFar + [east])
        }
        
        let west = curr.getWest();
        if (map.values.contains(west) && !pathSoFar.contains(west)) {
            shortestPaths += findPaths(map: map, curr: west, target: target, pathSoFar: pathSoFar + [west])
        }
        
        return shortestPaths;
    }
    
    func translateToDirectional(path: [Point]) -> String {
        var str = "";
        for i in 1..<path.count {
            let start = path[i - 1];
            let end = path[i];
            if (end == start.getEast()) {
                str += ">";
            } else if (end == start.getNorth()) {
                str += "^";
            } else if (end == start.getSouth()) {
                str += "v";
            } else if (end == start.getWest()) {
                str += "<"
            }
        }
        return str;
    }
    
    // TODO: Maybe we need to do a recursive BFS, keeping track of the subpaths stemming for each
    func execPart2() throws {
        
        let directionalCodes = codes.reduce(into: [String:[String]]()) { $0[$1] = translateFromNumericToDirectional("A" + $1)}
        
//        print(directionalCodes);
//
//        for (key, codes) in directionalCodes {
//            var collapsedCounts = [String:Int]();
//            var smallestCount = 100000000;
//            for dir in codes {
//                var collapsed = "";
//                for i in 1...dir.count {
//                    if (i == dir.count) {
//                        collapsed += dir[i - 1]!;
//                    } else if (dir[i] != dir[i - 1]) {
//                        collapsed += dir[i - 1]!;
//                    }
//                }
////                if (collapsed.count < dir.count) {
////                    print("Collapsed \(dir) to \(collapsed)")
////                }
//                if collapsed.count < smallestCount {
//                    smallestCount = collapsed.count;
//                }
//                collapsedCounts[dir] = collapsed.count;
//            }
//            var shorterCodes = [String]();
//            for (key, count) in collapsedCounts {
//                if (count == smallestCount) {
//                    shorterCodes.append(key);
//                }
//            }
//            directionalCodes[key] = [shorterCodes[0]];
//        }
//
//        print(directionalCodes);
        
        var sum = 0;
        for (key, codes) in directionalCodes {
            var smallestCost = Int.max;
            for code in codes {
                let cost = expand(curr: code, level: 0)
//                print("Cost of \(code) after 25 is: \(cost)");
                if (smallestCost > cost) {
                    smallestCost = cost;
                }
            }
            print("smallest cost for: \(key) is \(smallestCost)");
            
            let complexity = Int(key[..<key.index(key.startIndex, offsetBy: 3)])! * smallestCost;
            sum += complexity;
        }
        print("Total complexity: \(sum)")
    
        
        
//        var cache = [String:Int]();
//        for start in directional.keys {
//            for end in directional.keys {
//                var curr = start + end;
//                var count = 0;
//                for i in 1...12 {
//                    let paths = pruneNonShortest(translateFromDirectionalToDirectional(curr).flatMap{ $0 });
//                    print("^ yields: \(paths[0].count) after processing \(curr.count) at \(i)")
//                    curr = paths[0];
//                    count = paths[0].count;
//                }
//            }
//        }
//
//
//        // Keypad -> Directional
//        var directionalCodes = codes.reduce(into: [String:[String]]()) { $0[$1] = translateFromNumericToDirectional("A" + $1)}
//        print(directionalCodes);
//
//        for i in 0..<25 {
//            for (code, directionalCodesList) in directionalCodes {
////                if (i < 3) {
////                    print("Evaluating: \(code) \(directionalCodesList[0]) with current shortest size: \(directionalCodesList[0].count)")
////                }
//                let newDirectional = directionalCodesList.map { translateFromDirectionalToDirectional("A" + $0) }.flatMap { $0 }
//                let shortest = pruneNonShortest(newDirectional);
////                if (i < 3) {
////                    print("Shortest: \(shortest[0].count): \(shortest[0])")
////                }
//                directionalCodes[code] = shortest
//            }
//            print("Finished level: \(i + 1)")
//        }
//
//        var sum = 0;
//        for (code, directionalCodesList) in directionalCodes {
//            let newDirectional = directionalCodesList.sorted { $0.count < $1.count }
//            let complexity = Int(code[..<code.index(code.startIndex, offsetBy: 3)])! * newDirectional[0].count;
//            sum += complexity;
//            print("Shortest direction for \(code) is \(newDirectional[0].count) with complexity: \(complexity)")
//        }
//
//
//        print("Total complexity: \(sum)")
    
        // 381220099682006 is too high
    }
    
    // make sure the first one starts with A
    func expand(curr: String, level: Int) -> Int {
        print("Evaluating \(curr) at level \(level)")
        let maxLevel = 25; // # of directional keypads - 1
        if (level == maxLevel) {
//            print("Found string at level \(maxLevel): \(curr)")
            return curr.count;
        }
        
//        let cacheKey = "\(curr):\(maxLevel - level)";
//        if (cache.keys.contains(cacheKey)) {
//            print("Cache hit for \(cacheKey): \(level) + \(maxLevel - level)= \(cache[cacheKey]!)")
//            return cache[cacheKey]!;
//        }
//
        var cost = 0;
        var withImplicitStart = "A" + curr;
        
        // try to fetch substrings from cache
        for i in 0..<withImplicitStart.count - 2 {
            if (withImplicitStart.count <= 2) {
                continue;
            }
            let startIndex = withImplicitStart.startIndex;
            let endIndex = withImplicitStart.index(startIndex, offsetBy: withImplicitStart.count - i - 1);
            let substr = withImplicitStart[startIndex...endIndex];
            print("substring for \(withImplicitStart) at [0..<\(withImplicitStart.count - i - 1)] = \(substr)")
            let substrCacheKey = "\(substr):\(maxLevel - level)"
            if (cache.keys.contains(substrCacheKey)) {
                print("Cache hit for substring \(substr) = \(cache[substrCacheKey]!)")
                cost += cache[substrCacheKey]!;
                withImplicitStart = String(withImplicitStart[endIndex...])
                break;
            }
        }
        
        if (withImplicitStart.count == 0) {
            return cost;
        }
        
//        let fullCacheKey = "\(curr):\(maxLevel - level)";
//        if (cache.keys.contains(fullCacheKey)) {
//            print("Cache hit for \(fullCacheKey): \(level) + \(maxLevel - level)= \(cache[fullCacheKey]!)")
//            return cache[fullCacheKey]!;
//        }
        
        for i in 1..<withImplicitStart.count {
            let startIndex = withImplicitStart.index(withImplicitStart.startIndex, offsetBy: i - 1);
            let endIndex = withImplicitStart.index(withImplicitStart.startIndex, offsetBy: i);
            let cacheKey = "\(withImplicitStart[startIndex...endIndex]):\(maxLevel - level)"
//            print("\tFor path: \(withImplicitStart) looking for cacheKey: \(cacheKey) at level \(level)")
            if (cache.keys.contains(cacheKey)) {
//                print("\tCACHE HIT for \(cacheKey) = \(cache[cacheKey]!)")
                cost += cache[cacheKey]!
                continue;
            }
            // TODO: look for bigger prefixes in the cache!
            let directions = findEfficientDirectionalPaths(findShortestPaths(map: directional, curr: directional[withImplicitStart[i - 1]!]!, target: directional[withImplicitStart[i]!]!).map{ translateToDirectional(path: $0 )})
            
            var smallestExpansionCost = 100000000000000000;
            for direction in directions {
                let expansionCost = expand(curr: direction + "A", level: level + 1);
                if (expansionCost < smallestExpansionCost) {
                    smallestExpansionCost = expansionCost;
                }
            }
            cost += smallestExpansionCost;
        }
        
        print("Caching \(withImplicitStart):\(maxLevel - level) = \(cost)")
        if (level < 15) {
            print("For \(curr) found cost: \(cost) at level \(level)")
        }
        cache["\(withImplicitStart):\(maxLevel - level)"] = cost;
        return cost;
    }
    
    func findEfficientDirectionalPaths(_ paths: [String]) -> [String] {
        if (paths.count == 1) {
            return paths
        }
        var collapsedCounts = [String:Int]();
        var smallestCount = 100000000;
        for dir in paths {
            
            var collapsed = "";
            for i in 1...dir.count {
                if (i == dir.count) {
                    collapsed += dir[i - 1]!;
                } else if (dir[i] != dir[i - 1]) {
                    collapsed += dir[i - 1]!;
                }
            }
            //                if (collapsed.count < dir.count) {
            //                    print("Collapsed \(dir) to \(collapsed)")
            //                }
            if collapsed.count < smallestCount {
                smallestCount = collapsed.count;
            }
            collapsedCounts[dir] = collapsed.count;
        }
        var shorterCodes = [String]();
        for (key, count) in collapsedCounts {
            if (count == smallestCount) {
                shorterCodes.append(key);
            }
        }

        return shorterCodes.sorted { $0 < $1 }
    }
}
