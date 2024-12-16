//
//  Fourteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/14/24.
//

import Foundation

class Fourteen: Problem {
    
    let filename = "sample.txt";
    
    var robots: [Robot] = [];
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func getEdge() -> Point {
        return robots.count > 100 ? Point(101, 103) : Point(11, 7)
    }
    
    func prep() throws {
        for (i, line) in input.enumerated() {
            if (line.isEmpty) {
                continue;
            }
            let tokens = line.components(separatedBy: " v=");
            let posTokens = tokens[0].components(separatedBy: "p=")[1].components(separatedBy: ",");
            let velocityTokens = tokens[1].components(separatedBy: ",")
            print(tokens)
            let pos = Point(Int(posTokens[0])!, Int(posTokens[1])!);
            let velocity = Point(Int(velocityTokens[0])!, Int(velocityTokens[1])!);
            robots.append(Robot("\(i)", pos, velocity))
        }
        
        print(robots);
    }
    
    func execPart1() throws {
        let edge = getEdge()
        for _ in 0..<100 {
            for robot in robots {
                robot.move(edge: edge);
            }
        }
        var quadrantCounts = [0, 0, 0, 0];
        for robot in robots {
            print("Evaluating robot in: \(robot.pos)")
            if let quadrant = getQuadrant(point: robot.pos) {
                quadrantCounts[quadrant] += 1;
            }
        }
        
        let safetyFactor = quadrantCounts.reduce(1, *);
        print("Safety factor: \(safetyFactor)")
    }
    
    func getQuadrant(point: Point) -> Int? {
        let edge = getEdge();
        let xMid = (edge.x - 1) / 2;
        let yMid = (edge.y - 1) / 2
        if (point.x == xMid || point.y == yMid) {
            return nil;
        }
        if (point.x < xMid && point.y < yMid) {
            return 0;
        } else if (point.x > xMid && point.y < yMid) {
            return 1;
        } else if (point.x < xMid && point.y > yMid) {
            return 2;
        } else if (point.x > xMid && point.y > yMid) {
            return 3;
        }
        
        print("Found a weird coordinate not in a quadrant: \(point)")
        return nil;
    }
    
    func execPart2() throws {
        robots = [];
        try prep();
        let edge = getEdge()
        for i in 1..<10000 {
            for robot in robots {
                robot.move(edge: edge);
            }
            
//            var quadrantCounts = [0, 0, 0, 0];
//            for robot in robots {
//                if let quadrant = getQuadrant(point: robot.pos) {
//                    quadrantCounts[quadrant] += 1;
//                }
//            }
//
//            if (quadrantCounts[0] == quadrantCounts[1] && quadrantCounts[2] == quadrantCounts[3]) {
//                print("Possible christmas tree at seconds: \(i + 1)")
            //                printMap()
            //            }
            
            if (i == 6993 || i == 7093) {
                print("Possible christmas tree at seconds: \(i)")
                printMap()
            }
            // 10831
            // 10730
            
            // 1034
            // 933
            
            // 6994 is too low
            // 6993 is incorrect
        }
    }
    
    func printMap() {
        let map: Set<Point> = Set(robots.map { $0.pos });
        let edge = getEdge();
        var image = "";
        for y in 0..<edge.y {
            var line = "";
            for x in 0..<edge.x {
                if (map.contains(Point(x, y))) {
                    line += "*";
                } else {
                    line += " "
                }
            }
            line += "\n"
            image += line;
        }
        print(image);
    }
    
    class Robot: CustomStringConvertible {
        var name: String;
        var pos: Point;
        var velocity: Point;
        
        public var description: String { return "\(name): \(pos) -> \(velocity)" }
        
        init(_ name: String, _ pos: Point, _ velocity: Point) {
            self.name = name;
            self.pos = pos;
            self.velocity = velocity;
        }
        
        func move(edge: Point) {
            let newX = (pos.x + velocity.x) % edge.x;
            let newY = (pos.y + velocity.y) % edge.y;
            
            let actualX = newX < 0 ? edge.x + newX : newX;
            let actualY = newY < 0 ? edge.y + newY : newY;
            self.pos = Point(actualX, actualY)
        }
    }
}
