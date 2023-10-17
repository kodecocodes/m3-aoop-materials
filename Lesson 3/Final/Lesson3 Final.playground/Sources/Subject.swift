import Foundation

public protocol Subject: AnyObject {
  var observers: [Observer] { get set }
  func addObserver(_ obj: Observer)
  func removeObserver(_ obj: Observer)
  func broadcastUpdates()
}

public extension Subject {
  func addObserver(_ obj: Observer) {
    observers.append(obj)
  }

  func removeObserver(_ obj: Observer) {
    observers.removeAll { item in
      item === obj
    }
  }

  func broadcastUpdates() {
    observers.forEach { observer in
      observer.subjectUpdated(subject: self)
    }
  }
}
