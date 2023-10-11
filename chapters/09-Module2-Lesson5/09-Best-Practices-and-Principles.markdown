```metadata
number: "5"
title: "Lesson 5: Liskov Substitution, Interface Segregation and Dependency Inversion"
section: 2
free: true
authors:
  # These are applied on a per-chapter basis. If you would like to apply a role to the entire
  # book (i.e. every chapter), use the authors attribute in publish.yaml.
  # Roles: fpe, editor, tech_editor, author, illustrator
  # Use your rw.com username.
  - username: ehabamer
    role: author
description: |
  This lesson takes a deeper look at the final three SOLID principles: Liskov Substitution, Interface Segregation and Dependency Inversion.
```

# Lesson 5: Liskov Substitution, Interface Segregation and Dependency Inversion

## Introduction

In the last lesson, you were introduced to SOLID and its five principles. You learned the first two principles: Single Responsibility and Open-Closed Principle. 

You created a new sample system that started as a very messy implementation, then you broke it down into multiple stand-alone pieces to respect the Single Responsibility principle. You also resumed working on the contacts app and improved it to follow the Open-Closed Principle, which is the second SOLID principle.

In this lesson, you'll cover the remaining three SOLID principles. As you learn more about those principles, you'll realize that both the contacts app and the sample app you created in the last lesson fall short. You'll refactor those apps to apply the new principles to them.

## Instruction

The third SOLID principle, which you'll cover now, is **Liskov Substitution**. Its definition states:

_Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program._

In other words, if swapping out an object with its subclass could potentially break the affected component, you're not adhering to this principle.

This principle isn't a hard rule that you must follow in the system design; rather, it's a guideline that engineers should aim to follow and respect.

In the previous principles, Single Responsibility made you break the system into smaller focused parts. This principle sets boundaries for the subclasses you implement in your system.

Base classes define the common functionality and the main APIs for your objects. Child classes, also known as subclasses, can implement that functionality in their own unique ways.

However, if subclasses start offering unexpected functionality that affects the system, then you're breaking the Liskov Substitution principle. The system itself won't detect this issue, as it depends on the various types to function properly. The responsibility to adhere to this principle falls on you. 

It's important to remember that if you have to create a subclass with extra functionality or one that alters the system's expected output, the best practice is to update the base class to accommodate that potential output, even if not all subclasses will use it.

Does that sound confusing? It will make sense once you try it out with some code.

Currently, your contacts app doesn't perform any validation when you update a contact card's information. You simply expect the app to save whatever information it receives. There's nothing to notify the system that an update should be rejected.

So for your next step, you'll implement a new `EmergencyContactCard` in your contacts app. This card will have a restriction: The phone number must be three digits long. Any call to `set(:)` methods that change the phone number must verify that the new number contains exactly three digits.

In the next demo, you'll explore how to adhere to the governance that the Liskov Substitution Principle requires. You'll also learn how to update the system as needed to meet requirements without violating the principle.

## Demo 1

In this demo, you'll put the Liskov Substitution to work. You'll pick up right where you left off with the contacts app in the previous lesson.

Your new requirement is to implement `EmergencyContactCard`. It can't have any related contacts or be related to any, so you'll use the configuration implemented in the last demo to disable those features. The main requirement on this new card is that the phone number must be exactly three digits.

Create a new file under **Sources** named **EmergencyContactCard.swift** and add the following:

```swift
public class EmergencyContactCard: ContactCard {
  override private init(firstName: String, lastName: String, phoneNumber: String) {
    super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
    canAdd = []
    cardType = .emergency
  }
```

The first initializer is the one you're familiar with from the base class but, in this case, it's marked as private.

```swift
 public convenience init?(emergencyName: String, phoneNumber: String) {
  if phoneNumber.count != 3 {
    return nil
  }
    self.init(firstName: emergencyName, lastName: "", phoneNumber: phoneNumber)
  }
```

Here, you used a `?` in the name of the `convenience` initializer to mark it as a fail-able initializer. You also added a validation that checks if the string length equals three characters. If it doesn't, then the initialization fails and returns nil. If it succeeds, the initialization process continues as normal.

```swift
 public override func contactInformation() -> String {
    "Contact: EmergencyName: \(firstName), Phone: \(phoneNumber)"
  }
}
```

Finally, the override for `contactInformation()` just returns a string properly that represents the new type. It ignores the number of connections because it won't have any. So far, you have kept the Liskov Substitution principle!

The next step is to include the validation in `set(phone:)`:

```swift
public override func set(phone: String) {
  guard phone.count == 3 else {
    return
  }
  super.set(phone: phone)
}
```

This is where you start breaking the principle!

The system expects the value to be stored when `set(:)` is called. However, your child type, `EmergencyContactCard`, ignores the value completely when the input doesn't match its expectations.

This is clearly the requirement, but the system isn't expecting operations to be ignored.

One way to fix this problem is to allow the base type to inform the system whether or not update operations succeed by providing a `Bool` representing success or failure. 

Open **ContactCard.swift**. Change the signature of all `set(:)` functions to return a `Bool`:

