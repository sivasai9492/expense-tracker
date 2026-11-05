# 💰 Expense Tracker App

A simple and user-friendly **Expense Tracker Application** developed using Flutter. It helps users record daily expenses, manage monthly budgets, monitor spending, and visualize their financial activities through charts.

## 📌 Project Overview

Managing daily expenses is important for maintaining financial discipline. This Expense Tracker application provides an easy way to track expenses, organize spending by categories, and monitor monthly budgets.

The application stores expense data locally, allowing users to access their records even after closing and reopening the app.

## ✨ Features

- **Add Expenses:** Record expenses with details such as title, amount, category, and date.
- **View Expenses:** View all recorded expenses.
- **Edit Expenses:** Update existing expense details.
- **Delete Expenses:** Remove unwanted expense records.
- **Expense Details:** View individual expense information.
- **Local Storage:** Save expense data using SharedPreferences.
- **Monthly Budget:** Set and update a monthly spending limit.
- **Budget Tracking:** View total spending, remaining budget, and budget progress.
- **Budget Alerts:** Receive warnings when spending reaches 80% of the budget or exceeds the limit.
- **Search Expenses:** Search for specific expenses.
- **Category Filter:** Filter expenses based on categories.
- **Sorting:** Sort expenses by newest or oldest.
- **Expense Summary:** View category-wise spending.
- **Pie Chart:** Visualize expenses by category.
- **Monthly Bar Chart:** Compare expenses across the last six calendar months.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Application development |
| Dart | Programming language |
| Provider | State management |
| SharedPreferences | Local data storage |
| fl_chart | Data visualization and charts |
| Android Studio | Emulator and Android development |
| Visual Studio Code | Code editor |
| Git | Version control |
| GitHub | Source code hosting |

## 📸 Application Screenshots

### 1. Home Screen
Displays total expenses and the main dashboard.

![Home Screen](screenshots/home_screen.png)

### 2. Monthly Budget
Displays monthly budget, spending, remaining balance, and budget progress.

![Monthly Budget](screenshots/monthly_budget.png)

### 3. Expense Summary
Displays category-wise expense analysis.

![Expense Summary](screenshots/expense_summary.png)

### 4. Monthly Expense Chart
Displays monthly expense comparisons using a bar chart.

![Monthly Chart](screenshots/monthly_chart.png)

## 📂 Project Structure

```text
expense_tracker/
│
├── android/
├── assets/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── screens/
│   └── widgets/
│
├── screenshots/
│   ├── home_screen.png
│   ├── monthly_budget.png
│   ├── expense_summary.png
│   └── monthly_chart.png
│
├── test/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

*Note: The structure above shows the main project folders. Individual files may vary.*

## 🚀 How to Run the Project

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android Emulator or Android Device

### Installation Steps

**Step 1: Clone the repository**

```bash
git clone https://github.com/sivasai9492/expense-tracker.git
```

**Step 2: Navigate to the project folder**

```bash
cd expense-tracker
```

**Step 3: Install dependencies**

```bash
flutter pub get
```

**Step 4: Run the application**

```bash
flutter run
```

## 🧪 Testing

The project includes tests for expense analytics and application functionality.

Run the following command:

```bash
flutter test
```

To check the project for code issues:

```bash
flutter analyze
```

## 💾 Data Storage

The application uses **SharedPreferences** for local data storage.

It helps preserve expense records and monthly budget information even after the application is closed or restarted.

## 📊 Expense Analytics

The application provides visual insights into spending through:

- Category-wise expense distribution.
- Monthly expense comparison.
- Total monthly spending.
- Remaining monthly budget.
- Budget utilization percentage.

## 🎯 Project Objectives

- Develop a simple expense management application.
- Help users monitor their daily spending.
- Encourage better financial planning.
- Provide monthly budget tracking.
- Visualize spending patterns using charts.
- Demonstrate Flutter application development and state management.

## 👥 Team Members & Contributions

### 1. S. Siva Sai
**Role: Project Owner & Lead Developer**

- Project planning and architecture.
- Flutter application development.
- Provider state management.
- Expense management functionality.
- Monthly budget implementation.
- Local storage integration.
- GitHub repository management.
- Final integration and bug fixing.

### 2. T. Naresh
**Role: Testing & Feature Development**

- Testing Add, Edit and Delete Expense functionality.
- Identifying and fixing application bugs.
- Testing monthly budget calculations.
- Verifying local data persistence.
- Developing and improving application functionality.
- Preparing test cases and documentation.

### 3. V. Prasanth
**Role: UI Development & Analytics**

- Designing and improving application screens.
- Working on expense summary functionality.
- Supporting category-wise expense analysis.
- Improving charts and data visualization.
- Testing user interface responsiveness.
- Contributing to application development and debugging.

### Team Collaboration

All three team members contribute to project development, testing, debugging, documentation, and final project demonstration.
## 🔮 Future Enhancements

- Dark mode support.
- Export expense reports to PDF or Excel.
- Income tracking.
- Savings goal management.
- Cloud backup and synchronization.

## 📄 License

This project is developed for educational and academic purposes.

---

**Developed using Flutter **



## Project Setup and Documentation

Proper project documentation helps developers understand, install, configure, and run the SpendTrack application.

### 1. Development Environment

The following tools are required:

- Flutter SDK for application development.
- Dart programming language.
- Android Studio or Android SDK.
- Visual Studio Code or another compatible IDE.
- Git and GitHub for version control.

### 2. Project Installation

Clone the project repository:

```bash
git clone https://github.com/aswindatha3186/SpendTrack.git
cd SpendTrack
```

Install the required dependencies:

```bash
flutter pub get
```

### 3. Running the Application

Connect an Android device or start an emulator, then execute:

```bash
flutter run
```

### 4. Project Structure

The application follows an organized Flutter project structure:

- `lib/` – Application source code.
- `lib/models/` – Data models.
- `lib/providers/` – Application state management.
- `lib/services/` – Local storage and supporting services.
- `lib/screens/` – Application screens.
- `lib/widgets/` – Reusable UI components.
- `test/` – Automated test files.
- `android/` – Android-specific configuration.

### 5. Documentation Contribution

- Prepared project installation and execution instructions.
- Documented development environment requirements.
- Explained the project directory structure.
- Provided commands for dependency installation and application execution.
- Improved repository documentation for future developers.

### 6. Contribution Summary

This contribution focuses on making SpendTrack easier to understand, install, and run by providing clear project setup instructions and organized technical documentation.
