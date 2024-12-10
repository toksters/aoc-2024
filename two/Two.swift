//
//  Two.swift
//  aoc-2024
//
//  Created by Juntoku Shimizu on 12/2/24.
//

import Foundation

class Two: Problem {
    
    var reports: [[Int]] = []
    
    init() throws {
        try super.init(filepath: #file)
        prep();
    }
    
    func prep() {
        for line in input {
            if (line.count == 0) {
                continue;
            }
            reports.append(line.components(separatedBy: " ").map({ (lvl: String) -> Int in Int(lvl)! }));
        }
        print(reports);
    }
    
    func execPart1() {
        var validReportCount = 0;
        for report in reports {
            if (isReportValid(report: report)) {
                validReportCount += 1;
                print("\(report) is valid!")
            }
        }
        
        print("\n\n\(validReportCount) reports are valid!")
        
    }
    
    func execPart2() {
        var validReportCount = 0;
        var invalidReports: [[Int]] = []
        for report in reports {
            if (isReportValid(report: report)) {
                validReportCount += 1;
                print("\(report) is valid!")
            } else {
                print("Invalid report: \(report)")
                invalidReports.append(report);
            }
        }
        
        print("\(validReportCount) reports are valid")
        print("\(invalidReports.count) reports are still invalid")
        
        for invalidReport in invalidReports {
            for i in 0..<invalidReport.count {
                if (isReportValid(report: invalidReport, ignoreIndex: i)) {
                    validReportCount += 1;
                    print("A once invalid report \(invalidReport) is now valid after ignoring i=\(i)!")
                    break;
                }
            }
        }
        
        // 339 is incorrect
        // 345 is too high
        // 363 is too high
        print("\n\n\(validReportCount) reports are valid!")
    }
    
    func isReportValid(report: [Int], ignoreIndex: Int? = nil) -> Bool {
        var editedReport = report;
        if (ignoreIndex != nil) {
            editedReport = [];
            for (i, lvl) in report.enumerated() {
                if (i != ignoreIndex!) {
                    editedReport.append(lvl);
                }
            }
        }
        if (editedReport[0] < editedReport[1]) {
            // increasing
            for i in 0..<editedReport.count - 1 {
                if (!areConsecutiveLevelsIncreasing(first: editedReport[i], second: editedReport[i + 1])) {
                    return false;
                }
            }
            return true;
        } else if (editedReport[0] > editedReport[1]) {
            // decreasing
            for i in 0..<editedReport.count - 1 {
                if (!areConsecutiveLevelsIncreasing(first: editedReport[i + 1], second: editedReport[i])) {
                    return false;
                }
            }
            return true;
        } else {
            return false;
        }
    }
    
    func areConsecutiveLevelsIncreasing(first: Int, second: Int) -> Bool {
        return first < second && second - first <= 3;
    }

    
}
