//
//  Twentythree.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/23/24.
//

import Foundation

class Twentythree: Problem {
    
    var network = [String:Set<String>]();
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        for line in input {
            if (line.isEmpty) { continue; }
            let computers = line.components(separatedBy: "-");
            if (!network.keys.contains(computers[0])) {
                network[computers[0]] = [computers[1]];
            } else {
                network[computers[0]]?.insert(computers[1])
            }
            if (!network.keys.contains(computers[1])) {
                network[computers[1]] = [computers[0]];
            } else {
                network[computers[1]]?.insert(computers[0])
            }
        }
        print(network)
    }
    
    func execPart1() throws {
        var triplets = Set<Set<String>>();
        for (computer, connections) in network {
            if (!computer.hasPrefix("t")) {
                continue;
            }
            for connection in connections {
                for distantConnection in network[connection] ?? [] {
                    if (connections.contains(distantConnection)) {
                        triplets.insert([computer, connection, distantConnection]);
                    }
                }
            }
        }
        
        print("\(triplets)")
        print("\(triplets.count) has computers with 't' in it")
        
        // 2106 is too high
    }
    
    func execPart2() throws {
        
        
        var biggestSize = 0;
        var biggestIntersection = Set<String>();
        for (first, firstConns) in network {
            let firstSet = firstConns.union([first]);
            var intersection = firstSet;
            for connection in firstConns {
                let partialIntersection = intersection.intersection(network[connection]!.union([connection]));
                if (partialIntersection.count > 2) {
                    intersection = partialIntersection;
                }
            }
            if (first == "co") {
                print("co intersection: \(intersection)")
            }
            if (intersection.count > biggestSize) {
                biggestSize = intersection.count;
                biggestIntersection = intersection;
            }
        }
        
        print(biggestIntersection.sorted().joined(separator: ","))
    }
}
