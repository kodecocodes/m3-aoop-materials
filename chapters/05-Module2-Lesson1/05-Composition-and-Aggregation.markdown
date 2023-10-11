```metadata
number: "1"
title: "Lesson 1: Composition and Aggregation"
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
  In this lesson you'll learn about the difference between composition and aggregation and how they can be applied in object-oriented programming.
```

# Lesson 1: Composition and Aggregation

## Introduction

Object-oriented programming is a powerful concept that offers a large set of tools. But just like any tool, you need to learn how to use it properly. How you use the tools will influence the different directions you take when you build an app.

In this module, you'll learn about the guidelines and practices that help you choose the right direction to take when you are defining your models, designing your objects or trying to write code that will be easy to understand and maintain by other people.

In the first lesson, you'll learn how Composition and Aggregation differ when it comes to defining your data models and how they affect the rest of the app you're building. You'll also create the base data model for a basic contacts app, which you'll continue building throughout the rest of the module.

But before you get into the code, you need to understand what those words mean.

## Instruction

According to the Oxford Pocket Dictionary of Current English, `Composition` means "the nature of something's ingredients or constituents; the way in which a whole or mixture is made up". You can say a house is composed of walls and floors, or a letter is composed of words. The composing item is part of the whole, not separated from it.

But `Aggregation` means "the formation of a number of things into a cluster". It's a bunch of things grouped together to form something else — like a sports team is a group of players, or a company has employees. Each of the units can exist individually, but together they form the entity.

To help you understand it in software engineering terms: Composition means that the main object _owns_ the items that its composed from. If you delete the main object, all the items inside it get deleted. On the other hand, with Aggregation, when you delete the main object, the smaller ones can still exist.

For example, a text file is composed of characters. If you delete this text file, you'll delete all the characters that are contained within that file, but you don't lose the fonts you used in that text file. The file is indeed composed of characters, but it also references the fonts you have on your computer.

Using composition doesn't mean you can't use aggregation for something else or vice versa. They're meant to complement each other to help you define your objects in a meaningful way. With the example of the text file, both are used in different parts where it makes the most sense. 

It's also not a rule of thumb that once you define something by aggregation, you must always define it that way, even in different apps with different requirements. If the smaller object doesn't make sense on its own in one app, then you don't need to use aggregation in that app. The same goes for Composition.

For example, say your app defines companies and employees. It usually makes sense to use aggregation to define the employees in this company. They can move from one company to the other. But if your app doesn't deal with the employee as a separate entity, and just stores their work phone numbers, it would make sense to delete the employee information when you delete the company. In that case, you could use Composition.

The key point for you is to understand how your app will interact with different objects so you can define the relationships and ownership between them properly, without overcomplicating anything.

## Demo 1

You'll start by building the base for your contacts program. In this demo, I'm using an Xcode playground and writing in Swift. If you're following along, start up Xcode and select **File ▸ New ▸ File**. Choose **Playground**. Name it **Composition** and save it to your desktop.

The first thing you need to understand is the app's purpose and requirements.

Each contact carries basic information:
- First name
- Last name
- Phone number

So first, you'll define the Contact entity as follows:

```swift
struct ContactCard {
  var firstName: String
  var lastName: String
  var phoneNumber: String
}
```

Here, you defined a structure named `ContactCard` that contains three properties of type `String`. You defined the phone number as a string to avoid any issues related to having country codes or the `+` (plus) character, which you'll need in some phone numbers.

Next, create two contacts with the new type. Add the following code after the declaration of the structure in your playground file:

```swift
var ehabContact = ContactCard(firstName: "Ehab", lastName: "Amer", phoneNumber: "1234567890")
var timContact = ContactCard(firstName: "Tim", lastName: "Condon", phoneNumber: "0987654321")
```

Those two lines define different contacts with different information using the model you created.

So far, you've been using Composition to define your object. `ContactCard` is _composed_ of a string for the first name, a string for the last name and a string for the phone number.

The object _owns_ the data directly, and deleting any contact will delete all the information contained inside it.

The next requirement is to connect contacts to one another. Some contact book apps allow you to connect different contacts together with a relationship. For example, you can save the contacts of a whole family and specify the relationship status as brother, sister, father, mother, etc.

Your app should be able to connect contacts to one another. However, for simplicity, you won't define the nature of the relationship.

One way to think about this is by adding a new property for a list of related contacts inside the contact card:

```swift
struct ContactCard {
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [ContactCard] = []
}
```

Note that you give the array a default value of an empty array so you don't need to make any changes to the existing code defining `ehabContact` and `timContact`.

Then, add the following lines after the definition of the two contacts to create a relationship between them:

```swift
ehabContact.relatedContacts.append(timContact)
```

Now, you'll print out the contact.

```swift
print(ehabContact.relatedContacts)
```

