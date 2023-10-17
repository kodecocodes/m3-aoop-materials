var ehabContact = ContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
var timContact = ContactCard(firstName: "Tim", lastName: "Condon", phoneNumber: "0987654321")

ehabContact.addRelatedContact(timContact)

let containsTim = ehabContact.relatedContacts.contains(timContact.contactID)
let containsEhab = timContact.relatedContacts.contains(ehabContact.contactID)

print("Ehab contact contains Tim contact: \(containsTim)")
print("Tim contact contains Ehab contact: \(containsEhab)")
