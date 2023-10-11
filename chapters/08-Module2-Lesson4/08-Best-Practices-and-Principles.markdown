```metadata
number: "4"
title: "Lesson 4: Single Responsibility and Open-Closed Principles"
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
  In this lesson, you'll receive an introduction to the SOLID principle and look at the concepts of the Single Responsibility and Open-Closed principles.
```

# Lesson 4: Single Responsibility and Open-Closed Principles

## Introduction

In the last three lessons, you learned about aggregation and composition — two different approaches that go hand-in-hand to define your models and the different parts of a system. You then learned about base classes and different techniques related to inheritance that help you define operations in a cleaner way. In the third lesson, "Design Patterns", you learned about design patterns by looking at what they are and which software engineering challenges they solve.

In all three lessons, you took small steps to write cleaner code: Code that's easier to maintain, easy to understand by others and focuses on an operation.

In this lesson, you'll understand more about the criteria that will help you judge, on your own, if you need to refactor your code to simplify it. To do this, you'll focus on SOLID: A famous set of principles that will help you design your software to be easier to read and maintain from day one.

## Instruction

Imagine you're reading a novel. It has a deep story, rich events and well-written characters with deep personalities. However, the novel was written in one long block with no paragraphs, no punctuation and no line breaks. It's hard to understand where one sentence ends and another begins.

That sounds like a nightmare, right? As amazing as the story is, much of the novel's value is lost because the writing lacks structure.

Now, imagine writing software that's just as hard to understand. It could work perfectly with no bugs and an excellent user experience. However, when the code is jammed into a single file with limited methods and cryptic property or method names, it becomes hard to determine where an operation begins and what, specifically, it does. Extending such a codebase with more features is frustrating at best — and impossible at worst.

One situation where you might encounter overly complicated code is when a single piece of code is responsible for too many actions, complicating the generation of the final output.

For example, imagine a function that adds two numbers. It performs the addition, converts the value to a string, gets the localized presentation of this string, then styles the result by changing the colors and font. It passes the result to different layers of UI, opens a file on disk that contains all previously calculated math operations, counts the existing entries, creates a new file if the existing operation is more than 100, creates a new string with the addition operation with its result and timestamp, appends this new entry to the file and, finally, saves the file.

Wow, even just explaining all of this was a workout! I wouldn't be surprised if the code was hard to follow.

The above method has a very obvious problem: It's doing too many things. Some of its tasks are directly related to presenting the result on screen, while others are related to logging. The part that's directly related to presenting the result on screen can obviously use a cleanup, but you'll focus first on the part that wasn't part of the output: The part that opens a log file and checks if there are too many entries in that file before adding the operation to that file.

This operation can be described as a side effect. It's a change in the state of the system that isn't directly related to the intended output of the original operation. The user doesn't care about the log file! They only care about the output that appears on the screen. Any operation or changes of stored values or state of the system that isn't part of producing the output is a side effect.

Side effects aren't a bad thing, but if left unchecked and not properly organized, they can make your system overly complicated and harder to test.

When you implemented the observer pattern, you made the contacts book register itself as an observer to every contact. Additionally, if you modify any of the stored contacts, the contacts book that contains those entries will be automatically updated.

Both of those tasks are actually side effects. The first method's main focus is to save the contact in its list. Observing changes is not part of the main operation, and is, therefore, a side-effect.

Similarly, changing one of a contact's values is the main operation; notifying a list of observers that the contact has changed isn't related to the update operation. Thus, it's a side effect.

Side effects are not "bad". In the contacts example, the side effects are crucial to the system. The way you implement your code will determine how side effects work and how many of them you'll have. You can implement all UI updates on your app as side effects. As long as they're organized and consistent, your system will be easy to maintain.

Now that you understand what side effects in software engineering are, you can now learn the famous SOLID principle.

A little bit of history about those principles: In 2000, Robert Cecil Martin (known as Uncle Bob) first introduced the term SOLID in his paper "Design Principles and Design Patterns". The term is an acronym for five design principles that address the problem of software **rotting**: a metaphor for how a poorly structured codebase can deteriorate with time as it receives more features and its complexity increases.

The five SOLID principles are:

- S: Single Responsibility.
- O: Open-Closed principle.
- L: Liskov Substitution.
- I: Interface Segregation.
- D: Dependency Inversion.