```swift
public func set(firstName: String, lastName: String) -> Bool {
  self.firstName = firstName
  self.lastName = lastName
  broadcastUpdates()
  return true
}

public func set(phone: String) -> Bool {
  phoneNumber = phone
  broadcastUpdates()
  return true
}

public func set(phone: Double) -> Bool {
  phoneNumber = "\(phone)"
  broadcastUpdates()
  return true
}
```

Now, return to `EmergencyContactCard`. Update the override of `set(phone:)` to return `false` if the length didn't meet the expectations:

```swift
public override func set(phone: String) -> Bool {
  guard phone.count == 3 else {
  return false
  }
  return super.set(phone: phone)
}
```

Now, test this by creating an instance. Open the main playground file. Add a new emergency contact.

```swift
let emergencyContact1 = EmergencyContactCard(emergencyName: "Cold Store Creamery", phoneNumber: "555")
```
Just a quick note. If you are a getting an error that states that the EmergencyContactCard could not be found in scope, you may need to restart your playground and/or rebuild the project. Next, create another one with an empty phone number.

```swift
let emergencyContact2 = EmergencyContactCard(emergencyName: "Rifftrax", phoneNumber: "")
```

Finally, print out the contact information.

```swift
print("emergency 1: \(emergencyContact1?.contactInformation() ?? "None")")
print("emergency 21: \(emergencyContact2?.contactInformation() ?? "None")")
```

Run the playground. The first contact prints, but the second one doesn't. The child class — `EmergencyContactCard` — delivers the requirements without performing any functionality that isn't specified by the base class. New requirements MUST be implemented. 

It's also important to know how to update the overall system to accommodate future additions. The first time you designed the base class, there were no requirements for data validations, so you didn't need to consider them. When validations became a requirement for a new child type, you made sure that the system also received the necessary updates to make sure everything fit together properly. 

If you implement that validation without modifying the system, you risk breaking consistency among the child types. Later on, a team member might add a feature to your system that fails to display the correct information to a user attempting to update their phone number. This could lead to confusion, as the user might assume the save operation was successful when it wasn't. The end result would be a bug causing the loss of the new emergency number.

## Instruction

In the last demo, you updated the setters in `ContactCard` to return a Boolean value representing the success or failure of the update operation. You did this because a new child type required a validation that could reject information, and the base type assumed that all data is saved.

Changing the app's functionality in a way that the base type doesn't expect goes against the Liskov Substitution principle. You refactored the contacts app so that it properly follows the principle, reducing the chance of creating unexpected behavior down the road.

Now, you'll learn about the next SOLID principle: **Interface Segregation**. The definition of Interface Segregation is:

_Clients should not be forced to depend upon interfaces they do not use._

When designing a protocol or interface that you'll use in different places in your code, it's best to break that protocol into multiple smaller pieces where each piece has a specific role. That way, clients depend only on the part of the protocol they need.

This principle focuses on the design of protocols. A protocol is a blueprint for a class that doesn't contain any implementations, only the method definitions. Any class or type conforming to this blueprint must implement all the methods in it.

To understand the principle, start by defining an example of a blueprint for the controls that can exist in a car. These controls could include:

- **Driving controls**: Steering, acceleration and brakes.
- **Navigation system controls**: Entering new addresses, choosing routes, etc.
- **Radio controls**: Setting the station and volume.
- **Climate controls**: Heating and air conditioner settings.

Imagine you're developing software for a vehicle controlled by AI. You have modules for AI controls, entertainment, weather control and navigation. Each of these modules must integrate with the car's system to function properly.

The blueprint for car controls includes methods for all four systems: AI controls, entertainment, weather control, and navigation. However, each system integrates with only its corresponding method and doesn't require access to or knowledge of the other methods. This is where the Interface Segregation principle comes into play.

In this example, you shouldn't have one protocol for the whole car; instead, you should have a protocol for each system. You should create four separate blueprints: one each for driving, navigation, radio and climate controls.

You might have a single class that implements all four blueprints, but your AI modules will interact with the car using only the relevant protocol type, remaining unaware of the other blueprint implementations. For example, the weather controls module will only see the methods defined in the climate controls protocol.

In the next demo, you'll break the definition of a large protocol into multiple smaller ones.

## Demo 2

In the last demo, you learned about the Liskov Substitution principle. In this demo, you'll put the Interface Segregation principle to work.

Open the starter playground. It already has an implementation for `CarProtocol` with a variety of methods. You'll also find a group of classes representing the AI modules that access your car. Each AI module has a reference to the car it'll control as a protocol type.

`AICarControlsModule` is the AI module responsible for controlling the car's driving capabilities. It needs the methods `accelerate()`, `brake()` and `steer()`. It doesn't need anything from the navigation or radio controls.

The first issue you'll have is that the controls module has access to other systems that it neither needs nor is responsible for. This could open room for bugs where someone from the team working on the controls module could accidentally access another system. Same for the other modules — they could access the driving controls of the car, causing some serious, life-threatening situations.

`CarProtocol` defines four sets of completely unrelated operations. It would be best to break down that protocol into smaller protocols, where each is responsible for one system only.

To implement this, completely delete `CarProtocol` and replace it with the following:

