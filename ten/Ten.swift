//
//  Ten.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/10/24.
//

import Foundation

class Ten: Problem {
    
    var map: [Point:Int] = [:]
    
    var trailheads: Set<Point> = []
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            if (line.isEmpty) {
                continue;
            }
            for(x, char) in line.enumerated() {
                let elevation = Int(String(char))!;
                map[Point(x, y)] = elevation;
                if (elevation == 0) {
                    trailheads.insert(Point(x, y))
                }
            }
        }
//        print("\(map), \(trailheads)")
    }
    
    func execPart1() throws {
        var sum = 0;
        for trailhead in trailheads {
            let score = Set(explore(currPos: trailhead, explored: [])).count
            print("Trailhead \(trailhead) has a score of \(score)");
            sum += score
        }
        
        print("sum = \(sum)")
    }
    
    func explore(currPos: Point, explored: [Point]) -> [Point] {
        let currElevation = map[currPos]!;
        if (currElevation == 9) {
//            print("Found trailhead end with path \(explored + [currPos])")
            return [currPos];
        }
        
        let targetElevation = currElevation + 1;
        
        let shouldExplore = { point in
            return !explored.contains(point) && self.map.keys.contains(point) && self.map[point] == targetElevation;
        }
        
        var trailcount: [Point] = [];
        
        // north
        let north = Point(currPos.x, currPos.y - 1);
        if (shouldExplore(north)) {
            var newExplored = explored + [currPos];
            trailcount += explore(currPos: north, explored: newExplored);
        }
        
        // south
        let south = Point(currPos.x, currPos.y + 1);
        if (shouldExplore(south)) {
            var newExplored = explored + [currPos];
            trailcount += explore(currPos: south, explored: newExplored);
        }
        
        // east
        let east = Point(currPos.x + 1, currPos.y);
        if (shouldExplore(east)) {
            var newExplored = explored + [currPos];
            trailcount += explore(currPos: east, explored: newExplored);
        }
        
        // west
        let west = Point(currPos.x - 1, currPos.y);
        if (shouldExplore(west)) {
            var newExplored = explored + [currPos];
            trailcount += explore(currPos: west, explored: newExplored);
        }
        
        return trailcount;
    }
    
    func execPart2() throws{
        var sum = 0;
        for trailhead in trailheads {
            let score = exploreRating(currPos: trailhead, explored: []);
            print("Trailhead \(trailhead) has a score of \(score)");
            sum += score
        }
        
        print("sum = \(sum)")
    }
    
    func exploreRating(currPos: Point, explored: [Point]) -> Int {
        let currElevation = map[currPos]!;
        if (currElevation == 9) {
//            print("Found trailhead end with path \(explored + [currPos])")
            return 1;
        }
        
        let targetElevation = currElevation + 1;
        
        let shouldExplore = { point in
            return !explored.contains(point) && self.map.keys.contains(point) && self.map[point] == targetElevation;
        }
        
        var trailcount = 0;
        
        // north
        let north = Point(currPos.x, currPos.y - 1);
        if (shouldExplore(north)) {
            var newExplored = explored + [currPos];
            trailcount += exploreRating(currPos: north, explored: newExplored);
        }
        
        // south
        let south = Point(currPos.x, currPos.y + 1);
        if (shouldExplore(south)) {
            var newExplored = explored + [currPos];
            trailcount += exploreRating(currPos: south, explored: newExplored);
        }
        
        // east
        let east = Point(currPos.x + 1, currPos.y);
        if (shouldExplore(east)) {
            var newExplored = explored + [currPos];
            trailcount += exploreRating(currPos: east, explored: newExplored);
        }
        
        // west
        let west = Point(currPos.x - 1, currPos.y);
        if (shouldExplore(west)) {
            var newExplored = explored + [currPos];
            trailcount += exploreRating(currPos: west, explored: newExplored);
        }
        
        return trailcount;
    }
    
    enum Direction {
        case N, S, E, W
    }
}
