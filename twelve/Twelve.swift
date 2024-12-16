//
//  Twelve.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/12/24.
//

import Foundation

class Twelve: Problem {
    
    var garden: [Point:String] = [:];
    
    var edge = Point(0, 0)
    
    var groups: [String:Set<Point>] = [:]
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
                try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            if (line.isEmpty) { continue }
            for (x, char) in line.enumerated() {
                garden[Point(x, y)] = String(char);
            }
        }
        edge = Point(input[0].count - 1, input.count - 2);
        print("Set edge to \(edge)")
    }
    
    func execPart1() throws {
        var unexplored: Set<Point> = Set(Array(garden.keys));
        
        var priceSum = 0;
        while (!unexplored.isEmpty) {
            for y in 0...edge.y {
                for x in 0...edge.x {
                    if (unexplored.contains(Point(x, y))) {
                        let plant = garden[Point(x, y)]!;
                        let explored = exploreGroup(Point(x, y), locallyExplored: [], unexplored: unexplored);
                        let perimeter = getPerimeter(explored);
                        priceSum += explored.count * perimeter;
                        var plantName = plant;
                        while(groups.keys.contains(plantName)) {
                            plantName += plant;
                        }
                        print("Found group for plant \(plantName) \(explored.count): \(perimeter)");
                        groups[plantName] = explored;
                        unexplored = unexplored.subtracting(explored)
                    }
                }
            }
        }
        print("Total price: \(priceSum)")
    }
    
    func exploreGroup(_ pos: Point, locallyExplored: Set<Point>, unexplored: Set<Point>) -> Set<Point> {
        
        let plant = garden[pos]!;
        
        // TODO: base case???
        
        var explored: Set<Point> = locallyExplored.union([pos]);
        
        // explore north
        let north = Point(pos.x, pos.y - 1);
        if (!explored.contains(north) && unexplored.contains(north) && garden[north]! == plant) {
            let newUnexplored = unexplored.subtracting([north])
            let northRes = exploreGroup(north, locallyExplored: explored, unexplored: newUnexplored);
            explored = explored.union(northRes);
        }
        
        // explore east
        let east = Point(pos.x + 1, pos.y)
        if (!explored.contains(east) && unexplored.contains(east) && garden[east]! == plant) {
            let newUnexplored = unexplored.subtracting([east])
            let eastRes = exploreGroup(east, locallyExplored: explored, unexplored: newUnexplored);
            explored = explored.union(eastRes);
        }
        
        // explore south
        let south = Point(pos.x, pos.y + 1)
        if (!explored.contains(south) && unexplored.contains(south) && garden[south]! == plant) {
            let newUnexplored = unexplored.subtracting([south])
            let southRes = exploreGroup(south, locallyExplored: explored, unexplored: newUnexplored);
            explored = explored.union(southRes);
        }
        
        // explore west
        let west = Point(pos.x - 1, pos.y);
        if (!explored.contains(west) && unexplored.contains(west) && garden[west]! == plant) {
            let newUnexplored = unexplored.subtracting([west])
            let westRes = exploreGroup(west, locallyExplored: explored, unexplored: newUnexplored);
            explored = explored.union(westRes);
        }
        
        return explored;
    }
    
    func getPerimeter(_ group: Set<Point>) -> Int {
        var perimeter = 0;
        for plant in group {
            let adjacentPlants = group.intersection([plant.getEast(), plant.getWest(), plant.getNorth(), plant.getSouth()]);
            perimeter += 4 - adjacentPlants.count;
        }
        return perimeter;
    }
    
    func execPart2() throws {
        var total = 0;
        for key in groups.keys {
            let group = groups[key]!;
            let sides = getSides(group);
            print("Price for \(key) is area \(group.count) * sides \(sides) = \(group.count * sides)")
            total += group.count * sides;
        }
        
        print("Part 2 total: \(total)")
        
        // 793320 is too low!
        // 812096 still too low
    }
    
    func getSides(_ group: Set<Point>) -> Int {
        var sides = 0;
        var edges: Set<Edge> = [];
        
        for plant in group {
            if (!group.contains(plant.getNorth())) {
                edges.insert(Edge(plant, Direction.N))
            }
            if (!group.contains(plant.getEast())) {
                edges.insert(Edge(plant, Direction.E))
            }
            if (!group.contains(plant.getWest())) {
                edges.insert(Edge(plant, Direction.W))
            }
            if (!group.contains(plant.getSouth())) {
                edges.insert(Edge(plant, Direction.S))
            }
        }
//        print("edges: \(edges)")
        
        var unexploredEdges = Set(edges);
        var exploredEdges: Set<Edge> = [];
        while (!unexploredEdges.isEmpty) {
            let currEdge = unexploredEdges.removeFirst()
            let explored = exploreSide(currEdge, locallyExplored: exploredEdges, unexploredEdges: unexploredEdges);
            exploredEdges = exploredEdges.union(explored);
            unexploredEdges = unexploredEdges.subtracting(explored);
//            print("Found side for \(currEdge.pos) and \(currEdge.side) with size: \(explored.count)")
            sides += 1;
        }
        
        return sides;
    }
    
    func exploreSide(_ edge: Edge, locallyExplored: Set<Edge>, unexploredEdges: Set<Edge>) -> Set<Edge> {
        var directionToMove = Direction.S;
        if (edge.side == Direction.N || edge.side == Direction.S) {
            directionToMove = Direction.E;
        }
        
        var explored = locallyExplored.union([edge]);
        var newUnexplored = unexploredEdges.subtracting([edge]);
        
        if (directionToMove == Direction.E) {
            let rightEdge = Edge(edge.pos.getEast(), edge.side);
            let leftEdge = Edge(edge.pos.getWest(), edge.side);
            if (unexploredEdges.contains(rightEdge) && !explored.contains(rightEdge)) {
                explored = explored.union(exploreSide(rightEdge, locallyExplored: explored, unexploredEdges: newUnexplored));
                newUnexplored = unexploredEdges.subtracting(explored);
            }
            if (unexploredEdges.contains(leftEdge) && !explored.contains(leftEdge)) {
                explored = explored.union(exploreSide(leftEdge, locallyExplored: explored, unexploredEdges: newUnexplored))
                newUnexplored = unexploredEdges.subtracting(explored);
            }
        }
        
        if (directionToMove == Direction.S) {
            let topEdge = Edge(edge.pos.getNorth(), edge.side);
            let bottomEdge = Edge(edge.pos.getSouth(), edge.side);
            if (unexploredEdges.contains(topEdge) && !explored.contains(topEdge)) {
                explored = explored.union(exploreSide(topEdge, locallyExplored: explored, unexploredEdges: newUnexplored));
                newUnexplored = unexploredEdges.subtracting(explored);
            }
            if (unexploredEdges.contains(bottomEdge) && !explored.contains(bottomEdge)) {
                explored = explored.union(exploreSide(bottomEdge, locallyExplored: explored, unexploredEdges: newUnexplored))
                newUnexplored = unexploredEdges.subtracting(explored);
            }
        }
        
        return explored;
    }

    
    enum Direction {
        case N, S, E, W;
    }
    
    struct Edge: Hashable, Equatable, CustomStringConvertible {
        var pos: Point;
        var side: Direction;
        
        public var description: String { return "(\(pos),\(side))" }
        
        init(_ pos: Point, _ side: Direction) {
            self.pos = pos;
            self.side = side;
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pos);
            hasher.combine(side);
        }
        
        static func ==(lhs: Edge, rhs: Edge) -> Bool {
            return lhs.pos == rhs.pos && lhs.side == rhs.side;
        }
    }
}
