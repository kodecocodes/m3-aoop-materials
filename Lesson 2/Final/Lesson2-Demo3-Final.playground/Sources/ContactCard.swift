import Foundation

public class ContactCard {
  public let contactID: UUID
  var firstName: String
  var lastName: String
  var phoneNumber: String
  public var relatedContacts: [UUID]
  var isCompany: Bool

  public func set(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  
  public func set(phone: String) {
    phoneNumber = phone
  }
  
  public func set(phone: Double) {
    phoneNumber = "\(phone)"
  }
  
  public init(firstName: String, lastName: String, phoneNumber: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    contactID = UUID()
    relatedContacts = []
    isCompany = false
  }

  public func addRelatedContact(_ contact: ContactCard) {
    relatedContacts.append(contact.contactID)
  }

  public func contactInformation() -> String {
    "Contact: FirstName: \(firstName), lastName: \(lastName), Phone: \(phoneNumber), Connections: \(relatedContacts.count)"
  }
}
