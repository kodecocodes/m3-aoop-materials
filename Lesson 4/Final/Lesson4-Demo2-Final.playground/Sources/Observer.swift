import Foundation

public protocol Observer: AnyObject {
  func subjectUpdated(subject: any Subject)
}

