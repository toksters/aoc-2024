//
//  Sixteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/15/24.
//

import Foundation

class Sixteen: Problem {
    
    var pos = Point(0, 0);
    
    var direction = Direction.E;
    
    var end = Point(0, 0);
    
    var walls: Set<Point> = [];
    
    var edge = Point(0, 0);
    
    var min = 10000000000;
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
//        try super.init(filename: "small-sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for (y, line) in input.enumerated() {
            if (line.isEmpty) {
                edge = Point(input[0].count, y);
                continue;
            }
            
            for (x, char) in line.enumerated() {
                let point = Point(x, y);
                if (char == "#") {
                    walls.insert(point);
                } else if (char == "E") {
                    end = point;
                } else if (char == "S") {
                    pos = point;
                }
            }
        }
        
        print("walls: \(walls)")
        print("start: \(pos)")
        print("end: \(end)")
    }
    
    func execPart1() throws {
        // dijkstras
        let graph = buildGraph();
        var costs: [Point:Int] = [:];
        for node in graph.keys {
            costs[node] = 10000000000000;
        }
        print(graph);
        costs[pos] = 0;
        var directionAtNode: [Point:Direction] = [pos:Direction.E];
        
        var unvisited: Set<Point> = Set(graph.keys);
        
        var pqueue = [(pos, 0)];
        while (!pqueue.isEmpty) {
            print("exploring: \(pqueue)")
            let currNode = pqueue.remove(at: 0).0;
            if (!unvisited.contains(currNode)) {
                continue;
            }
            
            unvisited.remove(currNode);
                        
            let edges = graph[currNode]!
            for edge in edges {
                let tentDist = costs[currNode]! + getActualCost(directionAtNode[currNode]!, edge)!;
                print("tentDistance for edge: \(edge) is: \(tentDist)")
                if (costs[edge.to]! > tentDist) {
                    // must update direction at node when overwriting cost of target node
                    directionAtNode[edge.to] = getNextDir(edge);
                    costs[edge.to] = tentDist;
                    pqueue.append((edge.to, tentDist));
                }
            }
            pqueue = pqueue.sorted(by: {(first, second) in
                first.1 < second.1
            })
        }
        
        print("Total cost of target: \(costs[end]!)")
        min = costs[end]!;
        
        
        // [START] Naive recursive approach
//        let minScore = explore(Position(pos, direction), 0, nil, [], "");
//
//        if let ms = minScore {
//            print("Min score: \(ms)")
//        } else {
//            print("No min score found")
//        }
//
        // 365388 is too high!
        // 136536 is too high!
        // 134536 is too high!
        
    }
    
    func execPart2() throws{
        // dijkstras
        let graph = buildGraph();
        var costs: [Point:Int] = [:];
        var paths: [Point:[Point]] = [:]; // stores prevous nodes for the optimal path
        for node in graph.keys {
            costs[node] = 10000000000000;
        }
        costs[pos] = 0;
        paths[pos] = [];
        var directionAtNode: [Point:Direction] = [pos:Direction.E];
        
        var unvisited: Set<Point> = Set(graph.keys);
        
        var pqueue = [(pos, 0)];
        while (!pqueue.isEmpty) {
//            print("exploring: \(pqueue)")
            let currNode = pqueue.remove(at: 0).0;
            if (!unvisited.contains(currNode)) {
                continue;
            }
            
            unvisited.remove(currNode);
                        
            let edges = graph[currNode]!
            for edge in edges {
                let tentDist = costs[currNode]! + getActualCost(directionAtNode[currNode]!, edge)!;
//                print("tentDistance for edge: \(edge) is: \(tentDist)")
                if (costs[edge.to]! > tentDist) {
                    // must update direction at node when overwriting cost of target node
                    directionAtNode[edge.to] = getNextDir(edge);
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
        
        print("Total cost of target: \(costs[end]!)")
        print("Paths to target: \(paths[end]!)");
        
        var bestSeats: Set<Point> = [];
        
        var currNode = end;
        var nodesToExplore = [] + paths[end]!;
        var exploredNodes: Set<Point> = [];
        while (!nodesToExplore.isEmpty) {
            let prevNodes = paths[currNode]!;
//            print("exploring nodes: \(nodesToExplore)")
            for prevNode in prevNodes {
                let direction = getNextDir(Edge(prevNode, currNode, 0))!;
                var travelingNode = prevNode;
//                print("traveling from \(prevNode) to \(currNode) in direction \(direction)")
                while (travelingNode != currNode) {
//                    print("traveling node: \(travelingNode)")
                    bestSeats.insert(travelingNode);
                    travelingNode = travelingNode.getDirection(direction);
                }
                if (!exploredNodes.contains(prevNode)) {
                    nodesToExplore.append(prevNode);
                }
            }
            exploredNodes.insert(currNode);
            currNode = nodesToExplore.remove(at: 0);
        }
        
//        for path in paths[end]! {
//            for i in 0..<path.count - 1 {
//                let direction = getNextDir(Edge(path[i], path[i + 1], 0))!;
//                var currNode = path[i];
////                print("finding points between \(currNode) and \(nodes[i + 1]) in direction \(direction)")
//                while (currNode != path[i + 1]) {
//                    bestSeats.insert(currNode);
//                    currNode = currNode.getDirection(direction);
//                }
//            }
//        }
        
        print("Best seat count: \(bestSeats.count + 1)")
    }

    
    func getEdgeForPoints(_ edges: [Edge], _ from: Point, _ to: Point) -> Edge? {
        for edge in edges {
            if (edge.from == from && edge.to == to) {
                return edge;
            }
        }
        
        return nil;
    }
    
    func getNextDir(_ edge: Edge) -> Direction? {
        if (edge.from.x == edge.to.x) {
            // moving up/down
            return edge.from.y < edge.to.y ? Direction.S : Direction.N;
        }
        if (edge.from.y == edge.to.y) {
            // moving left/right
            return edge.from.x < edge.to.x ? Direction.E : Direction.W;
        }
        
        print("Unknown movement detected in edge: \(edge)");
        return nil;
    }
    
    func getActualCost(_ direction: Direction, _ edge: Edge) -> Int? {
        if (edge.from.x == edge.to.x) {
            // moving up/down
            if ([Direction.N, Direction.S].contains(direction)) {
                return edge.cost;
            }
            return edge.cost + 1000;
        }
        if (edge.from.y == edge.to.y) {
            // moving left/right
            if ([Direction.E, Direction.W].contains(direction)) {
                return edge.cost;
            }
            return edge.cost + 1000;
        }
        
        print("Unexpected movement in calculating cost!!!")
        return nil;
    }
    
    func buildGraph() -> [Point: [Edge]] {
        
        var nodes: Set<Point> = [];
        
        for y in 0..<edge.y {
            for x in 0..<edge.x {
                let point = Point(x, y);
                if (walls.contains(point)) {
                    continue;
                }
                if (point == pos) {
                    nodes.insert(point)
                    continue;
                }
                if (point == end) {
                    nodes.insert(end)
                    continue;
                }
                
                let isNorthWall = walls.contains(point.getNorth()) ? 0 : 1;
                let isSouthWall = walls.contains(point.getSouth()) ? 0 : 1
                let isWestWall = walls.contains(point.getWest()) ? 0 : 1;
                let isEastWall = walls.contains(point.getEast()) ? 0 : 1;
                
                let totalOpenSpaces = isNorthWall + isSouthWall + isEastWall + isWestWall;
                
                // definitely a node
                if totalOpenSpaces > 2 {
                    nodes.insert(point);
                    continue;
                }
                
                if totalOpenSpaces == 2 {
                    if (isNorthWall + isSouthWall != 2 && isWestWall + isEastWall != 2) {
                        nodes.insert(point)
                    }
                }
            }
        }
        
        var edges: [Edge] = [];
        
        for node in nodes {
            if (!walls.contains(node.getEast())) {
                var currNode = node.getEast();
                var cost = 1;
                while (!walls.contains(currNode)) {
                    if (nodes.contains(currNode)) {
                        let edge = Edge(node, currNode, cost);
                        edges.append(edge);
                    }
                    cost += 1;
                    currNode = currNode.getEast();
                }
            }
            
            if (!walls.contains(node.getWest())) {
                var currNode = node.getWest();
                var cost = 1;
                while (!walls.contains(currNode)) {
                    if (nodes.contains(currNode)) {
                        let edge = Edge(node, currNode, cost);
                        edges.append(edge);
                    }
                    cost += 1;
                    currNode = currNode.getWest();
                }
            }
            
            if (!walls.contains(node.getNorth())) {
                var currNode = node.getNorth();
                var cost = 1;
                while (!walls.contains(currNode)) {
                    if (nodes.contains(currNode)) {
                        let edge = Edge(node, currNode, cost);
                        edges.append(edge);
                    }
                    cost += 1;
                    currNode = currNode.getNorth();
                }
            }
            
            if (!walls.contains(node.getSouth())) {
                var currNode = node.getSouth();
                var cost = 1;
                while (!walls.contains(currNode)) {
                    if (nodes.contains(currNode)) {
                        let edge = Edge(node, currNode, cost);
                        edges.append(edge);
                    }
                    cost += 1;
                    currNode = currNode.getSouth();
                }
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
    
    
    
    // Recursive solution with pruning. This takes way too long.
    func explore(_ currPos: Position, _ currScore: Int, _ minScore: Int?, _ explored: Set<Point>, _ path: String) -> Int? {
        let newPath = "\(path):\(currPos.pos)";
        if (currPos.pos == end) {
            print("found a path with score \(currScore) and path: \(newPath)");
            return currScore;
        }
        
        let newExplored = Set(explored).union([currPos.pos]);
        
        // prune if we encountered a better route already
        if (currScore > 94436 || (minScore != nil && currScore >= minScore!)) {
            return nil;
        }
        
        // otherwise explore.
        var newMinScore = minScore;
        
        // turn counterclockwise
        let nextCounterClockwisePos = currPos.counterClockwise().move();
        if (!walls.contains(nextCounterClockwisePos.pos) && !newExplored.contains(nextCounterClockwisePos.pos)) {
            let counterClockwiseResult = explore(nextCounterClockwisePos, currScore + 1001, newMinScore, newExplored, newPath)
            if (counterClockwiseResult != nil && (newMinScore == nil || newMinScore! > counterClockwiseResult!)) {
                newMinScore = counterClockwiseResult;
            }
        }
        
        // proceed forward if not wall
        let nextPos = currPos.move();
        if (!walls.contains(nextPos.pos) && !newExplored.contains(nextPos.pos)) {
            let result = explore(nextPos, currScore + 1, newMinScore, newExplored, newPath)
            if (result != nil && (newMinScore == nil || newMinScore! > result!)) {
                newMinScore = result;
            }
        }
        
        
        // turn clockwise
        let nextClockwisePos = currPos.clockwise().move();
        if (!walls.contains(nextClockwisePos.pos) && !newExplored.contains(nextClockwisePos.pos)) {
            let clockwiseResult = explore(nextClockwisePos, currScore + 1001, newMinScore, newExplored, newPath);
            if (clockwiseResult != nil && (newMinScore == nil || newMinScore! > clockwiseResult!)) {
                newMinScore = clockwiseResult;
            }
        }
        
        

        
//        // turn counterclockwise
//        let nextTurnaroundPos = currPos.clockwise().clockwise().move();
//        if (!walls.contains(nextTurnaroundPos.pos) && !newExplored.contains(nextTurnaroundPos.pos)) {
//            let turnaroundResult = explore(nextTurnaroundPos, currScore + 2001, newMinScore, newExplored)
//            if (turnaroundResult != nil && (newMinScore == nil || newMinScore! > turnaroundResult!)) {
//                newMinScore = turnaroundResult;
//            }
//        }
        
        return newMinScore;
    }
    
    struct Position: Hashable, Equatable, CustomStringConvertible {
        let clockwiseMap = [Direction.N: Direction.E, Direction.E: Direction.S, Direction.S: Direction.W, Direction.W: Direction.N];
        let counterClockwiseMap = [Direction.N: Direction.W, Direction.E: Direction.N, Direction.S: Direction.E, Direction.W: Direction.S];
        
        var pos: Point;
        var direction: Direction;
        
        public var description: String { return "(\(pos),\(direction))" }
        
        init(_ pos: Point, _ direction: Direction) {
            self.pos = pos;
            self.direction = direction;
        }
        
        func clockwise() -> Position {
            return Position(pos, clockwiseMap[self.direction]!);
        }
        
        func counterClockwise() -> Position {
            return Position(pos, counterClockwiseMap[self.direction]!);
        }
        
        func move() -> Position {
            return Position(pos.getDirection(self.direction), self.direction);
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pos);
            hasher.combine(direction);
        }
        
        static func ==(lhs: Position, rhs: Position) -> Bool {
            return lhs.pos == rhs.pos && lhs.direction == rhs.direction;
        }
    }
    
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
}
