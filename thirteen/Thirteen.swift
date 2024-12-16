//
//  Thirteen.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/13/24.
//

import Foundation

class Thirteen: Problem {
    
    var pos = Point(0, 0);
    
    var machines: [Machine] = [];
    
    let aCost = 3;
    
    let bCost = 1;
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        var a = Point(0, 0);
        var b = Point(0, 0);
        var prize = Point(0, 0);
        for i in 0..<input.count {
            let tokens = input[i].components(separatedBy: ": ");
            if (i % 4 == 0) {
                // button a
                let offsets = tokens[1].components(separatedBy: ", ").map { Int($0.components(separatedBy: "+")[1])!}
                a = Point(offsets[0], offsets[1]);
            } else if (i % 4 == 1) {
                // button b
                let offsets = tokens[1].components(separatedBy: ", ").map { Int($0.components(separatedBy: "+")[1])!}
                b = Point(offsets[0], offsets[1]);
            } else if (i % 4 == 2) {
                // prize
                let offsets = tokens[1].components(separatedBy: ", ").map { Int($0.components(separatedBy: "=")[1])!}
                prize = Point(offsets[0], offsets[1]);
            } else if (i % 4 == 3) {
                let machine = Machine(a, b, prize);
                machines.append(machine);
                print("Created machine: \(machine)")
            }
        }
    }
    
    func execPart1() throws {
        var totalCost = 0;
        for machine in machines {
            guard let cost = getMinCost(machine: machine) else {
                print("Machine \(machine) does not have possible solution--skipping");
                continue;
            }
            print("Min cost for machine\n\(machine)\n is \(cost)")
            totalCost += cost;
        }
        print("Min cost: \(totalCost)")
    }
    
    func getMinCost(machine: Machine) -> Int? {
        var tempCost = 0;
        var tempPath = "";
        var pos = Point(0, 0);
        while (pos.x < machine.prize.x && pos.y < machine.prize.y) {
            tempCost += bCost;
            tempPath += "b";
            pos = Point(pos.x + machine.b.x, pos.y + machine.b.y);
        }
        
        if (pos == machine.prize) {
            return tempCost;
        }
        
        var minCost: Int? = nil;
        for i in 0..<tempPath.count {
            var path = String(tempPath.substring(to: tempPath.index(tempPath.startIndex , offsetBy: tempPath.count  - i)));
            var newPos = Point(pos.x - i * machine.b.x, pos.y - i * machine.b.y);
            var newCost = tempCost - i * bCost;
            
            while (newPos.x <= machine.prize.x || newPos.y <= machine.prize.y) {
                if (newPos == machine.prize && (minCost == nil || minCost! > newCost)) {
                    print("Found min cost path at: \(path) with cost \(newCost)")
                    minCost = newCost;
                }
                
                path += "a";
                newPos = Point(newPos.x + machine.a.x, newPos.y + machine.a.y);
                newCost += aCost;
            }
        }
        
        return minCost;
    }
    
    func getCostForPath(path: String) -> Int {
        var cost = 0;
        
        for char in path {
            if (char == "a") {
                cost += aCost;
            } else if (char == "b") {
                cost += bCost;
            }
        }
        return cost;
    }
    
    func execPart2() throws{
        print("\n\n---PART 2---\n\n")
        var totalCost = 0;
        for machine in machines {
            let bigMachine = Machine(machine.a, machine.b, Point(machine.prize.x + 10000000000000, machine.prize.y + 10000000000000))
//            let bigMachine = machine;
            guard let cost = getMinCostForBigMachine(machine: bigMachine) else {
                print("Machine \(bigMachine) does not have possible solution--skipping");
                continue;
            }
            print("Min cost for machine \(bigMachine)\n is \(cost)")
            totalCost += cost;
        }
        print("Min cost: \(totalCost)")
    }
    
    func getMinCostForBigMachine(machine: Machine) -> Int? {

        let aCount = ((machine.b.x * machine.prize.y) - (machine.prize.x * machine.b.y)) / ((machine.b.x * machine.a.y) - (machine.a.x * machine.b.y))
        
        let bCount = (machine.prize.y - (aCount * machine.a.y)) / machine.b.y;
        
        print("Found a = \(aCount) and b = \(bCount)")
        
        if (Point(machine.a.x * aCount + machine.b.x * bCount, machine.a.y * aCount + machine.b.y * bCount) == machine.prize) {
            print("\(aCount) * \(aCost) + \(bCount) + \(bCost) ")
            return (aCount * aCost) + (bCount * bCost);
        }
        
        
        // aA + bB = P
        
        // a (x1, y1) + b (x2, y2) = (px, py)
        
        // a * x1 + b * x2 = px
        // a * y1 + b * y2 = py
        
        // a = (px - (b * x2)) / x1
        // b = (py - (a * y1)) / y2
        
        // x = (j - (y * h)) / j
        // y = (k - (x * l)) / m
        
        // eg.
        // a = (8400 - b * 22) / 94
        // b = (5400 - a * 34) / 67
        
        // a = (8400 - ((5400 - a * 34)/ 67)/ 94)

        
        return nil;
    }
    
    
    
    /* Abandon this. I don't think it really matters the order in which we push the buttons. We just need to get to the distance with the fewest number of A buttons */
    func traverse(_ pos: Point, _ machine: Machine, _ cost: Int, _ path: String = "") -> Int? {
        if (machine.minCost != nil && machine.minCost! <= cost) {
//            print("Pruned at path: \(path) b/c cost is \(cost) > \(machine.minCost!)")
            return nil;
        }
        
        if (machine.minCostPath != nil && abCountsMatch(path, machine.minCostPath!)) {
            return nil;
        }
        
        if (pos == machine.prize) {
            if (machine.minCost == nil || machine.minCost! > cost) {
//                print("Found prize at cost \(cost) and path \(path)")
                machine.minCost = cost;
                machine.minCostPath = path;
                return cost;
            }
            
            return nil;
        }
        
        if (pos.x > machine.prize.x || pos.y > machine.prize.y) {
            return nil;
        }
        
        var aRes = traverse(Point(pos.x + machine.a.x, pos.y + machine.a.y), machine, cost + aCost, path + "a");
        var bRes = traverse(Point(pos.x + machine.b.x, pos.y + machine.b.y), machine, cost + bCost, path + "b");
        
        let costs = [aRes, bRes].filter({ $0 != nil }).map({ $0! }).sorted();
        
        return costs.isEmpty ? nil : costs[0];
    }
    
    func abCountsMatch(_ first: String, _ second: String) -> Bool {
        if (first.count != second.count) {
            return false;
        }
        var firstACount = 0;
        var firstBCount = 0;
        for char in first {
            if (String(char) == "a") {
                firstACount += 1;
            } else if (String(char) == "b") {
                firstBCount += 1;
            }
        }
        
        var secondACount = 0;
        var secondBCount = 0;
        for char in second {
            if (String(char) == "a") {
                secondACount += 1;
            } else if (String(char) == "b") {
                secondBCount += 1;
            }
        }
        
        return firstACount == secondACount && firstBCount == secondBCount;
    }
    
    class Machine: CustomStringConvertible {
        let a: Point;
        
        let b: Point;
        
        let prize: Point;
        
        var minCost: Int?;
        
        var minCostPath: String?;
        
        public var description: String { return "\nA: X+\(a.x) Y+\(a.y)\nB: X+\(b.x) Y+\(b.y)\nPrize: X=\(prize.x) Y=\(prize.y)" }
        
        init(_ a: Point, _ b: Point, _ prize: Point) {
            self.a = a;
            self.b = b;
            self.prize = prize;
            self.minCost = nil;
        }
    }
}
