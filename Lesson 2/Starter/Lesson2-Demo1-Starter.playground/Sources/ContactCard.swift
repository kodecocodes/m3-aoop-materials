import Foundation

public class ContactCard {
  let contactID: UUID
  var firstName: String
  var lastName: String
  var phoneNumber: String
  public var relatedContacts: [UUID]

  public init(firstName: String, lastName: String, phoneNumber: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    contactID = UUID()
    relatedContacts = []
  }

  public func addRelatedContact(_ contact: ContactCard) {
    relatedContacts.append(contact.contactID)
    contact.relatedContacts.append(contactID)
  }

  public func contactInformation() -> String {
    "Contact: FirstName: \(firstName), lastName: \(lastName), Phone: \(phoneNumber), Connections: \(relatedContacts.count)"
  }
}
