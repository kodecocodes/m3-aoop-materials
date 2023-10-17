var ehabContact = ContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
var timContact = ContactCard(firstName: "Tim", lastName: "Condon", phoneNumber: "0987654321")

ehabContact.addRelatedContact(timContact)

let containsTim = ehabContact.relatedContacts.contains(timContact.contactID)
let containsEhab = timContact.relatedContacts.contains(ehabContact.contactID)

//print("Ehab contact contains Tim contact: \(containsTim)")
//print("Tim contact contains Ehab contact: \(containsEhab)")

let kodeco = ContactCard(firstName: "Kodeco", lastName: "", phoneNumber: "111111111")
kodeco.isCompany = true

let razeware = ContactCard(firstName: "Razeware", lastName: "", phoneNumber: "111111111")
razeware.isCompany = true

kodeco.addRelatedContact(razeware)
kodeco.addRelatedContact(ehabContact)

print(ehabContact.contactInformation())
print(kodeco.contactInformation())
print(razeware.contactInformation())
