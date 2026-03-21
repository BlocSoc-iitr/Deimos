import 'package:flutter/material.dart';
import 'package:Deimos/theme/app_theme.dart';

class SmoothLoadingIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const SmoothLoadingIndicator({
    Key? key,
    this.size = 60,
    this.strokeWidth = 5,
    this.color = AppTheme.primary,
  }) : super(key: key);

  @override
  State<SmoothLoadingIndicator> createState() => _SmoothLoadingIndicatorState();
}

class _SmoothLoadingIndicatorState extends State<SmoothLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: RotationTransition(
            turns: _rotationController,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                backgroundColor: widget.color.withOpacity(0.1),
              ),
            ),
          ),
        );
      },
    );
  }
}

