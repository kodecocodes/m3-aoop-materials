import Foundation
import UIKit

class System {
  var currentFileNameNumber = 5
  var activeView = SimulatedView()
  func doMainOperation(num1: Int, num2: Int) {
    let sum = num1 + num2
    let stringSum = "\(sum)"
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ar")
    let localizedSum = formatter.string(from: NSNumber(integerLiteral: sum))!
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    let styledString = NSAttributedString(string: localizedSum, attributes: attributes)
    activeView.labelText = styledString
    let activeFileName = "logFile\(currentFileNameNumber).log"
    var logFileHandler = SimulatedFile(fileName: activeFileName)
    logFileHandler.openFile()
    if logFileHandler.numberOfLines >= 100 {
      currentFileNameNumber += 1
      let newActiveFileName = "logFile\(currentFileNameNumber).log"
      logFileHandler.closeFile()
      logFileHandler = SimulatedFile(fileName: activeFileName)
      logFileHandler.openFile()
    }
    let logEntry = "\(num1) + \(num2) = \(sum). Presented: \(localizedSum)"
    logFileHandler.writeData(logEntry)
    logFileHandler.closeFile()
  }
}

let system = System()
system.doMainOperation(num1: 3, num2: 7)
