let ehabContact = PersonContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
let timContact = PersonContactCard(firstName: "Tim", lastName: "Contact", phoneNumber: "0987654321")
timContact.set(firstName: "Timothy", lastName: "Condon")

timContact.set(phone: "555-5555")
ehabContact.set(phone: 12345679.0)

ehabContact.addRelatedContact(timContact)

let containsTim = ehabContact.relatedContacts.contains(timContact.contactID)
let containsEhab = timContact.relatedContacts.contains(ehabContact.contactID)

//print("Ehab contact contains Tim contact: \(containsTim)")
//print("Tim contact contains Ehab contact: \(containsEhab)")


let kodeco = CompanyContactCard(companyName: "Kodeco", phoneNumber: "1111111111")
let razeware = CompanyContactCard(companyName: "Razeware", phoneNumber: "2222222222")

kodeco.addRelatedContact(razeware)
kodeco.addRelatedContact(ehabContact)

print(ehabContact.contactInformation())
print(kodeco.contactInformation())
print(razeware.contactInformation())