Those principles are similar to design patterns because both concepts solve a problem. Don't think of them as medication but rather as vitamins that improve your system. Each of those guidelines can help shape your design in a way that can make it easier to extend in the future.

In this lesson and the next, you'll take a closer look at each of the SOLID principles.

## Instruction

The first SOLID principle is **Single Responsibility**. From its name, it's very straightforward:

_A class should have one, and only one, reason to change_.

Each class or type you define should have **only one** job to do. That doesn’t mean you can only implement one method, but each class needs to have a focused, specialized role.

Remember the example above of adding two numbers, showing the result on screen and writing that operation in a log? Here's how you'd properly specify those steps in a more organized way:

1. Perform the addition.
2. Convert the value to a string.
3. Get the localized presentation of this string.
4. Apply attributes like colors and font to the result.
5. Pass it to different layers of UI.
6. Open a file on disk that contains all previously calculated math operations.
7. Count the existing entries and create a new file if the existing operation is more than 100.
8. Create a new string with the addition operation and its result, the timestamp.
9. Append this new entry to the file.
10. Save the file.

If you implement one method to do the 10 steps above, this method will be very long and will do too many things. They're all related to the functionality you want to deliver, but you shouldn't blend them.

The first principle tells you not to mix unrelated things. So, for this example, you should create a group of different classes with different responsibilities and have the system put them together to deliver the requirements.

In the next demo, you'll refactor a system that does the above ten steps in one method to a more organized one that has different modules with focused responsibilities.

## Demo 1

Open the starter playground. You'll find the system method already implemented. It uses two types from the **sources** folder for demo purposes: `SimulatedFile` and `SimulatedView`. You won't need to make any changes to those two types. Build and run. It writes our log file.

Now, take a look at the system method:

```swift
class System {
  var currentFileNameNumber = 5
  var activeView = SimulatedView()
  func doMainOperation(num1: Int, num2: Int) {
    let sum = num1 + num2 // 1
    let stringSum = "\(sum)" // 2
    let formatter = NumberFormatter() // 3
    formatter.locale = Locale(identifier: "ar")
    let localizedSum = formatter.string(from: NSNumber(integerLiteral: sum))!
    let attributes: [NSAttributedString.Key : Any] = [ // 4
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    let styledString = NSAttributedString(string: localizedSum, attributes: attributes)
    activeView.labelText = localizedSum // 5
    let activeFileName = "logFile\(currentFileNameNumber).log" // 6
    var logFileHandler = SimulatedFile(fileName: activeFileName)
    logFileHandler.openFile()
    if logFileHandler.numberOfLines >= 100 { // 7
      currentFileNameNumber += 1
      let newActiveFileName = "logFile\(currentFileNameNumber).log"
      logFileHandler.closeFile()
      logFileHandler = SimulatedFile(fileName: activeFileName)
      logFileHandler.openFile()
    }
    let logEntry = "\(num1) + \(num2) = \(sum). Presented: \(localizedSum)" // 8
    logFileHandler.writeData(logEntry) // 9
    logFileHandler.closeFile() // 10
  }
}
```

You can see that it's not comfortable to read.

Looking at the code, you can identify this method's different responsibilities. The math operation. The String operations. Styling the string. And log management.

The system should be putting those capabilities together, not the method. So now, you'll start refactoring this large method to extract classes that each have a clear focus.

Start with the simplest — the math operation. Add this new class at the end of the playground:

```swift
class Calculator {
}
```

`Calculator`, in this system, performs only one operation: It adds two numbers. 

```Swift
class Calculator {
  class func add(num1: Int, num2: Int) -> Int { 
    num1 + num2
  }
}
```

Implement that function and use it in `doMainOperation`

```swift
func doMainOperation(num1: Int, num2: Int) {
  let sum = Calculator.add(num1: num1, num2: num2) 
  ...
```

Next, create `StringManager` to take care of the localization. Since the `Foundation` framework already handles the conversion from `Int` to `String` quite effectively through string interpolation, there's no need to transition to a class for this task.


```swift
class StringManager {
  class func toLocalizedValue(num: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ar")
    let localizedSum = formatter.string(from: NSNumber(integerLiteral: num))!
    print(localizedSum)
    return localizedSum
  }
}
```

