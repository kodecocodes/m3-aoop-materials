import Foundation

struct ContactCard {
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [ContactCard] = []
}

var ehabContact = ContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
var timContact = ContactCard(firstName: "Tim", lastName: "Condon", phoneNumber: "0987654321")

ehabContact.relatedContacts.append(timContact)
print(ehabContact.relatedContacts)
