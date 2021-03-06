# iForage
![twitter cover3](https://user-images.githubusercontent.com/91622555/138967460-19904389-e1c0-4321-9369-7e5255024ea8.png)

---

### Table of Contents

- [Introduction](#Introduction)
- [Description](#Description)
- [Screenshots](#Screenshots)

---

# Introduction
### Problem Domain
- Limited apps assisting foragers track local foraging spots.
- Existing apps are old fashioned and do not have a modern design.

# Solution
- Create an app which helps foragers track and manage foraging spots around them, with a clean and easy to use interface.

# Existing Product
#### iNaturalist
<img src="https://user-images.githubusercontent.com/91622555/137644818-bec5c761-a3cd-425f-bc4d-a33dc415ce50.PNG" width="200" />

- iNaturalist allows users to create an account and mark on a map a plant/foraging spot they've discovered, allowing all users to visit and view the spot.

- I found through discussing Foraging Apps with a reddit forum that this can be problematic as it can provoke reckless individuals destroying greenland.

- Individuals on this forum also identified that they preferred a private account where they could mark a foraging spot on a map that only they can see.

- This would be beneficial as greenland doesn't get destroyed and the forager can keep track of all their foraging spots.
- In addition to this, the UI is not aestically pleasing, providing no useful information to the user besides a marker.


# Dependencies
- Firebase
- SDWebImageSwiftUI

# Description
- A simple foraging app, allowing users to track and manage their forraging spots.
- Project was made using SwiftUI
- MVVM Design Pattern
- Dark/Light Mode Feature
- Async/Await

# Screenshots
<img src="https://user-images.githubusercontent.com/91622555/138966668-f4e4c43e-d3b0-4b96-8ac6-f54eeb25fa24.gif" width="200" />.
<img src="https://user-images.githubusercontent.com/91622555/138966679-22e60e8c-8c41-448a-8584-28d7868c387a.gif" width="200" />.
<img src="https://user-images.githubusercontent.com/91622555/138967121-707be8f5-9a32-4d83-9903-01fa2d10d62b.gif" width="200" />
- The user can create posts which are linked with their current location or a location of their choosing.
- The post can be liked, edited and deleted completely from the database.
- The user can search for posts they've posted, with all actions the user performing occuring live, for example, if the user likes the post from the explore page, the like is visible on the post. Therefore, all actions are in real-time.

---

# Additional Features
- The user can share and rate the app from within the app.
- The user can delete their account.
- Focus states have been added for a better user experience, the user is moved to the next textfield automatically instead of manually pressing it.
- When creating a post, validation has been added to prevent the user from not filling out all textfields.

# Conclusion
In comparison to iNaturalist, the home page provides a user enriched experience, showing the user an image and name of the plant. Providing the user with a modern design which they would be more familiar with than a map pin.

[Back To The Top](#iForage)

[Check out on the app store](https://apps.apple.com/gb/app/iforage/id1592190038)
