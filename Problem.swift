//
//  Problem.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/1/24.
//

import Foundation

class Problem {
    
    let input: [String];
        
    init(filename: String = "input.txt", filepath: String) throws {
        do {
            let currentFilename = filepath.components(separatedBy: "/").dropLast().joined(separator: "/");
            self.input = try readFileToLineList(filepath: currentFilename + "/\(filename)")!
        } catch let err {
            print("/n/n PARSING ERROR \(err)/n/n")
            throw err;
        }
    }
    
}
