//
//  Point.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/8/24.
//

import Foundation

class Point: Hashable, Equatable, CustomStringConvertible {
    var x: Int;
    var y: Int;
    
    public var description: String { return "(\(x),\(y))" }
    
    init(_ x: Int, _ y: Int) {
        self.x = x;
        self.y = y;
    }
    
    func getWest() -> Point {
        return Point(x - 1, y);
    }
    
    func getNorth() -> Point  {
        return Point(x, y - 1);
    }
    
    func getSouth() -> Point  {
        return Point(x, y + 1);
    }
    
    func getEast() -> Point  {
        return Point(x + 1, y);
    }
    
    func getDirection(_ direction: Direction) -> Point {
        switch (direction) {
        case Direction.N:
            return getNorth();
        case Direction.S:
            return getSouth();
        case Direction.E:
            return getEast();
        case Direction.W:
            return getWest();
        }
    }
    
    // from (x,y) format
    static func fromString(_ str: String) -> Point {
        var strMut = str;
        strMut.removeLast();
        strMut.removeFirst();
        let tokens = strMut.components(separatedBy: ",");
        return Point(Int(tokens[0])!, Int(tokens[1])!)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x);
        hasher.combine(y);
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y;
    }
}

enum Direction: String, CustomStringConvertible {
        
    case N = "N";
    case S = "S";
    case E = "E";
    case W = "W";
    
    public var description: String { return "\(self.rawValue)" }
}
