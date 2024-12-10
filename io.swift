//
//  io.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/1/24.
//

import Foundation

private let fm = FileManager.default;

func readFileToLineList(filepath: String) throws -> [String]? {
    return try readFile(filepath: filepath)?.components(separatedBy: "\n");
}

func readFile(filepath: String) throws -> String? {
    print("reading file at \(filepath)")
    if let filedata = fm.contents(atPath: filepath) {
        if let contents = String(data: filedata, encoding: .utf8) {
            return contents;
        }
    }
    
    print("Unable to parse file contents for \(filepath)")
    return nil;
}
