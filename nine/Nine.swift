//
//  Nine.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/9/24.
//

import Foundation

class Nine: Problem {
    
    var disk: [FileData] = [];
    
    var maxId = 0;
    
    init() throws {
//        try super.init(filename: "sample.txt", filepath: #file)
        try super.init(filepath: #file)
        try prep();
    }
    
    func prep() throws {
        disk = [];
        let diskline = input[0];
        for i in stride(from: 0, to: diskline.count, by: 2) {
//            print("i = \(i)");
            let id = i / 2;
            let size = Int(diskline[i]!)!;
            let padding = Int(diskline[i + 1] ?? "0")!;
            disk.append(FileData(id, size, padding));
//            print("added \(disk[id])");
            maxId = id;
        }
        
        print(disk);
        print("max id: \(maxId)")
    }
    
    func execPart1() throws {
        print("Executing part 1");
        var leftIndex = 0;
        var rightIndex = disk.count - 1;
        
        var newDisk: [FileData] = [];
        var addedLeft = false;
        
        while (leftIndex != rightIndex) {
            let left = disk[leftIndex];
            let right = disk[rightIndex];
            let availablePadding = left.padding;
            let diskEndSize = right.size;
            
            if (availablePadding == diskEndSize) {
                if (!addedLeft) {
                    newDisk.append(FileData(left.id, left.size, 0))
                    left.markTagged();
                }
                newDisk.append(FileData(right.id, right.size, 0))
                right.markTagged();
                
                leftIndex += 1;
                rightIndex -= 1;
                right.setSize(0)
                left.setSize(0)
                addedLeft = false;
            } else if (availablePadding > diskEndSize) {
                // there is still available padding after move
                left.setPadding(left.padding - right.size)
                if (!addedLeft) {
                    newDisk.append(FileData(left.id, left.size, 0))
                    addedLeft = true;
                }
                newDisk.append(FileData(right.id, right.size, 0))
                right.setSize(0)
                right.markTagged()
                
                rightIndex -= 1;
            } else {
                // we need more space on left
                if (!addedLeft) {
                    newDisk.append(FileData(left.id, left.size, 0));
                    left.setSize(0)
                    left.markTagged();
                }
                newDisk.append(FileData(right.id, left.padding, 0));
                right.setSize(right.size - left.padding)
                
                leftIndex += 1;
                addedLeft = false;
            }
//            print("new disk: \(newDisk)")
        }
    
        print("new disk: \(newDisk)")
        
        for i in rightIndex..<disk.count {
            if (disk[i].size > 0 && !disk[i].tagged) {
                print("Adding: \(disk[i]) because it is marked untagged")
                newDisk.append(FileData(disk[i].id, disk[i].size, disk[i].padding))
            }
        }
        
//        print("disk: \(disk)")
//        print("new disk after adding unaccounted diskspace: \(newDisk)")
        
        newDisk.popLast(); // A hack b/c the last element is being counted twice
        
        // OMG we might need to do another iteration??
        
        
        print("right index: \(rightIndex) is \(disk[rightIndex])")
        
        print("Checksum: \(calculateChecksum(disk: newDisk))")

        // 5822041608272 is too low!
        // 6386655947072 is too high!
        // 6384282079460
    }
    
    func execPart2() throws{
        print("Executing part 2. Reprepping");
        try prep();
        //print("Starting disk: \(disk)")
        var rightIndex = disk.count - 1;
        
        var newDisk: [FileData] = [];
        var currDisk = disk;
        var currId = maxId;
        while (currId > 0) {
            let right: FileData = {
                for i in 0..<currDisk.count {
                    if (currDisk[i].id == currId) {
                        return currDisk[i];
                    }
                }
                return nil;
            }()!
            var appended = false;
            for leftIndex in 0..<disk.count {
                let left = currDisk[leftIndex];
//                print("comparing \(left.padding) to fit \(right.size) for \(right)")
                if (left.id == right.id && !appended) {
                    newDisk.append(right);
                    appended = true;
                } else if (left.padding >= right.size && !appended) {
                    // it fits!
                    newDisk.append(FileData(left.id, left.size, 0))
                    newDisk.append(FileData(right.id, right.size, left.padding - right.size));
                    
                    // TODO: need to account for opened up padding!
                    // find index of right in currDisk
                    for i in 1..<currDisk.count {
                        if (currDisk[i].id == right.id) {
                            // need to update the padding of the element before that one
                            currDisk[i - 1].setPadding(currDisk[i - 1].padding + right.size + right.padding)
                        }
                    }
                    appended = true;
                } else if (appended && left.id == right.id) {
                } else {
//                    print("Appending \(left)")
                    newDisk.append(left);
                }
            }
            
            currId -= 1;
            rightIndex -= 1;
            currDisk = newDisk;
            newDisk = [];
//            printDisk(disk: currDisk);
//            print("Disk after reshuffle: \(currDisk)")
        }
        
        print("checksum: \(calculateChecksum(disk: currDisk))")
    
    }
    
    func calculateChecksum(disk: [FileData]) -> Int {
        var i = 0;
        var index = 0;
        var checksum = 0;
        while i < disk.count {
            let file = disk[i];
            for _ in 0..<file.size {
//                print("Adding i=\(index) * file.id=\(file.id) =\(index * file.id) to checksum")
                checksum += (index) * file.id;
                index += 1;
            }
            index += file.padding;
            i += 1;
        }
        return checksum;
    }
    
    func printDisk(disk: [FileData]) {
        if (disk.count > 100) {
            return;
        }
        var str = ""
        for file in disk {
            for _ in 0..<file.size {
                str += String(file.id);
            }
            for _ in 0..<file.padding {
                str += "."
            }
        }
        print(str)
    }
    
    class FileData: CustomStringConvertible {
        var id: Int;
        var size: Int;
        var padding: Int;
        var tagged = false;
        
        public var description: String { return "\(id): \(size) [\(padding)]" }
        
        init(_ id: Int, _ size: Int, _ padding: Int) {
            self.id = id;
            self.size = size;
            self.padding = padding;
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id);
            hasher.combine(size);
            hasher.combine(padding);
        }
        
        func setSize(_ newSize: Int) {
            self.size = newSize;
        }
        
        func setPadding(_ newPadding: Int) {
            self.padding = newPadding;
        }
        
        func markTagged() {
            self.tagged = true;
        }
        
        static func ==(lhs: FileData, rhs: FileData) -> Bool {
            return lhs.id == rhs.id && lhs.size == rhs.size && lhs.padding == rhs.padding;
        }
    }
}
