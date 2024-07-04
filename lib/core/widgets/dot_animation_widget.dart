import 'package:flutter/material.dart';

class DotAnimationWidget extends StatefulWidget {
  const DotAnimationWidget({super.key});

  @override
  _DotAnimationWidgetState createState() => _DotAnimationWidgetState();
}

class _DotAnimationWidgetState extends State<DotAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _dotAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _dotController,
          curve: Interval(
            index * 0.2,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return FadeTransition(
          opacity: _dotAnimations[index],
          child: const Text(
            '.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
