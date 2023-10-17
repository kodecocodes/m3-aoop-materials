import Foundation
import UIKit

class System {
  var currentFileNameNumber = 5
  var activeView = SimulatedView()
  func doMainOperation(num1: Int, num2: Int) {
    let sum = Calculator.add(num1: num1, num2: num2)
    let stringSum = "\(sum)"
    let localizedSum = StringManager.toLocalizedValue(num: sum)
    
    ViewPresenter.showValueOnView(value: localizedSum, view: activeView)

    let logEntry = "\(num1) + \(num2) = \(sum). Presented: \(localizedSum)"
    LogManager.singleton().addLogEntry(logEntry)
  }
}

let system = System()
system.doMainOperation(num1: 3, num2: 7)

class Calculator {
  class func add(num1: Int, num2: Int) -> Int {
    num1 + num2
  }
}

class StringManager {
  class func toLocalizedValue(num: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ar")
    let localizedSum = formatter.string(from: NSNumber(integerLiteral: num))!
    print(localizedSum)
    return localizedSum
  }
}

class ViewPresenter {
  class func showValueOnView(value: String, view: SimulatedView) {
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    let styledString = NSAttributedString(string: value, attributes: attributes)
    view.labelText = styledString
  }
}

class LogManager {
  private static let maxLogSize = 100
  private static var currentInstance: LogManager?
  private var currentFileNameNumber = 5
  private var logFileHandler: SimulatedFile!
  
  private init() {
    let activeFileName = fileName(numbered: currentFileNameNumber)
    logFileHandler = SimulatedFile(fileName: activeFileName)
    logFileHandler.openFile()
  }
  
  class func singleton() -> LogManager {
    if currentInstance == nil {
      currentInstance = .init()
    }
    return currentInstance!
  }
  
  public func addLogEntry(_ entry: String) {
    verifyLogSize()
    print("\(entry) | Log entry saved.")
  }
  
  private func fileName(numbered: Int) -> String {
    "logFile\(numbered).log"
  }
  
  private func verifyLogSize() {
    if logFileHandler.numberOfLines >= LogManager.maxLogSize {
      currentFileNameNumber += 1
      logFileHandler.closeFile()
      let newFileName = fileName(numbered: currentFileNameNumber)
      logFileHandler = SimulatedFile(fileName: newFileName)
      logFileHandler.openFile()
    }
  }
}
