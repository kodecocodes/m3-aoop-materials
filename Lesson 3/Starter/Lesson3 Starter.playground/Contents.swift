let ehabContact = PersonContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
let timContact = PersonContactCard(firstName: "Tim", lastName: "Contact", phoneNumber: "0987654321")

ehabContact.addRelatedContact(timContact)

print(ehabContact.contactInformation())
print(timContact.contactInformation())

let kodeco = CompanyContactCard(companyName: "Kodeco", phoneNumber: "1111111111")
let razeware = CompanyContactCard(companyName: "Razeware", phoneNumber: "2222222222")

kodeco.addRelatedContact(razeware)
kodeco.addRelatedContact(ehabContact)

print(kodeco.contactInformation())
print(razeware.contactInformation())

timContact.set(firstName: "Tim", lastName: "Condon")
timContact.set(phone: "555-5555")
ehabContact.set(phone: 12345679.0)


ContactsBook.current.saveContact(contact: ehabContact)
ContactsBook.current.saveContact(contact: timContact)
ContactsBook.current.saveContact(contact: kodeco)
ContactsBook.current.saveContact(contact: razeware)