This converts the number to a string in Arabic letters. Use the new method in your system:

```swift
func doMainOperation(num1: Int, num2: Int) {
  let sum = Calculator.add(num1: num1, num2: num2)
  let stringSum = "\(sum)" 
  let localizedSum = StringManager.toLocalizedValue(num: sum) // new code
```

The system's role in applying styling to the string is problematic, as this task is tied to the user interface. Ideally, the system should avoid incorporating any UI-specific code. Furthermore, views should remain passive, focusing solely on binding data to display elements.

To fix this, you need something between the system and the view to take care of this formatting and styling. Create the new class `ViewPresenter` to take care of the formatting and pass the new value to the view:

```swift
class ViewPresenter {
  class func showValueOnView(value: String, view: SimulatedView) {
    let attributes: [NSAttributedString.Key : Any] = [
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    let styledString = NSAttributedString(string: value, attributes: attributes)

    view.labelText = styledString
  }
}
```

Use the new method in your system and keep the line that creates the log entry:

```swift
func doMainOperation(num1: Int, num2: Int) {
  let sum = Calculator.add(num1: num1, num2: num2)
  let stringSum = "\(sum)"
  let localizedSum = StringManager.toLocalizedValue(num: sum)

  ViewPresenter.showValueOnView(value: localizedSum, view: activeView) // new code

  let logEntry = "\(num1) + \(num2) = \(sum). Presented: \(localizedSum)"
  ...
```

Now, the missing parts in your system are all related to logging. The system shouldn't know how the logging works, what the limit per file is, how logs are written, etc. Instead, the only thing it should know is that it needs to pass the entry to a logging manager that will take care of those details.

So your next step is to design that `LogManager`:

```Swift
class LogManager {
  public func addLogEntry(_ entry: String) {
  }
}
```

From the old system implementation, `LogManager` should be responsible for:
1. Handling log files.
2. Verifying the sizes of log files.
3. Writing log entries.

Also, wouldn't it be cleaner to have a singular manager for logs across your whole system as it grows? It makes sense to implement the `Singleton` pattern on `LogManager` right?

Here's how you do that:

```swift
class LogManager {
 private static var currentInstance: LogManager?

 private init() {
 }

 class func singleton() -> LogManager {
  if currentInstance == nil {
    currentInstance = .init()
  }
  return currentInstance!
  }
  ...
}
```
Now, for the complete implementation.

```swift
class LogManager {
  private static var currentInstance: LogManager?
  private static let maxLogSize = 100 // new code
  private var currentFileNameNumber = 5 
  private var logFileHandler: SimulatedFile! 

  private init() {
    let activeFileName = fileName(numbered: currentFileNameNumber) 
    logFileHandler = SimulatedFile(fileName: activeFileName) 
    logFileHandler.openFile() 
  }

  class func singleton() -> LogManager {
    if currentInstance == nil {
      currentInstance = .init()
    }
    return currentInstance!
  }

  public func addLogEntry(_ entry: String) {
    verifyLogSize() 
    print("\(entry) | Log entry saved.")
  }

  private func fileName(numbered: Int) -> String { // new code
    "logFile\(numbered).log"
  }

 private func verifyLogSize() { // new code
  if logFileHandler.numberOfLines >= LogManager.maxLogSize_const {
    currentFileNameNumber += 1
    logFileHandler.closeFile()
    let newFileName = fileName(numbered: currentFileNameNumber)
    logFileHandler = SimulatedFile(fileName: newFileName)
    logFileHandler.openFile()
    }
  }
}
```

At this point, the only thing your system knows — or needs to know — about `LogManager` is that it needs to call `LogManager.singleton().addLogEntry(logEntry)`. `LogManager` manages all the details about handling and validating the files.

To implement that, add the following line to the end of `doMainOperation(::)`:

```swift
func doMainOperation(num1: Int, num2: Int) {
  ...
  let logEntry = "\(num1) + \(num2) = \(sum). Presented: \(localizedSum)"
  LogManager.singleton().addLogEntry(logEntry) // new code
```

Build and run. Look at that. The playground values are all the same as before.

The updated `init()` ensures that the instance of `LogManager` is ready to be used right away. You've separated `fileName(:)` out into a new method. After all, since `verifyLogSize()` and `init()` create filename strings to access those files, you don't want to copy/paste code in different places. Finally, you moved the verification code into a separate method.

