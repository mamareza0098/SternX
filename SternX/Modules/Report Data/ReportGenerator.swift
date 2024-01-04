//Created for SternX in 2024
// Using Swift 5.0

import Foundation

class ReportGenerator {
    
    func generateReport(_ data: [Int: Int]) {
        let header = ["User ID", "Average Character Length"]
        let rows = data.sorted{ $0.1 > $1.1 }.map({ "\($0.key),\($0.value)" })
        let csv = header.joined(separator: ",") + "\n" + rows.joined(separator: "\n")
        print(csv)
    }
    
}
