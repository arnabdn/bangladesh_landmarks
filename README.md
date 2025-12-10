Here is a clean, polished **README.md** tailored for your project, matching your features, workflow, API usage, and overall app structure.

---

# 🇧🇩 Bangladesh Landmarks App

A Flutter application for creating, browsing, editing, and visualizing landmark records across Bangladesh using a remote REST API.
The app features interactive maps, custom division-based markers, list view management, and a modern UI theme.

---

## 🚀 Overview

Bangladesh Landmarks is a mobile application that lets users:

* Add new landmarks with **title, latitude, longitude, and an image**
* View all landmarks on an **interactive map**
* Browse all entries in a **scrollable list with swipe actions**
* Edit or delete any existing landmark
* Visualize landmarks with **custom markers based on geographic division**
* Switch between map, records list, and new entry using **bottom navigation**

All data is stored remotely through a RESTful API.

---

## 🧩 Features

### 🗺️ Map Overview

* Map centered on Bangladesh
* Shows all landmarks with **division-based custom markers**
* Tapping a marker opens a bottom sheet with:

  * Title
  * Image preview
  * Edit / Delete buttons

### 📋 Records List

* Scrollable, card-style list
* Each item includes:

  * Thumbnail image
  * Title
  * Coordinates
* Swipe left → **Edit**
* Swipe right → **Delete**

### ➕ Add / Edit Entry

* Title, latitude, longitude input fields
* Image picker with required validation
* Auto-fetch user location (optional future enhancement)
* Updates submitted through the same REST API


### 🔗 REST API Integration

Uses the backend at:

```
https://labs.anontech.info/cse489/t3/api.php
```

Supports:

| Action | HTTP Method | App Feature        |
| ------ | ----------- | ------------------ |
| Create | POST        | Add New Entry      |
| Read   | GET         | Records List + Map |
| Update | PUT         | Edit Entry         |
| Delete | DELETE      | Remove Entry       |

---

##  Project Structure

```
lib/
 ├── main.dart
 ├── services/
 │     └── api_service.dart
 ├── models/
 │     └── landmark.dart
 ├── screens/
 │     ├── overview_map.dart
 │     ├── records_list.dart
 │     └── new_entry.dart
 └── utils/
       └── divisions.dart
assets/
 └── markers/
       ├── dhaka.png
       ├── sylhet.png
       ├── rajshahi.png
       ├── ... etc
```

---

## 🛠️ Setup Instructions

### 1. Clone the repository

```sh
git clone https://github.com/arnabdn/bangladesh_landmarks.git
cd bangladesh_landmarks
```

### 2. Install dependencies

```sh
flutter pub get
```

### 3. Add required assets in `pubspec.yaml`

```yaml
assets:
  - assets/markers/
```

### 4. Run the app

```sh
flutter run
```

---

## 🧪 Git Workflow (Already Implemented)

* **main** → stable branch
* **feature branches** for each module:

  * `feature/api`
  * `feature/map-view`
  * `feature/edit-delete`
  * `feature/division-markers`
  * etc.
* **Pull Requests** used for merging feature branches
* Minimum **10 meaningful commits** with proper tags:

  * `feat: …`
  * `fix: …`
  * `refactor: …`
  * `chore: …`

---

## Known Limitations

* can't update picture for backend issues.
* API sometimes returns slow responses (server-side delay)
* No offline caching — requires active internet connection

---

Academic Integrity Statement

I, Arnab Debnath, confirm that all code and project structure were created by me.
I used ChatGPT to assist with debugging and implementation guidance, and Gemini AI to help generate custom marker designs, GIMP to further modify it, Neovim as text editor and GIT plue GITHUB for version control.
All AI-generated suggestions were manually reviewed, modified, and integrated by me.
I take full responsibility for the final content and implementation of this project.
