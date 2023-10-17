import Foundation

public struct ContactOptions: OptionSet {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int
  
  static let unknown = ContactOptions(rawValue: 1 << 0) // binary = 0001
  static let person = ContactOptions(rawValue: 1 << 1) // binary = 0010
  static let company = ContactOptions(rawValue: 1 << 2) // binary = 0100
  static let emergency = ContactOptions(rawValue: 1 << 3) // binary = 1000
  static let publicPayPhone = ContactOptions(rawValue: 1 << 4) // binary = 10000
}
