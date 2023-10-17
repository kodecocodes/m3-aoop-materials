import Foundation

public class PersonContactCard: ContactCard {

  public override init(firstName: String, lastName: String, phoneNumber: String) {
    super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    canAdd = [.person]
    cardType = .person
  }

}

