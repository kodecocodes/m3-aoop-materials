import Foundation

public class PersonContactCard: ContactCard {
  
  public override init(firstName: String, lastName: String, phoneNumber: String) {
    super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    isCompany = false
  }
  
  public override func addRelatedContact(_ contact: ContactCard) {
    if !contact.isCompany {
      print("Calling super from Person")
      super.addRelatedContact(contact)
      print("Other contact is a Person too. Adding 2-way relationship")
      contact.relatedContacts.append(contactID)
    }
  }
}

