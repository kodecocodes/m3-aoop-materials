```metadata
number: "3"
title: "Lesson 3: Design Patterns"
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
  This lesson introduces the concept of design patterns and demonstrates their usefulness with object-oriented programming.
```

# Lesson 3: Design Patterns

## Introduction

**Design patterns** are a collection of well-known technical designs that address common technical problems. The software engineering community creates design patterns to solve common issues related to the creation, structure, behavior and architecture of your apps.

Many, if not all, of the challenges you'll face aren't unique; many developers have come across them before, and design patterns codify the solutions. Understanding those design patterns helps you avoid reinventing the wheel and equips you to take the right way forward.

Keep in mind, however, that it's important to consider design patterns carefully before you implement them. Just as misusing medication, or taking it when it's not necessary, can result in severe complications, applying design patterns carelessly can introduce significant issues.

In this lesson, you'll continue working on the contacts program. Your goal is to implement three design patterns:

1. Singleton
2. Factory
3. Observer

Now, it's time to get started!

## Instruction

In the previous lesson, you created `ContactsBook` with the static property, `current`, so the different modules of the program can all access the same list of contacts. However, nothing in your implementation prevents different teams and team members from using your code to create different instances from `ContactsBook`. This would cause the program to end up with multiple different contact lists.

Your first thought might be that it's their fault because they misused your code. You wouldn't be wrong thinking so, but it's always safer to secure your code against misuse. You need the class itself to enforce that it can never be instantiated more than once. To do this, you'll use the appropriately named **Singleton** pattern.

## Demo 1

In this demo, you'll get to know the first design pattern: the Singleton. Start by opening the starter playground. In the navigator, look in the **Sources** folder and open `ContactsBook.swift`.

You intended your team members to use the static property directly and never initialize a new instance. However, that's a big assumption. Instead, you'll enforce your intention in the implementation.

First, you'll make the initializer a private method so no one can access it:

```swift
private init() {
  self.contactsList = []
}
```

You don't want to expose the internal details about the static property, so you'll create a new method that replaces the constructor. This will be the method that's also responsible for returning the instance to be used. 

You'll construct the static property, if it has never been created before, then return it. To do so, add this new method right after the private constructor:

```swift
public class func singleton() -> ContactsBook {
  if current == nil {
    current = ContactsBook()
  }

  return current!
}
```

Update `current` to the following:

```swift
private static var current: ContactsBook?
```

This makes `ContactsBook` an **optional**, meaning it may or may not contain a value. 

You need just one more method to print out the contents of the contacts book. Add the following:

```swift
public func printContacts() {
  print("Contacts Book has \(contactsList.count) entries")
  contactsList.forEach { contact in
    print(contact.contactInformation(), separator: "\n")
  }
}
```

Return to the main playground. Delete all the code that used `ContactsBook` before, then add the following:

```swift
let book1 = ContactsBook.singleton()
let book2 = ContactsBook.singleton()
let book3 = ContactsBook.singleton()
let book4 = ContactsBook.singleton()

book1.saveContact(contact: ehabContact)
book2.saveContact(contact: timContact)
book3.saveContact(contact: kodeco)
book4.saveContact(contact: razeware)

... // Adding the relationships

book1.printContacts()
```

Here, you've created four different properties for the contacts book, each from `singleton()`. You then added a different contact to each instance.

Run the program. You'll see that calling `book1` printed all four contacts as if they were all added to it. The reality is that all four instances are actually the same instance. It's now impossible to create a second instance of `ContactsBook`.

## Instruction

In the previous demo, you implemented the Singleton pattern on `ContactsBook`. This prevents anyone from creating multiple instances of the contact book and ending up without a real source of truth for the list of contacts in the program.

Now, you'll move on to solving a different problem that's related to the method you're using to instantiate contacts. When you first started building the program, you had one class: `ContactCard`. But as your program expanded, you created two new types: **Person** and **Company**. This allowed you to hide some implementation details behind those types and their constructors.

The result was that the rest of the system became aware of two new types, even though it doesn't care about them, and they don't offer anything to the rest of the system. It's all a data modeling issue.

