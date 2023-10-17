import Foundation

public class ContactsFactory {

  public class func createPersonContact(
    firstName: String,
    lastName: String,
    phone: String
  ) -> ContactCard {
    PersonContactCard(firstName: firstName, lastName: lastName, phoneNumber: phone)
  }

  public class func createCompanyContact(
    companyName: String,
    phone: String
  ) -> ContactCard {
    CompanyContactCard(companyName: companyName, phoneNumber: phone)
  }

}

