import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Defines the movement direction of the particles in the progress bar.
enum ParticleDirection {
  /// Particles move from bottom to top.
  vertical,

  /// Particles move from left to right.
  horizontal,
}

/// A premium, performance-optimized gradient progress bar with beautiful animated bubble particles.
///
/// Use [BubbleProgressBar] to create an interactive progress indicator that supports
/// custom gradients, particle effects, and different movement directions.
class BubbleProgressBar extends StatefulWidget {
  /// Creates a [BubbleProgressBar].
  ///
  /// The [value] must be between 0.0 and 1.0.
  const BubbleProgressBar({
    required this.value,
    this.height = 20,
    this.gradient,
    this.backgroundColor,
    this.bubbleDensity = 0.5,
    this.minBubbleDiameter = 4.0,
    this.maxBubbleDiameter = 10.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.bubbleWidget,
    this.borderRadius,
    this.direction = ParticleDirection.vertical,
    super.key,
  }) : assert(value >= 0 && value <= 1, 'Value must be between 0 and 1'),
       assert(bubbleDensity >= 0 && bubbleDensity <= 1, 'Bubble density must be between 0 and 1'),
       assert(minBubbleDiameter <= maxBubbleDiameter, 'Min diameter must be less than or equal to max diameter');

  /// The current progress value between 0.0 and 1.0.
  final double value;

  /// The height of the progress bar.
  final double height;

  /// The gradient to apply to the filled part of the progress bar.
  final Gradient? gradient;

  /// The background color of the unfilled part of the progress bar.
  final Color? backgroundColor;

  /// The density of the bubbles (0.0 to 1.0).
  ///
  /// A higher value means more bubbles will be generated.
  final double bubbleDensity;

  /// The minimum diameter of a bubble particle.
  final double minBubbleDiameter;

  /// The maximum diameter of a bubble particle.
  final double maxBubbleDiameter;

  /// The duration of the progress value transition animation.
  final Duration animationDuration;

  /// The curve to apply to the progress value transition animation.
  final Curve animationCurve;

  /// An optional custom widget to use as a bubble particle.
  ///
  /// If null, a default white circle is used.
  final Widget? bubbleWidget;

  /// The border radius of the progress bar.
  ///
  /// Defaults to `height / 2` (stadium shape).
  final BorderRadiusGeometry? borderRadius;

  /// The movement direction of the bubble particles.
  final ParticleDirection direction;

  @override
  State<BubbleProgressBar> createState() => _BubbleProgressBarState();
}