If you want to, you can break down `verifyLogSize()` even further, and even use a different implementation to achieve the same result. However, the principle remains the same. By following the Single Responsibility principle, you've made `doSomething()` more organized.

You now have a proper `LogManager` that you can use all across your different system operations. You can change the logging, localization and presentation of data on the screen in many ways without affecting the system itself. Your changes will be isolated and less risky.

Each class controls whatever side effects it has, and the system knows minimum information about each type. If one of them breaks, it'll be easy to identify what went wrong; fixing one element won't affect the others.

## Instruction

In the last demo, you implemented the first principle in SOLID, the Single Responsibility principle. You refactored the system by breaking it down into four specialized types, each with its own clearly defined focus, instead of having it juggle multiple operations.

Now, it's time to learn about the second SOLID principle: **Open-Closed**. Here's how it's defined:

_Software entities, including classes, modules and functions, should be open for extension but closed for modification._

This means you should be able to expand the capabilities of your types without having to alter them drastically to add what you need.

When you want to add new functionality to a system while keeping the existing functionality intact, you shouldn't be forced to change what already exists to introduce new capabilities. This might sound a bit more complicated than it is. It happens that you've already implemented this in lesson two, "Polishing OOP Concepts", for different reasons.

The Contacts app started by defining a single type for contacts, `ContactCard`. Later, you received the requirement to introduce Company contacts, which were different from normal contacts and had special requirements regarding creating connections. You defined a new type to hide the implementation details of how the two types of contacts differ and how exactly to manage adding related contacts.

In lesson three, "Design Patterns", you learned about the factory pattern, which is ideal for hiding the implementation details of the constructor. I'm sure that made you rethink the need for those child types and whether the base class on its own is enough.

With the current requirements of person and company contacts, things look fine. Some information in the constructor is enough to differentiate between each, such as a small `if` condition in the `addRelatedContact(:)`. But imagine if your next requirement is about adding public services, emergency contacts, public payphones and other types of contacts.

If you relied on a single type, you'd be in clear violation of the Open-Closed principle for a simple reason: To implement these new types of contacts, you'd have to add a significant amount of code to the existing `ContactCard` class, which is already stable, to make it compatible with the new types.

The one drawback with the current implementation of the base class is the `isCompany` property. To add new types, you'll still need to define new properties, update the implementations of `addRelatedContact(:)` to consider those properties, etc. This will create a mess.

However, there's a better way to implement this flexible growth while maintaining isolation between types.

In the next demo, you'll update the implementation of `ContactCard` and its subclasses to better follow the Open-Closed principle, making it easy to implement new card types when you need to.

## Demo 2

Open the starter playground. It's identical to the code you had at the end of lesson three, "Design Patterns".

In the current implementation of the cards, the flag `isCompany` is a Boolean variable. Its two possible values indicate whether the contact represents a company or an individual. The value of the flag determines how to handle the relationship between the contacts.

If you introduce different types, you can no longer rely on this flag. Adding more flags will make matters even worse — you'd need to go back to each existing type to accommodate each new flag. Adding new types will gradually become more and more expensive.

Clearly, you need a different approach. Instead of a Boolean flag, you'll configure each card type to express which card types it can include in its related contacts. When you call `addRelatedContact(:)`, it'll check if either contact can include the other, then create the connection if the configuration allows it.

Create a new Swift file under **Sources**. Name it **ContactOptions.swift**. Then, add this new structure inside it:

```swift
public struct ContactOptions: OptionSet {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int
}
```

`OptionSet` is a protocol that offers a unique kind of configuration. It's a set of values, and just like with any set, you can check whether it contains a certain value or not. By specifying that `rawValue` is of type `Int`, you can store the different set values in a single integer using its bits.

Add those static properties under `ContactOptions`:

```swift
static let unknown = ContactOptions(rawValue: 1 << 0) // binary = 0001
static let person = ContactOptions(rawValue: 1 << 1) // binary = 0010
static let company = ContactOptions(rawValue: 1 << 2) // binary = 0100
static let emergency = ContactOptions(rawValue: 1 << 3)// binary = 1000
static let publicPayPhone = ContactOptions(rawValue: 1 << 4) // binary = 10000
```

