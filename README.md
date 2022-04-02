# UsersManagement

UIKit + Combine

iOS 15.0+ (due to the usage of UISheetPresentationController)

A hobby project exploring the UITableView. Author: sypianBS bensypianski@googlemail.com

Features:
- fetching users from a server (or locally if problems occur)
- showing users in sections (A-Z sorted)
- filtering
- adding to favorites
- reordering favorites
- creating new users

Improvements ideas:
- refactor to MVVM (since the MainListViewController is a bit full)
- storing data using Core Data or Realm (currently no persistency, everything is forgotten after the app restart)

![usersFavoritesSettings](https://user-images.githubusercontent.com/99125193/161397600-41e6d3d4-c154-465b-a3d4-b41557b28d9c.png)
