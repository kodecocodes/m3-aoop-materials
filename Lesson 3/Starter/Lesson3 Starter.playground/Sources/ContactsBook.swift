import Foundation

public class ContactsBook {
  private var contactsList: [ContactCard] = []

  public init() {}

  public static var current = ContactsBook()

  public func saveContact(contact: ContactCard) {
    contactsList.append(contact)
  }
}