Fortunately, the **Factory** pattern is here to save the day. With a real factory, you don't know many manufacturing details about a product; that "construction" information is abstracted away from the consumer. The Factory pattern does the same for your program.

When you have many different types that all share a base type, the factory can take care of the construction differences and return all of them as instances of the base type. This makes the system completely unaware of the multiple child types you might have.

![Contacts Factory Diagram](Images/FactoryDiagram.png)

By utilizing dedicated methods to create the various contact types your system needs and delivering them all under the umbrella of the base class, `ContactCard`, your system accesses all necessary functions without any knowledge of the derived classes. You can add as many contact types as you need in the future, and that knowledge is "classified" so only the factory can access it.

The Factory pattern doesn't just hide child types — it hides the construction process as a whole. If creating and setting up each object requires multiple method calls and several operations, the factory will hide all that.

## Demo 2

In the last demo, you implemented the Singleton pattern on `ContactsBook`. In this demo, you'll implement the Factory pattern. Select the `Sources` folder. Click **File ▸ New File**, then name your new file `ContactsFactory`.

Next, add the following:

```swift
public class ContactsFactory {
}
```

The factory is responsible for creating the two contact types, so you need to create methods to build each one:

```swift
public class func createPersonContact(
  firstName: String,
  lastName: String,
  phone: String
) -> ContactCard {
  
}

public class func createCompanyContact(
  companyName: String,
  phone: String
) -> ContactCard {
  
}
```

Notice the new keyword in the method declaration: `class`. Just as you can access static properties directly from the class without creating an object, you can similarly access methods in the same way. Defining a method as a `class` lets you call it directly from `ContactsFactory.createPersonContact(:::)`.

Now, add the implementation in each function by calling the constructors of the child types:

```swift
public class func createPersonContact(
  firstName: String,
  lastName: String,
  phoneNumber: String
) -> ContactCard {
  PersonContactCard(firstName: firstName, lastName: lastName, phoneNumber: phone) // new code
}

public class func createCompanyContact(
  companyName: String,
  phoneNumber: String
) -> ContactCard {
  CompanyContactCard(companyName: companyName, phoneNumber: phone) // new code
}
```

Here, you're creating objects from `PersonContactCard` and `CompanyContactCard`, but you're returning them as `ContactCard`. 

Finally, go to the main playground file and replace the code where you create the different instances of the contact cards to use the new Factory methods:

```swift
let ehabContact = ContactsFactory.createPersonContact(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
let timContact = ContactsFactory.createPersonContact(firstName: "Tim", lastName: "Condon", phoneNumber: "0987654321")

...

let kodeco = ContactsFactory.createCompanyContact(companyName: "Kodeco", phoneNumber: "1111111111")
let razeware = ContactsFactory.createCompanyContact(companyName: "Razeware", phoneNumber: "2222222222")
```

When you call those methods from your playground, notice that Xcode shows their signature when they return an instance of `ContactCard`.

Run the program. Nothing else in your system needs to change.

With this example, Factory patterns might seem like more trouble than they're worth. However, you'll meet situations where creating an object isn't as simple as calling a single constructor. You may have many configurations to apply to the object, and you might need to perform multiple methods and steps before the object is ready to use. The Factory pattern is ideal for those situations.

## Instruction

In the last demo, you implemented the Factory pattern. You saw that you can use it to hide the implementation details of objects that share a base type. It abstracts the setup and construction processes that the objects need before you can use them in your system. It also hides their types; you'll receive them as instances of their base types.

The next and last pattern you'll learn in this lesson is the **Observer** pattern. It's an interesting pattern that's common, but not always obvious. Properly understanding this pattern can help you implement proper, simple and frequent UI updates.

Before going into the pattern's details, you'll need to understand the problem it solves.

Imagine that you have a bunch of modules that all share a common data source. That data source receives updates frequently, and the other modules need to react to the individual changes occurring in the data source. Additionally, the number of modules that will react to the changes varies.

One way to handle this is to set up a system where, whenever the source of the changes applies those changes to the data source, you also notify the other modules that the data has changed. But that can get very messy quickly.