```swift
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
```

Next, update the `carReference` type in each AI module to match the corresponding protocol type:

```swift
class AICarControlsModule {
  var carReference: CarControlsProtocol! // updated
}

class AICarNavigationModule {
  var carReference: CarNavigationProtocol! // updated
}

class AICarEntertainmentModule {
  var carReference: CarRadioProtocol! // updated
}

class AICarWeatherModule {
  var carReference: CarACProtocol! // updated
}
```

Separating out the protocols like this has two main benefits:
1. Each module can now only access the system it needs.
2. You can define a car type that doesn't conform to either of those protocols, if needed. For example, some cars don't have their own navigation system; the driver needs to rely on their phone's navigation system to get around.

By following the SOLID principles here, you're able to give your overall system flexibility and focus.

## Instruction

In the last demo, you learned about the Interface Segregation principle. Now, it's time to learn about the final principle, **Dependency Inversion**, which is defined like this:

_Depend upon abstractions, not concretions._

Different parts of your code should not depend on concrete classes — they don't need that knowledge. Instead, rely on protocols to connect parts of your app.

Following this principle ensures that the different parts of your system are abstracted from each other, reducing coupling.

Using protocols to design functionality is just like designing the blueprints of a car before beginning production. Once you've defined all the different parts and how they connect on paper, you can build everything in parallel to save time. You can even implement upgrades by swapping one part with an enhanced version.

You might wonder why base classes aren't enough. Base classes are meant to include functionality, whereas protocols aren't. Protocols specify **what** the object should do — not **how** to do it.

When a module relies on another module's abstraction, it can't create an instance of that module directly because doing so would require knowledge of the concrete type. Therefore, modules with abstract dependencies expect to receive the instances they'll use for their operations.

To understand this better, you'll apply the Dependency Inversion principle to the example from the first demo.

## Demo 3

In this demo, you'll put the Dependency Inversion principle to work by applying it to the system you refactored in the first demo. I've moved the system initialzation underneath all the class initializations.

Open the starter playground to begin. It's exactly like the final state from demo 1 in the previous lesson.

You have a system that does a math operation, localizes the result, shows it on the UI, then logs the whole operation.

`LogManager` handles multiple tasks to ensure that the logs are properly organized. The system gets the singleton instance directly to perform the logging operation.

The first step to create an abstraction between the system and `LogManager` is to create a protocol for `LogManager`.

To do this, add this new protocol before the declaration of `LogManager`:

```swift
protocol LoggingProtocol {
  func addLogEntry(_ entry: String)
}
```

Then, change the declaration of `LogManager` to conform to the new protocol:

```swift
class LogManager: LoggingProtocol {
 ...
```

The class already includes the `addLogEntry(_ entry: String)` method. You reverse-engineered a protocol containing the single function that any class responsible for logging should implement. This allows for loggers that upload entries to a server, save them in a database, or write them to various types of files.

Now, you need to update your system to depend on the new abstraction.

Start by updating `System` by adding a new property and a new initializer:

```swift
class System {
  var activeView = SimulatedView()
  var logger: LoggingProtocol // new code

  init(logger: LoggingProtocol) { // new code
     self.logger = logger
  }
...
```

Now, in `doMainOperation(::)`, change the line of code that adds the log entry to the following:

```swift
logger.addLogEntry(logEntry)
```

You updated `System` to expect an instance that conforms to `LoggingProtocol`. The system doesn't care how this instance works, whether it's a singleton or not, how the instance is created or any details related to its construction. It only cares that you give it something it can use.

Finally, modify the last line in the playground — the one that creates a `System` instance — by passing it the `LogManager` singleton.

```swift
let system = System(logger: LogManager.singleton())
```

Build and run the playground. The printed message remains the same; nothing has changed in the functionality of the system. It's still using the very same instance.

But your changes have made a key difference — you can now create new log managers and use them in your system without changing a single line of code!

## Conclusion

In the last demo, you learned about the fifth SOLID principle, Dependency Inversion. You updated the calculator project from demo 1 to depend on an abstract logger rather than the concrete `LogManager`. You covered **a lot** of ground in this lesson.

SOLID principles are guidelines to help you plan for the future. You can implement them in different ways. They aren't instructions like design patterns, which are focused on solving a specific technical challenge.

Here are the things you learned in this lesson:

- Liskov Substitution principle is a guideline that says when you implement new child types, they must not perform operations that the base class doesn't expect. Child types can operate differently, but if the system and the base class expect specific operations like saving data, activating another module, or delivering output, the child types must adhere to those expectations.

- Interface Segregation principle is similar to the Single Responsibility principle, except that it is used to design interfaces (protocols). Methods defined in an interface should be related to one another. If you have methods that aren't relevant to the rest of the interface, it's best to separate them into their own interface.

- Dependency Inversion principle creates abstraction and decoupling between the different parts of the system. If one module requires a direct integration with another module to operate, then this integration should be done through interfaces and not via concrete types. This allows you to modify and control the different modules without affecting the rest of the system.

By using SOLID practices, you will create programs that are easier to read, easier to maintain and less likely to have bugs.
