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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x);
        hasher.combine(y);
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y;
    }
}
