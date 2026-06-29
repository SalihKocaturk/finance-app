# Expense Tracker (finance-app) — App Overview

Repository: [github.com/SalihKocaturk/finance-app](https://github.com/SalihKocaturk/finance-app)

## What it is

This is a cross-platform personal/family **expense and income tracker** built with **Flutter** (Dart makes up ~81% of the codebase). The repo contains platform folders for **Android, iOS, Web, Windows, Linux, and macOS**, plus a `functions` folder, `firebase.json`, and `.firebaserc` — indicating the backend is **Firebase** (likely Firebase Auth for login and Cloud Functions / Firestore for data and shared-account features).

The in-app branding name is **"Expense Tracker"**, and the UI text in the screenshots is in **Turkish**, with a language switcher available in settings.

## Tech stack (inferred from repo structure)

- **Framework:** Flutter / Dart
- **Backend:** Firebase (Cloud Functions in `functions/`, project config in `.firebaserc` / `firebase.json`)
- **Platforms:** Android, iOS, Web, Windows, Linux, macOS (all included as build targets)
- **State/assets:** standard Flutter `lib/`, `assets/`, `pubspec.yaml` structure

## Core features (based on the screenshots)

### 1. Authentication
A clean login screen (email + password) with "Forgot Password?" and "Sign up" options. This confirms account-based, cloud-synced data rather than purely local storage.

### 2. Home Dashboard
Shows the current **balance** in a large gradient card, broken down into **Gelir** (Income) and **Gider** (Expense) totals. Below it, a **"İşlemler" (Transactions)** list shows recent entries (e.g., "Maaş" / Salary, 300.00 ₺).

### 3. Multi-currency support
Tapping the currency selector (top right) opens a picker with **TRY (₺), USD ($), and EUR (€)** — so the app isn't locked to a single currency.

### 4. Add Transactions
A dedicated "İşlemler" tab offers two quick-action cards: **"Gelir ekle" (Add income)** and **"Gider ekle" (Add expense)**, plus a "Son eklenenler" (Recently added) list.

### 5. Statistics
The "İstatistikler" tab provides:
- Summary counts of income vs. expense entries
- A **bar chart** ("Transactions") comparing Income (green) vs. Expense (red/orange) across days of the week
- A **donut chart** ("Kategoriler" / Categories) breaking down spending/income by category (e.g., Ulaşım/Transport, Hediye/Gift, Maaş/Salary) with percentages and amounts

### 6. Profile & Settings
- **Profile** screen with avatar, name, and email, linking to: Kullanıcı bilgileri (User info), Gizlilik politikası (Privacy policy), Şartlar ve koşullar (Terms & conditions), Ayarlar (Settings), Hesabı yönet (Manage account), and Çıkış yap (Log out, with a confirmation dialog).
- **Settings** lets users toggle **Dark theme** and choose the **app language** (Turkish shown, implying multi-language support).

### 7. Shared / Family Accounts
The **"Hesabı yönet" (Manage account)** screen is a standout feature: it shows member count and transaction count, and generates a **shareable invite code** (e.g., `799048`) so other people can join the same financial account. Each member is listed with their role (e.g., "Owner") and can be edited or removed. There's also a destructive "Hesabı kapat" (Close account) action. This suggests the app supports **shared budgets**, e.g., for couples, families, or roommates tracking finances together.

## Navigation structure

A persistent bottom navigation bar with four tabs:

1. **Ana sayfa** (Home) — balance overview & recent transactions
2. **İşlemler** (Transactions) — add income/expense, view recent entries
3. **İstatistikler** (Statistics) — charts and category breakdowns
4. **Ayarlar** (Settings, shown as Profile/Settings) — profile, app settings, account management

## Summary

In short, this is a **Firebase-backed, cross-platform Flutter expense tracker** with multi-currency support, category-based analytics (bar + donut charts), and a notable **shared-account/invite-code system** that lets multiple users collaborate on the same set of finances — going beyond a typical single-user budgeting app.

---

## Screenshots

### Home — Balance overview
![Home screen](Screenshot_20260629_154933.jpg)

### Home — Currency selector (TRY / USD / EUR)
![Currency selector](Screenshot_20260629_154942.jpg)

### Transactions — Add income / Add expense
![Transactions tab](Screenshot_20260629_155000.jpg)

### Statistics — Income/Expense chart & category breakdown
![Statistics tab](Screenshot_20260629_155038.jpg)

### Profile
![Profile screen](Screenshot_20260629_155044.jpg)

### Settings — Dark theme & language
![Settings screen](Screenshot_20260629_155051.jpg)

### Manage account — Shared account & invite code
![Manage account screen](Screenshot_20260629_155121.jpg)

### Profile — Logout confirmation
![Logout confirmation](Screenshot_20260629_155218.jpg)

### Login screen
![Login screen](Screenshot_20260629_155347.jpg)
