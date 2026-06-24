# Neon Tic-Tac-Toe with Minimax AI 🎮✨

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

A premium, highly-polished mobile **Tic-Tac-Toe** game developed with Flutter and Dart. It features an unbeatable **Artificial Intelligence (AI)** engine powered by the **Minimax Algorithm with Alpha-Beta Pruning**, alongside a local **2-Player** offline mode.

---

## 🌟 Key Features

*   **🤖 Advanced AI Opponent (Single Player)**
    *   **Minimax Algorithm**: Evaluates all game possibilities to make optimal decisions.
    *   **Alpha-Beta Pruning**: Drastically limits searched branches, maximizing performance and ensuring zero response latency.
    *   **Three Difficulty Levels**:
        *   🟢 **Easy (Kolay)**: Random moves for a relaxed play.
        *   🟡 **Medium (Orta)**: Depth-limited Minimax (depth limit = 2) offering a balanced, beatable challenge.
        *   🔴 **Hard (Zor)**: Unrestricted, full-depth search for mathematically flawless, unbeatable AI gameplay.
*   **👥 2-Player Local Mode**
    *   Play against your friends offline on the same device.
    *   Custom name input support for a personalized competitive experience.
*   **🎨 Premium Sci-Fi Visuals & Custom Painter**
    *   **Neon Glowing Win Lines**: Custom drawing logic using `CustomPainter` rendering layered glow and blur effects for winning combinations.
    *   **Glow UI Elements**: Modern neon gradient backgrounds and themed board layout.
    *   **Theme Switcher (Dark & Light Mode)**: Swiftly switch between a radiant dark sci-fi mode and a clean, colorful gradient blue light theme.
*   **🔊 Audio & Haptic Feedback**
    *   **Interactive Sound Effects**: Soft tap sounds powered by the `audioplayers` package.
    *   **Dynamic Vibrations**: Multiple rapid haptic feedbacks (`HapticFeedback.vibrate()`) triggered upon game-over events for immersive game feel.
*   **📊 Match History & Statistics**
    *   Persistent session scoreboards tracking Player 1, Player 2, and Draw scores.
    *   Match history log tracking dates, match outcomes, player details, and score history.
*   **📱 Responsive & Fluid Layout**
    *   Engineered with `LayoutBuilder`, `ConstrainedBox`, and `SingleChildScrollView` to dynamically adapt to various smartphone screens, tablets, and orientations.
    *   Smooth transitions between menus powered by `AnimatedSwitcher` and custom transition animations.

---

## 🛠️ Architecture & Folder Structure

The project follows a clean, single-screen-focused modular structure:

```text
lib/
├── main.dart            # App entry point initializing MaterialApp.
├── giris_ekrani.dart    # Main Menu, Mode/Difficulty selection, Settings, History, & transitions.
├── oyun_ekrani.dart     # Game Board, Tic-Tac-Toe state logic, Minimax algorithm, and Neon Painter.
├── zorluk.dart          # Difficulty configurations (Enums) and navigation states.
└── gecmis_oyun.dart     # Memory stores for game records and application configuration settings.
```

### 🧠 Minimax AI & Alpha-Beta Breakdown
The AI logic runs on a minimax decision model (found in `oyun_ekrani.dart`):

*   **Heuristic Scoring**: 
    *   AI (`O` - Maximizer) win: $+10 - \text{depth}$
    *   Human (`X` - Minimizer) win: $-10 + \text{depth}$
    *   Draw: $0$
    *(Depth subtraction/addition ensures the AI chooses the quickest path to victory and the longest defense against loss).*
*   **Pruning**:
    *   Uses `alpha` and `beta` thresholds. When a branch is guaranteed to yield a worse outcome than an already evaluated alternative, searching stops immediately, cutting down execution steps.

---

## 🚀 Getting Started

Follow these steps to run the project locally on your machine.

### Prerequisites
Make sure you have installed:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.11.0 or higher recommended)
*   [Dart SDK](https://dart.dev/get)
*   An Android/iOS Emulator or physical testing device.

### Installation

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/EAemir1/Neon_Tic-Tac-Toe_with_Minimax_AI
    cd Neon_Tic-Tac-Toe_with_Minimax_AI
    ```

2.  **Get Package Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    ```bash
    flutter run
    ```

---

## ⚙️ Dependencies

This application uses the following libraries and resources:

*   **[audioplayers](https://pub.dev/packages/audioplayers)**: Low-latency audio reproduction for UI sounds.
*   **HapticFeedback (Flutter SDK)**: Internal system haptic engine controls.
*   **Assets**:
    *   `assets/sounds/tap.mp3` - Audio clip for move indicators.
    *   `assets/icons/three-in-a-row.png` - Launcher/App representative icon.

---

## 📐 Gallery / Screenshots

<table align="center">
  <tr>
    <th align="center">🏠 Lobby / Menu</th>
    <th align="center">🎮 Mode Selection</th>
    <th align="center">⚡ Difficulty Selection</th>
  </tr>
  <tr>
    <td align="center" valign="top">
      <img width="200" height="400" alt="lobi" src="https://github.com/user-attachments/assets/8720b6df-e3ca-48f4-99f7-da791cf18669" />
    </td>
    <td align="center" valign="top">
      <img width="200" height="400" alt="modSecim" src="https://github.com/user-attachments/assets/86877653-0892-4a27-9dc2-b40588fdd1b1" />
    </td>
    <td align="center" valign="top">
      <img width="200" height="400" alt="zorluk" src="https://github.com/user-attachments/assets/9066debd-02fe-4205-89c0-2cbfe69ee301" />
    </td>
  </tr>
  <tr>
    <th align="center">🕹️ Game Board</th>
    <th align="center">⚙️ Settings</th>
    <th align="center">📜 Match History</th>
  </tr>
  <tr>
    <td align="center" valign="top">
      <img width="200" height="400" alt="oyunEkrani" src="https://github.com/user-attachments/assets/ff171869-cb2d-4579-b9e2-5b8c605ebfbf" />
    </td>
    <td align="center" valign="top">
      <img width="200" height="400" alt="ayarlar" src="https://github.com/user-attachments/assets/3ed7b058-8e3c-43c6-95b7-adfd7e22b7ab" />
    </td>
    <td align="center" valign="top">
      <img width="200" height="400" alt="gecmis" src="https://github.com/user-attachments/assets/dea3f44d-cc4b-4941-93cd-e29d5bdaa496" />
    </td>
  </tr>
</table>


---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

