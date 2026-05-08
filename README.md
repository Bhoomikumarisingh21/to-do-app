# Taskly ✅ — Flutter To-Do App

A beautiful, feature-rich To-Do app built with Flutter. Supports task priorities, categories, due dates, search, progress tracking, and persistent local storage.

---

## 📸 Features

- ✅ Add, edit, delete tasks with swipe-to-delete
- 🎯 Three priority levels: Low / Medium / High
- 📂 Custom categories with filter chips
- 📅 Due date picker with overdue alerts
- 🔍 Real-time search
- 📊 Progress stats header
- 💾 Persistent storage with SharedPreferences
- 🌗 Light & dark mode support
- ✨ Material 3 design

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── todo.dart                # Todo data model
├── providers/
│   └── todo_provider.dart       # State management (ChangeNotifier)
├── screens/
│   └── home_screen.dart         # Main screen
└── widgets/
    ├── todo_card.dart            # Individual task card
    ├── add_todo_sheet.dart       # Add/Edit bottom sheet
    ├── stats_header.dart         # Progress stats
    ├── category_chips.dart       # Category filter row
    └── search_bar_widget.dart    # Search input
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0 installed
- Android Studio / VS Code with Flutter plugin
- A device/emulator

### Installation

```bash
# 1. Clone or download the project
git clone https://github.com/YOUR_USERNAME/taskly.git
cd taskly

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.1 | State management |
| `shared_preferences` | ^2.2.2 | Local data persistence |
| `uuid` | ^4.3.3 | Unique task IDs |

---

## 🐙 How to Post to GitHub

Follow these steps to upload this project to your GitHub profile.

### Step 1: Create a GitHub Repository

1. Go to [github.com](https://github.com) and sign in
2. Click the **+** button (top right) → **New repository**
3. Fill in:
   - **Repository name**: `taskly` (or any name you like)
   - **Description**: `A beautiful Flutter To-Do app`
   - **Visibility**: Public ✅ (so others can see it)
   - ❌ Do NOT initialize with README (we already have one)
4. Click **Create repository**

---

### Step 2: Initialize Git in Your Project

Open a terminal inside your project folder and run:

```bash
git init
git add .
git commit -m "🚀 Initial commit: Taskly Flutter Todo App"
```

---

### Step 3: Connect and Push to GitHub

Copy the remote URL from your newly created GitHub repo, then run:

```bash
git remote add origin https://github.com/YOUR_USERNAME/taskly.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

---

### Step 4: Verify

Visit `https://github.com/YOUR_USERNAME/taskly` — you should see all your files live! 🎉

---

### 💡 Tips for a Great GitHub Profile

- Add a **screenshot** of the app to the README for visual appeal
- Use a descriptive commit message for each change
- Add **topics/tags** to your repo (flutter, dart, todo-app, mobile) via Settings → Topics
- Star your own repo if you're proud of it 😄

---

## 🛠 Future Improvements

- [ ] Notifications/reminders
- [ ] Cloud sync (Firebase)
- [ ] Recurring tasks
- [ ] Widgets for home screen

---

## 📄 License

MIT License — free to use and modify.
