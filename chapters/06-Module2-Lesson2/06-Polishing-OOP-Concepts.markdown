```metadata
number: "2"
title: "Lesson 2: Polishing OOP Concepts"
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
  This lessons explores some object-oriented concepts such as static members and methods as well as method overloading and method overridding.
```

# Lesson 2: Polishing OOP Concepts

## Introduction

In this lesson you'll dive deeper into Object Oriented Programming by learning about base classes and how they can ensure consistency and abstraction from the rest of the system. You'll also learn about static members and static methods; what their power is and their limitations. Finally, you'll learn about method overloading and method overriding and how they can solve what would appear to be a complex challenge, in almost no effort.

You'll continue working on the same `ContactCard` app you started on in the last lesson. I recommend that you use the starter playground with this lesson and not continue from the code of the last lesson. The Playground file is a little bit more organized and is using a separate Swift file to define `ContactCard` and the type is now a class type not a structure. Structs can't be used with inheritance which you'll be doing in this lesson.

## Instruction

The next requirement in your program is to add support for marking contacts as "Company". In contact book applications a company is a normal contact card but it creates some convenient functionality compared to how a person contact would appear, like have a single field for name instead of two.

In this demonstration, once a contact is marked as "company", the app should ignore the `lastName` field and completely rely on `firstName` for the name of the company. Also `relatedContacts` would be the list of employees working within that company, which in that case would be a one-way relationship where employees are added in the company contacts, but not the other way around. Also this list can contain the contacts of companies that do business with each other which then would be a two-way relationship and the contacts would be added for both companies.

![App Diagram](Images/AppDiagram.png)

## Demo 1

In this demo, your going to write some logic to determine whether a contact is a person or a company. The first thing to do is introduce the ability to mark a contact as a company. Open the starter Playground. It's been refactored into separate files. Expand the navigator by clicking the `Hide/Show` navigator button. Expand the `Sources` folder, then open the `ContactCard.swift` file. Add this new field to the `ContactCard` definition:

```swift
public class ContactCard {
  let contactID: UUID
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [UUID]
  public var isCompany: Bool // new code
  ...
```
This simply determines whether the contact is a company. Update the constructor to set the new property:

```swift
public init(firstName: String, lastName: String, phoneNumber: String) {
  self.firstName = firstName
  self.lastName = lastName
  self.phoneNumber = phoneNumber
  contactID = UUID()
  relatedContacts = []
  isCompany = false // new code
}
```
Return to the main playground file and create these two new companies:

```swift
let kodeco = ContactCard(firstName: "Kodeco", lastName: "", phoneNumber: "1111111111")
kodeco.isCompany = true

let razeware = ContactCard(firstName: "Razeware", lastName: "", phoneNumber: "1111111111")
razeware.isCompany = true

print(kodeco.contactInformation())
print(razeware.contactInformation())
```

Next, comment out the existing print statements to keep things clear

```swift
//print("Ehab contact contains Tim contact: \(containsTim)")
//print("Tim contact contains Ehab contact: \(containsEhab)")
```

Run the playground. You can see from the code that you defined a company contact exactly the same way as you define a person, except that you set `isCompany` to true right after the creation of the contact. 

The next step is to create the relation between the new companies and the contacts you created from the previous lesson. Add the following right after the last code and before the print statements:

```swift
kodeco.addRelatedContact(razeware)
kodeco.addRelatedContact(ehabContact)
```

Print out Ehab's contact information:

```swift
print(ehabContact.contactInformation())
```

Run the playground. Look at the number of connections. Both Kodeco and Ehab have two connections. This goes against the requirements! People are only allowed to have a two way relationship with other people but not companies. Yet Ehab has a connection to Tim, and Kodeco. Companies, on the other hand, can have a two way connection to other companies, but they keep a one way connection to people. This one way connection indicates a list of employees. 

To fix this, go to the implementation of `addRelatedContact(_:)`. Add a check for companies to skip the addition of the other direction relationship if the contact is a person:

```swift
public func addRelatedContact(_ contact: ContactCard) {
  relatedContacts.append(contact.contactID)

    if isCompany == true && contact.isCompany == true {
      print("Both this contact and the new contact are companies. Adding 2-way relationship")
      contact.relatedContacts.append(contactID)
    } else if isCompany == false && contact.isCompany == false {
      print("Both this contact and the new contact are people. Adding 2-way relationship")
      contact.relatedContacts.append(contactID)
    }
}
```

The updated method now properly meets the requirements, but you can make the code a little cleaner.

Notice that in the two conditions, it's either both properties are `true` or both properties are `false`. So why not just check if the two properties are equal? Change the implementation of the function to the following:

