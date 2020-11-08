//
//  String+.swift
//  PrintfulTechTask
//
//  Created by pavels.vetlugins on 08/11/2020.
//

import Foundation

extension String {

    func capturedGroups(withRegex pattern: String) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            if let range = Range(capturedGroupIndex, in: self) {
                results.append(String(self[range]))
            }
        }

        return results
    }
    
}
