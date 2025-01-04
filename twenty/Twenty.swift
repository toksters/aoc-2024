//
//  Twenty.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/20/24.
//

import Foundation

class Twenty: Problem {
    
    var walls = Set<Point>();
    
    var end = Point(0, 0);
    
    var start = Point(0, 0);
    
    var edge = Point(0, 0);
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            if (line.isEmpty) {
                edge = Point(input[0].count, y);
                continue;
            }
            
            for (x, char) in line.enumerated() {
                let point = Point(x, y);
                if (char == "#") {
                    walls.insert(point);
                } else if (char == "E") {
                    end = point;
                } else if (char == "S") {
                    start = point;
                }
            }
        }
        
        print("walls: \(walls)")
        print("start: \(start)")
        print("end: \(end)")
    }
    
    func execPart1() throws {
        // find the route without cheating
        let path = getPath();
        let indexes = path.enumerated().reduce(into: [Point:Int]()) {
            $0[$1.1] = $1.0
        }
        print("standard path takes \(path.count - 1) picoseconds");

        let isPossibleCheat = { currInd, newPos in
            !self.walls.contains(newPos) && indexes.keys.contains(newPos) && indexes[newPos]! > currInd
        }
        
        var bestSavings = 0;
        // then for every point, consider the positions available by cheating
        // NN, NE, SS, SE, EE, WW, SW, NW
        var savingsCount = 0;
        let savingsThreshold = 99;
        for (i, pos) in path.enumerated() {
            let north = pos.getNorth().getNorth();
            if (isPossibleCheat(i, north)) {
                let savings = indexes[north]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(north) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let south = pos.getSouth().getSouth();
            if (isPossibleCheat(i, south)) {
                let savings = indexes[south]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(south) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let east = pos.getEast().getEast();
            if (isPossibleCheat(i, east)) {
                let savings = indexes[east]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(east) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let west = pos.getWest().getWest();
            if (isPossibleCheat(i, west)) {
                let savings = indexes[west]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(west) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let northeast = pos.getNorth().getEast();
            if (isPossibleCheat(i, northeast)) {
                let savings = indexes[northeast]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(northeast) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let southeast = pos.getSouth().getEast();
            if (isPossibleCheat(i, southeast)) {
                let savings = indexes[southeast]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(southeast) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let southwest = pos.getSouth().getWest();
            if (isPossibleCheat(i, southwest)) {
                let savings = indexes[southwest]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(southwest) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
            
            let northwest = pos.getNorth().getWest();
            if (isPossibleCheat(i, northwest)) {
                let savings = indexes[northwest]! - i - 2;
                if (savingsThreshold < savings) {
                    savingsCount += 1
                    print("Found optimal cheat from \(pos) to \(northwest) with \(savings) picoseconds")
                    bestSavings = savings;
                }
            }
        }
        
        print("\(savingsCount) cheats are >= \(savingsThreshold + 1)")
    }
    
    func getPath() -> [Point] {
        var pos = start;
        var path = [Point]();
        var visited = Set<Point>();
        
        let canMove = { adj in !visited.contains(adj) && !self.walls.contains(adj) };
        path.append(pos);
        visited.insert(pos);
        while pos != end {
            if (canMove(pos.getNorth())) {
                pos = pos.getNorth();
            } else if (canMove(pos.getSouth())) {
                pos = pos.getSouth()
            } else if (canMove(pos.getEast())) {
                pos = pos.getEast();
            } else if (canMove(pos.getWest())) {
                pos = pos.getWest();
            } else {
                print("ERROR: Could not find path at: pos = \(pos)")
                break;
            }
            path.append(pos)
            visited.insert(pos);
        }
        return path;
    }
    
    func execPart2() throws{
        // find the route without cheating
        let path = getPath();
        let indexes = path.enumerated().reduce(into: [Point:Int]()) {
            $0[$1.1] = $1.0
        }
        print("standard path takes \(path.count - 1) picoseconds");

        let isPossibleCheat = { currInd, newPos in
            !self.walls.contains(newPos) && indexes.keys.contains(newPos) && indexes[newPos]! > currInd
        }
        
        // (1, 3), (5, 7) distance = abs(1 - 5) + abs(3 - 7) = 4 + 4 = 8
        let manhattanDist: (Point, Point) -> Int = { first, second in abs(first.x - second.x) + abs(first.y - second.y) }
        
        // if manhattan distance <= 20
        let savingsGoal = 100;
        var niceCheats = 0;
        for starting in path {
            for ending in path {
                if (indexes[starting]! >= indexes[ending]!) {
                    continue;
                }
                
                let manhattanDist = manhattanDist(starting, ending);
                if (manhattanDist <= 20) {
                    let savings = indexes[ending]! - indexes[starting]! - manhattanDist;
                    if (savings >= savingsGoal) {
                        niceCheats += 1;
                    }
                }
            }
        }
        
        print("There are \(niceCheats) that save at least \(savingsGoal) picoseconds")
    }
}