```swift
public func addRelatedContact(_ contact: ContactCard) {
  relatedContacts.append(contact.contactID)

  if isCompany == contact.isCompany {
    print("Both this contact and the new contact are the same type. Adding 2-way relationship")
    contact.relatedContacts.append(contactID)
  }
}
```

Run the playground. The code now meets the requirements. And top of that, the code is much cleaner. Or is it?

## Instruction

In the last demo, you updated `ContactCard` to support marking the contact as a company by setting the value of `isCompany` to true on the contact object after creating it. You also updated `addRelatedContact(_:)` to compare the values of `isCompany` between the two contacts and only apply the second relationship only if the two contacts are companies or people. You also cleaned up the implementation of that function right away as soon as you saw room for improvement.

Its always important to look at the code you are writing with a judgmental eye. There will be many occasions that you'll get the feeling of "This looks a little messy" and in many cases that feeling will be valid and there will be a way to clean it up a little.

But please note, you can always strive to make your code look cleaner, but just like everything "Perfect is the enemy of good". You must pay attention to what are you improving and why it falls short because otherwise you may end up _over engineering_ your system which can be much much worse than messy code.

Notice that the way you are marking a contact as a company is by performing a second step which is to set `isCompany` to `true`. This works but isn't ideal because you are exposing additional details of `ContactCard` to whoever is using it in your system to get the functionality of the "Company" support. Additionally, you have a small issue in the implementation of `addRelatedContact(_:)` where if you execute `ehabContact.addRelatedContact(kodeco)` it'll work and create a one-way relationship. This means you need to add additional logic in that function that only applies if the method is called on a person contact.

It would be cleaner to create a company contact in one step and separate the validation logic between a person contact and the company contact.

Inheritance in OOP is an excellent solution for challenges like this. 

When you look at the street, you can see so many different kinds of vehicles, there are busses, trains, cars, motorcycles, bicycles, ...etc. They are all means of transportation and move different number of people from one place to another. Moreover, each of those types of vehicles have different models that can group certain characteristics together. Then each individual car has differences to the others based milage, maintenance and any customization applied by the owner.

In code, you can create a class named `Vehicle` and have all the common information and methods/operations defined inside it. Even if the different vehicles actually perform those operations differently. So while a bike and a truck behave differently, both is a kind of vehicle that can move and stop.

To specify vehicle types such as a car, you can create a subclasses that _inherit_ from `Vehicle`. Hence, the `Train`, `Car`, and `Motorcycle` classes all inherit from the `Vehicle`. They also provide their own behavior.

While a `Train` class can move and stop, it can also announce the upcoming station. The `Car` can open its trunk and the `Motorcycle` can open its side stand. All three classes are different, yet all three are still vehicles.

![Class Diagram](Images/VehicleDiagram.png)

Additionally, cars are made by multiple manufacturers that affect how the vehicle behaves. To model this in code, you can create a subclass specific to the manufacturer's brand. In subclasses of the brand will inherit those traits.

![Class Diagram](Images/CarDiagram.png)

A car defined from an instance of `Volvo` will have all the properties and methods defined in `Car` and all the ones defined in `Vehicle`.

To match this approach with your program, You'll need to create the two new types `PersonContactCard` and `CompanyContactCard` where the customizations specific to their types will be implemented. Both of them inherit from `ContactCard` that will contain all the common functionality and properties they both have.

## Demo 2

In the last demo, you added support for marking a contact as a company contact by introducing a new property that must be set manually when the contact is created. In this demo, you'll use inheritance to hide this flag and set it automatically from the initializers of the new types.

Open your playground. You'll need to create two new files to represent two new classes. While many languages allow you to define multiple  classes in the same file, it is often preferred to keep your classes separate to make them easier to find and work with.

Expand the navigator and select the `Sources` director. Click `File / New / File` and create a file called `CompanyContactCard`. Do the same for `PersonContactCard`.

Open `CompanyContactCard.swift`. Create the new class definition for `CompanyContactCard`:

```swift
public class CompanyContactCard: ContactCard {
}
```

In `PersonContactCard.swift` create `PersonContactCard`:

```swift
public class PersonContactCard: ContactCard {
}
```

You'll start on the person contact first. Create a new initializer in `PersonContactCard` the overrides the original one in `ContactCard` and sets `isCompany` to `false`:

```swift
public override init(firstName: String, lastName: String, phoneNumber: String) {
  super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
  isCompany = false
}
```

By overriding, you are replacing the parent initializer with your own implementation. Note, you still call the parent initializer by the way of the super keyword. So when the initializer is run, the parent's class initializer runs all the code there first, and then returns to its initializer, and runs its code. 

We want to do the same with the `addRelatedContact` method. Override it to perform some default validation.

