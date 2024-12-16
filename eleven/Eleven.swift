//
//  Eleven.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/11/24.
//

import Foundation

class Eleven: Problem {
    
    var stones: [Int] = []
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        stones = input[0].components(separatedBy: " ").map {
            Int($0)!
        }
        
        print("\(stones). also Int('000') is \(Int("000")!)")
    }
    
    func execPart1() throws {
        var currStones = stones;
        for i in 0..<25 {
            print("Blinking for \(i)th time")
            currStones = blink(currStones);
        }
        print("Curr stones count: \(currStones.count)");
    }
    
    func blink(_ stones: [Int]) -> [Int] {
        let isZero = { stone in stone == 0 }
        let isEven: (Int) -> Bool = { stone in "\(stone)".count % 2 == 0}
        
        var newStones: [Int] = [];
        for i in 0..<stones.count {
            let stone = stones[i];
            
            if (isZero(stone)) {
                newStones.append(1);
            } else if (isEven(stone)) {
                let stoneStr = "\(stone)";
                let index = stoneStr.index(stoneStr.startIndex, offsetBy: stoneStr.count / 2);
                newStones.append(Int(stoneStr[..<index])!);
                newStones.append(Int(stoneStr.suffix(from: index))!)
            } else {
                newStones.append(stone * 2024);
            }
        }
//        print("New stones: \(newStones)");
        return newStones;
    }
    
    func execPart2() throws{
        var currStones = stones;
        
        // cache for 25 blink results
        var stoneCache25: [Int: [Int]] = [:]
        for num in 0..<100 {
            var cacheStones = [num];
            for _ in 0..<25 {
                cacheStones = blink(cacheStones);
            }
            stoneCache25[num] = cacheStones;
            print("Cached \(cacheStones.count) possibilities after 25 for \(num)")
        }
        
        for i in 1...25 {
            print("Blinking for \(i)th time")
            currStones = blink(currStones);
        }
        print("Finished 25 blinks with size: \(currStones.count)")

        var newCurrStones: [Int] = [];
        for stone in currStones {
            if (stoneCache25.keys.contains(stone)) {
                newCurrStones.append(contentsOf: stoneCache25[stone]!)
            } else {
                var subStone = [stone];
                for _ in 0..<25 {
                    subStone = blink(subStone);
                }
                newCurrStones.append(contentsOf: subStone);
                stoneCache25[stone] = subStone;
            }
        }
        print("Finished 50 blinks with size: \(newCurrStones.count)")
        
        var finalStoneCount = 0;
        for (i, stone) in newCurrStones.enumerated() {
            if (i % 10000000 == 0) {print("processed \(i) stones")}
            if (stoneCache25.keys.contains(stone)) {
                finalStoneCount += stoneCache25[stone]!.count
            } else {
                var subStone = [stone];
                for _ in 0..<25 {
                    subStone = blink(subStone);
                }
                stoneCache25[stone] = subStone;
                finalStoneCount += subStone.count;
            }
        }
        
        print("Final stones count: \(finalStoneCount)");
        
        // 22900752462879 is too low
        // 22938365706844 is too low!
        // 65601038650482 is too low!
        // 221291560078593
    }
}