Another way is to use the data source itself to notify those modules that changes have occurred. However, this implies the data source must recognize the modules to notify them, even as the modules are aware of the data source. This mutual recognition can become tangled. Without proper abstraction, it might disrupt your dependencies or make your implementation more complex.

The Observer pattern provides a common design that solves this problem. It gives you a specification to implement to allow different modules to make themselves known to data sources so they can receive updates on them. And when they're done, they remove themselves and stop receiving updates.

Think of it like a newsletter. The person creating the newsletter doesn't know who's on the mailing list; they just send their email to the list as a whole. Another system or person is responsible for maintaining the people present on that mailing list — the subscribers — and provides a mechanism that they can ask to stop receiving updates, or unsubscribe.

For your contacts program, you want the contacts book to receive an update whenever a contact gets updates. 

The Observer pattern has a two-part specification:

1. **The subject**: The entity that gets updated. In this case, it's the contact card.
2. **The observer**: The entity that wants to know about updates to the subject(s) it's interested in. In this case, the observer is the contacts book.

The observer is nothing more than a protocol or interface that defines a method that informs it when a subject has been updated. The subject defines four things.

First, it defines a 
1. A list of observers.
2. A method to add an observer to the list.
3. A method to remove an observer from the list.
4. A method to announce to all the observers that this subject has been updated.

## Demo 3

In this demo, you'll implement the Observer pattern to allow the contacts book to receive update notifications whenever a contact is updated. Ideally, in a system with a user interface, the contacts book will also notify the UI to update, so it will reflect changes to individual contacts.

To start, create two new Swift files under the **Sources** folder. Name the first: **Subject** and the second: **Observer.swift**. Now, open **subject.swift** and add the following:

```swift
public protocol Subject: AnyObject {
}
```

Next, open **Observer.swift** and add:

```swift
public protocol Observer: AnyObject {
}
```

Both of those protocols have constraints that need to be implemented on classes and not structs, mainly because they rely on references. Value types get copied when you assign them to different properties or add them to an array. Subjects need references to the observers, not copies of them.

Start with `Observer` because it's simpler:

```swift
public protocol Observer: AnyObject {
  func subjectUpdated(subject: any Subject)
}
```

`subjectUpdated(:)` is the method that each observer needs to implement to be notified when a subject receives an update. The affected subject is passed as a parameter. Without it, the observer won't know which entry was updated.

Next, open **Subject.swift**. Add the protocol specifications:

```swift
public protocol Subject: AnyObject {
  var observers: [Observer] { get set }
  func addObserver(_ obj: Observer) 
  func removeObserver(_ obj: Observer) 
  func broadcastUpdates() 
}
```

The protocol consists of four parts. First, it takes in an array of observers. Next, it has a method adds an observer. Then it defines a method that removes the observer. Finally, it defines a method sends a notification to all the registered observers on the list that the subject has been updated.

Since Swift supports having implementations directly in protocols, you can implement those functions to save yourself a lot of trouble whenever you want to conform to `Subject` in your code. 

To do so, add this code after the closing bracket of `Subject` (not inside it):

```swift
public extension Subject {
  func addObserver(_ obj: Observer) {
    observers.append(obj)
  }

  func removeObserver(_ obj: Observer) {
    observers.removeAll { item in
      item === obj
    }
  }

  func broadcastUpdates() {
    observers.forEach { observer in
      observer.subjectUpdated(subject: self)
    }
  }
}
```

Now, whenever you conform to `Subject`, you'll receive those implementations directly. However, you'll still need to define the `observers` array in your conforming type.

Go to **ContactCard.swift**. Change its declaration to conform to `Subject` and add an array of observers:

```Swift
public class ContactCard: Subject {
  public var observers: [Observer]
  ...
```

Remember to initialize the array in the main constructor.

```swift
public init(firstName: String, lastName: String, phoneNumber: String) {
  self.firstName = firstName
  self.lastName = lastName
  self.phoneNumber = phoneNumber
  isCompany = false
  contactID = UUID()
  relatedContacts = []
  observers = [] // new code
}
```

