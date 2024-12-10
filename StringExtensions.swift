//
//  StringExtensions.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/3/24.
//

import Foundation

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension String {
    subscript(i: Int) -> String? {
        if (self.count <= i) {
            return nil;
        }
        return String(self[index(startIndex, offsetBy: i)])
    }
}
