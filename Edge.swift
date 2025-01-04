//
//  Edge.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/18/24.
//

import Foundation

struct Edge: Hashable, Equatable, CustomStringConvertible {
    var from: Point;
    var to: Point;
    var cost: Int;
    
    public var description: String { return "(\(from)->\(to): $\(cost))" }
    
    init(_ from: Point, _ to: Point, _ cost: Int) {
        self.from = from;
        self.to = to;
        self.cost = cost;
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(from);
        hasher.combine(to);
        hasher.combine(cost);
    }
    
    static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to && lhs.cost == rhs.cost;
    }
}