Next, go to **ContactsBook.swift** and make it conform to `Observer` in an extension by adding the following at the end of the file, after the final closing bracket:

```swift
extension ContactsBook: Observer {
  public func subjectUpdated(subject: Subject) {
    let index = contactsList.firstIndex { contact in
      contact === subject
    }

    guard let index else {
      return
    }
    print("Contact at index \(index) has been updated")
  }
}
```

Here, you made `ContactBook` conform to the protocol and implemented `subjectUpdated(:)`. The new function searches for the index of the provided subject (which is an instance of `ContactCard`) in the array of contacts. When it finds the index of the item, it prints out the index.

Go to your playground and apply any updates on the contacts you have:

```swift
ehabContact.set(phone: "333333333333")
ehabContact.set(phone: 44444444444)
timContact.set(firstName: "Nick", lastName: "Fury")
```

Before we run, comment out the current prints methods so we can have a clean console log.

```swift
//print(ehabContact.contactInformation())
//print(kodeco.contactInformation())
//print(razeware.contactInformation())

//book1.printContacts()
```

Open up **ContactsBook.swift** and do the same

```swift
//print("Contacts Book has \(contactsList.count) entries")
```

Make sure to leave the print statement you added in the extension.

Open up **PersonContactCard.swfit** and do the same.

```swift
// print("Calling super from Person")

//print("Other contact is a Person too. Add 2-way relationship")
```

Finally, do the same for **CompanyContactCard.swft**:

```swift
//print("Calling super from Company")

//print("Other contact is a company too. Adding 2-way relationship")
```

Run the program. Nothing is printed out to the console.

Well, that's expected. Your observer didn't subscribe to receive updates on any subject, so when you updated the subjects, they didn't know who to inform. The array `observers` is empty. You'll fix this next.

Open **ContactsBook.swift**. Add the following: 

```swift
public func saveContact(contact: ContactCard) {
  contactsList.append(contact)
  contact.addObserver(self) // new code
}
```

Now, whenever `ContactsBook` receives a new contact to save, it subscribes to the new contact so that it can receive updates on it.

Run the program again. Still, nothing prints!

Well... you updated some contact cards, but they didn't announce anything to the observers.

In **ContactCard.swift**, update all the methods that change the values or relationship to call `broadcastUpdates()` when they're done:

```swift
public func addRelatedContact(_ contact: ContactCard) {
  relatedContacts.append(contact.contactID)
  broadcastUpdates() // new code
}

public func set(firstName: String, lastName: String) {
  self.firstName = firstName
  self.lastName = lastName
  broadcastUpdates() // new code
}

public func set(phone: String) {
  phoneNumber = phone
  broadcastUpdates() // new code
}

public func set(phone: Double) {
  phoneNumber = "\(phone)"
  broadcastUpdates() // new code
}
```

Run the program. This time, you'll see print statements with the index of the contact in the book with each change. Congratulations!

## Conclusion

In the last demo, you learned about the Observer pattern. You updated `ContactCard` to be a subject and `ContactsBook` to be an observer. Whenever the book receives a new contact to save, it subscribes to it so it receives updates whenever any of the contact card's values change.

You updated `ContactCard` to announce it has been updated in each of the methods that change its values. You also updated `ContactsBook` to print the index of the card that has been updated.

Here are the things you learned in this lesson:

- **Design patterns** are solutions for common challenges related to software design. They're intended to be ready-to-go, optimized specifications for you to implement, saving you the effort of designing a solution.

- The **Singleton pattern** is a specification for objects that should be only instantiated once, then be commonly shared across the whole system. There should be no way to accidentally create other instances.

- The **Factory pattern** abstracts the implementation details and child types for the initialization of different objects that have a common usage. Each factory function takes care of the setup of the object and returns it as its base type, so your system doesn't know the underlying types you define. This simplifies your object creation process.

- The **Observer pattern** is a specification that lets different parts of the system receive updates when individual objects change — without creating tight coupling between those parts. This pattern is very useful for reflecting changes to the data in the user interface.

In the next lesson, you'll learn some principles that will guide you to write cleaner, clearer and more reusable code.