Run the playground. You can see the Tim contact prints out to the console. So this works, but... it doesn't make sense?

## Instruction

In the last demo, you created a contact card type using only Composition. The type is composed of the information of the card and also other contacts. However, this approach doesn't make much sense.

![Composition Diagram](Images/Composition.jpg)

Your approach has two main issues:
1. The contacts database in your app is the main array of contacts plus the contacts inside each contact's `relatedContacts`.
2. By deleting one contact, you'll also completely delete all the related contacts from your database.

A simpler way to approach this is to use Aggregation and list all the contacts in an array. Contacts can have a link to other existing entries to create the relationship instead of containing the relative contact.

![Aggregation Diagram](Images/Aggregation.jpg)

This means that each contact is composed of three string values and an aggregation of other contacts to form the `relativeContacts`.

You need to specify a way to link contacts to each other instead of having one contain another. This is similar to how you can open a file from different locations without duplicating the file itself using shortcuts (on Windows) or aliases (on macOS).

## Demo

In the previous demo, you created a contact struct that used Composition. Now, you'll update the struct to use aggregation.

Open the playground in progress. First, add a field to represent an identifier for each contact. This identifier MUST be unique for each contact:

```swift
struct ContactCard {
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [ContactCard] = []
  let contactID = UUID() // new code
}

```

Notice that this value is a constant because identifiers should never change.

Next, change the type of `relatedContacts` to an array of `UUID`:

```swift
struct ContactCard {
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var relatedContacts: [UUID] = [] // new code
  let contactID = UUID() 
}
```

If you're familiar with value types and reference types, you can change `ContactCard`'s type from a structure to a class and use references directly. This will work the same and deliver the exact same result as the code above. However, you'll end up with a situation where you can't change to reference types. For the purpose of explaining the lesson, you need an obvious and explicit indirect reference to the related contacts.

File shortcuts work by linking to another unique file on the hard disk. In the same way, the `UUID` is the unique value for the contacts. You can create shortcuts to that contact using that value. So `relatedContacts` is now an array of shortcuts.

Change the lines where you added the relationship between the two contacts to use the new `contactID` property:

```swift
ehabContact.relatedContacts.append(timContact.contactID)
timContact.relatedContacts.append(ehabContact.contactID)
```

The relationship between two people almost always works in both directions. It doesn't make much sense to have one contact related to the other without the other being related back. So you want to make sure that both contacts have each other as part of their related contacts list.

There are a few drawbacks to this. For example, if someone else on your team is working with you on the app and creating contacts, they must go through two steps to properly implement the relationship. They might forget the second step, and they must also understand _how_ the relationship is done.

Also, If you decide to change how the identifiers work later, like the property name or its type, or even change your implementation to use reference types, they _will_ need to change their code. This is *not* a good object-oriented practice.

To avoid these problems, you'll abstract how this part works from the rest of your system. Add this new function inside the `ContactCard` type:

```swift
struct ContactCard {

  ...
  
  mutating func addRelatedContact(_ contact: inout ContactCard) {
    relatedContacts.append(contact.contactID)
    contact.relatedContacts.append(contactID)
  }
}
```

Now, replace the two lines that create the relationship between the two cards with this single line:

```swift
ehabContact.addRelatedContact(&timContact)
```

This way, the creation of the relationship doesn't expose any details about how it works, keeping your code secure from future updates. Security is what the next three lessons will focus on.

Now, to test this out. Add the following code:

```swift
let containsTim = ehabContact.relatedContacts.contains(timContact.contactID)
let containsEhab = timContact.relatedContacts.contains(ehabContact.contactID)
```

Here, you define two Boolean variables that check to see if Ehab contains the Tim contact and that the Tim contact contains Ehab. Now, print out the values:

```swift
print("Ehab contact contains Tim contact: \(containsTim)")
print("Tim contact contains Ehab contact: \(containsEhab)")
```

Execute the code. Both print out true. Great job. 

## Conclusion

In the last demo, you updated `ContactCard` to use aggregation for the related contacts and link them together using a unique identifier. You also moved the responsibility of creating the two-way relationship and the implementation details of how to create the relationship to a function inside the structure.

Here are the things you learned in this lesson:

- **Composition** and **Aggregation** are two different tools that help you define how the building blocks of your models or the parts of your system come together.
- They're meant to work together and complement each other. They are not mutually exclusive.
- Which one to use depends on what makes the most sense for your system. That choice might not necessarily make sense for another system.
- Composition means the object fully owns the composing parts. If you delete the main object from memory, all the parts used with Composition will also be deleted.
- Aggregation means the objects are separate from the main object but are linked to it. If you delete the main object, the other smaller objects can still live and function separately.

In the next lesson, you'll learn about classes and what it means for classes to have static members and static methods. These are advanced concepts in object-oriented programming that will improve how you build your apps, allowing you to deliver more functionality with less effort. 
