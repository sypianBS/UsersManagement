# UsersManagement (TableWithDragAndDrop)

UIKit + Combine

iOS 15.0+ (due to the usage of UISheetPresentationController)

A hobby project exploring the UITableView. Author: sypianBS bensypianski@googlemail.com

Features:
- fetching users from a server (or locally if problems occur)
- showing users in sections (A-Z sorted)
- filtering
- adding to favorites and reordering them (manually through drag and drop or alphabetical sort nav bar button)
- creating new users

Improvements ideas:
- refactor to MVVM (since the MainListViewController is a bit full)
- storing data using Core Data or Realm (currently no persistency, everything is forgotten after the app restart)

![githubUserMgmtScreens](https://user-images.githubusercontent.com/99125193/161488498-c026aeee-c124-40cc-bbb3-518d3bc9be92.png)

