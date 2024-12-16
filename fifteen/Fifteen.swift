//
//  Fifteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/15/24.
//

import Foundation

class Fifteen: Problem {
    
    var walls: Set<Point> = [];
    
    var boxes: Set<Point> = [];
    
    var pos: Point = Point(0, 0);
    
    var moves: [Direction] = [];
    
    var edge = Point(0, 0);
    
    init() throws {
//        try super.init(filename: "small-sample.txt", filepath: #file)
//        try super.init(filename: "sample.txt", filepath: #file)
//        try super.init(filename: "custom-sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var mapInput = true;
        for (y, line) in input.enumerated() {
            if (line.isEmpty) {
                edge = edge == Point(0,0) ? Point(input[0].count, y) : edge;
                mapInput = false;
                continue;
            }
            
            if (mapInput) {
                for (x, char) in line.enumerated() {
                    let point = Point(x, y);
                    if (char == "#") {
                        walls.insert(point);
                    } else if (char == "O") {
                        boxes.insert(point);
                    } else if (char == "@") {
                        pos = point;
                    }
                }
            } else {
                for (_, char) in line.enumerated() {
                    var direction: Direction? = nil;
                    switch (char) {
                    case "<":
                        direction = Direction.W;
                        break;
                    case ">":
                        direction = Direction.E;
                        break;
                    case "^":
                        direction = Direction.N;
                        break;
                    case "v":
                        direction = Direction.S;
                        break;
                    default:
                        print("ERROR: Unknown directional character encountered \(char)");
                    }
                    moves.append(direction!);
                }
            }
        }
        
        print("Edge: \(edge)")
        
//        print("moves: \(moves)")
//        print("boxes: \(boxes)")
//        print("pos: \(pos)")
    }
    
    func execPart1() throws {
        for move in moves {
            print("Pos: \(pos), move: \(move)")
            let nextPos = pos.getDirection(move);
            if (walls.contains(nextPos)) {
                continue;
            }
            if (boxes.contains(nextPos)) {
                var boxNextPos = nextPos.getDirection(move);
                var spaceFound = true;
                while (boxes.contains(boxNextPos) || walls.contains(boxNextPos)) {
                    if (walls.contains(boxNextPos)) {
                        spaceFound = false;
                        break;
                    }
                    boxNextPos = boxNextPos.getDirection(move);
                }
                if (!spaceFound) {
                    continue;
                }
//                print("Pushing box from \(nextPos) to \(boxNextPos)")
                boxes.remove(nextPos);
                boxes.insert(boxNextPos);
            }
            pos = nextPos;
        }
        
        var sum = 0;
        for box in boxes {
            sum += box.y * 100 + box.x;
        }
        
        print("Sum: \(sum)")
    }
    
    func execPart2() throws {
        walls = [];
        boxes = [];
        moves = [];
        try prep();
        edge = Point(edge.x * 2, edge.y);
        var bigBoxes: [Point:String] = [:];
        for box in boxes {
            bigBoxes[Point(box.x * 2, box.y)] = "[";
            bigBoxes[Point(box.x * 2 + 1, box.y)] = "]";
        }
        
        pos = Point(pos.x * 2, pos.y);
        var newWalls: Set<Point> = [];
        for wall in walls {
            newWalls.insert(Point(wall.x * 2, wall.y))
            newWalls.insert(Point(wall.x * 2 + 1, wall.y))
        }
        walls = newWalls;
        
        print("pos: \(pos)")
        print("bigBoxes: \(bigBoxes)")
        print("walls: \(walls)")
        
        print("Starting map: ")
        printMap(bigBoxes: bigBoxes);
        
        for move in moves {
            print("Pos: \(pos), move: \(move)")
            let nextPos = pos.getDirection(move);
            if (walls.contains(nextPos)) {
                continue;
            }
            if (bigBoxes.keys.contains(nextPos)) {
                var spaceFound = true;
                
                let boxLeft = bigBoxes[nextPos] == "[" ? nextPos.getEast() : nextPos;
                let boxRight = bigBoxes[nextPos] == "]" ? nextPos.getWest() : nextPos;
                
//                var boxLeftNextPos = boxLeft.getDirection(move);
//                var boxRightNextPos = boxRight.getDirection(move);
                
                var spacesToConsider: [Point] = [boxLeft, boxRight];
                var boxesToRemove: Set<Point> = [];
                var boxesToAdd: [Point:String] = [:]
                var active = true;
                while (active && (containsAny(Set(bigBoxes.keys), spacesToConsider) || containsAny(walls, spacesToConsider))) {
                    if (containsAny(walls, spacesToConsider)) {
                        spaceFound = false;
                        break;
                    }
                    
                    var newSpacesToConsider: [Point] = []
                    let isUpDown = move == Direction.N || move == Direction.S;
//                    print("Spaces to consider: \(spacesToConsider)")
                    for space in spacesToConsider {
                        if (!isUpDown && !bigBoxes.keys.contains(space)) {
                            active = false;
                            break;
                        }
                        
                        var appended = false;
                        if (bigBoxes.keys.contains(space)) {
                            appended = true;
                            newSpacesToConsider.append(space.getDirection(move))
                        }
                        boxesToRemove.insert(space);
                        boxesToAdd[space.getDirection(move)] = bigBoxes[space];
                        
                        // need to account for case going south:
                        //
                        // ...@
                        // ..[]
                        // .[]..
                        // ...[]
                        
                        if (isUpDown && appended && bigBoxes[space.getDirection(move)] ?? "" == "]") {
                            newSpacesToConsider.append(space.getDirection(move).getWest())
                        } else if (isUpDown && appended && bigBoxes[space.getDirection(move)] ?? "" == "[") {
                            newSpacesToConsider.append(space.getDirection(move).getEast())
                        }
                    }
                    spacesToConsider = Array(newSpacesToConsider);
                }
                if (!spaceFound) {
                    //printMap(bigBoxes: bigBoxes)
                    continue;
                }
                
                print("Completed moving assessment with space found = \(spaceFound)")
//                print("Pushing box from \(nextPos) to \(boxNextPos)")
                
                // TODO: refactor shift
                
                for box in boxesToRemove {
                    bigBoxes.removeValue(forKey: box);
                }
                for box in boxesToAdd.keys {
                    bigBoxes[box] = boxesToAdd[box]!;
                }
                print("\(bigBoxes)")
            }
            pos = nextPos;
//            printMap(bigBoxes: bigBoxes)
        }
        
        var sum = 0;
        for key in bigBoxes.keys {
            if (bigBoxes[key] == "]") {
                continue;
            }
            sum += key.x + key.y  * 100
        }
        print("Sum: \(sum)")
        printMap(bigBoxes: bigBoxes)
        
    }
    
    func printMap(bigBoxes: [Point:String]) {
        var map = "";
        for y in 0..<edge.y {
            for x in 0..<edge.x {
                let point = Point(x, y);
                if walls.contains(point) { map += "#" }
                else if bigBoxes.keys.contains(point) { map += bigBoxes[point]! }
                else if pos == point { map += "@" }
                else { map += "." }
            }
            map += "\n"
        }
        
        print(map);
    }
    
    func containsAny(_ set: Set<Point>, _ elements: [Point]) -> Bool {
        for element in elements {
            if (set.contains(element)) {
                return true;
            }
        }
        return false;
    }
}