class _BubbleProgressBarState extends State<BubbleProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _bubbleController;
  final List<_Bubble> _bubbles = [];

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addListener(_updateBubbles)
      ..repeat();

    _initializeBubbles();
  }

  void _initializeBubbles() {
    _bubbles.clear();
    final bubbleCount = (widget.bubbleDensity * 50).round();
    for (var i = 0; i < bubbleCount; i++) {
      _bubbles.add(_createInitialBubble());
    }
  }

  _Bubble _createInitialBubble() {
    final bubble = _Bubble(x: 0, y: 0, radius: 0, speed: 0, opacity: 0);
    _resetBubble(bubble, initial: true);
    return bubble;
  }

  void _resetBubble(_Bubble bubble, {bool initial = false}) {
    final radiusRange = (widget.maxBubbleDiameter - widget.minBubbleDiameter) / 2;
    final minRadius = widget.minBubbleDiameter / 2;
    bubble.radius = minRadius + _random.nextDouble() * radiusRange;

    final baseSpeed = widget.direction == ParticleDirection.horizontal
        ? (0.002 + _random.nextDouble() * 0.005)
        : (0.01 + _random.nextDouble() * 0.03);

    bubble
      ..speed = baseSpeed
      ..opacity = 0.3 + _random.nextDouble() * 0.4;

    if (widget.direction == ParticleDirection.vertical) {
      bubble
        ..x = _random.nextDouble()
        ..y = initial ? _random.nextDouble() : 1.0 + _random.nextDouble();
    } else {
      bubble
        ..x = initial ? _random.nextDouble() : -0.2 - _random.nextDouble()
        ..y = _random.nextDouble();
    }
  }

  @override
  void didUpdateWidget(BubbleProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bubbleDensity != widget.bubbleDensity ||
        oldWidget.minBubbleDiameter != widget.minBubbleDiameter ||
        oldWidget.maxBubbleDiameter != widget.maxBubbleDiameter ||
        oldWidget.direction != widget.direction) {
      _initializeBubbles();
    }
  }

  @override
  void dispose() {
    _bubbleController
      ..removeListener(_updateBubbles)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(widget.height / 2);

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(color: widget.backgroundColor ?? Colors.grey[200], borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bubbleWidgets = List.generate(
              _bubbles.length,
              (index) => SizedBox.square(
                dimension: widget.maxBubbleDiameter,
                child:
                    widget.bubbleWidget ??
                    const DecoratedBox(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    ),
              ),
            );

            return TweenAnimationBuilder<double>(
              duration: widget.animationDuration,
              curve: widget.animationCurve,
              tween: Tween<double>(begin: 0, end: widget.value),
              builder: (context, animatedValue, child) {
                final filledWidth = constraints.maxWidth * animatedValue;
                return Stack(
                  children: [
                    // Progress Fill
                    SizedBox(
                      width: filledWidth,
                      height: widget.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.gradient == null ? Theme.of(context).primaryColor : null,
                          gradient: widget.gradient,
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                    // Bubbles
                    if (filledWidth > 0 && _bubbles.isNotEmpty)
                      Positioned.fill(
                        right: constraints.maxWidth - filledWidth,
                        child: ClipRRect(
                          clipper: _FilledPartClipper(filledWidth, borderRadius),
                          child: Flow(
                            delegate: _BubbleFlowDelegate(bubbles: _bubbles, controller: _bubbleController),
                            children: bubbleWidgets,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _updateBubbles() {
    for (final bubble in _bubbles) {
      if (widget.direction == ParticleDirection.vertical) {
        bubble.y -= bubble.speed;
        if (bubble.y < -0.2) {
          _resetBubble(bubble);
        }
      } else {
        bubble.x += bubble.speed;
        if (bubble.x > 1.2) {
          _resetBubble(bubble);
        }
      }
    }
  }
}

class _FilledPartClipper extends CustomClipper<RRect> {
  _FilledPartClipper(this.width, this.radius);
  final double width;
  final BorderRadiusGeometry radius;

  @override
  RRect getClip(Size size) {
    return radius.resolve(TextDirection.ltr).toRRect(Rect.fromLTWH(0, 0, width, size.height));
  }

  @override
  bool shouldReclip(covariant _FilledPartClipper oldClipper) {
    return oldClipper.width != width || oldClipper.radius != radius;
  }
}

class _BubbleFlowDelegate extends FlowDelegate {
  _BubbleFlowDelegate({required this.bubbles, required Listenable controller}) : super(repaint: controller);

  final List<_Bubble> bubbles;

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    for (var i = 0; i < bubbles.length; i++) {
      if (i >= context.childCount) break;
      final bubble = bubbles[i];
      final dx = bubble.x * size.width;
      final dy = bubble.y * size.height;

      final childSize = context.getChildSize(i) ?? Size.zero;
      if (childSize.isEmpty) continue;

      final scale = (bubble.radius * 2) / childSize.width;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(dx, dy, 0)..scaleByDouble(scale, scale, 1, 1),
        opacity: bubble.opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubbleFlowDelegate oldDelegate) {
    return false; // Repaint handled by the listenable controller
  }
}

class _Bubble {
  _Bubble({required this.x, required this.y, required this.radius, required this.speed, required this.opacity});
  double x;
  double y;
  double radius;
  double speed;
  double opacity;
}