```swift
public override func addRelatedContact(_ contact: ContactCard) {
  if !contact.isCompany {
    print("Calling super from Person")
    super.addRelatedContact(contact)
    print("Other contact is a Person too. Adding 2-way relationship")
    contact.relatedContacts.append(contactID)
  }
}
```

The validation simply checks if the provided contact is a company then do nothing. A person contact can only link another person to it.

Open `CompanyContactCard.swift`. You're going to do the same. Override the initializer but this time set `isCompany` to true:

```swift
public override init(firstName: String, lastName: String, phoneNumber: String) {
  super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
  isCompany = true
}
```

Then override `addRelatedContact(_:)`:

```swift
public override func addRelatedContact(_ contact: ContactCard) {
  print("Calling super from Company")
  super.addRelatedContact(contact)
  if contact.isCompany {
    print("Other contact is a company too. Adding 2-way relationship")
    contact.relatedContacts.append(contactID)
  }
}
```

Both the overrides for `addRelatedContact(_:)` are calling `super.addRelatedContact(_:)`. As mentioned, this actually executes the implementation that is present inside `ContactCard`. This class is already doing a two-way relationship if both contacts are a company or are people. 

Open `ContactCard.swift`. Since you've created specific implementations of addRelatedContact, you can remove the code that checks for a company

```swift
public func addRelatedContact(_ contact: ContactCard) {
  relatedContacts.append(contact.contactID)
}
```

Finally, use the new types you created instead of using `ContactCard`. Open the main playground file. Change the definitions of all the contact objects you're creating to use the new types:

```swift
let ehabContact = PersonContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
let timContact = PersonContactCard(firstName: "Tim", lastName: "Contact", phoneNumber: "0987654321")

let kodeco = CompanyContactCard(firstName: "Kodeco", lastName: "", phoneNumber: "1111111111")
let razeware = CompanyContactCard(firstName: "Razeware", lastName: "", phoneNumber: "2222222222")
```

You won't need to change anything in the calls to `addRelatedContact(_:)` since each type is completely responsible for creating the relationship and applying the validations. Also, you no longer need to do anything about the `isCompany` flag, you even don't need to know about it. 

Open `ContactCard.swift`. Remove the public access modifier.

```swift
public init(firstName: String, lastName: String, phoneNumber: String) {
    ...
    isCompany = false
  }
```

There is one more small improvement you can apply. Company contacts don't use the last name field and the parameter `firstName` doesn't look very nice in the constructor. Why not improve the look of the constructor function for `CompanyContactCard`.

Open `CompanyContactCard.swft`. Update the constructor to the following:

```swift
public convenience init(companyName: String, phoneNumber: String) {
  self.init(firstName: companyName, lastName: "", phoneNumber: phoneNumber)
  isCompany = true
}
```

Then change the initialization of `kodeco` and `razeware` in the playground file:

```swift
let kodeco = CompanyContactCard(companyName: "Kodeco", phoneNumber: "1111111111")
let razeware = CompanyContactCard(companyName: "Other Company", phoneNumber: "2222222222")
```

Run the playground. You'll notice that the information and number of connections remain the same but the implementation looks a lot clearer.

This is good, but you can tidy it all up. Since you're cleaning the usage of your classes a little, creating setters for properties within classes is common. 

The main responsibility of setters is to perform an operation as values are being set. Setters can also provide validation or add additional functionality related to changing the value. They can also produce something known as side effects which you'll learn about soon enough.  That said, this program will build on top of the setters so we will include them now.

Open `ContactCard`. Create the setter for the first and last name properties:

```swift
public func set(firstName: String, lastName: String) {
  self.firstName = firstName
  self.lastName = lastName
}
```

We can change the name of the contact, passing in both the first and last. For instance, let's imagine Tim prefers to be called Timothy. Return to the playground file and add the following:

```swift
timContact.set(firstName: "Timothy", lastName: "Condon")
```

Now create a property for the  `PhoneNumber`. Open ContactCard and add the following:

```swift
public func set(phone: String) {
  phoneNumber = phone
}
```

You're expecting the phone number to be passed as a `String` which is absolutely correct, but why not have the ability to pass it as an `Double` and internally convert it to `String`? Add this additional setter:

```swift
public func set(phone: Double) {
  phoneNumber = "\(phone)"
}
```

Take a look at the three setter functions you added.

All three are named "set" and the last two are almost identical except for the different data type of its parameter. This is called method overloading.

You can create methods with the same name, but have different number of parameters or different parameter types. And whenever you call the method, the compiler will execute the version of the method that matches the parameters you passed. 

Return back to the main playground and set the phone numbers:

```swift
timContact.set(phone: "555-5555")
ehabContact.set(phone: 12345679.0)
```

And look at that - two phone numbers from two different types. A string for one and a double for the other.

This may look trivial but with more complex operations, this can do magic in making things easier for your team and the code readability. If you're lazy like me, its nice to remember less method names. :]

## Instruction

In the last demo, you created two new types representing a company contact and a person contact where both inherited from the base type for contact. You created overrides for initializer to apply the correct configuration for each and overrides for `addRelatedContact(_:)` so each can have its own logic and validations for adding related contacts.

You also created setters for the properties in the contact card. You used method overloading by creating setters that have the same method name only different number of parameters, or same number but different types.

The next and last piece of requirement for this lesson is to create the contact book object. So far all your contacts are created in the air and not stored anywhere. The app needs to have the contacts stored together somewhere and have some class responsible for saving the contacts in a file and loading from that file when the application starts.

For simplicity, you won't store them in a file. An array is just fine.

## Demo 3

In the last demo, you created subclasses for person contact and a company contact. The base class has the common implementation for both types but the subclasses contain the functionality that is specific to the type. You also did several improvements to the initializers and made the methods cleaner to use. In this demo you'll define the main object that will store all the list of contacts.

Create a new swift file under the sources folder named `ContactsBook.swift`. Define a new class named `ContactsBook` with a list of contacts inside it:

```swift
public class ContactsBook {
  public var contactsList: [ContactCard] = []

  public init() {}
}
```

Go to the main playground. Create a new ContactsBook. 

```swift
var contactsBook = ContactsBook()
```

Add the following contacts:

```swift
contactsBook.contactsList.append(ehabContact)
contactsBook.contactsList.append(timContact)
contactsBook.contactsList.append(kodeco)
contactsBook.contactsList.append(otherCompany)
```

Run the playground. Everything is correct.

There are two issues with this code. The first, there is nothing stopping anyone from clearing the whole list of contacts without you knowing about it. For instance, you could write this code:

```swift
contactsBook.contactsList.removeAll()
```

The best way is to change the access modifier of `contactsList` to private and create a function to add contacts to the list without anyone accessing the list directly. Open `ContactsBook.swift`. Add the following method:

```swift
public func saveContact(contact: ContactCard) {
  contactsList.append(contact)
}
```

And add the keyword `private` on the beginning of line where you declared the list:

```swift
private var contactsList: [ContactCard] = []
```

This, of course, breaks the calling code. Open the main playground file. Since you can no longer access the list, you need call the new method.

```swift 
contactsBook.saveContact(contact: ehabContact)
contactsBook.saveContact(contact: timContact)
contactsBook.saveContact(contact: kodeco)
contactsBook.saveContact(contact: razeware)
```

Nice - it's much better now. 

The second issue is if you have multiple places in your app where you need to access the book, you'll need to create a new instance of `ContactsBook` in each location. This means each instance will have its own list of contacts which isn't what you want. Every `ContactsBook` should be the same.

This is where the keyword `static` comes in. This keyword when preceding a property declaration, makes this property part of the class itself not the instance of the class. And since you have only one class with a unique name, then you'll have only one instance of that property.

Add this new property to `ContactsBook`:

```swift
public static var current = ContactsBook()
```

Now you can update the code in the main playground that adds the contacts to the book to the following:

```swift
// var contactsBook = ContactsBook() // You don't need this anymore

ContactsBook.current.saveContact(contact:ehabContact)
ContactsBook.current.saveContact(contact:timContact)
ContactsBook.current.saveContact(contact:kodeco)
ContactsBook.current.saveContact(contact:otherCompany)
```

The instance `ContactsBook.current` can be accessed from anywhere in your app. Its called a "shared" instance since the different parts of your app are sharing it. Some developers even prefer to name the variable "shared" for consistency.

Static properties can make things much easier and they can also make things messy because it makes everything able to access everyone. It must be used cautiously.

## Conclusion

In the last demo you learned about static properties and how you can share different properties across your app by making the property directly accessible by everyone.

Here are the things you learned in this lesson:

- You introduced the ability to mark a contact as a company contact. That made the usage of your type a little inconvenient so you updated your code by creating two new types, one for person and one for company and you made both of them inherited from the main type `ContactCard`. That made your code cleaner and you were able to implement the relationship validations in an organized way

- You used method overloading to create setters for the different properties with multiple functions that have the same name but different property numbers or same number but different type.

- And at the end you used `static` keyword to be able to create an instance of the `ContactsBook` to be a single source of truth for all the different parts of your app.

In the next lesson, you'll continue building on the `ContactsBook` and solve another issue where anyone can _still_ create their own instances of the book and ignore the instance that you meant to share.