//
//  Six.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/6/24.
//

import Foundation


class Six: Problem {
    
    var pos: Point = Point(0, 0);
    
    var initialPos: Point = Point(0, 0);
    
    var direction = Direction.N;
    
    var obstacles: Set<Point> = [];
    
    var edge: Point = Point(0, 0);
    
    enum Direction {
        case N, S, E, W;
    }
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            if line.isEmpty {
                edge = Point(input[0].count - 1, y - 1);
                print("Set edge to \(edge)")
                continue;
            }
            for (x, char) in line.enumerated() {
                if (char == "^") {
                    pos = Point(x, y);
                    initialPos = Point(x, y);
                    print("Assigning guard initial position of \(pos)")
                    continue;
                }
                if (char == "#") {
                    obstacles.insert(Point(x, y));
                }
            }
        }
        print("Initialization complete")
        print("Pos \(pos), obstacles: \(obstacles)")
    }
    
    func execPart1() throws {
        var visited: Set<Point> = [pos];
        
        while(pos.x > 0 && pos.y > 0 && pos.x < edge.x && pos.y < edge.y) {
            visited.insert(step());
        }
        
        print("Visited count: \(visited.count)")
    }
    
    func step() -> Point {
        var nextStep = getNextStep();
        while (obstacles.contains(nextStep)) {
            rotate();
            nextStep = getNextStep();
        }
        pos = nextStep;
        return pos;
    }
    
    func getNextStep() -> Point {
        if (direction == Direction.N) {
            return Point(pos.x, pos.y - 1);
        } else if (direction == Direction.E) {
            return Point(pos.x + 1, pos.y);
        } else if (direction == Direction.S) {
            return Point(pos.x, pos.y + 1);
        } else if (direction == Direction.W) {
            return Point(pos.x - 1, pos.y);
        }
        print("WARN: Unrecognized direction. Staying in place")
        return pos;
    }
    
    let nextDirections = [Direction.N: Direction.E, Direction.E: Direction.S, Direction.S: Direction.W, Direction.W: Direction.N];
    
    func rotate() {
        direction = nextDirections[direction]!;
    }
    
    func execPart2() throws {
        pos = initialPos;
        var validBarriers: Set<Point> = [];
        for y in 0...edge.y {
            for x in 0...edge.x {
                let barrier = Point(x, y);
                if (obstacles.contains(barrier)) {
                    continue;
                }
                if (pos == barrier) {
                    continue;
                }
//                print("Considering barrier at: \(barrier)")
                obstacles.insert(barrier);
                if (runUntilExitOrLoop()) {
                    print("Found a loop for barrier at: \(barrier)")
                    validBarriers.insert(barrier);
                }
                pos = initialPos;
                direction = Direction.N;
                obstacles.remove(barrier);
            }
        }
        print("Valid Barriers: \(validBarriers), Size \(validBarriers.count)")
    }
    
    func runUntilExitOrLoop() -> Bool {
        var visited: Set<String> = [];
                
        while(pos.x > 0 && pos.y > 0 && pos.x < edge.x && pos.y < edge.y) {
            let stepped = "\(step()):\(direction)"
            if (visited.contains(stepped)) {
                return true;
            }
            visited.insert(stepped);
        }
        return false;
    }
}
