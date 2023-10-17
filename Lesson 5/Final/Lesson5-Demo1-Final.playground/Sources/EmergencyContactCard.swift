import Foundation

public class EmergencyContactCard: ContactCard {
  override private init(firstName: String, lastName: String, phoneNumber: String) {
    super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    canAdd = []
    cardType = .emergency
  }
  
  public convenience init?(emergencyName: String, phoneNumber: String) {
    if phoneNumber.count != 3 {
      return nil
    }
    self.init(firstName: emergencyName, lastName: "", phoneNumber: phoneNumber)
  }
  
  public override func contactInformation() -> String {
    "Contact: EmergencyName: \(firstName), Phone: \(phoneNumber)"
  }
  
  public override func set(phone: String) -> Bool {
    guard phone.count == 3 else {
      return false
    }
    return super.set(phone: phone)
  }
}
