# 🚀 Nura Mobility – WebSocket Reliability Test (Flutter + GetX)

## 📌 Overview

This Flutter application demonstrates handling **unreliable WebSocket communication** using a hybrid approach:

* Sends **30 messages** (`ping 1 → ping 30`) via WebSocket
* Handles **dropped/missing responses**
* Recovers missing data using REST API (`/messages`)
* Ensures **final output is strictly ordered (monotonically increasing)**

---

## 🧠 Problem Understanding

The server:

* Maintains an internal `counter`
* May **not respond to every WebSocket message**
* Provides a `/messages` API to fetch the **complete message history**

### 🔥 Challenge

Ensure all counters from **1 → 30** are printed **in order**, even if:

* WebSocket drops messages
* Connection is unstable

---

## 🏗️ Architecture

```bash
lib/
├── data/
│   ├── api_service.dart
│   ├── web_socket_service.dart
│   └── model/
│       └── message_model.dart
│
├── controllers/
│   └── home_controller.dart
│
├── views/
│   └── home_view.dart
│
└── main.dart
```

---

## ⚙️ Tech Stack

* **Flutter**
* **GetX** (State Management)
* **WebSocket** 
* **HTTP** (`http` package)

---

## 🚀 Getting Started

### 🔹 1. Clone the Repository

```bash
git clone <your-repo-url>
cd <project-folder>
```

---

### 🔹 2. Install Dependencies

```bash
flutter pub get
```

---

### 🔹 3. Add Your Token

Update your token in:

```dart
api_service.dart
web_socket_service.dart
```

```dart
const String token = "YOUR_TOKEN_HERE";
```

---

### 🔹 4. Run the App

```bash
flutter run
```

---

### 🔹 5. Trigger the Flow

* Tap **"Send Messages"**
* Observe logs in console

---

## 🔄 Workflow

### 1️⃣ Reset Server

```http
POST /reset
```

---

### 2️⃣ Connect WebSocket

```
wss://interview.nuraemobility.co.in/ws?token=<token>
```

---

### 3️⃣ Send Messages

```
ping 1 → ping 30
```

---

### 4️⃣ Receive Responses

* Responses may be **missing or out-of-order**
* Stored in a buffer

---

### 5️⃣ Detect Missing Messages

Example:

```
Received: [1,2,4,5]
Missing: [3]
```

---

### 6️⃣ Recover via API

```http
GET /messages
```

* Fetch complete list
* Merge missing messages

---

### 7️⃣ Print Final Output

```
1 → 30 (strictly increasing)
```

---

## 🧪 Sample Console Logs

```
🔄 Resetting server...

🔌 WebSocket Connected

📤 Sending: ping 1
📤 Sending: ping 2
📤 Sending: ping 3

📥 WS Received: Counter 1
📥 WS Received: Counter 2
📥 WS Received: Counter 4

⚠️ Missing: [3]

🔄 Fetching from API...

📡 API Response:
[1,2,3,4,...,30]

✅ FINAL ORDERED OUTPUT:

Counter: 1
Counter: 2
Counter: 3
Counter: 4
...
Counter: 30
```

---

## ✅ Key Features

* ✔ Handles **unreliable WebSocket responses**
* ✔ Ensures **data consistency**
* ✔ Implements **buffer-based ordering**
* ✔ Uses **API fallback for recovery**
* ✔ Guarantees **monotonic counter output**
* ✔ Graceful handling of **connection drops**

---

## 🧠 Design Decisions

### 🔹 Why use buffer?

To store out-of-order messages before printing.

---

### 🔹 Why API fallback?

Because:

> WebSocket responses are not guaranteed

---

### 🔹 Why ordered printing?

To satisfy:

> "Output must be monotonically increasing"

---

## ⚠️ Edge Cases Handled

* WebSocket disconnects mid-process
* No messages received from WebSocket
* Partial responses
* Duplicate prevention
* Race conditions

---

## 💬 Final Thoughts

This solution demonstrates:

* Real-time communication handling
* Fault tolerance
* Clean architecture using GetX
* Production-like recovery strategy

---

