import Foundation

public class ContactCard: Subject {
  let contactID: UUID
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [UUID]
  public var observers: [Observer]
  var canAdd: ContactOptions = []
  var cardType: ContactOptions = .unknown

  public init(firstName: String, lastName: String, phoneNumber: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    contactID = UUID()
    relatedContacts = []
    observers = []
  }

  public func set(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
    broadcastUpdates()
  }

  public func set(phone: String) {
    phoneNumber = phone
    broadcastUpdates()
  }

  public func set(phone: Double) {
    phoneNumber = "\(phone)"
    broadcastUpdates()
  }

  public final func addRelatedContact(_ contact: ContactCard) {
    if canAdd.contains(contact.cardType) {
      print("Adding contact to related list.")
      relatedContacts.append(contact.contactID)
    } else {
      print("Can't Add")
    }
    
    if contact.canAdd.contains(cardType) {
      print("Adding inverse relation")
      contact.relatedContacts.append(self.contactID)
    } else {
      print("Can't Add Inverse")
    }
    broadcastUpdates()
  }

  public func contactInformation() -> String {
    "Contact: FirstName: \(firstName), lastName: \(lastName), Phone: \(phoneNumber), Connections: \(relatedContacts.count)"
  }
  
}
