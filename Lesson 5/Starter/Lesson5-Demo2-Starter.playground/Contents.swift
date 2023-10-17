import Foundation

protocol CarProtocol {
  func accelerate()
  func brake()
  func steer()

  func navigateTo(destination: String)
  func cancelNavigation()

  func changeRadioStation(stationNumber: Float)
  func changeVolume(volume: Int)

  func getCarTemperature() -> Int
  func setTemperature(temp: Int)
  func setFanSpeed(speed: Int)
}

class AICarControlsModule {
  var carReference: CarProtocol!

  func doSomething() {
  }
}

class AICarNavigationModule {
  var carReference: CarProtocol!
}

class AICarEntertainmentModule {
  var carReference: CarProtocol!
}

class AICarWeatherModule {
  var carReference: CarProtocol!
}
