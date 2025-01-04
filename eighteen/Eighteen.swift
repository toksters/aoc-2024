//
//  Eighteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/18/24.
//

import Foundation

class Eighteen: Problem {
    
    var byteLimit: Int;
    
    var goal = Point(0, 0);
        
    var walls: Set<Point> = [];
    
    init() throws {
//      byteLimit = 12; goal = Point(6, 6); try super.init(filename: "sample.txt", filepath: #file);
        byteLimit = 1024; goal = Point(70, 70); try super.init(filepath: #file);
        try prep(limit: byteLimit);
    }
    
    func prep(limit: Int) throws {
        for (y, line) in input.enumerated() {
            if (line.isEmpty || y == limit) {
                break;
            }
            let tokens = line.components(separatedBy: ",").map { Int($0)!}
            walls.insert(Point(tokens[0], tokens[1]))
        }
    }
    
    func execPart1() throws -> Int {
        // dijkstras
        let pos = Point(0, 0);
        let graph = buildGraph();
        var costs: [Point:Int] = [:];
        var paths: [Point:[Point]] = [:]; // stores prevous nodes for the optimal path
        for node in graph.keys {
            costs[node] = 10000000000000;
        }
//        print(graph);
        costs[pos] = 0;
        paths[pos] = [];
        
        var unvisited: Set<Point> = Set(graph.keys);
        
        var pqueue = [(pos, 0)];
        while (!pqueue.isEmpty) {
//            print("exploring: \(pqueue)")
            let currNode = pqueue.remove(at: 0).0;
            if (!unvisited.contains(currNode)) {
                continue;
            }
//            print("exploring: \(currNode)")
            
            unvisited.remove(currNode);
                        
            let edges = graph[currNode]!
            for edge in edges {
                let tentDist = costs[currNode]! + edge.cost;
//                print("tentDistance for edge: \(edge) is: \(tentDist)")
                if (costs[edge.to]! > tentDist) {
                    // must update direction at node when overwriting cost of target node
                    costs[edge.to] = tentDist;
                    paths[edge.to] = [currNode]
                    pqueue.append((edge.to, tentDist));
                } else if (costs[edge.to]! == tentDist) {
                    paths[edge.to] = (paths[edge.to] ?? []) + [currNode];
                }
            }
            pqueue = pqueue.sorted(by: {(first, second) in
                first.1 < second.1
            })
        }
        
        print("Total cost of target: \(costs[goal]!)")
        return costs[goal]!
//        print("Paths to target: \(paths[goal]!)");
    }

    func buildGraph() -> [Point: [Edge]] {
        
        var nodes: Set<Point> = [];
        
        for y in 0...goal.y {
            for x in 0...goal.x {
                let point = Point(x, y);
                if (walls.contains(point)) {
                    continue;
                }
                
                // this will include dead ends but thats fine.
                nodes.insert(point);
            }
        }
        
        var edges: [Edge] = [];
        
        for node in nodes {
            let east = node.getEast();
            if (isWithinBounds(east) && !walls.contains(east)) {
                let edge = Edge(node, east, 1);
                edges.append(edge);
            }
            
            let west = node.getWest();
            if (isWithinBounds(west) && !walls.contains(west)) {
                let edge = Edge(node, west, 1);
                edges.append(edge);
            }
            
            let north = node.getNorth();
            if (isWithinBounds(north) && !walls.contains(north)) {
                let edge = Edge(node, north, 1);
                edges.append(edge);
            }
            
            let south = node.getSouth();
            if (isWithinBounds(south) && !walls.contains(node.getSouth())) {
                let edge = Edge(node, south, 1);
                edges.append(edge);
            }
        }
        
        var graph: [Point: [Edge]] = [:]
        
        for edge in edges {
            if (!graph.keys.contains(edge.from)) {
                graph[edge.from] = [edge];
                continue;
            }
            graph[edge.from]?.append(edge);
        }
        
        return graph;
    }
    
    func isWithinBounds(_ point: Point) -> Bool {
        return point.x >= 0 && point.y >= 0 && point.x <= goal.x && point.y <= goal.y;
    }
    
    func execPart2() throws{
        // binary search time!
        
        // 3450 is the limit
        
        var upperBound = 3450
        var lowerBound = 1024;
        while(lowerBound < upperBound - 1) {
            let limit = lowerBound + (upperBound - lowerBound)/2
            print("attempting \(limit)")
            walls = [];
            try prep(limit: limit);
            let result = try execPart1();
            if (result == 10000000000000) {
                print("\(limit) was too high. Decreasing upper bound to \(limit)")
                upperBound = limit;
            } else {
                print("\(limit) was too low. Increasing lower bound to \(limit)")
                lowerBound = limit;
            }
        }
        print("Upper bound \(upperBound), lowerBound \(lowerBound)")
    }
}