Next, open **ContactCard.swift**. Delete the declaration of `isCompany` and remove all of its references from the child types. Finally, add the following properties in `ContactCard`:

```swift
var canAdd: ContactOptions = []
var cardType: ContactOptions = .unknown
```

Next, you'll update `addRelatedContact(:)`. First, change the method signature:

```swift
public final func addRelatedContact(_ contact: ContactCard) {
```

The method is marked as `final` to prevent overrides because you don't want to allow the implementation to be changed in subtypes.

Next, open **CompanyContactCard.swift** and **PersonContactCard.swift**. Delete the overridden method.

Then, return to **ContactCard.swift** update `addRelatedContact` to the following:

```swift
public final func addRelatedContact(_ contact: ContactCard) {
  if canAdd.contains(contact.cardType) {
    print("Adding contact to related list.")
    relatedContacts.append(contact.contactID)
  } else {
    print("Can't Add")
  }
```

The first `if` condition checks if this contact's `canAdd` contains the value of `cardType` of the other contact.

For instances of `CompanyContactCard`, this set will contain `.person` and `.company`. So if `contact.cardType` (the other card) has either of those two values, the relationship will happen.

```swift
  if contact.canAdd.contains(cardType) {
    print("Adding inverse relation")
    contact.relatedContacts.append(self.contactID)
  } else {
    print("Can't Add Inverse")
  }
  broadcastUpdates()
}
```

The other `if` condition handles the inverse, when the other contact's `canAdd` set contains the type. When one contact is a Company and the other is a Person, `PersonContactCard` instances only list `.person`. So Company cards won't be added.

Now, you can properly set `canAdd` and `cardType` in `PersonContactCard` and `CompanyContactCard`. Open **PersonContactCard.swift**. Update the init to the following:


```swift
public override init(firstName: String, lastName: String, phoneNumber: String) {
  super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
  canAdd = [.person] // new code
  cardType = .person // new code
}
```

If you run into errors regarding the ContactOptions, just restart the playground. This should solve the issue. Then, go to `CompanyContactCard`. Update it to the following:

```swift
override init(firstName: String, lastName: String, phoneNumber: String) {
  super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
  canAdd = [.person, .company] // new code
  cardType = .company // new code
}
```

Build and run. The log messages are still the same. The relationship counts haven't changed.

When you add a new type, such as an `EmergencyContactCard`, you'll give the new type its own `cardType` and `canAdd` values. Whether you'll want the existing types to include this new card type in their related contacts or not will be a matter of adding a single value to the allowed list.

This approach treats the modifications more like configuration settings rather than actual code alterations. It gives you greater flexibility to extend the system with minimum changes — or even no changes at all, if there was no change to the existing types' requirements.

Using `OptionSet` is one way to create this configuration. You can rely on the class type directly using `type(of:)`, but if the different child types are in different frameworks, it will impact your dependency graph. You might end up having several `include` statements in your files that aren't ideal.

Using a new type to define configuration can solve that, but it'll also mean that for each new contact type you introduce, you'll need to add a new static value entry.

It's for you to decide which is the best approach for your system, but the rule is to keep things as isolated as possible to avoid having to make too many modifications when requirements change.

## Conclusion

In the last demo, you refactored `ContactCard` to have a configuration that defines which contacts are relevant to each other. 

In this lesson, you got an introduction to the SOLID principles. Specifically, you learned:

- Side effects from a method refer to changes in your system's stored values or state, which the method makes but are not directly tied to generating the output. Some examples include saving a log entry or updating the UI when you change a saved property. Side effects aren't necessarily a bad thing, but if you have too many side effects and start losing track of them, your system will do things you don't expect — and bugs will appear.

- SOLID is a group of five principles that help you design and build software in a more organized way, allowing you to easily receive updates and new features without adding complexity.

- The Single Responsibility principle states that each type should have a focus on one area. This means your system may end up with many types, but they'll all be easy to maintain.

- The Open-Closed principle defines that a system should be open for extension but closed for modification. When you need to add more features to a system while leaving the existing one intact, you shouldn't be forced to modify existing files to add new features. Instead, you should be able to create new child types to provide the new functionality and include them in your system with only minor changes to existing code.

In the next lesson, you'll learn about the other three SOLID principles: Liskov Substitution, Interface Segregation and Dependency Inversion.