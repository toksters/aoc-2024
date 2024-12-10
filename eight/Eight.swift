//
//  Eight.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/8/24.
//

import Foundation


class Eight: Problem {
    
    var antennae: [String:Set<Point>] = [:]
    
    var antinodes: [String:Set<Point>] = [:]
    
    var edge = Point(0, 0);
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            for (x, char) in line.enumerated() {
                let antenna = String(char);
                let point = Point(x, y);
                if (antenna == ".") {
                    continue;
                }
                if (antennae.keys.contains(antenna)) {
                    antennae[antenna]!.insert(point);
                } else {
                    antennae[antenna] = [point]
                }
            }
        }
        edge = Point(input.count - 2, input[0].count - 1)
        
        print("Initialized edge to \(edge) and antennae to \(antennae)")
    
    }
    
    func execPart1() throws {
        for key in antennae.keys {
            let locations = Array(antennae[key]!);
            for i in 0..<locations.count {
                for j in 0..<locations.count {
                    if (i == j) {
                        continue;
                    }
                    let antinode = findAntinode(first: locations[i], second: locations[j]);
                    if antinodes.keys.contains(key) {
                        antinodes[key]!.insert(antinode);
                    } else {
                        antinodes[key] = [antinode];
                    }
                    
                }
            }
        }
        print("antinodes: \(antinodes)");
        var allAntinodes: Set<Point> = [];
        for key in antinodes.keys {
            allAntinodes = allAntinodes.union(antinodes[key]!);
        }
        
        allAntinodes = allAntinodes.filter { isInBounds($0) }
        
        print("all antinodes: \(allAntinodes)")
        print("antinodes count: \(allAntinodes.count)")
        
        // 368 is too high
    }
    
    func findAntinode(first: Point, second: Point) -> Point {
        // source = (5, 2), other = (8, 1), antinode = (2, 3);
        let xDiff = first.x - second.x;
        let yDiff = first.y - second.y;
        
        return Point(first.x + xDiff, first.y + yDiff);
    }
    
    func findAntinodes(first: Point, second: Point) -> [Point] {
        // source = (5, 2), other = (8, 1), antinode = (2, 3);
        let xDiff = first.x - second.x;
        let yDiff = first.y - second.y;
        
        var antinodes: [Point] = [];
        var currPoint = Point(first.x + xDiff, first.y + yDiff);
        
        var multiple = 2;
        while (isInBounds(currPoint)) {
            antinodes.append(currPoint);
            currPoint = Point(first.x + (xDiff*multiple), first.y + (yDiff*multiple));
            multiple = multiple + 1;
        }
        return antinodes;
    }
    
    func isInBounds(_ point: Point) -> Bool {
        return point.x >= 0 && point.y >= 0 && point.x <= edge.x && point.y <= edge.y
    }
    
    func execPart2() throws{
        for key in antennae.keys {
            let locations = Array(antennae[key]!);
            for i in 0..<locations.count {
                for j in 0..<locations.count {
                    if (i == j) {
                        continue;
                    }
                    let antinodesList = findAntinodes(first: locations[i], second: locations[j]);
                    if antinodes.keys.contains(key) {
                        antinodes[key] = antinodes[key]!.union(antinodesList);
                    } else {
                        antinodes[key] = Set(antinodesList);
                    }
                    
                }
            }
        }
        print("antinodes: \(antinodes)");
        var allAntinodes: Set<Point> = [];
        for key in antinodes.keys {
            allAntinodes = allAntinodes.union(antinodes[key]!);
        }
        
        allAntinodes = allAntinodes.filter { isInBounds($0) }
        
        for antenna in antennae.keys {
            let antennaLocations = antennae[antenna]!;
            if (antennaLocations.count > 2) {
                allAntinodes = allAntinodes.union(antennaLocations)
            }
        }
        
        print("all antinodes: \(allAntinodes)")
        print("antinodes count: \(allAntinodes.count)")
    }
}
