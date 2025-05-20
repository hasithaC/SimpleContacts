# SimpleContacts
A simple iOS Contacts app built with Swift and UIKit. Supports creating, reading, updating, and deleting (CRUD) contact entries using Core Data for local storage.

## Features

- Display all previously stored contacts on app launch
- Create new contacts with name and phone number
- Edit existing contact details
- Delete contacts from the list
- Instantly reflect contact creation, update, or deletion on the main screen
- Input validation for contact name and phone number
- Real-time contact filtering using a search bar


## How to Use the App

- Launch the app
- Tap the "+" button to add a new contact
- Enter valid contact details (name and phone number)
- Tap "Save" to store the contact
- View the newly created contact on the main screen
- Use the search bar to filter contacts by name
- Tap a contact to edit its details
- Swipe left on a contact to delete it


## Assignment Scope Overview

| #   | Requirement             | Description                                                                                                                                                          |
|-----|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1   | UI with UITableView     | The main screen displays stored contacts (name and phone number) using a `UITableView`. Swipe-to-delete and tap-to-edit functionalities are implemented.           |
| 2   | Add New Contact         | A "+" icon is added to the navigation bar. Tapping it opens a modal with fields for name and phone number. Saving adds the contact and reflects it on the main screen. |
| 3   | Update Contact          | Tapping an existing contact opens the same form used for adding, but pre-filled with current details. Changes are saved and immediately reflected in the list.     |
| 4   | Delete Contact          | Contacts can be deleted by swiping left on a cell. The table view updates smoothly after a deletion.                                                               |
| 5   | Local Data Storage      | Core Data is used for persistent storage. All persistence-related logic is handled by a dedicated `DataPersistenceManager` class.                                     |
| 6   | Bonus Features          | - Validates empty names and phone number formats<br> - Implements a search bar to filter contacts<br> - Allows editing/deleting filtered contacts<br> - Follows MVVM architecture using `ContactFormViewController` as the reusable add/edit modal |
