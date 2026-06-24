import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Deimos/theme/app_theme.dart';

class SIMono extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final double letterSpacing;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;

  const SIMono(
    this.text, {
    super.key,
    this.fontSize = 11,
    this.color,
    this.letterSpacing = 0,
    this.fontWeight = FontWeight.normal,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        color: color ?? AppTheme.text,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
      ),
    );
  }
}

class SIBigNum extends StatelessWidget {
  final String value;
  final String unit;
  final Color? color;

  const SIBigNum({
    super.key,
    required this.value,
    required this.unit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 52,
            fontWeight: FontWeight.w500,
            letterSpacing: -2,
            color: color ?? AppTheme.text,
          ),
        ),
        const SizedBox(width: 6),
        SIMono(
          unit,
          fontSize: 14,
          color: AppTheme.textDim,
        ),
      ],
    );
  }
}

class SIBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? right;

  const SIBar({
    super.key,
    required this.title,
    this.onBack,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_back, color: AppTheme.text, size: 20),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 8,
                height: 8,
                color: AppTheme.accent,
              ),
            ),
          Expanded(
            child: SIMono(
              title.toUpperCase(),
              fontSize: 11,
              letterSpacing: 2,
              color: AppTheme.textDim,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (right != null) right!,
        ],
      ),
    );
  }
}

class SITag extends StatelessWidget {
  final String text;
  final bool invert;
  final bool accent;

  const SITag({
    super.key,
    required this.text,
    this.invert = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = invert 
        ? AppTheme.onChip 
        : (accent ? AppTheme.accent : AppTheme.textDim);
    final bgColor = invert ? AppTheme.chip : Colors.transparent;
    final borderColor = accent ? AppTheme.accent : AppTheme.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SIMono(
            text.toUpperCase(),
            fontSize: 10,
            letterSpacing: 1.5,
            color: textColor,
          ),
        ],
      ),
    );
  }
}

class SIKV extends StatelessWidget {
  final String k;
  final String v;
  final bool mono;

  const SIKV({
    super.key,
    required this.k,
    required this.v,
    this.mono = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SIMono(
                k.toUpperCase(),
                fontSize: 11,
                letterSpacing: 1,
                color: AppTheme.textDim,
              ),
              const SizedBox(width: 8),
              if (mono)
                Flexible(
                  child: SIMono(v, fontSize: 13, color: AppTheme.text, overflow: TextOverflow.ellipsis),
                )
              else
                Flexible(
                  child: Text(
                    v,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.interTight(fontSize: 13, color: AppTheme.text),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              const dashWidth = 4.0;
              final dashCount = (constraints.maxWidth / (2 * dashWidth)).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  dashCount,
                  (_) => const SizedBox(
                    width: dashWidth,
                    height: 1,
                    child: DecoratedBox(decoration: BoxDecoration(color: AppTheme.border)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SISpark extends StatelessWidget {
  final List<double> points;
  final Color? color;
  final double width;
  final double height;

  const SISpark({
    super.key,
    required this.points,
    this.color,
    this.width = 80,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return SizedBox(width: width, height: height);
    return CustomPaint(
      size: Size(width, height),
      painter: _SparkPainter(
        points: points,
        color: color ?? AppTheme.accent,
      ),
    );
  }
}

class _SparkPainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const _SparkPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final min = points.reduce((a, b) => a < b ? a : b);
    final max = points.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs();

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final normalized = range > 0 ? (points[i] - min) / range : 0.5;
      final y = size.height - normalized * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparkPainter old) =>
      old.points != points || old.color != color;
}
