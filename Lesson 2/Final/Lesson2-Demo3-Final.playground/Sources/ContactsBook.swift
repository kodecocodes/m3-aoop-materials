import Foundation

public class ContactsBook {
  public static var current = ContactsBook()
  private var contactsList: [ContactCard] = []
  
  public init() {}
  
  public func saveContact(contact: ContactCard) {
    contactsList.append(contact)
  }
}
