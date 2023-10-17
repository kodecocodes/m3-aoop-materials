import Foundation

protocol CarControlsProtocol {
  func accelerate()
  func brake()
  func steer()
}

protocol CarNavigationProtocol {
  func navigateTo(destination: String)
  func cancelNavigation()
}

protocol CarRadioProtocol {
  func changeRadioStation(stationNumber: Float)
  func changeVolume(volume: Int)
}

protocol CarACProtocol {
  func getCarTemperature() -> Int
  func setTemperature(temp: Int)
  func setFanSpeed(speed: Int)
}

class AICarControlsModule {
  var carReference: CarControlsProtocol!

  func doSomething() {
  }
}

class AICarNavigationModule {
  var carReference: CarNavigationProtocol!
}

class AICarEntertainmentModule {
  var carReference: CarRadioProtocol!
}

class AICarWeatherModule {
  var carReference: CarACProtocol!
}
