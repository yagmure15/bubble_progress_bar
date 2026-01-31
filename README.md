# Bubble Progress Bar 🫧

A premium, highly customizable, and performance-optimized gradient progress bar with beautiful animated bubble particles for Flutter.

<p align="center">
  <video width="100%" controls autoplay loop muted>
    <source src="https://github.com/yagmure15/bubble_progress_bar/blob/main/example/assets/video/progress-bar.mp4?raw=true" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</p>

*Note: If the video doesn't play above, you can find it in the `example/assets/video` folder.*

## 🌟 Overview

**Bubble Progress Bar** is designed to give your app a modern and polished feel. Whether you're building a download manager, a file uploader, or an onboarding experience, this progress bar adds life to your UI with smooth bubble animations and vibrant gradients.

## ✨ Features

- **🌈 Gradient Support:** Easily apply custom gradients to your progress bar.
- **🫧 Particle System:** Optimized bubble particles that move vertically or horizontally.
- **🚀 Performance-First:** Built using `FlowDelegate` and object pooling to ensure 60+ FPS even with high particle density.
- **🎨 Highly Customizable:** Control everything from bubble density, diameters, and speed to progress curves and durations.
- **🧩 Custom Widgets:** Use any custom widget as a particle (e.g., icons, images, or SVGs).
- **📏 Responsive Layout:** Adapts perfectly to any parent container width.

## 🚀 Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  bubble_progress_bar:
    git:
      url: https://github.com/yagmure15/bubble_progress_bar.git
```

Import the package:

```dart
import 'package:bubble_progress_bar/bubble_progress_bar.dart';
```

## 📖 Usage

### Basic Usage

```dart
BubbleProgressBar(
  value: 0.7, // 70% progress
  height: 24,
  gradient: LinearGradient(
    colors: [Colors.blue, Colors.purple],
  ),
)
```

### Advanced Usage with Custom Particles

```dart
BubbleProgressBar(
  value: _downloadProgress,
  height: 30,
  bubbleDensity: 0.8,
  minBubbleDiameter: 5,
  maxBubbleDiameter: 12,
  direction: ParticleDirection.horizontal,
  gradient: LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
  ),
  bubbleWidget: Icon(
    Icons.star,
    color: Colors.white,
    size: 10,
  ),
  borderRadius: BorderRadius.circular(15),
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.easeOutBack,
)
```

## 🛠️ Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `double` | **Required** | Progress value between 0.0 and 1.0. |
| `height` | `double` | `20.0` | Total height of the progress bar. |
| `gradient` | `Gradient?` | `null` | Gradient for the filled part. |
| `backgroundColor` | `Color?` | `Colors.grey[200]` | Color of the unfilled track. |
| `bubbleDensity` | `double` | `0.5` | Density of particles (0.0 to 1.0). |
| `minBubbleDiameter`| `double` | `4.0` | Minimum size of the bubbles. |
| `maxBubbleDiameter`| `double` | `10.0` | Maximum size of the bubbles. |
| `direction` | `ParticleDirection`| `vertical` | Movement direction (`vertical` or `horizontal`). |
| `animationDuration`| `Duration` | `300ms` | Duration of the progress value transition. |
| `bubbleWidget` | `Widget?` | `null` | Custom widget to use as a particle. |
| `borderRadius` | `BorderRadius?`| `height / 2` | Corner radius of the bar. |

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request on [GitHub](https://github.com/yagmure15/bubble_progress_bar).

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
